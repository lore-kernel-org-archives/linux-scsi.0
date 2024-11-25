Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2022500AC;
	Mon, 25 Nov 2024 04:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732507268; cv=none; b=anAIbwMlF3JjwJOq+8GZo/M6h2a9OTAizZ4X2zNhcvkWB5PK+JeWQQp+W54F36z9WObE1xAvJRriIws9cwRNsaiGW/xzZSHu4dbqnz5SOSiW5LVr1n6YraeW9IrfpUfia16S8EJsBPn+rw1F9kLCniPnVgR52JpbQAVv/7hnvEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732507268; c=relaxed/simple;
	bh=B/dsNi+GdvK5CwNP19Y1zvgT+mh+876vhMcIORmOrfY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sxWASEswo4OAs6zKcLig5oTpQ5IZZMx7d7QqKQmh3XJAR/BhqpBlW+TBz9gBZ//ojT6Fk0CjcPvhPWpbtb6uFdfRAi9TKaHX1ruxMdWwqH2Y9gEc4UWH3ZW4JFVpzut/WTP61AcsEEagA5h6qTut2gMekKEgPICnFeCINe3Oz64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F22ai0Us; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F22ai0Us"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91124C4CECE;
	Mon, 25 Nov 2024 04:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732507268;
	bh=B/dsNi+GdvK5CwNP19Y1zvgT+mh+876vhMcIORmOrfY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=F22ai0UsD0jotUIaVJNnc3W9y/IsgtlW33H4V5RZO2p7jgupIexc17MApOC6XLEBC
	 yFjSE4yeVqFPF9g1z1Qv1Jgpc8bnMC2i4KDRrp/o1bDAMlkfAofVjEytsvK6MCNDs8
	 J7b33Z6IqS3l+DnJUccjffWkfRPOJ8M3zxi0k2f9dehvU6dhPZFOApaungWBdEfU5a
	 o0+EGpDp73c6cBQ/ro8uOa/QPAGJQ6joIKLde4fnMH9tAWVQU0PeWde+z71v1X12nk
	 2GId/LNcxIzul2YTGYCG4abEiZImzkwIN2annD2wmdTcOVOHQ7YhS0mgwYnkalZUk6
	 O4YKkhKsz/1Hw==
Message-ID: <2e55151f-2001-46b6-8f82-cf961bbdf7cf@kernel.org>
Date: Mon, 25 Nov 2024 13:00:53 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 05/26] blk-zoned: Fix a deadlock triggered by
 unaligned writes
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <20241119002815.600608-6-bvanassche@acm.org>
 <6729e88d-5311-4b6e-a3da-0f144aab56c9@kernel.org>
 <17b232e6-72bf-427a-8ffa-4785182201cc@acm.org>
 <055d17a7-94f3-488f-b45a-90b092a4165d@kernel.org>
 <03c6dc60-fc51-4906-b433-aeac6be87083@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <03c6dc60-fc51-4906-b433-aeac6be87083@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/22/24 2:51 AM, Bart Van Assche wrote:
> 
> On 11/20/24 7:32 PM, Damien Le Moal wrote:
>> On 11/20/24 06:04, Bart Van Assche wrote:
>>> On 11/18/24 6:57 PM, Damien Le Moal wrote:
>>>> On 11/19/24 9:27 AM, Bart Van Assche wrote:
>>>>> If the queue is filled with unaligned writes then the following
>>>>> deadlock occurs:
>>>>>
>>>>> Call Trace:
>>>>>    <TASK>
>>>>>    __schedule+0x8cc/0x2190
>>>>>    schedule+0xdd/0x2b0
>>>>>    blk_queue_enter+0x2ce/0x4f0
>>>>>    blk_mq_alloc_request+0x303/0x810
>>>>>    scsi_execute_cmd+0x3f4/0x7b0
>>>>>    sd_zbc_do_report_zones+0x19e/0x4c0
>>>>>    sd_zbc_report_zones+0x304/0x920
>>>>>    disk_zone_wplug_handle_error+0x237/0x920
>>>>>    disk_zone_wplugs_work+0x17e/0x430
>>>>>    process_one_work+0xdd0/0x1490
>>>>>    worker_thread+0x5eb/0x1010
>>>>>    kthread+0x2e5/0x3b0
>>>>>    ret_from_fork+0x3a/0x80
>>>>>    </TASK>
>>>>>
>>>>> Fix this deadlock by removing the disk->fops->report_zones() call and by
>>>>> deriving the write pointer information from successfully completed zoned
>>>>> writes.
>>>>>
>>>>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>>>>
>>>> Doesn't this need a Fixes tag and CC stable, and come earlier in the series
>>>> (or
>>>> sent separately) ?
>>>
>>> I will add Fixes: and Cc: stable tags.
>>>
>>> I'm not sure how to move this patch earlier since it depends on the
>>> previous patch in this series ("blk-zoned: Only handle errors after
>>> pending zoned writes have completed"). Without that patch, it is not
>>> safe to use zwplug->wp_offset_compl in the error handler.
>>>
>>>> Overall, this patch seems wrong anyway as zone reset and zone finish may be
>>>> done between 2 writes, failing the next one but the recovery done here will
>>>> use
>>>> the previous succeful write end position as the wp, which is NOT correct as
>>>> reset or finish changed that...
>>>
>>> I will add support for the zone reset and zone finish commands in this
>>> patch.
>>>
>>>> And we also have the possibility of torn writes
>>>> (partial writes) with SAS SMR drives. So I really think that you cannot avoid
>>>> doing a report zone to recover errors.
>>>
>>> Thanks for having brought this up. This is something I was not aware of.
>>>
>>> disk_zone_wplug_handle_error() submits a new request to retrieve zone
>>> information while handling an error triggered by other requests. This
>>> can easily lead to a deadlock as the above call trace shows. How about
>>> introducing a queue flag for the "report zones" approach in
>>> disk_zone_wplug_handle_error() such that the "report zones" approach is
>>> only used for SAS SMR drives?
>>
>> Sure, but how would that solve the potential deadlock problem ? ALso, I am not
>> entirely clear on how the deadlock can happen given that zone write plugs are
>> queueing/blocking BIOs, not requests. So even assuming you have a large number
>> of BIOs plugged in a zone write plug, the error handler work should still be
>> able to issue a request to do a report zones, no ? On which resource can the
>> deadlock happen ? Plugged BIOs do not yet use a tag, right ?
>>
>> What am I missing here ? Or is it maybe something that can happen with your
>> modifications because you changed the zone write plug behavior to allow for more
>> than one BIO at a time being unplugged and issued to the device ?
>>
>> Note that if you do have a test case for this triggering the deadlock, we
>> definitely need to solve this and ideally have a blktest case checking it.
> 
> Hi Damien,
> 
> The call trace mentioned above comes from the kernel log and was
> encountered while I was testing this patch series. A reproducer has
> already been shared - see also
> https://lore.kernel.org/linux-block/e840b66a-79f0-4169-9ab1-
> c475d9608e4d@acm.org/. The lockup happened after the queue was filled up
> with requests and hence sd_zbc_report_zones() failed to allocate an
> additional request for the zone report.
> 
> I'm wondering whether this lockup can also happen with the current
> upstream kernel by submitting multiple unaligned writes simultaneously
> where each write affects another zone and where the number of writes
> matches the queue depth.

Let me check. This indeed may be a possibility.

> 
> Thanks,
> 
> Bart.
> 
> 


-- 
Damien Le Moal
Western Digital Research
