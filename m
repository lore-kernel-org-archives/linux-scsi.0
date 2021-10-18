Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7C30C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 12:45:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F39160F8F
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 12:45:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbhJRMr2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 08:47:28 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:63926 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231713AbhJRMrZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Oct 2021 08:47:25 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20211018124510epoutp04ef5fd6887e36cbd3e11a7213506a76e9~vIKtuIWXb0084700847epoutp04H
        for <linux-scsi@vger.kernel.org>; Mon, 18 Oct 2021 12:45:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20211018124510epoutp04ef5fd6887e36cbd3e11a7213506a76e9~vIKtuIWXb0084700847epoutp04H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1634561110;
        bh=Wbw1uYcgqE0JizNW8QWxlyzchdmZ9mpTecbu25VPqWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rc8GfBF4o8SVuej6jdv9G9JFfzsfwV2S2iMqTgvfUciPpwOEr801oS9ye6iSxgOSL
         TY/R7Mh/pNXJBY4TsGSpOs/akSdjetkusiuzCtwx/IGV4MEAzIpoxJODm7xl25Q28w
         X86HykAx7lOT0c75nf86XTm5ztIV9X5g7o+PA0+o=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20211018124509epcas2p1a72827a7f16b6932638f1bdf472dfb0f~vIKsl8Ylc2115521155epcas2p1K;
        Mon, 18 Oct 2021 12:45:09 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.102]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4HXxRQ5LKXz4x9Q3; Mon, 18 Oct
        2021 12:45:06 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        3E.2C.10014.25C6D616; Mon, 18 Oct 2021 21:45:06 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20211018124505epcas2p37bd15e319f80e82d321f85565afd7712~vIKpjlyD_2766327663epcas2p3K;
        Mon, 18 Oct 2021 12:45:05 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20211018124505epsmtrp22fba3e711f454f893b2a986e168026b0~vIKpisOlN2052720527epsmtrp2L;
        Mon, 18 Oct 2021 12:45:05 +0000 (GMT)
X-AuditID: b6c32a47-473ff7000000271e-8e-616d6c527272
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        B0.50.08738.15C6D616; Mon, 18 Oct 2021 21:45:05 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211018124505epsmtip22dc0e8ec2fb74e1fed0bf12aafdbb456~vIKpVu8cA0439304393epsmtip2I;
        Mon, 18 Oct 2021 12:45:05 +0000 (GMT)
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
Subject: [PATCH v5 10/15] scsi: ufs: ufs-exynos: add pre/post_hce_enable drv
 callbacks
Date:   Mon, 18 Oct 2021 21:42:11 +0900
Message-Id: <20211018124216.153072-11-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211018124216.153072-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJsWRmVeSWpSXmKPExsWy7bCmuW5QTm6iwdlOCYuTT9awWTyYt43N
        4uXPq2wWBx92slhM+/CT2eLT+mWsFpf3a1v07HS2OD1hEZPFk/WzmC0W3djGZHHjVxurxca3
        P5gsbm45ymIx4/w+Jovu6zvYLJYf/8dk8fvnISYHIY/LV7w9ZjX0snlc7utl8ti8Qstj8Z6X
        TB6bVnWyeUxYdIDR4/v6DjaPj09vsXj0bVnF6PF5k5xH+4FupgCeqGybjNTElNQihdS85PyU
        zLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKDnlBTKEnNKgUIBicXFSvp2NkX5
        pSWpChn5xSW2SqkFKTkF5gV6xYm5xaV56Xp5qSVWhgYGRqZAhQnZGS0XxAre81XcePybuYHx
        JE8XIyeHhICJRNu648xdjFwcQgI7GCU6/z1ig3A+MUqsfvcEKvOZUWLDvdfsMC0bl1xmhEjs
        YpS49P84K4TzkVFiwZwzzCBVbAK6EluevwKrEhF4zyjx5PEUdhCHWeAps8S8H71AWzg4hAUi
        JNZtNQFpYBFQlXjfuJgJxOYVcJC4/v0vI8Q6eYkjvzrBhnICxXsWHYGqEZQ4OfMJC4jNDFTT
        vHU22K0SAi84JA7+u8YG0ewiceDuJyYIW1ji1fEtUD9ISXx+t5cNoqGbUaL10X+oxGpgGDT6
        QNj2Er+mb2EFOZRZQFNi/S59EFNCQFniyC2ovXwSHYf/skOEeSU62oQgGtUlDmyfzgJhy0p0
        z/nMCmF7ANkHoYE1mVFiU9MW1gmMCrOQvDMLyTuzEBYvYGRexSiWWlCcm55abFRgDI/i5Pzc
        TYzg1K7lvoNxxtsPeocYmTgYDzFKcDArifAmueYmCvGmJFZWpRblxxeV5qQWH2I0BQb2RGYp
        0eR8YHbJK4k3NLE0MDEzMzQ3MjUwVxLntRTNThQSSE8sSc1OTS1ILYLpY+LglGpgsuUSVd+W
        udjn5RnpRz9SLy5p07tU6Hr0gk77vgrOsOpnF38xFbydpz/xzEThzACpjDebS9IynVO+dSQ7
        1KmfPV9b9pOb1eVnDWvg5eVhfOcPbJ6do9SR1jpju9n3nXvrYh6fleH/veyTTFJhyLrtJp0B
        Pw8IMPaYxBxlfSD/RXXVrU2FsdnXVVYHC848E5jtZG635uZO3/hX8XL9gWHRil3rH7n5RThJ
        GbrvZGT2/2sfzh8yZ+8s8ah/5rLH+ML+t09hqlL8srcsmKFxta9NjsOD6lMWBQoL980P2xIV
        WbHB71t7F+9Du0jd6Fp5hV/fPReU7Pwnv6kpSE7Y2OmH5/avC/h/6SR/fWL80laJpTgj0VCL
        uag4EQDfK+bxdgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsWy7bCSvG5gTm6iwYz7JhYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLS7v17bo2elscXrCIiaLJ+tnMVssurGNyeLGrzZWi41v
        fzBZ3NxylMVixvl9TBbd13ewWSw//o/J4vfPQ0wOQh6Xr3h7zGroZfO43NfL5LF5hZbH4j0v
        mTw2repk85iw6ACjx/f1HWweH5/eYvHo27KK0ePzJjmP9gPdTAE8UVw2Kak5mWWpRfp2CVwZ
        LRfECt7zVdx4/Ju5gfEkTxcjJ4eEgInExiWXGbsYuTiEBHYwSrTu+MAMkZCVePZuBzuELSxx
        v+UIK0TRe0aJrZ82giXYBHQltjx/xQhiiwh8ZJSY800LpIhZ4COzxJ2VS1i6GDk4hAXCJFqn
        M4HUsAioSrxvXAxm8wo4SFz//pcRYoG8xJFfnWCLOYHiPYuOgNUICdhLLH45mxmiXlDi5Mwn
        LCA2M1B989bZzBMYBWYhSc1CklrAyLSKUTK1oDg3PbfYsMAoL7Vcrzgxt7g0L10vOT93EyM4
        ArW0djDuWfVB7xAjEwfjIUYJDmYlEd4k19xEId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwXuk7G
        CwmkJ5akZqemFqQWwWSZODilGpicfE5v+PJLO3fVfcm4OycOfPid/Zf/Su5mns5gRSZDuSMF
        +Uc4in7IRrz6FOXOsenBpjN/RK4e+N1Rd64gwsBz0ikBsWSdr1Pvy/4ynJx9ZeeXsy7zjj5d
        JpNVuigjwXtlAWOWj/cS7X8HBPc9qlCKeMW+JVto9VqVU2YbJymeFp38fl3f7Ak792w+w5K9
        4kz5g2fyfHf3rLVQPaSxOU6sr2rvjeuL+bcuLdxWpsTq0pFxalVkXm2K3tzQ60v4/xScWOTz
        Y7Pq8tD7MYe9ztcWb580dcfvJQynKpTXi27eM9lPLFfL6vyVZ5wljR4TmaX31s09l2GX8qD+
        6/HCa3yem1Sv3Hd+Wym8neWa9zP3V0osxRmJhlrMRcWJAHMRdT8vAwAA
X-CMS-MailID: 20211018124505epcas2p37bd15e319f80e82d321f85565afd7712
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211018124505epcas2p37bd15e319f80e82d321f85565afd7712
References: <20211018124216.153072-1-chanho61.park@samsung.com>
        <CGME20211018124505epcas2p37bd15e319f80e82d321f85565afd7712@epcas2p3.samsung.com>
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
index 6bb4bbb2af21..c9e933655322 100644
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

