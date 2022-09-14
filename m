Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B11EECAAD3
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Sep 2022 16:52:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiINQwL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Sep 2022 12:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiINQwK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Sep 2022 12:52:10 -0400
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E79480015
        for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2022 09:52:09 -0700 (PDT)
Received: by mail-pj1-f44.google.com with SMTP id s14-20020a17090a6e4e00b0020057c70943so19656712pjm.1
        for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2022 09:52:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=P2tQKuknDHje5Am5RrL89R1gGLwZppiV62rL4xH3pjQ=;
        b=XRWD3d0y/Kuc2LmBDj8RuSE+0Y6SJ6zSKiSZ5Ad+ajbwS/z/3uJu3l9ORUYL+G4UJA
         8+aOBy5uFelSIYTq0GEWMvOsj/OF4umHrlUhwZg9F3a8qUITzs7vCaLTjx7ucJNJYAkN
         FlOkPjN3rGXilnx/KouYvCh+y3a3RfJoR6U7nmCz7R4vcTQ5nkTz3yL7EKXKasighgYM
         oxRsetdUdeUhNlaw/Es5iW+jV6THsd20GDBDOBHkhI79OwsElxdnKGlxNLtBanZKgtXE
         tiegn8Xm/8vwyMwPgbeRwB/4j8FNdnnUfDIxlCvtDkyO/xzoEnnYmVb+d3nsTuecTHjM
         zYUQ==
X-Gm-Message-State: ACrzQf3oWmiuwu815m8PrG/HxX4Pwp4mJ73kz9JnFfU3PsoPJiVjW3cD
        mY9Rl90WAuNbHBhuXGGEwhE=
X-Google-Smtp-Source: AMsMyM66xrYF0uNrrDOyMQHKF5WCy1uzqst7EYPP3QF0paW82Cms7NuJRbDtSQqdCVXW3UccYJk8Kw==
X-Received: by 2002:a17:90b:4d8c:b0:200:7cd8:333e with SMTP id oj12-20020a17090b4d8c00b002007cd8333emr5718542pjb.95.1663174328864;
        Wed, 14 Sep 2022 09:52:08 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:44a3:d997:5eda:cf2b? ([2620:15c:211:201:44a3:d997:5eda:cf2b])
        by smtp.gmail.com with ESMTPSA id w187-20020a6282c4000000b0053e156e9475sm10286593pfd.182.2022.09.14.09.52.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Sep 2022 09:52:08 -0700 (PDT)
Message-ID: <e2a6451e-db2d-8e9b-befb-c04d6028fffe@acm.org>
Date:   Wed, 14 Sep 2022 09:52:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v4 3/4] scsi: core: Introduce a new list for SCSI proc
 directory entries
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220913195716.3966875-1-bvanassche@acm.org>
 <20220913195716.3966875-4-bvanassche@acm.org>
 <33c751b4-9c6d-ac2c-d394-86ae0de3af0d@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <33c751b4-9c6d-ac2c-d394-86ae0de3af0d@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/14/22 02:43, John Garry wrote:
> On 13/09/2022 20:57, Bart Van Assche wrote:
>> +void scsi_proc_hostdir_add(const struct scsi_host_template *sht)
>>   {
>> +    struct scsi_proc_entry *e;
>> +
>>       if (!sht->show_info)
>>           return;
>>       mutex_lock(&global_host_template_mutex);
>> -    if (!sht->present++) {
>> -        sht->proc_dir = proc_mkdir(sht->proc_name, proc_scsi);
>> -            if (!sht->proc_dir)
>> -            printk(KERN_ERR "%s: proc_mkdir failed for %s\n",
>> -                   __func__, sht->proc_name);
>> +    e = __scsi_lookup_proc_entry(sht);
>> +    if (!e) {
>> +        e = kzalloc(sizeof(*e), GFP_KERNEL);
> 
> So this following scenario is safe, right?
> 
> 1. host0 calls scsi_proc_hostdir_add() but alloc here fails
> 2. host1 calls scsi_proc_hostdir_add() but alloc passes, so e->present = 1
> 3. host0 calls scsi_proc_hostdir_rm(), so e->present goes to zero and we 
> dealloc the scsi_proc_entry
> 4. host1 calls scsi_proc_hostdir_rm(), but does not find the 
> scsi_proc_entry and returns
> 
> I suppose the only problem is that we try to free the procfs dir but 
> host1 still has a procfs entry after 3
> 
> I just wonder why we can't make scsi_alloc_alloc() -> 
> scsi_proc_hostdir_add() error, i.e. return an error code in this 
> function - it would seem to make things simpler

That sounds like a good idea to me. I will look into this.

>> +    e->proc_dir = proc_mkdir(sht->proc_name, proc_scsi);
>> +    if (!e->proc_dir) {
>> +        printk(KERN_ERR "%s: proc_mkdir failed for %s\n", __func__,
>> +               sht->proc_name);
>> +        e->present--;
> 
> I don't see why we decrement e->present and then free e

I will remove the code that decrements e->present again.

Thanks,

Bart.

