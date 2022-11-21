Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35D3FC4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Nov 2022 00:35:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbiKUAfR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 20 Nov 2022 19:35:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbiKUAfB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Nov 2022 19:35:01 -0500
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF1DB2D
        for <linux-scsi@vger.kernel.org>; Sun, 20 Nov 2022 16:34:39 -0800 (PST)
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20221121003432epoutp03740d8169557d170f5c9194df01d2abf4~pclsfViD92369223692epoutp03r
        for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2022 00:34:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20221121003432epoutp03740d8169557d170f5c9194df01d2abf4~pclsfViD92369223692epoutp03r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1668990872;
        bh=BvjD1EvWtFZ3n4cwRbkPz7m31epfqvknwMJOF3uafG8=;
        h=From:To:Cc:Subject:Date:References:From;
        b=LxmZJSh27Pnna6ii4g2LtDj8MrcHGwS92l2x3fUI7fzWZD4RCETl1HABUHv0XYPiF
         AaNAXh4mYl+gNIB7/Q0yjKYLciqQPYIfjjfecjKE2l6ekXGW8SL7TBpHsOmT4kG5s9
         i2qS1U3T982PAPl4RVwiayvGGXri/s1qkHdnK4DQ=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20221121003432epcas1p3cb1fb6b4d4f600b36a6d212521b844ca~pclsEEivr0115401154epcas1p35;
        Mon, 21 Nov 2022 00:34:32 +0000 (GMT)
Received: from epsmges1p1.samsung.com (unknown [182.195.38.247]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4NFpLH3dqXz4x9QC; Mon, 21 Nov
        2022 00:34:31 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        5A.88.07146.797CA736; Mon, 21 Nov 2022 09:34:31 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20221121003431epcas1p1429429bf4bc1670c7b82b3889c017049~pclrBVIUi2214322143epcas1p1N;
        Mon, 21 Nov 2022 00:34:31 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221121003431epsmtrp118e53d077b451ab31169e28cf8c8fc5a~pclrAdtK11572115721epsmtrp13;
        Mon, 21 Nov 2022 00:34:31 +0000 (GMT)
X-AuditID: b6c32a35-205ff70000021bea-c0-637ac797c3d4
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        AF.E2.14392.697CA736; Mon, 21 Nov 2022 09:34:30 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.100.232]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221121003430epsmtip2c936a1b9499d6689cde8d38829accf4a~pclq3sapg0494604946epsmtip2R;
        Mon, 21 Nov 2022 00:34:30 +0000 (GMT)
From:   Chanwoo Lee <cw9316.lee@samsung.com>
To:     stanley.chu@mediatek.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, matthias.bgg@gmail.com,
        linux-scsi@vger.kernel.org, linux-mediatek@lists.infradead.org
Cc:     ChanWoo Lee <cw9316.lee@samsung.com>
Subject: [PATCH] scsi: ufs: ufs-mediatek: Remove unnecessary return code
Date:   Mon, 21 Nov 2022 09:33:38 +0900
Message-Id: <20221121003338.11034-1-cw9316.lee@samsung.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjk+LIzCtJLcpLzFFi42LZdlhTT3f68apkg4aPEhYzTrWxWiy6sY3J
        4nLzRUaL7us72CyWH//HZNHUYmyxdOtNRgd2j52z7rJ7TFh0gNFj85J6j5aT+1k8Pj69xeLR
        t2UVo8fnTXIB7FHZNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+
        AbpumTlA5ygplCXmlAKFAhKLi5X07WyK8ktLUhUy8otLbJVSC1JyCswK9IoTc4tL89L18lJL
        rAwNDIxMgQoTsjMOHWtmLjjPU7Hl9222BsZdXF2MHBwSAiYSUzcBmVwcQgI7GCWur7rPBOF8
        YpToWH+NHcL5xiixf9F2RpiOdbe8IOJ7GSVetnQDFXECOV8YJbo/y4PUsAloSdw+5g1SIyKw
        glHi6uFnLCA1zAIaEidnPQGrFxbwkGjY9Z8dpJ5FQFWi41gSSJhXwFpi/5c1rCC2hIC8xJ/7
        PcwQcUGJkzOfQI2Rl2jeOpsZZL6EwC12ia2tS5kgGlwkpn9rg7KFJV4d38IOYUtJvOxvY4do
        aGaU2Pb1EhOE08EosbH1BSNElbHEp8+fwb5kFtCUWL9LHyKsKLHz91xGiM18Eu++9rBCAoJX
        oqNNCKJERWJO1zk2mF0fbzyGesBD4veBa0yQ8ImVePn8PcsERvlZSP6ZheSfWQiLFzAyr2IU
        Sy0ozk1PLTYsMITHaXJ+7iZGcILUMt3BOPHtB71DjEwcjIcYJTiYlUR4RY5VJgvxpiRWVqUW
        5ccXleakFh9iNAUG8ERmKdHkfGCKziuJNzSxNDAxMzKxMLY0NlMS522YoZUsJJCeWJKanZpa
        kFoE08fEwSnVwJRZ9fZ1TwAb+60ouYklJadqlF7GSsn6t6y4cajgCvOms4ttZGeUFjzbsLkl
        aWZ4a6j94tm/TDbZLuXKvLz3kvtl9Wh+bs/Fd7VO/4h6L9H9fMIOQ0P21269+2tfnFivOcVw
        Rr1v5knLqGLz7YsmHCmuy0+Mmp8Xszz9TG5LcPuVA7ulOW1SjeTPP1m/9sumj0ZXOR5Y7f6p
        NsVebPKUBNbjK/xeyEdJFQqxV1w+uOfJdY+E6Sutm8u5O4zPyV75eMbjl1aNEL+nu+miwzr6
        7xyvrWFZv/kAM8Nupqk/3eYWfPo80yFjcXR8pO3X9oRtP+8ZaGjI1fW/Prlaj5FH56+7SV3t
        +aze91act060JCuxFGckGmoxFxUnAgDM4IyRGQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsWy7bCSvO6041XJBg1PrSxmnGpjtVh0YxuT
        xeXmi4wW3dd3sFksP/6PyaKpxdhi6dabjA7sHjtn3WX3mLDoAKPH5iX1Hi0n97N4fHx6i8Wj
        b8sqRo/Pm+QC2KO4bFJSczLLUov07RK4Mg4da2YuOM9TseX3bbYGxl1cXYwcHBICJhLrbnl1
        MXJxCAnsZpS4sm41SxcjJ1BcSmL3/vNsEDXCEocPF0PUfGKUuH5tKhNInE1AS+L2MW+QuIjA
        OkaJM9t+M4L0MgtoSJyc9YQdxBYW8JBo2PWfHaSeRUBVouNYEkiYV8BaYv+XNawQq+Ql/tzv
        YYaIC0qcnPmEBWKMvETz1tnMExj5ZiFJzUKSWsDItIpRMrWgODc9t9iwwDAvtVyvODG3uDQv
        XS85P3cTIzhgtTR3MG5f9UHvECMTB+MhRgkOZiURXpFjlclCvCmJlVWpRfnxRaU5qcWHGKU5
        WJTEeS90nYwXEkhPLEnNTk0tSC2CyTJxcEo1MJkpnHz785r5ksi/l6bO2xLJsVVKk5OVNTJj
        cuM0xbCgtxHMKZ0CYRq6ezIZ105QFflonLW+5YHSzTmsE1r6v/w4w6d5+pJA0fH5yiK2Gkdf
        iK5WTDbe9/bZmrnLltcyKGuVZvhzCXxTepNfsEq9vCu0vWPquznNDytuTEiZsyqgUuvIn5Pn
        GL2fzVhzvmvfIZ68BYnLS7meX+JL6ODjmu70gl9itvTu6LI7vlcWxdnEigb+XqV1sIDJ5+yk
        zTNldxad/M6atuzbpgkHa8xcrFWD9PKyVxR/ljuXKeeh/S/jydpfwpN7Tgk0zSy9e1y0YkNI
        eXDUmbJ0pp8KXdePrUjtnBRgqHfuvb9syrXnxUosxRmJhlrMRcWJADuug1bHAgAA
X-CMS-MailID: 20221121003431epcas1p1429429bf4bc1670c7b82b3889c017049
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221121003431epcas1p1429429bf4bc1670c7b82b3889c017049
References: <CGME20221121003431epcas1p1429429bf4bc1670c7b82b3889c017049@epcas1p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: ChanWoo Lee <cw9316.lee@samsung.com>

Modify to remove unnecessary 'return 0' code.

Signed-off-by: ChanWoo Lee <cw9316.lee@samsung.com>
---
 drivers/ufs/host/ufs-mediatek.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index ef5816d82326..21d9b047539f 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1095,7 +1095,7 @@ static void ufs_mtk_setup_clk_gating(struct ufs_hba *hba)
 	}
 }
 
-static int ufs_mtk_post_link(struct ufs_hba *hba)
+static void ufs_mtk_post_link(struct ufs_hba *hba)
 {
 	/* enable unipro clock gating feature */
 	ufs_mtk_cfg_unipro_cg(hba, true);
@@ -1106,8 +1106,6 @@ static int ufs_mtk_post_link(struct ufs_hba *hba)
 			FIELD_PREP(UFSHCI_AHIBERN8_SCALE_MASK, 3);
 
 	ufs_mtk_setup_clk_gating(hba);
-
-	return 0;
 }
 
 static int ufs_mtk_link_startup_notify(struct ufs_hba *hba,
@@ -1120,7 +1118,7 @@ static int ufs_mtk_link_startup_notify(struct ufs_hba *hba,
 		ret = ufs_mtk_pre_link(hba);
 		break;
 	case POST_CHANGE:
-		ret = ufs_mtk_post_link(hba);
+		ufs_mtk_post_link(hba);
 		break;
 	default:
 		ret = -EINVAL;
@@ -1272,9 +1270,8 @@ static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
 	struct arm_smccc_res res;
 
 	if (status == PRE_CHANGE) {
-		if (!ufshcd_is_auto_hibern8_supported(hba))
-			return 0;
-		ufs_mtk_auto_hibern8_disable(hba);
+		if (ufshcd_is_auto_hibern8_supported(hba))
+			ufs_mtk_auto_hibern8_disable(hba);
 		return 0;
 	}
 
-- 
2.29.0

