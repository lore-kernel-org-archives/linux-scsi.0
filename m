From: Norman Diamond <n0diamond-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was: ehci_hcd fails to read a single good block)
Date: Mon, 9 Apr 2012 11:25:14 +0900 (JST)
Message-ID: <582586.38117.qm@web100016.mail.kks.yahoo.co.jp>
References: <Pine.LNX.4.44L0.1204061221530.1392-100000@iolanthe.rowland.org>
Reply-To: n0diamond-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1204061221530.1392-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Alan Stern wrote:
> On Fri, 6 Apr 2012, Norman Diamond wrote:
[Alan Stern:]
>>> However there's no question that other bridges having the same vend=
or, product, and revision ID values as yours _did_ report the drive cap=
acity incorrectly; otherwise the quirk entry would not be there.  What =
I'm not sure of is whether those bridges went on to crash as dramatical=
ly as yours.
>>=20
>> Except that mine doesn't crash when trying to read a nonexistent blo=
ck, so the quirk handling still looks overly aggressive.
>=20
> You're not thinking about it the right way.=A0 If the quirk handling =
were any less agressive, it would fail to work entirely on some devices=
 (those that crash when trying to access a nonexistent block).

I see your point, regarding devices which differ from mine, and which p=
ossibly differ from the other user in 2004 since we don't really know t=
he reason for his crash (he might have had a bad block at or near the e=
nd of his drive).

> Such devices would not usable at all.

We are already in that situation because of the decrement.  If the driv=
e was partitioned while the drive was internally installed on an ATA ca=
ble, then the decrement now interferes with the usability of the drive =
regardless of whether the USB bridge really does or doesn't have a bug.=
  The current driver doesn't even give a chance.  Also, if the drive wa=
s partitioned when using a known non-buggy bridge, then the same situat=
ion happens when using a bridge whose status is ambiguous because the d=
river does a decrement.

> Besides, suppose this quirk entry were removed.=A0 What would happen =
with the other bridges with the same ID numbers that do not decrement t=
he block count properly?=A0 Linux would try to access the nonexistent l=
ast block, and the access would fail.=A0 Perhaps no unplug and replug w=
ould be needed, but any data destined for that block would be lost.

The present situation loses reads and writes of the last block when the=
 last block DOES exist.

>>>> This still makes me wonder why Windows is able to handle the same =
bridges.
>>>=20
>>> Probably because Windows does not try to read the last block, unles=
s it is occupied by a file.
>>=20
>> I think Windows does.=A0 At least in some cases the last block of a =
partition contains structural information and can't be used for files.=A0=
 At least in some cases Windows reports a file system error if that blo=
ck can't be accessed when trying to mount the partition.
>=20
> Not in any of the cases I have seen or heard of, but that isn't a ver=
y large sampling.

I found the reason for this.  In Windows 2000 and later, if Windows is =
creating the partitions, Windows deliberately avoids using the equivale=
nt of 1 emulated IDE cylinder (16065 sectors), in case the user decides=
 later to convert the drive from Windows basic format to Windows dynami=
c format.  Vista and later avoid using some different amount but the ef=
fect in our case is the same.  Windows doesn't try to use the last bloc=
k in such cases.

But Linux can.  I connected the drive to a known good USB-to-IDE bridge=
 and created an NTFS partition containing the last sector in the drive.

Then I connected the drive to my Prolific bridge.  Windows accessed the=
 NTFS partition with no problem, including its last sector.  But Linux =
gave an error.  Linux DOES also access the NTFS partition, but Linux gi=
ves an error that it truncated the partition because the partition runs=
 past the point where Linux thinks the drive ends, which is due to the =
decrement.

> You'll get an error right away; the partition-table-reading code does=
n't accept partitions that appear to extend past the end of the device.

I got an error in the log as you said, visible with dmesg.  But hal off=
ered to mount the partition, and fdisk displays the partition.  OK, aft=
er reporting things up to this point, let's try mounting the partition,=
 but read-only...  The mount command obeyed with no error message, and =
no further report to the log.  The ls command displays the contents (on=
ly System Volume Information at the moment, because Windows XP likes to=
 create restore points on USB drives).  But we know that Linux is acces=
sing a truncation of the partition.
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
