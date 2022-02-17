Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45ACAC433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 19:15:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245036AbiBQTP5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 14:15:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245094AbiBQTPq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 14:15:46 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35D390272
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:15:29 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id q17so11477551edd.4
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M5yAKRPOYPM760CdAYHhzv7XEs1t0RhLsmSJvSdNh9Y=;
        b=NpNTI6CSxXCTWLshyCdFJ37xj26igwOrzTY79d6XC9CXN9GK/PRpetljUnoeRJXYJE
         MxQauNMCC0wPX/1L3WGDrwjW1s7Q1XqIa3nLAPkN5RoBs2GWAorunZKqis0vba/1leOp
         TxL7lHUPZNCrfWYccN08lRaFe0na+6/oSJdVCNbdqggySX1Owof7rCVqwvf5SpMSf82L
         O7X7lGhMZRGCO0JbgRD84TykkDs0JrYkWfr3aT8Tn2xognTGOhEuiIx2j8HSJlDusDlS
         ZlM6T5UCxPEhJmzt/L6FJ53UCEab+xWdwsyuJPiG9GBZU3andAlZiFxHVbJpyma+3SVy
         KGZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M5yAKRPOYPM760CdAYHhzv7XEs1t0RhLsmSJvSdNh9Y=;
        b=wMWIPAs9XlgXomG27bv1pDycUOZ/9pAYnCLu/SwIG0VvjlQ4zKwrxLzGGITOeNbXiy
         D3/G12OvFcujg1atzhUDmjHCrCobYDCt532D63XEuKaTRDHdjD1w0GJtUDTdsVhl2g3i
         y++wwdhnbr6gtmMrVH4+O4U5Xjjbk2HrWT2MdajS91gW9ztEiYHAkILLiYEwoMZVtNqP
         voHVMKX6NLNcJrxh39vmD8lnE6olLspwjPm1Sv1GXdZj1V6LK5rT6wydeKGC8axRv+K/
         X4j2Xjp+83KfIeOuyzPx6kCXy9Lo2omhrihSYc7tk0a2N30d/Gg/SUZ4L71fx8gkxXOV
         Ic+g==
X-Gm-Message-State: AOAM531eexJ3tO66SZE1Trlavs2saTheft5c7YIBzTOB6n2hVRaWsGLO
        SnZKbn2pRzzpOZ5TDKmBpAfUGeL8YROQlUQARphEzQ==
X-Google-Smtp-Source: ABdhPJyBqXcVbMijEByew8lVuybW8kOwzQYEfxoQM/S2NioDrtFYVBHVgbJTXjaJMwhciL+PpdE2KAEskop5OusOKJw=
X-Received: by 2002:a50:9b12:0:b0:410:b926:d2d3 with SMTP id
 o18-20020a509b12000000b00410b926d2d3mr4271909edi.331.1645125328273; Thu, 17
 Feb 2022 11:15:28 -0800 (PST)
MIME-Version: 1.0
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com> <20220217132956.484818-14-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20220217132956.484818-14-damien.lemoal@opensource.wdc.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 17 Feb 2022 20:15:17 +0100
Message-ID: <CAMGffEkGB=um3_Vk+Qzy7t2SnopVbc5qNEH_PFjpOLV9ZF=K3g@mail.gmail.com>
Subject: Re: [PATCH v4 13/31] scsi: pm8001: Remove local variable in pm8001_pci_resume()
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Feb 17, 2022 at 2:30 PM Damien Le Moal
<damien.lemoal@opensource.wdc.com> wrote:
>
> In pm8001_pci_resume(), the use of the u32 type for the local variable
> device_state causes a sparse warning:
>
> warning: incorrect type in assignment (different base types)
>     expected unsigned int [usertype] device_state
>     got restricted pci_power_t [usertype] current_state
>
> Since this variable is used only once in the function, remove it and
> use pdev->current_state directly. While at it, also add a blank line
> after the last local variable declaration.
>
> Reviewed-by: John Garry <john.garry@huawei.com>
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
thx!
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index d8a2121cb8d9..4b9a26f008a9 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -1335,13 +1335,13 @@ static int __maybe_unused pm8001_pci_resume(struct device *dev)
>         struct pm8001_hba_info *pm8001_ha;
>         int rc;
>         u8 i = 0, j;
> -       u32 device_state;
>         DECLARE_COMPLETION_ONSTACK(completion);
> +
>         pm8001_ha = sha->lldd_ha;
> -       device_state = pdev->current_state;
>
> -       pm8001_info(pm8001_ha, "pdev=0x%p, slot=%s, resuming from previous operating state [D%d]\n",
> -                     pdev, pm8001_ha->name, device_state);
> +       pm8001_info(pm8001_ha,
> +                   "pdev=0x%p, slot=%s, resuming from previous operating state [D%d]\n",
> +                   pdev, pm8001_ha->name, pdev->current_state);
>
>         rc = pci_go_44(pdev);
>         if (rc)
> --
> 2.34.1
>
