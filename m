From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 5/8] zfcp: Message cleanup
Date: Tue, 10 Jun 2008 18:20:58 +0200
Message-ID: <20080610162516.732038000@de.ibm.com>
References: <20080610162053.144590000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:30383 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbYFJQZY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jun 2008 12:25:24 -0400
Content-Disposition: inline; filename=zfcp-messages.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Christof Schmitt <christof.schmitt@de.ibm.com>, Swen Schillig <swen@vnet.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Cleanup the messages used in the zfcp driver: Remove unnecessary debug
and trace message and convert the remaining messages to standard
kernel macros. Remove the zfcp message macros and while updating the
whole flie also update the copyright headers.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
---
 drivers/s390/scsi/Makefile             |    2 
 drivers/s390/scsi/zfcp_aux.c           |   75 -
 drivers/s390/scsi/zfcp_dbf.c           |   41 
 drivers/s390/scsi/zfcp_def.h           |  124 --
 drivers/s390/scsi/zfcp_erp.c           |  293 +-----
 drivers/s390/scsi/zfcp_ext.h           |   20 
 drivers/s390/scsi/zfcp_fsf.c           | 1557 +++++----------------------------
 drivers/s390/scsi/zfcp_fsf.h           |   20 
 drivers/s390/scsi/zfcp_scsi.c          |   64 -
 drivers/s390/scsi/zfcp_sysfs_adapter.c |   23 
 drivers/s390/scsi/zfcp_sysfs_driver.c  |  106 --
 drivers/s390/scsi/zfcp_sysfs_port.c    |   23 
 drivers/s390/scsi/zfcp_sysfs_unit.c    |   23 
 13 files changed, 396 insertions(+), 1975 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2008-06-10 17:37:48.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2008-06-10 17:41:27.000000000 +0200
@@ -1,22 +1,9 @@
 /*
- * This file is part of the zfcp device driver for
- * FCP adapters for IBM System z9 and zSeries.
+ * zfcp device driver
  *
- * (C) Copyright IBM Corp. 2002, 2006
+ * Module interface and handling of zfcp data structures.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ * Copyright IBM Corporation 2002, 2008
  */
 
 /*
@@ -31,13 +18,16 @@
  *            Maxim Shchetynin
  *            Volker Sameske
  *            Ralph Wuerthner
+ *            Michael Loehr
+ *            Swen Schillig
+ *            Christof Schmitt
+ *            Martin Petermann
+ *            Sven Schuetz
  */
 
 #include <linux/miscdevice.h>
 #include "zfcp_ext.h"
 
-/* accumulated log level (module parameter) */
-static u32 loglevel = ZFCP_LOG_LEVEL_DEFAULTS;
 static char *device;
 /*********************** FUNCTION PROTOTYPES *********************************/
 
@@ -57,12 +47,6 @@ MODULE_LICENSE("GPL");
 module_param(device, charp, 0400);
 MODULE_PARM_DESC(device, "specify initial device");
 
-module_param(loglevel, uint, 0400);
-MODULE_PARM_DESC(loglevel,
-		 "log levels, 8 nibbles: "
-		 "FC ERP QDIO CIO Config FSF SCSI Other, "
-		 "levels: 0=none 1=normal 2=devel 3=trace");
-
 /****************************************************************/
 /************** Functions without logging ***********************/
 /****************************************************************/
@@ -87,8 +71,6 @@ _zfcp_hex_dump(char *addr, int count)
 /****** Functions to handle the request ID hash table    ********/
 /****************************************************************/
 
-#define ZFCP_LOG_AREA			ZFCP_LOG_AREA_FSF
-
 static int zfcp_reqlist_alloc(struct zfcp_adapter *adapter)
 {
 	int idx;
@@ -118,14 +100,10 @@ int zfcp_reqlist_isempty(struct zfcp_ada
 	return 1;
 }
 
-#undef ZFCP_LOG_AREA
-
 /****************************************************************/
 /************** Uncategorised Functions *************************/
 /****************************************************************/
 
-#define ZFCP_LOG_AREA			ZFCP_LOG_AREA_OTHER
-
 /**
  * zfcp_device_setup - setup function
  * @str: pointer to parameter string
@@ -143,8 +121,11 @@ zfcp_device_setup(char *devstr)
 
 	len = strlen(devstr) + 1;
 	str = kmalloc(len, GFP_KERNEL);
-	if (!str)
-		goto err_out;
+	if (!str) {
+		pr_err("zfcp: Could not allocate memory for "
+		       "device parameter string, device not attached.\n");
+		return 0;
+	}
 	memcpy(str, devstr, len);
 
 	tmp = strchr(str, ',');
@@ -167,7 +148,8 @@ zfcp_device_setup(char *devstr)
 	return 1;
 
  err_out:
-	ZFCP_LOG_NORMAL("Parse error for device parameter string %s\n", str);
+	pr_err("zfcp: Parse error for device parameter string %s, "
+	       "device not attached.\n", str);
 	kfree(str);
 	return 0;
 }
@@ -248,8 +230,6 @@ zfcp_module_init(void)
 	if (!zfcp_data.gid_pn_cache)
 		goto out_gid_cache;
 
-	atomic_set(&zfcp_data.loglevel, loglevel);
-
 	/* initialize adapter list */
 	INIT_LIST_HEAD(&zfcp_data.adapter_list_head);
 
@@ -263,8 +243,7 @@ zfcp_module_init(void)
 
 	retval = misc_register(&zfcp_cfdc_misc);
 	if (retval != 0) {
-		ZFCP_LOG_INFO("registration of misc device "
-			      "zfcp_cfdc failed\n");
+		pr_err("zfcp: registration of misc device zfcp_cfdc failed\n");
 		goto out_misc;
 	}
 
@@ -277,7 +256,7 @@ zfcp_module_init(void)
 	/* setup dynamic I/O */
 	retval = zfcp_ccw_register();
 	if (retval) {
-		ZFCP_LOG_NORMAL("registration with common I/O layer failed\n");
+		pr_err("zfcp: Registration with common I/O layer failed.\n");
 		goto out_ccw_register;
 	}
 
@@ -300,14 +279,10 @@ zfcp_module_init(void)
 	return retval;
 }
 
-#undef ZFCP_LOG_AREA
-
 /****************************************************************/
 /****** Functions for configuration/set-up of structures ********/
 /****************************************************************/
 
-#define ZFCP_LOG_AREA			ZFCP_LOG_AREA_CONFIG
-
 /**
  * zfcp_get_unit_by_lun - find unit in unit list of port by FCP LUN
  * @port: pointer to port to search for unit
@@ -598,6 +573,8 @@ static void _zfcp_status_read_scheduler(
  * All adapter internal structures are set up.
  * Proc-fs entries are also created.
  *
+ * FIXME: Use -ENOMEM as return code for allocation failures
+ *
  * returns:	0             if a new adapter was successfully enqueued
  *              ZFCP_KNOWN    if an adapter with this devno was already present
  *		-ENOMEM       if alloc failed
@@ -615,11 +592,8 @@ zfcp_adapter_enqueue(struct ccw_device *
 
 	/* try to allocate new adapter data structure (zeroed) */
 	adapter = kzalloc(sizeof (struct zfcp_adapter), GFP_KERNEL);
-	if (!adapter) {
-		ZFCP_LOG_INFO("error: allocation of base adapter "
-			      "structure failed\n");
+	if (!adapter)
 		goto out;
-	}
 
 	ccw_device->handler = NULL;
 
@@ -760,7 +734,6 @@ zfcp_adapter_dequeue(struct zfcp_adapter
 	zfcp_reqlist_free(adapter);
 	kfree(adapter->fc_stats);
 	kfree(adapter->stats_reset_data);
-	ZFCP_LOG_TRACE("freeing adapter structure\n");
 	kfree(adapter);
  out:
 	return;
@@ -908,12 +881,8 @@ zfcp_nameserver_enqueue(struct zfcp_adap
 
 	port = zfcp_port_enqueue(adapter, 0, ZFCP_STATUS_PORT_WKA,
 				 ZFCP_DID_DIRECTORY_SERVICE);
-	if (!port) {
-		ZFCP_LOG_INFO("error: enqueue of nameserver port for "
-			      "adapter %s failed\n",
-			      zfcp_get_busid_by_adapter(adapter));
+	if (!port)
 		return -ENXIO;
-	}
 	zfcp_port_put(port);
 
 	return 0;
@@ -946,5 +915,3 @@ int zfcp_sg_setup_table(struct scatterli
 	}
 	return 0;
 }
-
-#undef ZFCP_LOG_AREA
--- a/drivers/s390/scsi/zfcp_dbf.c	2008-06-10 17:37:48.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_dbf.c	2008-06-10 17:41:27.000000000 +0200
@@ -1,22 +1,9 @@
 /*
- * This file is part of the zfcp device driver for
- * FCP adapters for IBM System z9 and zSeries.
+ * zfcp device driver
  *
- * (C) Copyright IBM Corp. 2002, 2006
+ * Debug traces for zfcp.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ * Copyright IBM Corporation 2002, 2008
  */
 
 #include <linux/ctype.h>
@@ -29,8 +16,6 @@ module_param(dbfsize, uint, 0400);
 MODULE_PARM_DESC(dbfsize,
 		 "number of pages for each debug feature area (default 4)");
 
-#define ZFCP_LOG_AREA			ZFCP_LOG_AREA_OTHER
-
 static void zfcp_dbf_hexdump(debug_info_t *dbf, void *to, int to_len,
 			     int level, char *from, int from_len)
 {
@@ -515,13 +500,13 @@ static const char *zfcp_rec_dbf_ids[] = 
 	[52]	= "port boxed close unit",
 	[53]	= "port boxed fcp",
 	[54]	= "unit boxed fcp",
-	[55]	= "port access denied ct",
-	[56]	= "port access denied els",
-	[57]	= "port access denied open port",
-	[58]	= "port access denied close physical",
-	[59]	= "unit access denied open unit",
+	[55]	= "port access denied",
+	[56]	= "",
+	[57]	= "",
+	[58]	= "",
+	[59]	= "unit access denied",
 	[60]	= "shared unit access denied open unit",
-	[61]	= "unit access denied fcp",
+	[61]	= "",
 	[62]	= "request timeout",
 	[63]	= "adisc link test reject or timeout",
 	[64]	= "adisc link test d_id changed",
@@ -586,8 +571,8 @@ static const char *zfcp_rec_dbf_ids[] = 
 	[120]	= "unknown fsf command",
 	[121]	= "no recommendation for status qualifier",
 	[122]	= "status read physical port closed in error",
-	[123]	= "fc service class not supported ct",
-	[124]	= "fc service class not supported els",
+	[123]	= "fc service class not supported",
+	[124]	= "",
 	[125]	= "need newer zfcp",
 	[126]	= "need newer microcode",
 	[127]	= "arbitrated loop not supported",
@@ -595,7 +580,7 @@ static const char *zfcp_rec_dbf_ids[] = 
 	[129]	= "qtcb size mismatch",
 	[130]	= "unknown fsf status ecd",
 	[131]	= "fcp request too big",
-	[132]	= "fc service class not supported fcp",
+	[132]	= "",
 	[133]	= "data direction not valid fcp",
 	[134]	= "command length not valid fcp",
 	[135]	= "status read act update",
@@ -1291,5 +1276,3 @@ void zfcp_adapter_debug_unregister(struc
 	adapter->hba_dbf = NULL;
 	adapter->rec_dbf = NULL;
 }
-
-#undef ZFCP_LOG_AREA
--- a/drivers/s390/scsi/zfcp_def.h	2008-06-10 17:39:27.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_def.h	2008-06-10 17:41:27.000000000 +0200
@@ -1,22 +1,9 @@
 /*
- * This file is part of the zfcp device driver for
- * FCP adapters for IBM System z9 and zSeries.
+ * zfcp device driver
  *
- * (C) Copyright IBM Corp. 2002, 2006
+ * Global definitions for the zfcp device driver.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ * Copyright IBM Corporation 2002, 2008
  */
 
 #ifndef ZFCP_DEF_H
@@ -52,9 +39,6 @@
 
 /********************* GENERAL DEFINES *********************************/
 
-/* zfcp version number, it consists of major, minor, and patch-level number */
-#define ZFCP_VERSION		"4.8.0"
-
 /**
  * zfcp_sg_to_address - determine kernel address from struct scatterlist
  * @list: struct scatterlist
@@ -308,107 +292,6 @@ struct zfcp_rc_entry {
  */
 #define ZFCP_CT_TIMEOUT			(3 * R_A_TOV)
 
-/******************** LOGGING MACROS AND DEFINES *****************************/
-
-/*
- * Logging may be applied on certain kinds of driver operations
- * independently. Additionally, different log-levels are supported for
- * each of these areas.
- */
-
-#define ZFCP_NAME               "zfcp"
-
-/* independent log areas */
-#define ZFCP_LOG_AREA_OTHER	0
-#define ZFCP_LOG_AREA_SCSI	1
-#define ZFCP_LOG_AREA_FSF	2
-#define ZFCP_LOG_AREA_CONFIG	3
-#define ZFCP_LOG_AREA_CIO	4
-#define ZFCP_LOG_AREA_QDIO	5
-#define ZFCP_LOG_AREA_ERP	6
-#define ZFCP_LOG_AREA_FC	7
-
-/* log level values*/
-#define ZFCP_LOG_LEVEL_NORMAL	0
-#define ZFCP_LOG_LEVEL_INFO	1
-#define ZFCP_LOG_LEVEL_DEBUG	2
-#define ZFCP_LOG_LEVEL_TRACE	3
-
-/*
- * this allows removal of logging code by the preprocessor
- * (the most detailed log level still to be compiled in is specified,
- * higher log levels are removed)
- */
-#define ZFCP_LOG_LEVEL_LIMIT	ZFCP_LOG_LEVEL_TRACE
-
-/* get "loglevel" nibble assignment */
-#define ZFCP_GET_LOG_VALUE(zfcp_lognibble) \
-	       ((atomic_read(&zfcp_data.loglevel) >> (zfcp_lognibble<<2)) & 0xF)
-
-/* set "loglevel" nibble */
-#define ZFCP_SET_LOG_NIBBLE(value, zfcp_lognibble) \
-	       (value << (zfcp_lognibble << 2))
-
-/* all log-level defaults are combined to generate initial log-level */
-#define ZFCP_LOG_LEVEL_DEFAULTS \
-	(ZFCP_SET_LOG_NIBBLE(ZFCP_LOG_LEVEL_NORMAL, ZFCP_LOG_AREA_OTHER) | \
-	 ZFCP_SET_LOG_NIBBLE(ZFCP_LOG_LEVEL_NORMAL, ZFCP_LOG_AREA_SCSI) | \
-	 ZFCP_SET_LOG_NIBBLE(ZFCP_LOG_LEVEL_NORMAL, ZFCP_LOG_AREA_FSF) | \
-	 ZFCP_SET_LOG_NIBBLE(ZFCP_LOG_LEVEL_NORMAL, ZFCP_LOG_AREA_CONFIG) | \
-	 ZFCP_SET_LOG_NIBBLE(ZFCP_LOG_LEVEL_NORMAL, ZFCP_LOG_AREA_CIO) | \
-	 ZFCP_SET_LOG_NIBBLE(ZFCP_LOG_LEVEL_NORMAL, ZFCP_LOG_AREA_QDIO) | \
-	 ZFCP_SET_LOG_NIBBLE(ZFCP_LOG_LEVEL_NORMAL, ZFCP_LOG_AREA_ERP) | \
-	 ZFCP_SET_LOG_NIBBLE(ZFCP_LOG_LEVEL_NORMAL, ZFCP_LOG_AREA_FC))
-
-/* check whether we have the right level for logging */
-#define ZFCP_LOG_CHECK(level) \
-	((ZFCP_GET_LOG_VALUE(ZFCP_LOG_AREA)) >= level)
-
-/* logging routine for zfcp */
-#define _ZFCP_LOG(fmt, args...) \
-	printk(KERN_ERR ZFCP_NAME": %s(%d): " fmt, __func__, \
-	       __LINE__ , ##args)
-
-#define ZFCP_LOG(level, fmt, args...) \
-do { \
-	if (ZFCP_LOG_CHECK(level)) \
-		_ZFCP_LOG(fmt, ##args); \
-} while (0)
-
-#if ZFCP_LOG_LEVEL_LIMIT < ZFCP_LOG_LEVEL_NORMAL
-# define ZFCP_LOG_NORMAL(fmt, args...)	do { } while (0)
-#else
-# define ZFCP_LOG_NORMAL(fmt, args...) \
-do { \
-	if (ZFCP_LOG_CHECK(ZFCP_LOG_LEVEL_NORMAL)) \
-		printk(KERN_ERR ZFCP_NAME": " fmt, ##args); \
-} while (0)
-#endif
-
-#if ZFCP_LOG_LEVEL_LIMIT < ZFCP_LOG_LEVEL_INFO
-# define ZFCP_LOG_INFO(fmt, args...)	do { } while (0)
-#else
-# define ZFCP_LOG_INFO(fmt, args...) \
-do { \
-	if (ZFCP_LOG_CHECK(ZFCP_LOG_LEVEL_INFO)) \
-		printk(KERN_ERR ZFCP_NAME": " fmt, ##args); \
-} while (0)
-#endif
-
-#if ZFCP_LOG_LEVEL_LIMIT < ZFCP_LOG_LEVEL_DEBUG
-# define ZFCP_LOG_DEBUG(fmt, args...)	do { } while (0)
-#else
-# define ZFCP_LOG_DEBUG(fmt, args...) \
-	ZFCP_LOG(ZFCP_LOG_LEVEL_DEBUG, fmt , ##args)
-#endif
-
-#if ZFCP_LOG_LEVEL_LIMIT < ZFCP_LOG_LEVEL_TRACE
-# define ZFCP_LOG_TRACE(fmt, args...)	do { } while (0)
-#else
-# define ZFCP_LOG_TRACE(fmt, args...) \
-	ZFCP_LOG(ZFCP_LOG_LEVEL_TRACE, fmt , ##args)
-#endif
-
 /*************** ADAPTER/PORT/UNIT AND FSF_REQ STATUS FLAGS ******************/
 
 /*
@@ -846,7 +729,6 @@ struct zfcp_data {
 	char                    init_busid[BUS_ID_SIZE];
 	wwn_t                   init_wwpn;
 	fcp_lun_t               init_fcp_lun;
-	char 			*driver_version;
 	struct kmem_cache		*fsf_req_qtcb_cache;
 	struct kmem_cache		*sr_buffer_cache;
 	struct kmem_cache		*gid_pn_cache;
--- a/drivers/s390/scsi/zfcp_erp.c	2008-06-10 17:37:48.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_erp.c	2008-06-10 17:41:27.000000000 +0200
@@ -1,26 +1,11 @@
 /*
- * This file is part of the zfcp device driver for
- * FCP adapters for IBM System z9 and zSeries.
+ * zfcp device driver
  *
- * (C) Copyright IBM Corp. 2002, 2006
+ * Error Recovery Procedures (ERP).
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ * Copyright IBM Corporation 2002, 2008
  */
 
-#define ZFCP_LOG_AREA			ZFCP_LOG_AREA_ERP
-
 #include "zfcp_ext.h"
 
 static int zfcp_erp_adapter_reopen_internal(struct zfcp_adapter *, int, u8,
@@ -171,14 +156,9 @@ static int zfcp_erp_adapter_reopen_inter
 {
 	int retval;
 
-	ZFCP_LOG_DEBUG("reopen adapter %s\n",
-		       zfcp_get_busid_by_adapter(adapter));
-
 	zfcp_erp_adapter_block(adapter, clear_mask);
 
 	if (atomic_test_mask(ZFCP_STATUS_COMMON_ERP_FAILED, &adapter->status)) {
-		ZFCP_LOG_DEBUG("skipped reopen of failed adapter %s\n",
-			       zfcp_get_busid_by_adapter(adapter));
 		/* ensure propagation of failed status to new devices */
 		zfcp_erp_adapter_failed(adapter, 13, NULL);
 		retval = -EIO;
@@ -270,15 +250,9 @@ static int zfcp_erp_port_forced_reopen_i
 {
 	int retval;
 
-	ZFCP_LOG_DEBUG("forced reopen of port 0x%016Lx on adapter %s\n",
-		       port->wwpn, zfcp_get_busid_by_port(port));
-
 	zfcp_erp_port_block(port, clear_mask);
 
 	if (atomic_test_mask(ZFCP_STATUS_COMMON_ERP_FAILED, &port->status)) {
-		ZFCP_LOG_DEBUG("skipped forced reopen of failed port 0x%016Lx "
-			       "on adapter %s\n", port->wwpn,
-			       zfcp_get_busid_by_port(port));
 		retval = -EIO;
 		goto out;
 	}
@@ -332,15 +306,9 @@ static int zfcp_erp_port_reopen_internal
 {
 	int retval;
 
-	ZFCP_LOG_DEBUG("reopen of port 0x%016Lx on adapter %s\n",
-		       port->wwpn, zfcp_get_busid_by_port(port));
-
 	zfcp_erp_port_block(port, clear_mask);
 
 	if (atomic_test_mask(ZFCP_STATUS_COMMON_ERP_FAILED, &port->status)) {
-		ZFCP_LOG_DEBUG("skipped reopen of failed port 0x%016Lx "
-			       "on adapter %s\n", port->wwpn,
-			       zfcp_get_busid_by_port(port));
 		/* ensure propagation of failed status to new devices */
 		zfcp_erp_port_failed(port, 14, NULL);
 		retval = -EIO;
@@ -396,17 +364,9 @@ static int zfcp_erp_unit_reopen_internal
 	int retval;
 	struct zfcp_adapter *adapter = unit->port->adapter;
 
-	ZFCP_LOG_DEBUG("reopen of unit 0x%016Lx on port 0x%016Lx "
-		       "on adapter %s\n", unit->fcp_lun,
-		       unit->port->wwpn, zfcp_get_busid_by_unit(unit));
-
 	zfcp_erp_unit_block(unit, clear_mask);
 
 	if (atomic_test_mask(ZFCP_STATUS_COMMON_ERP_FAILED, &unit->status)) {
-		ZFCP_LOG_DEBUG("skipped reopen of failed unit 0x%016Lx "
-			       "on port 0x%016Lx on adapter %s\n",
-			       unit->fcp_lun, unit->port->wwpn,
-			       zfcp_get_busid_by_unit(unit));
 		retval = -EIO;
 		goto out;
 	}
@@ -631,13 +591,8 @@ zfcp_erp_strategy_check_fsfreq(struct zf
 					ZFCP_STATUS_FSFREQ_DISMISSED;
 				zfcp_rec_dbf_event_action(142, erp_action);
 			}
-			if (erp_action->status & ZFCP_STATUS_ERP_TIMEDOUT) {
+			if (erp_action->status & ZFCP_STATUS_ERP_TIMEDOUT)
 				zfcp_rec_dbf_event_action(143, erp_action);
-				ZFCP_LOG_NORMAL("error: erp step timed out "
-						"(action=%d, fsf_req=%p)\n ",
-						erp_action->action,
-						erp_action->fsf_req);
-			}
 			/*
 			 * If fsf_req is neither dismissed nor completed
 			 * then keep it running asynchronously and don't mess
@@ -740,11 +695,10 @@ zfcp_erp_thread_setup(struct zfcp_adapte
 	atomic_clear_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_UP, &adapter->status);
 
 	retval = kernel_thread(zfcp_erp_thread, adapter, SIGCHLD);
-	if (retval < 0) {
-		ZFCP_LOG_NORMAL("error: creation of erp thread failed for "
-				"adapter %s\n",
-				zfcp_get_busid_by_adapter(adapter));
-	} else {
+	if (retval < 0)
+		dev_err(&adapter->ccw_device->dev,
+			"Creation of ERP thread failed.\n");
+	else {
 		wait_event(adapter->erp_thread_wqh,
 			   atomic_test_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_UP,
 					    &adapter->status));
@@ -919,15 +873,10 @@ zfcp_erp_strategy(struct zfcp_erp_action
 		   This might happen if an erp_action that used a memory pool
 		   element was timed out.
 		 */
-		if (adapter->erp_total_count == adapter->erp_low_mem_count) {
-			ZFCP_LOG_NORMAL("error: no mempool elements available, "
-					"restarting I/O on adapter %s "
-					"to free mempool\n",
-					zfcp_get_busid_by_adapter(adapter));
+		if (adapter->erp_total_count == adapter->erp_low_mem_count)
 			zfcp_erp_adapter_reopen_internal(adapter, 0, 66, NULL);
-		} else {
-		retval = zfcp_erp_strategy_memwait(erp_action);
-		}
+		else
+			retval = zfcp_erp_strategy_memwait(erp_action);
 		goto unlock;
 	case ZFCP_ERP_CONTINUES:
 		/* leave since this action runs asynchronously */
@@ -1039,12 +988,6 @@ zfcp_erp_strategy_do_action(struct zfcp_
 	case ZFCP_ERP_ACTION_REOPEN_UNIT:
 		retval = zfcp_erp_unit_strategy(erp_action);
 		break;
-
-	default:
-		ZFCP_LOG_NORMAL("bug: unknown erp action requested on "
-				"adapter %s (action=%d)\n",
-				zfcp_get_busid_by_adapter(erp_action->adapter),
-				erp_action->action);
 	}
 
 	return retval;
@@ -1083,8 +1026,7 @@ zfcp_erp_adapter_failed(struct zfcp_adap
 {
 	zfcp_erp_modify_adapter_status(adapter, id, ref,
 				       ZFCP_STATUS_COMMON_ERP_FAILED, ZFCP_SET);
-	ZFCP_LOG_NORMAL("adapter erp failed on adapter %s\n",
-			zfcp_get_busid_by_adapter(adapter));
+	dev_err(&adapter->ccw_device->dev, "Adapter ERP failed.\n");
 }
 
 /*
@@ -1100,12 +1042,13 @@ zfcp_erp_port_failed(struct zfcp_port *p
 				    ZFCP_STATUS_COMMON_ERP_FAILED, ZFCP_SET);
 
 	if (atomic_test_mask(ZFCP_STATUS_PORT_WKA, &port->status))
-		ZFCP_LOG_NORMAL("port erp failed (adapter %s, "
-				"port d_id=0x%06x)\n",
-				zfcp_get_busid_by_port(port), port->d_id);
+		dev_err(&port->adapter->ccw_device->dev,
+			"Port ERP failed for WKA port d_id=0x%06x.\n",
+			port->d_id);
 	else
-		ZFCP_LOG_NORMAL("port erp failed (adapter %s, wwpn=0x%016Lx)\n",
-				zfcp_get_busid_by_port(port), port->wwpn);
+		dev_err(&port->adapter->ccw_device->dev,
+			"Port ERP failed for port wwpn=0x%016Lx.\n",
+			port->wwpn);
 }
 
 /*
@@ -1120,9 +1063,9 @@ zfcp_erp_unit_failed(struct zfcp_unit *u
 	zfcp_erp_modify_unit_status(unit, id, ref,
 				    ZFCP_STATUS_COMMON_ERP_FAILED, ZFCP_SET);
 
-	ZFCP_LOG_NORMAL("unit erp failed on unit 0x%016Lx on port 0x%016Lx "
-			" on adapter %s\n", unit->fcp_lun,
-			unit->port->wwpn, zfcp_get_busid_by_unit(unit));
+	dev_err(&unit->port->adapter->ccw_device->dev,
+		"Unit ERP failed for unit 0x%016Lx on port 0x%016Lx.\n",
+		unit->fcp_lun, unit->port->wwpn);
 }
 
 /*
@@ -1336,13 +1279,10 @@ zfcp_erp_schedule_work(struct zfcp_unit 
 
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p) {
-		ZFCP_LOG_NORMAL("error: Out of resources. Could not register "
-				"the FCP-LUN 0x%Lx connected to "
-				"the port with WWPN 0x%Lx connected to "
-				"the adapter %s with the SCSI stack.\n",
-				unit->fcp_lun,
-				unit->port->wwpn,
-				zfcp_get_busid_by_unit(unit));
+		dev_err(&unit->port->adapter->ccw_device->dev,
+			"Out of resources. Could not register unit 0x%016Lx "
+			"on port 0x%016Lx with SCSI stack.\n",
+			unit->fcp_lun, unit->port->wwpn);
 		return;
 	}
 
@@ -1585,7 +1525,6 @@ static int
 zfcp_erp_adapter_strategy(struct zfcp_erp_action *erp_action)
 {
 	int retval;
-	struct zfcp_adapter *adapter = erp_action->adapter;
 
 	retval = zfcp_erp_adapter_strategy_close(erp_action);
 	if (erp_action->status & ZFCP_STATUS_ERP_CLOSE_ONLY)
@@ -1593,12 +1532,8 @@ zfcp_erp_adapter_strategy(struct zfcp_er
 	else
 		retval = zfcp_erp_adapter_strategy_open(erp_action);
 
-	if (retval == ZFCP_ERP_FAILED) {
-		ZFCP_LOG_INFO("Waiting to allow the adapter %s "
-			      "to recover itself\n",
-			      zfcp_get_busid_by_adapter(adapter));
+	if (retval == ZFCP_ERP_FAILED)
 		ssleep(ZFCP_TYPE2_RECOVERY_TIME);
-	}
 
 	return retval;
 }
@@ -1743,19 +1678,13 @@ zfcp_erp_adapter_strategy_open_fsf_xconf
 	for (retries = ZFCP_EXCHANGE_CONFIG_DATA_RETRIES; retries; retries--) {
 		atomic_clear_mask(ZFCP_STATUS_ADAPTER_HOST_CON_INIT,
 				  &adapter->status);
-		ZFCP_LOG_DEBUG("Doing exchange config data\n");
 		write_lock_irq(&adapter->erp_lock);
 		zfcp_erp_action_to_running(erp_action);
 		write_unlock_irq(&adapter->erp_lock);
 		if (zfcp_fsf_exchange_config_data(erp_action)) {
 			retval = ZFCP_ERP_FAILED;
-			ZFCP_LOG_INFO("error:  initiation of exchange of "
-				      "configuration data failed for "
-				      "adapter %s\n",
-				      zfcp_get_busid_by_adapter(adapter));
 			break;
 		}
-		ZFCP_LOG_DEBUG("Xchange underway\n");
 
 		/*
 		 * Why this works:
@@ -1773,19 +1702,13 @@ zfcp_erp_adapter_strategy_open_fsf_xconf
 		zfcp_rec_dbf_event_thread_lock(6, adapter);
 		down(&adapter->erp_ready_sem);
 		zfcp_rec_dbf_event_thread_lock(7, adapter);
-		if (erp_action->status & ZFCP_STATUS_ERP_TIMEDOUT) {
-			ZFCP_LOG_INFO("error: exchange of configuration data "
-				      "for adapter %s timed out\n",
-				      zfcp_get_busid_by_adapter(adapter));
+		if (erp_action->status & ZFCP_STATUS_ERP_TIMEDOUT)
 			break;
-		}
 
 		if (!atomic_test_mask(ZFCP_STATUS_ADAPTER_HOST_CON_INIT,
 				     &adapter->status))
 			break;
 
-		ZFCP_LOG_DEBUG("host connection still initialising... "
-			       "waiting and retrying...\n");
 		/* sleep a little bit before retry */
 		ssleep(sleep);
 		sleep *= 2;
@@ -1795,12 +1718,8 @@ zfcp_erp_adapter_strategy_open_fsf_xconf
 			  &adapter->status);
 
 	if (!atomic_test_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK,
-			      &adapter->status)) {
-		ZFCP_LOG_INFO("error: exchange of configuration data for "
-			      "adapter %s failed\n",
-			      zfcp_get_busid_by_adapter(adapter));
+			      &adapter->status))
 		retval = ZFCP_ERP_FAILED;
-	}
 
 	return retval;
 }
@@ -1829,16 +1748,8 @@ zfcp_erp_adapter_strategy_open_fsf_xport
 	zfcp_rec_dbf_event_thread_lock(8, adapter);
 	down(&adapter->erp_ready_sem);
 	zfcp_rec_dbf_event_thread_lock(9, adapter);
-	if (erp_action->status & ZFCP_STATUS_ERP_TIMEDOUT) {
-		ZFCP_LOG_INFO("error: exchange port data timed out (adapter "
-			      "%s)\n", zfcp_get_busid_by_adapter(adapter));
+	if (erp_action->status & ZFCP_STATUS_ERP_TIMEDOUT)
 		ret = ZFCP_ERP_FAILED;
-	}
-
-	/* don't treat as error for the sake of compatibility */
-	if (!atomic_test_mask(ZFCP_STATUS_ADAPTER_XPORT_OK, &adapter->status))
-		ZFCP_LOG_INFO("warning: exchange port data failed (adapter "
-			      "%s\n", zfcp_get_busid_by_adapter(adapter));
 
 	return ret;
 }
@@ -1884,8 +1795,6 @@ zfcp_erp_port_forced_strategy(struct zfc
 		if (atomic_test_mask((ZFCP_STATUS_PORT_PHYS_OPEN |
 				      ZFCP_STATUS_COMMON_OPEN),
 			             &port->status)) {
-			ZFCP_LOG_DEBUG("port 0x%016Lx is open -> trying "
-				       "close physical\n", port->wwpn);
 			retval =
 			    zfcp_erp_port_forced_strategy_close(erp_action);
 		} else
@@ -1895,8 +1804,6 @@ zfcp_erp_port_forced_strategy(struct zfc
 	case ZFCP_ERP_STEP_PHYS_PORT_CLOSING:
 		if (atomic_test_mask(ZFCP_STATUS_PORT_PHYS_OPEN,
 				     &port->status)) {
-			ZFCP_LOG_DEBUG("close physical failed for port "
-				       "0x%016Lx\n", port->wwpn);
 			retval = ZFCP_ERP_FAILED;
 		} else
 			retval = ZFCP_ERP_SUCCEEDED;
@@ -1930,8 +1837,6 @@ zfcp_erp_port_strategy(struct zfcp_erp_a
 	case ZFCP_ERP_STEP_UNINITIALIZED:
 		zfcp_erp_port_strategy_clearstati(port);
 		if (atomic_test_mask(ZFCP_STATUS_COMMON_OPEN, &port->status)) {
-			ZFCP_LOG_DEBUG("port 0x%016Lx is open -> trying "
-				       "close\n", port->wwpn);
 			retval = zfcp_erp_port_strategy_close(erp_action);
 			goto out;
 		}		/* else it's already closed, open it */
@@ -1939,8 +1844,6 @@ zfcp_erp_port_strategy(struct zfcp_erp_a
 
 	case ZFCP_ERP_STEP_PORT_CLOSING:
 		if (atomic_test_mask(ZFCP_STATUS_COMMON_OPEN, &port->status)) {
-			ZFCP_LOG_DEBUG("close failed for port 0x%016Lx\n",
-				       port->wwpn);
 			retval = ZFCP_ERP_FAILED;
 			goto out;
 		}		/* else it's closed now, open it */
@@ -1983,12 +1886,10 @@ zfcp_erp_port_strategy_open_common(struc
 	case ZFCP_ERP_STEP_PORT_CLOSING:
 		if (fc_host_port_type(adapter->scsi_host) == FC_PORTTYPE_PTP) {
 			if (port->wwpn != adapter->peer_wwpn) {
-				ZFCP_LOG_NORMAL("Failed to open port 0x%016Lx "
-						"on adapter %s.\nPeer WWPN "
-						"0x%016Lx does not match\n",
-						port->wwpn,
-						zfcp_get_busid_by_adapter(adapter),
-						adapter->peer_wwpn);
+				dev_err(&adapter->ccw_device->dev,
+					"Failed to open port 0x%016Lx, "
+					"Peer WWPN 0x%016Lx does not match.\n",
+					port->wwpn, adapter->peer_wwpn);
 				zfcp_erp_port_failed(port, 25, NULL);
 				retval = ZFCP_ERP_FAILED;
 				break;
@@ -2001,17 +1902,14 @@ zfcp_erp_port_strategy_open_common(struc
 		if (!(adapter->nameserver_port)) {
 			retval = zfcp_nameserver_enqueue(adapter);
 			if (retval != 0) {
-				ZFCP_LOG_NORMAL("error: nameserver port "
-						"unavailable for adapter %s\n",
-						zfcp_get_busid_by_adapter(adapter));
+				dev_err(&adapter->ccw_device->dev,
+					"Nameserver port unavailable.\n");
 				retval = ZFCP_ERP_FAILED;
 				break;
 			}
 		}
 		if (!atomic_test_mask(ZFCP_STATUS_COMMON_UNBLOCKED,
 				      &adapter->nameserver_port->status)) {
-			ZFCP_LOG_DEBUG("nameserver port is not open -> open "
-				       "nameserver port\n");
 			/* nameserver port may live again */
 			atomic_set_mask(ZFCP_STATUS_COMMON_RUNNING,
 					&adapter->nameserver_port->status);
@@ -2027,57 +1925,37 @@ zfcp_erp_port_strategy_open_common(struc
 		/* else nameserver port is already open, fall through */
 	case ZFCP_ERP_STEP_NAMESERVER_OPEN:
 		if (!atomic_test_mask(ZFCP_STATUS_COMMON_OPEN,
-				      &adapter->nameserver_port->status)) {
-			ZFCP_LOG_DEBUG("open failed for nameserver port\n");
+				      &adapter->nameserver_port->status))
 			retval = ZFCP_ERP_FAILED;
-		} else {
-			ZFCP_LOG_DEBUG("nameserver port is open -> "
-				       "nameserver look-up for port 0x%016Lx\n",
-				       port->wwpn);
+		else
 			retval = zfcp_erp_port_strategy_open_common_lookup
 				(erp_action);
-		}
 		break;
 
 	case ZFCP_ERP_STEP_NAMESERVER_LOOKUP:
 		if (!atomic_test_mask(ZFCP_STATUS_PORT_DID_DID, &port->status)) {
 			if (atomic_test_mask
 			    (ZFCP_STATUS_PORT_INVALID_WWPN, &port->status)) {
-				ZFCP_LOG_DEBUG("nameserver look-up failed "
-					       "for port 0x%016Lx "
-					       "(misconfigured WWPN?)\n",
-					       port->wwpn);
 				zfcp_erp_port_failed(port, 26, NULL);
 				retval = ZFCP_ERP_EXIT;
-			} else {
-				ZFCP_LOG_DEBUG("nameserver look-up failed for "
-					       "port 0x%016Lx\n", port->wwpn);
+			} else
 				retval = ZFCP_ERP_FAILED;
-			}
-		} else {
-			ZFCP_LOG_DEBUG("port 0x%016Lx has d_id=0x%06x -> "
-				       "trying open\n", port->wwpn, port->d_id);
+		} else
 			retval = zfcp_erp_port_strategy_open_port(erp_action);
-		}
 		break;
 
 	case ZFCP_ERP_STEP_PORT_OPENING:
 		/* D_ID might have changed during open */
 		if (atomic_test_mask((ZFCP_STATUS_COMMON_OPEN |
 				      ZFCP_STATUS_PORT_DID_DID),
-				     &port->status)) {
-			ZFCP_LOG_DEBUG("port 0x%016Lx is open\n", port->wwpn);
+				     &port->status))
 			retval = ZFCP_ERP_SUCCEEDED;
-		} else {
-			ZFCP_LOG_DEBUG("open failed for port 0x%016Lx\n",
-				       port->wwpn);
+		else
 			retval = ZFCP_ERP_FAILED;
-		}
 		break;
 
 	default:
-		ZFCP_LOG_NORMAL("bug: unknown erp step 0x%08x\n",
-				erp_action->step);
+		/* unknown erp step */
 		retval = ZFCP_ERP_FAILED;
 	}
 
@@ -2095,27 +1973,20 @@ zfcp_erp_port_strategy_open_nameserver(s
 	case ZFCP_ERP_STEP_UNINITIALIZED:
 	case ZFCP_ERP_STEP_PHYS_PORT_CLOSING:
 	case ZFCP_ERP_STEP_PORT_CLOSING:
-		ZFCP_LOG_DEBUG("port 0x%016Lx has d_id=0x%06x -> trying open\n",
-			       port->wwpn, port->d_id);
 		retval = zfcp_erp_port_strategy_open_port(erp_action);
 		break;
 
 	case ZFCP_ERP_STEP_PORT_OPENING:
-		if (atomic_test_mask(ZFCP_STATUS_COMMON_OPEN, &port->status)) {
-			ZFCP_LOG_DEBUG("WKA port is open\n");
+		if (atomic_test_mask(ZFCP_STATUS_COMMON_OPEN, &port->status))
 			retval = ZFCP_ERP_SUCCEEDED;
-		} else {
-			ZFCP_LOG_DEBUG("open failed for WKA port\n");
+		else
 			retval = ZFCP_ERP_FAILED;
-		}
 		/* this is needed anyway (dont care for retval of wakeup) */
-		ZFCP_LOG_DEBUG("continue other open port operations\n");
 		zfcp_erp_port_strategy_open_nameserver_wakeup(erp_action);
 		break;
 
 	default:
-		ZFCP_LOG_NORMAL("bug: unknown erp step 0x%08x\n",
-				erp_action->step);
+		/* unknown erp step */
 		retval = ZFCP_ERP_FAILED;
 	}
 
@@ -2313,39 +2184,26 @@ zfcp_erp_unit_strategy(struct zfcp_erp_a
 	case ZFCP_ERP_STEP_UNINITIALIZED:
 		zfcp_erp_unit_strategy_clearstati(unit);
 		if (atomic_test_mask(ZFCP_STATUS_COMMON_OPEN, &unit->status)) {
-			ZFCP_LOG_DEBUG("unit 0x%016Lx is open -> "
-				       "trying close\n", unit->fcp_lun);
 			retval = zfcp_erp_unit_strategy_close(erp_action);
 			break;
 		}
 		/* else it's already closed, fall through */
 	case ZFCP_ERP_STEP_UNIT_CLOSING:
-		if (atomic_test_mask(ZFCP_STATUS_COMMON_OPEN, &unit->status)) {
-			ZFCP_LOG_DEBUG("close failed for unit 0x%016Lx\n",
-				       unit->fcp_lun);
+		if (atomic_test_mask(ZFCP_STATUS_COMMON_OPEN, &unit->status))
 			retval = ZFCP_ERP_FAILED;
-		} else {
+		else
 			if (erp_action->status & ZFCP_STATUS_ERP_CLOSE_ONLY)
 				retval = ZFCP_ERP_EXIT;
-			else {
-				ZFCP_LOG_DEBUG("unit 0x%016Lx is not open -> "
-					       "trying open\n", unit->fcp_lun);
+			else
 				retval =
 				    zfcp_erp_unit_strategy_open(erp_action);
-			}
-		}
 		break;
 
 	case ZFCP_ERP_STEP_UNIT_OPENING:
-		if (atomic_test_mask(ZFCP_STATUS_COMMON_OPEN, &unit->status)) {
-			ZFCP_LOG_DEBUG("unit 0x%016Lx is open\n",
-				       unit->fcp_lun);
+		if (atomic_test_mask(ZFCP_STATUS_COMMON_OPEN, &unit->status))
 			retval = ZFCP_ERP_SUCCEEDED;
-		} else {
-			ZFCP_LOG_DEBUG("open failed for unit 0x%016Lx\n",
-				       unit->fcp_lun);
+		else
 			retval = ZFCP_ERP_FAILED;
-		}
 		break;
 	}
 
@@ -2493,16 +2351,8 @@ static int zfcp_erp_action_enqueue(int w
 
 	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
 		if (atomic_test_mask(ZFCP_STATUS_COMMON_ERP_INUSE,
-				     &port->status)) {
-			if (port->erp_action.action !=
-			    ZFCP_ERP_ACTION_REOPEN_PORT_FORCED) {
-				ZFCP_LOG_INFO("dropped erp action %i (port "
-					      "0x%016Lx, action in use: %i)\n",
-					      want, port->wwpn,
-					      port->erp_action.action);
-			}
+				     &port->status))
 			goto out;
-		}
 		if (!atomic_test_mask
 		    (ZFCP_STATUS_COMMON_RUNNING, &adapter->status) ||
 		    atomic_test_mask
@@ -2522,19 +2372,10 @@ static int zfcp_erp_action_enqueue(int w
 		break;
 
 	default:
-		ZFCP_LOG_NORMAL("bug: unknown erp action requested "
-				"on adapter %s (action=%d)\n",
-				zfcp_get_busid_by_adapter(adapter), want);
+		/* unknown erp action */
 		goto out;
 	}
 
-	/* check whether we need something stronger first */
-	if (need) {
-		ZFCP_LOG_DEBUG("stronger erp action %d needed before "
-			       "erp action %d on adapter %s\n",
-			       need, want, zfcp_get_busid_by_adapter(adapter));
-	}
-
 	/* mark adapter to have some error recovery pending */
 	atomic_set_mask(ZFCP_STATUS_ADAPTER_ERP_PENDING, &adapter->status);
 
@@ -2672,10 +2513,9 @@ zfcp_erp_action_cleanup(int action, stru
 			port->rport =
 				fc_remote_port_add(adapter->scsi_host, 0, &ids);
 			if (!port->rport)
-				ZFCP_LOG_NORMAL("failed registration of rport"
-						"(adapter %s, wwpn=0x%016Lx)\n",
-						zfcp_get_busid_by_port(port),
-						port->wwpn);
+				dev_err(&adapter->ccw_device->dev,
+					"Failed registration of rport "
+					"0x%016Lx.\n", port->wwpn);
 			else {
 				scsi_target_unblock(&port->rport->dev);
 				port->rport->maxframe_size = port->maxframe_size;
@@ -2803,7 +2643,6 @@ void zfcp_erp_adapter_access_changed(str
 
 void zfcp_erp_port_access_changed(struct zfcp_port *port, u8 id, void *ref)
 {
-	struct zfcp_adapter *adapter = port->adapter;
 	struct zfcp_unit *unit;
 
 	if (!atomic_test_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED,
@@ -2816,34 +2655,16 @@ void zfcp_erp_port_access_changed(struct
 		return;
 	}
 
-	ZFCP_LOG_NORMAL("reopen of port 0x%016Lx on adapter %s "
-			"(due to ACT update)\n",
-			port->wwpn, zfcp_get_busid_by_adapter(adapter));
-	if (zfcp_erp_port_reopen(port, ZFCP_STATUS_COMMON_ERP_FAILED, id, ref))
-		ZFCP_LOG_NORMAL("failed reopen of port"
-				"(adapter %s, wwpn=0x%016Lx)\n",
-				zfcp_get_busid_by_adapter(adapter), port->wwpn);
+	zfcp_erp_port_reopen(port, ZFCP_STATUS_COMMON_ERP_FAILED, id, ref);
 }
 
 void zfcp_erp_unit_access_changed(struct zfcp_unit *unit, u8 id, void *ref)
 {
-	struct zfcp_adapter *adapter = unit->port->adapter;
-
 	if (!atomic_test_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED,
 			      &unit->status) &&
 	    !atomic_test_mask(ZFCP_STATUS_COMMON_ACCESS_BOXED,
 			      &unit->status))
 		return;
 
-	ZFCP_LOG_NORMAL("reopen of unit 0x%016Lx on port 0x%016Lx "
-			" on adapter %s (due to ACT update)\n",
-			unit->fcp_lun, unit->port->wwpn,
-			zfcp_get_busid_by_adapter(adapter));
-	if (zfcp_erp_unit_reopen(unit, ZFCP_STATUS_COMMON_ERP_FAILED, id, ref))
-		ZFCP_LOG_NORMAL("failed reopen of unit (adapter %s, "
-				"wwpn=0x%016Lx, fcp_lun=0x%016Lx)\n",
-				zfcp_get_busid_by_adapter(adapter),
-				unit->port->wwpn, unit->fcp_lun);
+	zfcp_erp_unit_reopen(unit, ZFCP_STATUS_COMMON_ERP_FAILED, id, ref);
 }
-
-#undef ZFCP_LOG_AREA
--- a/drivers/s390/scsi/zfcp_ext.h	2008-06-10 17:37:48.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ext.h	2008-06-10 17:41:27.000000000 +0200
@@ -1,22 +1,9 @@
 /*
- * This file is part of the zfcp device driver for
- * FCP adapters for IBM System z9 and zSeries.
+ * zfcp device driver
  *
- * (C) Copyright IBM Corp. 2002, 2006
+ * External function declarations.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ * Copyright IBM Corporation 2002, 2008
  */
 
 #ifndef ZFCP_EXT_H
@@ -27,7 +14,6 @@
 extern struct zfcp_data zfcp_data;
 
 /******************************** SYSFS  *************************************/
-extern struct attribute_group *zfcp_driver_attr_groups[];
 extern int  zfcp_sysfs_adapter_create_files(struct device *);
 extern void zfcp_sysfs_adapter_remove_files(struct device *);
 extern int  zfcp_sysfs_port_create_files(struct device *, u32);
--- a/drivers/s390/scsi/zfcp_fsf.c	2008-06-10 17:41:01.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-06-10 17:41:27.000000000 +0200
@@ -1,22 +1,9 @@
 /*
- * This file is part of the zfcp device driver for
- * FCP adapters for IBM System z9 and zSeries.
+ * zfcp device driver
  *
- * (C) Copyright IBM Corp. 2002, 2006
+ * Implementation of FSF commands.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ * Copyright IBM Corporation 2002, 2008
  */
 
 #include "zfcp_ext.h"
@@ -71,12 +58,58 @@ static const char zfcp_act_subtable_type
 	"unknown", "OS", "WWPN", "DID", "LUN"
 };
 
+static void zfcp_act_eval_err(struct zfcp_adapter *adapter, u32 table)
+{
+	u16 subtable = (table & 0xffff0000) >> 16;
+	u16 rule = table & 0xffff;
+
+	if (subtable > 0 &&
+	    subtable < ARRAY_SIZE(zfcp_act_subtable_type)) {
+		dev_warn(&adapter->ccw_device->dev,
+			 "Access denied in subtable %s, rule %d.\n",
+			 zfcp_act_subtable_type[subtable], rule);
+	}
+}
+
+static void zfcp_fsf_access_denied_port(struct zfcp_fsf_req *req,
+					struct zfcp_port *port)
+{
+	struct fsf_qtcb_header *header = &req->qtcb->header;
+	dev_warn(&req->adapter->ccw_device->dev,
+		 "Access denied, cannot send command to port 0x%016Lx.\n",
+		 port->wwpn);
+	zfcp_act_eval_err(req->adapter, header->fsf_status_qual.halfword[0]);
+	zfcp_act_eval_err(req->adapter, header->fsf_status_qual.halfword[1]);
+	zfcp_erp_port_access_denied(port, 55, req);
+	req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+}
+
+static void zfcp_fsf_access_denied_unit(struct zfcp_fsf_req *req,
+					struct zfcp_unit *unit)
+{
+	struct fsf_qtcb_header *header = &req->qtcb->header;
+	dev_warn(&req->adapter->ccw_device->dev,
+		 "Access denied for unit 0x%016Lx on port 0x%016Lx.\n",
+		 unit->fcp_lun, unit->port->wwpn);
+	zfcp_act_eval_err(req->adapter, header->fsf_status_qual.halfword[0]);
+	zfcp_act_eval_err(req->adapter, header->fsf_status_qual.halfword[1]);
+	zfcp_erp_unit_access_denied(unit, 59, req);
+	req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+}
+
+static void zfcp_fsf_class_not_supp(struct zfcp_fsf_req *req)
+{
+	dev_err(&req->adapter->ccw_device->dev,
+		"Required FC class not supported by adapter, "
+		"shutting down adapter.\n");
+	zfcp_erp_adapter_shutdown(req->adapter, 0, 123, req);
+	req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+}
+
 /****************************************************************/
 /*************** FSF related Functions  *************************/
 /****************************************************************/
 
-#define ZFCP_LOG_AREA			ZFCP_LOG_AREA_FSF
-
 /*
  * function:	zfcp_fsf_req_alloc
  *
@@ -200,7 +233,6 @@ zfcp_fsf_req_complete(struct zfcp_fsf_re
 	int cleanup;
 
 	if (unlikely(fsf_req->fsf_command == FSF_QTCB_UNSOLICITED_STATUS)) {
-		ZFCP_LOG_DEBUG("Status read response received\n");
 		/*
 		 * Note: all cleanup handling is done in the callchain of
 		 * the function call-chain below.
@@ -225,7 +257,6 @@ zfcp_fsf_req_complete(struct zfcp_fsf_re
 
 	/* cleanup request if requested by initiator */
 	if (likely(cleanup)) {
-		ZFCP_LOG_TRACE("removing FSF request %p\n", fsf_req);
 		/*
 		 * lock must not be held here since it will be
 		 * grabed by the called routine, too
@@ -233,7 +264,6 @@ zfcp_fsf_req_complete(struct zfcp_fsf_re
 		zfcp_fsf_req_free(fsf_req);
 	} else {
 		/* notify initiator waiting for the requests completion */
-		ZFCP_LOG_TRACE("waking initiator of FSF request %p\n",fsf_req);
 		/*
 		 * FIXME: Race! We must not access fsf_req here as it might have been
 		 * cleaned up already due to the set ZFCP_STATUS_FSFREQ_COMPLETED
@@ -276,8 +306,6 @@ zfcp_fsf_protstatus_eval(struct zfcp_fsf
 	zfcp_hba_dbf_event_fsf_response(fsf_req);
 
 	if (fsf_req->status & ZFCP_STATUS_FSFREQ_DISMISSED) {
-		ZFCP_LOG_DEBUG("fsf_req 0x%lx has been dismissed\n",
-			       (unsigned long) fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR |
 			ZFCP_STATUS_FSFREQ_RETRY; /* only for SCSI cmnds. */
 		goto skip_protstatus;
@@ -291,34 +319,26 @@ zfcp_fsf_protstatus_eval(struct zfcp_fsf
 		break;
 
 	case FSF_PROT_QTCB_VERSION_ERROR:
-		ZFCP_LOG_NORMAL("error: The adapter %s contains "
-				"microcode of version 0x%x, the device driver "
-				"only supports 0x%x. Aborting.\n",
-				zfcp_get_busid_by_adapter(adapter),
-				prot_status_qual->version_error.fsf_version,
-				ZFCP_QTCB_VERSION);
+		dev_err(&adapter->ccw_device->dev,
+			"The QTCB version requested by zfcp (0x%x) is not "
+			"supported by the FCP adapter (lowest supported 0x%x, "
+			"highest supported 0x%x).\n",
+			ZFCP_QTCB_VERSION, prot_status_qual->word[0],
+			prot_status_qual->word[1]);
 		zfcp_erp_adapter_shutdown(adapter, 0, 117, fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
 	case FSF_PROT_SEQ_NUMB_ERROR:
-		ZFCP_LOG_NORMAL("bug: Sequence number mismatch between "
-				"driver (0x%x) and adapter %s (0x%x). "
-				"Restarting all operations on this adapter.\n",
-				qtcb->prefix.req_seq_no,
-				zfcp_get_busid_by_adapter(adapter),
-				prot_status_qual->sequence_error.exp_req_seq_no);
 		zfcp_erp_adapter_reopen(adapter, 0, 98, fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_RETRY;
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
 	case FSF_PROT_UNSUPP_QTCB_TYPE:
-		ZFCP_LOG_NORMAL("error: Packet header type used by the "
-				"device driver is incompatible with "
-				"that used on adapter %s. "
-				"Stopping all operations on this adapter.\n",
-				zfcp_get_busid_by_adapter(adapter));
+		dev_err(&adapter->ccw_device->dev,
+			"Packet header type used by the device driver is "
+			"incompatible with that used on the adapter.\n");
 		zfcp_erp_adapter_shutdown(adapter, 0, 118, fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
@@ -330,12 +350,9 @@ zfcp_fsf_protstatus_eval(struct zfcp_fsf
 		break;
 
 	case FSF_PROT_DUPLICATE_REQUEST_ID:
-			ZFCP_LOG_NORMAL("bug: The request identifier 0x%Lx "
-					"to the adapter %s is ambiguous. "
-				"Stopping all operations on this adapter.\n",
-				*(unsigned long long*)
-				(&qtcb->bottom.support.req_handle),
-					zfcp_get_busid_by_adapter(adapter));
+		dev_err(&adapter->ccw_device->dev,
+			"The request identifier 0x%Lx is ambiguous.\n",
+			(unsigned long long)qtcb->bottom.support.req_handle);
 		zfcp_erp_adapter_shutdown(adapter, 0, 78, fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
@@ -349,10 +366,6 @@ zfcp_fsf_protstatus_eval(struct zfcp_fsf
 		break;
 
 	case FSF_PROT_REEST_QUEUE:
-		ZFCP_LOG_NORMAL("The local link to adapter with "
-			      "%s was re-plugged. "
-			      "Re-starting operations on this adapter.\n",
-			      zfcp_get_busid_by_adapter(adapter));
 		/* All ports should be marked as ready to run again */
 		zfcp_erp_modify_adapter_status(adapter, 28, NULL,
 					       ZFCP_STATUS_COMMON_RUNNING,
@@ -365,24 +378,17 @@ zfcp_fsf_protstatus_eval(struct zfcp_fsf
 		break;
 
 	case FSF_PROT_ERROR_STATE:
-		ZFCP_LOG_NORMAL("error: The adapter %s "
-				"has entered the error state. "
-				"Restarting all operations on this "
-				"adapter.\n",
-				zfcp_get_busid_by_adapter(adapter));
 		zfcp_erp_adapter_reopen(adapter, 0, 100, fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_RETRY;
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
 	default:
-		ZFCP_LOG_NORMAL("bug: Transfer protocol status information "
-				"provided by the adapter %s "
-				"is not compatible with the device driver. "
-				"Stopping all operations on this adapter. "
-				"(debug info 0x%x).\n",
-				zfcp_get_busid_by_adapter(adapter),
-				qtcb->prefix.prot_status);
+		dev_err(&adapter->ccw_device->dev,
+			"Transfer protocol status information"
+			"provided by the adapter (0x%x) "
+			"is not compatible with the device driver.\n",
+			qtcb->prefix.prot_status);
 		zfcp_erp_adapter_shutdown(adapter, 0, 119, fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 	}
@@ -416,21 +422,14 @@ zfcp_fsf_fsfstatus_eval(struct zfcp_fsf_
 	/* evaluate FSF Status */
 	switch (fsf_req->qtcb->header.fsf_status) {
 	case FSF_UNKNOWN_COMMAND:
-		ZFCP_LOG_NORMAL("bug: Command issued by the device driver is "
-				"not known by the adapter %s "
-				"Stopping all operations on this adapter. "
-				"(debug info 0x%x).\n",
-				zfcp_get_busid_by_adapter(fsf_req->adapter),
-				fsf_req->qtcb->header.fsf_command);
+		dev_err(&fsf_req->adapter->ccw_device->dev,
+			"Command issued by the device driver (0x%x) is "
+			"not known by the adapter.\n",
+			fsf_req->qtcb->header.fsf_command);
 		zfcp_erp_adapter_shutdown(fsf_req->adapter, 0, 120, fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
-	case FSF_FCP_RSP_AVAILABLE:
-		ZFCP_LOG_DEBUG("FCP Sense data will be presented to the "
-			       "SCSI stack.\n");
-		break;
-
 	case FSF_ADAPTER_STATUS_AVAILABLE:
 		zfcp_fsf_fsfstatus_qual_eval(fsf_req);
 		break;
@@ -472,17 +471,13 @@ zfcp_fsf_fsfstatus_qual_eval(struct zfcp
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_SQ_NO_RECOM:
-		ZFCP_LOG_NORMAL("bug: No recommendation could be given for a "
-				"problem on the adapter %s "
-				"Stopping all operations on this adapter. ",
-				zfcp_get_busid_by_adapter(fsf_req->adapter));
+		dev_err(&fsf_req->adapter->ccw_device->dev,
+			"No recommendation could be given for a "
+			"problem on the adapter.\n");
 		zfcp_erp_adapter_shutdown(fsf_req->adapter, 0, 121, fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_SQ_ULP_PROGRAMMING_ERROR:
-		ZFCP_LOG_NORMAL("error: not enough SBALs for data transfer "
-				"(adapter %s)\n",
-				zfcp_get_busid_by_adapter(fsf_req->adapter));
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
@@ -491,11 +486,6 @@ zfcp_fsf_fsfstatus_qual_eval(struct zfcp
 		/* dealt with in the respective functions */
 		break;
 	default:
-		ZFCP_LOG_NORMAL("bug: Additional status info could "
-				"not be interpreted properly.\n");
-		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_NORMAL,
-			      (char *) &fsf_req->qtcb->header.fsf_status_qual,
-			      sizeof (union fsf_status_qual));
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	}
@@ -523,84 +513,67 @@ zfcp_fsf_link_down_info_eval(struct zfcp
 
 	switch (link_down->error_code) {
 	case FSF_PSQ_LINK_NO_LIGHT:
-		ZFCP_LOG_NORMAL("The local link to adapter %s is down "
-				"(no light detected)\n",
-				zfcp_get_busid_by_adapter(adapter));
+		dev_warn(&fsf_req->adapter->ccw_device->dev,
+			 "The local link is down: "
+			 "no light detected.\n");
 		break;
 	case FSF_PSQ_LINK_WRAP_PLUG:
-		ZFCP_LOG_NORMAL("The local link to adapter %s is down "
-				"(wrap plug detected)\n",
-				zfcp_get_busid_by_adapter(adapter));
+		dev_warn(&fsf_req->adapter->ccw_device->dev,
+			 "The local link is down: "
+			 "wrap plug detected.\n");
 		break;
 	case FSF_PSQ_LINK_NO_FCP:
-		ZFCP_LOG_NORMAL("The local link to adapter %s is down "
-				"(adjacent node on link does not support FCP)\n",
-				zfcp_get_busid_by_adapter(adapter));
+		dev_warn(&fsf_req->adapter->ccw_device->dev,
+			 "The local link is down: "
+			 "adjacent node on link does not support FCP.\n");
 		break;
 	case FSF_PSQ_LINK_FIRMWARE_UPDATE:
-		ZFCP_LOG_NORMAL("The local link to adapter %s is down "
-				"(firmware update in progress)\n",
-				zfcp_get_busid_by_adapter(adapter));
-			break;
+		dev_warn(&fsf_req->adapter->ccw_device->dev,
+			 "The local link is down: "
+			 "firmware update in progress.\n");
+		break;
 	case FSF_PSQ_LINK_INVALID_WWPN:
-		ZFCP_LOG_NORMAL("The local link to adapter %s is down "
-				"(duplicate or invalid WWPN detected)\n",
-				zfcp_get_busid_by_adapter(adapter));
+		dev_warn(&fsf_req->adapter->ccw_device->dev,
+			 "The local link is down: "
+			 "duplicate or invalid WWPN detected.\n");
 		break;
 	case FSF_PSQ_LINK_NO_NPIV_SUPPORT:
-		ZFCP_LOG_NORMAL("The local link to adapter %s is down "
-				"(no support for NPIV by Fabric)\n",
-				zfcp_get_busid_by_adapter(adapter));
+		dev_warn(&fsf_req->adapter->ccw_device->dev,
+			 "The local link is down: "
+			 "no support for NPIV by Fabric.\n");
 		break;
 	case FSF_PSQ_LINK_NO_FCP_RESOURCES:
-		ZFCP_LOG_NORMAL("The local link to adapter %s is down "
-				"(out of resource in FCP daughtercard)\n",
-				zfcp_get_busid_by_adapter(adapter));
+		dev_warn(&fsf_req->adapter->ccw_device->dev,
+			 "The local link is down: "
+			 "out of resource in FCP daughtercard.\n");
 		break;
 	case FSF_PSQ_LINK_NO_FABRIC_RESOURCES:
-		ZFCP_LOG_NORMAL("The local link to adapter %s is down "
-				"(out of resource in Fabric)\n",
-				zfcp_get_busid_by_adapter(adapter));
+		dev_warn(&fsf_req->adapter->ccw_device->dev,
+			 "The local link is down: "
+			 "out of resource in Fabric.\n");
 		break;
 	case FSF_PSQ_LINK_FABRIC_LOGIN_UNABLE:
-		ZFCP_LOG_NORMAL("The local link to adapter %s is down "
-				"(unable to Fabric login)\n",
-				zfcp_get_busid_by_adapter(adapter));
+		dev_warn(&fsf_req->adapter->ccw_device->dev,
+			 "The local link is down: "
+			 "unable to login to Fabric.\n");
 		break;
 	case FSF_PSQ_LINK_WWPN_ASSIGNMENT_CORRUPTED:
-		ZFCP_LOG_NORMAL("WWPN assignment file corrupted on adapter %s\n",
-				zfcp_get_busid_by_adapter(adapter));
+		dev_warn(&fsf_req->adapter->ccw_device->dev,
+			 "WWPN assignment file corrupted on adapter.\n");
 		break;
 	case FSF_PSQ_LINK_MODE_TABLE_CURRUPTED:
-		ZFCP_LOG_NORMAL("Mode table corrupted on adapter %s\n",
-				zfcp_get_busid_by_adapter(adapter));
+		dev_warn(&fsf_req->adapter->ccw_device->dev,
+			 "Mode table corrupted on adapter.\n");
 		break;
 	case FSF_PSQ_LINK_NO_WWPN_ASSIGNMENT:
-		ZFCP_LOG_NORMAL("No WWPN for assignment table on adapter %s\n",
-				zfcp_get_busid_by_adapter(adapter));
+		dev_warn(&fsf_req->adapter->ccw_device->dev,
+			 "No WWPN for assignment table on adapter.\n");
 		break;
 	default:
-		ZFCP_LOG_NORMAL("The local link to adapter %s is down "
-				"(warning: unknown reason code %d)\n",
-				zfcp_get_busid_by_adapter(adapter),
-				link_down->error_code);
+		dev_warn(&fsf_req->adapter->ccw_device->dev,
+			 "The local link to adapter is down.\n");
 	}
 
-	if (adapter->connection_features & FSF_FEATURE_NPIV_MODE)
-		ZFCP_LOG_DEBUG("Debug information to link down: "
-		               "primary_status=0x%02x "
-		               "ioerr_code=0x%02x "
-		               "action_code=0x%02x "
-		               "reason_code=0x%02x "
-		               "explanation_code=0x%02x "
-		               "vendor_specific_code=0x%02x\n",
-				link_down->primary_status,
-				link_down->ioerr_code,
-				link_down->action_code,
-				link_down->reason_code,
-				link_down->explanation_code,
-				link_down->vendor_specific_code);
-
  out:
 	zfcp_erp_adapter_failed(adapter, id, fsf_req);
 }
@@ -616,7 +589,6 @@ static int
 zfcp_fsf_req_dispatch(struct zfcp_fsf_req *fsf_req)
 {
 	struct zfcp_erp_action *erp_action = fsf_req->erp_action;
-	struct zfcp_adapter *adapter = fsf_req->adapter;
 	int retval = 0;
 
 
@@ -673,20 +645,6 @@ zfcp_fsf_req_dispatch(struct zfcp_fsf_re
 	case FSF_QTCB_UPLOAD_CONTROL_FILE:
 		zfcp_fsf_control_file_handler(fsf_req);
 		break;
-
-	default:
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		ZFCP_LOG_NORMAL("bug: Command issued by the device driver is "
-				"not supported by the adapter %s\n",
-				zfcp_get_busid_by_adapter(adapter));
-		if (fsf_req->fsf_command != fsf_req->qtcb->header.fsf_command)
-			ZFCP_LOG_NORMAL
-			    ("bug: Command issued by the device driver differs "
-			     "from the command returned by the adapter %s "
-			     "(debug info 0x%x, 0x%x).\n",
-			     zfcp_get_busid_by_adapter(adapter),
-			     fsf_req->fsf_command,
-			     fsf_req->qtcb->header.fsf_command);
 	}
 
 	if (!erp_action)
@@ -718,12 +676,8 @@ zfcp_fsf_status_read(struct zfcp_adapter
 				     req_flags | ZFCP_REQ_NO_QTCB,
 				     adapter->pool.fsf_req_status_read,
 				     &lock_flags, &fsf_req);
-	if (retval < 0) {
-		ZFCP_LOG_INFO("error: Could not create unsolicited status "
-			      "buffer for adapter %s.\n",
-			      zfcp_get_busid_by_adapter(adapter));
+	if (retval < 0)
 		goto failed_req_create;
-	}
 
 	sbale = zfcp_qdio_sbale_req(fsf_req);
         sbale[0].flags |= SBAL_FLAGS0_TYPE_STATUS;
@@ -744,14 +698,9 @@ zfcp_fsf_status_read(struct zfcp_adapter
 	sbale->length = sizeof(struct fsf_status_read_buffer);
 
 	retval = zfcp_fsf_req_send(fsf_req);
-	if (retval) {
-		ZFCP_LOG_DEBUG("error: Could not set-up unsolicited status "
-			       "environment.\n");
+	if (retval)
 		goto failed_req_send;
-	}
 
-	ZFCP_LOG_TRACE("Status Read request initiated (adapter%s)\n",
-		       zfcp_get_busid_by_adapter(adapter));
 	goto out;
 
  failed_req_send:
@@ -783,14 +732,8 @@ zfcp_fsf_status_read_port_closed(struct 
 		break;
 	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
 
-	if (!port || (port->d_id != (status_buffer->d_id & ZFCP_DID_MASK))) {
-		ZFCP_LOG_NORMAL("bug: Reopen port indication received for "
-				"nonexisting port with d_id 0x%06x on "
-				"adapter %s. Ignored.\n",
-				status_buffer->d_id & ZFCP_DID_MASK,
-				zfcp_get_busid_by_adapter(adapter));
+	if (!port || (port->d_id != (status_buffer->d_id & ZFCP_DID_MASK)))
 		goto out;
-	}
 
 	switch (status_buffer->status_subtype) {
 
@@ -801,20 +744,48 @@ zfcp_fsf_status_read_port_closed(struct 
 	case FSF_STATUS_READ_SUB_ERROR_PORT:
 		zfcp_erp_port_shutdown(port, 0, 122, fsf_req);
 		break;
-
-	default:
-		ZFCP_LOG_NORMAL("bug: Undefined status subtype received "
-				"for a reopen indication on port with "
-				"d_id 0x%06x on the adapter %s. "
-				"Ignored. (debug info 0x%x)\n",
-				status_buffer->d_id,
-				zfcp_get_busid_by_adapter(adapter),
-				status_buffer->status_subtype);
 	}
  out:
 	return 0;
 }
 
+static void zfcp_fsf_bit_error_threshold(struct zfcp_fsf_req *req)
+{
+	struct zfcp_adapter *adapter = req->adapter;
+	struct fsf_status_read_buffer *buf =
+		(struct fsf_status_read_buffer *) req->data;
+	struct fsf_bit_error_payload *err =
+		(struct fsf_bit_error_payload *) buf->payload;
+	dev_warn(&adapter->ccw_device->dev,
+		 "Warning: bit error threshold data "
+		 "received for the adapter: "
+		 "link failures = %i, loss of sync errors = %i, "
+		 "loss of signal errors = %i, "
+		 "primitive sequence errors = %i, "
+		 "invalid transmission word errors = %i, "
+		 "CRC errors = %i).\n",
+		 err->link_failure_error_count,
+		 err->loss_of_sync_error_count,
+		 err->loss_of_signal_error_count,
+		 err->primitive_sequence_error_count,
+		 err->invalid_transmission_word_error_count,
+		 err->crc_error_count);
+	dev_warn(&adapter->ccw_device->dev,
+		 "Additional bit error threshold data of the adapter: "
+		 "primitive sequence event time-outs = %i, "
+		 "elastic buffer overrun errors = %i, "
+		 "advertised receive buffer-to-buffer credit = %i, "
+		 "current receice buffer-to-buffer credit = %i, "
+		 "advertised transmit buffer-to-buffer credit = %i, "
+		 "current transmit buffer-to-buffer credit = %i).\n",
+		 err->primitive_sequence_event_timeout_count,
+		 err->elastic_buffer_overrun_error_count,
+		 err->advertised_receive_b2b_credit,
+		 err->current_receive_b2b_credit,
+		 err->advertised_transmit_b2b_credit,
+		 err->current_transmit_b2b_credit);
+}
+
 /*
  * function:    zfcp_fsf_status_read_handler
  *
@@ -829,7 +800,6 @@ zfcp_fsf_status_read_handler(struct zfcp
 	struct zfcp_adapter *adapter = fsf_req->adapter;
 	struct fsf_status_read_buffer *status_buffer =
 		(struct fsf_status_read_buffer *) fsf_req->data;
-	struct fsf_bit_error_payload *fsf_bit_error;
 
 	if (fsf_req->status & ZFCP_STATUS_FSFREQ_DISMISSED) {
 		zfcp_hba_dbf_event_fsf_unsol("dism", adapter, status_buffer);
@@ -851,79 +821,45 @@ zfcp_fsf_status_read_handler(struct zfcp
 		break;
 
 	case FSF_STATUS_READ_SENSE_DATA_AVAIL:
-		ZFCP_LOG_INFO("unsolicited sense data received (adapter %s)\n",
-			      zfcp_get_busid_by_adapter(adapter));
 		break;
 
 	case FSF_STATUS_READ_BIT_ERROR_THRESHOLD:
-		fsf_bit_error = (struct fsf_bit_error_payload *)
-			status_buffer->payload;
-		ZFCP_LOG_NORMAL("Warning: bit error threshold data "
-		    "received (adapter %s, "
-		    "link failures = %i, loss of sync errors = %i, "
-		    "loss of signal errors = %i, "
-		    "primitive sequence errors = %i, "
-		    "invalid transmission word errors = %i, "
-		    "CRC errors = %i)\n",
-		    zfcp_get_busid_by_adapter(adapter),
-		    fsf_bit_error->link_failure_error_count,
-		    fsf_bit_error->loss_of_sync_error_count,
-		    fsf_bit_error->loss_of_signal_error_count,
-		    fsf_bit_error->primitive_sequence_error_count,
-		    fsf_bit_error->invalid_transmission_word_error_count,
-		    fsf_bit_error->crc_error_count);
-		ZFCP_LOG_INFO("Additional bit error threshold data "
-		    "(adapter %s, "
-		    "primitive sequence event time-outs = %i, "
-		    "elastic buffer overrun errors = %i, "
-		    "advertised receive buffer-to-buffer credit = %i, "
-		    "current receice buffer-to-buffer credit = %i, "
-		    "advertised transmit buffer-to-buffer credit = %i, "
-		    "current transmit buffer-to-buffer credit = %i)\n",
-		    zfcp_get_busid_by_adapter(adapter),
-		    fsf_bit_error->primitive_sequence_event_timeout_count,
-		    fsf_bit_error->elastic_buffer_overrun_error_count,
-		    fsf_bit_error->advertised_receive_b2b_credit,
-		    fsf_bit_error->current_receive_b2b_credit,
-		    fsf_bit_error->advertised_transmit_b2b_credit,
-		    fsf_bit_error->current_transmit_b2b_credit);
+		zfcp_fsf_bit_error_threshold(fsf_req);
 		break;
 
 	case FSF_STATUS_READ_LINK_DOWN:
 		switch (status_buffer->status_subtype) {
 		case FSF_STATUS_READ_SUB_NO_PHYSICAL_LINK:
-			ZFCP_LOG_INFO("Physical link to adapter %s is down\n",
-				      zfcp_get_busid_by_adapter(adapter));
+			dev_warn(&adapter->ccw_device->dev,
+				 "Physical link is down.\n");
 			zfcp_fsf_link_down_info_eval(fsf_req, 38,
 				(struct fsf_link_down_info *)
 				&status_buffer->payload);
 			break;
 		case FSF_STATUS_READ_SUB_FDISC_FAILED:
-			ZFCP_LOG_INFO("Local link to adapter %s is down "
-				      "due to failed FDISC login\n",
-				      zfcp_get_busid_by_adapter(adapter));
+			dev_warn(&adapter->ccw_device->dev,
+				 "Local link is down "
+				 "due to failed FDISC login.\n");
 			zfcp_fsf_link_down_info_eval(fsf_req, 39,
 				(struct fsf_link_down_info *)
 				&status_buffer->payload);
 			break;
 		case FSF_STATUS_READ_SUB_FIRMWARE_UPDATE:
-			ZFCP_LOG_INFO("Local link to adapter %s is down "
-				      "due to firmware update on adapter\n",
-				      zfcp_get_busid_by_adapter(adapter));
+			dev_warn(&adapter->ccw_device->dev,
+				 "Local link is down "
+				 "due to firmware update on adapter.\n");
 			zfcp_fsf_link_down_info_eval(fsf_req, 40, NULL);
 			break;
 		default:
-			ZFCP_LOG_INFO("Local link to adapter %s is down "
-				      "due to unknown reason\n",
-				      zfcp_get_busid_by_adapter(adapter));
+			dev_warn(&adapter->ccw_device->dev,
+				 "Local link is down.\n");
 			zfcp_fsf_link_down_info_eval(fsf_req, 41, NULL);
 		};
 		break;
 
 	case FSF_STATUS_READ_LINK_UP:
-		ZFCP_LOG_NORMAL("Local link to adapter %s was replugged. "
-				"Restarting operations on this adapter\n",
-				zfcp_get_busid_by_adapter(adapter));
+		dev_info(&adapter->ccw_device->dev,
+			 "Local link was replugged.\n");
 		/* All ports should be marked as ready to run again */
 		zfcp_erp_modify_adapter_status(adapter, 30, NULL,
 					       ZFCP_STATUS_COMMON_RUNNING,
@@ -935,81 +871,18 @@ zfcp_fsf_status_read_handler(struct zfcp
 		break;
 
 	case FSF_STATUS_READ_NOTIFICATION_LOST:
-		ZFCP_LOG_NORMAL("Unsolicited status notification(s) lost: "
-				"adapter %s%s%s%s%s%s%s%s%s\n",
-				zfcp_get_busid_by_adapter(adapter),
-				(status_buffer->status_subtype &
-					FSF_STATUS_READ_SUB_INCOMING_ELS) ?
-					", incoming ELS" : "",
-				(status_buffer->status_subtype &
-					FSF_STATUS_READ_SUB_SENSE_DATA) ?
-					", sense data" : "",
-				(status_buffer->status_subtype &
-					FSF_STATUS_READ_SUB_LINK_STATUS) ?
-					", link status change" : "",
-				(status_buffer->status_subtype &
-					FSF_STATUS_READ_SUB_PORT_CLOSED) ?
-					", port close" : "",
-				(status_buffer->status_subtype &
-					FSF_STATUS_READ_SUB_BIT_ERROR_THRESHOLD) ?
-					", bit error exception" : "",
-				(status_buffer->status_subtype &
-					FSF_STATUS_READ_SUB_ACT_UPDATED) ?
-					", ACT update" : "",
-				(status_buffer->status_subtype &
-					FSF_STATUS_READ_SUB_ACT_HARDENED) ?
-					", ACT hardening" : "",
-				(status_buffer->status_subtype &
-					FSF_STATUS_READ_SUB_FEATURE_UPDATE_ALERT) ?
-					", adapter feature change" : "");
-
 		if (status_buffer->status_subtype &
 		    FSF_STATUS_READ_SUB_ACT_UPDATED)
 			zfcp_erp_adapter_access_changed(adapter, 135, fsf_req);
 		break;
 
 	case FSF_STATUS_READ_CFDC_UPDATED:
-		ZFCP_LOG_NORMAL("CFDC has been updated on the adapter %s\n",
-			      zfcp_get_busid_by_adapter(adapter));
 		zfcp_erp_adapter_access_changed(adapter, 136, fsf_req);
 		break;
 
-	case FSF_STATUS_READ_CFDC_HARDENED:
-		switch (status_buffer->status_subtype) {
-		case FSF_STATUS_READ_SUB_CFDC_HARDENED_ON_SE:
-			ZFCP_LOG_NORMAL("CFDC of adapter %s saved on SE\n",
-				      zfcp_get_busid_by_adapter(adapter));
-			break;
-		case FSF_STATUS_READ_SUB_CFDC_HARDENED_ON_SE2:
-			ZFCP_LOG_NORMAL("CFDC of adapter %s has been copied "
-				      "to the secondary SE\n",
-				zfcp_get_busid_by_adapter(adapter));
-			break;
-		default:
-			ZFCP_LOG_NORMAL("CFDC of adapter %s has been hardened\n",
-				      zfcp_get_busid_by_adapter(adapter));
-		}
-		break;
-
 	case FSF_STATUS_READ_FEATURE_UPDATE_ALERT:
-		ZFCP_LOG_INFO("List of supported features on adapter %s has "
-			      "been changed from 0x%08X to 0x%08X\n",
-			      zfcp_get_busid_by_adapter(adapter),
-			      *(u32*) (status_buffer->payload + 4),
-			      *(u32*) (status_buffer->payload));
 		adapter->adapter_features = *(u32*) status_buffer->payload;
 		break;
-
-	default:
-		ZFCP_LOG_NORMAL("warning: An unsolicited status packet of unknown "
-				"type was received (debug info 0x%x)\n",
-				status_buffer->status_type);
-		ZFCP_LOG_DEBUG("Dump of status_read_buffer %p:\n",
-			       status_buffer);
-		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG,
-			      (char *) status_buffer,
-			      sizeof (struct fsf_status_read_buffer));
-		break;
 	}
 	mempool_free(status_buffer, adapter->pool.data_status_read);
 	zfcp_fsf_req_free(fsf_req);
@@ -1060,15 +933,8 @@ zfcp_fsf_abort_fcp_command(unsigned long
 	retval = zfcp_fsf_req_create(adapter, FSF_QTCB_ABORT_FCP_CMND,
 				     req_flags, adapter->pool.fsf_req_abort,
 				     &lock_flags, &fsf_req);
-	if (retval < 0) {
-		ZFCP_LOG_INFO("error: Failed to create an abort command "
-			      "request for lun 0x%016Lx on port 0x%016Lx "
-			      "on adapter %s.\n",
-			      unit->fcp_lun,
-			      unit->port->wwpn,
-			      zfcp_get_busid_by_adapter(adapter));
+	if (retval < 0)
 		goto out;
-	}
 
 	if (unlikely(!atomic_test_mask(ZFCP_STATUS_COMMON_UNBLOCKED,
 			&unit->status)))
@@ -1134,17 +1000,6 @@ zfcp_fsf_abort_fcp_command_handler(struc
 			 * fine.
 			 */
 		} else {
-			ZFCP_LOG_INFO("Temporary port identifier 0x%x for "
-				      "port 0x%016Lx on adapter %s invalid. "
-				      "This may happen occasionally.\n",
-				      unit->port->handle,
-				      unit->port->wwpn,
-				      zfcp_get_busid_by_unit(unit));
-			ZFCP_LOG_INFO("status qualifier:\n");
-			ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_INFO,
-				      (char *) &new_fsf_req->qtcb->header.
-				      fsf_status_qual,
-				      sizeof (union fsf_status_qual));
 			/* Let's hope this sorts out the mess */
 			zfcp_erp_adapter_reopen(unit->port->adapter, 0, 104,
 						new_fsf_req);
@@ -1160,20 +1015,6 @@ zfcp_fsf_abort_fcp_command_handler(struc
 			 * This is fine.
 			 */
 		} else {
-			ZFCP_LOG_INFO
-			    ("Warning: Temporary LUN identifier 0x%x of LUN "
-			     "0x%016Lx on port 0x%016Lx on adapter %s is "
-			     "invalid. This may happen in rare cases. "
-			     "Trying to re-establish link.\n",
-			     unit->handle,
-			     unit->fcp_lun,
-			     unit->port->wwpn,
-			     zfcp_get_busid_by_unit(unit));
-			ZFCP_LOG_DEBUG("Status qualifier data:\n");
-			ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG,
-				      (char *) &new_fsf_req->qtcb->header.
-				      fsf_status_qual,
-				      sizeof (union fsf_status_qual));
 			/* Let's hope this sorts out the mess */
 			zfcp_erp_port_reopen(unit->port, 0, 105, new_fsf_req);
 			new_fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
@@ -1186,20 +1027,12 @@ zfcp_fsf_abort_fcp_command_handler(struc
 		break;
 
 	case FSF_PORT_BOXED:
-		ZFCP_LOG_INFO("Remote port 0x%016Lx on adapter %s needs to "
-			      "be reopened\n", unit->port->wwpn,
-			      zfcp_get_busid_by_unit(unit));
 		zfcp_erp_port_boxed(unit->port, 47, new_fsf_req);
 		new_fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR
 		    | ZFCP_STATUS_FSFREQ_RETRY;
 		break;
 
 	case FSF_LUN_BOXED:
-                ZFCP_LOG_INFO(
-                        "unit 0x%016Lx on port 0x%016Lx on adapter %s needs "
-                        "to be reopened\n",
-                        unit->fcp_lun, unit->port->wwpn,
-                        zfcp_get_busid_by_unit(unit));
 		zfcp_erp_unit_boxed(unit, 48, new_fsf_req);
                 new_fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR
                         | ZFCP_STATUS_FSFREQ_RETRY;
@@ -1215,11 +1048,6 @@ zfcp_fsf_abort_fcp_command_handler(struc
 			/* SCSI stack will escalate */
 			new_fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
-		default:
-			ZFCP_LOG_NORMAL
-			    ("bug: Wrong status qualifier 0x%x arrived.\n",
-			     new_fsf_req->qtcb->header.fsf_status_qual.word[0]);
-			break;
 		}
 		break;
 
@@ -1227,12 +1055,6 @@ zfcp_fsf_abort_fcp_command_handler(struc
 		retval = 0;
 		new_fsf_req->status |= ZFCP_STATUS_FSFREQ_ABORTSUCCEEDED;
 		break;
-
-	default:
-		ZFCP_LOG_NORMAL("bug: An unknown FSF Status was presented "
-				"(debug info 0x%x)\n",
-				new_fsf_req->qtcb->header.fsf_status);
-		break;
 	}
  skip_fsfstatus:
 	return retval;
@@ -1287,12 +1109,8 @@ zfcp_fsf_send_ct(struct zfcp_send_ct *ct
 	ret = zfcp_fsf_req_create(adapter, FSF_QTCB_SEND_GENERIC,
 				  ZFCP_WAIT_FOR_SBAL | ZFCP_REQ_AUTO_CLEANUP,
 				  pool, &lock_flags, &fsf_req);
-	if (ret < 0) {
-                ZFCP_LOG_INFO("error: Could not create CT request (FC-GS) for "
-			      "adapter: %s\n",
-			      zfcp_get_busid_by_adapter(adapter));
+	if (ret < 0)
 		goto failed_req;
-	}
 
 	sbale = zfcp_qdio_sbale_req(fsf_req);
         if (zfcp_use_one_sbal(ct->req, ct->req_count,
@@ -1313,9 +1131,6 @@ zfcp_fsf_send_ct(struct zfcp_send_ct *ct
 						ct->req,
                                                 ZFCP_MAX_SBALS_PER_CT_REQ);
                 if (bytes <= 0) {
-                        ZFCP_LOG_INFO("error: creation of CT request failed "
-				      "on adapter %s\n",
-				      zfcp_get_busid_by_adapter(adapter));
                         if (bytes == 0)
                                 ret = -ENOMEM;
                         else
@@ -1330,9 +1145,6 @@ zfcp_fsf_send_ct(struct zfcp_send_ct *ct
 						ct->resp,
                                                 ZFCP_MAX_SBALS_PER_CT_REQ);
                 if (bytes <= 0) {
-                        ZFCP_LOG_INFO("error: creation of CT request failed "
-				      "on adapter %s\n",
-				      zfcp_get_busid_by_adapter(adapter));
                         if (bytes == 0)
                                 ret = -ENOMEM;
                         else
@@ -1343,10 +1155,6 @@ zfcp_fsf_send_ct(struct zfcp_send_ct *ct
                 fsf_req->qtcb->bottom.support.resp_buf_length = bytes;
         } else {
                 /* reject send generic request */
-		ZFCP_LOG_INFO(
-			"error: microcode does not support chained SBALs,"
-                        "CT request too big (adapter %s)\n",
-			zfcp_get_busid_by_adapter(adapter));
                 ret = -EOPNOTSUPP;
                 goto failed_send;
         }
@@ -1368,15 +1176,9 @@ zfcp_fsf_send_ct(struct zfcp_send_ct *ct
 		zfcp_fsf_start_timer(fsf_req, ZFCP_FSF_REQUEST_TIMEOUT);
 
 	ret = zfcp_fsf_req_send(fsf_req);
-	if (ret) {
-		ZFCP_LOG_DEBUG("error: initiation of CT request failed "
-			       "(adapter %s, port 0x%016Lx)\n",
-			       zfcp_get_busid_by_adapter(adapter), port->wwpn);
+	if (ret)
 		goto failed_send;
-	}
 
-	ZFCP_LOG_DEBUG("CT request initiated (adapter %s, port 0x%016Lx)\n",
-		       zfcp_get_busid_by_adapter(adapter), port->wwpn);
 	goto out;
 
  failed_send:
@@ -1408,7 +1210,6 @@ zfcp_fsf_send_ct_handler(struct zfcp_fsf
 	struct fsf_qtcb_header *header;
 	struct fsf_qtcb_bottom_support *bottom;
 	int retval = -EINVAL;
-	u16 subtable, rule, counter;
 
 	adapter = fsf_req->adapter;
 	send_ct = (struct zfcp_send_ct *) fsf_req->data;
@@ -1428,13 +1229,7 @@ zfcp_fsf_send_ct_handler(struct zfcp_fsf
 		break;
 
         case FSF_SERVICE_CLASS_NOT_SUPPORTED:
-		ZFCP_LOG_INFO("error: adapter %s does not support fc "
-			      "class %d.\n",
-			      zfcp_get_busid_by_port(port),
-			      ZFCP_FC_SERVICE_CLASS_DEFAULT);
-		/* stop operation for this adapter */
-		zfcp_erp_adapter_shutdown(adapter, 0, 123, fsf_req);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+		zfcp_fsf_class_not_supp(fsf_req);
 		break;
 
         case FSF_ADAPTER_STATUS_AVAILABLE:
@@ -1448,63 +1243,23 @@ zfcp_fsf_send_ct_handler(struct zfcp_fsf
 			/* ERP strategy will escalate */
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
-                default:
-			ZFCP_LOG_INFO("bug: Wrong status qualifier 0x%x "
-				      "arrived.\n",
-				      header->fsf_status_qual.word[0]);
-			break;
                 }
                 break;
 
 	case FSF_ACCESS_DENIED:
-		ZFCP_LOG_NORMAL("access denied, cannot send generic service "
-				"command (adapter %s, port d_id=0x%06x)\n",
-				zfcp_get_busid_by_port(port), port->d_id);
-		for (counter = 0; counter < 2; counter++) {
-			subtable = header->fsf_status_qual.halfword[counter * 2];
-			rule = header->fsf_status_qual.halfword[counter * 2 + 1];
-			switch (subtable) {
-			case FSF_SQ_CFDC_SUBTABLE_OS:
-			case FSF_SQ_CFDC_SUBTABLE_PORT_WWPN:
-			case FSF_SQ_CFDC_SUBTABLE_PORT_DID:
-			case FSF_SQ_CFDC_SUBTABLE_LUN:
-       				ZFCP_LOG_INFO("Access denied (%s rule %d)\n",
-					zfcp_act_subtable_type[subtable], rule);
-				break;
-			}
-		}
-		zfcp_erp_port_access_denied(port, 55, fsf_req);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+		zfcp_fsf_access_denied_port(fsf_req, port);
 		break;
 
         case FSF_GENERIC_COMMAND_REJECTED:
-		ZFCP_LOG_INFO("generic service command rejected "
-			      "(adapter %s, port d_id=0x%06x)\n",
-			      zfcp_get_busid_by_port(port), port->d_id);
-		ZFCP_LOG_INFO("status qualifier:\n");
-		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_INFO,
-			      (char *) &header->fsf_status_qual,
-			      sizeof (union fsf_status_qual));
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
         case FSF_PORT_HANDLE_NOT_VALID:
-		ZFCP_LOG_DEBUG("Temporary port identifier 0x%x for port "
-			       "0x%016Lx on adapter %s invalid. This may "
-			       "happen occasionally.\n", port->handle,
-			       port->wwpn, zfcp_get_busid_by_port(port));
-		ZFCP_LOG_INFO("status qualifier:\n");
-		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_INFO,
-			      (char *) &header->fsf_status_qual,
-			      sizeof (union fsf_status_qual));
 		zfcp_erp_adapter_reopen(adapter, 0, 106, fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
         case FSF_PORT_BOXED:
-		ZFCP_LOG_INFO("port needs to be reopened "
-			      "(adapter %s, port d_id=0x%06x)\n",
-			      zfcp_get_busid_by_port(port), port->d_id);
 		zfcp_erp_port_boxed(port, 49, fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR
 		    | ZFCP_STATUS_FSFREQ_RETRY;
@@ -1513,37 +1268,13 @@ zfcp_fsf_send_ct_handler(struct zfcp_fsf
 	/* following states should never occure, all cases avoided
 	   in zfcp_fsf_send_ct - but who knows ... */
 	case FSF_PAYLOAD_SIZE_MISMATCH:
-		ZFCP_LOG_INFO("payload size mismatch (adapter: %s, "
-			      "req_buf_length=%d, resp_buf_length=%d)\n",
-			      zfcp_get_busid_by_adapter(adapter),
-			      bottom->req_buf_length, bottom->resp_buf_length);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		break;
 	case FSF_REQUEST_SIZE_TOO_LARGE:
-		ZFCP_LOG_INFO("request size too large (adapter: %s, "
-			      "req_buf_length=%d)\n",
-			      zfcp_get_busid_by_adapter(adapter),
-			      bottom->req_buf_length);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		break;
 	case FSF_RESPONSE_SIZE_TOO_LARGE:
-		ZFCP_LOG_INFO("response size too large (adapter: %s, "
-			      "resp_buf_length=%d)\n",
-			      zfcp_get_busid_by_adapter(adapter),
-			      bottom->resp_buf_length);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		break;
 	case FSF_SBAL_MISMATCH:
-		ZFCP_LOG_INFO("SBAL mismatch (adapter: %s, req_buf_length=%d, "
-			      "resp_buf_length=%d)\n",
-			      zfcp_get_busid_by_adapter(adapter),
-			      bottom->req_buf_length, bottom->resp_buf_length);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
        default:
-		ZFCP_LOG_NORMAL("bug: An unknown FSF Status was presented "
-				"(debug info 0x%x)\n", header->fsf_status);
 		break;
 	}
 
@@ -1578,12 +1309,8 @@ zfcp_fsf_send_els(struct zfcp_send_els *
         ret = zfcp_fsf_req_create(adapter, FSF_QTCB_SEND_ELS,
 				  ZFCP_REQ_AUTO_CLEANUP,
 				  NULL, &lock_flags, &fsf_req);
-	if (ret < 0) {
-                ZFCP_LOG_INFO("error: creation of ELS request failed "
-			      "(adapter %s, port d_id: 0x%06x)\n",
-                              zfcp_get_busid_by_adapter(adapter), d_id);
+	if (ret < 0)
                 goto failed_req;
-	}
 
 	if (unlikely(!atomic_test_mask(ZFCP_STATUS_COMMON_UNBLOCKED,
 			&els->port->status))) {
@@ -1610,9 +1337,6 @@ zfcp_fsf_send_els(struct zfcp_send_els *
 						els->req,
                                                 ZFCP_MAX_SBALS_PER_ELS_REQ);
                 if (bytes <= 0) {
-                        ZFCP_LOG_INFO("error: creation of ELS request failed "
-				      "(adapter %s, port d_id: 0x%06x)\n",
-				      zfcp_get_busid_by_adapter(adapter), d_id);
                         if (bytes == 0) {
                                 ret = -ENOMEM;
                         } else {
@@ -1627,9 +1351,6 @@ zfcp_fsf_send_els(struct zfcp_send_els *
 						els->resp,
                                                 ZFCP_MAX_SBALS_PER_ELS_REQ);
                 if (bytes <= 0) {
-                        ZFCP_LOG_INFO("error: creation of ELS request failed "
-				      "(adapter %s, port d_id: 0x%06x)\n",
-				      zfcp_get_busid_by_adapter(adapter), d_id);
                         if (bytes == 0) {
                                 ret = -ENOMEM;
                         } else {
@@ -1640,10 +1361,6 @@ zfcp_fsf_send_els(struct zfcp_send_els *
                 fsf_req->qtcb->bottom.support.resp_buf_length = bytes;
         } else {
                 /* reject request */
-		ZFCP_LOG_INFO("error: microcode does not support chained SBALs"
-                              ", ELS request too big (adapter %s, "
-			      "port d_id: 0x%06x)\n",
-			      zfcp_get_busid_by_adapter(adapter), d_id);
                 ret = -EOPNOTSUPP;
                 goto failed_send;
         }
@@ -1661,15 +1378,9 @@ zfcp_fsf_send_els(struct zfcp_send_els *
 
 	zfcp_fsf_start_timer(fsf_req, ZFCP_FSF_REQUEST_TIMEOUT);
 	ret = zfcp_fsf_req_send(fsf_req);
-	if (ret) {
-		ZFCP_LOG_DEBUG("error: initiation of ELS request failed "
-			       "(adapter %s, port d_id: 0x%06x)\n",
-			       zfcp_get_busid_by_adapter(adapter), d_id);
+	if (ret)
 		goto failed_send;
-	}
 
-	ZFCP_LOG_DEBUG("ELS request initiated (adapter %s, port d_id: "
-		       "0x%06x)\n", zfcp_get_busid_by_adapter(adapter), d_id);
 	goto out;
 
  port_blocked:
@@ -1701,7 +1412,6 @@ static int zfcp_fsf_send_els_handler(str
 	struct fsf_qtcb_bottom_support *bottom;
 	struct zfcp_send_els *send_els;
 	int retval = -EINVAL;
-	u16 subtable, rule, counter;
 
 	send_els = (struct zfcp_send_els *) fsf_req->data;
 	adapter = send_els->adapter;
@@ -1721,13 +1431,7 @@ static int zfcp_fsf_send_els_handler(str
 		break;
 
 	case FSF_SERVICE_CLASS_NOT_SUPPORTED:
-		ZFCP_LOG_INFO("error: adapter %s does not support fc "
-			      "class %d.\n",
-			      zfcp_get_busid_by_adapter(adapter),
-			      ZFCP_FC_SERVICE_CLASS_DEFAULT);
-		/* stop operation for this adapter */
-		zfcp_erp_adapter_shutdown(adapter, 0, 124, fsf_req);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+		zfcp_fsf_class_not_supp(fsf_req);
 		break;
 
 	case FSF_ADAPTER_STATUS_AVAILABLE:
@@ -1743,91 +1447,25 @@ static int zfcp_fsf_send_els_handler(str
 		case FSF_SQ_RETRY_IF_POSSIBLE:
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
-		default:
-			ZFCP_LOG_INFO("bug: Wrong status qualifier 0x%x\n",
-				      header->fsf_status_qual.word[0]);
-			ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_INFO,
-				(char*)header->fsf_status_qual.word, 16);
 		}
 		break;
 
 	case FSF_ELS_COMMAND_REJECTED:
-		ZFCP_LOG_INFO("ELS has been rejected because command filter "
-			      "prohibited sending "
-			      "(adapter: %s, port d_id: 0x%06x)\n",
-			      zfcp_get_busid_by_adapter(adapter), d_id);
-
-		break;
-
 	case FSF_PAYLOAD_SIZE_MISMATCH:
-		ZFCP_LOG_INFO(
-			"ELS request size and ELS response size must be either "
-			"both 0, or both greater than 0 "
-			"(adapter: %s, req_buf_length=%d resp_buf_length=%d)\n",
-			zfcp_get_busid_by_adapter(adapter),
-			bottom->req_buf_length,
-			bottom->resp_buf_length);
-		break;
-
 	case FSF_REQUEST_SIZE_TOO_LARGE:
-		ZFCP_LOG_INFO(
-			"Length of the ELS request buffer, "
-			"specified in QTCB bottom, "
-			"exceeds the size of the buffers "
-			"that have been allocated for ELS request data "
-			"(adapter: %s, req_buf_length=%d)\n",
-			zfcp_get_busid_by_adapter(adapter),
-			bottom->req_buf_length);
-		break;
-
 	case FSF_RESPONSE_SIZE_TOO_LARGE:
-		ZFCP_LOG_INFO(
-			"Length of the ELS response buffer, "
-			"specified in QTCB bottom, "
-			"exceeds the size of the buffers "
-			"that have been allocated for ELS response data "
-			"(adapter: %s, resp_buf_length=%d)\n",
-			zfcp_get_busid_by_adapter(adapter),
-			bottom->resp_buf_length);
 		break;
 
 	case FSF_SBAL_MISMATCH:
 		/* should never occure, avoided in zfcp_fsf_send_els */
-		ZFCP_LOG_INFO("SBAL mismatch (adapter: %s, req_buf_length=%d, "
-			      "resp_buf_length=%d)\n",
-			      zfcp_get_busid_by_adapter(adapter),
-			      bottom->req_buf_length, bottom->resp_buf_length);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
 	case FSF_ACCESS_DENIED:
-		ZFCP_LOG_NORMAL("access denied, cannot send ELS command "
-				"(adapter %s, port d_id=0x%06x)\n",
-				zfcp_get_busid_by_adapter(adapter), d_id);
-		for (counter = 0; counter < 2; counter++) {
-			subtable = header->fsf_status_qual.halfword[counter * 2];
-			rule = header->fsf_status_qual.halfword[counter * 2 + 1];
-			switch (subtable) {
-			case FSF_SQ_CFDC_SUBTABLE_OS:
-			case FSF_SQ_CFDC_SUBTABLE_PORT_WWPN:
-			case FSF_SQ_CFDC_SUBTABLE_PORT_DID:
-			case FSF_SQ_CFDC_SUBTABLE_LUN:
-				ZFCP_LOG_INFO("Access denied (%s rule %d)\n",
-					zfcp_act_subtable_type[subtable], rule);
-				break;
-			}
-		}
-		if (port != NULL)
-			zfcp_erp_port_access_denied(port, 56, fsf_req);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+		zfcp_fsf_access_denied_port(fsf_req, port);
 		break;
 
 	default:
-		ZFCP_LOG_NORMAL(
-			"bug: An unknown FSF Status was presented "
-			"(adapter: %s, fsf_status=0x%08x)\n",
-			zfcp_get_busid_by_adapter(adapter),
-			header->fsf_status);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	}
@@ -1857,9 +1495,6 @@ zfcp_fsf_exchange_config_data(struct zfc
 				     adapter->pool.fsf_req_erp,
 				     &lock_flags, &fsf_req);
 	if (retval) {
-		ZFCP_LOG_INFO("error: Could not create exchange configuration "
-			      "data request for adapter %s.\n",
-			      zfcp_get_busid_by_adapter(adapter));
 		write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
 		return retval;
 	}
@@ -1880,16 +1515,9 @@ zfcp_fsf_exchange_config_data(struct zfc
 	retval = zfcp_fsf_req_send(fsf_req);
 	write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
 	if (retval) {
-		ZFCP_LOG_INFO("error: Could not send exchange configuration "
-			      "data command on the adapter %s\n",
-			      zfcp_get_busid_by_adapter(adapter));
 		zfcp_fsf_req_free(fsf_req);
 		erp_action->fsf_req = NULL;
 	}
-	else
-		ZFCP_LOG_DEBUG("exchange configuration data request initiated "
-			       "(adapter %s)\n",
-			       zfcp_get_busid_by_adapter(adapter));
 
 	return retval;
 }
@@ -1908,9 +1536,6 @@ zfcp_fsf_exchange_config_data_sync(struc
 				     ZFCP_WAIT_FOR_SBAL, NULL, &lock_flags,
 				     &fsf_req);
 	if (retval) {
-		ZFCP_LOG_INFO("error: Could not create exchange configuration "
-			      "data request for adapter %s.\n",
-			      zfcp_get_busid_by_adapter(adapter));
 		write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
 		return retval;
 	}
@@ -1931,11 +1556,7 @@ zfcp_fsf_exchange_config_data_sync(struc
 	zfcp_fsf_start_timer(fsf_req, ZFCP_FSF_REQUEST_TIMEOUT);
 	retval = zfcp_fsf_req_send(fsf_req);
 	write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
-	if (retval)
-		ZFCP_LOG_INFO("error: Could not send exchange configuration "
-			      "data command on the adapter %s\n",
-			      zfcp_get_busid_by_adapter(adapter));
-	else
+	if (!retval)
 		wait_event(fsf_req->completion_wq,
 			   fsf_req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
 
@@ -1959,8 +1580,6 @@ zfcp_fsf_exchange_config_evaluate(struct
 	struct Scsi_Host *shost = adapter->scsi_host;
 
 	bottom = &fsf_req->qtcb->bottom.config;
-	ZFCP_LOG_DEBUG("low/high QTCB version 0x%x/0x%x of FSF\n",
-		       bottom->low_qtcb_version, bottom->high_qtcb_version);
 	adapter->fsf_lic_version = bottom->lic_version;
 	adapter->adapter_features = bottom->adapter_features;
 	adapter->connection_features = bottom->connection_features;
@@ -2013,36 +1632,17 @@ zfcp_fsf_exchange_config_evaluate(struct
 		       min(FC_SERIAL_NUMBER_SIZE, 17));
 	}
 
-	if (fsf_req->erp_action)
-		ZFCP_LOG_NORMAL("The adapter %s reported the following "
-				"characteristics:\n"
-				"WWNN 0x%016Lx, WWPN 0x%016Lx, "
-				"S_ID 0x%06x,\n"
-				"adapter version 0x%x, "
-				"LIC version 0x%x, "
-				"FC link speed %d Gb/s\n",
-				zfcp_get_busid_by_adapter(adapter),
-				(wwn_t) fc_host_node_name(shost),
-				(wwn_t) fc_host_port_name(shost),
-				fc_host_port_id(shost),
-				adapter->hydra_version,
-				adapter->fsf_lic_version,
-				fc_host_speed(shost));
 	if (ZFCP_QTCB_VERSION < bottom->low_qtcb_version) {
-		ZFCP_LOG_NORMAL("error: the adapter %s "
-				"only supports newer control block "
-				"versions in comparison to this device "
-				"driver (try updated device driver)\n",
-				zfcp_get_busid_by_adapter(adapter));
+		dev_err(&adapter->ccw_device->dev,
+			"The adapter only supports newer control block "
+			"versions, try updated device driver.\n");
 		zfcp_erp_adapter_shutdown(adapter, 0, 125, fsf_req);
 		return -EIO;
 	}
 	if (ZFCP_QTCB_VERSION > bottom->high_qtcb_version) {
-		ZFCP_LOG_NORMAL("error: the adapter %s "
-				"only supports older control block "
-				"versions than this device driver uses"
-				"(consider a microcode upgrade)\n",
-				zfcp_get_busid_by_adapter(adapter));
+		dev_err(&adapter->ccw_device->dev,
+			"The adapter only supports older control block "
+			"versions, consider a microcode upgrade.\n");
 		zfcp_erp_adapter_shutdown(adapter, 0, 126, fsf_req);
 		return -EIO;
 	}
@@ -2074,50 +1674,38 @@ zfcp_fsf_exchange_config_data_handler(st
 
 		switch (fc_host_port_type(adapter->scsi_host)) {
 		case FC_PORTTYPE_PTP:
-			ZFCP_LOG_NORMAL("Point-to-Point fibrechannel "
-					"configuration detected at adapter %s\n"
-					"Peer WWNN 0x%016llx, "
-					"peer WWPN 0x%016llx, "
-					"peer d_id 0x%06x\n",
-					zfcp_get_busid_by_adapter(adapter),
-					adapter->peer_wwnn,
-					adapter->peer_wwpn,
-					adapter->peer_d_id);
+			if (fsf_req->erp_action)
+				dev_info(&adapter->ccw_device->dev,
+					 "Point-to-Point fibrechannel "
+					 "configuration detected.\n");
 			break;
 		case FC_PORTTYPE_NLPORT:
-			ZFCP_LOG_NORMAL("error: Arbitrated loop fibrechannel "
-					"topology detected at adapter %s "
-					"unsupported, shutting down adapter\n",
-					zfcp_get_busid_by_adapter(adapter));
+			dev_err(&adapter->ccw_device->dev,
+				"Unsupported arbitrated loop fibrechannel "
+				"topology detected, shutting down adapter\n");
 			zfcp_erp_adapter_shutdown(adapter, 0, 127, fsf_req);
 			return -EIO;
 		case FC_PORTTYPE_NPORT:
 			if (fsf_req->erp_action)
-				ZFCP_LOG_NORMAL("Switched fabric fibrechannel "
-						"network detected at adapter "
-						"%s.\n",
-					zfcp_get_busid_by_adapter(adapter));
+				dev_info(&adapter->ccw_device->dev,
+					 "Switched fabric fibrechannel "
+					 "network detected.\n");
 			break;
 		default:
-			ZFCP_LOG_NORMAL("bug: The fibrechannel topology "
-					"reported by the exchange "
-					"configuration command for "
-					"the adapter %s is not "
-					"of a type known to the zfcp "
-					"driver, shutting down adapter\n",
-					zfcp_get_busid_by_adapter(adapter));
+			dev_err(&adapter->ccw_device->dev,
+				"The fibrechannel topology reported by the "
+				"adapter is not known by the zfcp driver, "
+				"shutting down adapter.\n");
 			zfcp_erp_adapter_shutdown(adapter, 0, 128, fsf_req);
 			return -EIO;
 		}
 		bottom = &qtcb->bottom.config;
 		if (bottom->max_qtcb_size < sizeof(struct fsf_qtcb)) {
-			ZFCP_LOG_NORMAL("bug: Maximum QTCB size (%d bytes) "
-					"allowed by the adapter %s "
-					"is lower than the minimum "
-					"required by the driver (%ld bytes).\n",
-					bottom->max_qtcb_size,
-					zfcp_get_busid_by_adapter(adapter),
-					sizeof(struct fsf_qtcb));
+			dev_err(&adapter->ccw_device->dev,
+				"Maximum QTCB size (%d bytes) allowed by "
+				"the adapter is lower than the minimum "
+				"required by the driver (%ld bytes).\n",
+				bottom->max_qtcb_size, sizeof(struct fsf_qtcb));
 			zfcp_erp_adapter_shutdown(adapter, 0, 129, fsf_req);
 			return -EIO;
 		}
@@ -2154,12 +1742,8 @@ zfcp_fsf_exchange_port_data(struct zfcp_
 	unsigned long lock_flags;
 	int retval;
 
-	if (!(adapter->adapter_features & FSF_FEATURE_HBAAPI_MANAGEMENT)) {
-		ZFCP_LOG_INFO("error: exchange port data "
-			      "command not supported by adapter %s\n",
-			      zfcp_get_busid_by_adapter(adapter));
+	if (!(adapter->adapter_features & FSF_FEATURE_HBAAPI_MANAGEMENT))
 		return -EOPNOTSUPP;
-	}
 
 	/* setup new FSF request */
 	retval = zfcp_fsf_req_create(adapter, FSF_QTCB_EXCHANGE_PORT_DATA,
@@ -2167,10 +1751,6 @@ zfcp_fsf_exchange_port_data(struct zfcp_
 				     adapter->pool.fsf_req_erp,
 				     &lock_flags, &fsf_req);
 	if (retval) {
-		ZFCP_LOG_INFO("error: Out of resources. Could not create an "
-			      "exchange port data request for "
-			      "the adapter %s.\n",
-			      zfcp_get_busid_by_adapter(adapter));
 		write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
 		return retval;
 	}
@@ -2187,16 +1767,9 @@ zfcp_fsf_exchange_port_data(struct zfcp_
 	write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
 
 	if (retval) {
-		ZFCP_LOG_INFO("error: Could not send an exchange port data "
-			      "command on the adapter %s\n",
-			      zfcp_get_busid_by_adapter(adapter));
 		zfcp_fsf_req_free(fsf_req);
 		erp_action->fsf_req = NULL;
 	}
-	else
-		ZFCP_LOG_DEBUG("exchange port data request initiated "
-			       "(adapter %s)\n",
-			       zfcp_get_busid_by_adapter(adapter));
 	return retval;
 }
 
@@ -2214,21 +1787,13 @@ zfcp_fsf_exchange_port_data_sync(struct 
 	unsigned long lock_flags;
 	int retval;
 
-	if (!(adapter->adapter_features & FSF_FEATURE_HBAAPI_MANAGEMENT)) {
-		ZFCP_LOG_INFO("error: exchange port data "
-			      "command not supported by adapter %s\n",
-			      zfcp_get_busid_by_adapter(adapter));
+	if (!(adapter->adapter_features & FSF_FEATURE_HBAAPI_MANAGEMENT))
 		return -EOPNOTSUPP;
-	}
 
 	/* setup new FSF request */
 	retval = zfcp_fsf_req_create(adapter, FSF_QTCB_EXCHANGE_PORT_DATA,
 				0, NULL, &lock_flags, &fsf_req);
 	if (retval) {
-		ZFCP_LOG_INFO("error: Out of resources. Could not create an "
-			      "exchange port data request for "
-			      "the adapter %s.\n",
-			      zfcp_get_busid_by_adapter(adapter));
 		write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
 		return retval;
 	}
@@ -2244,11 +1809,7 @@ zfcp_fsf_exchange_port_data_sync(struct 
 	retval = zfcp_fsf_req_send(fsf_req);
 	write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
 
-	if (retval)
-		ZFCP_LOG_INFO("error: Could not send an exchange port data "
-			      "command on the adapter %s\n",
-			      zfcp_get_busid_by_adapter(adapter));
-	else
+	if (!retval)
 		wait_event(fsf_req->completion_wq,
 			   fsf_req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
 
@@ -2338,13 +1899,8 @@ zfcp_fsf_open_port(struct zfcp_erp_actio
 				     ZFCP_WAIT_FOR_SBAL | ZFCP_REQ_AUTO_CLEANUP,
 				     erp_action->adapter->pool.fsf_req_erp,
 				     &lock_flags, &fsf_req);
-	if (retval < 0) {
-		ZFCP_LOG_INFO("error: Could not create open port request "
-			      "for port 0x%016Lx on adapter %s.\n",
-			      erp_action->port->wwpn,
-			      zfcp_get_busid_by_adapter(erp_action->adapter));
+	if (retval < 0)
 		goto out;
-	}
 
 	sbale = zfcp_qdio_sbale_req(fsf_req);
         sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
@@ -2359,19 +1915,11 @@ zfcp_fsf_open_port(struct zfcp_erp_actio
 	zfcp_erp_start_timer(fsf_req);
 	retval = zfcp_fsf_req_send(fsf_req);
 	if (retval) {
-		ZFCP_LOG_INFO("error: Could not send open port request for "
-			      "port 0x%016Lx on adapter %s.\n",
-			      erp_action->port->wwpn,
-			      zfcp_get_busid_by_adapter(erp_action->adapter));
 		zfcp_fsf_req_free(fsf_req);
 		erp_action->fsf_req = NULL;
 		goto out;
 	}
 
-	ZFCP_LOG_DEBUG("open port request initiated "
-		       "(adapter %s,  port 0x%016Lx)\n",
-		       zfcp_get_busid_by_adapter(erp_action->adapter),
-		       erp_action->port->wwpn);
  out:
 	write_unlock_irqrestore(&erp_action->adapter->req_q.lock, lock_flags);
 	return retval;
@@ -2391,7 +1939,6 @@ zfcp_fsf_open_port_handler(struct zfcp_f
 	struct zfcp_port *port;
 	struct fsf_plogi *plogi;
 	struct fsf_qtcb_header *header;
-	u16 subtable, rule, counter;
 
 	port = (struct zfcp_port *) fsf_req->data;
 	header = &fsf_req->qtcb->header;
@@ -2405,9 +1952,6 @@ zfcp_fsf_open_port_handler(struct zfcp_f
 	switch (header->fsf_status) {
 
 	case FSF_PORT_ALREADY_OPEN:
-		ZFCP_LOG_NORMAL("bug: remote port 0x%016Lx on adapter %s "
-				"is already open.\n",
-				port->wwpn, zfcp_get_busid_by_port(port));
 		/*
 		 * This is a bug, however operation should continue normally
 		 * if it is simply ignored
@@ -2415,31 +1959,14 @@ zfcp_fsf_open_port_handler(struct zfcp_f
 		break;
 
 	case FSF_ACCESS_DENIED:
-		ZFCP_LOG_NORMAL("Access denied, cannot open port 0x%016Lx "
-				"on adapter %s\n",
-				port->wwpn, zfcp_get_busid_by_port(port));
-		for (counter = 0; counter < 2; counter++) {
-			subtable = header->fsf_status_qual.halfword[counter * 2];
-			rule = header->fsf_status_qual.halfword[counter * 2 + 1];
-			switch (subtable) {
-			case FSF_SQ_CFDC_SUBTABLE_OS:
-			case FSF_SQ_CFDC_SUBTABLE_PORT_WWPN:
-			case FSF_SQ_CFDC_SUBTABLE_PORT_DID:
-			case FSF_SQ_CFDC_SUBTABLE_LUN:
-				ZFCP_LOG_INFO("Access denied (%s rule %d)\n",
-					zfcp_act_subtable_type[subtable], rule);
-				break;
-			}
-		}
-		zfcp_erp_port_access_denied(port, 57, fsf_req);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+		zfcp_fsf_access_denied_port(fsf_req, port);
 		break;
 
 	case FSF_MAXIMUM_NUMBER_OF_PORTS_EXCEEDED:
-		ZFCP_LOG_INFO("error: The FSF adapter is out of resources. "
-			      "The remote port 0x%016Lx on adapter %s "
-			      "could not be opened. Disabling it.\n",
-			      port->wwpn, zfcp_get_busid_by_port(port));
+		dev_warn(&fsf_req->adapter->ccw_device->dev,
+			 "The adapter is out of resources. The remote port "
+			 "0x%016Lx could not be opened, disabling it.\n",
+			 port->wwpn);
 		zfcp_erp_port_failed(port, 31, fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
@@ -2455,18 +1982,13 @@ zfcp_fsf_open_port_handler(struct zfcp_f
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		case FSF_SQ_NO_RETRY_POSSIBLE:
-			ZFCP_LOG_NORMAL("The remote port 0x%016Lx on "
-					"adapter %s could not be opened. "
-					"Disabling it.\n",
-					port->wwpn,
-					zfcp_get_busid_by_port(port));
+			dev_warn(&fsf_req->adapter->ccw_device->dev,
+				 "The remote port 0x%016Lx could not be "
+				 "opened. Disabling it.\n", port->wwpn);
 			zfcp_erp_port_failed(port, 32, fsf_req);
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		default:
-			ZFCP_LOG_NORMAL
-			    ("bug: Wrong status qualifier 0x%x arrived.\n",
-			     header->fsf_status_qual.word[0]);
 			break;
 		}
 		break;
@@ -2474,10 +1996,6 @@ zfcp_fsf_open_port_handler(struct zfcp_f
 	case FSF_GOOD:
 		/* save port handle assigned by FSF */
 		port->handle = header->port_handle;
-		ZFCP_LOG_INFO("The remote port 0x%016Lx via adapter %s "
-			      "was opened, it's port handle is 0x%x\n",
-			      port->wwpn, zfcp_get_busid_by_port(port),
-			      port->handle);
 		/* mark port as open */
 		atomic_set_mask(ZFCP_STATUS_COMMON_OPEN |
 				ZFCP_STATUS_PORT_PHYS_OPEN, &port->status);
@@ -2505,16 +2023,9 @@ zfcp_fsf_open_port_handler(struct zfcp_f
 		{
 			if (fsf_req->qtcb->bottom.support.els1_length <
 			    sizeof (struct fsf_plogi)) {
-				ZFCP_LOG_INFO(
-					"warning: insufficient length of "
-					"PLOGI payload (%i)\n",
-					fsf_req->qtcb->bottom.support.els1_length);
 				/* skip sanity check and assume wwpn is ok */
 			} else {
 				if (plogi->serv_param.wwpn != port->wwpn) {
-					ZFCP_LOG_INFO("warning: d_id of port "
-						      "0x%016Lx changed during "
-						      "open\n", port->wwpn);
 					atomic_clear_mask(
 						ZFCP_STATUS_PORT_DID_DID,
 						&port->status);
@@ -2528,17 +2039,10 @@ zfcp_fsf_open_port_handler(struct zfcp_f
 
 	case FSF_UNKNOWN_OP_SUBTYPE:
 		/* should never occure, subtype not set in zfcp_fsf_open_port */
-		ZFCP_LOG_INFO("unknown operation subtype (adapter: %s, "
-			      "op_subtype=0x%x)\n",
-			      zfcp_get_busid_by_port(port),
-			      fsf_req->qtcb->bottom.support.operation_subtype);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
 	default:
-		ZFCP_LOG_NORMAL("bug: An unknown FSF Status was presented "
-				"(debug info 0x%x)\n",
-				header->fsf_status);
 		break;
 	}
 
@@ -2569,13 +2073,8 @@ zfcp_fsf_close_port(struct zfcp_erp_acti
 				     ZFCP_WAIT_FOR_SBAL | ZFCP_REQ_AUTO_CLEANUP,
 				     erp_action->adapter->pool.fsf_req_erp,
 				     &lock_flags, &fsf_req);
-	if (retval < 0) {
-		ZFCP_LOG_INFO("error: Could not create a close port request "
-			      "for port 0x%016Lx on adapter %s.\n",
-			      erp_action->port->wwpn,
-			      zfcp_get_busid_by_adapter(erp_action->adapter));
+	if (retval < 0)
 		goto out;
-	}
 
 	sbale = zfcp_qdio_sbale_req(fsf_req);
         sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
@@ -2591,19 +2090,11 @@ zfcp_fsf_close_port(struct zfcp_erp_acti
 	zfcp_erp_start_timer(fsf_req);
 	retval = zfcp_fsf_req_send(fsf_req);
 	if (retval) {
-		ZFCP_LOG_INFO("error: Could not send a close port request for "
-			      "port 0x%016Lx on adapter %s.\n",
-			      erp_action->port->wwpn,
-			      zfcp_get_busid_by_adapter(erp_action->adapter));
 		zfcp_fsf_req_free(fsf_req);
 		erp_action->fsf_req = NULL;
 		goto out;
 	}
 
-	ZFCP_LOG_TRACE("close port request initiated "
-		       "(adapter %s, port 0x%016Lx)\n",
-		       zfcp_get_busid_by_adapter(erp_action->adapter),
-		       erp_action->port->wwpn);
  out:
 	write_unlock_irqrestore(&erp_action->adapter->req_q.lock, lock_flags);
 	return retval;
@@ -2633,14 +2124,6 @@ zfcp_fsf_close_port_handler(struct zfcp_
 	switch (fsf_req->qtcb->header.fsf_status) {
 
 	case FSF_PORT_HANDLE_NOT_VALID:
-		ZFCP_LOG_INFO("Temporary port identifier 0x%x for port "
-			      "0x%016Lx on adapter %s invalid. This may happen "
-			      "occasionally.\n", port->handle,
-			      port->wwpn, zfcp_get_busid_by_port(port));
-		ZFCP_LOG_DEBUG("status qualifier:\n");
-		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG,
-			      (char *) &fsf_req->qtcb->header.fsf_status_qual,
-			      sizeof (union fsf_status_qual));
 		zfcp_erp_adapter_reopen(port->adapter, 0, 107, fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
@@ -2653,20 +2136,11 @@ zfcp_fsf_close_port_handler(struct zfcp_
 		break;
 
 	case FSF_GOOD:
-		ZFCP_LOG_TRACE("remote port 0x016%Lx on adapter %s closed, "
-			       "port handle 0x%x\n", port->wwpn,
-			       zfcp_get_busid_by_port(port), port->handle);
 		zfcp_erp_modify_port_status(port, 33, fsf_req,
 					    ZFCP_STATUS_COMMON_OPEN,
 					    ZFCP_CLEAR);
 		retval = 0;
 		break;
-
-	default:
-		ZFCP_LOG_NORMAL("bug: An unknown FSF Status was presented "
-				"(debug info 0x%x)\n",
-				fsf_req->qtcb->header.fsf_status);
-		break;
 	}
 
  skip_fsfstatus:
@@ -2696,14 +2170,8 @@ zfcp_fsf_close_physical_port(struct zfcp
 				     ZFCP_WAIT_FOR_SBAL | ZFCP_REQ_AUTO_CLEANUP,
 				     erp_action->adapter->pool.fsf_req_erp,
 				     &lock_flags, &fsf_req);
-	if (retval < 0) {
-		ZFCP_LOG_INFO("error: Could not create close physical port "
-			      "request (adapter %s, port 0x%016Lx)\n",
-			      zfcp_get_busid_by_adapter(erp_action->adapter),
-			      erp_action->port->wwpn);
-
+	if (retval < 0)
 		goto out;
-	}
 
 	sbale = zfcp_qdio_sbale_req(fsf_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
@@ -2721,19 +2189,11 @@ zfcp_fsf_close_physical_port(struct zfcp
 	zfcp_erp_start_timer(fsf_req);
 	retval = zfcp_fsf_req_send(fsf_req);
 	if (retval) {
-		ZFCP_LOG_INFO("error: Could not send close physical port "
-			      "request (adapter %s, port 0x%016Lx)\n",
-			      zfcp_get_busid_by_adapter(erp_action->adapter),
-			      erp_action->port->wwpn);
 		zfcp_fsf_req_free(fsf_req);
 		erp_action->fsf_req = NULL;
 		goto out;
 	}
 
-	ZFCP_LOG_TRACE("close physical port request initiated "
-		       "(adapter %s, port 0x%016Lx)\n",
-		       zfcp_get_busid_by_adapter(erp_action->adapter),
-		       erp_action->port->wwpn);
  out:
 	write_unlock_irqrestore(&erp_action->adapter->req_q.lock, lock_flags);
 	return retval;
@@ -2753,7 +2213,6 @@ zfcp_fsf_close_physical_port_handler(str
 	struct zfcp_port *port;
 	struct zfcp_unit *unit;
 	struct fsf_qtcb_header *header;
-	u16 subtable, rule, counter;
 
 	port = (struct zfcp_port *) fsf_req->data;
 	header = &fsf_req->qtcb->header;
@@ -2767,47 +2226,15 @@ zfcp_fsf_close_physical_port_handler(str
 	switch (header->fsf_status) {
 
 	case FSF_PORT_HANDLE_NOT_VALID:
-		ZFCP_LOG_INFO("Temporary port identifier 0x%x invalid"
-			      "(adapter %s, port 0x%016Lx). "
-			      "This may happen occasionally.\n",
-			      port->handle,
-			      zfcp_get_busid_by_port(port),
-			      port->wwpn);
-		ZFCP_LOG_DEBUG("status qualifier:\n");
-		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG,
-			      (char *) &header->fsf_status_qual,
-			      sizeof (union fsf_status_qual));
 		zfcp_erp_adapter_reopen(port->adapter, 0, 108, fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
 	case FSF_ACCESS_DENIED:
-		ZFCP_LOG_NORMAL("Access denied, cannot close "
-				"physical port 0x%016Lx on adapter %s\n",
-				port->wwpn, zfcp_get_busid_by_port(port));
-		for (counter = 0; counter < 2; counter++) {
-			subtable = header->fsf_status_qual.halfword[counter * 2];
-			rule = header->fsf_status_qual.halfword[counter * 2 + 1];
-			switch (subtable) {
-			case FSF_SQ_CFDC_SUBTABLE_OS:
-			case FSF_SQ_CFDC_SUBTABLE_PORT_WWPN:
-			case FSF_SQ_CFDC_SUBTABLE_PORT_DID:
-			case FSF_SQ_CFDC_SUBTABLE_LUN:
-	       			ZFCP_LOG_INFO("Access denied (%s rule %d)\n",
-					zfcp_act_subtable_type[subtable], rule);
-				break;
-			}
-		}
-		zfcp_erp_port_access_denied(port, 58, fsf_req);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+		zfcp_fsf_access_denied_port(fsf_req, port);
 		break;
 
 	case FSF_PORT_BOXED:
-		ZFCP_LOG_DEBUG("The remote port 0x%016Lx on adapter "
-			       "%s needs to be reopened but it was attempted "
-			       "to close it physically.\n",
-			       port->wwpn,
-			       zfcp_get_busid_by_port(port));
 		zfcp_erp_port_boxed(port, 50, fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR |
 			ZFCP_STATUS_FSFREQ_RETRY;
@@ -2830,19 +2257,10 @@ zfcp_fsf_close_physical_port_handler(str
 			/* ERP strategy will escalate */
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
-		default:
-			ZFCP_LOG_NORMAL
-			    ("bug: Wrong status qualifier 0x%x arrived.\n",
-			     header->fsf_status_qual.word[0]);
-			break;
 		}
 		break;
 
 	case FSF_GOOD:
-		ZFCP_LOG_DEBUG("Remote port 0x%016Lx via adapter %s "
-			       "physically closed, port handle 0x%x\n",
-			       port->wwpn,
-			       zfcp_get_busid_by_port(port), port->handle);
 		/* can't use generic zfcp_erp_modify_port_status because
 		 * ZFCP_STATUS_COMMON_OPEN must not be reset for the port
 		 */
@@ -2851,12 +2269,6 @@ zfcp_fsf_close_physical_port_handler(str
 		    atomic_clear_mask(ZFCP_STATUS_COMMON_OPEN, &unit->status);
 		retval = 0;
 		break;
-
-	default:
-		ZFCP_LOG_NORMAL("bug: An unknown FSF Status was presented "
-				"(debug info 0x%x)\n",
-				header->fsf_status);
-		break;
 	}
 
  skip_fsfstatus:
@@ -2890,14 +2302,8 @@ zfcp_fsf_open_unit(struct zfcp_erp_actio
 				     ZFCP_WAIT_FOR_SBAL | ZFCP_REQ_AUTO_CLEANUP,
 				     erp_action->adapter->pool.fsf_req_erp,
 				     &lock_flags, &fsf_req);
-	if (retval < 0) {
-		ZFCP_LOG_INFO("error: Could not create open unit request for "
-			      "unit 0x%016Lx on port 0x%016Lx on adapter %s.\n",
-			      erp_action->unit->fcp_lun,
-			      erp_action->unit->port->wwpn,
-			      zfcp_get_busid_by_adapter(erp_action->adapter));
+	if (retval < 0)
 		goto out;
-	}
 
 	sbale = zfcp_qdio_sbale_req(fsf_req);
         sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
@@ -2916,21 +2322,10 @@ zfcp_fsf_open_unit(struct zfcp_erp_actio
 	zfcp_erp_start_timer(fsf_req);
 	retval = zfcp_fsf_req_send(erp_action->fsf_req);
 	if (retval) {
-		ZFCP_LOG_INFO("error: Could not send an open unit request "
-			      "on the adapter %s, port 0x%016Lx for "
-			      "unit 0x%016Lx\n",
-			      zfcp_get_busid_by_adapter(erp_action->adapter),
-			      erp_action->port->wwpn,
-			      erp_action->unit->fcp_lun);
 		zfcp_fsf_req_free(fsf_req);
 		erp_action->fsf_req = NULL;
 		goto out;
 	}
-
-	ZFCP_LOG_TRACE("Open LUN request initiated (adapter %s, "
-		       "port 0x%016Lx, unit 0x%016Lx)\n",
-		       zfcp_get_busid_by_adapter(erp_action->adapter),
-		       erp_action->port->wwpn, erp_action->unit->fcp_lun);
  out:
 	write_unlock_irqrestore(&erp_action->adapter->req_q.lock, lock_flags);
 	return retval;
@@ -2952,7 +2347,6 @@ zfcp_fsf_open_unit_handler(struct zfcp_f
 	struct fsf_qtcb_header *header;
 	struct fsf_qtcb_bottom_support *bottom;
 	struct fsf_queue_designator *queue_designator;
-	u16 subtable, rule, counter;
 	int exclusive, readwrite;
 
 	unit = (struct zfcp_unit *) fsf_req->data;
@@ -2977,55 +2371,21 @@ zfcp_fsf_open_unit_handler(struct zfcp_f
 	switch (header->fsf_status) {
 
 	case FSF_PORT_HANDLE_NOT_VALID:
-		ZFCP_LOG_INFO("Temporary port identifier 0x%x "
-			      "for port 0x%016Lx on adapter %s invalid "
-			      "This may happen occasionally\n",
-			      unit->port->handle,
-			      unit->port->wwpn, zfcp_get_busid_by_unit(unit));
-		ZFCP_LOG_DEBUG("status qualifier:\n");
-		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG,
-			      (char *) &header->fsf_status_qual,
-			      sizeof (union fsf_status_qual));
 		zfcp_erp_adapter_reopen(unit->port->adapter, 0, 109, fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
 	case FSF_LUN_ALREADY_OPEN:
-		ZFCP_LOG_NORMAL("bug: Attempted to open unit 0x%016Lx on "
-				"remote port 0x%016Lx on adapter %s twice.\n",
-				unit->fcp_lun,
-				unit->port->wwpn, zfcp_get_busid_by_unit(unit));
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
 	case FSF_ACCESS_DENIED:
-		ZFCP_LOG_NORMAL("Access denied, cannot open unit 0x%016Lx on "
-				"remote port 0x%016Lx on adapter %s\n",
-				unit->fcp_lun, unit->port->wwpn,
-				zfcp_get_busid_by_unit(unit));
-		for (counter = 0; counter < 2; counter++) {
-			subtable = header->fsf_status_qual.halfword[counter * 2];
-			rule = header->fsf_status_qual.halfword[counter * 2 + 1];
-			switch (subtable) {
-			case FSF_SQ_CFDC_SUBTABLE_OS:
-			case FSF_SQ_CFDC_SUBTABLE_PORT_WWPN:
-			case FSF_SQ_CFDC_SUBTABLE_PORT_DID:
-			case FSF_SQ_CFDC_SUBTABLE_LUN:
-				ZFCP_LOG_INFO("Access denied (%s rule %d)\n",
-					zfcp_act_subtable_type[subtable], rule);
-				break;
-			}
-		}
-		zfcp_erp_unit_access_denied(unit, 59, fsf_req);
+		zfcp_fsf_access_denied_unit(fsf_req, unit);
 		atomic_clear_mask(ZFCP_STATUS_UNIT_SHARED, &unit->status);
-                atomic_clear_mask(ZFCP_STATUS_UNIT_READONLY, &unit->status);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+		atomic_clear_mask(ZFCP_STATUS_UNIT_READONLY, &unit->status);
 		break;
 
 	case FSF_PORT_BOXED:
-		ZFCP_LOG_DEBUG("The remote port 0x%016Lx on adapter %s "
-			       "needs to be reopened\n",
-			       unit->port->wwpn, zfcp_get_busid_by_unit(unit));
 		zfcp_erp_port_boxed(unit->port, 51, fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR |
 			ZFCP_STATUS_FSFREQ_RETRY;
@@ -3033,39 +2393,18 @@ zfcp_fsf_open_unit_handler(struct zfcp_f
 
 	case FSF_LUN_SHARING_VIOLATION:
 		if (header->fsf_status_qual.word[0] != 0) {
-			ZFCP_LOG_NORMAL("FCP-LUN 0x%Lx at the remote port "
-					"with WWPN 0x%Lx "
-					"connected to the adapter %s "
-					"is already in use in LPAR%d, CSS%d\n",
-					unit->fcp_lun,
-					unit->port->wwpn,
-					zfcp_get_busid_by_unit(unit),
-					queue_designator->hla,
-					queue_designator->cssid);
-		} else {
-			subtable = header->fsf_status_qual.halfword[4];
-			rule = header->fsf_status_qual.halfword[5];
-			switch (subtable) {
-			case FSF_SQ_CFDC_SUBTABLE_OS:
-			case FSF_SQ_CFDC_SUBTABLE_PORT_WWPN:
-			case FSF_SQ_CFDC_SUBTABLE_PORT_DID:
-			case FSF_SQ_CFDC_SUBTABLE_LUN:
-				ZFCP_LOG_NORMAL("Access to FCP-LUN 0x%Lx at the "
-						"remote port with WWPN 0x%Lx "
-						"connected to the adapter %s "
-						"is denied (%s rule %d)\n",
-						unit->fcp_lun,
-						unit->port->wwpn,
-						zfcp_get_busid_by_unit(unit),
-						zfcp_act_subtable_type[subtable],
-						rule);
-				break;
-			}
-		}
-		ZFCP_LOG_DEBUG("status qualifier:\n");
-		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG,
-			      (char *) &header->fsf_status_qual,
-			      sizeof (union fsf_status_qual));
+			dev_warn(&adapter->ccw_device->dev,
+				 "FCP-LUN 0x%Lx at the remote port "
+				 "with WWPN 0x%Lx "
+				 "connected to the adapter "
+				 "is already in use in LPAR%d, CSS%d.\n",
+				 unit->fcp_lun,
+				 unit->port->wwpn,
+				 queue_designator->hla,
+				 queue_designator->cssid);
+		} else
+			zfcp_act_eval_err(adapter,
+					  header->fsf_status_qual.word[2]);
 		zfcp_erp_unit_access_denied(unit, 60, fsf_req);
 		atomic_clear_mask(ZFCP_STATUS_UNIT_SHARED, &unit->status);
 		atomic_clear_mask(ZFCP_STATUS_UNIT_READONLY, &unit->status);
@@ -3073,13 +2412,10 @@ zfcp_fsf_open_unit_handler(struct zfcp_f
 		break;
 
 	case FSF_MAXIMUM_NUMBER_OF_LUNS_EXCEEDED:
-		ZFCP_LOG_INFO("error: The adapter ran out of resources. "
-			      "There is no handle (temporary port identifier) "
-			      "available for unit 0x%016Lx on port 0x%016Lx "
-			      "on adapter %s\n",
-			      unit->fcp_lun,
-			      unit->port->wwpn,
-			      zfcp_get_busid_by_unit(unit));
+		dev_warn(&fsf_req->adapter->ccw_device->dev,
+			 "The adapter ran out of resources. There is no "
+			 "handle available for unit 0x%016Lx on port 0x%016Lx.",
+			 unit->fcp_lun, unit->port->wwpn);
 		zfcp_erp_unit_failed(unit, 34, fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
@@ -3095,19 +2431,10 @@ zfcp_fsf_open_unit_handler(struct zfcp_f
 			/* ERP strategy will escalate */
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
-		default:
-			ZFCP_LOG_NORMAL
-			    ("bug: Wrong status qualifier 0x%x arrived.\n",
-			     header->fsf_status_qual.word[0]);
 		}
 		break;
 
 	case FSF_INVALID_COMMAND_OPTION:
-		ZFCP_LOG_NORMAL(
-			"Invalid option 0x%x has been specified "
-			"in QTCB bottom sent to the adapter %s\n",
-			bottom->option,
-			zfcp_get_busid_by_adapter(adapter));
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		retval = -EINVAL;
 		break;
@@ -3115,12 +2442,6 @@ zfcp_fsf_open_unit_handler(struct zfcp_f
 	case FSF_GOOD:
 		/* save LUN handle assigned by FSF */
 		unit->handle = header->lun_handle;
-		ZFCP_LOG_TRACE("unit 0x%016Lx on remote port 0x%016Lx on "
-			       "adapter %s opened, port handle 0x%x\n",
-			       unit->fcp_lun,
-			       unit->port->wwpn,
-			       zfcp_get_busid_by_unit(unit),
-			       unit->handle);
 		/* mark unit as open */
 		atomic_set_mask(ZFCP_STATUS_COMMON_OPEN, &unit->status);
 
@@ -3139,23 +2460,27 @@ zfcp_fsf_open_unit_handler(struct zfcp_f
 			if (!readwrite) {
                 		atomic_set_mask(ZFCP_STATUS_UNIT_READONLY,
 						&unit->status);
-                		ZFCP_LOG_NORMAL("read-only access for unit "
-						"(adapter %s, wwpn=0x%016Lx, "
-						"fcp_lun=0x%016Lx)\n",
-						zfcp_get_busid_by_unit(unit),
-						unit->port->wwpn,
-						unit->fcp_lun);
+				dev_info(&fsf_req->adapter->ccw_device->dev,
+					 "Read-only access for unit 0x%016Lx "
+					 "on port 0x%016Lx.\n",
+					 unit->fcp_lun, unit->port->wwpn);
         		}
 
         		if (exclusive && !readwrite) {
-                		ZFCP_LOG_NORMAL("exclusive access of read-only "
-						"unit not supported\n");
+				dev_err(&fsf_req->adapter->ccw_device->dev,
+					"Exclusive access of read-only unit "
+					"0x%016Lx on port 0x%016Lx not "
+					"supported, disabling unit.\n",
+					unit->fcp_lun, unit->port->wwpn);
 				zfcp_erp_unit_failed(unit, 35, fsf_req);
 				fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 				zfcp_erp_unit_shutdown(unit, 0, 80, fsf_req);
         		} else if (!exclusive && readwrite) {
-                		ZFCP_LOG_NORMAL("shared access of read-write "
-						"unit not supported\n");
+				dev_err(&fsf_req->adapter->ccw_device->dev,
+					"Shared access of read-write unit "
+					"0x%016Lx on port 0x%016Lx not "
+					"supported, disabling unit.\n",
+					unit->fcp_lun, unit->port->wwpn);
 				zfcp_erp_unit_failed(unit, 36, fsf_req);
 				fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 				zfcp_erp_unit_shutdown(unit, 0, 81, fsf_req);
@@ -3164,12 +2489,6 @@ zfcp_fsf_open_unit_handler(struct zfcp_f
 
 		retval = 0;
 		break;
-
-	default:
-		ZFCP_LOG_NORMAL("bug: An unknown FSF Status was presented "
-				"(debug info 0x%x)\n",
-				header->fsf_status);
-		break;
 	}
 
  skip_fsfstatus:
@@ -3204,14 +2523,8 @@ zfcp_fsf_close_unit(struct zfcp_erp_acti
 				     ZFCP_WAIT_FOR_SBAL | ZFCP_REQ_AUTO_CLEANUP,
 				     erp_action->adapter->pool.fsf_req_erp,
 				     &lock_flags, &fsf_req);
-	if (retval < 0) {
-		ZFCP_LOG_INFO("error: Could not create close unit request for "
-			      "unit 0x%016Lx on port 0x%016Lx on adapter %s.\n",
-			      erp_action->unit->fcp_lun,
-			      erp_action->port->wwpn,
-			      zfcp_get_busid_by_adapter(erp_action->adapter));
+	if (retval < 0)
 		goto out;
-	}
 
 	sbale = zfcp_qdio_sbale_req(fsf_req);
         sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
@@ -3227,20 +2540,11 @@ zfcp_fsf_close_unit(struct zfcp_erp_acti
 	zfcp_erp_start_timer(fsf_req);
 	retval = zfcp_fsf_req_send(erp_action->fsf_req);
 	if (retval) {
-		ZFCP_LOG_INFO("error: Could not send a close unit request for "
-			      "unit 0x%016Lx on port 0x%016Lx onadapter %s.\n",
-			      erp_action->unit->fcp_lun,
-			      erp_action->port->wwpn,
-			      zfcp_get_busid_by_adapter(erp_action->adapter));
 		zfcp_fsf_req_free(fsf_req);
 		erp_action->fsf_req = NULL;
 		goto out;
 	}
 
-	ZFCP_LOG_TRACE("Close LUN request initiated (adapter %s, "
-		       "port 0x%016Lx, unit 0x%016Lx)\n",
-		       zfcp_get_busid_by_adapter(erp_action->adapter),
-		       erp_action->port->wwpn, erp_action->unit->fcp_lun);
  out:
 	write_unlock_irqrestore(&erp_action->adapter->req_q.lock, lock_flags);
 	return retval;
@@ -3270,41 +2574,16 @@ zfcp_fsf_close_unit_handler(struct zfcp_
 	switch (fsf_req->qtcb->header.fsf_status) {
 
 	case FSF_PORT_HANDLE_NOT_VALID:
-		ZFCP_LOG_INFO("Temporary port identifier 0x%x for port "
-			      "0x%016Lx on adapter %s invalid. This may "
-			      "happen in rare circumstances\n",
-			      unit->port->handle,
-			      unit->port->wwpn,
-			      zfcp_get_busid_by_unit(unit));
-		ZFCP_LOG_DEBUG("status qualifier:\n");
-		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG,
-			      (char *) &fsf_req->qtcb->header.fsf_status_qual,
-			      sizeof (union fsf_status_qual));
 		zfcp_erp_adapter_reopen(unit->port->adapter, 0, 110, fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
 	case FSF_LUN_HANDLE_NOT_VALID:
-		ZFCP_LOG_INFO("Temporary LUN identifier 0x%x of unit "
-			      "0x%016Lx on port 0x%016Lx on adapter %s is "
-			      "invalid. This may happen occasionally.\n",
-			      unit->handle,
-			      unit->fcp_lun,
-			      unit->port->wwpn,
-			      zfcp_get_busid_by_unit(unit));
-		ZFCP_LOG_DEBUG("Status qualifier data:\n");
-		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG,
-			      (char *) &fsf_req->qtcb->header.fsf_status_qual,
-			      sizeof (union fsf_status_qual));
 		zfcp_erp_port_reopen(unit->port, 0, 111, fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
 	case FSF_PORT_BOXED:
-		ZFCP_LOG_DEBUG("The remote port 0x%016Lx on adapter %s "
-			       "needs to be reopened\n",
-			       unit->port->wwpn,
-			       zfcp_get_busid_by_unit(unit));
 		zfcp_erp_port_boxed(unit->port, 52, fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR |
 			ZFCP_STATUS_FSFREQ_RETRY;
@@ -3322,30 +2601,15 @@ zfcp_fsf_close_unit_handler(struct zfcp_
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		default:
-			ZFCP_LOG_NORMAL
-			    ("bug: Wrong status qualifier 0x%x arrived.\n",
-			     fsf_req->qtcb->header.fsf_status_qual.word[0]);
 			break;
 		}
 		break;
 
 	case FSF_GOOD:
-		ZFCP_LOG_TRACE("unit 0x%016Lx on port 0x%016Lx on adapter %s "
-			       "closed, port handle 0x%x\n",
-			       unit->fcp_lun,
-			       unit->port->wwpn,
-			       zfcp_get_busid_by_unit(unit),
-			       unit->handle);
 		/* mark unit as closed */
 		atomic_clear_mask(ZFCP_STATUS_COMMON_OPEN, &unit->status);
 		retval = 0;
 		break;
-
-	default:
-		ZFCP_LOG_NORMAL("bug: An unknown FSF Status was presented "
-				"(debug info 0x%x)\n",
-				fsf_req->qtcb->header.fsf_status);
-		break;
 	}
 
  skip_fsfstatus:
@@ -3379,15 +2643,8 @@ zfcp_fsf_send_fcp_command_task(struct zf
 	retval = zfcp_fsf_req_create(adapter, FSF_QTCB_FCP_CMND, req_flags,
 				     adapter->pool.fsf_req_scsi,
 				     &lock_flags, &fsf_req);
-	if (unlikely(retval < 0)) {
-		ZFCP_LOG_DEBUG("error: Could not create FCP command request "
-			       "for unit 0x%016Lx on port 0x%016Lx on "
-			       "adapter %s\n",
-			       unit->fcp_lun,
-			       unit->port->wwpn,
-			       zfcp_get_busid_by_adapter(adapter));
+	if (unlikely(retval < 0))
 		goto failed_req_create;
-	}
 
 	if (unlikely(!atomic_test_mask(ZFCP_STATUS_COMMON_UNBLOCKED,
 			&unit->status))) {
@@ -3463,15 +2720,9 @@ zfcp_fsf_send_fcp_command_task(struct zf
 		fcp_cmnd_iu->task_attribute = UNTAGGED;
 
 	/* set additional length of FCP_CDB in FCP_CMND IU in QTCB, if needed */
-	if (unlikely(scsi_cmnd->cmd_len > FCP_CDB_LENGTH)) {
+	if (unlikely(scsi_cmnd->cmd_len > FCP_CDB_LENGTH))
 		fcp_cmnd_iu->add_fcp_cdb_length
 		    = (scsi_cmnd->cmd_len - FCP_CDB_LENGTH) >> 2;
-		ZFCP_LOG_TRACE("SCSI CDB length is 0x%x, "
-			       "additional FCP_CDB length is 0x%x "
-			       "(shifted right 2 bits)\n",
-			       scsi_cmnd->cmd_len,
-			       fcp_cmnd_iu->add_fcp_cdb_length);
-	}
 	/*
 	 * copy SCSI CDB (including additional length, if any) to
 	 * FCP_CDB in FCP_CMND IU in QTCB
@@ -3488,19 +2739,14 @@ zfcp_fsf_send_fcp_command_task(struct zf
 					     scsi_sglist(scsi_cmnd),
 					     ZFCP_MAX_SBALS_PER_REQ);
 	if (unlikely(real_bytes < 0)) {
-		if (fsf_req->sbal_number < ZFCP_MAX_SBALS_PER_REQ) {
-			ZFCP_LOG_DEBUG(
-				"Data did not fit into available buffer(s), "
-			       "waiting for more...\n");
+		if (fsf_req->sbal_number < ZFCP_MAX_SBALS_PER_REQ)
 			retval = -EIO;
-		} else {
-			ZFCP_LOG_NORMAL("error: No truncation implemented but "
-					"required. Shutting down unit "
-					"(adapter %s, port 0x%016Lx, "
-					"unit 0x%016Lx)\n",
-					zfcp_get_busid_by_unit(unit),
-					unit->port->wwpn,
-					unit->fcp_lun);
+		else {
+			dev_err(&adapter->ccw_device->dev,
+				"SCSI request too large. "
+				"Shutting down unit 0x%016Lx on port "
+				"0x%016Lx.\n", unit->fcp_lun,
+				unit->port->wwpn);
 			zfcp_erp_unit_shutdown(unit, 0, 131, fsf_req);
 			retval = -EINVAL;
 		}
@@ -3510,28 +2756,13 @@ zfcp_fsf_send_fcp_command_task(struct zf
 	/* set length of FCP data length in FCP_CMND IU in QTCB */
 	zfcp_set_fcp_dl(fcp_cmnd_iu, real_bytes);
 
-	ZFCP_LOG_DEBUG("Sending SCSI command:\n");
-	ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG,
-		      (char *) scsi_cmnd->cmnd, scsi_cmnd->cmd_len);
-
 	if (use_timer)
 		zfcp_fsf_start_timer(fsf_req, ZFCP_FSF_REQUEST_TIMEOUT);
 
 	retval = zfcp_fsf_req_send(fsf_req);
-	if (unlikely(retval < 0)) {
-		ZFCP_LOG_INFO("error: Could not send FCP command request "
-			      "on adapter %s, port 0x%016Lx, unit 0x%016Lx\n",
-			      zfcp_get_busid_by_adapter(adapter),
-			      unit->port->wwpn,
-			      unit->fcp_lun);
+	if (unlikely(retval < 0))
 		goto send_failed;
-	}
 
-	ZFCP_LOG_TRACE("Send FCP Command initiated (adapter %s, "
-		       "port 0x%016Lx, unit 0x%016Lx)\n",
-		       zfcp_get_busid_by_adapter(adapter),
-		       unit->port->wwpn,
-		       unit->fcp_lun);
 	goto success;
 
  send_failed:
@@ -3563,14 +2794,8 @@ zfcp_fsf_send_fcp_command_task_managemen
 	retval = zfcp_fsf_req_create(adapter, FSF_QTCB_FCP_CMND, req_flags,
 				     adapter->pool.fsf_req_scsi,
 				     &lock_flags, &fsf_req);
-	if (retval < 0) {
-		ZFCP_LOG_INFO("error: Could not create FCP command (task "
-			      "management) request for adapter %s, port "
-			      " 0x%016Lx, unit 0x%016Lx.\n",
-			      zfcp_get_busid_by_adapter(adapter),
-			      unit->port->wwpn, unit->fcp_lun);
+	if (retval < 0)
 		goto out;
-	}
 
 	if (unlikely(!atomic_test_mask(ZFCP_STATUS_COMMON_UNBLOCKED,
 			&unit->status)))
@@ -3674,7 +2899,6 @@ zfcp_fsf_send_fcp_command_handler(struct
 	int retval = -EINVAL;
 	struct zfcp_unit *unit;
 	struct fsf_qtcb_header *header;
-	u16 subtable, rule, counter;
 
 	header = &fsf_req->qtcb->header;
 
@@ -3692,137 +2916,61 @@ zfcp_fsf_send_fcp_command_handler(struct
 	switch (header->fsf_status) {
 
 	case FSF_PORT_HANDLE_NOT_VALID:
-		ZFCP_LOG_INFO("Temporary port identifier 0x%x for port "
-			      "0x%016Lx on adapter %s invalid\n",
-			      unit->port->handle,
-			      unit->port->wwpn, zfcp_get_busid_by_unit(unit));
-		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG,
-			      (char *) &header->fsf_status_qual,
-			      sizeof (union fsf_status_qual));
 		zfcp_erp_adapter_reopen(unit->port->adapter, 0, 112, fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
 	case FSF_LUN_HANDLE_NOT_VALID:
-		ZFCP_LOG_INFO("Temporary LUN identifier 0x%x for unit "
-			      "0x%016Lx on port 0x%016Lx on adapter %s is "
-			      "invalid. This may happen occasionally.\n",
-			      unit->handle,
-			      unit->fcp_lun,
-			      unit->port->wwpn,
-			      zfcp_get_busid_by_unit(unit));
-		ZFCP_LOG_NORMAL("Status qualifier data:\n");
-		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_NORMAL,
-			      (char *) &header->fsf_status_qual,
-			      sizeof (union fsf_status_qual));
 		zfcp_erp_port_reopen(unit->port, 0, 113, fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
 	case FSF_HANDLE_MISMATCH:
-		ZFCP_LOG_NORMAL("bug: The port handle 0x%x has changed "
-				"unexpectedly. (adapter %s, port 0x%016Lx, "
-				"unit 0x%016Lx)\n",
-				unit->port->handle,
-				zfcp_get_busid_by_unit(unit),
-				unit->port->wwpn,
-				unit->fcp_lun);
-		ZFCP_LOG_NORMAL("status qualifier:\n");
-		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_NORMAL,
-			      (char *) &header->fsf_status_qual,
-			      sizeof (union fsf_status_qual));
 		zfcp_erp_adapter_reopen(unit->port->adapter, 0, 114, fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
 	case FSF_SERVICE_CLASS_NOT_SUPPORTED:
-		ZFCP_LOG_INFO("error: adapter %s does not support fc "
-			      "class %d.\n",
-			      zfcp_get_busid_by_unit(unit),
-			      ZFCP_FC_SERVICE_CLASS_DEFAULT);
-		/* stop operation for this adapter */
-		zfcp_erp_adapter_shutdown(unit->port->adapter, 0, 132, fsf_req);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+		zfcp_fsf_class_not_supp(fsf_req);
 		break;
 
 	case FSF_FCPLUN_NOT_VALID:
-		ZFCP_LOG_NORMAL("bug: unit 0x%016Lx on port 0x%016Lx on "
-				"adapter %s does not have correct unit "
-				"handle 0x%x\n",
-				unit->fcp_lun,
-				unit->port->wwpn,
-				zfcp_get_busid_by_unit(unit),
-				unit->handle);
-		ZFCP_LOG_DEBUG("status qualifier:\n");
-		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG,
-			      (char *) &header->fsf_status_qual,
-			      sizeof (union fsf_status_qual));
 		zfcp_erp_port_reopen(unit->port, 0, 115, fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
 	case FSF_ACCESS_DENIED:
-		ZFCP_LOG_NORMAL("Access denied, cannot send FCP command to "
-				"unit 0x%016Lx on port 0x%016Lx on "
-				"adapter %s\n",	unit->fcp_lun, unit->port->wwpn,
-				zfcp_get_busid_by_unit(unit));
-		for (counter = 0; counter < 2; counter++) {
-			subtable = header->fsf_status_qual.halfword[counter * 2];
-			rule = header->fsf_status_qual.halfword[counter * 2 + 1];
-			switch (subtable) {
-			case FSF_SQ_CFDC_SUBTABLE_OS:
-			case FSF_SQ_CFDC_SUBTABLE_PORT_WWPN:
-			case FSF_SQ_CFDC_SUBTABLE_PORT_DID:
-			case FSF_SQ_CFDC_SUBTABLE_LUN:
-				ZFCP_LOG_INFO("Access denied (%s rule %d)\n",
-					zfcp_act_subtable_type[subtable], rule);
-				break;
-			}
-		}
-		zfcp_erp_unit_access_denied(unit, 61, fsf_req);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+		zfcp_fsf_access_denied_unit(fsf_req, unit);
 		break;
 
 	case FSF_DIRECTION_INDICATOR_NOT_VALID:
-		ZFCP_LOG_INFO("bug: Invalid data direction given for unit "
-			      "0x%016Lx on port 0x%016Lx on adapter %s "
-			      "(debug info %d)\n",
-			      unit->fcp_lun,
-			      unit->port->wwpn,
-			      zfcp_get_busid_by_unit(unit),
-			      fsf_req->qtcb->bottom.io.data_direction);
-		/* stop operation for this adapter */
+		dev_err(&fsf_req->adapter->ccw_device->dev,
+			"Invalid data direction (%d) given for unit 0x%016Lx "
+			"on port 0x%016Lx, shutting down adapter.\n",
+			fsf_req->qtcb->bottom.io.data_direction,
+			unit->fcp_lun, unit->port->wwpn);
 		zfcp_erp_adapter_shutdown(unit->port->adapter, 0, 133, fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
 	case FSF_CMND_LENGTH_NOT_VALID:
-		ZFCP_LOG_NORMAL
-		    ("bug: An invalid control-data-block length field "
-		     "was found in a command for unit 0x%016Lx on port "
-		     "0x%016Lx on adapter %s " "(debug info %d)\n",
-		     unit->fcp_lun, unit->port->wwpn,
-		     zfcp_get_busid_by_unit(unit),
-		     fsf_req->qtcb->bottom.io.fcp_cmnd_length);
-		/* stop operation for this adapter */
+		dev_err(&fsf_req->adapter->ccw_device->dev,
+			"An invalid control-data-block length field (%d) "
+			"was found in a command for unit 0x%016Lx on port "
+			"0x%016Lx. Shutting down adapter.\n",
+			fsf_req->qtcb->bottom.io.fcp_cmnd_length,
+			unit->fcp_lun, unit->port->wwpn);
 		zfcp_erp_adapter_shutdown(unit->port->adapter, 0, 134, fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
 	case FSF_PORT_BOXED:
-		ZFCP_LOG_DEBUG("The remote port 0x%016Lx on adapter %s "
-			       "needs to be reopened\n",
-			       unit->port->wwpn, zfcp_get_busid_by_unit(unit));
 		zfcp_erp_port_boxed(unit->port, 53, fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR |
 			ZFCP_STATUS_FSFREQ_RETRY;
 		break;
 
 	case FSF_LUN_BOXED:
-		ZFCP_LOG_NORMAL("unit needs to be reopened (adapter %s, "
-				"wwpn=0x%016Lx, fcp_lun=0x%016Lx)\n",
-				zfcp_get_busid_by_unit(unit),
-				unit->port->wwpn, unit->fcp_lun);
 		zfcp_erp_unit_boxed(unit, 54, fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR
 			| ZFCP_STATUS_FSFREQ_RETRY;
@@ -3838,11 +2986,6 @@ zfcp_fsf_send_fcp_command_handler(struct
 			/* FIXME(hw) need proper specs for proper action */
 			/* let scsi stack deal with retries and escalation */
 			break;
-		default:
-			ZFCP_LOG_NORMAL
- 			    ("Unknown status qualifier 0x%x arrived.\n",
-			     header->fsf_status_qual.word[0]);
-			break;
 		}
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
@@ -3880,34 +3023,26 @@ zfcp_fsf_send_fcp_command_task_handler(s
 	struct scsi_cmnd *scpnt;
 	struct fcp_rsp_iu *fcp_rsp_iu = (struct fcp_rsp_iu *)
 	    &(fsf_req->qtcb->bottom.io.fcp_rsp);
-	struct fcp_cmnd_iu *fcp_cmnd_iu = (struct fcp_cmnd_iu *)
-	    &(fsf_req->qtcb->bottom.io.fcp_cmnd);
 	u32 sns_len;
 	char *fcp_rsp_info = zfcp_get_fcp_rsp_info_ptr(fcp_rsp_iu);
 	unsigned long flags;
-	struct zfcp_unit *unit = fsf_req->unit;
 
 	read_lock_irqsave(&fsf_req->adapter->abort_lock, flags);
 	scpnt = (struct scsi_cmnd *) fsf_req->data;
-	if (unlikely(!scpnt)) {
-		ZFCP_LOG_DEBUG
-		    ("Command with fsf_req %p is not associated to "
-		     "a scsi command anymore. Aborted?\n", fsf_req);
+	if (unlikely(!scpnt))
 		goto out;
-	}
+
 	if (unlikely(fsf_req->status & ZFCP_STATUS_FSFREQ_ABORTED)) {
 		/* FIXME: (design) mid-layer should handle DID_ABORT like
 		 *        DID_SOFT_ERROR by retrying the request for devices
 		 *        that allow retries.
 		 */
-		ZFCP_LOG_DEBUG("Setting DID_SOFT_ERROR and SUGGEST_RETRY\n");
 		set_host_byte(&scpnt->result, DID_SOFT_ERROR);
 		set_driver_byte(&scpnt->result, SUGGEST_RETRY);
 		goto skip_fsfstatus;
 	}
 
 	if (unlikely(fsf_req->status & ZFCP_STATUS_FSFREQ_ERROR)) {
-		ZFCP_LOG_DEBUG("Setting DID_ERROR\n");
 		set_host_byte(&scpnt->result, DID_ERROR);
 		goto skip_fsfstatus;
 	}
@@ -3920,97 +3055,31 @@ zfcp_fsf_send_fcp_command_task_handler(s
 	 * of result in SCSI command
 	 */
 	scpnt->result |= fcp_rsp_iu->scsi_status;
-	if (unlikely(fcp_rsp_iu->scsi_status)) {
-		/* DEBUG */
-		ZFCP_LOG_DEBUG("status for SCSI Command:\n");
-		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG,
-			      scpnt->cmnd, scpnt->cmd_len);
-		ZFCP_LOG_DEBUG("SCSI status code 0x%x\n",
-				fcp_rsp_iu->scsi_status);
-		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG,
-			      (void *) fcp_rsp_iu, sizeof (struct fcp_rsp_iu));
-		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG,
-			      zfcp_get_fcp_sns_info_ptr(fcp_rsp_iu),
-			      fcp_rsp_iu->fcp_sns_len);
-	}
 
 	if (fsf_req->adapter->adapter_features & FSF_FEATURE_MEASUREMENT_DATA)
 		zfcp_fsf_req_latency(fsf_req);
 
 	/* check FCP_RSP_INFO */
 	if (unlikely(fcp_rsp_iu->validity.bits.fcp_rsp_len_valid)) {
-		ZFCP_LOG_DEBUG("rsp_len is valid\n");
 		switch (fcp_rsp_info[3]) {
 		case RSP_CODE_GOOD:
 			/* ok, continue */
-			ZFCP_LOG_TRACE("no failure or Task Management "
-				       "Function complete\n");
 			set_host_byte(&scpnt->result, DID_OK);
 			break;
 		case RSP_CODE_LENGTH_MISMATCH:
 			/* hardware bug */
-			ZFCP_LOG_NORMAL("bug: FCP response code indictates "
-					"that the fibrechannel protocol data "
-					"length differs from the burst length. "
-					"The problem occured on unit 0x%016Lx "
-					"on port 0x%016Lx on adapter %s",
-					unit->fcp_lun,
-					unit->port->wwpn,
-					zfcp_get_busid_by_unit(unit));
-			/* dump SCSI CDB as prepared by zfcp */
-			ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG,
-				      (char *) &fsf_req->qtcb->
-				      bottom.io.fcp_cmnd, FSF_FCP_CMND_SIZE);
 			set_host_byte(&scpnt->result, DID_ERROR);
 			goto skip_fsfstatus;
 		case RSP_CODE_FIELD_INVALID:
 			/* driver or hardware bug */
-			ZFCP_LOG_NORMAL("bug: FCP response code indictates "
-					"that the fibrechannel protocol data "
-					"fields were incorrectly set up. "
-					"The problem occured on the unit "
-					"0x%016Lx on port 0x%016Lx on "
-					"adapter %s",
-					unit->fcp_lun,
-					unit->port->wwpn,
-					zfcp_get_busid_by_unit(unit));
-			/* dump SCSI CDB as prepared by zfcp */
-			ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG,
-				      (char *) &fsf_req->qtcb->
-				      bottom.io.fcp_cmnd, FSF_FCP_CMND_SIZE);
 			set_host_byte(&scpnt->result, DID_ERROR);
 			goto skip_fsfstatus;
 		case RSP_CODE_RO_MISMATCH:
 			/* hardware bug */
-			ZFCP_LOG_NORMAL("bug: The FCP response code indicates "
-					"that conflicting  values for the "
-					"fibrechannel payload offset from the "
-					"header were found. "
-					"The problem occured on unit 0x%016Lx "
-					"on port 0x%016Lx on adapter %s.\n",
-					unit->fcp_lun,
-					unit->port->wwpn,
-					zfcp_get_busid_by_unit(unit));
-			/* dump SCSI CDB as prepared by zfcp */
-			ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG,
-				      (char *) &fsf_req->qtcb->
-				      bottom.io.fcp_cmnd, FSF_FCP_CMND_SIZE);
 			set_host_byte(&scpnt->result, DID_ERROR);
 			goto skip_fsfstatus;
 		default:
-			ZFCP_LOG_NORMAL("bug: An invalid FCP response "
-					"code was detected for a command. "
-					"The problem occured on the unit "
-					"0x%016Lx on port 0x%016Lx on "
-					"adapter %s (debug info 0x%x)\n",
-					unit->fcp_lun,
-					unit->port->wwpn,
-					zfcp_get_busid_by_unit(unit),
-					fcp_rsp_info[3]);
-			/* dump SCSI CDB as prepared by zfcp */
-			ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG,
-				      (char *) &fsf_req->qtcb->
-				      bottom.io.fcp_cmnd, FSF_FCP_CMND_SIZE);
+			/* invalid FCP response code */
 			set_host_byte(&scpnt->result, DID_ERROR);
 			goto skip_fsfstatus;
 		}
@@ -4020,50 +3089,15 @@ zfcp_fsf_send_fcp_command_task_handler(s
 	if (unlikely(fcp_rsp_iu->validity.bits.fcp_sns_len_valid)) {
 		sns_len = FSF_FCP_RSP_SIZE -
 		    sizeof (struct fcp_rsp_iu) + fcp_rsp_iu->fcp_rsp_len;
-		ZFCP_LOG_TRACE("room for %i bytes sense data in QTCB\n",
-			       sns_len);
 		sns_len = min(sns_len, (u32) SCSI_SENSE_BUFFERSIZE);
-		ZFCP_LOG_TRACE("room for %i bytes sense data in SCSI command\n",
-			       SCSI_SENSE_BUFFERSIZE);
 		sns_len = min(sns_len, fcp_rsp_iu->fcp_sns_len);
-		ZFCP_LOG_TRACE("scpnt->result =0x%x, command was:\n",
-			       scpnt->result);
-		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_TRACE,
-			      scpnt->cmnd, scpnt->cmd_len);
 
-		ZFCP_LOG_TRACE("%i bytes sense data provided by FCP\n",
-			       fcp_rsp_iu->fcp_sns_len);
 		memcpy(scpnt->sense_buffer,
 		       zfcp_get_fcp_sns_info_ptr(fcp_rsp_iu), sns_len);
-		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_TRACE,
-			      (void *)scpnt->sense_buffer, sns_len);
-	}
-
-	/* check for overrun */
-	if (unlikely(fcp_rsp_iu->validity.bits.fcp_resid_over)) {
-		ZFCP_LOG_INFO("A data overrun was detected for a command. "
-			      "unit 0x%016Lx, port 0x%016Lx, adapter %s. "
-			      "The response data length is "
-			      "%d, the original length was %d.\n",
-			      unit->fcp_lun,
-			      unit->port->wwpn,
-			      zfcp_get_busid_by_unit(unit),
-			      fcp_rsp_iu->fcp_resid,
-			      (int) zfcp_get_fcp_dl(fcp_cmnd_iu));
 	}
 
 	/* check for underrun */
 	if (unlikely(fcp_rsp_iu->validity.bits.fcp_resid_under)) {
-		ZFCP_LOG_INFO("A data underrun was detected for a command. "
-			      "unit 0x%016Lx, port 0x%016Lx, adapter %s. "
-			      "The response data length is "
-			      "%d, the original length was %d.\n",
-			      unit->fcp_lun,
-			      unit->port->wwpn,
-			      zfcp_get_busid_by_unit(unit),
-			      fcp_rsp_iu->fcp_resid,
-			      (int) zfcp_get_fcp_dl(fcp_cmnd_iu));
-
 		scsi_set_resid(scpnt, fcp_rsp_iu->fcp_resid);
 		if (scsi_bufflen(scpnt) - scsi_get_resid(scpnt) <
 		    scpnt->underflow)
@@ -4071,8 +3105,6 @@ zfcp_fsf_send_fcp_command_task_handler(s
 	}
 
  skip_fsfstatus:
-	ZFCP_LOG_DEBUG("scpnt->result =0x%x\n", scpnt->result);
-
 	if (scpnt->result != 0)
 		zfcp_scsi_dbf_event_result("erro", 3, fsf_req->adapter, scpnt, fsf_req);
 	else if (scpnt->retries > 0)
@@ -4111,7 +3143,6 @@ zfcp_fsf_send_fcp_command_task_managemen
 	struct fcp_rsp_iu *fcp_rsp_iu = (struct fcp_rsp_iu *)
 	    &(fsf_req->qtcb->bottom.io.fcp_rsp);
 	char *fcp_rsp_info = zfcp_get_fcp_rsp_info_ptr(fcp_rsp_iu);
-	struct zfcp_unit *unit = (struct zfcp_unit *) fsf_req->data;
 
 	if (fsf_req->status & ZFCP_STATUS_FSFREQ_ERROR) {
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_TMFUNCFAILED;
@@ -4122,36 +3153,15 @@ zfcp_fsf_send_fcp_command_task_managemen
 	switch (fcp_rsp_info[3]) {
 	case RSP_CODE_GOOD:
 		/* ok, continue */
-		ZFCP_LOG_DEBUG("no failure or Task Management "
-			       "Function complete\n");
 		break;
 	case RSP_CODE_TASKMAN_UNSUPP:
-		ZFCP_LOG_NORMAL("bug: A reuested task management function "
-				"is not supported on the target device "
-				"unit 0x%016Lx, port 0x%016Lx, adapter %s\n ",
-				unit->fcp_lun,
-				unit->port->wwpn,
-				zfcp_get_busid_by_unit(unit));
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_TMFUNCNOTSUPP;
 		break;
 	case RSP_CODE_TASKMAN_FAILED:
-		ZFCP_LOG_NORMAL("bug: A reuested task management function "
-				"failed to complete successfully. "
-				"unit 0x%016Lx, port 0x%016Lx, adapter %s.\n",
-				unit->fcp_lun,
-				unit->port->wwpn,
-				zfcp_get_busid_by_unit(unit));
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_TMFUNCFAILED;
 		break;
 	default:
-		ZFCP_LOG_NORMAL("bug: An invalid FCP response "
-				"code was detected for a command. "
-				"unit 0x%016Lx, port 0x%016Lx, adapter %s "
-				"(debug info 0x%x)\n",
-				unit->fcp_lun,
-				unit->port->wwpn,
-				zfcp_get_busid_by_unit(unit),
-				fcp_rsp_info[3]);
+		/* invalid FCP response code */
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_TMFUNCFAILED;
 	}
 
@@ -4332,9 +3342,7 @@ zfcp_fsf_req_create(struct zfcp_adapter 
 
 	/* allocate new FSF request */
 	fsf_req = zfcp_fsf_req_alloc(pool, req_flags);
-	if (unlikely(NULL == fsf_req)) {
-		ZFCP_LOG_DEBUG("error: Could not put an FSF request into "
-			       "the outbound (send) queue.\n");
+	if (unlikely(!fsf_req)) {
 		ret = -ENOMEM;
 		goto failed_fsf_req;
 	}
@@ -4393,9 +3401,6 @@ zfcp_fsf_req_create(struct zfcp_adapter 
 		sbale[1].length = sizeof(struct fsf_qtcb);
 	}
 
-	ZFCP_LOG_TRACE("got %i free BUFFERs starting at index %i\n",
-                       fsf_req->sbal_number, fsf_req->sbal_first);
-
 	goto success;
 
  failed_sbals:
@@ -4429,13 +3434,7 @@ static int zfcp_fsf_req_send(struct zfcp
 	adapter = fsf_req->adapter;
 	req_q = &adapter->req_q;
 
-
-	/* FIXME(debug): remove it later */
 	sbale = zfcp_qdio_sbale_req(fsf_req);
-	ZFCP_LOG_DEBUG("SBALE0 flags=0x%x\n", sbale[0].flags);
-	ZFCP_LOG_TRACE("HEX DUMP OF SBALE1 PAYLOAD:\n");
-	ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_TRACE, (char *) sbale[1].addr,
-		      sbale[1].length);
 
 	/* put allocated FSF request into hash table */
 	spin_lock(&adapter->req_list_lock);
@@ -4476,5 +3475,3 @@ static int zfcp_fsf_req_send(struct zfcp
 	}
 	return retval;
 }
-
-#undef ZFCP_LOG_AREA
--- a/drivers/s390/scsi/zfcp_fsf.h	2008-06-10 17:36:57.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.h	2008-06-10 17:41:27.000000000 +0200
@@ -1,22 +1,9 @@
 /*
- * This file is part of the zfcp device driver for
- * FCP adapters for IBM System z9 and zSeries.
+ * zfcp device driver
  *
- * (C) Copyright IBM Corp. 2002, 2006
+ * Interface to the FSF support functions.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ * Copyright IBM Corporation 2002, 2008
  */
 
 #ifndef FSF_H
@@ -342,6 +329,7 @@ struct fsf_qual_latency_info {
 } __attribute__ ((packed));
 
 union fsf_prot_status_qual {
+	u32 word[FSF_PROT_STATUS_QUAL_SIZE / sizeof(u32)];
 	u64 doubleword[FSF_PROT_STATUS_QUAL_SIZE / sizeof(u64)];
 	struct fsf_qual_version_error   version_error;
 	struct fsf_qual_sequence_error  sequence_error;
--- a/drivers/s390/scsi/zfcp_scsi.c	2008-06-10 17:35:44.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_scsi.c	2008-06-10 17:41:27.000000000 +0200
@@ -1,26 +1,11 @@
 /*
- * This file is part of the zfcp device driver for
- * FCP adapters for IBM System z9 and zSeries.
+ * zfcp device driver
  *
- * (C) Copyright IBM Corp. 2002, 2006
+ * Interface to Linux SCSI midlayer.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ * Copyright IBM Corporation 2002, 2008
  */
 
-#define ZFCP_LOG_AREA			ZFCP_LOG_AREA_SCSI
-
 #include "zfcp_ext.h"
 #include <asm/atomic.h>
 
@@ -44,7 +29,7 @@ static struct device_attribute *zfcp_a_s
 
 struct zfcp_data zfcp_data = {
 	.scsi_host_template = {
-		.name			= ZFCP_NAME,
+		.name			= "zfcp",
 		.module			= THIS_MODULE,
 		.proc_name		= "zfcp",
 		.slave_alloc		= zfcp_scsi_slave_alloc,
@@ -64,7 +49,6 @@ struct zfcp_data zfcp_data = {
 		.max_sectors		= ZFCP_MAX_SECTORS,
 		.shost_attrs		= zfcp_a_stats_attrs,
 	},
-	.driver_version = ZFCP_VERSION,
 };
 
 /* Find start of Response Information in FCP response unit*/
@@ -181,16 +165,14 @@ zfcp_scsi_slave_alloc(struct scsi_device
 static void zfcp_scsi_slave_destroy(struct scsi_device *sdpnt)
 {
 	struct zfcp_unit *unit = (struct zfcp_unit *) sdpnt->hostdata;
-
+	WARN_ON(!unit);
 	if (unit) {
 		atomic_clear_mask(ZFCP_STATUS_UNIT_REGISTERED, &unit->status);
 		sdpnt->hostdata = NULL;
 		unit->device = NULL;
 		zfcp_erp_unit_failed(unit, 12, NULL);
 		zfcp_unit_put(unit);
-	} else
-		ZFCP_LOG_NORMAL("bug: no unit associated with SCSI device at "
-				"address %p\n", sdpnt);
+	}
 }
 
 /*
@@ -253,10 +235,6 @@ zfcp_scsi_command_async(struct zfcp_adap
 	if (unlikely(
 	      atomic_test_mask(ZFCP_STATUS_COMMON_ERP_FAILED, &unit->status) ||
 	     !atomic_test_mask(ZFCP_STATUS_COMMON_RUNNING, &unit->status))) {
-		ZFCP_LOG_DEBUG("stopping SCSI I/O on unit 0x%016Lx on port "
-			       "0x%016Lx on adapter %s\n",
-			       unit->fcp_lun, unit->port->wwpn,
-			       zfcp_get_busid_by_adapter(adapter));
 		zfcp_scsi_command_fail(scpnt, DID_ERROR);
 		goto out;
 	}
@@ -264,18 +242,12 @@ zfcp_scsi_command_async(struct zfcp_adap
 	tmp = zfcp_fsf_send_fcp_command_task(adapter, unit, scpnt, use_timer,
 					     ZFCP_REQ_AUTO_CLEANUP);
 	if (unlikely(tmp == -EBUSY)) {
-		ZFCP_LOG_DEBUG("adapter %s not ready or unit 0x%016Lx "
-			       "on port 0x%016Lx in recovery\n",
-			       zfcp_get_busid_by_unit(unit),
-			       unit->fcp_lun, unit->port->wwpn);
 		zfcp_scsi_command_fail(scpnt, DID_NO_CONNECT);
 		goto out;
 	}
 
-	if (unlikely(tmp < 0)) {
-		ZFCP_LOG_DEBUG("error: initiation of Send FCP Cmnd failed\n");
+	if (unlikely(tmp < 0))
 		retval = SCSI_MLQUEUE_HOST_BUSY;
-	}
 
 out:
 	return retval;
@@ -394,9 +366,6 @@ static int zfcp_scsi_eh_abort_handler(st
 	adapter = (struct zfcp_adapter *) scsi_host->hostdata[0];
 	unit = (struct zfcp_unit *) scpnt->device->hostdata;
 
-	ZFCP_LOG_INFO("aborting scsi_cmnd=%p on adapter %s\n",
-		      scpnt, zfcp_get_busid_by_adapter(adapter));
-
 	/* avoid race condition between late normal completion and abort */
 	write_lock_irqsave(&adapter->abort_lock, flags);
 
@@ -420,7 +389,6 @@ static int zfcp_scsi_eh_abort_handler(st
 
 	fsf_req = zfcp_fsf_abort_fcp_command(old_req_id, adapter, unit, 0);
 	if (!fsf_req) {
-		ZFCP_LOG_INFO("error: initiation of Abort FCP Cmnd failed\n");
 		zfcp_scsi_dbf_event_abort("nres", adapter, scpnt, NULL,
 					  old_req_id);
 		retval = FAILED;
@@ -485,10 +453,6 @@ zfcp_task_management_function(struct zfc
 	fsf_req = zfcp_fsf_send_fcp_command_task_management
 		(adapter, unit, tm_flags, 0);
 	if (!fsf_req) {
-		ZFCP_LOG_INFO("error: creation of task management request "
-			      "failed for unit 0x%016Lx on port 0x%016Lx on  "
-			      "adapter %s\n", unit->fcp_lun, unit->port->wwpn,
-			      zfcp_get_busid_by_adapter(adapter));
 		zfcp_scsi_dbf_event_devreset("nres", tm_flags, unit, scpnt);
 		retval = -ENOMEM;
 		goto out;
@@ -524,12 +488,6 @@ static int zfcp_scsi_eh_host_reset_handl
 
 	unit = (struct zfcp_unit*) scpnt->device->hostdata;
 	adapter = unit->port->adapter;
-
-	ZFCP_LOG_NORMAL("host reset because of problems with "
-		"unit 0x%016Lx on port 0x%016Lx, adapter %s\n",
-		unit->fcp_lun, unit->port->wwpn,
-		zfcp_get_busid_by_adapter(unit->port->adapter));
-
 	zfcp_erp_adapter_reopen(adapter, 0, 141, scpnt);
 	zfcp_erp_wait(adapter);
 
@@ -549,13 +507,11 @@ zfcp_adapter_scsi_register(struct zfcp_a
 	adapter->scsi_host = scsi_host_alloc(&zfcp_data.scsi_host_template,
 					     sizeof (struct zfcp_adapter *));
 	if (!adapter->scsi_host) {
-		ZFCP_LOG_NORMAL("error: registration with SCSI stack failed "
-				"for adapter %s ",
-				zfcp_get_busid_by_adapter(adapter));
+		dev_err(&adapter->ccw_device->dev,
+			"registration with SCSI stack failed.");
 		retval = -EIO;
 		goto out;
 	}
-	ZFCP_LOG_DEBUG("host registered, scsi_host=%p\n", adapter->scsi_host);
 
 	/* tell the SCSI stack some characteristics of this adapter */
 	adapter->scsi_host->max_id = 1;
@@ -987,5 +943,3 @@ static struct device_attribute *zfcp_a_s
 	&dev_attr_seconds_active,
 	NULL
 };
-
-#undef ZFCP_LOG_AREA
--- a/drivers/s390/scsi/zfcp_sysfs_adapter.c	2008-06-10 17:35:44.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_sysfs_adapter.c	2008-06-10 17:41:27.000000000 +0200
@@ -1,28 +1,13 @@
 /*
- * This file is part of the zfcp device driver for
- * FCP adapters for IBM System z9 and zSeries.
+ * zfcp device driver
  *
- * (C) Copyright IBM Corp. 2002, 2006
+ * sysfs attributes for CCW device.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ * Copyright IBM Corporation 2002, 2008
  */
 
 #include "zfcp_ext.h"
 
-#define ZFCP_LOG_AREA                   ZFCP_LOG_AREA_CONFIG
-
 /**
  * ZFCP_DEFINE_ADAPTER_ATTR
  * @_name:   name of show attribute
@@ -266,5 +251,3 @@ zfcp_sysfs_adapter_remove_files(struct d
 {
 	sysfs_remove_group(&dev->kobj, &zfcp_adapter_attr_group);
 }
-
-#undef ZFCP_LOG_AREA
--- a/drivers/s390/scsi/zfcp_sysfs_port.c	2008-06-10 17:35:44.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_sysfs_port.c	2008-06-10 17:41:27.000000000 +0200
@@ -1,28 +1,13 @@
 /*
- * This file is part of the zfcp device driver for
- * FCP adapters for IBM System z9 and zSeries.
+ * zfcp device driver
  *
- * (C) Copyright IBM Corp. 2002, 2006
+ * sysfs attributes for zfcp port.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ * Copyright IBM Corporation 2002, 2008
  */
 
 #include "zfcp_ext.h"
 
-#define ZFCP_LOG_AREA                   ZFCP_LOG_AREA_CONFIG
-
 /**
  * zfcp_sysfs_port_release - gets called when a struct device port is released
  * @dev: pointer to belonging device
@@ -291,5 +276,3 @@ zfcp_sysfs_port_remove_files(struct devi
 	if (!(flags & ZFCP_STATUS_PORT_WKA))
 		sysfs_remove_group(&dev->kobj, &zfcp_port_no_ns_attr_group);
 }
-
-#undef ZFCP_LOG_AREA
--- a/drivers/s390/scsi/zfcp_sysfs_unit.c	2008-06-10 17:35:44.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_sysfs_unit.c	2008-06-10 17:41:27.000000000 +0200
@@ -1,28 +1,13 @@
 /*
- * This file is part of the zfcp device driver for
- * FCP adapters for IBM System z9 and zSeries.
+ * zfcp device driver
  *
- * (C) Copyright IBM Corp. 2002, 2006
+ * sysfs interface for zfcp unit.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ * Copyright IBM Corporation 2002, 2008
  */
 
 #include "zfcp_ext.h"
 
-#define ZFCP_LOG_AREA                   ZFCP_LOG_AREA_CONFIG
-
 /**
  * zfcp_sysfs_unit_release - gets called when a struct device unit is released
  * @dev: pointer to belonging device
@@ -163,5 +148,3 @@ zfcp_sysfs_unit_remove_files(struct devi
 {
 	sysfs_remove_group(&dev->kobj, &zfcp_unit_attr_group);
 }
-
-#undef ZFCP_LOG_AREA
--- a/drivers/s390/scsi/zfcp_sysfs_driver.c	2008-06-10 17:35:44.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,106 +0,0 @@
-/*
- * This file is part of the zfcp device driver for
- * FCP adapters for IBM System z9 and zSeries.
- *
- * (C) Copyright IBM Corp. 2002, 2006
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#include "zfcp_ext.h"
-
-#define ZFCP_LOG_AREA                   ZFCP_LOG_AREA_CONFIG
-
-/**
- * ZFCP_DEFINE_DRIVER_ATTR - define for all loglevels sysfs attributes
- * @_name:       name of attribute
- * @_define:     name of ZFCP loglevel define
- *
- * Generates store function for a sysfs loglevel attribute of zfcp driver.
- */
-#define ZFCP_DEFINE_DRIVER_ATTR(_name, _define)                               \
-static ssize_t zfcp_sysfs_loglevel_##_name##_store(struct device_driver *drv, \
-						   const char *buf,           \
-						   size_t count)              \
-{                                                                             \
-	unsigned int loglevel;                                                \
-	unsigned int new_loglevel;                                            \
-	char *endp;                                                           \
-                                                                              \
-	new_loglevel = simple_strtoul(buf, &endp, 0);                         \
-	if ((endp + 1) < (buf + count))                                       \
-		return -EINVAL;                                               \
-	if (new_loglevel > 3)                                                 \
-		return -EINVAL;                                               \
-	down(&zfcp_data.config_sema);                                         \
-	loglevel = atomic_read(&zfcp_data.loglevel);                          \
-	loglevel &= ~((unsigned int) 0xf << (ZFCP_LOG_AREA_##_define << 2));  \
-	loglevel |= new_loglevel << (ZFCP_LOG_AREA_##_define << 2);           \
-	atomic_set(&zfcp_data.loglevel, loglevel);                            \
-	up(&zfcp_data.config_sema);                                           \
-	return count;                                                         \
-}                                                                             \
-                                                                              \
-static ssize_t zfcp_sysfs_loglevel_##_name##_show(struct device_driver *dev,  \
-						  char *buf)                  \
-{                                                                             \
-	return sprintf(buf,"%d\n", (unsigned int)                             \
-		       ZFCP_GET_LOG_VALUE(ZFCP_LOG_AREA_##_define));          \
-}                                                                             \
-                                                                              \
-static DRIVER_ATTR(loglevel_##_name, S_IWUSR | S_IRUGO,                       \
-		   zfcp_sysfs_loglevel_##_name##_show,                        \
-		   zfcp_sysfs_loglevel_##_name##_store);
-
-ZFCP_DEFINE_DRIVER_ATTR(other, OTHER);
-ZFCP_DEFINE_DRIVER_ATTR(scsi, SCSI);
-ZFCP_DEFINE_DRIVER_ATTR(fsf, FSF);
-ZFCP_DEFINE_DRIVER_ATTR(config, CONFIG);
-ZFCP_DEFINE_DRIVER_ATTR(cio, CIO);
-ZFCP_DEFINE_DRIVER_ATTR(qdio, QDIO);
-ZFCP_DEFINE_DRIVER_ATTR(erp, ERP);
-ZFCP_DEFINE_DRIVER_ATTR(fc, FC);
-
-static ssize_t zfcp_sysfs_version_show(struct device_driver *dev,
-					      char *buf)
-{
-	return sprintf(buf, "%s\n", zfcp_data.driver_version);
-}
-
-static DRIVER_ATTR(version, S_IRUGO, zfcp_sysfs_version_show, NULL);
-
-static struct attribute *zfcp_driver_attrs[] = {
-	&driver_attr_loglevel_other.attr,
-	&driver_attr_loglevel_scsi.attr,
-	&driver_attr_loglevel_fsf.attr,
-	&driver_attr_loglevel_config.attr,
-	&driver_attr_loglevel_cio.attr,
-	&driver_attr_loglevel_qdio.attr,
-	&driver_attr_loglevel_erp.attr,
-	&driver_attr_loglevel_fc.attr,
-	&driver_attr_version.attr,
-	NULL
-};
-
-static struct attribute_group zfcp_driver_attr_group = {
-	.attrs = zfcp_driver_attrs,
-};
-
-struct attribute_group *zfcp_driver_attr_groups[] = {
-	&zfcp_driver_attr_group,
-	NULL,
-};
-
-#undef ZFCP_LOG_AREA
--- a/drivers/s390/scsi/Makefile	2008-06-10 17:36:57.000000000 +0200
+++ b/drivers/s390/scsi/Makefile	2008-06-10 17:41:27.000000000 +0200
@@ -4,6 +4,6 @@
 
 zfcp-objs := zfcp_aux.o zfcp_ccw.o zfcp_scsi.o zfcp_erp.o zfcp_qdio.o \
 	     zfcp_fsf.o zfcp_dbf.o zfcp_sysfs_adapter.o zfcp_sysfs_port.o \
-	     zfcp_sysfs_unit.o zfcp_sysfs_driver.o zfcp_fc.o zfcp_cfdc.o
+	     zfcp_sysfs_unit.o zfcp_fc.o zfcp_cfdc.o
 
 obj-$(CONFIG_ZFCP) += zfcp.o

-- 
