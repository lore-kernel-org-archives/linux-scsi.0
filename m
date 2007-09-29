From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [linux-usb-devel] question on flushing buffers and spinning down disk
Date: Sat, 29 Sep 2007 22:06:16 +0200
Message-ID: <200709292206.17377.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0709291428050.1094-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out001.kontent.com ([81.88.40.215]:46252 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758104AbXI2UFR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Sep 2007 16:05:17 -0400
In-Reply-To: <Pine.LNX.4.44L0.0709291428050.1094-100000@netrider.rowland.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Pavel Machek <pavel@ucw.cz>, linux-usb-devel@lists.sourceforge.net, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Am Samstag 29 September 2007 schrieb Alan Stern:
> I disagree. =A0That bug report shows that problems arise when we try =
to
> suspend a parent without making sure the children are suspended first=
=2E =A0
> If the sd suspend method had already run then it would have been okay
> for the enclosure to cut power.

That is true. The question is who is to call the suspend method.

> > Suspension in a higher layer can have effects that are different to=
 suspension
> > of all devices on a lower level. Therefore the higher level must as=
k the lower
> > level to prepare itself.
>=20
> When the lower level is suspended then it is supposed to be prepared=20
> for the higher layer to suspend. =A0No additional preparation should =
be=20
> needed.

Yes.
If it returns from suspend without error a driver must keep that guaran=
tee.

> (That's true for USB and SCSI. =A0Other buses can have additional=20
> complications, like PCI with its multiple D states. =A0But the princi=
ple=20
> remains the same.)
>=20
> > Ideally it would ask the lower level for permission to do an autosu=
spend. I'd
> > like to change the API so that you can do that. But I don't think t=
hat the
> > lower levels have to implement autosuspend on their own to have lev=
els
> > above them support autosuspend. Can you summarize your requirements
> > for supporting autosuspend in the higher levels?
>=20
> It's very simple: The higher level can't autosuspend if doing so woul=
d=20
> cause harm to the lower level.
>=20
> There are two ways to avoid harm. =A0One is for the lower level to be=
=20
> such that it can never be harmed, no matter what the higher level doe=
s. =A0
> For example, a purely logical entity like a partition won't be harmed=
=20
> if the drive it belongs to is suspended. =A0In fact we don't try to=20
> suspend partitions, and they don't even have drivers.
>=20
> The other way is for the lower level to be suspended already. =A0That=
's
> how the autosuspend framework operates: the lower level autosuspends
> and tells the higher level that it is now safe for the higher level t=
o

This is how the hub driver works.

> autosuspend. =A0It's not supposed to work by the higher level announc=
ing: =A0
> "I want to autosuspend now, so all you lower guys had better get
> ready."

I see. And there's an appealing simplicity to it. But why insist that
this is the one true way?
=20
> Even in the case of system suspend things don't work that way. =A0We
> don't have higher-level drivers telling lower-level drivers to suspen=
d. =A0
> Rather, the PM core (acting on behalf of the user) tells _every_ driv=
er
> to suspend -- in the correct order, of course.

True. And putting the notification into a driver is a kludge at best.
It simply was the only way I could come up with without moving
autosuspend into generic code.
Nevertheless, I am not convinced that autosuspend has to work
on the device level only.
=20
> Now, how much extra work is involved in having the lower-level driver=
s=20
> implement autosuspend as opposed to having the higher-level driver as=
k=20
> permission? =A0Not much more than adding the autosuspend timers. =A0
> Everything else is needed anyway for supporting manual runtime suspen=
d.

Move autosuspend into generic code and I'll certainly try to come up wi=
th
something better than what I wrote.

	Regards
		Oliver
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
