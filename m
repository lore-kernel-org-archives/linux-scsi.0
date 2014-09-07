From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/8] scsi: stop passing a gfp_mask argument down the command setup path
Date: Sun,  7 Sep 2014 09:31:05 -0700
Message-ID: <1410107469-896-5-git-send-email-hch@lst.de>
References: <1410107469-896-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:35029 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbaIGQ3D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Sep 2014 12:29:03 -0400
Received: from [50.247.105.171] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XQfKn-0006Sw-Mm
	for linux-scsi@vger.kernel.org; Sun, 07 Sep 2014 16:29:02 +0000
In-Reply-To: <1410107469-896-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

There is no reason for ULDs to pass in a flag on how to allocate the S/G
lists.  While we don't need GFP_ATOMIC for the blk-mq case because we
don't hold locks, that decision can be made way down the chain without
having to pass a pointless gfp_mask argument.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c  | 20 +++++++++-----------
 drivers/scsi/sd.c        |  6 +++---
 drivers/scsi/sr.c        |  2 +-
 include/scsi/scsi_cmnd.h |  2 +-
 4 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0062865..877ea3d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -587,10 +587,10 @@ static void scsi_free_sgtable(struct scsi_data_buffer *sdb, bool mq)
 	__sg_free_table(&sdb->table, SCSI_MAX_SG_SEGMENTS, mq, scsi_sg_free);
 }
 
-static int scsi_alloc_sgtable(struct scsi_data_buffer *sdb, int nents,
-			      gfp_t gfp_mask, bool mq)
+static int scsi_alloc_sgtable(struct scsi_data_buffer *sdb, int nents, bool mq)
 {
 	struct scatterlist *first_chunk = NULL;
+	gfp_t gfp_mask = mq ? GFP_NOIO : GFP_ATOMIC;
 	int ret;
 
 	BUG_ON(!nents);
@@ -1017,8 +1017,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	}
 }
 
-static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb,
-			     gfp_t gfp_mask)
+static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb)
 {
 	int count;
 
@@ -1026,7 +1025,7 @@ static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb,
 	 * If sg table allocation fails, requeue request later.
 	 */
 	if (unlikely(scsi_alloc_sgtable(sdb, req->nr_phys_segments,
-					gfp_mask, req->mq_ctx != NULL)))
+					req->mq_ctx != NULL)))
 		return BLKPREP_DEFER;
 
 	/* 
@@ -1051,7 +1050,7 @@ static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb,
  *		BLKPREP_DEFER if the failure is retryable
  *		BLKPREP_KILL if the failure is fatal
  */
-int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
+int scsi_init_io(struct scsi_cmnd *cmd)
 {
 	struct scsi_device *sdev = cmd->device;
 	struct request *rq = cmd->request;
@@ -1060,7 +1059,7 @@ int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 
 	BUG_ON(!rq->nr_phys_segments);
 
-	error = scsi_init_sgtable(rq, &cmd->sdb, gfp_mask);
+	error = scsi_init_sgtable(rq, &cmd->sdb);
 	if (error)
 		goto err_exit;
 
@@ -1076,8 +1075,7 @@ int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 			rq->next_rq->special = bidi_sdb;
 		}
 
-		error = scsi_init_sgtable(rq->next_rq, rq->next_rq->special,
-					  GFP_ATOMIC);
+		error = scsi_init_sgtable(rq->next_rq, rq->next_rq->special);
 		if (error)
 			goto err_exit;
 	}
@@ -1089,7 +1087,7 @@ int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 		BUG_ON(prot_sdb == NULL);
 		ivecs = blk_rq_count_integrity_sg(rq->q, rq->bio);
 
-		if (scsi_alloc_sgtable(prot_sdb, ivecs, gfp_mask, is_mq)) {
+		if (scsi_alloc_sgtable(prot_sdb, ivecs, is_mq)) {
 			error = BLKPREP_DEFER;
 			goto err_exit;
 		}
@@ -1156,7 +1154,7 @@ static int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 	 * submit a request without an attached bio.
 	 */
 	if (req->bio) {
-		int ret = scsi_init_io(cmd, GFP_ATOMIC);
+		int ret = scsi_init_io(cmd);
 		if (unlikely(ret))
 			return ret;
 	} else {
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index aa43496..6f7588d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -769,7 +769,7 @@ static int sd_setup_discard_cmnd(struct scsi_cmnd *cmd)
 	 * amount of blocks described by the request.
 	 */
 	blk_add_request_payload(rq, page, len);
-	ret = scsi_init_io(cmd, GFP_ATOMIC);
+	ret = scsi_init_io(cmd);
 	rq->__data_len = nr_bytes;
 
 out:
@@ -863,7 +863,7 @@ static int sd_setup_write_same_cmnd(struct scsi_cmnd *cmd)
 	 * knows how much to actually write.
 	 */
 	rq->__data_len = sdp->sector_size;
-	ret = scsi_init_io(cmd, GFP_ATOMIC);
+	ret = scsi_init_io(cmd);
 	rq->__data_len = nr_bytes;
 	return ret;
 }
@@ -896,7 +896,7 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
 	int ret, host_dif;
 	unsigned char protect;
 
-	ret = scsi_init_io(SCpnt, GFP_ATOMIC);
+	ret = scsi_init_io(SCpnt);
 	if (ret != BLKPREP_OK)
 		goto out;
 	SCpnt = rq->special;
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 7eeb936..5d1e3ac 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -387,7 +387,7 @@ static int sr_init_command(struct scsi_cmnd *SCpnt)
 	struct request *rq = SCpnt->request;
 	int ret;
 
-	ret = scsi_init_io(SCpnt, GFP_ATOMIC);
+	ret = scsi_init_io(SCpnt);
 	if (ret != BLKPREP_OK)
 		goto out;
 	SCpnt = rq->special;
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 73f3490..fb0a848 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -157,7 +157,7 @@ extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
 				 size_t *offset, size_t *len);
 extern void scsi_kunmap_atomic_sg(void *virt);
 
-extern int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask);
+extern int scsi_init_io(struct scsi_cmnd *cmd);
 
 extern int scsi_dma_map(struct scsi_cmnd *cmd);
 extern void scsi_dma_unmap(struct scsi_cmnd *cmd);
-- 
1.9.1

