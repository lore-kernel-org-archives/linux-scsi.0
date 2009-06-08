From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCHv2 3/5] ibmvscsi: Send adapter info before login
Date: Mon, 08 Jun 2009 16:19:04 -0500
Message-ID: <200906082119.n58LJ4En023581@d03av04.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:45486 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526AbZFHVTK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2009 17:19:10 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e37.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n58LIXJm026634
	for <linux-scsi@vger.kernel.org>; Mon, 8 Jun 2009 15:18:33 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n58LJCNC263566
	for <linux-scsi@vger.kernel.org>; Mon, 8 Jun 2009 15:19:12 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n58LJ8ZX023729
	for <linux-scsi@vger.kernel.org>; Mon, 8 Jun 2009 15:19:12 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


The ibmvscsi driver currently sends the SRP Login before sending the Adapter
Info MAD, which can result in commands getting sent to the virtual adapter
before we are ready for them. This results in a slight window where the target
devices may not behave as expected. Change the order and close the window.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvscsi.c |  170 +++++++++++++++++++--------------------
 1 file changed, 85 insertions(+), 85 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_adapter_info drivers/scsi/ibmvscsi/ibmvscsi.c
--- scsi-misc-2.6/drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_adapter_info	2009-06-08 15:54:18.000000000 -0500
+++ scsi-misc-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c	2009-06-08 15:54:36.000000000 -0500
@@ -785,6 +785,83 @@ static int ibmvscsi_queuecommand(struct
 /* ------------------------------------------------------------
  * Routines for driver initialization
  */
+
+/**
+ * login_rsp: - Handle response to SRP login request
+ * @evt_struct:	srp_event_struct with the response
+ *
+ * Used as a "done" callback by when sending srp_login. Gets called
+ * by ibmvscsi_handle_crq()
+*/
+static void login_rsp(struct srp_event_struct *evt_struct)
+{
+	struct ibmvscsi_host_data *hostdata = evt_struct->hostdata;
+	switch (evt_struct->xfer_iu->srp.login_rsp.opcode) {
+	case SRP_LOGIN_RSP:	/* it worked! */
+		break;
+	case SRP_LOGIN_REJ:	/* refused! */
+		dev_info(hostdata->dev, "SRP_LOGIN_REJ reason %u\n",
+			 evt_struct->xfer_iu->srp.login_rej.reason);
+		/* Login failed.  */
+		atomic_set(&hostdata->request_limit, -1);
+		return;
+	default:
+		dev_err(hostdata->dev, "Invalid login response typecode 0x%02x!\n",
+			evt_struct->xfer_iu->srp.login_rsp.opcode);
+		/* Login failed.  */
+		atomic_set(&hostdata->request_limit, -1);
+		return;
+	}
+
+	dev_info(hostdata->dev, "SRP_LOGIN succeeded\n");
+
+	/* Now we know what the real request-limit is.
+	 * This value is set rather than added to request_limit because
+	 * request_limit could have been set to -1 by this client.
+	 */
+	atomic_set(&hostdata->request_limit,
+		   evt_struct->xfer_iu->srp.login_rsp.req_lim_delta);
+
+	/* If we had any pending I/Os, kick them */
+	scsi_unblock_requests(hostdata->host);
+}
+
+/**
+ * send_srp_login: - Sends the srp login
+ * @hostdata:	ibmvscsi_host_data of host
+ *
+ * Returns zero if successful.
+*/
+static int send_srp_login(struct ibmvscsi_host_data *hostdata)
+{
+	int rc;
+	unsigned long flags;
+	struct srp_login_req *login;
+	struct srp_event_struct *evt_struct = get_event_struct(&hostdata->pool);
+
+	BUG_ON(!evt_struct);
+	init_event_struct(evt_struct, login_rsp,
+			  VIOSRP_SRP_FORMAT, login_timeout);
+
+	login = &evt_struct->iu.srp.login_req;
+	memset(login, 0, sizeof(*login));
+	login->opcode = SRP_LOGIN_REQ;
+	login->req_it_iu_len = sizeof(union srp_iu);
+	login->req_buf_fmt = SRP_BUF_FORMAT_DIRECT | SRP_BUF_FORMAT_INDIRECT;
+
+	spin_lock_irqsave(hostdata->host->host_lock, flags);
+	/* Start out with a request limit of 0, since this is negotiated in
+	 * the login request we are just sending and login requests always
+	 * get sent by the driver regardless of request_limit.
+	 */
+	atomic_set(&hostdata->request_limit, 0);
+
+	rc = ibmvscsi_send_srp_event(evt_struct, hostdata, login_timeout * 2);
+	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+	dev_info(hostdata->dev, "sent SRP login\n");
+	return rc;
+};
+
 /**
  * adapter_info_rsp: - Handle response to MAD adapter info request
  * @evt_struct:	srp_event_struct with the response
@@ -825,6 +902,8 @@ static void adapter_info_rsp(struct srp_
 			hostdata->host->sg_tablesize = MAX_INDIRECT_BUFS;
 		}
 	}
+
+	send_srp_login(hostdata);
 }
 
 /**
@@ -844,11 +923,7 @@ static void send_mad_adapter_info(struct
 	dma_addr_t addr;
 
 	evt_struct = get_event_struct(&hostdata->pool);
-	if (!evt_struct) {
-		dev_err(hostdata->dev,
-			"couldn't allocate an event for ADAPTER_INFO_REQ!\n");
-		return;
-	}
+	BUG_ON(!evt_struct);
 
 	init_event_struct(evt_struct,
 			  adapter_info_rsp,
@@ -886,90 +961,15 @@ static void send_mad_adapter_info(struct
 };
 
 /**
- * login_rsp: - Handle response to SRP login request
- * @evt_struct:	srp_event_struct with the response
+ * init_adapter: Start virtual adapter initialization sequence
  *
- * Used as a "done" callback by when sending srp_login. Gets called
- * by ibmvscsi_handle_crq()
-*/
-static void login_rsp(struct srp_event_struct *evt_struct)
+ */
+static void init_adapter(struct ibmvscsi_host_data *hostdata)
 {
-	struct ibmvscsi_host_data *hostdata = evt_struct->hostdata;
-	switch (evt_struct->xfer_iu->srp.login_rsp.opcode) {
-	case SRP_LOGIN_RSP:	/* it worked! */
-		break;
-	case SRP_LOGIN_REJ:	/* refused! */
-		dev_info(hostdata->dev, "SRP_LOGIN_REJ reason %u\n",
-			 evt_struct->xfer_iu->srp.login_rej.reason);
-		/* Login failed.  */
-		atomic_set(&hostdata->request_limit, -1);
-		return;
-	default:
-		dev_err(hostdata->dev, "Invalid login response typecode 0x%02x!\n",
-			evt_struct->xfer_iu->srp.login_rsp.opcode);
-		/* Login failed.  */
-		atomic_set(&hostdata->request_limit, -1);
-		return;
-	}
-
-	dev_info(hostdata->dev, "SRP_LOGIN succeeded\n");
-
-	/* Now we know what the real request-limit is.
-	 * This value is set rather than added to request_limit because
-	 * request_limit could have been set to -1 by this client.
-	 */
-	atomic_set(&hostdata->request_limit,
-		   evt_struct->xfer_iu->srp.login_rsp.req_lim_delta);
-
-	/* If we had any pending I/Os, kick them */
-	scsi_unblock_requests(hostdata->host);
-
 	send_mad_adapter_info(hostdata);
-	return;
 }
 
 /**
- * send_srp_login: - Sends the srp login
- * @hostdata:	ibmvscsi_host_data of host
- * 
- * Returns zero if successful.
-*/
-static int send_srp_login(struct ibmvscsi_host_data *hostdata)
-{
-	int rc;
-	unsigned long flags;
-	struct srp_login_req *login;
-	struct srp_event_struct *evt_struct = get_event_struct(&hostdata->pool);
-	if (!evt_struct) {
-		dev_err(hostdata->dev, "couldn't allocate an event for login req!\n");
-		return FAILED;
-	}
-
-	init_event_struct(evt_struct,
-			  login_rsp,
-			  VIOSRP_SRP_FORMAT,
-			  login_timeout);
-
-	login = &evt_struct->iu.srp.login_req;
-	memset(login, 0x00, sizeof(struct srp_login_req));
-	login->opcode = SRP_LOGIN_REQ;
-	login->req_it_iu_len = sizeof(union srp_iu);
-	login->req_buf_fmt = SRP_BUF_FORMAT_DIRECT | SRP_BUF_FORMAT_INDIRECT;
-	
-	spin_lock_irqsave(hostdata->host->host_lock, flags);
-	/* Start out with a request limit of 0, since this is negotiated in
-	 * the login request we are just sending and login requests always
-	 * get sent by the driver regardless of request_limit.
-	 */
-	atomic_set(&hostdata->request_limit, 0);
-
-	rc = ibmvscsi_send_srp_event(evt_struct, hostdata, login_timeout * 2);
-	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
-	dev_info(hostdata->dev, "sent SRP login\n");
-	return rc;
-};
-
-/**
  * sync_completion: Signal that a synchronous command has completed
  * Note that after returning from this call, the evt_struct is freed.
  * the caller waiting on this completion shouldn't touch the evt_struct
@@ -1282,7 +1282,7 @@ void ibmvscsi_handle_crq(struct viosrp_c
 			if ((rc = ibmvscsi_ops->send_crq(hostdata,
 							 0xC002000000000000LL, 0)) == 0) {
 				/* Now login */
-				send_srp_login(hostdata);
+				init_adapter(hostdata);
 			} else {
 				dev_err(hostdata->dev, "Unable to send init rsp. rc=%ld\n", rc);
 			}
@@ -1292,7 +1292,7 @@ void ibmvscsi_handle_crq(struct viosrp_c
 			dev_info(hostdata->dev, "partner initialization complete\n");
 
 			/* Now login */
-			send_srp_login(hostdata);
+			init_adapter(hostdata);
 			break;
 		default:
 			dev_err(hostdata->dev, "unknown crq message type: %d\n", crq->format);
_
