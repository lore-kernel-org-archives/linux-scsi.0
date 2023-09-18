Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82E4ECD37B0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Sep 2023 16:59:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbjIRQ7X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Sep 2023 12:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbjIRQ7E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Sep 2023 12:59:04 -0400
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789B1D6;
        Mon, 18 Sep 2023 09:58:58 -0700 (PDT)
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-6c09d760cb9so2987230a34.2;
        Mon, 18 Sep 2023 09:58:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695056337; x=1695661137;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c2vSWbaA+nCLUUjiKCgMRYyAM+te1fbrLUvs69miu8E=;
        b=ZIN82FFPRXwmZWItQy9hrq/dKPpvgkT+jj5spjRdNUGvmRzGSvsopE49gztUMnyzG0
         8fmKeq0clZx7FFRSoHueYVcC9FijOyFcmanD1rVDRcnQf0utYLyrwApsjIeh3b9Itd1D
         7CSGJE1zAM6pvKPIIk+uuqGRaFdRygSUG55fb7omrMRSZrSRH9z4SEmw8Lumbj6hrQBv
         vupjkpOoCy0ng63dPHAsB+7Un2dsxwrDnCzc8xDqmz2N2VQqV1K06zpWnqTEQ5nPgwgN
         pppaPLu2h7MCrb2n/lwJaJk2AlKpYJGzoPv9wahSwVjMonsjcjiKzyqFz6SG0X3R+5No
         3V+A==
X-Gm-Message-State: AOJu0YyfxEvvdqYY1/IMOicR0p9zMugvEG87lDz86YrjpwIw6RCFSkC8
        nj+MQwt6D6ZWowg7fDmTzqk=
X-Google-Smtp-Source: AGHT+IG4URXfcIqkbSx26sXGDXlYhciwz8A/HnsSEcJWncmVnDZkai+9m5s063BMwCnXKi/9pZ2M2A==
X-Received: by 2002:a05:6830:100c:b0:6b9:4216:c209 with SMTP id a12-20020a056830100c00b006b94216c209mr8614005otp.12.1695056337589;
        Mon, 18 Sep 2023 09:58:57 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:33e7:1437:5d00:8e3b])
        by smtp.gmail.com with ESMTPSA id p17-20020a639511000000b005740aa41237sm5658041pgd.74.2023.09.18.09.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 09:58:57 -0700 (PDT)
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
Subject: [PATCH v12 15/16] scsi: ufs: Forbid auto-hibernation without I/O scheduler
Date:   Mon, 18 Sep 2023 09:55:54 -0700
Message-ID: <20230918165713.1598705-16-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
In-Reply-To: <20230918165713.1598705-1-bvanassche@acm.org>
References: <20230918165713.1598705-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UFSHCI controllers in legacy mode do not preserve the write order if
auto-hibernation is enabled. If the write order is not preserved, an I/O
scheduler is required to serialize zoned writes. Hence do not allow
auto-hibernation to be enabled without I/O scheduler if a zoned logical unit
is present and if the controller is operating in legacy mode. This patch has
been tested with the following shell script:

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
 drivers/ufs/core/ufshcd.c | 60 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d98c639a76a3..c6823435442e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4304,6 +4304,30 @@ int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
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
@@ -4312,13 +4336,42 @@ static void ufshcd_configure_auto_hibern8(struct ufs_hba *hba)
 	ufshcd_writel(hba, hba->ahit, REG_AUTO_HIBERNATE_IDLE_TIMER);
 }
 
+/**
+ * ufshcd_auto_hibern8_update() - Modify the auto-hibernation control register
+ * @hba: per-adapter instance
+ * @ahit: New auto-hibernate settings. Includes the scale and the value of the
+ * auto-hibernation timer. See also the UFSHCI_AHIBERN8_TIMER_MASK and
+ * UFSHCI_AHIBERN8_SCALE_MASK constants.
+ *
+ * Notes:
+ * - UFSHCI controllers do not preserve the command order in legacy mode
+ *   if auto-hibernation is enabled. If the command order is not preserved, an
+ *   I/O scheduler that serializes zoned writes (mq-deadline) is required if a
+ *   zoned logical unit is present. Enabling auto-hibernation without attaching
+ *   the mq-deadline scheduler first may cause unaligned write errors for the
+ *   zoned logical unit if a zoned logical unit is present.
+ * - Calls of this function must be serialized.
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
@@ -4327,6 +4380,13 @@ int ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
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
