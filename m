From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/3] libsas: reindent sas_queuecommand
Date: Mon, 11 Jul 2011 14:49:24 -0400
Message-ID: <20110711185045.363766914@bombadil.infradead.org>
References: <20110711184922.859239377@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:46858
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964842Ab1GKSuq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Jul 2011 14:50:46 -0400
Content-Disposition: inline; filename=libsas-reformat-queuecommand
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org

Switch sas_queuecommand to a normal indentation and goto based error handling.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/libsas/sas_scsi_host.c
===================================================================
--- linux-2.6.orig/drivers/scsi/libsas/sas_scsi_host.c	2011-07-02 13:46:15.714458862 +0200
+++ linux-2.6/drivers/scsi/libsas/sas_scsi_host.c	2011-07-02 13:46:45.267791828 +0200
@@ -184,56 +184,51 @@ int sas_queue_up(struct sas_task *task)
 
 int sas_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 {
-	int res = 0;
-	struct domain_device *dev = cmd_to_domain_dev(cmd);
 	struct sas_internal *i = to_sas_internal(host->transportt);
+	struct domain_device *dev = cmd_to_domain_dev(cmd);
+	struct sas_ha_struct *sas_ha = dev->port->ha;
+	struct sas_task *task;
+	int res = 0;
 
-	{
-		struct sas_ha_struct *sas_ha = dev->port->ha;
-		struct sas_task *task;
-
-		/* If the device fell off, no sense in issuing commands */
-		if (dev->gone) {
-			cmd->result = DID_BAD_TARGET << 16;
-			cmd->scsi_done(cmd);
-			goto out;
-		}
-
-		if (dev_is_sata(dev)) {
-			unsigned long flags;
-
-			spin_lock_irqsave(dev->sata_dev.ap->lock, flags);
-			res = ata_sas_queuecmd(cmd, dev->sata_dev.ap);
-			spin_unlock_irqrestore(dev->sata_dev.ap->lock, flags);
-			goto out;
-		}
-
-		res = -ENOMEM;
-		task = sas_create_task(cmd, dev, GFP_ATOMIC);
-		if (!task)
-			goto out;
-
-		/* Queue up, Direct Mode or Task Collector Mode. */
-		if (sas_ha->lldd_max_execute_num < 2)
-			res = i->dft->lldd_execute_task(task, 1, GFP_ATOMIC);
-		else
-			res = sas_queue_up(task);
-
-		/* Examine */
-		if (res) {
-			SAS_DPRINTK("lldd_execute_task returned: %d\n", res);
-			ASSIGN_SAS_TASK(cmd, NULL);
-			sas_free_task(task);
-			if (res == -SAS_QUEUE_FULL) {
-				cmd->result = DID_SOFT_ERROR << 16; /* retry */
-				res = 0;
-				cmd->scsi_done(cmd);
-			}
-			goto out;
-		}
+	/* If the device fell off, no sense in issuing commands */
+	if (dev->gone) {
+		cmd->result = DID_BAD_TARGET << 16;
+		goto out_done;
 	}
-out:
-	return res;
+
+	if (dev_is_sata(dev)) {
+		unsigned long flags;
+
+		spin_lock_irqsave(dev->sata_dev.ap->lock, flags);
+		res = ata_sas_queuecmd(cmd, dev->sata_dev.ap);
+		spin_unlock_irqrestore(dev->sata_dev.ap->lock, flags);
+		return res;
+	}
+
+	task = sas_create_task(cmd, dev, GFP_ATOMIC);
+	if (!task)
+		return -ENOMEM;
+
+	/* Queue up, Direct Mode or Task Collector Mode. */
+	if (sas_ha->lldd_max_execute_num < 2)
+		res = i->dft->lldd_execute_task(task, 1, GFP_ATOMIC);
+	else
+		res = sas_queue_up(task);
+
+	if (res)
+		goto out_free_task;
+	return 0;
+
+out_free_task:
+	SAS_DPRINTK("lldd_execute_task returned: %d\n", res);
+	ASSIGN_SAS_TASK(cmd, NULL);
+	sas_free_task(task);
+	if (res != -SAS_QUEUE_FULL)
+		return res;
+	cmd->result = DID_SOFT_ERROR << 16; /* retry */
+out_done:
+	cmd->scsi_done(cmd);
+	return 0;
 }
 
 static void sas_eh_finish_cmd(struct scsi_cmnd *cmd)

