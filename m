From: Swen Schillig <swen@vnet.ibm.com>
Subject: [RFC] zfcp: add statistics and other zfcp related information to sysfs
Date: Mon, 3 Sep 2007 14:16:21 +0200
Message-ID: <200709031416.21901.swen@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:19260 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbXICMNh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Sep 2007 08:13:37 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org

The zfcp adapter provides a variety of information which was never
published to the external world. This patch adds a few of those "statistics"
to the sysfs tree structure.

These are reflected in the following attributes

/sys/bus/ccw/drivers/zfcp/0.0.1707 
/* information for the virtual adapter */
	statistic_services/ 	
		requests	
		megabytes
		utilization
		seconds_active
/* LUN specific info for channel- and fabric-latency */
	0x500507630300c562/0x401040a600000000/  
		read_latency
		write_latency
		cmd_latency

Please comment if this would be an acceptable way to publish 
the additional information.

Cheers Swen.

---
 drivers/s390/scsi/Makefile                |    2 
 drivers/s390/scsi/zfcp_aux.c              |   30 ++++
 drivers/s390/scsi/zfcp_def.h              |   58 +++++----
 drivers/s390/scsi/zfcp_ext.h              |   32 ++---
 drivers/s390/scsi/zfcp_fsf.c              |    1 
 drivers/s390/scsi/zfcp_fsf.h              |   29 ++++
 drivers/s390/scsi/zfcp_qdio.c             |   34 +++++
 drivers/s390/scsi/zfcp_sysfs_statistics.c |  191 ++++++++++++++++++++++++++++++
 drivers/s390/scsi/zfcp_sysfs_unit.c       |   63 +++++++++
 9 files changed, 394 insertions(+), 46 deletions(-)

Index: HEAD/drivers/s390/scsi/zfcp_def.h
===================================================================
--- HEAD.orig/drivers/s390/scsi/zfcp_def.h
+++ HEAD/drivers/s390/scsi/zfcp_def.h
@@ -1,23 +1,23 @@
-/* 
+/*
  * This file is part of the zfcp device driver for
  * FCP adapters for IBM System z9 and zSeries.
  *
  * (C) Copyright IBM Corp. 2002, 2006
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
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
 
 #ifndef ZFCP_DEF_H
 #define ZFCP_DEF_H
@@ -90,7 +90,7 @@ zfcp_address_to_sg(void *address, struct
 #define ZFCP_DEVICE_TYPE        0x1732
 #define ZFCP_DEVICE_MODEL       0x03
 #define ZFCP_DEVICE_MODEL_PRIV	0x04
- 
+
 /* allow as many chained SBALs as are supported by hardware */
 #define ZFCP_MAX_SBALS_PER_REQ		FSF_MAX_SBALS_PER_REQ
 #define ZFCP_MAX_SBALS_PER_CT_REQ	FSF_MAX_SBALS_PER_REQ
@@ -508,7 +508,7 @@ struct zfcp_rc_entry {
 
 /*
  * this allows removal of logging code by the preprocessor
- * (the most detailed log level still to be compiled in is specified, 
+ * (the most detailed log level still to be compiled in is specified,
  * higher log levels are removed)
  */
 #define ZFCP_LOG_LEVEL_LIMIT	ZFCP_LOG_LEVEL_TRACE
@@ -546,7 +546,7 @@ do { \
 	if (ZFCP_LOG_CHECK(level)) \
 		_ZFCP_LOG(fmt, ##args); \
 } while (0)
-	
+
 #if ZFCP_LOG_LEVEL_LIMIT < ZFCP_LOG_LEVEL_NORMAL
 # define ZFCP_LOG_NORMAL(fmt, args...)	do { } while (0)
 #else
@@ -583,8 +583,8 @@ do { \
 
 /*************** ADAPTER/PORT/UNIT AND FSF_REQ STATUS FLAGS ******************/
 
-/* 
- * Note, the leftmost status byte is common among adapter, port 
+/*
+ * Note, the leftmost status byte is common among adapter, port
  * and unit
  */
 #define ZFCP_COMMON_FLAGS			0xfff00000
@@ -868,6 +868,17 @@ struct zfcp_erp_action {
 	struct timer_list timer;
 };
 
+struct latency_cont {
+	u32 channel;
+	u32 fabric;
+	u32 counter;
+};
+
+struct zfcp_latencies {
+	struct latency_cont read;
+	struct latency_cont write;
+	struct latency_cont cmd;
+};
 
 struct zfcp_adapter {
 	struct list_head	list;              /* list of adapters */
@@ -883,6 +894,7 @@ struct zfcp_adapter {
 	u32			adapter_features;  /* FCP channel features */
 	u32			connection_features; /* host connection features */
         u32			hardware_version;  /* of FCP channel */
+	u16			timer_ticks;       /* time int for a tick */
 	struct Scsi_Host	*scsi_host;	   /* Pointer to mid-layer */
 	struct list_head	port_list_head;	   /* remote port list */
 	struct list_head        port_remove_lh;    /* head of ports to be
@@ -930,6 +942,7 @@ struct zfcp_adapter {
 	struct zfcp_scsi_dbf_record	scsi_dbf_buf;
 	struct zfcp_adapter_mempool	pool;      /* Adapter memory pools */
 	struct qdio_initialize  qdio_init_data;    /* for qdio_establish */
+	struct device		stat_services;
 	struct device           generic_services;  /* directory for WKA ports */
 	struct fc_host_statistics *fc_stats;
 	struct fsf_qtcb_bottom_port *stats_reset_data;
@@ -986,6 +999,7 @@ struct zfcp_unit {
 						  all scsi_scan_target
 						  requests have been
 						  completed. */
+	struct zfcp_latencies	latencies;
 };
 
 /* FSF request */
@@ -1007,7 +1021,7 @@ struct zfcp_fsf_req {
 	u32		       fsf_command;    /* FSF Command copy */
 	struct fsf_qtcb	       *qtcb;	       /* address of associated QTCB */
 	u32		       seq_no;         /* Sequence number of request */
-        unsigned long          data;           /* private data of request */ 
+        unsigned long          data;           /* private data of request */
 	struct timer_list      timer;	       /* used for erp or scsi er */
 	struct zfcp_erp_action *erp_action;    /* used if this request is
 						  issued on behalf of erp */
Index: HEAD/drivers/s390/scsi/zfcp_fsf.c
===================================================================
--- HEAD.orig/drivers/s390/scsi/zfcp_fsf.c
+++ HEAD/drivers/s390/scsi/zfcp_fsf.c
@@ -2079,6 +2079,7 @@ zfcp_fsf_exchange_config_evaluate(struct
 		fc_host_supported_classes(shost) =
 				FC_COS_CLASS2 | FC_COS_CLASS3;
 		adapter->hydra_version = bottom->adapter_type;
+		adapter->timer_ticks = bottom->timer_interval;
 		if (fc_host_permanent_port_name(shost) == -1)
 			fc_host_permanent_port_name(shost) =
 				fc_host_port_name(shost);
Index: HEAD/drivers/s390/scsi/zfcp_fsf.h
===================================================================
--- HEAD.orig/drivers/s390/scsi/zfcp_fsf.h
+++ HEAD/drivers/s390/scsi/zfcp_fsf.h
@@ -213,6 +213,7 @@
 #define FSF_FEATURE_HBAAPI_MANAGEMENT           0x00000010
 #define FSF_FEATURE_ELS_CT_CHAINED_SBALS        0x00000020
 #define FSF_FEATURE_UPDATE_ALERT		0x00000100
+#define FSF_FEATURE_MEASUREMENT_DATA		0x00000200
 
 /* host connection features */
 #define FSF_FEATURE_NPIV_MODE			0x00000001
@@ -322,11 +323,18 @@ struct fsf_link_down_info {
 	u8 vendor_specific_code;
 } __attribute__ ((packed));
 
+struct fsf_qual_latency_info {
+	u32 channel_lat;
+	u32 fabric_lat;
+	u8 res1[8];
+} __attribute__ ((packed));
+
 union fsf_prot_status_qual {
 	u64 doubleword[FSF_PROT_STATUS_QUAL_SIZE / sizeof(u64)];
 	struct fsf_qual_version_error   version_error;
 	struct fsf_qual_sequence_error  sequence_error;
 	struct fsf_link_down_info link_down_info;
+	struct fsf_qual_latency_info latency_info;
 } __attribute__ ((packed));
 
 struct fsf_qtcb_prefix {
@@ -340,6 +348,15 @@ struct fsf_qtcb_prefix {
 	u8  res1[20];
 } __attribute__ ((packed));
 
+struct fsf_statistics_info {
+	u64 input_req;
+	u64 output_req;
+	u64 control_req;
+	u64 input_mb;
+	u64 output_mb;
+	u64 seconds_act;
+} __attribute__ ((packed));
+
 union fsf_status_qual {
 	u8  byte[FSF_STATUS_QUALIFIER_SIZE];
 	u16 halfword[FSF_STATUS_QUALIFIER_SIZE / sizeof (u16)];
@@ -427,7 +444,9 @@ struct fsf_qtcb_bottom_config {
 	u32 fc_link_speed;
 	u32 adapter_type;
 	u32 peer_d_id;
-	u8 res2[12];
+	u8 res1[2];
+	u16 timer_interval;
+	u8 res2[8];
 	u32 s_id;
 	struct fsf_nport_serv_param nport_serv_param;
 	u8 reserved_nport_serv_param[16];
@@ -436,7 +455,8 @@ struct fsf_qtcb_bottom_config {
 	u32 hardware_version;
 	u8 serial_number[32];
 	struct fsf_nport_serv_param plogi_payload;
-	u8 res4[160];
+	struct fsf_statistics_info stat_info;
+	u8 res4[112];
 } __attribute__ ((packed));
 
 struct fsf_qtcb_bottom_port {
@@ -469,7 +489,10 @@ struct fsf_qtcb_bottom_port {
 	u64 control_requests;
 	u64 input_mb;		/* where 1 MByte == 1.000.000 Bytes */
 	u64 output_mb;		/* where 1 MByte == 1.000.000 Bytes */
-	u8 res2[256];
+	u8 cp_util;
+	u8 cb_util;
+	u8 a_util;
+	u8 res2[253];
 } __attribute__ ((packed));
 
 union fsf_qtcb_bottom {
Index: HEAD/drivers/s390/scsi/zfcp_qdio.c
===================================================================
--- HEAD.orig/drivers/s390/scsi/zfcp_qdio.c
+++ HEAD/drivers/s390/scsi/zfcp_qdio.c
@@ -177,7 +177,7 @@ zfcp_qdio_handler_error_check(struct zfc
                 * which is set again in case we have missed by a mile.
                 */
                zfcp_erp_adapter_reopen(
-                       adapter, 
+                       adapter,
                        ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED |
                        ZFCP_STATUS_COMMON_ERP_FAILED);
 	}
@@ -241,6 +241,8 @@ static void zfcp_qdio_reqid_check(struct
 {
 	struct zfcp_fsf_req *fsf_req;
 	unsigned long flags;
+	struct fsf_qual_latency_info *lat_inf;
+	struct zfcp_unit *unit;
 
 	debug_long_event(adapter->erp_dbf, 4, req_id);
 
@@ -255,6 +257,36 @@ static void zfcp_qdio_reqid_check(struct
 		panic("error: unknown request id (%ld) on adapter %s.\n",
 		      req_id, zfcp_get_busid_by_adapter(adapter));
 
+	if ((fsf_req->fsf_command == FSF_QTCB_FCP_CMND) &&
+	    (fsf_req->qtcb->prefix.prot_status &
+	    (FSF_PROT_GOOD | FSF_PROT_FSF_STATUS_PRESENTED))) {
+		lat_inf = &fsf_req->qtcb->prefix.prot_status_qual.latency_info;
+		unit = fsf_req->unit;
+		switch(fsf_req->qtcb->bottom.io.data_direction) {
+			case FSF_DATADIR_READ:
+				unit->latencies.read.channel +=
+					lat_inf->channel_lat;
+				unit->latencies.read.fabric +=
+					lat_inf->fabric_lat;
+				unit->latencies.read.counter++;
+				break;
+			case FSF_DATADIR_WRITE:
+				unit->latencies.write.channel +=
+					lat_inf->channel_lat;
+				unit->latencies.write.fabric +=
+					lat_inf->fabric_lat;
+				unit->latencies.write.counter++;
+				break;
+			case FSF_DATADIR_CMND:
+				unit->latencies.cmd.channel +=
+					lat_inf->channel_lat;
+				unit->latencies.cmd.fabric +=
+					lat_inf->fabric_lat;
+				unit->latencies.cmd.counter++;
+				break;
+		}
+	}
+
 	zfcp_reqlist_remove(adapter, fsf_req);
 	atomic_dec(&adapter->reqs_active);
 	spin_unlock_irqrestore(&adapter->req_list_lock, flags);
Index: HEAD/drivers/s390/scsi/zfcp_sysfs_unit.c
===================================================================
--- HEAD.orig/drivers/s390/scsi/zfcp_sysfs_unit.c
+++ HEAD/drivers/s390/scsi/zfcp_sysfs_unit.c
@@ -125,6 +125,66 @@ zfcp_sysfs_unit_failed_show(struct devic
 static DEVICE_ATTR(failed, S_IWUSR | S_IRUGO, zfcp_sysfs_unit_failed_show,
 		   zfcp_sysfs_unit_failed_store);
 
+static ssize_t
+zfcp_sysfs_unit_read_latency_show(struct device *dev,
+				  struct device_attribute *attr, char *buf) {
+	struct zfcp_unit *unit;
+	struct zfcp_latencies *lat;
+	struct zfcp_adapter *adapter;
+
+	unit = dev_get_drvdata(dev);
+	lat = &unit->latencies;
+	adapter = unit->port->adapter;
+
+	return sprintf(buf, "%u %u %u\n",
+			lat->read.fabric * adapter->timer_ticks / 1000,
+			lat->read.channel * adapter->timer_ticks / 1000,
+			lat->read.counter);
+}
+
+static DEVICE_ATTR(read_latency, S_IRUGO, zfcp_sysfs_unit_read_latency_show,
+		   NULL);
+
+static ssize_t
+zfcp_sysfs_unit_write_latency_show(struct device *dev,
+				   struct device_attribute *attr, char *buf) {
+	struct zfcp_unit *unit;
+	struct zfcp_latencies *lat;
+	struct zfcp_adapter *adapter;
+
+	unit = dev_get_drvdata(dev);
+	lat = &unit->latencies;
+	adapter = unit->port->adapter;
+
+	return sprintf(buf, "%u %u %u\n",
+		       lat->write.fabric * adapter->timer_ticks / 1000,
+		       lat->write.channel * adapter->timer_ticks / 1000,
+		       lat->write.counter);
+}
+
+static DEVICE_ATTR(write_latency, S_IRUGO, zfcp_sysfs_unit_write_latency_show,
+		   NULL);
+
+static ssize_t
+zfcp_sysfs_unit_cmd_latency_show(struct device *dev,
+				 struct device_attribute *attr, char *buf) {
+	struct zfcp_unit *unit;
+	struct zfcp_latencies *lat;
+	struct zfcp_adapter *adapter;
+
+	unit = dev_get_drvdata(dev);
+	lat = &unit->latencies;
+	adapter = unit->port->adapter;
+
+	return sprintf(buf, "%u %u %u\n",
+		       lat->cmd.fabric * adapter->timer_ticks / 1000,
+		       lat->cmd.channel * adapter->timer_ticks / 1000,
+		       lat->cmd.counter);
+}
+
+static DEVICE_ATTR(cmd_latency, S_IRUGO, zfcp_sysfs_unit_cmd_latency_show,
+		   NULL);
+
 static struct attribute *zfcp_unit_attrs[] = {
 	&dev_attr_failed.attr,
 	&dev_attr_in_recovery.attr,
@@ -132,6 +192,9 @@ static struct attribute *zfcp_unit_attrs
 	&dev_attr_access_denied.attr,
 	&dev_attr_access_shared.attr,
 	&dev_attr_access_readonly.attr,
+	&dev_attr_read_latency.attr,
+	&dev_attr_write_latency.attr,
+	&dev_attr_cmd_latency.attr,
 	NULL
 };
 
Index: HEAD/drivers/s390/scsi/zfcp_ext.h
===================================================================
--- HEAD.orig/drivers/s390/scsi/zfcp_ext.h
+++ HEAD/drivers/s390/scsi/zfcp_ext.h
@@ -1,22 +1,22 @@
-/* 
+/*
  * This file is part of the zfcp device driver for
  * FCP adapters for IBM System z9 and zSeries.
  *
  * (C) Copyright IBM Corp. 2002, 2006
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
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #ifndef ZFCP_EXT_H
@@ -37,6 +37,8 @@ extern int  zfcp_sysfs_unit_create_files
 extern void zfcp_sysfs_unit_remove_files(struct device *);
 extern void zfcp_sysfs_port_release(struct device *);
 extern void zfcp_sysfs_unit_release(struct device *);
+extern int  zfcp_sysfs_statistic_services_create_files(struct device *);
+extern void zfcp_sysfs_statistic_services_remove_files(struct device *);
 
 /**************************** CONFIGURATION  *********************************/
 extern struct zfcp_unit *zfcp_get_unit_by_lun(struct zfcp_port *, fcp_lun_t);
Index: HEAD/drivers/s390/scsi/zfcp_aux.c
===================================================================
--- HEAD.orig/drivers/s390/scsi/zfcp_aux.c
+++ HEAD/drivers/s390/scsi/zfcp_aux.c
@@ -887,7 +887,7 @@ zfcp_unit_dequeue(struct zfcp_unit *unit
 /*
  * Allocates a combined QTCB/fsf_req buffer for erp actions and fcp/SCSI
  * commands.
- * It also genrates fcp-nameserver request/response buffer and unsolicited 
+ * It also genrates fcp-nameserver request/response buffer and unsolicited
  * status read fsf_req buffers.
  *
  * locks:       must only be called with zfcp_data.config_sema taken
@@ -978,7 +978,7 @@ zfcp_adapter_enqueue(struct ccw_device *
 	struct zfcp_adapter *adapter;
 
 	/*
-	 * Note: It is safe to release the list_lock, as any list changes 
+	 * Note: It is safe to release the list_lock, as any list changes
 	 * are protected by the config_sema, which must be held to get here
 	 */
 
@@ -1059,13 +1059,33 @@ zfcp_adapter_enqueue(struct ccw_device *
 	if (zfcp_sysfs_adapter_create_files(&ccw_device->dev))
 		goto sysfs_failed;
 
+	adapter->stat_services.parent = &adapter->ccw_device->dev;
+	adapter->stat_services.release = zfcp_dummy_release;
+	snprintf(adapter->stat_services.bus_id, BUS_ID_SIZE,
+		 "statistic_services");
+	dev_set_drvdata(&adapter->stat_services, adapter);
+
+	if (device_register(&adapter->stat_services)) {
+		ZFCP_LOG_NORMAL("SSS:stat_reg failed.\n");
+		goto services_failed;
+	}
+	ZFCP_LOG_NORMAL("SSS:stat_reg succeeded.\n");
+
+	if (zfcp_sysfs_statistic_services_create_files(&adapter->stat_services))
+	{
+		ZFCP_LOG_NORMAL("SSS: create files failed.\n");
+		goto sysfs_failed;
+	}
+
+	ZFCP_LOG_NORMAL("SSS:create files succeeded.\n");
+
 	adapter->generic_services.parent = &adapter->ccw_device->dev;
 	adapter->generic_services.release = zfcp_dummy_release;
 	snprintf(adapter->generic_services.bus_id, BUS_ID_SIZE,
 		 "generic_services");
 
 	if (device_register(&adapter->generic_services))
-		goto generic_services_failed;
+		goto services_failed;
 
 	/* put allocated adapter at list tail */
 	write_lock_irq(&zfcp_data.config_lock);
@@ -1077,7 +1097,7 @@ zfcp_adapter_enqueue(struct ccw_device *
 
 	goto out;
 
- generic_services_failed:
+ services_failed:
 	zfcp_sysfs_adapter_remove_files(&adapter->ccw_device->dev);
  sysfs_failed:
 	dev_set_drvdata(&ccw_device->dev, NULL);
@@ -1110,6 +1130,8 @@ zfcp_adapter_dequeue(struct zfcp_adapter
 
 	zfcp_adapter_scsi_unregister(adapter);
 	device_unregister(&adapter->generic_services);
+	zfcp_sysfs_statistic_services_remove_files(&adapter->stat_services);
+	device_unregister(&adapter->stat_services);
 	zfcp_sysfs_adapter_remove_files(&adapter->ccw_device->dev);
 	dev_set_drvdata(&adapter->ccw_device->dev, NULL);
 	/* sanity check: no pending FSF requests */
Index: HEAD/drivers/s390/scsi/Makefile
===================================================================
--- HEAD.orig/drivers/s390/scsi/Makefile
+++ HEAD/drivers/s390/scsi/Makefile
@@ -4,6 +4,6 @@
 
 zfcp-objs := zfcp_aux.o zfcp_ccw.o zfcp_scsi.o zfcp_erp.o zfcp_qdio.o \
 	     zfcp_fsf.o zfcp_dbf.o zfcp_sysfs_adapter.o zfcp_sysfs_port.o \
-	     zfcp_sysfs_unit.o zfcp_sysfs_driver.o
+	     zfcp_sysfs_unit.o zfcp_sysfs_driver.o zfcp_sysfs_statistics.o
 
 obj-$(CONFIG_ZFCP) += zfcp.o
Index: HEAD/drivers/s390/scsi/zfcp_sysfs_statistics.c
===================================================================
--- /dev/null
+++ HEAD/drivers/s390/scsi/zfcp_sysfs_statistics.c
@@ -0,0 +1,191 @@
+/*
+ * This file is part of the zfcp device driver for
+ * FCP adapters for IBM System z9 and zSeries.
+ *
+ * (C) Copyright IBM Corp. 2002, 2006
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
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include "zfcp_ext.h"
+
+#define ZFCP_LOG_AREA                   ZFCP_LOG_AREA_CONFIG
+
+
+static ssize_t
+zfcp_sysfs_adapter_utilization_show(struct device *dev,
+				    struct device_attribute *attr, char *buf) {
+	struct zfcp_adapter *adapter;
+	struct fsf_qtcb_bottom_port *qtcb_port;
+	int retval;
+
+	adapter = dev_get_drvdata(dev);
+
+	qtcb_port = kzalloc(sizeof(struct fsf_qtcb_bottom_port), GFP_KERNEL);
+	if (!qtcb_port) {
+		ZFCP_LOG_NORMAL("error: cannot allocate memory for exchange "
+				"port data request (adapter %s).\n",
+				zfcp_get_busid_by_adapter(adapter));
+		return (ssize_t) 0;
+	}
+
+	retval = zfcp_fsf_exchange_port_data_sync(adapter, qtcb_port);
+	if (retval) {
+		ZFCP_LOG_NORMAL("error: exchange port data request failed for "
+				"adapter %s.\n",
+				zfcp_get_busid_by_adapter(adapter));
+		kfree(qtcb_port);
+		return (ssize_t) 0;
+	}
+
+	retval = sprintf(buf, "%u %u %u\n", qtcb_port->cp_util,
+			 qtcb_port->cb_util, qtcb_port->a_util);
+	kfree(qtcb_port);
+	return retval;
+}
+
+static DEVICE_ATTR(utilization, S_IRUGO, zfcp_sysfs_adapter_utilization_show,
+		   NULL);
+
+static ssize_t
+zfcp_sysfs_adapter_request_show(struct device *dev,
+				struct device_attribute *attr, char *buf) {
+	struct zfcp_adapter *adapter;
+	struct fsf_qtcb_bottom_config *qtcb_config;
+	int retval;
+
+	adapter = dev_get_drvdata(dev);
+
+	qtcb_config = kzalloc(sizeof(struct fsf_qtcb_bottom_config),
+			      GFP_KERNEL);
+	if (!qtcb_config) {
+		ZFCP_LOG_NORMAL("error: cannot allocate memory for exchange "
+				"configuration data request (adapter %s).\n",
+				zfcp_get_busid_by_adapter(adapter));
+		return (ssize_t) 0;
+	}
+
+	retval = zfcp_fsf_exchange_config_data_sync(adapter, qtcb_config);
+	if (retval)
+		ZFCP_LOG_NORMAL("error: exchange configuration data request "
+				"failed for adapter %s.\n",
+				zfcp_get_busid_by_adapter(adapter));
+	else
+		retval = sprintf(buf, "%lu %lu %lu\n",
+				 qtcb_config->stat_info.input_req,
+				 qtcb_config->stat_info.output_req,
+				 qtcb_config->stat_info.control_req);
+
+	kfree(qtcb_config);
+	return (retval > 0) ? retval : (ssize_t) 0;
+}
+
+static DEVICE_ATTR(requests, S_IRUGO, zfcp_sysfs_adapter_request_show, NULL);
+
+static ssize_t
+zfcp_sysfs_adapter_mb_show(struct device *dev,
+			   struct device_attribute *attr, char *buf) {
+	struct zfcp_adapter *adapter;
+	struct fsf_qtcb_bottom_config *qtcb_config;
+	int retval;
+
+	adapter = dev_get_drvdata(dev);
+
+	qtcb_config = kzalloc(sizeof(struct fsf_qtcb_bottom_config),
+			      GFP_KERNEL);
+
+	if (!qtcb_config) {
+		ZFCP_LOG_NORMAL("error: cannot allocate memory for exchange "
+				"configuration data request (adapter %s).\n",
+				zfcp_get_busid_by_adapter(adapter));
+		return (ssize_t) 0;
+	}
+
+	retval = zfcp_fsf_exchange_config_data_sync(adapter, qtcb_config);
+	if (retval)
+		ZFCP_LOG_NORMAL("error: exchnage configuration data request "
+				"failed for adapter %s.\n",
+				zfcp_get_busid_by_adapter(adapter));
+	else
+		retval = sprintf(buf, "%lu %lu\n",
+				 qtcb_config->stat_info.input_mb,
+			 	 qtcb_config->stat_info.output_mb);
+
+	kfree(qtcb_config);
+	return (retval > 0) ? retval : (ssize_t) 0;
+}
+
+static DEVICE_ATTR(megabytes, S_IRUGO, zfcp_sysfs_adapter_mb_show, NULL);
+
+static ssize_t
+zfcp_sysfs_adapter_seconds_active_show(struct device *dev,
+				       struct device_attribute *attr,
+				       char *buf) {
+	struct zfcp_adapter *adapter;
+	struct fsf_qtcb_bottom_config *qtcb_config;
+	int retval;
+
+	adapter = dev_get_drvdata(dev);
+
+	qtcb_config = kzalloc(sizeof(struct fsf_qtcb_bottom_config),
+			      GFP_KERNEL);
+
+	if (!qtcb_config) {
+		ZFCP_LOG_NORMAL("error: cannot allocate memory for exchange "
+				"configuration data request (adapter %s).\n",
+				zfcp_get_busid_by_adapter(adapter));
+		return (ssize_t) 0;
+	}
+
+	retval = zfcp_fsf_exchange_config_data_sync(adapter, qtcb_config);
+	if (retval)
+		ZFCP_LOG_NORMAL("error: exchange configuration data request "
+				"failed for adapter %s.\n",
+				zfcp_get_busid_by_adapter(adapter));
+	else
+		retval = sprintf(buf, "%lu\n",
+				 qtcb_config->stat_info.seconds_act);
+
+	kfree(qtcb_config);
+	return (retval > 0) ? retval: (ssize_t) 0;
+}
+
+static DEVICE_ATTR(seconds_active, S_IRUGO,
+		   zfcp_sysfs_adapter_seconds_active_show, NULL);
+
+static struct attribute *zfcp_statistic_services_attrs[] = {
+	&dev_attr_utilization.attr,
+	&dev_attr_requests.attr,
+	&dev_attr_megabytes.attr,
+	&dev_attr_seconds_active.attr,
+	NULL
+};
+
+static struct attribute_group zfcp_statistic_services_attr_group = {
+	.attrs = zfcp_statistic_services_attrs,
+};
+
+int
+zfcp_sysfs_statistic_services_create_files(struct device *dev){
+	return sysfs_create_group(&dev->kobj,
+				  &zfcp_statistic_services_attr_group);
+}
+
+void
+zfcp_sysfs_statistic_services_remove_files(struct device *dev) {
+	sysfs_remove_group(&dev->kobj, &zfcp_statistic_services_attr_group);
+}
+
+#undef ZFCP_LOG_AREA
