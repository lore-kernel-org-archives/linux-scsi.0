Return-Path: <SRS0=7BVi=6B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0309FC2D0EF
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Apr 2020 18:10:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D572422240
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Apr 2020 18:10:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="in+b6fBt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730703AbgDQSKh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Apr 2020 14:10:37 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:62577 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730536AbgDQSKf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2020 14:10:35 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200417181026epoutp01c4e84085e8c176b46ff1f09a8a0987ea~Grc_2LyDI0600506005epoutp01I
        for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2020 18:10:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200417181026epoutp01c4e84085e8c176b46ff1f09a8a0987ea~Grc_2LyDI0600506005epoutp01I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1587147026;
        bh=abrRcmD7PErEDWrSo1etAHY9d7IsdF/uDfAWnuH7QOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=in+b6fBtPcXtXIO5k9xZn1b/bEf56zxpVsvhyjMLZ77kerO1bVGFKBGRnfugLz+R0
         mMRpFe1q+8WO2QDuHhLY1rAvDILKJ+kO7JY5egMDM78/Hd9qVi9APYNAjBhCftseHj
         3in6880kE4oVccbpqNMVRaGmvHV0LWj7GF5GwjVw=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20200417181025epcas5p4bc217de235b32a7f778deff29d544f7e~Grc95uyo-0789107891epcas5p48;
        Fri, 17 Apr 2020 18:10:25 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        DB.0B.04736.111F99E5; Sat, 18 Apr 2020 03:10:25 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20200417181024epcas5p4231ae3dd2598155854e9b7ee52438bcb~Grc9fwAKy1060310603epcas5p4y;
        Fri, 17 Apr 2020 18:10:24 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200417181024epsmtrp129c6cad6ffe2b8c1bbec82c81516a516~Grc9e8Jlc0669906699epsmtrp1P;
        Fri, 17 Apr 2020 18:10:24 +0000 (GMT)
X-AuditID: b6c32a4b-ae3ff70000001280-64-5e99f111f9bc
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        81.E0.04024.011F99E5; Sat, 18 Apr 2020 03:10:24 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200417181022epsmtip1009f98dabc98e3bf4185e743496a9453~Grc7hAOi-2097520975epsmtip1I;
        Fri, 17 Apr 2020 18:10:22 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v6 09/10] scsi: ufs-exynos: add UFS host support for Exynos
 SoCs
Date:   Fri, 17 Apr 2020 23:29:43 +0530
Message-Id: <20200417175944.47189-10-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200417175944.47189-1-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0gUYRSG+eauNjquQiejjBXLC5qi0YCaCYtMJGL2yyhtycHE27KjpSFp
        upiXvG2FaZsapOWGaJva5iU3U0OoVbI1DcyolDSIVBDKqFwnqX/vec9zznv4+BhcMUh6MKmZ
        2aI2U52upByJnme+PgGuy/WJQT+/s/z7xh6KX/xuo/iVjlaSbxq2kvz4eCfNz3SNELzp4xTJ
        T/YaKP7G+BOMr3hjpvi7z39h/O9+M823dM+gw6wwWVWJCSZjGSU8vFMg6MYGCWF5/i0hVHUZ
        kbBq2i1ctlRgccwJx/BkMT31nKjdf+i049miiVpa86oGz73+bY4uRBNWrBw5MMCFwphBT5Uj
        R0bB9SHQz5ppuVhB8GzMRtkpBbeG4Is1d2viwUvLX2gAQffCJVIudBiUt+qRnaI4f5it69rM
        cOfcYHitZNPHuWkM3rep7NqNi4fC6VbSrgnOG1Zv92+kMQzLRUDT43A5zBPud1pwu3bYsEt0
        LZsrWc4Vxuo/EfJKTyjuvonL/FUa2n4r7GuAU4GxXyvbbrD0vIuWtQcsVpfQMpIGV3pDZDsf
        WhpHCVlHguW1gbAjOOcLHb375SBnqFz/hMmTLJSWKGTaG4q/2v5O7oTaigpS1gIUvutA8tvU
        IFiZqsNrkGfDf/c3/Hd/w7+0ZoQb0Q5RI2WkiNIBTUimeD5QUmdIOZkpgWeyMkxo81v5HTUj
        kzVmCHEMUm5jS6vqExWk+pyUlzGEgMGV7uzT6A2LTVbnXRC1WUnanHRRGkI7GUK5ndWTtpMK
        LkWdLaaJokbUbnUxxsGjEIVFxaLjUUU6i22Xs/XU2t6YW7FePw6GJNCuA0uG1SPRWe26voUX
        l3PehEb63IPPc/OGD6P5qZVmvcbvWsvhkUPz+8qCvF2cGNWxsoCguMmwysWClR5Pp5FIotoY
        tb4nwVnwdm93/lh2Mf5RvNCYo4poqApL6lV5FUnNIS4Bwf5KQjqrDvbDtZL6D0eVfZ5SAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsWy7bCSnK7Ax5lxBpcn6lg8mLeNzeLlz6ts
        Fp/WL2O1mH/kHKvF+fMb2C1ubjnKYrHp8TVWi8u75rBZzDi/j8mi+/oONovlx/8xWfzfs4Pd
        YunWm4wOvB6X+3qZPDat6mTz2Lyk3qPl5H4Wj49Pb7F49G1ZxejxeZOcR/uBbqYAjigum5TU
        nMyy1CJ9uwSujKYLE9kLLk1grpj64T57A+OFc0xdjJwcEgImEhvPHmDvYuTiEBLYzSjx5fN/
        ZoiEtMT1jRPYIWxhiZX/nkMVNTFJLNrWAFbEJqAtcXf6FrBJIkBFR761MYLYzALPmCROPSzt
        YuTgEBYIkJg8ORkkzCKgKvF54R42kDCvgK3E/J02EOPlJVZvOAA2kRMo3NaylAmkREjARmLD
        kxiQMK+AoMTJmU9YQMLMAuoS6+cJQeyRl2jeOpt5AqPgLCRVsxCqZiGpWsDIvIpRMrWgODc9
        t9iwwDAvtVyvODG3uDQvXS85P3cTIziytDR3MF5eEn+IUYCDUYmH16BnZpwQa2JZcWXuIUYJ
        DmYlEd6DbkAh3pTEyqrUovz4otKc1OJDjNIcLErivE/zjkUKCaQnlqRmp6YWpBbBZJk4OKUa
        GDMaTvic9D7x/MQExobEoF9cvgle25dLHlRcuZXtzFlxy2jvJ7vzNnCXTdJTiJ0xebnltPb0
        y011ffVVa/dvPbeUN+0s6xov18P3X3tc3JwZet0zevM0odwCoaeLL5XmRyytPeFTE2r4aett
        0Y5lr+at0uUVlPViCXNcvlqr2vxcyrX7jn83rVRiKc5INNRiLipOBAAAz9j8qAIAAA==
X-CMS-MailID: 20200417181024epcas5p4231ae3dd2598155854e9b7ee52438bcb
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200417181024epcas5p4231ae3dd2598155854e9b7ee52438bcb
References: <20200417175944.47189-1-alim.akhtar@samsung.com>
        <CGME20200417181024epcas5p4231ae3dd2598155854e9b7ee52438bcb@epcas5p4.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch introduces Exynos UFS host controller driver,
which mainly handles vendor-specific operations including
link startup, power mode change and hibernation/unhibernation.

Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Julia Lawall <julia.lawall@lip6.fr>
[robot: drivers/scsi/ufs/ufs-exynos.c:931:8-10:
 WARNING: possible condition with no effect (if == else)
]
Reviewed-by: Kiwoong Kim <kwmad.kim@samsung.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
Tested-by: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
---
 drivers/scsi/ufs/Kconfig      |   12 +
 drivers/scsi/ufs/Makefile     |    1 +
 drivers/scsi/ufs/ufs-exynos.c | 1289 +++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-exynos.h |  284 ++++++++
 drivers/scsi/ufs/unipro.h     |   33 +
 5 files changed, 1619 insertions(+)
 create mode 100644 drivers/scsi/ufs/ufs-exynos.c
 create mode 100644 drivers/scsi/ufs/ufs-exynos.h

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index e2005aeddc2d..cc7e29c8c24f 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -160,3 +160,15 @@ config SCSI_UFS_BSG
 
 	  Select this if you need a bsg device node for your UFS controller.
 	  If unsure, say N.
+
+config SCSI_UFS_EXYNOS
+	bool "EXYNOS specific hooks to UFS controller platform driver"
+	depends on SCSI_UFSHCD_PLATFORM && ARCH_EXYNOS || COMPILE_TEST
+	select PHY_SAMSUNG_UFS
+	help
+	  This selects the EXYNOS specific additions to UFSHCD platform driver.
+	  UFS host on EXYNOS includes HCI and UNIPRO layer, and associates with
+	  UFS-PHY driver.
+
+	  Select this if you have UFS host controller on EXYNOS chipset.
+	  If unsure, say N.
diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index 94c6c5d7334b..f0c5b95ec9cc 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -4,6 +4,7 @@ obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) += tc-dwc-g210-pci.o ufshcd-dwc.o tc-dwc-g210.
 obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o ufshcd-dwc.o tc-dwc-g210.o
 obj-$(CONFIG_SCSI_UFS_CDNS_PLATFORM) += cdns-pltfrm.o
 obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
+obj-$(CONFIG_SCSI_UFS_EXYNOS) += ufs-exynos.o
 obj-$(CONFIG_SCSI_UFSHCD) += ufshcd-core.o
 ufshcd-core-y				+= ufshcd.o ufs-sysfs.o
 ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
new file mode 100644
index 000000000000..068390f4b6ff
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -0,0 +1,1289 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * UFS Host Controller driver for Exynos specific extensions
+ *
+ * Copyright (C) 2014-2015 Samsung Electronics Co., Ltd.
+ * Author: Seungwon Jeon  <essuuj@gmail.com>
+ * Author: Alim Akhtar <alim.akhtar@samsung.com>
+ *
+ */
+
+#include <linux/clk.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/phy/phy.h>
+#include <linux/platform_device.h>
+
+#include "ufshcd.h"
+#include "ufshcd-pltfrm.h"
+#include "ufshci.h"
+#include "unipro.h"
+
+#include "ufs-exynos.h"
+
+/*
+ * Exynos's Vendor specific registers for UFSHCI
+ */
+#define HCI_TXPRDT_ENTRY_SIZE	0x00
+#define PRDT_PREFECT_EN		BIT(31)
+#define PRDT_SET_SIZE(x)	((x) & 0x1F)
+#define HCI_RXPRDT_ENTRY_SIZE	0x04
+#define HCI_1US_TO_CNT_VAL	0x0C
+#define CNT_VAL_1US_MASK	0x3FF
+#define HCI_UTRL_NEXUS_TYPE	0x40
+#define HCI_UTMRL_NEXUS_TYPE	0x44
+#define HCI_SW_RST		0x50
+#define UFS_LINK_SW_RST		BIT(0)
+#define UFS_UNIPRO_SW_RST	BIT(1)
+#define UFS_SW_RST_MASK		(UFS_UNIPRO_SW_RST | UFS_LINK_SW_RST)
+#define HCI_DATA_REORDER	0x60
+#define HCI_UNIPRO_APB_CLK_CTRL	0x68
+#define UNIPRO_APB_CLK(v, x)	(((v) & ~0xF) | ((x) & 0xF))
+#define HCI_AXIDMA_RWDATA_BURST_LEN	0x6C
+#define HCI_GPIO_OUT		0x70
+#define HCI_ERR_EN_PA_LAYER	0x78
+#define HCI_ERR_EN_DL_LAYER	0x7C
+#define HCI_ERR_EN_N_LAYER	0x80
+#define HCI_ERR_EN_T_LAYER	0x84
+#define HCI_ERR_EN_DME_LAYER	0x88
+#define HCI_CLKSTOP_CTRL	0xB0
+#define REFCLK_STOP		BIT(2)
+#define UNIPRO_MCLK_STOP	BIT(1)
+#define UNIPRO_PCLK_STOP	BIT(0)
+#define CLK_STOP_MASK		(REFCLK_STOP |\
+				 UNIPRO_MCLK_STOP |\
+				 UNIPRO_PCLK_STOP)
+#define HCI_MISC		0xB4
+#define REFCLK_CTRL_EN		BIT(7)
+#define UNIPRO_PCLK_CTRL_EN	BIT(6)
+#define UNIPRO_MCLK_CTRL_EN	BIT(5)
+#define HCI_CORECLK_CTRL_EN	BIT(4)
+#define CLK_CTRL_EN_MASK	(REFCLK_CTRL_EN |\
+				 UNIPRO_PCLK_CTRL_EN |\
+				 UNIPRO_MCLK_CTRL_EN)
+/* Device fatal error */
+#define DFES_ERR_EN		BIT(31)
+#define DFES_DEF_L2_ERRS	(UIC_DATA_LINK_LAYER_ERROR_RX_BUF_OF |\
+				 UIC_DATA_LINK_LAYER_ERROR_PA_INIT)
+#define DFES_DEF_L3_ERRS	(UIC_NETWORK_UNSUPPORTED_HEADER_TYPE |\
+				 UIC_NETWORK_BAD_DEVICEID_ENC |\
+				 UIC_NETWORK_LHDR_TRAP_PACKET_DROPPING)
+#define DFES_DEF_L4_ERRS	(UIC_TRANSPORT_UNSUPPORTED_HEADER_TYPE |\
+				 UIC_TRANSPORT_UNKNOWN_CPORTID |\
+				 UIC_TRANSPORT_NO_CONNECTION_RX |\
+				 UIC_TRANSPORT_BAD_TC)
+
+enum {
+	UNIPRO_L1_5 = 0,/* PHY Adapter */
+	UNIPRO_L2,	/* Data Link */
+	UNIPRO_L3,	/* Network */
+	UNIPRO_L4,	/* Transport */
+	UNIPRO_DME,	/* DME */
+};
+
+/*
+ * UNIPRO registers
+ */
+#define UNIPRO_COMP_VERSION			0x000
+#define UNIPRO_DME_PWR_REQ			0x090
+#define UNIPRO_DME_PWR_REQ_POWERMODE		0x094
+#define UNIPRO_DME_PWR_REQ_LOCALL2TIMER0	0x098
+#define UNIPRO_DME_PWR_REQ_LOCALL2TIMER1	0x09C
+#define UNIPRO_DME_PWR_REQ_LOCALL2TIMER2	0x0A0
+#define UNIPRO_DME_PWR_REQ_REMOTEL2TIMER0	0x0A4
+#define UNIPRO_DME_PWR_REQ_REMOTEL2TIMER1	0x0A8
+#define UNIPRO_DME_PWR_REQ_REMOTEL2TIMER2	0x0AC
+
+/*
+ * UFS Protector registers
+ */
+#define UFSPRSECURITY	0x010
+#define NSSMU		BIT(14)
+#define UFSPSBEGIN0	0x200
+#define UFSPSEND0	0x204
+#define UFSPSLUN0	0x208
+#define UFSPSCTRL0	0x20C
+
+#define CNTR_DIV_VAL 40
+
+static void exynos_ufs_auto_ctrl_hcc(struct exynos_ufs *ufs, bool en);
+static void exynos_ufs_ctrl_clkstop(struct exynos_ufs *ufs, bool en);
+
+static inline void exynos_ufs_enable_auto_ctrl_hcc(struct exynos_ufs *ufs)
+{
+	exynos_ufs_auto_ctrl_hcc(ufs, true);
+}
+
+static inline void exynos_ufs_disable_auto_ctrl_hcc(struct exynos_ufs *ufs)
+{
+	exynos_ufs_auto_ctrl_hcc(ufs, false);
+}
+
+static inline void exynos_ufs_disable_auto_ctrl_hcc_save(
+					struct exynos_ufs *ufs, u32 *val)
+{
+	*val = hci_readl(ufs, HCI_MISC);
+	exynos_ufs_auto_ctrl_hcc(ufs, false);
+}
+
+static inline void exynos_ufs_auto_ctrl_hcc_restore(
+					struct exynos_ufs *ufs, u32 *val)
+{
+	hci_writel(ufs, *val, HCI_MISC);
+}
+
+static inline void exynos_ufs_gate_clks(struct exynos_ufs *ufs)
+{
+	exynos_ufs_ctrl_clkstop(ufs, true);
+}
+
+static inline void exynos_ufs_ungate_clks(struct exynos_ufs *ufs)
+{
+	exynos_ufs_ctrl_clkstop(ufs, false);
+}
+
+static int exynos7_ufs_drv_init(struct device *dev, struct exynos_ufs *ufs)
+{
+	return 0;
+}
+
+static int exynos7_ufs_pre_link(struct exynos_ufs *ufs)
+{
+	struct ufs_hba *hba = ufs->hba;
+	u32 val = ufs->drv_data->uic_attr->pa_dbg_option_suite;
+	int i;
+
+	exynos_ufs_enable_ov_tm(hba);
+	for_each_ufs_tx_lane(ufs, i)
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x297, i), 0x17);
+	for_each_ufs_rx_lane(ufs, i) {
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x362, i), 0xff);
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x363, i), 0x00);
+	}
+	exynos_ufs_disable_ov_tm(hba);
+
+	for_each_ufs_tx_lane(ufs, i)
+		ufshcd_dme_set(hba,
+			UIC_ARG_MIB_SEL(TX_HIBERN8_CONTROL, i), 0x0);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_TXPHY_CFGUPDT), 0x1);
+	udelay(1);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_OPTION_SUITE), val | (1 << 12));
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_SKIP_RESET_PHY), 0x1);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_SKIP_LINE_RESET), 0x1);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_LINE_RESET_REQ), 0x1);
+	udelay(1600);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_OPTION_SUITE), val);
+
+	return 0;
+}
+
+static int exynos7_ufs_post_link(struct exynos_ufs *ufs)
+{
+	struct ufs_hba *hba = ufs->hba;
+	int i;
+
+	exynos_ufs_enable_ov_tm(hba);
+	for_each_ufs_tx_lane(ufs, i) {
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x28b, i), 0x83);
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x29a, i), 0x07);
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x277, i),
+			TX_LINERESET_N(exynos_ufs_calc_time_cntr(ufs, 200000)));
+	}
+	exynos_ufs_disable_ov_tm(hba);
+
+	exynos_ufs_enable_dbg_mode(hba);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_SAVECONFIGTIME), 0xbb8);
+	exynos_ufs_disable_dbg_mode(hba);
+
+	return 0;
+}
+
+static int exynos7_ufs_pre_pwr_change(struct exynos_ufs *ufs,
+						struct ufs_pa_layer_attr *pwr)
+{
+	unipro_writel(ufs, 0x22, UNIPRO_DBG_FORCE_DME_CTRL_STATE);
+
+	return 0;
+}
+
+static int exynos7_ufs_post_pwr_change(struct exynos_ufs *ufs,
+						struct ufs_pa_layer_attr *pwr)
+{
+	struct ufs_hba *hba = ufs->hba;
+	int lanes = max_t(u32, pwr->lane_rx, pwr->lane_tx);
+
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_RXPHY_CFGUPDT), 0x1);
+
+	if (lanes == 1) {
+		exynos_ufs_enable_dbg_mode(hba);
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_CONNECTEDTXDATALANES), 0x1);
+		exynos_ufs_disable_dbg_mode(hba);
+	}
+
+	return 0;
+}
+
+/**
+ * exynos_ufs_auto_ctrl_hcc - HCI core clock control by h/w
+ * Control should be disabled in the below cases
+ * - Before host controller S/W reset
+ * - Access to UFS protector's register
+ */
+static void exynos_ufs_auto_ctrl_hcc(struct exynos_ufs *ufs, bool en)
+{
+	u32 misc = hci_readl(ufs, HCI_MISC);
+
+	if (en)
+		hci_writel(ufs, misc | HCI_CORECLK_CTRL_EN, HCI_MISC);
+	else
+		hci_writel(ufs, misc & ~HCI_CORECLK_CTRL_EN, HCI_MISC);
+}
+
+static void exynos_ufs_ctrl_clkstop(struct exynos_ufs *ufs, bool en)
+{
+	u32 ctrl = hci_readl(ufs, HCI_CLKSTOP_CTRL);
+	u32 misc = hci_readl(ufs, HCI_MISC);
+
+	if (en) {
+		hci_writel(ufs, misc | CLK_CTRL_EN_MASK, HCI_MISC);
+		hci_writel(ufs, ctrl | CLK_STOP_MASK, HCI_CLKSTOP_CTRL);
+	} else {
+		hci_writel(ufs, ctrl & ~CLK_STOP_MASK, HCI_CLKSTOP_CTRL);
+		hci_writel(ufs, misc & ~CLK_CTRL_EN_MASK, HCI_MISC);
+	}
+}
+
+static int exynos_ufs_get_clk_info(struct exynos_ufs *ufs)
+{
+	struct ufs_hba *hba = ufs->hba;
+	struct list_head *head = &hba->clk_list_head;
+	struct ufs_clk_info *clki;
+	u32 pclk_rate;
+	u32 f_min, f_max;
+	u8 div = 0;
+	int ret = 0;
+
+	if (!head || list_empty(head))
+		goto out;
+
+	list_for_each_entry(clki, head, list) {
+		if (!IS_ERR(clki->clk)) {
+			if (!strcmp(clki->name, "core_clk"))
+				ufs->clk_hci_core = clki->clk;
+			else if (!strcmp(clki->name, "sclk_unipro_main"))
+				ufs->clk_unipro_main = clki->clk;
+		}
+	}
+
+	if (!ufs->clk_hci_core || !ufs->clk_unipro_main) {
+		dev_err(hba->dev, "failed to get clk info\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ufs->mclk_rate = clk_get_rate(ufs->clk_unipro_main);
+	pclk_rate = clk_get_rate(ufs->clk_hci_core);
+	f_min = ufs->pclk_avail_min;
+	f_max = ufs->pclk_avail_max;
+
+	if (ufs->opts & EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL) {
+		do {
+			pclk_rate /= (div + 1);
+
+			if (pclk_rate <= f_max)
+				break;
+			div++;
+		} while (pclk_rate >= f_min);
+	}
+
+	if (unlikely(pclk_rate < f_min || pclk_rate > f_max)) {
+		dev_err(hba->dev, "not available pclk range %d\n", pclk_rate);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ufs->pclk_rate = pclk_rate;
+	ufs->pclk_div = div;
+
+out:
+	return ret;
+}
+
+static void exynos_ufs_set_unipro_pclk_div(struct exynos_ufs *ufs)
+{
+	if (ufs->opts & EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL) {
+		u32 val;
+
+		val = hci_readl(ufs, HCI_UNIPRO_APB_CLK_CTRL);
+		hci_writel(ufs, UNIPRO_APB_CLK(val, ufs->pclk_div),
+			   HCI_UNIPRO_APB_CLK_CTRL);
+	}
+}
+
+static void exynos_ufs_set_pwm_clk_div(struct exynos_ufs *ufs)
+{
+	struct ufs_hba *hba = ufs->hba;
+	struct exynos_ufs_uic_attr *attr = ufs->drv_data->uic_attr;
+
+	ufshcd_dme_set(hba,
+		UIC_ARG_MIB(CMN_PWM_CLK_CTRL), attr->cmn_pwm_clk_ctrl);
+}
+
+static void exynos_ufs_calc_pwm_clk_div(struct exynos_ufs *ufs)
+{
+	struct ufs_hba *hba = ufs->hba;
+	struct exynos_ufs_uic_attr *attr = ufs->drv_data->uic_attr;
+	const unsigned int div = 30, mult = 20;
+	const unsigned long pwm_min = 3 * 1000 * 1000;
+	const unsigned long pwm_max = 9 * 1000 * 1000;
+	const int divs[] = {32, 16, 8, 4};
+	unsigned long clk = 0, _clk, clk_period;
+	int i = 0, clk_idx = -1;
+
+	clk_period = UNIPRO_PCLK_PERIOD(ufs);
+	for (i = 0; i < ARRAY_SIZE(divs); i++) {
+		_clk = NSEC_PER_SEC * mult / (clk_period * divs[i] * div);
+		if (_clk >= pwm_min && _clk <= pwm_max) {
+			if (_clk > clk) {
+				clk_idx = i;
+				clk = _clk;
+			}
+		}
+	}
+
+	if (clk_idx == -1) {
+		ufshcd_dme_get(hba, UIC_ARG_MIB(CMN_PWM_CLK_CTRL), &clk_idx);
+		dev_err(hba->dev,
+			"failed to decide pwm clock divider, will not change\n");
+	}
+
+	attr->cmn_pwm_clk_ctrl = clk_idx & PWM_CLK_CTRL_MASK;
+}
+
+long exynos_ufs_calc_time_cntr(struct exynos_ufs *ufs, long period)
+{
+	const int precise = 10;
+	long pclk_rate = ufs->pclk_rate;
+	long clk_period, fraction;
+
+	clk_period = UNIPRO_PCLK_PERIOD(ufs);
+	fraction = ((NSEC_PER_SEC % pclk_rate) * precise) / pclk_rate;
+
+	return (period * precise) / ((clk_period * precise) + fraction);
+}
+
+static void exynos_ufs_specify_phy_time_attr(struct exynos_ufs *ufs)
+{
+	struct exynos_ufs_uic_attr *attr = ufs->drv_data->uic_attr;
+	struct ufs_phy_time_cfg *t_cfg = &ufs->t_cfg;
+
+	t_cfg->tx_linereset_p =
+		exynos_ufs_calc_time_cntr(ufs, attr->tx_dif_p_nsec);
+	t_cfg->tx_linereset_n =
+		exynos_ufs_calc_time_cntr(ufs, attr->tx_dif_n_nsec);
+	t_cfg->tx_high_z_cnt =
+		exynos_ufs_calc_time_cntr(ufs, attr->tx_high_z_cnt_nsec);
+	t_cfg->tx_base_n_val =
+		exynos_ufs_calc_time_cntr(ufs, attr->tx_base_unit_nsec);
+	t_cfg->tx_gran_n_val =
+		exynos_ufs_calc_time_cntr(ufs, attr->tx_gran_unit_nsec);
+	t_cfg->tx_sleep_cnt =
+		exynos_ufs_calc_time_cntr(ufs, attr->tx_sleep_cnt);
+
+	t_cfg->rx_linereset =
+		exynos_ufs_calc_time_cntr(ufs, attr->rx_dif_p_nsec);
+	t_cfg->rx_hibern8_wait =
+		exynos_ufs_calc_time_cntr(ufs, attr->rx_hibern8_wait_nsec);
+	t_cfg->rx_base_n_val =
+		exynos_ufs_calc_time_cntr(ufs, attr->rx_base_unit_nsec);
+	t_cfg->rx_gran_n_val =
+		exynos_ufs_calc_time_cntr(ufs, attr->rx_gran_unit_nsec);
+	t_cfg->rx_sleep_cnt =
+		exynos_ufs_calc_time_cntr(ufs, attr->rx_sleep_cnt);
+	t_cfg->rx_stall_cnt =
+		exynos_ufs_calc_time_cntr(ufs, attr->rx_stall_cnt);
+}
+
+static void exynos_ufs_config_phy_time_attr(struct exynos_ufs *ufs)
+{
+	struct ufs_hba *hba = ufs->hba;
+	struct ufs_phy_time_cfg *t_cfg = &ufs->t_cfg;
+	int i;
+
+	exynos_ufs_set_pwm_clk_div(ufs);
+
+	exynos_ufs_enable_ov_tm(hba);
+
+	for_each_ufs_rx_lane(ufs, i) {
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RX_FILLER_ENABLE, i),
+				ufs->drv_data->uic_attr->rx_filler_enable);
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RX_LINERESET_VAL, i),
+				RX_LINERESET(t_cfg->rx_linereset));
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RX_BASE_NVAL_07_00, i),
+				RX_BASE_NVAL_L(t_cfg->rx_base_n_val));
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RX_BASE_NVAL_15_08, i),
+				RX_BASE_NVAL_H(t_cfg->rx_base_n_val));
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RX_GRAN_NVAL_07_00, i),
+				RX_GRAN_NVAL_L(t_cfg->rx_gran_n_val));
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RX_GRAN_NVAL_10_08, i),
+				RX_GRAN_NVAL_H(t_cfg->rx_gran_n_val));
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RX_OV_SLEEP_CNT_TIMER, i),
+				RX_OV_SLEEP_CNT(t_cfg->rx_sleep_cnt));
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RX_OV_STALL_CNT_TIMER, i),
+				RX_OV_STALL_CNT(t_cfg->rx_stall_cnt));
+	}
+
+	for_each_ufs_tx_lane(ufs, i) {
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(TX_LINERESET_P_VAL, i),
+				TX_LINERESET_P(t_cfg->tx_linereset_p));
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(TX_HIGH_Z_CNT_07_00, i),
+				TX_HIGH_Z_CNT_L(t_cfg->tx_high_z_cnt));
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(TX_HIGH_Z_CNT_11_08, i),
+				TX_HIGH_Z_CNT_H(t_cfg->tx_high_z_cnt));
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(TX_BASE_NVAL_07_00, i),
+				TX_BASE_NVAL_L(t_cfg->tx_base_n_val));
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(TX_BASE_NVAL_15_08, i),
+				TX_BASE_NVAL_H(t_cfg->tx_base_n_val));
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(TX_GRAN_NVAL_07_00, i),
+				TX_GRAN_NVAL_L(t_cfg->tx_gran_n_val));
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(TX_GRAN_NVAL_10_08, i),
+				TX_GRAN_NVAL_H(t_cfg->tx_gran_n_val));
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(TX_OV_SLEEP_CNT_TIMER, i),
+				TX_OV_H8_ENTER_EN |
+				TX_OV_SLEEP_CNT(t_cfg->tx_sleep_cnt));
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(TX_MIN_ACTIVATETIME, i),
+				ufs->drv_data->uic_attr->tx_min_activatetime);
+	}
+
+	exynos_ufs_disable_ov_tm(hba);
+}
+
+static void exynos_ufs_config_phy_cap_attr(struct exynos_ufs *ufs)
+{
+	struct ufs_hba *hba = ufs->hba;
+	struct exynos_ufs_uic_attr *attr = ufs->drv_data->uic_attr;
+	int i;
+
+	exynos_ufs_enable_ov_tm(hba);
+
+	for_each_ufs_rx_lane(ufs, i) {
+		ufshcd_dme_set(hba,
+				UIC_ARG_MIB_SEL(RX_HS_G1_SYNC_LENGTH_CAP, i),
+				attr->rx_hs_g1_sync_len_cap);
+		ufshcd_dme_set(hba,
+				UIC_ARG_MIB_SEL(RX_HS_G2_SYNC_LENGTH_CAP, i),
+				attr->rx_hs_g2_sync_len_cap);
+		ufshcd_dme_set(hba,
+				UIC_ARG_MIB_SEL(RX_HS_G3_SYNC_LENGTH_CAP, i),
+				attr->rx_hs_g3_sync_len_cap);
+		ufshcd_dme_set(hba,
+				UIC_ARG_MIB_SEL(RX_HS_G1_PREP_LENGTH_CAP, i),
+				attr->rx_hs_g1_prep_sync_len_cap);
+		ufshcd_dme_set(hba,
+				UIC_ARG_MIB_SEL(RX_HS_G2_PREP_LENGTH_CAP, i),
+				attr->rx_hs_g2_prep_sync_len_cap);
+		ufshcd_dme_set(hba,
+				UIC_ARG_MIB_SEL(RX_HS_G3_PREP_LENGTH_CAP, i),
+				attr->rx_hs_g3_prep_sync_len_cap);
+	}
+
+	if (attr->rx_adv_fine_gran_sup_en == 0) {
+		for_each_ufs_rx_lane(ufs, i) {
+			ufshcd_dme_set(hba,
+				UIC_ARG_MIB_SEL(RX_ADV_GRANULARITY_CAP, i), 0);
+
+			if (attr->rx_min_actv_time_cap)
+				ufshcd_dme_set(hba,
+					UIC_ARG_MIB_SEL(RX_MIN_ACTIVATETIME_CAP,
+						i), attr->rx_min_actv_time_cap);
+
+			if (attr->rx_hibern8_time_cap)
+				ufshcd_dme_set(hba,
+					UIC_ARG_MIB_SEL(RX_HIBERN8TIME_CAP, i),
+						attr->rx_hibern8_time_cap);
+		}
+	} else if (attr->rx_adv_fine_gran_sup_en == 1) {
+		for_each_ufs_rx_lane(ufs, i) {
+			if (attr->rx_adv_fine_gran_step)
+				ufshcd_dme_set(hba,
+					UIC_ARG_MIB_SEL(RX_ADV_GRANULARITY_CAP,
+						i), RX_ADV_FINE_GRAN_STEP(
+						attr->rx_adv_fine_gran_step));
+
+			if (attr->rx_adv_min_actv_time_cap)
+				ufshcd_dme_set(hba,
+					UIC_ARG_MIB_SEL(
+						RX_ADV_MIN_ACTIVATETIME_CAP, i),
+						attr->rx_adv_min_actv_time_cap);
+
+			if (attr->rx_adv_hibern8_time_cap)
+				ufshcd_dme_set(hba,
+					UIC_ARG_MIB_SEL(RX_ADV_HIBERN8TIME_CAP,
+						i),
+						attr->rx_adv_hibern8_time_cap);
+		}
+	}
+
+	exynos_ufs_disable_ov_tm(hba);
+}
+
+static void exynos_ufs_establish_connt(struct exynos_ufs *ufs)
+{
+	struct ufs_hba *hba = ufs->hba;
+	enum {
+		DEV_ID		= 0x00,
+		PEER_DEV_ID	= 0x01,
+		PEER_CPORT_ID	= 0x00,
+		TRAFFIC_CLASS	= 0x00,
+	};
+
+	/* allow cport attributes to be set */
+	ufshcd_dme_set(hba, UIC_ARG_MIB(T_CONNECTIONSTATE), CPORT_IDLE);
+
+	/* local unipro attributes */
+	ufshcd_dme_set(hba, UIC_ARG_MIB(N_DEVICEID), DEV_ID);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(N_DEVICEID_VALID), TRUE);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(T_PEERDEVICEID), PEER_DEV_ID);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(T_PEERCPORTID), PEER_CPORT_ID);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(T_CPORTFLAGS), CPORT_DEF_FLAGS);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(T_TRAFFICCLASS), TRAFFIC_CLASS);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(T_CONNECTIONSTATE), CPORT_CONNECTED);
+}
+
+static void exynos_ufs_config_smu(struct exynos_ufs *ufs)
+{
+	u32 reg, val;
+
+	exynos_ufs_disable_auto_ctrl_hcc_save(ufs, &val);
+
+	/* make encryption disabled by default */
+	reg = ufsp_readl(ufs, UFSPRSECURITY);
+	ufsp_writel(ufs, reg | NSSMU, UFSPRSECURITY);
+	ufsp_writel(ufs, 0x0, UFSPSBEGIN0);
+	ufsp_writel(ufs, 0xffffffff, UFSPSEND0);
+	ufsp_writel(ufs, 0xff, UFSPSLUN0);
+	ufsp_writel(ufs, 0xf1, UFSPSCTRL0);
+
+	exynos_ufs_auto_ctrl_hcc_restore(ufs, &val);
+}
+
+static void exynos_ufs_config_sync_pattern_mask(struct exynos_ufs *ufs,
+					struct ufs_pa_layer_attr *pwr)
+{
+	struct ufs_hba *hba = ufs->hba;
+	u8 g = max_t(u32, pwr->gear_rx, pwr->gear_tx);
+	u32 mask, sync_len;
+	enum {
+		SYNC_LEN_G1 = 80 * 1000, /* 80us */
+		SYNC_LEN_G2 = 40 * 1000, /* 44us */
+		SYNC_LEN_G3 = 20 * 1000, /* 20us */
+	};
+	int i;
+
+	if (g == 1)
+		sync_len = SYNC_LEN_G1;
+	else if (g == 2)
+		sync_len = SYNC_LEN_G2;
+	else if (g == 3)
+		sync_len = SYNC_LEN_G3;
+	else
+		return;
+
+	mask = exynos_ufs_calc_time_cntr(ufs, sync_len);
+	mask = (mask >> 8) & 0xff;
+
+	exynos_ufs_enable_ov_tm(hba);
+
+	for_each_ufs_rx_lane(ufs, i)
+		ufshcd_dme_set(hba,
+			UIC_ARG_MIB_SEL(RX_SYNC_MASK_LENGTH, i), mask);
+
+	exynos_ufs_disable_ov_tm(hba);
+}
+
+static int exynos_ufs_pre_pwr_mode(struct ufs_hba *hba,
+				struct ufs_pa_layer_attr *dev_max_params,
+				struct ufs_pa_layer_attr *dev_req_params)
+{
+	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
+	struct phy *generic_phy = ufs->phy;
+	struct ufs_dev_params ufs_exynos_cap;
+	int ret;
+
+	if (!dev_req_params) {
+		pr_err("%s: incoming dev_req_params is NULL\n", __func__);
+		ret = -EINVAL;
+		goto out;
+	}
+
+
+	ufs_exynos_cap.tx_lanes = UFS_EXYNOS_LIMIT_NUM_LANES_TX;
+	ufs_exynos_cap.rx_lanes = UFS_EXYNOS_LIMIT_NUM_LANES_RX;
+	ufs_exynos_cap.hs_rx_gear = UFS_EXYNOS_LIMIT_HSGEAR_RX;
+	ufs_exynos_cap.hs_tx_gear = UFS_EXYNOS_LIMIT_HSGEAR_TX;
+	ufs_exynos_cap.pwm_rx_gear = UFS_EXYNOS_LIMIT_PWMGEAR_RX;
+	ufs_exynos_cap.pwm_tx_gear = UFS_EXYNOS_LIMIT_PWMGEAR_TX;
+	ufs_exynos_cap.rx_pwr_pwm = UFS_EXYNOS_LIMIT_RX_PWR_PWM;
+	ufs_exynos_cap.tx_pwr_pwm = UFS_EXYNOS_LIMIT_TX_PWR_PWM;
+	ufs_exynos_cap.rx_pwr_hs = UFS_EXYNOS_LIMIT_RX_PWR_HS;
+	ufs_exynos_cap.tx_pwr_hs = UFS_EXYNOS_LIMIT_TX_PWR_HS;
+	ufs_exynos_cap.hs_rate = UFS_EXYNOS_LIMIT_HS_RATE;
+	ufs_exynos_cap.desired_working_mode =
+				UFS_EXYNOS_LIMIT_DESIRED_MODE;
+
+	ret = ufshcd_get_pwr_dev_param(&ufs_exynos_cap,
+				       dev_max_params, dev_req_params);
+	if (ret) {
+		pr_err("%s: failed to determine capabilities\n", __func__);
+		goto out;
+	}
+
+	if (ufs->drv_data->pre_pwr_change)
+		ufs->drv_data->pre_pwr_change(ufs, dev_req_params);
+
+	if (ufshcd_is_hs_mode(dev_req_params)) {
+		exynos_ufs_config_sync_pattern_mask(ufs, dev_req_params);
+
+		switch (dev_req_params->hs_rate) {
+		case PA_HS_MODE_A:
+		case PA_HS_MODE_B:
+			phy_calibrate(generic_phy);
+			break;
+		}
+	}
+
+	return 0;
+out:
+	return ret;
+}
+
+#define PWR_MODE_STR_LEN	64
+static int exynos_ufs_post_pwr_mode(struct ufs_hba *hba,
+				struct ufs_pa_layer_attr *pwr_max,
+				struct ufs_pa_layer_attr *pwr_req)
+{
+	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
+	struct phy *generic_phy = ufs->phy;
+	int gear = max_t(u32, pwr_req->gear_rx, pwr_req->gear_tx);
+	int lanes = max_t(u32, pwr_req->lane_rx, pwr_req->lane_tx);
+	char pwr_str[PWR_MODE_STR_LEN] = "";
+
+	/* let default be PWM Gear 1, Lane 1 */
+	if (!gear)
+		gear = 1;
+
+	if (!lanes)
+		lanes = 1;
+
+	if (ufs->drv_data->post_pwr_change)
+		ufs->drv_data->post_pwr_change(ufs, pwr_req);
+
+	if ((ufshcd_is_hs_mode(pwr_req))) {
+		switch (pwr_req->hs_rate) {
+		case PA_HS_MODE_A:
+		case PA_HS_MODE_B:
+			phy_calibrate(generic_phy);
+			break;
+		}
+
+		snprintf(pwr_str, PWR_MODE_STR_LEN, "%s series_%s G_%d L_%d",
+			"FAST",	pwr_req->hs_rate == PA_HS_MODE_A ? "A" : "B",
+			gear, lanes);
+	} else {
+		snprintf(pwr_str, PWR_MODE_STR_LEN, "%s G_%d L_%d",
+			"SLOW", gear, lanes);
+	}
+
+	dev_info(hba->dev, "Power mode changed to : %s\n", pwr_str);
+
+	return 0;
+}
+
+static void exynos_ufs_specify_nexus_t_xfer_req(struct ufs_hba *hba,
+						int tag, bool op)
+{
+	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
+	u32 type;
+
+	type =  hci_readl(ufs, HCI_UTRL_NEXUS_TYPE);
+
+	if (op)
+		hci_writel(ufs, type | (1 << tag), HCI_UTRL_NEXUS_TYPE);
+	else
+		hci_writel(ufs, type & ~(1 << tag), HCI_UTRL_NEXUS_TYPE);
+}
+
+static void exynos_ufs_specify_nexus_t_tm_req(struct ufs_hba *hba,
+						int tag, u8 func)
+{
+	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
+	u32 type;
+
+	type =  hci_readl(ufs, HCI_UTMRL_NEXUS_TYPE);
+
+	switch (func) {
+	case UFS_ABORT_TASK:
+	case UFS_QUERY_TASK:
+		hci_writel(ufs, type | (1 << tag), HCI_UTMRL_NEXUS_TYPE);
+		break;
+	case UFS_ABORT_TASK_SET:
+	case UFS_CLEAR_TASK_SET:
+	case UFS_LOGICAL_RESET:
+	case UFS_QUERY_TASK_SET:
+		hci_writel(ufs, type & ~(1 << tag), HCI_UTMRL_NEXUS_TYPE);
+		break;
+	}
+}
+
+static void exynos_ufs_phy_init(struct exynos_ufs *ufs)
+{
+	struct ufs_hba *hba = ufs->hba;
+	struct phy *generic_phy = ufs->phy;
+
+	if (ufs->avail_ln_rx == 0 || ufs->avail_ln_tx == 0) {
+		ufshcd_dme_get(hba, UIC_ARG_MIB(PA_AVAILRXDATALANES),
+			&ufs->avail_ln_rx);
+		ufshcd_dme_get(hba, UIC_ARG_MIB(PA_AVAILTXDATALANES),
+			&ufs->avail_ln_tx);
+		WARN(ufs->avail_ln_rx != ufs->avail_ln_tx,
+			"available data lane is not equal(rx:%d, tx:%d)\n",
+			ufs->avail_ln_rx, ufs->avail_ln_tx);
+	}
+
+	phy_set_bus_width(generic_phy, ufs->avail_ln_rx);
+	phy_init(generic_phy);
+}
+
+static void exynos_ufs_config_unipro(struct exynos_ufs *ufs)
+{
+	struct ufs_hba *hba = ufs->hba;
+
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_CLK_PERIOD),
+		DIV_ROUND_UP(NSEC_PER_SEC, ufs->mclk_rate));
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXTRAILINGCLOCKS),
+			ufs->drv_data->uic_attr->tx_trailingclks);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_OPTION_SUITE),
+			ufs->drv_data->uic_attr->pa_dbg_option_suite);
+}
+
+static void exynos_ufs_config_intr(struct exynos_ufs *ufs, u32 errs, u8 index)
+{
+	switch (index) {
+	case UNIPRO_L1_5:
+		hci_writel(ufs, DFES_ERR_EN | errs, HCI_ERR_EN_PA_LAYER);
+		break;
+	case UNIPRO_L2:
+		hci_writel(ufs, DFES_ERR_EN | errs, HCI_ERR_EN_DL_LAYER);
+		break;
+	case UNIPRO_L3:
+		hci_writel(ufs, DFES_ERR_EN | errs, HCI_ERR_EN_N_LAYER);
+		break;
+	case UNIPRO_L4:
+		hci_writel(ufs, DFES_ERR_EN | errs, HCI_ERR_EN_T_LAYER);
+		break;
+	case UNIPRO_DME:
+		hci_writel(ufs, DFES_ERR_EN | errs, HCI_ERR_EN_DME_LAYER);
+		break;
+	}
+}
+
+static int exynos_ufs_pre_link(struct ufs_hba *hba)
+{
+	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
+
+	/* hci */
+	exynos_ufs_config_intr(ufs, DFES_DEF_L2_ERRS, UNIPRO_L2);
+	exynos_ufs_config_intr(ufs, DFES_DEF_L3_ERRS, UNIPRO_L3);
+	exynos_ufs_config_intr(ufs, DFES_DEF_L4_ERRS, UNIPRO_L4);
+	exynos_ufs_set_unipro_pclk_div(ufs);
+
+	/* unipro */
+	exynos_ufs_config_unipro(ufs);
+
+	/* m-phy */
+	exynos_ufs_phy_init(ufs);
+	exynos_ufs_config_phy_time_attr(ufs);
+	exynos_ufs_config_phy_cap_attr(ufs);
+
+	if (ufs->drv_data->pre_link)
+		ufs->drv_data->pre_link(ufs);
+
+	return 0;
+}
+
+static void exynos_ufs_fit_aggr_timeout(struct exynos_ufs *ufs)
+{
+	u32 val;
+
+	val = exynos_ufs_calc_time_cntr(ufs, IATOVAL_NSEC / CNTR_DIV_VAL);
+	hci_writel(ufs, val & CNT_VAL_1US_MASK, HCI_1US_TO_CNT_VAL);
+}
+
+static int exynos_ufs_post_link(struct ufs_hba *hba)
+{
+	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
+	struct phy *generic_phy = ufs->phy;
+	struct exynos_ufs_uic_attr *attr = ufs->drv_data->uic_attr;
+
+	exynos_ufs_establish_connt(ufs);
+	exynos_ufs_fit_aggr_timeout(ufs);
+
+	hci_writel(ufs, 0xa, HCI_DATA_REORDER);
+	hci_writel(ufs, PRDT_SET_SIZE(12), HCI_TXPRDT_ENTRY_SIZE);
+	hci_writel(ufs, PRDT_SET_SIZE(12), HCI_RXPRDT_ENTRY_SIZE);
+	hci_writel(ufs, (1 << hba->nutrs) - 1, HCI_UTRL_NEXUS_TYPE);
+	hci_writel(ufs, (1 << hba->nutmrs) - 1, HCI_UTMRL_NEXUS_TYPE);
+	hci_writel(ufs, 0xf, HCI_AXIDMA_RWDATA_BURST_LEN);
+
+	if (ufs->opts & EXYNOS_UFS_OPT_SKIP_CONNECTION_ESTAB)
+		ufshcd_dme_set(hba,
+			UIC_ARG_MIB(T_DBG_SKIP_INIT_HIBERN8_EXIT), TRUE);
+
+	if (attr->pa_granularity) {
+		exynos_ufs_enable_dbg_mode(hba);
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_GRANULARITY),
+				attr->pa_granularity);
+		exynos_ufs_disable_dbg_mode(hba);
+
+		if (attr->pa_tactivate)
+			ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TACTIVATE),
+					attr->pa_tactivate);
+		if (attr->pa_hibern8time &&
+		    !(ufs->opts & EXYNOS_UFS_OPT_USE_SW_HIBERN8_TIMER))
+			ufshcd_dme_set(hba, UIC_ARG_MIB(PA_HIBERN8TIME),
+					attr->pa_hibern8time);
+	}
+
+	if (ufs->opts & EXYNOS_UFS_OPT_USE_SW_HIBERN8_TIMER) {
+		if (!attr->pa_granularity)
+			ufshcd_dme_get(hba, UIC_ARG_MIB(PA_GRANULARITY),
+					&attr->pa_granularity);
+		if (!attr->pa_hibern8time)
+			ufshcd_dme_get(hba, UIC_ARG_MIB(PA_HIBERN8TIME),
+					&attr->pa_hibern8time);
+		/*
+		 * not wait for HIBERN8 time to exit hibernation
+		 */
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_HIBERN8TIME), 0);
+
+		if (attr->pa_granularity < 1 || attr->pa_granularity > 6) {
+			/* Valid range for granularity: 1 ~ 6 */
+			dev_warn(hba->dev,
+				"%s: pa_granularty %d is invalid, assuming backwards compatibility\n",
+				__func__,
+				attr->pa_granularity);
+			attr->pa_granularity = 6;
+		}
+	}
+
+	phy_calibrate(generic_phy);
+
+	if (ufs->drv_data->post_link)
+		ufs->drv_data->post_link(ufs);
+
+	return 0;
+}
+
+static int exynos_ufs_parse_dt(struct device *dev, struct exynos_ufs *ufs)
+{
+	struct device_node *np = dev->of_node;
+	struct exynos_ufs_drv_data *drv_data = &exynos_ufs_drvs;
+	struct exynos_ufs_uic_attr *attr;
+	u32 freq[2];
+	int ret;
+
+	while (drv_data->compatible) {
+		if (of_device_is_compatible(np, drv_data->compatible)) {
+			ufs->drv_data = drv_data;
+			break;
+		}
+		drv_data++;
+	}
+
+	if (ufs->drv_data && ufs->drv_data->uic_attr) {
+		attr = ufs->drv_data->uic_attr;
+	} else {
+		dev_err(dev, "failed to get uic attributes\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = of_property_read_u32_array(np,
+			"pclk-freq-avail-range", freq, ARRAY_SIZE(freq));
+	if (!ret) {
+		ufs->pclk_avail_min = freq[0];
+		ufs->pclk_avail_max = freq[1];
+	} else {
+		dev_err(dev, "failed to get available pclk range\n");
+		goto out;
+	}
+
+	attr->rx_adv_fine_gran_sup_en = RX_ADV_FINE_GRAN_SUP_EN;
+	attr->rx_adv_fine_gran_step = RX_ADV_FINE_GRAN_STEP_VAL;
+	attr->rx_adv_min_actv_time_cap = RX_ADV_MIN_ACTV_TIME_CAP;
+	attr->pa_granularity = PA_GRANULARITY_VAL;
+	attr->pa_tactivate = PA_TACTIVATE_VAL;
+	attr->pa_hibern8time = PA_HIBERN8TIME_VAL;
+
+out:
+	return ret;
+}
+
+static int exynos_ufs_init(struct ufs_hba *hba)
+{
+	struct device *dev = hba->dev;
+	struct platform_device *pdev = to_platform_device(dev);
+	struct exynos_ufs *ufs;
+	struct resource *res;
+	int ret;
+
+	ufs = devm_kzalloc(dev, sizeof(*ufs), GFP_KERNEL);
+	if (!ufs)
+		return -ENOMEM;
+
+	/* exynos-specific hci */
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "vs_hci");
+	ufs->reg_hci = devm_ioremap_resource(dev, res);
+	if (!ufs->reg_hci) {
+		dev_err(dev, "cannot ioremap for hci vendor register\n");
+		return -ENOMEM;
+	}
+
+	/* unipro */
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "unipro");
+	ufs->reg_unipro = devm_ioremap_resource(dev, res);
+	if (!ufs->reg_unipro) {
+		dev_err(dev, "cannot ioremap for unipro register\n");
+		return -ENOMEM;
+	}
+
+	/* ufs protector */
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "ufsp");
+	ufs->reg_ufsp = devm_ioremap_resource(dev, res);
+	if (!ufs->reg_ufsp) {
+		dev_err(dev, "cannot ioremap for ufs protector register\n");
+		return -ENOMEM;
+	}
+
+	ret = exynos_ufs_parse_dt(dev, ufs);
+	if (ret) {
+		dev_err(dev, "failed to get dt info.\n");
+		goto out;
+	}
+
+	ufs->phy = devm_phy_get(dev, "ufs-phy");
+	if (IS_ERR(ufs->phy)) {
+		ret = PTR_ERR(ufs->phy);
+		dev_err(dev, "failed to get ufs-phy\n");
+		goto out;
+	}
+
+	ret = phy_power_on(ufs->phy);
+	if (ret)
+		goto phy_exit;
+
+	ufs->hba = hba;
+	ufs->opts = ufs->drv_data->opts |
+		EXYNOS_UFS_OPT_SKIP_CONNECTION_ESTAB |
+		EXYNOS_UFS_OPT_USE_SW_HIBERN8_TIMER;
+	ufs->rx_sel_idx = PA_MAXDATALANES;
+	if (ufs->opts & EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX)
+		ufs->rx_sel_idx = 0;
+	hba->priv = (void *)ufs;
+	hba->quirks = ufs->drv_data->quirks;
+	if (ufs->drv_data->drv_init) {
+		ret = ufs->drv_data->drv_init(dev, ufs);
+		if (ret) {
+			dev_err(dev, "failed to init drv-data\n");
+			goto phy_off;
+		}
+	}
+
+	ret = exynos_ufs_get_clk_info(ufs);
+	if (ret)
+		goto phy_off;
+	exynos_ufs_specify_phy_time_attr(ufs);
+	exynos_ufs_config_smu(ufs);
+	return 0;
+
+phy_off:
+	phy_power_off(ufs->phy);
+phy_exit:
+	phy_exit(ufs->phy);
+	hba->priv = NULL;
+out:
+	return ret;
+}
+
+static int exynos_ufs_host_reset(struct ufs_hba *hba)
+{
+	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
+	unsigned long timeout = jiffies + msecs_to_jiffies(1);
+	u32 val;
+	int ret = 0;
+
+	exynos_ufs_disable_auto_ctrl_hcc_save(ufs, &val);
+
+	hci_writel(ufs, UFS_SW_RST_MASK, HCI_SW_RST);
+
+	do {
+		if (!(hci_readl(ufs, HCI_SW_RST) & UFS_SW_RST_MASK))
+			goto out;
+	} while (time_before(jiffies, timeout));
+
+	dev_err(hba->dev, "timeout host sw-reset\n");
+	ret = -ETIMEDOUT;
+
+out:
+	exynos_ufs_auto_ctrl_hcc_restore(ufs, &val);
+	return ret;
+}
+
+static void exynos_ufs_dev_hw_reset(struct ufs_hba *hba)
+{
+	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
+
+	hci_writel(ufs, 0 << 0, HCI_GPIO_OUT);
+	udelay(5);
+	hci_writel(ufs, 1 << 0, HCI_GPIO_OUT);
+}
+
+static void exynos_ufs_pre_hibern8(struct ufs_hba *hba, u8 enter)
+{
+	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
+	struct exynos_ufs_uic_attr *attr = ufs->drv_data->uic_attr;
+
+	if (!enter) {
+		if (ufs->opts & EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL)
+			exynos_ufs_disable_auto_ctrl_hcc(ufs);
+		exynos_ufs_ungate_clks(ufs);
+
+		if (ufs->opts & EXYNOS_UFS_OPT_USE_SW_HIBERN8_TIMER) {
+			const unsigned int granularity_tbl[] = {
+				1, 4, 8, 16, 32, 100
+			};
+			int h8_time = attr->pa_hibern8time *
+				granularity_tbl[attr->pa_granularity - 1];
+			unsigned long us;
+			s64 delta;
+
+			do {
+				delta = h8_time - ktime_us_delta(ktime_get(),
+							ufs->entry_hibern8_t);
+				if (delta <= 0)
+					break;
+
+				us = min_t(s64, delta, USEC_PER_MSEC);
+				if (us >= 10)
+					usleep_range(us, us + 10);
+			} while (1);
+		}
+	}
+}
+
+static void exynos_ufs_post_hibern8(struct ufs_hba *hba, u8 enter)
+{
+	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
+
+	if (!enter) {
+		u32 cur_mode = 0;
+		u32 pwrmode;
+
+		if (ufshcd_is_hs_mode(&ufs->dev_req_params))
+			pwrmode = FAST_MODE;
+		else
+			pwrmode = SLOW_MODE;
+
+		ufshcd_dme_get(hba, UIC_ARG_MIB(PA_PWRMODE), &cur_mode);
+		if (cur_mode != (pwrmode << 4 | pwrmode)) {
+			dev_warn(hba->dev, "%s: power mode change\n", __func__);
+			hba->pwr_info.pwr_rx = (cur_mode >> 4) & 0xf;
+			hba->pwr_info.pwr_tx = cur_mode & 0xf;
+			ufshcd_config_pwr_mode(hba, &hba->max_pwr_info.info);
+		}
+
+		if (!(ufs->opts & EXYNOS_UFS_OPT_SKIP_CONNECTION_ESTAB))
+			exynos_ufs_establish_connt(ufs);
+	} else {
+		ufs->entry_hibern8_t = ktime_get();
+		exynos_ufs_gate_clks(ufs);
+		if (ufs->opts & EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL)
+			exynos_ufs_enable_auto_ctrl_hcc(ufs);
+	}
+}
+
+static int exynos_ufs_hce_enable_notify(struct ufs_hba *hba,
+					enum ufs_notify_change_status status)
+{
+	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
+	int ret = 0;
+
+	switch (status) {
+	case PRE_CHANGE:
+		ret = exynos_ufs_host_reset(hba);
+		if (ret)
+			return ret;
+		exynos_ufs_dev_hw_reset(hba);
+		break;
+	case POST_CHANGE:
+		exynos_ufs_calc_pwm_clk_div(ufs);
+		if (!(ufs->opts & EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL))
+			exynos_ufs_enable_auto_ctrl_hcc(ufs);
+		break;
+	}
+
+	return ret;
+}
+
+static int exynos_ufs_link_startup_notify(struct ufs_hba *hba,
+					  enum ufs_notify_change_status status)
+{
+	int ret = 0;
+
+	switch (status) {
+	case PRE_CHANGE:
+		ret = exynos_ufs_pre_link(hba);
+		break;
+	case POST_CHANGE:
+		ret = exynos_ufs_post_link(hba);
+		break;
+	}
+
+	return ret;
+}
+
+static int exynos_ufs_pwr_change_notify(struct ufs_hba *hba,
+				enum ufs_notify_change_status status,
+				struct ufs_pa_layer_attr *dev_max_params,
+				struct ufs_pa_layer_attr *dev_req_params)
+{
+	int ret = 0;
+
+	switch (status) {
+	case PRE_CHANGE:
+		ret = exynos_ufs_pre_pwr_mode(hba, dev_max_params,
+					      dev_req_params);
+		break;
+	case POST_CHANGE:
+		ret = exynos_ufs_post_pwr_mode(hba, NULL, dev_req_params);
+		break;
+	}
+
+	return ret;
+}
+
+static void exynos_ufs_hibern8_notify(struct ufs_hba *hba,
+				     enum uic_cmd_dme enter,
+				     enum ufs_notify_change_status notify)
+{
+	switch ((u8)notify) {
+	case PRE_CHANGE:
+		exynos_ufs_pre_hibern8(hba, enter);
+		break;
+	case POST_CHANGE:
+		exynos_ufs_post_hibern8(hba, enter);
+		break;
+	}
+}
+
+static int exynos_ufs_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
+{
+	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
+
+	if (!ufshcd_is_link_active(hba))
+		phy_power_off(ufs->phy);
+
+	return 0;
+}
+
+static int exynos_ufs_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
+{
+	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
+
+	if (!ufshcd_is_link_active(hba))
+		phy_power_on(ufs->phy);
+
+	exynos_ufs_config_smu(ufs);
+
+	return 0;
+}
+
+static struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
+	.name				= "exynos_ufs",
+	.init				= exynos_ufs_init,
+	.hce_enable_notify		= exynos_ufs_hce_enable_notify,
+	.link_startup_notify		= exynos_ufs_link_startup_notify,
+	.pwr_change_notify		= exynos_ufs_pwr_change_notify,
+	.setup_xfer_req			= exynos_ufs_specify_nexus_t_xfer_req,
+	.setup_task_mgmt		= exynos_ufs_specify_nexus_t_tm_req,
+	.hibern8_notify			= exynos_ufs_hibern8_notify,
+	.suspend			= exynos_ufs_suspend,
+	.resume				= exynos_ufs_resume,
+};
+
+static int exynos_ufs_probe(struct platform_device *pdev)
+{
+	int err;
+	struct device *dev = &pdev->dev;
+
+	err = ufshcd_pltfrm_init(pdev, &ufs_hba_exynos_ops);
+	if (err)
+		dev_err(dev, "ufshcd_pltfrm_init() failed %d\n", err);
+
+	return err;
+}
+
+static int exynos_ufs_remove(struct platform_device *pdev)
+{
+	struct ufs_hba *hba =  platform_get_drvdata(pdev);
+
+	pm_runtime_get_sync(&(pdev)->dev);
+	ufshcd_remove(hba);
+	return 0;
+}
+
+struct exynos_ufs_drv_data exynos_ufs_drvs = {
+
+	.compatible		= "samsung,exynos7-ufs",
+	.uic_attr		= &exynos7_uic_attr,
+	.quirks			= UFSHCD_QUIRK_PRDT_BYTE_GRAN |
+				  UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR |
+				  UFSHCI_QUIRK_BROKEN_HCE |
+				  UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR |
+				  UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR,
+	.opts			= EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL |
+				  EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL |
+				  EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX,
+	.drv_init		= exynos7_ufs_drv_init,
+	.pre_link		= exynos7_ufs_pre_link,
+	.post_link		= exynos7_ufs_post_link,
+	.pre_pwr_change		= exynos7_ufs_pre_pwr_change,
+	.post_pwr_change	= exynos7_ufs_post_pwr_change,
+};
+
+static const struct of_device_id exynos_ufs_of_match[] = {
+	{ .compatible = "samsung,exynos7-ufs",
+	  .data	      = &exynos_ufs_drvs },
+	{},
+};
+
+static const struct dev_pm_ops exynos_ufs_pm_ops = {
+	.suspend	= ufshcd_pltfrm_suspend,
+	.resume		= ufshcd_pltfrm_resume,
+	.runtime_suspend = ufshcd_pltfrm_runtime_suspend,
+	.runtime_resume  = ufshcd_pltfrm_runtime_resume,
+	.runtime_idle    = ufshcd_pltfrm_runtime_idle,
+};
+
+static struct platform_driver exynos_ufs_pltform = {
+	.probe	= exynos_ufs_probe,
+	.remove	= exynos_ufs_remove,
+	.shutdown = ufshcd_pltfrm_shutdown,
+	.driver	= {
+		.name	= "exynos-ufshc",
+		.pm	= &exynos_ufs_pm_ops,
+		.of_match_table = of_match_ptr(exynos_ufs_of_match),
+	},
+};
+module_platform_driver(exynos_ufs_pltform);
diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
new file mode 100644
index 000000000000..813b286afd9d
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-exynos.h
@@ -0,0 +1,284 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * UFS Host Controller driver for Exynos specific extensions
+ *
+ * Copyright (C) 2014-2015 Samsung Electronics Co., Ltd.
+ *
+ */
+
+#ifndef _UFS_EXYNOS_H_
+#define _UFS_EXYNOS_H_
+
+/*
+ * UNIPRO registers
+ */
+#define UNIPRO_DBG_FORCE_DME_CTRL_STATE		0x150
+
+/*
+ * MIBs for PA debug registers
+ */
+#define PA_DBG_CLK_PERIOD	0x9514
+#define PA_DBG_TXPHY_CFGUPDT	0x9518
+#define PA_DBG_RXPHY_CFGUPDT	0x9519
+#define PA_DBG_MODE		0x9529
+#define PA_DBG_SKIP_RESET_PHY	0x9539
+#define PA_DBG_OV_TM		0x9540
+#define PA_DBG_SKIP_LINE_RESET	0x9541
+#define PA_DBG_LINE_RESET_REQ	0x9543
+#define PA_DBG_OPTION_SUITE	0x9564
+#define PA_DBG_OPTION_SUITE_DYN	0x9565
+
+/*
+ * MIBs for Transport Layer debug registers
+ */
+#define T_DBG_SKIP_INIT_HIBERN8_EXIT	0xc001
+
+/*
+ * Exynos MPHY attributes
+ */
+#define TX_LINERESET_N_VAL	0x0277
+#define TX_LINERESET_N(v)	(((v) >> 10) & 0xFF)
+#define TX_LINERESET_P_VAL	0x027D
+#define TX_LINERESET_P(v)	(((v) >> 12) & 0xFF)
+#define TX_OV_SLEEP_CNT_TIMER	0x028E
+#define TX_OV_H8_ENTER_EN	(1 << 7)
+#define TX_OV_SLEEP_CNT(v)	(((v) >> 5) & 0x7F)
+#define TX_HIGH_Z_CNT_11_08	0x028C
+#define TX_HIGH_Z_CNT_H(v)	(((v) >> 8) & 0xF)
+#define TX_HIGH_Z_CNT_07_00	0x028D
+#define TX_HIGH_Z_CNT_L(v)	((v) & 0xFF)
+#define TX_BASE_NVAL_07_00	0x0293
+#define TX_BASE_NVAL_L(v)	((v) & 0xFF)
+#define TX_BASE_NVAL_15_08	0x0294
+#define TX_BASE_NVAL_H(v)	(((v) >> 8) & 0xFF)
+#define TX_GRAN_NVAL_07_00	0x0295
+#define TX_GRAN_NVAL_L(v)	((v) & 0xFF)
+#define TX_GRAN_NVAL_10_08	0x0296
+#define TX_GRAN_NVAL_H(v)	(((v) >> 8) & 0x3)
+
+#define RX_FILLER_ENABLE	0x0316
+#define RX_FILLER_EN		(1 << 1)
+#define RX_LINERESET_VAL	0x0317
+#define RX_LINERESET(v)	(((v) >> 12) & 0xFF)
+#define RX_LCC_IGNORE		0x0318
+#define RX_SYNC_MASK_LENGTH	0x0321
+#define RX_HIBERN8_WAIT_VAL_BIT_20_16	0x0331
+#define RX_HIBERN8_WAIT_VAL_BIT_15_08	0x0332
+#define RX_HIBERN8_WAIT_VAL_BIT_07_00	0x0333
+#define RX_OV_SLEEP_CNT_TIMER	0x0340
+#define RX_OV_SLEEP_CNT(v)	(((v) >> 6) & 0x1F)
+#define RX_OV_STALL_CNT_TIMER	0x0341
+#define RX_OV_STALL_CNT(v)	(((v) >> 4) & 0xFF)
+#define RX_BASE_NVAL_07_00	0x0355
+#define RX_BASE_NVAL_L(v)	((v) & 0xFF)
+#define RX_BASE_NVAL_15_08	0x0354
+#define RX_BASE_NVAL_H(v)	(((v) >> 8) & 0xFF)
+#define RX_GRAN_NVAL_07_00	0x0353
+#define RX_GRAN_NVAL_L(v)	((v) & 0xFF)
+#define RX_GRAN_NVAL_10_08	0x0352
+#define RX_GRAN_NVAL_H(v)	(((v) >> 8) & 0x3)
+
+#define CMN_PWM_CLK_CTRL	0x0402
+#define PWM_CLK_CTRL_MASK	0x3
+
+#define IATOVAL_NSEC		20000	/* unit: ns */
+#define UNIPRO_PCLK_PERIOD(ufs) (NSEC_PER_SEC / ufs->pclk_rate)
+
+struct exynos_ufs;
+
+/* vendor specific pre-defined parameters */
+#define SLOW 1
+#define FAST 2
+
+#define UFS_EXYNOS_LIMIT_NUM_LANES_RX	2
+#define UFS_EXYNOS_LIMIT_NUM_LANES_TX	2
+#define UFS_EXYNOS_LIMIT_HSGEAR_RX	UFS_HS_G3
+#define UFS_EXYNOS_LIMIT_HSGEAR_TX	UFS_HS_G3
+#define UFS_EXYNOS_LIMIT_PWMGEAR_RX	UFS_PWM_G4
+#define UFS_EXYNOS_LIMIT_PWMGEAR_TX	UFS_PWM_G4
+#define UFS_EXYNOS_LIMIT_RX_PWR_PWM	SLOW_MODE
+#define UFS_EXYNOS_LIMIT_TX_PWR_PWM	SLOW_MODE
+#define UFS_EXYNOS_LIMIT_RX_PWR_HS	FAST_MODE
+#define UFS_EXYNOS_LIMIT_TX_PWR_HS	FAST_MODE
+#define UFS_EXYNOS_LIMIT_HS_RATE		PA_HS_MODE_B
+#define UFS_EXYNOS_LIMIT_DESIRED_MODE	FAST
+
+#define RX_ADV_FINE_GRAN_SUP_EN	0x1
+#define RX_ADV_FINE_GRAN_STEP_VAL	0x3
+#define RX_ADV_MIN_ACTV_TIME_CAP	0x9
+
+#define PA_GRANULARITY_VAL	0x6
+#define PA_TACTIVATE_VAL	0x3
+#define PA_HIBERN8TIME_VAL	0x20
+
+struct exynos_ufs_uic_attr {
+	/* TX Attributes */
+	unsigned int tx_trailingclks;
+	unsigned int tx_dif_p_nsec;
+	unsigned int tx_dif_n_nsec;
+	unsigned int tx_high_z_cnt_nsec;
+	unsigned int tx_base_unit_nsec;
+	unsigned int tx_gran_unit_nsec;
+	unsigned int tx_sleep_cnt;
+	unsigned int tx_min_activatetime;
+	/* RX Attributes */
+	unsigned int rx_filler_enable;
+	unsigned int rx_dif_p_nsec;
+	unsigned int rx_hibern8_wait_nsec;
+	unsigned int rx_base_unit_nsec;
+	unsigned int rx_gran_unit_nsec;
+	unsigned int rx_sleep_cnt;
+	unsigned int rx_stall_cnt;
+	unsigned int rx_hs_g1_sync_len_cap;
+	unsigned int rx_hs_g2_sync_len_cap;
+	unsigned int rx_hs_g3_sync_len_cap;
+	unsigned int rx_hs_g1_prep_sync_len_cap;
+	unsigned int rx_hs_g2_prep_sync_len_cap;
+	unsigned int rx_hs_g3_prep_sync_len_cap;
+	/* Common Attributes */
+	unsigned int cmn_pwm_clk_ctrl;
+	/* Internal Attributes */
+	unsigned int pa_dbg_option_suite;
+	/* Changeable Attributes */
+	unsigned int rx_adv_fine_gran_sup_en;
+	unsigned int rx_adv_fine_gran_step;
+	unsigned int rx_min_actv_time_cap;
+	unsigned int rx_hibern8_time_cap;
+	unsigned int rx_adv_min_actv_time_cap;
+	unsigned int rx_adv_hibern8_time_cap;
+	unsigned int pa_granularity;
+	unsigned int pa_tactivate;
+	unsigned int pa_hibern8time;
+};
+
+struct exynos_ufs_drv_data {
+	char *compatible;
+	struct exynos_ufs_uic_attr *uic_attr;
+	unsigned int quirks;
+	unsigned int opts;
+	/* SoC's specific operations */
+	int (*drv_init)(struct device *dev, struct exynos_ufs *ufs);
+	int (*pre_link)(struct exynos_ufs *ufs);
+	int (*post_link)(struct exynos_ufs *ufs);
+	int (*pre_pwr_change)(struct exynos_ufs *ufs,
+				struct ufs_pa_layer_attr *pwr);
+	int (*post_pwr_change)(struct exynos_ufs *ufs,
+				struct ufs_pa_layer_attr *pwr);
+};
+
+struct ufs_phy_time_cfg {
+	u32 tx_linereset_p;
+	u32 tx_linereset_n;
+	u32 tx_high_z_cnt;
+	u32 tx_base_n_val;
+	u32 tx_gran_n_val;
+	u32 tx_sleep_cnt;
+	u32 rx_linereset;
+	u32 rx_hibern8_wait;
+	u32 rx_base_n_val;
+	u32 rx_gran_n_val;
+	u32 rx_sleep_cnt;
+	u32 rx_stall_cnt;
+};
+
+struct exynos_ufs {
+	struct ufs_hba *hba;
+	struct phy *phy;
+	void __iomem *reg_hci;
+	void __iomem *reg_unipro;
+	void __iomem *reg_ufsp;
+	struct clk *clk_hci_core;
+	struct clk *clk_unipro_main;
+	struct clk *clk_apb;
+	u32 pclk_rate;
+	u32 pclk_div;
+	u32 pclk_avail_min;
+	u32 pclk_avail_max;
+	u32 mclk_rate;
+	int avail_ln_rx;
+	int avail_ln_tx;
+	int rx_sel_idx;
+	struct ufs_pa_layer_attr dev_req_params;
+	struct ufs_phy_time_cfg t_cfg;
+	ktime_t entry_hibern8_t;
+	struct exynos_ufs_drv_data *drv_data;
+
+	u32 opts;
+#define EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL		BIT(0)
+#define EXYNOS_UFS_OPT_SKIP_CONNECTION_ESTAB	BIT(1)
+#define EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL	BIT(2)
+#define EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX	BIT(3)
+#define EXYNOS_UFS_OPT_USE_SW_HIBERN8_TIMER	BIT(4)
+};
+
+#define for_each_ufs_rx_lane(ufs, i) \
+	for (i = (ufs)->rx_sel_idx; \
+		i < (ufs)->rx_sel_idx + (ufs)->avail_ln_rx; i++)
+#define for_each_ufs_tx_lane(ufs, i) \
+	for (i = 0; i < (ufs)->avail_ln_tx; i++)
+
+#define EXYNOS_UFS_MMIO_FUNC(name)					  \
+static inline void name##_writel(struct exynos_ufs *ufs, u32 val, u32 reg)\
+{									  \
+	writel(val, ufs->reg_##name + reg);				  \
+}									  \
+									  \
+static inline u32 name##_readl(struct exynos_ufs *ufs, u32 reg)		  \
+{									  \
+	return readl(ufs->reg_##name + reg);				  \
+}
+
+EXYNOS_UFS_MMIO_FUNC(hci);
+EXYNOS_UFS_MMIO_FUNC(unipro);
+EXYNOS_UFS_MMIO_FUNC(ufsp);
+#undef EXYNOS_UFS_MMIO_FUNC
+
+long exynos_ufs_calc_time_cntr(struct exynos_ufs *, long);
+
+static inline void exynos_ufs_enable_ov_tm(struct ufs_hba *hba)
+{
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_OV_TM), TRUE);
+}
+
+static inline void exynos_ufs_disable_ov_tm(struct ufs_hba *hba)
+{
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_OV_TM), FALSE);
+}
+
+static inline void exynos_ufs_enable_dbg_mode(struct ufs_hba *hba)
+{
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_MODE), TRUE);
+}
+
+static inline void exynos_ufs_disable_dbg_mode(struct ufs_hba *hba)
+{
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_MODE), FALSE);
+}
+
+struct exynos_ufs_drv_data exynos_ufs_drvs;
+
+struct exynos_ufs_uic_attr exynos7_uic_attr = {
+	.tx_trailingclks		= 0x10,
+	.tx_dif_p_nsec			= 3000000,	/* unit: ns */
+	.tx_dif_n_nsec			= 1000000,	/* unit: ns */
+	.tx_high_z_cnt_nsec		= 20000,	/* unit: ns */
+	.tx_base_unit_nsec		= 100000,	/* unit: ns */
+	.tx_gran_unit_nsec		= 4000,		/* unit: ns */
+	.tx_sleep_cnt			= 1000,		/* unit: ns */
+	.tx_min_activatetime		= 0xa,
+	.rx_filler_enable		= 0x2,
+	.rx_dif_p_nsec			= 1000000,	/* unit: ns */
+	.rx_hibern8_wait_nsec		= 4000000,	/* unit: ns */
+	.rx_base_unit_nsec		= 100000,	/* unit: ns */
+	.rx_gran_unit_nsec		= 4000,		/* unit: ns */
+	.rx_sleep_cnt			= 1280,		/* unit: ns */
+	.rx_stall_cnt			= 320,		/* unit: ns */
+	.rx_hs_g1_sync_len_cap		= SYNC_LEN_COARSE(0xf),
+	.rx_hs_g2_sync_len_cap		= SYNC_LEN_COARSE(0xf),
+	.rx_hs_g3_sync_len_cap		= SYNC_LEN_COARSE(0xf),
+	.rx_hs_g1_prep_sync_len_cap	= PREP_LEN(0xf),
+	.rx_hs_g2_prep_sync_len_cap	= PREP_LEN(0xf),
+	.rx_hs_g3_prep_sync_len_cap	= PREP_LEN(0xf),
+	.pa_dbg_option_suite		= 0x30103,
+};
+#endif /* _UFS_EXYNOS_H_ */
diff --git a/drivers/scsi/ufs/unipro.h b/drivers/scsi/ufs/unipro.h
index 766d551df3fc..4ee64782fd48 100644
--- a/drivers/scsi/ufs/unipro.h
+++ b/drivers/scsi/ufs/unipro.h
@@ -64,8 +64,25 @@
 #define CFGRXOVR4				0x00E9
 #define RXSQCTRL				0x00B5
 #define CFGRXOVR6				0x00BF
+#define RX_HS_G1_SYNC_LENGTH_CAP		0x008B
+#define RX_HS_G1_PREP_LENGTH_CAP		0x008C
+#define RX_HS_G2_SYNC_LENGTH_CAP		0x0094
+#define RX_HS_G3_SYNC_LENGTH_CAP		0x0095
+#define RX_HS_G2_PREP_LENGTH_CAP		0x0096
+#define RX_HS_G3_PREP_LENGTH_CAP		0x0097
+#define RX_ADV_GRANULARITY_CAP			0x0098
+#define RX_MIN_ACTIVATETIME_CAP			0x008F
+#define RX_HIBERN8TIME_CAP			0x0092
+#define RX_ADV_HIBERN8TIME_CAP			0x0099
+#define RX_ADV_MIN_ACTIVATETIME_CAP		0x009A
+
 
 #define is_mphy_tx_attr(attr)			(attr < RX_MODE)
+#define RX_ADV_FINE_GRAN_STEP(x)		((((x) & 0x3) << 1) | 0x1)
+#define SYNC_LEN_FINE(x)			((x) & 0x3F)
+#define SYNC_LEN_COARSE(x)			((1 << 6) | ((x) & 0x3F))
+#define PREP_LEN(x)				((x) & 0xF)
+
 #define RX_MIN_ACTIVATETIME_UNIT_US		100
 #define HIBERN8TIME_UNIT_US			100
 
@@ -124,6 +141,7 @@
 #define PA_PACPREQEOBTIMEOUT	0x1591
 #define PA_HIBERN8TIME		0x15A7
 #define PA_LOCALVERINFO		0x15A9
+#define PA_GRANULARITY		0x15AA
 #define PA_TACTIVATE		0x15A8
 #define PA_PACPFRAMECOUNT	0x15C0
 #define PA_PACPERRORCOUNT	0x15C1
@@ -291,4 +309,19 @@ enum {
 	TRUE,
 };
 
+/* CPort setting */
+#define E2EFC_ON	(1 << 0)
+#define E2EFC_OFF	(0 << 0)
+#define CSD_N_ON	(0 << 1)
+#define CSD_N_OFF	(1 << 1)
+#define CSV_N_ON	(0 << 2)
+#define CSV_N_OFF	(1 << 2)
+#define CPORT_DEF_FLAGS	(CSV_N_OFF | CSD_N_OFF | E2EFC_OFF)
+
+/* CPort connection state */
+enum {
+	CPORT_IDLE = 0,
+	CPORT_CONNECTED,
+};
+
 #endif /* _UNIPRO_H_ */
-- 
2.17.1

