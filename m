From: michaelc@cs.wisc.edu
Subject: [PATCH 3/7] scsi-hw-handler: add hp sw handler
Date: Sat, 09 Jun 2007 14:08:00 -0500
Message-ID: <11814160863051-git-send-email-michaelc@cs.wisc.edu>
References: <11814160842916-git-send-email-michaelc@cs.wisc.edu>
	<11814160853812-git-send-email-michaelc@cs.wisc.edu>
	<1181416085774-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu,
	device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1181416085774-git-send-email-michaelc@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-scsi@vger.kernel.org, dm-devel@redhat.com
Cc: Mike Christie <michaelc@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

This patch adds a very basic scsi hw handler for older
hp boxes which cannot be upgraded.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/Kconfig    |    8 ++
 drivers/scsi/Makefile   |    1 
 drivers/scsi/hw_hp_sw.c |  215 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 224 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index e4372da..3122346 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -288,6 +288,14 @@ endmenu
 menu "SCSI Device Info Drivers"
 	depends on SCSI
 
+config SCSI_HP_SW
+	tristate "HP/COMPAQ MSA Driver"
+	depends on SCSI
+	help
+	 If you have a HP/COMPAQ MSA device that requires START_STOP to
+	 be sent to start it and cannot upgrade the firmware then select y.
+	 Otherwise, say N.
+
 endmenu
 
 menu "SCSI low-level drivers"
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index cba3967..c86e3c0 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -129,6 +129,7 @@ obj-$(CONFIG_SCSI_IBMVSCSI)	+= ibmvscsi/
 obj-$(CONFIG_SCSI_IBMVSCSIS)	+= ibmvscsi/
 obj-$(CONFIG_SCSI_HPTIOP)	+= hptiop.o
 obj-$(CONFIG_SCSI_STEX)		+= stex.o
+obj-$(CONFIG_SCSI_HP_SW)	+= hw_hp_sw.o
 
 obj-$(CONFIG_ARM)		+= arm/
 
diff --git a/drivers/scsi/hw_hp_sw.c b/drivers/scsi/hw_hp_sw.c
new file mode 100644
index 0000000..190ea0a
--- /dev/null
+++ b/drivers/scsi/hw_hp_sw.c
@@ -0,0 +1,215 @@
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
+#include <linux/blkdev.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_dbg.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_eh.h>
+#include <scsi/scsi_driver.h>
+
+#define HP_SW_TIMEOUT 30
+#define HP_SW_RETRIES 3
+
+struct hp_sw_dev {
+	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
+	int retries;
+};
+
+static void hp_sw_done(struct request *req, int uptodate)
+{
+	struct request *act_req = req->end_io_data;
+	struct request_queue *q = req->q;
+	struct scsi_device *sdev = q->queuedata;
+	struct hp_sw_dev *hp_sw_dev = sdev->sdevt_data;
+	struct scsi_sense_hdr sshdr;
+	int rc = BLKERR_OK;
+
+	sdev_printk(KERN_INFO, sdev, "hp_sw_done %d\n", req->errors);
+
+	/*
+	 * This will at least get us going. Let Dave do the details.
+	 */
+	if (status_byte(req->errors) == CHECK_CONDITION &&
+	    scsi_normalize_sense(req->sense, req->sense_len, &sshdr)) {
+		/* tmp debug output */
+		__scsi_print_sense("hp_sw_done", req->sense, req->sense_len);
+
+		switch (sshdr.sense_key) {
+		case NOT_READY:
+			if ((sshdr.asc == 0x04) && (sshdr.ascq == 3)) {
+				rc = BLKERR_RETRY;
+				hp_sw_dev->retries++;
+				break;
+			}
+			/* fall through */
+		default:
+			hp_sw_dev->retries++;
+			rc = BLKERR_IMM_RETRY;
+		}
+	} else if (req->errors)
+		rc = BLKERR_IO;
+
+	if (rc == BLKERR_OK)
+		hp_sw_dev->retries = 0;
+	else if (hp_sw_dev->retries > HP_SW_RETRIES) {
+		hp_sw_dev->retries = 0;
+		rc = BLKERR_IO;
+	}
+
+	__blk_put_request(req->q, req);
+	scsi_blk_linux_cmd_done(act_req, rc);
+}
+
+static void hp_sw_transition(struct request *act_req)
+{
+	struct scsi_device *sdev = act_req->q->queuedata;
+	struct hp_sw_dev *hp_sw_dev = sdev->sdevt_data;
+	struct request *req;
+
+	sdev_printk(KERN_INFO, sdev, "hp_sw_done send START_STOP retries %d.\n",
+		   act_req->retries);
+
+	req = blk_get_request(sdev->request_queue, 0, GFP_ATOMIC);
+	if (!req) {
+		scsi_blk_linux_cmd_done(req, BLKERR_RES_TEMP_UNAVAIL);
+		return;
+	}
+
+	req->cmd_type = REQ_TYPE_BLOCK_PC;
+	req->cmd_flags |= REQ_FAILFAST;
+	req->cmd_len = COMMAND_SIZE(START_STOP);
+	memset(req->cmd, 0, MAX_COMMAND_SIZE);
+	req->cmd[0] = START_STOP;
+	req->cmd[4] = 1;	/* Start spin cycle */
+	req->timeout = HP_SW_TIMEOUT;
+	req->retries = HP_SW_RETRIES;
+	req->end_io_data = act_req;
+	req->sense = hp_sw_dev->sense;
+	memset(req->sense, 0, SCSI_SENSE_BUFFERSIZE);
+	req->sense_len = 0;
+
+	blk_execute_rq_nowait(req->q, NULL, req, 1, hp_sw_done);
+}
+
+static struct scsi_device_template hp_sw_template = {
+	.name		= "hp_sw",
+	.module		= THIS_MODULE,
+	.transition	= hp_sw_transition,
+};
+
+static const struct {
+	char *vendor;
+	char *model;
+} hp_sw_dev_list[] = {
+	{"COMPAQ", "MSA1000"},
+	{"HP", "HSV100"},
+	{NULL, NULL},
+};
+
+static int hp_sw_add(struct class_device *clsdev,
+		     struct class_interface *interface)
+{
+	struct scsi_device *sdev = to_scsi_device(clsdev->dev);
+	struct hp_sw_dev *hp_sw_dev;
+	int i, found = 0;
+	unsigned long flags;
+
+	for (i = 0; hp_sw_dev_list[i].vendor; i++) {
+		if (!strncmp(sdev->vendor, hp_sw_dev_list[i].vendor,
+			     strlen(hp_sw_dev_list[i].vendor)) &&
+		    !strncmp(sdev->model, hp_sw_dev_list[i].model,
+			     strlen(hp_sw_dev_list[i].model))) {
+			found = 1;
+			break;
+		}
+	}
+	if (!found)
+		return -ENODEV;
+
+	hp_sw_dev = kzalloc(sizeof(*hp_sw_dev), GFP_KERNEL);
+	if (!hp_sw_dev)
+		return -ENOMEM;
+
+	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
+	sdev->sdevt = &hp_sw_template;
+	sdev->sdevt_data = hp_sw_dev;
+	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
+
+	sdev_printk(KERN_NOTICE, sdev, "Attached %s.\n",
+		    hp_sw_template.name);
+	return 0;
+}
+
+static void hp_sw_remove(struct class_device *clsdev,
+			 struct class_interface *interface)
+{
+	struct scsi_device *sdev = to_scsi_device(clsdev->dev);
+	struct hp_sw_dev *hp_sw_dev = sdev->sdevt_data;
+	int i, found = 0;
+	unsigned long flags;
+
+	for (i = 0; hp_sw_dev_list[i].vendor; i++) {
+		if (!strncmp(sdev->vendor, hp_sw_dev_list[i].vendor,
+			     strlen(hp_sw_dev_list[i].vendor)) &&
+		    !strncmp(sdev->model, hp_sw_dev_list[i].model,
+			     strlen(hp_sw_dev_list[i].model))) {
+			found = 1;
+			break;
+		}
+	}
+	if (!found)
+		return;
+
+	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
+	sdev->sdevt = NULL;
+	sdev->sdevt_data = NULL;
+	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
+
+	sdev_printk(KERN_NOTICE, sdev, "Dettached %s.\n",
+		    hp_sw_template.name);
+
+	kfree(hp_sw_dev);
+}
+
+static struct class_interface hp_sw_interface = {
+        .add            = hp_sw_add,
+        .remove         = hp_sw_remove,
+};
+
+static int __init hp_sw_init(void)
+{
+	return scsi_register_interface(&hp_sw_interface);
+}
+
+static void __exit hp_sw_exit(void)
+{
+	scsi_unregister_interface(&hp_sw_interface);
+}
+
+module_init(hp_sw_init);
+module_exit(hp_sw_exit);
+
+MODULE_DESCRIPTION("HP MSA 1000");
+MODULE_AUTHOR("Mike Christie <michaelc@cs.wisc.edu");
+MODULE_LICENSE("GPL");
-- 
1.4.1.1
