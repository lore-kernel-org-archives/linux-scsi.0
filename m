Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EF4EC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 23 May 2022 12:52:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235725AbiEWMwW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 May 2022 08:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235775AbiEWMwN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 May 2022 08:52:13 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 981E34C41A
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 05:52:12 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id b135so1862903pfb.12
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 05:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hpPfvtBO8Ax24zHrikSzJYR4bEW9NmTM88PqNgTW5sk=;
        b=CvY+S0QfMa+VIvK5yMmQvgVcidOxaqgSFgFGGf6Xx6jZWSvYvE+RZq+H8xayIoYCR+
         3QevIsV6xkzsZwDUBwPs4OLLS7ZEIeyS+ZuxLYqTgEdduyOE695iHrSBKrpbMF+3aD41
         bHKUZUNdNq1OG/edhhEKXCpp+tvnJA+5VLJeRZsSVuLQ7FNCcnRM7CxR7bYS5XNQlU0c
         gvElWv27T3OAB4tiVwhqFi0pD3sL0+8P+P9n1fm074T8W5u1bCbqJHrmybVtFY5/E8BV
         ACl669t8oK0LPBbK35WwJGY6fAh1TDdoiIlYzxohCpZVsq4IGNeNYaEDmNfZUdbDU0Ky
         KeDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hpPfvtBO8Ax24zHrikSzJYR4bEW9NmTM88PqNgTW5sk=;
        b=AtIad5e2i7/fi2nwc4mAP/x8ETsIUy3HQmFlJS8FDz4oPeFhTYVA6T2L+gw/g0dYGD
         ubmYZ1wlLhfWi8hdon3GCqgo51KGwHmSLDDAWQVo83Iltfj06+dzo0/SISAzfSVuOMMp
         8prEATSFeeF2dXd1nDFdjWRBFFWwJio7vpsMKuOeruYKmEyCEAI1+H+77WNEJomMy6yw
         UYOawn8P/oW3Y/d4LCQ1EYivgs1fNAJmTU5K23iTLvB18LZ6l2UmJQamHI8NBkkfm6yA
         H6TaAPIDOntoCW/0oVdasYrdlo5gQHZizKl3UZHlv1VG6ZzUUfwd2YBmkwareKdZFSle
         8HMQ==
X-Gm-Message-State: AOAM532Wnu98+xviy5Aib9GIVFTe1+2yBenJBOHM6teuceS8PMLGvYY2
        uzlo+Zlbcd+8bYNcpgX62FPJw/xij2LKd0HXzv8Co8JUz9DSiswgqQ==
X-Google-Smtp-Source: ABdhPJwc0QnmASZ+93dkpbckcP8hij2k9P6onS7/Eyugm1J+Uq7w90ztF1dqYFITtOvIo3InddR433naeOooFaipVZg=
X-Received: by 2002:a63:9043:0:b0:3f9:6c36:3de3 with SMTP id
 a64-20020a639043000000b003f96c363de3mr12720914pge.616.1653310332205; Mon, 23
 May 2022 05:52:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220523120244.99515-1-hare@suse.de>
In-Reply-To: <20220523120244.99515-1-hare@suse.de>
From:   Zheyu Ma <zheyuma97@gmail.com>
Date:   Mon, 23 May 2022 20:52:01 +0800
Message-ID: <CAMhUBjnG2kphf6Ue8LgnoXGnP4dB4ErS3DF6YqTBQjvCn0UXJg@mail.gmail.com>
Subject: Re: [PATCHv2] myrb: fixup null pointer access on myrb_cleanup()
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, May 23, 2022 at 8:02 PM Hannes Reinecke <hare@suse.de> wrote:
>
> When myrb_probe() fails the callback might not be set, so we need
> to validate the 'disable_intr' callback in myrb_cleanup() to not
> cause a null pointer exception. And while at it do not call
> myrb_cleanup() if we cannot enable the PCI device at all.
>
> Reported-by: Zheyu Ma <zheyuma97@gmail.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/myrb.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
> index 71585528e8db..e885c1dbf61f 100644
> --- a/drivers/scsi/myrb.c
> +++ b/drivers/scsi/myrb.c
> @@ -1239,7 +1239,8 @@ static void myrb_cleanup(struct myrb_hba *cb)
>         myrb_unmap(cb);
>
>         if (cb->mmio_base) {
> -               cb->disable_intr(cb->io_base);
> +               if (cb->disable_intr)
> +                       cb->disable_intr(cb->io_base);
>                 iounmap(cb->mmio_base);
>         }
>         if (cb->irq)
> @@ -3413,9 +3414,13 @@ static struct myrb_hba *myrb_detect(struct pci_dev *pdev,
>         mutex_init(&cb->dcmd_mutex);
>         mutex_init(&cb->dma_mutex);
>         cb->pdev = pdev;
> +       cb->host = shost;
>
> -       if (pci_enable_device(pdev))
> -               goto failure;
> +       if (pci_enable_device(pdev)) {
> +               dev_err(&pdev->dev, "Failed to enable PCI device\n");
> +               scsi_host_put(shost);
> +               return NULL;
> +       }
>
>         if (privdata->hw_init == DAC960_PD_hw_init ||
>             privdata->hw_init == DAC960_P_hw_init) {
> --
> 2.29.2

This patch works for me, Thanks!

Tested-by: Zheyu Ma <zheyuma97@gmail.com>

Zheyu Ma
