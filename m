Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5AC6C38A2A
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 22:29:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87D87216FD
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 22:29:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgEHW3l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 18:29:41 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36583 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727082AbgEHW3l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 18:29:41 -0400
Received: by mail-pg1-f194.google.com with SMTP id d22so1514409pgk.3
        for <linux-scsi@vger.kernel.org>; Fri, 08 May 2020 15:29:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=gKbOb4boJ7z+2oCHWb7R40Fkbb6M7I9TRXxhkxZKIE8=;
        b=V0kO59uZFQEOU7srCUD/MC4zzb/qyboHmY3ZF6DIy55/wGSFeg7SsAITDjM4BM446G
         O1aAmFxKNA/q5VESQYoQs9Bd3JNvZjLBHnj/4XkWQcCqc4C3a73uP0/0KkeDGojafj8Y
         BIHo9nF9UVWIMPoFCT5TdCRpaR9e8OqsV2LTWmigDCf5m8DJ0ZyRadtJ8QXi7FuNbK6w
         Ki1XLHQ3lOoTmAjk4NH7S2L0dTEudvdVVAxwOa58r1uGEwg7wBta11o8+hN51Y7gTb0+
         kE6V5a6UZmhZqvFuzzXc4zXURBOx/xQlORm7miXodGjwX9Pcd++K2EFN2GpQle3hK6gD
         sQTw==
X-Gm-Message-State: AGi0PuZNgbxFwLUL8QZM/85yQ1WcS/muPo8jK1UgLkcHUY4Sn99rFax6
        AHn0Ahahwlb1sjQwUNGYlfw=
X-Google-Smtp-Source: APiQypKUNV0NsH6563aOt3+/uu4H+ILQgX3WNn11IUFfrLoIVrNFkciA37J26vdUKTSkYSFRmGH5/w==
X-Received: by 2002:aa7:951b:: with SMTP id b27mr5215090pfp.2.1588976979981;
        Fri, 08 May 2020 15:29:39 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:89ed:1db3:8c60:ba90? ([2601:647:4000:d7:89ed:1db3:8c60:ba90])
        by smtp.gmail.com with ESMTPSA id o11sm2109675pgp.62.2020.05.08.15.29.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 May 2020 15:29:39 -0700 (PDT)
Subject: Re: [PATCH v5 02/11] qla2xxx: Suppress two recently introduced
 compiler warnings
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        kbuild test robot <lkp@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        kbuild-all@lists.01.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Rajan Shanmugavelu <rajan.shanmugavelu@oracle.com>,
        Joe Jin <joe.jin@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>
References: <20200507042835.9135-3-bvanassche@acm.org>
 <202005080353.y49Uwj18%lkp@intel.com>
 <CAKwvOdnuXX2xpsz6fxV-qfvj1AqN3V7qyOwtwtCG4NWq+HzfAw@mail.gmail.com>
 <86bcf088-a35d-0a0f-0ba4-5883b1f2d6cb@acm.org>
 <CAK8P3a3PA25WUJp73Yea9xq_ca3uXA9Vz2U=UmHiDhg8FmGiNw@mail.gmail.com>
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
Message-ID: <040756ba-81ea-64e4-6a11-85608b871b88@acm.org>
Date:   Fri, 8 May 2020 15:29:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a3PA25WUJp73Yea9xq_ca3uXA9Vz2U=UmHiDhg8FmGiNw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-08 14:25, Arnd Bergmann wrote:
> On Fri, May 8, 2020 at 1:16 AM Bart Van Assche <bvanassche@acm.org> wrote:
>>
>> On 2020-05-07 15:00, Nick Desaulniers wrote:
>>> On Thu, May 7, 2020 at 12:18 PM kbuild test robot <lkp@intel.com> wrote:
>>>> All errors (new ones prefixed by >>):
>>>>
>>>>    In file included from drivers/scsi/qla2xxx/qla_dbg.c:77:
>>>>>> include/trace/events/qla.h:13:32: error: unknown warning group '-Wsuggest-attribute=format', ignored [-Werror,-Wunknown-warning-option]
>>>>    #pragma GCC diagnostic ignored "-Wsuggest-attribute=format"
>>>>                                   ^
>>>
>>> Hi Bart,
>>> These compiler specific pragma's are not toolchain portable.  You'll
>>> need to wrap them in:
>>> #ifndef __clang__
>>> preprocessor macros, or I think we have a pragma helper in tree that
>>> helps with compiler specific pragmas.  IIRC it uses _Pragma to define
>>> pragmas in macros.
>> Hi Nick,
>>
>> Thanks for the feedback. I will have a look at _Pragma() and see what
>> the best way is to suppress this warning.
> 
> The __diag_ignore() macro in linux/compiler.h should work for this.

Thanks Arnd, that's good to know. Is using __diag_ignore() mandatory in
this case? The following construct seems to work fine with both gcc and
clang:

 #define QLA_MSG_MAX 256

+#pragma GCC diagnostic push
+#ifndef __clang__
+#pragma GCC diagnostic ignored "-Wsuggest-attribute=format"
+#endif
+
 DECLARE_EVENT_CLASS(qla_log_event,
 	TP_PROTO(const char *buf,
 		struct va_format *vaf),
@@ -27,6 +32,8 @@ DECLARE_EVENT_CLASS(qla_log_event,
 	TP_printk("%s %s", __get_str(buf), __get_str(msg))
 );

+#pragma GCC diagnostic pop
+
 DEFINE_EVENT(qla_log_event, ql_dbg_log,
 	TP_PROTO(const char *buf, struct va_format *vaf),
 	TP_ARGS(buf, vaf)

Bart.
