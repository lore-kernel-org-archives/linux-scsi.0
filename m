Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA54AC3526A
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 10:04:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E65D22525
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 10:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388035AbgLDKD5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 05:03:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:52150 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388023AbgLDKD4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 4 Dec 2020 05:03:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 41F41AF2D;
        Fri,  4 Dec 2020 10:01:48 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 28/37] esp_scsi: use host byte as last argument to esp_cmd_is_done()
Date:   Fri,  4 Dec 2020 11:01:31 +0100
Message-Id: <20201204100140.140863-29-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20201204100140.140863-1-hare@suse.de>
References: <20201204100140.140863-1-hare@suse.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Just pass in the host byte to esp_cmd_is_done(), and set the
status or message bytes if the host byte is DID_OK.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc; Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/esp_scsi.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 43a1fd11df5e..2bc7e990c119 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -896,7 +896,7 @@ static void esp_put_ent(struct esp *esp, struct esp_cmd_entry *ent)
 }
 
 static void esp_cmd_is_done(struct esp *esp, struct esp_cmd_entry *ent,
-			    struct scsi_cmnd *cmd, unsigned int result)
+			    struct scsi_cmnd *cmd, unsigned char host_byte)
 {
 	struct scsi_device *dev = cmd->device;
 	int tgt = dev->id;
@@ -905,7 +905,12 @@ static void esp_cmd_is_done(struct esp *esp, struct esp_cmd_entry *ent,
 	esp->active_cmd = NULL;
 	esp_unmap_dma(esp, cmd);
 	esp_free_lun_tag(ent, dev->hostdata);
-	cmd->result = result;
+	cmd->result = 0;
+	set_host_byte(cmd, host_byte);
+	if (host_byte == DID_OK) {
+		set_msg_byte(cmd, ent->message);
+		set_status_byte(cmd, ent->status);
+	}
 
 	if (ent->eh_done) {
 		complete(ent->eh_done);
@@ -944,12 +949,6 @@ static void esp_cmd_is_done(struct esp *esp, struct esp_cmd_entry *ent,
 	esp_maybe_execute_command(esp);
 }
 
-static unsigned int compose_result(unsigned int status, unsigned int message,
-				   unsigned int driver_code)
-{
-	return (status | (message << 8) | (driver_code << 16));
-}
-
 static void esp_event_queue_full(struct esp *esp, struct esp_cmd_entry *ent)
 {
 	struct scsi_device *dev = ent->cmd->device;
@@ -1244,7 +1243,7 @@ static int esp_finish_select(struct esp *esp)
 		 * all bets are off.
 		 */
 		esp_schedule_reset(esp);
-		esp_cmd_is_done(esp, ent, cmd, (DID_ERROR << 16));
+		esp_cmd_is_done(esp, ent, cmd, DID_ERROR);
 		return 0;
 	}
 
@@ -1289,7 +1288,7 @@ static int esp_finish_select(struct esp *esp)
 		esp->target[dev->id].flags |= ESP_TGT_CHECK_NEGO;
 
 		scsi_esp_cmd(esp, ESP_CMD_ESEL);
-		esp_cmd_is_done(esp, ent, cmd, (DID_BAD_TARGET << 16));
+		esp_cmd_is_done(esp, ent, cmd, DID_BAD_TARGET);
 		return 1;
 	}
 
@@ -1874,10 +1873,7 @@ static int esp_process_event(struct esp *esp)
 				ent->flags |= ESP_CMD_FLAG_AUTOSENSE;
 				esp_autosense(esp, ent);
 			} else {
-				esp_cmd_is_done(esp, ent, cmd,
-						compose_result(ent->status,
-							       ent->message,
-							       DID_OK));
+				esp_cmd_is_done(esp, ent, cmd, DID_OK);
 			}
 		} else if (ent->message == DISCONNECT) {
 			esp_log_disconnect("Disconnecting tgt[%d] tag[%x:%x]\n",
-- 
2.16.4

