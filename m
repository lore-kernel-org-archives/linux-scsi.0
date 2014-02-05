From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 02/17] megaraid: simplify internal command handling
Date: Wed, 05 Feb 2014 04:39:32 -0800
Message-ID: <20140205124019.176219499@bombadil.infradead.org>
References: <20140205123930.150608699@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53180 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaBEMkX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Feb 2014 07:40:23 -0500
Content-Disposition: inline; filename=0002-megaraid-simplify-internal-command-handling.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org

We don't use the passed in scsi command for anything, so just add a
adapter-wide internal status to go along with the internal scb that
is used unter int_mtx to pass back the return value and get rid of
all the complexities and abuse of the scsi_cmnd structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/megaraid.c |  120 ++++++++++++-----------------------------------
 drivers/scsi/megaraid.h |    3 +-
 2 files changed, 32 insertions(+), 91 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 816db12..8bca30f 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -531,13 +531,6 @@ mega_build_cmd(adapter_t *adapter, Scsi_Cmnd *cmd, int *busy)
 	int	target = 0;
 	int	ldrv_num = 0;   /* logical drive number */
 
-
-	/*
-	 * filter the internal and ioctl commands
-	 */
-	if((cmd->cmnd[0] == MEGA_INTERNAL_CMD))
-		return (scb_t *)cmd->host_scribble;
-
 	/*
 	 * We know what channels our logical drives are on - mega_find_card()
 	 */
@@ -1439,19 +1432,22 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
 
 		cmdid = completed[i];
 
-		if( cmdid == CMDID_INT_CMDS ) { /* internal command */
+		/*
+		 * Only free SCBs for the commands coming down from the
+		 * mid-layer, not for which were issued internally
+		 *
+		 * For internal command, restore the status returned by the
+		 * firmware so that user can interpret it.
+		 */
+		if (cmdid == CMDID_INT_CMDS) {
 			scb = &adapter->int_scb;
-			cmd = scb->cmd;
-			mbox = (mbox_t *)scb->raw_mbox;
 
-			/*
-			 * Internal command interface do not fire the extended
-			 * passthru or 64-bit passthru
-			 */
-			pthru = scb->pthru;
+			list_del_init(&scb->list);
+			scb->state = SCB_FREE;
 
-		}
-		else {
+			adapter->int_status = status;
+			complete(&adapter->int_waitq);
+		} else {
 			scb = &adapter->scb_list[cmdid];
 
 			/*
@@ -1640,25 +1636,7 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
 				cmd->result |= (DID_BAD_TARGET << 16)|status;
 		}
 
-		/*
-		 * Only free SCBs for the commands coming down from the
-		 * mid-layer, not for which were issued internally
-		 *
-		 * For internal command, restore the status returned by the
-		 * firmware so that user can interpret it.
-		 */
-		if( cmdid == CMDID_INT_CMDS ) { /* internal command */
-			cmd->result = status;
-
-			/*
-			 * Remove the internal command from the pending list
-			 */
-			list_del_init(&scb->list);
-			scb->state = SCB_FREE;
-		}
-		else {
-			mega_free_scb(adapter, scb);
-		}
+		mega_free_scb(adapter, scb);
 
 		/* Add Scsi_Command to end of completed queue */
 		list_add_tail(SCSI_LIST(cmd), &adapter->completed_list);
@@ -4133,23 +4111,15 @@ mega_internal_dev_inquiry(adapter_t *adapter, u8 ch, u8 tgt,
  * The last argument is the address of the passthru structure if the command
  * to be fired is a passthru command
  *
- * lockscope specifies whether the caller has already acquired the lock. Of
- * course, the caller must know which lock we are talking about.
- *
  * Note: parameter 'pthru' is null for non-passthru commands.
  */
 static int
 mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
 {
-	Scsi_Cmnd	*scmd;
-	struct	scsi_device *sdev;
+	unsigned long flags;
 	scb_t	*scb;
 	int	rval;
 
-	scmd = scsi_allocate_command(GFP_KERNEL);
-	if (!scmd)
-		return -ENOMEM;
-
 	/*
 	 * The internal commands share one command id and hence are
 	 * serialized. This is so because we want to reserve maximum number of
@@ -4160,73 +4130,45 @@ mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
 	scb = &adapter->int_scb;
 	memset(scb, 0, sizeof(scb_t));
 
-	sdev = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
-	scmd->device = sdev;
-
-	memset(adapter->int_cdb, 0, sizeof(adapter->int_cdb));
-	scmd->cmnd = adapter->int_cdb;
-	scmd->device->host = adapter->host;
-	scmd->host_scribble = (void *)scb;
-	scmd->cmnd[0] = MEGA_INTERNAL_CMD;
-
-	scb->state |= SCB_ACTIVE;
-	scb->cmd = scmd;
+	scb->idx = CMDID_INT_CMDS;
+	scb->state |= SCB_ACTIVE | SCB_PENDQ;
 
 	memcpy(scb->raw_mbox, mc, sizeof(megacmd_t));
 
 	/*
 	 * Is it a passthru command
 	 */
-	if( mc->cmd == MEGA_MBOXCMD_PASSTHRU ) {
-
+	if (mc->cmd == MEGA_MBOXCMD_PASSTHRU)
 		scb->pthru = pthru;
-	}
-
-	scb->idx = CMDID_INT_CMDS;
 
-	megaraid_queue_lck(scmd, mega_internal_done);
+	spin_lock_irqsave(&adapter->lock, flags);
+	list_add_tail(&scb->list, &adapter->pending_list);
+	/*
+	 * Check if the HBA is in quiescent state, e.g., during a
+	 * delete logical drive opertion. If it is, don't run
+	 * the pending_list.
+	 */
+	if (atomic_read(&adapter->quiescent) == 0)
+		mega_runpendq(adapter);
+	spin_unlock_irqrestore(&adapter->lock, flags);
 
 	wait_for_completion(&adapter->int_waitq);
 
-	rval = scmd->result;
-	mc->status = scmd->result;
-	kfree(sdev);
+	mc->status = rval = adapter->int_status;
 
 	/*
 	 * Print a debug message for all failed commands. Applications can use
 	 * this information.
 	 */
-	if( scmd->result && trace_level ) {
+	if( rval && trace_level ) {
 		printk("megaraid: cmd [%x, %x, %x] status:[%x]\n",
-			mc->cmd, mc->opcode, mc->subopcode, scmd->result);
+			mc->cmd, mc->opcode, mc->subopcode, rval);
 	}
 
 	mutex_unlock(&adapter->int_mtx);
-
-	scsi_free_command(GFP_KERNEL, scmd);
-
 	return rval;
 }
 
-
-/**
- * mega_internal_done()
- * @scmd - internal scsi command
- *
- * Callback routine for internal commands.
- */
-static void
-mega_internal_done(Scsi_Cmnd *scmd)
-{
-	adapter_t	*adapter;
-
-	adapter = (adapter_t *)scmd->device->host->hostdata;
-
-	complete(&adapter->int_waitq);
-
-}
-
-
 static struct scsi_host_template megaraid_template = {
 	.module				= THIS_MODULE,
 	.name				= "MegaRAID",
diff --git a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
index 4d0ce4e..8f2e026 100644
--- a/drivers/scsi/megaraid.h
+++ b/drivers/scsi/megaraid.h
@@ -853,10 +853,10 @@ typedef struct {
 
 	u8	sglen;	/* f/w supported scatter-gather list length */
 
-	unsigned char int_cdb[MAX_COMMAND_SIZE];
 	scb_t			int_scb;
 	struct mutex		int_mtx;	/* To synchronize the internal
 						commands */
+	int			int_status; 	/* status of internal cmd */
 	struct completion	int_waitq;	/* wait queue for internal
 						 cmds */
 
@@ -1004,7 +1004,6 @@ static int mega_del_logdrv(adapter_t *, int);
 static int mega_do_del_logdrv(adapter_t *, int);
 static void mega_get_max_sgl(adapter_t *);
 static int mega_internal_command(adapter_t *, megacmd_t *, mega_passthru *);
-static void mega_internal_done(Scsi_Cmnd *);
 static int mega_support_cluster(adapter_t *);
 #endif
 
-- 
1.7.10.4


