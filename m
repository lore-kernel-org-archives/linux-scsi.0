From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 29/35] hpsa: when switching out of accel mode await only accel
	command completions
Date: Tue, 18 Feb 2014 13:57:37 -0600
Message-ID: <20140218195736.15787.53604.stgit@beardog.cce.hp.com>
References: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:57112 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaBRT7G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2014 14:59:06 -0500
Received: from g6t1525.atlanta.hp.com (g6t1525.atlanta.hp.com [15.193.200.68])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id 6F4881BEA
	for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2014 19:58:59 +0000 (UTC)
In-Reply-To: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: dab@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Don't wait for *all* commands to complete, only for accelerated mode
commands.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 3ed0142..41766c2 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -221,7 +221,7 @@ static inline void finish_cmd(struct CommandList *c);
 static void hpsa_wait_for_mode_change_ack(struct ctlr_info *h);
 #define BOARD_NOT_READY 0
 #define BOARD_READY 1
-static void hpsa_drain_commands(struct ctlr_info *h);
+static void hpsa_drain_accel_commands(struct ctlr_info *h);
 static void hpsa_flush_cache(struct ctlr_info *h);
 static int hpsa_scsi_ioaccel_queue_command(struct ctlr_info *h,
 	struct CommandList *c, u32 ioaccel_handle, u8 *cdb, int cdb_len,
@@ -6371,7 +6371,7 @@ static int hpsa_kickoff_rescan(struct ctlr_info *h)
 		scsi_block_requests(h->scsi_host);
 		for (i = 0; i < h->ndevices; i++)
 			h->dev[i]->offload_enabled = 0;
-		hpsa_drain_commands(h);
+		hpsa_drain_accel_commands(h);
 		/* Set 'accelerator path config change' bit */
 		dev_warn(&h->pdev->dev,
 			"Acknowledging event: 0x%08x (HP SSD Smart Path %s)\n",
@@ -7075,16 +7075,26 @@ clean_up:
 	kfree(h->blockFetchTable);
 }
 
-static void hpsa_drain_commands(struct ctlr_info *h)
+static int is_accelerated_cmd(struct CommandList *c)
 {
-	int cmds_out;
+	return c->cmd_type == CMD_IOACCEL1 || c->cmd_type == CMD_IOACCEL2;
+}
+
+static void hpsa_drain_accel_commands(struct ctlr_info *h)
+{
+	struct CommandList *c = NULL;
 	unsigned long flags;
+	int accel_cmds_out;
 
 	do { /* wait for all outstanding commands to drain out */
+		accel_cmds_out = 0;
 		spin_lock_irqsave(&h->lock, flags);
-		cmds_out = h->commands_outstanding;
+		list_for_each_entry(c, &h->cmpQ, list)
+			accel_cmds_out += is_accelerated_cmd(c);
+		list_for_each_entry(c, &h->reqQ, list)
+			accel_cmds_out += is_accelerated_cmd(c);
 		spin_unlock_irqrestore(&h->lock, flags);
-		if (cmds_out <= 0)
+		if (accel_cmds_out <= 0)
 			break;
 		msleep(100);
 	} while (1);

