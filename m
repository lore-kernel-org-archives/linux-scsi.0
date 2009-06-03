From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 3/4] ibmvscsi: Enable fast fail feature
Date: Wed, 03 Jun 2009 10:00:03 -0500
Message-ID: <4A268FF3.80805@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:51752 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507AbZFCPAK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jun 2009 11:00:10 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e39.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n53EuFnd006040
	for <linux-scsi@vger.kernel.org>; Wed, 3 Jun 2009 08:56:15 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n53F08qQ155692
	for <linux-scsi@vger.kernel.org>; Wed, 3 Jun 2009 09:00:09 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n53F04c5023095
	for <linux-scsi@vger.kernel.org>; Wed, 3 Jun 2009 09:00:08 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Robert Jennings <rcj@linux.vnet.ibm.com>


From: Robert Jennings <rcj@linux.vnet.ibm.com>

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
---

 drivers/scsi/ibmvscsi/ibmvscsi.c |   59 ++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/ibmvscsi/viosrp.h   |   14 ++++++++-
 2 files changed, 71 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_fastfail drivers/scsi/ibmvscsi/ibmvscsi.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_fastfail	2009-06-03 09:32:22.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c	2009-06-03 09:32:22.000000000 -0500
@@ -94,6 +94,7 @@ static int abort_timeout = 60;
 static int reset_timeout = 60;
 static int max_requests = IBMVSCSI_MAX_REQUESTS_DEFAULT;
 static int max_events = IBMVSCSI_MAX_REQUESTS_DEFAULT + 2;
+static int fast_fail = 1;
 
 static struct scsi_transport_template *ibmvscsi_transport_template;
 
@@ -114,6 +115,8 @@ module_param_named(init_timeout, init_ti
 MODULE_PARM_DESC(init_timeout, "Initialization timeout in seconds");
 module_param_named(max_requests, max_requests, int, S_IRUGO);
 MODULE_PARM_DESC(max_requests, "Maximum requests for this adapter");
+module_param_named(fast_fail, fast_fail, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(fast_fail, "Enable fast fail. [Default=1]");
 
 /* ------------------------------------------------------------
  * Routines for the event pool and event structs
@@ -863,6 +866,60 @@ static int send_srp_login(struct ibmvscs
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
+	else if (status != VIOSRP_MAD_SUCCESS)
+		dev_err(hostdata->dev, "error 0x%X enabling fast_fail\n", status);
+
+	send_srp_login(hostdata);
+}
+
+/**
+ * init_host - Start host initialization
+ * @hostdata:	ibmvscsi_host_data of host
+ *
+ * Returns zero if successful.
+ */
+static int enable_fast_fail(struct ibmvscsi_host_data *hostdata)
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
+	BUG_ON(!evt_struct);
+
+	init_event_struct(evt_struct, fast_fail_rsp, VIOSRP_MAD_FORMAT, info_timeout);
+
+	fast_fail_mad = &evt_struct->iu.mad.fast_fail;
+	memset(fast_fail_mad, 0, sizeof(*fast_fail_mad));
+	fast_fail_mad->common.type = VIOSRP_ENABLE_FAST_FAIL;
+	fast_fail_mad->common.length = sizeof(*fast_fail_mad);
+
+	spin_lock_irqsave(hostdata->host->host_lock, flags);
+	rc = ibmvscsi_send_srp_event(evt_struct, hostdata, info_timeout * 2);
+	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+	return rc;
+}
+
+/**
  * adapter_info_rsp: - Handle response to MAD adapter info request
  * @evt_struct:	srp_event_struct with the response
  *
@@ -903,7 +960,7 @@ static void adapter_info_rsp(struct srp_
 		}
 	}
 
-	send_srp_login(hostdata);
+	enable_fast_fail(hostdata);
 }
 
 /**
diff -puN drivers/scsi/ibmvscsi/viosrp.h~ibmvscsi_fastfail drivers/scsi/ibmvscsi/viosrp.h
--- linux-2.6/drivers/scsi/ibmvscsi/viosrp.h~ibmvscsi_fastfail	2009-06-03 09:32:22.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/viosrp.h	2009-06-03 09:32:22.000000000 -0500
@@ -86,7 +86,14 @@ enum viosrp_mad_types {
 	VIOSRP_EMPTY_IU_TYPE = 0x01,
 	VIOSRP_ERROR_LOG_TYPE = 0x02,
 	VIOSRP_ADAPTER_INFO_TYPE = 0x03,
-	VIOSRP_HOST_CONFIG_TYPE = 0x04
+	VIOSRP_HOST_CONFIG_TYPE = 0x04,
+	VIOSRP_ENABLE_FAST_FAIL = 0x08,
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
_
