Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00B8AC4320A
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 14:43:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF86460F14
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 14:43:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241194AbhHFOnX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 10:43:23 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:41306
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238046AbhHFOnX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 10:43:23 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id C2DDB40660;
        Fri,  6 Aug 2021 14:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1628260981;
        bh=4FcsXIKOCTXdkCXO47xOoDczDuk4vb+/L+ksQUFW4os=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=cDWY6Pqb2XPx2YyXcpAFYQn209DWyKMhg+ZrWWHmKOduA7dp0NNrcRBxWaXSAN3xc
         yxqDw9t5xjQsXaqwFjDNI+esMm8xTWI5PR6D/uLJf1X6BwwX+T5GHd8+NsuqMBZ2W8
         UuZI+GAadjQZ1tGbeHdCFJXSrHiHB5JM3KK6auGQD8m18VWkusOqUYklT64DM4lPCw
         1k65CkR+SuDDU/HAzPF1dzeDoihLh4TCaiAYJtuuNCK7+jKqv1LioTRcZQPQWDb7jC
         rg5Twvo8GFVmXYHnvGd41oZ69N7FaYHDiXK1VwTer19PhFrS5nNhy/+9Ax1ydwrWlq
         jWpx9EvGvThLg==
From:   Colin King <colin.king@canonical.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Daejun Park <daejun7.park@samsung.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] scsi: ufs: Fix unsigned int compared with less than zero
Date:   Fri,  6 Aug 2021 15:43:01 +0100
Message-Id: <20210806144301.19864-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Variable tag is currently and unsigned int and is being compared to
less than zero, this check is always false. Fix this by making tag
an int.

Addresses-Coverity: ("Macro compares unsigned to 0")
Fixes: 4728ab4a8e64 ("scsi: ufs: Remove ufshcd_valid_tag()")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 47a5085f16a9..21378682cb4f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6976,7 +6976,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *host = cmd->device->host;
 	struct ufs_hba *hba = shost_priv(host);
-	unsigned int tag = cmd->request->tag;
+	int tag = cmd->request->tag;
 	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
 	unsigned long flags;
 	int err = FAILED;
-- 
2.31.1

