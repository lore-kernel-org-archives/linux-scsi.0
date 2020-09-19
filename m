Return-Path: <SRS0=lXoO=C4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEA02C43466
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Sep 2020 03:45:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87E9E21D7B
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Sep 2020 03:45:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgISDpX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Sep 2020 23:45:23 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34122 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbgISDpX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Sep 2020 23:45:23 -0400
Received: by mail-pf1-f196.google.com with SMTP id k13so4197259pfg.1;
        Fri, 18 Sep 2020 20:45:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=idFK1gOYdtlPbYjnB19NSuMsZWXRNo6UfeEQDq3TUSI=;
        b=qmB0le58+Dw/EmG5y2dUNXVWfCUhXwywYE8GvOyp2D3ALVdAQVdeDCPTlR4d+pLBnM
         Nz+soow0+k3zFtFb94JI0lKYcR0nvBayosFQaju4Ej/4qSMd4jIRWIH8u/X8E8YPyNsL
         aAcV/J00wNLspfgVrBeKCHWS3ZnOKdJiu4L/cRinLiay8yuy69H04j06uQBg0hwFGAph
         uKMHPLwTY4HCTvDUPwCGMFLd8AFHFJu9t5Hetyz5KBySLDSIBPOFvWKUnDw5Hk9WMa31
         c6jqmzY9U5WWMrd6zRAW5oC6tOQptS4Nyl15e1YPUJdQVlQeKjArgaejswLTyA3dMPAr
         Omrw==
X-Gm-Message-State: AOAM530kmkrLTfAuqTNChmLVaLsPOr9EW3HapGYBQApMT0QvTsx7HUoV
        IM2uEkccVciQgrxaP6Fw87E=
X-Google-Smtp-Source: ABdhPJztBMRkPJN08Lkecif36xf9Ai8ciWriJG/1Swt773umCFjTWghBZBqwdd2pNz+cqXcYI3znLA==
X-Received: by 2002:a63:160b:: with SMTP id w11mr2448026pgl.110.1600487122494;
        Fri, 18 Sep 2020 20:45:22 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:1972:99fe:2141:2194? ([2601:647:4000:d7:1972:99fe:2141:2194])
        by smtp.gmail.com with ESMTPSA id e13sm3978025pjy.38.2020.09.18.20.45.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2020 20:45:21 -0700 (PDT)
Subject: Re: [PATCH 0/9] Rework runtime suspend and SCSI domain validation
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
References: <20200906012219.17893-1-bvanassche@acm.org>
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
Message-ID: <f4ff6be8-84b6-6f08-8657-21238c99df9c@acm.org>
Date:   Fri, 18 Sep 2020 20:45:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200906012219.17893-1-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-09-05 18:22, Bart Van Assche wrote:
> The SCSI runtime suspend and domain validation mechanisms both use
> scsi_device_quiesce(). scsi_device_quiesce() restricts blk_queue_enter() to
> BLK_MQ_REQ_PREEMPT requests. There is a conflict between the requirements
> of runtime suspend and SCSI domain validation: no requests must be sent to
> runtime suspended devices that are in the state RPM_SUSPENDED while
> BLK_MQ_REQ_PREEMPT requests must be processed during SCSI domain
> validation. This conflict is resolved by reworking the SCSI domain
> validation implementation.
> 
> Hybernation and runtime suspend have been retested but SCSI domain
> validation not yet.

Hi Martin and James,

Please advise how to proceed with this patch series. This patch series
includes an important fix for runtime power management. Unfortunately
the only way to fix runtime powermanagement is by reworking SPI DV and
I don't have access to a setup on which I can test the SPI DV changes.

Thanks,

Bart.
