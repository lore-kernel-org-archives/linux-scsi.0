Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 020EDC433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 17:12:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3A4464E61
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 17:12:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhCQRMO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 13:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbhCQRMJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 13:12:09 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65290C06174A
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 10:12:09 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id k14-20020a9d7dce0000b02901b866632f29so2501289otn.1
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 10:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HchjgJn3AgnpDc5+oGAmJzvgBR7qMdT7ZxA9Rjp655E=;
        b=f56nEazfE3s/D1h9atyavfjqZb/lAtSQgpQ7AZ65oHJJjDdmycjgaAOLupbKLr5N+a
         RKOI2al//Yv4/SV6kU/wHdwOW6fy5g9l6FjEC9b6oZve3BXgfocq+DpJw90HRaevzaqV
         DXUTYY2L882l9a58bhfMUjoKzLJa7to5bY5hADt5J3zBf7m7G54EtA0KJsSiRb+H1n2/
         lS+i2prvUmBRY/7aOOEVDlq6K1/4fvMR1vu5k+I/JywooIZ+O4z2JVhbnRhSwg+2JaGy
         9tJq9mM6V9BjVWFZhyWOfGByOmWj/+qVuiOJqpfQp8a6wZF7qh0ht5TcZFc7BOurK/WG
         QxQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HchjgJn3AgnpDc5+oGAmJzvgBR7qMdT7ZxA9Rjp655E=;
        b=Nd8eH0NRpTmSQPcDz7j1z/RQb09fWjw6Eif7DhCNQVq9YQ+HPyDVAMSVtnKxmK3p1Q
         ple1Jtm7hZag4EMxdTM8UZOUF3Sc1GFHqlzTJfGoL1nmIxQ59oVf5SlTDiHzL1y10F9S
         CNPralCwwfHbmUr5g/JyAJhm6hJOhzS7NVhfKLnPbOoo+nsOKtdBjx6SnIG+Z9jc/1Ua
         wjuinGTX9FLkwXVIICu7yRv9p9SLqJJqMNzGaH21xWUVCTxJPI/1wP2QvVrtMmCBSg5J
         YAobopv0VrMNbRnyQj5rylrj3EhR16eXy7JuVNraapWRv6WaKI7vtQ5RgzgHLaO01p4U
         0Ztw==
X-Gm-Message-State: AOAM530KYXQWeDYCrCJ8j9akJ7cxBqhBn0LtYisf15haZLh4/B3VX9gy
        JeRRQDpFlJGC6d0idfH9sEdx0An1sPTkFO/hnTjf0g==
X-Google-Smtp-Source: ABdhPJyLz4VMRJSTVjkIeIBOFPx1Ljq9ZBonqjSzDy1a5uZk19/2BxAbGu3+DDtbay8uqoQjvM4gfBPfT6976Ry4C6M=
X-Received: by 2002:a05:6830:1644:: with SMTP id h4mr4171335otr.349.1616001128576;
 Wed, 17 Mar 2021 10:12:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210316193905.1673600-1-jollys@google.com> <3a0626ae-327b-146f-5b2d-c58074c421a5@huawei.com>
In-Reply-To: <3a0626ae-327b-146f-5b2d-c58074c421a5@huawei.com>
From:   Jolly Shah <jollys@google.com>
Date:   Wed, 17 Mar 2021 10:11:57 -0700
Message-ID: <CABGCNpB-X6uXpi+ZECb7xpLxPw04GybMuMVFG-GojpwkC52hmQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: libsas: Reset num_scatter if libata mark qc as NODATA
To:     Jason Yan <yanaijie@huawei.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        john.garry@huawei.com, a.darwish@linutronix.de,
        luojiaxing@huawei.com, dan.carpenter@oracle.com,
        b.zolnierkie@samsung.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Jason,

Thanks for the review.


On Tue, Mar 16, 2021 at 6:50 PM Jason Yan <yanaijie@huawei.com> wrote:
>
>
> =E5=9C=A8 2021/3/17 3:39, Jolly Shah =E5=86=99=E9=81=93:
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
> > device. It does not need the scatterlist that has been setup, so it doe=
s
> > not perform dma_map_sg on the scatterlist (ata_qc_issue). Unfortunately=
,
> > when this command reaches the libsas layer(sas_ata_qc_issue), libsas
> > layer sees it as a non data command with a scatterlist. It cannot
> > extract the correct dma length, since the scatterlist has not been
> > mapped with dma_map_sg for a DMA operation. When this partially
> > constructed SAS task reaches pm80xx LLDD, it results in below warning.
> >
> > "pm80xx_chip_sata_req 6058: The sg list address
> > start_addr=3D0x0000000000000000 data_len=3D0x0end_addr_high=3D0xfffffff=
f
> > end_addr_low=3D0xffffffff has crossed 4G boundary"
> >
> > This patch assigns appropriate value to  num_sectors for ata non data
> > commands.
> >
> > Signed-off-by: Jolly Shah <jollys@google.com>
> > ---
> >   drivers/scsi/libsas/sas_ata.c | 6 ++++--
> >   1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_at=
a.c
> > index 024e5a550759..94ec08cebbaa 100644
> > --- a/drivers/scsi/libsas/sas_ata.c
> > +++ b/drivers/scsi/libsas/sas_ata.c
> > @@ -209,10 +209,12 @@ static unsigned int sas_ata_qc_issue(struct ata_q=
ueued_cmd *qc)
> >               task->num_scatter =3D si;
> >       }
> >
> > -     if (qc->tf.protocol =3D=3D ATA_PROT_NODATA)
> > +     if (qc->tf.protocol =3D=3D ATA_PROT_NODATA) {
> >               task->data_dir =3D DMA_NONE;
> > -     else
> > +             task->num_scatter =3D 0;
> > +     } else {
> >               task->data_dir =3D qc->dma_dir;
> > +     }
> >       task->scatter =3D qc->sg;
> >       task->ata_task.retry_count =3D 1;
> >       task->task_state_flags =3D SAS_TASK_STATE_PENDING;
> >
>
> Thanks for the patch. Except the warning, any functional errors?
>

No functional errors observed.

Thanks,
Jolly Shah

> The code looks good to me,
>
> Reviewed-by: Jason Yan <yanaijie@huawei.com>
