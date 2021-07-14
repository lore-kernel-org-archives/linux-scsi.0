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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4634FC07E9A
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 07:12:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A269613AF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 07:12:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238242AbhGNHPE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 03:15:04 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:11541 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238231AbhGNHO6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 03:14:58 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210714071202epoutp023a1dff618d0c1d2a92918538986a9cda~Rlsc8UjpA2633126331epoutp02x
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2021 07:12:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210714071202epoutp023a1dff618d0c1d2a92918538986a9cda~Rlsc8UjpA2633126331epoutp02x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1626246722;
        bh=TzqmxWLzJw7YUlq6RtqJwNn05f8F68Wk3f4J2IILl0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YF7vEHwWuzoroWNWAdxsfy+S5hf/V7MMvt43QAMXvA/Sq7QfXz9C8m9N9JG1w7GNl
         Ec1QElUp0L+eeekWcIF71RoZBQE/rpv1lQhj+pi78AtKM+pEShvc5Hz00ntUEd1vEE
         KZdp6BFBVlqC++1sQby6YnrAmU7HBsKhOa9FdV/M=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210714071202epcas2p4dbfd86dd70a50f1c9e943fbc84832e4c~RlscHFQB82506225062epcas2p4w;
        Wed, 14 Jul 2021 07:12:02 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.187]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4GPpbN24Ptz4x9QM; Wed, 14 Jul
        2021 07:12:00 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        8D.3D.09571.04E8EE06; Wed, 14 Jul 2021 16:12:00 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210714071159epcas2p4edc8104aad36d4d7a5bedb8328c0ab39~RlsZ4nEch2508225082epcas2p4h;
        Wed, 14 Jul 2021 07:11:59 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210714071159epsmtrp1be28ec233f0bee98cf9d99e459a6f821~RlsZ3casT1240112401epsmtrp1f;
        Wed, 14 Jul 2021 07:11:59 +0000 (GMT)
X-AuditID: b6c32a48-1dfff70000002563-0a-60ee8e40c601
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        B6.17.08289.F3E8EE06; Wed, 14 Jul 2021 16:11:59 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210714071159epsmtip2d56655535bfd69647c61476a6409819c~RlsZqL5-U2194721947epsmtip2k;
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
Subject: [PATCH v2 09/15] scsi: ufs: ufs-exynos: support custom version of
 ufs_hba_variant_ops
Date:   Wed, 14 Jul 2021 16:11:25 +0900
Message-Id: <20210714071131.101204-10-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210714071131.101204-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAJsWRmVeSWpSXmKPExsWy7bCmma5D37sEg74vPBYnn6xhs3gwbxub
        xcufV9kspn34yWzxaf0yVovL+7UtenY6W5yesIjJ4sn6WcwWi25sY7JYec3C4vz5DewWN7cc
        ZbGYcX4fk0X39R1sFsuP/2NyEPC4fMXb43JfL5PH5hVaHov3vGTy2LSqk81jwqIDjB4fn95i
        8ejbsorR4/MmOY/2A91MAVxROTYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5
        ibmptkouPgG6bpk5QH8oKZQl5pQChQISi4uV9O1sivJLS1IVMvKLS2yVUgtScgoMDQv0ihNz
        i0vz0vWS83OtDA0MjEyBKhNyMmZPvsVY8JK7YsmO94wNjI1cXYycHBICJhJbV35h6WLk4hAS
        2MEosWDlI2YI5xOjxJ3Pd9hBqoQEPjNKPJyYAtPxfeI/qKJdjBJ7zr1khHA+Mkq0nHnJBFLF
        JqArseX5K7CECMjcVYvvgi1hFjjJLHF6wUGwucICCRL/l+9jA7FZBFQlXj7eBhbnFXCQWHtr
        CSPEPnmJU8sOgk3lBIof3PCBEaJGUOLkzCcsIDYzUE3z1tlgN0kInOGQmLDuJxNEs4tE56dT
        UIOEJV4d38IOYUtJvOxvY4do6GaUaH30HyqxmlGis9EHwraX+DV9C2sXIwfQBk2J9bv0QUwJ
        AWWJI7eg9vJJdBz+yw4R5pXoaBOCaFSXOLB9OguELSvRPeczK4TtITHz0mI2SGhNZpRYfvsv
        0wRGhVlI3pmF5J1ZCIsXMDKvYhRLLSjOTU8tNiowQY7jTYzgpK3lsYNx9tsPeocYmTgYDzFK
        cDArifAuNXqbIMSbklhZlVqUH19UmpNafIjRFBjYE5mlRJPzgXkjryTe0NTIzMzA0tTC1MzI
        Qkmcl4P9UIKQQHpiSWp2ampBahFMHxMHp1QDE/P+nzlHFh9om79QeofWuyt6D/OPBO3r1EyT
        W7tRTPz5/YZrOpceiT44pHx3Wme3lNRzh+0zRXdf/TaRTafjYiOPmfeVsOeXT71i+PBVgrHv
        6qq7AeFXPOTP8c570cn01bOfyTI50WCW7CozlrfvspSetnb8PtRV1KIzJ3xud0xmCLOL8+M7
        cSJdTz8vMgi5Xmp/c3/cwcp3s1bevHrPJYCjP4jNPP/PRt+bEvcCOepaTzK+Up54PCS3re+g
        0ItnO1dMd699zS8/qZbjQp2mvfmWLWGK4sV8Mdkr+h2qjzRMObVSsVVu6c3S0Ocsxw63+wn4
        M8goHni5/vXJ1O8mkj/z6n5L/qjj7k/ssb+Zr8RSnJFoqMVcVJwIAOKGVFJjBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42LZdlhJXte+712CQctZeYuTT9awWTyYt43N
        4uXPq2wW0z78ZLb4tH4Zq8Xl/doWPTudLU5PWMRk8WT9LGaLRTe2MVmsvGZhcf78BnaLm1uO
        sljMOL+PyaL7+g42i+XH/zE5CHhcvuLtcbmvl8lj8wotj8V7XjJ5bFrVyeYxYdEBRo+PT2+x
        ePRtWcXo8XmTnEf7gW6mAK4oLpuU1JzMstQifbsErozZk28xFrzkrliy4z1jA2MjVxcjJ4eE
        gInE94n/mLsYuTiEBHYwSkxatpIFIiEr8ezdDnYIW1jifssRVoii94wSnftXMYEk2AR0JbY8
        f8UIkhAR2MUocfjMYXYQh1ngMrPEt2lXmEGqhAXiJH4feQVmswioSrx8vA1sLK+Ag8TaW0sY
        IVbIS5xadhBsKidQ/OCGD2BxIQF7iX/bVrNB1AtKnJz5BOw8ZqD65q2zmScwCsxCkpqFJLWA
        kWkVo2RqQXFuem6xYYFRXmq5XnFibnFpXrpecn7uJkZwdGlp7WDcs+qD3iFGJg7GQ4wSHMxK
        IrxLjd4mCPGmJFZWpRblxxeV5qQWH2KU5mBREue90HUyXkggPbEkNTs1tSC1CCbLxMEp1cBU
        yXOv+MypztJlkWILP7003C7DwX2o5e/2e+efn4q6fjH8v9juaa35LfqKMnJHJPmFVJ0XppS2
        eO9aqjY5pGWb//ITyjr8M/kMjny+J7Sw569dpKbW1sCpc1I+spz8OzNx7f5fn1wmxqUden1w
        d0ln1VeG1DDBniPvxM9Gy0wW8NCZdTzqN6/9bUMO3RR3l+oQkVWXLv9cXFNz5XrK9IJ/kq9j
        ls1SYXm+QMEh7sadj8brFH+/k7R8yLL4bufyV5vSjjS+tVj1sVt2yYmefce2sJxYxb1T0yze
        dlHgs8ln1s+YcquSv/jFtUl5XffeHNtdtOj6V/MjHUl13/prN7o9PZEs8vZkUG+zpaGxlut8
        cyWW4oxEQy3mouJEAICK4pwdAwAA
X-CMS-MailID: 20210714071159epcas2p4edc8104aad36d4d7a5bedb8328c0ab39
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210714071159epcas2p4edc8104aad36d4d7a5bedb8328c0ab39
References: <20210714071131.101204-1-chanho61.park@samsung.com>
        <CGME20210714071159epcas2p4edc8104aad36d4d7a5bedb8328c0ab39@epcas2p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

By default, ufs_hba_exynos_ops will be used but this patch supports to
use custom version of ufs_hba_variant_ops because some variants of
exynos-ufs will use only few callbacks.

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 8 +++++++-
 drivers/scsi/ufs/ufs-exynos.h | 1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 60edd420095f..90c0d7c85a13 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -1238,8 +1238,14 @@ static int exynos_ufs_probe(struct platform_device *pdev)
 {
 	int err;
 	struct device *dev = &pdev->dev;
+	const struct ufs_hba_variant_ops *vops = &ufs_hba_exynos_ops;
+	const struct exynos_ufs_drv_data *drv_data =
+		device_get_match_data(dev);
 
-	err = ufshcd_pltfrm_init(pdev, &ufs_hba_exynos_ops);
+	if (drv_data && drv_data->vops)
+		vops = drv_data->vops;
+
+	err = ufshcd_pltfrm_init(pdev, vops);
 	if (err)
 		dev_err(dev, "ufshcd_pltfrm_init() failed %d\n", err);
 
diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
index a46f30639f38..0938bd82763f 100644
--- a/drivers/scsi/ufs/ufs-exynos.h
+++ b/drivers/scsi/ufs/ufs-exynos.h
@@ -142,6 +142,7 @@ struct exynos_ufs_uic_attr {
 };
 
 struct exynos_ufs_drv_data {
+	const struct ufs_hba_variant_ops *vops;
 	struct exynos_ufs_uic_attr *uic_attr;
 	unsigned int quirks;
 	unsigned int opts;
-- 
2.32.0

