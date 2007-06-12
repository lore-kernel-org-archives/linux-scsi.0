From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [patch 2b/3] Expose Power Management Policy option to users
Date: Tue, 12 Jun 2007 10:47:12 -0700
Message-ID: <20070612104712.59a71529.kristen.c.accardi@intel.com>
References: <20070611184146.448266229@intel.com>
	<20070611114820.5290a903.kristen.c.accardi@intel.com>
	<466DA9DD.8080004@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32679 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755280AbXFLRuj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jun 2007 13:50:39 -0400
In-Reply-To: <466DA9DD.8080004@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: james.bottomley@steeleye.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, htejun@gmail.com

Enable link power management for ata drivers

libata drivers can define a function (enable_pm) that will
perform hardware specific actions to enable whatever power
management policy the user set up from the scsi sysfs 
interface if the driver supports it.  This power management 
policy will be activated after all disks have been 
enumerated and intialized.

Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Index: 2.6-git/drivers/ata/libata-scsi.c
===================================================================
--- 2.6-git.orig/drivers/ata/libata-scsi.c
+++ 2.6-git/drivers/ata/libata-scsi.c
@@ -2890,6 +2890,51 @@ void ata_scsi_simulate(struct ata_device
 	}
 }
 
+int ata_scsi_set_link_pm_policy(struct Scsi_Host *shost,
+		enum scsi_host_link_pm policy)
+{
+	struct ata_port *ap = ata_shost_to_port(shost);
+	int rc = -EINVAL;
+	int i;
+
+	/*
+ 	 * make sure no broken devices are on this port,
+ 	 * and that all devices support interface power
+ 	 * management
+ 	 */
+	for (i = 0; i < ATA_MAX_DEVICES; i++) {
+		struct ata_device *dev = &ap->device[i];
+
+		/* only check drives which exist */
+		if (!ata_dev_enabled(dev))
+			continue;
+
+		/*
+ 		 * do we need to handle the case where we've hotplugged
+ 		 * a broken drive (since hotplug and ALPM are mutually
+ 		 * exclusive) ?
+ 		 *
+ 		 * If so, if we detect a broken drive on a port with
+ 		 * alpm already enabled, then we should reset the policy
+ 		 * to off for the entire port.
+ 		 */
+		if ((dev->horkage & ATA_HORKAGE_ALPM) ||
+			!(dev->flags & ATA_DFLAG_IPM)) {
+			ata_dev_printk(dev, KERN_ERR,
+				"Unable to set Link PM policy\n");
+			ap->pm_policy = SHOST_MAX_PERFORMANCE;
+		}
+	}
+
+	if (ap->ops->enable_pm)
+		rc = ap->ops->enable_pm(ap, policy);
+
+	if (!rc)
+		shost->shost_link_pm_policy = ap->pm_policy;
+	return rc;
+}
+EXPORT_SYMBOL_GPL(ata_scsi_set_link_pm_policy);
+
 int ata_scsi_add_hosts(struct ata_host *host, struct scsi_host_template *sht)
 {
 	int i, rc;
@@ -2912,7 +2957,7 @@ int ata_scsi_add_hosts(struct ata_host *
 		shost->max_lun = 1;
 		shost->max_channel = 1;
 		shost->max_cmd_len = 16;
-
+		shost->shost_link_pm_policy = ap->pm_policy;
 		rc = scsi_add_host(ap->scsi_host, ap->host->dev);
 		if (rc)
 			goto err_add;
Index: 2.6-git/include/linux/libata.h
===================================================================
--- 2.6-git.orig/include/linux/libata.h
+++ 2.6-git/include/linux/libata.h
@@ -136,6 +136,7 @@ enum {
 	ATA_DFLAG_CDB_INTR	= (1 << 2), /* device asserts INTRQ when ready for CDB */
 	ATA_DFLAG_NCQ		= (1 << 3), /* device supports NCQ */
 	ATA_DFLAG_FLUSH_EXT	= (1 << 4), /* do FLUSH_EXT instead of FLUSH */
+	ATA_DFLAG_IPM		= (1 << 6), /* device supports interface PM */
 	ATA_DFLAG_CFG_MASK	= (1 << 8) - 1,
 
 	ATA_DFLAG_PIO		= (1 << 8), /* device limited to PIO mode */
@@ -300,6 +301,7 @@ enum {
 	ATA_HORKAGE_NONCQ	= (1 << 2),	/* Don't use NCQ */
 	ATA_HORKAGE_MAX_SEC_128	= (1 << 3),	/* Limit max sects to 128 */
 	ATA_HORKAGE_DMA_RW_ONLY	= (1 << 4),	/* ATAPI DMA for RW only */
+	ATA_HORKAGE_ALPM	= (1 << 5), 	/* ALPM problems */
 };
 
 enum hsm_task_states {
@@ -548,6 +550,7 @@ struct ata_port {
 
 	pm_message_t		pm_mesg;
 	int			*pm_result;
+	enum scsi_host_link_pm	pm_policy;
 
 	void			*private_data;
 
@@ -607,7 +610,7 @@ struct ata_port_operations {
 
 	int (*port_suspend) (struct ata_port *ap, pm_message_t mesg);
 	int (*port_resume) (struct ata_port *ap);
-
+	int (*enable_pm) (struct ata_port *ap, enum scsi_host_link_pm policy);
 	int (*port_start) (struct ata_port *ap);
 	void (*port_stop) (struct ata_port *ap);
 
@@ -812,7 +815,7 @@ extern int ata_cable_40wire(struct ata_p
 extern int ata_cable_80wire(struct ata_port *ap);
 extern int ata_cable_sata(struct ata_port *ap);
 extern int ata_cable_unknown(struct ata_port *ap);
-
+extern int ata_scsi_set_link_pm_policy(struct Scsi_Host *shost, enum scsi_host_link_pm);
 /*
  * Timing helpers
  */
Index: 2.6-git/drivers/ata/libata-core.c
===================================================================
--- 2.6-git.orig/drivers/ata/libata-core.c
+++ 2.6-git/drivers/ata/libata-core.c
@@ -2019,6 +2019,9 @@ int ata_dev_configure(struct ata_device 
 	if (dev->flags & ATA_DFLAG_LBA48)
 		dev->max_sectors = ATA_MAX_SECTORS_LBA48;
 
+	if (ata_id_has_hipm(dev->id))
+		dev->flags |= ATA_DFLAG_IPM;
+
 	if (dev->horkage & ATA_HORKAGE_DIAGNOSTIC) {
 		/* Let the user know. We don't want to disallow opens for
 		   rescue purposes, or in case the vendor is just a blithering
@@ -2048,6 +2051,13 @@ int ata_dev_configure(struct ata_device 
 	if (ata_device_blacklisted(dev) & ATA_HORKAGE_DMA_RW_ONLY)
 		dev->horkage |= ATA_HORKAGE_DMA_RW_ONLY;
 
+	if (ata_device_blacklisted(dev) & ATA_HORKAGE_ALPM) {
+		dev->horkage |= ATA_HORKAGE_ALPM;
+
+		/* reset link pm_policy for this port to no pm */
+		ap->pm_policy = SHOST_MAX_PERFORMANCE;
+	}
+
 	if (ap->ops->dev_config)
 		ap->ops->dev_config(dev);
 
@@ -6394,6 +6404,8 @@ int ata_host_register(struct ata_host *h
 		struct ata_port *ap = host->ports[i];
 
 		ata_scsi_scan_host(ap);
+		ata_scsi_set_link_pm_policy(ap->scsi_host,
+				ap->pm_policy);
 	}
 
 	return 0;
Index: 2.6-git/include/linux/ata.h
===================================================================
--- 2.6-git.orig/include/linux/ata.h
+++ 2.6-git/include/linux/ata.h
@@ -320,6 +320,8 @@ struct ata_taskfile {
 	  ((u64) (id)[(n) + 0]) )
 
 #define ata_id_cdb_intr(id)	(((id)[0] & 0x60) == 0x20)
+#define ata_id_has_hipm(id)	((id)[76] & (1 << 9))
+#define ata_id_has_dipm(id)	((id)[78] & (1 << 3))
 
 static inline unsigned int ata_id_major_version(const u16 *id)
 {
