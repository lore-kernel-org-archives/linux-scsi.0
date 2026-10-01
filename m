Received: from mta0.migadu.com (out-54.mta0.migadu.com [91.218.175.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D998C3CE4B5
	for <linux-scsi@vger.kernel.org>; Thu,  1 Oct 2026 10:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790851769; cv=none; b=grsJUe5Ws9E1R3xOKkq+llcyMKghYC/noSSs9DBI2524hxH359Pbbbf2Q0qevYMOUQciEVM9+CN4hTXEoVjSmam+3JrL+ReQ0VoGqz5GjLXhNaxby2AuNh0Zm7s1N0zvf/AEgHq1VGYmsossorZZhBn/bjn9k+SjtlymmPT61Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790851769; c=relaxed/simple;
	bh=XIyWcUSwko0u86khIC0kb9UOX0Et5JBm+9AF/1opBZs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uBaqenBGcdpUSj3XvkxDL7vo2Qx5AlqeGuCehKMg0WfKf/4H4vZg4JnvQt8tOJCQENzh27VLzbmKK8wjUfK2LLgWW1mfOBzg8YtsvXWRlKSCOzPHzU4qQOCYKLEKazDY7YoQbLk5XMwS9k8SiZ6TVzYj8ewLiWlKgiViQ9GkB2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CdSwidd4; arc=none smtp.client-ip=91.218.175.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CdSwidd4"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=XIyWcUSwko0u86khIC0kb9UOX0Et5JBm+9AF/1opBZs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790851764; v=1; x=1791456564;
 b=CdSwidd4YMDBbDOXNHNB9M9E6hsmsriXb53YQVcSlK+iPJLBYnQo1fgtVjavMmTc0yD/udqR
 lpRWaZClFlye8QV6CfPDWkQ5DE15NjR9uBOlDrji55nkxlAwl/utiLYeGfKjAUsssc+zr3IC6He
 hzJNkpnPPjGnMl1TGk/O2ghA=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9189637c840d8b77;
	Thu, 01 Oct 2026 10:49:24 +0000
X-Mizu-Trace-ID: 9189637c840d8b77
X-Migadu-Flow: FLOW_OUT
Message-ID: <bdf2781e-fbcb-4356-b1eb-ccdbfb39c1b9@linux.dev>
Date: Thu, 1 Oct 2026 11:49:17 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] scsi: mpi3mr: Poll a reply queue that an interrupt
 found busy
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260930145606.2632749-1-usama.arif@linux.dev>
 <20260930145606.2632749-2-usama.arif@linux.dev>
 <20260930151039.F23801F000FF@smtp.kernel.org>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260930151039.F23801F000FF@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 30/09/2026 16:10, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] scsi: mpi3mr: unhandled missed reply race under PREEMPT_RT
> --
> 
> commit c0b0a317901b4ce93a734871bf41b604287947d5
> Author: Usama Arif <usama.arif@linux.dev>
> 
> scsi: mpi3mr: Poll a reply queue that an interrupt found busy
> 
> This patch sets a flag to trigger a thread wakeup when an interrupt finds a
> reply queue busy. It aims to prevent missed replies when another context
> owns the queue.
> 
>> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
>> index f0d3cd398dd00..102f84667a5cf 100644
>> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
>> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> [ ... ]
>> @@ -588,8 +588,11 @@ int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
>>  
>>  	reply_qidx = op_reply_q->qid - 1;
>>  
>> -	if (!atomic_add_unless(&op_reply_q->in_use, 1, 1))
>> +	if (!atomic_add_unless(&op_reply_q->in_use, 1, 1)) {
>> +		/* The owner may have missed a reply, let the thread poll */
>> +		WRITE_ONCE(op_reply_q->enable_irq_poll, true);
> 
> [Severity: High]
> When this code executes in mpi3mr_process_op_reply_q() under PREEMPT_RT,
> does it leave missed IO replies stranded?
> 
> Under CONFIG_PREEMPT_RT, the interrupt handler is mpi3mr_isr_primary(),
> which exits without checking the enable_irq_poll flag or returning
> IRQ_WAKE_THREAD.
> 
> Additionally, looking at how the interrupt is requested:
> 
> drivers/scsi/mpi3mr/mpi3mr_fw.c:mpi3mr_request_irq() {
>     ...
> #else
> 	retval = request_threaded_irq(pci_irq_vector(pdev, index), mpi3mr_isr_primary,
> 	    NULL, IRQF_SHARED, intr_info->name, intr_info);
> #endif
>     ...
> }
> 
> Because the polling thread handler is explicitly NULL under PREEMPT_RT,
> there is no polling thread to wake up to process the missed replies.
> Could this cause SCSI command timeouts and host resets during concurrent
> IO under PREEMPT_RT?


This patch doesn't change how PREEMPT_RT behaves. Nothing reads
enable_irq_poll there, so a handler that loses the in_use try-lock
returns just as it did before, and the same goes for
threaded_isr_poll=0.

So the race remains on those configurations, but it is not new. The
reply waits for the next interrupt on that queue, or for the command
timeout if none comes. Fixing it without the polling thread needs a
different approach, which I'd rather keep out of this series.


> 
>>  		return 0;
>> +	}
>>  
>>  	exp_phase = op_reply_q->ephase;
>>  	reply_ci = op_reply_q->ci;
> 

