Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D865E10A0F;
	Mon,  5 Feb 2024 06:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707113700; cv=none; b=C2zxzuCEAtf7vJHT9cAh2rlTbzfvvh+OYxQw0zdUzedimRkIm1Tj4teQYXei9AeVZiC/GPqJ0s9tv/X+mcFs23Yk8Q9z7yPM1Q0DwJr/NGS/W6M4XGtk6BAzDOqwlr2s987XSSRx1CcFmO2FsySPKhPLzDqX5BukUJiRaxIIngU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707113700; c=relaxed/simple;
	bh=iPgTo1r5+BVOOv0xlone20BepvLTvYfS6cu5SEtKVK0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MufVKK9c8QwFU4L1Mx1GI2xF3lKAY/U5IDsWKVUhj9703KpIKL/7Ln1/NEJNVzgsGm+gdh/plK5UGwEwdKqtY+XkBMTUMcuJHIblFILxaf6oTeSjHWh0VqAHp6l14YJzpOa9sAwOT2AMiyTzRXGdBbJhQWGB70n4NjR1ZxG1LZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RP6zMWHg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RP6zMWHg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA0BC433C7;
	Mon,  5 Feb 2024 06:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707113699;
	bh=iPgTo1r5+BVOOv0xlone20BepvLTvYfS6cu5SEtKVK0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RP6zMWHge+xTEx2u8nIVPO3XFuQbDiqjKMOqASgq77EUPZukzI/YfoSUWwngynOFD
	 8jXec7wnqYl4+dkcdPNyAy6v5D0xhU2/bHNcUDhbSkxppAoaf6Of35NtjGCnriVFFa
	 XBS598tB7KnK15lbzUctMrSixetEOPwhf4VuhN8xZ09Yc/w3ms5aNM1OEYR2QpuHB5
	 w49x0SKhIkZqZ6Re8Ha+5BNdryiuGy117alKa5oMTmA8iL3lDs/npn1fkc4JQRvkDw
	 fZY6k9ZBC8pWwREUM14YpP2yitAMis6DL180jkEb30ePY/BzGb9Aq8/KZHW7jlRieC
	 RpWZYLRtpvyRw==
Message-ID: <29d31194-c2aa-4720-a7e1-a7c4524ecbab@kernel.org>
Date: Mon, 5 Feb 2024 15:14:56 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/26] block: Introduce zone write plugging
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-7-dlemoal@kernel.org> <Zb8K4uSN3SNeqrPI@fedora>
 <a3f17ffb-872b-49cf-a1a7-553ca4a272c0@kernel.org> <ZcBFoqweG+okoTN6@fedora>
 <58fa0123-e884-4321-9b9b-8575cc7b4e1d@kernel.org>
 <20240205051159.GA17817@lst.de>
 <6e99511d-14f6-4077-87de-47ff285bc26c@kernel.org>
 <20240205055046.GA18392@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240205055046.GA18392@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/5/24 14:50, Christoph Hellwig wrote:
> On Mon, Feb 05, 2024 at 02:37:41PM +0900, Damien Le Moal wrote:
>> OK. So I think that Hannes'idea to get/put the queue usage counter reference
>> based on a zone BIO plug becoming not empty (get ref) and becoming empty (put
>> ref) may be simpler then. And that would also work in the same way for blk-mq
>> and BIO based drivers.
> 
> Maybe I'm missing something, but I'm not sure how that would even work.
> 
> We need a q_usage_counter ref when doing all the submissions checks
> (limits, bounce, etc) early in blk_mq_sunmit_bio, and that one should be
> taken using the mormal bio_queue_enter patch to do the right thing on
> nowait submissions, when the queue is already frozen, etc.  What
> is the benefit of not just keeping that references vs releasing it
> for all but the first bio just so that we need to grab another
> new reference at the actual submission time?

I just tried to make the change, but the code does not become easier/cleaner at
all. In fact, the contrary, it is very messy. I think I am going to keep things
as is regarding the ref counting.

There is one thing I need to check though: I re-ran the perf tests but this time
took the average of 10 runs to mitigate differences due to variance between runs
of the same test. And doing that, I do see a regression in performance for ZNS
4K qd=16 sequential writes (751 MB/s with rc2 vs 661 MB/s with ZWP). I need to
check if that is due to never using the cached request for plugged BIOs in
blk_mq_submit_bio(). If that is the case, we'll need to tweak the reference
dropping there for the cached request case.

I am also seeing a regression in performance with btrfs on SMR HDD (244 MB/s
with rc2 and block/for-next vs 233 MB/s with ZWP). I need to check that as well.

-- 
Damien Le Moal
Western Digital Research

