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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C4BEC433B4
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 22:35:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11092610A0
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 22:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234550AbhDAWfL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Apr 2021 18:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233981AbhDAWfK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2021 18:35:10 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98EEC061788
        for <linux-scsi@vger.kernel.org>; Thu,  1 Apr 2021 15:35:10 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id g8-20020a9d6c480000b02901b65ca2432cso3525242otq.3
        for <linux-scsi@vger.kernel.org>; Thu, 01 Apr 2021 15:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Fj85qQK7dbFMVrWc6drYDzKb296D9FbiiC583NFbWrY=;
        b=IQUVaebifeGyZummO+FyMc4HYoA8epMMse84C7n0U0fsWyoFXP8OCKn24+g3ihYgpS
         np8crOUCKDBih1v8z55ihhICh3Lz/y6TMC/rZnJCa5G+WQL4sqoqNRSb6MN3GrYCTws4
         +IoGC5zMHomwEa7+19+dNME/iP3tgB43k4CwrEIeGlBgWLDWcQqFAVkue2qiA0GNQdJt
         AHKUQaeSY+/qwp0/BkjMiHzrLSPEvgvkbALGjI/E8t1dgvx3H8Bj9sYvaH3n1r4F/mLr
         OBrMi/+R2cHWKp/OgoVZBf/HMP6i/cm994PjeeHpenAUOmRWzCeJFC+oxq/DzB82kuoC
         LbJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Fj85qQK7dbFMVrWc6drYDzKb296D9FbiiC583NFbWrY=;
        b=o9HdsI+qAixfBxtzOoqriTgAfBMP/DFurC5wBH8GwHORQVjh2JZES0Cw2POhTXqaol
         sSTt5GMyYNGqpXnp3H+HGvpHEof2BypDBjater4xAeA/E+nxO2d5KrSRe+zNYoDpWUzm
         twPz9Tm4RApDPnRffEff6ZiQIKbEEGSYfSFVTbMVk+/4189ZmqhHyKE4mFymaTDgsr+i
         STs8zr/SVzAgIentdL2DgYXxBfROhkuQiNQtg+XpqMLOEBTl/GDqtfEvNra/MOfqvEo/
         Rv3DXnJkDhz9I6uyovm+10gctgiEAywEwCkNvxW59NIIkbfp1LueD0lLc1SK84iO0qhl
         dOMQ==
X-Gm-Message-State: AOAM530CZINz5Vt2IcDe9Mqc0K7+vaFHKeoM+2vifgLNk/EZneyIetCe
        rJSyeX2HJMk12SzrluAsglHgk2LD0PTlgk/AwXFFiA==
X-Google-Smtp-Source: ABdhPJzcNmOg3S5/WZxTXo0+O8T2gdkqSFEArCAiEh0ns2GZ+Yj7eLyW7JvUvO12GPjG7oeI1bzc4xzk/WWQcf2lOvc=
X-Received: by 2002:a9d:620a:: with SMTP id g10mr8664398otj.335.1617316510065;
 Thu, 01 Apr 2021 15:35:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210318225632.2481291-1-jollys@google.com> <5e7ea537-86ab-f654-1df4-765364116e18@huawei.com>
 <993f97da-01f0-262b-3fbe-66fa1769698a@huawei.com> <f74c0003-dbbf-5b4a-87f2-cd5571ea412e@huawei.com>
In-Reply-To: <f74c0003-dbbf-5b4a-87f2-cd5571ea412e@huawei.com>
From:   Jolly Shah <jollys@google.com>
Date:   Thu, 1 Apr 2021 15:34:58 -0700
Message-ID: <CABGCNpBABSkdSQf=c2T9qMTGgJPL7Si9Ft_DvC8WiLtT_vmL1Q@mail.gmail.com>
Subject: Re: [PATCH v2] scsi: libsas: Reset num_scatter if libata mark qc as NODATA
To:     luojiaxing <luojiaxing@huawei.com>
Cc:     John Garry <john.garry@huawei.com>,
        Jason Yan <yanaijie@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, a.darwish@linutronix.de,
        dan.carpenter@oracle.com, b.zolnierkie@samsung.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Luojiaxing,


On Mon, Mar 22, 2021 at 1:41 AM luojiaxing <luojiaxing@huawei.com> wrote:
>
>
> On 2021/3/20 20:14, John Garry wrote:
> > On 19/03/2021 01:43, Jason Yan wrote:
> >>
> >>
> >> =E5=9C=A8 2021/3/19 6:56, Jolly Shah =E5=86=99=E9=81=93:
> >>> When the cache_type for the scsi device is changed, the scsi layer
> >>> issues a MODE_SELECT command. The caching mode details are communicat=
ed
> >>> via a request buffer associated with the scsi command with data
> >>> direction set as DMA_TO_DEVICE (scsi_mode_select). When this command
> >>> reaches the libata layer, as a part of generic initial setup, libata
> >>> layer sets up the scatterlist for the command using the scsi command
> >>> (ata_scsi_qc_new). This command is then translated by the libata laye=
r
> >>> into ATA_CMD_SET_FEATURES (ata_scsi_mode_select_xlat). The libata lay=
er
> >>> treats this as a non data command (ata_mselect_caching), since it onl=
y
> >>> needs an ata taskfile to pass the caching on/off information to the
> >>> device. It does not need the scatterlist that has been setup, so it
> >>> does
> >>> not perform dma_map_sg on the scatterlist (ata_qc_issue).
> >>> Unfortunately,
> >>> when this command reaches the libsas layer(sas_ata_qc_issue), libsas
> >>> layer sees it as a non data command with a scatterlist. It cannot
> >>> extract the correct dma length, since the scatterlist has not been
> >>> mapped with dma_map_sg for a DMA operation. When this partially
> >>> constructed SAS task reaches pm80xx LLDD, it results in below warning=
.
> >>>
> >>> "pm80xx_chip_sata_req 6058: The sg list address
> >>> start_addr=3D0x0000000000000000 data_len=3D0x0end_addr_high=3D0xfffff=
fff
> >>> end_addr_low=3D0xffffffff has crossed 4G boundary"
> >>>
> >>> This patch updates code to handle ata non data commands separately so
> >>> num_scatter and total_xfer_len remain 0.
> >>>
> >>> Fixes: 53de092f47ff ("scsi: libsas: Set data_dir as DMA_NONE if
> >>> libata marks qc as NODATA")
> >>> Signed-off-by: Jolly Shah <jollys@google.com>
> >
> > Reviewed-by: John Garry <john.garry@huawei.com>
> >
> > @luojiaxing, can you please test this?
>
>
> Sure, let me take a look, and reply the test result here later
>

Wanted to follow up on test results. Any updates?

Thanks,
Jolly

>
> Thanks
>
> Jiaxing
>
>
> >
> >>> ---
> >>> v2:
> >>> - reorganized code to avoid setting num_scatter twice
> >>>
> >>>   drivers/scsi/libsas/sas_ata.c | 9 ++++-----
> >>>   1 file changed, 4 insertions(+), 5 deletions(-)
> >>>
> >>> diff --git a/drivers/scsi/libsas/sas_ata.c
> >>> b/drivers/scsi/libsas/sas_ata.c
> >>> index 024e5a550759..8b9a39077dba 100644
> >>> --- a/drivers/scsi/libsas/sas_ata.c
> >>> +++ b/drivers/scsi/libsas/sas_ata.c
> >>> @@ -201,18 +201,17 @@ static unsigned int sas_ata_qc_issue(struct
> >>> ata_queued_cmd *qc)
> >>>           memcpy(task->ata_task.atapi_packet, qc->cdb,
> >>> qc->dev->cdb_len);
> >>>           task->total_xfer_len =3D qc->nbytes;
> >>>           task->num_scatter =3D qc->n_elem;
> >>> +        task->data_dir =3D qc->dma_dir;
> >>> +    } else if (qc->tf.protocol =3D=3D ATA_PROT_NODATA) {
> >>> +        task->data_dir =3D DMA_NONE;
> >>
> >> Hi Jolly & John,
> >>
> >> We only set DMA_NONE for ATA_PROT_NODATA, I'm curious about why
> >> ATA_PROT_NCQ_NODATA and ATAPI_PROT_NODATA do not need to set DMA_NONE?
> >
> > So we can see something like atapi_eh_tur() -> ata_exec_internal(),
> > which is a ATAPI NONDATA and has DMA_NONE, so should be ok.
> >
> > Other cases, like those using the xlate function on the qc for
> > ATA_PROT_NCQ_NODATA, could be checked further.
> >
> > For now, we're just trying to fix the fix.
> >
> >>
> >> Thanks,
> >> Jason
> >>
> >>
> >>>       } else {
> >>>           for_each_sg(qc->sg, sg, qc->n_elem, si)
> >>>               xfer +=3D sg_dma_len(sg);
> >>>           task->total_xfer_len =3D xfer;
> >>>           task->num_scatter =3D si;
> >>> -    }
> >>> -
> >>> -    if (qc->tf.protocol =3D=3D ATA_PROT_NODATA)
> >>> -        task->data_dir =3D DMA_NONE;
> >>> -    else
> >>>           task->data_dir =3D qc->dma_dir;
> >>> +    }
> >>>       task->scatter =3D qc->sg;
> >>>       task->ata_task.retry_count =3D 1;
> >>>       task->task_state_flags =3D SAS_TASK_STATE_PENDING;
> >>>
> >> .
> >
> >
> > .
> >
>
