Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB8513C3D3;
	Thu, 21 Nov 2024 03:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732159217; cv=none; b=QMg1ocAV+tVVdY5hB5GumB0cxQEtuqk278DM89oaeHDPPL4BKtm7T18w+c2n2fPD3u0nd84xgdjOX1a3FS3iWlaZWVE7hKLNrxta7o5e2WkK+/t4s97EbUsfboV+I/0d2vEOuRa/v6RBBmbtxyHFW2fKISMwr1klCb7Ytl/XDOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732159217; c=relaxed/simple;
	bh=MC3RFGhGWiA3GAz90LPHnNqEKTvz9BkzkXD0BSzIhps=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gEpAogIcKXzbJLaAzxuQsz1WNM6YphbQ+dzp15zeL18IDZNv3ULkv+Yfc0mONlRSjnFHZLFC/W49v2Ij2oycjImqC3Z0LvqYyd4T2nW5WA/Uh6q1+8NUQp4taS6BObiTK/EY6DSbUFRDMK8CDkTMbLhHaeoGY4H6E97tOrNiYeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iFVWIzsT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iFVWIzsT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3488AC4CECD;
	Thu, 21 Nov 2024 03:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732159216;
	bh=MC3RFGhGWiA3GAz90LPHnNqEKTvz9BkzkXD0BSzIhps=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iFVWIzsT3fznLwc5AScWLtYwT8vYUhkdYLfGcE5KGavxzJRBw2r5pzKbKFwgz68mU
	 0QVdzQpguBTwSWMEmSv5NWflGZJJL8n7CUJ4VBH7HqboaqN/F0u1uh0WdSzP8YUNWb
	 cJlulsuJiGrfuMp4PYijul/3TVI60ozH3aJYu9WaLlK7/MJMztA7kRAdIdfxZc7FQN
	 U34DkmYREiRdEd6tyiP94HGZkcnx9EHIzZFrq5ZLXl2C0gH5v6Lpj3nstHupkV66b/
	 RYqn7mz5WX34HFxCpcQWQLjaCScBwoPIGVxu3tx43WyAAUIIdpH8ycd0TPcjkLUYMm
	 GHUc09DxcOiFQ==
Message-ID: <d594be95-2cbf-4f9c-8508-d7adcedb148b@kernel.org>
Date: Thu, 21 Nov 2024 12:20:14 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 00/26] Improve write performance for zoned UFS devices
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <95ab028e-6cf7-474e-aa33-37ab3bccd078@kernel.org>
 <de43ae13-240a-4653-b8ac-f36c433d9ffb@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <de43ae13-240a-4653-b8ac-f36c433d9ffb@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/20/24 04:08, Bart Van Assche wrote:
> On 11/19/24 12:01 AM, Damien Le Moal wrote:
>> Impressive improvements but the changes are rather invasive. Have you tried
>> simpler solution like forcing unplugging a zone write plug from the driver once
>> a command is passed to the driver and the driver did not reject it ? It seems
>> like this would make everything simpler on the block layer side. But I am not
>> sure if the performance gains would be the same.
> 
> Hi Damien,
> 
> I'm not sure that the approach of submitting a new zoned write if the
> driver did not reject the previous write would result in a simpler
> solution. SCSI devices are allowed to respond to any command with a unit
> attention instead of processing the command. If a unit attention is
> reported, the SCSI core requeues the command. In other words, even with
> this approach, proper support for requeued zoned writes in the block
> layer is required.

Yes, but it would be vastly simpler because you would be guaranteed to having
only a single write request per zone being in-flight between the write plug and
the device at any time. So the requeue would not need reordering, and likely not
need any special code at all. nless I am missing something, this would be
simpler, no ?

The main question though with such approach is: does it give you the same
performance improvements as your current (more invasive) approach ?

> Additionally, that approach is not compatible with using .queue_rqs().
> While the SCSI core does not yet support a .queue_rqs() callback, I
> think it would be good to have this support in the SCSI core.

I do not understand why it is not compatible. What is the problem ?

> If we need requeuing support anyway, why to select an approach that
> probably will result in lower performance than what has been implemented
> in this patch series?

I am only trying to see if there is not a simpler approach than what you did.
The less changes, the better, right ?

-- 
Damien Le Moal
Western Digital Research
