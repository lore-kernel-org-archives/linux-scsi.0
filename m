From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCHv2 5/6] ibmvfc: Add FC Passthru support
Date: Mon, 19 Oct 2009 15:07:54 -0500
Message-ID: <200910192009.n9JK9N9B026479@d03av06.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:46927 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757436AbZJSUH5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Oct 2009 16:07:57 -0400
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e35.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n9JJv2eM007345
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2009 13:57:02 -0600
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n9JK7teG143464
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2009 14:07:56 -0600
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n9JK9N7R026493
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2009 14:09:24 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Adds support for FC passthru via BSG.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |  279 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ibmvscsi/ibmvfc.h |    8 +
 2 files changed, 286 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_fc_pass_thru drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_fc_pass_thru	2009-10-19 12:30:19.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2009-10-19 12:30:19.000000000 -0500
@@ -39,6 +39,7 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_transport_fc.h>
+#include <scsi/scsi_bsg_fc.h>
 #include "ibmvfc.h"
 
 static unsigned int init_timeout = IBMVFC_INIT_TIMEOUT;
@@ -1675,6 +1676,276 @@ static void ibmvfc_sync_completion(struc
 }
 
 /**
+ * ibmvfc_bsg_timeout_done - Completion handler for cancelling BSG commands
+ * @evt:	struct ibmvfc_event
+ *
+ **/
+static void ibmvfc_bsg_timeout_done(struct ibmvfc_event *evt)
+{
+	struct ibmvfc_host *vhost = evt->vhost;
+
+	ibmvfc_free_event(evt);
+	vhost->aborting_passthru = 0;
+	dev_info(vhost->dev, "Passthru command cancelled\n");
+}
+
+/**
+ * ibmvfc_bsg_timeout - Handle a BSG timeout
+ * @job:	struct fc_bsg_job that timed out
+ *
+ * Returns:
+ *	0 on success / other on failure
+ **/
+static int ibmvfc_bsg_timeout(struct fc_bsg_job *job)
+{
+	struct ibmvfc_host *vhost = shost_priv(job->shost);
+	unsigned long port_id = (unsigned long)job->dd_data;
+	struct ibmvfc_event *evt;
+	struct ibmvfc_tmf *tmf;
+	unsigned long flags;
+	int rc;
+
+	ENTER;
+	spin_lock_irqsave(vhost->host->host_lock, flags);
+	if (vhost->aborting_passthru || vhost->state != IBMVFC_ACTIVE) {
+		__ibmvfc_reset_host(vhost);
+		spin_unlock_irqrestore(vhost->host->host_lock, flags);
+		return 0;
+	}
+
+	vhost->aborting_passthru = 1;
+	evt = ibmvfc_get_event(vhost);
+	ibmvfc_init_event(evt, ibmvfc_bsg_timeout_done, IBMVFC_MAD_FORMAT);
+
+	tmf = &evt->iu.tmf;
+	memset(tmf, 0, sizeof(*tmf));
+	tmf->common.version = 1;
+	tmf->common.opcode = IBMVFC_TMF_MAD;
+	tmf->common.length = sizeof(*tmf);
+	tmf->scsi_id = port_id;
+	tmf->cancel_key = IBMVFC_PASSTHRU_CANCEL_KEY;
+	tmf->my_cancel_key = IBMVFC_INTERNAL_CANCEL_KEY;
+	rc = ibmvfc_send_event(evt, vhost, default_timeout);
+
+	if (rc != 0) {
+		vhost->aborting_passthru = 0;
+		dev_err(vhost->dev, "Failed to send cancel event. rc=%d\n", rc);
+		rc = -EIO;
+	} else
+		dev_info(vhost->dev, "Cancelling passthru command to port id 0x%lx\n",
+			 port_id);
+
+	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+
+	LEAVE;
+	return rc;
+}
+
+/**
+ * ibmvfc_bsg_plogi - PLOGI into a target to handle a BSG command
+ * @vhost:		struct ibmvfc_host to send command
+ * @port_id:	port ID to send command
+ *
+ * Returns:
+ *	0 on success / other on failure
+ **/
+static int ibmvfc_bsg_plogi(struct ibmvfc_host *vhost, unsigned int port_id)
+{
+	struct ibmvfc_port_login *plogi;
+	struct ibmvfc_target *tgt;
+	struct ibmvfc_event *evt;
+	union ibmvfc_iu rsp_iu;
+	unsigned long flags;
+	int rc = 0, issue_login = 1;
+
+	ENTER;
+	spin_lock_irqsave(vhost->host->host_lock, flags);
+	list_for_each_entry(tgt, &vhost->targets, queue) {
+		if (tgt->scsi_id == port_id) {
+			issue_login = 0;
+			break;
+		}
+	}
+
+	if (!issue_login)
+		goto unlock_out;
+	if (unlikely((rc = ibmvfc_host_chkready(vhost))))
+		goto unlock_out;
+
+	evt = ibmvfc_get_event(vhost);
+	ibmvfc_init_event(evt, ibmvfc_sync_completion, IBMVFC_MAD_FORMAT);
+	plogi = &evt->iu.plogi;
+	memset(plogi, 0, sizeof(*plogi));
+	plogi->common.version = 1;
+	plogi->common.opcode = IBMVFC_PORT_LOGIN;
+	plogi->common.length = sizeof(*plogi);
+	plogi->scsi_id = port_id;
+	evt->sync_iu = &rsp_iu;
+	init_completion(&evt->comp);
+
+	rc = ibmvfc_send_event(evt, vhost, default_timeout);
+	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+
+	if (rc)
+		return -EIO;
+
+	wait_for_completion(&evt->comp);
+
+	if (rsp_iu.plogi.common.status)
+		rc = -EIO;
+
+	spin_lock_irqsave(vhost->host->host_lock, flags);
+	ibmvfc_free_event(evt);
+unlock_out:
+	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+	LEAVE;
+	return rc;
+}
+
+/**
+ * ibmvfc_bsg_request - Handle a BSG request
+ * @job:	struct fc_bsg_job to be executed
+ *
+ * Returns:
+ *	0 on success / other on failure
+ **/
+static int ibmvfc_bsg_request(struct fc_bsg_job *job)
+{
+	struct ibmvfc_host *vhost = shost_priv(job->shost);
+	struct fc_rport *rport = job->rport;
+	struct ibmvfc_passthru_mad *mad;
+	struct ibmvfc_event *evt;
+	union ibmvfc_iu rsp_iu;
+	unsigned long flags, port_id = -1;
+	unsigned int code = job->request->msgcode;
+	int rc = 0, req_seg, rsp_seg, issue_login = 0;
+	u32 fc_flags, rsp_len;
+
+	ENTER;
+	job->reply->reply_payload_rcv_len = 0;
+	if (rport)
+		port_id = rport->port_id;
+
+	switch (code) {
+	case FC_BSG_HST_ELS_NOLOGIN:
+		port_id = (job->request->rqst_data.h_els.port_id[0] << 16) |
+			(job->request->rqst_data.h_els.port_id[1] << 8) |
+			job->request->rqst_data.h_els.port_id[2];
+	case FC_BSG_RPT_ELS:
+		fc_flags = IBMVFC_FC_ELS;
+		break;
+	case FC_BSG_HST_CT:
+		issue_login = 1;
+		port_id = (job->request->rqst_data.h_ct.port_id[0] << 16) |
+			(job->request->rqst_data.h_ct.port_id[1] << 8) |
+			job->request->rqst_data.h_ct.port_id[2];
+	case FC_BSG_RPT_CT:
+		fc_flags = IBMVFC_FC_CT_IU;
+		break;
+	default:
+		return -ENOTSUPP;
+	};
+
+	if (port_id == -1)
+		return -EINVAL;
+	if (!mutex_trylock(&vhost->passthru_mutex))
+		return -EBUSY;
+
+	job->dd_data = (void *)port_id;
+	req_seg = dma_map_sg(vhost->dev, job->request_payload.sg_list,
+			     job->request_payload.sg_cnt, DMA_TO_DEVICE);
+
+	if (!req_seg) {
+		mutex_unlock(&vhost->passthru_mutex);
+		return -ENOMEM;
+	}
+
+	rsp_seg = dma_map_sg(vhost->dev, job->reply_payload.sg_list,
+			     job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
+
+	if (!rsp_seg) {
+		dma_unmap_sg(vhost->dev, job->request_payload.sg_list,
+			     job->request_payload.sg_cnt, DMA_TO_DEVICE);
+		mutex_unlock(&vhost->passthru_mutex);
+		return -ENOMEM;
+	}
+
+	if (req_seg > 1 || rsp_seg > 1) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	if (issue_login)
+		rc = ibmvfc_bsg_plogi(vhost, port_id);
+
+	spin_lock_irqsave(vhost->host->host_lock, flags);
+
+	if (unlikely(rc || (rport && (rc = fc_remote_port_chkready(rport)))) ||
+	    unlikely((rc = ibmvfc_host_chkready(vhost)))) {
+		spin_unlock_irqrestore(vhost->host->host_lock, flags);
+		goto out;
+	}
+
+	evt = ibmvfc_get_event(vhost);
+	ibmvfc_init_event(evt, ibmvfc_sync_completion, IBMVFC_MAD_FORMAT);
+	mad = &evt->iu.passthru;
+
+	memset(mad, 0, sizeof(*mad));
+	mad->common.version = 1;
+	mad->common.opcode = IBMVFC_PASSTHRU;
+	mad->common.length = sizeof(*mad) - sizeof(mad->fc_iu) - sizeof(mad->iu);
+
+	mad->cmd_ioba.va = (u64)evt->crq.ioba +
+		offsetof(struct ibmvfc_passthru_mad, iu);
+	mad->cmd_ioba.len = sizeof(mad->iu);
+
+	mad->iu.cmd_len = job->request_payload.payload_len;
+	mad->iu.rsp_len = job->reply_payload.payload_len;
+	mad->iu.flags = fc_flags;
+	mad->iu.cancel_key = IBMVFC_PASSTHRU_CANCEL_KEY;
+
+	mad->iu.cmd.va = sg_dma_address(job->request_payload.sg_list);
+	mad->iu.cmd.len = sg_dma_len(job->request_payload.sg_list);
+	mad->iu.rsp.va = sg_dma_address(job->reply_payload.sg_list);
+	mad->iu.rsp.len = sg_dma_len(job->reply_payload.sg_list);
+	mad->iu.scsi_id = port_id;
+	mad->iu.tag = (u64)evt;
+	rsp_len = mad->iu.rsp.len;
+
+	evt->sync_iu = &rsp_iu;
+	init_completion(&evt->comp);
+	rc = ibmvfc_send_event(evt, vhost, 0);
+	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+
+	if (rc) {
+		rc = -EIO;
+		goto out;
+	}
+
+	wait_for_completion(&evt->comp);
+
+	if (rsp_iu.passthru.common.status)
+		rc = -EIO;
+	else
+		job->reply->reply_payload_rcv_len = rsp_len;
+
+	spin_lock_irqsave(vhost->host->host_lock, flags);
+	ibmvfc_free_event(evt);
+	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+	job->reply->result = rc;
+	job->job_done(job);
+	rc = 0;
+out:
+	dma_unmap_sg(vhost->dev, job->request_payload.sg_list,
+		     job->request_payload.sg_cnt, DMA_TO_DEVICE);
+	dma_unmap_sg(vhost->dev, job->reply_payload.sg_list,
+		     job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
+	mutex_unlock(&vhost->passthru_mutex);
+	LEAVE;
+	return rc;
+}
+
+/**
  * ibmvfc_reset_device - Reset the device with the specified reset type
  * @sdev:	scsi device to reset
  * @type:	reset type
@@ -3918,6 +4189,8 @@ static void ibmvfc_tgt_add_rport(struct
 			rport->supported_classes |= FC_COS_CLASS2;
 		if (tgt->service_parms.class3_parms[0] & 0x80000000)
 			rport->supported_classes |= FC_COS_CLASS3;
+		if (rport->rqst_q)
+			blk_queue_max_hw_segments(rport->rqst_q, 1);
 	} else
 		tgt_dbg(tgt, "rport add failed\n");
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
@@ -4357,6 +4630,7 @@ static int ibmvfc_probe(struct vio_dev *
 	init_waitqueue_head(&vhost->work_wait_q);
 	init_waitqueue_head(&vhost->init_wait_q);
 	INIT_WORK(&vhost->rport_add_work_q, ibmvfc_rport_add_thread);
+	mutex_init(&vhost->passthru_mutex);
 
 	if ((rc = ibmvfc_alloc_mem(vhost)))
 		goto free_scsi_host;
@@ -4389,6 +4663,8 @@ static int ibmvfc_probe(struct vio_dev *
 		goto remove_shost;
 	}
 
+	if (shost_to_fc_host(shost)->rqst_q)
+		blk_queue_max_hw_segments(shost_to_fc_host(shost)->rqst_q, 1);
 	dev_set_drvdata(dev, vhost);
 	spin_lock(&ibmvfc_driver_lock);
 	list_add_tail(&vhost->queue, &ibmvfc_head);
@@ -4517,6 +4793,9 @@ static struct fc_function_template ibmvf
 
 	.get_starget_port_id = ibmvfc_get_starget_port_id,
 	.show_starget_port_id = 1,
+
+	.bsg_request = ibmvfc_bsg_request,
+	.bsg_timeout = ibmvfc_bsg_timeout,
 };
 
 /**
diff -puN drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_fc_pass_thru drivers/scsi/ibmvscsi/ibmvfc.h
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_fc_pass_thru	2009-10-19 12:30:19.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.h	2009-10-19 14:59:41.000000000 -0500
@@ -58,9 +58,10 @@
  * 1 for ERP
  * 1 for initialization
  * 1 for NPIV Logout
+ * 2 for BSG passthru
  * 2 for each discovery thread
  */
-#define IBMVFC_NUM_INTERNAL_REQ	(1 + 1 + 1 + (disc_threads * 2))
+#define IBMVFC_NUM_INTERNAL_REQ	(1 + 1 + 1 + 2 + (disc_threads * 2))
 
 #define IBMVFC_MAD_SUCCESS		0x00
 #define IBMVFC_MAD_NOT_SUPPORTED	0xF1
@@ -466,7 +467,10 @@ struct ibmvfc_passthru_iu {
 	u16 error;
 	u32 flags;
 #define IBMVFC_FC_ELS		0x01
+#define IBMVFC_FC_CT_IU		0x02
 	u32 cancel_key;
+#define IBMVFC_PASSTHRU_CANCEL_KEY	0x80000000
+#define IBMVFC_INTERNAL_CANCEL_KEY	0x80000001
 	u32 reserved;
 	struct srp_direct_buf cmd;
 	struct srp_direct_buf rsp;
@@ -693,6 +697,7 @@ struct ibmvfc_host {
 	int disc_buf_sz;
 	int log_level;
 	struct ibmvfc_discover_targets_buf *disc_buf;
+	struct mutex passthru_mutex;
 	int task_set;
 	int init_retries;
 	int discovery_threads;
@@ -702,6 +707,7 @@ struct ibmvfc_host {
 	int delay_init;
 	int scan_complete;
 	int logged_in;
+	int aborting_passthru;
 	int events_to_log;
 #define IBMVFC_AE_LINKUP	0x0001
 #define IBMVFC_AE_LINKDOWN	0x0002
_
