Return-Path: <SRS0=EUsX=4Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DED3C3F2D5
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 07:53:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FC6B246A8
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 07:53:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbgB1Hx1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Feb 2020 02:53:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:59832 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727009AbgB1HxZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Feb 2020 02:53:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 61695B21F;
        Fri, 28 Feb 2020 07:53:21 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 13/13] scsi: Remove cmd_list functionality
Date:   Fri, 28 Feb 2020 08:53:18 +0100
Message-Id: <20200228075318.91255-14-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200228075318.91255-1-hare@suse.de>
References: <20200228075318.91255-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove cmd_list functionality; no users left.  With that the scsi_put_command()
becomes empty, so remove that one, too.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi.c        | 14 --------------
 drivers/scsi/scsi_error.c  |  1 -
 drivers/scsi/scsi_lib.c    | 31 -------------------------------
 drivers/scsi/scsi_priv.h   |  2 --
 drivers/scsi/scsi_scan.c   |  1 -
 include/scsi/scsi_cmnd.h   |  1 -
 include/scsi/scsi_device.h |  1 -
 include/scsi/scsi_host.h   |  2 --
 8 files changed, 53 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 4b9fdfab77d9..56c24a73e0c7 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -94,20 +94,6 @@ EXPORT_SYMBOL(scsi_logging_level);
 ASYNC_DOMAIN_EXCLUSIVE(scsi_sd_pm_domain);
 EXPORT_SYMBOL(scsi_sd_pm_domain);
 
-/**
- * scsi_put_command - Free a scsi command block
- * @cmd: command block to free
- *
- * Returns:	Nothing.
- *
- * Notes:	The command must not belong to any lists.
- */
-void scsi_put_command(struct scsi_cmnd *cmd)
-{
-	scsi_del_cmd_from_list(cmd);
-	BUG_ON(delayed_work_pending(&cmd->abort_work));
-}
-
 #ifdef CONFIG_SCSI_LOGGING
 void scsi_log_send(struct scsi_cmnd *cmd)
 {
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index ae2fa170f6ad..978be1602f71 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2412,7 +2412,6 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
 	wake_up(&shost->host_wait);
 	scsi_run_host_queues(shost);
 
-	scsi_put_command(scmd);
 	kfree(rq);
 
 out_put_autopm_host:
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a48a5727831b..258a428a0a3f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -562,7 +562,6 @@ static void scsi_mq_uninit_cmd(struct scsi_cmnd *cmd)
 {
 	scsi_mq_free_sgtables(cmd);
 	scsi_uninit_cmd(cmd);
-	scsi_del_cmd_from_list(cmd);
 }
 
 /* Returns false when no more bytes to process, true if there are more */
@@ -1098,35 +1097,6 @@ static void scsi_cleanup_rq(struct request *rq)
 	}
 }
 
-/* Add a command to the list used by the aacraid and dpt_i2o drivers */
-void scsi_add_cmd_to_list(struct scsi_cmnd *cmd)
-{
-	struct scsi_device *sdev = cmd->device;
-	struct Scsi_Host *shost = sdev->host;
-	unsigned long flags;
-
-	if (shost->use_cmd_list) {
-		spin_lock_irqsave(&sdev->list_lock, flags);
-		list_add_tail(&cmd->list, &sdev->cmd_list);
-		spin_unlock_irqrestore(&sdev->list_lock, flags);
-	}
-}
-
-/* Remove a command from the list used by the aacraid and dpt_i2o drivers */
-void scsi_del_cmd_from_list(struct scsi_cmnd *cmd)
-{
-	struct scsi_device *sdev = cmd->device;
-	struct Scsi_Host *shost = sdev->host;
-	unsigned long flags;
-
-	if (shost->use_cmd_list) {
-		spin_lock_irqsave(&sdev->list_lock, flags);
-		BUG_ON(list_empty(&cmd->list));
-		list_del_init(&cmd->list);
-		spin_unlock_irqrestore(&sdev->list_lock, flags);
-	}
-}
-
 /* Called after a request has been started. */
 void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
 {
@@ -1160,7 +1130,6 @@ void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
 	if (in_flight)
 		__set_bit(SCMD_STATE_INFLIGHT, &cmd->state);
 
-	scsi_add_cmd_to_list(cmd);
 }
 
 static blk_status_t scsi_setup_scsi_cmnd(struct scsi_device *sdev,
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 25b0aaaf5ae8..22b6585e28b4 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -83,8 +83,6 @@ int scsi_eh_get_sense(struct list_head *work_q,
 int scsi_noretry_cmd(struct scsi_cmnd *scmd);
 
 /* scsi_lib.c */
-extern void scsi_add_cmd_to_list(struct scsi_cmnd *cmd);
-extern void scsi_del_cmd_from_list(struct scsi_cmnd *cmd);
 extern int scsi_maybe_unblock_host(struct scsi_device *sdev);
 extern void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd *cmd);
 extern void scsi_queue_insert(struct scsi_cmnd *cmd, int reason);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 058079f915f1..f2437a7570ce 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -236,7 +236,6 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	sdev->sdev_state = SDEV_CREATED;
 	INIT_LIST_HEAD(&sdev->siblings);
 	INIT_LIST_HEAD(&sdev->same_target_siblings);
-	INIT_LIST_HEAD(&sdev->cmd_list);
 	INIT_LIST_HEAD(&sdev->starved_entry);
 	INIT_LIST_HEAD(&sdev->event_list);
 	spin_lock_init(&sdev->list_lock);
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index a2849bb9cd19..80ac89e47b47 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -159,7 +159,6 @@ static inline struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
 	return *(struct scsi_driver **)cmd->request->rq_disk->private_data;
 }
 
-extern void scsi_put_command(struct scsi_cmnd *);
 extern void scsi_finish_command(struct scsi_cmnd *cmd);
 
 extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index f8312a3e5b42..f146a4557787 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -110,7 +110,6 @@ struct scsi_device {
 	atomic_t device_blocked;	/* Device returned QUEUE_FULL. */
 
 	spinlock_t list_lock;
-	struct list_head cmd_list;	/* queue of in use SCSI Command structures */
 	struct list_head starved_entry;
 	unsigned short queue_depth;	/* How deep of a queue we want */
 	unsigned short max_queue_depth;	/* max queue depth */
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index eff12445b823..74dc7d4f2a96 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -624,8 +624,6 @@ struct Scsi_Host {
 	/* The controller does not support WRITE SAME */
 	unsigned no_write_same:1;
 
-	unsigned use_cmd_list:1;
-
 	/* Host responded with short (<36 bytes) INQUIRY result */
 	unsigned short_inquiry:1;
 
-- 
2.16.4

