From: Martin Hicks <mort@wildopensource.com>
Subject: Re: Transport Attributes -- attempt#4
Date: Thu, 4 Mar 2004 11:14:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040304161424.GG1135@localhost>
References: <20040120215645.GG15871@localhost> <1077581832.1833.21.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="C+ts3FVlLX8+P6JN"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from galileo.bork.org ([66.11.174.156]:34510 "HELO galileo.bork.org")
	by vger.kernel.org with SMTP id S261998AbUCDQPA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Mar 2004 11:15:00 -0500
Content-Disposition: inline
In-Reply-To: <1077581832.1833.21.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>


--C+ts3FVlLX8+P6JN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline



On Mon, Feb 23, 2004 at 06:17:11PM -0600, James Bottomley wrote:
> On Tue, 2004-01-20 at 15:56, Martin Hicks wrote:
> > Updated patches against Linus' bk tree from earlier today.  The patch
> > that fixes up the scsi_sysfs.c error path, that was sent out by me on
> > Jan 16, is required for the core patch to apply cleanly.
> > 
> > I think I've addressed all the comments from the last round with the
> > exception of doing Lazy registration of the transport classes.  I'm
> > still not totally convinced that this is really required.
> 
> OK, I finally found time to look at all this and try it out.

Thanks!

> 
> My big objection is still that the scsi mid-layer needs to know about
> the transports.  In testing, I recoded this so that no mid-layer
> transport knowledge is necessary (patch attached).  I didn't opt for a
> transport registration API in the mid-layer, but I could see that such a
> thing might have been a better solution.

Agreed.  Thanks for getting the cruft out of the midlayer.

> I also see no necessity to allow hosts to add arbitrary transport
> attributes: they can simply add extra device attributes to the same
> effect.  This means that the attribute list is fixed, and we develop a
> private API between the transport and the device driver to update
> attributes (I didn't code this, but you can see where I'm going with
> it).

This is a future-needs thing, as far as I can see.  I'm going to leave
it as-is for now.  When the time comes that we want r/w sysfs attributes
to callback into the drivers it can be added then.

> There were a few other initialisation touches (Like making the
> attributes part of the host structure directly), and initialising the
> default transportt correctly in the host_alloc.

These are great.  Thanks.

> I did my implementation for the 53c700 which is the driver I can readily
> use.  As you can see, the other half of this is shifting the driver
> internally to use the transport attribute values (so that whatever we
> find there can be directly exported to the user).

I've expanded your changes to fix up the Fiber Channel transport
attributes using your new ideas.  I've also attached driver updates
for qla2xxx and qla1280.

thanks
mh

--
Martin Hicks                Wild Open Source Inc.
mort@wildopensource.com     613-266-2296

--C+ts3FVlLX8+P6JN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="xprt-qla1280.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1635  -> 1.1636 
#	drivers/scsi/Kconfig	1.58    -> 1.59   
#	drivers/scsi/qla1280.c	1.55    -> 1.56   
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 04/03/04	mort@green.i.bork.org	1.1636
# SPI transport attributes for qla1280
# --------------------------------------------
#
diff -Nru a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig	Thu Mar  4 10:57:37 2004
+++ b/drivers/scsi/Kconfig	Thu Mar  4 10:57:37 2004
@@ -1193,7 +1193,7 @@
 
 config SCSI_QLOGIC_1280
 	tristate "Qlogic QLA 1280 SCSI support"
-	depends on PCI && SCSI
+	depends on PCI && SCSI && SCSI_SPI_ATTRS
 	help
 	  Say Y if you have a QLogic ISP1x80/1x160 SCSI host adapter.
 
diff -Nru a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
--- a/drivers/scsi/qla1280.c	Thu Mar  4 10:57:37 2004
+++ b/drivers/scsi/qla1280.c	Thu Mar  4 10:57:37 2004
@@ -353,6 +353,8 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_spi.h>
 #include "scsi.h"
 #else
 #include <linux/blk.h>
@@ -1447,6 +1449,7 @@
 	int status = 0;
 	struct nvram *nv;
 	unsigned long flags;
+	int is1x160;
 
 	ha = (struct scsi_qla_host *)device->host->hostdata;
 	nv = &ha->nvram;
@@ -1454,6 +1457,12 @@
 	if (qla1280_check_for_dead_scsi_bus(ha, bus))
 		return 1;
 
+	if (ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP12160 ||
+	    ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP10160)
+		is1x160 = 1;
+	else
+		is1x160 = 0;
+
 	if (device->tagged_supported &&
 	    (ha->bus_settings[bus].qtag_enables & (BIT_0 << target))) {
 		scsi_adjust_queue_depth(device, MSG_ORDERED_TAG,
@@ -1489,6 +1498,15 @@
 		status = qla1280_set_target_parameters(ha, bus, target);
 	qla1280_get_target_parameters(ha, device);
 	spin_unlock_irqrestore(HOST_LOCK, flags);
+
+	spi_period(device) = nv->bus[bus].target[target].sync_period;
+	if (is1x160)
+		spi_offset(device) = nv->bus[bus].target[target].flags.
+			flags1x160.sync_offset;
+	else
+		spi_offset(device) = nv->bus[bus].target[target].flags.
+			flags1x80.sync_offset;
+
 	return status;
 }
 
@@ -4755,6 +4773,7 @@
 	host->max_id = MAX_TARGETS;
 	host->max_sectors = 1024;
 	host->unique_id = host->host_no;
+	host->transportt = &spi_transport_template;
 
 #if LINUX_VERSION_CODE < 0x020545
 	host->select_queue_depths = qla1280_select_queue_depth;

--C+ts3FVlLX8+P6JN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="xprt-qla2xxx.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1636  -> 1.1637 
#	drivers/scsi/qla2xxx/qla_os.h	1.2     -> 1.3    
#	drivers/scsi/qla2xxx/qla_os.c	1.6     -> 1.7    
#	drivers/scsi/qla2xxx/Kconfig	1.5     -> 1.6    
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 04/03/04	mort@green.i.bork.org	1.1637
# Transport Attributes for qla2xxx
# --------------------------------------------
#
diff -Nru a/drivers/scsi/qla2xxx/Kconfig b/drivers/scsi/qla2xxx/Kconfig
--- a/drivers/scsi/qla2xxx/Kconfig	Thu Mar  4 11:05:55 2004
+++ b/drivers/scsi/qla2xxx/Kconfig	Thu Mar  4 11:05:55 2004
@@ -1,41 +1,41 @@
 config SCSI_QLA2XXX
 	tristate
 	default (SCSI && PCI)
-	depends on SCSI && PCI
+	depends on SCSI && PCI && SCSI_FC_ATTRS
 
 config SCSI_QLA21XX
 	tristate "QLogic ISP2100 host adapter family support"
-	depends on SCSI_QLA2XXX
+	depends on SCSI_QLA2XXX && SCSI_FC_ATTRS
 	---help---
 	This driver supports the QLogic 21xx (ISP2100) host adapter family.
 
 config SCSI_QLA22XX
 	tristate "QLogic ISP2200 host adapter family support"
-	depends on SCSI_QLA2XXX
+	depends on SCSI_QLA2XXX && SCSI_FC_ATTRS
 	---help---
 	This driver supports the QLogic 22xx (ISP2200) host adapter family.
 
 config SCSI_QLA2300
 	tristate "QLogic ISP2300 host adapter family support"
-	depends on SCSI_QLA2XXX
+	depends on SCSI_QLA2XXX && SCSI_FC_ATTRS
 	---help---
 	This driver supports the QLogic 2300 (ISP2300, and ISP2312) host
 	adapter family.
 
 config SCSI_QLA2322
 	tristate "QLogic ISP2322 host adapter family support"
-	depends on SCSI_QLA2XXX
+	depends on SCSI_QLA2XXX && SCSI_FC_ATTRS
 	---help---
 	This driver supports the QLogic 2322 (ISP2322) host adapter family.
 
 config SCSI_QLA6312
 	tristate "QLogic ISP6312 host adapter family support"
-	depends on SCSI_QLA2XXX
+	depends on SCSI_QLA2XXX && SCSI_FC_ATTRS
 	---help---
 	This driver supports the QLogic 6312 (ISP6312) host adapter family.
 
 config SCSI_QLA6322
 	tristate "QLogic ISP6322 host adapter family support"
-	depends on SCSI_QLA2XXX
+	depends on SCSI_QLA2XXX && SCSI_FC_ATTRS
 	---help---
 	This driver supports the QLogic 6322 (ISP6322) host adapter family.
diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	Thu Mar  4 11:05:55 2004
+++ b/drivers/scsi/qla2xxx/qla_os.c	Thu Mar  4 11:05:55 2004
@@ -1766,7 +1766,7 @@
 }
 
 /**************************************************************************
-* qla2x00_slave_configure
+* qla2xxx_slave_configure
 *
 * Description:
 **************************************************************************/
@@ -1774,6 +1774,7 @@
 qla2xxx_slave_configure(struct scsi_device *sdev)
 {
 	scsi_qla_host_t *ha = to_qla_host(sdev->host);
+	struct fc_port *fc;
 	int queue_depth;
 
 	if (IS_QLA2100(ha) || IS_QLA2200(ha))
@@ -1800,7 +1801,18 @@
 		     sdev->host->hostt->cmd_per_lun /* 3 */);
 	}
 
-	return (0);
+	list_for_each_entry(fc, &ha->fcports, list) {
+		if (fc->os_target_id == sdev->id) {
+			fc_port_name(sdev) = __be64_to_cpu(*(uint64_t *)fc->port_name);
+			fc_node_name(sdev) = __be64_to_cpu(*(uint64_t *)fc->node_name);
+			fc_port_id(sdev) = fc->d_id.b.domain << 16 |
+				fc->d_id.b.area << 8 |
+				fc->d_id.b.al_pa;
+			break;
+		}
+	}
+
+	return 0;
 }
 
 /**
@@ -2140,6 +2152,8 @@
 
 	sysfs_create_bin_file(&host->shost_gendev.kobj, &sysfs_fw_dump_attr);
 	sysfs_create_bin_file(&host->shost_gendev.kobj, &sysfs_nvram_attr);
+
+	host->transportt = &fc_transport_template;
 
 	qla_printk(KERN_INFO, ha, "\n"
 	    " QLogic Fibre Channel HBA Driver: %s\n"
diff -Nru a/drivers/scsi/qla2xxx/qla_os.h b/drivers/scsi/qla2xxx/qla_os.h
--- a/drivers/scsi/qla2xxx/qla_os.h	Thu Mar  4 11:05:55 2004
+++ b/drivers/scsi/qla2xxx/qla_os.h	Thu Mar  4 11:05:55 2004
@@ -62,6 +62,8 @@
 
 #include <scsi/scsicam.h>
 #include <scsi/scsi_ioctl.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_fc.h>
 
 //TODO Fix this!!!
 /*

--C+ts3FVlLX8+P6JN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="xprt.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1632  -> 1.1634 
#	include/scsi/scsi_device.h	1.11    -> 1.13   
#	drivers/scsi/hosts.c	1.96    -> 1.97   
#	include/scsi/scsi_host.h	1.13    -> 1.14   
#	drivers/scsi/scsi_sysfs.c	1.39    -> 1.41   
#	drivers/scsi/scsi_priv.h	1.31    -> 1.32   
#	drivers/scsi/scsi_scan.c	1.115   -> 1.117  
#	drivers/scsi/Makefile	1.54    -> 1.56   
#	drivers/scsi/Kconfig	1.56    -> 1.58   
#	               (new)	        -> 1.2     drivers/scsi/scsi_transport_fc.c
#	               (new)	        -> 1.2     include/scsi/scsi_transport.h
#	               (new)	        -> 1.2     include/scsi/scsi_transport_fc.h
#	               (new)	        -> 1.2     include/scsi/scsi_transport_spi.h
#	               (new)	        -> 1.2     drivers/scsi/scsi_transport_spi.c
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 04/03/02	mort@green.i.bork.org	1.1633
# scsi-transport-class-attr-core-v5-1.diff
# --------------------------------------------
# 04/03/03	mort@green.i.bork.org	1.1634
# Updates to the Transport Attributes core to include James Bottomley's
# patch.
# --------------------------------------------
#
diff -Nru a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig	Thu Mar  4 10:26:56 2004
+++ b/drivers/scsi/Kconfig	Thu Mar  4 10:26:56 2004
@@ -196,6 +196,25 @@
 	  there should be no noticeable performance impact as long as you have
 	  logging turned off.
 
+menu "SCSI Transport Attributes"
+	depends on SCSI
+
+config SCSI_SPI_ATTRS
+	tristate "Parallel SCSI (SPI) Transport Attributes"
+	depends on SCSI
+	help
+	  If you wish to export transport-specific information about
+	  each attached SCSI device to sysfs, say Y.  Otherwise, say N.
+
+config SCSI_FC_ATTRS
+	tristate "FiberChannel Transport Attributes"
+	depends on SCSI
+	help
+	  If you wish to export transport-specific information about
+	  each attached FiberChannel device to sysfs, say Y.
+	  Otherwise, say N.
+
+endmenu
 
 menu "SCSI low-level drivers"
 	depends on SCSI!=n
diff -Nru a/drivers/scsi/Makefile b/drivers/scsi/Makefile
--- a/drivers/scsi/Makefile	Thu Mar  4 10:26:56 2004
+++ b/drivers/scsi/Makefile	Thu Mar  4 10:26:56 2004
@@ -22,6 +22,14 @@
 
 obj-$(CONFIG_SCSI)		+= scsi_mod.o
 
+# --- NOTE ORDERING HERE ---
+# For kernel non-modular link, transport attributes need to
+# be initialised before drivers
+# --------------------------
+obj-$(CONFIG_SCSI_SPI_ATTRS)	+= scsi_transport_spi.o
+obj-$(CONFIG_SCSI_FC_ATTRS) 	+= scsi_transport_fc.o
+
+
 obj-$(CONFIG_SCSI_AMIGA7XX)	+= amiga7xx.o	53c7xx.o
 obj-$(CONFIG_A3000_SCSI)	+= a3000.o	wd33c93.o
 obj-$(CONFIG_A2091_SCSI)	+= a2091.o	wd33c93.o
@@ -130,7 +138,7 @@
 scsi_mod-$(CONFIG_SYSCTL)	+= scsi_sysctl.o
 scsi_mod-$(CONFIG_SCSI_PROC_FS)	+= scsi_proc.o
 scsi_mod-$(CONFIG_X86_PC9800)	+= scsi_pc98.o
-			
+
 sd_mod-objs	:= sd.o
 sr_mod-objs	:= sr.o sr_ioctl.o sr_vendor.o
 initio-objs	:= ini9100u.o i91uscsi.o
diff -Nru a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c	Thu Mar  4 10:26:56 2004
+++ b/drivers/scsi/hosts.c	Thu Mar  4 10:26:56 2004
@@ -32,6 +32,7 @@
 #include <linux/unistd.h>
 
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_transport.h>
 #include "scsi.h"
 
 #include "scsi_priv.h"
@@ -221,6 +222,11 @@
 	shost->max_channel = 0;
 	shost->max_id = 8;
 	shost->max_lun = 8;
+
+	/* Give each shost a default transportt if the driver
+	 * doesn't yet support Transport Attributes */
+	if (!shost->transportt) 
+		shost->transportt = &blank_transport_template;
 
 	/*
 	 * All drivers right now should be able to handle 12 byte
diff -Nru a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
--- a/drivers/scsi/scsi_priv.h	Thu Mar  4 10:26:56 2004
+++ b/drivers/scsi/scsi_priv.h	Thu Mar  4 10:26:56 2004
@@ -155,6 +155,7 @@
 extern int scsi_sysfs_add_host(struct Scsi_Host *);
 extern int scsi_sysfs_register(void);
 extern void scsi_sysfs_unregister(void);
+extern struct scsi_transport_template blank_transport_template;
 
 extern struct class sdev_class;
 extern struct bus_type scsi_bus_type;
diff -Nru a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	Thu Mar  4 10:26:56 2004
+++ b/drivers/scsi/scsi_scan.c	Thu Mar  4 10:26:56 2004
@@ -35,6 +35,7 @@
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_devinfo.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_transport.h>
 #include "scsi.h"
 
 #include "scsi_priv.h"
@@ -192,7 +193,7 @@
 	struct scsi_device *sdev, *device;
 	unsigned long flags;
 
-	sdev = kmalloc(sizeof(*sdev), GFP_ATOMIC);
+	sdev = kmalloc(sizeof(*sdev) + shost->transportt->size, GFP_ATOMIC);
 	if (!sdev)
 		goto out;
 
@@ -237,6 +238,11 @@
 			goto out_free_queue;
 	}
 
+	if (shost->transportt->setup) {
+		if (shost->transportt->setup(sdev))
+			goto out_cleanup_slave;
+	}
+
 	if (get_device(&sdev->host->shost_gendev)) {
 
 		device_initialize(&sdev->sdev_gendev);
@@ -253,8 +259,15 @@
 		snprintf(sdev->sdev_classdev.class_id, BUS_ID_SIZE,
 			 "%d:%d:%d:%d", sdev->host->host_no,
 			 sdev->channel, sdev->id, sdev->lun);
+
+		class_device_initialize(&sdev->transport_classdev);
+		sdev->transport_classdev.dev = &sdev->sdev_gendev;
+		sdev->transport_classdev.class = sdev->host->transportt->class;
+		snprintf(sdev->transport_classdev.class_id, BUS_ID_SIZE,
+			 "%d:%d:%d:%d", sdev->host->host_no,
+			 sdev->channel, sdev->id, sdev->lun);
 	} else
-		goto out_cleanup_slave;
+		goto out_cleanup_transport;
 
 	/*
 	 * If there are any same target siblings, add this to the
@@ -283,6 +296,9 @@
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	return sdev;
 
+out_cleanup_transport:
+	if (shost->transportt->cleanup)
+		shost->transportt->cleanup(sdev);
 out_cleanup_slave:
 	if (shost->hostt->slave_destroy)
 		shost->hostt->slave_destroy(sdev);
@@ -744,6 +760,8 @@
 	} else {
 		if (sdev->host->hostt->slave_destroy)
 			sdev->host->hostt->slave_destroy(sdev);
+		if (sdev->host->transportt->cleanup)
+			sdev->host->transportt->cleanup(sdev);
 		put_device(&sdev->sdev_gendev);
 	}
  out:
@@ -1300,5 +1318,7 @@
 
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
+	if (sdev->host->transportt->cleanup)
+		sdev->host->transportt->cleanup(sdev);
 	put_device(&sdev->sdev_gendev);
 }
diff -Nru a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c	Thu Mar  4 10:26:56 2004
+++ b/drivers/scsi/scsi_sysfs.c	Thu Mar  4 10:26:56 2004
@@ -13,6 +13,7 @@
 #include <linux/device.h>
 
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_transport.h>
 #include "scsi.h"
 
 #include "scsi_priv.h"
@@ -344,6 +345,7 @@
  **/
 int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 {
+	struct class_device_attribute **attrs;
 	int error = -EINVAL, i;
 
 	if (sdev->sdev_state != SDEV_CREATED)
@@ -363,6 +365,12 @@
 		goto clean_device;
 	}
 
+	if (sdev->transport_classdev.class) {
+		error = class_device_add(&sdev->transport_classdev);
+		if (error)
+			goto clean_device2;
+	}
+
 	get_device(&sdev->sdev_gendev);
 
 	if (sdev->host->hostt->sdev_attrs) {
@@ -388,10 +396,24 @@
 		}
 	}
 
+ 	if (sdev->transport_classdev.class) {
+ 		attrs = sdev->host->transportt->attrs;
+ 		for (i = 0; attrs[i]; i++) {
+ 			error = class_device_create_file(&sdev->transport_classdev,
+ 							 attrs[i]);
+ 			if (error) {
+ 				scsi_remove_device(sdev);
+				goto out;
+			}
+ 		}
+ 	}
+
  out:
 	return error;
 
-clean_device:
+ clean_device2:
+	class_device_del(&sdev->sdev_classdev);
+ clean_device:
 	sdev->sdev_state = SDEV_CANCEL;
 
 	device_del(&sdev->sdev_gendev);
@@ -409,9 +431,12 @@
 	if (sdev->sdev_state == SDEV_RUNNING || sdev->sdev_state == SDEV_CANCEL) {
 		sdev->sdev_state = SDEV_DEL;
 		class_device_unregister(&sdev->sdev_classdev);
+		class_device_unregister(&sdev->transport_classdev);
 		device_del(&sdev->sdev_gendev);
 		if (sdev->host->hostt->slave_destroy)
 			sdev->host->hostt->slave_destroy(sdev);
+		if (sdev->host->transportt->cleanup)
+			sdev->host->transportt->cleanup(sdev);
 		put_device(&sdev->sdev_gendev);
 	}
 }
@@ -498,3 +523,7 @@
 
 	return 0;
 }
+
+/* A blank transport template that is used in drivers that don't
+ * yet implement Transport Attributes */
+struct scsi_transport_template blank_transport_template = { 0, };
diff -Nru a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- /dev/null	Wed Dec 31 16:00:00 1969
+++ b/drivers/scsi/scsi_transport_fc.c	Thu Mar  4 10:26:56 2004
@@ -0,0 +1,104 @@
+/* 
+ *  FiberChannel transport specific attributes exported to sysfs.
+ *
+ *  Copyright (c) 2003 Silicon Graphics, Inc.  All rights reserved.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#include <linux/module.h>
+#include <linux/init.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_fc.h>
+
+static void transport_class_release(struct class_device *class_dev);
+
+struct class fc_transport_class = {
+	.name = "fc_transport",
+	.release = transport_class_release,
+};
+
+static __init int fc_transport_init(void)
+{
+	return class_register(&fc_transport_class);
+}
+
+static void __exit fc_transport_exit(void)
+{
+	class_unregister(&fc_transport_class);
+}
+
+static int fc_setup_transport_attrs(struct scsi_device *sdev)
+{
+	/* FIXME: Callback into the driver */
+	fc_node_name(sdev) = -1;
+	fc_port_name(sdev) = -1;
+	fc_port_id(sdev) = -1;
+
+	return 0;
+}
+
+static void transport_class_release(struct class_device *class_dev)
+{
+	struct scsi_device *sdev = transport_class_to_sdev(class_dev);
+	put_device(&sdev->sdev_gendev);
+}
+
+#define fc_transport_show_function(field, format_string, cast)			\
+static ssize_t									\
+show_fc_transport_##field (struct class_device *cdev, char *buf)		\
+{										\
+	struct scsi_device *sdev = transport_class_to_sdev(cdev);		\
+	struct fc_transport_attrs *tp;						\
+	tp = (struct fc_transport_attrs *)&sdev->transport_data;		\
+	return snprintf(buf, 20, format_string, cast tp->field);		\
+}
+
+#define fc_transport_rd_attr(field, format_string)				\
+	fc_transport_show_function(field, format_string, )			\
+static CLASS_DEVICE_ATTR( field, S_IRUGO, show_fc_transport_##field, NULL)
+
+#define fc_transport_rd_attr_cast(field, format_string, cast)			\
+	fc_transport_show_function(field, format_string, (cast))		\
+static CLASS_DEVICE_ATTR( field, S_IRUGO, show_fc_transport_##field, NULL)
+
+/* the FiberChannel Tranport Attributes: */
+fc_transport_rd_attr_cast(node_name, "0x%llx\n", unsigned long long);
+fc_transport_rd_attr_cast(port_name, "0x%llx\n", unsigned long long);
+fc_transport_rd_attr(port_id, "0x%06x\n");
+
+struct class_device_attribute *fc_transport_attrs[] = {
+	&class_device_attr_node_name,
+	&class_device_attr_port_name,
+	&class_device_attr_port_id,
+	NULL
+};
+
+struct scsi_transport_template fc_transport_template = {
+	.attrs = fc_transport_attrs,
+	.class = &fc_transport_class,
+	.setup = &fc_setup_transport_attrs,
+	.cleanup = NULL,
+	.size = sizeof(struct fc_transport_attrs) - sizeof(unsigned long),
+};
+EXPORT_SYMBOL(fc_transport_template);
+
+MODULE_AUTHOR("Martin Hicks");
+MODULE_DESCRIPTION("FC Transport Attributes");
+MODULE_LICENSE("GPL");
+
+module_init(fc_transport_init);
+module_exit(fc_transport_exit);
diff -Nru a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
--- /dev/null	Wed Dec 31 16:00:00 1969
+++ b/drivers/scsi/scsi_transport_spi.c	Thu Mar  4 10:26:56 2004
@@ -0,0 +1,97 @@
+/* 
+ *  Parallel SCSI (SPI) transport specific attributes exported to sysfs.
+ *
+ *  Copyright (c) 2003 Silicon Graphics, Inc.  All rights reserved.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#include <linux/module.h>
+#include <linux/init.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_spi.h>
+
+static void transport_class_release(struct class_device *class_dev);
+
+struct class spi_transport_class = {
+	.name = "spi_transport",
+	.release = transport_class_release,
+};
+
+static __init int spi_transport_init(void)
+{
+	return class_register(&spi_transport_class);
+}
+
+static void __exit spi_transport_exit(void)
+{
+	class_unregister(&spi_transport_class);
+}
+
+static int spi_setup_transport_attrs(struct scsi_device *sdev)
+{
+	/* FIXME: should callback into the driver to get these values */
+	spi_period(sdev) = -1;
+	spi_offset(sdev) = -1;
+
+	return 0;
+}
+
+static void transport_class_release(struct class_device *class_dev)
+{
+	struct scsi_device *sdev = transport_class_to_sdev(class_dev);
+	put_device(&sdev->sdev_gendev);
+}
+
+#define spi_transport_show_function(field, format_string)			\
+static ssize_t									\
+show_spi_transport_##field (struct class_device *cdev, char *buf)		\
+{										\
+	struct scsi_device *sdev = transport_class_to_sdev(cdev);		\
+	struct spi_transport_attrs *tp;						\
+	tp = (struct spi_transport_attrs *)&sdev->transport_data;		\
+	return snprintf(buf, 20, format_string, tp->field);			\
+}
+
+#define spi_transport_rd_attr(field, format_string)				\
+	spi_transport_show_function(field, format_string)			\
+static CLASS_DEVICE_ATTR( field, S_IRUGO, show_spi_transport_##field, NULL)
+
+/* The Parallel SCSI Tranport Attributes: */
+spi_transport_rd_attr(period, "%d\n");
+spi_transport_rd_attr(offset, "%d\n");
+
+struct class_device_attribute *spi_transport_attrs[] = {
+	&class_device_attr_period,
+	&class_device_attr_offset,
+	NULL
+};
+
+struct scsi_transport_template spi_transport_template = {
+	.attrs = spi_transport_attrs,
+	.class = &spi_transport_class,
+	.setup = &spi_setup_transport_attrs,
+	.cleanup = NULL,
+	.size = sizeof(struct spi_transport_attrs) - sizeof(unsigned long),
+};
+EXPORT_SYMBOL(spi_transport_template);
+
+MODULE_AUTHOR("Martin Hicks");
+MODULE_DESCRIPTION("SPI Transport Attributes");
+MODULE_LICENSE("GPL");
+
+module_init(spi_transport_init);
+module_exit(spi_transport_exit);
diff -Nru a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
--- a/include/scsi/scsi_device.h	Thu Mar  4 10:26:56 2004
+++ b/include/scsi/scsi_device.h	Thu Mar  4 10:26:56 2004
@@ -103,12 +103,17 @@
 	struct device		sdev_gendev;
 	struct class_device	sdev_classdev;
 
+	struct class_device	transport_classdev;
+
 	enum scsi_device_state sdev_state;
-};
+	unsigned long		transport_data[0];
+} __attribute__((aligned(sizeof(unsigned long))));
 #define	to_scsi_device(d)	\
 	container_of(d, struct scsi_device, sdev_gendev)
 #define	class_to_sdev(d)	\
 	container_of(d, struct scsi_device, sdev_classdev)
+#define transport_class_to_sdev(class_dev) \
+	container_of(class_dev, struct scsi_device, transport_classdev)
 
 extern struct scsi_device *scsi_add_device(struct Scsi_Host *,
 		uint, uint, uint);
diff -Nru a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
--- a/include/scsi/scsi_host.h	Thu Mar  4 10:26:56 2004
+++ b/include/scsi/scsi_host.h	Thu Mar  4 10:26:56 2004
@@ -11,6 +11,7 @@
 struct scsi_device;
 struct Scsi_Host;
 struct scsi_host_cmd_pool;
+struct scsi_transport_template;
 
 
 /*
@@ -395,6 +396,7 @@
 	unsigned int            eh_kill:1; /* set when killing the eh thread */
 	wait_queue_head_t       host_wait;
 	struct scsi_host_template *hostt;
+	struct scsi_transport_template *transportt;
 	volatile unsigned short host_busy;   /* commands actually active on low-level */
 	volatile unsigned short host_failed; /* commands that failed. */
     
diff -Nru a/include/scsi/scsi_transport.h b/include/scsi/scsi_transport.h
--- /dev/null	Wed Dec 31 16:00:00 1969
+++ b/include/scsi/scsi_transport.h	Thu Mar  4 10:26:56 2004
@@ -0,0 +1,41 @@
+/* 
+ *  Transport specific attributes.
+ *
+ *  Copyright (c) 2003 Silicon Graphics, Inc.  All rights reserved.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#ifndef SCSI_TRANSPORT_H
+#define SCSI_TRANSPORT_H
+
+struct scsi_transport_template {
+	/* The NULL terminated list of transport attributes
+	 * that should be exported.
+	 */
+	struct class_device_attribute **attrs;
+
+	/* The transport class that the device is in */
+	struct class *class;
+
+	/* Constructor/Destructor functions */
+	int (* setup)(struct scsi_device *);
+	void (* cleanup)(struct scsi_device *);
+	/* The size of the specific transport attribute structure (a
+	 * space of this size will be left at the end of the
+	 * scsi_device structure */
+	int	size;
+};
+
+#endif /* SCSI_TRANSPORT_H */
diff -Nru a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
--- /dev/null	Wed Dec 31 16:00:00 1969
+++ b/include/scsi/scsi_transport_fc.h	Thu Mar  4 10:26:56 2004
@@ -0,0 +1,38 @@
+/* 
+ *  FiberChannel transport specific attributes exported to sysfs.
+ *
+ *  Copyright (c) 2003 Silicon Graphics, Inc.  All rights reserved.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#ifndef SCSI_TRANSPORT_FC_H
+#define SCSI_TRANSPORT_FC_H
+
+struct scsi_transport_template;
+
+struct fc_transport_attrs {
+	int port_id;
+	uint64_t node_name;
+	uint64_t port_name;
+};
+
+/* accessor functions */
+#define fc_port_id(x)	(((struct fc_transport_attrs *)&(x)->transport_data)->port_id)
+#define fc_node_name(x)	(((struct fc_transport_attrs *)&(x)->transport_data)->node_name)
+#define fc_port_name(x)	(((struct fc_transport_attrs *)&(x)->transport_data)->port_name)
+
+extern struct scsi_transport_template fc_transport_template;
+
+#endif /* SCSI_TRANSPORT_FC_H */
diff -Nru a/include/scsi/scsi_transport_spi.h b/include/scsi/scsi_transport_spi.h
--- /dev/null	Wed Dec 31 16:00:00 1969
+++ b/include/scsi/scsi_transport_spi.h	Thu Mar  4 10:26:56 2004
@@ -0,0 +1,38 @@
+/* 
+ *  Parallel SCSI (SPI) transport specific attributes exported to sysfs.
+ *
+ *  Copyright (c) 2003 Silicon Graphics, Inc.  All rights reserved.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#ifndef SCSI_TRANSPORT_SPI_H
+#define SCSI_TRANSPORT_SPI_H
+
+#include <linux/config.h>
+
+struct scsi_transport_template;
+
+struct spi_transport_attrs {
+	int period;
+	int offset;
+};
+
+/* accessor functions */
+#define spi_period(x)	(((struct spi_transport_attrs *)&(x)->transport_data)->period)
+#define spi_offset(x)	(((struct spi_transport_attrs *)&(x)->transport_data)->offset)
+
+extern struct scsi_transport_template spi_transport_template;
+
+#endif /* SCSI_TRANSPORT_SPI_H */

--C+ts3FVlLX8+P6JN--
