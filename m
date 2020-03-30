Return-Path: <SRS0=+9Kw=5P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 361E9C2D0E5
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Mar 2020 14:49:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01EE020781
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Mar 2020 14:49:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="bZQT8U7y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgC3Otw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Mar 2020 10:49:52 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:52587 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728159AbgC3Otu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Mar 2020 10:49:50 -0400
Received: by mail-pj1-f65.google.com with SMTP id ng8so7682218pjb.2
        for <linux-scsi@vger.kernel.org>; Mon, 30 Mar 2020 07:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dM88C1QGqBI6GelWDoTaSxU6lxBt7GdfPhOw1+SN7L4=;
        b=bZQT8U7yeFC0d8TYNbHn5nxihcCGYzsucQuteR7S/owSBM74VPEGKfvp1QygPlLklu
         7A8Cf+UJ2EJnU6xm+0oGKWQydb4lR8JoJNOjkbL9XKP7aFLsL40p+BMaSrDFU1lQNio9
         7f/kbrNNjQ/MHbdaUvWE0x8rRGWFOqb6aL9sA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dM88C1QGqBI6GelWDoTaSxU6lxBt7GdfPhOw1+SN7L4=;
        b=Vwku2hE+Fbh/WRnsv7XHNwC8NeLK3iEatKSuuRaGfFduyVXEdqFarToN9cbEK/DwJu
         yQMUZNA6rvWdsH63A79YMtIqScgxX4MpVpWAQH9rBqMSa37lo+BNmjIMVimwvDQHuSVw
         82wEYgmvODmEv0rwnI/wGxkfYzlI3Qb8/pU1chQjNad3lJSujBiCLXIiVCxdGHDd5pXb
         +aNs//xNSsj3tmvvmy+AndHGD5s3WZ+RUgLpk+v93wGVJ0mbTjXeG/uEIBzjol3hErdR
         f4cSE20NyI4ZWZkmqQW1+BuozfIwm7ww0s10SwZVdHoXulEuWwnmKPLg7Kg3UyHFHVnx
         bf+A==
X-Gm-Message-State: ANhLgQ0OeLGYQHlxu3+eX6oJuEjMMDqZVX6E+qoOTnowWEFxiIJ/Qwtt
        dAxxQ3E0Ycg5X/gWHGYUIc3Iug==
X-Google-Smtp-Source: ADFU+vs7rQVtixqgI9wBPaqXU1+aDYgI08FylS7YrS5dAycbwFZ775FR+CDJE1eOdLSXZ5NRtFq8wA==
X-Received: by 2002:a17:90a:7f03:: with SMTP id k3mr16139676pjl.42.1585579788982;
        Mon, 30 Mar 2020 07:49:48 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:24fa:e766:52c9:e3b2])
        by smtp.gmail.com with ESMTPSA id y198sm1460972pfg.123.2020.03.30.07.49.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 07:49:48 -0700 (PDT)
From:   Douglas Anderson <dianders@chromium.org>
To:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-block@vger.kernel.org, groeck@chromium.org,
        paolo.valente@linaro.org, linux-scsi@vger.kernel.org,
        sqazi@google.com, Douglas Anderson <dianders@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] scsi: core: Fix stall if two threads request budget at the same time
Date:   Mon, 30 Mar 2020 07:49:06 -0700
Message-Id: <20200330074856.2.I28278ef8ea27afc0ec7e597752a6d4e58c16176f@changeid>
X-Mailer: git-send-email 2.26.0.rc2.310.g2932bb562d-goog
In-Reply-To: <20200330144907.13011-1-dianders@chromium.org>
References: <20200330144907.13011-1-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It is possible for two threads to be running
blk_mq_do_dispatch_sched() at the same time with the same "hctx".
This is because there can be more than one caller to
__blk_mq_run_hw_queue() with the same "hctx" and hctx_lock() doesn't
prevent more than one thread from entering.

If more than one thread is running blk_mq_do_dispatch_sched() at the
same time with the same "hctx", they may have contention acquiring
budget.  The blk_mq_get_dispatch_budget() can eventually translate
into scsi_mq_get_budget().  If the device's "queue_depth" is 1 (not
uncommon) then only one of the two threads will be the one to
increment "device_busy" to 1 and get the budget.

The losing thread will break out of blk_mq_do_dispatch_sched() and
will stop dispatching requests.  The assumption is that when more
budget is available later (when existing transactions finish) the
queue will be kicked again, perhaps in scsi_end_request().

The winning thread now has budget and can go on to call
dispatch_request().  If dispatch_request() returns NULL here then we
have a potential problem.  Specifically we'll now call
blk_mq_put_dispatch_budget() which translates into
scsi_mq_put_budget().  That will mark the device as no longer busy but
doesn't do anything to kick the queue.  This violates the assumption
that the queue would be kicked when more budget was available.

Pictorially:

Thread A                          Thread B
================================= ==================================
blk_mq_get_dispatch_budget() => 1
dispatch_request() => NULL
                                  blk_mq_get_dispatch_budget() => 0
                                  // because Thread A marked
                                  // "device_busy" in scsi_device
blk_mq_put_dispatch_budget()

The above case was observed in reboot tests and caused a task to hang
forever waiting for IO to complete.  Traces showed that in fact two
tasks were running blk_mq_do_dispatch_sched() at the same time with
the same "hctx".  The task that got the budget did in fact see
dispatch_request() return NULL.  Both tasks returned and the system
went on for several minutes (until the hung task delay kicked in)
without the given "hctx" showing up again in traces.

Let's attempt to fix this problem by detecting budget contention.  If
we're in the SCSI code's put_budget() function and we saw that someone
else might have wanted the budget we got then we'll kick the queue.

The mechanism of kicking due to budget contention has the potential to
overcompensate and kick the queue more than strictly necessary, but it
shouldn't hurt.

Signed-off-by: Douglas Anderson <dianders@chromium.org>
---

 drivers/scsi/scsi_lib.c    | 27 ++++++++++++++++++++++++---
 drivers/scsi/scsi_scan.c   |  1 +
 include/scsi/scsi_device.h |  2 ++
 3 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 610ee41fa54c..0530da909995 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -344,6 +344,21 @@ static void scsi_dec_host_busy(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 	rcu_read_unlock();
 }
 
+static void scsi_device_dec_busy(struct scsi_device *sdev)
+{
+	bool was_contention;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sdev->budget_lock, flags);
+	atomic_dec(&sdev->device_busy);
+	was_contention = sdev->budget_contention;
+	sdev->budget_contention = false;
+	spin_unlock_irqrestore(&sdev->budget_lock, flags);
+
+	if (was_contention)
+		blk_mq_run_hw_queues(sdev->request_queue, true);
+}
+
 void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *shost = sdev->host;
@@ -354,7 +369,7 @@ void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd *cmd)
 	if (starget->can_queue > 0)
 		atomic_dec(&starget->target_busy);
 
-	atomic_dec(&sdev->device_busy);
+	scsi_device_dec_busy(sdev);
 }
 
 static void scsi_kick_queue(struct request_queue *q)
@@ -1624,16 +1639,22 @@ static void scsi_mq_put_budget(struct blk_mq_hw_ctx *hctx)
 	struct request_queue *q = hctx->queue;
 	struct scsi_device *sdev = q->queuedata;
 
-	atomic_dec(&sdev->device_busy);
+	scsi_device_dec_busy(sdev);
 }
 
 static bool scsi_mq_get_budget(struct blk_mq_hw_ctx *hctx)
 {
 	struct request_queue *q = hctx->queue;
 	struct scsi_device *sdev = q->queuedata;
+	unsigned long flags;
 
-	if (scsi_dev_queue_ready(q, sdev))
+	spin_lock_irqsave(&sdev->budget_lock, flags);
+	if (scsi_dev_queue_ready(q, sdev)) {
+		spin_unlock_irqrestore(&sdev->budget_lock, flags);
 		return true;
+	}
+	sdev->budget_contention = true;
+	spin_unlock_irqrestore(&sdev->budget_lock, flags);
 
 	if (atomic_read(&sdev->device_busy) == 0 && !scsi_device_blocked(sdev))
 		blk_mq_delay_run_hw_queue(hctx, SCSI_QUEUE_DELAY);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 058079f915f1..72f7b6faed9b 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -240,6 +240,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	INIT_LIST_HEAD(&sdev->starved_entry);
 	INIT_LIST_HEAD(&sdev->event_list);
 	spin_lock_init(&sdev->list_lock);
+	spin_lock_init(&sdev->budget_lock);
 	mutex_init(&sdev->inquiry_mutex);
 	INIT_WORK(&sdev->event_work, scsi_evt_thread);
 	INIT_WORK(&sdev->requeue_work, scsi_requeue_run_queue);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index f8312a3e5b42..3c5e0f0c8a91 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -106,6 +106,8 @@ struct scsi_device {
 	struct list_head    siblings;   /* list of all devices on this host */
 	struct list_head    same_target_siblings; /* just the devices sharing same target id */
 
+	spinlock_t budget_lock;		/* For device_busy and budget_contention */
+	bool budget_contention;		/* Someone couldn't get budget */
 	atomic_t device_busy;		/* commands actually active on LLDD */
 	atomic_t device_blocked;	/* Device returned QUEUE_FULL. */
 
-- 
2.26.0.rc2.310.g2932bb562d-goog

