From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was:
 ehci_hcd fails to read a single good block)
Date: Mon, 9 Apr 2012 10:19:56 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1204091014220.1429-100000@iolanthe.rowland.org>
References: <137070.95048.qm@web100013.mail.kks.yahoo.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <137070.95048.qm-W9a5FxB6bg8QKk/ZIwh3tkyFvBl6snHEEwWAM/ix52Y@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Norman Diamond <n0diamond-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 9 Apr 2012, Norman Diamond wrote:

> I suggest that quirk processing should only try to read 1 block, the =
last block which is asserted to exist, and decrement if the read fails =
due to non-existence.  If the read fails for a different reason then th=
e block exists and the count should not be decremented.

I have tried to explain before that this is a very bad idea.  Bridges
that crash when attempting to read beyond the end of the device would
become totally unusable.

> > By the way, Linux's SCSI disk driver no longer does this.=A0 It is =
more cautious; accesses near the end of a USB device are broken up into=
 single-block reads or writes.=A0 However at the time the quirk entry w=
as added, the driver wasn't so careful.
>=20
> Which means that someone's bridge might have crashed due to a bad
> block at or near the end of the drive.

More likely the bridge crashed because it was unable to handle a
multiple-block read whereas it could have handled a single-block read.

Regardless, we are now stuck.  We don't dare remove the existing quirk
entries because of the potential for breaking systems that currently
work.  If you can suggest a way of detecting whether or not the
capacity value is correct that will not break any existing systems, I
would be extremely glad to hear it.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
