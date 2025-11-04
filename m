Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642C42D3755;
	Tue,  4 Nov 2025 12:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762258079; cv=none; b=jAMWaSL0TY/ntVnX3PKtCNKfiN/rOnsoB2MQCIJg/3HNvDXEooWhhFm2aXApvNm6FXk7mN5ezYP+aL++tDLHzCkmXHn5N3d5koypK902UcBoaWljlok70nkJVxrf3CKyqP+R/uRKtFwKF1YHezUbpp2mWXO9i5wb3hXHm8dVyHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762258079; c=relaxed/simple;
	bh=mhQ3KHLkqGYbo/g1xFR6jX3qwUPqPMMpVaLpTTbtaQg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I8rx7ds5FOf6GaubCLac8YOraimZ4/W35u5k/kuPs6EGPwavj3dAHI1NHis1k/aq0ELXhOoaLo7h4Z3xet1CO0tCg+Y7v4MFhmCIBEVGvnZMS6tyq8Oy2xsEwQqgytKyu37tf+Gn2ASUCfmQc5jxYXmCor7oWehHdsmTyCBl2nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oPDuxtVN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oPDuxtVN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39D9C4CEF7;
	Tue,  4 Nov 2025 12:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762258079;
	bh=mhQ3KHLkqGYbo/g1xFR6jX3qwUPqPMMpVaLpTTbtaQg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oPDuxtVNaOkNeBRJkeP6cwjpYbZfu6E64GE3hqhhfsyvg64p39TzWnl+qGJ8Kyili
	 G+8nXBnWp+xFMPVoiWFAa9yF0hJ5r2LKZUv8tpMQbMslswc3G8iBwUbuGmHzS3esff
	 BUUcskn9yQ3gjhO837bV5YWBMy+qe4NuhnKpMpasjtCgV+PoKTDYN5Xz/eiHvudT5N
	 Rwb+sCSJWjcJp+ipFALmyfS/vGM+kIasuWTF5RKjEQGoS5I/ur8ZsgxVSQXjIw/TiZ
	 7rZhwIbnpjRaFlvS8QEV918zm2fOnqNiPJAGFj7X6QqpN73DLyNfiz/QxnK09UT8J7
	 8WUkPs4Fnvagw==
Message-ID: <180f16e4-851a-4009-8193-1efa41734afa@kernel.org>
Date: Tue, 4 Nov 2025 21:07:56 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ATA PASS-THROUGH latency regression after exposing blk-mq
 hardware queues
To: John Garry <john.g.garry@oracle.com>, Igor Pylypiv <ipylypiv@google.com>,
 Niklas Cassel <cassel@kernel.org>, John Garry <john.garry@huawei.com>
Cc: Jens Axboe <axboe@kernel.dk>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 linux-block@vger.kernel.org
References: <20251103170308.3356608-1-ipylypiv@google.com>
 <51db9579-f78d-4192-93fa-b252fe954d13@kernel.org>
 <c911b6fa-84d1-44a5-a668-6b46dbd00423@oracle.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <c911b6fa-84d1-44a5-a668-6b46dbd00423@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/4/25 18:10, John Garry wrote:
> On 03/11/2025 22:51, Damien Le Moal wrote:
>> On 11/4/25 02:03, Igor Pylypiv wrote:
>>> Hello,
>>>
>>> I'm observing significant latency regressions for ATA PASS-THROUGH
>>> commands that started after commit 42f22fe36d51 ("scsi: pm8001:
>>> Expose hardware queues for pm80xx"). It looks like the libata's deferral
>>> logic that relies on returning SCSI_MLQUEUE_DEVICE_BUSY does not work
>>> correctly for blk-mq's multiple hardware queues.
>>>
>>> Here's what I've figured out after some tracing:
>>>
>>> ATA PASS-THROUGH commands get continously deferred because NCQ queue is
>>> not yet drained. At the same time, other hardware queues (other CPUs)
>>> keep issuing more data commands effectively preventing the NCQ queue
>>> from draining. Since NCQ queue is not getting drained, ATA PASS-THROUGH
>>> commands can get starved for a really long time e.g. ~5 minutes.
>>
>> We already received a report of such issue, a while back. But being busy with
>> other things, it fell through the cracks.
>>
>> Note that the issue is not just for passthrough commands, but rather for
>> commands which trigger ap->ops->qc_defer() returning true, that is (most of the
>> time) a non-NCQ command issued while NCQ commands are on-going. It just happen
>> that most pasthrough commands are non-NCQ.
>>
>> I think it is time to address this command starvation issue...
>>> Reverting 42f22fe36d51 seems like a plausible workaround but I think that
>>> driver might still benefit from using multiple hardware queues e.g. to
>>> issue commands to different drives from other hardware queues. It seems
>>> like there should be a way to drain/freeze all hardware queues before
>>> issuing ATA PASS-THROUGH commands but I haven't yet figured out how to do
>>> that.
>>
>> Yes, we need to remember the fact that a deferred command exists/was issued. But
>> that is not trivial to handle unless we introduce a workqueue in libata that
>> handle these, draining the queue when needed. But that would mean that we keep
>> on hand commands that are not being issued, which is something that the block
>> layer better handles (with a requeue).
>>
>> So in the end, I think that the better solution is to look at the scsi & block
>> layers requeue path for deferred commands and make sure that these commands are
>> at the head of the dispatch queue, always, to ensure that the next time they are
>> issued, they are issued first and will eventually get a chance to run once all
>> on-going requests complete.
>>
>>> If you have any ideas or suggestions on how to fix this issue and/or what
>>> things to try, please share. If you happened to have patches that would
>>> fix the issue I would gladly review and test the patches.
>>
>> Let me see with Niklas how we can handle this. We'll send something soon.
>>
> When one of these special passthorugh commands is pending, can we defer 
> NCQ commands? Or that illegal?

Not illegal at all. libata-scsi is a SAT implementation which can do that. The
problem with multi-queue HBAs is that delaying NCQ commands with also the
non-NCQ ones delayed does not guarantee that the non-NCQ command will be the
first one to show up once the queue is drained. So this is not trivial... Not
sure how to do it yet.

An "ugly" solution would be to use a submission workqueue in libata-scsi that
holds on to the non-NCQ command instead of sending it back for requeue. But
that's not pretty and holding on command in the low level driver is not great.
Still thinking.


-- 
Damien Le Moal
Western Digital Research
