Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95557C18E5B
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:31:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76E0220848
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:31:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727299AbgCJQax (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 12:30:53 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:11210 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726971AbgCJQaw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Mar 2020 12:30:52 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 82C6DB3997658ACE18F2;
        Wed, 11 Mar 2020 00:30:38 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Wed, 11 Mar 2020 00:30:28 +0800
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <hare@suse.de>,
        <ming.lei@redhat.com>, <bvanassche@acm.org>, <hch@infradead.org>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH RFC v2 13/24] hpsa: use blk_mq_tagset_busy_iter() to traverse outstanding commands
Date:   Wed, 11 Mar 2020 00:25:39 +0800
Message-ID: <1583857550-12049-14-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1583857550-12049-1-git-send-email-john.garry@huawei.com>
References: <1583857550-12049-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.com>

Replace all hand-crafted command iterations with
blk_mq_tagset_busy_iter().

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/hpsa.c | 117 +++++++++++++++++++++++++-------------------
 1 file changed, 67 insertions(+), 50 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c14dd4b6e598..64ec0b2c647a 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1807,30 +1807,26 @@ static int hpsa_add_device(struct ctlr_info *h, struct hpsa_scsi_dev_t *device)
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
+	struct CommandList *c = h->cmd_pool + sc->request->tag;
 
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
@@ -1840,13 +1836,20 @@ static void hpsa_wait_for_outstanding_commands_for_dev(struct ctlr_info *h,
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
+		scsi_host_tagset_busy_iter(h->scsi_host,
+					   hpsa_find_outstanding_commands_iter,
+					   &iter_data);
+		if (iter_data.count == 0)
 			break;
 		if (++waits > num_wait)
 			break;
@@ -8128,27 +8131,34 @@ static void hpsa_undo_allocations_after_kdump_soft_reset(struct ctlr_info *h)
 	kfree(h);				/* init_one 1 */
 }
 
+static bool fail_all_outstanding_cmds_iter(struct scsi_cmnd *sc, void *data,
+					   bool reserved)
+{
+	struct hpsa_command_iter_data *iter_data = data;
+	struct ctlr_info *h = iter_data->h;
+	struct CommandList *c = h->cmd_pool + sc->request->tag;
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
+	scsi_host_tagset_busy_iter(h->scsi_host,
+				   fail_all_outstanding_cmds_iter, &iter_data);
 	dev_warn(&h->pdev->dev,
-		"failed %d commands in fail_all\n", failcount);
+		"failed %d commands in fail_all\n", iter_data.count);
 }
 
 static void set_lockup_detected_for_all_cpus(struct ctlr_info *h, u32 value)
@@ -9434,22 +9444,29 @@ static int is_accelerated_cmd(struct CommandList *c)
 	return c->cmd_type == CMD_IOACCEL1 || c->cmd_type == CMD_IOACCEL2;
 }
 
+static bool hpsa_drain_accel_commands_iter(struct scsi_cmnd *sc, void *data,
+					   bool reserved)
+{
+	struct hpsa_command_iter_data *iter_data = data;
+	struct ctlr_info *h = iter_data->h;
+	struct CommandList *c = h->cmd_pool + sc->request->tag;
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
+		scsi_host_tagset_busy_iter(h->scsi_host,
+					   hpsa_drain_accel_commands_iter,
+					   &iter_data);
+		if (iter_data.count <= 0)
 			break;
 		msleep(100);
 	} while (1);
-- 
2.17.1

