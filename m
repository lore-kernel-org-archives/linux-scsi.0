Return-Path: <SRS0=+Wsi=7M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CB73C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 18:14:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A51A2077D
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 18:14:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729328AbgE3SO4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 30 May 2020 14:14:56 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41440 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729083AbgE3SOz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 30 May 2020 14:14:55 -0400
Received: by mail-pg1-f195.google.com with SMTP id r10so1483635pgv.8;
        Sat, 30 May 2020 11:14:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=gzHliDfG3MVqnRd0q/xurr+lCDxUtG752a1jmrrDfZg=;
        b=io/OgOZdmBvK38/tKjZf2EaC6DAf5Zf1j312RRdI5dTvBBg3Rp8AdfqOPGtWxga7E5
         pgxMgCNUDL1df7FEIZB9duabmS7ZjO3h/kF1LeDae1CnYI3LzK9RcVmhzyvtnfnbRY4r
         O1lc2ARMuRNAfnxJ2CKz280Gw7ZVDYPbchMuSgFkqFhhapKJLhmqZ+Q0/UaWEszOqxaD
         Pd/yBdm615eQwvuD1ZXf5z44oCwQzNID+MWMpJ6xgZHPfifYzJwCMzYh+Zbd3n1ulI0H
         mGL5eNg65hOfS6bow1QwlmsHWWR4sJsD/1wtOpTRLuNIvDzjDCpNKrHTMRJG/6q26mKJ
         LutQ==
X-Gm-Message-State: AOAM5331KnEfVJ7IV58auwNJGHAG8aeGx+oJQ5Zbflv7x9eIb4HDcSc1
        LOLSIZhta3nVzTD5ALvqZjaN+6bMH2w=
X-Google-Smtp-Source: ABdhPJzhVnuPuxdWJ+3eoph/oB9wc5IxfJYdJqr11VLwigTlLTUe3IRamoDM3j8JfwF8C4ioMrcByg==
X-Received: by 2002:a65:534d:: with SMTP id w13mr12729721pgr.18.1590862493564;
        Sat, 30 May 2020 11:14:53 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:b048:c07d:3c0c:7eb5? ([2601:647:4000:d7:b048:c07d:3c0c:7eb5])
        by smtp.gmail.com with ESMTPSA id y138sm10202852pfb.33.2020.05.30.11.14.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2020 11:14:52 -0700 (PDT)
Subject: Re: [PATCH 1/2] scsi: sr: Fix sr_probe() missing mutex_destroy
To:     jejb@linux.ibm.com, Simon Arlott <simon@octiron.net>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     linux-scsi@vger.kernel.org, Merlijn Wajer <merlijn@archive.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <0cb16d6f-098a-a8c3-09c3-273d02067ada@0882a8b5-c6c3-11e9-b005-00805fc181fe>
 <48ed3e8c-6aed-c7bc-6330-18f2f64f8803@acm.org>
 <1590856871.8207.6.camel@linux.ibm.com>
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
Message-ID: <1cb8fbf6-a0bf-5dd6-fd4e-744a56ea70ae@acm.org>
Date:   Sat, 30 May 2020 11:14:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1590856871.8207.6.camel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-30 09:41, James Bottomley wrote:
> On Sat, 2020-05-30 at 09:24 -0700, Bart Van Assche wrote:
>> On 2020-05-30 02:32, Simon Arlott wrote:
>>> If the device minor cannot be allocated or the cdrom fails to be
>>> registered then the mutex should be destroyed.
>>
>> Please add Fixes: and Cc: stable tags.
> 
> This isn't really a bug, is it?  mutex_destroy is a nop unless lock
> debugging is enabled in which case it checks the lock is unlocked and
> marks it as unusable to detect a use after destroy.  Since the
> structure containing the mutex is kfree'd in the next statement, kasan
> would also detect any use after free.  That's not to say we shouldn't
> do this to be fully correct ... just that it has no potential ever to
> have user visible impact so there doesn't seem to be much point
> cluttering up the stable process with it.

That makes sense to me. I may have confused Simon with my suggestion.

Bart.
