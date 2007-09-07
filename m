From: Swen Schillig <swen@vnet.ibm.com>
Subject: [PATCH 2/2] zfcp: zfcp: add statistics and other zfcp relatedinformation to sysfs
Date: Fri, 7 Sep 2007 09:15:33 +0200
Message-ID: <200709070915.33439.swen@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:49054 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964859AbXIGHPz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Sep 2007 03:15:55 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, heiko.carstens@de.ibm.com

=46rom: Swen Schillig <swen@vnet.ibm.com>

add statistics and other zfcp related information to sysfs

The zfcp adapter provides a variety of information which was never
published to the external world. This patch adds a few of those "statis=
tics"
to the sysfs tree structure.

These are reflected in the following attributes

/sys/bus/ccw/drivers/zfcp/0.0.1707=20
/* information for the virtual adapter */
=A0=A0=A0=A0=A0=A0=A0=A0statistic_services/ =A0=A0=A0=A0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0requests=A0=A0=A0=A0=A0=
=A0=A0=A0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0megabytes
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0utilization
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0seconds_active
/* LUN specific info for channel- and fabric-latency */
=A0=A0=A0=A0=A0=A0=A0=A00x500507630300c562/0x401040a600000000/ =A0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0read_latency
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0write_latency
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0cmd_latency

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
---
 drivers/s390/scsi/Makefile                |    2=20
 drivers/s390/scsi/zfcp_aux.c              |   30 ++++-
 drivers/s390/scsi/zfcp_def.h              |   14 ++
 drivers/s390/scsi/zfcp_ext.h              |    2=20
 drivers/s390/scsi/zfcp_fsf.c              |    1=20
 drivers/s390/scsi/zfcp_fsf.h              |   28 ++++-
 drivers/s390/scsi/zfcp_qdio.c             |   39 +++++++
 drivers/s390/scsi/zfcp_sysfs_statistics.c |  162 +++++++++++++++++++++=
+++++++++
 drivers/s390/scsi/zfcp_sysfs_unit.c       |   63 +++++++++++
 9 files changed, 333 insertions(+), 8 deletions(-)

Index: HEAD/drivers/s390/scsi/zfcp_def.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- HEAD.orig/drivers/s390/scsi/zfcp_def.h
+++ HEAD/drivers/s390/scsi/zfcp_def.h
@@ -868,6 +868,17 @@ struct zfcp_erp_action {
 	struct timer_list timer;
 };
=20
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
=20
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
 	struct device           generic_services;  /* directory for WKA ports=
 */
 	struct fc_host_statistics *fc_stats;
 	struct fsf_qtcb_bottom_port *stats_reset_data;
@@ -986,6 +999,7 @@ struct zfcp_unit {
 						  all scsi_scan_target
 						  requests have been
 						  completed. */
+	struct zfcp_latencies	latencies;
 };
=20
 /* FSF request */
Index: HEAD/drivers/s390/scsi/zfcp_fsf.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- HEAD.orig/drivers/s390/scsi/zfcp_fsf.c
+++ HEAD/drivers/s390/scsi/zfcp_fsf.c
@@ -2079,6 +2079,7 @@ zfcp_fsf_exchange_config_evaluate(struct
 		fc_host_supported_classes(shost) =3D
 				FC_COS_CLASS2 | FC_COS_CLASS3;
 		adapter->hydra_version =3D bottom->adapter_type;
+		adapter->timer_ticks =3D bottom->timer_interval;
 		if (fc_host_permanent_port_name(shost) =3D=3D -1)
 			fc_host_permanent_port_name(shost) =3D
 				fc_host_port_name(shost);
Index: HEAD/drivers/s390/scsi/zfcp_fsf.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- HEAD.orig/drivers/s390/scsi/zfcp_fsf.h
+++ HEAD/drivers/s390/scsi/zfcp_fsf.h
@@ -322,11 +322,18 @@ struct fsf_link_down_info {
 	u8 vendor_specific_code;
 } __attribute__ ((packed));
=20
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
=20
 struct fsf_qtcb_prefix {
@@ -340,6 +347,15 @@ struct fsf_qtcb_prefix {
 	u8  res1[20];
 } __attribute__ ((packed));
=20
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
@@ -427,7 +443,9 @@ struct fsf_qtcb_bottom_config {
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
@@ -436,7 +454,8 @@ struct fsf_qtcb_bottom_config {
 	u32 hardware_version;
 	u8 serial_number[32];
 	struct fsf_nport_serv_param plogi_payload;
-	u8 res4[160];
+	struct fsf_statistics_info stat_info;
+	u8 res4[112];
 } __attribute__ ((packed));
=20
 struct fsf_qtcb_bottom_port {
@@ -469,7 +488,10 @@ struct fsf_qtcb_bottom_port {
 	u64 control_requests;
 	u64 input_mb;		/* where 1 MByte =3D=3D 1.000.000 Bytes */
 	u64 output_mb;		/* where 1 MByte =3D=3D 1.000.000 Bytes */
-	u8 res2[256];
+	u8 cp_util;
+	u8 cb_util;
+	u8 a_util;
+	u8 res2[253];
 } __attribute__ ((packed));
=20
 union fsf_qtcb_bottom {
Index: HEAD/drivers/s390/scsi/zfcp_qdio.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- HEAD.orig/drivers/s390/scsi/zfcp_qdio.c
+++ HEAD/drivers/s390/scsi/zfcp_qdio.c
@@ -232,6 +232,40 @@ zfcp_qdio_request_handler(struct ccw_dev
 	return;
 }
=20
+static void zfcp_qdio_fsf_req_latency(struct zfcp_fsf_req *fsf_req)
+{
+	struct fsf_qual_latency_info *lat_inf;
+	struct zfcp_unit *unit;
+
+	lat_inf =3D &fsf_req->qtcb->prefix.prot_status_qual.latency_info;
+	unit =3D fsf_req->unit;
+
+	switch (fsf_req->qtcb->bottom.io.data_direction) {
+	case FSF_DATADIR_READ:
+		unit->latencies.read.channel +=3D
+				lat_inf->channel_lat;
+		unit->latencies.read.fabric +=3D
+				lat_inf->fabric_lat;
+		unit->latencies.read.counter++;
+		break;
+	case FSF_DATADIR_WRITE:
+		unit->latencies.write.channel +=3D
+				lat_inf->channel_lat;
+		unit->latencies.write.fabric +=3D
+				lat_inf->fabric_lat;
+		unit->latencies.write.counter++;
+		break;
+	case FSF_DATADIR_CMND:
+		unit->latencies.cmd.channel +=3D
+				lat_inf->channel_lat;
+		unit->latencies.cmd.fabric +=3D
+				lat_inf->fabric_lat;
+		unit->latencies.cmd.counter++;
+		break;
+	}
+}
+
+
 /**
  * zfcp_qdio_reqid_check - checks for valid reqids.
  */
@@ -254,6 +288,11 @@ static void zfcp_qdio_reqid_check(struct
 		panic("error: unknown request id (%ld) on adapter %s.\n",
 		      req_id, zfcp_get_busid_by_adapter(adapter));
=20
+	if ((fsf_req->fsf_command =3D=3D FSF_QTCB_FCP_CMND) &&
+	    (fsf_req->qtcb->prefix.prot_status &
+	    (FSF_PROT_GOOD | FSF_PROT_FSF_STATUS_PRESENTED)))
+		zfcp_qdio_fsf_req_latency(fsf_req);
+
 	zfcp_reqlist_remove(adapter, fsf_req);
 	atomic_dec(&adapter->reqs_active);
 	spin_unlock_irqrestore(&adapter->req_list_lock, flags);
Index: HEAD/drivers/s390/scsi/zfcp_sysfs_unit.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- HEAD.orig/drivers/s390/scsi/zfcp_sysfs_unit.c
+++ HEAD/drivers/s390/scsi/zfcp_sysfs_unit.c
@@ -125,6 +125,66 @@ zfcp_sysfs_unit_failed_show(struct devic
 static DEVICE_ATTR(failed, S_IWUSR | S_IRUGO, zfcp_sysfs_unit_failed_s=
how,
 		   zfcp_sysfs_unit_failed_store);
=20
+static ssize_t
+zfcp_sysfs_unit_read_latency_show(struct device *dev,
+				  struct device_attribute *attr, char *buf) {
+	struct zfcp_unit *unit;
+	struct zfcp_latencies *lat;
+	struct zfcp_adapter *adapter;
+
+	unit =3D dev_get_drvdata(dev);
+	lat =3D &unit->latencies;
+	adapter =3D unit->port->adapter;
+
+	return sprintf(buf, "%u %u %u\n",
+			lat->read.fabric * adapter->timer_ticks / 1000,
+			lat->read.channel * adapter->timer_ticks / 1000,
+			lat->read.counter);
+}
+
+static DEVICE_ATTR(read_latency, S_IRUGO, zfcp_sysfs_unit_read_latency=
_show,
+		   NULL);
+
+static ssize_t
+zfcp_sysfs_unit_write_latency_show(struct device *dev,
+				   struct device_attribute *attr, char *buf) {
+	struct zfcp_unit *unit;
+	struct zfcp_latencies *lat;
+	struct zfcp_adapter *adapter;
+
+	unit =3D dev_get_drvdata(dev);
+	lat =3D &unit->latencies;
+	adapter =3D unit->port->adapter;
+
+	return sprintf(buf, "%u %u %u\n",
+		       lat->write.fabric * adapter->timer_ticks / 1000,
+		       lat->write.channel * adapter->timer_ticks / 1000,
+		       lat->write.counter);
+}
+
+static DEVICE_ATTR(write_latency, S_IRUGO, zfcp_sysfs_unit_write_laten=
cy_show,
+		   NULL);
+
+static ssize_t
+zfcp_sysfs_unit_cmd_latency_show(struct device *dev,
+				 struct device_attribute *attr, char *buf) {
+	struct zfcp_unit *unit;
+	struct zfcp_latencies *lat;
+	struct zfcp_adapter *adapter;
+
+	unit =3D dev_get_drvdata(dev);
+	lat =3D &unit->latencies;
+	adapter =3D unit->port->adapter;
+
+	return sprintf(buf, "%u %u %u\n",
+		       lat->cmd.fabric * adapter->timer_ticks / 1000,
+		       lat->cmd.channel * adapter->timer_ticks / 1000,
+		       lat->cmd.counter);
+}
+
+static DEVICE_ATTR(cmd_latency, S_IRUGO, zfcp_sysfs_unit_cmd_latency_s=
how,
+		   NULL);
+
 static struct attribute *zfcp_unit_attrs[] =3D {
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
=20
Index: HEAD/drivers/s390/scsi/zfcp_ext.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- HEAD.orig/drivers/s390/scsi/zfcp_ext.h
+++ HEAD/drivers/s390/scsi/zfcp_ext.h
@@ -37,6 +37,8 @@ extern int  zfcp_sysfs_unit_create_files
 extern void zfcp_sysfs_unit_remove_files(struct device *);
 extern void zfcp_sysfs_port_release(struct device *);
 extern void zfcp_sysfs_unit_release(struct device *);
+extern int  zfcp_sysfs_statistic_services_create_files(struct device *=
);
+extern void zfcp_sysfs_statistic_services_remove_files(struct device *=
);
=20
 /**************************** CONFIGURATION  *************************=
********/
 extern struct zfcp_unit *zfcp_get_unit_by_lun(struct zfcp_port *, fcp_=
lun_t);
Index: HEAD/drivers/s390/scsi/zfcp_aux.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- HEAD.orig/drivers/s390/scsi/zfcp_aux.c
+++ HEAD/drivers/s390/scsi/zfcp_aux.c
@@ -1067,13 +1067,32 @@ zfcp_adapter_enqueue(struct ccw_device *
 	if (zfcp_sysfs_adapter_create_files(&ccw_device->dev))
 		goto sysfs_failed;
=20
+	adapter->stat_services.parent =3D &adapter->ccw_device->dev;
+	adapter->stat_services.release =3D zfcp_dummy_release;
+	snprintf(adapter->stat_services.bus_id, BUS_ID_SIZE,
+		 "statistic_services");
+	dev_set_drvdata(&adapter->stat_services, adapter);
+
+	if (device_register(&adapter->stat_services))
+		goto services_failed;
+
+	if (zfcp_sysfs_statistic_services_create_files(&adapter->stat_service=
s))
+	{
+		device_unregister(&adapter->stat_services);
+		goto services_failed;
+	}
+
 	adapter->generic_services.parent =3D &adapter->ccw_device->dev;
 	adapter->generic_services.release =3D zfcp_dummy_release;
 	snprintf(adapter->generic_services.bus_id, BUS_ID_SIZE,
 		 "generic_services");
=20
-	if (device_register(&adapter->generic_services))
-		goto generic_services_failed;
+	if (device_register(&adapter->generic_services)) {
+		zfcp_sysfs_statistic_services_remove_files(&adapter->
+							   stat_services);
+		device_unregister(&adapter->stat_services);
+		goto services_failed;
+	}
=20
 	/* put allocated adapter at list tail */
 	write_lock_irq(&zfcp_data.config_lock);
@@ -1085,7 +1104,7 @@ zfcp_adapter_enqueue(struct ccw_device *
=20
 	goto out;
=20
- generic_services_failed:
+ services_failed:
 	zfcp_sysfs_adapter_remove_files(&adapter->ccw_device->dev);
  sysfs_failed:
 	zfcp_adapter_debug_unregister(adapter);
@@ -1118,9 +1137,11 @@ zfcp_adapter_dequeue(struct zfcp_adapter
 	int retval =3D 0;
 	unsigned long flags;
=20
-	zfcp_adapter_scsi_unregister(adapter);
 	device_unregister(&adapter->generic_services);
+	zfcp_sysfs_statistic_services_remove_files(&adapter->stat_services);
+	device_unregister(&adapter->stat_services);
 	zfcp_sysfs_adapter_remove_files(&adapter->ccw_device->dev);
+	zfcp_adapter_scsi_unregister(adapter);
 	dev_set_drvdata(&adapter->ccw_device->dev, NULL);
 	/* sanity check: no pending FSF requests */
 	spin_lock_irqsave(&adapter->req_list_lock, flags);
@@ -1264,6 +1285,7 @@ zfcp_port_enqueue(struct zfcp_adapter *a
=20
 	if (zfcp_sysfs_port_create_files(&port->sysfs_device, status)) {
 		device_unregister(&port->sysfs_device);
+		kfree(port);
 		return NULL;
 	}
=20
Index: HEAD/drivers/s390/scsi/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- HEAD.orig/drivers/s390/scsi/Makefile
+++ HEAD/drivers/s390/scsi/Makefile
@@ -4,6 +4,6 @@
=20
 zfcp-objs :=3D zfcp_aux.o zfcp_ccw.o zfcp_scsi.o zfcp_erp.o zfcp_qdio.=
o \
 	     zfcp_fsf.o zfcp_dbf.o zfcp_sysfs_adapter.o zfcp_sysfs_port.o \
-	     zfcp_sysfs_unit.o zfcp_sysfs_driver.o
+	     zfcp_sysfs_unit.o zfcp_sysfs_driver.o zfcp_sysfs_statistics.o
=20
 obj-$(CONFIG_ZFCP) +=3D zfcp.o
Index: HEAD/drivers/s390/scsi/zfcp_sysfs_statistics.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ HEAD/drivers/s390/scsi/zfcp_sysfs_statistics.c
@@ -0,0 +1,162 @@
+/*
+ * This file is part of the zfcp device driver for
+ * FCP adapters for IBM System z9 and zSeries.
+ *
+ * Copyright IBM Corp. 2007
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
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
+				    struct device_attribute *attr, char *buf)
+{
+	struct zfcp_adapter *adapter;
+	struct fsf_qtcb_bottom_port *qtcb_port;
+	int retval;
+
+	adapter =3D dev_get_drvdata(dev);
+
+	qtcb_port =3D kzalloc(sizeof(struct fsf_qtcb_bottom_port), GFP_KERNEL=
);
+	if (!qtcb_port)
+		return -ENOMEM;
+
+	retval =3D zfcp_fsf_exchange_port_data_sync(adapter, qtcb_port);
+	if (!retval)
+		retval =3D sprintf(buf, "%u %u %u\n", qtcb_port->cp_util,
+				 qtcb_port->cb_util, qtcb_port->a_util);
+	kfree(qtcb_port);
+	return retval;
+}
+
+static DEVICE_ATTR(utilization, S_IRUGO, zfcp_sysfs_adapter_utilizatio=
n_show,
+		   NULL);
+
+static ssize_t
+zfcp_sysfs_adapter_request_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct zfcp_adapter *adapter;
+	struct fsf_qtcb_bottom_config *qtcb_config;
+	int retval;
+
+	adapter =3D dev_get_drvdata(dev);
+
+	qtcb_config =3D kzalloc(sizeof(struct fsf_qtcb_bottom_config),
+			      GFP_KERNEL);
+	if (!qtcb_config)
+		return -ENOMEM;
+
+	retval =3D zfcp_fsf_exchange_config_data_sync(adapter, qtcb_config);
+	if (!retval)
+		retval =3D sprintf(buf, "%lu %lu %lu\n",
+				 qtcb_config->stat_info.input_req,
+				 qtcb_config->stat_info.output_req,
+				 qtcb_config->stat_info.control_req);
+
+	kfree(qtcb_config);
+	return retval;
+}
+
+static DEVICE_ATTR(requests, S_IRUGO, zfcp_sysfs_adapter_request_show,=
 NULL);
+
+static ssize_t
+zfcp_sysfs_adapter_mb_show(struct device *dev,
+			   struct device_attribute *attr, char *buf)
+{
+	struct zfcp_adapter *adapter;
+	struct fsf_qtcb_bottom_config *qtcb_config;
+	int retval;
+
+	adapter =3D dev_get_drvdata(dev);
+
+	qtcb_config =3D kzalloc(sizeof(struct fsf_qtcb_bottom_config),
+			      GFP_KERNEL);
+
+	if (!qtcb_config)
+		return -ENOMEM;
+
+	retval =3D zfcp_fsf_exchange_config_data_sync(adapter, qtcb_config);
+	if (!retval)
+		retval =3D sprintf(buf, "%lu %lu\n",
+				 qtcb_config->stat_info.input_mb,
+				 qtcb_config->stat_info.output_mb);
+
+	kfree(qtcb_config);
+	return retval;
+}
+
+static DEVICE_ATTR(megabytes, S_IRUGO, zfcp_sysfs_adapter_mb_show, NUL=
L);
+
+static ssize_t
+zfcp_sysfs_adapter_seconds_active_show(struct device *dev,
+				       struct device_attribute *attr,
+				       char *buf)
+{
+	struct zfcp_adapter *adapter;
+	struct fsf_qtcb_bottom_config *qtcb_config;
+	int retval;
+
+	adapter =3D dev_get_drvdata(dev);
+
+	qtcb_config =3D kzalloc(sizeof(struct fsf_qtcb_bottom_config),
+			      GFP_KERNEL);
+
+	if (!qtcb_config)
+		return -ENOMEM;
+
+	retval =3D zfcp_fsf_exchange_config_data_sync(adapter, qtcb_config);
+	if (!retval)
+		retval =3D sprintf(buf, "%lu\n",
+				 qtcb_config->stat_info.seconds_act);
+
+	kfree(qtcb_config);
+	return retval;
+}
+
+static DEVICE_ATTR(seconds_active, S_IRUGO,
+		   zfcp_sysfs_adapter_seconds_active_show, NULL);
+
+static struct attribute *zfcp_statistic_services_attrs[] =3D {
+	&dev_attr_utilization.attr,
+	&dev_attr_requests.attr,
+	&dev_attr_megabytes.attr,
+	&dev_attr_seconds_active.attr,
+	NULL
+};
+
+static struct attribute_group zfcp_statistic_services_attr_group =3D {
+	.attrs =3D zfcp_statistic_services_attrs,
+};
+
+int
+zfcp_sysfs_statistic_services_create_files(struct device *dev)
+{
+	return sysfs_create_group(&dev->kobj,
+				  &zfcp_statistic_services_attr_group);
+}
+
+void
+zfcp_sysfs_statistic_services_remove_files(struct device *dev)
+{
+	sysfs_remove_group(&dev->kobj, &zfcp_statistic_services_attr_group);
+}
+
+#undef ZFCP_LOG_AREA
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
