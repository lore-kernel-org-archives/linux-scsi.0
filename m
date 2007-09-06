From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 4/9] scsi_debug: convert to use the data buffer accessors
Date: Fri, 7 Sep 2007 06:50:20 +0900
Message-ID: <20070906183616C.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:60561 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932512AbXIFVwy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Sep 2007 17:52:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dougg@torque.net, jens.axboe@oracle.com, James.Bottomley@SteelEye.com, bharrosh@panasas.com, fujita.tomonori@lab.ntt.co.jp

From: Boaz Harrosh <bharrosh@panasas.com>

- remove the unnecessary map_single path.

- convert to use the new accessors for the sg lists and the
parameters.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_debug.c |   36 ++++++++++--------------------------
 1 files changed, 10 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 72ee4c9..c08ebf4 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -329,7 +329,7 @@ int scsi_debug_queuecommand(struct scsi_cmnd * SCpnt, done_funct_t done)
 	if (done == NULL)
 		return 0;	/* assume mid level reprocessing command */
 
-	SCpnt->resid = 0;
+	scsi_set_resid(SCpnt, 0);
 	if ((SCSI_DEBUG_OPT_NOISE & scsi_debug_opts) && cmd) {
 		printk(KERN_INFO "scsi_debug: cmd ");
 		for (k = 0, len = SCpnt->cmd_len; k < len; ++k)
@@ -603,26 +603,16 @@ static int fill_from_dev_buffer(struct scsi_cmnd * scp, unsigned char * arr,
 	void * kaddr_off;
 	struct scatterlist * sg;
 
-	if (0 == scp->request_bufflen)
+	if (0 == scsi_bufflen(scp))
 		return 0;
-	if (NULL == scp->request_buffer)
+	if (NULL == scsi_sglist(scp))
 		return (DID_ERROR << 16);
 	if (! ((scp->sc_data_direction == DMA_BIDIRECTIONAL) ||
 	      (scp->sc_data_direction == DMA_FROM_DEVICE)))
 		return (DID_ERROR << 16);
-	if (0 == scp->use_sg) {
-		req_len = scp->request_bufflen;
-		act_len = (req_len < arr_len) ? req_len : arr_len;
-		memcpy(scp->request_buffer, arr, act_len);
-		if (scp->resid)
-			scp->resid -= act_len;
-		else
-			scp->resid = req_len - act_len;
-		return 0;
-	}
 	active = 1;
 	req_len = act_len = 0;
-	scsi_for_each_sg(scp, sg, scp->use_sg, k) {
+	scsi_for_each_sg(scp, sg, scsi_sg_count(scp), k) {
 		if (active) {
 			kaddr = (unsigned char *)
 				kmap_atomic(sg->page, KM_USER0);
@@ -640,10 +630,10 @@ static int fill_from_dev_buffer(struct scsi_cmnd * scp, unsigned char * arr,
 		}
 		req_len += sg->length;
 	}
-	if (scp->resid)
-		scp->resid -= act_len;
+	if (scsi_get_resid(scp))
+		scsi_set_resid(scp, scsi_get_resid(scp) - act_len);
 	else
-		scp->resid = req_len - act_len;
+		scsi_set_resid(scp, req_len - act_len);
 	return 0;
 }
 
@@ -656,22 +646,16 @@ static int fetch_to_dev_buffer(struct scsi_cmnd * scp, unsigned char * arr,
 	void * kaddr_off;
 	struct scatterlist * sg;
 
-	if (0 == scp->request_bufflen)
+	if (0 == scsi_bufflen(scp))
 		return 0;
-	if (NULL == scp->request_buffer)
+	if (NULL == scsi_sglist(scp))
 		return -1;
 	if (! ((scp->sc_data_direction == DMA_BIDIRECTIONAL) ||
 	      (scp->sc_data_direction == DMA_TO_DEVICE)))
 		return -1;
-	if (0 == scp->use_sg) {
-		req_len = scp->request_bufflen;
-		len = (req_len < max_arr_len) ? req_len : max_arr_len;
-		memcpy(arr, scp->request_buffer, len);
-		return len;
-	}
 	sg = scsi_sglist(scp);
 	req_len = fin = 0;
-	for (k = 0; k < scp->use_sg; ++k, sg = sg_next(sg)) {
+	for (k = 0; k < scsi_sg_count(scp); ++k, sg = sg_next(sg)) {
 		kaddr = (unsigned char *)kmap_atomic(sg->page, KM_USER0);
 		if (NULL == kaddr)
 			return -1;
-- 
1.5.2.4

