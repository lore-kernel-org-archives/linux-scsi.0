Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F21E63B;
	Tue,  6 Feb 2024 00:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707178073; cv=none; b=pHOuOpj9/LbHmGggqSqiln2LJcBkA+eOewOcJWUbjkAZ+qyuV8DC9rBIvDs8AhNM5FKftLisL7p8eVDEaid/d/yEhEx9VKwveEmrkhMINuE7iuKY+Xu+PwHf+yZgGvzVnQMISrylgfU37aGRYiD3yHcD51is5pSC1ulV4HWDUAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707178073; c=relaxed/simple;
	bh=LHVAb8c/glKRgQdSgG3vaEe4H8FRHd+rnW5Xuzxk3+w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VpibDhBfD7nFUMQ4VVgKQl8shbYuVothIp4E/jXawtZBxJ1FTKPia/D9rEYlVIGZBbthft3XrPqsX5A7DJQ5k2s9RYrmj8xr51vpufyY2ihlsYb5hDBdI20467oibLv6Gg67uwhSKILl2jKgTF66+O7+yEk1cKEcifE9A/5yChM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e3q0dTK5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e3q0dTK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D79C433F1;
	Tue,  6 Feb 2024 00:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707178073;
	bh=LHVAb8c/glKRgQdSgG3vaEe4H8FRHd+rnW5Xuzxk3+w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=e3q0dTK51/vEWjlqKNYNZg4Y813QwSJzFIpwcbu+zrYJFYQfyihiw2MeI/VCUEvKX
	 wSF3RJpxJEpFE7Whcp49WJ1ftUdSn0ntTeGf1fAA9XYMCfbrZG5KL78VAcR3zifcL/
	 zM/I/hdWVAYqt0C0rA0heM5fcVEGH8jLb7Dqp+2GjQAtusxfjG7WIB1n0iJXU5Jcxt
	 WA8bDtUXL8w0tzuwZSxi14OGMVzvZfGnLQdsDOgDRo9ciLUNdd0B40e6L3pxPJFbEK
	 eTQMXBeBJCYTDLQ2b/kRYP48q3Uk1ByAlOQ3P2o3cOi7tN3/yfJYjBwqZa+UJk+jdQ
	 TjgXLYf7e6fgA==
Message-ID: <548aa284-6c80-4f01-a5ce-bb16f64e9c85@kernel.org>
Date: Tue, 6 Feb 2024 09:07:50 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/26] Zone write plugging
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <fc7ab626-58ed-49bd-b692-4875d17c6556@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <fc7ab626-58ed-49bd-b692-4875d17c6556@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/6/24 03:18, Bart Van Assche wrote:
> On 2/1/24 23:30, Damien Le Moal wrote:
>>   - Zone write plugging operates on BIOs instead of requests. Plugged
>>     BIOs waiting for execution thus do not hold scheduling tags and thus
>>     do not prevent other BIOs from being submitted to the device (reads
>>     or writes to other zones). Depending on the workload, this can
>>     significantly improve the device use and the performance.
> 
> Deep queues may introduce performance problems. In Android we had to
> restrict the number of pending writes to the device queue depth because
> otherwise read latency is too high (e.g. to start the camera app).

With zone write plugging, BIOS are delayed well above the scheduler and device.
BIOs that are plugged/delayed by ZWP do not hold tags, not even a scheduler tag,
so that allows reads (which are never plugged) to proceed. That is actually
unlike zone write locking which can hold on to all scheduler tags thus
preventing reads to proceed.

> I'm not convinced that queuing zoned write bios is a better approach than
> queuing zoned write requests.

Well, I do not see why not. The above point on its own is actually to me a good
argument enough. And various tests with btrfs showed that even with a slow HDD I
can see better overall thoughtput with ZWP compared to zone write locking.
And for fast sloid state zoned device (NVMe/UFS), you do not even need an IO
scheduler anymore.

> 
> Are there numbers available about the performance differences (bandwidth
> and latency) between plugging zoned write bios and zoned write plugging
> requests?

Finish reading the cover letter. It has lots of measurements with rc2, Jens
block/for-next and ZWP...

I actually reran all these perf tests over the weekend, but this time did 10
runs and took the average for comparison. Overall, I confirmed the results
showed in the cover letter: performance is generally on-par with ZWP or better,
but there is one exception: small sequential writes at high qd. There seem to be
an issue with regular plugging (current->plug) which result in lost merging
opportunists, causing the performance regression. I am digging into that to
understand what is happening.

-- 
Damien Le Moal
Western Digital Research

