Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27922C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 23:07:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E656664EF6
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 23:07:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbhCRXGv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 19:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbhCRXGd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 19:06:33 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7DDCC06175F
        for <linux-scsi@vger.kernel.org>; Thu, 18 Mar 2021 16:06:32 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id i81so1297467oif.6
        for <linux-scsi@vger.kernel.org>; Thu, 18 Mar 2021 16:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gFvbKoTbbtISsQgZesBGqRcM9fA6M7gbO6KnRJFUa1c=;
        b=YlOyVgCRI9TJ0J3Us5cFDJz1VNFTvypleCbdrXGB+xHIqvR7fXorMjOEF0pzeTtJfO
         YUaWp9LhjWJb6Cy0Gm7/qTGgIBF8JOxNE5EEss5na4GnTD0ceXgi6/8qhMF3VBUB1h8Y
         PFTkikmO/n/9S+q3nRwny22rGpyHIUfVvYy80qqFgNbdWSiVz6wU2gBfQeKgwDGaVWNx
         hm6iakR4kk/UFtjVaFyxOS2n729tb1tjEJp5xaCCovHcjxbpiXKHfn6rEprAgWoWWKQO
         z+C4jeCKamNLMLFZF908e8tNtb62HdSMEZY9VjHjAi3mAoKxslPz8yBWaEMEjVSXzkwf
         HNhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gFvbKoTbbtISsQgZesBGqRcM9fA6M7gbO6KnRJFUa1c=;
        b=VAPCks8opKXyJkc5b2Uk8j0A2fi8lb/e6/ZZqlHBGKGri7PWYY4QUN9wopWaPKv10U
         qM47VcebNc0P7wwHEMuN31uc+quMd75Ry/0JmPV/jYVD0N966uS7Wo8wR8poOTF2kKY+
         jRg8Zguem4QAHbb9skVwT7whgolHRHYJzMyU7WCJW2mB+wvXkq3Vw3re7afcLHcUY8Z1
         o2AwsL3jYHwcOm4hpj+chOBFIqTSaEyPSQjC4Lt3y5P/a0AzPZxMRTVTnMkJsKWQ84JZ
         YMelPcRN7LEHxHEZirnnYduS15ZYDOhtRM2bQCD0Yx5gIlIPVi6vxaegSlscAYrqkw8l
         dK9g==
X-Gm-Message-State: AOAM530yDaqr792WqRKcTkjOHzKI63Vf7uMvR44kGD1mIQ4NxQGfEc0D
        E506XWZ/eesdKdcDu+yv2/EXozRRAVJ1FRp4gn4qEQ==
X-Google-Smtp-Source: ABdhPJwdsIuzyRDFEv8Njjjkwsn44HZryMhC/a+R0VAHGnuyeetQ/n698sy1xgOuIPgXL2TnStsbpDtKs4wR83ugXqw=
X-Received: by 2002:aca:47c4:: with SMTP id u187mr4785963oia.136.1616108791883;
 Thu, 18 Mar 2021 16:06:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210316193905.1673600-1-jollys@google.com> <5e2c35b6-a9c4-0637-738b-ff6920635425@huawei.com>
 <CABGCNpDdK2+DNTJpzjig3hX3W_7JB8nEcRcuRnv8Z4oRSq2-dA@mail.gmail.com> <329a6159-7da6-f60d-b1a5-14648b90f052@huawei.com>
In-Reply-To: <329a6159-7da6-f60d-b1a5-14648b90f052@huawei.com>
From:   Jolly Shah <jollys@google.com>
Date:   Thu, 18 Mar 2021 16:06:20 -0700
Message-ID: <CABGCNpDisbWF=fSyKZPfyvR7RgZQeCg-PVxYOUs6PpkagAiMmw@mail.gmail.com>
Subject: Re: [PATCH] scsi: libsas: Reset num_scatter if libata mark qc as NODATA
To:     John Garry <john.garry@huawei.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        a.darwish@linutronix.de, Jason Yan <yanaijie@huawei.com>,
        luojiaxing@huawei.com, dan.carpenter@oracle.com,
        b.zolnierkie@samsung.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi John,


On Thu, Mar 18, 2021 at 9:19 AM John Garry <john.garry@huawei.com> wrote:
>
> On 18/03/2021 00:24, Jolly Shah wrote:
> > Hi John,
> >
> > Thanks for the review.
> >
> >
> > On Wed, Mar 17, 2021 at 4:44 AM John Garry <john.garry@huawei.com> wrote:
> >>
> >> On 16/03/2021 19:39, Jolly Shah wrote:
> >>> When the cache_type for the scsi device is changed, the scsi layer
> >>> issues a MODE_SELECT command. The caching mode details are communicated
> >>> via a request buffer associated with the scsi command with data
> >>> direction set as DMA_TO_DEVICE (scsi_mode_select). When this command
> >>> reaches the libata layer, as a part of generic initial setup, libata
> >>> layer sets up the scatterlist for the command using the scsi command
> >>> (ata_scsi_qc_new). This command is then translated by the libata layer
> >>> into ATA_CMD_SET_FEATURES (ata_scsi_mode_select_xlat). The libata layer
> >>> treats this as a non data command (ata_mselect_caching), since it only
> >>> needs an ata taskfile to pass the caching on/off information to the
> >>> device. It does not need the scatterlist that has been setup, so it does
> >>> not perform dma_map_sg on the scatterlist (ata_qc_issue).
> >>
> >> So if we don't perform the dma_map_sg() on the sgl at this point, then
> >> it seems to me that we should not perform for_each_sg() on it either,
> >> right? That is still what happens in sas_ata_qc_issue() in this case.
> >>
>
> Hi Jolly Shah,
>
> >
> > Yes that's right. To avoid that, I can add elseif block for
> > ATA_PROT_NODATA before for_each_sg() is performed. Currently there's
> > existing code block for ATA_PROT_NODATA after for_each_sg()  is
> > performed,
> > reused that to reset num_scatter. Please suggest.
> >
>
> How about just combine the 2x if-else statements into 1x if-elif-else
> statement, like:
>
>
> if (ata_is_atapi(qc->tf.protocol)) {
>         memcpy(task->ata_task.atapi_packet, qc->cdb, qc->dev->cdb_len);
>         task->total_xfer_len = qc->nbytes;
>         task->num_scatter = qc->n_elem;
>         task->data_dir = qc->dma_dir;
> } else if (qc->tf.protocol == ATA_PROT_NODATA) {
>         task->data_dir = DMA_NONE;
> } else {
>         for_each_sg(qc->sg, sg, qc->n_elem, si)
>                 xfer += sg_dma_len(sg);
>
>         task->total_xfer_len = xfer;
>         task->num_scatter = si;
>         task->data_dir = qc->dma_dir;
> }
>
Updated in v2.

> >>> Unfortunately,
> >>> when this command reaches the libsas layer(sas_ata_qc_issue), libsas
> >>> layer sees it as a non data command with a scatterlist. It cannot
> >>> extract the correct dma length, since the scatterlist has not been
> >>> mapped with dma_map_sg for a DMA operation. When this partially
> >>> constructed SAS task reaches pm80xx LLDD, it results in below warning.
> >>>
> >>> "pm80xx_chip_sata_req 6058: The sg list address
> >>> start_addr=0x0000000000000000 data_len=0x0end_addr_high=0xffffffff
> >>> end_addr_low=0xffffffff has crossed 4G boundary"
> >>>
> >>> This patch assigns appropriate value to  num_sectors for ata non data
> >>> commands.
> >>>
> >>> Signed-off-by: Jolly Shah <jollys@google.com>
> >>> ---
> >>>    drivers/scsi/libsas/sas_ata.c | 6 ++++--
> >>>    1 file changed, 4 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> >>> index 024e5a550759..94ec08cebbaa 100644
> >>> --- a/drivers/scsi/libsas/sas_ata.c
> >>> +++ b/drivers/scsi/libsas/sas_ata.c
> >>> @@ -209,10 +209,12 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
> >>>                task->num_scatter = si;
> >>>        }
> >>>
> >>> -     if (qc->tf.protocol == ATA_PROT_NODATA)
> >>> +     if (qc->tf.protocol == ATA_PROT_NODATA) {
> >>>                task->data_dir = DMA_NONE;
> >>> -     else
> >>> +             task->num_scatter = 0;
> >>
> >> task->num_scatter has already been set in this function. Best not set it
> >> twice.
> >>
> >
> > Sure. Please suggest if I should update patch to above suggested
> > approach. That will avoid setting num_scatter twice.
> >
>
> Thanks,
> John
>
> BTW, could we add a fixes tag?

Added in v2.

Thanks,
Jolly
