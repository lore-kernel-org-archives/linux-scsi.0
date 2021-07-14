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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD614C07E9C
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 07:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92AB2613AA
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 07:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238229AbhGNHPO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 03:15:14 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:31536 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238264AbhGNHPA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 03:15:00 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210714071203epoutp040df9a046124cfb324881f56f0f5ba3cc~RlsdqMnEt0948109481epoutp04L
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2021 07:12:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210714071203epoutp040df9a046124cfb324881f56f0f5ba3cc~RlsdqMnEt0948109481epoutp04L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1626246723;
        bh=eEXKyWquYO93I+OzTLmzLBjuVcLUnA3wC2j+ojcvVPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lARgPA57FmwzRo7vYU3gLV4ERslI2kgA505NYVjHfBu1oHIJ/diJz68cYuPED0RMS
         T9ixNfDxzMjBXYgaymMeemJYJj6KaakZyEeGyTWgX3em7qRgOrZVifPdAVEWYggKbp
         COKqN42sl1p5aQuihmX4XQe/N5DdxJ0S8mO+kJQo=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210714071202epcas2p3fd292ed4e618ede3de2f33065d221ba2~Rlsc8MhMF2304323043epcas2p3k;
        Wed, 14 Jul 2021 07:12:02 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.186]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4GPpbN3z7xz4x9QR; Wed, 14 Jul
        2021 07:12:00 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        56.42.09921.04E8EE06; Wed, 14 Jul 2021 16:12:00 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20210714071200epcas2p3f76e68f6bbb4755574dba2055a8130ab~RlsaR7BUu2291022910epcas2p3M;
        Wed, 14 Jul 2021 07:12:00 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210714071200epsmtrp15ea9759ede4c81f84f7e2bc98eb566ff~RlsaQxRI41240112401epsmtrp1h;
        Wed, 14 Jul 2021 07:12:00 +0000 (GMT)
X-AuditID: b6c32a45-f9dff700000026c1-10-60ee8e40513b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        18.17.08289.F3E8EE06; Wed, 14 Jul 2021 16:11:59 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210714071159epsmtip2056e1c26ec925e301ce4fcb97ea6a3ed~RlsaEMaC12386723867epsmtip2p;
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
Subject: [PATCH v2 14/15] scsi: ufs: ufs-exynos: multi-host configuration
 for exynosauto
Date:   Wed, 14 Jul 2021 16:11:30 +0900
Message-Id: <20210714071131.101204-15-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210714071131.101204-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAJsWRmVeSWpSXmKPExsWy7bCmqa5D37sEg53LpS1OPlnDZvFg3jY2
        i5c/r7JZTPvwk9ni0/plrBaX92tb9Ox0tjg9YRGTxZP1s5gtFt3YxmSx8pqFxfnzG9gtbm45
        ymIx4/w+Jovu6zvYLJYf/8fkIOBx+Yq3x+W+XiaPzSu0PBbvecnksWlVJ5vHhEUHGD0+Pr3F
        4tG3ZRWjx+dNch7tB7qZAriicmwyUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTy
        EnNTbZVcfAJ03TJzgP5QUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BQYGhboFSfm
        Fpfmpesl5+daGRoYGJkCVSbkZGz9+ZGp4J1cxZcH09gaGPdLdjFyckgImEic2LmXHcQWEtjB
        KHHnl2EXIxeQ/YlR4sGvTcwQzmdGib3rjzPCdFz4tYwdIrGLUWLW7FlQzkdGid1XjrCCVLEJ
        6Epsef6KESQhAjJ31eK7LCAOs8BJZonTCw6CbRQWiJK4sfEnM4jNIqAqsWpfKxOIzSvgINF0
        5j4LxD55iVPLDoLFOYHiBzd8YISoEZQ4OfMJWA0zUE3z1tlgx0oInOGQeLalgQmi2UVixpup
        zBC2sMSr41vYIWwpiZf9bewQDd2MEq2P/kMlVjNKdDb6QNj2Er+mbwH6hwNog6bE+l36IKaE
        gLLEkVtQe/kkOg7/ZYcI80p0tAlBNKpLHNg+Hep8WYnuOZ9ZIWwPiXWL+qGhNZlR4ubSWSwT
        GBVmIXlnFpJ3ZiEsXsDIvIpRLLWgODc9tdiowBA5jjcxgpO2lusOxslvP+gdYmTiYDzEKMHB
        rCTCu9TobYIQb0piZVVqUX58UWlOavEhRlNgYE9klhJNzgfmjbySeENTIzMzA0tTC1MzIwsl
        cV4O9kMJQgLpiSWp2ampBalFMH1MHJxSDUyhLuI1Dgx2ym+CXF9/3r+ev2PFWrOkyClKVRtf
        f/De9CY8UOGi6uLSJRnt/WfLzuSydbEk74l7k//TectcofBLvEu9DQ5M59O2e7JtrZBA0QOd
        zYvqvt8+UP1WzDWDy1+vOIB1sUtxwwmtOxbrnf14y+frfG/h+yvBuPGjsvayKbLMd7f+evhj
        1fv2T5IL9/iZcUUn/5nuf+3YhFkRsU9maVXrF4efi8i52Hdv1UfB5YW5Ib+n/GpZer322Yp+
        DwGWpVFPM+9eFFv3/eL77IIdVnVqnN/u3RAT23Zt3acPK0sOyqd8tf4ZeOGgmpiS3ySW0q6+
        JicGoaKCb1P7Ot42G7Uc4JKc8qDr7jNJ6S9KLMUZiYZazEXFiQCfYVHHYwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42LZdlhJXte+712Cwa65VhYnn6xhs3gwbxub
        xcufV9kspn34yWzxaf0yVovL+7UtenY6W5yesIjJ4sn6WcwWi25sY7JYec3C4vz5DewWN7cc
        ZbGYcX4fk0X39R1sFsuP/2NyEPC4fMXb43JfL5PH5hVaHov3vGTy2LSqk81jwqIDjB4fn95i
        8ejbsorR4/MmOY/2A91MAVxRXDYpqTmZZalF+nYJXBlbf35kKngnV/HlwTS2Bsb9kl2MnBwS
        AiYSF34tY+9i5OIQEtjBKLHz52ImiISsxLN3O9ghbGGJ+y1HWCGK3jNKzLy3lw0kwSagK7Hl
        +StGkISIwC5GicNnDoONYha4zCzxbdoVZpAqYYEIiRdN88FsFgFViVX7WsFW8Ao4SDSduc8C
        sUJe4tSyg2BxTqD4wQ0fGEFsIQF7iX/bVrNB1AtKnJz5BKyeGai+eets5gmMArOQpGYhSS1g
        ZFrFKJlaUJybnltsWGCUl1quV5yYW1yal66XnJ+7iREcXVpaOxj3rPqgd4iRiYPxEKMEB7OS
        CO9So7cJQrwpiZVVqUX58UWlOanFhxilOViUxHkvdJ2MFxJITyxJzU5NLUgtgskycXBKNTDF
        Pl1yu8vn32uNbUbLLHl1ZbgXHN6od/NNypH5Mm4TzpgWRZ+bbyDvzH/S60vhlCRLq2WcT97v
        M5WJ/h4yvXHP//+bl5VZHps2edZ1qVytjHUWW87daZkvleo+NV36x4unQb8s32f+eMD0a7Wd
        v9Cx/x4bmX/+yfQ5fyuKj2O5JPOdI1JPXP93ndjy/qnDx1tyVr7Z1hJe176Ea/RY7roRc8Jq
        Iud84cY/2kcbE58+2rDIIvlseeHFla1RAZJSkktnrtlTzPQj6/bBg+KGep3OK9S8df6yOz7l
        +tf9+uvJhU8s1ZLU2nQ4Z3Kvz7mxj3/C/t4FnB1f9t3cMLX0Q7Ryx4sq7oe8Vzbuzu+Ij7nT
        rsRSnJFoqMVcVJwIANA4DDodAwAA
X-CMS-MailID: 20210714071200epcas2p3f76e68f6bbb4755574dba2055a8130ab
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210714071200epcas2p3f76e68f6bbb4755574dba2055a8130ab
References: <20210714071131.101204-1-chanho61.park@samsung.com>
        <CGME20210714071200epcas2p3f76e68f6bbb4755574dba2055a8130ab@epcas2p3.samsung.com>
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
 drivers/scsi/ufs/ufs-exynos.c | 45 +++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 200137e6ecce..5b293a4ac6ea 100644
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
2.32.0

