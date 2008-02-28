From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 3/7] scsi_dh: add hp sw device handler
Date: Wed, 27 Feb 2008 17:08:47 -0800
Message-ID: <20080228010847.5535.9531.sendpatchset@localhost.localdomain>
References: <20080228010828.5535.74088.sendpatchset@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:57889 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760954AbYB1BIu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Feb 2008 20:08:50 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1S18LZ4022997
	for <linux-scsi@vger.kernel.org>; Wed, 27 Feb 2008 20:08:21 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1S18n1h214480
	for <linux-scsi@vger.kernel.org>; Wed, 27 Feb 2008 18:08:49 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1S18mnn031233
	for <linux-scsi@vger.kernel.org>; Wed, 27 Feb 2008 18:08:49 -0700
In-Reply-To: <20080228010828.5535.74088.sendpatchset@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: andmike@us.ibm.com, michaelc@cs.wisc.edu, Chandra Seetharaman <sekharan@us.ibm.com>, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, agk@redhat.com

Subject: scsi_dh: add hp sw device handler

From: Mike Christie <michaelc@cs.wisc.edu>

This patch adds a very basic scsi device handler for older hp boxes which
cannot be upgraded.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---

 drivers/scsi/device_handler/Kconfig         |    8 	8 +	0 -	0 !
 drivers/scsi/device_handler/Makefile        |    1 	1 +	0 -	0 !
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |  193 	193 +	0 -	0 !
 3 files changed, 202 insertions(+)

Index: linux-2.6.24/drivers/scsi/device_handler/Kconfig
===================================================================
--- linux-2.6.24.orig/drivers/scsi/device_handler/Kconfig
+++ linux-2.6.24/drivers/scsi/device_handler/Kconfig
@@ -16,3 +16,11 @@ config SCSI_DH_RDAC
 	depends on SCSI_DH
 	help
 	If you have a LSI RDAC select y. Otherwise, say N.
+
+config SCSI_DH_HP_SW
+	tristate "HP/COMPAQ MSA Device Handler"
+	depends on SCSI_DH
+	help
+	If you have a HP/COMPAQ MSA device that requires START_STOP to
+	be sent to start it and cannot upgrade the firmware then select y.
+	Otherwise, say N.
Index: linux-2.6.24/drivers/scsi/device_handler/Makefile
===================================================================
--- linux-2.6.24.orig/drivers/scsi/device_handler/Makefile
+++ linux-2.6.24/drivers/scsi/device_handler/Makefile
@@ -3,3 +3,4 @@
 #
 obj-$(CONFIG_SCSI_DH)		+= scsi_dh.o
 obj-$(CONFIG_SCSI_DH_RDAC)	+= scsi_dh_rdac.o
+obj-$(CONFIG_SCSI_DH_HP_SW)	+= scsi_dh_hp_sw.o
Index: linux-2.6.24/drivers/scsi/device_handler/scsi_dh_hp_sw.c
===================================================================
--- /dev/null
+++ linux-2.6.24/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -0,0 +1,193 @@
+/*
+ * Basic HP/COMPAQ MSA 1000 support. This is only needed if your HW cannot be
+ * upgraded.
+ *
+ * Copyright (C) 2006 Red Hat, Inc.  All rights reserved.
+ * Copyright (C) 2006 Mike Christie
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; see the file COPYING.  If not, write to
+ * the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_dbg.h>
+#include <scsi/scsi_eh.h>
+#include <scsi/scsi_dh.h>
+
+#define HP_SW_NAME	"hp_sw"
+
+#define HP_SW_TIMEOUT (60 * HZ)
+#define HP_SW_RETRIES 3
+
+struct hp_sw_dh_data {
+	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
+	int retries;
+};
+
+static int hp_sw_done(struct scsi_device *sdev)
+{
+	struct hp_sw_dh_data *h = sdev->sdev_dh_data;
+	struct scsi_sense_hdr sshdr;
+	int rc;
+
+	sdev_printk(KERN_INFO, sdev, "hp_sw_done\n");
+
+	rc = scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE, &sshdr);
+	if (!rc)
+		goto done;
+	switch (sshdr.sense_key) {
+	case NOT_READY:
+		if ((sshdr.asc == 0x04) && (sshdr.ascq == 3)) {
+			rc = SCSI_DH_RETRY;
+			h->retries++;
+			break;
+		}
+		/* fall through */
+	default:
+		h->retries++;
+		rc = SCSI_DH_IMM_RETRY;
+	}
+
+done:
+	if (rc == SCSI_DH_OK || rc == SCSI_DH_IO)
+		h->retries = 0;
+	else if (h->retries > HP_SW_RETRIES) {
+		h->retries = 0;
+		rc = SCSI_DH_IO;
+	}
+	return rc;
+}
+
+static int hp_sw_activate(struct scsi_device *sdev)
+{
+	struct hp_sw_dh_data *hp_sw_dh_data = sdev->sdev_dh_data;
+	struct request *req;
+	int ret = SCSI_DH_RES_TEMP_UNAVAIL;
+
+	req = blk_get_request(sdev->request_queue, WRITE, GFP_ATOMIC);
+	if (!req)
+		goto done;
+
+	sdev_printk(KERN_INFO, sdev, "sending START_STOP.");
+
+	req->cmd_type = REQ_TYPE_BLOCK_PC;
+	req->cmd_flags |= REQ_FAILFAST;
+	req->cmd_len = COMMAND_SIZE(START_STOP);
+	memset(req->cmd, 0, MAX_COMMAND_SIZE);
+	req->cmd[0] = START_STOP;
+	req->cmd[4] = 1;	/* Start spin cycle */
+	req->timeout = HP_SW_TIMEOUT;
+	req->sense = hp_sw_dh_data->sense;
+	memset(req->sense, 0, SCSI_SENSE_BUFFERSIZE);
+	req->sense_len = 0;
+
+	ret = blk_execute_rq(req->q, NULL, req, 1);
+	if (!ret) /* SUCCESS */
+		ret = hp_sw_done(sdev);
+	else
+		ret = SCSI_DH_IO;
+done:
+	return ret;
+}
+
+static const struct {
+	char *vendor;
+	char *model;
+} hp_sw_dh_data_list[] = {
+	{"COMPAQ", "MSA1000"},
+	{"HP", "HSV100"},
+	{NULL, NULL},
+};
+
+static int hp_sw_bus_notify(struct notifier_block *, unsigned long, void *);
+
+static struct scsi_device_handler hp_sw_dh = {
+	.name		= HP_SW_NAME,
+	.module		= THIS_MODULE,
+	.nb.notifier_call = hp_sw_bus_notify,
+	.activate	= hp_sw_activate,
+};
+
+static int hp_sw_bus_notify(struct notifier_block *nb,
+			    unsigned long action, void *data)
+{
+	struct device *dev = data;
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct hp_sw_dh_data *dh_data;
+	int i, found = 0;
+	unsigned long flags;
+
+	if (action == BUS_NOTIFY_ADD_DEVICE) {
+		for (i = 0; hp_sw_dh_data_list[i].vendor; i++) {
+			if (!strncmp(sdev->vendor, hp_sw_dh_data_list[i].vendor,
+				     strlen(hp_sw_dh_data_list[i].vendor)) &&
+			    !strncmp(sdev->model, hp_sw_dh_data_list[i].model,
+				     strlen(hp_sw_dh_data_list[i].model))) {
+				found = 1;
+				break;
+			}
+		}
+		if (!found)
+			goto out;
+
+		dh_data = kzalloc(sizeof(*dh_data), GFP_KERNEL);
+		if (!dh_data) {
+			sdev_printk(KERN_ERR, sdev, "Attach Failed %s.\n",
+				    HP_SW_NAME);
+			goto out;
+		}
+
+		spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
+		sdev->sdev_dh_data = dh_data;
+		sdev->sdev_dh = &hp_sw_dh;
+		spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
+		try_module_get(THIS_MODULE);
+
+		sdev_printk(KERN_NOTICE, sdev, "Attached %s.\n", HP_SW_NAME);
+	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
+		if (sdev->sdev_dh != &hp_sw_dh)
+			goto out;
+
+		spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
+		dh_data = sdev->sdev_dh_data;
+		sdev->sdev_dh_data = NULL;
+		sdev->sdev_dh = NULL;
+		spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
+		module_put(THIS_MODULE);
+
+		sdev_printk(KERN_NOTICE, sdev, "Dettached %s.\n", HP_SW_NAME);
+
+		kfree(dh_data);
+	}
+
+out:
+	return 0;
+}
+
+static int __init hp_sw_init(void)
+{
+	return scsi_register_device_handler(&hp_sw_dh);
+}
+
+static void __exit hp_sw_exit(void)
+{
+	scsi_unregister_device_handler(&hp_sw_dh);
+}
+
+module_init(hp_sw_init);
+module_exit(hp_sw_exit);
+
+MODULE_DESCRIPTION("HP MSA 1000");
+MODULE_AUTHOR("Mike Christie <michaelc@cs.wisc.edu");
+MODULE_LICENSE("GPL");

-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------
