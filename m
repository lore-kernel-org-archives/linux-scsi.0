Return-Path: <SRS0=Iijn=Y7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94E31C5DF60
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 08:42:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F05221D7B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 08:42:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QgcHv4+W";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TDAil+xJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387689AbfKGImx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 03:42:53 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:33550 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727120AbfKGImx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2019 03:42:53 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id AADD6607EB; Thu,  7 Nov 2019 08:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573116171;
        bh=FhzGwJZQG2zJIB0Q8ktwYHU/Z1FDW9gQQHn1DIAHV4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QgcHv4+Weq7gI9pkj1d8Cvwr3SDxu0OameeS/mWWBcWbok2neukfSamj2oixhIHSb
         220/8R64m2PQ++CxtT9OKi+bGQPeYLLe8ZciZKYUzJ0MFWQQbYtz38m58eGOt5RnKX
         GWrMRYJ9NLOIwrNizVS7/hbnjAbnNu4Vfwhq72yA=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B6AF2607EB;
        Thu,  7 Nov 2019 08:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573116168;
        bh=FhzGwJZQG2zJIB0Q8ktwYHU/Z1FDW9gQQHn1DIAHV4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TDAil+xJ4MkAIfiZwIvvGtUTsSZqealEIM67adLwcUgDx6XnimFxR1yy3rlrmF6I/
         E2cF565+yB472vgVIy6tFyVE/X9RcWoVlcjDULZa6gJNegrNn4km95JnsSwMZy9TtO
         cSob/iF36PgRwQOXboR8NATXAem49coqrXLZik4Q=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B6AF2607EB
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
        Tomas Winkler <tomas.winkler@intel.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 3/6] scsi: ufs: Remove the check before call setup clock notify vops
Date:   Thu,  7 Nov 2019 00:42:10 -0800
Message-Id: <1573116140-22408-4-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1573116140-22408-1-git-send-email-cang@codeaurora.org>
References: <1573116140-22408-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The functionality of vendor specific ops should be hanfundled properly in
platform specific driver, but should not count on UFS driver.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c386c2d..4dfd705 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7379,16 +7379,9 @@ static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 	if (list_empty(head))
 		goto out;
 
-	/*
-	 * vendor specific setup_clocks ops may depend on clocks managed by
-	 * this standard driver hence call the vendor specific setup_clocks
-	 * before disabling the clocks managed here.
-	 */
-	if (!on) {
-		ret = ufshcd_vops_setup_clocks(hba, on, PRE_CHANGE);
-		if (ret)
-			return ret;
-	}
+	ret = ufshcd_vops_setup_clocks(hba, on, PRE_CHANGE);
+	if (ret)
+		return ret;
 
 	list_for_each_entry(clki, head, list) {
 		if (!IS_ERR_OR_NULL(clki->clk)) {
@@ -7412,16 +7405,9 @@ static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 		}
 	}
 
-	/*
-	 * vendor specific setup_clocks ops may depend on clocks managed by
-	 * this standard driver hence call the vendor specific setup_clocks
-	 * after enabling the clocks managed here.
-	 */
-	if (on) {
-		ret = ufshcd_vops_setup_clocks(hba, on, POST_CHANGE);
-		if (ret)
-			return ret;
-	}
+	ret = ufshcd_vops_setup_clocks(hba, on, POST_CHANGE);
+	if (ret)
+		return ret;
 
 out:
 	if (ret) {
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

