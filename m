From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was:
 ehci_hcd fails to read a single good block)
Date: Mon, 2 Apr 2012 14:40:38 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1204021430130.12349-100000@netrider.rowland.org>
References: <307043.7654.qm@web100016.mail.kks.yahoo.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <307043.7654.qm-W9a5FxB6bg95hgrKqgaBcEyFvBl6snHEEwWAM/ix52Y@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Norman Diamond <n0diamond-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2 Apr 2012, Norman Diamond wrote:

> First, more big news:
> My USB-to-IDE bridge DOES NOT CRASH when reading a bad block.  When a=
 Linux driver tries to reassign a new USB address and crashes the bridg=
e, the fault is a Linux driver.  (And when Windows forgets about the ex=
istence of the drive, the fault is Windows.)

You really should capture a usbmon trace while running the dd test. =20
That will show exactly what is happening.  See
Documentation/usb/usbmon.txt.

> >> There's still something wrong here.=A0 When the bridge is connecte=
d to Windows XP, Windows accesses the correct number of blocks.=A0 We n=
eed to find someone who has a non-working but indistinguishable bridge,=
 ask them to connect it to Windows XP, and see if Windows XP gets a num=
ber of blocks that is too large by 1.
> >=20
> > How would you tell?
>=20
> http://hdparm-win32.dyndns.org/hdparm/
>=20
> D:\hdparm for Windows\binary\hdparm-6.9-20070516.win32\bin>hdparm /de=
v/sdg
>=20
> /dev/sdg:
>  geometry     =3D 2432/255/63, sectors =3D 39070080, start =3D 0
>=20
> Windows did not get a number of blocks that was too large by 1.  The =
bridge provided the correct answer for READ CAPACITY, Windows accepted =
it, and Linux improperly subtracted 1.

How do you know?  That is, how do you know that the number printed by=20
hdparm above is the value used by Windows and not a value obtained=20
directly from the bridge by the hdparm program itself?

Not that I have any reason to doubt this result -- I have no way of=20
knowing whether or not Windows subtracts 1 from the value reported by=20
any USB-(S)ATA bridge.

By the way, just out of curiosity, why does it matter so much for your=20
program to know the exact number of blocks a drive contains?

> >>> There is no good solution to this problem.
> >>=20
> >> Agreed.
>=20
> Wrong.  We CAN try to read the last block that the bridge says exists=
, to see if it really exists or not.  (Well, only partly wrong.  Maybe =
there really are some bridges that crash in that situation, but mine do=
esn't, and a broken driver still needs fixing.)

Yes, there really are such bridges.  You can find reports from people=20
complaining about them in the email archives.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
