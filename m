Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94233C4320A
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 02:50:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A18B6108E
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 02:50:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237838AbhHTCum (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 22:50:42 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:60606 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237794AbhHTCum (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 22:50:42 -0400
Received: from epcas3p4.samsung.com (unknown [182.195.41.22])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210820025001epoutp03bc734d32fe2045dd08cedd69cde55f31~c4-PnE69r1841918419epoutp03F
        for <linux-scsi@vger.kernel.org>; Fri, 20 Aug 2021 02:50:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210820025001epoutp03bc734d32fe2045dd08cedd69cde55f31~c4-PnE69r1841918419epoutp03F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1629427801;
        bh=h4IH088jehCETSAa9K4QBYYehY4vUxwWfjOEUe8G1uw=;
        h=Subject:Reply-To:From:To:Date:References:From;
        b=iMjg3dOG5vlnndAtVOOlSdFPj8YcJrBeG9W/Z9THJ3d3HfZakHpg7HyNZZryu+5+m
         A8t1MY23Fo9zkB2bia/5qt3nfc1fcYmcjUilY6H8TjtB8Ux9K9krOjIqTNoJg5nI3K
         zzIgI25V7/iHW6RClI2CHlI2J1uzFBa/gw489Ypk=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas3p1.samsung.com (KnoxPortal) with ESMTP id
        20210820025001epcas3p1f1f72b2f017e6bc9eb8c19aed5c5c61a~c4-PLu0EH2298422984epcas3p16;
        Fri, 20 Aug 2021 02:50:01 +0000 (GMT)
Received: from epcpadp3 (unknown [182.195.40.17]) by epsnrtp1.localdomain
        (Postfix) with ESMTP id 4GrR212rLtz4x9QT; Fri, 20 Aug 2021 02:50:01 +0000
        (GMT)
Mime-Version: 1.0
Subject: [PATCH] scsi: ufs: ufshpb: Fix possible memory leak
Reply-To: keosung.park@samsung.com
Sender: Keoseong Park <keosung.park@samsung.com>
From:   Keoseong Park <keosung.park@samsung.com>
To:     ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01629427801384.JavaMail.epsvc@epcpadp3>
Date:   Fri, 20 Aug 2021 10:46:24 +0900
X-CMS-MailID: 20210820014624epcms2p6724e146ca1f93ba6eac5e7cf95d4cfd2
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210820014624epcms2p6724e146ca1f93ba6eac5e7cf95d4cfd2
References: <CGME20210820014624epcms2p6724e146ca1f93ba6eac5e7cf95d4cfd2@epcms2p6>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When HPB pinned region exists and mctx allocation for this region fails,
memory leak is possible because memory is not released for the subregion
table of the current region.

So, change to free memory for the subregion table of the current region.

Signed-off-by: Keoseong Park <keosung.park@samsung.com>
---
 drivers/scsi/ufs/ufshpb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 9acce92a356b..052f584c789a 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -1933,7 +1933,7 @@ static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 		if (ufshpb_is_pinned_region(hpb, rgn_idx)) {
 			ret = ufshpb_init_pinned_active_region(hba, hpb, rgn);
 			if (ret)
-				goto release_srgn_table;
+				goto release_current_srgn_table;
 		} else {
 			rgn->rgn_state = HPB_RGN_INACTIVE;
 		}
@@ -1944,6 +1944,9 @@ static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 
 	return 0;
 
+release_current_srgn_table:
+	kvfree(rgn_table[rgn_idx].srgn_tbl);
+
 release_srgn_table:
 	for (i = 0; i < rgn_idx; i++)
 		kvfree(rgn_table[i].srgn_tbl);
-- 
2.17.1

