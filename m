Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A087AC43331
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 06:46:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7281D206B6
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 06:46:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KGDGk+2W";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="X+EDH734"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfKMGqu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Nov 2019 01:46:50 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:44746 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbfKMGqu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Nov 2019 01:46:50 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7FCAA60BF4; Wed, 13 Nov 2019 06:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573627609;
        bh=KXlcTtuXcJB8YvdOR6kq1K60cVzJa2GqQG8wQRd1wPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KGDGk+2WFhbicmOemCwoupqHmX1aV7XdmZYzoANuf/sv1FrixkBPh8XaVgeL2TQua
         nEOL+uUw8GEjMj6oDqpE9ByF3On1S833fRz/4QoHYt58JjK6X/M+kr7xs6qHgInau1
         vPh/4jW3XCCuHHhhOaQgB7SgRPYisbpRuP9a8AX0=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7CF1060B18;
        Wed, 13 Nov 2019 06:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573627608;
        bh=KXlcTtuXcJB8YvdOR6kq1K60cVzJa2GqQG8wQRd1wPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X+EDH734Qu9XG/yNzR8SxfIMhwG/1zp7l0axtgYBUXL14BQE3MJpQ8XdVINOTURbR
         Bvjk9zYLAwR5GrheweNJoB5+B2mHkHRog979QKJdgOkA9h/j1x2TSs9Mc/KD406VNJ
         poUwpKt8tTj8iSXiZKlorGg19tIMZXTVBSQvdCHQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7CF1060B18
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
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 4/7] scsi: ufs: Fix register dump caused sleep in atomic context
Date:   Tue, 12 Nov 2019 22:45:48 -0800
Message-Id: <1573627552-12615-5-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1573627552-12615-1-git-send-email-cang@codeaurora.org>
References: <1573627552-12615-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ufshcd_print_host_regs() can be called by interrupt handler, but it may
sleep due to ufshcd_dump_regs() allocates the dump buffer memory with flag
GFP_KERNEL. Fix it by changing GFP_KERNEL to GFP_ATMOIC.

Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f12f5a7..671ea2a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -117,7 +117,7 @@ int ufshcd_dump_regs(struct ufs_hba *hba, size_t offset, size_t len,
 	if (offset % 4 != 0 || len % 4 != 0) /* keep readl happy */
 		return -EINVAL;
 
-	regs = kzalloc(len, GFP_KERNEL);
+	regs = kzalloc(len, GFP_ATOMIC);
 	if (!regs)
 		return -ENOMEM;
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

