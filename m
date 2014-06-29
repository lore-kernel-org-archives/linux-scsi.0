From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/10] scsi: move the nr_phys_segments assert into scsi_init_io
Date: Sun, 29 Jun 2014 15:34:32 +0200
Message-ID: <1404048881-19526-2-git-send-email-hch@lst.de>
References: <1404048881-19526-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:46559 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbaF2Nc3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jun 2014 09:32:29 -0400
In-Reply-To: <1404048881-19526-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

scsi_init_io should only be called for requests that transfer data,
so move the assert that a request has segments from the callers into
scsi_init_io.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 37038fb..b505b06 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -996,8 +996,11 @@ int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 {
 	struct scsi_device *sdev = cmd->device;
 	struct request *rq = cmd->request;
+	int error;
 
-	int error = scsi_init_sgtable(rq, &cmd->sdb, gfp_mask);
+	BUG_ON(!rq->nr_phys_segments);
+
+	error = scsi_init_sgtable(rq, &cmd->sdb, gfp_mask);
 	if (error)
 		goto err_exit;
 
@@ -1088,11 +1091,7 @@ int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 	 * submit a request without an attached bio.
 	 */
 	if (req->bio) {
-		int ret;
-
-		BUG_ON(!req->nr_phys_segments);
-
-		ret = scsi_init_io(cmd, GFP_ATOMIC);
+		int ret = scsi_init_io(cmd, GFP_ATOMIC);
 		if (unlikely(ret))
 			return ret;
 	} else {
@@ -1131,11 +1130,6 @@ int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req)
 			return ret;
 	}
 
-	/*
-	 * Filesystem requests must transfer data.
-	 */
-	BUG_ON(!req->nr_phys_segments);
-
 	memset(cmd->cmnd, 0, BLK_MAX_CDB);
 	return scsi_init_io(cmd, GFP_ATOMIC);
 }
-- 
1.7.10.4

