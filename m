From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] scsi: remove the disable_blk_mq host flag
Date: Wed, 13 Jul 2016 13:19:05 +0900
Message-ID: <1468383545-28503-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42512 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbcGMETQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jul 2016 00:19:16 -0400
Received: from p7077-ipngn101marunouchi.tokyo.ocn.ne.jp ([114.177.62.77] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bNBde-0007HP-E8
	for linux-scsi@vger.kernel.org; Wed, 13 Jul 2016 04:19:10 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

We've had scsi-mq for 2.5 years now, so we can remove the unused flag
to disable the code on a per-host basis that was put in for unexpected
emergencies during bringup.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/hosts.c     | 2 --
 drivers/scsi/scsi.c      | 1 +
 include/scsi/scsi_host.h | 6 ++----
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 1547bd9..ba9af4a 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -486,8 +486,6 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	else
 		shost->dma_boundary = 0xffffffff;
 
-	shost->use_blk_mq = scsi_use_blk_mq && !shost->hostt->disable_blk_mq;
-
 	device_initialize(&shost->shost_gendev);
 	dev_set_name(&shost->shost_gendev, "host%d", shost->host_no);
 	shost->shost_gendev.bus = &scsi_bus_type;
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 1deb6ad..1f36aca 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1160,6 +1160,7 @@ bool scsi_use_blk_mq = true;
 bool scsi_use_blk_mq = false;
 #endif
 module_param_named(use_blk_mq, scsi_use_blk_mq, bool, S_IWUSR | S_IRUGO);
+EXPORT_SYMBOL_GPL(scsi_use_blk_mq);
 
 static int __init init_scsi(void)
 {
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 76e9d27..0dee7af 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -495,9 +495,6 @@ struct scsi_host_template {
 	 */
 	unsigned int cmd_size;
 	struct scsi_host_cmd_pool *cmd_pool;
-
-	/* temporary flag to disable blk-mq I/O path */
-	bool disable_blk_mq;
 };
 
 /*
@@ -778,7 +775,8 @@ extern bool scsi_use_blk_mq;
 
 static inline bool shost_use_blk_mq(struct Scsi_Host *shost)
 {
-	return shost->use_blk_mq;
+	return scsi_use_blk_mq;
+
 }
 
 extern int scsi_queue_work(struct Scsi_Host *, struct work_struct *);
-- 
2.1.4

