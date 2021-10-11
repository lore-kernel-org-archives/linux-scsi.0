Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58B52C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 19:40:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E0F160F43
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 19:40:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234686AbhJKTmI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Oct 2021 15:42:08 -0400
Received: from mail-pg1-f174.google.com ([209.85.215.174]:33311 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232027AbhJKTmI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Oct 2021 15:42:08 -0400
Received: by mail-pg1-f174.google.com with SMTP id a73so11795519pge.0
        for <linux-scsi@vger.kernel.org>; Mon, 11 Oct 2021 12:40:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kruOA8bOi927BKzv7mbeKA1Xff6TQ9CBCnh/FityEnQ=;
        b=H0nTjC9koD5TaCJOIfFmlvMCEiqh9WUxntuPoPm7KC3KtpYGXdtsIQlPCMyez5XYeu
         tTe7TkGY4MwvNJPJ94B1yXckBUkVzDpMPfKb2XT1mtuza0Gt/gChY1S2C3ZAtmjW2ugQ
         nEC6DmZ5VhzJebRk6K3Uo1oaDoZa45c0LipZyVOYEmrR8mIKtEv8BzE2oBEuCvQdHbeB
         HZHdSeHmQiAYVVdh9K83REoTLFAZZtjtpXswUx/Pt1h/LYHo27sWgBKurW1KCZJZfxwV
         l7sYcaHI62TPTq34BubPrRiZwbI0kYDu+HwXaf9pzO7v91SJJuut3+vK88jKGVqQUpBC
         Kc9A==
X-Gm-Message-State: AOAM530qmVyTa50PDFapqYjMllCjfXNDN/tIpgi8GoD/xrL2P0PQnLHi
        qvrhSjNMZXF+TAhzFjBez8P/2XIjNkQ=
X-Google-Smtp-Source: ABdhPJw0YIAenxpVaLmuPfvihPEgRN8HzsE5HxEegmCIphR5mJEqBSe4uKozaGYxB4TKKVlybZIScw==
X-Received: by 2002:a65:62c4:: with SMTP id m4mr19772631pgv.453.1633981207462;
        Mon, 11 Oct 2021 12:40:07 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:5253:6091:3f47:989d? ([2601:647:4000:d7:5253:6091:3f47:989d])
        by smtp.gmail.com with ESMTPSA id m7sm8870061pgn.32.2021.10.11.12.40.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Oct 2021 12:40:06 -0700 (PDT)
Message-ID: <af2fa285-aa9e-72de-0f19-b3a054678ee0@acm.org>
Date:   Mon, 11 Oct 2021 12:40:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH] spraid: initial commit of Ramaxel spraid driver
Content-Language: en-US
To:     Yanling Song <songyl@ramaxel.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org
References: <20210930034752.248781-1-songyl@ramaxel.com>
 <526271c5-a745-7666-6b18-9eb61898f1db@acm.org>
 <20211009133207.789ad116@songyl>
 <52ee4617-93ba-919f-b990-f04f64a13d4b@acm.org>
 <20211011083435.6e24a2e8@songyl>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20211011083435.6e24a2e8@songyl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/11/21 01:34, Yanling Song wrote:
> get_unaligned_be*() is an inline which has the same function as our
> current code and there is no difference on performance.
> But current code is better when supporting old kernels since it is
> implemented on SCSI spec and there is no dependency on
> get_unaligned_be*(), which means the code can work on any version
> of kernel.
> So I prefer to keep current implementation. What's your opinion?

Hi Yanling,

On all architectures I'm familiar with get_unaligned_be*() is faster 
than fetching individual bytes and combining these with shift 
operations. As an example, x86 CPU's support unaligned memory accesses 
and for these CPU's the Linux kernel translates get_unaligned_be*() into 
a single (potentially unaligned) memory access.

Kernel drivers that are submitted for upstream inclusion should use the 
upstream kernel API. Whether or not get_unaligned_be*() is available in 
older kernels does not matter - since it is available in the upstream 
kernel and since it makes code faster and easier to read, using that 
function is strongly recommended. Additionally, it can happen that after 
a driver has been accepted upstream that someone writes a Coccinelle 
script to change all open-coded get_unaligned_be*() calls into 
get_unaligned_be*() calls. Compatibility with older kernels would not be 
accepted as a valid argument against such a patch.

I think that get_unaligned_be*() functions are supported since kernel 
version 2.6.26, released in 2008, 13 years ago. Does this address your 
concern about supporting older kernel versions?

Regarding supporting older kernel versions, a common approach is to 
develop against the latest upstream kernel. To support older kernels, 
include a header file called e.g. backport.h and in that header file 
implement the latest kernel API in terms of older kernel functions. An 
example:

#if LINUX_VERSION_CODE < KERNEL_VERSION(4, 14, 0) &&	\
	!defined(CONFIG_SUSE_KERNEL)
static inline void bio_set_dev(struct bio *bio,
                                struct block_device *bdev)
{
	bio->bi_bdev = bdev;
}
#endif

Bart.
