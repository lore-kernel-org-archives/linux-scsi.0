Return-Path: <SRS0=amAE=Z3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 911B6C43603
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Dec 2019 02:05:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66D15214B2
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Dec 2019 02:05:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="a3ovsm52";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="DPghKjSo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728730AbfLECFS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Dec 2019 21:05:18 -0500
Received: from a27-186.smtp-out.us-west-2.amazonses.com ([54.240.27.186]:57050
        "EHLO a27-186.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728393AbfLECFS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Dec 2019 21:05:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1575511517;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        bh=Sz6ApVmorzrVOvF1+bAfAiw7lYE6hdq0udIrhD+HFGg=;
        b=a3ovsm52YaqnQ04D1NTcQ8/h7Mzns3j51wOYet4kZBQ9loQMpGiCRuFmWr0m2+XN
        5ZPf3kMgPl4mTY6QAK/FA2UqtY2A/bIYVHxBFxHmEgpV/wANnfxahKrfbH5LQxEOZYe
        BGTiaGi4/d7poq7UBmlQ1yAwIQFQQT1A5Jowb+mI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1575511517;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:Feedback-ID;
        bh=Sz6ApVmorzrVOvF1+bAfAiw7lYE6hdq0udIrhD+HFGg=;
        b=DPghKjSowEHZx6SaQwvNrXkHhitDxOaup6wb6ouEW3sEqITlZ4Q1sD0fBvJFYBcW
        9XDR/EmKiH2HP0YVTuSaVWFQ0K7U2A0A6IJbrBGvrsYTfcLRtSXpaUzalZcJw3xNmuB
        dM8+MsOIWju2TgEbx1ALimeV1wgPkZKSS2VyHsH4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0EC44C447A5
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
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
Subject: [PATCH v5 3/5] scsi: ufs: Release clock if DMA map fails
Date:   Thu, 5 Dec 2019 02:05:17 +0000
Message-ID: <0101016ed3cde8e5-aa64e1c2-a930-47d4-b91e-2f7cd23f66b0-000000@us-west-2.amazonses.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1575511482-15115-1-git-send-email-cang@codeaurora.org>
References: <1575511482-15115-1-git-send-email-cang@codeaurora.org>
X-SES-Outgoing: 2019.12.05-54.240.27.186
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In queuecommand path, if DMA map fails, it bails out with clock held.
In this case, release the clock to keep its usage paired.

Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>
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

