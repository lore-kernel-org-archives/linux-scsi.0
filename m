Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E7D8C43381
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 01:50:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E2C764E16
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 01:50:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbhBEBuP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Feb 2021 20:50:15 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:55197 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233000AbhBEBt5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2021 20:49:57 -0500
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210205014914epoutp0219fbca9ddbb6705bafaf077601ac6ce0~gtuNquTEo1143411434epoutp02H
        for <linux-scsi@vger.kernel.org>; Fri,  5 Feb 2021 01:49:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210205014914epoutp0219fbca9ddbb6705bafaf077601ac6ce0~gtuNquTEo1143411434epoutp02H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1612489754;
        bh=zBlATRvYraRdAaJGrKEnqYtMnm/p4bFoVfSg53NqXac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gs8sYTye/5T2GvL9cOWG363cbS++PQ338yXARUFpnA6GgY24rCoYYSn3XQ7fzh/Go
         79kcrd36ozgwkFa/2Pf38Kvs1t4oYr+BKXyy9c/jTm3I9WUodQVo5L8Wvf+BqV3Dp6
         Zc88c8JUYwmDiY6RrqgIMYz4ZugB3keAXmwVSRKE=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20210205014913epcas1p37bc49ec7611462940f04a7f86b146ea2~gtuM_-k381527315273epcas1p3L;
        Fri,  5 Feb 2021 01:49:13 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.40.163]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4DWyyH1vQ8z4x9Q9; Fri,  5 Feb
        2021 01:49:11 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
        epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
        08.AE.09577.714AC106; Fri,  5 Feb 2021 10:49:11 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
        20210205014910epcas1p3bcaa909ace0684150973ccc3a35bb0de~gtuJ44pAx1526515265epcas1p3B;
        Fri,  5 Feb 2021 01:49:10 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210205014910epsmtrp255cb99957ee22a6dc5d543baad0532b9~gtuJ2FcS92849228492epsmtrp2o;
        Fri,  5 Feb 2021 01:49:10 +0000 (GMT)
X-AuditID: b6c32a39-c13ff70000002569-c8-601ca417bf35
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        EC.E8.13470.614AC106; Fri,  5 Feb 2021 10:49:10 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.101.61]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210205014910epsmtip2e954d452f0c93b43abedb0d53cdaac1d~gtuJkHrar0106301063epsmtip2B;
        Fri,  5 Feb 2021 01:49:09 +0000 (GMT)
From:   DooHyun Hwang <dh0421.hwang@samsung.com>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, asutoshd@codeaurora.org, beanhuo@micron.com,
        jaegeuk@kernel.org, adrian.hunter@intel.com, satyat@google.com
Cc:     grant.jung@samsung.com, jt77.jang@samsung.com,
        junwoo80.lee@samsung.com, jangsub.yi@samsung.com,
        sh043.lee@samsung.com, cw9316.lee@samsung.com,
        sh8267.baek@samsung.com, wkon.kim@samsung.com,
        DooHyun Hwang <dh0421.hwang@samsung.com>
Subject: [PATCH 3/3] scsi: ufs: reset the ufs device before link startup
 retry
Date:   Fri,  5 Feb 2021 10:36:33 +0900
Message-Id: <20210205013633.16243-3-dh0421.hwang@samsung.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210205013633.16243-1-dh0421.hwang@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Tf0xbVRTHc1/b15at81kG3CBiV52RKbQFSi8TGozgno5kGKNZnAYe8ELZ
        SltbujCTIb9SYWWjZIubVTbY+KFMaGCAiFB+LUINYfzYGJsYfoQFgTFHy4ZzwGx5LPLf95z7
        Oeebc+69PJZwBffnpWsyab2GUotxL3ZLb5Ak2K8yIEn6MIeLHLM/4WjqYguOOkz9XDT/5BaO
        uqeL2Mhpq+agC7+bOMg+5uCif9dtXDRrs7JQYfNZDF0eb8FQ69wAF7Wt52NotO17HJlvt+Ko
        pm8DQyVX/8RR3pqdjcYG+jmoqvkOQNdGHrNjfMnRM6cxsrzRSF5pn8fIxtoinLRc7gJkgaOT
        Ta7aCnFy+d5dNnmmqRaQrsZA8usuM5aw41N1lIqmUmm9iNakaFPTNWnR4oMfJb6bKI+QyoJl
        kUghFmmoDDpaHBufEPxeuto9rlh0nFIb3akEymAQS5RReq0xkxaptIbMaDGtS1XrZFJdiIHK
        MBg1aSEp2oz9Mqk0VO4mk9Sq3vtv63K5WUO3snPAIOcU4PMgEQ6HbqyzTwEvnpBoBdA1/QOH
        CZwA2tongYcSEo8BnKgSPa/oGjmNM1AHgGfn/tkKXABa/jJv9sWJENh+unaz1W7CjsGJHzsx
        T8AilgGsuLuIeyhvIgHWFIxverCJvXDo6bNNLSCiYdOgk834vQLXJotZHs0nlLCi6BnOMC9C
        x7ezmwzLzeQ3f8fyGEAinw8r8pYBUxwLR5oucBntDRf6mra0P3Q96MAZbQawpEfJFFsAHO0r
        3joIg06Xy92I53YIgrY2CZPeA395WgYY413wwaNijgeBhAAWmoQM8jq8srHqRrhuHQBzdzBZ
        Ev5dUgCYZZUCOPzHBNcCRNZt01i3TWP937ccsGqBL60zZKTRBplOvv2CG8Hm898X2QrOLz0M
        6QEYD/QAyGOJdwsok3+SUJBKnfiS1msT9UY1begBcveuS1n+Pila9//RZCbK5KFhYWEoPEIR
        IQ8T+wmSpVOJQiKNyqSP0bSO1j+vw3h8/xxMci+tev34JQV3WHl/ytxZdvHqzJIk6w27T7/9
        egy//ue4iMInoZdqDmc3KxoD6s+PHbNvLMxQQso4Lap6s9qrZ+7EufG3hqzDUQdNfPlA7iAr
        np0suen3/kj8yp6cgKMnBYuxpqCjwmli1XLgcPXancDuEtURsDbUsMaxFs28Q6ZIKuv6w1Xe
        vyZ/oszbWdk5pZX5+jx6ba6sNpCo65c4cus+dnwlW/zAEWdpiD03Kbt26KWljV1Ft1UB+U5B
        zqHeDw8kiFdEys9+i5FkHTn5Ramx++Xc67zyFz6fC3zVGdmxV3EzfEFR0acqnvbyrs82yxUz
        IQvdO7/Zf4OOa2roGpwXsw0qSraPpTdQ/wGCc9wohwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsWy7bCSvK7YEpkEg2vd/BYnn6xhs3gwbxub
        xd62E+wWL39eZbM4+LCTxeLT+mWsFjNOtbFa7Lt2kt3i19/17BZP1s9itujYOpnJYtGNbUwW
        O56fYbfY9beZyeLyrjlsFt3Xd7BZLD/+j8mif/VdNoumP/tYLK6dOcFqsXTrTUaLzZe+sTiI
        eVzu62XyWLCp1GPxnpdMHptWdbJ5TFh0gNGj5eR+Fo/v6zvYPD4+vcXi0bdlFaPH501yHu0H
        upkCuKO4bFJSczLLUov07RK4Mg6/sS5oZK+4cLWugfEcaxcjJ4eEgInEgUu9bCC2kMBuRomH
        L8Qg4jIS3ff3sncxcgDZwhKHDxd3MXIBlXxklFjw+CNYL5uAnsSe3lWsIAkRgXNMErfnLWEE
        cZgFfjNKTPrRzA5SJSzgJzF91XNmEJtFQFXiwu//jCA2r4CtxJZzn1ggtslL/LnfA1bDKWAn
        sbDzP9RFthJHnq2GqheUODnzCVg9M1B989bZzBMYBWYhSc1CklrAyLSKUTK1oDg3PbfYsMAw
        L7Vcrzgxt7g0L10vOT93EyM4RrU0dzBuX/VB7xAjEwfjIUYJDmYlEd7ENqkEId6UxMqq1KL8
        +KLSnNTiQ4zSHCxK4rwXuk7GCwmkJ5akZqemFqQWwWSZODilGphcf7T9+mbPdJrTcoq97PN/
        2hrTL9323/LhXb9gbUxXvz/3o/nnaisOnKpTOvphU5h9c8QpXTvG6vlXLt+VfbFMe/v8nXxP
        8nxlUkWEJHdm7EnI4KhbtPz6X81GdvmLL8padxxMqr63/47j44eO9w/9Z71csfjPUa9vm++v
        3burtNTvmlbfXZ9zDr9nKv+dV3k0+o6tseiZikcT0lVW5B7t0/A3+n+p/Jwn+4zvt1Z9sIgJ
        2xlyt/Aoa+nBmw8yn/o7nPoXezK5Jet2WJ1w2+2+1POHP2REr39qxmCx3yD57OXZtZG9a5uf
        vJ38qUst/EqpXH1EUZD0z7vbVX4pK3NJvF3vped0zOlS4T016acaSizFGYmGWsxFxYkALheC
        xEADAAA=
X-CMS-MailID: 20210205014910epcas1p3bcaa909ace0684150973ccc3a35bb0de
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210205014910epcas1p3bcaa909ace0684150973ccc3a35bb0de
References: <20210205013633.16243-1-dh0421.hwang@samsung.com>
        <CGME20210205014910epcas1p3bcaa909ace0684150973ccc3a35bb0de@epcas1p3.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If the link startup command fails, trigger hardware reset to reset
the UFS device before link startup retry.

Signed-off-by: DooHyun Hwang <dh0421.hwang@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 32cb3b0dcbcf..a87e98631a72 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4644,7 +4644,15 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
 				       (u32)ret);
 
 		if (link_startup_again) {
+			int err = 0;
+
 			link_startup_again = false;
+
+			/* Reset the attached device before retrying */
+			err = ufshcd_vops_device_reset(hba);
+			if (err && (err != -EOPNOTSUPP))
+				ufshcd_update_evt_hist(hba, UFS_EVT_DEV_RESET, err);
+
 			retries = DME_LINKSTARTUP_RETRIES;
 			goto link_startup;
 		}
-- 
2.29.0

