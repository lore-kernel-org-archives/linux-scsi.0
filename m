Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69D16EE57DF
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 07:54:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233487AbjIKHyM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 03:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbjIKHyM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 03:54:12 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FAD2D9
        for <linux-scsi@vger.kernel.org>; Mon, 11 Sep 2023 00:54:07 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id 2adb3069b0e04-501ce655fcbso6516292e87.2
        for <linux-scsi@vger.kernel.org>; Mon, 11 Sep 2023 00:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1694418845; x=1695023645; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RhTYTWTzuxqkqrCwo9QGoe0JCZRDwm89I5O/cCtJNvg=;
        b=TxUyuvaxgWn2GkCEFt91ncLSSbnZZol0L11rZFNxm3Q58J8OG8g+pWY3iNjG8Szx8f
         mC2CPDfT2sZYRbXPJAFVDf2vRP42za9wunP6tuDsbI+noXQRQCZLO/pbcMU0qhrWiA9u
         TKfAKTAWwp3Lnz258eywFWXHz2SBJ7dUtjApr0xX1Ok0Uc7aHTaJlA8aU0zDCXfF9crg
         uZR4yXnTh96d3um1wQcts0gmc9/0Y3//l9OszIaE3EB+i2CPorWgbPMqA8nAROTzbggd
         smMp5YlL5DkwGd/PTwIrAhoWTGCtCZgv8LUDBQXsm69B71DegCqYr0t9dotWomgZJY8E
         geYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694418845; x=1695023645;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RhTYTWTzuxqkqrCwo9QGoe0JCZRDwm89I5O/cCtJNvg=;
        b=AIGlJLFAHWMT9YwH8Th5B8oRP4HmC0ewgjgMi7B3AmNiuiUKDEy2gGiHCIQpEjPbOw
         cgFWO31dVKC3FR42vGcneEkhpiETFmOV5HbZhmoZrF8cKKi8XqGFYpm7OyVRphNG8Z5X
         pNpziAMtCcIwi/C8jYCVX+Tq6vDmIki6qRJjdEXVJi7sZdidViO+SkZh07XwxVprjoFl
         JT6pvQCueH6cFqo5Pc5P/e/mlyrTvvHO2hy52xavBpRV9Y+d53gRE9qDwZzdvQqNPxCV
         s83QK1CT75zqz7Tit8ZYyj283GL9vuLepiFgCSXEtP3Dp1cIpTzZIOmpA8yVI48zNEHv
         p+Tw==
X-Gm-Message-State: AOJu0Yx4m1TebppftGzPVXXxHNfXkg2JwRdmtj/6J7JFSfet78QJGWs8
        wnp9WSLtJJhUK+nDDDcgu/HiR9yt7BWSAJ1CaG6lUGAdGGSSBONJ
X-Google-Smtp-Source: AGHT+IG5dRWyA/6kySQ1UbCWtXHZAoxSmt46R2hbrSuIH2rP2ocwe3clqKrSVCacTxqrEJUyo1Rsvr2JCrNaOAheEkE=
X-Received: by 2002:a05:6512:2824:b0:4fe:2d93:2b50 with SMTP id
 cf36-20020a056512282400b004fe2d932b50mr7833234lfb.31.1694418845555; Mon, 11
 Sep 2023 00:54:05 -0700 (PDT)
MIME-Version: 1.0
References: <20230911030207.242917-1-dlemoal@kernel.org> <20230911030207.242917-2-dlemoal@kernel.org>
In-Reply-To: <20230911030207.242917-2-dlemoal@kernel.org>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Mon, 11 Sep 2023 09:53:54 +0200
Message-ID: <CAMGffE=x5aQrDF62eiStLr40b21X1DdkuuR3x=C=gSbLOrT4rw@mail.gmail.com>
Subject: Re: [PATCH 01/10] scsi: pm8001: Setup IRQs on resume
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
> The function pm8001_pci_resume() only calls pm8001_request_irq() without
> calling pm8001_setup_irq(). This causes the IRQ allocation to fail,
> whihc leads all drives being removed from the system.
>
> Fix this issue by integrating the code for pm8001_setup_irq() directly
> inside pm8001_request_irq() so that msix setup is performed both during
> normal initialization and resume operations.
>
> Fixes: dbf9bfe61571 ("[SCSI] pm8001: add SAS/SATA HBA driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
lgtm, thx!
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 51 +++++++++++--------------------
>  1 file changed, 17 insertions(+), 34 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm80=
01_init.c
> index 5e5ce1e74c3b..443a3176c6c0 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -273,7 +273,6 @@ static irqreturn_t pm8001_interrupt_handler_intx(int =
irq, void *dev_id)
>         return ret;
>  }
>
> -static u32 pm8001_setup_irq(struct pm8001_hba_info *pm8001_ha);
>  static u32 pm8001_request_irq(struct pm8001_hba_info *pm8001_ha);
>
>  /**
> @@ -294,13 +293,6 @@ static int pm8001_alloc(struct pm8001_hba_info *pm80=
01_ha,
>         pm8001_dbg(pm8001_ha, INIT, "pm8001_alloc: PHY:%x\n",
>                    pm8001_ha->chip->n_phy);
>
> -       /* Setup Interrupt */
> -       rc =3D pm8001_setup_irq(pm8001_ha);
> -       if (rc) {
> -               pm8001_dbg(pm8001_ha, FAIL,
> -                          "pm8001_setup_irq failed [ret: %d]\n", rc);
> -               goto err_out;
> -       }
>         /* Request Interrupt */
>         rc =3D pm8001_request_irq(pm8001_ha);
>         if (rc)
> @@ -1031,47 +1023,38 @@ static u32 pm8001_request_msix(struct pm8001_hba_=
info *pm8001_ha)
>  }
>  #endif
>
> -static u32 pm8001_setup_irq(struct pm8001_hba_info *pm8001_ha)
> -{
> -       struct pci_dev *pdev;
> -
> -       pdev =3D pm8001_ha->pdev;
> -
> -#ifdef PM8001_USE_MSIX
> -       if (pci_find_capability(pdev, PCI_CAP_ID_MSIX))
> -               return pm8001_setup_msix(pm8001_ha);
> -       pm8001_dbg(pm8001_ha, INIT, "MSIX not supported!!!\n");
> -#endif
> -       return 0;
> -}
> -
>  /**
>   * pm8001_request_irq - register interrupt
>   * @pm8001_ha: our ha struct.
>   */
>  static u32 pm8001_request_irq(struct pm8001_hba_info *pm8001_ha)
>  {
> -       struct pci_dev *pdev;
> +       struct pci_dev *pdev =3D pm8001_ha->pdev;
> +#ifdef PM8001_USE_MSIX
>         int rc;
>
> -       pdev =3D pm8001_ha->pdev;
> +       if (pci_find_capability(pdev, PCI_CAP_ID_MSIX)) {
> +               rc =3D pm8001_setup_msix(pm8001_ha);
> +               if (rc) {
> +                       pm8001_dbg(pm8001_ha, FAIL,
> +                                  "pm8001_setup_irq failed [ret: %d]\n",=
 rc);
> +                       return rc;
> +               }
>
> -#ifdef PM8001_USE_MSIX
> -       if (pdev->msix_cap && pci_msi_enabled())
> -               return pm8001_request_msix(pm8001_ha);
> -       else {
> -               pm8001_dbg(pm8001_ha, INIT, "MSIX not supported!!!\n");
> -               goto intx;
> +               if (pdev->msix_cap && pci_msi_enabled())
> +                       return pm8001_request_msix(pm8001_ha);
>         }
> +
> +       pm8001_dbg(pm8001_ha, INIT, "MSIX not supported!!!\n");
>  #endif
>
> -intx:
>         /* initialize the INT-X interrupt */
>         pm8001_ha->irq_vector[0].irq_id =3D 0;
>         pm8001_ha->irq_vector[0].drv_inst =3D pm8001_ha;
> -       rc =3D request_irq(pdev->irq, pm8001_interrupt_handler_intx, IRQF=
_SHARED,
> -               pm8001_ha->name, SHOST_TO_SAS_HA(pm8001_ha->shost));
> -       return rc;
> +
> +       return request_irq(pdev->irq, pm8001_interrupt_handler_intx,
> +                          IRQF_SHARED, pm8001_ha->name,
> +                          SHOST_TO_SAS_HA(pm8001_ha->shost));
>  }
>
>  /**
> --
> 2.41.0
>
