Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF95EC433E3
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 16:19:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6058619A6
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 16:19:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbhCVQSu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 12:18:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:57452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229771AbhCVQSk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Mar 2021 12:18:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 870896197F;
        Mon, 22 Mar 2021 16:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616429920;
        bh=kSTU4aDsOvuAbAuUCXG/WhJB+C+wlLWVnpXMEQ1jxZ0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=SpSi0kdOS0kxv1MsTetciTKKyrNHyjObZVRmx8C7LIiQrpYHzGtfjHU7ZXCYTyPK2
         aWT/dAm62jjq5I5Pw9keDeFQR+CxFhcoHedF8v0TDINBG2tWMFais3v21plBIZNdAR
         GHAu56/PRcyuTZAOjpQq10Aj57Ob4PPflbRaouyhAH0X9YCcXHAfE6Pp2zHMo3ahgy
         DwdHQmDZApU2R3PHmJh6kw4Yx2NQL7FBxxyjRZb3lhv3w0zxMzwfoLeXH+eGZfCUlj
         XlA3zQVkJxeFBqFv0h2kstNdIShA/M9NJTfUz/0/DvIfKa9dz3SG4ji87r3blhvjdk
         1hjmpcFG6fWkg==
Received: by mail-oo1-f46.google.com with SMTP id c12-20020a4ae24c0000b02901bad05f40e4so4231594oot.4;
        Mon, 22 Mar 2021 09:18:40 -0700 (PDT)
X-Gm-Message-State: AOAM533rtKEu4EuiKdnl90eGZFOs2PvTdzokZEqTxRvwLjGZS9aHo5si
        rY7ByuhKBUxXecEJAYXQlD2BpoPJzzuuofMQbCg=
X-Google-Smtp-Source: ABdhPJwJATAkvz6Hx4t7tPk8luQsFyzCoSamruM/CA7kbTtDRxjBf2ZNGWPmV0U+ze4BLpzCNUki46jerr63RaDhEzQ=
X-Received: by 2002:a4a:244d:: with SMTP id v13mr287550oov.66.1616429919879;
 Mon, 22 Mar 2021 09:18:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210322114441.3479365-1-arnd@kernel.org> <20210322154735.GA2079192@infradead.org>
 <20210322155344.GA23040@1wt.eu>
In-Reply-To: <20210322155344.GA23040@1wt.eu>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Mon, 22 Mar 2021 17:18:23 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1bb4QvNyM9kkt0KB9k70cdEZ-e+B-CHHtPhaPO6ouxeQ@mail.gmail.com>
Message-ID: <CAK8P3a1bb4QvNyM9kkt0KB9k70cdEZ-e+B-CHHtPhaPO6ouxeQ@mail.gmail.com>
Subject: Re: [PATCH] target: pscsi: avoid Wempty-body warning
To:     Willy Tarreau <w@1wt.eu>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        target-devel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Mar 22, 2021 at 4:53 PM Willy Tarreau <w@1wt.eu> wrote:
> On Mon, Mar 22, 2021 at 03:47:35PM +0000, Christoph Hellwig wrote:
> > On Mon, Mar 22, 2021 at 12:44:34PM +0100, Arnd Bergmann wrote:
> > > From: Arnd Bergmann <arnd@arndb.de>
> > >
> > > Building with 'make W=1' shows a harmless warning for pscsi:
> > >
> > > drivers/target/target_core_pscsi.c: In function 'pscsi_complete_cmd':
> > > drivers/target/target_core_pscsi.c:624:33: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
> > >   624 |                                 ; /* XXX: TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE */
> > >       |                                 ^
> > >
> > > Rework the coding style as suggested by gcc to avoid the warning.
> >
> > I would much, much prefer to drop the bogus warning;
> >
> >       if (foo)
> >               ; /* comment */
> >
> > is a fairly usual and absolutely sensible style.  The warning on hte
> > other hand is completely stupid.
>
> Agreed!
>
> These days it seems there is a competition for the stupidest warning
> between compilers, and we've reached the point where working around
> them manages to introduce real bugs :-(
>
> I predict we'll soon see warning such as "this comment looks like valid
> C code, if you really intended to comment it out, use #if 0 instead". Oh
> well, let's hope I have not given a new idea here...

I agree that this instance of the warning is particularly stupid, but the
I'd like to leave the warning option there and eventually enable it by
default because it tends to find other more interesting cases, and this
one is trivial to work around.

I remember previously fixing a few drivers that did obviously
incorrect things like

    if (error); /* note the extra ';' */
         return error;

and a lot mostly harmless code like

#ifdef DEBUG_THIS_DRIVER /* always disabled */
#define dprintk(args...) printk(args)
#else
#define dprintk(args...)
#endif
    /* note the mismatched format string */
    dprintk(KERN_WARNING "error %d\n", &object);

Turning the empty dprintk() into no_printk() means we can catch
the wrong format string during compile testing.

        Arnd
