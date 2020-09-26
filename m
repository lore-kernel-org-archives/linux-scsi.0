Return-Path: <SRS0=SrIF=DD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20449C4741F
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Sep 2020 04:32:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3A4D2076D
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Sep 2020 04:32:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730036AbgIZEcr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 26 Sep 2020 00:32:47 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:45474 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729231AbgIZEcq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Sep 2020 00:32:46 -0400
Received: by mail-pg1-f182.google.com with SMTP id y14so4136439pgf.12;
        Fri, 25 Sep 2020 21:32:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=4shQRsIdT17fWbtG5QC54RWuUlCCAfeGrv+BSHQqrZY=;
        b=EdRlomje7/dffht2Jy+9aced8mz+WQG91B0AXH9kRdDVG65ZzS7bon5xaYHofj7hum
         6/5pTPMQz5LO30CRjeXo4eZZ4FW5vB53ZaA0c7vP37JiZOXxDvaNmH7DvrH90rsG0Hcw
         DuhcNd/y39IPoUpmu0iKjoQKSDaFUWYZOBhk3gPaHsAC0YDI0Fpu5NoFp+KxfZYbMY/z
         /gnL0C4unmWeoi0rSNSlfr9xi9YEe8G7sDF5Phc+8r8Ql8l1qNmEETTFvNnXbY6VO0gG
         +z+fMCQjsFBYVNrSbSec81LnSnNbagXQM0/XTPzpPtuTFbMl9ADmExmNNWH8BDrHOnxf
         sMwg==
X-Gm-Message-State: AOAM530+Jx+Q3WepyRzJVdStDc6RDhvd6thkulZbE8NGK2hiOVlo9G4U
        7JMTmD/JID4L+E/b/mPJKEQTXxanVec=
X-Google-Smtp-Source: ABdhPJy16DWvqbbX2aZ2nD9wG4dk0ksmFpiO8s8jNedWL1wGpnxeYLX0c1BN3VZS6wXl/m1nDGhVaw==
X-Received: by 2002:a63:c00d:: with SMTP id h13mr1663256pgg.358.1601094765247;
        Fri, 25 Sep 2020 21:32:45 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:8ee4:7db:d6f2:5686? ([2601:647:4000:d7:8ee4:7db:d6f2:5686])
        by smtp.gmail.com with ESMTPSA id m13sm572576pjl.45.2020.09.25.21.32.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 21:32:44 -0700 (PDT)
Subject: Re: lib/scatterlist.c : sgl_alloc_order promises more than it
 delivers
To:     dgilbert@interlog.com,
        SCSI development list <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@ORACLE.COM>,
        USB list <linux-usb@vger.kernel.org>
References: <b9f5c065-7662-30e0-8cbd-27a77d28611e@interlog.com>
 <d9513f73-fa18-4b71-fabf-be0b9e1614fd@acm.org>
 <d487005a-ef6c-549f-7006-c7056cf3f36d@interlog.com>
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
Message-ID: <da346d8f-b27e-7880-10e8-f2617e0ec7ff@acm.org>
Date:   Fri, 25 Sep 2020 21:32:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <d487005a-ef6c-549f-7006-c7056cf3f36d@interlog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-09-24 21:55, Douglas Gilbert wrote:
> My code steps down from 1024 KiB elements on failure to 512 KiB and if that
> fails it tries 256 KiB. Then it gives up. The log output is consistent with
> my analysis. So your stated equality is an inequality when length >= 4 GiB.
> There is no promotion of unsigned int nent to uint64_t .
> 
> You can write your own test harness if you don't believe me. The test machine
> doesn't need much ram. Without the call to sgl_free() corrected, if it really
> did try to get that much ram and failed toward the end, then (partially)
> freed up what it had obtained, then you would see a huge memory leak ...> 
> 
> Now your intention seems to be that a 4 GiB sgl should be valid. Correct?
> Can that check just be dropped?

Hi Doug,

When I wrote that code, I did not expect that anyone would try to allocate
4 GiB or more as a single scatterlist. Are there any use cases for which a
4 GiB scatterlist works better than two or more smaller scatterlists?

Do you agree that many hardware DMA engines do not support transferring
4 GiB or more at once?

Thanks,

Bart.
