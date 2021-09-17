Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58BA9C4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 06:55:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FB8B611C0
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 06:55:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238590AbhIQG47 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 02:56:59 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:41837 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237575AbhIQG4v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 02:56:51 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210917065526epoutp03eced1f6e3e626e35bf19d905b54b0319~liZgmXiEl0483304833epoutp03t
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 06:55:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210917065526epoutp03eced1f6e3e626e35bf19d905b54b0319~liZgmXiEl0483304833epoutp03t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1631861726;
        bh=HAEMRcMPdknANmCAkm4kPlc+Bin9AcxuWblxgC/IUSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aAPtymICEDA7ONw8XgPpvqknDS8pxPv1xAT/OyW6f4SRmeJNIidm8vfXTZd9eW6Ms
         XmzxX75WhUj5B9OL2KH5O6Sg7S5NGZBW90JaVrS0L6ByT9aXNgMUv+ZgBU0xiMHkHg
         +0U4x1CW6QNSuiVkk0VxzgcKiW9y5iRHY3ZShFxs=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210917065525epcas2p29071c3a9d0f137d663095d432895a95e~liZgEGbyL3235432354epcas2p23;
        Fri, 17 Sep 2021 06:55:25 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.184]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4H9l8D3Bdpz4x9QL; Fri, 17 Sep
        2021 06:55:24 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        84.DF.09472.BDB34416; Fri, 17 Sep 2021 15:55:23 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20210917065523epcas2p1215e9f56482339ca8a9346a0ac2bfe23~liZdnV1sB0293102931epcas2p1a;
        Fri, 17 Sep 2021 06:55:23 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210917065523epsmtrp251bb844a8133d5a195e17dff3ae897ee~liZdmZqPq1371513715epsmtrp2R;
        Fri, 17 Sep 2021 06:55:23 +0000 (GMT)
X-AuditID: b6c32a48-d5fff70000002500-47-61443bdb1989
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        C7.91.08750.BDB34416; Fri, 17 Sep 2021 15:55:23 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210917065523epsmtip2ec1a3a2b4af444f7217f7343dbd9f745~liZdbDN6U2163221632epsmtip2v;
        Fri, 17 Sep 2021 06:55:23 +0000 (GMT)
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
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v3 08/17] scsi: ufs: ufs-exynos: add setup_clocks callback
Date:   Fri, 17 Sep 2021 15:54:27 +0900
Message-Id: <20210917065436.145629-9-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210917065436.145629-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02TfUwTZxzHee7ao5jBzqLbMzZHc3tBMEDL7O1kMHGgOyfLUGOWkGVwoZeW
        WNraa83miKlhKuUtIEakVIogYhiDwSrjdSIwOyYGFlC0mG1gHUrGuwjolLUcZvz3+T2/7/f5
        5ve8iFCxEwsQpWoMrF7DqAlsnaCxK5gMHf4gjpEeGwmnelw1GPVXaSNGPVy6iVFXR8wC6sz0
        EkrN1l0UUgNXtlA5zbHU9fxyhHLVWVCq/HYjQtVPLCLUHfsvAups388IlT3UhFFVjudIDE4P
        DO6hLaZcjB7Iy0XoHy+F0BVtDxG6odqM0fnlHYBeqMvE6Jn7TgGdZ68G9FzDm/TJjmwk4aVE
        dZSKZRSsXsJqUrSKVI0ymtizPyk2SU5KZaGybdT7hETDpLHRRFx8QuiuVLV7JEJymFEb3UsJ
        DMcR4R9G6bVGAytRaTlDNMHqFGqdTKYL45g0zqhRhqVo0yJlUmmE3K1MVqucPSZv3fn1X9mv
        tGIm0O+XBXxEEN8K75XmYVlgnUiMNwFY2TG/WswC2Dz5SMAXcwAO9DmRF5YLY6OYh8V4C4CL
        Vn9eNAOgtf6kwNPA8FBoHxsHnsYGfApA173T3p4CxS0odMwXrmzlj38CR5a6vD0swN+BttoL
        K9v64tvh+M3vV+MCYfcTM+phHzwGOluWAa9ZD3uKXStpqFuTcbkE9QRA/LYIVt0tB7w5Dj4b
        dq2yPxx32L15DoBzk+0Yb8gG8Pjo8mrjOwDNx+J53g6fFNmFWUDkTgiGdS3hHoT4W7DbuZrr
        BzO7nnnzy74w84SYNwbBjp+KBDxvgtnWOSEvoWF7Kc4fViGAv979TZgPJJY101jWTGP5P7cM
        oNXgFVbHpSlZLkK3de0VN4CVRx5CN4GSiemwToCIQCeAIpTY4NufvoMR+yqYr4+wem2S3qhm
        uU4gd591ARqwMUXr/iUaQ5JMHkGS0m1ySk5GUMSrvueef8SIcSVjYA+yrI7Vv/AhIp8AE+L4
        Paq4+19bucv0VGq91jgY1L23J2B4LCziceT9kbNF01VocaRVMVpiVpmeZrx3x7I5flbleLS7
        ebD3dMyZoWBlZe9FkQtOzeDTpV7kpjjpzi+k35iYRuefh/LfvlTps+h4kMQp227RD/xy96Xa
        294lDh7OuWXLb6p5gwzM3hlpO1WgQyYNj79tPWH1Mg7te739DzTyKlmfnGl7mVzeUX808DVz
        WcN5ouDjQylsszaxd6TMciOITt34z2cHRida28jx9MTY3Uem5ivY6U+bvTYP5BS2/Y0qjH21
        uwp+SEsu7V8QHjjqdTyj4vK1hetfnrOQN8BUxf4twzU9tZ83pVO6vYSAUzGyEFTPMf8BXL65
        GG0EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsWy7bCSvO5ta5dEg7V/BCxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZotP65exWlzer23Rs9PZ4vSERUwWT9bPYrZYdGMbk8XGtz+YLG5u
        OcpiMeP8PiaL7us72CyWH//H5CDgcfmKt8eshl42j8t9vUwem1doeSze85LJY9OqTjaPCYsO
        MHp8X9/B5vHx6S0Wj74tqxg9Pm+S82g/0M0UwBPFZZOSmpNZllqkb5fAlXHrZAN7wULBii37
        d7M1MF7g62Lk5JAQMJFY8vwRWxcjF4eQwA5GiS2HD7FDJGQlnr3bAWULS9xvOcIKUfSeUWL/
        1fWMIAk2AV2JLc9fgdkiAh8ZJeZ80wIpYhZYwizReGAeE0hCWMBL4uHPw2CTWARUJeavW8IG
        YvMK2Eu8urqWCWKDvMSRX53MIDangIPErV3/wYYKAdVMnLyIEaJeUOLkzCcsIDYzUH3z1tnM
        ExgFZiFJzUKSWsDItIpRMrWgODc9t9iwwCgvtVyvODG3uDQvXS85P3cTIzjitLR2MO5Z9UHv
        ECMTB+MhRgkOZiUR3gs1jolCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeS90nYwXEkhPLEnNTk0t
        SC2CyTJxcEo1MHlnW9iXbfYK1PpeeewsuwMD89czMmzT8pYbeu/5tiDj9cSmqT6hClosAnY5
        9pf1e5ousD5e6lsaXffQ52aNPw/Ltk39Itsa12aeE2MyDf0jH2gUEhftXcrLuirHfeOqwjmx
        +n9nTipcdOH4F6vuqYeKgov7j4kx2Aaaxjdfn3R3Oruj8qc/1TWfHC+12ryTrzZw5Xkedijm
        Fs+8P1XTlVUdlwbmVDcJ36vMjTjBHxNziCfzfsPFWs9jC+Q/O20KuCNz9uyMyA+NP3K+OPu8
        Odl+/tUU+5YXoZG1ZhnMXyRqHu3eIV5m8TWTdXfrZ3Xt1dcT5t2aJL2l6E7DM6NgP5lb37cn
        iPgF7GmYIvROiaU4I9FQi7moOBEADptnMycDAAA=
X-CMS-MailID: 20210917065523epcas2p1215e9f56482339ca8a9346a0ac2bfe23
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210917065523epcas2p1215e9f56482339ca8a9346a0ac2bfe23
References: <20210917065436.145629-1-chanho61.park@samsung.com>
        <CGME20210917065523epcas2p1215e9f56482339ca8a9346a0ac2bfe23@epcas2p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds setup_clocks callback to control/gate clocks by ufshcd.
To avoid calling before initialization, it needs to check whether ufs is
null or not and call it initially from pre_link callback.

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 627edef4fbeb..2024e44a09d7 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -795,6 +795,27 @@ static void exynos_ufs_config_intr(struct exynos_ufs *ufs, u32 errs, u8 index)
 	}
 }
 
+static int exynos_ufs_setup_clocks(struct ufs_hba *hba, bool on,
+				   enum ufs_notify_change_status status)
+{
+	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
+
+	if (!ufs)
+		return 0;
+
+	if (on) {
+		if (ufs->opts & EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL)
+			exynos_ufs_disable_auto_ctrl_hcc(ufs);
+		exynos_ufs_ungate_clks(ufs);
+	} else {
+		exynos_ufs_gate_clks(ufs);
+		if (ufs->opts & EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL)
+			exynos_ufs_enable_auto_ctrl_hcc(ufs);
+	}
+
+	return 0;
+}
+
 static int exynos_ufs_pre_link(struct ufs_hba *hba)
 {
 	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
@@ -813,6 +834,8 @@ static int exynos_ufs_pre_link(struct ufs_hba *hba)
 	exynos_ufs_config_phy_time_attr(ufs);
 	exynos_ufs_config_phy_cap_attr(ufs);
 
+	exynos_ufs_setup_clocks(hba, true, POST_CHANGE);
+
 	if (ufs->drv_data->pre_link)
 		ufs->drv_data->pre_link(ufs);
 
@@ -1203,6 +1226,7 @@ static struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.hce_enable_notify		= exynos_ufs_hce_enable_notify,
 	.link_startup_notify		= exynos_ufs_link_startup_notify,
 	.pwr_change_notify		= exynos_ufs_pwr_change_notify,
+	.setup_clocks			= exynos_ufs_setup_clocks,
 	.setup_xfer_req			= exynos_ufs_specify_nexus_t_xfer_req,
 	.setup_task_mgmt		= exynos_ufs_specify_nexus_t_tm_req,
 	.hibern8_notify			= exynos_ufs_hibern8_notify,
-- 
2.33.0

