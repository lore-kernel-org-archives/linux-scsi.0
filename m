Received: from mta0.migadu.com (out-74.mta0.migadu.com [91.218.175.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5033FF884
	for <linux-scsi@vger.kernel.org>; Thu,  1 Oct 2026 10:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790851827; cv=none; b=cFQJpa6m9NuHEGXt3bgvRqPu8tmDOwI1LTESUQ12jsyKA5CEUT9Jhx9lDVEPTeHVMnkm7mVvfsEF8+xr4ni7vDrWBD8H53tL745/TnG+mLot7M6o05vHMNPcXHvmAEir/48cDdCYdILnHIGzLSaEAf0uAvNHopq2eaA/YujwSOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790851827; c=relaxed/simple;
	bh=oUz6waLYg1/eEtKeCREvs7l2iCLaIUvR2pRHE5Jf0RU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nIq2PsJbIoELH96Tpsp4dRT1VNjksKZjJU78Ojl1wFFr7ZRV4asUsLHDusOP0+QB9E4k1iCwLihZ7AXeOmQCVALq28Ycf4g6//MWZSyA0Bq1obrfqqq3ebFDn1FX6jt+9hVuNCEqgDT0SHQbGW6/nmdXTELha+uWxltpinOcHPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ivttPynR; arc=none smtp.client-ip=91.218.175.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ivttPynR"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=oUz6waLYg1/eEtKeCREvs7l2iCLaIUvR2pRHE5Jf0RU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790851819; v=1; x=1791456619;
 b=ivttPynRprh5Wuz+JM8jZWW6SWMSt8OMjOJAKipo3fusvW2hXAJy7nKlkk9k7/RIg0aTGWX3
 ibOEFBDN+d0k/u1cnggmefuUExAqQtR/IYAgtRQsE0j+5nTLzHaTkYWAOPbY0oHKaWGOoXY271l
 xp3ULTI+dr9ZAX8ka5wKTuME=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 03b9e662ccb6b2b8;
	Thu, 01 Oct 2026 10:50:19 +0000
X-Mizu-Trace-ID: 03b9e662ccb6b2b8
X-Migadu-Flow: FLOW_OUT
Message-ID: <0b1bb7ce-4720-4d12-96ff-ab04cd1b85bc@linux.dev>
Date: Thu, 1 Oct 2026 11:50:15 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: mpi3mr: Stop IRQ polling when no reply is ready
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260930145606.2632749-1-usama.arif@linux.dev>
 <20260930145606.2632749-3-usama.arif@linux.dev>
 <20260930152032.BDA8F1F000FF@smtp.kernel.org>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260930152032.BDA8F1F000FF@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 30/09/2026 16:20, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] scsi: mpi3mr: dropped IRQ poll trigger causes hard-IRQ storm
> --
> 
> commit a00593b528c873a4c3ec905f3fa02c054a4e3bf0
> Author: Usama Arif <usama.arif@linux.dev>
> Subject: scsi: mpi3mr: Stop IRQ polling when no reply is ready
> 
> This commit modifies the IRQ polling logic in the mpi3mr driver to stop
> polling when a post-sleep check finds the queue empty. It introduces a
> barrier and a recheck of pend_ios to avoid losing wakeups from concurrent
> submitters.
> 
>> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
>> index 102f84667a5cf..6f113d8625bb4 100644
>> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
>> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> [ ... ]
>> @@ -819,17 +829,34 @@ static irqreturn_t mpi3mr_isr_poll(int irq, void *privdata)
>>  
>>  		if (!midx)
>>  			mpi3mr_process_admin_reply_q(mrioc);
>> -		num_op_reply +=
>> -		    mpi3mr_process_op_reply_q(mrioc, op_reply_q);
>> +		num_op_reply += mpi3mr_process_op_reply_q(mrioc, op_reply_q,
>> +							  &checked_empty);
>> +		/* Stop only on an empty check made while owning the queue */
>> +		if (slept && checked_empty) {
>> +			idle = true;
>> +			break;
>> +		}
>>  		if (!atomic_read(&op_reply_q->pend_ios))
>>  			break;
>>  
>>  		usleep_range(MPI3MR_IRQ_POLL_SLEEP, 10 * MPI3MR_IRQ_POLL_SLEEP);
>> +		slept = true;
>>  
>>  	} while (num_op_reply < mrioc->max_host_ios);
>>  
>> -	if (op_reply_q)
>> -		op_reply_q->enable_irq_poll = false;
>> +	if (op_reply_q) {
>> +		WRITE_ONCE(op_reply_q->enable_irq_poll, false);
>> +		if (idle) {
>> +			/*
>> +			 * Recheck after clearing, pairs with atomic_inc_return()
>> +			 * in mpi3mr_op_request_post().
>> +			 */
>> +			smp_mb();
>> +			if (atomic_read(&op_reply_q->pend_ios) >
>> +			    MPI3MR_IRQ_POLL_TRIGGER_IOCOUNT)
>> +				WRITE_ONCE(op_reply_q->enable_irq_poll, true);
>> +		}
>> +	}
> 
> [Severity: Medium]
> Could this unconditional clearing of the flag combined with gating the recheck
> behind if (idle) allow a concurrent submitter's trigger to be overwritten and
> lost?
> 
> If the polling thread processes all replies and pend_ios drops to 0, it breaks
> the loop with idle = false.
> 
> If a concurrent submitter in mpi3mr_op_request_post() then posts a burst of
> I/Os, surpasses the trigger threshold, and sets enable_irq_poll = true, the
> polling thread will subsequently execute WRITE_ONCE(op_reply_q->enable_irq_poll, false).
> 
> Because idle is false, the thread skips the smp_mb() barrier and the pend_ios
> recheck. Doesn't this blindly overwrite the submitter's flag and leave
> enable_irq_poll disabled, forcing all completions into the hard IRQ handler?
> 

Yes, it can be overwritten on those exits, but that is not new: before
this patch the thread cleared the flag on its exits without a recheck,
and those exits are unchanged. The recheck is only added to the idle
exit this patch introduces, which stops polling while I/Os can still be
pending.

It also only lasts until the next submission: mpi3mr_op_request_post()
sets the flag on every submission that leaves more than
MPI3MR_IRQ_POLL_TRIGGER_IOCOUNT I/Os pending, not just on the one that
crosses it. Until then the hard IRQ handler processes the replies, as it
does below the trigger or with threaded_isr_poll=0, so no reply is lost.

