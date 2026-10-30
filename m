Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793350089;
	b=orMvqNnobWyNDsUkU2XfOep93tQPHNgFmdm44FlLPzN0nM8RzlsbGo7TY5i4FO5lEf3n
	 1rz6YEArwauMC/GRWiOT9YyaHSAmlwYxXHX87WI8S0fA2lNZGynYAZnhiOXWuYk+1rmPg
	 idztfk62dwQv+9P0naBU2/Tb2sD45rKyFPBDqw8S2RyfisRu7AeW3Ko2YA6csf9QOQ8oX
	 GgeXlxwYUDnpqWyrzqbVP8CXrAsR5DyQv5wdmSEmLdIwNRKuLUXmr8potxq9luLquxEk5
	 Uxci+5n7TUZ2CKd6gaRUJbZXWlOrYEMEx3PlK/HcMk+Xipp/rvAlvPpmHi42FEo4oJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793350089;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=+2bjoUByJAlqnwuFf3MJ95frf4hMv8XzJJp/ROmm0P8=;
	b=eIjSqx4vFo91qpbtfh1nazYvK/XNrJ93zuon3I5VBprkFjze4BmzTzUXKPrKUR1zemSc
	 Nbr8l1Z/CCejxYjPt2vB5rJnbrNNher5z84WXzKctfzocnxYOdlQzTzVKm5Gyk5UO7M5r
	 ArkMn++2vD4k6oOPxwsg0hckB/NTLKVTT1HRFRd7F3CeTTnhfZ6MIgafF0cSmndhvgMfh
	 PI4scYZJki3fTSvVhT0i4dys5QRGap/xz98YSQt0IOSDVFIRVLWWbkYVr1gQ5XXB8v+BN
	 oVXpFODNSwwanfpKBcXI/OW32BqUo+4ighnSs1ZFtD6exWzwj70Vg3Gfuxf8bD5A6VQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B+2pEo3i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77DB0606A31C
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2026 08:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B+2pEo3i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE481F00A02;
	Fri, 30 Oct 2026 08:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793350089;
	bh=+2bjoUByJAlqnwuFf3MJ95frf4hMv8XzJJp/ROmm0P8=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=B+2pEo3ixF87pe/TTiE4dHC6+WRkW3GtjwbmF82/1deIjMV8eKDLiSLa19EFINy4R
	 cd993ADG4THUvNYy5zDsTUbfMBUSlvEA24gM2cmPq/cJ6r4+LbdQ0UX3cSjzl7kgzJ
	 LR1gaBnfXONxg/xHOI4vDEntkw5p/IyE+iZqPX/3X+Dg33xFug7lfbJ4+SdHZRA3yM
	 dz1snptzVnjYVan2ISae38dG0IuCmPMEoeYxo8YDL7hoUi4Fs4TOgtJ5UyqDY/jJ6H
	 es8nKP1Pk55YEidoSrJS/vzsKlhPZKaUd/ot2jU09odbZCRpBEc9y4JmcPTpdQo9AP
	 /1rQFIGoQxhIw==
Message-ID: <sashiko-outbox-190714@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1] ufs: mcq: fix dev cmd abort path and add OCS poll
 after sq cleanup
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kiwoong Kim" <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20261030083311.602909-1-kwmad.kim@samsung.com>
References: <CGME20261030083321epcas2p2872d81c94fed72e685d580c0fc5d4bb6@epcas2p2.samsung.com>
 <20261030083311.602909-1-kwmad.kim@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 08:48:08 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] ufs: mcq: polling unupdated header.ocs in ufshcd_mcq_sq_cleanup() =
breaks SCSI cleanup
- [High] ufs: mcq: ufshcd_mcq_sq_cleanup() treats OCS_ABORTED as -ETIMEDOUT=
 and wedges EH
--

commit 1f3e43d50c19634050bcd7e46bc9f38e9ee41667
Author: Kiwoong Kim <kwmad.kim@samsung.com>

ufs: mcq: fix dev cmd abort path and add OCS poll after sq cleanup

This commit skips task management commands in ufshcd_try_to_abort_task()
when aborting reserved device management commands and goes directly to
ufshcd_clear_cmd(). It also adds a polling loop in ufshcd_mcq_sq_cleanup()
waiting for header.ocs to change from OCS_INVALID_COMMAND_STATUS after
SQ_CUS is set, returning -ETIMEDOUT if ocs is non-zero.

> diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
> index 25e392f8ede2b..1a38aecd126b3 100644
> --- a/drivers/ufs/core/ufs-mcq.c
> +++ b/drivers/ufs/core/ufs-mcq.c
> @@ -607,12 +607,34 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int =
task_tag)
>  	if (err)
>  		dev_err(hba->dev, "%s: failed. hwq=3D%d, tag=3D%d err=3D%d\n",
>  			__func__, id, task_tag, err);
> -	else
> +	else {
> +		enum utp_ocs ocs;
> +		ktime_t start =3D ktime_get();
> +
>  		dev_info(hba->dev,
>  			 "%s, hwq %d: cleanup return code (RTC) %ld\n",
>  			 __func__, id,
>  			 FIELD_GET(SQ_ICU_ERR_CODE_MASK, readl(reg)));
> =20
> +		/*
> +		 * There is no order guaranteed between OCS update and CUS update,
> +		 * which is why we need to wait here.
> +		 */
> +		do {
> +			unsigned long flags;
> +
> +			spin_lock_irqsave(&hwq->cq_lock, flags);
> +			ocs =3D READ_ONCE(lrbp->utr_descriptor_ptr->header.ocs);
> +			spin_unlock_irqrestore(&hwq->cq_lock, flags);
> +			if (ocs !=3D OCS_INVALID_COMMAND_STATUS)
> +				break;
> +			usleep_range(20, 50);
> +		} while (ktime_us_delta(ktime_get(), start) < MCQ_POLL_US);

[Severity: High]
Does this loop ever see lrbp->utr_descriptor_ptr->header.ocs change when
ufshcd_mcq_sq_cleanup() is called for a regular SCSI I/O command?

In MCQ mode, hardware writes the completion status into cqe->overall_status
in the completion queue entry rather than lrbp->utr_descriptor_ptr->header.=
ocs.
In software, ufshcd_compl_one_cqe() only copies cqe->overall_status into
lrbp->utr_descriptor_ptr->header.ocs when !ufshcd_is_scsi_cmd(cmd):

drivers/ufs/core/ufshcd.c:ufshcd_compl_one_cqe() {
	if (ufshcd_is_scsi_cmd(cmd)) {
		if (unlikely(ufshcd_should_inform_monitor(hba, cmd)))
			ufshcd_update_monitor(hba, cmd);
		ufshcd_add_command_trace(hba, cmd, UFS_CMD_COMP);
		cmd->result =3D ufshcd_transfer_rsp_status(hba, cmd, cqe);
		ufshcd_release_scsi_cmd(hba, cmd);
	} else {
		if (cqe) {
			ocs =3D cqe->overall_status & MASK_OCS;
			lrbp->utr_descriptor_ptr->header.ocs =3D ocs;
		} else {
			ocs =3D lrbp->utr_descriptor_ptr->header.ocs;
		}
		...
	}
}

In addition, callers such as ufshcd_clear_lu_cmds() and ufshcd_abort_all()
only call ufshcd_mcq_poll_cqe_lock() after ufshcd_clear_cmd() ->
ufshcd_mcq_sq_cleanup() returns 0, and poll queues or controllers with
UFSHCD_QUIRK_MCQ_BROKEN_INTR do not process CQEs via interrupts while this
loop is waiting.

For any SCSI command cleaned up via ufshcd_mcq_abort() ->
ufshcd_try_to_abort_task() -> ufshcd_clear_cmd() -> ufshcd_mcq_sq_cleanup()
or ufshcd_clear_lu_cmds() -> ufshcd_clear_cmd() -> ufshcd_mcq_sq_cleanup(),
won't header.ocs remain OCS_INVALID_COMMAND_STATUS for the full 500 ms
(MCQ_POLL_US) while holding hwq->sq_mutex with the SQ stopped, and then
always fail with -ETIMEDOUT?

> +
> +		if (ocs)
> +			err =3D -ETIMEDOUT;
> +	}

[Severity: High]
When SQ cleanup (SQ_ICU) aborts an outstanding transfer request, the host
controller posts a CQE with overall_status set to OCS_ABORTED (0x06) rather
than OCS_SUCCESS (0x00). Once ufshcd_compl_one_cqe() writes OCS_ABORTED to
lrbp->utr_descriptor_ptr->header.ocs, the poll loop exits because ocs is no
longer OCS_INVALID_COMMAND_STATUS, and this check then sets err =3D -ETIMED=
OUT
because ocs is non-zero.

When a reserved device management command times out in ufshcd_exec_dev_cmd()
-> ufshcd_issue_dev_cmd() -> blk_execute_rq(), the timeout path runs:

scsi_timeout()
  -> scmd_eh_abort_handler()
    -> ufshcd_abort()
      -> ufshcd_mcq_abort()
        -> ufshcd_try_to_abort_task()
          -> ufshcd_clear_cmd()
            -> ufshcd_mcq_sq_cleanup()

In ufshcd_mcq_abort(), a non-zero return from ufshcd_try_to_abort_task() is
treated as an abort failure:

drivers/ufs/core/ufs-mcq.c:ufshcd_mcq_abort() {
	...
	err =3D ufshcd_try_to_abort_task(hba, tag);
	if (err) {
		dev_err(hba->dev, "%s: device abort failed %d\n", __func__, err);
		lrbp->req_abort_skip =3D true;
		return FAILED;
	}
	return SUCCESS;
}

When ufshcd_mcq_abort() returns FAILED to scmd_eh_abort_handler(), the
command is not completed for the caller to retry; instead,
scmd_eh_abort_handler() passes the reserved command to scsi_eh_scmd_add(),
which triggers WARN_ON_ONCE(!test_bit(SCMD_STATE_INFLIGHT, &scmd->state))
and escalates to SCSI error recovery while the caller is still blocked insi=
de
blk_execute_rq() holding hba->dev_cmd.lock and hba->clk_scaling_lock via
ufshcd_dev_man_lock().

Should ufshcd_mcq_sq_cleanup() only return -ETIMEDOUT when ocs is still
OCS_INVALID_COMMAND_STATUS after the poll (rather than on any non-zero ocs
such as OCS_ABORTED), so that a successful SQ cleanup returns 0?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030083311.6029=
09-1-kwmad.kim@samsung.com?part=3D1
