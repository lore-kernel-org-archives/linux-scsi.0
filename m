From: Arkadiusz Miskiewicz <arekm@maven.pl>
Subject: Re: 2.6.22 oops kernel BUG at block/elevator.c:366!
Date: Thu, 30 Aug 2007 13:29:37 +0200
Message-ID: <200708301329.37396.arekm@maven.pl>
References: <200708291950.14513.arekm@maven.pl> <200708292011.47134.arekm@maven.pl> <20070829181648.GD7932@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.carme.maven.pl ([193.239.45.138]:58014 "EHLO
	main.carme.maven.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbXH3L3m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Aug 2007 07:29:42 -0400
In-Reply-To: <20070829181648.GD7932@kernel.dk>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Ed Lin <ed.lin@promise.com>

On Wednesday 29 of August 2007, Jens Axboe wrote:
> On Wed, Aug 29 2007, Arkadiusz Miskiewicz wrote:
> > On Wednesday 29 of August 2007, Jens Axboe wrote:
> > > On Wed, Aug 29 2007, Arkadiusz Miskiewicz wrote:
> > > > On Wednesday 29 of August 2007, Jens Axboe wrote:
> > > > > On Wed, Aug 29 2007, Arkadiusz Miskiewicz wrote:
> > > > > > I guess I should sent these here since it looks like not sc=
si bug
> > > > > > anyway.
> > > > >
> > > > > It's stex, right? It seems to have some issues with multiple
> > > > > completions of commands, which craps out the block layer of c=
ourse.
> > > >
> > > > Yes, stex. I'm staying with 2.6.19 in that case since it works =
fine
> > > > in that version.
> > > >
> > > > So scsi bug ... 8-)
> > >
> > > And you based that conclusion on what exactly?
> >
> > Isn't drivers/scsi/* handled by linux-scsi@? (that's what I mean)
>
> Yep indeed, I thought you meant that it was a scsi bug (and not an st=
ex
> one). You could try and copy the 2.6.19 stex driver into 2.6.20 and s=
ee
> if that works, though.

Looks like this bug is known for months :-(

Ed Lin pointed to http://lkml.org/lkml/2007/1/23/268 with possible patc=
h (that=20
unfortunately serialises access to storage devices, well...)

There is also: http://bugzilla.kernel.org/show_bug.cgi?id=3D7842

I'm running 2.6.22 with that patch now, did huge (few hours) rsync that=
=20
previously caused oopses and now everything works properly.

Can we get some form of this patch into Linus tree?

--=20
Arkadiusz Mi=B6kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
