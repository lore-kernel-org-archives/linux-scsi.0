Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A115C47094
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 04:45:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 533C9613B0
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 04:45:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhFJErD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 00:47:03 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:17149 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbhFJErC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jun 2021 00:47:02 -0400
IronPort-SDR: 9ZxkIA9BUeH8WF1atT1heVdvVZvMcfhcklU25BRDOH6cg0alSaGr58o4Sk30JLBrtL8xolty2R
 CrLga3xU5bruQ2ZxasIenK4pO6tIBSqi4F7860XpAEJgzXxPISPkMK6WeoF50+AoG1w9tz6Jip
 B5lsrelE5cPC3fyzLcTBYveS9uIGFOxp+vP1DjCrOkDE7mJOtTAxFln4YaQcZ9iIaONdEYgXib
 chdZ4VHKwC9GUHXUZOn+jKOLh3oZeWaHbCuF8G+4IwOc2kjfVy28lRjt51NeXFe7aKmOoLNmnP
 a9s=
X-IronPort-AV: E=Sophos;i="5.83,262,1616482800"; 
   d="scan'208";a="29778433"
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by labrats.qualcomm.com with ESMTP; 09 Jun 2021 21:45:07 -0700
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg02-sd.qualcomm.com with ESMTP; 09 Jun 2021 21:45:06 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 3DB5E21AF7; Wed,  9 Jun 2021 21:45:06 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart van Assche <bvanassche@acm.org>,
        Dinghao Liu <dinghao.liu@zju.edu.cn>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 9/9] scsi: ufs: Apply more limitations to user access
Date:   Wed,  9 Jun 2021 21:43:37 -0700
Message-Id: <1623300218-9454-10-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1623300218-9454-1-git-send-email-cang@codeaurora.org>
References: <1623300218-9454-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Do not let user access HW if hba resume fails or hba is not in good state,
otherwise it may lead to various stability issues.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufs-debugfs.c |  27 ++---------
 drivers/scsi/ufs/ufs-sysfs.c   | 105 ++++++++++++++---------------------------
 drivers/scsi/ufs/ufs_bsg.c     |  16 +++----
 drivers/scsi/ufs/ufshcd.c      |  63 +++++++++++++++----------
 drivers/scsi/ufs/ufshcd.h      |  17 ++++++-
 5 files changed, 101 insertions(+), 127 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-debugfs.c b/drivers/scsi/ufs/ufs-debugfs.c
index 4e1ff20..42c1c8b 100644
--- a/drivers/scsi/ufs/ufs-debugfs.c
+++ b/drivers/scsi/ufs/ufs-debugfs.c
@@ -52,25 +52,6 @@ static int ee_usr_mask_get(void *data, u64 *val)
 	return 0;
 }
 
-static int ufs_debugfs_get_user_access(struct ufs_hba *hba)
-__acquires(&hba->host_sem)
-{
-	down(&hba->host_sem);
-	if (!ufshcd_is_user_access_allowed(hba)) {
-		up(&hba->host_sem);
-		return -EBUSY;
-	}
-	ufshcd_rpm_get_sync(hba);
-	return 0;
-}
-
-static void ufs_debugfs_put_user_access(struct ufs_hba *hba)
-__releases(&hba->host_sem)
-{
-	ufshcd_rpm_put_sync(hba);
-	up(&hba->host_sem);
-}
-
 static int ee_usr_mask_set(void *data, u64 val)
 {
 	struct ufs_hba *hba = data;
@@ -78,11 +59,11 @@ static int ee_usr_mask_set(void *data, u64 val)
 
 	if (val & ~(u64)MASK_EE_STATUS)
 		return -EINVAL;
-	err = ufs_debugfs_get_user_access(hba);
+	err = ufshcd_get_user_access(hba);
 	if (err)
 		return err;
 	err = ufshcd_update_ee_usr_mask(hba, val, MASK_EE_STATUS);
-	ufs_debugfs_put_user_access(hba);
+	ufshcd_put_user_access(hba);
 	return err;
 }
 
@@ -120,10 +101,10 @@ static void ufs_debugfs_restart_ee(struct work_struct *work)
 	struct ufs_hba *hba = container_of(work, struct ufs_hba, debugfs_ee_work.work);
 
 	if (!hba->ee_usr_mask || pm_runtime_suspended(hba->dev) ||
-	    ufs_debugfs_get_user_access(hba))
+	    ufshcd_get_user_access(hba))
 		return;
 	ufshcd_write_ee_control(hba);
-	ufs_debugfs_put_user_access(hba);
+	ufshcd_put_user_access(hba);
 }
 
 void ufs_debugfs_hba_init(struct ufs_hba *hba)
diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 52bd807..b8732b9 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -160,22 +160,14 @@ static ssize_t auto_hibern8_show(struct device *dev,
 	if (!ufshcd_is_auto_hibern8_supported(hba))
 		return -EOPNOTSUPP;
 
-	down(&hba->host_sem);
-	if (!ufshcd_is_user_access_allowed(hba)) {
-		ret = -EBUSY;
-		goto out;
-	}
-
-	pm_runtime_get_sync(hba->dev);
+	ret = ufshcd_get_user_access(hba);
+	if (ret)
+		return ret;
 	ufshcd_hold(hba, false);
 	ahit = ufshcd_readl(hba, REG_AUTO_HIBERNATE_IDLE_TIMER);
 	ufshcd_release(hba);
-	pm_runtime_put_sync(hba->dev);
-
 	ret = sysfs_emit(buf, "%d\n", ufshcd_ahit_to_us(ahit));
-
-out:
-	up(&hba->host_sem);
+	ufshcd_put_user_access(hba);
 	return ret;
 }
 
@@ -202,7 +194,7 @@ static ssize_t auto_hibern8_store(struct device *dev,
 		goto out;
 	}
 
-	ufshcd_auto_hibern8_update(hba, ufshcd_us_to_ahit(timer));
+	ret = ufshcd_auto_hibern8_update(hba, ufshcd_us_to_ahit(timer));
 
 out:
 	up(&hba->host_sem);
@@ -239,17 +231,11 @@ static ssize_t wb_on_store(struct device *dev, struct device_attribute *attr,
 	if (wb_enable != 0 && wb_enable != 1)
 		return -EINVAL;
 
-	down(&hba->host_sem);
-	if (!ufshcd_is_user_access_allowed(hba)) {
-		res = -EBUSY;
-		goto out;
-	}
-
-	ufshcd_rpm_get_sync(hba);
+	res = ufshcd_get_user_access(hba);
+	if (res)
+		return res;
 	res = ufshcd_wb_toggle(hba, wb_enable);
-	ufshcd_rpm_put_sync(hba);
-out:
-	up(&hba->host_sem);
+	ufshcd_put_user_access(hba);
 	return res < 0 ? res : count;
 }
 
@@ -527,16 +513,11 @@ static ssize_t ufs_sysfs_read_desc_param(struct ufs_hba *hba,
 	if (param_size > 8)
 		return -EINVAL;
 
-	down(&hba->host_sem);
-	if (!ufshcd_is_user_access_allowed(hba)) {
-		ret = -EBUSY;
-		goto out;
-	}
-
-	ufshcd_rpm_get_sync(hba);
+	ret = ufshcd_get_user_access(hba);
+	if (ret)
+		return ret;
 	ret = ufshcd_read_desc_param(hba, desc_id, desc_index,
 				param_offset, desc_buf, param_size);
-	ufshcd_rpm_put_sync(hba);
 	if (ret) {
 		ret = -EINVAL;
 		goto out;
@@ -561,7 +542,7 @@ static ssize_t ufs_sysfs_read_desc_param(struct ufs_hba *hba,
 	}
 
 out:
-	up(&hba->host_sem);
+	ufshcd_put_user_access(hba);
 	return ret;
 }
 
@@ -904,23 +885,20 @@ static ssize_t _name##_show(struct device *dev,				\
 	int desc_len = QUERY_DESC_MAX_SIZE;				\
 	u8 *desc_buf;							\
 									\
-	down(&hba->host_sem);						\
-	if (!ufshcd_is_user_access_allowed(hba)) {			\
-		up(&hba->host_sem);					\
-		return -EBUSY;						\
-	}								\
+	ret = ufshcd_get_user_access(hba);				\
+	if (ret)							\
+		return ret;						\
 	desc_buf = kzalloc(QUERY_DESC_MAX_SIZE, GFP_ATOMIC);		\
 	if (!desc_buf) {						\
-		up(&hba->host_sem);					\
-		return -ENOMEM;						\
+		ret = -ENOMEM;						\
+		goto out;						\
 	}								\
-	ufshcd_rpm_get_sync(hba);					\
 	ret = ufshcd_query_descriptor_retry(hba,			\
 		UPIU_QUERY_OPCODE_READ_DESC, QUERY_DESC_IDN_DEVICE,	\
 		0, 0, desc_buf, &desc_len);				\
 	if (ret) {							\
 		ret = -EINVAL;						\
-		goto out;						\
+		goto out_free;						\
 	}								\
 	index = desc_buf[DEVICE_DESC_PARAM##_pname];			\
 	kfree(desc_buf);						\
@@ -928,12 +906,12 @@ static ssize_t _name##_show(struct device *dev,				\
 	ret = ufshcd_read_string_desc(hba, index, &desc_buf,		\
 				      SD_ASCII_STD);			\
 	if (ret < 0)							\
-		goto out;						\
+		goto out_free;						\
 	ret = sysfs_emit(buf, "%s\n", desc_buf);			\
-out:									\
-	ufshcd_rpm_put_sync(hba);					\
+out_free:								\
 	kfree(desc_buf);						\
-	up(&hba->host_sem);						\
+out:									\
+	ufshcd_put_user_access(hba);					\
 	return ret;							\
 }									\
 static DEVICE_ATTR_RO(_name)
@@ -973,24 +951,20 @@ static ssize_t _name##_show(struct device *dev,				\
 	int ret;							\
 	struct ufs_hba *hba = dev_get_drvdata(dev);			\
 									\
-	down(&hba->host_sem);						\
-	if (!ufshcd_is_user_access_allowed(hba)) {			\
-		up(&hba->host_sem);					\
-		return -EBUSY;						\
-	}								\
+	ret = ufshcd_get_user_access(hba);				\
+	if (ret)							\
+		return ret;						\
 	if (ufshcd_is_wb_flags(QUERY_FLAG_IDN##_uname))			\
 		index = ufshcd_wb_get_query_index(hba);			\
-	ufshcd_rpm_get_sync(hba);					\
 	ret = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_READ_FLAG,	\
 		QUERY_FLAG_IDN##_uname, index, &flag);			\
-	ufshcd_rpm_put_sync(hba);					\
 	if (ret) {							\
 		ret = -EINVAL;						\
 		goto out;						\
 	}								\
 	ret = sysfs_emit(buf, "%s\n", flag ? "true" : "false");		\
 out:									\
-	up(&hba->host_sem);						\
+	ufshcd_put_user_access(hba);					\
 	return ret;							\
 }									\
 static DEVICE_ATTR_RO(_name)
@@ -1042,24 +1016,20 @@ static ssize_t _name##_show(struct device *dev,				\
 	int ret;							\
 	u8 index = 0;							\
 									\
-	down(&hba->host_sem);						\
-	if (!ufshcd_is_user_access_allowed(hba)) {			\
-		up(&hba->host_sem);					\
-		return -EBUSY;						\
-	}								\
+	ret = ufshcd_get_user_access(hba);				\
+	if (ret)							\
+		return ret;						\
 	if (ufshcd_is_wb_attrs(QUERY_ATTR_IDN##_uname))			\
 		index = ufshcd_wb_get_query_index(hba);			\
-	ufshcd_rpm_get_sync(hba);					\
 	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,	\
 		QUERY_ATTR_IDN##_uname, index, 0, &value);		\
-	ufshcd_rpm_put_sync(hba);					\
 	if (ret) {							\
 		ret = -EINVAL;						\
 		goto out;						\
 	}								\
 	ret = sysfs_emit(buf, "0x%08X\n", value);			\
 out:									\
-	up(&hba->host_sem);						\
+	ufshcd_put_user_access(hba);					\
 	return ret;							\
 }									\
 static DEVICE_ATTR_RO(_name)
@@ -1195,16 +1165,11 @@ static ssize_t dyn_cap_needed_attribute_show(struct device *dev,
 	u8 lun = ufshcd_scsi_to_upiu_lun(sdev->lun);
 	int ret;
 
-	down(&hba->host_sem);
-	if (!ufshcd_is_user_access_allowed(hba)) {
-		ret = -EBUSY;
-		goto out;
-	}
-
-	ufshcd_rpm_get_sync(hba);
+	ret = ufshcd_get_user_access(hba);
+	if (ret)
+		return ret;
 	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
 		QUERY_ATTR_IDN_DYN_CAP_NEEDED, lun, 0, &value);
-	ufshcd_rpm_put_sync(hba);
 	if (ret) {
 		ret = -EINVAL;
 		goto out;
@@ -1213,7 +1178,7 @@ static ssize_t dyn_cap_needed_attribute_show(struct device *dev,
 	ret = sysfs_emit(buf, "0x%08X\n", value);
 
 out:
-	up(&hba->host_sem);
+	ufshcd_put_user_access(hba);
 	return ret;
 }
 static DEVICE_ATTR_RO(dyn_cap_needed_attribute);
diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs/ufs_bsg.c
index 39bf204..c5b3eb8 100644
--- a/drivers/scsi/ufs/ufs_bsg.c
+++ b/drivers/scsi/ufs/ufs_bsg.c
@@ -97,7 +97,9 @@ static int ufs_bsg_request(struct bsg_job *job)
 
 	bsg_reply->reply_payload_rcv_len = 0;
 
-	ufshcd_rpm_get_sync(hba);
+	ret = ufshcd_get_user_access(hba);
+	if (ret)
+		goto out;
 
 	msgcode = bsg_request->msgcode;
 	switch (msgcode) {
@@ -105,10 +107,8 @@ static int ufs_bsg_request(struct bsg_job *job)
 		desc_op = bsg_request->upiu_req.qr.opcode;
 		ret = ufs_bsg_alloc_desc_buffer(hba, job, &desc_buff,
 						&desc_len, desc_op);
-		if (ret) {
-			ufshcd_rpm_put_sync(hba);
-			goto out;
-		}
+		if (ret)
+			goto out_put_access;
 
 		fallthrough;
 	case UPIU_TRANSACTION_NOP_OUT:
@@ -138,10 +138,8 @@ static int ufs_bsg_request(struct bsg_job *job)
 		break;
 	}
 
-	ufshcd_rpm_put_sync(hba);
-
 	if (!desc_buff)
-		goto out;
+		goto out_put_access;
 
 	if (desc_op == UPIU_QUERY_OPCODE_READ_DESC && desc_len)
 		bsg_reply->reply_payload_rcv_len =
@@ -151,6 +149,8 @@ static int ufs_bsg_request(struct bsg_job *job)
 
 	kfree(desc_buff);
 
+out_put_access:
+	ufshcd_put_user_access(hba);
 out:
 	bsg_reply->result = ret;
 	job->reply_len = sizeof(struct ufs_bsg_reply);
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index cf24ec2..5ec829c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -128,15 +128,6 @@ enum {
 	UFSHCD_CAN_QUEUE	= 32,
 };
 
-/* UFSHCD states */
-enum {
-	UFSHCD_STATE_RESET,
-	UFSHCD_STATE_ERROR,
-	UFSHCD_STATE_OPERATIONAL,
-	UFSHCD_STATE_EH_SCHEDULED_FATAL,
-	UFSHCD_STATE_EH_SCHEDULED_NON_FATAL,
-};
-
 /* UFSHCD error handling flags */
 enum {
 	UFSHCD_EH_IN_PROGRESS = (1 << 0),
@@ -254,6 +245,31 @@ static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable);
 static void ufshcd_hba_vreg_set_lpm(struct ufs_hba *hba);
 static void ufshcd_hba_vreg_set_hpm(struct ufs_hba *hba);
 
+int ufshcd_get_user_access(struct ufs_hba *hba)
+__acquires(&hba->host_sem)
+{
+	down(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		up(&hba->host_sem);
+		return -EBUSY;
+	}
+	if (ufshcd_rpm_get_sync(hba)) {
+		ufshcd_rpm_put_sync(hba);
+		up(&hba->host_sem);
+		return -EBUSY;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ufshcd_get_user_access);
+
+void ufshcd_put_user_access(struct ufs_hba *hba)
+__releases(&hba->host_sem)
+{
+	ufshcd_rpm_put_sync(hba);
+	up(&hba->host_sem);
+}
+EXPORT_SYMBOL_GPL(ufshcd_put_user_access);
+
 static inline bool ufshcd_valid_tag(struct ufs_hba *hba, int tag)
 {
 	return tag >= 0 && tag < hba->nutrs;
@@ -1553,19 +1569,14 @@ static ssize_t ufshcd_clkscale_enable_store(struct device *dev,
 	if (kstrtou32(buf, 0, &value))
 		return -EINVAL;
 
-	down(&hba->host_sem);
-	if (!ufshcd_is_user_access_allowed(hba)) {
-		err = -EBUSY;
-		goto out;
-	}
+	err = ufshcd_get_user_access(hba);
+	if (err)
+		return err;
+	ufshcd_hold(hba, false);
 
 	value = !!value;
 	if (value == hba->clk_scaling.is_enabled)
 		goto out;
-
-	ufshcd_rpm_get_sync(hba);
-	ufshcd_hold(hba, false);
-
 	hba->clk_scaling.is_enabled = value;
 
 	if (value) {
@@ -1578,10 +1589,9 @@ static ssize_t ufshcd_clkscale_enable_store(struct device *dev,
 					__func__, err);
 	}
 
-	ufshcd_release(hba);
-	ufshcd_rpm_put_sync(hba);
 out:
-	up(&hba->host_sem);
+	ufshcd_release(hba);
+	ufshcd_put_user_access(hba);
 	return err ? err : count;
 }
 
@@ -4180,13 +4190,13 @@ int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
 }
 EXPORT_SYMBOL_GPL(ufshcd_uic_hibern8_exit);
 
-void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
+int ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 {
 	unsigned long flags;
 	bool update = false;
 
 	if (!ufshcd_is_auto_hibern8_supported(hba))
-		return;
+		return 0;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	if (hba->ahit != ahit) {
@@ -4197,12 +4207,17 @@ void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 
 	if (update &&
 	    !pm_runtime_suspended(&hba->sdev_ufs_device->sdev_gendev)) {
-		ufshcd_rpm_get_sync(hba);
+		if (ufshcd_rpm_get_sync(hba)) {
+			ufshcd_rpm_put_sync(hba);
+			return -EBUSY;
+		}
 		ufshcd_hold(hba, false);
 		ufshcd_auto_hibern8_enable(hba);
 		ufshcd_release(hba);
 		ufshcd_rpm_put_sync(hba);
 	}
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(ufshcd_auto_hibern8_update);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 47da47c..5cd1484 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -101,6 +101,15 @@ struct uic_command {
 	struct completion done;
 };
 
+/* UFSHCD states */
+enum {
+	UFSHCD_STATE_RESET,
+	UFSHCD_STATE_ERROR,
+	UFSHCD_STATE_OPERATIONAL,
+	UFSHCD_STATE_EH_SCHEDULED_FATAL,
+	UFSHCD_STATE_EH_SCHEDULED_NON_FATAL,
+};
+
 /* Used to differentiate the power management options */
 enum ufs_pm_op {
 	UFS_RUNTIME_PM,
@@ -931,7 +940,9 @@ static inline bool ufshcd_is_wb_allowed(struct ufs_hba *hba)
 
 static inline bool ufshcd_is_user_access_allowed(struct ufs_hba *hba)
 {
-	return !hba->shutting_down;
+	return !hba->shutting_down && !hba->is_sys_suspended &&
+		!hba->is_wl_sys_suspended &&
+		hba->ufshcd_state == UFSHCD_STATE_OPERATIONAL;
 }
 
 #define ufshcd_writel(hba, val, reg)	\
@@ -1104,7 +1115,7 @@ int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 	enum flag_idn idn, u8 index, bool *flag_res);
 
 void ufshcd_auto_hibern8_enable(struct ufs_hba *hba);
-void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit);
+int ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit);
 void ufshcd_fixup_dev_quirks(struct ufs_hba *hba, struct ufs_dev_fix *fixups);
 #define SD_ASCII_STD true
 #define SD_RAW false
@@ -1131,6 +1142,8 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable);
 int ufshcd_suspend_prepare(struct device *dev);
 void ufshcd_resume_complete(struct device *dev);
+int ufshcd_get_user_access(struct ufs_hba *hba);
+void ufshcd_put_user_access(struct ufs_hba *hba);
 
 /* Wrapper functions for safely calling variant operations */
 static inline const char *ufshcd_get_var_name(struct ufs_hba *hba)
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

