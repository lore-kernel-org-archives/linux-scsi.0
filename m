Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19863E2746;
	Mon, 13 Jul 2026 10:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783939871; cv=none; b=Binug6Ebwi2PfBXNk0RiESUSSzIr3y9392Tu+8lgWWQyeUnQvtRbG9R7/LfjTtz7GgCgkJ3C9uAM3DSqUyXj6jigN7gK5CQ2H4gYjAO8V3Qll3RAoVlaYWzIvNm3CJhLDUVZgFDvuMBvoxUT3i4+1tAknmH/qJ4Kfi8iy6pcE0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783939871; c=relaxed/simple;
	bh=OPfMRIa4nA9KedTVQcSOtY2NNVo7PJwo8kfHEMk2qLE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MVxKuOP/EQnfSvWH79JcU/E488ieax4FRZO9HxNKYmfT/9Tlqvif2J+ZmkxzXNpLdg5kUI/g/OobM7RI+50rkWS3Ios/E0v6I8wRRAUmWFvE57MJBAC6HSOT67GP+JPgYM+BoNxAE31LMDyEdWEvkb4T4bkQ0sjC8UYAg3fEYwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mEOHFbNh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mEOHFbNh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92AE01F000E9;
	Mon, 13 Jul 2026 10:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783939870;
	bh=tZkCzQFcbnjr4csOBbD7u4BPCfN0sfEmA68briBhZ40=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mEOHFbNhq/Vq9ihpncTaawP5Dumq1hlknv4kyvlVW026DldcidW5uh5q1G6P6/47l
	 buPj1fcNDtC4gBOzlk5iYcqpFvbilGdJtNoUDq6O8/sJ9kujODcENR59op0Gvw7lwD
	 xAwL+n2qnZDakUwPJdvJC6Jlim988edojUbZaqZXHQN+IpBA1PyOMhapejhVZQa46J
	 X59YkPteg3WOG2Lk+bWhr6xyZiueAOFqmoll7VuMxJjXoi4cVa+itA+3fGthm01/s3
	 9CcIF0jxdZUJAmoVVFMJJAkKfzRph5TLVHtmCiQ54XxrP1P4zePf8suV4hlZzhSXg8
	 Mok3ePWjmRNLw==
Date: Mon, 13 Jul 2026 12:51:05 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Igor Pylypiv <ipylypiv@google.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCH v3 1/2] ata: libata-scsi: terminate deferred commands on
 time out
Message-ID: <alTDGdJMA-XZHeS-@fedora>
References: <20260713041252.463401-1-dlemoal@kernel.org>
 <20260713041252.463401-2-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713041252.463401-2-dlemoal@kernel.org>

On Mon, Jul 13, 2026 at 01:12:51PM +0900, Damien Le Moal wrote:
> If a command timeout occurs while we have a deferred non-NCQ command
> waiting to be issued, the SCSI EH task is not immediately woken up as the
> waiting deferred command is never issued nor completed, thus leaving this
> command to always be counted as "busy" for the SCSI host. This results in
> the test "shost->host_failed != scsi_host_busy(shost))" in the function
> scsi_error_handler() to always be true, keeping the EH task sleeping.
> Eventually, when the deferred command also times out, the SCSI EH task
> is woken up and the timeout processing occurs.
> 
> Avoid this unnecessary SCSI EH task wake-up additional time using the
> eh_timed_out SCSI host template operation. The function
> ata_scsi_eh_timed_out() is introduced to implement this operation. This
> function calls the new helper ata_eh_schedule_deferred_qc_retry() to
> schedule a retry through libata EH of all differed queued command, except

s/differed/deferred/

> for a differed queued commands that timed out as that case is handled in

s/differed/deferred/

> ata_scsi_cmd_error_handler().
> 
> Since ata_scsi_eh_timed_out() does not directly handles the timeout itself
> and eventual re-issuing of deferred commands, this function returns
> SCSI_EH_NOT_HANDLED to have scsi_timeout() continue with the regular
> timeout handling, using scsi_abort_command() and scsi_eh_scmd_add(), thus
> preventing the wkae-up delay for SCSI EH task.

s/wkae-up/wake-up/

> 
> Fixes: 0ea84089dbf6 ("ata: libata-scsi: avoid Non-NCQ command starvation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  drivers/ata/libata-eh.c   | 35 ++++++++++++++++++++++++++++++++++-
>  drivers/ata/libata-scsi.c | 22 ++++++++++++++++++++++
>  drivers/ata/libata.h      |  2 ++
>  include/linux/libata.h    |  2 ++
>  4 files changed, 60 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
> index 05df7ea6954a..8e9d57c6f039 100644
> --- a/drivers/ata/libata-eh.c
> +++ b/drivers/ata/libata-eh.c
> @@ -546,6 +546,31 @@ static void ata_eh_unload(struct ata_port *ap)
>  	spin_unlock_irqrestore(ap->lock, flags);
>  }
>  
> +void ata_eh_schedule_deferred_qc_retry(struct ata_port *ap,
> +				       struct scsi_cmnd *scmd)
> +{
> +	struct ata_queued_cmd *qc;
> +	struct ata_link *link;
> +	unsigned long flags;
> +
> +	/*
> +	 * Trigger EH for retrying any deferred qc that is not the queued
> +	 * command for scmd.
> +	 */
> +	spin_lock_irqsave(ap->lock, flags);
> +	ata_for_each_link(link, ap, PMP_FIRST) {
> +		qc = link->deferred_qc;
> +		if (!qc || qc->scsicmd == scmd)
> +			continue;
> +
> +		link->deferred_qc = NULL;
> +		cancel_work(&link->deferred_qc_work);
> +		qc->flags |= ATA_QCFLAG_RETRY;
> +		ata_qc_schedule_eh(qc);
> +	}
> +	spin_unlock_irqrestore(ap->lock, flags);

I was expecting you to modify ata_scsi_requeue_deferred_qc() to also
requeue commands using this method, so we only have one of the functions.

Would it work if you modify ata_scsi_requeue_deferred_qc() to essentially
call this function instead?

(They seem to have different locking requirements, so possibly create a
__ata_scsi_requeue_deferred_qc() that has a lockdep_assert_held(ap->lock)
and let ata_eh_schedule_deferred_qc_retry() take the lock and call
__ata_scsi_requeue_deferred_qc(). Perhaps we can come up with better names,
but you get the point.)


Because, as far as I understood the Sashiko comment:

"""
[Severity: Critical]
This is a pre-existing issue, but won't the explicit invocation of this
requeue logic on every command timeout make a regression more likely?

When ata_scsi_requeue_deferred_qc() completes a deferred command using
ata_scsi_qc_done() with DID_REQUEUE, it unconditionally calls
ata_qc_free(), which clears the active flag.
"""

I don't see how this patch will address the pre-existing issue Sashiko
warned about.

I think that we need to modify ata_scsi_requeue_deferred_qc() to
also requeue commands via EH.

Possibly it works because ata_scsi_requeue_deferred_qc() is currently
always called by EH. But I think it would be simpler if we just have
one function that always requeues/retries via EH, regardless if we
already are in EH context or not.


> +}
> +
>  /**
>   *	ata_scsi_error - SCSI layer error handler callback
>   *	@host: SCSI host on which error occurred
> @@ -1214,9 +1239,17 @@ static void __ata_eh_qc_complete(struct ata_queued_cmd *qc)
>  	struct scsi_cmnd *scmd = qc->scsicmd;
>  	unsigned long flags;
>  
> +
> +	/*
> +	 * If we are retrying a deferred QC after a timeout, it is not active
> +	 * and all we need to do is to complete it directly.
> +	 */
>  	spin_lock_irqsave(ap->lock, flags);
>  	qc->scsidone = ata_eh_scsidone;
> -	__ata_qc_complete(qc);
> +	if ((qc->flags & ATA_QCFLAG_RETRY) && !(qc->flags & ATA_QCFLAG_ACTIVE))
> +		qc->complete_fn(qc);
> +	else
> +		__ata_qc_complete(qc);

I thought that we had to call scsi_eh_finish_cmd() for a command that was
on the SCSI list of failed commands.

See e.g. how ata_scsi_cmd_error_handler() currently calls scsi_eh_finish_cmd().

What am I missing?

Does the code still work if you simply unconditionally call
__ata_qc_complete() here?

(Even if it is slightly less efficient, I would prefer a single/unified path.
This is only if we have a NCQ error or timeout, so I don't think it is super
critical to prioritize efficiency over maintainability here.)


Kind regards,
Niklas
