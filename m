Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DDDCC47255
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 16:11:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E04F22070B
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 16:11:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730016AbgEKQLw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 12:11:52 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38051 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729550AbgEKQLw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2020 12:11:52 -0400
Received: by mail-pl1-f193.google.com with SMTP id m7so4131633plt.5
        for <linux-scsi@vger.kernel.org>; Mon, 11 May 2020 09:11:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=sErqUs0vhXwvlzUk5Qm/vY6u1XrZRa3tkjbjJjEjN1Y=;
        b=WiyYweE0/D+KmLXgem8gA7nzHAK+PPc0cISSyb1Iq5A9mre6007tr84q/m3qXx6nWr
         EnWFc/h3b/d5gzyH/FgX6cTCzNG98wTIzt7Y1gymYqilUd1GOJ9gBPauw0xGqJR9eZ4k
         hGf+jPvq7VG3Y2GHVNRdh6Ai/gxANm4lAP7vQw2UUGbatKlcGJ3wwhbpVSVyZyQ/rzVG
         bLUBnJNJcmVDmd2zayUk4Apukw/mBjtag3vbGgfIlEWW9D9H+Z4t6c1gicvtrmdIfbeq
         nu3tQ2GORSxhzyjgsp1zZidYph9+KB/wjAEnTjz1mNpdG/6935go/25HIf0kRsW6He8W
         LpJQ==
X-Gm-Message-State: AGi0PuYDbngiirtBStDk3AviggX2tSjrDcaPYRNpKqqBRRz70e9yKUC9
        lM1ZKho8sWW4z8sM+z1Lo8I=
X-Google-Smtp-Source: APiQypJ85td6HFuySLFa+CzqnEKSY9yxjZgo/dfS5wzhumem7+D1cn1lVJM1di2OGXkjaxpKE8noNA==
X-Received: by 2002:a17:90a:246c:: with SMTP id h99mr19339682pje.125.1589213511473;
        Mon, 11 May 2020 09:11:51 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:c4e5:b27b:830d:5d6e? ([2601:647:4000:d7:c4e5:b27b:830d:5d6e])
        by smtp.gmail.com with ESMTPSA id j32sm8328722pgb.55.2020.05.11.09.11.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 09:11:50 -0700 (PDT)
Subject: Re: [PATCH v4 09/11] qla2xxx: Change {RD,WRT}_REG_*() function names
 from upper case into lower case
To:     Arun Easi <aeasi@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200427030310.19687-1-bvanassche@acm.org>
 <20200427030310.19687-10-bvanassche@acm.org>
 <alpine.LRH.2.21.9999.2005110039430.23618@irv1user01.caveonetworks.com>
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
Message-ID: <8667a46c-631e-a00c-2a1a-ac97c5fd0fd0@acm.org>
Date:   Mon, 11 May 2020 09:11:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.21.9999.2005110039430.23618@irv1user01.caveonetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-11 00:40, Arun Easi wrote:
> On Sun, 26 Apr 2020, 8:03pm, Bart Van Assche wrote:
>> @@ -258,8 +258,8 @@ static inline void WRT_REG_DWORD(volatile __le32 __iomem *addr, u32 data)
>>   * The ISP2312 v2 chip cannot access the FLASH/GPIO registers via MMIO in an
>>   * 133Mhz slot.
>>   */
>> -#define RD_REG_WORD_PIO(addr)		(inw((unsigned long)addr))
>> -#define WRT_REG_WORD_PIO(addr, data)	(outw(data, (unsigned long)addr))
>> +#define rd_reg_word_PIO(addr)		(inw((unsigned long)addr))
>> +#define wrt_reg_word_PIO(addr, data)	(outw(data, (unsigned long)addr))
> 
> Why mix case for PIO? Might as well do it here too. Anyway,
> 
> Reviewed-by: Arun Easi <aeasi@marvell.com>

Hi Arun,

Please trim emails when replying. It was hard for me to find your reply.

Anyway, I will make the proposed change.

Thanks,

Bart.
