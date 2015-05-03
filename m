From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.1-rc1
Date: Sun, 03 May 2015 09:14:08 -0700
Message-ID: <1430669648.2192.19.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59374 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750852AbbECQOM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 May 2015 12:14:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is three logical fixes (as 5 patches).  The 3ware class of drivers
were causing an oops with multiqueue by tearing down the command
mappings after completing the command (where the variables in the
command used to tear down the mapping were no-longer valid). There's
also a fix for the qnap iscsi target which was choking on us sending it
commands that were too long and a fix for the reworked aha1542
allocating GFP_KERNEL under a lock.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Christoph Hellwig (3):
      3w-9xxx: fix command completion race
      3w-xxxx: fix command completion race
      3w-sas: fix command completion race

Mike Christie (1):
      SCSI: add 1024 max sectors black list flag

Ondrej Zary (1):
      aha1542: Allocate memory before taking a lock

and the diffstat:

 drivers/scsi/3w-9xxx.c      | 57 +++++++++++----------------------------------
 drivers/scsi/3w-9xxx.h      |  5 ----
 drivers/scsi/3w-sas.c       | 50 ++++++++-------------------------------
 drivers/scsi/3w-sas.h       |  4 ----
 drivers/scsi/3w-xxxx.c      | 42 +++++----------------------------
 drivers/scsi/3w-xxxx.h      |  5 ----
 drivers/scsi/aha1542.c      | 23 +++++++++---------
 drivers/scsi/scsi_devinfo.c |  1 +
 drivers/scsi/scsi_scan.c    |  6 +++++
 include/scsi/scsi_devinfo.h |  1 +
 10 files changed, 48 insertions(+), 146 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 7600639..add419d 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -149,7 +149,6 @@ static int twa_reset_sequence(TW_Device_Extension *tw_dev, int soft_reset);
 static int twa_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int request_id, char *cdb, int use_sg, TW_SG_Entry *sglistarg);
 static void twa_scsiop_execute_scsi_complete(TW_Device_Extension *tw_dev, int request_id);
 static char *twa_string_lookup(twa_message_type *table, unsigned int aen_code);
-static void twa_unmap_scsi_data(TW_Device_Extension *tw_dev, int request_id);
 
 /* Functions */
 
@@ -1340,11 +1339,11 @@ static irqreturn_t twa_interrupt(int irq, void *dev_instance)
 				}
 
 				/* Now complete the io */
+				scsi_dma_unmap(cmd);
+				cmd->scsi_done(cmd);
 				tw_dev->state[request_id] = TW_S_COMPLETED;
 				twa_free_request_id(tw_dev, request_id);
 				tw_dev->posted_request_count--;
-				tw_dev->srb[request_id]->scsi_done(tw_dev->srb[request_id]);
-				twa_unmap_scsi_data(tw_dev, request_id);
 			}
 
 			/* Check for valid status after each drain */
@@ -1402,26 +1401,6 @@ static void twa_load_sgl(TW_Device_Extension *tw_dev, TW_Command_Full *full_comm
 	}
 } /* End twa_load_sgl() */
 
-/* This function will perform a pci-dma mapping for a scatter gather list */
-static int twa_map_scsi_sg_data(TW_Device_Extension *tw_dev, int request_id)
-{
-	int use_sg;
-	struct scsi_cmnd *cmd = tw_dev->srb[request_id];
-
-	use_sg = scsi_dma_map(cmd);
-	if (!use_sg)
-		return 0;
-	else if (use_sg < 0) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1c, "Failed to map scatter gather list");
-		return 0;
-	}
-
-	cmd->SCp.phase = TW_PHASE_SGLIST;
-	cmd->SCp.have_data_in = use_sg;
-
-	return use_sg;
-} /* End twa_map_scsi_sg_data() */
-
 /* This function will poll for a response interrupt of a request */
 static int twa_poll_response(TW_Device_Extension *tw_dev, int request_id, int seconds)
 {
@@ -1600,9 +1579,11 @@ static int twa_reset_device_extension(TW_Device_Extension *tw_dev)
 		    (tw_dev->state[i] != TW_S_INITIAL) &&
 		    (tw_dev->state[i] != TW_S_COMPLETED)) {
 			if (tw_dev->srb[i]) {
-				tw_dev->srb[i]->result = (DID_RESET << 16);
-				tw_dev->srb[i]->scsi_done(tw_dev->srb[i]);
-				twa_unmap_scsi_data(tw_dev, i);
+				struct scsi_cmnd *cmd = tw_dev->srb[i];
+
+				cmd->result = (DID_RESET << 16);
+				scsi_dma_unmap(cmd);
+				cmd->scsi_done(cmd);
 			}
 		}
 	}
@@ -1781,21 +1762,18 @@ static int twa_scsi_queue_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_
 	/* Save the scsi command for use by the ISR */
 	tw_dev->srb[request_id] = SCpnt;
 
-	/* Initialize phase to zero */
-	SCpnt->SCp.phase = TW_PHASE_INITIAL;
-
 	retval = twa_scsiop_execute_scsi(tw_dev, request_id, NULL, 0, NULL);
 	switch (retval) {
 	case SCSI_MLQUEUE_HOST_BUSY:
+		scsi_dma_unmap(SCpnt);
 		twa_free_request_id(tw_dev, request_id);
-		twa_unmap_scsi_data(tw_dev, request_id);
 		break;
 	case 1:
-		tw_dev->state[request_id] = TW_S_COMPLETED;
-		twa_free_request_id(tw_dev, request_id);
-		twa_unmap_scsi_data(tw_dev, request_id);
 		SCpnt->result = (DID_ERROR << 16);
+		scsi_dma_unmap(SCpnt);
 		done(SCpnt);
+		tw_dev->state[request_id] = TW_S_COMPLETED;
+		twa_free_request_id(tw_dev, request_id);
 		retval = 0;
 	}
 out:
@@ -1863,8 +1841,8 @@ static int twa_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int request_id,
 				command_packet->sg_list[0].address = TW_CPU_TO_SGL(tw_dev->generic_buffer_phys[request_id]);
 				command_packet->sg_list[0].length = cpu_to_le32(TW_MIN_SGL_LENGTH);
 			} else {
-				sg_count = twa_map_scsi_sg_data(tw_dev, request_id);
-				if (sg_count == 0)
+				sg_count = scsi_dma_map(srb);
+				if (sg_count < 0)
 					goto out;
 
 				scsi_for_each_sg(srb, sg, sg_count, i) {
@@ -1979,15 +1957,6 @@ static char *twa_string_lookup(twa_message_type *table, unsigned int code)
 	return(table[index].text);
 } /* End twa_string_lookup() */
 
-/* This function will perform a pci-dma unmap */
-static void twa_unmap_scsi_data(TW_Device_Extension *tw_dev, int request_id)
-{
-	struct scsi_cmnd *cmd = tw_dev->srb[request_id];
-
-	if (cmd->SCp.phase == TW_PHASE_SGLIST)
-		scsi_dma_unmap(cmd);
-} /* End twa_unmap_scsi_data() */
-
 /* This function gets called when a disk is coming on-line */
 static int twa_slave_configure(struct scsi_device *sdev)
 {
diff --git a/drivers/scsi/3w-9xxx.h b/drivers/scsi/3w-9xxx.h
index 040f721..0fdc83c 100644
--- a/drivers/scsi/3w-9xxx.h
+++ b/drivers/scsi/3w-9xxx.h
@@ -324,11 +324,6 @@ static twa_message_type twa_error_table[] = {
 #define TW_CURRENT_DRIVER_BUILD 0
 #define TW_CURRENT_DRIVER_BRANCH 0
 
-/* Phase defines */
-#define TW_PHASE_INITIAL 0
-#define TW_PHASE_SINGLE  1
-#define TW_PHASE_SGLIST  2
-
 /* Misc defines */
 #define TW_9550SX_DRAIN_COMPLETED	      0xFFFF
 #define TW_SECTOR_SIZE                        512
diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index 2361772..f837485 100644
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
+			struct scsi_cmnd *cmd = tw_dev->srb[i];
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
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index c75f204..2940bd7 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -1271,32 +1271,6 @@ static int tw_initialize_device_extension(TW_Device_Extension *tw_dev)
 	return 0;
 } /* End tw_initialize_device_extension() */
 
-static int tw_map_scsi_sg_data(struct pci_dev *pdev, struct scsi_cmnd *cmd)
-{
-	int use_sg;
-
-	dprintk(KERN_WARNING "3w-xxxx: tw_map_scsi_sg_data()\n");
-
-	use_sg = scsi_dma_map(cmd);
-	if (use_sg < 0) {
-		printk(KERN_WARNING "3w-xxxx: tw_map_scsi_sg_data(): pci_map_sg() failed.\n");
-		return 0;
-	}
-
-	cmd->SCp.phase = TW_PHASE_SGLIST;
-	cmd->SCp.have_data_in = use_sg;
-
-	return use_sg;
-} /* End tw_map_scsi_sg_data() */
-
-static void tw_unmap_scsi_data(struct pci_dev *pdev, struct scsi_cmnd *cmd)
-{
-	dprintk(KERN_WARNING "3w-xxxx: tw_unmap_scsi_data()\n");
-
-	if (cmd->SCp.phase == TW_PHASE_SGLIST)
-		scsi_dma_unmap(cmd);
-} /* End tw_unmap_scsi_data() */
-
 /* This function will reset a device extension */
 static int tw_reset_device_extension(TW_Device_Extension *tw_dev)
 {
@@ -1319,8 +1293,8 @@ static int tw_reset_device_extension(TW_Device_Extension *tw_dev)
 			srb = tw_dev->srb[i];
 			if (srb != NULL) {
 				srb->result = (DID_RESET << 16);
-				tw_dev->srb[i]->scsi_done(tw_dev->srb[i]);
-				tw_unmap_scsi_data(tw_dev->tw_pci_dev, tw_dev->srb[i]);
+				scsi_dma_unmap(srb);
+				srb->scsi_done(srb);
 			}
 		}
 	}
@@ -1767,8 +1741,8 @@ static int tw_scsiop_read_write(TW_Device_Extension *tw_dev, int request_id)
 	command_packet->byte8.io.lba = lba;
 	command_packet->byte6.block_count = num_sectors;
 
-	use_sg = tw_map_scsi_sg_data(tw_dev->tw_pci_dev, tw_dev->srb[request_id]);
-	if (!use_sg)
+	use_sg = scsi_dma_map(srb);
+	if (use_sg <= 0)
 		return 1;
 
 	scsi_for_each_sg(tw_dev->srb[request_id], sg, use_sg, i) {
@@ -1955,9 +1929,6 @@ static int tw_scsi_queue_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_c
 	/* Save the scsi command for use by the ISR */
 	tw_dev->srb[request_id] = SCpnt;
 
-	/* Initialize phase to zero */
-	SCpnt->SCp.phase = TW_PHASE_INITIAL;
-
 	switch (*command) {
 		case READ_10:
 		case READ_6:
@@ -2185,12 +2156,11 @@ static irqreturn_t tw_interrupt(int irq, void *dev_instance)
 
 				/* Now complete the io */
 				if ((error != TW_ISR_DONT_COMPLETE)) {
+					scsi_dma_unmap(tw_dev->srb[request_id]);
+					tw_dev->srb[request_id]->scsi_done(tw_dev->srb[request_id]);
 					tw_dev->state[request_id] = TW_S_COMPLETED;
 					tw_state_request_finish(tw_dev, request_id);
 					tw_dev->posted_request_count--;
-					tw_dev->srb[request_id]->scsi_done(tw_dev->srb[request_id]);
-					
-					tw_unmap_scsi_data(tw_dev->tw_pci_dev, tw_dev->srb[request_id]);
 				}
 			}
 				
diff --git a/drivers/scsi/3w-xxxx.h b/drivers/scsi/3w-xxxx.h
index 29b0b84e..6f65e66 100644
--- a/drivers/scsi/3w-xxxx.h
+++ b/drivers/scsi/3w-xxxx.h
@@ -195,11 +195,6 @@ static unsigned char tw_sense_table[][4] =
 #define TW_AEN_SMART_FAIL        0x000F
 #define TW_AEN_SBUF_FAIL         0x0024
 
-/* Phase defines */
-#define TW_PHASE_INITIAL 0
-#define TW_PHASE_SINGLE 1
-#define TW_PHASE_SGLIST 2
-
 /* Misc defines */
 #define TW_ALIGNMENT_6000		      64 /* 64 bytes */
 #define TW_ALIGNMENT_7000                     4  /* 4 bytes */
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index ec43276..b95d277 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -375,9 +375,10 @@ static int aha1542_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 	u8 lun = cmd->device->lun;
 	unsigned long flags;
 	int bufflen = scsi_bufflen(cmd);
-	int mbo;
+	int mbo, sg_count;
 	struct mailbox *mb = aha1542->mb;
 	struct ccb *ccb = aha1542->ccb;
+	struct chain *cptr;
 
 	if (*cmd->cmnd == REQUEST_SENSE) {
 		/* Don't do the command - we have the sense data already */
@@ -397,6 +398,13 @@ static int aha1542_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 		print_hex_dump_bytes("command: ", DUMP_PREFIX_NONE, cmd->cmnd, cmd->cmd_len);
 	}
 #endif
+	if (bufflen) {	/* allocate memory before taking host_lock */
+		sg_count = scsi_sg_count(cmd);
+		cptr = kmalloc(sizeof(*cptr) * sg_count, GFP_KERNEL | GFP_DMA);
+		if (!cptr)
+			return SCSI_MLQUEUE_HOST_BUSY;
+	}
+
 	/* Use the outgoing mailboxes in a round-robin fashion, because this
 	   is how the host adapter will scan for them */
 
@@ -441,19 +449,10 @@ static int aha1542_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 
 	if (bufflen) {
 		struct scatterlist *sg;
-		struct chain *cptr;
-		int i, sg_count = scsi_sg_count(cmd);
+		int i;
 
 		ccb[mbo].op = 2;	/* SCSI Initiator Command  w/scatter-gather */
-		cmd->host_scribble = kmalloc(sizeof(*cptr)*sg_count,
-		                                         GFP_KERNEL | GFP_DMA);
-		cptr = (struct chain *) cmd->host_scribble;
-		if (cptr == NULL) {
-			/* free the claimed mailbox slot */
-			aha1542->int_cmds[mbo] = NULL;
-			spin_unlock_irqrestore(sh->host_lock, flags);
-			return SCSI_MLQUEUE_HOST_BUSY;
-		}
+		cmd->host_scribble = (void *)cptr;
 		scsi_for_each_sg(cmd, sg, sg_count, i) {
 			any2scsi(cptr[i].dataptr, isa_page_to_bus(sg_page(sg))
 								+ sg->offset);
diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 262ab83..9f77d23 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -226,6 +226,7 @@ static struct {
 	{"PIONEER", "CD-ROM DRM-624X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"Promise", "VTrak E610f", NULL, BLIST_SPARSELUN | BLIST_NO_RSOC},
 	{"Promise", "", NULL, BLIST_SPARSELUN},
+	{"QNAP", "iSCSI Storage", NULL, BLIST_MAX_1024},
 	{"QUANTUM", "XP34301", "1071", BLIST_NOTQ},
 	{"REGAL", "CDC-4X", NULL, BLIST_MAX5LUN | BLIST_SINGLELUN},
 	{"SanDisk", "ImageMate CF-SD1", NULL, BLIST_FORCELUN},
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 60aae01..6efab1c 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -897,6 +897,12 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	 */
 	if (*bflags & BLIST_MAX_512)
 		blk_queue_max_hw_sectors(sdev->request_queue, 512);
+	/*
+	 * Max 1024 sector transfer length for targets that report incorrect
+	 * max/optimal lengths and relied on the old block layer safe default
+	 */
+	else if (*bflags & BLIST_MAX_1024)
+		blk_queue_max_hw_sectors(sdev->request_queue, 1024);
 
 	/*
 	 * Some devices may not want to have a start command automatically
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index 183eaab..96e3f56 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -36,5 +36,6 @@
 					     for sequential scan */
 #define BLIST_TRY_VPD_PAGES	0x10000000 /* Attempt to read VPD pages */
 #define BLIST_NO_RSOC		0x20000000 /* don't try to issue RSOC */
+#define BLIST_MAX_1024		0x40000000 /* maximum 1024 sector cdb length */
 
 #endif


