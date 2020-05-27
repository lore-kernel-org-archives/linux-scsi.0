Return-Path: <SRS0=8UCH=7J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4091CC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 16:36:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 259742084C
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 16:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391274AbgE0Qgo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 May 2020 12:36:44 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:32851 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388698AbgE0Qgo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 May 2020 12:36:44 -0400
Received: by mail-pl1-f195.google.com with SMTP id t7so10315305plr.0
        for <linux-scsi@vger.kernel.org>; Wed, 27 May 2020 09:36:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=SFjkKPj3G3xuD+GLiVyr95KCM677NZcv3GqnCQbaZ4c=;
        b=inRalj8BjWYxBBTawRdsjdF8YoO3FCDk6snOilWVtJ/m+OTywGBZmP8Tff+yAxixZP
         vD0NFoX8qMRY6CQU9AdqmRT5Fzvc5Ps1P7vUodZ/kQwWZVJOHjjp5HLoXVktoWuiEhE5
         8wU+oFc2CHcqWRZHlsjhFXHDdaAy9hAko2i9GyX5naRPhKI47tDCFCRYFrlP+vQzw9+I
         PjUGI/rU3fuOqcEDEwJQFC92RjpXwJ8wFirbQJzauZBt3CjNlB+2qAnTiCBiI73YJn8c
         BsB3M+TSJRK2Joiin4CSIRsW2+6IdHmSso+cGA0/kqWSjR3EtQw2FSpRkYShrC89Gm91
         ol3g==
X-Gm-Message-State: AOAM532IQiHo7JCnVpEbDLyIzN167Juc5K8mwbIy4kiTbwdEVj1b8HGO
        T+nEqDW7Uj7Xscm50xk+PxixGgTI
X-Google-Smtp-Source: ABdhPJxGdVyEMHvmY74u7g/8kYKWagG8zH5LEydqWnialFrN0VETLmB0+oZGM8S0O4BpTK+O4hZ1oA==
X-Received: by 2002:a17:902:8b86:: with SMTP id ay6mr6513254plb.338.1590597403064;
        Wed, 27 May 2020 09:36:43 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id w19sm2475743pfq.43.2020.05.27.09.36.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2020 09:36:42 -0700 (PDT)
Subject: Re: [RFC PATCH 0/4] scsi: use xarray for devices and targets
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Doug Gilbert <dgilbert@interlog.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20200527141400.58087-1-hare@suse.de>
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
Message-ID: <f1cb4faf-816e-9f71-aa74-ddf023b197f4@acm.org>
Date:   Wed, 27 May 2020 09:36:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200527141400.58087-1-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-27 07:13, Hannes Reinecke wrote:
> Hi all,
> 
> based on the ideas from Doug Gilbert here's now my take on using
> xarrays for devices and targets.
> It revolves around two ideas:
> - 'channel' and 'id' are never ever used to the full 32 bit range;
>   'channels' are well below 10, and no driver is using more than
>   16 bits for the id. So we can reduce the type of 'channel' and
>   'id' to 16 bits, and use the 32 bit value 'channel << 16 | id'
>   as the index into the target xarray.
> - Most SCSI LUNs are below 256 (to ensure compability with older
>   systems). So there we can use the LUN number as the index into
>   the xarray; for larger LUN numbers we'll allocate a separate
>   index.
> 
> With these change we can implement an efficient lookup mechanism,
> devolving into direct lookup for most cases.
> And iteration should be as efficient as the current, list-based,
> approach.
> 
> This is compile-tested only, to give you an impression of the
> overall idea and to get the discussion rolling.

Hi Hannes,

My understanding of the xarray concept is that it provides two
advantages over using linked lists:
- Faster lookups.
- Requires less memory.

Will we benefit from any of these advantages in the SCSI code? Hadn't
James Bottomley already brought up that lookup by (channel, target, lun)
only happens from some LLDs and from the procfs code?

Are there any use cases where the number of SCSI devices is large enough
to benefit from the memory reduction?

Thanks,

Bart.
