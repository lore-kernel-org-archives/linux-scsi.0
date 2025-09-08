Received: from mail.cybernetics.com (mail.cybernetics.com [72.215.153.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65898188CB1
	for <linux-scsi@vger.kernel.org>; Mon,  8 Sep 2025 19:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.215.153.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757358571; cv=none; b=ULaxoCiqyfs/r0+D5YbrKZ9zxSHKQ8zqHItDpsz5dI0Cy9b9QSVg4N/HFOKcZd15mRpgd3m2+BJosT1cJz6zJCvyhglpD2v2jedCYH1U8ACO6FtYNZGFJ6BHCXgibOWSsGr0XiotfzCySxhXPneHGhrFkctGj8/pOe+RJXf+pac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757358571; c=relaxed/simple;
	bh=7AeQ9u1HgLJvM5SuitqxpTrimWcGTWENDlCZ/5zVOYY=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=iDy1IeXbu55cFFjhGHJE5P9wwMVe+2mb8QnTvKuocXuJQ8UlL1Ivx3J0lgmPgSefqUpMwf6QLekwJeR6diKYboRks5JQhaadpA/Rz+B8cLs5AuZxwdFUw0Pslahm33KGBUNNKk8VVscTy+/P8iPDint4anuaNU2g7JFLTXHJ7po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com; spf=pass smtp.mailfrom=cybernetics.com; dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b=WuUJBY6h; arc=none smtp.client-ip=72.215.153.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b="WuUJBY6h"
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id S3GSX9zBvRyfSBat; Mon, 08 Sep 2025 15:09:28 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
	bh=HuCpFf9K+JsAPM4tutKOqxZ6vTqQCUKFzCy/o/Cd6nI=;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:Cc:To:From:
	Content-Language:Subject:MIME-Version:Date:Message-ID; b=WuUJBY6hZTClc0B603wT
	aTAZOiZDL5GV1n2lh1GwQxSwSE3iPnHc8ZMskz2Iea6gn4cbn9tcIw/k+MVrK9bpbOotZBwVKZ+49
	eQMgWtugVuHIwCiX8i+PSaRfSohVpFrHmBGmn/6wrQtR37l94b6Xsk4sdFl4/kI8Xh7PDI4mWs=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate SPEC SMTP 8.0.5)
  with ESMTPS id 14188950; Mon, 08 Sep 2025 15:09:28 -0400
Message-ID: <7c22ef18-5b35-4590-adf4-b5722d2ccc3e@cybernetics.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
Date: Mon, 8 Sep 2025 15:09:28 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH 13/15] scsi: qla2xxx: improve cmd logging
Content-Language: en-US
X-ASG-Orig-Subj: [PATCH 13/15] scsi: qla2xxx: improve cmd logging
From: Tony Battersby <tonyb@cybernetics.com>
To: Nilesh Javali <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel@vger.kernel.org,
 scst-devel@lists.sourceforge.net,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <f8977250-638c-4d7d-ac0c-65f742b8d535@cybernetics.com>
In-Reply-To: <f8977250-638c-4d7d-ac0c-65f742b8d535@cybernetics.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1757358568
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 8956
X-ASG-Debug-ID: 1757358568-1cf43947df30c730001-ziuLRu

(target mode)

- Add the command tag to various messages so that different messages
  about the same command can be correlated.

- For CTIO errors (i.e. when the HW reports an error about a cmd), print
  the cmd tag, opcode, state, initiator WWPN, and LUN.  This info helps
  an administrator determine what is going wrong.

- When a command experiences a transport error, log a message when it
  is freed.  This makes debugging exceptions easier.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c    |  2 +-
 drivers/scsi/qla2xxx/qla_target.c | 89 ++++++++++++++++++++++---------
 2 files changed, 65 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index ff4124eccc9c..a19471d51ea5 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -54,7 +54,7 @@
  * | Misc                         |       0xd303       | 0xd031-0xd0ff	|
  * |                              |                    | 0xd101-0xd1fe	|
  * |                              |                    | 0xd214-0xd2fe	|
- * | Target Mode		  |	  0xe084       |		|
+ * | Target Mode		  |	  0xe086       |		|
  * | Target Mode Management	  |	  0xf09b       | 0xf002		|
  * |                              |                    | 0xf046-0xf049  |
  * | Target Mode Task Management  |	  0x1000d      |		|
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 0ddbf02ebe79..028cb41f78be 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1984,8 +1984,12 @@ static void abort_cmds_for_lun(struct scsi_qla_host *vha, u64 lun, be_id_t s_id)
 		cmd_key = sid_to_key(cmd->atio.u.isp24.fcp_hdr.s_id);
 		cmd_lun = scsilun_to_int(
 			(struct scsi_lun *)&cmd->atio.u.isp24.fcp_cmnd.lun);
-		if (cmd_key == key && cmd_lun == lun)
+		if (cmd_key == key && cmd_lun == lun) {
+			ql_dbg(ql_dbg_tgt_mgt, vha, 0xe085,
+			    "qla_target(%d): tag %lld: aborted by TMR\n",
+			    vha->vp_idx, cmd->se_cmd.tag);
 			cmd->aborted = 1;
+		}
 	}
 	spin_unlock_irqrestore(&vha->cmd_list_lock, flags);
 }
@@ -3831,6 +3835,16 @@ void qlt_free_cmd(struct qla_tgt_cmd *cmd)
 
 	BUG_ON(cmd->sg_mapped);
 
+	if (unlikely(cmd->aborted ||
+		     (cmd->trc_flags & (TRC_CTIO_IGNORED | TRC_CTIO_STRANGE |
+					TRC_CTIO_ERR)))) {
+		ql_dbg(ql_dbg_tgt_mgt, cmd->vha, 0xe086,
+		    "qla_target(%d): tag %lld: free cmd (trc_flags %x, aborted %u, sent_term_exchg %u, rsp_sent %u)\n",
+		    cmd->vha->vp_idx, cmd->se_cmd.tag,
+		    cmd->trc_flags, cmd->aborted, cmd->sent_term_exchg,
+		    cmd->rsp_sent);
+	}
+
 	if (unlikely(cmd->cdb != &cmd->atio.u.isp24.fcp_cmnd.cdb[0])) {
 		kfree(cmd->cdb);
 		cmd->cdb = &cmd->atio.u.isp24.fcp_cmnd.cdb[0];
@@ -3843,7 +3857,6 @@ void qlt_free_cmd(struct qla_tgt_cmd *cmd)
 		WARN_ON(1);
 		return;
 	}
-	cmd->jiffies_at_free = get_jiffies_64();
 	cmd->vha->hw->tgt.tgt_ops->rel_cmd(cmd);
 }
 EXPORT_SYMBOL(qlt_free_cmd);
@@ -3908,7 +3921,6 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha,
 	struct ctio7_from_24xx *ctio)
 {
 	struct qla_hw_data *ha = vha->hw;
-	struct se_cmd *se_cmd;
 	struct qla_tgt_cmd *cmd;
 	struct qla_qpair *qpair = rsp->qpair;
 	uint16_t ctio_flags;
@@ -3947,12 +3959,12 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha,
 	if ((ctio_flags & CTIO7_FLAGS_DATA_OUT) && cmd->sess)
 		qlt_chk_edif_rx_sa_delete_pending(vha, cmd->sess, ctio);
 
-	se_cmd = &cmd->se_cmd;
 	cmd->cmd_sent_to_fw = 0;
 
 	qlt_unmap_sg(vha, cmd);
 
 	if (unlikely(status != CTIO_SUCCESS)) {
+		u8 op = cmd->cdb ? cmd->cdb[0] : 0;
 		bool term_exchg = false;
 
 		/*
@@ -3970,8 +3982,10 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha,
 			term_exchg = true;
 			if (printk_ratelimit())
 				dev_info(&vha->hw->pdev->dev,
-				    "qla_target(%d): CTIO with INVALID_RX_ID ATIO attr %x CTIO Flags %x|%x\n",
-				    vha->vp_idx, cmd->atio.u.isp24.attr,
+				    "qla_target(%d): tag %lld, op %x: CTIO with INVALID_RX_ID status 0x%x received (state %d, port %8phC, LUN %lld, ATIO attr %x, CTIO Flags %x|%x)\n",
+				    vha->vp_idx, cmd->se_cmd.tag, op,
+				    status, cmd->state, cmd->sess->port_name,
+				    cmd->unpacked_lun, cmd->atio.u.isp24.attr,
 				    ((cmd->ctio_flags >> 9) & 0xf),
 				    cmd->ctio_flags);
 			break;
@@ -3982,13 +3996,31 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha,
 			term_exchg = true;
 			fallthrough;
 		case CTIO_TIMEOUT:
+		{
+			const char *status_str;
+
+			switch (status & 0xFFFF) {
+			case CTIO_LIP_RESET:
+				status_str = "LIP_RESET";
+				break;
+			case CTIO_TARGET_RESET:
+				status_str = "TARGET_RESET";
+				break;
+			case CTIO_ABORTED:
+				status_str = "ABORTED";
+				break;
+			case CTIO_TIMEOUT:
+			default:
+				status_str = "TIMEOUT";
+				break;
+			}
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf058,
-			    "qla_target(%d): CTIO with "
-			    "status %#x received, state %x, se_cmd %p, "
-			    "(LIP_RESET=e, ABORTED=2, TARGET_RESET=17, "
-			    "TIMEOUT=b, INVALID_RX_ID=8)\n", vha->vp_idx,
-			    status, cmd->state, se_cmd);
+			    "qla_target(%d): tag %lld, op %x: CTIO with %s status 0x%x received (state %d, port %8phC, LUN %lld)\n",
+			    vha->vp_idx, cmd->se_cmd.tag, op,
+			    status_str, status, cmd->state,
+			    cmd->sess->port_name, cmd->unpacked_lun);
 			break;
+		}
 
 		case CTIO_PORT_LOGGED_OUT:
 		case CTIO_PORT_UNAVAILABLE:
@@ -3997,10 +4029,11 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha,
 				(status & 0xFFFF) == CTIO_PORT_LOGGED_OUT;
 
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf059,
-			    "qla_target(%d): CTIO with %s status %x "
-			    "received (state %x, se_cmd %p)\n", vha->vp_idx,
+			    "qla_target(%d): tag %lld, op %x: CTIO with %s status 0x%x received (state %d, port %8phC, LUN %lld)\n",
+			    vha->vp_idx, cmd->se_cmd.tag, op,
 			    logged_out ? "PORT LOGGED OUT" : "PORT UNAVAILABLE",
-			    status, cmd->state, se_cmd);
+			    status, cmd->state, cmd->sess->port_name,
+			    cmd->unpacked_lun);
 
 			term_exchg = true;
 			if (logged_out && cmd->sess) {
@@ -4017,14 +4050,15 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha,
 			}
 			break;
 		}
+
 		case CTIO_DIF_ERROR: {
 			struct ctio_crc_from_fw *crc =
 				(struct ctio_crc_from_fw *)ctio;
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf073,
-			    "qla_target(%d): CTIO with DIF_ERROR status %x "
-			    "received (state %x, ulp_cmd %p) actual_dif[0x%llx] "
-			    "expect_dif[0x%llx]\n",
-			    vha->vp_idx, status, cmd->state, se_cmd,
+			    "qla_target(%d): tag %lld, op %x: CTIO with DIF_ERROR status 0x%x received (state %d, port %8phC, LUN %lld, actual_dif[0x%llx] expect_dif[0x%llx])\n",
+			    vha->vp_idx, cmd->se_cmd.tag, op, status,
+			    cmd->state, cmd->sess->port_name,
+			    cmd->unpacked_lun,
 			    *((u64 *)&crc->actual_dif[0]),
 			    *((u64 *)&crc->expected_dif[0]));
 
@@ -4037,14 +4071,18 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha,
 		case CTIO_FAST_INVALID_REQ:
 		case CTIO_FAST_SPI_ERR:
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf05b,
-			    "qla_target(%d): CTIO with EDIF error status 0x%x received (state %x, se_cmd %p\n",
-			    vha->vp_idx, status, cmd->state, se_cmd);
+			    "qla_target(%d): tag %lld, op %x: CTIO with EDIF error status 0x%x received (state %d, port %8phC, LUN %lld)\n",
+			    vha->vp_idx, cmd->se_cmd.tag, op, status,
+			    cmd->state, cmd->sess->port_name,
+			    cmd->unpacked_lun);
 			break;
 
 		default:
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf05b,
-			    "qla_target(%d): CTIO with error status 0x%x received (state %x, se_cmd %p\n",
-			    vha->vp_idx, status, cmd->state, se_cmd);
+			    "qla_target(%d): tag %lld, op %x: CTIO with error status 0x%x received (state %d, port %8phC, LUN %lld)\n",
+			    vha->vp_idx, cmd->se_cmd.tag, op, status,
+			    cmd->state, cmd->sess->port_name,
+			    cmd->unpacked_lun);
 			break;
 		}
 
@@ -4082,12 +4120,13 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha,
 	} else if (cmd->aborted) {
 		cmd->trc_flags |= TRC_CTIO_ABORTED;
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf01e,
-		  "Aborted command %p (tag %lld) finished\n", cmd, se_cmd->tag);
+		    "qla_target(%d): tag %lld: Aborted command finished\n",
+		    vha->vp_idx, cmd->se_cmd.tag);
 	} else {
 		cmd->trc_flags |= TRC_CTIO_STRANGE;
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf05c,
-		    "qla_target(%d): A command in state (%d) should "
-		    "not return a CTIO complete\n", vha->vp_idx, cmd->state);
+		    "qla_target(%d): tag %lld: A command in state (%d) should not return a CTIO complete\n",
+		    vha->vp_idx, cmd->se_cmd.tag, cmd->state);
 	}
 
 	if (unlikely(status != CTIO_SUCCESS) &&
-- 
2.43.0


