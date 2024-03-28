Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF543DAC11;
	Thu, 28 Mar 2024 05:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711605292; cv=none; b=PSOCQLq+lUpYxAKraT2in7cmMVFoSSbujeKOQGJAxUO7S+Pin5FRREanjacatKrFLg/ab8meyWSA8rqURpFYfWo36RSWxSgQk31IsP8P5alarvYy9Zo3Zbh+hNIIOOwRaLTMMyWg3sBLcfZTIPRVZEazkQ6dAK/kGRoHuseCsIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711605292; c=relaxed/simple;
	bh=R1I8/lwm7TQTj/Rx7NOR7Kh++SMDavsSyypMJXowvqQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ggyaY++4fkX5b+ohLtUffAJ+4vkdFi2AODUtrKDkokmp++Yj4iG7Ub3sljWlmh2/DBfqe3dWZBowORXPJdlPqDwNz1MzvQl5Ua4XQsPLLvXQ2XqY1wX/7RJgzdfmsdjqqQF8v3iFyjtqTC8ml3O8nDTg4/d5PLkq0mK9VC7A0pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Not8lgvv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Not8lgvv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1531FC433F1;
	Thu, 28 Mar 2024 05:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711605291;
	bh=R1I8/lwm7TQTj/Rx7NOR7Kh++SMDavsSyypMJXowvqQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Not8lgvvo57JW8mQsdE04ybsKR4cSQfq7yNynShXu/xh1N5+a8Q0V9D3OU09GPw+n
	 k0F+KvwG9M9Jbs+IAKstSG7bJlHNkESsVgOvOoAwRNN/tjIUzl+0E18WzmNG650Sau
	 frkp9ogTJYuQ14LngS1CmZ60zxhy+Cq0osDvDVPXSoozH5Pq8ehWKrcoDUskccCQ/o
	 qhiKxhFuVRFUlTYlBFkg1iA/rexA5ajHCfxn0UY3uax4N1sT+76/eZBSD+M1S2iHJU
	 U/OtpbdtnYSKQyqPgyCgMjc4tMJbFAkhtSU0PpW/VYr1C2wkKbnAveEXSBG+CZ8wxU
	 NvQjDVeV0nTWA==
Message-ID: <573649d8-c022-4c05-83bf-99b8074fd930@kernel.org>
Date: Thu, 28 Mar 2024 14:54:48 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/30] block: Introduce blk_zone_update_request_bio()
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org,
 Keith Busch <kbusch@kernel.org>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-5-dlemoal@kernel.org> <20240328041457.GC13510@lst.de>
 <86114cba-535b-41e9-9b85-bac2fbdc1ed3@kernel.org>
 <20240328054208.GA16087@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240328054208.GA16087@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/28/24 14:42, Christoph Hellwig wrote:
> On Thu, Mar 28, 2024 at 02:20:17PM +0900, Damien Le Moal wrote:
>> I do not think that is corect. Because is_flush indicates that RQF_FLUSH_SEQ is
>> set, that is, we are in the middle of a flush sequence. And flush sequence
>> progression is handled at the request level, not BIOs. Once the sequence
>> finishes, then and only then the BIO original endio should be done, meaning that
>> we will then take this path and actually do blk_zone_update_request_bio() and
>> bio_endio(). So I still think this is correct.
> 
> Well.
> 
> lk_flush_restore_request with the previous patch now restores rq->__sector,
> and the blk_mq_end_request call following it will propagate it to the
> original bio.  But blk_flush_restore_request grabs the sector from
> rq->bio->bi_iter.bi_sector, and we need to actually get it there first,
> which is done by the data I/O completion that has RQF_FLUSH_SEQ set.

Ah. Yes. There is no issue with the current code for regular writes, but we
would get the original sector and not the written sector in the case of zone
append. Will make the change.

> I think we really need a good test case for zone append and FUA,
> i.e. we need the append op for zonefs, which should exercise the
> fua code if O_SYNC/O_DSYNC is set.

Yep. There is currently no issuer of zone append + FUA. But once I get to add
that for zonefs and block dev files, we indeed will have good tstbed.

> 

-- 
Damien Le Moal
Western Digital Research

