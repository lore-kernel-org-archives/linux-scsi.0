From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/3] tcm/pscsi: Drop unnecessary struct pscsi_plugin_task->pscsi_req_bidi
Date: Mon,  8 Nov 2010 21:41:25 -0800
Message-ID: <1289281286-20476-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm3.bullet.mail.ac4.yahoo.com ([98.139.52.200]:46579 "HELO
	nm3.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751448Ab0KIFsK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2010 00:48:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, LIO-Target devel <linux-iscsi-target-dev@googlegroups.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch drops struct pscsi_plugin_task->pscsi_req_bidi and converts
__pscsi_map_task_SG() and pscsi_req_done() to use the already present
pt->pscsi_req->next_rq pointer.

Reported-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_pscsi.c |   21 ++++++++-------------
 drivers/target/target_core_pscsi.h |    1 -
 2 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index a1b9bf6..fa2c975 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1199,21 +1199,16 @@ static int __pscsi_map_task_SG(
 		return task->task_sg_num;
 	}
 	/*
-	 * Setup the secondary pt->pscsi_req_bidi used for the extra BIDI-COMMAND
+	 * Setup the secondary pt->pscsi_req->next_rq used for the extra BIDI-COMMAND
 	 * SCSI READ paylaod mapped for struct se_task->task_sg_bidi[]
 	 */
-	pt->pscsi_req_bidi = blk_make_request(pdv->pdv_sd->request_queue,
+	pt->pscsi_req->next_rq = blk_make_request(pdv->pdv_sd->request_queue,
 					hbio, GFP_KERNEL);
-	if (!(pt->pscsi_req_bidi)) {
+	if (!(pt->pscsi_req->next_rq)) {
 		printk(KERN_ERR "pSCSI: blk_make_request() failed for BIDI\n");
 		goto fail;
 	}
-	pscsi_blk_init_request(task, pt, pt->pscsi_req_bidi, 1);
-	/*
-	 * Setup the magic BIDI-COMMAND ->next_req pointer to the original
-	 * pt->pscsi_req.
-	 */	
-	pt->pscsi_req->next_rq = pt->pscsi_req_bidi;
+	pscsi_blk_init_request(task, pt, pt->pscsi_req->next_rq, 1);
 
 	return task->task_sg_num;
 fail:
@@ -1467,11 +1462,11 @@ static void pscsi_req_done(struct request *req, int uptodate)
 	pt->pscsi_resid = req->resid_len;
 
 	pscsi_process_SAM_status(task, pt);
-
-	if (req->next_rq != NULL) {
+	/*
+	 * Release BIDI-READ if present
+	 */
+	if (req->next_rq != NULL)
 		__blk_put_request(req->q, req->next_rq);
-		pt->pscsi_req_bidi = NULL;
-	}
 
 	__blk_put_request(req->q, req);
 	pt->pscsi_req = NULL;
diff --git a/drivers/target/target_core_pscsi.h b/drivers/target/target_core_pscsi.h
index f40d119..8d812fb 100644
--- a/drivers/target/target_core_pscsi.h
+++ b/drivers/target/target_core_pscsi.h
@@ -32,7 +32,6 @@ struct pscsi_plugin_task {
 	int	pscsi_result;
 	u32	pscsi_resid;
 	struct request *pscsi_req;
-	struct request *pscsi_req_bidi;
 } ____cacheline_aligned;
 
 #define PDF_HAS_CHANNEL_ID	0x01
-- 
1.5.6.5

