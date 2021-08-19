Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6D87C4320A
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 01:49:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADA5A610F9
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 01:49:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236389AbhHTBtq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 21:49:46 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:13347 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235877AbhHTBtn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 21:49:43 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210820014903epoutp01b0d31f03fe6d9ac4e989bdbe0c6ba068~c4KA6B9SV1829618296epoutp01_
        for <linux-scsi@vger.kernel.org>; Fri, 20 Aug 2021 01:49:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210820014903epoutp01b0d31f03fe6d9ac4e989bdbe0c6ba068~c4KA6B9SV1829618296epoutp01_
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1629424144;
        bh=66qEicnIYMhO8Vbu+61zgiZtEIAgnKSoCVqjxIgW6sw=;
        h=From:To:Cc:Subject:Date:References:From;
        b=a7Am/Q09+H+FiTtg7Kr4QW8zS8pEIBnTlckQOLQgRck6gzTJJGicb8Mt0c1PoqcVm
         TpAXBiRvb2vasdkroAGa3udfFG9aMsB0yvoMDeOKQ+M3QvPUFcbw+fHLOle2BrwQBi
         67tkJs1OHjIjHvkNub3xTe0Nll+Nb7DYHPIhcgRY=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20210820014903epcas5p2e5c058ade7c7e77a10160ad9996e676a~c4KAeumJW1347513475epcas5p2K;
        Fri, 20 Aug 2021 01:49:03 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4GrPgX6yrbz4x9QN; Fri, 20 Aug
        2021 01:48:56 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        AE.58.41701.BF90F116; Fri, 20 Aug 2021 10:48:43 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20210819170304epcas5p211ae01fc6ba6f5beaf7afaa90dcd5dda~cw_wfHsUp1503415034epcas5p2p;
        Thu, 19 Aug 2021 17:03:04 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210819170304epsmtrp2faf230cb549f23c73802a7ebc68b6be0~cw_weIvaM0828208282epsmtrp2x;
        Thu, 19 Aug 2021 17:03:04 +0000 (GMT)
X-AuditID: b6c32a4b-0abff7000001a2e5-6b-611f09fb5a20
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        0E.26.32548.7CE8E116; Fri, 20 Aug 2021 02:03:03 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210819170301epsmtip28419697366e72c3c11e7ad95793f5ddf~cw_uRMeka0714007140epsmtip2j;
        Thu, 19 Aug 2021 17:03:00 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     krzysztof.kozlowski@canonical.com,
        linux-samsung-soc@vger.kernel.org, avri.altman@wdc.com,
        kwmad.kim@samsung.com, dan.carpenter@oracle.com,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH] scsi: ufs: ufs-exynos: Fix static checker warning
Date:   Thu, 19 Aug 2021 22:41:31 +0530
Message-Id: <20210819171131.55912-1-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEKsWRmVeSWpSXmKPExsWy7bCmhu5vTvlEg0XvBC0ezNvGZvHy51U2
        i9f/prNYbHz7g8ni5pajLBYzzu9jsui+voPNYvnxf0wOHB6zGnrZPD4+vcXi0bdlFaPH501y
        Hu0HupkCWKOybTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTd
        MnOAblFSKEvMKQUKBSQWFyvp29kU5ZeWpCpk5BeX2CqlFqTkFJgU6BUn5haX5qXr5aWWWBka
        GBiZAhUmZGccWr6JueALf8WNz+3MDYyTebsYOTkkBEwkvnXsYupi5OIQEtjNKHH0/Q12kISQ
        wCdGiauvmSDsz4wST9vLuhg5wBomXUmBCO9ilDi5NACit4VJovHbNkaQBJuAtsTd6VvAekUE
        rCR+rfzMDGIzC+xklFj+Qh1kjrCAk8Sk5dEgYRYBVYndc/+wgti8AjYSqy/8Zoe4TV5i9YYD
        zBD2NnaJW+3JELaLxKmrD1ggbGGJV8e3QNVLSXx+t5cN4sxsiZ5dxhDhGoml845BldtLHLgy
        hwWkhFlAU2L9Ln2IsKzE1FPrmCCO5JPo/f2ECSLOK7FjHoytKtH87irUGGmJid3drBC2h8Sr
        +X+ZISESK/Hz51rWCYyysxA2LGBkXMUomVpQnJueWmxaYJyXWg6PouT83E2M4MSl5b2D8dGD
        D3qHGJk4GA8xSnAwK4nwHvsjmyjEm5JYWZValB9fVJqTWnyI0RQYYhOZpUST84GpM68k3tDE
        0sDEzMzMxNLYzFBJnFf3lUyikEB6YklqdmpqQWoRTB8TB6dUA1Pdf9fD3QyPb33PqfBr0Xv4
        rDVNS1thU9HmY3f+fK3UmmG0MS71yXqPsDkcvOJh+/QkH14+tMhg7f3tTOk602Mn87auqYxl
        2LrJ9J9clfGJeUxXLyhwGOvfPaInn87gpLqLue7fL6+a5L4rphHvp91gVH5tyXukJ7bg3buS
        8L/cC7qn69iaBjE+LEhsfL8x7UKvwkVl65ATubsWMGysr+hfsvfej623JO+EdunqL/PUlI/3
        cHisujHX8WL8g1XLnd9JSwqoH+F6UzpRxO68elpwN/+O5Y80n6yasP2QaOFS6Xjrje/2u8xM
        bhLc8lD3g3O4nvuz9o9Rm89OTUhTY7D4c13eqM9pmXNk02vLx0osxRmJhlrMRcWJAHEySbDl
        AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmluLIzCtJLcpLzFFi42LZdlhJXvd4n1yiwc5NFhYP5m1js3j58yqb
        xet/01ksNr79wWRxc8tRFosZ5/cxWXRf38Fmsfz4PyYHDo9ZDb1sHh+f3mLx6NuyitHj8yY5
        j/YD3UwBrFFcNimpOZllqUX6dglcGYeWb2Iu+MJfceNzO3MD42TeLkYODgkBE4lJV1K6GLk4
        hAR2MEr8X7+VuYuREyguLXF94wR2CFtYYuW/5+wQRU1MEo+nLGIFSbAJaEvcnb6FCcQWEbCR
        OPp1IitIEbPAfkaJjr9TmUA2CAs4SUxaHg1SwyKgKrF77h+wXl6g+tUXfkMtkJdYveEA8wRG
        ngWMDKsYJVMLinPTc4sNC4zyUsv1ihNzi0vz0vWS83M3MYLDSUtrB+OeVR/0DjEycTAeYpTg
        YFYS4T32RzZRiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+FrpPxQgLpiSWp2ampBalFMFkmDk6p
        Biadp8yub4XYr85zLzRjPzc1O5zBhEWPoag7MH2uSmzDIieGCuGcDI+oU5s+sG78GhHzWoGD
        UdnZ3b/3pMSHhTsyJCJyOmXXsLFL1KYBfTT15UQmXS9pe8eNTWcCXvyRm8LNvd3p978/Uo2N
        +T9zXVnntcm1bvK3ufFtTvqu1port7P3s55qTTRh/znBSPH2wl8NQg9/depOk9n/3st5e6Sy
        lKb3K4uUo8yeCyS2Ttlh0L+8UvPsxuQ2tSyDP8b77jhLHDtTJq316+2DCPs3Z7W/S4hFcd0N
        aTqpHZmof2au/9aIUNOCD3It64NidJ4r6i/ZUBn43fn2xJMbGV8rvFEJnLWmasHBU6rLF2oo
        sRRnJBpqMRcVJwIANeCg+pYCAAA=
X-CMS-MailID: 20210819170304epcas5p211ae01fc6ba6f5beaf7afaa90dcd5dda
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210819170304epcas5p211ae01fc6ba6f5beaf7afaa90dcd5dda
References: <CGME20210819170304epcas5p211ae01fc6ba6f5beaf7afaa90dcd5dda@epcas5p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

clk_get_rate() returns unsigned long and currently this driver
stores the return value in u32 type, resulting the below warning:

Fixed smatch warnings:

        drivers/scsi/ufs/ufs-exynos.c:286 exynos_ufs_get_clk_info()
        warn: wrong type for 'ufs->mclk_rate' (should be 'ulong')

        drivers/scsi/ufs/ufs-exynos.c:287 exynos_ufs_get_clk_info()
        warn: wrong type for 'pclk_rate' (should be 'ulong')

Fixes: 55f4b1f73631: "scsi: ufs: ufs-exynos: Add UFS host support for Exynos SoCs"
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 4 ++--
 drivers/scsi/ufs/ufs-exynos.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index cf46d6f86e0e..427a2ff7e9da 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -260,7 +260,7 @@ static int exynos_ufs_get_clk_info(struct exynos_ufs *ufs)
 	struct ufs_hba *hba = ufs->hba;
 	struct list_head *head = &hba->clk_list_head;
 	struct ufs_clk_info *clki;
-	u32 pclk_rate;
+	unsigned long pclk_rate;
 	u32 f_min, f_max;
 	u8 div = 0;
 	int ret = 0;
@@ -299,7 +299,7 @@ static int exynos_ufs_get_clk_info(struct exynos_ufs *ufs)
 	}
 
 	if (unlikely(pclk_rate < f_min || pclk_rate > f_max)) {
-		dev_err(hba->dev, "not available pclk range %d\n", pclk_rate);
+		dev_err(hba->dev, "not available pclk range %lu\n", pclk_rate);
 		ret = -EINVAL;
 		goto out;
 	}
diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
index 67505fe32ebf..dadf4fd10dd8 100644
--- a/drivers/scsi/ufs/ufs-exynos.h
+++ b/drivers/scsi/ufs/ufs-exynos.h
@@ -184,7 +184,7 @@ struct exynos_ufs {
 	u32 pclk_div;
 	u32 pclk_avail_min;
 	u32 pclk_avail_max;
-	u32 mclk_rate;
+	unsigned long mclk_rate;
 	int avail_ln_rx;
 	int avail_ln_tx;
 	int rx_sel_idx;

base-commit: 36a21d51725af2ce0700c6ebcb6b9594aac658a6
-- 
2.17.1

