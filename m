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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40BA6C11F72
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 07:12:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C0F5613AA
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 07:12:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238251AbhGNHPF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 03:15:05 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:31112 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238240AbhGNHO6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 03:14:58 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210714071201epoutp04d7989f9320964aa80ed7ca19c59e9a18~RlscE-ucw0822208222epoutp04F
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2021 07:12:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210714071201epoutp04d7989f9320964aa80ed7ca19c59e9a18~RlscE-ucw0822208222epoutp04F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1626246722;
        bh=nMElEhDOh+0gZSWQnKtzixOmaoeS4v1nCMxL6Kc/MxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ly2YSvKBFErC+am3j/bBAmpRh2JP3IfD6yr7CnVelvb0M+XlS7fD8LWqSPk4uCCzB
         z9zD4V4rw55wj96yX2f8PVNf6i5RxkkqpwNaeE1wJopbbGeyqaoeEXOp/T6SJ5HD9J
         zbF9A2nzsRn/9bFc1L1h/BBtsMuCu48DjFMcv9gs=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210714071201epcas2p4371ef76c00a3c60871a13e33c945c8e2~RlsbTZVRh2506225062epcas2p4q;
        Wed, 14 Jul 2021 07:12:01 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.183]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4GPpbM6dFqz4x9QJ; Wed, 14 Jul
        2021 07:11:59 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        B9.3D.09571.F3E8EE06; Wed, 14 Jul 2021 16:11:59 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210714071159epcas2p4c4eabf50abdaa46567fc5356bce8942b~RlsZsV7E52506525065epcas2p4l;
        Wed, 14 Jul 2021 07:11:59 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210714071159epsmtrp1d193383e8c25893c979722203999b387~RlsZrR60q1252112521epsmtrp1I;
        Wed, 14 Jul 2021 07:11:59 +0000 (GMT)
X-AuditID: b6c32a48-1f5ff70000002563-07-60ee8e3f6b97
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        75.17.08289.F3E8EE06; Wed, 14 Jul 2021 16:11:59 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210714071159epsmtip2f1cf003de2a8bcbd415ae7b8d68b04e4~RlsZdI1oB1845718457epsmtip2x;
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
Subject: [PATCH v2 07/15] scsi: ufs: ufs-exynos: add setup_clocks callback
Date:   Wed, 14 Jul 2021 16:11:23 +0900
Message-Id: <20210714071131.101204-8-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210714071131.101204-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIJsWRmVeSWpSXmKPExsWy7bCmma5937sEgx+dJhYnn6xhs3gwbxub
        xcufV9kspn34yWzxaf0yVovL+7UtenY6W5yesIjJ4sn6WcwWi25sY7JYec3C4vz5DewWN7cc
        ZbGYcX4fk0X39R1sFsuP/2NyEPC4fMXb43JfL5PH5hVaHov3vGTy2LSqk81jwqIDjB4fn95i
        8ejbsorR4/MmOY/2A91MAVxROTYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5
        ibmptkouPgG6bpk5QH8oKZQl5pQChQISi4uV9O1sivJLS1IVMvKLS2yVUgtScgoMDQv0ihNz
        i0vz0vWS83OtDA0MjEyBKhNyMh5+WMhcMEGgYtOx1awNjOd4uxg5OSQETCTur1rK3sXIxSEk
        sINRom3zFGYI5xOjxMIVHVCZz4wSB/pOscK0HGvZzgSR2MUoMXnTLRYI5yOjxJ2vN1hAqtgE
        dCW2PH/FCJIQARm8avFdsCpmgZPMEqcXHGQHqRIW8JK49Hw7G4jNIqAqcez5BLAdvAL2Evt/
        7IXaJy9xatlBJhCbU8BB4uCGD4wQNYISJ2c+AdvGDFTTvHU22OUSAhc4JG4+P8AM0ewiceL7
        ZihbWOLV8S3sELaUxMv+NnaIhm5GidZH/6ESqxklOht9IGx7iV/TtwBdwQG0QVNi/S59EFNC
        QFniyC2ovXwSHYf/skOEeSU62oQgGtUlDmyfzgJhy0p0z/kM9YqHxLw1F1khoTWZUeLtivus
        ExgVZiF5ZxaSd2YhLF7AyLyKUSy1oDg3PbXYqMAEOZI3MYLTtpbHDsbZbz/oHWJk4mA8xCjB
        wawkwrvU6G2CEG9KYmVValF+fFFpTmrxIUZTYGBPZJYSTc4HZo68knhDUyMzMwNLUwtTMyML
        JXFeDvZDCUIC6YklqdmpqQWpRTB9TBycUg1M8clxHTzCDonxfJW9bqpL5ql+qPw2y/akPKtO
        tcH/l1Yre/VUzxypXfpjqod2r+6No5vuHLFsZ57XtphrRUzm3blXp4Qkdopviq5yu/isLm+i
        smEUu5UCm6bhlgtbDK/rOPb2MNeViVxRmFe94NZ2IX3eW3N3CWf2VP40ZoiftLitdvapxpC4
        L1P/34gT/ZXvll8qzxO48eOTGRsKntX7Kp1T/K4rN6tXpahbcEPl9wkPKjdKbpa5/cU7w37y
        vPwlZcl5KyrchK6//WOeZhtRUPYlQfn4g935wW7reX47fp70c/Gdz+Fd++6cWLp4rveX8Dxl
        o1tmFfNYDm78EdFir7h96fOtvaa1wVeFp+5SYinOSDTUYi4qTgQAkxJovGQEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42LZdlhJXte+712CwZL5whYnn6xhs3gwbxub
        xcufV9kspn34yWzxaf0yVovL+7UtenY6W5yesIjJ4sn6WcwWi25sY7JYec3C4vz5DewWN7cc
        ZbGYcX4fk0X39R1sFsuP/2NyEPC4fMXb43JfL5PH5hVaHov3vGTy2LSqk81jwqIDjB4fn95i
        8ejbsorR4/MmOY/2A91MAVxRXDYpqTmZZalF+nYJXBkPPyxkLpggULHp2GrWBsZzvF2MnBwS
        AiYSx1q2M3UxcnEICexglHi16AorREJW4tm7HewQtrDE/ZYjrBBF7xklPu5cxAySYBPQldjy
        /BUjSEJEYBejxOEzh9lBHGaBy8wS36ZdAasSFvCSuPR8OxuIzSKgKnHs+QSwFbwC9hL7f+yF
        WicvcWrZQSYQm1PAQeLghg+MILYQUM2/bavZIOoFJU7OfMICYjMD1Tdvnc08gVFgFpLULCSp
        BYxMqxglUwuKc9Nziw0LjPJSy/WKE3OLS/PS9ZLzczcxgqNLS2sH455VH/QOMTJxMB5ilOBg
        VhLhXWr0NkGINyWxsiq1KD++qDQntfgQozQHi5I474Wuk/FCAumJJanZqakFqUUwWSYOTqkG
        pgnW3vN3Jcfot+aIff+jurJNOV33wa/nJS+kJpbXbpY85h+ruMJ71iypcx339Q/r/7l075s3
        y8pjhwp8tjBsX65iW73mqorfIYMjvi/EdrPlst1uYXjdNtfosU3NuvKPCcv3JyzTyLQM59W/
        uHx7ofL0okQ7+f3nVSsTj6oXvLvXXHBq6U7uBydOnH7/4lQDS19C+/H+xW/mTrvV4bjgP6PH
        Vt65/JlqIdZbbS0mNEy+wDmB6Ykfy/Izt7srC7OaKnVfCsTHd2y7tfbi80f/T6+LvWfycF7n
        p+MS/5edlWC4/2SXJmceu+BO4U8f1zoVCG6sCH9yaMM9E7Hc/suBH8znRM+ZE6Af0LY/5kxc
        XKESS3FGoqEWc1FxIgCgC19JHQMAAA==
X-CMS-MailID: 20210714071159epcas2p4c4eabf50abdaa46567fc5356bce8942b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210714071159epcas2p4c4eabf50abdaa46567fc5356bce8942b
References: <20210714071131.101204-1-chanho61.park@samsung.com>
        <CGME20210714071159epcas2p4c4eabf50abdaa46567fc5356bce8942b@epcas2p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds setup_clocks callback to control/gate clocks by ufshcd.
To avoid calling before initialization, it needs to check whether ufs is
null or not and call it initially from pre_link callback.

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 78cc5bda0a1f..530dab500d11 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -795,6 +795,27 @@ static void exynos_ufs_config_intr(struct exynos_ufs *ufs, u32 errs, u8 index)
 	}
 }
 
+static int exynos_ufs_setup_clocks(struct ufs_hba *hba, bool on,
+				   enum ufs_notify_change_status status)
+{
+	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
+
+	if (!ufs)
+		return 0;
+
+	if (on) {
+		if (ufs->opts & EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL)
+			exynos_ufs_disable_auto_ctrl_hcc(ufs);
+		exynos_ufs_ungate_clks(ufs);
+	} else {
+		exynos_ufs_gate_clks(ufs);
+		if (ufs->opts & EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL)
+			exynos_ufs_enable_auto_ctrl_hcc(ufs);
+	}
+
+	return 0;
+}
+
 static int exynos_ufs_pre_link(struct ufs_hba *hba)
 {
 	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
@@ -813,6 +834,8 @@ static int exynos_ufs_pre_link(struct ufs_hba *hba)
 	exynos_ufs_config_phy_time_attr(ufs);
 	exynos_ufs_config_phy_cap_attr(ufs);
 
+	exynos_ufs_setup_clocks(hba, true, POST_CHANGE);
+
 	if (ufs->drv_data->pre_link)
 		ufs->drv_data->pre_link(ufs);
 
@@ -1203,6 +1226,7 @@ static struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.hce_enable_notify		= exynos_ufs_hce_enable_notify,
 	.link_startup_notify		= exynos_ufs_link_startup_notify,
 	.pwr_change_notify		= exynos_ufs_pwr_change_notify,
+	.setup_clocks			= exynos_ufs_setup_clocks,
 	.setup_xfer_req			= exynos_ufs_specify_nexus_t_xfer_req,
 	.setup_task_mgmt		= exynos_ufs_specify_nexus_t_tm_req,
 	.hibern8_notify			= exynos_ufs_hibern8_notify,
-- 
2.32.0

