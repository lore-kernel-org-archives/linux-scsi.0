Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C569D30BF70;
	Tue, 14 Jul 2026 05:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784007687; cv=none; b=Dg+51MrqHrkhg7hQraMllf9h00YV/shpNv+4g95wMNZLxgC7gbEaBwhhbGDlsxLtTL51v9j39dnGNIea7LWX6RQIbRGmmUBm6p2e4tC/PV962hfbDibsxHazRFKi38yKS6iWCkU4lvqsyo3xUOPkZrrDsdNkeVlAcGc5yhgZjc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784007687; c=relaxed/simple;
	bh=4okm+848ls9ZaBkYF9L80q0vDBBKyYp+SCTYHqKBC98=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lVQAno3ViP1GXZpxY55Rtym0DUPL68J2OggYR2qf1qHHhmUdSQVxEa9ajGMSsBlemw2M/bdgGBLRGbf3FoTO0tep73ANWZnZt5mUVwKsK9AY/MlSTVSpxjGVrNlhNjMaAUkURFxkHCG/7kdOYG22+WpiT5flozuJ0hhpvxzOVQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=COHQnAmQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="COHQnAmQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651D51F000E9;
	Tue, 14 Jul 2026 05:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784007686;
	bh=9dqzQmPd9zn0fg00HGPgmxAGwnP58Nc3j/8g+H3dHsE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=COHQnAmQpUw1avhW9yVcFaAIGw0EpEdDu+pUQnJ2qWeMlKPa7KgSs3bqlLdYyLrNQ
	 hjIwnrXPaJUg0A0PPUNYbm/paUzoXLR4IXrM7ZbWh3GF+3AdPlJttzwN3vvEdlX3Y3
	 /dygJuqIYIbWWB9GtwB2pOC//J62CHNcvBllpc+z8dLI6qywFhUo5iH6h8D2QjfE87
	 uy3gOucMDHXYH5EDOU5rQ6o+5cfSF84ZsiGF+jX3Ckl+OFpWDD77LbYn0fNY6Pl28H
	 rHyeJFFMg753m193sQwesonFExp3wSnUFn59EPjMkkzQ1519oRYEdqykZF+WKuwv2K
	 eRsUj5cSbZWBg==
Message-ID: <f31d12e0-e7e8-4fba-aa6a-9461f7aced4d@kernel.org>
Date: Tue, 14 Jul 2026 14:41:13 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] ata: libata-scsi: terminate deferred commands on
 time out
To: Niklas Cassel <cassel@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Igor Pylypiv <ipylypiv@google.com>, John Garry <john.g.garry@oracle.com>,
 Jason Yan <yanaijie@huawei.com>
References: <20260713041252.463401-1-dlemoal@kernel.org>
 <20260713041252.463401-2-dlemoal@kernel.org> <alTDGdJMA-XZHeS-@fedora>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <alTDGdJMA-XZHeS-@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/13/26 19:51, Niklas Cassel wrote:
>> +void ata_eh_schedule_deferred_qc_retry(struct ata_port *ap,
>> +				       struct scsi_cmnd *scmd)
>> +{
>> +	struct ata_queued_cmd *qc;
>> +	struct ata_link *link;
>> +	unsigned long flags;
>> +
>> +	/*
>> +	 * Trigger EH for retrying any deferred qc that is not the queued
>> +	 * command for scmd.
>> +	 */
>> +	spin_lock_irqsave(ap->lock, flags);
>> +	ata_for_each_link(link, ap, PMP_FIRST) {
>> +		qc = link->deferred_qc;
>> +		if (!qc || qc->scsicmd == scmd)
>> +			continue;
>> +
>> +		link->deferred_qc = NULL;
>> +		cancel_work(&link->deferred_qc_work);
>> +		qc->flags |= ATA_QCFLAG_RETRY;
>> +		ata_qc_schedule_eh(qc);
>> +	}
>> +	spin_unlock_irqrestore(ap->lock, flags);
> 
> I was expecting you to modify ata_scsi_requeue_deferred_qc() to also
> requeue commands using this method, so we only have one of the functions.
> 
> Would it work if you modify ata_scsi_requeue_deferred_qc() to essentially
> call this function instead?

Yes, good point. I will do more tests but looks OK so far to do the retry
through EH. Initially, I did not want to do that to not trigger EH too much,
but as you pointed out, ata_scsi_requeue_deferred_qc() is called only if EH is
already scheduled or already running. So there is no point in not using it.

> """
> [Severity: Critical]
> This is a pre-existing issue, but won't the explicit invocation of this
> requeue logic on every command timeout make a regression more likely?
> 
> When ata_scsi_requeue_deferred_qc() completes a deferred command using
> ata_scsi_qc_done() with DID_REQUEUE, it unconditionally calls
> ata_qc_free(), which clears the active flag.
> """

When I read this comment from Sashiko, it seems to me that it refers to the
race between command normal completion and timeout timer triggering. Both may
happen at nearly the same time, and one may "win" depending on which is
processed first. Though if it is the timeout, we still endup doing a normal
completion if there was one. The code comment:

int ata_scsi_cmd_error_handler()
{
	...

	/* Normal completion occurred after
	 * SCSI timeout but before this point.
	 * Successfully complete it.
	 */
	scmd->retries = scmd->allowed;
	scsi_eh_finish_cmd(scmd, &ap->eh_done_q);

Which incidentally is the code path we take when retrying deferred QCs.

> I don't see how this patch will address the pre-existing issue Sashiko
> warned about.

It does not.

> I think that we need to modify ata_scsi_requeue_deferred_qc() to
> also requeue commands via EH.

Done. Testing now.

> Possibly it works because ata_scsi_requeue_deferred_qc() is currently
> always called by EH. But I think it would be simpler if we just have
> one function that always requeues/retries via EH, regardless if we
> already are in EH context or not.

Yes. Agree.

> 
> 
>> +}
>> +
>>  /**
>>   *	ata_scsi_error - SCSI layer error handler callback
>>   *	@host: SCSI host on which error occurred
>> @@ -1214,9 +1239,17 @@ static void __ata_eh_qc_complete(struct ata_queued_cmd *qc)
>>  	struct scsi_cmnd *scmd = qc->scsicmd;
>>  	unsigned long flags;
>>  
>> +
>> +	/*
>> +	 * If we are retrying a deferred QC after a timeout, it is not active
>> +	 * and all we need to do is to complete it directly.
>> +	 */
>>  	spin_lock_irqsave(ap->lock, flags);
>>  	qc->scsidone = ata_eh_scsidone;
>> -	__ata_qc_complete(qc);
>> +	if ((qc->flags & ATA_QCFLAG_RETRY) && !(qc->flags & ATA_QCFLAG_ACTIVE))
>> +		qc->complete_fn(qc);
>> +	else
>> +		__ata_qc_complete(qc);
> 
> I thought that we had to call scsi_eh_finish_cmd() for a command that was
> on the SCSI list of failed commands.

The new use of the eh_timed_out operation puts them in shost->eh_cmd_q with
scsi_eh_scmd_add() because we do not have a abort handler for ATA. commands in
shost->eh_cmd_q go into the local eh_work_q of ata_scsi_cmd_error_handler() and
for all deferred QCs, we endup calling scsi_eh_finish_cmd(), which finally move
the commands into the done_q that ata_eh_finish() uses.
So this is all good, because we always have scsi_eh_scmd_add() to "unbusy" the
host so that we do not block SCSI EH task wakeup.

> See e.g. how ata_scsi_cmd_error_handler() currently calls scsi_eh_finish_cmd().
> 
> What am I missing?

Nothing.

> Does the code still work if you simply unconditionally call
> __ata_qc_complete() here?

You get a WARN_ON() because the QC does *not* have ATA_QCFLAG_ACTIVE flag set
because for deferred QCs, we have not yet issued them. Hence the little change
above to avoid the warn splat. We could avoid it with a ATA_QCFLAG_DEFERRED flag...

> (Even if it is slightly less efficient, I would prefer a single/unified path.
> This is only if we have a NCQ error or timeout, so I don't think it is super
> critical to prioritize efficiency over maintainability here.)

This is not about efficiency. It is to be consistent with the ATA_QCFLAG_ACTIVE
flag being set or not.

-- 
Damien Le Moal
Western Digital Research
