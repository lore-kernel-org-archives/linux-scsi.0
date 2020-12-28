Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BE44C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Dec 2020 11:09:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20E5A229C4
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Dec 2020 11:09:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727284AbgL1LJf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Dec 2020 06:09:35 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:8022 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727085AbgL1LJf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Dec 2020 06:09:35 -0500
IronPort-SDR: wOGjy2wbqBZSpu0bYUBb/D6QxTBumtWCfKVDoaL5WQR89N4N7enX6rGwt09sFAFv3bOuicXLfj
 7BV3RUqQtzW4fSXjsexF+Z1bH7Uc9wQsgdzSdDVoYM7EgBVu1Vens2KGG7c9AEhX/ipzQgVWju
 0LqE4x+bIMuV+JeqCf+MnDm1iobnES9mhGHG8lYRCTHgXd4vkGaYEjMlIBNtaBAxEjNnbp9975
 F4lFv+BGxkor2UH1IqK3an9kW5N4izt85FhNK/cgr8nAlw1y0IeWAjbZDDTueSCOwq6wWjwtHX
 z8Y=
X-IronPort-AV: E=Sophos;i="5.78,455,1599548400"; 
   d="scan'208";a="29452326"
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
  by labrats.qualcomm.com with ESMTP; 28 Dec 2020 03:09:08 -0800
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg05-sd.qualcomm.com with ESMTP; 28 Dec 2020 03:08:36 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 5B87A2188E; Mon, 28 Dec 2020 03:08:35 -0800 (PST)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v7 2/3] scsi: ufs: Refactor ufshcd_init/exit_clk_scaling/gating()
Date:   Mon, 28 Dec 2020 03:08:17 -0800
Message-Id: <1609153700-25703-3-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1609153700-25703-1-git-send-email-cang@codeaurora.org>
References: <1609153700-25703-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ufshcd_hba_exit() is always called after ufshcd_exit_clk_scaling() and
ufshcd_exit_clk_gating(), so move ufshcd_exit_clk_scaling/gating() to
ufshcd_hba_exit(). Meanwhile, add dedicated funcs to init and remove
sysfs nodes of clock scaling/gating to make the code more readable.
Overall functionality remains same.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 128 +++++++++++++++++++++++++---------------------
 drivers/scsi/ufs/ufshcd.h |   4 ++
 2 files changed, 75 insertions(+), 57 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 972e119..e84c65f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1540,7 +1540,7 @@ static ssize_t ufshcd_clkscale_enable_store(struct device *dev,
 	return count;
 }
 
-static void ufshcd_clkscaling_init_sysfs(struct ufs_hba *hba)
+static void ufshcd_init_clk_scaling_sysfs(struct ufs_hba *hba)
 {
 	hba->clk_scaling.enable_attr.show = ufshcd_clkscale_enable_show;
 	hba->clk_scaling.enable_attr.store = ufshcd_clkscale_enable_store;
@@ -1551,6 +1551,42 @@ static void ufshcd_clkscaling_init_sysfs(struct ufs_hba *hba)
 		dev_err(hba->dev, "Failed to create sysfs for clkscale_enable\n");
 }
 
+static void ufshcd_remove_clk_scaling_sysfs(struct ufs_hba *hba)
+{
+	if (hba->clk_scaling.enable_attr.attr.name)
+		device_remove_file(hba->dev, &hba->clk_scaling.enable_attr);
+}
+
+static void ufshcd_init_clk_scaling(struct ufs_hba *hba)
+{
+	char wq_name[sizeof("ufs_clkscaling_00")];
+
+	if (!ufshcd_is_clkscaling_supported(hba))
+		return;
+
+	INIT_WORK(&hba->clk_scaling.suspend_work,
+		  ufshcd_clk_scaling_suspend_work);
+	INIT_WORK(&hba->clk_scaling.resume_work,
+		  ufshcd_clk_scaling_resume_work);
+
+	snprintf(wq_name, sizeof(wq_name), "ufs_clkscaling_%d",
+		 hba->host->host_no);
+	hba->clk_scaling.workq = create_singlethread_workqueue(wq_name);
+
+	hba->clk_scaling.is_initialized = true;
+}
+
+static void ufshcd_exit_clk_scaling(struct ufs_hba *hba)
+{
+	if (!hba->clk_scaling.is_initialized)
+		return;
+
+	ufshcd_remove_clk_scaling_sysfs(hba);
+	destroy_workqueue(hba->clk_scaling.workq);
+	ufshcd_devfreq_remove(hba);
+	hba->clk_scaling.is_initialized = false;
+}
+
 static void ufshcd_ungate_work(struct work_struct *work)
 {
 	int ret;
@@ -1842,32 +1878,31 @@ static ssize_t ufshcd_clkgate_enable_store(struct device *dev,
 	return count;
 }
 
-static void ufshcd_init_clk_scaling(struct ufs_hba *hba)
+static void ufshcd_init_clk_gating_sysfs(struct ufs_hba *hba)
 {
-	char wq_name[sizeof("ufs_clkscaling_00")];
-
-	if (!ufshcd_is_clkscaling_supported(hba))
-		return;
-
-	INIT_WORK(&hba->clk_scaling.suspend_work,
-		  ufshcd_clk_scaling_suspend_work);
-	INIT_WORK(&hba->clk_scaling.resume_work,
-		  ufshcd_clk_scaling_resume_work);
+	hba->clk_gating.delay_attr.show = ufshcd_clkgate_delay_show;
+	hba->clk_gating.delay_attr.store = ufshcd_clkgate_delay_store;
+	sysfs_attr_init(&hba->clk_gating.delay_attr.attr);
+	hba->clk_gating.delay_attr.attr.name = "clkgate_delay_ms";
+	hba->clk_gating.delay_attr.attr.mode = 0644;
+	if (device_create_file(hba->dev, &hba->clk_gating.delay_attr))
+		dev_err(hba->dev, "Failed to create sysfs for clkgate_delay\n");
 
-	snprintf(wq_name, sizeof(wq_name), "ufs_clkscaling_%d",
-		 hba->host->host_no);
-	hba->clk_scaling.workq = create_singlethread_workqueue(wq_name);
+	hba->clk_gating.enable_attr.show = ufshcd_clkgate_enable_show;
+	hba->clk_gating.enable_attr.store = ufshcd_clkgate_enable_store;
+	sysfs_attr_init(&hba->clk_gating.enable_attr.attr);
+	hba->clk_gating.enable_attr.attr.name = "clkgate_enable";
+	hba->clk_gating.enable_attr.attr.mode = 0644;
+	if (device_create_file(hba->dev, &hba->clk_gating.enable_attr))
+		dev_err(hba->dev, "Failed to create sysfs for clkgate_enable\n");
 }
 
-static void ufshcd_exit_clk_scaling(struct ufs_hba *hba)
+static void ufshcd_remove_clk_gating_sysfs(struct ufs_hba *hba)
 {
-	if (!ufshcd_is_clkscaling_supported(hba))
-		return;
-
-	if (hba->clk_scaling.enable_attr.attr.name)
-		device_remove_file(hba->dev, &hba->clk_scaling.enable_attr);
-	destroy_workqueue(hba->clk_scaling.workq);
-	ufshcd_devfreq_remove(hba);
+	if (hba->clk_gating.delay_attr.attr.name)
+		device_remove_file(hba->dev, &hba->clk_gating.delay_attr);
+	if (hba->clk_gating.enable_attr.attr.name)
+		device_remove_file(hba->dev, &hba->clk_gating.enable_attr);
 }
 
 static void ufshcd_init_clk_gating(struct ufs_hba *hba)
@@ -1888,34 +1923,22 @@ static void ufshcd_init_clk_gating(struct ufs_hba *hba)
 	hba->clk_gating.clk_gating_workq = alloc_ordered_workqueue(wq_name,
 							   WQ_MEM_RECLAIM);
 
-	hba->clk_gating.is_enabled = true;
+	ufshcd_init_clk_gating_sysfs(hba);
 
-	hba->clk_gating.delay_attr.show = ufshcd_clkgate_delay_show;
-	hba->clk_gating.delay_attr.store = ufshcd_clkgate_delay_store;
-	sysfs_attr_init(&hba->clk_gating.delay_attr.attr);
-	hba->clk_gating.delay_attr.attr.name = "clkgate_delay_ms";
-	hba->clk_gating.delay_attr.attr.mode = 0644;
-	if (device_create_file(hba->dev, &hba->clk_gating.delay_attr))
-		dev_err(hba->dev, "Failed to create sysfs for clkgate_delay\n");
-
-	hba->clk_gating.enable_attr.show = ufshcd_clkgate_enable_show;
-	hba->clk_gating.enable_attr.store = ufshcd_clkgate_enable_store;
-	sysfs_attr_init(&hba->clk_gating.enable_attr.attr);
-	hba->clk_gating.enable_attr.attr.name = "clkgate_enable";
-	hba->clk_gating.enable_attr.attr.mode = 0644;
-	if (device_create_file(hba->dev, &hba->clk_gating.enable_attr))
-		dev_err(hba->dev, "Failed to create sysfs for clkgate_enable\n");
+	hba->clk_gating.is_enabled = true;
+	hba->clk_gating.is_initialized = true;
 }
 
 static void ufshcd_exit_clk_gating(struct ufs_hba *hba)
 {
-	if (!ufshcd_is_clkgating_allowed(hba))
+	if (!hba->clk_gating.is_initialized)
 		return;
-	device_remove_file(hba->dev, &hba->clk_gating.delay_attr);
-	device_remove_file(hba->dev, &hba->clk_gating.enable_attr);
+
+	ufshcd_remove_clk_gating_sysfs(hba);
 	cancel_work_sync(&hba->clk_gating.ungate_work);
 	cancel_delayed_work_sync(&hba->clk_gating.gate_work);
 	destroy_workqueue(hba->clk_gating.clk_gating_workq);
+	hba->clk_gating.is_initialized = false;
 }
 
 /* Must be called with host lock acquired */
@@ -7646,7 +7669,7 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
 				goto out;
 
 			hba->clk_scaling.is_enabled = true;
-			ufshcd_clkscaling_init_sysfs(hba);
+			ufshcd_init_clk_scaling_sysfs(hba);
 		}
 	}
 
@@ -7775,7 +7798,6 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 	 */
 	if (ret) {
 		pm_runtime_put_sync(hba->dev);
-		ufshcd_exit_clk_scaling(hba);
 		ufshcd_hba_exit(hba);
 	}
 }
@@ -8212,12 +8234,12 @@ static int ufshcd_hba_init(struct ufs_hba *hba)
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
@@ -8964,13 +8986,9 @@ void ufshcd_remove(struct ufs_hba *hba)
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
@@ -9169,7 +9187,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	err = devm_request_irq(dev, irq, ufshcd_intr, IRQF_SHARED, UFSHCD, hba);
 	if (err) {
 		dev_err(hba->dev, "request irq failed\n");
-		goto exit_gating;
+		goto out_disable;
 	} else {
 		hba->is_irq_enabled = true;
 	}
@@ -9177,7 +9195,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	err = scsi_add_host(host, hba->dev);
 	if (err) {
 		dev_err(hba->dev, "scsi_add_host failed\n");
-		goto exit_gating;
+		goto out_disable;
 	}
 
 	hba->cmd_queue = blk_mq_init_queue(&hba->host->tag_set);
@@ -9260,10 +9278,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
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

