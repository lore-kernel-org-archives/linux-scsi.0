Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70E3BC433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 17:48:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D8A46140D
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 17:48:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244920AbhDURtY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 13:49:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:52334 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245068AbhDURtN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Apr 2021 13:49:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 050ABB2F5;
        Wed, 21 Apr 2021 17:48:02 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 29/42] mesh: translate message to host byte status
Date:   Wed, 21 Apr 2021 19:47:36 +0200
Message-Id: <20210421174749.11221-30-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210421174749.11221-1-hare@suse.de>
References: <20210421174749.11221-1-hare@suse.de>
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
 drivers/scsi/mesh.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
index 6052a47b03dc..5be587dd75ea 100644
--- a/drivers/scsi/mesh.c
+++ b/drivers/scsi/mesh.c
@@ -597,8 +597,9 @@ static void mesh_done(struct mesh_state *ms, int start_next)
 	if (cmd) {
 		set_host_byte(cmd, ms->stat);
 		set_status_byte(cmd, cmd->SCp.Status);
-		if (ms->stat == DID_OK)
-			set_msg_byte(cmd, cmd->SCp.Message);
+		if (get_host_byte(cmd) == DID_OK &&
+		    cmd->SCp.Message != COMMAND_COMPLETE)
+			translate_msg_byte(cmd, cmd->SCp.Message);
 		if (DEBUG_TARGET(cmd)) {
 			printk(KERN_DEBUG "mesh_done: result = %x, data_ptr=%d, buflen=%d\n",
 			       scsi_get_compat_result(cmd), ms->data_ptr, scsi_bufflen(cmd));
-- 
2.29.2

