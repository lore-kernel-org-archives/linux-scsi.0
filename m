Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30A57C11F67
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 06:58:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19FF761353
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 06:58:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbhGIHAr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 03:00:47 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:19289 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbhGIHAh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 03:00:37 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210709065752epoutp014c16ec2d0fa57185ce3dc25672f0d8a6~QDRp8T8z32701027010epoutp01c
        for <linux-scsi@vger.kernel.org>; Fri,  9 Jul 2021 06:57:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210709065752epoutp014c16ec2d0fa57185ce3dc25672f0d8a6~QDRp8T8z32701027010epoutp01c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1625813872;
        bh=7MyMmz3j+3GW1QjdhMcRamX4pXSm4lwm4ob35PeaKKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=soG7b1WJdIzIjnw97tS/dc1w7gY4wPu79/blrN9/qQepaQD5SA08I1swXSzp03Tvk
         BPQbCBrBYkBI9gUR9J5pKDsoo3jlFhU8X5MokovIfvR39+rTgo9oyioo5NeCyXdp03
         TKfS7KM21YrvbAU2/eSpzemHx1FdM4Nr1Q2KaxXs=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210709065751epcas2p48818e4e0aaa95c2327a3d2f712774533~QDRpDZyTq0617006170epcas2p44;
        Fri,  9 Jul 2021 06:57:51 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.181]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4GLkWK0GDtz4x9Q1; Fri,  9 Jul
        2021 06:57:49 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        50.B3.09921.C63F7E06; Fri,  9 Jul 2021 15:57:48 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20210709065747epcas2p37d1d2fc1ce5b582b71fa5187099d1801~QDRk3nT-c2002320023epcas2p37;
        Fri,  9 Jul 2021 06:57:47 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210709065747epsmtrp2c49df8b4c52a1fa9a50606dc9e8430b3~QDRk2us5x0268602686epsmtrp2-;
        Fri,  9 Jul 2021 06:57:47 +0000 (GMT)
X-AuditID: b6c32a45-fb3ff700000026c1-96-60e7f36cab19
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        13.C7.08289.B63F7E06; Fri,  9 Jul 2021 15:57:47 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210709065747epsmtip247add9b1e6869c861a6a02bef658ecc1~QDRkoLcul3077030770epsmtip2R;
        Fri,  9 Jul 2021 06:57:47 +0000 (GMT)
From:   Chanho Park <chanho61.park@samsung.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Can Guo <cang@codeaurora.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Bart Van Assche <bvanassche@acm.org>,
        jongmin jeong <jjmin.jeong@samsung.com>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH 15/15] scsi: ufs: ufs-exynos: introduce exynosauto v9
 virtual host
Date:   Fri,  9 Jul 2021 15:57:11 +0900
Message-Id: <20210709065711.25195-16-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709065711.25195-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJJsWRmVeSWpSXmKPExsWy7bCmhW7O5+cJBtMnsVucfLKGzeLBvG1s
        Fi9/XmWzmPbhJ7PFp/XLWC0u79e26NnpbHF6wiImiyfrZzFbLLqxjcli5TULi5tbjrJYzDi/
        j8mi+/oONovlx/8xOfB7XL7i7XG5r5fJY/MKLY/Fe14yeWxa1cnmMWHRAUaPj09vsXj0bVnF
        6PF5k5xH+4FupgCuqBybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFsl
        F58AXbfMHKAXlBTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2SqkFKTkFhoYFesWJucWleel6
        yfm5VoYGBkamQJUJORkTT/9kLbipUHH39CaWBsa7Ul2MHBwSAiYSm15pdDFycQgJ7GCUmLvg
        LwuE84lR4ufak8wQzmdGiR19P9m6GDnBOub/XMoEkdjFKLF5xm2oqo+MEife7mMHqWIT0JXY
        8vwVI0hCRKCfUWL5/rlgg5kFTjJLnF5wEKxKWCBEYvqXZ8wgNouAqsTF/ilgNq+AvcSTiyAN
        IPvkJU4tO8gEYnMCxef9mMAEUSMocXLmE7AaZqCa5q2zwc6QEDjCIfF070sWiPdcJM7tSoeY
        Iyzx6vgWdghbSuLzu71sEPXdjBKtj/5DJVYzSnQ2+kDY9hK/pm9hBZnDLKApsX6XPsRIZYkj
        t6DW8kl0HP7LDhHmlehoE4JoVJc4sH061PWyEt1zPrNC2B4Sxw5PBVskJDAJGNhTKyYwKsxC
        8swsJM/MQti7gJF5FaNYakFxbnpqsVGBIXIMb2IEp2kt1x2Mk99+0DvEyMTBeIhRgoNZSYTX
        aMazBCHelMTKqtSi/Pii0pzU4kOMpsCgnsgsJZqcD8wUeSXxhqZGZmYGlqYWpmZGFkrivBzs
        hxKEBNITS1KzU1MLUotg+pg4OKUamNaf7eMoKGd4c0Q1rn/v/uth10zmxPzh3jv1QfMCywke
        bHsY5z7T2qyionqI/XPLvYCVNY8aVj+tmBKhH5Y066SzmFqa6ZqiSzGJdyasWZ37rO6ozpbG
        4E9+r9pMk1XOLvuzK3/eI84P8vy+eQ3aSyWmzE/2bS0OfWm05fB/36I1aarNqQ88NJIV+Tas
        TY/5ZTn7yMeeg1Xiss4zDgdMzeUXKlr8OUvhdFL6JWulop3rN2d8fRVacfRCHtfskHoeGeuP
        Gx8meGwpu1fWwBJQt11Wi0nhr9+WyIgpr3SblY+1/PllLTn3a+DuU/nXHv2ccd+YYdv/k9aM
        Vkomq4P/PmFMnVZluzY+o+9MoEJIkxJLcUaioRZzUXEiAFU+yHZcBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42LZdlhJXjf78/MEgyO3hSxOPlnDZvFg3jY2
        i5c/r7JZTPvwk9ni0/plrBaX92tb9Ox0tjg9YRGTxZP1s5gtFt3YxmSx8pqFxc0tR1ksZpzf
        x2TRfX0Hm8Xy4/+YHPg9Ll/x9rjc18vksXmFlsfiPS+ZPDat6mTzmLDoAKPHx6e3WDz6tqxi
        9Pi8Sc6j/UA3UwBXFJdNSmpOZllqkb5dAlfGxNM/WQtuKlTcPb2JpYHxrlQXIyeHhICJxPyf
        S5m6GLk4hAR2MErs3XmIHSIhK/Hs3Q4oW1jifssRVoii94wSbz9tYQJJsAnoSmx5/ooRxBYR
        mMgoseSeGEgRs8BlZolv064wgySEBYIk7i16BlbEIqAqcbF/ClicV8Be4snFuSwQG+QlTi07
        CDaUEyg+78cEMFtIwE7i3oZ97BD1ghInZz4Bq2cGqm/eOpt5AqPALCSpWUhSCxiZVjFKphYU
        56bnFhsWGOWllusVJ+YWl+al6yXn525iBEeUltYOxj2rPugdYmTiYDzEKMHBrCTCazTjWYIQ
        b0piZVVqUX58UWlOavEhRmkOFiVx3gtdJ+OFBNITS1KzU1MLUotgskwcnFINTPt2pX0o/DzD
        6IeZ14RXrI+4+Y9slTlbI/Cnbu60ZatOy++urZazOZbUMrGxZKrapJ7szx6lWn5hWh/SvtzY
        8pH76wWZ1ZeZY3f9d91buWPWhg8ZSmvWv/xWvqFvdvULpuW/vxT3SSXZrl8XJnd5TRBT3Hqd
        +QsdyxJ4bp02+KDiu/P4krdHPhypunNt74o5vx87Plt3tl8yc4X4vWtiz7bqHFjyPX7B6apv
        963jA2adlz9uXpK8VfuVVcY/s8AVgjecHtytVz+Uqz+t5oaVe8mi18b72pTZHrh6V2+XP2wv
        9NjK+r/c6oorLRIi538dmLQ2h2/tmyNVf1y6k3u9im7wuunrBF4y9F952vmHa8c1JZbijERD
        Leai4kQAlr08LBcDAAA=
X-CMS-MailID: 20210709065747epcas2p37d1d2fc1ce5b582b71fa5187099d1801
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210709065747epcas2p37d1d2fc1ce5b582b71fa5187099d1801
References: <20210709065711.25195-1-chanho61.park@samsung.com>
        <CGME20210709065747epcas2p37d1d2fc1ce5b582b71fa5187099d1801@epcas2p3.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch introduces virtual host driver of exynosauto v9 ufs mHCI.
VH(Virtual Host) only supports data transfer functions. So, most of
physical features are broken. So, we need to set below quirks.
- UFSHCD_QUIRK_BROKEN_UIC_CMD
- UFSHCD_QUIRK_SKIP_INTERFACE_CONFIGURATION
Before initialization, the VH is necessary to wait until PH is ready.
It's implemented as polling at the moment.

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 84 +++++++++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 30c12e97c665..e0292711d2da 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -98,6 +98,8 @@
 #define HCI_MH_ALLOWABLE_TRAN_OF_VH		0x30C
 #define HCI_MH_IID_IN_TASK_TAG			0X308
 
+#define PH_READY_TIMEOUT_MS			(5 * MSEC_PER_SEC)
+
 enum {
 	UNIPRO_L1_5 = 0,/* PHY Adapter */
 	UNIPRO_L2,	/* Data Link */
@@ -1362,6 +1364,68 @@ static int exynos_ufs_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	return 0;
 }
 
+static int exynosauto_ufs_vh_link_startup_notify(struct ufs_hba *hba,
+						 enum ufs_notify_change_status status)
+{
+	if (status == POST_CHANGE) {
+		ufshcd_set_link_active(hba);
+		ufshcd_set_ufs_dev_active(hba);
+		hba->wlun_dev_clr_ua = true;
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
@@ -1376,6 +1440,12 @@ static struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
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
@@ -1444,6 +1514,18 @@ static struct exynos_ufs_drv_data exynosauto_ufs_drvs = {
 	.post_pwr_change	= exynosauto_ufs_post_pwr_change,
 };
 
+static struct exynos_ufs_drv_data exynosauto_ufs_vh_drvs = {
+	.vops			= &ufs_hba_exynosauto_vh_ops,
+	.quirks			= UFSHCD_QUIRK_PRDT_BYTE_GRAN |
+				  UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR |
+				  UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR |
+				  UFSHCI_QUIRK_BROKEN_HCE |
+				  UFSHCD_QUIRK_BROKEN_UIC_CMD |
+				  UFSHCD_QUIRK_SKIP_INTERFACE_CONFIGURATION |
+				  UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING,
+	.opts			= EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX,
+};
+
 static struct exynos_ufs_drv_data exynos_ufs_drvs = {
 	.uic_attr		= &exynos7_uic_attr,
 	.quirks			= UFSHCD_QUIRK_PRDT_BYTE_GRAN |
@@ -1471,6 +1553,8 @@ static const struct of_device_id exynos_ufs_of_match[] = {
 	  .data	      = &exynos_ufs_drvs },
 	{ .compatible = "samsung,exynosautov9-ufs",
 	  .data	      = &exynosauto_ufs_drvs },
+	{ .compatible = "samsung,exynosautov9-ufs-vh",
+	  .data	      = &exynosauto_ufs_vh_drvs },
 	{},
 };
 
-- 
2.32.0

