From: Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] [v2] ibmvscsi: requeue while CRQ closed
Date: Mon, 12 Nov 2007 09:00:23 -0600
Message-ID: <20071112150022.GA29035@linux.vnet.ibm.com>
References: <20071109151600.GA16255@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:59779 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbXKLPBB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Nov 2007 10:01:01 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id lACF10dA023317
	for <linux-scsi@vger.kernel.org>; Mon, 12 Nov 2007 10:01:00 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id lACF0hFb126396
	for <linux-scsi@vger.kernel.org>; Mon, 12 Nov 2007 08:00:45 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lACF0fIt017452
	for <linux-scsi@vger.kernel.org>; Mon, 12 Nov 2007 08:00:43 -0700
Content-Disposition: inline
In-Reply-To: <20071109151600.GA16255@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, santil@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, linux-scsi@vger.kernel.org

CRQ send errors that return with H_CLOSED should return with
SCSI_MLQUEUE_HOST_BUSY until firmware alerts the client of a CRQ
transport event.  The transport event will either reinitialize and
requeue the requests or fail and return IO with DID_ERROR.

To avoid failing the eh_* functions while re-attaching to the server
adapter this will retry for a period of time while ibmvscsi_send_srp_event
returns SCSI_MLQUEUE_HOST_BUSY.

In ibmvscsi_eh_abort_handler() the loop includes the search of the
event list.  The lock on the hostdata is dropped while waiting to try
again after failing ibmvscsi_send_srp_event.  The event could have been
purged if a login was in progress when the function was called.

In ibmvscsi_eh_device_reset_handler() the loop includes the call to
get_event_struct() because a failing call to ibmvscsi_send_srp_event()
will have freed the event struct.

Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
Signed-off-by: Brian King <brking@linux.vnet.ibm.com>

---
 drivers/scsi/ibmvscsi/ibmvscsi.c |   59 ++++++++++++++++++++++++++++++++-------
 1 file changed, 48 insertions(+), 11 deletions(-)

Index: linux-2.6/drivers/scsi/ibmvscsi/ibmvscsi.c
===================================================================
--- linux-2.6.orig/drivers/scsi/ibmvscsi/ibmvscsi.c	2007-11-12 08:52:59.000000000 -0600
+++ linux-2.6/drivers/scsi/ibmvscsi/ibmvscsi.c	2007-11-12 08:54:17.000000000 -0600
@@ -629,6 +629,16 @@
 		list_del(&evt_struct->list);
 		del_timer(&evt_struct->timer);
 
+		/* If send_crq returns H_CLOSED, return SCSI_MLQUEUE_HOST_BUSY.
+		 * Firmware will send a CRQ with a transport event (0xFF) to
+		 * tell this client what has happened to the transport.  This
+		 * will be handled in ibmvscsi_handle_crq()
+		 */
+		if (rc == H_CLOSED) {
+			dev_warn(hostdata->dev, "send warning. "
+			         "Receive queue closed, will retry.\n");
+			goto send_busy;
+		}
 		dev_err(hostdata->dev, "send error %d\n", rc);
 		atomic_inc(&hostdata->request_limit);
 		goto send_error;
@@ -976,58 +986,74 @@
 	int rsp_rc;
 	unsigned long flags;
 	u16 lun = lun_from_dev(cmd->device);
+	unsigned long wait_switch = 0;
 
 	/* First, find this command in our sent list so we can figure
 	 * out the correct tag
 	 */
 	spin_lock_irqsave(hostdata->host->host_lock, flags);
-	found_evt = NULL;
-	list_for_each_entry(tmp_evt, &hostdata->sent, list) {
-		if (tmp_evt->cmnd == cmd) {
-			found_evt = tmp_evt;
-			break;
+	wait_switch = jiffies + (init_timeout * HZ);
+	do {
+		found_evt = NULL;
+		list_for_each_entry(tmp_evt, &hostdata->sent, list) {
+			if (tmp_evt->cmnd == cmd) {
+				found_evt = tmp_evt;
+				break;
+			}
 		}
-	}
 
-	if (!found_evt) {
-		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
-		return SUCCESS;
-	}
+		if (!found_evt) {
+			spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+			return SUCCESS;
+		}
 
-	evt = get_event_struct(&hostdata->pool);
-	if (evt == NULL) {
-		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
-		sdev_printk(KERN_ERR, cmd->device, "failed to allocate abort event\n");
-		return FAILED;
-	}
+		evt = get_event_struct(&hostdata->pool);
+		if (evt == NULL) {
+			spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+			sdev_printk(KERN_ERR, cmd->device,
+				"failed to allocate abort event\n");
+			return FAILED;
+		}
 	
-	init_event_struct(evt,
-			  sync_completion,
-			  VIOSRP_SRP_FORMAT,
-			  init_timeout);
+		init_event_struct(evt,
+				  sync_completion,
+				  VIOSRP_SRP_FORMAT,
+				  init_timeout);
 
-	tsk_mgmt = &evt->iu.srp.tsk_mgmt;
+		tsk_mgmt = &evt->iu.srp.tsk_mgmt;
 	
-	/* Set up an abort SRP command */
-	memset(tsk_mgmt, 0x00, sizeof(*tsk_mgmt));
-	tsk_mgmt->opcode = SRP_TSK_MGMT;
-	tsk_mgmt->lun = ((u64) lun) << 48;
-	tsk_mgmt->tsk_mgmt_func = SRP_TSK_ABORT_TASK;
-	tsk_mgmt->task_tag = (u64) found_evt;
-
-	sdev_printk(KERN_INFO, cmd->device, "aborting command. lun 0x%lx, tag 0x%lx\n",
-		    tsk_mgmt->lun, tsk_mgmt->task_tag);
-
-	evt->sync_srp = &srp_rsp;
-	init_completion(&evt->comp);
-	rsp_rc = ibmvscsi_send_srp_event(evt, hostdata, init_timeout * 2);
+		/* Set up an abort SRP command */
+		memset(tsk_mgmt, 0x00, sizeof(*tsk_mgmt));
+		tsk_mgmt->opcode = SRP_TSK_MGMT;
+		tsk_mgmt->lun = ((u64) lun) << 48;
+		tsk_mgmt->tsk_mgmt_func = SRP_TSK_ABORT_TASK;
+		tsk_mgmt->task_tag = (u64) found_evt;
+
+		evt->sync_srp = &srp_rsp;
+
+		init_completion(&evt->comp);
+		rsp_rc = ibmvscsi_send_srp_event(evt, hostdata, init_timeout * 2);
+
+		if (rsp_rc != SCSI_MLQUEUE_HOST_BUSY)
+			break;
+
+		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+		msleep(10);
+		spin_lock_irqsave(hostdata->host->host_lock, flags);
+	} while (time_before(jiffies, wait_switch));
+
 	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+
 	if (rsp_rc != 0) {
 		sdev_printk(KERN_ERR, cmd->device,
 			    "failed to send abort() event. rc=%d\n", rsp_rc);
 		return FAILED;
 	}
 
+	sdev_printk(KERN_INFO, cmd->device,
+                    "aborting command. lun 0x%lx, tag 0x%lx\n",
+		    (((u64) lun) << 48), (u64) found_evt);
+
 	wait_for_completion(&evt->comp);
 
 	/* make sure we got a good response */
@@ -1099,41 +1125,56 @@
 	int rsp_rc;
 	unsigned long flags;
 	u16 lun = lun_from_dev(cmd->device);
+	unsigned long wait_switch = 0;
 
 	spin_lock_irqsave(hostdata->host->host_lock, flags);
-	evt = get_event_struct(&hostdata->pool);
-	if (evt == NULL) {
-		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
-		sdev_printk(KERN_ERR, cmd->device, "failed to allocate reset event\n");
-		return FAILED;
-	}
+	wait_switch = jiffies + (init_timeout * HZ);
+	do {
+		evt = get_event_struct(&hostdata->pool);
+		if (evt == NULL) {
+			spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+			sdev_printk(KERN_ERR, cmd->device,
+				"failed to allocate reset event\n");
+			return FAILED;
+		}
 	
-	init_event_struct(evt,
-			  sync_completion,
-			  VIOSRP_SRP_FORMAT,
-			  init_timeout);
+		init_event_struct(evt,
+				  sync_completion,
+				  VIOSRP_SRP_FORMAT,
+				  init_timeout);
 
-	tsk_mgmt = &evt->iu.srp.tsk_mgmt;
+		tsk_mgmt = &evt->iu.srp.tsk_mgmt;
 
-	/* Set up a lun reset SRP command */
-	memset(tsk_mgmt, 0x00, sizeof(*tsk_mgmt));
-	tsk_mgmt->opcode = SRP_TSK_MGMT;
-	tsk_mgmt->lun = ((u64) lun) << 48;
-	tsk_mgmt->tsk_mgmt_func = SRP_TSK_LUN_RESET;
+		/* Set up a lun reset SRP command */
+		memset(tsk_mgmt, 0x00, sizeof(*tsk_mgmt));
+		tsk_mgmt->opcode = SRP_TSK_MGMT;
+		tsk_mgmt->lun = ((u64) lun) << 48;
+		tsk_mgmt->tsk_mgmt_func = SRP_TSK_LUN_RESET;
 
-	sdev_printk(KERN_INFO, cmd->device, "resetting device. lun 0x%lx\n",
-		    tsk_mgmt->lun);
+		evt->sync_srp = &srp_rsp;
+
+		init_completion(&evt->comp);
+		rsp_rc = ibmvscsi_send_srp_event(evt, hostdata, init_timeout * 2);
+
+		if (rsp_rc != SCSI_MLQUEUE_HOST_BUSY)
+			break;
+
+		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+		msleep(10);
+		spin_lock_irqsave(hostdata->host->host_lock, flags);
+	} while (time_before(jiffies, wait_switch));
 
-	evt->sync_srp = &srp_rsp;
-	init_completion(&evt->comp);
-	rsp_rc = ibmvscsi_send_srp_event(evt, hostdata, init_timeout * 2);
 	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+
 	if (rsp_rc != 0) {
 		sdev_printk(KERN_ERR, cmd->device,
 			    "failed to send reset event. rc=%d\n", rsp_rc);
 		return FAILED;
 	}
 
+	sdev_printk(KERN_INFO, cmd->device, "resetting device. lun 0x%lx\n",
+		    (((u64) lun) << 48));
+
 	wait_for_completion(&evt->comp);
 
 	/* make sure we got a good response */
