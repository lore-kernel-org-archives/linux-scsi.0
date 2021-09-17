Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F45BC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 06:55:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A776610C8
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 06:55:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238770AbhIQG5S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 02:57:18 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53958 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238448AbhIQG4y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 02:56:54 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210917065526epoutp0135e60f4a24a49c1fe218092e42ac959f~liZgbtnVO0941709417epoutp01C
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 06:55:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210917065526epoutp0135e60f4a24a49c1fe218092e42ac959f~liZgbtnVO0941709417epoutp01C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1631861726;
        bh=3baXso0cT4YAdRrO2mhhbue5bCk6NOjPCDeLrfPw0uc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jSuWLl34lBzjIwAM6QvXF1qUzKQ4wBX0JYPMrMUXOKVuSowINN6ORn1W7KIeY+8Gf
         ukjRssfEgfXPqjzNaVtKz7w8j8Oo36Ev3uIwqpcPKWgGMlB4ofkvuKUpNtna7MsmeB
         Z4jzKoobeEnoGsWYnuZMpGJG5tcZGorimPUcfeGo=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210917065525epcas2p22a1df3fdd70d60289a85b23782d8cf30~liZf8sTut0686706867epcas2p2l;
        Fri, 17 Sep 2021 06:55:25 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.186]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4H9l8D43q5z4x9Pw; Fri, 17 Sep
        2021 06:55:24 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        CC.ED.09749.CDB34416; Fri, 17 Sep 2021 15:55:24 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20210917065523epcas2p3b178e3d9d2d4db628f597732be9c6856~liZd8yBBy0100601006epcas2p3r;
        Fri, 17 Sep 2021 06:55:23 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210917065523epsmtrp1d41b70439ea441ad9959548eae7e1798~liZd5RMuf1045910459epsmtrp1B;
        Fri, 17 Sep 2021 06:55:23 +0000 (GMT)
X-AuditID: b6c32a47-29aa8a8000002615-af-61443bdc7ebe
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        29.91.08750.BDB34416; Fri, 17 Sep 2021 15:55:23 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210917065523epsmtip240432b2e231c3df41a76b45b4fd4f1ca~liZdsnSl11565515655epsmtip2n;
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
Subject: [PATCH v3 11/17] scsi: ufs: ufs-exynos: add
 EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR option
Date:   Fri, 17 Sep 2021 15:54:30 +0900
Message-Id: <20210917065436.145629-12-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210917065436.145629-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBJsWRmVeSWpSXmKPExsWy7bCmhe4da5dEg1m3OSxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZotP65exWlzer23Rs9PZ4vSERUwWT9bPYrZYdGMbk8XGtz+YLG5u
        OcpiMeP8PiaL7us72CyWH//H5CDgcfmKt8eshl42j8t9vUwem1doeSze85LJY9OqTjaPCYsO
        MHp8X9/B5vHx6S0Wj74tqxg9Pm+S82g/0M0UwBOVY5ORmpiSWqSQmpecn5KZl26r5B0c7xxv
        amZgqGtoaWGupJCXmJtqq+TiE6DrlpkD9JKSQlliTilQKCCxuFhJ386mKL+0JFUhI7+4xFYp
        tSAlp8DQsECvODG3uDQvXS85P9fK0MDAyBSoMiEno2P9dNaCnTwVE6c1MzUwfuTqYuTkkBAw
        kTi2YD8LiC0ksINR4ukerS5GLiD7E6PE7i8PoRKfGSW2fY2DaZi44TozRHwXo8Ts66UQDR8Z
        JRavaGMDSbAJ6Epsef6KESQhIvCeUeLJ4ynsIA6zwCxmieNfJzOBVAkLJEo0ru0G62ARUJV4
        0nqEHcTmFXCQ+DnnOyvEOnmJI786wdZxAsVv7frPCFEjKHFy5hOw85iBapq3zmYGWSAhcIND
        4u+300AJDiDHRWL23giIOcISr45vYYewpSRe9rexQ9R3M0q0PvoPlVjNKNHZ6ANh20v8mr6F
        FWQOs4CmxPpd+hAjlSWO3IJayyfRcfgvO0SYV6KjTQiiUV3iwPbpLBC2rET3nM9Qn3hIHOpf
        ww4JrMmMEkev7GGcwKgwC8k3s5B8Mwth8QJG5lWMYqkFxbnpqcVGBcbIEbyJEZzEtdx3MM54
        +0HvECMTB+MhRgkOZiUR3gs1jolCvCmJlVWpRfnxRaU5qcWHGE2BYT2RWUo0OR+YR/JK4g1N
        jczMDCxNLUzNjCyUxHnn/nNKFBJITyxJzU5NLUgtgulj4uCUamBSe/7U60B6rJ52Ncdun30G
        zydOmfLS56jZ3cfxH+6/Y5zcxftknne3+9euR69Pdwf2s0RWcO6dXb8/M2TPvosxfy29xdr5
        fvLtuek1a8M3nSZHG7MCqa7AyMCJYWc8bp07btMbXsxX/Z5TIdJe6NeS1NyAE/f4NHsc+G3L
        G5UnJateU+nVXZ56vdXsXnHXvN28Wte/MN36MTmbX/CawINttZPsCt9U7rngqW7BF+W2WOxp
        9OV1fxJe1M7Wqqp6tPrk56dip3efFN3JbWgooa22qL4nV0SXY0b2D8mQzpu9u5X+Rabt8+iM
        aY/aV+qYaVVpOnP5xeYJfGnSp5vmKQrkXzIRrMmR/iKz0VhpkRJLcUaioRZzUXEiAH8mYz5r
        BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsWy7bCSvO5ta5dEg4snlC1OPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZotP65exWlzer23Rs9PZ4vSERUwWT9bPYrZYdGMbk8XGtz+YLG5u
        OcpiMeP8PiaL7us72CyWH//H5CDgcfmKt8eshl42j8t9vUwem1doeSze85LJY9OqTjaPCYsO
        MHp8X9/B5vHx6S0Wj74tqxg9Pm+S82g/0M0UwBPFZZOSmpNZllqkb5fAldGxfjprwU6eionT
        mpkaGD9ydTFyckgImEhM3HCdGcQWEtjBKPFwbilEXFbi2bsd7BC2sMT9liOsXYxcQDXvGSX+
        3l0GlmAT0JXY8vwVI4gtIvCRUWLONy2QImaBJcwSjQfmMYEkhAXiJX7Of8kKYrMIqEo8aT0C
        1swr4CDxc853VogN8hJHfnWCXcEJFL+16z8jxEX2EhMnL2KEqBeUODnzCQuIzQxU37x1NvME
        RoFZSFKzkKQWMDKtYpRMLSjOTc8tNiwwykst1ytOzC0uzUvXS87P3cQIjjctrR2Me1Z90DvE
        yMTBeIhRgoNZSYT3Qo1johBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeC10n44UE0hNLUrNTUwtS
        i2CyTBycUg1MxvJ2LS/3lyuLa59qU7v+jSfsw5RV2UfWsm+7Ynn65koHn6SJM41f9z19teN+
        dl2739OmpL609bWy316LaXvt6Z8yx7xaOK3f42WiNqPZf66tj1euUM744yF+d5GQ/aPn894E
        5xw8vTfY1uCp7L+JC432fjv1bsLXC6smn9mdnKQdtPNyXb32zvTYitS/ZYaqn//37/c1avyn
        +LdwV9qJDO4Dlruv9a5TTPl72uv1FPvE4zfmzjJROaBRsSantI3/EfNfuUPPHl9vFPulIGhz
        1Sz1mnfs0c82Ik+KxY4fjP9Z0Zcam7QoIJqzffmRT3Ncnm0TvNro1+Xc6cOhsPTA9rgwSxb+
        Aom7Vd+CpW8pKrEUZyQaajEXFScCADqM1OYmAwAA
X-CMS-MailID: 20210917065523epcas2p3b178e3d9d2d4db628f597732be9c6856
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210917065523epcas2p3b178e3d9d2d4db628f597732be9c6856
References: <20210917065436.145629-1-chanho61.park@samsung.com>
        <CGME20210917065523epcas2p3b178e3d9d2d4db628f597732be9c6856@epcas2p3.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To skip exynos_ufs_config_phy_*_attr settings for exynos-ufs variant,
this patch provides EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR as an opts
flag.

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 6 ++++--
 drivers/scsi/ufs/ufs-exynos.h | 1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index a3160d9bd234..73833c186ca9 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -831,8 +831,10 @@ static int exynos_ufs_pre_link(struct ufs_hba *hba)
 
 	/* m-phy */
 	exynos_ufs_phy_init(ufs);
-	exynos_ufs_config_phy_time_attr(ufs);
-	exynos_ufs_config_phy_cap_attr(ufs);
+	if (!(ufs->opts & EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR)) {
+		exynos_ufs_config_phy_time_attr(ufs);
+		exynos_ufs_config_phy_cap_attr(ufs);
+	}
 
 	exynos_ufs_setup_clocks(hba, true, POST_CHANGE);
 
diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
index bc4b8b0324bd..a0899aaa902e 100644
--- a/drivers/scsi/ufs/ufs-exynos.h
+++ b/drivers/scsi/ufs/ufs-exynos.h
@@ -200,6 +200,7 @@ struct exynos_ufs {
 #define EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL	BIT(2)
 #define EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX	BIT(3)
 #define EXYNOS_UFS_OPT_USE_SW_HIBERN8_TIMER	BIT(4)
+#define EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR	BIT(5)
 };
 
 #define for_each_ufs_rx_lane(ufs, i) \
-- 
2.33.0

