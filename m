Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7261B34DCD2;
	Mon, 20 Jul 2026 07:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784532668; cv=none; b=pOTHDYMIOwwbgi0a0+OVKWrikkWVIEqIPplN3lABcWJ+3c+x24w2iWX8dGiNc0+LyjST+W5Z+yOBAckpwuAVQP8wclHru3+NdMpFf4pbyii47msUyAo1G/YqLbKCwJgfc60OKDatnUsvxE5Y4/pnIiNQKmJYfZythMkbrUEcg8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784532668; c=relaxed/simple;
	bh=kt1t6xyGOY39sCn0LMPtHJAboLW5Eq4fJ9o5owf6NkE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Gzs1Q3FMcEN1Boxmtddd4Por1PinVMI9SQbgJ9T3gctmE7ErFN3Hso+pDhVgdGgoH2lpsNoGfF9TMaSEoGXK1TCxvJR4Y4CQC6T7mftgWWGbfBKm80vn6X09+joh650yuMIGrkcBiqptH+SOvAh0JUJa+f51zD28fqwDbp7IBro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cS0CBZZh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cS0CBZZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10121F000E9;
	Mon, 20 Jul 2026 07:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784532667;
	bh=y2OtsMfTVSfHkSe6Yz51R3q/1MikUGvBUtV0G3di9zk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cS0CBZZhWxtjtwJUJlrozZdEEaQPu8zaYv+lTAtoPdiubWUPehPlzGLwH6tQ6fZ0d
	 xdN+wRa0zXBmVdYuoGk5tVF1W9Mp40a01KTVcpMcqhol/J0jQ86MPUm7KTJh/v70yf
	 KOKUVpPjpptoj7HLxiMcPsSGdQv8zb127QU3hN+fDDhzCopjlje5L9sfjIQXWRcOO6
	 RQ74Bcc3MlQKBWLfoRzVA3ieiJUMeeVHPs8CFHcYq6BtlGiMHFo0KkJKXQYVJWgf/n
	 gKSkLsvsYh7PwG3fhWC0h8b0Oz3S4uuJcQq9Av1Oosy8M+FycPbD1/LPNsfXMbVPSp
	 Ei7yAm7xwjuwQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 1/2] ata: libata-scsi: terminate deferred commands on
 time out
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: dlemoal@kernel.org, cassel@kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260720071450.1877625-2-dlemoal@kernel.org>
References: <20260720071450.1877625-1-dlemoal@kernel.org>
 <20260720071450.1877625-2-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 07:31:06 +0000
Message-Id: <20260720073106.E10121F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] A race condition between block layer timeout work and the SCSI EH =
thread causes deferred QCs to fail permanently, resulting in spurious I/O e=
rrors.
--

--- Patch [1]: [PATCH v6 1/2] ata: libata-scsi: terminate deferred commands=
 on time out ---
commit 65621fb40c8a19c964f38c70891c67cb0a3f9251
Author: Damien Le Moal <dlemoal@kernel.org>
Subject: ata: libata-scsi: terminate deferred commands on time out

If a command timeout occurs while we have deferred non-NCQ commands
waiting to be issued, the SCSI EH task is not immediately woken up as the
waiting deferred commands are never issued nor completed. Avoid this
unnecessary SCSI EH task wake-up additional time by scheduling a retry of
all waiting deferred QCs, using the eh_timed_out SCSI host template
operation.

> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 5868526301a2b..b02b4ca5c09e2 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c

[ ... ]

> -void ata_scsi_requeue_deferred_qc(struct ata_port *ap)
> +void ata_scsi_requeue_deferred_qc(struct ata_port *ap,
> +				  struct scsi_cmnd *timedout_scmd)
>  {
> +	struct ata_queued_cmd *qc;
>  	struct ata_link *link;
> =20
>  	lockdep_assert_held(ap->lock);
> =20
>  	/*
> -	 * If we have a deferred qc when a reset occurs or NCQ commands fail,
> -	 * do not try to be smart about what to do with this deferred command
> -	 * and simply requeue it by completing it with DID_REQUEUE.
> +	 * Trigger EH for any deferred qc, to either retry them or handle one
> +	 * that timed out.
>  	 */
>  	ata_for_each_link(link, ap, PMP_FIRST) {
> -		struct ata_queued_cmd *qc =3D link->deferred_qc;
> +		qc =3D link->deferred_qc;
> +		if (!qc)
> +			continue;
> =20
> -		if (qc) {
> -			link->deferred_qc =3D NULL;
> -			cancel_work(&link->deferred_qc_work);
> +		link->deferred_qc =3D NULL;
> +		cancel_work(&link->deferred_qc_work);
> +
> +		if (!timedout_scmd) {
> +			/*
> +			 * We are retrying due to some error. Complete the
> +			 * request and ask for a requeue. In this case, since EH
> +			 * was scheduled already, the block layer attempting to
> +			 * re-issue the command immediately will not lead to the
> +			 * device being kept busy, thus allowing SCSI EH task to
> +			 * run.
> +			 */
>  			ata_scsi_qc_done(qc, true, DID_REQUEUE << 16);
> +			continue;
>  		}
> +
> +		/*
> +		 * We are being called from scsi_timeout(). scsi_eh_scmd_add()
> +		 * will add the command to eh_work_q and it will be handled by
> +		 * ata_scsi_cmd_error_handler(). So here, we only need to
> +		 * indicate if we want a retry if the command did not timeout.
> +		 */
> +		if (qc->scsicmd !=3D timedout_scmd)
> +			qc->flags |=3D ATA_QCFLAG_RETRY;
> +
> +		/*
> +		 * Schedule EH, but set EH pending on the port so that we do not
> +		 * reenter this function from ata_eh_set_pending() with
> +		 * timedout_scmd being NULL and erroneously retry deferred QCs
> +		 * that have timed out on other links.
> +		 */
> +		ap->pflags |=3D ATA_PFLAG_EH_PENDING;
> +		ata_qc_schedule_eh(qc);

[Severity: High]
Does this introduce a race condition between the block layer timeout work a=
nd
the SCSI EH thread that could cause deferred QCs to fail permanently with
spurious I/O errors?

When a command times out, ata_scsi_eh_timed_out() calls this and triggers
ata_qc_schedule_eh() on deferred QCs. This calls blk_abort_request(), which
schedules the block layer timeout_work asynchronously.

Meanwhile, the original timed-out command is added to eh_cmd_q and immediat=
ely
wakes up the SCSI EH thread. If the SCSI EH thread processes eh_cmd_q in
ata_scsi_cmd_error_handler() before the asynchronous timeout_work for the
deferred QCs runs, ata_scsi_cmd_error_handler() will miss the deferred QCs
since they aren't in eh_work_q yet:

drivers/ata/libata-eh.c:ata_scsi_cmd_error_handler() {
    ...
	list_for_each_entry_safe(scmd, tmp, eh_work_q, eh_entry) {
        /* deferred QCs skipped if timeout_work hasn't added them yet */
    ...
}

Later in the EH process, ata_eh_finish() will process these missed QCs
(because ATA_QCFLAG_EH is set), calling ata_eh_qc_retry() which frees the qc
without completing the block request.

When the delayed timeout_work finally adds the deferred QCs to SCSI EH, a
subsequent EH run will fail to find their freed qcs, fall back to the normal
completion path, set scmd->retries =3D scmd->allowed, and complete them with
DID_TIME_OUT. This prevents retries and fails the commands permanently.

>  	}
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720071450.1877=
625-1-dlemoal@kernel.org?part=3D1
