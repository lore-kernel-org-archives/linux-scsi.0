Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A3C2FE;
	Sun,  3 Dec 2023 20:13:37 -0800 (PST)
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6cdea2f5918so2398214b3a.2;
        Sun, 03 Dec 2023 20:13:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701663217; x=1702268017;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uN3bzbyeWcghI1KnaMB29wgwuBrNNkdpOT/Q5Af7e6M=;
        b=FaM3xQI6BJ7NddgrKmsu1zsj09dLjZXlct9TIm8jEHdf09UupMMM3omLTPoXRO92BQ
         HKfwRu1sHNNVdrRWMc22XKW+c4MAP875g5+q3/ymE2LXGm80o75ug0C9THvTCqXGuI2F
         9sir+5XECsTlHBOoRKdnWK7oXaJ1aAf4otsGzcvOyFz/YVuncQ9Yk8yD1JXB77+xGEep
         46r7GPf8b9FMzvq244wdY/cMpLQ9/YFXMtuxj8/GMWjWLnH77ooTq284yrptZNVUpiLR
         oB7TAD3C9pSRNfFZNUkRC0616CuEYmXOQnw9/3+A7mu4Knj9JEEYQig+9mwr6n05eGaW
         3WrA==
X-Gm-Message-State: AOJu0YxsLNIAJel+sFVzmxML8ya2gYX9AoF+FB/LhDy5ol4EpNuDA6zO
	W4Q0ENqaiS6uqPdJ9xeZIq8=
X-Google-Smtp-Source: AGHT+IHMQ7UlA/TkoW3SWrTgiAU5rcCOHIe4yQDzBy3Kmxhp9aOqtKaXGsqv2F8cRgATVP0ClL+Bjg==
X-Received: by 2002:a05:6a20:1586:b0:18f:97c:5b84 with SMTP id h6-20020a056a20158600b0018f097c5b84mr880558pzj.82.1701663216906;
        Sun, 03 Dec 2023 20:13:36 -0800 (PST)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net. [73.231.117.72])
        by smtp.gmail.com with ESMTPSA id x11-20020a056a00270b00b006cbb83adc1bsm2057945pfv.44.2023.12.03.20.13.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Dec 2023 20:13:36 -0800 (PST)
Message-ID: <8372f2d0-b695-4af4-90e6-e35b86e3b844@acm.org>
Date: Sun, 3 Dec 2023 20:13:34 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/4] block: Make fair tag sharing configurable
Content-Language: en-US
To: Yu Kuai <yukuai1@huaweicloud.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
 Keith Busch <kbusch@kernel.org>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Ed Tsai <ed.tsai@mediatek.com>, Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20231130193139.880955-1-bvanassche@acm.org>
 <20231130193139.880955-2-bvanassche@acm.org>
 <58f50403-fcc9-ec11-f52b-f11ced3d2652@huaweicloud.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <58f50403-fcc9-ec11-f52b-f11ced3d2652@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/1/23 23:21, Yu Kuai wrote:
> 在 2023/12/01 3:31, Bart Van Assche 写道:
>> +/*
>> + * Enable or disable fair tag sharing for all request queues 
>> associated with
>> + * a tag set.
>> + */
>> +void blk_mq_update_fair_sharing(struct blk_mq_tag_set *set, bool enable)
>> +{
>> +    const unsigned int DFTS_BIT = 
>> ilog2(BLK_MQ_F_DISABLE_FAIR_TAG_SHARING);
>> +    struct blk_mq_hw_ctx *hctx;
>> +    struct request_queue *q;
>> +    unsigned long i;
>> +
>> +    /*
>> +     * Serialize against blk_mq_update_nr_hw_queues() and
>> +     * blk_mq_realloc_hw_ctxs().
>> +     */
>> +    mutex_lock(&set->tag_list_lock);
> I'm a litter confused about this comment, because
> blk_mq_realloc_hw_ctxs() can be called from
> blk_mq_update_nr_hw_queues().
> 
> If you are talking about blk_mq_init_allocated_queue(), it looks like
> just holding this lock is not enough?

I added that comment because blk_mq_init_allocated_queue() calls
blk_mq_realloc_hw_ctxs() before the request queue is added to
set->tag_list. I will take a closer look at how
blk_mq_init_allocated_queue() reads set->flags and will make sure
that these reads are properly serialized against the changes made
by blk_mq_update_fair_sharing().

Thanks,

Bart.
