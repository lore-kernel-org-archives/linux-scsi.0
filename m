Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2841C10F27
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:32:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 708CE222C3
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:32:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727299AbgCJQci (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 12:32:38 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:11213 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727236AbgCJQci (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Mar 2020 12:32:38 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 9C1F0ABDCE0AE73B9ADB;
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
Subject: [PATCH RFC v2 12/24] hpsa: use reserved commands
Date:   Wed, 11 Mar 2020 00:25:38 +0800
Message-ID: <1583857550-12049-13-git-send-email-john.garry@huawei.com>
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

Enable the use of reserved commands, and drop the hand-crafted
command allocation.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/hpsa.c | 147 ++++++++++++++------------------------------
 drivers/scsi/hpsa.h |   1 -
 2 files changed, 45 insertions(+), 103 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 703f824584fe..c14dd4b6e598 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -244,10 +244,6 @@ static struct hpsa_scsi_dev_t
 	*hpsa_find_device_by_sas_rphy(struct ctlr_info *h,
 		struct sas_rphy *rphy);
 
-#define SCSI_CMD_BUSY ((struct scsi_cmnd *)&hpsa_cmd_busy)
-static const struct scsi_cmnd hpsa_cmd_busy;
-#define SCSI_CMD_IDLE ((struct scsi_cmnd *)&hpsa_cmd_idle)
-static const struct scsi_cmnd hpsa_cmd_idle;
 static int number_of_controllers;
 
 static irqreturn_t do_hpsa_intr_intx(int irq, void *dev_id);
@@ -342,7 +338,7 @@ static inline struct ctlr_info *shost_to_hba(struct Scsi_Host *sh)
 
 static inline bool hpsa_is_cmd_idle(struct CommandList *c)
 {
-	return c->scsi_cmd == SCSI_CMD_IDLE;
+	return c->scsi_cmd == NULL;
 }
 
 /* extract sense key, asc, and ascq from sense data.  -1 means invalid. */
@@ -2445,7 +2441,12 @@ static void hpsa_cmd_resolve_events(struct ctlr_info *h,
 	 * this command has completed.  Then, check to see if the handler is
 	 * waiting for this command, and, if so, wake it.
 	 */
-	c->scsi_cmd = SCSI_CMD_IDLE;
+	if (c->scsi_cmd && c->cmd_type == CMD_IOCTL_PEND) {
+		struct scsi_cmnd *scmd = c->scsi_cmd;
+
+		scsi_put_reserved_cmd(scmd);
+	}
+	c->scsi_cmd = NULL;
 	mb();	/* Declare command idle before checking for pending events. */
 	if (dev) {
 		atomic_dec(&dev->commands_outstanding);
@@ -5502,7 +5503,6 @@ static void hpsa_cmd_init(struct ctlr_info *h, int index,
 	c->ErrDesc.Addr = cpu_to_le64((u64) err_dma_handle);
 	c->ErrDesc.Len = cpu_to_le32((u32) sizeof(*c->err_info));
 	c->h = h;
-	c->scsi_cmd = SCSI_CMD_IDLE;
 }
 
 static void hpsa_preinitialize_commands(struct ctlr_info *h)
@@ -5803,6 +5803,7 @@ static int hpsa_scsi_host_alloc(struct ctlr_info *h)
 	sh->max_lun = HPSA_MAX_LUN;
 	sh->max_id = HPSA_MAX_LUN;
 	sh->can_queue = h->nr_cmds - HPSA_NRESERVED_CMDS;
+	sh->nr_reserved_cmds = HPSA_NRESERVED_CMDS;
 	sh->cmd_per_lun = sh->can_queue;
 	sh->sg_tablesize = h->maxsgentries;
 	sh->transportt = hpsa_sas_transport_template;
@@ -5846,23 +5847,6 @@ static int hpsa_scsi_add_host(struct ctlr_info *h)
 	return 0;
 }
 
-/*
- * The block layer has already gone to the trouble of picking out a unique,
- * small-integer tag for this request.  We use an offset from that value as
- * an index to select our command block.  (The offset allows us to reserve the
- * low-numbered entries for our own uses.)
- */
-static int hpsa_get_cmd_index(struct scsi_cmnd *scmd)
-{
-	int idx = scmd->request->tag;
-
-	if (idx < 0)
-		return idx;
-
-	/* Offset to leave space for internal cmds. */
-	return idx += HPSA_NRESERVED_CMDS;
-}
-
 /*
  * Send a TEST_UNIT_READY command to the specified LUN using the specified
  * reply queue; returns zero if the unit is ready, and non-zero otherwise.
@@ -6019,7 +6003,7 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 	if (lockup_detected(h)) {
 		snprintf(msg, sizeof(msg),
 			 "cmd %d RESET FAILED, lockup detected",
-			 hpsa_get_cmd_index(scsicmd));
+			 scsicmd->request->tag);
 		hpsa_show_dev_msg(KERN_WARNING, h, dev, msg);
 		rc = FAILED;
 		goto return_reset_status;
@@ -6029,7 +6013,7 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 	if (detect_controller_lockup(h)) {
 		snprintf(msg, sizeof(msg),
 			 "cmd %d RESET FAILED, new lockup detected",
-			 hpsa_get_cmd_index(scsicmd));
+			  scsicmd->request->tag);
 		hpsa_show_dev_msg(KERN_WARNING, h, dev, msg);
 		rc = FAILED;
 		goto return_reset_status;
@@ -6091,12 +6075,12 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 static struct CommandList *cmd_tagged_alloc(struct ctlr_info *h,
 					    struct scsi_cmnd *scmd)
 {
-	int idx = hpsa_get_cmd_index(scmd);
+	int idx = scmd->request->tag;
 	struct CommandList *c = h->cmd_pool + idx;
 
-	if (idx < HPSA_NRESERVED_CMDS || idx >= h->nr_cmds) {
+	if (idx < 0 || idx >= h->nr_cmds) {
 		dev_err(&h->pdev->dev, "Bad block tag: %d not in [%d..%d]\n",
-			idx, HPSA_NRESERVED_CMDS, h->nr_cmds - 1);
+			idx, 0, h->nr_cmds - 1);
 		/* The index value comes from the block layer, so if it's out of
 		 * bounds, it's probably not our bug.
 		 */
@@ -6133,81 +6117,49 @@ static void cmd_tagged_free(struct ctlr_info *h, struct CommandList *c)
 	 * else to free it, because it is accessed by index.
 	 */
 	(void)atomic_dec(&c->refcount);
+	c->scsi_cmd = NULL;
 }
 
-/*
- * For operations that cannot sleep, a command block is allocated at init,
- * and managed by cmd_alloc() and cmd_free() using a simple bitmap to track
- * which ones are free or in use.  Lock must be held when calling this.
- * cmd_free() is the complement.
- * This function never gives up and returns NULL.  If it hangs,
- * another thread must call cmd_free() to free some tags.
- */
-
 static struct CommandList *cmd_alloc(struct ctlr_info *h)
 {
+	struct scsi_cmnd *scmd;
 	struct CommandList *c;
-	int refcount, i;
-	int offset = 0;
-
-	/*
-	 * There is some *extremely* small but non-zero chance that that
-	 * multiple threads could get in here, and one thread could
-	 * be scanning through the list of bits looking for a free
-	 * one, but the free ones are always behind him, and other
-	 * threads sneak in behind him and eat them before he can
-	 * get to them, so that while there is always a free one, a
-	 * very unlucky thread might be starved anyway, never able to
-	 * beat the other threads.  In reality, this happens so
-	 * infrequently as to be indistinguishable from never.
-	 *
-	 * Note that we start allocating commands before the SCSI host structure
-	 * is initialized.  Since the search starts at bit zero, this
-	 * all works, since we have at least one command structure available;
-	 * however, it means that the structures with the low indexes have to be
-	 * reserved for driver-initiated requests, while requests from the block
-	 * layer will use the higher indexes.
-	 */
+	int idx;
 
-	for (;;) {
-		i = find_next_zero_bit(h->cmd_pool_bits,
-					HPSA_NRESERVED_CMDS,
-					offset);
-		if (unlikely(i >= HPSA_NRESERVED_CMDS)) {
-			offset = 0;
-			continue;
-		}
-		c = h->cmd_pool + i;
-		refcount = atomic_inc_return(&c->refcount);
-		if (unlikely(refcount > 1)) {
-			cmd_free(h, c); /* already in use */
-			offset = (i + 1) % HPSA_NRESERVED_CMDS;
-			continue;
-		}
-		set_bit(i & (BITS_PER_LONG - 1),
-			h->cmd_pool_bits + (i / BITS_PER_LONG));
-		break; /* it's ours now. */
+	scmd = scsi_get_reserved_cmd(h->scsi_host);
+	if (!scmd) {
+		dev_warn(&h->pdev->dev, "failed to allocate reserved cmd\n");
+		return NULL;
+ 	}
+	idx = scmd->request->tag;
+	c = cmd_tagged_alloc(h, scmd);
+	if (!c) {
+		dev_warn(&h->pdev->dev, "failed to allocate reserved cmd %u\n",
+			 idx);
+		scsi_put_reserved_cmd(scmd);
+		return NULL;
 	}
-	hpsa_cmd_partial_init(h, i, c);
-	c->device = NULL;
-	return c;
+	hpsa_cmd_partial_init(h, idx, c);
+	c->scsi_cmd = scmd;
+ 	c->device = NULL;
+	dev_dbg(&h->pdev->dev, "using reserved cmd %u\n", idx);
+ 	return c;
 }
 
-/*
- * This is the complementary operation to cmd_alloc().  Note, however, in some
- * corner cases it may also be used to free blocks allocated by
- * cmd_tagged_alloc() in which case the ref-count decrement does the trick and
- * the clear-bit is harmless.
- */
 static void cmd_free(struct ctlr_info *h, struct CommandList *c)
 {
-	if (atomic_dec_and_test(&c->refcount)) {
-		int i;
-
-		i = c - h->cmd_pool;
-		clear_bit(i & (BITS_PER_LONG - 1),
-			  h->cmd_pool_bits + (i / BITS_PER_LONG));
+	struct scsi_cmnd *scmd = c->scsi_cmd;
+ 
+	if (!scmd) {
+		dev_warn(&h->pdev->dev, "freeing idle cmd\n");
+		return;
 	}
+	cmd_tagged_free(h, c);
+	if (c->cmd_type == CMD_IOCTL_PEND && scmd) {
+		dev_dbg(&h->pdev->dev, "returning reserved cmd %u\n",
+			scmd->request->tag);
+		scsi_put_reserved_cmd(scmd);
+ 	}
 }
 
 #ifdef CONFIG_COMPAT
@@ -6393,7 +6345,6 @@ static int hpsa_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 
 	/* Fill in the command type */
 	c->cmd_type = CMD_IOCTL_PEND;
-	c->scsi_cmd = SCSI_CMD_BUSY;
 	/* Fill in Command Header */
 	c->Header.ReplyQueue = 0; /* unused in simple mode */
 	if (iocommand.buf_size > 0) {	/* buffer to fill */
@@ -6525,7 +6476,6 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 	c = cmd_alloc(h);
 
 	c->cmd_type = CMD_IOCTL_PEND;
-	c->scsi_cmd = SCSI_CMD_BUSY;
 	c->Header.ReplyQueue = 0;
 	c->Header.SGList = (u8) sg_used;
 	c->Header.SGTotal = cpu_to_le16(sg_used);
@@ -6669,7 +6619,6 @@ static int fill_cmd(struct CommandList *c, u8 cmd, struct ctlr_info *h,
 	enum dma_data_direction dir = DMA_NONE;
 
 	c->cmd_type = CMD_IOCTL_PEND;
-	c->scsi_cmd = SCSI_CMD_BUSY;
 	c->Header.ReplyQueue = 0;
 	if (buff != NULL && size > 0) {
 		c->Header.SGList = 1;
@@ -7982,8 +7931,6 @@ static int hpsa_init_reset_devices(struct pci_dev *pdev, u32 board_id)
 
 static void hpsa_free_cmd_pool(struct ctlr_info *h)
 {
-	kfree(h->cmd_pool_bits);
-	h->cmd_pool_bits = NULL;
 	if (h->cmd_pool) {
 		dma_free_coherent(&h->pdev->dev,
 				h->nr_cmds * sizeof(struct CommandList),
@@ -8004,17 +7951,13 @@ static void hpsa_free_cmd_pool(struct ctlr_info *h)
 
 static int hpsa_alloc_cmd_pool(struct ctlr_info *h)
 {
-	h->cmd_pool_bits = kcalloc(DIV_ROUND_UP(h->nr_cmds, BITS_PER_LONG),
-				   sizeof(unsigned long),
-				   GFP_KERNEL);
 	h->cmd_pool = dma_alloc_coherent(&h->pdev->dev,
 		    h->nr_cmds * sizeof(*h->cmd_pool),
 		    &h->cmd_pool_dhandle, GFP_KERNEL);
 	h->errinfo_pool = dma_alloc_coherent(&h->pdev->dev,
 		    h->nr_cmds * sizeof(*h->errinfo_pool),
 		    &h->errinfo_pool_dhandle, GFP_KERNEL);
-	if ((h->cmd_pool_bits == NULL)
-	    || (h->cmd_pool == NULL)
+	if ((h->cmd_pool == NULL)
 	    || (h->errinfo_pool == NULL)) {
 		dev_err(&h->pdev->dev, "out of memory in %s", __func__);
 		goto clean_up;
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index f8c88fc7b80a..70addb024ebb 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -205,7 +205,6 @@ struct ctlr_info {
 	dma_addr_t		ioaccel2_cmd_pool_dhandle;
 	struct ErrorInfo 	*errinfo_pool;
 	dma_addr_t		errinfo_pool_dhandle;
-	unsigned long  		*cmd_pool_bits;
 	int			scan_finished;
 	u8			scan_waiting : 1;
 	spinlock_t		scan_lock;
-- 
2.17.1

