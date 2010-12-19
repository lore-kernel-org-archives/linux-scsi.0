From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 12/12] megaraid_sas: Convert SHT->queuecommand() to run host_lock-less
Date: Sun, 19 Dec 2010 13:22:07 -0800
Message-ID: <1292793727-31957-13-git-send-email-nab@linux-iscsi.org>
References: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Ravi Anand <ravi.anand@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>, Douglas Gilbert <dgilbert@interlog.com>, adam radford <aradford@gmail.com>, Kashyap Desai <Kashyap.Desai@lsi.com>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts megasas_queue_command_lck -> to megasas_queue_command
running in modern host_lock-less mode.  This includes running using
struct megasas_instance->hba_lock to disable interrupts around existing
callers in megasas_queue_command().  In the existing code the
megasas_instance->hba_lock is taken to disable interrupts for

*) Setup of megasas_cmd for scsi_cmnd descriptor in megasas_get_cmd()

*) Issuing megasas_cmd to firmware via instance->instancet->fire_cmd()

Along with commit 1cb8d64a19c and 0fbb4eb3b to make the following
megasas_instance members use proper atomic_t values:

*) fw_issuepend_done: used to signal SCSI_MLQUEUE_HOST_BUSY during
                     ->queuecommand(), and used during shutdown)

*) fw_outstanding:  used to track number outstanding megasas_cmd
                    descriptors

The one part of the code not originaly held, but has now been converted
to hold instance->hba_lock w/ interrupts disabled megasas_build_ldio()
and megasas_build_dcdb().  This part of code was originally protected
by Scsi_Host->host_lock disabling interrupts.

This allows for megaraid_sas to run in host_lock less dispatch
w/ disabling interrupts around internal megasas_instance->hba_lock.
So far this is functioning with QEMU Megasas 8708EM2 HBA emulation
with SG_IO into KVM Guest from TCM_Loop backstores on a .37-rc3 KVM
x86_64 Host.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/megaraid/megaraid_sas.c |   68 ++++++++++++++++++++++-----------
 1 files changed, 45 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index da0d3e3..db3075d 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -122,19 +122,17 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 		     u8 alt_status);
 
 /**
- * megasas_get_cmd -	Get a command from the free pool
+ * __megasas_get_cmd -	Get a command from the free pool
  * @instance:		Adapter soft state
  *
  * Returns a free command from the pool
+ * Locking: Called with instance->cmd_pool_lock w/ spin_lock_irqsave
  */
-static struct megasas_cmd *megasas_get_cmd(struct megasas_instance
-						  *instance)
+static struct megasas_cmd *
+__megasas_get_cmd(struct megasas_instance *instance)
 {
-	unsigned long flags;
 	struct megasas_cmd *cmd = NULL;
 
-	spin_lock_irqsave(&instance->cmd_pool_lock, flags);
-
 	if (!list_empty(&instance->cmd_pool)) {
 		cmd = list_entry((&instance->cmd_pool)->next,
 				 struct megasas_cmd, list);
@@ -143,7 +141,25 @@ static struct megasas_cmd *megasas_get_cmd(struct megasas_instance
 		printk(KERN_ERR "megasas: Command pool empty!\n");
 	}
 
+	return cmd;
+}
+
+/**
+ * megasas_get_cmd -    Get a command from the free pool
+ * @instance:           Adapter soft state
+ *
+ * Returns a free command from the pool
+ */
+static struct megasas_cmd *
+megasas_get_cmd(struct megasas_instance *instance)
+{
+	struct megasas_cmd *cmd;
+	unsigned long flags;
+
+	spin_lock_irqsave(&instance->cmd_pool_lock, flags);
+	cmd = __megasas_get_cmd(instance);
 	spin_unlock_irqrestore(&instance->cmd_pool_lock, flags);
+
 	return cmd;
 }
 
@@ -1332,9 +1348,18 @@ megasas_dump_pending_frames(struct megasas_instance *instance)
  * megasas_queue_command -	Queue entry point
  * @scmd:			SCSI command to be queued
  * @done:			Callback entry point
+ *
+ * This is the main Linux/SCSI per I/O cmd dispatcher that is running
+ * in 'host_lock-less' mode w/o the legacy Scsi_Host->host_Lock held,
+ * and with IRQs enabled.
+ *
+ * This means that interaction with FW requires the instance->hba_lock
+ * be held with interrupts disabled, or that other megasas_instance
+ * reference must be done in an atomic fashion in modern host_lock-less
+ * mode.
  */
 static int
-megasas_queue_command_lck(struct scsi_cmnd *scmd, void (*done) (struct scsi_cmnd *))
+megasas_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *scmd)
 {
 	u32 frame_count;
 	struct megasas_cmd *cmd;
@@ -1347,23 +1372,18 @@ megasas_queue_command_lck(struct scsi_cmnd *scmd, void (*done) (struct scsi_cmnd
 	if (atomic_read(&instance->fw_issuepend_done) == 0)
 		return SCSI_MLQUEUE_HOST_BUSY;
 
-	spin_lock_irqsave(&instance->hba_lock, flags);
-	if (instance->adprecovery != MEGASAS_HBA_OPERATIONAL) {
-		spin_unlock_irqrestore(&instance->hba_lock, flags);
-		return SCSI_MLQUEUE_HOST_BUSY;
-	}
-
-	spin_unlock_irqrestore(&instance->hba_lock, flags);
-
-	scmd->scsi_done = done;
-	scmd->result = 0;
-
 	if (MEGASAS_IS_LOGICAL(scmd) &&
 	    (scmd->device->id >= MEGASAS_MAX_LD || scmd->device->lun)) {
 		scmd->result = DID_BAD_TARGET << 16;
 		goto out_done;
 	}
 
+	spin_lock_irqsave(&instance->hba_lock, flags);
+	if (instance->adprecovery != MEGASAS_HBA_OPERATIONAL) {
+		spin_unlock_irqrestore(&instance->hba_lock, flags);
+		return SCSI_MLQUEUE_HOST_BUSY;
+	}
+
 	switch (scmd->cmnd[0]) {
 	case SYNCHRONIZE_CACHE:
 		/*
@@ -1371,14 +1391,17 @@ megasas_queue_command_lck(struct scsi_cmnd *scmd, void (*done) (struct scsi_cmnd
 		 * No need to send it down
 		 */
 		scmd->result = DID_OK << 16;
+		spin_unlock_irqrestore(&instance->hba_lock, flags);
 		goto out_done;
 	default:
 		break;
 	}
 
-	cmd = megasas_get_cmd(instance);
-	if (!cmd)
+	cmd = __megasas_get_cmd(instance);
+	if (!cmd) {
+		spin_unlock_irqrestore(&instance->hba_lock, flags);
 		return SCSI_MLQUEUE_HOST_BUSY;
+	}
 
 	/*
 	 * Logical drive command
@@ -1387,6 +1410,7 @@ megasas_queue_command_lck(struct scsi_cmnd *scmd, void (*done) (struct scsi_cmnd
 		frame_count = megasas_build_ldio(instance, scmd, cmd);
 	else
 		frame_count = megasas_build_dcdb(instance, scmd, cmd);
+	spin_unlock_irqrestore(&instance->hba_lock, flags);
 
 	if (!frame_count)
 		goto out_return_cmd;
@@ -1414,12 +1438,10 @@ megasas_queue_command_lck(struct scsi_cmnd *scmd, void (*done) (struct scsi_cmnd
  out_return_cmd:
 	megasas_return_cmd(instance, cmd);
  out_done:
-	done(scmd);
+	scmd->scsi_done(scmd);
 	return 0;
 }
 
-static DEF_SCSI_QCMD(megasas_queue_command)
-
 static struct megasas_instance *megasas_lookup_instance(u16 host_no)
 {
 	int i;
-- 
1.7.3.4
