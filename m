Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFAC5C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Apr 2022 23:39:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbiD0Xmo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Apr 2022 19:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbiD0Xmm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Apr 2022 19:42:42 -0400
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F855F260
        for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2022 16:39:30 -0700 (PDT)
Received: by mail-pl1-f171.google.com with SMTP id b12so2882036plg.4
        for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2022 16:39:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k23SKwJTDpyjcozrr8MpWutx8/NJPzXL4cAkJY4C2AI=;
        b=adsyl8BNYOLjbLeBteGUWr2wmQxH/Efit9PRj2wqa0H13TNLPHiRQmipo9e6xiD1P5
         9ThRh2PggX889hMgTQrO4/CPc7CrhK4CUC6dtL+0XwmioT1pr36Z0G2Zrne2GOrkiEcl
         jtPs3Znceuadaak/r8IyUY7gfQgpZ24VR1x77s2yZcx4rkI8I31Vy+93tYMQPC6jkziF
         9RdJmMuhvhNckgxt6R4GZzlnbV1SkLmX4EhimA5gG+ElWtqA8quqZVnxJ6S31Il4zxhN
         WH5wKLRK7y94/mQxXx5DiqQurJgPiPtaeujO+/FXE0TqarE5EoWe5KyIYLZckIIkjF61
         2oJA==
X-Gm-Message-State: AOAM531dmDrSTpT3e42sQO0NuMmRaCo46R0xUdeWuwA84684Ez63eYDa
        CWzt8wDUiqPoFPKIH11QulTj/mHBcjgcJg==
X-Google-Smtp-Source: ABdhPJyr5mWEnbFmNXg18C62kQL7VEDsBEPZHUSl93jEKKPlFPJwJpzaorJkRvmO1Xlfn5UkaP4dGQ==
X-Received: by 2002:a17:902:db10:b0:15c:e4d6:4b10 with SMTP id m16-20020a170902db1000b0015ce4d64b10mr24934250plx.44.1651102769448;
        Wed, 27 Apr 2022 16:39:29 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6cbb:d78e:9b3:bb62])
        by smtp.gmail.com with ESMTPSA id f16-20020aa78b10000000b0050a81508653sm19817580pfd.198.2022.04.27.16.39.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 16:39:28 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 4/4] scsi: ufs: Add suspend/resume SCSI command processing support
Date:   Wed, 27 Apr 2022 16:38:55 -0700
Message-Id: <20220427233855.2685505-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
In-Reply-To: <20220427233855.2685505-1-bvanassche@acm.org>
References: <20220427233855.2685505-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This functionality is needed by UFS drivers to e.g. suspend SCSI command
processing while reprogramming encryption keys if the hardware does not
support concurrent I/O and key reprogramming.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 20 ++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.h |  3 +++
 2 files changed, 23 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 60ba11b68735..22447c4f16a2 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1692,6 +1692,26 @@ static void ufshcd_ungate_work(struct work_struct *work)
 	ufshcd_scsi_unblock_requests(hba);
 }
 
+/*
+ * Block processing of new SCSI commands and wait until pending SCSI
+ * commands and TMFs have finished. ufshcd_exec_dev_cmd() and
+ * ufshcd_issue_devman_upiu_cmd() are not affected by this function.
+ *
+ * Return: 0 upon success; -EBUSY upon timeout.
+ */
+int ufshcd_freeze_scsi_devs(struct ufs_hba *hba, u64 timeout_us)
+{
+	return ufshcd_clock_scaling_prepare(hba, timeout_us);
+}
+EXPORT_SYMBOL_GPL(ufshcd_freeze_scsi_devs);
+
+/* Resume processing of SCSI commands. */
+void ufshcd_unfreeze_scsi_devs(struct ufs_hba *hba)
+{
+	ufshcd_clock_scaling_unprepare(hba, true);
+}
+EXPORT_SYMBOL_GPL(ufshcd_unfreeze_scsi_devs);
+
 /**
  * ufshcd_hold - Enable clocks that were gated earlier due to ufshcd_release.
  * Also, exit from hibern8 mode and set the link as active.
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 2b0f3441b813..8954fcbdaf6f 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1181,6 +1181,9 @@ void ufshcd_release(struct ufs_hba *hba);
 
 void ufshcd_clkgate_delay_set(struct device *dev, unsigned long value);
 
+int ufshcd_freeze_scsi_devs(struct ufs_hba *hba, u64 timeout_us);
+void ufshcd_unfreeze_scsi_devs(struct ufs_hba *hba);
+
 void ufshcd_map_desc_id_to_length(struct ufs_hba *hba, enum desc_idn desc_id,
 				  int *desc_length);
 
