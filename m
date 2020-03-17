Return-Path: <SRS0=78fV=5C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB327C10F29
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Mar 2020 03:59:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA57A20658
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Mar 2020 03:59:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgCQD7k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Mar 2020 23:59:40 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:37518 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbgCQD7k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Mar 2020 23:59:40 -0400
Received: by mail-pj1-f65.google.com with SMTP id ca13so9821921pjb.2;
        Mon, 16 Mar 2020 20:59:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=o+0HagUr4HI/xbZe0kDuhSARtN12WFdm90lmgkXYbjo=;
        b=HpIC7oI7IkH1xvv3lyGo6It8aIM/sJbeLMJCCukl5O9X7Vb7wc6levG1j/L3b72XeF
         PkK22cTzJOYlK5ds3juOlw65Ek2/qKsnGIREdHm/r2dD4NQYIwhFKiiWxO6UVNwWCnux
         Kf7PRJWYM6nu/NQZ/3HLxSb6ffIhpFli8C8WSsDX7/hXa9RdQybRPQSl4wtNAmyKfniz
         hR+nAcrNUWgaRr45GKUnBwU5Tz9eZi9lT466To9yJbBAwgAktDgfSXsyqRHRWcs/fChc
         uQSorgxwG5TvwpLWglBa/2BiQnQ1ImrcatS9it5tbnukd187BKrtAHbGxB7CJPt5IBJO
         H8cA==
X-Gm-Message-State: ANhLgQ0GQ1HCMBVl/Z/fUDfhilSvrRlK+sH/v27c+EbE6fPgSML5r0r7
        2sG8wFwNeR0SHxfQbw1Ccg8=
X-Google-Smtp-Source: ADFU+vsXomTDgzT6KgwIqseoW04GHkn2UK/Mw6vKIvY+mvHnkDTo863+r8mAFDy8AB4kc8InAOyEmw==
X-Received: by 2002:a17:90b:352:: with SMTP id fh18mr3039940pjb.168.1584417577134;
        Mon, 16 Mar 2020 20:59:37 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:f131:b83b:a5b4:4b1b? ([2601:647:4000:d7:f131:b83b:a5b4:4b1b])
        by smtp.gmail.com with ESMTPSA id 8sm1293481pfv.65.2020.03.16.20.59.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2020 20:59:36 -0700 (PDT)
Subject: Re: [PATCH v6 3/7] scsi: ufs: introduce common delay function
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
        beanhuo@micron.com, asutoshd@codeaurora.org, cang@codeaurora.org,
        matthias.bgg@gmail.com, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com
References: <20200316085303.20350-1-stanley.chu@mediatek.com>
 <20200316085303.20350-4-stanley.chu@mediatek.com>
 <fdf91490-9c7d-df34-1c1f-e03e12855378@acm.org>
 <1584404000.14250.28.camel@mtksdccf07>
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
Message-ID: <b7a6045e-9615-0cd2-9812-2871bf9ba44c@acm.org>
Date:   Mon, 16 Mar 2020 20:59:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1584404000.14250.28.camel@mtksdccf07>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-03-16 17:13, Stanley Chu wrote:
> On Mon, 2020-03-16 at 09:23 -0700, Bart Van Assche wrote:
>> On 3/16/20 1:52 AM, Stanley Chu wrote:
>>> +void ufshcd_wait_us(unsigned long us, unsigned long tolerance, bool can_sleep)
>>> +{
>>> +	if (!us)
>>> +		return;
>>> +
>>> +	if (us < 10 || !can_sleep)
>>> +		udelay(us);
>>> +	else
>>> +		usleep_range(us, us + tolerance);
>>> +}
>>> +EXPORT_SYMBOL_GPL(ufshcd_wait_us);
>>
>> I don't like this function because I think it makes the UFS code harder 
>> to read instead of easier. The 'can_sleep' argument is only set by one 
>> caller which I think is a strong argument to remove that argument again 
>> and to move the code that depends on that argument from the above 
>> function into the caller. Additionally, it is not possible to comprehend 
>> what a ufshcd_wait_us() call does without looking up the function 
>> definition to see what the meaning of the third argument is.
>>
>> Please drop this patch.
> 
> Thanks for your review and comments.
> 
> If the problem is the third argument 'can_sleep' which makes the code
> not be easily comprehensible, how about just removing 'can_sleep' from
> this function and keeping left parts because this function provides good
> flexibility to users to choose udelay or usleep_range according to the
> 'us' argument?

Hi Stanley,

I think that we need to get rid of 'can_sleep' across the entire UFS
driver. As far as I can see the only context from which 'can_sleep' is
set to true is ufshcd_host_reset_and_restore() and 'can_sleep' is set to
true because ufshcd_hba_stop() is called with a spinlock held. Do you
agree that it is wrong to call udelay() while holding a spinlock() and
that doing so has a bad impact on the energy consumption of the UFS
driver? Has it already been considered to use another mechanism to
serialize REG_CONTROLLER_ENABLE changes, e.g. a mutex?

Thanks,

Bart.
