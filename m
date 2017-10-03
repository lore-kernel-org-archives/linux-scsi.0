From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/9] qla2xxx: don't break the bsg-lib abstractions
Date: Tue,  3 Oct 2017 12:48:40 +0200
Message-ID: <20171003104845.10417-5-hch@lst.de>
References: <20171003104845.10417-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49452 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751277AbdJCKs7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Oct 2017 06:48:59 -0400
In-Reply-To: <20171003104845.10417-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>

Always use bsg_job->reply instead of scsi_req(bsg_job->req)->sense), as
they always point to the same memory.

Never set scsi_req(bsg_job->req)->result and we'll set that value through
bsg_job_done.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 10 ++++------
 drivers/scsi/qla2xxx/qla_isr.c | 12 +++---------
 drivers/scsi/qla2xxx/qla_mr.c  |  3 +--
 3 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 2ea0ef93f5cb..92a951fcd076 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -919,9 +919,9 @@ qla2x00_process_loopback(struct bsg_job *bsg_job)
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply) +
 	    sizeof(response) + sizeof(uint8_t);
-	fw_sts_ptr = ((uint8_t *)scsi_req(bsg_job->req)->sense) +
-	    sizeof(struct fc_bsg_reply);
-	memcpy(fw_sts_ptr, response, sizeof(response));
+	fw_sts_ptr = bsg_job->reply + sizeof(struct fc_bsg_reply);
+	memcpy(bsg_job->reply + sizeof(struct fc_bsg_reply), response,
+			sizeof(response));
 	fw_sts_ptr += sizeof(response);
 	*fw_sts_ptr = command_sent;
 
@@ -2554,13 +2554,11 @@ qla24xx_bsg_timeout(struct bsg_job *bsg_job)
 						ql_log(ql_log_warn, vha, 0x7089,
 						    "mbx abort_command "
 						    "failed.\n");
-						scsi_req(bsg_job->req)->result =
 						bsg_reply->result = -EIO;
 					} else {
 						ql_dbg(ql_dbg_user, vha, 0x708a,
 						    "mbx abort_command "
 						    "success.\n");
-						scsi_req(bsg_job->req)->result =
 						bsg_reply->result = 0;
 					}
 					spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -2571,7 +2569,7 @@ qla24xx_bsg_timeout(struct bsg_job *bsg_job)
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	ql_log(ql_log_info, vha, 0x708b, "SRB not found to abort.\n");
-	scsi_req(bsg_job->req)->result = bsg_reply->result = -ENXIO;
+	 bsg_reply->result = -ENXIO;
 	return 0;
 
 done:
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 9d9668aac6f6..886c7085fada 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1543,7 +1543,6 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 	struct fc_bsg_reply *bsg_reply;
 	uint16_t comp_status;
 	uint32_t fw_status[3];
-	uint8_t* fw_sts_ptr;
 	int res;
 
 	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
@@ -1604,11 +1603,7 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 			    type, sp->handle, comp_status, fw_status[1], fw_status[2],
 			    le16_to_cpu(((struct els_sts_entry_24xx *)
 				pkt)->total_byte_count));
-			fw_sts_ptr = ((uint8_t*)scsi_req(bsg_job->req)->sense) +
-				sizeof(struct fc_bsg_reply);
-			memcpy( fw_sts_ptr, fw_status, sizeof(fw_status));
-		}
-		else {
+		} else {
 			ql_dbg(ql_dbg_user, vha, 0x5040,
 			    "ELS-CT pass-through-%s error hdl=%x comp_status-status=0x%x "
 			    "error subcode 1=0x%x error subcode 2=0x%x.\n",
@@ -1619,10 +1614,9 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 				    pkt)->error_subcode_2));
 			res = DID_ERROR << 16;
 			bsg_reply->reply_payload_rcv_len = 0;
-			fw_sts_ptr = ((uint8_t*)scsi_req(bsg_job->req)->sense) +
-					sizeof(struct fc_bsg_reply);
-			memcpy( fw_sts_ptr, fw_status, sizeof(fw_status));
 		}
+		memcpy(bsg_job->reply + sizeof(struct fc_bsg_reply),
+				fw_status, sizeof(fw_status));
 		ql_dump_buffer(ql_dbg_user + ql_dbg_buffer, vha, 0x5056,
 				(uint8_t *)pkt, sizeof(*pkt));
 	}
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index e23a3d4c36f3..d5da3981cefe 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -2245,8 +2245,7 @@ qlafx00_ioctl_iosb_entry(scsi_qla_host_t *vha, struct req_que *req,
 		memcpy(fstatus.reserved_3,
 		    pkt->reserved_2, 20 * sizeof(uint8_t));
 
-		fw_sts_ptr = ((uint8_t *)scsi_req(bsg_job->req)->sense) +
-		    sizeof(struct fc_bsg_reply);
+		fw_sts_ptr = bsg_job->reply + sizeof(struct fc_bsg_reply);
 
 		memcpy(fw_sts_ptr, (uint8_t *)&fstatus,
 		    sizeof(struct qla_mt_iocb_rsp_fx00));
-- 
2.14.1
