Return-Path: <SRS0=fKRq=4M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEF03C35679
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Feb 2020 02:17:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EB3E2067D
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Feb 2020 02:17:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbgBXCRM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Feb 2020 21:17:12 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:53303 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727151AbgBXCRM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Feb 2020 21:17:12 -0500
Received: by mail-pj1-f66.google.com with SMTP id n96so3479350pjc.3;
        Sun, 23 Feb 2020 18:17:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=aY7a1yOVsQSkzgjtNx+4l8akXJgAh6uvUVK0XKNtpLU=;
        b=OTJotyAZNRltBfxzeFpI0aDRMdM4fW37fsRYNezbd2oXtPTKg2mF0zGKlz4XOmpSN3
         Nr6wiWs7NgbUS74DIv9xN/vg7r0TzufimnCslGewmZLpc+EDjbU2HPHJpYz2sCzQEivu
         toTtb+62QQ2gKVa1iqJ+NxtF2ZHyFnpShSViJo1/Lf9t7k0Isxq7NtwgDk/tvdLJFNrn
         f03v4kKkXxDXsnZHGFzpjrcjU86TdFklUR1Gj0JisInboI3Ui5W/eEvn5bkolueHU3Hr
         2ZtOTr4MCMLfgQTBDcoqLWAiZx3BGYzZ+AZAnn6Z6A3B07e0A+TUCMbamlMTVL38I7MC
         x1vw==
X-Gm-Message-State: APjAAAX3EEITOwfFBL9oNm+rVmXjcrchMcsdYdMCBuuSFJ+mfUWeN3wQ
        zaRMN/fUZamCo3Qqisvh0lcC8ndzfqg=
X-Google-Smtp-Source: APXvYqxokF7ddUn8l9JrOfuXCMFi729mweHqKGCiPuypte/ivu5uJzEdqKIwtHmz5NUHwCBFHjwLKg==
X-Received: by 2002:a17:90a:b311:: with SMTP id d17mr17824017pjr.17.1582510631222;
        Sun, 23 Feb 2020 18:17:11 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:e878:dc9f:85a:3cab? ([2601:647:4000:d7:e878:dc9f:85a:3cab])
        by smtp.gmail.com with ESMTPSA id a2sm10516056pfi.30.2020.02.23.18.17.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Feb 2020 18:17:10 -0800 (PST)
Subject: Re: NULL pointer dereference in qla24xx_abort_command, kernel 4.19.98
 (Debian)
To:     Ondrej Zary <linux@zary.sk>
Cc:     qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <202002231929.01662.linux@zary.sk>
 <12dcd970-2aa6-2a9a-0f8c-029201ea84df@acm.org>
 <202002232057.16101.linux@zary.sk>
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
Message-ID: <336cb7b1-5e40-5830-3c1c-4389257081ea@acm.org>
Date:   Sun, 23 Feb 2020 18:17:09 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <202002232057.16101.linux@zary.sk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-02-23 11:57, Ondrej Zary wrote:
> On Sunday 23 February 2020 20:26:39 Bart Van Assche wrote:
>> On 2020-02-23 10:29, Ondrej Zary wrote:
>>> a couple of days after upgrading a server from Debian 9 (kernel 4.9.210-1)
>>> to 10 (kernel 4.19.98), qla2xxx crashed, along with mysql.
>>>
>>> There is an EMC CX3 array connected through the fibre-channel adapter.
>>> No errors are present in EMC event log.
>>>
>>> This server was running without any problems since Debian 4.
>>> Is this a known bug?
>>
>> Please report issues encountered with Debian kernels in the Debian bug
>> tracker. If you want the upstream community to assist please retest with
>> an upstream kernel.
> 
> Debian kernel does not have any patches related to qla2xxx driver:
> https://salsa.debian.org/kernel-team/linux/raw/debian/4.19.98-1/debian/patches/series
> 
> It crashed after running for 11 days. Not a quick&easy test.

It would help a lot if the crash address would be translated into a
source code line number. Something like the following commands should do
the trick:
$ gdb drivers/scsi/qla2xxx/qla2xxx.ko
(gdb) list *(qla24xx_async_abort_cmd+0x1b)

Thanks,

Bart.
