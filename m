Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEA90C11F68
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 06:57:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B604E61245
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 06:57:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbhGIHAg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 03:00:36 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:38035 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbhGIHAe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 03:00:34 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210709065749epoutp04f99ef2ff568a6a882b55fe6c232592fc~QDRnBPSy51010810108epoutp04g
        for <linux-scsi@vger.kernel.org>; Fri,  9 Jul 2021 06:57:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210709065749epoutp04f99ef2ff568a6a882b55fe6c232592fc~QDRnBPSy51010810108epoutp04g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1625813869;
        bh=zU6c2IkKZlJdDlUWUDmg7+H7g+or8OGwvfpPyh/1+jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bgJQwOog3hZezaOwKx4WC13Bx8FNXAdD3acHC3KsPQgxp4VLgNJZ26K1t8l/jUV6Z
         /XTD8qzdwYXVFvgEs3dNw4LpTmIrORR3BQJ8qcqzTNEN9IWf2xBEQAPoxb90vFc+oL
         0vCfJHsuw1K3h3Ee8wp6H2tMmucMZ2L6wvaRuE74=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210709065748epcas2p19ac771b1d502fe473dcb061b2538d7cb~QDRl399js0581505815epcas2p1y;
        Fri,  9 Jul 2021 06:57:48 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.183]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4GLkWH0SPqz4x9QL; Fri,  9 Jul
        2021 06:57:47 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        D7.D4.09541.A63F7E06; Fri,  9 Jul 2021 15:57:46 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210709065746epcas2p26f07099abcb946400ff2777fd9df975d~QDRj75odZ2550225502epcas2p2H;
        Fri,  9 Jul 2021 06:57:46 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210709065746epsmtrp1bc4578793672c53acf62df32e5923af1~QDRj68AdQ3179431794epsmtrp1P;
        Fri,  9 Jul 2021 06:57:46 +0000 (GMT)
X-AuditID: b6c32a46-095ff70000002545-62-60e7f36ad0da
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        DE.B7.08289.A63F7E06; Fri,  9 Jul 2021 15:57:46 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210709065746epsmtip27683dec1acd43a88a19fd291612147f5~QDRjuLhML3134631346epsmtip2v;
        Fri,  9 Jul 2021 06:57:46 +0000 (GMT)
From:   Chanho Park <chanho61.park@samsung.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
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
Subject: [PATCH 04/15] scsi: ufs: ufs-exynos: simplify drv_data retrieval
Date:   Fri,  9 Jul 2021 15:57:00 +0900
Message-Id: <20210709065711.25195-5-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709065711.25195-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Tf0xbVRT2vldeH2jZozB3xzKpT40OUtY2Ft6wbC782GNggoEQY2baJzwL
        s7RdW4zTLNawAQOBbgobxSGisq3YNbKusGUM6HBI5xxLmQKbBBbkl5IBNUMw22x5XeS/75zz
        ffec79x7cVTowaLxIq2JNWgZDYmF8VxXt8nF+33TKonDnUQNTH6PUeNNLoyaXbmNUfULKyi1
        5GgNobzdcdRnF1Oo65YWhJp0WFGqZdiFUGd/pagR54886uTNKwhV9VsnRp3uf4S8voH2DmXS
        3ppqhD5/Jpb+5vIsQrfbjmK0paUH0It/jPLoGqcN0L725+jyniokO+xtjaKQZQpYg4jV5usK
        irTqZDIzR5milCdIpGLpDiqRFGmZYjaZTM3KFqcXafwWSNEHjKbEn8pmjEZy+06FQVdiYkWF
        OqMpmWT1BRq9VKqPNzLFxhKtOj5fV5wklUhkcj9TpSl0278G+qaID4dWf+CbQUd4JQjFIfEq
        vNVYi1SCMFxIdAL49/QIxgVLADrqu9AAS0j4AByawJ4oajpuoRzpEoD2mV4eFywCeLSud02B
        EWLonJ4DgUIUUQvg6e5TayyUGEDh9eZefoAVSWRAr+WGH+M4j3gJXplID6QFxE543jrD59rF
        QE9rLxLAocQu2PSPBeE4EXCgYZIXwKifU3qhcW0kSPThsLftZ8CJU6GrvD6II+FcvzN4aDSc
        rS3jc4IqAI/cexwstPk9fJrF4V1w9YQzJDAcSmyDjkvbAxASL8C+0WDfcFhx9SGfSwtgRZmQ
        E74MezpO8Di8FVZ96QvhMA0fnysNbu44gONldtQCRNZ1dqzr7Fj/b9wMUBt4ltUbi9WsUaaX
        rb/idrD2qGPTO8EX8wvxboDgwA0gjpJRAtnJKZVQUMAc/Ig16JSGEg1rdAO5f9fH0OiN+Tr/
        r9CalFK5LCFBskNOyRNkFLlJgPPdKiGhZkzs+yyrZw1PdAgeGm1G0EfOv3LvtelG39m7bMlT
        tNd9Z/329gyyJXd+36z1K3vonn7ncFsKMnFDe3/kwJD6IbNw8fc3DvCeqhhY/De2NmKP+b20
        yKbGO0PNerPXtHv+J3u1ZnNBmnI4bzBxKXMwpzsP+eRu6dmNHps5cWrGmysK87VkifbzX2zs
        gqkZT8O0B8c2Pbh8mLgmLhRXSHweZwU2rt2S83z2fbJuMzoW7mDuvjk710lmqKJuRlcnqKas
        v3h6DkfZzNcqN1itmjODIeq3njmkqIr7eOmg7PPpGGXDnUPntK7l3UfKlWMZq2RDX6crrmGr
        PelPBdP17pQ+e98F/mvFYyvLIa2ymOVX8hUkz1jISGNRg5H5D/vuX45dBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42LZdlhJXjfr8/MEg4aZIhYnn6xhs3gwbxub
        xcufV9kspn34yWzxaf0yVovL+7UtenY6W5yesIjJ4sn6WcwWi25sY7JYec3C4uaWoywWM87v
        Y7Lovr6DzWL58X9MDvwel694e1zu62Xy2LxCy2PxnpdMHptWdbJ5TFh0gNHj49NbLB59W1Yx
        enzeJOfRfqCbKYArissmJTUnsyy1SN8ugSvj0NqFjAXzBCuu/NrI3sC4na+LkZNDQsBEom/7
        ReYuRi4OIYEdjBInF15mg0jISjx7t4MdwhaWuN9yhBWi6D2jxLXbcxlBEmwCuhJbnr8Cs0UE
        JjJKLLknBlLELHCZWeLbtCvMIAlhAU+JyxPOAk3i4GARUJXY99ANJMwrYCexedYLqAXyEqeW
        HWQCsTkF7CXm/ZgAZgsB1dzbsI8dol5Q4uTMJywgNjNQffPW2cwTGAVmIUnNQpJawMi0ilEy
        taA4Nz232LDAKC+1XK84Mbe4NC9dLzk/dxMjOJ60tHYw7ln1Qe8QIxMH4yFGCQ5mJRFeoxnP
        EoR4UxIrq1KL8uOLSnNSiw8xSnOwKInzXug6GS8kkJ5YkpqdmlqQWgSTZeLglGpgmqLYUf36
        8+9TpTuFlmRdqfg8g3WadVaijU9w3PVcdf/v/iF7Zrq+LGv+aRd3kvdk8OGP93e5TLq4ZndK
        0gT9x2b3/5d15bezCUwTzbBpZfuSLn5sUimv60mV6JojvQy/Nx1k/1D+dYZhX87CZ8/6LKa1
        stu3XMtk/sckf2aDTef7SuFvAdI+f7m3hp5fYNW4vLbmRUOFROwTQ7ugVV1p0Vefmfj4H99s
        prO9dm+FVeqjHXJ77eS31ovpXJzU8aTebWbC9pouv1PXG++vfae5+I2Wi/htxVOvQhRvzv/X
        2fO459HeM4fS5+az2iddbri1+o3bcr5runreBSe5xZxrexcyvvbR/Lo1f/9Wp+WKSizFGYmG
        WsxFxYkAM9um+hYDAAA=
X-CMS-MailID: 20210709065746epcas2p26f07099abcb946400ff2777fd9df975d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210709065746epcas2p26f07099abcb946400ff2777fd9df975d
References: <20210709065711.25195-1-chanho61.park@samsung.com>
        <CGME20210709065746epcas2p26f07099abcb946400ff2777fd9df975d@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The compatible field of exynos_ufs_drv_data is not necessary because
of_device_id already has it. Thus, we don't need it anymore and we can
get drv_data by device_get_match_data.

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 10 +---------
 drivers/scsi/ufs/ufs-exynos.h |  3 +--
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index cf46d6f86e0e..db5892901cc0 100644
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
index 475a5adf0f8b..7bf2053f6e90 100644
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
2.32.0

