Return-Path: <SRS0=7BVi=6B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C43C4C3815B
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Apr 2020 18:10:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6A4222240
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Apr 2020 18:10:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Sk6QXVIr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730539AbgDQSKv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Apr 2020 14:10:51 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:62539 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730515AbgDQSKV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2020 14:10:21 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200417181018epoutp01a26f4c304a1812e6aee64873c73d5b9a~Grc3yQOMe3222132221epoutp01V
        for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2020 18:10:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200417181018epoutp01a26f4c304a1812e6aee64873c73d5b9a~Grc3yQOMe3222132221epoutp01V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1587147018;
        bh=ZPz4c7rs/J4yvDkVsqsO6MPyp8jBkGC5MbwUBNlrl90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sk6QXVIrIived9p0rOteg/kN7cgbJm+28nlEdvrthDZEuyusIoDAmOiTyWgtli8P+
         p7qqwhc8AiNIKWjUt+wXiHctA2McemuLaQacxm1mHXuk1LD9Xe6+TBAm5f5vgVEQ3A
         9qk3d9V1shUdkgNMWZQVYCg6K4SAfLqsm+jB8Qxg=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20200417181017epcas5p431965f3c43030dbd4f1e4da2089a72ad~Grc2jonzf0789107891epcas5p44;
        Fri, 17 Apr 2020 18:10:17 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D0.26.04778.901F99E5; Sat, 18 Apr 2020 03:10:17 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20200417181016epcas5p2ee7ac86d743ceee9076690dc5b1e2f08~Grc1k8_Li2908329083epcas5p28;
        Fri, 17 Apr 2020 18:10:16 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200417181016epsmtrp21f2b776f5522f2fa635b1a24193b6d96~Grc1kIOB11925319253epsmtrp2C;
        Fri, 17 Apr 2020 18:10:16 +0000 (GMT)
X-AuditID: b6c32a4a-33bff700000012aa-21-5e99f109ea0e
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        EF.D0.04024.801F99E5; Sat, 18 Apr 2020 03:10:16 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200417181014epsmtip17135e62ed861b5744dded85dd6b07524~GrczthsVI2097520975epsmtip1F;
        Fri, 17 Apr 2020 18:10:14 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v6 05/10] scsi: ufs: add quirk to fix abnormal ocs fatal
 error
Date:   Fri, 17 Apr 2020 23:29:39 +0530
Message-Id: <20200417175944.47189-6-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200417175944.47189-1-alim.akhtar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42LZdlhTU5fz48w4g58vxCwezNvGZvHy51U2
        i0/rl7FazD9yjtXi/PkN7BY3txxlsdj0+BqrxeVdc9gsZpzfx2TRfX0Hm8Xy4/+YLP7v2cFu
        sXTrTUYHXo/Lfb1MHptWdbJ5bF5S79Fycj+Lx8ent1g8+rasYvT4vEnOo/1AN1MARxSXTUpq
        TmZZapG+XQJXxtwJHxkL7vFUtDy6z97AeIiri5GTQ0LARGLDnj/sXYxcHEICuxkldtz/yQbh
        fGKUeN94CMr5xijxau8rVpiW9vXzmSESexklXt9uAnI4gJwWJokjTCA1bALaEnenbwGzRQSE
        JY58a2MEsZkFbjBJPFjpAmILCwRInPr6EGwmi4CqxNLJy8DqeQVsJHa3f2aC2CUvsXrDAWYQ
        m1PAVqKtZSkTyF4JgftsErt3nGGEKHKRuPRtPTOELSzx6vgWdghbSuLzu71sILdJCGRL9Owy
        hgjXSCydd4wFwraXOHBlDgtICbOApsT6XfoQZ/JJ9P5+wgTRySvR0SYEUa0q0fzuKlSntMTE
        7m5oiHhIzD86CxqIExglzm9ewjSBUXYWwtQFjIyrGCVTC4pz01OLTQuM8lLL9YoTc4tL89L1
        kvNzNzGCk4mW1w7GZed8DjEKcDAq8fB29M2ME2JNLCuuzD3EKMHBrCTCe9ANKMSbklhZlVqU
        H19UmpNafIhRmoNFSZx3EuvVGCGB9MSS1OzU1ILUIpgsEwenVAPjtkhTzwDmy6kX5N/POxKy
        bYtYgd/rZY6+cyKWRt81/5lhmG1Wd7984ZzbudfNN8asyJ5hy8T2OrHULEnu9N7aBmuPBL+j
        ljdE1W/lTH/gy+UqvOjXJOu363cbhMwKtmGo2bzgi1abv1vibf19U66ETeqbypFUaZrBrnQ/
        n0NmU1DySyc2NXMlluKMREMt5qLiRABGx36hIgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsWy7bCSnC7Hx5lxBs+X81o8mLeNzeLlz6ts
        Fp/WL2O1mH/kHKvF+fMb2C1ubjnKYrHp8TVWi8u75rBZzDi/j8mi+/oONovlx/8xWfzfs4Pd
        YunWm4wOvB6X+3qZPDat6mTz2Lyk3qPl5H4Wj49Pb7F49G1ZxejxeZOcR/uBbqYAjigum5TU
        nMyy1CJ9uwSujLkTPjIW3OOpaHl0n72B8RBXFyMnh4SAiUT7+vnMXYxcHEICuxklpiw4wwSR
        kJa4vnECO4QtLLHy33N2iKImJolVr6azgiTYBLQl7k7fAtYgAlR05FsbI4jNLPCMSeLUw1IQ
        W1jAT2LyqU6wGhYBVYmlk5eB2bwCNhK72z9DLZOXWL3hADOIzSlgK9HWshQozgG0zEZiw5OY
        CYx8CxgZVjFKphYU56bnFhsWGOallusVJ+YWl+al6yXn525iBAezluYOxstL4g8xCnAwKvHw
        GvTMjBNiTSwrrsw9xCjBwawkwnvQDSjEm5JYWZValB9fVJqTWnyIUZqDRUmc92nesUghgfTE
        ktTs1NSC1CKYLBMHp1QDY2eHQNb1szsF18Rar2laoin3SLRCtk70Y+yuxqe7T/+asltNwurN
        5PV8F/hrFh9OL306R8T5tVTfL9YfbgaTTGVnd05unXG4UyelRZf5gc4VPwnxTb1P6ryqfG91
        n978YtGpbs+1F/+mGs1OuFX/7VzgITsvg7jMs1+Pf0jw/2G1Yum/dR+2SymxFGckGmoxFxUn
        AgCk5ziyYgIAAA==
X-CMS-MailID: 20200417181016epcas5p2ee7ac86d743ceee9076690dc5b1e2f08
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200417181016epcas5p2ee7ac86d743ceee9076690dc5b1e2f08
References: <20200417175944.47189-1-alim.akhtar@samsung.com>
        <CGME20200417181016epcas5p2ee7ac86d743ceee9076690dc5b1e2f08@epcas5p2.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kiwoong Kim <kwmad.kim@samsung.com>

Some architectures determines if fatal error for OCS
occurrs to check status in response upiu. This patch
is to prevent from reporting command results with that.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 6 ++++++
 drivers/scsi/ufs/ufshcd.h | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b32fcedcdcb9..8c07caff0a5c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4794,6 +4794,12 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	/* overall command status of utrd */
 	ocs = ufshcd_get_tr_ocs(lrbp);
 
+	if (hba->quirks & UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR) {
+		if (be32_to_cpu(lrbp->ucd_rsp_ptr->header.dword_1) &
+					MASK_RSP_UPIU_RESULT)
+			ocs = OCS_SUCCESS;
+	}
+
 	switch (ocs) {
 	case OCS_SUCCESS:
 		result = ufshcd_get_req_rsp(lrbp->ucd_rsp_ptr);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index a9b9ace9fc72..e1d09c2c4302 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -541,6 +541,12 @@ enum ufshcd_quirks {
 	 * resolution of the values of PRDTO and PRDTL in UTRD as byte.
 	 */
 	UFSHCD_QUIRK_PRDT_BYTE_GRAN			= 1 << 9,
+
+	/*
+	 * This quirk needs to be enabled if the host controller reports
+	 * OCS FATAL ERROR with device error through sense data
+	 */
+	UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR		= 1 << 10,
 };
 
 enum ufshcd_caps {
-- 
2.17.1

