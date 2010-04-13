From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH][RFC 2/3/2/5] SCST pass-through dev handlers
Date: Tue, 13 Apr 2010 17:08:00 +0400
Message-ID: <4BC46CB0.5010909@vlnb.net>
References: <4BC45A32.2010904@vlnb.net> <4BC46173.7000102@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:53960 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030Ab0DMNIW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2010 09:08:22 -0400
In-Reply-To: <4BC46173.7000102@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Linus Torvalds <torvalds@linux-foundation.org>, Bart Van Assche <bart.vanassche@gmail.com>

This patch contains SCST pass-through dev handlers.

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
 scst_cdrom.c       |  284 ++++++++++++++++++++++++++++++++++++
 scst_changer.c     |  207 ++++++++++++++++++++++++++
 scst_dev_handler.h |   27 +++
 scst_disk.c        |  361 ++++++++++++++++++++++++++++++++++++++++++++++
 scst_modisk.c      |  380 ++++++++++++++++++++++++++++++++++++++++++++++++
 scst_processor.c   |  207 ++++++++++++++++++++++++++
 scst_raid.c        |  208 ++++++++++++++++++++++++++
 scst_tape.c        |  413 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 2087 insertions(+)

diff -uprN orig/linux-2.6.33/drivers/scst/dev_handlers/scst_cdrom.c linux-2.6.33/drivers/scst/dev_handlers/scst_cdrom.c
--- orig/linux-2.6.33/drivers/scst/dev_handlers/scst_cdrom.c
+++ linux-2.6.33/drivers/scst/dev_handlers/scst_cdrom.c
@@ -0,0 +1,284 @@
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
+
+#define LOG_PREFIX	"dev_cdrom"
+
+#include "scst.h"
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
+	.name = 		CDROM_NAME,
+	.type =			TYPE_ROM,
+	.pass_through =		1,
+	.parse_atomic =		1,
+	.dev_done_atomic = 	1,
+	.attach = 		cdrom_attach,
+	.detach = 		cdrom_detach,
+	.parse = 		cdrom_parse,
+	.dev_done = 		cdrom_done,
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+	.default_trace_flags =	SCST_DEFAULT_DEV_LOG_FLAGS,
+	.trace_flags =		&trace_flag,
+#endif
+};
+
+/**************************************************************
+ *  Function:  cdrom_attach
+ *
+ *  Argument:
+ *
+ *  Returns :  1 if attached, error code otherwise
+ *
+ *  Description:
+ *************************************************************/
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
+/************************************************************
+ *  Function:  cdrom_detach
+ *
+ *  Argument:
+ *
+ *  Returns :  None
+ *
+ *  Description:  Called to detach this device type driver
+ ************************************************************/
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
+/********************************************************************
+ *  Function:  cdrom_parse
+ *
+ *  Argument:
+ *
+ *  Returns :  The state of the command
+ *
+ *  Description:  This does the parsing of the command
+ *
+ *  Note:  Not all states are allowed on return
+ ********************************************************************/
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
+/********************************************************************
+ *  Function:  cdrom_done
+ *
+ *  Argument:
+ *
+ *  Returns :
+ *
+ *  Description:  This is the completion routine for the command,
+ *                it is used to extract any necessary information
+ *                about a command.
+ ********************************************************************/
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
diff -uprN orig/linux-2.6.33/drivers/scst/dev_handlers/scst_changer.c linux-2.6.33/drivers/scst/dev_handlers/scst_changer.c
--- orig/linux-2.6.33/drivers/scst/dev_handlers/scst_changer.c
+++ linux-2.6.33/drivers/scst/dev_handlers/scst_changer.c
@@ -0,0 +1,207 @@
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
+
+#define LOG_PREFIX      "dev_changer"
+
+#include "scst.h"
+#include "scst_dev_handler.h"
+
+#define CHANGER_NAME	"dev_changer"
+
+#define CHANGER_RETRIES       2
+#define READ_CAP_LEN          8
+
+static int changer_attach(struct scst_device *);
+/* static void changer_detach(struct scst_device *); */
+static int changer_parse(struct scst_cmd *);
+/* static int changer_done(struct scst_cmd *); */
+
+static struct scst_dev_type changer_devtype = {
+	.name =	CHANGER_NAME,
+	.type =	TYPE_MEDIUM_CHANGER,
+	.pass_through = 1,
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
+/**************************************************************
+ *  Function:  changer_attach
+ *
+ *  Argument:
+ *
+ *  Returns :  1 if attached, error code otherwise
+ *
+ *  Description:
+ *************************************************************/
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
+/************************************************************
+ *  Function:  changer_detach
+ *
+ *  Argument:
+ *
+ *  Returns :  None
+ *
+ *  Description:  Called to detach this device type driver
+ ************************************************************/
+#if 0
+void changer_detach(struct scst_device *dev)
+{
+	return;
+}
+#endif
+
+/********************************************************************
+ *  Function:  changer_parse
+ *
+ *  Argument:
+ *
+ *  Returns :  The state of the command
+ *
+ *  Description:  This does the parsing of the command
+ *
+ *  Note:  Not all states are allowed on return
+ ********************************************************************/
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
+/********************************************************************
+ *  Function:  changer_done
+ *
+ *  Argument:
+ *
+ *  Returns :
+ *
+ *  Description:  This is the completion routine for the command,
+ *                it is used to extract any necessary information
+ *                about a command.
+ ********************************************************************/
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
diff -uprN orig/linux-2.6.33/drivers/scst/dev_handlers/scst_dev_handler.h linux-2.6.33/drivers/scst/dev_handlers/scst_dev_handler.h
--- orig/linux-2.6.33/drivers/scst/dev_handlers/scst_dev_handler.h
+++ linux-2.6.33/drivers/scst/dev_handlers/scst_dev_handler.h
@@ -0,0 +1,27 @@
+#ifndef __SCST_DEV_HANDLER_H
+#define __SCST_DEV_HANDLER_H
+
+#include <linux/module.h>
+#include <scsi/scsi_eh.h>
+#include "scst_debug.h"
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
diff -uprN orig/linux-2.6.33/drivers/scst/dev_handlers/scst_disk.c linux-2.6.33/drivers/scst/dev_handlers/scst_disk.c
--- orig/linux-2.6.33/drivers/scst/dev_handlers/scst_disk.c
+++ linux-2.6.33/drivers/scst/dev_handlers/scst_disk.c
@@ -0,0 +1,361 @@
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
+
+#define LOG_PREFIX           "dev_disk"
+
+#include "scst.h"
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
+static int disk_done(struct scst_cmd *cmd);
+static int disk_exec(struct scst_cmd *cmd);
+
+static struct scst_dev_type disk_devtype = {
+	.name =			DISK_NAME,
+	.type =			TYPE_DISK,
+	.pass_through =		1,
+	.parse_atomic =		1,
+	.dev_done_atomic =	1,
+	.exec_atomic =		1,
+	.attach =		disk_attach,
+	.detach =		disk_detach,
+	.parse =		disk_parse,
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
+	.pass_through =		1,
+	.parse_atomic =		1,
+	.dev_done_atomic =	1,
+	.exec_atomic =		1,
+	.attach =		disk_attach,
+	.detach =		disk_detach,
+	.parse =		disk_parse,
+	.dev_done =		disk_done,
+	.exec =			disk_exec,
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
+/**************************************************************
+ *  Function:  disk_attach
+ *
+ *  Argument:
+ *
+ *  Returns :  1 if attached, error code otherwise
+ *
+ *  Description:
+ *************************************************************/
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
+/************************************************************
+ *  Function:  disk_detach
+ *
+ *  Argument:
+ *
+ *  Returns :  None
+ *
+ *  Description:  Called to detach this device type driver
+ ************************************************************/
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
+/********************************************************************
+ *  Function:  disk_parse
+ *
+ *  Argument:
+ *
+ *  Returns :  The state of the command
+ *
+ *  Description:  This does the parsing of the command
+ *
+ *  Note:  Not all states are allowed on return
+ ********************************************************************/
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
+/********************************************************************
+ *  Function:  disk_done
+ *
+ *  Argument:
+ *
+ *  Returns :
+ *
+ *  Description:  This is the completion routine for the command,
+ *                it is used to extract any necessary information
+ *                about a command.
+ ********************************************************************/
+static int disk_done(struct scst_cmd *cmd)
+{
+	int res = SCST_CMD_STATE_DEFAULT;
+
+	res = scst_block_generic_dev_done(cmd, disk_set_block_shift);
+	return res;
+}
+
+/********************************************************************
+ *  Function:  disk_exec
+ *
+ *  Argument:
+ *
+ *  Returns :
+ *
+ *  Description:  Make SCST do nothing for data READs and WRITES.
+ *                Intended for raw line performance testing
+ ********************************************************************/
+static int disk_exec(struct scst_cmd *cmd)
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
+MODULE_DESCRIPTION("SCSI disk (type 0) dev handler for SCST");
+MODULE_VERSION(SCST_VERSION_STRING);
diff -uprN orig/linux-2.6.33/drivers/scst/dev_handlers/scst_modisk.c linux-2.6.33/drivers/scst/dev_handlers/scst_modisk.c
--- orig/linux-2.6.33/drivers/scst/dev_handlers/scst_modisk.c
+++ linux-2.6.33/drivers/scst/dev_handlers/scst_modisk.c
@@ -0,0 +1,380 @@
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
+
+#define LOG_PREFIX             "dev_modisk"
+
+#include "scst.h"
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
+static int modisk_exec(struct scst_cmd *);
+
+static struct scst_dev_type modisk_devtype = {
+	.name =			MODISK_NAME,
+	.type =			TYPE_MOD,
+	.pass_through =		1,
+	.parse_atomic =		1,
+	.dev_done_atomic =	1,
+	.exec_atomic =		1,
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
+	.pass_through =		1,
+	.parse_atomic =		1,
+	.dev_done_atomic =	1,
+	.exec_atomic =		1,
+	.attach =		modisk_attach,
+	.detach =		modisk_detach,
+	.parse =		modisk_parse,
+	.dev_done =		modisk_done,
+	.exec =			modisk_exec,
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
+/**************************************************************
+ *  Function:  modisk_attach
+ *
+ *  Argument:
+ *
+ *  Returns :  1 if attached, error code otherwise
+ *
+ *  Description:
+ *************************************************************/
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
+/************************************************************
+ *  Function:  modisk_detach
+ *
+ *  Argument:
+ *
+ *  Returns :  None
+ *
+ *  Description:  Called to detach this device type driver
+ ************************************************************/
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
+/********************************************************************
+ *  Function:  modisk_parse
+ *
+ *  Argument:
+ *
+ *  Returns :  The state of the command
+ *
+ *  Description:  This does the parsing of the command
+ *
+ *  Note:  Not all states are allowed on return
+ ********************************************************************/
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
+/********************************************************************
+ *  Function:  modisk_done
+ *
+ *  Argument:
+ *
+ *  Returns :
+ *
+ *  Description:  This is the completion routine for the command,
+ *                it is used to extract any necessary information
+ *                about a command.
+ ********************************************************************/
+static int modisk_done(struct scst_cmd *cmd)
+{
+	int res;
+
+	res = scst_block_generic_dev_done(cmd, modisk_set_block_shift);
+	return res;
+}
+
+/********************************************************************
+ *  Function:  modisk_exec
+ *
+ *  Argument:
+ *
+ *  Returns :
+ *
+ *  Description:  Make SCST do nothing for data READs and WRITES.
+ *                Intended for raw line performance testing
+ ********************************************************************/
+static int modisk_exec(struct scst_cmd *cmd)
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
diff -uprN orig/linux-2.6.33/drivers/scst/dev_handlers/scst_processor.c linux-2.6.33/drivers/scst/dev_handlers/scst_processor.c
--- orig/linux-2.6.33/drivers/scst/dev_handlers/scst_processor.c
+++ linux-2.6.33/drivers/scst/dev_handlers/scst_processor.c
@@ -0,0 +1,207 @@
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
+
+#define LOG_PREFIX "dev_processor"
+
+#include "scst.h"
+#include "scst_dev_handler.h"
+
+#define PROCESSOR_NAME	"dev_processor"
+
+#define PROCESSOR_RETRIES	2
+#define READ_CAP_LEN		8
+
+static int processor_attach(struct scst_device *);
+/*static void processor_detach(struct scst_device *);*/
+static int processor_parse(struct scst_cmd *);
+/*static int processor_done(struct scst_cmd *);*/
+
+static struct scst_dev_type processor_devtype = {
+	.name =			PROCESSOR_NAME,
+	.type =			TYPE_PROCESSOR,
+	.pass_through =		1,
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
+/**************************************************************
+ *  Function:  processor_attach
+ *
+ *  Argument:
+ *
+ *  Returns :  1 if attached, error code otherwise
+ *
+ *  Description:
+ *************************************************************/
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
+/************************************************************
+ *  Function:  processor_detach
+ *
+ *  Argument:
+ *
+ *  Returns :  None
+ *
+ *  Description:  Called to detach this device type driver
+ ************************************************************/
+#if 0
+void processor_detach(struct scst_device *dev)
+{
+	return;
+}
+#endif
+
+/********************************************************************
+ *  Function:  processor_parse
+ *
+ *  Argument:
+ *
+ *  Returns :  The state of the command
+ *
+ *  Description:  This does the parsing of the command
+ *
+ *  Note:  Not all states are allowed on return
+ ********************************************************************/
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
+/********************************************************************
+ *  Function:  processor_done
+ *
+ *  Argument:
+ *
+ *  Returns :
+ *
+ *  Description:  This is the completion routine for the command,
+ *                it is used to extract any necessary information
+ *                about a command.
+ ********************************************************************/
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
diff -uprN orig/linux-2.6.33/drivers/scst/dev_handlers/scst_raid.c linux-2.6.33/drivers/scst/dev_handlers/scst_raid.c
--- orig/linux-2.6.33/drivers/scst/dev_handlers/scst_raid.c
+++ linux-2.6.33/drivers/scst/dev_handlers/scst_raid.c
@@ -0,0 +1,208 @@
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
+
+#include "scst.h"
+#include "scst_dev_handler.h"
+
+#define RAID_NAME	"dev_raid"
+
+#define RAID_RETRIES		2
+#define READ_CAP_LEN		8
+
+static int raid_attach(struct scst_device *);
+/* static void raid_detach(struct scst_device *); */
+static int raid_parse(struct scst_cmd *);
+/* static int raid_done(struct scst_cmd *); */
+
+static struct scst_dev_type raid_devtype = {
+	.name =			RAID_NAME,
+	.type =			TYPE_RAID,
+	.pass_through =		1,
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
+/**************************************************************
+ *  Function:  raid_attach
+ *
+ *  Argument:
+ *
+ *  Returns :  1 if attached, error code otherwise
+ *
+ *  Description:
+ *************************************************************/
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
+/************************************************************
+ *  Function:  raid_detach
+ *
+ *  Argument:
+ *
+ *  Returns :  None
+ *
+ *  Description:  Called to detach this device type driver
+ ************************************************************/
+#if 0
+void raid_detach(struct scst_device *dev)
+{
+	return;
+}
+#endif
+
+/********************************************************************
+ *  Function:  raid_parse
+ *
+ *  Argument:
+ *
+ *  Returns :  The state of the command
+ *
+ *  Description:  This does the parsing of the command
+ *
+ *  Note:  Not all states are allowed on return
+ ********************************************************************/
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
+/********************************************************************
+ *  Function:  raid_done
+ *
+ *  Argument:
+ *
+ *  Returns :
+ *
+ *  Description:  This is the completion routine for the command,
+ *                it is used to extract any necessary information
+ *                about a command.
+ ********************************************************************/
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
diff -uprN orig/linux-2.6.33/drivers/scst/dev_handlers/scst_tape.c linux-2.6.33/drivers/scst/dev_handlers/scst_tape.c
--- orig/linux-2.6.33/drivers/scst/dev_handlers/scst_tape.c
+++ linux-2.6.33/drivers/scst/dev_handlers/scst_tape.c
@@ -0,0 +1,413 @@
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
+
+#define LOG_PREFIX           "dev_tape"
+
+#include "scst.h"
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
+static int tape_exec(struct scst_cmd *);
+
+static struct scst_dev_type tape_devtype = {
+	.name =			TAPE_NAME,
+	.type =			TYPE_TAPE,
+	.pass_through =		1,
+	.parse_atomic =		1,
+	.dev_done_atomic =	1,
+	.exec_atomic =		1,
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
+	.pass_through =		1,
+	.parse_atomic =		1,
+	.dev_done_atomic =	1,
+	.exec_atomic =		1,
+	.attach =		tape_attach,
+	.detach =		tape_detach,
+	.parse =		tape_parse,
+	.dev_done =		tape_done,
+	.exec =			tape_exec,
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
+/**************************************************************
+ *  Function:  tape_attach
+ *
+ *  Argument:
+ *
+ *  Returns :  1 if attached, error code otherwise
+ *
+ *  Description:
+ *************************************************************/
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
+/************************************************************
+ *  Function:  tape_detach
+ *
+ *  Argument:
+ *
+ *  Returns :  None
+ *
+ *  Description:  Called to detach this device type driver
+ ************************************************************/
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
+/********************************************************************
+ *  Function:  tape_parse
+ *
+ *  Argument:
+ *
+ *  Returns :  The state of the command
+ *
+ *  Description:  This does the parsing of the command
+ *
+ *  Note:  Not all states are allowed on return
+ ********************************************************************/
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
+/********************************************************************
+ *  Function:  tape_done
+ *
+ *  Argument:
+ *
+ *  Returns :
+ *
+ *  Description:  This is the completion routine for the command,
+ *                it is used to extract any necessary information
+ *                about a command.
+ ********************************************************************/
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
+/********************************************************************
+ *  Function:  tape_exec
+ *
+ *  Argument:
+ *
+ *  Returns :
+ *
+ *  Description:  Make SCST do nothing for data READs and WRITES.
+ *                Intended for raw line performance testing
+ ********************************************************************/
+static int tape_exec(struct scst_cmd *cmd)
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
