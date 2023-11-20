Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410D8CF;
	Mon, 20 Nov 2023 15:58:57 -0800 (PST)
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-280351c32afso3989210a91.1;
        Mon, 20 Nov 2023 15:58:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700524736; x=1701129536;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/40zxP6irGy1o9ycOvbKwOnVPv8rOKZ+3Lyg8ZQ0JM4=;
        b=n2yw1FH6eIaatLnRDTlLg2cNJBtrmjnmgkMo41rfcieyZYRmKp1D6WPnM17Wl+RYFy
         SaFkWh3pVjz8Zx6BijcU65gPx6zf3sRN1rwWVgRiAWndxvmMbEhpRlhyk7ane++IaQ9H
         s8CTWyfIXZ76cwl/in7dqQsDBbK+eVICFlnCKPoqMr9pPbYY8LFGl6sy8bl2hJPBNKBq
         NpnV9P6N0+kpJgiS2SPGPdRvjENIIoCvbZE4sJ3Xmk68Q3BGxE/kqHJE30EL+hXsLuL2
         YHsZr50DdcGgrdwlHSGLQ2TXqFmltjUTU2MjsRttdzRGl6u8V0KMiTB/HOJl/zsOfQ/Y
         +Bxg==
X-Gm-Message-State: AOJu0YwcC/fFKprj7IJAFN7eySt+1KyBtEdmB8TtE3dvmxhM6g0fE9uf
	dkHCu1s1PCLtyZbbUnZXg5BGsIfpG6g=
X-Google-Smtp-Source: AGHT+IEEOfP6hsU+Y4ehUMpL18m/V+1IC+iMrLsKkC6HcENAVxf2jJPLAqeQ1o6ZHblo5JhkoteOsA==
X-Received: by 2002:a17:903:11d1:b0:1b8:90bd:d157 with SMTP id q17-20020a17090311d100b001b890bdd157mr11914249plh.26.1700524736522;
        Mon, 20 Nov 2023 15:58:56 -0800 (PST)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net. [73.231.117.72])
        by smtp.gmail.com with ESMTPSA id je7-20020a170903264700b001ce669e4662sm5156650plb.61.2023.11.20.15.58.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Nov 2023 15:58:56 -0800 (PST)
Message-ID: <a4233f10-56c7-4d57-8875-f29efe815627@acm.org>
Date: Mon, 20 Nov 2023 15:58:52 -0800
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
To: Damien Le Moal <dlemoal@kernel.org>,
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
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c789e381-f0c4-4c61-bbc7-069a834841c9@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/20/23 15:02, Damien Le Moal wrote:
> On 11/21/23 05:44, Bart Van Assche wrote:
>> How about applying this (untested) patch on top of this patch series?
>>
>> diff --git a/block/blk-settings.c b/block/blk-settings.c
>> index 4c776c08f190..aba1972e9767 100644
>> --- a/block/blk-settings.c
>> +++ b/block/blk-settings.c
>> @@ -84,8 +84,6 @@ void blk_set_stacking_limits(struct queue_limits *lim)
>>    	lim->max_dev_sectors = UINT_MAX;
>>    	lim->max_write_zeroes_sectors = UINT_MAX;
>>    	lim->max_zone_append_sectors = UINT_MAX;
>> -	/* Request-based stacking drivers do not reorder requests. */
>> -	lim->driver_preserves_write_order = true;
>>    }
>>    EXPORT_SYMBOL(blk_set_stacking_limits);
>>
>> diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
>> index 2d3e186ca87e..cb9abe4bd065 100644
>> --- a/drivers/md/dm-linear.c
>> +++ b/drivers/md/dm-linear.c
>> @@ -147,6 +147,11 @@ static int linear_report_zones(struct dm_target *ti,
>>    #define linear_report_zones NULL
>>    #endif
>>
>> +static void linear_io_hints(struct dm_target *ti, struct queue_limits *limits)
>> +{
>> +	limits->driver_preserves_write_order = true;
>> +}
> 
> Hmm, but does dm-linear preserve write order ? I am not convinced. And what
> about dm-flakey, dm-error and dm-crypt ? All of these also support zoned
> devices. I do not think that we can say that any of these preserve write order.

Hi Damien,

I propose to keep any changes for files in the drivers/md/ directory for
later. This patch series is already big enough. Additionally, I don't
need the dm changes myself since Android does does not use dm-linear nor
dm-verity to access a zoned logical unit. All we need to know right now
is that the approach of this patch series can be extended to dm drivers.

Thanks,

Bart.

