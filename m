Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22CA1E517;
	Mon, 25 Nov 2024 04:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732508396; cv=none; b=NE+571cEV5eJ8bcTK1TY59wc4lqCicLRKfVZ6q9y41E0BVJEnpGkZjA0SCw+vXn0cHPU4aoBtHIs5uWhKVuLOJkOCFQpb8HrnyfViSGNYZDDGRIIgkJiBx76E/PcUlQSUY/F9An9Ud5p2BjYy05L355NQdDebpleqWz8anu5SvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732508396; c=relaxed/simple;
	bh=h6AaT+rKUeHRPcLdFWpk0Yp4f9IoZ851unKPnLpStts=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=uqfX+EyEkNBaxW5U6R/PqbV9pO3KNtlzo49yxSgPmq9OgpsxpdUcHIfLekymlbwHjkxdIJQ3Q/sG0X8ekdpCmXO/wmNudaXL0FM6FLDztB4tZl3sYxBOhkH5rrUUIqUh4LVSsDN9KpiuR3TeXJszCq6mWDvrYtJHX98M9NpxPBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GdfbKCWD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GdfbKCWD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 895DEC4CECE;
	Mon, 25 Nov 2024 04:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732508396;
	bh=h6AaT+rKUeHRPcLdFWpk0Yp4f9IoZ851unKPnLpStts=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=GdfbKCWDo+Bdc9UfTDKgEQHQkuyoa/y56lR+FbU9xokpnKEUN4LDXZb+Imb6+JL3W
	 99hzE3neUP9HtqSKUMVYpfi5NhK5iDyWJJG+HuuwIUg1WfDLWeKupGi6EfbjsmHsVS
	 NTe3BeFngACr+b29pZkNkh7iuSf0VpbbU2mIBIinn3hsKGsplXn5SSsmA6w94CfVqk
	 oHkB5jkD6nSjZXrMHbWK++fNIFV6gjHkdf38H8vHQJgb5Zps0gnQvTR+g1dZ1OaIQz
	 qvB/JVhyZ67DaLiwIbplPaXYG0Gv8X6wwCgOhegF8dK9k5aMHVa3mDqv8y4XnP70q+
	 y6fkdhrEJYstw==
Message-ID: <ec7b6eef-48e6-42f3-8e6f-54dfd3724393@kernel.org>
Date: Mon, 25 Nov 2024 13:19:41 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 05/26] blk-zoned: Fix a deadlock triggered by
 unaligned writes
From: Damien Le Moal <dlemoal@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <20241119002815.600608-6-bvanassche@acm.org>
 <6729e88d-5311-4b6e-a3da-0f144aab56c9@kernel.org>
 <17b232e6-72bf-427a-8ffa-4785182201cc@acm.org>
 <055d17a7-94f3-488f-b45a-90b092a4165d@kernel.org>
 <03c6dc60-fc51-4906-b433-aeac6be87083@acm.org>
 <2e55151f-2001-46b6-8f82-cf961bbdf7cf@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <2e55151f-2001-46b6-8f82-cf961bbdf7cf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/25/24 1:00 PM, Damien Le Moal wrote:
> On 11/22/24 2:51 AM, Bart Van Assche wrote:
>>
>> On 11/20/24 7:32 PM, Damien Le Moal wrote:
>>> On 11/20/24 06:04, Bart Van Assche wrote:
>>>> On 11/18/24 6:57 PM, Damien Le Moal wrote:
>>>>> On 11/19/24 9:27 AM, Bart Van Assche wrote:
>>>>>> If the queue is filled with unaligned writes then the following
>>>>>> deadlock occurs:
>>>>>>
>>>>>> Call Trace:
>>>>>>    <TASK>
>>>>>>    __schedule+0x8cc/0x2190
>>>>>>    schedule+0xdd/0x2b0
>>>>>>    blk_queue_enter+0x2ce/0x4f0
>>>>>>    blk_mq_alloc_request+0x303/0x810
>>>>>>    scsi_execute_cmd+0x3f4/0x7b0
>>>>>>    sd_zbc_do_report_zones+0x19e/0x4c0
>>>>>>    sd_zbc_report_zones+0x304/0x920
>>>>>>    disk_zone_wplug_handle_error+0x237/0x920
>>>>>>    disk_zone_wplugs_work+0x17e/0x430
>>>>>>    process_one_work+0xdd0/0x1490
>>>>>>    worker_thread+0x5eb/0x1010
>>>>>>    kthread+0x2e5/0x3b0
>>>>>>    ret_from_fork+0x3a/0x80
>>>>>>    </TASK>
>>>>>>
>>>>>> Fix this deadlock by removing the disk->fops->report_zones() call and by
>>>>>> deriving the write pointer information from successfully completed zoned
>>>>>> writes.
>>>>>>
>>>>>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>>>>>
>>>>> Doesn't this need a Fixes tag and CC stable, and come earlier in the series
>>>>> (or
>>>>> sent separately) ?
>>>>
>>>> I will add Fixes: and Cc: stable tags.
>>>>
>>>> I'm not sure how to move this patch earlier since it depends on the
>>>> previous patch in this series ("blk-zoned: Only handle errors after
>>>> pending zoned writes have completed"). Without that patch, it is not
>>>> safe to use zwplug->wp_offset_compl in the error handler.
>>>>
>>>>> Overall, this patch seems wrong anyway as zone reset and zone finish may be
>>>>> done between 2 writes, failing the next one but the recovery done here will
>>>>> use
>>>>> the previous succeful write end position as the wp, which is NOT correct as
>>>>> reset or finish changed that...
>>>>
>>>> I will add support for the zone reset and zone finish commands in this
>>>> patch.
>>>>
>>>>> And we also have the possibility of torn writes
>>>>> (partial writes) with SAS SMR drives. So I really think that you cannot avoid
>>>>> doing a report zone to recover errors.
>>>>
>>>> Thanks for having brought this up. This is something I was not aware of.
>>>>
>>>> disk_zone_wplug_handle_error() submits a new request to retrieve zone
>>>> information while handling an error triggered by other requests. This
>>>> can easily lead to a deadlock as the above call trace shows. How about
>>>> introducing a queue flag for the "report zones" approach in
>>>> disk_zone_wplug_handle_error() such that the "report zones" approach is
>>>> only used for SAS SMR drives?
>>>
>>> Sure, but how would that solve the potential deadlock problem ? ALso, I am not
>>> entirely clear on how the deadlock can happen given that zone write plugs are
>>> queueing/blocking BIOs, not requests. So even assuming you have a large number
>>> of BIOs plugged in a zone write plug, the error handler work should still be
>>> able to issue a request to do a report zones, no ? On which resource can the
>>> deadlock happen ? Plugged BIOs do not yet use a tag, right ?
>>>
>>> What am I missing here ? Or is it maybe something that can happen with your
>>> modifications because you changed the zone write plug behavior to allow for more
>>> than one BIO at a time being unplugged and issued to the device ?
>>>
>>> Note that if you do have a test case for this triggering the deadlock, we
>>> definitely need to solve this and ideally have a blktest case checking it.
>>
>> Hi Damien,
>>
>> The call trace mentioned above comes from the kernel log and was
>> encountered while I was testing this patch series. A reproducer has
>> already been shared - see also
>> https://lore.kernel.org/linux-block/e840b66a-79f0-4169-9ab1-
>> c475d9608e4d@acm.org/. The lockup happened after the queue was filled up
>> with requests and hence sd_zbc_report_zones() failed to allocate an
>> additional request for the zone report.
>>
>> I'm wondering whether this lockup can also happen with the current
>> upstream kernel by submitting multiple unaligned writes simultaneously
>> where each write affects another zone and where the number of writes
>> matches the queue depth.
> 
> Let me check. This indeed may be a possibility.

Thinking more about this, the answer is no, this cannot happen. The reason is
that zone write plugs are blocking BIOs, not requests. So the number of BIOs
queued waiting for execution does not matter as we are not holding tags. A
report zone for recovering from a write error in a zone may have to wait for a
tag for some time before executing, when many zones are being read/written at
the same time. But as long as requests complete and tags are freed, error
recovery report zones will eventually proceed and execute. No deadlock.
Even if the drive stops responding, we will eventually get a timeout and drive
reset which will abort all commands, so even then, we will have forward
progress with error recovery.

This is for the current upstream code.

Now, in your case, with several write requests issued per zone and said write
requests potentially waiting in the requeue or dispatch lists, then a report
zone for error recovery may indeed block forever... So with your changes, a
solution for this is needed I think.


-- 
Damien Le Moal
Western Digital Research
