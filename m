Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D613C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:53:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AF0D61027
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:53:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbhDTCxg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 22:53:36 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:44422 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbhDTCxg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 22:53:36 -0400
Received: from epcas3p2.samsung.com (unknown [182.195.41.20])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210420025304epoutp04ed66df0ad6dc5b52ce3f4c8523d952fb~3cVEfAbOR1275512755epoutp04c
        for <linux-scsi@vger.kernel.org>; Tue, 20 Apr 2021 02:53:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210420025304epoutp04ed66df0ad6dc5b52ce3f4c8523d952fb~3cVEfAbOR1275512755epoutp04c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1618887184;
        bh=Fp/0nc/PyyIZ2plCf1MobAAmjIp1zIjpOhmUIT5HL0E=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=ury1zp0nYtGkon3jN+ziBRRpiXxVKsHLdVi8rp2vS6WwA9W5RH09UpZaa0Hk74aQv
         Pl4VzBFMuI52FVrZHa49jlo5UkRdPNIJ6emxd/1EvlY/e1v85ULxYMoA5857XR/EUS
         oYynkg3FOqvURkRnDceWCj+9lFs7AQhFpnm3o3sc=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas3p2.samsung.com (KnoxPortal) with ESMTP id
        20210420025303epcas3p2ff9cdfd8053f051d3cd8fa96d1ec887b~3cVD3K_3S2946829468epcas3p2E;
        Tue, 20 Apr 2021 02:53:03 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp2.localdomain
        (Postfix) with ESMTP id 4FPSsq43d1z4x9Q0; Tue, 20 Apr 2021 02:53:03 +0000
        (GMT)
Mime-Version: 1.0
Subject: [PATCH] scsi: ufs: Add batched WB buffer flush
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "mchehab+huawei@kernel.org" <mchehab+huawei@kernel.org>,
        Keoseong Park <keosung.park@samsung.com>,
        "lukas.bulwahn@gmail.com" <lukas.bulwahn@gmail.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        Daejun Park <daejun7.park@samsung.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        "satyat@google.com" <satyat@google.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Jieon Seol <jieon.seol@samsung.com>,
        Jaemyung Lee <jaemyung.lee@samsung.com>,
        Dukhyun Kwon <d_hyun.kwon@samsung.com>,
        JinHwan Park <jh.i.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1381713434.61618887183562.JavaMail.epsvc@epcpadp4>
Date:   Tue, 20 Apr 2021 11:50:12 +0900
X-CMS-MailID: 20210420025012epcms2p4a850fa0017e7a152ec5e5f89350d66b9
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210420025012epcms2p4a850fa0017e7a152ec5e5f89350d66b9
References: <CGME20210420025012epcms2p4a850fa0017e7a152ec5e5f89350d66b9@epcms2p4>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently, WriteBooster (WB) buffer is always flushed during hibern8. However,
this is inefficient because data in the WB buffer can be invalid due to
spatial locality of IO workload.
If the WB buffer flush is flushed in a batched manner, the amount of data
migration and power consumption can be reduced because the overwritten data
of the WB buffer may be invalid due to spatial locality.

This patch supports batched flush of WB buffer. When batched flush is enabled,
fWriteBoosterBufferFlushDuringHibernate is set only when
b_rpm_dev_flush_capable is true during runtime suspend. When the device is
resumed, fWriteBoosterBufferFlushDuringHibernate is cleared to stop flush
during hibern8.

Co-developed-by: Keoseong Park <keosung.park@samsung.com>
Signed-off-by: Keoseong Park <keosung.park@samsung.com>
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs |  9 ++++
 drivers/scsi/ufs/ufs-sysfs.c               | 50 ++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c                  | 14 ++++--
 drivers/scsi/ufs/ufshcd.h                  |  2 +
 4 files changed, 71 insertions(+), 4 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index d1bc23cb6a9d..b67b8449e840 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1172,3 +1172,12 @@ Description:	This node is used to set or display whether UFS WriteBooster is
 		(if the platform supports UFSHCD_CAP_CLK_SCALING). For a
 		platform that doesn't support UFSHCD_CAP_CLK_SCALING, we can
 		disable/enable WriteBooster through this sysfs node.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/wb_batched_flush
+Date:		April 2021
+Contact:	Daejun Park <daejun7.park@samsung.com>
+Description:	This entry shows whether batch flushing of UFS WriteBooster
+		buffers is enabled. Writing 1 to this entry allows the device to flush
+		the WriteBooster buffer only when it needs to perform a buffer flush
+		during runtime suspend. Writing 0 to this entry allows the device to
+		flush the WriteBooster buffer during link hibernation.
diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index d7c3cff9662f..943ac12e59c6 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -253,6 +253,54 @@ static ssize_t wb_on_store(struct device *dev, struct device_attribute *attr,
 	return res < 0 ? res : count;
 }
 
+
+static ssize_t wb_batched_flush_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "%d\n", hba->vps->wb_batched_flush);
+}
+
+static ssize_t wb_batched_flush_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	unsigned int wb_batched_flush;
+	ssize_t res;
+
+	if (!ufshcd_is_wb_allowed(hba)) {
+		dev_warn(dev, "To control WB through wb_batched_flush is not allowed!\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (kstrtouint(buf, 0, &wb_batched_flush))
+		return -EINVAL;
+
+	if (wb_batched_flush != 0 && wb_batched_flush != 1)
+		return -EINVAL;
+
+	down(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		res = -EBUSY;
+		goto out;
+	}
+
+	if (wb_batched_flush == hba->vps->wb_batched_flush)
+		goto out;
+
+	pm_runtime_get_sync(hba->dev);
+	res = ufshcd_wb_toggle_flush_during_h8(hba, !wb_batched_flush);
+	pm_runtime_put_sync(hba->dev);
+	if (!res)
+		hba->vps->wb_batched_flush = wb_batched_flush;
+
+out:
+	up(&hba->host_sem);
+	return res < 0 ? res : count;
+}
+
 static DEVICE_ATTR_RW(rpm_lvl);
 static DEVICE_ATTR_RO(rpm_target_dev_state);
 static DEVICE_ATTR_RO(rpm_target_link_state);
@@ -261,6 +309,7 @@ static DEVICE_ATTR_RO(spm_target_dev_state);
 static DEVICE_ATTR_RO(spm_target_link_state);
 static DEVICE_ATTR_RW(auto_hibern8);
 static DEVICE_ATTR_RW(wb_on);
+static DEVICE_ATTR_RW(wb_batched_flush);
 
 static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
 	&dev_attr_rpm_lvl.attr,
@@ -271,6 +320,7 @@ static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
 	&dev_attr_spm_target_link_state.attr,
 	&dev_attr_auto_hibern8.attr,
 	&dev_attr_wb_on.attr,
+	&dev_attr_wb_batched_flush.attr,
 	NULL
 };
 
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0625da7a42ee..e11dc578a17c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -244,7 +244,6 @@ static int ufshcd_setup_vreg(struct ufs_hba *hba, bool on);
 static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
 					 struct ufs_vreg *vreg);
 static int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag);
-static void ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set);
 static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable);
 static void ufshcd_hba_vreg_set_lpm(struct ufs_hba *hba);
 static void ufshcd_hba_vreg_set_hpm(struct ufs_hba *hba);
@@ -277,7 +276,8 @@ static inline void ufshcd_wb_config(struct ufs_hba *hba)
 
 	ufshcd_wb_toggle(hba, true);
 
-	ufshcd_wb_toggle_flush_during_h8(hba, true);
+	ufshcd_wb_toggle_flush_during_h8(hba, !hba->vps->wb_batched_flush);
+
 	if (!(hba->quirks & UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL))
 		ufshcd_wb_toggle_flush(hba, true);
 }
@@ -5472,7 +5472,7 @@ int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable)
 	return ret;
 }
 
-static void ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set)
+int ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set)
 {
 	int ret;
 
@@ -5481,10 +5481,12 @@ static void ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set)
 	if (ret) {
 		dev_err(hba->dev, "%s: WB-Buf Flush during H8 %s failed: %d\n",
 			__func__, set ? "enable" : "disable", ret);
-		return;
+		return ret;
 	}
 	dev_dbg(hba->dev, "%s WB-Buf Flush during H8 %s\n",
 			__func__, set ? "enabled" : "disabled");
+
+	return ret;
 }
 
 static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable)
@@ -8745,6 +8747,8 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 			ret = ufshcd_set_dev_pwr_mode(hba, req_dev_pwr_mode);
 			if (ret)
 				goto enable_gating;
+		} else if (hba->vps->wb_batched_flush) {
+			ufshcd_wb_toggle_flush_during_h8(hba, true);
 		}
 	}
 
@@ -8925,6 +8929,8 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	ufshcd_auto_hibern8_enable(hba);
 
 	if (hba->dev_info.b_rpm_dev_flush_capable) {
+		if (hba->vps->wb_batched_flush)
+			ufshcd_wb_toggle_flush_during_h8(hba, false);
 		hba->dev_info.b_rpm_dev_flush_capable = false;
 		cancel_delayed_work(&hba->rpm_dev_flush_recheck_work);
 	}
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 5eb66a8debc7..049f3f08506c 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -643,6 +643,7 @@ struct ufs_hba_variant_params {
 	struct devfreq_simple_ondemand_data ondemand_data;
 	u16 hba_enable_delay_us;
 	u32 wb_flush_threshold;
+	bool wb_batched_flush;
 };
 
 /**
@@ -1105,6 +1106,7 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 			     enum query_opcode desc_op);
 
 int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable);
+int ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set);
 
 /* Wrapper functions for safely calling variant operations */
 static inline const char *ufshcd_get_var_name(struct ufs_hba *hba)
-- 
2.25.1


