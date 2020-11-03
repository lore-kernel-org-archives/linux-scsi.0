Return-Path: <SRS0=0yur=EJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5BD8C55178
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 14:15:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E65F22243
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 14:15:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729420AbgKCOOu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Nov 2020 09:14:50 -0500
Received: from mga02.intel.com ([134.134.136.20]:29139 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729345AbgKCOOY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 3 Nov 2020 09:14:24 -0500
IronPort-SDR: 1JRLATAODLYWrr6JdX6NEHvlfzd4KTYKNNrb88ty6+L0g8KqcSRe40/P2ArT6VoZ7MEUXiN6Lj
 csOvbrpjkvgg==
X-IronPort-AV: E=McAfee;i="6000,8403,9793"; a="156045785"
X-IronPort-AV: E=Sophos;i="5.77,448,1596524400"; 
   d="scan'208";a="156045785"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2020 06:14:24 -0800
IronPort-SDR: MWk003GDfdTz884kOADsSp0AjGgt8Xs5/xFrA24iyafcih5SJK3AhNqwVFkUq6q0BKRMqBh9pT
 j7aHJG8enxSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,448,1596524400"; 
   d="scan'208";a="527170246"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.94])
  by fmsmga006.fm.intel.com with ESMTP; 03 Nov 2020 06:14:21 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH V4 2/2] scsi: ufs: Allow an error return value from ->device_reset()
Date:   Tue,  3 Nov 2020 16:14:03 +0200
Message-Id: <20201103141403.2142-3-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201103141403.2142-1-adrian.hunter@intel.com>
References: <20201103141403.2142-1-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It is simpler for drivers to provide a ->device_reset() callback
irrespective of whether the GPIO, or firmware interface necessary to do the
reset, is discovered during probe.

Change ->device_reset() to return an error code.  Drivers that provide
the callback, but do not do the reset operation should return -EOPNOTSUPP.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/scsi/ufs/ufs-mediatek.c |  4 +++-
 drivers/scsi/ufs/ufs-qcom.c     |  6 ++++--
 drivers/scsi/ufs/ufshcd.h       | 11 +++++++----
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index 8df73bc2f8cb..914a827a93ee 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -743,7 +743,7 @@ static int ufs_mtk_link_startup_notify(struct ufs_hba *hba,
 	return ret;
 }
 
-static void ufs_mtk_device_reset(struct ufs_hba *hba)
+static int ufs_mtk_device_reset(struct ufs_hba *hba)
 {
 	struct arm_smccc_res res;
 
@@ -764,6 +764,8 @@ static void ufs_mtk_device_reset(struct ufs_hba *hba)
 	usleep_range(10000, 15000);
 
 	dev_info(hba->dev, "device reset done\n");
+
+	return 0;
 }
 
 static int ufs_mtk_link_set_hpm(struct ufs_hba *hba)
diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 9a19c6d15d3b..357c3b49321d 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1422,13 +1422,13 @@ static void ufs_qcom_dump_dbg_regs(struct ufs_hba *hba)
  *
  * Toggles the (optional) reset line to reset the attached device.
  */
-static void ufs_qcom_device_reset(struct ufs_hba *hba)
+static int ufs_qcom_device_reset(struct ufs_hba *hba)
 {
 	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 
 	/* reset gpio is optional */
 	if (!host->device_reset)
-		return;
+		return -EOPNOTSUPP;
 
 	/*
 	 * The UFS device shall detect reset pulses of 1us, sleep for 10us to
@@ -1439,6 +1439,8 @@ static void ufs_qcom_device_reset(struct ufs_hba *hba)
 
 	gpiod_set_value_cansleep(host->device_reset, 0);
 	usleep_range(10, 15);
+
+	return 0;
 }
 
 #if IS_ENABLED(CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND)
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 213be0667b59..5191d87f6263 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -323,7 +323,7 @@ struct ufs_hba_variant_ops {
 	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
 	void	(*dbg_register_dump)(struct ufs_hba *hba);
 	int	(*phy_initialization)(struct ufs_hba *);
-	void	(*device_reset)(struct ufs_hba *hba);
+	int	(*device_reset)(struct ufs_hba *hba);
 	void	(*config_scaling_param)(struct ufs_hba *hba,
 					struct devfreq_dev_profile *profile,
 					void *data);
@@ -1207,9 +1207,12 @@ static inline void ufshcd_vops_dbg_register_dump(struct ufs_hba *hba)
 static inline void ufshcd_vops_device_reset(struct ufs_hba *hba)
 {
 	if (hba->vops && hba->vops->device_reset) {
-		hba->vops->device_reset(hba);
-		ufshcd_set_ufs_dev_active(hba);
-		ufshcd_update_reg_hist(&hba->ufs_stats.dev_reset, 0);
+		int err = hba->vops->device_reset(hba);
+
+		if (!err)
+			ufshcd_set_ufs_dev_active(hba);
+		if (err != -EOPNOTSUPP)
+			ufshcd_update_reg_hist(&hba->ufs_stats.dev_reset, err);
 	}
 }
 
-- 
2.17.1

