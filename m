Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CAB3C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Mar 2022 19:15:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245026AbiCGTQb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 14:16:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245000AbiCGTQZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 14:16:25 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC097CDD8
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 11:15:29 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id h14so3030719lfk.11
        for <linux-scsi@vger.kernel.org>; Mon, 07 Mar 2022 11:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TwTcsRMn5VZVrmgXZDV1J6sFeJgAdw8S2EoV6iZ5xnc=;
        b=dlpUNu5q4CyzmXtBLA/gOu0GC/00SF7ttDAollAbHZtk5bw2xAtIqb7CwTopnt8lf3
         AbfnSVPq9xulj/tw8AvoPmKfCZDzXeZNEVEEDbHlLhh/I5bp+zk8upvRu1BNSASuquhE
         pUQrRqiHujQApoBOt9qnNksqqhPlFfAR59MXs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TwTcsRMn5VZVrmgXZDV1J6sFeJgAdw8S2EoV6iZ5xnc=;
        b=tYkhpGGQCrur6NKB8vK8lvlT7qU+NZ5z+Tr6fy10bnVGcUadN4oGWGlbroWV9DGtXo
         t4sYrJ2L3rOGeZUWyWo2yo7D13F0Ruta2yllAVULQcSp61L6x2eWVZnDZKIxsfu+A/es
         XXJGV8QXFwpi7XeZT1YnCafmf7HzzyufCXVfn8z05GqGvpzY4u+9gQMpLoGuQxLf01oU
         pLGyP5OMqqeYX7y+SvGDWBXh7H4w6RzNPzC7z8IXFruLKuz+j6ayD1B75HO4rHdjJbBJ
         +38ZN/igVzPf8Iq61UdGiAXLFerpzpSf6/5IZ+CqmUz+gZgpfmOS5rmsHdapUcL6WFjT
         84Yg==
X-Gm-Message-State: AOAM531KsuIShXNGGYwYuuokbJV91Ue6295rQMhJgzcm0P8H3Kvmvd+v
        iipknU+pQJH+PgD/akXLKLdJzBdDMoGXGrKYIJE=
X-Google-Smtp-Source: ABdhPJyyYLfcuWPHDhE36lYgox84CPmCkNdCIR89/gCAJWIcTlcJO7FYp1iPYVCetiTll29/Z+xtuQ==
X-Received: by 2002:a05:6512:2082:b0:443:4236:5f57 with SMTP id t2-20020a056512208200b0044342365f57mr8773407lfr.335.1646680526338;
        Mon, 07 Mar 2022 11:15:26 -0800 (PST)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id t6-20020a056512068600b004437f8e83edsm2998536lfe.255.2022.03.07.11.15.24
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Mar 2022 11:15:25 -0800 (PST)
Received: by mail-lj1-f179.google.com with SMTP id r20so21961429ljj.1
        for <linux-scsi@vger.kernel.org>; Mon, 07 Mar 2022 11:15:24 -0800 (PST)
X-Received: by 2002:a05:651c:1213:b0:247:e2d9:cdda with SMTP id
 i19-20020a05651c121300b00247e2d9cddamr5310350lja.443.1646680524503; Mon, 07
 Mar 2022 11:15:24 -0800 (PST)
MIME-Version: 1.0
References: <20220228110822.491923-1-jakobkoschel@gmail.com>
 <20220307150037.GD3293@kadam> <f7ffd78aa68340e1ade6af15fa2f06d8@AcuMS.aculab.com>
In-Reply-To: <f7ffd78aa68340e1ade6af15fa2f06d8@AcuMS.aculab.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 7 Mar 2022 11:15:07 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjnsmmGdh-SZzaPD=e1rKhoBkQAF3JeVhGvpa=Gax--7g@mail.gmail.com>
Message-ID: <CAHk-=wjnsmmGdh-SZzaPD=e1rKhoBkQAF3JeVhGvpa=Gax--7g@mail.gmail.com>
Subject: Re: [PATCH 0/6] Remove usage of list iterator past the loop body
To:     David Laight <David.Laight@aculab.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        linux-arch <linux-arch@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jason Gunthorpe <jgg@ziepe.ca>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Arnd Bergman <arnd@arndb.de>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Nathan Chancellor <nathan@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Mar 7, 2022 at 7:26 AM David Laight <David.Laight@aculab.com> wrote:
>
> I'd write the following new defines (but I might be using
> the old names here):

See my email at

  https://lore.kernel.org/all/CAHk-=wiacQM76xec=Hr7cLchVZ8Mo9VDHmXRJzJ_EX4sOsApEA@mail.gmail.com/

for what I think is the way forward if we want to do new defines and
clean up the situation.

It's really just an example (and converts two list cases and one
single file that uses them), so it's not in any way complete.

I also has that "-std=gnu11" in the patch so that you can use the
loop-declared variables - but without the other small fixups for some
of the things that exposed.

I'll merge the proper version of the "update C standard version" from
Arnd early in the 5.18 merge window, but for testing that one file
example change I sent out the patch like that.

          Linus
