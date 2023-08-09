Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92089C001B0
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Aug 2023 20:24:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234536AbjHIUYp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Aug 2023 16:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234562AbjHIUYc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Aug 2023 16:24:32 -0400
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A67D42737;
        Wed,  9 Aug 2023 13:24:17 -0700 (PDT)
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-564af0ac494so203218a12.0;
        Wed, 09 Aug 2023 13:24:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691612657; x=1692217457;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5GQvRWKNYdRiuW/Tcxgs198CxU/SAUQOToewtQo4mxI=;
        b=gifHS4Ii9XgWJ9aOswiF7EkaAW8y7luZfbXkiWuUa8FqENomZFp94e+54sCCw64SUk
         AI7XciyzgVlJGsi7hvvFohiHmNgYKUn3QYx3OnOXOoXGUTIG3d0vwMXlBITQlKiTWDaI
         xRAMb1yly8dK8j9XbuQFYEJUlZF1rWhyLJYqi0ruL1aWaJLa5iASd+YxVJMBWug+Q2iu
         zq8YGKsjoNvq33hGi/4ghF6R7AhdpeaUwgvVp3+Kv2SnV6bVJUX7U5WM6gVjRsfN6J5t
         qHEY+PtmocpaogreseIydE589OswTFWjkacCdQTZoVN7g6njS67fgfDq1W/px+HnUc3Z
         5IMw==
X-Gm-Message-State: AOJu0YyWacxJqe+BtbjGIqjGbBalUaj/R7fZ8yucOLIFo+EyApwjJC9q
        C7d4Z6PmUNzNlFwT4976V7I=
X-Google-Smtp-Source: AGHT+IGI2lF8cTD7f0JakBeSSM5vUd4YS+85+eChvlIBblwBYJ6SnBf4rQ3RjhxDCDp2TGYmXDv+VA==
X-Received: by 2002:a17:90b:1e12:b0:268:47c2:e490 with SMTP id pg18-20020a17090b1e1200b0026847c2e490mr331892pjb.1.1691612656880;
        Wed, 09 Aug 2023 13:24:16 -0700 (PDT)
Received: from bvanassche-glaptop2.roam.corp.google.com ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id gq9-20020a17090b104900b002694da8a9cdsm1868103pjb.48.2023.08.09.13.24.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 13:24:16 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Can Guo <quic_cang@quicinc.com>,
        Avri Altman <avri.altman@wdc.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: [PATCH v7 7/7] scsi: ufs: Disable zone write locking
Date:   Wed,  9 Aug 2023 13:23:48 -0700
Message-ID: <20230809202355.1171455-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
In-Reply-To: <20230809202355.1171455-1-bvanassche@acm.org>
References: <20230809202355.1171455-1-bvanassche@acm.org>
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

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Can Guo <quic_cang@quicinc.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ae7b868f9c26..ae6b63b02930 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4337,23 +4337,50 @@ int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
 }
 EXPORT_SYMBOL_GPL(ufshcd_uic_hibern8_exit);
 
+static void ufshcd_update_zone_write_lock(struct ufs_hba *hba,
+					  bool use_zone_write_lock)
+{
+	struct scsi_device *sdev;
+
+	shost_for_each_device(sdev, hba->host)
+		blk_freeze_queue_start(sdev->request_queue);
+	shost_for_each_device(sdev, hba->host) {
+		struct request_queue *q = sdev->request_queue;
+
+		blk_mq_freeze_queue_wait(q);
+		q->limits.use_zone_write_lock = use_zone_write_lock;
+		blk_mq_unfreeze_queue(q);
+	}
+}
+
 void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 {
 	unsigned long flags;
-	bool update = false;
+	bool prev_state, new_state, update = false;
 
 	if (!ufshcd_is_auto_hibern8_supported(hba))
 		return;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
+	prev_state = ufshcd_is_auto_hibern8_enabled(hba);
 	if (hba->ahit != ahit) {
 		hba->ahit = ahit;
 		update = true;
 	}
+	new_state = ufshcd_is_auto_hibern8_enabled(hba);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	if (!update)
 		return;
+	if (!is_mcq_enabled(hba) && !prev_state && new_state) {
+		/*
+		 * Auto-hibernation will be enabled. Enable write locking for
+		 * zoned writes since auto-hibernation may cause reordering of
+		 * zoned writes when using the legacy mode of the UFS host
+		 * controller.
+		 */
+		ufshcd_update_zone_write_lock(hba, true);
+	}
 	if (!pm_runtime_suspended(&hba->ufs_device_wlun->sdev_gendev)) {
 		ufshcd_rpm_get_sync(hba);
 		ufshcd_hold(hba);
@@ -4361,6 +4388,13 @@ void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 		ufshcd_release(hba);
 		ufshcd_rpm_put_sync(hba);
 	}
+	if (!is_mcq_enabled(hba) && prev_state && !new_state) {
+		/*
+		 * Auto-hibernation has been disabled. Disable write locking
+		 * for zoned writes.
+		 */
+		ufshcd_update_zone_write_lock(hba, false);
+	}
 }
 EXPORT_SYMBOL_GPL(ufshcd_auto_hibern8_update);
 
@@ -5140,6 +5174,7 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 
 	ufshcd_hpb_configure(hba, sdev);
 
+	q->limits.use_zone_write_lock = false;
 	blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD - 1);
 	if (hba->quirks & UFSHCD_QUIRK_4KB_DMA_ALIGNMENT)
 		blk_queue_update_dma_alignment(q, SZ_4K - 1);
