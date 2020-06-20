Return-Path: <SRS0=CpYn=AB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29F60C433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Jun 2020 17:51:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04CF7239CF
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Jun 2020 17:51:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="mCErTwcX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728262AbgFTRvJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Jun 2020 13:51:09 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:12291 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728126AbgFTRvI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Jun 2020 13:51:08 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200620175106epoutp030e5b71e39288367c046deee374cbfbca~aUeYWDp9-3105131051epoutp03c
        for <linux-scsi@vger.kernel.org>; Sat, 20 Jun 2020 17:51:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200620175106epoutp030e5b71e39288367c046deee374cbfbca~aUeYWDp9-3105131051epoutp03c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592675466;
        bh=kgQx6GkHG+g2FYavxug1XfQFwsmcK85FkVaRvxsVKak=;
        h=From:To:Cc:Subject:Date:References:From;
        b=mCErTwcXor+EgQBDL6q5bWbxhFnCLx9Dpmkh1GLuCfRAp2MuPtXfdH6sXfIXeocib
         bzlM7Yxv2Uy9Dx86eoTp7xSyqt3cIUNeR+HzZsl6JiE4P4lESP8LHCwaK56Cm56Chm
         IMpNJm0K1eKcPy9QYz+O/nL5YX0QA9Wd6xv+j3do=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200620175105epcas5p2a0f9f291f07c0bb8dc780b10d9f2f363~aUeXA9T8a2357823578epcas5p2L;
        Sat, 20 Jun 2020 17:51:05 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B5.00.09475.98C4EEE5; Sun, 21 Jun 2020 02:51:05 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20200620175104epcas5p25068bb07029c9d6aff56623e4ecb0a26~aUeVyRbn42357823578epcas5p2K;
        Sat, 20 Jun 2020 17:51:04 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200620175104epsmtrp1c6797b3456983879c679dfb1c8b488b9~aUeVxm_Z81505115051epsmtrp1O;
        Sat, 20 Jun 2020 17:51:04 +0000 (GMT)
X-AuditID: b6c32a4b-39fff70000002503-e4-5eee4c8907b5
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        72.0D.08382.78C4EEE5; Sun, 21 Jun 2020 02:51:04 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200620175102epsmtip1e73ed9d8a4a6d1ef5bca3b802c7f6bf3~aUeUes8-P3245232452epsmtip1T;
        Sat, 20 Jun 2020 17:51:02 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     linux-scsi@vger.kernel.org
Cc:     avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-kernel@vger.kernel.org,
        jejb@linux.ibm.com, Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH -next] scsi: ufs: allow exynos ufs driver to build as module
Date:   Sat, 20 Jun 2020 23:02:32 +0530
Message-Id: <20200620173232.52521-1-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsWy7bCmum6nz7s4g/O3JCwezNvGZvHy51U2
        i0/rl7FaLLqxjcni5pajLBaXd81hs+i+voPNYvnxf0wWS7feZHTg9Ljc18vkMWHRAUaPlpP7
        WTw+Pr3F4tG3ZRWjx+dNch7tB7qZAtijuGxSUnMyy1KL9O0SuDKezXjFVLCEv2J++0+mBsaj
        vF2MnBwSAiYS/2duYwGxhQR2M0rcWCTaxcgFZH9ilFi75QUjhPONUeLnnj5mmI7FHR3sEIm9
        jBIfOvexQ7S3MEl8Wc0NYrMJaEvcnb6FCcQWEZCT2Lz8KwtIA7PANUaJc21/wPYJC/hIfNv1
        mRXEZhFQlbi4/D+YzStgI7H22yM2iG3yEqs3HGAGaZYQOMcusaX1GhNEwkViyYQfUEXCEq+O
        b2GHsKUkXva3AdkcQHa2RM8uY4hwjcTSecdYIGx7iQNX5rCAlDALaEqs36UPEmYW4JPo/f2E
        CaKTV6KjTQiiWlWi+d1VqE5piYnd3awQJR4SU2YwQnweK3Fu9T3WCYwysxBmLmBkXMUomVpQ
        nJueWmxaYJyXWq5XnJhbXJqXrpecn7uJEZwCtLx3MD568EHvECMTB+MhRgkOZiUR3sPv38QJ
        8aYkVlalFuXHF5XmpBYfYpTmYFES51X6cSZOSCA9sSQ1OzW1ILUIJsvEwSnVwGSX9XhyopC8
        ufLT47FmuQ9/vvlRXfrkTfQJ/kofh9qYepHU3zGlD0WOP5tyYddV97t3/vyLWXhrgrjSqT1O
        07mTrJ8Yc+7JXKPj8061R99sw7eW16cK1E/rH9TeJ63+OPf4ASP9nZkqrqeX/hXxPtMVlFCU
        IhvcvWBqa8t1Q06L629tQ2u2Z82pFPnkee3LvfU37XY5Fnx4HZNrz+UQcW5y26LPXqfV8g2r
        Znw925m8bpVa109tb525WV6h78+n5YaHPYs+dui9eKncp7lrP6Xsmah9pXDHB1NRkcbF/voT
        2x89N5j7cO21T74tC4Sbw0+Usc6xuLv99u3IxV7RlntfB06/ldez9v6703vtDHqUWIozEg21
        mIuKEwHr95rocAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCLMWRmVeSWpSXmKPExsWy7bCSnG6Hz7s4g9XzmC0ezNvGZvHy51U2
        i0/rl7FaLLqxjcni5pajLBaXd81hs+i+voPNYvnxf0wWS7feZHTg9Ljc18vkMWHRAUaPlpP7
        WTw+Pr3F4tG3ZRWjx+dNch7tB7qZAtijuGxSUnMyy1KL9O0SuDKezXjFVLCEv2J++0+mBsaj
        vF2MnBwSAiYSizs62LsYuTiEBHYzStw895IRIiEtcX3jBHYIW1hi5b/nUEVNTBIdW7YxgSTY
        BLQl7k7fAmaLCMhJbF7+lQWkiFngAaNEz/fjLCAJYQEfiW+7PrOC2CwCqhIXl/8Hs3kFbCTW
        fnvEBrFBXmL1hgPMExh5FjAyrGKUTC0ozk3PLTYsMMxLLdcrTswtLs1L10vOz93ECA44Lc0d
        jNtXfdA7xMjEwXiIUYKDWUmE9/D7N3FCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeW8ULowTEkhP
        LEnNTk0tSC2CyTJxcEo1MIVtvnpqqsZGd8lXG93zDxx4sa/324PnBoY+4Xc/ftA2ehCTYTO7
        c/+ir33f+xKN313TnrJpvZCE5EFN2YcFp8s/qsb6ez2Sjwq/dt64TH7nzN/T/cQOfNphuDm+
        IfTVlQvsbbdsm6quKTwNfOdxb8X7s5smbVxswfTk6+ym8gKPqza8gVHN/infc/omB+5w/XPE
        aGOG9rk5aZwXjTXUxW+su3T8k7Hc1sRO1h61Nr36e/K5TXnTtZqXv0iMrV77vjnA8EjyEZuJ
        am+jIs83B3ox6s3lsS7KyGtsmjG5+r/9MqNYiW6lqet33dM+cN30sUxX9Frm649uLdwQcuGg
        r+u1xx4+fvMP+ihznvp54pkSS3FGoqEWc1FxIgB4kK2XpwIAAA==
X-CMS-MailID: 20200620175104epcas5p25068bb07029c9d6aff56623e4ecb0a26
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200620175104epcas5p25068bb07029c9d6aff56623e4ecb0a26
References: <CGME20200620175104epcas5p25068bb07029c9d6aff56623e4ecb0a26@epcas5p2.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allow Exynos UFS driver to build as a module.
This patch fix the below build issue reported by
kernel build robot.

drivers/scsi/ufs/ufs-exynos.o: in function `exynos_ufs_probe':
drivers/scsi/ufs/ufs-exynos.c:1231: undefined reference to `ufshcd_pltfrm_init'
drivers/scsi/ufs/ufs-exynos.o: in function `exynos_ufs_pre_pwr_mode':
drivers/scsi/ufs/ufs-exynos.c:635: undefined reference to `ufshcd_get_pwr_dev_param'
drivers/scsi/ufs/ufs-exynos.o:undefined reference to `ufshcd_pltfrm_shutdown'
drivers/scsi/ufs/ufs-exynos.o:undefined reference to `ufshcd_pltfrm_suspend'
drivers/scsi/ufs/ufs-exynos.o:undefined reference to `ufshcd_pltfrm_resume'
drivers/scsi/ufs/ufs-exynos.o:undefined reference to `ufshcd_pltfrm_runtime_suspend'
drivers/scsi/ufs/ufs-exynos.o:undefined reference to `ufshcd_pltfrm_runtime_resume'
drivers/scsi/ufs/ufs-exynos.o:undefined reference to `ufshcd_pltfrm_runtime_idle'

Fixes: 55f4b1f73631 ("scsi: ufs: ufs-exynos: Add UFS host support for Exynos SoCs")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 8cd90262784d..3188a50dfb51 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -162,7 +162,7 @@ config SCSI_UFS_BSG
 	  If unsure, say N.
 
 config SCSI_UFS_EXYNOS
-	bool "EXYNOS specific hooks to UFS controller platform driver"
+	tristate "EXYNOS specific hooks to UFS controller platform driver"
 	depends on SCSI_UFSHCD_PLATFORM && (ARCH_EXYNOS || COMPILE_TEST)
 	select PHY_SAMSUNG_UFS
 	help

base-commit: ce2cc8efd7a40cbd17841add878cb691d0ce0bba
prerequisite-patch-id: c12207f678b32e29496ec7e324425c8f49422a2c
prerequisite-patch-id: 8263330366e8c180c0ab9f76fbd4dbbcf0bee427
prerequisite-patch-id: 7456972c04fc1a76c922196aecd98e9ed17cc6eb
-- 
2.17.1

