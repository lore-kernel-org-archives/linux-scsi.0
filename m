Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3782E63C0;
	Tue, 21 Nov 2023 01:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bm1hCBEY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BDBEC433C8;
	Tue, 21 Nov 2023 01:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700529679;
	bh=p3EdOw3VHz4PxL6swnM5Y5besmZ+9QCnx60IZWSoteo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bm1hCBEYul3ebSW3k8dnf5qOD08ImM8yAbjB1GO1CzupG0j8b/dsKFdVNlXI3cx3q
	 rS/B56SACoEiKvevZKZdmiqyOAYXXPXKL4jU9l4glUuN9U8/V20x+hATEm23BEYn+m
	 cOh+JsN7WHyz+gx7xvv8JZitQoXtJONEOQpPLT4rhvqJ3oAcABAjjgrqiin9oraDQ9
	 26TLT5WEGfOHKqAAANkA6gY/vAwzwElanXrfjCyDEi9YnLttQJDrypsHbhRjjMntNJ
	 SWr76q33fNpXODyKwTVzkYdHkM2oMvR/1EWUYanSwPOu0T11GVE8ZA2ftEZcgpsM7V
	 xai31dfFGPJkQ==
Message-ID: <d4870aac-4464-4528-b5c4-6cef853d280e@kernel.org>
Date: Tue, 21 Nov 2023 10:21:17 +0900
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
 <c789e381-f0c4-4c61-bbc7-069a834841c9@kernel.org>
 <a4233f10-56c7-4d57-8875-f29efe815627@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <a4233f10-56c7-4d57-8875-f29efe815627@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/21/23 08:58, Bart Van Assche wrote:
> On 11/20/23 15:02, Damien Le Moal wrote:
>> On 11/21/23 05:44, Bart Van Assche wrote:
>>> How about applying this (untested) patch on top of this patch series?
>>>
>>> diff --git a/block/blk-settings.c b/block/blk-settings.c
>>> index 4c776c08f190..aba1972e9767 100644
>>> --- a/block/blk-settings.c
>>> +++ b/block/blk-settings.c
>>> @@ -84,8 +84,6 @@ void blk_set_stacking_limits(struct queue_limits *lim)
>>>    	lim->max_dev_sectors = UINT_MAX;
>>>    	lim->max_write_zeroes_sectors = UINT_MAX;
>>>    	lim->max_zone_append_sectors = UINT_MAX;
>>> -	/* Request-based stacking drivers do not reorder requests. */
>>> -	lim->driver_preserves_write_order = true;
>>>    }
>>>    EXPORT_SYMBOL(blk_set_stacking_limits);
>>>
>>> diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
>>> index 2d3e186ca87e..cb9abe4bd065 100644
>>> --- a/drivers/md/dm-linear.c
>>> +++ b/drivers/md/dm-linear.c
>>> @@ -147,6 +147,11 @@ static int linear_report_zones(struct dm_target *ti,
>>>    #define linear_report_zones NULL
>>>    #endif
>>>
>>> +static void linear_io_hints(struct dm_target *ti, struct queue_limits *limits)
>>> +{
>>> +	limits->driver_preserves_write_order = true;
>>> +}
>>
>> Hmm, but does dm-linear preserve write order ? I am not convinced. And what
>> about dm-flakey, dm-error and dm-crypt ? All of these also support zoned
>> devices. I do not think that we can say that any of these preserve write order.
> 
> Hi Damien,
> 
> I propose to keep any changes for files in the drivers/md/ directory for
> later. This patch series is already big enough. Additionally, I don't
> need the dm changes myself since Android does does not use dm-linear nor
> dm-verity to access a zoned logical unit. All we need to know right now
> is that the approach of this patch series can be extended to dm drivers.

Agree. For now, dm will keep working as usual using the zone write locking. We
can optimize that later as needed and if possible. So initializing the limits
driver_preserves_write_order to false (default) is the way to go.

-- 
Damien Le Moal
Western Digital Research

