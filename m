Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46F56C11F66
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 06:57:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EF0A613C0
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 06:57:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbhGIHAf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 03:00:35 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:50421 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbhGIHAe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 03:00:34 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210709065750epoutp03df4c122d16201fce1b3cbdb0435a88b7~QDRnazzqx2645626456epoutp03I
        for <linux-scsi@vger.kernel.org>; Fri,  9 Jul 2021 06:57:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210709065750epoutp03df4c122d16201fce1b3cbdb0435a88b7~QDRnazzqx2645626456epoutp03I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1625813870;
        bh=nMElEhDOh+0gZSWQnKtzixOmaoeS4v1nCMxL6Kc/MxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fu/yjZ1JIi3sHb21sayUy7BqdMIIn5TuYGVJG6EHBqJBw0MTOZHltUK+rHomUSXPx
         lWCXPuNnfpS3rHaHmQb2Zex3kSbg2nUCC9vMK8nKUjyonCcUxAPhgdX4FYKEc2bTb/
         aMZ7BqcS1/4B5d4wl9E14/6FMCNGFboGVlxzkpc8=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210709065749epcas2p33490f24b7bc62de207e28a9a1152711c~QDRmoHdNt2002320023epcas2p3B;
        Fri,  9 Jul 2021 06:57:49 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.186]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4GLkWH5YFvz4x9Q9; Fri,  9 Jul
        2021 06:57:47 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        5B.D4.09541.B63F7E06; Fri,  9 Jul 2021 15:57:47 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210709065746epcas2p20094c97a7abfd7704c30ca6bac04f924~QDRkPKd6s1400414004epcas2p2N;
        Fri,  9 Jul 2021 06:57:46 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210709065746epsmtrp21a5fa14ca82f8f7625f95a7760a40361~QDRkOVE0s0268602686epsmtrp25;
        Fri,  9 Jul 2021 06:57:46 +0000 (GMT)
X-AuditID: b6c32a46-095ff70000002545-66-60e7f36bbe26
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E5.63.08394.A63F7E06; Fri,  9 Jul 2021 15:57:46 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210709065746epsmtip25eb1800bce91303ec7f0b7b230ca0479~QDRj-tCnn3134631346epsmtip2x;
        Fri,  9 Jul 2021 06:57:46 +0000 (GMT)
From:   Chanho Park <chanho61.park@samsung.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
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
Subject: [PATCH 07/15] scsi: ufs: ufs-exynos: add setup_clocks callback
Date:   Fri,  9 Jul 2021 15:57:03 +0900
Message-Id: <20210709065711.25195-8-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709065711.25195-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDJsWRmVeSWpSXmKPExsWy7bCmhW725+cJBt2LhCxOPlnDZvFg3jY2
        i5c/r7JZTPvwk9ni0/plrBaX92tb9Ox0tjg9YRGTxZP1s5gtFt3YxmSx8pqFxc0tR1ksZpzf
        x2TRfX0Hm8Xy4/+YHPg9Ll/x9rjc18vksXmFlsfiPS+ZPDat6mTzmLDoAKPHx6e3WDz6tqxi
        9Pi8Sc6j/UA3UwBXVI5NRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2S
        i0+ArltmDtALSgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpdSClJwCQ8MCveLE3OLSvHS9
        5PxcK0MDAyNToMqEnIyHHxYyF0wQqNh0bDVrA+M53i5GTg4JAROJH+c7mLsYuTiEBHYwSry6
        do4JwvnEKDH970eozDdGiYXtsxhhWm5uPwRVtZdR4tuBg6wQzkdGiRWfL7OBVLEJ6Epsef6K
        ESQhItDPKLF8/1wWEIdZ4CSzxOkFB9lBqoQF3CWW9L8Bs1kEVCW69j8B6+YVsJM4/raDHWKf
        vMSpZQeZQGxOAXuJeT8mMEHUCEqcnPmEBcRmBqpp3job7FgJgSMcEv/PPmSGaHaRWNryjAnC
        FpZ4dXwL1FApic/v9rJBNHQzSrQ++g+VWM0o0dnoA2HbS/yavgXoOQ6gDZoS63fpg5gSAsoS
        R25B7eWT6Dj8lx0izCvR0SYE0agucWD7dBYIW1aie85nVgjbQ+Lq/ufQMJ3EKHFr633mCYwK
        s5C8MwvJO7MQFi9gZF7FKJZaUJybnlpsVGCEHMmbGMHJWsttB+OUtx/0DjEycTAeYpTgYFYS
        4TWa8SxBiDclsbIqtSg/vqg0J7X4EKMpMLAnMkuJJucD80VeSbyhqZGZmYGlqYWpmZGFkjgv
        B/uhBCGB9MSS1OzU1ILUIpg+Jg5OqQamy3MNJx4NyFbeFFj775581v/fuY0hn7+ciY1+kcjI
        9HGPTv+XicfsCxij15TOabNRU8+tltUSOavJ3nuS3/jr8XCNrU5vl5u9e7X7+q+l9oZ68Szn
        X9vVFbt4fnFcMnPX+zlzCwXvbcg1rH/+f+dPa+Hopc8Dgk67nLiQeK9ae4pM98miJi+LK1Oq
        HAR7wuI3W+7fye5q1DTzZa7VSZXZT7e+2Ouzr4/r4etnm+Y8nPTq2KaUlpCMvzV7CwPkbHQK
        bf5JbLYP7vaVuNz39K/f5v3/v8zKDv/Gbryre7flpqNpPi0eekuzg7ZFe7rfWxL8LchH143h
        mokK/7ZPrj9E5G+dUavsXpVSy6DmXztFiaU4I9FQi7moOBEAPIKvhV8EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42LZdlhJXjfr8/MEgxP/VS1OPlnDZvFg3jY2
        i5c/r7JZTPvwk9ni0/plrBaX92tb9Ox0tjg9YRGTxZP1s5gtFt3YxmSx8pqFxc0tR1ksZpzf
        x2TRfX0Hm8Xy4/+YHPg9Ll/x9rjc18vksXmFlsfiPS+ZPDat6mTzmLDoAKPHx6e3WDz6tqxi
        9Pi8Sc6j/UA3UwBXFJdNSmpOZllqkb5dAlfGww8LmQsmCFRsOraatYHxHG8XIyeHhICJxM3t
        h5hAbCGB3YwSH045QMRlJZ6928EOYQtL3G85wtrFyAVU855R4vmZ6SwgCTYBXYktz18xgtgi
        AhMZJZbcEwMpYha4zCzxbdoVZpCEsIC7xJL+N2CTWARUJbr2P2EDsXkF7CSOv+2A2iAvcWrZ
        QbArOAXsJeb9mAB1kZ3EvQ372CHqBSVOznwCtpgZqL5562zmCYwCs5CkZiFJLWBkWsUomVpQ
        nJueW2xYYJiXWq5XnJhbXJqXrpecn7uJERxPWpo7GLev+qB3iJGJg/EQowQHs5IIr9GMZwlC
        vCmJlVWpRfnxRaU5qcWHGKU5WJTEeS90nYwXEkhPLEnNTk0tSC2CyTJxcEo1MM3Nkb4z/WfE
        70+TFwZ9DDLcPkPPIe+5qeQqxhlc/CXiNWXnd6cFmVcw79WoZpl3OWHj5k1Fp2TC3D56Sb8/
        8/PKpP5uj872sAvX7C7u+5F6ra7P+cYt90Mugv8i2qYcKKuvvjdLZCmno9grgS62jtP7mtfO
        ZemcvMcwXPGO6qu4Fw3r9P/NfqlUt6vn76yNJ9L59vrw9u9ji55y3JWZO+O5ZXUTz/5TJbU5
        f11jplf9i6o4lRNxiPvq8eoVDlaXjeL//H+w9vov4TW3LgQW3vPyO/vy1YTbn3KCV3UsP8LG
        0T233qq5/KxKgmn+0oPLLmROs9pQMjPgwOV33GkbLz7cdfND54HU75dPLF574naYEktxRqKh
        FnNRcSIA5hbJkxYDAAA=
X-CMS-MailID: 20210709065746epcas2p20094c97a7abfd7704c30ca6bac04f924
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210709065746epcas2p20094c97a7abfd7704c30ca6bac04f924
References: <20210709065711.25195-1-chanho61.park@samsung.com>
        <CGME20210709065746epcas2p20094c97a7abfd7704c30ca6bac04f924@epcas2p2.samsung.com>
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

