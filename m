Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2732C433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 17:50:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AACBA61405
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 17:50:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245039AbhDURvF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 13:51:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:52398 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245076AbhDURtN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Apr 2021 13:49:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 007C0B2E8;
        Wed, 21 Apr 2021 17:48:02 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 31/42] acornscsi: remove acornscsi_reportstatus()
Date:   Wed, 21 Apr 2021 19:47:38 +0200
Message-Id: <20210421174749.11221-32-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210421174749.11221-1-hare@suse.de>
References: <20210421174749.11221-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Unused.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/arm/acornscsi.c | 25 -------------------------
 1 file changed, 25 deletions(-)

diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index 6a49a75e94ff..17590b1053a8 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -2511,31 +2511,6 @@ static int acornscsi_queuecmd_lck(struct scsi_cmnd *SCpnt,
 
 DEF_SCSI_QCMD(acornscsi_queuecmd)
 
-/*
- * Prototype: void acornscsi_reportstatus(struct scsi_cmnd **SCpntp1, struct scsi_cmnd **SCpntp2, int result)
- * Purpose  : pass a result to *SCpntp1, and check if *SCpntp1 = *SCpntp2
- * Params   : SCpntp1 - pointer to command to return
- *	      SCpntp2 - pointer to command to check
- *	      result  - result to pass back to mid-level done function
- * Returns  : *SCpntp2 = NULL if *SCpntp1 is the same command structure as *SCpntp2.
- */
-static inline void acornscsi_reportstatus(struct scsi_cmnd **SCpntp1,
-					  struct scsi_cmnd **SCpntp2,
-					  int result)
-{
-	struct scsi_cmnd *SCpnt = *SCpntp1;
-
-    if (SCpnt) {
-	*SCpntp1 = NULL;
-
-	SCpnt->result = result;
-	SCpnt->scsi_done(SCpnt);
-    }
-
-    if (SCpnt == *SCpntp2)
-	*SCpntp2 = NULL;
-}
-
 enum res_abort { res_not_running, res_success, res_success_clear, res_snooze };
 
 /*
-- 
2.29.2

