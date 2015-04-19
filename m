From: Christoph Hellwig <hch@lst.de>
Subject: Re: BUG: unable to handle kernel NULL pointer deref, bisected to
	746650160
Date: Sun, 19 Apr 2015 18:58:41 +0200
Message-ID: <20150419165841.GA20332@lst.de>
References: <20150408183333.493607a3@goldlack.schiller106> <20150413174105.GA14988@lst.de> <20150413202829.580e3801@goldlack.schiller106>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ikeVEW9yuYc//A+q"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:33534 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbbDSQ6o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Apr 2015 12:58:44 -0400
Content-Disposition: inline
In-Reply-To: <20150413202829.580e3801@goldlack.schiller106>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Torsten Luettgert <ml-lkml@enda.eu>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This looks like a long standing bug in all three 3ware drivers to
me, that the taking the host lock around the host_busy manipulation
was hiding.

Can you test the patch below?

--ikeVEW9yuYc//A+q
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-3w-sas-fix-command-completion-race.patch"

>From b500f76e6f92722d8f1fc0de90961af730320953 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Sun, 19 Apr 2015 18:46:36 +0200
Subject: 3w-sas: fix command completion race

The 3w-sas driver needs to tear down the dma mappings before returning
the command to the midlayer, as there is no guarantee the sglist and
count are valid after that point.  Also remove the dma mapping helpers
which have another inherent race due to the request_id index.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/3w-sas.c | 50 ++++++++++----------------------------------------
 drivers/scsi/3w-sas.h |  4 ----
 2 files changed, 10 insertions(+), 44 deletions(-)

diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index 2361772..3d4c5f9 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -290,26 +290,6 @@ static int twl_post_command_packet(TW_Device_Extension *tw_dev, int request_id)
 	return 0;
 } /* End twl_post_command_packet() */
 
-/* This function will perform a pci-dma mapping for a scatter gather list */
-static int twl_map_scsi_sg_data(TW_Device_Extension *tw_dev, int request_id)
-{
-	int use_sg;
-	struct scsi_cmnd *cmd = tw_dev->srb[request_id];
-
-	use_sg = scsi_dma_map(cmd);
-	if (!use_sg)
-		return 0;
-	else if (use_sg < 0) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1, "Failed to map scatter gather list");
-		return 0;
-	}
-
-	cmd->SCp.phase = TW_PHASE_SGLIST;
-	cmd->SCp.have_data_in = use_sg;
-
-	return use_sg;
-} /* End twl_map_scsi_sg_data() */
-
 /* This function hands scsi cdb's to the firmware */
 static int twl_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int request_id, char *cdb, int use_sg, TW_SG_Entry_ISO *sglistarg)
 {
@@ -357,8 +337,8 @@ static int twl_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int request_id,
 	if (!sglistarg) {
 		/* Map sglist from scsi layer to cmd packet */
 		if (scsi_sg_count(srb)) {
-			sg_count = twl_map_scsi_sg_data(tw_dev, request_id);
-			if (sg_count == 0)
+			sg_count = scsi_dma_map(srb);
+			if (sg_count <= 0)
 				goto out;
 
 			scsi_for_each_sg(srb, sg, sg_count, i) {
@@ -1102,15 +1082,6 @@ out:
 	return retval;
 } /* End twl_initialize_device_extension() */
 
-/* This function will perform a pci-dma unmap */
-static void twl_unmap_scsi_data(TW_Device_Extension *tw_dev, int request_id)
-{
-	struct scsi_cmnd *cmd = tw_dev->srb[request_id];
-
-	if (cmd->SCp.phase == TW_PHASE_SGLIST)
-		scsi_dma_unmap(cmd);
-} /* End twl_unmap_scsi_data() */
-
 /* This function will handle attention interrupts */
 static int twl_handle_attention_interrupt(TW_Device_Extension *tw_dev)
 {
@@ -1251,11 +1222,11 @@ static irqreturn_t twl_interrupt(int irq, void *dev_instance)
 			}
 
 			/* Now complete the io */
+			scsi_dma_unmap(cmd);
+			cmd->scsi_done(cmd);
 			tw_dev->state[request_id] = TW_S_COMPLETED;
 			twl_free_request_id(tw_dev, request_id);
 			tw_dev->posted_request_count--;
-			tw_dev->srb[request_id]->scsi_done(tw_dev->srb[request_id]);
-			twl_unmap_scsi_data(tw_dev, request_id);
 		}
 
 		/* Check for another response interrupt */
@@ -1400,10 +1371,12 @@ static int twl_reset_device_extension(TW_Device_Extension *tw_dev, int ioctl_res
 		if ((tw_dev->state[i] != TW_S_FINISHED) &&
 		    (tw_dev->state[i] != TW_S_INITIAL) &&
 		    (tw_dev->state[i] != TW_S_COMPLETED)) {
-			if (tw_dev->srb[i]) {
-				tw_dev->srb[i]->result = (DID_RESET << 16);
-				tw_dev->srb[i]->scsi_done(tw_dev->srb[i]);
-				twl_unmap_scsi_data(tw_dev, i);
+		    	struct scsi_cmnd * cmd = tw_dev->srb[i];
+
+			if (cmd) {
+				cmd->result = (DID_RESET << 16);
+				scsi_dma_unmap(cmd);
+				cmd->scsi_done(cmd);
 			}
 		}
 	}
@@ -1507,9 +1480,6 @@ static int twl_scsi_queue_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_
 	/* Save the scsi command for use by the ISR */
 	tw_dev->srb[request_id] = SCpnt;
 
-	/* Initialize phase to zero */
-	SCpnt->SCp.phase = TW_PHASE_INITIAL;
-
 	retval = twl_scsiop_execute_scsi(tw_dev, request_id, NULL, 0, NULL);
 	if (retval) {
 		tw_dev->state[request_id] = TW_S_COMPLETED;
diff --git a/drivers/scsi/3w-sas.h b/drivers/scsi/3w-sas.h
index d474892..fec6449 100644
--- a/drivers/scsi/3w-sas.h
+++ b/drivers/scsi/3w-sas.h
@@ -103,10 +103,6 @@ static char *twl_aen_severity_table[] =
 #define TW_CURRENT_DRIVER_BUILD 0
 #define TW_CURRENT_DRIVER_BRANCH 0
 
-/* Phase defines */
-#define TW_PHASE_INITIAL 0
-#define TW_PHASE_SGLIST  2
-
 /* Misc defines */
 #define TW_SECTOR_SIZE                        512
 #define TW_MAX_UNITS			      32
-- 
1.9.1


--ikeVEW9yuYc//A+q--
