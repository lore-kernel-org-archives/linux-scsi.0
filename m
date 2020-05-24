Return-Path: <SRS0=1EFY=7G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEA1AC433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 24 May 2020 15:50:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A6FD207DA
	for <linux-scsi@archiver.kernel.org>; Sun, 24 May 2020 15:50:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgEXPux (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 24 May 2020 11:50:53 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37909 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgEXPux (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 24 May 2020 11:50:53 -0400
Received: by mail-pf1-f194.google.com with SMTP id q8so7811272pfu.5
        for <linux-scsi@vger.kernel.org>; Sun, 24 May 2020 08:50:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=j6BN3ANHE6a2Q5Hf17li7zBc2dOyL1gSLZ2Dzx6JpZA=;
        b=ZPqSwwTBhkfdQhllzQji3p97/nE5swpHrv3d8S3ItgdfCkYbG3eLdbhDr6TkAPYkWQ
         zHgavyqygO1qdIXqabe02zcjCUUQWbEmN8kSjSV0jrsTWxRxTf6WdfFV4c3e477tGzst
         oMNHSKJZrseFdfu13e4dP2Pubvxm9GNxxr/IkOuC5kjan5RhZXIeTKIkJfuCkK4vjLKw
         GTNd17T0C2eV9KKlekcNZrVc2TSxGRG8tfsMgMJb5e8jGETNC1Yh3QRU5P/ElbGlgbie
         RAhczCOLqd/C3LoN67bc3re126cu3IaShEUKEB2m/aUmFvKEJozqdwmiU5dYUl1xGxIk
         jpaQ==
X-Gm-Message-State: AOAM531TyZ6R/ZQwrlqYS/Hf9iXJzyqfEH0pVofWV5xz1/9GcKntEikI
        1WPO5AWZNemhkZxO3KTq8MA=
X-Google-Smtp-Source: ABdhPJy5NVTdNqy8qvPqmQpDDi2R9iEZefnNzsYmjh4omj4EI4XgGX/K+FNMtYuXAvUft/BTUt2new==
X-Received: by 2002:a62:c5c2:: with SMTP id j185mr6101793pfg.74.1590335450798;
        Sun, 24 May 2020 08:50:50 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:9477:1dd0:c09d:7101? ([2601:647:4000:d7:9477:1dd0:c09d:7101])
        by smtp.gmail.com with ESMTPSA id b63sm10958958pfg.86.2020.05.24.08.50.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 May 2020 08:50:49 -0700 (PDT)
Subject: Re: [PATCH v7 15/15] qla2xxx: Fix endianness annotations in source
 files
To:     Finn Thain <fthain@telegraphics.com.au>,
        Daniel Wagner <dwagner@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E. J. Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Arun Easi <aeasi@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200518211712.11395-1-bvanassche@acm.org>
 <20200518211712.11395-16-bvanassche@acm.org>
 <20200519152401.oh6cewdru3fu7ogd@beryllium.lan>
 <alpine.LNX.2.22.394.2005201726250.8@nippy.intranet>
 <20200520085652.ps64ccmgjefc46cc@beryllium.lan>
 <alpine.LNX.2.22.394.2005211358460.8@nippy.intranet>
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
Message-ID: <2737709e-1423-da29-4697-dc517ad7e413@acm.org>
Date:   Sun, 24 May 2020 08:50:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.22.394.2005211358460.8@nippy.intranet>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-23 21:28, Finn Thain wrote:
> 2. The get_unaligned_le32() changes produce new pointer offsets in the 
> assembly code for qla82xx_get_table_desc() and qla82xx_get_data_desc().
> 
> diff -ru /tmp/unpatched/qla_target.s /tmp/patched/qla_target.s
> --- /tmp/unpatched/qla_target.s 2020-05-24 14:02:32.178019380 +1000
> +++ /tmp/patched/qla_target.s   2020-05-24 14:01:43.487947966 +1000
> @@ -12884,10 +12884,10 @@
>         .cfi_offset 6, -16
>         movq    %rsp, %rbp
>         .cfi_def_cfa_register 6
> -       subq    $32, %rsp
> -       movq    %rdi, -24(%rbp)
> -       movq    %rsi, -32(%rbp)
> -       movq    -32(%rbp), %rax
> +       subq    $64, %rsp
> +       movq    %rdi, -56(%rbp)
> +       movq    %rsi, -64(%rbp)
> +       movq    -64(%rbp), %rax
>         movl    52(%rax), %eax
>         movl    %eax, -8(%rbp)
>         movl    $24, -12(%rbp)
> @@ -12895,62 +12895,62 @@
>         cmpl    %eax, -12(%rbp)
>         cmovbe  -12(%rbp), %eax
>         movl    %eax, %edx
> -       movq    -32(%rbp), %rax
> +       movq    -64(%rbp), %rax
>         movl    %edx, 52(%rax)
> -       movq    -24(%rbp), %rax
> +       movq    -56(%rbp), %rax
> (and so on.)
> 
> Was this expected? I find it surprising...

The functions qla82xx_get_table_desc() and qla82xx_get_data_desc() exist
in qla_nx.c. Does the above diff perhaps refer to qla_nx.s instead of
qla_target.s?

To me the change of "subq $32, %rsp" into "subq $64, %rsp" means that
the compiler reserved more space on the stack for local variables.

If I compare the assembler output for qla_nx.c then I see that
qla82xx_get_table_desc() gets inlined with my patch applied but not
without my patch applied. This is something that I had not expected but
that explains the above diff IMHO.

Bart.
