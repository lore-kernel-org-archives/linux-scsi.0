From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 3/3] zfcp: Add some statistics provided by the FCP adapter to the sysfs
Date: Thu, 24 Apr 2008 19:35:54 +0200
Message-ID: <20080424174056.230867000@de.ibm.com>
References: <20080424173551.821393000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:2060 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbYDXRk7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Apr 2008 13:40:59 -0400
Content-Disposition: inline; filename=zfcp-stat-sysfs.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

The new FCP adapter statistics provide a variety of information about
the virtual adapter (subchannel). In order to collect this information
the zfcp driver is extended to query this information.

The information provided by the new FCP adapter statistics can be
fetched by reading from the following files in the sysfs filesystem

/sys/class/scsi_host/host<n>/seconds_active
/sys/class/scsi_host/host<n>/requests
/sys/class/scsi_host/host<n>/megabytes
/sys/class/scsi_host/host<n>/utilization

These are the statistics on a virtual adapter (subchannel) level.

The information provided is raw and not modified or interpreted by any
means.  No interpretation or modification of the values is done by the
zfcp driver.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_fsf.h  |   18 +++++-
 drivers/s390/scsi/zfcp_scsi.c |  114 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 130 insertions(+), 2 deletions(-)

--- a/drivers/s390/scsi/zfcp_fsf.h	2008-04-24 15:06:33.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.h	2008-04-24 15:06:42.000000000 +0200
@@ -213,6 +213,7 @@
 #define FSF_FEATURE_HBAAPI_MANAGEMENT           0x00000010
 #define FSF_FEATURE_ELS_CT_CHAINED_SBALS        0x00000020
 #define FSF_FEATURE_UPDATE_ALERT		0x00000100
+#define FSF_FEATURE_MEASUREMENT_DATA		0x00000200
 
 /* host connection features */
 #define FSF_FEATURE_NPIV_MODE			0x00000001
@@ -340,6 +341,15 @@ struct fsf_qtcb_prefix {
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
@@ -436,7 +446,8 @@ struct fsf_qtcb_bottom_config {
 	u32 hardware_version;
 	u8 serial_number[32];
 	struct fsf_nport_serv_param plogi_payload;
-	u8 res4[160];
+	struct fsf_statistics_info stat_info;
+	u8 res4[112];
 } __attribute__ ((packed));
 
 struct fsf_qtcb_bottom_port {
@@ -469,7 +480,10 @@ struct fsf_qtcb_bottom_port {
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
--- a/drivers/s390/scsi/zfcp_scsi.c	2008-04-24 15:06:33.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_scsi.c	2008-04-24 15:06:42.000000000 +0200
@@ -40,6 +40,7 @@ static struct zfcp_unit *zfcp_unit_looku
 					  unsigned int, unsigned int);
 
 static struct device_attribute *zfcp_sysfs_sdev_attrs[];
+static struct device_attribute *zfcp_a_stats_attrs[];
 
 struct zfcp_data zfcp_data = {
 	.scsi_host_template = {
@@ -61,6 +62,7 @@ struct zfcp_data zfcp_data = {
 		.use_clustering		= 1,
 		.sdev_attrs		= zfcp_sysfs_sdev_attrs,
 		.max_sectors		= ZFCP_MAX_SECTORS,
+		.shost_attrs		= zfcp_a_stats_attrs,
 	},
 	.driver_version = ZFCP_VERSION,
 };
@@ -809,4 +811,116 @@ static struct device_attribute *zfcp_sys
 	NULL
 };
 
+static ssize_t zfcp_sysfs_adapter_util_show(struct device *dev,
+					    struct device_attribute *attr,
+					    char *buf)
+{
+	struct Scsi_Host *scsi_host = dev_to_shost(dev);
+	struct fsf_qtcb_bottom_port *qtcb_port;
+	int retval;
+	struct zfcp_adapter *adapter;
+
+	adapter = (struct zfcp_adapter *) scsi_host->hostdata[0];
+	if (!(adapter->adapter_features & FSF_FEATURE_MEASUREMENT_DATA))
+		return -EOPNOTSUPP;
+
+	qtcb_port = kzalloc(sizeof(struct fsf_qtcb_bottom_port), GFP_KERNEL);
+	if (!qtcb_port)
+		return -ENOMEM;
+
+	retval = zfcp_fsf_exchange_port_data_sync(adapter, qtcb_port);
+	if (!retval)
+		retval = sprintf(buf, "%u %u %u\n", qtcb_port->cp_util,
+				 qtcb_port->cb_util, qtcb_port->a_util);
+	kfree(qtcb_port);
+	return retval;
+}
+
+static int zfcp_sysfs_adapter_ex_config(struct device *dev,
+					struct fsf_statistics_info *stat_inf)
+{
+	int retval;
+	struct fsf_qtcb_bottom_config *qtcb_config;
+	struct Scsi_Host *scsi_host = dev_to_shost(dev);
+	struct zfcp_adapter *adapter;
+
+	adapter = (struct zfcp_adapter *) scsi_host->hostdata[0];
+	if (!(adapter->adapter_features & FSF_FEATURE_MEASUREMENT_DATA))
+		return -EOPNOTSUPP;
+
+	qtcb_config = kzalloc(sizeof(struct fsf_qtcb_bottom_config),
+			       GFP_KERNEL);
+	if (!qtcb_config)
+		return -ENOMEM;
+
+	retval = zfcp_fsf_exchange_config_data_sync(adapter, qtcb_config);
+	if (!retval)
+		*stat_inf = qtcb_config->stat_info;
+
+	kfree(qtcb_config);
+	return retval;
+}
+
+static ssize_t zfcp_sysfs_adapter_request_show(struct device *dev,
+					       struct device_attribute *attr,
+					       char *buf)
+{
+	struct fsf_statistics_info stat_info;
+	int retval;
+
+	retval = zfcp_sysfs_adapter_ex_config(dev, &stat_info);
+	if (retval)
+		return retval;
+
+	return sprintf(buf, "%llu %llu %llu\n",
+		       (unsigned long long) stat_info.input_req,
+		       (unsigned long long) stat_info.output_req,
+		       (unsigned long long) stat_info.control_req);
+}
+
+static ssize_t zfcp_sysfs_adapter_mb_show(struct device *dev,
+					  struct device_attribute *attr,
+					  char *buf)
+{
+	struct fsf_statistics_info stat_info;
+	int retval;
+
+	retval = zfcp_sysfs_adapter_ex_config(dev, &stat_info);
+	if (retval)
+		return retval;
+
+	return sprintf(buf, "%llu %llu\n",
+		       (unsigned long long) stat_info.input_mb,
+		       (unsigned long long) stat_info.output_mb);
+}
+
+static ssize_t zfcp_sysfs_adapter_sec_active_show(struct device *dev,
+						  struct device_attribute *attr,
+						  char *buf)
+{
+	struct fsf_statistics_info stat_info;
+	int retval;
+
+	retval = zfcp_sysfs_adapter_ex_config(dev, &stat_info);
+	if (retval)
+		return retval;
+
+	return sprintf(buf, "%llu\n",
+		       (unsigned long long) stat_info.seconds_act);
+}
+
+static DEVICE_ATTR(utilization, S_IRUGO, zfcp_sysfs_adapter_util_show, NULL);
+static DEVICE_ATTR(requests, S_IRUGO, zfcp_sysfs_adapter_request_show, NULL);
+static DEVICE_ATTR(megabytes, S_IRUGO, zfcp_sysfs_adapter_mb_show, NULL);
+static DEVICE_ATTR(seconds_active, S_IRUGO,
+		   zfcp_sysfs_adapter_sec_active_show, NULL);
+
+static struct device_attribute *zfcp_a_stats_attrs[] = {
+	&dev_attr_utilization,
+	&dev_attr_requests,
+	&dev_attr_megabytes,
+	&dev_attr_seconds_active,
+	NULL
+};
+
 #undef ZFCP_LOG_AREA

-- 
