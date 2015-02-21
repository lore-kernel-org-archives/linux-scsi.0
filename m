From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 09/43] hpsa: factor out hpsa_init_cmd function
Date: Sat, 21 Feb 2015 16:18:20 -0600
Message-ID: <20150221221820.21954.5503.stgit@brunhilda>
References: <20150221221553.21954.32599.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:57229 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbbBUWTj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Feb 2015 17:19:39 -0500
Received: from g5t1626.atlanta.hp.com (g5t1626.atlanta.hp.com [15.192.137.9])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id 3FBA16051B
	for <linux-scsi@vger.kernel.org>; Sat, 21 Feb 2015 22:19:39 +0000 (UTC)
In-Reply-To: <20150221221553.21954.32599.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Stephen Cameron <stephenmcameron@gmail.com>

Factor out hpsa_cmd_init from cmd_alloc().  We also need
this for resubmitting commands down the default RAID path
when they have returned from the ioaccel paths with errors.

In particular, reinitialize the cmd_type and busaddr fields as these
will not be correct for submitting down the RAID stack path
after ioaccel command completion.

This saves time when submitting commands.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c     |   77 ++++++++++++++++++++++++++++++++---------------
 drivers/scsi/hpsa_cmd.h |    2 +
 2 files changed, 53 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index ac0f992..361937a 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4337,7 +4337,6 @@ static int hpsa_ciss_submit(struct ctlr_info *h,
 	/* Fill in the request block... */
 
 	c->Request.Timeout = 0;
-	memset(c->Request.CDB, 0, sizeof(c->Request.CDB));
 	BUG_ON(cmd->cmd_len > sizeof(c->Request.CDB));
 	c->Request.CDBLen = cmd->cmd_len;
 	memcpy(c->Request.CDB, cmd->cmnd, cmd->cmd_len);
@@ -4388,6 +4387,48 @@ static int hpsa_ciss_submit(struct ctlr_info *h,
 	return 0;
 }
 
+static void hpsa_cmd_init(struct ctlr_info *h, int index,
+				struct CommandList *c)
+{
+	dma_addr_t cmd_dma_handle, err_dma_handle;
+
+	/* Zero out all of commandlist except the last field, refcount */
+	memset(c, 0, offsetof(struct CommandList, refcount));
+	c->Header.tag = cpu_to_le64((u64) (index << DIRECT_LOOKUP_SHIFT));
+	cmd_dma_handle = h->cmd_pool_dhandle + index * sizeof(*c);
+	c->err_info = h->errinfo_pool + index;
+	memset(c->err_info, 0, sizeof(*c->err_info));
+	err_dma_handle = h->errinfo_pool_dhandle
+	    + index * sizeof(*c->err_info);
+	c->cmdindex = index;
+	c->busaddr = (u32) cmd_dma_handle;
+	c->ErrDesc.Addr = cpu_to_le64((u64) err_dma_handle);
+	c->ErrDesc.Len = cpu_to_le32((u32) sizeof(*c->err_info));
+	c->h = h;
+}
+
+static void hpsa_preinitialize_commands(struct ctlr_info *h)
+{
+	int i;
+
+	for (i = 0; i < h->nr_cmds; i++) {
+		struct CommandList *c = h->cmd_pool + i;
+
+		hpsa_cmd_init(h, i, c);
+		atomic_set(&c->refcount, 0);
+	}
+}
+
+static inline void hpsa_cmd_partial_init(struct ctlr_info *h, int index,
+				struct CommandList *c)
+{
+	dma_addr_t cmd_dma_handle = h->cmd_pool_dhandle + index * sizeof(*c);
+
+	memset(c->Request.CDB, 0, sizeof(c->Request.CDB));
+	memset(c->err_info, 0, sizeof(*c->err_info));
+	c->busaddr = (u32) cmd_dma_handle;
+}
+
 static void hpsa_command_resubmit_worker(struct work_struct *work)
 {
 	struct scsi_cmnd *cmd;
@@ -4402,6 +4443,7 @@ static void hpsa_command_resubmit_worker(struct work_struct *work)
 		cmd->scsi_done(cmd);
 		return;
 	}
+	hpsa_cmd_partial_init(c->h, c->cmdindex, c);
 	if (hpsa_ciss_submit(c->h, c, cmd, dev->scsi3addr)) {
 		/*
 		 * If we get here, it means dma mapping failed. Try
@@ -4458,10 +4500,11 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 		h->acciopath_status)) {
 
 		cmd->host_scribble = (unsigned char *) c;
-		c->cmd_type = CMD_SCSI;
-		c->scsi_cmd = cmd;
 
 		if (dev->offload_enabled) {
+			hpsa_cmd_init(h, c->cmdindex, c);
+			c->cmd_type = CMD_SCSI;
+			c->scsi_cmd = cmd;
 			rc = hpsa_scsi_ioaccel_raid_map(h, c);
 			if (rc == 0)
 				return 0; /* Sent on ioaccel path */
@@ -4470,6 +4513,9 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 				return SCSI_MLQUEUE_HOST_BUSY;
 			}
 		} else if (dev->ioaccel_handle) {
+			hpsa_cmd_init(h, c->cmdindex, c);
+			c->cmd_type = CMD_SCSI;
+			c->scsi_cmd = cmd;
 			rc = hpsa_scsi_ioaccel_direct_map(h, c);
 			if (rc == 0)
 				return 0; /* Sent on direct map path */
@@ -5077,10 +5123,7 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 static struct CommandList *cmd_alloc(struct ctlr_info *h)
 {
 	struct CommandList *c;
-	int i;
-	union u64bit temp64;
-	dma_addr_t cmd_dma_handle, err_dma_handle;
-	int refcount;
+	int refcount, i;
 	unsigned long offset;
 
 	/*
@@ -5114,24 +5157,7 @@ static struct CommandList *cmd_alloc(struct ctlr_info *h)
 		break; /* it's ours now. */
 	}
 	h->last_allocation = i; /* benignly racy */
-
-	/* Zero out all of commandlist except the last field, refcount */
-	memset(c, 0, offsetof(struct CommandList, refcount));
-	c->Header.tag = cpu_to_le64((u64) (i << DIRECT_LOOKUP_SHIFT));
-	cmd_dma_handle = h->cmd_pool_dhandle + i * sizeof(*c);
-	c->err_info = h->errinfo_pool + i;
-	memset(c->err_info, 0, sizeof(*c->err_info));
-	err_dma_handle = h->errinfo_pool_dhandle
-	    + i * sizeof(*c->err_info);
-
-	c->cmdindex = i;
-
-	c->busaddr = (u32) cmd_dma_handle;
-	temp64.val = (u64) err_dma_handle;
-	c->ErrDesc.Addr = cpu_to_le64((u64) err_dma_handle);
-	c->ErrDesc.Len = cpu_to_le32((u32) sizeof(*c->err_info));
-
-	c->h = h;
+	hpsa_cmd_partial_init(h, i, c);
 	return c;
 }
 
@@ -6850,6 +6876,7 @@ static int hpsa_alloc_cmd_pool(struct ctlr_info *h)
 		dev_err(&h->pdev->dev, "out of memory in %s", __func__);
 		goto clean_up;
 	}
+	hpsa_preinitialize_commands(h);
 	return 0;
 clean_up:
 	hpsa_free_cmd_pool(h);
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index f6ca5fa..0efb6f2b 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -438,7 +438,7 @@ struct CommandList {
 	 * not used.
 	 */
 	struct hpsa_scsi_dev_t *phys_disk;
-	atomic_t refcount; /* Must be last to avoid memset in cmd_alloc */
+	atomic_t refcount; /* Must be last to avoid memset in hpsa_cmd_init() */
 } __aligned(COMMANDLIST_ALIGNMENT);
 
 /* Max S/G elements in I/O accelerator command */

