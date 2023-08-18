Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4530BEE49A0
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Aug 2023 19:47:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379839AbjHRTqq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Aug 2023 15:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379680AbjHRTqV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Aug 2023 15:46:21 -0400
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2AED44BA;
        Fri, 18 Aug 2023 12:45:55 -0700 (PDT)
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-689fa6f94e1so1078081b3a.1;
        Fri, 18 Aug 2023 12:45:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692387893; x=1692992693;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3nGkbMr8f4Di9fmNTcg0EeI1U2lHMPKKJiTC7Gl/Le4=;
        b=Y92L83YMw/FmKVh5ovIFjwroTnBJruzPPY3jaGButfzCkPXBRyRjLZOA79MZ/hfckY
         XKBhjSV5xIGpsfCbNmsR6nkygIMntXDq3x7f6FKYWOcaf+hqlrfn1bNI69rHKcH+WyV3
         7qyt9f6TysR35asNUj6PNJpxURl3uitpsY2w/2qDlJwiAA+QA4d0KftpJlzwb0nLsLLi
         hMA/Lw1YjtnP4RjvQ/ypEVsT2dalNv0LbsnB7tZnX73gi0NUehvjjg4klE+LAg//gZaS
         Eo54mYicPXc1cbH7RDUctxkbejIQYYBEflFgNj6LSZzXj1nWt15r9btw0Av5Nk5nwHp3
         k+3w==
X-Gm-Message-State: AOJu0Yx/wdxopz0G87nZsuEgDrUWPtJFwpiBvNkVsbfp63JiGr2RQWi7
        th9FM3w9za/I1yZDLWF88xw=
X-Google-Smtp-Source: AGHT+IENyR4lLjxKxnHJugBFI37tqAeFW35iUCCyJM4vlgSxkiPPnM+YQGedDS8bleV9sDwcAKw+oA==
X-Received: by 2002:a05:6a20:548f:b0:143:b9c4:966 with SMTP id i15-20020a056a20548f00b00143b9c40966mr236838pzk.22.1692387892903;
        Fri, 18 Aug 2023 12:44:52 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5012:5192:47aa:c304])
        by smtp.gmail.com with ESMTPSA id u16-20020a170903125000b001bb8be10a84sm2115801plh.304.2023.08.18.12.44.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Aug 2023 12:44:52 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Can Guo <quic_cang@quicinc.com>,
        Avri Altman <avri.altman@wdc.com>,
        "Bao D . Nguyen" <quic_nguyenb@quicinc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: [PATCH v10 17/18] scsi: ufs: Forbid auto-hibernation without I/O scheduler
Date:   Fri, 18 Aug 2023 12:34:20 -0700
Message-ID: <20230818193546.2014874-18-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
In-Reply-To: <20230818193546.2014874-1-bvanassche@acm.org>
References: <20230818193546.2014874-1-bvanassche@acm.org>
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

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Can Guo <quic_cang@quicinc.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Bao D. Nguyen <quic_nguyenb@quicinc.com>
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
