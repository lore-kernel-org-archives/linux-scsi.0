Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86817C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 09:38:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FD2C6126A
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 09:38:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234321AbhIVJkQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 05:40:16 -0400
Received: from mga07.intel.com ([134.134.136.100]:35905 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234376AbhIVJjm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Sep 2021 05:39:42 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="287225672"
X-IronPort-AV: E=Sophos;i="5.85,313,1624345200"; 
   d="scan'208";a="287225672"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2021 02:38:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,313,1624345200"; 
   d="scan'208";a="474496273"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.84])
  by fmsmga007.fm.intel.com with ESMTP; 22 Sep 2021 02:38:09 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Wei Li <liwei213@huawei.com>, linux-scsi@vger.kernel.org
Subject: [PATCH V5 2/3] scsi: ufs: Fix runtime PM dependencies getting broken
Date:   Wed, 22 Sep 2021 12:38:41 +0300
Message-Id: <20210922093842.18025-3-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210922093842.18025-1-adrian.hunter@intel.com>
References: <20210922093842.18025-1-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UFS SCSI devices make use of device links to establish PM dependencies.
However, SCSI PM will force devices' runtime PM state to be active during
system resume. That can break runtime PM dependencies for UFS devices.
Fix by adding a flag 'preserve_rpm' to let UFS SCSI devices opt-out of
the unwanted behaviour.

Fixes: b294ff3e34490f ("scsi: ufs: core: Enable power management for wlun")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/scsi/scsi_pm.c     | 16 +++++++++++-----
 drivers/scsi/ufs/ufshcd.c  |  1 +
 include/scsi/scsi_device.h |  1 +
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index 3717eea37ecb..0557c1ad304d 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -73,13 +73,22 @@ static int scsi_dev_type_resume(struct device *dev,
 		int (*cb)(struct device *, const struct dev_pm_ops *))
 {
 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	struct scsi_device *sdev = NULL;
+	bool preserve_rpm = false;
 	int err = 0;
 
+	if (scsi_is_sdev_device(dev)) {
+		sdev = to_scsi_device(dev);
+		preserve_rpm = sdev->preserve_rpm;
+		if (preserve_rpm && pm_runtime_suspended(dev))
+			return 0;
+	}
+
 	err = cb(dev, pm);
 	scsi_device_resume(to_scsi_device(dev));
 	dev_dbg(dev, "scsi resume: %d\n", err);
 
-	if (err == 0) {
+	if (err == 0 && !preserve_rpm) {
 		pm_runtime_disable(dev);
 		err = pm_runtime_set_active(dev);
 		pm_runtime_enable(dev);
@@ -91,11 +100,8 @@ static int scsi_dev_type_resume(struct device *dev,
 		 *
 		 * The resume hook will correct runtime PM status of the disk.
 		 */
-		if (!err && scsi_is_sdev_device(dev)) {
-			struct scsi_device *sdev = to_scsi_device(dev);
-
+		if (!err && sdev)
 			blk_set_runtime_active(sdev->request_queue);
-		}
 	}
 
 	return err;
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d725390aea99..39fc6070d2f7 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5025,6 +5025,7 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 		pm_runtime_get_noresume(&sdev->sdev_gendev);
 	else if (ufshcd_is_rpm_autosuspend_allowed(hba))
 		sdev->rpm_autosuspend = 1;
+	sdev->preserve_rpm = 1;
 
 	ufshcd_crypto_setup_rq_keyslot_manager(hba, q);
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index b97e142a7ca9..24884600d2d4 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -196,6 +196,7 @@ struct scsi_device {
 	unsigned no_read_disc_info:1;	/* Avoid READ_DISC_INFO cmds */
 	unsigned no_read_capacity_16:1; /* Avoid READ_CAPACITY_16 cmds */
 	unsigned try_rc_10_first:1;	/* Try READ_CAPACACITY_10 first */
+	unsigned preserve_rpm:1;	/* Preserve runtime PM */
 	unsigned security_supported:1;	/* Supports Security Protocols */
 	unsigned is_visible:1;	/* is the device visible in sysfs */
 	unsigned wce_default_on:1;	/* Cache is ON by default */
-- 
2.17.1

