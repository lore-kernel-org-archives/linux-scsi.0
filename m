From: Xiangliang Yu <yxlraid@gmail.com>
Subject: [PATCH 1/3] libsas: modify SATA error handler
Date: Thu, 24 Apr 2014 21:27:27 +0800
Message-ID: <1398346047-10276-1-git-send-email-yxlraid@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tj@kernel.org, JBottomley@parallels.com
Cc: dan.j.williams@intel.com, todd.e.brandt@intel.com, lukasz.dorau@intel.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Xiangliang Yu <yxlraid@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Add support for SATA port softreset and port multiplier error
handling.

Signed-off-by: Xiangliang Yu <yxlraid@gmail.com>
---
 drivers/scsi/libsas/sas_ata.c |  226 ++++++++++++++++++++++++++++++++++++++++-
 include/scsi/libsas.h         |    6 +
 2 files changed, 231 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 766098a..29a19fd 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -442,6 +442,226 @@ static int sas_ata_hard_reset(struct ata_link *link, unsigned int *class,
 	return ret;
 }
 
+static void sas_ata_freeze(struct ata_port *ap)
+{
+	struct domain_device *dev = ap->private_data;
+	struct sas_ha_struct *sas_ha = dev->port->ha;
+	struct Scsi_Host *host = sas_ha->core.shost;
+	struct sas_internal *i = to_sas_internal(host->transportt);
+
+	if (i->dft->lldd_dev_freeze)
+		i->dft->lldd_dev_freeze(dev);
+}
+
+static void sas_ata_thaw(struct ata_port *ap)
+{
+	struct domain_device *dev = ap->private_data;
+	struct sas_ha_struct *sas_ha = dev->port->ha;
+	struct Scsi_Host *host = sas_ha->core.shost;
+	struct sas_internal *i = to_sas_internal(host->transportt);
+
+	if (i->dft->lldd_dev_thaw)
+		i->dft->lldd_dev_thaw(dev);
+}
+
+static int sas_ata_wait_task_done(struct sas_task *task, unsigned long timeout,
+		int (*check_done)(struct sas_task *task))
+{
+	struct ata_port *ap = task->uldd_task;
+	unsigned long deadline;
+	int done;
+
+	if (!check_done) {
+		SAS_DPRINTK("check function is null.\n");
+		return -1;
+	}
+
+	deadline = ata_deadline(jiffies, timeout);
+	done = check_done(task);
+
+	while (done && time_before(jiffies, deadline)) {
+		ata_msleep(ap, 1);
+
+		done = check_done(task);
+	}
+
+	return done;
+}
+
+static int sas_ata_exec_polled_cmd(struct ata_port *ap, struct ata_taskfile *tf,
+		int pmp, unsigned long timeout)
+{
+	struct domain_device *dev = ap->private_data;
+	struct sas_ha_struct *sas_ha = dev->port->ha;
+	struct Scsi_Host *host = sas_ha->core.shost;
+	struct sas_internal *i = to_sas_internal(host->transportt);
+	struct sas_task *task = NULL;
+	int ret = -1;
+
+	if (!i->dft->lldd_execute_task) {
+		SAS_DPRINTK("execute function is null.\n");
+		return ret;
+	}
+
+	task = sas_alloc_task(GFP_ATOMIC);
+	if (!task) {
+		SAS_DPRINTK("failed to alloc sas task.\n");
+		goto fail;
+	}
+
+	task->dev = dev;
+	task->task_proto = SAS_PROTOCOL_SATA;
+	task->uldd_task = ap;
+
+	ata_tf_to_fis(tf, pmp, 0, (u8 *)&task->ata_task.fis);
+	task->ata_task.retry_count = 1;
+	task->task_state_flags = SAS_TASK_STATE_PENDING;
+	task->task_state_flags |= SAS_TASK_NEED_DEV_RESET;
+
+	ret = i->dft->lldd_execute_task(task, 1, GFP_ATOMIC);
+	if (ret) {
+		SAS_DPRINTK("failed to send internal task.\n");
+		goto fail;
+	}
+
+	if (timeout) {
+		ret = sas_ata_wait_task_done(task, timeout,
+				i->dft->lldd_wait_task_done);
+		if (ret) {
+			SAS_DPRINTK("get wrong status.\n");
+			goto fail;
+		}
+	}
+	list_del_init(&task->list);
+	sas_free_task(task);
+
+	return 0;
+fail:
+	if (task) {
+		list_del_init(&task->list);
+		sas_free_task(task);
+	}
+
+	return ret;
+}
+
+static int sas_ata_soft_reset(struct ata_link *link, unsigned int *class,
+			      unsigned long deadline)
+{
+	struct ata_taskfile tf;
+	struct ata_port *ap = link->ap;
+	struct domain_device *dev = ap->private_data;
+	struct sas_ha_struct *sas_ha = dev->port->ha;
+	struct Scsi_Host *host = sas_ha->core.shost;
+	struct sas_internal *i = to_sas_internal(host->transportt);
+	struct sas_phy *phy;
+	unsigned long now, msecs;
+	unsigned int pmp;
+	int ret = -1;
+	int (*check_ready)(struct ata_link *link);
+
+	phy = sas_get_local_phy(dev);
+	if (scsi_is_sas_phy_local(phy))
+		check_ready = local_ata_check_ready;
+	else
+		check_ready = smp_ata_check_ready;
+	sas_put_local_phy(phy);
+
+	pmp = sata_srst_pmp(link);
+
+	msecs = 0;
+	now = jiffies;
+	if (time_after(deadline, now))
+		msecs = jiffies_to_msecs(deadline - now);
+
+	memset(&tf, 0, sizeof(struct ata_taskfile));
+	tf.ctl = ATA_SRST;
+	tf.device = ATA_DEVICE_OBS;
+
+	if (sas_ata_exec_polled_cmd(ap, &tf, pmp, msecs)) {
+		ret = -EIO;
+		goto fail;
+	}
+
+	tf.ctl &= ~ATA_SRST;
+	sas_ata_exec_polled_cmd(ap, &tf, pmp, msecs);
+
+	ret = ata_wait_after_reset(link, deadline, check_ready);
+	if (ret) {
+		SAS_DPRINTK("device is not ready.\n");
+		ret = -EIO;
+		goto fail;
+	} else {
+		if (i->dft->lldd_dev_classify)
+			*class = i->dft->lldd_dev_classify(dev);
+	}
+
+	return 0;
+
+fail:
+	SAS_DPRINTK("failed to reset.\n");
+	return ret;
+}
+
+/* According sata 3.0 spec 13.15.4.2, enable the device port */
+static int sas_ata_pmp_hard_reset(struct ata_link *link, unsigned int *class,
+			      unsigned long deadline)
+{
+	struct ata_port *ap = link->ap;
+	struct domain_device *dev = ap->private_data;
+	struct sas_ha_struct *sas_ha = dev->port->ha;
+	struct Scsi_Host *host = sas_ha->core.shost;
+	struct sas_internal *i = to_sas_internal(host->transportt);
+	int ret = -1;
+	u32 scontrol = 0;
+
+	set_bit(SAS_DEV_RESET, &dev->state);
+
+	ret = sata_scr_read(link, SCR_CONTROL, &scontrol);
+	if (ret)
+		goto error;
+
+	/* enable device port */
+	scontrol = 0x1;
+	ret = sata_scr_write(link, SCR_CONTROL, scontrol);
+	if (ret)
+		goto error;
+
+	ata_msleep(ap, 1);
+
+	scontrol = 0x0;
+	ret = sata_scr_write(link, SCR_CONTROL, scontrol);
+	if (ret)
+		goto error;
+
+	ata_msleep(ap, 10);
+
+	/* check device link status */
+	if (ata_link_offline(link)) {
+		SAS_DPRINTK("link is offline.\n");
+		goto error;
+	}
+
+	/* clear X bit */
+	scontrol = 0xFFFFFFFF;
+	ret = sata_scr_write(link, SCR_ERROR, scontrol);
+	if (ret)
+		goto error;
+
+	/* may be need to wait for device sig */
+	ata_msleep(ap, 3);
+
+	/* check device class */
+	if (i->dft->lldd_dev_classify)
+		*class = i->dft->lldd_dev_classify(dev);
+
+	return 0;
+
+error:
+	SAS_DPRINTK("failed to hard reset.\n");
+	return ret;
+}
+
 /*
  * notify the lldd to forget the sas_task for this internal ata command
  * that bypasses scsi-eh
@@ -551,8 +771,12 @@ void sas_ata_end_eh(struct ata_port *ap)
 static struct ata_port_operations sas_sata_ops = {
 	.prereset		= ata_std_prereset,
 	.hardreset		= sas_ata_hard_reset,
+	.softreset		= sas_ata_soft_reset,
+	.pmp_hardreset		= sas_ata_pmp_hard_reset,
+	.freeze			= sas_ata_freeze,
+	.thaw			= sas_ata_thaw,
 	.postreset		= ata_std_postreset,
-	.error_handler		= ata_std_error_handler,
+	.error_handler		= sata_pmp_error_handler,
 	.post_internal_cmd	= sas_ata_post_internal,
 	.qc_defer               = ata_std_qc_defer,
 	.qc_prep		= ata_noop_qc_prep,
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index ef7872c..a26466a 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -689,6 +689,12 @@ struct sas_domain_function_template {
 	/* GPIO support */
 	int (*lldd_write_gpio)(struct sas_ha_struct *, u8 reg_type,
 			       u8 reg_index, u8 reg_count, u8 *write_data);
+
+	/* ATA EH functions */
+	void (*lldd_dev_freeze)(struct domain_device *);
+	void (*lldd_dev_thaw)(struct domain_device *);
+	int (*lldd_wait_task_done)(struct sas_task *);
+	int (*lldd_dev_classify)(struct domain_device *);
 };
 
 extern int sas_register_ha(struct sas_ha_struct *);
-- 
1.7.1
