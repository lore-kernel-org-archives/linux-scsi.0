Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A965EE7FF4
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 08:11:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbjIKILb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 04:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbjIKILa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 04:11:30 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F607CA
        for <linux-scsi@vger.kernel.org>; Mon, 11 Sep 2023 01:11:23 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id 2adb3069b0e04-502b1bbe5c3so1942082e87.1
        for <linux-scsi@vger.kernel.org>; Mon, 11 Sep 2023 01:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1694419882; x=1695024682; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VMp0NS+1PaICBEz4whkfCkNrgovv7aaIvb7Im59/CmE=;
        b=UQ3dtVuHvUo6k0nt152kE8AElsY86trZF6fFNvibh4yd9+8fiKXkGsp/kQ71aUzUDN
         Tzt0/4po43BiRD3HBq4bo4k4rC4iL0ahy3cXn+f3E6jB5K8mNPjTUUj42aN81/hYHWN0
         3yRTZk6OOHdmZ+9CMTTJtB26EIZGqVcV0loil7A7oJ+EcpXQUAfmbQV+Ctjfu7+ryiZa
         bpPgtA+XpEzNZ2nT/kCg45qLGp2APh70nwgFvu360ueTfL/lrJ5+BjppiCuFkl82yaih
         pynpVIBguAGGqU5vgUKYIPLlcyB52VcW7HrKnq640Su/U45PEZLAwEUZCTtyigDLcOmP
         8LRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694419882; x=1695024682;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VMp0NS+1PaICBEz4whkfCkNrgovv7aaIvb7Im59/CmE=;
        b=ZSxuEYE960Cku5BCKO+5ewL6pApAibqlkYdvesrgWMgmuLu3POxKsVgg2OgkYrgCuQ
         BaTL2iPFN1nlGGdsxaS4Ewhm9zfqizu8B7HS1LrQPtDrRnu5mr/pciXvqaE6uE4DfkdF
         gdtnc5kBFcb2axxMtawV46MX9cqfJRfcMTiov081/rGVi6LrKCTt07mYfDs65ibRExvt
         M0AVZJaAEYFa4KL0f3ZDTdqxGR1/9Rn3qaFPH+HXYn44viZU25KKPAJe99U3+7hW/H7A
         INtwnmyfXtntf4rf5mxW99Dhnj3RoKYiSS0oIWKmSIQhwbO2GWct3UF95/SRtV6IDlnP
         7tyA==
X-Gm-Message-State: AOJu0YwUpBO+8SCvuiQi3KUCgpNclgSmj4Kj1A7Cff0bMNWnpvOf0hlR
        OdgbAYFK2O17oNj0rxK1yXQ6p82BstjKSArmjoJq8Q==
X-Google-Smtp-Source: AGHT+IE2MmkPT8dE97/x9KMcaY/+oJ87h21POjiX68A5C23KaXMZgzqzr4wG6YBgXSkXtxD1nAbEH6LazqSQFM6eyoM=
X-Received: by 2002:a05:6512:3d09:b0:4fe:3a57:7c90 with SMTP id
 d9-20020a0565123d0900b004fe3a577c90mr10079120lfv.19.1694419881776; Mon, 11
 Sep 2023 01:11:21 -0700 (PDT)
MIME-Version: 1.0
References: <20230911030207.242917-1-dlemoal@kernel.org> <20230911030207.242917-3-dlemoal@kernel.org>
In-Reply-To: <20230911030207.242917-3-dlemoal@kernel.org>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Mon, 11 Sep 2023 10:11:11 +0200
Message-ID: <CAMGffEm6d7+6kpiSjqmwMVYQ4rs5sHLTn9W+tySdvU83s0uT+w@mail.gmail.com>
Subject: Re: [PATCH 02/10] scsi: pm8001: Introduce pm8001_free_irq()
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 11, 2023 at 5:02=E2=80=AFAM Damien Le Moal <dlemoal@kernel.org>=
 wrote:
>
> Instead of repeating the same code twice in pm8001_pci_remove() and
> pm8001_pci_suspend() to free IRQs, introduuce the function
> pm8001_free_irq() to do that.
>
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 49 ++++++++++++++++++-------------
>  1 file changed, 28 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm80=
01_init.c
> index 443a3176c6c0..3b7d47cd70ba 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -274,6 +274,7 @@ static irqreturn_t pm8001_interrupt_handler_intx(int =
irq, void *dev_id)
>  }
>
>  static u32 pm8001_request_irq(struct pm8001_hba_info *pm8001_ha);
> +static void pm8001_free_irq(struct pm8001_hba_info *pm8001_ha);
>
>  /**
>   * pm8001_alloc - initiate our hba structure and 6 DMAs area.
> @@ -1057,6 +1058,24 @@ static u32 pm8001_request_irq(struct pm8001_hba_in=
fo *pm8001_ha)
>                            SHOST_TO_SAS_HA(pm8001_ha->shost));
>  }
>
> +static void pm8001_free_irq(struct pm8001_hba_info *pm8001_ha)
> +{
> +#ifdef PM8001_USE_MSIX
> +       struct pci_dev *pdev =3D pm8001_ha->pdev;
> +       int i;
> +
> +       for (i =3D 0; i < pm8001_ha->number_of_intr; i++)
> +               synchronize_irq(pci_irq_vector(pdev, i));
> +
> +       for (i =3D 0; i < pm8001_ha->number_of_intr; i++)
> +               free_irq(pci_irq_vector(pdev, i), &pm8001_ha->irq_vector[=
i]);
> +
> +       pci_free_irq_vectors(pdev);
> +#else
> +       free_irq(pm8001_ha->irq, pm8001_ha->sas);
> +#endif
> +}
> +
>  /**
>   * pm8001_pci_probe - probe supported device
>   * @pdev: pci device which kernel has been prepared for.
> @@ -1252,24 +1271,17 @@ static int pm8001_init_ccb_tag(struct pm8001_hba_=
info *pm8001_ha)
>  static void pm8001_pci_remove(struct pci_dev *pdev)
>  {
>         struct sas_ha_struct *sha =3D pci_get_drvdata(pdev);
> -       struct pm8001_hba_info *pm8001_ha;
> +       struct pm8001_hba_info *pm8001_ha =3D sha->lldd_ha;
>         int i, j;
> -       pm8001_ha =3D sha->lldd_ha;
> +
>         sas_unregister_ha(sha);
>         sas_remove_host(pm8001_ha->shost);
>         list_del(&pm8001_ha->list);
>         PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0xFF);
>         PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha);
>
> -#ifdef PM8001_USE_MSIX
> -       for (i =3D 0; i < pm8001_ha->number_of_intr; i++)
> -               synchronize_irq(pci_irq_vector(pdev, i));
> -       for (i =3D 0; i < pm8001_ha->number_of_intr; i++)
> -               free_irq(pci_irq_vector(pdev, i), &pm8001_ha->irq_vector[=
i]);
> -       pci_free_irq_vectors(pdev);
> -#else
> -       free_irq(pm8001_ha->irq, sha);
> -#endif
> +       pm8001_free_irq(pm8001_ha);
> +
>  #ifdef PM8001_USE_TASKLET
>         /* For non-msix and msix interrupts */
>         if ((!pdev->msix_cap || !pci_msi_enabled()) ||
> @@ -1309,7 +1321,8 @@ static int __maybe_unused pm8001_pci_suspend(struct=
 device *dev)
>         struct pci_dev *pdev =3D to_pci_dev(dev);
>         struct sas_ha_struct *sha =3D pci_get_drvdata(pdev);
>         struct pm8001_hba_info *pm8001_ha =3D sha->lldd_ha;
> -       int  i, j;
> +       int j;
> +
>         sas_suspend_ha(sha);
>         flush_workqueue(pm8001_wq);
>         scsi_block_requests(pm8001_ha->shost);
> @@ -1319,15 +1332,9 @@ static int __maybe_unused pm8001_pci_suspend(struc=
t device *dev)
>         }
>         PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0xFF);
>         PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha);
> -#ifdef PM8001_USE_MSIX
> -       for (i =3D 0; i < pm8001_ha->number_of_intr; i++)
> -               synchronize_irq(pci_irq_vector(pdev, i));
> -       for (i =3D 0; i < pm8001_ha->number_of_intr; i++)
> -               free_irq(pci_irq_vector(pdev, i), &pm8001_ha->irq_vector[=
i]);
> -       pci_free_irq_vectors(pdev);
> -#else
> -       free_irq(pm8001_ha->irq, sha);
> -#endif
> +
> +       pm8001_free_irq(pm8001_ha);
> +
>  #ifdef PM8001_USE_TASKLET
>         /* For non-msix and msix interrupts */
>         if ((!pdev->msix_cap || !pci_msi_enabled()) ||
> --
> 2.41.0
>
