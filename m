Return-Path: <SRS0=n0Yx=CO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5C74C43461
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Sep 2020 06:16:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9714120FC3
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Sep 2020 06:16:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Nl48W+nS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbgIEGQF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Sep 2020 02:16:05 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:55125 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbgIEGP6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Sep 2020 02:15:58 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200905061554epoutp01a0d0909a6addc1f966e351e2e60eab10~xzqXTiIBW1816118161epoutp01R
        for <linux-scsi@vger.kernel.org>; Sat,  5 Sep 2020 06:15:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200905061554epoutp01a0d0909a6addc1f966e351e2e60eab10~xzqXTiIBW1816118161epoutp01R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1599286554;
        bh=ozBcYL4GOFetvj3IzQDqG8OkSvnIuF3YAsvBlwvB578=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=Nl48W+nSYQOq9WGw1xnzMOJjvCgVuuddp0cQyI/s+PY7jsFQKxd7bzk9L/LMK1unZ
         Nqfa7IyGsb0/80pvOUPRW9Vq2WaFiRUlL5rrcPqqALHBZXaYTFcRPcg+VDIhzmebGi
         v/iOSvm6ClzQjKw11Si5ilLGfewPJk2ldvco9J1E=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20200905061553epcas2p147abd0cc7db1315a67c5b0b6b0f6ee77~xzqW0JUlQ2988129881epcas2p1O;
        Sat,  5 Sep 2020 06:15:53 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.185]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Bk46b4jBKzMqYkW; Sat,  5 Sep
        2020 06:15:51 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        29.96.27441.71D235F5; Sat,  5 Sep 2020 15:15:51 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20200905061551epcas2p39976167b31a737e4093f0a421c71ee12~xzqUS7y5p1024910249epcas2p3c;
        Sat,  5 Sep 2020 06:15:51 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200905061551epsmtrp2ea486131da8957c7e1d3a7bb6382839a~xzqURkoTC3004930049epsmtrp2K;
        Sat,  5 Sep 2020 06:15:51 +0000 (GMT)
X-AuditID: b6c32a47-fafff70000006b31-1a-5f532d17ebc3
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        8F.EE.08303.61D235F5; Sat,  5 Sep 2020 15:15:50 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200905061550epsmtip11bd0102bbad08d1f9cfd74cd3fcc84b3~xzqUCvbxa1142811428epsmtip1U;
        Sat,  5 Sep 2020 06:15:50 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v4 2/2] ufs: exynos: enable
 UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL
Date:   Sat,  5 Sep 2020 15:06:52 +0900
Message-Id: <cc68be5636791c55c1fc122263b52ad3e92ae251.1599285983.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1599285983.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1599285983.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNJsWRmVeSWpSXmKPExsWy7bCmqa64bnC8wdQ9ihYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCxubjnKYtF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+Ur3h6X+3qZPCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBH
        VI5NRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtDdSgpl
        iTmlQKGAxOJiJX07m6L80pJUhYz84hJbpdSClJwCQ8MCveLE3OLSvHS95PxcK0MDAyNToMqE
        nIwjh28zFizmqLh6ej97A+Mbti5GTg4JAROJ/psnGbsYuTiEBHYwSsxadZsJwvnEKPH20klW
        COczo8Trtq9MMC2zDr9kBbGFBHYBJfZIQxT9YJS4t2A12Fw2AU2Jpzengo0SEdjMJPFqwX1m
        kASzgLrErgknwCYJC4RIvNwzH2wSi4CqxIm58xhBbF6BaImF266zQmyTk7h5rhOsl1PAUuJb
        J8QCBJsLqGYqh8Sue4eYIRpcJLbvb4E6VVji1fEt7BC2lMTnd3uhvq6X2De1gRWiuYdR4um+
        f4wQCWOJWc/agWwOoEs1Jdbv0gcxJQSUJY7cYoG4n0+i4/Bfdogwr0RHmxBEo7LEr0mToYZI
        Ssy8eQdqq4fE3Pnt0FAE2rRj0Ry2CYzysxAWLGBkXMUollpQnJueWmxUYIwcfZsYwalUy30H
        44y3H/QOMTJxMB5ilOBgVhLh9TgXGC/Em5JYWZValB9fVJqTWnyI0RQYkBOZpUST84HJPK8k
        3tDUyMzMwNLUwtTMyEJJnLfY6kKckEB6YklqdmpqQWoRTB8TB6dUA5OM0UqR3Vwi+vuj9v/u
        PfNjkvJZPT2VV9/c9mxmk9L1mNr6Mbdgb2GstkVXufyXmu4LDJe61nx7+7CFl3Gt6kTPyK/M
        9Sm7Fqxeukdvsteh5u+q4r2Rj1t/lHsubN//c5KetALfEuPj7xW11IWO3trLa7lvVUH2Ymmx
        Ouag/REMEVVtPtPrd/B9sfCuPO/R0/77wYP1IeYfDf+dXHlQoe/eG998C6PjnmpfTL6et1OL
        fLfRed/Txb8sFii8u8Ly9fGWC9HblIV3nU73rNjPLmTPwySn9qjNxif6zOrvvbpmdkKX5uwt
        UEncpP7nXMK1Yz3nT7OHHDdv/POTXWxOad6RdXJSguY21Z8n7Jy80FiJpTgj0VCLuag4EQDC
        +YWRLgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsWy7bCSnK6YbnC8wcpjVhYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCxubjnKYtF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+Ur3h6X+3qZPCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBH
        FJdNSmpOZllqkb5dAlfGkcO3GQsWc1RcPb2fvYHxDVsXIyeHhICJxKzDL1m7GLk4hAR2MErM
        uvsOKiEpcWLnc0YIW1jifssRqKJvjBK98/+xgCTYBDQlnt6cygSSEBE4zCTxf+tzdpAEs4C6
        xK4JJ5hAbGGBIIk9XR/BprIIqEqcmDsPbCqvQLTEwm3XWSE2yEncPNfJDGJzClhKfOtcDVTP
        AbTNQuLjE1UcwhMYBRYwMqxilEwtKM5Nzy02LDDKSy3XK07MLS7NS9dLzs/dxAiOAy2tHYx7
        Vn3QO8TIxMF4iFGCg1lJhNfjXGC8EG9KYmVValF+fFFpTmrxIUZpDhYlcd6vsxbGCQmkJ5ak
        ZqemFqQWwWSZODilGpgWn/Gr2xh4X076u2XgnMKKu++Nypc0Rs+a07p+5zqOiwd0nnPFHmpM
        M+aye/h6Rvv8eFaZ7KfvmCs8X1xa9a3VjCsqe/u7Hb1+bHI/w3b4n/X6/PS3g7iFf8zrBcIy
        DEZV/rxvn1R6hn9asbS8R/LuhFVNybtfnNk5+8Vp0w0iJQ5LHmm1BG1+4t/lOjNMVcHUcdrD
        n04uU144visp4crJnc5u9lj622PBdZ3zjG4tb5yzcPqOyfpXfYODw9c8+Hx9o8jEmIALHYde
        cx14Ftg4c3tKZPHh+QnZsz2mtLGLCLbeehau0rzqjYViQG2C5MFWfgUbsxlcvu/jzHhdv3JM
        3dzVdP7not7dIjMOuFxXYinOSDTUYi4qTgQAhiGBH/ICAAA=
X-CMS-MailID: 20200905061551epcas2p39976167b31a737e4093f0a421c71ee12
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200905061551epcas2p39976167b31a737e4093f0a421c71ee12
References: <cover.1599285983.git.kwmad.kim@samsung.com>
        <CGME20200905061551epcas2p39976167b31a737e4093f0a421c71ee12@epcas2p3.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For Exynos, only flush during hibern8 is enough for
sustaining performance and I think that there is
a possiblity of raising current thanks to an increase
of internal operations for manual flush.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 7d383e3..4584f5d 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -1290,7 +1290,8 @@ struct exynos_ufs_drv_data exynos_ufs_drvs = {
 				  UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR |
 				  UFSHCI_QUIRK_BROKEN_HCE |
 				  UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR |
-				  UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR,
+				  UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR |
+				  UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL,
 	.opts			= EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL |
 				  EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL |
 				  EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX |
-- 
2.7.4

