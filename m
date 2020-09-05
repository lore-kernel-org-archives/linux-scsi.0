Return-Path: <SRS0=n0Yx=CO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F22CFC43461
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Sep 2020 05:56:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB1DD208DB
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Sep 2020 05:56:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="YpV/kcW4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbgIEF43 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Sep 2020 01:56:29 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:46093 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbgIEF40 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Sep 2020 01:56:26 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200905055622epoutp038a10fceee93bbd5548ba638447938b06~xzZTyOyLR1140011400epoutp03A
        for <linux-scsi@vger.kernel.org>; Sat,  5 Sep 2020 05:56:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200905055622epoutp038a10fceee93bbd5548ba638447938b06~xzZTyOyLR1140011400epoutp03A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1599285382;
        bh=/bHa5LTyI9vLjgCG8rn2FKYFtFURiL7ySHIHrDNMLLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=YpV/kcW458Z9lqonqHu8ckbvVAKA0baz6qBL5iJLLFV+GtOlmismJTxJzqSqV66eL
         g1hV7VQnDGNpT/gEpvWE5cNI0GjaEXK+KSo5dtTskIZ4pWVNfXObShG10AkuA34aMY
         ZHdSRT/hk6M9HDKxvyhVBipdEEcBc8NaWy9T60Mw=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20200905055621epcas2p34aab185d9d636a1924923e518a53f8dc~xzZTULVhg0172701727epcas2p3U;
        Sat,  5 Sep 2020 05:56:21 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.188]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Bk3h26YtnzMqYkW; Sat,  5 Sep
        2020 05:56:18 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        6F.B9.27013.288235F5; Sat,  5 Sep 2020 14:56:18 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20200905055618epcas2p4b3c308b70a17978b98c87f30c4a88a94~xzZP9_VFU0304503045epcas2p4B;
        Sat,  5 Sep 2020 05:56:18 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200905055618epsmtrp1702ac2d562fb561e72bb7dc217894a5e~xzZP7AJ3C0632406324epsmtrp1I;
        Sat,  5 Sep 2020 05:56:18 +0000 (GMT)
X-AuditID: b6c32a48-d35ff70000006985-71-5f532882f5d6
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        8E.6E.08303.188235F5; Sat,  5 Sep 2020 14:56:17 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200905055617epsmtip1fdec73faf484643b05fe191a3298eabf~xzZPrty9E2804428044epsmtip1o;
        Sat,  5 Sep 2020 05:56:17 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v7 1/2] ufs: introduce a callback to get info of command
 completion
Date:   Sat,  5 Sep 2020 14:47:19 +0900
Message-Id: <49632a6a0c4e2c65d453b7234644e02c327b7f91.1599284713.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1599284713.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1599284713.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJJsWRmVeSWpSXmKPExsWy7bCmqW6TRnC8QdtvI4sH87axWextO8Fu
        8fLnVTaLgw87WSymffjJbPFp/TJWi19/17NbrF78gMVi0Y1tTBY3txxlsei+voPNYvnxf0wW
        XXdvMFos/feWxYHP4/IVb4/Lfb1MHhMWHWD0+L6+g83j49NbLB59W1YxenzeJOfRfqCbKYAj
        KscmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+huJYWy
        xJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUmpBSk6BoWGBXnFibnFpXrpecn6ulaGBgZEpUGVC
        Tsa0ZWdZCt4KVKy5dI2pgbGRr4uRk0NCwETi7pRGJhBbSGAHo8T16TFdjFxA9idGiQvTprFC
        OJ8ZJR6tXsAM03Hw5ndmiI5djBJ/L/tAFP1glGjp72YESbAJaEo8vTmVCSQhIrCZSeLVgvtg
        HcwC6hK7JpwA2ycsECrx7VIvWAOLgKrEs+OPwWp4BaIlJq15wgixTU7i5rlOsDingKXErdl7
        WVHZXEA1Uzkk9hydwgLR4CJxo+MMVLOwxKvjW9ghbCmJl/1tUHa9xL6pDVDNPYwST/f9g2ow
        lpj1rB3I5gC6VFNi/S59EFNCQFniyC0WiPv5JDoO/2WHCPNKdLQJQTQqS/yaNBlqiKTEzJt3
        oEo8JCaeiIeED9Ci569fM09glJ+FMH8BI+MqRrHUguLc9NRiowIT5MjbxAhOo1oeOxhnv/2g
        d4iRiYPxEKMEB7OSCK/HucB4Id6UxMqq1KL8+KLSnNTiQ4ymwHCcyCwlmpwPTOR5JfGGpkZm
        ZgaWphamZkYWSuK876wuxAkJpCeWpGanphakFsH0MXFwSjUw7eiRFohOTSzjSpktvcUvNbCM
        OavLyPt7MtOmdib3XXHH/aOnRUfVyiztZ60Q0DzQu6HYc3Pg8mmvsmr2VDtsWNPu6Om9d94H
        42CRvfrBeU+Xmn3ynrSv/uWZVZERmQtEvhxuc+Xw2+rJxznzuPeU0otOWtEe/lw+M9yO3S6Y
        X9ZyZ3Wi3beTHV7lrGtWbWYs8mzs7C9RW33NzlT526Wr71iP62yeYsT71Pf8PzunCkG+4/OO
        LNo8ZZ6ac9jxU5OEUr4nrX/P+HPK443tDLmsiiLqk5vdfjb2CHjWfDFhl+FZ7ZDwv84oRLam
        oPfayv8P5A51dTQfrNn0fk8R95nTtfszmLy8ei7UdIc+UVdiKc5INNRiLipOBABTotUjLAQA
        AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsWy7bCSnG6TRnC8wXEdiwfztrFZ7G07wW7x
        8udVNouDDztZLKZ9+Mls8Wn9MlaLX3/Xs1usXvyAxWLRjW1MFje3HGWx6L6+g81i+fF/TBZd
        d28wWiz995bFgc/j8hVvj8t9vUweExYdYPT4vr6DzePj01ssHn1bVjF6fN4k59F+oJspgCOK
        yyYlNSezLLVI3y6BK2PasrMsBW8FKtZcusbUwNjI18XIySEhYCJx8OZ35i5GLg4hgR2MEjOO
        n2SDSEhKnNj5nBHCFpa433KEFaLoG6PElD9n2EESbAKaEk9vTmUCSYgIHGaS+L/1OViCWUBd
        YteEE0AJDg5hgWCJE/90QcIsAqoSz44/ZgaxeQWiJSateQK1QE7i5rlOsDingKXErdl7WUFs
        IQELiSMbJrLhEp/AKLCAkWEVo2RqQXFuem6xYYFRXmq5XnFibnFpXrpecn7uJkZwHGhp7WDc
        s+qD3iFGJg7GQ4wSHMxKIrwe5wLjhXhTEiurUovy44tKc1KLDzFKc7AoifN+nbUwTkggPbEk
        NTs1tSC1CCbLxMEp1cDUnWCbI/RPkMtgQ5jozJ8nnzeyqma+mSvjuEnPZevpCufbQoe7il5e
        tsgMfCIeOulTUvG1961Fm7oMXzc+DEwxTazvU/nT/v+QwWz29f+vXW/j/JK/96Vx6H7d4JZq
        mQtfN4h9jGS/8su7p/GFpJjRnyVWpYqvfxnr2Dt4O7p/y7XQy5Naa1SbzVHQXL83UcHa2eqK
        tPmO9x48JdYPN/WG7jt4cfbk01MNVeO1qp/zR0+Zw3S3Sl9xccDfiH9nPqt4WDirtKeuXL/h
        z4ppd3UP8Dydca1uySblF8HTd7PXFlsezz4TzbaFsf7IpWtyna78wsuWLlbeOy3/vfGydQZV
        AYdOtHb9EfrFULPpppASS3FGoqEWc1FxIgDB0B0J8gIAAA==
X-CMS-MailID: 20200905055618epcas2p4b3c308b70a17978b98c87f30c4a88a94
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200905055618epcas2p4b3c308b70a17978b98c87f30c4a88a94
References: <cover.1599284713.git.kwmad.kim@samsung.com>
        <CGME20200905055618epcas2p4b3c308b70a17978b98c87f30c4a88a94@epcas2p4.samsung.com>
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
Acked-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshcd.c | 1 +
 drivers/scsi/ufs/ufshcd.h | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 06e2439..64bd59c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4923,6 +4923,7 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 		lrbp = &hba->lrb[index];
 		lrbp->compl_time_stamp = ktime_get();
 		cmd = lrbp->cmd;
+		ufshcd_vops_compl_xfer_req(hba, index, (cmd) ? true : false);
 		if (cmd) {
 			ufshcd_add_command_trace(hba, index, "complete");
 			result = ufshcd_transfer_rsp_status(hba, lrbp);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 618b253..02bd405 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -307,6 +307,7 @@ struct ufs_hba_variant_ops {
 					struct ufs_pa_layer_attr *,
 					struct ufs_pa_layer_attr *);
 	void	(*setup_xfer_req)(struct ufs_hba *, int, bool);
+	void	(*compl_xfer_req)(struct ufs_hba *hba, int tag, bool is_scsi);
 	void	(*setup_task_mgmt)(struct ufs_hba *, int, u8);
 	void    (*hibern8_notify)(struct ufs_hba *, enum uic_cmd_dme,
 					enum ufs_notify_change_status);
@@ -1111,6 +1112,13 @@ static inline void ufshcd_vops_setup_xfer_req(struct ufs_hba *hba, int tag,
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

