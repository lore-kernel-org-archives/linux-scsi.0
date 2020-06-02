Return-Path: <SRS0=e+HO=7P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98AB7C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Jun 2020 15:41:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77440207F7
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Jun 2020 15:41:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D9QcqhuJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgFBPlw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Jun 2020 11:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgFBPlw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jun 2020 11:41:52 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA73C08C5C0;
        Tue,  2 Jun 2020 08:41:51 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id 5so1652514pjd.0;
        Tue, 02 Jun 2020 08:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KX3c8fO2lYmMAt3OHtw1oi3ANcKudMTPhDF4G19EAAQ=;
        b=D9QcqhuJEs2IrQoossyHxDHpRLIgGEuV2VVn3QgJFExUkI9juh3QwN9GWer3diuRDy
         7siCDZt6f8VBGxRGNJqQYeI8SCDcgDwlZTGrWwKMnN7TFj9Vjy7rr97Was3jcYAYhEG2
         waP+7kczrlXSed6+WY97dB0u/PE9DfbFI6y2Yuqd1MzzzSMpK4KgSF9U5Y8ajovHGxcw
         YcKdAngDGAKT3spA6jymicSn4ktlmwzWN+PQttF33jjGpCXXtOB+njSspFX/HDrLsvTL
         KxPiOcSNAlRY7VewKLMDNfkA2RBt+x+UCAdJNicwgUQjRiqS9e88b1k9CB8mX8EgGfnM
         Ey5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KX3c8fO2lYmMAt3OHtw1oi3ANcKudMTPhDF4G19EAAQ=;
        b=idQY6QXQHHtEOIj8dGUUAuQjpp7jPQSAsH6rvTCoSIHFyvHx57tyZk9SLxb5ydlL66
         ObWgwi9S7aoUKNPwu7Ek76GRVThuLKvhNRV7a64GK+kwC/+dFLNOPbLwehKv3RkcVn3D
         1vGmpBVUqTRTptJepFTf6WhkMu8fKKifjr1PvwDPCDnBvJC9Df0oAAxUe916cl0dpS4k
         kiVED601KanoYQbwVFqu7eW5jewq7chiTDG+ne8lmjMzV35Yh/xESwv8ZrXtls5zm4WU
         Y7tGzdQOboqvEvyVrxaIhtGzhOvhkKzWJt4CS3YZTsotQTwG2E4Y6FvGRCNjrSyB6nSG
         Qg0Q==
X-Gm-Message-State: AOAM531D7An0bf8OBcGifemEcoEC2T9VVMoJhQ6rNJHD8pkjr6f6l0cu
        kuaZ19TLLjBK5eZcOTO38NbRbK6lelTFB7ly1ks=
X-Google-Smtp-Source: ABdhPJzwm8nE1kIQ/TKnWve0lieKdz/G0UN93sdbs2pWw8NsR1KluU9+qRq6EZWRMM9F/lSx94o0wiPVBNn36jHFkp8=
X-Received: by 2002:a17:902:bb95:: with SMTP id m21mr13540578pls.262.1591112510781;
 Tue, 02 Jun 2020 08:41:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200602092126.32327-1-piotr.stankiewicz@intel.com>
In-Reply-To: <20200602092126.32327-1-piotr.stankiewicz@intel.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 2 Jun 2020 18:41:39 +0300
Message-ID: <CAHp75Vcw6tJkq72UHuV=YW__J__baSqFv2dy1akr=RrM5itMfg@mail.gmail.com>
Subject: Re: [PATCH 15/15] scsi: use PCI_IRQ_MSI_TYPES and PCI_IRQ_ALL_TYPES
 where appropriate
To:     Piotr Stankiewicz <piotr.stankiewicz@intel.com>
Cc:     Brian King <brking@us.ibm.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jim Gill <jgill@vmware.com>,
        VMware PV-Drivers <pv-drivers@vmware.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jun 2, 2020 at 12:24 PM Piotr Stankiewicz
<piotr.stankiewicz@intel.com> wrote:
>
> Seeing as there is shorthand available to use when asking for any type
> of interrupt, or any type of message signalled interrupt, leverage it.

>         irq_flag = PCI_IRQ_LEGACY;
>         if (ioa_cfg->ipr_chip->has_msi)
> -               irq_flag |= PCI_IRQ_MSI | PCI_IRQ_MSIX;
> +               irq_flag |= PCI_IRQ_MSI_TYPES;

Perhaps

       if (ioa_cfg->ipr_chip->has_msi)
               irq_flag = PCI_IRQ_ALL_TYPES;
       else
               irq_flag = PCI_IRQ_LEGACY;

?

>         rc = pci_alloc_irq_vectors(pdev, 1, ipr_number_of_msix, irq_flag);
>         if (rc < 0) {
>                 ipr_wait_for_pci_err_recovery(ioa_cfg);
> diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
> index c3f010df641e..825b7db9c713 100644
> --- a/drivers/scsi/vmw_pvscsi.c
> +++ b/drivers/scsi/vmw_pvscsi.c
> @@ -1347,7 +1347,7 @@ static u32 pvscsi_get_max_targets(struct pvscsi_adapter *adapter)
>
>  static int pvscsi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  {
> -       unsigned int irq_flag = PCI_IRQ_MSIX | PCI_IRQ_MSI | PCI_IRQ_LEGACY;
> +       unsigned int irq_flag = PCI_IRQ_ALL_TYPES;
>         struct pvscsi_adapter *adapter;
>         struct pvscsi_adapter adapter_temp;
>         struct Scsi_Host *host = NULL;
> --
> 2.17.2
>


-- 
With Best Regards,
Andy Shevchenko
