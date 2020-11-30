Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56153C8301C
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 02:47:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37464208FE
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 02:47:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgK3CrS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Nov 2020 21:47:18 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38887 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbgK3CrS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Nov 2020 21:47:18 -0500
Received: by mail-pf1-f196.google.com with SMTP id w187so9485632pfd.5;
        Sun, 29 Nov 2020 18:47:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Jq2pbaYrRdnUtUgGV5B/zAxCvRijH9Fr7LSJktZsZ7A=;
        b=OSEUmCznSViTGGyZDbH8N7z+W5nOZwfUfPutt4vdyDosILRvQ4OCnbbaT8V+f9ir4e
         zYd/vVwM6uCwjqhR5xAbjwkFSPcfJc3GYyRLncoUpcWhNhsmiMoP48mLzR43/A7wh3Ts
         xAwmDuBFWUN0HB3cZ/wwdFZYif5z+l++eaQEwCix4kL2oFXf1vIMjl8mEFp6h5pk+JSy
         v9pBW3AiXLuJNrVBC1sRe/IThNpb75Yrdkdo5lze8xnXs1tsnrA+MIjK5HK7QvlD1mia
         A8TngEM+bmniEgIWiv8KPZlR22KvQxIqYPml1IAT6aWlug00G/yjU0bF/alR9o6sJ2FE
         gS/w==
X-Gm-Message-State: AOAM533zZ77mTFEyeRb2vaXQ3hMTIAl1TCMi6Ml2/uJqLMJXmB1oGTrP
        RA3Y6gyDNTXkp6FLcOLx8qs=
X-Google-Smtp-Source: ABdhPJzpSRp/Mil3I70o9W9CkQpnc8PrR/U5w3gWzTBQ6HkOpMcEsCirS9zUshTdRh9J/5PsNyHnOA==
X-Received: by 2002:a63:7f03:: with SMTP id a3mr14168878pgd.313.1606704397262;
        Sun, 29 Nov 2020 18:46:37 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id n127sm14734659pfd.143.2020.11.29.18.46.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Nov 2020 18:46:36 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Martin Kepplinger <martin.kepplinger@puri.sm>
Subject: [PATCH v4 7/9] scsi: Only process PM requests if rpm_status != RPM_ACTIVE
Date:   Sun, 29 Nov 2020 18:46:13 -0800
Message-Id: <20201130024615.29171-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201130024615.29171-1-bvanassche@acm.org>
References: <20201130024615.29171-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of submitting all SCSI commands submitted with scsi_execute() to a
SCSI device if rpm_status != RPM_ACTIVE, only submit RQF_PM (power
management requests) if rpm_status != RPM_ACTIVE. This patch makes the
SCSI core handle the runtime power management status (rpm_status) as it
should be handled.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Can Guo <cang@codeaurora.org>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Martin Kepplinger <martin.kepplinger@puri.sm>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b7ac14571415..91bc39a4c3c3 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -249,7 +249,8 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 
 	req = blk_get_request(sdev->request_queue,
 			data_direction == DMA_TO_DEVICE ?
-			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, BLK_MQ_REQ_PREEMPT);
+			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN,
+			rq_flags & RQF_PM ? BLK_MQ_REQ_PM : 0);
 	if (IS_ERR(req))
 		return ret;
 	rq = scsi_req(req);
@@ -1206,6 +1207,8 @@ static blk_status_t
 scsi_device_state_check(struct scsi_device *sdev, struct request *req)
 {
 	switch (sdev->sdev_state) {
+	case SDEV_CREATED:
+		return BLK_STS_OK;
 	case SDEV_OFFLINE:
 	case SDEV_TRANSPORT_OFFLINE:
 		/*
@@ -1232,18 +1235,18 @@ scsi_device_state_check(struct scsi_device *sdev, struct request *req)
 		return BLK_STS_RESOURCE;
 	case SDEV_QUIESCE:
 		/*
-		 * If the devices is blocked we defer normal commands.
+		 * If the device is blocked we only accept power management
+		 * commands.
 		 */
-		if (req && !(req->rq_flags & RQF_PREEMPT))
+		if (req && WARN_ON_ONCE(!(req->rq_flags & RQF_PM)))
 			return BLK_STS_RESOURCE;
 		return BLK_STS_OK;
 	default:
 		/*
 		 * For any other not fully online state we only allow
-		 * special commands.  In particular any user initiated
-		 * command is not allowed.
+		 * power management commands.
 		 */
-		if (req && !(req->rq_flags & RQF_PREEMPT))
+		if (req && !(req->rq_flags & RQF_PM))
 			return BLK_STS_IOERR;
 		return BLK_STS_OK;
 	}
@@ -2517,15 +2520,13 @@ void sdev_evt_send_simple(struct scsi_device *sdev,
 EXPORT_SYMBOL_GPL(sdev_evt_send_simple);
 
 /**
- *	scsi_device_quiesce - Block user issued commands.
+ *	scsi_device_quiesce - Block all commands except power management.
  *	@sdev:	scsi device to quiesce.
  *
  *	This works by trying to transition to the SDEV_QUIESCE state
  *	(which must be a legal transition).  When the device is in this
- *	state, only special requests will be accepted, all others will
- *	be deferred.  Since special requests may also be requeued requests,
- *	a successful return doesn't guarantee the device will be
- *	totally quiescent.
+ *	state, only power management requests will be accepted, all others will
+ *	be deferred.
  *
  *	Must be called with user context, may sleep.
  *
@@ -2587,12 +2588,12 @@ void scsi_device_resume(struct scsi_device *sdev)
 	 * device deleted during suspend)
 	 */
 	mutex_lock(&sdev->state_mutex);
+	if (sdev->sdev_state == SDEV_QUIESCE)
+		scsi_device_set_state(sdev, SDEV_RUNNING);
 	if (sdev->quiesced_by) {
 		sdev->quiesced_by = NULL;
 		blk_clear_pm_only(sdev->request_queue);
 	}
-	if (sdev->sdev_state == SDEV_QUIESCE)
-		scsi_device_set_state(sdev, SDEV_RUNNING);
 	mutex_unlock(&sdev->state_mutex);
 }
 EXPORT_SYMBOL(scsi_device_resume);
