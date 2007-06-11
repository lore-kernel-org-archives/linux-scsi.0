From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: [patch 2/3] Expose Power Management Policy option to users
Date: Mon, 11 Jun 2007 11:48:20 -0700
Message-ID: <20070611114820.5290a903.kristen.c.accardi@intel.com>
References: <20070611184146.448266229@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:41737 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756836AbXFKSvw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Jun 2007 14:51:52 -0400
In-Reply-To: <20070611184146.448266229@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org, james.bottomley@steeleye.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, htejun@gmail.com, Kristen Carlson Accardi <kristen.c.accardi@intel.com>

This patch will modify the scsi and ata subsystem to allow
users to set a power management policy for the link.
libata drivers can define a function (enable_pm) that will
perform hardware specific actions to enable whatever power
management policy the user sets up if the driver supports
it.  This power management policy will be activated after
all disks have been enumerated and intialized.

The scsi subsystem will create a new sysfs file for each
host in /sys/class/scsi_host called "link_power_management_policy".
This file can have 3 possible values:

Value		Meaning
-------------------------------------------------------------------
min_power	User wishes the link to conserve power as much as
		possible, even at the cost of some performance

max_performance User wants priority to be on performance, not power
		savings

medium_power	User wants power savings, with less performance cost
		than min_power (but less power savings as well).


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
Index: 2.6-git/drivers/scsi/hosts.c
===================================================================
--- 2.6-git.orig/drivers/scsi/hosts.c
+++ 2.6-git/drivers/scsi/hosts.c
@@ -54,6 +54,25 @@ static struct class shost_class = {
 };
 
 /**
+ *	scsi_host_set_link_pm - Change the link power management policy
+ *	@shost:	scsi host to change the policy of.
+ *	@policy:	policy to change to.
+ *
+ *	Returns zero if successful or an error if the requested
+ *	transition is illegal.
+ **/
+int scsi_host_set_link_pm(struct Scsi_Host *shost,
+		enum scsi_host_link_pm policy)
+{
+	struct scsi_host_template *sht = shost->hostt;
+	if (sht->set_link_pm_policy)
+		sht->set_link_pm_policy(shost, policy);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(scsi_host_set_link_pm);
+
+/**
  *	scsi_host_set_state - Take the given host through the host
  *		state model.
  *	@shost:	scsi host to change the state of.
Index: 2.6-git/drivers/scsi/scsi_sysfs.c
===================================================================
--- 2.6-git.orig/drivers/scsi/scsi_sysfs.c
+++ 2.6-git/drivers/scsi/scsi_sysfs.c
@@ -189,6 +189,74 @@ show_shost_state(struct class_device *cl
 
 static CLASS_DEVICE_ATTR(state, S_IRUGO | S_IWUSR, show_shost_state, store_shost_state);
 
+static const struct {
+	enum scsi_host_link_pm	value;
+	char			*name;
+} shost_link_pm_policy[] = {
+	{ SHOST_NOT_AVAILABLE, "max_performance" },
+	{ SHOST_MIN_POWER, "min_power" },
+	{ SHOST_MAX_PERFORMANCE, "max_performance" },
+	{ SHOST_MEDIUM_POWER, "medium_power" },
+};
+
+const char *scsi_host_link_pm_policy(enum scsi_host_link_pm policy)
+{
+	int i;
+	char *name = NULL;
+
+	for (i = 0; i < ARRAY_SIZE(shost_link_pm_policy); i++) {
+		if (shost_link_pm_policy[i].value == policy) {
+			name = shost_link_pm_policy[i].name;
+			break;
+		}
+	}
+	return name;
+}
+
+static ssize_t store_link_pm_policy(struct class_device *class_dev,
+	const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(class_dev);
+	enum scsi_host_link_pm policy = 0;
+	int i;
+
+	/*
+ 	 * we are skipping array location 0 on purpose - this
+ 	 * is because a value of SHOST_NOT_AVAILABLE is displayed
+ 	 * to the user as max_performance, but when the user
+ 	 * writes "max_performance", they actually want the
+ 	 * value to match SHOST_MAX_PERFORMANCE.
+ 	 */
+	for (i = 1; i < ARRAY_SIZE(shost_link_pm_policy); i++) {
+		const int len = strlen(shost_link_pm_policy[i].name);
+		if (strncmp(shost_link_pm_policy[i].name, buf, len) == 0 &&
+		   buf[len] == '\n') {
+			policy = shost_link_pm_policy[i].value;
+			break;
+		}
+	}
+	if (!policy)
+		return -EINVAL;
+
+	if (scsi_host_set_link_pm(shost, policy))
+		return -EINVAL;
+	return count;
+}
+static ssize_t
+show_link_pm_policy(struct class_device *class_dev, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(class_dev);
+	const char *policy =
+		scsi_host_link_pm_policy(shost->shost_link_pm_policy);
+
+	if (!policy)
+		return -EINVAL;
+
+	return snprintf(buf, 23, "%s\n", policy);
+}
+static CLASS_DEVICE_ATTR(link_power_management_policy, S_IRUGO | S_IWUSR,
+		show_link_pm_policy, store_link_pm_policy);
+
 shost_rd_attr(unique_id, "%u\n");
 shost_rd_attr(host_busy, "%hu\n");
 shost_rd_attr(cmd_per_lun, "%hd\n");
@@ -207,6 +275,7 @@ static struct class_device_attribute *sc
 	&class_device_attr_proc_name,
 	&class_device_attr_scan,
 	&class_device_attr_state,
+	&class_device_attr_link_power_management_policy,
 	NULL
 };
 
Index: 2.6-git/include/scsi/scsi_host.h
===================================================================
--- 2.6-git.orig/include/scsi/scsi_host.h
+++ 2.6-git/include/scsi/scsi_host.h
@@ -42,6 +42,16 @@ enum scsi_eh_timer_return {
 	EH_RESET_TIMER,
 };
 
+/*
+ * shost pm policy: If you alter this, you also need to alter scsi_sysfs.c
+ * (for the ascii descriptions)
+ */
+enum scsi_host_link_pm {
+	SHOST_NOT_AVAILABLE,
+	SHOST_MIN_POWER,
+	SHOST_MAX_PERFORMANCE,
+	SHOST_MEDIUM_POWER,
+};
 
 struct scsi_host_template {
 	struct module *module;
@@ -345,6 +355,12 @@ struct scsi_host_template {
 	int (*suspend)(struct scsi_device *, pm_message_t state);
 
 	/*
+ 	 * link power management support
+ 	 */
+	int (*set_link_pm_policy)(struct Scsi_Host *, enum scsi_host_link_pm);
+	enum scsi_host_link_pm default_link_pm_policy;
+
+	/*
 	 * Name of proc directory
 	 */
 	char *proc_name;
@@ -642,6 +658,7 @@ struct Scsi_Host {
 	
 
 	enum scsi_host_state shost_state;
+	enum scsi_host_link_pm shost_link_pm_policy;
 
 	/* ldm bits */
 	struct device		shost_gendev;
@@ -749,4 +766,5 @@ extern struct Scsi_Host *scsi_register(s
 extern void scsi_unregister(struct Scsi_Host *);
 extern int scsi_host_set_state(struct Scsi_Host *, enum scsi_host_state);
 
+extern int scsi_host_set_link_pm(struct Scsi_Host *, enum scsi_host_link_pm);
 #endif /* _SCSI_SCSI_HOST_H */
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
@@ -299,6 +300,7 @@ enum {
 	ATA_HORKAGE_NONCQ	= (1 << 2),	/* Don't use NCQ */
 	ATA_HORKAGE_MAX_SEC_128	= (1 << 3),	/* Limit max sects to 128 */
 	ATA_HORKAGE_DMA_RW_ONLY	= (1 << 4),	/* ATAPI DMA for RW only */
+	ATA_HORKAGE_ALPM	= (1 << 5), 	/* ALPM problems */
 };
 
 enum hsm_task_states {
@@ -547,6 +549,7 @@ struct ata_port {
 
 	pm_message_t		pm_mesg;
 	int			*pm_result;
+	enum scsi_host_link_pm	pm_policy;
 
 	void			*private_data;
 
@@ -606,7 +609,7 @@ struct ata_port_operations {
 
 	int (*port_suspend) (struct ata_port *ap, pm_message_t mesg);
 	int (*port_resume) (struct ata_port *ap);
-
+	int (*enable_pm) (struct ata_port *ap, enum scsi_host_link_pm policy);
 	int (*port_start) (struct ata_port *ap);
 	void (*port_stop) (struct ata_port *ap);
 
@@ -811,7 +814,7 @@ extern int ata_cable_40wire(struct ata_p
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
 
@@ -6389,6 +6399,8 @@ int ata_host_register(struct ata_host *h
 		struct ata_port *ap = host->ports[i];
 
 		ata_scsi_scan_host(ap);
+		ata_scsi_set_link_pm_policy(ap->scsi_host,
+				ap->pm_policy);
 	}
 
 	return 0;
Index: 2.6-git/Documentation/scsi/link_power_management_policy.txt
===================================================================
--- /dev/null
+++ 2.6-git/Documentation/scsi/link_power_management_policy.txt
@@ -0,0 +1,19 @@
+This parameter allows the user to set the link (interface) power management.
+There are 3 possible options:
+
+Value			Effect
+----------------------------------------------------------------------------
+min_power		Tell the controller to try to make the link use the
+			least possible power when possible.  This may
+			sacrifice some performance due to increased latency
+			when coming out of lower power states.
+
+max_performance		Generally, this means no power management.  Tell
+			the controller to have performance be a priority
+			over power management.
+
+medium_power		Tell the controller to enter a lower power state
+			when possible, but do not enter the lowest power
+			state, thus improving latency over min_power setting.
+
+
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

-- 
