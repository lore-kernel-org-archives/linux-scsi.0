Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B000117C91;
	Sat, 18 Oct 2025 05:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760765485; cv=none; b=uo+VxK0/3sgf8g3QBHkfI0aazqkZCeliRcdby6U2JoM0lnDqTDkn4mXTzItjqxRe+71/92GfyLVck7v0rqNN+nGZ4LUfzjwUW+Uu3iGLC9DksOg/lTTAADTHezb8SZvuRzHzK0hjtCRU9Vnd3eLQ1XHWE48HI0N3CdoFXhdPnXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760765485; c=relaxed/simple;
	bh=+DrabyyUEfaw1rx6lwDamN6AJOivU3Ylaj3frD2nU+w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EMUopgUA3Nz8ENp+wOX82FrJh0Pr3W/laJ8uUYaxAoElXQsLPFCoZBAXkVuhFAQXyWvOU+MIX3JvQC6GCVh9lkmAM5ZOKlE/V6jfx5SnS90x0RDI8u/7tc9T3YH4PX/xYXoz0sfI4OtMnMmw5rcEgzCJNJVyj3KHyRcCjW2NK4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pDw0R0D/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pDw0R0D/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D07C4CEF8;
	Sat, 18 Oct 2025 05:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760765485;
	bh=+DrabyyUEfaw1rx6lwDamN6AJOivU3Ylaj3frD2nU+w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pDw0R0D/uuswInDSgY/54iOKbVabxIG9mFOYAFSVDU2DaDAGR2nMF2cbhm4SjAMEm
	 baGcTBRLtqDaVvUtK5gwiQw4afVvMYpwO1Jwj0IL7pvpR0hsZoP8grjXIiOdaBKctU
	 /b5QEqPpDETb159G821mCfcqEqEXQbIyF8gZRKZB4LdM6I6v3VeGBapqpk0YW2JcR5
	 iirmDpc6b9CbItbipZAC1reX79lGjtki4JuKNLrCpNlb5bQnYTc78WUh35zMcUrppB
	 VY2Ubw4MPtEwewU+35XFtpgEHOeTqu8+PBI3nJ73m+d2TPu5RdxRKyDRshytENYC7d
	 eeMQDUivwEVyw==
Message-ID: <136efbd2-babc-4f07-871f-f1464a2ec546@kernel.org>
Date: Sat, 18 Oct 2025 14:31:23 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v25 07/20] block/mq-deadline: Enable zoned write
 pipelining
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20251014215428.3686084-1-bvanassche@acm.org>
 <20251014215428.3686084-8-bvanassche@acm.org>
 <08ce89bb-756a-4ce8-9980-ddea8baab1d1@kernel.org>
 <a1850fbc-a699-4e73-9fb7-48d4734c6dd3@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <a1850fbc-a699-4e73-9fb7-48d4734c6dd3@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/17/25 05:50, Bart Van Assche wrote:
> On 10/15/25 12:31 AM, Damien Le Moal wrote:
>> it seems to me that what you are trying to do can be generic in the
>> block layer and leave mq-deadline untouched.
> Hi Damien,
> 
> After having given this some further thought, I think that write
> pipelining can be enabled if an I/O scheduler is active by serializing
> blk_mq_run_dispatch_ops() calls, e.g. with a mutex. For mq-deadline and
> BFQ a single mutex per request queue should be used. For Kyber one mutex
> per hwq should be sufficient. With this approach it may be necessary to
> use different hardware queues for reads and writes to prevent that read
> performance is affected negatively. Inserting different types of
> requests into different hardware queues is already supported - see e.g.
> blk_mq_map_queue(). Please let me know if you want me to look further
> into this approach.

As mentioned before, I really do not like the idea of having to spread zone
write ordering all over the place again. Zone write plugging isolated that,
removing all dependencies on other block layer features like the IO scheduler.
Having to modify these again is not making progress, but going backward.

Maybe we need to rethink this, restarting from your main use case and why
performance is not good. I think that said main use case is f2fs. So what
happens with write throughput with it ? Why doesn't merging of small writes in
the zone write plugs improve performance ? Wouldn't small modifications to f2fs
zone write path improve things ?

If the answers to all of the above is "no/does not work", what about a different
approach: zone write plugging v2 with a single thread per CPU that does the
pipelining without to force changes to other layers/change the API all over the
block layer ? And what about unplugging a zone write plug from the device driver
once a request is issued ? etc.

I find what you did to be too invasive. I am still trying to think of a
better/simpler approach to solve your problem. But I do not have zoned UFS
hardware to test anything, so I can only think about solutions. Unless you have
a neat way to recreate the problem without Zoned UFS devices ?


-- 
Damien Le Moal
Western Digital Research
