Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6ED319860;
	Mon,  1 Dec 2025 16:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764606392; cv=none; b=KgZZvfCBsXorGk+1hg4BKbeebARrDcgNSTFP/eyrci+mVTq8OJawS/W7SurTh65LnctCMsMh2Rhv4dn1CNOSbvWsik7MrtOa5GN5jK69pYM7VDnALncAt/mveA3ZeXuckrY89u7JYE5/UHXbv09ci1omkR+CZ3YPIfeSOF8tFeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764606392; c=relaxed/simple;
	bh=svSOkwWJi2p/kuYLhrjOtrS2/POoZwGwh72SVTyxwQQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hKTnX5izPvJrA4Xu+2US1/xY6RYiJ1OMHDsg1VlHq8Ug7UFiD3S6ntl7MmKd62zFntURZp3RV+N7gec/4ensM5sknTeoKfGAoWNOiUAP8UQWtEQt0U9wQmCNENaHYeh1tq3xAKx06Xu1ncAbn1NNnA0SA/Cx18i3QsYO2DX0leE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BHfJk4W/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BHfJk4W/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B873C4CEF1;
	Mon,  1 Dec 2025 16:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764606392;
	bh=svSOkwWJi2p/kuYLhrjOtrS2/POoZwGwh72SVTyxwQQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BHfJk4W/+KnkpPfeGZMWdd8R/Dzodczxx2SHaCE9vV+ZAwtDiePAUW4CRgmIHSWSs
	 V1BlAk8JGxCUaeVE4ednVBYmH6sUNvy9zyqhw5RGrCdasFqu6Xgd0nYVl0OkshTcue
	 nbD/4xAA66n2F9NletrJ0gwae6nnSUqfKtH3wLgKggxtBSlpx60rdMPYYlEqb/VKYz
	 UlI8VxQJwU58cGpV/ayQvCc5bZlRkXV4ha15TXy279x0BGoGncZI8sCOwkC9NgG4Xp
	 CdHFuLI8cbm9u/CIypG/HBrD15DdQsq9GdSx3HYKFsFKyKGr54B02wubvooOVC3BFy
	 tdBGTfNW4gxCQ==
Message-ID: <fadbd728-6810-49de-905d-214c2f72a857@kernel.org>
Date: Mon, 1 Dec 2025 17:26:27 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] block: add IOC_PR_READ_KEYS ioctl
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-block@vger.kernel.org,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-kernel@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Mike Christie <michael.christie@oracle.com>, Jens Axboe <axboe@kernel.dk>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20251126163600.583036-1-stefanha@redhat.com>
 <20251126163600.583036-4-stefanha@redhat.com>
 <cfd7cace-563b-4fcb-9415-72ac0eb3e811@suse.de>
 <89bdc184-363c-4d14-bad6-dd4ab65b80d9@kernel.org>
 <20251201150636.GA866564@fedora>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 a/A=
In-Reply-To: <20251201150636.GA866564@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 01/12/2025 16:06, Stefan Hajnoczi wrote:
> On Sat, Nov 29, 2025 at 03:32:35PM +0100, Krzysztof Kozlowski wrote:
>> On 27/11/2025 08:07, Hannes Reinecke wrote:
>>>
>>>> +	size_t keys_info_len = struct_size(keys_info, keys, inout.num_keys);
>>>> +
>>>> +	keys_info = kzalloc(keys_info_len, GFP_KERNEL);
>>>> +	if (!keys_info)
>>>> +		return -ENOMEM;
>>>> +
>>>> +	keys_info->num_keys = inout.num_keys;
>>>> +
>>>> +	ret = ops->pr_read_keys(bdev, keys_info);
>>>> +	if (ret)
>>>> +		return ret;
>>>> +
>>>> +	/* Copy out individual keys */
>>>> +	u64 __user *keys_ptr = u64_to_user_ptr(inout.keys_ptr);
>>>> +	u32 num_copy_keys = min(inout.num_keys, keys_info->num_keys);
>>>> +	size_t keys_copy_len = num_copy_keys * sizeof(keys_info->keys[0]);
>>>
>>> We just had the discussion about variable declarations on the ksummit 
>>> lists; I really would prefer to have all declarations at the start of 
>>> the scope (read: at the start of the function here).
>>
>> Then also cleanup.h should not be used here.
> 
> Hi Krzysztof,
> The documentation in cleanup.h says:
> 
>  * Given that the "__free(...) = NULL" pattern for variables defined at
>  * the top of the function poses this potential interdependency problem
>  * the recommendation is to always define and assign variables in one
>        ^^^^^^^^^^^^^^
>  * statement and not group variable definitions at the top of the
>  * function when __free() is used.
> 
> This is a recommendation, not mandatory. It is also describing a
> scenario that does not apply here.

If you have actual argument, so allocation in some if branch, the of course.

> 
> There are many examples of existing users of __free() initialized to
> NULL:
> 
>   $ git grep '__free(' | grep ' = NULL' | wc -l
>   491
> 

There is tons of incorrect usage, some I started already fixing.
Maintainers were changing when applying the correct code (correct patch)
into incorrect declaration without constructor and separate assignment.

Then contributors started adding patches at least making NULL
assignment, but still not following recommendation.

Then contributors started adding patches mixing cleanup.h with gotos,
also clearly discouraged.

Sorry, but please never use that argument. People did not read cleanup.h
and produced poor code. Maintainers did not read cleanup.h and changed
correct code into poor code.

Existing poor code, just its existence, is never the actual argument in
discussion.

> To me it seems like it is okay to use cleanup.h in this fashion. Did I
> miss something?



Best regards,
Krzysztof
