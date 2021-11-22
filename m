Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7361C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 14:02:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239715AbhKVOF5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 09:05:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239717AbhKVOFy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 09:05:54 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8CE3C061746
        for <linux-scsi@vger.kernel.org>; Mon, 22 Nov 2021 06:02:47 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id c32so81332358lfv.4
        for <linux-scsi@vger.kernel.org>; Mon, 22 Nov 2021 06:02:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l6o7CtLm35w0k5NT5wmZL6ENwR6FVC1O0fmAZQaHPz8=;
        b=RjjqusDeC5g/m8gkVgDBP+x094iGVdgfCS82zrcIw/60DWNeuUWbATQCEy7QZMMbQo
         fyDBQyA+QosrV16VqfT9G8T5/bv0jx2P8qO0YjirXJqM9xy5z3/93Lcod86u3kLSWOyn
         Fy1A1oyUNTMcdr4iGIZRuF5QQMSA5Kq/2b2cbBCUuBW5uJkbuIv3axDdda+QkhM6k93o
         6e15vJbDNezTcR2d1xQ6W/qhrM8oYnDyTk/aP5ymQFctMe7ohMAWArYTL+HXxp/T12um
         te3PcQx5i1a1ktFLeWUO1spjk/7+xDnMaVEer4rl3StjicFYNdwBr7/ZFjRr9Rwovqcm
         Zx4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l6o7CtLm35w0k5NT5wmZL6ENwR6FVC1O0fmAZQaHPz8=;
        b=lQMUUWqPby964fPVBJIqFvAhjryapYZ3QYDj/0SGm6gd5Stgesxd6aa7aMnAfo3/M8
         bDEhWnE/1pU8615UIcMspTLWHD4bRZxpe/d5NXrRhHT+Dw/o4miO6lzR5arx95EC661J
         d7QXD+hXDZ9TrCie5TPIzPfq22mkZwjUeZhjcWRyqKyltabYtdY6KliJoiT3+WGNpAZl
         zHN2yA18y3fNQoCb2INlgdXglrEgpUsZIMqiaXF60ojOIHkCIFR02gza06Wsv+AR5oXg
         u9g96Psj72JAIrGCkSh5G+3Kc5a4xBIz6QNrnGbzlJ035Egx1X05tp9w5ONL9l+X1/mA
         yi8Q==
X-Gm-Message-State: AOAM532h7z3QA/gsOOxqltOzGn6tISSgduhEG6+lMZ1AxAcJc12qyjYj
        HM6XQzbpdiH9YTPnWwAQSco0GkpS6FAZq0VB2ESO83J1idU=
X-Google-Smtp-Source: ABdhPJy2UL+mZc1fS0Tu+GqY5DA6wBlqJcnckZajFyJkP1nr2A1vgA7UzpTy8lYm0fEsOin1JE3w9D3LnlPhcQ5AtYU=
X-Received: by 2002:ac2:4bc1:: with SMTP id o1mr58312648lfq.254.1637589764676;
 Mon, 22 Nov 2021 06:02:44 -0800 (PST)
MIME-Version: 1.0
References: <20211122130625.1136848-1-hch@lst.de> <20211122130625.1136848-10-hch@lst.de>
In-Reply-To: <20211122130625.1136848-10-hch@lst.de>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Mon, 22 Nov 2021 15:02:08 +0100
Message-ID: <CAPDyKFoj62a92dGXt47dRhiDwmDw_KUeECz8hw6ny46i_u=WZg@mail.gmail.com>
Subject: Re: [PATCH 09/14] mmc: don't set GENHD_FL_SUPPRESS_PARTITION_INFO
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 22 Nov 2021 at 14:06, Christoph Hellwig <hch@lst.de> wrote:
>
> This manually reverts 07b652cdbec3 ("mmc: card: Don't show eMMC RPMB and
> BOOT areas in /proc/partitions").  Based on the commit description that
> change was purely cosmetic.  mmc is the last driver that sets this
> flag and thus prevents it from being removed.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

Kind regards
Uffe


> ---
>  drivers/mmc/core/block.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
> index a71b3512c877a..2dd93d49d822c 100644
> --- a/drivers/mmc/core/block.c
> +++ b/drivers/mmc/core/block.c
> @@ -2397,8 +2397,7 @@ static struct mmc_blk_data *mmc_blk_alloc_req(struct mmc_card *card,
>         set_disk_ro(md->disk, md->read_only || default_ro);
>         md->disk->flags = GENHD_FL_EXT_DEVT;
>         if (area_type & (MMC_BLK_DATA_AREA_RPMB | MMC_BLK_DATA_AREA_BOOT))
> -               md->disk->flags |= GENHD_FL_NO_PART |
> -                                  GENHD_FL_SUPPRESS_PARTITION_INFO;
> +               md->disk->flags |= GENHD_FL_NO_PART;
>
>         /*
>          * As discussed on lkml, GENHD_FL_REMOVABLE should:
> --
> 2.30.2
>
