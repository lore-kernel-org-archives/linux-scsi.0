Return-Path: <SRS0=HoCN=7I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64463C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 17:04:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FB0C20823
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 17:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728561AbgEZREE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 May 2020 13:04:04 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37676 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbgEZREE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2020 13:04:04 -0400
Received: by mail-pl1-f196.google.com with SMTP id x10so8917858plr.4;
        Tue, 26 May 2020 10:04:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Wlo4YYZRgFxx8YY2behXUUIIdun8rPBWQgGdvg5rdjQ=;
        b=PpZ+CnBqwU+bcLvPxIHBzd9wOOAt6JKT6646D1M8YdfghUa46YXuP/jTALPYw05ldX
         OybCnu8LOjIqLHWXAcEqZxeWXnnHiGpyM5NCv9LXXW61S5f83+WMo1dKqrjFV2w308Mz
         5YSMLMc0XF3qr3lZePKQ6J9TrcRhzKmV8hdIOThMZM64nBJmyhrfJkR2QzXp5qicy13O
         nUK+B923NEEE4jcG8L14TQcNgQWLwDHTCFcpl8bWg5UsnSFehQUaJlMFxp8oDfpnsag3
         NzWtlwKzLfZGpS0fDqYAmbstHfp4ZPbD5c3ZniDTleb28K/umiNd8+WtmWd0KdPeHrnr
         9s3g==
X-Gm-Message-State: AOAM5335RmO232Iw1lvnwV7vsSSM5p4NwZvqMeQH27j8tFkJkcZZoJ2S
        OyM6umcT0cNoev7udk6k8h8=
X-Google-Smtp-Source: ABdhPJyOSOhqC9a2daL8vGXqvaSTXPUAR8rqvSnxCfcaqDbhQ92llj4+dJ/MTg7PmzoW0mltmneccA==
X-Received: by 2002:a17:90a:f493:: with SMTP id bx19mr189496pjb.45.1590512643516;
        Tue, 26 May 2020 10:04:03 -0700 (PDT)
Received: from [192.168.2.10] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id h4sm51270pje.29.2020.05.26.10.04.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 10:04:02 -0700 (PDT)
Subject: Re: Another approach of UFSHPB
To:     Avri Altman <Avri.Altman@wdc.com>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     ALIM AKHTAR <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        MOHAMMED RAFIQ KAMAL BASHA <md.rafiq@samsung.com>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>
References: <aaf130c2-27bd-977b-55df-e97859f4c097@acm.org>
 <835c57b9-f792-2460-c3cc-667031969d63@acm.org>
 <1589538614-24048-1-git-send-email-avri.altman@wdc.com>
 <d10b27f1-49ec-d092-b252-2bb8cdc4c66e@acm.org>
 <SN6PR04MB46408050B71E3A6225D6C495FCBA0@SN6PR04MB4640.namprd04.prod.outlook.com>
 <231786897.01589928601376.JavaMail.epsvc@epcpadp1>
 <CGME20200516171420epcas2p108c570904c5117c3654d71e0a2842faa@epcms2p4>
 <231786897.01590385382061.JavaMail.epsvc@epcpadp2>
 <6eec7c64-d4c1-c76e-5c14-7904a8792275@acm.org>
 <SN6PR04MB46400AED930A3DC5B94AED25FCB00@SN6PR04MB4640.namprd04.prod.outlook.com>
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
Message-ID: <fd8c4336-8528-19d9-b1fe-1f74baf6b483@acm.org>
Date:   Tue, 26 May 2020 10:03:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <SN6PR04MB46400AED930A3DC5B94AED25FCB00@SN6PR04MB4640.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-25 23:15, Avri Altman wrote:
>> On 2020-05-24 22:40, Daejun Park wrote:
>>> The HPB driver is close to the UFS core function, but it is not essential
>>> for operating UFS device. With reference to this article
>>> (https://lwn.net/Articles/645810/), we implemented extended UFS-feature
>>> as bus model. Because the HPB driver consumes the user's main memory, it
>> should
>>> support bind / unbind functionality as needed. We implemented the HPB
>> driver
>>> can be unbind / unload on runtime.
>>
>> I do not agree that the bus model is the best choice for freeing cache
>> memory if it is no longer needed. A shrinker is probably a much better
>> choice because the callback functions in a shrinker get invoked when a
>> system is under memory pressure. See also register_shrinker(),
>> unregister_shrinker() and struct shrinker in include/linux/shrinker.h.
>
> Since this discussion is closely related to cache allocation,
> What is your opinion about allocating the pages dynamically as the regions
> Are being activated/deactivated, in oppose of how it is done today - 
> Statically on init for the entire max-active-subregions?

Memory that is statically allocated cannot be used for any other purpose
(e.g. page cache) without triggering the associated shrinker. As far as
I know shrinkers are only triggered when (close to) out of memory. So
dynamically allocating memory as needed is probably a better strategy
than statically allocating the entire region at initialization time.

Thanks,

Bart.



