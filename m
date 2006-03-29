From: Brian King <brking@us.ibm.com>
Subject: [PATCH 04/10] libata: Add support for SATA attachment to SAS adapters
Date: Wed, 29 Mar 2006 08:38:12 -0600
Message-ID: <200603291438.k2TEcCGk006192@d01av02.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60061 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751141AbWC2Oia (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Mar 2006 09:38:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com, brking@us.ibm.com


The following patch enhances libata to allow SAS device drivers
to utilize libata to talk to SATA devices. It introduces some
new APIs which allow libata to be used without allocating a
virtual scsi host.

New APIs:

ata_sas_port_alloc - Allocate an ata_port 
ata_sas_port_init - Initialize an ata_port (probe device, etc)
ata_sas_port_destroy - Free an ata_port allocated by ata_sas_port_alloc
ata_sas_slave_configure - configure scsi device
ata_sas_queuecmd - queue a scsi command, similar to ata_scsi_queuecomand

These new APIs can be used either directly by a SAS LLDD or could be used
by the SAS transport class. 

Possible usage for a SAS LLDD would be:

scsi_scan_host
	target_alloc
		ata_sas_port_alloc
	slave_alloc
		ata_sas_port_init
	slave_configure
		ata_sas_slave_configure

Commands received by the LLDD for SATA devices would call ata_sas_queuecmd.

Device teardown would occur with:

slave_destroy
	port_disable
target_destroy
	ata_sas_port_destroy

Signed-off-by: Brian King <brking@us.ibm.com>
---

 libata-dev-bjking1/drivers/scsi/libata-core.c |    4 
 libata-dev-bjking1/drivers/scsi/libata-scsi.c |  162 ++++++++++++++++++++++++++
 libata-dev-bjking1/drivers/scsi/libata.h      |    2 
 libata-dev-bjking1/include/linux/libata.h     |    9 +
 4 files changed, 175 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/libata-scsi.c~libata_sas drivers/scsi/libata-scsi.c
--- libata-dev/drivers/scsi/libata-scsi.c~libata_sas	2006-03-29 08:18:37.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/libata-scsi.c	2006-03-29 08:18:37.000000000 -0600
@@ -2752,3 +2752,165 @@ void ata_scsi_scan_host(struct ata_port 
 	}
 }
 
+/**
+ *	ata_sas_port_alloc - Allocate port for a SAS attached SATA device
+ *	@pdev: PCI device that the scsi device is attached to
+ *	@port_info: Information from low-level host driver
+ *	@host: SCSI host that the scsi device is attached to
+ *
+ *	LOCKING:
+ *	PCI/etc. bus probe sem.
+ *
+ *	RETURNS:
+ *	ata_port pointer on success / NULL on failure.
+ */
+
+struct ata_port *ata_sas_port_alloc(struct pci_dev *pdev,
+				    struct ata_port_info *port_info,
+				    struct Scsi_Host *host)
+{
+	struct ata_port *ap = kzalloc(sizeof(*ap), GFP_KERNEL);
+	int i;
+
+	if (!ap)
+		return NULL;
+
+	ap->dev = &pdev->dev;
+	ap->id = ata_unique_id++;
+	ap->lock = host->host_lock;
+	ap->ops = port_info->port_ops;
+	ap->flags = port_info->host_flags;
+	ap->pio_mask = port_info->pio_mask;
+	ap->mwdma_mask = port_info->mwdma_mask;
+	ap->udma_mask = port_info->udma_mask;
+	ap->cbl = ATA_CBL_SATA;
+	ap->active_tag = ATA_TAG_POISON;
+	ap->last_ctl = 0xFF;
+	INIT_LIST_HEAD(&ap->eh_done_q);
+
+	for (i = 0; i < ATA_MAX_DEVICES; i++) {
+		struct ata_device *dev = &ap->device[i];
+		dev->devno = i;
+		dev->pio_mask = UINT_MAX;
+		dev->mwdma_mask = UINT_MAX;
+		dev->udma_mask = UINT_MAX;
+	}
+
+	return ap;
+}
+EXPORT_SYMBOL_GPL(ata_sas_port_alloc);
+
+/**
+ *	ata_sas_port_start - Set port up for dma.
+ *	@ap: Port to initialize
+ *
+ *	Called just after data structures for each port are
+ *	initialized.  Allocates DMA pad.
+ *
+ *	May be used as the port_start() entry in ata_port_operations.
+ *
+ *	LOCKING:
+ *	Inherited from caller.
+ */
+int ata_sas_port_start(struct ata_port *ap)
+{
+	return ata_pad_alloc(ap, ap->dev);
+}
+EXPORT_SYMBOL_GPL(ata_sas_port_start);
+
+/**
+ *	ata_port_stop - Undo ata_sas_port_start()
+ *	@ap: Port to shut down
+ *
+ *	Frees the DMA pad.
+ *
+ *	May be used as the port_stop() entry in ata_port_operations.
+ *
+ *	LOCKING:
+ *	Inherited from caller.
+ */
+
+void ata_sas_port_stop(struct ata_port *ap)
+{
+	ata_pad_free(ap, ap->dev);
+}
+EXPORT_SYMBOL_GPL(ata_sas_port_stop);
+
+/**
+ *	ata_sas_port_init - Initialize a SATA device
+ *	@ap: SATA port to initialize
+ *
+ *	LOCKING:
+ *	PCI/etc. bus probe sem.
+ *
+ *	RETURNS:
+ *	Zero on success, non-zero on error.
+ */
+
+int ata_sas_port_init(struct ata_port *ap)
+{
+	int rc = ap->ops->port_start(ap);
+
+	if (!rc)
+		rc = ata_bus_probe(ap);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(ata_sas_port_init);
+
+/**
+ *	ata_sas_port_destroy - Destroy a SATA port allocated by ata_sas_port_alloc
+ *	@ap: SATA port to destroy
+ *
+ */
+
+void ata_sas_port_destroy(struct ata_port *ap)
+{
+	ap->ops->port_stop(ap);
+	kfree(ap);
+}
+EXPORT_SYMBOL_GPL(ata_sas_port_destroy);
+
+/**
+ *	ata_sas_slave_configure - Default slave_config routine for libata devices
+ *	@sdev: SCSI device to configure
+ *	@ap: ATA port to which SCSI device is attached
+ *
+ *	RETURNS:
+ *	Zero.
+ */
+
+int ata_sas_slave_configure(struct scsi_device *sdev, struct ata_port *ap)
+{
+	ata_scsi_sdev_config(sdev);
+	ata_scsi_dev_config(sdev, ap->device);
+	if (!ata_id_is_sata(ap->device->id))
+		blk_queue_max_sectors(sdev->request_queue, ATA_MAX_SECTORS);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ata_sas_slave_configure);
+
+/**
+ *	ata_sas_queuecmd - Issue SCSI cdb to libata-managed device
+ *	@cmd: SCSI command to be sent
+ *	@done: Completion function, called when command is complete
+ *	@ap:	ATA port to which the command is being sent
+ *
+ *	RETURNS:
+ *	Zero.
+ */
+
+int ata_sas_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *),
+		     struct ata_port *ap)
+{
+	ata_scsi_dump_cdb(ap, cmd);
+
+	if (likely(ata_dev_present(ap->device)))
+		__ata_scsi_queuecmd(cmd, done, ap, ap->device);
+	else {
+		cmd->result = (DID_BAD_TARGET << 16);
+		done(cmd);
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ata_sas_queuecmd);
diff -puN drivers/scsi/libata.h~libata_sas drivers/scsi/libata.h
--- libata-dev/drivers/scsi/libata.h~libata_sas	2006-03-29 08:18:37.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/libata.h	2006-03-29 08:18:37.000000000 -0600
@@ -42,6 +42,7 @@ struct ata_scsi_args {
 /* libata-core.c */
 extern int atapi_enabled;
 extern int libata_fua;
+extern unsigned int ata_unique_id;
 extern struct ata_queued_cmd *ata_qc_new_init(struct ata_port *ap,
 				      struct ata_device *dev);
 extern int ata_rwcmd_protocol(struct ata_queued_cmd *qc);
@@ -89,5 +90,6 @@ extern void ata_scsi_set_sense(struct sc
 extern void ata_scsi_rbuf_fill(struct ata_scsi_args *args,
                         unsigned int (*actor) (struct ata_scsi_args *args,
                                            u8 *rbuf, unsigned int buflen));
+extern int ata_bus_probe(struct ata_port *ap);
 
 #endif /* __LIBATA_H__ */
diff -puN include/linux/libata.h~libata_sas include/linux/libata.h
--- libata-dev/include/linux/libata.h~libata_sas	2006-03-29 08:18:37.000000000 -0600
+++ libata-dev-bjking1/include/linux/libata.h	2006-03-29 08:18:37.000000000 -0600
@@ -519,6 +519,15 @@ extern int ata_scsi_error(struct Scsi_Ho
 extern void ata_eh_qc_complete(struct ata_queued_cmd *qc);
 extern void ata_eh_qc_retry(struct ata_queued_cmd *qc);
 extern int ata_scsi_release(struct Scsi_Host *host);
+extern void ata_sas_port_destroy(struct ata_port *);
+extern struct ata_port *ata_sas_port_alloc(struct pci_dev *,
+					   struct ata_port_info *, struct Scsi_Host *);
+extern int ata_sas_port_init(struct ata_port *);
+extern int ata_sas_port_start(struct ata_port *ap);
+extern void ata_sas_port_stop(struct ata_port *ap);
+extern int ata_sas_slave_configure(struct scsi_device *, struct ata_port *);
+extern int ata_sas_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *),
+			    struct ata_port *ap);
 extern unsigned int ata_host_intr(struct ata_port *ap, struct ata_queued_cmd *qc);
 extern int ata_scsi_device_resume(struct scsi_device *);
 extern int ata_scsi_device_suspend(struct scsi_device *, pm_message_t state);
diff -puN drivers/scsi/libata-core.c~libata_sas drivers/scsi/libata-core.c
--- libata-dev/drivers/scsi/libata-core.c~libata_sas	2006-03-29 08:18:37.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/libata-core.c	2006-03-29 08:18:37.000000000 -0600
@@ -68,7 +68,7 @@ static unsigned int ata_dev_set_xfermode
 					 struct ata_device *dev);
 static void ata_dev_xfermask(struct ata_port *ap, struct ata_device *dev);
 
-static unsigned int ata_unique_id = 1;
+unsigned int ata_unique_id = 1;
 static struct workqueue_struct *ata_wq;
 
 int atapi_enabled = 1;
@@ -1354,7 +1354,7 @@ err_out_nosup:
  *	Zero on success, non-zero on error.
  */
 
-static int ata_bus_probe(struct ata_port *ap)
+int ata_bus_probe(struct ata_port *ap)
 {
 	unsigned int classes[ATA_MAX_DEVICES];
 	unsigned int i, rc, found = 0;
_
