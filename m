Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794767854;
	b=Ba9IsfIpJsnlvsfcN4yrjaZKD1I043+gaFi4+B4LNZNPgWFN4k45r7kM9AAENFoZbeRX
	 86wDj3Tcry5NlnQXMSo0oem/k8ryeBQiEmW+cgC9XRGKFwJCea5FGWFQfpy/8OIoifDOj
	 GM7Z3dt82vQagFAglC0aVxDZ469rWlUaBYNQE5rJOwCz8pvgM0VlcAbmHlzBgmf/O+tr1
	 on7CE6d99Vvc26GipcFNgkHRKSeRsjSD7NpVFH+JXR5QMFoktjGWI/9LT2vKktNUXXw2c
	 dGRHw8SNfECnOf5YPrFIPyJcq8/Mrcu8mzBkHANM0EYx9nFuoDU1iWkl9/8K8TC8hXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794767854;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=9+CWduOD2mKLrUtPjD/H/4JSv1e7FTjJ8If9tjLANUo=;
	b=QFS5knAbuw7/q3s8S/JX/XOnpRLYWCSLeinx7fvMGZ/mqyfxqq+o/5R/d8/05ZmiR0v5
	 iG237q4UpVzm/WwTh40PnVPkCBM27ajwLsWz4tkeXyrz2O9wP5S1eAOTd817uT4Izcr+6
	 6EoB+10JQP8yRLJooeZ/KYI+t3sksht47I8iXCrLovCvi2yLRf19OBQTXL+R+iO4Sg38w
	 6/duvzy/5hATNihAfjP99G/FvDF7w4J+p5/cOJKfGbJekDjD/n68IPBc8r/VYPK7pXerb
	 s45nW9GYzVu8+KALRB8r6f7qPCii/c800C+qfqvMzOmeWhpTuriBddA4D0HMTZ/UJvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=MQtY6NIt;
	arc=none smtp.remote-ip=95.215.58.21
Received: from mta1.migadu.com (out-21.mta1.migadu.com [95.215.58.21])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15584606A31F
	for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 18:37:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 15584606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=MQtY6NIt
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=JOx3d+X1zVfHWepWY8CK1e2hQWjyfmWSp9MXd/S2URA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794767850; v=1; x=1795372650;
 b=MQtY6NItBSPHeo5XNdLlKlS12p92qKMsy4V0enD0O77WNlcb7TDZf845urA7TjXonFBJq4Ji
 zAm7/p++WuudAXJcLRxqdhmOfwW23QU8vARBC/g4hdn26LyT1gB3sPC/nuLaFo2rYet5uS4lFpX
 dhMsZbSSGUrzPp83vGJOrFjw=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 8bdf4a6ce8e839ca;
	Sun, 15 Nov 2026 18:37:30 +0000
X-Mizu-Trace-ID: 8bdf4a6ce8e839ca
X-Migadu-Flow: FLOW_OUT
Message-ID: <84b50119-cb4a-4bda-9ab8-7b590216858e@linux.dev>
Date: Sun, 15 Nov 2026 18:37:28 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 01/29] scsi: core: Clear cmd->flags for terminal
 queuing error
To: Bart Van Assche <bvanassche@acm.org>,
 james.bottomley@hansenpartnership.com, mkp@kernel.org
Cc: hare@suse.com, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, snitzer@kernel.org, jmeneghi@redhat.com,
 bmarzins@redhat.com, dm-devel@lists.linux.dev, hch@lst.de,
 michael.christie@oracle.com
References: <20261108204733.557995-1-john.garry@linux.dev>
 <20261108204733.557995-2-john.garry@linux.dev>
 <060d5e0d-764e-40bd-8bb7-ead8d4ada5b0@acm.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <060d5e0d-764e-40bd-8bb7-ead8d4ada5b0@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/9/26 20:49, Bart Van Assche wrote:
> On 11/8/26 12:47 PM, John Garry wrote:
>  > If a request can't be queued in scsi_queue_rq(), then we error out
>  > with a blk_status_t code. Such a scenario may be the scsi_device has
>  > its transport offline. For BLK_STS_RESOURCE or BLK_STS_AGAIN, the
>  > request will be requeued in the block layer.
> 
> This is not correct for BLK_STS_AGAIN. Only BLK_STS_RESOURCE and
> BLK_STS_DEV_RESOURCE cause the block layer to requeue a request. For
> all other status codes, including BLK_STS_AGAIN,
> blk_mq_dispatch_rq_list() and blk_mq_try_issue_directly() call
> blk_mq_end_request().

ok, right

> 
>  > For other errors, the block layer ends the request and so we won't
>  > see it again (until recycled). Normally when a request completes
>  > scmd->flags is cleared in scsi_end_request(). However for the error
>  > scenario mentioned above, scsi_end_request() is not called and so
>  > scmd->flags is not cleared. As such, when the request is recycled we
>  > see the old value in scmd->flags.
> 
> Please describe the consequences of this bug in the patch description.
> As far as I can tell there are at least two:
> - SCMD_FAIL_IF_RECOVERING is part of SCMD_PRESERVED_FLAGS and
>    scsi_execute_cmd() ORs new flags into scmd->flags. If a command
>    submitted with SCMD_FAIL_IF_RECOVERING is failed with BLK_STS_OFFLINE
>    because the host is in recovery, the flag leaks into the next request
>    that is allocated with the same tag. That request will then be failed
>    instead of requeued if it is submitted while the SCSI error handler
>    is active.
> - If SCMD_INITIALIZED leaks, scsi_init_command() skips
>    scsi_initialize_rq() for the next filesystem request. Hence,
>    jiffies_at_alloc and retries are not reinitialized and that request
>    may be failed prematurely by scsi_cmd_runtime_exceeded().
 > >  > Fix this issue by clearing scmd->flags in the error scenario 
mentioned
>  > by calling scsi_cleanup_rq().
> 
> Please add Fixes: and Cc: stable tags. For the SCMD_FAIL_IF_RECOVERING
> leak, I think this should be:
> 
> Fixes: 310bcaef6d7e ("scsi: core: Support failing requests while 
> recovering")

I am more inclined to go back to some commit pre-LTS v5.15, which is the 
oldest LTS maintained today. Even if you check 64104f703212f, I'd say 
that the issue existed then.

> 
>  > @@ -1994,8 +1994,8 @@ static blk_status_t scsi_queue_rq(struct 
> blk_mq_hw_ctx *hctx,
>  >           * we hit an error, as we will never see this command
>  >           * again.
>  >           */
>  > -        if (req->rq_flags & RQF_DONTPREP)
>  > -            scsi_mq_uninit_cmd(cmd);
>  > +        scsi_cleanup_rq(req);
>  > +        scsi_run_queue_async(sdev);
> 
> Since the block layer also ends requests for which scsi_queue_rq()
> returns BLK_STS_AGAIN, the BLK_STS_AGAIN case has the same issue.
> Please convert that case too:
> 
>      case BLK_STS_AGAIN:
>          cmd->result = DID_BUS_BUSY << 16;
>          scsi_cleanup_rq(req);
>          break;
> 

ok, fine. BTW, does anyone ever check cmd->result in this case, or are 
we just exercising good practice to set the result to failed?

> Although no SCSI driver returns BLK_STS_AGAIN today, I think both
> error paths should handle this in the same way.
> 
Hi Martin, I would really rather not post yet another version of this 
series. How about send the extra change which Bart requested separately?

Thanks,
John
