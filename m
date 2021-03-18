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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35832C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 00:25:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2B4964F62
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 00:25:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhCRAZM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 20:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbhCRAYz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 20:24:55 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C165C06174A
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 17:24:55 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id v23so389762ple.9
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 17:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=62xgyuajU6tPw+M6TsZi2hiokYvIOr5Uaenxy/zAlGg=;
        b=WI0VP6TtBL+cnRViHv7of0jXPRhATu5KFZ/BcWIMdApFfQJkhUP7LkF0M+RYMD4sVA
         11AWfppCK9H3XEcYaoiaFjrkqx6eoT/NGqHBnyyRysqGOAxIJFe8O15Fy5CA03VmfwSI
         l28WWneVh2/QnaY+NCOK2wLlK7sfucZHd9q2lsxrWDLBvWw6KJLv7NX+RDZynH8D8fM9
         QbIiNPwfP0XS4Buanio/I+GBH6d+SWNSVCwqnhu4DPqwV3ok04fYQ+H3mr8McZ9bsVwj
         bvTyPr/F7kCtMDRu5l/RGB5MAmlQfiXYzmu4aaOauC4es79EWQzmTRdqBPmmrfiRTueZ
         nbHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=62xgyuajU6tPw+M6TsZi2hiokYvIOr5Uaenxy/zAlGg=;
        b=jOCL/bY3hvqiAvSgUGR4IXExHVt8R2N/kLXNkjuEMLiEPvt3o/OQl8muG4dThP5Mit
         p41ZaJ7OAbvgr6zbnXd34V8k3EU2JLeJHL+5Uc/W9ny47RW5w8NOJg0TTjCEciR+PhD5
         7ujxl40vZ/Wy5JsEuzdE2GHl+btQ90l744LXKq9I+iM/cx8qUvTivJ/TBODyXGixP42w
         M13g8TViGvfOcY94VSRH6WR7XZbAAIihYtaM3QXBQP+BzptYz4Sd/b26xzYCjx9vBnhC
         +r591szWnu8SOQ2SYjjB/yKUNL62LGCacz7WseW5e6dtuqzOrEmsRXK4Os0qxnWpMz5S
         ll/A==
X-Gm-Message-State: AOAM532BiqadzE8MtPELE7hng6NRzQmRcqBFljap8mxfGN7fELJZgu1l
        ZAks1JIB1F/aIAOfrJPnw3s8NWil19fWZEBaIbNcaw==
X-Google-Smtp-Source: ABdhPJzWI3PAehWugN6WUCwZTKYZmT4l1xfy3zClMuUAJQGMw+FDmDgjxsz23qtHVd1KWB5WITvmwfo7Jbp5U6EJf4g=
X-Received: by 2002:a17:902:bf01:b029:e6:6b59:a48b with SMTP id
 bi1-20020a170902bf01b02900e66b59a48bmr6959147plb.55.1616027094933; Wed, 17
 Mar 2021 17:24:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210316193905.1673600-1-jollys@google.com> <5e2c35b6-a9c4-0637-738b-ff6920635425@huawei.com>
In-Reply-To: <5e2c35b6-a9c4-0637-738b-ff6920635425@huawei.com>
From:   Jolly Shah <jollys@google.com>
Date:   Wed, 17 Mar 2021 17:24:44 -0700
Message-ID: <CABGCNpDdK2+DNTJpzjig3hX3W_7JB8nEcRcuRnv8Z4oRSq2-dA@mail.gmail.com>
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

Thanks for the review.


On Wed, Mar 17, 2021 at 4:44 AM John Garry <john.garry@huawei.com> wrote:
>
> On 16/03/2021 19:39, Jolly Shah wrote:
> > When the cache_type for the scsi device is changed, the scsi layer
> > issues a MODE_SELECT command. The caching mode details are communicated
> > via a request buffer associated with the scsi command with data
> > direction set as DMA_TO_DEVICE (scsi_mode_select). When this command
> > reaches the libata layer, as a part of generic initial setup, libata
> > layer sets up the scatterlist for the command using the scsi command
> > (ata_scsi_qc_new). This command is then translated by the libata layer
> > into ATA_CMD_SET_FEATURES (ata_scsi_mode_select_xlat). The libata layer
> > treats this as a non data command (ata_mselect_caching), since it only
> > needs an ata taskfile to pass the caching on/off information to the
> > device. It does not need the scatterlist that has been setup, so it does
> > not perform dma_map_sg on the scatterlist (ata_qc_issue).
>
> So if we don't perform the dma_map_sg() on the sgl at this point, then
> it seems to me that we should not perform for_each_sg() on it either,
> right? That is still what happens in sas_ata_qc_issue() in this case.
>

Yes that's right. To avoid that, I can add elseif block for
ATA_PROT_NODATA before for_each_sg() is performed. Currently there's
existing code block for ATA_PROT_NODATA after for_each_sg()  is
performed,
reused that to reset num_scatter. Please suggest.

> > Unfortunately,
> > when this command reaches the libsas layer(sas_ata_qc_issue), libsas
> > layer sees it as a non data command with a scatterlist. It cannot
> > extract the correct dma length, since the scatterlist has not been
> > mapped with dma_map_sg for a DMA operation. When this partially
> > constructed SAS task reaches pm80xx LLDD, it results in below warning.
> >
> > "pm80xx_chip_sata_req 6058: The sg list address
> > start_addr=0x0000000000000000 data_len=0x0end_addr_high=0xffffffff
> > end_addr_low=0xffffffff has crossed 4G boundary"
> >
> > This patch assigns appropriate value to  num_sectors for ata non data
> > commands.
> >
> > Signed-off-by: Jolly Shah <jollys@google.com>
> > ---
> >   drivers/scsi/libsas/sas_ata.c | 6 ++++--
> >   1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> > index 024e5a550759..94ec08cebbaa 100644
> > --- a/drivers/scsi/libsas/sas_ata.c
> > +++ b/drivers/scsi/libsas/sas_ata.c
> > @@ -209,10 +209,12 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
> >               task->num_scatter = si;
> >       }
> >
> > -     if (qc->tf.protocol == ATA_PROT_NODATA)
> > +     if (qc->tf.protocol == ATA_PROT_NODATA) {
> >               task->data_dir = DMA_NONE;
> > -     else
> > +             task->num_scatter = 0;
>
> task->num_scatter has already been set in this function. Best not set it
> twice.
>

Sure. Please suggest if I should update patch to above suggested
approach. That will avoid setting num_scatter twice.

Thanks,
Jolly Shah

> Thanks,
> John
>
> > +     } else {
> >               task->data_dir = qc->dma_dir;
> > +     }
> >       task->scatter = qc->sg;
> >       task->ata_task.retry_count = 1;
> >       task->task_state_flags = SAS_TASK_STATE_PENDING;
> >
>
