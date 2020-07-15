Return-Path: <SRS0=K8op=A2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C72AAC433E4
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 04:00:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B01C2206D5
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 04:00:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725798AbgGOEAs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 00:00:48 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:40944 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbgGOEAr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2020 00:00:47 -0400
Received: by mail-pj1-f66.google.com with SMTP id t15so2014321pjq.5;
        Tue, 14 Jul 2020 21:00:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=lERFJsVziUIHdDubkh5EQsGRx2WiD8PPl5yIF/RY6ck=;
        b=Nv2Rkw7Xrczm2KEgi3kdQVC2yk6r3J/TrCnDoMEwi6y5ouLa1Ti7V28sgnNed+knFT
         aTGuz74f1xKCvjj4IM6JS9xAX6WX9QZhSbIMXvkveznnEkb0GRurKCUFZ5Q2z27m7vKj
         FsK/mwfE2MUQlJCK7Qx3ijqg4ZPmfdR/O9DxdZMu4pyAgkvr3NF+HgZK26bEPPqaNK3R
         T+0luXxLI/ZMWnToRrDqrjholVJ9T9+T4Qs/JZXrBs7KhadOcilPema6IGEA7qOPZMxl
         SOwpuNwuOEP9EW8/IqU3DAaGIMOb33KJ6Sbj6MUwute4uPiQcYNi5Cqw2YTXLIwAv/hU
         tECg==
X-Gm-Message-State: AOAM531eChbYjvp+9Erxl1imVLJYBV3ljvN3eG7Wg9hR0z9egCpD7bom
        cgBobHnMsM7k6vMxWZp2ZDE=
X-Google-Smtp-Source: ABdhPJx1qYjuOEb0D4RJpuqJbzCrkMb27Oza/CFeXaMET7dz1U0JmL/QBR5OITuGJreervEq8almHw==
X-Received: by 2002:a17:902:b589:: with SMTP id a9mr6097265pls.98.1594785647018;
        Tue, 14 Jul 2020 21:00:47 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id i132sm568002pfe.9.2020.07.14.21.00.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jul 2020 21:00:46 -0700 (PDT)
Subject: Re: [PATCH v3] scsi: ufs: Cleanup completed request without interrupt
 notification
To:     Avri Altman <Avri.Altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>
References: <20200706132113.21096-1-stanley.chu@mediatek.com>
 <3d509c4b-d66d-2a4a-5fbd-a50a0610ad31@acm.org>
 <1594607245.22878.8.camel@mtkswgap22>
 <SN6PR04MB46409838AE9D4BD63797E26DFC600@SN6PR04MB4640.namprd04.prod.outlook.com>
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
Message-ID: <912623e8-5915-8380-f39a-fac7b5868a6d@acm.org>
Date:   Tue, 14 Jul 2020 21:00:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <SN6PR04MB46409838AE9D4BD63797E26DFC600@SN6PR04MB4640.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-13 01:10, Avri Altman wrote:
> Artificially injecting errors is a very common validation mechanism,
> Provided that you are not breaking anything of the upper-layers,
> Which I don't think you are doing.

Hi Avri,

My concern is that the code that is being added in the abort handler
sooner or later will evolve into a duplicate of the regular completion
path. Wouldn't it be better to poll for completions from the timeout
handler by calling ufshcd_transfer_req_compl() instead of duplicating
that function?

>>> In section 7.2.3 of the UFS specification I found the following about how
>>> to process request completions: "Software determines if new TRs have
>>> completed since step #2, by repeating one of the two methods described in
>>> step #2. If new TRs have completed, software repeats the sequence from
>>> step #3." Is such a loop perhaps missing from the Linux UFS driver?
>
> Could not find that citation.
> What version of the spec are you using?

That quote comes from the following document: "Universal Flash Storage
Host Controller Interface (UFSHCI); Version 2.1; JESD223C; (Revision of
JESD223B, September 2013); MARCH 2016".

Bart.

