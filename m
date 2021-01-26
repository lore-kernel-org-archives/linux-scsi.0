Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16C57C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 18:46:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB7C422228
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 18:46:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390582AbhAZRTZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jan 2021 12:19:25 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:16409 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727284AbhAZGqF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 01:46:05 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210126064513epoutp0399c7fa5811b3ad984a0fdb17e2ec6298~dtTypJQ2s2737927379epoutp03X
        for <linux-scsi@vger.kernel.org>; Tue, 26 Jan 2021 06:45:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210126064513epoutp0399c7fa5811b3ad984a0fdb17e2ec6298~dtTypJQ2s2737927379epoutp03X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611643513;
        bh=fXkc/J8P35LYNPusVhQ+9QBrxVTdlboL1ax5vgyVZ0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=nTgjkR4U8ABqUnxYKFtus/l0rfWDUPAkyo5JwztJ8IBLsPS0HrD5cs01/80Scx83Z
         s+CxUlqW/jGoUXA335yPb+jPWY9vxvZSQL6WPKH9W+XPA6X0YqMYLOlOlRoZWBrzB0
         HACGWKNRWvd5kijT2jy9wTDdKq66NEb1C8v1PNkc=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210126064512epcas2p3a53150acde1a5fdfe5486d3779852992~dtTxyVl_t2298922989epcas2p3J;
        Tue, 26 Jan 2021 06:45:12 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.181]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4DPy0P6r10z4x9Pr; Tue, 26 Jan
        2021 06:45:09 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        C4.98.10621.47ABF006; Tue, 26 Jan 2021 15:45:08 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20210126064507epcas2p198d2843a8e4952ac6d99f9743d213b45~dtTtBKCUc1089710897epcas2p1X;
        Tue, 26 Jan 2021 06:45:07 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210126064507epsmtrp27f9cf5b7e8d211e9dd2a780783e63f90~dtTtAUH4E1454614546epsmtrp2V;
        Tue, 26 Jan 2021 06:45:07 +0000 (GMT)
X-AuditID: b6c32a45-337ff7000001297d-b4-600fba7485c1
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        36.09.13470.37ABF006; Tue, 26 Jan 2021 15:45:07 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210126064507epsmtip2e675da9a39c2b5f8ddf5913fb499fea0~dtTs0JogF0891408914epsmtip2_;
        Tue, 26 Jan 2021 06:45:07 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v8 1/2] ufs: introduce a callback to get info of command
 completion
Date:   Tue, 26 Jan 2021 15:33:34 +0900
Message-Id: <ebacbd8c23ca29a340e91a7f563a49440e69e528.1611642467.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1611642467.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1611642467.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLJsWRmVeSWpSXmKPExsWy7bCmuW7JLv4Eg/b5HBYP5m1js9jbdoLd
        4uXPq2wWBx92slh8XfqM1WLah5/MFp/WL2O1+PV3PbvF6sUPWCwW3djGZHFzy1EWi+7rO9gs
        lh//x2TRdfcGo8XSf29ZHPg9Ll/x9rjc18vkMWHRAUaP7+s72Dw+Pr3F4tG3ZRWjx+dNch7t
        B7qZAjiicmwyUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJz
        gI5XUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BQYGhboFSfmFpfmpesl5+daGRoY
        GJkCVSbkZKx5s5K54I1AxfFHRg2MDXxdjBwcEgImEhPXyHYxcnEICexglPi3/AI7hPOJUeJY
        32omCOcbo8TDh8tZuhg5wTpmfnzCBGILCexllNi9yhWi6AejxP5nq8ASbAKaEk9vTgXrFhE4
        wyRxrfUsK0iCWUBdYteEE2BFwgKhEktubWECuYNFQFXizgRdkDCvQLTE63eroZbJSdw818kM
        YnMKWEpMOb6fEZXNBVQzk0Pi5oK/rBANLhIb1/VBNQtLvDq+hR3ClpL4/G4vG4RdL7FvagMr
        RHMPo8TTff8YIRLGErOetTOCHMQM9MH6XfqQMFKWOHKLBeJ8PomOw3/ZIcK8Eh1tQhCNyhK/
        Jk2GGiIpMfPmHaitHhLrHu5hgYQPyKZDl5knMMrPQliwgJFxFaNYakFxbnpqsVGBIXLcbWIE
        p1Mt1x2Mk99+0DvEyMTBeIhRgoNZSYR3tx5PghBvSmJlVWpRfnxRaU5q8SFGU2A4TmSWEk3O
        Byb0vJJ4Q1MjMzMDS1MLUzMjCyVx3mKDB/FCAumJJanZqakFqUUwfUwcnFINTEd/eGZfOSzE
        07S2snmGTOZG454pbx25lNsmz/iqZVdjsO35lE+Lb5WtTzf7luU2pff84X2cu7p7DJ0Sp06R
        ZtuQ6ykYsy8tIDFkykXFj7FmKRf4hNP8pq30D/944Ev5AwProN8aYeK5GyyDO9bv9xd796jm
        xF5tkxsyvPPO3TTUOKyjqXLQrfvNvB8ckTYTtn5eEB9oHivSnNeZwF7ukDxhzsU4GbGdSnnT
        1MXis42DJk7dGr/rY3qRl4WuSfdzvUWGths62e99/mFpd+rpj9x/mTWi8fPcgtcn3V3hzPFm
        QWfHPp9TK2KXcvjYXExzbXKQe376ec4MDeU3ysbB9Qf+rq84wB+yKWXxI4epSizFGYmGWsxF
        xYkA8rQEgzAEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsWy7bCSvG7xLv4Eg4tNmhYP5m1js9jbdoLd
        4uXPq2wWBx92slh8XfqM1WLah5/MFp/WL2O1+PV3PbvF6sUPWCwW3djGZHFzy1EWi+7rO9gs
        lh//x2TRdfcGo8XSf29ZHPg9Ll/x9rjc18vkMWHRAUaP7+s72Dw+Pr3F4tG3ZRWjx+dNch7t
        B7qZAjiiuGxSUnMyy1KL9O0SuDLWvFnJXPBGoOL4I6MGxga+LkZODgkBE4mZH58wdTFycQgJ
        7GaUmDF7OxNEQlLixM7njBC2sMT9liOsEEXfGCXm9zWAFbEJaEo8vTkVrFtE4B6TxKUJc5lB
        EswC6hK7JpwAKxIWCJbom3IayObgYBFQlbgzQRckzCsQLfH63WoWiAVyEjfPdYK1cgpYSkw5
        vh9ssZCAhUTntn/suMQnMAosYGRYxSiZWlCcm55bbFhgmJdarlecmFtcmpeul5yfu4kRHBFa
        mjsYt6/6oHeIkYmD8RCjBAezkgjvbj2eBCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8F7pOxgsJ
        pCeWpGanphakFsFkmTg4pRqYdI/WlikumHRl5+cVGy+7TTrw7OaGiSzrJvYbZCwK4JpfcSQx
        PORwasThxR8SeZyy+v6xO3x7ZhZn/kTWp8tn2dKE/4KB5/3+CRvu6WvfUrb5Gbc1z6k1ercE
        LgfsUrlbdlODv+J/iMRDl4UPP3b2eJbX7+gKn3LicHfCtGdsvjcan93RbxHwcN3QrX0h9ITb
        xydiFhsL1zFdnzjj/mctFkFlcZMtPx3/7D99J7BvbaJWQdGt7pviBkdvz5a8rcNzu233Ssud
        65wezku+ZPtI4rvOm+lc6yI0LY9XhT9bqze9NFrf+9o1Do0ZE7R+lrYbMD5IcBT9fMHlNMce
        8ewi7n+/75kUT/+6vtz9gt2pJUosxRmJhlrMRcWJAEM1YS33AgAA
X-CMS-MailID: 20210126064507epcas2p198d2843a8e4952ac6d99f9743d213b45
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210126064507epcas2p198d2843a8e4952ac6d99f9743d213b45
References: <cover.1611642467.git.kwmad.kim@samsung.com>
        <CGME20210126064507epcas2p198d2843a8e4952ac6d99f9743d213b45@epcas2p1.samsung.com>
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

