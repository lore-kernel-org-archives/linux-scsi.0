Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2079DC4320A
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 11:23:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC47660EE8
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 11:23:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245447AbhHFLXa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 07:23:30 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:49210
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231173AbhHFLXa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 07:23:30 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 7CB9C3F049;
        Fri,  6 Aug 2021 11:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1628248993;
        bh=H1p/HXx7/C4MAn4Q4UfTW04vI5AaqbugvXyofQ0obOw=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=TpI9lSCmRlzMVuV3y9ww8ZdpkNWG4J8Gk5L//ujzTGfFHwA99qmPBv7ndCCzlLsSp
         P9vyYOC2j+zHjDjv6fakqwsYGzLCb6MnHvmBaswtRVQSbf+SBuLVZ87CKGHeuHmF8C
         4CsjJOr+l8RKrTxbmn6F8f6+LevmfWVZhFc4wKynJU/AYOmJmJrAL34KYFNFWpjYnJ
         OLMMCWNlHhpR2GeUTZUeGFjqGsOaw1IhQQox9pnSaLvPk35RzZcV2BVUN8eafQcRTH
         SDSiWFV2XgA9tD/D7nkF6tqwuyjyIBZiIG8mYF5b6KdEI0Q4IC8hytIJfu0ci600XW
         SNJSlI4VXl/KQ==
From:   Colin King <colin.king@canonical.com>
To:     Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: snic: Remove redundant assignment to variable ret
Date:   Fri,  6 Aug 2021 12:23:13 +0100
Message-Id: <20210806112313.12434-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable ret is being initialized with a value that is never read,
the assignment is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/snic/snic_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
index 6dd0ff188bb4..92f5b65c2a27 100644
--- a/drivers/scsi/snic/snic_scsi.c
+++ b/drivers/scsi/snic/snic_scsi.c
@@ -2383,7 +2383,7 @@ snic_host_reset(struct scsi_cmnd *sc)
 {
 	struct Scsi_Host *shost = sc->device->host;
 	u32 start_time  = jiffies;
-	int ret = FAILED;
+	int ret;
 
 	SNIC_SCSI_DBG(shost,
 		      "host reset:sc %p sc_cmd 0x%x req %p tag %d flags 0x%llx\n",
-- 
2.31.1

