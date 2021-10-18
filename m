Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A14AC4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 12:45:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC925610A1
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 12:45:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbhJRMrl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 08:47:41 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:52896 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhJRMr3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Oct 2021 08:47:29 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20211018124516epoutp020da20b4a99c5efa2b0a4531fa0e4da18~vIKzheTVY0471704717epoutp02h
        for <linux-scsi@vger.kernel.org>; Mon, 18 Oct 2021 12:45:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20211018124516epoutp020da20b4a99c5efa2b0a4531fa0e4da18~vIKzheTVY0471704717epoutp02h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1634561116;
        bh=xHm+g4IiD90t/dar4gEHI6pP+RxxCTXDBqNNOJ3n1a8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uYG6MdD5OT4rszYclus4o6NxtUoKkkm14lx7x6pZOY3HLQh9bhtuY5VdxL33+YZqN
         lu9YnWlpNO7RE6hdboXOPT/qHhTqWW5hZh2kZPKL48v/Ua3emi4SxvF+OY3AibhHeO
         2WOgnFR4yh6a/Q6tKzFUZ064CAxMtEjLf6T+OfUo=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20211018124515epcas2p2f8e04347527244a0662126ec34461b37~vIKyFoB-X0992709927epcas2p2a;
        Mon, 18 Oct 2021 12:45:15 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.89]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4HXxRS13brz4x9Q8; Mon, 18 Oct
        2021 12:45:08 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        57.14.09868.35C6D616; Mon, 18 Oct 2021 21:45:08 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20211018124506epcas2p4cadea8f87fde299c22317496a2d29f14~vIKp7nrsU2241122411epcas2p4V;
        Mon, 18 Oct 2021 12:45:06 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211018124506epsmtrp188bb66092e74a1ea79990abf9a0a0330~vIKp6dnV41588315883epsmtrp1F;
        Mon, 18 Oct 2021 12:45:06 +0000 (GMT)
X-AuditID: b6c32a45-9b9ff7000000268c-7f-616d6c5321e4
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        29.50.08902.25C6D616; Mon, 18 Oct 2021 21:45:06 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211018124506epsmtip20f6f8c2d3b5073e4d2198336b73d8a9a~vIKpqoCl90224202242epsmtip2i;
        Mon, 18 Oct 2021 12:45:06 +0000 (GMT)
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
        Chanho Park <chanho61.park@samsung.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Inki Dae <inki.dae@samsung.com>
Subject: [PATCH v5 13/15] scsi: ufs: ufs-exynos: multi-host configuration
 for exynosauto
Date:   Mon, 18 Oct 2021 21:42:14 +0900
Message-Id: <20211018124216.153072-14-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211018124216.153072-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01TfVBUVRTvvvd4u0tuvRbIG5O1LioDubiLwF7EVQiQ50BFHzNNZIMPeLIM
        +zW7S2U1RaUry7cQaqsQoQVDxE7b8lUptBCKTEAQo1CMfA4i44iYscBo7fKw/O/3O/f8zu+c
        c+/l46JZ0p+fpTWxBi2jlpDeRHNnkEL6mlrDyNoqMNQz3UCi8apmEs0tD5Po5wkLgU4sLONo
        0fa1Fxpqfw4VtsWi3tIaDJVdKyXQtM2Ko5qrzRi6umL2Qt/ddGFoxPELgU71X8BQwZVWEtVe
        vI+h1WUnFu1DD/2eSFtzi0h6qLgIo7+vC6bP/jSH0fZ6C0mX1nQAesmWR9K3Z0YJuthRD+g7
        9mfoYx0FWPKGlOzdKpbJYA1iVpuuy8jSZiolia+mxqaGR8jkUnkkUkjEWkbDKiVxScnSfVlq
        94QS8duMOscdSmaMRsmOPbsNuhwTK1bpjCalhNVnqPUKfYiR0RhztJkhWta0Sy6ThYa7Ew9m
        qzpdVlK/Gvhu4/ICLxd8uzkfCPiQCoPD3XYiH3jzRVQrgGUrbetkEcBfa7owjvwNYH51J/lA
        UlVrwT1YRJ0HsHAwkMO3AZws2+rBJCWFjtkbwCP2pW4BOD31Gc9DcCqPgLmVZjfh832oFNh4
        bqdHQFBbYXl15ZqBkIqG88dGeJzZs7BrhTMTuOOFax15cp6APZ9PEx6Mu3M+bTqNe+pDaoEP
        bYvdBCeOg33jwziHfeCNi471ov5wrsTM4wQFAB6d/Gf94BsALR8ncXgvXDnp8PI0ilNB0PbD
        Dg+EVADsGl33fQzmdd7jcWEhzDOLOGEg7Gg5ud7BJlhw5o4Xh2noaDqKcwstd+9k2MErBWLr
        Q+NYHxrH+r9xNcDrwZOs3qjJZI2hevl/N5yu09jB2osPjm8F5TcXQpwA4wMngHxc4itMi9cw
        ImEGc/g91qBLNeSoWaMThLuXfRz390vXub+M1pQqD4uUhUVEyBWh4TKFZKMw0i+bEVGZjInN
        Zlk9a3igw/gC/1ysfEa8ZSp+9kOp35uHogJQ6kCtUtr81rZPGi2Pz5f9ORr9cn3y2J4634pF
        L1E+GkhzlWzc8oY1oO5uX2mg87ejEyOXfoytSHt00/ag6JbqwVsnXgipXlE4Yuan9499xC5B
        w8HDm3f294g3WNufrnDtd36QeeQ61aK8q3QdPx+dtBrlrbosP1NlfzFlpGXqpf7QidNfpsQs
        VRbb+i1RAmJ7gv9Sd8srRSO7BOcsDeiRmb9O+Zwt+er10XjvdsGBjiPm94Ux0qASXQx+Ieud
        uT778OS9fV8c+OP5hesDE0uDceZLLqAIvjwGLYmqBOX9eNdA21N7ewOu8K5FJPBHG3q3jUc2
        HRqUEEYVIw/GDUbmX3kv3dR6BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsWy7bCSvG5QTm6iwbLtfBYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLS7v17bo2elscXrCIiaLSfcnsFg8WT+L2WLRjW1MFjd+
        tbFabHz7g8ni5pajLBYzzu9jsui+voPNYvnxf0wWv38eYnIQ9rh8xdtjVkMvm8flvl4mj80r
        tDwW73nJ5LFpVSebx4RFBxg9vq/vYPP4+PQWi0ffllWMHp83yXm0H+hmCuCJ4rJJSc3JLEst
        0rdL4Mo4/GMWW8Fv9Yp1Pz+wNzCuVexi5OSQEDCRmLe8k7mLkYtDSGA3o8TBqc9ZIBKyEs/e
        7WCHsIUl7rccYYUoes8oMeXwabAiNgFdiS3PXzGC2CICHxkl5nzTAiliFpjCInHjaTMTSEJY
        IEJibd8iNhCbRUBVYvKCuWA2r4CDxOv2m1Ab5CWO/AI5g5ODEyjes+gIWK+QgL3E4pezmSHq
        BSVOznwCtpgZqL5562zmCYwCs5CkZiFJLWBkWsUomVpQnJueW2xYYJiXWq5XnJhbXJqXrpec
        n7uJERyPWpo7GLev+qB3iJGJg/EQowQHs5IIb5JrbqIQb0piZVVqUX58UWlOavEhRmkOFiVx
        3gtdJ+OFBNITS1KzU1MLUotgskwcnFINTHMjr5emSMVM2lS8Zod/g9W9gE/6Crnfd/xd0H7h
        6uoDsWrzXtzvWfAiXkPaSqpo0s9/U3h9VPxKK1ImyF+SeHvh7+bbyy46bxP7FJFQsHbODgW1
        xUFPl/yKdou184rZvGfRxZrm+1VC/5ZvCex6ZbtPwCHt7E6Ozt63LbuEhZdwyHzqOtx4naH1
        v8vLiKyL5osUXl5U7zC4cfEve0R36Y31RYddsoQZg/JsMkteLhT6a/PZvPttrH35ctHpheEr
        1u/8l/V6wmr+b3Uul7UX3Hy24d1MpqSMydHSNh4LU3cqT4+tdVtyQfGERap2FcuKr6s6f24M
        8ag3WHYr0+VLIM+3zXtdBQ/Iz9nc9q5duFKJpTgj0VCLuag4EQCGNu3mNgMAAA==
X-CMS-MailID: 20211018124506epcas2p4cadea8f87fde299c22317496a2d29f14
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211018124506epcas2p4cadea8f87fde299c22317496a2d29f14
References: <20211018124216.153072-1-chanho61.park@samsung.com>
        <CGME20211018124506epcas2p4cadea8f87fde299c22317496a2d29f14@epcas2p4.samsung.com>
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
support up to four interfaces(1 for a PH and 3 for VHs) but this patch
initially supports only 1 PH and 1 VH. For this, we uses TASK_TAG[7:5]
field so TASK_TAG[4:0] for 32 doorbel will be supported. After the PH is
initiated, this will send a ready message to VHs through a mailbox
register. The message handler is not fully implemented yet such as
supporting reset / abort cases.

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Reviewed-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 68 +++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 2ff9bbd8b821..6e6149d99609 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -83,6 +83,44 @@
 #define UFS_SHARABLE		(UFS_WR_SHARABLE | UFS_RD_SHARABLE)
 #define UFS_SHAREABILITY_OFFSET	0x710
 
+/* Multi-host registers */
+#define MHCTRL			0xC4
+#define MHCTRL_EN_VH_MASK	(0xE)
+#define MHCTRL_EN_VH(vh)	(vh << 1)
+#define PH2VH_MBOX		0xD8
+
+#define MH_MSG_MASK		(0xFF)
+
+#define MH_MSG(id, msg)		((id << 8) | (msg & 0xFF))
+#define MH_MSG_PH_READY		0x1
+#define MH_MSG_VH_READY		0x2
+
+#define ALLOW_INQUIRY		BIT(25)
+#define ALLOW_MODE_SELECT	BIT(24)
+#define ALLOW_MODE_SENSE	BIT(23)
+#define ALLOW_PRE_FETCH		GENMASK(22, 21)
+#define ALLOW_READ_CMD_ALL	GENMASK(20, 18)	/* read_6/10/16 */
+#define ALLOW_READ_BUFFER	BIT(17)
+#define ALLOW_READ_CAPACITY	GENMASK(16, 15)
+#define ALLOW_REPORT_LUNS	BIT(14)
+#define ALLOW_REQUEST_SENSE	BIT(13)
+#define ALLOW_SYNCHRONIZE_CACHE	GENMASK(8, 7)
+#define ALLOW_TEST_UNIT_READY	BIT(6)
+#define ALLOW_UNMAP		BIT(5)
+#define ALLOW_VERIFY		BIT(4)
+#define ALLOW_WRITE_CMD_ALL	GENMASK(3, 1)	/* write_6/10/16 */
+
+#define ALLOW_TRANS_VH_DEFAULT	(ALLOW_INQUIRY | ALLOW_MODE_SELECT | \
+				 ALLOW_MODE_SENSE | ALLOW_PRE_FETCH | \
+				 ALLOW_READ_CMD_ALL | ALLOW_READ_BUFFER | \
+				 ALLOW_READ_CAPACITY | ALLOW_REPORT_LUNS | \
+				 ALLOW_REQUEST_SENSE | ALLOW_SYNCHRONIZE_CACHE | \
+				 ALLOW_TEST_UNIT_READY | ALLOW_UNMAP | \
+				 ALLOW_VERIFY | ALLOW_WRITE_CMD_ALL)
+
+#define HCI_MH_ALLOWABLE_TRAN_OF_VH		0x30C
+#define HCI_MH_IID_IN_TASK_TAG			0X308
+
 enum {
 	UNIPRO_L1_5 = 0,/* PHY Adapter */
 	UNIPRO_L2,	/* Data Link */
@@ -174,6 +212,20 @@ static int exynosauto_ufs_drv_init(struct device *dev, struct exynos_ufs *ufs)
 	return 0;
 }
 
+static int exynosauto_ufs_post_hce_enable(struct exynos_ufs *ufs)
+{
+	struct ufs_hba *hba = ufs->hba;
+
+	/* Enable Virtual Host #1 */
+	ufshcd_rmwl(hba, MHCTRL_EN_VH_MASK, MHCTRL_EN_VH(1), MHCTRL);
+	/* Default VH Transfer permissions */
+	hci_writel(ufs, ALLOW_TRANS_VH_DEFAULT, HCI_MH_ALLOWABLE_TRAN_OF_VH);
+	/* IID information is replaced in TASKTAG[7:5] instead of IID in UCD */
+	hci_writel(ufs, 0x1, HCI_MH_IID_IN_TASK_TAG);
+
+	return 0;
+}
+
 static int exynosauto_ufs_pre_link(struct exynos_ufs *ufs)
 {
 	struct ufs_hba *hba = ufs->hba;
@@ -241,6 +293,20 @@ static int exynosauto_ufs_pre_pwr_change(struct exynos_ufs *ufs,
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
@@ -1416,8 +1482,10 @@ static struct exynos_ufs_drv_data exynosauto_ufs_drvs = {
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

