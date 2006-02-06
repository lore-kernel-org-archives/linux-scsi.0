From: brking@us.ibm.com
Subject: [patch 10/15] libata: Add support for SATA attachment to SAS adapters
Date: Mon, 06 Feb 2006 09:42:29 -0600
Message-ID: <200602061542.k16FgZjP013245@d03av01.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:61075 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S932170AbWBFPmh
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Feb 2006 10:42:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, brking@us.ibm.com


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

 drivers/scsi/libata-core.c |    4 -
 drivers/scsi/libata-scsi.c |  158 +++++++++++++++++++++++++++++++++++++++++----
 drivers/scsi/libata.h      |    2 
 include/linux/libata.h     |    8 ++
 4 files changed, 157 insertions(+), 15 deletions(-)

diff -puN drivers/scsi/libata-scsi.c~libata_sas drivers/scsi/libata-scsi.c
--- libata-dev/drivers/scsi/libata-scsi.c~libata_sas	2006-02-03 12:42:04.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/libata-scsi.c	2006-02-03 12:42:04.000000000 -0600
@@ -255,22 +255,10 @@ int ata_task_ioctl(struct scsi_device *s
 	return rc;
 }
 
-int ata_scsi_ioctl(struct scsi_device *scsidev, int cmd, void __user *arg)
+int __ata_scsi_ioctl(struct scsi_device *scsidev, int cmd, void __user *arg)
 {
-	struct ata_port *ap;
-	struct ata_device *dev;
 	int val = -EINVAL, rc = -EINVAL;
 
-	ap = (struct ata_port *) &scsidev->host->hostdata[0];
-	if (!ap)
-		goto out;
-
-	dev = ata_scsi_find_dev(ap, scsidev);
-	if (!dev) {
-		rc = -ENODEV;
-		goto out;
-	}
-
 	switch (cmd) {
 	case ATA_IOC_GET_IO32:
 		val = 0;
@@ -299,6 +287,28 @@ int ata_scsi_ioctl(struct scsi_device *s
 		break;
 	}
 
+	return rc;
+}
+EXPORT_SYMBOL_GPL(__ata_scsi_ioctl);
+
+int ata_scsi_ioctl(struct scsi_device *scsidev, int cmd, void __user *arg)
+{
+	struct ata_port *ap;
+	struct ata_device *dev;
+	int rc = -EINVAL;
+
+	ap = (struct ata_port *) &scsidev->host->hostdata[0];
+	if (!ap)
+		goto out;
+
+	dev = ata_scsi_find_dev(ap, scsidev);
+	if (!dev) {
+		rc = -ENODEV;
+		goto out;
+	}
+
+	rc = __ata_scsi_ioctl(scsidev, cmd, arg);
+
 out:
 	return rc;
 }
@@ -2678,3 +2688,125 @@ void ata_scsi_scan_host(struct ata_port 
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
+	return ap;
+}
+EXPORT_SYMBOL_GPL(ata_sas_port_alloc);
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
+	if (unlikely(!ata_dev_present(ap->device))) {
+		cmd->result = (DID_BAD_TARGET << 16);
+		done(cmd);
+		return 0;
+	}
+
+	if (cmd->cmd_len > ap->cdb_len) {
+		cmd->result = (DID_ABORT << 16);
+		done(cmd);
+		return 0;
+	}
+
+	__ata_scsi_queuecmd(cmd, done, ap, ap->device);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ata_sas_queuecmd);
diff -puN drivers/scsi/libata.h~libata_sas drivers/scsi/libata.h
--- libata-dev/drivers/scsi/libata.h~libata_sas	2006-02-03 12:42:04.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/libata.h	2006-02-03 12:42:04.000000000 -0600
@@ -41,6 +41,7 @@ struct ata_scsi_args {
 
 /* libata-core.c */
 extern int atapi_enabled;
+extern unsigned int ata_unique_id;
 extern struct ata_queued_cmd *ata_qc_new_init(struct ata_port *ap,
 				      struct ata_device *dev);
 extern int ata_rwcmd_protocol(struct ata_queued_cmd *qc);
@@ -85,5 +86,6 @@ extern void ata_scsi_set_sense(struct sc
 extern void ata_scsi_rbuf_fill(struct ata_scsi_args *args,
                         unsigned int (*actor) (struct ata_scsi_args *args,
                                            u8 *rbuf, unsigned int buflen));
+extern int ata_bus_probe(struct ata_port *ap);
 
 #endif /* __LIBATA_H__ */
diff -puN include/linux/libata.h~libata_sas include/linux/libata.h
--- libata-dev/include/linux/libata.h~libata_sas	2006-02-03 12:42:04.000000000 -0600
+++ libata-dev-bjking1/include/linux/libata.h	2006-02-03 12:42:04.000000000 -0600
@@ -504,11 +504,19 @@ extern int ata_device_add(const struct a
 extern void ata_host_set_remove(struct ata_host_set *host_set);
 extern int ata_scsi_detect(struct scsi_host_template *sht);
 extern int ata_scsi_ioctl(struct scsi_device *dev, int cmd, void __user *arg);
+extern int __ata_scsi_ioctl(struct scsi_device *dev, int cmd, void __user *arg);
 extern int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *));
 extern int ata_scsi_error(struct Scsi_Host *host);
 extern void ata_eh_qc_complete(struct ata_queued_cmd *qc);
 extern void ata_eh_qc_retry(struct ata_queued_cmd *qc);
 extern int ata_scsi_release(struct Scsi_Host *host);
+extern void ata_sas_port_destroy(struct ata_port *);
+extern struct ata_port *ata_sas_port_alloc(struct pci_dev *,
+					   struct ata_port_info *, struct Scsi_Host *);
+extern int ata_sas_port_init(struct ata_port *);
+extern int ata_sas_slave_configure(struct scsi_device *, struct ata_port *);
+extern int ata_sas_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *),
+			    struct ata_port *ap);
 extern unsigned int ata_host_intr(struct ata_port *ap, struct ata_queued_cmd *qc);
 extern int ata_scsi_device_resume(struct scsi_device *);
 extern int ata_scsi_device_suspend(struct scsi_device *);
diff -puN drivers/scsi/libata-core.c~libata_sas drivers/scsi/libata-core.c
--- libata-dev/drivers/scsi/libata-core.c~libata_sas	2006-02-03 12:42:04.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/libata-core.c	2006-02-03 12:42:04.000000000 -0600
@@ -71,7 +71,7 @@ static int ata_choose_xfer_mode(const st
 				u8 *xfer_mode_out,
 				unsigned int *xfer_shift_out);
 
-static unsigned int ata_unique_id = 1;
+unsigned int ata_unique_id = 1;
 static struct workqueue_struct *ata_wq;
 
 int atapi_enabled = 0;
@@ -1487,7 +1487,7 @@ void ata_dev_config(struct ata_port *ap,
  *	Zero on success, non-zero on error.
  */
 
-static int ata_bus_probe(struct ata_port *ap)
+int ata_bus_probe(struct ata_port *ap)
 {
 	unsigned int i, found = 0;
 
_
