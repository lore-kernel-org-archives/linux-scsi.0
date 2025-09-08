Received: from mail.cybernetics.com (mail.cybernetics.com [72.215.153.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F90754654
	for <linux-scsi@vger.kernel.org>; Mon,  8 Sep 2025 19:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.215.153.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757358068; cv=none; b=evw8zi62RPCGqo0MHJo7FwxlV9AoFzZ3H9GNR0zM+GegCBl0TwpOVuY/bor+rxlIqcXZqRTNdIjn+A+vvfXYtkIbBsLr4RHTEyXYQgmy9f8pYsiO+KkDUNdo4xwL2g+jBezsWS/sZTccMDzozZ9HFWqK8GDWBs5zpFwL/OaTx6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757358068; c=relaxed/simple;
	bh=v5605DrgHXYgGUTIdSKUVT8UPJmtSDjfC6fjfhBimzU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=q4IJeLUTUWGzLX1tnkUxt89hXzZyChW5MlwgYsK276JVtu7MnF//FCLd8m6z2t9dy1pyYIiL2xXsQ7lMj3Yg6Wa8N6cIQ8KZCWqxzUrWXbbfXEyukkpgjCtox2kI007+EQZqj2uNOwwmpsHvo9ltEYQoDwz7acGDE4S29v3eDBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com; spf=pass smtp.mailfrom=cybernetics.com; dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b=lURwNsVG; arc=none smtp.client-ip=72.215.153.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b="lURwNsVG"
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id flbENCVvvM0ThneH; Mon, 08 Sep 2025 15:01:05 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
	bh=wLZyR4Gp4v+ggLzVtImTsVNMAUlLsEeuvD/tSV7JM4o=;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:Cc:To:From:
	Content-Language:Subject:MIME-Version:Date:Message-ID; b=lURwNsVGJlJe2GnSrppf
	i916qNPwKA0hiy0xmZM+MaCOtQbIWBAqvGdjD4NFwqOdx2z/9dK5SXGPUY7kC0FfUBfnPZaL1jvGi
	b+KNJtolcbX27K1SagA9yu/PykUfYVbX1bbW7bn177KAm3hcp4SAKY7KED33WWmm7ZYnXDPQnY=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate SPEC SMTP 8.0.5)
  with ESMTPS id 14189145; Mon, 08 Sep 2025 15:01:05 -0400
Message-ID: <1d78cff6-d94d-43b9-a15c-6de3889d6066@cybernetics.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
Date: Mon, 8 Sep 2025 15:01:04 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH 09/15] scsi: qla2xxx: improve checks in qlt_xmit_response /
 qlt_rdy_to_xfer
Content-Language: en-US
X-ASG-Orig-Subj: [PATCH 09/15] scsi: qla2xxx: improve checks in qlt_xmit_response /
 qlt_rdy_to_xfer
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
X-Barracuda-Start-Time: 1757358065
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 5659
X-ASG-Debug-ID: 1757358065-1cf43947df30c540001-ziuLRu

(target mode)

Similar fixes to both functions:

qlt_xmit_response:
- If the cmd cannot be processed, remember to call ->free_cmd() to
  prevent the target-mode midlevel from seeing a cmd lockup.
- Do not try to send the response if the exchange has been terminated.
- Check for chip reset once after lock instead of both before and after
  lock.
- Give errors from qlt_pre_xmit_response() a lower priority to
  compensate for removing the first check for chip reset.

qlt_rdy_to_xfer:
- Check for chip reset after lock instead of before lock to avoid races.
- Do not try to receive data if the exchange has been terminated.
- Give errors from qlt_pci_map_calc_cnt() a lower priority to compensate
  for moving the check for chip reset.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 86 +++++++++++++++++--------------
 1 file changed, 48 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 1160ca4c118f..da010de9ba8a 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3207,12 +3207,7 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 	uint32_t full_req_cnt = 0;
 	unsigned long flags = 0;
 	int res;
-
-	if (!qpair->fw_started || (cmd->reset_count != qpair->chip_reset) ||
-	    (cmd->sess && cmd->sess->deleted)) {
-		cmd->state = QLA_TGT_STATE_PROCESSED;
-		return 0;
-	}
+	int pre_xmit_res;
 
 	ql_dbg_qp(ql_dbg_tgt, qpair, 0xe018,
 	    "is_send_status=%d, cmd->bufflen=%d, cmd->sg_cnt=%d, cmd->dma_data_direction=%d se_cmd[%p] qp %d\n",
@@ -3220,33 +3215,39 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 	    1 : 0, cmd->bufflen, cmd->sg_cnt, cmd->dma_data_direction,
 	    &cmd->se_cmd, qpair->id);
 
-	res = qlt_pre_xmit_response(cmd, &prm, xmit_type, scsi_status,
+	pre_xmit_res = qlt_pre_xmit_response(cmd, &prm, xmit_type, scsi_status,
 	    &full_req_cnt);
-	if (unlikely(res != 0)) {
-		return res;
-	}
+	/*
+	 * Check pre_xmit_res later because we want to check other errors
+	 * first.
+	 */
 
 	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
 
+	if (unlikely(cmd->sent_term_exchg ||
+		     cmd->sess->deleted ||
+		     !qpair->fw_started ||
+		     cmd->reset_count != qpair->chip_reset)) {
+		ql_dbg(ql_dbg_tgt_mgt, vha, 0xe101,
+		    "qla_target(%d): tag %lld: skipping send response for aborted cmd\n",
+		    vha->vp_idx, cmd->se_cmd.tag);
+		qlt_unmap_sg(vha, cmd);
+		cmd->state = QLA_TGT_STATE_PROCESSED;
+		vha->hw->tgt.tgt_ops->free_cmd(cmd);
+		spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
+		return 0;
+	}
+
+	/* Check for errors from qlt_pre_xmit_response(). */
+	res = pre_xmit_res;
+	if (unlikely(res))
+		goto out_unmap_unlock;
+
 	if (xmit_type == QLA_TGT_XMIT_STATUS)
 		qpair->tgt_counters.core_qla_snd_status++;
 	else
 		qpair->tgt_counters.core_qla_que_buf++;
 
-	if (!qpair->fw_started || cmd->reset_count != qpair->chip_reset) {
-		/*
-		 * Either the port is not online or this request was from
-		 * previous life, just abort the processing.
-		 */
-		cmd->state = QLA_TGT_STATE_PROCESSED;
-		ql_dbg_qp(ql_dbg_async, qpair, 0xe101,
-			"RESET-RSP online/active/old-count/new-count = %d/%d/%d/%d.\n",
-			vha->flags.online, qla2x00_reset_active(vha),
-			cmd->reset_count, qpair->chip_reset);
-		res = 0;
-		goto out_unmap_unlock;
-	}
-
 	/* Does F/W have an IOCBs for this request */
 	res = qlt_check_reserve_free_req(qpair, full_req_cnt);
 	if (unlikely(res))
@@ -3361,6 +3362,7 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 	struct qla_tgt_prm prm;
 	unsigned long flags = 0;
 	int res = 0;
+	int pci_map_res;
 	struct qla_qpair *qpair = cmd->qpair;
 
 	memset(&prm, 0, sizeof(prm));
@@ -3369,28 +3371,36 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 	prm.sg = NULL;
 	prm.req_cnt = 1;
 
-	if (!qpair->fw_started || (cmd->reset_count != qpair->chip_reset) ||
-	    (cmd->sess && cmd->sess->deleted)) {
-		/*
-		 * Either the port is not online or this request was from
-		 * previous life, just abort the processing.
-		 */
+	/* Calculate number of entries and segments required */
+	pci_map_res = qlt_pci_map_calc_cnt(&prm);
+	/*
+	 * Check pci_map_res later because we want to check other errors first.
+	 */
+
+	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
+
+	if (unlikely(cmd->sent_term_exchg ||
+		     cmd->sess->deleted ||
+		     !qpair->fw_started ||
+		     cmd->reset_count != qpair->chip_reset)) {
+		ql_dbg(ql_dbg_tgt_mgt, vha, 0xe102,
+		    "qla_target(%d): tag %lld: skipping data-out for aborted cmd\n",
+		    vha->vp_idx, cmd->se_cmd.tag);
+		qlt_unmap_sg(vha, cmd);
 		cmd->aborted = 1;
 		cmd->write_data_transferred = 0;
 		cmd->state = QLA_TGT_STATE_DATA_IN;
 		vha->hw->tgt.tgt_ops->handle_data(cmd);
-		ql_dbg_qp(ql_dbg_async, qpair, 0xe102,
-			"RESET-XFR online/active/old-count/new-count = %d/%d/%d/%d.\n",
-			vha->flags.online, qla2x00_reset_active(vha),
-			cmd->reset_count, qpair->chip_reset);
+		spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
 		return 0;
 	}
 
-	/* Calculate number of entries and segments required */
-	if (qlt_pci_map_calc_cnt(&prm) != 0)
-		return -EAGAIN;
+	/* Check for errors from qlt_pci_map_calc_cnt(). */
+	if (unlikely(pci_map_res != 0)) {
+		res = -EAGAIN;
+		goto out_unlock_free_unmap;
+	}
 
-	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
 	/* Does F/W have an IOCBs for this request */
 	res = qlt_check_reserve_free_req(qpair, prm.req_cnt);
 	if (res != 0)
-- 
2.43.0


