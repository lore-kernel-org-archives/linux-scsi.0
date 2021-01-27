Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CAD8C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 04:22:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8CDF2070C
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 04:22:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238430AbhA0EWp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jan 2021 23:22:45 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:54887 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237283AbhA0Dur (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 22:50:47 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210127034959epoutp03cd1d57654757c2854380f696736adedd~d_kFHHIUA1081910819epoutp03C
        for <linux-scsi@vger.kernel.org>; Wed, 27 Jan 2021 03:49:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210127034959epoutp03cd1d57654757c2854380f696736adedd~d_kFHHIUA1081910819epoutp03C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611719399;
        bh=fXkc/J8P35LYNPusVhQ+9QBrxVTdlboL1ax5vgyVZ0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=X2UHjILRKJK3ROGqGuH2tIWaF6urvAjbjQ6lks/JhcPsHtEM9Odp61GbPdZOpjxV1
         OwpAt5p0v3tRUuEj5F7s+ziAdk5BLpx2DWBrbeEs2MvFWL1MLMXB/VqpS5hmGKXtXL
         nOEv3IQKswj5BG1Tb5tyBCaM6rW4IBVbdeqHh7y8=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210127034958epcas2p18c8104a03aa07dcf49e36b78e293c7b2~d_kECe-m60654406544epcas2p1h;
        Wed, 27 Jan 2021 03:49:58 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.184]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4DQV3n58D1z4x9Q5; Wed, 27 Jan
        2021 03:49:57 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        C5.39.56312.5E2E0106; Wed, 27 Jan 2021 12:49:57 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20210127034957epcas2p3d9e58c70424505b05b8c6b9d6f7cf095~d_kChR6572454124541epcas2p3l;
        Wed, 27 Jan 2021 03:49:57 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210127034957epsmtrp288844f7bdfdc0ac5e2756ca5113dbe66~d_kCgXNVn2046420464epsmtrp2M;
        Wed, 27 Jan 2021 03:49:57 +0000 (GMT)
X-AuditID: b6c32a46-1efff7000000dbf8-cb-6010e2e5332e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D6.79.13470.4E2E0106; Wed, 27 Jan 2021 12:49:57 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210127034956epsmtip25487dd458c2c7096be21f885e18d02fb~d_kCTEC-R2612426124epsmtip2O;
        Wed, 27 Jan 2021 03:49:56 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v9 1/2] ufs: introduce a callback to get info of command
 completion
Date:   Wed, 27 Jan 2021 12:38:22 +0900
Message-Id: <893c09bb91db01a105f0325ab5ff2e6c652ebfab.1611718633.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1611718633.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1611718633.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLJsWRmVeSWpSXmKPExsWy7bCmme7TRwIJBkuvKlo8mLeNzWJv2wl2
        i5c/r7JZHHzYyWLxdekzVotpH34yW3xav4zV4tff9ewWqxc/YLFYdGMbk8XNLUdZLLqv72Cz
        WH78H5NF190bjBZL/71lceD3uHzF2+NyXy+Tx4RFBxg9vq/vYPP4+PQWi0ffllWMHp83yXm0
        H+hmCuCIyrHJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvM
        ATpeSaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgaFigV5yYW1yal66XnJ9rZWhg
        YGQKVJmQk7HmzUrmgjcCFccfGTUwNvB1MXJySAiYSPQt3c7excjFISSwg1Hi7dHJzBDOJ0aJ
        j+3bmEGqhAS+MUosviMD03Fkcx8rRNFeRon/l7+wQDg/GCWOP5vHDlLFJqAp8fTmVCaQhIjA
        GSaJa61nWUESzALqErsmnGACsYUFQiU2LN0AFmcRUJXYdnMyI4jNKxAt0TrpLyvEOjmJm+c6
        gc7g4OAUsJR4vtsAhckFVDGTQ6JvwkU2iHIXidtd/5kgbGGJV8e3sEPYUhKf3+2FqqmX2De1
        gRWiuYdR4um+f4wQCWOJWc/aGUEWMAM9sH6XPogpIaAsceQWC8T1fBIdh/+yQ4R5JTrahCAa
        lSV+TZoMNURSYubNO1BbPSQWHpnJCAkeoE3TL+xnnMAoPwthwQJGxlWMYqkFxbnpqcVGBUbI
        cbeJEZxOtdx2ME55+0HvECMTB+MhRgkOZiUR3vfKAglCvCmJlVWpRfnxRaU5qcWHGE2BwTiR
        WUo0OR+Y0PNK4g1NjczMDCxNLUzNjCyUxHmLDR7ECwmkJ5akZqemFqQWwfQxcXBKNTCpsykr
        /Hq85tsH+3qzl1s1lm/OcpnOrTojJas1s5/9+ffsw2psfFJ9h88nZyQck5BLf6urelac5VS5
        8+bwuSyrLjz+AdS6bmHW08OFy1ZdOsx4a/sRg+kK94uLOOffn7MqfdvjkkKjDROKJzW87/MM
        r3j7rMAi+db0XseGCSsn9PAUTWrO+5v/p+y/LgO/pueUWJlCy/jkLV1pxtsmPn1dd3j7qgrN
        4zbPfT9uLz0VIBL5KJPBRsv4+Q85x2XxS7esbD+2+0aLXYJC8R1/zclLphuva8p/d+9hfEvo
        5ElH50+UnrOjX/ORxwOL4qfNbzaFqN7hUFnuHB9ZvvjEzmeL+AV38v+e+NTmWv3tXVxKLMUZ
        iYZazEXFiQCYwLYSMAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsWy7bCSvO7TRwIJBu2nmCwezNvGZrG37QS7
        xcufV9ksDj7sZLH4uvQZq8W0Dz+ZLT6tX8Zq8evvenaL1YsfsFgsurGNyeLmlqMsFt3Xd7BZ
        LD/+j8mi6+4NRoul/96yOPB7XL7i7XG5r5fJY8KiA4we39d3sHl8fHqLxaNvyypGj8+b5Dza
        D3QzBXBEcdmkpOZklqUW6dslcGWsebOSueCNQMXxR0YNjA18XYycHBICJhJHNvexgthCArsZ
        Jbq6FCDikhIndj5nhLCFJe63HIGq+cYo8ewWC4jNJqAp8fTmVKYuRi4OEYF7TBKXJsxlBkkw
        C6hL7JpwggnEFhYIlvg0fyNYA4uAqsS2m5PBhvIKREu0TvrLCrFATuLmuU6gXg4OTgFLiee7
        DSB2WUjcvLKSFYfwBEaBBYwMqxglUwuKc9Nziw0LDPNSy/WKE3OLS/PS9ZLzczcxgmNBS3MH
        4/ZVH/QOMTJxMB5ilOBgVhLhfa8skCDEm5JYWZValB9fVJqTWnyIUZqDRUmc90LXyXghgfTE
        ktTs1NSC1CKYLBMHp1QD045WXuMqkcPNezjnygkWBpV/yAuzMujtfrFw5voj3Vs/iZV3nzp1
        +roh9+MjfxhU9Sca3jV/svzH061Pg9p2Js1/OmkT55P+hXyP3p/5K3fabnbi+nX9ki3Kkz7u
        +tQ7OUCOk1P25/vZM0O1/lxPrDoXtM33UP0bsV1M3Vl9lf//PK7/ZLRJVkr/f+bFKKHueY+L
        TkxNTSv8fEn596HfB4pb+DcV3ruc9lfEIEllkVN2qIz+ecGzL4RfXDr3Q2bqzcmx+xedfrXy
        rm6l/LSqRSH8PPcXGDNcjbx5geto9lT323NWPi7/ytW/6vvdhoyJC+e3VYUc8WE8nsbRsOif
        U9vXuvSfJ7a8ZFG97lR74qOtEktxRqKhFnNRcSIA2Uu+uPQCAAA=
X-CMS-MailID: 20210127034957epcas2p3d9e58c70424505b05b8c6b9d6f7cf095
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210127034957epcas2p3d9e58c70424505b05b8c6b9d6f7cf095
References: <cover.1611718633.git.kwmad.kim@samsung.com>
        <CGME20210127034957epcas2p3d9e58c70424505b05b8c6b9d6f7cf095@epcas2p3.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some SoC specific might need command history for
various reasons, such as stacking command contexts
in system memory to check for debugging in the future
or scaling some DVFS knobs to boost IO throughput.

What you would do with the information could be
variant per SoC vendor.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
Acked-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshcd.c | 1 +
 drivers/scsi/ufs/ufshcd.h | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9c691e4..af0548a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5093,6 +5093,7 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 		lrbp->in_use = false;
 		lrbp->compl_time_stamp = ktime_get();
 		cmd = lrbp->cmd;
+		ufshcd_vops_compl_xfer_req(hba, index, (cmd) ? true : false);
 		if (cmd) {
 			ufshcd_add_command_trace(hba, index, UFS_CMD_COMP);
 			result = ufshcd_transfer_rsp_status(hba, lrbp);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index ee61f82..0178365 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -343,6 +343,7 @@ struct ufs_hba_variant_ops {
 					struct ufs_pa_layer_attr *,
 					struct ufs_pa_layer_attr *);
 	void	(*setup_xfer_req)(struct ufs_hba *, int, bool);
+	void	(*compl_xfer_req)(struct ufs_hba *hba, int tag, bool is_scsi);
 	void	(*setup_task_mgmt)(struct ufs_hba *, int, u8);
 	void    (*hibern8_notify)(struct ufs_hba *, enum uic_cmd_dme,
 					enum ufs_notify_change_status);
@@ -1199,6 +1200,13 @@ static inline void ufshcd_vops_setup_xfer_req(struct ufs_hba *hba, int tag,
 		return hba->vops->setup_xfer_req(hba, tag, is_scsi_cmd);
 }
 
+static inline void ufshcd_vops_compl_xfer_req(struct ufs_hba *hba,
+					      int tag, bool is_scsi)
+{
+	if (hba->vops && hba->vops->compl_xfer_req)
+		hba->vops->compl_xfer_req(hba, tag, is_scsi);
+}
+
 static inline void ufshcd_vops_setup_task_mgmt(struct ufs_hba *hba,
 					int tag, u8 tm_function)
 {
-- 
2.7.4

