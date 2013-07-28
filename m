From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH 3/9] scsi: ufs: Add support for host assisted background operations
Date: Sun, 28 Jul 2013 22:40:31 +0530
Message-ID: <1375031437-10206-4-git-send-email-santoshsy@gmail.com>
References: <1375031437-10206-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64280 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab3G1RME (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Jul 2013 13:12:04 -0400
Received: by mail-pa0-f46.google.com with SMTP id fa1so5035759pad.33
        for <linux-scsi@vger.kernel.org>; Sun, 28 Jul 2013 10:12:03 -0700 (PDT)
In-Reply-To: <1375031437-10206-1-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Sujit Reddy Thumma <sthumma@codeaurora.org>, Santosh Y <santoshsy@gmail.com>

From: Sujit Reddy Thumma <sthumma@codeaurora.org>

Background operations in the UFS device can be disabled by
the host to reduce the response latency of transfer requests.
Add support for enabling/disabling the background operations
during runtime suspend/resume of the device.

If the device is in critical need of BKOPS it will raise an
URGENT_BKOPS exception which should be handled by the host to
make sure the device performs as expected.

During bootup, the BKOPS is enabled in the device by default.
The disable of BKOPS is supported only when the driver supports
runtime suspend/resume operations as the runtime PM framework
provides a way to determine the device idleness and hence BKOPS
can be managed effectively. During runtime resume the BKOPS is
disabled to reduce latency and during runtime suspend the BKOPS
is enabled to allow device to carry out idle time BKOPS.

In some cases where the BKOPS is disabled during runtime resume
and due to continuous data transfers the runtime suspend is not
triggered, the BKOPS is enabled when the device raises a level-2
exception (outstanding operations - performance impact).

Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
Signed-off-by: Santosh Y <santoshsy@gmail.com>

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 50d32f1..bce09a6 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -107,6 +107,28 @@ enum {
 /* Flag idn for Query Requests*/
 enum flag_idn {
 	QUERY_FLAG_IDN_FDEVICEINIT      = 0x01,
+	QUERY_FLAG_IDN_BKOPS_EN         = 0x04,
+};
+
+/* Attribute idn for Query requests */
+enum attr_idn {
+	QUERY_ATTR_IDN_BKOPS_STATUS	= 0x05,
+	QUERY_ATTR_IDN_EE_CONTROL	= 0x0D,
+	QUERY_ATTR_IDN_EE_STATUS	= 0x0E,
+};
+
+/* Exception event mask values */
+enum {
+	MASK_EE_STATUS		= 0xFFFF,
+	MASK_EE_URGENT_BKOPS	= (1 << 2),
+};
+
+/* Background operation status */
+enum {
+	BKOPS_STATUS_NO_OP               = 0x0,
+	BKOPS_STATUS_NON_CRITICAL        = 0x1,
+	BKOPS_STATUS_PERF_IMPACT         = 0x2,
+	BKOPS_STATUS_CRITICAL            = 0x3,
 };
 
 /* UTP QUERY Transaction Specific Fields OpCode */
@@ -155,6 +177,7 @@ enum {
 	MASK_TASK_RESPONSE              = 0xFF00,
 	MASK_RSP_UPIU_RESULT            = 0xFFFF,
 	MASK_QUERY_DATA_SEG_LEN         = 0xFFFF,
+	MASK_RSP_EXCEPTION_EVENT        = 0x10000,
 };
 
 /* Task management service response */
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 7b581f7..4267246 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -261,6 +261,21 @@ ufshcd_get_rsp_upiu_result(struct utp_upiu_rsp *ucd_rsp_ptr)
 }
 
 /**
+ * ufshcd_is_exception_event - Check if the device raised an exception event
+ * @ucd_rsp_ptr: pointer to response UPIU
+ *
+ * The function checks if the device raised an exception event indicated in
+ * the Device Information field of response UPIU.
+ *
+ * Returns true if exception is raised, false otherwise.
+ */
+static inline bool ufshcd_is_exception_event(struct utp_upiu_rsp *ucd_rsp_ptr)
+{
+	return be32_to_cpu(ucd_rsp_ptr->header.dword_2) &
+			MASK_RSP_EXCEPTION_EVENT ? true : false;
+}
+
+/**
  * ufshcd_config_int_aggr - Configure interrupt aggregation values.
  *		Currently there is no use case where we want to configure
  *		interrupt aggregation dynamically. So to configure interrupt
@@ -1107,6 +1122,77 @@ out_unlock:
 }
 
 /**
+ * ufshcd_query_attr - API function for sending attribute requests
+ * hba: per-adapter instance
+ * opcode: attribute opcode
+ * idn: attribute idn to access
+ * index: index field
+ * selector: selector field
+ * attr_val: the attribute value after the query request completes
+ *
+ * Returns 0 for success, non-zero in case of failure
+*/
+int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
+			enum attr_idn idn, u8 index, u8 selector, u32 *attr_val)
+{
+	struct ufs_query_req *request;
+	struct ufs_query_res *response;
+	int err;
+
+	BUG_ON(!hba);
+
+	if (!attr_val) {
+		dev_err(hba->dev, "%s: attribute value required for opcode 0x%x\n",
+				__func__, opcode);
+		err = -EINVAL;
+		goto out;
+	}
+
+	mutex_lock(&hba->dev_cmd.lock);
+	request = &hba->dev_cmd.query.request;
+	response = &hba->dev_cmd.query.response;
+	memset(request, 0, sizeof(struct ufs_query_req));
+	memset(response, 0, sizeof(struct ufs_query_res));
+
+	switch (opcode) {
+	case UPIU_QUERY_OPCODE_WRITE_ATTR:
+		request->query_func = UPIU_QUERY_FUNC_STANDARD_WRITE_REQUEST;
+		request->upiu_req.value = *attr_val;
+		break;
+	case UPIU_QUERY_OPCODE_READ_ATTR:
+		request->query_func = UPIU_QUERY_FUNC_STANDARD_READ_REQUEST;
+		break;
+	default:
+		dev_err(hba->dev, "%s: Expected query attr opcode but got = 0x%.2x\n",
+				__func__, opcode);
+		err = -EINVAL;
+		goto out_unlock;
+	}
+
+	request->upiu_req.opcode = opcode;
+	request->upiu_req.idn = idn;
+	request->upiu_req.index = index;
+	request->upiu_req.selector = selector;
+
+	/* Send query request */
+	err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY,
+						QUERY_REQ_TIMEOUT);
+
+	if (err) {
+		dev_err(hba->dev, "%s: opcode 0x%.2x for idn %d failed, err = %d\n",
+				__func__, opcode, idn, err);
+		goto out_unlock;
+	}
+
+	*attr_val = response->upiu_res.value;
+
+out_unlock:
+	mutex_unlock(&hba->dev_cmd.lock);
+out:
+	return err;
+}
+
+/**
  * ufshcd_memory_alloc - allocate memory for host memory space data structures
  * @hba: per adapter instance
  *
@@ -1772,6 +1858,9 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 			 */
 			scsi_status = result & MASK_SCSI_STATUS;
 			result = ufshcd_scsi_cmd_status(lrbp, scsi_status);
+
+			if (ufshcd_is_exception_event(lrbp->ucd_rsp_ptr))
+				schedule_work(&hba->eeh_work);
 			break;
 		case UPIU_TRANSACTION_REJECT_UPIU:
 			/* TODO: handle Reject UPIU Response */
@@ -1875,6 +1964,230 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
 }
 
 /**
+ * ufshcd_disable_ee - disable exception event
+ * @hba: per-adapter instance
+ * @mask: exception event to disable
+ *
+ * Disables exception event in the device so that the EVENT_ALERT
+ * bit is not set.
+ *
+ * Returns zero on success, non-zero error value on failure.
+ */
+static int ufshcd_disable_ee(struct ufs_hba *hba, u16 mask)
+{
+	int err = 0;
+	u32 val;
+
+	if (!(hba->ee_ctrl_mask & mask))
+		goto out;
+
+	val = hba->ee_ctrl_mask & ~mask;
+	val &= 0xFFFF; /* 2 bytes */
+	err = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+			QUERY_ATTR_IDN_EE_CONTROL, 0, 0, &val);
+	if (!err)
+		hba->ee_ctrl_mask &= ~mask;
+out:
+	return err;
+}
+
+/**
+ * ufshcd_enable_ee - enable exception event
+ * @hba: per-adapter instance
+ * @mask: exception event to enable
+ *
+ * Enable corresponding exception event in the device to allow
+ * device to alert host in critical scenarios.
+ *
+ * Returns zero on success, non-zero error value on failure.
+ */
+static int ufshcd_enable_ee(struct ufs_hba *hba, u16 mask)
+{
+	int err = 0;
+	u32 val;
+
+	if (hba->ee_ctrl_mask & mask)
+		goto out;
+
+	val = hba->ee_ctrl_mask | mask;
+	val &= 0xFFFF; /* 2 bytes */
+	err = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+			QUERY_ATTR_IDN_EE_CONTROL, 0, 0, &val);
+	if (!err)
+		hba->ee_ctrl_mask |= mask;
+out:
+	return err;
+}
+
+/**
+ * ufshcd_enable_auto_bkops - Allow device managed BKOPS
+ * @hba: per-adapter instance
+ *
+ * Allow device to manage background operations on its own. Enabling
+ * this might lead to inconsistent latencies during normal data transfers
+ * as the device is allowed to manage its own way of handling background
+ * operations.
+ *
+ * Returns zero on success, non-zero on failure.
+ */
+static int ufshcd_enable_auto_bkops(struct ufs_hba *hba)
+{
+	int err = 0;
+
+	if (hba->auto_bkops_enabled)
+		goto out;
+
+	err = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_SET_FLAG,
+			QUERY_FLAG_IDN_BKOPS_EN, NULL);
+	if (err) {
+		dev_err(hba->dev, "%s: failed to enable bkops %d\n",
+				__func__, err);
+		goto out;
+	}
+
+	hba->auto_bkops_enabled = true;
+
+	/* No need of URGENT_BKOPS exception from the device */
+	err = ufshcd_disable_ee(hba, MASK_EE_URGENT_BKOPS);
+	if (err)
+		dev_err(hba->dev, "%s: failed to disable exception event %d\n",
+				__func__, err);
+out:
+	return err;
+}
+
+/**
+ * ufshcd_disable_auto_bkops - block device in doing background operations
+ * @hba: per-adapter instance
+ *
+ * Disabling background operations improves command response latency but
+ * has drawback of device moving into critical state where the device is
+ * not-operable. Make sure to call ufshcd_enable_auto_bkops() whenever the
+ * host is idle so that BKOPS are managed effectively without any negative
+ * impacts.
+ *
+ * Returns zero on success, non-zero on failure.
+ */
+static int ufshcd_disable_auto_bkops(struct ufs_hba *hba)
+{
+	int err = 0;
+
+	if (!hba->auto_bkops_enabled)
+		goto out;
+
+	/*
+	 * If host assisted BKOPs is to be enabled, make sure
+	 * urgent bkops exception is allowed.
+	 */
+	err = ufshcd_enable_ee(hba, MASK_EE_URGENT_BKOPS);
+	if (err) {
+		dev_err(hba->dev, "%s: failed to enable exception event %d\n",
+				__func__, err);
+		goto out;
+	}
+
+	err = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_CLEAR_FLAG,
+			QUERY_FLAG_IDN_BKOPS_EN, NULL);
+	if (err) {
+		dev_err(hba->dev, "%s: failed to disable bkops %d\n",
+				__func__, err);
+		ufshcd_disable_ee(hba, MASK_EE_URGENT_BKOPS);
+		goto out;
+	}
+
+	hba->auto_bkops_enabled = false;
+out:
+	return err;
+}
+
+/**
+ * ufshcd_force_reset_auto_bkops - force enable of auto bkops
+ * @hba: per adapter instance
+ *
+ * After a device reset the device may toggle the BKOPS_EN flag
+ * to default value. The s/w tracking variables should be updated
+ * as well. Do this by forcing enable of auto bkops.
+ */
+static void  ufshcd_force_reset_auto_bkops(struct ufs_hba *hba)
+{
+	hba->auto_bkops_enabled = false;
+	hba->ee_ctrl_mask |= MASK_EE_URGENT_BKOPS;
+	ufshcd_enable_auto_bkops(hba);
+}
+
+static inline int ufshcd_get_bkops_status(struct ufs_hba *hba, u32 *status)
+{
+	return ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+			QUERY_ATTR_IDN_BKOPS_STATUS, 0, 0, status);
+}
+
+/**
+ * ufshcd_urgent_bkops - handle urgent bkops exception event
+ * @hba: per-adapter instance
+ *
+ * Enable fBackgroundOpsEn flag in the device to permit background
+ * operations.
+ */
+static int ufshcd_urgent_bkops(struct ufs_hba *hba)
+{
+	int err;
+	u32 status = 0;
+
+	err = ufshcd_get_bkops_status(hba, &status);
+	if (err) {
+		dev_err(hba->dev, "%s: failed to get BKOPS status %d\n",
+				__func__, err);
+		goto out;
+	}
+
+	status = status & 0xF;
+
+	/* handle only if status indicates performance impact or critical */
+	if (status >= BKOPS_STATUS_PERF_IMPACT)
+		err = ufshcd_enable_auto_bkops(hba);
+out:
+	return err;
+}
+
+static inline int ufshcd_get_ee_status(struct ufs_hba *hba, u32 *status)
+{
+	return ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+			QUERY_ATTR_IDN_EE_STATUS, 0, 0, status);
+}
+
+/**
+ * ufshcd_exception_event_handler - handle exceptions raised by device
+ * @work: pointer to work data
+ *
+ * Read bExceptionEventStatus attribute from the device and handle the
+ * exception event accordingly.
+ */
+static void ufshcd_exception_event_handler(struct work_struct *work)
+{
+	struct ufs_hba *hba;
+	int err;
+	u32 status = 0;
+	hba = container_of(work, struct ufs_hba, eeh_work);
+
+	err = ufshcd_get_ee_status(hba, &status);
+	if (err) {
+		dev_err(hba->dev, "%s: failed to get exception status %d\n",
+				__func__, err);
+		goto out;
+	}
+
+	status &= hba->ee_ctrl_mask;
+	if (status & MASK_EE_URGENT_BKOPS) {
+		err = ufshcd_urgent_bkops(hba);
+		if (err)
+			dev_err(hba->dev, "%s: failed to handle urgent bkops %d\n",
+					__func__, err);
+	}
+out:
+	return;
+}
+
+/**
  * ufshcd_fatal_err_handler - handle fatal errors
  * @hba: per adapter instance
  */
@@ -2185,6 +2498,7 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 	if (ret)
 		goto out;
 
+	ufshcd_force_reset_auto_bkops(hba);
 	scsi_scan_host(hba->host);
 out:
 	return;
@@ -2249,6 +2563,34 @@ int ufshcd_resume(struct ufs_hba *hba)
 }
 EXPORT_SYMBOL_GPL(ufshcd_resume);
 
+int ufshcd_runtime_suspend(struct ufs_hba *hba)
+{
+	if (!hba)
+		return 0;
+
+	/*
+	 * The device is idle with no requests in the queue,
+	 * allow background operations.
+	 */
+	return ufshcd_enable_auto_bkops(hba);
+}
+EXPORT_SYMBOL(ufshcd_runtime_suspend);
+
+int ufshcd_runtime_resume(struct ufs_hba *hba)
+{
+	if (!hba)
+		return 0;
+
+	return ufshcd_disable_auto_bkops(hba);
+}
+EXPORT_SYMBOL(ufshcd_runtime_resume);
+
+int ufshcd_runtime_idle(struct ufs_hba *hba)
+{
+	return 0;
+}
+EXPORT_SYMBOL(ufshcd_runtime_idle);
+
 /**
  * ufshcd_remove - de-allocate SCSI host and host memory space
  *		data structure memory
@@ -2339,6 +2681,7 @@ int ufshcd_init(struct device *dev, struct ufs_hba **hba_handle,
 
 	/* Initialize work queues */
 	INIT_WORK(&hba->feh_workq, ufshcd_fatal_err_handler);
+	INIT_WORK(&hba->eeh_work, ufshcd_exception_event_handler);
 
 	/* Initialize UIC command mutex */
 	mutex_init(&hba->uic_cmd_mutex);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 6d6fdeb..59c9c48 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -178,9 +178,12 @@ struct ufs_dev_cmd {
  * @tm_condition: condition variable for task management
  * @ufshcd_state: UFSHCD states
  * @intr_mask: Interrupt Mask Bits
+ * @ee_ctrl_mask: Exception event control mask
  * @feh_workq: Work queue for fatal controller error handling
+ * @eeh_work: Worker to handle exception events
  * @errors: HBA errors
  * @dev_cmd: ufs device management command information
+ * @auto_bkops_enabled: to track whether bkops is enabled in device
  */
 struct ufs_hba {
 	void __iomem *mmio_base;
@@ -218,15 +221,19 @@ struct ufs_hba {
 
 	u32 ufshcd_state;
 	u32 intr_mask;
+	u16 ee_ctrl_mask;
 
 	/* Work Queues */
 	struct work_struct feh_workq;
+	struct work_struct eeh_work;
 
 	/* HBA Errors */
 	u32 errors;
 
 	/* Device management request data */
 	struct ufs_dev_cmd dev_cmd;
+
+	bool auto_bkops_enabled;
 };
 
 #define ufshcd_writel(hba, val, reg)	\
@@ -253,4 +260,7 @@ static inline void check_upiu_size(void)
 		GENERAL_UPIU_REQUEST_SIZE + QUERY_DESC_MAX_SIZE);
 }
 
+extern int ufshcd_runtime_suspend(struct ufs_hba *hba);
+extern int ufshcd_runtime_resume(struct ufs_hba *hba);
+extern int ufshcd_runtime_idle(struct ufs_hba *hba);
 #endif /* End of Header */
-- 
1.8.3.1

