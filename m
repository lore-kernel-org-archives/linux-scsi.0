Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAC79C8301A
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 11:54:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86A462222A
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 11:54:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388550AbgLBLyt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 06:54:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:38740 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388458AbgLBLys (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 2 Dec 2020 06:54:48 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9B2F4AE63;
        Wed,  2 Dec 2020 11:53:04 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 22/34] scsi_debug: do not set COMMAND_COMPLETE
Date:   Wed,  2 Dec 2020 12:52:37 +0100
Message-Id: <20201202115249.37690-23-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20201202115249.37690-1-hare@suse.de>
References: <20201202115249.37690-1-hare@suse.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

COMMAND_COMPLETE is defined as '0', so setting it is quite pointless.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 24c0f7ec0351..93048f13a4e3 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -853,7 +853,7 @@ static const int illegal_condition_result =
 	(DRIVER_SENSE << 24) | (DID_ABORT << 16) | SAM_STAT_CHECK_CONDITION;
 
 static const int device_qfull_result =
-	(DID_OK << 16) | (COMMAND_COMPLETE << 8) | SAM_STAT_TASK_SET_FULL;
+	(DID_OK << 16) | SAM_STAT_TASK_SET_FULL;
 
 static const int condition_met_result = SAM_STAT_CONDITION_MET;
 
-- 
2.16.4

