Received: from mail.cybernetics.com (mail.cybernetics.com [72.215.153.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C282472B1
	for <linux-scsi@vger.kernel.org>; Fri,  3 Oct 2025 14:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.215.153.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759502311; cv=none; b=HOqHOAwvxQYIW3EElUZ6SWdLMoNkDpwItDXWXfTydtKUsVqQvGHqCRw6qZDiVMixniM0H+LPgAqzqg4jbcn+dZdgCl/KqrAh7+C7+l8nj6JTYPGtANqk0wc47VZFEohgMihZg8IRoJtjaHehno1tMfcYyXr2q7QDmCi1gspMGFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759502311; c=relaxed/simple;
	bh=s+pFCHQtx2iwLi48JMaz7+9l7AXAYiVMugLfEc3I2Y4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WYC6kVcaewfTWrfNEoRK9O5gln+V/J53VA7YtGR1cayK7uS9v64Or0NkRWAnRN5gS6rwfdomC8VDgWrzciA/THH/l/djlh6jZAjXms1nULMYqclrqSPO8qsm739h9kYpk7r96UhnDss+wRdgJUR3XQH9I/0GFMa69GWCwGVSFWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com; spf=pass smtp.mailfrom=cybernetics.com; dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b=PWiJ2V3K; arc=none smtp.client-ip=72.215.153.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b="PWiJ2V3K"
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id lfBdsFd2g1Bgdmyk; Fri, 03 Oct 2025 10:38:21 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
	bh=5bX+6YMLnqgfErhyM2kFyZ3qB51WB8BBylxMxAN4ZlY=;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:Cc:To:
	Content-Language:Subject:MIME-Version:Date:Message-ID; b=PWiJ2V3KWkJErkoC80ov
	pMz57Wx3vAute+RVMhdzaDAbpvztkc9xPJxYHXe+hmCCo2sOEShM7jsvpeukHhpnoRJQ3cxyRG/qE
	ypYWJOwrZogsgeR6nSe5v5hbgAgXHOkbkKHycpPmNsMlpRkhbf9MD2qAdxbOc9n/xNtOdErnv4=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate SPEC SMTP 8.0.5)
  with ESMTPS id 14223278; Fri, 03 Oct 2025 10:38:21 -0400
Message-ID: <2c536668-7dae-470c-a559-e278c9091b92@cybernetics.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
Date: Fri, 3 Oct 2025 10:38:21 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/16] scsi: qla2xxx: fix TMR failure handling
Content-Language: en-US
X-ASG-Orig-Subj: Re: [PATCH v3 11/16] scsi: qla2xxx: fix TMR failure handling
To: Dan Carpenter <dan.carpenter@linaro.org>, oe-kbuild@lists.linux.dev,
 Nilesh Javali <njavali@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
 linux-scsi <linux-scsi@vger.kernel.org>, target-devel@vger.kernel.org,
 scst-devel@lists.sourceforge.net,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Dmitry Bogdanov <d.bogdanov@yadro.com>,
 Xose Vazquez Perez <xose.vazquez@gmail.com>
References: <202510031227.18psESZQ-lkp@intel.com>
From: Tony Battersby <tonyb@cybernetics.com>
In-Reply-To: <202510031227.18psESZQ-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1759502301
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 8225
X-ASG-Debug-ID: 1759502301-1cf43947df3e3e40001-ziuLRu

On 10/3/25 04:40, Dan Carpenter wrote:
> Hi Tony,
>
> kernel test robot noticed the following build warnings:
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Tony-Battersby/Revert-scsi-qla2xxx-Perform-lockless-command-completion-in-abort-path/20250930-024814
> base:   e5f0a698b34ed76002dc5cff3804a61c80233a7a
> patch link:    https://lore.kernel.org/r/f52cda16-4952-4b28-bbf7-d44f4e054490%40cybernetics.com
> patch subject: [PATCH v2 11/16] scsi: qla2xxx: fix TMR failure handling
> config: i386-randconfig-141-20251002 (https://download.01.org/0day-ci/archive/20251003/202510031227.18psESZQ-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> | Closes: https://lore.kernel.org/r/202510031227.18psESZQ-lkp@intel.com/
>
> New smatch warnings:
> drivers/scsi/qla2xxx/qla_target.c:5735 qlt_handle_abts_completion() error: we previously assumed 'mcmd' could be null (see line 5723)
>
v3 patch below, which should fix this issue.

From: Tony Battersby <tonyb@cybernetics.com>
Date: Fri, 3 Oct 2025 10:03:08 -0400
Subject: [PATCH v3 11/16] scsi: qla2xxx: fix TMR failure handling

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

v2 -> v3:
- Check for mcmd == NULL in qlt_free_ul_mcmd().

v1 -> v2:
- Change FCP_TMF_REJECTED to FCP_TMF_FAILED.
- Add QLA24XX_MGMT_LLD_OWNED and qlt_free_ul_mcmd().
- Improve patch description.

 drivers/scsi/qla2xxx/qla_os.c     |  2 +-
 drivers/scsi/qla2xxx/qla_target.c | 56 +++++++++++++------------------
 drivers/scsi/qla2xxx/qla_target.h |  2 ++
 3 files changed, 27 insertions(+), 33 deletions(-)

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
index 849ab256807b..009b9ca5c2b9 100644
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
 
@@ -2234,6 +2211,21 @@ void qlt_free_mcmd(struct qla_tgt_mgmt_cmd *mcmd)
 }
 EXPORT_SYMBOL(qlt_free_mcmd);
 
+/*
+ * If the upper layer knows about this mgmt cmd, then call its ->free_cmd()
+ * callback, which will eventually call qlt_free_mcmd().  Otherwise, call
+ * qlt_free_mcmd() directly.
+ */
+void qlt_free_ul_mcmd(struct qla_hw_data *ha, struct qla_tgt_mgmt_cmd *mcmd)
+{
+	if (!mcmd)
+		return;
+	if (mcmd->flags & QLA24XX_MGMT_LLD_OWNED)
+		qlt_free_mcmd(mcmd);
+	else
+		ha->tgt.tgt_ops->free_mcmd(mcmd);
+}
+
 /*
  * ha->hardware_lock supposed to be held on entry. Might drop it, then
  * reacquire
@@ -2326,12 +2318,12 @@ void qlt_xmit_tm_rsp(struct qla_tgt_mgmt_cmd *mcmd)
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
@@ -2364,7 +2356,7 @@ void qlt_xmit_tm_rsp(struct qla_tgt_mgmt_cmd *mcmd)
 	 * qlt_xmit_tm_rsp() returns here..
 	 */
 	if (free_mcmd)
-		ha->tgt.tgt_ops->free_mcmd(mcmd);
+		qlt_free_ul_mcmd(ha, mcmd);
 
 	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
 }
@@ -5742,7 +5734,7 @@ static void qlt_handle_abts_completion(struct scsi_qla_host *vha,
 		if (le32_to_cpu(entry->error_subcode1) == 0x1E &&
 		    le32_to_cpu(entry->error_subcode2) == 0) {
 			if (qlt_chk_unresolv_exchg(vha, rsp->qpair, entry)) {
-				ha->tgt.tgt_ops->free_mcmd(mcmd);
+				qlt_free_ul_mcmd(ha, mcmd);
 				return;
 			}
 			qlt_24xx_retry_term_exchange(vha, rsp->qpair,
@@ -5753,10 +5745,10 @@ static void qlt_handle_abts_completion(struct scsi_qla_host *vha,
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


