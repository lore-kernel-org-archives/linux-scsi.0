Return-Path: <SRS0=ICpX=ZG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50AEDC432C3
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 02:34:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77DDC206F3
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 02:34:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfKNCen (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Nov 2019 21:34:43 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34363 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfKNCen (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Nov 2019 21:34:43 -0500
Received: by mail-pg1-f195.google.com with SMTP id z188so2686218pgb.1
        for <linux-scsi@vger.kernel.org>; Wed, 13 Nov 2019 18:34:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ZC4F8egCW2FV2YNCMmqpMWetyObVa72yR/mLPhLXY8A=;
        b=axSDjSw4imIj6pBt3oBxWJZvhbSGYmJXEdbhywCaNUOXdwzEwsr0ItnMDAoXaR5sOF
         +riRUq4hP7UuZn5wNJZmMsrihmOrmANlS1yH1Ciw8JVhJeMasLCplg8hNUpAvlO5zH3+
         Qpvm/44DGc7j6UG11wlcOzwjLYnpa4AUF8Mz9w4b6iojztRB8uvYC93J/Ilv4bzmDhEr
         wUAoxEhyjEm6jvhC5IUniAJ2kDSlvpWfgEmuUqr9wY80dvD5c9xu2DKdOkZpCf2LF1bg
         OaE6b25TcD+gxbPufuhxhZbd886ZqyYbo9yZXqJJBbI3juCrVLuRVBeOvHEVtO1Dp/Te
         jj6w==
X-Gm-Message-State: APjAAAWtdBnQPazS4ZtGE2Ba+bi959DIs8E1CDej9ny9mu0Cxjd1eCzW
        /6xq6uHJiEawvPEyx4fJLls=
X-Google-Smtp-Source: APXvYqwJLH9U6WI3ExRkFh7oI7aDg+bBSPQyLLLZydIBvp0HBLiFVwo6TAHuHaykvFyvDwwlBRqIpg==
X-Received: by 2002:a62:83ca:: with SMTP id h193mr8068819pfe.218.1573698882621;
        Wed, 13 Nov 2019 18:34:42 -0800 (PST)
Received: from ?IPv6:2601:647:4000:a8:cb7:5e35:ff76:162c? ([2601:647:4000:a8:cb7:5e35:ff76:162c])
        by smtp.gmail.com with ESMTPSA id q8sm3844750pgg.15.2019.11.13.18.34.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Nov 2019 18:34:41 -0800 (PST)
Subject: Re: [PATCH] Revert "qla2xxx: Fix Nport ID display value"
To:     Himanshu Madhani <hmadhani@marvell.com>
Cc:     Roman Bolshakov <r.bolshakov@yadro.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Quinn Tran <qutran@marvell.com>
References: <20191109042135.12125-1-bvanassche@acm.org>
 <20191111112804.nycfzaddewlz6yzl@SPB-NB-133.local>
 <32187dd9-f222-fbed-cc93-1c6abca6e06c@acm.org>
 <19433666-FCA3-4340-8A81-707F85B87F02@marvell.com>
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
Message-ID: <1dac96c3-54d5-11bf-292b-c25a62a3c919@acm.org>
Date:   Wed, 13 Nov 2019 18:34:40 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <19433666-FCA3-4340-8A81-707F85B87F02@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-11-13 07:29, Himanshu Madhani wrote:
> On Nov 11, 2019, at 8:48 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>> Himanshu, can you tell us which adapters and/or firmware versions need
>> which version of the above code?
> 
> All adapters with FW v4.4 will behave same. If you are running into issue with P2P connection,
> it might be something different than specific to this code change. Original code in the driver was not
> following firmware spec. This code is now used in initiator mode as well due to introduction of
> FC-NVMe handling in the driver.  Also, can you tell me what version of firmware you have on your 
> remote port.

Hi Himanshu,

My test was run on a setup with a single QLE2562 adapter with both FC
ports connected directly to each other. The kernel driver identifies
that adapter as follows: ISP2532: PCIe (5.0GT/s x8) @ 0000:00:0a.0 hdma+
host#=12 fw=8.07.00 (90d5). Please let me know if you need more information.

Thanks,

Bart.

