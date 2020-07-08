Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85473C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 01:52:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 661A020774
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 01:52:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="XiE7knXD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728988AbgGHBwx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 21:52:53 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:41083 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728740AbgGHBww (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2020 21:52:52 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200708015250epoutp017554d2769c72d98767f9a3aca4fcc206~fpA1MgvCk0820208202epoutp01c
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2020 01:52:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200708015250epoutp017554d2769c72d98767f9a3aca4fcc206~fpA1MgvCk0820208202epoutp01c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594173170;
        bh=rJrK8YWEMIlsXw1bcpuzIBhBH2129E6jXTK3Xevwysc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=XiE7knXDF4eMx9SQC4vRjg3gDZGck6dbk4WtDQRm1S524ztHDnbfv8Vn4EE41p/Cu
         4iwBHyDFWyLOCPaBcLn/+Mbd7QJvyPCDyrVsYH8zZKEXbISwForrrAbxvnlU0fiopR
         ayNnOMZxtJ2//Zx2MBJDUYJhYz8WwMK9KPsNGBsg=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20200708015249epcas2p4d6ee6204e1dc33532e0b66223f9a5e29~fpA0jlw0Q1153411534epcas2p4s;
        Wed,  8 Jul 2020 01:52:49 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.189]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4B1j4G4BsdzMqYlt; Wed,  8 Jul
        2020 01:52:46 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        60.46.19322.EE6250F5; Wed,  8 Jul 2020 10:52:46 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20200708015245epcas2p35585b4ad52f5055ea26df34edd9a6903~fpAxI_iKG3075230752epcas2p3D;
        Wed,  8 Jul 2020 01:52:45 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200708015245epsmtrp2b7edcb4e9c47345de513093e26ec0c39~fpAxIGO0n0240502405epsmtrp2k;
        Wed,  8 Jul 2020 01:52:45 +0000 (GMT)
X-AuditID: b6c32a45-797ff70000004b7a-79-5f0526ee134b
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        9B.B9.08382.DE6250F5; Wed,  8 Jul 2020 10:52:45 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200708015245epsmtip1ced31cb9282b2c4165a9813e971dfc00~fpAw5n22w2521725217epsmtip1m;
        Wed,  8 Jul 2020 01:52:45 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RFC PATCH v4 3/3] ufs: exynos: implement dbg_register_dump
Date:   Wed,  8 Jul 2020 10:44:48 +0900
Message-Id: <f87c67e318746b8f2482d1ca63bf1109d34a8d57.1594097045.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1594097045.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1594097045.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFJsWRmVeSWpSXmKPExsWy7bCmqe47NdZ4gw37JSwezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVnc3HKUxaL7+g42i+XH/zFZ
        dN29wWix9N9bFgc+j8tXvD0u9/UyeUxYdIDR4/v6DjaPj09vsXj0bVnF6PF5k5xH+4FupgCO
        qBybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC7lRTK
        EnNKgUIBicXFSvp2NkX5pSWpChn5xSW2SqkFKTkFhoYFesWJucWleel6yfm5VoYGBkamQJUJ
        ORmdDx6wFyzjqXh+YDpzA+NSri5GDg4JAROJrieyXYxcHEICOxglphzYyA7hfGKUuDL/CjOE
        841R4uDT9UAOJ1jHsnVb2SASexklZizYBOX8YJT4e28CE0gVm4CmxNObU5lAEiICm5kkXi24
        D9bOLKAusWvCCbAiYQEXiferDrKB2CwCqhJ3l21gAzmKVyBa4vQtYYhtchI3z3WCtXIKWEo8
        vzmJDZXNBVQzlUPi0LNzrBANLhKtD24yQtjCEq+Ob2GHsKUkPr/bywZh10vsm9rACtHcwyjx
        dN8/qAZjiVnP2hlBjmAG+mD9Ln1IIClLHLnFAnE+n0TH4b/sEGFeiY42IYhGZYlfkyZDDZGU
        mHnzDtRWD4m/m2cwQcIHaNOZFTuYJjDKz0JYsICRcRWjWGpBcW56arFRgSFy7G1iBCdSLdcd
        jJPfftA7xMjEwXiIUYKDWUmE10CRNV6INyWxsiq1KD++qDQntfgQoykwHCcyS4km5wNTeV5J
        vKGpkZmZgaWphamZkYWSOG+u4oU4IYH0xJLU7NTUgtQimD4mDk6pBib3H9rWWZcWcD+8diLK
        baaw3Lt7stfeaM13Ku5ouS67XDHsUqyRwIapGom7REvX7rOLDtzO8lr0biLfSv+U1jO1G5Wv
        HX1dvuuNcdjJPt5NBkoLdznNUVLsT+qxyZ5/7I1d5KrA8uMVb8t27W4QXviLtZenKO1Mccqh
        f/wXOOfN0nVda/p11z27qhcM3ttm/+1WY/W9fXrvu3vWh7bwsNge/81gLf7X4cevFm9zgVeR
        5pts0+OWuxoeb52qMuWnkvGEi1eOuz8zyd/gENC0/ax2g9YR3VvBTJdOJasteHzi+/P+QvUC
        u9JIieqsaXeZcm76PHyQb9R2Rt+0xzbf453ZhfDk/3YSx7M/OLxq4lZiKc5INNRiLipOBADP
        dlF9LQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsWy7bCSnO5bNdZ4g2Xr1S0ezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVnc3HKUxaL7+g42i+XH/zFZ
        dN29wWix9N9bFgc+j8tXvD0u9/UyeUxYdIDR4/v6DjaPj09vsXj0bVnF6PF5k5xH+4FupgCO
        KC6blNSczLLUIn27BK6MzgcP2AuW8VQ8PzCduYFxKVcXIyeHhICJxLJ1W9m6GLk4hAR2M0os
        OP+KHSIhKXFi53NGCFtY4n7LEVaIom+MEis+vGIFSbAJaEo8vTmVCSQhInCYSeL/1udg3cwC
        6hK7JpxgArGFBVwk3q86yAZiswioStxdtgHI5uDgFYiWOH1LGGKBnMTNc53MIDangKXE85uT
        wMqFBCwkni94wYRLfAKjwAJGhlWMkqkFxbnpucWGBYZ5qeV6xYm5xaV56XrJ+bmbGMGRoKW5
        g3H7qg96hxiZOBgPMUpwMCuJ8BoossYL8aYkVlalFuXHF5XmpBYfYpTmYFES571RuDBOSCA9
        sSQ1OzW1ILUIJsvEwSnVwNRcl7BXPMaEtaLu1uwW+YS0KfPZ98jMMpuXuEF0M1d4orb0dXfF
        bUtMX71dLnl4Y3OIf3U6zyKxw7NW/m3wVjlms7iuqfH1HLbIFX+cNjZ5+iyZ9m3B7X33GiNj
        TUQacnoOvWAu4VT/GmooOCP7mu+hy1pRQm9nqWza/8jpi+a875PfLdye49d+RZRP9ZgCa6TE
        i099R8RK2JWFs4RYDmyxWHe8grv89uX9R6IP7zM4XbTxttWOPJtN19ZJPiwpuyYX/ff/H5EG
        nX5ni9/qpyycPaKuRq7bw3WgwS70pV7db42sWS7KQavcJwT/5lmnIDvJ2kB3e8jXabYzurSn
        Cm1/ba+z6sXK3IwE+acV1kosxRmJhlrMRcWJAB7QO+rzAgAA
X-CMS-MailID: 20200708015245epcas2p35585b4ad52f5055ea26df34edd9a6903
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200708015245epcas2p35585b4ad52f5055ea26df34edd9a6903
References: <cover.1594097045.git.kwmad.kim@samsung.com>
        <CGME20200708015245epcas2p35585b4ad52f5055ea26df34edd9a6903@epcas2p3.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

At present, I just add command history print and
you can add various vendor regions.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 8c60f7d..815c361 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -1246,6 +1246,29 @@ static int exynos_ufs_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	return 0;
 }
 
+static void exynos_ufs_dbg_register_dump(struct ufs_hba *hba)
+{
+	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
+	unsigned long flags;
+
+	spin_lock_irqsave(&ufs->dbg_lock, flags);
+	if (ufs->under_dump == 0)
+		ufs->under_dump = 1;
+	else {
+		spin_unlock_irqrestore(&ufs->dbg_lock, flags);
+		goto out;
+	}
+	spin_unlock_irqrestore(&ufs->dbg_lock, flags);
+
+	exynos_ufs_dump_info(&ufs->handle, hba->dev);
+
+	spin_lock_irqsave(&ufs->dbg_lock, flags);
+	ufs->under_dump = 0;
+	spin_unlock_irqrestore(&ufs->dbg_lock, flags);
+out:
+	return;
+}
+
 static struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.name				= "exynos_ufs",
 	.init				= exynos_ufs_init,
@@ -1258,6 +1281,7 @@ static struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.hibern8_notify			= exynos_ufs_hibern8_notify,
 	.suspend			= exynos_ufs_suspend,
 	.resume				= exynos_ufs_resume,
+	.dbg_register_dump		= exynos_ufs_dbg_register_dump,
 };
 
 static int exynos_ufs_probe(struct platform_device *pdev)
-- 
2.7.4

