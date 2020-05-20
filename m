Return-Path: <SRS0=Yj8A=7C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66473C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 21:20:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C72620823
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 21:20:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728148AbgETVUC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 May 2020 17:20:02 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43318 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727083AbgETVUC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 May 2020 17:20:02 -0400
Received: by mail-pl1-f195.google.com with SMTP id k22so1864936pls.10;
        Wed, 20 May 2020 14:20:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=y1v1713nXqKb0mxXeMZ0dgr7QWzgxODsG/gXBN3Zu1w=;
        b=U3jjxk19NY2QmIT5YJfOd3YG70EbpS0kPXFacjOQP+0tzT/GACpRJ3BMkydGlQK4L0
         bUXYqqOHS7WRap3JBWRhjHxlKdkGpcAKgEOg1ba/qEJNE93ogW4iANxc2EUFfNxCC9PM
         reTm4bZGlmeL+QQVenpZsYi04ABryo2+0YWbTUxwOTDccHaVpPuIDB5nUrU4CuROmvGD
         uBFbDJk6oexbpSuJrOAWlw9iH+JdXvzhNfhf4YVr4BzgGuHUX3HmcZXcU5Z7k3387Z7v
         lOiMmKZ/bgJ6TQuhKfd5yhEQUzw4RL1EMIqPGiu1eT2oyCD5T6yuJfDwxhWuadj638CQ
         xHwg==
X-Gm-Message-State: AOAM532ZCZnshxpmsPL6rHsg9snCkwQa8HNXfoEOXHrSeD1ihCDVxSaJ
        sVjWN4vFYpV3GOi2GGMiNy4=
X-Google-Smtp-Source: ABdhPJzsTi5dHdAljD2Af9tu7m+Hchp/cP7wHZA4vPNursV5rq+vV6uAs1HaY/yk/uNQQoSqHaePgg==
X-Received: by 2002:a17:90a:f313:: with SMTP id ca19mr7042583pjb.7.1590009601132;
        Wed, 20 May 2020 14:20:01 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:c031:e55:f9a8:4282? ([2601:647:4000:d7:c031:e55:f9a8:4282])
        by smtp.gmail.com with ESMTPSA id i21sm2560415pgn.20.2020.05.20.14.19.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2020 14:20:00 -0700 (PDT)
Subject: Re: Another approach of UFSHPB
To:     Christoph Hellwig <hch@infradead.org>,
        yongmyung lee <ymhungry.lee@samsung.com>
Cc:     Avri Altman <Avri.Altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
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
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>
References: <835c57b9-f792-2460-c3cc-667031969d63@acm.org>
 <1589538614-24048-1-git-send-email-avri.altman@wdc.com>
 <d10b27f1-49ec-d092-b252-2bb8cdc4c66e@acm.org>
 <SN6PR04MB46408050B71E3A6225D6C495FCBA0@SN6PR04MB4640.namprd04.prod.outlook.com>
 <CGME20200516171420epcas2p108c570904c5117c3654d71e0a2842faa@epcms2p7>
 <231786897.01589928601376.JavaMail.epsvc@epcpadp1>
 <20200520175555.GA27975@infradead.org>
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
Message-ID: <e1e81ad1-2681-9dbe-34aa-85f4e5559927@acm.org>
Date:   Wed, 20 May 2020 14:19:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200520175555.GA27975@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-20 10:55, Christoph Hellwig wrote:
> HPB is a completely fucked up concept and we shoud not merge it at all.
> Especially not with a crazy bullshit vendor extension layer that makes
> it even easier for vendors to implement even worse things than the
> already horrible spec says.  Just stop this crap and implement sane
> interfaces for the next generation hardware instead of wasting your
> time on this idiotic idea.

Hi Christoph,

What exactly is it that you are not happy about? Is it the concept of
using host memory to store L2P translation information or how that
concept has been translated into SCSI commands (HPB READ BUFFER, HPB
READ and HPB WRITE BUFFER)?

In the former case: aren't Open-Channel SSDs another example of storage
devices for which the L2P translation tables are maintained in host
memory? Didn't the driver for Fusion-io SSDs also maintain the L2P
mapping in host memory?

Do you agree that HPB UFS storage devices are already being used widely
and hence that not accepting this functionality in the upstream kernel
will force users of HPB devices to maintain HPB code outside the kernel
tree? Isn't one of the goals of the Linux kernel project to increase its
user base?

Bart.


