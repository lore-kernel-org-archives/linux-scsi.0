Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47C6FC43461
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 00:49:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2A952177B
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 00:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599612580;
	bh=JuewVb3CWL2f8ApY/LeauzXHZXVBZAWlQT1A8+lK45U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=lUlQnRWL/Zgb+roKFkyklNvr/l6+gAeSneyNa5HhvvX1ySLazJw606DYu/bRwtZaA
	 m2zmAvsPlrfX3olxohgozKwsAupcRd8sqWImVS0HimrPFrjgZ15J1cGxxRonjoL44o
	 wpNb8I43r9dtMPMpr06ImHrV8+150i/dD+gRuq48=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729212AbgIIAtf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 20:49:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:51132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728458AbgIIAtd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Sep 2020 20:49:33 -0400
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A23B21D20;
        Wed,  9 Sep 2020 00:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599612572;
        bh=JuewVb3CWL2f8ApY/LeauzXHZXVBZAWlQT1A8+lK45U=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=1JUR3bSxoVpeWmCcldM6kA1CJMlepqwv/tbK+zGFbP+opWOGsgXeoWnYMid8n5ifj
         WrL4WvAdrthp1NvIkfSE+JoK+CRNnGfl6bGNTDW9Ex6Y++gXA/tEf+dmkYtmVh1Ppa
         GOxChAvtbdSORr507DW0vLP2PQO2pIeyvgKPXyI8=
Received: by mail-lj1-f175.google.com with SMTP id a22so1215302ljp.13;
        Tue, 08 Sep 2020 17:49:32 -0700 (PDT)
X-Gm-Message-State: AOAM533oSmWNK3uTUMNfaQ061lVkq13GAL/RhTPnlg+ox6QkI7p5Ia9S
        jmhavDFYutSuA5BAgnUnegOBDqtUB5LrJsT5zBE=
X-Google-Smtp-Source: ABdhPJwQqF8kGQl3aQIHo4jL6u7iNStiHzbekOsDMSF5xlfXaQF0zXWv8Np4ajPtvuGLncE3yLEaBvzKiELR1KuaAk4=
X-Received: by 2002:a05:651c:104:: with SMTP id a4mr547366ljb.273.1599612570759;
 Tue, 08 Sep 2020 17:49:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200908145347.2992670-1-hch@lst.de> <20200908145347.2992670-16-hch@lst.de>
In-Reply-To: <20200908145347.2992670-16-hch@lst.de>
From:   Song Liu <song@kernel.org>
Date:   Tue, 8 Sep 2020 17:49:19 -0700
X-Gmail-Original-Message-ID: <CAPhsuW548EyxEJmriyQy9VObEDUvg0H1HVcuwkadva88_e=FGw@mail.gmail.com>
Message-ID: <CAPhsuW548EyxEJmriyQy9VObEDUvg0H1HVcuwkadva88_e=FGw@mail.gmail.com>
Subject: Re: [PATCH 15/19] md: use bdev_check_media_change
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Denis Efremov <efremov@linux.com>,
        Tim Waugh <tim@cyberelk.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Borislav Petkov <bp@alien8.de>,
        "David S. Miller" <davem@davemloft.net>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        linux-m68k@lists.linux-m68k.org, linux-block@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>,
        linux-scsi@vger.kernel.org,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Sep 8, 2020 at 7:55 AM Christoph Hellwig <hch@lst.de> wrote:
>
> The md driver does not have a ->revalidate_disk method, so it can just
> use bdev_check_media_change without any additional changes.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Acked-by: Song Liu <song@kernel.org>

> ---
>  drivers/md/md.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 9562ef598ae1f4..27ed61197014ef 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7848,7 +7848,7 @@ static int md_open(struct block_device *bdev, fmode_t mode)
>         atomic_inc(&mddev->openers);
>         mutex_unlock(&mddev->open_mutex);
>
> -       check_disk_change(bdev);
> +       bdev_check_media_change(bdev);
>   out:
>         if (err)
>                 mddev_put(mddev);
> --
> 2.28.0
>
