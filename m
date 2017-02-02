From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH V4 21/24] aacraid: Retrieve HBA host information ioctl
Date: Thu, 2 Feb 2017 15:53:35 -0800
Message-ID: <20170202235338.14724-22-RaghavaAditya.Renukunta@microsemi.com>
References: <20170202235338.14724-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0085.outbound.protection.outlook.com ([104.47.34.85]:55746
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752579AbdBCGbO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Feb 2017 01:31:14 -0500
In-Reply-To: <20170202235338.14724-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, jthumshirn@suse.de

Added a new ioctl interface to retrieve the host device information.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---

Changes in  V2:
None

Changes in  V3:
None

Changes in  V4:
Removed camelcase

 drivers/scsi/aacraid/aacraid.h  | 52 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/aacraid/commctrl.c | 26 +++++++++++++++++++++
 2 files changed, 78 insertions(+)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 4814fba4..4073396 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -2334,6 +2334,7 @@ struct revision
 #define FSACTL_GET_CONTAINERS			2131
 #define FSACTL_SEND_LARGE_FIB			CTL_CODE(2138, METHOD_BUFFERED)
 #define FSACTL_RESET_IOP			CTL_CODE(2140, METHOD_BUFFERED)
+#define FSACTL_GET_HBA_INFO			CTL_CODE(2150, METHOD_BUFFERED)
 /* flags defined for IOP & HW SOFT RESET */
 #define HW_IOP_RESET				0x01
 #define HW_SOFT_RESET				0x02
@@ -2373,6 +2374,57 @@ struct aac_common
 extern struct aac_common aac_config;
 
 /*
+ * This is for management ioctl purpose only.
+ */
+struct aac_hba_info {
+
+	u8	driver_name[50];
+	u8	adapter_number;
+	u8	system_io_bus_number;
+	u8	device_number;
+	u32	function_number;
+	u32	vendor_id;
+	u32	device_id;
+	u32	sub_vendor_id;
+	u32	sub_system_id;
+	u32	mapped_base_address_size;
+	u32	base_physical_address_high_part;
+	u32	base_physical_address_low_part;
+
+	u32	max_command_size;
+	u32	max_fib_size;
+	u32	max_scatter_gather_from_os;
+	u32	max_scatter_gather_to_fw;
+	u32	max_outstanding_fibs;
+
+	u32	queue_start_threshold;
+	u32	queue_dump_threshold;
+	u32	max_io_size_queued;
+	u32	outstanding_io;
+
+	u32	firmware_build_number;
+	u32	bios_build_number;
+	u32	driver_build_number;
+	u32	serial_number_high_part;
+	u32	serial_number_low_part;
+	u32	supported_options;
+	u32	feature_bits;
+	u32	currentnumber_ports;
+
+	u8	new_comm_interface:1;
+	u8	new_commands_supported:1;
+	u8	disable_passthrough:1;
+	u8	expose_non_dasd:1;
+	u8	queue_allowed:1;
+	u8	bled_check_enabled:1;
+	u8	reserved1:1;
+	u8	reserted2:1;
+
+	u32	reserved3[10];
+
+};
+
+/*
  *	The following macro is used when sending and receiving FIBs. It is
  *	only used for debugging.
  */
diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index 4b65b91..9ef35ff 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -1011,6 +1011,29 @@ static int aac_get_pci_info(struct aac_dev* dev, void __user *arg)
 	}
 	return 0;
 }
+
+static int aac_get_hba_info(struct aac_dev *dev, void __user *arg)
+{
+	struct aac_hba_info hbainfo;
+
+	hbainfo.adapter_number		= (u8) dev->id;
+	hbainfo.system_io_bus_number	= dev->pdev->bus->number;
+	hbainfo.device_number		= (dev->pdev->devfn >> 3);
+	hbainfo.function_number		= (dev->pdev->devfn & 0x0007);
+
+	hbainfo.vendor_id		= dev->pdev->vendor;
+	hbainfo.device_id		= dev->pdev->device;
+	hbainfo.sub_vendor_id		= dev->pdev->subsystem_vendor;
+	hbainfo.sub_system_id		= dev->pdev->subsystem_device;
+
+	if (copy_to_user(arg, &hbainfo, sizeof(struct aac_hba_info))) {
+		dprintk((KERN_DEBUG "aacraid: Could not copy hba info\n"));
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
 struct aac_reset_iop {
 	u8	reset_type;
 };
@@ -1070,6 +1093,9 @@ int aac_do_ioctl(struct aac_dev * dev, int cmd, void __user *arg)
 	case FSACTL_GET_PCI_INFO:
 		status = aac_get_pci_info(dev,arg);
 		break;
+	case FSACTL_GET_HBA_INFO:
+		status = aac_get_hba_info(dev, arg);
+		break;
 	case FSACTL_RESET_IOP:
 		status = aac_send_reset_adapter(dev, arg);
 		break;
-- 
2.7.4
