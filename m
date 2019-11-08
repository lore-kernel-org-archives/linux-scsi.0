Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1455FC6194
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 08:16:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5E6F2178F
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 08:16:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TjNxE5sl";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="mdJLYfvD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730720AbfKHIQX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 03:16:23 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:50282 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727573AbfKHIQX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Nov 2019 03:16:23 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9F2D7608FF; Fri,  8 Nov 2019 08:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573200982;
        bh=YE4mTfL1gCRFuKHoeeEuCd7jY1kBHK31oyr+tOEAPfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TjNxE5sliFapWQiDw2tjpWK4diVD81tidrvLsZN04xBkXbyqQg245osh8j0WvyRFT
         obmkRzHZInO9aV54eEBuYua2WAhqMW5Hf0mYUygcwTrpPGxOZEt+Q3rfiAyMt7M4A0
         1USSxCCVUCgjsZTNvXWj/AX9L2qK2GsFKd5vH4mU=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BDCDB60117;
        Fri,  8 Nov 2019 08:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573200977;
        bh=YE4mTfL1gCRFuKHoeeEuCd7jY1kBHK31oyr+tOEAPfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mdJLYfvDzmqZJsbab5fIcgnplrHe06TgdDAckcjLofpkaj0rT7BUCOY9qoMMI5qhT
         VJpA5qEPyNv+CQ8G3/WjJYY10pzaNwQ46p4HVRX6xAVWByjc/QIqInTNq0Hf+xtu6T
         AA0hq2LO40+9TKfW4xeI7YCia+cE4gFEVGOd0KiA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BDCDB60117
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
Subject: [PATCH v1 5/5] scsi: ufs: Complete pending requests in host reset and restore path
Date:   Fri,  8 Nov 2019 00:15:31 -0800
Message-Id: <1573200932-384-6-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1573200932-384-1-git-send-email-cang@codeaurora.org>
References: <1573200932-384-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In UFS host reset and restore path, before probe, we stop and start the
host controller once. After host controller is stopped, the pending
requests, if any, are cleared from the doorbell, but no completion IRQ
would be raised due to the hba is stopped.
These pending requests shall be completed along with the first NOP_OUT
command(as it is the first command which can raise a transfer completion
IRQ) sent during probe.
Since the OCSs of these pending requests are not SUCCESS(because they are
not yet literally finished), their UPIUs shall be dumped. When there are
multiple pending requests, the UPIU dump can be overwhelming and may lead
to stability issues because it is in atomic context.
Therefore, before probe, complete these pending requests right after host
controller is stopped.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5950a7c..4df4136 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5404,8 +5404,8 @@ static void ufshcd_err_handler(struct work_struct *work)
 
 	/*
 	 * if host reset is required then skip clearing the pending
-	 * transfers forcefully because they will automatically get
-	 * cleared after link startup.
+	 * transfers forcefully because they will get cleared during
+	 * host reset and restore
 	 */
 	if (needs_reset)
 		goto skip_pending_xfer_clear;
@@ -6333,9 +6333,13 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 	int err;
 	unsigned long flags;
 
-	/* Reset the host controller */
+	/*
+	 * Stop the host controller and complete the requests
+	 * cleared by h/w
+	 */
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	ufshcd_hba_stop(hba, false);
+	ufshcd_complete_requests(hba);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	/* scale up clocks to max frequency before full reinitialization */
@@ -6369,7 +6373,6 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 static int ufshcd_reset_and_restore(struct ufs_hba *hba)
 {
 	int err = 0;
-	unsigned long flags;
 	int retries = MAX_HOST_RESET_RETRIES;
 
 	do {
@@ -6379,15 +6382,6 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba)
 		err = ufshcd_host_reset_and_restore(hba);
 	} while (err && --retries);
 
-	/*
-	 * After reset the door-bell might be cleared, complete
-	 * outstanding requests in s/w here.
-	 */
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	ufshcd_transfer_req_compl(hba);
-	ufshcd_tmc_handler(hba);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
-
 	return err;
 }
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

