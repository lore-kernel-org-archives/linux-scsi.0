Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76EBEEB64DA
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Jul 2023 00:19:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbjGUATd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Jul 2023 20:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjGUATd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Jul 2023 20:19:33 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3EB5269A
        for <linux-scsi@vger.kernel.org>; Thu, 20 Jul 2023 17:19:31 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-57a6df91b1eso14440507b3.1
        for <linux-scsi@vger.kernel.org>; Thu, 20 Jul 2023 17:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mobile-mirkwood-net.20221208.gappssmtp.com; s=20221208; t=1689898770; x=1690503570;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k34IaOMjddk9vEMq2KmhQlgm5OvqR7O1AJD/+fcejls=;
        b=wT6IFDvagCqbT1eQ2x6hHLVIGWHbpELYYkTvdYCr59DlFuMrPsEP6qJapy2Mhq0zUS
         7FYlbMaQTpv0zSQNoBqp7Mz1KQtX5kwbGu9KpPvaQt67ySrnLlXKdrJBJ1366EHykcXK
         E2atgCUZpVbX+PDEqQRrHL8eI/Ww9zVLbl+UA7veEjGokQV5DgVem4/YfW8SSLjpNabw
         ooWnnB9ssnvao/Xunp1w6HsPhCrJv415DHvzfPkO6QVqO06298DE9v7YmrRK5F7JzD9M
         OffxZhlQun91xo6VZVrNRwSTrwRtZR3yY1P0sgNiUvpHFAQq5XDwyyf06cRPQAV/Hyhi
         HYmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689898770; x=1690503570;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k34IaOMjddk9vEMq2KmhQlgm5OvqR7O1AJD/+fcejls=;
        b=TKokQgdfTdGuRzShxnsLk296aZUqD7AuyPSfZyjNBM+ZQnrlQB67ev6uUeuS2svBdc
         k97skN27mi2jv2AsJ/FVAWVTUjCqQHO+1enuqcZGy13GJ3HXSFeNnU1+p+4gDw/u+XQr
         jFSUQReoeeJu/qSxeES9UJgiffuF3mqncK6Nkjunnn4y1ja6e3Qp5GQla9R7loI3Efh0
         F0x68N2/sFNS3qSco4kS1F7j83aH/D8wni1rtYJwAPVamaRd8Nbt9OY+c8Gx8UkmBl6P
         Ih7ylmMzUV9T93Cwg5kfnshoVCfNRp4uJUbifW6qE2ToTK/5WZtIJJdmphcu31GHhKm9
         O8aw==
X-Gm-Message-State: ABy/qLZgYDN+oULTexgfNGALHgthG5ybZEoY6jyp8fHYvnQajDNs75Lh
        8zV7aNGBjDMeQ9KKG83ruNR4ZBkTkwqlYv1SHgE0baFUDij5CuV3
X-Google-Smtp-Source: APBJJlGsCXtopaXnHOy0u6hXk8KUmU1/qwnhpyYR4tz3V2VfsEMrbKutaLtUpZwzrqDus+XkumGKvGHAoq4x5Tt9KIU=
X-Received: by 2002:a0d:d48f:0:b0:57a:6df7:5ccd with SMTP id
 w137-20020a0dd48f000000b0057a6df75ccdmr637482ywd.13.1689898770723; Thu, 20
 Jul 2023 17:19:30 -0700 (PDT)
MIME-Version: 1.0
References: <CALM2zXUDAqAzCQR+sJDwoxxEEnG7cLJ4QazCVscJX-rR49=V2A@mail.gmail.com>
 <fc9f01f1-deb2-cd05-c7ef-1e08ea1d8d60@suse.de>
In-Reply-To: <fc9f01f1-deb2-cd05-c7ef-1e08ea1d8d60@suse.de>
From:   Mike Edwards <medwards@mobile.mirkwood.net>
Date:   Thu, 20 Jul 2023 20:19:19 -0400
Message-ID: <CALM2zXU1xNn9X8NwYYsmPbpuA+8pnVL8N0zGhWYmJVTvryyG+Q@mail.gmail.com>
Subject: Re: Mylex AcceleRAID 170 + myrb/myrs causing crash
To:     Hannes Reinecke <hare@suse.de>
Cc:     linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This issue is now being tracked in the SUSE bugzilla as bug 1213537.

On Fri, Jul 14, 2023 at 2:04=E2=80=AFAM Hannes Reinecke <hare@suse.de> wrot=
e:
>
> On 7/13/23 21:21, Mike Edwards wrote:
> > I spun up an old machine (with an even older Mylex AcceleRAID card, the
> > 170 w/ a bios dated Jan 21, 2000 - yikes!) recently.  While this machin=
e
> > was running an old 4.7 kernel and booted fine, attempting to update it
> > to a modern release of Debian with a 6.1 kernel caused the kernel to
> > hang while booting, with a number of stuck tasks warnings, starting wit=
h
> > udev-worker and including kworker kernel processes.
> >
> > During troubleshooting, I was able to identify the myrb/myrs drivers
> > which replaced the old DAC960 driver (removed in commit
> > 6956b956934f10c19eca2a1d44f50a3bee860531) as the culprit.  The last
> > kernel to successfully boot on here is 4.19.x, while anything newer
> > exhibits the same stuck processes - and indeed, blacklisting the myrb
> > and myrs drivers allows 6.1 to boot on this machine.
> >
> > I know this card is functional, as I do have two drives attached to it,
> > and both it and the drives work fine in 4.19 and older kernels, so the
> > issue seems to be with the newer myrb/myrs drivers.  Is there a chance
> > of fixing the current drivers, or, at worst, reintroducing the old
> > deprecated DAC960 driver back into the kernel?  I'm not absolutely tied
> > to using that driver, other than 'it just works' for this card.
>
> Whee, someone is using it!
> I'm not alone!
>
> But sure, of course I'll help.
> Can you try install openSUSE Leap on it? Then you can open a bugzilla on
> our side, and we can track and discuss things there. Debugging via
> e-mail tends to be very distracting to others not directly involved.
>
> For starters, a message log might help. And please enable dynamic debug
> via
>
> echo 'file drivers/scsi/myrs.c +p' > \
>    /sys/kernel/debug/dynamic_debug/control
> echo 'file drivers/scsi/myrb.c +p' > \
>    /sys/kernel/debug/dynamic_debug/control
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                Kernel Storage Architect
> hare@suse.de                              +49 911 74053 688
> SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> HRB 36809 (AG N=C3=BCrnberg), Gesch=C3=A4ftsf=C3=BChrer: Ivo Totev, Andre=
w
> Myers, Andrew McDonald, Martje Boudien Moerman
>
