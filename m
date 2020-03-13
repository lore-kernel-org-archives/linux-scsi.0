Return-Path: <SRS0=Yi3m=46=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B925C10DCE
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 14:56:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DD11206FA
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 14:56:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgCMO4R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Mar 2020 10:56:17 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39856 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgCMO4Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Mar 2020 10:56:16 -0400
Received: by mail-pg1-f196.google.com with SMTP id s2so5117754pgv.6
        for <linux-scsi@vger.kernel.org>; Fri, 13 Mar 2020 07:56:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Sc4/5PAi7piB/S3raDDoP9v1KIZnW6zhR9EmFg+3htg=;
        b=lsLwpG4MT2/TbCJ9RCIPF3MzKQobtcKjZzHRd1ZKa+bFrhNHR5Y2VFDv+EzPIxyQ4L
         2nFVkl4jfCUIjMnKse0T0aGzXwMEHu/uPqKmsUnEjG3LaIoIWogulIXWr6i5yk6hRtNt
         IdHekgSJccVu/+bst+YD7p/KaCh7ELEjfDm9EVol3lbTdYRu3hwqKN68JnMAdhDQCGux
         qiKFgH522d+kBiWIkgw7k5YYldq6WKrzKDxrEuFKYjM+ABF9O3Y1Be7KxIRZm3F5mHtF
         mI3Spk/eEVgsMXEQgMGfrUaAVZM4jtBM7njHEdHDXb8l3dzS1RK7nzztUKtCwwGVog6v
         +n2Q==
X-Gm-Message-State: ANhLgQ0S+cd0v1934FFOEK/z9wXkdTuk19PDKYrwAZUd61IMcKLmc2LY
        sR8ITtz+2ZXz5AJAw8MZcQ0=
X-Google-Smtp-Source: ADFU+vui45tohJRWaoijvNehVGfGhhBMQ6UIp+K8jqFp+eHKOwX/tUCvKWVZRlAPlQOnVMQXnQrKlQ==
X-Received: by 2002:a65:4489:: with SMTP id l9mr12378584pgq.248.1584111375019;
        Fri, 13 Mar 2020 07:56:15 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:4927:51b8:6d1e:6c02? ([2601:647:4000:d7:4927:51b8:6d1e:6c02])
        by smtp.gmail.com with ESMTPSA id 129sm33875841pfw.84.2020.03.13.07.56.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Mar 2020 07:56:14 -0700 (PDT)
Subject: Re: [PATCH v2 3/5] treewide: Consolidate
 {get,put}_unaligned_[bl]e24() definitions
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@fb.com>,
        Felipe Balbi <balbi@kernel.org>,
        Harvey Harrison <harvey.harrison@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20200313023718.21830-1-bvanassche@acm.org>
 <20200313023718.21830-4-bvanassche@acm.org>
 <20200313092522.GR1922688@smile.fi.intel.com>
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
Message-ID: <c7a54745-b605-c349-a005-c8cdb9a7c18e@acm.org>
Date:   Fri, 13 Mar 2020 07:56:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200313092522.GR1922688@smile.fi.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-03-13 02:25, Andy Shevchenko wrote:
> On Thu, Mar 12, 2020 at 07:37:16PM -0700, Bart Van Assche wrote:
>> Move the get_unaligned_be24(), get_unaligned_le24() and
>> put_unaligned_le24() definitions from various drivers into
>> include/linux/unaligned/generic.h. Add a put_unaligned_be24()
>> implementation.
>>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Keith Busch <kbusch@kernel.org>
>> Cc: Sagi Grimberg <sagi@grimberg.me>
>> Cc: Jens Axboe <axboe@fb.com>
>> Cc: Felipe Balbi <balbi@kernel.org>
>> Cc: Harvey Harrison <harvey.harrison@gmail.com>
>> Cc: Martin K. Petersen <martin.petersen@oracle.com>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: H. Peter Anvin <hpa@zytor.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> 
> Btw, Greg  gave Ack to my patch, I think it applies here as well (for USB)
> because the change is basically the same.

If nobody complains I will add the following:

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org> # For USB

Thanks,

Bart.

