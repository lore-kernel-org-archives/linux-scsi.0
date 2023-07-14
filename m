Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF7E5EB64DC
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 15:04:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236282AbjGNPEO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 11:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236304AbjGNPEL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 11:04:11 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 819743A8E
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 08:04:02 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-577497ec6c6so20363837b3.2
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 08:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mobile-mirkwood-net.20221208.gappssmtp.com; s=20221208; t=1689347041; x=1691939041;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q3fJ1NiwBHJ+Twc3yB0FkABFjezFyJ/ncE5ZrSTtcFE=;
        b=ifMpMZRTjNrD5MKS7jpp5bqcoN1L/KBmLJ0tMXA1o0X1neS3auj13e0VkHeGFvVy5b
         UYmF4LFpYFBEwrc4He8iYNlaIxvREcykKeHPafhiM4TZlbVVRdCPr53yEYkq9wZr8f/g
         BM1qLh7/tU811M/sdWUg/PiQ3rBiYZAYOZdxY3lZ3rLC7sGPWjPvKDw0WizDxnGqDBtd
         7uYAqTxoSuJ9j1WX39SXCXKaOAIRuW4bn+0B1lqSZCocaC0E4EsbY1fxvPK+JRnKTLw8
         VdIP15J7MlE7qeJTvcu36HckWPtGd8VF2sfNOnfpYz85BFi9IQ6+MoVB5iMh99hVTpkt
         4qBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689347041; x=1691939041;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q3fJ1NiwBHJ+Twc3yB0FkABFjezFyJ/ncE5ZrSTtcFE=;
        b=k8lILMm7LjBy803xnIFJs38N/ZeDZmUm0FOn1IHCsU/d1AqAsAUFz8uEjT8w268NmU
         mP5CIRBIAVVdz01VIgw1CsqUEALqibz1Wp35vRh7lbggnw8m2mnAlAi47jaXcjj0myOa
         obyCS1yCzDfTVFMJvpQSboOKElKMN4pkrgPiED4rD8KM2zm9HbHN6GoUxma0eQE6FJRO
         aafHgCgSvHozsJqFk5VUfcRVIqKovp0NAuAjr4XfLXxRZf37zEW9xic7kuIIoOvy5piK
         V33mhxvn/JMPyzP4KzBOxBOERoccVWcrx9OlitlqTjoB89ZDn9eWkzCE9IrDYsRSZXyZ
         ruLQ==
X-Gm-Message-State: ABy/qLYiks5g47rTHmJXBG3yYZm9K6+eqx/jfNPPC2s+nVcZc4m0rJal
        1jgD0g2cqYQUQxEQj1vxxPA//8lw394FCk20fRwY+8BClG9Myb+6
X-Google-Smtp-Source: APBJJlHabOLYQZQmuroGLs6fpXVFJ+Ddy7lB7ENAbhc1seewwvKyvfcMDKbj8iVCnCI/T9RCHjNxJG9LzTU4JLFYRR0=
X-Received: by 2002:a0d:fc06:0:b0:576:97b7:9335 with SMTP id
 m6-20020a0dfc06000000b0057697b79335mr4917670ywf.52.1689347041293; Fri, 14 Jul
 2023 08:04:01 -0700 (PDT)
MIME-Version: 1.0
References: <CALM2zXUDAqAzCQR+sJDwoxxEEnG7cLJ4QazCVscJX-rR49=V2A@mail.gmail.com>
 <fc9f01f1-deb2-cd05-c7ef-1e08ea1d8d60@suse.de>
In-Reply-To: <fc9f01f1-deb2-cd05-c7ef-1e08ea1d8d60@suse.de>
From:   Mike Edwards <medwards@mobile.mirkwood.net>
Date:   Fri, 14 Jul 2023 11:03:50 -0400
Message-ID: <CALM2zXX9LfshDUaFpKL5KURQy7p8J=5KpSi_foVaC1BfAB9sJg@mail.gmail.com>
Subject: Re: Mylex AcceleRAID 170 + myrb/myrs causing crash
To:     Hannes Reinecke <hare@suse.de>
Cc:     linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I can try openSUSE Leap, certainly.

However, those debugging statements are going to be hard - the process
lockup occurs at initial module load, before init really starts doing
much of anything.  I've even tried passing init=3D/bin/bash on the
commandline, with no luck - I never made it to a shell before things
went south.  For the same reason, there are no logs to speak of, alas
- but I can try seeing if I can get a serial console going, as that
will let me dump output.

I'll verify that the driver in OpenSUSE Leap has the same issue, and
will open a bug report when it (almost certainly!) dies the same way.

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
