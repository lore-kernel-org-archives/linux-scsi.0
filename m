Return-Path: <SRS0=NMWN=AO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 617DAC433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 05:39:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 395D320772
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 05:39:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="JIPQimFV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726035AbgGCFjG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jul 2020 01:39:06 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:19839 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbgGCFjE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2020 01:39:04 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200703053900epoutp04be4d4003eab36c01f4f011f387deade5~eJ33zrD-c0905409054epoutp04C
        for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2020 05:39:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200703053900epoutp04be4d4003eab36c01f4f011f387deade5~eJ33zrD-c0905409054epoutp04C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593754740;
        bh=XV4VHyivv1UMix0YA1Wmc67ORxLl0zohUGbKIZb7yL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=JIPQimFVkK+nzMWmfyDlwP7NA/QlZ6KXgPFhv78kfjyN8Im4jLGNlyKQNnS4UZU/x
         UdN8iMsDkhD0dWyBYAS+sBqwK2ZDfA1kf4Zw3eWkfZzoj4Zxu9utrCOPjmmHxC9C97
         tHl/W/CP8PhZpFpw8U8te5zqG/UDxg7hWiZL1fp0=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20200703053859epcas2p1d248421a52898051cf98526ef59a1ef2~eJ33CYPqq2169721697epcas2p1a;
        Fri,  3 Jul 2020 05:38:59 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.191]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 49ykKV4Jl6zMqYkW; Fri,  3 Jul
        2020 05:38:54 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        07.35.27013.E64CEFE5; Fri,  3 Jul 2020 14:38:54 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20200703053854epcas2p12c65dc7bf34f99354482104f51805b5d~eJ3yXAvtl2169321693epcas2p15;
        Fri,  3 Jul 2020 05:38:54 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200703053854epsmtrp2d7a16dbe7b00fed56dcecc68abeeca17~eJ3yWR2nT0408904089epsmtrp2j;
        Fri,  3 Jul 2020 05:38:54 +0000 (GMT)
X-AuditID: b6c32a48-d1fff70000006985-52-5efec46eb46c
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        72.AA.08382.E64CEFE5; Fri,  3 Jul 2020 14:38:54 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200703053853epsmtip1ba79b7cc690f2356ce2df2e8f8ce3550~eJ3yJTnk92792027920epsmtip1W;
        Fri,  3 Jul 2020 05:38:53 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RFC PATCH v3 1/2] ufs: introduce a callback to get info of command
 completion
Date:   Fri,  3 Jul 2020 14:31:04 +0900
Message-Id: <93c364a2285a6c8eaaed6e0f68bbc8376ae7519e.1593752220.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1593752220.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1593752220.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNJsWRmVeSWpSXmKPExsWy7bCmqW7ekX9xBmuPyVs8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvz6u57dYvXiBywWi25sY7K4ueUoi0X39R1sFsuP/2Oy
        6Lp7g9Fi6b+3LA58HpeveHtc7utl8piw6ACjx/f1HWweH5/eYvHo27KK0ePzJjmP9gPdTAEc
        UTk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUB3KymU
        JeaUAoUCEouLlfTtbIryS0tSFTLyi0tslVILUnIKDA0L9IoTc4tL89L1kvNzrQwNDIxMgSoT
        cjKaPu1mLZgsWHF6yWmWBsZevi5GTg4JAROJZT2b2LsYuTiEBHYwSnx7OJkVwvnEKNE0cT0j
        hPONUeL7xsVsMC2zGs6zQCT2MkpsOLaOGcL5wShxqWs3K0gVm4CmxNObU5lAEiICm5kkXi24
        zwySYBZQl9g14QQTiC0sECnRcvYjWJxFQFXi/vmTYM28AtESq6d9Y4VYJydx81wnWA2ngKVE
        a/N9dlQ2F1DNVA6J27uvMEE0uEh83nULyhaWeHV8CzuELSXx+d1eqB/qJfZNbWCFaO5hlHi6
        7x8jRMJYYtazdiCbA+hSTYn1u/RBTAkBZYkjt1gg7ueT6Dj8lx0izCvR0SYE0ags8WvSZKgh
        khIzb96B2uoh0bdsHpgtBLLpxBWhCYzysxDmL2BkXMUollpQnJueWmxUYIIcfZsYwalUy2MH
        4+y3H/QOMTJxMB5ilOBgVhLhTVD9FyfEm5JYWZValB9fVJqTWnyI0RQYjhOZpUST84HJPK8k
        3tDUyMzMwNLUwtTMyEJJnPed1YU4IYH0xJLU7NTUgtQimD4mDk6pBqbuzFd/w1dGv274nx98
        7H+lgnH/S59DV3VSNSSUCjQZH95d8a6ubIka682I/xX/z29pn7XgesSMPKdTes56H7P+yqup
        vT7++8R1rqtBp5SVZlTXq2wO2nKkoPp/rr66+pJjzim96Yu+svbtM1luM09ZltNzisqz38+N
        Gf/seMRn/lyFsSDl8ySv119PJhts+//o7qTT5m/ig1etSs+Xeh1bqzjtSMeEtjelBeV9zNNq
        DluKqpe/FHv0nXH9QtVEuwirFdfUlrgyCQrdMVkz4W557d+tj/hL/7pPa8oK/XzPNvNezoy7
        Mx0j3V26vFMzPk1UuWqmMzWx9d95+Z3Z6oKRdw7nznkX6xsgMOHgbmMlluKMREMt5qLiRAA+
        e3DOLgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsWy7bCSnG7ekX9xBq92sFo8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvz6u57dYvXiBywWi25sY7K4ueUoi0X39R1sFsuP/2Oy
        6Lp7g9Fi6b+3LA58HpeveHtc7utl8piw6ACjx/f1HWweH5/eYvHo27KK0ePzJjmP9gPdTAEc
        UVw2Kak5mWWpRfp2CVwZTZ92sxZMFqw4veQ0SwNjL18XIyeHhICJxKyG8yxdjFwcQgK7GSX6
        ji5ihEhISpzY+RzKFpa433KEFaLoG6PEzgWLmUASbAKaEk9vTmUCSYgIHGaS+L/1OTtIgllA
        XWLXhBNgRcIC4RJz/l0Di7MIqErcP3+SFcTmFYiWWD3tGyvEBjmJm+c6mUFsTgFLidbm+2D1
        QgIWEnd3z8UpPoFRYAEjwypGydSC4tz03GLDAsO81HK94sTc4tK8dL3k/NxNjOBY0NLcwbh9
        1Qe9Q4xMHIyHGCU4mJVEeBNU/8UJ8aYkVlalFuXHF5XmpBYfYpTmYFES571RuDBOSCA9sSQ1
        OzW1ILUIJsvEwSnVwDSj88aUa9lqHAaGLB5XdGVOeB+8btDaLldksInVbE/1RL1VtuFyZn95
        LjxjnK/3cucy/ZOK7+PLngl93BivGX/xF7eushhjghHTlMO8nwrbv/yqZXrKJK1u4fpmck78
        tKUPuQQuXOE8ov3nsPOKyCXF8SsifVbFHnjt8TwruuC/6v2Xou2Pj55t82GL3DGhp7Tr84zv
        zya/4ltRxXjHr9BAlWs9m3360t/5fn/72uYpr+rbfe7IRRc5rgzHwxHcDPdYloUHr7n6jfv+
        XsHPanElb3O3TJZ4ybP46oOVt97E5sSKn/uxMvKul53rmvTOrV+NV6wwTYlpcDJgb936yWXu
        86o6xzrtehGlo7tFPyixFGckGmoxFxUnAgDQF/jr9AIAAA==
X-CMS-MailID: 20200703053854epcas2p12c65dc7bf34f99354482104f51805b5d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200703053854epcas2p12c65dc7bf34f99354482104f51805b5d
References: <cover.1593752220.git.kwmad.kim@samsung.com>
        <CGME20200703053854epcas2p12c65dc7bf34f99354482104f51805b5d@epcas2p1.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
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
---
 drivers/scsi/ufs/ufshcd.c | 2 ++
 drivers/scsi/ufs/ufshcd.h | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 52abe82..3326236 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4882,6 +4882,7 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 	for_each_set_bit(index, &completed_reqs, hba->nutrs) {
 		lrbp = &hba->lrb[index];
 		cmd = lrbp->cmd;
+		ufshcd_vops_compl_xfer_req(hba, index, (cmd) ? true : false);
 		if (cmd) {
 			ufshcd_add_command_trace(hba, index, "complete");
 			result = ufshcd_transfer_rsp_status(hba, lrbp);
@@ -4890,6 +4891,7 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 			/* Mark completed command as NULL in LRB */
 			lrbp->cmd = NULL;
 			lrbp->compl_time_stamp = ktime_get();
+
 			/* Do not touch lrbp after scsi done */
 			cmd->scsi_done(cmd);
 			__ufshcd_release(hba);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index c774012..5cf9f99 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -307,6 +307,7 @@ struct ufs_hba_variant_ops {
 	void	(*config_scaling_param)(struct ufs_hba *hba,
 					struct devfreq_dev_profile *profile,
 					void *data);
+	void	(*compl_xfer_req)(struct ufs_hba *hba, int tag, bool is_scsi);
 };
 
 /* clock gating state  */
@@ -1137,6 +1138,13 @@ static inline void ufshcd_vops_config_scaling_param(struct ufs_hba *hba,
 		hba->vops->config_scaling_param(hba, profile, data);
 }
 
+static inline void ufshcd_vops_compl_xfer_req(struct ufs_hba *hba,
+					      int tag, bool is_scsi)
+{
+	if (hba->vops && hba->vops->compl_xfer_req)
+		hba->vops->compl_xfer_req(hba, tag, is_scsi);
+}
+
 extern struct ufs_pm_lvl_states ufs_pm_lvl_states[];
 
 /*
-- 
2.7.4

