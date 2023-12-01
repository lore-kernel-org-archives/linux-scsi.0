Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E7DD99;
	Fri,  1 Dec 2023 14:14:53 -0800 (PST)
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1d069b1d127so4224935ad.0;
        Fri, 01 Dec 2023 14:14:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701468893; x=1702073693;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QQqLfuL0yzwBHh3YArsTFlBmIfIaZRtpkmMP/b6bF+E=;
        b=u49vD6DbiNq8gVccT1s4ajAZFRsHE511YTFTlO4PSyogR3BGAD/sB2vwJcv1ougF51
         cHDMWXN8NbEi4fJ+QAkSN0LwD3Ji4GPVTUI5RiFuBW0qfL0MJNv5WbuiCsFWJJWRUY7S
         BHhlEzlladOzcA7TtVIP0vlhfVWQyBkiE6YQw1Ru9BEPYsDNkCgL1HialZv9+slWD4Ys
         lw7IeOeEMxIytfuj+tfD/ld1UdeoPSpB80Ks5cwWJa3HdoHI+M21/B0iYBDlAjD1vasJ
         tSNInwluNRk1QQn/iWcLXFZFDsr2sT5be+brDPdEp6z7dsshyFEJDpxP8q/RmY+7Dvc7
         NU8g==
X-Gm-Message-State: AOJu0YzQsJlecqDSIA4YrYP+hvhEqxC1BmIgkq1w1VO20HY+7H3ZpeR3
	deXMEdKJ+7lIqhGr0zgLGe4OkdFs6mI7EA==
X-Google-Smtp-Source: AGHT+IHPmgHat07EwFnXbdWuHASQXDxVzsIvbOPDwMTc36CSanYp8dGaLqv8KkouleS3pxjDnaPU5Q==
X-Received: by 2002:a17:902:f54a:b0:1d0:6ffd:f1f3 with SMTP id h10-20020a170902f54a00b001d06ffdf1f3mr147712plf.73.1701468892853;
        Fri, 01 Dec 2023 14:14:52 -0800 (PST)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net. [73.231.117.72])
        by smtp.gmail.com with ESMTPSA id l7-20020a170902f68700b001cc2ebd2c2csm1112660plg.256.2023.12.01.14.14.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Dec 2023 14:14:51 -0800 (PST)
Message-ID: <22a70cc4-2150-4296-84d5-f0bf6617613a@acm.org>
Date: Fri, 1 Dec 2023 14:14:49 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/4] block: Make fair tag sharing configurable
Content-Language: en-US
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
 Keith Busch <kbusch@kernel.org>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Yu Kuai <yukuai1@huaweicloud.com>, Ed Tsai <ed.tsai@mediatek.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
References: <20231130193139.880955-1-bvanassche@acm.org>
 <20231130193139.880955-2-bvanassche@acm.org>
 <e728ac4b-bce4-4c2e-88bb-8874c73f0c8e@wdc.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <e728ac4b-bce4-4c2e-88bb-8874c73f0c8e@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/1/23 04:52, Johannes Thumshirn wrote:
> On 30.11.23 20:31, Bart Van Assche wrote:
>> +void blk_mq_update_fair_sharing(struct blk_mq_tag_set *set, bool enable)
>> +{
>> +	const unsigned int DFTS_BIT = ilog2(BLK_MQ_F_DISABLE_FAIR_TAG_SHARING);
>> +	struct blk_mq_hw_ctx *hctx;
>> +	struct request_queue *q;
>> +	unsigned long i;
>> +
>> +	/*
>> +	 * Serialize against blk_mq_update_nr_hw_queues() and
>> +	 * blk_mq_realloc_hw_ctxs().
>> +	 */
>> +	mutex_lock(&set->tag_list_lock);
>> +	list_for_each_entry(q, &set->tag_list, tag_set_list)
>> +		blk_mq_freeze_queue(q);
>> +	assign_bit(DFTS_BIT, &set->flags, !enable);
>> +	list_for_each_entry(q, &set->tag_list, tag_set_list)
>> +		queue_for_each_hw_ctx(q, hctx, i)
>> +			assign_bit(DFTS_BIT, &hctx->flags, !enable);
>> +	list_for_each_entry(q, &set->tag_list, tag_set_list)
>> +		blk_mq_unfreeze_queue(q);
>> +	mutex_unlock(&set->tag_list_lock);
> 
> Hi Bart,
> 
> The above code adds a 3rd user (at least) of the following pattern to
> the kernel:
> 
> 	list_for_each_entry(q, &set->tag_list, tag_set_list)
> 		blk_mq_freeze_queue(q);
> 
> 	/* do stuff */
> 
> 	list_for_each_entry(q, &set->tag_list, tag_set_list)
> 		blk_mq_unfreeze_queue(q);
> 
> Would it maybe be beneficial if we'd introduce functions for this, like:
> 
> static inline void blk_mq_freeze_tag_set(struct blk_mq_tag_set *set)
> {
> 	lockdep_assert_held(&set->tag_list_lock);
> 
> 	list_for_each_entry(q, &set->tag_list, tag_set_list)
> 		blk_mq_freeze_queue(q);
> }
> 
> static inline void blk_mq_unfreeze_tag_set(struct blk_mq_tag_set *set)
> {
> 	lockdep_assert_held(&set->tag_list_lock);
> 
> 	list_for_each_entry(q, &set->tag_list, tag_set_list)
> 		blk_mq_unfreeze_queue(q);
> }

Hi Johannes,

That sounds like a good idea to me. I will make this change.

Thanks,

Bart.
