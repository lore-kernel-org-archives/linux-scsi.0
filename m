From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 03/10] scsi_debug: use sg buffer copy helper functions
Date: Sun,  9 Mar 2008 13:44:30 +0900
Message-ID: <1205037877-12843-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1205037877-12843-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205037877-12843-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205037877-12843-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:47279 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbYCIEqE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Mar 2008 23:46:04 -0500
In-Reply-To: <1205037877-12843-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@HansenPartnership.com>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi_debug.c |   79 +++++++-------------------------------------
 1 files changed, 13 insertions(+), 66 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 3abd286..7a2a3ed 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -591,81 +591,37 @@ static int check_readiness(struct scsi_cmnd * SCpnt, int reset_only,
 }
 
 /* Returns 0 if ok else (DID_ERROR << 16). Sets scp->resid . */
-static int fill_from_dev_buffer(struct scsi_cmnd * scp, unsigned char * arr,
+static int fill_from_dev_buffer(struct scsi_cmnd *scp, unsigned char *arr,
 				int arr_len)
 {
-	int k, req_len, act_len, len, active;
-	void * kaddr;
-	void * kaddr_off;
-	struct scatterlist *sg;
+	int act_len;
 	struct scsi_data_buffer *sdb = scsi_in(scp);
 
 	if (!sdb->length)
 		return 0;
-	if (!sdb->table.sgl)
-		return (DID_ERROR << 16);
 	if (!(scsi_bidi_cmnd(scp) || scp->sc_data_direction == DMA_FROM_DEVICE))
 		return (DID_ERROR << 16);
-	active = 1;
-	req_len = act_len = 0;
-	for_each_sg(sdb->table.sgl, sg, sdb->table.nents, k) {
-		if (active) {
-			kaddr = (unsigned char *)
-				kmap_atomic(sg_page(sg), KM_USER0);
-			if (NULL == kaddr)
-				return (DID_ERROR << 16);
-			kaddr_off = (unsigned char *)kaddr + sg->offset;
-			len = sg->length;
-			if ((req_len + len) > arr_len) {
-				active = 0;
-				len = arr_len - req_len;
-			}
-			memcpy(kaddr_off, arr + req_len, len);
-			kunmap_atomic(kaddr, KM_USER0);
-			act_len += len;
-		}
-		req_len += sg->length;
-	}
+
+	act_len = sg_copy_from_buffer(sdb->table.sgl, sdb->table.nents,
+				      arr, arr_len);
 	if (sdb->resid)
 		sdb->resid -= act_len;
 	else
-		sdb->resid = req_len - act_len;
+		sdb->resid = scsi_bufflen(scp) - act_len;
+
 	return 0;
 }
 
 /* Returns number of bytes fetched into 'arr' or -1 if error. */
-static int fetch_to_dev_buffer(struct scsi_cmnd * scp, unsigned char * arr,
-			       int max_arr_len)
+static int fetch_to_dev_buffer(struct scsi_cmnd *scp, unsigned char *arr,
+			       int arr_len)
 {
-	int k, req_len, len, fin;
-	void * kaddr;
-	void * kaddr_off;
-	struct scatterlist * sg;
-
-	if (0 == scsi_bufflen(scp))
+	if (!scsi_bufflen(scp))
 		return 0;
-	if (NULL == scsi_sglist(scp))
-		return -1;
 	if (!(scsi_bidi_cmnd(scp) || scp->sc_data_direction == DMA_TO_DEVICE))
 		return -1;
-	req_len = fin = 0;
-	scsi_for_each_sg(scp, sg, scsi_sg_count(scp), k) {
-		kaddr = (unsigned char *)kmap_atomic(sg_page(sg), KM_USER0);
-		if (NULL == kaddr)
-			return -1;
-		kaddr_off = (unsigned char *)kaddr + sg->offset;
-		len = sg->length;
-		if ((req_len + len) > max_arr_len) {
-			len = max_arr_len - req_len;
-			fin = 1;
-		}
-		memcpy(arr + req_len, kaddr_off, len);
-		kunmap_atomic(kaddr, KM_USER0);
-		if (fin)
-			return req_len + len;
-		req_len += sg->length;
-	}
-	return req_len;
+
+	return scsi_sg_copy_to_buffer(scp, arr, arr_len);
 }
 
 
@@ -1965,16 +1921,7 @@ static int resp_xdwriteread(struct scsi_cmnd *scp, unsigned long long lba,
 	if (!buf)
 		return ret;
 
-	offset = 0;
-	scsi_for_each_sg(scp, sg, scsi_sg_count(scp), i) {
-		kaddr = (unsigned char *)kmap_atomic(sg_page(sg), KM_USER0);
-		if (!kaddr)
-			goto out;
-
-		memcpy(buf + offset, kaddr + sg->offset, sg->length);
-		offset += sg->length;
-		kunmap_atomic(kaddr, KM_USER0);
-	}
+	scsi_sg_copy_to_buffer(scp, buf, scsi_bufflen(scp));
 
 	offset = 0;
 	for_each_sg(sdb->table.sgl, sg, sdb->table.nents, i) {
-- 
1.5.3.7

