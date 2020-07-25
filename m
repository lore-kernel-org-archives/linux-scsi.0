Return-Path: <SRS0=zQak=BE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36DDBC433EA
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 10:06:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C323206F6
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 10:06:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aJhDGStK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbgGYKGI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 25 Jul 2020 06:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbgGYKGH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Jul 2020 06:06:07 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4972C0619D3;
        Sat, 25 Jul 2020 03:06:07 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id a23so6568231pfk.13;
        Sat, 25 Jul 2020 03:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o4MdyPd4FwJNN1L7gfFEaTU+8yhML1lu+0tVhMhnwAM=;
        b=aJhDGStKtBwZuMIoYYEPl2TtYY3iIaDNK5pYcDOiJXEuKoA3M9qPzGCHTouPjJc6dz
         KeIOWbQ/AVt1k0YFLE507+uudo/skz4i689nh/DXNCc1zvmNmYkSx3AG4PsS3Ap0q44v
         wDjfjFul4flugULbHlymMuj13fzvDUqP1GGWMG0QSAu8FHbM0tnLj9HLL+/JIVYyivQh
         lajhcnIETPjIuXD09f4BH+kUF1lgcL5UD3bhpCAWu3D0GBV0GOFaB3Sg/Z1u0M5Pxmzh
         ATJYZE2cqplWfN3mRuokAQr+VS3qVzJ1PwpZzAULSG0j+rxhEhVJqDR1OjzPzGwKREuh
         AV2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o4MdyPd4FwJNN1L7gfFEaTU+8yhML1lu+0tVhMhnwAM=;
        b=OhzUN6dRzyFs6kwyseAOxn7wWPGwVNzn4EHIUMslphsT3Ff9wL0Fu/sqQ42TSzCUz8
         s7zZ8sadrHK8iGpR4Id3GwK8xxz1TTukWviJlH2Si8dQLJt2aersEsFrdwRTMkwq+Zjy
         V9y+IKSa4plasY4BJ3s5arXFZeA4ukpzSKdCMYKohd0fYjNe/2on2OpWjugHOtSZzPvr
         HfexZrA9gyuqjGQf0BFm6FJNt2BXzBveQhiOkW8R4+u4B2G/UvJn2PJ3w/OWHiqvaUan
         60CIU+E82dK4CnYmdomAZTuXrfqVRMfkOu9uRoyGXDlLINECo6mL444r6hd4PNVtmk7p
         T5gw==
X-Gm-Message-State: AOAM533k6hTP8y96rSfTcIXQQmo0lDL572jjbSR6/O1MCR7eSRcl1+hZ
        4wjJ8/lxTtJIW0Tyn8Ejlz9mPdkU2WW55dAZqVdb60Sg
X-Google-Smtp-Source: ABdhPJxxR8K10M6/03HrPBRxVKahwHeFZirVdQwi0NTxs8aZflSh+JYyO6WFwsatB9YsjaAFdxcYLSfUrtgxyIvCcBQ=
X-Received: by 2002:a62:8ccb:: with SMTP id m194mr12804651pfd.36.1595671567294;
 Sat, 25 Jul 2020 03:06:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200724171706.1550403-1-tasleson@redhat.com> <20200724171706.1550403-4-tasleson@redhat.com>
In-Reply-To: <20200724171706.1550403-4-tasleson@redhat.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Sat, 25 Jul 2020 13:05:51 +0300
Message-ID: <CAHp75VcwDhHmLbOO2WKkShNYAdLawLx6A5O-4newkCe4XEb3LQ@mail.gmail.com>
Subject: Re: [v4 03/11] dev_vprintk_emit: Increase hdr size
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
> With the addition of the device persistent id we have the possibility
> of adding 154 more bytes to the hdr.  Thus if we assume the previous
> size of 128 was sufficent we can simply add the 2 amounts and round

sufficient

> up.

...

> -       char hdr[128];
> +       char hdr[288];

This is quite a drastic change for the stack.
Can you refactor to avoid this?

-- 
With Best Regards,
Andy Shevchenko
