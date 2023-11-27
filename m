Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D37BC;
	Mon, 27 Nov 2023 15:05:05 -0800 (PST)
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1cf856663a4so33145305ad.3;
        Mon, 27 Nov 2023 15:05:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701126305; x=1701731105;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QZQYFviZ0NjJMmOQCkwljhOK1QMILYnuXSQ9cUUqnio=;
        b=Tehz8kcJaKAZY/wILOFhZeEixKnOLVGss0bzfGkdS5EenAX91Ot7r6vVeyfGewWjVM
         LnHESd5n0IqWUT8GImi4ZLGGxIHBSFbf+oJXwokWbhNzYbbXTJm/3MKhGx9BOtZkT5xx
         EexVvkCAaXaP3QgnTfklJTsnwDEP+bzCDepViYrtDrx9tfWrU64b2PH2Y04eGIrFjZ3p
         9R7yQxdu8ob4Zj6o9mRCbA+WlEZQbSSgxTuXhatheO87gBiLBhUG57TUZDsy/AlGmsDZ
         MT1pVTBZakkIn7MgUkHhu0gN8bzk4HaHOBgh3+h1fIaz8qAdZGVsl5D6FjSyaxMS/C0G
         h9Jw==
X-Gm-Message-State: AOJu0YwPdvlfOWTetND/EPfCNQAfkt1WanHgeF7AheCc9AOUjzCOLgfS
	rJsWTNUhfyr2BPFAL7g1GrQ=
X-Google-Smtp-Source: AGHT+IG6nyxa/ygS3f7POO8Ki4nl96QbcWd1qBCupU+VPfqkGaOoaCgHB/aUl1wzRbi7EkhCEs4ioA==
X-Received: by 2002:a17:902:a411:b0:1cf:959d:8cf with SMTP id p17-20020a170902a41100b001cf959d08cfmr13580999plq.8.1701126304996;
        Mon, 27 Nov 2023 15:05:04 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:81f2:7dda:474a:ba23? ([2620:0:1000:8411:81f2:7dda:474a:ba23])
        by smtp.gmail.com with ESMTPSA id u16-20020a170902e81000b001c9c5a1b477sm8839283plg.169.2023.11.27.15.05.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Nov 2023 15:05:04 -0800 (PST)
Message-ID: <0a522249-2b27-49a9-bf39-8d8c37b120f4@acm.org>
Date: Mon, 27 Nov 2023 15:05:02 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/3] scsi: core: Support disabling fair tag sharing
Content-Language: en-US
To: Yu Kuai <yukuai1@huaweicloud.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
 Keith Busch <kbusch@kernel.org>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Ed Tsai <ed.tsai@mediatek.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20231114180426.1184601-1-bvanassche@acm.org>
 <20231114180426.1184601-3-bvanassche@acm.org>
 <80dee412-2fda-6a23-0b62-08f87bd7e607@huaweicloud.com>
 <d706f265-f991-45c0-a551-34ecdee55f7c@acm.org>
 <d1e94a08-f28e-ddd9-5bda-7fee28b87f31@huaweicloud.com>
 <ef7de6b5-2ed3-469e-bb01-4eacda62cd6a@acm.org>
 <e5e8e995-c38b-7b23-a0a9-5b2f285164c8@huaweicloud.com>
 <5dd7b7f7-bcae-4769-b6c8-ac0da8e69c93@acm.org>
 <1b380cbf-40e9-6ba6-62da-d3aad94809d0@huaweicloud.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1b380cbf-40e9-6ba6-62da-d3aad94809d0@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/22/23 22:29, Yu Kuai wrote:
> 在 2023/11/22 3:32, Bart Van Assche 写道:
>> +static ssize_t queue_fair_sharing_store(struct request_queue *q,
>> +                    const char *page, size_t count)
>> +{
>> +    const unsigned int DFTS_BIT = ilog2(BLK_MQ_F_DISABLE_FAIR_TAG_SHARING);
>> +    struct blk_mq_tag_set *set = q->tag_set;
>> +    struct blk_mq_hw_ctx *hctx;
>> +    unsigned long i;
>> +    int res;
>> +    bool val;
>> +
>> +    res = kstrtobool(page, &val);
>> +    if (res < 0)
>> +        return res;
>> +
>> +    mutex_lock(&set->tag_list_lock);
>> +    clear_bit(DFTS_BIT, &set->flags);
>> +    list_for_each_entry(q, &set->tag_list, tag_set_list) {
>> +        /* Serialize against blk_mq_realloc_hw_ctxs() */
> 
> If set/clear bit concurrent with test bit from io path, will there be
> problem? Why don't freeze these queues?

If that happens the changes applied through this sysfs attribute may only take
effect after a short delay (depending on how fast changes are propagated from
one CPU to another). I don't think that this is an issue?
  >> +#define QUEUE_RW_ENTRY_NO_SYSFS_MUTEX(_prefix, _name)       \
>> +    static struct queue_sysfs_entry _prefix##_entry = { \
>> +        .attr = { .name = _name, .mode = 0644 },    \
>> +        .show = _prefix##_show,                     \
>> +        .store = _prefix##_store,                   \
>> +        .no_sysfs_mutex = true,                     \
>> +    };
>> +
> 
> This actually change all the queues from the same tagset, can we add
> this new entry to /sys/class/scsi_host/hostx/xxx ?

That would make it impossible to disable fair tag sharing for block drivers
that are not based on the SCSI core. Are you sure that's what you want?

Thanks,

Bart.
