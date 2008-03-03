From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] libata: update port initialisation for SAS call in
Date: Mon, 03 Mar 2008 11:18:24 -0600
Message-ID: <1204564704.3043.28.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>
Cc: Brian King <brking@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

The current port initialisation is skating on thin ice ... it doesn't
fill in the device and link backlinks, and it doesn't add the sdev.
Currently, this is all fine because they're never used, but it's a NULL
deref waiting to happen, so fill them all in.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

----

I need to use this in the following patch to plumb in the queue depth
setting, so I'll take this through the scsi trees with the appropriate
acks.

James

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 0562b0a..f54f87c 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3634,12 +3648,15 @@ EXPORT_SYMBOL_GPL(ata_sas_port_stop);
  *	Zero on success, non-zero on error.
  */
 
-int ata_sas_port_init(struct ata_port *ap)
+int ata_sas_port_init(struct ata_port *ap, struct scsi_device *sdev)
 {
 	int rc = ap->ops->port_start(ap);
 
 	if (!rc) {
 		ap->print_id = ata_print_id++;
+		ap->link.device->sdev = sdev;
+		ap->link.device->link = &ap->link;
+		ap->link.ap = ap;
 		rc = ata_bus_probe(ap);
 	}
 
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index c72014a..cddada2 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -3694,7 +3694,7 @@ static int ipr_ata_slave_alloc(struct scsi_device *sdev)
 	if (sdev->sdev_target)
 		sata_port = sdev->sdev_target->hostdata;
 	if (sata_port)
-		rc = ata_sas_port_init(sata_port->ap);
+		rc = ata_sas_port_init(sata_port->ap, sdev);
 	if (rc)
 		ipr_slave_destroy(sdev);
 
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 601ec5b..2bcc30b 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -1048,7 +1062,7 @@ int sas_slave_alloc(struct scsi_device *scsi_dev)
 	struct domain_device *dev = sdev_to_domain_dev(scsi_dev);
 
 	if (dev_is_sata(dev))
-		return ata_sas_port_init(dev->sata_dev.ap);
+		return ata_sas_port_init(dev->sata_dev.ap, scsi_dev);
 
 	return 0;
 }
diff --git a/include/linux/libata.h b/include/linux/libata.h
index a05f600..14570e7 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -815,7 +815,7 @@ extern int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmn
 extern void ata_sas_port_destroy(struct ata_port *);
 extern struct ata_port *ata_sas_port_alloc(struct ata_host *,
 					   struct ata_port_info *, struct Scsi_Host *);
-extern int ata_sas_port_init(struct ata_port *);
+extern int ata_sas_port_init(struct ata_port *, struct scsi_device *);
 extern int ata_sas_port_start(struct ata_port *ap);
 extern void ata_sas_port_stop(struct ata_port *ap);
 extern int ata_sas_slave_configure(struct scsi_device *, struct ata_port *);


