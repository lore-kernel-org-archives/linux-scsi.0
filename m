From: James Bottomley <James.Bottomley@suse.de>
Subject: [PATCH 2/2] libsas: convert to libata new error handler
Date: Sun, 23 Jan 2011 09:44:12 -0600
Message-ID: <1295797452.3007.122.camel@mulgrave.site>
References: <1295797260.3007.118.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1295797260.3007.118.camel@mulgrave.site>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-ide <linux-ide@vger.kernel.org>, Brian King <brking@linux.vnet.ibm.com>, Robert Jennings <rcj@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

The conversion is quite complex given that the libata new error
handler has to be hooked into the current libsas timeout and error
handling.  The way this is done is to process all the failed commands
via libsas first, but if they have no underlying sas task (and they're
on a sata device) assume they are destined for the libata error
handler and send them accordingly.

Finally, activate the port recovery of the libata error handler for
each port known to the host.  This is somewhat suboptimal, since that
port may not need recovering, but given the current architecture of
the libata error handler, it's the only way; and the spurious
activation is harmless.

Signed-off-by: James Bottomley <James.Bottomley@suse.de>
---
 drivers/scsi/libsas/sas_ata.c       |   87 ++++++++++++++++++++++++++++++++--
 drivers/scsi/libsas/sas_scsi_host.c |   14 +++++-
 include/scsi/sas_ata.h              |   22 +++++++++
 3 files changed, 115 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 571603d..6aa4a79 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -240,37 +240,43 @@ static bool sas_ata_qc_fill_rtf(struct ata_queued_cmd *qc)
 	return true;
 }
 
-static void sas_ata_phy_reset(struct ata_port *ap)
+static int sas_ata_hard_reset(struct ata_link *link, unsigned int *class,
+			       unsigned long deadline)
 {
+	struct ata_port *ap = link->ap;
 	struct domain_device *dev = ap->private_data;
 	struct sas_internal *i =
 		to_sas_internal(dev->port->ha->core.shost->transportt);
 	int res = TMF_RESP_FUNC_FAILED;
+	int ret = 0;
 
 	if (i->dft->lldd_I_T_nexus_reset)
 		res = i->dft->lldd_I_T_nexus_reset(dev);
 
-	if (res != TMF_RESP_FUNC_COMPLETE)
+	if (res != TMF_RESP_FUNC_COMPLETE) {
 		SAS_DPRINTK("%s: Unable to reset I T nexus?\n", __func__);
+		ret = -EAGAIN;
+	}
 
 	switch (dev->sata_dev.command_set) {
 		case ATA_COMMAND_SET:
 			SAS_DPRINTK("%s: Found ATA device.\n", __func__);
-			ap->link.device[0].class = ATA_DEV_ATA;
+			*class = ATA_DEV_ATA;
 			break;
 		case ATAPI_COMMAND_SET:
 			SAS_DPRINTK("%s: Found ATAPI device.\n", __func__);
-			ap->link.device[0].class = ATA_DEV_ATAPI;
+			*class = ATA_DEV_ATAPI;
 			break;
 		default:
 			SAS_DPRINTK("%s: Unknown SATA command set: %d.\n",
 				    __func__,
 				    dev->sata_dev.command_set);
-			ap->link.device[0].class = ATA_DEV_UNKNOWN;
+			*class = ATA_DEV_UNKNOWN;
 			break;
 	}
 
 	ap->cbl = ATA_CBL_SATA;
+	return ret;
 }
 
 static void sas_ata_post_internal(struct ata_queued_cmd *qc)
@@ -351,7 +357,11 @@ static int sas_ata_scr_read(struct ata_link *link, unsigned int sc_reg_in,
 }
 
 static struct ata_port_operations sas_sata_ops = {
-	.phy_reset		= sas_ata_phy_reset,
+	.prereset		= ata_std_prereset,
+	.softreset		= NULL,
+	.hardreset		= sas_ata_hard_reset,
+	.postreset		= ata_std_postreset,
+	.error_handler		= ata_std_error_handler,
 	.post_internal_cmd	= sas_ata_post_internal,
 	.qc_defer               = ata_std_qc_defer,
 	.qc_prep		= ata_noop_qc_prep,
@@ -783,3 +793,68 @@ int sas_discover_sata(struct domain_device *dev)
 
 	return res;
 }
+
+void sas_ata_strategy_handler(struct Scsi_Host *shost)
+{
+	struct scsi_device *sdev;
+
+	shost_for_each_device(sdev, shost) {
+		struct domain_device *ddev = sdev_to_domain_dev(sdev);
+		struct ata_port *ap = ddev->sata_dev.ap;
+
+		if (!dev_is_sata(ddev))
+			continue;
+		
+		ata_port_printk(ap, KERN_DEBUG, "sas eh calling libata port error handler");
+		ata_scsi_port_error_handler(shost, ap);
+	}
+}
+
+int sas_ata_timed_out(struct scsi_cmnd *cmd, struct sas_task *task,
+		      enum blk_eh_timer_return *rtn)
+{
+	struct domain_device *ddev = cmd_to_domain_dev(cmd);
+
+	if (!dev_is_sata(ddev) || task)
+		return 0;
+
+	/* we're a sata device with no task, so this must be a libata
+	 * eh timeout.  Ideally should hook into libata timeout
+	 * handling, but there's no point, it just wants to activate
+	 * the eh thread */
+	*rtn = BLK_EH_NOT_HANDLED;
+	return 1;
+}
+
+int sas_ata_eh(struct Scsi_Host *shost, struct list_head *work_q,
+	       struct list_head *done_q)
+{
+	int rtn = 0;
+	struct scsi_cmnd *cmd, *n;
+	struct ata_port *ap;
+
+	do {
+		LIST_HEAD(sata_q);
+
+		ap = NULL;
+		
+		list_for_each_entry_safe(cmd, n, work_q, eh_entry) {
+			struct domain_device *ddev = cmd_to_domain_dev(cmd);
+
+			if (!dev_is_sata(ddev) || TO_SAS_TASK(cmd))
+				continue;
+			if(ap && ap != ddev->sata_dev.ap)
+				continue;
+			ap = ddev->sata_dev.ap;
+			rtn = 1;
+			list_move(&cmd->eh_entry, &sata_q);
+		}
+
+		if (!list_empty(&sata_q)) {
+			ata_port_printk(ap, KERN_DEBUG,"sas eh calling libata cmd error handler\n");
+			ata_scsi_cmd_error_handler(shost, ap, &sata_q);
+		}
+	} while (ap);
+
+	return rtn;
+}
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 9a7aaf5..67758ea 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -663,11 +663,16 @@ void sas_scsi_recover_host(struct Scsi_Host *shost)
 	 * scsi_unjam_host does, but we skip scsi_eh_abort_cmds because any
 	 * command we see here has no sas_task and is thus unknown to the HA.
 	 */
-	if (!scsi_eh_get_sense(&eh_work_q, &ha->eh_done_q))
-		scsi_eh_ready_devs(shost, &eh_work_q, &ha->eh_done_q);
+	if (!sas_ata_eh(shost, &eh_work_q, &ha->eh_done_q))
+		if (!scsi_eh_get_sense(&eh_work_q, &ha->eh_done_q))
+			scsi_eh_ready_devs(shost, &eh_work_q, &ha->eh_done_q);
 
 out:
+	/* now link into libata eh --- if we have any ata devices */
+	sas_ata_strategy_handler(shost);
+
 	scsi_eh_flush_done_q(&ha->eh_done_q);
+
 	SAS_DPRINTK("--- Exit %s\n", __func__);
 	return;
 }
@@ -676,6 +681,11 @@ enum blk_eh_timer_return sas_scsi_timed_out(struct scsi_cmnd *cmd)
 {
 	struct sas_task *task = TO_SAS_TASK(cmd);
 	unsigned long flags;
+	enum blk_eh_timer_return rtn; 
+
+	if (sas_ata_timed_out(cmd, task, &rtn))
+		return rtn;
+	
 
 	if (!task) {
 		cmd->request->timeout /= 2;
diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
index c583193..9c159f7 100644
--- a/include/scsi/sas_ata.h
+++ b/include/scsi/sas_ata.h
@@ -39,6 +39,11 @@ int sas_ata_init_host_and_port(struct domain_device *found_dev,
 			       struct scsi_target *starget);
 
 void sas_ata_task_abort(struct sas_task *task);
+void sas_ata_strategy_handler(struct Scsi_Host *shost);
+int sas_ata_timed_out(struct scsi_cmnd *cmd, struct sas_task *task,
+		      enum blk_eh_timer_return *rtn);
+int sas_ata_eh(struct Scsi_Host *shost, struct list_head *work_q,
+	       struct list_head *done_q);
 
 #else
 
@@ -55,6 +60,23 @@ static inline int sas_ata_init_host_and_port(struct domain_device *found_dev,
 static inline void sas_ata_task_abort(struct sas_task *task)
 {
 }
+
+static inline void sas_ata_strategy_handler(struct Scsi_Host *shost)
+{
+}
+
+static inline int sas_ata_timed_out(struct scsi_cmnd *cmd,
+				    struct sas_task *task,
+				    enum blk_eh_timer_return *rtn)
+{
+	return 0;
+}
+static inline int sas_ata_eh(struct Scsi_Host *shost, struct list_head *work_q,
+			     struct list_head *done_q)
+{
+	return 0;
+}
+
 #endif
 
 #endif /* _SAS_ATA_H_ */
-- 
1.7.2.3



