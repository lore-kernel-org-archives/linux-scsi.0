From: Norman Diamond <n0diamond@yahoo.co.jp>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was: ehci_hcd fails to read a single good block)
Date: Mon, 2 Apr 2012 13:25:05 +0900 (JST)
Message-ID: <307043.7654.qm@web100016.mail.kks.yahoo.co.jp>
References: <Pine.LNX.4.44L0.1203311121560.27759-100000@netrider.rowland.org>
Reply-To: n0diamond@yahoo.co.jp
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web100016.mail.kks.yahoo.co.jp ([114.111.98.190]:23076 "HELO
	web100016.mail.kks.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750846Ab2DBEZI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Apr 2012 00:25:08 -0400
In-Reply-To: <Pine.LNX.4.44L0.1203311121560.27759-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

=46irst, more big news:
My USB-to-IDE bridge DOES NOT CRASH when reading a bad block.  When a L=
inux driver tries to reassign a new USB address and crashes the bridge,=
 the fault is a Linux driver.  (And when Windows forgets about the exis=
tence of the drive, the fault is Windows.)

echo 0 >/sys/block/sdc/queue/read_ahead_kb
might or might not be necessary; I haven't tried sg_dd without it.

sg_dd if=3D/dev/sdc bs=3D512 count=3D1 bpt=3D1 blk_sgio=3D1 skip=3D3907=
0080 | od
gets the error that I expected because the block doesn't exist.  dmesg =
does not show the error; sg_dd detected the error and displayed it on t=
he terminal.  Next I can do this:
sg_dd if=3D/dev/sdc bs=3D512 count=3D1 bpt=3D1 blk_sgio=3D1 skip=3D3907=
0079 | od
and get the contents of the last block.

sg_dd if=3D/dev/sdc bs=3D512 count=3D1 bpt=3D1 blk_sgio=3D1 skip=3D5515=
62 | od
gets the error that I expected because the block is bad.  dmesg does no=
t show the error; sg_dd detected the error and displayed it on the term=
inal.  Next I can do this:
sg_dd if=3D/dev/sdc bs=3D512 count=3D1 bpt=3D1 blk_sgio=3D1 skip=3D5515=
63 | od
and get the contents of the block after the bad block.

The USB cable did not need to be unplugged and replugged.

Therefore when an ordinary dd fails and a USB driver tries to assign a =
new address but fails, and the USB cable has to be unplugged and replug=
ged, the fault is a driver.

Alan Stern wrote:
> On Sat, 31 Mar 2012, Norman Diamond wrote:
>=20
>>>> bcdDevice is 1.00
>>>
>>> That's the same as a bridge that was reported non-working.=A0 Which=
 means the OS has no way to tell them apart.
>>=20
>> There's still something wrong here.=A0 When the bridge is connected =
to Windows XP, Windows accesses the correct number of blocks.=A0 We nee=
d to find someone who has a non-working but indistinguishable bridge, a=
sk them to connect it to Windows XP, and see if Windows XP gets a numbe=
r of blocks that is too large by 1.
>=20
> How would you tell?

http://hdparm-win32.dyndns.org/hdparm/

D:\hdparm for Windows\binary\hdparm-6.9-20070516.win32\bin>hdparm /dev/=
sdg

/dev/sdg:
 geometry     =3D 2432/255/63, sectors =3D 39070080, start =3D 0

Windows did not get a number of blocks that was too large by 1.  The br=
idge provided the correct answer for READ CAPACITY, Windows accepted it=
, and Linux improperly subtracted 1.

> And what's so special about XP?=A0 Why not Vista or Windows 7?

OK, I have Windows 7 installed in two computers (64 bit and 32 bit) and=
 should try the Windows port of the obsolete version of hdparm.

>>> There is no good solution to this problem.
>>=20
>> Agreed.

Wrong.  We CAN try to read the last block that the bridge says exists, =
to see if it really exists or not.  (Well, only partly wrong.  Maybe th=
ere really are some bridges that crash in that situation, but mine does=
n't, and a broken driver still needs fixing.)

>>=A0 But in my case I think I need to disable that quirk entirely for =
all USB bridges, so that my uses of Linux will always believe what the =
USB bridge reports.=A0 At least then my program will work correctly whe=
n working bridges are attached.=A0 Then if a user complains, we can tel=
l them to use a different bridge.
>
> Well, if you want to disable the quirk entirely, it's not hard to do.=
=A0=20
> In drivers/usb/storage/scsiglue.c, just get rid of the lines that set=
=20
> sdev->fix_capacity and sdev->guess_capacity.
>=20
> If you want to find out who reported the problems with the bridge chi=
p, look in the unusual_devs.h file for the entry with vendor ID 0x067b =
and product ID 0x2507.

Uh, then feel free to credit me in that file for reporting that the sam=
e bridge works  ^_^
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
