Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 459F4C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 08:12:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B316610C7
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 08:12:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240627AbhJGIN4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 04:13:56 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:43898 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240528AbhJGINy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 04:13:54 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20211007081159epoutp0297a4b6017a0af04135f1c8720bc18fa7~rsWDrRm450347003470epoutp02W
        for <linux-scsi@vger.kernel.org>; Thu,  7 Oct 2021 08:11:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20211007081159epoutp0297a4b6017a0af04135f1c8720bc18fa7~rsWDrRm450347003470epoutp02W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1633594319;
        bh=kDPUu0crvjpJeXBJprcRYTsG7RPKldzeF7DRZzQcczY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ncB8yN2UJ+bHkj276kZBcv45bl9Sm12AMmuJF3nq0XnxiYGALT6sziaLKZey2uQKZ
         s9TdlFzXkEU/YNkjtap4JMYXIq83nvLy2Y+zG+Zw7ArfAJvaVVwF3ygPayZ6s2iKln
         2EfyCg0VsctK/AmT+nyXx+qoldvY217Fq0TNKyJk=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20211007081146epcas2p251fcc9d4234a0aac2f2b5c6ab97e95e3~rsV3vfeZx3166031660epcas2p2u;
        Thu,  7 Oct 2021 08:11:46 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.99]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4HQ3v43lstz4x9Q3; Thu,  7 Oct
        2021 08:11:44 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        EF.F7.09472.CBBAE516; Thu,  7 Oct 2021 17:11:40 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20211007081134epcas2p4af32ee0344c2c17f478709da5acc7a87~rsVsAJSdm2637326373epcas2p4j;
        Thu,  7 Oct 2021 08:11:34 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20211007081134epsmtrp2dcb493f6589303d1efe0d165517fb804~rsVr9zBOY2686726867epsmtrp24;
        Thu,  7 Oct 2021 08:11:34 +0000 (GMT)
X-AuditID: b6c32a48-d5fff70000002500-c0-615eabbcd19a
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        EF.53.09091.5BBAE516; Thu,  7 Oct 2021 17:11:33 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211007081133epsmtip21d5926cbbe49e3c7e7dc944835bcada1~rsVrvwQ_p0776407764epsmtip2R;
        Thu,  7 Oct 2021 08:11:33 +0000 (GMT)
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
        Jaehoon Chung <jh80.chung@samsung.com>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        Sowon Na <sowon.na@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH v4 04/16] scsi: ufs: ufs-exynos: simplify drv_data retrieval
Date:   Thu,  7 Oct 2021 17:09:22 +0900
Message-Id: <20211007080934.108804-5-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211007080934.108804-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAJsWRmVeSWpSXmKPExsWy7bCmue6e1XGJBv1TOS1OPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZotP65exWlzer23Rs9PZ4vSERUwWT9bPYrZYdGMbk8WNX22sFhvf
        /mCymHF+H5NF9/UdbBbLj/9jsvj98xCTg6DH5SveHrMaetk8Lvf1MnlsXqHlsXjPSyaPTas6
        2TwmLDrA6PF9fQebx8ent1g8+rasYvT4vEnOo/1AN1MAT1S2TUZqYkpqkUJqXnJ+SmZeuq2S
        d3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QX0oKZYk5pUChgMTiYiV9O5ui/NKSVIWM
        /OISW6XUgpScAvMCveLE3OLSvHS9vNQSK0MDAyNToMKE7Iyln/cyFlwSrFhw7iBTA+Mzvi5G
        Tg4JAROJiS0vWboYuTiEBHYwSmxffoodwvnEKLF+/WJmCOcbo8SOl28ZYVq+r7gFldjLKPFh
        5m9GCOcjo8TECX/AqtgEdCW2PH8FlhAReM8o8eTxFLDBzAIHmCUe7/zJClIlLOAjsXTjI3YQ
        m0VAVeLBurMsIDavgL3E49kXWCD2yUsc+dXJDGJzCjhI7Nm1lg2iRlDi5MwnYDXMQDXNW2eD
        3SQh8IBD4k5nExNEs4vEiY/foA4Xlnh1fAs7hC0l8fndXjaIhm5GidZH/6ESqxklOht9IGx7
        iV/TtwBdygG0QVNi/S59EFNCQFniyC2ovXwSHYf/skOEeSU62oQgGtUlDmyfDnW+rET3nM+s
        ELaHxNyPT6ABPJlR4vHLD8wTGBVmIXlnFpJ3ZiEsXsDIvIpRLLWgODc9tdiowAQeycn5uZsY
        wUldy2MH4+y3H/QOMTJxMB5ilOBgVhLhzbePTRTiTUmsrEotyo8vKs1JLT7EaAoM7InMUqLJ
        +cC8klcSb2hiaWBiZmZobmRqYK4kzjv3n1OikEB6YklqdmpqQWoRTB8TB6dUA1Ph9/zC6Vkx
        nV9fdlkskHjhLNn1kId5d9Xv/e3GmZcjDkemuBSGNTXqe+3vV29O/RDg+VD/wr8pz0Nm/ZPa
        duir6Z/rt67fu3uFYY5dc+gngU0c/YblmRee/ltStzKz2rVobZb7XMXrF+f8OqhQsjT4uNOO
        V+c3OT748u5HW0lt0LGYTcuEGdPlbHfbuVorfn5f2H1huvaCtS4nqufeuNBuvUiQa4kk66Py
        uVVPN56TYotOqrqZ8ffxXo6VH4X1c0I2WOtfD/1gk/7u4DXnDZ+2hRZ35m/fpfSc9+EhDpkU
        w3ivhlNV3wNOmhnwMNcUnHjM7OiYvGKW22TDUgumm4en8iTJ1j+e/8pgycWz7nFKLMUZiYZa
        zEXFiQBQaGbKcwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBIsWRmVeSWpSXmKPExsWy7bCSvO7W1XGJBu+WGlmcfLKGzeLBvG1s
        Fi9/XmWzOPiwk8Vi2oefzBaf1i9jtbi8X9uiZ6ezxekJi5gsnqyfxWyx6MY2Josbv9pYLTa+
        /cFkMeP8PiaL7us72CyWH//HZPH75yEmB0GPy1e8PWY19LJ5XO7rZfLYvELLY/Gel0wem1Z1
        snlMWHSA0eP7+g42j49Pb7F49G1ZxejxeZOcR/uBbqYAnigum5TUnMyy1CJ9uwSujKWf9zIW
        XBKsWHDuIFMD4zO+LkZODgkBE4nvK24xdzFycQgJ7GaUOL/qFSNEQlbi2bsd7BC2sMT9liOs
        EEXvGSWenjoIlmAT0JXY8hyiQUTgI6PEnG9aIEXMAqeYJdau28QCkhAW8JFYuvERWAOLgKrE
        g3VnweK8AvYSj2dfYIHYIC9x5FcnM4jNKeAgsWfXWrYuRg6gbfYSXX8jIcoFJU7OfAJWzgxU
        3rx1NvMERoFZSFKzkKQWMDKtYpRMLSjOTc8tNiwwzEst1ytOzC0uzUvXS87P3cQIjjwtzR2M
        21d90DvEyMTBeIhRgoNZSYQ33z42UYg3JbGyKrUoP76oNCe1+BCjNAeLkjjvha6T8UIC6Ykl
        qdmpqQWpRTBZJg5OqQYmrzSreKFfdr33XdU3txup7GXpevHpk8PLN9/fLex/lLpRheE1y7K6
        BSIXM1Oy3FrdI3v3xE45cY3tFheP6eGIOzwrvtS5rDKfujue50fmr7fvL6m9L1ge8in/fMcR
        vsrN8UXhGp2FDu0Tect0DctvcP+ry3RuT5f7FZm90T783V2fS7nFtxLNqh9+431yuDzRRnau
        WOCF3J8rDdXqT0QsPHdX1V24Ok9y2qa1Zkrmi7w+XbuywOxD3Tre/KjGz9KLL94OcDa8Mid/
        72v+z2baXSL/hVY2XGrM2ZiX8tRBw7iCWc3y31TXwtm7Fz9d/uEpG5PQEoX9Z/95LN8o3i99
        +uZSywe/Zyx8F5p3W1JXiaU4I9FQi7moOBEAQivz6CsDAAA=
X-CMS-MailID: 20211007081134epcas2p4af32ee0344c2c17f478709da5acc7a87
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211007081134epcas2p4af32ee0344c2c17f478709da5acc7a87
References: <20211007080934.108804-1-chanho61.park@samsung.com>
        <CGME20211007081134epcas2p4af32ee0344c2c17f478709da5acc7a87@epcas2p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The compatible field of exynos_ufs_drv_data is not necessary because
of_device_id already has it. Thus, we don't need it anymore and we can
get drv_data by device_get_match_data.

Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 10 +---------
 drivers/scsi/ufs/ufs-exynos.h |  3 +--
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index a14dd8ce56d4..8a17ba32a721 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -893,17 +893,10 @@ static int exynos_ufs_post_link(struct ufs_hba *hba)
 static int exynos_ufs_parse_dt(struct device *dev, struct exynos_ufs *ufs)
 {
 	struct device_node *np = dev->of_node;
-	struct exynos_ufs_drv_data *drv_data = &exynos_ufs_drvs;
 	struct exynos_ufs_uic_attr *attr;
 	int ret = 0;
 
-	while (drv_data->compatible) {
-		if (of_device_is_compatible(np, drv_data->compatible)) {
-			ufs->drv_data = drv_data;
-			break;
-		}
-		drv_data++;
-	}
+	ufs->drv_data = device_get_match_data(dev);
 
 	if (ufs->drv_data && ufs->drv_data->uic_attr) {
 		attr = ufs->drv_data->uic_attr;
@@ -1258,7 +1251,6 @@ static struct exynos_ufs_uic_attr exynos7_uic_attr = {
 };
 
 static struct exynos_ufs_drv_data exynos_ufs_drvs = {
-	.compatible		= "samsung,exynos7-ufs",
 	.uic_attr		= &exynos7_uic_attr,
 	.quirks			= UFSHCD_QUIRK_PRDT_BYTE_GRAN |
 				  UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR |
diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
index 0a31f77a5f48..2e72aabaa673 100644
--- a/drivers/scsi/ufs/ufs-exynos.h
+++ b/drivers/scsi/ufs/ufs-exynos.h
@@ -142,7 +142,6 @@ struct exynos_ufs_uic_attr {
 };
 
 struct exynos_ufs_drv_data {
-	char *compatible;
 	struct exynos_ufs_uic_attr *uic_attr;
 	unsigned int quirks;
 	unsigned int opts;
@@ -191,7 +190,7 @@ struct exynos_ufs {
 	struct ufs_pa_layer_attr dev_req_params;
 	struct ufs_phy_time_cfg t_cfg;
 	ktime_t entry_hibern8_t;
-	struct exynos_ufs_drv_data *drv_data;
+	const struct exynos_ufs_drv_data *drv_data;
 
 	u32 opts;
 #define EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL		BIT(0)
-- 
2.33.0

