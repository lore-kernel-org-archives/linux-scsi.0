Return-Path: <SRS0=uOdR=AW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B103FC433E2
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Jul 2020 07:05:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B328206F4
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Jul 2020 07:05:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="mC+m3R9d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbgGKHFt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Jul 2020 03:05:49 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:24785 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728034AbgGKHFs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Jul 2020 03:05:48 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200711070546epoutp032c162528175501a2bd5ea33b2211adc4~goN6sgJFb1583615836epoutp03W
        for <linux-scsi@vger.kernel.org>; Sat, 11 Jul 2020 07:05:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200711070546epoutp032c162528175501a2bd5ea33b2211adc4~goN6sgJFb1583615836epoutp03W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594451146;
        bh=tx3CIR9u1gUiVssci1vg/SMB/POOVHhz/CdFyBPep6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=mC+m3R9dfHm9CNNA0weS48FKSGEQeGR4EICNzCwHldF2RJjWJpjRyhIPNp2xOd57O
         TlL/5b1iyzTiYR5nkU203fBg2IVpYB1VVo3sZIN3j5yVjcwXGqrEPOI+t1QULgTnzY
         o/AbnaGKmamRH5vft+GtOs8ZNm40t4K+uGMN4Ovo=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20200711070545epcas2p26b5f76ca063a9948681df4dee8a2e877~goN6KXMIb0916109161epcas2p2s;
        Sat, 11 Jul 2020 07:05:45 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.191]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4B3gsz5nC7zMqYkZ; Sat, 11 Jul
        2020 07:05:43 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        11.85.27441.7C4690F5; Sat, 11 Jul 2020 16:05:43 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20200711070543epcas2p28a42f8386624ecaede5329e035e5e1a9~goN4D3B6V2091420914epcas2p2B;
        Sat, 11 Jul 2020 07:05:43 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200711070543epsmtrp1394760731ba748b19079386d25aa3872~goN4DJGXP0578505785epsmtrp1X;
        Sat, 11 Jul 2020 07:05:43 +0000 (GMT)
X-AuditID: b6c32a47-fafff70000006b31-28-5f0964c706f5
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        40.79.08382.7C4690F5; Sat, 11 Jul 2020 16:05:43 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200711070543epsmtip22df37e4f1895695676c0c57834fa071b~goN33f6iF2838728387epsmtip2K;
        Sat, 11 Jul 2020 07:05:43 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RFC PATCH v5 1/3] ufs: introduce a callback to get info of command
 completion
Date:   Sat, 11 Jul 2020 15:57:43 +0900
Message-Id: <eb76022ae068f8146e774cc0905cfe514b99b19b.1594450408.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1594450408.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1594450408.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDJsWRmVeSWpSXmKPExsWy7bCmqe7xFM54g7U/dC0ezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVnc3HKUxaL7+g42i+XH/zFZ
        dN29wWix9N9bFgc+j8tXvD0u9/UyeUxYdIDR4/v6DjaPj09vsXj0bVnF6PF5k5xH+4FupgCO
        qBybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC7lRTK
        EnNKgUIBicXFSvp2NkX5pSWpChn5xSW2SqkFKTkFhoYFesWJucWleel6yfm5VoYGBkamQJUJ
        ORntH+awFbwVqJiyZAZjA2MjXxcjJ4eEgInE02P/2boYuTiEBHYwSuzvOQzlfGKUuLpqCxOE
        841R4ujjiawwLY27lrJDJPYySpy6+Y8RwvnBKHHwx3ZGkCo2AU2JpzengrWLCGxmkni14D4z
        SIJZQF1i14QTTCC2sECkxKrzK8HGsgioSiyeuo0NxOYViJZYd7qfEWKdnMTNc51gvZwClhJn
        n15gQWVzAdVM5ZB43/yZDaLBReLJLYhlEgLCEq+Ob2GHsKUkXva3Qdn1EvumNrBCNPcwSjzd
        9w9qm7HErGftQDYH0KWaEut36YOYEgLKEkdusUDczyfRcfgvO0SYV6KjTQiiUVni16TJUEMk
        JWbevAO1yUPi0qKnrJAAAtr04cgr5gmM8rMQFixgZFzFKJZaUJybnlpsVGCMHH+bGMHJVMt9
        B+OMtx/0DjEycTAeYpTgYFYS4Y0W5YwX4k1JrKxKLcqPLyrNSS0+xGgKDMiJzFKiyfnAdJ5X
        Em9oamRmZmBpamFqZmShJM5bbHUhTkggPbEkNTs1tSC1CKaPiYNTqoEprpsvorn61I+oE+Kr
        Tlon8M3P/BfJvrLyVV8f2wn1liXrA/ZPXbHnXuPXkLJCL4dMjz3fBaYwlLd+WV7/8/iOp80J
        ihOvrj/2KXZLwtJHXTFnjNaVpJjzKPvuTDm48uLVv7ZH/p9Kmno09k2Cx7XZez9rbz1/ZlJo
        21v5Ke1buQ+teuY+2S3r6/uwZ0q2MqkXlBv6/W4FfxU4VOG0QLb27f3FjmvSJj5puFMzkWUC
        x2fGALHdblOTWZqYVhYnPEqzNk++KcCa2sO7PHDP4+fvb09etdfI92jCT2mhZ6m8XSEz1b9e
        fGw959XzxE0eBQEMe5j2VFup3tcNdHHZ4PI7Z+3uj2Wb51u5vpnwYXbPCyWW4oxEQy3mouJE
        AB3nYCwvBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsWy7bCSvO7xFM54g1svJCwezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVnc3HKUxaL7+g42i+XH/zFZ
        dN29wWix9N9bFgc+j8tXvD0u9/UyeUxYdIDR4/v6DjaPj09vsXj0bVnF6PF5k5xH+4FupgCO
        KC6blNSczLLUIn27BK6M9g9z2AreClRMWTKDsYGxka+LkZNDQsBEonHXUvYuRi4OIYHdjBJH
        j51jgkhISpzY+ZwRwhaWuN9yhBWi6BujxLanj9hBEmwCmhJPb05lAkmICBxmkvi/9TlYgllA
        XWLXhBNgk4QFwiW+taxnAbFZBFQlFk/dxgZi8wpES6w73Q+1QU7i5rlOZhCbU8BS4uzTC0D1
        HEDbLCTWzq/DITyBUWABI8MqRsnUguLc9NxiwwLDvNRyveLE3OLSvHS95PzcTYzgONDS3MG4
        fdUHvUOMTByMhxglOJiVRHijRTnjhXhTEiurUovy44tKc1KLDzFKc7AoifPeKFwYJySQnliS
        mp2aWpBaBJNl4uCUamDSOHOJ++F2nmjfbJenJtO1Q9fa99e/O/pmWdee9/8m/419k5xgckxT
        8+aP52KKR25mpNc959q8x+F3XGLZpyPmk75adz3a+Wb2/poJFTf6P8Vuijf/cfT7Bttygymq
        fk7nmhL/XJv74fM2JU3/XTNtld8p2RRc0+PzmX1JR9ar6VOR2cIHZ9/L5tY1K5+yS+52CdSy
        9pq9PLHmFftPLvfdav5ntRhyOCrOqzntX6NoVv/i52RdgwKOEseUqLX2G77uYjdxK+A/12t+
        NvCIDFucz+PvWofuOcdce3U9Zm2GmKnYdces5c/0TE69Ys1vPtzF2mslxcWzvu9o8Y8rsabr
        Gl2frz0aN0Ffd8e51UuVWIozEg21mIuKEwFKBfwk8gIAAA==
X-CMS-MailID: 20200711070543epcas2p28a42f8386624ecaede5329e035e5e1a9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200711070543epcas2p28a42f8386624ecaede5329e035e5e1a9
References: <cover.1594450408.git.kwmad.kim@samsung.com>
        <CGME20200711070543epcas2p28a42f8386624ecaede5329e035e5e1a9@epcas2p2.samsung.com>
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
index 292af12..092480a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4884,6 +4884,7 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 		lrbp = &hba->lrb[index];
 		lrbp->compl_time_stamp = ktime_get();
 		cmd = lrbp->cmd;
+		ufshcd_vops_compl_xfer_req(hba, index, (cmd) ? true : false);
 		if (cmd) {
 			ufshcd_add_command_trace(hba, index, "complete");
 			result = ufshcd_transfer_rsp_status(hba, lrbp);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index c774012..e5353d6 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -294,6 +294,7 @@ struct ufs_hba_variant_ops {
 					struct ufs_pa_layer_attr *,
 					struct ufs_pa_layer_attr *);
 	void	(*setup_xfer_req)(struct ufs_hba *, int, bool);
+	void	(*compl_xfer_req)(struct ufs_hba *hba, int tag, bool is_scsi);
 	void	(*setup_task_mgmt)(struct ufs_hba *, int, u8);
 	void    (*hibern8_notify)(struct ufs_hba *, enum uic_cmd_dme,
 					enum ufs_notify_change_status);
@@ -1070,6 +1071,13 @@ static inline void ufshcd_vops_setup_xfer_req(struct ufs_hba *hba, int tag,
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

