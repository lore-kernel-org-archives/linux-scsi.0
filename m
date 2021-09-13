Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A19BFC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 08:12:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D9C460D42
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 08:12:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237999AbhIMINU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 04:13:20 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:22022 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237914AbhIMINN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Sep 2021 04:13:13 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210913081156epoutp028ecc11151f4aa08ebc97fea24a2ebbcf~kU3KI6LTx1748017480epoutp02b
        for <linux-scsi@vger.kernel.org>; Mon, 13 Sep 2021 08:11:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210913081156epoutp028ecc11151f4aa08ebc97fea24a2ebbcf~kU3KI6LTx1748017480epoutp02b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1631520716;
        bh=swn3c0mDNJ/0hlD7Do34gPFEkYMDRPAATDWWj2Pi0sc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=K9uTRG+3Z5Lt98nKtKeYTioJnmTIxZg8UqM+3V3g9nx+56j2JzsPUI2qR6nYtG/+Y
         pzdfRwV9SnxCyO9+Dnm+Jk14PWNJI7agRC7GklI23VnfzSIoh/2Tl7YbiCwDOvoEwl
         KZ4XdHoE8zzPGG4OVd19LBuOGpsfD26SUjGkHkzg=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210913081155epcas2p18d703a2887b2f6211a5a913f6325c751~kU3JjJjoa0434804348epcas2p1M;
        Mon, 13 Sep 2021 08:11:55 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.190]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4H7K2K6W12z4x9Px; Mon, 13 Sep
        2021 08:11:53 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        DD.AC.09472.8C70F316; Mon, 13 Sep 2021 17:11:52 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210913081152epcas2p2eac4a8dbef33164a150dccf2e282dcce~kU3GHqJtB0641906419epcas2p2p;
        Mon, 13 Sep 2021 08:11:52 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210913081152epsmtrp1ea874e3c703c9ee8bcef2e0ff1377e2e~kU3GG30sr1354313543epsmtrp1K;
        Mon, 13 Sep 2021 08:11:52 +0000 (GMT)
X-AuditID: b6c32a48-d75ff70000002500-fd-613f07c85b0a
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        C0.DE.08750.7C70F316; Mon, 13 Sep 2021 17:11:52 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210913081151epsmtip17921edbefd78aeeede98be637d1dedc1~kU3F8Z8Qr0411604116epsmtip1x;
        Mon, 13 Sep 2021 08:11:51 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        cang@codeaurora.org, adrian.hunter@intel.com, sc.suh@samsung.com,
        hy50.seo@samsung.com, sh425.lee@samsung.com,
        bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v2 3/3] scsi: ufs: ufs-exynos: implement exynos isr
Date:   Mon, 13 Sep 2021 16:55:55 +0900
Message-Id: <746e059782953fca6c21945297151d2bb73d3370.1631519695.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1631519695.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1631519695.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNJsWRmVeSWpSXmKPExsWy7bCmhe4JdvtEg3071S1OPlnDZvFg3jY2
        i5c/r7JZHHzYyWLxdekzVotP65exWqxe/IDFYtGNbUwWN7ccZbG4vGsOm0X39R1sFsuP/2Oy
        6Lp7g9Fi6b+3LA58Hpf7epk8Fu95yeQxYdEBRo/v6zvYPD4+vcXi0bdlFaPH501yHu0HupkC
        OKJybDJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOADldS
        KEvMKQUKBSQWFyvp29kU5ZeWpCpk5BeX2CqlFqTkFBgaFugVJ+YWl+al6yXn51oZGhgYmQJV
        JuRkLDney1Qw36Ri3tLnrA2Mk7S6GDk5JARMJLYfeMXSxcjFISSwg1Hi6vRPTBDOJ0aJrwsf
        sUI4nxkl/n59zgbT8vnxO6jELkaJJxNXM0M4PxglNny5xQJSxSagKfH05lQmEFtEYB+TxNFd
        6SA2s4C6xK4JJ8DiwgLOEvfbuoBsDg4WAVWJaT2aIGFegWiJTfOmsEIsk5O4ea6TGcTmFLCU
        uP8XohXB5gKqmcohsf/xLSaIBheJRadeMELYwhKvjm9hh7ClJF72t0HZ9RL7pjawQjT3MEo8
        3fcPqsFYYtazdkaQg5iBHli/Sx/ElBBQljgC8RazAJ9Ex+G/7BBhXomONiGIRmWJX5MmQw2R
        lJh58w7UJg+J9X1vGSHBA7Tp7KFGxgmM8rMQFixgZFzFKJZaUJybnlpsVGCCHHubGMGpVMtj
        B+Pstx/0DjEycTAeYpTgYFYS4d32xjZRiDclsbIqtSg/vqg0J7X4EKMpMBwnMkuJJucDk3le
        SbyhqZGZmYGlqYWpmZGFkjjv+deWiUIC6YklqdmpqQWpRTB9TBycUg1MQmI/Miuqi1+dsAzj
        VtJ7my1hXqP165bymp21zxZu4uZk1vYRDbZ0/OzI6vDq14/At9MjDtgF3tPTPSFmK/TBsObd
        7Ba+bV+ueuusbs1t+bRwa0r7/ndCfx6wXLYJf7DIY0mmzBqWyadjl75TjVx86tbdLU8Znu9p
        K8q6orxCZEIjv+HrVeYdW25XrnoanB38een7wrRJembNUtNvfZHWetwmdVeqc96T5iS7JQyG
        kkV3pqetlzxcZMW0fdrThNV5R+RPBjXWlyzQ/r9JlkHFQ+z1i4+z9op1Km66+ohlSo/Nplpr
        faEluhuyV1xar5X8LX+Fh4nnoS95Jobs3/aIKUm9veZlsWFNkZ/Bar8GJZbijERDLeai4kQA
        B1N9nS4EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsWy7bCSnO4JdvtEg65+RouTT9awWTyYt43N
        4uXPq2wWBx92slh8XfqM1eLT+mWsFqsXP2CxWHRjG5PFzS1HWSwu75rDZtF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+W+XiaPxXteMnlMWHSA0eP7+g42j49Pb7F49G1ZxejxeZOcR/uBbqYA
        jigum5TUnMyy1CJ9uwSujCXHe5kK5ptUzFv6nLWBcZJWFyMnh4SAicTnx+9YQWwhgR2MElf/
        S0HEJSVO7HzOCGELS9xvOQJUwwVU841R4tnHF8wgCTYBTYmnN6cygSREBM4xSUy9vJQJJMEs
        oC6xa8IJMFtYwFniflsXkM3BwSKgKjGtRxMkzCsQLbFp3hRWiAVyEjfPdYLN5BSwlLj/F6JV
        SMBCon/zJkZc4hMYBRYwMqxilEwtKM5Nzy02LDDKSy3XK07MLS7NS9dLzs/dxAiOBC2tHYx7
        Vn3QO8TIxMF4iFGCg1lJhHfbG9tEId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwXuk7GCwmkJ5ak
        ZqemFqQWwWSZODilGpiY1AtY9/nZ3Gr5WMaXcvj3N/383OBtt2ffvMZ/Jjiyj+MoF9eTA7dL
        49qTLt+JjeYJ6FeY+VG3aMnKnjMeF+Jilx7q8178my/7z9dqNwmnhSe7vp6fwSzwpLt0e1cU
        93we36SpymlK+4PZw7tOCLLZFtz13mn9IbpoYe20oNnNroE2+/56zpUJ4BRUN737V8Pdbsez
        irdlQcv8Pa7I7LWRtH0iK9V7cc6GX7cfpa2fL+Gs2jjBJOywy5wX2XcWip9covH6jbB3+4rp
        czi1orcxTKr6d1HwyMqSskZ5m/Q/uY8YpqSYLPA/dpdr+iLr3CtvXU5vtOPMTdNdGFg4v/nr
        bYuNi6TucrCzp0yozlRiKc5INNRiLipOBACl7xX+8wIAAA==
X-CMS-MailID: 20210913081152epcas2p2eac4a8dbef33164a150dccf2e282dcce
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210913081152epcas2p2eac4a8dbef33164a150dccf2e282dcce
References: <cover.1631519695.git.kwmad.kim@samsung.com>
        <CGME20210913081152epcas2p2eac4a8dbef33164a150dccf2e282dcce@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch is to raise recovery in some abnormal
conditions using an vendor specific interrupt
for some cases, such as a situation that some
contexts of a pending request in the host isn't
the same with those of its corresponding UPIUs
if they should have been the same exactly.

The representative case is shown like below.
In the case, a broken UTRD entry, for internal
coherent problem or whatever, that had smaller value
of PRDT length than expected was transferred to the host.
So, the host raised an interrupt of transfer complete
even if device didn't finish its data transfer because
the host sees a fetched version of UTRD to determine
if data tranfer is over or not. Then the application level
seemed to recogize this as a sort of corruption and this
symptom led to boot failure.

[5:   init:    1] init: Failed to copy /avb into /metadata/gsi/dsu/avb/: No such file or directory
[5:   init:    1] init: [libfs_mgr]Created logical partition system on device /dev/block/dm-0
[4:   init:    1] init: [libfs_mgr]Created logical partition vendor on device /dev/block/dm-1
[4:   init:    1] init: [libfs_avb]total vbmeta size mismatch: 13504 (expected: 15616)
[4:   init:    1] init: [libfs_avb]VerifyVbmetaImages failed
[4:   init:    1] init: Failed to open AvbHandle: No such file or directory

If the issued command would be write, it could be a
disaster because some parts of its entire data chunk
may be not written or more than the chunk may be written.

Using the VENDOR_SPECIFIC_IS.RX_UPIU_HIT_ERROR, the host
can detect the abnormal condition right when an
DATA IN for offset bigger than expected for the broken value
(i.e. PRDT length in this case) is received, do something for
recovery and system will keep going safe.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 84 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 72 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index a14dd8c..b0c8843 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -21,6 +21,7 @@
 #include "unipro.h"
 
 #include "ufs-exynos.h"
+#include "../scsi_transport_api.h"
 
 /*
  * Exynos's Vendor specific registers for UFSHCI
@@ -31,6 +32,8 @@
 #define HCI_RXPRDT_ENTRY_SIZE	0x04
 #define HCI_1US_TO_CNT_VAL	0x0C
 #define CNT_VAL_1US_MASK	0x3FF
+#define VENDOR_SPECIFIC_IS	0x38
+#define VENDOR_SPECIFIC_IE	0x3C
 #define HCI_UTRL_NEXUS_TYPE	0x40
 #define HCI_UTMRL_NEXUS_TYPE	0x44
 #define HCI_SW_RST		0x50
@@ -74,6 +77,18 @@
 				 UIC_TRANSPORT_NO_CONNECTION_RX |\
 				 UIC_TRANSPORT_BAD_TC)
 
+enum exynos_ufs_vs_interrupt {
+	/*
+	 * This occurs when information of a pending request isn't
+	 * the same with incoming UPIU for the request. For example,
+	 * if UFS driver rings with task tag #1, subsequential UPIUs
+	 * for this must have one as the value of task tag. But if
+	 * it's corrutped until the host receives it or incoming UPIUs
+	 * has an unexpected value for task tag, this raises.
+	 */
+	RX_UPIU_HIT_ERROR	= 1 << 19,
+};
+
 enum {
 	UNIPRO_L1_5 = 0,/* PHY Adapter */
 	UNIPRO_L2,	/* Data Link */
@@ -996,6 +1011,10 @@ static int exynos_ufs_init(struct ufs_hba *hba)
 		goto out;
 	exynos_ufs_specify_phy_time_attr(ufs);
 	exynos_ufs_config_smu(ufs);
+
+	/* enable vendor interrupts */
+	hci_writel(ufs, VENDOR_SPECIFIC_IE, RX_UPIU_HIT_ERROR);
+
 	return 0;
 
 phy_off:
@@ -1005,26 +1024,34 @@ static int exynos_ufs_init(struct ufs_hba *hba)
 	return ret;
 }
 
-static int exynos_ufs_host_reset(struct ufs_hba *hba)
+static int exynos_ufs_host_reset(struct exynos_ufs *ufs)
 {
-	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
 	unsigned long timeout = jiffies + msecs_to_jiffies(1);
-	u32 val;
-	int ret = 0;
-
-	exynos_ufs_disable_auto_ctrl_hcc_save(ufs, &val);
 
+	/* host reset */
 	hci_writel(ufs, UFS_SW_RST_MASK, HCI_SW_RST);
-
 	do {
 		if (!(hci_readl(ufs, HCI_SW_RST) & UFS_SW_RST_MASK))
-			goto out;
+			return 0;
+		cpu_relax();
 	} while (time_before(jiffies, timeout));
 
-	dev_err(hba->dev, "timeout host sw-reset\n");
-	ret = -ETIMEDOUT;
+	pr_err("timeout host sw-reset\n");
+	return -ETIMEDOUT;
+}
+
+static int exynos_ufs_host_init(struct ufs_hba *hba)
+{
+	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
+	u32 val;
+	int ret;
+
+	exynos_ufs_disable_auto_ctrl_hcc_save(ufs, &val);
+
+	ret = exynos_ufs_host_reset(ufs);
+	if (ret)
+		return ret;
 
-out:
 	exynos_ufs_auto_ctrl_hcc_restore(ufs, &val);
 	return ret;
 }
@@ -1110,7 +1137,7 @@ static int exynos_ufs_hce_enable_notify(struct ufs_hba *hba,
 
 	switch (status) {
 	case PRE_CHANGE:
-		ret = exynos_ufs_host_reset(hba);
+		ret = exynos_ufs_host_init(hba);
 		if (ret)
 			return ret;
 		exynos_ufs_dev_hw_reset(hba);
@@ -1198,6 +1225,38 @@ static int exynos_ufs_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	return 0;
 }
 
+static irqreturn_t exynos_ufs_isr(struct ufs_hba *hba)
+{
+	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
+	u32 status;
+	unsigned long flags;
+
+	if (!hba->priv) return IRQ_HANDLED;
+	status = hci_readl(ufs, VENDOR_SPECIFIC_IS);
+	hci_writel(ufs, status, VENDOR_SPECIFIC_IS);
+	/*
+	 * If host doesn't guarantee integrity of UTP transmission,
+	 * it needs to be reset immediately to make it unable to
+	 * proceed requests. Because w/o this, if UTP functions
+	 * in host doesn't work properly for such system power margins,
+	 * DATA IN from broken devices or whatever in the real world,
+	 * some unexpected events could happen, such as transferring
+	 * a broken DATA IN to a device. It could be various types of
+	 * problems on the level of file system. In this case, I think
+	 * blocking the host's functionality is the best strategy.
+	 * Perhaps, if its root cause is temporary, system could recover.
+	 */
+	if (status & RX_UPIU_HIT_ERROR) {
+		pr_err("%s: status: 0x%08x\n", __func__, status);
+		hba->force_reset = true;
+		hba->force_requeue = true;
+		scsi_schedule_eh(hba->host);
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		return IRQ_HANDLED;
+	}
+	return IRQ_NONE;
+}
+
 static struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.name				= "exynos_ufs",
 	.init				= exynos_ufs_init,
@@ -1209,6 +1268,7 @@ static struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.hibern8_notify			= exynos_ufs_hibern8_notify,
 	.suspend			= exynos_ufs_suspend,
 	.resume				= exynos_ufs_resume,
+	.intr				= exynos_ufs_isr,
 };
 
 static int exynos_ufs_probe(struct platform_device *pdev)
-- 
2.7.4

