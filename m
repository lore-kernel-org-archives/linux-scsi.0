Return-Path: <SRS0=2LRe=DO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 596A6C4363C
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:28:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16046208C3
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:28:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgJGD2g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Oct 2020 23:28:36 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:45883 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbgJGD2g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Oct 2020 23:28:36 -0400
Received: by mail-pl1-f177.google.com with SMTP id y20so282684pll.12
        for <linux-scsi@vger.kernel.org>; Tue, 06 Oct 2020 20:28:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=2S+wo6Rrp0qHHhGJekSbD3NV9PEzyNZ+GZuEqYrkexU=;
        b=tLnuGrkZLEXJlrU3OYOaw3IoEwyAjhspdQ2m/l0Q6FFWqEQcP+nRfQwmm+QlUbk/44
         qntAsgb7WcOmvok8PiLmNNqrwj5uQrouT1/uE33XPfODzZSfT5dN4R2BztWXBeIAstEP
         wTmT/c5oY3n6L/lrxCUVeAGCFmEBuKTQheTXHj3zT2qxDxUgXkF2VikTWJ0UpQ5be6sd
         LFJw54Kn6XozLwIftEvJ1CL7EzplzihS+UU/1gwW73CvHrBxcKIpDpuKnZNjJ/PQ7AeV
         4FLgGNeWmUPLC/3rM09UFZVoSVDx2EbBddw4AUTfdbNUJiW+oENn4qC6TbUj6+m+BflC
         ETcA==
X-Gm-Message-State: AOAM531EwOJz6h6rxsHBWgylgSDZ1Drys8oC+g07KqYXYu/zAQwQKLoF
        Po2rBHL5pgpcJNSFKC1fbxQ=
X-Google-Smtp-Source: ABdhPJy5QHtAtAvFhMI42iAeKvsfNPtVivYojI/FHq8znzMjo62KhgMh7AMNTS7YQAbNlokdodI4GA==
X-Received: by 2002:a17:902:ee8b:b029:d3:f156:eefc with SMTP id a11-20020a170902ee8bb02900d3f156eefcmr991320pld.19.1602041315490;
        Tue, 06 Oct 2020 20:28:35 -0700 (PDT)
Received: from [192.168.3.218] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id c10sm733356pfc.196.2020.10.06.20.28.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Oct 2020 20:28:34 -0700 (PDT)
Subject: Re: [PATCH V2 0/4] pm80xx updates.
To:     dgilbert@interlog.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Viswas G <Viswas.G@microchip.com.com>
Cc:     linux-scsi@vger.kernel.org,
        Vasanthalakshmi.Tharmarajan@microchip.com, Viswas.G@microchip.com,
        Ruksar.devadi@microchip.com,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>
References: <20201005145011.23674-1-Viswas.G@microchip.com.com>
 <yq1r1qa7pw7.fsf@ca-mkp.ca.oracle.com>
 <81c98e02-75cf-5f9d-612f-a67a374811c3@interlog.com>
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
Message-ID: <012cd628-6bd3-e4f4-b494-51a9779a3c2c@acm.org>
Date:   Tue, 6 Oct 2020 20:28:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <81c98e02-75cf-5f9d-612f-a67a374811c3@interlog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-10-06 20:03, Douglas Gilbert wrote:
> Is the "imperative mood" something in Danish or German grammar?

Have you already encountered this?
https://en.wikipedia.org/wiki/Imperative_mood#English

Thanks,

Bart.
