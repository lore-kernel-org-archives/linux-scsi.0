From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/10] sd: split sd_init_command
Date: Sun, 29 Jun 2014 15:34:40 +0200
Message-ID: <1404048881-19526-10-git-send-email-hch@lst.de>
References: <1404048881-19526-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:46585 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbaF2Ncg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jun 2014 09:32:36 -0400
In-Reply-To: <1404048881-19526-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

Factor out a function to initialize regular read/write commands and leave
sd_init_command as a simple dispatcher to the different prepare routines.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c |   58 ++++++++++++++++++++++++++---------------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5f85102..ba756b1 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -877,21 +877,7 @@ static int sd_setup_flush_cmnd(struct scsi_cmnd *cmd)
 	return BLKPREP_OK;
 }
 
-static void sd_uninit_command(struct scsi_cmnd *SCpnt)
-{
-	struct request *rq = SCpnt->request;
-
-	if (rq->cmd_flags & REQ_DISCARD)
-		__free_page(rq->completion_data);
-
-	if (SCpnt->cmnd != rq->cmd) {
-		mempool_free(SCpnt->cmnd, sd_cdb_pool);
-		SCpnt->cmnd = NULL;
-		SCpnt->cmd_len = 0;
-	}
-}
-
-static int sd_init_command(struct scsi_cmnd *SCpnt)
+static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
 {
 	struct request *rq = SCpnt->request;
 	struct scsi_device *sdp = SCpnt->device;
@@ -903,20 +889,6 @@ static int sd_init_command(struct scsi_cmnd *SCpnt)
 	int ret, host_dif;
 	unsigned char protect;
 
-	/*
-	 * Discard request come in as REQ_TYPE_FS but we turn them into
-	 * block PC requests to make life easier.
-	 */
-	if (rq->cmd_flags & REQ_DISCARD) {
-		ret = sd_setup_discard_cmnd(SCpnt);
-		goto out;
-	} else if (rq->cmd_flags & REQ_WRITE_SAME) {
-		ret = sd_setup_write_same_cmnd(SCpnt);
-		goto out;
-	} else if (rq->cmd_flags & REQ_FLUSH) {
-		ret = sd_setup_flush_cmnd(SCpnt);
-		goto out;
-	}
 	ret = scsi_init_io(SCpnt, GFP_ATOMIC);
 	if (ret != BLKPREP_OK)
 		goto out;
@@ -1148,6 +1120,34 @@ static int sd_init_command(struct scsi_cmnd *SCpnt)
 	return ret;
 }
 
+static int sd_init_command(struct scsi_cmnd *cmd)
+{
+	struct request *rq = cmd->request;
+
+	if (rq->cmd_flags & REQ_DISCARD)
+		return sd_setup_discard_cmnd(cmd);
+	else if (rq->cmd_flags & REQ_WRITE_SAME)
+		return sd_setup_write_same_cmnd(cmd);
+	else if (rq->cmd_flags & REQ_FLUSH)
+		return sd_setup_flush_cmnd(cmd);
+	else
+		return sd_setup_read_write_cmnd(cmd);
+}
+
+static void sd_uninit_command(struct scsi_cmnd *SCpnt)
+{
+	struct request *rq = SCpnt->request;
+
+	if (rq->cmd_flags & REQ_DISCARD)
+		__free_page(rq->completion_data);
+
+	if (SCpnt->cmnd != rq->cmd) {
+		mempool_free(SCpnt->cmnd, sd_cdb_pool);
+		SCpnt->cmnd = NULL;
+		SCpnt->cmd_len = 0;
+	}
+}
+
 /**
  *	sd_open - open a scsi disk device
  *	@inode: only i_rdev member may be used
-- 
1.7.10.4

