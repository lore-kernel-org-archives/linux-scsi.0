Received: from mail.cybernetics.com (mail.cybernetics.com [72.215.153.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC86E7E0E8
	for <linux-scsi@vger.kernel.org>; Wed, 17 Sep 2025 20:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.215.153.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758141512; cv=none; b=Oh0WQN0djkmGM8vKssRXUrCSpsYeqQsVG2VS8yM/y300N6Ve8vgvmeSyf8oV0bpQ4FMKQwXx2q4uU/T2kH2J/YO2PX81zQM7lmopguUetJ82xljZ6avOWdFFgHHtS7vAtYf+kNGlYDDFgqCwpO8/88B1T+EuwlYwlst2g1uAUYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758141512; c=relaxed/simple;
	bh=a/iD33GvYTEkwuSozJYoLCewcQgi0sOaVuviXlk0wMc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qc/bfbIpcgCQkoVjBQFTEuLXMaNZXn0IaVjoY5sEBNulHpz3+IMnHQBkNdoOS0bxSDOJ+jUmMkzjdhWLvaE79sNNAoN4hRFZmVc6OPzvtYqKWk8mjehMvTtZL9qF3oOnFLmr+svcAMiHJMa8diem4du6E25kc++5FshJmdXFVDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com; spf=pass smtp.mailfrom=cybernetics.com; dkim=fail (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b=n1d04PTo reason="signature verification failed"; arc=none smtp.client-ip=72.215.153.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b="n1d04PTo"
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id HzpGG8uSwFbkbqww; Wed, 17 Sep 2025 16:38:22 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
	bh=oL1F8gzzpaib0l+nvp/telYc5XtMu6BNekRjylhrow8=;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:Cc:To:
	Content-Language:Subject:MIME-Version:Date:Message-ID; b=n1d04PTop6ATnE+mKYZm
	fFLYo1GPMF3LnTaGECk/VoTjlAi+fHJsFvdj5b+cDRIIxwgwJL3tcr1C5JDdpI3o0uVLD1oZP87HB
	+kQbTrGNkU1zkRUsoep87lSp/6S1Mav9NBwssAvqRpJ8VOejOu8JemJn8rvQQ31eESuN/wUXR4=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate SPEC SMTP 8.0.5)
  with ESMTPS id 14202411; Wed, 17 Sep 2025 16:38:22 -0400
Message-ID: <7e746ee3-6c51-4006-a5cf-17ca527be71b@cybernetics.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
Date: Wed, 17 Sep 2025 16:38:22 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [DMARC Error]Re: [PATCH 10/15] scsi: qla2xxx: fix TMR failure
 handling
Content-Language: en-US
X-ASG-Orig-Subj: Re: [DMARC Error]Re: [PATCH 10/15] scsi: qla2xxx: fix TMR failure
 handling
To: Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc: Nilesh Javali <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi <linux-scsi@vger.kernel.org>, target-devel@vger.kernel.org,
 scst-devel@lists.sourceforge.net,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <f8977250-638c-4d7d-ac0c-65f742b8d535@cybernetics.com>
 <f7f93110-bd53-4ebc-9aed-abe5de82028d@cybernetics.com>
 <20250912143615.GB624@yadro.com>
 <526d0d1b-79f1-47fd-bc44-6727898f381c@cybernetics.com>
 <20250917130641.GD624@yadro.com>
From: Tony Battersby <tonyb@cybernetics.com>
In-Reply-To: <20250917130641.GD624@yadro.com>
Content-Type: text/plain; charset=UTF-8
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1758141502
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 9842
Content-Transfer-Encoding: quoted-printable
X-ASG-Debug-ID: 1758141502-1cf43947df361b00001-ziuLRu

On 9/17/25 09:06, Dmitry Bogdanov wrote:
> On Tue, Sep 16, 2025 at 12:04:11PM -0400, Tony Battersby wrote:
>> On 9/12/25 10:36, Dmitry Bogdanov wrote:
>>> On Mon, Sep 08, 2025 at 03:02:49PM -0400, Tony Battersby wrote:
>>>> - Calling mempool_free() directly can lead to memory-use-after-free.
>>> No, it is a API contract between modules. If handle_tmr returned an e=
rror,
>>> then the caller of handle_tmr is responsible to make a cleanup.
>>> Otherwise, target module (tcm_qla2xxx) is responsible. The same rule =
is
>>> for handle_cmd.
>>>> +               qlt_xmit_tm_rsp(mcmd);
>>> qlt_xmit_tm_rsp does not free mcmd for TMF ABORT. So you introduce a =
memleak.
>> I just tested it, and there is no memleak.  qlt_build_abts_resp_iocb()
>> sets req->outstanding_cmds[h] to mcmd, and then
>> qlt_handle_abts_completion() calls ->free_mcmd after getting a respons=
e
>> from the ISP.
> ha->tgt.tgt_ops->free_mcmd(mcmd) can be called when mcmd was handled by=
 the
> target core, i.e. handle_tmr() returned 0. LIO's tcm_qla2xxx_free_mcmd =
calls
> target core function transport_generic_free_cmd to clear core's command
> object. Which in turns calls eventually mempool_free in qla2xxx.
> But when handle_tmr returned an error then there is no that core's
> command object and LIO will not free the mcmd. That is how a memleak
> will happen.

OK, I see the problem now.=C2=A0 Thanks for pointing that out.

>> The original code had a memory-use-after-free by calling
>> qlt_build_abts_resp_iocb() and then mempool_free(), and
>> then qlt_handle_abts_completion() used the freed mcmd.  I can reword t=
he
>> commit message to make this clearer.
> BTW, the easyest way to just to fix that use-after-free is to use
> qlt_24xx_send_abts_resp instead of qlt_build_abts_resp_iocb like in oth=
er
> places, where there is no mcmd and there is no need to wait the
> completion from FW.
>
> We use this patch:
>
>
> From: Dmitry Bogdanov <d.bogdanov@yadro.com>
> Date: Thu, 27 Apr 2023 15:41:55 +0300
> Subject: [PATCH] scsi: qla2xxx: fix use-after-free on ABTS_RESP sending
>
> If an abort was rejected by LIO Core qla2xxx sends ABTS_RESP with rejec=
ted
> status. But it does not save mcmd pointer which is freed right after se=
nding
> the response to FW. It leads to use-after-free at the completion from F=
W.
>
> Use a correct function to send ABTS_RESP when the abort is rejected by =
LIO Core.
>
> Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> ---
>  drivers/scsi/qla2xxx/qla_target.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/q=
la_target.c
> index b9d816b8341e..43eafdc765a3 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -2162,7 +2162,9 @@ static void qlt_do_tmr_work(struct work_struct *w=
ork)
>  		switch (mcmd->tmr_func) {
>  		case QLA_TGT_ABTS:
>  			mcmd->fc_tm_rsp =3D FCP_TMF_REJECTED;
> -			qlt_build_abts_resp_iocb(mcmd);
> +			qlt_24xx_send_abts_resp(mcmd->qpair,
> +						&mcmd->orig_iocb.abts,
> +						FCP_TMF_REJECTED, false);
>  			break;
>  		case QLA_TGT_LUN_RESET:
>  		case QLA_TGT_CLEAR_TS:


This approach could work.=C2=A0 But the handle_tmr() error path is alread=
y
significantly different than qlt_xmit_tm_rsp(); I assume because
qlt_xmit_tm_rsp() is well-maintained, whereas the handle_tmr() error
path is not.=C2=A0 So I think it makes more sense to make qlt_xmit_tm_rsp=
()
work for both cases.=C2=A0 Here is my proposed v2 patch:

Changes since v1:
- Change FCP_TMF_REJECTED to FCP_TMF_FAILED.
- Add QLA24XX_MGMT_LLD_OWNED and qlt_free_ul_mcmd().
- Improve patch description.

From: Tony Battersby <tonyb@cybernetics.com>
Date: Wed, 17 Sep 2025 15:59:23 -0400
Subject: [PATCH] scsi: qla2xxx: fix TMR failure handling

(target mode)

If handle_tmr() fails:

- The code for QLA_TGT_ABTS results in memory-use-after-free and
  double-free:
	qlt_do_tmr_work()
		qlt_build_abts_resp_iocb()
			qpair->req->outstanding_cmds[h] =3D (srb_t *)mcmd;
		mempool_free(mcmd, qla_tgt_mgmt_cmd_mempool); FIRST FREE
	qlt_handle_abts_completion()
		mcmd =3D qlt_ctio_to_cmd()
			cmd =3D req->outstanding_cmds[h];
			return cmd;
		vha  =3D mcmd->vha; USE-AFTER-FREE
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
 drivers/scsi/qla2xxx/qla_target.c | 54 +++++++++++++------------------
 drivers/scsi/qla2xxx/qla_target.h |  2 ++
 2 files changed, 24 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla=
_target.c
index 1e81582085e3..f73ecf680f52 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2017,7 +2017,6 @@ static void qlt_do_tmr_work(struct work_struct *wor=
k)
 	struct qla_hw_data *ha =3D mcmd->vha->hw;
 	int rc;
 	uint32_t tag;
-	unsigned long flags;
=20
 	switch (mcmd->tmr_func) {
 	case QLA_TGT_ABTS:
@@ -2032,34 +2031,12 @@ static void qlt_do_tmr_work(struct work_struct *w=
ork)
 	    mcmd->tmr_func, tag);
=20
 	if (rc !=3D 0) {
-		spin_lock_irqsave(mcmd->qpair->qp_lock_ptr, flags);
-		switch (mcmd->tmr_func) {
-		case QLA_TGT_ABTS:
-			mcmd->fc_tm_rsp =3D FCP_TMF_REJECTED;
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
+		mcmd->flags |=3D QLA24XX_MGMT_LLD_OWNED;
+		mcmd->fc_tm_rsp =3D FCP_TMF_FAILED;
+		qlt_xmit_tm_rsp(mcmd);
 	}
 }
=20
@@ -2246,6 +2223,19 @@ void qlt_free_mcmd(struct qla_tgt_mgmt_cmd *mcmd)
 }
 EXPORT_SYMBOL(qlt_free_mcmd);
=20
+/*
+ * If the upper layer knows about this mgmt cmd, then call its ->free_cm=
d()
+ * callback, which will eventually call qlt_free_mcmd().  Otherwise, cal=
l
+ * qlt_free_mcmd() directly.
+ */
+void qlt_free_ul_mcmd(struct qla_hw_data *ha, struct qla_tgt_mgmt_cmd *m=
cmd)
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
@@ -2338,12 +2328,12 @@ void qlt_xmit_tm_rsp(struct qla_tgt_mgmt_cmd *mcm=
d)
 			"RESET-TMR online/active/old-count/new-count =3D %d/%d/%d/%d.\n",
 			vha->flags.online, qla2x00_reset_active(vha),
 			mcmd->reset_count, qpair->chip_reset);
-		ha->tgt.tgt_ops->free_mcmd(mcmd);
+		qlt_free_ul_mcmd(ha, mcmd);
 		spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
 		return;
 	}
=20
-	if (mcmd->flags =3D=3D QLA24XX_MGMT_SEND_NACK) {
+	if (mcmd->flags & QLA24XX_MGMT_SEND_NACK) {
 		switch (mcmd->orig_iocb.imm_ntfy.u.isp24.status_subcode) {
 		case ELS_LOGO:
 		case ELS_PRLO:
@@ -2376,7 +2366,7 @@ void qlt_xmit_tm_rsp(struct qla_tgt_mgmt_cmd *mcmd)
 	 * qlt_xmit_tm_rsp() returns here..
 	 */
 	if (free_mcmd)
-		ha->tgt.tgt_ops->free_mcmd(mcmd);
+		qlt_free_ul_mcmd(ha, mcmd);
=20
 	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
 }
@@ -5717,7 +5707,7 @@ static void qlt_handle_abts_completion(struct scsi_=
qla_host *vha,
 		if (le32_to_cpu(entry->error_subcode1) =3D=3D 0x1E &&
 		    le32_to_cpu(entry->error_subcode2) =3D=3D 0) {
 			if (qlt_chk_unresolv_exchg(vha, rsp->qpair, entry)) {
-				ha->tgt.tgt_ops->free_mcmd(mcmd);
+				qlt_free_ul_mcmd(ha, mcmd);
 				return;
 			}
 			qlt_24xx_retry_term_exchange(vha, rsp->qpair,
@@ -5728,10 +5718,10 @@ static void qlt_handle_abts_completion(struct scs=
i_qla_host *vha,
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
=20
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla=
_target.h
index 15a59c125c53..73432be21461 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -965,6 +965,7 @@ struct qla_tgt_mgmt_cmd {
 	unsigned int flags;
 #define QLA24XX_MGMT_SEND_NACK	BIT_0
 #define QLA24XX_MGMT_ABORT_IO_ATTR_VALID BIT_1
+#define QLA24XX_MGMT_LLD_OWNED	BIT_2
 	uint32_t reset_count;
 	struct work_struct work;
 	uint64_t unpacked_lun;
@@ -1056,6 +1057,7 @@ extern int qlt_rdy_to_xfer(struct qla_tgt_cmd *);
 extern int qlt_xmit_response(struct qla_tgt_cmd *, int, uint8_t);
 extern int qlt_abort_cmd(struct qla_tgt_cmd *);
 extern void qlt_xmit_tm_rsp(struct qla_tgt_mgmt_cmd *);
+void qlt_free_ul_mcmd(struct qla_hw_data *ha, struct qla_tgt_mgmt_cmd *m=
cmd);
 extern void qlt_free_mcmd(struct qla_tgt_mgmt_cmd *);
 extern void qlt_free_cmd(struct qla_tgt_cmd *cmd);
 extern void qlt_async_event(uint16_t, struct scsi_qla_host *, uint16_t *=
);
--=20
2.43.0

