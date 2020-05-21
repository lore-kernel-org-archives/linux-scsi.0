Return-Path: <SRS0=cxkO=7D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 923A1C433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 21 May 2020 20:58:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A16D20826
	for <linux-scsi@archiver.kernel.org>; Thu, 21 May 2020 20:58:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729756AbgEUU6e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 May 2020 16:58:34 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:39700 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728778AbgEUU6e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 May 2020 16:58:34 -0400
Received: by mail-pf1-f176.google.com with SMTP id b190so4035564pfg.6;
        Thu, 21 May 2020 13:58:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=HlyikusR5+ebS59Lh+bZL2cphTrjmdR11F4ZjNW58eY=;
        b=mz/dY8syfhzi67/G3KNfUZ6zRf9kTpNns1wj/26d/6py9oVhb7/rwCJxEhdUuWldvy
         h3arXbQPibcGT2xBz9ZuAESaPtSz1k7SNca93xyZyIH25lu77vEuVQs03Vzf1HbiTZK4
         Q/lL9ZP3GR1QyPvzWkbtzjtShdi/gP6ox2KXvDtIp298SMF5cT6tSZSlpLXNV+J+hQIx
         KNouz2butlKUgok5329PT5ydJtPY7yPmIYc++az1j+AvwOIRtzZutkiKB9YLf8KvgmdS
         alPBPQXGU11ny70l+R7IZFH+LwN16MURbOojAUJUSvlwo3E1qfPISrOa+SsqLLsBNAaQ
         KfLA==
X-Gm-Message-State: AOAM533iHDGO1HJtsgnwYmdyN5LzrCQAQlLQM6O0qwd2KTzlokOwnhTN
        NSDxTL5PtD316balpsHMaVjVQRbi
X-Google-Smtp-Source: ABdhPJycbICYK4dBV4MK/0g2Pesr6Cd+vJeOxzXRWijmiNNPOLhpEiWnd5tswi3obVOdTRIv6sQmzA==
X-Received: by 2002:a63:5225:: with SMTP id g37mr10312414pgb.230.1590094712763;
        Thu, 21 May 2020 13:58:32 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:50cc:4329:ba49:7ab1? ([2601:647:4000:d7:50cc:4329:ba49:7ab1])
        by smtp.gmail.com with ESMTPSA id 19sm5098162pjl.52.2020.05.21.13.58.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2020 13:58:32 -0700 (PDT)
Subject: Re: [PATCH] scsi: st: convert convert get_user_pages() -->
 pin_user_pages()
To:     John Hubbard <jhubbard@nvidia.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     =?UTF-8?Q?Kai_M=c3=a4kisara?= <Kai.Makisara@kolumbus.fi>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20200519045525.2446851-1-jhubbard@nvidia.com>
 <494478b6-9a8c-5271-fc9f-fd758af850c0@acm.org>
 <2fa00c72-5ffb-9bc6-df25-a87a863a6d62@nvidia.com>
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
Message-ID: <658b4aec-16fb-6969-747f-00e37bd36491@acm.org>
Date:   Thu, 21 May 2020 13:58:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <2fa00c72-5ffb-9bc6-df25-a87a863a6d62@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-21 12:57, John Hubbard wrote:
> Also, I doubt if it's worth it, but do you want a patch to change
> SetPageDirty()
> to set_page_dirty_lock(), meanwhile? It seems like if that's never come
> up, then
> it's mostly a theoretical bug.

Hi John,

Since I do not use the st driver myself I will leave it to Kai to answer
that question.

Thanks,

Bart.

