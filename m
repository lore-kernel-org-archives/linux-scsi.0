Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0453EE49B1
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Aug 2023 19:20:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjHVTUP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Aug 2023 15:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbjHVTUN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Aug 2023 15:20:13 -0400
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B75951BE;
        Tue, 22 Aug 2023 12:20:05 -0700 (PDT)
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-51b4ef5378bso3454661a12.1;
        Tue, 22 Aug 2023 12:20:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692732005; x=1693336805;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bhEE5rTGdKfdoShqKbxndfVcHcv8Xl0IxiGnxC2ZmBM=;
        b=FImsoCyAN80Cac0D35wyiypJwn9EtBlGSPpH9US/witZrGZGvSeiAH+L3X5Fv3v4pO
         lSsQ2HaB77IBPyzrznHEcVQSSzuQQ5UDrISaoyeenjJoL6wF3bjEgwfTCsLa3HAO9UTQ
         Al+GAOHlxwUrfdegYY9kQSXKaIodrctAlfOM0OfSH+jwvMcR6CfvIbs32x+sCeS7RqsB
         GSgFEQ/7cRJ/RQu5LIo43K9FcTdNVLS9aL6KZr+KHTTwvAMtUBj54hIuDC0L6jb+36TD
         7VGgH3uhndQH2hJFpmg9MwQzBUs27mrNYl4mhICiwV/45+5sSnZfeuVp+jAcITaqdi/1
         1x2w==
X-Gm-Message-State: AOJu0Yzcsskg4qVT4w2aWLEuXEohUkTUZlG5SoEBYAzM57hxZ9TryIjC
        0mZO67zznQB2r0Rt9mqcEaz/vzfpde4=
X-Google-Smtp-Source: AGHT+IER2E/nfQVQZwR3MkQEWNJmYW8Kw1VweZkdUVAFn55zSGqdeiQffpIyqEOtZf/YudS0tw4RzA==
X-Received: by 2002:a17:90a:db15:b0:263:2335:594e with SMTP id g21-20020a17090adb1500b002632335594emr9697252pjv.38.1692732005075;
        Tue, 22 Aug 2023 12:20:05 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:88be:bf57:de29:7cc])
        by smtp.gmail.com with ESMTPSA id m11-20020a17090a414b00b002696bd123e4sm8081632pjg.46.2023.08.22.12.20.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Aug 2023 12:20:04 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "Bao D . Nguyen" <quic_nguyenb@quicinc.com>,
        Can Guo <quic_cang@quicinc.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: [PATCH v11 15/16] scsi: ufs: Forbid auto-hibernation without I/O scheduler
Date:   Tue, 22 Aug 2023 12:17:10 -0700
Message-ID: <20230822191822.337080-16-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
In-Reply-To: <20230822191822.337080-1-bvanassche@acm.org>
References: <20230822191822.337080-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UFSHCI 3.0 controllers do not preserve the write order if auto-hibernation
is enabled. If the write order is not preserved, an I/O scheduler is
required to serialize zoned writes. Hence do not allow auto-hibernation
to be enabled without I/O scheduler if a zoned logical unit is present
and if the controller is operating in legacy mode. This patch has been
tested with the following shell script:

    show_ah8() {
        echo -n "auto_hibern8: "
        adb shell "cat /sys/devices/platform/13200000.ufs/auto_hibern8"
    }

    set_ah8() {
        local rc
        adb shell "echo $1 > /sys/devices/platform/13200000.ufs/auto_hibern8"
        rc=$?
        show_ah8
        return $rc
    }

    set_iosched() {
        adb shell "echo $1 >/sys/class/block/$zoned_bdev/queue/scheduler &&
    	           echo -n 'I/O scheduler: ' &&
	           cat /sys/class/block/sde/queue/scheduler"
    }

    adb root
    zoned_bdev=$(adb shell grep -lvw 0 /sys/class/block/sd*/queue/chunk_sectors |&
	         sed 's|/sys/class/block/||g;s|/queue/chunk_sectors||g')
    [ -n "$zoned_bdev" ]
    show_ah8
    set_ah8 0
    set_iosched none
    if set_ah8 150000; then
        echo "Error: enabled AH8 without I/O scheduler"
    fi
    set_iosched mq-deadline
    set_ah8 150000

Reviewed-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Reviewed-by: Can Guo <quic_cang@quicinc.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 58 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 68bf8e94eee6..c28a362b5b99 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4337,6 +4337,30 @@ int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
 }
 EXPORT_SYMBOL_GPL(ufshcd_uic_hibern8_exit);
 
+static int ufshcd_update_preserves_write_order(struct ufs_hba *hba,
+					       bool preserves_write_order)
+{
+	struct scsi_device *sdev;
+
+	if (!preserves_write_order) {
+		shost_for_each_device(sdev, hba->host) {
+			struct request_queue *q = sdev->request_queue;
+
+			/*
+			 * Refuse to enable auto-hibernation if no I/O scheduler
+			 * is present. This code does not check whether the
+			 * attached I/O scheduler serializes zoned writes
+			 * (ELEVATOR_F_ZBD_SEQ_WRITE) because this cannot be
+			 * checked from outside the block layer core.
+			 */
+			if (blk_queue_is_zoned(q) && !q->elevator)
+				return -EPERM;
+		}
+	}
+
+	return 0;
+}
+
 static void ufshcd_configure_auto_hibern8(struct ufs_hba *hba)
 {
 	if (!ufshcd_is_auto_hibern8_supported(hba))
@@ -4345,13 +4369,40 @@ static void ufshcd_configure_auto_hibern8(struct ufs_hba *hba)
 	ufshcd_writel(hba, hba->ahit, REG_AUTO_HIBERNATE_IDLE_TIMER);
 }
 
+/**
+ * ufshcd_auto_hibern8_update() - Modify the auto-hibernation control register
+ * @hba: per-adapter instance
+ * @ahit: New auto-hibernate settings. Includes the scale and the value of the
+ * auto-hibernation timer. See also the UFSHCI_AHIBERN8_TIMER_MASK and
+ * UFSHCI_AHIBERN8_SCALE_MASK constants.
+ *
+ * A note: UFSHCI controllers do not preserve the command order in legacy mode
+ * if auto-hibernation is enabled. If the command order is not preserved, an
+ * I/O scheduler that serializes zoned writes (mq-deadline) is required if a
+ * zoned logical unit is present. Enabling auto-hibernation without attaching
+ * the mq-deadline scheduler first may cause unaligned write errors for the
+ * zoned logical unit if a zoned logical unit is present.
+ */
 int ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 {
 	const u32 cur_ahit = READ_ONCE(hba->ahit);
+	bool prev_state, new_state;
+	int ret;
 
 	if (!ufshcd_is_auto_hibern8_supported(hba) || cur_ahit == ahit)
 		return 0;
 
+	prev_state = FIELD_GET(UFSHCI_AHIBERN8_TIMER_MASK, cur_ahit);
+	new_state = FIELD_GET(UFSHCI_AHIBERN8_TIMER_MASK, ahit);
+
+	if (!is_mcq_enabled(hba) && !prev_state && new_state) {
+		/*
+		 * Auto-hibernation will be enabled for legacy UFSHCI mode.
+		 */
+		ret = ufshcd_update_preserves_write_order(hba, false);
+		if (ret)
+			return ret;
+	}
 	WRITE_ONCE(hba->ahit, ahit);
 	if (!pm_runtime_suspended(&hba->ufs_device_wlun->sdev_gendev)) {
 		ufshcd_rpm_get_sync(hba);
@@ -4360,6 +4411,13 @@ int ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 		ufshcd_release(hba);
 		ufshcd_rpm_put_sync(hba);
 	}
+	if (!is_mcq_enabled(hba) && prev_state && !new_state) {
+		/*
+		 * Auto-hibernation has been disabled.
+		 */
+		ret = ufshcd_update_preserves_write_order(hba, true);
+		WARN_ON_ONCE(ret);
+	}
 
 	return 0;
 }
