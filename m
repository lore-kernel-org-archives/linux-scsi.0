Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E85CC43461
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 17:48:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A6A16140D
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 17:48:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238743AbhDURtT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 13:49:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:52322 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245064AbhDURtN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Apr 2021 13:49:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BC42FB1EF;
        Wed, 21 Apr 2021 17:48:01 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 15/42] NCR5380: use SCSI result accessors
Date:   Wed, 21 Apr 2021 19:47:22 +0200
Message-Id: <20210421174749.11221-16-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210421174749.11221-1-hare@suse.de>
References: <20210421174749.11221-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use accessors to set the SCSI result.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/NCR5380.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index d7594b794d3c..855edda9db41 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -538,7 +538,7 @@ static void complete_cmd(struct Scsi_Host *instance,
 
 	if (hostdata->sensing == cmd) {
 		/* Autosense processing ends here */
-		if (status_byte(cmd->result) != GOOD) {
+		if (get_status_byte(cmd) != SAM_STAT_GOOD) {
 			scsi_eh_restore_cmnd(cmd, &hostdata->ses);
 		} else {
 			scsi_eh_restore_cmnd(cmd, &hostdata->ses);
@@ -567,18 +567,19 @@ static int NCR5380_queue_command(struct Scsi_Host *instance,
 	struct NCR5380_cmd *ncmd = scsi_cmd_priv(cmd);
 	unsigned long flags;
 
+	set_host_byte(cmd, DID_OK);
+	set_status_byte(cmd, SAM_STAT_GOOD);
 #if (NDEBUG & NDEBUG_NO_WRITE)
 	switch (cmd->cmnd[0]) {
 	case WRITE_6:
 	case WRITE_10:
 		shost_printk(KERN_DEBUG, instance, "WRITE attempted with NDEBUG_NO_WRITE set\n");
-		cmd->result = (DID_ERROR << 16);
+		set_host_byte(cmd, DID_ERROR);
 		cmd->scsi_done(cmd);
 		return 0;
 	}
 #endif /* (NDEBUG & NDEBUG_NO_WRITE) */
 
-	cmd->result = 0;
 
 	spin_lock_irqsave(&hostdata->lock, flags);
 
@@ -1154,7 +1155,7 @@ static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
 		if (!hostdata->selecting)
 			return false;
 
-		cmd->result = DID_BAD_TARGET << 16;
+		set_host_byte(cmd, DID_BAD_TARGET);
 		complete_cmd(instance, cmd);
 		dsprintk(NDEBUG_SELECTION, instance,
 			"target did not respond within 250ms\n");
@@ -1203,7 +1204,7 @@ static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
 	NCR5380_transfer_pio(instance, &phase, &len, &data, 0);
 	if (len) {
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-		cmd->result = DID_ERROR << 16;
+		set_host_byte(cmd, DID_ERROR);
 		complete_cmd(instance, cmd);
 		dsprintk(NDEBUG_SELECTION, instance, "IDENTIFY message transfer failed\n");
 		ret = false;
@@ -1743,7 +1744,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				shost_printk(KERN_DEBUG, instance, "NDEBUG_NO_DATAOUT set, attempted DATAOUT aborted\n");
 				sink = 1;
 				do_abort(instance, 0);
-				cmd->result = DID_ERROR << 16;
+				set_host_byte(cmd, DID_ERROR);
 				complete_cmd(instance, cmd);
 				hostdata->connected = NULL;
 				hostdata->busy[scmd_id(cmd)] &= ~(1 << cmd->device->lun);
@@ -1826,9 +1827,8 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 					hostdata->connected = NULL;
 					hostdata->busy[scmd_id(cmd)] &= ~(1 << cmd->device->lun);
 
-					cmd->result &= ~0xffff;
-					cmd->result |= cmd->SCp.Status;
-					cmd->result |= cmd->SCp.Message << 8;
+					set_msg_byte(cmd, cmd->SCp.Message);
+					set_status_byte(cmd, cmd->SCp.Status);
 
 					set_resid_from_SCp(cmd);
 
@@ -1980,7 +1980,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				if (msgout == ABORT) {
 					hostdata->connected = NULL;
 					hostdata->busy[scmd_id(cmd)] &= ~(1 << cmd->device->lun);
-					cmd->result = DID_ERROR << 16;
+					set_host_byte(cmd, DID_ERROR);
 					complete_cmd(instance, cmd);
 					return;
 				}
@@ -2261,7 +2261,7 @@ static int NCR5380_abort(struct scsi_cmnd *cmd)
 	if (list_del_cmd(&hostdata->unissued, cmd)) {
 		dsprintk(NDEBUG_ABORT, instance,
 		         "abort: removed %p from issue queue\n", cmd);
-		cmd->result = DID_ABORT << 16;
+		set_host_byte(cmd, DID_ABORT);
 		cmd->scsi_done(cmd); /* No tag or busy flag to worry about */
 		goto out;
 	}
@@ -2270,7 +2270,7 @@ static int NCR5380_abort(struct scsi_cmnd *cmd)
 		dsprintk(NDEBUG_ABORT, instance,
 		         "abort: cmd %p == selecting\n", cmd);
 		hostdata->selecting = NULL;
-		cmd->result = DID_ABORT << 16;
+		set_host_byte(cmd, DID_ABORT);
 		complete_cmd(instance, cmd);
 		goto out;
 	}
@@ -2341,7 +2341,7 @@ static void bus_reset_cleanup(struct Scsi_Host *instance)
 	 */
 
 	if (hostdata->selecting) {
-		hostdata->selecting->result = DID_RESET << 16;
+		set_host_byte(hostdata->selecting, DID_RESET);
 		complete_cmd(instance, hostdata->selecting);
 		hostdata->selecting = NULL;
 	}
@@ -2399,7 +2399,7 @@ static int NCR5380_host_reset(struct scsi_cmnd *cmd)
 	list_for_each_entry(ncmd, &hostdata->unissued, list) {
 		struct scsi_cmnd *scmd = NCR5380_to_scmd(ncmd);
 
-		scmd->result = DID_RESET << 16;
+		set_host_byte(scmd, DID_RESET);
 		scmd->scsi_done(scmd);
 	}
 	INIT_LIST_HEAD(&hostdata->unissued);
-- 
2.29.2

