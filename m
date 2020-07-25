Return-Path: <SRS0=zQak=BE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA047C433E3
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 10:26:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F19920714
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 10:26:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fU2pWFw4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgGYK0h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 25 Jul 2020 06:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbgGYK0g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Jul 2020 06:26:36 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D71C0619D3;
        Sat, 25 Jul 2020 03:26:35 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x72so6598118pfc.6;
        Sat, 25 Jul 2020 03:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RgZlB5gf3rHPNMgpLHmZRCAYCoGgXfxGyETCwUduUsc=;
        b=fU2pWFw4y+QeFWlwpd5xApuENt+nNL/8Her7E4AMDECBYiulJZlURIPrcMsTOq/dgG
         qLojpw8bpzg5KhYhjG1ZV/KVkeY9fi9x+bAa8elqQ+drHAMLH3DMWLaCuPoI5o8tCM1X
         11g0AtAly7YvXrlzMh9jKjWEbGA/SEJ69XCDoV3t8+KqKhWgrCti+96EITeSzgApWpqq
         HcUeeo6XSs8Oo/kIimy0TmFHinrvLdDOB8stGBVzh67cjzVYCZq4vE7b+GyLpbpPlZI8
         LPtpKUYj7yQg1RgZXSWMzWqtPfNWatGvu95wW6mDiBFtFLpJfb3eqQa4H/QElQluLpPV
         SosQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RgZlB5gf3rHPNMgpLHmZRCAYCoGgXfxGyETCwUduUsc=;
        b=LOhK63cIAs9wmB/9clgy7N0MZ08pi1YBd42GMJ/Ybw1ocbpaQ+d8sNpZ5VGmEphFW7
         hQMbYW2sJK8nqzDWM2yVxDFAsgybRfy5NU+jSQ74LOtnIi4iQL16SLyqBpshGn4E9/KU
         anymdYqm8Mjw8C0CakuGTW6uC7I8X8IFzm7x1xw6FDxoenpsZuUo3Yi8MlI7kyVL3Jir
         Ujz2nPm2IPnn6IZo/bdZ0DniqMdIUk5y09BcG8+WQhte8X9p/Ejx6QxHQRGzfD1EOXTN
         bdoxB0hSiHuIst4BxST+GNJ8QN5a/3kkC0+FFHUrOUo2eJwSbukMdEwcy5ezsQgNhgy7
         eqWg==
X-Gm-Message-State: AOAM5322TjJ4gzVvYSm0NLW90WkwyLJgvShUUP53Urbv50ZKTi03Kxfg
        tjFoch3fJjAWyIHz79y4cxmfW5aXsBUFfutTaqc=
X-Google-Smtp-Source: ABdhPJxj3+CHev14xjBiaBJKvcLF4p+ytZKzrXuth9FI7a1YkW1UyQ6yXaDWh2InG4sBtd8JfrcddKYhjvrxtp8fbDM=
X-Received: by 2002:a62:8ccb:: with SMTP id m194mr12855127pfd.36.1595672795207;
 Sat, 25 Jul 2020 03:26:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200724171706.1550403-1-tasleson@redhat.com> <20200724171706.1550403-7-tasleson@redhat.com>
In-Reply-To: <20200724171706.1550403-7-tasleson@redhat.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Sat, 25 Jul 2020 13:26:19 +0300
Message-ID: <CAHp75VdRCaOp4eg4XKuGbCvh6BFAzmaqnyRA2UwfcPmuNzk9zA@mail.gmail.com>
Subject: Re: [v4 06/11] libata: Add ata_scsi_durable_name
To:     Tony Asleson <tasleson@redhat.com>
Cc:     linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jul 24, 2020 at 8:19 PM Tony Asleson <tasleson@redhat.com> wrote:
>
> Function used to create the durable name for ata scsi.

https://chris.beams.io/posts/git-commit/

> Signed-off-by: Tony Asleson <tasleson@redhat.com>

...

> +}
> +
> +

One is enough, really!

>  /**

...

> -       if (dev)
> +       if (dev) {
>                 rc = ata_scsi_dev_config(sdev, dev);
> +               if (!rc)
> +                       dev->tdev.durable_name = ata_scsi_durable_name;
> +       }

Can we stick to our usual pattern?

rc = ...
if (rc)
  return rc;
...

>         return rc;
>  }


-- 
With Best Regards,
Andy Shevchenko
