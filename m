Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 836C9C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 03:49:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 520102245C
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 03:49:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728738AbhASDs1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 22:48:27 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:48267 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728725AbhASDp5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 22:45:57 -0500
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210119034508epoutp033922a461299b9a35d03d8c1c4cf95c55~bhVjfMg1H2549825498epoutp03r
        for <linux-scsi@vger.kernel.org>; Tue, 19 Jan 2021 03:45:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210119034508epoutp033922a461299b9a35d03d8c1c4cf95c55~bhVjfMg1H2549825498epoutp03r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611027908;
        bh=IUvNu4dNPyTjKtls0lrz2Urf0qov0F2gqycSUqGOIkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=YqbprX8N1P3msUo12KblDdXM8aYTEHhblsPPhHn+0gj8tkfEiW806T8m8SRB7r+Jm
         tGNsmSTUmMbi+xRRuQcqvCoZnHWvQDrs5hgMFcNr1xMqZDtlzBHb6L3JO2lkcYq7Ct
         fEVmtPDZp7JUW8jIOHsvwkw9zmdkt1TyJbgCIKXQ=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210119034507epcas2p3cc01858b045148ceb1d90fa30d90d717~bhVix0SAY0516005160epcas2p3Q;
        Tue, 19 Jan 2021 03:45:07 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.183]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4DKZKt0v0Nz4x9QH; Tue, 19 Jan
        2021 03:45:06 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        04.F9.56312.0C556006; Tue, 19 Jan 2021 12:45:04 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210119034504epcas2p478f76a8f9cb0cbecff219a2098cb2eaf~bhVfvQgXD3241732417epcas2p4u;
        Tue, 19 Jan 2021 03:45:04 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210119034504epsmtrp1178b8c50594df5ab622f7f8ae85d92d7~bhVfuMWig1244212442epsmtrp1f;
        Tue, 19 Jan 2021 03:45:04 +0000 (GMT)
X-AuditID: b6c32a46-777d6a800000dbf8-93-600655c02b03
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        50.8E.13470.0C556006; Tue, 19 Jan 2021 12:45:04 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210119034504epsmtip1462125dad2440652919c0a7ce49f08bc~bhVffXeWY2314823148epsmtip1Z;
        Tue, 19 Jan 2021 03:45:04 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RESEND PATCH -6 2/2] ufs: ufs-exynos: use
 UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE
Date:   Tue, 19 Jan 2021 12:33:42 +0900
Message-Id: <80d7e27d6ec537e650a6bd74897b6c60618efcdc.1611026909.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1611026909.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1611026909.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPJsWRmVeSWpSXmKPExsWy7bCmqe6BULYEg13XjSwezNvGZrG37QS7
        xcufV9ksDj7sZLH4uvQZq8W0Dz+ZLT6tX8Zq8evvenaL1YsfsFgsurGNyeLmlqMsFt3Xd7BZ
        LD/+j8mi6+4NRoul/96yOPB7XL7i7XG5r5fJY8KiA4we39d3sHl8fHqLxaNvyypGj8+b5Dza
        D3QzBXBE5dhkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXm
        AB2vpFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwNCzQK07MLS7NS9dLzs+1MjQw
        MDIFqkzIyZh5+DNbwTL2ipUHJrA1MDaxdTFyckgImEhc3dgNZHNxCAnsYJR4+HIbM0hCSOAT
        o8TmB64QiW+MEk+//WWG6Tjw8QwTRGIvo0TLjzdQ7T8YJRbtP8YCUsUmoCnx9OZUsCoRgTNM
        Etdaz7KCJJgF1CV2TTjBBGILC0RJTD61DcxmEVCV2DDvDJjNKxAtsfnDG3aIdXISN891gq3m
        FLCUmNmxhwmVzQVUM5dD4lvPTCaIBheJ9e+PQtnCEq+Ob4EaJCXxsr8Nyq6X2De1gRWiuQfo
        uX3/GCESxhKznrUD2RxAl2pKrN+lD2JKCChLHLnFAnE/n0TH4b/sEGFeiY42IYhGZYlfkyZD
        DZGUmHnzDlSJh8TJa6KQ8AFadP/rYdYJjPKzEOYvYGRcxSiWWlCcm55abFRghBx7mxjBKVXL
        bQfjlLcf9A4xMnEwHmKU4GBWEuEtXceUIMSbklhZlVqUH19UmpNafIjRFBiOE5mlRJPzgUk9
        ryTe0NTIzMzA0tTC1MzIQkmct9jgQbyQQHpiSWp2ampBahFMHxMHp1QDk2Eru+oTjqu21876
        LloTIRx00vYvW9pqKcXHpUxK/x6aufrzGn44nXdrVunX0z1xgZUuCZnu0uyT4meLM0hdnHS7
        xrI3XUzqv+78CTyHJ/676ZB/pKw1xrhG1cPY5EAbt8omqfb0l7YZyvcPvQisZop47b+npvHb
        bMsNiSsqa/4u2HWo/ULWlitMsbdyGaKDyiUV37R28syILxXMN+F9K2BgF1R1/GFP8w4bI6cl
        kY9WWT1ofHmt65ZnzLWvRQZMBU9934SENIev86/d/tSQtTfAe592r5rO6vY1x/hs9jtuFbjM
        aLzQWn6Od+TCvOTQisQVD9Z4Zj37VqqV9N893TnYpCtvU0wu863IG0osxRmJhlrMRcWJAJQV
        +nQyBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsWy7bCSnO6BULYEg0/bRSwezNvGZrG37QS7
        xcufV9ksDj7sZLH4uvQZq8W0Dz+ZLT6tX8Zq8evvenaL1YsfsFgsurGNyeLmlqMsFt3Xd7BZ
        LD/+j8mi6+4NRoul/96yOPB7XL7i7XG5r5fJY8KiA4we39d3sHl8fHqLxaNvyypGj8+b5Dza
        D3QzBXBEcdmkpOZklqUW6dslcGXMPPyZrWAZe8XKAxPYGhib2LoYOTkkBEwkDnw8w9TFyMUh
        JLCbUWL66vtQCUmJEzufM0LYwhL3W46wQhR9Y5R4cX4DO0iCTUBT4unNqWDdIgL3mCQuTZjL
        DJJgFlCX2DXhBBOILSwQIfGh/yeYzSKgKrFh3hkwm1cgWmLzhzfsEBvkJG6e6wTr5RSwlJjZ
        sQesRkjAQmLhzp8suMQnMAosYGRYxSiZWlCcm55bbFhgmJdarlecmFtcmpeul5yfu4kRHBVa
        mjsYt6/6oHeIkYmD8RCjBAezkghv6TqmBCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8F7pOxgsJ
        pCeWpGanphakFsFkmTg4pRqY1r+UujTxW+DsEzFtLvzz3c4eu/5Yf+tdhsy5cvdTd4V/Xf03
        54TLiaV3Gm7bC8mLy+3fPGe/3c5NzVkLN+z8YTf5ww3O6Wwrnio+fZ3wR/u5t+l368kf4r6f
        Oat5ePWkclY7l0VKjbHWybF1HctjfcXaJzAtndr33HXK9B1NAcdO2iSuK+Qwq5v8LizQ4+Oi
        S2cVPnNdPPni8f6WGG63j7tYln44fbmxcJ56zdrdk/feMnY9vPnwgxPZ6XkHcmcpz12wxyfg
        oz8H56bpU6eff3VU7qzZs5fv5QriFBuvW86+95I/c98OjtM1q6bLaD/997td+2vJjN6NfNui
        D8/5FPhIN0F6V4ZO9k83H3EFUV8WJZbijERDLeai4kQAr/a2N/kCAAA=
X-CMS-MailID: 20210119034504epcas2p478f76a8f9cb0cbecff219a2098cb2eaf
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210119034504epcas2p478f76a8f9cb0cbecff219a2098cb2eaf
References: <cover.1611026909.git.kwmad.kim@samsung.com>
        <CGME20210119034504epcas2p478f76a8f9cb0cbecff219a2098cb2eaf@epcas2p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Exynos needs alignment with page size because it isn't capable
to transfer data in one DATA IN to seversal areas.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index a8770ff..d1f0031 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -1236,7 +1236,8 @@ struct exynos_ufs_drv_data exynos_ufs_drvs = {
 				  UFSHCI_QUIRK_BROKEN_HCE |
 				  UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR |
 				  UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR |
-				  UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL,
+				  UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL |
+				  UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE,
 	.opts			= EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL |
 				  EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL |
 				  EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX |
-- 
2.7.4

