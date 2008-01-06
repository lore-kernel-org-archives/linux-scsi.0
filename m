From: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: [PATCH 30/33][SCSI] sun3x_esp: Convert 'Scsi_Cmnd' to 'struct scsi_cmnd'
Date: Sun, 6 Jan 2008 04:05:23 +0100 (MET)
Message-ID: <20080106030523.30002.87000.sendpatchset@thinktank.campus.ltu.se>
References: <20080106030250.30002.96493.sendpatchset@thinktank.campus.ltu.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gepetto.dc.ltu.se ([130.240.42.40]:54046 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbYAFDFh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Jan 2008 22:05:37 -0500
In-Reply-To: <20080106030250.30002.96493.sendpatchset@thinktank.campus.ltu.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: kernel-janitors@vger.kernel.org, trivial@kernel.org, linux-scsi@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>

Convert the typedef'ed 'Scsi_Cmnd' to 'struct scsi_cmnd'.

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Last item before 'drivers/scsi/scsi_typedefs.h' can be removed.
Cleaned up checkpatch.pl-warnings.


diff --git a/drivers/scsi/sun3x_esp.c b/drivers/scsi/sun3x_esp.c
index 1bc4190..8a7d5a4 100644
--- a/drivers/scsi/sun3x_esp.c
+++ b/drivers/scsi/sun3x_esp.c
@@ -25,7 +25,7 @@
 
 static void dma_barrier(struct NCR_ESP *esp);
 static int  dma_bytes_sent(struct NCR_ESP *esp, int fifo_count);
-static int  dma_can_transfer(struct NCR_ESP *esp, Scsi_Cmnd *sp);
+static int  dma_can_transfer(struct NCR_ESP *esp, struct scsi_cmnd *sp);
 static void dma_drain(struct NCR_ESP *esp);
 static void dma_invalidate(struct NCR_ESP *esp);
 static void dma_dump_state(struct NCR_ESP *esp);
@@ -38,11 +38,11 @@ static void dma_poll(struct NCR_ESP *esp, unsigned char *vaddr);
 static int  dma_ports_p(struct NCR_ESP *esp);
 static void dma_reset(struct NCR_ESP *esp);
 static void dma_setup(struct NCR_ESP *esp, __u32 addr, int count, int write);
-static void dma_mmu_get_scsi_one (struct NCR_ESP *esp, Scsi_Cmnd *sp);
-static void dma_mmu_get_scsi_sgl (struct NCR_ESP *esp, Scsi_Cmnd *sp);
-static void dma_mmu_release_scsi_one (struct NCR_ESP *esp, Scsi_Cmnd *sp);
-static void dma_mmu_release_scsi_sgl (struct NCR_ESP *esp, Scsi_Cmnd *sp);
-static void dma_advance_sg (Scsi_Cmnd *sp);
+static void dma_mmu_get_scsi_one(struct NCR_ESP *esp, struct scsi_cmnd *sp);
+static void dma_mmu_get_scsi_sgl(struct NCR_ESP *esp, struct scsi_cmnd *sp);
+static void dma_mmu_release_scsi_one(struct NCR_ESP *esp, struct scsi_cmnd *sp);
+static void dma_mmu_release_scsi_sgl(struct NCR_ESP *esp, struct scsi_cmnd *sp);
+static void dma_advance_sg(struct scsi_cmnd *sp);
 
 /* Detecting ESP chips on the machine.  This is the simple and easy
  * version.
@@ -174,7 +174,7 @@ static int dma_bytes_sent(struct NCR_ESP *esp, int fifo_count)
 	return rval - fifo_count;
 }
 
-static int dma_can_transfer(struct NCR_ESP *esp, Scsi_Cmnd *sp)
+static int dma_can_transfer(struct NCR_ESP *esp, struct scsi_cmnd *sp)
 {
 	return sp->SCp.this_residual;
 }
@@ -319,14 +319,14 @@ static void dma_setup(struct NCR_ESP *esp, __u32 addr, int count, int write)
 	dregs->st_addr = addr;
 }
 
-static void dma_mmu_get_scsi_one (struct NCR_ESP *esp, Scsi_Cmnd *sp)
+static void dma_mmu_get_scsi_one(struct NCR_ESP *esp, struct scsi_cmnd *sp)
 {
     sp->SCp.have_data_in = dvma_map((unsigned long)sp->SCp.buffer,
 				       sp->SCp.this_residual);
     sp->SCp.ptr = (char *)((unsigned long)sp->SCp.have_data_in);
 }
 
-static void dma_mmu_get_scsi_sgl (struct NCR_ESP *esp, Scsi_Cmnd *sp)
+static void dma_mmu_get_scsi_sgl(struct NCR_ESP *esp, struct scsi_cmnd *sp)
 {
     int sz = sp->SCp.buffers_residual;
     struct scatterlist *sg = sp->SCp.buffer;
@@ -339,12 +339,12 @@ static void dma_mmu_get_scsi_sgl (struct NCR_ESP *esp, Scsi_Cmnd *sp)
     sp->SCp.ptr=(char *)((unsigned long)sp->SCp.buffer->dma_address);
 }
 
-static void dma_mmu_release_scsi_one (struct NCR_ESP *esp, Scsi_Cmnd *sp)
+static void dma_mmu_release_scsi_one(struct NCR_ESP *esp, struct scsi_cmnd *sp)
 {
     dvma_unmap((char *)sp->SCp.have_data_in);
 }
 
-static void dma_mmu_release_scsi_sgl (struct NCR_ESP *esp, Scsi_Cmnd *sp)
+static void dma_mmu_release_scsi_sgl(struct NCR_ESP *esp, struct scsi_cmnd *sp)
 {
     int sz = sp->use_sg - 1;
     struct scatterlist *sg = (struct scatterlist *)sp->request_buffer;
@@ -355,7 +355,7 @@ static void dma_mmu_release_scsi_sgl (struct NCR_ESP *esp, Scsi_Cmnd *sp)
     }
 }
 
-static void dma_advance_sg (Scsi_Cmnd *sp)
+static void dma_advance_sg(struct scsi_cmnd *sp)
 {
     sp->SCp.ptr = (char *)((unsigned long)sp->SCp.buffer->dma_address);
 }
