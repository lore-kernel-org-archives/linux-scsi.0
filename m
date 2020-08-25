Return-Path: <SRS0=BOoC=CD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB49CC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Aug 2020 01:52:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB31320706
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Aug 2020 01:52:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="sreqcpWg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbgHYBwS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Aug 2020 21:52:18 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:19550 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgHYBwO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Aug 2020 21:52:14 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200825015210epoutp04b702f8f8ca45832c2f3d5fcf30faafd3~uX99JsG-31078810788epoutp044
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2020 01:52:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200825015210epoutp04b702f8f8ca45832c2f3d5fcf30faafd3~uX99JsG-31078810788epoutp044
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1598320330;
        bh=VZEVkI6KA+51xe2B6bHDs8bj3l3LVoS2jIR6eato8Rs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=sreqcpWgX/IbLnHiVtKEBiZn9d4nacwMD5R0jNaSnuanGe8ywcgQEoBKnozY1XbFY
         QcThYj/r0atocdLxEj0kwPP5gUl8H3DRUMKnVGmasMsNTczQcgdYdDSWFZJ9IEKJ0C
         SFZWuKzNXziat95bYoeZK8bHOhaHuR0hMBV9f9G0=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20200825015209epcas2p1eec8738ea7b9e476ebf5acd8db7cc581~uX98VIeyC3016330163epcas2p1q;
        Tue, 25 Aug 2020 01:52:09 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.182]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4BbBnK6jFCzMqYkV; Tue, 25 Aug
        2020 01:52:05 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        35.9B.19322.4CE644F5; Tue, 25 Aug 2020 10:52:04 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20200825015203epcas2p2dd85feeebcd455e2eecf53a7f077760a~uX93H-P8o0267902679epcas2p26;
        Tue, 25 Aug 2020 01:52:03 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200825015203epsmtrp2d2a0258256025df353bd6d65c18f8f2e~uX93HK2ID2482424824epsmtrp2d;
        Tue, 25 Aug 2020 01:52:03 +0000 (GMT)
X-AuditID: b6c32a45-7adff70000004b7a-20-5f446ec4d4a3
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A5.0B.08382.3CE644F5; Tue, 25 Aug 2020 10:52:03 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200825015203epsmtip2b7f7e27d2f9501a3eaf971c12090a0a7~uX92w-Xxv2237122371epsmtip2i;
        Tue, 25 Aug 2020 01:52:03 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v3 2/2] ufs: exynos: enable
 UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL
Date:   Tue, 25 Aug 2020 10:43:16 +0900
Message-Id: <ef94af8f273316d50d7f50a0cac9c7be9b9316a1.1598319701.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1598319701.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1598319701.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJJsWRmVeSWpSXmKPExsWy7bCmme6RPJd4g89PZCwezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVnc3HKUxaL7+g42i+XH/zFZ
        dN29wWix9N9bFgc+j8tXvD0u9/UyeUxYdIDR4/v6DjaPj09vsXj0bVnF6PF5k5xH+4FupgCO
        qBybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC7lRTK
        EnNKgUIBicXFSvp2NkX5pSWpChn5xSW2SqkFKTkFhoYFesWJucWleel6yfm5VoYGBkamQJUJ
        ORl3HkYVLOao+DvlEVsD4xu2LkYODgkBE4lv0727GLk4hAR2MEq07vrLBOF8YpSY9+c7C4Tz
        jVFiyvZDjF2MnGAd3X9/QiX2Mko0vf3BDOH8YJR4NvcGE0gVm4CmxNObU8FmiQhsZpJ4teA+
        M0iCWUBdYteEE2BFwgIhErvm/AezWQRUJS6f2AK2glcgWmJW0xQWiHVyEjfPdYL1cgpYSnzb
        uJcVlc0FVDOVQ2Lq9t+sEB+5SEz4qADRKyzx6vgWdghbSuLzu71sEHa9xL6pDVC9PYwST/f9
        g/rNWGLWs3ZGkDnMQB+s36UPMVJZ4sgtFojz+SQ6Dv9lhwjzSnS0CUE0Kkv8mjQZaoikxMyb
        d6C2ekjs27gUGj5Am56/bmKewCg/C2HBAkbGVYxiqQXFuempxUYFhsiRt4kRnEa1XHcwTn77
        Qe8QIxMH4yFGCQ5mJRFewYvO8UK8KYmVValF+fFFpTmpxYcYTYHhOJFZSjQ5H5jI80riDU2N
        zMwMLE0tTM2MLJTEeXMVL8QJCaQnlqRmp6YWpBbB9DFxcEo1MPk+//omV9SnRtKYpXPXzMWH
        mGdO63jt+eRFcdqJvx8fhOx64SWzcn/w6Y2Prr8OviFybz733MKnxgsU7R6ca+oOjzw3Ke7i
        wrrg2IuF38RVO5+pC9ckS0b9kBbefVo96+r+q1bfG9SDhFbOaVr+p3rbopb1kZZqzOd/WvxY
        1GGV0/dpTvSBX1f35uXbT/pXZ1Hm22Ngs+ZiaL5qVN6RrW+6zd7uUpPYL7/4Rbb4Cs5VUbYR
        FizTor4ceZtmf3z5mlWqklvXdjlEbrflYFHU8827lb1VbeqUuy9qLE492mQhz3KJ53f16b12
        03s+P7n3Ie6kykHWdMfzb+f/l7VWqFtTtD+E9yfHn71/l7Zd+zRJiaU4I9FQi7moOBEA9rDU
        OiwEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsWy7bCSvO7hPJd4g5Z3WhYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCxubjnKYtF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+Ur3h6X+3qZPCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBH
        FJdNSmpOZllqkb5dAlfGnYdRBYs5Kv5OecTWwPiGrYuRk0NCwESi++9Pli5GLg4hgd2MEtfv
        tzNCJCQlTux8DmULS9xvOcIKUfSNUWLdg9nMIAk2AU2JpzenMoEkRAQOM0n83/qcHSTBLKAu
        sWvCCSYQW1ggSOL2lTYWEJtFQFXi8oktYFN5BaIlZjVNYYHYICdx81wn2FBOAUuJbxv3Am3j
        ANpmIfGyiReH8ARGgQWMDKsYJVMLinPTc4sNCwzzUsv1ihNzi0vz0vWS83M3MYKjQEtzB+P2
        VR/0DjEycTAeYpTgYFYS4RW86BwvxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdG4cI4IYH0xJLU
        7NTUgtQimCwTB6dUAxOTd4vFxlkvb6tXaCamzZ93fb7kmnhxmbqzs198ev7HYUeriWPllG8O
        jyY8KD1r6Lq7V9Zu7o92uagZ3hYvFZq3arGt/bjK5ZLf/OqSQ9NZmkJW3rTZWiFgJuUZxP3S
        UXNXPVODa29Gzy4/Vs0dT+JW1bye2jZR64VdjZW3371N5lXf3Nee4niqM13O03wCk+iCzQ+0
        iv8ec2wNKTt64Lr0a9YXc/f+mS0v3i2w6o7GPkmn+XxLbcMs51e5nf3/bOvMlGgPqcPR6pkP
        /pxU/39iV6mk7ZR/9lNrDdof/uMw+6+1Zc6TU1M2OmrwP5m1o+yFm9Imx/dHvm92OO/PXL3i
        3/KV/dcWPeB8aX3utE6BEktxRqKhFnNRcSIAlD/fH/ECAAA=
X-CMS-MailID: 20200825015203epcas2p2dd85feeebcd455e2eecf53a7f077760a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200825015203epcas2p2dd85feeebcd455e2eecf53a7f077760a
References: <cover.1598319701.git.kwmad.kim@samsung.com>
        <CGME20200825015203epcas2p2dd85feeebcd455e2eecf53a7f077760a@epcas2p2.samsung.com>
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
index 3c0a50b..defbcc2 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -1289,7 +1289,8 @@ struct exynos_ufs_drv_data exynos_ufs_drvs = {
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

