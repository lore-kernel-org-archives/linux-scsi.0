From: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: [PATCH 10/33][SCSI] cyberstorm: Convert 'Scsi_Cmnd' to 'struct scsi_cmnd'
Date: Sun, 6 Jan 2008 04:03:41 +0100 (MET)
Message-ID: <20080106030341.30002.60990.sendpatchset@thinktank.campus.ltu.se>
References: <20080106030250.30002.96493.sendpatchset@thinktank.campus.ltu.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gepetto.dc.ltu.se ([130.240.42.40]:53896 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbYAFDDx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Jan 2008 22:03:53 -0500
In-Reply-To: <20080106030250.30002.96493.sendpatchset@thinktank.campus.ltu.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: kernel-janitors@vger.kernel.org, trivial@kernel.org, linux-scsi@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>

Convert the typedef'ed 'Scsi_Cmnd' to 'struct scsi_cmnd'.

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Last item before 'drivers/scsi/scsi_typedefs.h' can be removed.


diff --git a/drivers/scsi/cyberstorm.c b/drivers/scsi/cyberstorm.c
index c6b98a4..3f8d1b0 100644
--- a/drivers/scsi/cyberstorm.c
+++ b/drivers/scsi/cyberstorm.c
@@ -79,7 +79,7 @@ struct cyber_dma_registers {
 #define CYBER_SLOW_CABLE 0x08	/* If *not* set, assume SLOW_CABLE */
 
 static int  dma_bytes_sent(struct NCR_ESP *esp, int fifo_count);
-static int  dma_can_transfer(struct NCR_ESP *esp, Scsi_Cmnd *sp);
+static int  dma_can_transfer(struct NCR_ESP *esp, struct scsi_cmnd *sp);
 static void dma_dump_state(struct NCR_ESP *esp);
 static void dma_init_read(struct NCR_ESP *esp, __u32 addr, int length);
 static void dma_init_write(struct NCR_ESP *esp, __u32 addr, int length);
@@ -206,7 +206,7 @@ static int dma_bytes_sent(struct NCR_ESP *esp, int fifo_count)
 	return fifo_count;
 }
 
-static int dma_can_transfer(struct NCR_ESP *esp, Scsi_Cmnd *sp)
+static int dma_can_transfer(struct NCR_ESP *esp, struct scsi_cmnd *sp)
 {
 	/* I don't think there's any limit on the CyberDMA. So we use what
 	 * the ESP chip can handle (24 bit).
