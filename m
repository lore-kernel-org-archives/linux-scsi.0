Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888E52E370E;
	Tue, 22 Jul 2025 01:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753148316; cv=none; b=kcJ/sYKdr312aGphFEGK6EA8wOglwGgsF6UlW48LFaLxcMhfH7fxzKvloty4Ev4Z0GQ/dUGW9Hj9DTWoLojX/+fTHBZVhuNmJfgdhAJS4xXqtf7DEBY4qgJgC7sItkIcogyhRw0pWiVvGmltXzWBLiMdc/U24uCUpCerp7U1qtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753148316; c=relaxed/simple;
	bh=i5zkt/hX78LyBmZYCFXh6hsLPItBh4Cf/TR+y9yEDfE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UGY6wtDAC9ixLFOGm/lNKfXHH2LLfyNW6UJlL/H6BH6l47j9C4JEjus6HAuCBTJ4hLbKdn+iyZ46S0c/RXo87D5OETD9YuPQWTEA3m7zvyw2Is3oQdCmfoDwyCg21TCYEgDtP0zOGVaUp7DCFhu/umvwZV589rV6Hf9yYHocw0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CzycaPDA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CzycaPDA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C0AC4CEF5;
	Tue, 22 Jul 2025 01:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753148315;
	bh=i5zkt/hX78LyBmZYCFXh6hsLPItBh4Cf/TR+y9yEDfE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CzycaPDA7JhZ8e3pal64Q8xioZEWvlkRJz/RGttWhh/BqkcRvEW1MewBmGVfAUCFq
	 VrUjFHhzlyUCvrFqFU0w9eqqnjOoyNxvet8okU/tBMJXmWL906HR8+b5jExjfcQyDn
	 /K19YfJZv2UEkP4d8Ap3oCeu9WOvBsVjvUJcugiDFrUjgS8Z47zZXiSa3Dl3tT3+hr
	 fBFS4wvo7Vw6GkbKM2I6fEhs1bT9Fy1mcu5NNPM2edxqNhprvBNVgw/UWIL4Zg6AaZ
	 eJnjvtQV+TeN3JwjoNFJvirRQtBIFtHg7UzWT4liWu2g/ZQkmUxlI94dXuPvj7Fvxp
	 dZpBI9NTvahOQ==
Message-ID: <15e63230-6e18-4581-a60a-a77bc3b57721@kernel.org>
Date: Tue, 22 Jul 2025 10:36:08 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 00/12] Improve write performance for zoned UFS devices
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20250717205808.3292926-1-bvanassche@acm.org>
 <f1b3060c-f951-4184-886c-87ba812986a7@kernel.org>
 <754540df-0039-47b5-ab60-44d6c4f7ac5a@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <754540df-0039-47b5-ab60-44d6c4f7ac5a@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 7/19/25 3:30 AM, Bart Van Assche wrote:
> On 7/18/25 12:08 AM, Damien Le Moal wrote:
>> How did you test this ?
> 
> Hi Damien,
> 
> This patch series has been tested as follows:
> - In an x86-64 VM:
>   - By running blktests.
>   - By running the attached two scripts. test-pipelining-zoned-writes
>     submits small writes sequentially and has been used to compare IOPS
>     with and without write pipelining. test-pipelining-and-requeuing
>     submits sequential or random writes. This script has
>     been used to verify that the HOST BUSY and UNALIGNED WRITE
>     conditions are handled correctly for both I/O patterns.
> - On an ARM development board with a ZUFS device, by running a multitude
>   of I/O patterns on top of F2FS and a ZUFS device with data
>   verification enabled.
> 
>> I do not have a zoned UFS drive, so I used an NVMe ZNS drive, which should be
>> fine since the commands in the submission queues of a PCI controller are always
>> handled in order. So I added:
>>
>> diff --git a/drivers/nvme/host/zns.c b/drivers/nvme/host/zns.c
>> index cce4c5b55aa9..36d16b8d3f37 100644
>> --- a/drivers/nvme/host/zns.c
>> +++ b/drivers/nvme/host/zns.c
>> @@ -108,7 +108,7 @@ int nvme_query_zone_info(struct nvme_ns *ns, unsigned lbaf,
>>   void nvme_update_zone_info(struct nvme_ns *ns, struct queue_limits *lim,
>>                  struct nvme_zone_info *zi)
>>   {
>> -       lim->features |= BLK_FEAT_ZONED;
>> +       lim->features |= BLK_FEAT_ZONED | BLK_FEAT_ORDERED_HWQ;
>>          lim->max_open_zones = zi->max_open_zones;
>>          lim->max_active_zones = zi->max_active_zones;
>>          lim->max_hw_zone_append_sectors = ns->ctrl->max_zone_append;
>>
>> And ran this:
>>
>> fio --name=test --filename=/dev/nvme1n2 --ioengine=io_uring --iodepth=128 \
>>     --direct=1 --bs=4096 --zonemode=zbd --rw=randwrite \
>>     --numjobs=1
>>
>> And I get unaligned write errors 100% of the time. Looking at your patches
>> again, you are not handling REQ_NOWAIT case in blk_zone_wplug_handle_write(). If
>> you get REQ_NOWAIT BIO, which io_uring will issue, the code goes directly to
>> plugging the BIO, thus bypassing your from_cpu handling.
> 
> Didn't Jens recommend libaio instead of io_uring for zoned storage? See
> also https://lore.kernel.org/linux-block/8c0f9d28-d68f-4800-
> b94f-1905079d4007@kernel.dk/T/#mb61b6d1294da76a9f1be38edf6dceaf703112335. I ran
> all my tests with
> libaio instead of io_uring.

My bad, yes, io_uring does not work reliably for zoned writes because of its
no-wait handling of BIOs and punting to a worker thread for blocking BIOs. But
as I said, tests with libaio did not go well either.

>> But the same fio command with libaio (no REQ_NOWAIT in that case) also fails.
> 
> While this patch series addresses most potential causes of reordering by
> the block layer, it does not address all possible causes of reordering.
> An example of a potential cause of reordering that has not been
> addressed by this patch series can be found in blk_mq_insert_requests().
> That function either inserts requests in a software or a hardware queue.
> Bypassing the software queue for some requests can cause reordering.
> Another example can be found in blk_mq_dispatch_rq_list(). If the block
> driver responds with BLK_STS_RESOURCE or BLK_STS_DEV_RESOURCE, the
> requests that have not been accepted by the block driver are added to
> the &hctx->dispatch list. If these requests came from a software queue,
> adding these to hctx->dispatch_list instead of putting them back in
> their original position in the software queue can cause reordering.
> 
> Patches 8 and 9 work around this by retrying writes in the unlikely case
> that reordering happens. I think this is a more pragmatic solution than
> making more changes in the block layer to make it fully preserve the
> request order. In the traces that I gathered and that I inspected, I
> did not see any UNALIGNED WRITE errors being reported by ZUFS devices.

So the end result of your patches is that the submission path can still
generates reordering and cause unaligned write errors. Not great to say the
least. I would really prefer something that does not cause such submission
errors to be sure that if we see an error, it is due to the a user bug (user
sending unaligned writes).

-- 
Damien Le Moal
Western Digital Research
