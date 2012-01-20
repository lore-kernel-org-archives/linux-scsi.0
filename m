From: Matthew Garrett <mjg@redhat.com>
Subject: [PATCHv2 3/8] libata: Migrate ACPI code over to new bindings
Date: Fri, 20 Jan 2012 01:18:49 +0100
Message-ID: <20120120001848.GD27706@homac.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-acpi-owner@vger.kernel.org
To: linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Garzik <jgarzik@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Now that we have the ability to directly glue the ACPI namespace to the
driver model in libata, we don't need the custom code to handle the same
thing. Remove it and migrate the functions over to the new code.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Holger Macht <holger@homac.de>
---
 drivers/ata/libata-acpi.c |  166 +++++++++++----------------------------------
 drivers/ata/libata-core.c |    3 -
 drivers/ata/libata-pmp.c  |    4 -
 drivers/ata/libata.h      |    5 --
 drivers/ata/pata_acpi.c   |    4 +-
 include/linux/libata.h    |    7 +--
 6 files changed, 45 insertions(+), 144 deletions(-)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 0a23f94..3a7771d 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -47,14 +47,29 @@ static void ata_acpi_clear_gtf(struct ata_device *dev)
 	dev->gtf_cache = NULL;
 }
 
-static acpi_handle ap_acpi_handle(struct ata_port *ap)
+/**
+ * ata_ap_acpi_handle - provide the acpi_handle for an ata_port
+ * @ap: the acpi_handle returned will correspond to this port
+ *
+ * Returns the acpi_handle for the ACPI namespace object corresponding to
+ * the ata_port passed into the function, or NULL if no such object exists
+ */
+acpi_handle ata_ap_acpi_handle(struct ata_port *ap)
 {
 	if (ap->flags & ATA_FLAG_ACPI_SATA)
 		return NULL;
 	return DEVICE_ACPI_HANDLE(&ap->scsi_host->shost_gendev);
 }
+EXPORT_SYMBOL(ata_ap_acpi_handle);
 
-static acpi_handle dev_acpi_handle(struct ata_device *dev)
+/**
+ * ata_dev_acpi_handle - provide the acpi_handle for an ata_device
+ * @dev: the acpi_device returned will correspond to this port
+ *
+ * Returns the acpi_handle for the ACPI namespace object corresponding to
+ * the ata_device passed into the function, or NULL if no such object exists
+ */
+acpi_handle ata_dev_acpi_handle(struct ata_device *dev)
 {
 	acpi_integer adr;
 	struct ata_port *ap = dev->link->ap;
@@ -69,66 +84,9 @@ static acpi_handle dev_acpi_handle(struct ata_device *dev)
 			adr = SATA_ADR(ap->port_no, dev->link->pmp);
 		return acpi_get_child(DEVICE_ACPI_HANDLE(ap->host->dev), adr);
 	} else
-		return acpi_get_child(ap_acpi_handle(ap), dev->devno);
-}
-
-/**
- * ata_acpi_associate_sata_port - associate SATA port with ACPI objects
- * @ap: target SATA port
- *
- * Look up ACPI objects associated with @ap and initialize acpi_handle
- * fields of @ap, the port and devices accordingly.
- *
- * LOCKING:
- * EH context.
- *
- * RETURNS:
- * 0 on success, -errno on failure.
- */
-void ata_acpi_associate_sata_port(struct ata_port *ap)
-{
-	WARN_ON(!(ap->flags & ATA_FLAG_ACPI_SATA));
-
-	if (!sata_pmp_attached(ap)) {
-		u64 adr = SATA_ADR(ap->port_no, NO_PORT_MULT);
-
-		ap->link.device->acpi_handle =
-			acpi_get_child(ap->host->acpi_handle, adr);
-	} else {
-		struct ata_link *link;
-
-		ap->link.device->acpi_handle = NULL;
-
-		ata_for_each_link(link, ap, EDGE) {
-			u64 adr = SATA_ADR(ap->port_no, link->pmp);
-
-			link->device->acpi_handle =
-				acpi_get_child(ap->host->acpi_handle, adr);
-		}
-	}
-}
-
-static void ata_acpi_associate_ide_port(struct ata_port *ap)
-{
-	int max_devices, i;
-
-	ap->acpi_handle = acpi_get_child(ap->host->acpi_handle, ap->port_no);
-	if (!ap->acpi_handle)
-		return;
-
-	max_devices = 1;
-	if (ap->flags & ATA_FLAG_SLAVE_POSS)
-		max_devices++;
-
-	for (i = 0; i < max_devices; i++) {
-		struct ata_device *dev = &ap->link.device[i];
-
-		dev->acpi_handle = acpi_get_child(ap->acpi_handle, i);
-	}
-
-	if (ata_acpi_gtm(ap, &ap->__acpi_init_gtm) == 0)
-		ap->pflags |= ATA_PFLAG_INIT_GTM_VALID;
+		return acpi_get_child(ata_ap_acpi_handle(ap), dev->devno);
 }
+EXPORT_SYMBOL(ata_dev_acpi_handle);
 
 /* @ap and @dev are the same as ata_acpi_handle_hotplug() */
 static void ata_acpi_detach_device(struct ata_port *ap, struct ata_device *dev)
@@ -254,56 +212,6 @@ static const struct acpi_dock_ops ata_acpi_ap_dock_ops = {
 };
 
 /**
- * ata_acpi_associate - associate ATA host with ACPI objects
- * @host: target ATA host
- *
- * Look up ACPI objects associated with @host and initialize
- * acpi_handle fields of @host, its ports and devices accordingly.
- *
- * LOCKING:
- * EH context.
- *
- * RETURNS:
- * 0 on success, -errno on failure.
- */
-void ata_acpi_associate(struct ata_host *host)
-{
-	int i, j;
-
-	if (!is_pci_dev(host->dev) || libata_noacpi)
-		return;
-
-	host->acpi_handle = DEVICE_ACPI_HANDLE(host->dev);
-	if (!host->acpi_handle)
-		return;
-
-	for (i = 0; i < host->n_ports; i++) {
-		struct ata_port *ap = host->ports[i];
-
-		if (host->ports[0]->flags & ATA_FLAG_ACPI_SATA)
-			ata_acpi_associate_sata_port(ap);
-		else
-			ata_acpi_associate_ide_port(ap);
-
-		if (ap->acpi_handle) {
-			/* we might be on a docking station */
-			register_hotplug_dock_device(ap->acpi_handle,
-					     &ata_acpi_ap_dock_ops, ap);
-		}
-
-		for (j = 0; j < ata_link_max_devices(&ap->link); j++) {
-			struct ata_device *dev = &ap->link.device[j];
-
-			if (dev->acpi_handle) {
-				/* we might be on a docking station */
-				register_hotplug_dock_device(dev->acpi_handle,
-					     &ata_acpi_dev_dock_ops, dev);
-			}
-		}
-	}
-}
-
-/**
  * ata_acpi_dissociate - dissociate ATA host from ACPI objects
  * @host: target ATA host
  *
@@ -324,7 +232,7 @@ void ata_acpi_dissociate(struct ata_host *host)
 		struct ata_port *ap = host->ports[i];
 		const struct ata_acpi_gtm *gtm = ata_acpi_init_gtm(ap);
 
-		if (ap->acpi_handle && gtm)
+		if (ata_ap_acpi_handle(ap) && gtm)
 			ata_acpi_stm(ap, gtm);
 	}
 }
@@ -349,7 +257,8 @@ int ata_acpi_gtm(struct ata_port *ap, struct ata_acpi_gtm *gtm)
 	acpi_status status;
 	int rc = 0;
 
-	status = acpi_evaluate_object(ap->acpi_handle, "_GTM", NULL, &output);
+	status = acpi_evaluate_object(ata_ap_acpi_handle(ap), "_GTM", NULL,
+				      &output);
 
 	rc = -ENOENT;
 	if (status == AE_NOT_FOUND)
@@ -419,7 +328,8 @@ int ata_acpi_stm(struct ata_port *ap, const struct ata_acpi_gtm *stm)
 	input.count = 3;
 	input.pointer = in_params;
 
-	status = acpi_evaluate_object(ap->acpi_handle, "_STM", &input, NULL);
+	status = acpi_evaluate_object(ata_ap_acpi_handle(ap), "_STM", &input,
+				      NULL);
 
 	if (status == AE_NOT_FOUND)
 		return -ENOENT;
@@ -476,7 +386,8 @@ static int ata_dev_get_GTF(struct ata_device *dev, struct ata_acpi_gtf **gtf)
 			    __func__, ap->port_no);
 
 	/* _GTF has no input parameters */
-	status = acpi_evaluate_object(dev->acpi_handle, "_GTF", NULL, &output);
+	status = acpi_evaluate_object(ata_dev_acpi_handle(dev), "_GTF", NULL,
+				      &output);
 	out_obj = dev->gtf_cache = output.pointer;
 
 	if (ACPI_FAILURE(status)) {
@@ -842,7 +753,8 @@ static int ata_acpi_push_id(struct ata_device *dev)
 
 	/* It's OK for _SDD to be missing too. */
 	swap_buf_le16(dev->id, ATA_ID_WORDS);
-	status = acpi_evaluate_object(dev->acpi_handle, "_SDD", &input, NULL);
+	status = acpi_evaluate_object(ata_dev_acpi_handle(dev), "_SDD", &input,
+				      NULL);
 	swap_buf_le16(dev->id, ATA_ID_WORDS);
 
 	if (status == AE_NOT_FOUND)
@@ -892,7 +804,7 @@ void ata_acpi_on_resume(struct ata_port *ap)
 	const struct ata_acpi_gtm *gtm = ata_acpi_init_gtm(ap);
 	struct ata_device *dev;
 
-	if (ap->acpi_handle && gtm) {
+	if (ata_ap_acpi_handle(ap) && gtm) {
 		/* _GTM valid */
 
 		/* restore timing parameters */
@@ -933,22 +845,22 @@ void ata_acpi_set_state(struct ata_port *ap, pm_message_t state)
 {
 	struct ata_device *dev;
 
-	if (!ap->acpi_handle || (ap->flags & ATA_FLAG_ACPI_SATA))
+	if (!ata_ap_acpi_handle(ap) || (ap->flags & ATA_FLAG_ACPI_SATA))
 		return;
 
 	/* channel first and then drives for power on and vica versa
 	   for power off */
 	if (state.event == PM_EVENT_ON)
-		acpi_bus_set_power(ap->acpi_handle, ACPI_STATE_D0);
+		acpi_bus_set_power(ata_ap_acpi_handle(ap), ACPI_STATE_D0);
 
 	ata_for_each_dev(dev, &ap->link, ENABLED) {
-		if (dev->acpi_handle)
-			acpi_bus_set_power(dev->acpi_handle,
+		if (ata_dev_acpi_handle(dev))
+			acpi_bus_set_power(ata_dev_acpi_handle(dev),
 				state.event == PM_EVENT_ON ?
 					ACPI_STATE_D0 : ACPI_STATE_D3);
 	}
 	if (state.event != PM_EVENT_ON)
-		acpi_bus_set_power(ap->acpi_handle, ACPI_STATE_D3);
+		acpi_bus_set_power(ata_ap_acpi_handle(ap), ACPI_STATE_D3);
 }
 
 /**
@@ -973,7 +885,7 @@ int ata_acpi_on_devcfg(struct ata_device *dev)
 	int nr_executed = 0;
 	int rc;
 
-	if (!dev->acpi_handle)
+	if (!ata_dev_acpi_handle(dev))
 		return 0;
 
 	/* do we need to do _GTF? */
@@ -1019,7 +931,6 @@ int ata_acpi_on_devcfg(struct ata_device *dev)
 	}
 
 	ata_dev_warn(dev, "ACPI: failed the second time, disabled\n");
-	dev->acpi_handle = NULL;
 
 	/* We can safely continue if no _GTF command has been executed
 	 * and port is not frozen.
@@ -1073,6 +984,9 @@ static int ata_acpi_bind_host(struct device *dev, int host, acpi_handle *handle)
 	if (!*handle)
 		return -ENODEV;
 
+	register_hotplug_dock_device(ata_ap_acpi_handle(ap),
+				     &ata_acpi_ap_dock_ops, ap);
+
 	return 0;
 }
 
@@ -1089,10 +1003,12 @@ static int ata_acpi_bind_device(struct device *dev, int channel, int id,
 	else
 		ata_dev = &ap->link.device[id];
 
-	*handle = dev_acpi_handle(ata_dev);
+	*handle = ata_dev_acpi_handle(ata_dev);
 
 	if (!*handle)
 		return -ENODEV;
+	register_hotplug_dock_device(ata_dev_acpi_handle(ata_dev),
+				     &ata_acpi_dev_dock_ops, ata_dev);
 
 	return 0;
 }
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 2339faf..6742cc4 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6042,9 +6042,6 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 	if (rc)
 		goto err_tadd;
 
-	/* associate with ACPI nodes */
-	ata_acpi_associate(host);
-
 	/* set cable, sata_spd_limit and report */
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
index 21b80c5..61c59ee 100644
--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -529,8 +529,6 @@ int sata_pmp_attach(struct ata_device *dev)
 	ata_for_each_link(tlink, ap, EDGE)
 		sata_link_init_spd(tlink);
 
-	ata_acpi_associate_sata_port(ap);
-
 	return 0;
 
  fail:
@@ -570,8 +568,6 @@ static void sata_pmp_detach(struct ata_device *dev)
 	ap->nr_pmp_links = 0;
 	link->pmp = 0;
 	spin_unlock_irqrestore(ap->lock, flags);
-
-	ata_acpi_associate_sata_port(ap);
 }
 
 /**
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 3c5de9e..ddf0c7b 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -109,9 +109,6 @@ extern int ata_port_probe(struct ata_port *ap);
 /* libata-acpi.c */
 #ifdef CONFIG_ATA_ACPI
 extern unsigned int ata_acpi_gtf_filter;
-
-extern void ata_acpi_associate_sata_port(struct ata_port *ap);
-extern void ata_acpi_associate(struct ata_host *host);
 extern void ata_acpi_dissociate(struct ata_host *host);
 extern int ata_acpi_on_suspend(struct ata_port *ap);
 extern void ata_acpi_on_resume(struct ata_port *ap);
@@ -121,8 +118,6 @@ extern void ata_acpi_set_state(struct ata_port *ap, pm_message_t state);
 extern int ata_acpi_register(void);
 extern void ata_acpi_unregister(void);
 #else
-static inline void ata_acpi_associate_sata_port(struct ata_port *ap) { }
-static inline void ata_acpi_associate(struct ata_host *host) { }
 static inline void ata_acpi_dissociate(struct ata_host *host) { }
 static inline int ata_acpi_on_suspend(struct ata_port *ap) { return 0; }
 static inline void ata_acpi_on_resume(struct ata_port *ap) { }
diff --git a/drivers/ata/pata_acpi.c b/drivers/ata/pata_acpi.c
index 54145ed..b63ca3b 100644
--- a/drivers/ata/pata_acpi.c
+++ b/drivers/ata/pata_acpi.c
@@ -39,7 +39,7 @@ static int pacpi_pre_reset(struct ata_link *link, unsigned long deadline)
 {
 	struct ata_port *ap = link->ap;
 	struct pata_acpi *acpi = ap->private_data;
-	if (ap->acpi_handle == NULL || ata_acpi_gtm(ap, &acpi->gtm) < 0)
+	if (ata_ap_acpi_handle(ap) == NULL || ata_acpi_gtm(ap, &acpi->gtm) < 0)
 		return -ENODEV;
 
 	return ata_sff_prereset(link, deadline);
@@ -195,7 +195,7 @@ static int pacpi_port_start(struct ata_port *ap)
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	struct pata_acpi *acpi;
 
-	if (ap->acpi_handle == NULL)
+	if (ata_ap_acpi_handle(ap) == NULL)
 		return -ENODEV;
 
 	acpi = ap->private_data = devm_kzalloc(&pdev->dev, sizeof(struct pata_acpi), GFP_KERNEL);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index cafc09a..36970c6 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -544,9 +544,6 @@ struct ata_host {
 	struct mutex		eh_mutex;
 	struct task_struct	*eh_owner;
 
-#ifdef CONFIG_ATA_ACPI
-	acpi_handle		acpi_handle;
-#endif
 	struct ata_port		*simplex_claimed;	/* channel owning the DMA */
 	struct ata_port		*ports[0];
 };
@@ -614,7 +611,6 @@ struct ata_device {
 	struct scsi_device	*sdev;		/* attached SCSI device */
 	void			*private_data;
 #ifdef CONFIG_ATA_ACPI
-	acpi_handle		acpi_handle;
 	union acpi_object	*gtf_cache;
 	unsigned int		gtf_filter;
 #endif
@@ -796,7 +792,6 @@ struct ata_port {
 	void			*private_data;
 
 #ifdef CONFIG_ATA_ACPI
-	acpi_handle		acpi_handle;
 	struct ata_acpi_gtm	__acpi_init_gtm; /* use ata_acpi_init_gtm() */
 #endif
 	/* owned by EH */
@@ -1111,6 +1106,8 @@ int ata_acpi_stm(struct ata_port *ap, const struct ata_acpi_gtm *stm);
 int ata_acpi_gtm(struct ata_port *ap, struct ata_acpi_gtm *stm);
 unsigned long ata_acpi_gtm_xfermask(struct ata_device *dev,
 				    const struct ata_acpi_gtm *gtm);
+acpi_handle ata_ap_acpi_handle(struct ata_port *ap);
+acpi_handle ata_dev_acpi_handle(struct ata_device *dev);
 int ata_acpi_cbl_80wire(struct ata_port *ap, const struct ata_acpi_gtm *gtm);
 #else
 static inline const struct ata_acpi_gtm *ata_acpi_init_gtm(struct ata_port *ap)
-- 
1.7.8

