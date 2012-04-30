From: Norman Diamond <n0diamond@yahoo.co.jp>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was: ehci_hcd fails to read a single good block)
Date: Tue, 1 May 2012 08:07:21 +0900 (JST)
Message-ID: <909120.88778.qm@web100007.mail.kks.yahoo.co.jp>
References: <Pine.LNX.4.44L0.1204301523120.1558-100000@iolanthe.rowland.org>
Reply-To: n0diamond@yahoo.co.jp
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web100007.mail.kks.yahoo.co.jp ([114.111.98.181]:47620 "HELO
	web100007.mail.kks.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756283Ab2D3XHY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Apr 2012 19:07:24 -0400
In-Reply-To: <Pine.LNX.4.44L0.1204301523120.1558-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

Alan Stern wrote:
> On Mon, 30 Apr 2012, Norman Diamond wrote:
>=20
>> Here you are modifying my proposal.=C2=A0 It is no problem to discus=
s your
>> idea.=C2=A0 At first I thought your idea was better than mine, but o=
n
>> second thought, sorry, here's a problem.=C2=A0 Again it is because t=
he
>> broken and unbroken Prolific bridges are indistinguishable.=C2=A0 A
>> Prolific bridge could be connected to a drive whose actual usable
>> capacity is a multiple of 63, or it could be connected to a modern
>> drive with emulated capacity that is even (in fact a multiple of 8)
>> and not usually a multiple of 63.
>>=20
>> Therefore I still favour my version.=C2=A0 If the bridge reports an =
even
>> number then I want to believe it, if the bridge reports a multiple o=
f
>> 63 then I want to believe it, and if neither then I want to fall bac=
k
>> on the existing heuristic which performs a decrement.
>=20
> Hmmm.=C2=A0 What about when one of the broken bridges with an older d=
rive
> reports a number which is 1 larger than a multiple of 63 but also
> happens to be even?=C2=A0 In that case your proposed heuristic would =
fail --
> but then so would the existing heuristic, so we'd be no worse off tha=
n
> we are now.

Exactly.  It's not perfect but the improvements far outweigh the downsi=
de.

> I still think your proposed heuristic should be handled separately fr=
om=20
> the existing one, so that it would not be applied in situations where=
=20
> we know the device is not a USB-(S)ATA bridge.

OK.  One quirk for bridges (accept even numbers, accept multiples of 63=
, and otherwise decrement) and one quirk for other kinds of devices (ac=
cept even numbers and otherwise decrement, i.e. the present heuristic).

>>> As for whether we need TEST_CAPACITY...=EF=BF=BD That is still high=
ly
>>> debatable.=EF=BF=BD If we did have it, which quirk entries would us=
e it?=EF=BF=BD So
>>> far the only candidate we have is your Prolific bridge, and even th=
ere
>>> it seems that the divisible-by-63 heuristic would work just as well=
=2E
>>=20
>> I wish I could get a broken Prolific bridge to test together with
> > mine.=C2=A0 Anyway the divisible-by-63 heuristic would work better =
than
> > the existing heuristic but it would not work as well as
> > TEST_CAPACITY.=C2=A0 My proposed modified heursitic would usually w=
ork
> > better than the existing heuristic but not as well as TEST_CAPACITY=
=2E
>=20
> How do you know?=C2=A0 You haven't read through ten years' worth of e=
mail=20
> messages on this subject, have you?=C2=A0 You're going on the basis o=
f your=20
> experience with _one_ bridge and a couple of drives.

Because we do know there are a lot of multiples of 63 out there, and be=
cause if the bridge reports a capacity that is a multiple of 63 (i.e. m=
aximum LBA one less than a multiple of 63) and we try reading that last=
 block then it should be read successfully.  The only time we have to w=
orry about TEST_CAPACITY is a pretty rare case -- and even in such rare=
 cases, we don't know if the bridge will always hang in those cases.=20

My bridge appeared to hang on reading multiple nonexistent blocks but n=
ot on reading a single nonexistent block, and at this moment it looks l=
ike it might not even be the bridge's fault (I have to test it on more =
drives).

> By the way, have you tried connecting your bridge to a CD/DVD drive?

I have read CDs through it.  I never thought of inquring the capacity.

>> By the way, a while back you asked what happens if I use sg_dd to tr=
y
>> reading multiple blocks including the last existing block and some
>> non-existing ones.=C2=A0 The answer seems to depend on the drive as =
well
>> as the method of connection (USB-to-PATA vs. eSATA plus
>> SATA-to-PATA).=C2=A0 With the drive that I've usually been using I t=
hink
>> the drive hangs so we can't really figure out whether to blame the
>> bridge.=C2=A0 With a different drive the drive reports the error but=
 sg_dd
>> and Linux drivers do something to retry so many times that after 30
>> minutes I lost patience waiting for sg_dd to finish and report its
>> error.
>=20
> Indeed -- that's exactly the sort of thing which could happen with
> TEST_CAPACITY.=C2=A0 It's one of the reasons I'm cautious about addin=
g
> TEST_CAPACITY and an example of why TEST_CAPACITY might not work as=20
> well as you think.

Correction:  Therefore TEST_CAPACITY should not try to read multiple bl=
ocks in one read.

Your other message says you have a different model of Prolific bridge w=
hich has the capacity bug but which is (sadly at this moment) distingui=
shable from mine.  Anyway, what happens if you try to read the last blo=
ck that the bridge asserted to exist?  Also for curiosity what happens =
if you try to read multiple nonexistent blocks, but that curiosity is i=
rrelevant to the single block that TEST_CAPACITY would try to read.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
