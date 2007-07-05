From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: [patch 3/4] Enable link power management for ata drivers
Date: Thu, 5 Jul 2007 13:05:30 -0700
Message-ID: <20070705130530.5873afeb.kristen.c.accardi@intel.com>
References: <20070705194909.337398431@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:43233 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762174AbXGEUIt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jul 2007 16:08:49 -0400
In-Reply-To: <20070705194909.337398431@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, James.Bottomley@steeleye.com, edwintorok@gmail.com, axboe@kernel.dk, linux-scsi@vger.kernel.org, Kristen Carlson Accardi <kristen.c.accardi@intel.com>

libata drivers can define a function (enable_pm) that will
perform hardware specific actions to enable whatever power
management policy the user set up from the scsi sysfs 
interface if the driver supports it.  This power management 
policy will be activated after all disks have been 
enumerated and intialized.  Drivers should also define
disable_pm, which will turn off link power management, but
not change link power management policy.

Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Index: 2.6-git/drivers/ata/libata-scsi.c
===================================================================
--- 2.6-git.orig/drivers/ata/libata-scsi.c
+++ 2.6-git/drivers/ata/libata-scsi.c
@@ -2905,6 +2905,51 @@ void ata_scsi_simulate(struct ata_device
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
@@ -2927,7 +2972,7 @@ int ata_scsi_add_hosts(struct ata_host *
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
@@ -298,6 +299,7 @@ enum {
 	ATA_HORKAGE_NODMA	= (1 << 1),	/* DMA problems */
 	ATA_HORKAGE_NONCQ	= (1 << 2),	/* Don't use NCQ */
 	ATA_HORKAGE_MAX_SEC_128	= (1 << 3),	/* Limit max sects to 128 */
+	ATA_HORKAGE_ALPM	= (1 << 4), 	/* ALPM problems */
 };
 
 enum hsm_task_states {
@@ -546,6 +548,7 @@ struct ata_port {
 
 	pm_message_t		pm_mesg;
 	int			*pm_result;
+	enum scsi_host_link_pm	pm_policy;
 
 	void			*private_data;
 
@@ -605,7 +608,8 @@ struct ata_port_operations {
 
 	int (*port_suspend) (struct ata_port *ap, pm_message_t mesg);
 	int (*port_resume) (struct ata_port *ap);
-
+	int (*enable_pm) (struct ata_port *ap, enum scsi_host_link_pm policy);
+	int (*disable_pm) (struct ata_port *ap);
 	int (*port_start) (struct ata_port *ap);
 	void (*port_stop) (struct ata_port *ap);
 
@@ -811,7 +815,7 @@ extern int ata_cable_40wire(struct ata_p
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
@@ -2021,6 +2021,9 @@ int ata_dev_configure(struct ata_device 
 	if (dev->flags & ATA_DFLAG_LBA48)
 		dev->max_sectors = ATA_MAX_SECTORS_LBA48;
 
+	if (ata_id_has_hipm(dev->id) || ata_id_has_dipm(dev->id))
+		dev->flags |= ATA_DFLAG_IPM;
+
 	if (dev->horkage & ATA_HORKAGE_DIAGNOSTIC) {
 		/* Let the user know. We don't want to disallow opens for
 		   rescue purposes, or in case the vendor is just a blithering
@@ -2046,6 +2049,13 @@ int ata_dev_configure(struct ata_device 
 		dev->max_sectors = min_t(unsigned int, ATA_MAX_SECTORS_128,
 					 dev->max_sectors);
 
+	if (ata_device_blacklisted(dev) & ATA_HORKAGE_ALPM) {
+		dev->horkage |= ATA_HORKAGE_ALPM;
+
+		/* reset link pm_policy for this port to no pm */
+		ap->pm_policy = SHOST_MAX_PERFORMANCE;
+	}
+
 	if (ap->ops->dev_config)
 		ap->ops->dev_config(dev);
 
@@ -5807,6 +5817,28 @@ int ata_flush_cache(struct ata_device *d
 	return 0;
 }
 
+static void ata_host_disable_link_pm(struct ata_host *host)
+{
+	int i;
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+		if (ap->ops->disable_pm)
+			ap->ops->disable_pm(ap);
+	}
+}
+
+static void ata_host_enable_link_pm(struct ata_host *host)
+{
+	int i;
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+		ata_scsi_set_link_pm_policy(ap->scsi_host,
+				ap->pm_policy);
+	}
+}
+
 #ifdef CONFIG_PM
 static int ata_host_request_pm(struct ata_host *host, pm_message_t mesg,
 			       unsigned int action, unsigned int ehi_flags,
@@ -5874,6 +5906,12 @@ int ata_host_suspend(struct ata_host *ho
 {
 	int rc;
 
+	/*
+ 	 * disable link pm on all ports before requesting
+ 	 * any pm activity
+ 	 */
+	ata_host_disable_link_pm(host);
+
 	rc = ata_host_request_pm(host, mesg, 0, ATA_EHI_QUIET, 1);
 	if (rc == 0)
 		host->dev->power.power_state = mesg;
@@ -5896,6 +5934,9 @@ void ata_host_resume(struct ata_host *ho
 	ata_host_request_pm(host, PMSG_ON, ATA_EH_SOFTRESET,
 			    ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, 0);
 	host->dev->power.power_state = PMSG_ON;
+
+	/* reenable link pm */
+	ata_host_enable_link_pm(host);
 }
 #endif
 
@@ -6385,6 +6426,8 @@ int ata_host_register(struct ata_host *h
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
@@ -321,6 +321,8 @@ struct ata_taskfile {
 	  ((u64) (id)[(n) + 0]) )
 
 #define ata_id_cdb_intr(id)	(((id)[0] & 0x60) == 0x20)
+#define ata_id_has_hipm(id)	((id)[76] & (1 << 9))
+#define ata_id_has_dipm(id)	((id)[78] & (1 << 3))
 
 static inline unsigned int ata_id_major_version(const u16 *id)
 {

-- 
