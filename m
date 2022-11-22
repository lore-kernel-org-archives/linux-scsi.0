Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61E11C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Nov 2022 22:27:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234320AbiKVW1P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Nov 2022 17:27:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234264AbiKVW1O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Nov 2022 17:27:14 -0500
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F73879E2B
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2022 14:27:14 -0800 (PST)
Received: by mail-pj1-f46.google.com with SMTP id t17so13716347pjo.3
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2022 14:27:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C0LhfTi/S7dYsdQK1Ey0lYG6TJ57E7plztRQPKjBZ08=;
        b=qTAKJ82DMHQHDzWIyp+u5nV2jp8ubyTnIM7Ev7+xu0Aa1nithktQVgwoahIiLlar5L
         zLxukr2UKCI52eb/bq9eCYE0Bx224IWMUiVNmotAtcwGDiVt3I7ijJSO8H6J0K/EMLJI
         /+/1zJsffVN8lsU82SuSxg3BKcPkS/u5kHe5jo/Eu+WXfGWvc0OqFevyU+2aXi/Y625L
         LUpvsyEzrK7ffaMKm1l+BWe8ba4QB4XbxKdH/w+1zGKPzw7Md2sFrHDXU7oH/wbaZZcg
         mGCVAYznhEeQazMN9LGoiJ+qaX6kC+E4ICihLuJ6LtAMItuxg6+om9QwbmqfHFai/6KJ
         3Viw==
X-Gm-Message-State: ANoB5pm/ttC2cwYoFPQiwcOawoShL3yYjdaX3v1+GKsTqU42anL1Rz8N
        uLNPtmRsb1TLv1Lj5GNhHyg=
X-Google-Smtp-Source: AA0mqf6Z1d75wA2FQ4+prEJ+YTk7/7ZHhT5QZDRV8Wzvqhpy55JCKv0sVEUAyPn69qI3eZvNw5eHKw==
X-Received: by 2002:a17:902:f813:b0:17f:8011:dd03 with SMTP id ix19-20020a170902f81300b0017f8011dd03mr6003707plb.59.1669156033356;
        Tue, 22 Nov 2022 14:27:13 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:3c88:9479:e09c:9acb])
        by smtp.gmail.com with ESMTPSA id cp5-20020a170902e78500b00172973d3cd9sm12539551plb.55.2022.11.22.14.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 14:27:12 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v4 4/5] scsi: ufs: Add suspend/resume SCSI command processing support
Date:   Tue, 22 Nov 2022 14:26:16 -0800
Message-Id: <20221122222617.3449081-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
In-Reply-To: <20221122222617.3449081-1-bvanassche@acm.org>
References: <20221122222617.3449081-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This functionality is needed by UFS drivers to e.g. suspend SCSI command
processing while reprogramming encryption keys if the hardware does not
support concurrent I/O and key reprogramming. This patch prepares for
adding support in the upstream kernel for the Pixel 6 and 7 UFS
controllers.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 20 ++++++++++++++++++++
 include/ufs/ufshcd.h      |  3 +++
 2 files changed, 23 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 7b2948592c4a..fa1c84731b8e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1707,6 +1707,26 @@ static void ufshcd_ungate_work(struct work_struct *work)
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
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 5cf81dff60aa..bd45818bf0e8 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1186,6 +1186,9 @@ void ufshcd_release(struct ufs_hba *hba);
 
 void ufshcd_clkgate_delay_set(struct device *dev, unsigned long value);
 
+int ufshcd_freeze_scsi_devs(struct ufs_hba *hba, u64 timeout_us);
+void ufshcd_unfreeze_scsi_devs(struct ufs_hba *hba);
+
 void ufshcd_map_desc_id_to_length(struct ufs_hba *hba, enum desc_idn desc_id,
 				  int *desc_length);
 
