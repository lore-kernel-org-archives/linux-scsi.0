Return-Path: <SRS0=HJ87=Y2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A508CA9EC7
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 05:04:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E67E21924
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 05:04:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Mi3kMvnx";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JRMJJnly"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbfKBFD7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Nov 2019 01:03:59 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:51262 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfKBFD6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Nov 2019 01:03:58 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 60E6F61549; Sat,  2 Nov 2019 05:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572671037;
        bh=Ve/Yxvbisy8xe2h3IlOlgFo0c2W6vtKPBFXI0QOItL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mi3kMvnx4Ns9FtzRrkiukz9LqlUXHLlN3S/VoVKQGrAqpaILiCJXaKFrADR9ySYgu
         gLyR+FJYyragj4JBxhca0uWsQZG3mPI6d2wW9AY9SOAGDvruNH5dDU9clEGeBKQ17O
         dWZ664IeZvIBYEETxKviU32NrbLXTIh4noh0MFKg=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 10737614E5;
        Sat,  2 Nov 2019 05:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572671030;
        bh=Ve/Yxvbisy8xe2h3IlOlgFo0c2W6vtKPBFXI0QOItL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JRMJJnlyaH6SyKV7HJaIsjbVrjFuO0gpD8vcD2+2opKuWTdl/zIC2ja9tnQdc0L2s
         xR0NhTOkacqJvuzt//J0R0N1j6YStj7td3Q6xVVSgxgAAMDZ3P6u9T9xooMe/tFI42
         HVGuSvapI0Wy6gSfe3ZSoRWFu+fxkEKnUXACjI3E=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 10737614E5
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
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 1/6] scsi: ufs: Add device reset in link recovery path
Date:   Fri,  1 Nov 2019 22:03:31 -0700
Message-Id: <1572671016-883-2-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1572671016-883-1-git-send-email-cang@codeaurora.org>
References: <1572671016-883-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In order to recover from hibern8 exit failure, perform a reset in
link recovery path before issuing link start-up.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c28c144..525f8e6 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3859,6 +3859,9 @@ static int ufshcd_link_recovery(struct ufs_hba *hba)
 	ufshcd_set_eh_in_progress(hba);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
+	/* Reset the attached device */
+	ufshcd_vops_device_reset(hba);
+
 	ret = ufshcd_host_reset_and_restore(hba);
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

