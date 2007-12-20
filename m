From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 5/5] sg_ring: Convert scsi_debug
Date: Thu, 20 Dec 2007 16:53:36 +1100
Message-ID: <200712201653.36632.rusty@rustcorp.com.au>
References: <200712201645.19035.rusty@rustcorp.com.au> <200712201650.42299.rusty@rustcorp.com.au> <200712201651.59283.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:34854 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758151AbXLTFxn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Dec 2007 00:53:43 -0500
In-Reply-To: <200712201651.59283.rusty@rustcorp.com.au>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Douglas Gilbert <dougg@torque.net>

Douglas Gilbert pointed out that converting scsi_debug would be a good
demonstration of the conversion required for other SCSI devices.

Details of the changes:
1) ->use_sg is replaced by ->sg, which if non-NULL, contains the sg_ring.
2) ->request_buffer can be NULL (it's only relevent if ->sg isn't set)
3) sg_ring_for_each is no longer required, just iterate directly over ->sg.
4) The iterator updates a struct sg_ring (sg) and an index (k), so previous
   references to sg become &sg->sg[k] (the k'th element within the sg_ring sg).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r c5fe2cab1d48 drivers/scsi/scsi_debug.c
--- a/drivers/scsi/scsi_debug.c	Thu Dec 20 13:12:43 2007 +1100
+++ b/drivers/scsi/scsi_debug.c	Thu Dec 20 13:39:24 2007 +1100
@@ -601,16 +601,16 @@ static int fill_from_dev_buffer(struct s
 	int k, req_len, act_len, len, active;
 	void * kaddr;
 	void * kaddr_off;
-	struct scatterlist * sg;
+	struct sg_ring * sg;
 
 	if (0 == scp->request_bufflen)
 		return 0;
-	if (NULL == scp->request_buffer)
-		return (DID_ERROR << 16);
 	if (! ((scp->sc_data_direction == DMA_BIDIRECTIONAL) ||
 	      (scp->sc_data_direction == DMA_FROM_DEVICE)))
 		return (DID_ERROR << 16);
-	if (0 == scp->use_sg) {
+	if (NULL == scp->sg) {
+		if (NULL == scp->request_buffer)
+			return (DID_ERROR << 16);
 		req_len = scp->request_bufflen;
 		act_len = (req_len < arr_len) ? req_len : arr_len;
 		memcpy(scp->request_buffer, arr, act_len);
@@ -622,14 +622,14 @@ static int fill_from_dev_buffer(struct s
 	}
 	active = 1;
 	req_len = act_len = 0;
-	scsi_for_each_sg(scp, sg, scp->use_sg, k) {
+	sg_ring_for_each(scp->sg, sg, k) {
 		if (active) {
 			kaddr = (unsigned char *)
-				kmap_atomic(sg_page(sg), KM_USER0);
+				kmap_atomic(sg_page(&sg->sg[k]), KM_USER0);
 			if (NULL == kaddr)
 				return (DID_ERROR << 16);
-			kaddr_off = (unsigned char *)kaddr + sg->offset;
-			len = sg->length;
+			kaddr_off = (unsigned char *)kaddr + sg->sg[k].offset;
+			len = sg->sg[k].length;
 			if ((req_len + len) > arr_len) {
 				active = 0;
 				len = arr_len - req_len;
@@ -638,7 +638,7 @@ static int fill_from_dev_buffer(struct s
 			kunmap_atomic(kaddr, KM_USER0);
 			act_len += len;
 		}
-		req_len += sg->length;
+		req_len += sg->sg[k].length;
 	}
 	if (scp->resid)
 		scp->resid -= act_len;
@@ -654,29 +654,29 @@ static int fetch_to_dev_buffer(struct sc
 	int k, req_len, len, fin;
 	void * kaddr;
 	void * kaddr_off;
-	struct scatterlist * sg;
+	struct sg_ring * sg;
 
 	if (0 == scp->request_bufflen)
 		return 0;
-	if (NULL == scp->request_buffer)
-		return -1;
 	if (! ((scp->sc_data_direction == DMA_BIDIRECTIONAL) ||
 	      (scp->sc_data_direction == DMA_TO_DEVICE)))
 		return -1;
-	if (0 == scp->use_sg) {
+	if (NULL == scp->sg) {
+		if (NULL == scp->request_buffer)
+			return -1;
 		req_len = scp->request_bufflen;
 		len = (req_len < max_arr_len) ? req_len : max_arr_len;
 		memcpy(arr, scp->request_buffer, len);
 		return len;
 	}
-	sg = scsi_sglist(scp);
 	req_len = fin = 0;
-	for (k = 0; k < scp->use_sg; ++k, sg = sg_next(sg)) {
-		kaddr = (unsigned char *)kmap_atomic(sg_page(sg), KM_USER0);
+	sg_ring_for_each(scp->sg, sg, k) {
+		kaddr = (unsigned char *)kmap_atomic(sg_page(&sg->sg[k]),
+						     KM_USER0);
 		if (NULL == kaddr)
 			return -1;
-		kaddr_off = (unsigned char *)kaddr + sg->offset;
-		len = sg->length;
+		kaddr_off = (unsigned char *)kaddr + sg->sg[k].offset;
+		len = sg->sg[k].length;
 		if ((req_len + len) > max_arr_len) {
 			len = max_arr_len - req_len;
 			fin = 1;
@@ -685,7 +685,7 @@ static int fetch_to_dev_buffer(struct sc
 		kunmap_atomic(kaddr, KM_USER0);
 		if (fin)
 			return req_len + len;
-		req_len += sg->length;
+		req_len += sg->sg[k].length;
 	}
 	return req_len;
 }
