From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCHv2 5/5] ibmvscsi: Add support for capabilities MAD
Date: Mon, 08 Jun 2009 16:19:08 -0500
Message-ID: <200906082119.n58LJ8ME016005@d03av02.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:41679 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755764AbZFHVTI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2009 17:19:08 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n58LHlGR018026
	for <linux-scsi@vger.kernel.org>; Mon, 8 Jun 2009 15:17:47 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n58LJ9fm213390
	for <linux-scsi@vger.kernel.org>; Mon, 8 Jun 2009 15:19:09 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n58LJ9Q7016022
	for <linux-scsi@vger.kernel.org>; Mon, 8 Jun 2009 15:19:09 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Add support to ibmvscsi for the capabilities MAD. This command gets sent
to the Virtual I/O server prior to login in order to communicate client
capabilities. Additionally it returns information regarding capabilities
that the server supports. The two main capabilities communicated in this
MAD are related to partition migration and client reserve. Client reserve
allows for SCSI-2 reservations to be sent to virtual disks which are backed
by physical LUNs and will result in the reservation being sent to the
physical LUN.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvscsi.c |  224 ++++++++++++++++++++++++++++++++++-----
 drivers/scsi/ibmvscsi/ibmvscsi.h |    4 
 drivers/scsi/ibmvscsi/viosrp.h   |   54 +++++++++
 3 files changed, 255 insertions(+), 27 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_client_reserve drivers/scsi/ibmvscsi/ibmvscsi.c
--- scsi-misc-2.6/drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_client_reserve	2009-06-08 15:54:41.000000000 -0500
+++ scsi-misc-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c	2009-06-08 15:54:41.000000000 -0500
@@ -70,6 +70,7 @@
 #include <linux/moduleparam.h>
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
+#include <linux/of.h>
 #include <asm/firmware.h>
 #include <asm/vio.h>
 #include <asm/firmware.h>
@@ -95,6 +96,7 @@ static int reset_timeout = 60;
 static int max_requests = IBMVSCSI_MAX_REQUESTS_DEFAULT;
 static int max_events = IBMVSCSI_MAX_REQUESTS_DEFAULT + 2;
 static int fast_fail = 1;
+static int client_reserve = 1;
 
 static struct scsi_transport_template *ibmvscsi_transport_template;
 
@@ -117,6 +119,8 @@ module_param_named(max_requests, max_req
 MODULE_PARM_DESC(max_requests, "Maximum requests for this adapter");
 module_param_named(fast_fail, fast_fail, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(fast_fail, "Enable fast fail. [Default=1]");
+module_param_named(client_reserve, client_reserve, int, S_IRUGO );
+MODULE_PARM_DESC(client_reserve, "Attempt client managed reserve/release");
 
 /* ------------------------------------------------------------
  * Routines for the event pool and event structs
@@ -790,6 +794,53 @@ static int ibmvscsi_queuecommand(struct
  */
 
 /**
+ * map_persist_bufs: - Pre-map persistent data for adapter logins
+ * @hostdata:   ibmvscsi_host_data of host
+ *
+ * Map the capabilities and adapter info DMA buffers to avoid runtime failures.
+ * Return 1 on error, 0 on success.
+ */
+static int map_persist_bufs(struct ibmvscsi_host_data *hostdata)
+{
+
+	hostdata->caps_addr = dma_map_single(hostdata->dev, &hostdata->caps,
+					     sizeof(hostdata->caps), DMA_BIDIRECTIONAL);
+
+	if (dma_mapping_error(hostdata->dev, hostdata->caps_addr)) {
+		dev_err(hostdata->dev, "Unable to map capabilities buffer!\n");
+		return 1;
+	}
+
+	hostdata->adapter_info_addr = dma_map_single(hostdata->dev,
+						     &hostdata->madapter_info,
+						     sizeof(hostdata->madapter_info),
+						     DMA_BIDIRECTIONAL);
+	if (dma_mapping_error(hostdata->dev, hostdata->adapter_info_addr)) {
+		dev_err(hostdata->dev, "Unable to map adapter info buffer!\n");
+		dma_unmap_single(hostdata->dev, hostdata->caps_addr,
+				 sizeof(hostdata->caps), DMA_BIDIRECTIONAL);
+		return 1;
+	}
+
+	return 0;
+}
+
+/**
+ * unmap_persist_bufs: - Unmap persistent data needed for adapter logins
+ * @hostdata:   ibmvscsi_host_data of host
+ *
+ * Unmap the capabilities and adapter info DMA buffers
+ */
+static void unmap_persist_bufs(struct ibmvscsi_host_data *hostdata)
+{
+	dma_unmap_single(hostdata->dev, hostdata->caps_addr,
+			 sizeof(hostdata->caps), DMA_BIDIRECTIONAL);
+
+	dma_unmap_single(hostdata->dev, hostdata->adapter_info_addr,
+			 sizeof(hostdata->madapter_info), DMA_BIDIRECTIONAL);
+}
+
+/**
  * login_rsp: - Handle response to SRP login request
  * @evt_struct:	srp_event_struct with the response
  *
@@ -817,6 +868,7 @@ static void login_rsp(struct srp_event_s
 	}
 
 	dev_info(hostdata->dev, "SRP_LOGIN succeeded\n");
+	hostdata->client_migrated = 0;
 
 	/* Now we know what the real request-limit is.
 	 * This value is set rather than added to request_limit because
@@ -866,6 +918,93 @@ static int send_srp_login(struct ibmvscs
 };
 
 /**
+ * capabilities_rsp: - Handle response to MAD adapter capabilities request
+ * @evt_struct:	srp_event_struct with the response
+ *
+ * Used as a "done" callback by when sending adapter_info.
+ */
+static void capabilities_rsp(struct srp_event_struct *evt_struct)
+{
+	struct ibmvscsi_host_data *hostdata = evt_struct->hostdata;
+
+	if (evt_struct->xfer_iu->mad.capabilities.common.status) {
+		dev_err(hostdata->dev, "error 0x%X getting capabilities info\n",
+			evt_struct->xfer_iu->mad.capabilities.common.status);
+	} else {
+		if (hostdata->caps.migration.common.server_support != SERVER_SUPPORTS_CAP)
+			dev_info(hostdata->dev, "Partition migration not supported\n");
+
+		if (client_reserve) {
+			if (hostdata->caps.reserve.common.server_support ==
+			    SERVER_SUPPORTS_CAP)
+				dev_info(hostdata->dev, "Client reserve enabled\n");
+			else
+				dev_info(hostdata->dev, "Client reserve not supported\n");
+		}
+	}
+
+	send_srp_login(hostdata);
+}
+
+/**
+ * send_mad_capabilities: - Sends the mad capabilities request
+ *      and stores the result so it can be retrieved with
+ * @hostdata:	ibmvscsi_host_data of host
+ */
+static void send_mad_capabilities(struct ibmvscsi_host_data *hostdata)
+{
+	struct viosrp_capabilities *req;
+	struct srp_event_struct *evt_struct;
+	unsigned long flags;
+	struct device_node *of_node = hostdata->dev->archdata.of_node;
+	const char *location;
+
+	evt_struct = get_event_struct(&hostdata->pool);
+	BUG_ON(!evt_struct);
+
+	init_event_struct(evt_struct, capabilities_rsp,
+			  VIOSRP_MAD_FORMAT, info_timeout);
+
+	req = &evt_struct->iu.mad.capabilities;
+	memset(req, 0, sizeof(*req));
+
+	hostdata->caps.flags = CAP_LIST_SUPPORTED;
+	if (hostdata->client_migrated)
+		hostdata->caps.flags |= CLIENT_MIGRATED;
+
+	strncpy(hostdata->caps.name, dev_name(&hostdata->host->shost_gendev),
+		sizeof(hostdata->caps.name));
+	hostdata->caps.name[sizeof(hostdata->caps.name) - 1] = '\0';
+
+	location = of_get_property(of_node, "ibm,loc-code", NULL);
+	location = location ? location : dev_name(hostdata->dev);
+	strncpy(hostdata->caps.loc, location, sizeof(hostdata->caps.loc));
+	hostdata->caps.loc[sizeof(hostdata->caps.loc) - 1] = '\0';
+
+	req->common.type = VIOSRP_CAPABILITIES_TYPE;
+	req->buffer = hostdata->caps_addr;
+
+	hostdata->caps.migration.common.cap_type = MIGRATION_CAPABILITIES;
+	hostdata->caps.migration.common.length = sizeof(hostdata->caps.migration);
+	hostdata->caps.migration.common.server_support = SERVER_SUPPORTS_CAP;
+	hostdata->caps.migration.ecl = 1;
+
+	if (client_reserve) {
+		hostdata->caps.reserve.common.cap_type = RESERVATION_CAPABILITIES;
+		hostdata->caps.reserve.common.length = sizeof(hostdata->caps.reserve);
+		hostdata->caps.reserve.common.server_support = SERVER_SUPPORTS_CAP;
+		hostdata->caps.reserve.type = CLIENT_RESERVE_SCSI_2;
+		req->common.length = sizeof(hostdata->caps);
+	} else
+		req->common.length = sizeof(hostdata->caps) - sizeof(hostdata->caps.reserve);
+
+	spin_lock_irqsave(hostdata->host->host_lock, flags);
+	if (ibmvscsi_send_srp_event(evt_struct, hostdata, info_timeout * 2))
+		dev_err(hostdata->dev, "couldn't send CAPABILITIES_REQ!\n");
+	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+};
+
+/**
  * fast_fail_rsp: - Handle response to MAD enable fast fail
  * @evt_struct:	srp_event_struct with the response
  *
@@ -884,7 +1023,7 @@ static void fast_fail_rsp(struct srp_eve
 	else if (status != VIOSRP_MAD_SUCCESS)
 		dev_err(hostdata->dev, "error 0x%X enabling fast_fail\n", status);
 
-	send_srp_login(hostdata);
+	send_mad_capabilities(hostdata);
 }
 
 /**
@@ -900,8 +1039,10 @@ static int enable_fast_fail(struct ibmvs
 	struct viosrp_fast_fail *fast_fail_mad;
 	struct srp_event_struct *evt_struct;
 
-	if (!fast_fail)
-		return send_srp_login(hostdata);
+	if (!fast_fail) {
+		send_mad_capabilities(hostdata);
+		return 0;
+	}
 
 	evt_struct = get_event_struct(&hostdata->pool);
 	BUG_ON(!evt_struct);
@@ -929,10 +1070,6 @@ static int enable_fast_fail(struct ibmvs
 static void adapter_info_rsp(struct srp_event_struct *evt_struct)
 {
 	struct ibmvscsi_host_data *hostdata = evt_struct->hostdata;
-	dma_unmap_single(hostdata->dev,
-			 evt_struct->iu.mad.adapter_info.buffer,
-			 evt_struct->iu.mad.adapter_info.common.length,
-			 DMA_BIDIRECTIONAL);
 
 	if (evt_struct->xfer_iu->mad.adapter_info.common.status) {
 		dev_err(hostdata->dev, "error %d getting adapter info\n",
@@ -977,7 +1114,6 @@ static void send_mad_adapter_info(struct
 	struct viosrp_adapter_info *req;
 	struct srp_event_struct *evt_struct;
 	unsigned long flags;
-	dma_addr_t addr;
 
 	evt_struct = get_event_struct(&hostdata->pool);
 	BUG_ON(!evt_struct);
@@ -992,28 +1128,11 @@ static void send_mad_adapter_info(struct
 	
 	req->common.type = VIOSRP_ADAPTER_INFO_TYPE;
 	req->common.length = sizeof(hostdata->madapter_info);
-	req->buffer = addr = dma_map_single(hostdata->dev,
-					    &hostdata->madapter_info,
-					    sizeof(hostdata->madapter_info),
-					    DMA_BIDIRECTIONAL);
+	req->buffer = hostdata->adapter_info_addr;
 
-	if (dma_mapping_error(hostdata->dev, req->buffer)) {
-		if (!firmware_has_feature(FW_FEATURE_CMO))
-			dev_err(hostdata->dev,
-			        "Unable to map request_buffer for "
-			        "adapter_info!\n");
-		free_event_struct(&hostdata->pool, evt_struct);
-		return;
-	}
-	
 	spin_lock_irqsave(hostdata->host->host_lock, flags);
-	if (ibmvscsi_send_srp_event(evt_struct, hostdata, info_timeout * 2)) {
+	if (ibmvscsi_send_srp_event(evt_struct, hostdata, info_timeout * 2))
 		dev_err(hostdata->dev, "couldn't send ADAPTER_INFO_REQ!\n");
-		dma_unmap_single(hostdata->dev,
-				 addr,
-				 sizeof(hostdata->madapter_info),
-				 DMA_BIDIRECTIONAL);
-	}
 	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
 };
 
@@ -1361,6 +1480,7 @@ void ibmvscsi_handle_crq(struct viosrp_c
 		if (crq->format == 0x06) {
 			/* We need to re-setup the interpartition connection */
 			dev_info(hostdata->dev, "Re-enabling adapter!\n");
+			hostdata->client_migrated = 1;
 			purge_requests(hostdata, DID_REQUEUE);
 			if ((ibmvscsi_ops->reenable_crq_queue(&hostdata->queue,
 							      hostdata)) ||
@@ -1529,6 +1649,46 @@ static int ibmvscsi_change_queue_depth(s
 /* ------------------------------------------------------------
  * sysfs attributes
  */
+static ssize_t show_host_vhost_loc(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct ibmvscsi_host_data *hostdata = shost_priv(shost);
+	int len;
+
+	len = snprintf(buf, sizeof(hostdata->caps.loc), "%s\n",
+		       hostdata->caps.loc);
+	return len;
+}
+
+static struct device_attribute ibmvscsi_host_vhost_loc = {
+	.attr = {
+		 .name = "vhost_loc",
+		 .mode = S_IRUGO,
+		 },
+	.show = show_host_vhost_loc,
+};
+
+static ssize_t show_host_vhost_name(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct ibmvscsi_host_data *hostdata = shost_priv(shost);
+	int len;
+
+	len = snprintf(buf, sizeof(hostdata->caps.name), "%s\n",
+		       hostdata->caps.name);
+	return len;
+}
+
+static struct device_attribute ibmvscsi_host_vhost_name = {
+	.attr = {
+		 .name = "vhost_name",
+		 .mode = S_IRUGO,
+		 },
+	.show = show_host_vhost_name,
+};
+
 static ssize_t show_host_srp_version(struct device *dev,
 				     struct device_attribute *attr, char *buf)
 {
@@ -1652,6 +1812,8 @@ static struct device_attribute ibmvscsi_
 };
 
 static struct device_attribute *ibmvscsi_attrs[] = {
+	&ibmvscsi_host_vhost_loc,
+	&ibmvscsi_host_vhost_name,
 	&ibmvscsi_host_srp_version,
 	&ibmvscsi_host_partition_name,
 	&ibmvscsi_host_partition_number,
@@ -1732,6 +1894,11 @@ static int ibmvscsi_probe(struct vio_dev
 	atomic_set(&hostdata->request_limit, -1);
 	hostdata->host->max_sectors = IBMVSCSI_MAX_SECTORS_DEFAULT;
 
+	if (map_persist_bufs(hostdata)) {
+		dev_err(&vdev->dev, "couldn't map persistent buffers\n");
+		goto persist_bufs_failed;
+	}
+
 	rc = ibmvscsi_ops->init_crq_queue(&hostdata->queue, hostdata, max_events);
 	if (rc != 0 && rc != H_RESOURCE) {
 		dev_err(&vdev->dev, "couldn't initialize crq. rc=%d\n", rc);
@@ -1792,6 +1959,8 @@ static int ibmvscsi_probe(struct vio_dev
       init_pool_failed:
 	ibmvscsi_ops->release_crq_queue(&hostdata->queue, hostdata, max_events);
       init_crq_failed:
+	unmap_persist_bufs(hostdata);
+      persist_bufs_failed:
 	scsi_host_put(host);
       scsi_host_alloc_failed:
 	return -1;
@@ -1800,6 +1969,7 @@ static int ibmvscsi_probe(struct vio_dev
 static int ibmvscsi_remove(struct vio_dev *vdev)
 {
 	struct ibmvscsi_host_data *hostdata = vdev->dev.driver_data;
+	unmap_persist_bufs(hostdata);
 	release_event_pool(&hostdata->pool, hostdata);
 	ibmvscsi_ops->release_crq_queue(&hostdata->queue, hostdata,
 					max_events);
diff -puN drivers/scsi/ibmvscsi/ibmvscsi.h~ibmvscsi_client_reserve drivers/scsi/ibmvscsi/ibmvscsi.h
--- scsi-misc-2.6/drivers/scsi/ibmvscsi/ibmvscsi.h~ibmvscsi_client_reserve	2009-06-08 15:54:41.000000000 -0500
+++ scsi-misc-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.h	2009-06-08 15:54:41.000000000 -0500
@@ -90,6 +90,7 @@ struct event_pool {
 /* all driver data associated with a host adapter */
 struct ibmvscsi_host_data {
 	atomic_t request_limit;
+	int client_migrated;
 	struct device *dev;
 	struct event_pool pool;
 	struct crq_queue queue;
@@ -97,6 +98,9 @@ struct ibmvscsi_host_data {
 	struct list_head sent;
 	struct Scsi_Host *host;
 	struct mad_adapter_info_data madapter_info;
+	struct capabilities caps;
+	dma_addr_t caps_addr;
+	dma_addr_t adapter_info_addr;
 };
 
 /* routines for managing a command/response queue */
diff -puN drivers/scsi/ibmvscsi/viosrp.h~ibmvscsi_client_reserve drivers/scsi/ibmvscsi/viosrp.h
--- scsi-misc-2.6/drivers/scsi/ibmvscsi/viosrp.h~ibmvscsi_client_reserve	2009-06-08 15:54:41.000000000 -0500
+++ scsi-misc-2.6-bjking1/drivers/scsi/ibmvscsi/viosrp.h	2009-06-08 15:54:41.000000000 -0500
@@ -37,6 +37,7 @@
 
 #define SRP_VERSION "16.a"
 #define SRP_MAX_IU_LEN	256
+#define SRP_MAX_LOC_LEN 32
 
 union srp_iu {
 	struct srp_login_req login_req;
@@ -87,6 +88,7 @@ enum viosrp_mad_types {
 	VIOSRP_ERROR_LOG_TYPE = 0x02,
 	VIOSRP_ADAPTER_INFO_TYPE = 0x03,
 	VIOSRP_HOST_CONFIG_TYPE = 0x04,
+	VIOSRP_CAPABILITIES_TYPE = 0x05,
 	VIOSRP_ENABLE_FAST_FAIL = 0x08,
 };
 
@@ -96,6 +98,28 @@ enum viosrp_mad_status {
 	VIOSRP_MAD_FAILED = 0xF7,
 };
 
+enum viosrp_capability_type {
+	MIGRATION_CAPABILITIES = 0x01,
+	RESERVATION_CAPABILITIES = 0x02,
+};
+
+enum viosrp_capability_support {
+	SERVER_DOES_NOT_SUPPORTS_CAP = 0x0,
+	SERVER_SUPPORTS_CAP = 0x01,
+	SERVER_CAP_DATA = 0x02,
+};
+
+enum viosrp_reserve_type {
+	CLIENT_RESERVE_SCSI_2 = 0x01,
+};
+
+enum viosrp_capability_flag {
+	CLIENT_MIGRATED = 0x01,
+	CLIENT_RECONNECT = 0x02,
+	CAP_LIST_SUPPORTED = 0x04,
+	CAP_LIST_DATA = 0x08,
+};
+
 /* 
  * Common MAD header
  */
@@ -138,12 +162,42 @@ struct viosrp_fast_fail {
 	struct mad_common common;
 };
 
+struct viosrp_capabilities {
+	struct mad_common common;
+	u64 buffer;
+};
+
+struct mad_capability_common {
+	u32 cap_type;
+	u16 length;
+	u16 server_support;
+};
+
+struct mad_reserve_cap {
+	struct mad_capability_common common;
+	u32 type;
+};
+
+struct mad_migration_cap {
+	struct mad_capability_common common;
+	u32 ecl;
+};
+
+struct capabilities{
+	u32 flags;
+	char name[SRP_MAX_LOC_LEN];
+	char loc[SRP_MAX_LOC_LEN];
+	struct mad_migration_cap migration;
+	struct mad_reserve_cap reserve;
+};
+
 union mad_iu {
 	struct viosrp_empty_iu empty_iu;
 	struct viosrp_error_log error_log;
 	struct viosrp_adapter_info adapter_info;
 	struct viosrp_host_config host_config;
 	struct viosrp_fast_fail fast_fail;
+	struct viosrp_capabilities capabilities;
 };
 
 union viosrp_iu {
_
