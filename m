Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1875C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Mar 2022 20:36:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237363AbiCAUhQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Mar 2022 15:37:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233240AbiCAUhP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2022 15:37:15 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC173BBEA
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 12:36:33 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id b9so28918250lfv.7
        for <linux-scsi@vger.kernel.org>; Tue, 01 Mar 2022 12:36:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rAZcpGOFnijhfBt719P+IqprCBqe8sD9TF0Sez9IwiQ=;
        b=F+7BPGYsO9QeRc6BTbvPUJxguXCTYika7fzNVLbSEfMjTVK29FjvhOtCtbBO2oalkB
         9cweHARFFeQAeiDWhTrtcdfTzbCEOfTOrVCN9rTTV3Ek5jpvIVUt3aua8OA61CgDhA1w
         zQABsshAfnGl6gFdFI9HcnnKU8AOre3uWnEew=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rAZcpGOFnijhfBt719P+IqprCBqe8sD9TF0Sez9IwiQ=;
        b=06a5BtWY9RrFWskwmP7ZnsmyZfss2o+CQeM43bqv7YaVr9t+RWcmXurAzIS3z5lpiX
         3lrkvX1cshHrFFw4ypDlCyRFRcLODTZzernve61WzGqkW5Ov5mmYHgQqtoOS/esusxeo
         aKo1fcg3GB5AAKhrcCVJE9+rnyTpLY/FHjVSQk3I9Hjn/zPfkykycFJPZu4/l82uhcbB
         +vT3ipow46u2djVN5jT+WgfruAt9lj9q0qb9lJOsoRndYTl1KA9FD5q3JQp/DEPJ+kNn
         BBcXCkb0XKCKAcAHP/Ouw3LqMH0m45tUweVPLho5D5R8b+GcXQXCwGbTgIlc6IN3t6SA
         A8Iw==
X-Gm-Message-State: AOAM530g6Rk3ozVAee0C1gCHW+0pZ0E9CIeirncZWmuzIYu3ltRgOHEI
        03LMRhUjzIeMZKa/HYqrW+3JssbBu71Sc+cF99U=
X-Google-Smtp-Source: ABdhPJz6MBLCJcOwJ/pZXT0BvL5VX/aSLZx3GuYO6cdG+sMfOflOhK+uNm6H6g/buWnglp3XqSQpKw==
X-Received: by 2002:ac2:5fae:0:b0:443:af66:385e with SMTP id s14-20020ac25fae000000b00443af66385emr16283625lfe.602.1646166991219;
        Tue, 01 Mar 2022 12:36:31 -0800 (PST)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com. [209.85.208.170])
        by smtp.gmail.com with ESMTPSA id x3-20020a2e7c03000000b00246173f84adsm2176636ljc.40.2022.03.01.12.36.30
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 12:36:31 -0800 (PST)
Received: by mail-lj1-f170.google.com with SMTP id s25so23460900lji.5
        for <linux-scsi@vger.kernel.org>; Tue, 01 Mar 2022 12:36:30 -0800 (PST)
X-Received: by 2002:ac2:44a4:0:b0:445:8fc5:a12a with SMTP id
 c4-20020ac244a4000000b004458fc5a12amr10608648lfm.27.1646166980002; Tue, 01
 Mar 2022 12:36:20 -0800 (PST)
MIME-Version: 1.0
References: <20220228110822.491923-1-jakobkoschel@gmail.com> <20220228110822.491923-7-jakobkoschel@gmail.com>
In-Reply-To: <20220228110822.491923-7-jakobkoschel@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 1 Mar 2022 12:36:03 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgLtKofBbn9kSXRU3MpdX7S2OxN1V5Mc679oJpFnp_VnQ@mail.gmail.com>
Message-ID: <CAHk-=wgLtKofBbn9kSXRU3MpdX7S2OxN1V5Mc679oJpFnp_VnQ@mail.gmail.com>
Subject: Re: [PATCH 6/6] treewide: remove check of list iterator against head
 past the loop body
To:     Jakob Koschel <jakobkoschel@gmail.com>
Cc:     linux-arch <linux-arch@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergman <arnd@arndb.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Mike Rapoport <rppt@kernel.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Nathan Chancellor <nathan@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-sgx@vger.kernel.org, drbd-dev@lists.linbit.com,
        linux-block <linux-block@vger.kernel.org>,
        linux-iio@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        dma <dmaengine@vger.kernel.org>,
        linux1394-devel@lists.sourceforge.net,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        nouveau@lists.freedesktop.org,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        intel-wired-lan@lists.osuosl.org, Netdev <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-staging@lists.linux.dev, linux-usb@vger.kernel.org,
        linux-aspeed@lists.ozlabs.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-tegra <linux-tegra@vger.kernel.org>,
        linux-mediatek@lists.infradead.org, KVM list <kvm@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical@lists.samba.org,
        Linux F2FS Dev Mailing List 
        <linux-f2fs-devel@lists.sourceforge.net>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        kgdb-bugreport@lists.sourceforge.net,
        v9fs-developer@lists.sourceforge.net,
        tipc-discussion@lists.sourceforge.net, alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

So looking at this patch, I really reacted to the fact that quite
often the "use outside the loop" case is all kinds of just plain
unnecessary, but _used_ to be a convenience feature.

I'll just quote the first chunk in it's entirely as an example - not
because I think this chunk is particularly important, but because it's
a good example:

On Mon, Feb 28, 2022 at 3:09 AM Jakob Koschel <jakobkoschel@gmail.com> wrote:
>
> diff --git a/arch/arm/mach-mmp/sram.c b/arch/arm/mach-mmp/sram.c
> index 6794e2db1ad5..fc47c107059b 100644
> --- a/arch/arm/mach-mmp/sram.c
> +++ b/arch/arm/mach-mmp/sram.c
> @@ -39,19 +39,22 @@ static LIST_HEAD(sram_bank_list);
>  struct gen_pool *sram_get_gpool(char *pool_name)
>  {
>         struct sram_bank_info *info = NULL;
> +       struct sram_bank_info *tmp;
>
>         if (!pool_name)
>                 return NULL;
>
>         mutex_lock(&sram_lock);
>
> -       list_for_each_entry(info, &sram_bank_list, node)
> -               if (!strcmp(pool_name, info->pool_name))
> +       list_for_each_entry(tmp, &sram_bank_list, node)
> +               if (!strcmp(pool_name, tmp->pool_name)) {
> +                       info = tmp;
>                         break;
> +               }
>
>         mutex_unlock(&sram_lock);
>
> -       if (&info->node == &sram_bank_list)
> +       if (!info)
>                 return NULL;
>
>         return info->gpool;

I realize this was probably at least auto-generated with coccinelle,
but maybe that script could be taught to do avoid the "use after loop"
by simply moving the code _into_ the loop.

IOW, this all would be cleaner and clear written as

        if (!pool_name)
                return NULL;

        mutex_lock(&sram_lock);
        list_for_each_entry(info, &sram_bank_list, node) {
                if (!strcmp(pool_name, info->pool_name)) {
                        mutex_unlock(&sram_lock);
                        return info;
                }
        }
        mutex_unlock(&sram_lock);
        return NULL;

Ta-daa - no use outside the loop, no need for new variables, just a
simple "just do it inside the loop". Yes, we end up having that lock
thing twice, but it looks worth it from a "make the code obvious"
standpoint.

Would it be even cleaner if the locking was done in the caller, and
the loop was some simple helper function? It probably would. But that
would require a bit more smarts than probably a simple coccinelle
script would do.

                Linus
