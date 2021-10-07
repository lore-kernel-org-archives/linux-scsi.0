Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33CE4C43219
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 08:12:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F34561163
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 08:12:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240703AbhJGIOO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 04:14:14 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:46047 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240648AbhJGIOE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 04:14:04 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20211007081210epoutp045cd76f63b6602adb1d94ea615144d602~rsWNVfyzB0261602616epoutp04v
        for <linux-scsi@vger.kernel.org>; Thu,  7 Oct 2021 08:12:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20211007081210epoutp045cd76f63b6602adb1d94ea615144d602~rsWNVfyzB0261602616epoutp04v
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1633594330;
        bh=Iv1/wcOGyQsI39zsBhCRKBpFtBXAYy8a+V3phfuPAxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cgthj0wzPWKLzPWsp/6P7WTrMqwDWjirWpa2zR69aTDJKb3pu9nirDzPY1URnEDpG
         Bgacnv3XUVKmvV5geuYTpy6YFOXThEDSR2qSY3XswNJ9gc93kAOF2E/hQ/baPSF/DM
         096WAeWyx6KJB8mse2sliUac1R9fbVcq7B5PhSfA=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20211007081150epcas2p4d1bb9360b9e8a306ae39324f97623f98~rsV6yuZla2608526085epcas2p4b;
        Thu,  7 Oct 2021 08:11:50 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.36.101]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4HQ3v76ZQGz4x9Zb; Thu,  7 Oct
        2021 08:11:47 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        34.A8.09816.DBBAE516; Thu,  7 Oct 2021 17:11:41 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20211007081135epcas2p22a653765a6e520d1da1ba1ceb3f7fa25~rsVswTl9S2768327683epcas2p2P;
        Thu,  7 Oct 2021 08:11:35 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20211007081135epsmtrp2f9839e9aebd53658e820f28ebc9cd8a0~rsVsvHFL92686626866epsmtrp2-;
        Thu,  7 Oct 2021 08:11:35 +0000 (GMT)
X-AuditID: b6c32a46-625ff70000002658-17-615eabbd79df
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F4.63.09091.6BBAE516; Thu,  7 Oct 2021 17:11:34 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211007081134epsmtip2a129942bc9c6792198cf78236ef814d8~rsVshyFj-0776407764epsmtip2T;
        Thu,  7 Oct 2021 08:11:34 +0000 (GMT)
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
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v4 11/16] scsi: ufs: ufs-exynos: add pre/post_hce_enable drv
 callbacks
Date:   Thu,  7 Oct 2021 17:09:29 +0900
Message-Id: <20211007080934.108804-12-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211007080934.108804-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJsWRmVeSWpSXmKPExsWy7bCmqe7e1XGJBv/ealmcfLKGzeLBvG1s
        Fi9/XmWzOPiwk8Vi2oefzBaf1i9jtbi8X9uiZ6ezxekJi5gsnqyfxWyx6MY2Josbv9pYLTa+
        /cFkcXPLURaLGef3MVl0X9/BZrH8+D8mi98/DzE5CHlcvuLtMauhl83jcl8vk8fmFVoei/e8
        ZPLYtKqTzWPCogOMHt/Xd7B5fHx6i8Wjb8sqRo/Pm+Q82g90MwXwRGXbZKQmpqQWKaTmJeen
        ZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gA9p6RQlphTChQKSCwuVtK3synK
        Ly1JVcjILy6xVUotSMkpMC/QK07MLS7NS9fLSy2xMjQwMDIFKkzIzrh//ilbwXu+ikVXFrI0
        MJ7k6WLk5JAQMJH4+fEdUxcjF4eQwA5GiTXzdrFBOJ8YJc5tmcYO4XxjlLj+YyNjFyMHWMvr
        HYkg3UICexklLn6ph6j5yCgx79suZpAEm4CuxJbnrxhBEiIC7xklnjyeAjaJWeAps8S8H71s
        IFXCAhES7y+CdHBwsAioSux6XAgS5hVwkFjS/ocF4j55iSO/OsGGcgLF9+xaywZRIyhxcuYT
        sBpmoJrmrbOZQeZLCLzhkOhueMgM0ewicez9fnYIW1ji1fEtULaUxOd3e9kgGroZJVof/YdK
        rGaU6Gz0gbDtJX5N38IKchyzgKbE+l36EN8rSxy5BbWXT6Lj8F92iDCvREebEESjusSB7dOh
        zpeV6J7zmRXC9pD4sH8tNKgnM0pMX3+QaQKjwiwk78xC8s4shMULGJlXMYqlFhTnpqcWGxUY
        wWM4OT93EyM4sWu57WCc8vaD3iFGJg7GQ4wSHMxKIrz59rGJQrwpiZVVqUX58UWlOanFhxhN
        gWE9kVlKNDkfmFvySuINTSwNTMzMDM2NTA3MlcR55/5zShQSSE8sSc1OTS1ILYLpY+LglGpg
        qo4/0Tmv5uv9CZG3ChosWR76H62T3V2v8mNq/XvRuv7SL8tS1saz6/j7bf3avPOP1vq66BV1
        8w9t2uDAyP4+mHvtTb5H8psu5zKeTr8c8SP14zZty8oZTcHdy3+HqZyYv8To2kkD/dO/M3UO
        9pavnvE4/vMFn76LkRm2Pc7KvvVX8ssZoxZsimgtdGguKz179bTd88qP08Rz17Is3L4q6XaN
        xdWavdM+P7y2+d8VrtJv1qX60g3JMbGnHz05L96Q/F9y8X/90h/79lTH3A+T1Jm48AtHXOeH
        nLqlxzb/ua1i//mcuMru5d6B7Pf2lkmf32t+d3XCaq9/LPf/n2GNn2Ruc4PpSDtfa65TvdfL
        KCWW4oxEQy3mouJEAAN0GBd1BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsWy7bCSvO621XGJBoefalicfLKGzeLBvG1s
        Fi9/XmWzOPiwk8Vi2oefzBaf1i9jtbi8X9uiZ6ezxekJi5gsnqyfxWyx6MY2Josbv9pYLTa+
        /cFkcXPLURaLGef3MVl0X9/BZrH8+D8mi98/DzE5CHlcvuLtMauhl83jcl8vk8fmFVoei/e8
        ZPLYtKqTzWPCogOMHt/Xd7B5fHx6i8Wjb8sqRo/Pm+Q82g90MwXwRHHZpKTmZJalFunbJXBl
        3D//lK3gPV/FoisLWRoYT/J0MXJwSAiYSLzekdjFyMUhJLCbUaLh5yemLkZOoLisxLN3O9gh
        bGGJ+y1HWCGK3jNKbNwwEayITUBXYsvzV4wgtojAR0aJOd+0QIqYBT4yS9xZuYQFJCEsECax
        ffcXFpBtLAKqErseF4KEeQUcJJa0/2GBWCAvceRXJzOIzQkU37NrLRtIuZCAvUTX30iIckGJ
        kzOfgJUzA5U3b53NPIFRYBaS1CwkqQWMTKsYJVMLinPTc4sNCwzzUsv1ihNzi0vz0vWS83M3
        MYLjT0tzB+P2VR/0DjEycTAeYpTgYFYS4c23j00U4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuh
        62S8kEB6YklqdmpqQWoRTJaJg1OqgSlBss+3wD+kYUbEpdpidodL71v5yt63/r23Z+8MsR/P
        LZzaPW5eNjLrLJjqt1qZ31S7ZYL+gwVTWu53MzWwTsl+r212bmrH7s3cZjxrzzm5nLi4cOVb
        289HI0wnK3A7pz+0OqH6wOP45sqLJ+otUp7+LVys9+nIvTk1eUd2MX+oO/lj1rRaiTOWvOZb
        1iku05xw47muPNuB/dNl4k46rnGo/VsUys17Vil9laDyvxRW7QTpZMnUQJ/1Sz34T8/7HZNZ
        x7/+XOBEqaUnObeEMf7c+HTSg6mPNV7v2Zjudf+WSufHLYscz9ReZdps/Jf7yu7v3pGr2+NY
        Iww7bHM/a3jKLy/sCbl7y6hErXNy3UslluKMREMt5qLiRACVGjReLgMAAA==
X-CMS-MailID: 20211007081135epcas2p22a653765a6e520d1da1ba1ceb3f7fa25
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211007081135epcas2p22a653765a6e520d1da1ba1ceb3f7fa25
References: <20211007080934.108804-1-chanho61.park@samsung.com>
        <CGME20211007081135epcas2p22a653765a6e520d1da1ba1ceb3f7fa25@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds driver-specific pre/post_hce_enable callbacks to execute
extra initializations before and after hce_enable_notify callback.

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 10 ++++++++++
 drivers/scsi/ufs/ufs-exynos.h |  2 ++
 2 files changed, 12 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 2dae90758f8f..ae85942c08ae 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -1136,6 +1136,12 @@ static int exynos_ufs_hce_enable_notify(struct ufs_hba *hba,
 
 	switch (status) {
 	case PRE_CHANGE:
+		if (ufs->drv_data->pre_hce_enable) {
+			ret = ufs->drv_data->pre_hce_enable(ufs);
+			if (ret)
+				return ret;
+		}
+
 		ret = exynos_ufs_host_reset(hba);
 		if (ret)
 			return ret;
@@ -1145,6 +1151,10 @@ static int exynos_ufs_hce_enable_notify(struct ufs_hba *hba,
 		exynos_ufs_calc_pwm_clk_div(ufs);
 		if (!(ufs->opts & EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL))
 			exynos_ufs_enable_auto_ctrl_hcc(ufs);
+
+		if (ufs->drv_data->post_hce_enable)
+			ret = ufs->drv_data->post_hce_enable(ufs);
+
 		break;
 	}
 
diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
index 89955ae226dc..02308faea422 100644
--- a/drivers/scsi/ufs/ufs-exynos.h
+++ b/drivers/scsi/ufs/ufs-exynos.h
@@ -154,6 +154,8 @@ struct exynos_ufs_drv_data {
 				struct ufs_pa_layer_attr *pwr);
 	int (*post_pwr_change)(struct exynos_ufs *ufs,
 				struct ufs_pa_layer_attr *pwr);
+	int (*pre_hce_enable)(struct exynos_ufs *ufs);
+	int (*post_hce_enable)(struct exynos_ufs *ufs);
 };
 
 struct ufs_phy_time_cfg {
-- 
2.33.0

