Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 126DDC11F77
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 07:12:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC05A613AA
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 07:12:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238215AbhGNHPI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 03:15:08 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:21284 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238230AbhGNHO7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 03:14:59 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210714071204epoutp03e5a8a587e31888ffdffd1e28980cd59c~RlsedRMqP1952519525epoutp03_
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2021 07:12:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210714071204epoutp03e5a8a587e31888ffdffd1e28980cd59c~RlsedRMqP1952519525epoutp03_
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1626246724;
        bh=MmUgXvX/NpKO8lAywWMapzDS9Zdw8SpjRt0eU0Szou0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RhuGF2R2yO9zU9zGLoFiwkNCK44Ec4f1XZLSJFaNuQB4/2H159YD8+7GF1Ov5Hz4B
         2Pt8ed2h1hcT7tUS5xdb+iH1EOl3H+pmuqzm+H2h9QrkEquQjndZ8+vUQ8AuQSXn4U
         oX0r+qw2ms1pdZAslFYojEUpVfEQWSIw5j1pjDIg=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210714071203epcas2p3ede78124bb1b8c601e646ae21207008d~RlsdxprqL2479924799epcas2p3F;
        Wed, 14 Jul 2021 07:12:03 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.183]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4GPpbN3vHyz4x9Q7; Wed, 14 Jul
        2021 07:12:00 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        46.42.09921.04E8EE06; Wed, 14 Jul 2021 16:12:00 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20210714071200epcas2p199f4f7b209e565c9a87440af319acda1~RlsaPPMf00378503785epcas2p1P;
        Wed, 14 Jul 2021 07:12:00 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210714071159epsmtrp132b31cd8928bc18899726060bb517692~RlsaLue9v1252112521epsmtrp1K;
        Wed, 14 Jul 2021 07:11:59 +0000 (GMT)
X-AuditID: b6c32a45-fb3ff700000026c1-0f-60ee8e405c13
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        18.43.08394.F3E8EE06; Wed, 14 Jul 2021 16:11:59 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210714071159epsmtip256806448f4e384e6ef7dcc09e6b467f7~RlsZ-Wbhq1845718457epsmtip2z;
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
Subject: [PATCH v2 13/15] scsi: ufs: ufs-exynos: support exynosauto v9 ufs
 driver
Date:   Wed, 14 Jul 2021 16:11:29 +0900
Message-Id: <20210714071131.101204-14-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210714071131.101204-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xbVRzHc+69tBe05q4gntVXd41uwxTauuIFKZCwx3XgQtwfG5jZ1nJH
        G0vb9YHvOB5uQDfAEbcJjFS6lYkzIKsMjNuguBQsExIcMAwZICqFbAOGIoWBLbeL/Pf5Pb7n
        m9/vnIOj/D6OANfqLYxJr9KRnAistWu7TJRafk8pHhoSUD2TlzjUWF0rh/It3eJQp2eXUGq+
        yRlGDVx/mTrRnkZ5K+sRarKpGqXqh1sR6utBiurra+ZSt103MOps3zWEsg21cagGzyqSStAD
        v6bTA+UnEfryxRja8aMPoVsaSzl0ZX0HoOf+GMHoclcjoB+0PEcf77AhmRHZuiQNo8phTEJG
        rzbkaPW5cjJ9vyJNIYsXS0SSBOpVUqhX5TFycmdGpmi3VheYgxTmq3TWQCpTZTaTcclJJoPV
        wgg1BrNFTjLGHJ1RIjHGmlV5Zqs+N1ZtyEuUiMVSWaBTqdMUVM6jxuKY94+7U46CNbIMhOOQ
        2AEvnipEykAEzifaALxw04mxwTyAtpPFHDb4B8De88PoI8mSZygkuQpge2E3N1jgE3MArtUc
        CDKHEEHXX9Mg2BQVPLfRMbp+Lkr0oNBr71xXRBL74Vf9y5wgY8SL8NvCqXULHpEK/WOFIbvn
        4c/OTiTI4YF8Z/MsYHs2wZ4vJ7Ego4Geou9r0KABJHpxeH/qDsKKd0LPn6tcliPhtMcVYgH0
        VRzjsgIbgJ9NrIUK3wBYWpDBcgr0n3GFlQE84LAdNv0QF0RIvAB/Ggn5PgFLuh5y2TQPlhzj
        s8KtsOPKGYzlZ6Gt9kEYyzR0OTyh/VYBeGmqDakEwuoN41RvGKf6f2M7QBtBNGM05+UyZqlR
        svGKW8D6y47Z1Qaq7s7GugGCAzeAOEpG8S5I7yr5vBzVBx8yJoPCZNUxZjeQBZb9OSp4Um0I
        fA29RSGRSePjxQkyShYvpcineDjXreQTuSoL8y7DGBnTIx2ChwuOIpEVFQuij+OcyVkLe5uN
        NTeTXAjXufWLXfLNo+/1YSXIMzz81Mh49Eub90RaehVuf6xgTRnXH5M6tePcOzNEvNHwemNL
        0r/ZxMHVuu8U1dptyYn2goM1h3arl27d29c/mC+U7zFK3khYHLE/XPFrkY98umikYdP44NWU
        LdrHEt/M+H155hXvZWf/obPDmqLY8tfqG7oONw8XXy8Xv9VpWDzyW5V1YaJ3798HfD2HsweZ
        lYJFVDPmOu19W5qmqE0fNSW3Z23bNycKu/G0S3LNMGBrPdFxn/h0FXN0Y8O/qHnzjokie3hp
        /u3xK46sKn/tynS398jjd5ajSj85VzpjO2+vIzGzRiWJQU1m1X8yESOSYgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42LZdlhJXte+712CwaTZphYnn6xhs3gwbxub
        xcufV9kspn34yWzxaf0yVovL+7UtenY6W5yesIjJ4sn6WcwWi25sY7JYec3C4vz5DewWN7cc
        ZbGYcX4fk0X39R1sFsuP/2NyEPC4fMXb43JfL5PH5hVaHov3vGTy2LSqk81jwqIDjB4fn95i
        8ejbsorR4/MmOY/2A91MAVxRXDYpqTmZZalF+nYJXBmNEz4xF7RoVbQfsm9g/K/UxcjJISFg
        IvHz+HWmLkYuDiGB3YwSHfMeM0EkZCWevdvBDmELS9xvOcIKUfSeUeL+uv9sIAk2AV2JLc9f
        MYIkRAR2MUocPnOYHcRhFrjMLPFt2hVmkCphgUCJNy/vM4LYLAKqEmubXoDFeQUcJH49aGKG
        WCEvcWrZQbDVnEDxgxs+gNULCdhL/Nu2mg2iXlDi5MwnLCA2M1B989bZzBMYBWYhSc1CklrA
        yLSKUTK1oDg3PbfYsMAwL7Vcrzgxt7g0L10vOT93EyM4trQ0dzBuX/VB7xAjEwfjIUYJDmYl
        Ed6lRm8ThHhTEiurUovy44tKc1KLDzFKc7AoifNe6DoZLySQnliSmp2aWpBaBJNl4uCUamDS
        8bHeLbvo98vKWNk6++3uYds68t9YBB2M9mHUYq2c9LN7593v/HzsYcd3q9zzuLbq6RzvKZKr
        FAuvRf7TO7ysrMV9l6igqfXLE7NLhcyTn+zd/KnbfG5CPWv+ohfafNwbjjfEsfee3/71lH+D
        gQt78nGD2rRXgSUnPlyL5wx7FOByqnJ+sPXDdeVfTjDFb82798oobObK6X8nxrO73OJd0rNb
        zv21t4lyyk0Dn0wJXT79xpcPtA0Wz8q9c2XO5pTWL9/jFhzrf6BUqMTx86uyvJr6LPfPeZtV
        tA8sKpiUz6S67UzdpYTjlxrVo+5JT/i4NXuVxtKLoqEOnDcOHVBr27+gPyuAKfeN8LQTlguU
        WIozEg21mIuKEwGtCctcHAMAAA==
X-CMS-MailID: 20210714071200epcas2p199f4f7b209e565c9a87440af319acda1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210714071200epcas2p199f4f7b209e565c9a87440af319acda1
References: <20210714071131.101204-1-chanho61.park@samsung.com>
        <CGME20210714071200epcas2p199f4f7b209e565c9a87440af319acda1@epcas2p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds to support ufs variant for ExynosAuto v9 SoC. This
requires control UFS IP sharability register via syscon and regmap.
Regarding uic_attr, most of values can be shared with exynos7 except
tx_dif_p_nsec value.

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 .../bindings/ufs/samsung,exynos-ufs.yaml      |  1 +
 drivers/scsi/ufs/ufs-exynos.c                 | 96 +++++++++++++++++++
 2 files changed, 97 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
index d3e31b23b62d..fa5247c4a44f 100644
--- a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
@@ -20,6 +20,7 @@ properties:
   compatible:
     enum:
       - samsung,exynos7-ufs
+      - samsung,exynosautov9-ufs
 
   reg:
     items:
diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 9669afe8f1f4..200137e6ecce 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -15,6 +15,7 @@
 #include <linux/mfd/syscon.h>
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
+#include <linux/regmap.h>
 
 #include "ufshcd.h"
 #include "ufshcd-pltfrm.h"
@@ -76,6 +77,12 @@
 				 UIC_TRANSPORT_NO_CONNECTION_RX |\
 				 UIC_TRANSPORT_BAD_TC)
 
+/* FSYS UFS Shareability */
+#define UFS_WR_SHARABLE		BIT(2)
+#define UFS_RD_SHARABLE		BIT(1)
+#define UFS_SHARABLE		(UFS_WR_SHARABLE | UFS_RD_SHARABLE)
+#define UFS_SHAREABILITY_OFFSET	0x710
+
 enum {
 	UNIPRO_L1_5 = 0,/* PHY Adapter */
 	UNIPRO_L2,	/* Data Link */
@@ -151,6 +158,79 @@ static int exynos7_ufs_drv_init(struct device *dev, struct exynos_ufs *ufs)
 	return 0;
 }
 
+static int exynosauto_ufs_drv_init(struct device *dev, struct exynos_ufs *ufs)
+{
+	struct exynos_ufs_uic_attr *attr = ufs->drv_data->uic_attr;
+
+	/* IO Coherency setting */
+	if (ufs->sysreg) {
+		return regmap_update_bits(ufs->sysreg, UFS_SHAREABILITY_OFFSET,
+					  UFS_SHARABLE, UFS_SHARABLE);
+	}
+
+	attr->tx_dif_p_nsec = 3200000;
+
+	return 0;
+}
+
+static int exynosauto_ufs_pre_link(struct exynos_ufs *ufs)
+{
+	struct ufs_hba *hba = ufs->hba;
+	int i;
+
+	ufshcd_dme_set(hba, UIC_ARG_MIB(0x200), 0x40);
+	for_each_ufs_rx_lane(ufs, i) {
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x12, i),
+			       DIV_ROUND_UP(NSEC_PER_SEC, ufs->mclk_rate));
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x11, i), 0x0);
+
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x1b, i), 0x2);
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x1c, i), 0x8a);
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x1d, i), 0xa3);
+
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x1b, i), 0x2);
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x1c, i), 0x8a);
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x1d, i), 0xa3);
+
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x2f, i), 0x79);
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x84, i), 0x1);
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x25, i), 0xf6);
+	}
+
+	for_each_ufs_tx_lane(ufs, i) {
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xaa, i),
+			       DIV_ROUND_UP(NSEC_PER_SEC, ufs->mclk_rate));
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xa9, i), 0x02);
+
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xab, i), 0x8);
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xac, i), 0x22);
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xad, i), 0x8);
+
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x04, i), 0x1);
+	}
+
+	ufshcd_dme_set(hba, UIC_ARG_MIB(0x200), 0x0);
+
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_LOCAL_TX_LCC_ENABLE), 0x0);
+
+	ufshcd_dme_set(hba, UIC_ARG_MIB(0xa011), 0x8000);
+
+	return 0;
+}
+
+static int exynosauto_ufs_pre_pwr_change(struct exynos_ufs *ufs,
+					 struct ufs_pa_layer_attr *pwr)
+{
+	struct ufs_hba *hba = ufs->hba;
+
+	/* PACP_PWR_req and delivered to the remote DME */
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA0), 12000);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA1), 32000);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA2), 16000);
+
+	return 0;
+}
+
 static int exynos7_ufs_pre_link(struct exynos_ufs *ufs)
 {
 	struct ufs_hba *hba = ufs->hba;
@@ -1305,6 +1385,20 @@ static struct exynos_ufs_uic_attr exynos7_uic_attr = {
 	.pa_dbg_option_suite		= 0x30103,
 };
 
+static struct exynos_ufs_drv_data exynosauto_ufs_drvs = {
+	.uic_attr		= &exynos7_uic_attr,
+	.quirks			= UFSHCD_QUIRK_PRDT_BYTE_GRAN |
+				  UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR |
+				  UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR |
+				  UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING,
+	.opts			= EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL |
+				  EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR |
+				  EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX,
+	.drv_init		= exynosauto_ufs_drv_init,
+	.pre_link		= exynosauto_ufs_pre_link,
+	.pre_pwr_change		= exynosauto_ufs_pre_pwr_change,
+};
+
 static struct exynos_ufs_drv_data exynos_ufs_drvs = {
 	.uic_attr		= &exynos7_uic_attr,
 	.quirks			= UFSHCD_QUIRK_PRDT_BYTE_GRAN |
@@ -1330,6 +1424,8 @@ static struct exynos_ufs_drv_data exynos_ufs_drvs = {
 static const struct of_device_id exynos_ufs_of_match[] = {
 	{ .compatible = "samsung,exynos7-ufs",
 	  .data	      = &exynos_ufs_drvs },
+	{ .compatible = "samsung,exynosautov9-ufs",
+	  .data	      = &exynosauto_ufs_drvs },
 	{},
 };
 
-- 
2.32.0

