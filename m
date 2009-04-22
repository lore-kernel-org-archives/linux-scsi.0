From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] libata: rewrite SCSI host scheme to be one per ATA host
Date: Wed, 22 Apr 2009 05:09:29 -0400
Message-ID: <20090422090929.GA14928@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="2oS5YaxWCcQjTEyO"
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Currently, libata creates a Scsi_Host per port.  This was originally
done to leverage SCSI's infrastructure to arbitrate among master/slave
devices, but is not needed for most modern SATA controllers.   And I
_think_ it is not needed for master/slave if done properly, either.

The patch below converts libata such that there is now a 1:1
correspondence between struct Scsi_Host and struct ata_host.  ATA ports
are represented as SCSI layer 'channels', which is more natural.

This patch is an experiment, and not meant for upstream anytime soon.
I just wanted to see what kind of effort would be required to get it
to work.

I was able to successfully boot the following patch on
AHCI/x86-64/Fedora.

It may work with other controllers -- TRY AT YOUR OWN RISK.  It will
probably fail for master/slave configurations, and SAS & PMP also
need looking at.  It yielded this lsscsi output on my AHCI box:

[0:0:0:0]    disk    ATA      ST3500320AS      SD15  /dev/sda
[0:2:0:0]    disk    ATA      G.SKILL 128GB SS 02.1  /dev/sdb
[0:5:0:0]    cd/dvd  PIONEER  BD-ROM  BDC-202  1.04  /dev/sr0

NOT-signed-off-by: me

 drivers/ata/ahci.c            |    4 
 drivers/ata/libata-core.c     |   17 +--
 drivers/ata/libata-eh.c       |   47 ++++++--
 drivers/ata/libata-scsi.c     |  237 +++++++++++++++++++++---------------------
 drivers/ata/libata.h          |    3 
 drivers/scsi/libsas/sas_ata.c |    2 
 include/linux/libata.h        |    9 -
 7 files changed, 184 insertions(+), 135 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 08186ec..b0468a8 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -326,14 +326,18 @@ static ssize_t ahci_activity_store(struct ata_device *dev,
 static void ahci_init_sw_activity(struct ata_link *link);
 
 static struct device_attribute *ahci_shost_attrs[] = {
+#if 0
 	&dev_attr_link_power_management_policy,
 	&dev_attr_em_message_type,
 	&dev_attr_em_message,
+#endif
 	NULL
 };
 
 static struct device_attribute *ahci_sdev_attrs[] = {
+#if 0
 	&dev_attr_sw_activity,
+#endif
 	&dev_attr_unload_heads,
 	NULL
 };
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 17c5d48..71f32dc 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -95,6 +95,7 @@ static void ata_dev_xfermask(struct ata_device *dev);
 static unsigned long ata_dev_blacklisted(const struct ata_device *dev);
 
 unsigned int ata_print_id = 1;
+unsigned int ata_host_print_id = 1;
 static struct workqueue_struct *ata_wq;
 
 struct workqueue_struct *ata_aux_wq;
@@ -2308,7 +2309,7 @@ static void ata_dev_config_ncq(struct ata_device *dev,
 		return;
 	}
 	if (ap->flags & ATA_FLAG_NCQ) {
-		hdepth = min(ap->scsi_host->can_queue, ATA_MAX_QUEUE - 1);
+		hdepth = min(ap->host->scsi_host->can_queue, ATA_MAX_QUEUE - 1);
 		dev->flags |= ATA_DFLAG_NCQ;
 	}
 
@@ -5635,15 +5636,15 @@ static void ata_host_release(struct device *gendev, void *res)
 		if (!ap)
 			continue;
 
-		if (ap->scsi_host)
-			scsi_host_put(ap->scsi_host);
-
 		kfree(ap->pmp_link);
 		kfree(ap->slave_link);
 		kfree(ap);
 		host->ports[i] = NULL;
 	}
 
+	if (host->scsi_host)
+		scsi_host_put(host->scsi_host);
+
 	dev_set_drvdata(gendev, NULL);
 }
 
@@ -6089,6 +6090,8 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 	for (i = 0; i < host->n_ports; i++)
 		host->ports[i]->print_id = ata_print_id++;
 
+	host->print_id = ata_host_print_id++;
+
 	rc = ata_scsi_add_hosts(host, sht);
 	if (rc)
 		return rc;
@@ -6222,8 +6225,7 @@ static void ata_port_detach(struct ata_port *ap)
 	cancel_rearming_delayed_work(&ap->hotplug_task);
 
  skip_eh:
-	/* remove the associated SCSI host */
-	scsi_remove_host(ap->scsi_host);
+ 	return;
 }
 
 /**
@@ -6242,6 +6244,9 @@ void ata_host_detach(struct ata_host *host)
 	for (i = 0; i < host->n_ports; i++)
 		ata_port_detach(host->ports[i]);
 
+	/* remove the associated SCSI host */
+	scsi_remove_host(host->scsi_host);
+
 	/* the host is dead now, dissociate ACPI */
 	ata_acpi_dissociate(host);
 }
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 0183131..db8a66f 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -466,14 +466,22 @@ static void ata_eh_clear_action(struct ata_link *link, struct ata_device *dev,
  */
 enum blk_eh_timer_return ata_scsi_timed_out(struct scsi_cmnd *cmd)
 {
-	struct Scsi_Host *host = cmd->device->host;
-	struct ata_port *ap = ata_shost_to_port(host);
+	struct Scsi_Host *shost = cmd->device->host;
+	struct ata_port *ap;
+	struct ata_host *host;
+	struct ata_device *atadev;
 	unsigned long flags;
 	struct ata_queued_cmd *qc;
-	enum blk_eh_timer_return ret;
+	enum blk_eh_timer_return ret = BLK_EH_NOT_HANDLED;
 
 	DPRINTK("ENTER\n");
 
+	host = ata_shost_to_host(shost);
+	atadev = ata_scsi_find_dev(host, cmd->device);
+	if (!atadev)
+		goto out;
+	ap = atadev->link->ap;
+
 	if (ap->ops->error_handler) {
 		ret = BLK_EH_NOT_HANDLED;
 		goto out;
@@ -532,13 +540,12 @@ static void ata_eh_unload(struct ata_port *ap)
  *	RETURNS:
  *	Zero.
  */
-void ata_scsi_error(struct Scsi_Host *host)
+static void __ata_scsi_error(struct Scsi_Host *shost, struct ata_port *ap)
 {
-	struct ata_port *ap = ata_shost_to_port(host);
 	int i;
 	unsigned long flags;
 
-	DPRINTK("ENTER\n");
+	DPRINTK("ENTER, port_no %u\n", ap->port_no);
 
 	/* synchronize with port task */
 	ata_port_flush_task(ap);
@@ -575,7 +582,7 @@ void ata_scsi_error(struct Scsi_Host *host)
 		if (ap->ops->lost_interrupt)
 			ap->ops->lost_interrupt(ap);
 			
-		list_for_each_entry_safe(scmd, tmp, &host->eh_cmd_q, eh_entry) {
+		list_for_each_entry_safe(scmd, tmp, &shost->eh_cmd_q, eh_entry) {
 			struct ata_queued_cmd *qc;
 
 			for (i = 0; i < ATA_MAX_QUEUE; i++) {
@@ -698,7 +705,7 @@ void ata_scsi_error(struct Scsi_Host *host)
 		 * before EH completion, SCSI midlayer will
 		 * re-initiate EH.
 		 */
-		host->host_eh_scheduled = 0;
+		shost->host_eh_scheduled = 0;
 
 		spin_unlock_irqrestore(ap->lock, flags);
 	} else {
@@ -707,7 +714,7 @@ void ata_scsi_error(struct Scsi_Host *host)
 	}
 
 	/* finish or retry handled scmd's and clean up */
-	WARN_ON(host->host_failed || !list_empty(&host->eh_cmd_q));
+	WARN_ON(shost->host_failed || !list_empty(&shost->eh_cmd_q));
 
 	scsi_eh_flush_done_q(&ap->eh_done_q);
 
@@ -733,6 +740,24 @@ void ata_scsi_error(struct Scsi_Host *host)
 	DPRINTK("EXIT\n");
 }
 
+void ata_scsi_error(struct Scsi_Host *shost)
+{
+	struct ata_host *host = ata_shost_to_host(shost);
+	unsigned int i;
+
+	DPRINTK("ENTER\n");
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+
+		if (ap->pflags & ATA_PFLAG_EH_PENDING)
+			__ata_scsi_error(shost, ap);
+	}
+
+	DPRINTK("EXIT\n");
+}
+
+
 /**
  *	ata_port_wait_eh - Wait for the currently pending EH to complete
  *	@ap: Port to wait EH for
@@ -761,7 +786,7 @@ void ata_port_wait_eh(struct ata_port *ap)
 	spin_unlock_irqrestore(ap->lock, flags);
 
 	/* make sure SCSI EH is complete */
-	if (scsi_host_in_recovery(ap->scsi_host)) {
+	if (scsi_host_in_recovery(ap->host->scsi_host)) {
 		msleep(10);
 		goto retry;
 	}
@@ -901,7 +926,7 @@ void ata_port_schedule_eh(struct ata_port *ap)
 		return;
 
 	ata_eh_set_pending(ap, 1);
-	scsi_schedule_eh(ap->scsi_host);
+	scsi_schedule_eh(ap->host->scsi_host);
 
 	DPRINTK("port EH scheduled\n");
 }
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 2733b0c..7aa6aa6 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -58,10 +58,8 @@ static u8 ata_scsi_rbuf[ATA_SCSI_RBUF_SIZE];
 
 typedef unsigned int (*ata_xlat_func_t)(struct ata_queued_cmd *qc);
 
-static struct ata_device *__ata_scsi_find_dev(struct ata_port *ap,
+static struct ata_device *__ata_scsi_find_dev(struct ata_host *,
 					const struct scsi_device *scsidev);
-static struct ata_device *ata_scsi_find_dev(struct ata_port *ap,
-					    const struct scsi_device *scsidev);
 static int ata_scsi_user_scan(struct Scsi_Host *shost, unsigned int channel,
 			      unsigned int id, unsigned int lun);
 
@@ -136,6 +134,7 @@ static const char *ata_scsi_lpm_get(enum link_pm policy)
 	return NULL;
 }
 
+#if 0
 static ssize_t ata_scsi_lpm_put(struct device *dev,
 				struct device_attribute *attr,
 				const char *buf, size_t count)
@@ -183,6 +182,7 @@ ata_scsi_lpm_show(struct device *dev, struct device_attribute *attr, char *buf)
 DEVICE_ATTR(link_power_management_policy, S_IRUGO | S_IWUSR,
 		ata_scsi_lpm_show, ata_scsi_lpm_put);
 EXPORT_SYMBOL_GPL(dev_attr_link_power_management_policy);
+#endif
 
 static ssize_t ata_scsi_park_show(struct device *device,
 				  struct device_attribute *attr, char *buf)
@@ -190,19 +190,21 @@ static ssize_t ata_scsi_park_show(struct device *device,
 	struct scsi_device *sdev = to_scsi_device(device);
 	struct ata_port *ap;
 	struct ata_link *link;
+	struct ata_host *host;
 	struct ata_device *dev;
 	unsigned long flags, now;
 	unsigned int uninitialized_var(msecs);
 	int rc = 0;
 
-	ap = ata_shost_to_port(sdev->host);
+	host = ata_shost_to_host(sdev->host);
 
-	spin_lock_irqsave(ap->lock, flags);
-	dev = ata_scsi_find_dev(ap, sdev);
+	spin_lock_irqsave(&host->lock, flags);
+	dev = ata_scsi_find_dev(host, sdev);
 	if (!dev) {
 		rc = -ENODEV;
 		goto unlock;
 	}
+	ap = dev->link->ap;
 	if (dev->flags & ATA_DFLAG_NO_UNLOAD) {
 		rc = -EOPNOTSUPP;
 		goto unlock;
@@ -218,7 +220,7 @@ static ssize_t ata_scsi_park_show(struct device *device,
 		msecs = 0;
 
 unlock:
-	spin_unlock_irq(ap->lock);
+	spin_unlock_irq(&host->lock);
 
 	return rc ? rc : snprintf(buf, 20, "%u\n", msecs);
 }
@@ -230,6 +232,7 @@ static ssize_t ata_scsi_park_store(struct device *device,
 	struct scsi_device *sdev = to_scsi_device(device);
 	struct ata_port *ap;
 	struct ata_device *dev;
+	struct ata_host *host;
 	long int input;
 	unsigned long flags;
 	int rc;
@@ -242,14 +245,15 @@ static ssize_t ata_scsi_park_store(struct device *device,
 		input = ATA_TMOUT_MAX_PARK;
 	}
 
-	ap = ata_shost_to_port(sdev->host);
+	host = ata_shost_to_host(sdev->host);
 
-	spin_lock_irqsave(ap->lock, flags);
-	dev = ata_scsi_find_dev(ap, sdev);
+	spin_lock_irqsave(&host->lock, flags);
+	dev = ata_scsi_find_dev(host, sdev);
 	if (unlikely(!dev)) {
 		rc = -ENODEV;
 		goto unlock;
 	}
+	ap = dev->link->ap;
 	if (dev->class != ATA_DEV_ATA) {
 		rc = -EOPNOTSUPP;
 		goto unlock;
@@ -276,7 +280,7 @@ static ssize_t ata_scsi_park_store(struct device *device,
 		}
 	}
 unlock:
-	spin_unlock_irqrestore(ap->lock, flags);
+	spin_unlock_irqrestore(&host->lock, flags);
 
 	return rc ? rc : len;
 }
@@ -291,6 +295,7 @@ static void ata_scsi_set_sense(struct scsi_cmnd *cmd, u8 sk, u8 asc, u8 ascq)
 	scsi_build_sense_buffer(0, cmd->sense_buffer, sk, asc, ascq);
 }
 
+#if 0
 static ssize_t
 ata_scsi_em_message_store(struct device *dev, struct device_attribute *attr,
 			  const char *buf, size_t count)
@@ -335,8 +340,9 @@ ata_scsi_activity_show(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
-	struct ata_port *ap = ata_shost_to_port(sdev->host);
-	struct ata_device *atadev = ata_scsi_find_dev(ap, sdev);
+	struct ata_host *host = ata_shost_to_host(sdev->host);
+	struct ata_device *atadev = ata_scsi_find_dev(host, sdev);
+	struct ata_port *ap = atadev->ap;
 
 	if (ap->ops->sw_activity_show && (ap->flags & ATA_FLAG_SW_ACTIVITY))
 		return ap->ops->sw_activity_show(atadev, buf);
@@ -348,8 +354,9 @@ ata_scsi_activity_store(struct device *dev, struct device_attribute *attr,
 	const char *buf, size_t count)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
-	struct ata_port *ap = ata_shost_to_port(sdev->host);
-	struct ata_device *atadev = ata_scsi_find_dev(ap, sdev);
+	struct ata_host *host = ata_shost_to_host(sdev->host);
+	struct ata_device *atadev = ata_scsi_find_dev(host, sdev);
+	struct ata_port *ap = atadev->ap;
 	enum sw_activity val;
 	int rc;
 
@@ -369,6 +376,7 @@ ata_scsi_activity_store(struct device *dev, struct device_attribute *attr,
 DEVICE_ATTR(sw_activity, S_IWUGO | S_IRUGO, ata_scsi_activity_show,
 			ata_scsi_activity_store);
 EXPORT_SYMBOL_GPL(dev_attr_sw_activity);
+#endif
 
 struct device_attribute *ata_common_sdev_attrs[] = {
 	&dev_attr_unload_heads,
@@ -425,10 +433,10 @@ int ata_std_bios_param(struct scsi_device *sdev, struct block_device *bdev,
  *	RETURNS:
  *	Zero on success, negative errno on error.
  */
-static int ata_get_identity(struct ata_port *ap, struct scsi_device *sdev,
+static int ata_get_identity(struct ata_host *host, struct scsi_device *sdev,
 			    void __user *arg)
 {
-	struct ata_device *dev = ata_scsi_find_dev(ap, sdev);
+	struct ata_device *dev = ata_scsi_find_dev(host, sdev);
 	u16 __user *dst = arg;
 	char buf[40];
 
@@ -656,11 +664,18 @@ static int ata_ioc32(struct ata_port *ap)
 	return 0;
 }
 
-int ata_sas_scsi_ioctl(struct ata_port *ap, struct scsi_device *scsidev,
+int ata_sas_scsi_ioctl(struct ata_host *host, struct scsi_device *scsidev,
 		     int cmd, void __user *arg)
 {
 	int val = -EINVAL, rc = -EINVAL;
 	unsigned long flags;
+	struct ata_port *ap;
+	struct ata_device *atadev;
+
+	atadev = ata_scsi_find_dev(host, scsidev);
+	if (!atadev)
+		return -ENOENT;
+	ap = atadev->link->ap;
 
 	switch (cmd) {
 	case ATA_IOC_GET_IO32:
@@ -688,7 +703,7 @@ int ata_sas_scsi_ioctl(struct ata_port *ap, struct scsi_device *scsidev,
 		return rc;
 
 	case HDIO_GET_IDENTITY:
-		return ata_get_identity(ap, scsidev, arg);
+		return ata_get_identity(host, scsidev, arg);
 
 	case HDIO_DRIVE_CMD:
 		if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
@@ -711,7 +726,7 @@ EXPORT_SYMBOL_GPL(ata_sas_scsi_ioctl);
 
 int ata_scsi_ioctl(struct scsi_device *scsidev, int cmd, void __user *arg)
 {
-	return ata_sas_scsi_ioctl(ata_shost_to_port(scsidev->host),
+	return ata_sas_scsi_ioctl(ata_shost_to_host(scsidev->host),
 				scsidev, cmd, arg);
 }
 EXPORT_SYMBOL_GPL(ata_scsi_ioctl);
@@ -1157,8 +1172,8 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
 
 int ata_scsi_slave_config(struct scsi_device *sdev)
 {
-	struct ata_port *ap = ata_shost_to_port(sdev->host);
-	struct ata_device *dev = __ata_scsi_find_dev(ap, sdev);
+	struct ata_host *host = ata_shost_to_host(sdev->host);
+	struct ata_device *dev = __ata_scsi_find_dev(host, sdev);
 	int rc = 0;
 
 	ata_scsi_sdev_config(sdev);
@@ -1185,27 +1200,34 @@ int ata_scsi_slave_config(struct scsi_device *sdev)
  */
 void ata_scsi_slave_destroy(struct scsi_device *sdev)
 {
-	struct ata_port *ap = ata_shost_to_port(sdev->host);
+	struct ata_host *host = ata_shost_to_host(sdev->host);
 	struct request_queue *q = sdev->request_queue;
 	unsigned long flags;
 	struct ata_device *dev;
+	bool new_eh = true;
 
-	if (!ap->ops->error_handler)
-		return;
-
-	spin_lock_irqsave(ap->lock, flags);
-	dev = __ata_scsi_find_dev(ap, sdev);
+	spin_lock_irqsave(&host->lock, flags);
+	dev = __ata_scsi_find_dev(host, sdev);
 	if (dev && dev->sdev) {
+		struct ata_port *ap = dev->link->ap;
+
+		if (!ap->ops->error_handler)
+			new_eh = false;
+
+		else {
 		/* SCSI device already in CANCEL state, no need to offline it */
 		dev->sdev = NULL;
 		dev->flags |= ATA_DFLAG_DETACH;
 		ata_port_schedule_eh(ap);
+		}
 	}
-	spin_unlock_irqrestore(ap->lock, flags);
+	spin_unlock_irqrestore(&host->lock, flags);
 
-	kfree(q->dma_drain_buffer);
-	q->dma_drain_buffer = NULL;
-	q->dma_drain_size = 0;
+	if (new_eh) {
+		kfree(q->dma_drain_buffer);
+		q->dma_drain_buffer = NULL;
+		q->dma_drain_size = 0;
+	}
 }
 
 /**
@@ -1225,25 +1247,25 @@ void ata_scsi_slave_destroy(struct scsi_device *sdev)
  */
 int ata_scsi_change_queue_depth(struct scsi_device *sdev, int queue_depth)
 {
-	struct ata_port *ap = ata_shost_to_port(sdev->host);
+	struct ata_host *host = ata_shost_to_host(sdev->host);
 	struct ata_device *dev;
 	unsigned long flags;
 
 	if (queue_depth < 1 || queue_depth == sdev->queue_depth)
 		return sdev->queue_depth;
 
-	dev = ata_scsi_find_dev(ap, sdev);
+	dev = ata_scsi_find_dev(host, sdev);
 	if (!dev || !ata_dev_enabled(dev))
 		return sdev->queue_depth;
 
 	/* NCQ enabled? */
-	spin_lock_irqsave(ap->lock, flags);
+	spin_lock_irqsave(&host->lock, flags);
 	dev->flags &= ~ATA_DFLAG_NCQ_OFF;
 	if (queue_depth == 1 || !ata_ncq_enabled(dev)) {
 		dev->flags |= ATA_DFLAG_NCQ_OFF;
 		queue_depth = 1;
 	}
-	spin_unlock_irqrestore(ap->lock, flags);
+	spin_unlock_irqrestore(&host->lock, flags);
 
 	/* limit and apply queue depth */
 	queue_depth = min(queue_depth, sdev->host->can_queue);
@@ -2690,21 +2712,20 @@ static struct ata_device *ata_find_dev(struct ata_port *ap, int devno)
 	return NULL;
 }
 
-static struct ata_device *__ata_scsi_find_dev(struct ata_port *ap,
+static struct ata_device *__ata_scsi_find_dev(struct ata_host *host,
 					      const struct scsi_device *scsidev)
 {
 	int devno;
+	struct ata_port *ap;
 
-	/* skip commands not addressed to targets we simulate */
-	if (!sata_pmp_attached(ap)) {
-		if (unlikely(scsidev->channel || scsidev->lun))
-			return NULL;
-		devno = scsidev->id;
-	} else {
-		if (unlikely(scsidev->id || scsidev->lun))
-			return NULL;
-		devno = scsidev->channel;
-	}
+	if (scsidev->channel > host->n_ports)
+		return NULL;
+	
+	ap = host->ports[scsidev->channel];
+	if (ata_port_is_dummy(ap))
+		return NULL;
+
+	devno = scsidev->id;
 
 	return ata_find_dev(ap, devno);
 }
@@ -2725,10 +2746,10 @@ static struct ata_device *__ata_scsi_find_dev(struct ata_port *ap,
  *	RETURNS:
  *	Associated ATA device, or %NULL if not found.
  */
-static struct ata_device *
-ata_scsi_find_dev(struct ata_port *ap, const struct scsi_device *scsidev)
+struct ata_device *
+ata_scsi_find_dev(struct ata_host *host, const struct scsi_device *scsidev)
 {
-	struct ata_device *dev = __ata_scsi_find_dev(ap, scsidev);
+	struct ata_device *dev = __ata_scsi_find_dev(host, scsidev);
 
 	if (unlikely(!dev || !ata_dev_enabled(dev)))
 		return NULL;
@@ -2983,15 +3004,13 @@ static inline ata_xlat_func_t ata_get_xlat_func(struct ata_device *dev, u8 cmd)
  *	Prints the contents of a SCSI command via printk().
  */
 
-static inline void ata_scsi_dump_cdb(struct ata_port *ap,
-				     struct scsi_cmnd *cmd)
+static inline void ata_scsi_dump_cdb(struct scsi_cmnd *cmd)
 {
 #ifdef ATA_DEBUG
 	struct scsi_device *scsidev = cmd->device;
 	u8 *scsicmd = cmd->cmnd;
 
-	DPRINTK("CDB (%u:%d,%d,%d) %02x %02x %02x %02x %02x %02x %02x %02x %02x\n",
-		ap->print_id,
+	DPRINTK("CDB (%d,%d,%d) %02x %02x %02x %02x %02x %02x %02x %02x %02x\n",
 		scsidev->channel, scsidev->id, scsidev->lun,
 		scsicmd[0], scsicmd[1], scsicmd[2], scsicmd[3],
 		scsicmd[4], scsicmd[5], scsicmd[6], scsicmd[7],
@@ -3069,20 +3088,20 @@ static inline int __ata_scsi_queuecmd(struct scsi_cmnd *scmd,
  */
 int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 {
-	struct ata_port *ap;
 	struct ata_device *dev;
+	struct ata_host *host;
 	struct scsi_device *scsidev = cmd->device;
 	struct Scsi_Host *shost = scsidev->host;
 	int rc = 0;
 
-	ap = ata_shost_to_port(shost);
+	host = ata_shost_to_host(shost);
 
 	spin_unlock(shost->host_lock);
-	spin_lock(ap->lock);
+	spin_lock(&host->lock);
 
-	ata_scsi_dump_cdb(ap, cmd);
+	ata_scsi_dump_cdb(cmd);
 
-	dev = ata_scsi_find_dev(ap, scsidev);
+	dev = ata_scsi_find_dev(host, scsidev);
 	if (likely(dev))
 		rc = __ata_scsi_queuecmd(cmd, done, dev);
 	else {
@@ -3090,7 +3109,7 @@ int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 		done(cmd);
 	}
 
-	spin_unlock(ap->lock);
+	spin_unlock(&host->lock);
 	spin_lock(shost->host_lock);
 	return rc;
 }
@@ -3217,56 +3236,43 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
 
 int ata_scsi_add_hosts(struct ata_host *host, struct scsi_host_template *sht)
 {
-	int i, rc;
-
-	for (i = 0; i < host->n_ports; i++) {
-		struct ata_port *ap = host->ports[i];
-		struct Scsi_Host *shost;
+	int rc;
+	struct Scsi_Host *shost;
 
-		rc = -ENOMEM;
-		shost = scsi_host_alloc(sht, sizeof(struct ata_port *));
-		if (!shost)
-			goto err_alloc;
+	shost = scsi_host_alloc(sht, sizeof(struct ata_host *));
+	if (!shost)
+		return -ENOMEM;
 
-		*(struct ata_port **)&shost->hostdata[0] = ap;
-		ap->scsi_host = shost;
+	*(struct ata_host **)&shost->hostdata[0] = host;
+	host->scsi_host = shost;
 
-		shost->transportt = &ata_scsi_transport_template;
-		shost->unique_id = ap->print_id;
-		shost->max_id = 16;
-		shost->max_lun = 1;
-		shost->max_channel = 1;
-		shost->max_cmd_len = 16;
+	shost->transportt = &ata_scsi_transport_template;
+	shost->unique_id = host->print_id;
+	shost->max_id = 32;
+	shost->max_lun = 1;
+	shost->max_channel = 32;
+	shost->max_cmd_len = 16;
 
-		/* Schedule policy is determined by ->qc_defer()
-		 * callback and it needs to see every deferred qc.
-		 * Set host_blocked to 1 to prevent SCSI midlayer from
-		 * automatically deferring requests.
-		 */
-		shost->max_host_blocked = 1;
+	/* Schedule policy is determined by ->qc_defer()
+	 * callback and it needs to see every deferred qc.
+	 * Set host_blocked to 1 to prevent SCSI midlayer from
+	 * automatically deferring requests.
+	 */
+	shost->max_host_blocked = 1;
 
-		rc = scsi_add_host(ap->scsi_host, ap->host->dev);
-		if (rc)
-			goto err_add;
+	rc = scsi_add_host(shost, host->dev);
+	if (rc) {
+		scsi_host_put(shost);
+		return rc;
 	}
 
 	return 0;
-
- err_add:
-	scsi_host_put(host->ports[i]->scsi_host);
- err_alloc:
-	while (--i >= 0) {
-		struct Scsi_Host *shost = host->ports[i]->scsi_host;
-
-		scsi_remove_host(shost);
-		scsi_host_put(shost);
-	}
-	return rc;
 }
 
 void ata_scsi_scan_host(struct ata_port *ap, int sync)
 {
 	int tries = 5;
+	struct ata_host *host = ap->host;
 	struct ata_device *last_failed_dev = NULL;
 	struct ata_link *link;
 	struct ata_device *dev;
@@ -3278,7 +3284,7 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
 	ata_for_each_link(link, ap, EDGE) {
 		ata_for_each_dev(dev, link, ENABLED) {
 			struct scsi_device *sdev;
-			int channel = 0, id = 0;
+			int id = 0;
 
 			if (dev->sdev)
 				continue;
@@ -3286,9 +3292,10 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
 			if (ata_is_host_link(link))
 				id = dev->devno;
 			else
-				channel = link->pmp;
+				id = link->pmp;
 
-			sdev = __scsi_add_device(ap->scsi_host, channel, id, 0,
+			sdev = __scsi_add_device(host->scsi_host,
+						 ap->port_no, id, 0,
 						 NULL);
 			if (!IS_ERR(sdev)) {
 				dev->sdev = sdev;
@@ -3376,6 +3383,7 @@ int ata_scsi_offline_dev(struct ata_device *dev)
 static void ata_scsi_remove_dev(struct ata_device *dev)
 {
 	struct ata_port *ap = dev->link->ap;
+	struct ata_host *host = ap->host;
 	struct scsi_device *sdev;
 	unsigned long flags;
 
@@ -3385,7 +3393,7 @@ static void ata_scsi_remove_dev(struct ata_device *dev)
 	 * be removed if there is __scsi_device_get() interface which
 	 * increments reference counts regardless of device state.
 	 */
-	mutex_lock(&ap->scsi_host->scan_mutex);
+	mutex_lock(&host->scsi_host->scan_mutex);
 	spin_lock_irqsave(ap->lock, flags);
 
 	/* clearing dev->sdev is protected by host lock */
@@ -3411,7 +3419,7 @@ static void ata_scsi_remove_dev(struct ata_device *dev)
 	}
 
 	spin_unlock_irqrestore(ap->lock, flags);
-	mutex_unlock(&ap->scsi_host->scan_mutex);
+	mutex_unlock(&host->scsi_host->scan_mutex);
 
 	if (sdev) {
 		ata_dev_printk(dev, KERN_INFO, "detaching (SCSI %s)\n",
@@ -3517,25 +3525,28 @@ void ata_scsi_hotplug(struct work_struct *work)
 static int ata_scsi_user_scan(struct Scsi_Host *shost, unsigned int channel,
 			      unsigned int id, unsigned int lun)
 {
-	struct ata_port *ap = ata_shost_to_port(shost);
+	struct ata_port *ap;
+	struct ata_host *host = ata_shost_to_host(shost);
 	unsigned long flags;
 	int devno, rc = 0;
 
+	if (channel == SCAN_WILD_CARD)
+		ap = host->ports[0];
+	else {
+		if (channel > host->n_ports)
+			return -EINVAL;
+		ap = host->ports[channel];
+	}
+
 	if (!ap->ops->error_handler)
 		return -EOPNOTSUPP;
 
 	if (lun != SCAN_WILD_CARD && lun)
 		return -EINVAL;
 
-	if (!sata_pmp_attached(ap)) {
-		if (channel != SCAN_WILD_CARD && channel)
-			return -EINVAL;
-		devno = id;
-	} else {
-		if (id != SCAN_WILD_CARD && id)
-			return -EINVAL;
-		devno = channel;
-	}
+	if (id != SCAN_WILD_CARD && id)
+		return -EINVAL;
+	devno = id;
 
 	spin_lock_irqsave(ap->lock, flags);
 
@@ -3749,7 +3760,7 @@ int ata_sas_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *),
 {
 	int rc = 0;
 
-	ata_scsi_dump_cdb(ap, cmd);
+	ata_scsi_dump_cdb(cmd);
 
 	if (likely(ata_dev_enabled(ap->link.device)))
 		rc = __ata_scsi_queuecmd(cmd, done, ap->link.device);
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 89a1e00..af890b4 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -205,4 +205,7 @@ extern u8 ata_irq_on(struct ata_port *ap);
 extern void ata_pio_task(struct work_struct *work);
 #endif /* CONFIG_ATA_SFF */
 
+struct ata_device *
+ata_scsi_find_dev(struct ata_host *host, const struct scsi_device *scsidev);
+
 #endif /* __LIBATA_H__ */
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index e155011..758df0b 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -375,6 +375,7 @@ int sas_ata_init_host_and_port(struct domain_device *found_dev,
 		      ha->dev,
 		      sata_port_info.flags,
 		      &sas_sata_ops);
+	found_dev->sata_dev.ata_host.scsi_host = shost;
 	ap = ata_sas_port_alloc(&found_dev->sata_dev.ata_host,
 				&sata_port_info,
 				shost);
@@ -385,7 +386,6 @@ int sas_ata_init_host_and_port(struct domain_device *found_dev,
 
 	ap->private_data = found_dev;
 	ap->cbl = ATA_CBL_SATA;
-	ap->scsi_host = shost;
 	found_dev->sata_dev.ap = ap;
 
 	return 0;
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 3d501db..2ea4dce 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -507,10 +507,12 @@ struct ata_ioports {
 #endif /* CONFIG_ATA_SFF */
 
 struct ata_host {
+	struct Scsi_Host	*scsi_host; /* our co-allocated scsi host */
 	spinlock_t		lock;
 	struct device 		*dev;
 	void __iomem * const	*iomap;
 	unsigned int		n_ports;
+	unsigned int		print_id; /* user visible unique host ID */
 	void			*private_data;
 	struct ata_port_operations *ops;
 	unsigned long		flags;
@@ -690,7 +692,6 @@ struct ata_link {
 };
 
 struct ata_port {
-	struct Scsi_Host	*scsi_host; /* our co-allocated scsi host */
 	struct ata_port_operations *ops;
 	spinlock_t		*lock;
 	/* Flags owned by the EH context. Only EH should touch these once the
@@ -947,7 +948,7 @@ extern void ata_host_init(struct ata_host *, struct device *,
 extern int ata_scsi_detect(struct scsi_host_template *sht);
 extern int ata_scsi_ioctl(struct scsi_device *dev, int cmd, void __user *arg);
 extern int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *));
-extern int ata_sas_scsi_ioctl(struct ata_port *ap, struct scsi_device *dev,
+extern int ata_sas_scsi_ioctl(struct ata_host *, struct scsi_device *dev,
 			    int cmd, void __user *arg);
 extern void ata_sas_port_destroy(struct ata_port *);
 extern struct ata_port *ata_sas_port_alloc(struct ata_host *,
@@ -1472,9 +1473,9 @@ static inline unsigned int __ac_err_mask(u8 status)
 	return mask;
 }
 
-static inline struct ata_port *ata_shost_to_port(struct Scsi_Host *host)
+static inline struct ata_host *ata_shost_to_host(struct Scsi_Host *host)
 {
-	return *(struct ata_port **)&host->hostdata[0];
+	return *(struct ata_host **)&host->hostdata[0];
 }
 
 static inline int ata_check_ready(u8 status)

--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.txt"

Linux version 2.6.30-rc2-scsihost1-00368-gaefe647-dirty (jgarzik@bd.yyz.us) (gcc version 4.3.2 20081105 (Red Hat 4.3.2-7) (GCC) ) #2 SMP Wed Apr 22 03:24:22 EDT 2009
Command line: ro root=UUID=f12abe85-327f-4e7d-9b06-5bb07624196d nogui
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009cc00 (usable)
 BIOS-e820: 000000000009cc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bcdc2000 (usable)
 BIOS-e820: 00000000bcdc2000 - 00000000bcfda000 (ACPI NVS)
 BIOS-e820: 00000000bcfda000 - 00000000bf6bd000 (usable)
 BIOS-e820: 00000000bf6bd000 - 00000000bf6bf000 (reserved)
 BIOS-e820: 00000000bf6bf000 - 00000000bf714000 (usable)
 BIOS-e820: 00000000bf714000 - 00000000bf7bf000 (ACPI NVS)
 BIOS-e820: 00000000bf7bf000 - 00000000bf7e7000 (usable)
 BIOS-e820: 00000000bf7e7000 - 00000000bf7ff000 (ACPI data)
 BIOS-e820: 00000000bf7ff000 - 00000000bf800000 (usable)
 BIOS-e820: 00000000bf800000 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000f8000000 - 00000000fd000000 (reserved)
 BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
DMI 2.5 present.
last_pfn = 0x140000 max_arch_pfn = 0x100000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-DFFFF write-protect
  E0000-FFFFF uncachable
MTRR variable ranges enabled:
  0 base 000000000 mask F80000000 write-back
  1 base 080000000 mask FC0000000 write-back
  2 base 100000000 mask FC0000000 write-back
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
e820 update range: 00000000c0000000 - 0000000100000000 (usable) ==> (reserved)
last_pfn = 0xbf800 max_arch_pfn = 0x100000000
init_memory_mapping: 0000000000000000-00000000bf800000
 0000000000 - 00bf800000 page 2M
kernel direct mapping tables up to bf800000 @ 8000-c000
init_memory_mapping: 0000000100000000-0000000140000000
 0100000000 - 0140000000 page 2M
kernel direct mapping tables up to 140000000 @ a000-10000
RAMDISK: 37c54000 - 37fef547
ACPI: RSDP 00000000000fe020 00024 (v02 INTEL )
ACPI: XSDT 00000000bf7fe120 0006C (v01 INTEL  DX58SO   0000084F      01000013)
ACPI: FACP 00000000bf7fd000 000F4 (v03 INTEL  DX58SO   0000084F MSFT 0100000D)
ACPI Warning (tbfadt-0562): Optional field Pm2ControlBlock has zero address or length: 0000000000000450/0 [20090320]
ACPI Warning (tbfadt-0612): Invalid length for Pm2ControlBlock: 0, using default 8 [20090320]
ACPI: DSDT 00000000bf7f8000 043CE (v02 INTEL  DX58SO   0000084F MSFT 0100000D)
ACPI: FACS 00000000bf726000 00040
ACPI: APIC 00000000bf7f7000 00138 (v02 INTEL  DX58SO   0000084F MSFT 0100000D)
ACPI: WDDT 00000000bf7f6000 00040 (v01 INTEL  DX58SO   0000084F MSFT 0100000D)
ACPI: MCFG 00000000bf7f5000 0003C (v01 INTEL  DX58SO   0000084F MSFT 0100000D)
ACPI: ASF! 00000000bf7f4000 000AC (v32 INTEL  DX58SO   0000084F MSFT 0100000D)
ACPI: SSDT 00000000bf7ea000 070AC (v01 INTEL  SSDT  PM 0000084F MSFT 0100000D)
ACPI: DMAR 00000000bf7e7000 00140 (v01 INTEL  DX58SO   0000084F MSFT 0100000D)
ACPI: WDTT 00000000bf7f2000 0020C (v01 INTEL  DX58SO   0000084F MSFT 0100000D)
ACPI: ASPT 00000000bf7f3000 00034 (v04 INTEL  PerfTune 0000084F MSFT 0100000D)
ACPI: Local APIC address 0xfee00000
(8 early reservations) ==> bootmem [0000000000 - 0140000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 0004d99a64]    TEXT DATA BSS ==> [0000200000 - 0004d99a64]
  #3 [0037c54000 - 0037fef547]          RAMDISK ==> [0037c54000 - 0037fef547]
  #4 [000009cc00 - 0000100000]    BIOS reserved ==> [000009cc00 - 0000100000]
  #5 [0004d9a000 - 0004d9a15e]              BRK ==> [0004d9a000 - 0004d9a15e]
  #6 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
  #7 [000000a000 - 000000b000]          PGTABLE ==> [000000a000 - 000000b000]
 [ffffe20000000000-ffffe200045fffff] PMD -> [ffff880028200000-ffff88002c7fffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00140000
Movable zone start PFN for each node
early_node_map[7] active PFN ranges
    0: 0x00000000 -> 0x0000009c
    0: 0x00000100 -> 0x000bcdc2
    0: 0x000bcfda -> 0x000bf6bd
    0: 0x000bf6bf -> 0x000bf714
    0: 0x000bf7bf -> 0x000bf7e7
    0: 0x000bf7ff -> 0x000bf800
    0: 0x00100000 -> 0x00140000
On node 0 totalpages: 1045695
  DMA zone: 56 pages used for memmap
  DMA zone: 105 pages reserved
  DMA zone: 3835 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 765275 pages, LIFO batch:31
  Normal zone: 3584 pages used for memmap
  Normal zone: 258560 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x06] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x10] disabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x12] disabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x14] disabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x16] disabled)
ACPI: LAPIC (acpi_id[0x09] lapic_id[0x11] disabled)
ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x13] disabled)
ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x15] disabled)
ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x17] disabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x04] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x05] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x06] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x07] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x08] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x09] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x0a] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x0b] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x0c] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x0d] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x0e] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x0f] high level lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 16 CPUs, 8 hotplug CPUs
nr_irqs_gsi: 24
Allocating PCI resources starting at c4000000 (gap: c0000000:38000000)
NR_CPUS:4096 nr_cpumask_bits:16 nr_cpu_ids:16 nr_node_ids:1
PERCPU: Embedded 25 pages at ffff88002c800000, static data 70816 bytes
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1027670
Kernel command line: ro root=UUID=f12abe85-327f-4e7d-9b06-5bb07624196d nogui
Initializing CPU#0
NR_IRQS:4352
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
Fast TSC calibration using PIT
Detected 3200.122 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
No AGP bridge found
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
software IO TLB at phys 0x20000000 - 0x24000000
Memory: 3946412k/5242880k available (3281k kernel code, 1060100k absent, 235492k reserved, 2494k data, 404k init)
Calibrating delay loop (skipped), value calculated using timer frequency.. 6400.24 BogoMIPS (lpj=12800488)
Mount-cache hash table entries: 256
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
CPU0: Thermal monitoring enabled (TM1)
CPU 0 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 CMCI:8
using mwait in idle threads.
ACPI: Core revision 20090320
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Genuine Intel(R) CPU             000  @ 3.20GHz stepping 04
Booting processor 1 APIC 0x2 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 6400.36 BogoMIPS (lpj=12800729)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
CPU1: Thermal monitoring enabled (TM1)
CPU 1 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Genuine Intel(R) CPU             000  @ 3.20GHz stepping 04
Skipping synchronization checks as TSC is reliable.
Booting processor 2 APIC 0x4 ip 0x6000
Initializing CPU#2
Calibrating delay using timer specific routine.. 6400.36 BogoMIPS (lpj=12800733)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
CPU2: Thermal monitoring enabled (TM1)
CPU 2 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
CPU2: Genuine Intel(R) CPU             000  @ 3.20GHz stepping 04
Skipping synchronization checks as TSC is reliable.
Booting processor 3 APIC 0x6 ip 0x6000
Initializing CPU#3
Calibrating delay using timer specific routine.. 6400.36 BogoMIPS (lpj=12800726)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
CPU3: Thermal monitoring enabled (TM1)
CPU 3 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
CPU3: Genuine Intel(R) CPU             000  @ 3.20GHz stepping 04
Skipping synchronization checks as TSC is reliable.
Booting processor 4 APIC 0x1 ip 0x6000
Initializing CPU#4
Calibrating delay using timer specific routine.. 6400.36 BogoMIPS (lpj=12800724)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
CPU4: Thermal monitoring enabled (TM1)
CPU 4 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
x86 PAT enabled: cpu 4, old 0x7040600070406, new 0x7010600070106
CPU4: Genuine Intel(R) CPU             000  @ 3.20GHz stepping 04
Skipping synchronization checks as TSC is reliable.
Booting processor 5 APIC 0x3 ip 0x6000
Initializing CPU#5
Calibrating delay using timer specific routine.. 6400.36 BogoMIPS (lpj=12800736)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
CPU5: Thermal monitoring enabled (TM1)
CPU 5 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
x86 PAT enabled: cpu 5, old 0x7040600070406, new 0x7010600070106
CPU5: Genuine Intel(R) CPU             000  @ 3.20GHz stepping 04
Skipping synchronization checks as TSC is reliable.
Booting processor 6 APIC 0x5 ip 0x6000
Initializing CPU#6
Calibrating delay using timer specific routine.. 6400.36 BogoMIPS (lpj=12800728)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
CPU6: Thermal monitoring enabled (TM1)
CPU 6 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
x86 PAT enabled: cpu 6, old 0x7040600070406, new 0x7010600070106
CPU6: Genuine Intel(R) CPU             000  @ 3.20GHz stepping 04
Skipping synchronization checks as TSC is reliable.
Booting processor 7 APIC 0x7 ip 0x6000
Initializing CPU#7
Calibrating delay using timer specific routine.. 6400.36 BogoMIPS (lpj=12800726)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
CPU7: Thermal monitoring enabled (TM1)
CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
x86 PAT enabled: cpu 7, old 0x7040600070406, new 0x7010600070106
CPU7: Genuine Intel(R) CPU             000  @ 3.20GHz stepping 04
Skipping synchronization checks as TSC is reliable.
Brought up 8 CPUs
Total of 8 processors activated (51202.79 BogoMIPS).
net_namespace: 1720 bytes
NET: Registered protocol family 16
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
dca service started, version 1.8
PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
PCI: MCFG area at f8000000 reserved in E820
PCI: Using MMCONFIG at f8000000 - fbffffff
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: PME# disabled
pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
pci 0000:00:07.0: PME# disabled
pci 0000:00:19.0: reg 10 32bit mmio: [0xc7200000-0xc721ffff]
pci 0000:00:19.0: reg 14 32bit mmio: [0xc7223000-0xc7223fff]
pci 0000:00:19.0: reg 18 io port: [0x5100-0x511f]
pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
pci 0000:00:19.0: PME# disabled
pci 0000:00:1a.0: reg 20 io port: [0x50e0-0x50ff]
pci 0000:00:1a.1: reg 20 io port: [0x50c0-0x50df]
pci 0000:00:1a.2: reg 20 io port: [0x50a0-0x50bf]
pci 0000:00:1a.7: reg 10 32bit mmio: [0xc7222000-0xc72223ff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1b.0: reg 10 64bit mmio: [0xf0000000-0xf0003fff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: PME# disabled
pci 0000:00:1d.0: reg 20 io port: [0x5080-0x509f]
pci 0000:00:1d.1: reg 20 io port: [0x5060-0x507f]
pci 0000:00:1d.2: reg 20 io port: [0x5040-0x505f]
pci 0000:00:1d.7: reg 10 32bit mmio: [0xc7221000-0xc72213ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 007f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0810 (mask 007f)
pci 0000:00:1f.2: reg 10 io port: [0x5128-0x512f]
pci 0000:00:1f.2: reg 14 io port: [0x5134-0x5137]
pci 0000:00:1f.2: reg 18 io port: [0x5120-0x5127]
pci 0000:00:1f.2: reg 1c io port: [0x5130-0x5133]
pci 0000:00:1f.2: reg 20 io port: [0x5020-0x503f]
pci 0000:00:1f.2: reg 24 32bit mmio: [0xc7220000-0xc72207ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: reg 10 64bit mmio: [0xf0004000-0xf00040ff]
pci 0000:00:1f.3: reg 20 io port: [0x5000-0x501f]
pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:00:03.0: bridge io port: [0x3000-0x4fff]
pci 0000:00:03.0: bridge 32bit mmio: [0xc0000000-0xc6ffffff]
pci 0000:00:03.0: bridge 64bit mmio pref: [0xd0000000-0xefffffff]
pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
pci 0000:03:00.0: PME# disabled
pci 0000:03:02.0: PME# supported from D0 D3hot D3cold
pci 0000:03:02.0: PME# disabled
pci 0000:02:00.0: bridge io port: [0x3000-0x4fff]
pci 0000:02:00.0: bridge 32bit mmio: [0xc0000000-0xc6ffffff]
pci 0000:02:00.0: bridge 64bit mmio pref: [0xd0000000-0xefffffff]
pci 0000:04:00.0: reg 10 32bit mmio: [0xc6000000-0xc6ffffff]
pci 0000:04:00.0: reg 14 64bit mmio: [0xe0000000-0xefffffff]
pci 0000:04:00.0: reg 1c 64bit mmio: [0xc4000000-0xc5ffffff]
pci 0000:04:00.0: reg 24 io port: [0x4000-0x407f]
pci 0000:04:00.0: reg 30 32bit mmio: [0xfffe0000-0xffffffff]
pci 0000:03:00.0: bridge io port: [0x4000-0x4fff]
pci 0000:03:00.0: bridge 32bit mmio: [0xc4000000-0xc6ffffff]
pci 0000:03:00.0: bridge 64bit mmio pref: [0xe0000000-0xefffffff]
pci 0000:05:00.0: reg 10 32bit mmio: [0xc2000000-0xc2ffffff]
pci 0000:05:00.0: reg 14 64bit mmio: [0xd0000000-0xdfffffff]
pci 0000:05:00.0: reg 1c 64bit mmio: [0xc0000000-0xc1ffffff]
pci 0000:05:00.0: reg 24 io port: [0x3000-0x307f]
pci 0000:05:00.0: reg 30 32bit mmio: [0xfffe0000-0xffffffff]
pci 0000:03:02.0: bridge io port: [0x3000-0x3fff]
pci 0000:03:02.0: bridge 32bit mmio: [0xc0000000-0xc2ffffff]
pci 0000:03:02.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
pci 0000:09:00.0: reg 10 io port: [0x2018-0x201f]
pci 0000:09:00.0: reg 14 io port: [0x2024-0x2027]
pci 0000:09:00.0: reg 18 io port: [0x2010-0x2017]
pci 0000:09:00.0: reg 1c io port: [0x2020-0x2023]
pci 0000:09:00.0: reg 20 io port: [0x2000-0x200f]
pci 0000:09:00.0: reg 24 32bit mmio: [0xc7100000-0xc71003ff]
pci 0000:09:00.0: supports D1
pci 0000:09:00.0: PME# supported from D0 D1 D3hot
pci 0000:09:00.0: PME# disabled
pci 0000:00:1c.4: bridge io port: [0x2000-0x2fff]
pci 0000:00:1c.4: bridge 32bit mmio: [0xc7100000-0xc71fffff]
pci 0000:0a:02.0: reg 10 32bit mmio: [0xc7020000-0xc703ffff]
pci 0000:0a:02.0: reg 14 32bit mmio: [0xc7000000-0xc701ffff]
pci 0000:0a:02.0: reg 18 io port: [0x1000-0x103f]
pci 0000:0a:02.0: reg 30 32bit mmio: [0xfffe0000-0xffffffff]
pci 0000:0a:02.0: PME# supported from D0 D3hot D3cold
pci 0000:0a:02.0: PME# disabled
pci 0000:0a:03.0: reg 10 32bit mmio: [0xc7044000-0xc70447ff]
pci 0000:0a:03.0: reg 14 32bit mmio: [0xc7040000-0xc7043fff]
pci 0000:0a:03.0: supports D1 D2
pci 0000:0a:03.0: PME# supported from D0 D1 D2 D3hot
pci 0000:0a:03.0: PME# disabled
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge io port: [0x1000-0x1fff]
pci 0000:00:1e.0: bridge 32bit mmio: [0xc7000000-0xc70fffff]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG7._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
DMAR:Host address width 39
DMAR:DRHD (flags: 0x00000000)base: 0x00000000fe711000
DMAR:DRHD (flags: 0x00000001)base: 0x00000000fe710000
DMAR:RMRR base: 0x00000000000e9000 end: 0x00000000000e9fff
DMAR:RMRR base: 0x00000000000ea000 end: 0x00000000000eafff
DMAR:RMRR base: 0x00000000000eb000 end: 0x00000000000ebfff
DMAR:RMRR base: 0x00000000000e6000 end: 0x00000000000e6fff
DMAR:RMRR base: 0x00000000000e7000 end: 0x00000000000e7fff
DMAR:RMRR base: 0x00000000000e8000 end: 0x00000000000e8fff
DMAR:RMRR base: 0x00000000000ec000 end: 0x00000000000eefff
hpet clockevent registered
HPET: 4 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 comparators, 64-bit 14.318180 MHz counter
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 2
Switched to high resolution mode on CPU 3
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 5
Switched to high resolution mode on CPU 6
Switched to high resolution mode on CPU 7
Switched to high resolution mode on CPU 4
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 8 devices
ACPI: ACPI bus type pnp unregistered
system 00:05: ioport range 0x500-0x53f has been reserved
system 00:05: ioport range 0x400-0x47f has been reserved
system 00:05: ioport range 0x680-0x6ff has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: disabled
pci 0000:00:01.0:   MEM window: disabled
pci 0000:00:01.0:   PREFETCH window: disabled
pci 0000:04:00.0: BAR 6: can't allocate mem resource [0xf0000000-0xefffffff]
pci 0000:03:00.0: PCI bridge, secondary bus 0000:04
pci 0000:03:00.0:   IO window: 0x4000-0x4fff
pci 0000:03:00.0:   MEM window: 0xc4000000-0xc6ffffff
pci 0000:03:00.0:   PREFETCH window: 0x000000e0000000-0x000000efffffff
pci 0000:05:00.0: BAR 6: can't allocate mem resource [0xe0000000-0xdfffffff]
pci 0000:03:02.0: PCI bridge, secondary bus 0000:05
pci 0000:03:02.0:   IO window: 0x3000-0x3fff
pci 0000:03:02.0:   MEM window: 0xc0000000-0xc2ffffff
pci 0000:03:02.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
pci 0000:02:00.0: PCI bridge, secondary bus 0000:03
pci 0000:02:00.0:   IO window: 0x3000-0x4fff
pci 0000:02:00.0:   MEM window: 0xc0000000-0xc6ffffff
pci 0000:02:00.0:   PREFETCH window: 0x000000d0000000-0x000000efffffff
pci 0000:00:03.0: PCI bridge, secondary bus 0000:02
pci 0000:00:03.0:   IO window: 0x3000-0x4fff
pci 0000:00:03.0:   MEM window: 0xc0000000-0xc6ffffff
pci 0000:00:03.0:   PREFETCH window: 0x000000d0000000-0x000000efffffff
pci 0000:00:07.0: PCI bridge, secondary bus 0000:06
pci 0000:00:07.0:   IO window: disabled
pci 0000:00:07.0:   MEM window: disabled
pci 0000:00:07.0:   PREFETCH window: disabled
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:07
pci 0000:00:1c.0:   IO window: disabled
pci 0000:00:1c.0:   MEM window: disabled
pci 0000:00:1c.0:   PREFETCH window: disabled
pci 0000:00:1c.1: PCI bridge, secondary bus 0000:08
pci 0000:00:1c.1:   IO window: disabled
pci 0000:00:1c.1:   MEM window: disabled
pci 0000:00:1c.1:   PREFETCH window: disabled
pci 0000:00:1c.4: PCI bridge, secondary bus 0000:09
pci 0000:00:1c.4:   IO window: 0x2000-0x2fff
pci 0000:00:1c.4:   MEM window: 0xc7100000-0xc71fffff
pci 0000:00:1c.4:   PREFETCH window: disabled
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0a
pci 0000:00:1e.0:   IO window: 0x1000-0x1fff
pci 0000:00:1e.0:   MEM window: 0xc7000000-0xc70fffff
pci 0000:00:1e.0:   PREFETCH window: 0x000000c7300000-0x000000c73fffff
pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:03.0: setting latency timer to 64
pci 0000:02:00.0: setting latency timer to 64
pci 0000:03:00.0: setting latency timer to 64
pci 0000:03:02.0: setting latency timer to 64
pci 0000:00:07.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:07.0: setting latency timer to 64
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.4: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:01: resource 0 mem: [0x0-0x0]
pci_bus 0000:01: resource 1 mem: [0x0-0x0]
pci_bus 0000:01: resource 2 mem: [0x0-0x0]
pci_bus 0000:01: resource 3 mem: [0x0-0x0]
pci_bus 0000:02: resource 0 io:  [0x3000-0x4fff]
pci_bus 0000:02: resource 1 mem: [0xc0000000-0xc6ffffff]
pci_bus 0000:02: resource 2 mem: [0xd0000000-0xefffffff]
pci_bus 0000:02: resource 3 mem: [0x0-0x0]
pci_bus 0000:03: resource 0 io:  [0x3000-0x4fff]
pci_bus 0000:03: resource 1 mem: [0xc0000000-0xc6ffffff]
pci_bus 0000:03: resource 2 mem: [0xd0000000-0xefffffff]
pci_bus 0000:03: resource 3 mem: [0x0-0x0]
pci_bus 0000:04: resource 0 io:  [0x4000-0x4fff]
pci_bus 0000:04: resource 1 mem: [0xc4000000-0xc6ffffff]
pci_bus 0000:04: resource 2 mem: [0xe0000000-0xefffffff]
pci_bus 0000:04: resource 3 mem: [0x0-0x0]
pci_bus 0000:05: resource 0 io:  [0x3000-0x3fff]
pci_bus 0000:05: resource 1 mem: [0xc0000000-0xc2ffffff]
pci_bus 0000:05: resource 2 mem: [0xd0000000-0xdfffffff]
pci_bus 0000:05: resource 3 mem: [0x0-0x0]
pci_bus 0000:06: resource 0 mem: [0x0-0x0]
pci_bus 0000:06: resource 1 mem: [0x0-0x0]
pci_bus 0000:06: resource 2 mem: [0x0-0x0]
pci_bus 0000:06: resource 3 mem: [0x0-0x0]
pci_bus 0000:07: resource 0 mem: [0x0-0x0]
pci_bus 0000:07: resource 1 mem: [0x0-0x0]
pci_bus 0000:07: resource 2 mem: [0x0-0x0]
pci_bus 0000:07: resource 3 mem: [0x0-0x0]
pci_bus 0000:08: resource 0 mem: [0x0-0x0]
pci_bus 0000:08: resource 1 mem: [0x0-0x0]
pci_bus 0000:08: resource 2 mem: [0x0-0x0]
pci_bus 0000:08: resource 3 mem: [0x0-0x0]
pci_bus 0000:09: resource 0 io:  [0x2000-0x2fff]
pci_bus 0000:09: resource 1 mem: [0xc7100000-0xc71fffff]
pci_bus 0000:09: resource 2 mem: [0x0-0x0]
pci_bus 0000:09: resource 3 mem: [0x0-0x0]
pci_bus 0000:0a: resource 0 io:  [0x1000-0x1fff]
pci_bus 0000:0a: resource 1 mem: [0xc7000000-0xc70fffff]
pci_bus 0000:0a: resource 2 mem: [0xc7300000-0xc73fffff]
pci_bus 0000:0a: resource 3 io:  [0x00-0xffff]
pci_bus 0000:0a: resource 4 mem: [0x000000-0xffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs...
rootfs image is initramfs; unpacking...
Freeing initrd memory: 3693k freed
Intel AES-NI instructions are not detected.
audit: initializing netlink socket (disabled)
type=2000 audit(1240390430.888:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
msgmni has been set to 7716
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
pci 0000:05:00.0: Boot video device
pcieport-driver 0000:00:01.0: irq 24 for MSI/MSI-X
pcieport-driver 0000:00:01.0: setting latency timer to 64
pcieport-driver 0000:00:03.0: irq 25 for MSI/MSI-X
pcieport-driver 0000:00:03.0: setting latency timer to 64
pcieport-driver 0000:00:07.0: irq 26 for MSI/MSI-X
pcieport-driver 0000:00:07.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: irq 27 for MSI/MSI-X
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.1: irq 28 for MSI/MSI-X
pcieport-driver 0000:00:1c.1: setting latency timer to 64
pcieport-driver 0000:00:1c.4: irq 29 for MSI/MSI-X
pcieport-driver 0000:00:1c.4: setting latency timer to 64
aer 0000:00:01.0:pcie02: AER service couldn't init device: no _OSC support
aer 0000:00:03.0:pcie02: AER service couldn't init device: no _OSC support
aer 0000:00:07.0:pcie02: AER service couldn't init device: no _OSC support
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
ACPI: Sleep Button (CM) [SLPB]
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-3 state
ACPI: CPU0 (power states: C1[C1] C2[C3])
processor ACPI_CPU:00: registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: CPU1 (power states: C1[C1] C2[C3])
processor ACPI_CPU:01: registered as cooling_device1
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: CPU2 (power states: C1[C1] C2[C3])
processor ACPI_CPU:02: registered as cooling_device2
ACPI: Processor [CPU2] (supports 8 throttling states)
ACPI: CPU3 (power states: C1[C1] C2[C3])
processor ACPI_CPU:03: registered as cooling_device3
ACPI: Processor [CPU3] (supports 8 throttling states)
ACPI: CPU4 (power states: C1[C1] C2[C3])
processor ACPI_CPU:04: registered as cooling_device4
ACPI: Processor [CPU4] (supports 8 throttling states)
ACPI: CPU5 (power states: C1[C1] C2[C3])
processor ACPI_CPU:05: registered as cooling_device5
ACPI: Processor [CPU5] (supports 8 throttling states)
ACPI: CPU6 (power states: C1[C1] C2[C3])
processor ACPI_CPU:06: registered as cooling_device6
ACPI: Processor [CPU6] (supports 8 throttling states)
ACPI: CPU7 (power states: C1[C1] C2[C3])
processor ACPI_CPU:07: registered as cooling_device7
ACPI: Processor [CPU7] (supports 8 throttling states)
Linux agpgart interface v0.103
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
brd: module loaded
usbcore: registered new interface driver libusual
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: PC Speaker as /devices/platform/pcspkr/input/input2
cpuidle: using governor ladder
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.19.
ALSA device list:
  No soundcards found.
TCP cubic registered
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
Freeing unused kernel memory: 404k freed
Write protecting the kernel read-only data: 4276k
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xc7222000
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.30-rc2-scsihost1-00368-gaefe647-dirty ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.7
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xc7221000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.30-rc2-scsihost1-00368-gaefe647-dirty ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 16, io base 0x000050e0
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.30-rc2-scsihost1-00368-gaefe647-dirty uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 21, io base 0x000050c0
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.30-rc2-scsihost1-00368-gaefe647-dirty uhci_hcd
usb usb4: SerialNumber: 0000:00:1a.1
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1a.2: setting latency timer to 64
uhci_hcd 0000:00:1a.2: UHCI Host Controller
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1a.2: irq 19, io base 0x000050a0
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.30-rc2-scsihost1-00368-gaefe647-dirty uhci_hcd
usb usb5: SerialNumber: 0000:00:1a.2
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00005080
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.30-rc2-scsihost1-00368-gaefe647-dirty uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.0
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00005060
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.30-rc2-scsihost1-00368-gaefe647-dirty uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.1
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00005040
usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb8: Product: UHCI Host Controller
usb usb8: Manufacturer: Linux 2.6.30-rc2-scsihost1-00368-gaefe647-dirty uhci_hcd
usb usb8: SerialNumber: 0000:00:1d.2
usb usb8: configuration #1 chosen from 1 choice
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 2 ports detected
SCSI subsystem initialized
Driver 'sd' needs updating - please use bus_type methods
libata version 3.00 loaded.
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT A -> GSI 19 (level, low) -> IRQ 19
ahci 0000:00:1f.2: irq 30 for MSI/MSI-X
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems 
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
ata1: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 30
ata2: SATA max UDMA/133 abar m2048@0xc7220000 port 0xc7220180 irq 30
ata3: SATA max UDMA/133 irq_stat 0x00400040 irq 30, connection status changed
ata4: SATA max UDMA/133 abar m2048@0xc7220000 port 0xc7220280 irq 30
ata5: SATA max UDMA/133 abar m2048@0xc7220000 port 0xc7220300 irq 30
ata6: SATA max UDMA/133 irq_stat 0x00400040, connection status changed
ahci 0000:09:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ahci 0000:09:00.0: controller can't do NCQ, turning off CAP_NCQ
ahci 0000:09:00.0: controller can't do PMP, turning off CAP_PMP
ahci 0000:09:00.0: MV_AHCI HACK: port_map 7 -> 3
ahci 0000:09:00.0: Disabling your PATA port. Use the boot option 'ahci.marvell_enable=0' to avoid this.
ahci: SSS flag set, parallel bus scan disabled
ahci 0000:09:00.0: AHCI 0001.0000 32 slots 3 ports 3 Gbps 0x3 impl IDE mode
ahci 0000:09:00.0: flags: 64bit stag led slum part 
ahci 0000:09:00.0: setting latency timer to 64
scsi1 : ahci
ata7: SATA max UDMA/133 abar m1024@0xc7100000 port 0xc7100100 irq 16
ata8: SATA max UDMA/133 abar m1024@0xc7100000 port 0xc7100180 irq 16
ata9: DUMMY
ata7: SATA link down (SStatus 0 SControl 300)
usb 4-1: new low speed USB device using uhci_hcd and address 2
usb 4-1: New USB device found, idVendor=045e, idProduct=0047
usb 4-1: New USB device strings: Mfr=1, Product=3, SerialNumber=0
usb 4-1: Product: Microsoft 5-Button Mouse with IntelliEye(TM)
usb 4-1: Manufacturer: Microsoft
usb 4-1: configuration #1 chosen from 1 choice
input: Microsoft Microsoft 5-Button Mouse with IntelliEye(TM) as /devices/pci0000:00/0000:00:1a.1/usb4/4-1/4-1:1.0/input/input3
generic-usb 0003:045E:0047.0001: input,hidraw0: USB HID v1.10 Mouse [Microsoft Microsoft 5-Button Mouse with IntelliEye(TM)] on usb-0000:00:1a.1-1/input0
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-8: ST3500320AS, SD15, max UDMA/133
ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
usb 4-2: new low speed USB device using uhci_hcd and address 3
ata2: SATA link down (SStatus 0 SControl 300)
usb 4-2: New USB device found, idVendor=045e, idProduct=000b
usb 4-2: New USB device strings: Mfr=0, Product=1, SerialNumber=0
usb 4-2: Product: Microsoft Natural Keyboard Elite
usb 4-2: configuration #1 chosen from 1 choice
input: Microsoft Natural Keyboard Elite as /devices/pci0000:00/0000:00:1a.1/usb4/4-2/4-2:1.0/input/input4
generic-usb 0003:045E:000B.0002: input,hidraw1: USB HID v1.10 Keyboard [Microsoft Natural Keyboard Elite] on usb-0000:00:1a.1-2/input0
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: ATA-8: G.SKILL 128GB SSD, 02.10104, max UDMA/100
ata3.00: 250445824 sectors, multi 0: LBA 
ata3.00: configured for UDMA/100
ata4: SATA link down (SStatus 0 SControl 300)
ata5: SATA link down (SStatus 0 SControl 300)
ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata6.00: ATAPI: PIONEER BD-ROM  BDC-202, 1.04, max UDMA/66
ata6.00: configured for UDMA/66
scsi 0:0:0:0: Direct-Access     ATA      ST3500320AS      SD15 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda:<5>scsi 0:2:0:0: Direct-Access     ATA      G.SKILL 128GB SS 02.1 PQ: 0 ANSI: 5
sd 0:2:0:0: [sdb] 250445824 512-byte hardware sectors: (128 GB/119 GiB)
sd 0:2:0:0: [sdb] Write Protect is off
sd 0:2:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 0:2:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1
sd 0:2:0:0: [sdb] Attached SCSI disk
scsi 0:5:0:0: CD-ROM            PIONEER  BD-ROM  BDC-202  1.04 PQ: 0 ANSI: 5
 sda1 sda2 sda3 sda4 < sda5 sda6 >
sd 0:0:0:0: [sda] Attached SCSI disk
ata8: SATA link down (SStatus 0 SControl 300)
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with writeback data mode.
udevd version 127 started
e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.4-k4
e1000e: Copyright (c) 1999-2008 Intel Corporation.
e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
e1000e 0000:00:19.0: setting latency timer to 64
e1000e 0000:00:19.0: irq 31 for MSI/MSI-X
0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1c:c0:79:c8:c2
0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: ffffff-0ff
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: setting latency timer to 64
firewire_ohci 0000:0a:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:2:0:0: Attached scsi generic sg1 type 0
scsi 0:5:0:0: Attached scsi generic sg2 type 5
firewire_ohci: Added fw-ohci device 0000:0a:03.0, OHCI version 1.10
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 32x/32x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 0:5:0:0: Attached scsi CD-ROM sr0
i801_smbus 0000:00:1f.3: PCI INT B -> GSI 18 (level, low) -> IRQ 18
firewire_core: created device fw0: GUID 0090270002258426, S400
EXT3 FS on sda2, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda3, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb1, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda6, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
Adding 6144820k swap on /dev/sda5.  Priority:-1 extents:1 across:6144820k 
platform microcode: firmware: requesting intel-ucode/06-1a-04
platform microcode: firmware: requesting intel-ucode/06-1a-04
platform microcode: firmware: requesting intel-ucode/06-1a-04
platform microcode: firmware: requesting intel-ucode/06-1a-04
platform microcode: firmware: requesting intel-ucode/06-1a-04
platform microcode: firmware: requesting intel-ucode/06-1a-04
platform microcode: firmware: requesting intel-ucode/06-1a-04
platform microcode: firmware: requesting intel-ucode/06-1a-04
Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Microcode Update Driver: v2.00 removed.
e1000e 0000:00:19.0: irq 31 for MSI/MSI-X
e1000e 0000:00:19.0: irq 31 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth0: link is not ready
NET: Registered protocol family 17
e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Bridge firewalling registered
virbr0: starting userspace STP failed, starting kernel STP
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
virbr0: no IPv6 routers present
fuse init (API version 7.11)

--2oS5YaxWCcQjTEyO--
