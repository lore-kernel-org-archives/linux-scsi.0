From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v5 3/7] libsas: fix mixed topology recovery
Date: Sat, 14 Jan 2012 10:10:16 -0800
Message-ID: <20120114181015.25887.25138.stgit@localhost6.localdomain6>
References: <20120114180904.25887.75601.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120114180904.25887.75601.stgit@localhost6.localdomain6>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org, Andrzej Jakowski <andrzej.jakowski@intel.com>
List-Id: linux-scsi@vger.kernel.org

If we have a domain with sas and sata devices there may still be sas
recovery actions to take after peeling off the commands to send to
libata.

Reported-by: Andrzej Jakowski <andrzej.jakowski@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_ata.c       |    8 ++------
 drivers/scsi/libsas/sas_scsi_host.c |   13 +++++++------
 include/scsi/sas_ata.h              |    9 ++++-----
 3 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 2c00a38..0ee6831 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -704,10 +704,9 @@ void sas_ata_strategy_handler(struct Scsi_Host *shost)
 	sas_enable_revalidation(sas_ha);
 }
 
-int sas_ata_eh(struct Scsi_Host *shost, struct list_head *work_q,
-	       struct list_head *done_q)
+void sas_ata_eh(struct Scsi_Host *shost, struct list_head *work_q,
+		struct list_head *done_q)
 {
-	int rtn = 0;
 	struct scsi_cmnd *cmd, *n;
 	struct ata_port *ap;
 
@@ -724,7 +723,6 @@ int sas_ata_eh(struct Scsi_Host *shost, struct list_head *work_q,
 			if (ap && ap != ddev->sata_dev.ap)
 				continue;
 			ap = ddev->sata_dev.ap;
-			rtn = 1;
 			list_move(&cmd->eh_entry, &sata_q);
 		}
 
@@ -746,8 +744,6 @@ int sas_ata_eh(struct Scsi_Host *shost, struct list_head *work_q,
 				list_del_init(sata_q.next);
 		}
 	} while (ap);
-
-	return rtn;
 }
 
 void sas_ata_schedule_reset(struct domain_device *dev)
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index b563ff2..e58ca50 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -678,7 +678,8 @@ void sas_scsi_recover_host(struct Scsi_Host *shost)
 	shost->host_eh_scheduled = 0;
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
-	SAS_DPRINTK("Enter %s\n", __func__);
+	SAS_DPRINTK("Enter %s busy: %d failed: %d\n",
+		    __func__, shost->host_busy, shost->host_failed);
 	/*
 	 * Deal with commands that still have SAS tasks (i.e. they didn't
 	 * complete via the normal sas_task completion mechanism)
@@ -693,9 +694,9 @@ void sas_scsi_recover_host(struct Scsi_Host *shost)
 	 * scsi_unjam_host does, but we skip scsi_eh_abort_cmds because any
 	 * command we see here has no sas_task and is thus unknown to the HA.
 	 */
-	if (!sas_ata_eh(shost, &eh_work_q, &ha->eh_done_q))
-		if (!scsi_eh_get_sense(&eh_work_q, &ha->eh_done_q))
-			scsi_eh_ready_devs(shost, &eh_work_q, &ha->eh_done_q);
+	sas_ata_eh(shost, &eh_work_q, &ha->eh_done_q);
+	if (!scsi_eh_get_sense(&eh_work_q, &ha->eh_done_q))
+		scsi_eh_ready_devs(shost, &eh_work_q, &ha->eh_done_q);
 
 out:
 	clear_bit(SAS_HA_FROZEN, &ha->state);
@@ -707,8 +708,8 @@ out:
 
 	scsi_eh_flush_done_q(&ha->eh_done_q);
 
-	SAS_DPRINTK("--- Exit %s\n", __func__);
-	return;
+	SAS_DPRINTK("--- Exit %s: busy: %d failed: %d\n",
+		    __func__, shost->host_busy, shost->host_failed);
 }
 
 enum blk_eh_timer_return sas_scsi_timed_out(struct scsi_cmnd *cmd)
diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
index da3f377..cb724fd 100644
--- a/include/scsi/sas_ata.h
+++ b/include/scsi/sas_ata.h
@@ -41,8 +41,8 @@ int sas_ata_init_host_and_port(struct domain_device *found_dev,
 
 void sas_ata_task_abort(struct sas_task *task);
 void sas_ata_strategy_handler(struct Scsi_Host *shost);
-int sas_ata_eh(struct Scsi_Host *shost, struct list_head *work_q,
-	       struct list_head *done_q);
+void sas_ata_eh(struct Scsi_Host *shost, struct list_head *work_q,
+		struct list_head *done_q);
 void sas_probe_sata(struct work_struct *work);
 void sas_ata_schedule_reset(struct domain_device *dev);
 void sas_ata_wait_eh(struct domain_device *dev);
@@ -66,10 +66,9 @@ static inline void sas_ata_strategy_handler(struct Scsi_Host *shost)
 {
 }
 
-static inline int sas_ata_eh(struct Scsi_Host *shost, struct list_head *work_q,
-			     struct list_head *done_q)
+static inline void sas_ata_eh(struct Scsi_Host *shost, struct list_head *work_q,
+			      struct list_head *done_q)
 {
-	return 0;
 }
 
 static inline void sas_probe_sata(struct work_struct *work)

