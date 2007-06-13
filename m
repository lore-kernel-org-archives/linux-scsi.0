From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 2/5] ibmvscsi: Enhanced error logging
Date: Wed, 13 Jun 2007 17:12:19 -0500
Message-ID: <200706132212.l5DMCKnZ020759@d01av03.pok.ibm.com>
References: <11817727312836-patch-mail.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:51206 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754808AbXFMWMX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jun 2007 18:12:23 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5DMCKHk027754
	for <linux-scsi@vger.kernel.org>; Wed, 13 Jun 2007 18:12:20 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5DMCLAB539056
	for <linux-scsi@vger.kernel.org>; Wed, 13 Jun 2007 18:12:21 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5DMCKpd020832
	for <linux-scsi@vger.kernel.org>; Wed, 13 Jun 2007 18:12:20 -0400
In-Reply-To: <11817727312836-patch-mail.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: santil@linux.vnet.ibm.com
Cc: rcjenn@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Converts ibmvscsi to use dev_printk and friends to simplify
debugging. ibmvscsi adapter initialization now looks like this:

ibmvscsi 30000005: SRP_VERSION: 16.a
ibmvscsi 30000005: partner initialization complete
ibmvscsi 30000005: sent SRP login
ibmvscsi 30000005: SRP_LOGIN succeeded

Additionally, this patch adds the logging of a couple return codes in
a couple logs.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c  |  208 ++++++++------------
 linux-2.6-bjking1/drivers/scsi/ibmvscsi/rpa_vscsi.c |   20 -
 2 files changed, 100 insertions(+), 128 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_printk_enhancements drivers/scsi/ibmvscsi/ibmvscsi.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_printk_enhancements	2007-06-13 16:02:19.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c	2007-06-13 16:03:08.000000000 -0500
@@ -173,9 +173,8 @@ static void release_event_pool(struct ev
 		}
 	}
 	if (in_use)
-		printk(KERN_WARNING
-		       "ibmvscsi: releasing event pool with %d "
-		       "events still in use?\n", in_use);
+		dev_warn(hostdata->dev, "releasing event pool with %d "
+			 "events still in use?\n", in_use);
 	kfree(pool->events);
 	dma_free_coherent(hostdata->dev,
 			  pool->size * sizeof(*pool->iu_storage),
@@ -210,15 +209,13 @@ static void free_event_struct(struct eve
 				       struct srp_event_struct *evt)
 {
 	if (!valid_event_struct(pool, evt)) {
-		printk(KERN_ERR
-		       "ibmvscsi: Freeing invalid event_struct %p "
-		       "(not in pool %p)\n", evt, pool->events);
+		dev_err(evt->hostdata->dev, "Freeing invalid event_struct %p "
+			"(not in pool %p)\n", evt, pool->events);
 		return;
 	}
 	if (atomic_inc_return(&evt->free) != 1) {
-		printk(KERN_ERR
-		       "ibmvscsi: Freeing event_struct %p "
-		       "which is not in use!\n", evt);
+		dev_err(evt->hostdata->dev, "Freeing event_struct %p "
+			"which is not in use!\n", evt);
 		return;
 	}
 }
@@ -426,10 +423,9 @@ static int map_sg_data(struct scsi_cmnd 
 					   SG_ALL * sizeof(struct srp_direct_buf),
 					   &evt_struct->ext_list_token, 0);
 		if (!evt_struct->ext_list) {
-			printk(KERN_ERR
-			       "ibmvscsi: Can't allocate memory for indirect table\n");
+			sdev_printk(KERN_ERR, cmd->device,
+				    "Can't allocate memory for indirect table\n");
 			return 0;
-			
 		}
 	}
 
@@ -464,8 +460,8 @@ static int map_single_data(struct scsi_c
 			       cmd->request_bufflen,
 			       DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(data->va)) {
-		printk(KERN_ERR
-		       "ibmvscsi: Unable to map request_buffer for command!\n");
+		sdev_printk(KERN_ERR, cmd->device,
+			    "Unable to map request_buffer for command!\n");
 		return 0;
 	}
 	data->len = cmd->request_bufflen;
@@ -496,13 +492,13 @@ static int map_data_for_srp_cmd(struct s
 	case DMA_NONE:
 		return 1;
 	case DMA_BIDIRECTIONAL:
-		printk(KERN_ERR
-		       "ibmvscsi: Can't map DMA_BIDIRECTIONAL to read/write\n");
+		sdev_printk(KERN_ERR, cmd->device,
+			    "Can't map DMA_BIDIRECTIONAL to read/write\n");
 		return 0;
 	default:
-		printk(KERN_ERR
-		       "ibmvscsi: Unknown data direction 0x%02x; can't map!\n",
-		       cmd->sc_data_direction);
+		sdev_printk(KERN_ERR, cmd->device,
+			    "Unknown data direction 0x%02x; can't map!\n",
+			    cmd->sc_data_direction);
 		return 0;
 	}
 
@@ -585,8 +581,7 @@ static int ibmvscsi_send_srp_event(struc
 	     ibmvscsi_send_crq(hostdata, crq_as_u64[0], crq_as_u64[1])) != 0) {
 		list_del(&evt_struct->list);
 
-		printk(KERN_ERR "ibmvscsi: send error %d\n",
-		       rc);
+		dev_err(hostdata->dev, "send error %d\n", rc);
 		atomic_inc(&hostdata->request_limit);
 		goto send_error;
 	}
@@ -627,9 +622,8 @@ static void handle_cmd_rsp(struct srp_ev
 
 	if (unlikely(rsp->opcode != SRP_RSP)) {
 		if (printk_ratelimit())
-			printk(KERN_WARNING 
-			       "ibmvscsi: bad SRP RSP type %d\n",
-			       rsp->opcode);
+			dev_warn(evt_struct->hostdata->dev,
+				 "bad SRP RSP type %d\n", rsp->opcode);
 	}
 	
 	if (cmnd) {
@@ -690,7 +684,7 @@ static int ibmvscsi_queuecommand(struct 
 	srp_cmd->lun = ((u64) lun) << 48;
 
 	if (!map_data_for_srp_cmd(cmnd, evt_struct, srp_cmd, hostdata->dev)) {
-		printk(KERN_ERR "ibmvscsi: couldn't convert cmd to srp_cmd\n");
+		sdev_printk(KERN_ERR, cmnd->device, "couldn't convert cmd to srp_cmd\n");
 		free_event_struct(&hostdata->pool, evt_struct);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
@@ -737,16 +731,16 @@ static void adapter_info_rsp(struct srp_
 			 DMA_BIDIRECTIONAL);
 
 	if (evt_struct->xfer_iu->mad.adapter_info.common.status) {
-		printk("ibmvscsi: error %d getting adapter info\n",
-		       evt_struct->xfer_iu->mad.adapter_info.common.status);
+		dev_err(hostdata->dev, "error %d getting adapter info\n",
+			evt_struct->xfer_iu->mad.adapter_info.common.status);
 	} else {
-		printk("ibmvscsi: host srp version: %s, "
-		       "host partition %s (%d), OS %d, max io %u\n",
-		       hostdata->madapter_info.srp_version,
-		       hostdata->madapter_info.partition_name,
-		       hostdata->madapter_info.partition_number,
-		       hostdata->madapter_info.os_type,
-		       hostdata->madapter_info.port_max_txu[0]);
+		dev_info(hostdata->dev, "host srp version: %s, "
+			 "host partition %s (%d), OS %d, max io %u\n",
+			 hostdata->madapter_info.srp_version,
+			 hostdata->madapter_info.partition_name,
+			 hostdata->madapter_info.partition_number,
+			 hostdata->madapter_info.os_type,
+			 hostdata->madapter_info.port_max_txu[0]);
 		
 		if (hostdata->madapter_info.port_max_txu[0]) 
 			hostdata->host->max_sectors = 
@@ -754,11 +748,10 @@ static void adapter_info_rsp(struct srp_
 		
 		if (hostdata->madapter_info.os_type == 3 &&
 		    strcmp(hostdata->madapter_info.srp_version, "1.6a") <= 0) {
-			printk("ibmvscsi: host (Ver. %s) doesn't support large"
-			       "transfers\n",
-			       hostdata->madapter_info.srp_version);
-			printk("ibmvscsi: limiting scatterlists to %d\n",
-			       MAX_INDIRECT_BUFS);
+			dev_err(hostdata->dev, "host (Ver. %s) doesn't support large transfers\n",
+				hostdata->madapter_info.srp_version);
+			dev_err(hostdata->dev, "limiting scatterlists to %d\n",
+				MAX_INDIRECT_BUFS);
 			hostdata->host->sg_tablesize = MAX_INDIRECT_BUFS;
 		}
 	}
@@ -781,8 +774,8 @@ static void send_mad_adapter_info(struct
 
 	evt_struct = get_event_struct(&hostdata->pool);
 	if (!evt_struct) {
-		printk(KERN_ERR "ibmvscsi: couldn't allocate an event "
-		       "for ADAPTER_INFO_REQ!\n");
+		dev_err(hostdata->dev,
+			"couldn't allocate an event for ADAPTER_INFO_REQ!\n");
 		return;
 	}
 
@@ -802,15 +795,13 @@ static void send_mad_adapter_info(struct
 					    DMA_BIDIRECTIONAL);
 
 	if (dma_mapping_error(req->buffer)) {
-		printk(KERN_ERR
-		       "ibmvscsi: Unable to map request_buffer "
-		       "for adapter_info!\n");
+		dev_err(hostdata->dev, "Unable to map request_buffer for adapter_info!\n");
 		free_event_struct(&hostdata->pool, evt_struct);
 		return;
 	}
 	
 	if (ibmvscsi_send_srp_event(evt_struct, hostdata)) {
-		printk(KERN_ERR "ibmvscsi: couldn't send ADAPTER_INFO_REQ!\n");
+		dev_err(hostdata->dev, "couldn't send ADAPTER_INFO_REQ!\n");
 		dma_unmap_single(hostdata->dev,
 				 addr,
 				 sizeof(hostdata->madapter_info),
@@ -832,24 +823,23 @@ static void login_rsp(struct srp_event_s
 	case SRP_LOGIN_RSP:	/* it worked! */
 		break;
 	case SRP_LOGIN_REJ:	/* refused! */
-		printk(KERN_INFO "ibmvscsi: SRP_LOGIN_REJ reason %u\n",
-		       evt_struct->xfer_iu->srp.login_rej.reason);
+		dev_info(hostdata->dev, "SRP_LOGIN_REJ reason %u\n",
+			 evt_struct->xfer_iu->srp.login_rej.reason);
 		/* Login failed.  */
 		atomic_set(&hostdata->request_limit, -1);
 		return;
 	default:
-		printk(KERN_ERR
-		       "ibmvscsi: Invalid login response typecode 0x%02x!\n",
-		       evt_struct->xfer_iu->srp.login_rsp.opcode);
+		dev_err(hostdata->dev, "Invalid login response typecode 0x%02x!\n",
+			evt_struct->xfer_iu->srp.login_rsp.opcode);
 		/* Login failed.  */
 		atomic_set(&hostdata->request_limit, -1);
 		return;
 	}
 
-	printk(KERN_INFO "ibmvscsi: SRP_LOGIN succeeded\n");
+	dev_info(hostdata->dev, "SRP_LOGIN succeeded\n");
 
 	if (evt_struct->xfer_iu->srp.login_rsp.req_lim_delta < 0)
-		printk(KERN_ERR "ibmvscsi: Invalid request_limit.\n");
+		dev_err(hostdata->dev, "Invalid request_limit.\n");
 
 	/* Now we know what the real request-limit is.
 	 * This value is set rather than added to request_limit because
@@ -878,8 +868,7 @@ static int send_srp_login(struct ibmvscs
 	struct srp_login_req *login;
 	struct srp_event_struct *evt_struct = get_event_struct(&hostdata->pool);
 	if (!evt_struct) {
-		printk(KERN_ERR
-		       "ibmvscsi: couldn't allocate an event for login req!\n");
+		dev_err(hostdata->dev, "couldn't allocate an event for login req!\n");
 		return FAILED;
 	}
 
@@ -902,7 +891,7 @@ static int send_srp_login(struct ibmvscs
 
 	rc = ibmvscsi_send_srp_event(evt_struct, hostdata);
 	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
-	printk("ibmvscsic: sent SRP login\n");
+	dev_info(hostdata->dev, "sent SRP login\n");
 	return rc;
 };
 
@@ -957,7 +946,7 @@ static int ibmvscsi_eh_abort_handler(str
 	evt = get_event_struct(&hostdata->pool);
 	if (evt == NULL) {
 		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
-		printk(KERN_ERR "ibmvscsi: failed to allocate abort event\n");
+		sdev_printk(KERN_ERR, cmd->device, "failed to allocate abort event\n");
 		return FAILED;
 	}
 	
@@ -975,15 +964,16 @@ static int ibmvscsi_eh_abort_handler(str
 	tsk_mgmt->tsk_mgmt_func = SRP_TSK_ABORT_TASK;
 	tsk_mgmt->task_tag = (u64) found_evt;
 
-	printk(KERN_INFO "ibmvscsi: aborting command. lun 0x%lx, tag 0x%lx\n",
-	       tsk_mgmt->lun, tsk_mgmt->task_tag);
+	sdev_printk(KERN_INFO, cmd->device, "aborting command. lun 0x%lx, tag 0x%lx\n",
+		    tsk_mgmt->lun, tsk_mgmt->task_tag);
 
 	evt->sync_srp = &srp_rsp;
 	init_completion(&evt->comp);
 	rsp_rc = ibmvscsi_send_srp_event(evt, hostdata);
 	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
 	if (rsp_rc != 0) {
-		printk(KERN_ERR "ibmvscsi: failed to send abort() event\n");
+		sdev_printk(KERN_ERR, cmd->device,
+			    "failed to send abort() event. rc=%d\n", rsp_rc);
 		return FAILED;
 	}
 
@@ -992,9 +982,8 @@ static int ibmvscsi_eh_abort_handler(str
 	/* make sure we got a good response */
 	if (unlikely(srp_rsp.srp.rsp.opcode != SRP_RSP)) {
 		if (printk_ratelimit())
-			printk(KERN_WARNING 
-			       "ibmvscsi: abort bad SRP RSP type %d\n",
-			       srp_rsp.srp.rsp.opcode);
+			sdev_printk(KERN_WARNING, cmd->device, "abort bad SRP RSP type %d\n",
+				    srp_rsp.srp.rsp.opcode);
 		return FAILED;
 	}
 
@@ -1005,10 +994,9 @@ static int ibmvscsi_eh_abort_handler(str
 
 	if (rsp_rc) {
 		if (printk_ratelimit())
-			printk(KERN_WARNING 
-			       "ibmvscsi: abort code %d for task tag 0x%lx\n",
-			       rsp_rc,
-			       tsk_mgmt->task_tag);
+			sdev_printk(KERN_WARNING, cmd->device,
+				    "abort code %d for task tag 0x%lx\n",
+				    rsp_rc, tsk_mgmt->task_tag);
 		return FAILED;
 	}
 
@@ -1027,15 +1015,13 @@ static int ibmvscsi_eh_abort_handler(str
 
 	if (found_evt == NULL) {
 		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
-		printk(KERN_INFO
-		       "ibmvscsi: aborted task tag 0x%lx completed\n",
-		       tsk_mgmt->task_tag);
+		sdev_printk(KERN_INFO, cmd->device, "aborted task tag 0x%lx completed\n",
+			    tsk_mgmt->task_tag);
 		return SUCCESS;
 	}
 
-	printk(KERN_INFO
-	       "ibmvscsi: successfully aborted task tag 0x%lx\n",
-	       tsk_mgmt->task_tag);
+	sdev_printk(KERN_INFO, cmd->device, "successfully aborted task tag 0x%lx\n",
+		    tsk_mgmt->task_tag);
 
 	cmd->result = (DID_ABORT << 16);
 	list_del(&found_evt->list);
@@ -1069,7 +1055,7 @@ static int ibmvscsi_eh_device_reset_hand
 	evt = get_event_struct(&hostdata->pool);
 	if (evt == NULL) {
 		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
-		printk(KERN_ERR "ibmvscsi: failed to allocate reset event\n");
+		sdev_printk(KERN_ERR, cmd->device, "failed to allocate reset event\n");
 		return FAILED;
 	}
 	
@@ -1086,15 +1072,16 @@ static int ibmvscsi_eh_device_reset_hand
 	tsk_mgmt->lun = ((u64) lun) << 48;
 	tsk_mgmt->tsk_mgmt_func = SRP_TSK_LUN_RESET;
 
-	printk(KERN_INFO "ibmvscsi: resetting device. lun 0x%lx\n",
-	       tsk_mgmt->lun);
+	sdev_printk(KERN_INFO, cmd->device, "resetting device. lun 0x%lx\n",
+		    tsk_mgmt->lun);
 
 	evt->sync_srp = &srp_rsp;
 	init_completion(&evt->comp);
 	rsp_rc = ibmvscsi_send_srp_event(evt, hostdata);
 	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
 	if (rsp_rc != 0) {
-		printk(KERN_ERR "ibmvscsi: failed to send reset event\n");
+		sdev_printk(KERN_ERR, cmd->device,
+			    "failed to send reset event. rc=%d\n", rsp_rc);
 		return FAILED;
 	}
 
@@ -1103,9 +1090,8 @@ static int ibmvscsi_eh_device_reset_hand
 	/* make sure we got a good response */
 	if (unlikely(srp_rsp.srp.rsp.opcode != SRP_RSP)) {
 		if (printk_ratelimit())
-			printk(KERN_WARNING 
-			       "ibmvscsi: reset bad SRP RSP type %d\n",
-			       srp_rsp.srp.rsp.opcode);
+			sdev_printk(KERN_WARNING, cmd->device, "reset bad SRP RSP type %d\n",
+				    srp_rsp.srp.rsp.opcode);
 		return FAILED;
 	}
 
@@ -1116,9 +1102,9 @@ static int ibmvscsi_eh_device_reset_hand
 
 	if (rsp_rc) {
 		if (printk_ratelimit())
-			printk(KERN_WARNING 
-			       "ibmvscsi: reset code %d for task tag 0x%lx\n",
-			       rsp_rc, tsk_mgmt->task_tag);
+			sdev_printk(KERN_WARNING, cmd->device,
+				    "reset code %d for task tag 0x%lx\n",
+				    rsp_rc, tsk_mgmt->task_tag);
 		return FAILED;
 	}
 
@@ -1184,6 +1170,7 @@ static void purge_requests(struct ibmvsc
 void ibmvscsi_handle_crq(struct viosrp_crq *crq,
 			 struct ibmvscsi_host_data *hostdata)
 {
+	long rc;
 	unsigned long flags;
 	struct srp_event_struct *evt_struct =
 	    (struct srp_event_struct *)crq->IU_data_ptr;
@@ -1191,27 +1178,25 @@ void ibmvscsi_handle_crq(struct viosrp_c
 	case 0xC0:		/* initialization */
 		switch (crq->format) {
 		case 0x01:	/* Initialization message */
-			printk(KERN_INFO "ibmvscsi: partner initialized\n");
+			dev_info(hostdata->dev, "partner initialized\n");
 			/* Send back a response */
-			if (ibmvscsi_send_crq(hostdata,
-					      0xC002000000000000LL, 0) == 0) {
+			if ((rc = ibmvscsi_send_crq(hostdata,
+						    0xC002000000000000LL, 0)) == 0) {
 				/* Now login */
 				send_srp_login(hostdata);
 			} else {
-				printk(KERN_ERR
-				       "ibmvscsi: Unable to send init rsp\n");
+				dev_err(hostdata->dev, "Unable to send init rsp. rc=%ld\n", rc);
 			}
 
 			break;
 		case 0x02:	/* Initialization response */
-			printk(KERN_INFO
-			       "ibmvscsi: partner initialization complete\n");
+			dev_info(hostdata->dev, "partner initialization complete\n");
 
 			/* Now login */
 			send_srp_login(hostdata);
 			break;
 		default:
-			printk(KERN_ERR "ibmvscsi: unknown crq message type\n");
+			dev_err(hostdata->dev, "unknown crq message type: %d\n", crq->format);
 		}
 		return;
 	case 0xFF:	/* Hypervisor telling us the connection is closed */
@@ -1219,8 +1204,7 @@ void ibmvscsi_handle_crq(struct viosrp_c
 		atomic_set(&hostdata->request_limit, 0);
 		if (crq->format == 0x06) {
 			/* We need to re-setup the interpartition connection */
-			printk(KERN_INFO
-			       "ibmvscsi: Re-enabling adapter!\n");
+			dev_info(hostdata->dev, "Re-enabling adapter!\n");
 			purge_requests(hostdata, DID_REQUEUE);
 			if ((ibmvscsi_reenable_crq_queue(&hostdata->queue,
 							hostdata)) ||
@@ -1228,14 +1212,11 @@ void ibmvscsi_handle_crq(struct viosrp_c
 					       0xC001000000000000LL, 0))) {
 					atomic_set(&hostdata->request_limit,
 						   -1);
-					printk(KERN_ERR
-					       "ibmvscsi: error after"
-					       " enable\n");
+					dev_err(hostdata->dev, "error after enable\n");
 			}
 		} else {
-			printk(KERN_INFO
-			       "ibmvscsi: Virtual adapter failed rc %d!\n",
-			       crq->format);
+			dev_err(hostdata->dev, "Virtual adapter failed rc %d!\n",
+				crq->format);
 
 			purge_requests(hostdata, DID_ERROR);
 			if ((ibmvscsi_reset_crq_queue(&hostdata->queue,
@@ -1244,8 +1225,7 @@ void ibmvscsi_handle_crq(struct viosrp_c
 					       0xC001000000000000LL, 0))) {
 					atomic_set(&hostdata->request_limit,
 						   -1);
-					printk(KERN_ERR
-					       "ibmvscsi: error after reset\n");
+					dev_err(hostdata->dev, "error after reset\n");
 			}
 		}
 		scsi_unblock_requests(hostdata->host);
@@ -1253,9 +1233,8 @@ void ibmvscsi_handle_crq(struct viosrp_c
 	case 0x80:		/* real payload */
 		break;
 	default:
-		printk(KERN_ERR
-		       "ibmvscsi: got an invalid message type 0x%02x\n",
-		       crq->valid);
+		dev_err(hostdata->dev, "got an invalid message type 0x%02x\n",
+			crq->valid);
 		return;
 	}
 
@@ -1264,16 +1243,14 @@ void ibmvscsi_handle_crq(struct viosrp_c
 	 * actually sent
 	 */
 	if (!valid_event_struct(&hostdata->pool, evt_struct)) {
-		printk(KERN_ERR
-		       "ibmvscsi: returned correlation_token 0x%p is invalid!\n",
+		dev_err(hostdata->dev, "returned correlation_token 0x%p is invalid!\n",
 		       (void *)crq->IU_data_ptr);
 		return;
 	}
 
 	if (atomic_read(&evt_struct->free)) {
-		printk(KERN_ERR
-		       "ibmvscsi: received duplicate  correlation_token 0x%p!\n",
-		       (void *)crq->IU_data_ptr);
+		dev_err(hostdata->dev, "received duplicate correlation_token 0x%p!\n",
+			(void *)crq->IU_data_ptr);
 		return;
 	}
 
@@ -1284,8 +1261,7 @@ void ibmvscsi_handle_crq(struct viosrp_c
 	if (evt_struct->done)
 		evt_struct->done(evt_struct);
 	else
-		printk(KERN_ERR
-		       "ibmvscsi: returned done() is NULL; not running it!\n");
+		dev_err(hostdata->dev, "returned done() is NULL; not running it!\n");
 
 	/*
 	 * Lock the host_lock before messing with these structures, since we
@@ -1311,8 +1287,7 @@ static int ibmvscsi_do_host_config(struc
 
 	evt_struct = get_event_struct(&hostdata->pool);
 	if (!evt_struct) {
-		printk(KERN_ERR
-		       "ibmvscsi: could't allocate event for HOST_CONFIG!\n");
+		dev_err(hostdata->dev, "couldn't allocate event for HOST_CONFIG!\n");
 		return -1;
 	}
 
@@ -1332,8 +1307,7 @@ static int ibmvscsi_do_host_config(struc
 						    DMA_BIDIRECTIONAL);
 
 	if (dma_mapping_error(host_config->buffer)) {
-		printk(KERN_ERR
-		       "ibmvscsi: dma_mapping error " "getting host config\n");
+		dev_err(hostdata->dev, "dma_mapping error getting host config\n");
 		free_event_struct(&hostdata->pool, evt_struct);
 		return -1;
 	}
@@ -1556,7 +1530,7 @@ static int ibmvscsi_probe(struct vio_dev
 	driver_template.can_queue = max_requests;
 	host = scsi_host_alloc(&driver_template, sizeof(*hostdata));
 	if (!host) {
-		printk(KERN_ERR "ibmvscsi: couldn't allocate host data\n");
+		dev_err(&vdev->dev, "couldn't allocate host data\n");
 		goto scsi_host_alloc_failed;
 	}
 
@@ -1570,11 +1544,11 @@ static int ibmvscsi_probe(struct vio_dev
 
 	rc = ibmvscsi_init_crq_queue(&hostdata->queue, hostdata, max_requests);
 	if (rc != 0 && rc != H_RESOURCE) {
-		printk(KERN_ERR "ibmvscsi: couldn't initialize crq\n");
+		dev_err(&vdev->dev, "couldn't initialize crq. rc=%d\n", rc);
 		goto init_crq_failed;
 	}
 	if (initialize_event_pool(&hostdata->pool, max_requests, hostdata) != 0) {
-		printk(KERN_ERR "ibmvscsi: couldn't initialize event pool\n");
+		dev_err(&vdev->dev, "couldn't initialize event pool\n");
 		goto init_pool_failed;
 	}
 
diff -puN drivers/scsi/ibmvscsi/rpa_vscsi.c~ibmvscsi_printk_enhancements drivers/scsi/ibmvscsi/rpa_vscsi.c
--- linux-2.6/drivers/scsi/ibmvscsi/rpa_vscsi.c~ibmvscsi_printk_enhancements	2007-06-13 16:02:19.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/rpa_vscsi.c	2007-06-13 16:02:19.000000000 -0500
@@ -177,7 +177,7 @@ static void set_adapter_info(struct ibmv
 	memset(&hostdata->madapter_info, 0x00,
 			sizeof(hostdata->madapter_info));
 
-	printk(KERN_INFO "rpa_vscsi: SPR_VERSION: %s\n", SRP_VERSION);
+	dev_info(hostdata->dev, "SRP_VERSION: %s\n", SRP_VERSION);
 	strcpy(hostdata->madapter_info.srp_version, SRP_VERSION);
 
 	strncpy(hostdata->madapter_info.partition_name, partition_name,
@@ -232,25 +232,24 @@ int ibmvscsi_init_crq_queue(struct crq_q
 
 	if (rc == 2) {
 		/* Adapter is good, but other end is not ready */
-		printk(KERN_WARNING "ibmvscsi: Partner adapter not ready\n");
+		dev_warn(hostdata->dev, "Partner adapter not ready\n");
 		retrc = 0;
 	} else if (rc != 0) {
-		printk(KERN_WARNING "ibmvscsi: Error %d opening adapter\n", rc);
+		dev_warn(hostdata->dev, "Error %d opening adapter\n", rc);
 		goto reg_crq_failed;
 	}
 
 	if (request_irq(vdev->irq,
 			ibmvscsi_handle_event,
 			0, "ibmvscsi", (void *)hostdata) != 0) {
-		printk(KERN_ERR "ibmvscsi: couldn't register irq 0x%x\n",
-		       vdev->irq);
+		dev_err(hostdata->dev, "couldn't register irq 0x%x\n",
+			vdev->irq);
 		goto req_irq_failed;
 	}
 
 	rc = vio_enable_interrupts(vdev);
 	if (rc != 0) {
-		printk(KERN_ERR "ibmvscsi:  Error %d enabling interrupts!!!\n",
-		       rc);
+		dev_err(hostdata->dev, "Error %d enabling interrupts!!!\n", rc);
 		goto req_irq_failed;
 	}
 
@@ -294,7 +293,7 @@ int ibmvscsi_reenable_crq_queue(struct c
 	} while ((rc == H_IN_PROGRESS) || (rc == H_BUSY) || (H_IS_LONG_BUSY(rc)));
 
 	if (rc)
-		printk(KERN_ERR "ibmvscsi: Error %d enabling adapter\n", rc);
+		dev_err(hostdata->dev, "Error %d enabling adapter\n", rc);
 	return rc;
 }
 
@@ -327,10 +326,9 @@ int ibmvscsi_reset_crq_queue(struct crq_
 				queue->msg_token, PAGE_SIZE);
 	if (rc == 2) {
 		/* Adapter is good, but other end is not ready */
-		printk(KERN_WARNING "ibmvscsi: Partner adapter not ready\n");
+		dev_warn(hostdata->dev, "Partner adapter not ready\n");
 	} else if (rc != 0) {
-		printk(KERN_WARNING
-		       "ibmvscsi: couldn't register crq--rc 0x%x\n", rc);
+		dev_warn(hostdata->dev, "couldn't register crq--rc 0x%x\n", rc);
 	}
 	return rc;
 }
_
