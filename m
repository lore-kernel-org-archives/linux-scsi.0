Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2DF7C432BE
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 03:03:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B74A60F9E
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 03:03:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241648AbhIADEh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Aug 2021 23:04:37 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:15329 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbhIADEh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Aug 2021 23:04:37 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210901030339epoutp023391ebc485880c0361e2d35ca1727421~gk6kBRYmP2567625676epoutp02i
        for <linux-scsi@vger.kernel.org>; Wed,  1 Sep 2021 03:03:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210901030339epoutp023391ebc485880c0361e2d35ca1727421~gk6kBRYmP2567625676epoutp02i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1630465419;
        bh=lc8zeqoqaH49vhsvrGLKaucQCSd1wvO3g9kCje9XZSo=;
        h=From:To:Cc:Subject:Date:References:From;
        b=QjSrDPYGezK7R6pTHFPfjcFGDZryf73zDsD4uDAmiioIHSRZVqNT6y6Qe0PDXQ/Td
         TBnscNc9fqwDnLFLPQUj4cwKzAo09WhGqcy/IqjOTASfIrgvYw+mozjjFeBbeu9+we
         Ag6Wa615+5HXZDU2geS85M34Z1usQMUZqpGlLiPk=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20210901030338epcas1p354ed9d3fdc9769986f3f09faf7d1e729~gk6jA98l20057900579epcas1p33;
        Wed,  1 Sep 2021 03:03:38 +0000 (GMT)
Received: from epsmges1p1.samsung.com (unknown [182.195.38.242]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4Gzpm90xQXz4x9QK; Wed,  1 Sep
        2021 03:03:37 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        2C.AA.09910.88DEE216; Wed,  1 Sep 2021 12:03:36 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210901030336epcas1p160bcf6510e1eb742316bf0b052051a30~gk6hWWDdj0092400924epcas1p1y;
        Wed,  1 Sep 2021 03:03:36 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210901030336epsmtrp2eee72885a965eee6923fe504465403e6~gk6hVWomt2998129981epsmtrp2J;
        Wed,  1 Sep 2021 03:03:36 +0000 (GMT)
X-AuditID: b6c32a35-c2fff700000026b6-39-612eed884c57
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        63.14.09091.88DEE216; Wed,  1 Sep 2021 12:03:36 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.100.232]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210901030336epsmtip27514b700e4e636be39cf8bcd59bcaa24~gk6hFDYPe0971309713epsmtip2K;
        Wed,  1 Sep 2021 03:03:36 +0000 (GMT)
From:   Chanwoo Lee <cw9316.lee@samsung.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, daejun7.park@samsung.com,
        beanhuo@micron.com, stanley.chu@mediatek.com,
        keosung.park@samsung.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     grant.jung@samsung.com, jt77.jang@samsung.com,
        dh0421.hwang@samsung.com, sh043.lee@samsung.com,
        ChanWoo Lee <cw9316.lee@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3] scsi: ufs: ufshpb: Remove unused parameters
Date:   Wed,  1 Sep 2021 11:56:17 +0900
Message-Id: <20210901025617.31174-1-cw9316.lee@samsung.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Ta0xTZxjO19OeHjDdzlrcPmCbeKIGWFoptx1uzqghh2AGsh+6OYUTOGlr
        29OuFzf5sUBhlYsQwOCgxW2QORMCw1VBxMugLrLicMnACSMoOtABaS2WjXDRrOWUzX/P837P
        8z3v+10wRHwVjcBUrIkxsLSGQEP5PTdjpNJKt4yO6/iQnPqqByVnl++i5MDDSj55xruMkE1D
        VgHZPnWQvPG7S0iuPO8Skm1jPTyy98kvQnLQ5QHkSF8LSlbf60XJ84MveKRl7QafPNc9Dnbj
        1MhoNlXX1g+octePfGqpqwKlFmb+4FO1l9oB5XO8TZ3sr+blYh+p05UMXcQYohi2UFekYhUZ
        RPYH+Xvzk5Lj5FJ5CvkuEcXSWiaD2Lc/V5qp0vj7J6KO0xqzv5RLG43Ezl3pBp3ZxEQpdUZT
        BsHoizT6ZL3MSGuNZlYhYxlTqjwuLj7JLyxQK13uOVT/dNNnFue4oATcD6kCIRjEE2Hn7BJa
        BUIxMd4LYIevl8eRZwBOrPwg4Mg/AJ5xtIINS+tFe3DhOoDf908GySKAfTOP/X4MQ/FYOHEr
        O2AIwy08eHW4OKBBcAeATbaG9Z0k+Huweda+jvn4djhQMyEMYBGeBh31iyiXtgWuPTiFcPXX
        oKt5mh/AiL9e1m1HAptCvBOD8/ctAs6wD9b+PCfksATODV4K4gjo81xHOUMZgEP2O0KOlAM4
        PzoWVCXAZz4fCIyA4DGwq28nV94Kr6yeBVzyK9Dz9ylBQAJxEaywijnJNthSdQfdyFoY+zPY
        DwVvd6yuYzF+BJZN2Ph1YIvtpXlsL81j+z/4G4C0g9cZvVGrYIxyvfy/ey3UaR1g/RXHJvWC
        erdX5gQ8DDgBxBAiTCR4KKPFoiL6RDFj0OUbzBrG6ARJ/hOuRyI2F+r834A15csTU+ISk+MT
        yYSUhGTiDRGYe5MW4wraxKgZRs8YNnw8LCSihOesUUsjL48QTxUP9hwq2C05uaPfuziQc7om
        eiF/c+r56br5Q50tGceveZ74Ss23w9SMI3r12FnP+/fkjQMvxL/m7BU1fMmE7381zT7L3nUv
        ufccWLYeBepPqOG/VJGuakme/tZhcz0zqPdOtjfJvTexcToT/elImrWt4jJPS3eFso92ddvE
        hy98d/Rz3J3KnxRcfGcqT5v1OO+0yfB14kJ3X83236wX0mMLHSWMh2ycwIdUn155a0xlaQyn
        Zw6u4FWPmmNqz7VudZ7YNHotS7nNgyUTK9GVBTkLzzPXDpRm4eKZ4vD4yLSw1m9Ly3XxOxpo
        72pe3sdfkMOS2mPTdQTfqKTlsYjBSP8LrLzl6U4EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsWy7bCSvG7HW71Eg487uSwezNvGZvHy51U2
        i4MPO1kspn34yWwx41Qbq8WqB+EW+66dZLf49Xc9u8WiG9uYLHY8P8NucfzkO0aLy7vmsFl0
        X9/BZrH8+D8mi6Y/+1gslm69yegg4HH5irfHhEUHGD1aTu5n8fi+voPN4+PTWywefVtWMXp8
        3iTn0X6gmymAI4rLJiU1J7MstUjfLoEr4+TbV2wF77krmg7dZG1gvMfZxcjJISFgIrFw82zW
        LkYuDiGB3YwSi3e0MUIkpCR27z/P1sXIAWQLSxw+XAxR84lR4sbGx6wgcTYBLYnbx7xB4iIC
        fUwSO1etYwRxmAV2MEpMXr+QDWSQsIC9xMyXs8GGsgioShzsvc0OYvMKWEtsmviFDWKZvMSf
        +z3MEHFBiZMzn7CA2MxA8eats5knMPLNQpKahSS1gJFpFaNkakFxbnpusWGBYV5quV5xYm5x
        aV66XnJ+7iZGcGxoae5g3L7qg94hRiYOxkOMEhzMSiK8rA/1EoV4UxIrq1KL8uOLSnNSiw8x
        SnOwKInzXug6GS8kkJ5YkpqdmlqQWgSTZeLglGpgErD9lCEd9i3pwOu7LHevJKq+WGh6xEqb
        v3bW07VN90P2vNjFbfG0/sLZeLPnEq0iL/PaXvQwzMsItFppvT1J69HRK56L/597JjIvftqm
        68fs+Z8d5DVwnpI781mHkePHiKuiT9f7zT7xZ/Lkqz8brm4W+JJ3P/LEA5u37j7LZlv3npas
        N0x7vLjn75Km8678IR7TP26Ti+qe3mrWnqLH+7uFdfHm+UuKjyy2X13yWHanoef2jOp+DSsm
        1ys2rU++btzVvLVWaO1zzU97EnNiwh87JPLxcW9z5l88IWhR1bqHh3e1vYo6EHG9pH3dRLtf
        +pFPNouJtTX431JZs39iWd+JL/5TnYtPVfi+PKIcaafEUpyRaKjFXFScCABpL8xp/AIAAA==
X-CMS-MailID: 20210901030336epcas1p160bcf6510e1eb742316bf0b052051a30
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210901030336epcas1p160bcf6510e1eb742316bf0b052051a30
References: <CGME20210901030336epcas1p160bcf6510e1eb742316bf0b052051a30@epcas1p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: ChanWoo Lee <cw9316.lee@samsung.com>

The following parameters are not used in the function.
So, remove unused parameters.

*func(): ufshpb_set_hpb_read_to_upiu
 -> struct ufshpb_lu *hpb
 -> u32 lpn

Reviewed-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: ChanWoo Lee <cw9316.lee@samsung.com>

---
v2->v3:
 * Add tag information.
v1->v2:
 * edit description.
---
 drivers/scsi/ufs/ufshpb.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 02fb51ae8b25..589af5f6b940 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -333,9 +333,8 @@ ufshpb_get_pos_from_lpn(struct ufshpb_lu *hpb, unsigned long lpn, int *rgn_idx,
 }
 
 static void
-ufshpb_set_hpb_read_to_upiu(struct ufs_hba *hba, struct ufshpb_lu *hpb,
-			    struct ufshcd_lrb *lrbp, u32 lpn, __be64 ppn,
-			    u8 transfer_len, int read_id)
+ufshpb_set_hpb_read_to_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
+			    __be64 ppn, u8 transfer_len, int read_id)
 {
 	unsigned char *cdb = lrbp->cmd->cmnd;
 	__be64 ppn_tmp = ppn;
@@ -703,8 +702,7 @@ int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		}
 	}
 
-	ufshpb_set_hpb_read_to_upiu(hba, hpb, lrbp, lpn, ppn, transfer_len,
-				    read_id);
+	ufshpb_set_hpb_read_to_upiu(hba, lrbp, ppn, transfer_len, read_id);
 
 	hpb->stats.hit_cnt++;
 	return 0;
-- 
2.29.0

