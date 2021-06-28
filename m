Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9EB8C2B9F4
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Jun 2021 06:00:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2CE6619B6
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Jun 2021 06:00:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbhF1GCa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Jun 2021 02:02:30 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:44689 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbhF1GC3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jun 2021 02:02:29 -0400
Received: from epcas3p3.samsung.com (unknown [182.195.41.21])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210628060003epoutp04777ea62521d383027f1b1a22838b8dcf~MqZBi4tun2978929789epoutp04H
        for <linux-scsi@vger.kernel.org>; Mon, 28 Jun 2021 06:00:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210628060003epoutp04777ea62521d383027f1b1a22838b8dcf~MqZBi4tun2978929789epoutp04H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1624860003;
        bh=ZBOaOnM5XEPFGcC55XN4dpE+X+wQQkFTm3DwUDgOvdE=;
        h=Subject:Reply-To:From:To:Date:References:From;
        b=MpmJLGRbgtwsqQ4a9ugeeVwbsgYImWzKsP0rdvFV6zJIeRumR8hCvQ6F31jKRVRZK
         L6n3rmb2OS2aLf2mIT+WjwjUC7aV7XSrVdQA/3gcaCKnLJ5P4IgG9fJHAwy06xRkf4
         86fAzJSyIulcel4kSSpynAx9iJdr9J1DvsIkYzcU=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas3p2.samsung.com (KnoxPortal) with ESMTP id
        20210628060001epcas3p2c38c4026db1fbb6c43a167d8095aab09~MqZAVAEGW1026810268epcas3p21;
        Mon, 28 Jun 2021 06:00:01 +0000 (GMT)
Received: from epcpadp3 (unknown [182.195.40.17]) by epsnrtp4.localdomain
        (Postfix) with ESMTP id 4GCxlj5qcBz4x9QP; Mon, 28 Jun 2021 06:00:01 +0000
        (GMT)
Mime-Version: 1.0
Subject: [PATCH v2] scsi: ufs: Refactor ufshcd_is_intr_aggr_allowed()
Reply-To: keosung.park@samsung.com
Sender: Keoseong Park <keosung.park@samsung.com>
From:   Keoseong Park <keosung.park@samsung.com>
To:     ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        "satyat@google.com" <satyat@google.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jpinto@synopsys.com" <jpinto@synopsys.com>,
        "joe@perches.com" <joe@perches.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01624860001810.JavaMail.epsvc@epcpadp3>
Date:   Mon, 28 Jun 2021 14:58:01 +0900
X-CMS-MailID: 20210628055801epcms2p449fdffa1a6c801497d7e65bae2896b79
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210628055801epcms2p449fdffa1a6c801497d7e65bae2896b79
References: <CGME20210628055801epcms2p449fdffa1a6c801497d7e65bae2896b79@epcms2p4>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Simplify if else statement to return statement,
and remove code related to CONFIG_SCSI_UFS_DWC that is not in use.

v1 -> v2
Remove code related to CONFIG_SCSI_UFS_DWC that is not in use.

Cc: Joao Pinto <jpinto@synopsys.com>
Signed-off-by: Keoseong Park <keosung.park@samsung.com>
---
 drivers/scsi/ufs/ufshcd.h | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index c98d540ac044..c9faca237290 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -893,16 +893,8 @@ static inline bool ufshcd_is_rpm_autosuspend_allowed(struct ufs_hba *hba)
 
 static inline bool ufshcd_is_intr_aggr_allowed(struct ufs_hba *hba)
 {
-/* DWC UFS Core has the Interrupt aggregation feature but is not detectable*/
-#ifndef CONFIG_SCSI_UFS_DWC
-	if ((hba->caps & UFSHCD_CAP_INTR_AGGR) &&
-	    !(hba->quirks & UFSHCD_QUIRK_BROKEN_INTR_AGGR))
-		return true;
-	else
-		return false;
-#else
-return true;
-#endif
+	return (hba->caps & UFSHCD_CAP_INTR_AGGR) &&
+		!(hba->quirks & UFSHCD_QUIRK_BROKEN_INTR_AGGR);
 }
 
 static inline bool ufshcd_can_aggressive_pc(struct ufs_hba *hba)
-- 
2.17.1
