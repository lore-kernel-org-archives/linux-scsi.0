Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BCD83E9C2B;
	Tue,  6 Oct 2026 13:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791292352; cv=none; b=eTtC0BTiko90sf7YF8Jk1E2p8O6yNAcIFlhc7NJ+qaoy/Gd4HZQ0Ysbj0Dn68wFxzWUoJjqVpuKpeAs7J7kEkDvIS+IPJr0+hGNpe7Avcxpt2BHuJVs4IfZtEEoA2imAFMa7UIYxaQvFfiOLcsB7IT5r1VucOY+p94BKecZ/Go4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791292352; c=relaxed/simple;
	bh=ZCVYTUZnTXZyTrRVjphJvOYu/pMx9KdBpM4QUck0toA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IqMii0Z5dRnqgP57Ml4WnkDUYk1vp6szEwyoIZ1UdjToeWOnunD+0M3jhdSX6WyW8T2+6QSSw9CHgYOjFRSC58Fzb9vXqGWDra4/g7D1CXX4qMSlGkY9JOnfX+M9WF+EcR1hqkdBs+touOFJee1prLwuzh7tYDDuzsNL2IYQ69s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SYTWQ01h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SYTWQ01h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC911F000FF;
	Tue,  6 Oct 2026 13:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791292350;
	bh=4LvfoqhtHgWbDEgayj3ZprDs3tmO35VoOivMkzGAMAE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SYTWQ01hxci9COZZPeaJMyU7ds8x+Ml/VT9Iy2Vq7EUyxPKq26gGYkkzb6/N7j3Ip
	 SZr5C3cLe0253lqhrez/ABSMmcAC4+k+wtoeD9tKAIGgW3RHZPgKopCCbq6a/dr2ZE
	 SJ7K2QnQERM87lSmT4thIgqSxHUNgx82FoBIfA9GccKjLWS+PHQYSGRDKgc1BBENCc
	 oqsWMaG2yuQPD/Zwn38hz/PxUu2QlLSJl4+fhlEZRxALQZHCGoed/I163cePIC47y5
	 vCmRjKq8The2J2A2ra9M4ySW4IUnaIcb3YxhnTMKBVFYjtBt9lyZGBuHMypkUBajiz
	 /JNFaK8JZYboQ==
Message-ID: <0254e559-b9d2-4563-9864-0aef85b9b5a3@kernel.org>
Date: Tue, 6 Oct 2026 15:12:28 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/7] zloop: add degrade_element control command
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20261006124510.882017-1-dlemoal@kernel.org>
 <20261006124510.882017-6-dlemoal@kernel.org>
 <20261006125600.7F72C1F000FF@smtp.kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20261006125600.7F72C1F000FF@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/10/06 14:56, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [Medium] block/zloop: removing degraded element re-enables I/O during transition
> - [Low] block/zloop: format string arguments swapped in degrade_element
> - [Low] block/zloop: missing validation for ZLOOP_OPT_ELEMENT_ID
> --
> 
> commit a9552af0fb1bf978fc86a4c32f3c9541477e5165
> Author: Damien Le Moal <dlemoal@kernel.org>
> Subject: zloop: add degrade_element control command
> 
> This commit introduces a new degrade_element control command for zloop 
> devices to simulate degraded storage elements. Read and write operations 
> to zones served by a degraded element are failed based on element type. 
> The patch also updates storage element status accesses to use READ_ONCE() 
> and WRITE_ONCE() for safe lockless checks in the I/O path.
> 
>> diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
>> index d6a45f2148576..3913bd2299108 100644
>> --- a/drivers/block/zloop.c
>> +++ b/drivers/block/zloop.c
> 
> [ ... ]
> 
>> @@ -982,11 +986,26 @@ static bool zloop_prep_rq(struct zloop_device *zlo, struct request *rq)
>>  	spin_lock(&zone->wp_lock);
>>  
>>  	if (zlo->nr_elements) {
>> +		struct blk_storage_element *se;
>> +
>>  		if (zone->cond == BLK_ZONE_COND_OFFLINE ||
>>  		    (zone->cond == BLK_ZONE_COND_READONLY && is_write)) {
>>  			ret = false;
>>  			goto unlock;
>>  		}
>> +
>> +		/*
>> +		 * Check the health state of the storage element serving the
>> +		 * zone.
>> +		 */
>> +		if (is_write)
>> +			se = &zlo->elements[zone->wr_se_id - 1];
>> +		else
>> +			se = &zlo->elements[zone->rd_se_id - 1];
>> +		if (READ_ONCE(se->status) == BLK_SE_STS_DEGRADED) {
>> +			ret = false;
>> +			goto unlock;
>> +		}
>>  	}
> 
> [ ... ]
> 
>> @@ -1249,9 +1293,9 @@ static int zloop_remove_element(struct gendisk *disk, unsigned int element_id)
>>  	 * modify the zones.
>>  	 */
>>  	zlo->remove_element_id = element_id;
>> -	se->status = BLK_SE_STS_REMOVE_IN_PROGRESS;
>> -	if (paired_se && paired_se->status != BLK_SE_STS_REMOVED)
>> -		paired_se->status = BLK_SE_STS_REMOVE_IN_PROGRESS;
>> +	WRITE_ONCE(se->status, BLK_SE_STS_REMOVE_IN_PROGRESS);
>> +	if (paired_se && READ_ONCE(paired_se->status) != BLK_SE_STS_REMOVED)
>> +		WRITE_ONCE(paired_se->status, BLK_SE_STS_REMOVE_IN_PROGRESS);
> 
> [Severity: Medium]
> When zloop_remove_element() is called on an element that was previously marked
> as degraded, won't this unconditionally overwrite the status to
> BLK_SE_STS_REMOVE_IN_PROGRESS?
> 
> If the status changes to BLK_SE_STS_REMOVE_IN_PROGRESS, the check in
> zloop_prep_rq() for BLK_SE_STS_DEGRADED will no longer match. Does this
> mean that I/O will unexpectedly succeed on the degraded element until the
> 2-second delayed removal work actually offlines the zones?

Yes. The remove in progress condition needs to be checked too.

> 
> [ ... ]
> 
>> @@ -1944,6 +1988,42 @@ static int zloop_ctl_remove(struct zloop_options *opts)
>>  	return 0;
>>  }
>>  
>> +static int zloop_ctl_degrade_element(struct zloop_options *opts)
>> +{
>> +	struct zloop_device *zlo;
>> +	int ret = 0;
>> +
>> +	if (!(opts->mask & ZLOOP_OPT_ID)) {
>> +		pr_err("No ID specified for degrade_element\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (opts->mask & ~(ZLOOP_OPT_ID | ZLOOP_OPT_ELEMENT_ID)) {
>> +		pr_err("Invalid option specified for degrade_element\n");
>> +		return -EINVAL;
>> +	}
> 
> [Severity: Low]
> Does this code silently fail if the user omits the element_id option?

No. The missing element_id option is checked before this if.

> 
> The check above ensures no invalid options are provided, but it lacks a
> validation to ensure ZLOOP_OPT_ELEMENT_ID is actually present in opts->mask.
> If omitted, opts->element_id defaults to 0, which gets rejected silently inside
> zloop_degrade_element() without any error message to the user.
> 
>> +
>> +	mutex_lock(&zloop_ctl_mutex);
>> +
>> +	zlo = idr_find(&zloop_index_idr, opts->id);
>> +	if (!zlo || zlo->state == Zlo_creating)
>> +		ret = -ENODEV;
>> +	else if (zlo->state == Zlo_deleting)
>> +		ret = -EINVAL;
>> +	if (ret)
>> +		goto unlock;
>> +
>> +	ret = zloop_degrade_element(zlo, opts->element_id);
>> +	if (!ret)
>> +		pr_info("Degraded element %u of device %u\n",
>> +			opts->id, opts->element_id);
> 
> [Severity: Low]
> Are the arguments to pr_info() swapped here?

Yes they are.

> 
> The format string specifies "element %u of device %u", but the variables are
> passed as opts->id (the device ID) followed by opts->element_id (the element
> ID). This will display the values in the reverse order of the text.
> 
>> +
>> +unlock:
>> +	mutex_unlock(&zloop_ctl_mutex);
>> +
>> +	return ret;
>> +}
> 


-- 
Damien Le Moal
Western Digital Research
