From: Brian King <brking@us.ibm.com>
Subject: [PATCH 4/4] libata: Add support for SATA attachment to SAS adapters
Date: Mon, 07 Aug 2006 14:27:31 -0500
Message-ID: <200608071927.k77JRV4s018202@d03av04.boulder.ibm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, brking@us.ibm.com
List-Id: linux-scsi@vger.kernel.org


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

 libata-dev-bjking1/drivers/scsi/libata-core.c |    2 
 libata-dev-bjking1/drivers/scsi/libata-scsi.c |  149 ++++++++++++++++++++++++++
 libata-dev-bjking1/drivers/scsi/libata.h      |    1 
 libata-dev-bjking1/include/linux/libata.h     |    9 +
 4 files changed, 160 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/libata-scsi.c~libata_sas drivers/scsi/libata-scsi.c
--- libata-dev/drivers/scsi/libata-scsi.c~libata_sas	2006-08-07 12:41:10.000000000 -0500
+++ libata-dev-bjking1/drivers/scsi/libata-scsi.c	2006-08-07 12:41:27.000000000 -0500
@@ -3158,3 +3158,152 @@ void ata_scsi_dev_rescan(void *data)
 			scsi_rescan_device(&(dev->sdev->sdev_gendev));
 	}
 }
+
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
+struct ata_port *ata_sas_port_alloc(struct ata_host_set *host_set,
+				    struct ata_port_info *port_info,
+				    struct Scsi_Host *host)
+{
+	struct ata_port *ap = kzalloc(sizeof(*ap), GFP_KERNEL);
+	struct ata_probe_ent *ent;
+
+	if (!ap)
+		return NULL;
+
+	ent = ata_probe_ent_alloc(host_set->dev, port_info);
+	if (!ent) {
+		kfree(ap);
+		return NULL;
+	}
+
+	ata_port_init(ap, host_set, ent, 0);
+	ap->lock = host->host_lock;
+	kfree(ent);
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
+	if (likely(ata_scsi_dev_enabled(ap->device)))
+		__ata_scsi_queuecmd(cmd, done, ap->device);
+	else {
+		cmd->result = (DID_BAD_TARGET << 16);
+		done(cmd);
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ata_sas_queuecmd);
diff -puN drivers/scsi/libata.h~libata_sas drivers/scsi/libata.h
--- libata-dev/drivers/scsi/libata.h~libata_sas	2006-08-07 12:41:10.000000000 -0500
+++ libata-dev-bjking1/drivers/scsi/libata.h	2006-08-07 12:42:18.000000000 -0500
@@ -111,6 +111,7 @@ extern void ata_scsi_rbuf_fill(struct at
                                            u8 *rbuf, unsigned int buflen));
 extern void ata_schedule_scsi_eh(struct Scsi_Host *shost);
 extern void ata_scsi_dev_rescan(void *data);
+extern int ata_bus_probe(struct ata_port *ap);
 
 /* libata-eh.c */
 extern enum scsi_eh_timer_return ata_scsi_timed_out(struct scsi_cmnd *cmd);
diff -puN include/linux/libata.h~libata_sas include/linux/libata.h
--- libata-dev/include/linux/libata.h~libata_sas	2006-08-07 12:41:10.000000000 -0500
+++ libata-dev-bjking1/include/linux/libata.h	2006-08-07 12:41:11.000000000 -0500
@@ -691,6 +691,15 @@ extern int ata_scsi_detect(struct scsi_h
 extern int ata_scsi_ioctl(struct scsi_device *dev, int cmd, void __user *arg);
 extern int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *));
 extern int ata_scsi_release(struct Scsi_Host *host);
+extern void ata_sas_port_destroy(struct ata_port *);
+extern struct ata_port *ata_sas_port_alloc(struct ata_host_set *,
+					   struct ata_port_info *, struct Scsi_Host *);
+extern int ata_sas_port_init(struct ata_port *);
+extern int ata_sas_port_start(struct ata_port *ap);
+extern void ata_sas_port_stop(struct ata_port *ap);
+extern int ata_sas_slave_configure(struct scsi_device *, struct ata_port *);
+extern int ata_sas_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *),
+			    struct ata_port *ap);
 extern unsigned int ata_host_intr(struct ata_port *ap, struct ata_queued_cmd *qc);
 extern int sata_scr_valid(struct ata_port *ap);
 extern int sata_scr_read(struct ata_port *ap, int reg, u32 *val);
diff -puN drivers/scsi/libata-core.c~libata_sas drivers/scsi/libata-core.c
--- libata-dev/drivers/scsi/libata-core.c~libata_sas	2006-08-07 12:41:10.000000000 -0500
+++ libata-dev-bjking1/drivers/scsi/libata-core.c	2006-08-07 12:42:01.000000000 -0500
@@ -1528,7 +1528,7 @@ err_out_nosup:
  *	Zero on success, negative errno otherwise.
  */
 
-static int ata_bus_probe(struct ata_port *ap)
+int ata_bus_probe(struct ata_port *ap)
 {
 	unsigned int classes[ATA_MAX_DEVICES];
 	int tries[ATA_MAX_DEVICES];
_
