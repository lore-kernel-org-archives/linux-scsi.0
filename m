From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 6/6] tcm_loop: Convert to use new optimized TFO->new_cmd_map() caller
Date: Mon,  6 Sep 2010 14:37:45 -0700
Message-ID: <1283809065-13745-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp101.sbc.mail.re3.yahoo.com ([66.196.96.84]:41461 "HELO
	smtp101.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755871Ab0IFVhw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2010 17:37:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Boaz Harrosh <bharrosh@panasas.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts the TCM_Loop virtual SCSI LLD fabric module to use
the new struct target_core_fabrics_ops->new_cmd_map() caller added in
commit f3b8d9dfe00.  This allows TCM_Loop to do second stage setup of new
struct se_cmd descriptors directly within TCM processing thread context,
and allows us to drop it's internal per struct tcm_loop_hba->tl_hba_qobj and
->tl_kthread members.

This means that tcm_loop_processing_thread() processing of seperate
TCM_Loop HBA queue in kthreads now goes away, and the original
tcm_loop_execute_core_cmd() now becomes the TFO->new_cmd_map() caller at
tcm_loop_new_cmd_map().  This function is called directly from TCM backstore
processing thread context after se_cmd->transport_add_cmd_to_queue(se_cmd,
TRANSPORT_NEW_CMD_MAP) is invoked by tcm_loop_queuecommand() from within
interrupt context.

This has been tested so far in KVM guest v2.6.36-rc3 with TCM/FILEIO backstores

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/tcm_loop/tcm_loop_configfs.c    |   35 +-------
 drivers/target/tcm_loop/tcm_loop_core.h        |    2 -
 drivers/target/tcm_loop/tcm_loop_fabric.c      |   61 --------------
 drivers/target/tcm_loop/tcm_loop_fabric.h      |    2 -
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.c |  100 +++++++-----------------
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.h |    2 +-
 6 files changed, 34 insertions(+), 168 deletions(-)

diff --git a/drivers/target/tcm_loop/tcm_loop_configfs.c b/drivers/target/tcm_loop/tcm_loop_configfs.c
index fa4d82a..dd60cbf 100644
--- a/drivers/target/tcm_loop/tcm_loop_configfs.c
+++ b/drivers/target/tcm_loop/tcm_loop_configfs.c
@@ -449,17 +449,6 @@ check_len:
 	snprintf(&tl_hba->tl_wwn_address[0], TL_WWN_ADDR_LEN, "%s", &name[off]);
 
 	/*
-	 * Setup the tl_hba->tl_hba_qobj
-	 */
-	tl_hba->tl_hba_qobj = kzalloc(sizeof(struct se_queue_obj), GFP_KERNEL);
-	if (!(tl_hba->tl_hba_qobj)) {
-		kfree(tl_hba);
-		printk("Unable to allocate tl_hba->tl_hba_qobj\n");
-		return ERR_PTR(-ENOMEM);
-	}
-	transport_init_queue_obj(tl_hba->tl_hba_qobj);
-
-	/*
 	 * Call device_register(tl_hba->dev) to register the emulated
 	 * Linux/SCSI LLD of type struct Scsi_Host at tl_hba->sh after
 	 * device_register() callbacks in tcm_loop_driver_probe()
@@ -469,19 +458,6 @@ check_len:
 		goto out;
 
 	sh = tl_hba->sh;
-	/*
-	 * Start up the per struct Scsi_Host tcm_loop processing thread
-	 */
-	tl_hba->tl_kthread = kthread_run(tcm_loop_processing_thread,
-			(void *)tl_hba, "tcm_loop_%d", sh->host_no);
-	if (IS_ERR(tl_hba->tl_kthread)) {
-		printk(KERN_ERR "Unable to start tcm_loop kthread\n");
-		device_unregister(&tl_hba->dev);
-		ret = -ENOMEM;
-		goto out;
-	}
-	wait_for_completion(&tl_hba->tl_hba_qobj->thread_create_comp);
-
 	tcm_loop_hba_no_cnt++;
 	printk(KERN_INFO "TCM_Loop_ConfigFS: Allocated emulated Target"
 		" %s Address: %s at Linux/SCSI Host ID: %d\n",
@@ -489,7 +465,6 @@ check_len:
 
 	return &tl_hba->tl_hba_wwn;
 out:
-	kfree(tl_hba->tl_hba_qobj);
 	kfree(tl_hba);
 	return ERR_PTR(ret);
 }
@@ -500,12 +475,6 @@ void tcm_loop_drop_scsi_hba(
 	struct tcm_loop_hba *tl_hba = container_of(wwn,
 				struct tcm_loop_hba, tl_hba_wwn);
 	int host_no = tl_hba->sh->host_no;
-
-	/*
-	 * Shutdown the per HBA tcm_loop processing kthread
-	 */
-	kthread_stop(tl_hba->tl_kthread);
-	wait_for_completion(&tl_hba->tl_hba_qobj->thread_done_comp);
 	/*
 	 * Call device_unregister() on the original tl_hba->dev.
 	 * tcm_loop_fabric_scsi.c:tcm_loop_release_adapter() will
@@ -590,6 +559,10 @@ int tcm_loop_register_configfs(void)
 	 * virtual memory address mappings
 	 */
 	fabric->tf_ops.alloc_cmd_iovecs = NULL;
+	/*
+	 * Used for setting up remaining TCM resources in process context
+	 */
+	fabric->tf_ops.new_cmd_map = &tcm_loop_new_cmd_map;
 	fabric->tf_ops.check_stop_free = &tcm_loop_check_stop_free;
 	fabric->tf_ops.release_cmd_to_pool = &tcm_loop_deallocate_core_cmd;
 	fabric->tf_ops.release_cmd_direct = &tcm_loop_deallocate_core_cmd;
diff --git a/drivers/target/tcm_loop/tcm_loop_core.h b/drivers/target/tcm_loop/tcm_loop_core.h
index eaebe89..69906b7 100644
--- a/drivers/target/tcm_loop/tcm_loop_core.h
+++ b/drivers/target/tcm_loop/tcm_loop_core.h
@@ -69,8 +69,6 @@ struct tcm_loop_hba {
 	struct se_lun *tl_hba_lun;
 	struct se_port *tl_hba_lun_sep;
 	struct se_device_s *se_dev_hba_ptr;
-	struct se_queue_obj *tl_hba_qobj;
-	struct task_struct *tl_kthread;
 	struct tcm_loop_nexus *tl_nexus;
 	struct device dev;
 	struct Scsi_Host *sh;
diff --git a/drivers/target/tcm_loop/tcm_loop_fabric.c b/drivers/target/tcm_loop/tcm_loop_fabric.c
index ef23f07..abd643d 100644
--- a/drivers/target/tcm_loop/tcm_loop_fabric.c
+++ b/drivers/target/tcm_loop/tcm_loop_fabric.c
@@ -455,67 +455,6 @@ u64 tcm_loop_pack_lun(unsigned int lun)
 	return cpu_to_le64(result);
 }
 
-static struct se_queue_req *tcm_loop_get_qr_from_queue(struct se_queue_obj *qobj)
-{
-	struct se_queue_req *qr;
-	unsigned long flags;
-
-	spin_lock_irqsave(&qobj->cmd_queue_lock, flags);
-	if (list_empty(&qobj->qobj_list)) {
-		spin_unlock_irqrestore(&qobj->cmd_queue_lock, flags);
-		return NULL;
-	}
-
-	qr = list_first_entry(&qobj->qobj_list, struct se_queue_req, qr_list);
-	list_del(&qr->qr_list);
-	atomic_dec(&qobj->queue_cnt);
-	spin_unlock_irqrestore(&qobj->cmd_queue_lock, flags);
-
-	return qr;
-}
-
-int tcm_loop_processing_thread(void *p)
-{
-	struct scsi_cmnd *sc;
-	struct tcm_loop_cmd *tl_cmd;
-	struct tcm_loop_hba *tl_hba = (struct tcm_loop_hba *)p;
-	struct se_queue_obj *qobj = tl_hba->tl_hba_qobj;
-	struct se_queue_req *qr;
-	int ret;
-
-	current->policy = SCHED_NORMAL;
-	set_user_nice(current, -20);
-	spin_lock_irq(&current->sighand->siglock);
-	siginitsetinv(&current->blocked, SHUTDOWN_SIGS);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
-
-	complete(&qobj->thread_create_comp);
-
-	while (!(kthread_should_stop())) {
-		ret = wait_event_interruptible(qobj->thread_wq,
-			atomic_read(&qobj->queue_cnt) || kthread_should_stop());
-		if (ret < 0)
-			goto out;
-
-		qr = tcm_loop_get_qr_from_queue(qobj);
-		if (!(qr))
-			continue;
-
-		tl_cmd = (struct tcm_loop_cmd *)qr->cmd;
-		sc = tl_cmd->sc;
-		kfree(qr);
-
-		TL_CDB_DEBUG("processing_thread, calling tcm_loop_execute"
-			"_core_cmd() for tl_cmd: %p, sc: %p\n", tl_cmd, sc);
-		tcm_loop_execute_core_cmd(tl_cmd, sc);
-	}
-
-out:
-	complete(&qobj->thread_done_comp);
-	return 0;
-}
-
 static int __init tcm_loop_fabric_init(void)
 {
 	int ret;
diff --git a/drivers/target/tcm_loop/tcm_loop_fabric.h b/drivers/target/tcm_loop/tcm_loop_fabric.h
index dde23c5..eef5165 100644
--- a/drivers/target/tcm_loop/tcm_loop_fabric.h
+++ b/drivers/target/tcm_loop/tcm_loop_fabric.h
@@ -41,5 +41,3 @@ extern int tcm_loop_queue_tm_rsp(struct se_cmd *);
 extern u16 tcm_loop_set_fabric_sense_len(struct se_cmd *, u32);
 extern u16 tcm_loop_get_fabric_sense_len(void);
 extern u64 tcm_loop_pack_lun(unsigned int);
-
-extern int tcm_loop_processing_thread(void *);
diff --git a/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c b/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
index 126f311..78476bc 100644
--- a/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
+++ b/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
@@ -54,12 +54,13 @@
  *
  * Can be called from interrupt context in tcm_loop_queuecommand() below
  */
-static struct tcm_loop_cmd *tcm_loop_allocate_core_cmd(
+static struct se_cmd *tcm_loop_allocate_core_cmd(
 	struct tcm_loop_hba *tl_hba,
 	struct se_portal_group *se_tpg,
 	struct scsi_cmnd *sc,
 	int data_direction)
 {
+	struct se_cmd *se_cmd;
 	struct se_session *se_sess;
 	struct tcm_loop_nexus *tl_nexus = tl_hba->tl_nexus;
 	struct tcm_loop_cmd *tl_cmd;
@@ -109,62 +110,37 @@ static struct tcm_loop_cmd *tcm_loop_allocate_core_cmd(
 		kmem_cache_free(tcm_loop_cmd_cache, tl_cmd);
 		return NULL;
 	}
-			
-	return tl_cmd;
-}
-
-/*
- * Queue up the newly allocated struct tcm_loop_cmd to be processed by
- * tcm_loop_fabri.c:tcm_loop_processing_thread()
- *
- * Can be called from interrupt context in tcm_loop_queuecommand() below
- */
-static int tcm_loop_queue_core_cmd(
-	struct se_queue_obj *qobj,
-	struct tcm_loop_cmd *tl_cmd)
-{
-	struct se_queue_req *qr;
-	unsigned long flags;
-
-	qr = kzalloc(sizeof(struct se_queue_req), GFP_ATOMIC);
-	if (!(qr)) {
-		printk(KERN_ERR "Unable to allocate memory for"
-				" struct se_queue_req\n");
-		return -1;	
+	se_cmd = tl_cmd->tl_se_cmd;
+	/*
+	 * Locate the struct se_lun pointer and attach it to struct se_cmd
+	 */
+	if (transport_get_lun_for_cmd(se_cmd, NULL,
+				tl_cmd->sc->device->lun) < 0) {
+		/* NON_EXISTENT_LUN */
+		transport_send_check_condition_and_sense(se_cmd,
+				se_cmd->scsi_sense_reason, 0);
+		return 0;
 	}
-	INIT_LIST_HEAD(&qr->qr_list);
-
-	qr->cmd = (void *)tl_cmd;
-	spin_lock_irqsave(&qobj->cmd_queue_lock, flags);
-	list_add_tail(&qr->qr_list, &qobj->qobj_list);
-	spin_unlock_irqrestore(&qobj->cmd_queue_lock, flags);
+	/*
+	 * Make early call to setup se_cmd->transport_add_cmd_to_queue() pointer
+	 */
+	transport_device_setup_cmd(se_cmd);
 
-	atomic_inc(&qobj->queue_cnt);
-	wake_up_interruptible(&qobj->thread_wq);
-	return 0;
+	return se_cmd;
 }
 
 /*
- * Called by tcm_loop_processing_thread() in tcm_loop_fabric.c
+ * Called by struct target_core_fabric_ops->new_cmd_map()
  *
  * Always called in process context
  */
-int tcm_loop_execute_core_cmd(struct tcm_loop_cmd *tl_cmd, struct scsi_cmnd *sc)
+int tcm_loop_new_cmd_map(struct se_cmd *se_cmd)
 {
-	struct se_cmd *se_cmd = tl_cmd->tl_se_cmd;
+	struct tcm_loop_cmd *tl_cmd = se_cmd->se_fabric_cmd_ptr;
+	struct scsi_cmnd *sc = tl_cmd->sc;
 	void *mem_ptr;
 	int ret;
 	/*
-	 * Locate the struct se_lun pointer and attach it to struct se_cmd
-	 */
-	if (transport_get_lun_for_cmd(se_cmd, NULL,
-				tl_cmd->sc->device->lun) < 0) {
-		/* NON_EXISTENT_LUN */
-		transport_send_check_condition_and_sense(se_cmd,
-				se_cmd->scsi_sense_reason, 0);
-		return 0;
-	}
-	/*
 	 * Allocate the necessary tasks to complete the received CDB+data
 	 */
 	ret = transport_generic_allocate_tasks(se_cmd, tl_cmd->sc->cmnd);
@@ -213,11 +189,8 @@ int tcm_loop_execute_core_cmd(struct tcm_loop_cmd *tl_cmd, struct scsi_cmnd *sc)
 				TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
 		return 0;
 	}
-	/*
-	 * Queue up the struct se_cmd + tasks to be processed by the
-	 * TCM storage object.
-	 */
-	return transport_generic_handle_cdb(se_cmd);
+
+	return 0;
 }
 
 /*
@@ -333,9 +306,9 @@ static int tcm_loop_queuecommand(
 	struct scsi_cmnd *sc,
 	void (*done)(struct scsi_cmnd *))
 {
+	struct se_cmd *se_cmd;
 	struct se_portal_group *se_tpg;
 	struct Scsi_Host *host = sc->device->host;
-	struct tcm_loop_cmd *tl_cmd;
 	struct tcm_loop_hba *tl_hba;
 	struct tcm_loop_tpg *tl_tpg;
 	int data_direction;
@@ -380,31 +353,17 @@ static int tcm_loop_queuecommand(
 	 * Determine the SAM Task Attribute and allocate tl_cmd and
 	 * tl_cmd->tl_se_cmd from TCM infrastructure
 	 */
-	tl_cmd = tcm_loop_allocate_core_cmd(tl_hba, se_tpg, sc, data_direction);
-	if (!(tl_cmd)) {
+	se_cmd = tcm_loop_allocate_core_cmd(tl_hba, se_tpg, sc, data_direction);
+	if (!(se_cmd)) {
 		spin_lock_irq(host->host_lock);
 		sc->result = host_byte(DID_ERROR);
 		(*done)(sc);
 		return 0;
 	}
 	/*
-	 * Queue the tl_cmd to be executed in process context by the
-	 * tcm_loop kernel thread
-	 */
-	if (tcm_loop_queue_core_cmd(tl_hba->tl_hba_qobj, tl_cmd) < 0) {
-		/*
-		 * Will free both struct tcm_loop_cmd and struct se_cmd
-		 */
-		transport_release_cmd_to_pool(tl_cmd->tl_se_cmd);
-		/*
-		 * Reaquire the struct scsi_host->host_lock, and
-		 * complete the struct scsi_cmnd
-		 */
-		spin_lock_irq(host->host_lock);
-		sc->result = host_byte(DID_ERROR);
-		(*done)(sc);
-		return 0;
-	}
+	 * Queue up the newly allocated to be processed in TCM thread context.
+	*/
+	se_cmd->transport_add_cmd_to_queue(se_cmd, TRANSPORT_NEW_CMD_MAP);
 	/*
 	 * Reaquire the the struct scsi_host->host_lock before returning
 	 */
@@ -585,7 +544,6 @@ static void tcm_loop_release_adapter(struct device *dev)
 {
 	struct tcm_loop_hba *tl_hba = to_tcm_loop_hba(dev);
 
-	kfree(tl_hba->tl_hba_qobj);
 	kfree(tl_hba);
 }
 
diff --git a/drivers/target/tcm_loop/tcm_loop_fabric_scsi.h b/drivers/target/tcm_loop/tcm_loop_fabric_scsi.h
index c93e610..bcba89b 100644
--- a/drivers/target/tcm_loop/tcm_loop_fabric_scsi.h
+++ b/drivers/target/tcm_loop/tcm_loop_fabric_scsi.h
@@ -1,6 +1,6 @@
 extern struct kmem_cache *tcm_loop_cmd_cache;
 
-extern int tcm_loop_execute_core_cmd(struct tcm_loop_cmd *, struct scsi_cmnd *);
+extern int tcm_loop_new_cmd_map(struct se_cmd *);
 extern void tcm_loop_check_stop_free(struct se_cmd *);
 extern void tcm_loop_deallocate_core_cmd(struct se_cmd *);
 extern void tcm_loop_scsi_forget_host(struct Scsi_Host *);
-- 
1.5.6.5

