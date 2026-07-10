Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77563EFFDB;
	Fri, 10 Jul 2026 08:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783672768; cv=none; b=S3UaYN+a6E2gYwCOK20RfOe3YG4s6eCR/MPk7xLtFHByMyHFBvW9XKtPH05zJ8Kx/SpVnqzqUvhsl7B+X7thai1gf7auvKZ8W1Ss1xfSi2WcxD892tskKxh7fq6c9S5ntpfItQmG4T2T16bR3tioVfjfT+6xjHfbf+1LJ902Ja0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783672768; c=relaxed/simple;
	bh=XwVuQT60fomAn1ozvyEthH2cFlqdZKqdBU1pnIbwH6I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TLZSHh07/wIjuO7oy3QpGDVjA6rlo93PxaQpx3LYSoEhFXm2O9xYK3WLLPHTOqkdvBdS6BnW6DFuYD+rtid9MZo73U5Z8pgpSwgDGjp4/fwyfVdVHX4fwPQ6vc6XI9byJLlNUTQdH54buC+rJxtpjAkvdtmzU/TZIWIZuBoTh/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vhxmk34W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vhxmk34W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5778C1F000E9;
	Fri, 10 Jul 2026 08:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783672767;
	bh=aipSMyElu/STpX86lsvYZ6lNpuc1IgPZFBvqUAzNuUg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Vhxmk34WB5zcYBDnZw3u7X7CtTXaN+Wy/EEbOg1rup02GiHQ2qCwiqtrkKhKzYudA
	 tBVAynyTWrbu1NOsvUy+a64x5lCp8V1+Kvz5zu5erXEgV+woSh5/I+tMjKiJwEDV2H
	 FxANU895EAY0hNb8oE8xdG1EY1bMZSNiXqQs5JwCkE9u/hlYizTtlHF4PfLHs1jQ4I
	 7YFK1Lv3TKR+ldNf2uOgbjIAnyWvpUPMDzHEMmvK0thq5O7VqkFaKm3x4ikajQ0UL5
	 Qb2RVWSPgFvqNNFielmzcp3dLhhRuG74yRtUpeuTJjk1qGLX/9ulpHprodLaHu7Z3y
	 K0zhF4FYTAF4A==
Date: Fri, 10 Jul 2026 10:39:23 +0200
From: Niklas Cassel <cassel@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 1/2] ata: libata-scsi: terminate deferred commands on
 time out
Message-ID: <alCvu2_Z4YVa6AeS@fedora>
References: <20260710000646.1202200-1-dlemoal@kernel.org>
 <20260710000646.1202200-2-dlemoal@kernel.org>
 <20260710002431.3148D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710002431.3148D1F000E9@smtp.kernel.org>

On Fri, Jul 10, 2026 at 12:24:30AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> 
> New issues:
> - [High] `ata_scsi_port_eh_timed_out` fails to set `ATA_PFLAG_EH_PENDING`, which allows requeued deferred commands to be immediately re-issued and the timed-out command itself to be erroneously executed, defeating the patch's optimization and causing unnecessary hardware resets.
> 
> Pre-existing issues:
> - [Critical] A race condition between a deferred command's SCSI timeout and its requeue completion causes the command to be silently dropped and reported as successfully completed to the block layer, leading to silent data corruption.
> --
> 
> --- Patch [1]: [PATCH v2 1/2] ata: libata-scsi: terminate deferred commands on time out ---
> commit a21f27abd9e61a32aa55fa1005071af9c225247b
> Author: Damien Le Moal <dlemoal@kernel.org>
> 
> ata: libata-scsi: terminate deferred commands on time out
> 
> If a command timeout occurs while we have a deferred non-NCQ command
> waiting to be issued, the SCSI EH task is never woken up. Avoid this
> unnecessary EH trigger additional wait time using the eh_timed_out SCSI
> host template operation to force a requeue of deferred QCs.
> 
> > diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> > --- a/drivers/ata/libata-scsi.c
> > +++ b/drivers/ata/libata-scsi.c
> 
> [ ... ]
> 
> > @@ -1694,16 +1695,19 @@ void ata_scsi_requeue_deferred_qc(struct ata_port *ap)
> >  	/*
> >  	 * If we have a deferred qc when a reset occurs or NCQ commands fail,
> >  	 * do not try to be smart about what to do with this deferred command
> > -	 * and simply requeue it by completing it with DID_REQUEUE.
> > +	 * and simply requeue it by completing it with DID_REQUEUE. The
> > +	 * exception here is if the deferred qc timed out, in which case, we
> > +	 * leave it as is as ata_scsi_cmd_error_handler() will take care of it.
> >  	 */
> >  	ata_for_each_link(link, ap, PMP_FIRST) {
> >  		struct ata_queued_cmd *qc = link->deferred_qc;
> >  
> > -		if (qc) {
> > -			link->deferred_qc = NULL;
> > -			cancel_work(&link->deferred_qc_work);
> > -			ata_scsi_qc_done(qc, true, DID_REQUEUE << 16);
> > -		}
> > +		if (!qc || qc->scsicmd == timed_out_scmd)
> > +			continue;
> > +
> > +		link->deferred_qc = NULL;
> > +		cancel_work(&link->deferred_qc_work);
> > +		ata_scsi_qc_done(qc, true, DID_REQUEUE << 16);
> 
> [Severity: Critical]
> This is a pre-existing issue, but won't the explicit invocation of this
> requeue logic on every command timeout make a regression more likely?
> 
> When ata_scsi_requeue_deferred_qc() completes a deferred command using
> ata_scsi_qc_done() with DID_REQUEUE, it unconditionally calls
> ata_qc_free(), which clears the active flag.
> 
> If the block layer timer for this command expires concurrently,
> scsi_timeout() can win the race against the scsi_done() completion. The
> block layer marks the command as timed out and adds it to the SCSI EH queue.
> 
> When SCSI EH runs ata_scsi_cmd_error_handler(), it iterates over all QCs to
> find the command. Since ata_qc_free() was already called and the deferred_qc
> pointer was set to NULL, it won't match the deferred check.
> 
> Does this cause the loop to finish without finding the command and fall
> through to the successful completion branch:
> 
> drivers/ata/libata-eh.c:ata_scsi_cmd_error_handler() {
>     ...
>     } else {
>         /* Normal completion occurred after
>          * SCSI timeout but before this point.
>          * Successfully complete it.
>          */
>         set_host_byte(scmd, DID_OK);
>         scsi_eh_finish_cmd(scmd, &ap->eh_done_q);
>     }
> }
> 
> Could this result in the command being reported as successfully completed to
> the block layer, resulting in silent data corruption?

This specific race between ata_scsi_requeue_deferred_qc() and scsi_timeout()
has not existed for that long, because ata_scsi_requeue_deferred_qc() itself
is not that old.

Perhaps ata_scsi_requeue_deferred_qc(), instead of calling
ata_scsi_qc_done(qc, ...) directly to finish the command, should instead set
ATA_QCFLAG_RETRY (or similar) and call ata_qc_schedule_eh(qc, ...), such that
scsi_eh_scmd_add() will be called, and then EH will requeue the command instead
the completion path.

This way, there should be no race between ata_scsi_requeue_deferred_qc() ->
scsi_done() -> scsi_complete() -> scsi_queue_insert() and scsi_timeout(), as
it will be EH itself that requeues the command.


Note that while link->deferred_qc is set, we can only get a block layer timeout.
If the command was actually issued by the workqueue, link->deferred_qc will be
NULL, so the code in ata_scsi_cmd_error_handler() to handle the race between
normal completion and scsi_timeout() is not really applicable for link->deferred_qc.
(If link->deferred_qc is set, this qc cannot have raced against completion, only
against timeout.)


Kind regards,
Niklas
