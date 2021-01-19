Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F629C433E6
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 23:01:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE4A123104
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 23:01:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbhASXBT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jan 2021 18:01:19 -0500
Received: from mga17.intel.com ([192.55.52.151]:24148 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403813AbhASOTK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Jan 2021 09:19:10 -0500
IronPort-SDR: 3qypdZBcLs6p3tigMX9TUQ42v6QXr4lwVomxy1uX/hWxiAylQGMJNXlMbAHmtiPvoUNvCADd12
 SLgydeVT8SIw==
X-IronPort-AV: E=McAfee;i="6000,8403,9868"; a="158704858"
X-IronPort-AV: E=Sophos;i="5.79,359,1602572400"; 
   d="scan'208";a="158704858"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2021 06:15:52 -0800
IronPort-SDR: EbQfvLRc2P53yHNIZ4Q7GcFGyhrWNL0YRQYnLaZigZa1Rj5vx4TOYGSAlD6MXvu92VOPrFo8mC
 5SJgqBZu2yRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,359,1602572400"; 
   d="scan'208";a="347189967"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.149])
  by fmsmga007.fm.intel.com with ESMTP; 19 Jan 2021 06:15:50 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH 4/4] scsi: ufs-debugfs: Add user-defined exception event rate limiting
Date:   Tue, 19 Jan 2021 16:15:42 +0200
Message-Id: <20210119141542.3808-5-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210119141542.3808-1-adrian.hunter@intel.com>
References: <20210119141542.3808-1-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An enabled user-specified exception event that does not clear quickly will
repeatedly cause the handler to run. That could unduly disturb the driver
behaviour being tested or debugged. To prevent that add debugfs file
exception_event_rate_limit_ms. When a exception event happens, it is
disabled, and then after a period of time (default 20ms) the exception
event is enabled again.

Note that if the driver also has that exception event enabled, it will not
be disabled.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/scsi/ufs/ufs-debugfs.c | 44 ++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-debugfs.h |  2 ++
 drivers/scsi/ufs/ufshcd.c      |  5 ++--
 drivers/scsi/ufs/ufshcd.h      |  4 ++++
 4 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-debugfs.c b/drivers/scsi/ufs/ufs-debugfs.c
index 59729073b569..ced9ef4d7c78 100644
--- a/drivers/scsi/ufs/ufs-debugfs.c
+++ b/drivers/scsi/ufs/ufs-debugfs.c
@@ -88,15 +88,59 @@ static int ee_usr_mask_set(void *data, u64 val)
 
 DEFINE_DEBUGFS_ATTRIBUTE(ee_usr_mask_fops, ee_usr_mask_get, ee_usr_mask_set, "%#llx\n");
 
+void ufs_debugfs_exception_event(struct ufs_hba *hba, u16 status)
+{
+	bool chgd = false;
+	u16 ee_ctrl_mask;
+	int err = 0;
+
+	if (!hba->debugfs_ee_rate_limit_ms || !status)
+		return;
+
+	mutex_lock(&hba->ee_ctrl_mutex);
+	ee_ctrl_mask = hba->ee_drv_mask | (hba->ee_usr_mask & ~status);
+	chgd = ee_ctrl_mask != hba->ee_ctrl_mask;
+	if (chgd) {
+		err = __ufshcd_write_ee_control(hba, ee_ctrl_mask);
+		if (err)
+			dev_err(hba->dev, "%s: failed to write ee control %d\n",
+				__func__, err);
+	}
+	mutex_unlock(&hba->ee_ctrl_mutex);
+
+	if (chgd && !err) {
+		unsigned long delay = msecs_to_jiffies(hba->debugfs_ee_rate_limit_ms);
+
+		queue_delayed_work(system_freezable_wq, &hba->debugfs_ee_work, delay);
+	}
+}
+
+static void ufs_debugfs_restart_ee(struct work_struct *work)
+{
+	struct ufs_hba *hba = container_of(work, struct ufs_hba, debugfs_ee_work.work);
+
+	if (!hba->ee_usr_mask || pm_runtime_suspended(hba->dev) ||
+	    ufs_debugfs_get_user_access(hba))
+		return;
+	ufshcd_write_ee_control(hba);
+	ufs_debugfs_put_user_access(hba);
+}
+
 void ufs_debugfs_hba_init(struct ufs_hba *hba)
 {
+	/* Set default exception event rate limit period to 20ms */
+	hba->debugfs_ee_rate_limit_ms = 20;
+	INIT_DELAYED_WORK(&hba->debugfs_ee_work, ufs_debugfs_restart_ee);
 	hba->debugfs_root = debugfs_create_dir(dev_name(hba->dev), ufs_debugfs_root);
 	debugfs_create_file("stats", 0400, hba->debugfs_root, hba, &ufs_debugfs_stats_fops);
 	debugfs_create_file("exception_event_mask", 0600, hba->debugfs_root,
 			    hba, &ee_usr_mask_fops);
+	debugfs_create_u32("exception_event_rate_limit_ms", 0600, hba->debugfs_root,
+			   &hba->debugfs_ee_rate_limit_ms);
 }
 
 void ufs_debugfs_hba_exit(struct ufs_hba *hba)
 {
 	debugfs_remove_recursive(hba->debugfs_root);
+	cancel_delayed_work_sync(&hba->debugfs_ee_work);
 }
diff --git a/drivers/scsi/ufs/ufs-debugfs.h b/drivers/scsi/ufs/ufs-debugfs.h
index f35b39c4b4f5..3ca29d30460a 100644
--- a/drivers/scsi/ufs/ufs-debugfs.h
+++ b/drivers/scsi/ufs/ufs-debugfs.h
@@ -12,11 +12,13 @@ void __init ufs_debugfs_init(void);
 void __exit ufs_debugfs_exit(void);
 void ufs_debugfs_hba_init(struct ufs_hba *hba);
 void ufs_debugfs_hba_exit(struct ufs_hba *hba);
+void ufs_debugfs_exception_event(struct ufs_hba *hba, u16 status);
 #else
 static inline void ufs_debugfs_init(void) {}
 static inline void ufs_debugfs_exit(void) {}
 static inline void ufs_debugfs_hba_init(struct ufs_hba *hba) {}
 static inline void ufs_debugfs_hba_exit(struct ufs_hba *hba) {}
+static inline void ufs_debugfs_exception_event(struct ufs_hba *hba, u16 status) {}
 #endif
 
 #endif
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d68f5ecc9b13..f0959b9609fd 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5147,14 +5147,14 @@ static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
 	}
 }
 
-static int __ufshcd_write_ee_control(struct ufs_hba *hba, u32 ee_ctrl_mask)
+int __ufshcd_write_ee_control(struct ufs_hba *hba, u32 ee_ctrl_mask)
 {
 	return ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
 				       QUERY_ATTR_IDN_EE_CONTROL, 0, 0,
 				       &ee_ctrl_mask);
 }
 
-static int ufshcd_write_ee_control(struct ufs_hba *hba)
+int ufshcd_write_ee_control(struct ufs_hba *hba)
 {
 	int err;
 
@@ -5643,6 +5643,7 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
 	if (status & hba->ee_drv_mask & MASK_EE_URGENT_BKOPS)
 		ufshcd_bkops_exception_event_handler(hba);
 
+	ufs_debugfs_exception_event(hba, status);
 out:
 	ufshcd_scsi_unblock_requests(hba);
 	/*
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index ff9601f8d9e6..49eed4cf009c 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -833,6 +833,8 @@ struct ufs_hba {
 #endif
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *debugfs_root;
+	struct delayed_work debugfs_ee_work;
+	u32 debugfs_ee_rate_limit_ms;
 #endif
 };
 
@@ -1276,6 +1278,8 @@ static inline u8 ufshcd_scsi_to_upiu_lun(unsigned int scsi_lun)
 int ufshcd_dump_regs(struct ufs_hba *hba, size_t offset, size_t len,
 		     const char *prefix);
 
+int __ufshcd_write_ee_control(struct ufs_hba *hba, u32 ee_ctrl_mask);
+int ufshcd_write_ee_control(struct ufs_hba *hba);
 int ufshcd_update_ee_control(struct ufs_hba *hba, u16 *mask, u16 *other_mask,
 			     u16 set, u16 clr);
 
-- 
2.17.1

