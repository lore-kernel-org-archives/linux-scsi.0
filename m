From: James Bottomley <James.Bottomley@steeleye.com>
Subject: specimen generic block TCQ implementation in 53c700 driver (3/3)
Date: Mon, 10 Jun 2002 23:10:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200206110310.g5B3Aqs07175@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed ;
	boundary="==_Exmh_2152075980"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id UAA07387
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jun 2002 20:10:56 -0700
Received: from localhost.localdomain (sshppp-200.mtv1.steeleye.com [172.16.1.200])
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) with ESMTP id UAA07249
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jun 2002 20:10:53 -0700
Received: from mulgrave (jejb@localhost)
	by localhost.localdomain (8.11.6/linuxconf) with ESMTP id g5B3Aqs07175
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jun 2002 23:10:52 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multipart MIME message.

--==_Exmh_2152075980
Content-Type: text/plain; charset=us-ascii

This completes the generic TCQ code by providing a sample implementation.  I'm 
afraid very few people actually have a 53c700 based system, but it's the one 
my servers use for my SCSI root devices (and it's also the driver I understand 
the best), so it's the one I chose to try.

The patch removes the TCQ code from the driver and uses the generic functions 
instead.  It's pretty crude, but designed to prototype the feasibility of the 
idea.

The patch applies to version 2.8 of the 53c700 driver.

James Bottomley


--==_Exmh_2152075980
Content-Type: text/plain ; name="53c700-blk-tag-2.5.21.diff"; charset=us-ascii
Content-Description: 53c700-blk-tag-2.5.21.diff
Content-Disposition: attachment; filename="53c700-blk-tag-2.5.21.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.587   -> 1.588  
#	drivers/scsi/53c700.h	1.4     -> 1.5    
#	drivers/scsi/53c700.c	1.9     -> 1.10   
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 02/06/10	jejb@mulgrave.(none)	1.588
# [SCSI 53c700] add specimen block layer tcq
# --------------------------------------------
#
diff -Nru a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
--- a/drivers/scsi/53c700.c	Mon Jun 10 23:10:02 2002
+++ b/drivers/scsi/53c700.c	Mon Jun 10 23:10:02 2002
@@ -284,6 +284,7 @@
 	tpnt->cmd_per_lun = NCR_700_MAX_TAGS;
 	tpnt->use_clustering = DISABLE_CLUSTERING;
 	tpnt->proc_info = NCR_700_proc_directory_info;
+	tpnt->use_blk_tcq = 1;
 	
 	if(tpnt->name == NULL)
 		tpnt->name = "53c700";
@@ -499,46 +500,12 @@
 free_slot(struct NCR_700_command_slot *slot,
 	  struct NCR_700_Host_Parameters *hostdata)
 {
-	int hash;
-	struct NCR_700_command_slot **forw, **back;
-
-
 	if((slot->state & NCR_700_SLOT_MASK) != NCR_700_SLOT_MAGIC) {
 		printk(KERN_ERR "53c700: SLOT %p is not MAGIC!!!\n", slot);
 	}
 	if(slot->state == NCR_700_SLOT_FREE) {
 		printk(KERN_ERR "53c700: SLOT %p is FREE!!!\n", slot);
 	}
-	/* remove from queues */
-	if(slot->tag != NCR_700_NO_TAG) {
-		hash = hash_ITLQ(slot->cmnd->target, slot->cmnd->lun,
-				 slot->tag);
-		if(slot->ITLQ_forw == NULL)
-			back = &hostdata->ITLQ_Hash_back[hash];
-		else
-			back = &slot->ITLQ_forw->ITLQ_back;
-
-		if(slot->ITLQ_back == NULL)
-			forw = &hostdata->ITLQ_Hash_forw[hash];
-		else
-			forw = &slot->ITLQ_back->ITLQ_forw;
-
-		*forw = slot->ITLQ_forw;
-		*back = slot->ITLQ_back;
-	}
-	hash = hash_ITL(slot->cmnd->target, slot->cmnd->lun);
-	if(slot->ITL_forw == NULL)
-		back = &hostdata->ITL_Hash_back[hash];
-	else
-		back = &slot->ITL_forw->ITL_back;
-	
-	if(slot->ITL_back == NULL)
-		forw = &hostdata->ITL_Hash_forw[hash];
-	else
-		forw = &slot->ITL_back->ITL_forw;
-	
-	*forw = slot->ITL_forw;
-	*back = slot->ITL_back;
 	
 	slot->resume_offset = 0;
 	slot->cmnd = NULL;
@@ -566,48 +533,6 @@
 	hostdata->cmd = NULL;
 }
 
-/* Most likely nexus is the oldest in each case */
-STATIC inline struct NCR_700_command_slot *
-find_ITL_Nexus(struct NCR_700_Host_Parameters *hostdata, __u8 pun, __u8 lun)
-{
-	int hash = hash_ITL(pun, lun);
-	struct NCR_700_command_slot *slot = hostdata->ITL_Hash_back[hash];
-	while(slot != NULL && !(slot->cmnd->target == pun &&
-				slot->cmnd->lun == lun))
-		slot = slot->ITL_back;
-	return slot;
-}
-
-STATIC inline struct NCR_700_command_slot *
-find_ITLQ_Nexus(struct NCR_700_Host_Parameters *hostdata, __u8 pun,
-		__u8 lun, __u8 tag)
-{
-	int hash = hash_ITLQ(pun, lun, tag);
-	struct NCR_700_command_slot *slot = hostdata->ITLQ_Hash_back[hash];
-
-	while(slot != NULL && !(slot->cmnd->target == pun 
-	      && slot->cmnd->lun == lun && slot->tag == tag))
-		slot = slot->ITLQ_back;
-
-#ifdef NCR_700_TAG_DEBUG
-	if(slot != NULL) {
-		struct NCR_700_command_slot *n = slot->ITLQ_back;
-		while(n != NULL && n->cmnd->target != pun
-		      && n->cmnd->lun != lun && n->tag != tag)
-			n = n->ITLQ_back;
-
-		if(n != NULL && n->cmnd->target == pun && n->cmnd->lun == lun
-		   && n->tag == tag) {
-			printk(KERN_WARNING "53c700: WARNING: DUPLICATE tag %d\n",
-			       tag);
-		}
-	}
-#endif
-	return slot;
-}
-
-
-
 /* This translates the SDTR message offset and period to a value
  * which can be loaded into the SXFER_REG.
  *
@@ -697,7 +622,6 @@
 			SCp->underflow = SCp->old_underflow;
 			
 		}
-
 		free_slot(slot, hostdata);
 #ifdef NCR_700_DEBUG
 		if(NCR_700_get_depth(SCp->device) == 0 ||
@@ -1148,6 +1072,7 @@
 		__u8 lun;
 		struct NCR_700_command_slot *slot;
 		__u8 reselection_id = hostdata->reselection_id;
+		Scsi_Device *SDp;
 
 		lun = hostdata->msgin[0] & 0x1f;
 
@@ -1155,34 +1080,39 @@
 		DEBUG(("scsi%d: (%d:%d) RESELECTED!\n",
 		       host->host_no, reselection_id, lun));
 		/* clear the reselection indicator */
+		SDp = scsi_find_device(host, 0, reselection_id, lun);
+		if(unlikely(SDp == NULL)) {
+			printk(KERN_ERR "scsi%d: (%d:%d) HAS NO device\n",
+			       host->host_no, reselection_id, lun);
+			BUG();
+		}
 		if(hostdata->msgin[1] == A_SIMPLE_TAG_MSG) {
-			slot = find_ITLQ_Nexus(hostdata, reselection_id,
-					       lun, hostdata->msgin[2]);
+			Scsi_Cmnd *SCp = scsi_find_tag(SDp, hostdata->msgin[2]);
+			if(unlikely(SCp == NULL)) {
+				printk(KERN_ERR "scsi%d: (%d:%d) no saved request for tag %d\n", 
+				       host->host_no, reselection_id, lun, hostdata->msgin[2]);
+				BUG();
+			}
+
+			slot = (struct NCR_700_command_slot *)SCp->host_scribble;
+			DEBUG(("53c700: %d:%d:%d, reselection is tag %d, slot %p(%d)\n",
+			       host->host_no, SDp->id, SDp->lun,
+			       hostdata->msgin[2], slot, slot->tag));
 		} else {
-			slot = find_ITL_Nexus(hostdata, reselection_id, lun);
+			Scsi_Cmnd *SCp = scsi_find_tag(SDp, SCSI_NO_TAG);
+			if(unlikely(SCp == NULL)) {
+				printk(KERN_ERR "scsi%d: (%d:%d) no saved request for untagged cmd\n", 
+				       host->host_no, reselection_id, lun);
+				BUG();
+			}
+			slot = (struct NCR_700_command_slot *)SCp->host_scribble;
 		}
-	retry:
+
 		if(slot == NULL) {
-			struct NCR_700_command_slot *s = find_ITL_Nexus(hostdata, reselection_id, lun);
 			printk(KERN_ERR "scsi%d: (%d:%d) RESELECTED but no saved command (MSG = %02x %02x %02x)!!\n",
 			       host->host_no, reselection_id, lun,
 			       hostdata->msgin[0], hostdata->msgin[1],
 			       hostdata->msgin[2]);
-			printk(KERN_ERR " OUTSTANDING TAGS:");
-			while(s != NULL) {
-				if(s->cmnd->target == reselection_id &&
-				   s->cmnd->lun == lun) {
-					printk("%d ", s->tag);
-					if(s->tag == hostdata->msgin[2]) {
-						printk(" ***FOUND*** \n");
-						slot = s;
-						goto retry;
-					}
-						
-				}
-				s = s->ITL_back;
-			}
-			printk("\n");
 		} else {
 			if(hostdata->state != NCR_700_HOST_BUSY)
 				printk(KERN_ERR "scsi%d: FATAL, host not busy during valid reselection!\n",
@@ -1474,9 +1404,8 @@
 	 * will refuse all tags, so send the request sense as untagged
 	 * */
 	if((hostdata->tag_negotiated & (1<<SCp->target))
-	   && (slot->tag != NCR_700_NO_TAG && SCp->cmnd[0] != REQUEST_SENSE)) {
-		hostdata->msgout[count++] = A_SIMPLE_TAG_MSG;
-		hostdata->msgout[count++] = slot->tag;
+	   && (slot->tag != SCSI_NO_TAG && SCp->cmnd[0] != REQUEST_SENSE)) {
+		count += scsi_populate_tag_msg(SCp, &hostdata->msgout[count]);
 	}
 
 	if(hostdata->fast &&
@@ -1836,7 +1765,6 @@
 	__u32 move_ins;
 	int pci_direction;
 	struct NCR_700_command_slot *slot;
-	int hash;
 
 	if(hostdata->command_slot_count >= NCR_700_COMMAND_SLOTS_PER_HOST) {
 		/* We're over our allocation, this should never happen
@@ -1844,7 +1772,15 @@
 		printk(KERN_WARNING "scsi%d: Command depth has gone over queue depth\n", SCp->host->host_no);
 		return 1;
 	}
-	if(NCR_700_get_depth(SCp->device) != 0 && !(hostdata->tag_negotiated & (1<<SCp->target))) {
+	/* check for untagged commands.  We cannot have any outstanding
+	 * commands if we accept them.  Commands could be untagged because:
+	 *
+	 * - The tag negotiated bitmap is clear
+	 * - The blk layer sent and untagged command
+	 */
+	if(NCR_700_get_depth(SCp->device) != 0
+	   && (!(hostdata->tag_negotiated & (1<<SCp->target))
+	       || !blk_rq_tagged(SCp->request))) {
 		DEBUG((KERN_ERR "scsi%d (%d:%d) has non zero depth %d\n",
 		       SCp->host->host_no, SCp->target, SCp->lun,
 		       NCR_700_get_depth(SCp->device)));
@@ -1883,84 +1819,40 @@
 		 * NOTE: There is a danger here: the mid layer supports
 		 * tag queuing per LUN.  We only support it per PUN because
 		 * of potential reselection issues */
+		printk(KERN_NOTICE "scsi%d: (%d:%d) beginning blk layer TCQ\n",
+		       SCp->device->host->host_no, SCp->target, SCp->lun);
+		scsi_activate_tcq(SCp->device, NCR_700_MAX_TAGS);
+	}
+
+	if(blk_rq_tagged(SCp->request)
+	   && (hostdata->tag_negotiated &(1<<SCp->target)) == 0) {
 		printk(KERN_INFO "scsi%d: (%d:%d) Enabling Tag Command Queuing\n", SCp->device->host->host_no, SCp->target, SCp->lun);
 		hostdata->tag_negotiated |= (1<<SCp->target);
 		NCR_700_set_flag(SCp->device, NCR_700_DEV_BEGIN_TAG_QUEUEING);
-		SCp->device->tagged_queue = 1;
 	}
 
-	if(hostdata->tag_negotiated &(1<<SCp->target)) {
+	/* here we may have to process an untagged command.  The gate
+	 * above ensures that this will be the only one outstanding,
+	 * so clear the tag negotiated bit.
+	 *
+	 * FIXME: This will royally screw up on multiple LUN devices
+	 * */
+	if(!blk_rq_tagged(SCp->request)
+	   && (hostdata->tag_negotiated &(1<<SCp->target))) {
+		printk(KERN_INFO "scsi%d: (%d:%d) Disabling Tag Command Queuing\n", SCp->device->host->host_no, SCp->target, SCp->lun);
+		hostdata->tag_negotiated &= ~(1<<SCp->target);
+	}
 
-		struct NCR_700_command_slot *old =
-			find_ITL_Nexus(hostdata, SCp->target, SCp->lun);
-#ifdef NCR_700_TAG_DEBUG
-		struct NCR_700_command_slot *found;
-#endif
-		
-		if(old != NULL && old->tag == SCp->device->current_tag) {
-			/* On some badly starving drives, this can be
-			 * a frequent occurance, so print the message
-			 * only once */
-			if(NCR_700_is_flag_clear(SCp->device, NCR_700_DEV_TAG_STARVATION_WARNED)) {
-				printk(KERN_WARNING "scsi%d (%d:%d) Target is suffering from tag starvation.\n", SCp->host->host_no, SCp->target, SCp->lun);
-				NCR_700_set_flag(SCp->device, NCR_700_DEV_TAG_STARVATION_WARNED);
-			}
-			/* Release the slot and ajust the depth before refusing
-			 * the command */
-			free_slot(slot, hostdata);
-			NCR_700_set_depth(SCp->device, NCR_700_get_depth(SCp->device) - 1);
-			return 1;
-		}
-		slot->tag = SCp->device->current_tag++;
-#ifdef NCR_700_TAG_DEBUG
-		while((found = find_ITLQ_Nexus(hostdata, SCp->target, SCp->lun, slot->tag)) != NULL) {
-			printk("\n\n**ERROR** already using tag %d, but oldest is %d\n", slot->tag, (old == NULL) ? -1 : old->tag);
-			printk("  FOUND = %p, tag = %d, pun = %d, lun = %d\n",
-			       found, found->tag, found->cmnd->target, found->cmnd->lun);
-			slot->tag = SCp->device->current_tag++;
-			printk("   Tag list is: ");
-			while(old != NULL) {
-				if(old->cmnd->target == SCp->target &&
-				   old->cmnd->lun == SCp->lun)
-					printk("%d ", old->tag);
-				old = old->ITL_back;
-			}
-			printk("\n\n");
-		}
-#endif
-		hash = hash_ITLQ(SCp->target, SCp->lun, slot->tag);
-		/* link into the ITLQ hash queues */
-		slot->ITLQ_forw = hostdata->ITLQ_Hash_forw[hash];
-		hostdata->ITLQ_Hash_forw[hash] = slot;
-#ifdef NCR_700_TAG_DEBUG
-		if(slot->ITLQ_forw != NULL && slot->ITLQ_forw->ITLQ_back != NULL) {
-			printk(KERN_ERR "scsi%d (%d:%d) ITLQ_back is not NULL!!!!\n", SCp->host->host_no, SCp->target, SCp->lun);
-		}
-#endif
-		if(slot->ITLQ_forw != NULL)
-			slot->ITLQ_forw->ITLQ_back = slot;
-		else
-			hostdata->ITLQ_Hash_back[hash] = slot;
-		slot->ITLQ_back = NULL;
+	if((hostdata->tag_negotiated &(1<<SCp->target))) {
+		slot->tag = SCp->request->tag;
+		DEBUG(("53c700 %d:%d:%d, sending out tag %d, slot %p\n",
+		       SCp->host->host_no, SCp->target, SCp->lun, slot->tag,
+		       slot));
 	} else {
-		slot->tag = NCR_700_NO_TAG;
+		slot->tag = SCSI_NO_TAG;
+		/* must populate current_cmnd for scsi_find_tag to work */
+		SCp->device->current_cmnd = SCp;
 	}
-	/* link into the ITL hash queues */
-	hash = hash_ITL(SCp->target, SCp->lun);
-	slot->ITL_forw = hostdata->ITL_Hash_forw[hash];
-	hostdata->ITL_Hash_forw[hash] = slot;
-#ifdef NCR_700_TAG_DEBUG
-	if(slot->ITL_forw != NULL && slot->ITL_forw->ITL_back != NULL) {
-		printk(KERN_ERR "scsi%d (%d:%d) ITL_back is not NULL!!!!\n",
-		       SCp->host->host_no, SCp->target, SCp->lun);
-	}
-#endif
-	if(slot->ITL_forw != NULL)
-		slot->ITL_forw->ITL_back = slot;
-	else
-		hostdata->ITL_Hash_back[hash] = slot;
-	slot->ITL_back = NULL;
-
 	/* sanity check: some of the commands generated by the mid-layer
 	 * have an eccentric idea of their sc_data_direction */
 	if(!SCp->use_sg && !SCp->request_bufflen 
@@ -2054,16 +1946,12 @@
 NCR_700_abort(Scsi_Cmnd * SCp)
 {
 	struct NCR_700_command_slot *slot;
-	struct NCR_700_Host_Parameters *hostdata = 
-		(struct NCR_700_Host_Parameters *)SCp->host->hostdata[0];
 
 	printk(KERN_INFO "scsi%d (%d:%d) New error handler wants to abort command\n\t",
 	       SCp->host->host_no, SCp->target, SCp->lun);
 	print_command(SCp->cmnd);
 
-	slot = find_ITL_Nexus(hostdata, SCp->target, SCp->lun);
-	while(slot != NULL && slot->cmnd != SCp)
-		slot = slot->ITL_back;
+	slot = (struct NCR_700_command_slot *)SCp->host_scribble;
 
 	if(slot == NULL)
 		/* no outstanding command to abort */
diff -Nru a/drivers/scsi/53c700.h b/drivers/scsi/53c700.h
--- a/drivers/scsi/53c700.h	Mon Jun 10 23:10:02 2002
+++ b/drivers/scsi/53c700.h	Mon Jun 10 23:10:02 2002
@@ -9,7 +9,7 @@
 #define _53C700_H
 
 /* Turn on for general debugging---too verbose for normal use */
-#undef NCR_700_DEBUG
+#undef	NCR_700_DEBUG
 /* Debug the tag queues, checking hash queue allocation and deallocation
  * and search for duplicate tags */
 #undef NCR_700_TAG_DEBUG
@@ -189,8 +189,7 @@
 	#define NCR_700_SLOT_BUSY (1|NCR_700_SLOT_MAGIC) /* slot has command active on HA */
 	#define NCR_700_SLOT_QUEUED (2|NCR_700_SLOT_MAGIC) /* slot has command to be made active on HA */
 	__u8	state;
-	#define NCR_700_NO_TAG	0xdead
-	__u16	tag;
+	int	tag;
 	__u32	resume_offset;
 	Scsi_Cmnd	*cmnd;
 	/* The pci_mapped address of the actual command in cmnd */

--==_Exmh_2152075980--


