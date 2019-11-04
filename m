Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A592CA9ED8
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:02:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B8DA20656
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:02:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbfKDJCe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 04:02:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:57256 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728078AbfKDJCO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Nov 2019 04:02:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CE373B4A9;
        Mon,  4 Nov 2019 09:02:10 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Bart van Assche <bvanassche@acm.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 13/52] dpt_i2o: use standard SAM status codes
Date:   Mon,  4 Nov 2019 10:01:12 +0100
Message-Id: <20191104090151.129140-14-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191104090151.129140-1-hare@suse.de>
References: <20191104090151.129140-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use standard SAM status codes and omit the explicit shift to convert
from linux-specific ones.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/dpt_i2o.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index abc74fd474dc..83576fd694c4 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -2656,7 +2656,7 @@ static void adpt_fail_posted_scbs(adpt_hba* pHba)
 		unsigned long flags;
 		spin_lock_irqsave(&d->list_lock, flags);
 		list_for_each_entry(cmd, &d->cmd_list, list) {
-			cmd->result = (DID_OK << 16) | (QUEUE_FULL <<1);
+			cmd->result = (DID_OK << 16) | SAM_STAT_TASK_SET_FULL;
 			cmd->scsi_done(cmd);
 		}
 		spin_unlock_irqrestore(&d->list_lock, flags);
-- 
2.16.4

