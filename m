From: Liu Ping Fan <kernelfans@gmail.com>
Subject: [RFC 7/9] scsi: adopt ref on scsi_cmnd to avoid a race on request
Date: Fri, 30 May 2014 16:15:45 +0800
Message-ID: <1401437747-2097-8-git-send-email-pingfank@linux.vnet.ibm.com>
References: <1401437747-2097-1-git-send-email-pingfank@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yh0-f52.google.com ([209.85.213.52]:46727 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932662AbaE3IN3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 May 2014 04:13:29 -0400
Received: by mail-yh0-f52.google.com with SMTP id z6so1280497yhz.11
        for <linux-scsi@vger.kernel.org>; Fri, 30 May 2014 01:13:28 -0700 (PDT)
In-Reply-To: <1401437747-2097-1-git-send-email-pingfank@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, Jens Axboe <axboe@kernel.dk>, Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Jeff Moyer <jmoyer@redhat.com>

When running io stress test on large latency disk, e.g guest with a image on nfs.
It can trigger the BUG_ON(test_bit(REQ_ATOM_COMPLETE, &req->atomic_flags));
Since there is a race between latency "finishing" scmd and the re-allocated scmd.
I.e a request is still referred by a scmd, but we had turn it back to
slab. This patch introduces the ref on scmd to exclude this issue.

inc ref rules is like the following:
  When setup a scmd, inited as 1. When add a timer inc 1.

dec ref rules is like the following:
  -for the normal ref
     scsi_done() will drop the ref when fail to acquire REQ_ATOM_COMPLETE immediately
     or drop the ref by scsi_end_request()
     or drop by return SUCCESS_REMOVE
  -for a timer ref
     when deleting timer, if !list_empty(timeout_list), then there is a timer ref, and
     drop it.

Oops call trace:

[ 3379.866773] ------------[ cut here ]------------
[ 3379.866997] kernel BUG at block/blk-core.c:2295!
[ 3379.867238] Oops: Exception in kernel mode, sig: 5 [#1]
[ 3379.867400] SMP NR_CPUS=2048 NUMA pSeries
[ 3379.867574] Modules linked in: nfsv3 sg rpcsec_gss_krb5 arc4 md4 nfsv4 nls_utf8
[ 3379.879310] CPU: 4 PID: 0 Comm: swapper/4 Not tainted 3.10.0-105.el7.ppc64 #1
[ 3379.879586] task: c0000003f8bf6900 ti: c0000003fffd4000 task.ti: c0000003f8cb4000
[ 3379.879858] NIP: c000000000413324 LR: c000000000413380 CTR: c0000000005b2cf0
[ 3379.881647] REGS: c0000003fffd76b0 TRAP: 0700   Not tainted  (3.10.0-105.el7.ppc64)
[ 3379.881932] MSR: 8000000000029032 <SF,EE,ME,IR,DR,RI>  CR: 42022042  XER: 00000000
[ 3379.882533] SOFTE: 0
[ 3379.882626] CFAR: c000000000413388
[ 3379.882765]
GPR00: c0000000004132e4 c0000003fffd7930 c0000000012543b8 00000312efc08912
GPR04: c0000003f650f000 c0000003f650f000 c000000000c55e48 000000000009f49d
GPR08: c0000000012e43b8 0000000000000001 0000000000080000 000000002f7c7611
GPR12: 0000000022022044 c00000000fe01000 c000000000b270e8 0000000000010000
GPR16: c000000000b27128 c000000000b27110 c000000000b271c8 c000000000c54480
GPR20: c000000000ac9e00 0000000000000000 c000000000ac9c58 c000000000b271f0
GPR24: c000000003a81948 c000000003a81848 0000000000000000 0000000000000000
GPR28: c0000003f650f000 c0000003efab0000 c0000003efab0004 c0000003f650f000
[ 3379.886311] NIP [c000000000413324] .blk_start_request+0x84/0x100
[ 3379.886539] LR [c000000000413380] .blk_start_request+0xe0/0x100
[ 3379.886760] PACATMSCRATCH [8000000000009032]
[ 3379.886951] Call Trace:
[ 3379.887037] [c0000003fffd7930] [c0000000004132e4] .blk_start_request+0x44/0x100 (unreliable)
[ 3379.887381] [c0000003fffd79b0] [c0000000005b2ef8] .scsi_request_fn+0x208/0x7e0
[ 3379.887756] [c0000003fffd7ad0] [c0000000004141c8] .blk_run_queue+0x68/0xa0
[ 3379.889260] [c0000003fffd7b50] [c0000000005b2098] .scsi_run_queue+0x158/0x300
[ 3379.889645] [c0000003fffd7c10] [c0000000005b5bec] .scsi_io_completion+0x22c/0xe80
[ 3379.890083] [c0000003fffd7ce0] [c0000000005a58a8] .scsi_finish_command+0x108/0x1a0
[ 3379.890483] [c0000003fffd7d70] [c0000000005b5858] .scsi_softirq_done+0x1c8/0x240
[ 3379.890956] [c0000003fffd7e00] [c000000000422b24] .blk_done_softirq+0xa4/0xd0
[ 3379.891364] [c0000003fffd7e90] [c0000000000bb8a8] .__do_softirq+0x148/0x380
[ 3379.891632] [c0000003fffd7f90] [c00000000002462c] .call_do_softirq+0x14/0x24
[ 3379.892008] [c0000003fffd3df0] [c000000000010f70] .do_softirq+0x120/0x170
[ 3379.892429] [c0000003fffd3e80] [c0000000000bbe34] .irq_exit+0x1e4/0x1f0
[ 3379.893180] [c0000003fffd3f10] [c000000000010b60] .__do_irq+0xc0/0x1d0
[ 3379.893578] [c0000003fffd3f90] [c000000000024650] .call_do_irq+0x14/0x24
[ 3379.894018] [c0000003f8cb7830] [c000000000010cfc] .do_IRQ+0x8c/0x100
[ 3379.894539] [c0000003f8cb78d0] [c000000000002494] hardware_interrupt_common+0x114/0x180
[ 3379.895278] --- Exception: 501 at .plpar_hcall_norets+0x84/0xd4
[ 3379.895278]     LR = .shared_cede_loop+0x40/0x90
[ 3379.895730] [c0000003f8cb7bc0] [0000000000000000]           (null) (unreliable)
[ 3379.896356] [c0000003f8cb7c40] [c0000000006c5054] .cpuidle_idle_call+0x114/0x3c0
[ 3379.897882] [c0000003f8cb7d10] [c00000000007d6f0] .pseries_lpar_idle+0x10/0x50
[ 3379.898200] [c0000003f8cb7d80] [c0000000000186a4] .arch_cpu_idle+0x64/0x150
[ 3379.898475] [c0000003f8cb7e00] [c000000000135b84] .cpu_startup_entry+0x1a4/0x2e0
[ 3379.898860] [c0000003f8cb7ed0] [c0000000008b9a4c] .start_secondary+0x3a8/0x3b0
[ 3379.899173] [c0000003f8cb7f90] [c00000000000976c] .start_secondary_prolog+0x10/0x14
[ 3379.899496] Instruction dump:
[ 3379.899631] 792a77e3 41820010 815f0050 2f8a0001 419e004c e93f0178 815f0064 2fa90000
[ 3379.900085] 915f013c 40de0074 e93f0058 792907e0 <0b090000> 7fe3fb78 48010495 60000000
[ 3379.900546] ---[ end trace d57cacc25e1c8c73 ]---
[ 3379.905937]
[ 3379.906041] Sending IPI to other CPUs
[ 3389.939144] ERROR: 1 cpu(s) not responding

Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
---
 drivers/scsi/scsi.c       | 33 +++++++++++++++++++++-------
 drivers/scsi/scsi_error.c |  5 +++--
 drivers/scsi/scsi_lib.c   | 56 +++++++++++++++++++++++++++++++++--------------
 drivers/scsi/scsi_priv.h  |  3 +++
 include/scsi/scsi_cmnd.h  |  1 +
 5 files changed, 72 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index d8afec8..2095edc 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -271,6 +271,8 @@ struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
 		}
 	}
 
+	if (likely(cmd))
+		atomic_set(&cmd->ref, 1);
 	return cmd;
 }
 EXPORT_SYMBOL_GPL(__scsi_get_command);
@@ -320,6 +322,7 @@ void __scsi_put_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd,
 {
 	unsigned long flags;
 
+	BUG_ON(atomic_read(&cmd->ref) != 0);
 	/* changing locks here, don't need to restore the irq state */
 	spin_lock_irqsave(&shost->free_list_lock, flags);
 	if (unlikely(list_empty(&shost->free_list))) {
@@ -348,15 +351,25 @@ void scsi_put_command(struct scsi_cmnd *cmd)
 	struct scsi_device *sdev = cmd->device;
 	unsigned long flags;
 
-	/* serious error if the command hasn't come from a device list */
-	spin_lock_irqsave(&cmd->device->list_lock, flags);
-	BUG_ON(list_empty(&cmd->list));
-	list_del_init(&cmd->list);
-	spin_unlock_irqrestore(&cmd->device->list_lock, flags);
+	BUG_ON(atomic_read(&cmd->ref) <= 0);
+	if (atomic_dec_and_test(&cmd->ref)) {
+		smp_mb();
+		if (cmd->request) {
+			BUG_ON(!list_empty(&cmd->request->queuelist));
+			/* scsi layer has no access to req, so let it gone */
+			blk_reclaim_request(cmd->request, cmd->request->errors);
+		}
+		__scsi_release_buffers(cmd, 0);
+		/* serious error if the command hasn't come from a device list */
+		spin_lock_irqsave(&cmd->device->list_lock, flags);
+		BUG_ON(list_empty(&cmd->list));
+		list_del_init(&cmd->list);
+		spin_unlock_irqrestore(&cmd->device->list_lock, flags);
 
-	cancel_delayed_work(&cmd->abort_work);
+		cancel_delayed_work(&cmd->abort_work);
 
-	__scsi_put_command(cmd->device->host, cmd, &sdev->sdev_gendev);
+		__scsi_put_command(cmd->device->host, cmd, &sdev->sdev_gendev);
+	}
 }
 EXPORT_SYMBOL(scsi_put_command);
 
@@ -757,8 +770,12 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
  */
 static void scsi_done(struct scsi_cmnd *cmd)
 {
+	int ret;
+
 	trace_scsi_dispatch_cmd_done(cmd);
-	blk_complete_request(cmd->request);
+	ret = blk_complete_request(cmd->request);
+	if (ret < 0)
+		scsi_put_command(cmd);
 }
 
 /**
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 8ddd8f5..52e1adb 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -875,9 +875,10 @@ static int scsi_try_to_abort_cmd(struct scsi_host_template *hostt, struct scsi_c
 		return FAILED;
 
 	ret = hostt->eh_abort_handler(scmd);
-	/* After introducing ref on scsi_cmnd, here will handle the ref */
-	if (ret == SUCCESS_REMOVE)
+	if (ret == SUCCESS_REMOVE) {
+		scsi_put_command(scmd);
 		ret = SUCCESS;
+	}
 	return ret;
 }
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e117579..d5eb2df 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -114,6 +114,7 @@ static void scsi_unprep_request(struct request *req)
 	struct scsi_cmnd *cmd = req->special;
 
 	blk_unprep_request(req);
+	cmd->request = NULL;
 	req->special = NULL;
 
 	scsi_put_command(cmd);
@@ -138,6 +139,7 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
 	struct scsi_target *starget = scsi_target(device);
 	struct request_queue *q = device->request_queue;
 	unsigned long flags;
+	bool drop;
 
 	SCSI_LOG_MLQUEUE(1,
 		 printk("Inserting command %p into mlqueue\n", cmd));
@@ -182,7 +184,10 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
 	 * before blk_cleanup_queue() finishes.
 	 */
 	spin_lock_irqsave(q->queue_lock, flags);
-	blk_requeue_request(q, cmd->request);
+	drop = blk_requeue_request(q, cmd->request);
+	if (drop)
+		/* drop the ref by a timer */
+		scsi_put_command(cmd);
 	kblockd_schedule_work(q, &device->requeue_work);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
@@ -587,8 +592,6 @@ void scsi_run_host_queues(struct Scsi_Host *shost)
 		scsi_run_queue(sdev->request_queue);
 }
 
-static void __scsi_release_buffers(struct scsi_cmnd *, int);
-
 /*
  * Function:    scsi_end_request()
  *
@@ -616,15 +619,16 @@ static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int error,
 {
 	struct request_queue *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
+	int drop = 0;
 
 	/*
 	 * If there are blocks left over at the end, set up the command
 	 * to queue the remainder of them.
 	 */
-	if (blk_end_request(req, error, bytes)) {
+	if (blk_end_request_noreclaim(req, error, bytes, &drop)) {
 		/* kill remainder if no retrys */
 		if (error && scsi_noretry_cmd(cmd))
-			blk_end_request_all(req, error);
+			blk_end_request_all_noreclaim(req, error);
 		else {
 			if (requeue) {
 				/*
@@ -639,12 +643,15 @@ static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int error,
 			return cmd;
 		}
 	}
+	/* drop the ref which is hold by timer */
+	if (drop)
+		scsi_put_command(cmd);
 
+	req->errors = error;
 	/*
 	 * This will goose the queue request function at the end, so we don't
 	 * need to worry about launching another command.
 	 */
-	__scsi_release_buffers(cmd, 0);
 	scsi_next_command(cmd);
 	return NULL;
 }
@@ -700,7 +707,7 @@ static void scsi_free_sgtable(struct scsi_data_buffer *sdb)
 	__sg_free_table(&sdb->table, SCSI_MAX_SG_SEGMENTS, scsi_sg_free);
 }
 
-static void __scsi_release_buffers(struct scsi_cmnd *cmd, int do_bidi_check)
+void __scsi_release_buffers(struct scsi_cmnd *cmd, int do_bidi_check)
 {
 
 	if (cmd->sdb.table.nents)
@@ -876,7 +883,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 
 			scsi_queue_dequeue(cmd);
 			scsi_release_buffers(cmd);
-			blk_end_request_all(req, 0);
+			blk_end_request_all_noreclaim(req, 0);
 
 			scsi_next_command(cmd);
 			return;
@@ -1179,6 +1186,7 @@ static struct scsi_cmnd *scsi_get_cmd_from_req(struct scsi_device *sdev,
 		req->special = cmd;
 	} else {
 		cmd = req->special;
+		BUG_ON(atomic_read(&cmd->ref) <= 0);
 	}
 
 	/* pull a tag out of the request if we have one */
@@ -1321,6 +1329,7 @@ scsi_prep_return(struct request_queue *q, struct request *req, int ret)
 		/* release the command and kill it */
 		if (req->special) {
 			struct scsi_cmnd *cmd = req->special;
+			cmd->request = NULL;
 			scsi_release_buffers(cmd);
 			scsi_put_command(cmd);
 			req->special = NULL;
@@ -1600,6 +1609,7 @@ static void scsi_request_fn(struct request_queue *q)
 	struct Scsi_Host *shost;
 	struct scsi_cmnd *cmd;
 	struct request *req;
+	bool tref;
 
 	if(!get_device(&sdev->sdev_gendev))
 		/* We must be tearing the block queue down already */
@@ -1612,6 +1622,8 @@ static void scsi_request_fn(struct request_queue *q)
 	shost = sdev->host;
 	for (;;) {
 		int rtn;
+
+		tref = false;
 		/*
 		 * get next queueable request.  We do this early to make sure
 		 * that the request is fully prepared even if we cannot 
@@ -1629,14 +1641,6 @@ static void scsi_request_fn(struct request_queue *q)
 		}
 
 
-		/*
-		 * Remove the request from the request list.
-		 */
-		if (!(blk_queue_tagged(q) && !blk_queue_start_tag(q, req)))
-			blk_start_request(req);
-		sdev->device_busy++;
-
-		spin_unlock(q->queue_lock);
 		cmd = req->special;
 		if (unlikely(cmd == NULL)) {
 			printk(KERN_CRIT "impossible request in %s.\n"
@@ -1649,6 +1653,23 @@ static void scsi_request_fn(struct request_queue *q)
 		spin_lock(shost->host_lock);
 
 		/*
+		 * Remove the request from the request list.
+		 */
+		if (!(blk_queue_tagged(q) && !blk_queue_start_tag(q, req))) {
+			blk_start_request(req);
+			if (likely(cmd)) {
+				tref = true;
+				/* a timer references the cmd */
+				atomic_inc(&cmd->ref);
+				/* usual 2, or 3 for done cmd in flight */
+				BUG_ON(atomic_read(&cmd->ref) > 3);
+			}
+		}
+		sdev->device_busy++;
+
+		spin_unlock(q->queue_lock);
+
+		/*
 		 * We hit this when the driver is using a host wide
 		 * tag map. For device level tag maps the queue_depth check
 		 * in the device ready fn would prevent us from trying
@@ -1708,6 +1729,9 @@ static void scsi_request_fn(struct request_queue *q)
 	 */
 	spin_lock_irq(q->queue_lock);
 	blk_requeue_request(q, req);
+	if (tref)
+		/* drop the ref holded by a timer*/
+		scsi_put_command(cmd);
 	sdev->device_busy--;
 out_delay:
 	if (sdev->device_busy == 0)
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 601b964..a8f630c 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -179,4 +179,7 @@ extern int scsi_internal_device_block(struct scsi_device *sdev);
 extern int scsi_internal_device_unblock(struct scsi_device *sdev,
 					enum scsi_device_state new_state);
 
+extern void __scsi_release_buffers(struct scsi_cmnd *cmd, int do_bidi_check);
+
+
 #endif /* _SCSI_PRIV_H */
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 029b076..5643026 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -58,6 +58,7 @@ struct scsi_cmnd {
 	struct delayed_work abort_work;
 	int eh_eflags;		/* Used by error handlr */
 
+	atomic_t ref;
 	/*
 	 * A SCSI Command is assigned a nonzero serial_number before passed
 	 * to the driver's queue command function.  The serial_number is
-- 
1.8.1.4

