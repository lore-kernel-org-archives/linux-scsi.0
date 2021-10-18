Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5FE1C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 12:45:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFCFA6103C
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 12:45:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbhJRMrm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 08:47:42 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:52910 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbhJRMr3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Oct 2021 08:47:29 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20211018124517epoutp02ca9c4486ee6f8b773ceb63a74ebc8876~vIK0cTnDI0581605816epoutp02H
        for <linux-scsi@vger.kernel.org>; Mon, 18 Oct 2021 12:45:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20211018124517epoutp02ca9c4486ee6f8b773ceb63a74ebc8876~vIK0cTnDI0581605816epoutp02H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1634561117;
        bh=Va88gHeYV3KQzJEktgmbE3hAuFG89pk7H6aa7EFFzq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UmA+Yn9HEr772NKd71fncphtxHxYkh6ZEufAH0wdDCmQFVeXCqLCaV7xQjwDRgVVy
         kYES4Gga+J35HbhznUOqHmpv8PFzBK6OvaNT4RkMWcO1YHIpX06+ZYAM4U5SYe7rmH
         etMwbFGDK6KrqPzcSaZOR9jNCmNe9JWlpeP23YRg=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20211018124516epcas2p2062992f4a54520f6e79d06fd3d0566c8~vIKzvjaGe0992709927epcas2p2g;
        Mon, 18 Oct 2021 12:45:16 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.89]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4HXxRS0sxwz4x9Pv; Mon, 18 Oct
        2021 12:45:08 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        EB.D9.09823.35C6D616; Mon, 18 Oct 2021 21:45:08 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20211018124506epcas2p3a014f68fb3d6cdfa43a3562c74bb6895~vIKp_rXB00244402444epcas2p3L;
        Mon, 18 Oct 2021 12:45:06 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211018124506epsmtrp1eccc72c92067eb2841d60ac2cb53950d~vIKp9yTLO1580315803epsmtrp1R;
        Mon, 18 Oct 2021 12:45:06 +0000 (GMT)
X-AuditID: b6c32a48-13dff7000000265f-1b-616d6c5334f9
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        59.50.08902.25C6D616; Mon, 18 Oct 2021 21:45:06 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211018124506epsmtip2fce23f590ebe4ec5df37b5c6064c67da~vIKpyLswQ0235802358epsmtip2u;
        Mon, 18 Oct 2021 12:45:06 +0000 (GMT)
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
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v5 14/15] scsi: ufs: ufs-exynos: introduce exynosauto v9
 virtual host
Date:   Mon, 18 Oct 2021 21:42:15 +0900
Message-Id: <20211018124216.153072-15-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211018124216.153072-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJsWRmVeSWpSXmKPExsWy7bCmuW5ITm6iwa7lTBYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLS7v17bo2elscXrCIiaLJ+tnMVssurGNyeLGrzZWi41v
        fzBZ3NxylMVixvl9TBbd13ewWSw//o/J4vfPQ0wOQh6Xr3h7zGroZfO43NfL5LF5hZbH4j0v
        mTw2repk85iw6ACjx/f1HWweH5/eYvHo27KK0ePzJjmP9gPdTAE8Udk2GamJKalFCql5yfkp
        mXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUDPKSmUJeaUAoUCEouLlfTtbIry
        S0tSFTLyi0tslVILUnIKzAv0ihNzi0vz0vXyUkusDA0MjEyBChOyMz69+MlecECpYtLHX4wN
        jLNluhg5OSQETCTWHv7IDmILCexglFg9T6SLkQvI/sQosXDTUWaIxDdGiTPr2WEa3v98zApR
        tJdR4t/SW+wQzkdGiX33Z7CAVLEJ6Epsef6KESQhIvCeUeLJ4ylgVcwCT5kl5v3oZQOpEhYI
        l1h47DuYzSKgKvHi2zqwfbwCDhK9L2ZC7ZOXOPKrEyzOCRTvWXSECaJGUOLkzCdg25iBapq3
        zmYGWSAh8IRD4u+liYwQzS4Sjzq2s0DYwhKvjm+BGiol8bK/jR2ioZtRovXRf6jEakaJzkYf
        CNte4tf0LUCfcgBt0JRYv0sfxJQQUJY4cgtqL59Ex+G/7BBhXomONiGIRnWJA9unQ22Vleie
        85kVwvaQONI4CRpakxklNt0/zjiBUWEWkndmIXlnFsLiBYzMqxjFUguKc9NTi40KTOBRnJyf
        u4kRnNq1PHYwzn77Qe8QIxMH4yFGCQ5mJRHeJNfcRCHelMTKqtSi/Pii0pzU4kOMpsDAnsgs
        JZqcD8wueSXxhiaWBiZmZobmRqYG5krivJai2YlCAumJJanZqakFqUUwfUwcnFINTFNc1/Zv
        mpr4p+mBONusNEGJgq9FQhesBfnm7C3ju/nYKlM7JdvBuiV8zY99D+Ycz2h84ZQb0JllNG/B
        xXqu3Uv9c68xcLVbWPsHJ86YGtP86k99zMHj8dqPdq/8kHWXr2n56nd+az88K/zfsqfeQZGv
        ataJ/Q+Di/xf7l9Sa239TlLwVyPP1FsLO/WYJ29YofVtP7O/+lVDN5P9wcasl17O/cXUxC34
        Mthvcc52ra6YlOtN+50X63/oMHq+abeZk07j63u/A/0vzNYpcU/y12vV1NUPmrmE5R5H0Dyb
        bHm31x7V80PCar2kPrWahwdddrj8259L+PLlWa2yM5/6JdxZdD9o2Zv1RulpcxcGK7EUZyQa
        ajEXFScCAMIZ3N12BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHIsWRmVeSWpSXmKPExsWy7bCSvG5QTm6iwckXwhYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLS7v17bo2elscXrCIiaLJ+tnMVssurGNyeLGrzZWi41v
        fzBZ3NxylMVixvl9TBbd13ewWSw//o/J4vfPQ0wOQh6Xr3h7zGroZfO43NfL5LF5hZbH4j0v
        mTw2repk85iw6ACjx/f1HWweH5/eYvHo27KK0ePzJjmP9gPdTAE8UVw2Kak5mWWpRfp2CVwZ
        n178ZC84oFQx6eMvxgbG2TJdjJwcEgImEu9/PmbtYuTiEBLYzSgxt2MuK0RCVuLZux3sELaw
        xP2WI1BF7xklTl49wQSSYBPQldjy/BUjiC0i8JFRYs43LZAiZoGPzBJ3Vi5hAUkIC4RKrJz7
        BsxmEVCVePFtHTOIzSvgINH7YibUBnmJI786weKcQPGeRUfAFggJ2Essfjkbql5Q4uTMJ2Bz
        mIHqm7fOZp7AKDALSWoWktQCRqZVjJKpBcW56bnFhgWGeanlesWJucWleel6yfm5mxjBUail
        uYNx+6oPeocYmTgYDzFKcDArifAmueYmCvGmJFZWpRblxxeV5qQWH2KU5mBREue90HUyXkgg
        PbEkNTs1tSC1CCbLxMEp1cC045n/TKU7GwWm+rQfkhI/E3Xdok3N7n2L5PaiV4/91nnWa9m8
        qJWM5FfxLvw4qVpg9d3pzs92MD7OWeq0SKipYbKi2Qzdyy6+mqdSO4p1+gRZ1LUZOD0FrbO2
        t8Ya/bPUbp57POI2l4b6bCf2latn5LSHyu1Nm7xC213lk2BdzIQVnFPmBKTLfbLaWTnjsalm
        lcaBg9NXzP3AvLxK0zrs4qfGkjT9ObOWSxqUMSy8O0OrfMe3L4eUlx95zzJDqdUr9/qCzn/b
        GF4tnLxG7eqqpw5rfeIrRH5/rA4p/mVUVfGE/3K9Yv2BXe3Vih8fex/UuRCVNmW6OPeHorQM
        Cy7hbdeOMZxd3H1M4vX7QCElluKMREMt5qLiRAAG9nEbMQMAAA==
X-CMS-MailID: 20211018124506epcas2p3a014f68fb3d6cdfa43a3562c74bb6895
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211018124506epcas2p3a014f68fb3d6cdfa43a3562c74bb6895
References: <20211018124216.153072-1-chanho61.park@samsung.com>
        <CGME20211018124506epcas2p3a014f68fb3d6cdfa43a3562c74bb6895@epcas2p3.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch introduces virtual host driver of exynosauto v9 ufs mHCI.
VH(Virtual Host) only supports data transfer functions. So, most of
physical features are broken. So, we need to set below quirks.
- UFSHCD_QUIRK_BROKEN_UIC_CMD
- UFSHCD_QUIRK_SKIP_PH_CONFIGURATION
Before initialization, the VH is necessary to wait until PH is ready.
It's implemented as polling at the moment.

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 86 +++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 6e6149d99609..cd26bc82462e 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -121,6 +121,8 @@
 #define HCI_MH_ALLOWABLE_TRAN_OF_VH		0x30C
 #define HCI_MH_IID_IN_TASK_TAG			0X308
 
+#define PH_READY_TIMEOUT_MS			(5 * MSEC_PER_SEC)
+
 enum {
 	UNIPRO_L1_5 = 0,/* PHY Adapter */
 	UNIPRO_L2,	/* Data Link */
@@ -1406,6 +1408,70 @@ static int exynos_ufs_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	return 0;
 }
 
+static int exynosauto_ufs_vh_link_startup_notify(struct ufs_hba *hba,
+						 enum ufs_notify_change_status status)
+{
+	if (status == POST_CHANGE) {
+		ufshcd_set_link_active(hba);
+		ufshcd_set_ufs_dev_active(hba);
+	}
+
+	return 0;
+}
+
+static int exynosauto_ufs_vh_wait_ph_ready(struct ufs_hba *hba)
+{
+	u32 mbox;
+	ktime_t start, stop;
+
+	start = ktime_get();
+	stop = ktime_add(start, ms_to_ktime(PH_READY_TIMEOUT_MS));
+
+	do {
+		mbox = ufshcd_readl(hba, PH2VH_MBOX);
+		/* TODO: Mailbox message protocols between the PH and VHs are
+		 * not implemented yet. This will be supported later
+		 */
+		if ((mbox & MH_MSG_MASK) == MH_MSG_PH_READY)
+			return 0;
+
+		usleep_range(40, 50);
+	} while (ktime_before(ktime_get(), stop));
+
+	return -ETIME;
+}
+
+static int exynosauto_ufs_vh_init(struct ufs_hba *hba)
+{
+	struct device *dev = hba->dev;
+	struct platform_device *pdev = to_platform_device(dev);
+	struct exynos_ufs *ufs;
+	int ret;
+
+	ufs = devm_kzalloc(dev, sizeof(*ufs), GFP_KERNEL);
+	if (!ufs)
+		return -ENOMEM;
+
+	/* exynos-specific hci */
+	ufs->reg_hci = devm_platform_ioremap_resource_byname(pdev, "vs_hci");
+	if (IS_ERR(ufs->reg_hci)) {
+		dev_err(dev, "cannot ioremap for hci vendor register\n");
+		return PTR_ERR(ufs->reg_hci);
+	}
+
+	ret = exynosauto_ufs_vh_wait_ph_ready(hba);
+	if (ret)
+		return ret;
+
+	ufs->drv_data = device_get_match_data(dev);
+	if (!ufs->drv_data)
+		return -ENODEV;
+
+	exynos_ufs_priv_init(hba, ufs);
+
+	return 0;
+}
+
 static struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.name				= "exynos_ufs",
 	.init				= exynos_ufs_init,
@@ -1420,6 +1486,12 @@ static struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.resume				= exynos_ufs_resume,
 };
 
+static struct ufs_hba_variant_ops ufs_hba_exynosauto_vh_ops = {
+	.name				= "exynosauto_ufs_vh",
+	.init				= exynosauto_ufs_vh_init,
+	.link_startup_notify		= exynosauto_ufs_vh_link_startup_notify,
+};
+
 static int exynos_ufs_probe(struct platform_device *pdev)
 {
 	int err;
@@ -1488,6 +1560,18 @@ static struct exynos_ufs_drv_data exynosauto_ufs_drvs = {
 	.post_pwr_change	= exynosauto_ufs_post_pwr_change,
 };
 
+static struct exynos_ufs_drv_data exynosauto_ufs_vh_drvs = {
+	.vops			= &ufs_hba_exynosauto_vh_ops,
+	.quirks			= UFSHCD_QUIRK_PRDT_BYTE_GRAN |
+				  UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR |
+				  UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR |
+				  UFSHCI_QUIRK_BROKEN_HCE |
+				  UFSHCD_QUIRK_BROKEN_UIC_CMD |
+				  UFSHCD_QUIRK_SKIP_PH_CONFIGURATION |
+				  UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING,
+	.opts			= EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX,
+};
+
 static struct exynos_ufs_drv_data exynos_ufs_drvs = {
 	.uic_attr		= &exynos7_uic_attr,
 	.quirks			= UFSHCD_QUIRK_PRDT_BYTE_GRAN |
@@ -1515,6 +1599,8 @@ static const struct of_device_id exynos_ufs_of_match[] = {
 	  .data	      = &exynos_ufs_drvs },
 	{ .compatible = "samsung,exynosautov9-ufs",
 	  .data	      = &exynosauto_ufs_drvs },
+	{ .compatible = "samsung,exynosautov9-ufs-vh",
+	  .data	      = &exynosauto_ufs_vh_drvs },
 	{},
 };
 
-- 
2.33.0

