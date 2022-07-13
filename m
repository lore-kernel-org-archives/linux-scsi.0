Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0A3DC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jul 2022 20:04:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237020AbiGMUER (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jul 2022 16:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbiGMUEQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jul 2022 16:04:16 -0400
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE9F5DFBF
        for <linux-scsi@vger.kernel.org>; Wed, 13 Jul 2022 13:04:15 -0700 (PDT)
Received: by mail-pj1-f53.google.com with SMTP id t5-20020a17090a6a0500b001ef965b262eso5356743pjj.5
        for <linux-scsi@vger.kernel.org>; Wed, 13 Jul 2022 13:04:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AT8865gafO4AP8eOM0W0kP/u5ZywEtYtgelpTP7YQHI=;
        b=Z9/VJUrOoh8i5kreBRSpHO+uA9wrMbShOssikC/Xvg2J/ihSRyL9rDf2Yfm639mup+
         QOCvU/0QBkaQ7xASpFZ8bPcWfhvv2j2i7tcW3fpE6HoDaUbH8XyJXWklWEkzL7foEqN0
         ewnSSdNdw0r2i7jFAHeWHyehXgteyuNZrOD98VtGGVcHsKJMsshZYYU+E36F+h7pK8pv
         xt8+jgvmkklgTgS9L/nkzvlqiQSmfQbTtsLmSKBVQngasxiO5m81I+iEoeQtVIHnDlxS
         R3LAlc71ye/GELqHEGAkA0GPi14nbgAoG6Gq366Srg3kGWvpWSPMahE58rS1RLNvc7mX
         xUlQ==
X-Gm-Message-State: AJIora9y5QU8jfbTgCTKNkuXNm9SwZ8NzL6jASt8CZVAJOUI3CzRoSJr
        jgP2RH6oVtDyVtNRp6pJn1U=
X-Google-Smtp-Source: AGRyM1uJX2ROBrRrzyHZWwrKA5zAZpp9ic5DneX1axFsFnKMoh5p9nnUkjkVhs2j5IVMQlxjtbBK+w==
X-Received: by 2002:a17:902:db12:b0:16c:3273:c7b1 with SMTP id m18-20020a170902db1200b0016c3273c7b1mr4634380plx.172.1657742655161;
        Wed, 13 Jul 2022 13:04:15 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:cf8d:5409:1ca6:f804? ([2620:15c:211:201:cf8d:5409:1ca6:f804])
        by smtp.gmail.com with ESMTPSA id h3-20020aa79f43000000b0050dc762816asm9209154pfr.68.2022.07.13.13.04.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jul 2022 13:04:14 -0700 (PDT)
Message-ID: <98e6554a-5d88-fcb6-d46d-a267009da014@acm.org>
Date:   Wed, 13 Jul 2022 13:04:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v4 4/4] scsi: core: Call blk_mq_free_tag_set() earlier
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Li Zhijian <lizhijian@fujitsu.com>
References: <20220712221936.1199196-1-bvanassche@acm.org>
 <20220712221936.1199196-5-bvanassche@acm.org>
 <3c0f352a-0be6-7322-3556-8ce0d66ba8f3@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <3c0f352a-0be6-7322-3556-8ce0d66ba8f3@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/13/22 01:13, John Garry wrote:
> It seems to me that blk_mq_free_tag_set() is called from 
> scsi_remove_host() now, right?

Right, I will update the patch description. I moved the 
blk_mq_free_tag_set() after I wrote the patch description.

>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index 2aca0a838ca5..295c48fdb650 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -1990,7 +1990,10 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
>>   void scsi_mq_destroy_tags(struct Scsi_Host *shost)
>>   {
>> +    if (!shost->tag_set.tags)
>> +        return;
>>       blk_mq_free_tag_set(&shost->tag_set);
>> +    WARN_ON_ONCE(shost->tag_set.tags);
> 
> blk_mq_free_tag_set() clears the tagset tags pointer, so I don't know 
> why you don't trust the semantics of that API - this seems like paranoia.

Semantics of the API? Shouldn't this rather be called an undocumented 
aspect of blk_mq_free_tag_set()?

My concern is that the "set->tags = NULL" statement might be removed in 
the future from blk_mq_free_tag_set() and also that it is possible that 
scsi_mq_destroy_tags() is not updated after that change.

Thanks,

Bart.
