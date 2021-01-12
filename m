Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C85FC433E9
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 02:58:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0039C22D5B
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 02:58:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733170AbhALC6A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 21:58:00 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:43153 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731674AbhALC6A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2021 21:58:00 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210112025715epoutp04a7b2b792f3e2b4496600f1b028ab65cd~ZXKvzdG5a2941229412epoutp04c
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jan 2021 02:57:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210112025715epoutp04a7b2b792f3e2b4496600f1b028ab65cd~ZXKvzdG5a2941229412epoutp04c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1610420235;
        bh=lwAQ1PzW0VMl9CBiHdgxELLV18mjj2JnxwNzqNXeoZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=KYqMsPixdrykqrua5G7FhLYi2Fnfjvi/v9zFMKjGLS2wVyLW9K8h/J9xJczqTSYdf
         4BYS1vvsZni+O3F+saHCCp4/tx62Tw77IsuhzNWQBld/uIYlR+MP4XOYWQKni0s4Ea
         ogguNMrp/psCML+gXqmDPN7zY76aRSzdVIxhP9YM=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210112025714epcas2p4dad68975171f0fe96b76fcc02a988218~ZXKu811630196301963epcas2p4E;
        Tue, 12 Jan 2021 02:57:14 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.182]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4DFFbs1Ztcz4x9Q7; Tue, 12 Jan
        2021 02:57:13 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        4A.D9.05262.9001DFF5; Tue, 12 Jan 2021 11:57:13 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210112025712epcas2p4f92af7bd5781df2fcefecca47d55bf8e~ZXKtKWLWr0196501965epcas2p4E;
        Tue, 12 Jan 2021 02:57:12 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210112025712epsmtrp1cfadd1f55dcf0a39d950d1c1dae0f684~ZXKtJbHMv2408724087epsmtrp1G;
        Tue, 12 Jan 2021 02:57:12 +0000 (GMT)
X-AuditID: b6c32a47-b97ff7000000148e-01-5ffd10096975
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        D4.12.08745.8001DFF5; Tue, 12 Jan 2021 11:57:12 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210112025712epsmtip107e7edd5aad3cf96842d31bfeea84649~ZXKs8mZMd1012010120epsmtip1-;
        Tue, 12 Jan 2021 02:57:12 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v5 2/2] ufs: ufs-exynos: set dma_alignment to 4095
Date:   Tue, 12 Jan 2021 11:45:56 +0900
Message-Id: <689878ebbad3e63a96b431df8d843264f8fe57ba.1610419491.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1610419491.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1610419491.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAJsWRmVeSWpSXmKPExsWy7bCmuS6nwN94gxMt7BYP5m1js9jbdoLd
        4uXPq2wWBx92slh8XfqM1WLah5/MFp/WL2O1+PV3PbvF6sUPWCwW3djGZHFzy1EWi+7rO9gs
        lh//x2TRdfcGo8XSf29ZHPg9Ll/x9rjc18vkMWHRAUaP7+s72Dw+Pr3F4tG3ZRWjx+dNch7t
        B7qZAjiicmwyUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJz
        gI5XUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BQYGhboFSfmFpfmpesl5+daGRoY
        GJkCVSbkZPw9eJOxoEWgYuP5JtYGxjbeLkZODgkBE4lbszYzdzFycQgJ7GCU2LH4JTuE84lR
        4tTONqjMZ0aJn03H2GBazq1fxw5iCwnsYpT4uqMGougHo8TBjZMYQRJsApoST29OZQJJiAic
        YZK41nqWFSTBLKAusWvCCSYQW1jASWLmsdfMIDaLgKrEHaipvALREutmrGaF2CYncfNcJ1gN
        p4ClxNGJTayobC6gmpkcEv23H7JDNLhInHgxBapZWOLV8S1QcSmJl/1tUHa9xL6pDVDNPYwS
        T/f9Y4RIGEvMetYOZHMAXaopsX6XPogpIaAsceQWC8T9fBIdh/+yQ4R5JTrahCAalSV+TZoM
        NURSYubNO1CbPCTeb1vECAkgoE2XN7ewTWCUn4WwYAEj4ypGsdSC4tz01GKjAmPk6NvECE6q
        Wu47GGe8/aB3iJGJg/EQowQHs5IIr9eGP/FCvCmJlVWpRfnxRaU5qcWHGE2BATmRWUo0OR+Y
        1vNK4g1NjczMDCxNLUzNjCyUxHmLDR7ECwmkJ5akZqemFqQWwfQxcXBKNTBN+Or4SuMmxyLb
        x2wWMfPtfJSmXuoq+VnCMJVx7+NvGZtKF/zL/K8yM9C4hnFGeN61s7Lubclet09zWE/zSKg7
        dvF4fVqUZmPu5kmPtrxrf6tfEmxWvW3vtO87irhF2Wu4Hb4HRGyJPy8pwZezOMrnBeubtXcN
        tW3PpRl55/WUlx5LqM44FCUslOJqzJcz5cXykzYJXCtTutfLfet2dt90dbfVop3uJk88r355
        8T4ue5/GHJeuTxV7Gv2bxI44/djz7bK58twTjArOM1Wv3NJsWjbXb3JwoEzGrPnTl+7PfPL+
        w2L3qnlRG9eVzOZiEsmslIj3XdMpeoH77+TMHbLzdQyKX73h5rcp/RzZ/1+JpTgj0VCLuag4
        EQC1MHhtMwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsWy7bCSnC6HwN94g10XJS0ezNvGZrG37QS7
        xcufV9ksDj7sZLH4uvQZq8W0Dz+ZLT6tX8Zq8evvenaL1YsfsFgsurGNyeLmlqMsFt3Xd7BZ
        LD/+j8mi6+4NRoul/96yOPB7XL7i7XG5r5fJY8KiA4we39d3sHl8fHqLxaNvyypGj8+b5Dza
        D3QzBXBEcdmkpOZklqUW6dslcGX8PXiTsaBFoGLj+SbWBsY23i5GTg4JAROJc+vXsYPYQgI7
        GCUmLS+HiEtKnNj5nBHCFpa433KEtYuRC6jmG6PEwZcrwBJsApoST29OZQJJiAjcY5K4NGEu
        M0iCWUBdYteEE0wgtrCAk8TMY6/B4iwCqhJ3oLbxCkRLrJuxmhVig5zEzXOdYDWcApYSRyc2
        AcU5gLZZSBzeqYlDeAKjwAJGhlWMkqkFxbnpucWGBUZ5qeV6xYm5xaV56XrJ+bmbGMHxoKW1
        g3HPqg96hxiZOBgPMUpwMCuJ8Hpt+BMvxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdC18l4IYH0
        xJLU7NTUgtQimCwTB6dUA5PPCc7YgOvxKW/qmyRqZe9+XPnjhruom/Pewk+dQYEL3z9zeNyz
        rDJ+b/G891utnzGF2ez5HHbFo3f299PewhvX6nFqKX56VG5/03ShfmsKo+2sg5uvtl06cXPi
        rpnRry1WNObPNJ4jFH3dZp5C44JGiaC+tzOnmZk83LzP0FutRNZWIUDC4frZ/5vW+JapVFVP
        0P5u2xITM9Frotklx8X+ZQkG13hONu22kTvXNdGC/cqfIzLLPWfNenPg2hyfhRZpe5f9XHOm
        xoJLoyYl1rzycIfWTNN/VR/ehMtw8y9PeKjCZsGyMvrbzzV/jm48WbLGw/h/7cUv1ZP4VWtz
        qsT3f6+x00+YtfUruyC7ZZ4SS3FGoqEWc1FxIgBMHOc09gIAAA==
X-CMS-MailID: 20210112025712epcas2p4f92af7bd5781df2fcefecca47d55bf8e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210112025712epcas2p4f92af7bd5781df2fcefecca47d55bf8e
References: <cover.1610419491.git.kwmad.kim@samsung.com>
        <CGME20210112025712epcas2p4f92af7bd5781df2fcefecca47d55bf8e@epcas2p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Exynos requires one scatterlist entry for smaller than
page size, i.e. 4KB. For the cases of dispatching commands
with more than one scatterlist entry and under 4KB size,
Exynos behaves as follows:

Given that a command to read something
from device is dispatched with two scatterlist entries that
are named AAA and BBB. After dispatching, host builds two PRDT
entries and during transmission, device sends just one DATA IN
because device doesn't care on host dma. The host then tranfers
the whole data from start address of the area named AAA.
In consequence, the area that follows AAA would be corrupted.

    |<------------->|
    +-------+------------         +-------+
    +  AAA  + (corrupted)   ...   +  BBB  +
    +-------+------------         +-------+

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index a8770ff..8635d9d 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -14,6 +14,7 @@
 #include <linux/of_address.h>
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
+#include <linux/blkdev.h>
 
 #include "ufshcd.h"
 #include "ufshcd-pltfrm.h"
@@ -1193,6 +1194,13 @@ static int exynos_ufs_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	return 0;
 }
 
+static void exynos_ufs_slave_configure(struct scsi_device *sdev)
+{
+	struct request_queue *q = sdev->request_queue;
+
+	blk_queue_update_dma_alignment(q, PAGE_SIZE - 1);
+}
+
 static struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.name				= "exynos_ufs",
 	.init				= exynos_ufs_init,
@@ -1204,6 +1212,7 @@ static struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.hibern8_notify			= exynos_ufs_hibern8_notify,
 	.suspend			= exynos_ufs_suspend,
 	.resume				= exynos_ufs_resume,
+	.slave_configure		= exynos_ufs_slave_configure,
 };
 
 static int exynos_ufs_probe(struct platform_device *pdev)
-- 
2.7.4

