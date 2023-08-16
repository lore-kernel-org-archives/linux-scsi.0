Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C59EC25B5E
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Aug 2023 19:57:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345955AbjHPT46 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Aug 2023 15:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346042AbjHPT4z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Aug 2023 15:56:55 -0400
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C618E2D5F;
        Wed, 16 Aug 2023 12:56:27 -0700 (PDT)
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-68890d565b5so803310b3a.2;
        Wed, 16 Aug 2023 12:56:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692215787; x=1692820587;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BTSMOfTx0pMCvUPspES6iLE7qSqH956qQYDrRNFNXN0=;
        b=WUf9F7iCQZNGUqmxClTqpb4m9FSI4pvuiAftttQH+H2qjTV1h2PrMjJphE7PQWtQ+u
         DDO20b/B+tzexWrYDvTm2XNOAdsgWHjfU6al7x/dQzOxLriMvUlLC53z7cXE8YYFqpwZ
         UZ7OWYKoeIB08lLei+ZE6Z/y/3xBjx1l5++LG/uuI5WqKA1jWPxKTCRqNc7pqPmKtpqA
         JgsnZzgYyaQAvSvtZQdsCUSoSTcKIBYEEFwG7gr149vWpaSEN3Gx8DjiUVfakBpsGD4P
         WYrJX6PtE3EvBfRu5wZeQv/Tz+/SPt69rBsO+eZqbDJ+/znQMtiXxgI0TLynxX2WfGk0
         3Oaw==
X-Gm-Message-State: AOJu0YyyKW4CeTZaoPBF42rfq3MmOYIF803ySU7QrhEVUWgAgkVOVxZy
        QDNDoJxGJRnFw+AMNybXk2k=
X-Google-Smtp-Source: AGHT+IEDc8pSVKHfw7i1ypJBfLFz4tYdsFxrGYr8CsQdd5+U8nKNL/D8ivw6SLkFT0gnT9UG6kAlFQ==
X-Received: by 2002:a05:6a00:438a:b0:688:2253:ce07 with SMTP id bt10-20020a056a00438a00b006882253ce07mr2703662pfb.2.1692215787161;
        Wed, 16 Aug 2023 12:56:27 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:7141:e456:f574:7de0])
        by smtp.gmail.com with ESMTPSA id r26-20020a62e41a000000b0068890c19c49sm1588508pfh.180.2023.08.16.12.56.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Aug 2023 12:56:26 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Can Guo <quic_cang@quicinc.com>,
        Avri Altman <avri.altman@wdc.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Lu Hongfei <luhongfei@vivo.com>,
        Daniil Lunev <dlunev@chromium.org>,
        Peter Wang <peter.wang@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <arthur.simchaev@wdc.com>,
        zhanghui <zhanghui31@xiaomi.com>,
        Po-Wen Kao <powen.kao@mediatek.com>,
        Eric Biggers <ebiggers@google.com>,
        Keoseong Park <keosung.park@samsung.com>
Subject: [PATCH v9 16/17] scsi: ufs: Forbid auto-hibernation without I/O scheduler
Date:   Wed, 16 Aug 2023 12:53:28 -0700
Message-ID: <20230816195447.3703954-17-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
In-Reply-To: <20230816195447.3703954-1-bvanassche@acm.org>
References: <20230816195447.3703954-1-bvanassche@acm.org>
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
Cc: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-sysfs.c   |  2 +-
 drivers/ufs/core/ufshcd-priv.h |  1 -
 drivers/ufs/core/ufshcd.c      | 60 ++++++++++++++++++++++++++++++++--
 include/ufs/ufshcd.h           |  2 +-
 4 files changed, 60 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 6c72075750dd..a693dea1bd18 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -203,7 +203,7 @@ static ssize_t auto_hibern8_store(struct device *dev,
 		goto out;
 	}
 
-	ufshcd_auto_hibern8_update(hba, ufshcd_us_to_ahit(timer));
+	ret = ufshcd_auto_hibern8_update(hba, ufshcd_us_to_ahit(timer));
 
 out:
 	up(&hba->host_sem);
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index 0f3bd943b58b..a2b74fbc2056 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -60,7 +60,6 @@ int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
 		      enum attr_idn idn, u8 index, u8 selector, u32 *attr_val);
 int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 	enum flag_idn idn, u8 index, bool *flag_res);
-void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit);
 void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
 			  struct cq_entry *cqe);
 int ufshcd_mcq_init(struct ufs_hba *hba);
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 39000c018d8b..37d430d20939 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4337,6 +4337,29 @@ int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
 }
 EXPORT_SYMBOL_GPL(ufshcd_uic_hibern8_exit);
 
+static int ufshcd_update_preserves_write_order(struct ufs_hba *hba,
+						bool preserves_write_order)
+{
+	struct scsi_device *sdev;
+
+	if (!preserves_write_order) {
+		shost_for_each_device(sdev, hba->host) {
+			struct request_queue *q = sdev->request_queue;
+
+			/*
+			 * This code does not check whether the attached I/O
+			 * scheduler serializes zoned writes
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
@@ -4345,13 +4368,37 @@ static void ufshcd_configure_auto_hibern8(struct ufs_hba *hba)
 	ufshcd_writel(hba, hba->ahit, REG_AUTO_HIBERNATE_IDLE_TIMER);
 }
 
-void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
+/**
+ * ufshcd_auto_hibern8_update() - Modify the auto-hibernation control register
+ * @hba: per-adapter instance
+ * @ahit: New auto-hibernate settings. Includes the scale and the value of the
+ * auto-hibernation timer. See also the UFSHCI_AHIBERN8_TIMER_MASK and
+ * UFSHCI_AHIBERN8_SCALE_MASK constants.
+ *
+ * Note: enabling auto-hibernation if a zoned logical unit is present without
+ * attaching the mq-deadline scheduler first to the zoned logical unit may cause
+ * unaligned write errors for the zoned logical unit.
+ */
+int ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 {
 	const u32 cur_ahit = READ_ONCE(hba->ahit);
+	bool prev_state, new_state;
+	int ret;
 
 	if (!ufshcd_is_auto_hibern8_supported(hba) || cur_ahit == ahit)
-		return;
+		return 0;
 
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
@@ -4360,6 +4407,15 @@ void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
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
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(ufshcd_auto_hibern8_update);
 
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 040d66d99912..7ae071a6811c 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1363,7 +1363,7 @@ static inline int ufshcd_disable_host_tx_lcc(struct ufs_hba *hba)
 	return ufshcd_dme_set(hba, UIC_ARG_MIB(PA_LOCAL_TX_LCC_ENABLE), 0);
 }
 
-void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit);
+int ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit);
 void ufshcd_fixup_dev_quirks(struct ufs_hba *hba,
 			     const struct ufs_dev_quirk *fixups);
 #define SD_ASCII_STD true
