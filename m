From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 4/9] scsi_dh: add skeleton for SCSI Device Handlers
Date: Wed, 23 Jan 2008 16:31:15 -0800
Message-ID: <20080124003115.18871.42778.sendpatchset@localhost.localdomain>
References: <20080124003010.18871.84095.sendpatchset@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:41537 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbYAXAbR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jan 2008 19:31:17 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e32.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m0NNS41u003990
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jan 2008 18:28:04 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0O0VGY9081636
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jan 2008 17:31:17 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m0O0VGci031133
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jan 2008 17:31:16 -0700
In-Reply-To: <20080124003010.18871.84095.sendpatchset@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: andmike@us.ibm.com, michaelc@cs.wisc.edu, Chandra Seetharaman <sekharan@us.ibm.com>, jens.axboe@oracle.com

Subject: scsi_dh: add skeleton for SCSI Device Handlers

From: Mike Anderson <andmike@linux.vnet.ibm.com>

Add base support to the SCSI subsystem for SCSI device handlers.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---

 drivers/scsi/Kconfig                 |    2 	2 +	0 -	0 !
 drivers/scsi/Makefile                |    1 	1 +	0 -	0 !
 drivers/scsi/device_handler/Kconfig  |   16 	16 +	0 -	0 !
 drivers/scsi/device_handler/Makefile |    3 	3 +	0 -	0 !
 drivers/scsi/scsi_error.c            |   10 	10 +	0 -	0 !
 drivers/scsi/scsi_sysfs.c            |   43 	43 +	0 -	0 !
 include/scsi/scsi_device.h           |    2 	2 +	0 -	0 !
 7 files changed, 77 insertions(+)

Index: linux-2.6.24-rc8/drivers/scsi/Kconfig
===================================================================
--- linux-2.6.24-rc8.orig/drivers/scsi/Kconfig
+++ linux-2.6.24-rc8/drivers/scsi/Kconfig
@@ -1822,4 +1822,6 @@ endif # SCSI_LOWLEVEL
 
 source "drivers/scsi/pcmcia/Kconfig"
 
+source "drivers/scsi/device_handler/Kconfig"
+
 endmenu
Index: linux-2.6.24-rc8/drivers/scsi/Makefile
===================================================================
--- linux-2.6.24-rc8.orig/drivers/scsi/Makefile
+++ linux-2.6.24-rc8/drivers/scsi/Makefile
@@ -34,6 +34,7 @@ obj-$(CONFIG_SCSI_ISCSI_ATTRS)	+= scsi_t
 obj-$(CONFIG_SCSI_SAS_ATTRS)	+= scsi_transport_sas.o
 obj-$(CONFIG_SCSI_SAS_LIBSAS)	+= libsas/
 obj-$(CONFIG_SCSI_SRP_ATTRS)	+= scsi_transport_srp.o
+obj-$(CONFIG_SCSI_DH)		+= device_handler/
 
 obj-$(CONFIG_ISCSI_TCP) 	+= libiscsi.o	iscsi_tcp.o
 obj-$(CONFIG_INFINIBAND_ISER) 	+= libiscsi.o
Index: linux-2.6.24-rc8/drivers/scsi/device_handler/Kconfig
===================================================================
--- /dev/null
+++ linux-2.6.24-rc8/drivers/scsi/device_handler/Kconfig
@@ -0,0 +1,16 @@
+#
+# SCSI Device Handler configuration
+#
+
+menuconfig SCSI_DH
+	bool "SCSI Device Handlers"
+	depends on SCSI!=n
+	default n
+	help
+	  SCSI Device Handlers provide device specific support for
+	  devices utilized in multipath configurations. Say Y here to
+	  select support for specific hardware.
+
+if SCSI_DH
+
+endif #SCSI_DH
Index: linux-2.6.24-rc8/drivers/scsi/device_handler/Makefile
===================================================================
--- /dev/null
+++ linux-2.6.24-rc8/drivers/scsi/device_handler/Makefile
@@ -0,0 +1,3 @@
+#
+# SCSI Device Handler
+#
Index: linux-2.6.24-rc8/drivers/scsi/scsi_error.c
===================================================================
--- linux-2.6.24-rc8.orig/drivers/scsi/scsi_error.c
+++ linux-2.6.24-rc8/drivers/scsi/scsi_error.c
@@ -298,6 +298,7 @@ static inline void scsi_eh_prt_fail_stat
  */
 static int scsi_check_sense(struct scsi_cmnd *scmd)
 {
+	struct scsi_device *sdev = scmd->device;
 	struct scsi_sense_hdr sshdr;
 
 	if (! scsi_command_normalize_sense(scmd, &sshdr))
@@ -306,6 +307,15 @@ static int scsi_check_sense(struct scsi_
 	if (scsi_sense_is_deferred(&sshdr))
 		return NEEDS_RETRY;
 
+	if (sdev->sdev_dh && sdev->sdev_dh->check_sense) {
+		int rc;
+
+		rc = sdev->sdev_dh->check_sense(sdev, &sshdr);
+		if (rc != SUCCESS)
+			return rc;
+		/* handler does not care. Drop down to default handling */
+	}
+
 	/*
 	 * Previous logic looked for FILEMARK, EOM or ILI which are
 	 * mainly associated with tapes and returned SUCCESS.
Index: linux-2.6.24-rc8/drivers/scsi/scsi_sysfs.c
===================================================================
--- linux-2.6.24-rc8.orig/drivers/scsi/scsi_sysfs.c
+++ linux-2.6.24-rc8/drivers/scsi/scsi_sysfs.c
@@ -951,6 +951,49 @@ int scsi_register_interface(struct class
 }
 EXPORT_SYMBOL(scsi_register_interface);
 
+static int scsi_dh_notifier_add(struct device *dev, void *data)
+{
+	struct scsi_device_handler *sdev_dh = data;
+
+	sdev_dh->nb.notifier_call(&sdev_dh->nb, BUS_NOTIFY_ADD_DEVICE, dev);
+
+	return 0;
+}
+
+int scsi_register_device_handler(struct scsi_device_handler *sdev_dh)
+{
+	int ret;
+
+	ret = bus_register_notifier(&scsi_bus_type, &sdev_dh->nb);
+
+	bus_for_each_dev(&scsi_bus_type, NULL, sdev_dh, scsi_dh_notifier_add);
+
+	return ret;
+}
+EXPORT_SYMBOL(scsi_register_device_handler);
+
+static int scsi_dh_notifier_remove(struct device *dev, void *data)
+{
+	struct scsi_device_handler *sdev_dh = data;
+
+	sdev_dh->nb.notifier_call(&sdev_dh->nb, BUS_NOTIFY_DEL_DEVICE, dev);
+
+	return 0;
+}
+
+int scsi_unregister_device_handler(struct scsi_device_handler *sdev_dh)
+{
+	int ret;
+
+	ret = bus_unregister_notifier(&scsi_bus_type, &sdev_dh->nb);
+
+	bus_for_each_dev(&scsi_bus_type, NULL, sdev_dh,
+					scsi_dh_notifier_remove);
+
+	return ret;
+}
+EXPORT_SYMBOL(scsi_unregister_device_handler);
+
 
 static struct class_device_attribute *class_attr_overridden(
 		struct class_device_attribute **attrs,
Index: linux-2.6.24-rc8/include/scsi/scsi_device.h
===================================================================
--- linux-2.6.24-rc8.orig/include/scsi/scsi_device.h
+++ linux-2.6.24-rc8/include/scsi/scsi_device.h
@@ -241,7 +241,9 @@ extern struct scsi_device *__scsi_add_de
 		uint, uint, uint, void *hostdata);
 extern int scsi_add_device(struct Scsi_Host *host, uint channel,
 			   uint target, uint lun);
+extern int scsi_register_device_handler(struct scsi_device_handler *sdev_dh);
 extern void scsi_remove_device(struct scsi_device *);
+extern int scsi_unregister_device_handler(struct scsi_device_handler *sdev_dh);
 
 extern int scsi_device_get(struct scsi_device *);
 extern void scsi_device_put(struct scsi_device *);

-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------
