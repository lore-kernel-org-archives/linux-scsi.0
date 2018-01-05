From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 13/14] megaraid_sas: NVME passthru command support
Date: Fri,  5 Jan 2018 05:27:48 -0800
Message-ID: <1515158869-26693-14-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1515158869-26693-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:43585 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751312AbeAEN3n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jan 2018 08:29:43 -0500
Received: by mail-pl0-f66.google.com with SMTP id z5so3041098plo.10
        for <linux-scsi@vger.kernel.org>; Fri, 05 Jan 2018 05:29:43 -0800 (PST)
In-Reply-To: <1515158869-26693-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Feature - NVME pass-through via MFI interface.
Current MR product support different encapsulation via MFI frame work.

NVME native command should be framed by application and it should be embedded
in MFI as payload.
Driver will provide interface to send MFI frame along with payload
(In this case, payload is NVME native command) to the Firmware.
Driver already had such generic interface for SATA, SMP pass-through.
Changes are explained below.

1. Driver will pass MFI command to the FW, if FW support NVME encapsulated
processing (not all SAS3.5 firmware supports this feature).
2. Driver expose sysfs entry “support_nvme_encapsulation”. This is required for
backward compatibility for applications using earlier driver versions
that did not process IOCTL frames and could result in host hang.
This is already fixed as part of
commit 82add4e1b354 ("scsi: megaraid_sas: Incorrect processing of IOCTL frames for SMP/STP commands")

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        | 30 +++++++++++++++++++++++++----
 drivers/scsi/megaraid/megaraid_sas_base.c   | 30 ++++++++++++++++++++++++++++-
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  7 +++++++
 3 files changed, 62 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 14b82c0b0461..d557ff03eb1d 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -197,6 +197,7 @@ enum MFI_CMD_OP {
 	MFI_CMD_ABORT		= 0x6,
 	MFI_CMD_SMP		= 0x7,
 	MFI_CMD_STP		= 0x8,
+	MFI_CMD_NVME		= 0x9,
 	MFI_CMD_OP_COUNT,
 	MFI_CMD_INVALID		= 0xff
 };
@@ -1352,7 +1353,13 @@ struct megasas_ctrl_info {
 
 	struct {
 	#if defined(__BIG_ENDIAN_BITFIELD)
-		u16 reserved:8;
+		u16 reserved:2;
+		u16 support_nvme_passthru:1;
+		u16 support_pl_debug_info:1;
+		u16 support_flash_comp_info:1;
+		u16 support_host_info:1;
+		u16 support_dual_fw_update:1;
+		u16 support_ssc_rev3:1;
 		u16 fw_swaps_bbu_vpd_info:1;
 		u16 support_pd_map_target_id:1;
 		u16 support_ses_ctrl_in_multipathcfg:1;
@@ -1377,7 +1384,19 @@ struct megasas_ctrl_info {
 		 *  provide the data in little endian order
 		 */
 		u16 fw_swaps_bbu_vpd_info:1;
-		u16 reserved:8;
+		u16 support_ssc_rev3:1;
+		/* FW supports CacheCade 3.0, only one SSCD creation allowed */
+		u16 support_dual_fw_update:1;
+		/* FW supports dual firmware update feature */
+		u16 support_host_info:1;
+		/* FW supports MR_DCMD_CTRL_HOST_INFO_SET/GET */
+		u16 support_flash_comp_info:1;
+		/* FW supports MR_DCMD_CTRL_FLASH_COMP_INFO_GET */
+		u16 support_pl_debug_info:1;
+		/* FW supports retrieval of PL debug information through apps */
+		u16 support_nvme_passthru:1;
+		/* FW supports NVMe passthru commands */
+		u16 reserved:2;
 	#endif
 		} adapter_operations4;
 	u8 pad[0x800 - 0x7FE]; /* 0x7FE pad to 2K for expansion */
@@ -1630,7 +1649,8 @@ union megasas_sgl_frame {
 typedef union _MFI_CAPABILITIES {
 	struct {
 #if   defined(__BIG_ENDIAN_BITFIELD)
-	u32     reserved:18;
+	u32     reserved:17;
+	u32	support_nvme_passthru:1;
 	u32     support_64bit_mode:1;
 	u32 support_pd_map_target_id:1;
 	u32     support_qd_throttling:1;
@@ -1660,7 +1680,8 @@ typedef union _MFI_CAPABILITIES {
 	u32     support_qd_throttling:1;
 	u32	support_pd_map_target_id:1;
 	u32     support_64bit_mode:1;
-	u32     reserved:18;
+	u32	support_nvme_passthru:1;
+	u32     reserved:17;
 #endif
 	} mfi_capabilities;
 	__le32		reg;
@@ -2268,6 +2289,7 @@ struct megasas_instance {
 	u32 nvme_page_size;
 	u8 adapter_type;
 	bool consistent_mask_64bit;
+	bool support_nvme_passthru;
 };
 struct MR_LD_VF_MAP {
 	u32 size;
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index d92279eec8f8..0f1d88f272be 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -181,6 +181,7 @@ static DECLARE_WAIT_QUEUE_HEAD(megasas_poll_wait);
 static u32 support_poll_for_event;
 u32 megasas_dbg_lvl;
 static u32 support_device_change;
+static bool support_nvme_encapsulation;
 
 /* define lock for aen poll */
 spinlock_t poll_aen_lock;
@@ -3334,6 +3335,7 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 
 	case MFI_CMD_SMP:
 	case MFI_CMD_STP:
+	case MFI_CMD_NVME:
 		megasas_complete_int_cmd(instance, cmd);
 		break;
 
@@ -4721,6 +4723,8 @@ megasas_get_ctrl_info(struct megasas_instance *instance)
 			ci->adapterOperations3.useSeqNumJbodFP;
 		instance->support_morethan256jbod =
 			ci->adapter_operations4.support_pd_map_target_id;
+		instance->support_nvme_passthru =
+			ci->adapter_operations4.support_nvme_passthru;
 
 		/*Check whether controller is iMR or MR */
 		instance->is_imr = (ci->memory_size ? 0 : 1);
@@ -4737,6 +4741,8 @@ megasas_get_ctrl_info(struct megasas_instance *instance)
 			instance->disableOnlineCtrlReset ? "Disabled" : "Enabled");
 		dev_info(&instance->pdev->dev, "Secure JBOD support\t: %s\n",
 			instance->secure_jbod_support ? "Yes" : "No");
+		dev_info(&instance->pdev->dev, "NVMe passthru support\t: %s\n",
+			 instance->support_nvme_passthru ? "Yes" : "No");
 		break;
 
 	case DCMD_TIMEOUT:
@@ -7110,7 +7116,9 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 		return -EINVAL;
 	}
 
-	if (ioc->frame.hdr.cmd >= MFI_CMD_OP_COUNT) {
+	if ((ioc->frame.hdr.cmd >= MFI_CMD_OP_COUNT) ||
+	    ((ioc->frame.hdr.cmd == MFI_CMD_NVME) &&
+	    !instance->support_nvme_passthru)) {
 		dev_err(&instance->pdev->dev,
 			"Received invalid ioctl command 0x%x\n",
 			ioc->frame.hdr.cmd);
@@ -7580,6 +7588,14 @@ static ssize_t dbg_lvl_store(struct device_driver *dd, const char *buf,
 }
 static DRIVER_ATTR_RW(dbg_lvl);
 
+static ssize_t
+support_nvme_encapsulation_show(struct device_driver *dd, char *buf)
+{
+	return sprintf(buf, "%u\n", support_nvme_encapsulation);
+}
+
+static DRIVER_ATTR_RO(support_nvme_encapsulation);
+
 static inline void megasas_remove_scsi_device(struct scsi_device *sdev)
 {
 	sdev_printk(KERN_INFO, sdev, "SCSI device is removed\n");
@@ -7768,6 +7784,7 @@ static int __init megasas_init(void)
 
 	support_poll_for_event = 2;
 	support_device_change = 1;
+	support_nvme_encapsulation = true;
 
 	memset(&megasas_mgmt_info, 0, sizeof(megasas_mgmt_info));
 
@@ -7817,8 +7834,17 @@ static int __init megasas_init(void)
 	if (rval)
 		goto err_dcf_support_device_change;
 
+	rval = driver_create_file(&megasas_pci_driver.driver,
+				  &driver_attr_support_nvme_encapsulation);
+	if (rval)
+		goto err_dcf_support_nvme_encapsulation;
+
 	return rval;
 
+err_dcf_support_nvme_encapsulation:
+	driver_remove_file(&megasas_pci_driver.driver,
+			   &driver_attr_support_device_change);
+
 err_dcf_support_device_change:
 	driver_remove_file(&megasas_pci_driver.driver,
 			   &driver_attr_dbg_lvl);
@@ -7851,6 +7877,8 @@ static void __exit megasas_exit(void)
 	driver_remove_file(&megasas_pci_driver.driver,
 			   &driver_attr_release_date);
 	driver_remove_file(&megasas_pci_driver.driver, &driver_attr_version);
+	driver_remove_file(&megasas_pci_driver.driver,
+			   &driver_attr_support_nvme_encapsulation);
 
 	pci_unregister_driver(&megasas_pci_driver);
 	unregister_chrdev(megasas_mgmt_majorno, "megaraid_sas_ioctl");
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 0a85f3c48ef6..f3940b6af290 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1080,6 +1080,7 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 
 	drv_ops->mfi_capabilities.support_qd_throttling = 1;
 	drv_ops->mfi_capabilities.support_pd_map_target_id = 1;
+	drv_ops->mfi_capabilities.support_nvme_passthru = 1;
 
 	if (instance->consistent_mask_64bit)
 		drv_ops->mfi_capabilities.support_64bit_mode = 1;
@@ -3994,7 +3995,13 @@ void megasas_refire_mgmt_cmd(struct megasas_instance *instance)
 				result = RETURN_CMD;
 
 			break;
+		case MFI_CMD_NVME:
+			if (!instance->support_nvme_passthru) {
+				cmd_mfi->frame->hdr.cmd_status = MFI_STAT_INVALID_CMD;
+				result = COMPLETE_CMD;
+			}
 
+			break;
 		default:
 			break;
 		}
-- 
2.14.1
