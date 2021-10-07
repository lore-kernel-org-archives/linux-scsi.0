Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7226C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 08:12:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2AE661163
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 08:12:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240649AbhJGIN7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 04:13:59 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:43994 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240634AbhJGIN5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 04:13:57 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20211007081203epoutp02ad569fd19c72a7a2cfd8b087e40f94ef~rsWGzFs8R0347003470epoutp02b
        for <linux-scsi@vger.kernel.org>; Thu,  7 Oct 2021 08:12:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20211007081203epoutp02ad569fd19c72a7a2cfd8b087e40f94ef~rsWGzFs8R0347003470epoutp02b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1633594323;
        bh=0NdoKOIF/6qVExksciypQ5TS6mbut5eWWv49K7bpieU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A/6syUtmY+SWpsRSb+4FF4v8hYWRNDb9zQ3rKaZwcnajiAUWYIpXLvDP+1dmc9Eqs
         CeOGRNRr6o/rJ8ygOih8B6LRNdqGokmNcYSAlQfoGI8ZEqlErUXtNrk/5aPgnWL+Tf
         BmRE6CC/9u+LNeg+Lntjb4OZnM4jDvPkajHanUpY=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20211007081144epcas2p14dac65fe5e33e4aa4b30365f98740baa~rsV1PfLAL0150001500epcas2p1x;
        Thu,  7 Oct 2021 08:11:44 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.98]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4HQ3tz5JRzz4x9Q3; Thu,  7 Oct
        2021 08:11:39 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        B5.6F.09717.ABBAE516; Thu,  7 Oct 2021 17:11:38 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20211007081134epcas2p1f4e1d77c82c3cd7647c0fa9f1fdca053~rsVsc28-q1709017090epcas2p1h;
        Thu,  7 Oct 2021 08:11:34 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20211007081134epsmtrp2e35f143982ce0fdb310d084cbd6e8d59~rsVsb2nW92686626866epsmtrp2_;
        Thu,  7 Oct 2021 08:11:34 +0000 (GMT)
X-AuditID: b6c32a45-4c1ff700000025f5-41-615eabba589e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        92.63.09091.6BBAE516; Thu,  7 Oct 2021 17:11:34 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211007081134epsmtip2ae1087ab0f15514a2fa2f79c007f3b5d~rsVsNKFO40435204352epsmtip2k;
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
Subject: [PATCH v4 08/16] scsi: ufs: ufs-exynos: support custom version of
 ufs_hba_variant_ops
Date:   Thu,  7 Oct 2021 17:09:26 +0900
Message-Id: <20211007080934.108804-9-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211007080934.108804-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te1BUVRzHOfde7l6obW4L6pllsvU6DUIBu8jjkiCk2NwGpmBysqlJuMJt
        QZbdde/SiDWGkvJmMChgJXJw1AaQnSUeK/ESBCWyoG1DMLUQJ2AiWQl5KbS7F8v/vr9zPt/z
        Pb/zIFDJBC4lUtV6TqdmVRTujrX0+gT7tdXtZ+W9tyE9MFGP079Xt+D01JIVpy//kYfRX84u
        ofQD43lX2tL1Ml14aTc9WFKD0BNGA0rX3GhB6BvLJ11p08wiQo829WF0xU+dCF0wYsbpC1dX
        EXplqQeJkjCWX2IYQ1YRzliKixDm2298mbPtUwjTWJuHMyU13YBZMObijO3eGMYUN9UCZq5x
        M5PTXYDEPfteWngKxyZzOhmnTtIkp6qVEVTM2wm7E4JD5Ao/RRgdSsnUbDoXQUXHxvm9nqqy
        N0fJPmJVGfahOJbnqYCd4TpNhp6TpWh4fQTFaZNV2lCtP8+m8xlqpb+a07+qkMsDg+1gYlrK
        zyuFuLZBfHjWelmUBRqfyQduBCSDYL+hE88H7oSENANY/uskEIoHAN4ZtooclIR8COBQZ9IT
        R3ZlPyZAHQB2LZtEQmEDsOLaI8xB4aQfbPpz2rmUJ3kfwIm7ZU4KJe+hsHqxCHdQHmQitI2O
        AIfGyJdgr8ni1GIyEp5esKFC3ovwynKeU7uRUbC97SIuMM/DgcoJZxpqZ7KbT6OOAEhOEvDE
        8WFcMEfD76brXQXtAaevNokELYVzf3fggqEAwBPja+sTdQDmHYsVdCRcLm+ymwl7gg80tgU4
        JCS3witj67nPwdzexyJhWAxzT0oEozfsbi3HBP0CLKiaW98BAwtXp9YPuxTABqsBKQEyw1Pt
        GJ5qx/B/8BmA1oKNnJZPV3J8oFbx3x0nadIbgfO5++4xg9KZWf8egBCgB0ACpTzFmsgPWIk4
        mc08wuk0CboMFcf3gGD7YZ9CpRuSNPb/otYnKILC5EEhIYrQwGB5KLVJ/NXqLlZCKlk9l8Zx
        Wk73xIcQbtIsRIXfKnE9UrB0cFPWgdR3vC96Zy3/s5cdUn7eejS2lVis3zdzM3L/2ZEPI9oz
        ZcdthkOfynbgpT9sM5ruelxvpeR3GjJ/HOpfO7SSMzL5BX2rKOYxERlfpR3HLH1jo/XSkP63
        HgHD3g3Fk0eXesIuGNk3PjGRwwSl6nff/vX4+GKiPnexxnz4zPz2LZbb0pY9Qa8M/qaUvDtv
        Hc2s2yxSr+aYKl3KOs5d3xaVPvBxWaz53M3m0JY38wPup2xNrdvSx60c6D0Yfc3r4Wtr2Z+F
        e9U0r+yIb9iI+UhFUTuj9w128V5duy6ZE48lfR/hNV/VNlwe7yL3tJ0ynl+o+kv3frVvRa4L
        hfEprMIX1fHsv/2b2tp3BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsWy7bCSvO621XGJBmsniVicfLKGzeLBvG1s
        Fi9/XmWzOPiwk8Vi2oefzBaf1i9jtbi8X9uiZ6ezxekJi5gsnqyfxWyx6MY2Josbv9pYLTa+
        /cFkcXPLURaLGef3MVl0X9/BZrH8+D8mi98/DzE5CHlcvuLtMauhl83jcl8vk8fmFVoei/e8
        ZPLYtKqTzWPCogOMHt/Xd7B5fHx6i8Wjb8sqRo/Pm+Q82g90MwXwRHHZpKTmZJalFunbJXBl
        XPrdw1awjrfiw9WD7A2Mm7i7GDk5JARMJJpnHmMBsYUEdjNKbDkXBhGXlXj2bgc7hC0scb/l
        CGsXIxdQzXtGibYtx8Ea2AR0JbY8f8UIYosIfGSUmPNNC6SIWeAjs8SdlUvAioQF4iS+/uwA
        m8QioCpxeONlsAZeAXuJ2d8/MkNskJc48qsTzOYUcJDYs2stWxcjB9A2e4muv5EQ5YISJ2c+
        ARvJDFTevHU28wRGgVlIUrOQpBYwMq1ilEwtKM5Nzy02LDDMSy3XK07MLS7NS9dLzs/dxAiO
        QC3NHYzbV33QO8TIxMF4iFGCg1lJhDffPjZRiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+FrpPx
        QgLpiSWp2ampBalFMFkmDk6pBqZTRTnmceJ1DP2LRNYlvebPcdIX79LjvXj+6sIpS/fzydy7
        IqF31/VQWand7fNyizwndRiVi09+W7P5gvbaU537pt8o+sZz5vYCobX8U0RNmN7JLBP+ejTt
        3ycHeW7+/ansh3Iy+OMdD2XLPt3NKea//9ulvEV+bAt9bfsSxP7OPx3rPMu41T2yOzJhy+t3
        /pYnzS8/u+7mw/2fa1afVpfBHcbbLGplXGLsG65OD9d0tz9+efnXK62nP5zyjb+2rvBWhNse
        8z2y3onTc2M9F1X/2ZwudLbeTOm8+aqsa6sjbsnON5yv43PKyaDCWNf76esf963MfYwthP4I
        Hjw+McQreNbsJ1XcXiuVs87OFFBiKc5INNRiLipOBABzhWlzLwMAAA==
X-CMS-MailID: 20211007081134epcas2p1f4e1d77c82c3cd7647c0fa9f1fdca053
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211007081134epcas2p1f4e1d77c82c3cd7647c0fa9f1fdca053
References: <20211007080934.108804-1-chanho61.park@samsung.com>
        <CGME20211007081134epcas2p1f4e1d77c82c3cd7647c0fa9f1fdca053@epcas2p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

By default, ufs_hba_exynos_ops will be used but this patch supports to
use custom version of ufs_hba_variant_ops because some variants of
exynos-ufs will use only few callbacks.

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 8 +++++++-
 drivers/scsi/ufs/ufs-exynos.h | 1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 41797f499544..8df792071a0a 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -1233,8 +1233,14 @@ static int exynos_ufs_probe(struct platform_device *pdev)
 {
 	int err;
 	struct device *dev = &pdev->dev;
+	const struct ufs_hba_variant_ops *vops = &ufs_hba_exynos_ops;
+	const struct exynos_ufs_drv_data *drv_data =
+		device_get_match_data(dev);
 
-	err = ufshcd_pltfrm_init(pdev, &ufs_hba_exynos_ops);
+	if (drv_data && drv_data->vops)
+		vops = drv_data->vops;
+
+	err = ufshcd_pltfrm_init(pdev, vops);
 	if (err)
 		dev_err(dev, "ufshcd_pltfrm_init() failed %d\n", err);
 
diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
index 2e72aabaa673..74f556d8a003 100644
--- a/drivers/scsi/ufs/ufs-exynos.h
+++ b/drivers/scsi/ufs/ufs-exynos.h
@@ -142,6 +142,7 @@ struct exynos_ufs_uic_attr {
 };
 
 struct exynos_ufs_drv_data {
+	const struct ufs_hba_variant_ops *vops;
 	struct exynos_ufs_uic_attr *uic_attr;
 	unsigned int quirks;
 	unsigned int opts;
-- 
2.33.0

