From: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: [PATCH 28/33][SCSI] oktagon_esp: Convert 'Scsi_Cmnd' to 'struct scsi_cmnd'
Date: Sun, 6 Jan 2008 04:05:12 +0100 (MET)
Message-ID: <20080106030512.30002.83966.sendpatchset@thinktank.campus.ltu.se>
References: <20080106030250.30002.96493.sendpatchset@thinktank.campus.ltu.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gepetto.dc.ltu.se ([130.240.42.40]:54032 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388AbYAFDFZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Jan 2008 22:05:25 -0500
In-Reply-To: <20080106030250.30002.96493.sendpatchset@thinktank.campus.ltu.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: kernel-janitors@vger.kernel.org, trivial@kernel.org, linux-scsi@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>

Convert the typedef'ed 'Scsi_Cmnd' to 'struct scsi_cmnd'.

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Last item before 'drivers/scsi/scsi_typedefs.h' can be removed.
Cleaned up checkpatch.pl-errors.


diff --git a/drivers/scsi/oktagon_esp.c b/drivers/scsi/oktagon_esp.c
index 8e5eadb..9bc4eea 100644
--- a/drivers/scsi/oktagon_esp.c
+++ b/drivers/scsi/oktagon_esp.c
@@ -49,7 +49,7 @@
 
 
 static int  dma_bytes_sent(struct NCR_ESP *esp, int fifo_count);
-static int  dma_can_transfer(struct NCR_ESP *esp, Scsi_Cmnd *sp);
+static int  dma_can_transfer(struct NCR_ESP *esp, struct scsi_cmnd *sp);
 static void dma_dump_state(struct NCR_ESP *esp);
 static void dma_init_read(struct NCR_ESP *esp, __u32 vaddress, int length);
 static void dma_init_write(struct NCR_ESP *esp, __u32 vaddress, int length);
@@ -64,11 +64,11 @@ static void dma_setup(struct NCR_ESP *esp, __u32 addr, int count, int write);
 static void dma_irq_exit(struct NCR_ESP *esp);
 static void dma_invalidate(struct NCR_ESP *esp);
 
-static void dma_mmu_get_scsi_one(struct NCR_ESP *,Scsi_Cmnd *);
-static void dma_mmu_get_scsi_sgl(struct NCR_ESP *,Scsi_Cmnd *);
-static void dma_mmu_release_scsi_one(struct NCR_ESP *,Scsi_Cmnd *);
-static void dma_mmu_release_scsi_sgl(struct NCR_ESP *,Scsi_Cmnd *);
-static void dma_advance_sg(Scsi_Cmnd *);
+static void dma_mmu_get_scsi_one(struct NCR_ESP *, struct scsi_cmnd *);
+static void dma_mmu_get_scsi_sgl(struct NCR_ESP *, struct scsi_cmnd *);
+static void dma_mmu_release_scsi_one(struct NCR_ESP *, struct scsi_cmnd *);
+static void dma_mmu_release_scsi_sgl(struct NCR_ESP *, struct scsi_cmnd *);
+static void dma_advance_sg(struct scsi_cmnd *);
 static int  oktagon_notify_reboot(struct notifier_block *this, unsigned long code, void *x);
 
 #ifdef USE_BOTTOM_HALF
@@ -395,7 +395,7 @@ static int dma_bytes_sent(struct NCR_ESP *esp, int fifo_count)
 	return fifo_count;
 }
 
-static int dma_can_transfer(struct NCR_ESP *esp, Scsi_Cmnd *sp)
+static int dma_can_transfer(struct NCR_ESP *esp, struct scsi_cmnd *sp)
 {
 	unsigned long sz = sp->SCp.this_residual;
 	if(sz > DMA_MAXTRANSFER)
@@ -542,26 +542,26 @@ static void dma_invalidate(struct NCR_ESP *esp)
  * mmu interface to pass the virtual address, not the physical.
  */
 
-void dma_mmu_get_scsi_one(struct NCR_ESP *esp, Scsi_Cmnd *sp)
+void dma_mmu_get_scsi_one(struct NCR_ESP *esp, struct scsi_cmnd *sp)
 {
         sp->SCp.ptr =
                 sp->request_buffer;
 }
 
-void dma_mmu_get_scsi_sgl(struct NCR_ESP *esp, Scsi_Cmnd *sp)
+void dma_mmu_get_scsi_sgl(struct NCR_ESP *esp, struct scsi_cmnd *sp)
 {
         sp->SCp.ptr = sg_virt(sp->SCp.buffer);
 }
 
-void dma_mmu_release_scsi_one(struct NCR_ESP *esp, Scsi_Cmnd *sp)
+void dma_mmu_release_scsi_one(struct NCR_ESP *esp, struct scsi_cmnd *sp)
 {
 }
 
-void dma_mmu_release_scsi_sgl(struct NCR_ESP *esp, Scsi_Cmnd *sp)
+void dma_mmu_release_scsi_sgl(struct NCR_ESP *esp, struct scsi_cmnd *sp)
 {
 }
 
-void dma_advance_sg(Scsi_Cmnd *sp)
+void dma_advance_sg(struct scsi_cmnd *sp)
 {
 	sp->SCp.ptr = sg_virt(sp->SCp.buffer);
 }
