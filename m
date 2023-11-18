Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7DB4C2BB3F
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Nov 2023 12:45:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbjKRMpR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Nov 2023 07:45:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjKRMpQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Nov 2023 07:45:16 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA773A2
        for <linux-scsi@vger.kernel.org>; Sat, 18 Nov 2023 04:45:13 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 41be03b00d2f7-5c21e185df5so484010a12.1
        for <linux-scsi@vger.kernel.org>; Sat, 18 Nov 2023 04:45:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700311512; x=1700916312; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LrY/xWbZ4wDVA1RqRlXMTeM7jlISNFM7jazUkWj8LsI=;
        b=QXlOKMzV/09ZmNdArZiSQ3QU0+aiw8tJS8E4VH9nJq99unbimcai1bHp9VNdd8hI8Q
         WMptcNrpRFZ9+uSjj9XqhYMej5IYNb3/OXp9X0Bk5npOk2PGzyko5PI7jOtyQQok3G/l
         sAAmq7D8GY2OvhtchwmOvahO9BDyEbCFDpHOMBJnU3o5hZTpcEwkqRHWNnR2dzyhwnDI
         EWvJywdKunK5qkDH2HF11iIrxyxAd6Gi8nhdjJkltl6JyWwR5GXC2g1jwaIT5Ma6CLP8
         B1k0f4kS1GwrAV1ewqJVLLLJnJi37L1He5IkIAogaN5BfsbMS/yzWfI9C/pbcALl7/db
         Bc0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700311512; x=1700916312;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LrY/xWbZ4wDVA1RqRlXMTeM7jlISNFM7jazUkWj8LsI=;
        b=Aw9GTgkzsEAAvLQ7aY0QRhclkvZVaOvm36disyphqrxCaP7CUeAlYKGkFj4Guzh7NS
         zz/Dsq45TMi5fuHjVB0mdnfWgmN8HOf771RvfEMWL76mx2CJjjcGroiWTQXue2GO6ZTV
         qN96tjcOnIdFELoORdaA7CBYRZZCXiXtGjRxVdJj+4ojh13DzIX9jkg31E9txWLaQN1X
         VnsXred+5did18wNluNmDehcYEYqxriDVflFkNVjsc46W4BmbHYh3dQnOkZLDd0a9txO
         C6jOy2enfP8J49H2UhiIBXaCBbsWlWeGwJNG8ALnKy9jlk8PLA3ERasMJYSs/NqF/GSC
         WOJQ==
X-Gm-Message-State: AOJu0Ywv0Z586J43q4IWOz3iDe7YoQ4ODIAmjVDHTuuR0M2IneIwFiaF
        ywKAUbPTVXF8mckEuz/KYSQ1105G6DQ=
X-Google-Smtp-Source: AGHT+IHaJrQkdCGc6Cxp9KDBtTRWtuF9GBzxjvHrpAiCuyFmIGESd3qwgpqgockMeMhNs8BIvqkvZQ==
X-Received: by 2002:a05:6a20:1584:b0:188:290f:3da6 with SMTP id h4-20020a056a20158400b00188290f3da6mr2499893pzj.41.1700311511869;
        Sat, 18 Nov 2023 04:45:11 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:65f5:5dbb:9d18:499c])
        by smtp.gmail.com with ESMTPSA id o23-20020a634e57000000b005c215baacc1sm1665511pgl.70.2023.11.18.04.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Nov 2023 04:45:10 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     akinobu.mita@gmail.com, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Subject: [PATCH] scsi: ufs: core: make fault-injection dynamically configurable per HBA
Date:   Sat, 18 Nov 2023 21:44:43 +0900
Message-Id: <20231118124443.1007116-1-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The UFS driver has two driver-specific fault injection mechanisms.
(trigger_eh and timeout)
Each fault injection configuration can only be specified by a module
parameter and cannot be reconfigured without reloading the driver.
Also, each configuration is common to all HBAs.

This change adds the following subdirectories for each UFS HBA when
debugfs is enabled.

/sys/kernel/debug/ufshcd/<HBA>/timeout_inject
/sys/kernel/debug/ufshcd/<HBA>/trigger_eh_inject

Each fault injection attribute can be dynamically set per HBA by a
corresponding file in these directories.

This is tested with QEMU UFS devices.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/ufs/core/ufs-fault-injection.c | 19 +++++++++++++++----
 drivers/ufs/core/ufs-fault-injection.h | 13 +++++++++----
 drivers/ufs/core/ufshcd.c              |  5 +++--
 include/ufs/ufshcd.h                   |  5 +++++
 4 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/drivers/ufs/core/ufs-fault-injection.c b/drivers/ufs/core/ufs-fault-injection.c
index 5b1184aac585..169540417079 100644
--- a/drivers/ufs/core/ufs-fault-injection.c
+++ b/drivers/ufs/core/ufs-fault-injection.c
@@ -4,6 +4,7 @@
 #include <linux/types.h>
 #include <linux/fault-inject.h>
 #include <linux/module.h>
+#include <ufs/ufshcd.h>
 #include "ufs-fault-injection.h"
 
 static int ufs_fault_get(char *buffer, const struct kernel_param *kp);
@@ -59,12 +60,22 @@ static int ufs_fault_set(const char *val, const struct kernel_param *kp)
 	return 0;
 }
 
-bool ufs_trigger_eh(void)
+void ufs_fault_inject_hba_init(struct ufs_hba *hba)
 {
-	return should_fail(&ufs_trigger_eh_attr, 1);
+	hba->trigger_eh_attr = ufs_trigger_eh_attr;
+	hba->timeout_attr = ufs_timeout_attr;
+#ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
+	fault_create_debugfs_attr("trigger_eh_inject", hba->debugfs_root, &hba->trigger_eh_attr);
+	fault_create_debugfs_attr("timeout_inject", hba->debugfs_root, &hba->timeout_attr);
+#endif
 }
 
-bool ufs_fail_completion(void)
+bool ufs_trigger_eh(struct ufs_hba *hba)
 {
-	return should_fail(&ufs_timeout_attr, 1);
+	return should_fail(&hba->trigger_eh_attr, 1);
+}
+
+bool ufs_fail_completion(struct ufs_hba *hba)
+{
+	return should_fail(&hba->timeout_attr, 1);
 }
diff --git a/drivers/ufs/core/ufs-fault-injection.h b/drivers/ufs/core/ufs-fault-injection.h
index 6d0cd8e10c87..996a35769781 100644
--- a/drivers/ufs/core/ufs-fault-injection.h
+++ b/drivers/ufs/core/ufs-fault-injection.h
@@ -7,15 +7,20 @@
 #include <linux/types.h>
 
 #ifdef CONFIG_SCSI_UFS_FAULT_INJECTION
-bool ufs_trigger_eh(void);
-bool ufs_fail_completion(void);
+void ufs_fault_inject_hba_init(struct ufs_hba *hba);
+bool ufs_trigger_eh(struct ufs_hba *hba);
+bool ufs_fail_completion(struct ufs_hba *hba);
 #else
-static inline bool ufs_trigger_eh(void)
+static inline void ufs_fault_inject_hba_init(struct ufs_hba *hba)
+{
+}
+
+static inline bool ufs_trigger_eh(struct ufs_hba *hba)
 {
 	return false;
 }
 
-static inline bool ufs_fail_completion(void)
+static inline bool ufs_fail_completion(struct ufs_hba *hba)
 {
 	return false;
 }
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 8b1031fb0a44..63f0ee117399 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2992,7 +2992,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	ufshcd_send_command(hba, tag, hwq);
 
 out:
-	if (ufs_trigger_eh()) {
+	if (ufs_trigger_eh(hba)) {
 		unsigned long flags;
 
 		spin_lock_irqsave(hba->host->host_lock, flags);
@@ -5649,7 +5649,7 @@ static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
 	    !(hba->quirks & UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR))
 		ufshcd_reset_intr_aggr(hba);
 
-	if (ufs_fail_completion())
+	if (ufs_fail_completion(hba))
 		return IRQ_HANDLED;
 
 	/*
@@ -9348,6 +9348,7 @@ static int ufshcd_hba_init(struct ufs_hba *hba)
 		goto out_disable_vreg;
 
 	ufs_debugfs_hba_init(hba);
+	ufs_fault_inject_hba_init(hba);
 
 	hba->is_powered = true;
 	goto out;
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 7f0b2c5599cd..d862c8ddce03 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -16,6 +16,7 @@
 #include <linux/blk-crypto-profile.h>
 #include <linux/blk-mq.h>
 #include <linux/devfreq.h>
+#include <linux/fault-inject.h>
 #include <linux/msi.h>
 #include <linux/pm_runtime.h>
 #include <linux/dma-direction.h>
@@ -1057,6 +1058,10 @@ struct ufs_hba {
 	struct dentry *debugfs_root;
 	struct delayed_work debugfs_ee_work;
 	u32 debugfs_ee_rate_limit_ms;
+#endif
+#ifdef CONFIG_SCSI_UFS_FAULT_INJECTION
+	struct fault_attr trigger_eh_attr;
+	struct fault_attr timeout_attr;
 #endif
 	u32 luns_avail;
 	unsigned int nr_hw_queues;
-- 
2.34.1

