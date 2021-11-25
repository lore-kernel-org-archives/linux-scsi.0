Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DF72C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Nov 2021 15:13:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355978AbhKYPQU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Nov 2021 10:16:20 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:47100 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353929AbhKYPOO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Nov 2021 10:14:14 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 1BE4B1FD3E;
        Thu, 25 Nov 2021 15:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637853062; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e+le586X5UJmEEMoltrl4TYyfy3edyUnMK+z50Je6dE=;
        b=NM4vQxyGWe+TyMZ3Fk0+HzYbfvLq2eWdmeNBFy48Iwyo62rYplGvEYZCs3LkFDWBtewbLd
        cWlchUJFYZiRqNB9q/qXYAsryO6ps0b42XYdYcqsN8tqZxfIW8zBW/BxpeYqqnwRL/JuHh
        ZlS4/P1kLritcM2pU1FQAOlaQL1POTs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637853062;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e+le586X5UJmEEMoltrl4TYyfy3edyUnMK+z50Je6dE=;
        b=T2zZCA/RWcJdx5kBdCupibSgTBnFdw+CQwMz/K/5ZOb7WpAQvc6ffapW9rpUCyNgXkC4kt
        EVbYzmn+me4wwpBA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 12354A3B8F;
        Thu, 25 Nov 2021 15:11:02 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id AC6C551919F8; Thu, 25 Nov 2021 16:11:01 +0100 (CET)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Bart van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/15] hpsa: use scsi_host_busy_iter() to traverse outstanding commands
Date:   Thu, 25 Nov 2021 16:10:39 +0100
Message-Id: <20211125151048.103910-7-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211125151048.103910-1-hare@suse.de>
References: <20211125151048.103910-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace all hand-crafted command iterations with
scsi_host_busy_iter() calls.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/hpsa.c | 117 +++++++++++++++++++++++++-------------------
 1 file changed, 67 insertions(+), 50 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c5f55b56fd2f..23babe177f5d 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1824,30 +1824,26 @@ static int hpsa_add_device(struct ctlr_info *h, struct hpsa_scsi_dev_t *device)
 	return rc;
 }
 
-static int hpsa_find_outstanding_commands_for_dev(struct ctlr_info *h,
-						struct hpsa_scsi_dev_t *dev)
-{
-	int i;
-	int count = 0;
-
-	for (i = 0; i < h->nr_cmds; i++) {
-		struct CommandList *c = h->cmd_pool + i;
-		int refcount = atomic_inc_return(&c->refcount);
-
-		if (refcount > 1 && hpsa_cmd_dev_match(h, c, dev,
-				dev->scsi3addr)) {
-			unsigned long flags;
+struct hpsa_command_iter_data {
+	struct ctlr_info *h;
+	struct hpsa_scsi_dev_t *dev;
+	unsigned char *scsi3addr;
+	int count;
+};
 
-			spin_lock_irqsave(&h->lock, flags);	/* Implied MB */
-			if (!hpsa_is_cmd_idle(c))
-				++count;
-			spin_unlock_irqrestore(&h->lock, flags);
-		}
+static bool hpsa_find_outstanding_commands_iter(struct scsi_cmnd *sc,
+						void *data, bool reserved)
+{
+	struct hpsa_command_iter_data *iter_data = data;
+	struct ctlr_info *h = iter_data->h;
+	struct hpsa_scsi_dev_t *dev = iter_data->dev;
+	struct CommandList *c = h->cmd_pool + scsi_cmd_to_rq(sc)->tag;
 
-		cmd_free(h, c);
+	if (hpsa_cmd_dev_match(h, c, dev, dev->scsi3addr)) {
+		iter_data->count++;
+		return false;
 	}
-
-	return count;
+	return true;
 }
 
 #define NUM_WAIT 20
@@ -1857,13 +1853,20 @@ static void hpsa_wait_for_outstanding_commands_for_dev(struct ctlr_info *h,
 	int cmds = 0;
 	int waits = 0;
 	int num_wait = NUM_WAIT;
+	struct hpsa_command_iter_data iter_data = {
+		.h = h,
+		.dev = device,
+	};
 
 	if (device->external)
 		num_wait = HPSA_EH_PTRAID_TIMEOUT;
 
 	while (1) {
-		cmds = hpsa_find_outstanding_commands_for_dev(h, device);
-		if (cmds == 0)
+		iter_data.count = 0;
+		scsi_host_busy_iter(h->scsi_host,
+				    hpsa_find_outstanding_commands_iter,
+				    &iter_data);
+		if (iter_data.count == 0)
 			break;
 		if (++waits > num_wait)
 			break;
@@ -8180,27 +8183,34 @@ static void hpsa_undo_allocations_after_kdump_soft_reset(struct ctlr_info *h)
 	kfree(h);				/* init_one 1 */
 }
 
+static bool fail_all_outstanding_cmds_iter(struct scsi_cmnd *sc, void *data,
+					   bool reserved)
+{
+	struct hpsa_command_iter_data *iter_data = data;
+	struct ctlr_info *h = iter_data->h;
+	struct CommandList *c = h->cmd_pool + scsi_cmd_to_rq(sc)->tag;
+
+	c->err_info->CommandStatus = CMD_CTLR_LOCKUP;
+	finish_cmd(c);
+	atomic_dec(&h->commands_outstanding);
+	iter_data->count++;
+
+	return true;
+}
+
 /* Called when controller lockup detected. */
 static void fail_all_outstanding_cmds(struct ctlr_info *h)
 {
-	int i, refcount;
-	struct CommandList *c;
-	int failcount = 0;
+	struct hpsa_command_iter_data iter_data = {
+		.h = h,
+		.count = 0,
+	};
 
 	flush_workqueue(h->resubmit_wq); /* ensure all cmds are fully built */
-	for (i = 0; i < h->nr_cmds; i++) {
-		c = h->cmd_pool + i;
-		refcount = atomic_inc_return(&c->refcount);
-		if (refcount > 1) {
-			c->err_info->CommandStatus = CMD_CTLR_LOCKUP;
-			finish_cmd(c);
-			atomic_dec(&h->commands_outstanding);
-			failcount++;
-		}
-		cmd_free(h, c);
-	}
+	scsi_host_busy_iter(h->scsi_host,
+			    fail_all_outstanding_cmds_iter, &iter_data);
 	dev_warn(&h->pdev->dev,
-		"failed %d commands in fail_all\n", failcount);
+		"failed %d commands in fail_all\n", iter_data.count);
 }
 
 static void set_lockup_detected_for_all_cpus(struct ctlr_info *h, u32 value)
@@ -9499,22 +9509,29 @@ static int is_accelerated_cmd(struct CommandList *c)
 	return c->cmd_type == CMD_IOACCEL1 || c->cmd_type == CMD_IOACCEL2;
 }
 
+static bool hpsa_drain_accel_commands_iter(struct scsi_cmnd *sc, void *data,
+					   bool reserved)
+{
+	struct hpsa_command_iter_data *iter_data = data;
+	struct ctlr_info *h = iter_data->h;
+	struct CommandList *c = h->cmd_pool + scsi_cmd_to_rq(sc)->tag;
+
+	iter_data->count += is_accelerated_cmd(c);
+	return true;
+}
+
 static void hpsa_drain_accel_commands(struct ctlr_info *h)
 {
-	struct CommandList *c = NULL;
-	int i, accel_cmds_out;
-	int refcount;
+	struct hpsa_command_iter_data iter_data = {
+		.h = h,
+	};
 
 	do { /* wait for all outstanding ioaccel commands to drain out */
-		accel_cmds_out = 0;
-		for (i = 0; i < h->nr_cmds; i++) {
-			c = h->cmd_pool + i;
-			refcount = atomic_inc_return(&c->refcount);
-			if (refcount > 1) /* Command is allocated */
-				accel_cmds_out += is_accelerated_cmd(c);
-			cmd_free(h, c);
-		}
-		if (accel_cmds_out <= 0)
+		iter_data.count = 0;
+		scsi_host_busy_iter(h->scsi_host,
+				    hpsa_drain_accel_commands_iter,
+				    &iter_data);
+		if (iter_data.count <= 0)
 			break;
 		msleep(100);
 	} while (1);
-- 
2.29.2

