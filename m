Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BBFEC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 22:40:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241791AbiCaWly (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 18:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233865AbiCaWlx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 18:41:53 -0400
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64DD21C2DAA
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:40:04 -0700 (PDT)
Received: by mail-pj1-f43.google.com with SMTP id mj15-20020a17090b368f00b001c637aa358eso3691557pjb.0
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:40:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FdAhgC6L10JaSDYdXGFyQpbAL4YR7OiTiMHONFsfLNw=;
        b=fRFcx625NuuJg4YE6n6B4Px4WtHSS8hKpDFcVeXaDFWZHHBXAdxwsST3VageYY16Nv
         dSpy2bj/qPbPmr5jW4MUzNSZTffypiBhMkT2UIZf25lNV/z20OeINPkk1We+U9qTeCwT
         CwOomUkQvxBYRkWNKaMdYWRkl6weoFBYvztsFsAhuw7kM0k3pTxFnHZkOP9KR/bMbtz6
         aepD85Cv4qcBlBDy+44oP+GgjY8sKK2UebOEy2NKN+hQdSwaqe1Ui4Zl2JruNiYk8tj+
         Cp2i4xPEj5qpyyw62WTi6+c3i+XHUs51BvwX+dg+CWcQxudH+O9G5LPIb7OGIuC2wTlW
         nuWQ==
X-Gm-Message-State: AOAM533GfTq/LUWM1S2Mtal+xnugm+so65SKUIQoCknQbLzVlBDljAXn
        eNWflQ3wUF1JAb8IHndQLg0=
X-Google-Smtp-Source: ABdhPJz3Z2g0MyGUmEx4nv1wvJsOk3HKgv5bysdSDxSI9vIO6m+4cB8eSjkdkHt0J0Z0BBlWYZQ3gQ==
X-Received: by 2002:a17:903:404b:b0:154:2b02:a496 with SMTP id n11-20020a170903404b00b001542b02a496mr42484907pla.73.1648766403564;
        Thu, 31 Mar 2022 15:40:03 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6375:fa54:efe8:6c8f])
        by smtp.gmail.com with ESMTPSA id p3-20020a056a000b4300b004faee36ea56sm483481pfo.155.2022.03.31.15.40.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 15:40:02 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Avri Altman <Avri.Altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Daejun Park <daejun7.park@samsung.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Bean Huo <beanhuo@micron.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Eric Biggers <ebiggers@google.com>,
        Jens Axboe <axboe@kernel.dk>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 26/29] scsi: ufs: Split the ufshcd.h header file
Date:   Thu, 31 Mar 2022 15:34:21 -0700
Message-Id: <20220331223424.1054715-27-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
In-Reply-To: <20220331223424.1054715-1-bvanassche@acm.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Split the ufshcd.h header file into a header file that defines the
interface used by UFS drivers and another header file with declarations
and data structures only used by the UFS core.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufs-debugfs.c   |   1 +
 drivers/scsi/ufs/ufs-hwmon.c     |   1 +
 drivers/scsi/ufs/ufs-sysfs.c     |   3 +-
 drivers/scsi/ufs/ufs_bsg.c       |   1 +
 drivers/scsi/ufs/ufshcd-crypto.h |   2 +
 drivers/scsi/ufs/ufshcd-priv.h   | 277 +++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c        |   1 +
 drivers/scsi/ufs/ufshcd.h        | 212 -----------------------
 drivers/scsi/ufs/ufshpb.c        |   1 +
 9 files changed, 285 insertions(+), 214 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshcd-priv.h

diff --git a/drivers/scsi/ufs/ufs-debugfs.c b/drivers/scsi/ufs/ufs-debugfs.c
index 4a0bbcf1757a..c10a8f09682b 100644
--- a/drivers/scsi/ufs/ufs-debugfs.c
+++ b/drivers/scsi/ufs/ufs-debugfs.c
@@ -5,6 +5,7 @@
 
 #include "ufs-debugfs.h"
 #include "ufshcd.h"
+#include "ufshcd-priv.h"
 
 static struct dentry *ufs_debugfs_root;
 
diff --git a/drivers/scsi/ufs/ufs-hwmon.c b/drivers/scsi/ufs/ufs-hwmon.c
index 74855491dc8f..c38d9d98a86d 100644
--- a/drivers/scsi/ufs/ufs-hwmon.c
+++ b/drivers/scsi/ufs/ufs-hwmon.c
@@ -8,6 +8,7 @@
 #include <linux/units.h>
 
 #include "ufshcd.h"
+#include "ufshcd-priv.h"
 
 struct ufs_hwmon_data {
 	struct ufs_hba *hba;
diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 2bf128e4b613..97ab1a75e3b8 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -6,8 +6,7 @@
 #include <linux/err.h>
 #include <linux/string.h>
 #include "ufs-sysfs.h"
-#include "ufs.h"
-#include "ufshcd.h"
+#include "ufshcd-priv.h"
 
 static const char *ufshcd_uic_link_state_to_string(
 			enum uic_link_state state)
diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs/ufs_bsg.c
index fbcdfb713542..9e9b93867cab 100644
--- a/drivers/scsi/ufs/ufs_bsg.c
+++ b/drivers/scsi/ufs/ufs_bsg.c
@@ -10,6 +10,7 @@
 #include <scsi/scsi_host.h>
 #include "ufs_bsg.h"
 #include "ufshcd.h"
+#include "ufshcd-priv.h"
 
 static int ufs_bsg_get_query_desc_size(struct ufs_hba *hba, int *desc_len,
 				       struct utp_upiu_query *qr)
diff --git a/drivers/scsi/ufs/ufshcd-crypto.h b/drivers/scsi/ufs/ufshcd-crypto.h
index 57dd51256b57..9f98f18f9646 100644
--- a/drivers/scsi/ufs/ufshcd-crypto.h
+++ b/drivers/scsi/ufs/ufshcd-crypto.h
@@ -8,6 +8,8 @@
 
 #include <scsi/scsi_cmnd.h>
 #include "ufshcd.h"
+#include "ufshcd-priv.h"
+#include "ufshci.h"
 
 #ifdef CONFIG_SCSI_UFS_CRYPTO
 
diff --git a/drivers/scsi/ufs/ufshcd-priv.h b/drivers/scsi/ufs/ufshcd-priv.h
new file mode 100644
index 000000000000..4ceb0c63aa15
--- /dev/null
+++ b/drivers/scsi/ufs/ufshcd-priv.h
@@ -0,0 +1,277 @@
+#ifndef _UFSHCD_PRIV_H_
+#define _UFSHCD_PRIV_H_
+
+#include <linux/pm_runtime.h>
+#include "ufshcd.h"
+
+static inline bool ufshcd_is_user_access_allowed(struct ufs_hba *hba)
+{
+	return !hba->shutting_down;
+}
+
+void ufshcd_schedule_eh_work(struct ufs_hba *hba);
+
+static inline bool ufshcd_keep_autobkops_enabled_except_suspend(
+							struct ufs_hba *hba)
+{
+	return hba->caps & UFSHCD_CAP_KEEP_AUTO_BKOPS_ENABLED_EXCEPT_SUSPEND;
+}
+
+static inline u8 ufshcd_wb_get_query_index(struct ufs_hba *hba)
+{
+	if (hba->dev_info.wb_buffer_type == WB_BUF_MODE_LU_DEDICATED)
+		return hba->dev_info.wb_dedicated_lu;
+	return 0;
+}
+
+#ifdef CONFIG_SCSI_UFS_HWMON
+void ufs_hwmon_probe(struct ufs_hba *hba, u8 mask);
+void ufs_hwmon_remove(struct ufs_hba *hba);
+void ufs_hwmon_notify_event(struct ufs_hba *hba, u8 ee_mask);
+#else
+static inline void ufs_hwmon_probe(struct ufs_hba *hba, u8 mask) {}
+static inline void ufs_hwmon_remove(struct ufs_hba *hba) {}
+static inline void ufs_hwmon_notify_event(struct ufs_hba *hba, u8 ee_mask) {}
+#endif
+
+int ufshcd_read_desc_param(struct ufs_hba *hba,
+			   enum desc_idn desc_id,
+			   int desc_index,
+			   u8 param_offset,
+			   u8 *param_read_buf,
+			   u8 param_size);
+int ufshcd_query_attr_retry(struct ufs_hba *hba, enum query_opcode opcode,
+			    enum attr_idn idn, u8 index, u8 selector,
+			    u32 *attr_val);
+int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
+		      enum attr_idn idn, u8 index, u8 selector, u32 *attr_val);
+int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
+	enum flag_idn idn, u8 index, bool *flag_res);
+void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit);
+
+#define SD_ASCII_STD true
+#define SD_RAW false
+int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
+			    u8 **buf, bool ascii);
+
+int ufshcd_hold(struct ufs_hba *hba, bool async);
+void ufshcd_release(struct ufs_hba *hba);
+
+void ufshcd_map_desc_id_to_length(struct ufs_hba *hba, enum desc_idn desc_id,
+				  int *desc_length);
+
+int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd);
+
+int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
+			     struct utp_upiu_req *req_upiu,
+			     struct utp_upiu_req *rsp_upiu,
+			     int msgcode,
+			     u8 *desc_buff, int *buff_len,
+			     enum query_opcode desc_op);
+
+int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable);
+
+/* Wrapper functions for safely calling variant operations */
+static inline const char *ufshcd_get_var_name(struct ufs_hba *hba)
+{
+	if (hba->vops)
+		return hba->vops->name;
+	return "";
+}
+
+static inline void ufshcd_vops_exit(struct ufs_hba *hba)
+{
+	if (hba->vops && hba->vops->exit)
+		return hba->vops->exit(hba);
+}
+
+static inline u32 ufshcd_vops_get_ufs_hci_version(struct ufs_hba *hba)
+{
+	if (hba->vops && hba->vops->get_ufs_hci_version)
+		return hba->vops->get_ufs_hci_version(hba);
+
+	return ufshcd_readl(hba, REG_UFS_VERSION);
+}
+
+static inline int ufshcd_vops_clk_scale_notify(struct ufs_hba *hba,
+			bool up, enum ufs_notify_change_status status)
+{
+	if (hba->vops && hba->vops->clk_scale_notify)
+		return hba->vops->clk_scale_notify(hba, up, status);
+	return 0;
+}
+
+static inline void ufshcd_vops_event_notify(struct ufs_hba *hba,
+					    enum ufs_event_type evt,
+					    void *data)
+{
+	if (hba->vops && hba->vops->event_notify)
+		hba->vops->event_notify(hba, evt, data);
+}
+
+static inline int ufshcd_vops_setup_clocks(struct ufs_hba *hba, bool on,
+					enum ufs_notify_change_status status)
+{
+	if (hba->vops && hba->vops->setup_clocks)
+		return hba->vops->setup_clocks(hba, on, status);
+	return 0;
+}
+
+static inline int ufshcd_vops_hce_enable_notify(struct ufs_hba *hba,
+						bool status)
+{
+	if (hba->vops && hba->vops->hce_enable_notify)
+		return hba->vops->hce_enable_notify(hba, status);
+
+	return 0;
+}
+static inline int ufshcd_vops_link_startup_notify(struct ufs_hba *hba,
+						bool status)
+{
+	if (hba->vops && hba->vops->link_startup_notify)
+		return hba->vops->link_startup_notify(hba, status);
+
+	return 0;
+}
+
+static inline int ufshcd_vops_pwr_change_notify(struct ufs_hba *hba,
+				  enum ufs_notify_change_status status,
+				  struct ufs_pa_layer_attr *dev_max_params,
+				  struct ufs_pa_layer_attr *dev_req_params)
+{
+	if (hba->vops && hba->vops->pwr_change_notify)
+		return hba->vops->pwr_change_notify(hba, status,
+					dev_max_params, dev_req_params);
+
+	return -ENOTSUPP;
+}
+
+static inline void ufshcd_vops_setup_task_mgmt(struct ufs_hba *hba,
+					int tag, u8 tm_function)
+{
+	if (hba->vops && hba->vops->setup_task_mgmt)
+		return hba->vops->setup_task_mgmt(hba, tag, tm_function);
+}
+
+static inline void ufshcd_vops_hibern8_notify(struct ufs_hba *hba,
+					enum uic_cmd_dme cmd,
+					enum ufs_notify_change_status status)
+{
+	if (hba->vops && hba->vops->hibern8_notify)
+		return hba->vops->hibern8_notify(hba, cmd, status);
+}
+
+static inline int ufshcd_vops_apply_dev_quirks(struct ufs_hba *hba)
+{
+	if (hba->vops && hba->vops->apply_dev_quirks)
+		return hba->vops->apply_dev_quirks(hba);
+	return 0;
+}
+
+static inline void ufshcd_vops_fixup_dev_quirks(struct ufs_hba *hba)
+{
+	if (hba->vops && hba->vops->fixup_dev_quirks)
+		hba->vops->fixup_dev_quirks(hba);
+}
+
+static inline int ufshcd_vops_suspend(struct ufs_hba *hba, enum ufs_pm_op op,
+				enum ufs_notify_change_status status)
+{
+	if (hba->vops && hba->vops->suspend)
+		return hba->vops->suspend(hba, op, status);
+
+	return 0;
+}
+
+static inline int ufshcd_vops_resume(struct ufs_hba *hba, enum ufs_pm_op op)
+{
+	if (hba->vops && hba->vops->resume)
+		return hba->vops->resume(hba, op);
+
+	return 0;
+}
+
+static inline void ufshcd_vops_dbg_register_dump(struct ufs_hba *hba)
+{
+	if (hba->vops && hba->vops->dbg_register_dump)
+		hba->vops->dbg_register_dump(hba);
+}
+
+static inline int ufshcd_vops_device_reset(struct ufs_hba *hba)
+{
+	if (hba->vops && hba->vops->device_reset)
+		return hba->vops->device_reset(hba);
+
+	return -EOPNOTSUPP;
+}
+
+static inline void ufshcd_vops_config_scaling_param(struct ufs_hba *hba,
+		struct devfreq_dev_profile *p,
+		struct devfreq_simple_ondemand_data *data)
+{
+	if (hba->vops && hba->vops->config_scaling_param)
+		hba->vops->config_scaling_param(hba, p, data);
+}
+
+extern struct ufs_pm_lvl_states ufs_pm_lvl_states[];
+
+/**
+ * ufshcd_scsi_to_upiu_lun - maps scsi LUN to UPIU LUN
+ * @scsi_lun: scsi LUN id
+ *
+ * Returns UPIU LUN id
+ */
+static inline u8 ufshcd_scsi_to_upiu_lun(unsigned int scsi_lun)
+{
+	if (scsi_is_wlun(scsi_lun))
+		return (scsi_lun & UFS_UPIU_MAX_UNIT_NUM_ID)
+			| UFS_UPIU_WLUN_ID;
+	else
+		return scsi_lun & UFS_UPIU_MAX_UNIT_NUM_ID;
+}
+
+int __ufshcd_write_ee_control(struct ufs_hba *hba, u32 ee_ctrl_mask);
+int ufshcd_write_ee_control(struct ufs_hba *hba);
+int ufshcd_update_ee_control(struct ufs_hba *hba, u16 *mask, u16 *other_mask,
+			     u16 set, u16 clr);
+
+static inline int ufshcd_update_ee_drv_mask(struct ufs_hba *hba,
+					    u16 set, u16 clr)
+{
+	return ufshcd_update_ee_control(hba, &hba->ee_drv_mask,
+					&hba->ee_usr_mask, set, clr);
+}
+
+static inline int ufshcd_update_ee_usr_mask(struct ufs_hba *hba,
+					    u16 set, u16 clr)
+{
+	return ufshcd_update_ee_control(hba, &hba->ee_usr_mask,
+					&hba->ee_drv_mask, set, clr);
+}
+
+static inline int ufshcd_rpm_get_sync(struct ufs_hba *hba)
+{
+	return pm_runtime_get_sync(&hba->ufs_device_wlun->sdev_gendev);
+}
+
+static inline int ufshcd_rpm_put_sync(struct ufs_hba *hba)
+{
+	return pm_runtime_put_sync(&hba->ufs_device_wlun->sdev_gendev);
+}
+
+static inline void ufshcd_rpm_get_noresume(struct ufs_hba *hba)
+{
+	pm_runtime_get_noresume(&hba->ufs_device_wlun->sdev_gendev);
+}
+
+static inline int ufshcd_rpm_resume(struct ufs_hba *hba)
+{
+	return pm_runtime_resume(&hba->ufs_device_wlun->sdev_gendev);
+}
+
+static inline int ufshcd_rpm_put(struct ufs_hba *hba)
+{
+	return pm_runtime_put(&hba->ufs_device_wlun->sdev_gendev);
+}
+
+#endif /* _UFSHCD_PRIV_H_ */
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index de366247628b..bab0f1ee41e6 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -32,6 +32,7 @@
 #include "ufs_bsg.h"
 #include "ufs_quirks.h"
 #include "ufshcd-crypto.h"
+#include "ufshcd-priv.h"
 #include "ufshcd.h"
 #include "ufshpb.h"
 #include "unipro.h"
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index ab0c643296c0..b13469fb1e15 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1007,11 +1007,6 @@ static inline bool ufshcd_is_wb_allowed(struct ufs_hba *hba)
 	return hba->caps & UFSHCD_CAP_WB_EN;
 }
 
-static inline bool ufshcd_is_user_access_allowed(struct ufs_hba *hba)
-{
-	return !hba->shutting_down;
-}
-
 #define ufshcd_writel(hba, val, reg)	\
 	writel((val), (hba)->mmio_base + (reg))
 #define ufshcd_readl(hba, reg)	\
@@ -1075,18 +1070,6 @@ static inline void *ufshcd_get_variant(struct ufs_hba *hba)
 	BUG_ON(!hba);
 	return hba->priv;
 }
-static inline bool ufshcd_keep_autobkops_enabled_except_suspend(
-							struct ufs_hba *hba)
-{
-	return hba->caps & UFSHCD_CAP_KEEP_AUTO_BKOPS_ENABLED_EXCEPT_SUSPEND;
-}
-
-static inline u8 ufshcd_wb_get_query_index(struct ufs_hba *hba)
-{
-	if (hba->dev_info.wb_buffer_type == WB_BUF_MODE_LU_DEDICATED)
-		return hba->dev_info.wb_dedicated_lu;
-	return 0;
-}
 
 #ifdef CONFIG_SCSI_UFS_HWMON
 void ufs_hwmon_probe(struct ufs_hba *hba, u8 mask);
@@ -1230,13 +1213,6 @@ int __ufshcd_suspend_prepare(struct device *dev, bool rpm_ok_for_spm);
 void ufshcd_resume_complete(struct device *dev);
 
 /* Wrapper functions for safely calling variant operations */
-static inline const char *ufshcd_get_var_name(struct ufs_hba *hba)
-{
-	if (hba->vops)
-		return hba->vops->name;
-	return "";
-}
-
 static inline int ufshcd_vops_init(struct ufs_hba *hba)
 {
 	if (hba->vops && hba->vops->init)
@@ -1245,61 +1221,6 @@ static inline int ufshcd_vops_init(struct ufs_hba *hba)
 	return 0;
 }
 
-static inline void ufshcd_vops_exit(struct ufs_hba *hba)
-{
-	if (hba->vops && hba->vops->exit)
-		return hba->vops->exit(hba);
-}
-
-static inline u32 ufshcd_vops_get_ufs_hci_version(struct ufs_hba *hba)
-{
-	if (hba->vops && hba->vops->get_ufs_hci_version)
-		return hba->vops->get_ufs_hci_version(hba);
-
-	return ufshcd_readl(hba, REG_UFS_VERSION);
-}
-
-static inline int ufshcd_vops_clk_scale_notify(struct ufs_hba *hba,
-			bool up, enum ufs_notify_change_status status)
-{
-	if (hba->vops && hba->vops->clk_scale_notify)
-		return hba->vops->clk_scale_notify(hba, up, status);
-	return 0;
-}
-
-static inline void ufshcd_vops_event_notify(struct ufs_hba *hba,
-					    enum ufs_event_type evt,
-					    void *data)
-{
-	if (hba->vops && hba->vops->event_notify)
-		hba->vops->event_notify(hba, evt, data);
-}
-
-static inline int ufshcd_vops_setup_clocks(struct ufs_hba *hba, bool on,
-					enum ufs_notify_change_status status)
-{
-	if (hba->vops && hba->vops->setup_clocks)
-		return hba->vops->setup_clocks(hba, on, status);
-	return 0;
-}
-
-static inline int ufshcd_vops_hce_enable_notify(struct ufs_hba *hba,
-						bool status)
-{
-	if (hba->vops && hba->vops->hce_enable_notify)
-		return hba->vops->hce_enable_notify(hba, status);
-
-	return 0;
-}
-static inline int ufshcd_vops_link_startup_notify(struct ufs_hba *hba,
-						bool status)
-{
-	if (hba->vops && hba->vops->link_startup_notify)
-		return hba->vops->link_startup_notify(hba, status);
-
-	return 0;
-}
-
 static inline int ufshcd_vops_phy_initialization(struct ufs_hba *hba)
 {
 	if (hba->vops && hba->vops->phy_initialization)
@@ -1308,102 +1229,8 @@ static inline int ufshcd_vops_phy_initialization(struct ufs_hba *hba)
 	return 0;
 }
 
-static inline int ufshcd_vops_pwr_change_notify(struct ufs_hba *hba,
-				  enum ufs_notify_change_status status,
-				  struct ufs_pa_layer_attr *dev_max_params,
-				  struct ufs_pa_layer_attr *dev_req_params)
-{
-	if (hba->vops && hba->vops->pwr_change_notify)
-		return hba->vops->pwr_change_notify(hba, status,
-					dev_max_params, dev_req_params);
-
-	return -ENOTSUPP;
-}
-
-static inline void ufshcd_vops_setup_task_mgmt(struct ufs_hba *hba,
-					int tag, u8 tm_function)
-{
-	if (hba->vops && hba->vops->setup_task_mgmt)
-		return hba->vops->setup_task_mgmt(hba, tag, tm_function);
-}
-
-static inline void ufshcd_vops_hibern8_notify(struct ufs_hba *hba,
-					enum uic_cmd_dme cmd,
-					enum ufs_notify_change_status status)
-{
-	if (hba->vops && hba->vops->hibern8_notify)
-		return hba->vops->hibern8_notify(hba, cmd, status);
-}
-
-static inline int ufshcd_vops_apply_dev_quirks(struct ufs_hba *hba)
-{
-	if (hba->vops && hba->vops->apply_dev_quirks)
-		return hba->vops->apply_dev_quirks(hba);
-	return 0;
-}
-
-static inline void ufshcd_vops_fixup_dev_quirks(struct ufs_hba *hba)
-{
-	if (hba->vops && hba->vops->fixup_dev_quirks)
-		hba->vops->fixup_dev_quirks(hba);
-}
-
-static inline int ufshcd_vops_suspend(struct ufs_hba *hba, enum ufs_pm_op op,
-				enum ufs_notify_change_status status)
-{
-	if (hba->vops && hba->vops->suspend)
-		return hba->vops->suspend(hba, op, status);
-
-	return 0;
-}
-
-static inline int ufshcd_vops_resume(struct ufs_hba *hba, enum ufs_pm_op op)
-{
-	if (hba->vops && hba->vops->resume)
-		return hba->vops->resume(hba, op);
-
-	return 0;
-}
-
-static inline void ufshcd_vops_dbg_register_dump(struct ufs_hba *hba)
-{
-	if (hba->vops && hba->vops->dbg_register_dump)
-		hba->vops->dbg_register_dump(hba);
-}
-
-static inline int ufshcd_vops_device_reset(struct ufs_hba *hba)
-{
-	if (hba->vops && hba->vops->device_reset)
-		return hba->vops->device_reset(hba);
-
-	return -EOPNOTSUPP;
-}
-
-static inline void ufshcd_vops_config_scaling_param(struct ufs_hba *hba,
-		struct devfreq_dev_profile *p,
-		struct devfreq_simple_ondemand_data *data)
-{
-	if (hba->vops && hba->vops->config_scaling_param)
-		hba->vops->config_scaling_param(hba, p, data);
-}
-
 extern struct ufs_pm_lvl_states ufs_pm_lvl_states[];
 
-/**
- * ufshcd_scsi_to_upiu_lun - maps scsi LUN to UPIU LUN
- * @scsi_lun: scsi LUN id
- *
- * Returns UPIU LUN id
- */
-static inline u8 ufshcd_scsi_to_upiu_lun(unsigned int scsi_lun)
-{
-	if (scsi_is_wlun(scsi_lun))
-		return (scsi_lun & UFS_UPIU_MAX_UNIT_NUM_ID)
-			| UFS_UPIU_WLUN_ID;
-	else
-		return scsi_lun & UFS_UPIU_MAX_UNIT_NUM_ID;
-}
-
 int ufshcd_dump_regs(struct ufs_hba *hba, size_t offset, size_t len,
 		     const char *prefix);
 
@@ -1412,43 +1239,4 @@ int ufshcd_write_ee_control(struct ufs_hba *hba);
 int ufshcd_update_ee_control(struct ufs_hba *hba, u16 *mask, u16 *other_mask,
 			     u16 set, u16 clr);
 
-static inline int ufshcd_update_ee_drv_mask(struct ufs_hba *hba,
-					    u16 set, u16 clr)
-{
-	return ufshcd_update_ee_control(hba, &hba->ee_drv_mask,
-					&hba->ee_usr_mask, set, clr);
-}
-
-static inline int ufshcd_update_ee_usr_mask(struct ufs_hba *hba,
-					    u16 set, u16 clr)
-{
-	return ufshcd_update_ee_control(hba, &hba->ee_usr_mask,
-					&hba->ee_drv_mask, set, clr);
-}
-
-static inline int ufshcd_rpm_get_sync(struct ufs_hba *hba)
-{
-	return pm_runtime_get_sync(&hba->ufs_device_wlun->sdev_gendev);
-}
-
-static inline int ufshcd_rpm_put_sync(struct ufs_hba *hba)
-{
-	return pm_runtime_put_sync(&hba->ufs_device_wlun->sdev_gendev);
-}
-
-static inline void ufshcd_rpm_get_noresume(struct ufs_hba *hba)
-{
-	pm_runtime_get_noresume(&hba->ufs_device_wlun->sdev_gendev);
-}
-
-static inline int ufshcd_rpm_resume(struct ufs_hba *hba)
-{
-	return pm_runtime_resume(&hba->ufs_device_wlun->sdev_gendev);
-}
-
-static inline int ufshcd_rpm_put(struct ufs_hba *hba)
-{
-	return pm_runtime_put(&hba->ufs_device_wlun->sdev_gendev);
-}
-
 #endif /* End of Header */
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index d456404e5c49..daac81290f50 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -17,6 +17,7 @@
 #include "../sd.h"
 #include "ufshcd.h"
 #include "ufshpb.h"
+#include "ufshcd-priv.h"
 
 #define ACTIVATION_THRESHOLD 8 /* 8 IOs */
 #define READ_TO_MS 1000
