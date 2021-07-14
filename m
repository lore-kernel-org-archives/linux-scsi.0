Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F9EDC11F67
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 07:12:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27DE86138C
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 07:12:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238259AbhGNHPH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 03:15:07 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:21280 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238229AbhGNHO7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 03:14:59 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210714071203epoutp03d7fd2d39d52b67b94393a70750c308a9~RlsdJJfzf1985919859epoutp03e
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2021 07:12:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210714071203epoutp03d7fd2d39d52b67b94393a70750c308a9~RlsdJJfzf1985919859epoutp03e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1626246723;
        bh=VaR7GsTXdfN/ttujUGssJkAQBO+Bmj7HAq8hMUH+6Fg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GGWgTWsmF/VvVmMnVJbSfnrRafDqSZEzVIyOlY17K6s22vpMQkrI9DMfZovwXUDTm
         HrDjag+3NU9x3FPryhBD4XjRom6sWGVfebL806UhRh28kDGNnQbmtGNk+fLXG67+qv
         wtJ34ND1itr1U0/g46NaLbOOe7cHUPhCTVhEIwS0=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210714071202epcas2p42e31624eb436f28f5a604e79808c0d5c~Rlscby6QQ2506225062epcas2p4z;
        Wed, 14 Jul 2021 07:12:02 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.187]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4GPpbP0xlcz4x9Q1; Wed, 14 Jul
        2021 07:12:01 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        63.4D.09571.04E8EE06; Wed, 14 Jul 2021 16:12:00 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210714071159epcas2p428292c7d0e97533de65d92a029eece93~RlsaHVfYQ2508225082epcas2p4i;
        Wed, 14 Jul 2021 07:11:59 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210714071159epsmtrp25bde34baab64b94dffc9d23e5f727942~RlsaGVSR20755107551epsmtrp2s;
        Wed, 14 Jul 2021 07:11:59 +0000 (GMT)
X-AuditID: b6c32a48-789f2a8000002563-10-60ee8e409f90
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        08.43.08394.F3E8EE06; Wed, 14 Jul 2021 16:11:59 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210714071159epsmtip21ff86311a69368dfbdc1fe0bf69ce1e6~RlsZ6I8_72386323863epsmtip2G;
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
Subject: [PATCH v2 12/15] scsi: ufs: ufs-exynos: add pre/post_hce_enable drv
 callbacks
Date:   Wed, 14 Jul 2021 16:11:28 +0900
Message-Id: <20210714071131.101204-13-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210714071131.101204-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPJsWRmVeSWpSXmKPExsWy7bCmha5D37sEg/MLFS1OPlnDZvFg3jY2
        i5c/r7JZTPvwk9ni0/plrBaX92tb9Ox0tjg9YRGTxZP1s5gtFt3YxmSx8pqFxfnzG9gtbm45
        ymIx4/w+Jovu6zvYLJYf/8fkIOBx+Yq3x+W+XiaPzSu0PBbvecnksWlVJ5vHhEUHGD0+Pr3F
        4tG3ZRWjx+dNch7tB7qZAriicmwyUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTy
        EnNTbZVcfAJ03TJzgP5QUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BQYGhboFSfm
        Fpfmpesl5+daGRoYGJkCVSbkZOy93c9YsIq34vnspewNjDO4uxg5OCQETCTezE/qYuTiEBLY
        wSjRdn47E4TziVHi89vlzBDON0aJ5mfTgBxOsI7zE/9DVe1llLgw+Q0LhPORUWL7wYNgVWwC
        uhJbnr9iBEmIgAxetfguWBWzwElmidMLDrKDVAkLREgsuPKUDcRmEVCVWPRuASuIzSvgILFx
        6yNWiH3yEqeWHWQCsTmB4gc3fGCEqBGUODnzCQuIzQxU07x1NtR9Fzgk3j3XhrBdJA5sP8kO
        YQtLvDq+BcqWkvj8bi8byEESAt2MEq2P/kMlVjNKdDb6QNj2Er+mb2EFBROzgKbE+l36kBBT
        ljhyC2otn0TH4b/sEGFeiY42IYhGdaCt01kgbFmJ7jmfoT7xkDjV8Z4VEliTGSVmnm5gmsCo
        MAvJN7OQfDMLYfECRuZVjGKpBcW56anFRgUmyFG8iRGcsrU8djDOfvtB7xAjEwfjIUYJDmYl
        Ed6lRm8ThHhTEiurUovy44tKc1KLDzGaAsN6IrOUaHI+MGvklcQbmhqZmRlYmlqYmhlZKInz
        crAfShASSE8sSc1OTS1ILYLpY+LglGpgOqdmFBC/oNB4xoYGqSMpG7/+yyzb9zzxb4VEzmlR
        1Z/P7rr2ex2KPXSn/G/rgbl37O7JMEU8eqBy+OBLGcNW/S1hISLR/VuK1mebZAodcjzzOnc5
        l8239KOdP+z+/ysMfRfkP+v/Mv84ubkG7gY3Gx0+zp5vG5i00bs/5c6SDyJ5Dxcwl1Ub98az
        9pz/Y/y4bP6UWQuYnhT3fn4/fVeCWvrXY/fNp1/xeDfxSYOCtFdT0ob7a2vuJ9TJr1nI+PmN
        DMfiIs+Ix/eidmzQUHz34uH6W5obOQLd2S+udL8UwWGxUF83bsWDxQwTA6xnLr1ZkZA95+WC
        T9ysjss4K63kus6pTJ++4xDzhrlbLd61v1FiKc5INNRiLipOBABdVlowYgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42LZdlhJXte+712CwaOn+hYnn6xhs3gwbxub
        xcufV9kspn34yWzxaf0yVovL+7UtenY6W5yesIjJ4sn6WcwWi25sY7JYec3C4vz5DewWN7cc
        ZbGYcX4fk0X39R1sFsuP/2NyEPC4fMXb43JfL5PH5hVaHov3vGTy2LSqk81jwqIDjB4fn95i
        8ejbsorR4/MmOY/2A91MAVxRXDYpqTmZZalF+nYJXBl7b/czFqzirXg+eyl7A+MM7i5GTg4J
        AROJ8xP/M3UxcnEICexmlNi/4g8jREJW4tm7HewQtrDE/ZYjrBBF7xklZrw/wQSSYBPQldjy
        /BUjSEJEYBejxOEzh9lBHGaBy8wS36ZdYQapEhYIkzi8uRPMZhFQlVj0bgEriM0r4CCxcesj
        VogV8hKnlh0Em8oJFD+44QPYGUIC9hL/tq1mg6gXlDg58wkLiM0MVN+8dTbzBEaBWUhSs5Ck
        FjAyrWKUTC0ozk3PLTYsMMxLLdcrTswtLs1L10vOz93ECI4uLc0djNtXfdA7xMjEwXiIUYKD
        WUmEd6nR2wQh3pTEyqrUovz4otKc1OJDjNIcLErivBe6TsYLCaQnlqRmp6YWpBbBZJk4OKUa
        mI5wrQ9e3up8lzO2vCT10wa9n/Es14J/nk7I33Ajc2v9I3mfiVl132RCTr3/4nqnK2nLxH1z
        Lt40alg7N8nkfWTU3i+C6x0TN27jZeVhjT8robPlTE6scSZbMsurPh7G368/78yRnvyrUXNX
        XYGTT2n5p96/HOe3h/berOWtvfrCtztog5jSOaZ/C/c/Pnjf0/3W5q+XZL4k7hIxUbnJmHnu
        ucplp4YD19Re5whHni6VCFiT5ZxUueadVszS3YGcNSwbt839rTvx9GKZjDKLP1+kZ/w76/Y5
        9Igq95Vp/9JkL11hXPH5DIuV58TnEUr70i9me1deZ5Lokp//57rgHIl7QVPaTUvvllQYxBsx
        xCixFGckGmoxFxUnAgDRqKARHQMAAA==
X-CMS-MailID: 20210714071159epcas2p428292c7d0e97533de65d92a029eece93
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210714071159epcas2p428292c7d0e97533de65d92a029eece93
References: <20210714071131.101204-1-chanho61.park@samsung.com>
        <CGME20210714071159epcas2p428292c7d0e97533de65d92a029eece93@epcas2p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds driver-specific pre/post_hce_enable callbacks to execute
extra initializations before and after hce_enable_notify callback.

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 10 ++++++++++
 drivers/scsi/ufs/ufs-exynos.h |  2 ++
 2 files changed, 12 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 81b8b8d9915a..9669afe8f1f4 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -1141,6 +1141,12 @@ static int exynos_ufs_hce_enable_notify(struct ufs_hba *hba,
 
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
@@ -1150,6 +1156,10 @@ static int exynos_ufs_hce_enable_notify(struct ufs_hba *hba,
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
index 8695270d38d9..9c44ca81020b 100644
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
2.32.0

