Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80B4CC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 21:20:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234064AbjKNVUM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Nov 2023 16:20:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbjKNVUL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Nov 2023 16:20:11 -0500
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34F909D;
        Tue, 14 Nov 2023 13:20:08 -0800 (PST)
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1cc5916d578so54661325ad.2;
        Tue, 14 Nov 2023 13:20:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699996807; x=1700601607;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q5+QxzV8SEnrspkTplBx7X3m9ppb+56nGOToDTc83Nw=;
        b=PGIIVRz7KDltcDI449tLOSbaMaBPAnLSzcp9PWhWWrfgyXaZ1QBZUAZCTAUXPK2Vhu
         R9bmmEWDcXbEci4LN7FnUG+gofOGJX+eA8Xvk1hn2n8lYBf03LUwdgqdYBxB0Jd4ngg4
         SPb8SJoBIXg4YzZ5X39LnhRh0v5IUzXQinJvEKDH0IOrNGoR+a7cfePD17A6uHbKcAPF
         hWHDGrlinkHnqQwhN5GmBvy8isQcYQjqU9G0BT/FUfGu6gD5HqZ23tmiIFj4JzWt6FZd
         R+t4dTlnjrpgFnK5c47XmLZIGWqkmQOfK4ukNd9BvwkufOphWpfD0AG/KYfucWJI+q32
         Vm5w==
X-Gm-Message-State: AOJu0YwGyT/TpPUClbWR3gcHnkaBO4dK9uVafz7jyNi4JKO7QtMQlyJT
        XP34si5wXUWSRhNkvpub+0o=
X-Google-Smtp-Source: AGHT+IFReN0liBceDtxwgA5scU2N9cZo0WgKLj2FWzWIjJvMPyLc1N+99GQMmlSiZXsbWjKffdybMA==
X-Received: by 2002:a17:903:1108:b0:1c3:c687:478c with SMTP id n8-20020a170903110800b001c3c687478cmr4691366plh.8.1699996807528;
        Tue, 14 Nov 2023 13:20:07 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:2278:ad72:cefb:4d49])
        by smtp.gmail.com with ESMTPSA id ix7-20020a170902f80700b001c71ec1866fsm6169288plb.258.2023.11.14.13.20.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Nov 2023 13:20:07 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "Bao D . Nguyen" <quic_nguyenb@quicinc.com>,
        Can Guo <quic_cang@quicinc.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: [PATCH v15 19/19] scsi: ufs: Inform the block layer about write ordering
Date:   Tue, 14 Nov 2023 13:16:27 -0800
Message-ID: <20231114211804.1449162-20-bvanassche@acm.org>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231114211804.1449162-1-bvanassche@acm.org>
References: <20231114211804.1449162-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From the UFSHCI 4.0 specification, about the legacy (single queue) mode:
"The host controller always process transfer requests in-order according
to the order submitted to the list. In case of multiple commands with
single doorbell register ringing (batch mode), The dispatch order for
these transfer requests by host controller will base on their index in
the List. A transfer request with lower index value will be executed
before a transfer request with higher index value."

From the UFSHCI 4.0 specification, about the MCQ mode:
"Command Submission
1. Host SW writes an Entry to SQ
2. Host SW updates SQ doorbell tail pointer

Command Processing
3. After fetching the Entry, Host Controller updates SQ doorbell head
   pointer
4. Host controller sends COMMAND UPIU to UFS device"

In other words, for both legacy and MCQ mode, UFS controllers are
required to forward commands to the UFS device in the order these
commands have been received from the host.

Notes:
- For legacy mode this is only correct if the host submits one
  command at a time. The UFS driver does this.
- Also in legacy mode, the command order is not preserved if
  auto-hibernation is enabled in the UFS controller. Hence, enable
  zone write locking if auto-hibernation is enabled.

This patch improves performance as follows on my test setup:
- With the mq-deadline scheduler: 2.5x more IOPS for small writes.
- When not using an I/O scheduler compared to using mq-deadline with
  zone locking: 4x more IOPS for small writes.

Reviewed-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Reviewed-by: Can Guo <quic_cang@quicinc.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 732509289165..e78954cda3ae 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4421,6 +4421,20 @@ static int ufshcd_update_preserves_write_order(struct ufs_hba *hba,
 				return -EPERM;
 		}
 	}
+	shost_for_each_device(sdev, hba->host)
+		blk_freeze_queue_start(sdev->request_queue);
+	shost_for_each_device(sdev, hba->host) {
+		struct request_queue *q = sdev->request_queue;
+
+		blk_mq_freeze_queue_wait(q);
+		q->limits.driver_preserves_write_order = preserves_write_order;
+		blk_queue_required_elevator_features(q,
+			!preserves_write_order && blk_queue_is_zoned(q) ?
+			ELEVATOR_F_ZBD_SEQ_WRITE : 0);
+		if (q->disk)
+			disk_set_zoned(q->disk, q->limits.zoned);
+		blk_mq_unfreeze_queue(q);
+	}
 
 	return 0;
 }
@@ -4463,7 +4477,8 @@ int ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 
 	if (!is_mcq_enabled(hba) && !prev_state && new_state) {
 		/*
-		 * Auto-hibernation will be enabled for legacy UFSHCI mode.
+		 * Auto-hibernation will be enabled for legacy UFSHCI mode. Tell
+		 * the block layer that write requests may be reordered.
 		 */
 		ret = ufshcd_update_preserves_write_order(hba, false);
 		if (ret)
@@ -4479,7 +4494,8 @@ int ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 	}
 	if (!is_mcq_enabled(hba) && prev_state && !new_state) {
 		/*
-		 * Auto-hibernation has been disabled.
+		 * Auto-hibernation has been disabled. Tell the block layer that
+		 * the order of write requests is preserved.
 		 */
 		ret = ufshcd_update_preserves_write_order(hba, true);
 		WARN_ON_ONCE(ret);
@@ -5247,6 +5263,10 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 	struct ufs_hba *hba = shost_priv(sdev->host);
 	struct request_queue *q = sdev->request_queue;
 
+	q->limits.driver_preserves_write_order =
+		!ufshcd_is_auto_hibern8_supported(hba) ||
+		FIELD_GET(UFSHCI_AHIBERN8_TIMER_MASK, hba->ahit) == 0;
+
 	blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD - 1);
 
 	/*
@@ -9026,6 +9046,7 @@ static const struct scsi_host_template ufshcd_driver_template = {
 	.max_host_blocked	= 1,
 	.track_queue_depth	= 1,
 	.skip_settle_delay	= 1,
+	.needs_prepare_resubmit	= 1,
 	.sdev_groups		= ufshcd_driver_groups,
 	.rpm_autosuspend_delay	= RPM_AUTOSUSPEND_DELAY_MS,
 };
