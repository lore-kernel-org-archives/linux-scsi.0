From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 29/48] hpsa: fix race between abort handler and main i/o
 path
Date: Fri, 23 Jan 2015 16:43:35 -0600
Message-ID: <20150123224335.14919.69164.stgit@brunhilda>
References: <20150123224020.14919.29458.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:49083 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbbAWWoa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2015 17:44:30 -0500
Received: from g2t2352.austin.hp.com (g2t2352.austin.hp.com [15.217.128.51])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id D26421167
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2015 22:44:29 +0000 (UTC)
In-Reply-To: <20150123224020.14919.29458.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Webb Scales <webbnh@hp.com>

This means changing the allocator to reference count commands.
The reference count is now the authoritative indicator of whether a
command is allocated or not.  The h->cmd_pool_bits bitmap is now
only a heuristic hint to speed up the allocation process, it is no
longer the authoritative record of allocated commands.

Since we changed the command allocator to use reference counting
as the authoritative indicator of whether a command is allocated,
fail_all_outstanding_cmds needs to use the reference count not
h->cmd_pool_bits for this purpose.

Fix hpsa_drain_accel_commands to use the reference count as the
authoritative indicator of whether a command is allocated instead of
the h->cmd_pool_bits bitmap.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c     |  109 +++++++++++++++++++++++++++--------------------
 drivers/scsi/hpsa.h     |    2 +
 drivers/scsi/hpsa_cmd.h |    1 
 3 files changed, 65 insertions(+), 47 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 60f5734..c95a20c 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4552,6 +4552,7 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 	char msg[256];		/* For debug messaging. */
 	int ml = 0;
 	__le32 tagupper, taglower;
+	int refcount;
 
 	/* Find the controller of the command to be aborted */
 	h = sdev_to_hba(sc->device);
@@ -4580,9 +4581,13 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 	/* Get SCSI command to be aborted */
 	abort = (struct CommandList *) sc->host_scribble;
 	if (abort == NULL) {
-		dev_err(&h->pdev->dev, "%s FAILED, Command to abort is NULL.\n",
-				msg);
-		return FAILED;
+		/* This can happen if the command already completed. */
+		return SUCCESS;
+	}
+	refcount = atomic_inc_return(&abort->refcount);
+	if (refcount == 1) { /* Command is done already. */
+		cmd_free(h, abort);
+		return SUCCESS;
 	}
 	hpsa_get_tag(h, abort, &taglower, &tagupper);
 	ml += sprintf(msg+ml, "Tag:0x%08x:%08x ", tagupper, taglower);
@@ -4604,6 +4609,7 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 		dev_warn(&h->pdev->dev, "FAILED abort on device C%d:B%d:T%d:L%d\n",
 			h->scsi_host->host_no,
 			dev->bus, dev->target, dev->lun);
+		cmd_free(h, abort);
 		return FAILED;
 	}
 	dev_info(&h->pdev->dev, "%s REQUEST SUCCEEDED.\n", msg);
@@ -4615,32 +4621,35 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 	 */
 #define ABORT_COMPLETE_WAIT_SECS 30
 	for (i = 0; i < ABORT_COMPLETE_WAIT_SECS * 10; i++) {
-		if (test_bit(abort->cmdindex & (BITS_PER_LONG - 1),
-				h->cmd_pool_bits +
-				(abort->cmdindex / BITS_PER_LONG)))
-			msleep(100);
-		else
+		refcount = atomic_read(&abort->refcount);
+		if (refcount < 2) {
+			cmd_free(h, abort);
 			return SUCCESS;
+		} else {
+			msleep(100);
+		}
 	}
 	dev_warn(&h->pdev->dev, "%s FAILED. Aborted command has not completed after %d seconds.\n",
 		msg, ABORT_COMPLETE_WAIT_SECS);
+	cmd_free(h, abort);
 	return FAILED;
 }
 
-
 /*
  * For operations that cannot sleep, a command block is allocated at init,
  * and managed by cmd_alloc() and cmd_free() using a simple bitmap to track
  * which ones are free or in use.  Lock must be held when calling this.
  * cmd_free() is the complement.
  */
+
 static struct CommandList *cmd_alloc(struct ctlr_info *h)
 {
 	struct CommandList *c;
 	int i;
 	union u64bit temp64;
 	dma_addr_t cmd_dma_handle, err_dma_handle;
-	int loopcount;
+	int refcount;
+	unsigned long offset = 0;
 
 	/* There is some *extremely* small but non-zero chance that that
 	 * multiple threads could get in here, and one thread could
@@ -4653,23 +4662,27 @@ static struct CommandList *cmd_alloc(struct ctlr_info *h)
 	 * infrequently as to be indistinguishable from never.
 	 */
 
-	loopcount = 0;
-	do {
-		i = find_first_zero_bit(h->cmd_pool_bits, h->nr_cmds);
-		if (i == h->nr_cmds)
-			i = 0;
-		loopcount++;
-	} while (test_and_set_bit(i & (BITS_PER_LONG - 1),
-		  h->cmd_pool_bits + (i / BITS_PER_LONG)) != 0 &&
-		loopcount < 10);
-
-	/* Thread got starved?  We do not expect this to ever happen. */
-	if (loopcount >= 10)
-		return NULL;
-
-	c = h->cmd_pool + i;
-	memset(c, 0, sizeof(*c));
-	c->Header.tag = cpu_to_le64((u64) i << DIRECT_LOOKUP_SHIFT);
+	for (;;) {
+		i = find_next_zero_bit(h->cmd_pool_bits, h->nr_cmds, offset);
+		if (unlikely(i == h->nr_cmds)) {
+			offset = 0;
+			continue;
+		}
+		c = h->cmd_pool + i;
+		refcount = atomic_inc_return(&c->refcount);
+		if (unlikely(refcount > 1)) {
+			cmd_free(h, c); /* already in use */
+			offset = (i + 1) % h->nr_cmds;
+			continue;
+		}
+		set_bit(i & (BITS_PER_LONG - 1),
+			h->cmd_pool_bits + (i / BITS_PER_LONG));
+		break; /* it's ours now. */
+	}
+
+	/* Zero out all of commandlist except the last field, refcount */
+	memset(c, 0, offsetof(struct CommandList, refcount));
+	c->Header.tag = cpu_to_le64((u64) (i << DIRECT_LOOKUP_SHIFT));
 	cmd_dma_handle = h->cmd_pool_dhandle + i * sizeof(*c);
 	c->err_info = h->errinfo_pool + i;
 	memset(c->err_info, 0, sizeof(*c->err_info));
@@ -4680,8 +4693,8 @@ static struct CommandList *cmd_alloc(struct ctlr_info *h)
 
 	c->busaddr = (u32) cmd_dma_handle;
 	temp64.val = (u64) err_dma_handle;
-	c->ErrDesc.Addr = cpu_to_le64(err_dma_handle);
-	c->ErrDesc.Len = cpu_to_le32(sizeof(*c->err_info));
+	c->ErrDesc.Addr = cpu_to_le64((u64) err_dma_handle);
+	c->ErrDesc.Len = cpu_to_le32((u32) sizeof(*c->err_info));
 
 	c->h = h;
 	return c;
@@ -4689,11 +4702,13 @@ static struct CommandList *cmd_alloc(struct ctlr_info *h)
 
 static void cmd_free(struct ctlr_info *h, struct CommandList *c)
 {
-	int i;
+	if (atomic_dec_and_test(&c->refcount)) {
+		int i;
 
-	i = c - h->cmd_pool;
-	clear_bit(i & (BITS_PER_LONG - 1),
-		  h->cmd_pool_bits + (i / BITS_PER_LONG));
+		i = c - h->cmd_pool;
+		clear_bit(i & (BITS_PER_LONG - 1),
+			  h->cmd_pool_bits + (i / BITS_PER_LONG));
+	}
 }
 
 #ifdef CONFIG_COMPAT
@@ -6598,17 +6613,18 @@ static void hpsa_undo_allocations_after_kdump_soft_reset(struct ctlr_info *h)
 /* Called when controller lockup detected. */
 static void fail_all_outstanding_cmds(struct ctlr_info *h)
 {
-	int i;
-	struct CommandList *c = NULL;
+	int i, refcount;
+	struct CommandList *c;
 
 	flush_workqueue(h->resubmit_wq); /* ensure all cmds are fully built */
 	for (i = 0; i < h->nr_cmds; i++) {
-		if (!test_bit(i & (BITS_PER_LONG - 1),
-				h->cmd_pool_bits + (i / BITS_PER_LONG)))
-			continue;
 		c = h->cmd_pool + i;
-		c->err_info->CommandStatus = CMD_HARDWARE_ERR;
-		finish_cmd(c);
+		refcount = atomic_inc_return(&c->refcount);
+		if (refcount > 1) {
+			c->err_info->CommandStatus = CMD_HARDWARE_ERR;
+			finish_cmd(c);
+		}
+		cmd_free(h, c);
 	}
 }
 
@@ -6645,9 +6661,7 @@ static void controller_lockup_detected(struct ctlr_info *h)
 	dev_warn(&h->pdev->dev, "Controller lockup detected: 0x%08x\n",
 			lockup_detected);
 	pci_disable_device(h->pdev);
-	spin_lock_irqsave(&h->lock, flags);
 	fail_all_outstanding_cmds(h);
-	spin_unlock_irqrestore(&h->lock, flags);
 }
 
 static void detect_controller_lockup(struct ctlr_info *h)
@@ -7449,18 +7463,19 @@ static void hpsa_drain_accel_commands(struct ctlr_info *h)
 {
 	struct CommandList *c = NULL;
 	int i, accel_cmds_out;
+	int refcount;
 
 	do { /* wait for all outstanding ioaccel commands to drain out */
 		accel_cmds_out = 0;
 		for (i = 0; i < h->nr_cmds; i++) {
-			if (!test_bit(i & (BITS_PER_LONG - 1),
-					h->cmd_pool_bits + (i / BITS_PER_LONG)))
-				continue;
 			c = h->cmd_pool + i;
-			accel_cmds_out += is_accelerated_cmd(c);
+			refcount = atomic_inc_return(&c->refcount);
+			if (refcount > 1) /* Command is allocated */
+				accel_cmds_out += is_accelerated_cmd(c);
+			cmd_free(h, c);
 		}
 		if (accel_cmds_out <= 0)
-				break;
+			break;
 		msleep(100);
 	} while (1);
 }
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index d0fb854..679e4d2 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -309,6 +309,8 @@ struct offline_device_entry {
  */
 #define SA5_DOORBELL	0x20
 #define SA5_REQUEST_PORT_OFFSET	0x40
+#define SA5_REQUEST_PORT64_LO_OFFSET 0xC0
+#define SA5_REQUEST_PORT64_HI_OFFSET 0xC4
 #define SA5_REPLY_INTR_MASK_OFFSET	0x34
 #define SA5_REPLY_PORT_OFFSET		0x44
 #define SA5_INTR_STATUS		0x30
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index 4726dbb..071b64c 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -421,6 +421,7 @@ struct CommandList {
 	 * not used.
 	 */
 	struct hpsa_scsi_dev_t *phys_disk;
+	atomic_t refcount; /* Must be last to avoid memset in cmd_alloc */
 } __aligned(COMMANDLIST_ALIGNMENT);
 
 /* Max S/G elements in I/O accelerator command */

