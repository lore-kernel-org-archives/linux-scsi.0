Return-Path: <SRS0=m56l=BO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9DBAC433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 18:43:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE99521744
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 18:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbgHDSnH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Aug 2020 14:43:07 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:54526 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727812AbgHDSnG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2020 14:43:06 -0400
Received: by mail-pj1-f68.google.com with SMTP id mt12so2929634pjb.4;
        Tue, 04 Aug 2020 11:43:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=p9np+eKKP43n3qbBWouR6lSQzP6T8lD1PCULhcRMsYc=;
        b=SYd9V8PzAb+wTDbRote4MLiSM4G5JQoJwVpyI6j4ijsTSHt81SETiV3F9o7YmeZmYU
         IHlvRQV+Pr3aaWXJfUx3NfLJz/HqiElQT9ifUClCS7ScwgCCL2W5Yi24RRQ424PH5x1F
         E1n0MbJprkITSRyYoz7NhIj2k6vrvArTtrsIo5dPbNwQ+RLb94SJla7XrFBYDr850DZ4
         l/JhM5plqdT2WbxruF1HqTD4nkGapbrUhIF6boQd3xVu9NaCslGtoDzASTbmma4iazy8
         T2coqRYuVdsSMxNu/Z3ckgunKHT3dkgAgtNigY+PEAT+7lI8RvqU17xtVbkQr8mK9FPs
         fD0Q==
X-Gm-Message-State: AOAM531XZI9HetQPQyK3QVpezdSi4cKzvtiZTfNiVjImzOsFtuGOojXM
        9NnHorrnX/VmljTl2g7Ocmk=
X-Google-Smtp-Source: ABdhPJzK5NDqDIaBe60YIfskP8ilC2R7cAT7BSUhyu5OAx1ZCYsF4HPUKNi0uY9BkmNZBb2ObOGz4g==
X-Received: by 2002:a17:90a:5206:: with SMTP id v6mr5559682pjh.202.1596566585944;
        Tue, 04 Aug 2020 11:43:05 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id b24sm21903595pgn.8.2020.08.04.11.43.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2020 11:43:05 -0700 (PDT)
Subject: Re: [PATCH v6 2/5] scsi: ufs: Add UFS-feature layer
To:     daejun7.park@samsung.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
References: <7bcf45da-233b-0c38-b93a-99d205603e63@acm.org>
 <231786897.01594636801601.JavaMail.epsvc@epcpadp1>
 <963815509.21594636682161.JavaMail.epsvc@epcpadp2>
 <231786897.01594637401708.JavaMail.epsvc@epcpadp1>
 <20200722064112.GB21117@infradead.org> <yq1h7tzg1lb.fsf@ca-mkp.ca.oracle.com>
 <CGME20200713103423epcms2p8442ee7cc22395e4a4cedf224f95c45e8@epcms2p3>
 <963815509.21595830981720.JavaMail.epsvc@epcpadp2>
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
Message-ID: <8d0fe031-e941-1b4e-7596-301ebd36f06d@acm.org>
Date:   Tue, 4 Aug 2020 11:43:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <963815509.21595830981720.JavaMail.epsvc@epcpadp2>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-26 23:18, Daejun Park wrote:
>>> I am also not sold on the whole "bus" thing.
>>
>> How about implementing HPB as a kernel module that calls the functions
>> in the UFS core directly, or in other words, get rid completely of the
>> new ufsf_bus introduced by this patch?
> 
> OK, I will remove the ufsf_bus and indirect calling functions.

Hi Daejun,

Any idea how much time this work will take and when a new version will be
posted?

Thanks,

Bart.
