Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26100C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 30 May 2022 02:26:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbiE3C03 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 May 2022 22:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbiE3C00 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 May 2022 22:26:26 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F83C71DBE
        for <linux-scsi@vger.kernel.org>; Sun, 29 May 2022 19:26:25 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id q21so18254492ejm.1
        for <linux-scsi@vger.kernel.org>; Sun, 29 May 2022 19:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kw2XsHaOr3U+iE1j+G98PTQr/5GCVr7TQntxOGqCCbY=;
        b=lfOu0Y768XSNboyRhNarhUBMnS8grMO00ojmnmFwfpbDPCqtVXRXU98OET9cqCKhzD
         gLgUEcO76HNj5KL0a+M3NP2FePb24yWQ0zUmvDPMfvWRklfIS3SbKdALHVny+HCxkgPq
         d5LJavCGA5G+vvuQBYGxsjO6MYN4b3KsUVKa+OMXwUVQ8s05dA558MLHCXcDCH7lFoS3
         hxfFUlhQkhmbwR7OJMqcJfVDMw0tl/5H9HyWeYqvUmPUaf5Epk64nE8asSnNqVhDVnPl
         EKwca7V3x8vCIqb/ZQCoBGPeBradFTvb10pJGLs8cdVfE6csA/F1xq/ViSIlHhu32cru
         IiHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kw2XsHaOr3U+iE1j+G98PTQr/5GCVr7TQntxOGqCCbY=;
        b=nYu2J5jXzqjOGKpEjjSVzgREVzRS8wP0g463q792odql3jY32P0yg/mHyjkBv1o+uE
         mRwSiz14IpMuA4Ce9T8CUKs0UyeSTecUy1CAB26WCzBpNDNlgNUyRWWUOgQLbtyWQXDt
         9s71aUs6e4V7mzGaGkktzsYPIAqRls+uG7MNPLZE9HhbngkWjWrxRi/+HBquFpr185d9
         NaUa3uQf/KxTyQQIElXnpiMJJoQMa7kmVxgN3pWhF+lq0Kjn4++8Zf9RhJm+/z3sWyhA
         +K6Mf0mg5JhTAnCaOKMqK9lVmjTLWuC9eoqp0DNX+V/5HCOrfPk99PtiTuOtE0CrCBJW
         1enA==
X-Gm-Message-State: AOAM530joBQwfYNEO6XfLTZJ5Llw0D0mftpk29ASbfuu/yxsLNmZOvXv
        BoCjJXKzygyVCqgP2xexgkHDPquxcN7OWUMk+1Q=
X-Google-Smtp-Source: ABdhPJza5DYpb9pK+duvmMFHPGLN/8K1+RYoB1X9TweOXqveDQhDwasndpELcPAhE+cYPiwtbLrCyhPyYB/F7x1tkjE=
X-Received: by 2002:a17:907:3f9f:b0:6fe:f9e2:9c6a with SMTP id
 hr31-20020a1709073f9f00b006fef9e29c6amr29503130ejc.479.1653877583728; Sun, 29
 May 2022 19:26:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220530014341.115427-1-damien.lemoal@opensource.wdc.com> <20220530014341.115427-2-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20220530014341.115427-2-damien.lemoal@opensource.wdc.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Mon, 30 May 2022 10:25:57 +0800
Message-ID: <CAD-N9QUdNpseSDG-9=CocvysNTfoJCD83vgdv=TXzXE_0DhyoQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] scsi: sd: Fix potential NULL pointer dereference
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, May 30, 2022 at 9:43 AM Damien Le Moal
<damien.lemoal@opensource.wdc.com> wrote:
>
> If sd_probe() sees an error before sdkp->device is initialized,
> sd_zbc_release_disk() is called, which causes a NULL pointer dereference
> when sd_is_zoned() is called. Avoid this by also testing if a scsi disk
> device pointer is set in sd_is_zoned().
>
> Reported-by: Dongliang Mu <mudongliangabcd@gmail.com>
> Fixes: 89d947561077 ("sd: Implement support for ZBC device")
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> ---
>  drivers/scsi/sd.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
> index 2abad54fd23f..b90b96e8834e 100644
> --- a/drivers/scsi/sd.h
> +++ b/drivers/scsi/sd.h
> @@ -236,7 +236,8 @@ static inline void sd_dif_config_host(struct scsi_disk *disk)
>
>  static inline int sd_is_zoned(struct scsi_disk *sdkp)
>  {
> -       return sdkp->zoned == 1 || sdkp->device->type == TYPE_ZBC;
> +       return sdkp->zoned == 1 ||
> +               (sdkp->device && sdkp->device->type == TYPE_ZBC);
>  }
>

Tested-by: Dongliang Mu <mudongliangabcd@gmail.com>


>  #ifdef CONFIG_BLK_DEV_ZONED
> --
> 2.36.1
>
