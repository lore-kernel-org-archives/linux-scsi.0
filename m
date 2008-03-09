From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 10/10] 3w-9xxx: use sg buffer copy helper functions
Date: Sun,  9 Mar 2008 13:44:37 +0900
Message-ID: <1205037877-12843-11-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1205037877-12843-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205037877-12843-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205037877-12843-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205037877-12843-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205037877-12843-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205037877-12843-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205037877-12843-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205037877-12843-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205037877-12843-9-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205037877-12843-10-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:50220 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267AbYCIEqE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Mar 2008 23:46:04 -0500
In-Reply-To: <1205037877-12843-10-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Adam Radford <linuxraid@amcc.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Adam Radford <linuxraid@amcc.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/3w-9xxx.c |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index b4912d1..fa922f8 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -1838,12 +1838,11 @@ static int twa_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int request_id,
 		if (scsi_sg_count(srb)) {
 			if ((scsi_sg_count(srb) == 1) &&
 			    (scsi_bufflen(srb) < TW_MIN_SGL_LENGTH)) {
-				if (srb->sc_data_direction == DMA_TO_DEVICE || srb->sc_data_direction == DMA_BIDIRECTIONAL) {
-					struct scatterlist *sg = scsi_sglist(srb);
-					char *buf = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
-					memcpy(tw_dev->generic_buffer_virt[request_id], buf, sg->length);
-					kunmap_atomic(buf - sg->offset, KM_IRQ0);
-				}
+				if (srb->sc_data_direction == DMA_TO_DEVICE ||
+				    srb->sc_data_direction == DMA_BIDIRECTIONAL)
+					scsi_sg_copy_to_buffer(srb,
+							       tw_dev->generic_buffer_virt[request_id],
+							       TW_SECTOR_SIZE);
 				command_packet->sg_list[0].address = TW_CPU_TO_SGL(tw_dev->generic_buffer_phys[request_id]);
 				command_packet->sg_list[0].length = cpu_to_le32(TW_MIN_SGL_LENGTH);
 			} else {
@@ -1915,13 +1914,11 @@ static void twa_scsiop_execute_scsi_complete(TW_Device_Extension *tw_dev, int re
 	    (cmd->sc_data_direction == DMA_FROM_DEVICE ||
 	     cmd->sc_data_direction == DMA_BIDIRECTIONAL)) {
 		if (scsi_sg_count(cmd) == 1) {
-			struct scatterlist *sg = scsi_sglist(tw_dev->srb[request_id]);
-			char *buf;
-			unsigned long flags = 0;
+			unsigned long flags;
+			void *buf = tw_dev->generic_buffer_virt[request_id];
+
 			local_irq_save(flags);
-			buf = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
-			memcpy(buf, tw_dev->generic_buffer_virt[request_id], sg->length);
-			kunmap_atomic(buf - sg->offset, KM_IRQ0);
+			scsi_sg_copy_from_buffer(cmd, buf, TW_SECTOR_SIZE);
 			local_irq_restore(flags);
 		}
 	}
-- 
1.5.3.7

