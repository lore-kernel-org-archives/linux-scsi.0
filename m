From: Dan Williams <dan.j.williams@intel.com>
Subject: [set1 PATCH 3/4] libsas: cleanup spurious calls to scsi_schedule_eh
Date: Thu, 21 Jun 2012 23:25:37 -0700
Message-ID: <20120622062537.21162.20343.stgit@dwillia2-linux.jf.intel.com>
References: <20120622062521.21162.31523.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120622062521.21162.31523.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Maciej Trela <maciej.trela@intel.com>, linux-ide@vger.kernel.org, Artur Wojcik <artur.wojcik@intel.com>, Jacek Danecki <jacek.danecki@intel.com>
List-Id: linux-scsi@vger.kernel.org

From: Maciej Trela <maciej.trela@intel.com>

eh is woken up automatically by the presence of failed commands,
scsi_schedule_eh is reserved for cases where there are no failed
commands.  This guarantees that host_eh_sceduled is only incremented
when an explicit eh request is made.

Reviewed-by: Jacek Danecki <jacek.danecki@intel.com>
Signed-off-by: Maciej Trela <maciej.trela@intel.com>
[fixed spurious delete of sas_ata_task_abort]
Signed-off-by: Artur Wojcik <artur.wojcik@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_ata.c       |    1 -
 drivers/scsi/libsas/sas_scsi_host.c |    1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 234b47e..6a6c80f 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -618,7 +618,6 @@ void sas_ata_task_abort(struct sas_task *task)
 		spin_lock_irqsave(q->queue_lock, flags);
 		blk_abort_request(qc->scsicmd->request);
 		spin_unlock_irqrestore(q->queue_lock, flags);
-		scsi_schedule_eh(qc->scsicmd->device->host);
 		return;
 	}
 
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index a09da44..52d5b01 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -1018,7 +1018,6 @@ void sas_task_abort(struct sas_task *task)
 		spin_lock_irqsave(q->queue_lock, flags);
 		blk_abort_request(sc->request);
 		spin_unlock_irqrestore(q->queue_lock, flags);
-		scsi_schedule_eh(sc->device->host);
 	}
 }
 

