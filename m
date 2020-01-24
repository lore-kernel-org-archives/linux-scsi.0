Return-Path: <SRS0=sMUn=3N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBC8CC2D0DB
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 12:38:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B06702077C
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 12:38:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="CouIZOxj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730291AbgAXMiP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jan 2020 07:38:15 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:35700 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729774AbgAXMiO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jan 2020 07:38:14 -0500
Received: by mail-ot1-f67.google.com with SMTP id r16so1459331otd.2
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jan 2020 04:38:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+dfFTmI5N3Q5lWszucBNEkDgT5Y9cxbXu/d3Aq4kIuk=;
        b=CouIZOxjnJTH+rRQDTW8j2RqyZdtthc9jvMIb6vru4ZPO6cXs+wC7+grkq0BXVsIGY
         OKjrA3XN0tSPkb9btQRS1YHPcuCMYCuYeR67Y/+AtzZuoDfnTdvkssafbF8YjGT6pN5F
         IC60JTFt3r5lMlDVCN0pg8cDpc62jR6/2pvM8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+dfFTmI5N3Q5lWszucBNEkDgT5Y9cxbXu/d3Aq4kIuk=;
        b=IWAaOYDs3bmky6xQFMt98gge0Ywc0DA4oVjUoP9MgWR7CaL1s6JMT55ej22qR6otQr
         XWe/RP5E+Nf6bD56/k50jGvr9xSaGX6uLerLB34tY8RxA6xCoz1/S05Q4qaHSZ5w1gnk
         Lg5Tw3lB2UOswC4tfvGALwT4dF5MrBRzeiT2HkHFWxjuNGpaRXp2HLjdSL9cVfHFK0AE
         plqb1P5KqTzHWccFURzgviSrVHpqXYtWmi4ZoUrFNl40MNmUqVg47JKLZf4D9RJGIUbB
         OIq5u8bFzQHkG1WMEn6wUlhJ06QVurX6yKv91QvcnSTQASVavFKQJRh5kTgrrqNhaabi
         TD8A==
X-Gm-Message-State: APjAAAXnRjKm5UW4Hnjl94lB5bhnV1980ha2MsUQ9dPQMhxZKL15qphj
        wvuX7VIDHlsS6fM+XhWtk0x4/DvOs56IVdYpu90c1Q==
X-Google-Smtp-Source: APXvYqzzV0eImCMFgQvyNcLIZdYRsXSEtyOYABPGGi+tL/JNcmIm1uXw1cbZLwIKBRX9Smf13ba028BWnrIPoSRHlK0=
X-Received: by 2002:a05:6830:1248:: with SMTP id s8mr2499242otp.202.1579869493800;
 Fri, 24 Jan 2020 04:38:13 -0800 (PST)
MIME-Version: 1.0
References: <20200113132609.69536-1-hare@suse.de>
In-Reply-To: <20200113132609.69536-1-hare@suse.de>
From:   Sumit Saxena <sumit.saxena@broadcom.com>
Date:   Fri, 24 Jan 2020 18:07:46 +0530
Message-ID: <CAL2rwxryXx0MkMAE2jbzGdeuvsY09g_UvuOfAC7qqFJ2k1LS=Q@mail.gmail.com>
Subject: Re: [PATCH] megaraid_sas: fixup MSIx interrupt setup during resume
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jan 13, 2020 at 6:56 PM Hannes Reinecke <hare@suse.de> wrote:
>
> Streamline resume workflow by using the same functions for enabling
> MSIx interrupts as used during initialisation.
> Without it the driver might crash during resume with:
>
> WARNING: CPU: 2 PID: 4306 at ../drivers/pci/msi.c:1303 pci_irq_get_affinity+0x3b/0x90
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
Looks good, thank you.
Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>

> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 20 +++++++++-----------
>  1 file changed, 9 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index a4bc81479284..ec58244c680c 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -7592,7 +7592,6 @@ megasas_resume(struct pci_dev *pdev)
>         int rval;
>         struct Scsi_Host *host;
>         struct megasas_instance *instance;
> -       int irq_flags = PCI_IRQ_LEGACY;
>
>         instance = pci_get_drvdata(pdev);
>
> @@ -7634,16 +7633,15 @@ megasas_resume(struct pci_dev *pdev)
>         atomic_set(&instance->ldio_outstanding, 0);
>
>         /* Now re-enable MSI-X */
> -       if (instance->msix_vectors) {
> -               irq_flags = PCI_IRQ_MSIX;
> -               if (instance->smp_affinity_enable)
> -                       irq_flags |= PCI_IRQ_AFFINITY;
> -       }
> -       rval = pci_alloc_irq_vectors(instance->pdev, 1,
> -                                    instance->msix_vectors ?
> -                                    instance->msix_vectors : 1, irq_flags);
> -       if (rval < 0)
> -               goto fail_reenable_msix;
> +       if (instance->msix_vectors)
> +               megasas_alloc_irq_vectors(instance);
> +
> +       if (!instance->msix_vectors) {
> +               rval = pci_alloc_irq_vectors(instance->pdev, 1, 1,
> +                                            PCI_IRQ_LEGACY);
> +               if (rval < 0)
> +                       goto fail_reenable_msix;
> +       }
>
>         megasas_setup_reply_map(instance);
>
> --
> 2.16.4
>
