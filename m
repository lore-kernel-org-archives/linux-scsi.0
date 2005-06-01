From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] saved and restore result for timed out commands
Date: Wed, 1 Jun 2005 17:26:34 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0506011708410.5912-100000@iolanthe.rowland.org>
References: <1117659647.5047.52.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:4566 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S261186AbVFAV0i
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Jun 2005 17:26:38 -0400
In-Reply-To: <1117659647.5047.52.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Doug Gilbert <dgilbert@interlog.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 1 Jun 2005, James Bottomley wrote:

> On Wed, 2005-06-01 at 14:45 -0400, Alan Stern wrote:
> > Has there been any more progress on this issue?
>=20
> Well, the patch is in scsi-misc, if that's what you're asking.

That's good.  Is it too much to ask for an additional patch to zero out
the sense data buffer after the error handler has finished with a comma=
nd? =20
After a transport error or a timeout there shouldn't be any sense data
(races aside), but the error handler often leaves apparently valid data=
 in
the buffer, unrelated to the original command.

By the way, is scsi-misc available anywhere as a patch (or set of
patches) for those of us not on the bleeding edge, or does it exist onl=
y=20
as a git repository?

> > I spoke with J=F6rg Schilling (author of the cdrecord package, a wi=
dely-used
> > sg client) and he said that failed operations should be retried
> > automatically if the command had not gotten as far as being sent on=
 the
> > bus -- e.g., if the host adapter driver's queue was full.  But if t=
he
> > command did get sent to the device then any subsequent failure shou=
ld be
> > reflected back to the client with no retrys.
>=20
> That's pretty much what we do now ... with the exception of QUEUE_FUL=
L
> and BUSY handling.  What's the actual problem you were discussing?

This isn't so much in response to a particular problem as it is an atte=
mpt=20
to make the Linux sg driver more useful.  (The discussion got started=20
because of an actual problem, but that problem was at the USB level, no=
t=20
the SCSI level.)

You may not have run across Schilling very much.  He's done a lot of=20
work on SCSI application programming on a variety of OS's.  His opinion=
 of=20
the Linux SCSI stack isn't very high, although admittedly many of the=20
problems he complains about only existed in much earlier versions of=20
Linux.  (Try reading through the some of the documentation or man pages=
=20
for cdrecord and you'll see what I mean.)

Anyway, he still talks about how Linux's sg interface is so much worse
than Solaris's.  Considering this issue of proper return codes and clie=
nt
control of the device, you can agree that he does have a point.  He mus=
t
think of himself purely as an applications programmer, not a kernel
programmer, because he hasn't done anything to _fix_ these problems -- =
he
prefers to complain about them.  So I decided to see if something could=
 be=20
done to fix this particular issue, which does appear to be genuine.

Overall, the motivation is simply to improve sg by making it more=20
transparent, giving clients more control over the device, and returning=
=20
valid and useful status.

Alan Stern

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
