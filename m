Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546682E173B;
	Fri, 10 Jul 2026 07:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783668351; cv=none; b=BjcgHA0KD834gBhs6Js1HSVk+vJhEloaFD5KAOTCounJ/JkTqn0t3uVoD0uZEY5KgUw89F/fB97YlFhJskSnXtbCI6WqCsEv7cVz1evlKcfy3yYR+p8NLVYOM61fvWUwpXvdCYw/OnxmhgSYIwez3LK4S1WDhIEARdXvxF53f3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783668351; c=relaxed/simple;
	bh=mewv+gZgS8BpBYwpIzjXeG0cs+k6LhWkkp2CJDv4/xg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MgnX92LeH4me6U8gd427YATU7yr8T8DidGFP/SG/wDdGfaIC6CWqR6+auDcyNwowtXNPp+jLqCrXL0sCPvjkF14aYrYr4QQ0bV418GV/hZA+AAn8lRtR5W0+f8TlYrqSBGv4DUB+UpazepC41ZuxXKgHrECfT8BWOVpht/55trI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PZsG6JKY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PZsG6JKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC2D1F000E9;
	Fri, 10 Jul 2026 07:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783668350;
	bh=1sKhUrqFGsf69NZnkMWyUimAG+eff7zuVpC8hd9zzhc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PZsG6JKYIYVHsURg/hXpT7YJwKLh2ConN76T1G4LTysXe+lzQLf55yWF0aXz5kqlU
	 mYNk3EPj2h8hjEiISb/hhNtKaGSspHP2MZS78CO24GieAyTOZRg+578fSsaTGvUJkd
	 a8MRXQ9vl1Pd8QMVVfWcSjb1Q4aL09G/K0W8FAkRN9RxuIwZJzP+b+6wROduYPtCJW
	 ilLy5vp1LdiPL667b/NcmJHDgEa5s+f2lnTPSC3z5FW24hQL3q1TEIha9CwT11FYc+
	 cZlU4e/M/iLkRcGKB/gdXWWLazLaZum4k0aDuPOeLfjyP0zfUBzRNYoJUaAjMlVmqH
	 fOIFK6pke+HYw==
Message-ID: <724b4a01-e396-4cc0-be2a-9860f42d803f@kernel.org>
Date: Fri, 10 Jul 2026 16:25:38 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] ata: libata-scsi: terminate deferred commands on
 time out
To: sashiko-reviews@lists.linux.dev
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, cassel@kernel.org
References: <20260710000646.1202200-1-dlemoal@kernel.org>
 <20260710000646.1202200-2-dlemoal@kernel.org>
 <20260710002431.3148D1F000E9@smtp.kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260710002431.3148D1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/10/26 09:24, sashiko-bot@kernel.org wrote:
>> @@ -1694,16 +1695,19 @@ void ata_scsi_requeue_deferred_qc(struct ata_port *ap)
>>  	/*
>>  	 * If we have a deferred qc when a reset occurs or NCQ commands fail,
>>  	 * do not try to be smart about what to do with this deferred command
>> -	 * and simply requeue it by completing it with DID_REQUEUE.
>> +	 * and simply requeue it by completing it with DID_REQUEUE. The
>> +	 * exception here is if the deferred qc timed out, in which case, we
>> +	 * leave it as is as ata_scsi_cmd_error_handler() will take care of it.
>>  	 */
>>  	ata_for_each_link(link, ap, PMP_FIRST) {
>>  		struct ata_queued_cmd *qc = link->deferred_qc;
>>  
>> -		if (qc) {
>> -			link->deferred_qc = NULL;
>> -			cancel_work(&link->deferred_qc_work);
>> -			ata_scsi_qc_done(qc, true, DID_REQUEUE << 16);
>> -		}
>> +		if (!qc || qc->scsicmd == timed_out_scmd)
>> +			continue;
>> +
>> +		link->deferred_qc = NULL;
>> +		cancel_work(&link->deferred_qc_work);
>> +		ata_scsi_qc_done(qc, true, DID_REQUEUE << 16);
> 
> [Severity: Critical]
> This is a pre-existing issue, but won't the explicit invocation of this
> requeue logic on every command timeout make a regression more likely?

Maybe. But that race exists since eons ago. And command timeouts are rare, so I
do not consider this to be "critical" at all.

>> +static enum scsi_timeout_action
>> +ata_scsi_port_eh_timed_out(struct ata_port *ap, struct scsi_cmnd *scmd)
>> +{
>> +	unsigned long flags;
>> +
>> +	/*
>> +	 * We had a timeout, either for an NCQ command or for one deferred
>> +	 * queued command. If we have deferred QCs and we do not release them
>> +	 * immediately, we will have shost->host_failed != scsi_host_busy()
>> +	 * until the deferred QCs also timeout. This unnecessarilly increases
>> +	 * the time it takes for scsi EH to start. Terminate all deferred QCs
>> +	 * to avoid that.
>> +	 */
>> +	spin_lock_irqsave(ap->lock, flags);
>> +	ata_scsi_requeue_deferred_qc(ap, scmd);
>> +	spin_unlock_irqrestore(ap->lock, flags);
> 
> [Severity: High]
> Does this function need to set ATA_PFLAG_EH_PENDING?
> 
> Because this flag is not set, ata_port_eh_scheduled() will evaluate to
> false. This allows the block layer to immediately retry the requeued
> commands, which __ata_scsi_queuecmd() will accept and re-defer, keeping
> the host busy.

No it will not because this is called with SCSI EH already waiting to run, so
newly incoming commands are not passed down by the scsi layer.

-- 
Damien Le Moal
Western Digital Research
