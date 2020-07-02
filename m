Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7173DC433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 07:45:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EDED20899
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 07:45:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="RKGntSkt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbgGBHpb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jul 2020 03:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgGBHpa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jul 2020 03:45:30 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A31DC08C5C1
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2020 00:45:30 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id t18so10650614otq.5
        for <linux-scsi@vger.kernel.org>; Thu, 02 Jul 2020 00:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F6b1fdLcGyEuxA/bOxQKPbF0BlCezKZJkWl8sSFYzWY=;
        b=RKGntSkt3LbGFYc4/L1iOlH4FAmUtEmhQWLBdRZo9RtGtaP9DfQCm+aoyz4ZjTlAw8
         9KR/o+T+uyQI3YYMzCq6rTkI3G9eizzntdKszTZTy8dUYoqntyVuqtbrL30R0rbjrfqI
         ldBiIdT+ATz/r47UEtUXjxugYQR7K0TCFlzDw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F6b1fdLcGyEuxA/bOxQKPbF0BlCezKZJkWl8sSFYzWY=;
        b=k0Ciig8Qy3PidjXpVZ18f9zY1DkFNs29+kZaFkfAmueOhacWwwMPAtwiVh3mmc9/Ez
         eiA8m2XSbdBfahjmN0pZvhAHBe/IcayHKie22MVZPQR3BUQCpR3bIkd0LBwJaFjr4r7M
         nV8xaBHLFgVnbImCu+HW1dWzeFIIPX14AYFakhpAqVG5b+5WyhRhFzLd5XF/6l6bdqAz
         03hRwYlUoXdZSs5MxZMDoB6kZdh8zfkDmdEcJ8m6wY3fcYNFsK9fVYL5WWvGiPqXDYH4
         uxAnd91+tHhsNDHQ5GVC1JxgzUHW9R33aShXyRHqGPq7WzUHBTWYztFbFGZt/tDomW1t
         0fTw==
X-Gm-Message-State: AOAM531JKrV7DgVj41rlvK45EiYKT8zUMMKdWH5RRKFM+mG6D8HNWK26
        06WfQoiS1zI/RKEufLsA9znpPGvLLTp+ST6uq6DxAw==
X-Google-Smtp-Source: ABdhPJxwuXuO5Z/WtxamLrPvlWqinmwcgcDTzAmXHjtQ/UzWK5sldtA+CK+EpDDdNR6Y4pjKUJitML/FwxwvgXfD3/8=
X-Received: by 2002:a9d:12f7:: with SMTP id g110mr26857360otg.79.1593675929865;
 Thu, 02 Jul 2020 00:45:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200701085254.51740-1-damien.lemoal@wdc.com> <SN4PR0401MB35981C2AD1B925263A35B3C59B6C0@SN4PR0401MB3598.namprd04.prod.outlook.com>
In-Reply-To: <SN4PR0401MB35981C2AD1B925263A35B3C59B6C0@SN4PR0401MB3598.namprd04.prod.outlook.com>
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Date:   Thu, 2 Jul 2020 13:15:18 +0530
Message-ID: <CAK=zhgrmfQgnBqmP5YC+Av0kLcjx4ZvrQ40pGJ_hmL4737x9uA@mail.gmail.com>
Subject: Re: [PATCH] scsi: mpt3sas: Fix unlock imbalance
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Patch looks good.
Acked-by: sreekanth reddy <sreekanth.reddy@broadcom.com>

On Wed, Jul 1, 2020 at 3:40 PM Johannes Thumshirn
<Johannes.Thumshirn@wdc.com> wrote:
>
> Looks good,
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>
> While we're at it the next block does a direct return manually unlocking
> 'ioc->pci_access_mutex' and rc is never set for any of the error paths
> in 'BRM_status_show'...
>
> Maybe we should add this one on top of your patch:
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> index 62e552838565..70d2d0987249 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> @@ -3149,20 +3149,20 @@ BRM_status_show(struct device *cdev, struct device_attribute *attr,
>         }
>         /* pci_access_mutex lock acquired by sysfs show path */
>         mutex_lock(&ioc->pci_access_mutex);
> -       if (ioc->pci_error_recovery || ioc->remove_host) {
> -               mutex_unlock(&ioc->pci_access_mutex);
> -               return 0;
> -       }
> +       if (ioc->pci_error_recovery || ioc->remove_host)
> +               goto out;
>
>         /* allocate upto GPIOVal 36 entries */
>         sz = offsetof(Mpi2IOUnitPage3_t, GPIOVal) + (sizeof(u16) * 36);
>         io_unit_pg3 = kzalloc(sz, GFP_KERNEL);
>         if (!io_unit_pg3) {
> +               rc = -ENOMEM;
>                 ioc_err(ioc, "%s: failed allocating memory for iounit_pg3: (%d) bytes\n",
>                         __func__, sz);
>                 goto out;
>         }
>
> +       rc = -EINVAL;
>         if (mpt3sas_config_get_iounit_pg3(ioc, &mpi_reply, io_unit_pg3, sz) !=
>             0) {
>                 ioc_err(ioc, "%s: failed reading iounit_pg3\n",
