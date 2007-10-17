From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 23/32] scsi_debug: convert to use the data buffer accessors
Date: Wed, 17 Oct 2007 20:12:58 +0200
Message-ID: <471650AA.6040508@panasas.com>
References: <47164306.6090702@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:4885 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757600AbXJQSOC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 14:14:02 -0400
In-Reply-To: <47164306.6090702@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <tomof@acm.org>, Matthew Wilcox <matthew@wil.cx>, Matthew Dharm <mdharm-scsi@one-e>
Cc: Benny Halevy <bhalevy@panasas.com>, Pete Wyckoff <pw@osc.edu>


  - remove the unnecessary map_single path.
  - convert to use the new accessors for the sg lists and the
    parameters.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: FUJITA Tomonori <tomof@acm.org>
Signed-off-by: Douglas Gilbert <dougg@torque.net>
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
1.5.3.1


