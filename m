From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 09/10] aacraid: Fix for KDUMP driver hang
Date: Mon, 25 Apr 2016 23:32:37 -0700
Message-ID: <20160426063237.28402.20267.stgit@pmcuser-System-Product-Name>
References: <20160426062414.28402.69178.stgit@pmcuser-System-Product-Name>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0061.outbound.protection.outlook.com ([157.56.111.61]:16568
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752400AbcDZGf1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Apr 2016 02:35:27 -0400
In-Reply-To: <20160426062414.28402.69178.stgit@pmcuser-System-Product-Name>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc: aacraid@pmc-sierra.com, gana.sridaran@microsemi.com, scott.benesh@microsemi.com, vishal.josemannanal@microsemi.com, RaghavaAditya.Renukunta@microsemi.com

When KDUMP is triggered the driver first talks to the firmware in INTX
mode, but the adapter firmware is still in MSIX mode. Therefore the first
driver command hangs since the driver is waiting for an INTX response and
firmware gives a MSIX response. If when the OS is installed on a RAID
drive created by the adapter KDUMP will hang since the driver does not
receive a response in sync mode.

Fixed by: Change the firmware to INTX mode if it is in MSIX mode before
sending the first sync command.
Cc: stable@vger.kernel.org

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/aacraid.h  |    1 +
 drivers/scsi/aacraid/comminit.c |   24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index b70f3eb..0ba8f61 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -29,6 +29,7 @@ enum {
 #define AAC_INT_MODE_MSI		(1<<1)
 #define AAC_INT_MODE_AIF		(1<<2)
 #define AAC_INT_MODE_SYNC		(1<<3)
+#define AAC_INT_MODE_MSIX		(1<<16)
 
 #define AAC_INT_ENABLE_TYPE1_INTX	0xfffffffb
 #define AAC_INT_ENABLE_TYPE1_MSIX	0xfffffffa
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 50d521a..341ea32 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -37,6 +37,7 @@
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/blkdev.h>
+#include <linux/delay.h>
 #include <linux/completion.h>
 #include <linux/mm.h>
 #include <scsi/scsi_host.h>
@@ -47,6 +48,20 @@ struct aac_common aac_config = {
 	.irq_mod = 1
 };
 
+static inline int aac_is_msix_mode(struct aac_dev *dev)
+{
+	u32 status;
+
+	status = src_readl(dev, MUnit.OMR);
+	return (status & AAC_INT_MODE_MSIX);
+}
+
+static inline void aac_change_to_intx(struct aac_dev *dev)
+{
+	aac_src_access_devreg(dev, AAC_DISABLE_MSIX);
+	aac_src_access_devreg(dev, AAC_ENABLE_INTX);
+}
+
 static int aac_alloc_comm(struct aac_dev *dev, void **commaddr, unsigned long commsize, unsigned long commalign)
 {
 	unsigned char *base;
@@ -414,6 +429,15 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 	dev->comm_interface = AAC_COMM_PRODUCER;
 	dev->raw_io_interface = dev->raw_io_64 = 0;
 
+
+	/*
+	 * Enable INTX mode, if not done already Enabled
+	 */
+	if (aac_is_msix_mode(dev)) {
+		aac_change_to_intx(dev);
+		dev_info(&dev->pdev->dev, "Changed firmware to INTX mode");
+	}
+
 	if ((!aac_adapter_sync_cmd(dev, GET_ADAPTER_PROPERTIES,
 		0, 0, 0, 0, 0, 0,
 		status+0, status+1, status+2, status+3, NULL)) &&

