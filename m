Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793325080;
	b=pbTSgAex2zpzqTzaD2uuv7KBgqLVjEVl/h8zMrlZbKNQV5ogDWJI/261ABRYCW9TLPll
	 CWWVaA+jib+cEubttFymB9dqMluWpMhiCk/OKFfXHio5TKh+X9OtMO6gR7t+eu/VdbITS
	 etNZ4CUDDR3+onc4xWYTIGKnxUM6yDfJY9Wsy2ufYVvBeOg54H8qNiV7QBUJ/czWN/UL/
	 +/XwF/erb/tbTPnlZ50veIu/F03UWHZ0Ig1IgG3EzY6eomMwYrSWE8HHNk4rrsA5r863s
	 0Ih92vWovGDCpcmzD781W59WSZzknuZU7kB1azLR8a5UrzpGSIPZdHceqnI64TngZRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793325080;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ezfW0kTIA5PHgkQx11DUQmWu3ivUkuVOVr5h6sqizzk=;
	b=RLg9KpFGLQvL2J9KyQrOlgfz2hHauE+MsVCAQBbRN2B9/XBWBm/HnznQmcDMHx5BAbeo
	 PJ7lAjLO+U73AM23qvVTJ3PsYVb8nHS5sBaCGJ4JChdnPCI0eXPjDULD4Qq/CiECkesdW
	 uUnA/sfEjBed0u5B9wdwQP8PRW00CkQIH4hDQvVBwwEAiH/2X4XE17GyDLCHUghK2ab7e
	 hcX8fl3GAopW+hRwDMKfZrhLvtx6zeazaIjdBsLGTgzRVkhWAG/wUY5/MT626b7sA/HwA
	 EMxGfIW6t38Bxnpw/nUoJMo6AK9SG/8zF9Y874jxDeXsbeJ7g+NT8zd1bIuCqFSN6wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d9a6pZWp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C7D606A31A
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2026 01:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d9a6pZWp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93EE11F000C1;
	Fri, 30 Oct 2026 01:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793325079;
	bh=ezfW0kTIA5PHgkQx11DUQmWu3ivUkuVOVr5h6sqizzk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=d9a6pZWpVGK3q1CRPsKjb79iuASnQ7wh3sdEgQZU/tyTWDlF/ea8gLyVgf9Mvn5eH
	 FnGe47xS25wSnQrwk/344TU5Y8Q9QevLsQd5bAcsiD5x1t1IK+9MGccWrW9dBe4w8i
	 i5RfbqSZ/qdxXgBdT92soOLcB6wkfluymun/9DODAz9iR088Z2m53xZoQY0b41ya2l
	 fZEz602cF4a9ecAiAZH6k8ATz/Yxwz3tbx0eT65kGXrmsx1gqUjd4rK/wurvkboDnw
	 VcJLp3T2IvKYB6lywzc+zWPVNioP/XmqVWn4/FUwWvo87mSYHvD4Qsyzw7nK0SSWQH
	 awYbaCFtzQ59g==
Message-ID: <sashiko-outbox-190159@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: ufs: mcq: Reap aborted CQEs before returning
 from abort
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jeuk Kim" <jeuk20.kim@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261030011321.1868029-1-jeuk20.kim@gmail.com>
References: <20261030011321.1868029-1-jeuk20.kim@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 01:51:19 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] scsi: ufs: unguarded completion and missing outstanding_reqs clear=
 in ufshcd_clear_lu_cmds()
- [High] scsi: ufs: missing UFSHCD_LRB_COMPLETED check in ufshcd_eh_timed_o=
ut()
- [Medium] scsi: ufs: ufshcd_compl_one_cqe() clobbers cmd->result of timed-=
out commands
--

commit 54407428c294792b0ec3e920d76f745b0a9af3bc
Author: Jeuk Kim <jeuk20.kim@samsung.com>

scsi: ufs: mcq: Reap aborted CQEs before returning from abort

This commit tracks per-command driver completion via UFSHCD_LRB_COMPLETED a=
nd
waits in ufshcd_mcq_sq_cleanup() for the CQE of an aborted or reset command=
 to
be reaped before returning. If SQ cleanup times out, DMA mappings are kept
intact until host-reset cleanup releases uncompleted commands after stopping
the HBA.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index cc75384c65021..3f2b99cfd87fc 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c

[ ... ]

> @@ -6014,6 +6020,7 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int =
task_tag,
>  			(struct utp_upiu_req *)lrbp->ucd_rsp_ptr);
>  		cmd->result =3D 0;
>  	}
> +	set_bit(UFSHCD_LRB_COMPLETED, &lrbp->flags);
>  	/* Do not touch lrbp after scsi_done() has been called. */
>  	scsi_done(cmd);
>  }

[Severity: Medium]
When a command has already timed out and SCMD_STATE_COMPLETE is set on
cmd->state, should ufshcd_compl_one_cqe() avoid overwriting cmd->result (ju=
st
as ufshcd_mcq_force_compl_one() below guards set_host_byte(cmd, DID_REQUEUE)
with !test_bit(SCMD_STATE_COMPLETE, &cmd->state))?

When a SCSI command times out, scsi_timeout() sets SCMD_STATE_COMPLETE on
scmd->state and schedules scmd_eh_abort_handler(). If ufshcd_abort() returns
FAILED (for example when lrbp->req_abort_skip is set, the command is found =
in
the SQ, UFS_QUERY_TASK or UFS_ABORT_TASK fails, or ufshcd_mcq_sq_cleanup()
times out) or eh_deadline has expired, scmd_eh_abort_handler() jumps to out:
before calling set_host_byte(scmd, DID_TIME_OUT) and queues the command to
eh_cmd_q with scmd->result =3D=3D 0 (or with DID_TIME_OUT already set if a
retried command timed out a second time).

When SCSI EH then runs ufshcd_eh_device_reset_handler() ->
ufshcd_clear_lu_cmds() -> ufshcd_mcq_sq_cleanup(), or drains CQEs during ho=
st
reset via ufshcd_mcq_compl_all_cqes_lock(), or processes a late CQE interru=
pt
after an SQ cleanup timeout, ufshcd_compl_one_cqe() runs while
SCMD_STATE_COMPLETE is already set and unconditionally executes:

drivers/ufs/core/ufshcd.c:ufshcd_compl_one_cqe() {
	if (ufshcd_is_scsi_cmd(cmd)) {
		...
		cmd->result =3D ufshcd_transfer_rsp_status(hba, cmd, cqe);
		ufshcd_release_scsi_cmd(hba, cmd);
	} else {
		...
		cmd->result =3D 0;
	}
}

For an OCS_ABORTED CQE, ufshcd_transfer_rsp_status() returns DID_REQUEUE <<=
 16,
setting scmd->result to a non-zero value. Later in scsi_eh_flush_done_q():

drivers/scsi/scsi_error.c:scsi_eh_flush_done_q() {
			if (!scmd->result &&
			    !(scmd->flags & SCMD_FORCE_EH_SUCCESS))
				scmd->result |=3D (DID_TIME_OUT << 16);
			...
			scsi_finish_command(scmd);
}

Because scmd->result is now DID_REQUEUE << 16 instead of 0, !scmd->result is
false and DID_TIME_OUT is not set when finishing the command. Can this cause
passthrough/SG_IO requests and scsi_execute_cmd() callers to observe
DID_REQUEUE instead of DID_TIME_OUT, and prevent scsi_noretry_cmd() and
sd_eh_action() from matching DID_TIME_OUT?

[ ... ]

> @@ -7934,31 +7947,34 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_h=
ba *hba, struct utp_upiu_req *r
>  	return err ? : result;
>  }
> =20
> +struct ufshcd_lu_reset_info {
> +	u64 lun;
> +	int err;
> +};
> +
>  static bool ufshcd_clear_lu_cmds(struct request *req, void *priv)
>  {
>  	struct scsi_cmnd *cmd =3D blk_mq_rq_to_pdu(req);
>  	struct scsi_device *sdev =3D cmd->device;
>  	struct Scsi_Host *shost =3D sdev->host;
>  	struct ufs_hba *hba =3D shost_priv(shost);
> -	const u64 lun =3D *(u64 *)priv;
> +	struct ufshcd_lu_reset_info *reset =3D priv;
>  	const u32 tag =3D req->tag;
> +	int err;
> =20
> -	if (blk_mq_is_reserved_rq(req) || sdev->lun !=3D lun)
> +	if (blk_mq_is_reserved_rq(req) || sdev->lun !=3D reset->lun)
>  		return true;
> =20
> -	if (ufshcd_clear_cmd(hba, tag) < 0) {
> +	err =3D ufshcd_clear_cmd(hba, tag);
> +	if (err) {
> +		reset->err =3D err;
>  		dev_err(hba->dev, "%s: failed to clear request %d\n", __func__,
>  			tag);
>  		return true;
>  	}
> =20
> -	if (hba->mcq_enabled) {
> -		struct ufs_hw_queue *hwq =3D ufshcd_mcq_req_to_hwq(hba, req);
> -
> -		if (hwq)
> -			ufshcd_mcq_poll_cqe_lock(hba, hwq);
> +	if (hba->mcq_enabled)
>  		return true;
> -	}
> =20
>  	ufshcd_compl_one_cqe(hba, tag, NULL);
>  	return true;
> @@ -7972,6 +7988,7 @@ static bool ufshcd_clear_lu_cmds(struct request *re=
q, void *priv)
>   */
>  static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
>  {
> +	struct ufshcd_lu_reset_info reset =3D { .lun =3D cmd->device->lun };
>  	struct Scsi_Host *host;
>  	struct ufs_hba *hba;
>  	int err;
> @@ -7989,7 +8006,8 @@ static int ufshcd_eh_device_reset_handler(struct sc=
si_cmnd *cmd)
>  		/* clear the commands that were pending for corresponding LUN */
>  		blk_mq_tagset_busy_iter(&hba->host->tag_set,
>  					ufshcd_clear_lu_cmds,
> -					&cmd->device->lun);
> +					&reset);
> +		err =3D reset.err;
>  	}

[Severity: High]
What happens in ufshcd_clear_lu_cmds() when blk_mq_tagset_busy_iter() visit=
s a
request on reset.lun that has already completed in the driver?

blk_mq_tagset_busy_iter() visits every request where blk_mq_request_started=
()
(req->state !=3D MQ_RQ_IDLE) is true. A command on reset.lun that already
completed via ufshcd_compl_one_cqe() (setting UFSHCD_LRB_COMPLETED and call=
ing
ufshcd_release_scsi_cmd()) remains started in MQ_RQ_IN_FLIGHT if it complet=
ed
after scsi_timeout() set SCMD_STATE_COMPLETE (since scsi_done_internal()
returns early before blk_mq_complete_request(), and ufshcd_abort() then fai=
ls
and queues the command to eh_cmd_q), or in MQ_RQ_COMPLETE if it was queued =
to
eh_cmd_q via scsi_complete() -> scsi_eh_scmd_add().

Because ufshcd_clear_lu_cmds() does not check UFSHCD_LRB_COMPLETED before
calling ufshcd_clear_cmd(hba, tag):

1. In MCQ mode, now that reset.err is propagated to
   ufshcd_eh_device_reset_handler(), visiting an already-completed command =
on
   a host with UFSHCD_QUIRK_MCQ_BROKEN_RTC causes ufshcd_mcq_sq_cleanup() to
   return -ETIMEDOUT and fails the LU reset even when no command is pending=
 in
   hardware. On hosts without that quirk, ufshcd_mcq_sq_cleanup() still sto=
ps
   the hardware SQ and issues SQ_ICU for a tag that has already completed.

2. In SDB mode (!hba->mcq_enabled), ufshcd_clear_lu_cmds() neither checks
   UFSHCD_LRB_COMPLETED / hba->outstanding_reqs nor clears tag in
   hba->outstanding_reqs. For an already-completed command on reset.lun,
   ufshcd_clear_cmd() sees the doorbell bit is 0 and returns 0, and
   ufshcd_clear_lu_cmds() calls ufshcd_compl_one_cqe(hba, tag, NULL) a seco=
nd
   time, triggering a double scsi_dma_unmap() and underflowing
   hba->clk_gating.active_reqs and hba->clk_scaling.active_reqs. For a comm=
and
   that was still pending in hba->outstanding_reqs, ufshcd_clear_lu_cmds()
   clears the doorbell bit and calls ufshcd_compl_one_cqe(hba, tag, NULL)
   while leaving tag set in hba->outstanding_reqs, so a subsequent
   ufshcd_poll() call sees (~tr_doorbell & hba->outstanding_reqs) and compl=
etes
   the same tag a second time via __ufshcd_transfer_req_compl().

Should ufshcd_clear_lu_cmds() check whether the command is already completed
(and clear hba->outstanding_reqs under hba->outstanding_lock in SDB mode)
before cleaning up and completing the tag?

[ ... ]

> @@ -9653,6 +9672,7 @@ static enum scsi_timeout_action ufshcd_eh_timed_out=
(struct scsi_cmnd *scmd)
>  			set_host_byte(scmd, DID_TIME_OUT);
>  		}
> =20
> +		set_bit(UFSHCD_LRB_COMPLETED, &lrbp->flags);
>  		scsi_done(scmd);
>  	}

[Severity: High]
Can ufshcd_eh_timed_out() call ufshcd_release_scsi_cmd(hba, scmd) a second
time here because it only checks !test_bit(SCMD_STATE_COMPLETE, &scmd->stat=
e)
instead of checking UFSHCD_LRB_COMPLETED (under hwq->cq_lock in MCQ mode)?

When hba->pm_op_in_progress is true, ufshcd_eh_timed_out() runs
ufshcd_link_recovery(hba) -> ufshcd_host_reset_and_restore() before this
block. That can leave SCMD_STATE_COMPLETE clear while UFSHCD_LRB_COMPLETED =
is
already set in two cases:

1. At the start of ufshcd_host_reset_and_restore(), ufshcd_complete_request=
s()
   calls ufshcd_mcq_force_compl_one() (or __ufshcd_transfer_req_compl() in =
SDB
   mode), which releases scmd via ufshcd_release_scsi_cmd(), sets
   UFSHCD_LRB_COMPLETED, and completes scmd with DID_REQUEUE via
   scsi_done(scmd) before ufshcd_hba_enable(), ufshcd_device_init(), and
   ufshcd_probe_hba() finish. Because the host is not in SHOST_RECOVERY,
   DID_REQUEUE causes scsi_complete() -> scsi_queue_insert() to requeue the
   request (or wakes blk_execute_rq() in scsi_execute_cmd() to retry). When
   scsi_queue_rq() runs while ufshcd_host_reset_and_restore() still has
   hba->ufshcd_state =3D=3D UFSHCD_STATE_RESET, scsi_queue_rq() executes
   clear_bit(SCMD_STATE_COMPLETE, &cmd->state) and ufshcd_queuecommand()
   returns SCSI_MLQUEUE_HOST_BUSY, leaving SCMD_STATE_COMPLETE =3D=3D 0 whi=
le
   UFSHCD_LRB_COMPLETED =3D=3D 1.

2. If scmd already completed in ufshcd_compl_one_cqe() (which called
   ufshcd_release_scsi_cmd() and set UFSHCD_LRB_COMPLETED), but
   scsi_done_internal() returned early at blk_should_fake_timeout() before
   setting SCMD_STATE_COMPLETE, ufshcd_mcq_force_compl_one() during
   ufshcd_link_recovery() now sees UFSHCD_LRB_COMPLETED is set and skips sc=
md
   without setting SCMD_STATE_COMPLETE.

In both cases, when ufshcd_link_recovery(hba) returns, ufshcd_eh_timed_out()
sees !test_bit(SCMD_STATE_COMPLETE, &scmd->state) is true and calls
ufshcd_release_scsi_cmd(hba, scmd) and scsi_done(scmd) a second time,
resulting in a double scsi_dma_unmap() and active_reqs underflow.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030011321.1868=
029-1-jeuk20.kim@gmail.com?part=3D1
