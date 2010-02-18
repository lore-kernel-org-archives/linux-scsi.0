From: giridhar.malavali@qlogic.com
Subject: [PATCH 2/8] qla2xxx: Proper clean-up of BSG requests when request times out.
Date: Thu, 18 Feb 2010 10:07:24 -0800
Message-ID: <1266516450-472-3-git-send-email-giridhar.malavali@qlogic.com>
References: <1266516450-472-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:54296 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1751364Ab0BRSHe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Feb 2010 13:07:34 -0500
In-Reply-To: <1266516450-472-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, stable@kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Fix for BSG request cleanup when the request timesout.
Proper release of driver resources used for BSG request during timeout cleanup.
Cc: stable@kernel.org
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |  125 +++++++++++++++++----------------------
 drivers/scsi/qla2xxx/qla_os.c   |   15 ++++-
 2 files changed, 67 insertions(+), 73 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index cbce52e..25596fe 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1882,12 +1882,6 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
 		ha = vha->hw;
 		type = "FC_BSG_RPT_ELS";
 
-		DEBUG2(printk(KERN_INFO
-		    "scsi(%ld): loop-id=%x portid=%02x%02x%02x.\n",
-		    fcport->vha->host_no, fcport->loop_id,
-		    fcport->d_id.b.domain, fcport->d_id.b.area,
-		    fcport->d_id.b.al_pa));
-
 		/* make sure the rport is logged in,
 		 * if not perform fabric login
 		 */
@@ -1904,11 +1898,6 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
 		ha = vha->hw;
 		type = "FC_BSG_HST_ELS_NOLOGIN";
 
-		DEBUG2(printk(KERN_INFO
-		    "scsi(%ld): loop-id=%x portid=%02x%02x%02x.\n",
-		    vha->host_no, vha->loop_id,
-		    vha->d_id.b.domain, vha->d_id.b.area, vha->d_id.b.al_pa));
-
 		/* Allocate a dummy fcport structure, since functions
 		 * preparing the IOCB and mailbox command retrieves port
 		 * specific information from fcport structure. For Host based
@@ -1934,9 +1923,12 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
 		    NPH_FABRIC_CONTROLLER : NPH_F_PORT;
 	}
 
-	DEBUG2(printk(KERN_INFO
-	    "scsi(%ld): vendor-id = %llu\n",
-	    vha->host_no, host->hostt->vendor_id));
+	if (!vha->flags.online) {
+		DEBUG2(qla_printk(KERN_WARNING, ha,
+		    "host not online\n"));
+		rval = -EIO;
+		goto done;
+	}
 
         req_sg_cnt =
 	    dma_map_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
@@ -2059,6 +2051,13 @@ qla2x00_process_ct(struct fc_bsg_job *bsg_job)
                 goto done_unmap_sg;
 	}
 
+	if (!vha->flags.online) {
+		DEBUG2(qla_printk(KERN_WARNING, ha,
+		    "host not online\n"));
+		rval = -EIO;
+                goto done_unmap_sg;
+	}
+
 	loop_id =
 	    (bsg_job->request->rqst_data.h_ct.preamble_word1 & 0xFF000000)
 	    >> 24;
@@ -2161,6 +2160,13 @@ qla2x00_process_vendor_specific(struct fc_bsg_job *bsg_job)
 		goto done;
 	}
 
+	if (!vha->flags.online) {
+		DEBUG2(qla_printk(KERN_WARNING, ha,
+		    "host not online\n"));
+		rval = -EIO;
+                goto done;
+	}
+
         elreq.req_sg_cnt =
 	    dma_map_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
 	    bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
@@ -2219,20 +2225,10 @@ qla2x00_process_vendor_specific(struct fc_bsg_job *bsg_job)
 		if (ha->current_topology != ISP_CFG_F) {
 			type = "FC_BSG_HST_VENDOR_LOOPBACK";
 
-			if ((IS_QLA81XX(ha)) &&
-				((elreq.options == 0) || (elreq.options == 2))) {
-				DEBUG2(qla_printk(KERN_INFO, ha, "scsi(%ld)"
-				"loopback option:0x%x not supported\n", vha->host_no, elreq.options));
-				rval = -EINVAL;
-				goto done_unmap_sg;
-			}
-
 			DEBUG2(qla_printk(KERN_INFO, ha,
 				"scsi(%ld) bsg rqst type: %s vendor rqst type: %x options: %x.\n",
 				vha->host_no, type, vendor_cmd, elreq.options));
-			DEBUG2(qla_printk(KERN_INFO, ha,
-				"scsi(%ld) tx_addr: 0x%llx rx_addr: 0x%llx tx_sg_cnt: %x rx_sg_cnt: %x\n",
-				vha->host_no, (unsigned long long)elreq.send_dma, (unsigned long long)elreq.rcv_dma, elreq.req_sg_cnt, elreq.rsp_sg_cnt));
+
 			command_sent = INT_DEF_LB_LOOPBACK_CMD;
 			rval = qla2x00_loopback_test(vha, &elreq, response);
 			if (IS_QLA81XX(ha)) {
@@ -2248,9 +2244,7 @@ qla2x00_process_vendor_specific(struct fc_bsg_job *bsg_job)
 			DEBUG2(qla_printk(KERN_INFO, ha,
 				"scsi(%ld) bsg rqst type: %s vendor rqst type: %x options: %x.\n",
 				vha->host_no, type, vendor_cmd, elreq.options));
-			DEBUG2(qla_printk(KERN_INFO, ha,
-				"scsi(%ld) tx_addr: 0x%llx rx_addr: 0x%llx tx_sg_cnt: %x rx_sg_cnt: %x\n",
-				vha->host_no, (unsigned long long)elreq.send_dma, (unsigned long long)elreq.rcv_dma, elreq.req_sg_cnt, elreq.rsp_sg_cnt));
+
 			command_sent = INT_DEF_LB_ECHO_CMD;
 			rval = qla2x00_echo_test(vha, &elreq, response);
 		}
@@ -2353,60 +2347,49 @@ qla24xx_bsg_timeout(struct fc_bsg_job *bsg_job)
         scsi_qla_host_t *vha = shost_priv(bsg_job->shost);
         struct qla_hw_data *ha = vha->hw;
         srb_t *sp;
-        int i;
+        int cnt, que;
         unsigned long flags;
-        uint16_t que_id;
         struct req_que *req;
-        struct rsp_que *rsp;
-	int found = 0;
 	struct srb_bsg *sp_bsg;
 
 	/* find the bsg job from the active list of commands */
         spin_lock_irqsave(&ha->hardware_lock, flags);
-	req = ha->req_q_map[0];
-        que_id = req->id;
-        if (req->rsp)
-                rsp = req->rsp;
-        else
-                rsp = ha->rsp_q_map[que_id];
-
-	for (i = 1; i < MAX_OUTSTANDING_COMMANDS; i++ ) {
-                sp = req->outstanding_cmds[i];
-
-                if (sp == NULL)
-                        continue;
-
-		sp_bsg = (struct srb_bsg*)sp->ctx;
+	for (que = 0; que < ha->max_req_queues; que++) {
+		req = ha->req_q_map[que];
+		if (!req)
+			continue;
 
-		if (((sp_bsg->ctx.type == SRB_CT_CMD) ||
-		    (sp_bsg->ctx.type == SRB_ELS_CMD_RPT)
-		    || ( sp_bsg->ctx.type == SRB_ELS_CMD_HST)) &&
-		    (sp_bsg->bsg_job == bsg_job)) {
-			DEBUG2(qla_printk(KERN_INFO, ha,
-			    "scsi(%ld) req_q: %p rsp_q: %p que_id: %x sp: %p\n",
-			    vha->host_no, req, rsp, que_id, sp));
-			found = 1;
-			break;
+		for (cnt = 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++ ) {
+			sp = req->outstanding_cmds[cnt];
+
+			if (sp) {
+				sp_bsg = (struct srb_bsg*)sp->ctx;
+
+				if (((sp_bsg->ctx.type == SRB_CT_CMD) ||
+				    (sp_bsg->ctx.type == SRB_ELS_CMD_RPT)
+				    || ( sp_bsg->ctx.type == SRB_ELS_CMD_HST)) &&
+				    (sp_bsg->bsg_job == bsg_job)) {
+					if (ha->isp_ops->abort_command(sp)) {
+						DEBUG2(qla_printk(KERN_INFO, ha,
+						"scsi(%ld): mbx abort_command failed\n", vha->host_no));
+						bsg_job->req->errors = bsg_job->reply->result = -EIO;
+					} else {
+						DEBUG2(qla_printk(KERN_INFO, ha,
+						"scsi(%ld): mbx abort_command success\n", vha->host_no));
+						bsg_job->req->errors = bsg_job->reply->result = 0;
+					}
+					goto done;
+				}
+			}
 		}
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-	if (!found) {
-		DEBUG2(qla_printk(KERN_INFO, ha,
-			"scsi(%ld) SRB not found to abort\n", vha->host_no));
-		bsg_job->req->errors = bsg_job->reply->result = -ENXIO;
-		return 0;
-	}
-
-	if (ha->isp_ops->abort_command(sp)) {
-		DEBUG2(qla_printk(KERN_INFO, ha,
-		"scsi(%ld): mbx abort_command failed\n", vha->host_no));
-		bsg_job->req->errors = bsg_job->reply->result = -EIO;
-	} else {
-		DEBUG2(qla_printk(KERN_INFO, ha,
-		"scsi(%ld): mbx abort_command success\n", vha->host_no));
-		bsg_job->req->errors = bsg_job->reply->result = 0;
-	}
+	DEBUG2(qla_printk(KERN_INFO, ha,
+		"scsi(%ld) SRB not found to abort\n", vha->host_no));
+	bsg_job->req->errors = bsg_job->reply->result = -ENXIO;
+	return 0;
 
+done:
 	if (bsg_job->request->msgcode == FC_BSG_HST_CT)
 		kfree(sp->fcport);
 	kfree(sp->ctx);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index ddc1d3d..7649005 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1160,8 +1160,19 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 					qla2x00_sp_compl(ha, sp);
 				} else {
 					ctx = sp->ctx;
-					del_timer_sync(&ctx->timer);
-					ctx->free(sp);
+					if (ctx->type == SRB_LOGIN_CMD || ctx->type == SRB_LOGOUT_CMD) {
+						del_timer_sync(&ctx->timer);
+						ctx->free(sp);
+					} else {
+						struct srb_bsg* sp_bsg = (struct srb_bsg*)sp->ctx;
+						if (sp_bsg->bsg_job->request->msgcode == FC_BSG_HST_CT)
+							kfree(sp->fcport);
+						sp_bsg->bsg_job->req->errors = 0;
+						sp_bsg->bsg_job->reply->result = res;
+						sp_bsg->bsg_job->job_done(sp_bsg->bsg_job);
+						kfree(sp->ctx);
+						mempool_free(sp, ha->srb_mempool);
+					}
 				}
 			}
 		}
-- 
1.6.2.rc1.30.gd43c

