Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CE570CB3;
	Mon, 25 Mar 2024 23:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711408662; cv=none; b=GHJNRmguN4aoR9hY29duYF+OmweoGd8DneCtmKyerLSOplaU3KKqTSP7+WRs/Mu5Il6IKbo09oMM6yIbSjk+pDOEQRjsTqvf8XjGQdaEXLa4g61wkKofv8sadeA5rnjkS7oyTQOKhGI3FtBq7fXouhPoEP24qLvcFWbTBZvOEIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711408662; c=relaxed/simple;
	bh=eX+nnrw2vRDpB8LH/AreoGfYWoaX1acBcF7HGBiBLoo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n71lk9tXLx/Hvc8OAb/cuYNwyy4d74g53gJIyVg6zu2SN3UxFHHOZz35qKRPq5Tv0XEO8w4pBxvCAtjxf8XK3JRq3Gtk+/Y55MY+RyvxgcND/f/UULDCuwUDyayr3yQ9wZRYA7rA0tEUkMUVZ+rrWk3nOT2TmDmEg3WvwRuj/8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jsDfCifQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jsDfCifQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 022EEC433F1;
	Mon, 25 Mar 2024 23:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711408662;
	bh=eX+nnrw2vRDpB8LH/AreoGfYWoaX1acBcF7HGBiBLoo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jsDfCifQLAIk9JJuzE4as6hgMMbGilVN04XANFdzSirIw+L3eUQi37r63UrKYiL3D
	 TWR6cwOOnRFjMX1FZsfySJM2U75ggJ+TV4aXRS/Spl3FoFy/BxffxYb0xeS4IT5mGR
	 XkECos6AlT4V8BSYikVSrz29nUeGwSymR+QM1H9OUxWA9A9IHmKVpVNr+8/M6NeJY8
	 KjsFY6/MNopqVGuRkz1w7rwZ1tIoWR3U9sOzKQhfKOnYJqRpYmVy7fDYhJWlDVAD+H
	 fzfee8JC7GeYSYPAUdOFpOPAyIMJPseP/9Q3cmdH6WE/r7NV2pEaGuJSHmC1Jl8ErJ
	 IdX0m9VxKB53w==
Message-ID: <3412b80a-a5a0-489c-96b9-d9b2652540e4@kernel.org>
Date: Tue, 26 Mar 2024 08:17:39 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 25/28] block: Move zone related debugfs attribute to
 blk-zoned.c
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
 <20240325044452.3125418-26-dlemoal@kernel.org>
 <ddc7708f-fcfa-45da-af01-601ea7ca8897@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ddc7708f-fcfa-45da-af01-601ea7ca8897@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/26/24 07:20, Bart Van Assche wrote:
> On 3/24/24 21:44, Damien Le Moal wrote:
>> diff --git a/block/blk-mq-debugfs.h b/block/blk-mq-debugfs.h
>> index 9c7d4b6117d4..3ebe2c29b624 100644
>> --- a/block/blk-mq-debugfs.h
>> +++ b/block/blk-mq-debugfs.h
>> @@ -83,7 +83,7 @@ static inline void blk_mq_debugfs_unregister_rqos(struct rq_qos *rqos)
>>   }
>>   #endif
>>   
>> -#ifdef CONFIG_BLK_DEBUG_FS_ZONED
>> +#if defined(CONFIG_BLK_DEV_ZONED) && defined(CONFIG_BLK_DEBUG_FS)
>>   int queue_zone_wlock_show(void *data, struct seq_file *m);
>>   #else
>>   static inline int queue_zone_wlock_show(void *data, struct seq_file *m)
>> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
>> index 03222314d649..62160a8675f4 100644
>> --- a/block/blk-zoned.c
>> +++ b/block/blk-zoned.c
>> @@ -22,6 +22,7 @@
>>   
>>   #include "blk.h"
>>   #include "blk-mq-sched.h"
>> +#include "blk-mq-debugfs.h"
>>   
>>   #define ZONE_COND_NAME(name) [BLK_ZONE_COND_##name] = #name
>>   static const char *const zone_cond_name[] = {
>> @@ -1745,3 +1746,22 @@ void blk_zone_dev_init(void)
>>   {
>>   	blk_zone_wplugs_cachep = KMEM_CACHE(blk_zone_wplug, SLAB_PANIC);
>>   }
>> +
>> +#ifdef CONFIG_BLK_DEBUG_FS
>> +
>> +int queue_zone_wlock_show(void *data, struct seq_file *m)
>> +{
>> +	struct request_queue *q = data;
>> +	unsigned int i;
>> +
>> +	if (!q->disk->seq_zones_wlock)
>> +		return 0;
>> +
>> +	for (i = 0; i < q->disk->nr_zones; i++)
>> +		if (test_bit(i, q->disk->seq_zones_wlock))
>> +			seq_printf(m, "%u\n", i);
>> +
>> +	return 0;
>> +}
>> +
>> +#endif
> 
> This patch increases the number of #ifdefs in block layer .c files so
> I'm not sure that this patch can be considered an improvement.

Not following... This removes CONFIG_BLK_DEBUG_FS_ZONED and only add this single
ifdef here in blk-zoned.c instead of testing the removed config in
blk-mq-debugfs.h. Same count and one less config. Sure, there is one ifdef in c
code added. But I *really* prefer that instead of having zone related code all
over the place guarded with #if defined(CONFIG_BLK_DEV_ZONED).

So unless Jens is against this change, I am keeping it.

> 
> Thanks,
> 
> Bart.

-- 
Damien Le Moal
Western Digital Research

