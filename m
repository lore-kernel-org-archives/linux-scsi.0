Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F765C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Mar 2022 12:40:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234974AbiCVMmL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Mar 2022 08:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233731AbiCVMmK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Mar 2022 08:42:10 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B346C85963;
        Tue, 22 Mar 2022 05:40:42 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id a17so20447530edm.9;
        Tue, 22 Mar 2022 05:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=t1hZFpsz98krD/PH6PxD5vpNeuRF6mWyFaQ+Q3Qv/og=;
        b=UXludevU4N+p982mYx7Qkiuj40zxoJtkHMgMP3V2iou/diyuRnv6wwjOEGByrz6Xu/
         YKW7Sorst5cJyKWl1uiX3zE+sPz6pagVQdkFgxFwcpsF8KOnWLF8ciOIoL2wJvXJuLtO
         2Ssu49xjbyhwGM3bOLVcrNyQj2Xy/Kr8Sx77sZaUJC9bMAokk3WwRMG8S/X6vkEefPQV
         3GbBsBlJTncumbeQzpJGc4xKyvNEGtIM704ubCBcCf+YUbxg4zdf7GDWbEg/kuZF++cG
         HdckEf+Tod+5YXb7eWO938sEbjEpOB76PFLlSGFiQiyd/G6JeZ6+CD+NBdlQrT5Q2J4m
         SO1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=t1hZFpsz98krD/PH6PxD5vpNeuRF6mWyFaQ+Q3Qv/og=;
        b=TxhOtxFzB04brCtlWH0Jlh+eDCgebzNk/evhTwMybf/PEJjGdbOCpSQH6DLFAG7VdG
         Bzsw5L+I20jT7vrohOZ3kUeSPutpT9ccelq0z19d0wZtilFvdDpNfqs2n3Js3rOve4Md
         SJL4t3/YeItXsxBTOyJZ+65dPdSP6/BjVgjXgamUGW5siNXRzDoyxu/XfsnyS2lCs3B3
         buW1QzAoCZYAZSY0gBTfbIXhA9HpoCQXUuhccAat5uzreIQngEaZm7a4r1d9jFG9rkfh
         /QQfZXl6dBwEzOiOodVkDykXf86r+H9ki7b11+mocUEoxY6Ux3Hvx9v3ZogGr2XdRKOj
         36UQ==
X-Gm-Message-State: AOAM532CHRfPNB5eLRCAqgI4hVEbh9ETcqcxexUV7IjobwIqeoTZvyMH
        Pbv81UaSGy0H1UbOZnBJd+Y=
X-Google-Smtp-Source: ABdhPJwFuW1BX+jn6RtSuudaiv5oLls6Mdga2VU/4A9C/Gywcs+m8OUtiWD63/AQuVfEeNZW+rqMcA==
X-Received: by 2002:aa7:d74d:0:b0:419:1d7:adcc with SMTP id a13-20020aa7d74d000000b0041901d7adccmr24916128eds.407.1647952840775;
        Tue, 22 Mar 2022 05:40:40 -0700 (PDT)
Received: from [192.168.178.40] (ipbcc1cfad.dynamic.kabel-deutschland.de. [188.193.207.173])
        by smtp.gmail.com with ESMTPSA id u5-20020aa7d985000000b004024027e7dasm9328415eds.28.2022.03.22.05.40.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Mar 2022 05:40:40 -0700 (PDT)
Message-ID: <abbe51c4-873f-e96e-d421-85906689a55a@gmail.com>
Date:   Tue, 22 Mar 2022 13:40:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC 0/3] Add zero copy feature for tcmu
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        linux-mm@kvack.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     linux-block@vger.kernel.org, xuyu@linux.alibaba.com
References: <20220318095531.15479-1-xiaoguang.wang@linux.alibaba.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
In-Reply-To: <20220318095531.15479-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 18.03.22 10:55, Xiaoguang Wang wrote:
> The core idea to implement tcmu zero copy feature is really straight,
> which just maps block device io request's sgl pages to tcmu user space
> backstore, then we can avoid extra copy overhead between sgl pages and
> tcmu internal data area(which really impacts io throughput), please see
> https://www.spinics.net/lists/target-devel/msg21121.html for detailed
> info.
> 

Can you please tell us, how big the performance improvement is and
which configuration you are using for measurenments?

> Initially I use remap_pfn_range or vm_insert_pages to map sgl pages to
> user space, but both of them have limits:
> 1)  Use vm_insert_pages
> which is like tcp getsockopt(TCP_ZEROCOPY_RECEIVE), but there're two
> restrictions:
>    1. anonymous pages can not be mmaped to user spacea.
>      ==> vm_insert_pages
>      ====> insert_pages
>      ======> insert_page_in_batch_locked
>      ========> validate_page_before_insert
>      In validate_page_before_insert(), it shows that anonymous page can not
>      be mapped to use space, we know that if issuing direct io to block
>      device, io request's sgl pages mostly comes from anonymous page.
>          if (PageAnon(page) || PageSlab(page) || page_has_type(page))
>              return -EINVAL;
>      I'm not sure why there is such restriction? for safety reasons ?
> 
>    2. warn_on triggered in __folio_mark_dirty
>      When calling zap_page_range in tcmu user space backstore when io
>      completes, there is a warn_on triggered in __folio_mark_dirty:
>         if (folio->mapping) {   /* Race with truncate? */
>             WARN_ON_ONCE(warn && !folio_test_uptodate(folio));
> 
>      I'm not familiar with folio yet, but I think the reason is that when
>      issuing a buffered read to tcmu block device, it's page cache mapped
>      to user space, backstore write this page and pte will be dirtied. but
>      initially it's newly allocated, hence page_update flag not set.
>      In zap_pte_range(), there is such codes:
>         if (!PageAnon(page)) {
>             if (pte_dirty(ptent)) {
>                 force_flush = 1;
>                 set_page_dirty(page);
>             }
>     So this warn_on is reasonable.
>     Indeed what I want is just to map io request sgl pages to tcmu user
>     space backstore, then backstore can read or write data to mapped area,
>     I don't want to care about page or its mapping status, so I choose to
>     use remap_pfn_range.
> 
> 2) Use remap_pfn_range()
>    remap_pfn_range works well, but it has somewhat obvious overhead. For a
>    512kb io request, it has 128 pages, and usually this 128 page's pfn are
>    not consecutive, so in worst cases, for a 512kb io request, I'd need to
>    issue 128 calls to remap_pfn_range, it's horrible. And in remap_pfn_range,
>    if x86 page attribute table feature is enabled, lookup_memtype called by
>    track_pfn_remap() also introduces obvious overhead.
> 
> Finally in order to solve these problems, Xu Yu helps to implment a new
> helper, which accepts an array of pages as parameter, anonymous pages can
> be mapped to user space, pages would be treated as special pte(pte_special
> returns true), so vm_normal_page returns NULL, above folio warn_on won't
> trigger.
> 
> Thanks.
> 
> Xiaoguang Wang (2):
>    mm: export zap_page_range()
>    scsi: target: tcmu: Support zero copy
> 
> Xu Yu (1):
>    mm/memory.c: introduce vm_insert_page(s)_mkspecial
> 
>   drivers/target/target_core_user.c | 257 +++++++++++++++++++++++++++++++++-----
>   include/linux/mm.h                |   2 +
>   mm/memory.c                       | 183 +++++++++++++++++++++++++++
>   3 files changed, 414 insertions(+), 28 deletions(-)
> 
