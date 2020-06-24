Return-Path: <SRS0=oFF2=AF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F703C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 02:53:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F37D920874
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 02:53:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388259AbgFXCx0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Jun 2020 22:53:26 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35161 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387985AbgFXCx0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jun 2020 22:53:26 -0400
Received: by mail-pg1-f194.google.com with SMTP id f3so656019pgr.2
        for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2020 19:53:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j7mAGTKtZk8rL1cAIBlxW4qFX3VWHVXb0CUMaqocpfQ=;
        b=eun76z9xnlUc+Xqsdg6oJIBakWnIFpN7Nf79uLZEbFzyNGtpC8X+fwmt5LtDenDDVP
         lfT7HTrwjyw7Dm8QQwMEZZIp/vOSg/uWVF2hXyjNwdYaSaSNK079QHUS/V3LM2V32x5F
         9yqBkBVwtOVGRxZhMmc3RK4fK1H12LHPS593Wr+nqTwvYGEwv+S2xiAfPXVz3vWrHWdS
         0Dh8htHBrl+sIZWEE0oRa95NF1msoGIdIoxyMKivn5GzU0o9rGt5ROiFZZHKFCMkr9Ac
         9NEcmGnsggKKG2w7ehK55cBaGJitDcGYvzyzX6JB6alekXk+viQEaQYUKfN/jcYM7OVt
         tsQw==
X-Gm-Message-State: AOAM532BT3KK7L19hRWsHADCzRX1Jb9JpkLQr7f+rwzN/SG2+ouXpflr
        fkEKvkWZywsagVcmAxg7894=
X-Google-Smtp-Source: ABdhPJw+Tx8gth06SEtOtVrn8nH1AOsEOF/amKBvP+iBgUyyR7sBgUZb5C7CAqEL1Akgv0K2IoWuAw==
X-Received: by 2002:aa7:8a51:: with SMTP id n17mr5232730pfa.89.1592967204165;
        Tue, 23 Jun 2020 19:53:24 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id q92sm3617455pjh.12.2020.06.23.19.53.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2020 19:53:23 -0700 (PDT)
Subject: Re: [RFC PATCH v1 1/2] ufs: introduce callbacks to get command
 information
To:     Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org,
        'Christoph Hellwig' <hch@lst.de>
References: <CGME20200620070044epcas2p269e3c266c86c65dd0e894d8188036a30@epcas2p2.samsung.com>
 <1592635992-35619-1-git-send-email-kwmad.kim@samsung.com>
 <992d1812-98b9-99b5-acc0-69c7aba3d074@acm.org>
 <003201d64905$ee05a5e0$ca10f1a0$@samsung.com>
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
Message-ID: <111d5f71-1992-5600-23e4-bbfd53c8a615@acm.org>
Date:   Tue, 23 Jun 2020 19:53:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <003201d64905$ee05a5e0$ca10f1a0$@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-06-22 19:28, Kiwoong Kim wrote:
> If you could get the information, Many would exploit it for their respective purposes.
> But, it's important for the information to contain accurate timestamps when the driver
> hooks it, if you're trying to figure out something wrong.
> 
> As for scaling DVFS knobs to boost UFS throughput, locating in the ufs driver is more
> Beneficial because SoC vendors have their own power domains and thus lead to make
> different way of what to scale up to boost. If it's populated in block layer, there is
> no way to introduce boosting per SoC.

Thanks for the clarification. Unfortunately we do not yet have an API
for sharing information between I/O schedulers and block drivers ...

Bart.


