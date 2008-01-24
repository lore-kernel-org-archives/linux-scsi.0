From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 5/9] scsi_dh: add EMC Clariion device handler
Date: Wed, 23 Jan 2008 16:31:31 -0800
Message-ID: <20080124003131.18871.55611.sendpatchset@localhost.localdomain>
References: <20080124003010.18871.84095.sendpatchset@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:50967 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbYAXAbd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jan 2008 19:31:33 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m0O0VXh2022427
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jan 2008 19:31:33 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0O0VXLD105794
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jan 2008 17:31:33 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m0O0VW4C032207
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jan 2008 17:31:33 -0700
In-Reply-To: <20080124003010.18871.84095.sendpatchset@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: andmike@us.ibm.com, michaelc@cs.wisc.edu, Chandra Seetharaman <sekharan@us.ibm.com>, jens.axboe@oracle.com

Subject: scsi_dh: add EMC Clariion device handler

From: Mike Christie <michaelc@cs.wisc.edu>

This adds support for EMC Clariions. It is just a port of what is in
mainline. Ed's patches will be intergrated in a different patch which adds
more advanced functionality.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---

 drivers/scsi/device_handler/Kconfig       |    6 	6 +	0 -	0 !
 drivers/scsi/device_handler/Makefile      |    2 	2 +	0 -	0 !
 drivers/scsi/device_handler/scsi_dh_emc.c |  360 	360 +	0 -	0 !
 3 files changed, 368 insertions(+)

Index: linux-2.6.24-rc8/drivers/scsi/device_handler/Kconfig
===================================================================
--- linux-2.6.24-rc8.orig/drivers/scsi/device_handler/Kconfig
+++ linux-2.6.24-rc8/drivers/scsi/device_handler/Kconfig
@@ -13,4 +13,10 @@ menuconfig SCSI_DH
 
 if SCSI_DH
 
+config SCSI_DH_EMC
+	tristate "EMC CLARiiON Device Handler"
+	help
+	If you have a EMC CLARiiON select y. Otherwise, say N.
+
+
 endif #SCSI_DH
Index: linux-2.6.24-rc8/drivers/scsi/device_handler/Makefile
===================================================================
--- linux-2.6.24-rc8.orig/drivers/scsi/device_handler/Makefile
+++ linux-2.6.24-rc8/drivers/scsi/device_handler/Makefile
@@ -1,3 +1,5 @@
 #
 # SCSI Device Handler
 #
+
+obj-$(CONFIG_SCSI_DH_EMC)	+= scsi_dh_emc.o
Index: linux-2.6.24-rc8/drivers/scsi/device_handler/scsi_dh_emc.c
===================================================================
--- /dev/null
+++ linux-2.6.24-rc8/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -0,0 +1,360 @@
+/*
+ * Target driver for EMC CLARiiON AX/CX-series hardware.
+ * Based on code from Lars Marowsky-Bree <lmb@suse.de>
+ * and Ed Goggin <egoggin@emc.com>.
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
+#include <linux/blkdev.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_eh.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_driver.h>
+
+#define CLARIION_NAME			"emc_clariion"
+
+#define CLARIION_TRESPASS_PAGE		0x22
+#define CLARIION_BUFFER_SIZE		0x80
+#define CLARIION_TIMEOUT		(60 * HZ)
+#define CLARIION_UNBOUND_LU		-1
+#define CLARIION_RETRIES		3
+
+struct clariion_dh_data {
+	/*
+	 * Use short trespass command (FC-series) or the long version
+	 * (default for AX/CX CLARiiON arrays).
+	 */
+	unsigned short_trespass;
+	/*
+	 * Whether or not (default) to honor SCSI reservations when
+	 * initiating a switch-over.
+	 */
+	unsigned hr;
+	/* I/O buffer for both MODE_SELECT and INQUIRY commands. */
+	char buffer[CLARIION_BUFFER_SIZE];
+	/*
+	 * SCSI sense buffer for commands -- assumes serial issuance
+	 * and completion sequence of all commands for same multipath.
+	 */
+	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
+};
+
+static unsigned char long_trespass[] = {
+	0, 0, 0, 0,
+	CLARIION_TRESPASS_PAGE,	/* Page code */
+	0x09,			/* Page length - 2 */
+	0x81,			/* Trespass code + Honor reservation bit */
+	0xff, 0xff,		/* Trespass target */
+	0, 0, 0, 0, 0, 0	/* Reserved bytes / unknown */
+};
+
+static unsigned char long_trespass_hr[] = {
+	0, 0, 0, 0,
+	CLARIION_TRESPASS_PAGE,	/* Page code */
+	0x09,			/* Page length - 2 */
+	0x01,			/* Trespass code + Honor reservation bit */
+	0xff, 0xff,		/* Trespass target */
+	0, 0, 0, 0, 0, 0	/* Reserved bytes / unknown */
+};
+
+static unsigned char short_trespass[] = {
+	0, 0, 0, 0,
+	CLARIION_TRESPASS_PAGE,	/* Page code */
+	0x02,			/* Page length - 2 */
+	0x81,			/* Trespass code + Honor reservation bit */
+	0xff,			/* Trespass target */
+};
+
+static unsigned char short_trespass_hr[] = {
+	0, 0, 0, 0,
+	CLARIION_TRESPASS_PAGE,	/* Page code */
+	0x02,			/* Page length - 2 */
+	0x01,			/* Trespass code + Honor reservation bit */
+	0xff,			/* Trespass target */
+};
+
+/*
+ * Parse MODE_SELECT cmd reply.
+ */
+static int parse_trespass_rsp(struct scsi_device *sdev, char *sense,
+			       int result)
+{
+	struct scsi_sense_hdr sshdr;
+	int err = 0;
+
+	if (status_byte(result) == CHECK_CONDITION &&
+	    scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE, &sshdr)) {
+		sdev_printk(KERN_ERR, sdev, "Found valid sense data 0x%2x, "
+			    "0x%2x, 0x%2x while sending CLARiiON trespass "
+			    "command.\n", sshdr.sense_key, sshdr.asc,
+			     sshdr.ascq);
+
+		if ((sshdr.sense_key == 0x05) && (sshdr.asc == 0x04) &&
+		     (sshdr.ascq == 0x00)) {
+			/*
+			 * Array based copy in progress -- do not send
+			 * pg_init or copy will be aborted mid-stream.
+			 */
+			sdev_printk(KERN_INFO, sdev, "Array Based Copy in "
+				    "progress while sending CLARiiON trespass "
+				    "command.\n");
+			err = BLKERR_DEV_TEMP_BUSY;
+		} else if ((sshdr.sense_key == 0x02) && (sshdr.asc == 0x04) &&
+			    (sshdr.ascq == 0x03)) {
+			/*
+			 * LUN Not Ready - Manual Intervention Required
+			 * indicates in-progress ucode upgrade (NDU).
+			 */
+			sdev_printk(KERN_INFO, sdev, "Detected in-progress "
+				    "ucode upgrade NDU operation while sending "
+				    "CLARiiON trespass command.\n");
+			err = BLKERR_DEV_TEMP_BUSY;
+		} else
+			err = BLKERR_DEV_FAILED;
+	} else if (result) {
+		sdev_printk(KERN_ERR, sdev, "Error 0x%x while sending "
+			    "CLARiiON trespass command.\n", result);
+		err = BLKERR_IO;
+	}
+
+	return err;
+}
+
+static void trespass_done(struct request *req, int uptodate)
+{
+	struct request *act_req = req->end_io_data;
+	struct scsi_device *sdev = req->q->queuedata;
+	int err_flags, result = req->errors;
+	char *sense = req->sense;
+
+	sdev_printk(KERN_NOTICE, sdev, "Trespass compeleted. Uptodate %d error "
+		    "%d.\n", uptodate, req->errors);
+
+	__blk_put_request(req->q, req);
+
+	err_flags = parse_trespass_rsp(sdev, sense, result);
+	if (err_flags) {
+		scsi_blk_linux_cmd_done(act_req, err_flags);
+		return;
+	}
+
+	scsi_blk_linux_cmd_done(act_req, BLKERR_OK);
+}
+
+static int execute_trespass(struct request *act_req)
+{
+	struct scsi_device *sdev = act_req->q->queuedata;
+	struct clariion_dh_data *csdev = sdev->sdev_dh_data;
+	struct request *req;
+	unsigned char *page22;
+	unsigned size;
+
+	if (csdev->short_trespass) {
+		page22 = csdev->hr ? short_trespass_hr : short_trespass;
+		size = sizeof(short_trespass);
+	} else {
+		page22 = csdev->hr ? long_trespass_hr : long_trespass;
+		size = sizeof(long_trespass);
+	}
+
+	req = blk_get_request(sdev->request_queue, 1, GFP_ATOMIC);
+	if (!req)
+		return BLKERR_RES_TEMP_UNAVAIL;
+
+	req->cmd_type = REQ_TYPE_BLOCK_PC;
+	req->cmd_flags |= REQ_FAILFAST;
+	req->timeout = CLARIION_TIMEOUT;
+	req->retries = CLARIION_RETRIES;
+	req->end_io_data = act_req;
+	req->sense = csdev->sense;
+	memset(req->sense, 0, SCSI_SENSE_BUFFERSIZE);
+	req->sense_len = 0;
+
+	memset(req->cmd, 0, MAX_COMMAND_SIZE);
+	req->cmd[0] = MODE_SELECT;
+	req->cmd[1] = 0x10;
+	req->cmd[4] = size;
+	req->cmd_len = COMMAND_SIZE(MODE_SELECT);
+	memcpy(csdev->buffer, page22, size);
+
+	if (blk_rq_map_kern(sdev->request_queue, req, csdev->buffer,
+							size, GFP_ATOMIC)) {
+		__blk_put_request(req->q, req);
+		return BLKERR_RES_TEMP_UNAVAIL;
+	}
+
+	sdev_printk(KERN_NOTICE, sdev, "Failing over device\n.");
+	blk_execute_rq_nowait(req->q, NULL, req, 1, trespass_done);
+	return BLKERR_OK;
+}
+
+static void clariion_transition(struct request *req)
+{
+	int err;
+
+	err = execute_trespass(req);
+	if (err)
+		scsi_blk_linux_cmd_done(req, err);
+}
+
+static int clariion_check_sense(struct scsi_device *sdev,
+				struct scsi_sense_hdr *sense_hdr)
+{
+	switch (sense_hdr->sense_key) {
+	case NOT_READY:
+		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x03)
+			/*
+			 * LUN Not Ready - Manual Intervention Required
+			 * indicates this is a passive path.
+			 *
+			 * FIXME: However, if this is seen and EVPD C0
+			 * indicates that this is due to a NDU in
+			 * progress, we should set FAIL_PATH too.
+			 * This indicates we might have to do a SCSI
+			 * inquiry in the end_io path. Ugh.
+			 *
+			 * Can return FAILED only when we want the error
+			 * recovery process to kick in.
+			 */
+			return SUCCESS;
+		break;
+	case ILLEGAL_REQUEST:
+		if (sense_hdr->asc == 0x25 && sense_hdr->ascq == 0x01)
+			/*
+			 * An array based copy is in progress. Do not
+			 * fail the path, do not bypass to another PG,
+			 * do not retry. Fail the IO immediately.
+			 * (Actually this is the same conclusion as in
+			 * the default handler, but lets make sure.)
+			 *
+			 * Can return FAILED only when we want the error
+			 * recovery process to kick in.
+			 */
+			return SUCCESS;
+		break;
+	case UNIT_ATTENTION:
+		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00)
+			/*
+			 * Unit Attention Code. This is the first IO
+			 * to the new path, so just retry.
+			 */
+			return NEEDS_RETRY;
+		break;
+	}
+
+	/* success just means we do not care what scsi-ml does */
+	return SUCCESS;
+}
+
+static const struct {
+	char *vendor;
+	char *model;
+} clariion_dev_list[] = {
+	{"DGC", "RAID"},
+	{"DGC", "DISK"},
+	{NULL, NULL},
+};
+
+static int clariion_bus_notify(struct notifier_block *, unsigned long, void *);
+
+static struct scsi_device_handler clariion_dh = {
+	.name		= CLARIION_NAME,
+	.module		= THIS_MODULE,
+	.nb.notifier_call = clariion_bus_notify,
+	.check_sense	= clariion_check_sense,
+	.transition	= clariion_transition,
+};
+
+/*
+ * TODO: need some interface so we can set trespass values
+ */
+static int clariion_bus_notify(struct notifier_block *nb,
+				unsigned long action, void *data)
+{
+	struct device *dev = data;
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct clariion_dh_data *dh_data;
+	int i, found = 0;
+	unsigned long flags;
+
+	if (action == BUS_NOTIFY_ADD_DEVICE) {
+		for (i = 0; clariion_dev_list[i].vendor; i++) {
+			if (!strncmp(sdev->vendor, clariion_dev_list[i].vendor,
+				     strlen(clariion_dev_list[i].vendor)) &&
+			    !strncmp(sdev->model, clariion_dev_list[i].model,
+				     strlen(clariion_dev_list[i].model))) {
+				found = 1;
+				break;
+			}
+		}
+		if (!found)
+			goto out;
+
+		dh_data = kzalloc(sizeof(*dh_data), GFP_KERNEL);
+		if (!dh_data) {
+			sdev_printk(KERN_ERR, sdev, "Attach failed %s.\n",
+				    CLARIION_NAME);
+			goto out;
+		}
+
+		spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
+		sdev->sdev_dh_data = dh_data;
+		sdev->sdev_dh = &clariion_dh;
+		spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
+
+		sdev_printk(KERN_NOTICE, sdev, "Attached %s.\n",
+			    CLARIION_NAME);
+
+	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
+		if (sdev->sdev_dh != &clariion_dh)
+			goto out;
+
+		spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
+		dh_data = sdev->sdev_dh_data;
+		sdev->sdev_dh_data = NULL;
+		sdev->sdev_dh = NULL;
+		spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
+
+		sdev_printk(KERN_NOTICE, sdev, "Dettached %s.\n",
+			    CLARIION_NAME);
+
+		kfree(dh_data);
+	}
+
+out:
+	return 0;
+}
+
+
+static int __init clariion_init(void)
+{
+	return scsi_register_device_handler(&clariion_dh);
+}
+
+static void __exit clariion_exit(void)
+{
+	scsi_unregister_device_handler(&clariion_dh);
+}
+
+module_init(clariion_init);
+module_exit(clariion_exit);
+
+MODULE_DESCRIPTION("EMC CX/AX/FC-family driver");
+MODULE_AUTHOR("Mike Christie <michaelc@cs.wisc.edu");
+MODULE_LICENSE("GPL");

-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------
