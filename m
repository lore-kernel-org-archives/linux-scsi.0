From: Gwendal Grignou <gwendal@google.com>
Subject: [PATCH 3/3] libata: Change transport topology layout
Date: Wed,  3 Oct 2012 17:49:49 -0700
Message-ID: <1349311789-9952-1-git-send-email-gwendal@google.com>
References: <20120928063820.GA19771@aaronlu.sh.intel.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120928063820.GA19771@aaronlu.sh.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: aaron.lu@intel.com, tj@kernel.org, jgarzik@pobox.com, james.bottomley@hansenpartnership.com
Cc: Gwendal Grignou <gwendal@google.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Integrate ata objects [port, link, device] with scsi objects.

Before [2.6.x]

The path of a scsi device is:
.../0000:00:1f.2/host0/port1/link1/dev1.0/target0:0:0/0:0:0:0

or when a port multiplier is present: for instance the device in port 4 of the
port multiplier:
.../0000:00:06.0/0000:09:00.0/host5/port6/link6.4/dev6.4.0/target5:4:0/5:4:0:0

Fix ACPI code that relied on previous topology. 


Signed-off-by: Gwendal Grignou <gwendal@google.com>
---
 drivers/ata/libata-acpi.c      |   11 ++++++++---
 drivers/ata/libata-core.c      |   13 ++++++-------
 drivers/ata/libata-scsi.c      |    4 ++--
 drivers/ata/libata-transport.c |   10 +++++++++-
 4 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index fd9ecf7..8e7f451 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -1065,7 +1065,7 @@ void ata_acpi_unbind(struct ata_device *dev)
 
 static int compat_pci_ata(struct ata_port *ap)
 {
-	struct device *dev = ap->tdev.parent;
+	struct device *dev = ap->host->dev;
 	struct pci_dev *pdev;
 
 	if (!is_pci_dev(dev))
@@ -1085,7 +1085,7 @@ static int ata_acpi_bind_host(struct ata_port *ap, acpi_handle *handle)
 	if (ap->flags & ATA_FLAG_ACPI_SATA)
 		return -ENODEV;
 
-	*handle = acpi_get_child(DEVICE_ACPI_HANDLE(ap->tdev.parent),
+	*handle = acpi_get_child(DEVICE_ACPI_HANDLE(ap->host->dev),
 			ap->port_no);
 
 	if (!*handle)
@@ -1150,7 +1150,12 @@ static struct ata_port *dev_to_ata_port(struct device *dev)
 
 static int ata_acpi_find_device(struct device *dev, acpi_handle *handle)
 {
-	struct ata_port *ap = dev_to_ata_port(dev);
+	struct ata_port *ap;
+
+	if (scsi_is_host_device(dev))
+		ap = ata_shost_to_port(dev_to_shost(dev));
+	else
+		ap = dev_to_ata_port(dev);
 
 	if (!ap)
 		return -ENODEV;
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 611050d..c83590b 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6063,19 +6063,18 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 	for (i = 0; i < host->n_ports; i++)
 		host->ports[i]->print_id = atomic_inc_return(&ata_print_id);
 
+	rc = ata_scsi_add_hosts(host, sht);
+	if (rc)
+		return rc;
 
 	/* Create associated sysfs transport objects  */
 	for (i = 0; i < host->n_ports; i++) {
-		rc = ata_tport_add(host->dev,host->ports[i]);
-		if (rc) {
+		struct ata_port *ap = host->ports[i];
+		rc = ata_tport_add(&ap->scsi_host->shost_gendev, ap);
+		if (rc)
 			goto err_tadd;
-		}
 	}
 
-	rc = ata_scsi_add_hosts(host, sht);
-	if (rc)
-		goto err_tadd;
-
 	/* set cable, sata_spd_limit and report */
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index bfda61f..9023bb1 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3649,8 +3649,8 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
 			else
 				channel = link->pmp;
 
-			sdev = __scsi_add_device(&ap->scsi_host->shost_gendev,
-						 channel, id, 0, NULL);
+			sdev = __scsi_add_device(&dev->tdev, channel, id, 0,
+						 NULL);
 			if (!IS_ERR(sdev)) {
 				dev->sdev = sdev;
 				scsi_device_put(sdev);
diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
index c04d393..ce91bd2 100644
--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -284,7 +284,7 @@ int ata_tport_add(struct device *parent,
 
 	dev->parent = get_device(parent);
 	dev->release = ata_tport_release;
-	dev_set_name(dev, "ata%d", ap->print_id);
+	dev_set_name(dev, "port%d", ap->print_id);
 	transport_setup_device(dev);
 	error = device_add(dev);
 	if (error) {
@@ -421,6 +421,10 @@ int ata_tlink_add(struct ata_link *link)
 		goto tlink_err;
 	}
 
+	pm_runtime_no_callbacks(dev);
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+
 	transport_add_device(dev);
 	transport_configure_device(dev);
 
@@ -649,6 +653,10 @@ static int ata_tdev_add(struct ata_device *ata_dev)
 		return error;
 	}
 
+	pm_runtime_no_callbacks(dev);
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+
 	transport_add_device(dev);
 	transport_configure_device(dev);
 	return 0;
-- 
1.7.7.3

