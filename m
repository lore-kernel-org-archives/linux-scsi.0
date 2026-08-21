Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E60E31F9B1;
	Fri, 21 Aug 2026 06:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787293464; cv=none; b=oebNAgXILsPsj8LkfPi0Lbc+DsNE15V801z1WNU9lajB7aJNWIwzg9C9omzp31grImfMeG3+YlPDDm2bNh4oyciXyg57TQuf/qjHGvgOoc6vbnNeiXMBA7QdUDDaTixnJZJuwqV+DsRc9jnqQzYsqD/cFtLU/XpZIMmwWFY5Cxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787293464; c=relaxed/simple;
	bh=ndCvU/6n7/PiCahpc25wNto3KENzhjpSsWiId91deYU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CarnrnSiPrnNhlKkljnWzzbEJkxwHoqqxJSMKdjnu5y3tjeKdi9ztBMIB/Y5bEUfgYV1R9QFbdx2zeGJC6LBze6J7RRzIcuEUT8QNMr1cMcV+zFJBDI9lJoxo7qOViLCnTvNrMB+NMbbf2sB+wW9Rk0P5IYOz9sezrzFU447Qps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=L3F3bm3g; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="L3F3bm3g"
Received: from PC-202605011814.localdomain (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4aceb0a3b;
	Fri, 21 Aug 2026 14:24:03 +0800 (GMT+08:00)
From: Runyu Xiao <runyu.xiao@seu.edu.cn>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jianhao Xu <jianhao.xu@seu.edu.cn>
Subject: [PATCH] scsi: pmcraid: shut down command timers before reuse
Date: Fri, 21 Aug 2026 14:23:51 +0800
Message-Id: <20260821062351.72658-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa022fda52203a1kunmf07c0533190178
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaTx8fVkxLHk1PQxkZSh4dTFYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSE
	pPSExVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=L3F3bm3gH4V1Kx5y+LWKJRJj2za+/Qdof19wEm+MKdRK4h2DQA5EsOlZA2AU+Wq3TRvB5a7Ah625JKi2UZH1ABRtLiobZzC1pcZwIOFKdPTiUhgiNJKcXABZVgTgaN1t7jVF/3tTkQAK+xVAsuXU3EZK+nL/gxo9HMcy8Re+k8I=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=J5kfBMxknzDQKh78hXv2u4953k4MlfzI5CML5D6GU0M=;
	h=date:mime-version:subject:message-id:from;

pmcraid removes a command from the pending pool and then either
completes it or reuses it for reset. timer_delete() only removes a
pending timer; it does not wait for a callback already running and does
not prevent the callback from rearming the timer. A timeout callback can
therefore access a command block after it has been returned or
reinitialized.

The response paths run in hardirq or softirq context, so they cannot
wait synchronously for a normal timer callback. Shut down the timer there
and defer completion to a work item. The worker uses
timer_shutdown_sync() before calling the original completion function.
The reset cleanup path also defers the reset command when it is still
pending so the reset engine cannot reinitialize it before its timer
callback has finished.

Flush command work before releasing command and control buffers.

Fixes: 89a3681041507773 ("[SCSI] pmcraid: PMC-Sierra MaxRAID driver to support 6Gb/s SAS RAID controller")

Cc: stable@vger.kernel.org

Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 942a99393204..ed2ebe68c816 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -55,6 +55,43 @@ static unsigned int pmcraid_enable_msix;
  */
 static atomic_t pmcraid_adapter_count = ATOMIC_INIT(0);
 
+static void pmcraid_cmd_work(struct work_struct *work);
+static void pmcraid_complete_reset_cmd(struct pmcraid_cmd *cmd);
+
+static void pmcraid_complete_reset_cmd(struct pmcraid_cmd *cmd)
+{
+	struct pmcraid_instance *pinstance = cmd->drv_inst;
+	unsigned long lock_flags;
+
+	spin_lock_irqsave(pinstance->host->host_lock, lock_flags);
+	cmd->cmd_done(cmd);
+	spin_unlock_irqrestore(pinstance->host->host_lock, lock_flags);
+}
+
+static void pmcraid_complete_response_cmd(struct pmcraid_cmd *cmd)
+{
+	cmd->cmd_done(cmd);
+}
+
+static void pmcraid_schedule_cmd_work(struct pmcraid_cmd *cmd,
+				      void (*work_fn)(struct pmcraid_cmd *))
+{
+	/* The command block stays unavailable until the worker completes. */
+	timer_shutdown(&cmd->timer);
+	cmd->work_fn = work_fn;
+	schedule_work(&cmd->timer_work);
+}
+
+static void pmcraid_cmd_work(struct work_struct *work)
+{
+	struct pmcraid_cmd *cmd = container_of(work, struct pmcraid_cmd,
+			timer_work);
+	void (*work_fn)(struct pmcraid_cmd *) = cmd->work_fn;
+
+	timer_shutdown_sync(&cmd->timer);
+	work_fn(cmd);
+}
+
 /*
  * Supporting user-level control interface through IOCTL commands.
  * pmcraid_major - major number to use
@@ -330,6 +367,7 @@ static void pmcraid_init_cmdblk(struct pmcraid_cmd *cmd, int index)
 	}
 
 	cmd->cmd_done = NULL;
+	cmd->work_fn = NULL;
 	cmd->scsi_cmd = NULL;
 	cmd->release = 0;
 	cmd->completion_req = 0;
@@ -483,8 +521,6 @@ static void pmcraid_clr_trans_op(
 	struct pmcraid_instance *pinstance
 )
 {
-	unsigned long lock_flags;
-
 	if (!pinstance->interrupt_mode) {
 		iowrite32(INTRS_TRANSITION_TO_OPERATIONAL,
 			pinstance->int_regs.ioa_host_interrupt_mask_reg);
@@ -495,12 +531,8 @@ static void pmcraid_clr_trans_op(
 	}
 
 	if (pinstance->reset_cmd != NULL) {
-		timer_delete(&pinstance->reset_cmd->timer);
-		spin_lock_irqsave(
-			pinstance->host->host_lock, lock_flags);
-		pinstance->reset_cmd->cmd_done(pinstance->reset_cmd);
-		spin_unlock_irqrestore(
-			pinstance->host->host_lock, lock_flags);
+		pmcraid_schedule_cmd_work(pinstance->reset_cmd,
+					  pmcraid_complete_reset_cmd);
 	}
 }
 
@@ -1967,6 +1999,32 @@ static void pmcraid_get_dump(struct pmcraid_instance *pinstance)
 	pmcraid_info("%s is not yet implemented\n", __func__);
 }
 
+static void pmcraid_fail_cmd(struct pmcraid_cmd *cmd)
+{
+	struct pmcraid_instance *pinstance = cmd->drv_inst;
+	unsigned long lock_flags;
+
+	spin_lock_irqsave(pinstance->host->host_lock, lock_flags);
+	if (cmd->scsi_cmd) {
+		struct scsi_cmnd *scsi_cmd = cmd->scsi_cmd;
+		__le32 resp = cmd->ioa_cb->ioarcb.response_handle;
+		u8 cdb = cmd->ioa_cb->ioarcb.cdb[0];
+
+		scsi_cmd->result |= DID_ERROR << 16;
+		scsi_dma_unmap(scsi_cmd);
+		pmcraid_info("failing(%d) CDB[0] = %x result: %x\n",
+			     le32_to_cpu(resp) >> 2, cdb, scsi_cmd->result);
+		pmcraid_return_cmd(cmd);
+		scsi_done(scsi_cmd);
+	} else if (cmd->cmd_done == pmcraid_internal_done ||
+		   cmd->cmd_done == pmcraid_erp_done) {
+		cmd->cmd_done(cmd);
+	} else {
+		pmcraid_return_cmd(cmd);
+	}
+	spin_unlock_irqrestore(pinstance->host->host_lock, lock_flags);
+}
+
 /**
  * pmcraid_fail_outstanding_cmds - Fails all outstanding ops.
  * @pinstance: pointer to adapter instance structure
@@ -1977,12 +2035,13 @@ static void pmcraid_get_dump(struct pmcraid_instance *pinstance)
  * pool.
  *
  * Return value:
- *	 none
+ *	 true if reset command completion was deferred, otherwise false
  */
-static void pmcraid_fail_outstanding_cmds(struct pmcraid_instance *pinstance)
+static bool pmcraid_fail_outstanding_cmds(struct pmcraid_instance *pinstance)
 {
 	struct pmcraid_cmd *cmd, *temp;
 	unsigned long lock_flags;
+	bool reset_deferred = false;
 
 	/* pending command list is protected by pending_pool_lock. Its
 	 * traversal must be done as within this lock
@@ -1998,42 +2057,28 @@ static void pmcraid_fail_outstanding_cmds(struct pmcraid_instance *pinstance)
 		cmd->ioa_cb->ioasa.ilid =
 			cpu_to_le32(PMCRAID_DRIVER_ILID);
 
-		/* In case the command timer is still running */
-		timer_delete(&cmd->timer);
-
-		/* If this is an IO command, complete it by invoking scsi_done
-		 * function. If this is one of the internal commands other
-		 * than pmcraid_ioa_reset and HCAM commands invoke cmd_done to
-		 * complete it
-		 */
-		if (cmd->scsi_cmd) {
-
-			struct scsi_cmnd *scsi_cmd = cmd->scsi_cmd;
-			__le32 resp = cmd->ioa_cb->ioarcb.response_handle;
-
-			scsi_cmd->result |= DID_ERROR << 16;
-
-			scsi_dma_unmap(scsi_cmd);
-			pmcraid_return_cmd(cmd);
-
-			pmcraid_info("failing(%d) CDB[0] = %x result: %x\n",
-				     le32_to_cpu(resp) >> 2,
-				     cmd->ioa_cb->ioarcb.cdb[0],
-				     scsi_cmd->result);
-			scsi_done(scsi_cmd);
-		} else if (cmd->cmd_done == pmcraid_internal_done ||
-			   cmd->cmd_done == pmcraid_erp_done) {
-			cmd->cmd_done(cmd);
-		} else if (cmd->cmd_done != pmcraid_ioa_reset &&
-			   cmd->cmd_done != pmcraid_ioa_shutdown_done) {
-			pmcraid_return_cmd(cmd);
-		}
-
 		atomic_dec(&pinstance->outstanding_cmds);
+		if (cmd == pinstance->reset_cmd &&
+		    cmd->cmd_done == pmcraid_ioa_reset) {
+			/* The reset engine owns this command and must resume only
+			 * after its timer callback has finished.
+			 */
+			pmcraid_schedule_cmd_work(cmd, pmcraid_complete_reset_cmd);
+			reset_deferred = true;
+		} else if (cmd == pinstance->reset_cmd &&
+			   cmd->cmd_done == pmcraid_ioa_shutdown_done) {
+			/* pmcraid_ioa_shutdown_done() takes host_lock itself. */
+			pmcraid_schedule_cmd_work(cmd,
+						  pmcraid_complete_response_cmd);
+			reset_deferred = true;
+		} else {
+			pmcraid_schedule_cmd_work(cmd, pmcraid_fail_cmd);
+		}
 		spin_lock_irqsave(&pinstance->pending_pool_lock, lock_flags);
 	}
 
 	spin_unlock_irqrestore(&pinstance->pending_pool_lock, lock_flags);
+	return reset_deferred;
 }
 
 /**
@@ -2151,8 +2196,11 @@ static void pmcraid_ioa_reset(struct pmcraid_cmd *cmd)
 		 */
 		pci_restore_state(pinstance->pdev);
 
-		/* fail all pending commands */
-		pmcraid_fail_outstanding_cmds(pinstance);
+		/* fail all pending commands. If the reset command itself is still
+		 * pending, its timer must finish before the reset engine reuses it.
+		 */
+		if (pmcraid_fail_outstanding_cmds(pinstance))
+			break;
 
 		/* check if unit check is active, if so extract dump */
 		if (pinstance->ioa_unit_check) {
@@ -3934,7 +3982,6 @@ static void pmcraid_tasklet_function(unsigned long instance)
 	struct pmcraid_instance *pinstance;
 	unsigned long hrrq_lock_flags;
 	unsigned long pending_lock_flags;
-	unsigned long host_lock_flags;
 	spinlock_t *lockp; /* hrrq buffer lock */
 	int id;
 	u32 resp;
@@ -3982,17 +4029,15 @@ static void pmcraid_tasklet_function(unsigned long instance)
 		list_del(&cmd->free_list);
 		spin_unlock_irqrestore(&pinstance->pending_pool_lock,
 					pending_lock_flags);
-		timer_delete(&cmd->timer);
 		atomic_dec(&pinstance->outstanding_cmds);
 
 		if (cmd->cmd_done == pmcraid_ioa_reset) {
-			spin_lock_irqsave(pinstance->host->host_lock,
-					  host_lock_flags);
-			cmd->cmd_done(cmd);
-			spin_unlock_irqrestore(pinstance->host->host_lock,
-					       host_lock_flags);
+			pmcraid_schedule_cmd_work(cmd, pmcraid_complete_reset_cmd);
 		} else if (cmd->cmd_done != NULL) {
-			cmd->cmd_done(cmd);
+			pmcraid_schedule_cmd_work(cmd,
+						  pmcraid_complete_response_cmd);
+		} else {
+			timer_shutdown(&cmd->timer);
 		}
 		/* loop over until we are done with all responses */
 		spin_lock_irqsave(lockp, hrrq_lock_flags);
@@ -4097,7 +4142,10 @@ pmcraid_release_cmd_blocks(struct pmcraid_instance *pinstance, int max_index)
 {
 	int i;
 	for (i = 0; i < max_index; i++) {
-		kmem_cache_free(pinstance->cmd_cachep, pinstance->cmd_list[i]);
+		struct pmcraid_cmd *cmd = pinstance->cmd_list[i];
+
+		flush_work(&cmd->timer_work);
+		kmem_cache_free(pinstance->cmd_cachep, cmd);
 		pinstance->cmd_list[i] = NULL;
 	}
 	kmem_cache_destroy(pinstance->cmd_cachep);
@@ -4137,6 +4185,14 @@ pmcraid_release_control_blocks(
 	pinstance->control_pool = NULL;
 }
 
+static void pmcraid_flush_cmd_works(struct pmcraid_instance *pinstance)
+{
+	int i;
+
+	for (i = 0; i < PMCRAID_MAX_CMD; i++)
+		flush_work(&pinstance->cmd_list[i]->timer_work);
+}
+
 /**
  * pmcraid_allocate_cmd_blocks - allocate memory for cmd block structures
  * @pinstance: pointer to per adapter instance structure
@@ -4168,6 +4224,7 @@ static int pmcraid_allocate_cmd_blocks(struct pmcraid_instance *pinstance)
 			pmcraid_release_cmd_blocks(pinstance, i);
 			return -ENOMEM;
 		}
+		INIT_WORK(&pinstance->cmd_list[i]->timer_work, pmcraid_cmd_work);
 	}
 	return 0;
 }
@@ -4459,6 +4516,7 @@ static void pmcraid_kill_tasklets(struct pmcraid_instance *pinstance)
  */
 static void pmcraid_release_buffers(struct pmcraid_instance *pinstance)
 {
+	pmcraid_flush_cmd_works(pinstance);
 	pmcraid_release_config_buffers(pinstance);
 	pmcraid_release_control_blocks(pinstance, PMCRAID_MAX_CMD);
 	pmcraid_release_cmd_blocks(pinstance, PMCRAID_MAX_CMD);
diff --git a/drivers/scsi/pmcraid.h b/drivers/scsi/pmcraid.h
index cd059b7599b4..dd4f18d14586 100644
--- a/drivers/scsi/pmcraid.h
+++ b/drivers/scsi/pmcraid.h
@@ -14,6 +14,7 @@
 #include <linux/types.h>
 #include <linux/completion.h>
 #include <linux/list.h>
+#include <linux/workqueue.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <linux/cdev.h>
@@ -569,12 +570,14 @@ struct pmcraid_cmd {
 	struct list_head free_list;
 	struct completion wait_for_completion;
 	struct timer_list timer;	/* needed for internal commands */
+	struct work_struct timer_work;
 	u32 timeout;			/* current timeout value */
 	u32 index;			/* index into the command list */
 	u8 completion_req;		/* for handling internal commands */
 	u8 release;			/* for handling completions */
 
 	void (*cmd_done) (struct pmcraid_cmd *);
+	void (*work_fn)(struct pmcraid_cmd *cmd);
 	struct pmcraid_instance *drv_inst;
 
 	struct pmcraid_sglist *sglist; /* used for passthrough IOCTLs */
-- 
2.34.1

