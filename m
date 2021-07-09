Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE2B5C11F66
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 06:58:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91A5461260
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 06:58:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbhGIHAp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 03:00:45 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:50495 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbhGIHAg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 03:00:36 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210709065752epoutp0366272fcc660680b99491d9854fc8f5a1~QDRpUhFzU2649126491epoutp03H
        for <linux-scsi@vger.kernel.org>; Fri,  9 Jul 2021 06:57:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210709065752epoutp0366272fcc660680b99491d9854fc8f5a1~QDRpUhFzU2649126491epoutp03H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1625813872;
        bh=lPjKT2sdwH5u1saDOnglau/QBljiZVmbk8LSDc00gVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HgHsKUDHuCswqK2VlcRCf4/o3eyyLIN5RkeqqeUjXdeYvCDij/5wGiB5542x6KBUz
         P7nnETc8M41DuZPdScdrMMX5HnFpykIkW+ElgDXLPp1CAC1SbcYq32Fqr6X98Q5ouG
         VXRtgBya8V3KhvV99lfxhnA9pu9zwH7Ulb89tm8o=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210709065751epcas2p4a38eb68596a2c0e7e940216d7cc7daff~QDRoXGw_J1603316033epcas2p4s;
        Fri,  9 Jul 2021 06:57:51 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.186]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4GLkWK0sYvz4x9Q6; Fri,  9 Jul
        2021 06:57:49 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        FE.D4.09541.C63F7E06; Fri,  9 Jul 2021 15:57:48 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20210709065747epcas2p10c59e097d9770fc02134cb0545c9de4f~QDRkvBeNh0966009660epcas2p1U;
        Fri,  9 Jul 2021 06:57:47 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210709065747epsmtrp2f787afabed861331eebf45a8202a2ecd~QDRkuP03K0268602686epsmtrp2_;
        Fri,  9 Jul 2021 06:57:47 +0000 (GMT)
X-AuditID: b6c32a46-095ff70000002545-6c-60e7f36c13c5
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        12.C7.08289.B63F7E06; Fri,  9 Jul 2021 15:57:47 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210709065747epsmtip22bce66bcc6238cd58308f42c295e1aa9~QDRkjfEUW3134631346epsmtip20;
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
Subject: [PATCH 14/15] scsi: ufs: ufs-exynos: multi-host configuration for
 exynosauto
Date:   Fri,  9 Jul 2021 15:57:10 +0900
Message-Id: <20210709065711.25195-15-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709065711.25195-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02TfUxTVxjGd+5tLwWHXgrMYxO0FJXAKNBu7Q4GphsMbyZkbCaTzCXQwB0w
        bz/SW9zQLdE5ZmuddiC0Q1E+Mpi4rRUKMuZGqTig/cMlfOgofmE3wCgByYxsGa7lYsZ/v/O+
        z5PnvOdDgAs9hEhQpjHQeo2KkRBhvK4rCUjKLEwVplY+wdGQ/zsC3TnbRaCZxVEC1c4t4uiR
        vYWPhntfRMd/zEReSxOG/PY6HDXd6MLQ+TGEfnde5SHbtV8wZL7eTaDWgSVsxzpqeGQXNXzi
        S4zq+DaRar48g1HtbSaCsjS5ADX/xziPOuFsA9RC+0bqqMuM5YW9x6SX0qpiWi+mNUXa4jJN
        SYZk1+6CzAKFMlUmlaWhVyRijUpNZ0iycvKk2WVMYASJeL+KKQ+U8lQsK0l5NV2vLTfQ4lIt
        a8iQ0LpiRieT6ZJZlZot15QkF2nV22SpqXJFQFnIlFq6z/B0no0fj461gkOgacMxECqA5MvQ
        VGPjHQNhAiHZDeCRzglesCEkHwE4ubSf4wUAx29HPDM4fK4QztADoK/zFp9bzAP4udeLB1UE
        KYXOqfsg2IgiTwLY2lu/nIGTQzj0NvSFBFWR5B442DwFgswjt8Dq3sZlDie3w8oJI8blbYKe
        lr5lDg3Uzz6xYJwmAg597V/eKx7QHOk8jQcDIOkSQOvMNwRnzoL1ff0rHAnvDzhDOBbBhdmf
        Cc5gBrBy8ulK4wKApsM5HG+Hf1udgeEEgYQEaO9JCSIk42D/+EruWmi88m8IVw6Hxi+EnDEe
        ui5ZeRzHQPOZBT7HFLxonyO406oC8MFiL24B4rpV49StGqfu/+AGgLeBF2gdqy6hWblOvvqK
        28Hyo07M7ganHs4luwEmAG4ABbgkKlxu+7NQGF6sqjhA67UF+nKGZt1AETjsr3BRdJE28Cs0
        hgKZQq5UpqYpkEIpR5L14YIQd6GQLFEZ6H00raP1z3yYIFR0CMtaM/1D3F2/vj7eou5aEu7s
        2ER8ypxyxN7Jd/zkVbiy3PsORt7I7W7F5jqr0ncrq0dsTd7Do0efz57IPP64evOg/PxrMY/f
        Ff52yXZ9Xeb6UePrBsvFv+bf2Fs/ODLZdy1KOjP9sFb5dmPsyarba6b8/uQd0Qrf6QPevLtz
        L419UvM0oWf61ls78z17mXO6+I9y/dVEhO+fvKqkqZEJU05Fw6+52f1jUfecG6zPOaTT7/hy
        yT1Xm2cB/958RVZSmr1mlnTEddTKWq0X3uz9IL8abSUpR6Mp5zOZKSW2p6Uinx99073V6gpd
        C5iDSUb7g203t8T08S+/7/nw+4iBAiAyp0h4bKlKlojrWdV/I720510EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42LZdlhJXjf78/MEg/eXeC1OPlnDZvFg3jY2
        i5c/r7JZTPvwk9ni0/plrBaX92tb9Ox0tjg9YRGTxZP1s5gtFt3YxmSx8pqFxc0tR1ksZpzf
        x2TRfX0Hm8Xy4/+YHPg9Ll/x9rjc18vksXmFlsfiPS+ZPDat6mTzmLDoAKPHx6e3WDz6tqxi
        9Pi8Sc6j/UA3UwBXFJdNSmpOZllqkb5dAlfGhB1zWApOyVVcvbacsYFxkWQXIyeHhICJxIbb
        B9i7GLk4hAR2MEos2reQESIhK/Hs3Q52CFtY4n7LEVaIoveMEg+2fGcDSbAJ6Epsef4KrEFE
        YCKjxJJ7YiBFzAKXmSW+TbvC3MXIwSEsECrx4mcsSA2LgKrE5P0QC3gF7CVa73QwQSyQlzi1
        7CCYzQkUn/djApgtJGAncW/DPnaIekGJkzOfsIDYzED1zVtnM09gFJiFJDULSWoBI9MqRsnU
        guLc9NxiwwKjvNRyveLE3OLSvHS95PzcTYzgeNLS2sG4Z9UHvUOMTByMhxglOJiVRHiNZjxL
        EOJNSaysSi3Kjy8qzUktPsQozcGiJM57oetkvJBAemJJanZqakFqEUyWiYNTqoGpWmb+5bni
        ckqOSzi0TzoZzmA4sFmklOM8f/2ssl7V619vBJlGKGm9dmtY413OwbukWG2e+e1+Y778aSdZ
        jc20XL4VGGjtnu/U4z3ZXcPLX/Eji8bqlu1bDAwbTwVrrePsTWgJkGpiK5DasHvNghkPbRV1
        /GOtntZuqpHZLcHnITP7kUXCR23rLwL/13ZWyv8vYK24OLfJuyWux3ml8K6SBDv39fyHGg/8
        Z931UeC0UmmTWJHiucpTuXJb3bbt3vfI5cK5+4bsTILm/2ze3vDrcelJ0Y3oUQgIejT3Ae+M
        mt/eXHuuZpyyuBTmWyCm/bTh8jXvZcbsmx9V+tfJ7j4kfyPSTUPzeDOL2DoRJZbijERDLeai
        4kQAA5wb6xYDAAA=
X-CMS-MailID: 20210709065747epcas2p10c59e097d9770fc02134cb0545c9de4f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210709065747epcas2p10c59e097d9770fc02134cb0545c9de4f
References: <20210709065711.25195-1-chanho61.park@samsung.com>
        <CGME20210709065747epcas2p10c59e097d9770fc02134cb0545c9de4f@epcas2p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UFS controller of ExynosAuto v9 SoC supports multi-host interface for I/O
virtualization. In general, we're using para-virtualized driver to
support a block device by several virtual machines. However, it should
be relayed by backend driver. Multi-host functionality extends the host
controller by providing register interfaces that can be used by each
VM's ufs drivers respectively. By this, we can provide direct access to
the UFS device for multiple VMs. It's similar with SR-IOV of PCIe.

We divide this M-HCI as PH(Physical Host) and VHs(Virtual Host). The PH
supports all UFSHCI functions(all SAPs) same as conventional UFSHCI but
the VH only supports data transfer function. Thus, except UTP_CMD_SAP and
UTP_TMPSAP, the PH should handle all the physical features.

This patch provides an initial implementation of PH part. M-HCI can
support up to four interfaces but this patch initially supports only 1
PH and 1 VH. For this, we uses TASK_TAG[7:5] field so TASK_TAG[4:0] for
32 doorbel will be supported. After the PH is initiated, this will send
a ready message to VHs through a mailbox register. The message handler
is not fully implemented yet such as supporting reset / abort cases.

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 44 +++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 82f915f7a447..30c12e97c665 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -83,6 +83,21 @@
 #define UFS_SHARABLE		(UFS_WR_SHARABLE | UFS_RD_SHARABLE)
 #define UFS_SHARABILITY_OFFSET	0x710
 
+/* Multi-host registers */
+#define MHCTRL					0xC4
+#define MHCTRL_EN_VH_MASK			(0xE)
+#define MHCTRL_EN_VH(vh)			(vh << 1)
+#define PH2VH_MBOX				0xD8
+
+#define MH_MSG_MASK				(0xFF)
+
+#define MH_MSG(id, msg)				((id << 8) | (msg & 0xFF))
+#define MH_MSG_PH_READY				0x1
+#define MH_MSG_VH_READY				0x2
+
+#define HCI_MH_ALLOWABLE_TRAN_OF_VH		0x30C
+#define HCI_MH_IID_IN_TASK_TAG			0X308
+
 enum {
 	UNIPRO_L1_5 = 0,/* PHY Adapter */
 	UNIPRO_L2,	/* Data Link */
@@ -173,6 +188,20 @@ static int exynosauto_ufs_drv_init(struct device *dev, struct exynos_ufs *ufs)
 	return 0;
 }
 
+static int exynosauto_ufs_post_hce_enable(struct exynos_ufs *ufs)
+{
+	struct ufs_hba *hba = ufs->hba;
+
+	/* Enable Virtual Host #1 */
+	ufshcd_rmwl(hba, MHCTRL_EN_VH_MASK, MHCTRL_EN_VH(1), MHCTRL);
+	/* Default VH Transfer permissions */
+	hci_writel(ufs, 0x03FFE1FE, HCI_MH_ALLOWABLE_TRAN_OF_VH);
+	/* IID information is replaced in TASKTAG[7:5] instead of IID in UCD */
+	hci_writel(ufs, 0x1, HCI_MH_IID_IN_TASK_TAG);
+
+	return 0;
+}
+
 static int exynosauto_ufs_pre_link(struct exynos_ufs *ufs)
 {
 	struct ufs_hba *hba = ufs->hba;
@@ -231,6 +260,19 @@ static int exynosauto_ufs_pre_pwr_change(struct exynos_ufs *ufs,
 	return 0;
 }
 
+static int exynosauto_ufs_post_pwr_change(struct exynos_ufs *ufs,
+					  struct ufs_pa_layer_attr *pwr)
+{
+	struct ufs_hba *hba = ufs->hba;
+	u32 enabled_vh;
+
+	enabled_vh = ufshcd_readl(hba, MHCTRL) & MHCTRL_EN_VH_MASK;
+
+	/* Send physical host ready message to virtual hosts */
+	ufshcd_writel(hba, MH_MSG(enabled_vh, MH_MSG_PH_READY), PH2VH_MBOX);
+
+	return 0;
+}
 
 static int exynos7_ufs_pre_link(struct exynos_ufs *ufs)
 {
@@ -1396,8 +1438,10 @@ static struct exynos_ufs_drv_data exynosauto_ufs_drvs = {
 				  EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR |
 				  EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX,
 	.drv_init		= exynosauto_ufs_drv_init,
+	.post_hce_enable	= exynosauto_ufs_post_hce_enable,
 	.pre_link		= exynosauto_ufs_pre_link,
 	.pre_pwr_change		= exynosauto_ufs_pre_pwr_change,
+	.post_pwr_change	= exynosauto_ufs_post_pwr_change,
 };
 
 static struct exynos_ufs_drv_data exynos_ufs_drvs = {
-- 
2.32.0

