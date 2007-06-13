From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 3/5] ibmvscsi: Add eh_host_reset_handler
Date: Wed, 13 Jun 2007 17:12:26 -0500
Message-ID: <200706132212.l5DMCQD9002964@d01av02.pok.ibm.com>
References: <11817727312836-patch-mail.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:59661 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754808AbXFMWMa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jun 2007 18:12:30 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5DL9dTU026701
	for <linux-scsi@vger.kernel.org>; Wed, 13 Jun 2007 17:09:39 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5DMCSBM518110
	for <linux-scsi@vger.kernel.org>; Wed, 13 Jun 2007 18:12:28 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5DMCRGu003013
	for <linux-scsi@vger.kernel.org>; Wed, 13 Jun 2007 18:12:28 -0400
In-Reply-To: <11817727312836-patch-mail.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: santil@linux.vnet.ibm.com
Cc: rcjenn@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Adds an eh_host_reset_handler to ibmvscsi which resets the connection
to the vscsi server. This patch also adds a timer to internally
issues commands to prevent client hangs in the case of a misbehaving
server. Tested by modifying the VIOS such that it would occasionally
drop one or more request in sequence.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c |  136 ++++++++++++++++-----
 linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.h |    1 
 2 files changed, 107 insertions(+), 30 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvscsi.h~ibmvscsi_timeout_handling drivers/scsi/ibmvscsi/ibmvscsi.h
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvscsi.h~ibmvscsi_timeout_handling	2007-06-13 16:03:45.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.h	2007-06-13 16:03:45.000000000 -0500
@@ -70,6 +70,7 @@ struct srp_event_struct {
 	union viosrp_iu iu;
 	void (*cmnd_done) (struct scsi_cmnd *);
 	struct completion comp;
+	struct timer_list timer;
 	union viosrp_iu *sync_srp;
 	struct srp_direct_buf *ext_list;
 	dma_addr_t ext_list_token;
diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_timeout_handling drivers/scsi/ibmvscsi/ibmvscsi.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_timeout_handling	2007-06-13 16:03:45.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c	2007-06-13 16:04:18.000000000 -0500
@@ -509,6 +509,70 @@ static int map_data_for_srp_cmd(struct s
 	return map_single_data(cmd, srp_cmd, dev);
 }
 
+/**
+ * purge_requests: Our virtual adapter just shut down.  purge any sent requests
+ * @hostdata:    the adapter
+ */
+static void purge_requests(struct ibmvscsi_host_data *hostdata, int error_code)
+{
+	struct srp_event_struct *tmp_evt, *pos;
+	unsigned long flags;
+
+	spin_lock_irqsave(hostdata->host->host_lock, flags);
+	list_for_each_entry_safe(tmp_evt, pos, &hostdata->sent, list) {
+		list_del(&tmp_evt->list);
+		del_timer(&tmp_evt->timer);
+		if (tmp_evt->cmnd) {
+			tmp_evt->cmnd->result = (error_code << 16);
+			unmap_cmd_data(&tmp_evt->iu.srp.cmd,
+				       tmp_evt,
+				       tmp_evt->hostdata->dev);
+			if (tmp_evt->cmnd_done)
+				tmp_evt->cmnd_done(tmp_evt->cmnd);
+		} else if (tmp_evt->done)
+			tmp_evt->done(tmp_evt);
+		free_event_struct(&tmp_evt->hostdata->pool, tmp_evt);
+	}
+	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+}
+
+/**
+ * ibmvscsi_reset_host - Reset the connection to the server
+ * @hostdata:	struct ibmvscsi_host_data to reset
+*/
+static void ibmvscsi_reset_host(struct ibmvscsi_host_data *hostdata)
+{
+	scsi_block_requests(hostdata->host);
+	atomic_set(&hostdata->request_limit, 0);
+
+	purge_requests(hostdata, DID_ERROR);
+	if ((ibmvscsi_reset_crq_queue(&hostdata->queue, hostdata)) ||
+	    (ibmvscsi_send_crq(hostdata, 0xC001000000000000LL, 0)) ||
+	    (vio_enable_interrupts(to_vio_dev(hostdata->dev)))) {
+		atomic_set(&hostdata->request_limit, -1);
+		dev_err(hostdata->dev, "error after reset\n");
+	}
+
+	scsi_unblock_requests(hostdata->host);
+}
+
+/**
+ * ibmvscsi_timeout - Internal command timeout handler
+ * @evt_struct:	struct srp_event_struct that timed out
+ *
+ * Called when an internally generated command times out
+*/
+static void ibmvscsi_timeout(struct srp_event_struct *evt_struct)
+{
+	struct ibmvscsi_host_data *hostdata = evt_struct->hostdata;
+
+	dev_err(hostdata->dev, "Command timed out (%x). Resetting connection\n",
+		evt_struct->iu.srp.cmd.opcode);
+
+	ibmvscsi_reset_host(hostdata);
+}
+
+
 /* ------------------------------------------------------------
  * Routines for sending and receiving SRPs
  */
@@ -516,12 +580,14 @@ static int map_data_for_srp_cmd(struct s
  * ibmvscsi_send_srp_event: - Transforms event to u64 array and calls send_crq()
  * @evt_struct:	evt_struct to be sent
  * @hostdata:	ibmvscsi_host_data of host
+ * @timeout:	timeout in seconds - 0 means do not time command
  *
  * Returns the value returned from ibmvscsi_send_crq(). (Zero for success)
  * Note that this routine assumes that host_lock is held for synchronization
 */
 static int ibmvscsi_send_srp_event(struct srp_event_struct *evt_struct,
-				   struct ibmvscsi_host_data *hostdata)
+				   struct ibmvscsi_host_data *hostdata,
+				   unsigned long timeout)
 {
 	u64 *crq_as_u64 = (u64 *) &evt_struct->crq;
 	int request_status;
@@ -577,9 +643,18 @@ static int ibmvscsi_send_srp_event(struc
 	 */
 	list_add_tail(&evt_struct->list, &hostdata->sent);
 
+	init_timer(&evt_struct->timer);
+	if (timeout) {
+		evt_struct->timer.data = (unsigned long) evt_struct;
+		evt_struct->timer.expires = jiffies + (timeout * HZ);
+		evt_struct->timer.function = (void (*)(unsigned long))ibmvscsi_timeout;
+		add_timer(&evt_struct->timer);
+	}
+
 	if ((rc =
 	     ibmvscsi_send_crq(hostdata, crq_as_u64[0], crq_as_u64[1])) != 0) {
 		list_del(&evt_struct->list);
+		del_timer(&evt_struct->timer);
 
 		dev_err(hostdata->dev, "send error %d\n", rc);
 		atomic_inc(&hostdata->request_limit);
@@ -709,7 +784,7 @@ static int ibmvscsi_queuecommand(struct 
 			offsetof(struct srp_indirect_buf, desc_list);
 	}
 
-	return ibmvscsi_send_srp_event(evt_struct, hostdata);
+	return ibmvscsi_send_srp_event(evt_struct, hostdata, 0);
 }
 
 /* ------------------------------------------------------------
@@ -800,7 +875,7 @@ static void send_mad_adapter_info(struct
 		return;
 	}
 	
-	if (ibmvscsi_send_srp_event(evt_struct, hostdata)) {
+	if (ibmvscsi_send_srp_event(evt_struct, hostdata, init_timeout * 2)) {
 		dev_err(hostdata->dev, "couldn't send ADAPTER_INFO_REQ!\n");
 		dma_unmap_single(hostdata->dev,
 				 addr,
@@ -889,7 +964,7 @@ static int send_srp_login(struct ibmvscs
 	 */
 	atomic_set(&hostdata->request_limit, 1);
 
-	rc = ibmvscsi_send_srp_event(evt_struct, hostdata);
+	rc = ibmvscsi_send_srp_event(evt_struct, hostdata, init_timeout * 2);
 	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
 	dev_info(hostdata->dev, "sent SRP login\n");
 	return rc;
@@ -969,7 +1044,7 @@ static int ibmvscsi_eh_abort_handler(str
 
 	evt->sync_srp = &srp_rsp;
 	init_completion(&evt->comp);
-	rsp_rc = ibmvscsi_send_srp_event(evt, hostdata);
+	rsp_rc = ibmvscsi_send_srp_event(evt, hostdata, init_timeout * 2);
 	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
 	if (rsp_rc != 0) {
 		sdev_printk(KERN_ERR, cmd->device,
@@ -1077,7 +1152,7 @@ static int ibmvscsi_eh_device_reset_hand
 
 	evt->sync_srp = &srp_rsp;
 	init_completion(&evt->comp);
-	rsp_rc = ibmvscsi_send_srp_event(evt, hostdata);
+	rsp_rc = ibmvscsi_send_srp_event(evt, hostdata, init_timeout * 2);
 	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
 	if (rsp_rc != 0) {
 		sdev_printk(KERN_ERR, cmd->device,
@@ -1133,32 +1208,30 @@ static int ibmvscsi_eh_device_reset_hand
 }
 
 /**
- * purge_requests: Our virtual adapter just shut down.  purge any sent requests
- * @hostdata:    the adapter
- */
-static void purge_requests(struct ibmvscsi_host_data *hostdata, int error_code)
+ * ibmvscsi_eh_host_reset_handler - Reset the connection to the server
+ * @cmd:	struct scsi_cmnd having problems
+*/
+static int ibmvscsi_eh_host_reset_handler(struct scsi_cmnd *cmd)
 {
-	struct srp_event_struct *tmp_evt, *pos;
-	unsigned long flags;
+	unsigned long wait_switch = 0;
+	struct ibmvscsi_host_data *hostdata =
+		(struct ibmvscsi_host_data *)cmd->device->host->hostdata;
 
-	spin_lock_irqsave(hostdata->host->host_lock, flags);
-	list_for_each_entry_safe(tmp_evt, pos, &hostdata->sent, list) {
-		list_del(&tmp_evt->list);
-		if (tmp_evt->cmnd) {
-			tmp_evt->cmnd->result = (error_code << 16);
-			unmap_cmd_data(&tmp_evt->iu.srp.cmd, 
-				       tmp_evt,	
-				       tmp_evt->hostdata->dev);
-			if (tmp_evt->cmnd_done)
-				tmp_evt->cmnd_done(tmp_evt->cmnd);
-		} else {
-			if (tmp_evt->done) {
-				tmp_evt->done(tmp_evt);
-			}
-		}
-		free_event_struct(&tmp_evt->hostdata->pool, tmp_evt);
+	dev_err(hostdata->dev, "Resetting connection due to error recovery\n");
+
+	ibmvscsi_reset_host(hostdata);
+
+	for (wait_switch = jiffies + (init_timeout * HZ);
+	     time_before(jiffies, wait_switch) &&
+		     atomic_read(&hostdata->request_limit) < 2;) {
+
+		msleep(10);
 	}
-	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+
+	if (atomic_read(&hostdata->request_limit) <= 0)
+		return FAILED;
+
+	return SUCCESS;
 }
 
 /**
@@ -1258,6 +1331,8 @@ void ibmvscsi_handle_crq(struct viosrp_c
 		atomic_add(evt_struct->xfer_iu->srp.rsp.req_lim_delta,
 			   &hostdata->request_limit);
 
+	del_timer(&evt_struct->timer);
+
 	if (evt_struct->done)
 		evt_struct->done(evt_struct);
 	else
@@ -1313,7 +1388,7 @@ static int ibmvscsi_do_host_config(struc
 	}
 
 	init_completion(&evt_struct->comp);
-	rc = ibmvscsi_send_srp_event(evt_struct, hostdata);
+	rc = ibmvscsi_send_srp_event(evt_struct, hostdata, init_timeout * 2);
 	if (rc == 0)
 		wait_for_completion(&evt_struct->comp);
 	dma_unmap_single(hostdata->dev, addr, length, DMA_BIDIRECTIONAL);
@@ -1504,6 +1579,7 @@ static struct scsi_host_template driver_
 	.queuecommand = ibmvscsi_queuecommand,
 	.eh_abort_handler = ibmvscsi_eh_abort_handler,
 	.eh_device_reset_handler = ibmvscsi_eh_device_reset_handler,
+	.eh_host_reset_handler = ibmvscsi_eh_host_reset_handler,
 	.slave_configure = ibmvscsi_slave_configure,
 	.change_queue_depth = ibmvscsi_change_queue_depth,
 	.cmd_per_lun = 16,
_
