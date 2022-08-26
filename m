Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C31CDECAAA2
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Aug 2022 00:26:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235785AbiHZA0u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Aug 2022 20:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiHZA0t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Aug 2022 20:26:49 -0400
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09905AF4A6
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2022 17:26:48 -0700 (PDT)
Received: by mail-pj1-f42.google.com with SMTP id w88-20020a17090a6be100b001fbb0f0b013so507pjj.5
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2022 17:26:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=BXo4LRgKgVTKWW02LRd5WxOgeTQRVas0PwL93Ve9P2Q=;
        b=OL2SQyFXFOBIn061ogYY2fNCZuR74LY5aZ3FItql4SkJcymlIDCuhZwVCi3hGWXyJD
         fCm4BDdNoK9FFrQTlUR+gnoIIDOQ86K2viHVzaarwLHX3KbkuWFUSwDmK0tGPBAl25wL
         6qei4bSu6X3jWFSzQpOrbrrEoc0zz56w7T3b+T24ISL9I0vhNgkKubs6Ss9U84Wn7inL
         MY8FMVGoUdvvRoQ2tiKFAEyrAr6QsyFI4QyVRBdVRYuA8QdQ3UE4dssxoNRDvMH+wbVl
         d/cXbAA4o088RQnt5/ZcG0gUJyz5cIMhO485AZP8AR4ylAveZqvQKnqyeBmt7LlkJKSG
         5Nvw==
X-Gm-Message-State: ACgBeo2yyVvspBUrfDFNUsGgbVDVuTGwzoc4AEBxfDW9RTJC9TW9ShPT
        l8gno3Tj6/oEz5p5xh1HR/0=
X-Google-Smtp-Source: AA6agR6WQrtcypajHdQHMVkGIFBWfeCbJCs7StyxP6fKJMx5miYEHfMp9ZCjGR7OaWd0+XmJuV7qnQ==
X-Received: by 2002:a17:902:ef4f:b0:173:353:3f6c with SMTP id e15-20020a170902ef4f00b0017303533f6cmr1502882plx.6.1661473607441;
        Thu, 25 Aug 2022 17:26:47 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:349c:3078:d005:5a7e])
        by smtp.gmail.com with ESMTPSA id a14-20020a170902710e00b0016d150c6c6dsm172319pll.45.2022.08.25.17.26.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 17:26:46 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Mike Christie <michael.christie@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Li Zhijian <lizhijian@fujitsu.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH] scsi: core: Fix a use-after-free
Date:   Thu, 25 Aug 2022 17:26:34 -0700
Message-Id: <20220826002635.919423-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There are two .exit_cmd_priv implementations. Both implementations use
resources associated with the SCSI host. Make sure that these resources are
still available when .exit_cmd_priv is called by waiting inside
scsi_remove_host() until the tag set has been freed.

This patch fixes the following use-after-free:

==================================================================
BUG: KASAN: use-after-free in srp_exit_cmd_priv+0x27/0xd0 [ib_srp]
Read of size 8 at addr ffff888100337000 by task multipathd/16727
Call Trace:
 <TASK>
 dump_stack_lvl+0x34/0x44
 print_report.cold+0x5e/0x5db
 kasan_report+0xab/0x120
 srp_exit_cmd_priv+0x27/0xd0 [ib_srp]
 scsi_mq_exit_request+0x4d/0x70
 blk_mq_free_rqs+0x143/0x410
 __blk_mq_free_map_and_rqs+0x6e/0x100
 blk_mq_free_tag_set+0x2b/0x160
 scsi_host_dev_release+0xf3/0x1a0
 device_release+0x54/0xe0
 kobject_put+0xa5/0x120
 device_release+0x54/0xe0
 kobject_put+0xa5/0x120
 scsi_device_dev_release_usercontext+0x4c1/0x4e0
 execute_in_process_context+0x23/0x90
 device_release+0x54/0xe0
 kobject_put+0xa5/0x120
 scsi_disk_release+0x3f/0x50
 device_release+0x54/0xe0
 kobject_put+0xa5/0x120
 disk_release+0x17f/0x1b0
 device_release+0x54/0xe0
 kobject_put+0xa5/0x120
 dm_put_table_device+0xa3/0x160 [dm_mod]
 dm_put_device+0xd0/0x140 [dm_mod]
 free_priority_group+0xd8/0x110 [dm_multipath]
 free_multipath+0x94/0xe0 [dm_multipath]
 dm_table_destroy+0xa2/0x1e0 [dm_mod]
 __dm_destroy+0x196/0x350 [dm_mod]
 dev_remove+0x10c/0x160 [dm_mod]
 ctl_ioctl+0x2c2/0x590 [dm_mod]
 dm_ctl_ioctl+0x5/0x10 [dm_mod]
 __x64_sys_ioctl+0xb4/0xf0
 dm_ctl_ioctl+0x5/0x10 [dm_mod]
 __x64_sys_ioctl+0xb4/0xf0
 do_syscall_64+0x3b/0x90
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

Cc: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.garry@huawei.com>
Cc: Li Zhijian <lizhijian@fujitsu.com>
Reported-by: Li Zhijian <lizhijian@fujitsu.com>
Fixes: 65ca846a5314 ("scsi: core: Introduce {init,exit}_cmd_priv()")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hosts.c      | 16 +++++++++++++---
 drivers/scsi/scsi_lib.c   |  6 +++++-
 drivers/scsi/scsi_priv.h  |  2 +-
 drivers/scsi/scsi_scan.c  |  1 +
 drivers/scsi/scsi_sysfs.c |  1 +
 include/scsi/scsi_host.h  |  2 ++
 6 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 26bf3b153595..9857dba09c95 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -182,6 +182,15 @@ void scsi_remove_host(struct Scsi_Host *shost)
 	mutex_unlock(&shost->scan_mutex);
 	scsi_proc_host_rm(shost);
 
+	/*
+	 * New SCSI devices cannot be attached anymore because of the SCSI host
+	 * state so drop the tag set refcnt. Wait until the tag set refcnt drops
+	 * to zero because .exit_cmd_priv implementations may need the host
+	 * pointer.
+	 */
+	kref_put(&shost->tagset_refcnt, scsi_mq_free_tags);
+	wait_for_completion(&shost->tagset_freed);
+
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (scsi_host_set_state(shost, SHOST_DEL))
 		BUG_ON(scsi_host_set_state(shost, SHOST_DEL_RECOVERY));
@@ -245,6 +254,9 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 	if (error)
 		goto fail;
 
+	kref_init(&shost->tagset_refcnt);
+	init_completion(&shost->tagset_freed);
+
 	/*
 	 * Increase usage count temporarily here so that calling
 	 * scsi_autopm_put_host() will trigger runtime idle if there is
@@ -317,6 +329,7 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 	pm_runtime_disable(&shost->shost_gendev);
 	pm_runtime_set_suspended(&shost->shost_gendev);
 	pm_runtime_put_noidle(&shost->shost_gendev);
+	kref_put(&shost->tagset_refcnt, scsi_mq_free_tags);
  fail:
 	return error;
 }
@@ -350,9 +363,6 @@ static void scsi_host_dev_release(struct device *dev)
 		kfree(dev_name(&shost->shost_dev));
 	}
 
-	if (shost->tag_set.tags)
-		scsi_mq_destroy_tags(shost);
-
 	kfree(shost->shost_data);
 
 	ida_free(&host_index_ida, shost->host_no);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 4dbd29ab1dcc..1f30e0c54e55 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1976,9 +1976,13 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 	return blk_mq_alloc_tag_set(tag_set);
 }
 
-void scsi_mq_destroy_tags(struct Scsi_Host *shost)
+void scsi_mq_free_tags(struct kref *kref)
 {
+	struct Scsi_Host *shost = container_of(kref, typeof(*shost),
+					       tagset_refcnt);
+
 	blk_mq_free_tag_set(&shost->tag_set);
+	complete(&shost->tagset_freed);
 }
 
 /**
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 429663bd78ec..f385b3f04d6e 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -94,7 +94,7 @@ extern void scsi_run_host_queues(struct Scsi_Host *shost);
 extern void scsi_requeue_run_queue(struct work_struct *work);
 extern void scsi_start_queue(struct scsi_device *sdev);
 extern int scsi_mq_setup_tags(struct Scsi_Host *shost);
-extern void scsi_mq_destroy_tags(struct Scsi_Host *shost);
+extern void scsi_mq_free_tags(struct kref *kref);
 extern void scsi_exit_queue(void);
 extern void scsi_evt_thread(struct work_struct *work);
 
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 91ac901a6682..5d27f5196de6 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -340,6 +340,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 		kfree(sdev);
 		goto out;
 	}
+	kref_get(&sdev->host->tagset_refcnt);
 	sdev->request_queue = q;
 	q->queuedata = sdev;
 	__scsi_init_queue(sdev->host, q);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index aa70d9282161..5d61f58399dc 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1476,6 +1476,7 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	mutex_unlock(&sdev->state_mutex);
 
 	blk_mq_destroy_queue(sdev->request_queue);
+	kref_put(&sdev->host->tagset_refcnt, scsi_mq_free_tags);
 	cancel_work_sync(&sdev->requeue_work);
 
 	if (sdev->host->hostt->slave_destroy)
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index b6e41ee3d566..9b0a028bf053 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -557,6 +557,8 @@ struct Scsi_Host {
 	struct scsi_host_template *hostt;
 	struct scsi_transport_template *transportt;
 
+	struct kref		tagset_refcnt;
+	struct completion	tagset_freed;
 	/* Area to keep a shared tag map */
 	struct blk_mq_tag_set	tag_set;
 
