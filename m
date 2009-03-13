From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: [RFC] FC pass thru - Rev V
Date: Fri, 13 Mar 2009 09:25:27 -0700
Message-ID: <BAD9A31D-BCDA-46F9-AE12-E310B684498F@qlogic.com>
References: <1227043498.4949.21.camel@ogier> <1234365225.24194.3.camel@ogier> <3F3E8B49-EB9A-4A6D-ABB0-3F4FC2EF7D1C@qlogic.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: text/plain; charset="US-ASCII"; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:46743 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495AbZCMQZb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Mar 2009 12:25:31 -0400
In-Reply-To: <3F3E8B49-EB9A-4A6D-ABB0-3F4FC2EF7D1C@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seokmann Ju <seokmann.ju@qlogic.com>
Cc: James Smart <James.Smart@Emulex.Com>, linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, "sven@linux.vnet.ibm.com Schuetz" <sven@linux.vnet.ibm.com>, futjita.tomonori@lab.ntt.co.jp, Boaz Harrosh <bharrosh@panasas.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>


On Feb 11, 2009, at 7:43 AM, Seokmann Ju wrote:

>
> On Feb 11, 2009, at 7:13 AM, James Smart wrote:
>
>> Trying to kick-start this again...
>> I've updated the prior RFC with the comments from Seokmann,
>> SvenFujita, and Boaz. I would still like review on the
>> blk_xxx completion calls in the std and error paths.
> I'm looking the driver changes to match it with latest updates in  
> the transport layer.
> The driver with the changes should be available within a couple of  
> weeks.
Here is a change that I've made for transport layer while I'm testing  
the feature.
---
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/ 
scsi_transport_fc.c
index 63ab7bc..4bca164 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3435,10 +3435,11 @@ fc_bsg_jobdone(struct fc_bsg_job *job)
                 BUG_ON(job->reply->reply_payload_rcv_len > rsp_len);
                 /* set reply (bidi) residual */
                 rsp->data_len = (rsp_len - job->reply- 
 >reply_payload_rcv_len);
-       }
+               blk_end_bidi_request(req, err, blk_rq_bytes(req),
+                   job->reply->reply_payload_rcv_len);

-       /* we assume all request payload was transferred */
-       blk_end_request(req, err, blk_rq_bytes(req));
+       } else
+               blk_end_request(req, err, blk_rq_bytes(req));

         fc_destroy_bsgjob(job);
  }
---

With this change, I'm able to issue several ELS/CT services to the  
qla2xxx module for those registered to the transport layer and have  
rport associated with them.

And, below is the driver changes for just review purpose.

Do we have time table for this support to make it available in the  
upstream?
I think it would be good to have the feature in 2.6.30 kernel, if  
possible.
I will continue to work on and add rest of helper function in the  
driver.

Thank you,
Seokmann

---
diff -Naurp qla2xxx-org//qla_attr.c qla2xxx//qla_attr.c
--- qla2xxx-org//qla_attr.c	2009-03-13 06:15:53.000000000 -0700
+++ qla2xxx//qla_attr.c	2009-03-13 06:15:53.000000000 -0700
@@ -1054,6 +1054,457 @@ qla2x00_terminate_rport_io(struct fc_rpo
  }

  static int
+qla2x00_issue_els(struct fc_bsg_job *bsg_job)
+{
+	struct fc_rport *rport = bsg_job->rport;
+	fc_port_t *fcport = *(fc_port_t **) rport->dd_data;
+	struct Scsi_Host *host = rport_to_shost(rport);
+	scsi_qla_host_t *vha = shost_priv(host);
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req;
+	struct rsp_que *rsp;
+	struct els_entry_24xx *els_iocb;
+	srb_t *sp;
+	unsigned long flags = 0;
+	uint32_t  handle;
+	int  index;
+	uint8_t  els_pkt[20];
+	size_t   copy_size;
+	uint16_t nextlid = 0;
+	uint16_t que_id;
+	int i;
+	int req_sg_cnt, rsp_sg_cnt;
+
+	/* ELS doesn't support multiple SG */
+	if (bsg_job->request_payload.sg_cnt > 1 ||
+	    bsg_job->reply_payload.sg_cnt > 1) {
+		qla_printk(KERN_WARNING, ha,
+		    "ERROR: multiple SG of request/response "
+		    "[%u/%u]  are not supported for ELS services\n",
+		    bsg_job->request_payload.sg_cnt,
+		    bsg_job->reply_payload.sg_cnt);
+		bsg_job->reply->result = -EIO;
+		goto pt_error0;
+	}
+
+	sp = mempool_alloc(ha->srb_mempool, GFP_ATOMIC);
+	if (!sp)
+		goto pt_error0;
+
+	sp->fcport = fcport;
+	sp->u.srv.bsg_job = bsg_job;
+	sp->flags = SRB_ELS_CT;
+
+	if (bsg_job->request->msgcode == FC_BSG_RPT_ELS) {
+		if (qla2x00_fabric_login(vha, fcport, &nextlid)) {
+			DEBUG2(qla_printk(KERN_WARNING, ha,
+			    "failed to login port %06X for ELS passthru\n",
+			    fcport->d_id.b24));
+			goto pt_error1;
+		}
+	}
+
+	que_id = vha->req_ques[0];
+	req = ha->req_q_map[que_id];
+	if (req->rsp)
+		rsp = req->rsp;
+	else
+		rsp = ha->rsp_q_map[que_id];
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	els_iocb = (struct els_entry_24xx *) qla2x00_req_pkt(vha, req, rsp);
+	if (els_iocb == NULL) {
+		qla_printk(KERN_WARNING, ha,
+		    "Passthru request failed to get request packet\n");
+		goto pt_error1;
+	}
+
+	req_sg_cnt = dma_map_sg(&ha->pdev->dev, bsg_job- 
 >request_payload.sg_list,
+	    bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
+	if (!req_sg_cnt)
+		goto pt_error1;
+	rsp_sg_cnt = dma_map_sg(&ha->pdev->dev, bsg_job- 
 >reply_payload.sg_list,
+	    bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
+	if (!rsp_sg_cnt)
+		goto pt_error2;
+
+	copy_size = sg_copy_to_buffer(bsg_job->request_payload.sg_list,
+	    bsg_job->request_payload.sg_cnt, els_pkt, 20);
+	if (!copy_size)
+		goto pt_error3;
+
+	printk("contents of ELS packet: ");
+	for (i=0;i<copy_size;i++)
+		printk("%2x ", els_pkt[i]);
+	printk("\n");
+
+	/* Check for room in outstanding command list. */
+	handle = req->current_outstanding_cmd;
+	for (index = 1; index < MAX_OUTSTANDING_COMMANDS; index++) {
+		handle++;
+		if (handle == MAX_OUTSTANDING_COMMANDS)
+			handle = 1;
+		if (!req->outstanding_cmds[handle])
+			break;
+	}
+
+	req->current_outstanding_cmd = handle;
+	req->outstanding_cmds[handle] = (srb_t *) sp;
+
+	els_iocb->handle = handle;
+
+	els_iocb->entry_type = ELS_IOCB_TYPE;
+	els_iocb->entry_count = 1;
+	els_iocb->sys_define = 0;
+	els_iocb->entry_status = 0;
+	els_iocb->nport_handle = cpu_to_le16(fcport->loop_id);
+	els_iocb->tx_dsd_count = __constant_cpu_to_le16(1);
+	els_iocb->vp_index = vha->vp_idx;
+	els_iocb->sof_type = EST_SOFI3;
+	els_iocb->rx_dsd_count = __constant_cpu_to_le16(1);
+	els_iocb->opcode = bsg_job->request->rqst_data.r_els.els_code;
+	els_iocb->port_id[0] = fcport->d_id.b.al_pa;
+	els_iocb->port_id[1] = fcport->d_id.b.area;
+	els_iocb->port_id[2] = fcport->d_id.b.domain;
+	els_iocb->control_flags = 0;
+	els_iocb->rx_byte_count =
+	    cpu_to_le32(bsg_job->reply_payload.payload_len);
+	els_iocb->tx_byte_count =
+	    cpu_to_le32(bsg_job->request_payload.payload_len);
+	els_iocb->tx_address[0] = cpu_to_le32(LSD(sg_dma_address
+	    (bsg_job->request_payload.sg_list)));
+	els_iocb->tx_address[1] = cpu_to_le32(MSD(sg_dma_address
+	    (bsg_job->request_payload.sg_list)));
+
+	els_iocb->tx_len = cpu_to_le32(sg_dma_len
+	    (bsg_job->request_payload.sg_list));
+
+	els_iocb->rx_address[0] = cpu_to_le32(LSD(sg_dma_address
+	    (bsg_job->reply_payload.sg_list)));
+	els_iocb->rx_address[1] = cpu_to_le32(MSD(sg_dma_address
+	    (bsg_job->reply_payload.sg_list)));
+
+	els_iocb->rx_len = cpu_to_le32(sg_dma_len
+	    (bsg_job->reply_payload.sg_list));
+
+	wmb();
+	qla2x00_isp_cmd(vha, req);
+
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	return 0;
+pt_error3:
+	dma_unmap_sg(&ha->pdev->dev, bsg_job->reply_payload.sg_list,
+	    bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
+pt_error2:
+	dma_unmap_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
+	    bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
+pt_error1:
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	mempool_free(sp, ha->srb_mempool);
+pt_error0:
+	qla_printk(KERN_WARNING, ha, "ELS passthru failed\n");
+	bsg_job->reply->result = -EIO;
+ 	bsg_job->reply->reply_payload_rcv_len = 0;
+ 	bsg_job->job_done(bsg_job);
+
+	return -EINVAL;
+}
+
+static int
+qla2x00_issue_ct(struct fc_bsg_job *bsg_job)
+{
+	struct fc_rport *rport = bsg_job->rport;
+	fc_port_t *fcport = *(fc_port_t **) rport->dd_data;
+	struct Scsi_Host *host = rport_to_shost(rport);
+	scsi_qla_host_t *vha = shost_priv(host);
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req;
+	struct rsp_que *rsp;
+	struct ct_entry_24xx *ct_iocb;
+	srb_t *sp;
+	unsigned long flags;
+	uint32_t  handle;
+	int  index;
+	uint8_t  ct_pkt[20];
+	size_t   copy_size;
+	int  req_sg_cnt, rsp_sg_cnt;
+	uint16_t avail_dsds;
+	uint32_t *cur_dsd;
+	struct scatterlist *sg;
+	uint16_t que_id;
+	int i;
+
+	sp = mempool_alloc(ha->srb_mempool, GFP_ATOMIC);
+	if (!sp)
+		goto pt_error0;
+
+	sp->fcport = fcport;
+	sp->u.srv.bsg_job = bsg_job;
+	sp->flags = SRB_ELS_CT;
+
+	que_id = vha->req_ques[0];
+	req = ha->req_q_map[que_id];
+	if (req->rsp)
+		rsp = req->rsp;
+	else
+		rsp = ha->rsp_q_map[que_id];
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	ct_iocb = (struct ct_entry_24xx *) qla2x00_req_pkt(vha, req, rsp);
+	if (ct_iocb == NULL) {
+		qla_printk(KERN_WARNING, ha,
+		    "Passthru request failed to get request packet\n");
+		goto pt_error1;
+	}
+
+	req_sg_cnt = dma_map_sg(&ha->pdev->dev, bsg_job- 
 >request_payload.sg_list,
+	    bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
+	if (!req_sg_cnt)
+		goto pt_error1;
+	rsp_sg_cnt = dma_map_sg(&ha->pdev->dev, bsg_job- 
 >reply_payload.sg_list,
+	    bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
+	if (!rsp_sg_cnt)
+		goto pt_error2;
+
+	copy_size = sg_copy_to_buffer(bsg_job->request_payload.sg_list,
+	    bsg_job->request_payload.sg_cnt, ct_pkt, 20);
+	if (!copy_size)
+		goto pt_error2;
+
+	printk("contents of CT packet: ");
+	for (i=0;i<copy_size;i++)
+		printk("%2x ", ct_pkt[i]);
+	printk("\n");
+
+	/* Check for room in outstanding command list. */
+	handle = req->current_outstanding_cmd;
+	for (index = 1; index < MAX_OUTSTANDING_COMMANDS; index++) {
+		handle++;
+		if (handle == MAX_OUTSTANDING_COMMANDS)
+			handle = 1;
+		if (!req->outstanding_cmds[handle])
+			break;
+	}
+
+	req->current_outstanding_cmd = handle;
+	req->outstanding_cmds[handle] = (srb_t *) sp;
+
+	ct_iocb->handle = handle;
+
+	ct_iocb->entry_type = CT_IOCB_TYPE;
+	ct_iocb->entry_count = 1;
+	ct_iocb->entry_status = 0;
+	ct_iocb->comp_status = __constant_cpu_to_le16(0);
+	if (IS_FWI2_CAPABLE(ha))
+		ct_iocb->nport_handle = cpu_to_le16(NPH_SNS);
+	else
+		ct_iocb->nport_handle =
+		    cpu_to_le16(SIMPLE_NAME_SERVER);
+	ct_iocb->cmd_dsd_count =
+	    __constant_cpu_to_le16(req_sg_cnt);
+	ct_iocb->vp_index = vha->vp_idx;
+	ct_iocb->timeout = 0;
+	ct_iocb->rsp_dsd_count =
+	    __constant_cpu_to_le16(rsp_sg_cnt);
+	ct_iocb->rsp_byte_count =
+	    cpu_to_le32(bsg_job->reply_payload.payload_len);
+	ct_iocb->cmd_byte_count =
+	    cpu_to_le32(bsg_job->request_payload.payload_len);
+	ct_iocb->dseg_0_address[0] = cpu_to_le32(LSD(sg_dma_address
+	    (bsg_job->request_payload.sg_list)));
+	ct_iocb->dseg_0_address[1] = cpu_to_le32(MSD(sg_dma_address
+	    (bsg_job->request_payload.sg_list)));
+
+	ct_iocb->dseg_0_len = cpu_to_le32(sg_dma_len
+	    (bsg_job->request_payload.sg_list));
+
+	rsp_sg_cnt = bsg_job->reply_payload.sg_cnt;
+	avail_dsds = 1;
+	cur_dsd = (uint32_t *)ct_iocb->dseg_1_address;
+	index = 0;
+	for_each_sg(bsg_job->reply_payload.sg_list, sg, rsp_sg_cnt, index) {
+		dma_addr_t       sle_dma;
+		cont_a64_entry_t *cont_pkt;
+
+		/* Allocate additional continuation packets? */
+		if (avail_dsds == 0) {
+			/*
+			 * Five DSDs are available in the Cont.
+			 * Type 1 IOCB.
+			 */
+			cont_pkt = qla2x00_prep_cont_type1_iocb(req, vha);
+			cur_dsd = (uint32_t *) cont_pkt->dseg_0_address;
+			avail_dsds = 5;
+		}
+
+		sle_dma = sg_dma_address(sg);
+		*cur_dsd++ = cpu_to_le32(LSD(sle_dma));
+		*cur_dsd++ = cpu_to_le32(MSD(sle_dma));
+		*cur_dsd++ = cpu_to_le32(sg_dma_len(sg));
+		avail_dsds--;
+	}
+
+	wmb();
+	qla2x00_isp_cmd(vha, req);
+
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	return 0;
+
+pt_error2:
+	dma_unmap_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
+	    bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
+pt_error1:
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	mempool_free(sp, ha->srb_mempool);
+pt_error0:
+	qla_printk(KERN_WARNING, ha, "CT passthru failed\n");
+	bsg_job->reply->result = -EIO;
+ 	bsg_job->job_done(bsg_job);
+
+	return -EINVAL;
+}
+
+static int
+qla2x00_issue_add_rport(struct fc_bsg_job *bsg_job)
+{
+	printk("%s is under construction\n", __func__);
+	return -EINVAL;
+}
+
+static int
+qla2x00_issue_delete_rport(struct fc_bsg_job *bsg_job)
+{
+	printk("%s is under construction\n", __func__);
+	return -EINVAL;
+}
+
+static int
+qla2x00_issue_vendor_specific(struct fc_bsg_job *bsg_job)
+{
+	printk("%s is under construction\n", __func__);
+	return -EINVAL;
+}
+
+static int
+qla24xx_bsg_request(struct fc_bsg_job *bsg_job)
+{
+	int ret = 0;
+	fc_port_t *fcport;
+	struct Scsi_Host *host;
+	scsi_qla_host_t *vha;
+	struct qla_hw_data *ha;
+
+	if (bsg_job->rport) {
+		if (bsg_job->rport->port_state != FC_PORTSTATE_ONLINE)
+			goto pt_error;
+
+		fcport = *(fc_port_t **) bsg_job->rport->dd_data;
+		host = rport_to_shost(bsg_job->rport);
+	} else {
+		printk("PASS-THRU: %s: HOST under construction\n", __func__);
+		ret = -EINVAL;
+		goto pt_error;
+	}
+
+	/* if fcport is NULL */
+	if (!fcport)
+		goto pt_error;
+
+	vha = shost_priv(host);
+	ha = vha->hw;
+
+	/* At this time, pass throug supported by 4Gb or higher */
+	if (!IS_FWI2_CAPABLE(ha))
+		goto pt_error;
+
+	switch (bsg_job->request->msgcode) {
+	case FC_BSG_RPT_ELS:
+		ret = qla2x00_issue_els(bsg_job);
+		break;
+	case FC_BSG_RPT_CT:
+		ret = qla2x00_issue_ct(bsg_job);
+		break;
+	case FC_BSG_HST_ADD_RPORT:
+		ret = qla2x00_issue_add_rport(bsg_job);
+		break;
+	case FC_BSG_HST_DEL_RPORT:
+		ret = qla2x00_issue_delete_rport(bsg_job);
+		break;
+	case FC_BSG_HST_ELS_NOLOGIN:
+		ret = qla2x00_issue_els(bsg_job);
+		break;
+	case FC_BSG_HST_VENDOR:
+		ret = qla2x00_issue_vendor_specific(bsg_job);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	if (ret)
+		goto pt_error;
+
+	return ret;
+
+pt_error:
+	printk(KERN_WARNING "ERROR: failed to issue job\n");
+	return ret;
+}
+
+static int
+qla24xx_bsg_timeout(struct fc_bsg_job *bsg_job)
+{
+	scsi_qla_host_t *vha = shost_priv(bsg_job->shost);
+	srb_t *sp;
+	int ret, i;
+	unsigned long flags;
+	int wait = 0;
+	struct qla_hw_data *ha = vha->hw;
+	uint16_t que_id;
+	struct req_que *req;
+	struct rsp_que *rsp;
+
+	ret = SUCCESS;
+
+	que_id = vha->req_ques[0];
+	req = ha->req_q_map[que_id];
+	if (req->rsp)
+		rsp = req->rsp;
+	else
+		rsp = ha->rsp_q_map[que_id];
+
+	/* Check active list for command command. */
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	for (i = 1; i < MAX_OUTSTANDING_COMMANDS; i++) {
+		sp = req->outstanding_cmds[i];
+
+		if (sp == NULL)
+			continue;
+
+		if ((sp->flags != SRB_ELS_CT) ||
+		    (sp->u.srv.bsg_job != bsg_job))
+			continue;
+
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+		if (ha->isp_ops->abort_command(vha, sp, req)) {
+			DEBUG2(printk("%s(%ld): abort_command "
+			    "mbx failed.\n", __func__, vha->host_no));
+			ret = FAILED;
+		} else {
+			DEBUG3(printk("%s(%ld): abort_command "
+			    "mbx success.\n", __func__, vha->host_no));
+			wait = 1;
+		}
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+
+		break;
+	}
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	return ret;
+}
+
+static int
  qla2x00_issue_lip(struct Scsi_Host *shost)
  {
  	scsi_qla_host_t *vha = shost_priv(shost);
@@ -1353,6 +1804,9 @@ struct fc_function_template qla2xxx_tran
  	.vport_create = qla24xx_vport_create,
  	.vport_disable = qla24xx_vport_disable,
  	.vport_delete = qla24xx_vport_delete,
+
+	.bsg_request = qla24xx_bsg_request,
+	.bsg_timeout = qla24xx_bsg_timeout,
  };

  struct fc_function_template qla2xxx_transport_vport_functions = {
@@ -1393,6 +1847,9 @@ struct fc_function_template qla2xxx_tran
  	.dev_loss_tmo_callbk = qla2x00_dev_loss_tmo_callbk,
  	.terminate_rport_io = qla2x00_terminate_rport_io,
  	.get_fc_host_stats = qla2x00_get_fc_host_stats,
+
+	.bsg_request = qla24xx_bsg_request,
+	.bsg_timeout = qla24xx_bsg_timeout,
  };

  void
diff -Naurp qla2xxx-org//qla_def.h qla2xxx//qla_def.h
--- qla2xxx-org//qla_def.h	2009-03-13 06:15:53.000000000 -0700
+++ qla2xxx//qla_def.h	2009-03-13 06:15:53.000000000 -0700
@@ -31,6 +31,7 @@
  #include <scsi/scsi_device.h>
  #include <scsi/scsi_cmnd.h>
  #include <scsi/scsi_transport_fc.h>
+#include <scsi/scsi_bsg_fc.h>

  #define QLA2XXX_DRIVER_NAME  "qla2xxx"

diff -Naurp qla2xxx-org//qla_isr.c qla2xxx//qla_isr.c
--- qla2xxx-org//qla_isr.c	2009-03-13 06:15:53.000000000 -0700
+++ qla2xxx//qla_isr.c	2009-03-13 06:15:53.000000000 -0700
@@ -1536,10 +1536,74 @@ qla24xx_process_response_queue(struct rs
  		case STATUS_CONT_TYPE:
  			qla2x00_status_cont_entry(vha, (sts_cont_entry_t *)pkt);
  			break;
+ 		case MS_IOCB_TYPE:
+ 		case ELS_IOCB_TYPE:
+ 			if (pkt->handle < MAX_OUTSTANDING_COMMANDS) {
+ 				sp = req->outstanding_cmds[pkt->handle];
+				if (sp->flags != SRB_ELS_CT)
+					break;
+ 				bsg_job = sp->u.srv.bsg_job;
+ 				req->outstanding_cmds[pkt->handle] = NULL;
+ 			} else {
+ 				bsg_job = NULL;
+ 				break;
+ 			}
+
+ 			bsg_job->reply->result = 0;
+ 			bsg_job->reply->reply_payload_rcv_len =
+ 			    bsg_job->reply_payload.payload_len;
+
+ 			if (comp_status) {
+ 				bsg_job->reply->result = -EIO;
+ 				printk(KERN_WARNING "scsi(%ld): ELS/CT: "
+ 				    "comp_status = %x\n", vha->host_no,
+ 				    comp_status);
+ 				bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =  
comp_status;
+ 				if ((comp_status >> 8) == CS_DATA_UNDERRUN)
+ 					bsg_job->reply->reply_payload_rcv_len =
+ 					    bsg_job->reply_payload.payload_len;
+ 				else if ((comp_status >> 8) == CS_ABORTED) {
+ 					bsg_job->reply->result = -EIO;
+ 				}
+ 			}
+
+			dma_unmap_sg(&ha->pdev->dev,
+			    bsg_job->request_payload.sg_list,
+			    bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
+			dma_unmap_sg(&ha->pdev->dev,
+			    bsg_job->reply_payload.sg_list,
+			    bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
+
+ 			mempool_free(sp, ha->srb_mempool);
+ 			bsg_job->job_done(bsg_job);
+ 			break;
  		case VP_RPT_ID_IOCB_TYPE:
  			qla24xx_report_id_acquisition(vha,
  			    (struct vp_rpt_id_entry_24xx *)pkt);
  			break;
+ 		case ABORT_IOCB_TYPE:
+ 			if (comp_status) {
+ 				if (pkt->handle < MAX_OUTSTANDING_COMMANDS) {
+ 					sp = req->outstanding_cmds[pkt->handle];
+ 					req->outstanding_cmds[pkt->handle] =
+ 					    NULL;
+ 					if (sp->flags & SRB_ELS_CT) {
+ 						bsg_job =
+						    (struct fc_bsg_job *)
+						    sp->u.srv.bsg_job;
+ 						qla_printk(KERN_ERR, ha,
+ 						    "failed to abort"
+ 						    " FC service %p\n",
+ 						    bsg_job);
+						/* TBD - what else to do? */
+ 					} else
+ 						qla_printk(KERN_ERR, ha,
+ 						    "failed to abort"
+ 						    " SCSI CMD[0] = %2x\n",
+ 						    sp->u.io.cmd->cmnd[0]);
+ 				}
+ 			}
+ 			break;
  		default:
  			/* Type Not Supported. */
  			DEBUG4(printk(KERN_WARNING
---

