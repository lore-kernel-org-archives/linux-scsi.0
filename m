Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EA59C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 06:56:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48BD56112E
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 06:56:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237759AbhIQG52 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 02:57:28 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:29072 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238596AbhIQG5A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 02:57:00 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210917065530epoutp04abe3a8b644281055adaadbea2bd77b2d~liZj7RDxP2951729517epoutp047
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 06:55:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210917065530epoutp04abe3a8b644281055adaadbea2bd77b2d~liZj7RDxP2951729517epoutp047
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1631861730;
        bh=QByzE0PugbXI92yPxUd44muSYhoKsxuDFtCR2Q52eIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tazCGjU3v/71Vov9Jjo5Cu+NGJoi6kWeX8Dt+7fu2CwD7zxpnFJAUGLRHsAXwtBrK
         rTijfQD1+bBZAafW3F7FXBgF7APfOo05WTlWI2Oz+SXcFUNNemqEqXfaR572A6IpSK
         wlbzBwiT2qi9t6Ze3Yut7JWl7ITzgnNJ5xf5CYNw=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210917065529epcas2p4d4a9a48ce5b511dec89627e101289f94~liZjH_A781208812088epcas2p4m;
        Fri, 17 Sep 2021 06:55:29 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.188]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4H9l8F1HGqz4x9Qc; Fri, 17 Sep
        2021 06:55:25 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        CF.ED.09749.DDB34416; Fri, 17 Sep 2021 15:55:25 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20210917065524epcas2p3929f70cb0b62e6ca85a6f4814b61fae1~liZeTkAr80100601006epcas2p3s;
        Fri, 17 Sep 2021 06:55:24 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210917065524epsmtrp1a1fd6546680ff0f596803658911958d4~liZeSsXP31077210772epsmtrp1s;
        Fri, 17 Sep 2021 06:55:24 +0000 (GMT)
X-AuditID: b6c32a47-d29ff70000002615-b8-61443bdc4294
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        33.20.09091.BDB34416; Fri, 17 Sep 2021 15:55:23 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210917065523epsmtip25ca47777b0fc632eb5453959892ce33d~liZeFmA482199021990epsmtip2u;
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
Subject: [PATCH v3 16/17] scsi: ufs: ufs-exynos: introduce exynosauto v9
 virtual host
Date:   Fri, 17 Sep 2021 15:54:35 +0900
Message-Id: <20210917065436.145629-17-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210917065436.145629-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJJsWRmVeSWpSXmKPExsWy7bCmqe5da5dEg9lvmS1OPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZotP65exWlzer23Rs9PZ4vSERUwWT9bPYrZYdGMbk8XGtz+YLG5u
        OcpiMeP8PiaL7us72CyWH//H5CDgcfmKt8eshl42j8t9vUwem1doeSze85LJY9OqTjaPCYsO
        MHp8X9/B5vHx6S0Wj74tqxg9Pm+S82g/0M0UwBOVY5ORmpiSWqSQmpecn5KZl26r5B0c7xxv
        amZgqGtoaWGupJCXmJtqq+TiE6DrlpkD9JKSQlliTilQKCCxuFhJ386mKL+0JFUhI7+4xFYp
        tSAlp8DQsECvODG3uDQvXS85P9fK0MDAyBSoMiEn4/jWJ8wFdxQrvvf1MzcwXpTuYuTgkBAw
        kWj8EtnFyMUhJLCDUeLzm6OMEM4nRolHG6ZDOd8YJdZtu8UE07HssyxEfC+jRHfjN3YI5yOj
        xOblZ4E6ODnYBHQltjx/BdYtIvCeUeLJ4ylgVcwCs5gljn+dzARSJSwQLvGxaSoriM0ioCox
        afERVpAVvAIOEtMnyIKEJQTkJY786mQGsTmBwrd2/QdbwCsgKHFy5hMWEJsZqKZ562xmkPkS
        Anc4JE6eu80M0ewiMWdWB5QtLPHq+BZ2CFtK4mV/GztEQzejROuj/1CJ1YwSnY0+ELa9xK/p
        W8AOYhbQlFi/Sx/ifWWJI7eg9vJJdBz+yw4R5pXoaBOCaFSXOLB9OguELSvRPeczK4TtITHn
        4Ek2SGBNZpRY9XIx0wRGhVlI3pmF5J1ZCIsXMDKvYhRLLSjOTU8tNiowRo7hTYzgNK7lvoNx
        xtsPeocYmTgYDzFKcDArifBeqHFMFOJNSaysSi3Kjy8qzUktPsRoCgzricxSosn5wEySVxJv
        aGpkZmZgaWphamZkoSTOO/efU6KQQHpiSWp2ampBahFMHxMHp1QDU3KR9s57T+qdn/z7U24t
        Ihpp/q7t1TJX18qE0qd3O+9EzV0amlf0OEa6LGvx4riQSTt8vQ9/Z/xpv/sX553AP4q9lmJn
        xbgPHZu/t6NARs8q5t3piQU1jtvm/RWTEkgo4I3Sb3pWLP9Vv9NmqgrPUytD9YA4q08H9Sbq
        RjxVl/pZnSe2UevE5n3ypXxcnh/rojauS82w0YtbX10T92xufNacxiYfwfdN8/4Zv+NiYVNx
        0JqQsiL/qNDlI1vP5keLKuYV3bmybj3zycopH0xbpa1New9oPPWaFm6zXq9xZuKc/oYqPkYh
        84hpfJ3fOZa03Y1+5390i3/7wu1ncxKWOER56F7jCV5wzujraiclluKMREMt5qLiRADMhmOl
        bAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsWy7bCSvO5ta5dEg6d3bCxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZotP65exWlzer23Rs9PZ4vSERUwWT9bPYrZYdGMbk8XGtz+YLG5u
        OcpiMeP8PiaL7us72CyWH//H5CDgcfmKt8eshl42j8t9vUwem1doeSze85LJY9OqTjaPCYsO
        MHp8X9/B5vHx6S0Wj74tqxg9Pm+S82g/0M0UwBPFZZOSmpNZllqkb5fAlXF86xPmgjuKFd/7
        +pkbGC9KdzFycEgImEgs+yzbxcjFISSwm1Hi4LnHLF2MnEBxWYln73awQ9jCEvdbjrBCFL1n
        lFjRexisiE1AV2LL81eMILaIwEdGiTnftECKmAWWMEs0HpjHBJIQFgiVWHFxOTOIzSKgKjFp
        McgkDg5eAQeJ6RNkIRbISxz51QlWwgkUvrXrP9hMIQF7iYmTF4HZvAKCEidnPgHbywxU37x1
        NvMERoFZSFKzkKQWMDKtYpRMLSjOTc8tNiwwzEst1ytOzC0uzUvXS87P3cQIjjYtzR2M21d9
        0DvEyMTBeIhRgoNZSYT3Qo1johBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeC10n44UE0hNLUrNT
        UwtSi2CyTBycUg1MV5yeRKvI/5M7XbBRYR9jpNb3KtNjxa8OXxUS0pzOFdYp9ntz+BWrECbH
        Y+ZTZnaL5abs+GTwpPgJS6HHvt2m+zYf752d6vcwvO3ixLZfUZN2f1GSWbvGf8mbg4taX5ql
        qP35vPZdfIQ++6RfSxbc6NS/+uFIzjl1u7qaFeGeBWemXJ4w37ZpbpzAHre21daflAM4Qy/L
        Hohl48vvtpi+sk8vx7Kxti/hoq7/GR3V6ytmd5/fU8//bpFzfGHk0avSchcWJ/66uNCvN/z8
        jiihwLIr3k+2vTZbFHbeN0L7/Xa+pgsfvytuyOi6/VZt6Z8eVjGzbkW5bJEtSnaGd6Z0VtcU
        LjooX/fwwX7hPfuXKbEUZyQaajEXFScCAPouFuwlAwAA
X-CMS-MailID: 20210917065524epcas2p3929f70cb0b62e6ca85a6f4814b61fae1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210917065524epcas2p3929f70cb0b62e6ca85a6f4814b61fae1
References: <20210917065436.145629-1-chanho61.park@samsung.com>
        <CGME20210917065524epcas2p3929f70cb0b62e6ca85a6f4814b61fae1@epcas2p3.samsung.com>
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
 drivers/scsi/ufs/ufs-exynos.c | 84 +++++++++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 0ca21cd8e76e..2e71138ce566 100644
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
+				  UFSHCD_QUIRK_SKIP_PH_CONFIGURATION |
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
2.33.0

