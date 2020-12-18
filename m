Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C3AEC2BBCF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 07:42:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC6CB23A1E
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 07:42:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbgLRHmq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Dec 2020 02:42:46 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:54641 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbgLRHmp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2020 02:42:45 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20201218074201epoutp043058ece2755b0960b85be83407d9f750~Rv7PnJxj41270712707epoutp04C
        for <linux-scsi@vger.kernel.org>; Fri, 18 Dec 2020 07:42:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20201218074201epoutp043058ece2755b0960b85be83407d9f750~Rv7PnJxj41270712707epoutp04C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608277321;
        bh=1eznudDb9pMmsTWiLYk6VcT0dlz00yiAIDtdPsCSGCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=MIM7jEd3uIcnY/ClD1Q5E9dIwNGUhG9M773zWz6dwxqZXvM7HPJGqX2xehB0cKGKw
         uzaHKkFFGBrmdH3Hth2njTgF/jbbLs2lG4ch5Ow95kX7ra3CJXVoPeSNU5g+bxsIWY
         lA5/BMS2boPjvIb0N2YRDWRgbQIQ/uqJRSWL5W9k=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20201218074152epcas2p1407ed13e7bdd394a27874f117f383356~Rv7HTLuDm0841308413epcas2p1V;
        Fri, 18 Dec 2020 07:41:52 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.182]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4Cy15m5HvxzMqYkf; Fri, 18 Dec
        2020 07:41:48 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        53.5B.05262.B3D5CDF5; Fri, 18 Dec 2020 16:41:47 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20201218074145epcas2p3563711f5d05a41dff0602d3e7aef5891~Rv7As-gQk2281922819epcas2p3d;
        Fri, 18 Dec 2020 07:41:45 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201218074145epsmtrp180086c6c74cdfb097ad0df3c12574a40~Rv7AsEDKd1822618226epsmtrp1V;
        Fri, 18 Dec 2020 07:41:45 +0000 (GMT)
X-AuditID: b6c32a47-b97ff7000000148e-46-5fdc5d3bf5c8
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        38.61.08745.93D5CDF5; Fri, 18 Dec 2020 16:41:45 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20201218074145epsmtip11b9d90ec82a62e8fc98cf9c68bdbae6e~Rv7Aa1JgK2655626556epsmtip1j;
        Fri, 18 Dec 2020 07:41:45 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RFC PATCH v1 2/2] ufs: ufs-exynos: apply vendor specifics for
 three timeouts
Date:   Fri, 18 Dec 2020 16:30:51 +0900
Message-Id: <5bf1a6fa16c010878b1dd7155256954fab548801.1608276380.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1608276380.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1608276380.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPJsWRmVeSWpSXmKPExsWy7bCmqa517J14g8Y/XBYP5m1js9jbdoLd
        4uXPq2wWBx92slh8XfqM1WLah5/MFp/WL2O1+PV3PbvF6sUPWCwW3djGZHFzy1EWi+7rO9gs
        lh//x2TRdfcGo8XSf29ZHPg9Ll/x9rjc18vkMWHRAUaP7+s72Dw+Pr3F4tG3ZRWjx+dNch7t
        B7qZAjiicmwyUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJz
        gI5XUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BQYGhboFSfmFpfmpesl5+daGRoY
        GJkCVSbkZKzqEyvo566Y/OMNawPjYs4uRk4OCQETie+7prJ0MXJxCAnsYJTYOmE2G4TziVFi
        8oUGJgjnM6PE+5+fWWBaJv0+xgyR2MUoMW9bKyuE84NRYsvE58wgVWwCmhJPb04FaxcROMMk
        ca31LCtIgllAXWLXhBNMILawQITEsdsPwOIsAqoSb++1g8V5BaIlvi+Zzg6xTk7i5rlOsKGc
        ApYSS/ogehFsLqCamRwSLYu+MUM0uEhs+PWVCcIWlnh1fAvUICmJl/1tUHa9xL6pDawQzT2M
        Ek/3/WOESBhLzHrWDmRzAF2qKbF+lz6IKSGgLHHkFgvE/XwSHYf/skOEeSU62oQgGpUlfk2a
        DDVEUmLmzTtQJR4S2++KQcIHaNHPyTfYJjDKz0KYv4CRcRWjWGpBcW56arFRgTFy7G1iBKdU
        LfcdjDPeftA7xMjEwXiIUYKDWUmEN/TB7Xgh3pTEyqrUovz4otKc1OJDjKbAcJzILCWanA9M
        6nkl8YamRmZmBpamFqZmRhZK4ryhK/vihQTSE0tSs1NTC1KLYPqYODilGpg0+4+rcl3V7Tyj
        afc98TIrs/subb3I39MErh4842F/iduTI+jv2wmL+HZHBCiu+LkuXizoxMwT5ww87h2I2Psq
        X/m2YyXHl5NM0loLD09nX/R10p/n609PcI7ax9z9ZInv58V/yzLMPovl6i0oOTPDjG3+LJu2
        MJPmJQICmy3EpjsUx76175331fx3pKSAzxdh9ZzmBXG8L333Jife5TX1vdxfx1wVp1r5Mt9r
        6rpnz5sP77Bvee1Uv+Wo/+07ghP2HbzX7HKhV2Dlg9X6nsb1JfXC6tvFxKeqCD0wqy9VWpH0
        Qt3WzFvk+WbxjFntTd1fn76bx3EzItHzdm6h3NHE+KBNfMyqRs/FvE41TFViKc5INNRiLipO
        BADQ5c/5MgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWy7bCSnK5l7J14g7UTuCwezNvGZrG37QS7
        xcufV9ksDj7sZLH4uvQZq8W0Dz+ZLT6tX8Zq8evvenaL1YsfsFgsurGNyeLmlqMsFt3Xd7BZ
        LD/+j8mi6+4NRoul/96yOPB7XL7i7XG5r5fJY8KiA4we39d3sHl8fHqLxaNvyypGj8+b5Dza
        D3QzBXBEcdmkpOZklqUW6dslcGWs6hMr6OeumPzjDWsD42LOLkZODgkBE4lJv48xdzFycQgJ
        7GCUmPr3ADtEQlLixM7njBC2sMT9liOsEEXfGCU2zJ8DlmAT0JR4enMqE0hCROAek8SlCXOZ
        QRLMAuoSuyacYAKxhQXCJO4vuA1mswioSry91w5m8wpES3xfMh1qm5zEzXOdYL2cApYSS/og
        eoUELCTu/+xmwiU+gVFgASPDKkbJ1ILi3PTcYsMCo7zUcr3ixNzi0rx0veT83E2M4JjQ0trB
        uGfVB71DjEwcjIcYJTiYlUR4Qx/cjhfiTUmsrEotyo8vKs1JLT7EKM3BoiTOe6HrZLyQQHpi
        SWp2ampBahFMlomDU6qBaXd4oVJ+wN0vl6MF3y0u3sLgOn32uuX9STLP7h3I2RWZ+Ky39Kwg
        t0tE2EeWjVxyzzT3m55TvqOWu+GE8GpWh31yM65OythS5rP7VniJ48t1+wokm1NPsCZem3Lr
        uxujFyfvkcVC6exmMiYuW+6zzPO5v+PR0/cJnq3sa5iWOK/ae25uTGnJCVEBM5d7+r9nL28M
        uvtrZp2OVoDzI4urH3ZENGRyG645sMD19J4Pz5tuCTXc2CmZ6v76G9/hHRsvZkucjtOJfc3/
        1batVcH8kcmcd4/LqhPCTq86Zmi9JnvmM/GJJ1+nm5q2zbpjYlwVnmT564puz9bEJu2EKaJq
        D1/+uaS+YGVm45vy131L/imxFGckGmoxFxUnAgD1RYGX+AIAAA==
X-CMS-MailID: 20201218074145epcas2p3563711f5d05a41dff0602d3e7aef5891
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201218074145epcas2p3563711f5d05a41dff0602d3e7aef5891
References: <cover.1608276380.git.kwmad.kim@samsung.com>
        <CGME20201218074145epcas2p3563711f5d05a41dff0602d3e7aef5891@epcas2p3.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set optimized values for those timeouts
- FC0_PROTECTION_TIMER
- TC0_REPLAY_TIMER
- AFC0_REQUEST_TIMER

Exynos doesn't yet use traffic class #1.

Change-Id: Ib672b554ea109159cd75ff67a111f46ebff4a7dc
Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index a8770ff..1ea8244 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -640,6 +640,11 @@ static int exynos_ufs_pre_pwr_mode(struct ufs_hba *hba,
 		}
 	}
 
+	/* setting for three timeout values for traffic class #0 */
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA0), 8064);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA1), 28224);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA2), 20160);
+
 	return 0;
 out:
 	return ret;
@@ -1236,7 +1241,8 @@ struct exynos_ufs_drv_data exynos_ufs_drvs = {
 				  UFSHCI_QUIRK_BROKEN_HCE |
 				  UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR |
 				  UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR |
-				  UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL,
+				  UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL |
+				  UFSHCD_QUIRK_SKIP_VENDOR_SPECIFIC_BEFORE_PMC,
 	.opts			= EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL |
 				  EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL |
 				  EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX |
-- 
2.7.4

