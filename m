From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 16/28] libsas: defer SAS_TASK_NEED_DEV_RESET commands to
 libata
Date: Thu, 22 Dec 2011 18:59:52 -0800
Message-ID: <20111223025952.21827.26938.stgit@localhost6.localdomain6>
References: <20111223025350.21827.85779.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:10173 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756331Ab1LWC7x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Dec 2011 21:59:53 -0500
In-Reply-To: <20111223025350.21827.85779.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org, "Darrick J. Wong" <djwong@us.ibm.com>

lldds use the SAS_TASK_NEED_DEV_RESET interface to request that eh
perform a reset.  In the sata device case defer the commands that
triggered the reset to libata-eh context so it can perform its pre and
post reset management.

In the sas_ata_post_internal() case the reset request is falling on deaf
ears as the sas_task is immediately destroyed without any reset action.
Since it is currently a nop, and likely superfluous given the conversion
to new-style libata-eh, just drop the request.

Cc: Darrick J. Wong <djwong@us.ibm.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_ata.c       |   14 ++++----------
 drivers/scsi/libsas/sas_scsi_host.c |    4 ++--
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 2bedc5af..21faf5a 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -406,18 +406,12 @@ static void sas_ata_post_internal(struct ata_queued_cmd *qc)
 		 *  ourselves.
 		 */
 		struct sas_task *task = qc->lldd_task;
-		unsigned long flags;
 
 		qc->lldd_task = NULL;
-		if (task) {
-			/* Should this be a AT(API) device reset? */
-			spin_lock_irqsave(&task->task_state_lock, flags);
-			task->task_state_flags |= SAS_TASK_NEED_DEV_RESET;
-			spin_unlock_irqrestore(&task->task_state_lock, flags);
-
-			task->uldd_task = NULL;
-			sas_ata_internal_abort(task);
-		}
+		if (!task)
+			return;
+		task->uldd_task = NULL;
+		sas_ata_internal_abort(task);
 	}
 }
 
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 1804069..57a3484 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -288,7 +288,7 @@ static void sas_scsi_clear_queue_lu(struct list_head *error_q, struct scsi_cmnd
 	list_for_each_entry_safe(cmd, n, error_q, eh_entry) {
 		if (cmd->device->sdev_target == my_cmd->device->sdev_target &&
 		    cmd->device->lun == my_cmd->device->lun)
-			sas_eh_finish_cmd(cmd);
+			sas_eh_defer_cmd(cmd);
 	}
 }
 
@@ -594,7 +594,7 @@ Again:
 					    "recovered\n",
 					    SAS_ADDR(task->dev),
 					    cmd->device->lun);
-				sas_eh_finish_cmd(cmd);
+				sas_eh_defer_cmd(cmd);
 				sas_scsi_clear_queue_lu(work_q, cmd);
 				goto Again;
 			}

