Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE1A4D98EC;
	Thu,  9 Jul 2026 17:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783619768; cv=none; b=uZVpkhyxnzN3MTAOft8nFUp6u3ZV33vN6ovjKQUOWn4lAYbvR9DFWZ3Slx8LEvjsNOOqgRQVSipbMQ/NvnbzGOKYH7C6TlsZn7DzPrunUq8hMGKCuSqKTp1QyAtfZmPMXwwG4VCGOap47vNo+9Xv/TShq/bWXwCmH3Xa1mOa/24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783619768; c=relaxed/simple;
	bh=xsu2IE3d7x6fKsY+8Rjeuq0hvIl24BGMA1UzSIy+1qE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fpuyk2BKYvncbxTOjQbFff/xt3Cc0LKD3ZQ4a+RZD0Bt1EkmFFVrYRuIt3X71nRVtBi2NimOATcQcgtIcWVJnGgypAdl62WpeemOghau5tWhloLiCOKlkaXew7P0FBnq5dqGNBJpZaWnzsLsm3tRx+TLLa/54d4lfm20aCjp2Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mlo+Udid; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mlo+Udid"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC511F000E9;
	Thu,  9 Jul 2026 17:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783619766;
	bh=ejhofY7E9N2+3tqF1ZyIzy8aXzZ10Qdu5hStQmO5wZU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mlo+UdidRHA3xVuscFQL76X984uu2Abw77sm1ncGfjpYkAiZ0FyRVECjIlstMEgyP
	 FduuXVqGUxR+iCuI8KjAlIZ6l/284857qAyHKlwOlZQXrmHjQM2t3361kxRVL+tfma
	 Nj4bCf6xaAxNjYfIM9BupAJ90gyK0yL2w4lHEaUS8o4f0J6J5abQshYsc9edNJDs0c
	 NzjGcQaEbcZMFEKhE2I5UumWoNTehFIvzwM/fKQ7uh2k2uFsrfGIj/Yzgh9D4iXib9
	 aHYQPJmFYsLV9VpaQWhap7BM0BReRgEuPUM5XG4gVoYPry/g9/cyMqjOIA2UgY0TBk
	 NU/fs9zbXQGmg==
Date: Thu, 9 Jul 2026 19:56:01 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org, Igor Pylypiv <ipylypiv@google.com>
Subject: Re: [PATCH v1 1/2] ata: libata-scsi: terminate deferred commands on
 time out
Message-ID: <ak_gsY5YvMBC-0M_@fedora>
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
> On 7/9/26 18:00, sashiko-bot@kernel.org wrote:
> > [Severity: High]
> > Does calling ata_scsi_qc_done() here prematurely complete the timed-out
> > deferred command and free the libata qc?
> 
> Yes it does. But unless it is the deferred QC that suffered the timeout, the
> scsi command will be requeued and retried.

I think Sashiko has a good point.


After this patch:

We will have some deferred QC handling in ata_scsi_eh_timed_out(scmd):

-Sets link->deferred_qc = NULL;

-Cancels the workqueue.

ata_scsi_eh_timed_out() will do the following:
If scmd (the QC that timed out) was the deferred QC:
-Sets DID_REQUEUE on the deferred QC.
Else:
-Sets DID_TIMEOUT on the deferred QC.

-Calls ata_scsi_qc_done(), which frees the deferred QC and calls scsi_done()

-scsi_done() will call scsi_done_internal(cmd, false);
 scsi_done_internal(cmd, false) will set SCMD_STATE_COMPLETE,
 but will defer the actual completion (scsi_complete() to softirq context.
-ata_scsi_eh_timed_out() will return SCSI_EH_NOT_HANDLED to scsi_timeout(),
 which will break; and will then evaluate if SCMD_STATE_COMPLETE is set,
 if it is, it will do nothing.
 (If it is not set it will add the scmd to the list of failed scmds.)



In case scmd == the deferred QC, since scsi_done_internal() will set
SCMD_STATE_COMPLETE, before deferring the completion to softirq context,
the code in scsi_timeout() will not add the scmd to the error list using
scsi_eh_scmd_add(), instead it will return BLK_EH_DONE;


Thus, Sashikos comment can not happen in realtity, because if the deferred
QC timed out, it will never be added to the list of scmds which
ata_scsi_cmd_error_handler() will loop over.


I think it would be cleaner if we:

1) Modify ata_scsi_eh_timed_out():
if scmd == the deferred QC, set DID_TIMEOUT, but return SCSI_EH_DONE.
This way it is more obvious that no further EH will be done. (Instead of
relying on SCMD_STATE_COMPLETE already have been set, even though the
completion was deferred to softirq context.)

If scmd != the deferred QC, continue to set DID_REQUEUE and return
SCSI_EH_NOT_HANDLED.




2) If it was a timeout of the deferred QC, then we know that
ata_scsi_eh_timed_out() has been called, before ata_scsi_cmd_error_handler()
is called.

On NCQ error, while having a deferred non-NCQ QC,
ata_scsi_cmd_error_handler() will be called without ata_scsi_eh_timed_out()
having been called first.

Thus, we should be able to remove the code which specifically handles
the case where the deferred QC timed out in ata_scsi_eh_timed_out().

If the deferred QC timed out, ata_scsi_eh_timed_out() must have been called
with the timed out deferred QC as argument. And ata_scsi_eh_timed_out() will
set link->deferred_qc = NULL; so the code which handles the deferred QC timing
out, should now be dead code that can never be reached.

(On a hard NCQ error, the deferred QC will be requeued using:
ata_do_link_abort() -> ata_eh_set_pending() -> ata_scsi_requeue_deferred_qc(),
which sets link->deferred_qc = NULL; cancels the workqueue and calls
ata_scsi_qc_done(qc, true, DID_REQUEUE << 16))


Kind regards,
Niklas
