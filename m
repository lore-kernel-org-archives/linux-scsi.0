From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 9/10] test max hw sectors for REQ_PC commands
Date: Tue, 08 Nov 2005 04:06:54 -0600
Message-ID: <1131444414.23111.70.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:11935 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932504AbVKHKID (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2005 05:08:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de, linux-scsi@vger.kernel.org

for REQ_PC commands we want to test for max_hw_sectors.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/block/ll_rw_blk.c b/drivers/block/ll_rw_blk.c
index 6fd9121..bfcd501 100644
--- a/drivers/block/ll_rw_blk.c
+++ b/drivers/block/ll_rw_blk.c
@@ -1322,9 +1322,15 @@ static inline int ll_new_hw_segment(requ
 static int ll_back_merge_fn(request_queue_t *q, struct request *req, 
 			    struct bio *bio)
 {
+	unsigned short max_sectors;
 	int len;
 
-	if (req->nr_sectors + bio_sectors(bio) > q->max_sectors) {
+	if (unlikely(blk_pc_request(req)))
+		max_sectors = q->max_hw_sectors;
+	else
+		max_sectors = q->max_sectors;
+
+	if (req->nr_sectors + bio_sectors(bio) > max_sectors) {
 		req->flags |= REQ_NOMERGE;
 		if (req == q->last_merge)
 			q->last_merge = NULL;
@@ -1354,9 +1360,16 @@ static int ll_back_merge_fn(request_queu
 static int ll_front_merge_fn(request_queue_t *q, struct request *req, 
 			     struct bio *bio)
 {
+	unsigned short max_sectors;
 	int len;
 
-	if (req->nr_sectors + bio_sectors(bio) > q->max_sectors) {
+	if (unlikely(blk_pc_request(req)))
+		max_sectors = q->max_hw_sectors;
+	else
+		max_sectors = q->max_sectors;
+
+
+	if (req->nr_sectors + bio_sectors(bio) > max_sectors) {
 		req->flags |= REQ_NOMERGE;
 		if (req == q->last_merge)
 			q->last_merge = NULL;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 99cb09f..6248f3a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -461,6 +461,7 @@ int scsi_execute_async(struct scsi_devic
 	req = blk_get_request(sdev->request_queue, write, gfp);
 	if (!req)
 		goto free_sense;
+	req->flags |= REQ_BLOCK_PC | REQ_QUIET;
 
 	if (use_sg)
 		err = scsi_req_map_sg(req, buffer, use_sg, bufflen, gfp);
@@ -476,7 +477,6 @@ int scsi_execute_async(struct scsi_devic
 	req->sense_len = 0;
 	req->timeout = timeout;
 	req->retries = retries;
-	req->flags |= REQ_BLOCK_PC | REQ_QUIET;
 	req->end_io_data = sioc;
 
 	sioc->data = privdata;


