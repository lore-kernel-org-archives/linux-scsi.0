From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH V2 21/24] aacraid: Retrieve HBA host information ioctl
Date: Wed, 25 Jan 2017 10:01:08 -0800
Message-ID: <20170125180111.25401-22-RaghavaAditya.Renukunta@microsemi.com>
References: <20170125180111.25401-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0082.outbound.protection.outlook.com ([104.47.42.82]:39136
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752114AbdAZAiW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Jan 2017 19:38:22 -0500
In-Reply-To: <20170125180111.25401-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, RaghavaAditya.Renukunta@microsemi.com, Scott.Benesh@microsemi.com

Added a new ioctl interface to retrieve the host device information.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>

---
 Changes in  V2:
  None

 drivers/scsi/aacraid/aacraid.h  | 52 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/aacraid/commctrl.c | 26 +++++++++++++++++++++
 2 files changed, 78 insertions(+)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 5342a7a..44dcf36 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -2338,6 +2338,7 @@ struct revision
 #define FSACTL_GET_CONTAINERS			2131
 #define FSACTL_SEND_LARGE_FIB			CTL_CODE(2138, METHOD_BUFFERED)
 #define FSACTL_RESET_IOP			CTL_CODE(2140, METHOD_BUFFERED)
+#define FSACTL_GET_HBA_INFO			CTL_CODE(2150, METHOD_BUFFERED)
 /* flags defined for IOP & HW SOFT RESET */
 #define HW_IOP_RESET				0x01
 #define HW_SOFT_RESET				0x02
@@ -2377,6 +2378,57 @@ struct aac_common
 extern struct aac_common aac_config;
 
 /*
+ * This is for management ioctl purpose only.
+ */
+struct aac_hba_info {
+
+	u8	DriverName[50];
+	u8	AdapterNumber;
+	u8	SystemIoBusNumber;
+	u8	DeviceNumber;
+	u32	FunctionNumber;
+	u32	VendorID;
+	u32	DeviceID;
+	u32	SubVendorID;
+	u32	SubSystemID;
+	u32	MappedBaseAddressSize;
+	u32	BasePhysicalAddress_HighPart;
+	u32	BasePhysicalAddress_LowPart;
+
+	u32	MaxCommandSize;
+	u32	MaxFibSize;
+	u32	MaxScatterGatherFromOs;
+	u32	MaxScatterGatherToFw;
+	u32	MaxOutstandingFibs;
+
+	u32	QueueStartThreshold;
+	u32	QueueDumpThreshold;
+	u32	MaxIoSizeQueued;
+	u32	OutstandingIO;
+
+	u32	FirmwareBuildNumber;
+	u32	BIOSBuildNumber;
+	u32	DriverBuildNumber;
+	u32	SerialNumber_HighPart;
+	u32	SerialNumber_LowPart;
+	u32	SupportedOptions;
+	u32	FeatureBits;
+	u32	currentnumberPorts;
+
+	u8	NewCommInterface:1;
+	u8	NewCommandsSupported:1;
+	u8	DisablePassthrough:1;
+	u8	ExposeNonDasd:1;
+	u8	QueueAllowed:1;
+	u8	BLEDCheckEnabled:1;
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
index 4b65b91..9ade2b4 100644
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
+	hbainfo.AdapterNumber		= (u8) dev->id;
+	hbainfo.SystemIoBusNumber	= dev->pdev->bus->number;
+	hbainfo.DeviceNumber		= (dev->pdev->devfn >> 3);
+	hbainfo.FunctionNumber		= (dev->pdev->devfn & 0x0007);
+
+	hbainfo.VendorID		= dev->pdev->vendor;
+	hbainfo.DeviceID		= dev->pdev->device;
+	hbainfo.SubVendorID		= dev->pdev->subsystem_vendor;
+	hbainfo.SubSystemID		= dev->pdev->subsystem_device;
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

