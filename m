From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] ufs: Fix kernel-doc errors and warnings
Date: Tue, 13 Feb 2018 09:22:07 -0800
Message-ID: <20180213172207.21965-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:33970 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964849AbeBMRWI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Feb 2018 12:22:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Vivek Gautam <vivek.gautam@codeaurora.org>

Avoid that the kernel-doc tool complains about mismatches between
kernel-doc headers and function definitions. Avoid that errors like
the following are reported when building the UFS driver with W=1:

drivers/scsi/ufs/tc-dwc-g210-pci.c:60: error: Cannot parse struct or union!
drivers/scsi/ufs/tc-dwc-g210-pltfrm.c:26: warning: cannot understand function prototype: 'struct ufs_hba_variant_ops tc_dwc_g210_20bit_pltfm_hba_vops = '

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Vivek Gautam <vivek.gautam@codeaurora.org>
---
 drivers/scsi/ufs/tc-dwc-g210-pci.c    |  4 +-
 drivers/scsi/ufs/tc-dwc-g210-pltfrm.c |  2 +-
 drivers/scsi/ufs/ufshcd-pci.c         |  7 ++-
 drivers/scsi/ufs/ufshcd.c             | 94 +++++++++++++++++------------------
 4 files changed, 53 insertions(+), 54 deletions(-)

diff --git a/drivers/scsi/ufs/tc-dwc-g210-pci.c b/drivers/scsi/ufs/tc-dwc-g210-pci.c
index 325d5e14fc0d..2f41722a8c28 100644
--- a/drivers/scsi/ufs/tc-dwc-g210-pci.c
+++ b/drivers/scsi/ufs/tc-dwc-g210-pci.c
@@ -51,7 +51,7 @@ static int tc_dwc_g210_pci_runtime_idle(struct device *dev)
 	return ufshcd_runtime_idle(dev_get_drvdata(dev));
 }
 
-/**
+/*
  * struct ufs_hba_dwc_vops - UFS DWC specific variant operations
  */
 static struct ufs_hba_variant_ops tc_dwc_g210_pci_hba_vops = {
@@ -71,7 +71,7 @@ static void tc_dwc_g210_pci_shutdown(struct pci_dev *pdev)
 /**
  * tc_dwc_g210_pci_remove - de-allocate PCI/SCSI host and host memory space
  *		data structure memory
- * @pdev - pointer to PCI handle
+ * @pdev: pointer to PCI handle
  */
 static void tc_dwc_g210_pci_remove(struct pci_dev *pdev)
 {
diff --git a/drivers/scsi/ufs/tc-dwc-g210-pltfrm.c b/drivers/scsi/ufs/tc-dwc-g210-pltfrm.c
index 2d3f5270f875..6dfe5a9206e9 100644
--- a/drivers/scsi/ufs/tc-dwc-g210-pltfrm.c
+++ b/drivers/scsi/ufs/tc-dwc-g210-pltfrm.c
@@ -20,7 +20,7 @@
 #include "ufshcd-dwc.h"
 #include "tc-dwc-g210.h"
 
-/**
+/*
  * UFS DWC specific variant operations
  */
 static struct ufs_hba_variant_ops tc_dwc_g210_20bit_pltfm_hba_vops = {
diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index 925b0ec7ec54..ffe6f82182ba 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -75,8 +75,7 @@ static struct ufs_hba_variant_ops ufs_intel_cnl_hba_vops = {
 #ifdef CONFIG_PM_SLEEP
 /**
  * ufshcd_pci_suspend - suspend power management function
- * @pdev: pointer to PCI device handle
- * @state: power state
+ * @dev: pointer to PCI device handle
  *
  * Returns 0 if successful
  * Returns non-zero otherwise
@@ -88,7 +87,7 @@ static int ufshcd_pci_suspend(struct device *dev)
 
 /**
  * ufshcd_pci_resume - resume power management function
- * @pdev: pointer to PCI device handle
+ * @dev: pointer to PCI device handle
  *
  * Returns 0 if successful
  * Returns non-zero otherwise
@@ -126,7 +125,7 @@ static void ufshcd_pci_shutdown(struct pci_dev *pdev)
 /**
  * ufshcd_pci_remove - de-allocate PCI/SCSI host and host memory space
  *		data structure memory
- * @pdev - pointer to PCI handle
+ * @pdev: pointer to PCI handle
  */
 static void ufshcd_pci_remove(struct pci_dev *pdev)
 {
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c7da2c185990..15d0f44563f8 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -87,6 +87,8 @@
 /* Interrupt aggregation default timeout, unit: 40us */
 #define INT_AGGR_DEF_TO	0x02
 
+#define ASCII_STD true
+
 #define ufshcd_toggle_vreg(_dev, _vreg, _on)				\
 	({                                                              \
 		int _ret;                                               \
@@ -523,7 +525,7 @@ int ufshcd_wait_for_register(struct ufs_hba *hba, u32 reg, u32 mask,
 
 /**
  * ufshcd_get_intr_mask - Get the interrupt bit mask
- * @hba - Pointer to adapter instance
+ * @hba: Pointer to adapter instance
  *
  * Returns interrupt bit mask per version
  */
@@ -550,7 +552,7 @@ static inline u32 ufshcd_get_intr_mask(struct ufs_hba *hba)
 
 /**
  * ufshcd_get_ufs_version - Get the UFS version supported by the HBA
- * @hba - Pointer to adapter instance
+ * @hba: Pointer to adapter instance
  *
  * Returns UFSHCI version supported by the controller
  */
@@ -577,7 +579,7 @@ static inline bool ufshcd_is_device_present(struct ufs_hba *hba)
 
 /**
  * ufshcd_get_tr_ocs - Get the UTRD Overall Command Status
- * @lrb: pointer to local command reference block
+ * @lrbp: pointer to local command reference block
  *
  * This function is used to get the OCS field from UTRD
  * Returns the OCS field in the UTRD
@@ -1759,7 +1761,7 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
 
 /**
  * ufshcd_copy_sense_data - Copy sense data in case of check condition
- * @lrb - pointer to local reference block
+ * @lrbp: pointer to local reference block
  */
 static inline void ufshcd_copy_sense_data(struct ufshcd_lrb *lrbp)
 {
@@ -1781,7 +1783,7 @@ static inline void ufshcd_copy_sense_data(struct ufshcd_lrb *lrbp)
  * ufshcd_copy_query_response() - Copy the Query Response and the data
  * descriptor
  * @hba: per adapter instance
- * @lrb - pointer to local reference block
+ * @lrbp: pointer to local reference block
  */
 static
 int ufshcd_copy_query_response(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
@@ -1882,7 +1884,7 @@ ufshcd_dispatch_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 /**
  * ufshcd_wait_for_uic_cmd - Wait complectioin of UIC command
  * @hba: per adapter instance
- * @uic_command: UIC command
+ * @uic_cmd: UIC command
  *
  * Must be called with mutex held.
  * Returns 0 only if success.
@@ -1965,7 +1967,8 @@ ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 
 /**
  * ufshcd_map_sg - Map scatter-gather list to prdt
- * @lrbp - pointer to local reference block
+ * @hba: per adapter instance
+ * @lrbp: pointer to local reference block
  *
  * Returns 0 in case of success, non-zero value in case of failure
  */
@@ -2101,8 +2104,8 @@ static void ufshcd_prepare_req_desc_hdr(struct ufshcd_lrb *lrbp,
 /**
  * ufshcd_prepare_utp_scsi_cmd_upiu() - fills the utp_transfer_req_desc,
  * for scsi commands
- * @lrbp - local reference block pointer
- * @upiu_flags - flags
+ * @lrbp: local reference block pointer
+ * @upiu_flags: flags
  */
 static
 void ufshcd_prepare_utp_scsi_cmd_upiu(struct ufshcd_lrb *lrbp, u32 upiu_flags)
@@ -2190,8 +2193,8 @@ static inline void ufshcd_prepare_utp_nop_upiu(struct ufshcd_lrb *lrbp)
 /**
  * ufshcd_comp_devman_upiu - UFS Protocol Information Unit(UPIU)
  *			     for Device Management Purposes
- * @hba - per adapter instance
- * @lrb - pointer to local reference block
+ * @hba: per adapter instance
+ * @lrbp: pointer to local reference block
  */
 static int ufshcd_comp_devman_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 {
@@ -2218,8 +2221,8 @@ static int ufshcd_comp_devman_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 /**
  * ufshcd_comp_scsi_upiu - UFS Protocol Information Unit(UPIU)
  *			   for SCSI Purposes
- * @hba - per adapter instance
- * @lrb - pointer to local reference block
+ * @hba: per adapter instance
+ * @lrbp: pointer to local reference block
  */
 static int ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 {
@@ -2260,7 +2263,7 @@ static inline u8 ufshcd_scsi_to_upiu_lun(unsigned int scsi_lun)
 
 /**
  * ufshcd_upiu_wlun_to_scsi_wlun - maps UPIU W-LUN id to SCSI W-LUN ID
- * @scsi_lun: UPIU W-LUN id
+ * @upiu_wlun_id: UPIU W-LUN id
  *
  * Returns SCSI W-LUN id
  */
@@ -2271,8 +2274,8 @@ static inline u16 ufshcd_upiu_wlun_to_scsi_wlun(u8 upiu_wlun_id)
 
 /**
  * ufshcd_queuecommand - main entry point for SCSI requests
+ * @host: SCSI host pointer
  * @cmd: command from SCSI Midlayer
- * @done: call back function
  *
  * Returns 0 for success, non-zero in case of failure
  */
@@ -2513,7 +2516,7 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
 /**
  * ufshcd_get_dev_cmd_tag - Get device management command tag
  * @hba: per-adapter instance
- * @tag: pointer to variable with available slot value
+ * @tag_out: pointer to variable with available slot value
  *
  * Get a free slot and lock it until device management command
  * completes.
@@ -2550,9 +2553,9 @@ static inline void ufshcd_put_dev_cmd_tag(struct ufs_hba *hba, int tag)
 
 /**
  * ufshcd_exec_dev_cmd - API for sending device management requests
- * @hba - UFS hba
- * @cmd_type - specifies the type (NOP, Query...)
- * @timeout - time in seconds
+ * @hba: UFS hba
+ * @cmd_type: specifies the type (NOP, Query...)
+ * @timeout: time in seconds
  *
  * NOTE: Since there is only one available tag for device management commands,
  * it is expected you hold the hba->dev_cmd.lock mutex.
@@ -2649,10 +2652,10 @@ static int ufshcd_query_flag_retry(struct ufs_hba *hba,
 
 /**
  * ufshcd_query_flag() - API function for sending flag query requests
- * hba: per-adapter instance
- * query_opcode: flag query to perform
- * idn: flag idn to access
- * flag_res: the flag value after the query request completes
+ * @hba: per-adapter instance
+ * @opcode: flag query to perform
+ * @idn: flag idn to access
+ * @flag_res: the flag value after the query request completes
  *
  * Returns 0 for success, non-zero in case of failure
  */
@@ -2716,12 +2719,12 @@ int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 
 /**
  * ufshcd_query_attr - API function for sending attribute requests
- * hba: per-adapter instance
- * opcode: attribute opcode
- * idn: attribute idn to access
- * index: index field
- * selector: selector field
- * attr_val: the attribute value after the query request completes
+ * @hba: per-adapter instance
+ * @opcode: attribute opcode
+ * @idn: attribute idn to access
+ * @index: index field
+ * @selector: selector field
+ * @attr_val: the attribute value after the query request completes
  *
  * Returns 0 for success, non-zero in case of failure
 */
@@ -2880,15 +2883,14 @@ static int __ufshcd_query_descriptor(struct ufs_hba *hba,
 }
 
 /**
- * ufshcd_query_descriptor_retry - API function for sending descriptor
- * requests
- * hba: per-adapter instance
- * opcode: attribute opcode
- * idn: attribute idn to access
- * index: index field
- * selector: selector field
- * desc_buf: the buffer that contains the descriptor
- * buf_len: length parameter passed to the device
+ * ufshcd_query_descriptor_retry - API function for sending descriptor requests
+ * @hba: per-adapter instance
+ * @opcode: attribute opcode
+ * @idn: attribute idn to access
+ * @index: index field
+ * @selector: selector field
+ * @desc_buf: the buffer that contains the descriptor
+ * @buf_len: length parameter passed to the device
  *
  * Returns 0 for success, non-zero in case of failure.
  * The buf_len parameter will contain, on return, the length parameter
@@ -3110,7 +3112,6 @@ static int ufshcd_read_device_desc(struct ufs_hba *hba, u8 *buf, u32 size)
  *
  * Return 0 in case of success, non-zero otherwise
  */
-#define ASCII_STD true
 static int ufshcd_read_string_desc(struct ufs_hba *hba, int desc_index,
 				   u8 *buf, u32 size, bool ascii)
 {
@@ -3912,7 +3913,7 @@ static int ufshcd_config_pwr_mode(struct ufs_hba *hba,
 
 /**
  * ufshcd_complete_dev_init() - checks device readiness
- * hba: per-adapter instance
+ * @hba: per-adapter instance
  *
  * Set fDeviceInit flag and poll until device toggles it.
  */
@@ -4453,7 +4454,7 @@ static int ufshcd_task_req_compl(struct ufs_hba *hba, u32 index, u8 *resp)
 
 /**
  * ufshcd_scsi_cmd_status - Update SCSI command result based on SCSI status
- * @lrb: pointer to local reference block of completed command
+ * @lrbp: pointer to local reference block of completed command
  * @scsi_status: SCSI command status
  *
  * Returns value base on SCSI command status
@@ -4488,7 +4489,7 @@ ufshcd_scsi_cmd_status(struct ufshcd_lrb *lrbp, int scsi_status)
 /**
  * ufshcd_transfer_rsp_status - Get overall status of the response
  * @hba: per adapter instance
- * @lrb: pointer to local reference block of completed command
+ * @lrbp: pointer to local reference block of completed command
  *
  * Returns result of the command to notify SCSI midlayer
  */
@@ -5796,7 +5797,7 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba)
 
 /**
  * ufshcd_eh_host_reset_handler - host reset handler registered to scsi layer
- * @cmd - SCSI command pointer
+ * @cmd: SCSI command pointer
  *
  * Returns SUCCESS/FAILED
  */
@@ -5981,11 +5982,11 @@ static void ufshcd_init_icc_levels(struct ufs_hba *hba)
  * will take effect only when its sent to "UFS device" well known logical unit
  * hence we require the scsi_device instance to represent this logical unit in
  * order for the UFS host driver to send the SSU command for power management.
-
+ *
  * We also require the scsi_device instance for "RPMB" (Replay Protected Memory
  * Block) LU so user space process can control this LU. User space may also
  * want to have access to BOOT LU.
-
+ *
  * This function adds scsi device instances for each of all well known LUs
  * (except "REPORT LUNS" LU).
  *
@@ -7436,7 +7437,6 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 /**
  * ufshcd_system_suspend - system suspend routine
  * @hba: per adapter instance
- * @pm_op: runtime PM or system PM
  *
  * Check the description of ufshcd_suspend() function for more details.
  *
@@ -7747,7 +7747,7 @@ EXPORT_SYMBOL(ufshcd_shutdown);
 /**
  * ufshcd_remove - de-allocate SCSI host and host memory space
  *		data structure memory
- * @hba - per adapter instance
+ * @hba: per adapter instance
  */
 void ufshcd_remove(struct ufs_hba *hba)
 {
-- 
2.16.1
