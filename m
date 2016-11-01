From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/3] smartpqi: switch to pci_alloc_irq_vectors
Date: Tue,  1 Nov 2016 08:12:49 -0600
Message-ID: <1478009569-19026-4-git-send-email-hch@lst.de>
References: <1478009569-19026-1-git-send-email-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1478009569-19026-1-git-send-email-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: martin.petersen@oracle.com, don.brace@microsemi.com
Cc: axboe@kernel.dk, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Which cleans up a lot of the MSI-X handling, and allows us to use the
PCI IRQ layer provided vector mapping, which we can then expose to blk-mq.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Acked-by: Don Brace <don.brace@microsemi.com>
Tested-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |   2 -
 drivers/scsi/smartpqi/smartpqi_init.c | 102 +++++++++++-----------------------
 2 files changed, 32 insertions(+), 72 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 07b6444..b673825 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -929,8 +929,6 @@ struct pqi_ctrl_info {
 	int		max_msix_vectors;
 	int		num_msix_vectors_enabled;
 	int		num_msix_vectors_initialized;
-	u32		msix_vectors[PQI_MAX_MSIX_VECTORS];
-	void		*intr_data[PQI_MAX_MSIX_VECTORS];
 	int		event_irq;
 	struct Scsi_Host *scsi_host;
 
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index a535b26..8702d9c 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -25,6 +25,7 @@
 #include <linux/rtc.h>
 #include <linux/bcd.h>
 #include <linux/cciss_ioctl.h>
+#include <linux/blk-mq-pci.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
@@ -2887,19 +2888,19 @@ static irqreturn_t pqi_irq_handler(int irq, void *data)
 
 static int pqi_request_irqs(struct pqi_ctrl_info *ctrl_info)
 {
+	struct pci_dev *pdev = ctrl_info->pci_dev;
 	int i;
 	int rc;
 
-	ctrl_info->event_irq = ctrl_info->msix_vectors[0];
+	ctrl_info->event_irq = pci_irq_vector(pdev, 0);
 
 	for (i = 0; i < ctrl_info->num_msix_vectors_enabled; i++) {
-		rc = request_irq(ctrl_info->msix_vectors[i],
-			pqi_irq_handler, 0,
-			DRIVER_NAME_SHORT, ctrl_info->intr_data[i]);
+		rc = request_irq(pci_irq_vector(pdev, i), pqi_irq_handler, 0,
+			DRIVER_NAME_SHORT, &ctrl_info->queue_groups[i]);
 		if (rc) {
-			dev_err(&ctrl_info->pci_dev->dev,
+			dev_err(&pdev->dev,
 				"irq %u init failed with error %d\n",
-				ctrl_info->msix_vectors[i], rc);
+				pci_irq_vector(pdev, i), rc);
 			return rc;
 		}
 		ctrl_info->num_msix_vectors_initialized++;
@@ -2908,72 +2909,23 @@ static int pqi_request_irqs(struct pqi_ctrl_info *ctrl_info)
 	return 0;
 }
 
-static void pqi_free_irqs(struct pqi_ctrl_info *ctrl_info)
-{
-	int i;
-
-	for (i = 0; i < ctrl_info->num_msix_vectors_initialized; i++)
-		free_irq(ctrl_info->msix_vectors[i],
-			ctrl_info->intr_data[i]);
-}
-
 static int pqi_enable_msix_interrupts(struct pqi_ctrl_info *ctrl_info)
 {
-	unsigned int i;
-	int max_vectors;
-	int num_vectors_enabled;
-	struct msix_entry msix_entries[PQI_MAX_MSIX_VECTORS];
-
-	max_vectors = ctrl_info->num_queue_groups;
-
-	for (i = 0; i < max_vectors; i++)
-		msix_entries[i].entry = i;
-
-	num_vectors_enabled = pci_enable_msix_range(ctrl_info->pci_dev,
-		msix_entries, PQI_MIN_MSIX_VECTORS, max_vectors);
+	int ret;
 
-	if (num_vectors_enabled < 0) {
+	ret = pci_alloc_irq_vectors(ctrl_info->pci_dev,
+			PQI_MIN_MSIX_VECTORS, ctrl_info->num_queue_groups,
+			PCI_IRQ_MSIX | PCI_IRQ_AFFINITY);
+	if (ret < 0) {
 		dev_err(&ctrl_info->pci_dev->dev,
-			"MSI-X init failed with error %d\n",
-			num_vectors_enabled);
-		return num_vectors_enabled;
-	}
-
-	ctrl_info->num_msix_vectors_enabled = num_vectors_enabled;
-	for (i = 0; i < num_vectors_enabled; i++) {
-		ctrl_info->msix_vectors[i] = msix_entries[i].vector;
-		ctrl_info->intr_data[i] = &ctrl_info->queue_groups[i];
+			"MSI-X init failed with error %d\n", ret);
+		return ret;
 	}
 
+	ctrl_info->num_msix_vectors_enabled = ret;
 	return 0;
 }
 
-static void pqi_irq_set_affinity_hint(struct pqi_ctrl_info *ctrl_info)
-{
-	int i;
-	int rc;
-	int cpu;
-
-	cpu = cpumask_first(cpu_online_mask);
-	for (i = 0; i < ctrl_info->num_msix_vectors_initialized; i++) {
-		rc = irq_set_affinity_hint(ctrl_info->msix_vectors[i],
-			get_cpu_mask(cpu));
-		if (rc)
-			dev_err(&ctrl_info->pci_dev->dev,
-				"error %d setting affinity hint for irq vector %u\n",
-				rc, ctrl_info->msix_vectors[i]);
-		cpu = cpumask_next(cpu, cpu_online_mask);
-	}
-}
-
-static void pqi_irq_unset_affinity_hint(struct pqi_ctrl_info *ctrl_info)
-{
-	int i;
-
-	for (i = 0; i < ctrl_info->num_msix_vectors_initialized; i++)
-		irq_set_affinity_hint(ctrl_info->msix_vectors[i], NULL);
-}
-
 static int pqi_alloc_operational_queues(struct pqi_ctrl_info *ctrl_info)
 {
 	unsigned int i;
@@ -4743,6 +4695,13 @@ static int pqi_slave_configure(struct scsi_device *sdev)
 	return 0;
 }
 
+static int pqi_map_queues(struct Scsi_Host *shost)
+{
+	struct pqi_ctrl_info *ctrl_info = shost_to_hba(shost);
+
+	return blk_mq_pci_map_queues(&shost->tag_set, ctrl_info->pci_dev);
+}
+
 static int pqi_getpciinfo_ioctl(struct pqi_ctrl_info *ctrl_info,
 	void __user *arg)
 {
@@ -5130,6 +5089,7 @@ static struct scsi_host_template pqi_driver_template = {
 	.ioctl = pqi_ioctl,
 	.slave_alloc = pqi_slave_alloc,
 	.slave_configure = pqi_slave_configure,
+	.map_queues = pqi_map_queues,
 	.sdev_attrs = pqi_sdev_attrs,
 	.shost_attrs = pqi_shost_attrs,
 };
@@ -5159,7 +5119,7 @@ static int pqi_register_scsi(struct pqi_ctrl_info *ctrl_info)
 	shost->cmd_per_lun = shost->can_queue;
 	shost->sg_tablesize = ctrl_info->sg_tablesize;
 	shost->transportt = pqi_sas_transport_template;
-	shost->irq = ctrl_info->msix_vectors[0];
+	shost->irq = pci_irq_vector(ctrl_info->pci_dev, 0);
 	shost->unique_id = shost->irq;
 	shost->nr_hw_queues = ctrl_info->num_queue_groups;
 	shost->hostdata[0] = (unsigned long)ctrl_info;
@@ -5409,8 +5369,6 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 	if (rc)
 		return rc;
 
-	pqi_irq_set_affinity_hint(ctrl_info);
-
 	rc = pqi_create_queues(ctrl_info);
 	if (rc)
 		return rc;
@@ -5557,10 +5515,14 @@ static inline void pqi_free_ctrl_info(struct pqi_ctrl_info *ctrl_info)
 
 static void pqi_free_interrupts(struct pqi_ctrl_info *ctrl_info)
 {
-	pqi_irq_unset_affinity_hint(ctrl_info);
-	pqi_free_irqs(ctrl_info);
-	if (ctrl_info->num_msix_vectors_enabled)
-		pci_disable_msix(ctrl_info->pci_dev);
+	int i;
+
+	for (i = 0; i < ctrl_info->num_msix_vectors_initialized; i++) {
+		free_irq(pci_irq_vector(ctrl_info->pci_dev, i),
+				&ctrl_info->queue_groups[i]);
+	}
+
+	pci_free_irq_vectors(ctrl_info->pci_dev);
 }
 
 static void pqi_free_ctrl_resources(struct pqi_ctrl_info *ctrl_info)
-- 
2.1.4

