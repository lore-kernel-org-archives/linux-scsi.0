Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E69A5C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 22:38:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242603AbiCaWjy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 18:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242600AbiCaWjw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 18:39:52 -0400
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3BF01B988D
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:38:04 -0700 (PDT)
Received: by mail-pj1-f42.google.com with SMTP id gb19so779391pjb.1
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:38:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x8OfFh5M7DMY0tvVTEXJ2GKyKFw46mVaZFAxthlC1Ps=;
        b=cBcn49+6LiCsyc/LK3DCwOyQHYGquQhg8O/iyUijAUWvgisrDlRUpa+2bXwgVdlZMi
         +eQNGflz7tIFVBgz6TCwtcgFufwrgVudbPM+WeXd5RLAumjZmup2Nt40Bg3tQw9yTcQx
         jtn9fPUEXNcVR1WiouefFYBfFdpaDsXZ9GsG3O9AzPHxAZnl9ZsQK7axpEk+RPi4ZBrd
         vXg/q9eEpnHAlouPqlRFhPnDHenDh/jZJfIMYqlbQX51NcvS6Kcpy6Hd5ksbLwPvw87c
         I75fv9yc93Un1v2kUL1GBo30h6cUMqwR079yJ12kiJwTEUHf9fw5ZBldZMNcaBsCX2dD
         +/TQ==
X-Gm-Message-State: AOAM532h8VpAUu0sDR8IUkmpwoJGIPhmic3jweXcW3eXy8cy8eK6Ay92
        kI2go7GswncxoPL1+YeuED8=
X-Google-Smtp-Source: ABdhPJwA8nQPnrDPShepzXL8pihciz9iB6Qiz6wgBwFPN/hMas3jwX0jsGYkOLESCrKLCMLCP1WHWw==
X-Received: by 2002:a17:902:da92:b0:154:10dc:26f8 with SMTP id j18-20020a170902da9200b0015410dc26f8mr7460592plx.133.1648766284327;
        Thu, 31 Mar 2022 15:38:04 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6375:fa54:efe8:6c8f])
        by smtp.gmail.com with ESMTPSA id p3-20020a056a000b4300b004faee36ea56sm483481pfo.155.2022.03.31.15.38.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 15:38:03 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH 21/29] scsi: ufs: Introduce ufshcd_clkgate_delay_set()
Date:   Thu, 31 Mar 2022 15:34:16 -0700
Message-Id: <20220331223424.1054715-22-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
In-Reply-To: <20220331223424.1054715-1-bvanassche@acm.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since the code to modify delay_ms while holding the host lock occurs
twice, introduce a function that performs this action.

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
index d6af4d82dfed..7d04cf8d75ef 100644
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
 
