Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC831C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 08:12:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B870C610C7
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 08:12:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240690AbhJGIOH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 04:14:07 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:42939 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240634AbhJGIOB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 04:14:01 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20211007081206epoutp015b3c0fa2aa782609deff83fc2f4ddb21~rsWKfzWRa1989419894epoutp01F
        for <linux-scsi@vger.kernel.org>; Thu,  7 Oct 2021 08:12:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20211007081206epoutp015b3c0fa2aa782609deff83fc2f4ddb21~rsWKfzWRa1989419894epoutp01F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1633594327;
        bh=b89H/KFQElrNIzeUUmTjG5KZK98QmFXSuwoXff9249M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rJ8XrSALcG8QaAn0jMHP1hHbqo+xlV7VhDQg/ihN8xCKSnSZyCAQFM5H/ASGj76LT
         khCA/Vw4k6/Ga7ZjYbxt9MfOkhXXUcfiAN2Ox0xf5yMWFGlnAK3tK2TEefKurwukdD
         YBQGuxwXjxy7HGsbgtkKNL4oe3xxkDbcU3SUsW64=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20211007081146epcas2p4d085c688bc8e47b21a4a89710b96d1fd~rsV3l7F1o2863928639epcas2p4a;
        Thu,  7 Oct 2021 08:11:46 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.90]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4HQ3v03Gcrz4x9RX; Thu,  7 Oct
        2021 08:11:40 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        18.F7.09472.8BBAE516; Thu,  7 Oct 2021 17:11:36 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20211007081135epcas2p410e67850fdd25fc762b0bfa49c6e24f1~rsVtJN22O3097830978epcas2p4a;
        Thu,  7 Oct 2021 08:11:35 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211007081135epsmtrp135057cd4219fd16f4e5f5eabcbd3eb3c~rsVtILx5S2192321923epsmtrp1r;
        Thu,  7 Oct 2021 08:11:35 +0000 (GMT)
X-AuditID: b6c32a48-d5fff70000002500-b6-615eabb8d37b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        44.B7.08750.7BBAE516; Thu,  7 Oct 2021 17:11:35 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211007081135epsmtip252cbb5496e99ef25d95867a65b577a39~rsVs1idkI0776407764epsmtip2U;
        Thu,  7 Oct 2021 08:11:35 +0000 (GMT)
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
        Jaehoon Chung <jh80.chung@samsung.com>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        Sowon Na <sowon.na@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Inki Dae <inki.dae@samsung.com>
Subject: [PATCH v4 14/16] scsi: ufs: ufs-exynos: multi-host configuration
 for exynosauto
Date:   Thu,  7 Oct 2021 17:09:32 +0900
Message-Id: <20211007080934.108804-15-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211007080934.108804-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01TbUxbVRj23FtuC1q8KyjHLnP1qiGghZZQelBwE1CvDiO6yGaTiTf0Bjro
        R/qxbGqyVkNt19GBg42VgQwQCeA6ELAwGJ/LwmbcD0bG2BImwyAs3dg6xKKiLe10/573Pc9z
        nvM+5xweLlgghDyVxsjqNUwpRURxescS5OK+9o8ZyXkBmpjvINDN+l4CLfqnCDTyi52Dji37
        cXTf3RKBJodeQof7stGlikYMfT1bwUHzbheOGqd7MTS9Zo1And4/MHSt+zwH1Vw+hyHHVQ+B
        vruwjqE//aPY9hh68soO2mUuJ+hJZzlG/9CaSDcNLGJ0V5udoCsahwG96rYR9L1fZzi0s7sN
        0L6uZ+mvhh1Y3hOKkoxillGyehGrKdQqVZqiTGrHzoLsAlmaRCqWpiM5JdIwajaTysnNE7+p
        Kg0MSIn2MaWmQCuPMRio5Ncy9FqTkRUVaw3GTIrVKUt1cl2SgVEbTJqiJA1rfEUqkaTIAsRP
        Soqnm82E7mr8fldnDWEGlc8dAjweJFOhvSPpEIjiCUgPgIvzXixU3AfwZN9lTqjwAThnqQsU
        kRuK1dnZMKsfwK7KTiK4ICDvAXh9JjuICVIMuxeWQJAUS94FcP5WFTdY4KSNA811Vm6QFUMq
        4E8/n9jAHPJFWFbetLETn9wOXTUdIGS3FY6v2fEgjgz0B/q/D3M2wYkT8xtHwgOcL3tq8aAB
        JJd5cM3/DzckzoHmlqnwuWPg0oXucF8IF49YuSGBA8CyuYeCdgDtltwQ3gbXjndHBGPCyQTo
        7k8OJfY8HJ8J+0ZD29jf3FCbD21WQUgYD4d/PB523QIdJ30RIUzDY9U3wpEeDYQ9cTSiAohc
        j4zjemQc1//GDQBvA0+zOoO6iDWk6FL/u+JCrboLbLz4RNoDar3LSaMA44FRAHk4FcvXbtvD
        CPhK5sCnrF5boDeVsoZRIAuEXYkLnyrUBr6MxlggTU2XpKalSeUpMomciuPXrWcxArKIMbIl
        LKtj9Q91GC9SaMaiZG8L3jE1ff56Sdu+A48NjsQltKbHi8WOBn0DX4sa/Jdq1IQYZWVbDp79
        pnF3Fj+/6WCrMF+1qq23lCmrttgnuqhXH+/cv3JxzGM/fX3829uV6c4VtWd62Zmm3KsG7+3d
        fMq86YbvGds5B39u/JTMu1nRXE23OfPeuFO1omCvxF4cs4B8UW3r0ocvqG96H/QNxq2ryu82
        130UTxd6ewYiHT1mZ96sx7ZrSnXGc/ZOXUL5tZy/Dn/ARL9vfcv/+7vu2Ba7+0nfOMcojzZz
        fdTu08LP5B23ds3+pnB5Xn4QtbV+pHMQv62rXtmjF+5sbxwSOzJcyUOKL8BCfG4+c4biGIoZ
        aSKuNzD/AmbCuPN6BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsWy7bCSvO721XGJBndPClmcfLKGzeLBvG1s
        Fi9/XmWzOPiwk8Vi2oefzBaf1i9jtbi8X9uiZ6ezxekJi5gsJt2fwGLxZP0sZotFN7YxWdz4
        1cZqsfHtDyaLm1uOsljMOL+PyaL7+g42i+XH/zFZ/P55iMlB2OPyFW+PWQ29bB6X+3qZPDav
        0PJYvOclk8emVZ1sHhMWHWD0+L6+g83j49NbLB59W1YxenzeJOfRfqCbKYAnissmJTUnsyy1
        SN8ugSvjxpIGtoLr6hWzNs5ga2CcqNjFyMkhIWAi8f3+faYuRi4OIYEdjBKrG7+wQyRkJZ69
        2wFlC0vcbznCClH0nlHi8fZXLCAJNgFdiS3PXzGC2CICHxkl5nzTAiliFpjCInHjaTPQWA4O
        YYEIiZP/CkBqWARUJVp7F7OB2LwCDhKzZqxhhFggL3HkVycziM0JFN+zay0bSKuQgL1E199I
        iHJBiZMzn4CtZQYqb946m3kCo8AsJKlZSFILGJlWMUqmFhTnpucWGxYY5aWW6xUn5haX5qXr
        JefnbmIEx6KW1g7GPas+6B1iZOJgPMQowcGsJMKbbx+bKMSbklhZlVqUH19UmpNafIhRmoNF
        SZz3QtfJeCGB9MSS1OzU1ILUIpgsEwenVAOT+z61xl7VIjarw7fi12Zy9sXcOXKwUkreLW9Z
        v9yj8LM1D33jZr09dVqZP8PDViPphcib4Gs3L+xJ+vVv247zevPY+NtDOoMmCWj1WahZvr1z
        2eubbplv26fLPmdWvbxZos8tGn5Y5MiWX2raacf9JTWrt7JHZPOI7G5v51ac8VBl59WvufGX
        P87ZPH3KhagVq65uW15xNCM1Z3/T46M2NV0+1Xzuz9yY1KMnpCW7Bm3cPK+X9/q8uTNfpr4+
        XfZQ425IbveWzgl75sdeK44WzRG32NW4pkLES/DehVb12rOFzxNd72/R/PLeQPT1KoOSgFU2
        BuVbO293xnls2bGn9sJW3fB/D1unKfv+EDqhxFKckWioxVxUnAgAC6Hk3TQDAAA=
X-CMS-MailID: 20211007081135epcas2p410e67850fdd25fc762b0bfa49c6e24f1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211007081135epcas2p410e67850fdd25fc762b0bfa49c6e24f1
References: <20211007080934.108804-1-chanho61.park@samsung.com>
        <CGME20211007081135epcas2p410e67850fdd25fc762b0bfa49c6e24f1@epcas2p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UFS controller of ExynosAuto v9 SoC supports multi-host interface for I/O
virtualization. In general, we're using para-virtualized driver to
support a block device by several virtual machines. However, it should
be relayed by backend driver. Multi-host functionality extends the host
controller by providing register interfaces that can be used by each
VM's ufs drivers respectively. By this, we can provide direct access to
the UFS device for multiple VMs. It's similar with SR-IOV of PCIe.

We divide this M-HCI as PH(Physical Host) and VHs(Virtual Host). The PH
supports all UFSHCI functions(all SAPs) same as conventional UFSHCI but
the VH only supports data transfer function. Thus, except UTP_CMD_SAP and
UTP_TMPSAP, the PH should handle all the physical features.

This patch provides an initial implementation of PH part. M-HCI can
support up to four interfaces but this patch initially supports only 1
PH and 1 VH. For this, we uses TASK_TAG[7:5] field so TASK_TAG[4:0] for
32 doorbel will be supported. After the PH is initiated, this will send
a ready message to VHs through a mailbox register. The message handler
is not fully implemented yet such as supporting reset / abort cases.

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 68 +++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 9d32f19395b8..32f73c906018 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -83,6 +83,44 @@
 #define UFS_SHARABLE		(UFS_WR_SHARABLE | UFS_RD_SHARABLE)
 #define UFS_SHAREABILITY_OFFSET	0x710
 
+/* Multi-host registers */
+#define MHCTRL			0xC4
+#define MHCTRL_EN_VH_MASK	(0xE)
+#define MHCTRL_EN_VH(vh)	(vh << 1)
+#define PH2VH_MBOX		0xD8
+
+#define MH_MSG_MASK		(0xFF)
+
+#define MH_MSG(id, msg)		((id << 8) | (msg & 0xFF))
+#define MH_MSG_PH_READY		0x1
+#define MH_MSG_VH_READY		0x2
+
+#define ALLOW_INQUIRY		BIT(25)
+#define ALLOW_MODE_SELECT	BIT(24)
+#define ALLOW_MODE_SENSE	BIT(23)
+#define ALLOW_PRE_FETCH		GENMASK(22, 21)
+#define ALLOW_READ_CMD_ALL	GENMASK(20, 18)	/* read_6/10/16 */
+#define ALLOW_READ_BUFFER	BIT(17)
+#define ALLOW_READ_CAPACITY	GENMASK(16, 15)
+#define ALLOW_REPORT_LUNS	BIT(14)
+#define ALLOW_REQUEST_SENSE	BIT(13)
+#define ALLOW_SYNCHRONIZE_CACHE	GENMASK(8, 7)
+#define ALLOW_TEST_UNIT_READY	BIT(6)
+#define ALLOW_UNMAP		BIT(5)
+#define ALLOW_VERIFY		BIT(4)
+#define ALLOW_WRITE_CMD_ALL	GENMASK(3, 1)	/* write_6/10/16 */
+
+#define ALLOW_TRANS_VH_DEFAULT	(ALLOW_INQUIRY | ALLOW_MODE_SELECT | \
+				 ALLOW_MODE_SENSE | ALLOW_PRE_FETCH | \
+				 ALLOW_READ_CMD_ALL | ALLOW_READ_BUFFER | \
+				 ALLOW_READ_CAPACITY | ALLOW_REPORT_LUNS | \
+				 ALLOW_REQUEST_SENSE | ALLOW_SYNCHRONIZE_CACHE | \
+				 ALLOW_TEST_UNIT_READY | ALLOW_UNMAP | \
+				 ALLOW_VERIFY | ALLOW_WRITE_CMD_ALL)
+
+#define HCI_MH_ALLOWABLE_TRAN_OF_VH		0x30C
+#define HCI_MH_IID_IN_TASK_TAG			0X308
+
 enum {
 	UNIPRO_L1_5 = 0,/* PHY Adapter */
 	UNIPRO_L2,	/* Data Link */
@@ -174,6 +212,20 @@ static int exynosauto_ufs_drv_init(struct device *dev, struct exynos_ufs *ufs)
 	return 0;
 }
 
+static int exynosauto_ufs_post_hce_enable(struct exynos_ufs *ufs)
+{
+	struct ufs_hba *hba = ufs->hba;
+
+	/* Enable Virtual Host #1 */
+	ufshcd_rmwl(hba, MHCTRL_EN_VH_MASK, MHCTRL_EN_VH(1), MHCTRL);
+	/* Default VH Transfer permissions */
+	hci_writel(ufs, ALLOW_TRANS_VH_DEFAULT, HCI_MH_ALLOWABLE_TRAN_OF_VH);
+	/* IID information is replaced in TASKTAG[7:5] instead of IID in UCD */
+	hci_writel(ufs, 0x1, HCI_MH_IID_IN_TASK_TAG);
+
+	return 0;
+}
+
 static int exynosauto_ufs_pre_link(struct exynos_ufs *ufs)
 {
 	struct ufs_hba *hba = ufs->hba;
@@ -241,6 +293,20 @@ static int exynosauto_ufs_pre_pwr_change(struct exynos_ufs *ufs,
 	return 0;
 }
 
+static int exynosauto_ufs_post_pwr_change(struct exynos_ufs *ufs,
+					  struct ufs_pa_layer_attr *pwr)
+{
+	struct ufs_hba *hba = ufs->hba;
+	u32 enabled_vh;
+
+	enabled_vh = ufshcd_readl(hba, MHCTRL) & MHCTRL_EN_VH_MASK;
+
+	/* Send physical host ready message to virtual hosts */
+	ufshcd_writel(hba, MH_MSG(enabled_vh, MH_MSG_PH_READY), PH2VH_MBOX);
+
+	return 0;
+}
+
 static int exynos7_ufs_pre_link(struct exynos_ufs *ufs)
 {
 	struct ufs_hba *hba = ufs->hba;
@@ -1413,8 +1479,10 @@ static struct exynos_ufs_drv_data exynosauto_ufs_drvs = {
 				  EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR |
 				  EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX,
 	.drv_init		= exynosauto_ufs_drv_init,
+	.post_hce_enable	= exynosauto_ufs_post_hce_enable,
 	.pre_link		= exynosauto_ufs_pre_link,
 	.pre_pwr_change		= exynosauto_ufs_pre_pwr_change,
+	.post_pwr_change	= exynosauto_ufs_post_pwr_change,
 };
 
 static struct exynos_ufs_drv_data exynos_ufs_drvs = {
-- 
2.33.0

