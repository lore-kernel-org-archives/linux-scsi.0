Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5464DC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 08:12:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 381796101B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 08:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240687AbhJGIOX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 04:14:23 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:44224 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240681AbhJGIOG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 04:14:06 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20211007081212epoutp02fbd16c0afcf8f76305926d3c2a2b692f~rsWPO6PDI0453504535epoutp029
        for <linux-scsi@vger.kernel.org>; Thu,  7 Oct 2021 08:12:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20211007081212epoutp02fbd16c0afcf8f76305926d3c2a2b692f~rsWPO6PDI0453504535epoutp029
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1633594332;
        bh=dJMndszYd3O+KUdzXACVnu14r4a+S9UetNP1Oa/HmVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yf/cUqmTZMeRRs8VJIa4qIWS+Uvwz3ytx+Qty0QIha/3AkMxTSWf32wemybqIrr0f
         TM3zerJroOfifKyiQ2ikk6n2QrdLh0illIf1BAC+qwOAR+YBDzIMQlqZKipGa+8bV8
         kcL+eTuI1hw2xXIRdfZtuq6PCoDShqdu6SjysDKo=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20211007081154epcas2p236c718d975f21edfe94cd2f02f7297b3~rsV_li5u80847008470epcas2p2d;
        Thu,  7 Oct 2021 08:11:54 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.89]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4HQ3v43lv9z4x9Py; Thu,  7 Oct
        2021 08:11:44 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        25.08.09472.FBBAE516; Thu,  7 Oct 2021 17:11:43 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20211007081135epcas2p372f122a0f601f0108bdd593ca0105f3c~rsVtPDBbc1913819138epcas2p3k;
        Thu,  7 Oct 2021 08:11:35 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20211007081135epsmtrp2034b7b90a1ef89dd41163fe5b85eb782~rsVtOS4Gk2686626866epsmtrp2B;
        Thu,  7 Oct 2021 08:11:35 +0000 (GMT)
X-AuditID: b6c32a48-d75ff70000002500-cf-615eabbfa666
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        85.B7.08750.7BBAE516; Thu,  7 Oct 2021 17:11:35 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211007081135epsmtip2d62bce60f62ec5f6bca0ca6bea460d16~rsVs-tHkf0566205662epsmtip2A;
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
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v4 15/16] scsi: ufs: ufs-exynos: introduce exynosauto v9
 virtual host
Date:   Thu,  7 Oct 2021 17:09:33 +0900
Message-Id: <20211007080934.108804-16-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211007080934.108804-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Tf1CTZRz3ed/x8mLOezcgn8ZV4yVTKGCjwV5JxIS69067KK5Iu6I39saQ
        8W5tgyAvj+KUAeKhkNgQpMkp8aPBmoCkCYPiwMpydqCnpDYVvEORH8FAoY0Xy/++n8/z+Tyf
        7/f5gaNiFybBMzgjq+cYDYmtFLT1hMaEn238gJFdtUVQ/a4mjLpW04ZRo+4/Mar7epGAOjTu
        RqkJ63Efynn2BWrfqQTqXJkFoVxWM0pZhtoQamhurw/VOjaLUJfsPwmow+d/RKiSwQ6MOtG3
        gFDzbgeyWUw7L26lzfmlGO3cX4rQ39eH0cdOjyK0raEIo8ssXYCesZow+v7NywJ6v70B0JO2
        Z+jCrhIkadWOzI1qllGxeinLpWlVGVx6HLk1OTUhNTpGJg+Xb6CUpJRjstg4MnFbUvhrGRrP
        cKQ0h9Fke6gkxmAgIzdt1GuzjaxUrTUY40hWp9LolLoIA5NlyObSIzjWGCuXyaKiPcIPM9W/
        FVpR3XBw7uKXt9F84AwqBn44JBSw2XLepxisxMVEB4BlFwoRHkwAuDj0B+DBJIBN8xb0kaWo
        vX9Z1Qlgd5MF48F9AKcvnUS8KowIh/bbd5bsAcQ9AF1/V/h6AUrcRGHNbCnmVfkTKbBtn9Oj
        wnEBsRZ2Vyi8tJDYDMd66gV83LOwd65oKdrPw5/ubMZ4jQj2f+1a0qAeTcHJKtS7PyRGcOg+
        fBTw5kR4/edxH772h3f67L58LYGTd89gvKEEwD03FpcXGgEs+mIbX8fDuUq7j7c5lAiF1s5I
        bwmJENh7eTl3NTT1PPTlaSE07RXzxnWwq71yuf2nYcmRyeUOaNi6MCbgD6scwIKyH7AyIDU/
        No75sXHM/wfXArQBPMnqDFnprCFKp/jvjtO0WTaw9NzD6A5QNTYe4QAIDhwA4igZINTGv8+I
        hSom7zNWr03VZ2tYgwNEe876ACoJTNN6/gtnTJUrNsgUMTFyZVS0TEmuEVYvbGHERDpjZDNZ
        VsfqH/kQ3E+Sj6iDH+w6gdkCys8N5H9TZ/q08XUybfca96s5eaH9/aJNTx0dLhR9khfpdIgI
        y62Lq07d2zEz39IasqJi+q/nR3PWlXx1pfrggwZX+suzIs6cW1OeO2V6pf5YznuxTPzq5L7s
        qZH1Ix0pu75TTr3j++3He5pmg0YSKpOlLbcqVMUXrjQ+4d5ZbA7FufVb/vno95jtN557U1Ld
        MRM4nVVuaclrKgiKrT1uu7p9QP62Y2DRLpqYf2hS5gT6J/7yolslGcIi11Z+3j69O0VSlZex
        Qlz3a9/d5oNjoe6F3mQbeEujdg5Ovzt/SPhSiMKqmNzJvTHcdaY3uDY8Smt2Me4jg8prdSPs
        AVJgUDPyMFRvYP4FZDbKdncEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsWy7bCSvO721XGJBjOapCxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZotP65exWlzer23Rs9PZ4vSERUwWT9bPYrZYdGMbk8WNX22sFhvf
        /mCyuLnlKIvFjPP7mCy6r+9gs1h+/B+Txe+fh5gchDwuX/H2mNXQy+Zxua+XyWPzCi2PxXte
        MnlsWtXJ5jFh0QFGj+/rO9g8Pj69xeLRt2UVo8fnTXIe7Qe6mQJ4orhsUlJzMstSi/TtErgy
        zrWvZy64p1jxv+k5cwPjZekuRk4OCQETic7tJ5lAbCGBHYwSa9uUIeKyEs/e7WCHsIUl7rcc
        Ye1i5AKqec8ocWv/LGaQBJuArsSW568YQWwRgY+MEnO+aYEUMQt8ZJa4s3IJSxcjB4ewQKjE
        gYsWICaLgKrEwSkmIOW8Ag4Sbw+vYIGYLy9x5Fcn2EhOoPieXWvZQMqFBOwluv5GQpQLSpyc
        +QSsnBmovHnrbOYJjAKzkKRmIUktYGRaxSiZWlCcm55bbFhglJdarlecmFtcmpeul5yfu4kR
        HH1aWjsY96z6oHeIkYmD8RCjBAezkghvvn1sohBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeC10n
        44UE0hNLUrNTUwtSi2CyTBycUg1MCq3xUvf5LnKtbmaY+TJ16+u43U4f7xeLvU3ZO6mwKHNn
        2CN9A8UjvWG7Xji+yWq4p2aWVrFP5ol83HeD7AOiYcs6JXZ+UpNUVa5+ciXow7RdX41/G35l
        4zzItvLbfOG3ai+SFnYvYY68KqNwk+lDiY2XfeRTvVPdk22emkhzixeWTt55O2GJE//K3BUt
        V/2O3ChiOCb/Nohly7abBnP5V9yKsOVKCd0jPrX661MHCaVZuuteWaQ+CND/IhP01ep6dAHj
        vh17p+Q2uiovZ/oUVh+YVe4qq27DOSlg1hsF9pLKez9sOmoU9z89mb7g6R6rcyrLNseXXEie
        ILdi2o67mbm7Gp/l6M39dn1pSbupEktxRqKhFnNRcSIAq59Udi0DAAA=
X-CMS-MailID: 20211007081135epcas2p372f122a0f601f0108bdd593ca0105f3c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211007081135epcas2p372f122a0f601f0108bdd593ca0105f3c
References: <20211007080934.108804-1-chanho61.park@samsung.com>
        <CGME20211007081135epcas2p372f122a0f601f0108bdd593ca0105f3c@epcas2p3.samsung.com>
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
index 32f73c906018..c2b654027b0f 100644
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
@@ -1403,6 +1405,68 @@ static int exynos_ufs_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
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
@@ -1417,6 +1481,12 @@ static struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
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
@@ -1485,6 +1555,18 @@ static struct exynos_ufs_drv_data exynosauto_ufs_drvs = {
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
@@ -1512,6 +1594,8 @@ static const struct of_device_id exynos_ufs_of_match[] = {
 	  .data	      = &exynos_ufs_drvs },
 	{ .compatible = "samsung,exynosautov9-ufs",
 	  .data	      = &exynosauto_ufs_drvs },
+	{ .compatible = "samsung,exynosautov9-ufs-vh",
+	  .data	      = &exynosauto_ufs_vh_drvs },
 	{},
 };
 
-- 
2.33.0

