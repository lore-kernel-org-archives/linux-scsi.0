Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC38AC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Nov 2022 00:39:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbiKPAjK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Nov 2022 19:39:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbiKPAjI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2022 19:39:08 -0500
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA852C65C
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 16:39:07 -0800 (PST)
Received: by mail-qk1-x72b.google.com with SMTP id k4so10706291qkj.8
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 16:39:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=E6Qu6PSxFmyYnw9j3WwIRMzL2Lo6mP5AiWrLkdP0tvA=;
        b=mJCdMjfOOZTl9pLfygIn+el0GZ9pYq93hrXVtHtbMpgvxw4afbg7wl9MI1WWOs/QLE
         Hyyq4qSkOjRF9Faah6tbNQWY3JpCsN7ckorF7HazQagz5NLS27LaUQ6TbDxhHJpMWDaS
         sX9r7pBQV95a/ypRkFnfFHytuiupjlynuLvs34zrQHgkP0/X32HA4zUGqMnxihvGY2f+
         v2tUujXglSwoaOYQRLgzMomn3cMmjakLKKJ2dr5ajLgFrKnjNk/a4APcwdt/VNgwhbCf
         0EJLN71mZBJrAqseB1V3h9iHBnabFlFupTnaHLvUbxpvCmsuj0SqaLeaTxC6cO2XM/kC
         511Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E6Qu6PSxFmyYnw9j3WwIRMzL2Lo6mP5AiWrLkdP0tvA=;
        b=MzzbCgwBbetAsDBKYPYBsUURffNMJWaRm1FYyyxU5nhYUv9Yjj/g55fwvXyJSC0LDT
         8/pXIMtVjVwHDLYZmG99MI4tTIYSfReXOc1mzpW1rxPtp8rW/8sQDnvsWamUlakveigp
         9jsRtf6esJUzfkX5DvvDBcF3mpVGkggVYa/r50j/0Ai/1S9Yzj/iDtZDYQE06MLchdDR
         aI6fQ2hMAeVXYtX6Ca5e6pcbnzdOKLidq4pX05kfd33WoQDWQQXbs8LjEG30LdXufnOo
         1BzdoMxexg2gyhzga/pzosI4725VVWL3pM4yl8ga6RhKZn9NXorgwGn0wTTtJT/uJhFd
         Sg2g==
X-Gm-Message-State: ANoB5pkRMdagDoullGs02I4QlDv68ZHkqff5X7gcv0dR+lhb/X/goLHK
        /K1CHRQd6/jvq8Hkj0IEhQHV2buCIdPNgA==
X-Google-Smtp-Source: AA0mqf4x0hP4AGsqYcihjwGzaO5V35peTevI8VP+3y8RPIcOqbsmDivSRU9GLpgRIlBMbV8jOky+7g==
X-Received: by 2002:a37:683:0:b0:6fb:a2e2:f504 with SMTP id 125-20020a370683000000b006fba2e2f504mr3523947qkg.632.1668559146238;
        Tue, 15 Nov 2022 16:39:06 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id w21-20020ac843d5000000b0039c72bb51f3sm7846611qtn.86.2022.11.15.16.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 16:39:05 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1ov6SH-005FGh-49;
        Tue, 15 Nov 2022 20:39:05 -0400
Date:   Tue, 15 Nov 2022 20:39:05 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, bvanassche@acm.org,
        bostroesser@gmail.com
Subject: Re: [PATCH v2 1/5] sgl_alloc_order: remove 4 GiB limit
Message-ID: <Y3QxKaDxAANwQVQf@ziepe.ca>
References: <20221112194939.4823-1-dgilbert@interlog.com>
 <20221112194939.4823-2-dgilbert@interlog.com>
 <Y3P3p1XqxisASnQt@ziepe.ca>
 <844d8e7e-614f-105b-3b33-e471a1bb24d1@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <844d8e7e-614f-105b-3b33-e471a1bb24d1@interlog.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 15, 2022 at 07:20:13PM -0500, Douglas Gilbert wrote:
> On 2022-11-15 15:33, Jason Gunthorpe wrote:
> > On Sat, Nov 12, 2022 at 02:49:35PM -0500, Douglas Gilbert wrote:
> > > This patch fixes a check done by sgl_alloc_order() before it starts
> > > any allocations. The comment in the original said: "Check for integer
> > > overflow" but the right hand side of the expression in the condition
> > > is resolved as u32 so it can not exceed UINT32_MAX (4 GiB) which
> > > means 'length' can not exceed that value.
> > > 
> > > This function may be used to replace vmalloc(unsigned long) for a
> > > large allocation (e.g. a ramdisk). vmalloc has no limit at 4 GiB so
> > > it seems unreasonable that sgl_alloc_order() whose length type is
> > > unsigned long long should be limited to 4 GB.
> > > 
> > > Solutions to this issue were discussed by Jason Gunthorpe
> > > <jgg@ziepe.ca> and Bodo Stroesser <bostroesser@gmail.com>. This
> > > version is base on a linux-scsi post by Jason titled: "Re:
> > > [PATCH v7 1/4] sgl_alloc_order: remove 4 GiB limit" dated 20220201.
> > > 
> > > An earlier patch fixed a memory leak in sg_alloc_order() due to the
> > > misuse of sgl_free(). Take the opportunity to put a one line comment
> > > above sgl_free()'s declaration warning that it is not suitable when
> > > order > 0 .
> > > 
> > > Cc: Jason Gunthorpe <jgg@ziepe.ca>
> > > Cc: Bodo Stroesser <bostroesser@gmail.com>
> > > Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> > > ---
> > >   include/linux/scatterlist.h |  1 +
> > >   lib/scatterlist.c           | 23 ++++++++++++++---------
> > >   2 files changed, 15 insertions(+), 9 deletions(-)
> > 
> > I still prefer the version I posted here:
> > 
> > https://lore.kernel.org/linux-scsi/Y1aDQznakNaWD8kd@ziepe.ca/
> 
> Three reasons that I don't:
>   1) making the first argument of type size_t may constrict the size
>      that can be allocated on a 32 bit machine (faint recollection of
>      extended/expanded memory on 8086). uint64_t would be better
>      than unsigned long long but see point 3)

32 bit machines can't kmap more than size_t - so this is not
correct. We can't put sgl tables into highmem.

>   2) making the last (fifth) argument of type size_t is overkill on a
>      64 bit machine. IMO 32 bits is sufficient. 

IIRC, I changed it to obviously avoid integer promotion/truncation
issues. It is better to handle those with correct typing than
introducing a bunch of frail checks. We don't need to worry about the
extra 32 bits in something like this.

>   3) it changes the signature of an existing exported kernel function
>      requiring changes in several call sites. 

So fix them. It is why we have one git tree. You'll get sympathy if it
is more than 5-10 :)

>      type may require more than a one line change at the existing call
>      sites. Due to the fact that this patch is removing an existing
>      4 GB limit, those call sites have zero need for this. If I was
>      maintaining the driver containing those call sites, I would be
>      a bit peeved.

Uh, if someone is "peeved" they are not understanding how kernel APIs
are expected to evolve, I think.

It should be two patches, one to correct the types in the function
signature, and another to resolve the 4G problem.

>     [That said, maintaining out-of-tree patchsets, while
>      trying to get them accepted in the mainline, is a considerable
>      pain due to the constant changes in the block layer API.]

Which is consistent with how the community views in-kernel APIs.

Jason
