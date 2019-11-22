Return-Path: <SRS0=RMqd=ZO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4FC7C432C0
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 08:52:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A92E620708
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 08:52:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="RyKyzf1G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfKVIwh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Nov 2019 03:52:37 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:33341 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbfKVIwh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Nov 2019 03:52:37 -0500
Received: by mail-io1-f66.google.com with SMTP id j13so7132942ioe.0
        for <linux-scsi@vger.kernel.org>; Fri, 22 Nov 2019 00:52:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zvUCCfU5/PF8rJjDmNpUUsFf/nE8qmL8h8zdqi5rKzw=;
        b=RyKyzf1GGgxfFUL3ZZXSYG9WscT2jkc0r3bM6NzvxGgPda04fILQZN7+bU6eHmpbNB
         ior/NfwDcA0qqh0BZDTmbNeT1V6VvnWs/OcTHt1nFvo3OTei+5A6p9fvgCO/jL/w5Pvd
         EwVnevpBlYtBH9M5LxLUWVi0iqNpLjMFvZB6noDme9plHz8+/wZUg6GNOGK1xij0PJRo
         C7n5oTunx1TcVNqjrjc6HXQ563ujD5Fi4QpMKz2vgQqRHZ8r9NEKWe5s7R9qP36gfFK5
         29oQXZN0l+pfKB/e4/qOTJug8SnbFTYeQRMM19tlSRQ2f+W948FwjAjOO2c4f/2PGniq
         oSqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zvUCCfU5/PF8rJjDmNpUUsFf/nE8qmL8h8zdqi5rKzw=;
        b=K+I+3JyrsRzfLSgqpoYw7duL7q8LYCZNbU7sn4dSAPwxVlGk1aGODAksAQUS2fCfY5
         r8UiMwwYH/bxrojHwxeF5R+roWZHWygW52uSNEVLzlTfokRi5FHcdy5LNORB0y9Ir/1v
         +DNEgffYxtHY2lbfOLZBHtOERZ8nB14vfRHjFLf43+knTuYm5LRi15acWoq9kmXCuGAJ
         5yg19cjqpwxwhmRO3/pXYlaG4FztBtN6aHNvlBGAzEtHxhI9rQB1U118kGf0ppEvdOZD
         TAHtntkk4eCAJ1TjcYVFgPI8SYPrFZIvKKwGedagvO8uC0S6fd9/TB/94n9DjsaLHUTb
         l4iQ==
X-Gm-Message-State: APjAAAX06Uo4vAd0RuwrrXVxLJvUFk28aYe/E/rW7NCdb23XrAGjblSM
        XUybzOwNaWN/WVqXxdUT/2jclXpCGHM/UHQjtuQU6Q==
X-Google-Smtp-Source: APXvYqyxNnhUYe6OElYe14bv2Wa+yAScAh3nlgbZvX5P1wTvJXYUBvLXimIQjWiFZhRKaEPl45Zjz/la/ULzvhRjYuQ=
X-Received: by 2002:a6b:ca41:: with SMTP id a62mr2664228iog.217.1574412756306;
 Fri, 22 Nov 2019 00:52:36 -0800 (PST)
MIME-Version: 1.0
References: <20191122020911.33269-1-yuehaibing@huawei.com>
In-Reply-To: <20191122020911.33269-1-yuehaibing@huawei.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Fri, 22 Nov 2019 09:52:25 +0100
Message-ID: <CAMGffEnCUqFVbOr60wUw3TK_K2_8A=06J8bHj=05pkRUkT4pGA@mail.gmail.com>
Subject: Re: [PATCH -next] scsi: pm80xx: Remove unused including <linux/version.h>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Nov 22, 2019 at 3:11 AM YueHaibing <yuehaibing@huawei.com> wrote:
>
> Remove including <linux/version.h> that don't need it.
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Thanks,
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 19601138e889..6402629bcd40 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -37,7 +37,6 @@
>   * POSSIBILITY OF SUCH DAMAGES.
>   *
>   */
> - #include <linux/version.h>
>   #include <linux/slab.h>
>   #include "pm8001_sas.h"
>   #include "pm80xx_hwi.h"
>
>
>
