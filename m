Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0B81547FF;
	Tue, 19 Nov 2024 21:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732050299; cv=none; b=tDYdCdpCdgJ0ulyRg70wBeJqVrJEI27UV0Qz64OSnpzB3a4pn81ULdI3iZhqOnxPt7eWNnhiR12tm4mE77Hc/3IutUqr3EvFmc/D9pBZTGLBtfNBeidGJHH1dVADqOfd1qFrsw68eZayZANFHJXZwnnQSV7VMpVlo+1JZcGCydU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732050299; c=relaxed/simple;
	bh=7xOEcFi09J4d2htNVHm2lVBIsrExkw8JFVQkrLwNPF4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DmBERqqi5+wk0KjDIxBs83FS4i/3wEaYesh1ag2aemcV0j3xvu8GnRIDKUJ/l9caw6SnDg8XttS9bErLkGLuCOd+NcrbaPpXxWVGEXM7HZIqEfX98OAaUv1l0lVKo9wpirrjkzYc1+Qry0lIFMi5qFECkhC1cQ0MSeCQhlElfLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=FN2lv5c9; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="FN2lv5c9"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XtH7Y1GKfz6CmM6Q;
	Tue, 19 Nov 2024 21:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1732050292; x=1734642293; bh=59LT412rnDgJV/ECAiOr/Jvi
	bvy0mDWH7YbiXECYGGk=; b=FN2lv5c9QynQBt6Y2izN/xipeAYE/Xkb5xSZkWl4
	K4GwitBjTIjJiwt5KMzFshLfitw7bzGBqmgrA4RY3vsYIBrZIoxguaEq8gOdAOjA
	PMMlzoJceZ7LIkcG83VNAYEHIM55Xkle1tDTWbCrlQSZ9yVGCmYiRXyPleC5fGQj
	y0e0ej+F0yD1jfSExNfB/98Q9pRvIVZ/YXaluNPsCtRiVDfp5b49dG18QQh0UZah
	+KwtUSUGgtKOvnni5NslHqsQCywOGcIyzwF2QAvT7slVGPiUZ6bRN+1tbwdG0luZ
	O26cpAAEjNw/7Mh5N2xEiu+qeOrE28JF58wFdGJD/+18ew==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ROLvC3fvYyB9; Tue, 19 Nov 2024 21:04:52 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XtH7R62ZKz6CmSMs;
	Tue, 19 Nov 2024 21:04:51 +0000 (UTC)
Message-ID: <17b232e6-72bf-427a-8ffa-4785182201cc@acm.org>
Date: Tue, 19 Nov 2024 13:04:50 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 05/26] blk-zoned: Fix a deadlock triggered by
 unaligned writes
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <20241119002815.600608-6-bvanassche@acm.org>
 <6729e88d-5311-4b6e-a3da-0f144aab56c9@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <6729e88d-5311-4b6e-a3da-0f144aab56c9@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/24 6:57 PM, Damien Le Moal wrote:
> On 11/19/24 9:27 AM, Bart Van Assche wrote:
>> If the queue is filled with unaligned writes then the following
>> deadlock occurs:
>>
>> Call Trace:
>>   <TASK>
>>   __schedule+0x8cc/0x2190
>>   schedule+0xdd/0x2b0
>>   blk_queue_enter+0x2ce/0x4f0
>>   blk_mq_alloc_request+0x303/0x810
>>   scsi_execute_cmd+0x3f4/0x7b0
>>   sd_zbc_do_report_zones+0x19e/0x4c0
>>   sd_zbc_report_zones+0x304/0x920
>>   disk_zone_wplug_handle_error+0x237/0x920
>>   disk_zone_wplugs_work+0x17e/0x430
>>   process_one_work+0xdd0/0x1490
>>   worker_thread+0x5eb/0x1010
>>   kthread+0x2e5/0x3b0
>>   ret_from_fork+0x3a/0x80
>>   </TASK>
>>
>> Fix this deadlock by removing the disk->fops->report_zones() call and by
>> deriving the write pointer information from successfully completed zoned
>> writes.
>>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> 
> Doesn't this need a Fixes tag and CC stable, and come earlier in the series (or
> sent separately) ?

I will add Fixes: and Cc: stable tags.

I'm not sure how to move this patch earlier since it depends on the
previous patch in this series ("blk-zoned: Only handle errors after
pending zoned writes have completed"). Without that patch, it is not
safe to use zwplug->wp_offset_compl in the error handler.

> Overall, this patch seems wrong anyway as zone reset and zone finish may be
> done between 2 writes, failing the next one but the recovery done here will use
> the previous succeful write end position as the wp, which is NOT correct as
> reset or finish changed that...

I will add support for the zone reset and zone finish commands in this
patch.

> And we also have the possibility of torn writes
> (partial writes) with SAS SMR drives. So I really think that you cannot avoid
> doing a report zone to recover errors.

Thanks for having brought this up. This is something I was not aware of.

disk_zone_wplug_handle_error() submits a new request to retrieve zone 
information while handling an error triggered by other requests. This
can easily lead to a deadlock as the above call trace shows. How about
introducing a queue flag for the "report zones" approach in
disk_zone_wplug_handle_error() such that the "report zones" approach is
only used for SAS SMR drives?

Thanks,

Bart.
