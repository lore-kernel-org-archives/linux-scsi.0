Return-Path: <SRS0=ePHC=6P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3872C4724C
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 04:59:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9923120836
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 04:59:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728118AbgEAE7b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 May 2020 00:59:31 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38268 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727922AbgEAE7a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 May 2020 00:59:30 -0400
Received: by mail-pg1-f196.google.com with SMTP id l25so1769187pgc.5
        for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2020 21:59:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=797sU4LAdXCzhMsENqTA8qVJ7grAr85MoE5SEIRXZdY=;
        b=g2we/zvdgnJov4o7XwUd7/g8hbHT8oUOZoCBHOoTOn2elxOu3KTMvqyeQZiMyjAxmj
         NC7aHVLqp1ZA8tK8vYgY0r/z1daOGAXB5OwF3mvSzOP987pjNlcquuKvHz11FRnCkp2F
         102joSwC3eewziJwXS9Nc3G7tPH9/ClkitX7WZcuJcpfYykDb/BY9u+ZitCbfvZ4WyXv
         Ck8YVKxp3WtUfXrhVozxCZMlTH0poi+RLmx0rdR2T6ifNGCwJFwkTBMdjFPUE8graCWA
         JI/ChaY+x+ZMJpEYqAbiH30WXDQf/ENJkU7MSFsE4OBOAUN0qWx0jx1l5Mm0ni6iwne0
         kWoQ==
X-Gm-Message-State: AGi0PuZ4xTajrFZLYDbVlQqMc82jjVtvT6LttrTI9q70xSPStwxP+khB
        1Z/cRXLH30+r+Nnz+NpElCW1gQ6W4Yo=
X-Google-Smtp-Source: APiQypIwIeesvr1lNKhS95dIlEnChml5V11cjedJ4KjnMk+Cx36u+jdtroFBPSrws+s3hNi6dBISiQ==
X-Received: by 2002:a63:5552:: with SMTP id f18mr2406624pgm.366.1588309169385;
        Thu, 30 Apr 2020 21:59:29 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:6909:5f45:32d1:8e51? ([2601:647:4000:d7:6909:5f45:32d1:8e51])
        by smtp.gmail.com with ESMTPSA id z1sm1052593pjn.43.2020.04.30.21.59.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 21:59:28 -0700 (PDT)
Subject: Re: [PATCH RFC v3 22/41] block: implement persistent commands
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org
References: <20200430131904.5847-1-hare@suse.de>
 <20200430131904.5847-23-hare@suse.de>
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
Message-ID: <4cd47cec-90cf-8e3b-c3f8-8dc9d4d22c80@acm.org>
Date:   Thu, 30 Apr 2020 21:59:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200430131904.5847-23-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-04-30 06:18, Hannes Reinecke wrote:
> Some LLDDs implement event handling by sending a command to the
> firmware, which then will be completed once the firmware wants
> to register an event.
     ^^^^^^^^
     report?

> So worst case a command is being sent to the firmware then the
                                                        ^^^^
                                                        when?
> driver initializes, and will be returned once the driver unloads.
> To avoid these commands to block the queues during freezing or
> quiescing this patch implements support for 'persistent' commands,
> which will be excluded from blk_queue_enter() and blk_queue_exit()
> calls.

How is it prevented that the SCSI timeout handler is activated for
persistent commands?

> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  block/blk-mq.c            | 12 +++++++++---
>  include/linux/blk-mq.h    |  2 ++
>  include/linux/blk_types.h |  4 ++++
>  3 files changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 44482aaed11e..402cf104d183 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -402,9 +402,14 @@ struct request *blk_mq_alloc_request(struct request_queue *q, unsigned int op,
>  {
>  	struct blk_mq_alloc_data alloc_data = { .flags = flags, .cmd_flags = op };
>  	struct request *rq;
> -	int ret;
> +	int ret = 0;
>  
> -	ret = blk_queue_enter(q, flags);
> +	if (flags & BLK_MQ_REQ_PERSISTENT) {
> +		if (blk_queue_dying(q))
> +			ret = -ENODEV;
> +		alloc_data.cmd_flags |= REQ_PERSISTENT;
> +	} else
> +		ret = blk_queue_enter(q, flags);
>  	if (ret)
>  		return ERR_PTR(ret);
>  

I think that not calling blk_queue_enter() for persistent commands means
opening a giant can of worms. There is quite some code in the block
layer that assumes that neither .queue_rq() nor the request completion
code will be called if q_usage_counter == 0. Skipping the
blk_queue_enter() call for persistent commands breaks that assumption. I
think we need a better solution.

Thanks,

Bart.
