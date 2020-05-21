Return-Path: <SRS0=cxkO=7D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B3DDC433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 21 May 2020 19:47:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBFF420814
	for <linux-scsi@archiver.kernel.org>; Thu, 21 May 2020 19:47:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729157AbgEUTrO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 May 2020 15:47:14 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42801 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728635AbgEUTrN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 May 2020 15:47:13 -0400
Received: by mail-pg1-f193.google.com with SMTP id n11so3709099pgl.9;
        Thu, 21 May 2020 12:47:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=foeJlyVbhHBxd2p0ZoCNpnTcxIWCYuViSyIENFIMaWU=;
        b=H4AMG/sSIZs2IO9bcj3oTb2+Rho16xRGbewPjJ7FYq5i4ZH/uK7JUSi1jH2fJbMR/K
         8MU8EVXXjA2o/df9FVjyUK9FlWmplPp1i6EDKx8Z/C1JvjuxZYMcTytYoNbzUFdME+i5
         hJOeJ4TA95pQGYEyQYdcfFx5kyuNrphWwJDEFRlnapwdQ97EB4u+tN1ZxObdEnI39E/U
         t9vqKoHcbTUAF+pNrekUT8bYPQZNGUdEcoKypRWLooTiO8eQa7YQyNEdbpwALN8ckCLd
         Ncy6p6PD+xLifrtv9NxFow4Y7/QyXxBNx7Iu1o29/h4aVUxD7ZqqwlJML7Qn2mv6oNSL
         2Ntw==
X-Gm-Message-State: AOAM533dGrD8OXJguH7t44vI9pNGUqzNGmJvNPedxWVjciv4H8mdtxhl
        HQHhi2QsWanuHbydNSPAsyxefRVW
X-Google-Smtp-Source: ABdhPJwjECtHL7tWmApimiikgR+JFhMdB5qg8I2RYTH+ATsJUPRcMqzu2Gmcwg0BVWU5oA0jnyF4eQ==
X-Received: by 2002:a63:e804:: with SMTP id s4mr10597494pgh.260.1590090431859;
        Thu, 21 May 2020 12:47:11 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:50cc:4329:ba49:7ab1? ([2601:647:4000:d7:50cc:4329:ba49:7ab1])
        by smtp.gmail.com with ESMTPSA id x10sm4344548pgr.65.2020.05.21.12.47.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2020 12:47:10 -0700 (PDT)
Subject: Re: [PATCH] scsi: st: convert convert get_user_pages() -->
 pin_user_pages()
To:     John Hubbard <jhubbard@nvidia.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     =?UTF-8?Q?Kai_M=c3=a4kisara?= <Kai.Makisara@kolumbus.fi>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20200519045525.2446851-1-jhubbard@nvidia.com>
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
Message-ID: <494478b6-9a8c-5271-fc9f-fd758af850c0@acm.org>
Date:   Thu, 21 May 2020 12:47:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200519045525.2446851-1-jhubbard@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-18 21:55, John Hubbard wrote:
> This code was using get_user_pages*(), in a "Case 2" scenario
> (DMA/RDMA), using the categorization from [1]. That means that it's
> time to convert the get_user_pages*() + put_page() calls to
> pin_user_pages*() + unpin_user_pages() calls.
> 
> There is some helpful background in [2]: basically, this is a small
> part of fixing a long-standing disconnect between pinning pages, and
> file systems' use of those pages.
> 
> Note that this effectively changes the code's behavior as well: it now
> ultimately calls set_page_dirty_lock(), instead of SetPageDirty().This
> is probably more accurate.
> 
> As Christoph Hellwig put it, "set_page_dirty() is only safe if we are
> dealing with a file backed page where we have reference on the inode it
> hangs off." [3]
> 
> Also, this deletes one of the two FIXME comments (about refcounting),
> because there is nothing wrong with the refcounting at this point.
> 
> [1] Documentation/core-api/pin_user_pages.rst
> 
> [2] "Explicit pinning of user-space pages":
>     https://lwn.net/Articles/807108/
> 
> [3] https://lore.kernel.org/r/20190723153640.GB720@lst.de

Kai, why is the st driver calling get_user_pages_fast() directly instead
of calling blk_rq_map_user()? blk_rq_map_user() is already used in
st_scsi_execute(). I think that the blk_rq_map_user() implementation is
also based on get_user_pages_fast(). See also iov_iter_get_pages_alloc()
in lib/iov_iter.c.

John, why are the get_user_pages_fast() calls in the st driver modified
but not the blk_rq_map_user() call? Are you sure that the modified code
is a "case 2" scenario and not a "case 1" scenario?

Thanks,

Bart.
