Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D07AAC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 08:31:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A05D4606A5
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 08:31:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235242AbhD0IcQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 04:32:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:49418 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235183AbhD0IcB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 04:32:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9633AB12C;
        Tue, 27 Apr 2021 08:31:06 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 26/40] mesh: translate message to host byte status
Date:   Tue, 27 Apr 2021 10:30:32 +0200
Message-Id: <20210427083046.31620-27-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210427083046.31620-1-hare@suse.de>
References: <20210427083046.31620-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of setting the message byte translate it to a host byte
status. As the error recovery would map it to DID_ERROR anyway
the translation doesn't change the SCSI error handling.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/mesh.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
index 0a9f4e44ab2c..78b72bcf58fe 100644
--- a/drivers/scsi/mesh.c
+++ b/drivers/scsi/mesh.c
@@ -595,9 +595,10 @@ static void mesh_done(struct mesh_state *ms, int start_next)
 	ms->current_req = NULL;
 	tp->current_req = NULL;
 	if (cmd) {
-		cmd->result = (ms->stat << 16) | cmd->SCp.Status;
+		set_host_byte(cmd, ms->stat);
+		set_status_byte(cmd, cmd->SCp.Status);
 		if (ms->stat == DID_OK)
-			cmd->result |= cmd->SCp.Message << 8;
+			scsi_msg_to_host_byte(cmd, cmd->SCp.Message);
 		if (DEBUG_TARGET(cmd)) {
 			printk(KERN_DEBUG "mesh_done: result = %x, data_ptr=%d, buflen=%d\n",
 			       cmd->result, ms->data_ptr, scsi_bufflen(cmd));
@@ -993,7 +994,7 @@ static void handle_reset(struct mesh_state *ms)
 	for (tgt = 0; tgt < 8; ++tgt) {
 		tp = &ms->tgts[tgt];
 		if ((cmd = tp->current_req) != NULL) {
-			cmd->result = DID_RESET << 16;
+			set_host_byte(cmd, DID_RESET);
 			tp->current_req = NULL;
 			mesh_completed(ms, cmd);
 		}
@@ -1003,7 +1004,7 @@ static void handle_reset(struct mesh_state *ms)
 	ms->current_req = NULL;
 	while ((cmd = ms->request_q) != NULL) {
 		ms->request_q = (struct scsi_cmnd *) cmd->host_scribble;
-		cmd->result = DID_RESET << 16;
+		set_host_byte(cmd, DID_RESET);
 		mesh_completed(ms, cmd);
 	}
 	ms->phase = idle;
-- 
2.29.2

