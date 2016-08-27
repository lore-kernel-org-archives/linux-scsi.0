From: Baoyou Xie <baoyou.xie@linaro.org>
Subject: [PATCH] scsi: move function declarationes to scsi_priv.h
Date: Sun, 28 Aug 2016 00:59:57 +0800
Message-ID: <1472317197-7865-1-git-send-email-baoyou.xie@linaro.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:36349 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752054AbcH0RAh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Aug 2016 13:00:37 -0400
Received: by mail-pf0-f182.google.com with SMTP id h186so38132995pfg.3
        for <linux-scsi@vger.kernel.org>; Sat, 27 Aug 2016 10:00:37 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@linaro.org, baoyou.xie@linaro.org, xie.baoyou@zte.com.cn

We get 2 warnings about global functions without a declaration
in the scsi driver when building with W=1:
drivers/scsi/scsi_lib.c:467:6: warning: no previous prototype for 'scsi_requeue_run_queue' [-Wmissing-prototypes]
drivers/scsi/scsi_lib.c:2609:6: warning: no previous prototype for 'scsi_evt_thread' [-Wmissing-prototypes]

in fact, both functiones are declared in drivers/scsi/scsi_scan.c
but need to move the declarationes into scsi_priv.h.

Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
---
 drivers/scsi/scsi_priv.h | 2 ++
 drivers/scsi/scsi_scan.c | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 57a4b99..ff3cde3 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -85,12 +85,14 @@ extern void scsi_device_unbusy(struct scsi_device *sdev);
 extern void scsi_queue_insert(struct scsi_cmnd *cmd, int reason);
 extern void scsi_io_completion(struct scsi_cmnd *, unsigned int);
 extern void scsi_run_host_queues(struct Scsi_Host *shost);
+extern void scsi_requeue_run_queue(struct work_struct *work);
 extern struct request_queue *scsi_alloc_queue(struct scsi_device *sdev);
 extern struct request_queue *scsi_mq_alloc_queue(struct scsi_device *sdev);
 extern int scsi_mq_setup_tags(struct Scsi_Host *shost);
 extern void scsi_mq_destroy_tags(struct Scsi_Host *shost);
 extern int scsi_init_queue(void);
 extern void scsi_exit_queue(void);
+extern void scsi_evt_thread(struct work_struct *work);
 struct request_queue;
 struct request;
 extern struct kmem_cache *scsi_sdb_cache;
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index e0a78f5..212e98d 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -217,8 +217,6 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	struct scsi_device *sdev;
 	int display_failure_msg = 1, ret;
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
-	extern void scsi_evt_thread(struct work_struct *work);
-	extern void scsi_requeue_run_queue(struct work_struct *work);
 
 	sdev = kzalloc(sizeof(*sdev) + shost->transportt->device_size,
 		       GFP_ATOMIC);
-- 
2.7.4

