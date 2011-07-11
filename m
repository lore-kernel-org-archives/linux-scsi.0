From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/3] libsas: sas_queuecommand doesnt need host_lock
Date: Mon, 11 Jul 2011 14:49:23 -0400
Message-ID: <20110711185045.179355504@bombadil.infradead.org>
References: <20110711184922.859239377@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:46857
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964823Ab1GKSuq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Jul 2011 14:50:46 -0400
Content-Disposition: inline; filename=libsas-unlocked-queuecommand
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/libsas/sas_scsi_host.c
===================================================================
--- linux-2.6.orig/drivers/scsi/libsas/sas_scsi_host.c	2011-07-02 13:40:58.777796133 +0200
+++ linux-2.6/drivers/scsi/libsas/sas_scsi_host.c	2011-07-02 13:42:22.504461759 +0200
@@ -182,27 +182,12 @@ int sas_queue_up(struct sas_task *task)
 	return 0;
 }
 
-/**
- * sas_queuecommand -- Enqueue a command for processing
- * @parameters: See SCSI Core documentation
- *
- * Note: XXX: Remove the host unlock/lock pair when SCSI Core can
- * call us without holding an IRQ spinlock...
- */
-static int sas_queuecommand_lck(struct scsi_cmnd *cmd,
-		     void (*scsi_done)(struct scsi_cmnd *))
-	__releases(host->host_lock)
-	__acquires(dev->sata_dev.ap->lock)
-	__releases(dev->sata_dev.ap->lock)
-	__acquires(host->host_lock)
+int sas_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 {
 	int res = 0;
 	struct domain_device *dev = cmd_to_domain_dev(cmd);
-	struct Scsi_Host *host = cmd->device->host;
 	struct sas_internal *i = to_sas_internal(host->transportt);
 
-	spin_unlock_irq(host->host_lock);
-
 	{
 		struct sas_ha_struct *sas_ha = dev->port->ha;
 		struct sas_task *task;
@@ -210,7 +195,7 @@ static int sas_queuecommand_lck(struct s
 		/* If the device fell off, no sense in issuing commands */
 		if (dev->gone) {
 			cmd->result = DID_BAD_TARGET << 16;
-			scsi_done(cmd);
+			cmd->scsi_done(cmd);
 			goto out;
 		}
 
@@ -228,7 +213,6 @@ static int sas_queuecommand_lck(struct s
 		if (!task)
 			goto out;
 
-		cmd->scsi_done = scsi_done;
 		/* Queue up, Direct Mode or Task Collector Mode. */
 		if (sas_ha->lldd_max_execute_num < 2)
 			res = i->dft->lldd_execute_task(task, 1, GFP_ATOMIC);
@@ -243,18 +227,15 @@ static int sas_queuecommand_lck(struct s
 			if (res == -SAS_QUEUE_FULL) {
 				cmd->result = DID_SOFT_ERROR << 16; /* retry */
 				res = 0;
-				scsi_done(cmd);
+				cmd->scsi_done(cmd);
 			}
 			goto out;
 		}
 	}
 out:
-	spin_lock_irq(host->host_lock);
 	return res;
 }
 
-DEF_SCSI_QCMD(sas_queuecommand)
-
 static void sas_eh_finish_cmd(struct scsi_cmnd *cmd)
 {
 	struct sas_task *task = TO_SAS_TASK(cmd);

