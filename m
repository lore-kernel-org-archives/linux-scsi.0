Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A0C8C432BE
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 00:53:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E6016102A
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 00:53:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241481AbhIAAyv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Aug 2021 20:54:51 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:51637 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231509AbhIAAyu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Aug 2021 20:54:50 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210901005353epoutp036000906610e21b40204c3e52403f8165~gjJQyAtLF3220032200epoutp03V
        for <linux-scsi@vger.kernel.org>; Wed,  1 Sep 2021 00:53:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210901005353epoutp036000906610e21b40204c3e52403f8165~gjJQyAtLF3220032200epoutp03V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1630457633;
        bh=gGDb+7FigMgN4FxCep8kmlEfPBvC4hSxrozBLm2y1w0=;
        h=From:To:Cc:Subject:Date:References:From;
        b=QIfrvVP1l+GIurlBSQDe9d8OTHVnq9k7R5ekik1HScQc6Hur+OnGO2sOSl3HjfEaM
         1nfTQtDhRE7Yxrj4gY61ewKov4PF/VElntP9DUlHH2JCYVkkgfZ3mGqvrMIZ9DPNMb
         bULHMjHoCBsbnJEc6haU961c9IySYLRQH/uz4frg=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210901005352epcas1p191896656d4786e2329380bd05a3351e6~gjJP_PjUD1377213772epcas1p1v;
        Wed,  1 Sep 2021 00:53:52 +0000 (GMT)
Received: from epsmges1p3.samsung.com (unknown [182.195.38.249]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4GzltR23RZz4x9QL; Wed,  1 Sep
        2021 00:53:51 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        BE.A6.09765.F1FCE216; Wed,  1 Sep 2021 09:53:51 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210901005350epcas1p10781b465ef299afd8b2f69e78b39cf5c~gjJOTpFzn1377213772epcas1p1o;
        Wed,  1 Sep 2021 00:53:50 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210901005350epsmtrp27d2f1a57d8ca67db414a1579c4ea93bf~gjJOSswrs1888918889epsmtrp2_;
        Wed,  1 Sep 2021 00:53:50 +0000 (GMT)
X-AuditID: b6c32a37-915ff70000002625-89-612ecf1ffb1b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F1.56.09091.E1FCE216; Wed,  1 Sep 2021 09:53:50 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.100.232]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210901005350epsmtip2a684a2801484bb9819b5c8493dd62906~gjJOFLWEb2900529005epsmtip2m;
        Wed,  1 Sep 2021 00:53:50 +0000 (GMT)
From:   Chanwoo Lee <cw9316.lee@samsung.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, daejun7.park@samsung.com,
        beanhuo@micron.com, stanley.chu@mediatek.com,
        keosung.park@samsung.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     grant.jung@samsung.com, jt77.jang@samsung.com,
        dh0421.hwang@samsung.com, sh043.lee@samsung.com,
        ChanWoo Lee <cw9316.lee@samsung.com>
Subject: [PATCH v2] scsi: ufs: ufshpb: Remove unused parameters
Date:   Wed,  1 Sep 2021 09:46:20 +0900
Message-Id: <20210901004620.29929-1-cw9316.lee@samsung.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPJsWRmVeSWpSXmKPExsWy7bCmrq78eb1Eg6OvOS0ezNvGZvHy51U2
        i4MPO1ksZpxqY7VY9SDcYt+1k+wWv/6uZ7dYdGMbk8WO52fYLY6ffMdocXnXHDaL7us72CyW
        H//HZNH0Zx+LxdKtNxkd+D0mLDrA6NFycj+Lx/f1HWweH5/eYvHo27KK0ePzJjmP9gPdTAHs
        Udk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUB3KymU
        JeaUAoUCEouLlfTtbIryS0tSFTLyi0tslVILUnIKzAr0ihNzi0vz0vXyUkusDA0MjEyBChOy
        M1ZOKi54ylXx8+E9tgbG5xxdjBwcEgImEmuPiXYxcnEICexglFj64QY7hPOJUWLt0aMsEM43
        RolpMxazdjFygnXM6uxnhEjsZZTYN7eHFcL5wihxbscUVpC5bAJaErePeYM0iAg0MUnsPlsF
        UsMs0MUo8etgFwtIQljAXuLKohXMIDaLgKpEw9MrYDavgLXEzm3f2CG2yUv8ud8DFReUODnz
        CVgvM1C8eetsZpChEgJTOST+/djNBvGQi8Tbs/UQvcISr45vgZojJfH53V42iPpmRolTs8+x
        QzgtjBKvr9yAqjKW+PT5MyPIIGYBTYn1u/QhwooSO3/PZYRYzCfx7msPK8QuXomONiGIEhWJ
        OV3n2GB2fbzxGKrEQ+Lz1WyQsJBArMTSh5sZJzDKz0LyzSwk38xC2LuAkXkVo1hqQXFuemqx
        YYExPE6T83M3MYJTrpb5DsZpbz/oHWJk4mA8xCjBwawkwpv9RitRiDclsbIqtSg/vqg0J7X4
        EKMpMHwnMkuJJucDk35eSbyhiaWBiZmRiYWxpbGZkjgv4yuZRCGB9MSS1OzU1ILUIpg+Jg5O
        qQamE28ezDEw//hj8zwfJnvtadOF9C1UZxe8XLiz5GQr66IJOYG98W+lK6pKFCIdJDT+fXPs
        c/N4uFpftMNZStYk66p24X2rTeHnXxUtXs+Qd9xI/cxc39oVCT7zORLPWF7c7ZP/lXPaNGOj
        ql+HNFmKe3w0k6+lvQhlv6dW+ncKg81plQduV3vrs6wckoRulzmuv+YV8JT9y8al91kftMpN
        5tJcm2SWZLfdlzk6dM7xeN2Zm6UsYm4Wr500996nb1/aqn2ZpRjv7vbZXLpD/92apY5Hr/gI
        JPJYyXUvXJWkrn/X9oWBxNr6vnMOvcdcLpqEZ+TLvD856Uu5GM+OgrPuZ3yfG32q+PO1sHdq
        WKgSS3FGoqEWc1FxIgDcV2NgQgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsWy7bCSvK7ceb1Eg2v7ZS0ezNvGZvHy51U2
        i4MPO1ksZpxqY7VY9SDcYt+1k+wWv/6uZ7dYdGMbk8WO52fYLY6ffMdocXnXHDaL7us72CyW
        H//HZNH0Zx+LxdKtNxkd+D0mLDrA6NFycj+Lx/f1HWweH5/eYvHo27KK0ePzJjmP9gPdTAHs
        UVw2Kak5mWWpRfp2CVwZKycVFzzlqvj58B5bA+Nzji5GTg4JAROJWZ39jCC2kMBuRomlLzMg
        4lISu/efZ+ti5ACyhSUOHy7uYuQCKvnEKPH35wV2kDibgJbE7WPeIHERgT4miZ2r1jGCOMwC
        ExglFl95ywwySFjAXuLKohVgNouAqkTD0ytgNq+AtcTObd/YIZbJS/y53wMVF5Q4OfMJC4jN
        DBRv3jqbeQIj3ywkqVlIUgsYmVYxSqYWFOem5xYbFhjmpZbrFSfmFpfmpesl5+duYgRHgZbm
        Dsbtqz7oHWJk4mA8xCjBwawkwpv9RitRiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+FrpPxQgLp
        iSWp2ampBalFMFkmDk6pBiYzCaV85XPz+Xkz2pvTqivCa8o51H9rGZxw3+G39V3YdL3ZjMWL
        eE4FdX9Z6Vf7Yv+UXRKd32yV1M5v3dfzRXL1v6PR/3RezSm70dE0d6MTo1ecyceigAuTPjI0
        s3gpHFQS/fLupso/W3Ymt29dIcvNS/dOf8BwMt79Z/7Pi+nb7z/ey7RvRVzBrMjm1cd60rq6
        7NceDM1WsTBsbN58sLelvk+4ZMXO/G8ytz65lARtY25fOJdB9cp6M/n4lkth0hOEbJOnHu9r
        X9G18O5rN0n2q/scdCo8JGJCdjbK3p0pe/vJvUfnz9xyL7WOW90rMi1ru67K98hYNenjRxn8
        n7xcllSiItKx7+v8rXJKn5RYijMSDbWYi4oTAXzdOz3xAgAA
X-CMS-MailID: 20210901005350epcas1p10781b465ef299afd8b2f69e78b39cf5c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210901005350epcas1p10781b465ef299afd8b2f69e78b39cf5c
References: <CGME20210901005350epcas1p10781b465ef299afd8b2f69e78b39cf5c@epcas1p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: ChanWoo Lee <cw9316.lee@samsung.com>

The following parameters are not used in the function.
So, remove unused parameters.

*func(): ufshpb_set_hpb_read_to_upiu
 -> struct ufshpb_lu *hpb
 -> u32 lpn

Signed-off-by: ChanWoo Lee <cw9316.lee@samsung.com>

---
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

