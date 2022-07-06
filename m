Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62D87CCA47B
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 02:05:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiGFCFv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jul 2022 22:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiGFCFr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2022 22:05:47 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E6D193DE
        for <linux-scsi@vger.kernel.org>; Tue,  5 Jul 2022 19:05:46 -0700 (PDT)
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220706020542epoutp039bca6c7b691a902f98f79beb667e815d~-Gz5foC3s2494324943epoutp03h
        for <linux-scsi@vger.kernel.org>; Wed,  6 Jul 2022 02:05:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220706020542epoutp039bca6c7b691a902f98f79beb667e815d~-Gz5foC3s2494324943epoutp03h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1657073142;
        bh=4WVMidKDt46NeEqlGcQQblUJcueMO5seurJwZWyKKCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HAidpDx7GNmQmqwnjXqzvkWpXJcaHZ+LqJlIgKpp6AkbmYRqXl4jI6nDFUApNyN7j
         tHxAP9x3hcii7jHjVfMdBmE8+opgCIxDKISMm6AnTmSq11sjCXe3Vzmaa0NEwz4dv9
         hsZMwbslYZfFh0pouehakLPSeYpC2EOt3JSu9urk=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20220706020541epcas2p1e5cbbb9553b612da8f9ca01020c77029~-Gz4z6iha0309303093epcas2p1t;
        Wed,  6 Jul 2022 02:05:41 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.69]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Ld2v941pDz4x9QJ; Wed,  6 Jul
        2022 02:05:41 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        09.B2.09666.5FDE4C26; Wed,  6 Jul 2022 11:05:41 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20220706020541epcas2p1c74a1d1b5ca37ee4795bf9ec0da23fa9~-Gz4CwDpV0308403084epcas2p16;
        Wed,  6 Jul 2022 02:05:41 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220706020541epsmtrp2e90554a8be70f454977286ad7481b9ac~-Gz4B_sEm3159231592epsmtrp28;
        Wed,  6 Jul 2022 02:05:41 +0000 (GMT)
X-AuditID: b6c32a45-471ff700000025c2-0a-62c4edf5d3fd
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E8.5B.08802.4FDE4C26; Wed,  6 Jul 2022 11:05:40 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220706020540epsmtip2a84f95c5fab56304ce9e9eab073eb1ad~-Gz3yh33M1055210552epsmtip2F;
        Wed,  6 Jul 2022 02:05:40 +0000 (GMT)
From:   Chanho Park <chanho61.park@samsung.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH v2 3/3] ufs: ufs-exynos: change ufs phy control sequence
Date:   Wed,  6 Jul 2022 11:02:55 +0900
Message-Id: <20220706020255.151177-4-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220706020255.151177-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJJsWRmVeSWpSXmKPExsWy7bCmhe7Xt0eSDNbukbN4MG8bm8W0Dz+Z
        LS7v17ZYdGMbk8WFpz1sFntfb2W32PT4GqvFhFXfWCxmnN/HZNF9fQebxfLj/5gsdt45wezA
        43H5irfHplWdbB53ru1h85iw6ACjx+Yl9R4fn95i8ejbsorR4/iN7UwenzfJBXBGZdtkpCam
        pBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAB2spFCWmFMKFApI
        LC5W0rezKcovLUlVyMgvLrFVSi1IySkwL9ArTswtLs1L18tLLbEyNDAwMgUqTMjO2PVkJUvB
        Wb6Kj4/OsjQwfuXuYuTkkBAwkXj75QRzFyMXh5DADkaJLZMus0I4nxglJh37AeV8ZpSY3zOf
        Eabl1toVUC27GCW2Hf0N5XxklJhxfikzSBWbgK7EluevGEESIgI7mCRutUxkAXGYBTYzSrRf
        3ckGUiUs4CEx5fszsA4WAVWJVQfWsIDYvAL2Egd3PmCG2CcvseHgdrA4p4CDxO/fvcwQNYIS
        J2c+AYszA9U0b50NdoaEwEoOic+zvkEd6yIx4eIlNghbWOLV8S3sELaUxOd3e6HixRJLZ31i
        gmhuYJS4vO0XVMJYYtazdqBBHEAbNCXW79IHMSUElCWO3ILayyfRcfgvO0SYV6KjTQiiUV3i
        wPbpLBC2rET3nM+sELaHxNyHf9ggoTWZUeLQllOsExgVZiF5ZxaSd2YhLF7AyLyKUSy1oDg3
        PbXYqMAQHsnJ+bmbGMFpWMt1B+Pktx/0DjEycTAeYpTgYFYS4V016WCSEG9KYmVValF+fFFp
        TmrxIUZTYGBPZJYSTc4HZoK8knhDE0sDEzMzQ3MjUwNzJXFer5QNiUIC6YklqdmpqQWpRTB9
        TBycUg1M258dU5G+Fdn3YHKoz+oIc8P3u8Qi7/+wWHZduXTHtyOO4Xkhp9WebuN/wmT0/t07
        q5Ns27tmbSznzqz+y/PaiNkg70j0/V3zC4v0hfve1i96ZH1QMMDx1ZT35fLcr82/FlsfWlyr
        8amo4P6uPrU9Le8NYzzeyPy8vcPPOaw30OxjVQrfY67Ew5fnVPPPc1svVL3Ee5/oArEIt46d
        6vWuP3mFJt3wnMlul6fGvTT9JbcOm0vEKqXHS/+//GfDfbhwjX68wBbHCYEzDPkm7tRwV8px
        8ZYr/sMbUv49WOfC8Q7FCrmzOzTFppuxOvw/9/TiqoZFc9+82drbbzJnwZ8Dlre2n/q22XRH
        yS/7d1YPlViKMxINtZiLihMB9XJSekwEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsWy7bCSvO6Xt0eSDDa+Mrd4MG8bm8W0Dz+Z
        LS7v17ZYdGMbk8WFpz1sFntfb2W32PT4GqvFhFXfWCxmnN/HZNF9fQebxfLj/5gsdt45wezA
        43H5irfHplWdbB53ru1h85iw6ACjx+Yl9R4fn95i8ejbsorR4/iN7UwenzfJBXBGcdmkpOZk
        lqUW6dslcGXserKSpeAsX8XHR2dZGhi/cncxcnJICJhI3Fq7grmLkYtDSGAHo8Tsx2sZIRKy
        Es/e7WCHsIUl7rccYYUoes8o8flZHwtIgk1AV2LL81eMIAkRgT1MEl/mbWABcZgFtjNKTHl7
        HaxKWMBDYsr3Z8wgNouAqsSqA2vA4rwC9hIHdz5ghlghL7Hh4HawOKeAg8Tv371gcSGgmnuf
        VkPVC0qcnPkEzGYGqm/eOpt5AqPALCSpWUhSCxiZVjFKphYU56bnFhsWGOWllusVJ+YWl+al
        6yXn525iBMeLltYOxj2rPugdYmTiYDzEKMHBrCTCu2rSwSQh3pTEyqrUovz4otKc1OJDjNIc
        LErivBe6TsYLCaQnlqRmp6YWpBbBZJk4OKUamCb6TD/wPiZqgqFMxrYnBuodfFysDyZt1l4a
        l22340TOs5j0DM81GhdtP6X1+Ds0Pt1TFDHv+A2WA0d7NqUsjgyvvv1Wu+B3rpLA3Pw/Wo9L
        Z94Q/vbg2OvFh+uO7kwulDzo7/7z1lkD70PqnLMcP2pX8L54OH/LHHZx9mlFvO+veAlN1dFV
        4Aj9s/lxxFOP7+/OpXNXik8TMq4O5+Z62ymhvmCrQNyFY+wtCV8OnPvZ+G/vmi3/Zaa7WgXu
        vHK3z0z1x+1ZM+98Eliwo0e0JXXRzcSOEibHSaxf0k5E3nqSYXXcNat74t1dBq/cd85kZjnD
        lS333zXvk53FjKmXu4P3mJkGf+3NFdt9YMPM5H4lluKMREMt5qLiRACla7frBgMAAA==
X-CMS-MailID: 20220706020541epcas2p1c74a1d1b5ca37ee4795bf9ec0da23fa9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220706020541epcas2p1c74a1d1b5ca37ee4795bf9ec0da23fa9
References: <20220706020255.151177-1-chanho61.park@samsung.com>
        <CGME20220706020541epcas2p1c74a1d1b5ca37ee4795bf9ec0da23fa9@epcas2p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since commit 1599069a62c6 ("phy: core: Warn when phy_power_on is called
before phy_init"), below warning has been reported.

phy_power_on was called before phy_init

To address this, we need to remove phy_power_on from
exynos_ufs_phy_init and move it after phy_init. phy_power_off and
phy_exit are also necessary in exynos_ufs_remove.

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/ufs/host/ufs-exynos.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index f971569bafc7..eced97538082 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -905,9 +905,13 @@ static int exynos_ufs_phy_init(struct exynos_ufs *ufs)
 	if (ret) {
 		dev_err(hba->dev, "%s: phy init failed, ret = %d\n",
 			__func__, ret);
-		goto out_exit_phy;
+		return ret;
 	}
 
+	ret = phy_power_on(generic_phy);
+	if (ret)
+		goto out_exit_phy;
+
 	return 0;
 
 out_exit_phy:
@@ -1169,10 +1173,6 @@ static int exynos_ufs_init(struct ufs_hba *hba)
 		goto out;
 	}
 
-	ret = phy_power_on(ufs->phy);
-	if (ret)
-		goto phy_off;
-
 	exynos_ufs_priv_init(hba, ufs);
 
 	if (ufs->drv_data->drv_init) {
@@ -1190,8 +1190,6 @@ static int exynos_ufs_init(struct ufs_hba *hba)
 	exynos_ufs_config_smu(ufs);
 	return 0;
 
-phy_off:
-	phy_power_off(ufs->phy);
 out:
 	hba->priv = NULL;
 	return ret;
@@ -1602,9 +1600,14 @@ static int exynos_ufs_probe(struct platform_device *pdev)
 static int exynos_ufs_remove(struct platform_device *pdev)
 {
 	struct ufs_hba *hba =  platform_get_drvdata(pdev);
+	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
 
 	pm_runtime_get_sync(&(pdev)->dev);
 	ufshcd_remove(hba);
+
+	phy_power_off(ufs->phy);
+	phy_exit(ufs->phy);
+
 	return 0;
 }
 
-- 
2.37.0

