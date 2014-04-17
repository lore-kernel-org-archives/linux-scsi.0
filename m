From: xiangliang yu <yxlraid@gmail.com>
Subject: Please help me to review the patch about supporting SATA PM in LIBSAS
Date: Thu, 17 Apr 2014 11:07:09 +0800
Message-ID: <CAP0P+NUR1AAxfGT5artyJeD7NNnkq2R=oHJ06VN3zQiLj9qTFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:38896 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708AbaDQDHL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Apr 2014 23:07:11 -0400
Received: by mail-la0-f49.google.com with SMTP id mc6so8630481lab.8
        for <linux-scsi@vger.kernel.org>; Wed, 16 Apr 2014 20:07:10 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, dan.j.williams@intel.com, pmurali@logicube.com, linux-scsi@vger.kernel.org

hi,

The patch is support SATA PM device and can  find all devices that is
attached to PM.
Until now, i have tested the identified, hot-plug and IO function and
result is ok except one mvsas timeout issue.
i'll continue to debug mvsas issue, but i don't know whether the
libsas code of the patch is ok.
So, please help me to review the patch if you feel free. thanks!
the patch is as below:


>From b7fba4dac79de4f74e552e374e3a2a5b2cee3216 Mon Sep 17 00:00:00 2001
From: root <root@localhost.localdomain>
Date: Thu, 17 Apr 2014 10:27:06 +0800
Subject: [PATCH 1/1] LIBSAS: add support for SATA PMP

 - Add support for PM feature

Signed-off-by: root <root@localhost.localdomain>
---
 drivers/ata/libata-scsi.c           |   53 +++-
 drivers/scsi/libsas/sas_ata.c       |  515 ++++++++++++++++++++++++++++++++++-
 drivers/scsi/libsas/sas_discover.c  |   25 ++-
 drivers/scsi/libsas/sas_internal.h  |    2 +
 drivers/scsi/libsas/sas_phy.c       |    1 +
 drivers/scsi/libsas/sas_port.c      |   11 +
 drivers/scsi/libsas/sas_scsi_host.c |   10 +-
 drivers/scsi/mvsas/mv_64xx.c        |    2 +
 drivers/scsi/mvsas/mv_94xx.c        |   20 ++-
 drivers/scsi/mvsas/mv_init.c        |    7 +-
 drivers/scsi/mvsas/mv_sas.c         |  191 +++++++++++++
 drivers/scsi/mvsas/mv_sas.h         |    9 +
 include/scsi/libsas.h               |   13 +
 include/scsi/sas_ata.h              |    1 +
 14 files changed, 836 insertions(+), 24 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index ef8567d..e897432 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4085,13 +4085,19 @@ EXPORT_SYMBOL_GPL(ata_sas_port_alloc);
  */
 int ata_sas_port_start(struct ata_port *ap)
 {
+ int rc = 0;
+
+ if (ap->flags & ATA_FLAG_PMP)
+ rc = ata_tport_add(ap->dev, ap);
+
  /*
  * the port is marked as frozen at allocation time, but if we don't
  * have new eh, we won't thaw it
  */
  if (!ap->ops->error_handler)
  ap->pflags &= ~ATA_PFLAG_FROZEN;
- return 0;
+
+ return rc;
 }
 EXPORT_SYMBOL_GPL(ata_sas_port_start);

@@ -4107,6 +4113,16 @@ EXPORT_SYMBOL_GPL(ata_sas_port_start);

 void ata_sas_port_stop(struct ata_port *ap)
 {
+ int i = 0;
+
+ if (ap->flags & ATA_FLAG_PMP) {
+ if (ap->pmp_link) {
+ for (i = 0; i < ap->nr_pmp_links; i++)
+ ata_tlink_delete(&ap->pmp_link[i]);
+ }
+
+ ata_tport_delete(ap);
+ }
 }
 EXPORT_SYMBOL_GPL(ata_sas_port_stop);

@@ -4143,12 +4159,10 @@ EXPORT_SYMBOL_GPL(ata_sas_sync_probe);

 int ata_sas_port_init(struct ata_port *ap)
 {
- int rc = ap->ops->port_start(ap);
+ int rc = 0;

- if (rc)
- return rc;
  ap->print_id = atomic_inc_return(&ata_print_id);
- return 0;
+ return ap->ops->port_start(ap);
 }
 EXPORT_SYMBOL_GPL(ata_sas_port_init);

@@ -4166,6 +4180,23 @@ void ata_sas_port_destroy(struct ata_port *ap)
 }
 EXPORT_SYMBOL_GPL(ata_sas_port_destroy);

+static struct ata_device *ata_sas_find_dev(struct scsi_device *sdev,
+ struct ata_port *ap)
+{
+ int devno = 0;
+
+ if (!sata_pmp_attached(ap)) {
+ if (unlikely(sdev->channel || sdev->lun))
+ return NULL;
+ } else {
+ if (unlikely(sdev->lun))
+ return NULL;
+ devno = sdev->channel;
+ }
+
+ return ata_find_dev(ap, devno);
+}
+
 /**
  * ata_sas_slave_configure - Default slave_config routine for libata devices
  * @sdev: SCSI device to configure
@@ -4177,8 +4208,10 @@ EXPORT_SYMBOL_GPL(ata_sas_port_destroy);

 int ata_sas_slave_configure(struct scsi_device *sdev, struct ata_port *ap)
 {
+ struct ata_device *dev = ata_sas_find_dev(sdev, ap);
+
  ata_scsi_sdev_config(sdev);
- ata_scsi_dev_config(sdev, ap->link.device);
+ ata_scsi_dev_config(sdev, dev);
  return 0;
 }
 EXPORT_SYMBOL_GPL(ata_sas_slave_configure);
@@ -4195,12 +4228,16 @@ EXPORT_SYMBOL_GPL(ata_sas_slave_configure);

 int ata_sas_queuecmd(struct scsi_cmnd *cmd, struct ata_port *ap)
 {
+ struct ata_device *dev = NULL;
+ struct scsi_device *scsidev = cmd->device;
  int rc = 0;

  ata_scsi_dump_cdb(ap, cmd);

- if (likely(ata_dev_enabled(ap->link.device)))
- rc = __ata_scsi_queuecmd(cmd, ap->link.device);
+ dev = ata_sas_find_dev(scsidev, ap);
+
+ if (likely(ata_dev_enabled(dev)))
+ rc = __ata_scsi_queuecmd(cmd, dev);
  else {
  cmd->result = (DID_BAD_TARGET << 16);
  cmd->scsi_done(cmd);
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 766098a..8bb5186 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -548,11 +548,250 @@ void sas_ata_end_eh(struct ata_port *ap)
  spin_unlock_irqrestore(&ha->lock, flags);
 }

+static void sas_ata_freeze(struct ata_port *ap)
+{
+ struct domain_device *dev = ap->private_data;
+ struct sas_ha_struct *sas_ha = dev->port->ha;
+ struct Scsi_Host *host = sas_ha->core.shost;
+ struct sas_internal *i = to_sas_internal(host->transportt);
+
+ if (i->dft->lldd_dev_freeze)
+ i->dft->lldd_dev_freeze(dev);
+}
+
+static void sas_ata_thaw(struct ata_port *ap)
+{
+ struct domain_device *dev = ap->private_data;
+ struct sas_ha_struct *sas_ha = dev->port->ha;
+ struct Scsi_Host *host = sas_ha->core.shost;
+ struct sas_internal *i = to_sas_internal(host->transportt);
+
+ if (i->dft->lldd_dev_thaw)
+ i->dft->lldd_dev_thaw(dev);
+}
+
+static int sas_ata_wait_task_done(struct sas_task *task, unsigned long timeout,
+ int (*check_done)(struct sas_task *task))
+{
+ struct ata_port *ap = task->uldd_task;
+ unsigned long deadline;
+ int done = -1;
+
+ if (!check_done) {
+ SAS_DPRINTK("check function is null.\n");
+ return done;
+ }
+
+ deadline = ata_deadline(jiffies, timeout);
+
+ done = check_done(task);
+ while (done && time_before(jiffies, deadline)) {
+ ata_msleep(ap, 1);
+
+ done = check_done(task);
+ }
+
+ return done;
+}
+
+static int sas_ata_exec_polled_cmd(struct ata_port *ap, struct
ata_taskfile *tf,
+ int pmp, unsigned long timeout)
+{
+ struct domain_device *dev = ap->private_data;
+ struct sas_ha_struct *sas_ha = dev->port->ha;
+ struct Scsi_Host *host = sas_ha->core.shost;
+ struct sas_internal *i = to_sas_internal(host->transportt);
+ struct sas_task *task = NULL;
+ int ret = -1;
+
+ if (!i->dft->lldd_execute_task) {
+ SAS_DPRINTK("execute function is null.\n");
+ goto fail;
+ }
+
+ task = sas_alloc_task(GFP_ATOMIC);
+ if (!task) {
+ SAS_DPRINTK("failed to alloc sas task.\n");
+ goto fail;
+ }
+
+ task->dev = dev;
+ task->task_proto = SAS_PROTOCOL_SATA;
+ task->uldd_task = ap;
+
+ ata_tf_to_fis(tf, pmp, 0, (u8 *)&task->ata_task.fis);
+ task->ata_task.retry_count = 1;
+ task->task_state_flags = SAS_TASK_STATE_PENDING;
+ if (tf->ctl & ATA_SRST)
+ task->task_state_flags |= SAS_TASK_NEED_DEV_RESET;
+
+ ret = i->dft->lldd_execute_task(task, 1, GFP_ATOMIC);
+ if (ret) {
+ SAS_DPRINTK("failed to send internal task.\n");
+ goto fail;
+ }
+
+ if (timeout) {
+ ret = sas_ata_wait_task_done(task, timeout, i->dft->lldd_wait_task_done);
+ if (ret) {
+ SAS_DPRINTK("internal task is timeout.\n");
+ goto fail;
+ }
+
+ kfree(task);
+ }
+
+ return 0;
+fail:
+ return ret;
+}
+
+/*
+ * Enable PMP port according to SATA 3.0 spec 13.15.4.2
+ */
+static int sas_ata_pmp_hard_reset(struct ata_link *link, unsigned int *class,
+ unsigned long deadline)
+{
+ struct ata_port *ap = link->ap;
+ struct domain_device *dev = ap->private_data;
+ struct sas_ha_struct *sas_ha = dev->port->ha;
+ struct Scsi_Host *host = sas_ha->core.shost;
+ struct sas_internal *i = to_sas_internal(host->transportt);
+ int ret = -1;
+ u32 scontrol = 0;
+
+ set_bit(SAS_DEV_RESET, &dev->state);
+
+ if ((ret = sata_scr_read(link, SCR_CONTROL, &scontrol)))
+ goto error;
+
+ /* enable PMP port */
+ scontrol = 0x1;
+ ret = sata_scr_write(link, SCR_CONTROL, scontrol);
+ if (ret)
+ goto error;
+
+ ata_msleep(ap, 1);
+
+ scontrol = 0x0;
+ ret = sata_scr_write(link, SCR_CONTROL, scontrol);
+ if (ret)
+ goto error;
+
+ ata_msleep(ap, 10);
+
+ /* check device is online */
+ if (ata_link_offline(link)) {
+ SAS_DPRINTK("link is offline.\n");
+ goto error;
+ }
+
+ /* clear X bit */
+ scontrol = 0xFFFFFFFF;
+ ret = sata_scr_write(link, SCR_ERROR, scontrol);
+ if (ret)
+ goto error;
+
+ ata_msleep(ap, 3); /* wait for device sig */
+
+ /* check device class */
+ if (i->dft->lldd_dev_classify)
+ *class = i->dft->lldd_dev_classify(dev);
+
+ return 0;
+error:
+ SAS_DPRINTK("falied to PMP port hard reset.\n");
+ return ret;
+}
+
+static int sas_ata_soft_reset(struct ata_link *link, unsigned int *class,
+ unsigned long deadline)
+{
+ struct ata_taskfile tf;
+ struct ata_port *ap = link->ap;
+ struct domain_device *dev = ap->private_data;
+ struct sas_ha_struct *sas_ha = dev->port->ha;
+ struct Scsi_Host *host = sas_ha->core.shost;
+ struct sas_internal *i = to_sas_internal(host->transportt);
+ struct sas_phy *phy;
+ unsigned long now, msecs;
+ unsigned int pmp;
+ int ret = -1;
+ int (*check_ready)(struct ata_link *link);
+
+ phy = sas_get_local_phy(dev);
+ if (scsi_is_sas_phy_local(phy))
+ check_ready = local_ata_check_ready;
+ else
+ check_ready = smp_ata_check_ready;
+ sas_put_local_phy(phy);
+
+ pmp = sata_srst_pmp(link);
+ memset(&tf, 0, sizeof(struct ata_taskfile));
+
+ msecs = 0; now = jiffies;
+ if (time_after(deadline, now))
+ msecs = jiffies_to_msecs(deadline - now);
+
+ tf.ctl = ATA_SRST;
+ tf.device = (1U << 6);
+
+ if (sas_ata_exec_polled_cmd(ap, &tf, pmp, msecs)) {
+ ret = -EIO;
+ goto fail;
+ }
+
+ tf.ctl &= ~ATA_SRST;
+ sas_ata_exec_polled_cmd(ap, &tf, pmp, msecs);
+
+ ret = ata_wait_after_reset(link, deadline, check_ready);
+ if (ret) {
+ SAS_DPRINTK("device is not ready.\n");
+ goto fail;
+ } else {
+ if (i->dft->lldd_dev_classify)
+ *class = i->dft->lldd_dev_classify(dev);
+ }
+
+ return 0;
+fail:
+ SAS_DPRINTK("failed to soft reset.\n");
+ return ret;
+}
+
+int sas_pm_revalidate_domain(struct domain_device *dev)
+{
+ struct ata_port *ap = NULL;
+ unsigned long flag;
+
+ ap = dev->sata_dev.ap;
+ if (!ap) {
+ SAS_DPRINTK("ap is null.\n");
+ return -1;
+ }
+
+ spin_lock_irqsave(ap->lock, flag);
+
+ /* avoid calling ata_scsi_hotplug function */
+ ap->pflags |= ATA_PFLAG_LOADING;
+ ata_port_schedule_eh(ap);
+
+ spin_unlock_irqrestore(ap->lock, flag);
+
+ sas_ata_wait_eh(dev);
+
+ return 0;
+}
+
 static struct ata_port_operations sas_sata_ops = {
  .prereset = ata_std_prereset,
+ .softreset = sas_ata_soft_reset,
  .hardreset = sas_ata_hard_reset,
  .postreset = ata_std_postreset,
- .error_handler = ata_std_error_handler,
+ .pmp_hardreset = sas_ata_pmp_hard_reset,
+ .freeze = sas_ata_freeze,
+ .thaw = sas_ata_thaw,
+ .error_handler = sata_pmp_error_handler,
  .post_internal_cmd = sas_ata_post_internal,
  .qc_defer               = ata_std_qc_defer,
  .qc_prep = ata_noop_qc_prep,
@@ -577,6 +816,7 @@ int sas_ata_init(struct domain_device *found_dev)
 {
  struct sas_ha_struct *ha = found_dev->port->ha;
  struct Scsi_Host *shost = ha->core.shost;
+ struct sas_internal *i = dev_to_sas_internal(found_dev);
  struct ata_port *ap;
  int rc;

@@ -592,6 +832,11 @@ int sas_ata_init(struct domain_device *found_dev)
  ap->private_data = found_dev;
  ap->cbl = ATA_CBL_SATA;
  ap->scsi_host = shost;
+
+ /* PM support setting */
+ if (i->dft->lldd_dev_set)
+ i->dft->lldd_dev_set(found_dev);
+
  rc = ata_sas_port_init(ap);
  if (rc) {
  ata_sas_port_destroy(ap);
@@ -644,7 +889,13 @@ static void sas_get_ata_command_set(struct
domain_device *dev)
      fis->lbal         == 0 &&
      fis->lbam         == 0xCE &&
      fis->lbah         == 0xAA &&
-     (fis->device & ~0x10) == 0))
+     (fis->device & ~0x10) == 0)
+            ||
+   (fis->interrupt_reason == 1 && /* SATA PM */
+    fis->lbal             == 1 &&
+    fis->byte_count_low   == 0x69 &&
+    fis->byte_count_high  == 0x96 &&
+    (fis->device & ~0x10) == 0))

  dev->sata_dev.command_set = ATA_COMMAND_SET;

@@ -660,18 +911,249 @@ static void sas_get_ata_command_set(struct
domain_device *dev)
   fis->lbal         == 1 &&
   fis->lbam         == 0x3C &&
   fis->lbah         == 0xC3 &&
-  fis->device       == 0)
- ||
- (fis->interrupt_reason == 1 && /* SATA PM */
-  fis->lbal             == 1 &&
-  fis->byte_count_low   == 0x69 &&
-  fis->byte_count_high  == 0x96 &&
-  (fis->device & ~0x10) == 0))
+  fis->device       == 0))

  /* Treat it as a superset? */
  dev->sata_dev.command_set = ATAPI_COMMAND_SET;
 }

+/*
+ * support PM hot-plug
+ */
+void sas_ata_pm_hotplug(struct ata_port *ap, struct ata_device *dev)
+{
+ struct domain_device *parent = ap->private_data;
+ struct domain_device *child = NULL, *n;
+ struct sata_device *sdev = &parent->sata_dev;
+ struct ata_link *link = dev->link;
+ struct ex_phy *ephy = &sdev->ephy[link->pmp];
+
+ list_for_each_entry_safe(child, n, &parent->children, siblings) {
+ if (child->sata_dev.port_no == link->pmp) {
+ sas_unregister_dev(parent->port, child);
+
+ memset(ephy->attached_sas_addr, 0, SAS_ADDR_SIZE);
+ if (ephy->port) {
+ sas_port_delete_phy(ephy->port, ephy->phy);
+ sas_device_set_phy(child, ephy->port);
+ if (ephy->port->num_phys == 0)
+ sas_port_delete(ephy->port);
+ ephy->port = NULL;
+ }
+ break;
+ }
+ }
+}
+
+static void sas_ata_set_phy(struct domain_device *parent,
+ struct ata_device *dev)
+{
+ struct sata_device *sdev = &parent->sata_dev;
+ struct ata_link *link = dev->link;
+ struct ex_phy *ephy = &sdev->ephy[link->pmp];
+ struct sas_rphy *rphy = parent->rphy;
+ struct sas_phy *phy = NULL;
+ unsigned int num_phys = 0, phy_id;
+
+ if (ephy->phy) {
+ SAS_DPRINTK("phy is already exist.\n");
+ return;
+ }
+
+ num_phys = parent->port->ha->num_phys;
+ phy_id = num_phys + (parent->phy->number + 1) * link->pmp;
+
+ ephy->phy = sas_phy_alloc(&rphy->dev, phy_id);
+
+ phy = ephy->phy;
+ BUG_ON(!phy);
+
+ ephy->attached_dev_type = SAS_SATA_DEV;
+ ephy->phy_id = link->pmp;
+ ephy->attached_tproto = parent->tproto;
+ ephy->attached_iproto = parent->iproto;
+
+ phy->identify.device_type = SAS_SATA_DEV;
+ phy->identify.initiator_port_protocols = SAS_PROTOCOL_SATA;
+ phy->identify.target_port_protocols = SAS_PROTOCOL_SATA;
+ phy->identify.phy_identifier = phy_id;
+
+ sas_phy_add(phy);
+}
+
+/*
+ * alloc domain_device for each ata_device and insert it into parent child list
+ */
+
+static int sas_ata_alloc_ddev(struct domain_device *parent,
+ struct ata_device *dev)
+{
+ struct ata_link *link = dev->link;
+ struct domain_device *child = NULL;
+ struct sata_device *sdev = &parent->sata_dev;
+ struct ex_phy *ephy = &sdev->ephy[link->pmp];
+ struct sas_rphy *rphy = NULL;
+ int ret = -1;
+
+ child = sas_alloc_device();
+ if (!child) {
+ SAS_DPRINTK("failed to alloc domain device.\n");
+ goto error;
+ }
+
+ kref_get(&parent->kref);
+ child->parent = parent;
+ child->port = parent->port;
+ child->tproto = parent->tproto;
+ child->dev_type = SAS_SATA_DEV;
+ child->sata_dev.port_no = link->pmp;
+ child->sata_dev.command_set = ATA_COMMAND_SET;
+ child->sata_dev.ap = parent->sata_dev.ap;
+
+ if (!ephy->port) {
+ ephy->port = sas_port_alloc(&parent->rphy->dev,
+ ephy->phy->number);
+ if (unlikely(!ephy->port)) {
+ SAS_DPRINTK("failed to alloc sas port.\n");
+ goto free;
+ }
+
+ if (unlikely(sas_port_add(ephy->port) != 0)) {
+ SAS_DPRINTK("can't add sas port.\n");
+ goto free;
+ }
+ }
+
+ BUG_ON(!ephy->phy);
+
+ sas_port_add_phy(ephy->port, ephy->phy);
+
+ rphy = sas_end_device_alloc(ephy->port);
+ if (!rphy) {
+ SAS_DPRINTK("failed to alloc end device.\n");
+ goto out;
+ }
+
+ rphy->identify.phy_identifier = parent->phy->identify.phy_identifier;
+ memcpy(child->sas_addr, parent->sas_addr, SAS_ADDR_SIZE);
+ sas_fill_in_rphy(child, rphy);
+ sas_hash_addr(child->hashed_sas_addr, child->sas_addr);
+ child->linkrate = parent->linkrate;
+ child->min_linkrate = child->linkrate;
+ child->max_linkrate = child->linkrate;
+ child->pathways = parent->pathways;
+
+ sas_device_set_phy(child, ephy->port);
+
+ child->rphy = rphy;
+ get_device(&child->rphy->dev);
+
+ list_add_tail(&child->siblings, &parent->children);
+ ret = 0;
+
+ return ret;
+out:
+ sas_port_free(ephy->port);
+free:
+ ephy->port = NULL;
+ sas_put_device(child);
+error:
+ SAS_DPRINTK("error exit.\n");
+ return ret;
+}
+
+static int sas_ata_add_ddev(struct domain_device *parent,
+ struct ata_device *dev)
+{
+ struct ata_link *link = dev->link;
+ struct domain_device *child, *n;
+ struct sas_rphy *rphy = NULL;
+ int ret = -1;
+
+ list_for_each_entry_safe(child, n, &parent->children, siblings)
+ {
+ if (child->sata_dev.port_no != link->pmp)
+ continue;
+
+ list_add_tail(&child->dev_list_node, &parent->port->dev_list);
+ ret = sas_notify_lldd_dev_found(child);
+ if (ret) {
+ SAS_DPRINTK(" failed to notify lldd.\n");
+ return ret;
+ }
+ rphy = child->rphy;
+
+ ret = sas_rphy_add(rphy);
+ if (ret)
+ SAS_DPRINTK("fail to add rphy.\n");
+ }
+ return 0;
+}
+
+void sas_ata_scan_host(struct ata_port *ap)
+{
+ struct ata_link *link;
+ struct ata_device *dev;
+ struct domain_device *parent = ap->private_data;
+ struct sas_port *port = NULL;
+ struct sata_device *sdev = NULL;
+ int ret = 0;
+
+
+ if (!sata_pmp_attached(ap)) {
+ printk("%s: ap is not pmp.\n",__func__);
+ return;
+ }
+
+ port = parent->port->port;
+ if (unlikely(!port->rphy)) {
+ ret = sas_rphy_add(parent->rphy);
+ if (ret) {
+ printk("%s: fail to add rphy .\n",__func__);
+ return;
+ }
+ list_del_init(&parent->disco_list_node);
+ }
+
+ sdev = &parent->sata_dev;
+ if (unlikely(!sdev->ephy)) {
+ printk("%s: alloc ex phy.\n",__func__);
+ sdev->ephy = kzalloc(sizeof(*sdev->ephy)*ap->nr_pmp_links,
+ GFP_KERNEL);
+ if (!sdev->ephy) {
+ printk(KERN_ERR "failed to alloc pm phy.\n");
+ return;
+ }
+ }
+
+ ata_for_each_link(link, ap, EDGE) {
+ ata_for_each_dev(dev, link, ALL) {
+
+ if (dev->flags & ATA_DFLAG_DETACHED) {
+ sas_ata_pm_hotplug(ap, dev);
+ continue;
+ }
+
+ if (!ata_dev_enabled(dev))
+ continue;
+
+ if (dev->sdev)
+ continue;
+
+ sas_ata_set_phy(parent, dev);
+
+ ret = sas_ata_alloc_ddev(parent, dev);
+ if (ret)
+ continue;
+ ret = sas_ata_add_ddev(parent, dev);
+ if (ret)
+ printk("%s: fail to add sas dev.\n",__func__);
+ }
+ }
+
+ return;
+}
+
 void sas_probe_sata(struct asd_sas_port *port)
 {
  struct domain_device *dev, *n;
@@ -772,8 +1254,14 @@ int sas_discover_sata(struct domain_device *dev)
 {
  int res;

- if (dev->dev_type == SAS_SATA_PM)
- return -ENODEV;
+ if (dev->dev_type == SAS_SATA_PM) {
+ struct ata_port *ap = dev->sata_dev.ap;
+ if (unlikely(!ap))
+ BUG();
+
+ if (!(ap->flags & ATA_FLAG_PMP))
+ return -ENODEV;
+ }

  sas_get_ata_command_set(dev);
  sas_fill_in_rphy(dev, dev->rphy);
@@ -823,6 +1311,9 @@ void sas_ata_strategy_handler(struct Scsi_Host *shost)
  if (!dev_is_sata(dev))
  continue;

+ if (dev->parent && (dev->dev_type == SAS_SATA_DEV))
+ continue;
+
  /* hold a reference over eh since we may be
  * racing with final remove once all commands
  * are completed
@@ -912,4 +1403,6 @@ void sas_ata_wait_eh(struct domain_device *dev)

  ap = dev->sata_dev.ap;
  ata_port_wait_eh(ap);
+
+ sas_ata_scan_host(ap);
 }
diff --git a/drivers/scsi/libsas/sas_discover.c
b/drivers/scsi/libsas/sas_discover.c
index 62b58d3..be0653a 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -47,6 +47,9 @@ void sas_init_dev(struct domain_device *dev)
  INIT_LIST_HEAD(&dev->ex_dev.children);
  mutex_init(&dev->ex_dev.cmd_mutex);
  break;
+ case SAS_SATA_PM:
+ INIT_LIST_HEAD(&dev->children);
+ break;
  default:
  break;
  }
@@ -110,6 +113,7 @@ static int sas_get_port_device(struct asd_sas_port *port)
  dev->port = port;
  switch (dev->dev_type) {
  case SAS_SATA_DEV:
+ case SAS_SATA_PM:
  rc = sas_ata_init(dev);
  if (rc) {
  rphy = NULL;
@@ -319,6 +323,14 @@ void sas_free_device(struct kref *kref)
  kfree(dev->ex_dev.ex_phy);

  if (dev_is_sata(dev) && dev->sata_dev.ap) {
+ if (dev->parent) {
+ kfree(dev);
+ return;
+ }
+
+ if (dev->sata_dev.ephy)
+ kfree(dev->sata_dev.ephy);
+
  ata_sas_port_destroy(dev->sata_dev.ap);
  dev->sata_dev.ap = NULL;
  }
@@ -500,6 +512,7 @@ static void sas_revalidate_domain(struct work_struct *work)
  struct sas_discovery_event *ev = to_sas_discovery_event(work);
  struct asd_sas_port *port = ev->port;
  struct sas_ha_struct *ha = port->ha;
+ struct domain_device *dev = NULL;

  /* prevent revalidation from finding sata links in recovery */
  mutex_lock(&ha->disco_mutex);
@@ -514,8 +527,16 @@ static void sas_revalidate_domain(struct work_struct *work)
  SAS_DPRINTK("REVALIDATING DOMAIN on port %d, pid:%d\n", port->id,
     task_pid_nr(current));

- if (port->port_dev)
- res = sas_ex_revalidate_domain(port->port_dev);
+ if (port->port_dev) {
+ dev = port->port_dev;
+ if (dev->dev_type == SAS_SATA_PM) {
+ mutex_unlock(&ha->disco_mutex);
+ res = sas_pm_revalidate_domain(dev);
+ mutex_lock(&ha->disco_mutex);
+ }
+ else
+ res = sas_ex_revalidate_domain(port->port_dev);
+ }

  SAS_DPRINTK("done REVALIDATING DOMAIN on port %d, pid:%d, res 0x%x\n",
     port->id, task_pid_nr(current), res);
diff --git a/drivers/scsi/libsas/sas_internal.h
b/drivers/scsi/libsas/sas_internal.h
index 7e7ba83..c09fab3 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -77,6 +77,7 @@ void sas_deform_port(struct asd_sas_phy *phy, int gone);

 void sas_porte_bytes_dmaed(struct work_struct *work);
 void sas_porte_broadcast_rcvd(struct work_struct *work);
+void sas_porte_sntf_rcvd(struct work_struct *work);
 void sas_porte_link_reset_err(struct work_struct *work);
 void sas_porte_timer_event(struct work_struct *work);
 void sas_porte_hard_reset(struct work_struct *work);
@@ -132,6 +133,7 @@ static inline void sas_fill_in_rphy(struct
domain_device *dev,
  rphy->identify.target_port_protocols = dev->tproto;
  switch (dev->dev_type) {
  case SAS_SATA_DEV:
+ case SAS_SATA_PM:
  /* FIXME: need sata device type */
  case SAS_END_DEVICE:
  case SAS_SATA_PENDING:
diff --git a/drivers/scsi/libsas/sas_phy.c b/drivers/scsi/libsas/sas_phy.c
index cdee446..ade4ff7 100644
--- a/drivers/scsi/libsas/sas_phy.c
+++ b/drivers/scsi/libsas/sas_phy.c
@@ -134,6 +134,7 @@ int sas_register_phys(struct sas_ha_struct *sas_ha)
  [PORTE_LINK_RESET_ERR] = sas_porte_link_reset_err,
  [PORTE_TIMER_EVENT] = sas_porte_timer_event,
  [PORTE_HARD_RESET] = sas_porte_hard_reset,
+ [PORTE_SNTF_RCVD] = sas_porte_sntf_rcvd,
  };

  /* Now register the phys. */
diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index d3c5297..07c1212 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -266,6 +266,17 @@ void sas_porte_bytes_dmaed(struct work_struct *work)
  sas_form_port(phy);
 }

+void sas_porte_sntf_rcvd(struct work_struct *work)
+{
+ struct asd_sas_event *ev = to_asd_sas_event(work);
+ struct asd_sas_phy *phy = ev->phy;
+
+ clear_bit(PORTE_SNTF_RCVD, &phy->port_events_pending);
+
+ SAS_DPRINTK("pm sntf received.\n");
+ sas_discover_event(phy->port, DISCE_REVALIDATE_DOMAIN);
+}
+
 void sas_porte_broadcast_rcvd(struct work_struct *work)
 {
  struct asd_sas_event *ev = to_asd_sas_event(work);
diff --git a/drivers/scsi/libsas/sas_scsi_host.c
b/drivers/scsi/libsas/sas_scsi_host.c
index 25d0f12..ad74932 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -916,6 +916,10 @@ int sas_target_alloc(struct scsi_target *starget)

  kref_get(&found_dev->kref);
  starget->hostdata = found_dev;
+
+ if (found_dev->parent)
+ starget->channel = found_dev->sata_dev.port_no;
+
  return 0;
 }

@@ -929,7 +933,11 @@ int sas_slave_configure(struct scsi_device *scsi_dev)
  BUG_ON(dev->rphy->identify.device_type != SAS_END_DEVICE);

  if (dev_is_sata(dev)) {
- ata_sas_slave_configure(scsi_dev, dev->sata_dev.ap);
+ struct domain_device *parent = dev;
+ if (dev->parent)
+ parent = dev->parent;
+
+ ata_sas_slave_configure(scsi_dev, parent->sata_dev.ap);
  return 0;
  }

diff --git a/drivers/scsi/mvsas/mv_64xx.c b/drivers/scsi/mvsas/mv_64xx.c
index 8bb0699..bb257cb 100644
--- a/drivers/scsi/mvsas/mv_64xx.c
+++ b/drivers/scsi/mvsas/mv_64xx.c
@@ -780,6 +780,8 @@ const struct mvs_dispatch mvs_64xx_dispatch = {
  mvs_64xx_iounmap,
  mvs_64xx_isr,
  mvs_64xx_isr_status,
+ NULL,
+ NULL,
  mvs_64xx_interrupt_enable,
  mvs_64xx_interrupt_disable,
  mvs_read_phy_ctl,
diff --git a/drivers/scsi/mvsas/mv_94xx.c b/drivers/scsi/mvsas/mv_94xx.c
index 1e4479f..ffbe574 100644
--- a/drivers/scsi/mvsas/mv_94xx.c
+++ b/drivers/scsi/mvsas/mv_94xx.c
@@ -462,7 +462,8 @@ static int mvs_94xx_init(struct mvs_info *mvi)

  /* set phy int mask */
  tmp = PHYEV_RDY_CH | PHYEV_BROAD_CH |
- PHYEV_ID_DONE  | PHYEV_DCDR_ERR | PHYEV_CRC_ERR ;
+ PHYEV_ID_DONE  | PHYEV_DCDR_ERR | PHYEV_CRC_ERR |
+ PHYEV_UNASSOC_FIS | PHYEV_SIG_FIS | PHYEV_AN;
  mvs_write_port_irq_mask(mvi, i, tmp);

  msleep(100);
@@ -589,6 +590,21 @@ static void mvs_94xx_interrupt_disable(struct
mvs_info *mvi)
  mw32(MVS_GBL_CTL, tmp);
 }

+static u32 mvs_94xx_read_isr_stat(struct mvs_info *mvi)
+{
+ void __iomem *regs = mvi->regs;
+ u32 stat = 0;
+
+ stat = mr32(MVS_INT_STAT);
+ return stat;
+}
+
+static void mvs_94xx_write_isr_stat(struct mvs_info *mvi, u32 stat)
+{
+ void __iomem *regs = mvi->regs;
+ mw32(MVS_INT_STAT, stat);
+}
+
 static u32 mvs_94xx_isr_status(struct mvs_info *mvi, int irq)
 {
  void __iomem *regs = mvi->regs_ex;
@@ -1013,6 +1029,8 @@ const struct mvs_dispatch mvs_94xx_dispatch = {
  mvs_94xx_iounmap,
  mvs_94xx_isr,
  mvs_94xx_isr_status,
+ mvs_94xx_read_isr_stat,
+ mvs_94xx_write_isr_stat,
  mvs_94xx_interrupt_enable,
  mvs_94xx_interrupt_disable,
  mvs_read_phy_ctl,
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 5ff978b..d6f1f70 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -93,7 +93,12 @@ static struct sas_domain_function_template
mvs_transport_ops = {
  .lldd_query_task = mvs_query_task,
  .lldd_port_formed = mvs_port_formed,
  .lldd_port_deformed     = mvs_port_deformed,
-
+ .lldd_dev_freeze        = mvs_dev_freeze,
+ .lldd_dev_thaw          = mvs_dev_thaw,
+ .lldd_wait_task_done    = mvs_wait_task_done,
+ .lldd_ata_check_ready   = mvs_check_ready,
+ .lldd_dev_classify      = mvs_dev_classify,
+ .lldd_dev_set           = mvs_dev_set,
 };

 static void mvs_phy_init(struct mvs_info *mvi, int phy_id)
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 6c1f223..a5aac8f 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1369,6 +1369,197 @@ void mvs_dev_gone(struct domain_device *dev)
  mvs_dev_gone_notify(dev);
 }

+void mvs_dev_freeze(struct domain_device *dev)
+{
+ struct mvs_device *mvi_dev = dev->lldd_dev;
+ struct mvs_info *mvi = mvi_dev->mvi_info;
+
+ if (!mvi)
+ return;
+
+ MVS_CHIP_DISP->interrupt_disable(mvi);
+}
+
+void mvs_dev_thaw(struct domain_device *dev)
+{
+ struct mvs_device *mvi_dev = dev->lldd_dev;
+ struct mvs_info *mvi = mvi_dev->mvi_info;
+
+ if (!mvi)
+ return;
+
+ MVS_CHIP_DISP->interrupt_enable(mvi);
+}
+
+int mvs_wait_task_done(struct sas_task *task)
+{
+ struct domain_device *dev = task->dev;
+ struct mvs_device *mdev = dev->lldd_dev;
+ struct asd_sas_port *sas_port = dev->port;
+ struct mvs_port *port = sas_port->lldd_port;
+ struct mvs_slot_info *slot =
+ (struct mvs_slot_info *)task->lldd_task;
+ struct mvs_info *mvi = mdev->mvi_info;
+ unsigned int rx_prod_idx, rx_desc;
+ u32 slot_idx = slot->slot_tag, reg;
+ int ret = -1;
+
+ reg = MVS_CHIP_DISP->read_isr_status(mvi);
+ rx_prod_idx = mvi->rx_cons;
+ mvi->rx_cons = le32_to_cpu(mvi->rx[0]);
+ if (mvi->rx_cons == 0xFFF)
+ return ret;
+
+ if (unlikely(mvi->rx_cons == rx_prod_idx))
+ mvi->rx_cons = MVS_CHIP_DISP->rx_update(mvi) &
+ RX_RING_SZ_MASK;
+
+ if (reg & 0x1) {
+ task->task_state_flags = SAS_TASK_STATE_DONE;
+ if (mdev && mdev->running_req)
+ mdev->running_req--;
+ if (sas_protocol_ata(task->task_proto))
+ mvs_free_reg_set(mvi, mdev);
+
+ mvs_slot_task_free(mvi, task, slot, slot_idx);
+
+ /* clear int register */
+ MVS_CHIP_DISP->write_isr_status(mvi, reg & 0x1);
+ reg = MVS_CHIP_DISP->read_isr_status(mvi);
+
+ rx_desc = le32_to_cpu(mvi->rx[mvi->rx_cons + 1]);
+ return 0;
+ }
+
+ if (mvi->rx_cons == rx_prod_idx)
+ return ret;
+
+ rx_desc = le32_to_cpu(mvi->rx[mvi->rx_cons + 1]);
+ if (rx_desc & RXQ_DONE)
+ ret = 0;
+
+ if ((reg == MVS_CHIP_DISP->read_isr_status(mvi)) & 0x1)
+ MVS_CHIP_DISP->write_isr_status(mvi, reg & 0x1);
+
+ return ret;
+}
+
+int mvs_check_ready(struct domain_device *dev)
+{
+ struct mvs_device *mdev = dev->lldd_dev;
+ struct mvs_info *mvi = mdev->mvi_info;
+ struct asd_sas_port *sas_port = dev->port;
+ struct mvs_port *port = sas_port->lldd_port;
+ int i = 0;
+ u32 reg, status = 0;
+
+ while (&(mvi->port[i]) != port) {
+ i++;
+ }
+
+ reg = MVS_CHIP_DISP->read_port_irq_stat(mvi, i);
+ if (reg == 0 && test_bit(SAS_DEV_RESET, &dev->state)) {
+ clear_bit(SAS_DEV_RESET, &dev->state);
+ return 1;
+ }
+
+ status = mvs_is_phy_ready(mvi, i);
+ if (!status)
+ return 1;
+
+ if (reg & PHYEV_UNASSOC_FIS) {
+ reg = readl(UNASSOC_D2H_FIS(i));
+ } else if (reg & PHYEV_SIG_FIS) {
+ MVS_CHIP_DISP->write_port_cfg_addr(mvi, i, PHYR_SATA_SIG0);
+ reg = cpu_to_le32(MVS_CHIP_DISP->read_port_cfg_data(mvi, i));
+ }
+
+ status = (reg >> 16) & 0xFF;
+
+ if (status & 0x80)
+ return 0;
+
+ return 1;
+}
+
+static u32 mvs_get_dev_sig(struct mvs_info *mvi, int phy, u32 reg)
+{
+ u32 sig = 0, val;
+
+ if (reg & PHYEV_UNASSOC_FIS) {
+ val = readl(UNASSOC_D2H_FIS(phy) + 0xC);
+ val = val & 0xFF;
+ sig |= val;
+ val = readl(UNASSOC_D2H_FIS(phy) + 0x4);
+ val = val & 0xFFFFFF;
+ sig |= (val << 8);
+
+ memset(UNASSOC_D2H_FIS(phy), 0, 4);
+ memset(UNASSOC_D2H_FIS(phy) + 0x4, 0, 4);
+ memset(UNASSOC_D2H_FIS(phy) + 0x8, 0, 4);
+ memset(UNASSOC_D2H_FIS(phy) + 0xC, 0, 4);
+ } else if (reg & PHYEV_SIG_FIS) {
+ MVS_CHIP_DISP->write_port_cfg_addr(mvi, phy, PHYR_SATA_SIG3);
+ val = cpu_to_le32(MVS_CHIP_DISP->read_port_cfg_data(mvi, phy));
+ val = val & 0xFF;
+ sig |= val;
+ MVS_CHIP_DISP->write_port_cfg_addr(mvi, phy, PHYR_SATA_SIG1);
+ val = cpu_to_le32(MVS_CHIP_DISP->read_port_cfg_data(mvi, phy));
+ val = val & 0xFFFFFF;
+ sig |= (val << 8);
+ }
+ return sig;
+}
+
+int mvs_dev_classify(struct domain_device *dev)
+{
+ struct mvs_device *mdev = dev->lldd_dev;
+ struct mvs_info *mvi = mdev->mvi_info;
+ struct asd_sas_port *sas_port = dev->port;
+ struct mvs_port *port = sas_port->lldd_port;
+ int i = 0;
+ u32 reg, sig;
+
+ if (test_and_clear_bit(SAS_DEV_RESET, &dev->state)) {
+ sig = port->sig;
+ port->sig = 0xFFFFFFFF;
+ goto out;
+ }
+
+ while (&mvi->port[i] != port) {
+ i++;
+ }
+
+ reg = MVS_CHIP_DISP->read_port_irq_stat(mvi, i);
+
+ port->sig = mvs_get_dev_sig(mvi, i, reg);
+ sig = port->sig;
+ port->sig = 0xFFFFFFFF;
+
+ reg = MVS_CHIP_DISP->read_port_irq_stat(mvi, i);
+ MVS_CHIP_DISP->write_port_irq_stat(mvi, i, reg);
+ reg = MVS_CHIP_DISP->read_port_irq_state(mvi, i);
+out:
+ if (sig == 0x96690101)
+ return ATA_DEV_PMP;
+ else if (sig == 0x101)
+ return ATA_DEV_ATA;
+ else
+ return ATA_DEV_UNKNOWN;
+}
+
+void mvs_dev_set(struct domain_device *dev)
+{
+ struct ata_port *ap;
+
+ if (dev->parent)
+ return;
+
+ ap = dev->sata_dev.ap;
+ /* add support PM and AN */
+ ap->flags |= (ATA_FLAG_PMP | ATA_FLAG_AN);
+}
+
 static void mvs_task_done(struct sas_task *task)
 {
  if (!del_timer(&task->slow_task->timer))
diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index d6b19dc..a61a05d 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -113,6 +113,8 @@ struct mvs_dispatch {
  void (*chip_iounmap)(struct mvs_info *mvi);
  irqreturn_t (*isr)(struct mvs_info *mvi, int irq, u32 stat);
  u32 (*isr_status)(struct mvs_info *mvi, int irq);
+ u32 (*read_isr_status)(struct mvs_info *mvi);
+ void (*write_isr_status)(struct mvs_info *mvi, u32 stat);
  void (*interrupt_enable)(struct mvs_info *mvi);
  void (*interrupt_disable)(struct mvs_info *mvi);

@@ -484,5 +486,12 @@ void mvs_int_port(struct mvs_info *mvi, int
phy_no, u32 events);
 void mvs_update_phyinfo(struct mvs_info *mvi, int i, int get_st);
 int mvs_int_rx(struct mvs_info *mvi, bool self_clear);
 struct mvs_device *mvs_find_dev_by_reg_set(struct mvs_info *mvi, u8 reg_set);
+
+void mvs_dev_freeze(struct domain_device *dev);
+void mvs_dev_thaw(struct domain_device *dev);
+int mvs_wait_task_done(struct sas_task *task);
+int mvs_check_ready(struct domain_device *dev);
+int mvs_dev_classify(struct domain_device *dev);
+void mvs_dev_set(struct domain_device *dev);
 #endif

diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index ef7872c..935494d 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -72,6 +72,8 @@ enum port_event {
  PORTE_TIMER_EVENT     = 3,
  PORTE_HARD_RESET      = 4,
  PORT_NUM_EVENTS       = 5,
+ /* support PM hot-plug event */
+ PORT_SNTF_RCVD        = 6,
 };

 enum phy_event {
@@ -173,6 +175,8 @@ struct sata_device {
         struct smp_resp        rps_resp; /* report_phy_sata_resp */
         u8     port_no;        /* port number, if this is a PM (Port) */

+ struct ex_phy *ephy;   /* add PM-attached device into sas transport layer */
+
  struct ata_port *ap;
  struct ata_host ata_host;
  u8     fis[ATA_RESP_FIS_SIZE];
@@ -204,6 +208,7 @@ struct domain_device {

         struct domain_device *parent;
         struct list_head siblings; /* devices on the same level */
+ struct list_head children; /* children device list */
         struct asd_sas_port *port;        /* shortcut to root of the tree */
  struct sas_phy *phy;

@@ -689,6 +694,13 @@ struct sas_domain_function_template {
  /* GPIO support */
  int (*lldd_write_gpio)(struct sas_ha_struct *, u8 reg_type,
        u8 reg_index, u8 reg_count, u8 *write_data);
+
+ /* PMP support */
+ int (*lldd_wait_task_done)(struct sas_task *);
+ int (*lldd_dev_classify)(struct domain_device *);
+ void (*lldd_dev_freeze)(struct domain_device *);
+ void (*lldd_dev_thaw)(struct domain_device *);
+ void (*lldd_dev_set)(struct domain_device *);
 };

 extern int sas_register_ha(struct sas_ha_struct *);
@@ -719,6 +731,7 @@ int  sas_discover_root_expander(struct domain_device *);
 void sas_init_ex_attr(void);

 int  sas_ex_revalidate_domain(struct domain_device *);
+int  sas_pm_revalidate_domain(struct domain_device *);

 void sas_unregister_domain_devices(struct asd_sas_port *port, int gone);
 void sas_init_disc(struct sas_discovery *disc, struct asd_sas_port *);
diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
index 00f41ae..f61eab5 100644
--- a/include/scsi/sas_ata.h
+++ b/include/scsi/sas_ata.h
@@ -48,6 +48,7 @@ void sas_probe_sata(struct asd_sas_port *port);
 void sas_suspend_sata(struct asd_sas_port *port);
 void sas_resume_sata(struct asd_sas_port *port);
 void sas_ata_end_eh(struct ata_port *ap);
+void sas_ata_scan_host(struct ata_port *ap);
 #else


-- 
1.7.1
