Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 562CAC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 07:09:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F7C160E08
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 07:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbhKBHLs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Nov 2021 03:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbhKBHLS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2021 03:11:18 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F6DC061767
        for <linux-scsi@vger.kernel.org>; Tue,  2 Nov 2021 00:08:44 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id f8so50879264edy.4
        for <linux-scsi@vger.kernel.org>; Tue, 02 Nov 2021 00:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qAe//IFLuNszKq8bula7b/2T7KR6e1v+cF+2hN/bYM8=;
        b=Huu2dSM0TXsunqdv7Jfc8goS0wCJH2FhjWq4aYDxWE6OIrMzgnYAMB8bOpzrg5XhSj
         ngXLUgoZhsywqu6GlDl3InT8H/Rinx/+jhSLn/84dTCjRQhya7+Tr/4DOq2TkMOaHPOf
         Uz91F3U8jB/8gBydvPSqv67lzWSOgAdhauUX4oYjy+ZVykRHSVt502zL0KLReadcKoEl
         50vKBmzuYnug8hCn6CcUgghr8c6DmjhNCuOqYX4t59GhtNGN8WX9WUjG1xnNshPlfopG
         FJbc1JgLv6TI8cJQFic8FhffmR52mBgb7l/EXixWgv7NHAcGX34yzzsbISpo5QZ5Cmze
         LX0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qAe//IFLuNszKq8bula7b/2T7KR6e1v+cF+2hN/bYM8=;
        b=qwo84zv1j9DuGlXBgjZt/TKth62eDKVfkaB7eojuyzir3pQE4I+LrEZZeTODwP0spw
         mcO9W5jaxpgsywSsXw6qMBdJ+jxbvlx+nIC2Upf3lr+1fTGK0nUL7jvPCHGSdUXZnhFX
         v893X6VnhPTFX8MGcFj4/CZe2jZurZBgYsao7uS/T50Nm5zR/9wNXUgKS0X+Da7UFOn9
         2ewGvGVv/LBndF1ySv6NykBeNfAOafBje3A7Wv2VnbcO53tdxwFQxZTzYsLqzP+ula3T
         SL9IRoXqsF5VUv3P+6GdUnI4z/IdAqHHA/zuWHq7/U2hWBkrM0KLcI3KIWT6ZuW5F+xz
         ufFQ==
X-Gm-Message-State: AOAM533rjiGpxRhJlICnAH71Xk4pXHkkZcP2RNHS/pYDKus+rLExPzV9
        /CY7fbD/PpM0Uabiq2ulQ783v0nA6NH+2DquZWwC7Q==
X-Google-Smtp-Source: ABdhPJyYJssIjsO4ZwywhOIuTfQgOfHSl6TnVzr3pYB5DgJ+8euexNpw3UfXjxBiT1QTBvdTU33+7AfI5gaLbgbGTFo=
X-Received: by 2002:a05:6402:190f:: with SMTP id e15mr48833021edz.310.1635836922055;
 Tue, 02 Nov 2021 00:08:42 -0700 (PDT)
MIME-Version: 1.0
References: <20211101232825.2350233-1-ipylypiv@google.com> <20211101232825.2350233-5-ipylypiv@google.com>
In-Reply-To: <20211101232825.2350233-5-ipylypiv@google.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Tue, 2 Nov 2021 08:08:30 +0100
Message-ID: <CAMGffE=_hCNRi=LEti5YUZpW5Sxt5WkEbgFWGVd6T57JqN2fCA@mail.gmail.com>
Subject: Re: [PATCH 4/4] scsi: pm80xx: Use bitmap_zalloc() for tags bitmap allocation
To:     Igor Pylypiv <ipylypiv@google.com>
Cc:     Jack Wang <jinpu.wang@ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Vishakha Channapattan <vishakhavc@google.com>,
        Changyuan Lyu <changyuanl@google.com>,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 2, 2021 at 12:29 AM Igor Pylypiv <ipylypiv@google.com> wrote:
>
> We used to allocate X bytes while we only need X bits.
>
> Reviewed-by: Vishakha Channapattan <vishakhavc@google.com>
> Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Thanks
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index 47db7e0beae6..9935cf20b93d 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -178,7 +178,7 @@ static void pm8001_free(struct pm8001_hba_info *pm8001_ha)
>         }
>         PM8001_CHIP_DISP->chip_iounmap(pm8001_ha);
>         flush_workqueue(pm8001_wq);
> -       kfree(pm8001_ha->tags);
> +       bitmap_free(pm8001_ha->tags);
>         kfree(pm8001_ha);
>  }
>
> @@ -1193,7 +1193,7 @@ pm8001_init_ccb_tag(struct pm8001_hba_info *pm8001_ha, struct Scsi_Host *shost,
>         can_queue = ccb_count - PM8001_RESERVE_SLOT;
>         shost->can_queue = can_queue;
>
> -       pm8001_ha->tags = kzalloc(ccb_count, GFP_KERNEL);
> +       pm8001_ha->tags = bitmap_zalloc(ccb_count, GFP_KERNEL);
>         if (!pm8001_ha->tags)
>                 goto err_out;
>
> --
> 2.33.1.1089.g2158813163f-goog
>
