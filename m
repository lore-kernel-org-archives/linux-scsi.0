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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00442C11F73
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 07:12:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCB706138C
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 07:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238254AbhGNHPG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 03:15:06 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:11501 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238260AbhGNHO6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 03:14:58 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210714071202epoutp0265667f8ebfb2ce06603fc72f3fb037fd~RlscZ-da12585925859epoutp02Z
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2021 07:12:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210714071202epoutp0265667f8ebfb2ce06603fc72f3fb037fd~RlscZ-da12585925859epoutp02Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1626246722;
        bh=nvto6MAUXII++5Qoedhxm85Le+YYY4cABecM5BXJJzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iojc/z+zYpxuuc6MgQaSxTR7/qZUYe0WGPIf79HRE9guw31GOB3H5Q0wWY59Nk8vj
         H9QkkT8hzuo0vanlrElEZAvMa2qkGxjvxu5dv7+0YwVFr/IPDhYo3kck+UuAPzIkiI
         C4/7N8DHWEFhX0v7I8ZhOA1pmffpG3mZfhr673sw=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210714071201epcas2p129d3d6a7bb09f8b1dc60d66608cfc9c2~Rlsb6zCvB0378503785epcas2p1V;
        Wed, 14 Jul 2021 07:12:01 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.189]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4GPpbN24kSz4x9QT; Wed, 14 Jul
        2021 07:12:00 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        AD.3D.09571.04E8EE06; Wed, 14 Jul 2021 16:12:00 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20210714071159epcas2p176be9a1310f8de27cfb3786fe86630d6~RlsaCVDse0389603896epcas2p18;
        Wed, 14 Jul 2021 07:11:59 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210714071159epsmtrp2acd4da76b5105e118916978531021fef~RlsaBfUJv0755107551epsmtrp2r;
        Wed, 14 Jul 2021 07:11:59 +0000 (GMT)
X-AuditID: b6c32a48-1dfff70000002563-0d-60ee8e409716
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F5.43.08394.F3E8EE06; Wed, 14 Jul 2021 16:11:59 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210714071159epsmtip22a155e625a0f86962bd3e991f057bc5c~RlsZ07cbj1845718457epsmtip2y;
        Wed, 14 Jul 2021 07:11:59 +0000 (GMT)
From:   Chanho Park <chanho61.park@samsung.com>
To:     Krzysztof Kozlowski <krzk@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Can Guo <cang@codeaurora.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Bart Van Assche <bvanassche@acm.org>,
        jongmin jeong <jjmin.jeong@samsung.com>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH v2 11/15] scsi: ufs: ufs-exynos: factor out priv data init
Date:   Wed, 14 Jul 2021 16:11:27 +0900
Message-Id: <20210714071131.101204-12-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210714071131.101204-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPJsWRmVeSWpSXmKPExsWy7bCmqa5D37sEg0X7eC1OPlnDZvFg3jY2
        i5c/r7JZTPvwk9ni0/plrBaX92tb9Ox0tjg9YRGTxZP1s5gtFt3YxmSx8pqFxfnzG9gtbm45
        ymIx4/w+Jovu6zvYLJYf/8fkIOBx+Yq3x+W+XiaPzSu0PBbvecnksWlVJ5vHhEUHGD0+Pr3F
        4tG3ZRWjx+dNch7tB7qZAriicmwyUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTy
        EnNTbZVcfAJ03TJzgP5QUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BQYGhboFSfm
        Fpfmpesl5+daGRoYGJkCVSbkZOy4wF7wg7vi1sqtjA2Mnzm7GDk5JARMJO7197CA2EICOxgl
        nvandjFyAdmfGCWmr3vCBuF8Y5R4NH8jI0zH+oOt7BCJvYwSd25eZIFwPjJKLDi/HGwWm4Cu
        xJbnrxhBEiIgc1ctvgtWxSxwklni9IKD7CBVwgJeEm9PzQXrYBFQlVi/7QUTiM0r4CDx6/9x
        Voh98hKnlh0Ei3MCxQ9u+MAIUSMocXLmE7BeZqCa5q2zmUEWSAic4ZB48H8JE0Szi8THG8uh
        DheWeHV8CzuELSXx+d1eNoiGbkaJ1kf/oRKrGSU6G30gbHuJX9O3AF3BAbRBU2L9Ln0QU0JA
        WeLILai9fBIdh/+yQ4R5JTrahCAa1SUObJ/OAmHLSnTP+Qz1iofE5p6j0DCdzCjxftNe9gmM
        CrOQvDMLyTuzEBYvYGRexSiWWlCcm55abFRgghzFmxjBKVvLYwfj7Lcf9A4xMnEwHmKU4GBW
        EuFdavQ2QYg3JbGyKrUoP76oNCe1+BCjKTCwJzJLiSbnA7NGXkm8oamRmZmBpamFqZmRhZI4
        Lwf7oQQhgfTEktTs1NSC1CKYPiYOTqkGJot1YXL/lzhm+SSvSvyUVpez53uv7VqNd5X3Vh68
        zf7z/aokJa7Hlro7r7pLdC7a+Wkmk7XHTIYyuR+lUYlOty+u19y9/W1p8rWzb9x2zz/K8Dfq
        iza/5MNz7euYUpaJ6u9UWGIQ/ML1sSMP00TudawrruStVPq5W37qSsVKNbYr91t793+V/7iv
        9uQWparsRZpPDXi2uf/a8bZGuWQpy7PZTncLL1VZC9y+bfrq6ZqKXzysy7k2zeTuNHj61L3l
        eNdDl3uJ0pPvfTNa6bNrqWUs/1n2Q7etP0hmbtnqH734w1LR+tjLjqVH1LVi/JIYv6+rflR0
        4oDTtVsH9wY2rMvhbGLIm3w9e71piYyz9mclluKMREMt5qLiRABgnrZgYgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42LZdlhJXte+712CwZcNWhYnn6xhs3gwbxub
        xcufV9kspn34yWzxaf0yVovL+7UtenY6W5yesIjJ4sn6WcwWi25sY7JYec3C4vz5DewWN7cc
        ZbGYcX4fk0X39R1sFsuP/2NyEPC4fMXb43JfL5PH5hVaHov3vGTy2LSqk81jwqIDjB4fn95i
        8ejbsorR4/MmOY/2A91MAVxRXDYpqTmZZalF+nYJXBk7LrAX/OCuuLVyK2MD42fOLkZODgkB
        E4n1B1vZuxi5OIQEdjNK/P/UywaRkJV49m4HO4QtLHG/5QgrRNF7RonXL04ygSTYBHQltjx/
        xQiSEBHYxShx+MxhsFHMApeZJb5Nu8IMUiUs4CXx9tRcFhCbRUBVYv22F2DdvAIOEr/+H2eF
        WCEvcWrZQbA4J1D84IYPjCC2kIC9xL9tq9kg6gUlTs58AjaHGai+eets5gmMArOQpGYhSS1g
        ZFrFKJlaUJybnltsWGCYl1quV5yYW1yal66XnJ+7iREcW1qaOxi3r/qgd4iRiYPxEKMEB7OS
        CO9So7cJQrwpiZVVqUX58UWlOanFhxilOViUxHkvdJ2MFxJITyxJzU5NLUgtgskycXBKNTBd
        Y4x7/1FrepS+0pGU9BiNsoijM9JLXF48Ljq67OZhrfWvl4UEzpzbWKtZbtVyguuLx/qJPun8
        cz70TE74X2FxeIXhhLLtBYZ83DGue363m6yY4yfHY/jYgNn4LSdza+WTs3cmBWjqRDdPXp4r
        dHj2885Dj/rsf22KVVf5Jxz8ZEWv2X8H3Tmy3Vfcdt66ue9VgO85nf1ib4+wvQnWLP9YPN+S
        exurTh2f4ia5n678n/vtMudt+xtsfKdWR83ATva+8Jz9mQarbhfKa15sOLbpzY8aA9nYy/9+
        /Q/Lz5tp/t3Oo+Bk00Z25VXFZ2xe+d6Tce/+YBllo8a2Oeb/9yVuh1M3aDw6XaAo5e4w97US
        S3FGoqEWc1FxIgBHFM/OHAMAAA==
X-CMS-MailID: 20210714071159epcas2p176be9a1310f8de27cfb3786fe86630d6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210714071159epcas2p176be9a1310f8de27cfb3786fe86630d6
References: <20210714071131.101204-1-chanho61.park@samsung.com>
        <CGME20210714071159epcas2p176be9a1310f8de27cfb3786fe86630d6@epcas2p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To be used this assignment code for other variant exynos-ufs driver,
this patch factors out the codes as inline code.

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 9a5a7a5ffc4b..81b8b8d9915a 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -951,6 +951,18 @@ static int exynos_ufs_parse_dt(struct device *dev, struct exynos_ufs *ufs)
 	return ret;
 }
 
+static inline void exynos_ufs_priv_init(struct ufs_hba *hba,
+					struct exynos_ufs *ufs)
+{
+	ufs->hba = hba;
+	ufs->opts = ufs->drv_data->opts;
+	ufs->rx_sel_idx = PA_MAXDATALANES;
+	if (ufs->opts & EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX)
+		ufs->rx_sel_idx = 0;
+	hba->priv = (void *)ufs;
+	hba->quirks = ufs->drv_data->quirks;
+}
+
 static int exynos_ufs_init(struct ufs_hba *hba)
 {
 	struct device *dev = hba->dev;
@@ -1000,13 +1012,8 @@ static int exynos_ufs_init(struct ufs_hba *hba)
 	if (ret)
 		goto phy_off;
 
-	ufs->hba = hba;
-	ufs->opts = ufs->drv_data->opts;
-	ufs->rx_sel_idx = PA_MAXDATALANES;
-	if (ufs->opts & EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX)
-		ufs->rx_sel_idx = 0;
-	hba->priv = (void *)ufs;
-	hba->quirks = ufs->drv_data->quirks;
+	exynos_ufs_priv_init(hba, ufs);
+
 	if (ufs->drv_data->drv_init) {
 		ret = ufs->drv_data->drv_init(dev, ufs);
 		if (ret) {
-- 
2.32.0

