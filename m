From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH] ips: sg chaining support to the path to non I/O commands
Date: Tue, 19 Feb 2008 18:41:30 +0900
Message-ID: <20080219184131V.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:58007 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756514AbYBSJyw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Feb 2008 04:54:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, Mark_Salyzyn@adaptec.com, lnxninja@linux.vnet.ibm.com, fujita.tomonori@lab.ntt.co.jp

Here is another ips patch, but not a bug fix.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] ips: sg chaining support to the path to non I/O commands

I overlooked ips_scmd_buf_write and ips_scmd_buf_read when I converted
ips to use the data buffer accessors.

ips is unlikely to use sg chaining (especially in this path) since a)
this path is used only for non I/O commands (with little data
transfer), b) ips's sg_tablesize is set to just 17.

Thanks to Tim Pepper for testing this patch.


Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Salyzyn, Mark <Mark_Salyzyn@adaptec.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/ips.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 7ed568f..e5467a4 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -3510,15 +3510,16 @@ ips_scmd_buf_write(struct scsi_cmnd *scmd, void *data, unsigned int count)
         struct scatterlist *sg = scsi_sglist(scmd);
 
         for (i = 0, xfer_cnt = 0;
-             (i < scsi_sg_count(scmd)) && (xfer_cnt < count); i++) {
-                min_cnt = min(count - xfer_cnt, sg[i].length);
+	(i < scsi_sg_count(scmd)) && (xfer_cnt < count);
+             i++, sg = sg_next(sg)) {
+                min_cnt = min(count - xfer_cnt, sg->length);
 
                 /* kmap_atomic() ensures addressability of the data buffer.*/
                 /* local_irq_save() protects the KM_IRQ0 address slot.     */
                 local_irq_save(flags);
-                buffer = kmap_atomic(sg_page(&sg[i]), KM_IRQ0) + sg[i].offset;
+		buffer = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
                 memcpy(buffer, &cdata[xfer_cnt], min_cnt);
-                kunmap_atomic(buffer - sg[i].offset, KM_IRQ0);
+		kunmap_atomic(buffer - sg->offset, KM_IRQ0);
                 local_irq_restore(flags);
 
                 xfer_cnt += min_cnt;
@@ -3543,15 +3544,16 @@ ips_scmd_buf_read(struct scsi_cmnd *scmd, void *data, unsigned int count)
         struct scatterlist *sg = scsi_sglist(scmd);
 
         for (i = 0, xfer_cnt = 0;
-             (i < scsi_sg_count(scmd)) && (xfer_cnt < count); i++) {
-                min_cnt = min(count - xfer_cnt, sg[i].length);
+             (i < scsi_sg_count(scmd)) && (xfer_cnt < count);
+             i++, sg = sg_next(sg)) {
+		min_cnt = min(count - xfer_cnt, sg->length);
 
                 /* kmap_atomic() ensures addressability of the data buffer.*/
                 /* local_irq_save() protects the KM_IRQ0 address slot.     */
                 local_irq_save(flags);
-                buffer = kmap_atomic(sg_page(&sg[i]), KM_IRQ0) + sg[i].offset;
+		buffer = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
                 memcpy(&cdata[xfer_cnt], buffer, min_cnt);
-                kunmap_atomic(buffer - sg[i].offset, KM_IRQ0);
+		kunmap_atomic(buffer - sg->offset, KM_IRQ0);
                 local_irq_restore(flags);
 
                 xfer_cnt += min_cnt;
-- 
1.5.3.7

