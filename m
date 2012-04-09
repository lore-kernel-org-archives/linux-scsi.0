From: Norman Diamond <n0diamond@yahoo.co.jp>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was: ehci_hcd fails to read a single good block)
Date: Tue, 10 Apr 2012 07:21:00 +0900 (JST)
Message-ID: <33113.94633.qm@web100010.mail.kks.yahoo.co.jp>
References: <Pine.LNX.4.44L0.1204091030260.1429-100000@iolanthe.rowland.org>
Reply-To: n0diamond@yahoo.co.jp
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web100010.mail.kks.yahoo.co.jp ([114.111.98.184]:43790 "HELO
	web100010.mail.kks.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751256Ab2DIWVD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Apr 2012 18:21:03 -0400
In-Reply-To: <Pine.LNX.4.44L0.1204091030260.1429-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

Alan Stern wrote:
> On Mon, 9 Apr 2012, Norman Diamond wrote:
[Alan Stern:]
>>> You're not thinking about it the right way.  If the quirk handling =
were any less agressive, it would fail to work entirely on some devices=
 (those that crash when trying to access a nonexistent block).
>>=20
>> I see your point, regarding devices which differ from mine, and whic=
h possibly differ from the other user in 2004 since we don't really kno=
w the reason for his crash (he might have had a bad block at or near th=
e end of his drive).
>>=20
>>> Such devices would not usable at all.
>>=20
>> We are already in that situation because of the decrement.
>=20
> No.=A0 That statement is simply wrong.=A0 Such devices are quite usab=
le.

As you saw yesterday, Linux truncated my existing NTFS partition, which=
 had been created properly by Linux with a different USB-to-IDE bridge.=
  Such devices are not fully usable, and not quite usable when they wer=
e partitioned while connected through bridges that Linux was fully happ=
y to use.

>>=A0 If the drive was partitioned while the drive was internally insta=
lled on an ATA cable, then the decrement now interferes with the usabil=
ity of the drive regardless of whether the USB bridge really does or do=
esn't have a bug.
>=20
> What are you talking about?=A0 If the bridge does have the capacity b=
ug then the decrement allows the bridge to be used correctly.

And when the bridge doesn't have the capacity bug, as mine doesn't, the=
 present level of quirk handling truncates the partition, as it did yes=
terday and as I reported yesterday.

>>=A0 Also, if the drive was partitioned when using a known non-buggy b=
ridge, then the same situation happens when using a bridge whose status=
 is ambiguous because the driver does a decrement.
>=20
> It is true that the current situation sometimes denies access to a bl=
ock which might work perfectly well.

Yes, and one paragraph earlier I described the same case where a drive =
had previously been connected directly to an ATA controller instead of =
a fully Linux-accepted USB bridge.  A block which already has been in u=
se now gets denied access.

> But we don't have any better solutions.

In some cases we do.

> And don't forget, in any individual case it is always possible to dis=
able the quirk by means of a module parameter.

Yes, I remember you mentioned that a week or two ago, and I need to loo=
k at the modconf files.  But I have to be capable of doing something re=
asonable with other bridges too, and the kinds of actions that are reas=
onable in my situation are different from yours.  I cannot deny access =
to the last block.  In my situation it is better to let a buggy bridge =
hang, so that the user knows they need to change bridges.

>>> Besides, suppose this quirk entry were removed.  What would happen =
with the other bridges with the same ID numbers that do not decrement t=
he block count properly?  Linux would try to access the nonexistent las=
t block, and the access would fail.  Perhaps no unplug and replug would=
 be needed, but any data destined for that block would be lost.
>>=20
>> The present situation loses reads and writes of the last block when =
the last block DOES exist.
>=20
> No, it doesn't; it prevents those reads and writes from being attempt=
ed in the first place.

Correction:  yes it does, exactly because it prevents those reads and w=
rites from being attempted in the first place.  As I described yesterda=
y, I used a different bridge (one that Linux fully accepts) and created=
 an NTFS partition ending in the actual last sector of the drive.  Then=
 when using my Prolific bridge, Linux prevented reads and writes of the=
 last block from being attempted in the first place.  The present situa=
tion loses reads and writes of the last block when the last block DOES =
exist and contains NTFS metadata.

> You probably don't care about this distinction, however.

I do understand the distinction between losing reads and writes because=
 of one reason and losing reads and writes because of a different reaso=
n.  But in my situation I cannot lose reads and writes that users expec=
t to take place, and I cannot give the excuse that they were lost becau=
se of one reason instead of a different reason.

> If you're trying to make a point in this discussion, I can't tell wha=
t it is.=A0 I already know that decrementing the capacity is not always=
 the right thing to do.=A0 But I don't know of any better alternative.

I do think that we can try to read the single last block that the bridg=
e asserts to exist, except in cases where a bridge has been observed to=
 hang when when trying to read the single last asserted block (not mult=
iples) where the bridge lied about the existence.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
