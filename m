From: Arvind Kumar <arvindkumar@vmware.com>
Subject: [PATCH 2/3] VMW_PVSCSI: Add support for I/O requests coalescing.
Date: Sat, 08 Mar 2014 12:59:39 -0800
Message-ID: <1394312380.8462.27.camel@arvindkumar-dev1.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:42617 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751721AbaCHVHD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Mar 2014 16:07:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: pv-drivers@vmware.com, rmehta@vmware.com

This change allows pvscsi driver to coalesce I/O requests
before issuing them. The number of I/O's coalesced can be
dynamically configured based on the workload.

Signed-off-by: Rishi Mehta <rmehta@vmware.com>
Acked-by: Arvind Kumar <arvindkumar@vmware.com>
Cc: Rishi Mehta <rmehta@vmware.com>
---
 drivers/scsi/vmw_pvscsi.c |   49 ++++++++++++++++++++++++++++++++++++++++++---
 drivers/scsi/vmw_pvscsi.h |   17 +++++++++++++---
 2 files changed, 60 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 7c5abd7..0591cff 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -72,6 +72,7 @@ struct pvscsi_adapter {
 	bool				use_msi;
 	bool				use_msix;
 	bool				use_msg;
+	bool				use_req_threshold;
 
 	spinlock_t			hw_lock;
 
@@ -109,6 +110,7 @@ static int pvscsi_cmd_per_lun    = PVSCSI_DEFAULT_QUEUE_DEPTH;
 static bool pvscsi_disable_msi;
 static bool pvscsi_disable_msix;
 static bool pvscsi_use_msg       = true;
+static bool pvscsi_use_req_threshold = true;
 
 #define PVSCSI_RW (S_IRUSR | S_IWUSR)
 
@@ -133,6 +135,10 @@ MODULE_PARM_DESC(disable_msix, "Disable MSI-X use in driver - (default=0)");
 module_param_named(use_msg, pvscsi_use_msg, bool, PVSCSI_RW);
 MODULE_PARM_DESC(use_msg, "Use msg ring when available - (default=1)");
 
+module_param_named(use_req_threshold, pvscsi_use_req_threshold,
+		   bool, PVSCSI_RW);
+MODULE_PARM_DESC(use_req_threshold, "Use driver-based request coalescing if configured - (default=1)");
+
 static const struct pci_device_id pvscsi_pci_tbl[] = {
 	{ PCI_VDEVICE(VMWARE, PCI_DEVICE_ID_VMWARE_PVSCSI) },
 	{ 0 }
@@ -282,10 +288,15 @@ static int scsi_is_rw(unsigned char op)
 static void pvscsi_kick_io(const struct pvscsi_adapter *adapter,
 			   unsigned char op)
 {
-	if (scsi_is_rw(op))
-		pvscsi_kick_rw_io(adapter);
-	else
+	if (scsi_is_rw(op)) {
+		struct PVSCSIRingsState *s = adapter->rings_state;
+
+		if (!adapter->use_req_threshold ||
+		    s->reqProdIdx - s->reqConsIdx >= s->reqCallThreshold)
+			pvscsi_kick_rw_io(adapter);
+	} else {
 		pvscsi_process_request_ring(adapter);
+	}
 }
 
 static void ll_adapter_reset(const struct pvscsi_adapter *adapter)
@@ -1077,6 +1088,34 @@ static int pvscsi_setup_msg_workqueue(struct pvscsi_adapter *adapter)
 	return 1;
 }
 
+static bool pvscsi_setup_req_threshold(struct pvscsi_adapter *adapter,
+				      bool enable)
+{
+	u32 val;
+
+	if (!pvscsi_use_req_threshold)
+		return false;
+
+	pvscsi_reg_write(adapter, PVSCSI_REG_OFFSET_COMMAND,
+			 PVSCSI_CMD_SETUP_REQCALLTHRESHOLD);
+	val = pvscsi_reg_read(adapter, PVSCSI_REG_OFFSET_COMMAND_STATUS);
+	if (val == -1) {
+		printk(KERN_INFO "pvscsi: device does not support req_threshold\n");
+		return false;
+	} else {
+		struct PVSCSICmdDescSetupReqCall cmd_msg = { 0 };
+		cmd_msg.enable = enable;
+		printk(KERN_INFO
+		       "pvscsi: %sabling reqCallThreshold\n",
+			enable ? "en" : "dis");
+		pvscsi_write_cmd_desc(adapter,
+				      PVSCSI_CMD_SETUP_REQCALLTHRESHOLD,
+				      &cmd_msg, sizeof(cmd_msg));
+		return pvscsi_reg_read(adapter,
+				       PVSCSI_REG_OFFSET_COMMAND_STATUS) != 0;
+	}
+}
+
 static irqreturn_t pvscsi_isr(int irq, void *devp)
 {
 	struct pvscsi_adapter *adapter = devp;
@@ -1416,6 +1455,10 @@ static int pvscsi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		flags = IRQF_SHARED;
 	}
 
+	adapter->use_req_threshold = pvscsi_setup_req_threshold(adapter, true);
+	printk(KERN_DEBUG "pvscsi: driver-based request coalescing %sabled\n",
+	       adapter->use_req_threshold ? "en" : "dis");
+
 	error = request_irq(adapter->irq, pvscsi_isr, flags,
 			    "vmw_pvscsi", adapter);
 	if (error) {
diff --git a/drivers/scsi/vmw_pvscsi.h b/drivers/scsi/vmw_pvscsi.h
index a643775..15a9ac6 100644
--- a/drivers/scsi/vmw_pvscsi.h
+++ b/drivers/scsi/vmw_pvscsi.h
@@ -26,7 +26,7 @@
 
 #include <linux/types.h>
 
-#define PVSCSI_DRIVER_VERSION_STRING   "1.0.3.0-k"
+#define PVSCSI_DRIVER_VERSION_STRING   "1.0.4.0-k"
 
 #define PVSCSI_MAX_NUM_SG_ENTRIES_PER_SEGMENT 128
 
@@ -117,8 +117,9 @@ enum PVSCSICommands {
 	PVSCSI_CMD_CONFIG            = 7,
 	PVSCSI_CMD_SETUP_MSG_RING    = 8,
 	PVSCSI_CMD_DEVICE_UNPLUG     = 9,
+	PVSCSI_CMD_SETUP_REQCALLTHRESHOLD     = 10,
 
-	PVSCSI_CMD_LAST              = 10  /* has to be last */
+	PVSCSI_CMD_LAST              = 11  /* has to be last */
 };
 
 /*
@@ -141,6 +142,14 @@ struct PVSCSICmdDescConfigCmd {
 	u32 _pad;
 } __packed;
 
+/*
+ * Command descriptor for PVSCSI_CMD_SETUP_REQCALLTHRESHOLD --
+ */
+
+struct PVSCSICmdDescSetupReqCall {
+	u32 enable;
+} __packed;
+
 enum PVSCSIConfigPageType {
 	PVSCSI_CONFIG_PAGE_CONTROLLER = 0x1958,
 	PVSCSI_CONFIG_PAGE_PHY        = 0x1959,
@@ -261,7 +270,9 @@ struct PVSCSIRingsState {
 	u32	cmpConsIdx;
 	u32	cmpNumEntriesLog2;
 
-	u8	_pad[104];
+	u32	reqCallThreshold;
+
+	u8	_pad[100];
 
 	u32	msgProdIdx;
 	u32	msgConsIdx;
-- 
1.7.9.5



