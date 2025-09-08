Received: from mail.cybernetics.com (mail.cybernetics.com [72.215.153.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398C0238C0F
	for <linux-scsi@vger.kernel.org>; Mon,  8 Sep 2025 19:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.215.153.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757358722; cv=none; b=qiQm4EeDzOhKQgIPWPA3Yh/CP0SLDJyCrUEFqrhiTCCKbxao0GiUi9VED4xldKIT4Hxcel5J+p+itjzAdhD8R4eXRMWf4iQpZOWcpEX10kqj4f+cj8U2oreU2ynleT9tNWGbcusrzDI0yRC27tQYDtDC97ZH9Hq4aiXVby09xLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757358722; c=relaxed/simple;
	bh=kK3gO5EQh2k/XQr2LkbVZyvs8he70bOcNGDaqclYibo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=qIZ6kjPbyxPIPezIfTpX48i4+aGQR8rtKdfKQane0S8uwkI0yq0JGZnA5rAf0q14Zqd1rqZRDGrdwLcywkWg+OPlV4IjNc7h2C7ZwgvbdafpYq5vSQtyqFWRwasvxJ7OPNiRpZUpdjC14/vBQAe4YSFZYxTJJiDZOaDz2tVF/EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com; spf=pass smtp.mailfrom=cybernetics.com; dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b=ekRRoTVd; arc=none smtp.client-ip=72.215.153.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b="ekRRoTVd"
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id 0hMBQSHlYPkagFjx; Mon, 08 Sep 2025 15:11:59 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
	bh=ZzyYGPh154qBPW+CWwfgxU4UDaBPIaXprsd1EZB2Ecg=;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:Cc:To:From:
	Content-Language:Subject:MIME-Version:Date:Message-ID; b=ekRRoTVd3JxAxZvarAiK
	Y+cHVfP95FH6SZyGxeGCriDg46OCRvoogyEQRm6rJAJh6gfrNrFwU29h3Cxswu3zOlh2j2WGuXx4L
	DeaJn2bK/M5Y/p1T/EYDoSRyMsIa29YFtBtjPoMSgCGktGSej21RXGNYKhagI++PBA/LgaFmPE=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate SPEC SMTP 8.0.5)
  with ESMTPS id 14188930; Mon, 08 Sep 2025 15:11:59 -0400
Message-ID: <98c1c083-2538-496f-b775-ad8c9cd340dd@cybernetics.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
Date: Mon, 8 Sep 2025 15:11:59 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [SCST PATCH 14/15] scsi: qla2xxx: add back SRR support
Content-Language: en-US
X-ASG-Orig-Subj: [SCST PATCH 14/15] scsi: qla2xxx: add back SRR support
From: Tony Battersby <tonyb@cybernetics.com>
To: Nilesh Javali <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel@vger.kernel.org,
 scst-devel@lists.sourceforge.net,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <f8977250-638c-4d7d-ac0c-65f742b8d535@cybernetics.com>
 <2cc10189-6953-428e-b34e-b1c714fc0eae@cybernetics.com>
In-Reply-To: <2cc10189-6953-428e-b34e-b1c714fc0eae@cybernetics.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1757358719
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 7009
X-ASG-Debug-ID: 1757358719-1cf43947df30c7f0001-ziuLRu

This patch applies to the out-of-tree SCST project, not to the Linux
kernel.  Apply when importing the upstream patch with the same title.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---
 qla2x00t-32gbit/qla2x00-target/scst_qla2xxx.c | 107 ++++++++++++++++--
 1 file changed, 95 insertions(+), 12 deletions(-)

diff --git a/qla2x00t-32gbit/qla2x00-target/scst_qla2xxx.c b/qla2x00t-32gbit/qla2x00-target/scst_qla2xxx.c
index d3a978610..7f06ac6f3 100644
--- a/qla2x00t-32gbit/qla2x00-target/scst_qla2xxx.c
+++ b/qla2x00t-32gbit/qla2x00-target/scst_qla2xxx.c
@@ -72,6 +72,8 @@
 #endif
 #endif
 
+#define sense_initiator_detected_error HARDWARE_ERROR, 0x48, 0x00
+
 static LIST_HEAD(sqa_tgt_glist);
 
 /* Function definitions for callbacks from the SCST target core. */
@@ -395,6 +397,17 @@ static struct qla_tgt_cmd *sqa_qla2xxx_get_cmd(struct fc_port *sess)
 	return cmd;
 }
 
+static int sqa_qla2xxx_get_cmd_ref(struct qla_tgt_cmd *cmd)
+{
+	scst_cmd_get(cmd->scst_cmd);
+	return 0;
+}
+
+static void sqa_qla2xxx_put_cmd_ref(struct qla_tgt_cmd *cmd)
+{
+	scst_cmd_put(cmd->scst_cmd);
+}
+
 static DEFINE_MUTEX(sqa_mutex);
 
 
@@ -527,8 +540,12 @@ static void sqa_qla2xxx_handle_data(struct qla_tgt_cmd *cmd)
 			break;
 		case DIF_ERR_NONE:
 		default:
-			scst_set_cmd_error(scst_cmd,
-				SCST_LOAD_SENSE(scst_sense_aborted_command));
+			if (cmd->srr_failed)
+				scst_set_cmd_error(scst_cmd,
+					SCST_LOAD_SENSE(sense_initiator_detected_error));
+			else
+				scst_set_cmd_error(scst_cmd,
+					SCST_LOAD_SENSE(scst_sense_aborted_command));
 			break;
 		}
 	}
@@ -1546,6 +1563,11 @@ static int sqa_xmit_response(struct scst_cmd *scst_cmd)
 		}
 	}
 
+	if (unlikely(cmd->free_sg)) {
+		cmd->free_sg = 0;
+		qlt_free_sg(cmd);
+	}
+
 	cmd->bufflen = scst_cmd_get_adjusted_resp_data_len(scst_cmd);
 	cmd->sg = scst_cmd_get_sg(scst_cmd);
 	cmd->sg_cnt = scst_cmd_get_sg_cnt(scst_cmd);
@@ -1556,6 +1578,15 @@ static int sqa_xmit_response(struct scst_cmd *scst_cmd)
 	cmd->lba = scst_cmd_get_lba(scst_cmd);
 	cmd->trc_flags |= TRC_XMIT_STATUS;
 
+	/*
+	 * se_cmd::data_length,t_data_sg,t_data_nents used by
+	 * qlt_restore_orig_sg()
+	 */
+	cmd->se_cmd.data_length = cmd->bufflen;
+	cmd->se_cmd.t_data_sg = cmd->sg;
+	cmd->se_cmd.t_data_nents = cmd->sg_cnt;
+	cmd->se_cmd.scsi_status = cmd->scsi_status;
+
 #if QLA_ENABLE_PI
 	if (scst_get_tgt_dif_actions(scst_cmd->cmd_dif_actions)) {
 		cmd->blk_sz = scst_cmd_get_block_size(scst_cmd);
@@ -1600,7 +1631,7 @@ static int sqa_xmit_response(struct scst_cmd *scst_cmd)
 		  cmd->bufflen, cmd->sg_cnt, cmd->dma_data_direction,
 		  cmd->se_cmd.residual_count);
 
-	res = qlt_xmit_response(cmd, xmit_type, scst_cmd_get_status(scst_cmd));
+	res = qlt_xmit_response(cmd, xmit_type, cmd->scsi_status);
 
 	switch (res) {
 	case 0:
@@ -1630,16 +1661,30 @@ static int sqa_rdy_to_xfer(struct scst_cmd *scst_cmd)
 	TRACE(TRACE_SCSI, "sqatgt(%ld/%d): tag=%lld", cmd->vha->host_no,
 	      cmd->vha->vp_idx, scst_cmd_get_tag(scst_cmd));
 
+	if (unlikely(cmd->free_sg)) {
+		cmd->free_sg = 0;
+		qlt_free_sg(cmd);
+	}
+
 	cmd->bufflen = scst_cmd_get_write_fields(scst_cmd, &cmd->sg,
 						 &cmd->sg_cnt);
+
 	cmd->dma_data_direction =
 		scst_to_tgt_dma_dir(scst_cmd_get_data_direction(scst_cmd));
+	cmd->offset = 0;
 
-	cmd->sg = scst_cmd_get_sg(scst_cmd);
-	cmd->sg_cnt = scst_cmd_get_sg_cnt(scst_cmd);
 	cmd->scsi_status = scst_cmd_get_status(scst_cmd);
 	cmd->trc_flags |= TRC_XFR_RDY;
 
+	/*
+	 * se_cmd::data_length,t_data_sg,t_data_nents used by
+	 * qlt_restore_orig_sg()
+	 */
+	cmd->se_cmd.data_length = cmd->bufflen;
+	cmd->se_cmd.t_data_sg = cmd->sg;
+	cmd->se_cmd.t_data_nents = cmd->sg_cnt;
+	cmd->se_cmd.scsi_status = cmd->scsi_status;
+
 #if QLA_ENABLE_PI
 	if (scst_get_tgt_dif_actions(scst_cmd->cmd_dif_actions)) {
 		cmd->blk_sz    = scst_cmd_get_block_size(scst_cmd);
@@ -1866,6 +1911,7 @@ static void sqa_on_hw_pending_cmd_timeout(struct scst_cmd *scst_cmd)
 	struct qla_tgt_cmd *cmd = scst_cmd_get_tgt_priv(scst_cmd);
 	struct scsi_qla_host *vha = cmd->vha;
 	struct qla_qpair *qpair = cmd->qpair;
+	struct qla_tgt_srr *srr;
 	unsigned long flags;
 	bool advance_cmd = false;
 
@@ -1898,19 +1944,53 @@ static void sqa_on_hw_pending_cmd_timeout(struct scst_cmd *scst_cmd)
 		break;
 	}
 
-	/* Handle race with normal CTIO completion. */
-	if (!cmd->cmd_sent_to_fw) {
+	srr = cmd->srr;
+	if (srr) {
+		/* Handle race with SRR processing. */
+		if (srr->imm_ntfy_recvd && srr->ctio_recvd) {
+			TRACE_MGMT_DBG(
+			    "sqatgt(%ld/%d): tag %lld: cmd should be scheduled for SRR processing",
+			    vha->host_no, vha->vp_idx,
+			    scst_cmd_get_tag(scst_cmd));
+			goto out_unlock;
+		}
+
 		TRACE_MGMT_DBG(
-		    "sqatgt(%ld/%d): tag %lld: cmd not sent to fw; assuming just completed",
+		    "sqatgt(%ld/%d): tag %lld: timeout waiting for %s SRR",
 		    vha->host_no, vha->vp_idx,
-		    scst_cmd_get_tag(scst_cmd));
-		goto out_unlock;
+		    scst_cmd_get_tag(scst_cmd),
+		    (!srr->imm_ntfy_recvd) ? "IMM" : "CTIO");
+
+		if (srr->ctio_recvd) {
+			/*
+			 * When the SRR CTIO was received, cmd processing was
+			 * delayed to wait for the SRR immediate notify, which
+			 * never arrived. Process the cmd now.
+			 *
+			 * Note that in this case cmd->cmd_sent_to_fw == 0
+			 * so we avoid checking that.
+			 */
+			advance_cmd = true;
+		}
+
+		qlt_srr_abort(cmd, false);
+		srr = NULL; /* srr may have been freed */
+	} else {
+		/* Handle race with normal CTIO completion. */
+		if (!cmd->cmd_sent_to_fw) {
+			TRACE_MGMT_DBG(
+			    "sqatgt(%ld/%d): tag %lld: cmd not sent to fw; assuming just completed",
+			    vha->host_no, vha->vp_idx,
+			    scst_cmd_get_tag(scst_cmd));
+			goto out_unlock;
+		}
 	}
 
 	/* Check for chip reset or a timeout after sending a term exchange. */
 	if (!qpair->fw_started ||
 	    cmd->reset_count != qpair->chip_reset ||
-	    (cmd->sent_term_exchg &&
+	    (!advance_cmd &&
+	     cmd->sent_term_exchg &&
 	     time_is_before_jiffies(cmd->jiffies_at_term_exchg +
 				    SQA_MAX_HW_PENDING_TIME * HZ / 2))) {
 		/*
@@ -1920,7 +2000,8 @@ static void sqa_on_hw_pending_cmd_timeout(struct scst_cmd *scst_cmd)
 		 * mapping, so try term exchange first and see if that works.
 		 */
 
-		sqa_cleanup_hw_pending_cmd(vha, cmd);
+		if (cmd->cmd_sent_to_fw)
+			sqa_cleanup_hw_pending_cmd(vha, cmd);
 
 		qlt_unmap_sg(vha, cmd);
 
@@ -2034,6 +2115,8 @@ static struct qla_tgt_func_tmpl sqa_qla2xxx_template = {
 	.handle_tmr		    = sqa_qla2xxx_handle_tmr,
 	.find_cmd_by_tag	    = sqa_qla2xxx_find_cmd_by_tag,
 	.get_cmd		    = sqa_qla2xxx_get_cmd,
+	.get_cmd_ref		    = sqa_qla2xxx_get_cmd_ref,
+	.put_cmd_ref		    = sqa_qla2xxx_put_cmd_ref,
 	.rel_cmd		    = sqa_qla2xxx_rel_cmd,
 	.free_cmd		    = sqa_qla2xxx_free_cmd,
 	.free_mcmd		    = sqa_qla2xxx_free_mcmd,
-- 
2.43.0


