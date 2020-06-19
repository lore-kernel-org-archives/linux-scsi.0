Return-Path: <SRS0=E1i/=AA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43455C433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Jun 2020 21:59:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C96622243
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Jun 2020 21:59:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728762AbgFSV7e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Jun 2020 17:59:34 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42117 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728242AbgFSV7c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jun 2020 17:59:32 -0400
Received: by mail-pl1-f193.google.com with SMTP id k6so4459880pll.9;
        Fri, 19 Jun 2020 14:59:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=AV7sMf6DKdniuUMlAi+PCzyUcAZ8zYs0XbZP7OgqLvo=;
        b=EJRXZHIsW0P3yI0do5y+ISFK4xTQmy24IOFsz8Pr2L/5YZNh8lMwAf9keb3GtDmzHL
         Bzv8epY/zgnVtK7UqZMpbEyYo0d6/srGEfneSC8XqHb0n6jW/ONt85tlgmGFnyvrAe2g
         +qWsbgPqELk40tp8ab/xIaC6Zy01amTJgfQmTxek227pKyofBWP1WV6IFuEvWt28MXLB
         99jjuK8XWPFibp+4G99EtHMGm/cD/h3TPD3W1Nbb7RQjr+mkm/efs2Dqd3Moax3Oeaye
         EZ0oD5W5vfnd6hfEXQNhJpf2z7T9hQ8ONCMqTRxd+yc2lV2OvLu+F8voIt7ZfScWRMMo
         TG5A==
X-Gm-Message-State: AOAM531HHZfHRhRMUyaflb/6wqBheIZEz5OmtUR/qHqNm0OsodIrmhZV
        oA7VtC0EzJkl6WHxS3vnqwQJIZDG
X-Google-Smtp-Source: ABdhPJx4OW9HYswSIJLZOwlHOxYK4xw7Rnvfy6NUwHa5lYL4TdK49UM/lZSvhmLbfdP9bmtLYJ83gg==
X-Received: by 2002:a17:90a:d803:: with SMTP id a3mr5821475pjv.125.1592603971568;
        Fri, 19 Jun 2020 14:59:31 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id t201sm6757784pfc.104.2020.06.19.14.59.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jun 2020 14:59:30 -0700 (PDT)
Subject: Re: [PATCH 2/2] block: only return started requests from
 blk_mq_tag_to_rq()
To:     Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Keith Busch <keith.busch@wdc.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20200619140159.141905-1-hare@suse.de>
 <60e34dce-aea4-311f-22da-4cb130c5ba88@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Autocrypt: addr=bvanassche@acm.org; prefer-encrypt=mutual; keydata=
 mQENBFSOu4oBCADcRWxVUvkkvRmmwTwIjIJvZOu6wNm+dz5AF4z0FHW2KNZL3oheO3P8UZWr
 LQOrCfRcK8e/sIs2Y2D3Lg/SL7qqbMehGEYcJptu6mKkywBfoYbtBkVoJ/jQsi2H0vBiiCOy
 fmxMHIPcYxaJdXxrOG2UO4B60Y/BzE6OrPDT44w4cZA9DH5xialliWU447Bts8TJNa3lZKS1
 AvW1ZklbvJfAJJAwzDih35LxU2fcWbmhPa7EO2DCv/LM1B10GBB/oQB5kvlq4aA2PSIWkqz4
 3SI5kCPSsygD6wKnbRsvNn2mIACva6VHdm62A7xel5dJRfpQjXj2snd1F/YNoNc66UUTABEB
 AAG0JEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPokBOQQTAQIAIwUCVI67
 igIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEHFcPTXFzhAJ8QkH/1AdXblKL65M
 Y1Zk1bYKnkAb4a98LxCPm/pJBilvci6boefwlBDZ2NZuuYWYgyrehMB5H+q+Kq4P0IBbTqTa
 jTPAANn62A6jwJ0FnCn6YaM9TZQjM1F7LoDX3v+oAkaoXuq0dQ4hnxQNu792bi6QyVdZUvKc
 macVFVgfK9n04mL7RzjO3f+X4midKt/s+G+IPr4DGlrq+WH27eDbpUR3aYRk8EgbgGKvQFdD
 CEBFJi+5ZKOArmJVBSk21RHDpqyz6Vit3rjep7c1SN8s7NhVi9cjkKmMDM7KYhXkWc10lKx2
 RTkFI30rkDm4U+JpdAd2+tP3tjGf9AyGGinpzE2XY1K5AQ0EVI67igEIAKiSyd0nECrgz+H5
 PcFDGYQpGDMTl8MOPCKw/F3diXPuj2eql4xSbAdbUCJzk2ETif5s3twT2ER8cUTEVOaCEUY3
 eOiaFgQ+nGLx4BXqqGewikPJCe+UBjFnH1m2/IFn4T9jPZkV8xlkKmDUqMK5EV9n3eQLkn5g
 lco+FepTtmbkSCCjd91EfThVbNYpVQ5ZjdBCXN66CKyJDMJ85HVr5rmXG/nqriTh6cv1l1Js
 T7AFvvPjUPknS6d+BETMhTkbGzoyS+sywEsQAgA+BMCxBH4LvUmHYhpS+W6CiZ3ZMxjO8Hgc
 ++w1mLeRUvda3i4/U8wDT3SWuHcB3DWlcppECLkAEQEAAYkBHwQYAQIACQUCVI67igIbDAAK
 CRBxXD01xc4QCZ4dB/0QrnEasxjM0PGeXK5hcZMT9Eo998alUfn5XU0RQDYdwp6/kMEXMdmT
 oH0F0xB3SQ8WVSXA9rrc4EBvZruWQ+5/zjVrhhfUAx12CzL4oQ9Ro2k45daYaonKTANYG22y
 //x8dLe2Fv1By4SKGhmzwH87uXxbTJAUxiWIi1np0z3/RDnoVyfmfbbL1DY7zf2hYXLLzsJR
 mSsED/1nlJ9Oq5fALdNEPgDyPUerqHxcmIub+pF0AzJoYHK5punqpqfGmqPbjxrJLPJfHVKy
 goMj5DlBMoYqEgpbwdUYkH6QdizJJCur4icy8GUNbisFYABeoJ91pnD4IGei3MTdvINSZI5e
Message-ID: <3d073c18-50da-a4c8-2f1e-332a1e717efc@acm.org>
Date:   Fri, 19 Jun 2020 14:59:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <60e34dce-aea4-311f-22da-4cb130c5ba88@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-06-19 07:09, Hannes Reinecke wrote:
> On 6/19/20 4:01 PM, Hannes Reinecke wrote:
>> blk_mq_tag_to_rq() is used from within the driver to map a tag
>> to a request. As such it should only return requests which are
>> already started (ie passed to the driver); otherwise the driver
>> might trip over requests which it has never seen and random
>> crashes will occur.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   block/blk-mq.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>> index 4f57d27bfa73..f02d18113f9e 100644
>> --- a/block/blk-mq.c
>> +++ b/block/blk-mq.c
>> @@ -815,9 +815,13 @@ EXPORT_SYMBOL(blk_mq_delay_kick_requeue_list);
>>     struct request *blk_mq_tag_to_rq(struct blk_mq_tags *tags,
>> unsigned int tag)
>>   {
>> +    struct request *rq;
>> +
>>       if (tag < tags->nr_tags) {
>>           prefetch(tags->rqs[tag]);
>> -        return tags->rqs[tag];
>> +        rq = tags->rqs[tag];
>> +        if (blk_mq_request_started(rq))
>> +            return rq;
>>       }
>>         return NULL;
>>
> This becomes particularly obnoxious for SCSI drivers using
> scsi_host_find_tag() for cleaning up stale commands (ie drivers like
> qla4xxx, fnic, and snic).
> All other drivers use it from the completion routine, so one can expect
> a valid (and started) tag here. So for those it shouldn't matter.
> 
> But still, if there are objections I could look at fixing it within the
> SCSI stack; although that would most likely mean I'll have to implement
> the above patch as an additional function.

Hi Hannes,

Will the above patch make the fast path of every block driver slightly
slower?

Shouldn't SCSI drivers (and other block drivers) use
blk_mq_tagset_busy_iter() to clean up stale commands instead of
iterating over all tags and calling blk_mq_tag_to_rq() directly?

Thanks,

Bart.
