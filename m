Return-Path: <SRS0=b1yV=7H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A587C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 25 May 2020 14:57:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C07720899
	for <linux-scsi@archiver.kernel.org>; Mon, 25 May 2020 14:57:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404034AbgEYO47 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 May 2020 10:56:59 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39214 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404031AbgEYO46 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 May 2020 10:56:58 -0400
Received: by mail-pl1-f194.google.com with SMTP id x18so6456735pll.6;
        Mon, 25 May 2020 07:56:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=GSeJgzuS0GkUO6N4+8ogkUKTdXsBLtVqabwwiImp2S8=;
        b=oq3coC4jkhtNyyYeCTx+TNmmWoiYcNTdBGClCB3F05f0tLSu9jANtUjTaqKMFuv3vv
         4qGN94WMZpgmNNv6cDZbuRmecb7/V7j3qvVjvjDJ8SePHXFf4MBW3pdy2fD86BjmUrxU
         3ZAj4GJ2rI0UcJP93HGLxUDdt062Fb4nkTunTsnpSOkhm9BHia/FmXrvosMlgxUvV8/A
         EiFD5dCuyX1mOivDbBqSEp6JEgjtg6DpzLGhGDkg+fjSMt19E+rqfftg1t7CO8rIcck6
         HH9XYTXCOcCAgghAGrGVeU/hF2KFJtaZaOU9jkTwcyZ9NjWhun59dEreTIhR+rpYlG/r
         yXpQ==
X-Gm-Message-State: AOAM530fuqVo1VTJD8pDaIwKE2deFDtt7EqKY0GzNGojZJoVymv9RAQs
        JyNaIYAYePBpmDuoG0pTFy0=
X-Google-Smtp-Source: ABdhPJwZ/vs3v7MT7XANjdmm69IbXqeYAMZns5n/UGzbtqQHE2TqeH5PKsQe3K1u5pc0vEdzKqx4aA==
X-Received: by 2002:a17:90a:7087:: with SMTP id g7mr21975421pjk.70.1590418617729;
        Mon, 25 May 2020 07:56:57 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:2590:9462:ff8a:101f? ([2601:647:4000:d7:2590:9462:ff8a:101f])
        by smtp.gmail.com with ESMTPSA id o18sm137417pjp.4.2020.05.25.07.56.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2020 07:56:56 -0700 (PDT)
Subject: Re: Another approach of UFSHPB
To:     daejun7.park@samsung.com, yongmyung lee <ymhungry.lee@samsung.com>,
        Avri Altman <Avri.Altman@wdc.com>,
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
Message-ID: <6eec7c64-d4c1-c76e-5c14-7904a8792275@acm.org>
Date:   Mon, 25 May 2020 07:56:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <231786897.01590385382061.JavaMail.epsvc@epcpadp2>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-24 22:40, Daejun Park wrote:
> The HPB driver is close to the UFS core function, but it is not essential
> for operating UFS device. With reference to this article
> (https://lwn.net/Articles/645810/), we implemented extended UFS-feature
> as bus model. Because the HPB driver consumes the user's main memory, it should
> support bind / unbind functionality as needed. We implemented the HPB driver 
> can be unbind / unload on runtime.

I do not agree that the bus model is the best choice for freeing cache
memory if it is no longer needed. A shrinker is probably a much better
choice because the callback functions in a shrinker get invoked when a
system is under memory pressure. See also register_shrinker(),
unregister_shrinker() and struct shrinker in include/linux/shrinker.h.

>> Should these parameters be per module or per UFS device?
> 
> I think it is necessary to take parameters for each module. 
> This is because each extended UFS-feature module has different functions
> and may require different parameters.

My question was a rhetorical question. Please choose per device
parameters when appropriate instead of module parameters.

Thanks,

Bart.
