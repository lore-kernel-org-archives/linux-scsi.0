Return-Path: <SRS0=0D1w=7E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24D55C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 22 May 2020 05:57:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E299F20757
	for <linux-scsi@archiver.kernel.org>; Fri, 22 May 2020 05:57:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="b8eCb9ON"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgEVF5O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 May 2020 01:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgEVF5O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2020 01:57:14 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C1BC061A0E
        for <linux-scsi@vger.kernel.org>; Thu, 21 May 2020 22:57:14 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id i22so8351270oik.10
        for <linux-scsi@vger.kernel.org>; Thu, 21 May 2020 22:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uiPMC6weLFsKpguoy019Xlq+o6RhjhuoAEUtsjBzwoY=;
        b=b8eCb9ONoZZE+HbBI1Mhu9mcEOuLNyfx3b5axShiqisTMDMI1NvbwO3XUjEyMVAqYe
         HP3Ax94luInpdTi8LrGAoFZkhU5LEbC9RgIMxiHw/2I6Lb15Z4NMgYfScpmQJ5UNjxA8
         MBhfAqrzvAy/FqtZWAGumtA57l91DCpQ2EjNU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uiPMC6weLFsKpguoy019Xlq+o6RhjhuoAEUtsjBzwoY=;
        b=SHl9rtbgqtnw4l7/9sjPP7QptKtdEkbvUYI0fbe9ICCe3PqssSJBJu8yTDasKiOruo
         9dSoHaPd7l+VKtib0Mn74hpgj9u6aJRelALJolR6KlxRr36qMwBs+2q3svcpXZbnHZ1I
         F5YyOrl/bIHVga7PgI9z59YsKXJh8EQBIXfkl0daP9uzzdYOE7UqMPFJf8y/KP5sz3FP
         V6VuHoSAGWZhZ9rHOH+qjVH+ZclNGvZRnn7oLHz1yZMUvg1Ifp9Hy8u31s/MxQNYDd+K
         t8pTnKnKDqiZwEr1vRjZr7LffD3fa9jWulPZrTDxdH9KSphECkCHdlMo2+1lqdMf/ovh
         0UUQ==
X-Gm-Message-State: AOAM533HfR846Vm+3Z8o7IzYk63WJSlADxEFuZKTCK/R9fxhvlL3wiVj
        iKp7gbZDioFQSzatGIRNl7BMzw/dR9yOlO9uUFGlJw==
X-Google-Smtp-Source: ABdhPJw6LPMiKNOOiDyV9AA22hLHV+4sVM/k7gjwvd7YwtmVqOgo1u5JTxx/ImRHbBSEs3ghjUDQr6dvzujHi8CkJiM=
X-Received: by 2002:aca:5243:: with SMTP id g64mr1499432oib.90.1590127033163;
 Thu, 21 May 2020 22:57:13 -0700 (PDT)
MIME-Version: 1.0
References: <1587626596-1044-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1587626596-1044-5-git-send-email-suganath-prabu.subramani@broadcom.com> <3849d23c-8af5-7427-2f56-7c78d996d1c2@redhat.com>
In-Reply-To: <3849d23c-8af5-7427-2f56-7c78d996d1c2@redhat.com>
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Date:   Fri, 22 May 2020 11:27:02 +0530
Message-ID: <CAK=zhgoEjYUwhKLH=-iqp7WS0H7FfoFOk9Uapm+6=KU19yNz7A@mail.gmail.com>
Subject: Re: [v2 4/5] mpt3sas: Handle RDPQ DMA allocation in same 4G region
To:     Tomas Henzl <thenzl@redhat.com>
Cc:     Suganath Prabu <suganath-prabu.subramani@broadcom.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Sathya Prakash Veerichetty <Sathya.Prakash@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, May 21, 2020 at 8:42 PM Tomas Henzl <thenzl@redhat.com> wrote:
>
> On 4/23/20 9:23 AM, Suganath Prabu wrote:
> > For INVADER_SERIES each set of 8 reply queues (0 - 7, 8 - 15,..) and
> > VENTURA_SERIES each set of 16 reply queues (0 - 15, 16 - 31,..) should
> > be within 4 GB boundary. Driver uses limitation of VENTURA_SERIES to
> > manage INVADER_SERIES as well. So here driver is allocating the DMA able
> > memory for RDPQ's accordingly.
> >
> > 1) At driver load, set DMA Mask to 64 and allocate memory for RDPQ's.
> > 2) Check if allocated resources for RDPQ are in the same 4GB range.
> > 3) If #2 is true, continue with 64 bit DMA and go to #6
> > 4) If #2 is false, then free all the resources from #1.
> > 5) Set DMA mask to 32 and allocate RDPQ's.
> > 6) Proceed with driver loading and other allocations
> > ---
> > v1 Change log:
> > 1) Use one dma pool for RDPQ's, thus removes the logic of using second
> > dma pool with align.
> > v2 Change log:
> > Added flag use_32bit_dma. If this flag is true, 32 bit coharent
> > dma is used.
> >
> > Signed-off-by: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  drivers/scsi/mpt3sas/mpt3sas_base.c | 152 +++++++++++++++++++++++++-----------
> >  drivers/scsi/mpt3sas/mpt3sas_base.h |   3 +
> >  2 files changed, 109 insertions(+), 46 deletions(-)
> >
> > diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> > index 0588941..af30e74 100644
> > --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> > +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> > @@ -2810,7 +2810,7 @@ _base_config_dma_addressing(struct MPT3SAS_ADAPTER *ioc, struct pci_dev *pdev)
> >       int dma_mask;
> >
> >       if (ioc->is_mcpu_endpoint ||
> > -         sizeof(dma_addr_t) == 4 ||
> > +         sizeof(dma_addr_t) == 4 || ioc->use_32bit_dma ||
> >           dma_get_required_mask(&pdev->dev) <= 32)
> >               dma_mask = 32;
> >       /* Set 63 bit DMA mask for all SAS3 and SAS35 controllers */
> > @@ -4807,8 +4807,8 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
> >  {
> >       int i = 0;
> >       int j = 0;
> > +     int dma_alloc_count = 0;
> >       struct chain_tracker *ct;
> > -     struct reply_post_struct *rps;
> >
> >       dexitprintk(ioc, ioc_info(ioc, "%s\n", __func__));
> >
> > @@ -4850,29 +4850,34 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
> >       }
> >
> >       if (ioc->reply_post) {
> > -             do {
> > -                     rps = &ioc->reply_post[i];
> > -                     if (rps->reply_post_free) {
> > -                             dma_pool_free(
> > -                                 ioc->reply_post_free_dma_pool,
> > -                                 rps->reply_post_free,
> > -                                 rps->reply_post_free_dma);
> > -                             dexitprintk(ioc,
> > -                                         ioc_info(ioc, "reply_post_free_pool(0x%p): free\n",
> > -                                                  rps->reply_post_free));
> > -                             rps->reply_post_free = NULL;
> > +             dma_alloc_count = DIV_ROUND_UP(ioc->reply_queue_count,
> > +                             RDPQ_MAX_INDEX_IN_ONE_CHUNK);
> > +             for (i = 0; i < ioc->reply_queue_count; i++) {
> > +                     if (i % RDPQ_MAX_INDEX_IN_ONE_CHUNK == 0
> > +                         && dma_alloc_count) {
> > +                             if (ioc->reply_post[i].reply_post_free) {
> > +                                     dma_pool_free(
> > +                                         ioc->reply_post_free_dma_pool,
> > +                                         ioc->reply_post[i].reply_post_free,
> > +                                     ioc->reply_post[i].reply_post_free_dma);
> > +                                     dexitprintk(ioc, ioc_info(ioc,
> > +                                        "reply_post_free_pool(0x%p): free\n",
> > +                                        ioc->reply_post[i].reply_post_free));
> > +                                     ioc->reply_post[i].reply_post_free =
> > +                                                                     NULL;
> > +                             }
> > +                             --dma_alloc_count;
> >                       }
> > -             } while (ioc->rdpq_array_enable &&
> > -                        (++i < ioc->reply_queue_count));
> > +             }
> > +             dma_pool_destroy(ioc->reply_post_free_dma_pool);
> >               if (ioc->reply_post_free_array &&
> >                       ioc->rdpq_array_enable) {
> >                       dma_pool_free(ioc->reply_post_free_array_dma_pool,
> > -                             ioc->reply_post_free_array,
> > -                             ioc->reply_post_free_array_dma);
> > +                         ioc->reply_post_free_array,
> > +                         ioc->reply_post_free_array_dma);
> >                       ioc->reply_post_free_array = NULL;
> >               }
> >               dma_pool_destroy(ioc->reply_post_free_array_dma_pool);
> > -             dma_pool_destroy(ioc->reply_post_free_dma_pool);
> >               kfree(ioc->reply_post);
> >       }
> >
> > @@ -4948,36 +4953,75 @@ mpt3sas_check_same_4gb_region(long reply_pool_start_address, u32 pool_sz)
> >  static int
> >  base_alloc_rdpq_dma_pool(struct MPT3SAS_ADAPTER *ioc, int sz)
> >  {
> > -     int i;
> > +     int i = 0;
> > +     u32 dma_alloc_count = 0;
> > +     int reply_post_free_sz = ioc->reply_post_queue_depth *
> > +             sizeof(Mpi2DefaultReplyDescriptor_t);
> >       int count = ioc->rdpq_array_enable ? ioc->reply_queue_count : 1;
> >
> >       ioc->reply_post = kcalloc(count, sizeof(struct reply_post_struct),
> >                       GFP_KERNEL);
> >       if (!ioc->reply_post)
> >               return -ENOMEM;
> > +     /*
> > +      *  For INVADER_SERIES each set of 8 reply queues(0-7, 8-15, ..) and
> > +      *  VENTURA_SERIES each set of 16 reply queues(0-15, 16-31, ..) should
> > +      *  be within 4GB boundary i.e reply queues in a set must have same
> > +      *  upper 32-bits in their memory address. so here driver is allocating
> > +      *  the DMA'able memory for reply queues according.
> > +      *  Driver uses limitation of
> > +      *  VENTURA_SERIES to manage INVADER_SERIES as well.
> > +      */
> > +     dma_alloc_count = DIV_ROUND_UP(ioc->reply_queue_count,
> > +                             RDPQ_MAX_INDEX_IN_ONE_CHUNK);
> >       ioc->reply_post_free_dma_pool =
> > -         dma_pool_create("reply_post_free pool",
> > -         &ioc->pdev->dev, sz, 16, 0);
> > +             dma_pool_create("reply_post_free pool",
> > +                 &ioc->pdev->dev, sz, 16, 0);
> >       if (!ioc->reply_post_free_dma_pool)
> >               return -ENOMEM;
> > -     i = 0;
> > -     do {
> > -             ioc->reply_post[i].reply_post_free =
> > -                 dma_pool_zalloc(ioc->reply_post_free_dma_pool,
> > -                 GFP_KERNEL,
> > -                 &ioc->reply_post[i].reply_post_free_dma);
> > -             if (!ioc->reply_post[i].reply_post_free)
> > -                     return -ENOMEM;
> > -             dinitprintk(ioc,
> > -                     ioc_info(ioc, "reply post free pool (0x%p): depth(%d),"
> > -                         "element_size(%d), pool_size(%d kB)\n",
> > -                         ioc->reply_post[i].reply_post_free,
> > -                         ioc->reply_post_queue_depth, 8, sz / 1024));
> > -             dinitprintk(ioc,
> > -                     ioc_info(ioc, "reply_post_free_dma = (0x%llx)\n",
> > -                         (u64)ioc->reply_post[i].reply_post_free_dma));
> > +     for (i = 0; i < ioc->reply_queue_count; i++) {
> > +             if ((i % RDPQ_MAX_INDEX_IN_ONE_CHUNK == 0) && dma_alloc_count) {
> > +                     ioc->reply_post[i].reply_post_free =
> ioc->reply_post is allocated with 'count' size, which may be smaller
> than ioc->reply_queue_count
> Probably this causes some older systems to not boot.
> The problem should be fixed before it comes to mainline.
>
> Cheers,
> tomash

Tomash, thanks for identifying this bug. We will post the fix patch today.

Thanks,
Sreekanth

>
>
> > +                         dma_pool_alloc(ioc->reply_post_free_dma_pool,
> > +                             GFP_KERNEL,
> > +                             &ioc->reply_post[i].reply_post_free_dma);
> > +                     if (!ioc->reply_post[i].reply_post_free)
> > +                             return -ENOMEM;
> > +                     /*
> > +                      * Each set of RDPQ pool must satisfy 4gb boundary
> > +                      * restriction.
> > +                      * 1) Check if allocated resources for RDPQ pool are in
> > +                      *      the same 4GB range.
> > +                      * 2) If #1 is true, continue with 64 bit DMA.
> > +                      * 3) If #1 is false, return 1. which means free all the
> > +                      * resources and set DMA mask to 32 and allocate.
> > +                      */
> > +                     if (!mpt3sas_check_same_4gb_region(
> > +                             (long)ioc->reply_post[i].reply_post_free, sz)) {
> > +                             dinitprintk(ioc,
> > +                                 ioc_err(ioc, "bad Replypost free pool(0x%p)"
> > +                                 "reply_post_free_dma = (0x%llx)\n",
> > +                                 ioc->reply_post[i].reply_post_free,
> > +                                 (unsigned long long)
> > +                                 ioc->reply_post[i].reply_post_free_dma));
> > +                             return -EAGAIN;
> > +                     }
> > +                     memset(ioc->reply_post[i].reply_post_free, 0,
> > +                                             RDPQ_MAX_INDEX_IN_ONE_CHUNK *
> > +                                             reply_post_free_sz);
> > +                     dma_alloc_count--;
> >
> > -     } while (ioc->rdpq_array_enable && ++i < ioc->reply_queue_count);
> > +             } else {
> > +                     ioc->reply_post[i].reply_post_free =
> > +                         (Mpi2ReplyDescriptorsUnion_t *)
> > +                         ((long)ioc->reply_post[i-1].reply_post_free
> > +                         + reply_post_free_sz);
> > +                     ioc->reply_post[i].reply_post_free_dma =
> > +                         (dma_addr_t)
> > +                         (ioc->reply_post[i-1].reply_post_free_dma +
> > +                         reply_post_free_sz);
> > +             }
> > +     }
> >       return 0;
> >  }
> >
> > @@ -4995,10 +5039,12 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
> >       u16 chains_needed_per_io;
> >       u32 sz, total_sz, reply_post_free_sz, reply_post_free_array_sz;
> >       u32 retry_sz;
> > +     u32 rdpq_sz = 0;
> >       u16 max_request_credit, nvme_blocks_needed;
> >       unsigned short sg_tablesize;
> >       u16 sge_size;
> >       int i, j;
> > +     int ret = 0;
> >       struct chain_tracker *ct;
> >
> >       dinitprintk(ioc, ioc_info(ioc, "%s\n", __func__));
> > @@ -5152,14 +5198,28 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
> >       /* reply post queue, 16 byte align */
> >       reply_post_free_sz = ioc->reply_post_queue_depth *
> >           sizeof(Mpi2DefaultReplyDescriptor_t);
> > -
> > -     sz = reply_post_free_sz;
> > +     rdpq_sz = reply_post_free_sz * RDPQ_MAX_INDEX_IN_ONE_CHUNK;
> >       if (_base_is_controller_msix_enabled(ioc) && !ioc->rdpq_array_enable)
> > -             sz *= ioc->reply_queue_count;
> > -     if (base_alloc_rdpq_dma_pool(ioc, sz))
> > -             goto out;
> > -     total_sz += sz * (!ioc->rdpq_array_enable ? 1 : ioc->reply_queue_count);
> > -
> > +             rdpq_sz = reply_post_free_sz * ioc->reply_queue_count;
> > +     ret = base_alloc_rdpq_dma_pool(ioc, rdpq_sz);
> > +     if (ret == -EAGAIN) {
> > +             /*
> > +              * Free allocated bad RDPQ memory pools.
> > +              * Change dma coherent mask to 32 bit and reallocate RDPQ
> > +              */
> > +             _base_release_memory_pools(ioc);
> > +             ioc->use_32bit_dma = true;
> > +             if (_base_config_dma_addressing(ioc, ioc->pdev) != 0) {
> > +                     ioc_err(ioc,
> > +                         "32 DMA mask failed %s\n", pci_name(ioc->pdev));
> > +                     return -ENODEV;
> > +             }
> > +             if (base_alloc_rdpq_dma_pool(ioc, rdpq_sz))
> > +                     return -ENOMEM;
> > +     } else if (ret == -ENOMEM)
> > +             return -ENOMEM;
> > +     total_sz = rdpq_sz * (!ioc->rdpq_array_enable ? 1 :
> > +         DIV_ROUND_UP(ioc->reply_queue_count, RDPQ_MAX_INDEX_IN_ONE_CHUNK));
> >       ioc->scsiio_depth = ioc->hba_queue_depth -
> >           ioc->hi_priority_depth - ioc->internal_depth;
> >
> > @@ -5171,7 +5231,6 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
> >                   ioc_info(ioc, "scsi host: can_queue depth (%d)\n",
> >                            ioc->shost->can_queue));
> >
> > -
> >       /* contiguous pool for request and chains, 16 byte align, one extra "
> >        * "frame for smid=0
> >        */
> > @@ -7141,6 +7200,7 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
> >       ioc->smp_affinity_enable = smp_affinity_enable;
> >
> >       ioc->rdpq_array_enable_assigned = 0;
> > +     ioc->use_32bit_dma = 0;
> >       if (ioc->is_aero_ioc)
> >               ioc->base_readl = &_base_readl_aero;
> >       else
> > diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
> > index caae040..5a83971 100644
> > --- a/drivers/scsi/mpt3sas/mpt3sas_base.h
> > +++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
> > @@ -367,6 +367,7 @@ struct mpt3sas_nvme_cmd {
> >  #define MPT3SAS_HIGH_IOPS_REPLY_QUEUES               8
> >  #define MPT3SAS_HIGH_IOPS_BATCH_COUNT                16
> >  #define MPT3SAS_GEN35_MAX_MSIX_QUEUES                128
> > +#define RDPQ_MAX_INDEX_IN_ONE_CHUNK          16
> >
> >  /* OEM Specific Flags will come from OEM specific header files */
> >  struct Mpi2ManufacturingPage10_t {
> > @@ -1063,6 +1064,7 @@ typedef void (*MPT3SAS_FLUSH_RUNNING_CMDS)(struct MPT3SAS_ADAPTER *ioc);
> >   * @thresh_hold: Max number of reply descriptors processed
> >   *                           before updating Host Index
> >   * @drv_support_bitmap: driver's supported feature bit map
> > + * @use_32bit_dma: Flag to use 32 bit consistent dma mask
> >   * @scsi_io_cb_idx: shost generated commands
> >   * @tm_cb_idx: task management commands
> >   * @scsih_cb_idx: scsih internal commands
> > @@ -1252,6 +1254,7 @@ struct MPT3SAS_ADAPTER {
> >       u8              high_iops_queues;
> >       u32             drv_support_bitmap;
> >       bool            enable_sdev_max_qd;
> > +     bool            use_32bit_dma;
> >
> >       /* internal commands, callback index */
> >       u8              scsi_io_cb_idx;
> >
>
