Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2683FC2BBCF
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 10:03:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA4D922795
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 10:03:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387885AbgLDKDa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 05:03:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:51242 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387862AbgLDKDa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 4 Dec 2020 05:03:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 42B7CAF2F;
        Fri,  4 Dec 2020 10:01:48 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 29/37] esp_scsi: do not set SCSI message byte
Date:   Fri,  4 Dec 2020 11:01:32 +0100
Message-Id: <20201204100140.140863-30-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20201204100140.140863-1-hare@suse.de>
References: <20201204100140.140863-1-hare@suse.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The message byte setting always devolves to COMMAND_COMPLETE, so
we can drop setting the message byte in the SCSI result.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/esp_scsi.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 2bc7e990c119..007ccef5d1e2 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -907,10 +907,8 @@ static void esp_cmd_is_done(struct esp *esp, struct esp_cmd_entry *ent,
 	esp_free_lun_tag(ent, dev->hostdata);
 	cmd->result = 0;
 	set_host_byte(cmd, host_byte);
-	if (host_byte == DID_OK) {
-		set_msg_byte(cmd, ent->message);
+	if (host_byte == DID_OK)
 		set_status_byte(cmd, ent->status);
-	}
 
 	if (ent->eh_done) {
 		complete(ent->eh_done);
@@ -926,7 +924,6 @@ static void esp_cmd_is_done(struct esp *esp, struct esp_cmd_entry *ent,
 		 */
 		cmd->result = ((DRIVER_SENSE << 24) |
 			       (DID_OK << 16) |
-			       (COMMAND_COMPLETE << 8) |
 			       (SAM_STAT_CHECK_CONDITION << 0));
 
 		ent->flags &= ~ESP_CMD_FLAG_AUTOSENSE;
-- 
2.16.4

