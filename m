From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] libsas: make ATA functions selectable by a config option
Date: Sun, 22 Jul 2007 13:15:55 -0500
Message-ID: <1185128155.3431.12.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:35437 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756517AbXGVSP7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Jul 2007 14:15:59 -0400
Received: from [172.17.6.40] (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (Postfix) with ESMTP id 11762AAA822C
	for <linux-scsi@vger.kernel.org>; Sun, 22 Jul 2007 14:15:56 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Not everyone wants libsas automatically to pull in libata.  This patch
makes the behaviour configurable, so you can build libsas with or
without ATA support.

James

diff --git a/drivers/scsi/libsas/Kconfig b/drivers/scsi/libsas/Kconfig
index aafdc92..1d6efef 100644
--- a/drivers/scsi/libsas/Kconfig
+++ b/drivers/scsi/libsas/Kconfig
@@ -30,6 +30,14 @@ config SCSI_SAS_LIBSAS
 	  This provides transport specific helpers for SAS drivers which
 	  use the domain device construct (like the aic94xxx).
 
+config SCSI_SAS_ATA
+	bool "ATA support for libsas (requires libata)"
+	depends on SCSI_SAS_LIBSAS && ATA
+	help
+		Builds in ATA support into libsas.  Will necessitate
+		the loading of libata along with libsas.
+	
+
 config SCSI_SAS_LIBSAS_DEBUG
 	bool "Compile the SAS Domain Transport Attributes in debug mode"
 	default y
diff --git a/drivers/scsi/libsas/Makefile b/drivers/scsi/libsas/Makefile
index 6383eb5..fd387b9 100644
--- a/drivers/scsi/libsas/Makefile
+++ b/drivers/scsi/libsas/Makefile
@@ -33,5 +33,5 @@ libsas-y +=  sas_init.o     \
 		sas_dump.o     \
 		sas_discover.o \
 		sas_expander.o \
-		sas_scsi_host.o \
-		sas_ata.o
+		sas_scsi_host.o
+libsas-$(CONFIG_SCSI_SAS_ATA) +=	sas_ata.o
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 359391f..ced2de3 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -21,6 +21,8 @@
  * USA
  */
 
+#include <linux/scatterlist.h>
+
 #include <scsi/sas_ata.h>
 #include "sas_internal.h"
 #include <scsi/scsi_host.h>
@@ -418,3 +420,398 @@ void sas_ata_task_abort(struct sas_task *task)
 	waiting = qc->private_data;
 	complete(waiting);
 }
+
+static void sas_task_timedout(unsigned long _task)
+{
+	struct sas_task *task = (void *) _task;
+	unsigned long flags;
+
+	spin_lock_irqsave(&task->task_state_lock, flags);
+	if (!(task->task_state_flags & SAS_TASK_STATE_DONE))
+		task->task_state_flags |= SAS_TASK_STATE_ABORTED;
+	spin_unlock_irqrestore(&task->task_state_lock, flags);
+
+	complete(&task->completion);
+}
+
+static void sas_disc_task_done(struct sas_task *task)
+{
+	if (!del_timer(&task->timer))
+		return;
+	complete(&task->completion);
+}
+
+#define SAS_DEV_TIMEOUT 10
+
+/**
+ * sas_execute_task -- Basic task processing for discovery
+ * @task: the task to be executed
+ * @buffer: pointer to buffer to do I/O
+ * @size: size of @buffer
+ * @pci_dma_dir: PCI_DMA_...
+ */
+static int sas_execute_task(struct sas_task *task, void *buffer, int size,
+			    int pci_dma_dir)
+{
+	int res = 0;
+	struct scatterlist *scatter = NULL;
+	struct task_status_struct *ts = &task->task_status;
+	int num_scatter = 0;
+	int retries = 0;
+	struct sas_internal *i =
+		to_sas_internal(task->dev->port->ha->core.shost->transportt);
+
+	if (pci_dma_dir != PCI_DMA_NONE) {
+		scatter = kzalloc(sizeof(*scatter), GFP_KERNEL);
+		if (!scatter)
+			goto out;
+
+		sg_init_one(scatter, buffer, size);
+		num_scatter = 1;
+	}
+
+	task->task_proto = task->dev->tproto;
+	task->scatter = scatter;
+	task->num_scatter = num_scatter;
+	task->total_xfer_len = size;
+	task->data_dir = pci_dma_dir;
+	task->task_done = sas_disc_task_done;
+	if (pci_dma_dir != PCI_DMA_NONE &&
+	    sas_protocol_ata(task->task_proto)) {
+		task->num_scatter = pci_map_sg(task->dev->port->ha->pcidev,
+					       task->scatter,
+					       task->num_scatter,
+					       task->data_dir);
+	}
+
+	for (retries = 0; retries < 5; retries++) {
+		task->task_state_flags = SAS_TASK_STATE_PENDING;
+		init_completion(&task->completion);
+
+		task->timer.data = (unsigned long) task;
+		task->timer.function = sas_task_timedout;
+		task->timer.expires = jiffies + SAS_DEV_TIMEOUT*HZ;
+		add_timer(&task->timer);
+
+		res = i->dft->lldd_execute_task(task, 1, GFP_KERNEL);
+		if (res) {
+			del_timer(&task->timer);
+			SAS_DPRINTK("executing SAS discovery task failed:%d\n",
+				    res);
+			goto ex_err;
+		}
+		wait_for_completion(&task->completion);
+		res = -ETASK;
+		if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
+			int res2;
+			SAS_DPRINTK("task aborted, flags:0x%x\n",
+				    task->task_state_flags);
+			res2 = i->dft->lldd_abort_task(task);
+			SAS_DPRINTK("came back from abort task\n");
+			if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
+				if (res2 == TMF_RESP_FUNC_COMPLETE)
+					continue; /* Retry the task */
+				else
+					goto ex_err;
+			}
+		}
+		if (task->task_status.stat == SAM_BUSY ||
+			   task->task_status.stat == SAM_TASK_SET_FULL ||
+			   task->task_status.stat == SAS_QUEUE_FULL) {
+			SAS_DPRINTK("task: q busy, sleeping...\n");
+			schedule_timeout_interruptible(HZ);
+		} else if (task->task_status.stat == SAM_CHECK_COND) {
+			struct scsi_sense_hdr shdr;
+
+			if (!scsi_normalize_sense(ts->buf, ts->buf_valid_size,
+						  &shdr)) {
+				SAS_DPRINTK("couldn't normalize sense\n");
+				continue;
+			}
+			if ((shdr.sense_key == 6 && shdr.asc == 0x29) ||
+			    (shdr.sense_key == 2 && shdr.asc == 4 &&
+			     shdr.ascq == 1)) {
+				SAS_DPRINTK("device %016llx LUN: %016llx "
+					    "powering up or not ready yet, "
+					    "sleeping...\n",
+					    SAS_ADDR(task->dev->sas_addr),
+					    SAS_ADDR(task->ssp_task.LUN));
+
+				schedule_timeout_interruptible(5*HZ);
+			} else if (shdr.sense_key == 1) {
+				res = 0;
+				break;
+			} else if (shdr.sense_key == 5) {
+				break;
+			} else {
+				SAS_DPRINTK("dev %016llx LUN: %016llx "
+					    "sense key:0x%x ASC:0x%x ASCQ:0x%x"
+					    "\n",
+					    SAS_ADDR(task->dev->sas_addr),
+					    SAS_ADDR(task->ssp_task.LUN),
+					    shdr.sense_key,
+					    shdr.asc, shdr.ascq);
+			}
+		} else if (task->task_status.resp != SAS_TASK_COMPLETE ||
+			   task->task_status.stat != SAM_GOOD) {
+			SAS_DPRINTK("task finished with resp:0x%x, "
+				    "stat:0x%x\n",
+				    task->task_status.resp,
+				    task->task_status.stat);
+			goto ex_err;
+		} else {
+			res = 0;
+			break;
+		}
+	}
+ex_err:
+	if (pci_dma_dir != PCI_DMA_NONE) {
+		if (sas_protocol_ata(task->task_proto))
+			pci_unmap_sg(task->dev->port->ha->pcidev,
+				     task->scatter, task->num_scatter,
+				     task->data_dir);
+		kfree(scatter);
+	}
+out:
+	return res;
+}
+
+/* ---------- SATA ---------- */
+
+static void sas_get_ata_command_set(struct domain_device *dev)
+{
+	struct dev_to_host_fis *fis =
+		(struct dev_to_host_fis *) dev->frame_rcvd;
+
+	if ((fis->sector_count == 1 && /* ATA */
+	     fis->lbal         == 1 &&
+	     fis->lbam         == 0 &&
+	     fis->lbah         == 0 &&
+	     fis->device       == 0)
+	    ||
+	    (fis->sector_count == 0 && /* CE-ATA (mATA) */
+	     fis->lbal         == 0 &&
+	     fis->lbam         == 0xCE &&
+	     fis->lbah         == 0xAA &&
+	     (fis->device & ~0x10) == 0))
+
+		dev->sata_dev.command_set = ATA_COMMAND_SET;
+
+	else if ((fis->interrupt_reason == 1 &&	/* ATAPI */
+		  fis->lbal             == 1 &&
+		  fis->byte_count_low   == 0x14 &&
+		  fis->byte_count_high  == 0xEB &&
+		  (fis->device & ~0x10) == 0))
+
+		dev->sata_dev.command_set = ATAPI_COMMAND_SET;
+
+	else if ((fis->sector_count == 1 && /* SEMB */
+		  fis->lbal         == 1 &&
+		  fis->lbam         == 0x3C &&
+		  fis->lbah         == 0xC3 &&
+		  fis->device       == 0)
+		||
+		 (fis->interrupt_reason == 1 &&	/* SATA PM */
+		  fis->lbal             == 1 &&
+		  fis->byte_count_low   == 0x69 &&
+		  fis->byte_count_high  == 0x96 &&
+		  (fis->device & ~0x10) == 0))
+
+		/* Treat it as a superset? */
+		dev->sata_dev.command_set = ATAPI_COMMAND_SET;
+}
+
+/**
+ * sas_issue_ata_cmd -- Basic SATA command processing for discovery
+ * @dev: the device to send the command to
+ * @command: the command register
+ * @features: the features register
+ * @buffer: pointer to buffer to do I/O
+ * @size: size of @buffer
+ * @pci_dma_dir: PCI_DMA_...
+ */
+static int sas_issue_ata_cmd(struct domain_device *dev, u8 command,
+			     u8 features, void *buffer, int size,
+			     int pci_dma_dir)
+{
+	int res = 0;
+	struct sas_task *task;
+	struct dev_to_host_fis *d2h_fis = (struct dev_to_host_fis *)
+		&dev->frame_rcvd[0];
+
+	res = -ENOMEM;
+	task = sas_alloc_task(GFP_KERNEL);
+	if (!task)
+		goto out;
+
+	task->dev = dev;
+
+	task->ata_task.fis.fis_type = 0x27;
+	task->ata_task.fis.command = command;
+	task->ata_task.fis.features = features;
+	task->ata_task.fis.device = d2h_fis->device;
+	task->ata_task.retry_count = 1;
+
+	res = sas_execute_task(task, buffer, size, pci_dma_dir);
+
+	sas_free_task(task);
+out:
+	return res;
+}
+
+static void sas_sata_propagate_sas_addr(struct domain_device *dev)
+{
+	unsigned long flags;
+	struct asd_sas_port *port = dev->port;
+	struct asd_sas_phy  *phy;
+
+	BUG_ON(dev->parent);
+
+	memcpy(port->attached_sas_addr, dev->sas_addr, SAS_ADDR_SIZE);
+	spin_lock_irqsave(&port->phy_list_lock, flags);
+	list_for_each_entry(phy, &port->phy_list, port_phy_el)
+		memcpy(phy->attached_sas_addr, dev->sas_addr, SAS_ADDR_SIZE);
+	spin_unlock_irqrestore(&port->phy_list_lock, flags);
+}
+
+#define ATA_IDENTIFY_DEV         0xEC
+#define ATA_IDENTIFY_PACKET_DEV  0xA1
+#define ATA_SET_FEATURES         0xEF
+#define ATA_FEATURE_PUP_STBY_SPIN_UP 0x07
+
+/**
+ * sas_discover_sata_dev -- discover a STP/SATA device (SATA_DEV)
+ * @dev: STP/SATA device of interest (ATA/ATAPI)
+ *
+ * The LLDD has already been notified of this device, so that we can
+ * send FISes to it.  Here we try to get IDENTIFY DEVICE or IDENTIFY
+ * PACKET DEVICE, if ATAPI device, so that the LLDD can fine-tune its
+ * performance for this device.
+ */
+static int sas_discover_sata_dev(struct domain_device *dev)
+{
+	int     res;
+	__le16  *identify_x;
+	u8      command;
+
+	identify_x = kzalloc(512, GFP_KERNEL);
+	if (!identify_x)
+		return -ENOMEM;
+
+	if (dev->sata_dev.command_set == ATA_COMMAND_SET) {
+		dev->sata_dev.identify_device = identify_x;
+		command = ATA_IDENTIFY_DEV;
+	} else {
+		dev->sata_dev.identify_packet_device = identify_x;
+		command = ATA_IDENTIFY_PACKET_DEV;
+	}
+
+	res = sas_issue_ata_cmd(dev, command, 0, identify_x, 512,
+				PCI_DMA_FROMDEVICE);
+	if (res)
+		goto out_err;
+
+	/* lives on the media? */
+	if (le16_to_cpu(identify_x[0]) & 4) {
+		/* incomplete response */
+		SAS_DPRINTK("sending SET FEATURE/PUP_STBY_SPIN_UP to "
+			    "dev %llx\n", SAS_ADDR(dev->sas_addr));
+		if (!le16_to_cpu(identify_x[83] & (1<<6)))
+			goto cont1;
+		res = sas_issue_ata_cmd(dev, ATA_SET_FEATURES,
+					ATA_FEATURE_PUP_STBY_SPIN_UP,
+					NULL, 0, PCI_DMA_NONE);
+		if (res)
+			goto cont1;
+
+		schedule_timeout_interruptible(5*HZ); /* More time? */
+		res = sas_issue_ata_cmd(dev, command, 0, identify_x, 512,
+					PCI_DMA_FROMDEVICE);
+		if (res)
+			goto out_err;
+	}
+cont1:
+	/* Get WWN */
+	if (dev->port->oob_mode != SATA_OOB_MODE) {
+		memcpy(dev->sas_addr, dev->sata_dev.rps_resp.rps.stp_sas_addr,
+		       SAS_ADDR_SIZE);
+	} else if (dev->sata_dev.command_set == ATA_COMMAND_SET &&
+		   (le16_to_cpu(dev->sata_dev.identify_device[108]) & 0xF000)
+		   == 0x5000) {
+		int i;
+
+		for (i = 0; i < 4; i++) {
+			dev->sas_addr[2*i] =
+	     (le16_to_cpu(dev->sata_dev.identify_device[108+i]) & 0xFF00) >> 8;
+			dev->sas_addr[2*i+1] =
+	      le16_to_cpu(dev->sata_dev.identify_device[108+i]) & 0x00FF;
+		}
+	}
+	sas_hash_addr(dev->hashed_sas_addr, dev->sas_addr);
+	if (!dev->parent)
+		sas_sata_propagate_sas_addr(dev);
+
+	/* XXX Hint: register this SATA device with SATL.
+	   When this returns, dev->sata_dev->lu is alive and
+	   present.
+	sas_satl_register_dev(dev);
+	*/
+
+	sas_fill_in_rphy(dev, dev->rphy);
+
+	return 0;
+out_err:
+	dev->sata_dev.identify_packet_device = NULL;
+	dev->sata_dev.identify_device = NULL;
+	kfree(identify_x);
+	return res;
+}
+
+static int sas_discover_sata_pm(struct domain_device *dev)
+{
+	return -ENODEV;
+}
+
+/**
+ * sas_discover_sata -- discover an STP/SATA domain device
+ * @dev: pointer to struct domain_device of interest
+ *
+ * First we notify the LLDD of this device, so we can send frames to
+ * it.  Then depending on the type of device we call the appropriate
+ * discover functions.  Once device discover is done, we notify the
+ * LLDD so that it can fine-tune its parameters for the device, by
+ * removing it and then adding it.  That is, the second time around,
+ * the driver would have certain fields, that it is looking at, set.
+ * Finally we initialize the kobj so that the device can be added to
+ * the system at registration time.  Devices directly attached to a HA
+ * port, have no parents.  All other devices do, and should have their
+ * "parent" pointer set appropriately before calling this function.
+ */
+int sas_discover_sata(struct domain_device *dev)
+{
+	int res;
+
+	sas_get_ata_command_set(dev);
+
+	res = sas_notify_lldd_dev_found(dev);
+	if (res)
+		return res;
+
+	switch (dev->dev_type) {
+	case SATA_DEV:
+		res = sas_discover_sata_dev(dev);
+		break;
+	case SATA_PM:
+		res = sas_discover_sata_pm(dev);
+		break;
+	default:
+		break;
+	}
+	sas_notify_lldd_dev_gone(dev);
+	if (!res) {
+		sas_notify_lldd_dev_found(dev);
+		res = sas_rphy_add(dev->rphy);
+	}
+
+	return res;
+}
diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 328a78a..6ac9f61 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -55,161 +55,6 @@ void sas_init_dev(struct domain_device *dev)
         }
 }
 
-static void sas_task_timedout(unsigned long _task)
-{
-	struct sas_task *task = (void *) _task;
-	unsigned long flags;
-
-	spin_lock_irqsave(&task->task_state_lock, flags);
-	if (!(task->task_state_flags & SAS_TASK_STATE_DONE))
-		task->task_state_flags |= SAS_TASK_STATE_ABORTED;
-	spin_unlock_irqrestore(&task->task_state_lock, flags);
-
-	complete(&task->completion);
-}
-
-static void sas_disc_task_done(struct sas_task *task)
-{
-	if (!del_timer(&task->timer))
-		return;
-	complete(&task->completion);
-}
-
-#define SAS_DEV_TIMEOUT 10
-
-/**
- * sas_execute_task -- Basic task processing for discovery
- * @task: the task to be executed
- * @buffer: pointer to buffer to do I/O
- * @size: size of @buffer
- * @pci_dma_dir: PCI_DMA_...
- */
-static int sas_execute_task(struct sas_task *task, void *buffer, int size,
-			    int pci_dma_dir)
-{
-	int res = 0;
-	struct scatterlist *scatter = NULL;
-	struct task_status_struct *ts = &task->task_status;
-	int num_scatter = 0;
-	int retries = 0;
-	struct sas_internal *i =
-		to_sas_internal(task->dev->port->ha->core.shost->transportt);
-
-	if (pci_dma_dir != PCI_DMA_NONE) {
-		scatter = kzalloc(sizeof(*scatter), GFP_KERNEL);
-		if (!scatter)
-			goto out;
-
-		sg_init_one(scatter, buffer, size);
-		num_scatter = 1;
-	}
-
-	task->task_proto = task->dev->tproto;
-	task->scatter = scatter;
-	task->num_scatter = num_scatter;
-	task->total_xfer_len = size;
-	task->data_dir = pci_dma_dir;
-	task->task_done = sas_disc_task_done;
-	if (pci_dma_dir != PCI_DMA_NONE &&
-	    sas_protocol_ata(task->task_proto)) {
-		task->num_scatter = pci_map_sg(task->dev->port->ha->pcidev,
-					       task->scatter,
-					       task->num_scatter,
-					       task->data_dir);
-	}
-
-	for (retries = 0; retries < 5; retries++) {
-		task->task_state_flags = SAS_TASK_STATE_PENDING;
-		init_completion(&task->completion);
-
-		task->timer.data = (unsigned long) task;
-		task->timer.function = sas_task_timedout;
-		task->timer.expires = jiffies + SAS_DEV_TIMEOUT*HZ;
-		add_timer(&task->timer);
-
-		res = i->dft->lldd_execute_task(task, 1, GFP_KERNEL);
-		if (res) {
-			del_timer(&task->timer);
-			SAS_DPRINTK("executing SAS discovery task failed:%d\n",
-				    res);
-			goto ex_err;
-		}
-		wait_for_completion(&task->completion);
-		res = -ETASK;
-		if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
-			int res2;
-			SAS_DPRINTK("task aborted, flags:0x%x\n",
-				    task->task_state_flags);
-			res2 = i->dft->lldd_abort_task(task);
-			SAS_DPRINTK("came back from abort task\n");
-			if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
-				if (res2 == TMF_RESP_FUNC_COMPLETE)
-					continue; /* Retry the task */
-				else
-					goto ex_err;
-			}
-		}
-		if (task->task_status.stat == SAM_BUSY ||
-			   task->task_status.stat == SAM_TASK_SET_FULL ||
-			   task->task_status.stat == SAS_QUEUE_FULL) {
-			SAS_DPRINTK("task: q busy, sleeping...\n");
-			schedule_timeout_interruptible(HZ);
-		} else if (task->task_status.stat == SAM_CHECK_COND) {
-			struct scsi_sense_hdr shdr;
-
-			if (!scsi_normalize_sense(ts->buf, ts->buf_valid_size,
-						  &shdr)) {
-				SAS_DPRINTK("couldn't normalize sense\n");
-				continue;
-			}
-			if ((shdr.sense_key == 6 && shdr.asc == 0x29) ||
-			    (shdr.sense_key == 2 && shdr.asc == 4 &&
-			     shdr.ascq == 1)) {
-				SAS_DPRINTK("device %016llx LUN: %016llx "
-					    "powering up or not ready yet, "
-					    "sleeping...\n",
-					    SAS_ADDR(task->dev->sas_addr),
-					    SAS_ADDR(task->ssp_task.LUN));
-
-				schedule_timeout_interruptible(5*HZ);
-			} else if (shdr.sense_key == 1) {
-				res = 0;
-				break;
-			} else if (shdr.sense_key == 5) {
-				break;
-			} else {
-				SAS_DPRINTK("dev %016llx LUN: %016llx "
-					    "sense key:0x%x ASC:0x%x ASCQ:0x%x"
-					    "\n",
-					    SAS_ADDR(task->dev->sas_addr),
-					    SAS_ADDR(task->ssp_task.LUN),
-					    shdr.sense_key,
-					    shdr.asc, shdr.ascq);
-			}
-		} else if (task->task_status.resp != SAS_TASK_COMPLETE ||
-			   task->task_status.stat != SAM_GOOD) {
-			SAS_DPRINTK("task finished with resp:0x%x, "
-				    "stat:0x%x\n",
-				    task->task_status.resp,
-				    task->task_status.stat);
-			goto ex_err;
-		} else {
-			res = 0;
-			break;
-		}
-	}
-ex_err:
-	if (pci_dma_dir != PCI_DMA_NONE) {
-		if (sas_protocol_ata(task->task_proto))
-			pci_unmap_sg(task->dev->port->ha->pcidev,
-				     task->scatter, task->num_scatter,
-				     task->data_dir);
-		kfree(scatter);
-	}
-out:
-	return res;
-}
-
 /* ---------- Domain device discovery ---------- */
 
 /**
@@ -313,202 +158,6 @@ static int sas_get_port_device(struct asd_sas_port *port)
 
 /* ---------- Discover and Revalidate ---------- */
 
-/* ---------- SATA ---------- */
-
-static void sas_get_ata_command_set(struct domain_device *dev)
-{
-	struct dev_to_host_fis *fis =
-		(struct dev_to_host_fis *) dev->frame_rcvd;
-
-	if ((fis->sector_count == 1 && /* ATA */
-	     fis->lbal         == 1 &&
-	     fis->lbam         == 0 &&
-	     fis->lbah         == 0 &&
-	     fis->device       == 0)
-	    ||
-	    (fis->sector_count == 0 && /* CE-ATA (mATA) */
-	     fis->lbal         == 0 &&
-	     fis->lbam         == 0xCE &&
-	     fis->lbah         == 0xAA &&
-	     (fis->device & ~0x10) == 0))
-
-		dev->sata_dev.command_set = ATA_COMMAND_SET;
-
-	else if ((fis->interrupt_reason == 1 &&	/* ATAPI */
-		  fis->lbal             == 1 &&
-		  fis->byte_count_low   == 0x14 &&
-		  fis->byte_count_high  == 0xEB &&
-		  (fis->device & ~0x10) == 0))
-
-		dev->sata_dev.command_set = ATAPI_COMMAND_SET;
-
-	else if ((fis->sector_count == 1 && /* SEMB */
-		  fis->lbal         == 1 &&
-		  fis->lbam         == 0x3C &&
-		  fis->lbah         == 0xC3 &&
-		  fis->device       == 0)
-		||
-		 (fis->interrupt_reason == 1 &&	/* SATA PM */
-		  fis->lbal             == 1 &&
-		  fis->byte_count_low   == 0x69 &&
-		  fis->byte_count_high  == 0x96 &&
-		  (fis->device & ~0x10) == 0))
-
-		/* Treat it as a superset? */
-		dev->sata_dev.command_set = ATAPI_COMMAND_SET;
-}
-
-/**
- * sas_issue_ata_cmd -- Basic SATA command processing for discovery
- * @dev: the device to send the command to
- * @command: the command register
- * @features: the features register
- * @buffer: pointer to buffer to do I/O
- * @size: size of @buffer
- * @pci_dma_dir: PCI_DMA_...
- */
-static int sas_issue_ata_cmd(struct domain_device *dev, u8 command,
-			     u8 features, void *buffer, int size,
-			     int pci_dma_dir)
-{
-	int res = 0;
-	struct sas_task *task;
-	struct dev_to_host_fis *d2h_fis = (struct dev_to_host_fis *)
-		&dev->frame_rcvd[0];
-
-	res = -ENOMEM;
-	task = sas_alloc_task(GFP_KERNEL);
-	if (!task)
-		goto out;
-
-	task->dev = dev;
-
-	task->ata_task.fis.fis_type = 0x27;
-	task->ata_task.fis.command = command;
-	task->ata_task.fis.features = features;
-	task->ata_task.fis.device = d2h_fis->device;
-	task->ata_task.retry_count = 1;
-
-	res = sas_execute_task(task, buffer, size, pci_dma_dir);
-
-	sas_free_task(task);
-out:
-	return res;
-}
-
-static void sas_sata_propagate_sas_addr(struct domain_device *dev)
-{
-	unsigned long flags;
-	struct asd_sas_port *port = dev->port;
-	struct asd_sas_phy  *phy;
-
-	BUG_ON(dev->parent);
-
-	memcpy(port->attached_sas_addr, dev->sas_addr, SAS_ADDR_SIZE);
-	spin_lock_irqsave(&port->phy_list_lock, flags);
-	list_for_each_entry(phy, &port->phy_list, port_phy_el)
-		memcpy(phy->attached_sas_addr, dev->sas_addr, SAS_ADDR_SIZE);
-	spin_unlock_irqrestore(&port->phy_list_lock, flags);
-}
-
-#define ATA_IDENTIFY_DEV         0xEC
-#define ATA_IDENTIFY_PACKET_DEV  0xA1
-#define ATA_SET_FEATURES         0xEF
-#define ATA_FEATURE_PUP_STBY_SPIN_UP 0x07
-
-/**
- * sas_discover_sata_dev -- discover a STP/SATA device (SATA_DEV)
- * @dev: STP/SATA device of interest (ATA/ATAPI)
- *
- * The LLDD has already been notified of this device, so that we can
- * send FISes to it.  Here we try to get IDENTIFY DEVICE or IDENTIFY
- * PACKET DEVICE, if ATAPI device, so that the LLDD can fine-tune its
- * performance for this device.
- */
-static int sas_discover_sata_dev(struct domain_device *dev)
-{
-	int     res;
-	__le16  *identify_x;
-	u8      command;
-
-	identify_x = kzalloc(512, GFP_KERNEL);
-	if (!identify_x)
-		return -ENOMEM;
-
-	if (dev->sata_dev.command_set == ATA_COMMAND_SET) {
-		dev->sata_dev.identify_device = identify_x;
-		command = ATA_IDENTIFY_DEV;
-	} else {
-		dev->sata_dev.identify_packet_device = identify_x;
-		command = ATA_IDENTIFY_PACKET_DEV;
-	}
-
-	res = sas_issue_ata_cmd(dev, command, 0, identify_x, 512,
-				PCI_DMA_FROMDEVICE);
-	if (res)
-		goto out_err;
-
-	/* lives on the media? */
-	if (le16_to_cpu(identify_x[0]) & 4) {
-		/* incomplete response */
-		SAS_DPRINTK("sending SET FEATURE/PUP_STBY_SPIN_UP to "
-			    "dev %llx\n", SAS_ADDR(dev->sas_addr));
-		if (!le16_to_cpu(identify_x[83] & (1<<6)))
-			goto cont1;
-		res = sas_issue_ata_cmd(dev, ATA_SET_FEATURES,
-					ATA_FEATURE_PUP_STBY_SPIN_UP,
-					NULL, 0, PCI_DMA_NONE);
-		if (res)
-			goto cont1;
-
-		schedule_timeout_interruptible(5*HZ); /* More time? */
-		res = sas_issue_ata_cmd(dev, command, 0, identify_x, 512,
-					PCI_DMA_FROMDEVICE);
-		if (res)
-			goto out_err;
-	}
-cont1:
-	/* Get WWN */
-	if (dev->port->oob_mode != SATA_OOB_MODE) {
-		memcpy(dev->sas_addr, dev->sata_dev.rps_resp.rps.stp_sas_addr,
-		       SAS_ADDR_SIZE);
-	} else if (dev->sata_dev.command_set == ATA_COMMAND_SET &&
-		   (le16_to_cpu(dev->sata_dev.identify_device[108]) & 0xF000)
-		   == 0x5000) {
-		int i;
-
-		for (i = 0; i < 4; i++) {
-			dev->sas_addr[2*i] =
-	     (le16_to_cpu(dev->sata_dev.identify_device[108+i]) & 0xFF00) >> 8;
-			dev->sas_addr[2*i+1] =
-	      le16_to_cpu(dev->sata_dev.identify_device[108+i]) & 0x00FF;
-		}
-	}
-	sas_hash_addr(dev->hashed_sas_addr, dev->sas_addr);
-	if (!dev->parent)
-		sas_sata_propagate_sas_addr(dev);
-
-	/* XXX Hint: register this SATA device with SATL.
-	   When this returns, dev->sata_dev->lu is alive and
-	   present.
-	sas_satl_register_dev(dev);
-	*/
-
-	sas_fill_in_rphy(dev, dev->rphy);
-
-	return 0;
-out_err:
-	dev->sata_dev.identify_packet_device = NULL;
-	dev->sata_dev.identify_device = NULL;
-	kfree(identify_x);
-	return res;
-}
-
-static int sas_discover_sata_pm(struct domain_device *dev)
-{
-	return -ENODEV;
-}
-
 int sas_notify_lldd_dev_found(struct domain_device *dev)
 {
 	int res = 0;
@@ -541,49 +190,6 @@ void sas_notify_lldd_dev_gone(struct domain_device *dev)
 
 /* ---------- Common/dispatchers ---------- */
 
-/**
- * sas_discover_sata -- discover an STP/SATA domain device
- * @dev: pointer to struct domain_device of interest
- *
- * First we notify the LLDD of this device, so we can send frames to
- * it.  Then depending on the type of device we call the appropriate
- * discover functions.  Once device discover is done, we notify the
- * LLDD so that it can fine-tune its parameters for the device, by
- * removing it and then adding it.  That is, the second time around,
- * the driver would have certain fields, that it is looking at, set.
- * Finally we initialize the kobj so that the device can be added to
- * the system at registration time.  Devices directly attached to a HA
- * port, have no parents.  All other devices do, and should have their
- * "parent" pointer set appropriately before calling this function.
- */
-int sas_discover_sata(struct domain_device *dev)
-{
-	int res;
-
-	sas_get_ata_command_set(dev);
-
-	res = sas_notify_lldd_dev_found(dev);
-	if (res)
-		return res;
-
-	switch (dev->dev_type) {
-	case SATA_DEV:
-		res = sas_discover_sata_dev(dev);
-		break;
-	case SATA_PM:
-		res = sas_discover_sata_pm(dev);
-		break;
-	default:
-		break;
-	}
-	sas_notify_lldd_dev_gone(dev);
-	if (!res) {
-		sas_notify_lldd_dev_found(dev);
-		res = sas_rphy_add(dev->rphy);
-	}
-
-	return res;
-}
 
 /**
  * sas_discover_end_dev -- discover an end device (SSP, etc)
@@ -690,11 +296,14 @@ static void sas_discover_domain(struct work_struct *work)
 	case FANOUT_DEV:
 		error = sas_discover_root_expander(dev);
 		break;
+#ifdef CONFIG_SCSI_SAS_ATA
 	case SATA_DEV:
 	case SATA_PM:
 		error = sas_discover_sata(dev);
 		break;
+#endif
 	default:
+		error = -ENXIO;
 		SAS_DPRINTK("unhandled device %d\n", dev->dev_type);
 		break;
 	}
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index eca83e8..c758964 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -535,6 +535,8 @@ int sas_smp_get_phy_events(struct sas_phy *phy)
 
 }
 
+#ifdef CONFIG_SCSI_SAS_ATA
+
 #define RPS_REQ_SIZE  16
 #define RPS_RESP_SIZE 60
 
@@ -578,6 +580,7 @@ static int sas_get_report_phy_sata(struct domain_device *dev,
 	kfree(rps_req);
 	return res;
 }
+#endif
 
 static void sas_ex_get_linkrate(struct domain_device *parent,
 				       struct domain_device *child,
@@ -645,6 +648,7 @@ static struct domain_device *sas_ex_discover_end_dev(
 	}
 	sas_ex_get_linkrate(parent, child, phy);
 
+#ifdef CONFIG_SCSI_SAS_ATA
 	if ((phy->attached_tproto & SAS_PROTO_STP) || phy->attached_sata_dev) {
 		child->dev_type = SATA_DEV;
 		if (phy->attached_tproto & SAS_PROTO_STP)
@@ -682,7 +686,9 @@ static struct domain_device *sas_ex_discover_end_dev(
 				    SAS_ADDR(parent->sas_addr), phy_id, res);
 			goto out_list_del;
 		}
-	} else if (phy->attached_tproto & SAS_PROTO_SSP) {
+	} else 
+#endif
+	  if (phy->attached_tproto & SAS_PROTO_SSP) {
 		child->dev_type = SAS_END_DEV;
 		rphy = sas_end_device_alloc(phy->port);
 		/* FIXME: error handling */
@@ -710,6 +716,7 @@ static struct domain_device *sas_ex_discover_end_dev(
 		SAS_DPRINTK("target proto 0x%x at %016llx:0x%x not handled\n",
 			    phy->attached_tproto, SAS_ADDR(parent->sas_addr),
 			    phy_id);
+		goto out_free;
 	}
 
 	list_add_tail(&child->siblings, &parent_ex->children);
diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
index 3407c81..dd5edc9 100644
--- a/include/scsi/sas_ata.h
+++ b/include/scsi/sas_ata.h
@@ -28,6 +28,8 @@
 #include <linux/libata.h>
 #include <scsi/libsas.h>
 
+#ifdef CONFIG_SCSI_SAS_ATA
+
 static inline int dev_is_sata(struct domain_device *dev)
 {
 	return (dev->rphy->identify.target_port_protocols & SAS_PROTOCOL_SATA);
@@ -38,4 +40,21 @@ int sas_ata_init_host_and_port(struct domain_device *found_dev,
 
 void sas_ata_task_abort(struct sas_task *task);
 
+#else
+
+
+static inline int dev_is_sata(struct domain_device *dev)
+{
+	return 0;
+}
+int sas_ata_init_host_and_port(struct domain_device *found_dev,
+			       struct scsi_target *starget)
+{
+	return 0;
+}
+void sas_ata_task_abort(struct sas_task *task)
+{
+}
+#endif
+
 #endif /* _SAS_ATA_H_ */


