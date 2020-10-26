Return-Path: <SRS0=a792=EB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DB08C4363A
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 21:30:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA17E2084C
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 21:30:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733242AbgJZVaO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 17:30:14 -0400
Received: from alexa-out-sd-01.qualcomm.com ([199.106.114.38]:63466 "EHLO
        alexa-out-sd-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733222AbgJZVaO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Oct 2020 17:30:14 -0400
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 26 Oct 2020 14:30:14 -0700
X-QCInternal: smtphost
Received: from asutoshd-linux1.qualcomm.com ([10.46.160.39])
  by ironmsg03-sd.qualcomm.com with ESMTP; 26 Oct 2020 14:30:13 -0700
Received: by asutoshd-linux1.qualcomm.com (Postfix, from userid 92687)
        id A246A20DDC; Mon, 26 Oct 2020 14:30:13 -0700 (PDT)
From:   Asutosh Das <asutoshd@codeaurora.org>
To:     asutoshd@codeaurora.org, linux-scsi@vger.kernel.org
Subject: [PATCH v1 1/1] scsi: ufs: Keep UFS regulators on when autobkops enabled
Date:   Mon, 26 Oct 2020 14:30:13 -0700
Message-Id: <6fd8e4d88eb331c9f04c74a3581593961f2caf73.1603747748.git.asutoshd@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: "Bao D. Nguyen" <nguyenb@codeaurora.org>

When bkops is enabled, the UFS device may do bkops during suspend.
With bkops enabled during suspend, keep the regulators
in active operation configuration, allowing the device to draw
high power to support bkops and avoid over current event.

Signed-off-by: Bao D. Nguyen <nguyenb@codeaurora.org>
Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 47c544d..a94543c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8523,7 +8523,9 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	if (ret)
 		goto set_dev_active;
 
-	ufshcd_vreg_set_lpm(hba);
+	/* Device may perform bkops if autobkops is enabled */
+	if (!hba->auto_bkops_enabled)
+		ufshcd_vreg_set_lpm(hba);
 
 disable_clks:
 	/*
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

