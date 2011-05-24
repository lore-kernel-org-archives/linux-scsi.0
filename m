From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 4/4] libsas: Add option for SATA soft reset
Date: Tue, 24 May 2011 13:18:04 -0700
Message-ID: <20110524201804.7351.6720.stgit@localhost6.localdomain6>
References: <20110524201708.7351.76421.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:22132 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747Ab1EXT4B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2011 15:56:01 -0400
In-Reply-To: <20110524201708.7351.76421.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: Dave Jiang <dave.jiang@intel.com>, linux-scsi@vger.kernel.org, jeffrey.d.skirvin@intel.com, jacek.danecki@intel.com, linux-ide@vger.kernel.org, edmund.nadolski@intel.com

From: Dave Jiang <dave.jiang@intel.com>

This allows a libsas driver to optionally provide a soft reset handler
for libata to drive.  The isci driver allows software to control the
assertion/deassertion of SRST.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_ata.c |   41 ++++++++++++++++++++++++++++++++++++++++-
 include/scsi/libsas.h         |    1 +
 2 files changed, 41 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 31fc21f..d6706c5 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -279,6 +279,45 @@ static int sas_ata_hard_reset(struct ata_link *link, unsigned int *class,
 	return ret;
 }
 
+static int sas_ata_soft_reset(struct ata_link *link, unsigned int *class,
+			       unsigned long deadline)
+{
+	struct ata_port *ap = link->ap;
+	struct domain_device *dev = ap->private_data;
+	struct sas_internal *i =
+		to_sas_internal(dev->port->ha->core.shost->transportt);
+	int res = TMF_RESP_FUNC_FAILED;
+	int ret = 0;
+
+	if (i->dft->lldd_ata_soft_reset)
+		res = i->dft->lldd_ata_soft_reset(dev);
+
+	if (res != TMF_RESP_FUNC_COMPLETE) {
+		SAS_DPRINTK("%s: Unable to soft reset\n", __func__);
+		ret = -EAGAIN;
+	}
+
+	switch (dev->sata_dev.command_set) {
+		case ATA_COMMAND_SET:
+			SAS_DPRINTK("%s: Found ATA device.\n", __func__);
+			*class = ATA_DEV_ATA;
+			break;
+		case ATAPI_COMMAND_SET:
+			SAS_DPRINTK("%s: Found ATAPI device.\n", __func__);
+			*class = ATA_DEV_ATAPI;
+			break;
+		default:
+			SAS_DPRINTK("%s: Unknown SATA command set: %d.\n",
+				    __func__,
+				    dev->sata_dev.command_set);
+			*class = ATA_DEV_UNKNOWN;
+			break;
+	}
+
+	ap->cbl = ATA_CBL_SATA;
+	return ret;
+}
+
 static void sas_ata_post_internal(struct ata_queued_cmd *qc)
 {
 	if (qc->flags & ATA_QCFLAG_FAILED)
@@ -309,7 +348,7 @@ static void sas_ata_post_internal(struct ata_queued_cmd *qc)
 
 static struct ata_port_operations sas_sata_ops = {
 	.prereset		= ata_std_prereset,
-	.softreset		= NULL,
+	.softreset		= sas_ata_soft_reset,
 	.hardreset		= sas_ata_hard_reset,
 	.postreset		= ata_std_postreset,
 	.error_handler		= ata_std_error_handler,
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index d603b26e..b3418f4 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -617,6 +617,7 @@ struct sas_domain_function_template {
 	int (*lldd_clear_aca)(struct domain_device *, u8 *lun);
 	int (*lldd_clear_task_set)(struct domain_device *, u8 *lun);
 	int (*lldd_I_T_nexus_reset)(struct domain_device *);
+	int (*lldd_ata_soft_reset)(struct domain_device *);
 	int (*lldd_lu_reset)(struct domain_device *, u8 *lun);
 	int (*lldd_query_task)(struct sas_task *);
 

