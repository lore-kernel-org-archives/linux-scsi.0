Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37078A2D;
	Thu,  3 Jul 2025 00:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751501503; cv=none; b=We3r0kMmsZ6SQIY0eXLCmGpL629qXtlGtI0C5vvwC4a86fzFZRQiYIAbP3eYQ/pnnvpWEkEfUK9vkIy1w8jw9vRC0jC6Gjgt1lMjWhslUIEKnZaHJoIAug1UOjdzdWNrnsP7qZ6hi0umb4zYIRK/Yowu2Efiw9LyVrgCzS+vwWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751501503; c=relaxed/simple;
	bh=ciRbywmskNGjVRIsc57wU0k8B3zJqHAdyjP9LPSBKVM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RIB8GWXE5Apvwu9uEjZAsOX+pI69retc1DqIqqwWgo7tWEfyX74AJgdDzqK4KI0EfHkGAvdClYaJ9ozI6p7KoZp72taBpKzfPazAmRwSNFqDX26Em53JYXwTbqp/EhXhqh21SMkGmzykyRiuABj1dSiIDZcrknlANOO/lCAoDdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gAV0j/Ih; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gAV0j/Ih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265A2C4CEE7;
	Thu,  3 Jul 2025 00:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751501501;
	bh=ciRbywmskNGjVRIsc57wU0k8B3zJqHAdyjP9LPSBKVM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gAV0j/IhDSYsXVOss49cftKkAzDiN2Ggao3lTtG6oklxXd4Dfrz0nX8zfSDiwxm5r
	 qX45g3ZjXl2PBcg0AiMlnHqoyuWZip82qlalSc1AWgNf2CQhouuUnNwyaMaNRPolZt
	 txgkpNh/xpbqm6A8yOhjZ1mfoOyXO47U3eWmua8j71BGYEuSKIs1rVyA819YG/83ZZ
	 iQeZK8DHXDyjhgso2fTcOYzZlq5tvFwOCcJy4TN6F+emR2Y4wpeda3D5CGZEgLoecC
	 jMysoOatGSlYTqnck8736XnE8yEXUM8MWE/g+wQd6kEh9+9AC65M0TsawKp1qCCtVS
	 2eF+n9oQ5T2cQ==
Message-ID: <a97a31b0-bb6c-4c7a-8d51-d2f723a2b650@kernel.org>
Date: Thu, 3 Jul 2025 09:09:30 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 01/11] block: Support block drivers that preserve the
 order of write requests
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
 Nitesh Shetty <nj.shetty@samsung.com>, Ming Lei <ming.lei@redhat.com>
References: <20250630223003.2642594-1-bvanassche@acm.org>
 <20250630223003.2642594-2-bvanassche@acm.org>
 <0f9f5900-b7d0-4df2-8c05-fc147c991534@kernel.org>
 <a7b5b394-ed7d-4f57-96ba-ff14375b2e7b@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <a7b5b394-ed7d-4f57-96ba-ff14375b2e7b@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 7/3/25 12:57 AM, Bart Van Assche wrote:
> On 7/2/25 3:57 AM, Damien Le Moal wrote:
>> On 7/1/25 07:29, Bart Van Assche wrote:
>>> diff --git a/block/blk-settings.c b/block/blk-settings.c
>>> index a000daafbfb4..bceb9a9cb5ba 100644
>>> --- a/block/blk-settings.c
>>> +++ b/block/blk-settings.c
>>> @@ -814,6 +814,8 @@ int blk_stack_limits(struct queue_limits *t, struct
>>> queue_limits *b,
>>>       }
>>>       t->max_secure_erase_sectors = min_not_zero(t->max_secure_erase_sectors,
>>>                              b->max_secure_erase_sectors);
>>> +    t->driver_preserves_write_order = t->driver_preserves_write_order &&
>>> +        b->driver_preserves_write_order;
>>
>> Why not use a feature instead ? Stacking of the features does exactly this, no ?
>> That would be less code and one less limit.
> 
> Hi Damien,
> 
> Thanks for the feedback. I will look into making this change.
> 
> Please also help with reviewing the other patches in this series.
> Progress on this patch series has been slow so far because every time I
> post this patch series reviewer feedback is provided on less than 10% of
> the code in this patch series.

I am still trying to wrap my head around what you are doing with these patches,
which is to allocate and submit a BIO from one CPU using the ctx (soft queue)
of another CPU, if I understood things correctly (your commit messages are
still a little too dry and do not explain a lot, especially the why...).

So far, I am not liking what I am seeing because I think it is dangerous given
all the per_cpu things around. I do not see how it can be safe to play with one
BIO from one CPU to be issued on another.

I did suggest that you simply should plug all BIOs, always, and have them
submitted by the BIO work for a zone by scheduling that work on a single CPU,
always the same CPU. Doing so, you can distribute writes to different zones to
different CPUs. And if the submitter process is not bouncing all over the place
(being rescheduled constantly on different CPUs), there will be no overhead
because you can simply run the BIO work on the current CPU.

-- 
Damien Le Moal
Western Digital Research
