Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60D79C48BE5
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Jun 2021 09:18:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D79E61002
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Jun 2021 09:18:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbhFUJUS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Jun 2021 05:20:18 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:31946 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbhFUJUS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jun 2021 05:20:18 -0400
Received: from epcas3p2.samsung.com (unknown [182.195.41.20])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210621091802epoutp0451f14818403d40a855ef92e3cf34c3ec~Kjk5TLBoO1118511185epoutp04D
        for <linux-scsi@vger.kernel.org>; Mon, 21 Jun 2021 09:18:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210621091802epoutp0451f14818403d40a855ef92e3cf34c3ec~Kjk5TLBoO1118511185epoutp04D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1624267082;
        bh=BkLKe4A7FHy8X5Pp4d78LtN0pOn1oXblP8uasI6bamk=;
        h=Subject:Reply-To:From:To:Date:References:From;
        b=cGw0vsPBp+r59+Hpm4FyvYSEa/Om3Wvf8ZRdY6f6GL5imA0V4KgLY5O5AevztdSlC
         QqrCMWAD1UsDoC3Oo+GLrvgTmPzzqNybcmKJjhCHxnGyX1zHk5OkqgcJTWrrjqMTNd
         awzTmk0E5/jL1AE0ZkBjRl8B8hgKfFPD+pLELO8A=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas3p2.samsung.com (KnoxPortal) with ESMTP id
        20210621091801epcas3p297e4cb21fcb590a8f291978aab6a3f7d~Kjk4pjCQx3249532495epcas3p2i;
        Mon, 21 Jun 2021 09:18:01 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp3.localdomain
        (Postfix) with ESMTP id 4G7kTP6gcYz4x9QJ; Mon, 21 Jun 2021 09:18:01 +0000
        (GMT)
Mime-Version: 1.0
Subject: [PATCH] scsi: ufs: Refactor ufshcd_is_intr_aggr_allowed()
Reply-To: keosung.park@samsung.com
Sender: Keoseong Park <keosung.park@samsung.com>
From:   Keoseong Park <keosung.park@samsung.com>
To:     "joe@perches.com" <joe@perches.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        "satyat@google.com" <satyat@google.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01624267081897.JavaMail.epsvc@epcpadp4>
Date:   Mon, 21 Jun 2021 17:51:58 +0900
X-CMS-MailID: 20210621085158epcms2p46170ba48174547df00b9720dbc843110
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210621085158epcms2p46170ba48174547df00b9720dbc843110
References: <CGME20210621085158epcms2p46170ba48174547df00b9720dbc843110@epcms2p4>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Change conditional compilation to IS_ENABLED macro,
and simplify if else statement to return statement.
No functional change.

Signed-off-by: Keoseong Park <keosung.park@samsung.com>
---
 drivers/scsi/ufs/ufshcd.h | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index c98d540ac044..6d239a855753 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -893,16 +893,15 @@ static inline bool ufshcd_is_rpm_autosuspend_allowed(struct ufs_hba *hba)
 
 static inline bool ufshcd_is_intr_aggr_allowed(struct ufs_hba *hba)
 {
-/* DWC UFS Core has the Interrupt aggregation feature but is not detectable*/
-#ifndef CONFIG_SCSI_UFS_DWC
-	if ((hba->caps & UFSHCD_CAP_INTR_AGGR) &&
-	    !(hba->quirks & UFSHCD_QUIRK_BROKEN_INTR_AGGR))
+	/*
+	 * DWC UFS Core has the Interrupt aggregation feature
+	 * but is not detectable.
+	 */
+	if (IS_ENABLED(CONFIG_SCSI_UFS_DWC))
 		return true;
-	else
-		return false;
-#else
-return true;
-#endif
+
+	return (hba->caps & UFSHCD_CAP_INTR_AGGR) &&
+		!(hba->quirks & UFSHCD_QUIRK_BROKEN_INTR_AGGR);
 }
 
 static inline bool ufshcd_can_aggressive_pc(struct ufs_hba *hba)
-- 
2.17.1
