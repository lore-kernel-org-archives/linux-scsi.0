Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AC07C2BBCF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 07:11:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 138F523A63
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 07:11:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732768AbgLRHKr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Dec 2020 02:10:47 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:12527 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbgLRHKq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2020 02:10:46 -0500
IronPort-SDR: o1dzN/J3CnVslQ+97D1Ar8E9JUDeF8c9OUfc5s90Y+yhkb/c5TtauXY5BxUoaq61PhFJ8uPakU
 Z13wDQ2qi1Q39TFlnwXU1Ud1/qjwGYPvV7mm04q9+LeU3Y/PR4m5Tbs7pGK+3KFXBOnZgL4UQG
 UoldU8ash20av7DsJIgJtVu1q8w8OZtr4aBQkJmBo13v3V9/XmhO2SfW5bBB+0ZSa+xXMPs3nl
 UZvFBoZNDbCu8N+esdJBfbEYE97AMa0aihixWg9xUeX2g76hZJc+E/ZFPONt2G9vm0FILlhyZj
 3T4=
X-IronPort-AV: E=Sophos;i="5.78,429,1599548400"; 
   d="scan'208";a="29385186"
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by labrats.qualcomm.com with ESMTP; 17 Dec 2020 23:10:05 -0800
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg03-sd.qualcomm.com with ESMTP; 17 Dec 2020 23:10:04 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 32769211C2; Thu, 17 Dec 2020 23:10:04 -0800 (PST)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support)
Subject: [PATCH v5 2/3] scsi: ufs: Clean up ufshcd_exit_clk_scaling/gating()
Date:   Thu, 17 Dec 2020 23:09:44 -0800
Message-Id: <1608275387-26183-3-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1608275387-26183-1-git-send-email-cang@codeaurora.org>
References: <1608275387-26183-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ufshcd_hba_exit() is always called after ufshcd_exit_clk_scaling() and
ufshcd_exit_clk_gating(), so move ufshcd_exit_clk_scaling/gating() to
ufshcd_hba_exit().

Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 32 +++++++++++++++-----------------
 drivers/scsi/ufs/ufshcd.h |  4 ++++
 2 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 4ccdd2b..80f82cb 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1857,11 +1857,14 @@ static void ufshcd_init_clk_scaling(struct ufs_hba *hba)
 	snprintf(wq_name, sizeof(wq_name), "ufs_clkscaling_%d",
 		 hba->host->host_no);
 	hba->clk_scaling.workq = create_singlethread_workqueue(wq_name);
+
+	hba->clk_scaling.is_initialized = true;
 }
 
 static void ufshcd_exit_clk_scaling(struct ufs_hba *hba)
 {
-	if (!ufshcd_is_clkscaling_supported(hba))
+	if (!ufshcd_is_clkscaling_supported(hba) ||
+	    !hba->clk_scaling.is_initialized)
 		return;
 
 	if (hba->devfreq)
@@ -1905,12 +1908,16 @@ static void ufshcd_init_clk_gating(struct ufs_hba *hba)
 	hba->clk_gating.enable_attr.attr.mode = 0644;
 	if (device_create_file(hba->dev, &hba->clk_gating.enable_attr))
 		dev_err(hba->dev, "Failed to create sysfs for clkgate_enable\n");
+
+	hba->clk_gating.is_initialized = true;
 }
 
 static void ufshcd_exit_clk_gating(struct ufs_hba *hba)
 {
-	if (!ufshcd_is_clkgating_allowed(hba))
+	if (!ufshcd_is_clkgating_allowed(hba) ||
+	    !hba->clk_gating.is_initialized)
 		return;
+
 	device_remove_file(hba->dev, &hba->clk_gating.delay_attr);
 	device_remove_file(hba->dev, &hba->clk_gating.enable_attr);
 	cancel_work_sync(&hba->clk_gating.ungate_work);
@@ -7775,7 +7782,6 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 	 */
 	if (ret) {
 		pm_runtime_put_sync(hba->dev);
-		ufshcd_exit_clk_scaling(hba);
 		ufshcd_hba_exit(hba);
 	}
 }
@@ -8212,12 +8218,12 @@ static int ufshcd_hba_init(struct ufs_hba *hba)
 static void ufshcd_hba_exit(struct ufs_hba *hba)
 {
 	if (hba->is_powered) {
+		ufshcd_exit_clk_scaling(hba);
+		ufshcd_exit_clk_gating(hba);
+		if (hba->eh_wq)
+			destroy_workqueue(hba->eh_wq);
 		ufshcd_variant_hba_exit(hba);
 		ufshcd_setup_vreg(hba, false);
-		ufshcd_suspend_clkscaling(hba);
-		if (ufshcd_is_clkscaling_supported(hba))
-			if (hba->devfreq)
-				ufshcd_suspend_clkscaling(hba);
 		ufshcd_setup_clocks(hba, false);
 		ufshcd_setup_hba_vreg(hba, false);
 		hba->is_powered = false;
@@ -8966,13 +8972,9 @@ void ufshcd_remove(struct ufs_hba *hba)
 	blk_mq_free_tag_set(&hba->tmf_tag_set);
 	blk_cleanup_queue(hba->cmd_queue);
 	scsi_remove_host(hba->host);
-	destroy_workqueue(hba->eh_wq);
 	/* disable interrupts */
 	ufshcd_disable_intr(hba, hba->intr_mask);
 	ufshcd_hba_stop(hba);
-
-	ufshcd_exit_clk_scaling(hba);
-	ufshcd_exit_clk_gating(hba);
 	ufshcd_hba_exit(hba);
 }
 EXPORT_SYMBOL_GPL(ufshcd_remove);
@@ -9171,7 +9173,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	err = devm_request_irq(dev, irq, ufshcd_intr, IRQF_SHARED, UFSHCD, hba);
 	if (err) {
 		dev_err(hba->dev, "request irq failed\n");
-		goto exit_gating;
+		goto out_disable;
 	} else {
 		hba->is_irq_enabled = true;
 	}
@@ -9179,7 +9181,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	err = scsi_add_host(host, hba->dev);
 	if (err) {
 		dev_err(hba->dev, "scsi_add_host failed\n");
-		goto exit_gating;
+		goto out_disable;
 	}
 
 	hba->cmd_queue = blk_mq_init_queue(&hba->host->tag_set);
@@ -9262,10 +9264,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	blk_cleanup_queue(hba->cmd_queue);
 out_remove_scsi_host:
 	scsi_remove_host(hba->host);
-exit_gating:
-	ufshcd_exit_clk_scaling(hba);
-	ufshcd_exit_clk_gating(hba);
-	destroy_workqueue(hba->eh_wq);
 out_disable:
 	hba->is_irq_enabled = false;
 	ufshcd_hba_exit(hba);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 5737679..cb9075d 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -347,6 +347,7 @@ enum clk_gating_state {
  * @delay_attr: sysfs attribute to control delay_attr
  * @enable_attr: sysfs attribute to enable/disable clock gating
  * @is_enabled: Indicates the current status of clock gating
+ * @is_initialized: Indicates whether clock gating is initialized or not
  * @active_reqs: number of requests that are pending and should be waited for
  * completion before gating clocks.
  */
@@ -359,6 +360,7 @@ struct ufs_clk_gating {
 	struct device_attribute delay_attr;
 	struct device_attribute enable_attr;
 	bool is_enabled;
+	bool is_initialized;
 	int active_reqs;
 	struct workqueue_struct *clk_gating_workq;
 };
@@ -386,6 +388,7 @@ struct ufs_saved_pwr_info {
 		clkscale_enable sysfs node
  * @is_allowed: tracks if scaling is currently allowed or not, used to block
 		clock scaling which is not invoked from devfreq governor
+ * @is_initialized: Indicates whether clock scaling is initialized or not
  * @is_busy_started: tracks if busy period has started or not
  * @is_suspended: tracks if devfreq is suspended or not
  */
@@ -401,6 +404,7 @@ struct ufs_clk_scaling {
 	struct work_struct resume_work;
 	bool is_enabled;
 	bool is_allowed;
+	bool is_initialized;
 	bool is_busy_started;
 	bool is_suspended;
 };
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

