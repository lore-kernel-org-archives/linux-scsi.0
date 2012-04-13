From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 02/12] libsas: cleanup spurious calls to scsi_schedule_eh
Date: Fri, 13 Apr 2012 16:37:01 -0700
Message-ID: <20120413233701.8025.9699.stgit@dwillia2-linux.jf.intel.com>
References: <20120413233343.8025.18101.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:48293 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932121Ab2DMXVV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Apr 2012 19:21:21 -0400
In-Reply-To: <20120413233343.8025.18101.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: Maciej Trela <maciej.trela@intel.com>, linux-ide@vger.kernel.org, Artur Wojcik <artur.wojcik@intel.com>, linux-scsi@vger.kernel.org, Jacek Danecki <jacek.danecki@intel.com>

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
index bc0cecc..bc83704 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -587,7 +587,6 @@ void sas_ata_task_abort(struct sas_task *task)
 		spin_lock_irqsave(q->queue_lock, flags);
 		blk_abort_request(qc->scsicmd->request);
 		spin_unlock_irqrestore(q->queue_lock, flags);
-		scsi_schedule_eh(qc->scsicmd->device->host);
 		return;
 	}
 
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index f0b9b7b..17339e5 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -1003,7 +1003,6 @@ void sas_task_abort(struct sas_task *task)
 		spin_lock_irqsave(q->queue_lock, flags);
 		blk_abort_request(sc->request);
 		spin_unlock_irqrestore(q->queue_lock, flags);
-		scsi_schedule_eh(sc->device->host);
 	}
 }
 

