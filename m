From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 1/5] qla2xxx: Properly set result field of bsg_job reply structure for success and failure.
Date: Wed, 21 Nov 2012 02:39:53 -0500
Message-ID: <1353483597-17206-2-git-send-email-saurav.kashyap@qlogic.com>
References: <1353483597-17206-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:27532 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752126Ab2KUH6H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2012 02:58:07 -0500
In-Reply-To: <1353483597-17206-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Armen Baloyan <armen.baloyan@qlogic.com>

FC transport on receiving bsg_job submission failure, calls bsg_job->job_done()
and sets the bsg_job->reply->result the returned value. In contrast, when the
success code (0) is returned fc transport doesn't call bsg_job->job_done() and
doesn't populate bsg_job->reply->result.

Signed-off-by: Steve Hodgson <steve@purestorage.com>
Signed-off-by: Armen Baloyan <armen.baloyan@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c |   65 +++++++++++++++-------------------------
 1 files changed, 24 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 2f9bddd..05520be 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -219,7 +219,8 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct fc_bsg_job *bsg_job)
 		break;
 	}
 exit_fcp_prio_cfg:
-	bsg_job->job_done(bsg_job);
+	if (!ret)
+		bsg_job->job_done(bsg_job);
 	return ret;
 }
 
@@ -741,7 +742,6 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 			if (qla81xx_get_port_config(vha, config)) {
 				ql_log(ql_log_warn, vha, 0x701f,
 				    "Get port config failed.\n");
-				bsg_job->reply->result = (DID_ERROR << 16);
 				rval = -EPERM;
 				goto done_free_dma_req;
 			}
@@ -761,7 +761,6 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 				    new_config, elreq.options);
 
 			if (rval) {
-				bsg_job->reply->result = (DID_ERROR << 16);
 				rval = -EPERM;
 				goto done_free_dma_req;
 			}
@@ -795,7 +794,6 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 					    "MPI reset failed.\n");
 				}
 
-				bsg_job->reply->result = (DID_ERROR << 16);
 				rval = -EIO;
 				goto done_free_dma_req;
 			}
@@ -812,33 +810,25 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 		ql_log(ql_log_warn, vha, 0x702c,
 		    "Vendor request %s failed.\n", type);
 
-		fw_sts_ptr = ((uint8_t *)bsg_job->req->sense) +
-		    sizeof(struct fc_bsg_reply);
-
-		memcpy(fw_sts_ptr, response, sizeof(response));
-		fw_sts_ptr += sizeof(response);
-		*fw_sts_ptr = command_sent;
 		rval = 0;
 		bsg_job->reply->result = (DID_ERROR << 16);
+		bsg_job->reply->reply_payload_rcv_len = 0;
 	} else {
 		ql_dbg(ql_dbg_user, vha, 0x702d,
 		    "Vendor request %s completed.\n", type);
-
-		bsg_job->reply_len = sizeof(struct fc_bsg_reply) +
-			sizeof(response) + sizeof(uint8_t);
-		bsg_job->reply->reply_payload_rcv_len =
-			bsg_job->reply_payload.payload_len;
-		fw_sts_ptr = ((uint8_t *)bsg_job->req->sense) +
-			sizeof(struct fc_bsg_reply);
-		memcpy(fw_sts_ptr, response, sizeof(response));
-		fw_sts_ptr += sizeof(response);
-		*fw_sts_ptr = command_sent;
-		bsg_job->reply->result = DID_OK;
+		bsg_job->reply->result = (DID_OK << 16);
 		sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
 			bsg_job->reply_payload.sg_cnt, rsp_data,
 			rsp_data_len);
 	}
-	bsg_job->job_done(bsg_job);
+
+	bsg_job->reply_len = sizeof(struct fc_bsg_reply) +
+	    sizeof(response) + sizeof(uint8_t);
+	fw_sts_ptr = ((uint8_t *)bsg_job->req->sense) +
+	    sizeof(struct fc_bsg_reply);
+	memcpy(fw_sts_ptr, response, sizeof(response));
+	fw_sts_ptr += sizeof(response);
+	*fw_sts_ptr = command_sent;
 
 	dma_free_coherent(&ha->pdev->dev, rsp_data_len,
 		rsp_data, rsp_data_dma);
@@ -853,6 +843,8 @@ done_unmap_req_sg:
 	dma_unmap_sg(&ha->pdev->dev,
 	    bsg_job->request_payload.sg_list,
 	    bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
+	if (!rval)
+		bsg_job->job_done(bsg_job);
 	return rval;
 }
 
@@ -877,16 +869,15 @@ qla84xx_reset(struct fc_bsg_job *bsg_job)
 	if (rval) {
 		ql_log(ql_log_warn, vha, 0x7030,
 		    "Vendor request 84xx reset failed.\n");
-		rval = 0;
-		bsg_job->reply->result = (DID_ERROR << 16);
+		rval = (DID_ERROR << 16);
 
 	} else {
 		ql_dbg(ql_dbg_user, vha, 0x7031,
 		    "Vendor request 84xx reset completed.\n");
 		bsg_job->reply->result = DID_OK;
+		bsg_job->job_done(bsg_job);
 	}
 
-	bsg_job->job_done(bsg_job);
 	return rval;
 }
 
@@ -976,8 +967,7 @@ qla84xx_updatefw(struct fc_bsg_job *bsg_job)
 		ql_log(ql_log_warn, vha, 0x7037,
 		    "Vendor request 84xx updatefw failed.\n");
 
-		rval = 0;
-		bsg_job->reply->result = (DID_ERROR << 16);
+		rval = (DID_ERROR << 16);
 	} else {
 		ql_dbg(ql_dbg_user, vha, 0x7038,
 		    "Vendor request 84xx updatefw completed.\n");
@@ -986,7 +976,6 @@ qla84xx_updatefw(struct fc_bsg_job *bsg_job)
 		bsg_job->reply->result = DID_OK;
 	}
 
-	bsg_job->job_done(bsg_job);
 	dma_pool_free(ha->s_dma_pool, mn, mn_dma);
 
 done_free_fw_buf:
@@ -996,6 +985,8 @@ done_unmap_sg:
 	dma_unmap_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
 		bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
 
+	if (!rval)
+		bsg_job->job_done(bsg_job);
 	return rval;
 }
 
@@ -1163,8 +1154,7 @@ qla84xx_mgmt_cmd(struct fc_bsg_job *bsg_job)
 		ql_log(ql_log_warn, vha, 0x7043,
 		    "Vendor request 84xx mgmt failed.\n");
 
-		rval = 0;
-		bsg_job->reply->result = (DID_ERROR << 16);
+		rval = (DID_ERROR << 16);
 
 	} else {
 		ql_dbg(ql_dbg_user, vha, 0x7044,
@@ -1184,8 +1174,6 @@ qla84xx_mgmt_cmd(struct fc_bsg_job *bsg_job)
 		}
 	}
 
-	bsg_job->job_done(bsg_job);
-
 done_unmap_sg:
 	if (mgmt_b)
 		dma_free_coherent(&ha->pdev->dev, data_len, mgmt_b, mgmt_dma);
@@ -1200,6 +1188,8 @@ done_unmap_sg:
 exit_mgmt:
 	dma_pool_free(ha->s_dma_pool, mn, mn_dma);
 
+	if (!rval)
+		bsg_job->job_done(bsg_job);
 	return rval;
 }
 
@@ -1276,9 +1266,7 @@ qla24xx_iidma(struct fc_bsg_job *bsg_job)
 		    fcport->port_name[3], fcport->port_name[4],
 		    fcport->port_name[5], fcport->port_name[6],
 		    fcport->port_name[7], rval, fcport->fp_speed, mb[0], mb[1]);
-		rval = 0;
-		bsg_job->reply->result = (DID_ERROR << 16);
-
+		rval = (DID_ERROR << 16);
 	} else {
 		if (!port_param->mode) {
 			bsg_job->reply_len = sizeof(struct fc_bsg_reply) +
@@ -1292,9 +1280,9 @@ qla24xx_iidma(struct fc_bsg_job *bsg_job)
 		}
 
 		bsg_job->reply->result = DID_OK;
+		bsg_job->job_done(bsg_job);
 	}
 
-	bsg_job->job_done(bsg_job);
 	return rval;
 }
 
@@ -1887,8 +1875,6 @@ qla2x00_process_vendor_specific(struct fc_bsg_job *bsg_job)
 		return qla24xx_process_bidir_cmd(bsg_job);
 
 	default:
-		bsg_job->reply->result = (DID_ERROR << 16);
-		bsg_job->job_done(bsg_job);
 		return -ENOSYS;
 	}
 }
@@ -1919,8 +1905,6 @@ qla24xx_bsg_request(struct fc_bsg_job *bsg_job)
 		ql_dbg(ql_dbg_user, vha, 0x709f,
 		    "BSG: ISP abort active/needed -- cmd=%d.\n",
 		    bsg_job->request->msgcode);
-		bsg_job->reply->result = (DID_ERROR << 16);
-		bsg_job->job_done(bsg_job);
 		return -EBUSY;
 	}
 
@@ -1943,7 +1927,6 @@ qla24xx_bsg_request(struct fc_bsg_job *bsg_job)
 	case FC_BSG_RPT_CT:
 	default:
 		ql_log(ql_log_warn, vha, 0x705a, "Unsupported BSG request.\n");
-		bsg_job->reply->result = ret;
 		break;
 	}
 	return ret;
-- 
1.7.7

