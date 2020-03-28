Return-Path: <SRS0=Uiav=5Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 465E0C2D0F1
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Mar 2020 16:10:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2654720CC7
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Mar 2020 16:10:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731149AbgCaQKP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Mar 2020 12:10:15 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:36630 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730562AbgCaQKO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Mar 2020 12:10:14 -0400
IronPort-SDR: 4cDDdotfZSrOFGqJiolPY42RKaKNCZFWr+ijJBDeoMtBy5Dvxkom/Sj9Tm1Vy0v8fUM5QpbtW2
 fh+lXzG4U4cBb2L6v3R2JsTKQ6HElj/+RsxEcVODq4Vw1f/o6PHjLU5FHMiZP57Z0OjtAQW740
 fzO+bAQAnm7VCYkyJM4kYtyJXCuuSO2dNCN+B9vXz5XL8YMlGz5auQ2TyUapusc0RrGtEf4bNS
 76/z7o9dMoHFwGyTf79UQKW+wat6IGc2zB/wwX6eA4x37t85uwzIhcAAfyISfdJcwQTDguBjqK
 NJo=
X-IronPort-AV: E=Sophos;i="5.72,314,1580803200"; 
   d="scan'208";a="28621129"
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by labrats.qualcomm.com with ESMTP; 27 Mar 2020 19:27:37 -0700
Received: from pacamara-linux.qualcomm.com ([192.168.140.135])
  by ironmsg03-sd.qualcomm.com with ESMTP; 27 Mar 2020 19:27:36 -0700
Received: by pacamara-linux.qualcomm.com (Postfix, from userid 359480)
        id AF31C3ABE; Fri, 27 Mar 2020 19:27:36 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 1/1] scsi: ufs: full reinit upon resume if link was off
Date:   Fri, 27 Mar 2020 19:27:31 -0700
Message-Id: <1585362454-5413-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Asutosh Das <asutoshd@codeaurora.org>

During suspend, if the link is put to off, it would require
a full initialization during resume. This patch resets and
restores both the hba and the card during initialization.

Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f19a11e..21e41e5 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8007,9 +8007,13 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		else
 			goto vendor_suspend;
 	} else if (ufshcd_is_link_off(hba)) {
-		ret = ufshcd_host_reset_and_restore(hba);
 		/*
-		 * ufshcd_host_reset_and_restore() should have already
+		 * A full initialization of the host and the device is required
+		 * since the link was put to off during suspend.
+		 */
+		ret = ufshcd_reset_and_restore(hba);
+		/*
+		 * ufshcd_reset_and_restore() should have already
 		 * set the link state as active
 		 */
 		if (ret || !ufshcd_is_link_active(hba))
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

