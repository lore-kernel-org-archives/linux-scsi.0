Received: from mail.cybernetics.com (mail.cybernetics.com [72.215.153.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A1622FDEC
	for <linux-scsi@vger.kernel.org>; Mon, 10 Nov 2025 15:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.215.153.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762790297; cv=none; b=XRsHl2ITRuv6OgJ8ZBpGPoGtaCjk3H6hMTmSj9N/MCnaInk8qM76kvQdk1/VXd1AqXJlJ+svMZC2d0KHx3v4oVyfwJDcti84DVj+9H6+H0nwhCZwYx1WSjzjQcp3GhzwwFk5jHuLQWiF2ZQFWhxVr9GmAHjlPliZijYMSiHYWjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762790297; c=relaxed/simple;
	bh=XvvgPNLHx2K2IYwC99YEuuNErfuamHgP55IEE6tjwVE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=OV3OzuM6mWnz6Z+pj69CYPR8HeXESTWwSVhVaeGFd3Gf9JQL5dmPxGXiO9duh/IXC/9m8IPuhENNRhABarA0KmjIIoNz94m2h6Nee0TFW+dcu9OHte2nI1qoepK73aez8FuF2B2I0xqXYx/N3iVWhmcCXXI99jXz+Nh4bMCBdf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com; spf=pass smtp.mailfrom=cybernetics.com; dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b=h8LXPCj5; arc=none smtp.client-ip=72.215.153.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b="h8LXPCj5"
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id KZqyQturEEUHVqIo; Mon, 10 Nov 2025 10:58:12 -0500 (EST)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
	bh=DvTiyzz44y1AtG6kDbhfAlRq8NZ1xcxnk5S30oKu15U=;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:Cc:To:From:
	Content-Language:Subject:MIME-Version:Date:Message-ID; b=h8LXPCj5xWqfwddZno2R
	HHqJMMdz/xcJ8kWO/Sbm9aD2JIqjwRK26Z7n/gja89JZyPC+7BdWHHmEndRym1gVoXPy+ep4T1j+P
	4bOpPPgB41sQelWiszLPOxBWBpEQ1dPase8Jt9XH7q4hqjqUfGy3UoI3nRpZBeFdqZc8MmAHxo=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate SPEC SMTP 8.0.5)
  with ESMTPS id 14272449; Mon, 10 Nov 2025 10:58:12 -0500
Message-ID: <cd6ccd31-33fa-4454-be36-507bf578a546@cybernetics.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
Date: Mon, 10 Nov 2025 10:58:12 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH v3 10/16] scsi: qla2xxx: improve checks in qlt_xmit_response /
 qlt_rdy_to_xfer
Content-Language: en-US
X-ASG-Orig-Subj: [PATCH v3 10/16] scsi: qla2xxx: improve checks in qlt_xmit_response /
 qlt_rdy_to_xfer
From: Tony Battersby <tonyb@cybernetics.com>
To: Nilesh Javali <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel@vger.kernel.org,
 scst-devel@lists.sourceforge.net,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Dmitry Bogdanov <d.bogdanov@yadro.com>,
 Xose Vazquez Perez <xose.vazquez@gmail.com>
References: <aaea0ab0-da8b-4153-9369-60db7507ff7a@cybernetics.com>
In-Reply-To: <aaea0ab0-da8b-4153-9369-60db7507ff7a@cybernetics.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1762790292
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 0
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 5709
X-ASG-Debug-ID: 1762790292-1cf439139110cdd0001-ziuLRu

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

v2 -> v3: no changes

v1 -> v2: no changes

 drivers/scsi/qla2xxx/qla_target.c | 86 +++++++++++++++++--------------
 1 file changed, 48 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index c6dc5e9efb69..849ab256807b 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3206,12 +3206,7 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
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
@@ -3219,33 +3214,39 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
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
@@ -3360,6 +3361,7 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 	struct qla_tgt_prm prm;
 	unsigned long flags = 0;
 	int res = 0;
+	int pci_map_res;
 	struct qla_qpair *qpair = cmd->qpair;
 
 	memset(&prm, 0, sizeof(prm));
@@ -3368,28 +3370,36 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
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


