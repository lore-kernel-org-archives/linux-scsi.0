Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B35DDC432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Aug 2021 14:52:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89049604D7
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Aug 2021 14:52:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238552AbhHaOxp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Aug 2021 10:53:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:11967 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237512AbhHaOxo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 31 Aug 2021 10:53:44 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10093"; a="218499073"
X-IronPort-AV: E=Sophos;i="5.84,366,1620716400"; 
   d="scan'208";a="218499073"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2021 07:52:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,366,1620716400"; 
   d="scan'208";a="519714568"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.174])
  by fmsmga004.fm.intel.com with ESMTP; 31 Aug 2021 07:52:46 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: ufs-pci: Fix Intel LKF link stability
Date:   Tue, 31 Aug 2021 17:53:17 +0300
Message-Id: <20210831145317.26306-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.17.1
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Intel LKF can experience link errors. Make fixes to increase link
stability, especially when switching to high speed modes.

Fixes: b2c57925df1ffc ("scsi: ufs: ufs-pci: Add support for Intel LKF")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/scsi/ufs/ufshcd-pci.c | 78 +++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c     |  3 +-
 drivers/scsi/ufs/ufshcd.h     |  1 +
 3 files changed, 81 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index b3bcc5c882da..149c1aa09103 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -128,6 +128,81 @@ static int ufs_intel_link_startup_notify(struct ufs_hba *hba,
 	return err;
 }
 
+static int ufs_intel_set_lanes(struct ufs_hba *hba, u32 lanes)
+{
+	struct ufs_pa_layer_attr pwr_info = hba->pwr_info;
+	int ret;
+
+	pwr_info.lane_rx = lanes;
+	pwr_info.lane_tx = lanes;
+	ret = ufshcd_config_pwr_mode(hba, &pwr_info);
+	if (ret)
+		dev_err(hba->dev, "%s: Setting %u lanes, err = %d\n",
+			__func__, lanes, ret);
+	return ret;
+}
+
+static int ufs_intel_lkf_pwr_change_notify(struct ufs_hba *hba,
+				enum ufs_notify_change_status status,
+				struct ufs_pa_layer_attr *dev_max_params,
+				struct ufs_pa_layer_attr *dev_req_params)
+{
+	int err = 0;
+
+	switch (status) {
+	case PRE_CHANGE:
+		if (ufshcd_is_hs_mode(dev_max_params) &&
+		    (hba->pwr_info.lane_rx != 2 || hba->pwr_info.lane_tx != 2))
+			ufs_intel_set_lanes(hba, 2);
+		memcpy(dev_req_params, dev_max_params, sizeof(*dev_req_params));
+		break;
+	case POST_CHANGE:
+		if (ufshcd_is_hs_mode(dev_req_params)) {
+			u32 peer_granularity;
+
+			usleep_range(1000, 1250);
+			err = ufshcd_dme_peer_get(hba, UIC_ARG_MIB(PA_GRANULARITY),
+						  &peer_granularity);
+		}
+		break;
+	default:
+		break;
+	}
+
+	return err;
+}
+
+static int ufs_intel_lkf_apply_dev_quirks(struct ufs_hba *hba)
+{
+	u32 granularity, peer_granularity;
+	u32 pa_tactivate, peer_pa_tactivate;
+	int ret;
+
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_GRANULARITY), &granularity);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_peer_get(hba, UIC_ARG_MIB(PA_GRANULARITY), &peer_granularity);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_TACTIVATE), &pa_tactivate);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_peer_get(hba, UIC_ARG_MIB(PA_TACTIVATE), &peer_pa_tactivate);
+	if (ret)
+		goto out;
+
+	if (granularity == peer_granularity) {
+		u32 new_peer_pa_tactivate = pa_tactivate + 2;
+
+		ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(PA_TACTIVATE), new_peer_pa_tactivate);
+	}
+out:
+	return ret;
+}
+
 #define INTEL_ACTIVELTR		0x804
 #define INTEL_IDLELTR		0x808
 
@@ -351,6 +426,7 @@ static int ufs_intel_lkf_init(struct ufs_hba *hba)
 	struct ufs_host *ufs_host;
 	int err;
 
+	hba->nop_out_timeout = 200;
 	hba->quirks |= UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8;
 	hba->caps |= UFSHCD_CAP_CRYPTO;
 	err = ufs_intel_common_init(hba);
@@ -381,6 +457,8 @@ static struct ufs_hba_variant_ops ufs_intel_lkf_hba_vops = {
 	.exit			= ufs_intel_common_exit,
 	.hce_enable_notify	= ufs_intel_hce_enable_notify,
 	.link_startup_notify	= ufs_intel_link_startup_notify,
+	.pwr_change_notify	= ufs_intel_lkf_pwr_change_notify,
+	.apply_dev_quirks	= ufs_intel_lkf_apply_dev_quirks,
 	.resume			= ufs_intel_resume,
 	.device_reset		= ufs_intel_device_reset,
 };
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3841ab49f556..67889d74761c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4776,7 +4776,7 @@ static int ufshcd_verify_dev_init(struct ufs_hba *hba)
 	mutex_lock(&hba->dev_cmd.lock);
 	for (retries = NOP_OUT_RETRIES; retries > 0; retries--) {
 		err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_NOP,
-					       NOP_OUT_TIMEOUT);
+					  hba->nop_out_timeout);
 
 		if (!err || err == -ETIMEDOUT)
 			break;
@@ -9483,6 +9483,7 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 	hba->host = host;
 	hba->dev = dev;
 	hba->dev_ref_clk_freq = REF_CLK_FREQ_INVAL;
+	hba->nop_out_timeout = NOP_OUT_TIMEOUT;
 	INIT_LIST_HEAD(&hba->clk_list_head);
 	spin_lock_init(&hba->outstanding_lock);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 52ea6f350b18..4723f27a55d1 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -858,6 +858,7 @@ struct ufs_hba {
 	/* Device management request data */
 	struct ufs_dev_cmd dev_cmd;
 	ktime_t last_dme_cmd_tstamp;
+	int nop_out_timeout;
 
 	/* Keeps information of the UFS device connected to this host */
 	struct ufs_dev_info dev_info;
-- 
2.17.1

