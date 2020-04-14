Return-Path: <SRS0=dx4r=56=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1579BC2BBFD
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 06:17:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3A58206E9
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 06:17:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405844AbgDNGQ6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Apr 2020 02:16:58 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:4045 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405829AbgDNGQ5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2020 02:16:57 -0400
IronPort-SDR: GF+nhx7pQG5Eg2UGkLUudbnUbCQzLoEq+k3j4XEYypW5RCLFBgcA1kgW9dhsR/G1jrHiUQ2pfu
 y4tcVGbk6/oBJWG/HWuxHpiLGKh9Ujh2QzIpFKwO4FTUc9if6Jr1WeBNWUL8yJBUeC7UTcoM4I
 EU3QbUOhpMpT4IGo408k+3dMtD18YNm202DnGiZZMz/bjvXUZXWPNiP6Af9mYJeKv8p8sA8IAg
 RkJvlbQEnfZRQhOTMM1/o3dSLhfBAtguxNZPkYk9V2FZOW2VIEAUIFEJj87g44rsDN4GvnGP68
 L2Y=
X-IronPort-AV: E=Sophos;i="5.72,381,1580803200"; 
   d="scan'208";a="46834943"
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by labrats.qualcomm.com with ESMTP; 13 Apr 2020 23:14:56 -0700
Received: from pacamara-linux.qualcomm.com ([192.168.140.135])
  by ironmsg03-sd.qualcomm.com with ESMTP; 13 Apr 2020 23:14:54 -0700
Received: by pacamara-linux.qualcomm.com (Postfix, from userid 359480)
        id CE87E3B21; Mon, 13 Apr 2020 23:14:54 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support)
Subject: [PATCH v2 1/1] scsi: ufs: full reinit upon resume if link was off
Date:   Mon, 13 Apr 2020 23:14:48 -0700
Message-Id: <1586844892-22720-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Asutosh Das <asutoshd@codeaurora.org>

During suspend, if the link is put to off, it would require
a full initialization during resume. This patch resets and
restores both the host and the card during initialization,
otherwise, host only reset and restore may fail occasionally.

Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Acked-by: Stanley Chu <stanley.chu@mediatek.com>

Change since v1:
- Incorporated Alim's comments.

---
 drivers/scsi/ufs/ufshcd.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 64e42ef..90313c8 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8048,9 +8048,13 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		else
 			goto vendor_suspend;
 	} else if (ufshcd_is_link_off(hba)) {
-		ret = ufshcd_host_reset_and_restore(hba);
 		/*
-		 * ufshcd_host_reset_and_restore() should have already
+		 * A full initialization of the host and the device is
+		 * required since the link was put to off during suspend.
+		 */
+		ret = ufshcd_reset_and_restore(hba);
+		/*
+		 * ufshcd_reset_and_restore() should have already
 		 * set the link state as active
 		 */
 		if (ret || !ufshcd_is_link_active(hba))
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

