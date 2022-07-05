Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AE86CCA47B
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jul 2022 06:57:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbiGEG5e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jul 2022 02:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiGEG5d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2022 02:57:33 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1865C11160
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jul 2022 23:57:28 -0700 (PDT)
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220705065724epoutp040106147e250afb0d5247dd8a22e7a9f4~_3JSwR05Y0610006100epoutp04G
        for <linux-scsi@vger.kernel.org>; Tue,  5 Jul 2022 06:57:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220705065724epoutp040106147e250afb0d5247dd8a22e7a9f4~_3JSwR05Y0610006100epoutp04G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1657004244;
        bh=GaXk6C5ZPNsJghk/oacoRjHDd45VFdfE52ZJL9lfkPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pci4O45Ge1DRgwKKZMpcdHxUUpc+QPg2EKgfl7j9mQuBrHPDxj7H5hWCCWYcgUJai
         XUROg6fPni1ZnQhnhjgR5nVk6cfln/LFXMHXj5bvhV+emzlfxbpCTLEw+US+NzcBRA
         O7vYEhEwZeRmcpH98CMqIn+OqUDC+8YdBLWYwkCM=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20220705065723epcas2p115fd9ef18d77c19234b44182cac668a8~_3JSWNshq0422904229epcas2p1u;
        Tue,  5 Jul 2022 06:57:23 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.69]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4LcYQC2TK5z4x9Q8; Tue,  5 Jul
        2022 06:57:23 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        46.02.09642.2D0E3C26; Tue,  5 Jul 2022 15:57:22 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20220705065722epcas2p1e93a8511b906d5e111bff48a312d0603~_3JRSIaiI0422904229epcas2p1o;
        Tue,  5 Jul 2022 06:57:22 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220705065722epsmtrp266de03dc69b6fac2f1c24830cdd316e5~_3JRQf4oY0175501755epsmtrp2D;
        Tue,  5 Jul 2022 06:57:22 +0000 (GMT)
X-AuditID: b6c32a47-5f7ff700000025aa-b9-62c3e0d2a3a7
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        7B.9C.08905.2D0E3C26; Tue,  5 Jul 2022 15:57:22 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220705065722epsmtip1655df47d4a490dea18633e188803e41c~_3JRBuGLG2649026490epsmtip1X;
        Tue,  5 Jul 2022 06:57:22 +0000 (GMT)
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
Subject: [PATCH 2/3] phy: samsung-ufs: ufs: change phy on/off control
Date:   Tue,  5 Jul 2022 15:54:39 +0900
Message-Id: <20220705065440.117864-3-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705065440.117864-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOJsWRmVeSWpSXmKPExsWy7bCmme6lB4eTDHrnmVo8mLeNzWLah5/M
        Fpf3a1ssurGNyeLC0x42i72vt7JbbHp8jdViwqpvLBYzzu9jsui+voPNYvnxf0wWO++cYHbg
        8bh8xdtj06pONo871/aweUxYdIDRY/OSeo+PT2+xePRtWcXocfzGdiaPz5vkAjijsm0yUhNT
        UosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgA5WUihLzCkFCgUk
        Fhcr6dvZFOWXlqQqZOQXl9gqpRak5BSYF+gVJ+YWl+al6+WlllgZGhgYmQIVJmRnbN5aWDBF
        qOJNx3SWBsYu/i5GTg4JAROJpl3rmLoYuTiEBHYwSiyd94wNwvnEKLF1x29WCOcbo8T9TZPY
        YVoOvTvACJHYyyjxe34PC0hCSOAjo8SPi6UgNpuArsSW56/AikQEdjBJ3GqZyALiMAtsZpRo
        v7qTDaRKWMBVYln/X7BuFgFVib2v54HZvAL2EvNONTNCrJOX2HBwO1icU8BB4uTH6VA1ghIn
        Zz4Bs5mBapq3zmYGWSAhsJRDouftdqhbXSSWvD0GNUhY4tXxLVBxKYnP7/ayQdjFEktnfWKC
        aG5glLi87RdUwlhi1rN2oGYOoA2aEut36YOYEgLKEkduQe3lk+g4/JcdIswr0dEmBNGoLnFg
        O8SZEgKyEt1zPrNC2B4Sfxf3QgN7MqPE5ztd7BMYFWYheWcWkndmISxewMi8ilEstaA4Nz21
        2KjAGB7Fyfm5mxjBKVjLfQfjjLcf9A4xMnEwHmKU4GBWEuFdNelgkhBvSmJlVWpRfnxRaU5q
        8SFGU2BgT2SWEk3OB2aBvJJ4QxNLAxMzM0NzI1MDcyVxXq+UDYlCAumJJanZqakFqUUwfUwc
        nFINTELcSqyev/cHTOqo07tUGHR1+1KWz8LFp/RuZK2vkn5SMEM368vcp1n5p4z/7Hi2bKX0
        y8dlx/ey6txUTkiKP6v9dHK147anWYXRC3srS/WOS5xOOfJhUo7+BVvB9BmnfZrq9rDxRt+U
        2pjKOntuWMjHmB02ulMnPYp+uInLwyRxHvuDiQt4lkg9y3/fL3n4yXKtdc3b1+Q+mbTFw9Ka
        YQl7hHDNWhZFz/tlAT436+q2vOlpmC15rGR9yt5P877YWbzP+JTcqHk75o/Xjy39Pz4vKZip
        cWDHxOdbJ/ztmu62wbmq7vDlj6LsL2qOxsx3/yjgMWvC6bwnK5wnz3nZaxuXX7uYYYa3bkzm
        9Zdmvf+UWIozEg21mIuKEwEQNOuiSgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsWy7bCSnO6lB4eTDH6cF7V4MG8bm8W0Dz+Z
        LS7v17ZYdGMbk8WFpz1sFntfb2W32PT4GqvFhFXfWCxmnN/HZNF9fQebxfLj/5gsdt45wezA
        43H5irfHplWdbB53ru1h85iw6ACjx+Yl9R4fn95i8ejbsorR4/iN7UwenzfJBXBGcdmkpOZk
        lqUW6dslcGVs3lpYMEWo4k3HdJYGxi7+LkZODgkBE4lD7w4wdjFycQgJ7GaUOPr8FTNEQlbi
        2bsd7BC2sMT9liOsEEXvGSVurOllBUmwCehKbHn+CqxbRGAPk8SXeRtYQBxmge2MElPeXmcB
        qRIWcJVY1v8XzGYRUJXY+3oemM0rYC8x71QzI8QKeYkNB7eDxTkFHCROfpwOZgsB1fx7fI0d
        ol5Q4uTMJ2BxZqD65q2zmScwCsxCkpqFJLWAkWkVo2RqQXFuem6xYYFhXmq5XnFibnFpXrpe
        cn7uJkZwtGhp7mDcvuqD3iFGJg7GQ4wSHMxKIryrJh1MEuJNSaysSi3Kjy8qzUktPsQozcGi
        JM57oetkvJBAemJJanZqakFqEUyWiYNTqoFp8XVe2z23r9o5/A1tFvx276r1v2OCzt58G1P0
        GbVEuc9I1uRpX3zus2xJYfac1qU/FpslHF3dMHn3qXWtEbozTn3jvzBv1ZuLlyqUunezBu3M
        8jqe/9z5woSE5k3Ns7bz8t9h+82x/lpUrdCCarOYQmG9NbbCB6d28N2es3ZqlXX/A1mXfMOl
        fc1ed0zy/rN8CYl5OqkndNfHugU7HERD7LZye4u/2/ppqWH0xaOOB6R19+/vaw26X9rGnPtt
        g6q/wO6pWw7/rVg+u6RV3sbA67NO6ValUFG2VR2Bkzx/vL29MzGoe0LvrV1H1i3PNt1oay20
        Q8f64zx2r1+7vi7R5J9r+Thb7IJg7yEDOZ7zSizFGYmGWsxFxYkAnQdhogUDAAA=
X-CMS-MailID: 20220705065722epcas2p1e93a8511b906d5e111bff48a312d0603
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220705065722epcas2p1e93a8511b906d5e111bff48a312d0603
References: <20220705065440.117864-1-chanho61.park@samsung.com>
        <CGME20220705065722epcas2p1e93a8511b906d5e111bff48a312d0603@epcas2p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The sequence of controlling ufs phy block should be below:

1) Power On
 - Turn off pmu isolation
 - Clock enable
2) Power Off
 - Clock disable
 - Turn on pmu isolation

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/phy/samsung/phy-samsung-ufs.c | 32 ++++++++++++++++-----------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/phy/samsung/phy-samsung-ufs.c b/drivers/phy/samsung/phy-samsung-ufs.c
index 14cce2f2487e..183c88e3d1ec 100644
--- a/drivers/phy/samsung/phy-samsung-ufs.c
+++ b/drivers/phy/samsung/phy-samsung-ufs.c
@@ -151,37 +151,43 @@ static int samsung_ufs_phy_clks_init(struct samsung_ufs_phy *phy)
 static int samsung_ufs_phy_init(struct phy *phy)
 {
 	struct samsung_ufs_phy *ss_phy = get_samsung_ufs_phy(phy);
-	int ret;
 
 	ss_phy->lane_cnt = phy->attrs.bus_width;
 	ss_phy->ufs_phy_state = CFG_PRE_INIT;
 
+	return 0;
+}
+
+static int samsung_ufs_phy_power_on(struct phy *phy)
+{
+	struct samsung_ufs_phy *ss_phy = get_samsung_ufs_phy(phy);
+	int ret;
+
+	samsung_ufs_phy_ctrl_isol(ss_phy, false);
+
 	ret = clk_bulk_prepare_enable(ss_phy->drvdata->num_clks, ss_phy->clks);
 	if (ret) {
 		dev_err(ss_phy->dev, "failed to enable ufs phy clocks\n");
 		return ret;
 	}
 
-	ret = samsung_ufs_phy_calibrate(phy);
-	if (ret)
-		dev_err(ss_phy->dev, "ufs phy calibration failed\n");
+	if (ss_phy->ufs_phy_state == CFG_PRE_INIT) {
+		ret = samsung_ufs_phy_calibrate(phy);
+		if (ret)
+			dev_err(ss_phy->dev, "ufs phy calibration failed\n");
+	}
 
 	return ret;
 }
 
-static int samsung_ufs_phy_power_on(struct phy *phy)
-{
-	struct samsung_ufs_phy *ss_phy = get_samsung_ufs_phy(phy);
-
-	samsung_ufs_phy_ctrl_isol(ss_phy, false);
-	return 0;
-}
-
 static int samsung_ufs_phy_power_off(struct phy *phy)
 {
 	struct samsung_ufs_phy *ss_phy = get_samsung_ufs_phy(phy);
 
+	clk_bulk_disable_unprepare(ss_phy->drvdata->num_clks, ss_phy->clks);
+
 	samsung_ufs_phy_ctrl_isol(ss_phy, true);
+
 	return 0;
 }
 
@@ -202,7 +208,7 @@ static int samsung_ufs_phy_exit(struct phy *phy)
 {
 	struct samsung_ufs_phy *ss_phy = get_samsung_ufs_phy(phy);
 
-	clk_bulk_disable_unprepare(ss_phy->drvdata->num_clks, ss_phy->clks);
+	ss_phy->ufs_phy_state = CFG_TAG_MAX;
 
 	return 0;
 }
-- 
2.37.0

