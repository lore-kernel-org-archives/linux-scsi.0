Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AD8FC41513
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Aug 2023 16:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238417AbjHOQGz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Aug 2023 12:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238432AbjHOQGv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Aug 2023 12:06:51 -0400
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 338E2C5;
        Tue, 15 Aug 2023 09:06:51 -0700 (PDT)
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1bba48b0bd2so36772705ad.3;
        Tue, 15 Aug 2023 09:06:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692115610; x=1692720410;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IAWn9Z/Pj9Pv3OLpYs+JGavERMMJKp5XghyG4qBhN98=;
        b=QPcxz/QUXhl6YlNro3Z4zqMlONdSco24IjGTaKZBpoQ+okVH2BmNghovOnFo/S11nO
         EVbXCeBGXugdzwOV51uPKPcBnPOHIWAaFtCo1MH2bHKxMknRccPIyO3opfyKrkeomWem
         AqHde44M6QT1AXD9Y1Vl5lLmA4Gk0QNtNCNTmqsjnqa/aXWLgxFchcvnJVerQeMSjrBJ
         fsmhZr8MGqbZe3aL33c6sqnndAHuc5B0njZzVNeRkJ+tXTsySn6VJPITj3rx6ZTuWxdN
         nX4LLEvq6Id4x3rRLQ+NPCBys+zzfKQFjnB7wBJLUxziNr6Xgz+DPvTSTbU7s+zPd3J8
         bgpQ==
X-Gm-Message-State: AOJu0YwkPdZ0hBhGCax4PYYyzI4A4vuuBQI/rp62pNLX7rFacERSdGAS
        uUYHQL99bSWN2EARrVtlT0g=
X-Google-Smtp-Source: AGHT+IFM3fdPrSkdfesSiiMMxGUACCDpbj4KtCXUVB+4bEekrYIk/BIBGW61Z3ivuFAgQsYJUL2fVw==
X-Received: by 2002:a17:903:2695:b0:1bd:eef1:41c0 with SMTP id jf21-20020a170903269500b001bdeef141c0mr3269474plb.29.1692115610545;
        Tue, 15 Aug 2023 09:06:50 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:a40d:28ad:b5b9:2ae2? ([2620:15c:211:201:a40d:28ad:b5b9:2ae2])
        by smtp.gmail.com with ESMTPSA id bf9-20020a170902b90900b001bc39aa63ebsm11227159plb.121.2023.08.15.09.06.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Aug 2023 09:06:49 -0700 (PDT)
Message-ID: <488b3264-1c00-bb89-331d-f2c6f5ec1957@acm.org>
Date:   Tue, 15 Aug 2023 09:06:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Subject: Re: [PATCH v8 1/9] block: Introduce more member variables related to
 zone write locking
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
References: <20230811213604.548235-1-bvanassche@acm.org>
 <20230811213604.548235-2-bvanassche@acm.org>
 <3188f400-b387-7be8-0f21-cf5089fe1411@kernel.org>
 <5a2b24c5-14c5-57a6-8af0-6ebdee2371de@acm.org>
 <66fa32a0-1c0d-1346-a77f-42b99058a1c3@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <66fa32a0-1c0d-1346-a77f-42b99058a1c3@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/14/23 19:01, Damien Le Moal wrote:
> On 8/15/23 01:57, Bart Van Assche wrote:
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -4350,6 +4350,7 @@ static void ufshcd_update_preserves_write_order(struct ufs_hba *hba,
>>    		blk_mq_freeze_queue_wait(q);
>>    		q->limits.driver_preserves_write_order = preserves_write_order;
>>    		blk_mq_unfreeze_queue(q);
>> +		scsi_rescan_device(&sdev->sdev_gendev);
> 
> Maybe calling disk_set_zoned() before blk_mq_unfreeze_queue() should be enough ?
> rescan/revalidate will be done in case you get a topology change event (or
> equivalent), which I think is not the case here.

Hi Damien,

I will look into calling disk_set_zoned() before blk_mq_unfreeze_queue().

Thanks,

Bart.

