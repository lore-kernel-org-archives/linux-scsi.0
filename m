From: Brian King <brking@linux.vnet.ibm.com>
Subject: [RFC] [PATCH 3/3] ipr: Use libata new EH
Date: Fri, 10 Jun 2016 16:39:14 -0500
Message-ID: <575B3382.8020403@linux.vnet.ibm.com>
References: <CAOS58YO65A8TpH22tEdM4SUcn8ncpY1f_YFMzomCN09OvhoRaQ@mail.gmail.com>
 <57470450.3070000@linux.vnet.ibm.com> <575B3215.5070602@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40654 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752342AbcFJVj1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jun 2016 17:39:27 -0400
Received: from pps.filterd (m0075771.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u5ALdQTS010174
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jun 2016 17:39:26 -0400
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
	by mx0a-001b2d01.pphosted.com with ESMTP id 23g1eenjdj-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jun 2016 17:39:26 -0400
Received: from localhost
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Fri, 10 Jun 2016 17:39:19 -0400
In-Reply-To: <575B3215.5070602@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>


Converts ipr to use the new EH API of libata, removing the
last user of this API, allowing for its ultimate removal from
the kernel.

Sending this out only as an RFC for now. The patch will need
significantly more testing, but I can now detect and initialize
a SATA device and the main functional path appears to be working.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |  425 ++++++++++++++++++++++++++++++-----------------------
 drivers/scsi/ipr.h |    2 
 2 files changed, 246 insertions(+), 181 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_libata_api_change drivers/scsi/ipr.c
--- linux-2.6.git/drivers/scsi/ipr.c~ipr_libata_api_change	2016-06-10 15:51:43.864962516 -0500
+++ linux-2.6.git-bjking1/drivers/scsi/ipr.c	2016-06-10 15:57:35.758792780 -0500
@@ -84,6 +84,7 @@
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_transport.h>
 #include "ipr.h"
 
 /*
@@ -3244,6 +3245,18 @@ static void ipr_release_dump(struct kref
 	LEAVE;
 }
 
+static struct ata_port_info sata_port_info;
+
+static void ipr_sata_eh_work(struct work_struct *work)
+{
+	struct ipr_sata_port *sata_port = container_of(work, struct ipr_sata_port, work);
+	struct ipr_ioa_cfg *ioa_cfg = sata_port->ioa_cfg;
+
+	ENTER;
+	ata_scsi_port_error_handler(ioa_cfg->host, sata_port->ap);
+	LEAVE;
+}
+
 /**
  * ipr_worker_thread - Worker thread
  * @work:		ioa config struct
@@ -3259,12 +3272,15 @@ static void ipr_worker_thread(struct wor
 {
 	unsigned long lock_flags;
 	struct ipr_resource_entry *res;
+	struct ipr_sata_port *sata_port;
+	struct ata_port *ap;
 	struct scsi_device *sdev;
 	struct ipr_dump *dump;
 	struct ipr_ioa_cfg *ioa_cfg =
 		container_of(work, struct ipr_ioa_cfg, work_q);
 	u8 bus, target, lun;
-	int did_work;
+	int did_work, rc;
+	int sata_ports = 0;
 
 	ENTER;
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
@@ -3301,25 +3317,90 @@ restart:
 		}
 
 		list_for_each_entry(res, &ioa_cfg->used_res_q, queue) {
-			if (res->del_from_ml && res->sdev) {
+			if (!res->del_from_ml)
+				continue;
+			if (res->sdev) {
 				did_work = 1;
 				sdev = res->sdev;
 				if (!scsi_device_get(sdev)) {
-					if (!res->add_to_ml)
-						list_move_tail(&res->queue, &ioa_cfg->free_res_q);
-					else
-						res->del_from_ml = 0;
+					if (!res->sata_port) {
+						if (!res->add_to_ml)
+							list_move_tail(&res->queue, &ioa_cfg->free_res_q);
+						else
+							res->del_from_ml = 0;
+					}
 					spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 					scsi_remove_device(sdev);
 					scsi_device_put(sdev);
 					spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 				}
 				break;
+			} else if (ipr_is_gata(res)) {
+				did_work = 1;
+				sata_port = res->sata_port;
+				res->sata_port = NULL;
+				ap = sata_port->ap;
+				if (!res->add_to_ml)
+					list_move_tail(&res->queue, &ioa_cfg->free_res_q);
+				else
+					res->del_from_ml = 0;
+
+				spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+				spin_lock_irqsave(ap->lock, lock_flags);
+				ap->pflags |= ATA_PFLAG_UNLOADING;
+				ata_port_schedule_eh(ap);
+				spin_unlock_irqrestore(ap->lock, lock_flags);
+
+				ata_port_wait_eh(ap);
+				ata_sas_port_destroy(ap);
+				kfree(sata_port);
+				spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 			}
 		}
 	} while (did_work);
 
 	list_for_each_entry(res, &ioa_cfg->used_res_q, queue) {
+		if (res->add_to_ml && ipr_is_gata(res) && !res->sata_port) {
+			spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+			sata_port = kzalloc(sizeof(*sata_port), GFP_KERNEL);
+			ap = ata_sas_port_alloc(&ioa_cfg->ata_host, &sata_port_info, ioa_cfg->host);
+
+			if (!sata_port || !ap) {
+				spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+				res->add_to_ml = 0;
+				kfree(sata_port);
+				goto restart;
+			}
+
+			spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+			sata_port->ioa_cfg = ioa_cfg;
+			sata_port->ap = ap;
+			sata_port->res = res;
+			INIT_WORK(&sata_port->work, ipr_sata_eh_work);
+
+			res->sata_port = sata_port;
+			ap->private_data = sata_port;
+			ap->cbl = ATA_CBL_SATA;
+			ap->scsi_host = ioa_cfg->host;
+			spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+			rc = ata_sas_port_init(ap);
+			if (rc == 0)
+				ata_sas_async_probe(ap);
+			sata_ports++;
+			spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+			goto restart;
+		}
+	}
+
+	if (sata_ports) {
+		sata_ports = 0;
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		wait_event(ioa_cfg->host->host_wait, !scsi_host_in_recovery(ioa_cfg->host));
+		spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+		goto restart;
+	}
+
+	list_for_each_entry(res, &ioa_cfg->used_res_q, queue) {
 		if (res->add_to_ml) {
 			bus = res->bus;
 			target = res->target;
@@ -4653,68 +4734,13 @@ static struct ipr_resource_entry *ipr_fi
 	return NULL;
 }
 
-static struct ata_port_info sata_port_info;
-
-/**
- * ipr_target_alloc - Prepare for commands to a SCSI target
- * @starget:	scsi target struct
- *
- * If the device is a SATA device, this function allocates an
- * ATA port with libata, else it does nothing.
- *
- * Return value:
- * 	0 on success / non-0 on failure
- **/
-static int ipr_target_alloc(struct scsi_target *starget)
-{
-	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
-	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *) shost->hostdata;
-	struct ipr_sata_port *sata_port;
-	struct ata_port *ap;
-	struct ipr_resource_entry *res;
-	unsigned long lock_flags;
-
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
-	res = ipr_find_starget(starget);
-	starget->hostdata = NULL;
-
-	if (res && ipr_is_gata(res)) {
-		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-		sata_port = kzalloc(sizeof(*sata_port), GFP_KERNEL);
-		if (!sata_port)
-			return -ENOMEM;
-
-		ap = ata_sas_port_alloc(&ioa_cfg->ata_host, &sata_port_info, shost);
-		if (ap) {
-			spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
-			sata_port->ioa_cfg = ioa_cfg;
-			sata_port->ap = ap;
-			sata_port->res = res;
-
-			res->sata_port = sata_port;
-			ap->private_data = sata_port;
-			starget->hostdata = sata_port;
-		} else {
-			kfree(sata_port);
-			return -ENOMEM;
-		}
-	}
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-
-	return 0;
-}
-
 /**
  * ipr_target_destroy - Destroy a SCSI target
  * @starget:	scsi target struct
  *
- * If the device was a SATA device, this function frees the libata
- * ATA port, else it does nothing.
- *
  **/
 static void ipr_target_destroy(struct scsi_target *starget)
 {
-	struct ipr_sata_port *sata_port = starget->hostdata;
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
 	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *) shost->hostdata;
 
@@ -4728,12 +4754,6 @@ static void ipr_target_destroy(struct sc
 				clear_bit(starget->id, ioa_cfg->target_ids);
 		}
 	}
-
-	if (sata_port) {
-		starget->hostdata = NULL;
-		ata_sas_port_destroy(sata_port->ap);
-		kfree(sata_port);
-	}
 }
 
 /**
@@ -4776,8 +4796,6 @@ static void ipr_slave_destroy(struct scs
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 	res = (struct ipr_resource_entry *) sdev->hostdata;
 	if (res) {
-		if (res->sata_port)
-			res->sata_port->ap->link.device[0].class = ATA_DEV_NONE;
 		sdev->hostdata = NULL;
 		res->sdev = NULL;
 		res->sata_port = NULL;
@@ -4837,37 +4855,6 @@ static int ipr_slave_configure(struct sc
 }
 
 /**
- * ipr_ata_slave_alloc - Prepare for commands to a SATA device
- * @sdev:	scsi device struct
- *
- * This function initializes an ATA port so that future commands
- * sent through queuecommand will work.
- *
- * Return value:
- * 	0 on success
- **/
-static int ipr_ata_slave_alloc(struct scsi_device *sdev)
-{
-	struct ipr_sata_port *sata_port = NULL;
-	int rc = -ENXIO;
-
-	ENTER;
-	if (sdev->sdev_target)
-		sata_port = sdev->sdev_target->hostdata;
-	if (sata_port) {
-		rc = ata_sas_port_init(sata_port->ap);
-		if (rc == 0)
-			rc = ata_sas_sync_probe(sata_port->ap);
-	}
-
-	if (rc)
-		ipr_slave_destroy(sdev);
-
-	LEAVE;
-	return rc;
-}
-
-/**
  * ipr_slave_alloc - Prepare for commands to a device.
  * @sdev:	scsi device struct
  *
@@ -4899,10 +4886,6 @@ static int ipr_slave_alloc(struct scsi_d
 		if (!ipr_is_naca_model(res))
 			res->needs_sync_complete = 1;
 		rc = 0;
-		if (ipr_is_gata(res)) {
-			spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-			return ipr_ata_slave_alloc(sdev);
-		}
 	}
 
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
@@ -5120,6 +5103,17 @@ static int ipr_sata_reset(struct ata_lin
 	return rc;
 }
 
+static void ipr_ata_sched_eh(struct ata_port *ap)
+{
+	struct ipr_sata_port *sata_port = ap->private_data;
+	struct ipr_ioa_cfg *ioa_cfg = sata_port->ioa_cfg;
+
+	if (ap->pflags & ATA_PFLAG_INITIALIZING)
+		return;
+
+	queue_work(ioa_cfg->sata_work_q, &sata_port->work);
+}
+
 /**
  * ipr_eh_dev_reset - Reset the device
  * @scsi_cmd:	scsi command struct
@@ -5136,7 +5130,6 @@ static int __ipr_eh_dev_reset(struct scs
 	struct ipr_cmnd *ipr_cmd;
 	struct ipr_ioa_cfg *ioa_cfg;
 	struct ipr_resource_entry *res;
-	struct ata_port *ap;
 	int rc = 0;
 	struct ipr_hrr_queue *hrrq;
 
@@ -5152,7 +5145,7 @@ static int __ipr_eh_dev_reset(struct scs
 	 * mid-layer to call ipr_eh_host_reset, which will then go to sleep and wait for the
 	 * reset to complete
 	 */
-	if (ioa_cfg->in_reset_reload)
+	if (ioa_cfg->in_reset_reload || ipr_is_gata(res))
 		return FAILED;
 	if (ioa_cfg->hrrq[IPR_INIT_HRRQ].ioa_is_dead)
 		return FAILED;
@@ -5163,13 +5156,6 @@ static int __ipr_eh_dev_reset(struct scs
 			if (ipr_cmd->ioarcb.res_handle == res->res_handle) {
 				if (ipr_cmd->scsi_cmd)
 					ipr_cmd->done = ipr_scsi_eh_done;
-				if (ipr_cmd->qc)
-					ipr_cmd->done = ipr_sata_eh_done;
-				if (ipr_cmd->qc &&
-				    !(ipr_cmd->qc->flags & ATA_QCFLAG_FAILED)) {
-					ipr_cmd->qc->err_mask |= AC_ERR_TIMEOUT;
-					ipr_cmd->qc->flags |= ATA_QCFLAG_FAILED;
-				}
 			}
 		}
 		spin_unlock(&hrrq->_lock);
@@ -5177,26 +5163,7 @@ static int __ipr_eh_dev_reset(struct scs
 	res->resetting_device = 1;
 	scmd_printk(KERN_ERR, scsi_cmd, "Resetting device\n");
 
-	if (ipr_is_gata(res) && res->sata_port) {
-		ap = res->sata_port->ap;
-		spin_unlock_irq(scsi_cmd->device->host->host_lock);
-		ata_std_error_handler(ap);
-		spin_lock_irq(scsi_cmd->device->host->host_lock);
-
-		for_each_hrrq(hrrq, ioa_cfg) {
-			spin_lock(&hrrq->_lock);
-			list_for_each_entry(ipr_cmd,
-					    &hrrq->hrrq_pending_q, queue) {
-				if (ipr_cmd->ioarcb.res_handle ==
-				    res->res_handle) {
-					rc = -EIO;
-					break;
-				}
-			}
-			spin_unlock(&hrrq->_lock);
-		}
-	} else
-		rc = ipr_device_reset(ioa_cfg, res);
+	rc = ipr_device_reset(ioa_cfg, res);
 	res->resetting_device = 0;
 	res->reset_occurred = 1;
 
@@ -5406,6 +5373,103 @@ static int ipr_scan_finished(struct Scsi
 	return rc;
 }
 
+static enum blk_eh_timer_return ipr_eh_timed_out(struct scsi_cmnd *scsi_cmd)
+{
+	enum blk_eh_timer_return rc = BLK_EH_NOT_HANDLED;
+	struct ipr_resource_entry *res;
+	struct ipr_ioa_cfg *ioa_cfg;
+	struct ipr_cmnd *ipr_cmd;
+	unsigned long flags;
+	struct ipr_hrr_queue *hrrq;
+
+	ENTER;
+	ioa_cfg = (struct ipr_ioa_cfg *)scsi_cmd->device->host->hostdata;
+	res = scsi_cmd->device->hostdata;
+
+	if (ipr_is_gata(res) && res->sata_port) {
+		for_each_hrrq(hrrq, ioa_cfg) {
+			spin_lock_irqsave(&hrrq->_lock, flags);
+			list_for_each_entry(ipr_cmd, &hrrq->hrrq_pending_q, queue) {
+				if (ipr_cmd->scsi_cmd == scsi_cmd) {
+					if (ipr_cmd->qc &&
+					    !(ipr_cmd->qc->flags & ATA_QCFLAG_FAILED)) {
+						ipr_cmd->qc->err_mask |= AC_ERR_TIMEOUT;
+						ipr_cmd->qc->flags |= ATA_QCFLAG_FAILED;
+					}
+					break;
+				}
+			}
+			spin_unlock_irqrestore(&hrrq->_lock, flags);
+		}
+	}
+
+	LEAVE;
+	return rc;
+}
+
+static void ipr_eh_strategy(struct Scsi_Host *shost)
+{
+	unsigned long flags;
+	LIST_HEAD(eh_work_q);
+	LIST_HEAD(eh_done_q);
+	LIST_HEAD(eh_sata_q);
+	struct scsi_cmnd *scsi_cmd, *tmp;
+	struct ipr_resource_entry *res, *last_res;
+	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *) shost->hostdata;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_splice_init(&shost->eh_cmd_q, &eh_work_q);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	do {
+		last_res = NULL;
+		res = NULL;
+
+		list_for_each_entry_safe(scsi_cmd, tmp, &eh_work_q, eh_entry) {
+			if (!scsi_cmd->device->hostdata)
+				continue;
+
+			res = scsi_cmd->device->hostdata;
+
+			if (!ipr_is_gata(res) || !res->sata_port)
+				continue;
+
+			if (last_res && last_res != res)
+				continue;
+
+			last_res = res;
+			list_move(&scsi_cmd->eh_entry, &eh_sata_q);
+		}
+
+		if (!list_empty(&eh_sata_q)) {
+			struct ata_port *ap = res->sata_port->ap;
+
+			ata_scsi_cmd_error_handler(shost, ap, &eh_sata_q);
+
+			while (!list_empty(&eh_sata_q))
+				list_del_init(eh_sata_q.next);
+		}
+	} while (last_res);
+
+	if (!scsi_eh_abort_cmds(&eh_work_q, &eh_done_q))
+		scsi_eh_ready_devs(shost, &eh_work_q, &eh_done_q);
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	if (shost->eh_deadline != -1)
+		shost->last_reset = 0;
+	shost->host_eh_scheduled = 0;
+
+	list_for_each_entry(res, &ioa_cfg->used_res_q, queue) {
+		if (ipr_is_gata(res) && res->sata_port)
+			ipr_ata_sched_eh(res->sata_port->ap);
+	}
+
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	flush_workqueue(ioa_cfg->sata_work_q);
+	scsi_eh_flush_done_q(&eh_done_q);
+}
+
 /**
  * ipr_eh_host_reset - Reset the host adapter
  * @scsi_cmd:	scsi command struct
@@ -6487,6 +6551,10 @@ static const char *ipr_ioa_info(struct S
 	return buffer;
 }
 
+static struct scsi_transport_template driver_transport = {
+	.eh_strategy_handler = ipr_eh_strategy,
+};
+
 static struct scsi_host_template driver_template = {
 	.module = THIS_MODULE,
 	.name = "IPR",
@@ -6496,11 +6564,11 @@ static struct scsi_host_template driver_
 	.eh_abort_handler = ipr_eh_abort,
 	.eh_device_reset_handler = ipr_eh_dev_reset,
 	.eh_host_reset_handler = ipr_eh_host_reset,
+	.eh_timed_out = ipr_eh_timed_out,
 	.slave_alloc = ipr_slave_alloc,
 	.slave_configure = ipr_slave_configure,
 	.slave_destroy = ipr_slave_destroy,
 	.scan_finished = ipr_scan_finished,
-	.target_alloc = ipr_target_alloc,
 	.target_destroy = ipr_target_destroy,
 	.change_queue_depth = ipr_change_queue_depth,
 	.bios_param = ipr_biosparam,
@@ -6516,46 +6584,6 @@ static struct scsi_host_template driver_
 };
 
 /**
- * ipr_ata_phy_reset - libata phy_reset handler
- * @ap:		ata port to reset
- *
- **/
-static void ipr_ata_phy_reset(struct ata_port *ap)
-{
-	unsigned long flags;
-	struct ipr_sata_port *sata_port = ap->private_data;
-	struct ipr_resource_entry *res = sata_port->res;
-	struct ipr_ioa_cfg *ioa_cfg = sata_port->ioa_cfg;
-	int rc;
-
-	ENTER;
-	spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
-	while (ioa_cfg->in_reset_reload) {
-		spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
-		wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
-		spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
-	}
-
-	if (!ioa_cfg->hrrq[IPR_INIT_HRRQ].allow_cmds)
-		goto out_unlock;
-
-	rc = ipr_device_reset(ioa_cfg, res);
-
-	if (rc) {
-		ap->link.device[0].class = ATA_DEV_NONE;
-		goto out_unlock;
-	}
-
-	ap->link.device[0].class = res->ata_class;
-	if (ap->link.device[0].class == ATA_DEV_UNKNOWN)
-		ap->link.device[0].class = ATA_DEV_NONE;
-
-out_unlock:
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
-	LEAVE;
-}
-
-/**
  * ipr_ata_post_internal - Cleanup after an internal command
  * @qc:	ATA queued command
  *
@@ -6633,8 +6661,9 @@ static void ipr_sata_done(struct ipr_cmn
 	struct ipr_sata_port *sata_port = qc->ap->private_data;
 	struct ipr_resource_entry *res = sata_port->res;
 	u32 ioasc = be32_to_cpu(ipr_cmd->s.ioasa.hdr.ioasc);
+	unsigned long flags;
 
-	spin_lock(&ipr_cmd->hrrq->_lock);
+	spin_lock_irqsave(ipr_cmd->hrrq->lock, flags);
 	if (ipr_cmd->ioa_cfg->sis64)
 		memcpy(&sata_port->ioasa, &ipr_cmd->s.ioasa64.u.gata,
 		       sizeof(struct ipr_ioasa_gata));
@@ -6651,7 +6680,7 @@ static void ipr_sata_done(struct ipr_cmn
 	else
 		qc->err_mask |= ac_err_mask(sata_port->ioasa.status);
 	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
-	spin_unlock(&ipr_cmd->hrrq->_lock);
+	spin_unlock_irqrestore(ipr_cmd->hrrq->lock, flags);
 	ata_qc_complete(qc);
 }
 
@@ -6821,7 +6850,7 @@ static unsigned int ipr_qc_issue(struct
 		return AC_ERR_SYSTEM;
 	}
 
-	ipr_init_ipr_cmnd(ipr_cmd, ipr_lock_and_done);
+	ipr_init_ipr_cmnd(ipr_cmd, ipr_sata_done);
 	ioarcb = &ipr_cmd->ioarcb;
 
 	if (ioa_cfg->sis64) {
@@ -6911,16 +6940,22 @@ static bool ipr_qc_fill_rtf(struct ata_q
 	return true;
 }
 
+static void ipr_ata_end_eh(struct ata_port *ap) { }
+
 static struct ata_port_operations ipr_sata_ops = {
-	.phy_reset = ipr_ata_phy_reset,
+	.prereset		= ata_std_prereset,
 	.hardreset = ipr_sata_reset,
+	.postreset		= ata_std_postreset,
+	.error_handler	= ata_std_error_handler,
 	.post_internal_cmd = ipr_ata_post_internal,
 	.qc_prep = ata_noop_qc_prep,
 	.qc_defer = ipr_qc_defer,
 	.qc_issue = ipr_qc_issue,
 	.qc_fill_rtf = ipr_qc_fill_rtf,
 	.port_start = ata_sas_port_start,
-	.port_stop = ata_sas_port_stop
+	.port_stop = ata_sas_port_stop,
+	.sched_eh		= ata_std_sched_eh,
+	.end_eh		= ipr_ata_end_eh,
 };
 
 static struct ata_port_info sata_port_info = {
@@ -9392,6 +9427,7 @@ static void ipr_free_all_resources(struc
 	ipr_free_irqs(ioa_cfg);
 	if (ioa_cfg->reset_work_q)
 		destroy_workqueue(ioa_cfg->reset_work_q);
+	destroy_workqueue(ioa_cfg->sata_work_q);
 	iounmap(ioa_cfg->hdw_dma_regs);
 	pci_release_regions(pdev);
 	ipr_free_mem(ioa_cfg);
@@ -9989,6 +10025,7 @@ static int ipr_probe_ioa(struct pci_dev
 
 	ioa_cfg = (struct ipr_ioa_cfg *)host->hostdata;
 	memset(ioa_cfg, 0, sizeof(struct ipr_ioa_cfg));
+	host->transportt = &driver_transport;
 	ata_host_init(&ioa_cfg->ata_host, &pdev->dev, &ipr_sata_ops);
 
 	ioa_cfg->ipr_chip = ipr_get_chip_info(dev_id);
@@ -10207,6 +10244,14 @@ static int ipr_probe_ioa(struct pci_dev
 		goto cleanup_nolog;
 	}
 
+	ioa_cfg->sata_work_q = alloc_ordered_workqueue("ipr_sata_%d",
+							WQ_MEM_RECLAIM, host->host_no);
+
+	if (!ioa_cfg->sata_work_q) {
+		dev_err(&pdev->dev, "Couldn't register SATA workqueue\n");
+		goto out_free_irq;
+	}
+
 	if ((dev_id->driver_data & IPR_USE_PCI_WARM_RESET) ||
 	    (dev_id->device == PCI_DEVICE_ID_IBM_OBSIDIAN_E && !ioa_cfg->revid)) {
 		ioa_cfg->needs_warm_reset = 1;
@@ -10217,7 +10262,7 @@ static int ipr_probe_ioa(struct pci_dev
 
 		if (!ioa_cfg->reset_work_q) {
 			dev_err(&pdev->dev, "Couldn't register reset workqueue\n");
-			goto out_free_irq;
+			goto out_free_sata_work_q;
 		}
 	} else
 		ioa_cfg->reset = ipr_reset_start_bist;
@@ -10230,6 +10275,8 @@ static int ipr_probe_ioa(struct pci_dev
 out:
 	return rc;
 
+out_free_sata_work_q:
+	destroy_workqueue(ioa_cfg->sata_work_q);
 out_free_irq:
 	ipr_free_irqs(ioa_cfg);
 cleanup_nolog:
@@ -10290,7 +10337,8 @@ static void __ipr_remove(struct pci_dev
 {
 	unsigned long host_lock_flags = 0;
 	struct ipr_ioa_cfg *ioa_cfg = pci_get_drvdata(pdev);
-	int i;
+	struct ipr_resource_entry *res;
+	int i = 0;
 	unsigned long driver_lock_flags;
 	ENTER;
 
@@ -10299,6 +10347,20 @@ static void __ipr_remove(struct pci_dev
 		spin_unlock_irqrestore(ioa_cfg->host->host_lock, host_lock_flags);
 		wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
 		spin_lock_irqsave(ioa_cfg->host->host_lock, host_lock_flags);
+
+		list_for_each_entry(res, &ioa_cfg->used_res_q, queue) {
+			if (ipr_is_gata(res) && res->sata_port) {
+				res->del_from_ml = 1;
+				i++;
+			}
+		}
+
+		if (i) {
+			spin_unlock_irqrestore(ioa_cfg->host->host_lock, host_lock_flags);
+			schedule_work(&ioa_cfg->work_q);
+			flush_work(&ioa_cfg->work_q);
+			spin_lock_irqsave(ioa_cfg->host->host_lock, host_lock_flags);
+		}
 	}
 
 	for (i = 0; i < ioa_cfg->hrrq_num; i++) {
@@ -10314,6 +10376,7 @@ static void __ipr_remove(struct pci_dev
 	flush_work(&ioa_cfg->work_q);
 	if (ioa_cfg->reset_work_q)
 		flush_workqueue(ioa_cfg->reset_work_q);
+	flush_workqueue(ioa_cfg->sata_work_q);
 	INIT_LIST_HEAD(&ioa_cfg->used_res_q);
 	spin_lock_irqsave(ioa_cfg->host->host_lock, host_lock_flags);
 
diff -puN drivers/scsi/ipr.h~ipr_libata_api_change drivers/scsi/ipr.h
--- linux-2.6.git/drivers/scsi/ipr.h~ipr_libata_api_change	2016-06-10 15:51:43.867962480 -0500
+++ linux-2.6.git-bjking1/drivers/scsi/ipr.h	2016-06-10 15:51:43.876962373 -0500
@@ -1283,6 +1283,7 @@ struct ipr_sata_port {
 	struct ipr_ioa_cfg *ioa_cfg;
 	struct ata_port *ap;
 	struct ipr_resource_entry *res;
+	struct work_struct work;
 	struct ipr_ioasa_gata ioasa;
 };
 
@@ -1563,6 +1564,7 @@ struct ipr_ioa_cfg {
 
 	struct work_struct work_q;
 	struct workqueue_struct *reset_work_q;
+	struct workqueue_struct *sata_work_q;
 
 	wait_queue_head_t reset_wait_q;
 	wait_queue_head_t msi_wait_q;
_

