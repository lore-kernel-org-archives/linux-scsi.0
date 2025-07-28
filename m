Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980D919D09C;
	Mon, 28 Jul 2025 07:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753688806; cv=none; b=ZwNqQveAyJNSFIT7AKpBfudvxOKlYkcakO3Quyf5vFcFKBV5e6EVAIgWn8EegEZaeKlV+gRk580ijPLXxz11E+dVa1d8J/oHQynxTNyGQUbyk0+DqYDZBNsNpcx4H+9Amq2W/d0AhQu0sO1U7Ba7kiDLamDI8jnUA89OCCqWa+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753688806; c=relaxed/simple;
	bh=wPMAgCo78CSUFgTRwa6J+xWxxs7B9n+X+mKNLhmxlPQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JIjFIzH6JuPZ2owT2OJr0JArh/0j2bdvVRM2pxZbxY8BURpaieeXZYMQLSv5GhYt7n6+0eb9OUoC1vTIts+xm5BRQLKBoCuNainm320MXbfv1d6Lj4OyWXNdmy9opFEjgX2q5bD7WDnLBHwRteQqm2IU6/pOBMP+K5LYofsKEEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q9pAXjRp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q9pAXjRp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7664C4CEE7;
	Mon, 28 Jul 2025 07:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753688806;
	bh=wPMAgCo78CSUFgTRwa6J+xWxxs7B9n+X+mKNLhmxlPQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=q9pAXjRpHtfETH41PFoSRhMNDE6KW96W7d3VQSdxiffZeFWMWQvMoxBylfBMdA2FW
	 z5TVPV5ikkjRXo7SiyLO0JeQ3T3q6FEgAnVEykriQz4ci7MtULLOrEJhzkj6CL5t8U
	 4Vkp/U4fY9Too1qTWd1u5CyPICNs1bpbEhp1l9Wk9RXksQVhbA5JXsDw27ijTDG98n
	 iE5O3xSu2g4I9EtEDcbXFNfbs+FyLH42O5KyzkJ/SFQvNFmHi+I+21e+tHopqBfXOk
	 9y12rwjEtriSez+V3OdTqfb8pzAgCcuK+KuZcyiSwtls+VUFyZTacDpVMsICLmckWa
	 pdUhG2h14cKYA==
Message-ID: <fa2f9406-4ee8-45f9-a784-b5042e9f4411@kernel.org>
Date: Mon, 28 Jul 2025 16:44:14 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Improper io_opt setting for md raid5
To: Yu Kuai <yukuai1@huaweicloud.com>, =?UTF-8?Q?Csord=C3=A1s_Hunor?=
 <csordas.hunor@gmail.com>, Coly Li <colyli@kernel.org>, hch@lst.de
Cc: linux-block@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <ywsfp3lqnijgig6yrlv2ztxram6ohf5z4yfeebswjkvp2dzisd@f5ikoyo3sfq5>
 <bdf20964-e1ee-45a9-bf24-3396e957ff67@gmail.com>
 <2b22f745-bbd5-4071-be9b-de9e4536f2d5@kernel.org>
 <6ab1be6e-380b-d4aa-dd71-f53373a66e29@huaweicloud.com>
 <655cb7e6-897a-4fab-a8ce-8832f2bc7274@kernel.org>
 <4767823c-2332-b3e1-67a6-2d7f55b48156@huaweicloud.com>
 <a1626eef-9846-4824-a899-2fbd8e369fac@kernel.org>
 <9c6f300a-f78f-de6e-4b99-453df377c7ba@huaweicloud.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <9c6f300a-f78f-de6e-4b99-453df377c7ba@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 7/28/25 4:14 PM, Yu Kuai wrote:
>>> With git log, start from commit 7e5f5fb09e6f ("block: Update topology
>>> documentation"), the documentation start contain specail explanation for
>>> raid array, and the optimal_io_size says:
>>>
>>> For RAID arrays it is usually the
>>> stripe width or the internal track size.  A properly aligned
>>> multiple of optimal_io_size is the preferred request size for
>>> workloads where sustained throughput is desired.
>>>
>>> And this explanation is exactly what raid5 did, it's important that
>>> io size is aligned multiple of io_opt.
>>
>> Looking at the sysfs doc for the above fields, they are described as follows:
>>
>> * /sys/block/<disk>/queue/minimum_io_size
>>
>> [RO] Storage devices may report a granularity or preferred
>> minimum I/O size which is the smallest request the device can
>> perform without incurring a performance penalty.  For disk
>> drives this is often the physical block size.  For RAID arrays
>> it is often the stripe chunk size.  A properly aligned multiple
>> of minimum_io_size is the preferred request size for workloads
>> where a high number of I/O operations is desired.
>>
>> So this matches the SCSI limit OPTIMAL TRANSFER LENGTH GRANULARITY and for a
>> RAID array, this indeed should be the stride x number of data disks.
> 
> Do you mean stripe here? io_min for raid array is always just one
> chunksize.

My bad, yes, that is the definition in sysfs. So io_min is the stride size, where:

stride size x number of data disks == stripe_size.

Note that chunk_sectors limit is the *stripe* size, not per drive stride.
Beware of the wording here to avoid confusion (this is all already super
confusing !).

Well, at least, that is how I interpret the io_min definition of
minimum_io_size in Documentation/ABI/stable/sysfs-block. But the wording "For
RAID arrays it is often the stripe chunk size." is super confusing. Not
entirely sure if stride or stripe was meant here...


>> * /sys/block/<disk>/queue/optimal_io_size
>>
>> Storage devices may report an optimal I/O size, which is
>> the device's preferred unit for sustained I/O.  This is rarely
>> reported for disk drives.  For RAID arrays it is usually the
>> stripe width or the internal track size.  A properly aligned
>> multiple of optimal_io_size is the preferred request size for
>> workloads where sustained throughput is desired.  If no optimal
>> I/O size is reported this file contains 0.
>>
>> Well, I find this definition not correct *at all*. This is repeating the
>> definition of minimum_io_size (limits->io_min) and completely disregard the
>> eventual optimal_io_size limit of the drives in the array. For a raid array,
>> this value should obviously be a multiple of minimum_io_size (the array stripe
>> size), but it can be much larger, since this should be an upper bound for IO
>> size. read_ahead_kb being set using this value is thus not correct I think.
>> read_ahead_kb should use max_sectors_kb, with alignment to minimum_io_size.
> 
> I think this is actually different than io_min, and io_opt for different
> levels are not the same, for raid0, raid10, raid456(raid1 doesn't have
> chunksize):
>  - lim.io_min = mddev->chunk_sectors << 9;

See above. Given how confusing the definition of minimum_io_size is, not sure
that is correct. This code assumes that io_min is the stripe size and not the
stride size.

>  - lim.io_opt = lim.io_min * (number of data copies);

I do not understand what you mean with "number of data copies"... There is no
data copy in a RAID 5/6 array.

> And I think they do match the definition above, specifically:
>  - properly multiple aligned io_min to *prevent performance penalty*;

Yes.

>  - properly multiple aligned io_opt to *get optimal performance*, the
>    number of data copies times the performance of a single disk;

That is how this field is defined for RAID, but that is far from what it means
for a single disk. It is unfortunate that it was defined like that.

For a single disk, io_opt is NOT about getting optimal_performance. It is about
an upper bound for the IO size to NOT get a performance penalty (e.g. due to a
DMA mapping that is too large for what the IOMMU can handle).

And for a RAID array, it means that we should always have io_min == io_opt but
it seems that the scsi code and limit stacking code try to make this limit an
upper bound on the IO size, aligned to the stripe size.

> The orginal problem is that scsi disks report unusual io_opt 32767,
> and raid5 set io_opt to 64k * 7(8 disks with 64k chunksise). The
> lcm_not_zero() from blk_stack_limits() end up with a huge value:
> 
> blk_stack_limits()
>  t->io_min = max(t->io_min, b->io_min);
>  t->io_opt = lcm_not_zero(t->io_opt, b->io_opt);

I understand the "problem" that was stated. There is an overflow that result in
a large io_opt and a ridiculously large read_ahead_kb.
io_opt being large should in my opinion not be an issue in itself, since it
should be an upper bound on IO size and not the stripe size (io_min indicates
that).

>> read_ahead_kb should use max_sectors_kb, with alignment to minimum_io_size.
> 
> The io_opt is used in raid array as minimal aligned size to get optimal
> IO performance, not the upper bound. With the respect of this, use this
> value for ra_pages make sense. However, if scsi is using this value as
> IO upper bound, it's right this doesn't make sense.

Here is your issue. People misunderstood optimal_io_size and used that instead
of using minimal_io_size/io_min limit for the granularity/alignment of IOs.
Using optimal_io_size as the "granularity" for optimal IOs that do not require
read-modify-write of RAID stripes is simply wrong in my optinion.
io_min/minimal_io_size is the attribute indicating that.

As for read_ahead_kb, it should be bounded by io_opt (upper bound) but should
be initialized to a smaller value aligned to io_min (if io_opt is unreasonably
large).

Given all of that and how misused io_opt seems to be, I am not sure how to fix
this though.

-- 
Damien Le Moal
Western Digital Research
