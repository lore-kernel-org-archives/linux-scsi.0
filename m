Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DB77C11F66
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 06:58:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69ED46138C
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 06:58:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbhGIHAr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 03:00:47 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:50555 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbhGIHAi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 03:00:38 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210709065754epoutp03af41a341b498938ab50677781cd7727b~QDRrQkuE02635126351epoutp03Q
        for <linux-scsi@vger.kernel.org>; Fri,  9 Jul 2021 06:57:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210709065754epoutp03af41a341b498938ab50677781cd7727b~QDRrQkuE02635126351epoutp03Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1625813874;
        bh=zbOxj+UmYSh5pQSL6yKZydj6rcicjcrAGWECl8UX5MI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mpxqMU3TlunDVh31qFSuRrSOnXWJsrfED3lXEkCPh9cVT36waPml5otj4zNU1oe4z
         ABazl7bB/i1HhXTh4ooLeXUzVD56luNx2soGkAf8oJinev0x8NiuGplQPXzRcEfqlf
         fngLZc8Ve+tdkxauZfhCv7CtoGidv8S0RWgM/aDg=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210709065752epcas2p322c3d88b2f038cfb96c8a21a8c9e0381~QDRptXlfU2002520025epcas2p3L;
        Fri,  9 Jul 2021 06:57:52 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.190]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4GLkWK4bmtz4x9QN; Fri,  9 Jul
        2021 06:57:49 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        00.E4.09541.C63F7E06; Fri,  9 Jul 2021 15:57:48 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210709065747epcas2p483ee186906567e9e61a2a2c10209fc79~QDRkuNdHm0617006170epcas2p4u;
        Fri,  9 Jul 2021 06:57:47 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210709065747epsmtrp2b4695e2f87f7844a58157a24d7e0a2b6~QDRktYbvK0268602686epsmtrp29;
        Fri,  9 Jul 2021 06:57:47 +0000 (GMT)
X-AuditID: b6c32a46-0abff70000002545-6d-60e7f36c0480
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        11.C7.08289.B63F7E06; Fri,  9 Jul 2021 15:57:47 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210709065747epsmtip273414fe2f73bebf5a8f98e6f4f8db7e7~QDRkeriTP3177431774epsmtip2h;
        Fri,  9 Jul 2021 06:57:47 +0000 (GMT)
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
Subject: [PATCH 13/15] scsi: ufs: ufs-exynos: support exynosauto v9 ufs
 driver
Date:   Fri,  9 Jul 2021 15:57:09 +0900
Message-Id: <20210709065711.25195-14-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709065711.25195-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDJsWRmVeSWpSXmKPExsWy7bCmqW7O5+cJBr/n8lmcfLKGzeLBvG1s
        Fi9/XmWzmPbhJ7PFp/XLWC0u79e26NnpbHF6wiImiyfrZzFbLLqxjcli5TULi5tbjrJYzDi/
        j8mi+/oONovlx/8xOfB7XL7i7XG5r5fJY/MKLY/Fe14yeWxa1cnmMWHRAUaPj09vsXj0bVnF
        6PF5k5xH+4FupgCuqBybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFsl
        F58AXbfMHKAXlBTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2SqkFKTkFhoYFesWJucWleel6
        yfm5VoYGBkamQJUJORnz9+9hLPihWnF04SzWBsYL8l2MnBwSAiYSD998Y+1i5OIQEtjBKHF7
        YguU84lR4vT2XhYI5zOjxJVpnUwwLe9ubWSCSOxilNj14hdU1UdGiasXjrCDVLEJ6Epsef6K
        ESQhItDPKLF8/1ywKmaBk8wSpxccBKsSFgiQ+L5nDTOIzSKgKvGiYSoLiM0rYC/xa8YPFoh9
        8hKnlh0E280JFJ/3YwITRI2gxMmZT8BqmIFqmrfOZgZZICFwhEPi0eO9zBDNLhJTH86BsoUl
        Xh3fwg5hS0l8freXDaKhm1Gi9dF/qMRqRonORh8IG+iK6VuA4cEBtEFTYv0ufRBTQkBZ4sgt
        qL18Eh2H/7JDhHklOtqEIBrVJQ5snw51vqxE95zPrBC2h8TdEwegoTWJUeLr3E7mCYwKs5C8
        MwvJO7MQFi9gZF7FKJZaUJybnlpsVGCEHMmbGMHJWsttB+OUtx/0DjEycTAeYpTgYFYS4TWa
        8SxBiDclsbIqtSg/vqg0J7X4EKMpMLAnMkuJJucD80VeSbyhqZGZmYGlqYWpmZGFkjgvB/uh
        BCGB9MSS1OzU1ILUIpg+Jg5OqQYm8wO8xhHi1kfnHe2WXHe1Ny7yS+6fTRGP7LYG58z5bGat
        7FK42P1i1u1LizXftQj3ncx/qRW861vY8ezDNcfTc6er2ea5132yL14vsaAvwf1o6snL//8m
        ycVUzpzdJGtovauSwyllKnf+77Y0c4+OzarKeV8Kj9gVM7skvpmn+bu/WzfhCpPz0hCruemm
        y1UjQyyeHJJ4b32mNOFUKL+mk9Hud89cl7ff4b0e92/Ko/sna5caSIn/Y7Fo/NDi9dD+j2RX
        3jKJebFbF21/ZTx/uavdO5t1EUkBM9jMgrr9POc9nOvbbyk4Wb1tlrfUCaYtxjc+qhQusdQw
        vJln6rb7j536uaDaTfvEZNdz9CuxFGckGmoxFxUnAgCz+Wi4XwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42LZdlhJXjf78/MEg7PtnBYnn6xhs3gwbxub
        xcufV9kspn34yWzxaf0yVovL+7UtenY6W5yesIjJ4sn6WcwWi25sY7JYec3C4uaWoywWM87v
        Y7Lovr6DzWL58X9MDvwel694e1zu62Xy2LxCy2PxnpdMHptWdbJ5TFh0gNHj49NbLB59W1Yx
        enzeJOfRfqCbKYArissmJTUnsyy1SN8ugStj/v49jAU/VCuOLpzF2sB4Qb6LkZNDQsBE4t2t
        jUxdjFwcQgI7GCXu/z7FCpGQlXj2bgc7hC0scb/lCCtE0XtGic3P1rOAJNgEdCW2PH/FCGKL
        CExklFhyTwykiFngMrPEt2lXmEESwgJ+Er+u7QKbxCKgKvGiYSpYM6+AvcSvGT9YIDbIS5xa
        dpAJxOYEis/7MQHMFhKwk7i3YR87RL2gxMmZT8DqmYHqm7fOZp7AKDALSWoWktQCRqZVjJKp
        BcW56bnFhgVGeanlesWJucWleel6yfm5mxjBEaWltYNxz6oPeocYmTgYDzFKcDArifAazXiW
        IMSbklhZlVqUH19UmpNafIhRmoNFSZz3QtfJeCGB9MSS1OzU1ILUIpgsEwenVANTVvKaQ4J3
        maZNUNvO8DsoNzOx09JGfsEfNucJ+Y8OLdR0tvu4yeLqxmkXa2+uzr5pb6NSkemdo65jPjHa
        7ljeKY/SOZm1PKLzXr28P83C/cD07VvSj3/xvdVSyn97gpLcFN6TNinaBRIu2368XVHCsnHz
        Ut55ZaKL9njX/2gPNLihX7ugfNrUN5NLdwptVrp7JVGx2E5rw8K7kTNCc+QPZiyyELLOePt2
        icmqXNfPfjP4TVZcEVJKZFYyld5yfPXsW8/qa19cuXXiqu+SBzNcFZRWbTok/HazeNFSWe6T
        pfZbFReJdZa6qoXMe3Zf9cyPsrez/3ZeXcGo8f2Jr+p6430+tntr8t2a5z7Iv2AroMRSnJFo
        qMVcVJwIAC2Wz4IXAwAA
X-CMS-MailID: 20210709065747epcas2p483ee186906567e9e61a2a2c10209fc79
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210709065747epcas2p483ee186906567e9e61a2a2c10209fc79
References: <20210709065711.25195-1-chanho61.park@samsung.com>
        <CGME20210709065747epcas2p483ee186906567e9e61a2a2c10209fc79@epcas2p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds to support ufs variant for ExynosAuto v9 SoC. This
requires control UFS IP sharability register via syscon and regmap.
Regarding uic_attr, most of values can be shared with exynos7 except
tx_dif_p_nsec value.

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 97 +++++++++++++++++++++++++++++++++++
 1 file changed, 97 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 9669afe8f1f4..82f915f7a447 100644
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
 
+/* FSYS UFS Sharability */
+#define UFS_WR_SHARABLE		BIT(2)
+#define UFS_RD_SHARABLE		BIT(1)
+#define UFS_SHARABLE		(UFS_WR_SHARABLE | UFS_RD_SHARABLE)
+#define UFS_SHARABILITY_OFFSET	0x710
+
 enum {
 	UNIPRO_L1_5 = 0,/* PHY Adapter */
 	UNIPRO_L2,	/* Data Link */
@@ -151,6 +158,80 @@ static int exynos7_ufs_drv_init(struct device *dev, struct exynos_ufs *ufs)
 	return 0;
 }
 
+static int exynosauto_ufs_drv_init(struct device *dev, struct exynos_ufs *ufs)
+{
+	struct exynos_ufs_uic_attr *attr = ufs->drv_data->uic_attr;
+
+	/* IO Coherency setting */
+	if (ufs->sysreg) {
+		return regmap_update_bits(ufs->sysreg, UFS_SHARABILITY_OFFSET,
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
+
 static int exynos7_ufs_pre_link(struct exynos_ufs *ufs)
 {
 	struct ufs_hba *hba = ufs->hba;
@@ -1305,6 +1386,20 @@ static struct exynos_ufs_uic_attr exynos7_uic_attr = {
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
@@ -1330,6 +1425,8 @@ static struct exynos_ufs_drv_data exynos_ufs_drvs = {
 static const struct of_device_id exynos_ufs_of_match[] = {
 	{ .compatible = "samsung,exynos7-ufs",
 	  .data	      = &exynos_ufs_drvs },
+	{ .compatible = "samsung,exynosautov9-ufs",
+	  .data	      = &exynosauto_ufs_drvs },
 	{},
 };
 
-- 
2.32.0

