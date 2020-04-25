Return-Path: <SRS0=0MZD=6J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EC99C55191
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Apr 2020 17:52:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 490F320672
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Apr 2020 17:52:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbgDYRv5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 25 Apr 2020 13:51:57 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:51110 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726061AbgDYRv5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Apr 2020 13:51:57 -0400
Received: by mail-pj1-f65.google.com with SMTP id t9so5288719pjw.0;
        Sat, 25 Apr 2020 10:51:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=YOYpjIbi+oV00jOmN2uFU72RJjmnEToaQzfcciU/EQM=;
        b=SRegaX7Lr0dA32l4dd2LaaVw13wUDk2xIOUUw+1flYWVM7IDqRQB8fpg8kADp9IcQs
         49lafNEtrPqBggsF0O+c3y1B2mtQ7yhlJe/CF1a1n/BWFbcDLm01p74sGcldllTRcW8g
         7VQ98LV/ed9hwV5LhpwLNAN1qLZLc2INbBh1V76AGyfo/NPtqSQEUgu7cwa9MdanbFXk
         BmYGqDZWrKFyPWusuEyd2eSie1QCX10OreIhhRpnVpxjbbcsFqOoM0xxMICB4fYKRpeJ
         /h3Ixf/edJCvTjRJj7hzfFCJGXpvfSqB4KXe3exUVZ2JEtBI775glLWY8QF1tM71YaLP
         uu6g==
X-Gm-Message-State: AGi0PuZ6GHPGKWc3/CTrwSEu5vLVsTtq2FfCN7oRor1Y+rWAYt7qHphZ
        eKlpcYCv164qOjnWKE0qJDR7+k+Yk/c=
X-Google-Smtp-Source: APiQypLyIdqdey0S7tINcmBiKFBGecZ1mzVKrvwLHIvRV7Y3vFsxibnx6YprZdbQ7HjTIc+co5PCCw==
X-Received: by 2002:a17:902:b18d:: with SMTP id s13mr15065359plr.240.1587837114672;
        Sat, 25 Apr 2020 10:51:54 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:9817:f6ce:d8be:3e60? ([2601:647:4000:d7:9817:f6ce:d8be:3e60])
        by smtp.gmail.com with ESMTPSA id a21sm8550316pfk.39.2020.04.25.10.51.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Apr 2020 10:51:53 -0700 (PDT)
Subject: Re: [PATCH v2 5/5] scsi: ufs: UFS Host Performance Booster(HPB)
 driver
To:     Avri Altman <Avri.Altman@wdc.com>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200416203126.1210-1-beanhuo@micron.com>
 <20200416203126.1210-6-beanhuo@micron.com>
 <8921adc3-0c1e-eb16-4a22-1a2a583fc8b3@acm.org>
 <SN6PR04MB4640851C163648C54EB274C5FCD00@SN6PR04MB4640.namprd04.prod.outlook.com>
 <SN6PR04MB4640ABB2BB5D2CE5AA2C3778FCD10@SN6PR04MB4640.namprd04.prod.outlook.com>
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
Message-ID: <12e8ad61-caa4-3d28-c1d7-febe99a488fb@acm.org>
Date:   Sat, 25 Apr 2020 10:51:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <SN6PR04MB4640ABB2BB5D2CE5AA2C3778FCD10@SN6PR04MB4640.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-04-25 01:59, Avri Altman wrote:
> One last word for the community members that are not into ufs day-to-day:
> 
> HPB implementation made its first public appearance around 2018 as part of Google's Pixel3 and some VIVO models.
> Since then, more and more mobile platforms are publically using HPB: Galaxy Note10,
> Galaxy S20 and VIVO NEX3 (that is already using HPB2.0), some Xiaomi models etc.
> 
> On the other hand, HPB1.0 spec was just recently closed - not even as part of UFS3.1,
> but only after - about 2 months ago. The industry is rushing forward, we've seen this many times.
> 
> The fact is that HPB is here to stay - either as a horde of out-of-tree implementations,
> or as a standard acceptable mainline driver.

Hi Avri,

Thanks for the additional clarification. I think we need HPB support in
the upstream kernel. A possible approach is to start a discussion about
how to integrate HPB support in the upstream kernel and to defer posting
new implementations until agreement about an approach has been achieved.
Is there e.g. an alternative for avoiding deadlocks other than using the
blk-mq reserved tag feature for the commands that manage the L2P tables?

Thanks,

Bart.
