Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 087C6CA9ED0
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 01:36:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB11A222C7
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 01:36:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="O0vG7jda";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="J3Pfr2Mh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbfKDBgP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Nov 2019 20:36:15 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:43108 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728288AbfKDBgO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Nov 2019 20:36:14 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6B53760DC6; Mon,  4 Nov 2019 01:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572831374;
        bh=Ve/Yxvbisy8xe2h3IlOlgFo0c2W6vtKPBFXI0QOItL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O0vG7jdaBbwkSaXjI/75taI22B9Q0SjLDKHtiXTftG3K1GyRdv8eXESvj7RI5zPA2
         uRVbvASQ9jo2vTK97HY49DpO6vddmdHW5UWirhlvda0hzYiGvdmg/XbrPsoMOnkR76
         A4gPLJ0F535O0xjIVV0/2pyQn41x1COIoGGuk2JQ=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 722A060AD0;
        Mon,  4 Nov 2019 01:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572831373;
        bh=Ve/Yxvbisy8xe2h3IlOlgFo0c2W6vtKPBFXI0QOItL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J3Pfr2Mh8ojYKuwntvuWSXDKDA1zvCkVN5cmBC/9dFp3q6VrAO8eENFU1lD+nN4rB
         lG4KOlMN//jJJwrl/u2bvvxYH7Lz6Zd8bcJPzGs4O9zOpBUkStTtBYZi2tyahwLF46
         DNYAfDEGipZLh6o1j8Nhmyw21CebTGsg7Sj2EM2A=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 722A060AD0
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
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 1/7] scsi: ufs: Add device reset in link recovery path
Date:   Sun,  3 Nov 2019 17:35:56 -0800
Message-Id: <1572831362-22779-2-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1572831362-22779-1-git-send-email-cang@codeaurora.org>
References: <1572831362-22779-1-git-send-email-cang@codeaurora.org>
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

