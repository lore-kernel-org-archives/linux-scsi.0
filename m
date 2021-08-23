Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48A99C4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 09:40:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A48461374
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 09:40:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235716AbhHWJkq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 05:40:46 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:52626 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbhHWJkp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Aug 2021 05:40:45 -0400
Received: from epcas3p2.samsung.com (unknown [182.195.41.20])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210823094002epoutp049ffdc9619dc07421508cf315082aeeee~d5hFQyC2o1494914949epoutp044
        for <linux-scsi@vger.kernel.org>; Mon, 23 Aug 2021 09:40:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210823094002epoutp049ffdc9619dc07421508cf315082aeeee~d5hFQyC2o1494914949epoutp044
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1629711602;
        bh=uyE27SkHI3Ns9KOB7Haj/anPPTHAw4hz43j27DE7sto=;
        h=Subject:Reply-To:From:To:Date:References:From;
        b=rXNT64UqzUsuW2WUCtsGbc3RD0eVFdOYk8ih1YxuNAf5DFajaSKftWlStmj+QVGdf
         /jbzxlIQcfU6aPG0EJzRJrzSwkFnJeB7aRAeGKUNKFz8PBCTLnS1q4986QL6j0VGy7
         ciHTUeczde2bTW/limi0dxJTm5AIktuHPGaev+3g=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas3p1.samsung.com (KnoxPortal) with ESMTP id
        20210823094001epcas3p12d76e0c9add42297a67e30a71f76ea91~d5hEdJk_A0763607636epcas3p1H;
        Mon, 23 Aug 2021 09:40:01 +0000 (GMT)
Received: from epcpadp3 (unknown [182.195.40.17]) by epsnrtp4.localdomain
        (Postfix) with ESMTP id 4GtRzj2Gbxz4x9Pw; Mon, 23 Aug 2021 09:40:01 +0000
        (GMT)
Mime-Version: 1.0
Subject: [PATCH v2] scsi: ufs: ufshpb: Fix possible memory leak
Reply-To: keosung.park@samsung.com
Sender: Keoseong Park <keosung.park@samsung.com>
From:   Keoseong Park <keosung.park@samsung.com>
To:     ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01629711601304.JavaMail.epsvc@epcpadp3>
Date:   Mon, 23 Aug 2021 18:07:14 +0900
X-CMS-MailID: 20210823090714epcms2p1e414fdd91582bdbf8170b4cefb8a0f74
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210823090714epcms2p1e414fdd91582bdbf8170b4cefb8a0f74
References: <CGME20210823090714epcms2p1e414fdd91582bdbf8170b4cefb8a0f74@epcms2p1>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When HPB pinned region exists and mctx allocation for this region fails,
memory leak is possible because memory is not released for the subregion
table of the current region.

So, change to free memory for the subregion table of the current region.

Signed-off-by: Keoseong Park <keosung.park@samsung.com>
---
v1 -> v2:
	* Merge new kvfree() statement with the for-loop below it.
	* Change to assign "hpb->rgn_tbl" when no error occurs.

 drivers/scsi/ufs/ufshpb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 9acce92a356b..58db9ab8f0ae 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -1904,8 +1904,6 @@ static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 	if (!rgn_table)
 		return -ENOMEM;
 
-	hpb->rgn_tbl = rgn_table;
-
 	for (rgn_idx = 0; rgn_idx < hpb->rgns_per_lu; rgn_idx++) {
 		int srgn_cnt = hpb->srgns_per_rgn;
 		bool last_srgn = false;
@@ -1942,10 +1940,12 @@ static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 		rgn->hpb = hpb;
 	}
 
+	hpb->rgn_tbl = rgn_table;
+
 	return 0;
 
 release_srgn_table:
-	for (i = 0; i < rgn_idx; i++)
+	for (i = 0; i <= rgn_idx; i++)
 		kvfree(rgn_table[i].srgn_tbl);
 
 	kvfree(rgn_table);
-- 
2.17.1

