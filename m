Return-Path: <SRS0=8IEi=A5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12195C433E3
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jul 2020 20:38:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7B37207DD
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jul 2020 20:38:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbgGRUir (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Jul 2020 16:38:47 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38345 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbgGRUir (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jul 2020 16:38:47 -0400
Received: by mail-pf1-f194.google.com with SMTP id j20so7072110pfe.5
        for <linux-scsi@vger.kernel.org>; Sat, 18 Jul 2020 13:38:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PP0+SKRyRVL0QvTo/UvpGhsgOXJSuZVC1kEuuwEQhF0=;
        b=lEXPeVAAkt5zn+tihR17OjTRU5XMIa9i5xHdKsFrW8qQnjgZqt8n5e05nUrAbSD6CQ
         6HcmpQlvfTlCSDBg3Z75GzXtzzH8Ow+NVUAl0vhNlfrFpMD6eypzdwJIZee3BiJp3e4e
         IJj06aX/fNdMfoZU1yoCGMsDaiPZ8rIvzvO2o56XcFz4H7FHQ5IF4EEW44SrgWJuWgo6
         oxAe+DFG6kB1WKKPRfPIDLCtpjGuJlaw+n9ArW7n0QHi48tN+5VfzyeD5BGOEcFD4FpX
         DCvQlny0PYrnInLXkseMhZfTvxZqoFpoChqKElpagDdVG48Zg40roRNrfvqA2phNFKLi
         s5Iw==
X-Gm-Message-State: AOAM530JvPJsAEUG/wQqxy4a+eeKIFr52weJLRr0miX3/v4fCS3oFUE8
        8+bVnOgHfEA0ysuMXE1pz7+zt/Z1
X-Google-Smtp-Source: ABdhPJyqjyW3INLhqwrvTAiCxBX6LV2HAMyjyPXEXPPgLpG7qYjOXlrlDHwgKBtGS1yRByau4btLyA==
X-Received: by 2002:aa7:9904:: with SMTP id z4mr13273385pff.324.1595104726385;
        Sat, 18 Jul 2020 13:38:46 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id p127sm11295716pfb.17.2020.07.18.13.38.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jul 2020 13:38:45 -0700 (PDT)
Subject: Re: [RFC PATCH v1] ufs: introduce async ufs interface initialization
To:     Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
References: <CGME20200702082826epcas2p2face6d1689c2f5efc1dcdb53c19804b8@epcas2p2.samsung.com>
 <1593678039-139543-1-git-send-email-kwmad.kim@samsung.com>
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
Message-ID: <8565af37-3d2c-fac9-94f7-0d9fc25c4d38@acm.org>
Date:   Sat, 18 Jul 2020 13:38:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1593678039-139543-1-git-send-email-kwmad.kim@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-02 01:20, Kiwoong Kim wrote:
> When you set uic_link_state during sleep statae to
> UIC_LINK_OFF_STATE, UFS driver does interface initialization
> that is a series of some steps including fDeviceInit and thus,
> You might feel that its latency is a little bit longer.
> 
> This patch is run it asynchronously to reduce system wake-up time.

Device drivers like UFS should only perform tasks that are specific to
the supported device(s). Asynchronous resume from a sleep state is a
mechanism that may also benefit other device drivers. Please work with
the maintainers of the power management subsystem (Rafael J. Wysocki and
Pavel Machek) to integrate support for this feature in the kernel power
management subsystem. The kernel power management subsystem exists in
the directory kernel/power.

Thanks,

Bart.
