Return-Path: <SRS0=0GAJ=6C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D059FC352BE
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 19:16:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1593221E9
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 19:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587237381;
	bh=nJnKcpqe99fN65NLQUHGPXgQLocTjwSyWw16Krxp1pM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=k/KzedzIYDUAvYii+WzIT/1lSa+7IznoT8TdDBa1iy/r6thRhAMEO2ngp3wzHD5WP
	 7AOa7TgEz2jBIeDS/AMNo1lPCjBefmoSYOJtl4feFPb39R9znXvAm9rPEnzzk4M5d2
	 Az/s8PhZTfIXYv/+W90CLU704ryUV9cm7qDmbQ/g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgDRTQV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Apr 2020 15:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728107AbgDRTQU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 18 Apr 2020 15:16:20 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962D9C061A0F
        for <linux-scsi@vger.kernel.org>; Sat, 18 Apr 2020 12:16:19 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id n17so4293919ejh.7
        for <linux-scsi@vger.kernel.org>; Sat, 18 Apr 2020 12:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M5L2K70fxOQxP+uWdRM/yMA+3xinlowUvRSVTNSTLNw=;
        b=VUI+VnT1NDQO7RfejypC/A0x1WOF6JlDgQOx4uVj0o8myo36afYqYoAB1bDh9hMclE
         y2579x/RBIr7L8eyYz+tWMdcXNGl1k4dVtK8zltRzr1OvNlhqXGfw7OPYoGf+9sgrfJ0
         nPVwr3eWFbVskZYoGSYtK1N/R40NufLSxc2Ks=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M5L2K70fxOQxP+uWdRM/yMA+3xinlowUvRSVTNSTLNw=;
        b=C7DEHIM9E/P8wPgRmrFGKjrKokCToXU/M4tSApHhPFi+S2mp40NOqdh9TjyEQLJF57
         aIN6FebpxyOtmXxhzSx30Ayx21UhhbqMa9o4Df8XJs1d1hJ2vYYoHMZwTYFYN0kswgw+
         IczYp+FrZTyJmY8KkdPQ6h5fLQ8Kc73QENRQ6X+YUSiTybn7zMKSh4k7TBtUIGPexhqm
         mObYog+f3UxMsbPyVHgnTOB5z0NbBn1BDgTx5qotA1vs94wUvzPmb/t5sf7g1KT8a51T
         ZVmDF1TyQ9mqRWQJ7n//SVgACt72z3FlOG1dR11vUJZnDypLum/eEqXCtEtA7MG4QMf1
         cMUg==
X-Gm-Message-State: AGi0PuZj/UKjsxcFCX/C9QDXKu7w01H9A9/mD2GxLh0+zNrKzuBqV361
        AOsKCJvWoECscV5jA5lZau4UbR0LKxs=
X-Google-Smtp-Source: APiQypLvYMQhpiD57Buttwu18R27xDdy375YZGYPfQygJG4CfAmNoffrbqHLv9TFyduVBEkwcaZhRg==
X-Received: by 2002:a17:906:c839:: with SMTP id dd25mr8762729ejb.164.1587237377893;
        Sat, 18 Apr 2020 12:16:17 -0700 (PDT)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com. [209.85.208.45])
        by smtp.gmail.com with ESMTPSA id b13sm3498640eje.13.2020.04.18.12.16.14
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 12:16:17 -0700 (PDT)
Received: by mail-ed1-f45.google.com with SMTP id e5so4076561edq.5
        for <linux-scsi@vger.kernel.org>; Sat, 18 Apr 2020 12:16:14 -0700 (PDT)
X-Received: by 2002:a2e:1418:: with SMTP id u24mr5613429ljd.265.1587237373258;
 Sat, 18 Apr 2020 12:16:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200418184111.13401-1-rdunlap@infradead.org> <20200418184111.13401-8-rdunlap@infradead.org>
 <20200418185033.GQ5820@bombadil.infradead.org> <b88d6f8b-e6af-7071-cefa-dc12e79116b6@infradead.org>
 <d018321b0f281ff29efb04dd1496c8e6499812fb.camel@perches.com>
In-Reply-To: <d018321b0f281ff29efb04dd1496c8e6499812fb.camel@perches.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 18 Apr 2020 12:15:57 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi4QU90W1j1VVUrqdrkrq-0XPA06sjGUm-g1VHRB-35YA@mail.gmail.com>
Message-ID: <CAHk-=wi4QU90W1j1VVUrqdrkrq-0XPA06sjGUm-g1VHRB-35YA@mail.gmail.com>
Subject: Re: [PATCH 7/9] drivers/base: fix empty-body warnings in devcoredump.c
To:     Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rafael Wysocki <rafael@kernel.org>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org,
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

On Sat, Apr 18, 2020 at 11:57 AM Joe Perches <joe@perches.com> wrote:
>
> sysfs_create_link is __must_check

The way to handle __must_check if you really really don't want to test
and have good reasons is

 (a) add a big comment about why this case ostensibly doesn't need the check

 (b) cast a test of it to '(void)' or something (I guess we could add
a helper for this). So something like

        /* We will always clean up, we don't care whether this fails
or succeeds */
        (void)!!sysfs_create_link(...)

There are other alternatives (like using WARN_ON_ONCE() instead, for
example). So it depends on the code. Which is why that comment is
important to show why the code chose that option.

However, I wonder if in this case we should just remove the
__must_check. Greg? It goes back a long long time.

Particularly for the "nowarn" version of that function. I'm not seeing
why you'd have to care, particularly if you don't even care about the
link already existing..

            Linus
