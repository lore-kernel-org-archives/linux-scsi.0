Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B520A325F;
	Tue, 28 Nov 2023 10:17:49 -0800 (PST)
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1cfb83211b9so27525785ad.3;
        Tue, 28 Nov 2023 10:17:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701195469; x=1701800269;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9ykM5pit3tyCABr+4dJQjDb2iWqO7SOgIz8BSLb3MOs=;
        b=QtJdPL0jf69oNqoeklyXvo6PHb1XMjNmETDGImi5eIqNxMplC4emvCkYr1KXx3q20+
         pf4mIbLH5cAUQoYGWmvyfMbCKlLr3F8SxNQWurxeRjs9ajSEmpR5alXxKFu+vMFT+lIQ
         S6lNfqO9CVVwBgdHAt1WbAo128qjUO2kYnCDeWrLcZ8nBCl55r8UrAqq2Xztj2TvLcjM
         4jLXb2wuIOYfrglQKQDeYbWR8iYqWrShfpOrUB9+zqKjVyNmekr0b64fUBAVf5sQf/8o
         hNF3FKutkNsZTfugOZnfPa9lLczU1tcFLdRtRZnOV1sYjeNLeWJUT5V9VGqtOdnO0T/n
         vdtQ==
X-Gm-Message-State: AOJu0YytcIWtUaqkKJs3+5PVfGflA+T0o6lfADzF86tJ5s1Zj5KcjGZx
	fwvzp1wO3/HnQZ2HIluuvZ8=
X-Google-Smtp-Source: AGHT+IHs+oXyYAtwsVir6xw1/94NRGZMskfl0HmGEXN1jhy21qSMwYODVE+W/cVCrfzynou372pZIg==
X-Received: by 2002:a17:902:ea84:b0:1cc:3b87:8997 with SMTP id x4-20020a170902ea8400b001cc3b878997mr12942376plb.57.1701195468776;
        Tue, 28 Nov 2023 10:17:48 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:1f8e:127f:6051:78b3? ([2620:0:1000:8411:1f8e:127f:6051:78b3])
        by smtp.gmail.com with ESMTPSA id l13-20020a170902d34d00b001cc29b5a2aesm10597690plk.254.2023.11.28.10.17.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Nov 2023 10:17:48 -0800 (PST)
Message-ID: <b1e346f9-19d9-47b8-9c74-6a406c5474b9@acm.org>
Date: Tue, 28 Nov 2023 10:17:46 -0800
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
 <0a522249-2b27-49a9-bf39-8d8c37b120f4@acm.org>
 <613332b7-098e-3160-f946-764873b9e71f@huaweicloud.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <613332b7-098e-3160-f946-764873b9e71f@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/27/23 18:03, Yu Kuai wrote:
> I was worried that there might be missing wakeups, why not using
> blk_mq_update_tag_set_shared() directly to disable tag sharing?

I think that calling blk_mq_update_tag_set_shared() to disable tag sharing
would be wrong because BLK_MQ_F_TAG_QUEUE_SHARED is also used for other
purposes than fair tag sharing. See e.g. blk_mq_mark_tag_wait().

>>   >> +#define QUEUE_RW_ENTRY_NO_SYSFS_MUTEX(_prefix, _name)       \
>>>> +    static struct queue_sysfs_entry _prefix##_entry = { \
>>>> +        .attr = { .name = _name, .mode = 0644 },    \
>>>> +        .show = _prefix##_show,                     \
>>>> +        .store = _prefix##_store,                   \
>>>> +        .no_sysfs_mutex = true,                     \
>>>> +    };
>>>> +
>>>
>>> This actually change all the queues from the same tagset, can we add
>>> this new entry to /sys/class/scsi_host/hostx/xxx ?
>>
>> That would make it impossible to disable fair tag sharing for block drivers
>> that are not based on the SCSI core. Are you sure that's what you want?
> 
> Yes, if there are other drivers that are sharing driver tags, this is
> not good, can you give some examples?

There is one tag set for all NVMe namespaces associated with the same
controller. Anyway, I will move this sysfs attribute to the SCSI host and
will organize the code such that a similar sysfs attribute can be added
easily to other block drivers than the SCSI core if that would be considered
useful.

Bart.

