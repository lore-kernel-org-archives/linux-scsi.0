From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 13/24][RFC] aic7xxx_old: Use scsi_eh API for REQUEST_SENSE invocation
Date: Mon,  4 Feb 2008 19:09:40 +0200
Message-ID: <1202144980-5015-1-git-send-email-bharrosh@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:44921 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137AbYBDRP1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 12:15:27 -0500
In-Reply-To: 47A72A7F.1050301@panasas.com
References: 47A72A7F.1050301@panasas.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>J
Cc: Andrew Morton <akpm@linux-foundation.org>

  - Use scsi_eh_prep/restore_cmnd() for synchronous
    REQUEST_SENSE invocation.
  - Use new sense accessors where needed.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/aic7xxx_old.c |   74 ++++++++++++-------------------------------
 1 files changed, 21 insertions(+), 53 deletions(-)

diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
index 3bfd929..520d46a 100644
--- a/drivers/scsi/aic7xxx_old.c
+++ b/drivers/scsi/aic7xxx_old.c
@@ -786,10 +786,7 @@ struct aic7xxx_scb {
 	struct hw_scatterlist	*sg_list;	/* SG list in adapter format */
 	unsigned char		tag_action;
 	unsigned char		sg_count;
-	unsigned char		*sense_cmd;	/*
-						 * Allocate 6 characters for
-						 * sense command.
-						 */
+	struct scsi_eh_save	ses;
 	unsigned char		*cmnd;
 	unsigned int		sg_length;	/*
 						 * We init this during
@@ -823,9 +820,6 @@ static struct {
   { CIOPARERR, "CIOBUS Parity Error" }
 };
 
-static unsigned char
-generic_sense[] = { REQUEST_SENSE, 0, 0, 0, 255, 0 };
-
 typedef struct {
   scb_queue_type free_scbs;        /*
                                     * SCBs assigned to free slot on
@@ -1277,6 +1271,8 @@ static void aic7xxx_print_sequencer(struct aic7xxx_host *p, int downloaded);
 #ifdef AIC7XXX_VERBOSE_DEBUGGING
 static void aic7xxx_check_scbs(struct aic7xxx_host *p, char *buffer);
 #endif
+static void aic7xxx_buildscb(struct aic7xxx_host *p, struct scsi_cmnd *cmd,
+			     struct aic7xxx_scb *scb);
 
 /****************************************************************************
  *
@@ -2528,7 +2524,7 @@ static int
 aic7xxx_allocate_scb(struct aic7xxx_host *p)
 {
   struct aic7xxx_scb   *scbp = NULL;
-  int scb_size = (sizeof (struct hw_scatterlist) * AIC7XXX_MAX_SG) + 12 + 6;
+  int scb_size = (sizeof(struct hw_scatterlist) * AIC7XXX_MAX_SG) + 12;
   int i;
   int step = PAGE_SIZE / 1024;
   unsigned long scb_count = 0;
@@ -2598,9 +2594,8 @@ aic7xxx_allocate_scb(struct aic7xxx_host *p)
       scbp = &scb_ap[i];
       scbp->hscb = &p->scb_data->hscbs[p->scb_data->numscbs];
       scbp->sg_list = &hsgp[i * AIC7XXX_MAX_SG];
-      scbp->sense_cmd = bufs;
-      scbp->cmnd = bufs + 6;
-      bufs += 12 + 6;
+      scbp->cmnd = bufs;
+      bufs += 12;
       scbp->scb_dma = scb_dma;
       memset(scbp->hscb, 0, sizeof(struct aic7xxx_hwscb));
       scbp->hscb->tag = p->scb_data->numscbs;
@@ -2694,10 +2689,7 @@ aic7xxx_done(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
 
   if (scb->flags & SCB_SENSE)
   {
-    pci_unmap_single(p->pdev,
-                     le32_to_cpu(scb->sg_list[0].address),
-                     SCSI_SENSE_BUFFERSIZE,
-                     PCI_DMA_FROMDEVICE);
+	scsi_eh_restore_cmnd(cmd, &scb->ses);
   }
   if (scb->flags & SCB_RECOVERY_SCB)
   {
@@ -2720,8 +2712,8 @@ aic7xxx_done(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
      * after failing to negotiate a wide or sync transfer message.
      */
     if ((scb->flags & SCB_SENSE) && 
-          ((scb->cmd->sense_buffer[12] == 0x43) ||  /* INVALID_MESSAGE */
-          (scb->cmd->sense_buffer[12] == 0x49))) /* MESSAGE_ERROR  */
+          ((scsi_sense(scb->cmd)[12] == 0x43) ||  /* INVALID_MESSAGE */
+          (scsi_sense(scb->cmd)[12] == 0x49))) /* MESSAGE_ERROR  */
     {
       message_error = TRUE;
     }
@@ -4263,18 +4255,8 @@ aic7xxx_handle_seqint(struct aic7xxx_host *p, unsigned char intstat)
                  * Send a sense command to the requesting target.
                  * XXX - revisit this and get rid of the memcopys.
                  */
-                memcpy(scb->sense_cmd, &generic_sense[0],
-                       sizeof(generic_sense));
-
-                scb->sense_cmd[1] = (cmd->device->lun << 5);
-                scb->sense_cmd[4] = SCSI_SENSE_BUFFERSIZE;
-
-                scb->sg_list[0].length = 
-                  cpu_to_le32(SCSI_SENSE_BUFFERSIZE);
-		scb->sg_list[0].address =
-                        cpu_to_le32(pci_map_single(p->pdev, cmd->sense_buffer,
-                                                   SCSI_SENSE_BUFFERSIZE,
-                                                   PCI_DMA_FROMDEVICE));
+		scsi_eh_prep_cmnd(cmd, &scb->ses, NULL, 0, ~0);
+		aic7xxx_buildscb(p, cmd, scb);
 
                 /*
                  * XXX - We should allow disconnection, but can't as it
@@ -4283,21 +4265,6 @@ aic7xxx_handle_seqint(struct aic7xxx_host *p, unsigned char intstat)
                 /* hscb->control &= DISCENB; */
                 hscb->control = 0;
                 hscb->target_status = 0;
-                hscb->SG_list_pointer = 
-		  cpu_to_le32(SCB_DMA_ADDR(scb, scb->sg_list));
-                hscb->SCSI_cmd_pointer = 
-                  cpu_to_le32(SCB_DMA_ADDR(scb, scb->sense_cmd));
-                hscb->data_count = scb->sg_list[0].length;
-                hscb->data_pointer = scb->sg_list[0].address;
-                hscb->SCSI_cmd_length = COMMAND_SIZE(scb->sense_cmd[0]);
-                hscb->residual_SG_segment_count = 0;
-                hscb->residual_data_count[0] = 0;
-                hscb->residual_data_count[1] = 0;
-                hscb->residual_data_count[2] = 0;
-
-                scb->sg_count = hscb->SG_segment_count = 1;
-                scb->sg_length = SCSI_SENSE_BUFFERSIZE;
-                scb->tag_action = 0;
                 scb->flags |= SCB_SENSE;
                 /*
                  * Ensure the target is busy since this will be an
@@ -6303,9 +6270,16 @@ aic7xxx_handle_command_completion_intr(struct aic7xxx_host *p)
        */
       scb->flags &= ~(SCB_ABORT|SCB_RESET);
     }
-    else if (scb->flags & SCB_SENSE)
+    cmd = scb->cmd;
+    if (scb->hscb->residual_SG_segment_count != 0)
+    {
+      aic7xxx_calculate_residual(p, scb);
+    }
+    cmd->result |= (aic7xxx_error(cmd) << 16);
+    aic7xxx_done(p, scb);
+    if (scb->flags & SCB_SENSE)
     {
-      char *buffer = &scb->cmd->sense_buffer[0];
+      const u8 *buffer = scsi_sense(cmd);
 
       if (buffer[12] == 0x47 || buffer[12] == 0x54)
       {
@@ -6317,13 +6291,6 @@ aic7xxx_handle_command_completion_intr(struct aic7xxx_host *p)
         aic_dev->needwdtr = aic_dev->needwdtr_copy;
       }
     }
-    cmd = scb->cmd;
-    if (scb->hscb->residual_SG_segment_count != 0)
-    {
-      aic7xxx_calculate_residual(p, scb);
-    }
-    cmd->result |= (aic7xxx_error(cmd) << 16);
-    aic7xxx_done(p, scb);
   }
 }
 
@@ -11141,6 +11108,7 @@ static struct scsi_host_template driver_template = {
 	.max_sectors		= 2048,
 	.cmd_per_lun		= 3,
 	.use_clustering		= ENABLE_CLUSTERING,
+	.sense_buffsize		= SCSI_SENSE_BUFFERSIZE,
 };
 
 #include "scsi_module.c"
-- 
1.5.3.3

