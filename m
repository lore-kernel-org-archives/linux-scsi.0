Received: from mail.cybernetics.com (mail.cybernetics.com [72.215.153.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B5B155A25
	for <linux-scsi@vger.kernel.org>; Mon, 29 Sep 2025 14:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.215.153.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759157011; cv=none; b=g0FZ2XolmyxrWjY/mrCli/UauE2QFyDo4AT8zNv+nVDiZT/E5XxjtboPVYFTNxXj2SE9S1aTCva1vItwKwwVe62NhAs4opkOOnn3J3EQLaptmYKmvmesElNvYQ2gRGwejcHhQJ5ysrtku/odVOK/F8jYUb0/bZrMFDAiwcejytY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759157011; c=relaxed/simple;
	bh=6LBt5eyV9mYhPLfyrtop1CAeRd9F2GvZXTgUFbXGQyk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=YoUY7B2HP77h8wjNpGtWApZ0D9bPixqu7Mn3rme7R4DlD1oYRGCRuWBdlnBdoMTR1QwBeHL1If3Cgih+GCX620i9sTFTKEWcQqqvecoJgAkHI6WIiUIOvmVxLjRIVrktwFmQyOxxzxKkp99xjXX4MEOXiBsYiNKC+akNV0vdKgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com; spf=pass smtp.mailfrom=cybernetics.com; dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b=GbweeamM; arc=none smtp.client-ip=72.215.153.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b="GbweeamM"
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id m0crga1vg9aUzSkC; Mon, 29 Sep 2025 10:43:28 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
	bh=Ijig8A8M5l5NoiSG70XS/AqNg7MQUA3QnctmGLYA5Wc=;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:Cc:To:From:
	Content-Language:Subject:MIME-Version:Date:Message-ID; b=GbweeamMLhhf1g+kurlt
	6iTMks35WmU9rR0b4PZFDmqjM8QCLFU5GG4Rj8FJ9tjfT2HPXLIJq1KzgSBZ3ZUlzcdz6g7wA18da
	Z14FHkmko13QzkEdRuaYdLtQABn/aaoxkoFVoP7XLjhaHiW6wPnCixl+UHShWT6Aq6Y7MdOEbM=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate SPEC SMTP 8.0.5)
  with ESMTPS id 14216643; Mon, 29 Sep 2025 10:43:28 -0400
Message-ID: <f52cda16-4952-4b28-bbf7-d44f4e054490@cybernetics.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
Date: Mon, 29 Sep 2025 10:43:28 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH v2 11/16] scsi: qla2xxx: fix TMR failure handling
Content-Language: en-US
X-ASG-Orig-Subj: [PATCH v2 11/16] scsi: qla2xxx: fix TMR failure handling
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
X-Barracuda-Start-Time: 1759157008
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 0
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 6693
X-ASG-Debug-ID: 1759157008-1cf43947df3c03f0001-ziuLRu

(target mode)

If handle_tmr() fails:

- The code for QLA_TGT_ABTS results in memory-use-after-free and
  double-free:
	qlt_do_tmr_work()
		qlt_build_abts_resp_iocb()
			qpair->req->outstanding_cmds[h] = (srb_t *)mcmd;
		mempool_free(mcmd, qla_tgt_mgmt_cmd_mempool); FIRST FREE
	qlt_handle_abts_completion()
		mcmd = qlt_ctio_to_cmd()
			cmd = req->outstanding_cmds[h];
			return cmd;
		vha  = mcmd->vha; USE-AFTER-FREE
		ha->tgt.tgt_ops->free_mcmd(mcmd); SECOND FREE

- qlt_send_busy() makes no sense because it sends a SCSI command
  response instead of a TMR response.

Instead just call qlt_xmit_tm_rsp() to send a TMR failed response,
since that code is well-tested and handles a number of corner cases.
But it would be incorrect to call ha->tgt.tgt_ops->free_mcmd() after
handle_tmr() failed, so add a flag to mcmd indicating the proper way to
free the mcmd so that qlt_xmit_tm_rsp() can be used for both cases.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---

v1 -> v2:
- Change FCP_TMF_REJECTED to FCP_TMF_FAILED.
- Add QLA24XX_MGMT_LLD_OWNED and qlt_free_ul_mcmd().
- Improve patch description.

 drivers/scsi/qla2xxx/qla_os.c     |  2 +-
 drivers/scsi/qla2xxx/qla_target.c | 54 +++++++++++++------------------
 drivers/scsi/qla2xxx/qla_target.h |  2 ++
 3 files changed, 25 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 2a3eb1dacf86..64387224f28a 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1893,7 +1893,7 @@ __qla2x00_abort_all_cmds(struct qla_qpair *qp, int res)
 				 * Currently, only ABTS response gets on the
 				 * outstanding_cmds[]
 				 */
-				ha->tgt.tgt_ops->free_mcmd(
+				qlt_free_ul_mcmd(ha,
 					(struct qla_tgt_mgmt_cmd *) sp);
 				break;
 			default:
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 849ab256807b..69ccba3436ec 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2005,7 +2005,6 @@ static void qlt_do_tmr_work(struct work_struct *work)
 	struct qla_hw_data *ha = mcmd->vha->hw;
 	int rc;
 	uint32_t tag;
-	unsigned long flags;
 
 	switch (mcmd->tmr_func) {
 	case QLA_TGT_ABTS:
@@ -2020,34 +2019,12 @@ static void qlt_do_tmr_work(struct work_struct *work)
 	    mcmd->tmr_func, tag);
 
 	if (rc != 0) {
-		spin_lock_irqsave(mcmd->qpair->qp_lock_ptr, flags);
-		switch (mcmd->tmr_func) {
-		case QLA_TGT_ABTS:
-			mcmd->fc_tm_rsp = FCP_TMF_REJECTED;
-			qlt_build_abts_resp_iocb(mcmd);
-			break;
-		case QLA_TGT_LUN_RESET:
-		case QLA_TGT_CLEAR_TS:
-		case QLA_TGT_ABORT_TS:
-		case QLA_TGT_CLEAR_ACA:
-		case QLA_TGT_TARGET_RESET:
-			qlt_send_busy(mcmd->qpair, &mcmd->orig_iocb.atio,
-			    qla_sam_status);
-			break;
-
-		case QLA_TGT_ABORT_ALL:
-		case QLA_TGT_NEXUS_LOSS_SESS:
-		case QLA_TGT_NEXUS_LOSS:
-			qlt_send_notify_ack(mcmd->qpair,
-			    &mcmd->orig_iocb.imm_ntfy, 0, 0, 0, 0, 0, 0);
-			break;
-		}
-		spin_unlock_irqrestore(mcmd->qpair->qp_lock_ptr, flags);
-
 		ql_dbg(ql_dbg_tgt_mgt, mcmd->vha, 0xf052,
 		    "qla_target(%d):  tgt_ops->handle_tmr() failed: %d\n",
 		    mcmd->vha->vp_idx, rc);
-		mempool_free(mcmd, qla_tgt_mgmt_cmd_mempool);
+		mcmd->flags |= QLA24XX_MGMT_LLD_OWNED;
+		mcmd->fc_tm_rsp = FCP_TMF_FAILED;
+		qlt_xmit_tm_rsp(mcmd);
 	}
 }
 
@@ -2234,6 +2211,19 @@ void qlt_free_mcmd(struct qla_tgt_mgmt_cmd *mcmd)
 }
 EXPORT_SYMBOL(qlt_free_mcmd);
 
+/*
+ * If the upper layer knows about this mgmt cmd, then call its ->free_cmd()
+ * callback, which will eventually call qlt_free_mcmd().  Otherwise, call
+ * qlt_free_mcmd() directly.
+ */
+void qlt_free_ul_mcmd(struct qla_hw_data *ha, struct qla_tgt_mgmt_cmd *mcmd)
+{
+	if (mcmd->flags & QLA24XX_MGMT_LLD_OWNED)
+		qlt_free_mcmd(mcmd);
+	else
+		ha->tgt.tgt_ops->free_mcmd(mcmd);
+}
+
 /*
  * ha->hardware_lock supposed to be held on entry. Might drop it, then
  * reacquire
@@ -2326,12 +2316,12 @@ void qlt_xmit_tm_rsp(struct qla_tgt_mgmt_cmd *mcmd)
 			"RESET-TMR online/active/old-count/new-count = %d/%d/%d/%d.\n",
 			vha->flags.online, qla2x00_reset_active(vha),
 			mcmd->reset_count, qpair->chip_reset);
-		ha->tgt.tgt_ops->free_mcmd(mcmd);
+		qlt_free_ul_mcmd(ha, mcmd);
 		spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
 		return;
 	}
 
-	if (mcmd->flags == QLA24XX_MGMT_SEND_NACK) {
+	if (mcmd->flags & QLA24XX_MGMT_SEND_NACK) {
 		switch (mcmd->orig_iocb.imm_ntfy.u.isp24.status_subcode) {
 		case ELS_LOGO:
 		case ELS_PRLO:
@@ -2364,7 +2354,7 @@ void qlt_xmit_tm_rsp(struct qla_tgt_mgmt_cmd *mcmd)
 	 * qlt_xmit_tm_rsp() returns here..
 	 */
 	if (free_mcmd)
-		ha->tgt.tgt_ops->free_mcmd(mcmd);
+		qlt_free_ul_mcmd(ha, mcmd);
 
 	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
 }
@@ -5742,7 +5732,7 @@ static void qlt_handle_abts_completion(struct scsi_qla_host *vha,
 		if (le32_to_cpu(entry->error_subcode1) == 0x1E &&
 		    le32_to_cpu(entry->error_subcode2) == 0) {
 			if (qlt_chk_unresolv_exchg(vha, rsp->qpair, entry)) {
-				ha->tgt.tgt_ops->free_mcmd(mcmd);
+				qlt_free_ul_mcmd(ha, mcmd);
 				return;
 			}
 			qlt_24xx_retry_term_exchange(vha, rsp->qpair,
@@ -5753,10 +5743,10 @@ static void qlt_handle_abts_completion(struct scsi_qla_host *vha,
 			    vha->vp_idx, entry->compl_status,
 			    entry->error_subcode1,
 			    entry->error_subcode2);
-			ha->tgt.tgt_ops->free_mcmd(mcmd);
+			qlt_free_ul_mcmd(ha, mcmd);
 		}
 	} else if (mcmd) {
-		ha->tgt.tgt_ops->free_mcmd(mcmd);
+		qlt_free_ul_mcmd(ha, mcmd);
 	}
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index eb15d8e9f79e..223c40bc9498 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -966,6 +966,7 @@ struct qla_tgt_mgmt_cmd {
 	unsigned int flags;
 #define QLA24XX_MGMT_SEND_NACK	BIT_0
 #define QLA24XX_MGMT_ABORT_IO_ATTR_VALID BIT_1
+#define QLA24XX_MGMT_LLD_OWNED	BIT_2
 	uint32_t reset_count;
 	struct work_struct work;
 	uint64_t unpacked_lun;
@@ -1059,6 +1060,7 @@ extern int qlt_abort_cmd(struct qla_tgt_cmd *);
 void qlt_send_term_exchange(struct qla_qpair *qpair,
 	struct qla_tgt_cmd *cmd, struct atio_from_isp *atio, int ha_locked);
 extern void qlt_xmit_tm_rsp(struct qla_tgt_mgmt_cmd *);
+void qlt_free_ul_mcmd(struct qla_hw_data *ha, struct qla_tgt_mgmt_cmd *mcmd);
 extern void qlt_free_mcmd(struct qla_tgt_mgmt_cmd *);
 extern void qlt_free_cmd(struct qla_tgt_cmd *cmd);
 extern void qlt_unmap_sg(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd);
-- 
2.43.0


