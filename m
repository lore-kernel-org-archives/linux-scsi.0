Return-Path: <SRS0=S2y6=2B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ADB1C43603
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 15:29:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D2272467B
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 15:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576078158;
	bh=fBn5ruKtjyqtQ3AqrWeGYxb7+yos4GPULqN2GTJVOfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=BCwR3iJx3+1uc4IDfHyZtJNkK3Q2E/uHwkCSYfpY4k2xSN4tYZzUBhfBpXcLLjDwT
	 gbvW5gq+UCK8ga0Ahg49lpnEugC6VlISv/lZtcQE247fhbG1azJaj2H6ggCr1cmPft
	 fKD11mRtibq/fCEfFXy5CD41KwAVCLAACdj0sP/E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387843AbfLKP3R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Dec 2019 10:29:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:35886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387831AbfLKP3Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Dec 2019 10:29:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E541D208C3;
        Wed, 11 Dec 2019 15:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078154;
        bh=fBn5ruKtjyqtQ3AqrWeGYxb7+yos4GPULqN2GTJVOfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oUtYP2XgVvkFBx6tbsieuA7LDVksDjDEpt2ayBmV2x7V0Ms1enfvjfPjytjNKXhBq
         BvWj3DmMrix1GPN5b1/+w6g3uAvqitP+aUe3junBt3VL5lQdV3XFBmujmzUS4LPq6p
         oprJwZXwlK7LXrnfPjyj5AYtMSCmgLaDNOwpiPGg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Subhash Jadavani <subhashj@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 40/58] scsi: ufs: Fix error handing during hibern8 enter
Date:   Wed, 11 Dec 2019 10:28:13 -0500
Message-Id: <20191211152831.23507-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211152831.23507-1-sashal@kernel.org>
References: <20191211152831.23507-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Subhash Jadavani <subhashj@codeaurora.org>

[ Upstream commit 6d303e4b19d694cdbebf76bcdb51ada664ee953d ]

During clock gating (ufshcd_gate_work()), we first put the link hibern8 by
calling ufshcd_uic_hibern8_enter() and if ufshcd_uic_hibern8_enter()
returns success (0) then we gate all the clocks.  Now let’s zoom in to what
ufshcd_uic_hibern8_enter() does internally: It calls
__ufshcd_uic_hibern8_enter() and if failure is encountered, link recovery
shall put the link back to the highest HS gear and returns success (0) to
ufshcd_uic_hibern8_enter() which is the issue as link is still in active
state due to recovery!  Now ufshcd_uic_hibern8_enter() returns success to
ufshcd_gate_work() and hence it goes ahead with gating the UFS clock while
link is still in active state hence I believe controller would raise UIC
error interrupts. But when we service the interrupt, clocks might have
already been disabled!

This change fixes for this by returning failure from
__ufshcd_uic_hibern8_enter() if recovery succeeds as link is still not in
hibern8, upon receiving the error ufshcd_hibern8_enter() would initiate
retry to put the link state back into hibern8.

Link: https://lore.kernel.org/r/1573798172-20534-8-git-send-email-cang@codeaurora.org
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9feae23bfd097..d25082e573e0a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3684,15 +3684,24 @@ static int __ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
 			     ktime_to_us(ktime_sub(ktime_get(), start)), ret);
 
 	if (ret) {
+		int err;
+
 		dev_err(hba->dev, "%s: hibern8 enter failed. ret = %d\n",
 			__func__, ret);
 
 		/*
-		 * If link recovery fails then return error so that caller
-		 * don't retry the hibern8 enter again.
+		 * If link recovery fails then return error code returned from
+		 * ufshcd_link_recovery().
+		 * If link recovery succeeds then return -EAGAIN to attempt
+		 * hibern8 enter retry again.
 		 */
-		if (ufshcd_link_recovery(hba))
-			ret = -ENOLINK;
+		err = ufshcd_link_recovery(hba);
+		if (err) {
+			dev_err(hba->dev, "%s: link recovery failed", __func__);
+			ret = err;
+		} else {
+			ret = -EAGAIN;
+		}
 	} else
 		ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_ENTER,
 								POST_CHANGE);
@@ -3706,7 +3715,7 @@ static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
 
 	for (retries = UIC_HIBERN8_ENTER_RETRIES; retries > 0; retries--) {
 		ret = __ufshcd_uic_hibern8_enter(hba);
-		if (!ret || ret == -ENOLINK)
+		if (!ret)
 			goto out;
 	}
 out:
-- 
2.20.1

