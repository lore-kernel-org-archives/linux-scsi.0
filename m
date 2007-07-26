From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH v2] Remove libsas PCI dependencies
Date: Thu, 26 Jul 2007 09:28:37 -0400
Message-ID: <46A8A185.7010609@garzik.org>
References: <Pine.SOC.4.64.0707261129220.17385@math.ut.ee>	 <46A867AB.7050007@garzik.org> <1185454007.3501.34.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070808040408010102030303"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:47536 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088AbXGZN2m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jul 2007 09:28:42 -0400
In-Reply-To: <1185454007.3501.34.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Meelis Roos <mroos@linux.ee>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel list <linux-kernel@vger.kernel.org>, "Darrick J. Wong" <djwong@us.ibm.com>, Andrew Morton <akpm@linux-foundation.org>

This is a multi-part message in MIME format.
--------------070808040408010102030303
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Eliminate unnecessary PCI dependencies in libsas.  It should use generic 
DMA and struct device like other subsystems.

Signed-off-by: Jeff Garzik <jeff@garzik.org>



--------------070808040408010102030303
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index ab00aec..63bcde2 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -586,7 +586,7 @@ static int __devinit asd_pci_probe(struct pci_dev *dev,
 		goto Err;
 	}
 	asd_ha->pcidev = dev;
-	asd_ha->sas_ha.pcidev = asd_ha->pcidev;
+	asd_ha->sas_ha.dev = &asd_ha->pcidev->dev;
 	asd_ha->sas_ha.lldd_ha = asd_ha;
 
 	asd_ha->name = asd_dev->name;
@@ -605,8 +605,6 @@ static int __devinit asd_pci_probe(struct pci_dev *dev,
 		goto Err_free;
 	}
 
-
-
 	err = asd_dev->setup(asd_ha);
 	if (err)
 		goto Err_free;
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index ced2de3..5e573ef 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -382,7 +382,7 @@ int sas_ata_init_host_and_port(struct domain_device *found_dev,
 	struct ata_port *ap;
 
 	ata_host_init(&found_dev->sata_dev.ata_host,
-		      &ha->pcidev->dev,
+		      ha->dev,
 		      sata_port_info.flags,
 		      &sas_sata_ops);
 	ap = ata_sas_port_alloc(&found_dev->sata_dev.ata_host,
@@ -448,10 +448,10 @@ static void sas_disc_task_done(struct sas_task *task)
  * @task: the task to be executed
  * @buffer: pointer to buffer to do I/O
  * @size: size of @buffer
- * @pci_dma_dir: PCI_DMA_...
+ * @dma_dir: DMA direction.  DMA_xxx
  */
 static int sas_execute_task(struct sas_task *task, void *buffer, int size,
-			    int pci_dma_dir)
+			    enum dma_data_direction dma_dir)
 {
 	int res = 0;
 	struct scatterlist *scatter = NULL;
@@ -461,7 +461,7 @@ static int sas_execute_task(struct sas_task *task, void *buffer, int size,
 	struct sas_internal *i =
 		to_sas_internal(task->dev->port->ha->core.shost->transportt);
 
-	if (pci_dma_dir != PCI_DMA_NONE) {
+	if (dma_dir != DMA_NONE) {
 		scatter = kzalloc(sizeof(*scatter), GFP_KERNEL);
 		if (!scatter)
 			goto out;
@@ -474,11 +474,11 @@ static int sas_execute_task(struct sas_task *task, void *buffer, int size,
 	task->scatter = scatter;
 	task->num_scatter = num_scatter;
 	task->total_xfer_len = size;
-	task->data_dir = pci_dma_dir;
+	task->data_dir = dma_dir;
 	task->task_done = sas_disc_task_done;
-	if (pci_dma_dir != PCI_DMA_NONE &&
+	if (dma_dir != DMA_NONE &&
 	    sas_protocol_ata(task->task_proto)) {
-		task->num_scatter = pci_map_sg(task->dev->port->ha->pcidev,
+		task->num_scatter = dma_map_sg(task->dev->port->ha->dev,
 					       task->scatter,
 					       task->num_scatter,
 					       task->data_dir);
@@ -565,9 +565,9 @@ static int sas_execute_task(struct sas_task *task, void *buffer, int size,
 		}
 	}
 ex_err:
-	if (pci_dma_dir != PCI_DMA_NONE) {
+	if (dma_dir != DMA_NONE) {
 		if (sas_protocol_ata(task->task_proto))
-			pci_unmap_sg(task->dev->port->ha->pcidev,
+			dma_unmap_sg(task->dev->port->ha->dev,
 				     task->scatter, task->num_scatter,
 				     task->data_dir);
 		kfree(scatter);
@@ -628,11 +628,11 @@ static void sas_get_ata_command_set(struct domain_device *dev)
  * @features: the features register
  * @buffer: pointer to buffer to do I/O
  * @size: size of @buffer
- * @pci_dma_dir: PCI_DMA_...
+ * @dma_dir: DMA direction.  DMA_xxx
  */
 static int sas_issue_ata_cmd(struct domain_device *dev, u8 command,
 			     u8 features, void *buffer, int size,
-			     int pci_dma_dir)
+			     enum dma_data_direction dma_dir)
 {
 	int res = 0;
 	struct sas_task *task;
@@ -652,7 +652,7 @@ static int sas_issue_ata_cmd(struct domain_device *dev, u8 command,
 	task->ata_task.fis.device = d2h_fis->device;
 	task->ata_task.retry_count = 1;
 
-	res = sas_execute_task(task, buffer, size, pci_dma_dir);
+	res = sas_execute_task(task, buffer, size, dma_dir);
 
 	sas_free_task(task);
 out:
@@ -707,7 +707,7 @@ static int sas_discover_sata_dev(struct domain_device *dev)
 	}
 
 	res = sas_issue_ata_cmd(dev, command, 0, identify_x, 512,
-				PCI_DMA_FROMDEVICE);
+				DMA_FROM_DEVICE);
 	if (res)
 		goto out_err;
 
@@ -720,13 +720,13 @@ static int sas_discover_sata_dev(struct domain_device *dev)
 			goto cont1;
 		res = sas_issue_ata_cmd(dev, ATA_SET_FEATURES,
 					ATA_FEATURE_PUP_STBY_SPIN_UP,
-					NULL, 0, PCI_DMA_NONE);
+					NULL, 0, DMA_NONE);
 		if (res)
 			goto cont1;
 
 		schedule_timeout_interruptible(5*HZ); /* More time? */
 		res = sas_issue_ata_cmd(dev, command, 0, identify_x, 512,
-					PCI_DMA_FROMDEVICE);
+					DMA_FROM_DEVICE);
 		if (res)
 			goto out_err;
 	}
diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 6ac9f61..7ef0afc 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -22,7 +22,6 @@
  *
  */
 
-#include <linux/pci.h>
 #include <linux/scatterlist.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_eh.h>
@@ -170,7 +169,7 @@ int sas_notify_lldd_dev_found(struct domain_device *dev)
 		if (res) {
 			printk("sas: driver on pcidev %s cannot handle "
 			       "device %llx, error:%d\n",
-			       pci_name(sas_ha->pcidev),
+			       sas_ha->dev->bus_id,
 			       SAS_ADDR(dev->sas_addr), res);
 		}
 	}
diff --git a/drivers/scsi/libsas/sas_dump.c b/drivers/scsi/libsas/sas_dump.c
index f1246d2..bf34a23 100644
--- a/drivers/scsi/libsas/sas_dump.c
+++ b/drivers/scsi/libsas/sas_dump.c
@@ -56,7 +56,7 @@ void sas_dprint_phye(int phyid, enum phy_event pe)
 
 void sas_dprint_hae(struct sas_ha_struct *sas_ha, enum ha_event he)
 {
-	SAS_DPRINTK("ha %s: %s event\n", pci_name(sas_ha->pcidev),
+	SAS_DPRINTK("ha %s: %s event\n", sas_ha->dev->bus_id,
 		    sas_hae_str[he]);
 }
 
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index df36461..8dda2d6 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -348,7 +348,7 @@ struct sas_ha_struct {
 
 /* public: */
 	char *sas_ha_name;
-	struct pci_dev *pcidev;	  /* should be set */
+	struct device *dev;	  /* should be set */
 	struct module *lldd_module; /* should be set */
 
 	u8 *sas_addr;		  /* must be set */

--------------070808040408010102030303--
