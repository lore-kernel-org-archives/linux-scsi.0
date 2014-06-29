From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/10] scsi: mark scsi_setup_blk_pc_cmnd static
Date: Sun, 29 Jun 2014 15:34:41 +0200
Message-ID: <1404048881-19526-11-git-send-email-hch@lst.de>
References: <1404048881-19526-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:46588 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbaF2Nch (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jun 2014 09:32:37 -0400
In-Reply-To: <1404048881-19526-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c    |    3 +--
 include/scsi/scsi_driver.h |    2 --
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ea23860..f0a3ef1 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1080,7 +1080,7 @@ static struct scsi_cmnd *scsi_get_cmd_from_req(struct scsi_device *sdev,
 	return cmd;
 }
 
-int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
+static int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 {
 	struct scsi_cmnd *cmd = req->special;
 
@@ -1105,7 +1105,6 @@ int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 	cmd->allowed = req->retries;
 	return BLKPREP_OK;
 }
-EXPORT_SYMBOL(scsi_setup_blk_pc_cmnd);
 
 /*
  * Setup a REQ_TYPE_FS command.  These are simple request from filesystems
diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
index 009d2ae..c2b7598 100644
--- a/include/scsi/scsi_driver.h
+++ b/include/scsi/scsi_driver.h
@@ -29,6 +29,4 @@ extern int scsi_register_interface(struct class_interface *);
 #define scsi_unregister_interface(intf) \
 	class_interface_unregister(intf)
 
-int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req);
-
 #endif /* _SCSI_SCSI_DRIVER_H */
-- 
1.7.10.4

