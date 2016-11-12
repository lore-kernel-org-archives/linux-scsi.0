From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.9-rc4
Date: Fri, 11 Nov 2016 17:35:28 -0800
Message-ID: <1478914528.2502.17.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

The megaraid_sas patch in here fixes a major regression in the last fix
set that made all megaraid_sas cards unusable.  It turns out no-one had
actually tested such an "obvious" fix, sigh.   The fix for the fix has
been tested ...

The next most serious is the vmw_pvscsi abort problem which basically
means that aborts don't work on the vmware paravirt devices and error
handling always escalates to reset.

The rest are an assortment of missed reference counting in certain
paths and corner case bugs that show up on some architectures.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Bart Van Assche (1):
      scsi: scsi_dh_alua: Fix a reference counting bug

Bill Kuzeja (1):
      scsi: qla2xxx: Fix scsi scan hang triggered if adapter fails during init

David Jeffery (1):
      scsi: vmw_pvscsi: return SUCCESS for successful command aborts

Mauricio Faria de Oliveira (2):
      scsi: qla2xxx: fix invalid DMA access after command aborts in PCI device remove
      scsi: qla2xxx: do not queue commands when unloading

Sreekanth Reddy (1):
      scsi: mpt3sas: Fix for block device of raid exists even after deleting raid disk

Sumit Saxena (1):
      scsi: megaraid_sas: fix macro MEGASAS_IS_LOGICAL to avoid regression

Varun Prakash (1):
      scsi: libcxgbi: fix incorrect DDP resource cleanup

tang.junhui (1):
      scsi: scsi_dh_alua: fix missing kref_put() in alua_rtpg_work()

And the diffstat:

 drivers/scsi/cxgbi/libcxgbi.c              |  3 ++-
 drivers/scsi/device_handler/scsi_dh_alua.c |  5 ++++-
 drivers/scsi/megaraid/megaraid_sas.h       |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c       |  4 ++--
 drivers/scsi/qla2xxx/qla_os.c              | 16 ++++++++++++++++
 drivers/scsi/vmw_pvscsi.c                  |  5 +++--
 drivers/scsi/vmw_pvscsi.h                  |  2 +-
 7 files changed, 29 insertions(+), 8 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index d142113..2ffe029 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -2081,9 +2081,10 @@ void cxgbi_cleanup_task(struct iscsi_task *task)
 	/*  never reached the xmit task callout */
 	if (tdata->skb)
 		__kfree_skb(tdata->skb);
-	memset(tdata, 0, sizeof(*tdata));
 
 	task_release_itt(task, task->hdr_itt);
+	memset(tdata, 0, sizeof(*tdata));
+
 	iscsi_tcp_cleanup_task(task);
 }
 EXPORT_SYMBOL_GPL(cxgbi_cleanup_task);
diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 241829e..7bb2068 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -793,6 +793,7 @@ static void alua_rtpg_work(struct work_struct *work)
 		WARN_ON(pg->flags & ALUA_PG_RUN_RTPG);
 		WARN_ON(pg->flags & ALUA_PG_RUN_STPG);
 		spin_unlock_irqrestore(&pg->lock, flags);
+		kref_put(&pg->kref, release_port_group);
 		return;
 	}
 	if (pg->flags & ALUA_SYNC_STPG)
@@ -890,6 +891,7 @@ static void alua_rtpg_queue(struct alua_port_group *pg,
 		/* Do not queue if the worker is already running */
 		if (!(pg->flags & ALUA_PG_RUNNING)) {
 			kref_get(&pg->kref);
+			sdev = NULL;
 			start_queue = 1;
 		}
 	}
@@ -901,7 +903,8 @@ static void alua_rtpg_queue(struct alua_port_group *pg,
 	if (start_queue &&
 	    !queue_delayed_work(alua_wq, &pg->rtpg_work,
 				msecs_to_jiffies(ALUA_RTPG_DELAY_MSECS))) {
-		scsi_device_put(sdev);
+		if (sdev)
+			scsi_device_put(sdev);
 		kref_put(&pg->kref, release_port_group);
 	}
 }
diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index ca86c88..3aaea71 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2233,7 +2233,7 @@ struct megasas_instance_template {
 };
 
 #define MEGASAS_IS_LOGICAL(scp)						\
-	(scp->device->channel < MEGASAS_MAX_PD_CHANNELS) ? 0 : 1
+	((scp->device->channel < MEGASAS_MAX_PD_CHANNELS) ? 0 : 1)
 
 #define MEGASAS_DEV_INDEX(scp)						\
 	(((scp->device->channel % 2) * MEGASAS_MAX_DEV_PER_CHANNEL) +	\
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 209a969..8aa769a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -1273,9 +1273,9 @@ scsih_target_alloc(struct scsi_target *starget)
 			sas_target_priv_data->handle = raid_device->handle;
 			sas_target_priv_data->sas_address = raid_device->wwid;
 			sas_target_priv_data->flags |= MPT_TARGET_FLAGS_VOLUME;
-			sas_target_priv_data->raid_device = raid_device;
 			if (ioc->is_warpdrive)
-				raid_device->starget = starget;
+				sas_target_priv_data->raid_device = raid_device;
+			raid_device->starget = starget;
 		}
 		spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
 		return 0;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index ace65db..567fa08 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -707,6 +707,11 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	srb_t *sp;
 	int rval;
 
+	if (unlikely(test_bit(UNLOADING, &base_vha->dpc_flags))) {
+		cmd->result = DID_NO_CONNECT << 16;
+		goto qc24_fail_command;
+	}
+
 	if (ha->flags.eeh_busy) {
 		if (ha->flags.pci_channel_io_perm_failure) {
 			ql_dbg(ql_dbg_aer, vha, 0x9010,
@@ -1451,6 +1456,15 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 		for (cnt = 1; cnt < req->num_outstanding_cmds; cnt++) {
 			sp = req->outstanding_cmds[cnt];
 			if (sp) {
+				/* Get a reference to the sp and drop the lock.
+				 * The reference ensures this sp->done() call
+				 * - and not the call in qla2xxx_eh_abort() -
+				 * ends the SCSI command (with result 'res').
+				 */
+				sp_get(sp);
+				spin_unlock_irqrestore(&ha->hardware_lock, flags);
+				qla2xxx_eh_abort(GET_CMD_SP(sp));
+				spin_lock_irqsave(&ha->hardware_lock, flags);
 				req->outstanding_cmds[cnt] = NULL;
 				sp->done(vha, sp, res);
 			}
@@ -2341,6 +2355,8 @@ qla2xxx_scan_finished(struct Scsi_Host *shost, unsigned long time)
 {
 	scsi_qla_host_t *vha = shost_priv(shost);
 
+	if (test_bit(UNLOADING, &vha->dpc_flags))
+		return 1;
 	if (!vha->host)
 		return 1;
 	if (time > vha->hw->loop_reset_delay * HZ)
diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 4a0d3cd..15ca09c 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -793,6 +793,7 @@ static int pvscsi_abort(struct scsi_cmnd *cmd)
 	unsigned long flags;
 	int result = SUCCESS;
 	DECLARE_COMPLETION_ONSTACK(abort_cmp);
+	int done;
 
 	scmd_printk(KERN_DEBUG, cmd, "task abort on host %u, %p\n",
 		    adapter->host->host_no, cmd);
@@ -824,10 +825,10 @@ static int pvscsi_abort(struct scsi_cmnd *cmd)
 	pvscsi_abort_cmd(adapter, ctx);
 	spin_unlock_irqrestore(&adapter->hw_lock, flags);
 	/* Wait for 2 secs for the completion. */
-	wait_for_completion_timeout(&abort_cmp, msecs_to_jiffies(2000));
+	done = wait_for_completion_timeout(&abort_cmp, msecs_to_jiffies(2000));
 	spin_lock_irqsave(&adapter->hw_lock, flags);
 
-	if (!completion_done(&abort_cmp)) {
+	if (!done) {
 		/*
 		 * Failed to abort the command, unmark the fact that it
 		 * was requested to be aborted.
diff --git a/drivers/scsi/vmw_pvscsi.h b/drivers/scsi/vmw_pvscsi.h
index c097d2c..d41292e 100644
--- a/drivers/scsi/vmw_pvscsi.h
+++ b/drivers/scsi/vmw_pvscsi.h
@@ -26,7 +26,7 @@
 
 #include <linux/types.h>
 
-#define PVSCSI_DRIVER_VERSION_STRING   "1.0.6.0-k"
+#define PVSCSI_DRIVER_VERSION_STRING   "1.0.7.0-k"
 
 #define PVSCSI_MAX_NUM_SG_ENTRIES_PER_SEGMENT 128
 
