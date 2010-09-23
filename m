From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC v3 03/15] libsas: Remove host_lock unlock() + lock() from sas_queuecommand()
Date: Thu, 23 Sep 2010 16:37:53 -0700
Message-ID: <1285285073-16391-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux>
Cc: James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>, "eata.c maintainer" <dario.ballabio@inwind.it>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes the now legacy host_lock unlock() + lock() optimization
from sas_scsi_host.c:sas_queuecommand()

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/libsas/sas_scsi_host.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index f0cfba9..bc1c97c 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -202,18 +202,14 @@ int sas_queue_up(struct sas_task *task)
  */
 int sas_queuecommand(struct scsi_cmnd *cmd,
 		     void (*scsi_done)(struct scsi_cmnd *))
-	__releases(host->host_lock)
 	__acquires(dev->sata_dev.ap->lock)
 	__releases(dev->sata_dev.ap->lock)
-	__acquires(host->host_lock)
 {
 	int res = 0;
 	struct domain_device *dev = cmd_to_domain_dev(cmd);
 	struct Scsi_Host *host = cmd->device->host;
 	struct sas_internal *i = to_sas_internal(host->transportt);
 
-	spin_unlock_irq(host->host_lock);
-
 	{
 		struct sas_ha_struct *sas_ha = dev->port->ha;
 		struct sas_task *task;
@@ -254,7 +250,6 @@ int sas_queuecommand(struct scsi_cmnd *cmd,
 		}
 	}
 out:
-	spin_lock_irq(host->host_lock);
 	return res;
 }
 
-- 
1.7.3
