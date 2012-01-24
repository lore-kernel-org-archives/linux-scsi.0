From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v7 6/6] libsas: revert ata srst
Date: Mon, 23 Jan 2012 23:50:45 -0800
Message-ID: <20120124075045.22384.23228.stgit@localhost6.localdomain6>
References: <20120124074825.22384.17157.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120124074825.22384.17157.stgit@localhost6.localdomain6>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

libata issues follow up srsts when the controller has a hard time
recording the signature-fis after a reset, or if the link supports port
multipliers.  libsas does not support port multipliers and no current
libsas lldds appear to need help retrieving the signature fis.  Revert
it for now to remove confusion.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_ata.c |   38 --------------------------------------
 include/scsi/libsas.h         |    1 -
 2 files changed, 0 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index f82997a..653aa97 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -443,43 +443,6 @@ static int sas_ata_hard_reset(struct ata_link *link, unsigned int *class,
 	return ret;
 }
 
-static int sas_ata_soft_reset(struct ata_link *link, unsigned int *class,
-			       unsigned long deadline)
-{
-	struct ata_port *ap = link->ap;
-	struct domain_device *dev = ap->private_data;
-	struct sas_internal *i = dev_to_sas_internal(dev);
-	int res = TMF_RESP_FUNC_FAILED;
-	int ret = 0;
-
-	if (i->dft->lldd_ata_soft_reset)
-		res = i->dft->lldd_ata_soft_reset(dev);
-
-	if (res != TMF_RESP_FUNC_COMPLETE) {
-		SAS_DPRINTK("%s: Unable to soft reset\n", __func__);
-		ret = -EAGAIN;
-	}
-
-	switch (dev->sata_dev.command_set) {
-	case ATA_COMMAND_SET:
-		SAS_DPRINTK("%s: Found ATA device.\n", __func__);
-		*class = ATA_DEV_ATA;
-		break;
-	case ATAPI_COMMAND_SET:
-		SAS_DPRINTK("%s: Found ATAPI device.\n", __func__);
-		*class = ATA_DEV_ATAPI;
-		break;
-	default:
-		SAS_DPRINTK("%s: Unknown SATA command set: %d.\n",
-			    __func__, dev->sata_dev.command_set);
-		*class = ATA_DEV_UNKNOWN;
-		break;
-	}
-
-	ap->cbl = ATA_CBL_SATA;
-	return ret;
-}
-
 /*
  * notify the lldd to forget the sas_task for this internal ata command
  * that bypasses scsi-eh
@@ -563,7 +526,6 @@ static void sas_ata_set_dmamode(struct ata_port *ap, struct ata_device *ata_dev)
 
 static struct ata_port_operations sas_sata_ops = {
 	.prereset		= ata_std_prereset,
-	.softreset		= sas_ata_soft_reset,
 	.hardreset		= sas_ata_hard_reset,
 	.postreset		= ata_std_postreset,
 	.error_handler		= ata_std_error_handler,
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 20153d5..5f5ed1b 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -619,7 +619,6 @@ struct sas_domain_function_template {
 	int (*lldd_clear_aca)(struct domain_device *, u8 *lun);
 	int (*lldd_clear_task_set)(struct domain_device *, u8 *lun);
 	int (*lldd_I_T_nexus_reset)(struct domain_device *);
-	int (*lldd_ata_soft_reset)(struct domain_device *);
 	int (*lldd_ata_check_ready)(struct domain_device *);
 	void (*lldd_ata_set_dmamode)(struct domain_device *);
 	int (*lldd_lu_reset)(struct domain_device *, u8 *lun);

