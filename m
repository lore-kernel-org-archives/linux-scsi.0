Return-Path: <SRS0=AKtJ=6V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06782C47247
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 23:16:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E351720870
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 23:16:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgEGXQf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 19:16:35 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33237 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbgEGXQf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 19:16:35 -0400
Received: by mail-pl1-f194.google.com with SMTP id t7so2722036plr.0
        for <linux-scsi@vger.kernel.org>; Thu, 07 May 2020 16:16:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=qu+ByJdMlD1CkEGLIpiu7+O3BI4pk0mRsd5qbYrIWjo=;
        b=RezPR5kyn6Ht7juOa/+d7QC81/PwLbLyNMvkJENxxvktUtNeE1UHQLgj/TqocChDub
         s57r5zeXCF+V9ATFDk+2gLMZv+b+Jwb145zG3Qp1eT9QoXYDT25MN0laxmkSoHQSsCV3
         TC96A/5kh7dskiREs8olJZ6t3zXZR8uJcMEioGrFJHagtJfPcySw/Vfsfv8NuH8mqtMA
         5QTCvyPELgrr4ga/8puDVRxkGU87Og/1oGSstvrRiielEze6tHqlRhOi+fOKKLuI1wgR
         Dw+9jjkN9pESmX0I5daLVNfRQ+SpyK1eEVUZBfG/LVVqmQjusP9qZ3zy2Coa6RHze95i
         DB9w==
X-Gm-Message-State: AGi0PubTM/s4xhsf77WnzOaiwZmsGiiY85Q/Foeq1e6m+9bWCNcvsG8q
        bn2jCdjcWhJcTTBZa3PXCcI=
X-Google-Smtp-Source: APiQypKFAt6hgetfVqk+/mGy0opCg9LrVvrs3efeVwdICvkeaWpQRdL4HSPG+tvRqZAfThQzmMcW5w==
X-Received: by 2002:a17:90a:3b42:: with SMTP id t2mr2755128pjf.11.1588893394286;
        Thu, 07 May 2020 16:16:34 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:8ce8:d4c:1f4f:21e0? ([2601:647:4000:d7:8ce8:d4c:1f4f:21e0])
        by smtp.gmail.com with ESMTPSA id cm14sm753333pjb.31.2020.05.07.16.16.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 16:16:33 -0700 (PDT)
Subject: Re: [PATCH v5 02/11] qla2xxx: Suppress two recently introduced
 compiler warnings
To:     Nick Desaulniers <ndesaulniers@google.com>,
        kbuild test robot <lkp@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        kbuild-all@lists.01.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        linux-scsi@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Rajan Shanmugavelu <rajan.shanmugavelu@oracle.com>,
        Joe Jin <joe.jin@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>, Arnd Bergmann <arnd@arndb.de>
References: <20200507042835.9135-3-bvanassche@acm.org>
 <202005080353.y49Uwj18%lkp@intel.com>
 <CAKwvOdnuXX2xpsz6fxV-qfvj1AqN3V7qyOwtwtCG4NWq+HzfAw@mail.gmail.com>
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
Message-ID: <86bcf088-a35d-0a0f-0ba4-5883b1f2d6cb@acm.org>
Date:   Thu, 7 May 2020 16:16:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAKwvOdnuXX2xpsz6fxV-qfvj1AqN3V7qyOwtwtCG4NWq+HzfAw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-07 15:00, Nick Desaulniers wrote:
> On Thu, May 7, 2020 at 12:18 PM kbuild test robot <lkp@intel.com> wrote:
>> All errors (new ones prefixed by >>):
>>
>>    In file included from drivers/scsi/qla2xxx/qla_dbg.c:77:
>>>> include/trace/events/qla.h:13:32: error: unknown warning group '-Wsuggest-attribute=format', ignored [-Werror,-Wunknown-warning-option]
>>    #pragma GCC diagnostic ignored "-Wsuggest-attribute=format"
>>                                   ^
> 
> Hi Bart,
> These compiler specific pragma's are not toolchain portable.  You'll
> need to wrap them in:
> #ifndef __clang__
> preprocessor macros, or I think we have a pragma helper in tree that
> helps with compiler specific pragmas.  IIRC it uses _Pragma to define
> pragmas in macros.
Hi Nick,

Thanks for the feedback. I will have a look at _Pragma() and see what
the best way is to suppress this warning.

Bart.
