Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE01844C6F;
	Thu, 21 Nov 2024 03:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732159934; cv=none; b=VkmRCcn4htr1gjqJBssaIGL8HjlR5eiWw46a1H1tfHe0G1EaBGGSHT3+1Q8dAeeuiGw40JW0cRmscIXWE/ySJ16bkrFGtqkt2e6L7LjQdfaysIGufktSUwuMMNx4u48Xh5MKRmj2KTUYa3MRTk94QsbAmxUyg+59U15FqSzXXDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732159934; c=relaxed/simple;
	bh=o7LphQP4KssuvEg1pyjU5Fp974fAtXEOmPXUGYKJpnw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HZs/60/DRSMBVEg9q3rwY6DJ4fSgvz4whU0KKGn7X9pE7zec4qL3r10VchmtFQ4yXk4LxW7kQEHcYP6n359KoLrTGbKOVknU7VZ0e9RhOSXqtLF3Pd5boa7YDJZ9dvgcvqLv/hbPywNFrFng+ZkddtFh3wvlGywsyG2KCsqh/GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZMtGv5RG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZMtGv5RG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D97C4CECD;
	Thu, 21 Nov 2024 03:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732159934;
	bh=o7LphQP4KssuvEg1pyjU5Fp974fAtXEOmPXUGYKJpnw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZMtGv5RGTnn50osthd8DnEmkFHb8LM+hI8pR4XMbz+36OmpQ0eBueXLCA51ChuY00
	 r312LzaCF18Y2NGgx/79C179K1Vk/6VWQhdoCd38mKW3cqueB9jA2sU+O2GSgWMHJK
	 ctqxl60+joUo0yFdv0dj42VlllgxK88ydt41xYmz4kQcqQW8QlvtsOdwplzIsfuuQ9
	 Vy+5eTWuqaL/irpHvJlBH74V8MBJ5ImNN1UgHA3zKFaPSrFNV1a8Zu1ztlQnBle+oj
	 Jm2ibuyh5ph8rOK/Fa7c7iFR8P/gMY5+6/pQfDODZl1g5otrsX6AVXWA+/V/Sudlkf
	 sN6M+TGmCrEWA==
Message-ID: <055d17a7-94f3-488f-b45a-90b092a4165d@kernel.org>
Date: Thu, 21 Nov 2024 12:32:11 +0900
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
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <17b232e6-72bf-427a-8ffa-4785182201cc@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/20/24 06:04, Bart Van Assche wrote:
> On 11/18/24 6:57 PM, Damien Le Moal wrote:
>> On 11/19/24 9:27 AM, Bart Van Assche wrote:
>>> If the queue is filled with unaligned writes then the following
>>> deadlock occurs:
>>>
>>> Call Trace:
>>>   <TASK>
>>>   __schedule+0x8cc/0x2190
>>>   schedule+0xdd/0x2b0
>>>   blk_queue_enter+0x2ce/0x4f0
>>>   blk_mq_alloc_request+0x303/0x810
>>>   scsi_execute_cmd+0x3f4/0x7b0
>>>   sd_zbc_do_report_zones+0x19e/0x4c0
>>>   sd_zbc_report_zones+0x304/0x920
>>>   disk_zone_wplug_handle_error+0x237/0x920
>>>   disk_zone_wplugs_work+0x17e/0x430
>>>   process_one_work+0xdd0/0x1490
>>>   worker_thread+0x5eb/0x1010
>>>   kthread+0x2e5/0x3b0
>>>   ret_from_fork+0x3a/0x80
>>>   </TASK>
>>>
>>> Fix this deadlock by removing the disk->fops->report_zones() call and by
>>> deriving the write pointer information from successfully completed zoned
>>> writes.
>>>
>>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>>
>> Doesn't this need a Fixes tag and CC stable, and come earlier in the series (or
>> sent separately) ?
> 
> I will add Fixes: and Cc: stable tags.
> 
> I'm not sure how to move this patch earlier since it depends on the
> previous patch in this series ("blk-zoned: Only handle errors after
> pending zoned writes have completed"). Without that patch, it is not
> safe to use zwplug->wp_offset_compl in the error handler.
> 
>> Overall, this patch seems wrong anyway as zone reset and zone finish may be
>> done between 2 writes, failing the next one but the recovery done here will use
>> the previous succeful write end position as the wp, which is NOT correct as
>> reset or finish changed that...
> 
> I will add support for the zone reset and zone finish commands in this
> patch.
> 
>> And we also have the possibility of torn writes
>> (partial writes) with SAS SMR drives. So I really think that you cannot avoid
>> doing a report zone to recover errors.
> 
> Thanks for having brought this up. This is something I was not aware of.
> 
> disk_zone_wplug_handle_error() submits a new request to retrieve zone 
> information while handling an error triggered by other requests. This
> can easily lead to a deadlock as the above call trace shows. How about
> introducing a queue flag for the "report zones" approach in
> disk_zone_wplug_handle_error() such that the "report zones" approach is
> only used for SAS SMR drives?

Sure, but how would that solve the potential deadlock problem ? ALso, I am not
entirely clear on how the deadlock can happen given that zone write plugs are
queueing/blocking BIOs, not requests. So even assuming you have a large number
of BIOs plugged in a zone write plug, the error handler work should still be
able to issue a request to do a report zones, no ? On which resource can the
deadlock happen ? Plugged BIOs do not yet use a tag, right ?

What am I missing here ? Or is it maybe something that can happen with your
modifications because you changed the zone write plug behavior to allow for more
than one BIO at a time being unplugged and issued to the device ?

Note that if you do have a test case for this triggering the deadlock, we
definitely need to solve this and ideally have a blktest case checking it.

-- 
Damien Le Moal
Western Digital Research
