From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 1/7] scsi_dh: add skeleton for SCSI Device Handlers
Date: Wed, 27 Feb 2008 17:08:34 -0800
Message-ID: <20080228010834.5535.41038.sendpatchset@localhost.localdomain>
References: <20080228010828.5535.74088.sendpatchset@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:43399 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760978AbYB1BIh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Feb 2008 20:08:37 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1S18bCf003186
	for <linux-scsi@vger.kernel.org>; Wed, 27 Feb 2008 20:08:37 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1S18aj0168838
	for <linux-scsi@vger.kernel.org>; Wed, 27 Feb 2008 18:08:36 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1S18Zlq030877
	for <linux-scsi@vger.kernel.org>; Wed, 27 Feb 2008 18:08:36 -0700
In-Reply-To: <20080228010828.5535.74088.sendpatchset@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: andmike@us.ibm.com, michaelc@cs.wisc.edu, Chandra Seetharaman <sekharan@us.ibm.com>, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, agk@redhat.com

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
 drivers/scsi/device_handler/scsi_dh.c |  146 	146 +	0 -	0 !
 drivers/scsi/scsi_error.c             |   10 	10 +	0 -	0 !
 drivers/scsi/scsi_lib.c               |    5 	5 +	0 -	0 !
 include/scsi/scsi_device.h            |   18 	18 +	0 -	0 !
 include/scsi/scsi_dh.h                |   58 	58 +	0 -	0 !
 9 files changed, 256 insertions(+)

Index: linux-2.6.25-rc2-mm1/drivers/scsi/Kconfig
===================================================================
--- linux-2.6.25-rc2-mm1.orig/drivers/scsi/Kconfig
+++ linux-2.6.25-rc2-mm1/drivers/scsi/Kconfig
@@ -1749,4 +1749,6 @@ endif # SCSI_LOWLEVEL
 
 source "drivers/scsi/pcmcia/Kconfig"
 
+source "drivers/scsi/device_handler/Kconfig"
+
 endmenu
Index: linux-2.6.25-rc2-mm1/drivers/scsi/Makefile
===================================================================
--- linux-2.6.25-rc2-mm1.orig/drivers/scsi/Makefile
+++ linux-2.6.25-rc2-mm1/drivers/scsi/Makefile
@@ -34,6 +34,7 @@ obj-$(CONFIG_SCSI_ISCSI_ATTRS)	+= scsi_t
 obj-$(CONFIG_SCSI_SAS_ATTRS)	+= scsi_transport_sas.o
 obj-$(CONFIG_SCSI_SAS_LIBSAS)	+= libsas/
 obj-$(CONFIG_SCSI_SRP_ATTRS)	+= scsi_transport_srp.o
+obj-$(CONFIG_SCSI_DH)		+= device_handler/
 
 obj-$(CONFIG_ISCSI_TCP) 	+= libiscsi.o	iscsi_tcp.o
 obj-$(CONFIG_INFINIBAND_ISER) 	+= libiscsi.o
Index: linux-2.6.25-rc2-mm1/drivers/scsi/device_handler/Kconfig
===================================================================
--- /dev/null
+++ linux-2.6.25-rc2-mm1/drivers/scsi/device_handler/Kconfig
@@ -0,0 +1,12 @@
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
Index: linux-2.6.25-rc2-mm1/drivers/scsi/device_handler/Makefile
===================================================================
--- /dev/null
+++ linux-2.6.25-rc2-mm1/drivers/scsi/device_handler/Makefile
@@ -0,0 +1,4 @@
+#
+# SCSI Device Handler
+#
+obj-$(CONFIG_SCSI_DH)		+= scsi_dh.o
Index: linux-2.6.25-rc2-mm1/drivers/scsi/scsi_error.c
===================================================================
--- linux-2.6.25-rc2-mm1.orig/drivers/scsi/scsi_error.c
+++ linux-2.6.25-rc2-mm1/drivers/scsi/scsi_error.c
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
Index: linux-2.6.25-rc2-mm1/include/scsi/scsi_device.h
===================================================================
--- linux-2.6.25-rc2-mm1.orig/include/scsi/scsi_device.h
+++ linux-2.6.25-rc2-mm1/include/scsi/scsi_device.h
@@ -161,9 +161,25 @@ struct scsi_device {
 
 	struct execute_work	ew; /* used to get process context on put */
 
+	struct scsi_device_handler *sdev_dh;
+	void			*sdev_dh_data;
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
+	int (*prep_fn)(struct scsi_device *);
+};
+
 #define	to_scsi_device(d)	\
 	container_of(d, struct scsi_device, sdev_gendev)
 #define	class_to_sdev(d)	\
@@ -229,7 +245,9 @@ extern struct scsi_device *__scsi_add_de
 		uint, uint, uint, void *hostdata);
 extern int scsi_add_device(struct Scsi_Host *host, uint channel,
 			   uint target, uint lun);
+extern int scsi_register_device_handler(struct scsi_device_handler *sdev_dh);
 extern void scsi_remove_device(struct scsi_device *);
+extern int scsi_unregister_device_handler(struct scsi_device_handler *sdev_dh);
 
 extern int scsi_device_get(struct scsi_device *);
 extern void scsi_device_put(struct scsi_device *);
Index: linux-2.6.25-rc2-mm1/drivers/scsi/device_handler/scsi_dh.c
===================================================================
--- /dev/null
+++ linux-2.6.25-rc2-mm1/drivers/scsi/device_handler/scsi_dh.c
@@ -0,0 +1,146 @@
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
+	struct scsi_device_handler *sdev_dh = data;
+
+	sdev_dh->nb.notifier_call(&sdev_dh->nb, BUS_NOTIFY_ADD_DEVICE, dev);
+	return 0;
+}
+
+/*
+ * scsi_register_device_handler - register a device handler personality
+ *      module.
+ * @sdev_dh - device handler to be registered.
+ *
+ * Returns 0 on success, -EBUSY if handler already registered.
+ */
+int scsi_register_device_handler(struct scsi_device_handler *sdev_dh)
+{
+	int ret = -EBUSY;
+	struct scsi_device_handler *tmp;
+
+	tmp = get_device_handler(sdev_dh->name);
+	if (tmp)
+		goto done;
+
+	ret = bus_register_notifier(&scsi_bus_type, &sdev_dh->nb);
+
+	bus_for_each_dev(&scsi_bus_type, NULL, sdev_dh, scsi_dh_notifier_add);
+	spin_lock(&list_lock);
+	list_add(&sdev_dh->list, &scsi_dh_list);
+	spin_unlock(&list_lock);
+
+done:
+	return ret;
+}
+EXPORT_SYMBOL_GPL(scsi_register_device_handler);
+
+static int scsi_dh_notifier_remove(struct device *dev, void *data)
+{
+	struct scsi_device_handler *sdev_dh = data;
+
+	sdev_dh->nb.notifier_call(&sdev_dh->nb, BUS_NOTIFY_DEL_DEVICE, dev);
+	return 0;
+}
+
+/*
+ * scsi_unregister_device_handler - register a device handler personality
+ *      module.
+ * @sdev_dh - device handler to be unregistered.
+ *
+ * Returns 0 on success, -ENODEV if handler not registered.
+ */
+int scsi_unregister_device_handler(struct scsi_device_handler *sdev_dh)
+{
+	int ret = -ENODEV;
+	struct scsi_device_handler *tmp;
+
+	tmp = get_device_handler(sdev_dh->name);
+	if (!tmp)
+		goto done;
+
+	ret = bus_unregister_notifier(&scsi_bus_type, &sdev_dh->nb);
+
+	bus_for_each_dev(&scsi_bus_type, NULL, sdev_dh,
+					scsi_dh_notifier_remove);
+	spin_lock(&list_lock);
+	list_del(&sdev_dh->list);
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
+	int err = SCSI_DH_NOSYS;
+	struct scsi_device *sdev;
+	struct scsi_device_handler *sdev_dh;
+	unsigned long flags;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	sdev = q->queuedata;
+	sdev_dh = sdev->sdev_dh;
+	if (!sdev || !sdev_dh || !get_device(&sdev->sdev_gendev)) {
+		spin_unlock_irqrestore(q->queue_lock, flags);
+		goto done;
+	}
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	if (sdev_dh->activate)
+		err = sdev_dh->activate(sdev);
+	put_device(&sdev->sdev_gendev);
+done:
+	return err;
+}
+EXPORT_SYMBOL_GPL(scsi_dh_activate);
Index: linux-2.6.25-rc2-mm1/include/scsi/scsi_dh.h
===================================================================
--- /dev/null
+++ linux-2.6.25-rc2-mm1/include/scsi/scsi_dh.h
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
--- linux-2.6.25-rc2-mm1.orig/drivers/scsi/scsi_lib.c
+++ linux-2.6.25-rc2-mm1/drivers/scsi/scsi_lib.c
@@ -1156,6 +1156,11 @@ int scsi_setup_fs_cmnd(struct scsi_devic
 	struct scsi_cmnd *cmd;
 	int ret = scsi_prep_state_check(sdev, req);
 
+	if ((ret == BLKPREP_OK) && (req->cmd_type == REQ_TYPE_FS)) {
+		if (sdev->sdev_dh && sdev->sdev_dh->prep_fn)
+			ret = sdev->sdev_dh->prep_fn(sdev);
+	}
+
 	if (ret != BLKPREP_OK)
 		return ret;
 	/*

-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------
