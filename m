From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 16/24] libsas: let libata handle command timeouts
Date: Fri, 16 Dec 2011 18:34:31 -0800
Message-ID: <20111217023431.15036.45032.stgit@localhost6.localdomain6>
References: <20111217022912.15036.85808.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:43489 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760796Ab1LQCeb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Dec 2011 21:34:31 -0500
In-Reply-To: <20111217022912.15036.85808.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org, Andrzej Jakowski <andrzej.jakowski@intel.com>

libsas-eh if it successfully aborts an ata command will hide the timeout
condition (AC_ERR_TIMEOUT) from libata.  The command likely completes
with the all-zero task->task_status it started with.  Instead, interpret
a TMF_RESP_FUNC_COMPLETE as the end of the sas_task but keep the scmd
around for libata-eh to handle.

Tested-by: Andrzej Jakowski <andrzej.jakowski@intel.com>
signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_init.c      |    1 +
 drivers/scsi/libsas/sas_scsi_host.c |   22 ++++++++++++++++++++--
 include/scsi/libsas.h               |    3 ++-
 3 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index b04b3ce..934c9e7 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -144,6 +144,7 @@ int sas_register_ha(struct sas_ha_struct *sas_ha)
 	}
 
 	INIT_LIST_HEAD(&sas_ha->eh_done_q);
+	INIT_LIST_HEAD(&sas_ha->eh_ata_q);
 
 	return 0;
 
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 3fca198..aa1fe72 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -265,6 +265,22 @@ static void sas_eh_finish_cmd(struct scsi_cmnd *cmd)
 	scsi_eh_finish_cmd(cmd, &sas_ha->eh_done_q);
 }
 
+static void sas_eh_defer_cmd(struct scsi_cmnd *cmd)
+{
+	struct sas_task *task = TO_SAS_TASK(cmd);
+	struct domain_device *dev = task->dev;
+	struct sas_ha_struct *ha = dev->port->ha;
+
+	if (!dev_is_sata(dev)) {
+		sas_eh_finish_cmd(cmd);
+		return;
+	}
+
+	/* report the timeout to libata */
+	sas_end_task(cmd, task);
+	list_move_tail(&cmd->eh_entry, &ha->eh_ata_q);
+}
+
 static void sas_scsi_clear_queue_lu(struct list_head *error_q, struct scsi_cmnd *my_cmd)
 {
 	struct scsi_cmnd *cmd, *n;
@@ -562,12 +578,12 @@ Again:
 		case TASK_IS_DONE:
 			SAS_DPRINTK("%s: task 0x%p is done\n", __func__,
 				    task);
-			sas_eh_finish_cmd(cmd);
+			sas_eh_defer_cmd(cmd);
 			continue;
 		case TASK_IS_ABORTED:
 			SAS_DPRINTK("%s: task 0x%p is aborted\n",
 				    __func__, task);
-			sas_eh_finish_cmd(cmd);
+			sas_eh_defer_cmd(cmd);
 			continue;
 		case TASK_IS_AT_LU:
 			SAS_DPRINTK("task 0x%p is at LU: lu recover\n", task);
@@ -635,12 +651,14 @@ Again:
 			goto clear_q;
 		}
 	}
+	list_splice_tail_init(&ha->eh_ata_q, work_q);
 	return list_empty(work_q);
 clear_q:
 	SAS_DPRINTK("--- Exit %s -- clear_q\n", __func__);
 	list_for_each_entry_safe(cmd, n, work_q, eh_entry)
 		sas_eh_finish_cmd(cmd);
 
+	list_splice_tail_init(&ha->eh_ata_q, work_q);
 	return list_empty(work_q);
 }
 
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index ccddfae..3ffc605 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -372,7 +372,8 @@ struct sas_ha_struct {
 
 	void *lldd_ha;		  /* not touched by sas class code */
 
-	struct list_head eh_done_q;
+	struct list_head eh_done_q;  /* complete via scsi_eh_flush_done_q */
+	struct list_head eh_ata_q; /* scmds to promote from sas to ata eh */
 };
 
 #define SHOST_TO_SAS_HA(_shost) (*(struct sas_ha_struct **)(_shost)->hostdata)

