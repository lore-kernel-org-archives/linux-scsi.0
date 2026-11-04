Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793786925;
	b=iLPpgKB6rvjV+YUhy0bgYSVnRrUFTTCNTiMs1vdG0nvrKc/Q6NoiP16ulx73UfMcjBLO
	 o5aSFF0N8YdoIYszLdZmU+A9+xG9NSklbAiPgg2mKCxhdBZ2wtIPBRvGjc7Eo9XeNxDhv
	 ehqDq4w2dSnpb+u/FacWnB+LgURp9Uxhr2SgH8JZQAIe9hAO9Wxf/Zxqf7fDU+nAeARLa
	 8mH7ym+XFRGHMFeEE8xlg+QGzFCAgKlsjOP2aOdWC12oKPEH6XbQrk/OgMCALOaebfAIS
	 sepBBMrrYYQ3uBzTLACVVy1fnO7dfoHW+xxHZ7fITp5tug8xhqA6vVirohxoBEvsjgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793786925;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=bE/pwDRc2r+YrNMGE4xA1pKIJKsP/W+IX+PWi2kt8YY=;
	b=OdFMhreNiV3ZLNWSQReeMfk7T3SNJj96HjBJMToPGbhch/vsAqkAhI7lm3b2exrXhTyW
	 zYj9ympKjjtesC36vlTEOw/lKR6P6pNIKSJFbATRGqAoYZNR1pFZLFC6xzmcws6mqsUcb
	 mpooBU7OGQaCzxM9jsjyUGAm11Ees8CW24lOdwNw4a2b2gqxvU4xUMYYtQeOmdhCkFAyQ
	 f7MI7dYDUd/usd2dkmvmSYO6UQa3LxaOAhZpMqS06egyMRaG3v06A6qIDxVzeHmgFUxSq
	 jpZ/RDjUVvDYs8CbL3l2plkZo3Jk6eSizErIY4s0XGo97tWoyOtngHFUPhyFr8c+3pA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eL3gyWbn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E252C606A31B
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 10:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eL3gyWbn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD031F000C1;
	Wed,  4 Nov 2026 10:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793786924;
	bh=bE/pwDRc2r+YrNMGE4xA1pKIJKsP/W+IX+PWi2kt8YY=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=eL3gyWbnaE20nLNKHPtu5uqT+801QuHQMG+sE1HlVtbpiHBdQnklDY2FsSw/NrkHV
	 0rk62Frlw09kpm2Uaw/ywswxEZif2rIEHkWjkikg/OKCUSV+5f6VHWND2R1CN/oxnA
	 r65/RcV8j8qoy3NcFrWiBjiZ/bJFbkvcz/tO+DQok1Kt6+8Zl8G8gCPaHJoIel5VCT
	 Pz0bzxuzYYp4rBY6JH0UkJaZxI5Ji+T0dzL3tXoVupMZyDogn5+TYdKWzfIFYj/0p2
	 jhCw3+H3Bz+EDEjw8nlusff1BbNFh5yXsztxrpDuRZldgiEXE1IApPtkyuxYmbwF6x
	 2LfCHTRmIhnfw==
Message-ID: <sashiko-outbox-197046@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 2/2] ufs: mcq: poll OCS after sq cleanup for device
 management commands
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kiwoong Kim" <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20261104094914.180788-3-kwmad.kim@samsung.com>
References: <20261104094914.180788-1-kwmad.kim@samsung.com>
 <CGME20261104094925epcas2p1f25905de00c2548e1e1349fba5f18551@epcas2p1.samsung.com>
 <20261104094914.180788-3-kwmad.kim@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 10:08:44 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] ufs: mcq: race between OCS poll in ufshcd_mcq_sq_cleanup() and CQE=
 completion
--

commit ed08af75bc0d7555962a67f5dd8315bda77ee7a4
Author: Kiwoong Kim <kwmad.kim@samsung.com>

ufs: mcq: poll OCS after sq cleanup for device management commands

This commit extends ufshcd_mcq_sq_cleanup() to poll the UTRD header.ocs
field for reserved (device management) requests after SQ_CUS is set, so
that cleanup waits for the OCS update before returning.

> diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
> index 25e392f8ede2b..8857775586311 100644
> --- a/drivers/ufs/core/ufs-mcq.c
> +++ b/drivers/ufs/core/ufs-mcq.c
> @@ -613,6 +613,24 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int t=
ask_tag)
>  			 __func__, id,
>  			 FIELD_GET(SQ_ICU_ERR_CODE_MASK, readl(reg)));
> =20
> +	/*
> +	 * For device management commands, there is no order guaranteed between
> +	 * OCS update and CUS update, which is why we need to wait here. SCSI
> +	 * commands are excluded because the OCS in their UTRD is not updated
> +	 * from the CQE.
> +	 */
> +	if (!err && blk_mq_is_reserved_rq(rq)) {
> +		enum utp_ocs ocs;
> +
> +		err =3D read_poll_timeout(READ_ONCE, ocs,
> +					ocs !=3D OCS_INVALID_COMMAND_STATUS, 20,
> +					MCQ_POLL_US, false,
> +					lrbp->utr_descriptor_ptr->header.ocs);
> +		if (err)
> +			dev_err(hba->dev, "%s: OCS not updated. hwq=3D%d, tag=3D%d err=3D%d\n=
",
> +				__func__, id, task_tag, err);
> +	}

[Severity: High]
Can polling lrbp->utr_descriptor_ptr->header.ocs without synchronizing
with hwq->cq_lock race with ufshcd_compl_one_cqe()?

In MCQ mode, the UFS controller writes the CQE to hwq->cqe_base_addr
rather than updating lrbp->utr_descriptor_ptr->header.ocs in host memory.
The UTRD header.ocs field is updated in software by the CQ completion
handler under hwq->cq_lock:

drivers/ufs/core/ufshcd.c:ufshcd_compl_one_cqe() {
	...
	if (blk_mq_is_reserved_rq(scsi_cmd_to_rq(cmd))) {
		if (cqe) {
			ocs =3D cqe->overall_status & MASK_OCS;
			lrbp->utr_descriptor_ptr->header.ocs =3D ocs;
		} else {
			ocs =3D lrbp->utr_descriptor_ptr->header.ocs;
		}
		ufshcd_add_query_upiu_trace(
			hba,
			ocs =3D=3D OCS_SUCCESS ? UFS_QUERY_COMP : UFS_QUERY_ERR,
			(struct utp_upiu_req *)lrbp->ucd_rsp_ptr);
		cmd->result =3D 0;
	}
	/* Do not touch lrbp after scsi_done() has been called. */
	scsi_done(cmd);
}

Because ufshcd_compl_one_cqe() writes lrbp->utr_descriptor_ptr->header.ocs
before tracing lrbp->ucd_rsp_ptr, setting cmd->result =3D 0, and calling
scsi_done(cmd), ufshcd_mcq_sq_cleanup() can observe the updated ocs and
return 0 to scmd_eh_abort_handler() while ufshcd_compl_one_cqe() is still
running on another CPU.

When scmd_eh_abort_handler() receives SUCCESS from the abort path:

drivers/scsi/scsi_error.c:scmd_eh_abort_handler() {
	...
	set_host_byte(scmd, DID_TIME_OUT);
	...
	scsi_finish_command(scmd);
}

Two races can then occur against the in-progress ufshcd_compl_one_cqe():

1. If ufshcd_compl_one_cqe() executes cmd->result =3D 0 after
   scmd_eh_abort_handler() calls set_host_byte(scmd, DID_TIME_OUT), the
   timeout status in cmd->result is overwritten with 0 before
   scsi_io_completion() inspects it, causing blk_execute_rq() in
   ufshcd_issue_dev_cmd() to see BLK_STS_OK instead of a timeout.

2. If scsi_finish_command() completes the request first,
   ufshcd_exec_dev_cmd() releases the reserved command via
   ufshcd_put_dev_mgmt_cmd() and a retry loop such as
   ufshcd_query_flag_retry() can immediately reallocate the single
   reserved request and submit the retry via blk_execute_rq(), which
   clears SCMD_STATE_COMPLETE in scsi_prepare_cmd(). When the delayed
   ufshcd_compl_one_cqe() from the first command then reaches
   scsi_done(cmd), it can prematurely complete the newly submitted retry
   command while it is still in flight in hardware.

Should ufshcd_mcq_sq_cleanup() synchronize with hwq->cq_lock (or poll CQEs
under hwq->cq_lock) so that ufshcd_compl_one_cqe() has completely finished
before cleanup returns?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104094914.1807=
88-1-kwmad.kim@samsung.com?part=3D2
