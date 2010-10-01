From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [PATCH 14/19]: SCST pass-through dev handlers
Date: Sat, 02 Oct 2010 01:51:58 +0400
Message-ID: <4CA657FE.1020600@vlnb.net>
References: <4CA653F0.1010008@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4CA653F0.1010008@vlnb.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

This patch contains SCST pass-through dev handlers.

Those handlers allows to export local SCSI-capable devices to remote
initiators. 1:many relationship with remote initiators is supported,
i.e. many initiators can connect to single exported local SCSI-capable
device at the same time.

It is possible, because SCST core emulates necessary functionality of
SCSI host adapter. Such emulation is needed, because from remote initiators'
point of view a SCSI target acts as a SCSI host with its own devices. You can
find more deep elaboration why it is needed in
http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg06911.html.

Some of the emulated functions are:

 * Generation of necessary UNIT ATTENTIONs, their storage and delivery to all
   connected remote initiators.

 * RESERVE/RELEASE functionality.

 * All types of RESETs and other task management functions.

 * REPORT LUNS command as well as SCSI address space management in order to have
   consistent address space on all remote initiators, since local SCSI devices
   could not know about each other to report via REPORT LUNS command.

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
 scst_cdrom.c       |  245 ++++++++++++++++++++
 scst_changer.c     |  167 +++++++++++++
 scst_dev_handler.h |   27 ++
 scst_disk.c        |  647 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 scst_modisk.c      |  328 ++++++++++++++++++++++++++
 scst_processor.c   |  167 +++++++++++++
 scst_raid.c        |  168 +++++++++++++
 scst_tape.c        |  361 +++++++++++++++++++++++++++++
 8 files changed, 2110 insertions(+)

diff -uprN orig/linux-2.6.35/drivers/scst/dev_handlers/scst_cdrom.c linux-2.6.35/drivers/scst/dev_handlers/scst_cdrom.c
--- orig/linux-2.6.35/drivers/scst/dev_handlers/scst_cdrom.c
+++ linux-2.6.35/drivers/scst/dev_handlers/scst_cdrom.c
@@ -0,0 +1,245 @@
+/*
+ *  scst_cdrom.c
+ *
+ *  Copyright (C) 2004 - 2010 Vladislav Bolkhovitin <vst@vlnb.net>
+ *  Copyright (C) 2004 - 2005 Leonid Stoljar
+ *  Copyright (C) 2007 - 2010 ID7 Ltd.
+ *
+ *  SCSI CDROM (type 5) dev handler
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation, version 2
+ *  of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ *  GNU General Public License for more details.
+ */
+
+#include <linux/cdrom.h>
+#include <scsi/scsi_host.h>
+#include <linux/slab.h>
+
+#define LOG_PREFIX	"dev_cdrom"
+
+#include <scst/scst.h>
+#include "scst_dev_handler.h"
+
+#define CDROM_NAME	"dev_cdrom"
+
+#define CDROM_DEF_BLOCK_SHIFT	11
+
+struct cdrom_params {
+	int block_shift;
+};
+
+static int cdrom_attach(struct scst_device *);
+static void cdrom_detach(struct scst_device *);
+static int cdrom_parse(struct scst_cmd *);
+static int cdrom_done(struct scst_cmd *);
+
+static struct scst_dev_type cdrom_devtype = {
+	.name =			CDROM_NAME,
+	.type =			TYPE_ROM,
+	.threads_num =		1,
+	.parse_atomic =		1,
+	.dev_done_atomic =	1,
+	.attach =		cdrom_attach,
+	.detach =		cdrom_detach,
+	.parse =		cdrom_parse,
+	.dev_done =		cdrom_done,
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+	.default_trace_flags =	SCST_DEFAULT_DEV_LOG_FLAGS,
+	.trace_flags =		&trace_flag,
+#endif
+};
+
+static int cdrom_attach(struct scst_device *dev)
+{
+	int res, rc;
+	uint8_t cmd[10];
+	const int buffer_size = 512;
+	uint8_t *buffer = NULL;
+	int retries;
+	unsigned char sense_buffer[SCSI_SENSE_BUFFERSIZE];
+	enum dma_data_direction data_dir;
+	struct cdrom_params *params;
+
+	if (dev->scsi_dev == NULL ||
+	    dev->scsi_dev->type != dev->type) {
+		PRINT_ERROR("%s", "SCSI device not define or illegal type");
+		res = -ENODEV;
+		goto out;
+	}
+
+	params = kzalloc(sizeof(*params), GFP_KERNEL);
+	if (params == NULL) {
+		TRACE(TRACE_OUT_OF_MEM, "%s",
+		      "Unable to allocate struct cdrom_params");
+		res = -ENOMEM;
+		goto out;
+	}
+
+	buffer = kmalloc(buffer_size, GFP_KERNEL);
+	if (!buffer) {
+		TRACE(TRACE_OUT_OF_MEM, "%s", "Memory allocation failure");
+		res = -ENOMEM;
+		goto out_free_params;
+	}
+
+	/* Clear any existing UA's and get cdrom capacity (cdrom block size) */
+	memset(cmd, 0, sizeof(cmd));
+	cmd[0] = READ_CAPACITY;
+	cmd[1] = (dev->scsi_dev->scsi_level <= SCSI_2) ?
+	    ((dev->scsi_dev->lun << 5) & 0xe0) : 0;
+	retries = SCST_DEV_UA_RETRIES;
+	while (1) {
+		memset(buffer, 0, buffer_size);
+		memset(sense_buffer, 0, sizeof(sense_buffer));
+		data_dir = SCST_DATA_READ;
+
+		TRACE_DBG("%s", "Doing READ_CAPACITY");
+		rc = scsi_execute(dev->scsi_dev, cmd, data_dir, buffer,
+				   buffer_size, sense_buffer,
+				   SCST_GENERIC_CDROM_REG_TIMEOUT, 3, 0
+				   , NULL
+				  );
+
+		TRACE_DBG("READ_CAPACITY done: %x", rc);
+
+		if ((rc == 0) ||
+		    !scst_analyze_sense(sense_buffer,
+				sizeof(sense_buffer), SCST_SENSE_KEY_VALID,
+				UNIT_ATTENTION, 0, 0))
+			break;
+
+		if (!--retries) {
+			PRINT_ERROR("UA not cleared after %d retries",
+				SCST_DEV_UA_RETRIES);
+			params->block_shift = CDROM_DEF_BLOCK_SHIFT;
+			res = -ENODEV;
+			goto out_free_buf;
+		}
+	}
+
+	if (rc == 0) {
+		int sector_size = ((buffer[4] << 24) | (buffer[5] << 16) |
+				      (buffer[6] << 8) | (buffer[7] << 0));
+		if (sector_size == 0)
+			params->block_shift = CDROM_DEF_BLOCK_SHIFT;
+		else
+			params->block_shift =
+				scst_calc_block_shift(sector_size);
+		TRACE_DBG("Sector size is %i scsi_level %d(SCSI_2 %d)",
+			sector_size, dev->scsi_dev->scsi_level, SCSI_2);
+	} else {
+		params->block_shift = CDROM_DEF_BLOCK_SHIFT;
+		TRACE(TRACE_MINOR, "Read capacity failed: %x, using default "
+			"sector size %d", rc, params->block_shift);
+		PRINT_BUFF_FLAG(TRACE_MINOR, "Returned sense", sense_buffer,
+			sizeof(sense_buffer));
+	}
+
+	res = scst_obtain_device_parameters(dev);
+	if (res != 0) {
+		PRINT_ERROR("Failed to obtain control parameters for device "
+			"%s", dev->virt_name);
+		goto out_free_buf;
+	}
+
+out_free_buf:
+	kfree(buffer);
+
+out_free_params:
+	if (res == 0)
+		dev->dh_priv = params;
+	else
+		kfree(params);
+
+out:
+	return res;
+}
+
+static void cdrom_detach(struct scst_device *dev)
+{
+	struct cdrom_params *params =
+		(struct cdrom_params *)dev->dh_priv;
+
+	kfree(params);
+	dev->dh_priv = NULL;
+	return;
+}
+
+static int cdrom_get_block_shift(struct scst_cmd *cmd)
+{
+	struct cdrom_params *params = (struct cdrom_params *)cmd->dev->dh_priv;
+	/*
+	 * No need for locks here, since *_detach() can not be
+	 * called, when there are existing commands.
+	 */
+	return params->block_shift;
+}
+
+static int cdrom_parse(struct scst_cmd *cmd)
+{
+	int res = SCST_CMD_STATE_DEFAULT;
+
+	scst_cdrom_generic_parse(cmd, cdrom_get_block_shift);
+
+	cmd->retries = SCST_PASSTHROUGH_RETRIES;
+
+	return res;
+}
+
+static void cdrom_set_block_shift(struct scst_cmd *cmd, int block_shift)
+{
+	struct cdrom_params *params = (struct cdrom_params *)cmd->dev->dh_priv;
+	/*
+	 * No need for locks here, since *_detach() can not be
+	 * called, when there are existing commands.
+	 */
+	if (block_shift != 0)
+		params->block_shift = block_shift;
+	else
+		params->block_shift = CDROM_DEF_BLOCK_SHIFT;
+	return;
+}
+
+static int cdrom_done(struct scst_cmd *cmd)
+{
+	int res = SCST_CMD_STATE_DEFAULT;
+
+	res = scst_block_generic_dev_done(cmd, cdrom_set_block_shift);
+	return res;
+}
+
+static int __init cdrom_init(void)
+{
+	int res = 0;
+
+	cdrom_devtype.module = THIS_MODULE;
+
+	res = scst_register_dev_driver(&cdrom_devtype);
+	if (res < 0)
+		goto out;
+
+out:
+	return res;
+
+}
+
+static void __exit cdrom_exit(void)
+{
+	scst_unregister_dev_driver(&cdrom_devtype);
+	return;
+}
+
+module_init(cdrom_init);
+module_exit(cdrom_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Vladislav Bolkhovitin & Leonid Stoljar");
+MODULE_DESCRIPTION("SCSI CDROM (type 5) dev handler for SCST");
+MODULE_VERSION(SCST_VERSION_STRING);
diff -uprN orig/linux-2.6.35/drivers/scst/dev_handlers/scst_changer.c linux-2.6.35/drivers/scst/dev_handlers/scst_changer.c
--- orig/linux-2.6.35/drivers/scst/dev_handlers/scst_changer.c
+++ linux-2.6.35/drivers/scst/dev_handlers/scst_changer.c
@@ -0,0 +1,167 @@
+/*
+ *  scst_changer.c
+ *
+ *  Copyright (C) 2004 - 2010 Vladislav Bolkhovitin <vst@vlnb.net>
+ *  Copyright (C) 2004 - 2005 Leonid Stoljar
+ *  Copyright (C) 2007 - 2010 ID7 Ltd.
+ *
+ *  SCSI medium changer (type 8) dev handler
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation, version 2
+ *  of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ *  GNU General Public License for more details.
+ */
+
+#include <scsi/scsi_host.h>
+#include <linux/slab.h>
+
+#define LOG_PREFIX      "dev_changer"
+
+#include <scst/scst.h>
+#include "scst_dev_handler.h"
+
+#define CHANGER_NAME	"dev_changer"
+
+#define CHANGER_RETRIES       2
+
+static int changer_attach(struct scst_device *);
+/* static void changer_detach(struct scst_device *); */
+static int changer_parse(struct scst_cmd *);
+/* static int changer_done(struct scst_cmd *); */
+
+static struct scst_dev_type changer_devtype = {
+	.name =	CHANGER_NAME,
+	.type =	TYPE_MEDIUM_CHANGER,
+	.threads_num =	1,
+	.parse_atomic =	1,
+/*	.dev_done_atomic =	1, */
+	.attach =	changer_attach,
+/*	.detach =	changer_detach, */
+	.parse =	changer_parse,
+/*	.dev_done =	changer_done */
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+	.default_trace_flags =	SCST_DEFAULT_DEV_LOG_FLAGS,
+	.trace_flags =		&trace_flag,
+#endif
+};
+
+static int changer_attach(struct scst_device *dev)
+{
+	int res, rc;
+	int retries;
+
+	if (dev->scsi_dev == NULL ||
+	    dev->scsi_dev->type != dev->type) {
+		PRINT_ERROR("%s", "SCSI device not define or illegal type");
+		res = -ENODEV;
+		goto out;
+	}
+
+	/*
+	 * If the device is offline, don't try to read capacity or any
+	 * of the other stuff
+	 */
+	if (dev->scsi_dev->sdev_state == SDEV_OFFLINE) {
+		TRACE_DBG("%s", "Device is offline");
+		res = -ENODEV;
+		goto out;
+	}
+
+	retries = SCST_DEV_UA_RETRIES;
+	do {
+		TRACE_DBG("%s", "Doing TEST_UNIT_READY");
+		rc = scsi_test_unit_ready(dev->scsi_dev,
+			SCST_GENERIC_CHANGER_TIMEOUT, CHANGER_RETRIES
+					  , NULL);
+		TRACE_DBG("TEST_UNIT_READY done: %x", rc);
+	} while ((--retries > 0) && rc);
+
+	if (rc) {
+		PRINT_WARNING("Unit not ready: %x", rc);
+		/* Let's try not to be too smart and continue processing */
+	}
+
+	res = scst_obtain_device_parameters(dev);
+	if (res != 0) {
+		PRINT_ERROR("Failed to obtain control parameters for device "
+			"%s", dev->virt_name);
+		goto out;
+	}
+
+out:
+	return res;
+}
+
+#if 0
+void changer_detach(struct scst_device *dev)
+{
+	return;
+}
+#endif
+
+static int changer_parse(struct scst_cmd *cmd)
+{
+	int res = SCST_CMD_STATE_DEFAULT;
+
+	scst_changer_generic_parse(cmd, NULL);
+
+	cmd->retries = SCST_PASSTHROUGH_RETRIES;
+
+	return res;
+}
+
+#if 0
+int changer_done(struct scst_cmd *cmd)
+{
+	int res = SCST_CMD_STATE_DEFAULT;
+
+	/*
+	 * SCST sets good defaults for cmd->is_send_status and
+	 * cmd->resp_data_len based on cmd->status and cmd->data_direction,
+	 * therefore change them only if necessary
+	 */
+
+#if 0
+	switch (cmd->cdb[0]) {
+	default:
+		/* It's all good */
+		break;
+	}
+#endif
+	return res;
+}
+#endif
+
+static int __init changer_init(void)
+{
+	int res = 0;
+
+	changer_devtype.module = THIS_MODULE;
+
+	res = scst_register_dev_driver(&changer_devtype);
+	if (res < 0)
+		goto out;
+
+out:
+	return res;
+}
+
+static void __exit changer_exit(void)
+{
+	scst_unregister_dev_driver(&changer_devtype);
+	return;
+}
+
+module_init(changer_init);
+module_exit(changer_exit);
+
+MODULE_AUTHOR("Vladislav Bolkhovitin & Leonid Stoljar");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("SCSI medium changer (type 8) dev handler for SCST");
+MODULE_VERSION(SCST_VERSION_STRING);
diff -uprN orig/linux-2.6.35/drivers/scst/dev_handlers/scst_dev_handler.h linux-2.6.35/drivers/scst/dev_handlers/scst_dev_handler.h
--- orig/linux-2.6.35/drivers/scst/dev_handlers/scst_dev_handler.h
+++ linux-2.6.35/drivers/scst/dev_handlers/scst_dev_handler.h
@@ -0,0 +1,27 @@
+#ifndef __SCST_DEV_HANDLER_H
+#define __SCST_DEV_HANDLER_H
+
+#include <linux/module.h>
+#include <scsi/scsi_eh.h>
+#include <scst/scst_debug.h>
+
+#define SCST_DEV_UA_RETRIES 5
+#define SCST_PASSTHROUGH_RETRIES	0
+
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+
+#ifdef CONFIG_SCST_DEBUG
+#define SCST_DEFAULT_DEV_LOG_FLAGS (TRACE_OUT_OF_MEM | TRACE_PID | \
+	TRACE_LINE | TRACE_FUNCTION | TRACE_MGMT | TRACE_MINOR | \
+	TRACE_MGMT_DEBUG | TRACE_SPECIAL)
+#else
+#define SCST_DEFAULT_DEV_LOG_FLAGS (TRACE_OUT_OF_MEM | TRACE_MGMT | \
+	TRACE_SPECIAL)
+#endif
+
+static unsigned long dh_trace_flag = SCST_DEFAULT_DEV_LOG_FLAGS;
+#define trace_flag dh_trace_flag
+
+#endif /* defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING) */
+
+#endif /* __SCST_DEV_HANDLER_H */
diff -uprN orig/linux-2.6.35/drivers/scst/dev_handlers/scst_disk.c linux-2.6.35/drivers/scst/dev_handlers/scst_disk.c
--- orig/linux-2.6.35/drivers/scst/dev_handlers/scst_disk.c
+++ linux-2.6.35/drivers/scst/dev_handlers/scst_disk.c
@@ -0,0 +1,647 @@
+/*
+ *  scst_disk.c
+ *
+ *  Copyright (C) 2004 - 2010 Vladislav Bolkhovitin <vst@vlnb.net>
+ *  Copyright (C) 2004 - 2005 Leonid Stoljar
+ *  Copyright (C) 2007 - 2010 ID7 Ltd.
+ *
+ *  SCSI disk (type 0) dev handler
+ *  &
+ *  SCSI disk (type 0) "performance" device handler (skip all READ and WRITE
+ *   operations).
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation, version 2
+ *  of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ *  GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <scsi/scsi_host.h>
+#include <linux/slab.h>
+#include <asm/unaligned.h>
+
+#define LOG_PREFIX           "dev_disk"
+
+#include <scst/scst.h>
+#include "scst_dev_handler.h"
+
+# define DISK_NAME           "dev_disk"
+# define DISK_PERF_NAME      "dev_disk_perf"
+
+#define DISK_DEF_BLOCK_SHIFT	9
+
+struct disk_params {
+	int block_shift;
+};
+
+static int disk_attach(struct scst_device *dev);
+static void disk_detach(struct scst_device *dev);
+static int disk_parse(struct scst_cmd *cmd);
+static int disk_perf_exec(struct scst_cmd *cmd);
+static int disk_done(struct scst_cmd *cmd);
+static int disk_exec(struct scst_cmd *cmd);
+static bool disk_on_sg_tablesize_low(struct scst_cmd *cmd);
+
+static struct scst_dev_type disk_devtype = {
+	.name =			DISK_NAME,
+	.type =			TYPE_DISK,
+	.threads_num =		1,
+	.parse_atomic =		1,
+	.dev_done_atomic =	1,
+	.attach =		disk_attach,
+	.detach =		disk_detach,
+	.parse =		disk_parse,
+	.exec =			disk_exec,
+	.on_sg_tablesize_low = disk_on_sg_tablesize_low,
+	.dev_done =		disk_done,
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+	.default_trace_flags = SCST_DEFAULT_DEV_LOG_FLAGS,
+	.trace_flags = &trace_flag,
+#endif
+};
+
+static struct scst_dev_type disk_devtype_perf = {
+	.name =			DISK_PERF_NAME,
+	.type =			TYPE_DISK,
+	.parse_atomic =		1,
+	.dev_done_atomic =	1,
+	.attach =		disk_attach,
+	.detach =		disk_detach,
+	.parse =		disk_parse,
+	.exec =			disk_perf_exec,
+	.dev_done =		disk_done,
+	.on_sg_tablesize_low = disk_on_sg_tablesize_low,
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+	.default_trace_flags =	SCST_DEFAULT_DEV_LOG_FLAGS,
+	.trace_flags =		&trace_flag,
+#endif
+};
+
+static int __init init_scst_disk_driver(void)
+{
+	int res = 0;
+
+	disk_devtype.module = THIS_MODULE;
+
+	res = scst_register_dev_driver(&disk_devtype);
+	if (res < 0)
+		goto out;
+
+	disk_devtype_perf.module = THIS_MODULE;
+
+	res = scst_register_dev_driver(&disk_devtype_perf);
+	if (res < 0)
+		goto out_unreg;
+
+out:
+	return res;
+
+out_unreg:
+	scst_unregister_dev_driver(&disk_devtype);
+	goto out;
+}
+
+static void __exit exit_scst_disk_driver(void)
+{
+
+	scst_unregister_dev_driver(&disk_devtype_perf);
+	scst_unregister_dev_driver(&disk_devtype);
+	return;
+}
+
+module_init(init_scst_disk_driver);
+module_exit(exit_scst_disk_driver);
+
+static int disk_attach(struct scst_device *dev)
+{
+	int res, rc;
+	uint8_t cmd[10];
+	const int buffer_size = 512;
+	uint8_t *buffer = NULL;
+	int retries;
+	unsigned char sense_buffer[SCSI_SENSE_BUFFERSIZE];
+	enum dma_data_direction data_dir;
+	struct disk_params *params;
+
+	if (dev->scsi_dev == NULL ||
+	    dev->scsi_dev->type != dev->type) {
+		PRINT_ERROR("%s", "SCSI device not define or illegal type");
+		res = -ENODEV;
+		goto out;
+	}
+
+	params = kzalloc(sizeof(*params), GFP_KERNEL);
+	if (params == NULL) {
+		TRACE(TRACE_OUT_OF_MEM, "%s",
+		      "Unable to allocate struct disk_params");
+		res = -ENOMEM;
+		goto out;
+	}
+
+	buffer = kmalloc(buffer_size, GFP_KERNEL);
+	if (!buffer) {
+		TRACE(TRACE_OUT_OF_MEM, "%s", "Memory allocation failure");
+		res = -ENOMEM;
+		goto out_free_params;
+	}
+
+	/* Clear any existing UA's and get disk capacity (disk block size) */
+	memset(cmd, 0, sizeof(cmd));
+	cmd[0] = READ_CAPACITY;
+	cmd[1] = (dev->scsi_dev->scsi_level <= SCSI_2) ?
+	    ((dev->scsi_dev->lun << 5) & 0xe0) : 0;
+	retries = SCST_DEV_UA_RETRIES;
+	while (1) {
+		memset(buffer, 0, buffer_size);
+		memset(sense_buffer, 0, sizeof(sense_buffer));
+		data_dir = SCST_DATA_READ;
+
+		TRACE_DBG("%s", "Doing READ_CAPACITY");
+		rc = scsi_execute(dev->scsi_dev, cmd, data_dir, buffer,
+				   buffer_size, sense_buffer,
+				   SCST_GENERIC_DISK_REG_TIMEOUT, 3, 0
+				   , NULL
+				  );
+
+		TRACE_DBG("READ_CAPACITY done: %x", rc);
+
+		if ((rc == 0) ||
+		    !scst_analyze_sense(sense_buffer,
+				sizeof(sense_buffer), SCST_SENSE_KEY_VALID,
+				UNIT_ATTENTION, 0, 0))
+			break;
+		if (!--retries) {
+			PRINT_ERROR("UA not clear after %d retries",
+				SCST_DEV_UA_RETRIES);
+			res = -ENODEV;
+			goto out_free_buf;
+		}
+	}
+	if (rc == 0) {
+		int sector_size = ((buffer[4] << 24) | (buffer[5] << 16) |
+				     (buffer[6] << 8) | (buffer[7] << 0));
+		if (sector_size == 0)
+			params->block_shift = DISK_DEF_BLOCK_SHIFT;
+		else
+			params->block_shift =
+				scst_calc_block_shift(sector_size);
+	} else {
+		params->block_shift = DISK_DEF_BLOCK_SHIFT;
+		TRACE(TRACE_MINOR, "Read capacity failed: %x, using default "
+			"sector size %d", rc, params->block_shift);
+		PRINT_BUFF_FLAG(TRACE_MINOR, "Returned sense", sense_buffer,
+			sizeof(sense_buffer));
+	}
+
+	res = scst_obtain_device_parameters(dev);
+	if (res != 0) {
+		PRINT_ERROR("Failed to obtain control parameters for device "
+			"%s", dev->virt_name);
+		goto out_free_buf;
+	}
+
+out_free_buf:
+	kfree(buffer);
+
+out_free_params:
+	if (res == 0)
+		dev->dh_priv = params;
+	else
+		kfree(params);
+
+out:
+	return res;
+}
+
+static void disk_detach(struct scst_device *dev)
+{
+	struct disk_params *params =
+		(struct disk_params *)dev->dh_priv;
+
+	kfree(params);
+	dev->dh_priv = NULL;
+	return;
+}
+
+static int disk_get_block_shift(struct scst_cmd *cmd)
+{
+	struct disk_params *params = (struct disk_params *)cmd->dev->dh_priv;
+	/*
+	 * No need for locks here, since *_detach() can not be
+	 * called, when there are existing commands.
+	 */
+	return params->block_shift;
+}
+
+static int disk_parse(struct scst_cmd *cmd)
+{
+	int res = SCST_CMD_STATE_DEFAULT;
+
+	scst_sbc_generic_parse(cmd, disk_get_block_shift);
+
+	cmd->retries = SCST_PASSTHROUGH_RETRIES;
+
+	return res;
+}
+
+static void disk_set_block_shift(struct scst_cmd *cmd, int block_shift)
+{
+	struct disk_params *params = (struct disk_params *)cmd->dev->dh_priv;
+	/*
+	 * No need for locks here, since *_detach() can not be
+	 * called, when there are existing commands.
+	 */
+	if (block_shift != 0)
+		params->block_shift = block_shift;
+	else
+		params->block_shift = DISK_DEF_BLOCK_SHIFT;
+	return;
+}
+
+static int disk_done(struct scst_cmd *cmd)
+{
+	int res = SCST_CMD_STATE_DEFAULT;
+
+	res = scst_block_generic_dev_done(cmd, disk_set_block_shift);
+	return res;
+}
+
+static bool disk_on_sg_tablesize_low(struct scst_cmd *cmd)
+{
+	bool res;
+
+	switch (cmd->cdb[0]) {
+	case WRITE_6:
+	case READ_6:
+	case WRITE_10:
+	case READ_10:
+	case WRITE_VERIFY:
+	case WRITE_12:
+	case READ_12:
+	case WRITE_VERIFY_12:
+	case WRITE_16:
+	case READ_16:
+	case WRITE_VERIFY_16:
+		res = true;
+		/* See comment in disk_exec */
+		cmd->inc_expected_sn_on_done = 1;
+		break;
+	default:
+		res = false;
+		break;
+	}
+	return res;
+}
+
+struct disk_work {
+	struct scst_cmd *cmd;
+	struct completion disk_work_cmpl;
+	volatile int result;
+	unsigned int left;
+	uint64_t save_lba;
+	unsigned int save_len;
+	struct scatterlist *save_sg;
+	int save_sg_cnt;
+};
+
+static int disk_cdb_get_transfer_data(const uint8_t *cdb,
+	uint64_t *out_lba, unsigned int *out_length)
+{
+	int res;
+	uint64_t lba;
+	unsigned int len;
+
+	switch (cdb[0]) {
+	case WRITE_6:
+	case READ_6:
+		lba = be16_to_cpu(get_unaligned((__be16 *)&cdb[2]));
+		len = cdb[4];
+		break;
+	case WRITE_10:
+	case READ_10:
+	case WRITE_VERIFY:
+		lba = be32_to_cpu(get_unaligned((__be32 *)&cdb[2]));
+		len = be16_to_cpu(get_unaligned((__be16 *)&cdb[7]));
+		break;
+	case WRITE_12:
+	case READ_12:
+	case WRITE_VERIFY_12:
+		lba = be32_to_cpu(get_unaligned((__be32 *)&cdb[2]));
+		len = be32_to_cpu(get_unaligned((__be32 *)&cdb[6]));
+		break;
+	case WRITE_16:
+	case READ_16:
+	case WRITE_VERIFY_16:
+		lba = be64_to_cpu(get_unaligned((__be64 *)&cdb[2]));
+		len = be32_to_cpu(get_unaligned((__be32 *)&cdb[10]));
+		break;
+	default:
+		res = -EINVAL;
+		goto out;
+	}
+
+	res = 0;
+	*out_lba = lba;
+	*out_length = len;
+
+	TRACE_DBG("LBA %lld, length %d", (unsigned long long)lba, len);
+
+out:
+	return res;
+}
+
+static int disk_cdb_set_transfer_data(uint8_t *cdb,
+	uint64_t lba, unsigned int len)
+{
+	int res;
+
+	switch (cdb[0]) {
+	case WRITE_6:
+	case READ_6:
+		put_unaligned(cpu_to_be16(lba), (__be16 *)&cdb[2]);
+		cdb[4] = len;
+		break;
+	case WRITE_10:
+	case READ_10:
+	case WRITE_VERIFY:
+		put_unaligned(cpu_to_be32(lba), (__be32 *)&cdb[2]);
+		put_unaligned(cpu_to_be16(len), (__be16 *)&cdb[7]);
+		break;
+	case WRITE_12:
+	case READ_12:
+	case WRITE_VERIFY_12:
+		put_unaligned(cpu_to_be32(lba), (__be32 *)&cdb[2]);
+		put_unaligned(cpu_to_be32(len), (__be32 *)&cdb[6]);
+		break;
+	case WRITE_16:
+	case READ_16:
+	case WRITE_VERIFY_16:
+		put_unaligned(cpu_to_be64(lba), (__be64 *)&cdb[2]);
+		put_unaligned(cpu_to_be32(len), (__be32 *)&cdb[10]);
+		break;
+	default:
+		res = -EINVAL;
+		goto out;
+	}
+
+	res = 0;
+
+	TRACE_DBG("LBA %lld, length %d", (unsigned long long)lba, len);
+	TRACE_BUFFER("New CDB", cdb, SCST_MAX_CDB_SIZE);
+
+out:
+	return res;
+}
+
+static void disk_restore_sg(struct disk_work *work)
+{
+	disk_cdb_set_transfer_data(work->cmd->cdb, work->save_lba, work->save_len);
+	work->cmd->sg = work->save_sg;
+	work->cmd->sg_cnt = work->save_sg_cnt;
+	return;
+}
+
+static void disk_cmd_done(void *data, char *sense, int result, int resid)
+{
+	struct disk_work *work = data;
+
+	TRACE_DBG("work %p, cmd %p, left %d, result %d, sense %p, resid %d",
+		work, work->cmd, work->left, result, sense, resid);
+
+	if (result == SAM_STAT_GOOD)
+		goto out_complete;
+
+	work->result = result;
+
+	disk_restore_sg(work);
+
+	scst_pass_through_cmd_done(work->cmd, sense, result, resid + work->left);
+
+out_complete:
+	complete_all(&work->disk_work_cmpl);
+	return;
+}
+
+/* Executes command and split CDB, if necessary */
+static int disk_exec(struct scst_cmd *cmd)
+{
+	int res, rc;
+	struct disk_params *params = (struct disk_params *)cmd->dev->dh_priv;
+	struct disk_work work;
+	unsigned int offset, cur_len; /* in blocks */
+	struct scatterlist *sg, *start_sg;
+	int cur_sg_cnt;
+	int sg_tablesize = cmd->dev->scsi_dev->host->sg_tablesize;
+	int max_sectors = cmd->dev->scsi_dev->host->max_sectors;
+	int num, j;
+
+	if (unlikely(((max_sectors << params->block_shift) & ~PAGE_MASK) != 0)) {
+		int mlen = max_sectors << params->block_shift;
+		int pg = ((mlen >> PAGE_SHIFT) + ((mlen & ~PAGE_MASK) != 0)) - 1;
+		int adj_len = pg << PAGE_SHIFT;
+		max_sectors = adj_len >> params->block_shift;
+		if (max_sectors == 0) {
+			PRINT_ERROR("Too low max sectors %d",
+				cmd->dev->scsi_dev->host->max_sectors);
+			goto out_error;
+		}
+	}
+
+	if (unlikely((cmd->bufflen >> params->block_shift) > max_sectors)) {
+		if ((cmd->out_bufflen >> params->block_shift) > max_sectors) {
+			PRINT_ERROR("Too limited max_sectors %d for "
+				"bidirectional cmd %x (out_bufflen %d)",
+				max_sectors, cmd->cdb[0], cmd->out_bufflen);
+			/* Let lower level handle it */
+			res = SCST_EXEC_NOT_COMPLETED;
+			goto out;
+		}
+		goto split;
+	}
+
+	if (likely(cmd->sg_cnt <= sg_tablesize)) {
+		res = SCST_EXEC_NOT_COMPLETED;
+		goto out;
+	}
+
+split:
+	BUG_ON(cmd->out_sg_cnt > sg_tablesize);
+	BUG_ON((cmd->out_bufflen >> params->block_shift) > max_sectors);
+
+	/*
+	 * We don't support changing BIDI CDBs (see disk_on_sg_tablesize_low()),
+	 * so use only sg_cnt
+	 */
+
+	memset(&work, 0, sizeof(work));
+	work.cmd = cmd;
+	work.save_sg = cmd->sg;
+	work.save_sg_cnt = cmd->sg_cnt;
+	rc = disk_cdb_get_transfer_data(cmd->cdb, &work.save_lba,
+		&work.save_len);
+	if (rc != 0)
+		goto out_error;
+
+	rc = scst_check_local_events(cmd);
+	if (unlikely(rc != 0))
+		goto out_done;
+
+	cmd->status = 0;
+	cmd->msg_status = 0;
+	cmd->host_status = DID_OK;
+	cmd->driver_status = 0;
+
+	TRACE_DBG("cmd %p, save_sg %p, save_sg_cnt %d, save_lba %lld, "
+		"save_len %d (sg_tablesize %d, max_sectors %d, block_shift %d, "
+		"sizeof(*sg) 0x%zx)", cmd, work.save_sg, work.save_sg_cnt,
+		(unsigned long long)work.save_lba, work.save_len,
+		sg_tablesize, max_sectors, params->block_shift, sizeof(*sg));
+
+	/*
+	 * If we submit all chunks async'ly, it will be very not trivial what
+	 * to do if several of them finish with sense or residual. So, let's
+	 * do it synchronously.
+	 */
+
+	num = 1;
+	j = 0;
+	offset = 0;
+	cur_len = 0;
+	sg = work.save_sg;
+	start_sg = sg;
+	cur_sg_cnt = 0;
+	while (1) {
+		unsigned int l;
+
+		if (unlikely(sg_is_chain(&sg[j]))) {
+			bool reset_start_sg = (start_sg == &sg[j]);
+			sg = sg_chain_ptr(&sg[j]);
+			j = 0;
+			if (reset_start_sg)
+				start_sg = sg;
+		}
+
+		l = sg[j].length >> params->block_shift;
+		cur_len += l;
+		cur_sg_cnt++;
+
+		TRACE_DBG("l %d, j %d, num %d, offset %d, cur_len %d, "
+			"cur_sg_cnt %d, start_sg %p", l, j, num, offset,
+			cur_len, cur_sg_cnt, start_sg);
+
+		if (((num % sg_tablesize) == 0) ||
+		     (num == work.save_sg_cnt) ||
+		     (cur_len >= max_sectors)) {
+			TRACE_DBG("%s", "Execing...");
+
+			disk_cdb_set_transfer_data(cmd->cdb,
+				work.save_lba + offset, cur_len);
+			cmd->sg = start_sg;
+			cmd->sg_cnt = cur_sg_cnt;
+
+			work.left = work.save_len - (offset + cur_len);
+			init_completion(&work.disk_work_cmpl);
+
+			rc = scst_scsi_exec_async(cmd, &work, disk_cmd_done);
+			if (unlikely(rc != 0)) {
+				PRINT_ERROR("scst_scsi_exec_async() failed: %d",
+					rc);
+				goto out_err_restore;
+			}
+
+			wait_for_completion(&work.disk_work_cmpl);
+
+			if (work.result != SAM_STAT_GOOD) {
+				/* cmd can be already dead */
+				res = SCST_EXEC_COMPLETED;
+				goto out;
+			}
+
+			offset += cur_len;
+			cur_len = 0;
+			cur_sg_cnt = 0;
+			start_sg = &sg[j+1];
+
+			if (num == work.save_sg_cnt)
+				break;
+		}
+		num++;
+		j++;
+	}
+
+	cmd->completed = 1;
+
+out_restore:
+	disk_restore_sg(&work);
+
+out_done:
+	res = SCST_EXEC_COMPLETED;
+	cmd->scst_cmd_done(cmd, SCST_CMD_STATE_DEFAULT, SCST_CONTEXT_SAME);
+
+out:
+	return res;
+
+out_err_restore:
+	scst_set_cmd_error(cmd, SCST_LOAD_SENSE(scst_sense_hardw_error));
+	goto out_restore;
+
+out_error:
+	scst_set_cmd_error(cmd, SCST_LOAD_SENSE(scst_sense_hardw_error));
+	goto out_done;
+}
+
+static int disk_perf_exec(struct scst_cmd *cmd)
+{
+	int res, rc;
+	int opcode = cmd->cdb[0];
+
+	rc = scst_check_local_events(cmd);
+	if (unlikely(rc != 0))
+		goto out_done;
+
+	cmd->status = 0;
+	cmd->msg_status = 0;
+	cmd->host_status = DID_OK;
+	cmd->driver_status = 0;
+
+	switch (opcode) {
+	case WRITE_6:
+	case WRITE_10:
+	case WRITE_12:
+	case WRITE_16:
+	case READ_6:
+	case READ_10:
+	case READ_12:
+	case READ_16:
+	case WRITE_VERIFY:
+	case WRITE_VERIFY_12:
+	case WRITE_VERIFY_16:
+		goto out_complete;
+	}
+
+	res = SCST_EXEC_NOT_COMPLETED;
+
+out:
+	return res;
+
+out_complete:
+	cmd->completed = 1;
+
+out_done:
+	res = SCST_EXEC_COMPLETED;
+	cmd->scst_cmd_done(cmd, SCST_CMD_STATE_DEFAULT, SCST_CONTEXT_SAME);
+	goto out;
+}
+
+MODULE_AUTHOR("Vladislav Bolkhovitin & Leonid Stoljar");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("SCSI disk (type 0) dev handler for SCST");
+MODULE_VERSION(SCST_VERSION_STRING);
+
diff -uprN orig/linux-2.6.35/drivers/scst/dev_handlers/scst_modisk.c linux-2.6.35/drivers/scst/dev_handlers/scst_modisk.c
--- orig/linux-2.6.35/drivers/scst/dev_handlers/scst_modisk.c
+++ linux-2.6.35/drivers/scst/dev_handlers/scst_modisk.c
@@ -0,0 +1,328 @@
+/*
+ *  scst_modisk.c
+ *
+ *  Copyright (C) 2004 - 2010 Vladislav Bolkhovitin <vst@vlnb.net>
+ *  Copyright (C) 2004 - 2005 Leonid Stoljar
+ *  Copyright (C) 2007 - 2010 ID7 Ltd.
+ *
+ *  SCSI MO disk (type 7) dev handler
+ *  &
+ *  SCSI MO disk (type 7) "performance" device handler (skip all READ and WRITE
+ *   operations).
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation, version 2
+ *  of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ *  GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <scsi/scsi_host.h>
+#include <linux/slab.h>
+
+#define LOG_PREFIX             "dev_modisk"
+
+#include <scst/scst.h>
+#include "scst_dev_handler.h"
+
+# define MODISK_NAME           "dev_modisk"
+# define MODISK_PERF_NAME      "dev_modisk_perf"
+
+#define MODISK_DEF_BLOCK_SHIFT    10
+
+struct modisk_params {
+	int block_shift;
+};
+
+static int modisk_attach(struct scst_device *);
+static void modisk_detach(struct scst_device *);
+static int modisk_parse(struct scst_cmd *);
+static int modisk_done(struct scst_cmd *);
+static int modisk_perf_exec(struct scst_cmd *);
+
+static struct scst_dev_type modisk_devtype = {
+	.name =			MODISK_NAME,
+	.type =			TYPE_MOD,
+	.threads_num =		1,
+	.parse_atomic =		1,
+	.dev_done_atomic =	1,
+	.attach =		modisk_attach,
+	.detach =		modisk_detach,
+	.parse =		modisk_parse,
+	.dev_done =		modisk_done,
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+	.default_trace_flags =	SCST_DEFAULT_DEV_LOG_FLAGS,
+	.trace_flags =		&trace_flag,
+#endif
+};
+
+static struct scst_dev_type modisk_devtype_perf = {
+	.name =			MODISK_PERF_NAME,
+	.type =			TYPE_MOD,
+	.parse_atomic =		1,
+	.dev_done_atomic =	1,
+	.attach =		modisk_attach,
+	.detach =		modisk_detach,
+	.parse =		modisk_parse,
+	.dev_done =		modisk_done,
+	.exec =			modisk_perf_exec,
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+	.default_trace_flags =	SCST_DEFAULT_DEV_LOG_FLAGS,
+	.trace_flags =		&trace_flag,
+#endif
+};
+
+static int __init init_scst_modisk_driver(void)
+{
+	int res = 0;
+
+	modisk_devtype.module = THIS_MODULE;
+
+	res = scst_register_dev_driver(&modisk_devtype);
+	if (res < 0)
+		goto out;
+
+	modisk_devtype_perf.module = THIS_MODULE;
+
+	res = scst_register_dev_driver(&modisk_devtype_perf);
+	if (res < 0)
+		goto out_unreg;
+
+out:
+	return res;
+
+out_unreg:
+	scst_unregister_dev_driver(&modisk_devtype);
+	goto out;
+}
+
+static void __exit exit_scst_modisk_driver(void)
+{
+
+	scst_unregister_dev_driver(&modisk_devtype_perf);
+	scst_unregister_dev_driver(&modisk_devtype);
+	return;
+}
+
+module_init(init_scst_modisk_driver);
+module_exit(exit_scst_modisk_driver);
+
+static int modisk_attach(struct scst_device *dev)
+{
+	int res, rc;
+	uint8_t cmd[10];
+	const int buffer_size = 512;
+	uint8_t *buffer = NULL;
+	int retries;
+	unsigned char sense_buffer[SCSI_SENSE_BUFFERSIZE];
+	enum dma_data_direction data_dir;
+	struct modisk_params *params;
+
+	if (dev->scsi_dev == NULL ||
+	    dev->scsi_dev->type != dev->type) {
+		PRINT_ERROR("%s", "SCSI device not define or illegal type");
+		res = -ENODEV;
+		goto out;
+	}
+
+	params = kzalloc(sizeof(*params), GFP_KERNEL);
+	if (params == NULL) {
+		TRACE(TRACE_OUT_OF_MEM, "%s",
+		      "Unable to allocate struct modisk_params");
+		res = -ENOMEM;
+		goto out;
+	}
+	params->block_shift = MODISK_DEF_BLOCK_SHIFT;
+
+	/*
+	 * If the device is offline, don't try to read capacity or any
+	 * of the other stuff
+	 */
+	if (dev->scsi_dev->sdev_state == SDEV_OFFLINE) {
+		TRACE_DBG("%s", "Device is offline");
+		res = -ENODEV;
+		goto out_free_params;
+	}
+
+	buffer = kmalloc(buffer_size, GFP_KERNEL);
+	if (!buffer) {
+		TRACE(TRACE_OUT_OF_MEM, "%s", "Memory allocation failure");
+		res = -ENOMEM;
+		goto out_free_params;
+	}
+
+	/*
+	 * Clear any existing UA's and get modisk capacity (modisk block
+	 * size).
+	 */
+	memset(cmd, 0, sizeof(cmd));
+	cmd[0] = READ_CAPACITY;
+	cmd[1] = (dev->scsi_dev->scsi_level <= SCSI_2) ?
+	    ((dev->scsi_dev->lun << 5) & 0xe0) : 0;
+	retries = SCST_DEV_UA_RETRIES;
+	while (1) {
+		memset(buffer, 0, buffer_size);
+		memset(sense_buffer, 0, sizeof(sense_buffer));
+		data_dir = SCST_DATA_READ;
+
+		TRACE_DBG("%s", "Doing READ_CAPACITY");
+		rc = scsi_execute(dev->scsi_dev, cmd, data_dir, buffer,
+				   buffer_size, sense_buffer,
+				   SCST_GENERIC_MODISK_REG_TIMEOUT, 3, 0
+				   , NULL
+				  );
+
+		TRACE_DBG("READ_CAPACITY done: %x", rc);
+
+		if (!rc || !scst_analyze_sense(sense_buffer,
+				sizeof(sense_buffer), SCST_SENSE_KEY_VALID,
+				UNIT_ATTENTION, 0, 0))
+			break;
+
+		if (!--retries) {
+			PRINT_ERROR("UA not cleared after %d retries",
+				    SCST_DEV_UA_RETRIES);
+			res = -ENODEV;
+			goto out_free_buf;
+		}
+	}
+
+	if (rc == 0) {
+		int sector_size = ((buffer[4] << 24) | (buffer[5] << 16) |
+				       (buffer[6] << 8) | (buffer[7] << 0));
+		if (sector_size == 0)
+			params->block_shift = MODISK_DEF_BLOCK_SHIFT;
+		else
+			params->block_shift =
+				scst_calc_block_shift(sector_size);
+		TRACE_DBG("Sector size is %i scsi_level %d(SCSI_2 %d)",
+		      sector_size, dev->scsi_dev->scsi_level, SCSI_2);
+	} else {
+		params->block_shift = MODISK_DEF_BLOCK_SHIFT;
+		TRACE(TRACE_MINOR, "Read capacity failed: %x, using default "
+			"sector size %d", rc, params->block_shift);
+		PRINT_BUFF_FLAG(TRACE_MINOR, "Returned sense", sense_buffer,
+			sizeof(sense_buffer));
+	}
+
+	res = scst_obtain_device_parameters(dev);
+	if (res != 0) {
+		PRINT_ERROR("Failed to obtain control parameters for device "
+			"%s: %x", dev->virt_name, res);
+		goto out_free_buf;
+	}
+
+out_free_buf:
+	kfree(buffer);
+
+out_free_params:
+	if (res == 0)
+		dev->dh_priv = params;
+	else
+		kfree(params);
+
+out:
+	return res;
+}
+
+static void modisk_detach(struct scst_device *dev)
+{
+	struct modisk_params *params =
+		(struct modisk_params *)dev->dh_priv;
+
+	kfree(params);
+	dev->dh_priv = NULL;
+	return;
+}
+
+static int modisk_get_block_shift(struct scst_cmd *cmd)
+{
+	struct modisk_params *params =
+		(struct modisk_params *)cmd->dev->dh_priv;
+	/*
+	 * No need for locks here, since *_detach() can not be
+	 * called, when there are existing commands.
+	 */
+	return params->block_shift;
+}
+
+static int modisk_parse(struct scst_cmd *cmd)
+{
+	int res = SCST_CMD_STATE_DEFAULT;
+
+	scst_modisk_generic_parse(cmd, modisk_get_block_shift);
+
+	cmd->retries = SCST_PASSTHROUGH_RETRIES;
+
+	return res;
+}
+
+static void modisk_set_block_shift(struct scst_cmd *cmd, int block_shift)
+{
+	struct modisk_params *params =
+		(struct modisk_params *)cmd->dev->dh_priv;
+	/*
+	 * No need for locks here, since *_detach() can not be
+	 * called, when there are existing commands.
+	 */
+	if (block_shift != 0)
+		params->block_shift = block_shift;
+	else
+		params->block_shift = MODISK_DEF_BLOCK_SHIFT;
+	return;
+}
+
+static int modisk_done(struct scst_cmd *cmd)
+{
+	int res;
+
+	res = scst_block_generic_dev_done(cmd, modisk_set_block_shift);
+	return res;
+}
+
+static int modisk_perf_exec(struct scst_cmd *cmd)
+{
+	int res = SCST_EXEC_NOT_COMPLETED, rc;
+	int opcode = cmd->cdb[0];
+
+	rc = scst_check_local_events(cmd);
+	if (unlikely(rc != 0))
+		goto out_done;
+
+	cmd->status = 0;
+	cmd->msg_status = 0;
+	cmd->host_status = DID_OK;
+	cmd->driver_status = 0;
+
+	switch (opcode) {
+	case WRITE_6:
+	case WRITE_10:
+	case WRITE_12:
+	case WRITE_16:
+	case READ_6:
+	case READ_10:
+	case READ_12:
+	case READ_16:
+		cmd->completed = 1;
+		goto out_done;
+	}
+
+out:
+	return res;
+
+out_done:
+	res = SCST_EXEC_COMPLETED;
+	cmd->scst_cmd_done(cmd, SCST_CMD_STATE_DEFAULT, SCST_CONTEXT_SAME);
+	goto out;
+}
+
+MODULE_AUTHOR("Vladislav Bolkhovitin & Leonid Stoljar");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("SCSI MO disk (type 7) dev handler for SCST");
+MODULE_VERSION(SCST_VERSION_STRING);
diff -uprN orig/linux-2.6.35/drivers/scst/dev_handlers/scst_processor.c linux-2.6.35/drivers/scst/dev_handlers/scst_processor.c
--- orig/linux-2.6.35/drivers/scst/dev_handlers/scst_processor.c
+++ linux-2.6.35/drivers/scst/dev_handlers/scst_processor.c
@@ -0,0 +1,167 @@
+/*
+ *  scst_processor.c
+ *
+ *  Copyright (C) 2004 - 2010 Vladislav Bolkhovitin <vst@vlnb.net>
+ *  Copyright (C) 2004 - 2005 Leonid Stoljar
+ *  Copyright (C) 2007 - 2010 ID7 Ltd.
+ *
+ *  SCSI medium processor (type 3) dev handler
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation, version 2
+ *  of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ *  GNU General Public License for more details.
+ */
+
+#include <scsi/scsi_host.h>
+#include <linux/slab.h>
+
+#define LOG_PREFIX "dev_processor"
+
+#include <scst/scst.h>
+#include "scst_dev_handler.h"
+
+#define PROCESSOR_NAME	"dev_processor"
+
+#define PROCESSOR_RETRIES	2
+
+static int processor_attach(struct scst_device *);
+/*static void processor_detach(struct scst_device *);*/
+static int processor_parse(struct scst_cmd *);
+/*static int processor_done(struct scst_cmd *);*/
+
+static struct scst_dev_type processor_devtype = {
+	.name =			PROCESSOR_NAME,
+	.type =			TYPE_PROCESSOR,
+	.threads_num =		1,
+	.parse_atomic =		1,
+/*	.dev_done_atomic =	1,*/
+	.attach =		processor_attach,
+/*	.detach =		processor_detach,*/
+	.parse =		processor_parse,
+/*	.dev_done =		processor_done*/
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+	.default_trace_flags =	SCST_DEFAULT_DEV_LOG_FLAGS,
+	.trace_flags =		&trace_flag,
+#endif
+};
+
+static int processor_attach(struct scst_device *dev)
+{
+	int res, rc;
+	int retries;
+
+	if (dev->scsi_dev == NULL ||
+	    dev->scsi_dev->type != dev->type) {
+		PRINT_ERROR("%s", "SCSI device not define or illegal type");
+		res = -ENODEV;
+		goto out;
+	}
+
+	/*
+	 * If the device is offline, don't try to read capacity or any
+	 * of the other stuff
+	 */
+	if (dev->scsi_dev->sdev_state == SDEV_OFFLINE) {
+		TRACE_DBG("%s", "Device is offline");
+		res = -ENODEV;
+		goto out;
+	}
+
+	retries = SCST_DEV_UA_RETRIES;
+	do {
+		TRACE_DBG("%s", "Doing TEST_UNIT_READY");
+		rc = scsi_test_unit_ready(dev->scsi_dev,
+			SCST_GENERIC_PROCESSOR_TIMEOUT, PROCESSOR_RETRIES
+					  , NULL);
+		TRACE_DBG("TEST_UNIT_READY done: %x", rc);
+	} while ((--retries > 0) && rc);
+
+	if (rc) {
+		PRINT_WARNING("Unit not ready: %x", rc);
+		/* Let's try not to be too smart and continue processing */
+	}
+
+	res = scst_obtain_device_parameters(dev);
+	if (res != 0) {
+		PRINT_ERROR("Failed to obtain control parameters for device "
+			"%s", dev->virt_name);
+		goto out;
+	}
+
+out:
+	return res;
+}
+
+#if 0
+void processor_detach(struct scst_device *dev)
+{
+	return;
+}
+#endif
+
+static int processor_parse(struct scst_cmd *cmd)
+{
+	int res = SCST_CMD_STATE_DEFAULT;
+
+	scst_processor_generic_parse(cmd, NULL);
+
+	cmd->retries = SCST_PASSTHROUGH_RETRIES;
+
+	return res;
+}
+
+#if 0
+int processor_done(struct scst_cmd *cmd)
+{
+	int res = SCST_CMD_STATE_DEFAULT;
+
+	/*
+	 * SCST sets good defaults for cmd->is_send_status and
+	 * cmd->resp_data_len based on cmd->status and cmd->data_direction,
+	 * therefore change them only if necessary.
+	 */
+
+#if 0
+	switch (cmd->cdb[0]) {
+	default:
+		/* It's all good */
+		break;
+	}
+#endif
+	return res;
+}
+#endif
+
+static int __init processor_init(void)
+{
+	int res = 0;
+
+	processor_devtype.module = THIS_MODULE;
+
+	res = scst_register_dev_driver(&processor_devtype);
+	if (res < 0)
+		goto out;
+
+out:
+	return res;
+}
+
+static void __exit processor_exit(void)
+{
+	scst_unregister_dev_driver(&processor_devtype);
+	return;
+}
+
+module_init(processor_init);
+module_exit(processor_exit);
+
+MODULE_AUTHOR("Vladislav Bolkhovitin & Leonid Stoljar");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("SCSI medium processor (type 3) dev handler for SCST");
+MODULE_VERSION(SCST_VERSION_STRING);
diff -uprN orig/linux-2.6.35/drivers/scst/dev_handlers/scst_raid.c linux-2.6.35/drivers/scst/dev_handlers/scst_raid.c
--- orig/linux-2.6.35/drivers/scst/dev_handlers/scst_raid.c
+++ linux-2.6.35/drivers/scst/dev_handlers/scst_raid.c
@@ -0,0 +1,168 @@
+/*
+ *  scst_raid.c
+ *
+ *  Copyright (C) 2004 - 2010 Vladislav Bolkhovitin <vst@vlnb.net>
+ *  Copyright (C) 2004 - 2005 Leonid Stoljar
+ *  Copyright (C) 2007 - 2010 ID7 Ltd.
+ *
+ *  SCSI raid(controller) (type 0xC) dev handler
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation, version 2
+ *  of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ *  GNU General Public License for more details.
+ */
+
+#define LOG_PREFIX      "dev_raid"
+
+#include <scsi/scsi_host.h>
+#include <linux/slab.h>
+
+#include <scst/scst.h>
+#include "scst_dev_handler.h"
+
+#define RAID_NAME	"dev_raid"
+
+#define RAID_RETRIES		2
+
+static int raid_attach(struct scst_device *);
+/* static void raid_detach(struct scst_device *); */
+static int raid_parse(struct scst_cmd *);
+/* static int raid_done(struct scst_cmd *); */
+
+static struct scst_dev_type raid_devtype = {
+	.name =			RAID_NAME,
+	.type =			TYPE_RAID,
+	.threads_num =		1,
+	.parse_atomic =		1,
+/*	.dev_done_atomic =	1,*/
+	.attach =		raid_attach,
+/*	.detach =		raid_detach,*/
+	.parse =		raid_parse,
+/*	.dev_done =		raid_done,*/
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+	.default_trace_flags =	SCST_DEFAULT_DEV_LOG_FLAGS,
+	.trace_flags =		&trace_flag,
+#endif
+};
+
+static int raid_attach(struct scst_device *dev)
+{
+	int res, rc;
+	int retries;
+
+	if (dev->scsi_dev == NULL ||
+	    dev->scsi_dev->type != dev->type) {
+		PRINT_ERROR("%s", "SCSI device not define or illegal type");
+		res = -ENODEV;
+		goto out;
+	}
+
+	/*
+	 * If the device is offline, don't try to read capacity or any
+	 * of the other stuff
+	 */
+	if (dev->scsi_dev->sdev_state == SDEV_OFFLINE) {
+		TRACE_DBG("%s", "Device is offline");
+		res = -ENODEV;
+		goto out;
+	}
+
+	retries = SCST_DEV_UA_RETRIES;
+	do {
+		TRACE_DBG("%s", "Doing TEST_UNIT_READY");
+		rc = scsi_test_unit_ready(dev->scsi_dev,
+			SCST_GENERIC_RAID_TIMEOUT, RAID_RETRIES
+					  , NULL);
+		TRACE_DBG("TEST_UNIT_READY done: %x", rc);
+	} while ((--retries > 0) && rc);
+
+	if (rc) {
+		PRINT_WARNING("Unit not ready: %x", rc);
+		/* Let's try not to be too smart and continue processing */
+	}
+
+	res = scst_obtain_device_parameters(dev);
+	if (res != 0) {
+		PRINT_ERROR("Failed to obtain control parameters for device "
+			"%s", dev->virt_name);
+		goto out;
+	}
+
+out:
+	return res;
+}
+
+#if 0
+void raid_detach(struct scst_device *dev)
+{
+	return;
+}
+#endif
+
+static int raid_parse(struct scst_cmd *cmd)
+{
+	int res = SCST_CMD_STATE_DEFAULT;
+
+	scst_raid_generic_parse(cmd, NULL);
+
+	cmd->retries = SCST_PASSTHROUGH_RETRIES;
+
+	return res;
+}
+
+#if 0
+int raid_done(struct scst_cmd *cmd)
+{
+	int res = SCST_CMD_STATE_DEFAULT;
+
+	/*
+	 * SCST sets good defaults for cmd->is_send_status and
+	 * cmd->resp_data_len based on cmd->status and cmd->data_direction,
+	 * therefore change them only if necessary.
+	 */
+
+#if 0
+	switch (cmd->cdb[0]) {
+	default:
+		/* It's all good */
+		break;
+	}
+#endif
+	return res;
+}
+#endif
+
+static int __init raid_init(void)
+{
+	int res = 0;
+
+	raid_devtype.module = THIS_MODULE;
+
+	res = scst_register_dev_driver(&raid_devtype);
+	if (res < 0)
+		goto out;
+
+out:
+	return res;
+
+}
+
+static void __exit raid_exit(void)
+{
+	scst_unregister_dev_driver(&raid_devtype);
+	return;
+}
+
+module_init(raid_init);
+module_exit(raid_exit);
+
+MODULE_AUTHOR("Vladislav Bolkhovitin & Leonid Stoljar");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("SCSI raid(controller) (type 0xC) dev handler for SCST");
+MODULE_VERSION(SCST_VERSION_STRING);
diff -uprN orig/linux-2.6.35/drivers/scst/dev_handlers/scst_tape.c linux-2.6.35/drivers/scst/dev_handlers/scst_tape.c
--- orig/linux-2.6.35/drivers/scst/dev_handlers/scst_tape.c
+++ linux-2.6.35/drivers/scst/dev_handlers/scst_tape.c
@@ -0,0 +1,361 @@
+/*
+ *  scst_tape.c
+ *
+ *  Copyright (C) 2004 - 2010 Vladislav Bolkhovitin <vst@vlnb.net>
+ *  Copyright (C) 2004 - 2005 Leonid Stoljar
+ *  Copyright (C) 2007 - 2010 ID7 Ltd.
+ *
+ *  SCSI tape (type 1) dev handler
+ *  &
+ *  SCSI tape (type 1) "performance" device handler (skip all READ and WRITE
+ *   operations).
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation, version 2
+ *  of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ *  GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <scsi/scsi_host.h>
+#include <linux/slab.h>
+
+#define LOG_PREFIX           "dev_tape"
+
+#include <scst/scst.h>
+#include "scst_dev_handler.h"
+
+# define TAPE_NAME           "dev_tape"
+# define TAPE_PERF_NAME      "dev_tape_perf"
+
+#define TAPE_RETRIES		2
+
+#define TAPE_DEF_BLOCK_SIZE	512
+
+/* The fixed bit in READ/WRITE/VERIFY */
+#define SILI_BIT		2
+
+struct tape_params {
+	int block_size;
+};
+
+static int tape_attach(struct scst_device *);
+static void tape_detach(struct scst_device *);
+static int tape_parse(struct scst_cmd *);
+static int tape_done(struct scst_cmd *);
+static int tape_perf_exec(struct scst_cmd *);
+
+static struct scst_dev_type tape_devtype = {
+	.name =			TAPE_NAME,
+	.type =			TYPE_TAPE,
+	.threads_num =		1,
+	.parse_atomic =		1,
+	.dev_done_atomic =	1,
+	.attach =		tape_attach,
+	.detach =		tape_detach,
+	.parse =		tape_parse,
+	.dev_done =		tape_done,
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+	.default_trace_flags =	SCST_DEFAULT_DEV_LOG_FLAGS,
+	.trace_flags =		&trace_flag,
+#endif
+};
+
+static struct scst_dev_type tape_devtype_perf = {
+	.name =			TAPE_PERF_NAME,
+	.type =			TYPE_TAPE,
+	.parse_atomic =		1,
+	.dev_done_atomic =	1,
+	.attach =		tape_attach,
+	.detach =		tape_detach,
+	.parse =		tape_parse,
+	.dev_done =		tape_done,
+	.exec =			tape_perf_exec,
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+	.default_trace_flags =	SCST_DEFAULT_DEV_LOG_FLAGS,
+	.trace_flags =		&trace_flag,
+#endif
+};
+
+static int __init init_scst_tape_driver(void)
+{
+	int res = 0;
+
+	tape_devtype.module = THIS_MODULE;
+
+	res = scst_register_dev_driver(&tape_devtype);
+	if (res < 0)
+		goto out;
+
+	tape_devtype_perf.module = THIS_MODULE;
+
+	res = scst_register_dev_driver(&tape_devtype_perf);
+	if (res < 0)
+		goto out_unreg;
+
+out:
+	return res;
+
+out_unreg:
+	scst_unregister_dev_driver(&tape_devtype);
+	goto out;
+}
+
+static void __exit exit_scst_tape_driver(void)
+{
+
+	scst_unregister_dev_driver(&tape_devtype_perf);
+	scst_unregister_dev_driver(&tape_devtype);
+	return;
+}
+
+module_init(init_scst_tape_driver);
+module_exit(exit_scst_tape_driver);
+
+static int tape_attach(struct scst_device *dev)
+{
+	int res, rc;
+	int retries;
+	struct scsi_mode_data data;
+	const int buffer_size = 512;
+	uint8_t *buffer = NULL;
+	struct tape_params *params;
+
+	if (dev->scsi_dev == NULL ||
+	    dev->scsi_dev->type != dev->type) {
+		PRINT_ERROR("%s", "SCSI device not define or illegal type");
+		res = -ENODEV;
+		goto out;
+	}
+
+	params = kzalloc(sizeof(*params), GFP_KERNEL);
+	if (params == NULL) {
+		TRACE(TRACE_OUT_OF_MEM, "%s",
+		      "Unable to allocate struct tape_params");
+		res = -ENOMEM;
+		goto out;
+	}
+
+	params->block_size = TAPE_DEF_BLOCK_SIZE;
+
+	buffer = kmalloc(buffer_size, GFP_KERNEL);
+	if (!buffer) {
+		TRACE(TRACE_OUT_OF_MEM, "%s", "Memory allocation failure");
+		res = -ENOMEM;
+		goto out_free_req;
+	}
+
+	retries = SCST_DEV_UA_RETRIES;
+	do {
+		TRACE_DBG("%s", "Doing TEST_UNIT_READY");
+		rc = scsi_test_unit_ready(dev->scsi_dev,
+			SCST_GENERIC_TAPE_SMALL_TIMEOUT, TAPE_RETRIES
+					  , NULL);
+		TRACE_DBG("TEST_UNIT_READY done: %x", rc);
+	} while ((--retries > 0) && rc);
+
+	if (rc) {
+		PRINT_WARNING("Unit not ready: %x", rc);
+		/* Let's try not to be too smart and continue processing */
+		goto obtain;
+	}
+
+	TRACE_DBG("%s", "Doing MODE_SENSE");
+	rc = scsi_mode_sense(dev->scsi_dev,
+			      ((dev->scsi_dev->scsi_level <= SCSI_2) ?
+			       ((dev->scsi_dev->lun << 5) & 0xe0) : 0),
+			      0 /* Mode Page 0 */,
+			      buffer, buffer_size,
+			      SCST_GENERIC_TAPE_SMALL_TIMEOUT, TAPE_RETRIES,
+			      &data, NULL);
+	TRACE_DBG("MODE_SENSE done: %x", rc);
+
+	if (rc == 0) {
+		int medium_type, mode, speed, density;
+		if (buffer[3] == 8) {
+			params->block_size = ((buffer[9] << 16) |
+					    (buffer[10] << 8) |
+					    (buffer[11] << 0));
+		} else
+			params->block_size = TAPE_DEF_BLOCK_SIZE;
+		medium_type = buffer[1];
+		mode = (buffer[2] & 0x70) >> 4;
+		speed = buffer[2] & 0x0f;
+		density = buffer[4];
+		TRACE_DBG("Tape: lun %d. bs %d. type 0x%02x mode 0x%02x "
+		      "speed 0x%02x dens 0x%02x", dev->scsi_dev->lun,
+		      params->block_size, medium_type, mode, speed, density);
+	} else {
+		PRINT_ERROR("MODE_SENSE failed: %x", rc);
+		res = -ENODEV;
+		goto out_free_buf;
+	}
+
+obtain:
+	res = scst_obtain_device_parameters(dev);
+	if (res != 0) {
+		PRINT_ERROR("Failed to obtain control parameters for device "
+			"%s", dev->virt_name);
+		goto out_free_buf;
+	}
+
+out_free_buf:
+	kfree(buffer);
+
+out_free_req:
+	if (res == 0)
+		dev->dh_priv = params;
+	else
+		kfree(params);
+
+out:
+	return res;
+}
+
+static void tape_detach(struct scst_device *dev)
+{
+	struct tape_params *params =
+		(struct tape_params *)dev->dh_priv;
+
+	kfree(params);
+	dev->dh_priv = NULL;
+	return;
+}
+
+static int tape_get_block_size(struct scst_cmd *cmd)
+{
+	struct tape_params *params = (struct tape_params *)cmd->dev->dh_priv;
+	/*
+	 * No need for locks here, since *_detach() can not be called,
+	 * when there are existing commands.
+	 */
+	return params->block_size;
+}
+
+static int tape_parse(struct scst_cmd *cmd)
+{
+	int res = SCST_CMD_STATE_DEFAULT;
+
+	scst_tape_generic_parse(cmd, tape_get_block_size);
+
+	cmd->retries = SCST_PASSTHROUGH_RETRIES;
+
+	return res;
+}
+
+static void tape_set_block_size(struct scst_cmd *cmd, int block_size)
+{
+	struct tape_params *params = (struct tape_params *)cmd->dev->dh_priv;
+	/*
+	 * No need for locks here, since *_detach() can not be called, when
+	 * there are existing commands.
+	 */
+	params->block_size = block_size;
+	return;
+}
+
+static int tape_done(struct scst_cmd *cmd)
+{
+	int opcode = cmd->cdb[0];
+	int status = cmd->status;
+	int res = SCST_CMD_STATE_DEFAULT;
+
+	if ((status == SAM_STAT_GOOD) || (status == SAM_STAT_CONDITION_MET))
+		res = scst_tape_generic_dev_done(cmd, tape_set_block_size);
+	else if ((status == SAM_STAT_CHECK_CONDITION) &&
+		   SCST_SENSE_VALID(cmd->sense)) {
+		struct tape_params *params;
+
+		TRACE_DBG("Extended sense %x", cmd->sense[0] & 0x7F);
+
+		if ((cmd->sense[0] & 0x7F) != 0x70) {
+			PRINT_ERROR("Sense format 0x%x is not supported",
+				cmd->sense[0] & 0x7F);
+			scst_set_cmd_error(cmd,
+				SCST_LOAD_SENSE(scst_sense_hardw_error));
+			goto out;
+		}
+
+		if (opcode == READ_6 && !(cmd->cdb[1] & SILI_BIT) &&
+		    (cmd->sense[2] & 0xe0)) {
+			/* EOF, EOM, or ILI */
+			int TransferLength, Residue = 0;
+			if ((cmd->sense[2] & 0x0f) == BLANK_CHECK)
+				/* No need for EOM in this case */
+				cmd->sense[2] &= 0xcf;
+			TransferLength = ((cmd->cdb[2] << 16) |
+					  (cmd->cdb[3] << 8) | cmd->cdb[4]);
+			/* Compute the residual count */
+			if ((cmd->sense[0] & 0x80) != 0) {
+				Residue = ((cmd->sense[3] << 24) |
+					   (cmd->sense[4] << 16) |
+					   (cmd->sense[5] << 8) |
+					   cmd->sense[6]);
+			}
+			TRACE_DBG("Checking the sense key "
+				"sn[2]=%x cmd->cdb[0,1]=%x,%x TransLen/Resid"
+				" %d/%d", (int)cmd->sense[2], cmd->cdb[0],
+				cmd->cdb[1], TransferLength, Residue);
+			if (TransferLength > Residue) {
+				int resp_data_len = TransferLength - Residue;
+				if (cmd->cdb[1] & SCST_TRANSFER_LEN_TYPE_FIXED) {
+					/*
+					 * No need for locks here, since
+					 * *_detach() can not be called, when
+					 * there are existing commands.
+					 */
+					params = (struct tape_params *)
+						 cmd->dev->dh_priv;
+					resp_data_len *= params->block_size;
+				}
+				scst_set_resp_data_len(cmd, resp_data_len);
+			}
+		}
+	}
+
+out:
+	TRACE_DBG("cmd->is_send_status=%x, cmd->resp_data_len=%d, "
+	      "res=%d", cmd->is_send_status, cmd->resp_data_len, res);
+	return res;
+}
+
+static int tape_perf_exec(struct scst_cmd *cmd)
+{
+	int res = SCST_EXEC_NOT_COMPLETED, rc;
+	int opcode = cmd->cdb[0];
+
+	rc = scst_check_local_events(cmd);
+	if (unlikely(rc != 0))
+		goto out_done;
+
+	cmd->status = 0;
+	cmd->msg_status = 0;
+	cmd->host_status = DID_OK;
+	cmd->driver_status = 0;
+
+	switch (opcode) {
+	case WRITE_6:
+	case READ_6:
+		cmd->completed = 1;
+		goto out_done;
+	}
+
+out:
+	return res;
+
+out_done:
+	res = SCST_EXEC_COMPLETED;
+	cmd->scst_cmd_done(cmd, SCST_CMD_STATE_DEFAULT, SCST_CONTEXT_SAME);
+	goto out;
+}
+
+MODULE_AUTHOR("Vladislav Bolkhovitin & Leonid Stoljar");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("SCSI tape (type 1) dev handler for SCST");
+MODULE_VERSION(SCST_VERSION_STRING);
