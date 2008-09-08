From: "Gwendal Grignou" <gwendal@google.com>
Subject: [PATCH #upstream-fixes] libata: Add transport class for libata in sysfs
Date: Sun, 7 Sep 2008 17:55:06 -0700
Message-ID: <e7510f760809071755y78e06e00l680972e08288bb0b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org, jgarzik@pobox.com
List-Id: linux-scsi@vger.kernel.org

Hello,

I resend this patch with resources error handling fixes.
The code is heavily inspired from libsas, libata-transport.c has the
same skeleton as libsas-transport.c.
I follow libata objects life cycle, which means that sysfs attributes
are created when the host hba are initialized, not when the ATA
devices are found.
I verify it works weither CONFIG_SYSFS_DEPRECATED_V2 is set or not.

Gwendal.
---
From: Gwendal Grignou <gwendal@google.com>
Date: Sun, 31 Aug 2008 22:50:16 -0700
Subject: Add transport class for libata.

This patch adds objects for accessing libata objects from user space:
- ata_port class: one per ATA port
- ata_link class: one per ATA port or 15 for SATA Port Multiplier
- ata_device class: up to 2 for PATA link, usually one for SATA.

Each object exports information from the corresponding data strucure.
For instance, ata_device exports id, the cached identify output if
the device is a disk, gscr register output if it is a PM.

More fields can be added later, like error counters and ATA specific
statistics.

Signed-off-by: Gwendal Grignou <gwendal@google.com>
---
 Documentation/ABI/testing/sysfs-ata |   87 +++++
 drivers/ata/Makefile                |    2 +-
 drivers/ata/libata-core.c           |   42 ++-
 drivers/ata/libata-pmp.c            |   16 +-
 drivers/ata/libata-scsi.c           |   21 +-
 drivers/ata/libata-transport.c      |  720 +++++++++++++++++++++++++++++++++++
 drivers/ata/libata-transport.h      |   18 +
 drivers/ata/libata.h                |    4 +
 include/linux/libata.h              |   12 +-
 9 files changed, 896 insertions(+), 26 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-ata
 create mode 100644 drivers/ata/libata-transport.c
 create mode 100644 drivers/ata/libata-transport.h

diff --git a/Documentation/ABI/testing/sysfs-ata
b/Documentation/ABI/testing/sysfs-ata
new file mode 100644
index 0000000..0133bc3
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-ata
@@ -0,0 +1,87 @@
+What:		/sys/class/ata_...
+Date:		August 2008
+Contact:	Gwendal Grignou<gwendal@google.com>
+Description:
+
+Provide a place in sysfs for storing the ATA topology of the system.
This allows
+retrieving various information about ATA objects.
+
+Files under /sys/class/ata_port
+-------------------------------
+
+	For each port, a directory ataX is created where X is the ata_port_id of
+	the port. The device parent is the ata host device.
+
+idle_irq (read)
+
+	Number of IRQ received by the port while idle [some ata HBA only]
+
+nr_pmp_links (read)
+
+	If a SATA Port Multiplier (PM) is connected, number of link behind it.
+
+Files under /sys/class/ata_link
+-------------------------------
+
+	Behind each port, there is a ata_link. If there is a SATA PM in the
+	topology, 15 ata_link objects are created.
+
+	If a link is behind a port, the directory name is linkX, where X is
+	ata_port_id of the port.
+	If a link is behind a PM, its name is linkX.Y where X is ata_port_id
+	of the parent port and Y the PM port.
+
+hw_sata_spd_limit
+
+	Maximum speed supported by the connected SATA device
+
+sata_spd_limit
+
+	Maximum speed imposed by libata
+
+sata_spd
+
+	Current speed of the link [1.5, 3Gps,...]
+
+Files under /sys/class/ata_device
+---------------------------------
+
+	Behind each link, up to two ata device are created.
+	The name of the directory is devX[.Y].Z where:
+	- X is ata_port_id of the port where the device is connected,
+	- Y the port of the PM if any, and
+	- Z the device id: for PATA, there is usually 2 devices [0,1],
+	only 1 for SATA.
+
+class
+	Device class. Can be "ata" for disk, "atapi" for packet device,
+	"pmp" for PM, or "none" if no device was found behind the link.
+
+dma_mode
+
+	Transfer modes supported by the device when in DMA mode.
+	Mostly used by PATA device
+
+pio_mode
+
+	Transfer modes supported by the device when in PIO mode.
+	Mostly used by PATA device
+
+xfer_mode
+
+	Current transfer mode
+
+id
+
+	Cached result of IDENTIFY command, as described in ATA8 7.16 and 7.17.
+	Only valid if the device is not a PM
+
+gscr
+
+	Cached result of the dump of PM GSCR register.
+	Valid registers are 0, 1, 2, 32, 33, 64 and 96
+	Only valid if the device is a PM
+
+spdn_cnt
+
+	Number of time libata decided to lower the speed of link due to errors.
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 674965f..17746a9 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -79,7 +79,7 @@ obj-$(CONFIG_ATA_GENERIC)	+= ata_generic.o
 # Should be last libata driver
 obj-$(CONFIG_PATA_LEGACY)	+= pata_legacy.o

-libata-objs	:= libata-core.o libata-scsi.o libata-eh.o
+libata-objs	:= libata-core.o libata-scsi.o libata-eh.o libata-transport.o
 libata-$(CONFIG_ATA_SFF)	+= libata-sff.o
 libata-$(CONFIG_SATA_PMP)	+= libata-pmp.o
 libata-$(CONFIG_ATA_ACPI)	+= libata-acpi.o
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 79e3a8e..0dbc04c 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -64,7 +64,7 @@
 #include <linux/cdrom.h>

 #include "libata.h"
-
+#include "libata-transport.h"

 /* debounce timing parameters in msecs { interval, duration, timeout } */
 const unsigned long sata_deb_timing_normal[]		= {   5,  100, 2000 };
@@ -864,7 +864,7 @@ const char *ata_mode_string(unsigned long xfer_mask)
 	return "<n/a>";
 }

-static const char *sata_spd_string(unsigned int spd)
+const char *sata_spd_string(unsigned int spd)
 {
 	static const char * const spd_str[] = {
 		"1.5 Gbps",
@@ -5167,7 +5167,8 @@ void ata_link_init(struct ata_port *ap, struct
ata_link *link, int pmp)
 	int i;

 	/* clear everything except for devices */
-	memset(link, 0, offsetof(struct ata_link, device[0]));
+	memset((void *)link + ATA_LINK_CLEAR_OFFSET, 0,
+	       offsetof(struct ata_link, device[0]) - ATA_LINK_CLEAR_OFFSET);

 	link->ap = ap;
 	link->pmp = pmp;
@@ -5622,9 +5623,18 @@ int ata_host_register(struct ata_host *host,
struct scsi_host_template *sht)
 	for (i = 0; i < host->n_ports; i++)
 		host->ports[i]->print_id = ata_print_id++;

+
+	/* Create associated sysfs transport objects  */
+	for (i = 0; i < host->n_ports; i++) {
+		rc = ata_tport_add(host->dev,host->ports[i]);
+		if (rc) {
+			goto err_tadd;
+		}
+	}
+
 	rc = ata_scsi_add_hosts(host, sht);
 	if (rc)
-		return rc;
+		goto err_tadd;

 	/* associate with ACPI nodes */
 	ata_acpi_associate(host);
@@ -5708,6 +5718,13 @@ int ata_host_register(struct ata_host *host,
struct scsi_host_template *sht)
 	}

 	return 0;
+
+ err_tadd:
+	while (--i >= 0) {
+		ata_tport_delete(host->ports[i]);
+	}
+	return rc;
+
 }

 /**
@@ -5813,6 +5830,13 @@ static void ata_port_detach(struct ata_port *ap)
 	cancel_rearming_delayed_work(&ap->hotplug_task);

  skip_eh:
+	if (ap->pmp_link) {
+		int i;
+		for (i = 0; i < SATA_PMP_MAX_PORTS; i++)
+			ata_tlink_delete(&ap->pmp_link[i]);
+	}
+	ata_tport_delete(ap);
+
 	/* remove the associated SCSI host */
 	scsi_remove_host(ap->scsi_host);
 }
@@ -6138,9 +6162,17 @@ static int __init ata_init(void)
 	if (!ata_aux_wq)
 		goto free_wq;

+	libata_transport_init();
+	ata_scsi_transport_template = ata_attach_transport();
+	if (ata_scsi_transport_template == NULL) {
+		goto free_aux_wq;
+	}
+
 	printk(KERN_DEBUG "libata version " DRV_VERSION " loaded.\n");
 	return 0;

+free_aux_wq:
+	destroy_workqueue(ata_aux_wq);
 free_wq:
 	destroy_workqueue(ata_wq);
 free_force_tbl:
@@ -6150,6 +6182,8 @@ free_force_tbl:

 static void __exit ata_exit(void)
 {
+	ata_release_transport(ata_scsi_transport_template);
+	libata_transport_exit();
 	kfree(ata_force_tbl);
 	destroy_workqueue(ata_wq);
 	destroy_workqueue(ata_aux_wq);
diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
index b65db30..aeb472e 100644
--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -10,6 +10,7 @@
 #include <linux/kernel.h>
 #include <linux/libata.h>
 #include "libata.h"
+#include "libata-transport.h"

 const struct ata_port_operations sata_pmp_port_ops = {
 	.inherits		= &sata_port_ops,
@@ -286,7 +287,7 @@ static int sata_pmp_configure(struct ata_device
*dev, int print_info)
 static int sata_pmp_init_links(struct ata_port *ap, int nr_ports)
 {
 	struct ata_link *pmp_link = ap->pmp_link;
-	int i;
+	int i, err;

 	if (!pmp_link) {
 		pmp_link = kzalloc(sizeof(pmp_link[0]) * SATA_PMP_MAX_PORTS,
@@ -298,6 +299,13 @@ static int sata_pmp_init_links(struct ata_port
*ap, int nr_ports)
 			ata_link_init(ap, &pmp_link[i], i);

 		ap->pmp_link = pmp_link;
+
+		for (i = 0; i < SATA_PMP_MAX_PORTS; i++) {
+			err = ata_tlink_add(&pmp_link[i]);
+			if (err) {
+				goto err_tlink;
+			}
+		}
 	}

 	for (i = 0; i < nr_ports; i++) {
@@ -310,6 +318,12 @@ static int sata_pmp_init_links(struct ata_port
*ap, int nr_ports)
 	}

 	return 0;
+  err_tlink:
+	while (--i >= 0)
+		ata_tlink_delete(&pmp_link[i]);
+	kfree(pmp_link);
+	ap->pmp_link = NULL;
+	return err;
 }

 static void sata_pmp_quirks(struct ata_port *ap)
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index b9d3ba4..be297d8 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -48,6 +48,7 @@
 #include <linux/uaccess.h>

 #include "libata.h"
+#include "libata-transport.h"

 #define SECTOR_SIZE		512
 #define ATA_SCSI_RBUF_SIZE	4096
@@ -61,9 +62,6 @@ static struct ata_device *__ata_scsi_find_dev(struct
ata_port *ap,
 					const struct scsi_device *scsidev);
 static struct ata_device *ata_scsi_find_dev(struct ata_port *ap,
 					    const struct scsi_device *scsidev);
-static int ata_scsi_user_scan(struct Scsi_Host *shost, unsigned int channel,
-			      unsigned int id, unsigned int lun);
-

 #define RW_RECOVERY_MPAGE 0x1
 #define RW_RECOVERY_MPAGE_LEN 12
@@ -103,17 +101,6 @@ static const u8 def_control_mpage[CONTROL_MPAGE_LEN] = {
 	0, 30	/* extended self test time, see 05-359r1 */
 };

-/*
- * libata transport template.  libata doesn't do real transport stuff.
- * It just needs the eh_timed_out hook.
- */
-static struct scsi_transport_template ata_scsi_transport_template = {
-	.eh_strategy_handler	= ata_scsi_error,
-	.eh_timed_out		= ata_scsi_timed_out,
-	.user_scan		= ata_scsi_user_scan,
-};
-
-
 static const struct {
 	enum link_pm	value;
 	const char	*name;
@@ -3072,7 +3059,7 @@ int ata_scsi_add_hosts(struct ata_host *host,
struct scsi_host_template *sht)
 		*(struct ata_port **)&shost->hostdata[0] = ap;
 		ap->scsi_host = shost;

-		shost->transportt = &ata_scsi_transport_template;
+		shost->transportt = ata_scsi_transport_template;
 		shost->unique_id = ap->print_id;
 		shost->max_id = 16;
 		shost->max_lun = 1;
@@ -3355,8 +3342,8 @@ void ata_scsi_hotplug(struct work_struct *work)
  *	RETURNS:
  *	Zero.
  */
-static int ata_scsi_user_scan(struct Scsi_Host *shost, unsigned int channel,
-			      unsigned int id, unsigned int lun)
+int ata_scsi_user_scan(struct Scsi_Host *shost, unsigned int channel,
+		       unsigned int id, unsigned int lun)
 {
 	struct ata_port *ap = ata_shost_to_port(shost);
 	unsigned long flags;
diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
new file mode 100644
index 0000000..0931b14
--- /dev/null
+++ b/drivers/ata/libata-transport.c
@@ -0,0 +1,720 @@
+/*
+ *  Copyright 2008 Google, Inc.  All rights reserved.
+ *	Released under GPL v2.
+ *
+ * Libata transport class.
+ *
+ * The ATA transport class contains common code to deal with ATA HBAs,
+ * an approximated representation of ATA topologies in the driver model,
+ * and various sysfs attributes to expose these topologies and management
+ * interfaces to user-space.
+ *
+ * There are 3 objects defined in in this class:
+ * - ata_port
+ * - ata_link
+ * - ata_device
+ * Each port has a link object. Each link can have up to two devices for PATA
+ * and generally one for SATA.
+ * If there is SATA port multiplier [PMP], 15 additional ata_link object are
+ * created.
+ *
+ * These objects are created when the ata host is initialized and when a PMP is
+ * found. They are removed only when the HBA is removed, cleaned before the
+ * error handler runs.
+ */
+
+
+#include <linux/kernel.h>
+#include <linux/blkdev.h>
+#include <linux/spinlock.h>
+#include <scsi/scsi_transport.h>
+#include <linux/libata.h>
+#include <linux/hdreg.h>
+#include <linux/uaccess.h>
+
+#include "libata.h"
+#include "libata-transport.h"
+
+#define ATA_PORT_ATTRS		2
+#define ATA_LINK_ATTRS		3
+#define ATA_DEV_ATTRS		8
+
+struct scsi_transport_template;
+struct scsi_transport_template *ata_scsi_transport_template;
+
+struct ata_internal {
+	struct scsi_transport_template t;
+
+	struct device_attribute private_port_attrs[ATA_PORT_ATTRS];
+	struct device_attribute private_link_attrs[ATA_LINK_ATTRS];
+	struct device_attribute private_dev_attrs[ATA_DEV_ATTRS];
+
+	struct transport_container link_attr_cont;
+	struct transport_container dev_attr_cont;
+
+	/*
+	 * The array of null terminated pointers to attributes
+	 * needed by scsi_sysfs.c
+	 */
+	struct device_attribute *link_attrs[ATA_LINK_ATTRS + 1];
+	struct device_attribute *port_attrs[ATA_PORT_ATTRS + 1];
+	struct device_attribute *dev_attrs[ATA_DEV_ATTRS + 1];
+};
+#define to_ata_internal(tmpl)	container_of(tmpl, struct ata_internal, t)
+
+
+#define tdev_to_device(d)					\
+	container_of((d), struct ata_device, tdev)
+#define transport_class_to_dev(dev)				\
+	tdev_to_device((dev)->parent)
+
+#define tdev_to_link(d)						\
+	container_of((d), struct ata_link, tdev)
+#define transport_class_to_link(dev)				\
+	tdev_to_link((dev)->parent)
+
+#define tdev_to_port(d)						\
+	container_of((d), struct ata_port, tdev)
+#define transport_class_to_port(dev)				\
+	tdev_to_port((dev)->parent)
+
+
+/* Device objects are always created whit link objects */
+static int ata_tdev_add(struct ata_device *dev);
+static void ata_tdev_delete(struct ata_device *dev);
+
+
+/*
+ * Hack to allow attributes of the same name in different objects.
+ */
+#define ATA_DEVICE_ATTR(_prefix,_name,_mode,_show,_store) \
+	struct device_attribute device_attr_##_prefix##_##_name = \
+	__ATTR(_name,_mode,_show,_store)
+
+#define ata_bitfield_name_match(title, table)			\
+static ssize_t							\
+get_ata_##title##_names(u32 table_key, char *buf)		\
+{								\
+	char *prefix = "";					\
+	ssize_t len = 0;					\
+	int i;							\
+								\
+	for (i = 0; i < ARRAY_SIZE(table); i++) {		\
+		if (table[i].value & table_key) {		\
+			len += sprintf(buf + len, "%s%s",	\
+				prefix, table[i].name);		\
+			prefix = ", ";				\
+		}						\
+	}							\
+	len += sprintf(buf + len, "\n");			\
+	return len;						\
+}
+
+#define ata_bitfield_name_search(title, table)			\
+static ssize_t							\
+get_ata_##title##_names(u32 table_key, char *buf)		\
+{								\
+	ssize_t len = 0;					\
+	int i;							\
+								\
+	for (i = 0; i < ARRAY_SIZE(table); i++) {		\
+		if (table[i].value == table_key) {		\
+			len += sprintf(buf + len, "%s",		\
+				table[i].name);			\
+			break;					\
+		}						\
+	}							\
+	len += sprintf(buf + len, "\n");			\
+	return len;						\
+}
+
+static struct {
+	u32		value;
+	char		*name;
+} ata_class_names[] = {
+	{ ATA_DEV_UNKNOWN,		"unknown" },
+	{ ATA_DEV_ATA,			"ata" },
+	{ ATA_DEV_ATA_UNSUP,		"ata" },
+	{ ATA_DEV_ATAPI,		"atapi" },
+	{ ATA_DEV_ATAPI_UNSUP,		"atapi" },
+	{ ATA_DEV_PMP,			"pmp" },
+	{ ATA_DEV_PMP_UNSUP,		"pmp" },
+	{ ATA_DEV_SEMB,			"semb" },
+	{ ATA_DEV_SEMB_UNSUP,		"semb" },
+	{ ATA_DEV_NONE,			"none" }
+};
+ata_bitfield_name_search(class, ata_class_names)
+
+static struct {
+	u32		value;
+	char		*name;
+} ata_xfer_names[] = {
+	{ XFER_UDMA_7,			"XFER_UDMA_7" },
+	{ XFER_UDMA_6,			"XFER_UDMA_6" },
+	{ XFER_UDMA_5,			"XFER_UDMA_5" },
+	{ XFER_UDMA_4,			"XFER_UDMA_4" },
+	{ XFER_UDMA_3,			"XFER_UDMA_3" },
+	{ XFER_UDMA_2,			"XFER_UDMA_2" },
+	{ XFER_UDMA_1,			"XFER_UDMA_1" },
+	{ XFER_UDMA_0,			"XFER_UDMA_0" },
+	{ XFER_MW_DMA_4,		"XFER_MW_DMA_4" },
+	{ XFER_MW_DMA_3,		"XFER_MW_DMA_3" },
+	{ XFER_MW_DMA_2,		"XFER_MW_DMA_2" },
+	{ XFER_MW_DMA_1,		"XFER_MW_DMA_1" },
+	{ XFER_MW_DMA_0,		"XFER_MW_DMA_0" },
+	{ XFER_SW_DMA_2,		"XFER_SW_DMA_2" },
+	{ XFER_SW_DMA_1,		"XFER_SW_DMA_1" },
+	{ XFER_SW_DMA_0,		"XFER_SW_DMA_0" },
+	{ XFER_PIO_6,			"XFER_PIO_6" },
+	{ XFER_PIO_5,			"XFER_PIO_5" },
+	{ XFER_PIO_4,			"XFER_PIO_4" },
+	{ XFER_PIO_3,			"XFER_PIO_3" },
+	{ XFER_PIO_2,			"XFER_PIO_2" },
+	{ XFER_PIO_1,			"XFER_PIO_1" },
+	{ XFER_PIO_0,			"XFER_PIO_0" },
+	{ XFER_PIO_SLOW,		"XFER_PIO_SLOW" }
+};
+ata_bitfield_name_match(xfer,ata_xfer_names)
+
+/*
+ * ATA Port attributes
+ */
+#define ata_port_show_simple(field, name, format_string, cast)		\
+static ssize_t								\
+show_ata_port_##name(struct device *dev,				\
+		     struct device_attribute *attr, char *buf)		\
+{									\
+	struct ata_port *ap = transport_class_to_port(dev);		\
+									\
+	return snprintf(buf, 20, format_string, cast ap->field);	\
+}
+
+#define ata_port_simple_attr(field, name, format_string, type)		\
+	ata_port_show_simple(field, name, format_string, (type))	\
+static DEVICE_ATTR(name, S_IRUGO, show_ata_port_##name, NULL)
+
+ata_port_simple_attr(nr_pmp_links, nr_pmp_links, "%d\n", int);
+ata_port_simple_attr(stats.idle_irq, idle_irq, "%ld\n", unsigned long);
+
+static DECLARE_TRANSPORT_CLASS(ata_port_class,
+			       "ata_port", NULL, NULL, NULL);
+
+static void ata_tport_release(struct device *dev)
+{
+	put_device(dev->parent);
+}
+
+/**
+ * ata_is_port --  check if a struct device represents a ATA port
+ * @dev:	device to check
+ *
+ * Returns:
+ *	%1 if the device represents a ATA Port, %0 else
+ */
+int ata_is_port(const struct device *dev)
+{
+	return dev->release == ata_tport_release;
+}
+
+static int ata_tport_match(struct attribute_container *cont,
+			   struct device *dev)
+{
+	if (!ata_is_port(dev))
+		return 0;
+	return &ata_scsi_transport_template->host_attrs.ac == cont;
+}
+
+/**
+ * ata_tport_delete  --  remove ATA PORT
+ * @port:	ATA PORT to remove
+ *
+ * Removes the specified ATA PORT.  Remove the associated link as well.
+ */
+void ata_tport_delete(struct ata_port *ap)
+{
+	struct device *dev = &ap->tdev;
+
+	ata_tlink_delete(&ap->link);
+
+	transport_remove_device(dev);
+	device_del(dev);
+	transport_destroy_device(dev);
+	put_device(dev);
+}
+
+/** ata_tport_add - initialize a transport ATA port structure
+ *
+ * @parent:	parent device
+ * @ap:		existing ata_port structure
+ *
+ * Initialize a ATA port structure for sysfs.  It will be added to the device
+ * tree below the device specified by @parent which could be a PCI device.
+ *
+ * Returns %0 on success
+ */
+int ata_tport_add(struct device *parent,
+		  struct ata_port *ap)
+{
+	int error;
+	struct device *dev = &ap->tdev;
+
+	device_initialize(dev);
+
+	dev->parent = get_device(parent);
+	dev->release = ata_tport_release;
+	sprintf(dev->bus_id, "ata%d", ap->print_id);
+	transport_setup_device(dev);
+	error = device_add(dev);
+	if (error) {
+		goto tport_err;
+	}
+
+	transport_add_device(dev);
+	transport_configure_device(dev);
+
+	error = ata_tlink_add(&ap->link);
+	if (error) {
+		goto tport_link_err;
+	}
+	return 0;
+
+ tport_link_err:
+	transport_remove_device(dev);
+	device_del(dev);
+
+ tport_err:
+	transport_destroy_device(dev);
+	put_device(dev);
+	return error;
+}
+
+
+/*
+ * ATA link attributes
+ */
+
+
+#define ata_link_show_linkspeed(field)					\
+static ssize_t								\
+show_ata_link_##field(struct device *dev,				\
+		      struct device_attribute *attr, char *buf)		\
+{									\
+	struct ata_link *link = transport_class_to_link(dev);		\
+									\
+	return sprintf(buf,"%s\n", sata_spd_string(fls(link->field)));	\
+}
+
+#define ata_link_linkspeed_attr(field)					\
+	ata_link_show_linkspeed(field)					\
+static DEVICE_ATTR(field, S_IRUGO, show_ata_link_##field, NULL)
+
+ata_link_linkspeed_attr(hw_sata_spd_limit);
+ata_link_linkspeed_attr(sata_spd_limit);
+ata_link_linkspeed_attr(sata_spd);
+
+
+static DECLARE_TRANSPORT_CLASS(ata_link_class,
+		"ata_link", NULL, NULL, NULL);
+
+static void ata_tlink_release(struct device *dev)
+{
+	put_device(dev->parent);
+}
+
+/**
+ * ata_is_link --  check if a struct device represents a ATA link
+ * @dev:	device to check
+ *
+ * Returns:
+ *	%1 if the device represents a ATA link, %0 else
+ */
+int ata_is_link(const struct device *dev)
+{
+	return dev->release == ata_tlink_release;
+}
+
+static int ata_tlink_match(struct attribute_container *cont,
+			   struct device *dev)
+{
+	struct ata_internal* i = to_ata_internal(ata_scsi_transport_template);
+	if (!ata_is_link(dev))
+		return 0;
+	return &i->link_attr_cont.ac == cont;
+}
+
+/**
+ * ata_tlink_delete  --  remove ATA LINK
+ * @port:	ATA LINK to remove
+ *
+ * Removes the specified ATA LINK.  remove associated ATA device(s) as well.
+ */
+void ata_tlink_delete(struct ata_link *link)
+{
+	struct device *dev = &link->tdev;
+	struct ata_device *ata_dev;
+
+	ata_link_for_each_dev(ata_dev, link) {
+		ata_tdev_delete(ata_dev);
+	}
+
+	transport_remove_device(dev);
+	device_del(dev);
+	transport_destroy_device(dev);
+	put_device(dev);
+}
+
+/**
+ * ata_tlink_add  --  initialize a transport ATA link structure
+ * @link:	allocated ata_link structure.
+ *
+ * Initialize an ATA LINK structure for sysfs.  It will be added in the
+ * device tree below the ATA PORT it belongs to.
+ *
+ * Returns %0 on success
+ */
+int ata_tlink_add(struct ata_link *link)
+{
+	struct device *dev = &link->tdev;
+	struct ata_port *ap = link->ap;
+	struct ata_device *ata_dev;
+	int error;
+
+	device_initialize(dev);
+	dev->parent = get_device(&ap->tdev);
+	dev->release = ata_tlink_release;
+	if (ata_is_host_link(link))
+		sprintf(dev->bus_id, "link%d", ap->print_id);
+        else
+		sprintf(dev->bus_id, "link%d.%d", ap->print_id, link->pmp);
+
+	transport_setup_device(dev);
+
+	error = device_add(dev);
+	if (error) {
+		goto tlink_err;
+	}
+
+	transport_add_device(dev);
+	transport_configure_device(dev);
+
+	ata_link_for_each_dev(ata_dev, link) {
+		error = ata_tdev_add(ata_dev);
+		if (error) {
+			goto tlink_dev_err;
+		}
+	}
+	return 0;
+  tlink_dev_err:
+	while (--ata_dev >= link->device) {
+		ata_tdev_delete(ata_dev);
+	}
+	transport_remove_device(dev);
+	device_del(dev);
+  tlink_err:
+	transport_destroy_device(dev);
+	put_device(dev);
+	return error;
+}
+
+/*
+ * ATA device attributes
+ */
+
+#define ata_dev_show_class(title, field)				\
+static ssize_t								\
+show_ata_dev_##field(struct device *dev,				\
+		     struct device_attribute *attr, char *buf)		\
+{									\
+	struct ata_device *ata_dev = transport_class_to_dev(dev);	\
+									\
+	return get_ata_##title##_names(ata_dev->field, buf);		\
+}
+
+#define ata_dev_attr(title, field)					\
+	ata_dev_show_class(title, field)				\
+static DEVICE_ATTR(field, S_IRUGO, show_ata_dev_##field, NULL)
+
+ata_dev_attr(class, class);
+ata_dev_attr(xfer, pio_mode);
+ata_dev_attr(xfer, dma_mode);
+ata_dev_attr(xfer, xfer_mode);
+
+
+#define ata_dev_show_simple(field, format_string, cast)		\
+static ssize_t								\
+show_ata_dev_##field(struct device *dev,				\
+		     struct device_attribute *attr, char *buf)		\
+{									\
+	struct ata_device *ata_dev = transport_class_to_dev(dev);	\
+									\
+	return snprintf(buf, 20, format_string, cast ata_dev->field);	\
+}
+
+#define ata_dev_simple_attr(field, format_string, type)	\
+	ata_dev_show_simple(field, format_string, (type))	\
+static DEVICE_ATTR(field, S_IRUGO, 			\
+		   show_ata_dev_##field, NULL)
+
+ata_dev_simple_attr(spdn_cnt, "%d\n", int);
+
+static ssize_t
+show_ata_dev_id(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct ata_device *ata_dev = transport_class_to_dev(dev);
+	int written = 0, i = 0;
+
+	if (ata_dev->class == ATA_DEV_PMP)
+		return 0;
+	for(i=0;i<ATA_ID_WORDS;i++)  {
+		written += snprintf(buf+written, 20, "%04x%c",
+				    ata_dev->id[i],
+				    ((i+1) & 7) ? ' ' : '\n');
+	}
+	return written;
+}
+
+static DEVICE_ATTR(id, S_IRUGO, show_ata_dev_id, NULL);
+
+static ssize_t
+show_ata_dev_gscr(struct device *dev,
+		  struct device_attribute *attr, char *buf)
+{
+	struct ata_device *ata_dev = transport_class_to_dev(dev);
+	int written = 0, i = 0;
+
+	if (ata_dev->class != ATA_DEV_PMP)
+		return 0;
+	for(i=0;i<SATA_PMP_GSCR_DWORDS;i++)  {
+		written += snprintf(buf+written, 20, "%08x%c",
+				    ata_dev->gscr[i],
+				    ((i+1) & 3) ? ' ' : '\n');
+	}
+	return written;
+}
+
+static DEVICE_ATTR(gscr, S_IRUGO, show_ata_dev_gscr, NULL);
+
+static DECLARE_TRANSPORT_CLASS(ata_dev_class,
+			       "ata_device", NULL, NULL, NULL);
+
+static void ata_tdev_release(struct device *dev)
+{
+	put_device(dev->parent);
+}
+
+/**
+ * ata_is_ata_dev  --  check if a struct device represents a ATA device
+ * @dev:	device to check
+ *
+ * Returns:
+ *	%1 if the device represents a ATA device, %0 else
+ */
+int ata_is_ata_dev(const struct device *dev)
+{
+	return dev->release == ata_tdev_release;
+}
+
+static int ata_tdev_match(struct attribute_container *cont,
+			  struct device *dev)
+{
+	struct ata_internal* i = to_ata_internal(ata_scsi_transport_template);
+	if (!ata_is_ata_dev(dev))
+		return 0;
+	return &i->dev_attr_cont.ac == cont;
+}
+
+/**
+ * ata_tdev_free  --  free a ATA LINK
+ * @dev:	ATA PHY to free
+ *
+ * Frees the specified ATA PHY.
+ *
+ * Note:
+ *   This function must only be called on a PHY that has not
+ *   successfully been added using ata_tdev_add().
+ */
+static void ata_tdev_free(struct ata_device *dev)
+{
+	transport_destroy_device(&dev->tdev);
+	put_device(&dev->tdev);
+}
+
+/**
+ * ata_tdev_delete  --  remove ATA device
+ * @port:	ATA PORT to remove
+ *
+ * Removes the specified ATA device.
+ */
+static void ata_tdev_delete(struct ata_device *ata_dev)
+{
+	struct device *dev = &ata_dev->tdev;
+
+	transport_remove_device(dev);
+	device_del(dev);
+	ata_tdev_free(ata_dev);
+}
+
+
+/**
+ * ata_tdev_add  --  initialize a transport ATA device structure.
+ * @ata_dev:	ata_dev structure.
+ *
+ * Initialize an ATA device structure for sysfs.  It will be added in the
+ * device tree below the ATA LINK device it belongs to.
+ *
+ * Returns %0 on success
+ */
+static int ata_tdev_add(struct ata_device *ata_dev)
+{
+	struct device *dev = &ata_dev->tdev;
+	struct ata_link *link = ata_dev->link;
+	struct ata_port *ap = link->ap;
+	int error;
+
+	device_initialize(dev);
+	dev->parent = get_device(&link->tdev);
+	dev->release = ata_tdev_release;
+	if (ata_is_host_link(link))
+		sprintf(dev->bus_id, "dev%d.%d",
+			ap->print_id,ata_dev->devno);
+        else
+		sprintf(dev->bus_id, "dev%d.%d.0",
+			ap->print_id, link->pmp);
+
+	transport_setup_device(dev);
+	error = device_add(dev);
+	if (error) {
+		ata_tdev_free(ata_dev);
+		return error;
+	}
+
+	transport_add_device(dev);
+	transport_configure_device(dev);
+	return 0;
+}
+
+
+/*
+ * Setup / Teardown code
+ */
+
+#define SETUP_TEMPLATE(attrb, field, perm, test)			\
+	i->private_##attrb[count] = dev_attr_##field;		       	\
+	i->private_##attrb[count].attr.mode = perm;			\
+	i->attrb[count] = &i->private_##attrb[count];			\
+	if (test)							\
+		count++
+
+#define SETUP_LINK_ATTRIBUTE(field)					\
+	SETUP_TEMPLATE(link_attrs, field, S_IRUGO, 1)
+
+#define SETUP_PORT_ATTRIBUTE(field)					\
+	SETUP_TEMPLATE(port_attrs, field, S_IRUGO, 1)
+
+#define SETUP_DEV_ATTRIBUTE(field)					\
+	SETUP_TEMPLATE(dev_attrs, field, S_IRUGO, 1)
+
+/**
+ * ata_attach_transport  --  instantiate ATA transport template
+ */
+struct scsi_transport_template *ata_attach_transport(void)
+{
+	struct ata_internal *i;
+	int count;
+
+	i = kzalloc(sizeof(struct ata_internal), GFP_KERNEL);
+	if (!i)
+		return NULL;
+
+	i->t.eh_strategy_handler	= ata_scsi_error;
+	i->t.eh_timed_out		= ata_scsi_timed_out;
+	i->t.user_scan			= ata_scsi_user_scan;
+
+	i->t.host_attrs.ac.attrs = &i->port_attrs[0];
+	i->t.host_attrs.ac.class = &ata_port_class.class;
+	i->t.host_attrs.ac.match = ata_tport_match;
+	transport_container_register(&i->t.host_attrs);
+
+	i->link_attr_cont.ac.class = &ata_link_class.class;
+	i->link_attr_cont.ac.attrs = &i->link_attrs[0];
+	i->link_attr_cont.ac.match = ata_tlink_match;
+	transport_container_register(&i->link_attr_cont);
+
+	i->dev_attr_cont.ac.class = &ata_dev_class.class;
+	i->dev_attr_cont.ac.attrs = &i->dev_attrs[0];
+	i->dev_attr_cont.ac.match = ata_tdev_match;
+	transport_container_register(&i->dev_attr_cont);
+
+	count = 0;
+	SETUP_PORT_ATTRIBUTE(nr_pmp_links);
+	SETUP_PORT_ATTRIBUTE(idle_irq);
+	BUG_ON(count > ATA_PORT_ATTRS);
+	i->port_attrs[count] = NULL;
+
+	count = 0;
+	SETUP_LINK_ATTRIBUTE(hw_sata_spd_limit);
+	SETUP_LINK_ATTRIBUTE(sata_spd_limit);
+	SETUP_LINK_ATTRIBUTE(sata_spd);
+	BUG_ON(count > ATA_LINK_ATTRS);
+	i->link_attrs[count] = NULL;
+
+	count = 0;
+	SETUP_DEV_ATTRIBUTE(class);
+	SETUP_DEV_ATTRIBUTE(pio_mode);
+	SETUP_DEV_ATTRIBUTE(dma_mode);
+	SETUP_DEV_ATTRIBUTE(xfer_mode);
+	SETUP_DEV_ATTRIBUTE(spdn_cnt);
+	SETUP_DEV_ATTRIBUTE(id);
+	SETUP_DEV_ATTRIBUTE(gscr);
+	BUG_ON(count > ATA_DEV_ATTRS);
+	i->dev_attrs[count] = NULL;
+
+	return &i->t;
+}
+
+/**
+ * ata_release_transport  --  release ATA transport template instance
+ * @t:		transport template instance
+ */
+void ata_release_transport(struct scsi_transport_template *t)
+{
+	struct ata_internal *i = to_ata_internal(t);
+
+	transport_container_unregister(&i->t.host_attrs);
+	transport_container_unregister(&i->link_attr_cont);
+	transport_container_unregister(&i->dev_attr_cont);
+
+	kfree(i);
+}
+
+__init int libata_transport_init(void)
+{
+	int error;
+
+	error = transport_class_register(&ata_link_class);
+	if (error)
+		goto out_unregister_transport;
+	error = transport_class_register(&ata_port_class);
+	if (error)
+		goto out_unregister_link;
+	error = transport_class_register(&ata_dev_class);
+	if (error)
+		goto out_unregister_port;
+	return 0;
+
+ out_unregister_port:
+	transport_class_unregister(&ata_port_class);
+ out_unregister_link:
+	transport_class_unregister(&ata_link_class);
+ out_unregister_transport:
+	return error;
+
+}
+
+void __exit libata_transport_exit(void)
+{
+	transport_class_unregister(&ata_link_class);
+	transport_class_unregister(&ata_port_class);
+	transport_class_unregister(&ata_dev_class);
+}
diff --git a/drivers/ata/libata-transport.h b/drivers/ata/libata-transport.h
new file mode 100644
index 0000000..2820cf8
--- /dev/null
+++ b/drivers/ata/libata-transport.h
@@ -0,0 +1,18 @@
+#ifndef _LIBATA_TRANSPORT_H
+#define _LIBATA_TRANSPORT_H
+
+
+extern struct scsi_transport_template *ata_scsi_transport_template;
+
+int ata_tlink_add(struct ata_link *link);
+void ata_tlink_delete(struct ata_link *link);
+
+int ata_tport_add(struct device *parent, struct ata_port *ap);
+void ata_tport_delete(struct ata_port *ap);
+
+struct scsi_transport_template *ata_attach_transport(void);
+void ata_release_transport(struct scsi_transport_template *t);
+
+__init int libata_transport_init(void);
+void __exit libata_transport_exit(void);
+#endif
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index ade5c75..d262d87 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -115,6 +115,7 @@ extern int ata_cmd_ioctl(struct scsi_device
*scsidev, void __user *arg);
 extern struct ata_port *ata_port_alloc(struct ata_host *host);
 extern void ata_dev_enable_pm(struct ata_device *dev, enum link_pm policy);
 extern void ata_lpm_schedule(struct ata_port *ap, enum link_pm);
+extern const char *sata_spd_string(unsigned int spd);

 /* libata-acpi.c */
 #ifdef CONFIG_ATA_ACPI
@@ -148,6 +149,9 @@ extern void ata_scsi_hotplug(struct work_struct *work);
 extern void ata_schedule_scsi_eh(struct Scsi_Host *shost);
 extern void ata_scsi_dev_rescan(struct work_struct *work);
 extern int ata_bus_probe(struct ata_port *ap);
+extern int ata_scsi_user_scan(struct Scsi_Host *shost, unsigned int channel,
+			      unsigned int id, unsigned int lun);
+

 /* libata-eh.c */
 extern unsigned long ata_internal_cmd_timeout(struct ata_device *dev, u8 cmd);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 225bfc5..9b6247b 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -557,13 +557,16 @@ struct ata_device {
 	unsigned long		flags;		/* ATA_DFLAG_xxx */
 	unsigned int		horkage;	/* List of broken features */
 	struct scsi_device	*sdev;		/* attached SCSI device */
+	struct device		tdev;
+
+	/* n_sector is used as CLEAR_OFFSET, read comment above CLEAR_OFFSET */
+	u64			n_sectors;	/* size of device, if ATA */
+	unsigned int		class;		/* ATA_DEV_xxx */
+
 #ifdef CONFIG_ATA_ACPI
 	acpi_handle		acpi_handle;
 	union acpi_object	*gtf_cache;
 #endif
-	/* n_sector is used as CLEAR_OFFSET, read comment above CLEAR_OFFSET */
-	u64			n_sectors;	/* size of device, if ATA */
-	unsigned int		class;		/* ATA_DEV_xxx */

 	u8			pio_mode;
 	u8			dma_mode;
@@ -642,6 +645,7 @@ struct ata_link {
 	struct ata_port		*ap;
 	int			pmp;		/* port multiplier port # */

+	struct device		tdev;
 	unsigned int		active_tag;	/* active tag on this link */
 	u32			sactive;	/* active NCQ commands */

@@ -659,6 +663,7 @@ struct ata_link {

 	struct ata_device	device[ATA_MAX_DEVICES];
 };
+#define ATA_LINK_CLEAR_OFFSET		offsetof(struct ata_link, active_tag)

 struct ata_port {
 	struct Scsi_Host	*scsi_host; /* our co-allocated scsi host */
@@ -697,6 +702,7 @@ struct ata_port {
 	struct ata_port_stats	stats;
 	struct ata_host		*host;
 	struct device 		*dev;
+	struct device		tdev;

 	void			*port_task_data;
 	struct delayed_work	port_task;
-- 
1.5.4.5
