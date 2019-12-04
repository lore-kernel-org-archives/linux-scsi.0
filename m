Return-Path: <SRS0=+pba=Z2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDF85C2BD09
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Dec 2019 18:33:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C141320656
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Dec 2019 18:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575484398;
	bh=br61MmbqNzyL0zQQ9ZbnyNvUPNjXO7jzCtUUCCg/cZQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=ZuU76imGD/Ui8goGOI5/oJH0A/kB5XB0Ty80LkdqibN44dBXCPsmcCmmtPBN4hmDw
	 rSUAToHOl/ABY3S0/xVOZiJM2oeKcqw/eFWw+mg8WYUguE5IULgSsqxaR/ByZu9Bwb
	 GkytD/YaTVVL6OPQQUpyc+zLy3DFAoxSrs/ui8Qs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728587AbfLDSdR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Dec 2019 13:33:17 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:34681 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728234AbfLDSdR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Dec 2019 13:33:17 -0500
Received: by mail-lj1-f194.google.com with SMTP id m6so478165ljc.1
        for <linux-scsi@vger.kernel.org>; Wed, 04 Dec 2019 10:33:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FPiBy3e3zUg0m4K/nRiHT6Vw6UdUbtEDAqlj3R5valo=;
        b=Djtns5IVsjsKkjqXlXecLgmq7TLzrMkrPSgPEVr/ZvwmJI4iaDca3o5iA6ZgsfgxEU
         Hpfx40UcKXq7pbBcMond4TGqgXSpVLfIVObpgFXwaKdlBXgs60PfyOM2EclUBrVxZy+I
         VKVVd/1vx0Caofr6kXg8TOm9f33WEMkE4r42w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FPiBy3e3zUg0m4K/nRiHT6Vw6UdUbtEDAqlj3R5valo=;
        b=RC7gue3pdIeBdR9OQAbTvOC4QXJZkmwxJdOi0ZOc+X6DkLf4deMs6S+x3vI0jJYt2D
         cj9XWUo0z73oOvqpwGXBgG8JQgMer3241qQcAOqJgIepHbdTdEZfsdWjVFJxeVf2MOlA
         czXqDmg764vjIaZGthIi2dd1/8os/smDOsK1hr6CIz9Vn37rGuUN3pJA5AmjUyQzxmST
         BuFI7+nrfZE2Rrj4xM550XL4bVuCyT90d2DvQhjGO9igcgubBqQD8OCnjaasF9kH+Eaq
         r2dQM8DsfqtIl/p7zKAiCxe/tS5B4rJsVhriajtMjo9ad3hrRbCR0UYoU9zODEEGZvgq
         b8/g==
X-Gm-Message-State: APjAAAV6wY9YCZTw3qYYXUiqTppVs19eegz/Io0ggVs3QPC8+EjFcirO
        9Y03ITwzNcG8gYG6DuKvrVUzJvQYWPc=
X-Google-Smtp-Source: APXvYqyvH8+v7j9Zg8P8qUQZrmzPbCI6z+wd7Mw3HEbWN9REbmGIgFaUhO+9jS2jO3zrTcoIkXAcrQ==
X-Received: by 2002:a2e:b52a:: with SMTP id z10mr2920032ljm.178.1575484394441;
        Wed, 04 Dec 2019 10:33:14 -0800 (PST)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id 10sm3696796ljw.2.2019.12.04.10.33.13
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2019 10:33:13 -0800 (PST)
Received: by mail-lf1-f53.google.com with SMTP id q6so357274lfb.6
        for <linux-scsi@vger.kernel.org>; Wed, 04 Dec 2019 10:33:13 -0800 (PST)
X-Received: by 2002:ac2:555c:: with SMTP id l28mr2926109lfk.52.1575484392762;
 Wed, 04 Dec 2019 10:33:12 -0800 (PST)
MIME-Version: 1.0
References: <CAK8P3a33oETbN-60VjpNNeuW1U1Wzb4juVzdiw1ESdses6m3bw@mail.gmail.com>
 <20191204140812.2761761-1-arnd@arndb.de>
In-Reply-To: <20191204140812.2761761-1-arnd@arndb.de>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 4 Dec 2019 10:32:56 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjBbi2xJZw+7Wqtt3W_mOUSPU2N4w-OES9WUUyXt-DnCg@mail.gmail.com>
Message-ID: <CAHk-=wjBbi2xJZw+7Wqtt3W_mOUSPU2N4w-OES9WUUyXt-DnCg@mail.gmail.com>
Subject: Re: [PATCH] scsi: sg: fix v3 compat read/write interface
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Doug Gilbert <dgilbert@interlog.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 4, 2019 at 6:08 AM Arnd Bergmann <arnd@arndb.de> wrote:
>
> To address both of these, move the definition of compat_sg_io_hdr
> into a scsi/sg.h to make it visible to sg.c and rewrite the logic
> for reading req_pack_id as well as the size check to a simpler
> version that gets the expected results.

I think the patch is a good thing, except for this part:

> @@ -575,6 +561,14 @@ sg_new_read(Sg_fd * sfp, char __user *buf, size_t count, Sg_request * srp)
>         int err = 0, err2;
>         int len;
>
> +#ifdef CONFIG_COMPAT
> +       if (in_compat_syscall()) {
> +               if (count < sizeof(struct compat_sg_io_hdr)) {
> +                       err = -EINVAL;
> +                       goto err_out;
> +               }
> +       } else
> +#endif
>         if (count < SZ_SG_IO_HDR) {
>                 err = -EINVAL;
>                 goto err_out;

Yes, yes, I know we do things like that in some other places too, but
I really detest this kind of ifdeffery.

That

         } else
  #endif
         if (count < SZ_SG_IO_HDR) {

is just evil. Please don't add things like this where the #ifdef
section has subtle semantic continuations outside of it. If somebody
adds a statement in between there, it now acts completely wrong.

I think you can remove the #ifdef entirely. If CONFIG_COMPAT isn't
set, I think in_compat_syscall() just turns to 0, and the code gets
optimized away.

Hmm?

               Linus
