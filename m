Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74551C19F2B
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jul 2022 22:19:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbiG1WT2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jul 2022 18:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232366AbiG1WTM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jul 2022 18:19:12 -0400
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9A07969E
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2022 15:19:06 -0700 (PDT)
Received: by mail-pl1-f182.google.com with SMTP id v18so2963977plo.8
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2022 15:19:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B2VpnzpxPX3Pmo2QoyyBQCVYsbY7t6a8XWBDIqfLwcI=;
        b=ta5GmmnmNvAK2bMBZDQJOAFD6EHwmTpx0aBLAN+KTzsonAA8KZbzScgTLqcp9LYNdE
         GOCs1GlfXbzz4OBhKFSQwZx7ydfvjAV427Oje/VfVEYy8J8HXQ9SvZSVf/TdjzWW6uaR
         PZYf58YclJPoGr1EGsbGh7VobiMWB+hS5kPsXONo9lXgUJtSamachPxq1cfFspSykCiM
         IWj71ofXWK92Jwu8RB8sif0CNm1CnsM130XLPm8Ngo3hB2z4cd+J03GjJxjEkx7jGzsi
         aV4MQqEguvJkHEhGnVQTzxQEwN8NiWqo+kCSyyvWJ7bFpck5TL66ottGY9rP4X9m538r
         6KmA==
X-Gm-Message-State: ACgBeo18qk1twuTTW8gRL6PQ7dHjroq/wKJKIVb+5nX0iWAxU2yOTA/7
        iMpQj9FuEmLNdaq2WHn9pqo=
X-Google-Smtp-Source: AA6agR7iaQTzLbgzJDFdJqgMF/EHtf6v/yRUm7MhKIN3uRZ+b6ksNCwJVFJG0BwnSX+MlptcXbRMAg==
X-Received: by 2002:a17:90a:a404:b0:1ee:e545:288b with SMTP id y4-20020a17090aa40400b001eee545288bmr807704pjp.142.1659046745927;
        Thu, 28 Jul 2022 15:19:05 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:9520:2952:8318:8e3e])
        by smtp.gmail.com with ESMTPSA id k11-20020a170902c40b00b0016dc8932725sm1556709plk.285.2022.07.28.15.19.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 15:19:05 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Mike Christie <michael.christie@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 2/4] scsi: core: Make sure that hosts outlive targets
Date:   Thu, 28 Jul 2022 15:18:49 -0700
Message-Id: <20220728221851.1822295-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
In-Reply-To: <20220728221851.1822295-1-bvanassche@acm.org>
References: <20220728221851.1822295-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

Fix the race conditions between SCSI LLD kernel module unloading and SCSI
device and target removal by making sure that SCSI hosts are destroyed after
all associated target and device objects have been freed.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.garry@huawei.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
[ bvanassche: Reworked Ming's patch and split it ]
---
 drivers/scsi/hosts.c     | 8 ++++++++
 drivers/scsi/scsi_scan.c | 7 +++++++
 include/scsi/scsi_host.h | 3 +++
 3 files changed, 18 insertions(+)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index ef6c0e37acce..8fa98c8d0ee0 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -190,6 +190,13 @@ void scsi_remove_host(struct Scsi_Host *shost)
 	transport_unregister_device(&shost->shost_gendev);
 	device_unregister(&shost->shost_dev);
 	device_del(&shost->shost_gendev);
+
+	/*
+	 * After scsi_remove_host() has returned the scsi LLD module can be
+	 * unloaded and/or the host resources can be released. Hence wait until
+	 * the dependent SCSI targets and devices are gone before returning.
+	 */
+	wait_event(shost->targets_wq, atomic_read(&shost->target_count) == 0);
 }
 EXPORT_SYMBOL(scsi_remove_host);
 
@@ -394,6 +401,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	INIT_LIST_HEAD(&shost->starved_list);
 	init_waitqueue_head(&shost->host_wait);
 	mutex_init(&shost->scan_mutex);
+	init_waitqueue_head(&shost->targets_wq);
 
 	index = ida_alloc(&host_index_ida, GFP_KERNEL);
 	if (index < 0) {
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 4c1efd6a3b0c..ac6059702d13 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -406,9 +406,14 @@ static void scsi_target_destroy(struct scsi_target *starget)
 static void scsi_target_dev_release(struct device *dev)
 {
 	struct device *parent = dev->parent;
+	struct Scsi_Host *shost = dev_to_shost(parent);
 	struct scsi_target *starget = to_scsi_target(dev);
 
 	kfree(starget);
+
+	if (atomic_dec_return(&shost->target_count) == 0)
+		wake_up(&shost->targets_wq);
+
 	put_device(parent);
 }
 
@@ -523,6 +528,8 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	starget->max_target_blocked = SCSI_DEFAULT_TARGET_BLOCKED;
 	init_waitqueue_head(&starget->sdev_wq);
 
+	atomic_inc(&shost->target_count);
+
  retry:
 	spin_lock_irqsave(shost->host_lock, flags);
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 667d889b92b5..339f975d356e 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -689,6 +689,9 @@ struct Scsi_Host {
 	/* ldm bits */
 	struct device		shost_gendev, shost_dev;
 
+	atomic_t		target_count;
+	wait_queue_head_t	targets_wq;
+
 	/*
 	 * Points to the transport data (if any) which is allocated
 	 * separately
