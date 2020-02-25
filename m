Return-Path: <SRS0=dnTk=4N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF48DC35DF3
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Feb 2020 03:41:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF87024653
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Feb 2020 03:41:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbgBYDlx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Feb 2020 22:41:53 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36058 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726962AbgBYDlw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Feb 2020 22:41:52 -0500
Received: by mail-pl1-f194.google.com with SMTP id a6so4918379plm.3;
        Mon, 24 Feb 2020 19:41:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=NfwJ5K56Btcw4+UaJTYHBCDqKgLQRVQFN/YDLhlR3cE=;
        b=IyzGPlJoRjnXtrZKqxy8CeKRhhTCgUF5T/HuODbaT4Fnz4/dB1zm+tUyrECKP8GjLj
         wXcftavqOexWAhqSdB37F8b0qGPcDAKApjrf4zBUgBTUFM48lINxJIajhQxloqZX+IxW
         38F5jXt/v/GWOYt78t2mBu7pa3D1Gi4P+9jUxcYi5lThf6LfBOKwu6eA3QFtdi7vT3S3
         VkcDGBjPBMfKa9JqUiAYRyIRBMDrctVjxiE49RkyjL2seI12yVdEyPnidtrncexLeIxG
         M3FAFPcqnFhd+tQ+yc9sYVmK0pOjYGAX6ETtmSlSylfaU9Wc0JLMNRYPPXo6DX0sNrv3
         2phA==
X-Gm-Message-State: APjAAAURh3W1TbuYfAcWMktVqSW/ARx58xwTWQMphFuA+9J5czzle7+G
        z6/7Mp4p/f6LxWp78l8S1NXRiPyxhP8=
X-Google-Smtp-Source: APXvYqxjqaP4aSXz3bwzH7aV+g9LNgqYdRjYsNhqFFdaTjsULo7Q6Rj28RTLmhuTYEpfDsdsibeoqQ==
X-Received: by 2002:a17:90a:3841:: with SMTP id l1mr2784753pjf.108.1582602111270;
        Mon, 24 Feb 2020 19:41:51 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:e0d5:574d:fc92:e4e? ([2601:647:4000:d7:e0d5:574d:fc92:e4e])
        by smtp.gmail.com with ESMTPSA id w21sm14427241pgc.87.2020.02.24.19.41.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 19:41:50 -0800 (PST)
Subject: Re: NULL pointer dereference in qla24xx_abort_command, kernel 4.19.98
 (Debian)
To:     Ondrej Zary <linux@zary.sk>
Cc:     qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <202002231929.01662.linux@zary.sk>
 <202002232057.16101.linux@zary.sk>
 <336cb7b1-5e40-5830-3c1c-4389257081ea@acm.org>
 <202002240920.17691.linux@zary.sk>
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
Message-ID: <1fbad673-1b8c-0813-c60e-a4f56330a972@acm.org>
Date:   Mon, 24 Feb 2020 19:41:48 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <202002240920.17691.linux@zary.sk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-02-24 00:20, Ondrej Zary wrote:
> Looks like it's in some inlined function.
> 
> /usr/src/linux-source-4.19# gdb /lib/modules/4.19.0-8-amd64/kernel/drivers/scsi/qla2xxx/qla2xxx.ko
> GNU gdb (Debian 8.2.1-2+b3) 8.2.1
> ...
> Reading symbols from /lib/modules/4.19.0-8-amd64/kernel/drivers/scsi/qla2xxx/qla2xxx.ko...Reading symbols 
> from /usr/lib/debug//lib/modules/4.19.0-8-amd64/kernel/drivers/scsi/qla2xxx/qla2xxx.ko...done.
> done.
> 
> (gdb) list *(qla24xx_async_abort_cmd+0x1b)
> 0xf88b is in qla24xx_async_abort_cmd (./arch/x86/include/asm/atomic.h:97).
> 92       *
> 93       * Atomically increments @v by 1.
> 94       */
> 95      static __always_inline void arch_atomic_inc(atomic_t *v)
> 96      {
> 97              asm volatile(LOCK_PREFIX "incl %0"
> 98                           : "+m" (v->counter) :: "memory");
> 99      }
> 100     #define arch_atomic_inc arch_atomic_inc
>
> [ ... ]
> 
> (gdb) disassemble qla24xx_async_abort_cmd
> Dump of assembler code for function qla24xx_async_abort_cmd:
>    0x000000000000f870 <+0>:     callq  0xf875 <qla24xx_async_abort_cmd+5>
>    0x000000000000f875 <+5>:     push   %r15
>    0x000000000000f877 <+7>:     push   %r14
>    0x000000000000f879 <+9>:     push   %r13
>    0x000000000000f87b <+11>:    push   %r12
>    0x000000000000f87d <+13>:    push   %rbp
>    0x000000000000f87e <+14>:    push   %rbx
>    0x000000000000f87f <+15>:    mov    0x28(%rdi),%r13
>    0x000000000000f883 <+19>:    mov    0x20(%rdi),%r15
>    0x000000000000f887 <+23>:    mov    0x48(%rdi),%r14
>    0x000000000000f88b <+27>:    lock incl 0x4(%r14)
>    0x000000000000f890 <+32>:    mfence

Thanks, this is very helpful. I think the above means that the crash is
triggered by the following code:

	sp = qla2xxx_get_qpair_sp(cmd_sp->qpair, cmd_sp->fcport,
		GFP_KERNEL);

From the start of qla2xxx_get_qpair_sp():

	QLA_QPAIR_MARK_BUSY(qpair, bail);

From qla_def.h:

#define QLA_QPAIR_MARK_BUSY(__qpair, __bail) do {	\
	atomic_inc(&__qpair->ref_count);		\
	mb();						\
	if (__qpair->delete_in_progress) {		\
		atomic_dec(&__qpair->ref_count);	\
		__bail = 1;				\
	} else {					\
	       __bail = 0;				\
	}						\
} while (0)

One of the changes between kernel version v4.9.210 and v4.19.98 is the
following: "qla2xxx: Add multiple queue pair functionality". I think the
 above information means that the cmd_sp->qpair pointer is NULL. I will
let QLogic recommend a solution.

Bart.
