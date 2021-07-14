Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA49EC11F67
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 07:12:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE75B613AB
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 07:12:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238266AbhGNHO7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 03:14:59 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:21006 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238079AbhGNHO6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 03:14:58 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210714071202epoutp034a5364b4731a263b05106e1781638ab6~RlscMMi9b1985919859epoutp03b
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2021 07:12:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210714071202epoutp034a5364b4731a263b05106e1781638ab6~RlscMMi9b1985919859epoutp03b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1626246722;
        bh=YOZ5BNAbzYTzYNUSuiqBSwuF3vy175tJRdUfBrY/I+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s7lD3mXD9lu9Hy9VkyalayzZmpOkkVWcXCuZFEQNO2qs/G7XiuwVB3sF0bqGHrNFP
         Wd+gU/jA3elW7zji4O1TDh1SuoeNw8Pev82AX66bjLrW7qjYGGC8qATBmHGrN71xfP
         rnTezbubDTqGwHwfVNOqvUjKtxdr2goSykMnJkRc=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210714071201epcas2p11624130d2836aea5c7a0ec4787d240e2~Rlsbf2eyr0389603896epcas2p1-;
        Wed, 14 Jul 2021 07:12:01 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.190]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4GPpbM6Rmxz4x9QK; Wed, 14 Jul
        2021 07:11:59 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        99.3D.09571.F3E8EE06; Wed, 14 Jul 2021 16:11:59 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20210714071159epcas2p3fa23ac2a670e1c31deeac1c9332f76fe~RlsZaNsRO2291022910epcas2p3I;
        Wed, 14 Jul 2021 07:11:59 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210714071159epsmtrp2143a1fa89189a4ef069edc5e723f94ae~RlsZZLk3A0755107551epsmtrp2k;
        Wed, 14 Jul 2021 07:11:59 +0000 (GMT)
X-AuditID: b6c32a48-1f5ff70000002563-05-60ee8e3f4280
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        13.17.08289.E3E8EE06; Wed, 14 Jul 2021 16:11:58 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210714071158epsmtip25c0331498ffa3602859a93afc0435a36~RlsZLsTA52386723867epsmtip2o;
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
Subject: [PATCH v2 04/15] scsi: ufs: ufs-exynos: simplify drv_data retrieval
Date:   Wed, 14 Jul 2021 16:11:20 +0900
Message-Id: <20210714071131.101204-5-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210714071131.101204-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te0xTVxjPube9vbBUr8DcGXtQuugCS7GtFI9GRhmO3AWmZG77g2WDa7nh
        sb7S2/pgi2EYsDxE5oxi3RgDxhTMaGot6GA81AkzBjKqTiciUGYAy6uLwuZgLRcz/vt95/f9
        vt/3feccEg+5QYSTuXoza9IzWikRLHBdjtoiS6iYypTfKFaiXs85Aj2odhFofOEmgU7MLOBo
        rrlBiAY63kDlF5PQ9cpaDHmabTiq/d2FobO3EOrrs4vQHedVAarq+xlDZbdbCfTDtUVMTdED
        7hR6oOIIRp8/E03XtY1jtKOxhKArazsBPTt2V0BXOBsB7XO8Sh/uLMPSgtO123NYJos1SVi9
        xpCVq8+Ol6bszkjKUMXJFTLFVrRFKtEzOjZeuiM1TZacq/XPIZXsZbQW/1Eaw3HSTW9uNxks
        ZlaSY+DM8VLWmKU1KhTGGI7RcRZ9dozGoNumkMuVKn9mpjZnuCPR+Nu6/Q32R0QB+HNNKQgi
        IRUL6x/6QACHUK0A2l3CUhDsx3MA1l84i/GBD0DPYC94ppicX8R4xSU/UXuAT5oFcL7jgTBA
        EJQMOh9OgAARFijbWDcoCAQ41YvD6zVdokBWKJUKv3VWLysE1AbY8pMbLwUkKaYSoK0Q8W4R
        8NeGrmW3IEoNu+wzy12IqXWw95RHEMC4P+fQhdN4oD6k+knoPNZL8OIdsKRgQsjjUDhxzSni
        cTj0TbUTvKAMwKKRpRWiCcCSL1J5nAD/PukUBhrCqSjYfGlTAELqNXjl7orvGmi9/K+IPxZD
        a3EIL3wddracFPD4FVj2tW+lAxoWj5bi/LK+AnB26LCwEkhsq8axrRrH9r9xDcAbwXrWyOmy
        WU5pjF19wQ6w/K6j6VZw2jsT0w0wEnQDSOLSMPH3Sm9miDiLOZDPmgwZJouW5bqByr/rL/Hw
        5zUG/8fQmzMUKmVcnHyrCqnilEj6gpgUdWeGUNmMmf2UZY2s6ZkOI4PCC7D3ery3hmtVETbQ
        Zq1K9+bdcwmKzBGp66dO4WgCDZ6T5E5/k/4ynbz2n6sHLbljFccLqx4bN5a+ve3M06J9R9s/
        DnqpWJ6yeSHxya5HPfhI+dDcZnRcZI3q0i2RWe76Iwpr61DQvvtNde8nEkka052PZOoIMjKW
        mN6ZpkweHZtSOkZs8HPHUv/ShMfDaHb2tYediG1Jnub257lGq7wb1e78affcJ75Rb5R7zwfC
        ezcfLzxXEJoff/8X8/kfM+cPut5pW7Sw+B/je/5atDfnrVWX0/1vFR5qejo8edF6tCky8vbe
        +c9e3FConkzAzI7dUdVX3m1B383URNd/qAl7sutYj1TA5TCKaNzEMf8BRsfcpmAEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42LZdlhJXteu712CwdHfNhYnn6xhs3gwbxub
        xcufV9kspn34yWzxaf0yVovL+7UtenY6W5yesIjJ4sn6WcwWi25sY7JYec3C4vz5DewWN7cc
        ZbGYcX4fk0X39R1sFsuP/2NyEPC4fMXb43JfL5PH5hVaHov3vGTy2LSqk81jwqIDjB4fn95i
        8ejbsorR4/MmOY/2A91MAVxRXDYpqTmZZalF+nYJXBkP9zsWXBKsWLbhDVsD4zO+LkZODgkB
        E4nXP/4xdTFycQgJ7GCUeD3xAgtEQlbi2bsd7BC2sMT9liOsEEXvGSVaN05lBUmwCehKbHn+
        ihEkISKwi1Hi8JnD7CAOs8BlZolv064wg1QJC/hIzN8yD6yDRUBVYvtukDgHB6+AvcSsJguI
        DfISp5YdZAKxOQUcJA5u+MAIYgsBlfzbtpoNxOYVEJQ4OfMJ2HXMQPXNW2czT2AUmIUkNQtJ
        agEj0ypGydSC4tz03GLDAqO81HK94sTc4tK8dL3k/NxNjODI0tLawbhn1Qe9Q4xMHIyHGCU4
        mJVEeJcavU0Q4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuh62S8kEB6YklqdmpqQWoRTJaJg1Oq
        gWlmtugPt+lTnFueCl44LK8oeTn5Iu85LuG8v3ZqfLLvz97Y+jIiaNrKLR2ugqzfft7N6+wU
        2BWx8fCr9dvbzrx7dcF9bZz/tjX8ioe9JgTPfWH5RHRXzY6DvlHxS9e8s2TV8NKoz/3hWpka
        q7t8ZugDaXb/jNeblTkm6S82V45/seifyXEN1bq27/GObB7Hv7bapzpFTJjVlhvRsqB0+qSF
        igfXiWz7dWrbnnnXzbUUZ828m7ftVvDhvzbTNribxoj84WsuPZpvvPRg3gnbZesCGV2kS3Vm
        qjB37mYUS7vUw/jY7+oewVrjQ+ZShrcZqq0n1YZN3sC0QFLNRWdPWMpksV8LJFY1OT3MjzVf
        q6/EUpyRaKjFXFScCABLISQnGwMAAA==
X-CMS-MailID: 20210714071159epcas2p3fa23ac2a670e1c31deeac1c9332f76fe
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210714071159epcas2p3fa23ac2a670e1c31deeac1c9332f76fe
References: <20210714071131.101204-1-chanho61.park@samsung.com>
        <CGME20210714071159epcas2p3fa23ac2a670e1c31deeac1c9332f76fe@epcas2p3.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The compatible field of exynos_ufs_drv_data is not necessary because
of_device_id already has it. Thus, we don't need it anymore and we can
get drv_data by device_get_match_data.

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
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

