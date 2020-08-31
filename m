Return-Path: <SRS0=g0vc=CJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24BAEC433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 02:54:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08BD12076D
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 02:54:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbgHaCyV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 30 Aug 2020 22:54:21 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43387 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726984AbgHaCyP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Aug 2020 22:54:15 -0400
Received: by mail-pf1-f194.google.com with SMTP id f18so527939pfa.10
        for <linux-scsi@vger.kernel.org>; Sun, 30 Aug 2020 19:54:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fQ3YgPbT5W7c+FaOm1s6QGKjCVUM85RXDDNSW5xzmMo=;
        b=mA2fGBvUXZElpXuzfBrl6dCGh1Aj5/25DJ1pzCp/7usPH4fZarl0d8kLFKFr4vhP4U
         0BHbMXYrBYG+k9ez2t4dyLACTZO2JWG13EFN93F/Es8v4QXn1dZptcvoERBCCn2NIpdp
         GsMtYfX92U0ix5EqP9jagrD2uhZyTr+mHWBI8fTTEqvICzgeQY1Vgr7pIG0foxOBI/aN
         P4806pSsC0MznkJzPQGOhFZCL8CP87OAcCHDpT+S8TxmWQOCKGKa/N+ZAgULJmEJokgL
         jW0wB3+Hi2OLnmlOmMfQ504iEaYv1N36OGpjlyd0wkew7f5f1Lq3cilpLRavvrY10SWH
         oNwQ==
X-Gm-Message-State: AOAM530JYAPPiZT2dJl5mzV3zvSq4J/DFD/hPJEBbXFHsT+KfT9iAyex
        g9D4pOmn/gfvxnF3WpzTI3c=
X-Google-Smtp-Source: ABdhPJxBhpK7PfHr0BWIGF006Arnv+HGYVIFQZKwCM9m3PPEvay1vrtk75SnNXf3sb7lyszJSEVifQ==
X-Received: by 2002:aa7:947b:: with SMTP id t27mr1676523pfq.240.1598842454489;
        Sun, 30 Aug 2020 19:54:14 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id l123sm583569pgl.24.2020.08.30.19.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2020 19:54:13 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     linux-scsi@vger.kernel.org,
        Martin Kepplinger <martin.kepplinger@puri.sm>,
        Can Guo <cang@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH RFC 5/6] scsi_transport_spi: Freeze request queues instead of quiescing
Date:   Sun, 30 Aug 2020 19:53:56 -0700
Message-Id: <20200831025357.32700-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200831025357.32700-1-bvanassche@acm.org>
References: <20200831025357.32700-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of quiescing the request queues involved in domain validation,
freeze these. As a result, the struct request_queue pm_only member is no
longer set during domain validation. That will allow to modify
scsi_execute() such that it stops setting the BLK_MQ_REQ_PREEMPT flag.
Three additional changes in this patch are that scsi_mq_alloc_queue() is
exported, that scsi_device_quiesce() is no longer exported and that
scsi_target_{quiesce,resume}() have been changed into
scsi_target_{freeze,unfreeze}().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c           | 22 ++++++------
 drivers/scsi/scsi_priv.h          |  2 ++
 drivers/scsi/scsi_transport_spi.c | 56 ++++++++++++++++++++-----------
 include/scsi/scsi_device.h        |  6 ++--
 4 files changed, 51 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1d7135f61962..49eb8f2dffd8 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1866,6 +1866,7 @@ struct request_queue *scsi_mq_alloc_queue(struct scsi_device *sdev)
 	blk_queue_flag_set(QUEUE_FLAG_SCSI_PASSTHROUGH, sdev->request_queue);
 	return sdev->request_queue;
 }
+EXPORT_SYMBOL_GPL(scsi_mq_alloc_queue);
 
 int scsi_mq_setup_tags(struct Scsi_Host *shost)
 {
@@ -2540,7 +2541,6 @@ scsi_device_quiesce(struct scsi_device *sdev)
 
 	return err;
 }
-EXPORT_SYMBOL(scsi_device_quiesce);
 
 /**
  *	scsi_device_resume - Restart user issued commands to a quiesced device.
@@ -2569,30 +2569,30 @@ void scsi_device_resume(struct scsi_device *sdev)
 EXPORT_SYMBOL(scsi_device_resume);
 
 static void
-device_quiesce_fn(struct scsi_device *sdev, void *data)
+device_freeze_fn(struct scsi_device *sdev, void *data)
 {
-	scsi_device_quiesce(sdev);
+	blk_mq_freeze_queue(sdev->request_queue);
 }
 
 void
-scsi_target_quiesce(struct scsi_target *starget)
+scsi_target_freeze(struct scsi_target *starget)
 {
-	starget_for_each_device(starget, NULL, device_quiesce_fn);
+	starget_for_each_device(starget, NULL, device_freeze_fn);
 }
-EXPORT_SYMBOL(scsi_target_quiesce);
+EXPORT_SYMBOL(scsi_target_freeze);
 
 static void
-device_resume_fn(struct scsi_device *sdev, void *data)
+device_unfreeze_fn(struct scsi_device *sdev, void *data)
 {
-	scsi_device_resume(sdev);
+	blk_mq_unfreeze_queue(sdev->request_queue);
 }
 
 void
-scsi_target_resume(struct scsi_target *starget)
+scsi_target_unfreeze(struct scsi_target *starget)
 {
-	starget_for_each_device(starget, NULL, device_resume_fn);
+	starget_for_each_device(starget, NULL, device_unfreeze_fn);
 }
-EXPORT_SYMBOL(scsi_target_resume);
+EXPORT_SYMBOL(scsi_target_unfreeze);
 
 /**
  * scsi_internal_device_block_nowait - try to transition to the SDEV_BLOCK state
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index d12ada035961..6b9203df84c8 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -95,6 +95,8 @@ extern int scsi_mq_setup_tags(struct Scsi_Host *shost);
 extern void scsi_mq_destroy_tags(struct Scsi_Host *shost);
 extern void scsi_exit_queue(void);
 extern void scsi_evt_thread(struct work_struct *work);
+extern int scsi_device_quiesce(struct scsi_device *sdev);
+extern void scsi_device_resume(struct scsi_device *sdev);
 struct request_queue;
 struct request;
 
diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 959990f66865..63bec8980b27 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -997,59 +997,75 @@ void
 spi_dv_device(struct scsi_device *sdev)
 {
 	struct scsi_target *starget = sdev->sdev_target;
+	struct request_queue *q1, *q2;
 	u8 *buffer;
 	const int len = SPI_MAX_ECHO_BUFFER_SIZE*2;
 
 	/*
-	 * Because this function and the power management code both call
-	 * scsi_device_quiesce(), it is not safe to perform domain validation
-	 * while suspend or resume is in progress. Hence the
-	 * lock/unlock_system_sleep() calls.
+	 * Because creates a new request queue that is not visible to the rest
+	 * of the system, domain validation must be serialized against suspend,
+	 * resume and runtime power management. Hence the
+	 * lock/unlock_system_sleep() and scsi_autopm_{get,put}_device() calls.
 	 */
 	lock_system_sleep();
 
+	if (scsi_autopm_get_device(sdev))
+		goto unlock_system_sleep;
+
 	if (unlikely(spi_dv_in_progress(starget)))
-		goto unlock;
+		goto put_autopm;
 
 	if (unlikely(scsi_device_get(sdev)))
-		goto unlock;
+		goto put_autopm;
 
 	spi_dv_in_progress(starget) = 1;
 
 	buffer = kzalloc(len, GFP_KERNEL);
 
 	if (unlikely(!buffer))
-		goto out_put;
-
-	/* We need to verify that the actual device will quiesce; the
-	 * later target quiesce is just a nice to have */
-	if (unlikely(scsi_device_quiesce(sdev)))
-		goto out_free;
-
-	scsi_target_quiesce(starget);
+		goto put_sdev;
 
 	spi_dv_pending(starget) = 1;
 	mutex_lock(&spi_dv_mutex(starget));
 
 	starget_printk(KERN_INFO, starget, "Beginning Domain Validation\n");
 
-	spi_dv_device_internal(sdev, sdev->request_queue, buffer);
+	/*
+	 * Save the request queue pointer before it is overwritten by
+	 * scsi_mq_alloc_queue().
+	 */
+	q1 = sdev->request_queue;
+	q2 = scsi_mq_alloc_queue(sdev);
+
+	if (q2) {
+		/*
+		 * Restore the request queue pointer such that no other
+		 * subsystem can submit SCSI commands to 'sdev'.
+		 */
+		sdev->request_queue = q1;
+		scsi_target_freeze(starget);
+		spi_dv_device_internal(sdev, q2, buffer);
+		blk_cleanup_queue(q2);
+		scsi_target_unfreeze(starget);
+	}
 
 	starget_printk(KERN_INFO, starget, "Ending Domain Validation\n");
 
 	mutex_unlock(&spi_dv_mutex(starget));
 	spi_dv_pending(starget) = 0;
 
-	scsi_target_resume(starget);
-
 	spi_initial_dv(starget) = 1;
 
- out_free:
 	kfree(buffer);
- out_put:
+
+put_sdev:
 	spi_dv_in_progress(starget) = 0;
 	scsi_device_put(sdev);
-unlock:
+
+put_autopm:
+	scsi_autopm_put_device(sdev);
+
+unlock_system_sleep:
 	unlock_system_sleep();
 }
 EXPORT_SYMBOL(spi_dv_device);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index ef6e96e12c7c..08f88ef04bc9 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -422,10 +422,8 @@ extern struct scsi_event *sdev_evt_alloc(enum scsi_device_event evt_type,
 extern void sdev_evt_send(struct scsi_device *sdev, struct scsi_event *evt);
 extern void sdev_evt_send_simple(struct scsi_device *sdev,
 			  enum scsi_device_event evt_type, gfp_t gfpflags);
-extern int scsi_device_quiesce(struct scsi_device *sdev);
-extern void scsi_device_resume(struct scsi_device *sdev);
-extern void scsi_target_quiesce(struct scsi_target *);
-extern void scsi_target_resume(struct scsi_target *);
+extern void scsi_target_freeze(struct scsi_target *);
+extern void scsi_target_unfreeze(struct scsi_target *);
 extern void scsi_scan_target(struct device *parent, unsigned int channel,
 			     unsigned int id, u64 lun,
 			     enum scsi_scan_mode rescan);
