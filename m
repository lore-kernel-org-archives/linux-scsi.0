Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07ADCC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 06:22:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFA1C6134F
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 06:22:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348250AbhI3GXo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 02:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348252AbhI3GXn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Sep 2021 02:23:43 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C042C06161C
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 23:22:01 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id dj4so18239098edb.5
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 23:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uhCUHiJ3NQLjO12EN5/6e175XnYVbxCKOCuW8JGzx2Y=;
        b=PaBe3blxX6slSxNyH2Gu9mOGzaaBjuefrWpEVGQVd4GACA+dKi6eKTftf00+3lk1kD
         YWI5JhNgE65QHN3U8PRVJMrmM3XYVFshekilmTmnencCfT38pQcwGVXbXowqUfaMGhwv
         /ZPCfQ7TUoKod32gmIDIUxbY2IxIDncbvq7mm+gFUqUb/4TaQ+uh/PtFg2owi29v+w3C
         UiYYBBEPkkSYzhCDL8aZXQ9aEMRWFzsy6QRva3GR9bF9GvCPvTwYCbvGPS5C/L5hRxTG
         dEfObaC3HMX/Y5xxVNaHAevvhdK4Z4ZvWvz1KQBZIhNDYm2Tw7TqQmTxaUmEsH+B5ki4
         vOYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uhCUHiJ3NQLjO12EN5/6e175XnYVbxCKOCuW8JGzx2Y=;
        b=RNCoRGIgEolgOcJCGhqaYhNaNk7anElncosmoGesEIHAeoBDieMBJ0PZ6Xp8ZENbWM
         VblNgIQ9aEfHPavMMy68DLa6Z9FD+dQ3Sz1kD7Fw6SXogqFjCDuKGMjvKwKmqCmjWJRr
         gUQmGibGZgoBWtie33AfA4QsSUP3Ul6Qjpt18O9AumyiXV3fNW7e5Doj9Bxj5PWyxVtd
         jbiWuWyWJjWso+RDX+7XEKiULUcbdZHoiLQEfzTbMPFliWzD7RRPenmhOuKkavPqpvMV
         A1/mmQql1xl6UqBIFKjFqkDoVOzUkofryIWAIJt6VFrMb8wgp4mfNCXBZDt3CJZyIQ7W
         61Ng==
X-Gm-Message-State: AOAM530ryY0DDqLLunVSKXKnrNusqYS7DhGqS/6I0KlL+gdDDchScWY/
        YGjfxtk7CdhYYwZYy4HINORR27IBC5VLUAKnAPv6MA==
X-Google-Smtp-Source: ABdhPJwVELrPPlOUusJ1jPT7vytcTDYev2vEzs1PtfVDicJL5oUpYVIuU8wsqwkxVoo9mcs1WkNSxw6+N3t7DMJ+TOc=
X-Received: by 2002:aa7:c952:: with SMTP id h18mr5199532edt.18.1632982919623;
 Wed, 29 Sep 2021 23:21:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210929025807.646589-1-ipylypiv@google.com>
In-Reply-To: <20210929025807.646589-1-ipylypiv@google.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 30 Sep 2021 08:21:49 +0200
Message-ID: <CAMGffEmwwGLySh_V2PgANWZ9-hqCuucfH22p+VXTmDyFDWoKRA@mail.gmail.com>
Subject: Re: [PATCH 1/2] scsi: pm80xx: Replace open coded check with dev_is_expander()
To:     Igor Pylypiv <ipylypiv@google.com>
Cc:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Vishakha Channapattan <vishakhavc@google.com>,
        Akshat Jain <akshatzen@google.com>,
        Changyuan Lyu <changyuanl@google.com>,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 29, 2021 at 4:58 AM Igor Pylypiv <ipylypiv@google.com> wrote:
>
> This is a follow up cleanup to the commit 924a3541eab0 ("scsi: libsas:
> aic94xx: hisi_sas: mvsas: pm8001: Use dev_is_expander()")
>
> Reviewed-by: Vishakha Channapattan <vishakhavc@google.com>
> Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c | 3 +--
>  drivers/scsi/pm8001/pm80xx_hwi.c | 3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index 63690508313b..b73d286bea60 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -4476,8 +4476,7 @@ static int pm8001_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
>                 if (pm8001_dev->dev_type == SAS_SATA_DEV)
>                         stp_sspsmp_sata = 0x00; /* stp*/
>                 else if (pm8001_dev->dev_type == SAS_END_DEVICE ||
> -                       pm8001_dev->dev_type == SAS_EDGE_EXPANDER_DEVICE ||
> -                       pm8001_dev->dev_type == SAS_FANOUT_EXPANDER_DEVICE)
> +                       dev_is_expander(pm8001_dev->dev_type))
>                         stp_sspsmp_sata = 0x01; /*ssp or smp*/
>         }
>         if (parent_dev && dev_is_expander(parent_dev->dev_type))
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 6ffe17b849ae..778b5fce876b 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -4825,8 +4825,7 @@ static int pm80xx_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
>                 if (pm8001_dev->dev_type == SAS_SATA_DEV)
>                         stp_sspsmp_sata = 0x00; /* stp*/
>                 else if (pm8001_dev->dev_type == SAS_END_DEVICE ||
> -                       pm8001_dev->dev_type == SAS_EDGE_EXPANDER_DEVICE ||
> -                       pm8001_dev->dev_type == SAS_FANOUT_EXPANDER_DEVICE)
> +                       dev_is_expander(pm8001_dev->dev_type))
>                         stp_sspsmp_sata = 0x01; /*ssp or smp*/
>         }
>         if (parent_dev && dev_is_expander(parent_dev->dev_type))
> --
> 2.33.0.685.g46640cef36-goog
>
