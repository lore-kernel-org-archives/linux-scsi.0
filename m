Return-Path: <SRS0=xkU+=C3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E679C43466
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 03:09:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 176FB2083B
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 03:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600398574;
	bh=Ittz/wxGC9/mPG2IeyB9vgmU2CwAvg/OtpsciejW1Ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=hi+ywYRbyE8WaxxDg2XJuMrOc22rOGN8IGDnn0OEXTDltLWpr2l+KEmNhnGgYuYQp
	 ms7E1FiYjhVHBB4/B0/h2+Y6CdP7cpPNeg5Uxq1h19mVqiMu6+jyY9KYQNIpVGjDJw
	 WGBdLQvtrCm84Hf2oXWXVAJANuy1pv/6C0d1Bi48=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbgIRDJd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Sep 2020 23:09:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726939AbgIRCDC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Sep 2020 22:03:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8DDB208DB;
        Fri, 18 Sep 2020 02:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394582;
        bh=Ittz/wxGC9/mPG2IeyB9vgmU2CwAvg/OtpsciejW1Ec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EiaBtlQ4mB26wh7aUWvfWbdXEzA5p9n/YC0YP2J8cLEYaTK0TcLcPOo59dmGZCS/D
         xTYdQapgFXyQfQHqFBtTDj1oyKXio0l7t8o5mtCGNPXK/K/bGhFGMhB+I2QjgeAcI5
         vfSAXsHcdna8fPoS55sCeTtURzLGuSmi/tMVEXE4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 092/330] scsi: ufs: Make ufshcd_add_command_trace() easier to read
Date:   Thu, 17 Sep 2020 21:57:12 -0400
Message-Id: <20200918020110.2063155-92-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit e4d2add7fd5bc64ee3e388eabe6b9e081cb42e11 ]

Since the lrbp->cmd expression occurs multiple times, introduce a new local
variable to hold that pointer. This patch does not change any
functionality.

Cc: Bean Huo <beanhuo@micron.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20191224220248.30138-3-bvanassche@acm.org
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5e502e1605549..020a93a40a982 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -334,27 +334,27 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba,
 	u8 opcode = 0;
 	u32 intr, doorbell;
 	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
+	struct scsi_cmnd *cmd = lrbp->cmd;
 	int transfer_len = -1;
 
 	if (!trace_ufshcd_command_enabled()) {
 		/* trace UPIU W/O tracing command */
-		if (lrbp->cmd)
+		if (cmd)
 			ufshcd_add_cmd_upiu_trace(hba, tag, str);
 		return;
 	}
 
-	if (lrbp->cmd) { /* data phase exists */
+	if (cmd) { /* data phase exists */
 		/* trace UPIU also */
 		ufshcd_add_cmd_upiu_trace(hba, tag, str);
-		opcode = (u8)(*lrbp->cmd->cmnd);
+		opcode = cmd->cmnd[0];
 		if ((opcode == READ_10) || (opcode == WRITE_10)) {
 			/*
 			 * Currently we only fully trace read(10) and write(10)
 			 * commands
 			 */
-			if (lrbp->cmd->request && lrbp->cmd->request->bio)
-				lba =
-				  lrbp->cmd->request->bio->bi_iter.bi_sector;
+			if (cmd->request && cmd->request->bio)
+				lba = cmd->request->bio->bi_iter.bi_sector;
 			transfer_len = be32_to_cpu(
 				lrbp->ucd_req_ptr->sc.exp_data_transfer_len);
 		}
-- 
2.25.1

