Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52F59C5DF60
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 08:16:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28EC12178F
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 08:16:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XbB+AwP5";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YOV1tpB3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730668AbfKHIQO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 03:16:14 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:50070 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729873AbfKHIQO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Nov 2019 03:16:14 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1C699601E7; Fri,  8 Nov 2019 08:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573200973;
        bh=Khjp9idUetqKkgihK8iOQyiq9dNb53Oa0Bjyc3Bj4LY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XbB+AwP5o0IempQHaBSX/TprgB9tpSlCZdnC41QR0sfy5LyOaPoXx4E7g5SWIg3+y
         OyoUAeKhw+Wgv5xXA/iwDVmG9BYgZO3G2wjn9d/Ggym1taZrTm5u/NG+bYl+Thbha1
         3xmFrucMEzLo9Qabkn7Aci6gtBeoJjxzIjSmGq2k=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5798960386;
        Fri,  8 Nov 2019 08:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573200970;
        bh=Khjp9idUetqKkgihK8iOQyiq9dNb53Oa0Bjyc3Bj4LY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YOV1tpB3+Tj7bME6Iyf1/nNDM0GdTjbewVBRTjH/TQw7SqXqCK83rIboTzT34vzph
         3ezBsrcWSdJMjs62pt7frml5dZX6cQFJHA8xxHwxw16n7anidrX9NwC7E51ZBY230+
         U325+nY776k5eNGDxxgRyXMy/lE/Uv5HHdxGXJdk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5798960386
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
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
        Subhash Jadavani <subhashj@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 4/5] scsi: ufs: Avoid messing up the compl_time_stamp of lrbs
Date:   Fri,  8 Nov 2019 00:15:30 -0800
Message-Id: <1573200932-384-5-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1573200932-384-1-git-send-email-cang@codeaurora.org>
References: <1573200932-384-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To be on the safe side, do not touch one lrb after clear its slot in the
lrb_in_use bitmap to avoid messing up the next task which would possibly
occupy this lrb.

Signed-off-by: Can Guo <cang@codeaurora.org>
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

