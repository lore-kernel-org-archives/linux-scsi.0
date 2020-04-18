Return-Path: <SRS0=0GAJ=6C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E783C352BE
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 18:59:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B1BD21BE5
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 18:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587236386;
	bh=UgXOgSwIMyfiGPkOtWwuniPLy2NcYx/OJ8KMhNGbheM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=gcoAs1BPqk7iWDM5OWq2mwZjxgtR+XjGhW8mTCcVHIMN6Ud2Su6vl2rlkQS9XHHng
	 0rutQr7+zoZCS9hvuEJ1KKnKC6yZJiaQMosryb7sETht9hPosgSYGJOJ/mNpN4olOS
	 nSn2EVeyCAVNdyeF1aYoogrXq8jpdD0/8lfu7vvw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbgDRS7p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Apr 2020 14:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726086AbgDRS7p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 18 Apr 2020 14:59:45 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE66C061A0C
        for <linux-scsi@vger.kernel.org>; Sat, 18 Apr 2020 11:59:43 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id gr25so4262339ejb.10
        for <linux-scsi@vger.kernel.org>; Sat, 18 Apr 2020 11:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pJRI8oZ6j+rGEg2+OCymOS7794uvyRZcSR2Htjt5TI4=;
        b=Dab8X2CtWipiSivi9nyLxp8nBHQpWedKwzW35yNj8kBU3VxCHrB+3Kn5U3rtIjeKoA
         Lw3k/ndceMaBnN8HktM5POukz2zYdQKxOk+s6N6D5bBob3ys4IoAy4L7IIPc1NiF89LI
         qpPs2HFFi+SoqSVPJ7yi1QNfgGKP7Teiklti0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pJRI8oZ6j+rGEg2+OCymOS7794uvyRZcSR2Htjt5TI4=;
        b=ADAcxMoaytx61cfZhZaO63xte6GPleVL0EttQqQMI0g69InEDoDNOfL66PzQXa8K2u
         +vEM95gl9/FmxLSIijQFLA4dtOKIDtsvv6pWKLB5YzHygSOhgT1V/gCgTdg69PLnu6TG
         G+/u86kQKdfvinPSTN5+KQevpn+YGM2qwO7DPuyWXQV8PXl79NSD8YixGMBDG6vNJJAK
         zSIgV1VTN+DbBz1ruR5RyCLEP368AUxE0MjNBwKh96FwP7Cobf/HiUu5fE3QbZQvC5+m
         MBu2bk02SU8eG+59chpJxTHZ4EsGh6ftYxqSuqN1czWdkP1wdYbggxpLLf+UpIIHPqLW
         D6dw==
X-Gm-Message-State: AGi0Pub32AfjIVpIVzS12KCqtFaGBexO5sjgjhy7Sstpm7W6r3jGThb8
        PvSBUMEdoi5obm3pdH8CPxBiV8dkbIw=
X-Google-Smtp-Source: APiQypI2qUTOhUfScNpJgSIZCIRFI96y4y8rg8GyGxBBDMPNbG5zL57L7pZYJ5Psk1Ok4fFOgYCDew==
X-Received: by 2002:a17:906:2ad4:: with SMTP id m20mr9331351eje.324.1587236382206;
        Sat, 18 Apr 2020 11:59:42 -0700 (PDT)
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com. [209.85.218.44])
        by smtp.gmail.com with ESMTPSA id gq21sm4096567ejb.90.2020.04.18.11.59.41
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 11:59:42 -0700 (PDT)
Received: by mail-ej1-f44.google.com with SMTP id a2so4280200ejx.5
        for <linux-scsi@vger.kernel.org>; Sat, 18 Apr 2020 11:59:41 -0700 (PDT)
X-Received: by 2002:a05:6512:405:: with SMTP id u5mr5483360lfk.192.1587235998911;
 Sat, 18 Apr 2020 11:53:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200418184111.13401-1-rdunlap@infradead.org> <20200418184111.13401-3-rdunlap@infradead.org>
In-Reply-To: <20200418184111.13401-3-rdunlap@infradead.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 18 Apr 2020 11:53:03 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjSzuTyyBkmMDG4fx_sXzLJsh+9Xk-ubgbpJzJq_kzPsA@mail.gmail.com>
Message-ID: <CAHk-=wjSzuTyyBkmMDG4fx_sXzLJsh+9Xk-ubgbpJzJq_kzPsA@mail.gmail.com>
Subject: Re: [PATCH 2/9] fs: fix empty-body warning in posix_acl.c
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        target-devel <target-devel@vger.kernel.org>,
        Zzy Wysm <zzy@zzywysm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Apr 18, 2020 at 11:41 AM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> Fix gcc empty-body warning when -Wextra is used:

Please don't do this.

First off, "do_empty()" adds nothing but confusion. Now it
syntactically looks like it does something, and it's a new pattern to
everybody. I've never seen it before.

Secondly, even if we were to do this, then the patch would be wrong:

>         if (cmpxchg(p, ACL_NOT_CACHED, sentinel) != ACL_NOT_CACHED)
> -               /* fall through */ ;
> +               do_empty(); /* fall through */

That comment made little sense before, but it makes _no_ sense now.

What fall-through? I'm guessing it meant to say "nothing", and
somebody was confused. With "do_empty()", it's even more confusing.

Thirdly, there's a *reason* why "-Wextra" isn't used.

The warnings enabled by -Wextra are usually complete garbage, and
trying to fix them often makes the code worse. Exactly like here.

             Linus
