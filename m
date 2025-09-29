Received: from mail.cybernetics.com (mail.cybernetics.com [72.215.153.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCB42FF677
	for <linux-scsi@vger.kernel.org>; Mon, 29 Sep 2025 14:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.215.153.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759156656; cv=none; b=XbsCYJiA2BprkyjXfOx/rP61BCNwuoaKGFimqY4b++kbfHs5NNy0MBZVNtnkKyq05NML8xOogrZUxDjToCMb/5AjddcaOq+0tzrjAenUnW/ZeTuC+INn/iR0nqVuTzsbz4B60SpVLgqM7pGyeUhlkdEldvtRdFsEFxz5S4rHvMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759156656; c=relaxed/simple;
	bh=sXwrn7Yo5KCiAM3HqChWynS5RzMN9zapu7D/7DJu+kM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=KnpebNdP2CEfAuGMtLX/vKE5FWe3URZR3BBzVVcBy1YWWrTA1hIlrCDAKngq5oHZP6DWfj0bD20bcBU6aqSU+FdV0YMttaVsnj22IsNveuVES7kiFR3jfAtH8nDCv4+ekLIFtRc8SY1pn5i873caEEQypuvvqYKusSsR8BhdSsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com; spf=pass smtp.mailfrom=cybernetics.com; dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b=mCbf13Px; arc=none smtp.client-ip=72.215.153.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b="mCbf13Px"
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id DbqaYgkKENzs4L9y; Mon, 29 Sep 2025 10:37:33 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
	bh=yva6rNnOTxJJzCf5mgo/aOLIjnCYtd1mEQiI9FtYCYQ=;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:Cc:To:From:
	Content-Language:Subject:MIME-Version:Date:Message-ID; b=mCbf13PxUPhGNzPEZ9Ac
	Eimb2suwqCiHBvgJGsCDIGv2DTh6KUZyuznWFZHhJEH0cgD/pAwDrYyMdcSCEVp1bWK/1UKqRjv/e
	gHPZ+KkkFIwu0thEao3uBPCiSvC9suuvJxfkVviM3FMHjKB5OQKHCUuIH+22y8TWqUnVzte1jY=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate SPEC SMTP 8.0.5)
  with ESMTPS id 14216623; Mon, 29 Sep 2025 10:37:33 -0400
Message-ID: <e4dffd3f-0d62-4c9d-bff7-e1887bff1f50@cybernetics.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
Date: Mon, 29 Sep 2025 10:37:33 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH v2 07/16] scsi: qla2xxx: fix term exchange when cmd_sent_to_fw
 == 1
Content-Language: en-US
X-ASG-Orig-Subj: [PATCH v2 07/16] scsi: qla2xxx: fix term exchange when cmd_sent_to_fw
 == 1
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
References: <e95ee7d0-3580-4124-b854-7f73ca3a3a84@cybernetics.com>
In-Reply-To: <e95ee7d0-3580-4124-b854-7f73ca3a3a84@cybernetics.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1759156653
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 0
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 3598
X-ASG-Debug-ID: 1759156653-1cf43947df3c0260001-ziuLRu

(target mode)

Properly set the nport_handle field of the terminate exchange message.
Previously when this field was not set properly, the term exchange would
fail when cmd_sent_to_fw == 1 but work when cmd_sent_to_fw == 0 (i.e. it
would fail when the HW was actively transferring data or status for the
cmd but work when the HW was idle).  With this change, term exchange
works in any cmd state, which now makes it possible to abort a command
that is locked up in the HW.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---

v1 -> v2: no changes

 drivers/scsi/qla2xxx/qla_target.c | 52 ++++++++++++++++++-------------
 1 file changed, 31 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 72c74f8f5375..b700bfc642b3 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3622,14 +3622,35 @@ static int __qlt_send_term_exchange(struct qla_qpair *qpair,
 	struct qla_tgt_cmd *cmd,
 	struct atio_from_isp *atio)
 {
-	struct scsi_qla_host *vha = qpair->vha;
 	struct ctio7_to_24xx *ctio24;
-	request_t *pkt;
-	int ret = 0;
+	struct scsi_qla_host *vha;
+	uint16_t loop_id;
 	uint16_t temp;
 
-	if (cmd)
+	if (cmd) {
 		vha = cmd->vha;
+		loop_id = cmd->loop_id;
+	} else {
+		port_id_t id = be_to_port_id(atio->u.isp24.fcp_hdr.s_id);
+		struct qla_hw_data *ha;
+		struct fc_port *sess;
+		unsigned long flags;
+
+		vha = qpair->vha;
+		ha = vha->hw;
+
+		/*
+		 * CTIO7_NHANDLE_UNRECOGNIZED works when aborting an idle
+		 * command but not when aborting a command with an active CTIO
+		 * exchange.
+		 */
+		loop_id = CTIO7_NHANDLE_UNRECOGNIZED;
+		spin_lock_irqsave(&ha->tgt.sess_lock, flags);
+		sess = qla2x00_find_fcport_by_nportid(vha, &id, 1);
+		if (sess)
+			loop_id = sess->loop_id;
+		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
+	}
 
 	if (cmd) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xe009,
@@ -3642,31 +3663,20 @@ static int __qlt_send_term_exchange(struct qla_qpair *qpair,
 		    vha->vp_idx, le32_to_cpu(atio->u.isp24.exchange_addr));
 	}
 
-	pkt = (request_t *)qla2x00_alloc_iocbs_ready(qpair, NULL);
-	if (pkt == NULL) {
+	ctio24 = qla2x00_alloc_iocbs_ready(qpair, NULL);
+	if (!ctio24) {
 		ql_dbg(ql_dbg_tgt, vha, 0xe050,
 		    "qla_target(%d): %s failed: unable to allocate "
 		    "request packet\n", vha->vp_idx, __func__);
 		return -ENOMEM;
 	}
 
-	if (cmd != NULL) {
-		if (cmd->state < QLA_TGT_STATE_PROCESSED) {
-			ql_dbg(ql_dbg_tgt, vha, 0xe051,
-			    "qla_target(%d): Terminating cmd %p with "
-			    "incorrect state %d\n", vha->vp_idx, cmd,
-			    cmd->state);
-		} else
-			ret = 1;
-	}
-
 	qpair->tgt_counters.num_term_xchg_sent++;
-	pkt->entry_count = 1;
-	pkt->handle = QLA_TGT_SKIP_HANDLE | CTIO_COMPLETION_HANDLE_MARK;
 
-	ctio24 = (struct ctio7_to_24xx *)pkt;
 	ctio24->entry_type = CTIO_TYPE7;
-	ctio24->nport_handle = cpu_to_le16(CTIO7_NHANDLE_UNRECOGNIZED);
+	ctio24->entry_count = 1;
+	ctio24->handle = QLA_TGT_SKIP_HANDLE | CTIO_COMPLETION_HANDLE_MARK;
+	ctio24->nport_handle = cpu_to_le16(loop_id);
 	ctio24->timeout = cpu_to_le16(QLA_TGT_TIMEOUT);
 	ctio24->vp_index = vha->vp_idx;
 	ctio24->initiator_id = be_id_to_le(atio->u.isp24.fcp_hdr.s_id);
@@ -3683,7 +3693,7 @@ static int __qlt_send_term_exchange(struct qla_qpair *qpair,
 		qpair->reqq_start_iocbs(qpair);
 	else
 		qla2x00_start_iocbs(vha, qpair->req);
-	return ret;
+	return 0;
 }
 
 static void qlt_send_term_exchange(struct qla_qpair *qpair,
-- 
2.43.0


