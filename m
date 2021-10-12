Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03B2BC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 11:10:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3C2E60BD3
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 11:10:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236032AbhJLLM4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 07:12:56 -0400
Received: from email.ramaxel.com ([221.4.138.186]:64495 "EHLO
        VLXDG1SPAM1.ramaxel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232791AbhJLLM4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 07:12:56 -0400
Received: from V12DG1MBS01.ramaxel.local (v12dg1mbs01.ramaxel.local [172.26.18.31])
        by VLXDG1SPAM1.ramaxel.com with ESMTPS id 19CBAMI9031475
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 Oct 2021 19:10:22 +0800 (GMT-8)
        (envelope-from songyl@ramaxel.com)
Received: from songyl (10.64.10.54) by V12DG1MBS01.ramaxel.local
 (172.26.18.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 12
 Oct 2021 19:10:22 +0800
Date:   Tue, 12 Oct 2021 11:10:21 +0000
From:   Yanling Song <songyl@ramaxel.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <songyl@ramaxel.com>
Subject: Re: [PATCH] spraid: initial commit of Ramaxel spraid driver
Message-ID: <20211012111021.5efd1b67@songyl>
In-Reply-To: <af2fa285-aa9e-72de-0f19-b3a054678ee0@acm.org>
References: <20210930034752.248781-1-songyl@ramaxel.com>
        <526271c5-a745-7666-6b18-9eb61898f1db@acm.org>
        <20211009133207.789ad116@songyl>
        <52ee4617-93ba-919f-b990-f04f64a13d4b@acm.org>
        <20211011083435.6e24a2e8@songyl>
        <af2fa285-aa9e-72de-0f19-b3a054678ee0@acm.org>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.64.10.54]
X-ClientProxiedBy: V12DG1MBS03.ramaxel.local (172.26.18.33) To
 V12DG1MBS01.ramaxel.local (172.26.18.31)
X-DNSRBL: 
X-MAIL: VLXDG1SPAM1.ramaxel.com 19CBAMI9031475
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 11 Oct 2021 12:40:05 -0700
Bart Van Assche <bvanassche@acm.org> wrote:

> On 10/11/21 01:34, Yanling Song wrote:
> > get_unaligned_be*() is an inline which has the same function as our
> > current code and there is no difference on performance.
> > But current code is better when supporting old kernels since it is
> > implemented on SCSI spec and there is no dependency on
> > get_unaligned_be*(), which means the code can work on any version
> > of kernel.
> > So I prefer to keep current implementation. What's your opinion?  
> 
> Hi Yanling,
> 
> On all architectures I'm familiar with get_unaligned_be*() is faster 
> than fetching individual bytes and combining these with shift 
> operations. As an example, x86 CPU's support unaligned memory
> accesses and for these CPU's the Linux kernel translates
> get_unaligned_be*() into a single (potentially unaligned) memory
> access.
> 
> Kernel drivers that are submitted for upstream inclusion should use
> the upstream kernel API. Whether or not get_unaligned_be*() is
> available in older kernels does not matter - since it is available in
> the upstream kernel and since it makes code faster and easier to
> read, using that function is strongly recommended. Additionally, it
> can happen that after a driver has been accepted upstream that
> someone writes a Coccinelle script to change all open-coded
> get_unaligned_be*() calls into get_unaligned_be*() calls.
> Compatibility with older kernels would not be accepted as a valid
> argument against such a patch.
> 
> I think that get_unaligned_be*() functions are supported since kernel 
> version 2.6.26, released in 2008, 13 years ago. Does this address
> your concern about supporting older kernel versions?

Ok. Will used get_unaligned_be*() functions in the next verison.
> 
> Regarding supporting older kernel versions, a common approach is to 
> develop against the latest upstream kernel. To support older kernels, 
> include a header file called e.g. backport.h and in that header file 
> implement the latest kernel API in terms of older kernel functions.
> An example:
> 
> #if LINUX_VERSION_CODE < KERNEL_VERSION(4, 14, 0) &&	\
> 	!defined(CONFIG_SUSE_KERNEL)
> static inline void bio_set_dev(struct bio *bio,
>                                 struct block_device *bdev)
> {
> 	bio->bi_bdev = bdev;
> }
> #endif

Thanks. I'll use this way when supporting older kernel.

> 
> Bart.

