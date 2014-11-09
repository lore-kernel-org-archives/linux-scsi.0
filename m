From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 1/2] scsi: introduce force_blk_mq
Date: Mon, 10 Nov 2014 00:57:03 +0800
Message-ID: <1415552224-31145-2-git-send-email-ming.lei@canonical.com>
References: <1415552224-31145-1-git-send-email-ming.lei@canonical.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:52496 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbaKIQ5Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Nov 2014 11:57:24 -0500
Received: by mail-pa0-f47.google.com with SMTP id kx10so6659459pab.34
        for <linux-scsi@vger.kernel.org>; Sun, 09 Nov 2014 08:57:23 -0800 (PST)
In-Reply-To: <1415552224-31145-1-git-send-email-ming.lei@canonical.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Ming Lei <ming.lei@canonical.com>

>From scsi driver view, it is a bit troublesome to support both
blk-mq and non-blk-mq at the same time, especially when drivers
start to support multi hw-queue.

This patch introduces 'force_blk_mq' to scsi_host_template
so that drivers can provide blk-mq only support, and avoid
to consider legacy support.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/scsi/hosts.c     |    3 ++-
 include/scsi/scsi_host.h |    3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 06030e1..d2b83f8 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -459,7 +459,8 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	else
 		shost->dma_boundary = 0xffffffff;
 
-	shost->use_blk_mq = scsi_use_blk_mq && !shost->hostt->disable_blk_mq;
+	shost->use_blk_mq = (scsi_use_blk_mq && !shost->hostt->disable_blk_mq)
+				|| shost->hostt->force_blk_mq;
 
 	device_initialize(&shost->shost_gendev);
 	dev_set_name(&shost->shost_gendev, "host%d", shost->host_no);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 537c431..75c1468 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -514,6 +514,9 @@ struct scsi_host_template {
 
 	/* temporary flag to disable blk-mq I/O path */
 	bool disable_blk_mq;
+
+	/* tell scsi core we only support blk-mq */
+	bool force_blk_mq;
 };
 
 /*
-- 
1.7.9.5

