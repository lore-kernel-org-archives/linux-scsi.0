Return-Path: <SRS0=v3DL=ZS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 000DBC432C0
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 06:54:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2BF72080F
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 06:54:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbfKZGyI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 01:54:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:43530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727267AbfKZGyI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Nov 2019 01:54:08 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 810AEC76F4A; Tue, 26 Nov 2019 06:54:06 +0000 (UTC)
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 158B4C447A1;
        Tue, 26 Nov 2019 06:54:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 158B4C447A1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=pass (p=none dis=none) header.from=qti.qualcomm.com
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=pass smtp.mailfrom=cang@qti.qualcomm.com
From:   Can Guo <cang@qti.qualcomm.com>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 3/4] scsi: ufs: Avoid messing up the compl_time_stamp of lrbs
Date:   Mon, 25 Nov 2019 22:53:32 -0800
Message-Id: <1574751214-8321-4-git-send-email-cang@qti.qualcomm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1574751214-8321-1-git-send-email-cang@qti.qualcomm.com>
References: <1574751214-8321-1-git-send-email-cang@qti.qualcomm.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Can Guo <cang@codeaurora.org>

To be on the safe side, do not touch one lrb after clear its slot in the
lrb_in_use bitmap to avoid messing up the next task which would possibly
occupy this lrb.

Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 8e7c362..5950a7c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4902,12 +4902,14 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 			cmd->result = result;
 			/* Mark completed command as NULL in LRB */
 			lrbp->cmd = NULL;
+			lrbp->compl_time_stamp = ktime_get();
 			clear_bit_unlock(index, &hba->lrb_in_use);
 			/* Do not touch lrbp after scsi done */
 			cmd->scsi_done(cmd);
 			__ufshcd_release(hba);
 		} else if (lrbp->command_type == UTP_CMD_TYPE_DEV_MANAGE ||
 			lrbp->command_type == UTP_CMD_TYPE_UFS_STORAGE) {
+			lrbp->compl_time_stamp = ktime_get();
 			if (hba->dev_cmd.complete) {
 				ufshcd_add_command_trace(hba, index,
 						"dev_complete");
@@ -4916,8 +4918,6 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 		}
 		if (ufshcd_is_clkscaling_supported(hba))
 			hba->clk_scaling.active_reqs--;
-
-		lrbp->compl_time_stamp = ktime_get();
 	}
 
 	/* clear corresponding bits of completed commands */
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

