From: Xiangliang Yu <yxlraid@gmail.com>
Subject: [PATCH 2/3] libsas: add support for SATA port multiplier(PM)
Date: Thu, 24 Apr 2014 21:27:55 +0800
Message-ID: <1398346075-10326-1-git-send-email-yxlraid@gmail.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: tj@kernel.org, JBottomley@parallels.com
Cc: dan.j.williams@intel.com, todd.e.brandt@intel.com, lukasz.dorau@intel.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Xiangliang Yu <yxlraid@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Add support for SATA PM so that host can find devices that is
attached to PM, and add PM hotplug event support.

Signed-off-by: Xiangliang Yu <yxlraid@gmail.com>
---
 drivers/ata/libata-scsi.c           |   48 ++++-
 drivers/scsi/libsas/sas_ata.c       |  358 ++++++++++++++++++++++++++++++++++-
 drivers/scsi/libsas/sas_discover.c  |   25 +++-
 drivers/scsi/libsas/sas_internal.h  |    7 +
 drivers/scsi/libsas/sas_phy.c       |    1 +
 drivers/scsi/libsas/sas_port.c      |   12 ++
 drivers/scsi/libsas/sas_scsi_host.c |   12 +-
 include/scsi/libsas.h               |   13 ++-
 include/scsi/sas_ata.h              |    5 +
 9 files changed, 458 insertions(+), 23 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index ef8567d..969b3bb 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4091,7 +4091,8 @@ int ata_sas_port_start(struct ata_port *ap)
 	 */
 	if (!ap->ops->error_handler)
 		ap->pflags &= ~ATA_PFLAG_FROZEN;
-	return 0;
+
+	return ata_tport_add(ap->dev, ap);
 }
 EXPORT_SYMBOL_GPL(ata_sas_port_start);
 
@@ -4107,6 +4108,15 @@ EXPORT_SYMBOL_GPL(ata_sas_port_start);
 
 void ata_sas_port_stop(struct ata_port *ap)
 {
+	int i = 0;
+
+	/* delete pmp link */
+	if (ap->pmp_link) {
+		for (i = 0; i < ap->nr_pmp_links; i++)
+			ata_tlink_delete(&ap->pmp_link[i]);
+	}
+
+	ata_tport_delete(ap);
 }
 EXPORT_SYMBOL_GPL(ata_sas_port_stop);
 
@@ -4143,12 +4153,8 @@ EXPORT_SYMBOL_GPL(ata_sas_sync_probe);
 
 int ata_sas_port_init(struct ata_port *ap)
 {
-	int rc = ap->ops->port_start(ap);
-
-	if (rc)
-		return rc;
 	ap->print_id = atomic_inc_return(&ata_print_id);
-	return 0;
+	return ap->ops->port_start(ap);
 }
 EXPORT_SYMBOL_GPL(ata_sas_port_init);
 
@@ -4166,6 +4172,23 @@ void ata_sas_port_destroy(struct ata_port *ap)
 }
 EXPORT_SYMBOL_GPL(ata_sas_port_destroy);
 
+static struct ata_device *ata_sas_find_dev(struct scsi_device *sdev,
+		struct ata_port *ap)
+{
+	int devno = 0;
+
+	if (!sata_pmp_attached(ap)) {
+		if (unlikely(sdev->channel || sdev->lun))
+			return NULL;
+	} else {
+		if (unlikely(sdev->lun))
+			return NULL;
+		devno = sdev->channel;
+	}
+
+	return ata_find_dev(ap, devno);
+}
+
 /**
  *	ata_sas_slave_configure - Default slave_config routine for libata devices
  *	@sdev: SCSI device to configure
@@ -4177,8 +4200,11 @@ EXPORT_SYMBOL_GPL(ata_sas_port_destroy);
 
 int ata_sas_slave_configure(struct scsi_device *sdev, struct ata_port *ap)
 {
+	struct ata_device *dev = ata_sas_find_dev(sdev, ap);
+	BUG_ON(!dev);
+
 	ata_scsi_sdev_config(sdev);
-	ata_scsi_dev_config(sdev, ap->link.device);
+	ata_scsi_dev_config(sdev, dev);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ata_sas_slave_configure);
@@ -4196,11 +4222,15 @@ EXPORT_SYMBOL_GPL(ata_sas_slave_configure);
 int ata_sas_queuecmd(struct scsi_cmnd *cmd, struct ata_port *ap)
 {
 	int rc = 0;
+	struct ata_device *dev;
+	struct scsi_device *scsidev = cmd->device;
 
 	ata_scsi_dump_cdb(ap, cmd);
 
-	if (likely(ata_dev_enabled(ap->link.device)))
-		rc = __ata_scsi_queuecmd(cmd, ap->link.device);
+	dev = ata_sas_find_dev(scsidev, ap);
+
+	if (likely(dev && ata_dev_enabled(dev)))
+		rc = __ata_scsi_queuecmd(cmd, dev);
 	else {
 		cmd->result = (DID_BAD_TARGET << 16);
 		cmd->scsi_done(cmd);
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 29a19fd..c820042 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -201,6 +201,17 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
 	task = sas_alloc_task(GFP_ATOMIC);
 	if (!task)
 		goto out;
+
+	if (sata_pmp_attached(ap)) {
+		struct ata_device *adev = qc->dev;
+
+		if (!list_empty(&dev->children) &&
+			!ata_is_host_link(adev->link)) {
+			dev = adev->private_data;
+			BUG_ON(!dev);
+		}
+	}
+
 	task->dev = dev;
 	task->task_proto = SAS_PROTOCOL_STP;
 	task->task_done = sas_ata_task_done;
@@ -662,6 +673,31 @@ error:
 	return ret;
 }
 
+int sas_pm_revalidate_domain(struct domain_device *dev)
+{
+	struct ata_port *ap = NULL;
+	unsigned long flag;
+
+	ap = dev->sata_dev.ap;
+	if (!ap) {
+		SAS_DPRINTK("ap is null.\n");
+		return -1;
+	}
+
+	spin_lock_irqsave(ap->lock, flag);
+
+	/* avoid calling ata_scsi_hotplug function */
+	ap->pflags |= ATA_PFLAG_LOADING;
+
+	ata_port_schedule_eh(ap);
+
+	spin_unlock_irqrestore(ap->lock, flag);
+
+	sas_ata_wait_eh(dev);
+
+	return 0;
+}
+
 /*
  * notify the lldd to forget the sas_task for this internal ata command
  * that bypasses scsi-eh
@@ -801,6 +837,7 @@ int sas_ata_init(struct domain_device *found_dev)
 {
 	struct sas_ha_struct *ha = found_dev->port->ha;
 	struct Scsi_Host *shost = ha->core.shost;
+	struct sas_internal *i = dev_to_sas_internal(found_dev);
 	struct ata_port *ap;
 	int rc;
 
@@ -816,6 +853,7 @@ int sas_ata_init(struct domain_device *found_dev)
 	ap->private_data = found_dev;
 	ap->cbl = ATA_CBL_SATA;
 	ap->scsi_host = shost;
+
 	rc = ata_sas_port_init(ap);
 	if (rc) {
 		ata_sas_port_destroy(ap);
@@ -823,6 +861,10 @@ int sas_ata_init(struct domain_device *found_dev)
 	}
 	found_dev->sata_dev.ap = ap;
 
+	/* ata port support setting */
+	if (i->dft->lldd_dev_set)
+		i->dft->lldd_dev_set(found_dev);
+
 	return 0;
 }
 
@@ -868,7 +910,13 @@ static void sas_get_ata_command_set(struct domain_device *dev)
 	     fis->lbal         == 0 &&
 	     fis->lbam         == 0xCE &&
 	     fis->lbah         == 0xAA &&
-	     (fis->device & ~0x10) == 0))
+	     (fis->device & ~0x10) == 0)
+	    ||
+	    (fis->interrupt_reason == 1 &&	/* SATA PM */
+	     fis->lbal             == 1 &&
+	     fis->byte_count_low   == 0x69 &&
+	     fis->byte_count_high  == 0x96 &&
+	    (fis->device & ~0x10) == 0))
 
 		dev->sata_dev.command_set = ATA_COMMAND_SET;
 
@@ -884,18 +932,293 @@ static void sas_get_ata_command_set(struct domain_device *dev)
 		  fis->lbal         == 1 &&
 		  fis->lbam         == 0x3C &&
 		  fis->lbah         == 0xC3 &&
-		  fis->device       == 0)
-		||
-		 (fis->interrupt_reason == 1 &&	/* SATA PM */
-		  fis->lbal             == 1 &&
-		  fis->byte_count_low   == 0x69 &&
-		  fis->byte_count_high  == 0x96 &&
-		  (fis->device & ~0x10) == 0))
+		  fis->device       == 0))
 
 		/* Treat it as a superset? */
 		dev->sata_dev.command_set = ATAPI_COMMAND_SET;
 }
 
+/* Support unplug event of PMP attahced device*/
+void sas_ata_detach_dev(struct ata_port *ap, struct ata_device *dev)
+{
+	struct domain_device *parent = ap->private_data;
+	struct domain_device *child = NULL, *n;
+	struct sata_device *sdev = &parent->sata_dev;
+	struct ata_link *link = dev->link;
+	struct ex_phy *ephy = &sdev->ephy[link->pmp];
+
+	list_for_each_entry_safe(child, n, &parent->children, siblings) {
+
+		if (child->sata_dev.port_no == link->pmp) {
+			sas_unregister_dev(parent->port, child);
+
+			memset(ephy->attached_sas_addr, 0, SAS_ADDR_SIZE);
+			if (ephy->port) {
+				sas_port_delete_phy(ephy->port, ephy->phy);
+				sas_device_set_phy(child, ephy->port);
+				if (ephy->port->num_phys == 0)
+					sas_port_delete(ephy->port);
+				ephy->port = NULL;
+			}
+
+			break;
+		}
+	}
+}
+
+static void sas_ata_alloc_sas_phy(struct domain_device *parent,
+		struct ata_device *dev)
+{
+	struct sata_device *sdev = &parent->sata_dev;
+	struct ata_link *link = dev->link;
+	struct ex_phy *ephy = &sdev->ephy[link->pmp];
+	struct sas_rphy *rphy = parent->rphy;
+	struct sas_phy *phy = NULL;
+	unsigned int num_phys = 0, phy_id;
+
+	if (ephy->phy) {
+		SAS_DPRINTK("phy is not null.\n");
+		return;
+	}
+	num_phys = parent->port->ha->num_phys;
+
+	phy_id = num_phys + (parent->phy->number + 1) * link->pmp;
+	ephy->phy = sas_phy_alloc(&rphy->dev, phy_id);
+
+	phy = ephy->phy;
+	BUG_ON(!phy);
+
+	ephy->attached_dev_type = SAS_SATA_DEV;
+	ephy->phy_id = link->pmp;
+	ephy->attached_tproto = parent->tproto;
+	ephy->attached_iproto = parent->iproto;
+
+	phy->identify.device_type = SAS_SATA_DEV;
+	phy->identify.initiator_port_protocols = SAS_PROTOCOL_SATA;
+	phy->identify.target_port_protocols = SAS_PROTOCOL_SATA;
+	phy->identify.phy_identifier = phy_id;
+
+	sas_phy_add(phy);
+}
+
+static void sas_ata_free_sas_phy(struct domain_device *parent,
+		struct ata_device *dev)
+{
+	struct sata_device *sdev = &parent->sata_dev;
+	struct ata_link *link = dev->link;
+	struct ex_phy *ephy = &sdev->ephy[link->pmp];
+	struct sas_phy *phy = ephy->phy;
+
+	sas_phy_delete(phy);
+	sas_phy_free(phy);
+
+	ephy->phy = NULL;
+}
+
+/* alloc domain device for each sata device and insert it into children list */
+static int sas_ata_alloc_ddev(struct domain_device *parent,
+		struct ata_device *dev)
+{
+	struct ata_link *link = dev->link;
+	struct domain_device *child = NULL;
+	struct sata_device *sdev = &parent->sata_dev;
+	struct ex_phy *ephy = &sdev->ephy[link->pmp];
+	struct sas_rphy *rphy = NULL;
+	int ret = -1;
+
+	child = sas_alloc_device();
+	if (!child) {
+		SAS_DPRINTK("can't alloc child device.\n");
+		goto error;
+	}
+
+	kref_get(&parent->kref);
+	child->parent = parent;
+	child->port = parent->port;
+	child->tproto = parent->tproto;
+	child->dev_type = SAS_SATA_DEV;
+	child->sata_dev.port_no = link->pmp;
+	child->sata_dev.command_set = ATA_COMMAND_SET;
+	child->sata_dev.ap = parent->sata_dev.ap;
+
+	if (!ephy->port) {
+		ephy->port = sas_port_alloc(&parent->rphy->dev,
+				ephy->phy->number);
+		if (unlikely(!ephy->port)) {
+			SAS_DPRINTK("fail to alloc sas port.\n");
+			goto free;
+		}
+		if (unlikely(sas_port_add(ephy->port) != 0)) {
+			SAS_DPRINTK("can't add sas port.\n");
+			goto out;
+		}
+	}
+
+	BUG_ON(!ephy->phy);
+
+	sas_port_add_phy(ephy->port, ephy->phy);
+
+	rphy = sas_end_device_alloc(ephy->port);
+	if (!rphy) {
+		SAS_DPRINTK("fail to alloc end device.\n");
+		goto out;
+	}
+
+	rphy->identify.phy_identifier = parent->phy->identify.phy_identifier;
+	memcpy(child->sas_addr, parent->sas_addr, SAS_ADDR_SIZE);
+	sas_fill_in_rphy(child, rphy);
+	sas_hash_addr(child->hashed_sas_addr, child->sas_addr);
+	child->linkrate = parent->linkrate;
+	child->min_linkrate = child->linkrate;
+	child->max_linkrate = child->linkrate;
+	child->pathways = parent->pathways;
+
+	sas_device_set_phy(child, ephy->port);
+
+	child->rphy = rphy;
+	get_device(&child->rphy->dev);
+
+	list_add_tail(&child->siblings, &parent->children);
+	dev->private_data = child;
+
+	return 0;
+out:
+	sas_port_free(ephy->port);
+free:
+	ephy->port = NULL;
+	sas_put_device(child);
+error:
+	SAS_DPRINTK("error exit.\n");
+	return ret;
+}
+
+static void sas_ata_free_ddev(struct domain_device *parent,
+		struct ata_device *dev)
+{
+	struct ata_link *link = dev->link;
+	struct domain_device *child = NULL;
+	struct sata_device *sdev = &parent->sata_dev;
+	struct ex_phy *ephy = &sdev->ephy[link->pmp];
+	struct sas_rphy *rphy = NULL;
+
+	child = dev->private_data;
+	rphy = child->rphy;
+
+	list_del_init(&child->siblings);
+
+	sas_rphy_free(rphy);
+
+	sas_port_delete(ephy->port);
+	ephy->port = NULL;
+
+	sas_put_device(child);
+	dev->private_data = NULL;
+}
+
+static int sas_ata_add_ddev(struct domain_device *parent,
+		struct ata_device *dev)
+{
+	struct ata_link *link = dev->link;
+	struct domain_device *child, *n;
+	struct sas_rphy *rphy = NULL;
+	int ret = 0;
+
+	list_for_each_entry_safe(child, n, &parent->children, siblings)
+	{
+		if (child->sata_dev.port_no != link->pmp)
+			continue;
+
+		ret = sas_notify_lldd_dev_found(child);
+		if (ret) {
+			SAS_DPRINTK(" fail to notify lldd.\n");
+			return ret;
+		}
+		rphy = child->rphy;
+
+		ret = sas_rphy_add(rphy);
+		if (ret) {
+			sas_notify_lldd_dev_gone(child);
+			SAS_DPRINTK("fail to add rphy.\n");
+			return ret;
+		}
+
+		spin_lock_irq(&parent->port->dev_list_lock);
+		list_add_tail(&child->dev_list_node, &parent->port->dev_list);
+		spin_unlock_irq(&parent->port->dev_list_lock);
+	}
+
+	return ret;
+}
+
+void sas_ata_scan_host(struct ata_port *ap)
+{
+	struct ata_link *link;
+	struct ata_device *dev;
+	struct domain_device *parent = ap->private_data;
+	struct sas_port *port = NULL;
+	struct sata_device *sdev = NULL;
+	int ret = 0;
+
+	if (!sata_pmp_attached(ap)) {
+		SAS_DPRINTK("ap is not pmp attached.\n");
+		return;
+	}
+
+	port = parent->port->port;
+	if (unlikely(!port->rphy)) {
+		ret = sas_rphy_add(parent->rphy);
+		if (ret) {
+			SAS_DPRINTK("fail to add rphy .\n");
+			sas_fail_probe(parent, __func__, ret);
+			return;
+		}
+		list_del_init(&parent->disco_list_node);
+	}
+
+	sdev = &parent->sata_dev;
+
+	if (unlikely(!sdev->ephy)) {
+		sdev->ephy = kzalloc(sizeof(*sdev->ephy) * ap->nr_pmp_links,
+					GFP_KERNEL);
+		if (!sdev->ephy) {
+			SAS_DPRINTK("failed to alloc ex_phy.\n");
+			sas_rphy_delete(parent->rphy);
+			sas_fail_probe(parent, __func__, -ENOMEM);
+			return;
+		}
+	}
+
+	ata_for_each_link(link, ap, EDGE) {
+		ata_for_each_dev(dev, link, ALL) {
+
+			if (dev->flags & ATA_DFLAG_DETACHED) {
+				SAS_DPRINTK("unplug device.\n");
+				sas_ata_detach_dev(ap, dev);
+				continue;
+			}
+
+			if (dev->sdev || !ata_dev_enabled(dev))
+				continue;
+
+			sas_ata_alloc_sas_phy(parent, dev);
+
+			ret = sas_ata_alloc_ddev(parent, dev);
+			if (ret) {
+				SAS_DPRINTK("fail to alloc child dev.\n");
+				sas_ata_free_sas_phy(parent, dev);
+				continue;
+			}
+
+			ret = sas_ata_add_ddev(parent, dev);
+			if (ret) {
+				SAS_DPRINTK("fail to add sas dev.\n");
+				sas_ata_free_ddev(parent, dev);
+				sas_ata_free_sas_phy(parent, dev);
+			}
+		}
+	}
+}
+
 void sas_probe_sata(struct asd_sas_port *port)
 {
 	struct domain_device *dev, *n;
@@ -996,8 +1319,16 @@ int sas_discover_sata(struct domain_device *dev)
 {
 	int res;
 
-	if (dev->dev_type == SAS_SATA_PM)
-		return -ENODEV;
+	if (dev->dev_type == SAS_SATA_PM) {
+		struct ata_port *ap = dev->sata_dev.ap;
+
+		if (unlikely(!ap))
+			BUG();
+
+		/* if lldd do not support pmp, end discover */
+		if (!(ap->flags & ATA_FLAG_PMP))
+			return -ENODEV;
+	}
 
 	sas_get_ata_command_set(dev);
 	sas_fill_in_rphy(dev, dev->rphy);
@@ -1047,6 +1378,10 @@ void sas_ata_strategy_handler(struct Scsi_Host *shost)
 			if (!dev_is_sata(dev))
 				continue;
 
+			if (dev->parent &&
+				(dev->parent->dev_type == SAS_SATA_PM))
+				continue;
+
 			/* hold a reference over eh since we may be
 			 * racing with final remove once all commands
 			 * are completed
@@ -1136,4 +1471,7 @@ void sas_ata_wait_eh(struct domain_device *dev)
 
 	ap = dev->sata_dev.ap;
 	ata_port_wait_eh(ap);
+
+	/* add sata device that is attached to PM */
+	sas_ata_scan_host(ap);
 }
diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 62b58d3..6d4b0bd 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -42,6 +42,9 @@ void sas_init_dev(struct domain_device *dev)
 	case SAS_END_DEVICE:
 		INIT_LIST_HEAD(&dev->ssp_dev.eh_list_node);
 		break;
+	case SAS_SATA_PM:
+		INIT_LIST_HEAD(&dev->children);
+		break;
 	case SAS_EDGE_EXPANDER_DEVICE:
 	case SAS_FANOUT_EXPANDER_DEVICE:
 		INIT_LIST_HEAD(&dev->ex_dev.children);
@@ -110,6 +113,7 @@ static int sas_get_port_device(struct asd_sas_port *port)
 	dev->port = port;
 	switch (dev->dev_type) {
 	case SAS_SATA_DEV:
+	case SAS_SATA_PM:
 		rc = sas_ata_init(dev);
 		if (rc) {
 			rphy = NULL;
@@ -319,6 +323,14 @@ void sas_free_device(struct kref *kref)
 		kfree(dev->ex_dev.ex_phy);
 
 	if (dev_is_sata(dev) && dev->sata_dev.ap) {
+		/* PMP attached device */
+		if (dev->parent) {
+			kfree(dev);
+			return;
+		}
+
+		kfree(dev->sata_dev.ephy);
+
 		ata_sas_port_destroy(dev->sata_dev.ap);
 		dev->sata_dev.ap = NULL;
 	}
@@ -500,6 +512,7 @@ static void sas_revalidate_domain(struct work_struct *work)
 	struct sas_discovery_event *ev = to_sas_discovery_event(work);
 	struct asd_sas_port *port = ev->port;
 	struct sas_ha_struct *ha = port->ha;
+	struct domain_device *dev = NULL;
 
 	/* prevent revalidation from finding sata links in recovery */
 	mutex_lock(&ha->disco_mutex);
@@ -514,8 +527,16 @@ static void sas_revalidate_domain(struct work_struct *work)
 	SAS_DPRINTK("REVALIDATING DOMAIN on port %d, pid:%d\n", port->id,
 		    task_pid_nr(current));
 
-	if (port->port_dev)
-		res = sas_ex_revalidate_domain(port->port_dev);
+	if (port->port_dev) {
+		dev = port->port_dev;
+		/* SATA port multiplier hotplug */
+		if (dev->dev_type == SAS_SATA_PM) {
+			mutex_unlock(&ha->disco_mutex);
+			res = sas_pm_revalidate_domain(dev);
+			mutex_lock(&ha->disco_mutex);
+		} else
+			res = sas_ex_revalidate_domain(dev);
+	}
 
 	SAS_DPRINTK("done REVALIDATING DOMAIN on port %d, pid:%d, res 0x%x\n",
 		    port->id, task_pid_nr(current), res);
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 7e7ba83..ba11001 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -77,6 +77,7 @@ void sas_deform_port(struct asd_sas_phy *phy, int gone);
 
 void sas_porte_bytes_dmaed(struct work_struct *work);
 void sas_porte_broadcast_rcvd(struct work_struct *work);
+void sas_porte_sntf_rcvd(struct work_struct *work);
 void sas_porte_link_reset_err(struct work_struct *work);
 void sas_porte_timer_event(struct work_struct *work);
 void sas_porte_hard_reset(struct work_struct *work);
@@ -131,6 +132,12 @@ static inline void sas_fill_in_rphy(struct domain_device *dev,
 	rphy->identify.initiator_port_protocols = dev->iproto;
 	rphy->identify.target_port_protocols = dev->tproto;
 	switch (dev->dev_type) {
+	case SAS_SATA_PM:
+		/* SATA port multiplier don't need to scan target in
+		 * sas_rphy_add function and need device type when
+		 * removing module
+		 */
+		rphy->identify.target_port_protocols = SAS_PROTOCOL_NONE;
 	case SAS_SATA_DEV:
 		/* FIXME: need sata device type */
 	case SAS_END_DEVICE:
diff --git a/drivers/scsi/libsas/sas_phy.c b/drivers/scsi/libsas/sas_phy.c
index cdee446..ade4ff7 100644
--- a/drivers/scsi/libsas/sas_phy.c
+++ b/drivers/scsi/libsas/sas_phy.c
@@ -134,6 +134,7 @@ int sas_register_phys(struct sas_ha_struct *sas_ha)
 		[PORTE_LINK_RESET_ERR] = sas_porte_link_reset_err,
 		[PORTE_TIMER_EVENT] = sas_porte_timer_event,
 		[PORTE_HARD_RESET] = sas_porte_hard_reset,
+		[PORTE_SNTF_RCVD] = sas_porte_sntf_rcvd,
 	};
 
 	/* Now register the phys. */
diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index d3c5297..3a4c514 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -266,6 +266,18 @@ void sas_porte_bytes_dmaed(struct work_struct *work)
 	sas_form_port(phy);
 }
 
+/* Support SATA port multiplier hotplug event */
+void sas_porte_sntf_rcvd(struct work_struct *work)
+{
+	struct asd_sas_event *ev = to_asd_sas_event(work);
+	struct asd_sas_phy *phy = ev->phy;
+
+	clear_bit(PORTE_SNTF_RCVD, &phy->port_events_pending);
+
+	SAS_DPRINTK("pm sntf received.\n");
+	sas_discover_event(phy->port, DISCE_REVALIDATE_DOMAIN);
+}
+
 void sas_porte_broadcast_rcvd(struct work_struct *work)
 {
 	struct asd_sas_event *ev = to_asd_sas_event(work);
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 25d0f12..0c3b88b 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -916,6 +916,12 @@ int sas_target_alloc(struct scsi_target *starget)
 
 	kref_get(&found_dev->kref);
 	starget->hostdata = found_dev;
+
+	/* find ata device through channel field */
+	if (found_dev->parent &&
+		(found_dev->parent->dev_type == SAS_SATA_PM))
+		starget->channel = found_dev->sata_dev.port_no;
+
 	return 0;
 }
 
@@ -929,7 +935,11 @@ int sas_slave_configure(struct scsi_device *scsi_dev)
 	BUG_ON(dev->rphy->identify.device_type != SAS_END_DEVICE);
 
 	if (dev_is_sata(dev)) {
-		ata_sas_slave_configure(scsi_dev, dev->sata_dev.ap);
+		struct domain_device *parent = dev;
+		if (dev->parent && (dev->parent->dev_type == SAS_SATA_PM))
+			parent = dev->parent;
+
+		ata_sas_slave_configure(scsi_dev, parent->sata_dev.ap);
 		return 0;
 	}
 
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index a26466a..6ba1dd3 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -71,7 +71,8 @@ enum port_event {
 	PORTE_LINK_RESET_ERR  = 2,
 	PORTE_TIMER_EVENT     = 3,
 	PORTE_HARD_RESET      = 4,
-	PORT_NUM_EVENTS       = 5,
+	PORTE_SNTF_RCVD       = 5,
+	PORT_NUM_EVENTS       = 6,
 };
 
 enum phy_event {
@@ -173,6 +174,11 @@ struct sata_device {
         struct smp_resp        rps_resp; /* report_phy_sata_resp */
         u8     port_no;        /* port number, if this is a PM (Port) */
 
+	/* Allocate sas phy and port for each devcie that
+	 * is attached to port multiplier.
+	 */
+	struct ex_phy *ephy;
+
 	struct ata_port *ap;
 	struct ata_host ata_host;
 	u8     fis[ATA_RESP_FIS_SIZE];
@@ -204,6 +210,7 @@ struct domain_device {
 
         struct domain_device *parent;
         struct list_head siblings; /* devices on the same level */
+	struct list_head children;
         struct asd_sas_port *port;        /* shortcut to root of the tree */
 	struct sas_phy *phy;
 
@@ -695,6 +702,9 @@ struct sas_domain_function_template {
 	void (*lldd_dev_thaw)(struct domain_device *);
 	int (*lldd_wait_task_done)(struct sas_task *);
 	int (*lldd_dev_classify)(struct domain_device *);
+
+	/* SATA Port multiplier setting */
+	void (*lldd_dev_set)(struct domain_device *);
 };
 
 extern int sas_register_ha(struct sas_ha_struct *);
@@ -725,6 +735,7 @@ int  sas_discover_root_expander(struct domain_device *);
 void sas_init_ex_attr(void);
 
 int  sas_ex_revalidate_domain(struct domain_device *);
+int  sas_pm_revalidate_domain(struct domain_device *);
 
 void sas_unregister_domain_devices(struct asd_sas_port *port, int gone);
 void sas_init_disc(struct sas_discovery *disc, struct asd_sas_port *);
diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
index 00f41ae..9a638c5 100644
--- a/include/scsi/sas_ata.h
+++ b/include/scsi/sas_ata.h
@@ -48,6 +48,7 @@ void sas_probe_sata(struct asd_sas_port *port);
 void sas_suspend_sata(struct asd_sas_port *port);
 void sas_resume_sata(struct asd_sas_port *port);
 void sas_ata_end_eh(struct ata_port *ap);
+void sas_ata_scan_host(struct ata_port *ap);
 #else
 
 
@@ -100,6 +101,10 @@ static inline int sas_get_ata_info(struct domain_device *dev, struct ex_phy *phy
 static inline void sas_ata_end_eh(struct ata_port *ap)
 {
 }
+
+static inline void sas_ata_scan_host(struct ata_port *ap)
+{
+}
 #endif
 
 #endif /* _SAS_ATA_H_ */
-- 
1.7.1

