From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] More 64bit LUN fixes
Date: Mon,  7 Jul 2014 14:16:14 +0200
Message-ID: <1404735374-70276-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58360 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752986AbaGGMQS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Jul 2014 08:16:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <"hch@infradead.org>, linux-scsi"@vger.kernel.org>, Hannes Reinecke <hare@suse.de>

Update some missed printk() statements and fixed up some drivers.
This fixes the build failures seen by the kbuild test robot.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/53c700.c                       |  7 ++--
 drivers/scsi/NCR5380.c                      | 21 +++++-----
 drivers/scsi/NCR53c406a.c                   |  2 +-
 drivers/scsi/a100u2w.c                      |  2 +-
 drivers/scsi/arm/acornscsi.c                | 14 ++++---
 drivers/scsi/arm/fas216.c                   | 11 +++--
 drivers/scsi/arm/queue.c                    |  3 +-
 drivers/scsi/atari_NCR5380.c                | 62 +++++++++++++++--------------
 drivers/scsi/bnx2fc/bnx2fc_io.c             |  4 +-
 drivers/scsi/ch.c                           | 16 ++++----
 drivers/scsi/dpt_i2o.c                      | 38 +++++++++---------
 drivers/scsi/dpti.h                         |  6 +--
 drivers/scsi/g_NCR5380.c                    |  2 +-
 drivers/scsi/hptiop.c                       |  2 +-
 drivers/scsi/in2000.c                       |  6 +--
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  4 +-
 drivers/scsi/mesh.c                         |  2 +-
 drivers/scsi/ncr53c8xx.c                    |  2 +-
 drivers/scsi/nsp32.c                        |  2 +-
 drivers/scsi/pcmcia/nsp_cs.c                |  2 +-
 drivers/scsi/pcmcia/sym53c500_cs.c          |  2 +-
 drivers/scsi/ps3rom.c                       |  2 +-
 drivers/scsi/sun3_NCR5380.c                 | 57 +++++++++++++-------------
 drivers/scsi/tmscsim.c                      |  6 +--
 drivers/scsi/u14-34f.c                      |  4 +-
 drivers/scsi/wd33c93.c                      |  8 ++--
 26 files changed, 152 insertions(+), 135 deletions(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index a3adfb4..fabd4be 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -1005,7 +1005,7 @@ process_script_interrupt(__u32 dsps, __u32 dsp, struct scsi_cmnd *SCp,
 						 DMA_TO_DEVICE);
 
 				cmnd[0] = REQUEST_SENSE;
-				cmnd[1] = (SCp->device->lun & 0x7) << 5;
+				cmnd[1] = (lun & 0x7) << 5;
 				cmnd[2] = 0;
 				cmnd[3] = 0;
 				cmnd[4] = SCSI_SENSE_BUFFERSIZE;
@@ -1396,7 +1396,8 @@ NCR_700_start_command(struct scsi_cmnd *SCp)
 	struct NCR_700_Host_Parameters *hostdata =
 		(struct NCR_700_Host_Parameters *)SCp->device->host->hostdata[0];
 	__u16 count = 1;	/* for IDENTIFY message */
-	
+	u8 lun = SCp->device->lun;
+
 	if(hostdata->state != NCR_700_HOST_FREE) {
 		/* keep this inside the lock to close the race window where
 		 * the running command finishes on another CPU while we don't
@@ -1415,7 +1416,7 @@ NCR_700_start_command(struct scsi_cmnd *SCp)
 
 	hostdata->msgout[0] = NCR_700_identify((SCp->cmnd[0] != REQUEST_SENSE &&
 						slot->flags != NCR_700_FLAG_AUTOSENSE),
-					       SCp->device->lun);
+					       lun);
 	/* for INQUIRY or REQUEST_SENSE commands, we cannot be sure
 	 * if the negotiated transfer parameters still hold, so
 	 * always renegotiate them */
diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 2893d6a..45da3c8 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -762,7 +762,7 @@ static int __maybe_unused NCR5380_show_info(struct seq_file *m,
 
 static void lprint_Scsi_Cmnd(Scsi_Cmnd * cmd, struct seq_file *m)
 {
-	SPRINTF("scsi%d : destination target %d, lun %d\n", cmd->device->host->host_no, cmd->device->id, (u8)cmd->device->lun);
+	SPRINTF("scsi%d : destination target %d, lun %llu\n", cmd->device->host->host_no, cmd->device->id, cmd->device->lun);
 	SPRINTF("        command = ");
 	lprint_command(cmd->cmnd, m);
 }
@@ -1039,9 +1039,10 @@ static void NCR5380_main(struct work_struct *work)
 			for (tmp = (Scsi_Cmnd *) hostdata->issue_queue, prev = NULL; tmp; prev = tmp, tmp = (Scsi_Cmnd *) tmp->host_scribble) 
 			{
 				if (prev != tmp)
-				    dprintk(NDEBUG_LISTS, "MAIN tmp=%p   target=%d   busy=%d lun=%d\n", tmp, tmp->device->id, hostdata->busy[tmp->device->id], (u8)tmp->device->lun);
+				    dprintk(NDEBUG_LISTS, "MAIN tmp=%p   target=%d   busy=%d lun=%llu\n", tmp, tmp->device->id, hostdata->busy[tmp->device->id], tmp->device->lun);
 				/*  When we find one, remove it from the issue queue. */
-				if (!(hostdata->busy[tmp->device->id] & (1 << tmp->device->lun))) {
+				if (!(hostdata->busy[tmp->device->id] &
+				      (1 << (u8)(tmp->device->lun & 0xff)))) {
 					if (prev) {
 						REMOVE(prev, prev->host_scribble, tmp, tmp->host_scribble);
 						prev->host_scribble = tmp->host_scribble;
@@ -1057,7 +1058,7 @@ static void NCR5380_main(struct work_struct *work)
 					 * On failure, we must add the command back to the
 					 *   issue queue so we can keep trying. 
 					 */
-					dprintk(NDEBUG_MAIN|NDEBUG_QUEUES, "scsi%d : main() : command for target %d lun %d removed from issue_queue\n", instance->host_no, tmp->device->id, (u8)tmp->device->lun);
+					dprintk(NDEBUG_MAIN|NDEBUG_QUEUES, "scsi%d : main() : command for target %d lun %llu removed from issue_queue\n", instance->host_no, tmp->device->id, tmp->device->lun);
 	
 					/*
 					 * A successful selection is defined as one that 
@@ -2210,14 +2211,14 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance) {
 				case LINKED_FLG_CMD_COMPLETE:
 					/* Accept message by clearing ACK */
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-					dprintk(NDEBUG_LINKED, "scsi%d : target %d lun %d linked command complete.\n", instance->host_no, cmd->device->id, (u8)cmd->device->lun);
+					dprintk(NDEBUG_LINKED, "scsi%d : target %d lun %llu linked command complete.\n", instance->host_no, cmd->device->id, cmd->device->lun);
 					/* 
 					 * Sanity check : A linked command should only terminate with
 					 * one of these messages if there are more linked commands
 					 * available.
 					 */
 					if (!cmd->next_link) {
-					    printk("scsi%d : target %d lun %d linked command complete, no next_link\n" instance->host_no, cmd->device->id, (u8)cmd->device->lun);
+					    printk("scsi%d : target %d lun %llu linked command complete, no next_link\n" instance->host_no, cmd->device->id, cmd->device->lun);
 						sink = 1;
 						do_abort(instance);
 						return;
@@ -2226,7 +2227,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance) {
 					/* The next command is still part of this process */
 					cmd->next_link->tag = cmd->tag;
 					cmd->result = cmd->SCp.Status | (cmd->SCp.Message << 8);
-					dprintk(NDEBUG_LINKED, "scsi%d : target %d lun %d linked request done, calling scsi_done().\n", instance->host_no, cmd->device->id, (u8)cmd->device->lun);
+					dprintk(NDEBUG_LINKED, "scsi%d : target %d lun %llu linked request done, calling scsi_done().\n", instance->host_no, cmd->device->id, cmd->device->lun);
 					collect_stats(hostdata, cmd);
 					cmd->scsi_done(cmd);
 					cmd = hostdata->connected;
@@ -2238,7 +2239,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance) {
 					sink = 1;
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 					hostdata->connected = NULL;
-					dprintk(NDEBUG_QUEUES, "scsi%d : command for target %d, lun %d completed\n", instance->host_no, cmd->device->id, (u8)cmd->device->lun);
+					dprintk(NDEBUG_QUEUES, "scsi%d : command for target %d, lun %llu completed\n", instance->host_no, cmd->device->id, cmd->device->lun);
 					hostdata->busy[cmd->device->id] &= ~(1 << (cmd->device->lun & 0xFF));
 
 					/* 
@@ -2318,7 +2319,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance) {
 						    hostdata->disconnected_queue;
 						hostdata->connected = NULL;
 						hostdata->disconnected_queue = cmd;
-						dprintk(NDEBUG_QUEUES, "scsi%d : command for target %d lun %d was moved from connected to" "  the disconnected_queue\n", instance->host_no, cmd->device->id, (u8)cmd->device->lun);
+						dprintk(NDEBUG_QUEUES, "scsi%d : command for target %d lun %llu was moved from connected to" "  the disconnected_queue\n", instance->host_no, cmd->device->id, cmd->device->lun);
 						/* 
 						 * Restore phase bits to 0 so an interrupted selection, 
 						 * arbitration can resume.
@@ -2588,7 +2589,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance) {
 		do_abort(instance);
 	} else {
 		hostdata->connected = tmp;
-		dprintk(NDEBUG_RESELECTION, "scsi%d : nexus established, target = %d, lun = %d, tag = %d\n", instance->host_no, tmp->device->id, (u8)tmp->device->lun, tmp->tag);
+		dprintk(NDEBUG_RESELECTION, "scsi%d : nexus established, target = %d, lun = %llu, tag = %d\n", instance->host_no, tmp->device->id, tmp->device->lun, tmp->tag);
 	}
 }
 
diff --git a/drivers/scsi/NCR53c406a.c b/drivers/scsi/NCR53c406a.c
index c91888a..10c3374 100644
--- a/drivers/scsi/NCR53c406a.c
+++ b/drivers/scsi/NCR53c406a.c
@@ -698,7 +698,7 @@ static int NCR53c406a_queue_lck(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 	int i;
 
 	VDEB(printk("NCR53c406a_queue called\n"));
-	DEB(printk("cmd=%02x, cmd_len=%02x, target=%02x, lun=%02x, bufflen=%d\n", SCpnt->cmnd[0], SCpnt->cmd_len, SCpnt->target, SCpnt->lun, scsi_bufflen(SCpnt)));
+        DEB(printk("cmd=%02x, cmd_len=%02x, target=%02x, lun=%02x, bufflen=%d\n", SCpnt->cmnd[0], SCpnt->cmd_len, SCpnt->device->target, (u8)SCpnt->device->lun, scsi_bufflen(SCpnt)));
 
 #if 0
 	VDEB(for (i = 0; i < SCpnt->cmd_len; i++)
diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index 0163457..522570d 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -891,7 +891,7 @@ static int inia100_build_scb(struct orc_host * host, struct orc_scb * scb, struc
 		printk("max cdb length= %x\b", cmd->cmd_len);
 		scb->cdb_len = IMAX_CDB;
 	}
-	scb->ident = cmd->device->lun | DISC_ALLOW;
+	scb->ident = (u8)(cmd->device->lun & 0xff) | DISC_ALLOW;
 	if (cmd->device->tagged_supported) {	/* Tag Support                  */
 		scb->tag_msg = SIMPLE_QUEUE_TAG;	/* Do simple tag only   */
 	} else {
diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index 2e797a3..d89b9b4 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -760,7 +760,8 @@ intr_ret_t acornscsi_kick(AS_Host *host)
 	    SCpnt->tag = SCpnt->device->current_tag;
 	} else
 #endif
-	    set_bit(SCpnt->device->id * 8 + SCpnt->device->lun, host->busyluns);
+	    set_bit(SCpnt->device->id * 8 +
+		    (u8)(SCpnt->device->lun & 0x07), host->busyluns);
 
 	host->stats.removes += 1;
 
@@ -863,7 +864,8 @@ static void acornscsi_done(AS_Host *host, struct scsi_cmnd **SCpntp,
 	if (!SCpnt->scsi_done)
 	    panic("scsi%d.H: null scsi_done function in acornscsi_done", host->host->host_no);
 
-	clear_bit(SCpnt->device->id * 8 + SCpnt->device->lun, host->busyluns);
+	clear_bit(SCpnt->device->id * 8 +
+		  (u8)(SCpnt->device->lun & 0x7), host->busyluns);
 
 	SCpnt->scsi_done(SCpnt);
     } else
@@ -1576,7 +1578,8 @@ void acornscsi_message(AS_Host *host)
 	    printk(KERN_NOTICE "scsi%d.%c: disabling tagged queueing\n",
 		    host->host->host_no, acornscsi_target(host));
 	    host->SCpnt->device->simple_tags = 0;
-	    set_bit(host->SCpnt->device->id * 8 + host->SCpnt->device->lun, host->busyluns);
+	    set_bit(host->SCpnt->device->id * 8 +
+		    (u8)(host->SCpnt->device->lun & 0x7), host->busyluns);
 	    break;
 #endif
 	case EXTENDED_MESSAGE | (EXTENDED_SDTR << 8):
@@ -2671,7 +2674,8 @@ int acornscsi_abort(struct scsi_cmnd *SCpnt)
 //#if (DEBUG & DEBUG_ABORT)
 		printk("clear ");
 //#endif
-		clear_bit(SCpnt->device->id * 8 + SCpnt->device->lun, host->busyluns);
+		clear_bit(SCpnt->device->id * 8 +
+			  (u8)(SCpnt->device->lun & 0x7), host->busyluns);
 
 	/*
 	 * We found the command, and cleared it out.  Either
@@ -2853,7 +2857,7 @@ static int acornscsi_show_info(struct seq_file *m, struct Scsi_Host *instance)
 
     shost_for_each_device(scd, instance) {
 	seq_printf(m, "Device/Lun TaggedQ      Sync\n");
-	seq_printf(m, "     %d/%d   ", scd->id, scd->lun);
+	seq_printf(m, "     %d/%llu   ", scd->id, scd->lun);
 	if (scd->tagged_supported)
 		seq_printf(m, "%3sabled(%3d) ",
 			     scd->simple_tags ? "en" : "dis",
diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index b46a6f6..71cfb1e 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -1821,7 +1821,8 @@ static void fas216_allocate_tag(FAS216_Info *info, struct scsi_cmnd *SCpnt)
 			SCpnt->tag = SCpnt->device->current_tag;
 	} else
 #endif
-		set_bit(SCpnt->device->id * 8 + SCpnt->device->lun, info->busyluns);
+		set_bit(SCpnt->device->id * 8 +
+			(u8)(SCpnt->device->lun & 0x7), info->busyluns);
 
 	info->stats.removes += 1;
 	switch (SCpnt->cmnd[0]) {
@@ -2171,7 +2172,8 @@ static void fas216_done(FAS216_Info *info, unsigned int result)
 	 * status.
 	 */
 	info->device[SCpnt->device->id].parity_check = 0;
-	clear_bit(SCpnt->device->id * 8 + SCpnt->device->lun, info->busyluns);
+	clear_bit(SCpnt->device->id * 8 +
+		  (u8)(SCpnt->device->lun & 0x7), info->busyluns);
 
 	fn = (void (*)(FAS216_Info *, struct scsi_cmnd *, unsigned int))SCpnt->host_scribble;
 	fn(info, SCpnt, result);
@@ -2398,7 +2400,8 @@ static enum res_find fas216_find_command(FAS216_Info *info,
 		 * been set.
 		 */
 		info->origSCpnt = NULL;
-		clear_bit(SCpnt->device->id * 8 + SCpnt->device->lun, info->busyluns);
+		clear_bit(SCpnt->device->id * 8 +
+			  (u8)(SCpnt->device->lun & 0x7), info->busyluns);
 		printk("waiting for execution ");
 		res = res_success;
 	} else
@@ -3000,7 +3003,7 @@ void fas216_print_devices(FAS216_Info *info, struct seq_file *m)
 
 	shost_for_each_device(scd, info->host) {
 		dev = &info->device[scd->id];
-		seq_printf(m, "     %d/%d   ", scd->id, scd->lun);
+		seq_printf(m, "     %d/%llu   ", scd->id, scd->lun);
 		if (scd->tagged_supported)
 			seq_printf(m, "%3sabled(%3d) ",
 				     scd->simple_tags ? "en" : "dis",
diff --git a/drivers/scsi/arm/queue.c b/drivers/scsi/arm/queue.c
index cb11cce..3441ce3 100644
--- a/drivers/scsi/arm/queue.c
+++ b/drivers/scsi/arm/queue.c
@@ -167,7 +167,8 @@ struct scsi_cmnd *queue_remove_exclude(Queue_t *queue, unsigned long *exclude)
 	spin_lock_irqsave(&queue->queue_lock, flags);
 	list_for_each(l, &queue->head) {
 		QE_t *q = list_entry(l, QE_t, list);
-		if (!test_bit(q->SCpnt->device->id * 8 + q->SCpnt->device->lun, exclude)) {
+		if (!test_bit(q->SCpnt->device->id * 8 +
+			      (u8)(q->SCpnt->device->lun & 0x7), exclude)) {
 			SCpnt = __queue_remove(queue, l);
 			break;
 		}
diff --git a/drivers/scsi/atari_NCR5380.c b/drivers/scsi/atari_NCR5380.c
index 1814aa2..79e6f04 100644
--- a/drivers/scsi/atari_NCR5380.c
+++ b/drivers/scsi/atari_NCR5380.c
@@ -361,17 +361,18 @@ static void __init init_tags(void)
 
 static int is_lun_busy(Scsi_Cmnd *cmd, int should_be_tagged)
 {
+	u8 lun = cmd->device->lun;
 	SETUP_HOSTDATA(cmd->device->host);
 
-	if (hostdata->busy[cmd->device->id] & (1 << cmd->device->lun))
+	if (hostdata->busy[cmd->device->id] & (1 << lun))
 		return 1;
 	if (!should_be_tagged ||
 	    !setup_use_tagged_queuing || !cmd->device->tagged_supported)
 		return 0;
-	if (TagAlloc[cmd->device->id][cmd->device->lun].nr_allocated >=
-	    TagAlloc[cmd->device->id][cmd->device->lun].queue_size) {
+	if (TagAlloc[cmd->device->id][lun].nr_allocated >=
+	    TagAlloc[cmd->device->id][lun].queue_size) {
 		dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %d: no free tags\n",
-			   H_NO(cmd), cmd->device->id, cmd->device->lun);
+			   H_NO(cmd), cmd->device->id, lun);
 		return 1;
 	}
 	return 0;
@@ -385,6 +386,7 @@ static int is_lun_busy(Scsi_Cmnd *cmd, int should_be_tagged)
 
 static void cmd_get_tag(Scsi_Cmnd *cmd, int should_be_tagged)
 {
+	u8 lun = cmd->device->lun;
 	SETUP_HOSTDATA(cmd->device->host);
 
 	/* If we or the target don't support tagged queuing, allocate the LUN for
@@ -393,11 +395,11 @@ static void cmd_get_tag(Scsi_Cmnd *cmd, int should_be_tagged)
 	if (!should_be_tagged ||
 	    !setup_use_tagged_queuing || !cmd->device->tagged_supported) {
 		cmd->tag = TAG_NONE;
-		hostdata->busy[cmd->device->id] |= (1 << cmd->device->lun);
+		hostdata->busy[cmd->device->id] |= (1 << lun);
 		dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %d now allocated by untagged "
-			   "command\n", H_NO(cmd), cmd->device->id, cmd->device->lun);
+			   "command\n", H_NO(cmd), cmd->device->id, lun);
 	} else {
-		TAG_ALLOC *ta = &TagAlloc[cmd->device->id][cmd->device->lun];
+		TAG_ALLOC *ta = &TagAlloc[cmd->device->id][lun];
 
 		cmd->tag = find_first_zero_bit(ta->allocated, MAX_TAGS);
 		set_bit(cmd->tag, ta->allocated);
@@ -405,7 +407,7 @@ static void cmd_get_tag(Scsi_Cmnd *cmd, int should_be_tagged)
 		dprintk(NDEBUG_TAGS, "scsi%d: using tag %d for target %d lun %d "
 			   "(now %d tags in use)\n",
 			   H_NO(cmd), cmd->tag, cmd->device->id,
-			   cmd->device->lun, ta->nr_allocated);
+			   lun, ta->nr_allocated);
 	}
 }
 
@@ -416,21 +418,22 @@ static void cmd_get_tag(Scsi_Cmnd *cmd, int should_be_tagged)
 
 static void cmd_free_tag(Scsi_Cmnd *cmd)
 {
+	u8 lun = cmd->device->lun;
 	SETUP_HOSTDATA(cmd->device->host);
 
 	if (cmd->tag == TAG_NONE) {
-		hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
+		hostdata->busy[cmd->device->id] &= ~(1 << lun);
 		dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %d untagged cmd finished\n",
-			   H_NO(cmd), cmd->device->id, cmd->device->lun);
+			   H_NO(cmd), cmd->device->id, lun);
 	} else if (cmd->tag >= MAX_TAGS) {
 		printk(KERN_NOTICE "scsi%d: trying to free bad tag %d!\n",
 		       H_NO(cmd), cmd->tag);
 	} else {
-		TAG_ALLOC *ta = &TagAlloc[cmd->device->id][cmd->device->lun];
+		TAG_ALLOC *ta = &TagAlloc[cmd->device->id][lun];
 		clear_bit(cmd->tag, ta->allocated);
 		ta->nr_allocated--;
 		dprintk(NDEBUG_TAGS, "scsi%d: freed tag %d for target %d lun %d\n",
-			   H_NO(cmd), cmd->tag, cmd->device->id, cmd->device->lun);
+			   H_NO(cmd), cmd->tag, cmd->device->id, lun);
 	}
 }
 
@@ -713,7 +716,7 @@ static void lprint_Scsi_Cmnd(Scsi_Cmnd *cmd)
 {
 	int i, s;
 	unsigned char *command;
-	printk("scsi%d: destination target %d, lun %d\n",
+	printk("scsi%d: destination target %d, lun %llu\n",
 		H_NO(cmd), cmd->device->id, cmd->device->lun);
 	printk(KERN_CONT "        command = ");
 	command = cmd->cmnd;
@@ -759,7 +762,7 @@ static void show_Scsi_Cmnd(Scsi_Cmnd *cmd, struct seq_file *m)
 {
 	int i, s;
 	unsigned char *command;
-	seq_printf(m, "scsi%d: destination target %d, lun %d\n",
+	seq_printf(m, "scsi%d: destination target %d, lun %llu\n",
 		H_NO(cmd), cmd->device->id, cmd->device->lun);
 	seq_printf(m, "        command = ");
 	command = cmd->cmnd;
@@ -1060,12 +1063,13 @@ static void NCR5380_main(struct work_struct *work)
 #endif
 			for (tmp = (Scsi_Cmnd *) hostdata->issue_queue,
 			     prev = NULL; tmp; prev = tmp, tmp = NEXT(tmp)) {
+				u8 lun = tmp->device->lun;
 
 #if (NDEBUG & NDEBUG_LISTS)
 				if (prev != tmp)
-					printk("MAIN tmp=%p   target=%d   busy=%d lun=%d\n",
+					printk("MAIN tmp=%p   target=%d   busy=%d lun=%llu\n",
 					       tmp, tmp->device->id, hostdata->busy[tmp->device->id],
-					       tmp->device->lun);
+					       lun);
 #endif
 				/*  When we find one, remove it from the issue queue. */
 				/* ++guenther: possible race with Falcon locking */
@@ -1073,7 +1077,7 @@ static void NCR5380_main(struct work_struct *work)
 #ifdef SUPPORT_TAGS
 				    !is_lun_busy( tmp, tmp->cmnd[0] != REQUEST_SENSE)
 #else
-				    !(hostdata->busy[tmp->device->id] & (1 << tmp->device->lun))
+				    !(hostdata->busy[tmp->device->id] & (1 << lun))
 #endif
 				    ) {
 					/* ++guenther: just to be sure, this must be atomic */
@@ -1099,7 +1103,7 @@ static void NCR5380_main(struct work_struct *work)
 					 */
 					dprintk(NDEBUG_MAIN, "scsi%d: main(): command for target %d "
 						    "lun %d removed from issue_queue\n",
-						    HOSTNO, tmp->device->id, tmp->device->lun);
+						    HOSTNO, tmp->device->id, lun);
 					/*
 					 * REQUEST SENSE commands are issued without tagged
 					 * queueing, even on SCSI-II devices because the
@@ -2061,7 +2065,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 						 * accesses to this device will use the
 						 * polled-IO. */
 						printk(KERN_NOTICE "scsi%d: switching target %d "
-							   "lun %d to slow handshake\n", HOSTNO,
+							   "lun %llu to slow handshake\n", HOSTNO,
 							   cmd->device->id, cmd->device->lun);
 						cmd->device->borken = 1;
 						NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE |
@@ -2113,7 +2117,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 					/* Accept message by clearing ACK */
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 
-					dprintk(NDEBUG_LINKED, "scsi%d: target %d lun %d linked command "
+					dprintk(NDEBUG_LINKED, "scsi%d: target %d lun %llu linked command "
 						   "complete.\n", HOSTNO, cmd->device->id, cmd->device->lun);
 
 					/* Enable reselect interrupts */
@@ -2125,7 +2129,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 					 */
 
 					if (!cmd->next_link) {
-						 printk(KERN_NOTICE "scsi%d: target %d lun %d "
+						 printk(KERN_NOTICE "scsi%d: target %d lun %llu "
 							"linked command complete, no next_link\n",
 							HOSTNO, cmd->device->id, cmd->device->lun);
 						sink = 1;
@@ -2138,7 +2142,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 					 * and don't free it! */
 					cmd->next_link->tag = cmd->tag;
 					cmd->result = cmd->SCp.Status | (cmd->SCp.Message << 8);
-					dprintk(NDEBUG_LINKED, "scsi%d: target %d lun %d linked request "
+					dprintk(NDEBUG_LINKED, "scsi%d: target %d lun %llu linked request "
 						   "done, calling scsi_done().\n",
 						   HOSTNO, cmd->device->id, cmd->device->lun);
 #ifdef NCR5380_STATS
@@ -2155,7 +2159,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 					/* ++guenther: possible race with Falcon locking */
 					falcon_dont_release++;
 					hostdata->connected = NULL;
-					dprintk(NDEBUG_QUEUES, "scsi%d: command for target %d, lun %d "
+					dprintk(NDEBUG_QUEUES, "scsi%d: command for target %d, lun %llu "
 						  "completed\n", HOSTNO, cmd->device->id, cmd->device->lun);
 #ifdef SUPPORT_TAGS
 					cmd_free_tag(cmd);
@@ -2169,7 +2173,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 						/* ++Andreas: the mid level code knows about
 						   QUEUE_FULL now. */
 						TAG_ALLOC *ta = &TagAlloc[cmd->device->id][cmd->device->lun];
-						dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %d returned "
+						dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %llu returned "
 							   "QUEUE_FULL after %d commands\n",
 							   HOSTNO, cmd->device->id, cmd->device->lun,
 							   ta->nr_allocated);
@@ -2267,7 +2271,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 						cmd->device->tagged_supported = 0;
 						hostdata->busy[cmd->device->id] |= (1 << cmd->device->lun);
 						cmd->tag = TAG_NONE;
-						dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %d rejected "
+						dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %llu rejected "
 							   "QUEUE_TAG message; tagged queuing "
 							   "disabled\n",
 							   HOSTNO, cmd->device->id, cmd->device->lun);
@@ -2284,7 +2288,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 					hostdata->connected = NULL;
 					hostdata->disconnected_queue = cmd;
 					local_irq_restore(flags);
-					dprintk(NDEBUG_QUEUES, "scsi%d: command for target %d lun %d was "
+					dprintk(NDEBUG_QUEUES, "scsi%d: command for target %d lun %llu was "
 						  "moved from connected to the "
 						  "disconnected_queue\n", HOSTNO,
 						  cmd->device->id, cmd->device->lun);
@@ -2385,12 +2389,12 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 						printk("\n");
 					} else if (tmp != EXTENDED_MESSAGE)
 						printk(KERN_DEBUG "scsi%d: rejecting unknown "
-						       "message %02x from target %d, lun %d\n",
+						       "message %02x from target %d, lun %llu\n",
 						       HOSTNO, tmp, cmd->device->id, cmd->device->lun);
 					else
 						printk(KERN_DEBUG "scsi%d: rejecting unknown "
 						       "extended message "
-						       "code %02x, length %d from target %d, lun %d\n",
+						       "code %02x, length %d from target %d, lun %llu\n",
 						       HOSTNO, extended_msg[1], extended_msg[0],
 						       cmd->device->id, cmd->device->lun);
 
@@ -2588,7 +2592,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 
 	hostdata->connected = tmp;
-	dprintk(NDEBUG_RESELECTION, "scsi%d: nexus established, target = %d, lun = %d, tag = %d\n",
+	dprintk(NDEBUG_RESELECTION, "scsi%d: nexus established, target = %d, lun = %llu, tag = %d\n",
 		   HOSTNO, tmp->device->id, tmp->device->lun, tmp->tag);
 	falcon_dont_release--;
 }
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 32a5e0a..00db81d 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1448,9 +1448,9 @@ static void bnx2fc_lun_reset_cmpl(struct bnx2fc_cmd *io_req)
 	struct scsi_cmnd *sc_cmd = io_req->sc_cmd;
 	struct bnx2fc_rport *tgt = io_req->tgt;
 	struct bnx2fc_cmd *cmd, *tmp;
-	int tm_lun = sc_cmd->device->lun;
+	u64 tm_lun = sc_cmd->device->lun;
+	u64 lun;
 	int rc = 0;
-	int lun;
 
 	/* called with tgt_lock held */
 	BNX2FC_IO_DBG(io_req, "Entered bnx2fc_lun_reset_cmpl\n");
diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index ba1c3bf..ef5ae0d 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -251,7 +251,7 @@ ch_read_element_status(scsi_changer *ch, u_int elem, char *data)
  retry:
 	memset(cmd,0,sizeof(cmd));
 	cmd[0] = READ_ELEMENT_STATUS;
-	cmd[1] = (ch->device->lun << 5) |
+	cmd[1] = ((ch->device->lun & 0x7) << 5) |
 		(ch->voltags ? 0x10 : 0) |
 		ch_elem_to_typecode(ch,elem);
 	cmd[2] = (elem >> 8) & 0xff;
@@ -287,7 +287,7 @@ ch_init_elem(scsi_changer *ch)
 	VPRINTK(KERN_INFO, "INITIALIZE ELEMENT STATUS, may take some time ...\n");
 	memset(cmd,0,sizeof(cmd));
 	cmd[0] = INITIALIZE_ELEMENT_STATUS;
-	cmd[1] = ch->device->lun << 5;
+	cmd[1] = (ch->device->lun & 0x7) << 5;
 	err = ch_do_scsi(ch, cmd, NULL, 0, DMA_NONE);
 	VPRINTK(KERN_INFO, "... finished\n");
 	return err;
@@ -307,7 +307,7 @@ ch_readconfig(scsi_changer *ch)
 
 	memset(cmd,0,sizeof(cmd));
 	cmd[0] = MODE_SENSE;
-	cmd[1] = ch->device->lun << 5;
+	cmd[1] = (ch->device->lun & 0x7) << 5;
 	cmd[2] = 0x1d;
 	cmd[4] = 255;
 	result = ch_do_scsi(ch, cmd, buffer, 255, DMA_FROM_DEVICE);
@@ -432,7 +432,7 @@ ch_position(scsi_changer *ch, u_int trans, u_int elem, int rotate)
 		trans = ch->firsts[CHET_MT];
 	memset(cmd,0,sizeof(cmd));
 	cmd[0]  = POSITION_TO_ELEMENT;
-	cmd[1]  = ch->device->lun << 5;
+	cmd[1]  = (ch->device->lun & 0x7) << 5;
 	cmd[2]  = (trans >> 8) & 0xff;
 	cmd[3]  =  trans       & 0xff;
 	cmd[4]  = (elem  >> 8) & 0xff;
@@ -451,7 +451,7 @@ ch_move(scsi_changer *ch, u_int trans, u_int src, u_int dest, int rotate)
 		trans = ch->firsts[CHET_MT];
 	memset(cmd,0,sizeof(cmd));
 	cmd[0]  = MOVE_MEDIUM;
-	cmd[1]  = ch->device->lun << 5;
+	cmd[1]  = (ch->device->lun & 0x7) << 5;
 	cmd[2]  = (trans >> 8) & 0xff;
 	cmd[3]  =  trans       & 0xff;
 	cmd[4]  = (src   >> 8) & 0xff;
@@ -474,7 +474,7 @@ ch_exchange(scsi_changer *ch, u_int trans, u_int src,
 		trans = ch->firsts[CHET_MT];
 	memset(cmd,0,sizeof(cmd));
 	cmd[0]  = EXCHANGE_MEDIUM;
-	cmd[1]  = ch->device->lun << 5;
+	cmd[1]  = (ch->device->lun & 0x7) << 5;
 	cmd[2]  = (trans >> 8) & 0xff;
 	cmd[3]  =  trans       & 0xff;
 	cmd[4]  = (src   >> 8) & 0xff;
@@ -522,7 +522,7 @@ ch_set_voltag(scsi_changer *ch, u_int elem,
 		elem, tag);
 	memset(cmd,0,sizeof(cmd));
 	cmd[0]  = SEND_VOLUME_TAG;
-	cmd[1] = (ch->device->lun << 5) |
+	cmd[1] = ((ch->device->lun & 0x7) << 5) |
 		ch_elem_to_typecode(ch,elem);
 	cmd[2] = (elem >> 8) & 0xff;
 	cmd[3] = elem        & 0xff;
@@ -758,7 +758,7 @@ static long ch_ioctl(struct file *file,
 	voltag_retry:
 		memset(ch_cmd, 0, sizeof(ch_cmd));
 		ch_cmd[0] = READ_ELEMENT_STATUS;
-		ch_cmd[1] = (ch->device->lun << 5) |
+		ch_cmd[1] = ((ch->device->lun & 0x7) << 5) |
 			(ch->voltags ? 0x10 : 0) |
 			ch_elem_to_typecode(ch,elem);
 		ch_cmd[2] = (elem >> 8) & 0xff;
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index c0ae8fa..67283ef 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -459,7 +459,7 @@ static int adpt_queue_lck(struct scsi_cmnd * cmd, void (*done) (struct scsi_cmnd
 		 * to the device structure.  This should be a TEST_UNIT_READY
 		 * command from scan_scsis_single.
 		 */
-		if ((pDev = adpt_find_device(pHba, (u32)cmd->device->channel, (u32)cmd->device->id, (u32)cmd->device->lun)) == NULL) {
+		if ((pDev = adpt_find_device(pHba, (u32)cmd->device->channel, (u32)cmd->device->id, cmd->device->lun)) == NULL) {
 			// TODO: if any luns are at this bus, scsi id then fake a TEST_UNIT_READY and INQUIRY response 
 			// with type 7F (for all luns less than the max for this bus,id) so the lun scan will continue.
 			cmd->result = (DID_NO_CONNECT << 16);
@@ -579,8 +579,8 @@ static int adpt_show_info(struct seq_file *m, struct Scsi_Host *host)
 				seq_printf(m," Rev: %-8.8s\n", d->pScsi_dev->rev);
 
 				unit = d->pI2o_dev->lct_data.tid;
-				seq_printf(m, "\tTID=%d, (Channel=%d, Target=%d, Lun=%d)  (%s)\n\n",
-					       unit, (int)d->scsi_channel, (int)d->scsi_id, (int)d->scsi_lun,
+				seq_printf(m, "\tTID=%d, (Channel=%d, Target=%d, Lun=%llu)  (%s)\n\n",
+					       unit, (int)d->scsi_channel, (int)d->scsi_id, d->scsi_lun,
 					       scsi_device_online(d->pScsi_dev)? "online":"offline"); 
 				d = d->next_lun;
 			}
@@ -1162,7 +1162,7 @@ static void adpt_i2o_delete_hba(adpt_hba* pHba)
 	}
 }
 
-static struct adpt_device* adpt_find_device(adpt_hba* pHba, u32 chan, u32 id, u32 lun)
+static struct adpt_device* adpt_find_device(adpt_hba* pHba, u32 chan, u32 id, u64 lun)
 {
 	struct adpt_device* d;
 
@@ -1462,7 +1462,7 @@ static int adpt_i2o_parse_lct(adpt_hba* pHba)
 	i2o_lct *lct = pHba->lct;
 	u8 bus_no = 0;
 	s16 scsi_id;
-	s16 scsi_lun;
+	u64 scsi_lun;
 	u32 buf[10]; // larger than 7, or 8 ...
 	struct adpt_device* pDev; 
 	
@@ -1496,7 +1496,7 @@ static int adpt_i2o_parse_lct(adpt_hba* pHba)
 			}
 			bus_no = buf[0]>>16;
 			scsi_id = buf[1];
-			scsi_lun = (buf[2]>>8 )&0xff;
+			scsi_lun = scsilun_to_int((struct scsi_lun *)&buf[2]);
 			if(bus_no >= MAX_CHANNEL) {	// Something wrong skip it
 				printk(KERN_WARNING"%s: Channel number %d out of range \n", pHba->name, bus_no);
 				continue;
@@ -1571,7 +1571,7 @@ static int adpt_i2o_parse_lct(adpt_hba* pHba)
 			if(adpt_i2o_query_scalar(pHba, tid, 0x8000, -1, buf, 32)>=0) {
 				bus_no = buf[0]>>16;
 				scsi_id = buf[1];
-				scsi_lun = (buf[2]>>8 )&0xff;
+				scsi_lun = scsilun_to_int((struct scsi_lun *)&buf[2]);
 				if(bus_no >= MAX_CHANNEL) {	// Something wrong skip it
 					continue;
 				}
@@ -2407,8 +2407,8 @@ static s32 adpt_i2o_to_scsi(void __iomem *reply, struct scsi_cmnd* cmd)
 		case I2O_SCSI_DSC_COMMAND_TIMEOUT:
 		case I2O_SCSI_DSC_NO_ADAPTER:
 		case I2O_SCSI_DSC_RESOURCE_UNAVAILABLE:
-			printk(KERN_WARNING"%s: SCSI Timeout-Device (%d,%d,%d) hba status=0x%x, dev status=0x%x, cmd=0x%x\n",
-				pHba->name, (u32)cmd->device->channel, (u32)cmd->device->id, (u32)cmd->device->lun, hba_status, dev_status, cmd->cmnd[0]);
+			printk(KERN_WARNING"%s: SCSI Timeout-Device (%d,%d,%llu) hba status=0x%x, dev status=0x%x, cmd=0x%x\n",
+				pHba->name, (u32)cmd->device->channel, (u32)cmd->device->id, cmd->device->lun, hba_status, dev_status, cmd->cmnd[0]);
 			cmd->result = (DID_TIME_OUT << 16);
 			break;
 		case I2O_SCSI_DSC_ADAPTER_BUSY:
@@ -2447,8 +2447,8 @@ static s32 adpt_i2o_to_scsi(void __iomem *reply, struct scsi_cmnd* cmd)
 		case I2O_SCSI_DSC_QUEUE_FROZEN:
 		case I2O_SCSI_DSC_REQUEST_INVALID:
 		default:
-			printk(KERN_WARNING"%s: SCSI error %0x-Device(%d,%d,%d) hba_status=0x%x, dev_status=0x%x, cmd=0x%x\n",
-				pHba->name, detailed_status & I2O_SCSI_DSC_MASK, (u32)cmd->device->channel, (u32)cmd->device->id, (u32)cmd->device->lun,
+			printk(KERN_WARNING"%s: SCSI error %0x-Device(%d,%d,%llu) hba_status=0x%x, dev_status=0x%x, cmd=0x%x\n",
+				pHba->name, detailed_status & I2O_SCSI_DSC_MASK, (u32)cmd->device->channel, (u32)cmd->device->id, cmd->device->lun,
 			       hba_status, dev_status, cmd->cmnd[0]);
 			cmd->result = (DID_ERROR << 16);
 			break;
@@ -2464,8 +2464,8 @@ static s32 adpt_i2o_to_scsi(void __iomem *reply, struct scsi_cmnd* cmd)
 			   cmd->sense_buffer[2] == DATA_PROTECT ){
 				/* This is to handle an array failed */
 				cmd->result = (DID_TIME_OUT << 16);
-				printk(KERN_WARNING"%s: SCSI Data Protect-Device (%d,%d,%d) hba_status=0x%x, dev_status=0x%x, cmd=0x%x\n",
-					pHba->name, (u32)cmd->device->channel, (u32)cmd->device->id, (u32)cmd->device->lun, 
+				printk(KERN_WARNING"%s: SCSI Data Protect-Device (%d,%d,%llu) hba_status=0x%x, dev_status=0x%x, cmd=0x%x\n",
+					pHba->name, (u32)cmd->device->channel, (u32)cmd->device->id, cmd->device->lun,
 					hba_status, dev_status, cmd->cmnd[0]);
 
 			}
@@ -2476,8 +2476,8 @@ static s32 adpt_i2o_to_scsi(void __iomem *reply, struct scsi_cmnd* cmd)
 		 * for a limitted number of retries.
 		 */
 		cmd->result = (DID_TIME_OUT << 16);
-		printk(KERN_WARNING"%s: I2O MSG_FAIL - Device (%d,%d,%d) tid=%d, cmd=0x%x\n",
-			pHba->name, (u32)cmd->device->channel, (u32)cmd->device->id, (u32)cmd->device->lun,
+		printk(KERN_WARNING"%s: I2O MSG_FAIL - Device (%d,%d,%llu) tid=%d, cmd=0x%x\n",
+			pHba->name, (u32)cmd->device->channel, (u32)cmd->device->id, cmd->device->lun,
 			((struct adpt_device*)(cmd->device->hostdata))->tid, cmd->cmnd[0]);
 	}
 
@@ -2517,7 +2517,7 @@ static s32 adpt_i2o_reparse_lct(adpt_hba* pHba)
 	i2o_lct *lct = pHba->lct;
 	u8 bus_no = 0;
 	s16 scsi_id;
-	s16 scsi_lun;
+	u64 scsi_lun;
 	u32 buf[10]; // at least 8 u32's
 	struct adpt_device* pDev = NULL;
 	struct i2o_device* pI2o_dev = NULL;
@@ -2564,7 +2564,7 @@ static s32 adpt_i2o_reparse_lct(adpt_hba* pHba)
 			}
 
 			scsi_id = buf[1];
-			scsi_lun = (buf[2]>>8 )&0xff;
+			scsi_lun = scsilun_to_int((struct scsi_lun *)&buf[2]);
 			pDev = pHba->channel[bus_no].device[scsi_id];
 			/* da lun */
 			while(pDev) {
@@ -2633,7 +2633,7 @@ static s32 adpt_i2o_reparse_lct(adpt_hba* pHba)
 			while(pDev) {
 				if(pDev->scsi_lun == scsi_lun) {
 					if(!scsi_device_online(pDev->pScsi_dev)) {
-						printk(KERN_WARNING"%s: Setting device (%d,%d,%d) back online\n",
+						printk(KERN_WARNING"%s: Setting device (%d,%d,%llu) back online\n",
 								pHba->name,bus_no,scsi_id,scsi_lun);
 						if (pDev->pScsi_dev) {
 							scsi_device_set_state(pDev->pScsi_dev, SDEV_RUNNING);
@@ -2665,7 +2665,7 @@ static s32 adpt_i2o_reparse_lct(adpt_hba* pHba)
 		// in the LCT table
 		if (pDev->state & DPTI_DEV_UNSCANNED){
 			pDev->state = DPTI_DEV_OFFLINE;
-			printk(KERN_WARNING"%s: Device (%d,%d,%d) offline\n",pHba->name,pDev->scsi_channel,pDev->scsi_id,pDev->scsi_lun);
+			printk(KERN_WARNING"%s: Device (%d,%d,%llu) offline\n",pHba->name,pDev->scsi_channel,pDev->scsi_id,pDev->scsi_lun);
 			if (pDev->pScsi_dev) {
 				scsi_device_set_state(pDev->pScsi_dev, SDEV_OFFLINE);
 			}
diff --git a/drivers/scsi/dpti.h b/drivers/scsi/dpti.h
index aeb0461..1fa345a 100644
--- a/drivers/scsi/dpti.h
+++ b/drivers/scsi/dpti.h
@@ -184,7 +184,7 @@ struct adpt_device {
 	u32	block_size;
 	u8	scsi_channel;
 	u8	scsi_id;
-	u8 	scsi_lun;
+	u64	scsi_lun;
 	u8	state;
 	u16	tid;
 	struct i2o_device* pI2o_dev;
@@ -231,7 +231,7 @@ typedef struct _adpt_hba {
 	u32  sg_tablesize;	// Scatter/Gather List Size.       
 	u8  top_scsi_channel;
 	u8  top_scsi_id;
-	u8  top_scsi_lun;
+	u64  top_scsi_lun;
 	u8  dma64;
 
 	i2o_status_block* status_block;
@@ -300,7 +300,7 @@ static s32 adpt_send_nop(adpt_hba*pHba,u32 m);
 static void adpt_i2o_delete_hba(adpt_hba* pHba);
 static void adpt_inquiry(adpt_hba* pHba);
 static void adpt_fail_posted_scbs(adpt_hba* pHba);
-static struct adpt_device* adpt_find_device(adpt_hba* pHba, u32 chan, u32 id, u32 lun);
+static struct adpt_device* adpt_find_device(adpt_hba* pHba, u32 chan, u32 id, u64 lun);
 static int adpt_install_hba(struct scsi_host_template* sht, struct pci_dev* pDev) ;
 static int adpt_i2o_online_hba(adpt_hba* pHba);
 static void adpt_i2o_post_wait_complete(u32, int);
diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index a1bc8ca..b331272 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -768,7 +768,7 @@ static void sprint_command(struct seq_file *m, unsigned char *command)
 
 static void sprint_Scsi_Cmnd(struct seq_file *m, Scsi_Cmnd * cmd)
 {
-	PRINTP("host number %d destination target %d, lun %d\n" ANDP cmd->device->host->host_no ANDP cmd->device->id ANDP cmd->device->lun);
+	PRINTP("host number %d destination target %d, lun %llu\n" ANDP cmd->device->host->host_no ANDP cmd->device->id ANDP cmd->device->lun);
 	PRINTP("        command = ");
 	sprint_command(m, cmd->cmnd);
 }
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index ee196b3..dedb62c 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -1024,7 +1024,7 @@ static int hptiop_queuecommand_lck(struct scsi_cmnd *scp,
 
 	_req->scp = scp;
 
-	dprintk("hptiop_queuecmd(scp=%p) %d/%d/%d/%d cdb=(%08x-%08x-%08x-%08x) "
+	dprintk("hptiop_queuecmd(scp=%p) %d/%d/%d/%llu cdb=(%08x-%08x-%08x-%08x) "
 			"req_index=%d, req=%p\n",
 			scp,
 			host->host_no, scp->device->channel,
diff --git a/drivers/scsi/in2000.c b/drivers/scsi/in2000.c
index b1c4d83..ddf0694 100644
--- a/drivers/scsi/in2000.c
+++ b/drivers/scsi/in2000.c
@@ -2251,14 +2251,14 @@ static int in2000_show_info(struct seq_file *m, struct Scsi_Host *instance)
 		seq_printf(m, "\nconnected:     ");
 		if (hd->connected) {
 			cmd = (Scsi_Cmnd *) hd->connected;
-			seq_printf(m, " %d:%d(%02x)", cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
+			seq_printf(m, " %d:%llu(%02x)", cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
 		}
 	}
 	if (hd->proc & PR_INPUTQ) {
 		seq_printf(m, "\ninput_Q:       ");
 		cmd = (Scsi_Cmnd *) hd->input_Q;
 		while (cmd) {
-			seq_printf(m, " %d:%d(%02x)", cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
+			seq_printf(m, " %d:%llu(%02x)", cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
 			cmd = (Scsi_Cmnd *) cmd->host_scribble;
 		}
 	}
@@ -2266,7 +2266,7 @@ static int in2000_show_info(struct seq_file *m, struct Scsi_Host *instance)
 		seq_printf(m, "\ndisconnected_Q:");
 		cmd = (Scsi_Cmnd *) hd->disconnected_Q;
 		while (cmd) {
-			seq_printf(m, " %d:%d(%02x)", cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
+			seq_printf(m, " %d:%llu(%02x)", cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
 			cmd = (Scsi_Cmnd *) cmd->host_scribble;
 		}
 	}
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 2260041..3ed03df 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1690,7 +1690,7 @@ NonFastPath:
 			 MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
 	}
 	io_request->RaidContext.VirtualDiskTgtId = cpu_to_le16(device_id);
-	io_request->LUN[1] = scmd->device->lun;
+	int_to_scsilun(scmd->device->lun, (struct scsi_lun *)io_request->LUN);
 }
 
 /**
@@ -1713,7 +1713,7 @@ megasas_build_io_fusion(struct megasas_instance *instance,
 	device_id = MEGASAS_DEV_INDEX(instance, scp);
 
 	/* Zero out some fields so they don't get reused */
-	io_request->LUN[1] = 0;
+	memset(io_request->LUN, 0x0, 8);
 	io_request->CDB.EEDP32.PrimaryReferenceTag = 0;
 	io_request->CDB.EEDP32.PrimaryApplicationTagMask = 0;
 	io_request->EEDPFlags = 0;
diff --git a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
index e8a04ae..7a6160f 100644
--- a/drivers/scsi/mesh.c
+++ b/drivers/scsi/mesh.c
@@ -1230,7 +1230,7 @@ static void handle_msgin(struct mesh_state *ms)
 				ms->msgphase = msg_out;
 			} else if (code != cmd->device->lun + IDENTIFY_BASE) {
 				printk(KERN_WARNING "mesh: lun mismatch "
-				       "(%d != %d) on reselection from "
+				       "(%d != %llu) on reselection from "
 				       "target %d\n", code - IDENTIFY_BASE,
 				       cmd->device->lun, ms->conn_tgt);
 			}
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 7d014b1..a7305ff 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -6633,7 +6633,7 @@ static void ncr_sir_to_redo(struct ncb *np, int num, struct ccb *cp)
 		**	patch requested size into sense command
 		*/
 		cp->sensecmd[0]		= 0x03;
-		cp->sensecmd[1]		= cmd->device->lun << 5;
+		cp->sensecmd[1]		= (cmd->device->lun & 0x7) << 5;
 		cp->sensecmd[4]		= sizeof(cp->sense_buf);
 
 		/*
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 0665f9c..50b086a 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -915,7 +915,7 @@ static int nsp32_queuecommand_lck(struct scsi_cmnd *SCpnt, void (*done)(struct s
 	int ret;
 
 	nsp32_dbg(NSP32_DEBUG_QUEUECOMMAND,
-		  "enter. target: 0x%x LUN: 0x%x cmnd: 0x%x cmndlen: 0x%x "
+		  "enter. target: 0x%x LUN: 0x%llu cmnd: 0x%x cmndlen: 0x%x "
 		  "use_sg: 0x%x reqbuf: 0x%lx reqlen: 0x%x",
 		  SCpnt->device->id, SCpnt->device->lun, SCpnt->cmnd[0], SCpnt->cmd_len,
 		  scsi_sg_count(SCpnt), scsi_sglist(SCpnt), scsi_bufflen(SCpnt));
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index 987fbb1..340ceff 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -195,7 +195,7 @@ static int nsp_queuecommand_lck(struct scsi_cmnd *SCpnt,
 	nsp_hw_data *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
 
 	nsp_dbg(NSP_DEBUG_QUEUECOMMAND,
-		"SCpnt=0x%p target=%d lun=%d sglist=0x%p bufflen=%d sg_count=%d",
+		"SCpnt=0x%p target=%d lun=%llu sglist=0x%p bufflen=%d sg_count=%d",
 		SCpnt, target, SCpnt->device->lun, scsi_sglist(SCpnt),
 		scsi_bufflen(SCpnt), scsi_sg_count(SCpnt));
 	//nsp_dbg(NSP_DEBUG_QUEUECOMMAND, "before CurrentSC=0x%p", data->CurrentSC);
diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index f5b5273..155f957 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -558,7 +558,7 @@ SYM53C500_queue_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 
 	DEB(printk("cmd=%02x, cmd_len=%02x, target=%02x, lun=%02x, bufflen=%d\n", 
 	    SCpnt->cmnd[0], SCpnt->cmd_len, SCpnt->device->id, 
-	    SCpnt->device->lun,  scsi_bufflen(SCpnt)));
+		   (u8)SCpnt->device->lun,  scsi_bufflen(SCpnt)));
 
 	VDEB(for (i = 0; i < SCpnt->cmd_len; i++)
 	    printk("cmd[%d]=%02x  ", i, SCpnt->cmnd[i]));
diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
index e6e2a30..ef23fab 100644
--- a/drivers/scsi/ps3rom.c
+++ b/drivers/scsi/ps3rom.c
@@ -78,7 +78,7 @@ static int ps3rom_slave_configure(struct scsi_device *scsi_dev)
 	struct ps3rom_private *priv = shost_priv(scsi_dev->host);
 	struct ps3_storage_device *dev = priv->dev;
 
-	dev_dbg(&dev->sbd.core, "%s:%u: id %u, lun %u, channel %u\n", __func__,
+	dev_dbg(&dev->sbd.core, "%s:%u: id %u, lun %llu, channel %u\n", __func__,
 		__LINE__, scsi_dev->id, scsi_dev->lun, scsi_dev->channel);
 
 	/*
diff --git a/drivers/scsi/sun3_NCR5380.c b/drivers/scsi/sun3_NCR5380.c
index 8822079..1a2367a 100644
--- a/drivers/scsi/sun3_NCR5380.c
+++ b/drivers/scsi/sun3_NCR5380.c
@@ -355,17 +355,18 @@ static void __init init_tags( void )
 
 static int is_lun_busy(struct scsi_cmnd *cmd, int should_be_tagged)
 {
+    u8 lun = cmd->device->lun;
     SETUP_HOSTDATA(cmd->device->host);
 
-    if (hostdata->busy[cmd->device->id] & (1 << cmd->device->lun))
+    if (hostdata->busy[cmd->device->id] & (1 << lun))
 	return( 1 );
     if (!should_be_tagged ||
 	!setup_use_tagged_queuing || !cmd->device->tagged_supported)
 	return( 0 );
-    if (TagAlloc[cmd->device->id][cmd->device->lun].nr_allocated >=
-	TagAlloc[cmd->device->id][cmd->device->lun].queue_size ) {
+    if (TagAlloc[cmd->device->id][lun].nr_allocated >=
+	TagAlloc[cmd->device->id][lun].queue_size ) {
 	dprintk(NDEBUG_TAGS,  "scsi%d: target %d lun %d: no free tags\n",
-		    H_NO(cmd), cmd->device->id, cmd->device->lun );
+		    H_NO(cmd), cmd->device->id, lun );
 	return( 1 );
     }
     return( 0 );
@@ -379,6 +380,7 @@ static int is_lun_busy(struct scsi_cmnd *cmd, int should_be_tagged)
 
 static void cmd_get_tag(struct scsi_cmnd *cmd, int should_be_tagged)
 {
+    u8 lun = cmd->device->lun;
     SETUP_HOSTDATA(cmd->device->host);
 
     /* If we or the target don't support tagged queuing, allocate the LUN for
@@ -387,19 +389,19 @@ static void cmd_get_tag(struct scsi_cmnd *cmd, int should_be_tagged)
     if (!should_be_tagged ||
 	!setup_use_tagged_queuing || !cmd->device->tagged_supported) {
 	cmd->tag = TAG_NONE;
-	hostdata->busy[cmd->device->id] |= (1 << cmd->device->lun);
+	hostdata->busy[cmd->device->id] |= (1 << lun);
 	dprintk(NDEBUG_TAGS,  "scsi%d: target %d lun %d now allocated by untagged "
-		    "command\n", H_NO(cmd), cmd->device->id, cmd->device->lun );
+		    "command\n", H_NO(cmd), cmd->device->id, lun );
     }
     else {
-	TAG_ALLOC *ta = &TagAlloc[cmd->device->id][cmd->device->lun];
+	TAG_ALLOC *ta = &TagAlloc[cmd->device->id][lun];
 
 	cmd->tag = find_first_zero_bit( &ta->allocated, MAX_TAGS );
 	set_bit( cmd->tag, &ta->allocated );
 	ta->nr_allocated++;
 	dprintk(NDEBUG_TAGS,  "scsi%d: using tag %d for target %d lun %d "
 		    "(now %d tags in use)\n",
-		    H_NO(cmd), cmd->tag, cmd->device->id, cmd->device->lun,
+		    H_NO(cmd), cmd->tag, cmd->device->id, lun,
 		    ta->nr_allocated );
     }
 }
@@ -411,23 +413,24 @@ static void cmd_get_tag(struct scsi_cmnd *cmd, int should_be_tagged)
 
 static void cmd_free_tag(struct scsi_cmnd *cmd)
 {
+    u8 lun = cmd->device->lun;
     SETUP_HOSTDATA(cmd->device->host);
 
     if (cmd->tag == TAG_NONE) {
-	hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
+	hostdata->busy[cmd->device->id] &= ~(1 << lun);
 	dprintk(NDEBUG_TAGS,  "scsi%d: target %d lun %d untagged cmd finished\n",
-		    H_NO(cmd), cmd->device->id, cmd->device->lun );
+		    H_NO(cmd), cmd->device->id, lun );
     }
     else if (cmd->tag >= MAX_TAGS) {
 	printk(KERN_NOTICE "scsi%d: trying to free bad tag %d!\n",
 		H_NO(cmd), cmd->tag );
     }
     else {
-	TAG_ALLOC *ta = &TagAlloc[cmd->device->id][cmd->device->lun];
+	TAG_ALLOC *ta = &TagAlloc[cmd->device->id][lun];
 	clear_bit( cmd->tag, &ta->allocated );
 	ta->nr_allocated--;
 	dprintk(NDEBUG_TAGS,  "scsi%d: freed tag %d for target %d lun %d\n",
-		    H_NO(cmd), cmd->tag, cmd->device->id, cmd->device->lun );
+		    H_NO(cmd), cmd->tag, cmd->device->id, lun );
     }
 }
 
@@ -659,7 +662,7 @@ static void lprint_Scsi_Cmnd(Scsi_Cmnd *cmd)
 {
 	int i, s;
 	unsigned char *command;
-	printk("scsi%d: destination target %d, lun %d\n",
+	printk("scsi%d: destination target %d, lun %llu\n",
 		H_NO(cmd), cmd->device->id, cmd->device->lun);
 	printk(KERN_CONT "        command = ");
 	command = cmd->cmnd;
@@ -705,7 +708,7 @@ static void show_Scsi_Cmnd(Scsi_Cmnd *cmd, struct seq_file *m)
 {
 	int i, s;
 	unsigned char *command;
-	seq_printf(m, "scsi%d: destination target %d, lun %d\n",
+	seq_printf(m, "scsi%d: destination target %d, lun %llu\n",
 		H_NO(cmd), cmd->device->id, cmd->device->lun);
 	seq_printf(m, "        command = ");
 	command = cmd->cmnd;
@@ -1007,7 +1010,7 @@ static void NCR5380_main (struct work_struct *bl)
 		 prev = NULL; tmp; prev = tmp, tmp = NEXT(tmp) ) {
 
 		if (prev != tmp)
-			dprintk(NDEBUG_LISTS, "MAIN tmp=%p   target=%d   busy=%d lun=%d\n", tmp, tmp->device->id, hostdata->busy[tmp->device->id], tmp->device->lun);
+			dprintk(NDEBUG_LISTS, "MAIN tmp=%p   target=%d   busy=%d lun=%llu\n", tmp, tmp->device->id, hostdata->busy[tmp->device->id], tmp->device->lun);
 		/*  When we find one, remove it from the issue queue. */
 		/* ++guenther: possible race with Falcon locking */
 		if (
@@ -1038,7 +1041,7 @@ static void NCR5380_main (struct work_struct *bl)
 		     *   issue queue so we can keep trying.	
 		     */
 		    dprintk(NDEBUG_MAIN, "scsi%d: main(): command for target %d "
-				"lun %d removed from issue_queue\n",
+				"lun %llu removed from issue_queue\n",
 				HOSTNO, tmp->device->id, tmp->device->lun);
 		    /* 
 		     * REQUEST SENSE commands are issued without tagged
@@ -2020,7 +2023,7 @@ static void NCR5380_information_transfer (struct Scsi_Host *instance)
 			 * accesses to this device will use the
 			 * polled-IO. */ 
 			printk(KERN_NOTICE "scsi%d: switching target %d "
-			       "lun %d to slow handshake\n", HOSTNO,
+			       "lun %llu to slow handshake\n", HOSTNO,
 			       cmd->device->id, cmd->device->lun);
 			cmd->device->borken = 1;
 			NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | 
@@ -2078,7 +2081,7 @@ static void NCR5380_information_transfer (struct Scsi_Host *instance)
 		    /* Accept message by clearing ACK */
 		    NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		    
-		    dprintk(NDEBUG_LINKED, "scsi%d: target %d lun %d linked command "
+		    dprintk(NDEBUG_LINKED, "scsi%d: target %d lun %llu linked command "
 			       "complete.\n", HOSTNO, cmd->device->id, cmd->device->lun);
 
 		    /* Enable reselect interrupts */
@@ -2090,7 +2093,7 @@ static void NCR5380_information_transfer (struct Scsi_Host *instance)
 		     */
 
 		    if (!cmd->next_link) {
-			 printk(KERN_NOTICE "scsi%d: target %d lun %d "
+			 printk(KERN_NOTICE "scsi%d: target %d lun %llu "
 				"linked command complete, no next_link\n",
 				HOSTNO, cmd->device->id, cmd->device->lun);
 			    sink = 1;
@@ -2103,7 +2106,7 @@ static void NCR5380_information_transfer (struct Scsi_Host *instance)
 		     * and don't free it! */
 		    cmd->next_link->tag = cmd->tag;
 		    cmd->result = cmd->SCp.Status | (cmd->SCp.Message << 8); 
-		    dprintk(NDEBUG_LINKED, "scsi%d: target %d lun %d linked request "
+		    dprintk(NDEBUG_LINKED, "scsi%d: target %d lun %llu linked request "
 			       "done, calling scsi_done().\n",
 			       HOSTNO, cmd->device->id, cmd->device->lun);
 #ifdef NCR5380_STATS
@@ -2118,7 +2121,7 @@ static void NCR5380_information_transfer (struct Scsi_Host *instance)
 		    /* Accept message by clearing ACK */
 		    NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		    hostdata->connected = NULL;
-		    dprintk(NDEBUG_QUEUES, "scsi%d: command for target %d, lun %d "
+		    dprintk(NDEBUG_QUEUES, "scsi%d: command for target %d, lun %llu "
 			      "completed\n", HOSTNO, cmd->device->id, cmd->device->lun);
 #ifdef SUPPORT_TAGS
 		    cmd_free_tag( cmd );
@@ -2132,7 +2135,7 @@ static void NCR5380_information_transfer (struct Scsi_Host *instance)
 			/* ++Andreas: the mid level code knows about
 			   QUEUE_FULL now. */
 			TAG_ALLOC *ta = &TagAlloc[cmd->device->id][cmd->device->lun];
-			dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %d returned "
+			dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %llu returned "
 				   "QUEUE_FULL after %d commands\n",
 				   HOSTNO, cmd->device->id, cmd->device->lun,
 				   ta->nr_allocated);
@@ -2228,7 +2231,7 @@ static void NCR5380_information_transfer (struct Scsi_Host *instance)
 			cmd->device->tagged_supported = 0;
 			hostdata->busy[cmd->device->id] |= (1 << cmd->device->lun);
 			cmd->tag = TAG_NONE;
-			dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %d rejected "
+			dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %llu rejected "
 				   "QUEUE_TAG message; tagged queuing "
 				   "disabled\n",
 				   HOSTNO, cmd->device->id, cmd->device->lun);
@@ -2245,7 +2248,7 @@ static void NCR5380_information_transfer (struct Scsi_Host *instance)
 		    hostdata->connected = NULL;
 		    hostdata->disconnected_queue = cmd;
 		    local_irq_restore(flags);
-		    dprintk(NDEBUG_QUEUES, "scsi%d: command for target %d lun %d was "
+		    dprintk(NDEBUG_QUEUES, "scsi%d: command for target %d lun %llu was "
 			      "moved from connected to the "
 			      "disconnected_queue\n", HOSTNO, 
 			      cmd->device->id, cmd->device->lun);
@@ -2349,12 +2352,12 @@ static void NCR5380_information_transfer (struct Scsi_Host *instance)
 			printk("\n");
 		    } else if (tmp != EXTENDED_MESSAGE)
 			printk(KERN_DEBUG "scsi%d: rejecting unknown "
-			       "message %02x from target %d, lun %d\n",
+			       "message %02x from target %d, lun %llu\n",
 			       HOSTNO, tmp, cmd->device->id, cmd->device->lun);
 		    else
 			printk(KERN_DEBUG "scsi%d: rejecting unknown "
 			       "extended message "
-			       "code %02x, length %d from target %d, lun %d\n",
+			       "code %02x, length %d from target %d, lun %llu\n",
 			       HOSTNO, extended_msg[1], extended_msg[0],
 			       cmd->device->id, cmd->device->lun);
    
@@ -2576,7 +2579,7 @@ static void NCR5380_reselect (struct Scsi_Host *instance)
 #endif
     
     hostdata->connected = tmp;
-    dprintk(NDEBUG_RESELECTION, "scsi%d: nexus established, target = %d, lun = %d, tag = %d\n",
+    dprintk(NDEBUG_RESELECTION, "scsi%d: nexus established, target = %d, lun = %llu, tag = %d\n",
 	       HOSTNO, tmp->device->id, tmp->device->lun, tmp->tag);
 }
 
diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index b006cf7..7645757 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -621,7 +621,7 @@ dc390_StartSCSI( struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_sr
     {
 	dc390_freetag (pDCB, pSRB);
 	DEBUG0(printk ("DC390: Interrupt during Start SCSI (target %02i-%02i)\n",
-		scmd->device->id, scmd->device->lun));
+		       scmd->device->id, (u8)scmd->device->lun));
 	pSRB->SRBState = SRB_READY;
 	//DC390_write8 (ScsiCmd, CLEAR_FIFO_CMD);
 	pACB->SelLost++;
@@ -1726,7 +1726,7 @@ dc390_SRBdone( struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_srb*
 	    } else {
 		SET_RES_DRV(pcmd->result, DRIVER_SENSE);
 		//pSRB->ScsiCmdLen	 = (u8) (pSRB->Segment1[0] >> 8);
-		DEBUG0 (printk ("DC390: RETRY (%02x), target %02i-%02i\n", pcmd->cmnd[0], pcmd->device->id, pcmd->device->lun));
+		DEBUG0 (printk ("DC390: RETRY (%02x), target %02i-%02i\n", pcmd->cmnd[0], pcmd->device->id, (u8)pcmd->device->lun));
 		pSRB->TotalXferredLen = 0;
 		SET_RES_DID(pcmd->result, DID_SOFT_ERROR);
 	    }
@@ -1746,7 +1746,7 @@ dc390_SRBdone( struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_srb*
 	else if (status == SAM_STAT_TASK_SET_FULL)
 	{
 	    scsi_track_queue_full(pcmd->device, pDCB->GoingSRBCnt - 1);
-	    DEBUG0 (printk ("DC390: RETRY (%02x), target %02i-%02i\n", pcmd->cmnd[0], pcmd->device->id, pcmd->device->lun));
+	    DEBUG0 (printk ("DC390: RETRY (%02x), target %02i-%02i\n", pcmd->cmnd[0], pcmd->device->id, (u8)pcmd->device->lun));
 	    pSRB->TotalXferredLen = 0;
 	    SET_RES_DID(pcmd->result, DID_SOFT_ERROR);
 	}
diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index 5a03bb3..ea7b04a 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -1285,7 +1285,7 @@ static int u14_34f_queuecommand_lck(struct scsi_cmnd *SCpnt, void (*done)(struct
    cpp->cpp_index = i;
    SCpnt->host_scribble = (unsigned char *) &cpp->cpp_index;
 
-   if (do_trace) printk("%s: qcomm, mbox %d, target %d.%d:%d.\n",
+   if (do_trace) printk("%s: qcomm, mbox %d, target %d.%d:%llu.\n",
                         BN(j), i, SCpnt->device->channel, SCpnt->device->id,
                         SCpnt->device->lun);
 
@@ -1663,7 +1663,7 @@ static int reorder(unsigned int j, unsigned long cursec,
    if (link_statistics && (overlap || !(flushcount % link_statistics)))
       for (n = 0; n < n_ready; n++) {
          k = il[n]; cpp = &HD(j)->cp[k]; SCpnt = cpp->SCpnt;
-         printk("%s %d.%d:%d mb %d fc %d nr %d sec %ld ns %u"\
+         printk("%s %d.%d:%llu mb %d fc %d nr %d sec %ld ns %u"\
                 " cur %ld s:%c r:%c rev:%c in:%c ov:%c xd %d.\n",
                 (ihdlr ? "ihdlr" : "qcomm"), SCpnt->channel, SCpnt->target,
                 SCpnt->lun, k, flushcount, n_ready,
diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
index 41883a8..21222f6 100644
--- a/drivers/scsi/wd33c93.c
+++ b/drivers/scsi/wd33c93.c
@@ -895,7 +895,7 @@ wd33c93_intr(struct Scsi_Host *instance)
 
 		/* construct an IDENTIFY message with correct disconnect bit */
 
-		hostdata->outgoing_msg[0] = (0x80 | 0x00 | cmd->device->lun);
+		hostdata->outgoing_msg[0] = IDENTIFY(0, cmd->device->lun);
 		if (cmd->SCp.phase)
 			hostdata->outgoing_msg[0] |= 0x40;
 
@@ -2169,7 +2169,7 @@ wd33c93_show_info(struct seq_file *m, struct Scsi_Host *instance)
 		seq_printf(m, "\nconnected:     ");
 		if (hd->connected) {
 			cmd = (struct scsi_cmnd *) hd->connected;
-			seq_printf(m, " %d:%d(%02x)",
+			seq_printf(m, " %d:%llu(%02x)",
 				cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
 		}
 	}
@@ -2177,7 +2177,7 @@ wd33c93_show_info(struct seq_file *m, struct Scsi_Host *instance)
 		seq_printf(m, "\ninput_Q:       ");
 		cmd = (struct scsi_cmnd *) hd->input_Q;
 		while (cmd) {
-			seq_printf(m, " %d:%d(%02x)",
+			seq_printf(m, " %d:%llu(%02x)",
 				cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
 			cmd = (struct scsi_cmnd *) cmd->host_scribble;
 		}
@@ -2186,7 +2186,7 @@ wd33c93_show_info(struct seq_file *m, struct Scsi_Host *instance)
 		seq_printf(m, "\ndisconnected_Q:");
 		cmd = (struct scsi_cmnd *) hd->disconnected_Q;
 		while (cmd) {
-			seq_printf(m, " %d:%d(%02x)",
+			seq_printf(m, " %d:%llu(%02x)",
 				cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
 			cmd = (struct scsi_cmnd *) cmd->host_scribble;
 		}
-- 
1.7.12.4

