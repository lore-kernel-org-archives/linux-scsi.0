From: Chris Clayton <chris2553@googlemail.com>
Subject: Re: 2.6.30-rc8 Oops whilst booting
Date: Mon, 8 Jun 2009 21:03:53 +0100
Message-ID: <200906082103.53281.chris2553@googlemail.com>
References: <200906061959.55592.chris2553@googlemail.com> <alpine.LFD.2.01.0906081120400.6847@localhost.localdomain> <c6b1100b0906081217t57484774w475f79a93d37c221@mail.gmail.com>
Reply-To: chris2553@googlemail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:62951 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbZFHUEx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2009 16:04:53 -0400
In-Reply-To: <c6b1100b0906081217t57484774w475f79a93d37c221@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, scsi <linux-scsi@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>

On Monday 08 June 2009, Chris Clayton wrote:
> Linus,
>
> 2009/6/8 Linus Torvalds <torvalds@linux-foundation.org>:
> > On Mon, 8 Jun 2009, Chris Clayton wrote:
> >> I can confirm that a kernel built with Jaswinder's patch applied
> >> survived 200 boots without a panic.
> >
> > Ok, goodie.
> >
> > Can you confirm that the further cleanup (removing the pointless 'r=
et'
> > variable and the useless empty checking around 'for_each_entry') al=
so
> > works for you?
> >
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Linus
> >
> > ---
> > =A0kernel/async.c | =A0 15 +++++----------
> > =A01 files changed, 5 insertions(+), 10 deletions(-)
> >
> > diff --git a/kernel/async.c b/kernel/async.c
> > index 5054030..27235f5 100644
> > --- a/kernel/async.c
> > +++ b/kernel/async.c
> > @@ -92,23 +92,18 @@ extern int initcall_debug;
> > =A0static async_cookie_t =A0__lowest_in_progress(struct list_head *=
running)
> > =A0{
> > =A0 =A0 =A0 =A0struct async_entry *entry;
> > - =A0 =A0 =A0 async_cookie_t ret =3D next_cookie; /* begin with "in=
finity" value
> > */
> >
> > =A0 =A0 =A0 =A0if (!list_empty(running)) {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0entry =3D list_first_entry(running,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct async_entry, =
list);
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D entry->cookie;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return entry->cookie;
> > =A0 =A0 =A0 =A0}
> >
> > - =A0 =A0 =A0 if (!list_empty(&async_pending)) {
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_for_each_entry(entry, &async_pen=
ding, list)
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (entry->running =3D=
=3D running) {
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D=
 entry->cookie;
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break=
;
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> > - =A0 =A0 =A0 }
> > + =A0 =A0 =A0 list_for_each_entry(entry, &async_pending, list)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (entry->running =3D=3D running)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return entry->cookie;
> >
> > - =A0 =A0 =A0 return ret;
> > + =A0 =A0 =A0 return next_cookie; =A0 =A0 /* "infinity" value */
> > =A0}
> >
> > =A0static async_cookie_t =A0lowest_in_progress(struct list_head *ru=
nning)
>
> Yes, rc8-git5 with your patch applied has booted 100 times without a =
panic.
>

=2E..so I should have added:

Tested-by: Chris Clayton <chris2553@googlemail.com>

> May I add that the people who thought of, designed and implemented
> kexec should have a large and shiny medals pinned to their chests.
> Well over 1000 kernel boots have been executed on my PC today and, if
> I hadn't been able to do that automatically with a few lines of scrip=
t
> at the head of /etc/rc.d/rc.local, I would have been bleary-eyed
> before noon :-)
>
> Chris



--=20
No, Sir; there is nothing which has yet been contrived by man, by which
so much happiness is produced as by a good tavern or inn - Doctor Samue=
l
Johnson
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
