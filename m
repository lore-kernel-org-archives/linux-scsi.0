From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v5 06/15] scsi: ufs: separate device and host quirks
Date: Sun, 28 Feb 2016 15:32:38 +0200
Message-ID: <1456666367-11418-7-git-send-email-ygardi@codeaurora.org>
References: <1456666367-11418-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1456666367-11418-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, ygardi@codeaurora.org, Raviv Shvili <rshvili@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Currently we use the host quirks mechanism in order to
handle both device and host controller quirks.
In order to support various of UFS devices we should separate
handling the device quirks from the host controller's.

Reviewed-by: Gilad Broner <gbroner@codeaurora.org>
Signed-off-by: Raviv Shvili <rshvili@codeaurora.org>
Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/Makefile     |   2 +-
 drivers/scsi/ufs/ufs.h        |  31 +++++++++++
 drivers/scsi/ufs/ufs_quirks.c | 100 ++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs_quirks.h | 124 ++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c     |   2 +
 drivers/scsi/ufs/ufshcd.h     |   3 +
 6 files changed, 261 insertions(+), 1 deletion(-)
 create mode 100644 drivers/scsi/ufs/ufs_quirks.c
 create mode 100644 drivers/scsi/ufs/ufs_quirks.h

diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index 8303bcc..8570d41 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -1,5 +1,5 @@
 # UFSHCD makefile
 obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
-obj-$(CONFIG_SCSI_UFSHCD) += ufshcd.o
+obj-$(CONFIG_SCSI_UFSHCD) += ufshcd.o ufs_quirks.o
 obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
 obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index aacb235..8ec6356 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -196,6 +196,37 @@ enum unit_desc_param {
 	UNIT_DESC_PARAM_LARGE_UNIT_SIZE_M1	= 0x22,
 };
 
+/* Device descriptor parameters offsets in bytes*/
+enum device_desc_param {
+	DEVICE_DESC_PARAM_LEN			= 0x0,
+	DEVICE_DESC_PARAM_TYPE			= 0x1,
+	DEVICE_DESC_PARAM_DEVICE_TYPE		= 0x2,
+	DEVICE_DESC_PARAM_DEVICE_CLASS		= 0x3,
+	DEVICE_DESC_PARAM_DEVICE_SUB_CLASS	= 0x4,
+	DEVICE_DESC_PARAM_PRTCL			= 0x5,
+	DEVICE_DESC_PARAM_NUM_LU		= 0x6,
+	DEVICE_DESC_PARAM_NUM_WLU		= 0x7,
+	DEVICE_DESC_PARAM_BOOT_ENBL		= 0x8,
+	DEVICE_DESC_PARAM_DESC_ACCSS_ENBL	= 0x9,
+	DEVICE_DESC_PARAM_INIT_PWR_MODE		= 0xA,
+	DEVICE_DESC_PARAM_HIGH_PR_LUN		= 0xB,
+	DEVICE_DESC_PARAM_SEC_RMV_TYPE		= 0xC,
+	DEVICE_DESC_PARAM_SEC_LU		= 0xD,
+	DEVICE_DESC_PARAM_BKOP_TERM_LT		= 0xE,
+	DEVICE_DESC_PARAM_ACTVE_ICC_LVL		= 0xF,
+	DEVICE_DESC_PARAM_SPEC_VER		= 0x10,
+	DEVICE_DESC_PARAM_MANF_DATE		= 0x12,
+	DEVICE_DESC_PARAM_MANF_NAME		= 0x14,
+	DEVICE_DESC_PARAM_PRDCT_NAME		= 0x15,
+	DEVICE_DESC_PARAM_SN			= 0x16,
+	DEVICE_DESC_PARAM_OEM_ID		= 0x17,
+	DEVICE_DESC_PARAM_MANF_ID		= 0x18,
+	DEVICE_DESC_PARAM_UD_OFFSET		= 0x1A,
+	DEVICE_DESC_PARAM_UD_LEN		= 0x1B,
+	DEVICE_DESC_PARAM_RTT_CAP		= 0x1C,
+	DEVICE_DESC_PARAM_FRQ_RTC		= 0x1D,
+};
+
 /*
  * Logical Unit Write Protect
  * 00h: LU not write protected
diff --git a/drivers/scsi/ufs/ufs_quirks.c b/drivers/scsi/ufs/ufs_quirks.c
new file mode 100644
index 0000000..476ed01
--- /dev/null
+++ b/drivers/scsi/ufs/ufs_quirks.c
@@ -0,0 +1,100 @@
+/*
+ * Copyright (c) 2013-2016, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include "ufshcd.h"
+#include "ufs_quirks.h"
+
+static struct ufs_dev_fix ufs_fixups[] = {
+	/* UFS cards deviations table */
+	UFS_FIX(UFS_VENDOR_SAMSUNG, UFS_ANY_MODEL, UFS_DEVICE_NO_VCCQ),
+	UFS_FIX(UFS_VENDOR_SAMSUNG, UFS_ANY_MODEL,
+		UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS),
+	UFS_FIX(UFS_VENDOR_SAMSUNG, UFS_ANY_MODEL,
+		UFS_DEVICE_NO_FASTAUTO),
+	UFS_FIX(UFS_VENDOR_TOSHIBA, "THGLF2G9C8KBADG",
+		UFS_DEVICE_QUIRK_PA_TACTIVATE),
+	UFS_FIX(UFS_VENDOR_TOSHIBA, "THGLF2G9D8KBADG",
+		UFS_DEVICE_QUIRK_PA_TACTIVATE),
+
+	END_FIX
+};
+
+static int ufs_get_device_info(struct ufs_hba *hba,
+				struct ufs_device_info *card_data)
+{
+	int err;
+	u8 model_index;
+	u8 str_desc_buf[QUERY_DESC_STRING_MAX_SIZE + 1] = {0};
+	u8 desc_buf[QUERY_DESC_DEVICE_MAX_SIZE];
+
+	err = ufshcd_read_device_desc(hba, desc_buf,
+					QUERY_DESC_DEVICE_MAX_SIZE);
+	if (err) {
+		dev_err(hba->dev, "%s: Failed reading Device Desc. err = %d\n",
+			__func__, err);
+		goto out;
+	}
+
+	/*
+	 * getting vendor (manufacturerID) and Bank Index in big endian
+	 * format
+	 */
+	card_data->wmanufacturerid = desc_buf[DEVICE_DESC_PARAM_MANF_ID] << 8 |
+				     desc_buf[DEVICE_DESC_PARAM_MANF_ID + 1];
+
+	model_index = desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];
+
+	err = ufshcd_read_string_desc(hba, model_index, str_desc_buf,
+					QUERY_DESC_STRING_MAX_SIZE, ASCII_STD);
+	if (err) {
+		dev_err(hba->dev, "%s: Failed reading Product Name. err = %d\n",
+			__func__, err);
+		goto out;
+	}
+
+	str_desc_buf[QUERY_DESC_STRING_MAX_SIZE] = '\0';
+	strlcpy(card_data->model, (str_desc_buf + QUERY_DESC_HDR_SIZE),
+		min_t(u8, str_desc_buf[QUERY_DESC_LENGTH_OFFSET],
+		      MAX_MODEL_LEN));
+
+	/* Null terminate the model string */
+	card_data->model[MAX_MODEL_LEN] = '\0';
+
+out:
+	return err;
+}
+
+void ufs_advertise_fixup_device(struct ufs_hba *hba)
+{
+	int err;
+	struct ufs_dev_fix *f;
+	struct ufs_device_info card_data;
+
+	card_data.wmanufacturerid = 0;
+
+	err = ufs_get_device_info(hba, &card_data);
+	if (err) {
+		dev_err(hba->dev, "%s: Failed getting device info. err = %d\n",
+			__func__, err);
+		return;
+	}
+
+	for (f = ufs_fixups; f->quirk; f++) {
+		if (((f->card.wmanufacturerid == card_data.wmanufacturerid) ||
+		    (f->card.wmanufacturerid == UFS_ANY_VENDOR)) &&
+		    (STR_PRFX_EQUAL(f->card.model, card_data.model) ||
+		     !strcmp(f->card.model, UFS_ANY_MODEL)))
+			hba->dev_quirks |= f->quirk;
+	}
+}
+EXPORT_SYMBOL(ufs_advertise_fixup_device);
diff --git a/drivers/scsi/ufs/ufs_quirks.h b/drivers/scsi/ufs/ufs_quirks.h
new file mode 100644
index 0000000..01ab166
--- /dev/null
+++ b/drivers/scsi/ufs/ufs_quirks.h
@@ -0,0 +1,124 @@
+/*
+ * Copyright (c) 2014-2016, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef _UFS_QUIRKS_H_
+#define _UFS_QUIRKS_H_
+
+/* return true if s1 is a prefix of s2 */
+#define STR_PRFX_EQUAL(s1, s2) !strncmp(s1, s2, strlen(s1))
+
+#define UFS_ANY_VENDOR -1
+#define UFS_ANY_MODEL  "ANY_MODEL"
+
+#define MAX_MODEL_LEN 16
+
+#define UFS_VENDOR_TOSHIBA     0x198
+#define UFS_VENDOR_SAMSUNG     0x1CE
+
+/**
+ * ufs_device_info - ufs device details
+ * @wmanufacturerid: card details
+ * @model: card model
+ */
+struct ufs_device_info {
+	u16 wmanufacturerid;
+	char model[MAX_MODEL_LEN + 1];
+};
+
+/**
+ * ufs_dev_fix - ufs device quirk info
+ * @card: ufs card details
+ * @quirk: device quirk
+ */
+struct ufs_dev_fix {
+	struct ufs_device_info card;
+	unsigned int quirk;
+};
+
+#define END_FIX { { 0 }, 0 }
+
+/* add specific device quirk */
+#define UFS_FIX(_vendor, _model, _quirk) \
+		{					  \
+			.card.wmanufacturerid = (_vendor),\
+			.card.model = (_model),		  \
+			.quirk = (_quirk),		  \
+		}
+
+/*
+ * If UFS device is having issue in processing LCC (Line Control
+ * Command) coming from UFS host controller then enable this quirk.
+ * When this quirk is enabled, host controller driver should disable
+ * the LCC transmission on UFS host controller (by clearing
+ * TX_LCC_ENABLE attribute of host to 0).
+ */
+#define UFS_DEVICE_QUIRK_BROKEN_LCC (1 << 0)
+
+/*
+ * Some UFS devices don't need VCCQ rail for device operations. Enabling this
+ * quirk for such devices will make sure that VCCQ rail is not voted.
+ */
+#define UFS_DEVICE_NO_VCCQ (1 << 1)
+
+/*
+ * Some vendor's UFS device sends back to back NACs for the DL data frames
+ * causing the host controller to raise the DFES error status. Sometimes
+ * such UFS devices send back to back NAC without waiting for new
+ * retransmitted DL frame from the host and in such cases it might be possible
+ * the Host UniPro goes into bad state without raising the DFES error
+ * interrupt. If this happens then all the pending commands would timeout
+ * only after respective SW command (which is generally too large).
+ *
+ * We can workaround such device behaviour like this:
+ * - As soon as SW sees the DL NAC error, it should schedule the error handler
+ * - Error handler would sleep for 50ms to see if there are any fatal errors
+ *   raised by UFS controller.
+ *    - If there are fatal errors then SW does normal error recovery.
+ *    - If there are no fatal errors then SW sends the NOP command to device
+ *      to check if link is alive.
+ *        - If NOP command times out, SW does normal error recovery
+ *        - If NOP command succeed, skip the error handling.
+ *
+ * If DL NAC error is seen multiple times with some vendor's UFS devices then
+ * enable this quirk to initiate quick error recovery and also silence related
+ * error logs to reduce spamming of kernel logs.
+ */
+#define UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS (1 << 2)
+
+/*
+ * Some UFS devices may not work properly after resume if the link was kept
+ * in off state during suspend. Enabling this quirk will not allow the
+ * link to be kept in off state during suspend.
+ */
+#define UFS_DEVICE_QUIRK_NO_LINK_OFF	(1 << 3)
+
+/*
+ * Few Toshiba UFS device models advertise RX_MIN_ACTIVATETIME_CAPABILITY as
+ * 600us which may not be enough for reliable hibern8 exit hardware sequence
+ * from UFS device.
+ * To workaround this issue, host should set its PA_TACTIVATE time to 1ms even
+ * if device advertises RX_MIN_ACTIVATETIME_CAPABILITY less than 1ms.
+ */
+#define UFS_DEVICE_QUIRK_PA_TACTIVATE	(1 << 4)
+
+/*
+ * Some UFS memory devices may have really low read/write throughput in
+ * FAST AUTO mode, enable this quirk to make sure that FAST AUTO mode is
+ * never enabled for such devices.
+ */
+#define UFS_DEVICE_NO_FASTAUTO		(1 << 5)
+
+struct ufs_hba;
+void ufs_advertise_fixup_device(struct ufs_hba *hba);
+#endif /* UFS_QUIRKS_H_ */
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e2ed415..91a341b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -42,6 +42,7 @@
 #include <linux/nls.h>
 #include <linux/of.h>
 #include "ufshcd.h"
+#include "ufs_quirks.h"
 #include "unipro.h"
 
 #define UFSHCD_ENABLE_INTRS	(UTP_TRANSFER_REQ_COMPL |\
@@ -4591,6 +4592,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 	if (ret)
 		goto out;
 
+	ufs_advertise_fixup_device(hba);
 	/* UFS device is also active now */
 	ufshcd_set_ufs_dev_active(hba);
 	ufshcd_force_reset_auto_bkops(hba);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 54e13cc..77e79c0 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -470,6 +470,9 @@ struct ufs_hba {
 
 	unsigned int quirks;	/* Deviations from standard UFSHCI spec. */
 
+	/* Device deviations from standard UFS device spec. */
+	unsigned int dev_quirks;
+
 	wait_queue_head_t tm_wq;
 	wait_queue_head_t tm_tag_wq;
 	unsigned long tm_condition;
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
