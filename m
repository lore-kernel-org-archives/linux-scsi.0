Return-Path: <SRS0=HJ87=Y2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43987CA9EC7
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 05:02:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AE4E218AC
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 05:02:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Vr9paRXx";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="V5m/xaOH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbfKBFB6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Nov 2019 01:01:58 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:50280 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfKBFB5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Nov 2019 01:01:57 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id EE0DB615C4; Sat,  2 Nov 2019 05:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572670916;
        bh=JvxKGa6O4f7zI3Ydz7dqyF7nDweSq45f4x0Pmi5udY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vr9paRXx4JK+GvRWBrH8oMjeTvFC3uFAh3Eyb+n1bvnR9OhWFdw2ENzywdeoIRDfA
         RF4fhX1SCZvWMsv3LTKc/OAOmrsAoJPUIF80jPHK+1N2zjrYj/a9BBGX9O3ItdcBpq
         mYbBUMfOkjhoWJQF2IJ/JbUW+KtdXwNhTyN62wig=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 08A9A61584;
        Sat,  2 Nov 2019 05:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572670915;
        bh=JvxKGa6O4f7zI3Ydz7dqyF7nDweSq45f4x0Pmi5udY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V5m/xaOHApiOxQqqBCRoOiP4T6Lht1OGb/H79YbqHlBHUy+DeYW93gOXXqie9Yt9j
         xy6JoLpKdKe2I1gOKCNgDUvLiwKqe0vFNmjOXZqba8p16VM1zpz/B4xvzap0rb+Sxt
         gOFXVXCtdcy5CjpnF6IEsQv/PCGaoaILgo64n1nc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 08A9A61584
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
Subject: [PATCH v3 3/5] scsi: ufs: Release clock if DMA map fails
Date:   Fri,  1 Nov 2019 22:01:36 -0700
Message-Id: <1572670898-750-4-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1572670898-750-1-git-send-email-cang@codeaurora.org>
References: <1572670898-750-1-git-send-email-cang@codeaurora.org>
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
index 0a6b8f9..979b161 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2504,6 +2504,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
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

