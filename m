Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0B73D6CA4;
	Mon, 20 Jul 2026 09:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784539985; cv=none; b=PmlevFxI8S7YRJRx1dlMTYwik1D/xZO6EXbYkKQKcVhATeUofQFwLIoa9zSZT0vYEBmovRoa+skgBK6eo3JjG7+LRaPlBaYauLHy6TBYs/0+MqqQUQd+YHprRGoHjh43/m6w+3GwtuuPt+9n8s/OFMnxRSF7mmgH5f9QI54SIgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784539985; c=relaxed/simple;
	bh=vsf/E3+jsCQFMwL3EKVcVKBhK4dFH51HgTt0oiVpb2I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rZNHBIehwp/JnyQNKH40OkxoGu5nUNjZa3etfkcOQ0NQi2JRXV7CX+zjraVh/Q2lYN8T9U0xFvoCB+mb5SK55NoBKVXXJnM62Um28GT/jK5gfrb/rQ170jjPm/3co1BCwRL/L1iTvSYIZghAY22D2P4tbQTFC6EvuZfthu5aSe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XI6iGe0B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XI6iGe0B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3955E1F000E9;
	Mon, 20 Jul 2026 09:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784539984;
	bh=ZfR2g/WngHonCyKcs/mZInuSpqMXOSxgggCegt3LK1A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XI6iGe0BYtGPn25QKY67E6hw5PrL4gPoAvtiUT6L1+2KkgutDMPGNAW+N0BG4Jdlx
	 QHau7uR0BE143B56lkVMCXEPbN0+WpQcPEBX5HCMB1FnjRmXFfnb0UQ1IbBzk/HtpD
	 FZVRDBAwUYJy3UD29oP1oDrlBsLNWA+Tn7LxolguDRONuh6qVC5/BV068+8G8lTpR/
	 CA9oNCtHd/WxxKJoUN5lBuaKNvoenxvI+vznOGrfQV+kzutyVAwS2ND0x+Q54UfTLo
	 lvaX1z6Q15IWmdaHyOg1SQT6UFHKCTAsJR/lEyN1V2LjKexoAj5c2u/qkyv+QmBCLQ
	 0iiCs5rMUZWzw==
Message-ID: <8a4b58ca-c172-429d-8de3-34f92f5d2264@kernel.org>
Date: Mon, 20 Jul 2026 18:33:01 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/2] ata: libata-scsi: terminate deferred commands on
 time out
To: sashiko-reviews@lists.linux.dev
Cc: cassel@kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20260720071450.1877625-1-dlemoal@kernel.org>
 <20260720071450.1877625-2-dlemoal@kernel.org>
 <20260720073106.E10121F000E9@smtp.kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260720073106.E10121F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/20/26 16:31, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] A race condition between block layer timeout work and the SCSI EH thread causes deferred QCs to fail permanently, resulting in spurious I/O errors.
> --
> 
> --- Patch [1]: [PATCH v6 1/2] ata: libata-scsi: terminate deferred commands on time out ---
> commit 65621fb40c8a19c964f38c70891c67cb0a3f9251
> Author: Damien Le Moal <dlemoal@kernel.org>
> Subject: ata: libata-scsi: terminate deferred commands on time out
> 
> If a command timeout occurs while we have deferred non-NCQ commands
> waiting to be issued, the SCSI EH task is not immediately woken up as the
> waiting deferred commands are never issued nor completed. Avoid this
> unnecessary SCSI EH task wake-up additional time by scheduling a retry of
> all waiting deferred QCs, using the eh_timed_out SCSI host template
> operation.
> 
>> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
>> index 5868526301a2b..b02b4ca5c09e2 100644
>> --- a/drivers/ata/libata-scsi.c
>> +++ b/drivers/ata/libata-scsi.c
> 
> [ ... ]
> 
>> -void ata_scsi_requeue_deferred_qc(struct ata_port *ap)
>> +void ata_scsi_requeue_deferred_qc(struct ata_port *ap,
>> +				  struct scsi_cmnd *timedout_scmd)
>>  {
>> +	struct ata_queued_cmd *qc;
>>  	struct ata_link *link;
>>  
>>  	lockdep_assert_held(ap->lock);
>>  
>>  	/*
>> -	 * If we have a deferred qc when a reset occurs or NCQ commands fail,
>> -	 * do not try to be smart about what to do with this deferred command
>> -	 * and simply requeue it by completing it with DID_REQUEUE.
>> +	 * Trigger EH for any deferred qc, to either retry them or handle one
>> +	 * that timed out.
>>  	 */
>>  	ata_for_each_link(link, ap, PMP_FIRST) {
>> -		struct ata_queued_cmd *qc = link->deferred_qc;
>> +		qc = link->deferred_qc;
>> +		if (!qc)
>> +			continue;
>>  
>> -		if (qc) {
>> -			link->deferred_qc = NULL;
>> -			cancel_work(&link->deferred_qc_work);
>> +		link->deferred_qc = NULL;
>> +		cancel_work(&link->deferred_qc_work);
>> +
>> +		if (!timedout_scmd) {
>> +			/*
>> +			 * We are retrying due to some error. Complete the
>> +			 * request and ask for a requeue. In this case, since EH
>> +			 * was scheduled already, the block layer attempting to
>> +			 * re-issue the command immediately will not lead to the
>> +			 * device being kept busy, thus allowing SCSI EH task to
>> +			 * run.
>> +			 */
>>  			ata_scsi_qc_done(qc, true, DID_REQUEUE << 16);
>> +			continue;
>>  		}
>> +
>> +		/*
>> +		 * We are being called from scsi_timeout(). scsi_eh_scmd_add()
>> +		 * will add the command to eh_work_q and it will be handled by
>> +		 * ata_scsi_cmd_error_handler(). So here, we only need to
>> +		 * indicate if we want a retry if the command did not timeout.
>> +		 */
>> +		if (qc->scsicmd != timedout_scmd)
>> +			qc->flags |= ATA_QCFLAG_RETRY;
>> +
>> +		/*
>> +		 * Schedule EH, but set EH pending on the port so that we do not
>> +		 * reenter this function from ata_eh_set_pending() with
>> +		 * timedout_scmd being NULL and erroneously retry deferred QCs
>> +		 * that have timed out on other links.
>> +		 */
>> +		ap->pflags |= ATA_PFLAG_EH_PENDING;
>> +		ata_qc_schedule_eh(qc);
> 
> [Severity: High]
> Does this introduce a race condition between the block layer timeout work and
> the SCSI EH thread that could cause deferred QCs to fail permanently with
> spurious I/O errors?
> 
> When a command times out, ata_scsi_eh_timed_out() calls this and triggers
> ata_qc_schedule_eh() on deferred QCs. This calls blk_abort_request(), which
> schedules the block layer timeout_work asynchronously.
> 
> Meanwhile, the original timed-out command is added to eh_cmd_q and immediately
> wakes up the SCSI EH thread. If the SCSI EH thread processes eh_cmd_q in
> ata_scsi_cmd_error_handler() before the asynchronous timeout_work for the
> deferred QCs runs, ata_scsi_cmd_error_handler() will miss the deferred QCs
> since they aren't in eh_work_q yet:

Somehow, this patch seems to be working, but yet, in view of this comment, I do
not see how the host busy counter is decremented for the deferred QCs. Something
is missing. We somehow need to call scsi_complete() with a status that leads to
the command disposition to fall to the default scsi_eh_scmd_add() so that we do
not immediately retry the command, since that also does not work (previous
version issue).

Spending the weekend on this was a waste of time. Back to the drawing board on this.

-- 
Damien Le Moal
Western Digital Research
