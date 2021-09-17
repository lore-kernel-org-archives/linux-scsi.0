Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24C2CC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 06:56:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C4AF6112E
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 06:56:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238806AbhIQG5V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 02:57:21 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:29122 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238537AbhIQG4y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 02:56:54 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210917065528epoutp04430608f8885ed4696082a4bea8431fcc~liZi2-QYz2951729517epoutp046
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 06:55:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210917065528epoutp04430608f8885ed4696082a4bea8431fcc~liZi2-QYz2951729517epoutp046
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1631861729;
        bh=Q+1FOwMmvt/UfNZkgGqvo73CngjvQQxZR7qopF6TtmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VhjDvrKwVY8XE0LJ9MTMQSYsz7miJuNRvpAMJxgzGmVNkRKDQ0Fvwz5ZVo1Zgj1hn
         EqR3BZyBgem4UaQ3GwiN8X6MnYwmrcE8ZrBJRxHdjJvkJz9I89emmqMMTr0BM+Jg5M
         +eBiGoIqKkadDO4ffUkR1n5gE2XmNsGWbTXET988=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210917065528epcas2p1800d6bb845fb30d89d4c5e34002e2125~liZiN61Zm0293602936epcas2p1S;
        Fri, 17 Sep 2021 06:55:28 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.186]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4H9l8F00D1z4x9Q7; Fri, 17 Sep
        2021 06:55:24 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        D8.DF.09472.CDB34416; Fri, 17 Sep 2021 15:55:24 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210917065523epcas2p47156d9fba5b8d8a5e5908ccdc0ae1655~liZeH9Utn0164301643epcas2p4U;
        Fri, 17 Sep 2021 06:55:23 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210917065523epsmtrp28e142187a5921e25f8eff88fd68e8466~liZeG5qgB1371513715epsmtrp2T;
        Fri, 17 Sep 2021 06:55:23 +0000 (GMT)
X-AuditID: b6c32a48-d75ff70000002500-50-61443bdce05f
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        6C.91.08750.BDB34416; Fri, 17 Sep 2021 15:55:23 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210917065523epsmtip2234377e40163045a1196fbc91726c72e~liZd7tMHN1565515655epsmtip2o;
        Fri, 17 Sep 2021 06:55:23 +0000 (GMT)
From:   Chanho Park <chanho61.park@samsung.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Can Guo <cang@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v3 14/17] scsi: ufs: ufs-exynos: support exynosauto v9 ufs
 driver
Date:   Fri, 17 Sep 2021 15:54:33 +0900
Message-Id: <20210917065436.145629-15-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210917065436.145629-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02TfUwbZRzHfe5uR2F0O1qUx8aXeupwaFlLKDs2GBPIPNkSiSS6MGd3oRdK
        LG3XAzYUTbdJRykQDC9jZaID3VhFOysw2gjyZpCZCBFwyNwAx0RYGG+TCTqw5brIf5/f7/l+
        83t5nkeAiq7jEkGGLos16hgtiQdgzV3bo2S/7U5k5O7mUKp3ogGnxmqacWpqeQinOsYtGFU5
        t4xSC44Lm6iB716kilwJ1I+ltQg14bChVO1wM0J9PfM3Qv3a+D1GVfW1IZT1WgtOXexZRfYS
        9MDgftpmKsbpgZJihP6mPoyu+3YKoZ12C06X1rYD+r6jAKfnb49gdEmjHdCLzqfo0+1WJDkw
        VRujYRk1a5SyujS9OkOXHkvuT1ElqJRRcoVMEU3tJKU6JpONJRMPJMv2ZWg9I5HSHEab7Ukl
        MxxH7tgTY9RnZ7FSjZ7LiiVZg1prUCgM4RyTyWXr0sPT9Jm7FHJ5hNKjPKLVzI03YAZL6PGa
        NgdmAoPSQuAvgEQk7GpewApBgEBEtADYuvQZzgcLAN7r+wnwwSKAc/muTQ8tJ286fRY3gDeG
        K3yWeQAL60/iXhVOyGDj5PS6PZiYBXDiVrmfN0AJGwp7/ipDvCoxkQInZ83AyxjxPLTbuv28
        LCT2wrrVqwhf72nYvWJBvezvyY+41wCvCYK9ZycwL6MezammapTXDwvgncEgnhPhsOuSr28x
        nO5p9ONZAhfvtq63DQkrgPm/r/kOvgDQcuIAz3Fw5UyjxyzwFNgOHe4dXoTEs7B7xFd2Cyzo
        euDHp4WwwCzijaGw/coZjOcnofXcoq8DGv48dMO30jIAa3vzkVIgtW2YxrZhGtv/hT8FqB08
        xhq4zHSWizBEbrxjJ1h/5WF0C6iemQvvBIgAdAIoQMlgYX/ey4xIqGZy32WNepUxW8tynUDp
        2fVHqOTRNL3nm+iyVAplRFSUPFpJKaMiKDJE+PFqPCMi0pks9h2WNbDGhz5E4C8xIZFJplvT
        Uvmr5eIv0dEtfUtS3Qt5f166Y1drkPHntr0eEu80y3LbfqheKpfkTJ69YkBrlg+PHourbdns
        GnKWHxLfDOnq+ld3IuZyR8tAQeCefFI0oJ663L6y7ZFzWxNwWccHbvnY/KIQT7qQFHC7gjtv
        ii82S4OxmLcaUqYri4s++Tyu6WDM2+IZ3F3VM7/voL/DUvV+fcnW+22tualleRdVb1TMl5sf
        D4y8yhxteCVo6sMHOU/cS1n+g/pn83vCl0aPza7usg9dE9b1u1NSC+JaHYeup/b7jxY1dUaf
        EuRKhtYS65j2r3aLx+z0zqNJR3pee/OXoARrxenzlVWHXc+4FGYdiXEaRhGGGjnmP894Q/Nu
        BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsWy7bCSvO5ta5dEg4lrjSxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZotP65exWlzer23Rs9PZ4vSERUwWT9bPYrZYdGMbk8XGtz+YLG5u
        OcpiMeP8PiaL7us72CyWH//H5CDgcfmKt8eshl42j8t9vUwem1doeSze85LJY9OqTjaPCYsO
        MHp8X9/B5vHx6S0Wj74tqxg9Pm+S82g/0M0UwBPFZZOSmpNZllqkb5fAlfHh4RqWgk71inn7
        1rM0MF5R6GLk5JAQMJFoureJpYuRi0NIYAejxIrft1ghErISz97tYIewhSXutxxhhSh6zyjx
        Z9cBsCI2AV2JLc9fMYLYIgIfGSXmfNMCKWIWWMIs0XhgHhNIQlggUKJx6i4WEJtFQFVi1awj
        YFN5BRwkFv87xQSxQV7iyK9OZhCbEyh+a9d/sKFCAvYSEycvYoSoF5Q4OfMJ2BxmoPrmrbOZ
        JzAKzEKSmoUktYCRaRWjZGpBcW56brFhgVFearlecWJucWleul5yfu4mRnDEaWntYNyz6oPe
        IUYmDsZDjBIczEoivBdqHBOFeFMSK6tSi/Lji0pzUosPMUpzsCiJ817oOhkvJJCeWJKanZpa
        kFoEk2Xi4JRqYGoQ9So+JvJTOlmzUam96PWLXluW5Tsc+ZJeHT0feaK8caPd401ML9m//GAr
        UMuYY2R8aG6DmcZNy4sSl0IWL+zo90qY6DpF8Kmw/ofW7+cT8nlsbWtWPdDyCrv743ih/H31
        f49z2T4xmu9LYlfgfnRGWDTc0vKhmuS95oU/Ulwm/r5XNKHYeUsmz5Nq159M8pzLrXwfcGyM
        12s91THB4pe1Xd/x5rZYdndG95kTPwU53674Yv8oM/qdQIKMRMnWp8Hnvm407z3bs0Vw98Pb
        U9/cTN/jL3F556RP+1o/TLm2mWUfW+ikFK81d5tXz8iV0JES2PMgITh1Tv39GzO0jknpTdt4
        58zFpuUpWoc5tZRYijMSDbWYi4oTAZ455K4nAwAA
X-CMS-MailID: 20210917065523epcas2p47156d9fba5b8d8a5e5908ccdc0ae1655
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210917065523epcas2p47156d9fba5b8d8a5e5908ccdc0ae1655
References: <20210917065436.145629-1-chanho61.park@samsung.com>
        <CGME20210917065523epcas2p47156d9fba5b8d8a5e5908ccdc0ae1655@epcas2p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds to support ufs variant for ExynosAuto v9 SoC. This
requires control UFS IP sharability register via syscon and regmap.
Regarding uic_attr, most of values can be shared with exynos7 except
tx_dif_p_nsec value.

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 96 +++++++++++++++++++++++++++++++++++
 1 file changed, 96 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 7fb4514f700d..28f027d45917 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -15,6 +15,7 @@
 #include <linux/mfd/syscon.h>
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
+#include <linux/regmap.h>
 
 #include "ufshcd.h"
 #include "ufshcd-pltfrm.h"
@@ -76,6 +77,12 @@
 				 UIC_TRANSPORT_NO_CONNECTION_RX |\
 				 UIC_TRANSPORT_BAD_TC)
 
+/* FSYS UFS Shareability */
+#define UFS_WR_SHARABLE		BIT(2)
+#define UFS_RD_SHARABLE		BIT(1)
+#define UFS_SHARABLE		(UFS_WR_SHARABLE | UFS_RD_SHARABLE)
+#define UFS_SHAREABILITY_OFFSET	0x710
+
 enum {
 	UNIPRO_L1_5 = 0,/* PHY Adapter */
 	UNIPRO_L2,	/* Data Link */
@@ -151,6 +158,79 @@ static int exynos7_ufs_drv_init(struct device *dev, struct exynos_ufs *ufs)
 	return 0;
 }
 
+static int exynosauto_ufs_drv_init(struct device *dev, struct exynos_ufs *ufs)
+{
+	struct exynos_ufs_uic_attr *attr = ufs->drv_data->uic_attr;
+
+	/* IO Coherency setting */
+	if (ufs->sysreg) {
+		return regmap_update_bits(ufs->sysreg, UFS_SHAREABILITY_OFFSET,
+					  UFS_SHARABLE, UFS_SHARABLE);
+	}
+
+	attr->tx_dif_p_nsec = 3200000;
+
+	return 0;
+}
+
+static int exynosauto_ufs_pre_link(struct exynos_ufs *ufs)
+{
+	struct ufs_hba *hba = ufs->hba;
+	int i;
+
+	ufshcd_dme_set(hba, UIC_ARG_MIB(0x200), 0x40);
+	for_each_ufs_rx_lane(ufs, i) {
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x12, i),
+			       DIV_ROUND_UP(NSEC_PER_SEC, ufs->mclk_rate));
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x11, i), 0x0);
+
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x1b, i), 0x2);
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x1c, i), 0x8a);
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x1d, i), 0xa3);
+
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x1b, i), 0x2);
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x1c, i), 0x8a);
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x1d, i), 0xa3);
+
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x2f, i), 0x79);
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x84, i), 0x1);
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x25, i), 0xf6);
+	}
+
+	for_each_ufs_tx_lane(ufs, i) {
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xaa, i),
+			       DIV_ROUND_UP(NSEC_PER_SEC, ufs->mclk_rate));
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xa9, i), 0x02);
+
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xab, i), 0x8);
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xac, i), 0x22);
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xad, i), 0x8);
+
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x04, i), 0x1);
+	}
+
+	ufshcd_dme_set(hba, UIC_ARG_MIB(0x200), 0x0);
+
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_LOCAL_TX_LCC_ENABLE), 0x0);
+
+	ufshcd_dme_set(hba, UIC_ARG_MIB(0xa011), 0x8000);
+
+	return 0;
+}
+
+static int exynosauto_ufs_pre_pwr_change(struct exynos_ufs *ufs,
+					 struct ufs_pa_layer_attr *pwr)
+{
+	struct ufs_hba *hba = ufs->hba;
+
+	/* PACP_PWR_req and delivered to the remote DME */
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA0), 12000);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA1), 32000);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA2), 16000);
+
+	return 0;
+}
+
 static int exynos7_ufs_pre_link(struct exynos_ufs *ufs)
 {
 	struct ufs_hba *hba = ufs->hba;
@@ -1305,6 +1385,20 @@ static struct exynos_ufs_uic_attr exynos7_uic_attr = {
 	.pa_dbg_option_suite		= 0x30103,
 };
 
+static struct exynos_ufs_drv_data exynosauto_ufs_drvs = {
+	.uic_attr		= &exynos7_uic_attr,
+	.quirks			= UFSHCD_QUIRK_PRDT_BYTE_GRAN |
+				  UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR |
+				  UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR |
+				  UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING,
+	.opts			= EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL |
+				  EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR |
+				  EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX,
+	.drv_init		= exynosauto_ufs_drv_init,
+	.pre_link		= exynosauto_ufs_pre_link,
+	.pre_pwr_change		= exynosauto_ufs_pre_pwr_change,
+};
+
 static struct exynos_ufs_drv_data exynos_ufs_drvs = {
 	.uic_attr		= &exynos7_uic_attr,
 	.quirks			= UFSHCD_QUIRK_PRDT_BYTE_GRAN |
@@ -1330,6 +1424,8 @@ static struct exynos_ufs_drv_data exynos_ufs_drvs = {
 static const struct of_device_id exynos_ufs_of_match[] = {
 	{ .compatible = "samsung,exynos7-ufs",
 	  .data	      = &exynos_ufs_drvs },
+	{ .compatible = "samsung,exynosautov9-ufs",
+	  .data	      = &exynosauto_ufs_drvs },
 	{},
 };
 
-- 
2.33.0

