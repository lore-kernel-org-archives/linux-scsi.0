From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 1/7] scsi_dh: add skeleton for SCSI Device
	Handlers
Date: Tue, 01 Apr 2008 15:51:39 -0700
Message-ID: <20080401225139.2124.25928.sendpatchset@localhost.localdomain>
References: <20080401225133.2124.62025.sendpatchset@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080401225133.2124.62025.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: andmike@us.ibm.com, michaelc@cs.wisc.edu, asson_ronald@emc.com, James.Bottomley@HansenPartnership.com, Benoit_Arthur@emc.com, jens.axboe@oracle.com, agk@redhat.com
List-Id: linux-scsi@vger.kernel.org

Subject: scsi_dh: add skeleton for SCSI Device Handlers

From: Chandra Seetharaman <sekharan@us.ibm.com>

Add base support to the SCSI subsystem for SCSI device handlers.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---

 drivers/scsi/Kconfig                  |    2 	2 +	0 -	0 !
 drivers/scsi/Makefile                 |    1 	1 +	0 -	0 !
 drivers/scsi/device_handler/Kconfig   |   12 	12 +	0 -	0 !
 drivers/scsi/device_handler/Makefile  |    4 	4 +	0 -	0 !
 drivers/scsi/device_handler/scsi_dh.c |  147 	147 +	0 -	0 !
 drivers/scsi/scsi_error.c             |   11 	11 +	0 -	0 !
 drivers/scsi/scsi_lib.c               |    8 	8 +	0 -	0 !
 include/scsi/scsi.h                   |    1 	1 +	0 -	0 !
 include/scsi/scsi_device.h            |   22 	22 +	0 -	0 !
 include/scsi/scsi_dh.h                |   58 	58 +	0 -	0 !
 10 files changed, 266 insertions(+)

Index: linux-2.6.25-rc2-mm1/drivers/scsi/Kconfig
===================================================================
--- linux-2.6.25-rc2-mm1.orig/drivers/scsi/Kconfig	2008-03-14 10:48:26.000000000 -0700
+++ linux-2.6.25-rc2-mm1/drivers/scsi/Kconfig	2008-03-14 10:49:21.000000000 -0700
@@ -1749,4 +1749,6 @@
 
 source "drivers/scsi/pcmcia/Kconfig"
 
+source "drivers/scsi/device_handler/Kconfig"
+
 endmenu
Index: linux-2.6.25-rc2-mm1/drivers/scsi/Makefile
===================================================================
--- linux-2.6.25-rc2-mm1.orig/drivers/scsi/Makefile	2008-03-14 10:48:26.000000000 -0700
+++ linux-2.6.25-rc2-mm1/drivers/scsi/Makefile	2008-03-14 10:49:21.000000000 -0700
@@ -34,6 +34,7 @@
 obj-$(CONFIG_SCSI_SAS_ATTRS)	+= scsi_transport_sas.o
 obj-$(CONFIG_SCSI_SAS_LIBSAS)	+= libsas/
 obj-$(CONFIG_SCSI_SRP_ATTRS)	+= scsi_transport_srp.o
+obj-$(CONFIG_SCSI_DH)		+= device_handler/
 
 obj-$(CONFIG_ISCSI_TCP) 	+= libiscsi.o	iscsi_tcp.o
 obj-$(CONFIG_INFINIBAND_ISER) 	+= libiscsi.o
Index: linux-2.6.25-rc2-mm1/drivers/scsi/device_handler/Kconfig
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.25-rc2-mm1/drivers/scsi/device_handler/Kconfig	2008-03-14 13:40:57.000000000 -0700
@@ -0,0 +1,12 @@
+#
+# SCSI Device Handler configuration
+#
+
+menuconfig SCSI_DH
+	tristate "SCSI Device Handlers"
+	depends on SCSI
+	default n
+	help
+	  SCSI Device Handlers provide device specific support for
+	  devices utilized in multipath configurations. Say Y here to
+	  select support for specific hardware.
Index: linux-2.6.25-rc2-mm1/drivers/scsi/device_handler/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.25-rc2-mm1/drivers/scsi/device_handler/Makefile	2008-03-14 13:40:57.000000000 -0700
@@ -0,0 +1,4 @@
+#
+# SCSI Device Handler
+#
+obj-$(CONFIG_SCSI_DH)		+= scsi_dh.o
Index: linux-2.6.25-rc2-mm1/drivers/scsi/scsi_error.c
===================================================================
--- linux-2.6.25-rc2-mm1.orig/drivers/scsi/scsi_error.c	2008-03-14 10:48:27.000000000 -0700
+++ linux-2.6.25-rc2-mm1/drivers/scsi/scsi_error.c	2008-03-14 10:49:21.000000000 -0700
@@ -298,6 +298,7 @@
  */
 static int scsi_check_sense(struct scsi_cmnd *scmd)
 {
+	struct scsi_device *sdev = scmd->device;
 	struct scsi_sense_hdr sshdr;
 
 	if (! scsi_command_normalize_sense(scmd, &sshdr))
@@ -306,6 +307,16 @@
 	if (scsi_sense_is_deferred(&sshdr))
 		return NEEDS_RETRY;
 
+	if (sdev->scsi_dh_data && sdev->scsi_dh_data->scsi_dh &&
+			sdev->scsi_dh_data->scsi_dh->check_sense) {
+		int rc;
+
+		rc = sdev->scsi_dh_data->scsi_dh->check_sense(sdev, &sshdr);
+		if (rc != SCSI_RETURN_NOT_HANDLED)
+			return rc;
+		/* handler does not care. Drop down to default handling */
+	}
+
 	/*
 	 * Previous logic looked for FILEMARK, EOM or ILI which are
 	 * mainly associated with tapes and returned SUCCESS.
Index: linux-2.6.25-rc2-mm1/include/scsi/scsi_device.h
===================================================================
--- linux-2.6.25-rc2-mm1.orig/include/scsi/scsi_device.h	2008-03-14 10:48:31.000000000 -0700
+++ linux-2.6.25-rc2-mm1/include/scsi/scsi_device.h	2008-03-14 10:49:21.000000000 -0700
@@ -161,9 +161,29 @@
 
 	struct execute_work	ew; /* used to get process context on put */
 
+	struct scsi_dh_data	*scsi_dh_data;
 	enum scsi_device_state sdev_state;
 	unsigned long		sdev_data[0];
 } __attribute__((aligned(sizeof(unsigned long))));
+
+struct scsi_device_handler {
+	/* Used by the infrastructure */
+	struct list_head list; /* list of scsi_device_handlers */
+	struct notifier_block nb;
+
+	/* Filled by the hardware handler */
+	struct module *module;
+	const char *name;
+	int (*check_sense)(struct scsi_device *, struct scsi_sense_hdr *);
+	int (*activate)(struct scsi_device *);
+	int (*prep_fn)(struct scsi_device *, struct request *);
+};
+
+struct scsi_dh_data {
+	struct scsi_device_handler *scsi_dh;
+	char buf[0];
+};
+
 #define	to_scsi_device(d)	\
 	container_of(d, struct scsi_device, sdev_gendev)
 #define	class_to_sdev(d)	\
@@ -229,7 +249,9 @@
 		uint, uint, uint, void *hostdata);
 extern int scsi_add_device(struct Scsi_Host *host, uint channel,
 			   uint target, uint lun);
+extern int scsi_register_device_handler(struct scsi_device_handler *scsi_dh);
 extern void scsi_remove_device(struct scsi_device *);
+extern int scsi_unregister_device_handler(struct scsi_device_handler *scsi_dh);
 
 extern int scsi_device_get(struct scsi_device *);
 extern void scsi_device_put(struct scsi_device *);
Index: linux-2.6.25-rc2-mm1/drivers/scsi/device_handler/scsi_dh.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.25-rc2-mm1/drivers/scsi/device_handler/scsi_dh.c	2008-03-14 13:42:24.000000000 -0700
@@ -0,0 +1,151 @@
+/*
+ * SCSI device handler infrastruture.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright IBM Corporation, 2007
+ *      Authors:
+ *               Chandra Seetharaman <sekharan@us.ibm.com>
+ *               Mike Anderson <andmike@linux.vnet.ibm.com>
+ */
+
+#include <scsi/scsi_dh.h>
+#include "../scsi_priv.h"
+
+static DEFINE_SPINLOCK(list_lock);
+static LIST_HEAD(scsi_dh_list);
+
+static struct scsi_device_handler *get_device_handler(const char *name)
+{
+	struct scsi_device_handler *tmp, *found = NULL;
+
+	spin_lock(&list_lock);
+	list_for_each_entry(tmp, &scsi_dh_list, list) {
+		if (!strcmp(tmp->name, name)) {
+			found = tmp;
+			break;
+		}
+	}
+	spin_unlock(&list_lock);
+	return found;
+}
+
+static int scsi_dh_notifier_add(struct device *dev, void *data)
+{
+	struct scsi_device_handler *scsi_dh = data;
+
+	scsi_dh->nb.notifier_call(&scsi_dh->nb, BUS_NOTIFY_ADD_DEVICE, dev);
+	return 0;
+}
+
+/*
+ * scsi_register_device_handler - register a device handler personality
+ *      module.
+ * @scsi_dh - device handler to be registered.
+ *
+ * Returns 0 on success, -EBUSY if handler already registered.
+ */
+int scsi_register_device_handler(struct scsi_device_handler *scsi_dh)
+{
+	int ret = -EBUSY;
+	struct scsi_device_handler *tmp;
+
+	tmp = get_device_handler(scsi_dh->name);
+	if (tmp)
+		goto done;
+
+	ret = bus_register_notifier(&scsi_bus_type, &scsi_dh->nb);
+
+	bus_for_each_dev(&scsi_bus_type, NULL, scsi_dh, scsi_dh_notifier_add);
+	spin_lock(&list_lock);
+	list_add(&scsi_dh->list, &scsi_dh_list);
+	spin_unlock(&list_lock);
+
+done:
+	return ret;
+}
+EXPORT_SYMBOL_GPL(scsi_register_device_handler);
+
+static int scsi_dh_notifier_remove(struct device *dev, void *data)
+{
+	struct scsi_device_handler *scsi_dh = data;
+
+	scsi_dh->nb.notifier_call(&scsi_dh->nb, BUS_NOTIFY_DEL_DEVICE, dev);
+	return 0;
+}
+
+/*
+ * scsi_unregister_device_handler - register a device handler personality
+ *      module.
+ * @scsi_dh - device handler to be unregistered.
+ *
+ * Returns 0 on success, -ENODEV if handler not registered.
+ */
+int scsi_unregister_device_handler(struct scsi_device_handler *scsi_dh)
+{
+	int ret = -ENODEV;
+	struct scsi_device_handler *tmp;
+
+	tmp = get_device_handler(scsi_dh->name);
+	if (!tmp)
+		goto done;
+
+	ret = bus_unregister_notifier(&scsi_bus_type, &scsi_dh->nb);
+
+	bus_for_each_dev(&scsi_bus_type, NULL, scsi_dh,
+					scsi_dh_notifier_remove);
+	spin_lock(&list_lock);
+	list_del(&scsi_dh->list);
+	spin_unlock(&list_lock);
+
+done:
+	return ret;
+}
+EXPORT_SYMBOL_GPL(scsi_unregister_device_handler);
+
+/*
+ * scsi_dh_activate - activate the path associated with the scsi_device
+ *      corresponding to the given request queue.
+ * @q - Request queue that is associated with the scsi_device to be
+ *      activated.
+ */
+int scsi_dh_activate(struct request_queue *q)
+{
+	int err = 0;
+	unsigned long flags;
+	struct scsi_device *sdev;
+	struct scsi_device_handler *scsi_dh = NULL;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	sdev = q->queuedata;
+	if (sdev && sdev->scsi_dh_data)
+		scsi_dh = sdev->scsi_dh_data->scsi_dh;
+	if (!scsi_dh || !get_device(&sdev->sdev_gendev))
+		err = SCSI_DH_NOSYS;
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	if (err)
+		return err;
+
+	if (scsi_dh->activate)
+		err = scsi_dh->activate(sdev);
+	put_device(&sdev->sdev_gendev);
+	return err;
+}
+EXPORT_SYMBOL_GPL(scsi_dh_activate);
+
+MODULE_DESCRIPTION("SCSI device handler");
+MODULE_AUTHOR("Chandra Seetharaman <sekharan@us.ibm.com>");
+MODULE_LICENSE("GPL");
Index: linux-2.6.25-rc2-mm1/include/scsi/scsi_dh.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.25-rc2-mm1/include/scsi/scsi_dh.h	2008-03-14 10:49:21.000000000 -0700
@@ -0,0 +1,58 @@
+/*
+ * Header file for SCSI device handler infrastruture.
+ *
+ * Modified version of patches posted by Mike Christie <michaelc@cs.wisc.edu>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright IBM Corporation, 2007
+ *      Authors:
+ *               Chandra Seetharaman <sekharan@us.ibm.com>
+ *               Mike Anderson <andmike@linux.vnet.ibm.com>
+ */
+
+#include <scsi/scsi_device.h>
+
+enum {
+	SCSI_DH_OK = 0,
+	/*
+	 * device errors
+	 */
+	SCSI_DH_DEV_FAILED,	/* generic device error */
+	SCSI_DH_DEV_TEMP_BUSY,
+	SCSI_DH_DEVICE_MAX,	/* max device blkerr definition */
+
+	/*
+	 * transport errors
+	 */
+	SCSI_DH_NOTCONN = SCSI_DH_DEVICE_MAX + 1,
+	SCSI_DH_CONN_FAILURE,
+	SCSI_DH_TRANSPORT_MAX,	/* max transport blkerr definition */
+
+	/*
+	 * driver and generic errors
+	 */
+	SCSI_DH_IO = SCSI_DH_TRANSPORT_MAX + 1,	/* generic error */
+	SCSI_DH_INVALID_IO,
+	SCSI_DH_RETRY,		/* retry the req, but not immediately */
+	SCSI_DH_IMM_RETRY,	/* immediately retry the req */
+	SCSI_DH_TIMED_OUT,
+	SCSI_DH_RES_TEMP_UNAVAIL,
+	SCSI_DH_DEV_OFFLINED,
+	SCSI_DH_NOSYS,
+	SCSI_DH_DRIVER_MAX,
+};
+
+extern int scsi_dh_activate(struct request_queue *);
Index: linux-2.6.25-rc2-mm1/drivers/scsi/scsi_lib.c
===================================================================
--- linux-2.6.25-rc2-mm1.orig/drivers/scsi/scsi_lib.c	2008-03-14 10:48:27.000000000 -0700
+++ linux-2.6.25-rc2-mm1/drivers/scsi/scsi_lib.c	2008-03-14 10:49:21.000000000 -0700
@@ -1158,6 +1158,14 @@
 
 	if (ret != BLKPREP_OK)
 		return ret;
+
+	if (unlikely(sdev->scsi_dh_data && sdev->scsi_dh_data->scsi_dh
+			 && sdev->scsi_dh_data->scsi_dh->prep_fn)) {
+		ret = sdev->scsi_dh_data->scsi_dh->prep_fn(sdev, req);
+		if (ret != BLKPREP_OK)
+			return ret;
+	}
+
 	/*
 	 * Filesystem requests must transfer data.
 	 */
Index: linux-2.6.25-rc2-mm1/include/scsi/scsi.h
===================================================================
--- linux-2.6.25-rc2-mm1.orig/include/scsi/scsi.h	2008-03-14 10:48:31.000000000 -0700
+++ linux-2.6.25-rc2-mm1/include/scsi/scsi.h	2008-03-14 10:49:21.000000000 -0700
@@ -374,6 +374,7 @@
 #define SOFT_ERROR      0x2005
 #define ADD_TO_MLQUEUE  0x2006
 #define TIMEOUT_ERROR   0x2007
+#define SCSI_RETURN_NOT_HANDLED   0x2008
 
 /*
  * Midlevel queue return values.
Index: linux-2.6.25-rc2-mm1/drivers/scsi/scsi_sysfs.c
===================================================================
--- linux-2.6.25-rc2-mm1.orig/drivers/scsi/scsi_sysfs.c	2008-03-14 10:48:27.000000000 -0700
+++ linux-2.6.25-rc2-mm1/drivers/scsi/scsi_sysfs.c	2008-03-14 11:11:38.000000000 -0700
@@ -397,6 +397,7 @@
 	.resume		= scsi_bus_resume,
 	.remove		= scsi_bus_remove,
 };
+EXPORT_SYMBOL_GPL(scsi_bus_type);
 
 int scsi_sysfs_register(void)
 {

-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------
