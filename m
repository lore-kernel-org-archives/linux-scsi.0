Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kko+Iv5h"
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD1FC1
	for <linux-scsi@vger.kernel.org>; Mon, 20 Nov 2023 15:02:35 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC345C433C9;
	Mon, 20 Nov 2023 23:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700521354;
	bh=FrDMoJdlxK52/94+zVyE2hI7unP1VqBVCXrEm9LXIWs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kko+Iv5hW5ipjxGCXB91bSuqb3p77WbMww/J7ibq0UuFBP95NgW+VvnocPiimNirN
	 axtOMLVVh+MD55m7bEoFvQPj7IYO/bY50weo3FCs7U7fTo8k8Ua01iPwvdDP6FNItH
	 mHZCJRo7+cGjkDXBqNT0KSzn2etb9VgeMORrBQBXQRatxLr+BtP07s3MbA5epiugjS
	 d43VbL0YKQYVr1XKG27y/p2UIWs3mTEF/aXzakPSdKHcCZ3qx5IWdLchBmwJYzB090
	 fF+ONRayaii1rzbsDf8cyW02Sk6h9E/Ax7ytS9rm4OjYVPl1EMJv/YYjlCNbIss3pP
	 a5OCARCHEpFig==
Message-ID: <c789e381-f0c4-4c61-bbc7-069a834841c9@kernel.org>
Date: Tue, 21 Nov 2023 08:02:32 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 01/19] block: Introduce more member variables related
 to zone write locking
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
 Hannes Reinecke <hare@suse.de>, Nitesh Shetty <nj.shetty@samsung.com>,
 Ming Lei <ming.lei@redhat.com>
References: <20231114211804.1449162-1-bvanassche@acm.org>
 <20231114211804.1449162-2-bvanassche@acm.org>
 <3d8d04d5-80d8-4eee-9899-d9fe197dd203@kernel.org>
 <0d60bde5-018d-4850-8870-092b472463a6@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <0d60bde5-018d-4850-8870-092b472463a6@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/21/23 05:44, Bart Van Assche wrote:
> On 11/19/23 15:29, Damien Le Moal wrote:
>> On 11/15/23 06:16, Bart Van Assche wrote:
>>> @@ -82,6 +84,8 @@ void blk_set_stacking_limits(struct queue_limits *lim)
>>>   	lim->max_dev_sectors = UINT_MAX;
>>>   	lim->max_write_zeroes_sectors = UINT_MAX;
>>>   	lim->max_zone_append_sectors = UINT_MAX;
>>> +	/* Request-based stacking drivers do not reorder requests. */
>>
>> Rereading this patch, I do not think this statement is correct. I seriously
>> doubt that multipath will preserve write command order in all cases...
>>
>>> +	lim->driver_preserves_write_order = true;
>>
>> ... so it is likely much safer to set the default to "false" as that is the
>> default for all requests in general.
> 
> How about applying this (untested) patch on top of this patch series?
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 4c776c08f190..aba1972e9767 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -84,8 +84,6 @@ void blk_set_stacking_limits(struct queue_limits *lim)
>   	lim->max_dev_sectors = UINT_MAX;
>   	lim->max_write_zeroes_sectors = UINT_MAX;
>   	lim->max_zone_append_sectors = UINT_MAX;
> -	/* Request-based stacking drivers do not reorder requests. */
> -	lim->driver_preserves_write_order = true;
>   }
>   EXPORT_SYMBOL(blk_set_stacking_limits);
> 
> diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
> index 2d3e186ca87e..cb9abe4bd065 100644
> --- a/drivers/md/dm-linear.c
> +++ b/drivers/md/dm-linear.c
> @@ -147,6 +147,11 @@ static int linear_report_zones(struct dm_target *ti,
>   #define linear_report_zones NULL
>   #endif
> 
> +static void linear_io_hints(struct dm_target *ti, struct queue_limits *limits)
> +{
> +	limits->driver_preserves_write_order = true;
> +}

Hmm, but does dm-linear preserve write order ? I am not convinced. And what
about dm-flakey, dm-error and dm-crypt ? All of these also support zoned
devices. I do not think that we can say that any of these preserve write order.

> +
>   static int linear_iterate_devices(struct dm_target *ti,
>   				  iterate_devices_callout_fn fn, void *data)
>   {
> @@ -208,6 +213,7 @@ static struct target_type linear_target = {
>   	.map    = linear_map,
>   	.status = linear_status,
>   	.prepare_ioctl = linear_prepare_ioctl,
> +	.io_hints = linear_io_hints,
>   	.iterate_devices = linear_iterate_devices,
>   	.direct_access = linear_dax_direct_access,
>   	.dax_zero_page_range = linear_dax_zero_page_range,
> 
>>> @@ -685,6 +689,10 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>>>   						   b->max_secure_erase_sectors);
>>>   	t->zone_write_granularity = max(t->zone_write_granularity,
>>>   					b->zone_write_granularity);
>>> +	t->driver_preserves_write_order = t->driver_preserves_write_order &&
>>> +		b->driver_preserves_write_order;
>>> +	t->use_zone_write_lock = t->use_zone_write_lock ||
>>> +		b->use_zone_write_lock;
>>
>> Very minor nit: splitting the line after the equal would make this more readable.
> 
> Hmm ... I have often seen other reviewers asking to maximize the use of each
> source code line as much as reasonably possible.

As I said, very minor nit :) Feel free to ignore.

> 
> Thanks,
> 
> Bart.
> 

-- 
Damien Le Moal
Western Digital Research

