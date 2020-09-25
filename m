Return-Path: <SRS0=8X05=DC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88D2CC4363D
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 02:34:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 534B420888
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 02:34:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgIYCeM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Sep 2020 22:34:12 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42480 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgIYCeM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Sep 2020 22:34:12 -0400
Received: by mail-pf1-f194.google.com with SMTP id d6so1727205pfn.9;
        Thu, 24 Sep 2020 19:34:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=LrhMniYN89vNM15l1Ybxlbhe9ls/Xhv7pWfUsWlH+P0=;
        b=AMlILOoWaY2KNI2wnHubTHT1vu6EqE6weSL8TZr9cEV8kr2kgKn8C3hO48aKaEtIpF
         UH949xC8JSuoJggPbJ5tG50zDRJFoJGQa6ZC5HUA6u29MYc8cZSoteNH9XDUbTwrMyJn
         b93gR15zJMSO+YL4o4USvangiOEU+B7ghtTr28RTyfZ54k2hlNvJH+CREj2HYOaRE+i2
         Sd66KBzjg0HBldi0tS4HsPTc7oOi9rlHsn2Fnt13uHWEMRWEdLsr2xn/HKkpavEy9Fkn
         89yOirUecWy5eqTSVWwTG8bkkIKvjPhC5SGRB6w2d5omFMF/k5wTq3DH2Iw0Q0mqMF47
         6tNg==
X-Gm-Message-State: AOAM530HVAum7z+UzqtBlJihszj0KgY7Y3icP9Z7SVjbaVJkIlxHq0pQ
        jXKcBXim4r85+SOmfjhePUEmLyqnTuM=
X-Google-Smtp-Source: ABdhPJyoaIVJxw4gUpuZ8c8/aQO3LSBwKYrA4yPBV99yUCk19XBovEnWGmhyLNc8feEit7hjh+hljw==
X-Received: by 2002:a17:902:7484:b029:d1:dea3:a490 with SMTP id h4-20020a1709027484b02900d1dea3a490mr2115132pll.30.1601001250960;
        Thu, 24 Sep 2020 19:34:10 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:755a:78b:43e0:7557? ([2601:647:4000:d7:755a:78b:43e0:7557])
        by smtp.gmail.com with ESMTPSA id 1sm590573pgm.4.2020.09.24.19.34.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2020 19:34:10 -0700 (PDT)
Subject: Re: lib/scatterlist.c : sgl_alloc_order promises more than it
 delivers
To:     dgilbert@interlog.com,
        SCSI development list <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@ORACLE.COM>,
        USB list <linux-usb@vger.kernel.org>
References: <b9f5c065-7662-30e0-8cbd-27a77d28611e@interlog.com>
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
Message-ID: <d9513f73-fa18-4b71-fabf-be0b9e1614fd@acm.org>
Date:   Thu, 24 Sep 2020 19:34:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <b9f5c065-7662-30e0-8cbd-27a77d28611e@interlog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-09-24 18:46, Douglas Gilbert wrote:
>         /* Check for integer overflow */
>         if (length > (nent << (PAGE_SHIFT + order)))
>                 return NULL;
> 
> Well _integers_ don't wrap, but that pedantic point aside, 'nent' is an
> unsigned int which means the rhs expression cannot represent 2^32 or
> higher. So if length >= 2^32 the function fails (i.e. returns NULL).
> 
> On 8 GiB and 16 GiB machines I can easily build 6 or 12 GiB sgl_s (with
> scsi_debug) but only if no single allocation is >= 4 GiB due to the
> above check.
> 
> So is the above check intended to do that or is it a bug?

The above check verifies that nent << (PAGE_SHIFT + order) ==
(uint64_t)nent << (PAGE_SHIFT + order). So I think it does what the
comment says it does.

Bart.
