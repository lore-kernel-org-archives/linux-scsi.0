From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] hpsa: Convert SCSI LLD ->queuecommand() for host_lock less operation
Date: Mon, 31 Jan 2011 12:33:50 -0800
Message-ID: <1296506030-30442-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm9-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.67]:30168 "HELO
	nm9-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754083Ab1AaUdg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Jan 2011 15:33:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, Jeff Garzik <jeff@garzik.org>, John Hawley <warthog9@kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch first converts HPSA to run in struct Scsi_Host->host_lock'
less operation by removing DEF_SCSI_QCMD() and '_lck' suffix from the
hpsa_scsi_queue_command() I/O dispatcher.

Secondly in hpsa_scsi_queue_command() the struct ctlr_info *h->lock is
now held a single lock obtain/release cycle while struct CommandList
initialization is performed, and enqueued into HW.  This enqueuing
is done using a new h->lock unlocked __enqueue_cmd_and_start_io(),
wrapper and conversion of the the original enqueue_cmd_and_start_io()
to use this new code.

Reviewed-by: Jeff Garzik <jgarzik@redhat.com>
Reviewed-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/hpsa.c |   34 +++++++++++++++++++---------------
 1 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 12deffc..69e06bd 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -329,16 +329,25 @@ static void set_performant_mode(struct ctlr_info *h, struct CommandList *c)
 		c->busaddr |= 1 | (h->blockFetchTable[c->Header.SGList] << 1);
 }
 
-static void enqueue_cmd_and_start_io(struct ctlr_info *h,
+/*
+ * Must be called with struct ctlr_info *h->lock held w/ interrupts disabled
+ */
+static inline void __enqueue_cmd_and_start_io(struct ctlr_info *h,
 	struct CommandList *c)
 {
-	unsigned long flags;
-
 	set_performant_mode(h, c);
-	spin_lock_irqsave(&h->lock, flags);
 	addQ(&h->reqQ, c);
 	h->Qdepth++;
 	start_io(h);
+}
+
+static inline void enqueue_cmd_and_start_io(struct ctlr_info *h,
+	struct CommandList *c)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&h->lock, flags);
+	__enqueue_cmd_and_start_io(h, c);
 	spin_unlock_irqrestore(&h->lock, flags);
 }
 
@@ -1906,9 +1915,7 @@ sglist_finished:
 	return 0;
 }
 
-
-static int hpsa_scsi_queue_command_lck(struct scsi_cmnd *cmd,
-	void (*done)(struct scsi_cmnd *))
+static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 {
 	struct ctlr_info *h;
 	struct hpsa_scsi_dev_t *dev;
@@ -1921,7 +1928,7 @@ static int hpsa_scsi_queue_command_lck(struct scsi_cmnd *cmd,
 	dev = cmd->device->hostdata;
 	if (!dev) {
 		cmd->result = DID_NO_CONNECT << 16;
-		done(cmd);
+		cmd->scsi_done(cmd);
 		return 0;
 	}
 	memcpy(scsi3addr, dev->scsi3addr, sizeof(scsi3addr));
@@ -1929,16 +1936,13 @@ static int hpsa_scsi_queue_command_lck(struct scsi_cmnd *cmd,
 	/* Need a lock as this is being allocated from the pool */
 	spin_lock_irqsave(&h->lock, flags);
 	c = cmd_alloc(h);
-	spin_unlock_irqrestore(&h->lock, flags);
 	if (c == NULL) {			/* trouble... */
 		dev_err(&h->pdev->dev, "cmd_alloc returned NULL!\n");
+		spin_unlock_irqrestore(&h->lock, flags);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
 	/* Fill in the command list header */
-
-	cmd->scsi_done = done;    /* save this for use by completion code */
-
 	/* save c in case we have to abort it  */
 	cmd->host_scribble = (unsigned char *) c;
 
@@ -1994,15 +1998,15 @@ static int hpsa_scsi_queue_command_lck(struct scsi_cmnd *cmd,
 
 	if (hpsa_scatter_gather(h, c, cmd) < 0) { /* Fill SG list */
 		cmd_free(h, c);
+		spin_unlock_irqrestore(&h->lock, flags);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
-	enqueue_cmd_and_start_io(h, c);
+	__enqueue_cmd_and_start_io(h, c);
+	spin_unlock_irqrestore(&h->lock, flags);
 	/* the cmd'll come back via intr handler in complete_scsi_command()  */
 	return 0;
 }
 
-static DEF_SCSI_QCMD(hpsa_scsi_queue_command)
-
 static void hpsa_scan_start(struct Scsi_Host *sh)
 {
 	struct ctlr_info *h = shost_to_hba(sh);
-- 
1.7.4

