From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH update] ieee1394: sbp2: stricter dma_sync
Date: Sat, 9 Aug 2008 20:13:00 +0200 (CEST)
Message-ID: <tkrat.5ee0a38d3bbf7b46@s5r6.in-berlin.de>
References: <tkrat.768de7e4b028b713@s5r6.in-berlin.de>
	<1217877676.3318.32.camel@localhost.localdomain>
	<48975F5F.90906@s5r6.in-berlin.de> <489845FC.4080104@panasas.com>
	<48986B55.80403@s5r6.in-berlin.de> <489871B7.5050904@panasas.com>
	<tkrat.4aaf6794a4dd49c1@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <tkrat.4aaf6794a4dd49c1@s5r6.in-berlin.de>
Content-Disposition: INLINE
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: linux1394-devel@lists.sourceforge.net
Cc: linux-scsi@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>
List-Id: linux-scsi@vger.kernel.org

Two dma_sync_single_for_cpu() were called in the wrong place.
Luckily they were merely for DMA_TO_DEVICE, hence nobody noticed.

Also reorder the matching dma_sync_single_for_device() a little bit
so that they reside in the same functions as their counterparts.
This also avoids syncing the s/g table for requests which don't use it.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Update:
  - I forgot to remove four calls of dma_sync_single_for_cpu.
  - Call the pointer to the controller dmadev instead of dev
    to avoid confusion with the logical unit's device pointer.

 drivers/ieee1394/sbp2.c |   50 ++++++++++++----------------------------
 1 file changed, 16 insertions(+), 34 deletions(-)

Index: linux-2.6.27-rc2/drivers/ieee1394/sbp2.c
===================================================================
--- linux-2.6.27-rc2.orig/drivers/ieee1394/sbp2.c
+++ linux-2.6.27-rc2/drivers/ieee1394/sbp2.c
@@ -1522,6 +1522,10 @@ static void sbp2_prep_command_orb_sg(str
 		orb->misc |= ORB_SET_PAGE_TABLE_PRESENT(0x1);
 		orb->data_descriptor_lo = cmd->sge_dma;
 
+		dma_sync_single_for_cpu(hi->host->device.parent, cmd->sge_dma,
+					sizeof(cmd->scatter_gather_element),
+					DMA_TO_DEVICE);
+
 		/* loop through and fill out our SBP-2 page tables
 		 * (and split up anything too large) */
 		for (i = 0, sg_count = 0; i < count; i++, sg = sg_next(sg)) {
@@ -1548,6 +1552,11 @@ static void sbp2_prep_command_orb_sg(str
 		sbp2util_cpu_to_be32_buffer(sg_element,
 				(sizeof(struct sbp2_unrestricted_page_table)) *
 				sg_count);
+
+		dma_sync_single_for_device(hi->host->device.parent,
+					   cmd->sge_dma,
+					   sizeof(cmd->scatter_gather_element),
+					   DMA_TO_DEVICE);
 	}
 }
 
@@ -1555,12 +1564,14 @@ static void sbp2_create_command_orb(stru
 				    struct sbp2_command_info *cmd,
 				    struct scsi_cmnd *SCpnt)
 {
-	struct sbp2_fwhost_info *hi = lu->hi;
+	struct device *dmadev = lu->hi->host->device.parent;
 	struct sbp2_command_orb *orb = &cmd->command_orb;
 	u32 orb_direction;
 	unsigned int scsi_request_bufflen = scsi_bufflen(SCpnt);
 	enum dma_data_direction dma_dir = SCpnt->sc_data_direction;
 
+	dma_sync_single_for_cpu(dmadev, cmd->command_orb_dma,
+				sizeof(struct sbp2_command_orb), DMA_TO_DEVICE);
 	/*
 	 * Set-up our command ORB.
 	 *
@@ -1592,7 +1603,7 @@ static void sbp2_create_command_orb(stru
 		orb->data_descriptor_lo = 0x0;
 		orb->misc |= ORB_SET_DIRECTION(1);
 	} else
-		sbp2_prep_command_orb_sg(orb, hi, cmd, scsi_sg_count(SCpnt),
+		sbp2_prep_command_orb_sg(orb, lu->hi, cmd, scsi_sg_count(SCpnt),
 					 scsi_sglist(SCpnt),
 					 orb_direction, dma_dir);
 
@@ -1600,6 +1611,9 @@ static void sbp2_create_command_orb(stru
 
 	memset(orb->cdb, 0, sizeof(orb->cdb));
 	memcpy(orb->cdb, SCpnt->cmnd, SCpnt->cmd_len);
+
+	dma_sync_single_for_device(dmadev, cmd->command_orb_dma,
+			sizeof(struct sbp2_command_orb), DMA_TO_DEVICE);
 }
 
 static void sbp2_link_orb_command(struct sbp2_lu *lu,
@@ -1613,14 +1627,6 @@ static void sbp2_link_orb_command(struct
 	size_t length;
 	unsigned long flags;
 
-	dma_sync_single_for_device(hi->host->device.parent,
-				   cmd->command_orb_dma,
-				   sizeof(struct sbp2_command_orb),
-				   DMA_TO_DEVICE);
-	dma_sync_single_for_device(hi->host->device.parent, cmd->sge_dma,
-				   sizeof(cmd->scatter_gather_element),
-				   DMA_TO_DEVICE);
-
 	/* check to see if there are any previous orbs to use */
 	spin_lock_irqsave(&lu->cmd_orb_lock, flags);
 	last_orb = lu->last_orb;
@@ -1778,13 +1784,6 @@ static int sbp2_handle_status_write(stru
 	else
 		cmd = sbp2util_find_command_for_orb(lu, sb->ORB_offset_lo);
 	if (cmd) {
-		dma_sync_single_for_cpu(hi->host->device.parent,
-					cmd->command_orb_dma,
-					sizeof(struct sbp2_command_orb),
-					DMA_TO_DEVICE);
-		dma_sync_single_for_cpu(hi->host->device.parent, cmd->sge_dma,
-					sizeof(cmd->scatter_gather_element),
-					DMA_TO_DEVICE);
 		/* Grab SCSI command pointers and check status. */
 		/*
 		 * FIXME: If the src field in the status is 1, the ORB DMA must
@@ -1901,7 +1900,6 @@ done:
 
 static void sbp2scsi_complete_all_commands(struct sbp2_lu *lu, u32 status)
 {
-	struct sbp2_fwhost_info *hi = lu->hi;
 	struct list_head *lh;
 	struct sbp2_command_info *cmd;
 	unsigned long flags;
@@ -1910,13 +1908,6 @@ static void sbp2scsi_complete_all_comman
 	while (!list_empty(&lu->cmd_orb_inuse)) {
 		lh = lu->cmd_orb_inuse.next;
 		cmd = list_entry(lh, struct sbp2_command_info, list);
-		dma_sync_single_for_cpu(hi->host->device.parent,
-				        cmd->command_orb_dma,
-					sizeof(struct sbp2_command_orb),
-					DMA_TO_DEVICE);
-		dma_sync_single_for_cpu(hi->host->device.parent, cmd->sge_dma,
-					sizeof(cmd->scatter_gather_element),
-					DMA_TO_DEVICE);
 		sbp2util_mark_command_completed(lu, cmd);
 		if (cmd->Current_SCpnt) {
 			cmd->Current_SCpnt->result = status << 16;
@@ -2038,7 +2029,6 @@ static void sbp2scsi_slave_destroy(struc
 static int sbp2scsi_abort(struct scsi_cmnd *SCpnt)
 {
 	struct sbp2_lu *lu = (struct sbp2_lu *)SCpnt->device->host->hostdata[0];
-	struct sbp2_fwhost_info *hi = lu->hi;
 	struct sbp2_command_info *cmd;
 	unsigned long flags;
 
@@ -2052,14 +2042,6 @@ static int sbp2scsi_abort(struct scsi_cm
 		spin_lock_irqsave(&lu->cmd_orb_lock, flags);
 		cmd = sbp2util_find_command_for_SCpnt(lu, SCpnt);
 		if (cmd) {
-			dma_sync_single_for_cpu(hi->host->device.parent,
-					cmd->command_orb_dma,
-					sizeof(struct sbp2_command_orb),
-					DMA_TO_DEVICE);
-			dma_sync_single_for_cpu(hi->host->device.parent,
-					cmd->sge_dma,
-					sizeof(cmd->scatter_gather_element),
-					DMA_TO_DEVICE);
 			sbp2util_mark_command_completed(lu, cmd);
 			if (cmd->Current_SCpnt) {
 				cmd->Current_SCpnt->result = DID_ABORT << 16;

-- 
Stefan Richter
-=====-==--- =--- -=--=
http://arcgraph.de/sr/


-------------------------------------------------------------------------
This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
Build the coolest Linux based applications with Moblin SDK & win great prizes
Grand prize is a trip for two to an Open Source event anywhere in the world
http://moblin-contest.org/redirect.php?banner_id=100&url=/
