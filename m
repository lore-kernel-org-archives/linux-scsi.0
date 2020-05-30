Return-Path: <SRS0=+Wsi=7M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 220D9C433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 16:24:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09F1B207D5
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 16:24:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729173AbgE3QYY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 30 May 2020 12:24:24 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40913 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728998AbgE3QYY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 30 May 2020 12:24:24 -0400
Received: by mail-pf1-f195.google.com with SMTP id v2so1337115pfv.7;
        Sat, 30 May 2020 09:24:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=LiEAI8LkR+7XG0pM0v8PC1VVoSVEQVNXCKYCi5daAu0=;
        b=flJNXILpQtJdgZo0TPtkyqiUdDzt9ETVAQbWYPgEbtP0qmHM9nUMLnoKvdxJGZ5uDC
         Hs+k3Mfu6CXx6O7qLr3a0hu2zhBSjxGfJBOc90rA9kVL5qjE4bXdVmE93WK26Mg62bNb
         1CS6rDetqt8aoQaAUS6YgXpOVDuTMwOBaGwRK8IqNlEYuCCPuTVlqM2mlsR1BA2/c9AL
         TI0M2uHZmbtR7BP5Qb3fzbWSs8lJqmaRggNeK95tKzm59Ezt80JByzA/V3heMk11R+OV
         DQHuDMglQe+Er4/DoYbnzF94C0JHoL/2SP15dSgFru65OOpq8bSTsucVBTcZjtJd8Zfa
         PiDA==
X-Gm-Message-State: AOAM533tzYGujOVrCiZ6H0XR6V1qas3l1noSdOuPFKbv0J5PdOrvR/++
        EqAV/4J5iPPZQhQn/U3TLE/df/TKkJI=
X-Google-Smtp-Source: ABdhPJwZVUA4wpsQ8IYcgqtwJoAJ4ZJY2oz7flnnLhk2p2j77D+iI8vRncEHteOUOutpF1qwLydykw==
X-Received: by 2002:a63:480f:: with SMTP id v15mr10355568pga.148.1590855862710;
        Sat, 30 May 2020 09:24:22 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:b048:c07d:3c0c:7eb5? ([2601:647:4000:d7:b048:c07d:3c0c:7eb5])
        by smtp.gmail.com with ESMTPSA id 192sm9562567pfz.198.2020.05.30.09.24.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2020 09:24:21 -0700 (PDT)
Subject: Re: [PATCH 1/2] scsi: sr: Fix sr_probe() missing mutex_destroy
To:     Simon Arlott <simon@octiron.net>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     linux-scsi@vger.kernel.org, Merlijn Wajer <merlijn@archive.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <0cb16d6f-098a-a8c3-09c3-273d02067ada@0882a8b5-c6c3-11e9-b005-00805fc181fe>
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
Message-ID: <48ed3e8c-6aed-c7bc-6330-18f2f64f8803@acm.org>
Date:   Sat, 30 May 2020 09:24:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <0cb16d6f-098a-a8c3-09c3-273d02067ada@0882a8b5-c6c3-11e9-b005-00805fc181fe>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-30 02:32, Simon Arlott wrote:
> If the device minor cannot be allocated or the cdrom fails to be
> registered then the mutex should be destroyed.

Please add Fixes: and Cc: stable tags.

Thanks,

Bart.

