Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26DDCC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 00:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239510AbiBIATu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 19:19:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbiBIATs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 19:19:48 -0500
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 985FDC061576
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 16:19:47 -0800 (PST)
Received: by mail-pj1-f41.google.com with SMTP id d9-20020a17090a498900b001b8bb1d00e7so597939pjh.3
        for <linux-scsi@vger.kernel.org>; Tue, 08 Feb 2022 16:19:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jd9SQ7PSOaqpwqmTZsZA4dGI3/6UYeiQOoe2nsx24w4=;
        b=NNe1+z7e//MYkVWNtxuUipBcMi1iOBGTNAA2HGYKcCnDKZddxar+3uQwHSiKR0Ntkr
         DS2moV+Tug68wlwzwEe2GAI2jO7jMykkUpBRqOefjq/726X+9kr3X1djQ69tuc70tCQK
         +OhjC+tYNGPZqqWaoFRimZCjtJvdVRMa8ezjYhASjoGqcnjA898BH6CrSmDAoL6KrnIn
         KnOJOLg/uLmh//mnkBfQ6LHeCJhTl8ExP+HVCM697eQggO8s4UE9uOJm5iRiMyUJiLov
         N3K/31KS2+ms5dAq7Gu9WwK9pEHL9CmiqaZtp1sterrv/UZl9fZDpE+xAbosZvtQdXdg
         SAiQ==
X-Gm-Message-State: AOAM533ur44mR5e398i7XOVOLiy/dqb0diosCJCBtQF8mFti6n568b8X
        eFYytHhmh/f2KhTY9+oTefn1NlYB4dU5mXTy
X-Google-Smtp-Source: ABdhPJzznJQI/tihCc7UDSW6Acd3igw+BKidkk9C7S36Oj2EsPceuQ1S+tOHvBs9oH4XB3a2LL/kXw==
X-Received: by 2002:a17:902:d3c6:: with SMTP id w6mr6662773plb.44.1644365986920;
        Tue, 08 Feb 2022 16:19:46 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id y15sm16725692pfi.87.2022.02.08.16.19.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Feb 2022 16:19:46 -0800 (PST)
Message-ID: <e72b0d31-1ee4-3213-371e-81cd7d683724@acm.org>
Date:   Tue, 8 Feb 2022 16:19:44 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v2 30/44] mvsas: Fix a set-but-not-used warning
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Yufen Yu <yuyufen@huawei.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-31-bvanassche@acm.org>
 <0e3cf0a7-1574-edb5-3bf1-dafe5eaa069b@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <0e3cf0a7-1574-edb5-3bf1-dafe5eaa069b@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/8/22 09:50, John Garry wrote:
> On 08/02/2022 17:25, Bart Van Assche wrote:
>> @@ -559,10 +558,14 @@ static int mvs_pci_init(struct pci_dev *pdev, 
>> const struct pci_device_id *ent)
>>           }
>>           nhost++;
>>       } while (nhost < chip->n_host);
>> -    mpi = (struct mvs_prv_info *)(SHOST_TO_SAS_HA(shost)->lldd_ha);
>>   #ifdef CONFIG_SCSI_MVSAS_TASKLET
> 
> I really doubt the value such config options

So do I, but removing that config option falls outside the scope of this 
patch series.
>> +    {
>> +    struct mvs_prv_info *mpi;
>> +
>> +    mpi = (struct mvs_prv_info *)(SHOST_TO_SAS_HA(shost)->lldd_ha);
> 
> nit: I don't think that we require the cast to struct mvs_prv_info *
  Agreed, no explicit cast is required since lldd_ha has type 'void *'. 
I will remove the cast.

Thanks,

Bart.
