From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was:
 ehci_hcd fails to read a single good block)
Date: Fri, 30 Mar 2012 10:20:52 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1203301011050.1280-100000@iolanthe.rowland.org>
References: <662659.4715.qm@web100001.mail.kks.yahoo.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <662659.4715.qm-303aDswoEIb1/UedTyKF90yFvBl6snHEEwWAM/ix52Y@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Norman Diamond <n0diamond-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 30 Mar 2012, Norman Diamond wrote:

> > It is a separate value from the product ID.=C2=A0 It appears in the=
 output from "lsusb -v" or in /sys/kernel/debug/usb/devices (where it i=
s labelled "Rev=3D").
>=20
> bcdDevice is 1.00

That's the same as a bridge that was reported non-working.  Which means=
=20
the OS has no way to tell them apart.

> >> It is hard to imagine a USB bridge adding 1 to the number of block=
s.=C2=A0 Did that really happen?
> >=20
> > No.=C2=A0 What happened was that the bridge reported the number of =
blocks, but SCSI's READ CAPACITY command requires the device to report =
the highest available block number (which is one smaller since blocks a=
re numbered starting from 0).
>=20
> I guess you mean that some USB bridges screw up the result of the REA=
D CAPACITY command, so you have to subtract 1 in those cases.  This par=
ticular bridge isn't one of them, and the subtraction of 1 was wrong in=
 this case.

True, but the computer has no way to know.  However you can tell
usb-storage not to manipulate the capacity of your drive by specifying
a module parameter:

	modprobe usb-storage quirks=3D067b:2507:

> hdparm reports the bugged capacity after the incorrect subtraction of=
 1.  HDIO_GETGEO_BIG also gets the bugged capacity.  I don't see an opt=
ion to sdparm to get the device capacity (real SCSI devices probably ha=
ve it in a VPD page but this USB bridge doesn't provide any VPD pages).

I don't know if the information would be in a VPD page or not. =20
There's not much point in putting it there, since it's already
available via READ CAPACITY.

> sg_dd with correct parameters successfully read the actual last block=
!  That must be because sg_dd accessed /dev/sgsomething instead of /dev=
/sdmumble.
>=20
> My program doesn't know if a USB bridge is defective and/or if a driv=
er defectively manipulated a block count.  So I have to open a /dev/sgs=
omething, try to read 1 sector past the last sector that we think is va=
lid.  If it fails then I have to find out if the error was due to nonex=
istence or other reason.  If it succeeds then I have to execute more pa=
inful hacks that I have to add.

It's not as simple as that.  With many bridges, if you test to see=20
whether the block count is too small by trying to read "the block=20
beyond the end", you will hang the bridge -- requiring an unplug to=20
fix.

There is no good solution to this problem.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
