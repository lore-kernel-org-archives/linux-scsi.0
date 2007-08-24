From: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [PATCH 19/30] scsi: Remove explicit casts of [kv]alloc return values in osst driver
Date: Fri, 24 Aug 2007 10:46:59 +0200
Message-ID: <9a8748490708240146y2ce04ac6jb434ebb10e4ec041@mail.gmail.com>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
	 <aaed77aa8511322bc32b406a952c7c960091ff3b.1187912217.git.jesper.juhl@gmail.com>
	 <200708240905.04994.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.233]:27259 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbXHXIrA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Aug 2007 04:47:00 -0400
Received: by wr-out-0506.google.com with SMTP id 36so581010wra
        for <linux-scsi@vger.kernel.org>; Fri, 24 Aug 2007 01:46:59 -0700 (PDT)
In-Reply-To: <200708240905.04994.eike-kernel@sf-tec.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, Willem Riede <osst@riede.org>, osst-users@lists.sourceforge.net

On 24/08/07, Rolf Eike Beer <eike-kernel@sf-tec.de> wrote:
> Jesper Juhl wrote:
> > [kv]alloc() return void *. No need to cast the return value.
>
> > @@ -5756,7 +5756,7 @@ static int osst_probe(struct device *dev)
> >       write_lock(&os_scsi_tapes_lock);
> >       if (os_scsi_tapes == NULL) {
> >               os_scsi_tapes =
> > -                     (struct osst_tape **)kmalloc(osst_max_dev * sizeof(struct osst_tape *),
> > +                     kmalloc(osst_max_dev * sizeof(struct osst_tape *),
> >                                  GFP_ATOMIC);
> >               if (os_scsi_tapes == NULL) {
> >                       write_unlock(&os_scsi_tapes_lock);
>
> Three lines later:
>
>                 for (i=0; i < osst_max_dev; ++i) os_scsi_tapes[i] = NULL;
>
> This wants to be
>
> os_scsi_tapes = kcalloc(osst_max_dev, sizeof(struct osst_tape *), GFP_ATOMIC);
>

Thank you for pointing that out.

I plan to resend those patches that don't get picked up in about a
week or so. I'll address this issue then (or if it does get picked up
in its current form I'll submit a follow-on patch to address this).


> Eike

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
