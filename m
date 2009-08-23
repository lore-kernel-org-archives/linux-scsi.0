From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bugme-new] [Bug 14020] New: Stack trace when running smartctl
 on an USB disk
Date: Sun, 23 Aug 2009 12:24:47 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0908231216300.26309-100000@netrider.rowland.org>
References: <31690E3D-43A0-484D-9D65-C0003E033D1E@ime.usp.br>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:38593 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933922AbZHWQYp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Aug 2009 12:24:45 -0400
In-Reply-To: <31690E3D-43A0-484D-9D65-C0003E033D1E@ime.usp.br>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org

On Sun, 23 Aug 2009, Rog=E9rio Brito wrote:

> > The trace shows that something (presumably smartctl) sends a comman=
d
> > the drive doesn't understand.  The drive then violates the USB
> > mass-storage protocol, sending an invalid response.
>=20
> Right.
>=20
> > The kernel waits
> > for a proper response but nothing more happens, so after 30 seconds=
 =20
> > the
> > command times out and is aborted and the drive is reset.
>=20
> I'm not with the kernel sources here (so, I can't check the code), =20
> but is there any option to be able to log such invalid responses when=
 =20
> the kernel gets one? Perhaps the verbose USB logging does that?

There's no way to log the invalid responses because the kernel doesn't
realize they are invalid.  However the resets _do_ get logged; you can
see them in the logs you sent.

> > The command
> > then gets retried, and the same thing happens again.  The retries t=
ake
> > so long that the kernel complains about smartctl being blocked for =
=20
> > more
> > than 120 seconds -- that's the reason for the stack dump.
>=20
> Right.
>=20
> Geeez, Alan, is there any vendor out there that gets the USB =20
> implementation according to the specs?

There are some... but a lot of them mess it up.  :-(

> This is the 3rd USB device that I sent you some message about where =20
> the kernel moans about something that it doesn't understand (I can =20
> get you the vendor and device ids when I get home).
>=20
> I will test with some other devices that I have, just to see what =20
> their response is. :-(

Be sure to get usbmon traces.

> > So the problem has several causes.  One is that the drive is buggy =
(it
> > doesn't respond with an error code in the proper way when it =20
> > receives a
> > command it doesn't understand).  Another is that smartctl is trying=
 to
> > send commands in a form the drive can't handle.
>=20
> That's probably not smartctl, but the user (me) that is telling it to=
 =20
> use a given command set to check if the USB adapter understands/=20
> allows pass-thru of the SMART protocol to the drive.

Yes, it's entirely possible that this adapter does not understand the=20
pass-thru protocol you tried.  Isn't there more than one such protocol?

> > Finally, there's the
> > problem about all the retries taking too long.
>=20
> Is there anything that could be done about this?

The length of each timeout is adjustable in sysfs, but I don't remember=
=20
what attribute file you need to change.

Also, you could follow the instructions in those stack dumps.  They are
only warnings, not errors, and you can prevent the kernel from issuing
them.

> > Perhaps you can blame the kernel for spending too much time on =20
> > retries,
> > but the other two are the fault of the drive and smartctl.
>=20
> I understand the p-o-v of the kernel: some devices need a little bit =
=20
> more time on a retry, while others don't. There's no way to hardcode =
=20
> a once and for all behavior. It seems that an expensive solution to =20
> this would be to create (yet) another list of blacklisted devices =20
> (how many lists of quirks do we have in the kernel already---this is =
=20
> really causing some bloat, especially for some embedded devices). :-(
>=20
> OTOH, creating blacklists seem to not be the adequate (let alone =20
> "right") solution (see the ASUS/it87 monitoring cause) in many =20
> situations. :-/
>=20
>=20
> Thanks for your always kind messages, Rog=E9rio Brito.

You're welcome.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
