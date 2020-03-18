Return-Path: <SRS0=JOtj=5D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B53B2C10DCE
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Mar 2020 06:53:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DDBA2076C
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Mar 2020 06:53:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Wf1Xi31S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbgCRGxJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Mar 2020 02:53:09 -0400
Received: from mail-qv1-f66.google.com ([209.85.219.66]:34948 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727004AbgCRGxI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Mar 2020 02:53:08 -0400
Received: by mail-qv1-f66.google.com with SMTP id q73so2897659qvq.2
        for <linux-scsi@vger.kernel.org>; Tue, 17 Mar 2020 23:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WzwK1BObMe5QMhBnmi4AcZZcP1CODxNL9nxwEfiMr0g=;
        b=Wf1Xi31Sw55Mx8Qt35MG7CT5SeFtcPwIUMB8t9bMZc3toaq8slbJX8xQo/EJAFQPyJ
         fitU2zOY1RnYn3xIl/A2gKYwPNWzH4lTvp981B7Q3GcrIfC3chezzTz8Fm1UDnfDcaH9
         I5cDLbJ+8Sn0VtHDWsEzYwf7XpvbE9EAnjGQU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WzwK1BObMe5QMhBnmi4AcZZcP1CODxNL9nxwEfiMr0g=;
        b=B5E8chM8itShuCKl2KH0aqLGzRmgnI4aaP3wcxI/q4FAojFlcJP8sjDV7nX7/6/8Ay
         fBxrRkSTQ9HBpqZvTgKrS+20Dufa3YtcgYtepGg8/kM4Q5YlDcoHMR/5B1RPOFI+wfNj
         V9EBgmKp8oe1kazT0AefCexZvOizjh/2c+7JjvSvVF5ozp0FYEYRXLl0XbdcS7N6OVAJ
         FEsnQ1EesyCYcU+jlhlQtYIpvPG2zNOYn4CiUCWXS2E4B+QxBCVEB3gZ1fkZMbkjNW4T
         IH1euIFF/OwXmYvvo2645bNsg1LEZCnAChx/kINzruK5ojPQghDURmc3uC+2xNqAIvpz
         NLSQ==
X-Gm-Message-State: ANhLgQ2E+b0IpkZgTqaUXmSGh/IpUy+oZE4soHo/VQqQ44VumSXie4n/
        EAwLGRbiKxmS6eM+qwxgsQPEe7AdwUbVDC/CQRcpCg==
X-Google-Smtp-Source: ADFU+vueNnvjLRNtiqr4Q5BQ5BkEVUejXGBfmaYsn/LoB1bwU4HLlMoOF9pfAfLxR+b3CclP6JkCcv3vJTO7PZXAWIU=
X-Received: by 2002:ad4:4421:: with SMTP id e1mr2607486qvt.193.1584514387552;
 Tue, 17 Mar 2020 23:53:07 -0700 (PDT)
MIME-Version: 1.0
References: <1581416293-41610-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1581416293-41610-5-git-send-email-suganath-prabu.subramani@broadcom.com>
 <20200225184202.GC6261@infradead.org> <CAK=zhgoR0k+eoEMNznMGCF21eQMKT2UJ5vufCho4dXfHNFFV3g@mail.gmail.com>
 <CAK=zhgpXF=qcwhwpzsx44GDEJxFXLcZFSgO9cAXL8p2GjU0KoQ@mail.gmail.com> <CA+RiK67RquZitjQrh=yGcdunAOZaOhS90xGk3Mco2rm-ZHrEYA@mail.gmail.com>
In-Reply-To: <CA+RiK67RquZitjQrh=yGcdunAOZaOhS90xGk3Mco2rm-ZHrEYA@mail.gmail.com>
From:   Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Date:   Wed, 18 Mar 2020 12:23:59 +0530
Message-ID: <CA+RiK66=-8fqjvQPO1tX-P-G7cpuCmFSxOsb95MnkL4CueB9PA@mail.gmail.com>
Subject: Re: [PATCH 4/5] mpt3sas: Handle RDPQ DMA allocation in same 4g region
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Christoph,

We will simplify the logic as below, let us know your comments.

#use one dma pool for RDPQ's, thus removes the logic of using second
dma pool with align.
The requirement is, RDPQ memory blocks starting & end address should
have the same
higher 32 bit address.

1) At driver load, set DMA Mask to 64 and allocate memory for RDPQ's.

2) Check if allocated resources are in the same 4GB range.

3) If #2 is true, continue with 64 bit DMA and go to #6

4) If #2 is false, then free all the resources from #1.

5) Set DMA mask to 32 and allocate RDPQ's.

6) Proceed with driver loading and other allocations.

Thanks,
Suganath


On Wed, Mar 18, 2020 at 12:21 PM Suganath Prabu Subramani
<suganath-prabu.subramani@broadcom.com> wrote:
>
> Hi Christoph,
>
> We will simplify the logic as below, let us know your comments.
>
> #use one dma pool for RDPQ's, thus removes the logic of using second dma pool with align.
> The requirement is, RDPQ memory blocks starting & end address should have the same
> higher 32 bit address.
>
> 1) At driver load, set DMA Mask to 64 and allocate memory for RDPQ's.
>
> 2) Check if allocated resources are in the same 4GB range.
>
> 3) If #2 is true, continue with 64 bit DMA and go to #6
>
> 4) If #2 is false, then free all the resources from #1.
>
> 5) Set DMA mask to 32 and allocate RDPQ's.
>
> 6) Proceed with driver loading and other allocations.
>
> Thanks,
> Suganath
>
> On Thu, Mar 5, 2020 at 2:40 PM Sreekanth Reddy <sreekanth.reddy@broadcom.com> wrote:
>>
>> Hi,
>>
>> Any update over my previous reply?
>>
>> Thanks,
>> Sreekanth
>>
>> On Thu, Feb 27, 2020 at 6:11 PM Sreekanth Reddy
>> <sreekanth.reddy@broadcom.com> wrote:
>> >
>> > On Wed, Feb 26, 2020 at 12:12 AM Christoph Hellwig <hch@infradead.org> wrote:
>> > >
>> > > On Tue, Feb 11, 2020 at 05:18:12AM -0500, suganath-prabu.subramani@broadcom.com wrote:
>> > > > From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
>> > > >
>> > > > For INVADER_SERIES each set of 8 reply queues (0 - 7, 8 - 15,..)and
>> > > > VENTURA_SERIES each set of 16 reply queues (0 - 15, 16 - 31,..)should
>> > > > be within 4 GB boundary.Driver uses limitation of VENTURA_SERIES
>> > > > to manage INVADER_SERIES as well. So here driver is allocating the DMA
>> > > > able memory for RDPQ's accordingly.
>> > > >
>> > > > For RDPQ buffers, driver creates two separate pci pool.
>> > > > "reply_post_free_dma_pool" and "reply_post_free_dma_pool_align"
>> > > > First driver tries allocating memory from the pool
>> > > > "reply_post_free_dma_pool", if the requested allocation are
>> > > > within same 4gb region then proceeds for next allocations.
>> > > > If not, allocates from reply_post_free_dma_pool_align which is
>> > > > size aligned and if success, it will always meet same 4gb region
>> > > > requirement
>> > >
>> > > I don't fully understand the changelog here, and how having two
>> > > dma pools including one aligned is all that good.
>> >
>> > The requirement is that driver needs a set of memory blocks of size
>> > ~106 KB and this block should not cross the 4gb boundary (i.e.
>> > starting & end address of this block should have the same higher 32
>> > bit address). So what we are doing is that first we allocate a block
>> > from generic pool 'reply_post_free_dma_pool' and we check whether this
>> > block cross the 4gb boundary or not, if it is yes then we free this
>> > block and we try to allocate block once gain from pool
>> > 'reply_post_free_dma_pool_align' where we alignment of this pool is
>> > set to power of two from block size. Hoping that second time
>> > allocation block will not cross the 4 gb boundary.
>> >
>> > Is there any interface or API which make sures that it always
>> > allocates the required size memory block and also satisfies 4bg
>> > boundary condtion?
>> >
>> > >
>> > > Why not do a single dma_alloc_coherent and then subdvide it given
>> > > that all the allocations from the DMA pool seem to happen at HBA
>> > > initialization time anyway, invalidating the need for the dynamic
>> > > nature of the dma pools.
>> >
>> > we need 8 blocks of block size ~106 KB, so total will be ~848 KB and
>> > most of the times we may not get this much size continuous single
>> > block memory and also this block should satisfy the 4gb boundary
>> > requirement. And hence driver is allocating each block individually.
>> >
>> > Regards,
>> > Sreekanth
