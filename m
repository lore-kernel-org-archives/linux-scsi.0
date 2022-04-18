Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76B77C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Apr 2022 16:56:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346720AbiDRQ6u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Apr 2022 12:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346837AbiDRQ5z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Apr 2022 12:57:55 -0400
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2F734645
        for <linux-scsi@vger.kernel.org>; Mon, 18 Apr 2022 09:53:11 -0700 (PDT)
Received: by mail-pg1-f176.google.com with SMTP id bg9so19846151pgb.9
        for <linux-scsi@vger.kernel.org>; Mon, 18 Apr 2022 09:53:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=P7FvoVpUW/+JgmKjbomXqdf3D/4gb1ayt6rr44PvwNA=;
        b=HpYNfZxxgm4KHo0Rr/La+U2hHs3eUjz1hf5IYQY6F2os+uNXc2V3pE4A6YNhb4658+
         g5qVj0hp6R+zI4+lqPI/dvrYqYLJs0TrFzNp5WGmX5g4XPtLgLBZjMImJdgM/8IGv7zT
         FIKyKKoYz5wb5p/1gG8io7hVghxyBX8GGPwvd3B+Ko++PBoh4rUlJNgJS1EBytMeQatE
         z9dFiXtu32cDCtxIqbvkHCZ1IUp6l97Uynntmpy46skvUAZHO/vGHsmaIPnE8Ei/CZ33
         nd/dM3RUGhs27mgnfRDmSrmekYc0TroZGcWwoLQJ0g/FfJ1VMkugxXS7A7myH5WaMYUs
         ygAA==
X-Gm-Message-State: AOAM5332VgCTIH01wuqzoMvBcyJO7D/EKv8pbI7bG7axdWDPmof/Ey8x
        ypcaeYyk90EeOkRMxNU0NSY=
X-Google-Smtp-Source: ABdhPJzJqimhf0XmpxVqvrtcn7AfhNWi5YDT1pcs9Eo/ooQrOc6Yw6hsl8ZkEvoYIpptEgi05twrzg==
X-Received: by 2002:a65:6cc8:0:b0:382:1b18:56a9 with SMTP id g8-20020a656cc8000000b003821b1856a9mr10886149pgw.347.1650300790530;
        Mon, 18 Apr 2022 09:53:10 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:713b:40eb:c240:d568? ([2620:15c:211:201:713b:40eb:c240:d568])
        by smtp.gmail.com with ESMTPSA id ml1-20020a17090b360100b001cd40539cd9sm13327178pjb.1.2022.04.18.09.53.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Apr 2022 09:53:09 -0700 (PDT)
Message-ID: <d25a0e73-a948-0b74-d4de-ab7173c35d90@acm.org>
Date:   Mon, 18 Apr 2022 09:53:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 4/8] scsi: sd_zbc: Introduce struct zoned_disk_info
Content-Language: en-US
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Hannes Reinecke <hare@suse.de>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220415201752.2793700-1-bvanassche@acm.org>
 <20220415201752.2793700-5-bvanassche@acm.org>
 <0366876d-3bd2-d505-6564-2aac772d1815@opensource.wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <0366876d-3bd2-d505-6564-2aac772d1815@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/17/22 16:16, Damien Le Moal wrote:
> On 4/16/22 05:17, Bart Van Assche wrote:
>> +/**
>> + * struct zoned_disk_info - Properties of a zoned SCSI disk.
> 
> Nit: you could say "ZBC SCSI device" to be more inline with standards
> vocabulary here instead of "zoned SCSI disk".

Will fix.

>> + * @nr_zones: number of zones.
>> + * @zone_blocks: number of logical blocks per zone.
>> + */
>> +struct zoned_disk_info {
>> +	u32		nr_zones;
>> +	u32		zone_blocks;
>> +};
>> +
>>   struct scsi_disk {
>>   	struct scsi_device *device;
>>   
>> @@ -78,10 +88,10 @@ struct scsi_disk {
>>   	struct gendisk	*disk;
>>   	struct opal_dev *opal_dev;
>>   #ifdef CONFIG_BLK_DEV_ZONED
>> -	u32		nr_zones;
>> -	u32		rev_nr_zones;
>> -	u32		zone_blocks;
>> -	u32		rev_zone_blocks;
>> +	/* Updated during revalidation before the gendisk capacity is known. */
>> +	struct zoned_disk_info	early_zone_info;
>> +	/* Updated during revalidation after the gendisk capacity is known. */
>> +	struct zoned_disk_info	zone_info;
>>   	u32		zones_optimal_open;
>>   	u32		zones_optimal_nonseq;
>>   	u32		zones_max_open;
> 
> Nit: It would be nice to pack everything under the #ifdef into the same
> structure...

Hmm ... my goal is to only include the ZBC SCSI device properties in struct
zoned_disk_info that are evaluated twice (before and after the gendisk
capacity is known). Most ZBC-related members of struct scsi_disk are only
evaluated once.

Thanks,

Bart.
