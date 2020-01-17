Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53AC9C33CB3
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 03:44:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36D57206D7
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 03:44:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgAQDoB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jan 2020 22:44:01 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46812 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbgAQDoB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jan 2020 22:44:01 -0500
Received: by mail-pg1-f193.google.com with SMTP id z124so10952919pgb.13;
        Thu, 16 Jan 2020 19:44:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=qjTEZbkvZijH4Q89/0bwix+Zc3hP19cN20BTOTVd7ng=;
        b=USjaUajzaBwGhFtukQxPiT+886qWEyeCz5lpJ0xteL+2JwjFLeGOdlNP5Jh20qiU2n
         +AA7BNHss0g+hekJICM/C1Ofb51mBV18DqbO4rM+UQ2GCRSGmuPMZTflhAwBaEBxg7J2
         nPiJeLzUr7E/5kWNx35VYdfOhwL/kW1/mXLoVqWPE/QS4BZKdaImbk9l6hDWb2WBOA/m
         jjGYATRHT2Ed9yeZA7F8ALw5VCqQJJ2o5I9Z4PDbg6kfaPEWglKjhdEWRvTOhBrPgcxX
         Hx5wGdTh/Hen8I7I59fNO1Ykw+DkBO0qwDUKLod6y8b01R+HOmYzUEUOMMT2YyCVAvGy
         kP9A==
X-Gm-Message-State: APjAAAV8Aa8dvKR6Dxr7H34Qg7RgNYUY83jaLsEG7R1CEQulkZBtCOXr
        WN+GTyGuafoDAAW76aiJwEge0fj6Wu0=
X-Google-Smtp-Source: APXvYqx/V246VdMxBbBw6pKES2lQAgrm1BArd8h4eU99sD0DLcnzC23G7dv2zleCjsyJJHEo8NIsRQ==
X-Received: by 2002:aa7:914b:: with SMTP id 11mr931294pfi.69.1579232640078;
        Thu, 16 Jan 2020 19:44:00 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:8dfb:7edd:e01b:b201? ([2601:647:4000:d7:8dfb:7edd:e01b:b201])
        by smtp.gmail.com with ESMTPSA id b65sm27119652pgc.18.2020.01.16.19.43.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2020 19:43:58 -0800 (PST)
Subject: Re: [PATCH v1 1/1] scsi: ufs: Add command logging infrastructure
To:     "Asutosh Das (asd)" <asutoshd@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        cang@codeaurora.org
Cc:     Avri Altman <Avri.Altman@wdc.com>,
        "Winkler, Tomas" <tomas.winkler@intel.com>, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Evan Green <evgreen@chromium.org>,
        Janek Kotas <jank@cadence.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>
References: <1571808560-3965-1-git-send-email-cang@codeaurora.org>
 <5B8DA87D05A7694D9FA63FD143655C1B9DCF0AFE@hasmsx108.ger.corp.intel.com>
 <MN2PR04MB6991C2AF4DDEDD84C7887258FC6B0@MN2PR04MB6991.namprd04.prod.outlook.com>
 <01eb3c55e35738f2853fbc7175a12eaa@codeaurora.org>
 <20191029054620.GG1929@tuxbook-pro>
 <b7de9358-b8ba-3100-a3f2-ebed8aaab490@codeaurora.org>
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
Message-ID: <a07f3244-6536-0667-cf61-3ef8b8bc6c7e@acm.org>
Date:   Thu, 16 Jan 2020 19:43:56 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <b7de9358-b8ba-3100-a3f2-ebed8aaab490@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-16 15:03, Asutosh Das (asd) wrote:
> On 10/28/2019 10:46 PM, Bjorn Andersson wrote:
>> On Mon 28 Oct 19:37 PDT 2019, cang@codeaurora.org wrote:
>>
>>> On 2019-10-23 18:33, Avri Altman wrote:
>>>>>
>>>>>> Add the necessary infrastructure to keep timestamp history of
>>>>>> commands, events and other useful info for debugging complex issues.
>>>>>> This helps in diagnosing events leading upto failure.
>>>>>
>>>>> Why not use tracepoints, for that?
>>>> Ack on Tomas's comment.
>>>> Are there any pieces of information that you need not provided by the
>>>> upiu tracer?
>>>>
>>>> Thanks,
>>>> Avri
>>>
>>> In extreme cases, when the UFS runs into bad state, system may crash.
>>> There
>>> may not be a chance to collect trace. If trace is not collected and
>>> failure
>>> is hard to be reproduced, some command logs prints would be very
>>> helpful to
>>> help understand what was going on before we run into failure.
>>>
>>
>> This is a common problem shared among many/all subsystems, so it's
>> better to rely on a generic solution for this; such as using tracepoints
>> dumped into pstore/ramoops.
>>
>> Regards,
>> Bjorn
>>
> 
> Reviving this discussion.
> 
> Another issue with using ftrace is that several subsystems use it.
> Consider a situation in which we store a history of 64 commands,
> responses and some other required info in ftrace.
> 
> Say there's a command that's stuck for seconds until the software times
> out. In this case, the other ftrace events are still enabled and keep
> writing to ftrace buffer thus overwriting some/most of the ufs's command
> history; thus the history is more or less lost. And there's a need to
> reproduce the issue with other tracing disabled.
> 
> So what we need is a client specific logging mechanism, which is
> lightweight as ftrace and can be parsed from ramdumps.
> 
> I'm open to ideas but ftrace in its current form may not be suitable for
> this.

Hi Asutosh,

Are you aware that it is already possible today to figure out which SCSI
commands are pending? Are you familiar with the files under
/sys/kernel/debug/block/? An example:

$ (cd /sys/kernel/debug/block && grep -aH . */*/busy)
nvme0n1/hctx7/busy:0000000006f07009 {.op=READ, .cmd_flags=META|PRIO,
.rq_flags=DONTPREP|IO_STAT, .state=in_flight, .tag=275, .internal_tag=-1}

Bart.


