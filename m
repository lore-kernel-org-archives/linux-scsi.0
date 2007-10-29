From: Brian King <brking@linux.vnet.ibm.com>
Subject: [RFC 3/3] ipr: Use new libata EH API
Date: Mon, 29 Oct 2007 15:21:43 -0500
Message-ID: <472640D7.9010002@linux.vnet.ibm.com>
References: <47263F85.70908@linux.vnet.ibm.com> <47264016.9060603@linux.vnet.ibm.com> <47264065.3070602@linux.vnet.ibm.com>
Reply-To: brking@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <47264065.3070602@linux.vnet.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: brking@linux.vnet.ibm.com
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@SteelEye.com>
List-Id: linux-scsi@vger.kernel.org


This patch converts ipr to use the new libata EH API. This simplifies
a lot of the code, should make it more maintainable, and also provides
more robust error handling.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |  822 +++++++++++++++++++++++------------
 linux-2.6-bjking1/drivers/scsi/ipr.h |   15 
 2 files changed, 562 insertions(+), 275 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_sata_scsi_host2 drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_sata_scsi_host2	2007-10-29 13:04:12.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2007-10-29 14:26:24.000000000 -0500
@@ -613,6 +613,54 @@ static int ipr_set_pcix_cmd_reg(struct i
 }
 
 /**
+ * ipr_sata_qc_complete - Schedule completion of a SATA command
+ * @ioa_cfg:	ioa config struct
+ * @done_qc:	ATA qc to complete
+ *
+ * Return value:
+ * 	nothing
+ **/
+static void ipr_sata_qc_complete(struct ipr_ioa_cfg *ioa_cfg,
+				 struct ata_queued_cmd *done_qc)
+{
+	unsigned long flags;
+	struct ata_queued_cmd *qc;
+
+	spin_lock_irqsave(&ioa_cfg->qc_done_lock, flags);
+	if (!ioa_cfg->qc_done)
+		ioa_cfg->qc_done = done_qc;
+	else {
+		for (qc = ioa_cfg->qc_done; qc->lldd_task; qc = qc->lldd_task) {}
+		qc->lldd_task = done_qc;
+	}
+	spin_unlock_irqrestore(&ioa_cfg->qc_done_lock, flags);
+
+	tasklet_schedule(&ioa_cfg->tasklet);
+}
+
+/**
+ * ipr_sata_frozen_done - Done function for a SATA command on a frozen port
+ * @ipr_cmd:	ipr command struct
+ *
+ * Once one of our SATA ports is frozen by libata, we can no longer
+ * call ata_qc_complete for it. We change its ipr internal done function
+ * to this function to simply free up the ipr command struct.
+ *
+ * Return value:
+ * 	nothing
+ **/
+static void ipr_sata_frozen_done(struct ipr_cmnd *ipr_cmd)
+{
+	struct ata_queued_cmd *qc = ipr_cmd->qc;
+	struct ata_sas_rphy *rphy = dev_to_sata_rphy(qc->ap->dev);
+	struct ipr_sata_port *sata_port = rphy_to_sata_port(rphy);
+
+	ipr_cmd->ioa_cfg->request_limit++;
+	sata_port->active_requests--;
+	list_add_tail(&ipr_cmd->queue, &ipr_cmd->ioa_cfg->free_q);
+}
+
+/**
  * ipr_sata_eh_done - done function for aborted SATA commands
  * @ipr_cmd:	ipr command struct
  *
@@ -626,12 +674,15 @@ static void ipr_sata_eh_done(struct ipr_
 {
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 	struct ata_queued_cmd *qc = ipr_cmd->qc;
-	struct ipr_sata_port *sata_port = qc->ap->private_data;
+	struct ata_sas_rphy *rphy = dev_to_sata_rphy(qc->ap->dev);
+	struct ipr_sata_port *sata_port = rphy_to_sata_port(rphy);
 
 	qc->err_mask |= AC_ERR_OTHER;
 	sata_port->ioasa.status |= ATA_BUSY;
+	ioa_cfg->request_limit++;
+	sata_port->active_requests--;
 	list_add_tail(&ipr_cmd->queue, &ioa_cfg->free_q);
-	ata_qc_complete(qc);
+	ipr_sata_qc_complete(ioa_cfg, qc);
 }
 
 /**
@@ -652,6 +703,7 @@ static void ipr_scsi_eh_done(struct ipr_
 	scsi_cmd->result |= (DID_ERROR << 16);
 
 	scsi_dma_unmap(ipr_cmd->scsi_cmd);
+	ioa_cfg->request_limit++;
 	scsi_cmd->scsi_done(scsi_cmd);
 	list_add_tail(&ipr_cmd->queue, &ioa_cfg->free_q);
 }
@@ -2351,6 +2403,187 @@ static void ipr_release_dump(struct kref
 }
 
 /**
+ * ipr_show_sata_adapter_address - Show the adapter's resource address for this device
+ * @class_dev:	class device struct
+ * @buf:		buffer
+ *
+ * Return value:
+ * 	number of bytes printed to buffer
+ **/
+static ssize_t ipr_show_sata_adapter_address(struct class_device *class_dev, char *buf)
+{
+	struct Scsi_Host *host = class_to_shost(class_dev);
+	struct ata_port *ap = ata_shost_to_port(host);
+	struct ata_sas_rphy *rphy = dev_to_sata_rphy(ap->dev);
+	struct ipr_sata_port *sata_port = rphy_to_sata_port(rphy);
+	struct ipr_ioa_cfg *ioa_cfg = sata_port->ioa_cfg;
+	ssize_t len = -ENXIO;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
+	if (sata_port && sata_port->res)
+		len = snprintf(buf, PAGE_SIZE, "%d:%d:%d:%d\n",
+			       ioa_cfg->host->host_no,
+			       sata_port->res->cfgte.res_addr.bus,
+			       sata_port->res->cfgte.res_addr.target,
+			       sata_port->res->cfgte.res_addr.lun);
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
+	return len;
+}
+
+static struct class_device_attribute ipr_sata_adapter_address_attr = {
+	.attr = {
+		.name = 	"adapter_address",
+		.mode =		S_IRUSR,
+	},
+	.show = ipr_show_sata_adapter_address
+};
+
+/**
+ * ipr_show_sata_adapter_handle - Show the adapter's resource handle for this SATA rphy
+ * @class_dev:	class device struct
+ * @buf:		buffer
+ *
+ * Return value:
+ * 	number of bytes printed to buffer
+ **/
+static ssize_t ipr_show_sata_adapter_handle(struct class_device *class_dev, char *buf)
+{
+	struct Scsi_Host *host = class_to_shost(class_dev);
+	struct ata_port *ap = ata_shost_to_port(host);
+	struct ata_sas_rphy *rphy = dev_to_sata_rphy(ap->dev);
+	struct ipr_sata_port *sata_port = rphy_to_sata_port(rphy);
+	struct ipr_ioa_cfg *ioa_cfg = sata_port->ioa_cfg;
+	ssize_t len = -ENXIO;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
+	if (sata_port && sata_port->res)
+		len = snprintf(buf, PAGE_SIZE, "%08X\n", sata_port->res->cfgte.res_handle);
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
+	return len;
+}
+
+static struct class_device_attribute ipr_sata_adapter_handle_attr = {
+	.attr = {
+		.name = 	"adapter_handle",
+		.mode =		S_IRUSR,
+	},
+	.show = ipr_show_sata_adapter_handle
+};
+
+static struct class_device_attribute *ipr_sata_attrs[] = {
+	&ipr_sata_adapter_handle_attr,
+	&ipr_sata_adapter_address_attr,
+	NULL,
+};
+
+/**
+ * ipr_sata_info - Get information about the sata port
+ * @scsi_host:	scsi host struct
+ *
+ * Return value:
+ * 	pointer to buffer with description string
+ **/
+static const char * ipr_sata_info(struct Scsi_Host *host)
+{
+	static char buffer[512];
+	struct ata_port *ap = ata_shost_to_port(host);
+	struct ata_sas_rphy *rphy = dev_to_sata_rphy(ap->dev);
+	struct ipr_sata_port *sata_port = rphy_to_sata_port(rphy);
+	struct ipr_ioa_cfg *ioa_cfg = sata_port->ioa_cfg;
+	struct ipr_resource_entry *res = sata_port->res;
+
+	sprintf(buffer, "IBM %X Storage Adapter SATA Port: %d:%d:%d:%d",
+		ioa_cfg->type, ioa_cfg->host->host_no, res->cfgte.res_addr.bus,
+		res->cfgte.res_addr.target, res->cfgte.res_addr.lun);
+
+	return buffer;
+}
+
+static struct ata_port_info sata_port_info;
+
+static struct scsi_host_template sata_driver_template = {
+	.module = THIS_MODULE,
+	.name = "IPR",
+	.info = ipr_sata_info,
+	.ioctl = ata_scsi_ioctl,
+	.queuecommand = ata_scsi_queuecmd,
+	.slave_configure = ata_scsi_slave_config,
+	.slave_destroy = ata_scsi_slave_destroy,
+	.change_queue_depth = ata_scsi_change_queue_depth,
+	.bios_param = ata_std_bios_param,
+	.can_queue = 1,
+	.this_id = -1,
+	.sg_tablesize = IPR_MAX_SGLIST,
+	.max_sectors = IPR_IOA_MAX_SECTORS,
+	.cmd_per_lun = 1,
+	.emulated = ATA_SHT_EMULATED,
+	.use_clustering = ENABLE_CLUSTERING,
+	.shost_attrs = ipr_sata_attrs,
+	.proc_name = IPR_NAME
+};
+
+/**
+ * ipr_add_sata_dev - Add a SATA device
+ * @ioa_cfg:	ioa config struct
+ * @res:		resource entry struct
+ *
+ * This function adds a SATA rphy to the device hierarchy.
+ *
+ * Return value:
+ * 	nothing
+ **/
+static void ipr_add_sata_dev(struct ipr_ioa_cfg *ioa_cfg,
+			     struct ipr_resource_entry *res)
+{
+	int rc;
+	unsigned long flags;
+	struct ata_sas_rphy *rphy;
+	struct device *dev;
+	struct ipr_sata_port *sata_port;
+
+	rphy = ata_sas_rphy_alloc(&ioa_cfg->host->shost_gendev,
+				  &ioa_cfg->pdev->dev, &sata_port_info,
+				  sizeof(*sata_port));
+
+	if (!rphy)
+		return;
+
+	sata_port = rphy_to_sata_port(rphy);
+	spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
+	if (!ipr_is_gata(res)) {
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
+		ata_sas_rphy_free(rphy);
+		return;
+	}
+
+	sata_port->ioa_cfg = ioa_cfg;
+	sata_port->res = res;
+	res->sata_port = sata_port;
+	res->add_to_ml = 0;
+	list_add_tail(&sata_port->queue, &ioa_cfg->sata_ports);
+
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
+
+	rc = ata_sas_rphy_add(rphy, &sata_driver_template);
+
+	if (rc) {
+		spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
+		dev = get_device(&sata_port->rphy.dev);
+		list_del(&sata_port->queue);
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
+
+		ata_sas_rphy_free(rphy);
+
+		spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
+		sata_port->res->sata_port = NULL;
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
+		put_device(dev);
+	}
+}
+
+/**
  * ipr_worker_thread - Worker thread
  * @work:		ioa config struct
  *
@@ -2366,11 +2599,12 @@ static void ipr_worker_thread(struct wor
 	unsigned long lock_flags;
 	struct ipr_resource_entry *res;
 	struct scsi_device *sdev;
+	struct device *dev;
 	struct ipr_dump *dump;
+	struct ipr_sata_port *sata_port;
 	struct ipr_ioa_cfg *ioa_cfg =
 		container_of(work, struct ipr_ioa_cfg, work_q);
 	u8 bus, target, lun;
-	int did_work;
 
 	ENTER;
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
@@ -2394,42 +2628,64 @@ static void ipr_worker_thread(struct wor
 	}
 
 restart:
-	do {
-		did_work = 0;
-		if (!ioa_cfg->allow_cmds || !ioa_cfg->allow_ml_add_del) {
-			spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-			return;
-		}
+	if (!ioa_cfg->allow_cmds || !ioa_cfg->allow_ml_add_del) {
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		return;
+	}
 
-		list_for_each_entry(res, &ioa_cfg->used_res_q, queue) {
-			if (res->del_from_ml && res->sdev) {
-				did_work = 1;
-				sdev = res->sdev;
-				if (!scsi_device_get(sdev)) {
-					list_move_tail(&res->queue, &ioa_cfg->free_res_q);
-					spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-					scsi_remove_device(sdev);
-					scsi_device_put(sdev);
-					spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
-				}
-				break;
+	list_for_each_entry(res, &ioa_cfg->used_res_q, queue) {
+		if (res->del_from_ml && res->sdev) {
+			sdev = res->sdev;
+			if (!scsi_device_get(sdev)) {
+				list_move_tail(&res->queue, &ioa_cfg->free_res_q);
+				spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+				scsi_remove_device(sdev);
+				scsi_device_put(sdev);
+				spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 			}
+			goto restart;
 		}
-	} while(did_work);
+	}
 
-	list_for_each_entry(res, &ioa_cfg->used_res_q, queue) {
-		if (res->add_to_ml) {
-			bus = res->cfgte.res_addr.bus;
-			target = res->cfgte.res_addr.target;
-			lun = res->cfgte.res_addr.lun;
-			res->add_to_ml = 0;
+	list_for_each_entry(sata_port, &ioa_cfg->sata_ports, queue) {
+		if (sata_port->res->del_from_ml) {
+			dev = get_device(&sata_port->rphy.dev);
+			list_del(&sata_port->queue);
 			spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-			scsi_add_device(ioa_cfg->host, bus, target, lun);
+
+			ata_sas_rphy_delete(&sata_port->rphy);
+
+			spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+			sata_port->res->sata_port = NULL;
+			list_move_tail(&sata_port->res->queue, &ioa_cfg->free_res_q);
+			spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+
+			put_device(dev);
 			spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 			goto restart;
 		}
 	}
 
+	list_for_each_entry(res, &ioa_cfg->used_res_q, queue) {
+		if (res->add_to_ml) {
+			if (ipr_is_gata(res)) {
+				spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+				ipr_add_sata_dev(ioa_cfg, res);
+				spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+			} else {
+				bus = res->cfgte.res_addr.bus;
+				target = res->cfgte.res_addr.target;
+				lun = res->cfgte.res_addr.lun;
+				res->add_to_ml = 0;
+				spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+				scsi_add_device(ioa_cfg->host, bus, target, lun);
+				spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+			}
+
+			goto restart;
+		}
+	}
+
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 	kobject_uevent(&ioa_cfg->host->shost_classdev.kobj, KOBJ_CHANGE);
 	LEAVE;
@@ -3366,17 +3622,6 @@ static int ipr_free_dump(struct ipr_ioa_
  **/
 static int ipr_change_queue_depth(struct scsi_device *sdev, int qdepth)
 {
-	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *)sdev->host->hostdata;
-	struct ipr_resource_entry *res;
-	unsigned long lock_flags = 0;
-
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
-	res = (struct ipr_resource_entry *)sdev->hostdata;
-
-	if (res && ipr_is_gata(res) && qdepth > IPR_MAX_CMD_PER_ATA_LUN)
-		qdepth = IPR_MAX_CMD_PER_ATA_LUN;
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-
 	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
 	return sdev->queue_depth;
 }
@@ -3492,100 +3737,6 @@ static int ipr_biosparam(struct scsi_dev
 }
 
 /**
- * ipr_find_starget - Find target based on bus/target.
- * @starget:	scsi target struct
- *
- * Return value:
- * 	resource entry pointer if found / NULL if not found
- **/
-static struct ipr_resource_entry *ipr_find_starget(struct scsi_target *starget)
-{
-	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
-	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *) shost->hostdata;
-	struct ipr_resource_entry *res;
-
-	list_for_each_entry(res, &ioa_cfg->used_res_q, queue) {
-		if ((res->cfgte.res_addr.bus == starget->channel) &&
-		    (res->cfgte.res_addr.target == starget->id) &&
-		    (res->cfgte.res_addr.lun == 0)) {
-			return res;
-		}
-	}
-
-	return NULL;
-}
-
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
-/**
- * ipr_target_destroy - Destroy a SCSI target
- * @starget:	scsi target struct
- *
- * If the device was a SATA device, this function frees the libata
- * ATA port, else it does nothing.
- *
- **/
-static void ipr_target_destroy(struct scsi_target *starget)
-{
-	struct ipr_sata_port *sata_port = starget->hostdata;
-
-	if (sata_port) {
-		starget->hostdata = NULL;
-		ata_sas_port_destroy(sata_port->ap);
-		kfree(sata_port);
-	}
-}
-
-/**
  * ipr_find_sdev - Find device based on bus/target/lun.
  * @sdev:	scsi device struct
  *
@@ -3625,11 +3776,8 @@ static void ipr_slave_destroy(struct scs
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 	res = (struct ipr_resource_entry *) sdev->hostdata;
 	if (res) {
-		if (res->sata_port)
-			ata_port_disable(res->sata_port->ap);
 		sdev->hostdata = NULL;
 		res->sdev = NULL;
-		res->sata_port = NULL;
 	}
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 }
@@ -3664,45 +3812,13 @@ static int ipr_slave_configure(struct sc
 		}
 		if (ipr_is_vset_device(res) || ipr_is_scsi_disk(res))
 			sdev->allow_restart = 1;
-		if (ipr_is_gata(res) && res->sata_port) {
-			scsi_adjust_queue_depth(sdev, 0, IPR_MAX_CMD_PER_ATA_LUN);
-			ata_sas_slave_configure(sdev, res->sata_port->ap);
-		} else {
-			scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
-		}
+		scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
 	}
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 	return 0;
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
-	if (sata_port)
-		rc = ata_sas_port_init(sata_port->ap);
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
@@ -3726,7 +3842,7 @@ static int ipr_slave_alloc(struct scsi_d
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 
 	res = ipr_find_sdev(sdev);
-	if (res) {
+	if (res && !ipr_is_gata(res)) {
 		res->sdev = sdev;
 		res->add_to_ml = 0;
 		res->in_erp = 0;
@@ -3734,10 +3850,6 @@ static int ipr_slave_alloc(struct scsi_d
 		if (!ipr_is_naca_model(res))
 			res->needs_sync_complete = 1;
 		rc = 0;
-		if (ipr_is_gata(res)) {
-			spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-			return ipr_ata_slave_alloc(sdev);
-		}
 	}
 
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
@@ -3845,7 +3957,8 @@ static int ipr_device_reset(struct ipr_i
 static int ipr_sata_reset(struct ata_link *link, unsigned int *classes,
 				unsigned long deadline)
 {
-	struct ipr_sata_port *sata_port = link->ap->private_data;
+	struct ata_sas_rphy *rphy = dev_to_sata_rphy(link->ap->dev);
+	struct ipr_sata_port *sata_port = rphy_to_sata_port(rphy);
 	struct ipr_ioa_cfg *ioa_cfg = sata_port->ioa_cfg;
 	struct ipr_resource_entry *res;
 	unsigned long lock_flags = 0;
@@ -3859,9 +3972,21 @@ static int ipr_sata_reset(struct ata_lin
 		spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 	}
 
+	if (!ioa_cfg->request_limit) {
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		return -EIO;
+	}
+
 	res = sata_port->res;
 	if (res) {
+		ioa_cfg->request_limit--;
+		sata_port->active_requests++;
+
 		rc = ipr_device_reset(ioa_cfg, res);
+
+		ioa_cfg->request_limit++;
+		sata_port->active_requests--;
+
 		switch(res->cfgte.proto) {
 		case IPR_PROTO_SATA:
 		case IPR_PROTO_SAS_STP:
@@ -3898,7 +4023,6 @@ static int __ipr_eh_dev_reset(struct scs
 	struct ipr_cmnd *ipr_cmd;
 	struct ipr_ioa_cfg *ioa_cfg;
 	struct ipr_resource_entry *res;
-	struct ata_port *ap;
 	int rc = 0;
 
 	ENTER;
@@ -3917,37 +4041,19 @@ static int __ipr_eh_dev_reset(struct scs
 		return FAILED;
 	if (ioa_cfg->ioa_is_dead)
 		return FAILED;
+	if (ipr_is_gata(res))
+		return FAILED;
 
 	list_for_each_entry(ipr_cmd, &ioa_cfg->pending_q, queue) {
 		if (ipr_cmd->ioarcb.res_handle == res->cfgte.res_handle) {
 			if (ipr_cmd->scsi_cmd)
 				ipr_cmd->done = ipr_scsi_eh_done;
-			if (ipr_cmd->qc)
-				ipr_cmd->done = ipr_sata_eh_done;
-			if (ipr_cmd->qc && !(ipr_cmd->qc->flags & ATA_QCFLAG_FAILED)) {
-				ipr_cmd->qc->err_mask |= AC_ERR_TIMEOUT;
-				ipr_cmd->qc->flags |= ATA_QCFLAG_FAILED;
-			}
 		}
 	}
 
 	res->resetting_device = 1;
 	scmd_printk(KERN_ERR, scsi_cmd, "Resetting device\n");
-
-	if (ipr_is_gata(res) && res->sata_port) {
-		ap = res->sata_port->ap;
-		spin_unlock_irq(scsi_cmd->device->host->host_lock);
-		ata_do_eh(ap, NULL, NULL, ipr_sata_reset, NULL);
-		spin_lock_irq(scsi_cmd->device->host->host_lock);
-
-		list_for_each_entry(ipr_cmd, &ioa_cfg->pending_q, queue) {
-			if (ipr_cmd->ioarcb.res_handle == res->cfgte.res_handle) {
-				rc = -EIO;
-				break;
-			}
-		}
-	} else
-		rc = ipr_device_reset(ioa_cfg, res);
+	rc = ipr_device_reset(ioa_cfg, res);
 	res->resetting_device = 0;
 
 	LEAVE;
@@ -4389,6 +4495,7 @@ static void ipr_erp_done(struct ipr_cmnd
 		res->in_erp = 0;
 	}
 	scsi_dma_unmap(ipr_cmd->scsi_cmd);
+	ioa_cfg->request_limit++;
 	list_add_tail(&ipr_cmd->queue, &ioa_cfg->free_q);
 	scsi_cmd->scsi_done(scsi_cmd);
 }
@@ -4767,6 +4874,7 @@ static void ipr_erp_start(struct ipr_ioa
 	}
 
 	scsi_dma_unmap(ipr_cmd->scsi_cmd);
+	ioa_cfg->request_limit++;
 	list_add_tail(&ipr_cmd->queue, &ioa_cfg->free_q);
 	scsi_cmd->scsi_done(scsi_cmd);
 }
@@ -4791,6 +4899,7 @@ static void ipr_scsi_done(struct ipr_cmn
 
 	if (likely(IPR_IOASC_SENSE_KEY(ioasc) == 0)) {
 		scsi_dma_unmap(ipr_cmd->scsi_cmd);
+		ioa_cfg->request_limit++;
 		list_add_tail(&ipr_cmd->queue, &ioa_cfg->free_q);
 		scsi_cmd->scsi_done(scsi_cmd);
 	} else
@@ -4842,8 +4951,8 @@ static int ipr_queuecommand(struct scsi_
 		return 0;
 	}
 
-	if (ipr_is_gata(res) && res->sata_port)
-		return ata_sas_queuecmd(scsi_cmd, done, res->sata_port->ap);
+	if (!ioa_cfg->request_limit)
+		return SCSI_MLQUEUE_HOST_BUSY;
 
 	ipr_cmd = ipr_get_free_ipr_cmnd(ioa_cfg);
 	ioarcb = &ipr_cmd->ioarcb;
@@ -4878,6 +4987,7 @@ static int ipr_queuecommand(struct scsi_
 		rc = ipr_build_ioadl(ioa_cfg, ipr_cmd);
 
 	if (likely(rc == 0)) {
+		ioa_cfg->request_limit--;
 		mb();
 		writel(be32_to_cpu(ipr_cmd->ioarcb.ioarcb_host_pci_addr),
 		       ioa_cfg->regs.ioarrin_reg);
@@ -4890,26 +5000,6 @@ static int ipr_queuecommand(struct scsi_
 }
 
 /**
- * ipr_ioctl - IOCTL handler
- * @sdev:	scsi device struct
- * @cmd:	IOCTL cmd
- * @arg:	IOCTL arg
- *
- * Return value:
- * 	0 on success / other on failure
- **/
-static int ipr_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
-{
-	struct ipr_resource_entry *res;
-
-	res = (struct ipr_resource_entry *)sdev->hostdata;
-	if (res && ipr_is_gata(res))
-		return ata_scsi_ioctl(sdev, cmd, arg);
-
-	return -EINVAL;
-}
-
-/**
  * ipr_info - Get information about the card/driver
  * @scsi_host:	scsi host struct
  *
@@ -4935,7 +5025,6 @@ static struct scsi_host_template driver_
 	.module = THIS_MODULE,
 	.name = "IPR",
 	.info = ipr_ioa_info,
-	.ioctl = ipr_ioctl,
 	.queuecommand = ipr_queuecommand,
 	.eh_abort_handler = ipr_eh_abort,
 	.eh_device_reset_handler = ipr_eh_dev_reset,
@@ -4943,8 +5032,6 @@ static struct scsi_host_template driver_
 	.slave_alloc = ipr_slave_alloc,
 	.slave_configure = ipr_slave_configure,
 	.slave_destroy = ipr_slave_destroy,
-	.target_alloc = ipr_target_alloc,
-	.target_destroy = ipr_target_destroy,
 	.change_queue_depth = ipr_change_queue_depth,
 	.change_queue_type = ipr_change_queue_type,
 	.bios_param = ipr_biosparam,
@@ -4960,56 +5047,118 @@ static struct scsi_host_template driver_
 };
 
 /**
- * ipr_ata_phy_reset - libata phy_reset handler
- * @ap:		ata port to reset
+ * ipr_tasklet - ipr tasklet for deferred interrupt processing
+ * @data:	ioa_config struct
+ *
+ * Call ata_qc_complete on any completed ATA commands.
  *
+ * Return value:
+ * 	none
  **/
-static void ipr_ata_phy_reset(struct ata_port *ap)
+static void ipr_tasklet(unsigned long data)
 {
+	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *)data;
 	unsigned long flags;
-	struct ipr_sata_port *sata_port = ap->private_data;
-	struct ipr_resource_entry *res = sata_port->res;
+	struct ata_port *ap;
+	struct ata_queued_cmd *qc, *next_qc = NULL;
+
+	spin_lock_irqsave(&ioa_cfg->qc_done_lock, flags);
+	qc = ioa_cfg->qc_done;
+	ioa_cfg->qc_done = NULL;
+	spin_unlock_irqrestore(&ioa_cfg->qc_done_lock, flags);
+
+	while (qc) {
+		next_qc = qc->lldd_task;
+		ap = qc->ap;
+		spin_lock_irqsave(ap->lock, flags);
+		ata_qc_complete(qc);
+		spin_unlock_irqrestore(ap->lock, flags);
+		qc = next_qc;
+	}
+}
+
+/**
+ * ipr_sata_error_handler - libata error handler
+ * @ap:	ATA port to perform error recovery on
+ *
+ * Return value:
+ * 	none
+ **/
+static void ipr_sata_error_handler(struct ata_port *ap)
+{
+	struct ata_sas_rphy *rphy = dev_to_sata_rphy(ap->dev);
+	struct ipr_sata_port *sata_port = rphy_to_sata_port(rphy);
 	struct ipr_ioa_cfg *ioa_cfg = sata_port->ioa_cfg;
-	int rc;
+	struct ipr_cmnd *ipr_cmd;
+	unsigned long flags;
 
-	ENTER;
+	ata_do_eh(ap, NULL, NULL, ipr_sata_reset, NULL);
+
+	/* If commands are still outstanding, reset the adapter */
 	spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
-	while(ioa_cfg->in_reset_reload) {
-		spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
-		wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
-		spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
+	list_for_each_entry(ipr_cmd, &ioa_cfg->pending_q, queue) {
+		if (ipr_cmd->qc && ipr_cmd->qc->ap == ap) {
+			ipr_reset_reload(ioa_cfg, IPR_SHUTDOWN_ABBREV);
+			break;
+		}
 	}
 
-	if (!ioa_cfg->allow_cmds)
-		goto out_unlock;
+	ioa_cfg->request_limit += sata_port->active_requests;
+	sata_port->active_requests = 0;
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
+}
 
-	rc = ipr_device_reset(ioa_cfg, res);
+/**
+ * ipr_sata_freeze - libata freeze handler
+ * @ap:	ATA port to freeze
+ *
+ * Since ipr does not have the ability to freeze a port like a
+ * SATA adapter can, we simply ensure we never call ata_qc_complete for
+ * any commands that are still outstanding to this ATA port.
+ *
+ * Return value:
+ * 	none
+ **/
+static void ipr_sata_freeze(struct ata_port *ap)
+{
+	struct ata_sas_rphy *rphy = dev_to_sata_rphy(ap->dev);
+	struct ipr_sata_port *sata_port = rphy_to_sata_port(rphy);
+	struct ipr_ioa_cfg *ioa_cfg = sata_port->ioa_cfg;
+	struct ipr_cmnd *ipr_cmd;
+	struct ata_queued_cmd *sqc, *dqc, *qc;
+	unsigned long flags;
 
-	if (rc) {
-		ata_port_disable(ap);
-		goto out_unlock;
+	ENTER;
+	spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
+	list_for_each_entry(ipr_cmd, &ioa_cfg->pending_q, queue) {
+		if (ipr_cmd->qc && ipr_cmd->qc->ap == ap)
+			ipr_cmd->done = ipr_sata_frozen_done;
 	}
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
 
-	switch(res->cfgte.proto) {
-	case IPR_PROTO_SATA:
-	case IPR_PROTO_SAS_STP:
-		ap->link.device[0].class = ATA_DEV_ATA;
-		break;
-	case IPR_PROTO_SATA_ATAPI:
-	case IPR_PROTO_SAS_STP_ATAPI:
-		ap->link.device[0].class = ATA_DEV_ATAPI;
-		break;
-	default:
-		ap->link.device[0].class = ATA_DEV_UNKNOWN;
-		ata_port_disable(ap);
-		break;
-	};
+	spin_lock_irqsave(&ioa_cfg->qc_done_lock, flags);
+	sqc = ioa_cfg->qc_done;
+	ioa_cfg->qc_done = NULL;
+	dqc = NULL;
+	for (qc = sqc; qc; qc = qc->lldd_task) {
+		if (qc->ap != ap) {
+			if (!dqc)
+				ioa_cfg->qc_done = qc;
+			else
+				dqc->lldd_task = qc;
+			dqc = qc;
+		}
+	}
+
+	if (dqc)
+		dqc->lldd_task = NULL;
+	spin_unlock_irqrestore(&ioa_cfg->qc_done_lock, flags);
 
-out_unlock:
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
 	LEAVE;
 }
 
+static void ipr_sata_thaw(struct ata_port *ap) { }
+
 /**
  * ipr_ata_post_internal - Cleanup after an internal command
  * @qc:	ATA queued command
@@ -5019,7 +5168,9 @@ out_unlock:
  **/
 static void ipr_ata_post_internal(struct ata_queued_cmd *qc)
 {
-	struct ipr_sata_port *sata_port = qc->ap->private_data;
+	struct ata_port *ap = qc->ap;
+	struct ata_sas_rphy *rphy = dev_to_sata_rphy(ap->dev);
+	struct ipr_sata_port *sata_port = rphy_to_sata_port(rphy);
 	struct ipr_ioa_cfg *ioa_cfg = sata_port->ioa_cfg;
 	struct ipr_cmnd *ipr_cmd;
 	unsigned long flags;
@@ -5032,11 +5183,28 @@ static void ipr_ata_post_internal(struct
 	}
 
 	list_for_each_entry(ipr_cmd, &ioa_cfg->pending_q, queue) {
-		if (ipr_cmd->qc == qc) {
+		if (ipr_cmd->qc == qc && ioa_cfg->request_limit) {
+			ioa_cfg->request_limit--;
+			sata_port->active_requests++;
+
 			ipr_device_reset(ioa_cfg, sata_port->res);
+
+			ioa_cfg->request_limit++;
+			sata_port->active_requests--;
 			break;
 		}
 	}
+
+	/* If command is still outstanding, reset the adapter */
+	list_for_each_entry(ipr_cmd, &ioa_cfg->pending_q, queue) {
+		if (ipr_cmd->qc == qc) {
+			ipr_reset_reload(ioa_cfg, IPR_SHUTDOWN_ABBREV);
+			break;
+		}
+	}
+
+	ioa_cfg->request_limit += sata_port->active_requests;
+	sata_port->active_requests = 0;
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
 }
 
@@ -5050,9 +5218,13 @@ static void ipr_ata_post_internal(struct
  **/
 static void ipr_tf_read(struct ata_port *ap, struct ata_taskfile *tf)
 {
-	struct ipr_sata_port *sata_port = ap->private_data;
+	struct ata_sas_rphy *rphy = dev_to_sata_rphy(ap->dev);
+	struct ipr_sata_port *sata_port = rphy_to_sata_port(rphy);
+	struct ipr_ioa_cfg *ioa_cfg = sata_port->ioa_cfg;
 	struct ipr_ioasa_gata *g = &sata_port->ioasa;
+	unsigned long flags;
 
+	spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
 	tf->feature = g->error;
 	tf->nsect = g->nsect;
 	tf->lbal = g->lbal;
@@ -5065,6 +5237,7 @@ static void ipr_tf_read(struct ata_port 
 	tf->hob_lbam = g->hob_lbam;
 	tf->hob_lbah = g->hob_lbah;
 	tf->ctl = g->alt_status;
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
 }
 
 /**
@@ -5107,7 +5280,8 @@ static void ipr_sata_done(struct ipr_cmn
 {
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 	struct ata_queued_cmd *qc = ipr_cmd->qc;
-	struct ipr_sata_port *sata_port = qc->ap->private_data;
+	struct ata_sas_rphy *rphy = dev_to_sata_rphy(qc->ap->dev);
+	struct ipr_sata_port *sata_port = rphy_to_sata_port(rphy);
 	struct ipr_resource_entry *res = sata_port->res;
 	u32 ioasc = be32_to_cpu(ipr_cmd->ioasa.ioasc);
 
@@ -5116,15 +5290,17 @@ static void ipr_sata_done(struct ipr_cmn
 	ipr_dump_ioasa(ioa_cfg, ipr_cmd, res);
 
 	if (be32_to_cpu(ipr_cmd->ioasa.ioasc_specific) & IPR_ATA_DEVICE_WAS_RESET)
-		scsi_report_device_reset(ioa_cfg->host, res->cfgte.res_addr.bus,
-					 res->cfgte.res_addr.target);
+		scsi_report_device_reset(qc->ap->scsi_host, qc->dev->sdev->channel,
+					 qc->dev->sdev->id);
 
 	if (IPR_IOASC_SENSE_KEY(ioasc) > RECOVERED_ERROR)
 		qc->err_mask |= __ac_err_mask(ipr_cmd->ioasa.u.gata.status);
 	else
 		qc->err_mask |= ac_err_mask(ipr_cmd->ioasa.u.gata.status);
+	ioa_cfg->request_limit++;
+	sata_port->active_requests--;
 	list_add_tail(&ipr_cmd->queue, &ioa_cfg->free_q);
-	ata_qc_complete(qc);
+	ipr_sata_qc_complete(ioa_cfg, qc);
 }
 
 /**
@@ -5172,6 +5348,34 @@ static void ipr_build_ata_ioadl(struct i
 }
 
 /**
+ * ipr_sata_qc_defer - Check to see if a qc needs to be deferred
+ * @qc:	queued command
+ *
+ * Return value:
+ * 	0 if success, ATA_DEFER_PORT is qc needs to be deferred
+ **/
+static int ipr_sata_qc_defer(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct ata_sas_rphy *rphy = dev_to_sata_rphy(ap->dev);
+	struct ipr_sata_port *sata_port = rphy_to_sata_port(rphy);
+	struct ipr_ioa_cfg *ioa_cfg = sata_port->ioa_cfg;
+	unsigned long flags;
+
+	spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
+	if (unlikely(!ioa_cfg->request_limit ||
+		     (!ioa_cfg->allow_cmds && !ioa_cfg->ioa_is_dead))) {
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
+		return ATA_DEFER_PORT;
+	}
+
+	ioa_cfg->request_limit--;
+	sata_port->active_requests++;
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
+	return 0;
+}
+
+/**
  * ipr_qc_issue - Issue a SATA qc to a device
  * @qc:	queued command
  *
@@ -5181,15 +5385,25 @@ static void ipr_build_ata_ioadl(struct i
 static unsigned int ipr_qc_issue(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
-	struct ipr_sata_port *sata_port = ap->private_data;
+	struct ata_sas_rphy *rphy = dev_to_sata_rphy(ap->dev);
+	struct ipr_sata_port *sata_port = rphy_to_sata_port(rphy);
 	struct ipr_resource_entry *res = sata_port->res;
 	struct ipr_ioa_cfg *ioa_cfg = sata_port->ioa_cfg;
 	struct ipr_cmnd *ipr_cmd;
 	struct ipr_ioarcb *ioarcb;
 	struct ipr_ioarcb_ata_regs *regs;
+	unsigned long flags;
+
+	spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
+	if (unlikely(!ioa_cfg->allow_cmds || ioa_cfg->ioa_is_dead)) {
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
+		return AC_ERR_SYSTEM;
+	}
 
-	if (unlikely(!ioa_cfg->allow_cmds || ioa_cfg->ioa_is_dead))
+	if (qc->tag == ATA_TAG_INTERNAL && !ioa_cfg->request_limit) {
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
 		return AC_ERR_SYSTEM;
+	}
 
 	ipr_cmd = ipr_get_free_ipr_cmnd(ioa_cfg);
 	ioarcb = &ipr_cmd->ioarcb;
@@ -5206,6 +5420,7 @@ static unsigned int ipr_qc_issue(struct 
 	ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_NO_LINK_DESC;
 	ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_NO_ULEN_CHK;
 	ipr_cmd->dma_use_sg = qc->pad_len ? qc->n_elem + 1 : qc->n_elem;
+	qc->lldd_task = NULL;
 
 	ipr_build_ata_ioadl(ipr_cmd, qc);
 	regs->flags |= IPR_ATA_FLAG_STATUS_ON_GOOD_COMPLETION;
@@ -5234,12 +5449,18 @@ static unsigned int ipr_qc_issue(struct 
 
 	default:
 		WARN_ON(1);
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
 		return AC_ERR_INVALID;
 	}
 
+	if (qc->tag == ATA_TAG_INTERNAL) {
+		ioa_cfg->request_limit--;
+		sata_port->active_requests++;
+	}
 	mb();
 	writel(be32_to_cpu(ioarcb->ioarcb_host_pci_addr),
 	       ioa_cfg->regs.ioarrin_reg);
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
 	return 0;
 }
 
@@ -5252,7 +5473,8 @@ static unsigned int ipr_qc_issue(struct 
  **/
 static u8 ipr_ata_check_status(struct ata_port *ap)
 {
-	struct ipr_sata_port *sata_port = ap->private_data;
+	struct ata_sas_rphy *rphy = dev_to_sata_rphy(ap->dev);
+	struct ipr_sata_port *sata_port = rphy_to_sata_port(rphy);
 	return sata_port->ioasa.status;
 }
 
@@ -5265,7 +5487,8 @@ static u8 ipr_ata_check_status(struct at
  **/
 static u8 ipr_ata_check_altstatus(struct ata_port *ap)
 {
-	struct ipr_sata_port *sata_port = ap->private_data;
+	struct ata_sas_rphy *rphy = dev_to_sata_rphy(ap->dev);
+	struct ipr_sata_port *sata_port = rphy_to_sata_port(rphy);
 	return sata_port->ioasa.alt_status;
 }
 
@@ -5273,13 +5496,16 @@ static struct ata_port_operations ipr_sa
 	.check_status = ipr_ata_check_status,
 	.check_altstatus = ipr_ata_check_altstatus,
 	.dev_select = ata_noop_dev_select,
-	.phy_reset = ipr_ata_phy_reset,
+	.error_handler = ipr_sata_error_handler,
+	.freeze = ipr_sata_freeze,
+	.thaw = ipr_sata_thaw,
 	.post_internal_cmd = ipr_ata_post_internal,
 	.tf_read = ipr_tf_read,
+	.qc_defer = ipr_sata_qc_defer,
 	.qc_prep = ata_noop_qc_prep,
 	.qc_issue = ipr_qc_issue,
 	.port_start = ata_sas_port_start,
-	.port_stop = ata_sas_port_stop
+	.port_stop = ata_sas_port_stop,
 };
 
 static struct ata_port_info sata_port_info = {
@@ -7357,6 +7583,7 @@ static void __devinit ipr_init_ioa_cfg(s
 	ioa_cfg->pdev = pdev;
 	ioa_cfg->log_level = ipr_log_level;
 	ioa_cfg->doorbell = IPR_DOORBELL;
+	ioa_cfg->request_limit = IPR_MAX_COMMANDS;
 	sprintf(ioa_cfg->eye_catcher, IPR_EYECATCHER);
 	sprintf(ioa_cfg->trace_start, IPR_TRACE_START_LABEL);
 	sprintf(ioa_cfg->ipr_free_label, IPR_FREEQ_LABEL);
@@ -7372,7 +7599,10 @@ static void __devinit ipr_init_ioa_cfg(s
 	INIT_LIST_HEAD(&ioa_cfg->hostrcb_pending_q);
 	INIT_LIST_HEAD(&ioa_cfg->free_res_q);
 	INIT_LIST_HEAD(&ioa_cfg->used_res_q);
+	INIT_LIST_HEAD(&ioa_cfg->sata_ports);
 	INIT_WORK(&ioa_cfg->work_q, ipr_worker_thread);
+	spin_lock_init(&ioa_cfg->qc_done_lock);
+	tasklet_init(&ioa_cfg->tasklet, ipr_tasklet, (unsigned long) ioa_cfg);
 	init_waitqueue_head(&ioa_cfg->reset_wait_q);
 	ioa_cfg->sdt_state = INACTIVE;
 	if (ipr_enable_cache)
@@ -7460,8 +7690,6 @@ static int __devinit ipr_probe_ioa(struc
 
 	ioa_cfg = (struct ipr_ioa_cfg *)host->hostdata;
 	memset(ioa_cfg, 0, sizeof(struct ipr_ioa_cfg));
-	ata_host_init(&ioa_cfg->ata_host, &pdev->dev,
-		      sata_port_info.flags, &ipr_sata_ops);
 
 	ioa_cfg->chip_cfg = ipr_get_chip_cfg(dev_id);
 
@@ -7640,6 +7868,45 @@ static void ipr_initiate_ioa_bringdown(s
 }
 
 /**
+ * ipr_remove_sata_devs - Remove all SATA devices from the adapter
+ * @ioa_cfg:		ioa config struct
+ *
+ * Description: This function will delete all previously allocated
+ * SATA rphys.
+ *
+ * Return value:
+ * 	none
+ **/
+static void ipr_remove_sata_devs(struct ipr_ioa_cfg *ioa_cfg)
+{
+	struct ipr_sata_port *sata_port;
+	struct device *dev;
+	unsigned long flags;
+
+	ENTER;
+restart:
+	spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
+	list_for_each_entry(sata_port, &ioa_cfg->sata_ports, queue) {
+		dev = get_device(&sata_port->rphy.dev);
+		list_del(&sata_port->queue);
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
+
+		ata_sas_rphy_delete(&sata_port->rphy);
+
+		spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
+		sata_port->res->sata_port = NULL;
+		list_move_tail(&sata_port->res->queue, &ioa_cfg->free_res_q);
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
+
+		if (dev)
+			put_device(dev);
+		goto restart;
+	}
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
+	LEAVE;
+}
+
+/**
  * __ipr_remove - Remove a single adapter
  * @pdev:	pci device struct
  *
@@ -7655,6 +7922,15 @@ static void __ipr_remove(struct pci_dev 
 	ENTER;
 
 	spin_lock_irqsave(ioa_cfg->host->host_lock, host_lock_flags);
+	ioa_cfg->allow_ml_add_del = 0;
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, host_lock_flags);
+
+	flush_scheduled_work();
+	ipr_remove_sata_devs(ioa_cfg);
+	tasklet_disable(&ioa_cfg->tasklet);
+	ipr_tasklet((unsigned long)ioa_cfg);
+
+	spin_lock_irqsave(ioa_cfg->host->host_lock, host_lock_flags);
 	while(ioa_cfg->in_reset_reload) {
 		spin_unlock_irqrestore(ioa_cfg->host->host_lock, host_lock_flags);
 		wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
@@ -7662,11 +7938,10 @@ static void __ipr_remove(struct pci_dev 
 	}
 
 	ipr_initiate_ioa_bringdown(ioa_cfg, IPR_SHUTDOWN_NORMAL);
-
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, host_lock_flags);
 	wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
+	schedule_work(&ioa_cfg->work_q);
 	flush_scheduled_work();
-	spin_lock_irqsave(ioa_cfg->host->host_lock, host_lock_flags);
 
 	spin_lock(&ipr_driver_lock);
 	list_del(&ioa_cfg->queue);
@@ -7765,6 +8040,7 @@ static int __devinit ipr_probe(struct pc
 	ioa_cfg->allow_ml_add_del = 1;
 	ioa_cfg->host->max_channel = IPR_VSET_BUS;
 	schedule_work(&ioa_cfg->work_q);
+	flush_scheduled_work();
 	return 0;
 }
 
diff -puN drivers/scsi/ipr.h~ipr_sata_scsi_host2 drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_sata_scsi_host2	2007-10-29 13:04:13.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2007-10-29 14:00:22.000000000 -0500
@@ -951,11 +951,16 @@ struct ipr_bus_attributes {
 	u32 max_xfer_rate;
 };
 
+#define rphy_to_sata_port(d) \
+	container_of((d), struct ipr_sata_port, rphy)
+
 struct ipr_sata_port {
+	struct ata_sas_rphy rphy;
+	unsigned int active_requests;
 	struct ipr_ioa_cfg *ioa_cfg;
-	struct ata_port *ap;
 	struct ipr_resource_entry *res;
 	struct ipr_ioasa_gata ioasa;
+	struct list_head queue;
 };
 
 struct ipr_resource_entry {
@@ -1137,6 +1142,8 @@ struct ipr_ioa_cfg {
 	struct list_head free_res_q;
 	struct list_head used_res_q;
 
+	struct list_head sata_ports;
+
 	char ipr_hcam_label[8];
 #define IPR_HCAM_LABEL			"hcams"
 	struct ipr_hostrcb *hostrcb[IPR_NUM_HCAMS];
@@ -1170,6 +1177,7 @@ struct ipr_ioa_cfg {
 
 	u32 errors_logged;
 	u32 doorbell;
+	unsigned int request_limit;
 
 	struct Scsi_Host *host;
 	struct pci_dev *pdev;
@@ -1177,6 +1185,7 @@ struct ipr_ioa_cfg {
 	u8 saved_mode_page_len;
 
 	struct work_struct work_q;
+	struct tasklet_struct tasklet;
 
 	wait_queue_head_t reset_wait_q;
 
@@ -1191,7 +1200,9 @@ struct ipr_ioa_cfg {
 	struct ipr_cmnd *reset_cmd;
 	int (*reset) (struct ipr_cmnd *);
 
-	struct ata_host ata_host;
+	spinlock_t	qc_done_lock;
+	struct ata_queued_cmd *qc_done;
+
 	char ipr_cmd_label[8];
 #define IPR_CMD_LABEL		"ipr_cmnd"
 	struct ipr_cmnd *ipr_cmnd_list[IPR_NUM_CMD_BLKS];
_

