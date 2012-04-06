From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was:
 ehci_hcd fails to read a single good block)
Date: Fri, 6 Apr 2012 12:31:37 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1204061221530.1392-100000@iolanthe.rowland.org>
References: <124887.42544.qm@web100003.mail.kks.yahoo.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <124887.42544.qm-303aDswoEIYQKk/ZIwh3tkyFvBl6snHEEwWAM/ix52Y@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Norman Diamond <n0diamond-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 6 Apr 2012, Norman Diamond wrote:

> > However there's no question that other bridges having the same vend=
or, product, and revision ID values as yours _did_ report the drive cap=
acity incorrectly; otherwise the quirk entry would not be there.=A0 Wha=
t I'm not sure of is whether those bridges went on to crash as dramatic=
ally as yours.
>=20
> Except that mine doesn't crash when trying to read a nonexistent bloc=
k, so the quirk handling still looks overly aggressive.

You're not thinking about it the right way.  If the quirk handling were=
=20
any less agressive, it would fail to work entirely on some devices=20
(those that crash when trying to access a nonexistent block).  Such=20
devices would not usable at all.

Besides, suppose this quirk entry were removed.  What would happen with
the other bridges with the same ID numbers that do not decrement the
block count properly?  Linux would try to access the nonexistent last
block, and the access would fail.  Perhaps no unplug and replug would
be needed, but any data destined for that block would be lost.

> >> This still makes me wonder why Windows is able to handle the same =
bridges.
> >=20
> > Probably because Windows does not try to read the last block, unles=
s it is occupied by a file.
>=20
> I think Windows does.  At least in some cases the last block of a par=
tition contains structural information and can't be used for files.  At=
 least in some cases Windows reports a file system error if that block =
can't be accessed when trying to mount the partition.

Not in any of the cases I have seen or heard of, but that isn't a very=20
large sampling.

>  Now, Windows won't have this trouble with my bridge because Windows =
saw the correct drive size through my bridge.  Only Linux will have tro=
uble.  I'll have to see if I can create a suitable partition in Windows=
 and then get a Linux error when trying to mount the partition without =
its last sector.

You'll get an error right away; the partition-table-reading code
doesn't accept partitions that appear to extend past the end of the=20
device.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
