Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83B01A681E;
	Fri, 10 Jul 2026 00:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783643073; cv=none; b=usCXyqDRfbjY9xJM2vSSOS2xVtWoMIU9UcTVB1qtFjpP6bWiR92TnP5w65u1or+Z2Vx866qsMiPoGUNM6hBSOE83oGFrU0HsnxFG1CxIp834OuEf+FmxY+FDXKJQL9AakKz9YjUL0tHk+rlWXqBb7+AKkTeXx6rlZUQ55h1M7Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783643073; c=relaxed/simple;
	bh=1j9cQsfsDK/0QFkrvqF3ISU0W47cXjT/kv+EqPDklng=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BCkoC0GxhuJITrFqQXcL1UK29Tqegz5gE4hjatx+WE7+A0hlUmD2fEkzisgsBUMxwn5uR+EybdVpG8jbo+y2AFpScmkOAcRmtTT/HAgnzbNgMc09bLF+hCVpEQ+vzRRpOSKKyBMpA8uPlsYYp2FpvnwxkMowU8cuBqVIUOz66kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UYEAooH0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UYEAooH0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3148D1F000E9;
	Fri, 10 Jul 2026 00:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783643071;
	bh=p1dci4EoUtME2otBi8jU6WmMtv1TPe4Knf6QOX1mOWs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UYEAooH0ZbO16YLfB9O3hWq1QTwNHqRmW7VhPhCXwuyGGEy8AL7Jbi6HD6PpgflIc
	 mRFkanZbWb7A3sRrCst2vl7ZVclH581HbcZHHf78ochR5tCVADxD1faC7ADO7ws3KO
	 3Hp86QD9R2EMYzk/q6y/l7g+Zz5k5jLA/f4yvicj1RszbpQ4QIC8bRrrS7I3zrM2bv
	 aAUCQWxYz24yY+f7HO5pQGfqxjfIGMcVJFsguLq/4//jvkDU5eqcnjF9KSTbjTOVj+
	 Er6/56i0M93w+bVGzygRSJIRlR6wE4PQVY1PfbP8oUJ8xWoq1Wq2nHaTuRA/akXMIP
	 Lmy1fJHKWX06Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/2] ata: libata-scsi: terminate deferred commands on
 time out
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, dlemoal@kernel.org, linux-scsi@vger.kernel.org, cassel@kernel.org
In-Reply-To: <20260710000646.1202200-2-dlemoal@kernel.org>
References: <20260710000646.1202200-1-dlemoal@kernel.org>
 <20260710000646.1202200-2-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 10 Jul 2026 00:24:30 +0000
Message-Id: <20260710002431.3148D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] `ata_scsi_port_eh_timed_out` fails to set `ATA_PFLAG_EH_PENDING`, =
which allows requeued deferred commands to be immediately re-issued and the=
 timed-out command itself to be erroneously executed, defeating the patch's=
 optimization and causing unnecessary hardware resets.

Pre-existing issues:
- [Critical] A race condition between a deferred command's SCSI timeout and=
 its requeue completion causes the command to be silently dropped and repor=
ted as successfully completed to the block layer, leading to silent data co=
rruption.
--

--- Patch [1]: [PATCH v2 1/2] ata: libata-scsi: terminate deferred commands=
 on time out ---
commit a21f27abd9e61a32aa55fa1005071af9c225247b
Author: Damien Le Moal <dlemoal@kernel.org>

ata: libata-scsi: terminate deferred commands on time out

If a command timeout occurs while we have a deferred non-NCQ command
waiting to be issued, the SCSI EH task is never woken up. Avoid this
unnecessary EH trigger additional wait time using the eh_timed_out SCSI
host template operation to force a requeue of deferred QCs.

> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c

[ ... ]

> @@ -1694,16 +1695,19 @@ void ata_scsi_requeue_deferred_qc(struct ata_port=
 *ap)
>  	/*
>  	 * If we have a deferred qc when a reset occurs or NCQ commands fail,
>  	 * do not try to be smart about what to do with this deferred command
> -	 * and simply requeue it by completing it with DID_REQUEUE.
> +	 * and simply requeue it by completing it with DID_REQUEUE. The
> +	 * exception here is if the deferred qc timed out, in which case, we
> +	 * leave it as is as ata_scsi_cmd_error_handler() will take care of it.
>  	 */
>  	ata_for_each_link(link, ap, PMP_FIRST) {
>  		struct ata_queued_cmd *qc =3D link->deferred_qc;
> =20
> -		if (qc) {
> -			link->deferred_qc =3D NULL;
> -			cancel_work(&link->deferred_qc_work);
> -			ata_scsi_qc_done(qc, true, DID_REQUEUE << 16);
> -		}
> +		if (!qc || qc->scsicmd =3D=3D timed_out_scmd)
> +			continue;
> +
> +		link->deferred_qc =3D NULL;
> +		cancel_work(&link->deferred_qc_work);
> +		ata_scsi_qc_done(qc, true, DID_REQUEUE << 16);

[Severity: Critical]
This is a pre-existing issue, but won't the explicit invocation of this
requeue logic on every command timeout make a regression more likely?

When ata_scsi_requeue_deferred_qc() completes a deferred command using
ata_scsi_qc_done() with DID_REQUEUE, it unconditionally calls
ata_qc_free(), which clears the active flag.

If the block layer timer for this command expires concurrently,
scsi_timeout() can win the race against the scsi_done() completion. The
block layer marks the command as timed out and adds it to the SCSI EH queue.

When SCSI EH runs ata_scsi_cmd_error_handler(), it iterates over all QCs to
find the command. Since ata_qc_free() was already called and the deferred_qc
pointer was set to NULL, it won't match the deferred check.

Does this cause the loop to finish without finding the command and fall
through to the successful completion branch:

drivers/ata/libata-eh.c:ata_scsi_cmd_error_handler() {
    ...
    } else {
        /* Normal completion occurred after
         * SCSI timeout but before this point.
         * Successfully complete it.
         */
        set_host_byte(scmd, DID_OK);
        scsi_eh_finish_cmd(scmd, &ap->eh_done_q);
    }
}

Could this result in the command being reported as successfully completed to
the block layer, resulting in silent data corruption?

[ ... ]

> +static enum scsi_timeout_action
> +ata_scsi_port_eh_timed_out(struct ata_port *ap, struct scsi_cmnd *scmd)
> +{
> +	unsigned long flags;
> +
> +	/*
> +	 * We had a timeout, either for an NCQ command or for one deferred
> +	 * queued command. If we have deferred QCs and we do not release them
> +	 * immediately, we will have shost->host_failed !=3D scsi_host_busy()
> +	 * until the deferred QCs also timeout. This unnecessarilly increases
> +	 * the time it takes for scsi EH to start. Terminate all deferred QCs
> +	 * to avoid that.
> +	 */
> +	spin_lock_irqsave(ap->lock, flags);
> +	ata_scsi_requeue_deferred_qc(ap, scmd);
> +	spin_unlock_irqrestore(ap->lock, flags);

[Severity: High]
Does this function need to set ATA_PFLAG_EH_PENDING?

Because this flag is not set, ata_port_eh_scheduled() will evaluate to
false. This allows the block layer to immediately retry the requeued
commands, which __ata_scsi_queuecmd() will accept and re-defer, keeping
the host busy.

Furthermore, for the timed-out command itself (which is skipped by the
requeue logic), ata_scsi_deferred_qc_work() can run concurrently:

drivers/ata/libata-scsi.c:ata_scsi_deferred_qc_work() {
    ...
    qc =3D link->deferred_qc;
    if (qc && !ata_port_eh_scheduled(ap)) {
        WARN_ON_ONCE(ap->ops->qc_defer(qc));
        link->deferred_qc =3D NULL;
        ata_qc_issue(ap, qc);
    }
    ...
}

Since ata_port_eh_scheduled() evaluates to false, will this work item
erroneously issue the timed-out command to the hardware right as it enters
error handling?

When EH finally runs, it would find the timed-out command actively executing
in hardware instead of deferred, triggering a full port freeze and reset.
Can this defeat the patch's intended optimization of cleanly terminating the
timeout without a reset?

> +
> +	/*
> +	 * Let scsi_timeout() know that it must continue with handling the
> +	 * timeout as we in fact did not do much here.
> +	 */
> +	return SCSI_EH_NOT_HANDLED;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260710000646.1202=
200-1-dlemoal@kernel.org?part=3D1
