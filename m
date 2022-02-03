Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25980C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Feb 2022 06:52:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241260AbiBCGw5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Feb 2022 01:52:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbiBCGw5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Feb 2022 01:52:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E190C061714;
        Wed,  2 Feb 2022 22:52:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB3B7B8332E;
        Thu,  3 Feb 2022 06:52:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F697C340EF;
        Thu,  3 Feb 2022 06:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643871174;
        bh=bQxNuzvd1NM85jWwBcGAqaV6HQIXXxsxaFuHH++hW7E=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=iPbpEmktfL9wAfd2rEXXQYwp598ykoFr0shqwRD1nhljEPqm+HwJiO/RRKiQrBSjt
         kKkX0vDfM9P85hrn24JsdN0FB+hnSG5L/JsDcP/1HuvSZblcNw5QzTZ2EHSSmE/rxV
         K5ORVz1Ix49xspsShyowknTYrcaFY7XXiwuUIQcS03QSN7E8F6eRU6dbfm3qMplrzr
         6RV76AVCnbpqW3HZHjEIrVi4j1VLWrimfdLituSgy1AtFBUycK7+VuLYIuJcaG+EXl
         7rXDBI235wStl7I+3ehox9dtxhEiWv5esbeNIUpwsTlgxi7soKGu/eujK7GdFG1glL
         IM/RmMpwWqInA==
Received: by mail-yb1-f178.google.com with SMTP id k31so6012672ybj.4;
        Wed, 02 Feb 2022 22:52:54 -0800 (PST)
X-Gm-Message-State: AOAM532iwNB+3mUTmNjOzwLdLg1x4NcUObLskZCeyFR8g+ygmymBGT2G
        BAnGwugmYC/bSzevUv0eGTR2yQWx4iYwvn+FTNM=
X-Google-Smtp-Source: ABdhPJzwJ0DbTYyJkcuswrMZpwnbGZY1uWmUwDdpvFt/VC5AfRTLfAZVuYfLI6fv7rEIORSNR7KZqGQLnPzqXKEmQ4A=
X-Received: by 2002:a05:6902:5:: with SMTP id l5mr666337ybh.558.1643871173727;
 Wed, 02 Feb 2022 22:52:53 -0800 (PST)
MIME-Version: 1.0
References: <20220203064009.1795344-1-song@kernel.org> <20220203064009.1795344-2-song@kernel.org>
In-Reply-To: <20220203064009.1795344-2-song@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Wed, 2 Feb 2022 22:52:42 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6PNaYUb5xDxPX_gX=2fZdiRURRos5sT_Tsbngon1+eKw@mail.gmail.com>
Message-ID: <CAPhsuW6PNaYUb5xDxPX_gX=2fZdiRURRos5sT_Tsbngon1+eKw@mail.gmail.com>
Subject: Re: [PATCH 1/2] block: introduce BLK_STS_OFFLINE
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc:     Kernel Team <kernel-team@fb.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

CC linux-block (it was a typo in the original email)

On Wed, Feb 2, 2022 at 10:40 PM Song Liu <song@kernel.org> wrote:
>
> Currently, drivers reports BLK_STS_IOERR for devices that are not full
> online or being removed. This behavior could cause confusion for users,
> as they are not really I/O errors from the device.
>
> Solve this issue with a new state BLK_STS_OFFLINE, which reports "device
> offline error" in dmesg instead of "I/O error".
>
> Signed-off-by: Song Liu <song@kernel.org>
> ---
>  block/blk-core.c          | 1 +
>  include/linux/blk_types.h | 7 +++++++
>  2 files changed, 8 insertions(+)
>
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 61f6a0dc4511..24035dd2eef1 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -164,6 +164,7 @@ static const struct {
>         [BLK_STS_RESOURCE]      = { -ENOMEM,    "kernel resource" },
>         [BLK_STS_DEV_RESOURCE]  = { -EBUSY,     "device resource" },
>         [BLK_STS_AGAIN]         = { -EAGAIN,    "nonblocking retry" },
> +       [BLK_STS_OFFLINE]       = { -EIO,       "device offline" },
>
>         /* device mapper special case, should not leak out: */
>         [BLK_STS_DM_REQUEUE]    = { -EREMCHG, "dm internal retry" },
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index fe065c394fff..5561e58d158a 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -153,6 +153,13 @@ typedef u8 __bitwise blk_status_t;
>   */
>  #define BLK_STS_ZONE_ACTIVE_RESOURCE   ((__force blk_status_t)16)
>
> +/*
> + * BLK_STS_OFFLINE is returned from the driver when the target device is offline
> + * or is being taken offline. This could help differentiate the case where a
> + * device is intentionally being shut down from a real I/O error.
> + */
> +#define BLK_STS_OFFLINE                ((__force blk_status_t)17)
> +
>  /**
>   * blk_path_error - returns true if error may be path related
>   * @error: status the request was completed with
> --
> 2.30.2
>
