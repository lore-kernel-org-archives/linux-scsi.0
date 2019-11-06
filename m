Return-Path: <SRS0=TWTx=Y6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73EEBC5DF62
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 10:52:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F4BE2173E
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 10:52:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="MZH/6HS9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbfKFKwv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Nov 2019 05:52:51 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:43170 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725856AbfKFKwu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Nov 2019 05:52:50 -0500
Received: by mail-io1-f68.google.com with SMTP id c11so26432704iom.10
        for <linux-scsi@vger.kernel.org>; Wed, 06 Nov 2019 02:52:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YxRHfPn6q8vDBdVBGG1jiNVBofjSVOf1SpgVpGT8YwQ=;
        b=MZH/6HS9uO0smUtBYapdAf0f2d5m5mH1xcwS9yJcppCmIA++8JydxX4AZCqNfITlsc
         To3i9HAL0ZSRX0Y8x2MtIfv6da6UGr3QKZKR8vPKzrA7AxL/ktxFZp8Pj9u1jiBPrV1v
         0woKezUQtO0ODmCAd2IX+uzLKHzIn2DMiSfUncDnnxaMjwAb9x2kPJz6g96Bczp4LPds
         9Xh7Xx1XCqj6bSnk9SzVlU6AA36kk+1yQIPq+VLjff4G5+mebnfzhnfLFc+k9wWVe9+/
         k/D5GEfg2H5qlCCUASOx8BK9iKliAmN5C2MpFLcnxMSYAtkwbN3WgPvvtLBAKU97DMZu
         dBSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YxRHfPn6q8vDBdVBGG1jiNVBofjSVOf1SpgVpGT8YwQ=;
        b=RdibJM1ZBPRNuk+s3HeQfD/h5Iwh2gIFA5Or96hELdnAURMHdZPJvcLqwfPAic/zQa
         VTUY5NVxGaO36Nmou43g4EUe2fhsVZkJ8oy6mL3e2T8qdfY4R6ATSdk+sgJruK8IwzQ3
         SKHQ2RchaIUoHzfSSnHLBi7FVBx3F8h9wqk9m+QKevgc9AAO4WwNK4H6zblRYZhJG+4E
         GpnugxHy4ngXs63oKzANrNFHzLiDgy9642UdEAMGalQEhjwOu1G9tI0kVEDW0XWoGDwU
         mk7MLK7HpWSIQjhrzgAlubMBMwO6MS84Ua0Uqhfwwq2AA/YfyY2PlKxgGevE3NMPgdWz
         FinA==
X-Gm-Message-State: APjAAAW7pJifKf8FdqfIXpO4K6R1cgm8nB7Vdu485CD0ym/tCH9uZ+DU
        Pi98z+Yi5/GNMNMJohaC6Th4LnDdbq3xlV7nHKt/RQ==
X-Google-Smtp-Source: APXvYqwcfNu2/rWFUVeUXbGx0AZ+ujb2nkqDh4uoeem1oEnSg9LUa8HdYq/krZVT3UHGY97kKd7jr8gW6WkyH9IKYAQ=
X-Received: by 2002:a5d:80d5:: with SMTP id h21mr29051503ior.298.1573037568553;
 Wed, 06 Nov 2019 02:52:48 -0800 (PST)
MIME-Version: 1.0
References: <20191031051241.6762-1-deepak.ukey@microchip.com> <20191031051241.6762-12-deepak.ukey@microchip.com>
In-Reply-To: <20191031051241.6762-12-deepak.ukey@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Wed, 6 Nov 2019 11:52:37 +0100
Message-ID: <CAMGffE=FHGOLrCrXE6fmC-6fMcp71xLvL6u2O+-Xfb4GT7QxOw@mail.gmail.com>
Subject: Re: [PATCH 11/12] pm80xx : Tie the interrupt name to the module instance.
To:     Deepak Ukey <deepak.ukey@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com, Viswas.G@microchip.com,
        Jack Wang <jinpu.wang@profitbricks.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>, dpf@google.com,
        jsperbeck@google.com, Vikram Auradkar <auradkar@google.com>,
        ianyar@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 31, 2019 at 6:12 AM Deepak Ukey <deepak.ukey@microchip.com> wrote:
>
> From: Vikram Auradkar <auradkar@google.com>
>
> With msix enabled, the interrupt instances are <prefix><index> where
> the prefix is fixed for all module instances, making it a little
> harder to track down what's what.
>
> Signed-off-by: Vikram Auradkar <auradkar@google.com>
> Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
Looks fine.
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 11 ++++++-----
>  drivers/scsi/pm8001/pm8001_sas.h  |  2 ++
>  2 files changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index 86b619d10392..485f0afc53f9 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -894,7 +894,6 @@ static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha)
>         u32 number_of_intr;
>         int flag = 0;
>         int rc;
> -       static char intr_drvname[PM8001_MAX_MSIX_VEC][sizeof(DRV_NAME)+3];
>
>         /* SPCv controllers supports 64 msi-x */
>         if (pm8001_ha->chip_id == chip_8001) {
> @@ -915,14 +914,16 @@ static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha)
>                                 rc, pm8001_ha->number_of_intr));
>
>         for (i = 0; i < number_of_intr; i++) {
> -               snprintf(intr_drvname[i], sizeof(intr_drvname[0]),
> -                               DRV_NAME"%d", i);
> +               snprintf(pm8001_ha->intr_drvname[i],
> +                       sizeof(pm8001_ha->intr_drvname[0]),
> +                       "%s-%d", pm8001_ha->name, i);
>                 pm8001_ha->irq_vector[i].irq_id = i;
>                 pm8001_ha->irq_vector[i].drv_inst = pm8001_ha;
>
>                 rc = request_irq(pci_irq_vector(pm8001_ha->pdev, i),
>                         pm8001_interrupt_handler_msix, flag,
> -                       intr_drvname[i], &(pm8001_ha->irq_vector[i]));
> +                       pm8001_ha->intr_drvname[i],
> +                       &(pm8001_ha->irq_vector[i]));
>                 if (rc) {
>                         for (j = 0; j < i; j++) {
>                                 free_irq(pci_irq_vector(pm8001_ha->pdev, i),
> @@ -963,7 +964,7 @@ static u32 pm8001_request_irq(struct pm8001_hba_info *pm8001_ha)
>         pm8001_ha->irq_vector[0].irq_id = 0;
>         pm8001_ha->irq_vector[0].drv_inst = pm8001_ha;
>         rc = request_irq(pdev->irq, pm8001_interrupt_handler_intx, IRQF_SHARED,
> -               DRV_NAME, SHOST_TO_SAS_HA(pm8001_ha->shost));
> +               pm8001_ha->name, SHOST_TO_SAS_HA(pm8001_ha->shost));
>         return rc;
>  }
>
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
> index f7be7b85624e..a55b03bca529 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -541,6 +541,8 @@ struct pm8001_hba_info {
>         struct pm8001_ccb_info  *ccb_info;
>  #ifdef PM8001_USE_MSIX
>         int                     number_of_intr;/*will be used in remove()*/
> +       char                    intr_drvname[PM8001_MAX_MSIX_VEC]
> +                               [PM8001_NAME_LENGTH+1+3+1];
>  #endif
>  #ifdef PM8001_USE_TASKLET
>         struct tasklet_struct   tasklet[PM8001_MAX_MSIX_VEC];
> --
> 2.16.3
>
