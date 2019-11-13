Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03254C17447
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 06:00:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC136222CD
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 06:00:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="o5KllZa6";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Rie3pc0v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbfKMGAq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Nov 2019 01:00:46 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:35266 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbfKMGAp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Nov 2019 01:00:45 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 52D5860AD9; Wed, 13 Nov 2019 06:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573624845;
        bh=SbJuVvaOrF0yE78HlWlTZZYlmd3w34F0ZH9Nsx1B6+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o5KllZa6sDsqBPEiz9vBKlUtP5C9ApJLBmWGlV+uGbU5e8WAzA2e+8sBbBexzCIoZ
         J4kBZdi94avskbYDH7c0qkpUtBXnUBbkjO/uX8IiNsCdSZw/quowBT0bh9vCyVUo9q
         h/vsoAhdCjJ7CO9GcAjO6KTaPvMJeNSQLLkcYuSM=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 29C2560A61;
        Wed, 13 Nov 2019 06:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573624843;
        bh=SbJuVvaOrF0yE78HlWlTZZYlmd3w34F0ZH9Nsx1B6+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rie3pc0vM+K4KJX7dAzmUl83qy9kKTjmS3BHZ1/KQ8XnCf9FyJnr/P1+tNnRTOljH
         zh7yroo6Zt+b6hHsVGyztVOBJSuRS50oRgW4TBrN/+6BeV+B6wwm+O78CoGiqpLZda
         YPFxHglAHoyi29XplDNY4glmuOZdzKelTTuti/fQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 29C2560A61
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
        Tomas Winkler <tomas.winkler@intel.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 3/5] scsi: ufs: Release clock if DMA map fails
Date:   Tue, 12 Nov 2019 22:00:21 -0800
Message-Id: <1573624824-671-4-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1573624824-671-1-git-send-email-cang@codeaurora.org>
References: <1573624824-671-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In queuecommand path, if DMA map fails, it bails out with clock held.
In this case, release the clock to keep its usage paired.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5484177..9e44506 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2480,6 +2480,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	if (err) {
 		lrbp->cmd = NULL;
 		clear_bit_unlock(tag, &hba->lrb_in_use);
+		ufshcd_release(hba);
 		goto out;
 	}
 	/* Make sure descriptors are ready before ringing the doorbell */
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

