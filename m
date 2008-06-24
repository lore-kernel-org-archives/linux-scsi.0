From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 9/9] scsi_dh: Add NetApp hardware handler
Date: Tue, 24 Jun 2008 12:05:38 +0200
Message-ID: <20080624100538.590EB10B5DE@craiglockhart-ipmi.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:49724 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529AbYFXKFj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jun 2008 06:05:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org


NetApp specific hardware handler to filter out vendor-specific
sense code.

Signed-off-by: Martin George <marting@netapp.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/Kconfig         |    6 +
 drivers/scsi/device_handler/Makefile        |    1 +
 drivers/scsi/device_handler/scsi_dh_ontap.c |  157 +++++++++++++++++++++++++++
 3 files changed, 164 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/device_handler/scsi_dh_ontap.c

diff --git a/drivers/scsi/device_handler/Kconfig b/drivers/scsi/device_handler/Kconfig
index 6707025..841e0e4 100644
--- a/drivers/scsi/device_handler/Kconfig
+++ b/drivers/scsi/device_handler/Kconfig
@@ -31,6 +31,12 @@ config SCSI_DH_EMC
 	help
 	If you have a EMC CLARiiON select y. Otherwise, say N.
 
+config SCSI_DH_ONTAP
+	tristate "NetApp Device Handler"
+	depends on SCSI_DH
+	help
+	If you have a NetApp controller select y. Otherwise, say N.
+
 config SCSI_DH_ALUA
 	tristate "SPC-3 ALUA Device Handler (EXPERIMENTAL)"
 	depends on SCSI_DH && EXPERIMENTAL
diff --git a/drivers/scsi/device_handler/Makefile b/drivers/scsi/device_handler/Makefile
index e1d2ea0..abfb9db 100644
--- a/drivers/scsi/device_handler/Makefile
+++ b/drivers/scsi/device_handler/Makefile
@@ -5,4 +5,5 @@ obj-$(CONFIG_SCSI_DH)		+= scsi_dh.o
 obj-$(CONFIG_SCSI_DH_RDAC)	+= scsi_dh_rdac.o
 obj-$(CONFIG_SCSI_DH_HP_SW)	+= scsi_dh_hp_sw.o
 obj-$(CONFIG_SCSI_DH_EMC)	+= scsi_dh_emc.o
+obj-$(CONFIG_SCSI_DH_ONTAP)	+= scsi_dh_ontap.o
 obj-$(CONFIG_SCSI_DH_ALUA)	+= scsi_dh_alua.o
diff --git a/drivers/scsi/device_handler/scsi_dh_ontap.c b/drivers/scsi/device_handler/scsi_dh_ontap.c
new file mode 100644
index 0000000..175d657
--- /dev/null
+++ b/drivers/scsi/device_handler/scsi_dh_ontap.c
@@ -0,0 +1,157 @@
+/*
+ * Copyright 2008 NetApp, Inc., All Rights Reserved
+ * Author:  Martin George available at marting@netapp.com
+ *
+ * This file is released under the GPL.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License v2 for more details.
+ */
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_eh.h>
+#include <scsi/scsi_dh.h>
+
+#define ONTAP_NAME			"ontap"
+
+#define ONTAP_STATE_ACTIVE		0
+#define ONTAP_STATE_PASSIVE		1
+
+struct ontap_dh_data {
+	/* To add more members here later */
+	unsigned char			state;
+};
+
+static inline struct ontap_dh_data *get_ontap_data(struct scsi_device *sdev)
+{
+	struct scsi_dh_data *scsi_dh_data = sdev->scsi_dh_data;
+
+	BUG_ON(scsi_dh_data == NULL);
+	return ((struct ontap_dh_data *) scsi_dh_data->buf);
+}
+
+static int ontap_prep_fn(struct scsi_device *sdev, struct request *req)
+{
+	struct ontap_dh_data *h = get_ontap_data(sdev);
+	int ret = BLKPREP_OK;
+
+	if (h->state != ONTAP_STATE_ACTIVE) {
+		ret = BLKPREP_KILL;
+		req->cmd_flags |= REQ_QUIET;
+	}
+	return ret;
+}
+
+static int ontap_check_sense(struct scsi_device *sdev,
+				struct scsi_sense_hdr *sense_hdr)
+{
+	struct ontap_dh_data *h = get_ontap_data(sdev);
+
+	switch (sense_hdr->sense_key) {
+	case HARDWARE_ERROR:
+		if (sense_hdr->asc == 0x5D && sense_hdr->ascq == 0x12) {
+			/* Failed write on NetApp controller
+                         * Fail the IO */
+			h->state = ONTAP_STATE_PASSIVE;
+			return FAILED;
+		}
+		break;
+	}
+
+	/* Do not care what scsi-ml does */
+	return SCSI_RETURN_NOT_HANDLED;
+}
+
+const struct scsi_dh_devlist ontap_dev_list[] = {
+	{"NETAPP", "LUN"},
+	{NULL, NULL},
+};
+
+static int ontap_bus_attach(struct scsi_device *sdev);
+static void ontap_bus_detach(struct scsi_device *sdev);
+
+static struct scsi_device_handler ontap_dh = {
+	.name		= ONTAP_NAME,
+	.module		= THIS_MODULE,
+	.devlist	= ontap_dev_list,
+	.attach		= ontap_bus_attach,
+	.detach		= ontap_bus_detach,
+	.check_sense	= ontap_check_sense,
+	.prep_fn	= ontap_prep_fn,
+};
+
+static int ontap_bus_attach(struct scsi_device *sdev)
+{
+	struct scsi_dh_data *scsi_dh_data;
+	struct ontap_dh_data *h;
+	unsigned long flags;
+	int i, found = 0;
+
+	scsi_dh_data = kzalloc(sizeof(struct scsi_device_handler *)
+			       + sizeof(*h) , GFP_KERNEL);
+	if (!scsi_dh_data) {
+		sdev_printk(KERN_ERR, sdev, "%s: Attach failed\n",
+			    ONTAP_NAME);
+		return -ENOMEM;
+	}
+
+	scsi_dh_data->scsi_dh = &ontap_dh;
+	h = (struct ontap_dh_data *) scsi_dh_data->buf;
+	h->state = ONTAP_STATE_ACTIVE;
+
+	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
+	sdev->scsi_dh_data = scsi_dh_data;
+	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
+
+	sdev_printk(KERN_NOTICE, sdev, "Attached %s.\n", ONTAP_NAME);
+
+	try_module_get(THIS_MODULE);
+
+	return 0;
+}
+
+static void ontap_bus_detach(struct scsi_device *sdev)
+{
+	struct scsi_dh_data *scsi_dh_data;
+	unsigned long flags;
+
+	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
+	scsi_dh_data = sdev->scsi_dh_data;
+	sdev->scsi_dh_data = NULL;
+	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
+
+	sdev_printk(KERN_NOTICE, sdev, "%s: Detached\n",
+		    ONTAP_NAME);
+
+	kfree(scsi_dh_data);
+	module_put(THIS_MODULE);
+}
+
+static int __init ontap_init(void)
+{
+	int r;
+
+	r = scsi_register_device_handler(&ontap_dh);
+	if (r != 0)
+		printk(KERN_ERR "%s: Failed to register scsi device handler.",
+			ONTAP_NAME);
+	return r;
+}
+
+static void __exit ontap_exit(void)
+{
+	scsi_unregister_device_handler(&ontap_dh);
+}
+
+module_init(ontap_init);
+module_exit(ontap_exit);
+
+MODULE_DESCRIPTION("NetApp controller driver");
+MODULE_AUTHOR("Martin George <marting@netapp.com>");
+MODULE_LICENSE("GPL");
-- 
1.5.2.4

