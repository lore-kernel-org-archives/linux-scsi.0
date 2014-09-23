From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH V4 11/17] scsi: ufs: add UFS power management support
Date: Tue, 23 Sep 2014 10:31:33 +0300
Message-ID: <1411457499-8074-12-git-send-email-draviv@codeaurora.org>
References: <1411457499-8074-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1411457499-8074-1-git-send-email-draviv@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Subhash Jadavani <subhashj@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

From: Subhash Jadavani <subhashj@codeaurora.org>

This patch adds support for UFS device and UniPro link power management
during runtime/system PM.

Main idea is to define multiple UFS low power levels based on UFS device
and UFS link power states. This would allow any specific platform or pci
driver to choose the best suited low power level during runtime and
system suspend based on their power goals.

bkops handlig:
To put the UFS device in sleep state when bkops is disabled, first query
the bkops status from the device and enable bkops on device only if
device needs time to perform the bkops.

START_STOP handling:
Before sending START_STOP_UNIT to the device well-known logical unit
(w-lun) to make sure that the device w-lun unit attention condition is
cleared.

Write protection:
UFS device specification allows LUs to be write protected, either
permanently or power on write protected. If any LU is power on write
protected and if the card is power cycled (by powering off VCCQ and/or
VCC rails), LU's write protect status would be lost. So this means those
LUs can be written now. To ensures that UFS device is power cycled only
if the power on protect is not set for any of the LUs, check if power on
write protect is set and if device is in sleep/power-off state & link in
inactive state (Hibern8 or OFF state).
If none of the Logical Units on UFS device is power on write protected
then all UFS device power rails (VCC, VCCQ & VCCQ2) can be turned off if
UFS device is in power-off state and UFS link is in OFF state. But current
implementation would disable all device power rails even if UFS link is
not in OFF state.

Low power mode:
If UFS link is in OFF state then UFS host controller can be power collapsed
to avoid leakage current from it. Note that if UFS host controller is power
collapsed, full UFS reinitialization will be required on resume to
re-establish the link between host and device.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 37d64c1..42c459a 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -129,6 +129,7 @@ enum {
 /* Flag idn for Query Requests*/
 enum flag_idn {
 	QUERY_FLAG_IDN_FDEVICEINIT      = 0x01,
+	QUERY_FLAG_IDN_PWR_ON_WPE	= 0x03,
 	QUERY_FLAG_IDN_BKOPS_EN         = 0x04,
 };
 
@@ -194,6 +195,18 @@ enum unit_desc_param {
 	UNIT_DESC_PARAM_LARGE_UNIT_SIZE_M1	= 0x22,
 };
 
+/*
+ * Logical Unit Write Protect
+ * 00h: LU not write protected
+ * 01h: LU write protected when fPowerOnWPEn =1
+ * 02h: LU permanently write protected when fPermanentWPEn =1
+ */
+enum ufs_lu_wp_type {
+	UFS_LU_NO_WP		= 0x00,
+	UFS_LU_POWER_ON_WP	= 0x01,
+	UFS_LU_PERM_WP		= 0x02,
+};
+
 /* bActiveICCLevel parameter current units */
 enum {
 	UFSHCD_NANO_AMP		= 0,
@@ -226,11 +239,12 @@ enum {
 };
 
 /* Background operation status */
-enum {
+enum bkops_status {
 	BKOPS_STATUS_NO_OP               = 0x0,
 	BKOPS_STATUS_NON_CRITICAL        = 0x1,
 	BKOPS_STATUS_PERF_IMPACT         = 0x2,
 	BKOPS_STATUS_CRITICAL            = 0x3,
+	BKOPS_STATUS_MAX		 = BKOPS_STATUS_CRITICAL,
 };
 
 /* UTP QUERY Transaction Specific Fields OpCode */
@@ -291,6 +305,14 @@ enum {
 	UPIU_TASK_MANAGEMENT_FUNC_FAILED	= 0x05,
 	UPIU_INCORRECT_LOGICAL_UNIT_NO		= 0x09,
 };
+
+/* UFS device power modes */
+enum ufs_dev_pwr_mode {
+	UFS_ACTIVE_PWR_MODE	= 1,
+	UFS_SLEEP_PWR_MODE	= 2,
+	UFS_POWERDOWN_PWR_MODE	= 3,
+};
+
 /**
  * struct utp_upiu_header - UPIU header structure
  * @dword_0: UPIU header DW-0
@@ -437,6 +459,12 @@ struct ufs_query_res {
 #define UFS_VREG_VCCQ2_MIN_UV	   1650000 /* uV */
 #define UFS_VREG_VCCQ2_MAX_UV	   1950000 /* uV */
 
+/*
+ * VCCQ & VCCQ2 current requirement when UFS device is in sleep state
+ * and link is in Hibern8 state.
+ */
+#define UFS_VREG_LPM_LOAD_UA	1000 /* uA */
+
 struct ufs_vreg {
 	struct regulator *reg;
 	const char *name;
@@ -454,4 +482,10 @@ struct ufs_vreg_info {
 	struct ufs_vreg *vdd_hba;
 };
 
+struct ufs_dev_info {
+	bool f_power_on_wp_en;
+	/* Keeps information if any of the LU is power on write protected */
+	bool is_lu_power_on_wp;
+};
+
 #endif /* End of Header */
diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index 2a26faa..955ed55 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -43,34 +43,24 @@
  * @pdev: pointer to PCI device handle
  * @state: power state
  *
- * Returns -ENOSYS
+ * Returns 0 if successful
+ * Returns non-zero otherwise
  */
 static int ufshcd_pci_suspend(struct device *dev)
 {
-	/*
-	 * TODO:
-	 * 1. Call ufshcd_suspend
-	 * 2. Do bus specific power management
-	 */
-
-	return -ENOSYS;
+	return ufshcd_system_suspend(dev_get_drvdata(dev));
 }
 
 /**
  * ufshcd_pci_resume - resume power management function
  * @pdev: pointer to PCI device handle
  *
- * Returns -ENOSYS
+ * Returns 0 if successful
+ * Returns non-zero otherwise
  */
 static int ufshcd_pci_resume(struct device *dev)
 {
-	/*
-	 * TODO:
-	 * 1. Call ufshcd_resume.
-	 * 2. Do bus specific wake up
-	 */
-
-	return -ENOSYS;
+	return ufshcd_system_resume(dev_get_drvdata(dev));
 }
 #else
 #define ufshcd_pci_suspend	NULL
@@ -80,30 +70,15 @@ static int ufshcd_pci_resume(struct device *dev)
 #ifdef CONFIG_PM_RUNTIME
 static int ufshcd_pci_runtime_suspend(struct device *dev)
 {
-	struct ufs_hba *hba = dev_get_drvdata(dev);
-
-	if (!hba)
-		return 0;
-
-	return ufshcd_runtime_suspend(hba);
+	return ufshcd_runtime_suspend(dev_get_drvdata(dev));
 }
 static int ufshcd_pci_runtime_resume(struct device *dev)
 {
-	struct ufs_hba *hba = dev_get_drvdata(dev);
-
-	if (!hba)
-		return 0;
-
-	return ufshcd_runtime_resume(hba);
+	return ufshcd_runtime_resume(dev_get_drvdata(dev));
 }
 static int ufshcd_pci_runtime_idle(struct device *dev)
 {
-	struct ufs_hba *hba = dev_get_drvdata(dev);
-
-	if (!hba)
-		return 0;
-
-	return ufshcd_runtime_idle(hba);
+	return ufshcd_runtime_idle(dev_get_drvdata(dev));
 }
 #else /* !CONFIG_PM_RUNTIME */
 #define ufshcd_pci_runtime_suspend	NULL
@@ -117,7 +92,7 @@ static int ufshcd_pci_runtime_idle(struct device *dev)
  */
 static void ufshcd_pci_shutdown(struct pci_dev *pdev)
 {
-	ufshcd_hba_stop((struct ufs_hba *)pci_get_drvdata(pdev));
+	ufshcd_shutdown((struct ufs_hba *)pci_get_drvdata(pdev));
 }
 
 /**
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index dde4e6e..2482bba 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -225,45 +225,24 @@ out:
  * ufshcd_pltfrm_suspend - suspend power management function
  * @dev: pointer to device handle
  *
- *
- * Returns 0
+ * Returns 0 if successful
+ * Returns non-zero otherwise
  */
 static int ufshcd_pltfrm_suspend(struct device *dev)
 {
-	struct platform_device *pdev = to_platform_device(dev);
-	struct ufs_hba *hba =  platform_get_drvdata(pdev);
-
-	/*
-	 * TODO:
-	 * 1. Call ufshcd_suspend
-	 * 2. Do bus specific power management
-	 */
-
-	disable_irq(hba->irq);
-
-	return 0;
+	return ufshcd_system_suspend(dev_get_drvdata(dev));
 }
 
 /**
  * ufshcd_pltfrm_resume - resume power management function
  * @dev: pointer to device handle
  *
- * Returns 0
+ * Returns 0 if successful
+ * Returns non-zero otherwise
  */
 static int ufshcd_pltfrm_resume(struct device *dev)
 {
-	struct platform_device *pdev = to_platform_device(dev);
-	struct ufs_hba *hba =  platform_get_drvdata(pdev);
-
-	/*
-	 * TODO:
-	 * 1. Call ufshcd_resume.
-	 * 2. Do bus specific wake up
-	 */
-
-	enable_irq(hba->irq);
-
-	return 0;
+	return ufshcd_system_resume(dev_get_drvdata(dev));
 }
 #else
 #define ufshcd_pltfrm_suspend	NULL
@@ -273,30 +252,15 @@ static int ufshcd_pltfrm_resume(struct device *dev)
 #ifdef CONFIG_PM_RUNTIME
 static int ufshcd_pltfrm_runtime_suspend(struct device *dev)
 {
-	struct ufs_hba *hba =  dev_get_drvdata(dev);
-
-	if (!hba)
-		return 0;
-
-	return ufshcd_runtime_suspend(hba);
+	return ufshcd_runtime_suspend(dev_get_drvdata(dev));
 }
 static int ufshcd_pltfrm_runtime_resume(struct device *dev)
 {
-	struct ufs_hba *hba =  dev_get_drvdata(dev);
-
-	if (!hba)
-		return 0;
-
-	return ufshcd_runtime_resume(hba);
+	return ufshcd_runtime_resume(dev_get_drvdata(dev));
 }
 static int ufshcd_pltfrm_runtime_idle(struct device *dev)
 {
-	struct ufs_hba *hba =  dev_get_drvdata(dev);
-
-	if (!hba)
-		return 0;
-
-	return ufshcd_runtime_idle(hba);
+	return ufshcd_runtime_idle(dev_get_drvdata(dev));
 }
 #else /* !CONFIG_PM_RUNTIME */
 #define ufshcd_pltfrm_runtime_suspend	NULL
@@ -304,6 +268,11 @@ static int ufshcd_pltfrm_runtime_idle(struct device *dev)
 #define ufshcd_pltfrm_runtime_idle	NULL
 #endif /* CONFIG_PM_RUNTIME */
 
+static void ufshcd_pltfrm_shutdown(struct platform_device *pdev)
+{
+	ufshcd_shutdown((struct ufs_hba *)platform_get_drvdata(pdev));
+}
+
 /**
  * ufshcd_pltfrm_probe - probe routine of the driver
  * @pdev: pointer to Platform device handle
@@ -404,6 +373,7 @@ static const struct dev_pm_ops ufshcd_dev_pm_ops = {
 static struct platform_driver ufshcd_pltfrm_driver = {
 	.probe	= ufshcd_pltfrm_probe,
 	.remove	= ufshcd_pltfrm_remove,
+	.shutdown = ufshcd_pltfrm_shutdown,
 	.driver	= {
 		.name	= "ufshcd",
 		.owner	= THIS_MODULE,
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index de41630..a621827 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -44,7 +44,6 @@
 
 #define UFSHCD_ENABLE_INTRS	(UTP_TRANSFER_REQ_COMPL |\
 				 UTP_TASK_REQ_COMPL |\
-				 UIC_POWER_MODE |\
 				 UFSHCD_ERROR_MASK)
 /* UIC command timeout, unit: ms */
 #define UIC_CMD_TIMEOUT	500
@@ -138,12 +137,72 @@ enum {
 #define ufshcd_clear_eh_in_progress(h) \
 	(h->eh_flags &= ~UFSHCD_EH_IN_PROGRESS)
 
+#define ufshcd_set_ufs_dev_active(h) \
+	((h)->curr_dev_pwr_mode = UFS_ACTIVE_PWR_MODE)
+#define ufshcd_set_ufs_dev_sleep(h) \
+	((h)->curr_dev_pwr_mode = UFS_SLEEP_PWR_MODE)
+#define ufshcd_set_ufs_dev_poweroff(h) \
+	((h)->curr_dev_pwr_mode = UFS_POWERDOWN_PWR_MODE)
+#define ufshcd_is_ufs_dev_active(h) \
+	((h)->curr_dev_pwr_mode == UFS_ACTIVE_PWR_MODE)
+#define ufshcd_is_ufs_dev_sleep(h) \
+	((h)->curr_dev_pwr_mode == UFS_SLEEP_PWR_MODE)
+#define ufshcd_is_ufs_dev_poweroff(h) \
+	((h)->curr_dev_pwr_mode == UFS_POWERDOWN_PWR_MODE)
+
+static struct ufs_pm_lvl_states ufs_pm_lvl_states[] = {
+	{UFS_ACTIVE_PWR_MODE, UIC_LINK_ACTIVE_STATE},
+	{UFS_ACTIVE_PWR_MODE, UIC_LINK_HIBERN8_STATE},
+	{UFS_SLEEP_PWR_MODE, UIC_LINK_ACTIVE_STATE},
+	{UFS_SLEEP_PWR_MODE, UIC_LINK_HIBERN8_STATE},
+	{UFS_POWERDOWN_PWR_MODE, UIC_LINK_HIBERN8_STATE},
+	{UFS_POWERDOWN_PWR_MODE, UIC_LINK_OFF_STATE},
+};
+
+static inline enum ufs_dev_pwr_mode
+ufs_get_pm_lvl_to_dev_pwr_mode(enum ufs_pm_level lvl)
+{
+	return ufs_pm_lvl_states[lvl].dev_state;
+}
+
+static inline enum uic_link_state
+ufs_get_pm_lvl_to_link_pwr_state(enum ufs_pm_level lvl)
+{
+	return ufs_pm_lvl_states[lvl].link_state;
+}
+
 static void ufshcd_tmc_handler(struct ufs_hba *hba);
 static void ufshcd_async_scan(void *data, async_cookie_t cookie);
 static int ufshcd_reset_and_restore(struct ufs_hba *hba);
 static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag);
 static void ufshcd_hba_exit(struct ufs_hba *hba);
 static int ufshcd_probe_hba(struct ufs_hba *hba);
+static int ufshcd_host_reset_and_restore(struct ufs_hba *hba);
+static irqreturn_t ufshcd_intr(int irq, void *__hba);
+
+static inline int ufshcd_enable_irq(struct ufs_hba *hba)
+{
+	int ret = 0;
+
+	if (!hba->is_irq_enabled) {
+		ret = request_irq(hba->irq, ufshcd_intr, IRQF_SHARED, UFSHCD,
+				hba);
+		if (ret)
+			dev_err(hba->dev, "%s: request_irq failed, ret=%d\n",
+				__func__, ret);
+		hba->is_irq_enabled = true;
+	}
+
+	return ret;
+}
+
+static inline void ufshcd_disable_irq(struct ufs_hba *hba)
+{
+	if (hba->is_irq_enabled) {
+		free_irq(hba->irq, hba);
+		hba->is_irq_enabled = false;
+	}
+}
 
 /*
  * ufshcd_wait_for_register - wait for register value to change
@@ -1789,44 +1848,54 @@ out:
 EXPORT_SYMBOL_GPL(ufshcd_dme_get_attr);
 
 /**
- * ufshcd_uic_change_pwr_mode - Perform the UIC power mode chage
- *				using DME_SET primitives.
+ * ufshcd_uic_pwr_ctrl - executes UIC commands (which affects the link power
+ * state) and waits for it to take effect.
+ *
  * @hba: per adapter instance
- * @mode: powr mode value
+ * @cmd: UIC command to execute
+ *
+ * DME operations like DME_SET(PA_PWRMODE), DME_HIBERNATE_ENTER &
+ * DME_HIBERNATE_EXIT commands take some time to take its effect on both host
+ * and device UniPro link and hence it's final completion would be indicated by
+ * dedicated status bits in Interrupt Status register (UPMS, UHES, UHXS) in
+ * addition to normal UIC command completion Status (UCCS). This function only
+ * returns after the relevant status bits indicate the completion.
  *
  * Returns 0 on success, non-zero value on failure
  */
-static int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba, u8 mode)
+int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 {
-	struct uic_command uic_cmd = {0};
-	struct completion pwr_done;
+	struct completion uic_async_done;
 	unsigned long flags;
 	u8 status;
 	int ret;
 
-	uic_cmd.command = UIC_CMD_DME_SET;
-	uic_cmd.argument1 = UIC_ARG_MIB(PA_PWRMODE);
-	uic_cmd.argument3 = mode;
-	init_completion(&pwr_done);
-
 	mutex_lock(&hba->uic_cmd_mutex);
+	init_completion(&uic_async_done);
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	hba->pwr_done = &pwr_done;
+	hba->uic_async_done = &uic_async_done;
+	ret = __ufshcd_send_uic_cmd(hba, cmd);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
-	ret = __ufshcd_send_uic_cmd(hba, &uic_cmd);
 	if (ret) {
 		dev_err(hba->dev,
-			"pwr mode change with mode 0x%x uic error %d\n",
-			mode, ret);
+			"pwr ctrl cmd 0x%x with mode 0x%x uic error %d\n",
+			cmd->command, cmd->argument3, ret);
+		goto out;
+	}
+	ret = ufshcd_wait_for_uic_cmd(hba, cmd);
+	if (ret) {
+		dev_err(hba->dev,
+			"pwr ctrl cmd 0x%x with mode 0x%x uic error %d\n",
+			cmd->command, cmd->argument3, ret);
 		goto out;
 	}
 
-	if (!wait_for_completion_timeout(hba->pwr_done,
+	if (!wait_for_completion_timeout(hba->uic_async_done,
 					 msecs_to_jiffies(UIC_CMD_TIMEOUT))) {
 		dev_err(hba->dev,
-			"pwr mode change with mode 0x%x completion timeout\n",
-			mode);
+			"pwr ctrl cmd 0x%x with mode 0x%x completion timeout\n",
+			cmd->command, cmd->argument3);
 		ret = -ETIMEDOUT;
 		goto out;
 	}
@@ -1834,19 +1903,62 @@ static int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba, u8 mode)
 	status = ufshcd_get_upmcrs(hba);
 	if (status != PWR_LOCAL) {
 		dev_err(hba->dev,
-			"pwr mode change failed, host umpcrs:0x%x\n",
-			status);
+			"pwr ctrl cmd 0x%0x failed, host umpcrs:0x%x\n",
+			cmd->command, status);
 		ret = (status != PWR_OK) ? status : -1;
 	}
 out:
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	hba->pwr_done = NULL;
+	hba->uic_async_done = NULL;
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	mutex_unlock(&hba->uic_cmd_mutex);
 	return ret;
 }
 
 /**
+ * ufshcd_uic_change_pwr_mode - Perform the UIC power mode chage
+ *				using DME_SET primitives.
+ * @hba: per adapter instance
+ * @mode: powr mode value
+ *
+ * Returns 0 on success, non-zero value on failure
+ */
+static int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba, u8 mode)
+{
+	struct uic_command uic_cmd = {0};
+
+	uic_cmd.command = UIC_CMD_DME_SET;
+	uic_cmd.argument1 = UIC_ARG_MIB(PA_PWRMODE);
+	uic_cmd.argument3 = mode;
+
+	return ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
+}
+
+static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
+{
+	struct uic_command uic_cmd = {0};
+
+	uic_cmd.command = UIC_CMD_DME_HIBER_ENTER;
+
+	return ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
+}
+
+static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
+{
+	struct uic_command uic_cmd = {0};
+	int ret;
+
+	uic_cmd.command = UIC_CMD_DME_HIBER_EXIT;
+	ret = ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
+	if (ret) {
+		ufshcd_set_link_off(hba);
+		ret = ufshcd_host_reset_and_restore(hba);
+	}
+
+	return ret;
+}
+
+/**
  * ufshcd_config_max_pwr_mode - Set & Change power mode with
  *	maximum capability attribute information.
  * @hba: per adapter instance
@@ -2045,6 +2157,9 @@ static int ufshcd_hba_enable(struct ufs_hba *hba)
 		msleep(5);
 	}
 
+	/* UniPro link is disabled at this point */
+	ufshcd_set_link_off(hba);
+
 	if (hba->vops && hba->vops->hce_enable_notify)
 		hba->vops->hce_enable_notify(hba, PRE_CHANGE);
 
@@ -2077,7 +2192,7 @@ static int ufshcd_hba_enable(struct ufs_hba *hba)
 	}
 
 	/* enable UIC related interrupts */
-	ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
+	ufshcd_enable_intr(hba, UFSHCD_UIC_MASK);
 
 	if (hba->vops && hba->vops->hce_enable_notify)
 		hba->vops->hce_enable_notify(hba, POST_CHANGE);
@@ -2206,6 +2321,62 @@ static void ufshcd_set_queue_depth(struct scsi_device *sdev)
 	scsi_activate_tcq(sdev, lun_qdepth);
 }
 
+/*
+ * ufshcd_get_lu_wp - returns the "b_lu_write_protect" from UNIT DESCRIPTOR
+ * @hba: per-adapter instance
+ * @lun: UFS device lun id
+ * @b_lu_write_protect: pointer to buffer to hold the LU's write protect info
+ *
+ * Returns 0 in case of success and b_lu_write_protect status would be returned
+ * @b_lu_write_protect parameter.
+ * Returns -ENOTSUPP if reading b_lu_write_protect is not supported.
+ * Returns -EINVAL in case of invalid parameters passed to this function.
+ */
+static int ufshcd_get_lu_wp(struct ufs_hba *hba,
+			    u8 lun,
+			    u8 *b_lu_write_protect)
+{
+	int ret;
+
+	if (!b_lu_write_protect)
+		ret = -EINVAL;
+	/*
+	 * According to UFS device spec, RPMB LU can't be write
+	 * protected so skip reading bLUWriteProtect parameter for
+	 * it. For other W-LUs, UNIT DESCRIPTOR is not available.
+	 */
+	else if (lun >= UFS_UPIU_MAX_GENERAL_LUN)
+		ret = -ENOTSUPP;
+	else
+		ret = ufshcd_read_unit_desc_param(hba,
+					  lun,
+					  UNIT_DESC_PARAM_LU_WR_PROTECT,
+					  b_lu_write_protect,
+					  sizeof(*b_lu_write_protect));
+	return ret;
+}
+
+/**
+ * ufshcd_get_lu_power_on_wp_status - get LU's power on write protect
+ * status
+ * @hba: per-adapter instance
+ * @sdev: pointer to SCSI device
+ *
+ */
+static inline void ufshcd_get_lu_power_on_wp_status(struct ufs_hba *hba,
+						    struct scsi_device *sdev)
+{
+	if (hba->dev_info.f_power_on_wp_en &&
+	    !hba->dev_info.is_lu_power_on_wp) {
+		u8 b_lu_write_protect;
+
+		if (!ufshcd_get_lu_wp(hba, ufshcd_scsi_to_upiu_lun(sdev->lun),
+				      &b_lu_write_protect) &&
+		    (b_lu_write_protect == UFS_LU_POWER_ON_WP))
+			hba->dev_info.is_lu_power_on_wp = true;
+	}
+}
+
 /**
  * ufshcd_slave_alloc - handle initial SCSI device configurations
  * @sdev: pointer to SCSI device
@@ -2232,6 +2403,21 @@ static int ufshcd_slave_alloc(struct scsi_device *sdev)
 
 	ufshcd_set_queue_depth(sdev);
 
+	ufshcd_get_lu_power_on_wp_status(hba, sdev);
+
+	/*
+	 * For selecting the UFS device power mode (Active / UFS_Sleep /
+	 * UFS_PowerDown), SCSI power management command (START STOP UNIT)
+	 * needs to be sent to a "UFS device" Well known Logical Unit (W-LU).
+	 * As this command would be sent during the UFS host controller
+	 * runtime/system PM callbacks, we need a reference to "scsi_device"
+	 * associated to "UFS device" W-LU. This change saves the "scsi_device"
+	 * reference for "UFS device" W-LU during slave_configure() callback
+	 * from SCSI mid layer.
+	 */
+	if (ufshcd_scsi_to_upiu_lun(sdev->lun) == UFS_UPIU_UFS_DEVICE_WLUN)
+		hba->sdev_ufs_device = sdev;
+
 	return 0;
 }
 
@@ -2462,8 +2648,8 @@ static void ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
 		complete(&hba->active_uic_cmd->done);
 	}
 
-	if ((intr_status & UIC_POWER_MODE) && hba->pwr_done)
-		complete(hba->pwr_done);
+	if ((intr_status & UFSHCD_UIC_PWR_MASK) && hba->uic_async_done)
+		complete(hba->uic_async_done);
 }
 
 /**
@@ -2675,33 +2861,62 @@ static inline int ufshcd_get_bkops_status(struct ufs_hba *hba, u32 *status)
 }
 
 /**
- * ufshcd_urgent_bkops - handle urgent bkops exception event
+ * ufshcd_bkops_ctrl - control the auto bkops based on current bkops status
  * @hba: per-adapter instance
+ * @status: bkops_status value
  *
- * Enable fBackgroundOpsEn flag in the device to permit background
- * operations.
+ * Read the bkops_status from the UFS device and Enable fBackgroundOpsEn
+ * flag in the device to permit background operations if the device
+ * bkops_status is greater than or equal to "status" argument passed to
+ * this function, disable otherwise.
+ *
+ * Returns 0 for success, non-zero in case of failure.
+ *
+ * NOTE: Caller of this function can check the "hba->auto_bkops_enabled" flag
+ * to know whether auto bkops is enabled or disabled after this function
+ * returns control to it.
  */
-static int ufshcd_urgent_bkops(struct ufs_hba *hba)
+static int ufshcd_bkops_ctrl(struct ufs_hba *hba,
+			     enum bkops_status status)
 {
 	int err;
-	u32 status = 0;
+	u32 curr_status = 0;
 
-	err = ufshcd_get_bkops_status(hba, &status);
+	err = ufshcd_get_bkops_status(hba, &curr_status);
 	if (err) {
 		dev_err(hba->dev, "%s: failed to get BKOPS status %d\n",
 				__func__, err);
 		goto out;
+	} else if (curr_status > BKOPS_STATUS_MAX) {
+		dev_err(hba->dev, "%s: invalid BKOPS status %d\n",
+				__func__, curr_status);
+		err = -EINVAL;
+		goto out;
 	}
 
-	status = status & 0xF;
-
-	/* handle only if status indicates performance impact or critical */
-	if (status >= BKOPS_STATUS_PERF_IMPACT)
+	if (curr_status >= status)
 		err = ufshcd_enable_auto_bkops(hba);
+	else
+		err = ufshcd_disable_auto_bkops(hba);
 out:
 	return err;
 }
 
+/**
+ * ufshcd_urgent_bkops - handle urgent bkops exception event
+ * @hba: per-adapter instance
+ *
+ * Enable fBackgroundOpsEn flag in the device to permit background
+ * operations.
+ *
+ * If BKOPs is enabled, this function returns 0, 1 if the bkops in not enabled
+ * and negative error value for any other failure.
+ */
+static int ufshcd_urgent_bkops(struct ufs_hba *hba)
+{
+	return ufshcd_bkops_ctrl(hba, BKOPS_STATUS_PERF_IMPACT);
+}
+
 static inline int ufshcd_get_ee_status(struct ufs_hba *hba, u32 *status)
 {
 	return ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
@@ -2733,7 +2948,7 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
 	status &= hba->ee_ctrl_mask;
 	if (status & MASK_EE_URGENT_BKOPS) {
 		err = ufshcd_urgent_bkops(hba);
-		if (err)
+		if (err < 0)
 			dev_err(hba->dev, "%s: failed to handle urgent bkops %d\n",
 					__func__, err);
 	}
@@ -3452,7 +3667,8 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 	if (ret)
 		goto out;
 
-	ufshcd_config_max_pwr_mode(hba);
+	/* UniPro link is active now */
+	ufshcd_set_link_active(hba);
 
 	ret = ufshcd_verify_dev_init(hba);
 	if (ret)
@@ -3462,11 +3678,27 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 	if (ret)
 		goto out;
 
+	/* UFS device is also active now */
+	ufshcd_set_ufs_dev_active(hba);
 	ufshcd_force_reset_auto_bkops(hba);
 	hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
+	hba->wlun_dev_clr_ua = true;
+
+	ufshcd_config_max_pwr_mode(hba);
+
+	/*
+	 * If we are in error handling context or in power management callbacks
+	 * context, no need to scan the host
+	 */
+	if (!ufshcd_eh_in_progress(hba) && !hba->pm_op_in_progress) {
+		bool flag;
+
+		/* clear any previous UFS device information */
+		memset(&hba->dev_info, 0, sizeof(hba->dev_info));
+		if (!ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_READ_FLAG,
+				       QUERY_FLAG_IDN_PWR_ON_WPE, &flag))
+			hba->dev_info.f_power_on_wp_en = flag;
 
-	/* If we are in error handling context no need to scan the host */
-	if (!ufshcd_eh_in_progress(hba)) {
 		if (!hba->is_init_prefetch)
 			ufshcd_init_icc_levels(hba);
 
@@ -3491,8 +3723,10 @@ out:
 	 * If we failed to initialize the device or the device is not
 	 * present, turn off the power/clocks etc.
 	 */
-	if (ret && !ufshcd_eh_in_progress(hba))
+	if (ret && !ufshcd_eh_in_progress(hba) && !hba->pm_op_in_progress) {
+		pm_runtime_put_sync(hba->dev);
 		ufshcd_hba_exit(hba);
+	}
 
 	return ret;
 }
@@ -3527,6 +3761,42 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.can_queue		= UFSHCD_CAN_QUEUE,
 };
 
+static int ufshcd_config_vreg_load(struct device *dev, struct ufs_vreg *vreg,
+				   int ua)
+{
+	int ret = 0;
+	struct regulator *reg = vreg->reg;
+	const char *name = vreg->name;
+
+	BUG_ON(!vreg);
+
+	ret = regulator_set_optimum_mode(reg, ua);
+	if (ret >= 0) {
+		/*
+		 * regulator_set_optimum_mode() returns new regulator
+		 * mode upon success.
+		 */
+		ret = 0;
+	} else {
+		dev_err(dev, "%s: %s set optimum mode(ua=%d) failed, err=%d\n",
+				__func__, name, ua, ret);
+	}
+
+	return ret;
+}
+
+static inline int ufshcd_config_vreg_lpm(struct ufs_hba *hba,
+					 struct ufs_vreg *vreg)
+{
+	return ufshcd_config_vreg_load(hba->dev, vreg, UFS_VREG_LPM_LOAD_UA);
+}
+
+static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
+					 struct ufs_vreg *vreg)
+{
+	return ufshcd_config_vreg_load(hba->dev, vreg, vreg->max_uA);
+}
+
 static int ufshcd_config_vreg(struct device *dev,
 		struct ufs_vreg *vreg, bool on)
 {
@@ -3547,18 +3817,9 @@ static int ufshcd_config_vreg(struct device *dev,
 		}
 
 		uA_load = on ? vreg->max_uA : 0;
-		ret = regulator_set_optimum_mode(reg, uA_load);
-		if (ret >= 0) {
-			/*
-			 * regulator_set_optimum_mode() returns new regulator
-			 * mode upon success.
-			 */
-			ret = 0;
-		} else {
-			dev_err(dev, "%s: %s set optimum mode(uA_load=%d) failed, err=%d\n",
-					__func__, name, uA_load, ret);
+		ret = ufshcd_config_vreg_load(dev, vreg, uA_load);
+		if (ret)
 			goto out;
-		}
 	}
 out:
 	return ret;
@@ -3694,7 +3955,8 @@ static int ufshcd_init_hba_vreg(struct ufs_hba *hba)
 	return 0;
 }
 
-static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on)
+static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
+					bool skip_ref_clk)
 {
 	int ret = 0;
 	struct ufs_clk_info *clki;
@@ -3705,6 +3967,9 @@ static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on)
 
 	list_for_each_entry(clki, head, list) {
 		if (!IS_ERR_OR_NULL(clki->clk)) {
+			if (skip_ref_clk && !strcmp(clki->name, "ref_clk"))
+				continue;
+
 			if (on && !clki->enabled) {
 				ret = clk_prepare_enable(clki->clk);
 				if (ret) {
@@ -3730,6 +3995,11 @@ out:
 	return ret;
 }
 
+static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on)
+{
+	return  __ufshcd_setup_clocks(hba, on, false);
+}
+
 static int ufshcd_init_clocks(struct ufs_hba *hba)
 {
 	int ret = 0;
@@ -3886,68 +4156,532 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
 	}
 }
 
+static int
+ufshcd_send_request_sense(struct ufs_hba *hba, struct scsi_device *sdp)
+{
+	unsigned char cmd[6] = {REQUEST_SENSE,
+				0,
+				0,
+				0,
+				SCSI_SENSE_BUFFERSIZE,
+				0};
+	char *buffer;
+	int ret;
+
+	buffer = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
+	if (!buffer) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = scsi_execute_req_flags(sdp, cmd, DMA_FROM_DEVICE, buffer,
+				SCSI_SENSE_BUFFERSIZE, NULL,
+				msecs_to_jiffies(1000), 3, NULL, REQ_PM);
+	if (ret)
+		pr_err("%s: failed with err %d\n", __func__, ret);
+
+	kfree(buffer);
+out:
+	return ret;
+}
+
 /**
- * ufshcd_suspend - suspend power management function
+ * ufshcd_set_dev_pwr_mode - sends START STOP UNIT command to set device
+ *			     power mode
  * @hba: per adapter instance
- * @state: power state
+ * @pwr_mode: device power mode to set
  *
- * Returns -ENOSYS
+ * Returns 0 if requested power mode is set successfully
+ * Returns non-zero if failed to set the requested power mode
  */
-int ufshcd_suspend(struct ufs_hba *hba, pm_message_t state)
+static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
+				     enum ufs_dev_pwr_mode pwr_mode)
 {
+	unsigned char cmd[6] = { START_STOP };
+	struct scsi_sense_hdr sshdr;
+	struct scsi_device *sdp = hba->sdev_ufs_device;
+	int ret;
+
+	if (!sdp || !scsi_device_online(sdp))
+		return -ENODEV;
+
 	/*
-	 * TODO:
-	 * 1. Block SCSI requests from SCSI midlayer
-	 * 2. Change the internal driver state to non operational
-	 * 3. Set UTRLRSR and UTMRLRSR bits to zero
-	 * 4. Wait until outstanding commands are completed
-	 * 5. Set HCE to zero to send the UFS host controller to reset state
+	 * If scsi commands fail, the scsi mid-layer schedules scsi error-
+	 * handling, which would wait for host to be resumed. Since we know
+	 * we are functional while we are here, skip host resume in error
+	 * handling context.
 	 */
+	hba->host->eh_noresume = 1;
+	if (hba->wlun_dev_clr_ua) {
+		ret = ufshcd_send_request_sense(hba, sdp);
+		if (ret)
+			goto out;
+		/* Unit attention condition is cleared now */
+		hba->wlun_dev_clr_ua = false;
+	}
+
+	cmd[4] = pwr_mode << 4;
 
-	return -ENOSYS;
+	/*
+	 * Current function would be generally called from the power management
+	 * callbacks hence set the REQ_PM flag so that it doesn't resume the
+	 * already suspended childs.
+	 */
+	ret = scsi_execute_req_flags(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
+				     START_STOP_TIMEOUT, 0, NULL, REQ_PM);
+	if (ret) {
+		sdev_printk(KERN_WARNING, sdp,
+			  "START_STOP failed for power mode: %d\n", pwr_mode);
+		scsi_show_result(ret);
+		if (driver_byte(ret) & DRIVER_SENSE) {
+			scsi_show_sense_hdr(&sshdr);
+			scsi_show_extd_sense(sshdr.asc, sshdr.ascq);
+		}
+	}
+
+	if (!ret)
+		hba->curr_dev_pwr_mode = pwr_mode;
+out:
+	hba->host->eh_noresume = 0;
+	return ret;
+}
+
+static int ufshcd_link_state_transition(struct ufs_hba *hba,
+					enum uic_link_state req_link_state,
+					int check_for_bkops)
+{
+	int ret = 0;
+
+	if (req_link_state == hba->uic_link_state)
+		return 0;
+
+	if (req_link_state == UIC_LINK_HIBERN8_STATE) {
+		ret = ufshcd_uic_hibern8_enter(hba);
+		if (!ret)
+			ufshcd_set_link_hibern8(hba);
+		else
+			goto out;
+	}
+	/*
+	 * If autobkops is enabled, link can't be turned off because
+	 * turning off the link would also turn off the device.
+	 */
+	else if ((req_link_state == UIC_LINK_OFF_STATE) &&
+		   (!check_for_bkops || (check_for_bkops &&
+		    !hba->auto_bkops_enabled))) {
+		/*
+		 * Change controller state to "reset state" which
+		 * should also put the link in off/reset state
+		 */
+		ufshcd_hba_stop(hba);
+		/*
+		 * TODO: Check if we need any delay to make sure that
+		 * controller is reset
+		 */
+		ufshcd_set_link_off(hba);
+	}
+
+out:
+	return ret;
+}
+
+static void ufshcd_vreg_set_lpm(struct ufs_hba *hba)
+{
+	/*
+	 * If UFS device is either in UFS_Sleep turn off VCC rail to save some
+	 * power.
+	 *
+	 * If UFS device and link is in OFF state, all power supplies (VCC,
+	 * VCCQ, VCCQ2) can be turned off if power on write protect is not
+	 * required. If UFS link is inactive (Hibern8 or OFF state) and device
+	 * is in sleep state, put VCCQ & VCCQ2 rails in LPM mode.
+	 *
+	 * Ignore the error returned by ufshcd_toggle_vreg() as device is anyway
+	 * in low power state which would save some power.
+	 */
+	if (ufshcd_is_ufs_dev_poweroff(hba) && ufshcd_is_link_off(hba) &&
+	    !hba->dev_info.is_lu_power_on_wp) {
+		ufshcd_setup_vreg(hba, false);
+	} else if (!ufshcd_is_ufs_dev_active(hba)) {
+		ufshcd_toggle_vreg(hba->dev, hba->vreg_info.vcc, false);
+		if (!ufshcd_is_link_active(hba)) {
+			ufshcd_config_vreg_lpm(hba, hba->vreg_info.vccq);
+			ufshcd_config_vreg_lpm(hba, hba->vreg_info.vccq2);
+		}
+	}
+}
+
+static int ufshcd_vreg_set_hpm(struct ufs_hba *hba)
+{
+	int ret = 0;
+
+	if (ufshcd_is_ufs_dev_poweroff(hba) && ufshcd_is_link_off(hba) &&
+	    !hba->dev_info.is_lu_power_on_wp) {
+		ret = ufshcd_setup_vreg(hba, true);
+	} else if (!ufshcd_is_ufs_dev_active(hba)) {
+		ret = ufshcd_toggle_vreg(hba->dev, hba->vreg_info.vcc, true);
+		if (!ret && !ufshcd_is_link_active(hba)) {
+			ret = ufshcd_config_vreg_hpm(hba, hba->vreg_info.vccq);
+			if (ret)
+				goto vcc_disable;
+			ret = ufshcd_config_vreg_hpm(hba, hba->vreg_info.vccq2);
+			if (ret)
+				goto vccq_lpm;
+		}
+	}
+	goto out;
+
+vccq_lpm:
+	ufshcd_config_vreg_lpm(hba, hba->vreg_info.vccq);
+vcc_disable:
+	ufshcd_toggle_vreg(hba->dev, hba->vreg_info.vcc, false);
+out:
+	return ret;
+}
+
+static void ufshcd_hba_vreg_set_lpm(struct ufs_hba *hba)
+{
+	if (ufshcd_is_link_off(hba))
+		ufshcd_setup_hba_vreg(hba, false);
+}
+
+static void ufshcd_hba_vreg_set_hpm(struct ufs_hba *hba)
+{
+	if (ufshcd_is_link_off(hba))
+		ufshcd_setup_hba_vreg(hba, true);
 }
-EXPORT_SYMBOL_GPL(ufshcd_suspend);
 
 /**
- * ufshcd_resume - resume power management function
+ * ufshcd_suspend - helper function for suspend operations
  * @hba: per adapter instance
+ * @pm_op: desired low power operation type
+ *
+ * This function will try to put the UFS device and link into low power
+ * mode based on the "rpm_lvl" (Runtime PM level) or "spm_lvl"
+ * (System PM level).
+ *
+ * If this function is called during shutdown, it will make sure that
+ * both UFS device and UFS link is powered off.
  *
- * Returns -ENOSYS
+ * NOTE: UFS device & link must be active before we enter in this function.
+ *
+ * Returns 0 for success and non-zero for failure
  */
-int ufshcd_resume(struct ufs_hba *hba)
+static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 {
+	int ret = 0;
+	enum ufs_pm_level pm_lvl;
+	enum ufs_dev_pwr_mode req_dev_pwr_mode;
+	enum uic_link_state req_link_state;
+
+	hba->pm_op_in_progress = 1;
+	if (!ufshcd_is_shutdown_pm(pm_op)) {
+		pm_lvl = ufshcd_is_runtime_pm(pm_op) ?
+			 hba->rpm_lvl : hba->spm_lvl;
+		req_dev_pwr_mode = ufs_get_pm_lvl_to_dev_pwr_mode(pm_lvl);
+		req_link_state = ufs_get_pm_lvl_to_link_pwr_state(pm_lvl);
+	} else {
+		req_dev_pwr_mode = UFS_POWERDOWN_PWR_MODE;
+		req_link_state = UIC_LINK_OFF_STATE;
+	}
+
+	/*
+	 * If we can't transition into any of the low power modes
+	 * just gate the clocks.
+	 */
+	if (req_dev_pwr_mode == UFS_ACTIVE_PWR_MODE &&
+			req_link_state == UIC_LINK_ACTIVE_STATE) {
+		goto disable_clks;
+	}
+
+	if ((req_dev_pwr_mode == hba->curr_dev_pwr_mode) &&
+	    (req_link_state == hba->uic_link_state))
+		goto out;
+
+	/* UFS device & link must be active before we enter in this function */
+	if (!ufshcd_is_ufs_dev_active(hba) || !ufshcd_is_link_active(hba)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (ufshcd_is_runtime_pm(pm_op)) {
+		/*
+		 * The device is idle with no requests in the queue,
+		 * allow background operations if needed.
+		 */
+		ret = ufshcd_bkops_ctrl(hba, BKOPS_STATUS_NON_CRITICAL);
+		if (ret)
+			goto out;
+	}
+
+	if ((req_dev_pwr_mode != hba->curr_dev_pwr_mode) &&
+	     ((ufshcd_is_runtime_pm(pm_op) && !hba->auto_bkops_enabled) ||
+	       !ufshcd_is_runtime_pm(pm_op))) {
+		/* ensure that bkops is disabled */
+		ufshcd_disable_auto_bkops(hba);
+		ret = ufshcd_set_dev_pwr_mode(hba, req_dev_pwr_mode);
+		if (ret)
+			goto out;
+	}
+
+	ret = ufshcd_link_state_transition(hba, req_link_state, 1);
+	if (ret)
+		goto set_dev_active;
+
+	ufshcd_vreg_set_lpm(hba);
+
+disable_clks:
+	/*
+	 * Call vendor specific suspend callback. As these callbacks may access
+	 * vendor specific host controller register space call them before the
+	 * host clocks are ON.
+	 */
+	if (hba->vops && hba->vops->suspend) {
+		ret = hba->vops->suspend(hba, pm_op);
+		if (ret)
+			goto set_link_active;
+	}
+
+	if (hba->vops && hba->vops->setup_clocks) {
+		ret = hba->vops->setup_clocks(hba, false);
+		if (ret)
+			goto vops_resume;
+	}
+
+	if (!ufshcd_is_link_active(hba))
+		ufshcd_setup_clocks(hba, false);
+	else
+		/* If link is active, device ref_clk can't be switched off */
+		__ufshcd_setup_clocks(hba, false, true);
+
 	/*
-	 * TODO:
-	 * 1. Set HCE to 1, to start the UFS host controller
-	 * initialization process
-	 * 2. Set UTRLRSR and UTMRLRSR bits to 1
-	 * 3. Change the internal driver state to operational
-	 * 4. Unblock SCSI requests from SCSI midlayer
+	 * Disable the host irq as host controller as there won't be any
+	 * host controller trasanction expected till resume.
 	 */
+	ufshcd_disable_irq(hba);
+	/* Put the host controller in low power mode if possible */
+	ufshcd_hba_vreg_set_lpm(hba);
+	goto out;
 
-	return -ENOSYS;
+vops_resume:
+	if (hba->vops && hba->vops->resume)
+		hba->vops->resume(hba, pm_op);
+set_link_active:
+	ufshcd_vreg_set_hpm(hba);
+	if (ufshcd_is_link_hibern8(hba) && !ufshcd_uic_hibern8_exit(hba))
+		ufshcd_set_link_active(hba);
+	else if (ufshcd_is_link_off(hba))
+		ufshcd_host_reset_and_restore(hba);
+set_dev_active:
+	if (!ufshcd_set_dev_pwr_mode(hba, UFS_ACTIVE_PWR_MODE))
+		ufshcd_disable_auto_bkops(hba);
+out:
+	hba->pm_op_in_progress = 0;
+	return ret;
 }
-EXPORT_SYMBOL_GPL(ufshcd_resume);
 
-int ufshcd_runtime_suspend(struct ufs_hba *hba)
+/**
+ * ufshcd_resume - helper function for resume operations
+ * @hba: per adapter instance
+ * @pm_op: runtime PM or system PM
+ *
+ * This function basically brings the UFS device, UniPro link and controller
+ * to active state.
+ *
+ * Returns 0 for success and non-zero for failure
+ */
+static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 {
-	if (!hba)
-		return 0;
+	int ret;
+	enum uic_link_state old_link_state;
+
+	hba->pm_op_in_progress = 1;
+	old_link_state = hba->uic_link_state;
+
+	ufshcd_hba_vreg_set_hpm(hba);
+	/* Make sure clocks are enabled before accessing controller */
+	ret = ufshcd_setup_clocks(hba, true);
+	if (ret)
+		goto out;
+
+	if (hba->vops && hba->vops->setup_clocks) {
+		ret = hba->vops->setup_clocks(hba, true);
+		if (ret)
+			goto disable_clks;
+	}
+
+	/* enable the host irq as host controller would be active soon */
+	ret = ufshcd_enable_irq(hba);
+	if (ret)
+		goto disable_irq_and_vops_clks;
+
+	ret = ufshcd_vreg_set_hpm(hba);
+	if (ret)
+		goto disable_irq_and_vops_clks;
 
 	/*
-	 * The device is idle with no requests in the queue,
-	 * allow background operations.
+	 * Call vendor specific resume callback. As these callbacks may access
+	 * vendor specific host controller register space call them when the
+	 * host clocks are ON.
 	 */
-	return ufshcd_enable_auto_bkops(hba);
+	if (hba->vops && hba->vops->resume) {
+		ret = hba->vops->resume(hba, pm_op);
+		if (ret)
+			goto disable_vreg;
+	}
+
+	if (ufshcd_is_link_hibern8(hba)) {
+		ret = ufshcd_uic_hibern8_exit(hba);
+		if (!ret)
+			ufshcd_set_link_active(hba);
+		else
+			goto vendor_suspend;
+	} else if (ufshcd_is_link_off(hba)) {
+		ret = ufshcd_host_reset_and_restore(hba);
+		/*
+		 * ufshcd_host_reset_and_restore() should have already
+		 * set the link state as active
+		 */
+		if (ret || !ufshcd_is_link_active(hba))
+			goto vendor_suspend;
+	}
+
+	if (!ufshcd_is_ufs_dev_active(hba)) {
+		ret = ufshcd_set_dev_pwr_mode(hba, UFS_ACTIVE_PWR_MODE);
+		if (ret)
+			goto set_old_link_state;
+	}
+
+	ufshcd_disable_auto_bkops(hba);
+	goto out;
+
+set_old_link_state:
+	ufshcd_link_state_transition(hba, old_link_state, 0);
+vendor_suspend:
+	if (hba->vops && hba->vops->suspend)
+		hba->vops->suspend(hba, pm_op);
+disable_vreg:
+	ufshcd_vreg_set_lpm(hba);
+disable_irq_and_vops_clks:
+	ufshcd_disable_irq(hba);
+	if (hba->vops && hba->vops->setup_clocks)
+		ret = hba->vops->setup_clocks(hba, false);
+disable_clks:
+	ufshcd_setup_clocks(hba, false);
+out:
+	hba->pm_op_in_progress = 0;
+	return ret;
+}
+
+/**
+ * ufshcd_system_suspend - system suspend routine
+ * @hba: per adapter instance
+ * @pm_op: runtime PM or system PM
+ *
+ * Check the description of ufshcd_suspend() function for more details.
+ *
+ * Returns 0 for success and non-zero for failure
+ */
+int ufshcd_system_suspend(struct ufs_hba *hba)
+{
+	int ret = 0;
+
+	if (!hba || !hba->is_powered)
+		goto out;
+
+	if (pm_runtime_suspended(hba->dev)) {
+		if (hba->rpm_lvl == hba->spm_lvl)
+			/*
+			 * There is possibility that device may still be in
+			 * active state during the runtime suspend.
+			 */
+			if ((ufs_get_pm_lvl_to_dev_pwr_mode(hba->spm_lvl) ==
+			    hba->curr_dev_pwr_mode) && !hba->auto_bkops_enabled)
+				goto out;
+
+		/*
+		 * UFS device and/or UFS link low power states during runtime
+		 * suspend seems to be different than what is expected during
+		 * system suspend. Hence runtime resume the devic & link and
+		 * let the system suspend low power states to take effect.
+		 * TODO: If resume takes longer time, we might have optimize
+		 * it in future by not resuming everything if possible.
+		 */
+		ret = ufshcd_runtime_resume(hba);
+		if (ret)
+			goto out;
+	}
+
+	ret = ufshcd_suspend(hba, UFS_SYSTEM_PM);
+out:
+	return ret;
+}
+EXPORT_SYMBOL(ufshcd_system_suspend);
+
+/**
+ * ufshcd_system_resume - system resume routine
+ * @hba: per adapter instance
+ *
+ * Returns 0 for success and non-zero for failure
+ */
+
+int ufshcd_system_resume(struct ufs_hba *hba)
+{
+	if (!hba || !hba->is_powered || pm_runtime_suspended(hba->dev))
+		/*
+		 * Let the runtime resume take care of resuming
+		 * if runtime suspended.
+		 */
+		return 0;
+
+	return ufshcd_resume(hba, UFS_SYSTEM_PM);
+}
+EXPORT_SYMBOL(ufshcd_system_resume);
+
+/**
+ * ufshcd_runtime_suspend - runtime suspend routine
+ * @hba: per adapter instance
+ *
+ * Check the description of ufshcd_suspend() function for more details.
+ *
+ * Returns 0 for success and non-zero for failure
+ */
+int ufshcd_runtime_suspend(struct ufs_hba *hba)
+{
+	if (!hba || !hba->is_powered)
+		return 0;
+
+	return ufshcd_suspend(hba, UFS_RUNTIME_PM);
 }
 EXPORT_SYMBOL(ufshcd_runtime_suspend);
 
+/**
+ * ufshcd_runtime_resume - runtime resume routine
+ * @hba: per adapter instance
+ *
+ * This function basically brings the UFS device, UniPro link and controller
+ * to active state. Following operations are done in this function:
+ *
+ * 1. Turn on all the controller related clocks
+ * 2. Bring the UniPro link out of Hibernate state
+ * 3. If UFS device is in sleep state, turn ON VCC rail and bring the UFS device
+ *    to active state.
+ * 4. If auto-bkops is enabled on the device, disable it.
+ *
+ * So following would be the possible power state after this function return
+ * successfully:
+ *	S1: UFS device in Active state with VCC rail ON
+ *	    UniPro link in Active state
+ *	    All the UFS/UniPro controller clocks are ON
+ *
+ * Returns 0 for success and non-zero for failure
+ */
 int ufshcd_runtime_resume(struct ufs_hba *hba)
 {
-	if (!hba)
+	if (!hba || !hba->is_powered)
 		return 0;
-
-	return ufshcd_disable_auto_bkops(hba);
+	else
+		return ufshcd_resume(hba, UFS_RUNTIME_PM);
 }
 EXPORT_SYMBOL(ufshcd_runtime_resume);
 
@@ -3958,6 +4692,36 @@ int ufshcd_runtime_idle(struct ufs_hba *hba)
 EXPORT_SYMBOL(ufshcd_runtime_idle);
 
 /**
+ * ufshcd_shutdown - shutdown routine
+ * @hba: per adapter instance
+ *
+ * This function would power off both UFS device and UFS link.
+ *
+ * Returns 0 always to allow force shutdown even in case of errors.
+ */
+int ufshcd_shutdown(struct ufs_hba *hba)
+{
+	int ret = 0;
+
+	if (ufshcd_is_ufs_dev_poweroff(hba) && ufshcd_is_link_off(hba))
+		goto out;
+
+	if (pm_runtime_suspended(hba->dev)) {
+		ret = ufshcd_runtime_resume(hba);
+		if (ret)
+			goto out;
+	}
+
+	ret = ufshcd_suspend(hba, UFS_SHUTDOWN_PM);
+out:
+	if (ret)
+		dev_err(hba->dev, "%s failed, err %d\n", __func__, ret);
+	/* allow force shutdown even in case of errors */
+	return 0;
+}
+EXPORT_SYMBOL(ufshcd_shutdown);
+
+/**
  * ufshcd_remove - de-allocate SCSI host and host memory space
  *		data structure memory
  * @hba - per adapter instance
@@ -4109,6 +4873,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	if (err) {
 		dev_err(hba->dev, "request irq failed\n");
 		goto out_disable;
+	} else {
+		hba->is_irq_enabled = true;
 	}
 
 	/* Enable SCSI tag mapping */
@@ -4134,6 +4900,12 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	/* Hold auto suspend until async scan completes */
 	pm_runtime_get_sync(dev);
 
+	/*
+	 * The device-initialize-sequence hasn't been invoked yet.
+	 * Set the device to power-off state
+	 */
+	ufshcd_set_ufs_dev_poweroff(hba);
+
 	async_schedule(ufshcd_async_scan, hba);
 
 	return 0;
@@ -4141,6 +4913,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 out_remove_scsi_host:
 	scsi_remove_host(hba->host);
 out_disable:
+	hba->is_irq_enabled = false;
 	scsi_host_put(host);
 	ufshcd_hba_exit(hba);
 out_error:
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 9b5f77f..1ee429d 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -96,6 +96,54 @@ struct uic_command {
 	struct completion done;
 };
 
+/* Used to differentiate the power management options */
+enum ufs_pm_op {
+	UFS_RUNTIME_PM,
+	UFS_SYSTEM_PM,
+	UFS_SHUTDOWN_PM,
+};
+
+#define ufshcd_is_runtime_pm(op) ((op) == UFS_RUNTIME_PM)
+#define ufshcd_is_system_pm(op) ((op) == UFS_SYSTEM_PM)
+#define ufshcd_is_shutdown_pm(op) ((op) == UFS_SHUTDOWN_PM)
+
+/* Host <-> Device UniPro Link state */
+enum uic_link_state {
+	UIC_LINK_OFF_STATE	= 0, /* Link powered down or disabled */
+	UIC_LINK_ACTIVE_STATE	= 1, /* Link is in Fast/Slow/Sleep state */
+	UIC_LINK_HIBERN8_STATE	= 2, /* Link is in Hibernate state */
+};
+
+#define ufshcd_is_link_off(hba) ((hba)->uic_link_state == UIC_LINK_OFF_STATE)
+#define ufshcd_is_link_active(hba) ((hba)->uic_link_state == \
+				    UIC_LINK_ACTIVE_STATE)
+#define ufshcd_is_link_hibern8(hba) ((hba)->uic_link_state == \
+				    UIC_LINK_HIBERN8_STATE)
+#define ufshcd_set_link_off(hba) ((hba)->uic_link_state = UIC_LINK_OFF_STATE)
+#define ufshcd_set_link_active(hba) ((hba)->uic_link_state = \
+				    UIC_LINK_ACTIVE_STATE)
+#define ufshcd_set_link_hibern8(hba) ((hba)->uic_link_state = \
+				    UIC_LINK_HIBERN8_STATE)
+
+/*
+ * UFS Power management levels.
+ * Each level is in increasing order of power savings.
+ */
+enum ufs_pm_level {
+	UFS_PM_LVL_0, /* UFS_ACTIVE_PWR_MODE, UIC_LINK_ACTIVE_STATE */
+	UFS_PM_LVL_1, /* UFS_ACTIVE_PWR_MODE, UIC_LINK_HIBERN8_STATE */
+	UFS_PM_LVL_2, /* UFS_SLEEP_PWR_MODE, UIC_LINK_ACTIVE_STATE */
+	UFS_PM_LVL_3, /* UFS_SLEEP_PWR_MODE, UIC_LINK_HIBERN8_STATE */
+	UFS_PM_LVL_4, /* UFS_POWERDOWN_PWR_MODE, UIC_LINK_HIBERN8_STATE */
+	UFS_PM_LVL_5, /* UFS_POWERDOWN_PWR_MODE, UIC_LINK_OFF_STATE */
+	UFS_PM_LVL_MAX
+};
+
+struct ufs_pm_lvl_states {
+	enum ufs_dev_pwr_mode dev_state;
+	enum uic_link_state link_state;
+};
+
 /**
  * struct ufshcd_lrb - local reference block
  * @utr_descriptor_ptr: UTRD address of the command
@@ -184,6 +232,8 @@ struct ufs_clk_info {
  *                     variant specific Uni-Pro initialization.
  * @link_startup_notify: called before and after Link startup is carried out
  *                       to allow variant specific Uni-Pro initialization.
+ * @suspend: called during host controller PM callback
+ * @resume: called during host controller PM callback
  */
 struct ufs_hba_variant_ops {
 	const char *name;
@@ -193,6 +243,8 @@ struct ufs_hba_variant_ops {
 	int     (*setup_regulators)(struct ufs_hba *, bool);
 	int     (*hce_enable_notify)(struct ufs_hba *, bool);
 	int     (*link_startup_notify)(struct ufs_hba *, bool);
+	int     (*suspend)(struct ufs_hba *, enum ufs_pm_op);
+	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
 };
 
 /**
@@ -271,6 +323,13 @@ struct ufs_hba {
 	 * "UFS device" W-LU.
 	 */
 	struct scsi_device *sdev_ufs_device;
+	enum ufs_dev_pwr_mode curr_dev_pwr_mode;
+	enum uic_link_state uic_link_state;
+	/* Desired UFS power management level during runtime PM */
+	enum ufs_pm_level rpm_lvl;
+	/* Desired UFS power management level during system PM */
+	enum ufs_pm_level spm_lvl;
+	int pm_op_in_progress;
 
 	struct ufshcd_lrb *lrb;
 	unsigned long lrb_in_use;
@@ -285,16 +344,17 @@ struct ufs_hba {
 	struct ufs_hba_variant_ops *vops;
 	void *priv;
 	unsigned int irq;
+	bool is_irq_enabled;
 
-	struct uic_command *active_uic_cmd;
-	struct mutex uic_cmd_mutex;
 
 	wait_queue_head_t tm_wq;
 	wait_queue_head_t tm_tag_wq;
 	unsigned long tm_condition;
 	unsigned long tm_slots_in_use;
 
-	struct completion *pwr_done;
+	struct uic_command *active_uic_cmd;
+	struct mutex uic_cmd_mutex;
+	struct completion *uic_async_done;
 
 	u32 ufshcd_state;
 	u32 eh_flags;
@@ -317,9 +377,13 @@ struct ufs_hba {
 	/* Device management request data */
 	struct ufs_dev_cmd dev_cmd;
 
+	/* Keeps information of the UFS device connected to this host */
+	struct ufs_dev_info dev_info;
 	bool auto_bkops_enabled;
 	struct ufs_vreg_info vreg_info;
 	struct list_head clk_list_head;
+
+	bool wlun_dev_clr_ua;
 };
 
 #define ufshcd_writel(hba, val, reg)	\
@@ -346,11 +410,12 @@ static inline void check_upiu_size(void)
 		GENERAL_UPIU_REQUEST_SIZE + QUERY_DESC_MAX_SIZE);
 }
 
-extern int ufshcd_suspend(struct ufs_hba *hba, pm_message_t state);
-extern int ufshcd_resume(struct ufs_hba *hba);
 extern int ufshcd_runtime_suspend(struct ufs_hba *hba);
 extern int ufshcd_runtime_resume(struct ufs_hba *hba);
 extern int ufshcd_runtime_idle(struct ufs_hba *hba);
+extern int ufshcd_system_suspend(struct ufs_hba *hba);
+extern int ufshcd_system_resume(struct ufs_hba *hba);
+extern int ufshcd_shutdown(struct ufs_hba *hba);
 extern int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
 			       u8 attr_set, u32 mib_val, u8 peer);
 extern int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index e1b844b..d572119 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -124,8 +124,11 @@ enum {
 #define CONTROLLER_FATAL_ERROR			UFS_BIT(16)
 #define SYSTEM_BUS_FATAL_ERROR			UFS_BIT(17)
 
-#define UFSHCD_UIC_MASK		(UIC_COMMAND_COMPL |\
-				 UIC_POWER_MODE)
+#define UFSHCD_UIC_PWR_MASK	(UIC_HIBERNATE_ENTER |\
+				UIC_HIBERNATE_EXIT |\
+				UIC_POWER_MODE)
+
+#define UFSHCD_UIC_MASK		(UIC_COMMAND_COMPL | UFSHCD_UIC_PWR_MASK)
 
 #define UFSHCD_ERROR_MASK	(UIC_ERROR |\
 				DEVICE_FATAL_ERROR |\
@@ -210,7 +213,7 @@ enum {
 #define UIC_GET_ATTR_ID(v)		(((v) >> 16) & 0xFFFF)
 
 /* UIC Commands */
-enum {
+enum uic_cmd_dme {
 	UIC_CMD_DME_GET			= 0x01,
 	UIC_CMD_DME_SET			= 0x02,
 	UIC_CMD_DME_PEER_GET		= 0x03,
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
