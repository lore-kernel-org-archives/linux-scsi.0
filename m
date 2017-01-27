From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH V3 20/24] aacraid: Added ioctl to trigger IOP/IWBR reset
Date: Fri, 27 Jan 2017 11:28:49 -0800
Message-ID: <20170127192853.10082-21-RaghavaAditya.Renukunta@microsemi.com>
References: <20170127192853.10082-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0082.outbound.protection.outlook.com ([104.47.32.82]:43712
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750964AbdA1Cf4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Jan 2017 21:35:56 -0500
In-Reply-To: <20170127192853.10082-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com

Added a new ioctl interface to trigger an IOP or IWBR reset from ioctl.
Primary used by management utility to trigger resets.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>

---
Changes in  V2:
None

Changes in  V3:
None

 drivers/scsi/aacraid/aacraid.h  |  1 +
 drivers/scsi/aacraid/commctrl.c | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index e2df7a5..6b80a63 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -2337,6 +2337,7 @@ struct revision
 #define FSACTL_FORCE_DELETE_DISK		CTL_CODE(2120, METHOD_NEITHER)
 #define FSACTL_GET_CONTAINERS			2131
 #define FSACTL_SEND_LARGE_FIB			CTL_CODE(2138, METHOD_BUFFERED)
+#define FSACTL_RESET_IOP			CTL_CODE(2140, METHOD_BUFFERED)
 /* flags defined for IOP & HW SOFT RESET */
 #define HW_IOP_RESET				0x01
 #define HW_SOFT_RESET				0x02
diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index b2af77f..4b65b91 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -1011,7 +1011,22 @@ static int aac_get_pci_info(struct aac_dev* dev, void __user *arg)
 	}
 	return 0;
 }
+struct aac_reset_iop {
+	u8	reset_type;
+};
+
+static int aac_send_reset_adapter(struct aac_dev *dev, void __user *arg)
+{
+	struct aac_reset_iop reset;
+	int retval;
 
+	if (copy_from_user((void *)&reset, arg, sizeof(struct aac_reset_iop)))
+		return -EFAULT;
+
+	retval = aac_reset_adapter(dev, 0, reset.reset_type);
+	return retval;
+
+}
 
 int aac_do_ioctl(struct aac_dev * dev, int cmd, void __user *arg)
 {
@@ -1055,6 +1070,10 @@ int aac_do_ioctl(struct aac_dev * dev, int cmd, void __user *arg)
 	case FSACTL_GET_PCI_INFO:
 		status = aac_get_pci_info(dev,arg);
 		break;
+	case FSACTL_RESET_IOP:
+		status = aac_send_reset_adapter(dev, arg);
+		break;
+
 	default:
 		status = -ENOTTY;
 		break;
-- 
2.7.4

