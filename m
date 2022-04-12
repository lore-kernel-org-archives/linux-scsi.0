Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF99EC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 18:22:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358680AbiDLSZK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 14:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231859AbiDLSZH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 14:25:07 -0400
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F8F6007E
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:22:49 -0700 (PDT)
Received: by mail-pj1-f42.google.com with SMTP id nt14-20020a17090b248e00b001ca601046a4so3851561pjb.0
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:22:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tGEXHmMu3kvnw3VvaDiJOZqYOiflKEv4GwCAstRS5Bo=;
        b=2fYA1In3O2J3VpRxgPtV3Ol1Q2X7NZXc/FVgdzfrWee1A2AaPufSnasM15/Qha7bZT
         kYsa2jNbhBOvLD1e6rbhdUOD4dy0yZRPny/gxE57ED9e8Zf54aPf8Za6rJNXKbdIQxEe
         8K2cPxEo7glR2EEKtCwdpTYeXO1J3c1Q3xuqTnMzo5qfzFgVHbizZA/EIOjzcRDW1hRk
         5OHHuMZzi/61rcz4L/MXX9LMz/FmJamTAp2glSIGx1RjJRokvo3iog1ncoxWZDjqGhsp
         nyDW2KMGv+B6rIsRZH904f9DwDbe4AO97nBFqyXW1/iAv2SrP/gXCNRoh0WKDgYVuj5M
         fHEA==
X-Gm-Message-State: AOAM531neIxvQDTpNxgGcoREFNJWfEJYZ2gGre0mMWmT9RWfItEhJHTC
        Z2jCs7ApAnA9alufR/QgH7r/FGfUN+MecA==
X-Google-Smtp-Source: ABdhPJzcoSJtJGzsq1Jp14cmTmQ5WZftjwgUTZ3wWhlwtPsnujI9rh/viRxa8N2nYuHtC342stxLBw==
X-Received: by 2002:a17:902:cec1:b0:158:85e5:4c6b with SMTP id d1-20020a170902cec100b0015885e54c6bmr5098714plg.12.1649787768527;
        Tue, 12 Apr 2022 11:22:48 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:d4b2:56ee:d001:c159])
        by smtp.gmail.com with ESMTPSA id d18-20020a056a0010d200b004fa2e13ce80sm40367037pfu.76.2022.04.12.11.22.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 11:22:47 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>
Subject: [PATCH v2 21/29] scsi: ufs: Introduce ufshcd_clkgate_delay_set()
Date:   Tue, 12 Apr 2022 11:18:45 -0700
Message-Id: <20220412181853.3715080-22-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220412181853.3715080-1-bvanassche@acm.org>
References: <20220412181853.3715080-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since the code to modify delay_ms while holding the host lock occurs
twice, introduce a function that performs this action.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufs-mediatek.c |  5 +----
 drivers/scsi/ufs/ufshcd.c       | 18 +++++++++++++-----
 drivers/scsi/ufs/ufshcd.h       |  2 ++
 3 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index 2b26acc74efb..d19b35495302 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -857,7 +857,6 @@ static int ufs_mtk_pre_link(struct ufs_hba *hba)
 
 static void ufs_mtk_setup_clk_gating(struct ufs_hba *hba)
 {
-	unsigned long flags;
 	u32 ah_ms;
 
 	if (ufshcd_is_clkgating_allowed(hba)) {
@@ -866,9 +865,7 @@ static void ufs_mtk_setup_clk_gating(struct ufs_hba *hba)
 					  hba->ahit);
 		else
 			ah_ms = 10;
-		spin_lock_irqsave(hba->host->host_lock, flags);
-		hba->clk_gating.delay_ms = ah_ms + 5;
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		ufshcd_clkgate_delay_set(hba->dev, ah_ms + 5);
 	}
 }
 
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d1c3f6291538..cb74a9eeee70 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1864,18 +1864,26 @@ static ssize_t ufshcd_clkgate_delay_show(struct device *dev,
 	return sysfs_emit(buf, "%lu\n", hba->clk_gating.delay_ms);
 }
 
+void ufshcd_clkgate_delay_set(struct device *dev, unsigned long value)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	unsigned long flags;
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	hba->clk_gating.delay_ms = value;
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+}
+EXPORT_SYMBOL_GPL(ufshcd_clkgate_delay_set);
+
 static ssize_t ufshcd_clkgate_delay_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
-	struct ufs_hba *hba = dev_get_drvdata(dev);
-	unsigned long flags, value;
+	unsigned long value;
 
 	if (kstrtoul(buf, 0, &value))
 		return -EINVAL;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	hba->clk_gating.delay_ms = value;
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	ufshcd_clkgate_delay_set(dev, value);
 	return count;
 }
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 14414225faa1..3eb5d2c17e39 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1186,6 +1186,8 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
 int ufshcd_hold(struct ufs_hba *hba, bool async);
 void ufshcd_release(struct ufs_hba *hba);
 
+void ufshcd_clkgate_delay_set(struct device *dev, unsigned long value);
+
 void ufshcd_map_desc_id_to_length(struct ufs_hba *hba, enum desc_idn desc_id,
 				  int *desc_length);
 
