Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBC72C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Apr 2021 02:23:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B84CC6143A
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Apr 2021 02:23:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbhD3CXx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Apr 2021 22:23:53 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:56391 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbhD3CXw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Apr 2021 22:23:52 -0400
Received: from epcas3p3.samsung.com (unknown [182.195.41.21])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210430022302epoutp04d77d6754b03e5a6e915ca3c9ea05713d~6gXtI0B1B0818208182epoutp04M
        for <linux-scsi@vger.kernel.org>; Fri, 30 Apr 2021 02:23:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210430022302epoutp04d77d6754b03e5a6e915ca3c9ea05713d~6gXtI0B1B0818208182epoutp04M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1619749382;
        bh=j4LWkwldRLUrGOZFZYtV8wATCeynPe4551DILqQur/4=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=KzV8x6qFK4eOk27ftngGS/MxvDWRnyXmeDdNSJEWoMbJ9dv2kOCWbfSwna+xohPve
         IG3tXir8u+FdmBdug2ZnmGlAOr4lcIzDcYmqu3CYX6zAIbxv3155xi3cMsPFQZEDol
         uGKYHcsaJZ0S2WqaPzZhAiIsazIy4wFTdtgg7pug=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas3p4.samsung.com (KnoxPortal) with ESMTP id
        20210430022301epcas3p40a37b8920e942d2440983ff5a8aad732~6gXsi7Amt2702827028epcas3p4H;
        Fri, 30 Apr 2021 02:23:01 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp4.localdomain
        (Postfix) with ESMTP id 4FWbkY5Z1rz4x9Pv; Fri, 30 Apr 2021 02:23:01 +0000
        (GMT)
Mime-Version: 1.0
Subject: [PATCH] scsi: ufs: remove redundant initialization of variable
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
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Daejun Park <daejun7.park@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <2038148563.21619749381770.JavaMail.epsvc@epcpadp4>
Date:   Fri, 30 Apr 2021 11:14:19 +0900
X-CMS-MailID: 20210430021419epcms2p402717e968615d301ba18341d28a828ee
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210430021419epcms2p402717e968615d301ba18341d28a828ee
References: <CGME20210430021419epcms2p402717e968615d301ba18341d28a828ee@epcms2p4>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The variable d_lu_wb_buf_alloc may be repeatedly initialized to 0 in a for-loop.
If the variable is set to a value other than 0, it exits the for-loop, so there is no need to reset it to 0.

Since lun and d_lu_wb_buf_alloc are just being used in a else statement inside a local scope, move the declaration of the variables to that scope.

Signed-off-by: Keoseong Park <keosung.park@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0625da7a42ee..77cc473961a2 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7277,8 +7277,6 @@ static int ufshcd_scsi_add_wlus(struct ufs_hba *hba)
 static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
 {
 	struct ufs_dev_info *dev_info = &hba->dev_info;
-	u8 lun;
-	u32 d_lu_wb_buf_alloc;
 	u32 ext_ufs_feature;
 
 	if (!ufshcd_is_wb_allowed(hba))
@@ -7318,8 +7316,10 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
 				   DEVICE_DESC_PARAM_WB_SHARED_ALLOC_UNITS))
 			goto wb_disabled;
 	} else {
+		u8 lun;
+		u32 d_lu_wb_buf_alloc = 0;
+
 		for (lun = 0; lun < UFS_UPIU_MAX_WB_LUN_ID; lun++) {
-			d_lu_wb_buf_alloc = 0;
 			ufshcd_read_unit_desc_param(hba,
 					lun,
 					UNIT_DESC_PARAM_WB_BUF_ALLOC_UNITS,
-- 
2.17.1
