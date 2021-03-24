Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE834C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 10:57:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76CA360238
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 10:57:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234452AbhCXK5U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 06:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234485AbhCXK4y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 06:56:54 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8006C0613DE
        for <linux-scsi@vger.kernel.org>; Wed, 24 Mar 2021 03:56:51 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id z1so27140155edb.8
        for <linux-scsi@vger.kernel.org>; Wed, 24 Mar 2021 03:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ToRLObeEBgXor/SnBvKlxaQPAAiDt0hrFEbYVfvSCnc=;
        b=elEEkbDKetS27RjdVzzPaXDGsWXC+eCWLe3lSxMWM24U6+BEsf71pQbbPS1MT7tRVG
         A11IyB0kOvl0ZedJAPzv7uOAcohiuwGf+cR4Lq4sSe3DuLfgcrQ83b82UDPHNZp97OIm
         OkrH/eL56i/9orrRl05h7Rtshwdl5b169LGfxXmkdl+QumjUpoOL9fs8wPsZ8crvT7dL
         DDHUoHkYlbATU4Ejvkk33BGXkVVlzhnnf7jqfCpzrr/8OG9mLv02MBV8MVz0cmvNohaW
         5BrsHEkA1Tc/P/7DvXKJHMygW3zrDzrQGTtMpkjytmu8YyhjqXr9m5fbm6KPMCsODWIR
         A1OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ToRLObeEBgXor/SnBvKlxaQPAAiDt0hrFEbYVfvSCnc=;
        b=FwZi8Nl1S7pxpP/+1oXwa7qxRmtwufrd/+61pbb7F8X+obQMDAGdBruCaAm0LfGoTB
         ZI8V16OJp9Izo4ICUFe1KEWgFqtTgck9Ql69AV1AM6UDwOE8esNj5LtI5dCskFVt5qA/
         jl5W+ar26Nwt4ryrqj6QJ4voxAyxKEcTF4AjJUoXedq6LyJEc7mwDf8b+nQM4ungtGKO
         WAMF0r4/VHHVHOq5QLOLiW6j3rPu77iz9gDxlksio/FRA2CznD/xVwAmPZFedVNqpJea
         q8UEpcjTuPtBLVRBqAzoF4nTgkkhinl88QsYypXgYRnT4qzeg2AlieOKYYmV/fhoOMCu
         dCQw==
X-Gm-Message-State: AOAM530zhwY1o15spui5OudYb1ztzJou88Fw5LdAKpSicYEgh4kz0uRJ
        91XDL0rqIfoFMVbiWiHmYabcMBZQI9Lm1WE7lChkzA==
X-Google-Smtp-Source: ABdhPJwqlN1J15VG53NhAXyIjEDLmkLNi34PUF7ymALe3cIm19hNqrcFqLDjhEU7wQtAJnwdTKimHEfqlIOTdSRbOiY=
X-Received: by 2002:a05:6402:42c9:: with SMTP id i9mr2771463edc.35.1616583410353;
 Wed, 24 Mar 2021 03:56:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210323125458.1825564-1-arnd@kernel.org>
In-Reply-To: <20210323125458.1825564-1-arnd@kernel.org>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Wed, 24 Mar 2021 11:56:39 +0100
Message-ID: <CAMGffEnahDx9cR+GUmvXZT0ztq+uLC+Yn-_nMVOf452uwx8Q6A@mail.gmail.com>
Subject: Re: [PATCH] scsi: pm8001: avoid -Wrestrict warning
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Viswas G <Viswas.G@microchip.com>,
        Ruksar Devadi <Ruksar.devadi@microchip.com>,
        Joe Perches <joe@perches.com>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Lee Jones <lee.jones@linaro.org>,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 23, 2021 at 1:55 PM Arnd Bergmann <arnd@kernel.org> wrote:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> On some configurations, gcc warns about overlapping source and
> destination arguments to snprintf:
>
> drivers/scsi/pm8001/pm8001_init.c: In function 'pm8001_request_msix':
> drivers/scsi/pm8001/pm8001_init.c:977:3: error: 'snprintf' argument 4 may overlap destination object 'pm8001_ha' [-Werror=restrict]
>   977 |   snprintf(drvname, len, "%s-%d", pm8001_ha->name, i);
>       |   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/scsi/pm8001/pm8001_init.c:962:56: note: destination object referenced by 'restrict'-qualified argument 1 was declared here
>   962 | static u32 pm8001_request_msix(struct pm8001_hba_info *pm8001_ha)
>       |                                ~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~
>
> I first assumed this was a gcc bug, as that should not happen, but
> a reduced test case makes it clear that this happens when the loop
> counter is not bounded by the array size.
>
> Help the compiler out by adding an explicit limit here to make the
> code slightly more robust and avoid the warning.
>
> Link: https://godbolt.org/z/6T1qPM
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index bd626ef876da..a268c647b987 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -963,6 +963,7 @@ static u32 pm8001_request_msix(struct pm8001_hba_info *pm8001_ha)
>  {
>         u32 i = 0, j = 0;
>         int flag = 0, rc = 0;
> +       int nr_irqs = pm8001_ha->number_of_intr;
>
>         if (pm8001_ha->chip_id != chip_8001)
>                 flag &= ~IRQF_SHARED;
> @@ -971,7 +972,10 @@ static u32 pm8001_request_msix(struct pm8001_hba_info *pm8001_ha)
>                    "pci_enable_msix request number of intr %d\n",
>                    pm8001_ha->number_of_intr);
>
> -       for (i = 0; i < pm8001_ha->number_of_intr; i++) {
> +       if (nr_irqs > ARRAY_SIZE(pm8001_ha->intr_drvname))
> +               nr_irqs = ARRAY_SIZE(pm8001_ha->intr_drvname);
> +
> +       for (i = 0; i < nr_irqs; i++) {
>                 snprintf(pm8001_ha->intr_drvname[i],
>                         sizeof(pm8001_ha->intr_drvname[0]),
>                         "%s-%d", pm8001_ha->name, i);
> --
> 2.29.2
>
