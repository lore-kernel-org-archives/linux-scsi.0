From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 06/10] ips: use sg buffer copy helper funcitons
Date: Sun,  9 Mar 2008 13:44:33 +0900
Message-ID: <1205037877-12843-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1205037877-12843-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205037877-12843-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205037877-12843-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205037877-12843-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205037877-12843-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205037877-12843-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:47268 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbYCIEqD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Mar 2008 23:46:03 -0500
In-Reply-To: <1205037877-12843-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

This rewrites ips_scmd_buf_write/read with scsi_sg_copy_from/to_buffer
respectively.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Salyzyn, Mark <Mark_Salyzyn@adaptec.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/ips.c |   50 ++++++++------------------------------------------
 1 files changed, 8 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 6264036..cc4f44f 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -3502,28 +3502,11 @@ ips_send_wait(ips_ha_t * ha, ips_scb_t * scb, int timeout, int intr)
 static void
 ips_scmd_buf_write(struct scsi_cmnd *scmd, void *data, unsigned int count)
 {
-        int i;
-        unsigned int min_cnt, xfer_cnt;
-        char *cdata = (char *) data;
-        unsigned char *buffer;
-        unsigned long flags;
-        struct scatterlist *sg = scsi_sglist(scmd);
-
-        for (i = 0, xfer_cnt = 0;
-	(i < scsi_sg_count(scmd)) && (xfer_cnt < count);
-             i++, sg = sg_next(sg)) {
-                min_cnt = min(count - xfer_cnt, sg->length);
-
-                /* kmap_atomic() ensures addressability of the data buffer.*/
-                /* local_irq_save() protects the KM_IRQ0 address slot.     */
-                local_irq_save(flags);
-		buffer = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
-                memcpy(buffer, &cdata[xfer_cnt], min_cnt);
-		kunmap_atomic(buffer - sg->offset, KM_IRQ0);
-                local_irq_restore(flags);
+	unsigned long flags;
 
-                xfer_cnt += min_cnt;
-        }
+	local_irq_save(flags);
+	scsi_sg_copy_from_buffer(scmd, data, count);
+	local_irq_restore(flags);
 }
 
 /****************************************************************************/
@@ -3536,28 +3519,11 @@ ips_scmd_buf_write(struct scsi_cmnd *scmd, void *data, unsigned int count)
 static void
 ips_scmd_buf_read(struct scsi_cmnd *scmd, void *data, unsigned int count)
 {
-        int i;
-        unsigned int min_cnt, xfer_cnt;
-        char *cdata = (char *) data;
-        unsigned char *buffer;
-        unsigned long flags;
-        struct scatterlist *sg = scsi_sglist(scmd);
-
-        for (i = 0, xfer_cnt = 0;
-             (i < scsi_sg_count(scmd)) && (xfer_cnt < count);
-             i++, sg = sg_next(sg)) {
-		min_cnt = min(count - xfer_cnt, sg->length);
-
-                /* kmap_atomic() ensures addressability of the data buffer.*/
-                /* local_irq_save() protects the KM_IRQ0 address slot.     */
-                local_irq_save(flags);
-		buffer = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
-                memcpy(&cdata[xfer_cnt], buffer, min_cnt);
-		kunmap_atomic(buffer - sg->offset, KM_IRQ0);
-                local_irq_restore(flags);
+	unsigned long flags;
 
-                xfer_cnt += min_cnt;
-        }
+	local_irq_save(flags);
+	scsi_sg_copy_to_buffer(scmd, data, count);
+	local_irq_restore(flags);
 }
 
 /****************************************************************************/
-- 
1.5.3.7

