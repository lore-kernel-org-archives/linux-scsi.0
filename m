Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E711BC433DB
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Jan 2021 05:46:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2662221FE
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Jan 2021 05:46:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbhAAFpw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Jan 2021 00:45:52 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:28895 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726322AbhAAFpw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jan 2021 00:45:52 -0500
IronPort-SDR: U72dxaQyZauZ6WS6iqUsoT9/7QlY0cnyCVX//Vis7jaOj5bflnguIsQbI1jC9E7BQO8ySlmfGi
 bAnuYJf3au3nCdMr2gQ+GUZUjgj1UofhmRQkhZaKqYDx4OihXLwvy3+6OoCdog37sfysoRTjrq
 pS64Rz9RhxQCYk5ziVNMZADOZbcGfydJM4Twxi7el/6DXLWUCYpD565TJmpONxXpCd804fYFfQ
 slH3VoPKET3sOFBtwhRm/KLh4fcFx4bChz4kghgkdMGnHTm6BXxtxY3vdHYbkn22W8qHbFaIky
 NK8=
X-IronPort-AV: E=Sophos;i="5.78,466,1599548400"; 
   d="scan'208";a="29470880"
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by labrats.qualcomm.com with ESMTP; 31 Dec 2020 21:45:08 -0800
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg03-sd.qualcomm.com with ESMTP; 31 Dec 2020 21:45:08 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 2CBA3212C1; Thu, 31 Dec 2020 21:45:08 -0800 (PST)
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
        Adrian Hunter <adrian.hunter@intel.com>,
        Nitin Rawat <nitirawa@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 2/2] scsi: ufs: Protect PM ops and err_handler from user access through sysfs
Date:   Thu, 31 Dec 2020 21:44:53 -0800
Message-Id: <1609479893-8889-3-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1609479893-8889-1-git-send-email-cang@codeaurora.org>
References: <1609479893-8889-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

User layer may access sysfs nodes when system PM ops or error handling
is running, which can cause various problems. Rename eh_sem to host_sem
and use it to protect PM ops and error handling from user layer intervene.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufs-sysfs.c | 104 ++++++++++++++++++++++++++++++++++++-------
 drivers/scsi/ufs/ufshcd.c    |  40 ++++++++++-------
 drivers/scsi/ufs/ufshcd.h    |  10 ++++-
 3 files changed, 123 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 08e72b7..98a9447 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -154,18 +154,29 @@ static ssize_t auto_hibern8_show(struct device *dev,
 				 struct device_attribute *attr, char *buf)
 {
 	u32 ahit;
+	int ret;
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 
 	if (!ufshcd_is_auto_hibern8_supported(hba))
 		return -EOPNOTSUPP;
 
+	down(&hba->host_sem);
+	if (!ufshcd_is_sysfs_allowed(hba)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	pm_runtime_get_sync(hba->dev);
 	ufshcd_hold(hba, false);
 	ahit = ufshcd_readl(hba, REG_AUTO_HIBERNATE_IDLE_TIMER);
 	ufshcd_release(hba);
 	pm_runtime_put_sync(hba->dev);
 
-	return scnprintf(buf, PAGE_SIZE, "%d\n", ufshcd_ahit_to_us(ahit));
+	ret = scnprintf(buf, PAGE_SIZE, "%d\n", ufshcd_ahit_to_us(ahit));
+
+out:
+	up(&hba->host_sem);
+	return ret;
 }
 
 static ssize_t auto_hibern8_store(struct device *dev,
@@ -174,6 +185,7 @@ static ssize_t auto_hibern8_store(struct device *dev,
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 	unsigned int timer;
+	int ret = 0;
 
 	if (!ufshcd_is_auto_hibern8_supported(hba))
 		return -EOPNOTSUPP;
@@ -184,9 +196,17 @@ static ssize_t auto_hibern8_store(struct device *dev,
 	if (timer > UFSHCI_AHIBERN8_MAX)
 		return -EINVAL;
 
+	down(&hba->host_sem);
+	if (!ufshcd_is_sysfs_allowed(hba)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	ufshcd_auto_hibern8_update(hba, ufshcd_us_to_ahit(timer));
 
-	return count;
+out:
+	up(&hba->host_sem);
+	return ret ? ret : count;
 }
 
 static DEVICE_ATTR_RW(rpm_lvl);
@@ -225,12 +245,21 @@ static ssize_t ufs_sysfs_read_desc_param(struct ufs_hba *hba,
 	if (param_size > 8)
 		return -EINVAL;
 
+	down(&hba->host_sem);
+	if (!ufshcd_is_sysfs_allowed(hba)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	pm_runtime_get_sync(hba->dev);
 	ret = ufshcd_read_desc_param(hba, desc_id, desc_index,
 				param_offset, desc_buf, param_size);
 	pm_runtime_put_sync(hba->dev);
-	if (ret)
-		return -EINVAL;
+	if (ret) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	switch (param_size) {
 	case 1:
 		ret = sprintf(sysfs_buf, "0x%02X\n", *desc_buf);
@@ -249,6 +278,8 @@ static ssize_t ufs_sysfs_read_desc_param(struct ufs_hba *hba,
 		break;
 	}
 
+out:
+	up(&hba->host_sem);
 	return ret;
 }
 
@@ -591,9 +622,16 @@ static ssize_t _name##_show(struct device *dev,				\
 	int desc_len = QUERY_DESC_MAX_SIZE;				\
 	u8 *desc_buf;							\
 									\
+	down(&hba->host_sem);						\
+	if (!ufshcd_is_sysfs_allowed(hba)) {				\
+		up(&hba->host_sem);					\
+		return -EBUSY;						\
+	}								\
 	desc_buf = kzalloc(QUERY_DESC_MAX_SIZE, GFP_ATOMIC);		\
-	if (!desc_buf)                                                  \
-		return -ENOMEM;                                         \
+	if (!desc_buf) {						\
+		up(&hba->host_sem);					\
+		return -ENOMEM;						\
+	}								\
 	pm_runtime_get_sync(hba->dev);					\
 	ret = ufshcd_query_descriptor_retry(hba,			\
 		UPIU_QUERY_OPCODE_READ_DESC, QUERY_DESC_IDN_DEVICE,	\
@@ -613,6 +651,7 @@ static ssize_t _name##_show(struct device *dev,				\
 out:									\
 	pm_runtime_put_sync(hba->dev);					\
 	kfree(desc_buf);						\
+	up(&hba->host_sem);						\
 	return ret;							\
 }									\
 static DEVICE_ATTR_RO(_name)
@@ -651,15 +690,26 @@ static ssize_t _name##_show(struct device *dev,				\
 	u8 index = 0;							\
 	int ret;							\
 	struct ufs_hba *hba = dev_get_drvdata(dev);			\
+									\
+	down(&hba->host_sem);						\
+	if (!ufshcd_is_sysfs_allowed(hba)) {				\
+		up(&hba->host_sem);					\
+		return -EBUSY;						\
+	}								\
 	if (ufshcd_is_wb_flags(QUERY_FLAG_IDN##_uname))			\
 		index = ufshcd_wb_get_query_index(hba);			\
 	pm_runtime_get_sync(hba->dev);					\
 	ret = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_READ_FLAG,	\
 		QUERY_FLAG_IDN##_uname, index, &flag);			\
 	pm_runtime_put_sync(hba->dev);					\
-	if (ret)							\
-		return -EINVAL;						\
-	return sprintf(buf, "%s\n", flag ? "true" : "false"); \
+	if (ret) {							\
+		ret = -EINVAL;						\
+		goto out;						\
+	}								\
+	ret = sprintf(buf, "%s\n", flag ? "true" : "false");		\
+out:									\
+	up(&hba->host_sem);						\
+	return ret;							\
 }									\
 static DEVICE_ATTR_RO(_name)
 
@@ -709,15 +759,26 @@ static ssize_t _name##_show(struct device *dev,				\
 	u32 value;							\
 	int ret;							\
 	u8 index = 0;							\
+									\
+	down(&hba->host_sem);						\
+	if (!ufshcd_is_sysfs_allowed(hba)) {				\
+		up(&hba->host_sem);					\
+		return -EBUSY;						\
+	}								\
 	if (ufshcd_is_wb_attrs(QUERY_ATTR_IDN##_uname))			\
 		index = ufshcd_wb_get_query_index(hba);			\
 	pm_runtime_get_sync(hba->dev);					\
 	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,	\
 		QUERY_ATTR_IDN##_uname, index, 0, &value);		\
 	pm_runtime_put_sync(hba->dev);					\
-	if (ret)							\
-		return -EINVAL;						\
-	return sprintf(buf, "0x%08X\n", value);				\
+	if (ret) {							\
+		ret = -EINVAL;						\
+		goto out;						\
+	}								\
+	ret = sprintf(buf, "0x%08X\n", value);				\
+out:									\
+	up(&hba->host_sem);						\
+	return ret;							\
 }									\
 static DEVICE_ATTR_RO(_name)
 
@@ -850,13 +911,26 @@ static ssize_t dyn_cap_needed_attribute_show(struct device *dev,
 	u8 lun = ufshcd_scsi_to_upiu_lun(sdev->lun);
 	int ret;
 
+	down(&hba->host_sem);
+	if (!ufshcd_is_sysfs_allowed(hba)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	pm_runtime_get_sync(hba->dev);
 	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
 		QUERY_ATTR_IDN_DYN_CAP_NEEDED, lun, 0, &value);
 	pm_runtime_put_sync(hba->dev);
-	if (ret)
-		return -EINVAL;
-	return sprintf(buf, "0x%08X\n", value);
+	if (ret) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = sprintf(buf, "0x%08X\n", value);
+
+out:
+	up(&hba->host_sem);
+	return ret;
 }
 static DEVICE_ATTR_RO(dyn_cap_needed_attribute);
 
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 34e2541..6c3006a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1522,11 +1522,17 @@ static ssize_t ufshcd_clkscale_enable_store(struct device *dev,
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 	u32 value;
-	int err;
+	int err = 0;
 
 	if (kstrtou32(buf, 0, &value))
 		return -EINVAL;
 
+	down(&hba->host_sem);
+	if (!ufshcd_is_sysfs_allowed(hba)) {
+		err = -EBUSY;
+		goto out;
+	}
+
 	value = !!value;
 	if (value == hba->clk_scaling.is_allowed)
 		goto out;
@@ -1552,7 +1558,8 @@ static ssize_t ufshcd_clkscale_enable_store(struct device *dev,
 	ufshcd_release(hba);
 	pm_runtime_put_sync(hba->dev);
 out:
-	return count;
+	up(&hba->host_sem);
+	return err ? err : count;
 }
 
 static void ufshcd_clkscaling_init_sysfs(struct ufs_hba *hba)
@@ -5720,9 +5727,10 @@ static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
 
 static inline bool ufshcd_err_handling_should_stop(struct ufs_hba *hba)
 {
-	return (!hba->is_powered || hba->ufshcd_state == UFSHCD_STATE_ERROR ||
+	return (!hba->is_powered || hba->shutting_down ||
+		hba->ufshcd_state == UFSHCD_STATE_ERROR ||
 		(!(hba->saved_err || hba->saved_uic_err || hba->force_reset ||
-			ufshcd_is_link_broken(hba))));
+		   ufshcd_is_link_broken(hba))));
 }
 
 #ifdef CONFIG_PM
@@ -5792,13 +5800,13 @@ static void ufshcd_err_handler(struct work_struct *work)
 
 	hba = container_of(work, struct ufs_hba, eh_work);
 
-	down(&hba->eh_sem);
+	down(&hba->host_sem);
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	if (ufshcd_err_handling_should_stop(hba)) {
 		if (hba->ufshcd_state != UFSHCD_STATE_ERROR)
 			hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
-		up(&hba->eh_sem);
+		up(&hba->host_sem);
 		return;
 	}
 	ufshcd_set_eh_in_progress(hba);
@@ -5967,7 +5975,7 @@ static void ufshcd_err_handler(struct work_struct *work)
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	ufshcd_scsi_unblock_requests(hba);
 	ufshcd_err_handling_unprepare(hba);
-	up(&hba->eh_sem);
+	up(&hba->host_sem);
 }
 
 /**
@@ -7869,10 +7877,10 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 	struct ufs_hba *hba = (struct ufs_hba *)data;
 	int ret;
 
-	down(&hba->eh_sem);
+	down(&hba->host_sem);
 	/* Initialize hba, detect and initialize UFS device */
 	ret = ufshcd_probe_hba(hba, true);
-	up(&hba->eh_sem);
+	up(&hba->host_sem);
 	if (ret)
 		goto out;
 
@@ -8899,7 +8907,7 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
 	if (!hba)
 		return 0;
 
-	down(&hba->eh_sem);
+	down(&hba->host_sem);
 	if (!hba->is_powered)
 		return 0;
 
@@ -8931,7 +8939,7 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
 	if (!ret)
 		hba->is_sys_suspended = true;
 	else
-		up(&hba->eh_sem);
+		up(&hba->host_sem);
 	return ret;
 }
 EXPORT_SYMBOL(ufshcd_system_suspend);
@@ -8965,7 +8973,7 @@ int ufshcd_system_resume(struct ufs_hba *hba)
 		hba->curr_dev_pwr_mode, hba->uic_link_state);
 	if (!ret)
 		hba->is_sys_suspended = false;
-	up(&hba->eh_sem);
+	up(&hba->host_sem);
 	return ret;
 }
 EXPORT_SYMBOL(ufshcd_system_resume);
@@ -9057,7 +9065,10 @@ int ufshcd_shutdown(struct ufs_hba *hba)
 {
 	int ret = 0;
 
-	down(&hba->eh_sem);
+	down(&hba->host_sem);
+	hba->shutting_down = true;
+	up(&hba->host_sem);
+
 	if (!hba->is_powered)
 		goto out;
 
@@ -9075,7 +9086,6 @@ int ufshcd_shutdown(struct ufs_hba *hba)
 	if (ret)
 		dev_err(hba->dev, "%s failed, err %d\n", __func__, ret);
 	hba->is_powered = false;
-	up(&hba->eh_sem);
 	/* allow force shutdown even in case of errors */
 	return 0;
 }
@@ -9270,7 +9280,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	INIT_WORK(&hba->eh_work, ufshcd_err_handler);
 	INIT_WORK(&hba->eeh_work, ufshcd_exception_event_handler);
 
-	sema_init(&hba->eh_sem, 1);
+	sema_init(&hba->host_sem, 1);
 
 	/* Initialize UIC command mutex */
 	mutex_init(&hba->uic_cmd_mutex);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 9bb5f0e..3e91951 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -655,6 +655,8 @@ struct ufs_hba_variant_params {
  * @intr_mask: Interrupt Mask Bits
  * @ee_ctrl_mask: Exception event control mask
  * @is_powered: flag to check if HBA is powered
+ * @shutting_down: flag to check if shutdown has been invoked
+ * @host_sem: semaphore used to serialize concurrent contexts
  * @eh_wq: Workqueue that eh_work works on
  * @eh_work: Worker to handle UFS errors that require s/w attention
  * @eeh_work: Worker to handle exception events
@@ -751,7 +753,8 @@ struct ufs_hba {
 	u32 intr_mask;
 	u16 ee_ctrl_mask;
 	bool is_powered;
-	struct semaphore eh_sem;
+	bool shutting_down;
+	struct semaphore host_sem;
 
 	/* Work Queues */
 	struct workqueue_struct *eh_wq;
@@ -875,6 +878,11 @@ static inline bool ufshcd_is_wb_allowed(struct ufs_hba *hba)
 	return hba->caps & UFSHCD_CAP_WB_EN;
 }
 
+static inline bool ufshcd_is_sysfs_allowed(struct ufs_hba *hba)
+{
+	return !hba->shutting_down;
+}
+
 #define ufshcd_writel(hba, val, reg)	\
 	writel((val), (hba)->mmio_base + (reg))
 #define ufshcd_readl(hba, reg)	\
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

