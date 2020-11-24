Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCB1EC64E75
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 05:09:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89D6720870
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 05:09:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbgKXFJG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Nov 2020 00:09:06 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46046 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgKXFJG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2020 00:09:06 -0500
Received: by mail-pf1-f196.google.com with SMTP id b63so17280534pfg.12;
        Mon, 23 Nov 2020 21:09:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=be+w1zufcvQ5xw52FIcVjp9Ai9Qe+305azUVMmb6rPk=;
        b=QNnlkqg9Z42EKMBuN3SA6grwyfATV/E8GdglrvyJrWmuGRfe22tPln3+SJ2/p88we8
         R6h0bVDIbuMilFczpVlpQ/3R+0ZNoagfrBrmUcPPDWTdwWOZn9ELqceDdfRTPIJpxZQA
         8oOybqPTLtbMyxiQQDAlsd7ViC7xuXJ1CO7IAh0ZOkSuCbnuwVmZGb0+HzWr24XII0nU
         bTcCrBR691mtBhcNmhFUUsz344+ekkNAkZkBp8jfWrsqV7pp03FJE5GkjoVsucnIG6ZR
         Lf/a18cZ1WEame6D/dc3T6gAMeMyFlZHkPIIYLe4wea/FmyTadl75XyysQExmNifdLdi
         ZGrA==
X-Gm-Message-State: AOAM533Q3D6+RqmMfWRCZRsxXnov9fFDcOEHWQPxuOc8lub2LRJi5B9D
        MD1jVvqgmyfqaux6USU9ZXQ=
X-Google-Smtp-Source: ABdhPJzt+A3f0fRUxlx6HgKZILmvFwkUM5AW2PgkCYTE0h/UW2ZbgNo986TnvJy0fqsv9fI9TpK7Zg==
X-Received: by 2002:a17:90a:1157:: with SMTP id d23mr2707031pje.1.1606194544560;
        Mon, 23 Nov 2020 21:09:04 -0800 (PST)
Received: from [192.168.3.218] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id q4sm5105883pgl.14.2020.11.23.21.09.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2020 21:09:03 -0800 (PST)
Subject: Re: [PATCH v3 7/9] scsi_transport_spi: Freeze request queues instead
 of quiescing
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Woody Suwalski <terraluna977@gmail.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Stan Johnson <userm57@yahoo.com>
References: <20201123031749.14912-1-bvanassche@acm.org>
 <20201123031749.14912-8-bvanassche@acm.org>
 <12338292-47f8-8d1f-2c80-77912f030932@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <47d1d945-39da-50dc-ef2a-78e92d521d15@acm.org>
Date:   Mon, 23 Nov 2020 21:09:00 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <12338292-47f8-8d1f-2c80-77912f030932@suse.de>
Content-Type: multipart/mixed;
 boundary="------------B39536F5FD6544131B87D2AE"
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------B39536F5FD6544131B87D2AE
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On 11/22/20 11:02 PM, Hannes Reinecke wrote:
> On 11/23/20 4:17 AM, Bart Van Assche wrote:
>> Instead of quiescing the request queues involved in domain validation,
>> freeze these. As a result, the struct request_queue pm_only member is no
>> longer set during domain validation. That will allow to modify
>> scsi_execute() such that it stops setting the BLK_MQ_REQ_PREEMPT flag.
>> Three additional changes in this patch are that scsi_mq_alloc_queue() is
>> exported, that scsi_device_quiesce() is no longer exported and that
>> scsi_target_{quiesce,resume}() have been changed into
>> scsi_target_{freeze,unfreeze}().
>>
> The description is now partially wrong, as scsi_mq_alloc_queue() is
> certainly not exported (why would it?).
> 
> And it also glosses over the main idea of this patch, namely that not
> only sdev->request_queue is frozen, but also a completely _new_
> request queue is allocated to send SPI DV requests over.
> 
> Please modify the description.

Hi Hannes,

Thanks for the feedback. Please take a look at the attached patch.

>> +    q2 = scsi_mq_alloc_queue(sdev);
>> +
>> +    if (q2) {
>> +        /*
>> +         * Freeze the target such that no other subsystem can submit
>> +         * SCSI commands to 'sdev'. Submitting SCSI commands through
>> +         * q2 may trigger the SCSI error handler. The SCSI error
>> +         * handler must be able to handle a frozen sdev->request_queue
>> +         * and must also use blk_mq_rq_from_pdu(q2)->q instead of
>> +         * sdev->request_queue if it would be necessary to access q2
>> +         * directly.
>> +         */
> 
> ... 'it would be necessary' indicates that it doesn't do so, currently.
> And the SPI DV code most certainly _is_ submitting SCSI commands.
> So doesn't the above imply that SCSI EH will fail to work correctly?
> And if so, why isn't it fixed with some later patch in this series?
> Or how do you plan to address it?
> Hmm?

Before SPI domain validation starts, sdev->request_queue is frozen which
means that DV will only start after all pending SCSI commands have
finished, including potential error handling for these commands.

As far as I know there is only one sdev->request_queue access in the
SCSI error handler, namely in scsi_eh_lock_door(). Patch 5/9 from this
series makes the blk_get_request() call in that function use
BLK_MQ_REQ_NOWAIT so the SCSI error handler should still work fine if a
DV command fails. Does this answer your question?

Thanks,

Bart.

--------------B39536F5FD6544131B87D2AE
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-scsi_transport_spi-Freeze-request-queues-instead-of-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-scsi_transport_spi-Freeze-request-queues-instead-of-.pa";
 filename*1="tch"

From 66156c468f418da09512ef321913627ddf0da20d Mon Sep 17 00:00:00 2001
From: Bart Van Assche <bvanassche@acm.org>
Date: Sun, 30 Aug 2020 09:35:23 -0700
Subject: [PATCH] scsi_transport_spi: Freeze request queues instead of
 quiescing

Instead of quiescing the request queues involved in domain validation,
freeze these. As a result, the struct request_queue pm_only member is no
longer set during domain validation. That will allow to modify
scsi_execute() such that it stops setting the BLK_MQ_REQ_PREEMPT flag.

Attach a secondary request queue for submitting DV requests while the
primary request queue is frozen.

Change scsi_target_{quiesce,resume}() into scsi_target_{freeze,unfreeze}().

Unexport scsi_device_quiesce().

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
 drivers/scsi/scsi_transport_spi.c | 88 ++++++++++++++++++++++---------
 include/scsi/scsi_device.h        |  6 +--
 4 files changed, 76 insertions(+), 41 deletions(-)

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
index 959990f66865..bc02c865e0cc 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -983,6 +983,22 @@ spi_dv_device_internal(struct scsi_device *sdev, struct request_queue *q,
 	}
 }
 
+/*
+ * Allocate a request queue without setting sdev->request_queue such that it
+ * can be used as a secondary SCSI device queue.
+ */
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
@@ -997,59 +1013,79 @@ void
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

--------------B39536F5FD6544131B87D2AE--
