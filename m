Return-Path: <SRS0=BOnk=6Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 183A0C3A5A9
	for <linux-scsi@archiver.kernel.org>; Sat,  2 May 2020 16:22:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F10A021974
	for <linux-scsi@archiver.kernel.org>; Sat,  2 May 2020 16:22:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbgEBQWh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 May 2020 12:22:37 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41225 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728325AbgEBQWh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 May 2020 12:22:37 -0400
Received: by mail-pf1-f195.google.com with SMTP id 18so3144046pfv.8
        for <linux-scsi@vger.kernel.org>; Sat, 02 May 2020 09:22:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=owczh4rvPkt6YuMsXofkll5vS9JUcQTvJ6bXF+wEGk0=;
        b=Cbqbr4OTDLlQDUdaZ8nb5RZl99CzRZfqJIIg1mtoM6mxOADFeN7IQ3Get38BA1F9rG
         x0nS4E57maNH00FuQSTY395M1NUZUnSDjHb0HMQzzFPJ2paEpH37U+YGeROHa+OBpUyv
         UhV/vRRLnEUafrB9+UWKftUgV4t/SZBezln1e4aQoCXN38qdQ2kaAnanOJnsHf4NmSQS
         Bwjawz8MIJgO6YfGF9OvbiKdcNrSKgh1QN8MqiOMTH4CuoSetTwBJGsl/lv5/5ldOITc
         VWUf4BmqXuCK9L9R1C3dEde/jNMzvpHEteCIwrTlZZ3L5dao0BMQXif9on76cl0/ytPS
         bzFA==
X-Gm-Message-State: AGi0PuZk4J6RcFJvyvOIIRviSjpovGQd8Wra2ag0TJAkAKlmWyomoWan
        djrd0oELiCELXwNtZy0IZb6rkuOwE7LXLw==
X-Google-Smtp-Source: APiQypK4licLHwrarJotTrcEFhdtIKvTpoSl6x74x4NUQRhPAvgdskDp+3pfWRZFaxynnQbOMwdWIQ==
X-Received: by 2002:a63:1a16:: with SMTP id a22mr9612903pga.264.1588436555379;
        Sat, 02 May 2020 09:22:35 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:f841:776c:f563:db5c? ([2601:647:4000:d7:f841:776c:f563:db5c])
        by smtp.gmail.com with ESMTPSA id z185sm872482pgz.26.2020.05.02.09.22.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 May 2020 09:22:34 -0700 (PDT)
Subject: Re: [PATCH RFC v3 22/41] block: implement persistent commands
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org
References: <20200430131904.5847-1-hare@suse.de>
 <20200430131904.5847-23-hare@suse.de>
 <4cd47cec-90cf-8e3b-c3f8-8dc9d4d22c80@acm.org>
 <c65981a3-68b9-e7f5-ea10-efe57bbb3dfc@suse.de>
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
Message-ID: <8b979bbf-54bf-da09-fc96-00367f805a95@acm.org>
Date:   Sat, 2 May 2020 09:22:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <c65981a3-68b9-e7f5-ea10-efe57bbb3dfc@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-02 05:11, Hannes Reinecke wrote:
> On 5/1/20 6:59 AM, Bart Van Assche wrote:
>> On 2020-04-30 06:18, Hannes Reinecke wrote:
>>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>>> index 44482aaed11e..402cf104d183 100644
>>> --- a/block/blk-mq.c
>>> +++ b/block/blk-mq.c
>>> @@ -402,9 +402,14 @@ struct request *blk_mq_alloc_request(struct
>>> request_queue *q, unsigned int op,
>>>   {
>>>       struct blk_mq_alloc_data alloc_data = { .flags = flags,
>>> .cmd_flags = op };
>>>       struct request *rq;
>>> -    int ret;
>>> +    int ret = 0;
>>>   -    ret = blk_queue_enter(q, flags);
>>> +    if (flags & BLK_MQ_REQ_PERSISTENT) {
>>> +        if (blk_queue_dying(q))
>>> +            ret = -ENODEV;
>>> +        alloc_data.cmd_flags |= REQ_PERSISTENT;
>>> +    } else
>>> +        ret = blk_queue_enter(q, flags);
>>>       if (ret)
>>>           return ERR_PTR(ret);
>>>   
>>
>> I think that not calling blk_queue_enter() for persistent commands means
>> opening a giant can of worms. There is quite some code in the block
>> layer that assumes that neither .queue_rq() nor the request completion
>> code will be called if q_usage_counter == 0. Skipping the
>> blk_queue_enter() call for persistent commands breaks that assumption. I
>> think we need a better solution.
>>
> Well, yeah, maybe.
> My aim here is that _all_ I/O requiring a tag from the hardware will be
> tracked by the blocklayer tagset. Only that will give the block-layer
> accurate information about outstanding commands, such that the ongoing
> CPU hotplug discussion can make the correct decisions and implement
> functions really covering all outstanding I/O.
> It also allows us to use the scsi_host_busy_iter() functions within the
> driver, and will get rid of the hand-crafted iterations the driver has
> to do now.
> 
> It worked reasonably well, until I encountered the infamous AEN
> commands, which actually require the opposite: _not_ to be tracked by
> the block layer at all, as the commands themselves are just placeholders
> to be returned by the firmware once an event occurs.
> (And yes, I _do_ think this is a quite dangerous operation, because I
> can't quite see how one could reliably return this command in case of a
> firmware crash ...)
> (But anyhow, that's how the firmware is written and we have to live with
> it.)
> 
> So I implemented this approach, to have tags which are ignored by the
> block layer. But I have to admit that this approach relies on quite some
> assumptions (like these tags are never actually submitted to the
> blocklayer itself, are never started etc), none of which are spelled out
> clearly (yet).
> An alternative approach would be to arbitrary decrease the tagset size
> by one (eg by shifting the tags by one), and use the free tag for AENs).
> That would have to be coded within the driver, though.
> 
> If that's a solution which you like better I could give it a go.

How about dropping support for AEN commands entirely? As far as I know
such a command has never been standardized. Additionally, all SCSI core
code I'm familiar with supports unit attentions and does not rely on
asynchronous events to be reported immediately.

If dropping support for AEN commands is not an option, how about
aborting these commands before freezing a request queue?

Thanks,

Bart.
