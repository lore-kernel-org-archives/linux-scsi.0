Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AA73B7B76;
	Thu, 16 Jul 2026 11:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784201173; cv=none; b=kpikX/BSA3yjLtCkefnNYwjGQRc7ELZ03OS1gRyPRg53Yq5aIb12a8hP31PPKbwH52itxyR0ha0m/Fj67RpDmML4+Op6SwDhe5CrOQV6OlXkJV1Ni8EW/ru0hpvQO7myE4m27/Pp+5G5xC+tjda7QaYYv+CvAPz+qj5J7ChrpGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784201173; c=relaxed/simple;
	bh=/GhGkyLafmYx78c2jEqekEn/fV3IkD/dorAiNQiIxU8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lRbqhyr1inA62Kv/B5x+ANwF53KMMdi3elD9WzwLY7Yh3DoNp+DmHHw0AaFRaClfJGZ+BmhvlXOnUOlDb3jyP3EL3o6+S43syI059hn6ZKdQKoAqytN+6fMrhC4sxzndtn5V93MiyscXRTRtKLk0xO6/KD/7QsgeIIcXbJPUO1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PYXD5i+t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PYXD5i+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 254331F000E9;
	Thu, 16 Jul 2026 11:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784201172;
	bh=9GOFvBBwxehhAOz6zHVDn0FgramevHIDGhsthm6TZ8g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PYXD5i+tu3en/nLbfh+paZtlBMcn3UfFL9QtQuC94Ilriie7Q9q9sIOU0MnV2qqr1
	 bgcUNUJKJxI8jWQj8Eock47d4PrkiKA6zVGGbf5mvz0wGG+6CddRgMmWC2CtF0Jxc3
	 iwHV6SMInQ8wwjR0nfEGskz3k73msbbC/3gwYg/g7q1bCIXU9RkxpAMzKpoxfwQQ/O
	 Q7z+buNwHhE2XT0eb7LZJZYJ01jOLY6Gcgt+S2L1FJRBdAkrTW1Hp5YDBZtXeE0vds
	 3+jhjkvtb6rp4tHL+y0KVpdNbMAfPjoGsw4Ly5KPCN1PEqyyd70l3ZyiSOhFvA82ua
	 nylTayFBq7A7A==
Message-ID: <3541fa2a-b46b-4f25-8cbb-85c343286432@kernel.org>
Date: Thu, 16 Jul 2026 20:26:09 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] ata: libata-scsi: terminate deferred commands on
 time out
To: Niklas Cassel <cassel@kernel.org>, sashiko-reviews@lists.linux.dev,
 sashiko-bot@kernel.org
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20260715085824.854200-1-dlemoal@kernel.org>
 <20260715085824.854200-2-dlemoal@kernel.org>
 <20260715092017.05CBF1F000E9@smtp.kernel.org>
 <19CECED4-8BC0-4028-914B-2EF1C55C729D@kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <19CECED4-8BC0-4028-914B-2EF1C55C729D@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/16/26 20:15, Niklas Cassel wrote:
> On 15 July 2026 11:20:16 CEST, sashiko-bot@kernel.org wrote:
>> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
>> - [High] Deferred commands retried via `ata_eh_retry_deferred_qc` will be erroneously processed as ghost timeouts during SCSI EH, leading to lost retries or erroneous `DRIVER_TIMEOUT` failures for unissued commands, and `host_failed` underflows.
>> --
>>
>> --- Patch [1]: [PATCH v4 1/2] ata: libata-scsi: terminate deferred commands on time out ---
>> commit 40daf934a62cbe822fdf8ae16b1ee66e4ac23f37
>> Author: Damien Le Moal <dlemoal@kernel.org>
>>
>> ata: libata-scsi: terminate deferred commands on time out
>>
>> This patch introduces ata_scsi_eh_timed_out() to immediately schedule a retry
>> of all waiting deferred QCs using the eh_timed_out SCSI host template
>> operation. It implements ata_eh_retry_deferred_qc() to schedule the retry
>> through libata EH with ata_qc_schedule_eh() and flags waiting QCs with
>> ATA_QCFLAG_RETRY.
>>
>> Fixes: 0ea84089dbf6 ("ata: libata-scsi: avoid Non-NCQ command starvation")
>>
>>> diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
>>> index 05df7ea6954a9..5c56e1dd580b6 100644
>>> --- a/drivers/ata/libata-eh.c
>>> +++ b/drivers/ata/libata-eh.c
>>> @@ -546,6 +546,27 @@ static void ata_eh_unload(struct ata_port *ap)
>>>  	spin_unlock_irqrestore(ap->lock, flags);
>>>  }
>>>  
>>> +void ata_eh_retry_deferred_qc(struct ata_port *ap,
>>> +			      struct scsi_cmnd *timedout_scmd)
>>> +{
>>> +	struct ata_queued_cmd *qc;
>>> +	struct ata_link *link;
>>> +
>>> +	lockdep_assert_held(ap->lock);
>>> +
>>> +	/* Trigger EH for retrying any deferred qc that has not timed out. */
>>> +	ata_for_each_link(link, ap, PMP_FIRST) {
>>> +		qc = link->deferred_qc;
>>> +		if (!qc || qc->scsicmd == timedout_scmd)
>>> +			continue;
>>> +
>>> +		link->deferred_qc = NULL;
>>> +		cancel_work(&link->deferred_qc_work);
>>> +		qc->flags |= ATA_QCFLAG_RETRY;
>>
>> [Severity: High]
>> Does clearing link->deferred_qc here break the deferred QC lookup in
>> ata_scsi_cmd_error_handler()?
>>
>> When the SCSI EH thread runs ata_scsi_cmd_error_handler(), it attempts to
>> identify the deferred QC:
>>
>> drivers/ata/libata-eh.c:ata_scsi_cmd_error_handler() {
>>    ...
>>    if ((qc->flags & ATA_QCFLAG_ACTIVE) ||
>>        qc == qc->dev->link->deferred_qc)
>>        break;
>>    ...
>> }
>>
>> Because ATA_QCFLAG_ACTIVE is not set on deferred commands and we have already
>> cleared link->deferred_qc to NULL above, the condition fails. The loop
>> finishes without breaking and falls through to the ghost timeout branch:
>>
>> drivers/ata/libata-eh.c:ata_scsi_cmd_error_handler() {
>>    ...
>>    } else {
>>        /* Normal completion occurred after
>>         * SCSI timeout but before this point.
>>         * Successfully complete it.
>>         */
>>        scmd->retries = scmd->allowed;
>>        scsi_eh_finish_cmd(scmd, &ap->eh_done_q);
>>    }
>> }
>>
>> Will this cause the retry budget for the deferred command to be artificially
>> exhausted, resulting in erroneous DRIVER_TIMEOUT failures for unissued
>> commands?
>>
>> Additionally, when libata EH later processes this same qc in ata_eh_finish()
>> and calls ata_eh_qc_retry(), it will execute __ata_eh_qc_complete() and call
>> scsi_eh_finish_cmd() a second time for the same command. Could this double
>> completion cause host_failed to underflow and corrupt the SCSI EH state
>> machine
> 
> I'm on vacation mode, so not thinking clearly,
> but does Sashiko have a point here?

I missed this... And yes, I think Sashiko is making a good point here.

> You modify __ata_eh_qc_complete(), so it will NOT call __ata_qc_complete()
> if ((qc->flags & ATA_QCFLAG_RETRY) && !(qc->flags & ATA_QCFLAG_ACTIVE))
> 
> But __ata_eh_qc_complete() will still call scsi_eh_finish_cmd(). So it there a chance that 
> scsi_eh_finish_cmd() will be called twice?

Yes. That function only moves the command to the tail of the done queue though.
So calling it twice is completely harmless, hence why my testing did not reveal
anything wrong. But indeed that is dirty and useless.

> Do we perhaps need a QC flag anyway, so that an "aborted" deferred QC does not call scsi_eh_finish_cmd() in ata_scsi_cmd_error_handler()? (Such that the 
> scsi_eh_finish_cmd() in __ata_eh_qc_complete() is the only one that will be called.)

I will see what the simplest fix is. I do not really want to add another flag to
special case the retry of deferred QCs. But it is already... So we need to do
something.

Oh well, I will send a v6 then.



-- 
Damien Le Moal
Western Digital Research
