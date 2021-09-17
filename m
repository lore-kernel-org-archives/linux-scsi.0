Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DB78C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 06:56:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54C4561130
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 06:56:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238574AbhIQG5Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 02:57:25 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:20519 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237759AbhIQG4y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 02:56:54 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210917065528epoutp022eca53e534a189ed7948b39e9ed6262c~liZh9lU_x3012130121epoutp02Q
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 06:55:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210917065528epoutp022eca53e534a189ed7948b39e9ed6262c~liZh9lU_x3012130121epoutp02Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1631861728;
        bh=2cxtXvSnrsfGtmMqNe57p9BQZ/+NU7OTSJ4Hv/2wzNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UIjyW6K/1cZjQEcdapN6WkafL12wW5NztQnW1wf+GU6tm91Cj/OImsOAx25x5RBy5
         QtJvUp416KfRNFMb/EhWinbzdDxvU8oU3kaNM51kQkP53szWDW5WQletn5nMan7gBV
         VYSlHrS5VWneDeAPUeHU6krrRJrUV8xYD2ii0glM=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210917065527epcas2p4d3167fac34bf2df153f9809adf20c558~liZhM1fzo1927619276epcas2p4_;
        Fri, 17 Sep 2021 06:55:27 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.185]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4H9l8D43w2z4x9Ps; Fri, 17 Sep
        2021 06:55:24 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        DD.ED.09749.CDB34416; Fri, 17 Sep 2021 15:55:24 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20210917065524epcas2p18a720757ef3c4fc08d4bc8d16f9fe7fe~liZeOa8vq0293102931epcas2p1d;
        Fri, 17 Sep 2021 06:55:24 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210917065523epsmtrp1cc19f05c1553ccffef2464dc9c9436dc~liZeMDqAm1045910459epsmtrp1D;
        Fri, 17 Sep 2021 06:55:23 +0000 (GMT)
X-AuditID: b6c32a47-d29ff70000002615-b1-61443bdcfa89
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        7C.91.08750.BDB34416; Fri, 17 Sep 2021 15:55:23 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210917065523epsmtip2f1d2444ea930ba477395e6e0b961e8d4~liZeAw9jY2164221642epsmtip2g;
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
Subject: [PATCH v3 15/17] scsi: ufs: ufs-exynos: multi-host configuration
 for exynosauto
Date:   Fri, 17 Sep 2021 15:54:34 +0900
Message-Id: <20210917065436.145629-16-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210917065436.145629-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01TbUxTZxT2vbfcts66u4Lw2kVoSnQBBrRgy2WKU2n0omhIyH6MZZYLXEtn
        v9LbEjSY4dgUKCCIEa1AhCVlYW5k2EFtVCgfAWIYq2yCqERm94GZCHQ6JBms5XYZ/57nnOc8
        55z3g4cKH2AinkZvpk16SivBNnK6+mPk8Y92KSlp0+BWYsR7HSOeNHdhxOzrnzHCPVPBIS7N
        v0aJxQ57CDHeE0dU3Uwn7ta2IoS3w4YSrZNdCPHd8yWEeOAY5BCXx+4ghHXCiRFtQyvIXpwc
        /+kwaSutxsjxmmqEvPFVLPnlrVmE7GyvwMja1l5A/t1RjpELv05xyBpHOyB9nZHkuV4rkrUp
        R7u7kKYKaJOY1ucbCjR6dZrkcLYqXSVXSGXxslQiRSLWUzo6TaLMzIo/oNH6V5KIiyitxR/K
        ohhGkrhnt8lgMdPiQgNjTpPQxgKtUSYzJjCUjrHo1Qn5Bt17Mqk0Se5X5moLyz6LM65GFU96
        LmGlwC2qBHwexHfClm+tSCXYyBPiTgCX6lqCZBFA+20XyhIfgM7uelAJeGsl3gXIxl0A/nH9
        CsaSBQCbnWMg4Ivh8dDx+zMQSIThLwD0Pr3IDRAUt6Fw6GU9ElCF4jnQ0TYXEsAcfDu8Nz3K
        DWABvhe2eB4CdsIoOLBcgQYw3x+fcq0CVvMWHLni5QQw6teUfX91bVaIP+LBhj5ncFYlXPmh
        hPUJhc+GHFwWi+Ds+bNcVm8F8ItfVoOJrwGsOJPJ4vfhcoMjJOCD4jGww5XIWkbDgalg282w
        vP8fLhsWwPKzQrbwHdjb3cBh8TZobfSFsJiErkZf8LDqAWxy+zi1QGxbt41t3Ta2/xtfA2g7
        CKeNjE5NM0nG5PU33AnW3njsQSe4/Hw+oQ8gPNAHIA+VhAl+LNlHCQUF1MlTtMmgMlm0NNMH
        5P6zrkNFW/IN/k+iN6tk8iSFQpoqJ+SKJEISIWha2U8JcTVlpk/QtJE2/VeH8PiiUuSWxeUt
        /2b4jSO9swJzpTsjc8ftlY/UH59uFjgLtx+6xy8ZLC6+T80NmKs2H72YfIofPRU5enI64vj9
        vBPMzMQn53LD4zTJpSN9y0P58x86d+0TZzvDvInm7qt/7Xks/G3sZUyqJ9qu3BLrU3u4lsGE
        lA/6jz3eoMtzFHfbpw/1L9b9+XbNBsfR1Runt1qz9w8h4psZdw5ekDIZ8V1PX7nLFNrInofI
        1Of9NT1ekzs3x54xIa0nq1+NrUROts3YN/GNvuoLS0VNNnO5WLOYt+o5diZubttw6c4wb9UL
        wAxHtErffaIkwgfO96Ydb9RGpYgEoddGizyfWkSY4q4q/U2VhMMUUrJY1MRQ/wIRiRy7bAQA
        AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsWy7bCSvO5ta5dEg38rzS1OPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZotP65exWlzer23Rs9PZ4vSERUwWT9bPYrZYdGMbk8XGtz+YLG5u
        OcpiMeP8PiaL7us72CyWH//H5CDgcfmKt8eshl42j8t9vUwem1doeSze85LJY9OqTjaPCYsO
        MHp8X9/B5vHx6S0Wj74tqxg9Pm+S82g/0M0UwBPFZZOSmpNZllqkb5fAldHcpF3wX77ixsVp
        bA2MB6W6GDk4JARMJJ58lOhi5OIQEtjBKNHwoYu9i5ETKC4r8ezdDihbWOJ+yxFWiKL3jBLn
        9k5mA0mwCehKbHn+ihHEFhH4yCgx55sWSBGzwBJmicYD85hAEsICERKfmntZQGwWAVWJS/fO
        gk3lFXCQWHjxNiPEBnmJI786mUFsTqD4rV3/weJCAvYSEycvYoSoF5Q4OfMJ2BxmoPrmrbOZ
        JzAKzEKSmoUktYCRaRWjZGpBcW56brFhgVFearlecWJucWleul5yfu4mRnC0aWntYNyz6oPe
        IUYmDsZDjBIczEoivBdqHBOFeFMSK6tSi/Lji0pzUosPMUpzsCiJ817oOhkvJJCeWJKanZpa
        kFoEk2Xi4JRqYCo8/G1xPPvc2c7bc9/eWPokryFnKotAh/SiPXts3b2uvC5WO/7AZKdez3MP
        0eZEp0tTHveeu7I2szVFbeJ5f7Ef0f5Xn7Qvaz12/PPrihaJA4+et1s4MGxj2XGnYm5XT957
        /3svez848+ifKt55Id3+vNSnFVcSvBKW9BTN6XAuXBdh9HuFV2GL39EJv2292qX/GwseVhBd
        tvZJTafwEp6jF1fwHdy8S1Tn2FHzIpu/D3Tz+sNqrc2e7ndjPhD8+99en3NCoeyvPoW++vGx
        7/npswpN3HfULmRI9MUevP18quTNfWz7Wy+/iJ/Wn2N+obXU8uMbx90Z82S+LbhpvuergPXj
        9c/iC8VWrTH4ytKkxFKckWioxVxUnAgAaRaD9SUDAAA=
X-CMS-MailID: 20210917065524epcas2p18a720757ef3c4fc08d4bc8d16f9fe7fe
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210917065524epcas2p18a720757ef3c4fc08d4bc8d16f9fe7fe
References: <20210917065436.145629-1-chanho61.park@samsung.com>
        <CGME20210917065524epcas2p18a720757ef3c4fc08d4bc8d16f9fe7fe@epcas2p1.samsung.com>
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

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 45 +++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 28f027d45917..0ca21cd8e76e 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -83,6 +83,21 @@
 #define UFS_SHARABLE		(UFS_WR_SHARABLE | UFS_RD_SHARABLE)
 #define UFS_SHAREABILITY_OFFSET	0x710
 
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
@@ -231,6 +260,20 @@ static int exynosauto_ufs_pre_pwr_change(struct exynos_ufs *ufs,
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
+
 static int exynos7_ufs_pre_link(struct exynos_ufs *ufs)
 {
 	struct ufs_hba *hba = ufs->hba;
@@ -1395,8 +1438,10 @@ static struct exynos_ufs_drv_data exynosauto_ufs_drvs = {
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
2.33.0

