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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8ACDC11F67
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 07:12:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5A9B6138C
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 07:12:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238237AbhGNHPR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 03:15:17 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:31548 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238272AbhGNHPA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 03:15:00 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210714071205epoutp048ff526133955f000de066b64c057fcb0~Rlsfksupr0942509425epoutp04V
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2021 07:12:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210714071205epoutp048ff526133955f000de066b64c057fcb0~Rlsfksupr0942509425epoutp04V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1626246725;
        bh=stJk41kM7OMhlXJlN10udW/YreVjbMV+Qbw3QGqr63o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k/aUtACIJnMX99bH4/sekatu62F2VQKtoPzl2y0y2eVvG8gUhyDo4SVPB2NcQfzM7
         73eseawmxTvAfnQHxZhZt5fJHawBm49IzRI5Nb5s1PM4MaagSvmfZLbQpygeyo1Vce
         v7PDmva6Fn0+PdWYY/S0/SAkT/ve+LbnlnIyt6g8=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210714071205epcas2p4417cb516fd55456366fc28a1129f3d70~Rlse-dNN62508225082epcas2p44;
        Wed, 14 Jul 2021 07:12:05 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.189]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4GPpbQ0L4Nz4x9Q7; Wed, 14 Jul
        2021 07:12:02 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        D3.BF.09541.04E8EE06; Wed, 14 Jul 2021 16:12:00 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210714071200epcas2p413ca643dc459ee75ec7e5e4f8a6c05d7~RlsaWtfrl2508225082epcas2p4j;
        Wed, 14 Jul 2021 07:12:00 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210714071200epsmtrp2fc436150d4e963483f113e77fe096f35~RlsaVeqvf0755107551epsmtrp2t;
        Wed, 14 Jul 2021 07:12:00 +0000 (GMT)
X-AuditID: b6c32a46-0abff70000002545-f8-60ee8e4086d0
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        28.17.08289.F3E8EE06; Wed, 14 Jul 2021 16:12:00 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210714071159epsmtip22f6575a10d01c8fef7499dc5233f7349~RlsaJCI_R2336023360epsmtip2c;
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
Subject: [PATCH v2 15/15] scsi: ufs: ufs-exynos: introduce exynosauto v9
 virtual host
Date:   Wed, 14 Jul 2021 16:11:31 +0900
Message-Id: <20210714071131.101204-16-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210714071131.101204-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAJsWRmVeSWpSXmKPExsWy7bCmma5D37sEg8n7lC1OPlnDZvFg3jY2
        i5c/r7JZTPvwk9ni0/plrBaX92tb9Ox0tjg9YRGTxZP1s5gtFt3YxmSx8pqFxfnzG9gtbm45
        ymIx4/w+Jovu6zvYLJYf/8fkIOBx+Yq3x+W+XiaPzSu0PBbvecnksWlVJ5vHhEUHGD0+Pr3F
        4tG3ZRWjx+dNch7tB7qZAriicmwyUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTy
        EnNTbZVcfAJ03TJzgP5QUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BQYGhboFSfm
        Fpfmpesl5+daGRoYGJkCVSbkZFzoW8Ve8Fal4vaiU4wNjL1yXYwcHBICJhIbD+V0MXJxCAns
        YJSYsvIiG4TziVHi/b91TBDOZ6DM13fMXYycEB0Nk9khErsYJXY2bGeGcD4ySvxvOQ9WxSag
        K7Hl+StGkIQIyOBVi++ygDjMAieZJU4vOMgOUiUsEC5x4HQbWAeLgKrE2ge72UBsXgEHib/v
        VzJC7JOXOLXsIBOIzQkUP7jhAyNEjaDEyZlPWEBsZqCa5q2zwc6QEDjDIdHVshWq2UXiw/ld
        7BC2sMSr41ugbCmJz+/2skE0dDNKtD76D5VYzSjR2egDYdtL/Jq+hRUUTswCmhLrd+lDgkxZ
        4sgtqL18Eh2H/7JDhHklOtqEIBrVJQ5sn84CYctKdM/5zAphe0i829cNDa3JwEA5tJ15AqPC
        LCTvzELyziyExQsYmVcxiqUWFOempxYbFRghx/EmRnDS1nLbwTjl7Qe9Q4xMHIyHGCU4mJVE
        eJcavU0Q4k1JrKxKLcqPLyrNSS0+xGgKDOyJzFKiyfnAvJFXEm9oamRmZmBpamFqZmShJM7L
        wX4oQUggPbEkNTs1tSC1CKaPiYNTqoFp39Ul01mXrXkw78C2xCMOfW7y0/llNH9+NZWfuGtO
        qui6B5vqJOtD1lXvbp8V9EZpvaOwzifBmX/P/r27jXPSVPUvc9iU9ipdlfcLlhDeffKoVA3/
        fRveibtKZZrW+57b6Mw3y/i3STSHEPs/1fZfmV/3LPu2Jzruv+YTB5s5T/dpCjMo/tmb+OnX
        O+uL7/hMeQpVHp4qtD+++Cb7wTfLmeYcaf7trt4rvukL69YjTH03FLl+SOWb5nzkldtm1xnb
        nMdoFVh/+yWXNC/DUe7nj5Nb/jgJO/UeY4ywubNKdm/ovdxULv9Y8ak3Ew7cbpbUuDrFuuim
        uX0n25S7i+f/fnNAaU1xvPqswx1WE1lTlViKMxINtZiLihMBHGbDTGMEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42LZdlhJXteh712CQcNTRouTT9awWTyYt43N
        4uXPq2wW0z78ZLb4tH4Zq8Xl/doWPTudLU5PWMRk8WT9LGaLRTe2MVmsvGZhcf78BnaLm1uO
        sljMOL+PyaL7+g42i+XH/zE5CHhcvuLtcbmvl8lj8wotj8V7XjJ5bFrVyeYxYdEBRo+PT2+x
        ePRtWcXo8XmTnEf7gW6mAK4oLpuU1JzMstQifbsErowLfavYC96qVNxedIqxgbFXrouRk0NC
        wERiY8Nk9i5GLg4hgR2MEm2P57JBJGQlnr3bwQ5hC0vcbznCClH0nlHi74QjjCAJNgFdiS3P
        XzGCJEQEdjFKHD5zGGwUs8BlZolv064wg1QJC4RKXG1vYAKxWQRUJdY+2A22glfAQeLv+5WM
        ECvkJU4tOwhWwwkUP7jhA1hcSMBe4t+21VD1ghInZz5hAbGZgeqbt85mnsAoMAtJahaS1AJG
        plWMkqkFxbnpucWGBUZ5qeV6xYm5xaV56XrJ+bmbGMHRpaW1g3HPqg96hxiZOBgPMUpwMCuJ
        8C41epsgxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdC18l4IYH0xJLU7NTUgtQimCwTB6dUA5N+
        nNDT6zZbtrR5ie7O3JVr/cztucfdlFkGR75flPdPM2Fz7dnh8tC0OC0t4aMnQ0/k86UXa9br
        fb9y8oD7tVOveF4kr9/lHfV4q0+YR9FrZrX7JiLzfvka69kkyYcJbtvKaNIo321yMS6J611N
        3Oqzzx3TvjLoF9T8bvcX0V/xzvO+37EglaY1x2dL3ZnoWMUmviN65UfP6XL9vPvbGNn9jpyN
        4op//ttm9bJzZQb7ppYwXVCZ3PGjP37D7MOuRhsF3Q5knr8YYRFcqXlZQuGaw9asxd/2rW2/
        6rGq+jtHmbnnt79Ld194+CWyQCHydjSTUvTalVsSd/7UyBdavM/ulbi+uk3Prm01MfvqHyix
        FGckGmoxFxUnAgDVCJihHQMAAA==
X-CMS-MailID: 20210714071200epcas2p413ca643dc459ee75ec7e5e4f8a6c05d7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210714071200epcas2p413ca643dc459ee75ec7e5e4f8a6c05d7
References: <20210714071131.101204-1-chanho61.park@samsung.com>
        <CGME20210714071200epcas2p413ca643dc459ee75ec7e5e4f8a6c05d7@epcas2p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch introduces virtual host driver of exynosauto v9 ufs mHCI.
VH(Virtual Host) only supports data transfer functions. So, most of
physical features are broken. So, we need to set below quirks.
- UFSHCD_QUIRK_BROKEN_UIC_CMD
- UFSHCD_QUIRK_SKIP_PH_CONFIGURATION
Before initialization, the VH is necessary to wait until PH is ready.
It's implemented as polling at the moment.

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 .../bindings/ufs/samsung,exynos-ufs.yaml      |  1 +
 drivers/scsi/ufs/ufs-exynos.c                 | 84 +++++++++++++++++++
 2 files changed, 85 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
index fa5247c4a44f..9bd9ddc34791 100644
--- a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
@@ -21,6 +21,7 @@ properties:
     enum:
       - samsung,exynos7-ufs
       - samsung,exynosautov9-ufs
+      - samsung,exynosautov9-ufs-vh
 
   reg:
     items:
diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 5b293a4ac6ea..c277e1feded1 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -98,6 +98,8 @@
 #define HCI_MH_ALLOWABLE_TRAN_OF_VH		0x30C
 #define HCI_MH_IID_IN_TASK_TAG			0X308
 
+#define PH_READY_TIMEOUT_MS			(5 * MSEC_PER_SEC)
+
 enum {
 	UNIPRO_L1_5 = 0,/* PHY Adapter */
 	UNIPRO_L2,	/* Data Link */
@@ -1362,6 +1364,68 @@ static int exynos_ufs_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	return 0;
 }
 
+static int exynosauto_ufs_vh_link_startup_notify(struct ufs_hba *hba,
+						 enum ufs_notify_change_status status)
+{
+	if (status == POST_CHANGE) {
+		ufshcd_set_link_active(hba);
+		ufshcd_set_ufs_dev_active(hba);
+		hba->wlun_dev_clr_ua = true;
+	}
+
+	return 0;
+}
+
+static int exynosauto_ufs_vh_wait_ph_ready(struct ufs_hba *hba)
+{
+	u32 mbox;
+	ktime_t start, stop;
+
+	start = ktime_get();
+	stop = ktime_add(start, ms_to_ktime(PH_READY_TIMEOUT_MS));
+
+	do {
+		mbox = ufshcd_readl(hba, PH2VH_MBOX);
+		if ((mbox & MH_MSG_MASK) == MH_MSG_PH_READY)
+			return 0;
+
+		usleep_range(40, 50);
+	} while (ktime_before(ktime_get(), stop));
+
+	return -ETIME;
+}
+
+static int exynosauto_ufs_vh_init(struct ufs_hba *hba)
+{
+	struct device *dev = hba->dev;
+	struct platform_device *pdev = to_platform_device(dev);
+	struct exynos_ufs *ufs;
+	int ret;
+
+	ufs = devm_kzalloc(dev, sizeof(*ufs), GFP_KERNEL);
+	if (!ufs)
+		return -ENOMEM;
+
+	/* exynos-specific hci */
+	ufs->reg_hci = devm_platform_ioremap_resource_byname(pdev, "vs_hci");
+	if (IS_ERR(ufs->reg_hci)) {
+		dev_err(dev, "cannot ioremap for hci vendor register\n");
+		return PTR_ERR(ufs->reg_hci);
+	}
+
+	ret = exynosauto_ufs_vh_wait_ph_ready(hba);
+	if (ret)
+		return ret;
+
+	ufs->drv_data = device_get_match_data(dev);
+	if (!ufs->drv_data)
+		return -ENODEV;
+
+	exynos_ufs_priv_init(hba, ufs);
+
+	return 0;
+}
+
 static struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.name				= "exynos_ufs",
 	.init				= exynos_ufs_init,
@@ -1376,6 +1440,12 @@ static struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.resume				= exynos_ufs_resume,
 };
 
+static struct ufs_hba_variant_ops ufs_hba_exynosauto_vh_ops = {
+	.name				= "exynosauto_ufs_vh",
+	.init				= exynosauto_ufs_vh_init,
+	.link_startup_notify		= exynosauto_ufs_vh_link_startup_notify,
+};
+
 static int exynos_ufs_probe(struct platform_device *pdev)
 {
 	int err;
@@ -1444,6 +1514,18 @@ static struct exynos_ufs_drv_data exynosauto_ufs_drvs = {
 	.post_pwr_change	= exynosauto_ufs_post_pwr_change,
 };
 
+static struct exynos_ufs_drv_data exynosauto_ufs_vh_drvs = {
+	.vops			= &ufs_hba_exynosauto_vh_ops,
+	.quirks			= UFSHCD_QUIRK_PRDT_BYTE_GRAN |
+				  UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR |
+				  UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR |
+				  UFSHCI_QUIRK_BROKEN_HCE |
+				  UFSHCD_QUIRK_BROKEN_UIC_CMD |
+				  UFSHCD_QUIRK_SKIP_PH_CONFIGURATION |
+				  UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING,
+	.opts			= EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX,
+};
+
 static struct exynos_ufs_drv_data exynos_ufs_drvs = {
 	.uic_attr		= &exynos7_uic_attr,
 	.quirks			= UFSHCD_QUIRK_PRDT_BYTE_GRAN |
@@ -1471,6 +1553,8 @@ static const struct of_device_id exynos_ufs_of_match[] = {
 	  .data	      = &exynos_ufs_drvs },
 	{ .compatible = "samsung,exynosautov9-ufs",
 	  .data	      = &exynosauto_ufs_drvs },
+	{ .compatible = "samsung,exynosautov9-ufs-vh",
+	  .data	      = &exynosauto_ufs_vh_drvs },
 	{},
 };
 
-- 
2.32.0

