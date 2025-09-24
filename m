Received: from mail.cybernetics.com (mail.cybernetics.com [72.215.153.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD55502BE
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 19:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.215.153.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758742903; cv=none; b=iDK2jfQBjBdM0vdLeocCpxEEzPmQMPv1c2jE1pMkq+J7wov9aTXFLpqgdl7oDVgZZBfxZ+7y3paeHgQC49io0xL4RCoke3Opq6MFDXFAE24+Dbob4U7AugjHqC6xTPUJ71nkgXCm9l6uoEPvmuOd8tpS9ziuRXG98exM3raJqzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758742903; c=relaxed/simple;
	bh=VV6WJ0bBd3DEi31mfyoqrOv5LFnwEkIFOa58QLSBXN4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UY4y2Br3XfaEoqmmVK7GsXZ4VEK8QBpv3XwpbVNoPaxHcdYOTknYZnVGoHx/5B5KGbJjB/ORzweM9wlEVcvb1mbw1xMMTPH46ID+2QNDX0dZiH/JcCdvSjPMCcRqiXayHabCDL17nswciazT8BonjLgH8fgU7InRSDFywoO2Os8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com; spf=pass smtp.mailfrom=cybernetics.com; dkim=fail (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b=hqM3+ZpY reason="signature verification failed"; arc=none smtp.client-ip=72.215.153.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b="hqM3+ZpY"
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id 9IHoBhx4PQdzmGIy; Wed, 24 Sep 2025 15:41:33 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
	bh=FGLLnTAVyk+mU4ndX5JVErpH7HvRLZHX0LKjnCN1Mzo=;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:Cc:To:
	Content-Language:Subject:MIME-Version:Date:Message-ID; b=hqM3+ZpYUtcJmPnm0yBM
	u5rnCSg2lWhKhC0mKXSHL9lOoTxdqvYTgSdPS82ekDhmInu16o4nmL9On0JMw5cp3asjzn3VoDxYn
	1ZD2pgnqYBFghNpnqbGX094lUiUzRSsigJnrJK2xG0M3BKZxR7Hue2U3wP3UKl8HODXrYXijrQ=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate SPEC SMTP 8.0.5)
  with ESMTPS id 14211651; Wed, 24 Sep 2025 15:41:33 -0400
Message-ID: <e8cc07cf-9bd1-41a4-bd46-44e18179154b@cybernetics.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
Date: Wed, 24 Sep 2025 15:41:32 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/15] scsi: qla2xxx: fix oops during cmd abort
Content-Language: en-US
X-ASG-Orig-Subj: Re: [PATCH 08/15] scsi: qla2xxx: fix oops during cmd abort
To: Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc: Nilesh Javali <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi <linux-scsi@vger.kernel.org>, target-devel@vger.kernel.org,
 scst-devel@lists.sourceforge.net,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <f8977250-638c-4d7d-ac0c-65f742b8d535@cybernetics.com>
 <80974286-f8ac-4eff-9439-c05fe38716b1@cybernetics.com>
 <20250911142135.GA624@yadro.com>
From: Tony Battersby <tonyb@cybernetics.com>
In-Reply-To: <20250911142135.GA624@yadro.com>
Content-Type: text/plain; charset=UTF-8
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1758742893
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 0
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 7303
Content-Transfer-Encoding: quoted-printable
X-ASG-Debug-ID: 1758742893-1cf43947df39d840001-ziuLRu

On 9/11/25 10:21, Dmitry Bogdanov wrote:
> On Mon, Sep 08, 2025 at 02:58:06PM -0400, Tony Battersby wrote:
>> (target mode)
>>
>> There is a race between the following:
>>
>> CPU 1:
>> scst_hw_pending_work_fn() ->
>> sqa_on_hw_pending_cmd_timeout() ->
>> qlt_abort_cmd() ->
>> qlt_unmap_sg()
>>
>> CPU 2:
>> qla_do_work() ->
>> qla24xx_process_response_queue() ->
>> qlt_do_ctio_completion() ->
>> qlt_unmap_sg()
>>
>> Two CPUs calling qlt_unmap_sg() on the same cmd at the same time
>> results in an oops:
>>
>> dma_unmap_sg_attrs()
>>         BUG_ON(!valid_dma_direction(dir));
>>
>> This race is more likely to happen because qlt_abort_cmd() may cause t=
he
>> hardware to send a CTIO.
>>
>> The solution is to lock cmd->qpair->qp_lock_ptr when aborting a comman=
d.
>> This makes it possible to check the cmd state and make decisions about
>> what to do without racing with the CTIO handler and other code.
>>
>> - Lock cmd->qpair->qp_lock_ptr when aborting a cmd.
>> - Eliminate cmd->cmd_lock and change cmd->aborted back to a bitfield
>>   since it is now protected by qp_lock_ptr just like all the other
>>   flags.
>> - Add another command state QLA_TGT_STATE_DONE to avoid any possible
>>   races between qlt_abort_cmd() and tgt_ops->free_cmd().
>> - Add the cmd->sent_term_exchg flag to indicate if
>>   qlt_send_term_exchange() has already been called.
>> - For SCST (scst_hw_pending_work_fn()), export qlt_send_term_exchange(=
)
>>   and qlt_unmap_sg() so that they can be called directly instead of
>>   trying to make qlt_abort_cmd() work for both HW timeout and TMR abor=
t.
>> - Add TRC_CTIO_IGNORED for scst_hw_pending_work_fn().
>>
>> Fixes: 26f9ce53817a ("scsi: qla2xxx: Fix missed DMA unmap for aborted =
commands")
> You are trying to fix that commit using its approach, but actually that
> approach is the root cause itself. It is not ok to unmap dma while that
> memory is owned by HW.
>
> We use this patch 4 years already instead of 26f9ce53817a and never
> faced with such crashes.
>
>
> From: Dmitry Bogdanov <d.bogdanov@yadro.com>
> Date: Wed, 20 Oct 2021 15:57:31 +0300
> Subject: [PATCH] scsi: qla2xxx: clear cmds after chip reset
>
> Commands sent to FW, after chip reset got stuck and never freed as FW i=
s
> not going to response to them anymore.
>
> This patch partially reverts aefed3e5548f at __qla2x00_abort_all_cmds.
>
> Fixes: aefed3e5548f ("scsi: qla2xxx: target: Fix offline port handling =
and host reset handling")
> Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>

Hey Dmitry, I want to pick up your patch and add it to my v2 patchset,
but I have made a few changes to it.=C2=A0 Do I have your permission to a=
dd
your "Co-developed-by" and "Signed-off-by" tags to the patch below?=C2=A0
(Never did this before, I think I need to ask permission.)

Compared to your patch, I changed "if (cmd->se_cmd.t_state =3D=3D
TRANSPORT_WRITE_PENDING)" to "if (cmd->state =3D=3D
QLA_TGT_STATE_NEED_DATA)" (which is the way it was originally) to work
better with SCST and added the revert of 26f9ce53817a.

I will reply to this message with the two updated v2 patches that follow
your suggestions and remove the dangerous code that you objected to.=C2=A0=
 If
you approve of them, then I will submit the entire v2 patchset, since
some of the other patches needed to be rebased.

Thanks for your reviews!
Tony

From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH] scsi: qla2xxx: clear cmds after chip reset

Commit aefed3e5548f ("scsi: qla2xxx: target: Fix offline port handling
and host reset handling") caused two problems:

1. Commands sent to FW, after chip reset got stuck and never freed as FW
   is not going to respond to them anymore.

2. BUG_ON(cmd->sg_mapped) in qlt_free_cmd().  Commit 26f9ce53817a
   ("scsi: qla2xxx: Fix missed DMA unmap for aborted commands")
   attempted to fix this, but introduced another bug under different
   circumstances when two different CPUs were racing to call
   qlt_unmap_sg() at the same time: BUG_ON(!valid_dma_direction(dir)) in
   dma_unmap_sg_attrs().

So revert "scsi: qla2xxx: Fix missed DMA unmap for aborted commands" and
partially revert "scsi: qla2xxx: target: Fix offline port handling and
host reset handling" at __qla2x00_abort_all_cmds.

Fixes: aefed3e5548f ("scsi: qla2xxx: target: Fix offline port handling an=
d host reset handling")
Fixes: 26f9ce53817a ("scsi: qla2xxx: Fix missed DMA unmap for aborted com=
mands")
Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---
 drivers/scsi/qla2xxx/qla_os.c     | 20 ++++++++++++++++++--
 drivers/scsi/qla2xxx/qla_target.c |  5 +----
 drivers/scsi/qla2xxx/qla_target.h |  1 +
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
index f0b77f13628d..739137ddfd68 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1875,10 +1875,26 @@ __qla2x00_abort_all_cmds(struct qla_qpair *qp, in=
t res)
 					continue;
 				}
 				cmd =3D (struct qla_tgt_cmd *)sp;
-				cmd->aborted =3D 1;
+
+				if (cmd->sg_mapped)
+					qlt_unmap_sg(vha, cmd);
+
+				if (cmd->state =3D=3D QLA_TGT_STATE_NEED_DATA) {
+					cmd->aborted =3D 1;
+					cmd->write_data_transferred =3D 0;
+					cmd->state =3D QLA_TGT_STATE_DATA_IN;
+					ha->tgt.tgt_ops->handle_data(cmd);
+				} else {
+					ha->tgt.tgt_ops->free_cmd(cmd);
+				}
 				break;
 			case TYPE_TGT_TMCMD:
-				/* Skip task management functions. */
+				/*
+				 * Currently, only ABTS response gets on the
+				 * outstanding_cmds[]
+				 */
+				ha->tgt.tgt_ops->free_mcmd(
+					(struct qla_tgt_mgmt_cmd *) sp);
 				break;
 			default:
 				break;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla=
_target.c
index b700bfc642b3..2abdb8ce0302 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2447,7 +2447,7 @@ static int qlt_pci_map_calc_cnt(struct qla_tgt_prm =
*prm)
 	return -1;
 }
=20
-static void qlt_unmap_sg(struct scsi_qla_host *vha, struct qla_tgt_cmd *=
cmd)
+void qlt_unmap_sg(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd)
 {
 	struct qla_hw_data *ha;
 	struct qla_qpair *qpair;
@@ -3795,9 +3795,6 @@ int qlt_abort_cmd(struct qla_tgt_cmd *cmd)
=20
 	spin_lock_irqsave(&cmd->cmd_lock, flags);
 	if (cmd->aborted) {
-		if (cmd->sg_mapped)
-			qlt_unmap_sg(vha, cmd);
-
 		spin_unlock_irqrestore(&cmd->cmd_lock, flags);
 		/*
 		 * It's normal to see 2 calls in this path:
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla=
_target.h
index 15a59c125c53..c483966d0a84 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -1058,6 +1058,7 @@ extern int qlt_abort_cmd(struct qla_tgt_cmd *);
 extern void qlt_xmit_tm_rsp(struct qla_tgt_mgmt_cmd *);
 extern void qlt_free_mcmd(struct qla_tgt_mgmt_cmd *);
 extern void qlt_free_cmd(struct qla_tgt_cmd *cmd);
+extern void qlt_unmap_sg(struct scsi_qla_host *vha, struct qla_tgt_cmd *=
cmd);
 extern void qlt_async_event(uint16_t, struct scsi_qla_host *, uint16_t *=
);
 extern void qlt_enable_vha(struct scsi_qla_host *);
 extern void qlt_vport_create(struct scsi_qla_host *, struct qla_hw_data =
*);
--=20
2.43.0


