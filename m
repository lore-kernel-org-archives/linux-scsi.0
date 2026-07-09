Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAFF47B437;
	Thu,  9 Jul 2026 17:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783618039; cv=none; b=r3PXqnWBKoT7g+w5G3ilNmWfHAOdXjCWstQfzo7LF87h1kGVsq9roJKaf14zOqXwy+f09aZJdgmrASHi0Uki7SWh4JN0AEFbM/+YW4bQ5/qFSjac+XWrpd8dYn4ec3TLmJCqy9wW6ctjYGdvIQlSeOiptY5i8CknA7tHpHTug5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783618039; c=relaxed/simple;
	bh=Cw7l/h/+E1H47JnzluulIXdMZWt+8LfOWyOjCHXiDdE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Aq3mrZcQ6Aus7eTcDVLQC2dphc9CURR7/HA/qcCj7O/IW7N2nG9nny7X6Ru8/Ip5JrjLLbfkOGo1qYWgGucvLDl6I26vCwf5L6Nzrm/zd+02XIshItMrBHC4Hh1fIL+i5DkWdocAGvuKh7xs61SlGNXa8hQB3bnHU5KWG3EWaQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CC5E9Y04; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CC5E9Y04"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2ED11F000E9;
	Thu,  9 Jul 2026 17:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783618034;
	bh=2c2HymZHP04uwSR25xn0VyWvNZVIbSiueJUQlLHn4t8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CC5E9Y04O9SK9K9r3s6eJZoFp29+a4vliseW1IYN+hDTYYmcsNJFCm9nEEp7NjdW3
	 X5eglY47ln98M1LDwFCWfc6U9T2+WXgzJViS5RtYU9m318imt0RaaoriBftHcP4NaI
	 E57f+Gyw0+PY9SZMkE6MSw29b3R9hzK66apUE7NnCOUKyWdkFDRdol2+LeL8M10OHw
	 R9EQGVdULM54mPJGqomjA9lrXC6+GTmIcA5+oWDQYOpVycr50Z5aQgXTK4/UhP7P3V
	 dbwzFSE4m+A9cumlh22xYPyGgcnbGskVNlaS6SxK+llQZNckJ3epMyXH60Fcd1viQk
	 vHnAtxKZ7H2jg==
Date: Thu, 9 Jul 2026 19:27:09 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH v1 1/2] ata: libata-scsi: terminate deferred commands on
 time out
Message-ID: <ak_Z7Y1j7yoS_R-J@fedora>
References: <20260709083934.1116862-1-dlemoal@kernel.org>
 <20260709083934.1116862-2-dlemoal@kernel.org>
 <20260709090006.F317F1F00A3A@smtp.kernel.org>
 <dcc4f558-7b6e-4193-a943-036255fc202f@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dcc4f558-7b6e-4193-a943-036255fc202f@kernel.org>

On Thu, Jul 09, 2026 at 06:14:08PM +0900, Damien Le Moal wrote:
> > It seems this causes the handler to fall into the 'raced completion' branch:
> > 
> > drivers/ata/libata-eh.c:ata_scsi_cmd_error_handler() {
> >     ...
> >     } else {
> >         /* Normal completion occurred after
> >          * SCSI timeout but before this point.
> >          * Successfully complete it.
> >          */
> >         scmd->retries = scmd->allowed;
> >         scsi_eh_finish_cmd(scmd, &ap->eh_done_q);
> >     }
> >     ...
> > }
> 
> And after this, scsi_eh_flush_done_q() will retry the command.
> Tested and I do not see failure of the deferred QC :)

I don't see how scsi_eh_flush_done_q() will retry the command.

Since ata_scsi_eh_timed_out() calls ata_scsi_qc_done(), which
calls scsi_done(), which calls scsi_done_internal(cmd, false),
which sets SCMD_STATE_COMPLETE, scsi_timeout() will never add
the scmd to the list of failed scmds using scsi_eh_scmd_add().

Thus, when ata_scsi_cmd_error_handler() loops though the list
of failed scmds, the scmd in question will never have been added
in the first place.

Most likely the command is retried via:
ata_scsi_qc_done() -> scsi_done() -> scsi_done_internal()

softirq -> scsi_complete() -> scsi_decide_disposition()

scsi_decide_disposition() returns ADD_TO_MLQUEUE for DID_REQUEUE,

scsi_complete() calls scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
when scsi_decide_disposition() returns ADD_DO_MLQUEUE.


Kind regards,
Niklas
