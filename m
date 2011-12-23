From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 22/28] libsas: add mutex for SMP task execution
Date: Thu, 22 Dec 2011 19:00:23 -0800
Message-ID: <20111223030023.21827.20295.stgit@localhost6.localdomain6>
References: <20111223025350.21827.85779.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20111223025350.21827.85779.stgit@localhost6.localdomain6>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org, Jeff Skirvin <jeffrey.d.skirvin@intel.com>
List-Id: linux-scsi@vger.kernel.org

From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

SAS does not tag SMP requests, and at least one lldd (isci) does not permit
more than one in-flight request at a time.

Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_discover.c |    1 +
 drivers/scsi/libsas/sas_expander.c |   29 ++++++++++++++++-------------
 include/scsi/libsas.h              |    2 ++
 3 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 3905143..6e5fdfd 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -43,6 +43,7 @@ void sas_init_dev(struct domain_device *dev)
         case EDGE_DEV:
         case FANOUT_DEV:
                 INIT_LIST_HEAD(&dev->ex_dev.children);
+		mutex_init(&dev->ex_dev.cmd_mutex);
                 break;
         case SATA_DEV:
         case SATA_PM:
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 9d2bb32..fd77ea3 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -72,11 +72,13 @@ static int smp_execute_task(struct domain_device *dev, void *req, int req_size,
 	struct sas_internal *i =
 		to_sas_internal(dev->port->ha->core.shost->transportt);
 
+	mutex_lock(&dev->ex_dev.cmd_mutex);
 	for (retry = 0; retry < 3; retry++) {
 		task = sas_alloc_task(GFP_KERNEL);
-		if (!task)
-			return -ENOMEM;
-
+		if (!task) {
+			res = -ENOMEM;
+			break;
+		}
 		task->dev = dev;
 		task->task_proto = dev->tproto;
 		sg_init_one(&task->smp_task.smp_req, req, req_size);
@@ -94,7 +96,7 @@ static int smp_execute_task(struct domain_device *dev, void *req, int req_size,
 		if (res) {
 			del_timer(&task->timer);
 			SAS_DPRINTK("executing SMP task failed:%d\n", res);
-			goto ex_err;
+			break;
 		}
 
 		wait_for_completion(&task->completion);
@@ -104,21 +106,23 @@ static int smp_execute_task(struct domain_device *dev, void *req, int req_size,
 			i->dft->lldd_abort_task(task);
 			if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
 				SAS_DPRINTK("SMP task aborted and not done\n");
-				goto ex_err;
+				break;
 			}
 		}
 		if (task->task_status.resp == SAS_TASK_COMPLETE &&
 		    task->task_status.stat == SAM_STAT_GOOD) {
 			res = 0;
 			break;
-		} if (task->task_status.resp == SAS_TASK_COMPLETE &&
-		      task->task_status.stat == SAS_DATA_UNDERRUN) {
+		}
+		if (task->task_status.resp == SAS_TASK_COMPLETE &&
+		    task->task_status.stat == SAS_DATA_UNDERRUN) {
 			/* no error, but return the number of bytes of
 			 * underrun */
 			res = task->task_status.residual;
 			break;
-		} if (task->task_status.resp == SAS_TASK_COMPLETE &&
-		      task->task_status.stat == SAS_DATA_OVERRUN) {
+		}
+		if (task->task_status.resp == SAS_TASK_COMPLETE &&
+		    task->task_status.stat == SAS_DATA_OVERRUN) {
 			res = -EMSGSIZE;
 			break;
 		} else {
@@ -131,11 +135,10 @@ static int smp_execute_task(struct domain_device *dev, void *req, int req_size,
 			task = NULL;
 		}
 	}
-ex_err:
+	mutex_unlock(&dev->ex_dev.cmd_mutex);
+
 	BUG_ON(retry == 3 && task != NULL);
-	if (task != NULL) {
-		sas_free_task(task);
-	}
+	sas_free_task(task);
 	return res;
 }
 
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 7ba7095..6e1c640 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -153,6 +153,8 @@ struct expander_device {
 
 	struct ex_phy *ex_phy;
 	struct sas_port *parent_port;
+
+	struct mutex cmd_mutex;
 };
 
 /* ---------- SATA device ---------- */

