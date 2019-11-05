Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75483CA9EC7
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 04:00:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BF4921928
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 04:00:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hburbf1Q";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="nSpi0ROv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730533AbfKEEAj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 23:00:39 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:35040 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730017AbfKEEAj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 23:00:39 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 19EED61015; Tue,  5 Nov 2019 04:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572926438;
        bh=CfQKWzPAIBBRWL1m6nlO3ABW3eoRsUcJysSGhIsU7XU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hburbf1QsD1tAm9SyqTqJGCDvPxdEYcL8UOBiGc+dqtcLMSrd5cOrPWJ+gCRrBs1j
         mjPc3pyJzADI9vYgrbM7ptIZh7/kmMxDkS9+98u6wqF4SSx6A0ZYwV93NUJ8NLrpDU
         tpSMZedTBFsAF7gEML8WV7lppQjsDKVF5vhqOWTY=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A9EE860D61;
        Tue,  5 Nov 2019 04:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572926436;
        bh=CfQKWzPAIBBRWL1m6nlO3ABW3eoRsUcJysSGhIsU7XU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nSpi0ROvFBgEkZZoZrhC2OLoVVD3EnS17vtbYh224EsL0x2XuWvT9dY8Hstv8tSNf
         25wyT7WsoTzVouCWARkn2qj8gkNK3P9YGDAsPI73FA0hNhXhFBwX5NhRRNnIqeqp0t
         Qo8Xhxf0OmiVci6pjU67RLVxUic1h342eoqzTPxA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A9EE860D61
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Cc:     Subhash Jadavani <subhashj@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 7/7] scsi: ufs: Fix error handing during hibern8 enter
Date:   Mon,  4 Nov 2019 19:57:15 -0800
Message-Id: <1572926236-720-8-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1572926236-720-1-git-send-email-cang@codeaurora.org>
References: <1572926236-720-1-git-send-email-cang@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Subhash Jadavani <subhashj@codeaurora.org>

During clock gating (ufshcd_gate_work()), we first put the link hibern8 by
calling ufshcd_uic_hibern8_enter() and if ufshcd_uic_hibern8_enter()
returns success (0) then we gate all the clocks.
Now let’s zoom in to what ufshcd_uic_hibern8_enter() does internally:
It calls __ufshcd_uic_hibern8_enter() which on detecting the LINERESET,
initiates the full recovery and puts the link back to highest HS gear and
returns success (0) to ufshcd_uic_hibern8_enter() which is the issue as
link is still in active state due to recovery!
Now ufshcd_uic_hibern8_enter() returns success to ufshcd_gate_work() and
hence it goes ahead with gating the UFS clock while link is still in active
state hence I believe controller would raise UIC error interrupts. But when
we service the interrupt, clocks might have already been disabled!

This change fixes for this by returning failure from
__ufshcd_uic_hibern8_enter() if recovery succeeds as link is still not in
hibern8, upon receiving the error ufshcd_hibern8_enter() would initiate
retry to put the link state back into hibern8.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 7a5a904..934c27a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3891,15 +3891,24 @@ static int __ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
 			     ktime_to_us(ktime_sub(ktime_get(), start)), ret);
 
 	if (ret) {
+		int err;
+
 		dev_err(hba->dev, "%s: hibern8 enter failed. ret = %d\n",
 			__func__, ret);
 
 		/*
-		 * If link recovery fails then return error so that caller
-		 * don't retry the hibern8 enter again.
+		 * If link recovery fails then return error code (-ENOLINK)
+		 * returned ufshcd_link_recovery().
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
@@ -3913,7 +3922,7 @@ static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
 
 	for (retries = UIC_HIBERN8_ENTER_RETRIES; retries > 0; retries--) {
 		ret = __ufshcd_uic_hibern8_enter(hba);
-		if (!ret || ret == -ENOLINK)
+		if (!ret)
 			goto out;
 	}
 out:
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

