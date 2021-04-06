Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12578C433B4
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 08:17:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D18D4613C2
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 08:17:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232355AbhDFIRZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 04:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232032AbhDFIRZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 04:17:25 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A27C06174A
        for <linux-scsi@vger.kernel.org>; Tue,  6 Apr 2021 01:17:17 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id u21so20475732ejo.13
        for <linux-scsi@vger.kernel.org>; Tue, 06 Apr 2021 01:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xe3AzWmGnx/z1TKnpdZ61665fXMzlDZOAaprwaVmFcs=;
        b=fzPGV5Nko2inRgX0zUsHlxNhQE3/aR/j4jM4YRaQJEAG5Dh1+QpAw59NRnqJdbkBua
         VdmeFzdcXG0HzHZBXjE356tuRZEyBTofK5CZ18j2H6mfHmgTJ9dSUleenB+Da/0fBM1g
         YBizGz1NAj0nNOPqtUwWuTncDvNIZvBPiP0FkH92uOIk18b0Qh3CwOY5PrUchqkYB6z0
         VVEYeeistNCv7D2gxI2xr7OhM5t+OhN/VIvjPb+Fp39HSVmRkoZb7qFg2OB2E+MxTOn3
         dK/7m8e7E/DCmFY14tgip7PwkNw6tFuu+Aogp/hDXFqvqPDDdqSBLLTWjhdz3dImYWPu
         0EMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xe3AzWmGnx/z1TKnpdZ61665fXMzlDZOAaprwaVmFcs=;
        b=geTvvPjhAxc62Tkp73HEpyJCEUd8zvQc1uojrbZDxpJIzQuF3G6FIKYsj88+aeFRxu
         hxgMOIB2o8t9m2pkcAhixFh2YLsqoXWTrSOvRADVj1ppojagpPD8S3p3POc0xVNMFX55
         RxwRN7EM5lwlP2Su8QOQq/3OfRkNSnlpXCRmMM+L8mCT7NNc1aq2e1xC4oZHat7Eo9L3
         FK8lR5x/8iUpoYKPjVoDR4Y2zF8uF8DI5y2z8v2c9QXSoeq5Nj9G9XD9P97tcLSgarrY
         kULehsnKHL9uYlFqGsc073J4ffK1gJkD15/zzkNPeNNfXbcSWk5yJ4yAkCarZqi4AdRn
         kAYA==
X-Gm-Message-State: AOAM533tRuw9Jx9TUMeC509M8N1spsAxOBK4z2LHBdaHn3olJHnI2FJY
        dJEi7n+j6XXw1BqtzEclc+rv8kRjfdq8rczefD7DVw==
X-Google-Smtp-Source: ABdhPJzM2HMrpkpQaynvrx3o++wChaHZlmrLcFxgIV8Ppe8LCBRXpFIkDyrNJDz2ftpwtLsMD0IaByb/00UspVSDFlw=
X-Received: by 2002:a17:906:d8a3:: with SMTP id qc3mr10407639ejb.353.1617697036323;
 Tue, 06 Apr 2021 01:17:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210329183639.1674307-1-ipylypiv@google.com> <20210329183639.1674307-3-ipylypiv@google.com>
In-Reply-To: <20210329183639.1674307-3-ipylypiv@google.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Tue, 6 Apr 2021 10:17:05 +0200
Message-ID: <CAMGffEmTO0QPx1JECeGxj86y12nJz=HGxtLXe=N2kNU5aHjqhQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] scsi: pm80xx: Remove busy wait from mpi_uninit_check()
To:     Igor Pylypiv <ipylypiv@google.com>
Cc:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Vishakha Channapattan <vishakhavc@google.com>,
        Akshat Jain <akshatzen@google.com>,
        Jolly Shah <jollys@google.com>, Yu Zheng <yuuzheng@google.com>,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Viswas G <Viswas.G@microchip.com>,
        Deepak Ukey <deepak.ukey@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Mar 29, 2021 at 8:37 PM Igor Pylypiv <ipylypiv@google.com> wrote:
>
> mpi_uninit_check() is not being called in an ATOMIC context.
> The only caller of mpi_uninit_check() is pm80xx_chip_soft_rst().
>
> Callers of pm80xx_chip_soft_rst():
>  - pm8001_ioctl_soft_reset()
>  - pm8001_pci_probe()
>  - pm8001_pci_remove()
>  - pm8001_pci_suspend()
>  - pm8001_pci_resume()
>
> There was a similar fix for mpi_init_check() in commit d71023af4bec0
> ("scsi: pm80xx: Do not busy wait in MPI init check").
>
> Reviewed-by: Vishakha Channapattan <vishakhavc@google.com>
> Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index a6f65666c98e..9fade2ed9396 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -1502,12 +1502,12 @@ static int mpi_uninit_check(struct pm8001_hba_info *pm8001_ha)
>
>         /* wait until Inbound DoorBell Clear Register toggled */
>         if (IS_SPCV_12G(pm8001_ha->pdev)) {
> -               max_wait_count = (30 * 1000 * 1000) /* 30 sec */
> +               max_wait_count = SPCV_DOORBELL_CLEAR_TIMEOUT;
>         } else {
> -               max_wait_count = (15 * 1000 * 1000) /* 15 sec */
> +               max_wait_count = SPC_DOORBELL_CLEAR_TIMEOUT;
>         }
>         do {
> -               udelay(1);
> +               msleep(FW_READY_INTERVAL);
>                 value = pm8001_cr32(pm8001_ha, 0, MSGU_IBDB_SET);
>                 value &= SPCv_MSGU_CFG_TABLE_RESET;
>         } while ((value != 0) && (--max_wait_count));
> @@ -1519,9 +1519,9 @@ static int mpi_uninit_check(struct pm8001_hba_info *pm8001_ha)
>
>         /* check the MPI-State for termination in progress */
>         /* wait until Inbound DoorBell Clear Register toggled */
> -       max_wait_count = 2 * 1000 * 1000;       /* 2 sec for spcv/ve */
> +       max_wait_count = 100; /* 2 sec for spcv/ve */
>         do {
> -               udelay(1);
> +               msleep(FW_READY_INTERVAL);
>                 gst_len_mpistate =
>                         pm8001_mr32(pm8001_ha->general_stat_tbl_addr,
>                         GST_GSTLEN_MPIS_OFFSET);
> --
> 2.31.0.291.g576ba9dcdaf-goog
>
