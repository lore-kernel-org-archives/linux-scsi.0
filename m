Return-Path: <SRS0=xqUt=CC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 673E1C433E4
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 02:38:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48D4F206F7
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 02:38:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="PYjwjhF9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbgHXCiY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Aug 2020 22:38:24 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:49535 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727942AbgHXCiU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Aug 2020 22:38:20 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200824023818epoutp01aee109ead924924a399c3fde3f6f3c75~uE88lJjdr1009510095epoutp01u
        for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2020 02:38:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200824023818epoutp01aee109ead924924a399c3fde3f6f3c75~uE88lJjdr1009510095epoutp01u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1598236698;
        bh=rdQCFpaDIijB55N8c7lwlO0mBjw1eDFr/RCQmqqQch8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=PYjwjhF9P7lDnbQUODJlOz8KhRlHa1yXIyoWya3D3JouYnTHdH1V3+DOMO9rgpCr5
         TJLAW6BMb2yuLAEoNUvHz07UR3oBwBnX/iiJzVMIPKpI56BpB+AA/hf05rRBlAJ3ZR
         7E5fs2EG4A/U2zVVpMzHbwNRsohHppQe9bXK2byA=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20200824023817epcas2p12203b0ac22ee8123140c26e149e8b124~uE87-DWtw3024430244epcas2p1u;
        Mon, 24 Aug 2020 02:38:17 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.188]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4BZbs33SvWzMqYkh; Mon, 24 Aug
        2020 02:38:15 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        EB.D8.18874.618234F5; Mon, 24 Aug 2020 11:38:14 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20200824023813epcas2p1ff02473d05b0c69815f779d350fb8d0b~uE84cWVI83024430244epcas2p1Z;
        Mon, 24 Aug 2020 02:38:13 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200824023813epsmtrp15e96606541516b06d7bd75475ccb8382~uE84berJR1622416224epsmtrp1Q;
        Mon, 24 Aug 2020 02:38:13 +0000 (GMT)
X-AuditID: b6c32a46-519ff700000049ba-51-5f4328164198
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        B2.27.08303.518234F5; Mon, 24 Aug 2020 11:38:13 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200824023813epsmtip23580afc5da8ace1d0493e019998d296f~uE84I836f0110901109epsmtip2U;
        Mon, 24 Aug 2020 02:38:13 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v2 2/2] ufs: exynos: enable
 UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL
Date:   Mon, 24 Aug 2020 11:29:27 +0900
Message-Id: <93dc4a17520b92b1f990bd7d82523435f8ed6dd3.1598236010.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1598236010.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1598236010.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBJsWRmVeSWpSXmKPExsWy7bCmma6YhnO8wYTNrBYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCxubjnKYtF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+Ur3h6X+3qZPCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBH
        VI5NRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtDdSgpl
        iTmlQKGAxOJiJX07m6L80pJUhYz84hJbpdSClJwCQ8MCveLE3OLSvHS95PxcK0MDAyNToMqE
        nIyFn5YxFXxmr9j+cAJTA+NBti5GTg4JAROJvmWXGUFsIYEdjBKfrqh1MXIB2Z8YJX5/2sgM
        kfjMKHGgK6uLkQOs4deBQoiaXYwS99d9Z4dwfjBKvGs7zgLSwCagKfH05lQmkISIwGYmiVcL
        7oNNYhZQl9g14QQTiC0sECLxoOEBM8hUFgFViQVrNUDCvALREqtXrGWBuE5O4ua5TrBWTgFL
        ic+bJ7OhsrmAamZySHQs+Qb1jovE1MWboZqFJV4d38IOYUtJvOxvg7LrJfZNbWCFaO5hlHi6
        7x8jRMJYYtazdkaQg5iBPli/Sx/iY2WJI7dYIM7nk+g4/JcdIswr0dEmBNGoLPFr0mSoIZIS
        M2/egdrkIdH7ai4rJHyANl19uot5AqP8LIQFCxgZVzGKpRYU56anFhsVGCHH3SZGcBLVctvB
        OOXtB71DjEwcjIcYJTiYlUR4b2+yjxfiTUmsrEotyo8vKs1JLT7EaAoMx4nMUqLJ+cA0nlcS
        b2hqZGZmYGlqYWpmZKEkzluveCFOSCA9sSQ1OzW1ILUIpo+Jg1OqgWnnnYgnXufY7Lsr6h2n
        l8Wmm58x5PDpbylnN523S2XbwXaWa2/2RzAppM/z9/qdvvyRk9vVg4dyDzz9U79i7ROG2s6g
        eWGPDlRtmfrv2eXVQtanOWdPkZr2O5T78K34s3X7+XfPdVt2WvcJyyWOKJ9tCkvWC3T3TAmb
        lx/oLf9ANE9aKGL/gWLJ3kePzVnt9t8+d6OdxbNZ71THzxuhXMcS3md/Utn9bbnHMr1vdxRf
        MoeIzJtcczMpq5vdIKf6UWyiy/3a2/eEV0sd3Dp9wgQX5ZiXMppzP196fu2OVF8Fx8rPWQ+f
        tv9aEpG6VKbU5sbxJawn3k9Zo+DRNeuWlPTzJ0ZCp7deNvgkemj7qspYJZbijERDLeai4kQA
        7Q5rYisEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsWy7bCSvK6ohnO8weeXihYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCxubjnKYtF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+Ur3h6X+3qZPCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBH
        FJdNSmpOZllqkb5dAlfGwk/LmAo+s1dsfziBqYHxIFsXIweHhICJxK8DhV2MXBxCAjsYJRbN
        uMLexcgJFJeUOLHzOSOELSxxv+UIK0TRN0aJuz8fsYEk2AQ0JZ7enMoEkhAROMwk8X/rc7Bu
        ZgF1iV0TTjCB2MICQRJXj7SygmxjEVCVWLBWAyTMKxAtsXrFWhaIBXISN891MoPYnAKWEp83
        TwY7TkjAQmLvKmscwhMYBRYwMqxilEwtKM5Nzy02LDDKSy3XK07MLS7NS9dLzs/dxAiOAS2t
        HYx7Vn3QO8TIxMF4iFGCg1lJhPf2Jvt4Id6UxMqq1KL8+KLSnNTiQ4zSHCxK4rxfZy2MExJI
        TyxJzU5NLUgtgskycXBKNTBdSHhUoZ0n3FOkfzVA2sy3fM07XqPr27iOHPhjvu4OGydDYa67
        bE/WtyN72Wc0ya0P5GPMLfyx4/eqc9GRjoIflphnHlCy9s8oqd28d/7zj2o24QayL456rvr5
        63yFAhu7qOODXTt4J4h6PRPewFX9Wtfk9tKMmatTBdgViq9HrGt1/8LCUXg07i3/s0WPN3w4
        Gmi1TLlm28LyEwyzVnZMq5x4cu8lS6XbjVz7HU8tCb1h5xl+ympugcxr/fcLpMwM7u67Y3u4
        8tGMSVFHXh3cICrXxruT68XSr2e3N4VJqjgsO1KZNM3Gb8WpTZ4VT3ZP6FY23VnLcFzFwetQ
        jH/N6ftfD/yzqrWr5dxWbBeoxFKckWioxVxUnAgAO0zWePACAAA=
X-CMS-MailID: 20200824023813epcas2p1ff02473d05b0c69815f779d350fb8d0b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200824023813epcas2p1ff02473d05b0c69815f779d350fb8d0b
References: <cover.1598236010.git.kwmad.kim@samsung.com>
        <CGME20200824023813epcas2p1ff02473d05b0c69815f779d350fb8d0b@epcas2p1.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For Exynos, only flush during hibern8 is enough for
sustaining performance and I think that there is
a possiblity of raising current thanks to an increase
of internal operations for manual flush.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
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

