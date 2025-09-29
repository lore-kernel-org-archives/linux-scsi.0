Received: from mail.cybernetics.com (mail.cybernetics.com [72.215.153.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028F530ACE3
	for <linux-scsi@vger.kernel.org>; Mon, 29 Sep 2025 14:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.215.153.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759157077; cv=none; b=TcdYDPhE1jiTbdjZdzJFoC9BEjQYFmB7HBYpRTKEh0iJBJoMah8+e83oeoDiyQtu2EbN2meVheBxBxr2RgfpujecagJ30tSsc8Fcvdfxcho30l8Z2Gv4aprd1qGAr60RTeu6A0WDi/Ody2qNzviMAS8wJLljjQeJk4HQRl982p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759157077; c=relaxed/simple;
	bh=8oW2jLWEgnKwodbbp9b6V0oQUytrGU3HhuiVIqSGf4s=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=QmJKlmp8+aeGXtK5voYfLXlCWtF9FWn86fkmcM7GWdyNS0/YzVbdw7n84vi2OPP0cim099EvonQe0qtDTIbh1svEkHJfkJJKbrKFJpTL3RbKO+J/Tsysd34nj4vLl5Urznd6unGxNtdKlNdKh5Ab2vmk4IRr98CVsNUopiPoCiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com; spf=pass smtp.mailfrom=cybernetics.com; dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b=nIFLaRPM; arc=none smtp.client-ip=72.215.153.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b="nIFLaRPM"
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id ApvESGBBVvpfwyJI; Mon, 29 Sep 2025 10:44:34 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
	bh=lA47FHnFvX96rFmyVLQb2sIsUaY8syLj2K+pJhbrT9g=;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:Cc:To:From:
	Content-Language:Subject:MIME-Version:Date:Message-ID; b=nIFLaRPMSCNvuVv7hqoA
	UJOYe5oUeXY5lBI/HUCyoiiO5S5EJZfslwlbwFN7M7+OaNxPMyrmGIURjA9DWu8HEPY+XYl+UWQrL
	Am9jhEWfoW/uKMEManuUk3pUJiRmGQukRBINmhG5Swi28FrfRTiOmUERTaT5GczmW3e/eKoqkQ=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate SPEC SMTP 8.0.5)
  with ESMTPS id 14216645; Mon, 29 Sep 2025 10:44:34 -0400
Message-ID: <7a48ea6e-1c0c-4646-8fa7-57bf0d88ba26@cybernetics.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
Date: Mon, 29 Sep 2025 10:44:34 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH v2 12/16] scsi: qla2xxx: fix invalid memory access with big
 CDBs
Content-Language: en-US
X-ASG-Orig-Subj: [PATCH v2 12/16] scsi: qla2xxx: fix invalid memory access with big
 CDBs
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
X-Barracuda-Start-Time: 1759157074
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 7468
X-ASG-Debug-ID: 1759157074-1cf43947df3c0420001-ziuLRu

(target mode)

struct atio7_fcp_cmnd is a variable-length data structure because of
add_cdb_len, but it is embedded in struct atio_from_isp and copied
around like a fixed-length data structure.  For big CDBs > 16 bytes,
get_datalen_for_atio() called on a fixed-length copy of the atio will
access invalid memory.

In some cases this can be fixed by moving the atio to the end of the
data structure and using a variable-length allocation.  In other cases
such as allocating struct qla_tgt_cmd, the fixed-length data structures
are preallocated for speed, so in the case that add_cdb_len != 0,
allocate a separate buffer for the CDB.  Also add memcpy_atio() as a
safeguard against invalid memory accesses.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---

v1 -> v2: no changes

 drivers/scsi/qla2xxx/qla_target.c | 83 ++++++++++++++++++++++++++++---
 drivers/scsi/qla2xxx/qla_target.h |  7 ++-
 2 files changed, 81 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 69ccba3436ec..c2876b442a08 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -210,6 +210,10 @@ static void qlt_queue_unknown_atio(scsi_qla_host_t *vha,
 	struct qla_tgt_sess_op *u;
 	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
 	unsigned long flags;
+	unsigned int add_cdb_len = 0;
+
+	/* atio must be the last member of qla_tgt_sess_op for add_cdb_len */
+	BUILD_BUG_ON(offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) != sizeof(*u));
 
 	if (tgt->tgt_stop) {
 		ql_dbg(ql_dbg_async, vha, 0x502c,
@@ -218,12 +222,17 @@ static void qlt_queue_unknown_atio(scsi_qla_host_t *vha,
 		goto out_term;
 	}
 
-	u = kzalloc(sizeof(*u), GFP_ATOMIC);
+	if (atio->u.raw.entry_type == ATIO_TYPE7 &&
+	    atio->u.isp24.fcp_cmnd.task_mgmt_flags == 0)
+		add_cdb_len =
+			((unsigned int) atio->u.isp24.fcp_cmnd.add_cdb_len) * 4;
+
+	u = kzalloc(sizeof(*u) + add_cdb_len, GFP_ATOMIC);
 	if (u == NULL)
 		goto out_term;
 
 	u->vha = vha;
-	memcpy(&u->atio, atio, sizeof(*atio));
+	memcpy(&u->atio, atio, sizeof(*atio) + add_cdb_len);
 	INIT_LIST_HEAD(&u->cmd_list);
 
 	spin_lock_irqsave(&vha->cmd_list_lock, flags);
@@ -3829,6 +3838,13 @@ void qlt_free_cmd(struct qla_tgt_cmd *cmd)
 		qlt_decr_num_pend_cmds(cmd->vha);
 
 	BUG_ON(cmd->sg_mapped);
+
+	if (unlikely(cmd->cdb != &cmd->atio.u.isp24.fcp_cmnd.cdb[0])) {
+		kfree(cmd->cdb);
+		cmd->cdb = &cmd->atio.u.isp24.fcp_cmnd.cdb[0];
+		cmd->cdb_len = 16;
+	}
+
 	cmd->jiffies_at_free = get_jiffies_64();
 
 	if (!sess || !sess->se_sess) {
@@ -4128,7 +4144,6 @@ static void __qlt_do_work(struct qla_tgt_cmd *cmd)
 	struct qla_hw_data *ha = vha->hw;
 	struct fc_port *sess = cmd->sess;
 	struct atio_from_isp *atio = &cmd->atio;
-	unsigned char *cdb;
 	unsigned long flags;
 	uint32_t data_length;
 	int ret, fcp_task_attr, data_dir, bidi = 0;
@@ -4144,7 +4159,6 @@ static void __qlt_do_work(struct qla_tgt_cmd *cmd)
 		goto out_term;
 	}
 
-	cdb = &atio->u.isp24.fcp_cmnd.cdb[0];
 	cmd->se_cmd.tag = le32_to_cpu(atio->u.isp24.exchange_addr);
 
 	if (atio->u.isp24.fcp_cmnd.rddata &&
@@ -4162,7 +4176,7 @@ static void __qlt_do_work(struct qla_tgt_cmd *cmd)
 	    atio->u.isp24.fcp_cmnd.task_attr);
 	data_length = get_datalen_for_atio(atio);
 
-	ret = ha->tgt.tgt_ops->handle_cmd(vha, cmd, cdb, data_length,
+	ret = ha->tgt.tgt_ops->handle_cmd(vha, cmd, cmd->cdb, data_length,
 				          fcp_task_attr, data_dir, bidi);
 	if (ret != 0)
 		goto out_term;
@@ -4183,6 +4197,11 @@ static void __qlt_do_work(struct qla_tgt_cmd *cmd)
 	qlt_send_term_exchange(qpair, NULL, &cmd->atio, 1);
 
 	qlt_decr_num_pend_cmds(vha);
+	if (unlikely(cmd->cdb != &cmd->atio.u.isp24.fcp_cmnd.cdb[0])) {
+		kfree(cmd->cdb);
+		cmd->cdb = &cmd->atio.u.isp24.fcp_cmnd.cdb[0];
+		cmd->cdb_len = 16;
+	}
 	cmd->vha->hw->tgt.tgt_ops->rel_cmd(cmd);
 	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
 
@@ -4306,18 +4325,43 @@ static void qlt_assign_qpair(struct scsi_qla_host *vha,
 	cmd->se_cmd.cpuid = h->cpuid;
 }
 
+/*
+ * Safely make a fixed-length copy of a variable-length atio by truncating the
+ * CDB if necessary.
+ */
+static void memcpy_atio(struct atio_from_isp *dst,
+	const struct atio_from_isp *src)
+{
+	int len;
+
+	memcpy(dst, src, sizeof(*dst));
+
+	/*
+	 * If the CDB was truncated, prevent get_datalen_for_atio() from
+	 * accessing invalid memory.
+	 */
+	len = src->u.isp24.fcp_cmnd.add_cdb_len;
+	if (unlikely(len != 0)) {
+		dst->u.isp24.fcp_cmnd.add_cdb_len = 0;
+		memcpy(&dst->u.isp24.fcp_cmnd.add_cdb[0],
+		       &src->u.isp24.fcp_cmnd.add_cdb[len * 4],
+		       4);
+	}
+}
+
 static struct qla_tgt_cmd *qlt_get_tag(scsi_qla_host_t *vha,
 				       struct fc_port *sess,
 				       struct atio_from_isp *atio)
 {
 	struct qla_tgt_cmd *cmd;
+	int add_cdb_len;
 
 	cmd = vha->hw->tgt.tgt_ops->get_cmd(sess);
 	if (!cmd)
 		return NULL;
 
 	cmd->cmd_type = TYPE_TGT_CMD;
-	memcpy(&cmd->atio, atio, sizeof(*atio));
+	memcpy_atio(&cmd->atio, atio);
 	INIT_LIST_HEAD(&cmd->sess_cmd_list);
 	cmd->state = QLA_TGT_STATE_NEW;
 	cmd->tgt = vha->vha_tgt.qla_tgt;
@@ -4337,6 +4381,29 @@ static struct qla_tgt_cmd *qlt_get_tag(scsi_qla_host_t *vha,
 	cmd->vp_idx = vha->vp_idx;
 	cmd->edif = sess->edif.enable;
 
+	cmd->cdb = &cmd->atio.u.isp24.fcp_cmnd.cdb[0];
+	cmd->cdb_len = 16;
+
+	/*
+	 * NOTE: memcpy_atio() set cmd->atio.u.isp24.fcp_cmnd.add_cdb_len to 0,
+	 * so use the original value here.
+	 */
+	add_cdb_len = atio->u.isp24.fcp_cmnd.add_cdb_len;
+	if (unlikely(add_cdb_len != 0)) {
+		int cdb_len = 16 + add_cdb_len * 4;
+		u8 *cdb;
+
+		cdb = kmalloc(cdb_len, GFP_ATOMIC);
+		if (unlikely(!cdb)) {
+			vha->hw->tgt.tgt_ops->free_cmd(cmd);
+			return NULL;
+		}
+		/* CAUTION: copy CDB from atio not cmd->atio */
+		memcpy(cdb, atio->u.isp24.fcp_cmnd.cdb, cdb_len);
+		cmd->cdb = cdb;
+		cmd->cdb_len = cdb_len;
+	}
+
 	return cmd;
 }
 
@@ -5484,13 +5551,15 @@ qlt_alloc_qfull_cmd(struct scsi_qla_host *vha,
 
 	qlt_incr_num_pend_cmds(vha);
 	INIT_LIST_HEAD(&cmd->cmd_list);
-	memcpy(&cmd->atio, atio, sizeof(*atio));
+	memcpy_atio(&cmd->atio, atio);
 
 	cmd->tgt = vha->vha_tgt.qla_tgt;
 	cmd->vha = vha;
 	cmd->reset_count = ha->base_qpair->chip_reset;
 	cmd->q_full = 1;
 	cmd->qpair = ha->base_qpair;
+	cmd->cdb = &cmd->atio.u.isp24.fcp_cmnd.cdb[0];
+	cmd->cdb_len = 16;
 
 	if (qfull) {
 		cmd->q_full = 1;
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 223c40bc9498..97aa6d9cfc27 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -830,11 +830,13 @@ struct qla_tgt {
 struct qla_tgt_sess_op {
 	struct scsi_qla_host *vha;
 	uint32_t chip_reset;
-	struct atio_from_isp atio;
 	struct work_struct work;
 	struct list_head cmd_list;
 	bool aborted;
 	struct rsp_que *rsp;
+
+	struct atio_from_isp atio;
+	/* DO NOT ADD ANYTHING ELSE HERE - atio must be last member */
 };
 
 enum trace_flags {
@@ -925,8 +927,9 @@ struct qla_tgt_cmd {
 	uint8_t scsi_status, sense_key, asc, ascq;
 
 	struct crc_context *ctx;
-	const uint8_t	*cdb;
+	uint8_t		*cdb;
 	uint64_t	lba;
+	int		cdb_len;
 	uint16_t	a_guard, e_guard, a_app_tag, e_app_tag;
 	uint32_t	a_ref_tag, e_ref_tag;
 #define DIF_BUNDL_DMA_VALID 1
-- 
2.43.0


