From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 04/10] ps3rom: use sg buffer copy helper funcitons
Date: Sun,  9 Mar 2008 13:44:31 +0900
Message-ID: <1205037877-12843-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1205037877-12843-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205037877-12843-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205037877-12843-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205037877-12843-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:47329 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbYCIEqo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Mar 2008 23:46:44 -0500
In-Reply-To: <1205037877-12843-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

Note that if scsi_bufflen(cmd) is not zero, the command always has an
sg list. So this patch doesn't do the error checking in
fill_from_dev_buffer and fetch_to_dev_buffer did.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/ps3rom.c |   92 +++++-------------------------------------------
 1 files changed, 10 insertions(+), 82 deletions(-)

diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
index 0eed5ca..d1e7845 100644
--- a/drivers/scsi/ps3rom.c
+++ b/drivers/scsi/ps3rom.c
@@ -90,76 +90,6 @@ static int ps3rom_slave_configure(struct scsi_device *scsi_dev)
 	return 0;
 }
 
-/*
- * copy data from device into scatter/gather buffer
- */
-static int fill_from_dev_buffer(struct scsi_cmnd *cmd, const void *buf)
-{
-	int k, req_len, len, fin;
-	void *kaddr;
-	struct scatterlist *sgpnt;
-	unsigned int buflen;
-
-	buflen = scsi_bufflen(cmd);
-	if (!buflen)
-		return 0;
-
-	if (!scsi_sglist(cmd))
-		return -1;
-
-	req_len = fin = 0;
-	scsi_for_each_sg(cmd, sgpnt, scsi_sg_count(cmd), k) {
-		kaddr = kmap_atomic(sg_page(sgpnt), KM_IRQ0);
-		len = sgpnt->length;
-		if ((req_len + len) > buflen) {
-			len = buflen - req_len;
-			fin = 1;
-		}
-		memcpy(kaddr + sgpnt->offset, buf + req_len, len);
-		flush_kernel_dcache_page(sg_page(sgpnt));
-		kunmap_atomic(kaddr, KM_IRQ0);
-		req_len += len;
-		if (fin)
-			break;
-	}
-	scsi_set_resid(cmd, buflen - req_len);
-	return 0;
-}
-
-/*
- * copy data from scatter/gather into device's buffer
- */
-static int fetch_to_dev_buffer(struct scsi_cmnd *cmd, void *buf)
-{
-	int k, req_len, len, fin;
-	void *kaddr;
-	struct scatterlist *sgpnt;
-	unsigned int buflen;
-
-	buflen = scsi_bufflen(cmd);
-	if (!buflen)
-		return 0;
-
-	if (!scsi_sglist(cmd))
-		return -1;
-
-	req_len = fin = 0;
-	scsi_for_each_sg(cmd, sgpnt, scsi_sg_count(cmd), k) {
-		kaddr = kmap_atomic(sg_page(sgpnt), KM_IRQ0);
-		len = sgpnt->length;
-		if ((req_len + len) > buflen) {
-			len = buflen - req_len;
-			fin = 1;
-		}
-		memcpy(buf + req_len, kaddr + sgpnt->offset, len);
-		kunmap_atomic(kaddr, KM_IRQ0);
-		if (fin)
-			return req_len + len;
-		req_len += sgpnt->length;
-	}
-	return req_len;
-}
-
 static int ps3rom_atapi_request(struct ps3_storage_device *dev,
 				struct scsi_cmnd *cmd)
 {
@@ -193,9 +123,7 @@ static int ps3rom_atapi_request(struct ps3_storage_device *dev,
 		else
 			atapi_cmnd.proto = PIO_DATA_OUT_PROTO;
 		atapi_cmnd.in_out = DIR_WRITE;
-		res = fetch_to_dev_buffer(cmd, dev->bounce_buf);
-		if (res < 0)
-			return DID_ERROR << 16;
+		scsi_sg_copy_to_buffer(cmd, dev->bounce_buf, dev->bounce_size);
 		break;
 
 	default:
@@ -267,9 +195,7 @@ static int ps3rom_write_request(struct ps3_storage_device *dev,
 	dev_dbg(&dev->sbd.core, "%s:%u: write %u sectors starting at %u\n",
 		__func__, __LINE__, sectors, start_sector);
 
-	res = fetch_to_dev_buffer(cmd, dev->bounce_buf);
-	if (res < 0)
-		return DID_ERROR << 16;
+	scsi_sg_copy_to_buffer(cmd, dev->bounce_buf, dev->bounce_size);
 
 	res = lv1_storage_write(dev->sbd.dev_id,
 				dev->regions[dev->region_idx].id, start_sector,
@@ -379,11 +305,13 @@ static irqreturn_t ps3rom_interrupt(int irq, void *data)
 	if (!status) {
 		/* OK, completed */
 		if (cmd->sc_data_direction == DMA_FROM_DEVICE) {
-			res = fill_from_dev_buffer(cmd, dev->bounce_buf);
-			if (res) {
-				cmd->result = DID_ERROR << 16;
-				goto done;
-			}
+			int len;
+
+			len = scsi_sg_copy_from_buffer(cmd,
+						       dev->bounce_buf,
+						       dev->bounce_size);
+
+			scsi_set_resid(cmd, scsi_bufflen(cmd) - len);
 		}
 		cmd->result = DID_OK << 16;
 		goto done;
@@ -425,7 +353,7 @@ static struct scsi_host_template ps3rom_host_template = {
 	.cmd_per_lun =		1,
 	.emulated =             1,		/* only sg driver uses this */
 	.max_sectors =		PS3ROM_MAX_SECTORS,
-	.use_clustering =	DISABLE_CLUSTERING,
+	.use_clustering =	ENABLE_CLUSTERING,
 	.module =		THIS_MODULE,
 };
 
-- 
1.5.3.7

