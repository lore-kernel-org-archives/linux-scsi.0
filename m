From: Dave C Boutcher <sleddog@us.ibm.com>
Subject: [PATCH] ibmvscsi: handle re-enable firmware message
Date: Thu, 19 Jan 2006 13:34:44 -0600
Message-ID: <20060119193444.GA21420@cs.umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.35.202]:28644 "EHLO mail.cs.umn.edu")
	by vger.kernel.org with ESMTP id S1161166AbWASTer (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jan 2006 14:34:47 -0500
Received: from localhost (localhost [127.0.0.1])
	by augustus.cs.umn.edu (Postfix) with ESMTP id 691275C3F4
	for <linux-scsi@vger.kernel.org>; Thu, 19 Jan 2006 13:34:46 -0600 (CST)
Received: from mail.cs.umn.edu ([127.0.0.1])
 by localhost (mail.cs.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
 with LMTP id 27792-01-7 for <linux-scsi@vger.kernel.org>;
 Thu, 19 Jan 2006 13:34:44 -0600 (CST)
Received: from tera.cs.umn.edu (tera.cs.umn.edu [128.101.35.163])
	by mail.cs.umn.edu (Postfix) with ESMTP id 7E5A85C398
	for <linux-scsi@vger.kernel.org>; Thu, 19 Jan 2006 13:34:44 -0600 (CST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

New versions of the Power5 firmware can send a "re-enable" message to
the virtual scsi adapter.  This fix makes us handle the message
correctly.  Without it, the driver goes catatonic and the system crashes
unpleasantly.

Signed-off-by: Dave Boutcher <sleddog@us.ibm.com>

 drivers/scsi/ibmvscsi/ibmvscsi.c      |   68 ++++++++++++++++++----------------
 drivers/scsi/ibmvscsi/ibmvscsi.h      |    3 +
 drivers/scsi/ibmvscsi/iseries_vscsi.c |   13 ++++++
 drivers/scsi/ibmvscsi/rpa_vscsi.c     |   22 +++++++++++
 4 files changed, 74 insertions(+), 32 deletions(-)

diff -uNr -X exclude-files linux-2.6.15/drivers/scsi/ibmvscsi/ibmvscsi.c linux-2.6.15-vpm/drivers/scsi/ibmvscsi/ibmvscsi.c
--- linux-2.6.15/drivers/scsi/ibmvscsi/ibmvscsi.c	2006-01-02 21:21:10.000000000 -0600
+++ linux-2.6.15-vpm/drivers/scsi/ibmvscsi/ibmvscsi.c	2006-01-12 09:51:33.000000000 -0600
@@ -87,7 +87,7 @@
 static int init_timeout = 5;
 static int max_requests = 50;
 
-#define IBMVSCSI_VERSION "1.5.7"
+#define IBMVSCSI_VERSION "1.5.8"
 
 MODULE_DESCRIPTION("IBM Virtual SCSI");
 MODULE_AUTHOR("Dave Boutcher");
@@ -534,7 +534,6 @@
 static int ibmvscsi_send_srp_event(struct srp_event_struct *evt_struct,
 				   struct ibmvscsi_host_data *hostdata)
 {
-	struct scsi_cmnd *cmnd;
 	u64 *crq_as_u64 = (u64 *) &evt_struct->crq;
 	int rc;
 
@@ -544,19 +543,8 @@
 	 * can handle more requests (can_queue) when we actually can't
 	 */
 	if ((evt_struct->crq.format == VIOSRP_SRP_FORMAT) &&
-	    (atomic_dec_if_positive(&hostdata->request_limit) < 0)) {
-		/* See if the adapter is disabled */
-		if (atomic_read(&hostdata->request_limit) < 0)
-			goto send_error;
-	
-		printk(KERN_WARNING 
-		       "ibmvscsi: Warning, request_limit exceeded\n");
-		unmap_cmd_data(&evt_struct->iu.srp.cmd,
-			       evt_struct,
-			       hostdata->dev);
-		free_event_struct(&hostdata->pool, evt_struct);
-		return SCSI_MLQUEUE_HOST_BUSY;
-	}
+	    (atomic_dec_if_positive(&hostdata->request_limit) < 0))
+		goto send_error;
 
 	/* Copy the IU into the transfer area */
 	*evt_struct->xfer_iu = evt_struct->iu;
@@ -572,7 +560,7 @@
 	     ibmvscsi_send_crq(hostdata, crq_as_u64[0], crq_as_u64[1])) != 0) {
 		list_del(&evt_struct->list);
 
-		printk(KERN_ERR "ibmvscsi: failed to send event struct rc %d\n",
+		printk(KERN_ERR "ibmvscsi: send error %d\n",
 		       rc);
 		goto send_error;
 	}
@@ -582,14 +570,8 @@
  send_error:
 	unmap_cmd_data(&evt_struct->iu.srp.cmd, evt_struct, hostdata->dev);
 
-	if ((cmnd = evt_struct->cmnd) != NULL) {
-		cmnd->result = DID_ERROR << 16;
-		evt_struct->cmnd_done(cmnd);
-	} else if (evt_struct->done)
-		evt_struct->done(evt_struct);
-	
 	free_event_struct(&hostdata->pool, evt_struct);
-	return 0;
+ 	return SCSI_MLQUEUE_HOST_BUSY;
 }
 
 /**
@@ -802,7 +784,8 @@
 	case SRP_LOGIN_RSP_TYPE:	/* it worked! */
 		break;
 	case SRP_LOGIN_REJ_TYPE:	/* refused! */
-		printk(KERN_INFO "ibmvscsi: SRP_LOGIN_REQ rejected\n");
+		printk(KERN_INFO "ibmvscsi: SRP_LOGIN_REJ reason %u\n",
+		       evt_struct->xfer_iu->srp.login_rej.reason);
 		/* Login failed.  */
 		atomic_set(&hostdata->request_limit, -1);
 		return;
@@ -834,6 +817,9 @@
 		return;
 	}
 
+	/* If we had any pending I/Os, kick them */
+	scsi_unblock_requests(hostdata->host);
+
 	send_mad_adapter_info(hostdata);
 	return;
 }
@@ -862,6 +848,7 @@
 			  init_timeout * HZ);
 
 	login = &evt_struct->iu.srp.login_req;
+	memset(login, 0x00, sizeof(struct srp_login_req));
 	login->type = SRP_LOGIN_REQ_TYPE;
 	login->max_requested_initiator_to_target_iulen = sizeof(union srp_iu);
 	login->required_buffer_formats = 0x0006;
@@ -1122,7 +1109,7 @@
  * purge_requests: Our virtual adapter just shut down.  purge any sent requests
  * @hostdata:    the adapter
  */
-static void purge_requests(struct ibmvscsi_host_data *hostdata)
+static void purge_requests(struct ibmvscsi_host_data *hostdata, int error_code)
 {
 	struct srp_event_struct *tmp_evt, *pos;
 	unsigned long flags;
@@ -1131,7 +1118,7 @@
 	list_for_each_entry_safe(tmp_evt, pos, &hostdata->sent, list) {
 		list_del(&tmp_evt->list);
 		if (tmp_evt->cmnd) {
-			tmp_evt->cmnd->result = (DID_ERROR << 16);
+			tmp_evt->cmnd->result = (error_code << 16);
 			unmap_cmd_data(&tmp_evt->iu.srp.cmd, 
 				       tmp_evt,	
 				       tmp_evt->hostdata->dev);
@@ -1186,12 +1173,30 @@
 			printk(KERN_ERR "ibmvscsi: unknown crq message type\n");
 		}
 		return;
-	case 0xFF:		/* Hypervisor telling us the connection is closed */
-		printk(KERN_INFO "ibmvscsi: Virtual adapter failed!\n");
+	case 0xFF:	/* Hypervisor telling us the connection is closed */
+		scsi_block_requests(hostdata->host);
+		if (crq->format == 0x06) {
+			/* We need to re-setup the interpartition connection */
+			printk(KERN_INFO
+			       "ibmvscsi: Re-enabling adapter!\n");
+			purge_requests(hostdata, DID_REQUEUE);
+			if (ibmvscsi_reenable_crq_queue(&hostdata->queue,
+							hostdata) == 0)
+				if (ibmvscsi_send_crq(hostdata,
+						      0xC001000000000000LL, 0))
+					printk(KERN_ERR
+					       "ibmvscsi: transmit error after"
+					       " enable\n");
+		} else {
+			printk(KERN_INFO
+			       "ibmvscsi: Virtual adapter failed rc %d!\n",
+			       crq->format);
 
-		atomic_set(&hostdata->request_limit, -1);
-		purge_requests(hostdata);
-		ibmvscsi_reset_crq_queue(&hostdata->queue, hostdata);
+			atomic_set(&hostdata->request_limit, -1);
+			purge_requests(hostdata, DID_ERROR);
+			ibmvscsi_reset_crq_queue(&hostdata->queue, hostdata);
+		}
+		scsi_unblock_requests(hostdata->host);
 		return;
 	case 0x80:		/* real payload */
 		break;
diff -uNr linux-2.6.15-patched/drivers/scsi/ibmvscsi/ibmvscsi.h linux-2.6.15-patched2/drivers/scsi/ibmvscsi/ibmvscsi.h
--- linux-2.6.15-patched/drivers/scsi/ibmvscsi/ibmvscsi.h	2006-01-11 17:46:58.000000000 -0600
+++ linux-2.6.15-patched2/drivers/scsi/ibmvscsi/ibmvscsi.h	2006-01-11 17:52:28.000000000 -0600
@@ -103,6 +103,9 @@
 int ibmvscsi_reset_crq_queue(struct crq_queue *queue,
 			      struct ibmvscsi_host_data *hostdata);
 
+int ibmvscsi_reenable_crq_queue(struct crq_queue *queue,
+				struct ibmvscsi_host_data *hostdata);
+
 void ibmvscsi_handle_crq(struct viosrp_crq *crq,
 			 struct ibmvscsi_host_data *hostdata);
 int ibmvscsi_send_crq(struct ibmvscsi_host_data *hostdata,
diff -uNr linux-2.6.15-patched/drivers/scsi/ibmvscsi/iseries_vscsi.c linux-2.6.15-patched2/drivers/scsi/ibmvscsi/iseries_vscsi.c
--- linux-2.6.15-patched/drivers/scsi/ibmvscsi/iseries_vscsi.c	2006-01-11 17:46:58.000000000 -0600
+++ linux-2.6.15-patched2/drivers/scsi/ibmvscsi/iseries_vscsi.c	2006-01-11 17:52:28.000000000 -0600
@@ -124,6 +124,19 @@
 }
 
 /**
+ * reenable_crq_queue: - reenables a crq after a failure
+ * @queue:	crq_queue to initialize and register
+ * @hostdata:	ibmvscsi_host_data of host
+ *
+ * no-op for iSeries
+ */
+int ibmvscsi_reenable_crq_queue(struct crq_queue *queue,
+				struct ibmvscsi_host_data *hostdata)
+{
+	return 0;
+}
+
+/**
  * ibmvscsi_send_crq: - Send a CRQ
  * @hostdata:	the adapter
  * @word1:	the first 64 bits of the data
diff -uNr linux-2.6.15-patched/drivers/scsi/ibmvscsi/rpa_vscsi.c linux-2.6.15-patched2/drivers/scsi/ibmvscsi/rpa_vscsi.c
--- linux-2.6.15-patched/drivers/scsi/ibmvscsi/rpa_vscsi.c	2006-01-11 17:46:58.000000000 -0600
+++ linux-2.6.15-patched2/drivers/scsi/ibmvscsi/rpa_vscsi.c	2006-01-11 17:52:28.000000000 -0600
@@ -281,6 +281,28 @@
 }
 
 /**
+ * reenable_crq_queue: - reenables a crq after
+ * @queue:	crq_queue to initialize and register
+ * @hostdata:	ibmvscsi_host_data of host
+ *
+ */
+int ibmvscsi_reenable_crq_queue(struct crq_queue *queue,
+				 struct ibmvscsi_host_data *hostdata)
+{
+	int rc;
+	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
+
+	/* Re-enable the CRQ */
+	do {
+		rc = plpar_hcall_norets(H_ENABLE_CRQ, vdev->unit_address);
+	} while ((rc == H_InProgress) || (rc == H_Busy) || (H_isLongBusy(rc)));
+
+	if (rc)
+		printk(KERN_ERR "ibmvscsi: Error %d enabling adapter\n", rc);
+	return rc;
+}
+
+/**
  * reset_crq_queue: - resets a crq after a failure
  * @queue:	crq_queue to initialize and register
  * @hostdata:	ibmvscsi_host_data of host
-- 
Dave Boutcher
