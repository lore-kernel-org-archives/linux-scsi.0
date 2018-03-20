From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.16-rc6
Date: Tue, 20 Mar 2018 15:49:29 -0700
Message-ID: <1521586169.4426.42.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

One driver patch (qla2xxx) which fixes a problem caused by an existing
regression fix (FCP discovery is failing) and one generic fix to a
longstanding bug in libsas that causes I/O eventually to hang to the
device in the face of ATA error recovery.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Himanshu Madhani (1):
      scsi: qla2xxx: Remove FC_NO_LOOP_ID for FCP and FC-NVMe Discovery

Jason Yan (1):
      scsi: libsas: defer ata device eh commands to libata

And the diffstat:

 drivers/scsi/libsas/sas_scsi_host.c | 33 +++++++++++++--------------------
 drivers/scsi/qla2xxx/qla_init.c     |  1 -
 2 files changed, 13 insertions(+), 21 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 626727207889..a372af68d9a9 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -223,6 +223,7 @@ int sas_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 static void sas_eh_finish_cmd(struct scsi_cmnd *cmd)
 {
 	struct sas_ha_struct *sas_ha = SHOST_TO_SAS_HA(cmd->device->host);
+	struct domain_device *dev = cmd_to_domain_dev(cmd);
 	struct sas_task *task = TO_SAS_TASK(cmd);
 
 	/* At this point, we only get called following an actual abort
@@ -231,6 +232,14 @@ static void sas_eh_finish_cmd(struct scsi_cmnd *cmd)
 	 */
 	sas_end_task(cmd, task);
 
+	if (dev_is_sata(dev)) {
+		/* defer commands to libata so that libata EH can
+		 * handle ata qcs correctly
+		 */
+		list_move_tail(&cmd->eh_entry, &sas_ha->eh_ata_q);
+		return;
+	}
+
 	/* now finish the command and move it on to the error
 	 * handler done list, this also takes it off the
 	 * error handler pending list.
@@ -238,22 +247,6 @@ static void sas_eh_finish_cmd(struct scsi_cmnd *cmd)
 	scsi_eh_finish_cmd(cmd, &sas_ha->eh_done_q);
 }
 
-static void sas_eh_defer_cmd(struct scsi_cmnd *cmd)
-{
-	struct domain_device *dev = cmd_to_domain_dev(cmd);
-	struct sas_ha_struct *ha = dev->port->ha;
-	struct sas_task *task = TO_SAS_TASK(cmd);
-
-	if (!dev_is_sata(dev)) {
-		sas_eh_finish_cmd(cmd);
-		return;
-	}
-
-	/* report the timeout to libata */
-	sas_end_task(cmd, task);
-	list_move_tail(&cmd->eh_entry, &ha->eh_ata_q);
-}
-
 static void sas_scsi_clear_queue_lu(struct list_head *error_q, struct scsi_cmnd *my_cmd)
 {
 	struct scsi_cmnd *cmd, *n;
@@ -261,7 +254,7 @@ static void sas_scsi_clear_queue_lu(struct list_head *error_q, struct scsi_cmnd
 	list_for_each_entry_safe(cmd, n, error_q, eh_entry) {
 		if (cmd->device->sdev_target == my_cmd->device->sdev_target &&
 		    cmd->device->lun == my_cmd->device->lun)
-			sas_eh_defer_cmd(cmd);
+			sas_eh_finish_cmd(cmd);
 	}
 }
 
@@ -618,12 +611,12 @@ static void sas_eh_handle_sas_errors(struct Scsi_Host *shost, struct list_head *
 		case TASK_IS_DONE:
 			SAS_DPRINTK("%s: task 0x%p is done\n", __func__,
 				    task);
-			sas_eh_defer_cmd(cmd);
+			sas_eh_finish_cmd(cmd);
 			continue;
 		case TASK_IS_ABORTED:
 			SAS_DPRINTK("%s: task 0x%p is aborted\n",
 				    __func__, task);
-			sas_eh_defer_cmd(cmd);
+			sas_eh_finish_cmd(cmd);
 			continue;
 		case TASK_IS_AT_LU:
 			SAS_DPRINTK("task 0x%p is at LU: lu recover\n", task);
@@ -634,7 +627,7 @@ static void sas_eh_handle_sas_errors(struct Scsi_Host *shost, struct list_head *
 					    "recovered\n",
 					    SAS_ADDR(task->dev),
 					    cmd->device->lun);
-				sas_eh_defer_cmd(cmd);
+				sas_eh_finish_cmd(cmd);
 				sas_scsi_clear_queue_lu(work_q, cmd);
 				goto Again;
 			}
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 00329dda6179..8d7fab3cd01d 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1719,7 +1719,6 @@ qla24xx_handle_plogi_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 
 			set_bit(ea->fcport->loop_id, vha->hw->loop_id_map);
 			spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
-			ea->fcport->loop_id = FC_NO_LOOP_ID;
 			ea->fcport->chip_reset = vha->hw->base_qpair->chip_reset;
 			ea->fcport->logout_on_delete = 1;
 			ea->fcport->send_els_logo = 0;
