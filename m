From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 3/7] scsi_dh: add hp sw device handler
Date: Tue, 01 Apr 2008 15:51:51 -0700
Message-ID: <20080401225151.2124.46545.sendpatchset@localhost.localdomain>
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

Subject: scsi_dh: add hp sw device handler

From: Mike Christie <michaelc@cs.wisc.edu>

This patch adds a very basic scsi device handler for older hp boxes which
cannot be upgraded.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---

 drivers/scsi/device_handler/Kconfig         |    8 	8 +	0 -	0 !
 drivers/scsi/device_handler/Makefile        |    1 	1 +	0 -	0 !
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |  201 	201 +	0 -	0 !
 3 files changed, 210 insertions(+)

Index: linux-2.6.25-rc2-mm1/drivers/scsi/device_handler/Kconfig
===================================================================
--- linux-2.6.25-rc2-mm1.orig/drivers/scsi/device_handler/Kconfig
+++ linux-2.6.25-rc2-mm1/drivers/scsi/device_handler/Kconfig
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
Index: linux-2.6.25-rc2-mm1/drivers/scsi/device_handler/Makefile
===================================================================
--- linux-2.6.25-rc2-mm1.orig/drivers/scsi/device_handler/Makefile
+++ linux-2.6.25-rc2-mm1/drivers/scsi/device_handler/Makefile
@@ -3,3 +3,4 @@
 #
 obj-$(CONFIG_SCSI_DH)		+= scsi_dh.o
 obj-$(CONFIG_SCSI_DH_RDAC)	+= scsi_dh_rdac.o
+obj-$(CONFIG_SCSI_DH_HP_SW)	+= scsi_dh_hp_sw.o
Index: linux-2.6.25-rc2-mm1/drivers/scsi/device_handler/scsi_dh_hp_sw.c
===================================================================
--- /dev/null
+++ linux-2.6.25-rc2-mm1/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -0,0 +1,201 @@
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
+static inline struct hp_sw_dh_data *get_hp_sw_data(struct scsi_device *sdev)
+{
+	struct scsi_dh_data *scsi_dh_data = sdev->scsi_dh_data;
+	BUG_ON(scsi_dh_data == NULL);
+	return ((struct hp_sw_dh_data *) scsi_dh_data->buf);
+}
+
+static int hp_sw_done(struct scsi_device *sdev)
+{
+	struct hp_sw_dh_data *h = get_hp_sw_data(sdev);
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
+	struct hp_sw_dh_data *h = get_hp_sw_data(sdev);
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
+	req->sense = h->sense;
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
+	struct scsi_dh_data *scsi_dh_data;
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
+		scsi_dh_data = kzalloc(sizeof(struct scsi_device_handler *)
+				+ sizeof(struct hp_sw_dh_data) , GFP_KERNEL);
+		if (!scsi_dh_data) {
+			sdev_printk(KERN_ERR, sdev, "Attach Failed %s.\n",
+				    HP_SW_NAME);
+			goto out;
+		}
+
+		scsi_dh_data->scsi_dh = &hp_sw_dh;
+		spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
+		sdev->scsi_dh_data = scsi_dh_data;
+		spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
+		try_module_get(THIS_MODULE);
+
+		sdev_printk(KERN_NOTICE, sdev, "Attached %s.\n", HP_SW_NAME);
+	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
+		BUG_ON(sdev->scsi_dh_data == NULL);
+		if (sdev->scsi_dh_data->scsi_dh != &hp_sw_dh)
+			goto out;
+
+		spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
+		scsi_dh_data = sdev->scsi_dh_data;
+		sdev->scsi_dh_data = NULL;
+		spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
+		module_put(THIS_MODULE);
+
+		sdev_printk(KERN_NOTICE, sdev, "Dettached %s.\n", HP_SW_NAME);
+
+		kfree(scsi_dh_data);
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
