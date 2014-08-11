From: Dolev Raviv <draviv@codeaurora.org>
Subject: [RFC 05/10] scsi: ufs: improve init sequence
Date: Mon, 11 Aug 2014 15:40:33 +0300
Message-ID: <1407760838-6406-6-git-send-email-draviv@codeaurora.org>
References: <1407760838-6406-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:57352 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbaHKMlu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Aug 2014 08:41:50 -0400
In-Reply-To: <1407760838-6406-1-git-send-email-draviv@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Sujit Reddy Thumma <sthumma@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>

From: Sujit Reddy Thumma <sthumma@codeaurora.org>

In ->hce_enable_notify() callback the vendor specific initialization
may carry out additional DME configuration using UIC commands and
hence the UIC command completion interrupt enable bit should be set
before the post reset notification.
Add retries if the link-startup fails. This is required since due to
hardware timing issues, the Uni-Pro link-startup might fail. The UFS
HCI recovery procedure contradicts the Uni-Pro sequence. The UFS HCI
specifies to resend DME_LINKSTARTUP command after IS.ULLS (link-lost
interrupt) is received. The Uni-Pro specifies that if link-startup
fails the link is in "down" state. The link-lost is indicated to the
DME user only when the link is up. Hence, the UFS HCI recovery procedure
of waiting for IS.ULLS and retrying link-startup may not work properly.

At the end, if detection fails, power off (disable clocks, regulators,
phy) if the UFS device detection fails. This saves power while UFS device
is not embedded into the system.

Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
Signed-off-by: Dolev Raviv <draviv@codeaurora.org>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 57a8dbb..1fabff4 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -62,6 +62,12 @@
 /* Task management command timeout */
 #define TM_CMD_TIMEOUT	100 /* msecs */
 
+/* maximum number of link-startup retries */
+#define DME_LINKSTARTUP_RETRIES 3
+
+/* maximum number of reset retries before giving up */
+#define MAX_HOST_RESET_RETRIES 5
+
 /* Expose the flag value from utp_upiu_query.value */
 #define MASK_QUERY_UPIU_FLAG_LOC 0xFF
 
@@ -137,6 +143,8 @@ static void ufshcd_tmc_handler(struct ufs_hba *hba);
 static void ufshcd_async_scan(void *data, async_cookie_t cookie);
 static int ufshcd_reset_and_restore(struct ufs_hba *hba);
 static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag);
+static void ufshcd_hba_exit(struct ufs_hba *hba);
+static int ufshcd_probe_hba(struct ufs_hba *hba);
 
 /*
  * ufshcd_wait_for_register - wait for register value to change
@@ -2043,6 +2051,9 @@ static int ufshcd_hba_enable(struct ufs_hba *hba)
 		msleep(5);
 	}
 
+	/* enable UIC related interrupts */
+	ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
+
 	if (hba->vops && hba->vops->hce_enable_notify)
 		hba->vops->hce_enable_notify(hba, POST_CHANGE);
 
@@ -2058,23 +2069,33 @@ static int ufshcd_hba_enable(struct ufs_hba *hba)
 static int ufshcd_link_startup(struct ufs_hba *hba)
 {
 	int ret;
+	int retries = DME_LINKSTARTUP_RETRIES;
 
-	/* enable UIC related interrupts */
-	ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
+	do {
+		if (hba->vops && hba->vops->link_startup_notify)
+			hba->vops->link_startup_notify(hba, PRE_CHANGE);
 
-	if (hba->vops && hba->vops->link_startup_notify)
-		hba->vops->link_startup_notify(hba, PRE_CHANGE);
+		ret = ufshcd_dme_link_startup(hba);
 
-	ret = ufshcd_dme_link_startup(hba);
-	if (ret)
-		goto out;
+		/* check if device is detected by inter-connect layer */
+		if (!ret && !ufshcd_is_device_present(hba)) {
+			dev_err(hba->dev, "%s: Device not present\n", __func__);
+			ret = -ENXIO;
+			goto out;
+		}
+
+		/*
+		 * DME link lost indication is only received when link is up,
+		 * but we can't be sure if the link is up until link startup
+		 * succeeds. So reset the local Uni-Pro and try again.
+		 */
+		if (ret && ufshcd_hba_enable(hba))
+			goto out;
+	} while (ret && retries--);
 
-	/* check if device is detected by inter-connect layer */
-	if (!ufshcd_is_device_present(hba)) {
-		dev_err(hba->dev, "%s: Device not present\n", __func__);
-		ret = -ENXIO;
+	if (ret)
+		/* failed to get the link up... retire */
 		goto out;
-	}
 
 	/* Include any host controller configuration via UIC commands */
 	if (hba->vops && hba->vops->link_startup_notify) {
@@ -3139,7 +3160,6 @@ out:
 static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 {
 	int err;
-	async_cookie_t cookie;
 	unsigned long flags;
 
 	/* Reset the host controller */
@@ -3152,10 +3172,9 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 		goto out;
 
 	/* Establish the link again and restore the device */
-	cookie = async_schedule(ufshcd_async_scan, hba);
-	/* wait for async scan to be completed */
-	async_synchronize_cookie(++cookie);
-	if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL)
+	err = ufshcd_probe_hba(hba);
+
+	if (!err && (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL))
 		err = -EIO;
 out:
 	if (err)
@@ -3177,8 +3196,11 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba)
 {
 	int err = 0;
 	unsigned long flags;
+	int retries = MAX_HOST_RESET_RETRIES;
 
-	err = ufshcd_host_reset_and_restore(hba);
+	do {
+		err = ufshcd_host_reset_and_restore(hba);
+	} while (err && --retries);
 
 	/*
 	 * After reset the door-bell might be cleared, complete
@@ -3243,13 +3265,13 @@ static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd)
 }
 
 /**
- * ufshcd_async_scan - asynchronous execution for link startup
- * @data: data pointer to pass to this function
- * @cookie: cookie data
+ * ufshcd_probe_hba - probe hba to detect device and initialize
+ * @hba: per-adapter instance
+ *
+ * Execute link-startup and verify device initialization
  */
-static void ufshcd_async_scan(void *data, async_cookie_t cookie)
+static int ufshcd_probe_hba(struct ufs_hba *hba)
 {
-	struct ufs_hba *hba = (struct ufs_hba *)data;
 	int ret;
 
 	ret = ufshcd_link_startup(hba);
@@ -3275,7 +3297,26 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 		pm_runtime_put_sync(hba->dev);
 	}
 out:
-	return;
+	/*
+	 * If we failed to initialize the device or the device is not
+	 * present, turn off the power/clocks etc.
+	 */
+	if (ret && !ufshcd_eh_in_progress(hba))
+		ufshcd_hba_exit(hba);
+
+	return ret;
+}
+
+/**
+ * ufshcd_async_scan - asynchronous execution for probing hba
+ * @data: data pointer to pass to this function
+ * @cookie: cookie data
+ */
+static void ufshcd_async_scan(void *data, async_cookie_t cookie)
+{
+	struct ufs_hba *hba = (struct ufs_hba *)data;
+
+	ufshcd_probe_hba(hba);
 }
 
 static struct scsi_host_template ufshcd_driver_template = {
@@ -3596,6 +3637,7 @@ static int ufshcd_hba_init(struct ufs_hba *hba)
 	if (err)
 		goto out_disable_vreg;
 
+	hba->is_powered = true;
 	goto out;
 
 out_disable_vreg:
@@ -3608,9 +3650,12 @@ out:
 
 static void ufshcd_hba_exit(struct ufs_hba *hba)
 {
-	ufshcd_variant_hba_exit(hba);
-	ufshcd_setup_vreg(hba, false);
-	ufshcd_setup_clocks(hba, false);
+	if (hba->is_powered) {
+		ufshcd_variant_hba_exit(hba);
+		ufshcd_setup_vreg(hba, false);
+		ufshcd_setup_clocks(hba, false);
+		hba->is_powered = false;
+	}
 }
 
 /**
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index bc0f7ed..eddb3f3 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -228,6 +228,7 @@ struct ufs_hba_variant_ops {
  * @eh_flags: Error handling flags
  * @intr_mask: Interrupt Mask Bits
  * @ee_ctrl_mask: Exception event control mask
+ * @is_powered: flag to check if HBA is powered
  * @eh_work: Worker to handle UFS errors that require s/w attention
  * @eeh_work: Worker to handle exception events
  * @errors: HBA errors
@@ -283,6 +284,7 @@ struct ufs_hba {
 	u32 eh_flags;
 	u32 intr_mask;
 	u16 ee_ctrl_mask;
+	bool is_powered;
 
 	/* Work Queues */
 	struct work_struct eh_work;
-- 
1.8.5.2
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
