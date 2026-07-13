Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54383B83E8;
	Mon, 13 Jul 2026 23:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783986078; cv=none; b=kJML4LwehbKscdZ5pvrdc24x4jmey/kwyBVZJJ9GN2t1oXi4pKee0xOX9395XfG/XyzHgquRSct/ouEtRNHzfVcAsZXdZ+0gF1Gj952Dk8H1G9ZCAdWpqjhFh8+fIVv375Go5bDswH+fznifgRagAhgNiZVjbc5Uzin2QzACtNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783986078; c=relaxed/simple;
	bh=6pwi1VCJHf0rxm4mkXBSpr6VjS+UlW1NSwlowOYYzk4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hvwmrUaOEuacymXrwCqnHp151jWpg5wPCZhbTy5Ig6sHhx8M2/JK4hxcX48raSs90NUqKaV/N9iwbHlW1OMz3GtmeheFAy3meR3IWk3dBevVwxqFugK3xeAMkyQw+W2Eo8LJl1sBzCibAwuURwKe+oFILXWXNQZ6d6jxa5yopk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dm3165CH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dm3165CH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65891F000E9;
	Mon, 13 Jul 2026 23:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783986076;
	bh=hyxeBqDuTcvdJl2lo1N8GMl6DBujM0bNNEnk6hJ3Xgg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Dm3165CHaS7aWW08TUp4a8QaffidG/nws7EqFfurrr4RbkdfNn14QsREFkXZx5NAl
	 IG/8KlkolEupOPkaoV+faGbTqFXPJViexY9f+PTAR1hiJurH4hfSJ4tQshZcw6JpqC
	 b5shRhZOwK2xsda/RUQt9ljLX4POFXCx/pyXKh2MgCVnEUykRCCY8GmHX/KnNoz+s1
	 2dECdlx8yiu4ZvEY97ABfepjNaxb6jToCkwCKHmIEXEsktwDa+APobSdqYLfCTpYbj
	 2pU84A23Se2+XP3ePXV6XfeVexBmLdCHkWWp7M+yDU6yRY2hKK2Ls6b4taJVQpUTEp
	 YPv8PsEu5Jt/A==
Message-ID: <7232aa1a-002a-4cd3-998a-0c0262822048@kernel.org>
Date: Tue, 14 Jul 2026 08:41:04 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] ata: libata-scsi: terminate deferred commands on
 time out
To: Igor Pylypiv <ipylypiv@google.com>
Cc: linux-ide@vger.kernel.org, Niklas Cassel <cassel@kernel.org>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, John Garry <john.g.garry@oracle.com>,
 Jason Yan <yanaijie@huawei.com>
References: <20260713041252.463401-1-dlemoal@kernel.org>
 <20260713041252.463401-2-dlemoal@kernel.org> <alUpbYeKFLrPvlFQ@google.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <alUpbYeKFLrPvlFQ@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/14/26 03:07, Igor Pylypiv wrote:
> On Mon, Jul 13, 2026 at 01:12:51PM +0900, Damien Le Moal wrote:
>> If a command timeout occurs while we have a deferred non-NCQ command
>> waiting to be issued, the SCSI EH task is not immediately woken up as the
>> waiting deferred command is never issued nor completed, thus leaving this
>> command to always be counted as "busy" for the SCSI host. This results in
>> the test "shost->host_failed != scsi_host_busy(shost))" in the function
>> scsi_error_handler() to always be true, keeping the EH task sleeping.
>> Eventually, when the deferred command also times out, the SCSI EH task
>> is woken up and the timeout processing occurs.
>>
>> Avoid this unnecessary SCSI EH task wake-up additional time using the
>> eh_timed_out SCSI host template operation. The function
>> ata_scsi_eh_timed_out() is introduced to implement this operation. This
>> function calls the new helper ata_eh_schedule_deferred_qc_retry() to
>> schedule a retry through libata EH of all differed queued command, except
>> for a differed queued commands that timed out as that case is handled in
>> ata_scsi_cmd_error_handler().
>>
>> Since ata_scsi_eh_timed_out() does not directly handles the timeout itself
>> and eventual re-issuing of deferred commands, this function returns
>> SCSI_EH_NOT_HANDLED to have scsi_timeout() continue with the regular
>> timeout handling, using scsi_abort_command() and scsi_eh_scmd_add(), thus
>> preventing the wkae-up delay for SCSI EH task.
>>
>> Fixes: 0ea84089dbf6 ("ata: libata-scsi: avoid Non-NCQ command starvation")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
>> ---
>>  drivers/ata/libata-eh.c   | 35 ++++++++++++++++++++++++++++++++++-
>>  drivers/ata/libata-scsi.c | 22 ++++++++++++++++++++++
>>  drivers/ata/libata.h      |  2 ++
>>  include/linux/libata.h    |  2 ++
>>  4 files changed, 60 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
>> index 05df7ea6954a..8e9d57c6f039 100644
>> --- a/drivers/ata/libata-eh.c
>> +++ b/drivers/ata/libata-eh.c
>> @@ -546,6 +546,31 @@ static void ata_eh_unload(struct ata_port *ap)
>>  	spin_unlock_irqrestore(ap->lock, flags);
>>  }
>>  
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
> 
> 
> Gemini pointed out an issue:
> 
> ata_scsi_cmd_error_handler() would skip this command because
> ATA_QCFLAG_ACTIVE flag is not set and qc != qc->dev->link->deferred_qc
> because ata_eh_schedule_deferred_qc_retry() set link->deferred_qc to NULL.
> 
> https://github.com/torvalds/linux/blob/master/drivers/ata/libata-eh.c#L655-L657

And I think that is fine, since there was no errors with the deferred QCs. In
this case, it falls into the last else after the loop, which does:

	scmd->retries = scmd->allowed;
	scsi_eh_finish_cmd(scmd, &ap->eh_done_q);

and after that, ata_eh_finish() will retry the QCs because they are tagged with
ATA_QCFLAG_EH and ATA_QCFLAG_RETRY.

I tested with AHCI, and checked that.

If anything, the retries count should be checked because I think this path
messes it up.

-- 
Damien Le Moal
Western Digital Research
