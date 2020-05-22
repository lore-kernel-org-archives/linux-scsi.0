Return-Path: <SRS0=0D1w=7E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B096C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 22 May 2020 16:35:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E3FE2054F
	for <linux-scsi@archiver.kernel.org>; Fri, 22 May 2020 16:35:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730419AbgEVQf1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 May 2020 12:35:27 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:33664 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbgEVQf1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2020 12:35:27 -0400
Received: by mail-pj1-f67.google.com with SMTP id z15so2367008pjb.0;
        Fri, 22 May 2020 09:35:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=FrFECtsWjQl6tf8ykrWng9hvZAmDCDrjdPeRhrm7ht8=;
        b=AK3HPcv03cTNj5OniSg9AXgBrdm8JYAEvHQrf0pK38gz6pFeRYn049kvvwH+Sq4jKT
         d0G6DxQsEhgPcFzzvpmJeMFSo93rB/QqUVowbRyCKVtGDP7kngIZv4bNJFQlxiKwL9+0
         H1WvQq3gJ9GjV+vI/cFGEaHDvDbTh+QnPOqg4eJDbFSj9OS+P7HL66wRbz79z451+GHA
         UBKF/EX9cMO2QGoWKj7BtH/vmlkkton5lL3aHGRikGthEK/1AtteAcMTEbd872VfIZIw
         SPKWfKyLr/q3W8bM2xesOpxf+fQtemYbfLjOeF3eBqjsLRXkIEtqggi3DdTQHy01BQLB
         Vn9A==
X-Gm-Message-State: AOAM532d3RsAqYFNMFwaEZkhfXavSwxW8MeNsCylM+XPD1+WBiPvWoBN
        K/FAfIMSxma/mY4hiRzjaPw=
X-Google-Smtp-Source: ABdhPJyXQgvh/4e4/HGGwIDBAWsyl5WfZZk7uK5Jo8/5fM225m/l8sR/7+kGSH1fMjgsiFE/d4N8vw==
X-Received: by 2002:a17:90a:21af:: with SMTP id q44mr5827865pjc.50.1590165325521;
        Fri, 22 May 2020 09:35:25 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:69bd:6780:3ba9:55db? ([2601:647:4000:d7:69bd:6780:3ba9:55db])
        by smtp.gmail.com with ESMTPSA id s15sm6488500pgv.5.2020.05.22.09.35.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2020 09:35:24 -0700 (PDT)
Subject: Re: Another approach of UFSHPB
From:   Bart Van Assche <bvanassche@acm.org>
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
 <e1e81ad1-2681-9dbe-34aa-85f4e5559927@acm.org>
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
Message-ID: <224ba721-b80e-f018-a3f9-a2f56ecef8d6@acm.org>
Date:   Fri, 22 May 2020 09:35:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <e1e81ad1-2681-9dbe-34aa-85f4e5559927@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-20 14:19, Bart Van Assche wrote:
> On 2020-05-20 10:55, Christoph Hellwig wrote:
>> HPB is a completely fucked up concept and we shoud not merge it at all.
>> Especially not with a crazy bullshit vendor extension layer that makes
>> it even easier for vendors to implement even worse things than the
>> already horrible spec says.  Just stop this crap and implement sane
>> interfaces for the next generation hardware instead of wasting your
>> time on this idiotic idea.
> 
> What exactly is it that you are not happy about? Is it the concept of
> using host memory to store L2P translation information or how that
> concept has been translated into SCSI commands (HPB READ BUFFER, HPB
> READ and HPB WRITE BUFFER)?
> 
> In the former case: aren't Open-Channel SSDs another example of storage
> devices for which the L2P translation tables are maintained in host
> memory? Didn't the driver for Fusion-io SSDs also maintain the L2P
> mapping in host memory?
> 
> Do you agree that HPB UFS storage devices are already being used widely
> and hence that not accepting this functionality in the upstream kernel
> will force users of HPB devices to maintain HPB code outside the kernel
> tree? Isn't one of the goals of the Linux kernel project to increase its
> user base?

The following quote from
https://www.anandtech.com/show/13474/the-google-pixel-3-review/2 is
interesting: "Another big improvement for file I/O is the implementation
of “Host Performance Booster” in the kernel and UFS controller firmware
stack. HPB is essentially caching of the NAND chip’s FTL (flash
translation layer) L2P (logical to physical) mapping tables into the
hosts (SoCs) main memory. This allows the host driver to look up the
target L2P entry directly without betting on UFS’s limited SRAM to have
a cache-hit, reducing latency and greatly increasing random read
performance. The authors of the feature showcase an improvement of
59-67% in random I/O read performance due to the new feature. It’s worth
to mention that traditional Android I/O benchmarks won’t be able to show
this as as those tend to test read speeds with the files they’ve just
created."

Given the cost of SRAM in embedded controllers I think there is a strong
incentive for manufacturers of flash storage devices to reduce the
amount of SRAM on the storage controller. I think this means that
proposals to use host memory for caching L2P mappings will keep popping
up, no matter what we tell the storage controller vendors about what we
think about such a design.

Bart.
