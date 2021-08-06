Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4433DC4338F
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 06:49:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A093611C6
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 06:49:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243432AbhHFGtx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 02:49:53 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:39351 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243443AbhHFGtu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 02:49:50 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210806064932epoutp04c925ae07c6e4fe797966c1c9252fe4cc~YpOXE8Xud2302323023epoutp041
        for <linux-scsi@vger.kernel.org>; Fri,  6 Aug 2021 06:49:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210806064932epoutp04c925ae07c6e4fe797966c1c9252fe4cc~YpOXE8Xud2302323023epoutp041
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1628232572;
        bh=fti1qP8SGNzP4EIajI2EXvOvy3xeuS4CpNTRd509E0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=g/7x+OTLuskajlKd+Jo+5GS9c0o+QSbQtsRSj7AnOScmEBsgbe5VjZ2vTQmnWRyNb
         TTZjALa7NDIFTLZE2OoUTUT7/B82u+hMJRXO3PWzg5v6YXPZr3end9NswGQZNpY1RZ
         URjQijc5SEd9iJU2nWirKKSeVqKTwIsuwKIspz9U=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210806064931epcas2p26faab7e99d3a5642bec4aa1e8d1b44df~YpOWaVQkc3198631986epcas2p2v;
        Fri,  6 Aug 2021 06:49:31 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.187]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Ggx0n1Kf0z4x9QS; Fri,  6 Aug
        2021 06:49:29 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        2B.92.09541.67BDC016; Fri,  6 Aug 2021 15:49:26 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210806064925epcas2p2ba7e711758614384c17648d4924d025c~YpORI8Alc3198631986epcas2p2d;
        Fri,  6 Aug 2021 06:49:25 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210806064925epsmtrp1031d2959838d952099dc7abde66a6d63~YpORIFxG10418604186epsmtrp11;
        Fri,  6 Aug 2021 06:49:25 +0000 (GMT)
X-AuditID: b6c32a46-0abff70000002545-7e-610cdb76e927
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E1.21.32548.57BDC016; Fri,  6 Aug 2021 15:49:25 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210806064925epsmtip1b7d7f2697612b64d675b8b7760c29e9d~YpOQ0oPvl2886428864epsmtip1Y;
        Fri,  6 Aug 2021 06:49:25 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        cang@codeaurora.org, adrian.hunter@intel.com, sc.suh@samsung.com,
        hy50.seo@samsung.com, sh425.lee@samsung.com,
        bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RFC PATCH v1 2/2] scsi: ufs: ufs-exynos: implement exynos isr
Date:   Fri,  6 Aug 2021 15:34:12 +0900
Message-Id: <7d2030d91425a01f964f7a9309c1aa3a0ce6a2d6.1628231581.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1628231581.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1628231581.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBJsWRmVeSWpSXmKPExsWy7bCmqW7ZbZ5Eg661XBYnn6xhs3gwbxub
        xcufV9ksDj7sZLH4uvQZq8Wn9ctYLVYvfsBisejGNiaLm1uOslhc3jWHzaL7+g42i+XH/zFZ
        dN29wWix9N9bFgc+j8t9vUwei/e8ZPKYsOgAo8f39R1sHh+f3mLx6NuyitHj8yY5j/YD3UwB
        HFE5NhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAhysp
        lCXmlAKFAhKLi5X07WyK8ktLUhUy8otLbJVSC1JyCgwNC/SKE3OLS/PS9ZLzc60MDQyMTIEq
        E3Iy3nz8xlQwS62iZ/cFtgbG53JdjJwcEgImEk8mnGcBsYUEdjBK9E8PgLA/MUr8+aXRxcgF
        ZH9mlLi/YzMbTMOiBxfYIBK7GCWmruxihHB+MEo8fLKTCaSKTUBT4unNqWC2iMA+Jomju9JB
        bGYBdYldE06AxYUF3CU6zjSzg9gsAqoSvQengtm8AtES186dZ4XYJidx81wnM4jNKWApsehm
        OxMqmwuoZiqHRPuvXqAiDiDHRWL5QzuIXmGJV8e3sEPYUhIv+9ug7HqJfVMbWCF6exglnu77
        xwiRMJaY9aydEWQOM9AD63fpQ4xUljhyiwXifD6JjsN/2SHCvBIdbUIQjcoSvyZNhhoiKTHz
        5h2oEg+JY7e9IKEDtOjElCdsExjlZyHMX8DIuIpRLLWgODc9tdiowAg56jYxgpOoltsOxilv
        P+gdYmTiYDzEKMHBrCTCm7yYK1GINyWxsiq1KD++qDQntfgQoykwGCcyS4km5wPTeF5JvKGp
        kZmZgaWphamZkYWSOK9G3NcEIYH0xJLU7NTUgtQimD4mDk6pBqbLmvfWJz+tL256pf+nyKTB
        eM8hqS0zqq+emuX4bZpAwhX9iZw3a8/NuB33LHzywsqGpO3qu/+f5Q8+uf9Nod/j905ZU2Wn
        uGl/2sxtaeMzwXwte12I6FbRzcxmCh2Tj/g1es5frda+50WLxf6kqY+OOd983vyGe7lX/i77
        J8XWHG8mC9VOWhnl2b9vyZ6uNvNG/q9V7CFXxI6Z7b66x+3Hj3TVt9XGWU8+xZ/gLu7V6T7D
        /vZoVJRZoG/P/scRPLIrU9duFeKZ/TovYa3Lxa33IybIVU8uT1kbuqabV88o1eXNKblVBydz
        //h3qvfwpvida9QyP68wKuN5o/LA0MhwXe5C02rPt0+CBJtfV7UosRRnJBpqMRcVJwIAqp+C
        kisEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsWy7bCSnG7pbZ5EgwtT5CxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWLxdekzVotP65exWqxe/IDFYtGNbUwWN7ccZbG4vGsOm0X39R1sFsuP/2Oy
        6Lp7g9Fi6b+3LA58Hpf7epk8Fu95yeQxYdEBRo/v6zvYPD4+vcXi0bdlFaPH501yHu0HupkC
        OKK4bFJSczLLUov07RK4Mt58/MZUMEutomf3BbYGxudyXYycHBICJhKLHlxgA7GFBHYwStxq
        SIWIS0qc2PmcEcIWlrjfcoS1i5ELqOYbo8SrmRtZQBJsApoST29OZQJJiAicY5KYenkpE0iC
        WUBdYteEE2C2sIC7RMeZZnYQm0VAVaL34FQwm1cgWuLaufOsEBvkJG6e62QGsTkFLCUW3Wxn
        grjIQmLV3udsuMQnMAosYGRYxSiZWlCcm55bbFhglJdarlecmFtcmpeul5yfu4kRHAtaWjsY
        96z6oHeIkYmD8RCjBAezkghv8mKuRCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8F7pOxgsJpCeW
        pGanphakFsFkmTg4pRqYYqpkLH7HVa7/e+t7r35xfcTeIsdpX7ribBtZz0e8CdJftF6fJfv1
        0d3Je0uD3mvPmf33bYbJ0ibOh+8CNaR/91192yd/fnPGBo5YncauH6cOnXJwZ3fS/KHKnVZR
        ueK62a7bm9bd9tPc92XJwyMy1mfXn3jz78n+PXoxsyINO+P9sxi3tvnozMx6Op+7u7rW1Cx8
        MbN7xxFxjW+BxVmejKV/NYQWtFccFJ4qs3DKrBZDLf/gdJX2wnz+E3PXbGGYVHlzrrSAU+fm
        2mdm61xjhO45cNYWxx3xucvtd8n1hobDB/8Vi/kYz6gUbRP90CT161jhzK5LqwtYPvs4sjs1
        tHJ3rXj76sJt0WW+PdVKLMUZiYZazEXFiQAdfAPo9AIAAA==
X-CMS-MailID: 20210806064925epcas2p2ba7e711758614384c17648d4924d025c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210806064925epcas2p2ba7e711758614384c17648d4924d025c
References: <cover.1628231581.git.kwmad.kim@samsung.com>
        <CGME20210806064925epcas2p2ba7e711758614384c17648d4924d025c@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Based on some events in the real world, I implement
this to block the host's working in some abnormal
conditions using an vendor specific interrupt for
cases that some contexts of a pending request in the
host isn't the same with those of its corresponding UPIUs
if they should have been the same exactly.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 78 +++++++++++++++++++++++++++++------
 1 file changed, 66 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index cf46d6f86e0e..2cfe959e05b6 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -31,6 +31,8 @@
 #define HCI_RXPRDT_ENTRY_SIZE	0x04
 #define HCI_1US_TO_CNT_VAL	0x0C
 #define CNT_VAL_1US_MASK	0x3FF
+#define VENDOR_SPECIFIC_IS	0x38
+#define VENDOR_SPECIFIC_IE	0x3C
 #define HCI_UTRL_NEXUS_TYPE	0x40
 #define HCI_UTMRL_NEXUS_TYPE	0x44
 #define HCI_SW_RST		0x50
@@ -74,6 +76,18 @@
 				 UIC_TRANSPORT_NO_CONNECTION_RX |\
 				 UIC_TRANSPORT_BAD_TC)
 
+enum exynos_ufs_vs_interrupt {
+	/*
+	 * This occurs when information of a pending request isn't
+	 * the same with incoming UPIU for the request. For example,
+	 * if UFS driver rings with task tag #1, subsequential UPIUs
+	 * for this must have one as the value of task tag. But if
+	 * it's corrutped until the host receives it or incoming UPIUs
+	 * has an unexpected value for task tag, this raises.
+	 */
+	RX_UPIU_HIT_ERROR	= 1 << 19,
+};
+
 enum {
 	UNIPRO_L1_5 = 0,/* PHY Adapter */
 	UNIPRO_L2,	/* Data Link */
@@ -996,6 +1010,10 @@ static int exynos_ufs_init(struct ufs_hba *hba)
 		goto out;
 	exynos_ufs_specify_phy_time_attr(ufs);
 	exynos_ufs_config_smu(ufs);
+
+	/* enable vendor interrupts */
+	hci_writel(ufs, VENDOR_SPECIFIC_IE, RX_UPIU_HIT_ERROR);
+
 	return 0;
 
 phy_off:
@@ -1005,26 +1023,33 @@ static int exynos_ufs_init(struct ufs_hba *hba)
 	return ret;
 }
 
-static int exynos_ufs_host_reset(struct ufs_hba *hba)
+static int exynos_ufs_host_reset(struct exynos_ufs *ufs)
 {
-	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
 	unsigned long timeout = jiffies + msecs_to_jiffies(1);
-	u32 val;
-	int ret = 0;
-
-	exynos_ufs_disable_auto_ctrl_hcc_save(ufs, &val);
 
+	/* host reset */
 	hci_writel(ufs, UFS_SW_RST_MASK, HCI_SW_RST);
-
 	do {
 		if (!(hci_readl(ufs, HCI_SW_RST) & UFS_SW_RST_MASK))
-			goto out;
+			return 0;
 	} while (time_before(jiffies, timeout));
 
-	dev_err(hba->dev, "timeout host sw-reset\n");
-	ret = -ETIMEDOUT;
+	pr_err("timeout host sw-reset\n");
+	return -ETIMEDOUT;
+}
+
+static int exynos_ufs_host_init(struct ufs_hba *hba)
+{
+	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
+	u32 val;
+	int ret;
+
+	exynos_ufs_disable_auto_ctrl_hcc_save(ufs, &val);
+
+	ret = exynos_ufs_host_reset(ufs);
+	if (ret)
+		return ret;
 
-out:
 	exynos_ufs_auto_ctrl_hcc_restore(ufs, &val);
 	return ret;
 }
@@ -1110,7 +1135,7 @@ static int exynos_ufs_hce_enable_notify(struct ufs_hba *hba,
 
 	switch (status) {
 	case PRE_CHANGE:
-		ret = exynos_ufs_host_reset(hba);
+		ret = exynos_ufs_host_init(hba);
 		if (ret)
 			return ret;
 		exynos_ufs_dev_hw_reset(hba);
@@ -1198,6 +1223,34 @@ static int exynos_ufs_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	return 0;
 }
 
+static irqreturn_t exynos_ufs_isr(struct ufs_hba *hba, int *res)
+{
+	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
+	u32 status;
+
+	status = hci_readl(ufs, VENDOR_SPECIFIC_IS);
+	hci_writel(ufs, status, VENDOR_SPECIFIC_IS);
+	/*
+	 * If host doesn't guarantee integrity of UTP transmission,
+	 * it needs to be reset immediately to make it unable to
+	 * proceed requests. Because w/o this, if UTP functions
+	 * in host doesn't work properly for such system power margins,
+	 * DATA IN from broken devices or whatever in the real world,
+	 * some unexpected events could happen, such as tranferring
+	 * a broken DATA IN to a device. It could be various types of
+	 * problems on the level of file system. In this case, I think
+	 * blocking the host's functionality is the best strategy.
+	 * Perhaps, if its root cause is temporary, system could recover.
+	 */
+	if (status & RX_UPIU_HIT_ERROR) {
+		pr_err("%s: status: 0x%08x\n", __func__, status);
+		exynos_ufs_host_reset(ufs);
+		*res = 1;
+		return IRQ_HANDLED;
+	}
+	return IRQ_NONE;
+}
+
 static struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.name				= "exynos_ufs",
 	.init				= exynos_ufs_init,
@@ -1209,6 +1262,7 @@ static struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.hibern8_notify			= exynos_ufs_hibern8_notify,
 	.suspend			= exynos_ufs_suspend,
 	.resume				= exynos_ufs_resume,
+	.intr				= exynos_ufs_isr,
 };
 
 static int exynos_ufs_probe(struct platform_device *pdev)
-- 
2.31.1

