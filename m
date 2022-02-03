Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87711C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Feb 2022 06:53:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241903AbiBCGxR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Feb 2022 01:53:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241737AbiBCGxQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Feb 2022 01:53:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59FD2C061714;
        Wed,  2 Feb 2022 22:53:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22C64B8332E;
        Thu,  3 Feb 2022 06:53:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D305DC340EF;
        Thu,  3 Feb 2022 06:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643871192;
        bh=WenU48FmCsRXtCZxwexU9p6lhljp4WYlPcsszw9XORU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=u8ie2rEBIQdJaxU79YHCXi6gou+iDilTeSl6MgVjVWLTdf1AO4P6YS2IyJdAqASdQ
         WjZK+Pb1uMJCGqW6t1W0MQA9Ru1gR+0XcI5DpPHYw7Kbt4Ld9siOhS0Jj5gzhdZ+Sp
         o+vpBSBjIoFBpR5y/7cYDc3vkuE0lvMqmcSMpMyvw86/AlhSRrreyrSeISVNIwCNKJ
         FD0aOalNKdC5TQAf1sCmxSz4LAAHAk9oUcBqc5fkBDR2gQzqd2IOBB3xxuHdmOPHFp
         6X7OXvVXaAl+tdqzcWUHHjeMvkANo1p7+TsrEve/fH0ZRWhmguum86JYh6W24HbU19
         cIkkX2DEHjFcw==
Received: by mail-yb1-f171.google.com with SMTP id j2so6183024ybu.0;
        Wed, 02 Feb 2022 22:53:12 -0800 (PST)
X-Gm-Message-State: AOAM533BNcNT0fNVUiHMIaXcd4v7jH7p3R7WsmtN6r7icuYiR5K086W2
        5HwvyQmBRCZoUxsuM4iUq+OjxJrTM6XNiF7Eqz8=
X-Google-Smtp-Source: ABdhPJxXg9DvcWV8iQ1KPhbXDWRUr0+104btYSUwLMFt3E//vBO5JRslLV5mg7SE57M2ExF+aMnB5AT0v36QJMgc0us=
X-Received: by 2002:a25:27c8:: with SMTP id n191mr14920691ybn.670.1643871192015;
 Wed, 02 Feb 2022 22:53:12 -0800 (PST)
MIME-Version: 1.0
References: <20220203064009.1795344-1-song@kernel.org> <20220203064009.1795344-3-song@kernel.org>
In-Reply-To: <20220203064009.1795344-3-song@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Wed, 2 Feb 2022 22:53:01 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5DitVaUG-z35Si0bMERQdGAF60Tj3nD7DwmKhZVxs9AA@mail.gmail.com>
Message-ID: <CAPhsuW5DitVaUG-z35Si0bMERQdGAF60Tj3nD7DwmKhZVxs9AA@mail.gmail.com>
Subject: Re: [PATCH 2/2] scsi: use BLK_STS_OFFLINE for not fully online devices
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
> The new error message for such case looks like
>
> [  172.809565] device offline error, dev sda, sector 3138208 ...
>
> which will not be confused with regular I/O error (BLK_STS_IOERR).
>
> Signed-off-by: Song Liu <song@kernel.org>
> ---
>  drivers/scsi/scsi_lib.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 0a70aa763a96..e30bc51578e9 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1276,7 +1276,7 @@ scsi_device_state_check(struct scsi_device *sdev, struct request *req)
>                  * power management commands.
>                  */
>                 if (req && !(req->rq_flags & RQF_PM))
> -                       return BLK_STS_IOERR;
> +                       return BLK_STS_OFFLINE;
>                 return BLK_STS_OK;
>         }
>  }
> --
> 2.30.2
>
