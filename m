From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/2] ib_srp: 64bit LUN fixes
Date: Fri,  4 Jul 2014 13:54:35 +0200
Message-ID: <1404474875-109997-3-git-send-email-hare@suse.de>
References: <1404474875-109997-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52863 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935AbaGDLyj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Jul 2014 07:54:39 -0400
In-Reply-To: <1404474875-109997-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Bart van Assche <bvanassche@acm.org>

SRP is capable of handling 64bit LUNs, so as we now have proper
support for it we can modify the driver to use the standard functions.

Cc: Bart van Assche <bvanassche@acm.org>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/infiniband/ulp/srp/ib_srp.c   |  9 ++--
 drivers/infiniband/ulp/srpt/ib_srpt.c | 81 +----------------------------------
 2 files changed, 7 insertions(+), 83 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index e3c2c5b..eb55f25 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1713,7 +1713,8 @@ static void srp_process_aer_req(struct srp_target_port *target,
 	s32 delta = be32_to_cpu(req->req_lim_delta);
 
 	shost_printk(KERN_ERR, target->scsi_host, PFX
-		     "ignoring AER for LUN %llu\n", be64_to_cpu(req->lun));
+		     "ignoring AER for LUN %llu\n",
+		     scsilun_to_int((struct scsi_lun *)&req->lun));
 
 	if (srp_response_common(target, delta, &rsp, sizeof rsp))
 		shost_printk(KERN_ERR, target->scsi_host, PFX
@@ -1887,7 +1888,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	memset(cmd, 0, sizeof *cmd);
 
 	cmd->opcode = SRP_CMD;
-	cmd->lun    = cpu_to_be64((u64) scmnd->device->lun << 48);
+	int_to_scsilun(scmnd->device->lun, (struct scsi_lun *)&cmd->lun);
 	cmd->tag    = req->index;
 	memcpy(cmd->cdb, scmnd->cmnd, scmnd->cmd_len);
 
@@ -2305,7 +2306,7 @@ srp_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 }
 
 static int srp_send_tsk_mgmt(struct srp_target_port *target,
-			     u64 req_tag, unsigned int lun, u8 func)
+			     u64 req_tag, u64 lun, u8 func)
 {
 	struct srp_rport *rport = target->rport;
 	struct ib_device *dev = target->srp_host->srp_dev->dev;
@@ -2338,7 +2339,7 @@ static int srp_send_tsk_mgmt(struct srp_target_port *target,
 	memset(tsk_mgmt, 0, sizeof *tsk_mgmt);
 
 	tsk_mgmt->opcode 	= SRP_TSK_MGMT;
-	tsk_mgmt->lun		= cpu_to_be64((u64) lun << 48);
+	int_to_scsilun(lun, (struct scsi_lun *)&tsk_mgmt->lun);
 	tsk_mgmt->tag		= req_tag | SRP_TAG_TSK_MGMT;
 	tsk_mgmt->tsk_mgmt_func = func;
 	tsk_mgmt->task_tag	= req_tag;
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index fe09f27..232c29a 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1601,81 +1601,6 @@ static int srpt_build_tskmgmt_rsp(struct srpt_rdma_ch *ch,
 	return resp_len;
 }
 
-#define NO_SUCH_LUN ((uint64_t)-1LL)
-
-/*
- * SCSI LUN addressing method. See also SAM-2 and the section about
- * eight byte LUNs.
- */
-enum scsi_lun_addr_method {
-	SCSI_LUN_ADDR_METHOD_PERIPHERAL   = 0,
-	SCSI_LUN_ADDR_METHOD_FLAT         = 1,
-	SCSI_LUN_ADDR_METHOD_LUN          = 2,
-	SCSI_LUN_ADDR_METHOD_EXTENDED_LUN = 3,
-};
-
-/*
- * srpt_unpack_lun() - Convert from network LUN to linear LUN.
- *
- * Convert an 2-byte, 4-byte, 6-byte or 8-byte LUN structure in network byte
- * order (big endian) to a linear LUN. Supports three LUN addressing methods:
- * peripheral, flat and logical unit. See also SAM-2, section 4.9.4 (page 40).
- */
-static uint64_t srpt_unpack_lun(const uint8_t *lun, int len)
-{
-	uint64_t res = NO_SUCH_LUN;
-	int addressing_method;
-
-	if (unlikely(len < 2)) {
-		printk(KERN_ERR "Illegal LUN length %d, expected 2 bytes or "
-		       "more", len);
-		goto out;
-	}
-
-	switch (len) {
-	case 8:
-		if ((*((__be64 *)lun) &
-		     __constant_cpu_to_be64(0x0000FFFFFFFFFFFFLL)) != 0)
-			goto out_err;
-		break;
-	case 4:
-		if (*((__be16 *)&lun[2]) != 0)
-			goto out_err;
-		break;
-	case 6:
-		if (*((__be32 *)&lun[2]) != 0)
-			goto out_err;
-		break;
-	case 2:
-		break;
-	default:
-		goto out_err;
-	}
-
-	addressing_method = (*lun) >> 6; /* highest two bits of byte 0 */
-	switch (addressing_method) {
-	case SCSI_LUN_ADDR_METHOD_PERIPHERAL:
-	case SCSI_LUN_ADDR_METHOD_FLAT:
-	case SCSI_LUN_ADDR_METHOD_LUN:
-		res = *(lun + 1) | (((*lun) & 0x3f) << 8);
-		break;
-
-	case SCSI_LUN_ADDR_METHOD_EXTENDED_LUN:
-	default:
-		printk(KERN_ERR "Unimplemented LUN addressing method %u",
-		       addressing_method);
-		break;
-	}
-
-out:
-	return res;
-
-out_err:
-	printk(KERN_ERR "Support for multi-level LUNs has not yet been"
-	       " implemented");
-	goto out;
-}
-
 static int srpt_check_stop_free(struct se_cmd *cmd)
 {
 	struct srpt_send_ioctx *ioctx = container_of(cmd,
@@ -1728,8 +1653,7 @@ static int srpt_handle_cmd(struct srpt_rdma_ch *ch,
 		goto send_sense;
 	}
 
-	unpacked_lun = srpt_unpack_lun((uint8_t *)&srp_cmd->lun,
-				       sizeof(srp_cmd->lun));
+	unpacked_lun = scsilun_to_int((struct scsi_lun *)&srp_cmd->lun);
 	rc = target_submit_cmd(cmd, ch->sess, srp_cmd->cdb,
 			&send_ioctx->sense_data[0], unpacked_lun, data_len,
 			MSG_SIMPLE_TAG, dir, TARGET_SCF_ACK_KREF);
@@ -1840,8 +1764,7 @@ static void srpt_handle_tsk_mgmt(struct srpt_rdma_ch *ch,
 			TMR_TASK_MGMT_FUNCTION_NOT_SUPPORTED;
 		goto fail;
 	}
-	unpacked_lun = srpt_unpack_lun((uint8_t *)&srp_tsk->lun,
-				       sizeof(srp_tsk->lun));
+	unpacked_lun = scsilun_to_int((struct scsi_lun *)&srp_tsk->lun);
 
 	if (srp_tsk->tsk_mgmt_func == SRP_TSK_ABORT_TASK) {
 		rc = srpt_rx_mgmt_fn_tag(send_ioctx, srp_tsk->task_tag);
-- 
1.7.12.4

