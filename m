Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412CA4085B
	for <linux-scsi@vger.kernel.org>; Thu, 28 Mar 2024 23:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711667010; cv=none; b=TrGjz8emAbv9T+eviTQGAsC8ntLSjex0HRlZ3CrsCVrFvHQbhObIBrqV/lU9XX06F/Vsoou4ska9EvuPI1lTuPD8Ag3RUc37zegNaUl41abVpZO8d4v8zOuq5dyg2HMYEg/kqbnahtYJqUIy1uUtfnDwWmIm/a8mErNxgr9J7fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711667010; c=relaxed/simple;
	bh=KwDcoCTiQgifLAZkD8YMxnhyc8iS8IPhp9Oi083rYhY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=e+QJ8CmpGXw9P2R6jwJ9qEu3JdGJh7hF8a7pgjVTluUCk6092Lv0fd64hb+bPPsgL6zGyt52nlwNWESfAgpXpFMq+0ujQO0eJJQDxjCLIyJSzbGyC+OjUYfDCf1rPGHGrUBugayB6d/8w2K4RZNMjEVomiB8KPnqSRah69zBfFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IXKSnEat; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IXKSnEat"
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3688dcc5055so957945ab.1
        for <linux-scsi@vger.kernel.org>; Thu, 28 Mar 2024 16:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711667007; x=1712271807; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XpkAyFXDfnKKrnORiizuu0vbWhnwqe4qRQcMbxyl2vI=;
        b=IXKSnEat5rY7RFM/toezuCHss5DGLlIXMue6DEJTf3cOifsU662B1blY2tpCH00BcH
         md3xwa40YZO6t0KDD4jZIQDlapppXP90RsBkG7eYpFntvb1NoIyKC76m3Ksp6Hj8gzXo
         3Y+MnT4Linrc6HDd1CY9xp8Zv587LlenuBotZ6YFEp6t0FGQviKL+ANYlspHvHdabkrZ
         ZQJdCnZ+CD3vneBL7Uvei5WIFzk3tGjmBorhGA3io20DDsN5mYWCkHPrfFuZZEEJiBLS
         4Qp1hP5PnLmXsHWTASNjGvUYviiP/bnxoPewbR2CJPAHdgZhKpHe9ncppDLdnGVbU0/v
         j4yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711667007; x=1712271807;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XpkAyFXDfnKKrnORiizuu0vbWhnwqe4qRQcMbxyl2vI=;
        b=J+ozkCwH5N73LwqjGHF/B/SpB6T1HFAT62DLgdTRiVIRBWDy8yCwH+bpBiaQxnn/Lo
         14oQrqP5rLWHVDJgSU73a7dhq1VqU4/CmgEgWxlbvaZ4kmvvWOSgvhLLoTsiDjxUe5WJ
         bFuwu8AFgHFLS8JlN9bXpHwf8mewvevj2HmA90/wIWMwFgy8YV01myLe2k+YHnz87W0c
         FSG/RgMiKXvpnusj+tVmW4K/6Ba/Cn5ioKsInPqcoa3co9536HgM+aOwMzILbPDx4E+e
         vA5CJCZpTAupN80d8IVdCLvUm/hI7ZTOCZBPrFSL3hpI5n0ohCNTaUSRfgKODfdItkIB
         Dbzw==
X-Forwarded-Encrypted: i=1; AJvYcCWfH+9LbRAq81xoUsTIXjqj2N/xLUX6HKU40J9lTOCtXwz24vjuF+hHF6gOPWA2PVZq5f4eE8EMWTUKpk4ddlr3pqkmPK1UWfClqg==
X-Gm-Message-State: AOJu0YzPXelJFmzHCpQUgT1U7qF5cUSCb7GMVit11SwoOX/vRDkfSJdC
	8GWk97Rgg8rJJdErAQJWNl3qmLmM2yNpmINTL1Qisbxf8NAYAEYCuW+7o9G/078=
X-Google-Smtp-Source: AGHT+IHAI1GJZLWvZiX+0hK7hw4PeNQyK/rx84JPWm9big8mT9eaCtaTSySO5HhDhFTfwSSCdLU3UA==
X-Received: by 2002:a05:6e02:350c:b0:365:224b:e5f7 with SMTP id bu12-20020a056e02350c00b00365224be5f7mr610977ilb.1.1711667007379;
        Thu, 28 Mar 2024 16:03:27 -0700 (PDT)
Received: from [192.168.201.244] ([50.234.116.5])
        by smtp.gmail.com with ESMTPSA id 8-20020a630f48000000b005f0793db2ebsm1843234pgp.74.2024.03.28.16.03.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Mar 2024 16:03:26 -0700 (PDT)
Message-ID: <acf9949e-f4a2-49f7-9f6f-351c8158522a@kernel.dk>
Date: Thu, 28 Mar 2024 17:03:25 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/30] block: Do not force full zone append completion
 in req_bio_endio()
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, Bart Van Assche
 <bvanassche@acm.org>, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-2-dlemoal@kernel.org>
 <a474bae3-e505-4d17-a5e4-ed9928b6cbb3@acm.org>
 <935b43c0-b5cc-48ef-a283-564499ac7bde@kernel.org>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <935b43c0-b5cc-48ef-a283-564499ac7bde@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/28/24 4:43 PM, Damien Le Moal wrote:
> On 3/29/24 03:14, Bart Van Assche wrote:
>> On 3/27/24 17:43, Damien Le Moal wrote:
>>> This reverts commit 748dc0b65ec2b4b7b3dbd7befcc4a54fdcac7988.
>>>
>>> Partial zone append completions cannot be supported as there is no
>>> guarantees that the fragmented data will be written sequentially in the
>>> same manner as with a full command. Commit 748dc0b65ec2 ("block: fix
>>> partial zone append completion handling in req_bio_endio()") changed
>>> req_bio_endio() to always advance a partially failed BIO by its full
>>> length, but this can lead to incorrect accounting. So revert this
>>> change and let low level device drivers handle this case by always
>>> failing completely zone append operations. With this revert, users will
>>> still see an IO error for a partially completed zone append BIO.
>>>
>>> Fixes: 748dc0b65ec2 ("block: fix partial zone append completion handling in req_bio_endio()")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
>>> ---
>>>   block/blk-mq.c | 9 ++-------
>>>   1 file changed, 2 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>>> index 555ada922cf0..32afb87efbd0 100644
>>> --- a/block/blk-mq.c
>>> +++ b/block/blk-mq.c
>>> @@ -770,16 +770,11 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
>>>   		/*
>>>   		 * Partial zone append completions cannot be supported as the
>>>   		 * BIO fragments may end up not being written sequentially.
>>> -		 * For such case, force the completed nbytes to be equal to
>>> -		 * the BIO size so that bio_advance() sets the BIO remaining
>>> -		 * size to 0 and we end up calling bio_endio() before returning.
>>>   		 */
>>> -		if (bio->bi_iter.bi_size != nbytes) {
>>> +		if (bio->bi_iter.bi_size != nbytes)
>>>   			bio->bi_status = BLK_STS_IOERR;
>>> -			nbytes = bio->bi_iter.bi_size;
>>> -		} else {
>>> +		else
>>>   			bio->bi_iter.bi_sector = rq->__sector;
>>> -		}
>>>   	}
>>>   
>>>   	bio_advance(bio, nbytes);
>>
>> Hi Damien,
>>
>> This patch looks good to me but shouldn't it be separated from this
>> patch series? I think that will help this patch to get merged sooner.
> 
> Yes, it can go on its own. But patch 3 depends on it so I kept it in the series.
> 
> Jens,
> 
> How would you like to proceed with this one ?

I can just pick it up separately.

-- 
Jens Axboe


