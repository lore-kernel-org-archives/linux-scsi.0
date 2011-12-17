From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 12/24] libsas: kill invocation of scsi_eh_finish_cmd from
 sas_ata_task_done
Date: Fri, 16 Dec 2011 18:34:10 -0800
Message-ID: <20111217023410.15036.82306.stgit@localhost6.localdomain6>
References: <20111217022912.15036.85808.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20111217022912.15036.85808.stgit@localhost6.localdomain6>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org, "Darrick J. Wong" <djwong@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Prior to the conversion to the new-style libata-eh sas_ata_task_done()
may have been the last opportunity to clean up the scmd, but now
libata-eh explicitly handles this case.  It also races against sas-eh.
If a lldd completes a task after SAS_TASK_STATE_ABORTED is set it could
trigger a spurious decrement of shost->host_failed.  Current lldds have
the band-aid of checking SAS_TASK_STATE_ABORTED before calling
->task_done(), but better to just let the scmds escalate to libata for
race free cleanup.

Cc: Darrick J. Wong <djwong@us.ibm.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_ata.c |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index dd35a98..649b04b 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -145,20 +145,6 @@ static void sas_ata_task_done(struct sas_task *task)
 	ata_qc_complete(qc);
 	spin_unlock_irqrestore(dev->sata_dev.ap->lock, flags);
 
-	/*
-	 * If the sas_task has an ata qc, a scsi_cmnd and the aborted
-	 * flag is set, then we must have come in via the libsas EH
-	 * functions.  When we exit this function, we need to put the
-	 * scsi_cmnd on the list of finished errors.  The ata_qc_complete
-	 * call cleans up the libata side of things but we're protected
-	 * from the scsi_cmnd going away because the scsi_cmnd is owned
-	 * by the EH, making libata's call to scsi_done a NOP.
-	 */
-	spin_lock_irqsave(&task->task_state_lock, flags);
-	if (qc->scsicmd && task->task_state_flags & SAS_TASK_STATE_ABORTED)
-		scsi_eh_finish_cmd(qc->scsicmd, &sas_ha->eh_done_q);
-	spin_unlock_irqrestore(&task->task_state_lock, flags);
-
 qc_already_gone:
 	list_del_init(&task->list);
 	sas_free_task(task);

