Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF003C8300A
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 03:18:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADA072145D
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 03:18:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbgKWDSO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 Nov 2020 22:18:14 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39598 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727960AbgKWDSN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Nov 2020 22:18:13 -0500
Received: by mail-pl1-f195.google.com with SMTP id k5so1709153plt.6;
        Sun, 22 Nov 2020 19:18:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MLEafruK2sIv4f0h8QLtwJ927VYU5hiqjZ3HgPXMriw=;
        b=VJS1Yjnl5aV6EqkUJr0RyxXT70TqelAOasVq0t+Fp6QkHg1iMQdEKwJqa6v9Cy87EX
         nJ2LfcMkMKWN4BKh77xl/yck8BYng3rsghO1qCRPvUj62A+BUOBD8JhjgGTg9nB64ENd
         zqiM6ummhxDnd0vhQsnrxY4RgNxxrG5UAv+lJbzMq5S39jwmnbNP9u+PADMHsRToozG7
         U74zxFMybznEKnugUaWzOPiGsdbUFrrodl5X8DMbqtrbiY+s56iVdawAosFYielVK5SX
         KFlJTMnrTgpiwXoROuHkZCScnpsFOUh6dA38YzzCuNpQajud8/+d9eNOR7mSnf4LuCjt
         qG7A==
X-Gm-Message-State: AOAM531rU1VRFKbAuq1A9sumyxXyYWVWZEuYYZqLCdRjDeyCTYre2xFb
        oZhWP4RCX6kN7qioCs5U6ls=
X-Google-Smtp-Source: ABdhPJwNWKpysgReV4U5ctTR6DcJAhUt4Sjz6gvGwOroBCSeQSXxIYQ9WCMpD9WCV4DK0/FmXFfeDg==
X-Received: by 2002:a17:902:7081:b029:d9:d623:68f8 with SMTP id z1-20020a1709027081b02900d9d62368f8mr18150500plk.54.1606101491970;
        Sun, 22 Nov 2020 19:18:11 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id w12sm3578751pfn.136.2020.11.22.19.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2020 19:18:11 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Woody Suwalski <terraluna977@gmail.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Stan Johnson <userm57@yahoo.com>
Subject: [PATCH v3 7/9] scsi_transport_spi: Freeze request queues instead of quiescing
Date:   Sun, 22 Nov 2020 19:17:47 -0800
Message-Id: <20201123031749.14912-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123031749.14912-1-bvanassche@acm.org>
References: <20201123031749.14912-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Woody Suwalski <terraluna977@gmail.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c           | 21 ++++----
 drivers/scsi/scsi_priv.h          |  2 +
 drivers/scsi/scsi_transport_spi.c | 84 +++++++++++++++++++++----------
 include/scsi/scsi_device.h        |  6 +--
 4 files changed, 72 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b5449efc7283..fef4708f3778 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2555,7 +2555,6 @@ scsi_device_quiesce(struct scsi_device *sdev)
 
 	return err;
 }
-EXPORT_SYMBOL(scsi_device_quiesce);
 
 /**
  *	scsi_device_resume - Restart user issued commands to a quiesced device.
@@ -2584,30 +2583,30 @@ void scsi_device_resume(struct scsi_device *sdev)
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
index e34755986b47..18485595762a 100644
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
index 959990f66865..2352c441302f 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -983,6 +983,18 @@ spi_dv_device_internal(struct scsi_device *sdev, struct request_queue *q,
 	}
 }
 
+static struct request_queue *scsi_mq_alloc_queue(struct scsi_device *sdev)
+{
+	struct request_queue *q = blk_mq_init_queue(&sdev->host->tag_set);
+
+	if (IS_ERR(q))
+		return NULL;
+
+	q->queuedata = sdev;
+	__scsi_init_queue(sdev->host, q);
+	blk_queue_flag_set(QUEUE_FLAG_SCSI_PASSTHROUGH, q);
+	return q;
+}
 
 /**	spi_dv_device - Do Domain Validation on the device
  *	@sdev:		scsi device to validate
@@ -997,59 +1009,79 @@ void
 spi_dv_device(struct scsi_device *sdev)
 {
 	struct scsi_target *starget = sdev->sdev_target;
+	struct request_queue *q2;
 	u8 *buffer;
 	const int len = SPI_MAX_ECHO_BUFFER_SIZE*2;
 
 	/*
-	 * Because this function and the power management code both call
-	 * scsi_device_quiesce(), it is not safe to perform domain validation
-	 * while suspend or resume is in progress. Hence the
-	 * lock/unlock_system_sleep() calls.
+	 * Because this function creates a new request queue that is not
+	 * visible to the rest of the system, this function must be serialized
+	 * against suspend, resume and runtime power management. Hence the
+	 * lock/unlock_system_sleep() and scsi_autopm_{get,put}_device()
+	 * calls.
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
-
-	spi_dv_in_progress(starget) = 1;
+		goto put_autopm;
 
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
+
 	mutex_lock(&spi_dv_mutex(starget));
+	if (unlikely(spi_dv_in_progress(starget)))
+		goto clear_pending;
+
+	spi_dv_in_progress(starget) = 1;
 
 	starget_printk(KERN_INFO, starget, "Beginning Domain Validation\n");
 
-	spi_dv_device_internal(sdev, sdev->request_queue, buffer);
+	q2 = scsi_mq_alloc_queue(sdev);
+
+	if (q2) {
+		/*
+		 * Freeze the target such that no other subsystem can submit
+		 * SCSI commands to 'sdev'. Submitting SCSI commands through
+		 * q2 may trigger the SCSI error handler. The SCSI error
+		 * handler must be able to handle a frozen sdev->request_queue
+		 * and must also use blk_mq_rq_from_pdu(q2)->q instead of
+		 * sdev->request_queue if it would be necessary to access q2
+		 * directly.
+		 */
+		scsi_target_freeze(starget);
+		spi_dv_device_internal(sdev, q2, buffer);
+		blk_cleanup_queue(q2);
+		scsi_target_unfreeze(starget);
+	}
 
 	starget_printk(KERN_INFO, starget, "Ending Domain Validation\n");
 
-	mutex_unlock(&spi_dv_mutex(starget));
-	spi_dv_pending(starget) = 0;
-
-	scsi_target_resume(starget);
-
 	spi_initial_dv(starget) = 1;
+	spi_dv_in_progress(starget) = 0;
+
+clear_pending:
+	spi_dv_pending(starget) = 0;
+	mutex_unlock(&spi_dv_mutex(starget));
 
- out_free:
 	kfree(buffer);
- out_put:
-	spi_dv_in_progress(starget) = 0;
+
+put_sdev:
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
index f47fdf9cf788..dc193d7f479a 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -423,10 +423,8 @@ extern struct scsi_event *sdev_evt_alloc(enum scsi_device_event evt_type,
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
