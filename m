Received: from mail.cybernetics.com (mail.cybernetics.com [72.215.153.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D17127587D
	for <linux-scsi@vger.kernel.org>; Mon, 10 Nov 2025 15:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.215.153.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762790051; cv=none; b=b1bzj1v7iE0Av3C3Vnmt+PcybZHCOSwOFP0SxqWP79m8bI/UAKU37hGTj1g6md2ZsH+ow+YBBguEM2Ek39Hp4RP9pQyyRKbRYH5TiZ63EZSEH/zB0xLt+myh7I+P+ke+hapmLVown64FPxjgDX+CrWKOvR4bofv3gxg/+pOoOIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762790051; c=relaxed/simple;
	bh=aBlBadCDo4jvS2t/xfKllS/OSshvWCm5WkY+vvGthz8=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=VXsOPVB1gofwa3JK/UWeY2IZp1CSgQJIy+g6XPf1E3thQC83RAyszAGDdQPfA/olUH0h/ZUZ17fz+LTlTdp2odPaDm/9b4K1i/C3WhXn5s8VT21YymE9Rhw5/ECX/f7MQWmtjGa7Tnxhj9F2uoMtzAjwAoTvjfZmEC0yDO0fGYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com; spf=pass smtp.mailfrom=cybernetics.com; dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b=uukvdMjr; arc=none smtp.client-ip=72.215.153.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b="uukvdMjr"
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id zXuXQP7jDdVtO64Z; Mon, 10 Nov 2025 10:54:08 -0500 (EST)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
	bh=7DIf7QZ4vnXO7OepTCyx9SQG+Ol4HqEKsoV4eUbPbq4=;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:Cc:To:From:
	Content-Language:Subject:MIME-Version:Date:Message-ID; b=uukvdMjrHv2AlOI1AZRN
	I7nGyMAlWcFozYwmIgejAhj/3ytS1DAArI7fz4vfQEou+b1AEZGQO8D++PY2YBbUGSU2wcQuPXhaX
	8o1bgosRPfpQSznaSMd0oCe0WkRZZxSLoJi3Xp7LYdncr1svkokBt4TN2gyyw3yqlxOj8c7jdQ=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate SPEC SMTP 8.0.5)
  with ESMTPS id 14272430; Mon, 10 Nov 2025 10:54:07 -0500
Message-ID: <22f8a0b6-0e24-474d-9f28-9d65c9b7af03@cybernetics.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
Date: Mon, 10 Nov 2025 10:54:07 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH v3 06/16] scsi: qla2xxx: improve debug output for term
 exchange
Content-Language: en-US
X-ASG-Orig-Subj: [PATCH v3 06/16] scsi: qla2xxx: improve debug output for term
 exchange
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
X-Barracuda-Start-Time: 1762790048
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 4064
X-ASG-Debug-ID: 1762790047-1cf439139110cd20001-ziuLRu

(target mode)

Print better debug info when terminating a command, and print the
response status from the hardware.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---

v2 -> v3: no changes

v1 -> v2: no changes

 drivers/scsi/qla2xxx/qla_dbg.c    |  2 +-
 drivers/scsi/qla2xxx/qla_target.c | 40 +++++++++++++++++++++++++++----
 2 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 5136549005e7..ff4124eccc9c 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -54,7 +54,7 @@
  * | Misc                         |       0xd303       | 0xd031-0xd0ff	|
  * |                              |                    | 0xd101-0xd1fe	|
  * |                              |                    | 0xd214-0xd2fe	|
- * | Target Mode		  |	  0xe081       |		|
+ * | Target Mode		  |	  0xe084       |		|
  * | Target Mode Management	  |	  0xf09b       | 0xf002		|
  * |                              |                    | 0xf046-0xf049  |
  * | Target Mode Task Management  |	  0x1000d      |		|
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index df5c9aac5617..72c74f8f5375 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1909,6 +1909,10 @@ static void qlt_24xx_retry_term_exchange(struct scsi_qla_host *vha,
 	 * ABTS response. So, in it ID fields are reversed.
 	 */
 
+	ql_dbg(ql_dbg_tgt_mgt, vha, 0xe082,
+	    "qla_target(%d): tag %u: Sending TERM EXCH CTIO for ABTS\n",
+	    vha->vp_idx, le32_to_cpu(entry->exchange_addr_to_abort));
+
 	ctio->entry_type = CTIO_TYPE7;
 	ctio->entry_count = 1;
 	ctio->nport_handle = entry->nport_handle;
@@ -3620,16 +3624,24 @@ static int __qlt_send_term_exchange(struct qla_qpair *qpair,
 {
 	struct scsi_qla_host *vha = qpair->vha;
 	struct ctio7_to_24xx *ctio24;
-	struct qla_hw_data *ha = vha->hw;
 	request_t *pkt;
 	int ret = 0;
 	uint16_t temp;
 
-	ql_dbg(ql_dbg_tgt, vha, 0xe009, "Sending TERM EXCH CTIO (ha=%p)\n", ha);
-
 	if (cmd)
 		vha = cmd->vha;
 
+	if (cmd) {
+		ql_dbg(ql_dbg_tgt_mgt, vha, 0xe009,
+		    "qla_target(%d): tag %lld: Sending TERM EXCH CTIO state %d cmd_sent_to_fw %u\n",
+		    vha->vp_idx, cmd->se_cmd.tag, cmd->state,
+		    cmd->cmd_sent_to_fw);
+	} else {
+		ql_dbg(ql_dbg_tgt_mgt, vha, 0xe009,
+		    "qla_target(%d): tag %u: Sending TERM EXCH CTIO (no cmd)\n",
+		    vha->vp_idx, le32_to_cpu(atio->u.isp24.exchange_addr));
+	}
+
 	pkt = (request_t *)qla2x00_alloc_iocbs_ready(qpair, NULL);
 	if (pkt == NULL) {
 		ql_dbg(ql_dbg_tgt, vha, 0xe050,
@@ -3920,6 +3932,7 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha,
 	struct se_cmd *se_cmd;
 	struct qla_tgt_cmd *cmd;
 	struct qla_qpair *qpair = rsp->qpair;
+	uint16_t ctio_flags;
 
 	if (handle & CTIO_INTERMEDIATE_HANDLE_MARK) {
 		/* That could happen only in case of an error/reset/abort */
@@ -3931,11 +3944,28 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha,
 		return;
 	}
 
+	ctio_flags = le16_to_cpu(ctio->flags);
+
 	cmd = qlt_ctio_to_cmd(vha, rsp, handle, ctio);
-	if (cmd == NULL)
+	if (unlikely(cmd == NULL)) {
+		if ((handle & ~QLA_TGT_HANDLE_MASK) == QLA_TGT_SKIP_HANDLE &&
+		    (ctio_flags & 0xe1ff) == (CTIO7_FLAGS_STATUS_MODE_1 |
+		     CTIO7_FLAGS_TERMINATE)) {
+			u32 tag = le32_to_cpu(ctio->exchange_address);
+
+			if (status == CTIO_SUCCESS)
+				ql_dbg(ql_dbg_tgt_mgt, vha, 0xe083,
+				    "qla_target(%d): tag %u: term exchange successful\n",
+				    vha->vp_idx, tag);
+			else
+				ql_dbg(ql_dbg_tgt_mgt, vha, 0xe084,
+				    "qla_target(%d): tag %u: term exchange failed; status = 0x%x\n",
+				    vha->vp_idx, tag, status);
+		}
 		return;
+	}
 
-	if ((le16_to_cpu(ctio->flags) & CTIO7_FLAGS_DATA_OUT) && cmd->sess)
+	if ((ctio_flags & CTIO7_FLAGS_DATA_OUT) && cmd->sess)
 		qlt_chk_edif_rx_sa_delete_pending(vha, cmd->sess, ctio);
 
 	se_cmd = &cmd->se_cmd;
-- 
2.43.0


