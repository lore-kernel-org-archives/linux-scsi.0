Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69DEBC4361A
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 08:39:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10CE420449
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 08:39:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729115AbgLDIjS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 03:39:18 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:42926 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729110AbgLDIjS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 03:39:18 -0500
Received: by mail-ot1-f66.google.com with SMTP id 11so4464934oty.9;
        Fri, 04 Dec 2020 00:39:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=85WE5u2j5hMfc/C5GbWvBbgQah+/rPALigryqx6bEEQ=;
        b=GBjKbgJ9x9kVdONaB2rId4OsTPObEtcsOeFcc9EAwS+Qt4YfFFCwGtNYSti3oWe/oa
         /Ryq6M7gAhIV8OlZX0iNEFBtfWhEPoZlMAXIo/PAx09tSov17eyZQGOypDq71/OLcmlb
         u69yJWb5WjRebJVeF/YM6xN4lhmL49lmRAE5vlFDZvQmUTxUtcmPI7sdvbK2opS2aFYo
         /aOX7eI+teb6we4loBqs45f3Bh5sas3GPuq/y/6bWSWpsJjgDg41RmijOfJqewrVWtpe
         dnmvZ/iAosPAvDftYN2VBM4U/RJNSjFfWsDCGohkc08/EnLdCewf8k6SG+JQzZPhsOBv
         V3RQ==
X-Gm-Message-State: AOAM533pZdjiTJv2umj2NG7cUDUCNIloPR8lVBPmQgQiETgZO1r2GtYC
        ILu4ClWGGpBC59uZ+CbPZ7Vl3ynFBhH1JO8T4fw=
X-Google-Smtp-Source: ABdhPJwnsAkm6sHVvamQUFKixxM4mk4fL4gjGJq5DfiAqHn1FIZR2Gq/EIVHXDwSgTiIlYlkJNyrE4Y58R24CjfeqTw=
X-Received: by 2002:a05:6830:1f5a:: with SMTP id u26mr2817060oth.250.1607071117561;
 Fri, 04 Dec 2020 00:38:37 -0800 (PST)
MIME-Version: 1.0
References: <58cf6feeaf5dae1ee0c78c1b25c00c73de15b087.1606805196.git.fthain@telegraphics.com.au>
 <20201201170547.d6ff743eeuh6en6s@linutronix.de> <alpine.LNX.2.23.453.2012040953030.6@nippy.intranet>
In-Reply-To: <alpine.LNX.2.23.453.2012040953030.6@nippy.intranet>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 4 Dec 2020 09:38:25 +0100
Message-ID: <CAMuHMdUYwUPWzhBD+MWJsjBvmb31T0=2j8d0_-f9Q0ocfBAs9A@mail.gmail.com>
Subject: Re: [PATCH] scsi/NCR5380: Remove in_interrupt() test
To:     Finn Thain <fthain@telegraphics.com.au>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        scsi <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Finn,

On Fri, Dec 4, 2020 at 12:11 AM Finn Thain <fthain@telegraphics.com.au> wrote:
> > --- a/drivers/scsi/g_NCR5380.c
> > +++ b/drivers/scsi/g_NCR5380.c
> > @@ -529,14 +529,14 @@ static inline int generic_NCR5380_precv(struct NCR5380_hostdata *hostdata,
> >               if (start == len - 128) {
> >                       /* Ignore End of DMA interrupt for the final buffer */
> >                       if (NCR5380_poll_politely(hostdata, hostdata->c400_ctl_status,
> > -                                               CSR_HOST_BUF_NOT_RDY, 0, HZ / 64) < 0)
> > +                                               CSR_HOST_BUF_NOT_RDY, 0, 0) < 0)
>
> You've put your finger on a known problem with certain
> NCR5380_poll_politely() call sites. That is, the nominal timeout, HZ / 64,
> is meaningless because it is ignored in atomic context. So you may as well
> specify 0 jiffies at these call sites. (There will be a 1 jiffy timeout
> applied regardless.)

Notwithstanding HZ / 64 breaks if HZ < 64.

Possible values of HZ in the kernel:

24
32
48
64
100
128
200
250
256
300
500
1000
1024
1200

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
