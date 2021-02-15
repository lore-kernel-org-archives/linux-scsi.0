Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 558AEC433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Feb 2021 22:28:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 168AA64DF4
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Feb 2021 22:28:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbhBOW2R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Feb 2021 17:28:17 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:58784 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbhBOW2Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Feb 2021 17:28:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613428097; x=1644964097;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bPEeeX3iM1XATxCG1SFWJDkf4Of310g6wnHUTObj1ds=;
  b=SB//lVityRsDMBlFCU/ybneJd5ZzmZHAjSHqvuYjtnDaRKoesUaUN8SD
   l1G8pzocNORYXBe3vAc05p78caDbK5nrIrwtyHQUYgCSb3TGHuOyS4kxB
   OdR1JccnqQNpDAmhCFKVIEFnzPRAtn6n/xNzbl2GTmLDuWb8p7U8hzZBs
   0iCRko0aPCVcgalJGNoxNPLGOL4moyvyCd/eyUNpjiEcJHNvAz9U+taD5
   TBvOh9pwglmSvohBwj5rtHk2hF6eO4eqiuYAJdgzP2egf8cLIydD2Is/e
   2LbiiUalAG+4mBhDYRytWoBoNqekEFE1SGtwvBkIfv7vRQtT/0ZHkmXvL
   g==;
IronPort-SDR: YKLH9oZooAXlHE1S0DzR0PhRTMq8akRKdyAD3M3C+CqinlHYRr3QMJkph/f6L2eLtNMEvTMvtV
 7UsDaN664167m+ASiRLwUTX5/A1BDlkc4JcNUpOhNPyYShOBw0QwpvyxSChf3KdEErGO50qpFg
 4d+QXl3Alidg7uVXPS8VjzYQPRJUXVEItBnKd0LOapKQ7mjJlxFRcPPAsPdry4nvCMfwUXlkZR
 1IIp/buHJePqEZD7NH053DjIpP6KxqIhuAeCQfkTsDAJ2Gt6aXeihAKxlqweZewLQSWULrBCtG
 odk=
X-IronPort-AV: E=Sophos;i="5.81,181,1610434800"; 
   d="scan'208";a="109288926"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Feb 2021 15:26:59 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 15 Feb 2021 15:26:58 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 15 Feb 2021 15:26:57 -0700
Subject: [PATCH] hpsa: correct dev cmds outstanding for retried cmds
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Mon, 15 Feb 2021 16:26:57 -0600
Message-ID: <161342801747.29388.13045495968308188518.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prevent incrementing device->commands_outstanding for
ioaccel command retries that are driver initiated.
If the command goes through the retry path,
the device->commands_outstanding counter has already
accounted for the number of commands outstanding to the device.
Only commands going through function hpsa_cmd_resolve_events
decrement this counter.
 * ioaccel commands go to either HBA disks or to logical volumes
   comprised of SSDs.

The extra increment is causing device resets to hang.
 * Resets wait for all device outstanding commands to complete
   before returning.

Replace unused field abort_pending with retry_pending.

This is a maintenance driver so these changes have the
least impact/risk.

Tested-by: Joe Szczypek <jszczype@redhat.com>

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/hpsa.c     |   51 +++++++++++++++++++++++++++++++++++++++++------
 drivers/scsi/hpsa_cmd.h |    2 +-
 2 files changed, 45 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 337d3aa91945..38369766511c 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1151,7 +1151,10 @@ static void __enqueue_cmd_and_start_io(struct ctlr_info *h,
 {
 	dial_down_lockup_detection_during_fw_flash(h, c);
 	atomic_inc(&h->commands_outstanding);
-	if (c->device)
+	/*
+	 * Check to see if the command is being retried.
+	 */
+	if (c->device && !c->retry_pending)
 		atomic_inc(&c->device->commands_outstanding);
 
 	reply_queue = h->reply_map[raw_smp_processor_id()];
@@ -5567,7 +5570,8 @@ static inline void hpsa_cmd_partial_init(struct ctlr_info *h, int index,
 }
 
 static int hpsa_ioaccel_submit(struct ctlr_info *h,
-		struct CommandList *c, struct scsi_cmnd *cmd)
+		struct CommandList *c, struct scsi_cmnd *cmd,
+		bool retry)
 {
 	struct hpsa_scsi_dev_t *dev = cmd->device->hostdata;
 	int rc = IO_ACCEL_INELIGIBLE;
@@ -5584,18 +5588,22 @@ static int hpsa_ioaccel_submit(struct ctlr_info *h,
 	cmd->host_scribble = (unsigned char *) c;
 
 	if (dev->offload_enabled) {
-		hpsa_cmd_init(h, c->cmdindex, c);
+		hpsa_cmd_init(h, c->cmdindex, c); /* Zeroes out all fields */
 		c->cmd_type = CMD_SCSI;
 		c->scsi_cmd = cmd;
 		c->device = dev;
+		if (retry) /* Resubmit but do not increment device->commands_outstanding. */
+			c->retry_pending = true;
 		rc = hpsa_scsi_ioaccel_raid_map(h, c);
 		if (rc < 0)     /* scsi_dma_map failed. */
 			rc = SCSI_MLQUEUE_HOST_BUSY;
 	} else if (dev->hba_ioaccel_enabled) {
-		hpsa_cmd_init(h, c->cmdindex, c);
+		hpsa_cmd_init(h, c->cmdindex, c); /* Zeroes out all fields */
 		c->cmd_type = CMD_SCSI;
 		c->scsi_cmd = cmd;
 		c->device = dev;
+		if (retry) /* Resubmit but do not increment device->commands_outstanding. */
+			c->retry_pending = true;
 		rc = hpsa_scsi_ioaccel_direct_map(h, c);
 		if (rc < 0)     /* scsi_dma_map failed. */
 			rc = SCSI_MLQUEUE_HOST_BUSY;
@@ -5628,7 +5636,8 @@ static void hpsa_command_resubmit_worker(struct work_struct *work)
 
 		if (c2->error_data.serv_response ==
 				IOACCEL2_STATUS_SR_TASK_COMP_SET_FULL) {
-			rc = hpsa_ioaccel_submit(h, c, cmd);
+			/* Resubmit with the retry_pending flag set. */
+			rc = hpsa_ioaccel_submit(h, c, cmd, true);
 			if (rc == 0)
 				return;
 			if (rc == SCSI_MLQUEUE_HOST_BUSY) {
@@ -5644,6 +5653,15 @@ static void hpsa_command_resubmit_worker(struct work_struct *work)
 		}
 	}
 	hpsa_cmd_partial_init(c->h, c->cmdindex, c);
+	/*
+	 * Here we have not come in though queue_command, so we
+	 * can set the retry_pending flag to true for a driver initiated
+	 * retry attempt (I.E. not a SML retry).
+	 * I.E. We are submitting a driver initiated retry.
+	 * Note: hpsa_ciss_submit does not zero out the command fields like
+	 *       ioaccel submit does.
+	 */
+	c->retry_pending = true;
 	if (hpsa_ciss_submit(c->h, c, cmd, dev)) {
 		/*
 		 * If we get here, it means dma mapping failed. Try
@@ -5706,11 +5724,16 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 	/*
 	 * Call alternate submit routine for I/O accelerated commands.
 	 * Retries always go down the normal I/O path.
+	 * Note: If cmd->retries is non-zero, then this is a SML
+	 *       initiated retry and not a driver initiated retry.
+	 *       This command has been obtained from cmd_tagged_alloc
+	 *       and is therefore a brand-new command.
 	 */
 	if (likely(cmd->retries == 0 &&
 			!blk_rq_is_passthrough(cmd->request) &&
 			h->acciopath_status)) {
-		rc = hpsa_ioaccel_submit(h, c, cmd);
+		/* Submit with the retry_pending flag unset. */
+		rc = hpsa_ioaccel_submit(h, c, cmd, false);
 		if (rc == 0)
 			return 0;
 		if (rc == SCSI_MLQUEUE_HOST_BUSY) {
@@ -6105,6 +6128,7 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
  * at init, and managed by cmd_tagged_alloc() and cmd_tagged_free() using the
  * block request tag as an index into a table of entries.  cmd_tagged_free() is
  * the complement, although cmd_free() may be called instead.
+ * This function is only called for new requests from queue_command.
  */
 static struct CommandList *cmd_tagged_alloc(struct ctlr_info *h,
 					    struct scsi_cmnd *scmd)
@@ -6139,8 +6163,14 @@ static struct CommandList *cmd_tagged_alloc(struct ctlr_info *h,
 	}
 
 	atomic_inc(&c->refcount);
-
 	hpsa_cmd_partial_init(h, idx, c);
+
+	/*
+	 * This is a new command obtained from queue_command so
+	 * there have not been any driver initiated retry attempts.
+	 */
+	c->retry_pending = false;
+
 	return c;
 }
 
@@ -6208,6 +6238,13 @@ static struct CommandList *cmd_alloc(struct ctlr_info *h)
 	}
 	hpsa_cmd_partial_init(h, i, c);
 	c->device = NULL;
+
+	/*
+	 * cmd_alloc is for "internal" commands and they are never
+	 * retried.
+	 */
+	c->retry_pending = false;
+
 	return c;
 }
 
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index 46df2e3ff89b..d126bb877250 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -448,7 +448,7 @@ struct CommandList {
 	 */
 	struct hpsa_scsi_dev_t *phys_disk;
 
-	int abort_pending;
+	bool retry_pending;
 	struct hpsa_scsi_dev_t *device;
 	atomic_t refcount; /* Must be last to avoid memset in hpsa_cmd_init() */
 } __aligned(COMMANDLIST_ALIGNMENT);

