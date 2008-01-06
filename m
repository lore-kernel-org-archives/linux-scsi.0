From: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: [PATCH 21/33][SCSI] mac_esp: Convert 'Scsi_Cmnd' to 'struct scsi_cmnd'
Date: Sun, 6 Jan 2008 04:04:37 +0100 (MET)
Message-ID: <20080106030437.30002.1410.sendpatchset@thinktank.campus.ltu.se>
References: <20080106030250.30002.96493.sendpatchset@thinktank.campus.ltu.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gepetto.dc.ltu.se ([130.240.42.40]:53976 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350AbYAFDEt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Jan 2008 22:04:49 -0500
In-Reply-To: <20080106030250.30002.96493.sendpatchset@thinktank.campus.ltu.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>

Convert the typedef'ed 'Scsi_Cmnd' to 'struct scsi_cmnd'.

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Last item before 'drivers/scsi/scsi_typedefs.h' can be removed.
Cleaned up checkpatch.pl-errors.


diff --git a/drivers/scsi/mac_esp.c b/drivers/scsi/mac_esp.c
index bcb4902..85f3d47 100644
--- a/drivers/scsi/mac_esp.c
+++ b/drivers/scsi/mac_esp.c
@@ -47,7 +47,7 @@ extern void esp_handle(struct NCR_ESP *esp);
 extern void mac_esp_intr(int irq, void *dev_id);
 
 static int  dma_bytes_sent(struct NCR_ESP * esp, int fifo_count);
-static int  dma_can_transfer(struct NCR_ESP * esp, Scsi_Cmnd *sp);
+static int  dma_can_transfer(struct NCR_ESP *esp, struct scsi_cmnd *sp);
 static void dma_dump_state(struct NCR_ESP * esp);
 static void dma_init_read(struct NCR_ESP * esp, char * vaddress, int length);
 static void dma_init_write(struct NCR_ESP * esp, char * vaddress, int length);
@@ -582,7 +582,7 @@ static int dma_bytes_sent(struct NCR_ESP * esp, int fifo_count)
  * is ever implemented. Returning 0 here will use PIO.
  */
 
-static int dma_can_transfer(struct NCR_ESP * esp, Scsi_Cmnd * sp)
+static int dma_can_transfer(struct NCR_ESP *esp, struct scsi_cmnd *sp)
 {
 	unsigned long sz = sp->SCp.this_residual;
 #if 0	/* no DMA yet; make conditional */
