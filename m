Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18040C432BE
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Aug 2021 08:25:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04039604D7
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Aug 2021 08:25:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234822AbhH3I0J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Aug 2021 04:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234341AbhH3I0I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Aug 2021 04:26:08 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BDC7C061575
        for <linux-scsi@vger.kernel.org>; Mon, 30 Aug 2021 01:25:15 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id t19so29373342ejr.8
        for <linux-scsi@vger.kernel.org>; Mon, 30 Aug 2021 01:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KEK4WBNfpkjXSiV75GvcVvTk4n69HkWVWswXmeCALrU=;
        b=hZbN4XRtnLCMSQQUqTWcRTIw9Ux7I33tmP/tszbuFWis6EQyoVf3lF2WC1lLfZST/L
         8tReRuuQAYQsDlGoyRbYaHNZJznDUlnNRHqDuO3+q3ifvmQ4LSDZKqWthgw0ClsY1r4d
         k/LHoR+7tyZw2wLcJYJCNmJXyKTZRXRfSBDxQKlofwxFqErmIDAXF/KySRUXxeWITBku
         ItpoccOfjmmSxSL3pfhZOIlo1FSKeTdk2b6iHtEl/FxElbzZpNGZXrzYEPMusdVrUJp2
         rpYgOXsRAQye7DK8fsiX3gVgNhHL5s2TgwlG1m6kqSdcgVa//rn2nLJ1kkypsX9SqKgH
         O6SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KEK4WBNfpkjXSiV75GvcVvTk4n69HkWVWswXmeCALrU=;
        b=cs2ec81UUn9t76pQxJyihPiArPkL4hmiJVXBEqlyBHq/eFu0mpBo//zIlx0akgCH8D
         zR2rI4cQiq4BzTIhsG4iqID9AdqJNGKBXuNzilvhNdey6PO+Igjsh4lqh9q3MgbXcnl0
         CU2AEMcyNwTQt7GMjtyEEPxcgWrai7PFodX/Oc9Vo86HV8vSkH0AaVJwOiPUFlGPQOAO
         sls7dPVXTT6Wj0XMPtPEGkoyEGkEK7MJizJOpgBf+jtQ72ZUWcUh0aTvtMFD2FEemZde
         0t2HBCvAyJR60Sc4WsKMgbZ52G6OyEtpZYtKCdcwpHEqwdXCypiRPE/HBwi5+n96wzkO
         v6Pw==
X-Gm-Message-State: AOAM533mvRnsv34mderYTap3mwrC/fm9j+KN1b2m9DPnFWjm5bji1UtN
        2nUAHI87NUELrei9uGBcjN+oBle3j4VJDSQr8eQ5yA==
X-Google-Smtp-Source: ABdhPJzFgl0Cs8ftoQw0yx+Zc3nNedXSuOT0bdSDh+Nqra4SgakqDboBAimwVpuFtu4Fa70oXwaWOZl2IN/kUOKvanY=
X-Received: by 2002:a17:907:384:: with SMTP id ss4mr23636236ejb.478.1630311914138;
 Mon, 30 Aug 2021 01:25:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210823082338.67309-1-Ajish.Koshy@microchip.com> <20210823082338.67309-5-Ajish.Koshy@microchip.com>
In-Reply-To: <20210823082338.67309-5-Ajish.Koshy@microchip.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Mon, 30 Aug 2021 10:25:03 +0200
Message-ID: <CAMGffEmzYfp9BjDpjfckPwjGwreAtD9sz7u5fr+h7XJYpbkJRg@mail.gmail.com>
Subject: Re: [PATCH 4/4] scsi: pm80xx: fix memory leak during rmmod
To:     Ajish Koshy <Ajish.Koshy@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas G <Viswas.G@microchip.com>,
        Ruksar Devadi <Ruksar.devadi@microchip.com>,
        Ashokkumar N <Ashokkumar.N@microchip.com>,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 23, 2021 at 9:28 AM Ajish Koshy <Ajish.Koshy@microchip.com> wrote:
>
> Driver fails to release memory allocated. This will lead
> to memory leak during driver removal.
>
> Signed-off-by: Ajish Koshy <Ajish.Koshy@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
looks ok.
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 11 +++++++++++
>  drivers/scsi/pm8001/pm8001_sas.h  |  1 +
>  2 files changed, 12 insertions(+)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index 613455a3e686..7082fecf7ce8 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -1199,6 +1199,7 @@ pm8001_init_ccb_tag(struct pm8001_hba_info *pm8001_ha, struct Scsi_Host *shost,
>                 goto err_out;
>
>         /* Memory region for ccb_info*/
> +       pm8001_ha->ccb_count = ccb_count;
>         pm8001_ha->ccb_info =
>                 kcalloc(ccb_count, sizeof(struct pm8001_ccb_info), GFP_KERNEL);
>         if (!pm8001_ha->ccb_info) {
> @@ -1260,6 +1261,16 @@ static void pm8001_pci_remove(struct pci_dev *pdev)
>                         tasklet_kill(&pm8001_ha->tasklet[j]);
>  #endif
>         scsi_host_put(pm8001_ha->shost);
> +
> +       for (i = 0; i < pm8001_ha->ccb_count; i++) {
> +               dma_free_coherent(&pm8001_ha->pdev->dev,
> +                       sizeof(struct pm8001_prd) * PM8001_MAX_DMA_SG,
> +                       pm8001_ha->ccb_info[i].buf_prd,
> +                       pm8001_ha->ccb_info[i].ccb_dma_handle);
> +       }
> +       kfree(pm8001_ha->ccb_info);
> +       kfree(pm8001_ha->devices);
> +
>         pm8001_free(pm8001_ha);
>         kfree(sha->sas_phy);
>         kfree(sha->sas_port);
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
> index 3274d88a9ccc..7e999768bfd2 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -518,6 +518,7 @@ struct pm8001_hba_info {
>         u32                     iomb_size; /* SPC and SPCV IOMB size */
>         struct pm8001_device    *devices;
>         struct pm8001_ccb_info  *ccb_info;
> +       u32                     ccb_count;
>  #ifdef PM8001_USE_MSIX
>         int                     number_of_intr;/*will be used in remove()*/
>         char                    intr_drvname[PM8001_MAX_MSIX_VEC]
> --
> 2.27.0
>
