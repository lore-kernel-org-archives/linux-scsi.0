From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 04/11] libsas: Convert to host_lock less w/ interrupts disabled externally
Date: Thu, 11 Nov 2010 16:13:55 -0800
Message-ID: <1289520835-16498-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp103.sbc.mail.re3.yahoo.com ([66.196.96.86]:36743 "HELO
	smtp103.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751360Ab0KLAOJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Nov 2010 19:14:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Ravi Anand <ravi.anand@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Tejun Heo <tj@kernel.org>, Mike Anderson <andmike@linux.vnet.ibm.com>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts the libsas queuecommand to run in host_lock less mode
w/ the new IRQ_DISABLE_SCSI_QCMD() that disables interrupts while calling
->queuecommand() dispatch.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/libsas/sas_scsi_host.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 29251fa..a5ce08f 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -183,26 +183,22 @@ int sas_queue_up(struct sas_task *task)
 }
 
 /**
- * sas_queuecommand -- Enqueue a command for processing
+ * sas_queuecommand_irq_disable -- Enqueue a command for processing
  * @parameters: See SCSI Core documentation
  *
  * Note: XXX: Remove the host unlock/lock pair when SCSI Core can
  * call us without holding an IRQ spinlock...
  */
-static int sas_queuecommand_lck(struct scsi_cmnd *cmd,
+static int sas_queuecommand_irq_disable(struct scsi_cmnd *cmd,
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
@@ -250,11 +246,10 @@ static int sas_queuecommand_lck(struct scsi_cmnd *cmd,
 		}
 	}
 out:
-	spin_lock_irq(host->host_lock);
 	return res;
 }
 
-DEF_SCSI_QCMD(sas_queuecommand)
+IRQ_DISABLE_SCSI_QCMD(sas_queuecommand)
 
 static void sas_eh_finish_cmd(struct scsi_cmnd *cmd)
 {
-- 
1.7.2.3

