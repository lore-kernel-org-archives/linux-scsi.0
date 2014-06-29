From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/10] scsi: restructure command initialization for TYPE_FS requests
Date: Sun, 29 Jun 2014 15:34:33 +0200
Message-ID: <1404048881-19526-3-git-send-email-hch@lst.de>
References: <1404048881-19526-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:46562 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbaF2Nca (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jun 2014 09:32:30 -0400
In-Reply-To: <1404048881-19526-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

We should call the device handler prep_fn for all TYPE_FS requests,
not just simple read/write calls that are handled by the disk driver.

Restructure the common I/O code to call the prep_fn handler and zero
out the CDB, and just leave the call to scsi_init_io to the ULDs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c    |   22 ++++++++++++----------
 drivers/scsi/sd.c          |    2 +-
 drivers/scsi/sr.c          |    3 +--
 include/scsi/scsi_driver.h |    1 -
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b505b06..bc84811 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1115,11 +1115,10 @@ int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 EXPORT_SYMBOL(scsi_setup_blk_pc_cmnd);
 
 /*
- * Setup a REQ_TYPE_FS command.  These are simple read/write request
- * from filesystems that still need to be translated to SCSI CDBs from
- * the ULD.
+ * Setup a REQ_TYPE_FS command.  These are simple request from filesystems
+ * that still need to be translated to SCSI CDBs from the ULD.
  */
-int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req)
+static int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req)
 {
 	struct scsi_cmnd *cmd = req->special;
 
@@ -1131,9 +1130,8 @@ int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req)
 	}
 
 	memset(cmd->cmnd, 0, BLK_MAX_CDB);
-	return scsi_init_io(cmd, GFP_ATOMIC);
+	return scsi_cmd_to_driver(cmd)->init_command(cmd);
 }
-EXPORT_SYMBOL(scsi_setup_fs_cmnd);
 
 static int
 scsi_prep_state_check(struct scsi_device *sdev, struct request *req)
@@ -1238,12 +1236,16 @@ static int scsi_prep_fn(struct request_queue *q, struct request *req)
 		goto out;
 	}
 
-	if (req->cmd_type == REQ_TYPE_FS)
-		ret = scsi_cmd_to_driver(cmd)->init_command(cmd);
-	else if (req->cmd_type == REQ_TYPE_BLOCK_PC)
+	switch (req->cmd_type) {
+	case REQ_TYPE_FS:
+		ret = scsi_setup_fs_cmnd(sdev, req);
+		break;
+	case REQ_TYPE_BLOCK_PC:
 		ret = scsi_setup_blk_pc_cmnd(sdev, req);
-	else
+		break;
+	default:
 		ret = BLKPREP_KILL;
+	}
 
 out:
 	return scsi_prep_return(q, req, ret);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 9c86e3d..001b3e8 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -894,7 +894,7 @@ static int sd_init_command(struct scsi_cmnd *SCpnt)
 		ret = scsi_setup_flush_cmnd(sdp, rq);
 		goto out;
 	}
-	ret = scsi_setup_fs_cmnd(sdp, rq);
+	ret = scsi_init_io(SCpnt, GFP_ATOMIC);
 	if (ret != BLKPREP_OK)
 		goto out;
 	SCpnt = rq->special;
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index a7ea27c..9feeb37 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -385,10 +385,9 @@ static int sr_init_command(struct scsi_cmnd *SCpnt)
 	int block = 0, this_count, s_size;
 	struct scsi_cd *cd;
 	struct request *rq = SCpnt->request;
-	struct scsi_device *sdp = SCpnt->device;
 	int ret;
 
-	ret = scsi_setup_fs_cmnd(sdp, rq);
+	ret = scsi_init_io(SCpnt, GFP_ATOMIC);
 	if (ret != BLKPREP_OK)
 		goto out;
 	SCpnt = rq->special;
diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
index 36c4114..009d2ae 100644
--- a/include/scsi/scsi_driver.h
+++ b/include/scsi/scsi_driver.h
@@ -30,6 +30,5 @@ extern int scsi_register_interface(struct class_interface *);
 	class_interface_unregister(intf)
 
 int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req);
-int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req);
 
 #endif /* _SCSI_SCSI_DRIVER_H */
-- 
1.7.10.4

