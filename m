From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH] scsi_debug: convert to use the data buffer accessors and
 !use_sg cleanup
Date: Wed, 04 Jul 2007 21:28:01 +0300
Message-ID: <468BE6B1.6040807@panasas.com>
References: <468BE4CE.80402@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:47024 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755848AbXGDS2L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jul 2007 14:28:11 -0400
In-Reply-To: <468BE4CE.80402@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>


 scsi_debug is just a synthetic scsi target that simulate
 a scsi device and can inject errors to test the error
 handling paths in scsi-ml. As any scsi LLD it is converted
 to use the new data accessors.
 - Use of new data accessors
 - Clean of !use_sg code path.

 Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_debug.c |   46 +++++++++++++++-----------------------------
 1 files changed, 16 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 4cd9c58..1e2d6bb 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -328,7 +328,7 @@ int scsi_debug_queuecommand(struct scsi_cmnd * SCpnt, done_funct_t done)
 	if (done == NULL)
 		return 0;	/* assume mid level reprocessing command */

-	SCpnt->resid = 0;
+	scsi_set_resid(SCpnt, 0);
 	if ((SCSI_DEBUG_OPT_NOISE & scsi_debug_opts) && cmd) {
 		printk(KERN_INFO "scsi_debug: cmd ");
 		for (k = 0, len = SCpnt->cmd_len; k < len; ++k)
@@ -597,31 +597,22 @@ static int check_readiness(struct scsi_cmnd * SCpnt, int reset_only,
 static int fill_from_dev_buffer(struct scsi_cmnd * scp, unsigned char * arr,
 				int arr_len)
 {
-	int k, req_len, act_len, len, active;
+	int k, req_len, act_len, len, active, sg_count;
 	void * kaddr;
 	void * kaddr_off;
 	struct scatterlist * sgpnt;

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
-	sgpnt = (struct scatterlist *)scp->request_buffer;
+	sg_count = scsi_sg_count(scp);
 	active = 1;
-	for (k = 0, req_len = 0, act_len = 0; k < scp->use_sg; ++k, ++sgpnt) {
+	req_len = act_len = 0;
+	scsi_for_each_sg(scp, sgpnt, sg_count, k) {
 		if (active) {
 			kaddr = (unsigned char *)
 				kmap_atomic(sgpnt->page, KM_USER0);
@@ -639,10 +630,10 @@ static int fill_from_dev_buffer(struct scsi_cmnd * scp, unsigned char * arr,
 		}
 		req_len += sgpnt->length;
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

@@ -650,26 +641,21 @@ static int fill_from_dev_buffer(struct scsi_cmnd * scp, unsigned char * arr,
 static int fetch_to_dev_buffer(struct scsi_cmnd * scp, unsigned char * arr,
 			       int max_arr_len)
 {
-	int k, req_len, len, fin;
+	int k, req_len, len, fin, sg_count;
 	void * kaddr;
 	void * kaddr_off;
 	struct scatterlist * sgpnt;

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
-	sgpnt = (struct scatterlist *)scp->request_buffer;
-	for (k = 0, req_len = 0, fin = 0; k < scp->use_sg; ++k, ++sgpnt) {
+	sg_count = scsi_sg_count(scp);
+	req_len = fin = 0;
+	scsi_for_each_sg(scp, sgpnt, sg_count, k) {
 		kaddr = (unsigned char *)kmap_atomic(sgpnt->page, KM_USER0);
 		if (NULL == kaddr)
 			return -1;
-- 
1.5.2.2.249.g45fd


