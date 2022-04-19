Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A08EC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 22:59:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358399AbiDSXB7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Apr 2022 19:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358396AbiDSXBo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2022 19:01:44 -0400
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47195387A7
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:59:01 -0700 (PDT)
Received: by mail-pj1-f44.google.com with SMTP id d23-20020a17090a115700b001d2bde6c234so2298103pje.1
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:59:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tGEXHmMu3kvnw3VvaDiJOZqYOiflKEv4GwCAstRS5Bo=;
        b=UzyrI1/7Mq77sZ101vXHhclyV0Iv6EP2CJGAViQQF2hBX/Z9rh8rYf3fP4CQ5nmRK8
         u7R2RcnfH6j+gjXxlk0FrYQ4EVY53s36hKQmr+KJ0nflxrt64TBh3yKIS8p05C7Ty5UE
         WmQKbVZFnxLg5LhtmGZQNbkId/NLo/FI68/TdFuAaESY6KreaRqMJqcgNXiLkZTjY8KP
         q+gsI7QnQhKnKs92Ho9saBchMowAcN6BujpKcK09SqdFH6vCGSje0Ga7brqZAafIAKVW
         LDFn/LkAEtVUF66ZeTW9V6CRMviQesOaZOXy984kZRzWEnWU4mI5MTo1n7L91Ik/zjUH
         9yQg==
X-Gm-Message-State: AOAM532mO/ubPBv7LeA7Cnpqwf+krZV0NuHvg/d0PQf8aAPq6TAY/PhS
        eOW7LdVVQne9+wvaoVFATGY=
X-Google-Smtp-Source: ABdhPJw1lUUALhhfZHRcTg2lFQ9nwtbTzd3283Md51fQZijUIksy84sVwoxwUUivxzg1XdwBdO0uUg==
X-Received: by 2002:a17:90b:3715:b0:1cd:5529:4d72 with SMTP id mg21-20020a17090b371500b001cd55294d72mr955854pjb.201.1650409140696;
        Tue, 19 Apr 2022 15:59:00 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:59ec:2e90:f751:1806])
        by smtp.gmail.com with ESMTPSA id c15-20020a63350f000000b003992202f95fsm17622557pga.38.2022.04.19.15.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 15:58:59 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3 21/28] scsi: ufs: Introduce ufshcd_clkgate_delay_set()
Date:   Tue, 19 Apr 2022 15:58:04 -0700
Message-Id: <20220419225811.4127248-22-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220419225811.4127248-1-bvanassche@acm.org>
References: <20220419225811.4127248-1-bvanassche@acm.org>
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
 
