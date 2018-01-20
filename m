From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 2/3] scsi: aacraid: Preserve MSIX mode in the OMR register
Date: Fri, 19 Jan 2018 17:01:56 -0800
Message-ID: <20180120010157.22674-3-RaghavaAditya.Renukunta@microsemi.com>
References: <20180120010157.22674-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0055.outbound.protection.outlook.com ([104.47.33.55]:25824
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754766AbeATBCG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Jan 2018 20:02:06 -0500
In-Reply-To: <20180120010157.22674-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, tom.white@microsemi.com, aacraid@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>

Preserve the current MSIX mode value in the OMR before
rewriting the OMR to initiate the IOP or Soft Reset.

Signed-off-by: Prasad B Munirathnam <prasad.munirathnam@microsemi.com>
Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/src.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index df98f37..b05c3cf 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -680,6 +680,25 @@ void aac_set_intx_mode(struct aac_dev *dev)
 	}
 }
 
+static void aac_clear_omr(struct aac_dev *dev)
+{
+	u32 omr_value = 0;
+
+	omr_value = src_readl(dev, MUnit.OMR);
+
+	/*
+	 * Check for PCI Errors or Kernel Panic
+	 */
+	if ((omr_value == INVALID_OMR) || (omr_value & KERNEL_PANIC))
+		omr_value = 0;
+
+	/*
+	 * Preserve MSIX Value if any
+	 */
+	src_writel(dev, MUnit.OMR, omr_value & AAC_INT_MODE_MSIX);
+	src_readl(dev, MUnit.OMR);
+}
+
 static void aac_dump_fw_fib_iop_reset(struct aac_dev *dev)
 {
 	__le32 supported_options3;
@@ -740,6 +759,8 @@ static void aac_send_iop_reset(struct aac_dev *dev)
 
 	aac_set_intx_mode(dev);
 
+	aac_clear_omr(dev);
+
 	src_writel(dev, MUnit.IDR, IOP_SRC_RESET_MASK);
 
 	msleep(5000);
@@ -749,6 +770,7 @@ static void aac_send_hardware_soft_reset(struct aac_dev *dev)
 {
 	u_int32_t val;
 
+	aac_clear_omr(dev);
 	val = readl(((char *)(dev->base) + IBW_SWR_OFFSET));
 	val |= 0x01;
 	writel(val, ((char *)(dev->base) + IBW_SWR_OFFSET));
-- 
2.9.4
