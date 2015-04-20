From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for the 4.0+ merge window
Date: Sun, 19 Apr 2015 22:27:31 -0700
Message-ID: <1429507651.2292.18.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

I'd like to say these were a set of regressions for the recent merge
window code.  Unfortunately, they all predate the merge window code
(stable cc'd).  There's two fixes for data integrity (mostly only
showing up on module removal), an mvsas crash with expander attached
SATA devices which goes back to the dawn of the driver but is only just
being picked up as sas expanders become a standard item in low end
server hardware, an am53c974 one because the interrupt data isn't fully
initialised before the line is and a megaraid_sas one because it uses
smp_processor_id() to select MSI-X queues and that now triggers a
WARN_ON().

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The Short Changelog is

Christoph Hellwig (1):
      megaraid_sas: use raw_smp_processor_id()

Hannes Reinecke (1):
      am53c974: Fix crash during modprobe

James Bottomley (1):
      mvsas: fix panic on expander attached SATA devices

Martin K. Petersen (2):
      sd: Fix missing ATO tag check
      sd: Unregister integrity profile

And the diffstat:

 drivers/scsi/am53c974.c                     | 6 ++++--
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 9 ++++++---
 drivers/scsi/mvsas/mv_sas.c                 | 5 +----
 drivers/scsi/sd.c                           | 1 +
 drivers/scsi/sd_dif.c                       | 2 +-
 5 files changed, 13 insertions(+), 10 deletions(-)

With full diff below.

James

---
diff --git a/drivers/scsi/am53c974.c b/drivers/scsi/am53c974.c
index a6f5ee8..beea30e 100644
--- a/drivers/scsi/am53c974.c
+++ b/drivers/scsi/am53c974.c
@@ -476,6 +476,8 @@ static int pci_esp_probe_one(struct pci_dev *pdev,
 		goto fail_unmap_regs;
 	}
 
+	pci_set_drvdata(pdev, pep);
+
 	err = request_irq(pdev->irq, scsi_esp_intr, IRQF_SHARED,
 			  DRV_MODULE_NAME, esp);
 	if (err < 0) {
@@ -496,8 +498,6 @@ static int pci_esp_probe_one(struct pci_dev *pdev,
 	/* Assume 40MHz clock */
 	esp->cfreq = 40000000;
 
-	pci_set_drvdata(pdev, pep);
-
 	err = scsi_esp_register(esp, &pdev->dev);
 	if (err)
 		goto fail_free_irq;
@@ -507,6 +507,7 @@ static int pci_esp_probe_one(struct pci_dev *pdev,
 fail_free_irq:
 	free_irq(pdev->irq, esp);
 fail_unmap_command_block:
+	pci_set_drvdata(pdev, NULL);
 	pci_free_consistent(pdev, 16, esp->command_block,
 			    esp->command_block_dma);
 fail_unmap_regs:
@@ -530,6 +531,7 @@ static void pci_esp_remove_one(struct pci_dev *pdev)
 
 	scsi_esp_unregister(esp);
 	free_irq(pdev->irq, esp);
+	pci_set_drvdata(pdev, NULL);
 	pci_free_consistent(pdev, 16, esp->command_block,
 			    esp->command_block_dma);
 	pci_iounmap(pdev, esp->regs);
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 675b5e7..5a0800d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1584,11 +1584,11 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 			fp_possible = io_info.fpOkForIo;
 	}
 
-	/* Use smp_processor_id() for now until cmd->request->cpu is CPU
+	/* Use raw_smp_processor_id() for now until cmd->request->cpu is CPU
 	   id by default, not CPU group id, otherwise all MSI-X queues won't
 	   be utilized */
 	cmd->request_desc->SCSIIO.MSIxIndex = instance->msix_vectors ?
-		smp_processor_id() % instance->msix_vectors : 0;
+		raw_smp_processor_id() % instance->msix_vectors : 0;
 
 	if (fp_possible) {
 		megasas_set_pd_lba(io_request, scp->cmd_len, &io_info, scp,
@@ -1693,7 +1693,10 @@ megasas_build_dcdb_fusion(struct megasas_instance *instance,
 			<< MR_RAID_CTX_RAID_FLAGS_IO_SUB_TYPE_SHIFT;
 		cmd->request_desc->SCSIIO.DevHandle = io_request->DevHandle;
 		cmd->request_desc->SCSIIO.MSIxIndex =
-			instance->msix_vectors ? smp_processor_id() % instance->msix_vectors : 0;
+			instance->msix_vectors ?
+				raw_smp_processor_id() %
+					instance->msix_vectors :
+				0;
 		os_timeout_value = scmd->request->timeout / HZ;
 
 		if (instance->secure_jbod_support &&
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 2d5ab6d..454536c 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -441,14 +441,11 @@ static u32 mvs_get_ncq_tag(struct sas_task *task, u32 *tag)
 static int mvs_task_prep_ata(struct mvs_info *mvi,
 			     struct mvs_task_exec_info *tei)
 {
-	struct sas_ha_struct *sha = mvi->sas;
 	struct sas_task *task = tei->task;
 	struct domain_device *dev = task->dev;
 	struct mvs_device *mvi_dev = dev->lldd_dev;
 	struct mvs_cmd_hdr *hdr = tei->hdr;
 	struct asd_sas_port *sas_port = dev->port;
-	struct sas_phy *sphy = dev->phy;
-	struct asd_sas_phy *sas_phy = sha->sas_phy[sphy->number];
 	struct mvs_slot_info *slot;
 	void *buf_prd;
 	u32 tag = tei->tag, hdr_tag;
@@ -468,7 +465,7 @@ static int mvs_task_prep_ata(struct mvs_info *mvi,
 	slot->tx = mvi->tx_prod;
 	del_q = TXQ_MODE_I | tag |
 		(TXQ_CMD_STP << TXQ_CMD_SHIFT) |
-		(MVS_PHY_ID << TXQ_PHY_SHIFT) |
+		((sas_port->phy_mask & TXQ_PHY_MASK) << TXQ_PHY_SHIFT) |
 		(mvi_dev->taskfileset << TXQ_SRS_SHIFT);
 	mvi->tx[mvi->tx_prod] = cpu_to_le32(del_q);
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index dcc4244..79beebf 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3076,6 +3076,7 @@ static void scsi_disk_release(struct device *dev)
 	ida_remove(&sd_index_ida, sdkp->index);
 	spin_unlock(&sd_index_lock);
 
+	blk_integrity_unregister(disk);
 	disk->private_data = NULL;
 	put_disk(disk);
 	put_device(&sdkp->device->sdev_gendev);
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 14c7d42..5c06d29 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -77,7 +77,7 @@ void sd_dif_config_host(struct scsi_disk *sdkp)
 
 		disk->integrity->flags |= BLK_INTEGRITY_DEVICE_CAPABLE;
 
-		if (!sdkp)
+		if (!sdkp->ATO)
 			return;
 
 		if (type == SD_DIF_TYPE3_PROTECTION)
