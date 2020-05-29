Return-Path: <SRS0=G6Im=7L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC105C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 03:56:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFCDC2074D
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 03:56:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388007AbgE2D4b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 23:56:31 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:36969 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbgE2D4a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2020 23:56:30 -0400
Received: by mail-pj1-f66.google.com with SMTP id q9so574081pjm.2
        for <linux-scsi@vger.kernel.org>; Thu, 28 May 2020 20:56:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=+KQexcC1LjR7qdrqoVa1AxedhFo0lDBxDAv+kaTh/sg=;
        b=pCozC7RNcWpUZFkKyBtg1lT/8RWoPKjnNS3by0nH11FIAr/5zfTFzgrAtr9/wqcZ5I
         xsWldNpc3Si+5eNJUpmTO9pDz5JCMWYDov1tGPPPbZQAddlyhgrhJKnb03kP7HGep0i0
         HUtWlI0RhYPYvBd8twACEVa3Rxn3/oqIo4MbGXkR6RcSc0eDfiPyKLeZu998ZhBJUAQL
         rOlXe8D9sXAQvyR7tXfwXJ2PS3ykM0eejak0Om0ULjLf3lBedP1R2r+OOGRA7ccibUXd
         mbfKd96QLE/OydDLqBoTyP5gV/1ZSOtJuRc273RkqtT3dqsZMvLbrFFVBY9Oo5BthBGe
         hPCA==
X-Gm-Message-State: AOAM5314ers9TG+Jm1oyx5rlbSctrhGmiXS6Ti7IhW46pvabwrtfioNH
        KDXGivrjitCOe6yzyOatBoQ=
X-Google-Smtp-Source: ABdhPJztPo5vxmaGSzJ1Z/b7kWNDGl4epkv45sx/DyuW2lMQuZr2Aq5iuBvmL8r8XDA1edg7TYLbnA==
X-Received: by 2002:a17:90a:272b:: with SMTP id o40mr7397831pje.64.1590724587936;
        Thu, 28 May 2020 20:56:27 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:9d69:6341:e4af:37f4? ([2601:647:4000:d7:9d69:6341:e4af:37f4])
        by smtp.gmail.com with ESMTPSA id b29sm5973601pff.176.2020.05.28.20.56.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 20:56:26 -0700 (PDT)
Subject: Re: [PATCH 6/6] ufs: Remove the SCSI timeout handler
To:     Can Guo <cang@codeaurora.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
References: <20191224220248.30138-1-bvanassche@acm.org>
 <20191224220248.30138-7-bvanassche@acm.org>
 <4fe9074323178a0b006f08402dd08b51@codeaurora.org>
 <1728e2d6-5b00-e71f-5476-b082f4201aa1@acm.org>
 <8bd12e9fe32b0f996209ac2d4e8aa484@codeaurora.org>
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
Message-ID: <efed2865-030a-c98f-5b8f-e9cb008022a4@acm.org>
Date:   Thu, 28 May 2020 20:56:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <8bd12e9fe32b0f996209ac2d4e8aa484@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-28 18:39, Can Guo wrote:
> On 2020-05-29 00:12, Bart Van Assche wrote:
>> ufshcd_queuecommand() must have
>> finished before the block layer timeout handler is activated.
>
> This is the ideal/expected situation, but we are seeing the corner case.
> 
> Fixing the root cause of that is one thing, but having the timeout handler
> back can prevent UFS driver from messing up the subsequent requests further
> in such case, causing possible data corruption. Is there any drawbacks if
> we have it back?

Hi Can,

My conclusion from your emails is that ufshcd_queuecommand() can spend
more time than the SCSI timeout (30 seconds) in dma_map_sg(). A
dma_map_sg() call that keeps the CPU busy during more than 30 seconds is
not only weird but it is also a disaster from the point of view of
energy consumption. Please fix the root cause.

Thanks,

Bart.
