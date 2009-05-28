From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 07/10] ibmvfc: Add flush on halt support
Date: Thu, 28 May 2009 16:17:30 -0500
Message-ID: <200905282117.n4SLHUoe032746@d03av01.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:45744 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763916AbZE1VRm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2009 17:17:42 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n4SLBBrZ022686
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2009 15:11:11 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n4SLHV0U199164
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2009 15:17:32 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n4SLHVUV032762
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2009 15:17:31 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


The virtual I/O server controlling the NPIV adapter associated with
a virtual fibre channel adapter can send a HALT event to the client.
When this occurs, the client can no longer send commands until a RESUME
is received. By adding support for flush on halt, we will get all of
our outstanding commands flushed back before the Virtual I/O server
enters the halt state, eliminating potential command timeouts for
outstanding commands which might occur if we did not support this feature. 

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |   34 +++++++++++++++++++++++++++++++---
 drivers/scsi/ibmvscsi/ibmvfc.h |   13 +++++++++++--
 2 files changed, 42 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_flush_on_halt drivers/scsi/ibmvscsi/ibmvfc.h
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_flush_on_halt	2009-05-05 16:26:52.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.h	2009-05-05 16:26:52.000000000 -0500
@@ -207,7 +207,8 @@ struct ibmvfc_npiv_login_resp {
 #define IBMVFC_NATIVE_FC		0x01
 #define IBMVFC_CAN_FLUSH_ON_HALT	0x08
 	u32 reserved;
-	u64 capabilites;
+	u64 capabilities;
+#define IBMVFC_CAN_FLUSH_ON_HALT	0x08
 	u32 max_cmds;
 	u32 scsi_id_sz;
 	u64 max_dma_len;
@@ -547,9 +548,17 @@ struct ibmvfc_crq_queue {
 	dma_addr_t msg_token;
 };
 
+enum ibmvfc_ae_link_state {
+	IBMVFC_AE_LS_LINK_UP		= 0x01,
+	IBMVFC_AE_LS_LINK_BOUNCED	= 0x02,
+	IBMVFC_AE_LS_LINK_DOWN		= 0x04,
+	IBMVFC_AE_LS_LINK_DEAD		= 0x08,
+};
+
 struct ibmvfc_async_crq {
 	volatile u8 valid;
-	u8 pad[3];
+	u8 link_state;
+	u8 pad[2];
 	u32 pad2;
 	volatile u64 event;
 	volatile u64 scsi_id;
diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_flush_on_halt drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_flush_on_halt	2009-05-05 16:26:52.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2009-05-08 17:19:56.000000000 -0500
@@ -110,7 +110,7 @@ static const struct {
 	{ IBMVFC_FABRIC_MAPPED, IBMVFC_XPORT_DEAD, DID_ERROR, 0, 1, "transport dead" },
 	{ IBMVFC_FABRIC_MAPPED, IBMVFC_CONFIG_ERROR, DID_ERROR, 1, 1, "configuration error" },
 	{ IBMVFC_FABRIC_MAPPED, IBMVFC_NAME_SERVER_FAIL, DID_ERROR, 1, 1, "name server failure" },
-	{ IBMVFC_FABRIC_MAPPED, IBMVFC_LINK_HALTED, DID_REQUEUE, 0, 0, "link halted" },
+	{ IBMVFC_FABRIC_MAPPED, IBMVFC_LINK_HALTED, DID_REQUEUE, 1, 0, "link halted" },
 	{ IBMVFC_FABRIC_MAPPED, IBMVFC_XPORT_GENERAL, DID_OK, 1, 0, "general transport error" },
 
 	{ IBMVFC_VIOS_FAILURE, IBMVFC_CRQ_FAILURE, DID_REQUEUE, 1, 1, "CRQ failure" },
@@ -1169,8 +1169,9 @@ static void ibmvfc_set_login_info(struct
 	login_info->partition_num = vhost->partition_number;
 	login_info->vfc_frame_version = 1;
 	login_info->fcp_version = 3;
+	login_info->flags = IBMVFC_FLUSH_ON_HALT;
 	if (vhost->client_migrated)
-		login_info->flags = IBMVFC_CLIENT_MIGRATED;
+		login_info->flags |= IBMVFC_CLIENT_MIGRATED;
 
 	login_info->max_cmds = max_requests + IBMVFC_NUM_INTERNAL_REQ;
 	login_info->capabilities = IBMVFC_CAN_MIGRATE;
@@ -2185,8 +2186,25 @@ static void ibmvfc_handle_async(struct i
 		   " node_name: %llx\n", desc, crq->scsi_id, crq->wwpn, crq->node_name);
 
 	switch (crq->event) {
-	case IBMVFC_AE_LINK_UP:
 	case IBMVFC_AE_RESUME:
+		switch (crq->link_state) {
+		case IBMVFC_AE_LS_LINK_DOWN:
+			ibmvfc_link_down(vhost, IBMVFC_LINK_DOWN);
+			break;
+		case IBMVFC_AE_LS_LINK_DEAD:
+			ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
+			break;
+		case IBMVFC_AE_LS_LINK_UP:
+		case IBMVFC_AE_LS_LINK_BOUNCED:
+		default:
+			vhost->events_to_log |= IBMVFC_AE_LINKUP;
+			vhost->delay_init = 1;
+			__ibmvfc_reset_host(vhost);
+			break;
+		};
+
+		break;
+	case IBMVFC_AE_LINK_UP:
 		vhost->events_to_log |= IBMVFC_AE_LINKUP;
 		vhost->delay_init = 1;
 		__ibmvfc_reset_host(vhost);
@@ -2505,6 +2523,14 @@ static ssize_t ibmvfc_show_host_npiv_ver
 	return snprintf(buf, PAGE_SIZE, "%d\n", vhost->login_buf->resp.version);
 }
 
+static ssize_t ibmvfc_show_host_capabilities(struct device *dev,
+					     struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct ibmvfc_host *vhost = shost_priv(shost);
+	return snprintf(buf, PAGE_SIZE, "%llx\n", vhost->login_buf->resp.capabilities);
+}
+
 /**
  * ibmvfc_show_log_level - Show the adapter's error logging level
  * @dev:	class device struct
@@ -2554,6 +2580,7 @@ static DEVICE_ATTR(device_name, S_IRUGO,
 static DEVICE_ATTR(port_loc_code, S_IRUGO, ibmvfc_show_host_loc_code, NULL);
 static DEVICE_ATTR(drc_name, S_IRUGO, ibmvfc_show_host_drc_name, NULL);
 static DEVICE_ATTR(npiv_version, S_IRUGO, ibmvfc_show_host_npiv_version, NULL);
+static DEVICE_ATTR(capabilities, S_IRUGO, ibmvfc_show_host_capabilities, NULL);
 static DEVICE_ATTR(log_level, S_IRUGO | S_IWUSR,
 		   ibmvfc_show_log_level, ibmvfc_store_log_level);
 
@@ -2609,6 +2636,7 @@ static struct device_attribute *ibmvfc_a
 	&dev_attr_port_loc_code,
 	&dev_attr_drc_name,
 	&dev_attr_npiv_version,
+	&dev_attr_capabilities,
 	&dev_attr_log_level,
 	NULL
 };
_
