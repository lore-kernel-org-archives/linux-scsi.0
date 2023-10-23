Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65374C00A8F
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 21:58:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233707AbjJWV60 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 17:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233678AbjJWV6X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 17:58:23 -0400
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5B310D8;
        Mon, 23 Oct 2023 14:58:20 -0700 (PDT)
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-5aa7fdd1420so2133760a12.3;
        Mon, 23 Oct 2023 14:58:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698098300; x=1698703100;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MaWb7DT0DEjxXHAAOV/ImKft4gO+Lr1J7bQB17+rCQ0=;
        b=V+SzVXWyTh4cnKlvgrf8c9y/kaq3ANXZ9lclhfEHQ67HbGqiLLuR62FSyQWp7SRM/G
         qz0jE+ZqzEqy3bCaxQrS7NDGaSHVP76pdatlPcUNAtPwAXZraleBoBDniv82dCmtc93o
         P7+Pzfhvt+QHUqAGTnSnNicJ776ipF5zo6Ln3rrxQLLdlatLqLBgIyEToutgvX/oURhu
         1rz3n0jOiBVp6bNfyi2fiWurIimXVQQQdSX6bbGJ5twaS1DJ5a2KBg7bk2HHHhO3rWtL
         xkjL0sVhLD8df/GuZA9Bn5LCXldwIU5+JPnudU6SKtzzUF5F4LS5A2cUuEyaoEQ+KgtL
         undg==
X-Gm-Message-State: AOJu0YwlogkqdXvTgfdJNpd+ONJ+UAcZLKB3Ddk17XnolO+cbgOa08Lt
        1Ex38umBruViTShFA5b3xAI=
X-Google-Smtp-Source: AGHT+IE6esnJMDrUyM3z+ybJewbiE++YW5zP7Yud7ZMukUM2bxcXuoRBeKlrhliMt8CpIUCcL2IVyA==
X-Received: by 2002:a05:6a20:e123:b0:13d:2f80:cf1c with SMTP id kr35-20020a056a20e12300b0013d2f80cf1cmr1074461pzb.17.1698098300070;
        Mon, 23 Oct 2023 14:58:20 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:14f9:170e:9304:1c4e])
        by smtp.gmail.com with ESMTPSA id b12-20020a17090acc0c00b0027d12b1e29dsm7851029pju.25.2023.10.23.14.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 14:58:19 -0700 (PDT)
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
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: [PATCH v14 18/19] scsi: ufs: Forbid auto-hibernation without I/O scheduler
Date:   Mon, 23 Oct 2023 14:54:09 -0700
Message-ID: <20231023215638.3405959-19-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
In-Reply-To: <20231023215638.3405959-1-bvanassche@acm.org>
References: <20231023215638.3405959-1-bvanassche@acm.org>
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
index 3fc33794ce1f..0a21ea9d7576 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4305,6 +4305,30 @@ int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
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
@@ -4313,13 +4337,42 @@ static void ufshcd_configure_auto_hibern8(struct ufs_hba *hba)
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
@@ -4328,6 +4381,13 @@ int ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
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
