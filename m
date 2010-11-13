From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] SCSI queuecommand API change for 2.6.37-rc1
Date: Fri, 12 Nov 2010 17:42:06 -0800
Message-ID: <AANLkTinj2BM2eGo2yyfzs=t+nu79WLW_bGYota9sDZwH@mail.gmail.com>
References: <1289606118.3015.539.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51543 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751540Ab0KMBm7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Nov 2010 20:42:59 -0500
In-Reply-To: <1289606118.3015.539.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Fri, Nov 12, 2010 at 3:55 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
>
> This patch set contains a single patch modifying the SCSI queuecomman=
d
> host template API to go from being called with the host lock held to
> being called locklessly. =A0The transformation is a directly equivale=
nt
> one (i.e. the locking is simply pushed into each HBA) but will form t=
he
> basis for optimising locking in the driver patch for the next merge
> window.

Ok, so we talked about this patch at the KS, but I never saw it.

And now seeing it, I do detest it.

Why? Because if some driver gets missed for any reason (notably if
it's currently out of tree, and gets merged later), afaik there will
be ABSOLUTELY ZERO compiler warnings or anything about it, because you
kept the "queuecommand" function exactly the same. Whether it's a
locked or non-locked one, it always is of type

    int func(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *));

so there is no inherent type safety. Nothing will ever notice. Not the
compiler, and probably not the user either, since a missed lock with
probably work in many cases.

So it's a flag-day change, but it's a flag-day change which makes it
_really_ easy to miss the fact that a big change had actually
happened.

And the sad thing is that this could _trivially_ have been fixed while
actually making the patch no bigger. Make the new function look like

   int func(struct Scsi_Host *shost, struct scsi_cmnd *cmd, void
(*done)(struct scsi_cmnd *));

instead, and that would have made the "DEF_SCSI_QCMD()" macro simpler
and cleaner, it would likely make the code better (since the caller
really already always has the 'shost' right there, so looking it up
agan in cmd->device->shost is just extra work), _and_ it would mean
that if some driver didn't get converted, the compiler would
automatically have noticed.

And the patch would look 100% the same, except for these three small
one-liner changes:
 - the additional one-liner change to the 'queuecommand' function
pointer description itself
 - the one-liner change to the actual call-site (which would now not
just drop the lock, it would pass in the extra argument)
 - DEF_SCSI_QCMD() would drop the "struct Scsi_Host *shost =3D .." line=
,
and instead just take the new argument

It wouldn't change the patch wrt any of the low-level drivers at all.
But it would add so much inherent safety against mistakes.

It would _also_ make it much clearer when each driver is then starting
to remove that use of the wrapper function. When you remove the
wrapper function, you'd probably remove the "_lck" thing at the end of
the name, but you'd also change the prototype. It would be a very
clear visual clue whether this was a properly converted driver, or
whether this was a driver that had never seen the whole locking change
at all.

So please: when you change the semantics of a function, just change
the function prototype (or function name) at the same time. Especially
when it comes to a driver interface, so that the drivers don't get
taken by surprise.

Type safety and automatic compiler warnings really are our friends.
Especially when the patch was presumably mostly auto-generated, and
maybe the script missed something, and missing some conversion has
such subtle effects.

                        Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
