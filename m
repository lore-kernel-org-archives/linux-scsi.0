From: Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: [PATCH] ibmvscs: Add support for fast fail error reporting
Date: Tue, 21 Apr 2009 11:08:33 -0500
Message-ID: <20090421160832.GA21851@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:59943 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbZDUQIf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2009 12:08:35 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n3LG5DaN028238
	for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2009 12:05:13 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3LG8YIK170556
	for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2009 12:08:34 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3LG8X15032062
	for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2009 12:08:34 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, santil@us.ibm.com, sleon@ec.ibm.com, rcj@linux.vnet.ibm.com

A new mode of error reporting, fast fail, has been added to the VIOS
which allows failover to happen more quickly.

If this new fast fail mode is enabled on the VIOS and the vSCSI client
supports the mode, the VIOS will not return MEDIUM error on path failures,
but rather return VIOSRP_ADAPTER_FAIL in the crq response, which 
ibmvscsi will translate to DID_ERROR. 

This new mode can be enabled for single path configurations as well,
so it is the new default error reporting mode. A module parameter is
provided to disable this new behavior on the off chance it causes a
problem on some old VIOS version.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Santiago Leon <santil@us.ibm.com>
Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvscsi.c |   68 ++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/ibmvscsi/viosrp.h   |   14 +++++++-
 2 files changed, 79 insertions(+), 3 deletions(-)

Index: b/drivers/scsi/ibmvscsi/ibmvscsi.c
===================================================================
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -90,6 +90,7 @@ static int max_channel = 3;
 static int init_timeout = 5;
 static int max_requests = IBMVSCSI_MAX_REQUESTS_DEFAULT;
 static int max_events = IBMVSCSI_MAX_REQUESTS_DEFAULT + 2;
+static int fast_fail = 1;
 
 static struct scsi_transport_template *ibmvscsi_transport_template;
 
@@ -110,6 +111,8 @@ module_param_named(init_timeout, init_ti
 MODULE_PARM_DESC(init_timeout, "Initialization timeout in seconds");
 module_param_named(max_requests, max_requests, int, S_IRUGO);
 MODULE_PARM_DESC(max_requests, "Maximum requests for this adapter");
+module_param_named(fast_fail, fast_fail, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(fast_fail, "Enable fast fail. [Default=1]");
 
 /* ------------------------------------------------------------
  * Routines for the event pool and event structs
@@ -969,6 +972,67 @@ static int send_srp_login(struct ibmvscs
 };
 
 /**
+ * fast_fail_rsp: - Handle response to MAD enable fast fail
+ * @evt_struct:	srp_event_struct with the response
+ *
+ * Used as a "done" callback by when sending enable fast fail. Gets called
+ * by ibmvscsi_handle_crq()
+ */
+static void fast_fail_rsp(struct srp_event_struct *evt_struct)
+{
+	struct ibmvscsi_host_data *hostdata = evt_struct->hostdata;
+	u8 status = evt_struct->xfer_iu->mad.fast_fail.common.status;
+
+	if (status == VIOSRP_MAD_NOT_SUPPORTED)
+		dev_err(hostdata->dev, "fast_fail not supported in server\n");
+	else if (status == VIOSRP_MAD_FAILED)
+		dev_err(hostdata->dev, "fast_fail request failed\n");
+	else if (status != VIOSRP_MAD_SUCCESS) {
+		dev_err(hostdata->dev, "error 0x%X enabling fast_fail\n",
+			evt_struct->xfer_iu->mad.fast_fail.common.status);
+	}
+
+	send_srp_login(evt_struct->hostdata);
+}
+
+/**
+ * init_host - Start host initialization
+ * @hostdata:	ibmvscsi_host_data of host
+ *
+ * Returns zero if successful.
+ */
+static int init_host(struct ibmvscsi_host_data *hostdata)
+{
+	int rc;
+	unsigned long flags;
+	struct viosrp_fast_fail *fast_fail_mad;
+	struct srp_event_struct *evt_struct;
+
+	if (!fast_fail)
+		return send_srp_login(hostdata);
+
+	evt_struct = get_event_struct(&hostdata->pool);
+
+	if (!evt_struct) {
+		dev_err(hostdata->dev, "couldn't allocate an event for fast fail init!\n");
+		return send_srp_login(hostdata);
+	}
+
+	init_event_struct(evt_struct, fast_fail_rsp,
+			  VIOSRP_MAD_FORMAT, init_timeout);
+
+	fast_fail_mad = &evt_struct->iu.mad.fast_fail;
+	memset(fast_fail_mad, 0, sizeof(*fast_fail_mad));
+	fast_fail_mad->common.type = VIOSSRP_ENABLE_FAST_FAIL;
+	fast_fail_mad->common.length = sizeof(*fast_fail_mad);
+
+	spin_lock_irqsave(hostdata->host->host_lock, flags);
+	rc = ibmvscsi_send_srp_event(evt_struct, hostdata, init_timeout * 2);
+	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+	return rc;
+}
+
+/**
  * sync_completion: Signal that a synchronous command has completed
  * Note that after returning from this call, the evt_struct is freed.
  * the caller waiting on this completion shouldn't touch the evt_struct
@@ -1281,7 +1345,7 @@ void ibmvscsi_handle_crq(struct viosrp_c
 			if ((rc = ibmvscsi_ops->send_crq(hostdata,
 							 0xC002000000000000LL, 0)) == 0) {
 				/* Now login */
-				send_srp_login(hostdata);
+				init_host(hostdata);
 			} else {
 				dev_err(hostdata->dev, "Unable to send init rsp. rc=%ld\n", rc);
 			}
@@ -1291,7 +1355,7 @@ void ibmvscsi_handle_crq(struct viosrp_c
 			dev_info(hostdata->dev, "partner initialization complete\n");
 
 			/* Now login */
-			send_srp_login(hostdata);
+			init_host(hostdata);
 			break;
 		default:
 			dev_err(hostdata->dev, "unknown crq message type: %d\n", crq->format);
Index: b/drivers/scsi/ibmvscsi/viosrp.h
===================================================================
--- a/drivers/scsi/ibmvscsi/viosrp.h
+++ b/drivers/scsi/ibmvscsi/viosrp.h
@@ -86,7 +86,14 @@ enum viosrp_mad_types {
 	VIOSRP_EMPTY_IU_TYPE = 0x01,
 	VIOSRP_ERROR_LOG_TYPE = 0x02,
 	VIOSRP_ADAPTER_INFO_TYPE = 0x03,
-	VIOSRP_HOST_CONFIG_TYPE = 0x04
+	VIOSRP_HOST_CONFIG_TYPE = 0x04,
+	VIOSSRP_ENABLE_FAST_FAIL = 0x08,
+};
+
+enum viosrp_mad_status {
+	VIOSRP_MAD_SUCCESS = 0x00,
+	VIOSRP_MAD_NOT_SUPPORTED = 0xF1,
+	VIOSRP_MAD_FAILED = 0xF7,
 };
 
 /* 
@@ -127,11 +134,16 @@ struct viosrp_host_config {
 	u64 buffer;
 };
 
+struct viosrp_fast_fail {
+	struct mad_common common;
+};
+
 union mad_iu {
 	struct viosrp_empty_iu empty_iu;
 	struct viosrp_error_log error_log;
 	struct viosrp_adapter_info adapter_info;
 	struct viosrp_host_config host_config;
+	struct viosrp_fast_fail fast_fail;
 };
 
 union viosrp_iu {
