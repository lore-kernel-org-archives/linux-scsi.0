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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3673AC11F6A
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 07:12:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10425613C2
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 07:12:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238281AbhGNHPA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 03:15:00 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:21030 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238211AbhGNHO6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 03:14:58 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210714071202epoutp032cb958740e8cd1a58d0f64cdd209ecca~Rlsci-3BJ1952519525epoutp035
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2021 07:12:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210714071202epoutp032cb958740e8cd1a58d0f64cdd209ecca~Rlsci-3BJ1952519525epoutp035
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1626246722;
        bh=kLp8JXy2THeuVplpTPaDlDYNhkGSfgHHsgtP8hixo6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mAxIcD5wbvo/+EmyGUetwfeg3IYzfOA4MWiSXM7HVD/tcajcwhwKKzU/dEuZuRZqP
         xsvyhOPPfOyvWVlBL5deNbSAE7uUxD7F4tbq+BYLsQjufwqFtBLsjG5BZg2iEEP3NI
         h6VBVT9eFKQJ3De30bzMkVfeqdY9UoB+bXWczk1Q=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210714071201epcas2p3f38dd696582f064d8722919bf057f0c2~Rlsb3c9bK2291022910epcas2p3Y;
        Wed, 14 Jul 2021 07:12:01 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.187]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4GPpbM6T3wz4x9QC; Wed, 14 Jul
        2021 07:11:59 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        31.42.09921.F3E8EE06; Wed, 14 Jul 2021 16:11:59 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210714071159epcas2p2ae981fb3b91b0eba23060de5de104ec0~RlsZfoYbW1836418364epcas2p2B;
        Wed, 14 Jul 2021 07:11:59 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210714071159epsmtrp224c40fa2c30796e84eb7d3b2ac61cee2~RlsZdT0dZ0755107551epsmtrp2l;
        Wed, 14 Jul 2021 07:11:59 +0000 (GMT)
X-AuditID: b6c32a45-f9dff700000026c1-0c-60ee8e3fac1a
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        63.43.08394.F3E8EE06; Wed, 14 Jul 2021 16:11:59 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210714071158epsmtip2f0c19f0fdc5c5c4779c29d5edf3b471e~RlsZQonon2388323883epsmtip2S;
        Wed, 14 Jul 2021 07:11:58 +0000 (GMT)
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
Subject: [PATCH v2 05/15] scsi: ufs: ufs-exynos: get sysreg regmap for
 io-coherency
Date:   Wed, 14 Jul 2021 16:11:21 +0900
Message-Id: <20210714071131.101204-6-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210714071131.101204-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLJsWRmVeSWpSXmKPExsWy7bCmua5937sEg5f7DSxOPlnDZvFg3jY2
        i5c/r7JZTPvwk9ni0/plrBaX92tb9Ox0tjg9YRGTxZP1s5gtFt3YxmSx8pqFxfnzG9gtbm45
        ymIx4/w+Jovu6zvYLJYf/8fkIOBx+Yq3x+W+XiaPzSu0PBbvecnksWlVJ5vHhEUHGD0+Pr3F
        4tG3ZRWjx+dNch7tB7qZAriicmwyUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTy
        EnNTbZVcfAJ03TJzgP5QUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BQYGhboFSfm
        Fpfmpesl5+daGRoYGJkCVSbkZCxvf8dccECwYuKSz6wNjGv4uhg5OCQETCSWffHsYuTiEBLY
        wSjx+cMSFgjnE6PEzN/L2LoYOYGcb4wSr5p1QWyQhplftjBCFO1llDi58DUrhPMRqL13LxNI
        FZuArsSW56/AqkRA5q5afBdsLrPASWaJ0wsOsoNUCQuESqxYsIIV5BAWAVWJh0fKQcK8AvYS
        0w9sY4FYJy9xatlBsKGcAg4SBzd8YISoEZQ4OfMJWA0zUE3z1tnMIPMlBM5wSJzdtJYZotlF
        4s2ET6wQtrDEq+Nb2CFsKYnP7/ayQTR0M0q0PvoPlVjNKNHZ6ANh20v8mr4F7DhmAU2J9bv0
        IQGmLHHkFtRePomOw3/ZIcK8Eh1tQhCN6hIHtk+HOl9WonvOZ1aIEg+JDRNiIGE1mVFi64sN
        zBMYFWYh+WYWkm9mIexdwMi8ilEstaA4Nz212KjAEDmCNzGC07WW6w7GyW8/6B1iZOJgPMQo
        wcGsJMK71OhtghBvSmJlVWpRfnxRaU5q8SFGU2BQT2SWEk3OB2aMvJJ4Q1MjMzMDS1MLUzMj
        CyVxXg72QwlCAumJJanZqakFqUUwfUwcnFINTPOOHPLWzTr7x0r67RTrkKTs/9t3X+m8bXDs
        WKWy2TuLq/q8y10Nnl6boDA3x7bJwVv2J+uuLol5MXozrD40hoSULfffWOyR7yBpku36Yv6i
        PQfizTkO/5/YMd3nwLOD+febnkj8q1Bra7gduWdyzabO+DeJ9RdvrdvqL6P28fOTxctf+FTt
        vddo+03t7stFFzi1+TLM9NXr3T3v7ePomTPd5l7axCcX9vzoyTmz23ViWtOZ48ynfQOafFT5
        jHID/OSTP2sf3yX9WOPGJOZytSR+4XWdluYKr//a9Lz/2MrbNIv11eVta6Mbp5x8v1Qt38bz
        4rOJN//HLi2s0Ojq27zi8t4uAwPWWNnD61vfeSuxFGckGmoxFxUnAgBlEqa+YAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42LZdlhJXte+712CwZ0DrBYnn6xhs3gwbxub
        xcufV9kspn34yWzxaf0yVovL+7UtenY6W5yesIjJ4sn6WcwWi25sY7JYec3C4vz5DewWN7cc
        ZbGYcX4fk0X39R1sFsuP/2NyEPC4fMXb43JfL5PH5hVaHov3vGTy2LSqk81jwqIDjB4fn95i
        8ejbsorR4/MmOY/2A91MAVxRXDYpqTmZZalF+nYJXBnL298xFxwQrJi45DNrA+Mavi5GTg4J
        AROJmV+2MHYxcnEICexmlJh4+hE7REJW4tm7HVC2sMT9liOsILaQwHtGiT9LSkFsNgFdiS3P
        X4E1iwjsYpQ4fOYwO4jDLHCZWeLbtCvMIFXCAsES2678AUpwcLAIqEo8PFIOEuYVsJeYfmAb
        C8QCeYlTyw4ygdicAg4SBzd8YIRYZi/xb9tqNoh6QYmTM5+A1TMD1Tdvnc08gVFgFpLULCSp
        BYxMqxglUwuKc9Nziw0LDPNSy/WKE3OLS/PS9ZLzczcxgiNLS3MH4/ZVH/QOMTJxMB5ilOBg
        VhLhXWr0NkGINyWxsiq1KD++qDQntfgQozQHi5I474Wuk/FCAumJJanZqakFqUUwWSYOTqkG
        JrE2w4re0JhvR37uFd2dLlCZaPFvygJWE5uVm/6Wu7gyWf/Yz/0tllkv5fAylfyJvJNlJdfv
        57jJy7Ly/3GhR+e+7rRPSCoUuJh258LLhwobHBnMahzajU/mlB66rlQlMdNw7qIZJ1vOCq5p
        mJJcONFtXwTPZ6NCk/B1R1l3GNby3N7IcMnxX2nwbI+udbtVG5dkp//zvH/o5uYHRx617Sx+
        KBJmrfDI73bYOw+Z+/dVP16OY2z7t4g5clH8VT63wwLmxdoh079c8lV21jknytExx9ll1o1J
        r23ji9OCd12tDVf6ua40WvTubTt9b/b9c/MKvKOZroQUPvwU/E9C+IThgj/mm5l6Nb89efzt
        uBJLcUaioRZzUXEiAFMj+RMbAwAA
X-CMS-MailID: 20210714071159epcas2p2ae981fb3b91b0eba23060de5de104ec0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210714071159epcas2p2ae981fb3b91b0eba23060de5de104ec0
References: <20210714071131.101204-1-chanho61.park@samsung.com>
        <CGME20210714071159epcas2p2ae981fb3b91b0eba23060de5de104ec0@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UFS_EMBD sharability register of fsys block provides "sharability"
setting of ufs-exynos. It can be set via syscon and regmap.

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 .../devicetree/bindings/ufs/samsung,exynos-ufs.yaml          | 5 +++++
 drivers/scsi/ufs/ufs-exynos.c                                | 5 +++++
 drivers/scsi/ufs/ufs-exynos.h                                | 1 +
 3 files changed, 11 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
index 38193975c9f1..d3e31b23b62d 100644
--- a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
@@ -54,6 +54,11 @@ properties:
   phy-names:
     const: ufs-phy
 
+  sysreg:
+    $ref: '/schemas/types.yaml#/definitions/phandle'
+    description: phandle for FSYS sysreg interface, used to control
+                 sysreg register bit for UFS IO Coherency
+
 required:
   - compatible
   - reg
diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index db5892901cc0..da02ad3b036c 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
+#include <linux/mfd/syscon.h>
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
 
@@ -906,6 +907,10 @@ static int exynos_ufs_parse_dt(struct device *dev, struct exynos_ufs *ufs)
 		goto out;
 	}
 
+	ufs->sysreg = syscon_regmap_lookup_by_phandle(np, "sysreg");
+	if (IS_ERR(ufs->sysreg))
+		ufs->sysreg = NULL;
+
 	ufs->pclk_avail_min = PCLK_AVAIL_MIN;
 	ufs->pclk_avail_max = PCLK_AVAIL_MAX;
 
diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
index 7bf2053f6e90..a46f30639f38 100644
--- a/drivers/scsi/ufs/ufs-exynos.h
+++ b/drivers/scsi/ufs/ufs-exynos.h
@@ -191,6 +191,7 @@ struct exynos_ufs {
 	struct ufs_phy_time_cfg t_cfg;
 	ktime_t entry_hibern8_t;
 	const struct exynos_ufs_drv_data *drv_data;
+	struct regmap *sysreg;
 
 	u32 opts;
 #define EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL		BIT(0)
-- 
2.32.0

