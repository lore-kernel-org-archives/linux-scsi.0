Return-Path: <SRS0=bO3J=AJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4237C433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 03:43:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4446208B6
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 03:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbgF1DnK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Jun 2020 23:43:10 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:53871 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbgF1DnK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Jun 2020 23:43:10 -0400
Received: by mail-pj1-f67.google.com with SMTP id q90so5809310pjh.3
        for <linux-scsi@vger.kernel.org>; Sat, 27 Jun 2020 20:43:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=FxeCuAPwFb8cn4KIKL59s1IFlb/8XDwopTQWRt/j3gc=;
        b=K4W3JkqHC4mEAnLPX9FLaqYfsO1q1cLh0LjEyXtJP1q6BkKRy7nXx6MYd8OO6679z2
         C7akJ/91PUdaLZfkyrCb3/TFvSPKt6/FvYwGzT4IcBiSDAQxibctZ0pFjovVSmTRHN9e
         Y2tt2rYS69I459fG4qI1mkzDHfezojpGMbIJtPyZSby3/ggv1bzSrQJnP/5uVgXj8m1H
         nmpYW474gtLEOPauApinaG2FfEXRbKFNPa6NogufO9EvnoAVWnJ5R8jGHZOOZPMjAhrB
         8UqGuuCZK3UfKG5a3N+cvsbmG3C9pAONnklXrMdXg67JyOa2in/HQK7XrXynSqwUO2A6
         2kEg==
X-Gm-Message-State: AOAM5326sskYwdb4z6ZpUSSGk8U1Lsvr9eFLj3QRNC23vpLZbk0gGxCu
        WmHmA+z4IuyHBtYUfnuW31lRhnjK
X-Google-Smtp-Source: ABdhPJzE4WpGi1Zztb3M1HsKf0h5VcQrtQq92LfILRIkyYIbJO40py8EuP+dNIMlOIFjCFp9gNrlaA==
X-Received: by 2002:a17:902:9301:: with SMTP id bc1mr8255495plb.116.1593315788745;
        Sat, 27 Jun 2020 20:43:08 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id n7sm15057833pjq.22.2020.06.27.20.43.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Jun 2020 20:43:08 -0700 (PDT)
Subject: Re: [PATCH 02/22] block: add flag for internal commands
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Don Brace <don.brace@microchip.de>, linux-scsi@vger.kernel.org
References: <20200625140124.17201-1-hare@suse.de>
 <20200625140124.17201-3-hare@suse.de>
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
Message-ID: <3576e7ea-02d3-fc48-a66b-4dcc1bf6a8c2@acm.org>
Date:   Sat, 27 Jun 2020 20:43:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200625140124.17201-3-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-06-25 07:01, Hannes Reinecke wrote:
> diff --git a/block/blk-exec.c b/block/blk-exec.c
> index 85324d53d072..86e8968cfa90 100644
> --- a/block/blk-exec.c
> +++ b/block/blk-exec.c
> @@ -55,6 +55,11 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
>  	rq->rq_disk = bd_disk;
>  	rq->end_io = done;
>  
> +	if (WARN_ON(blk_rq_is_internal(rq))) {
> +		blk_mq_end_request(rq, BLK_STS_NOTSUPP);
> +		return;
> +	}
> +
>  	blk_account_io_start(rq);

Isn't it recommended to use WARN_ON_ONCE() instead of WARN_ON()?

>  #define REQ_DRV			(1ULL << __REQ_DRV)
>  #define REQ_SWAP		(1ULL << __REQ_SWAP)
> +#define REQ_INTERNAL		(1ULL << __REQ_INTERNAL)

How about introducing a __bitwise type for the REQ_ flags such that
sparse can check whether the proper type of flags has been passed to a
function?

Thanks,

Bart.
