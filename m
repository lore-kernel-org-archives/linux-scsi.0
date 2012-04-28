From: Norman Diamond <n0diamond@yahoo.co.jp>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was: ehci_hcd fails to read a single good block)
Date: Sat, 28 Apr 2012 09:59:52 +0900 (JST)
Message-ID: <760201.32872.qm@web100018.mail.kks.yahoo.co.jp>
References: <Pine.LNX.4.44L0.1204271036480.1690-100000@iolanthe.rowland.org>
Reply-To: n0diamond@yahoo.co.jp
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web100018.mail.kks.yahoo.co.jp ([114.111.98.192]:42410 "HELO
	web100018.mail.kks.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758582Ab2D1A7y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Apr 2012 20:59:54 -0400
In-Reply-To: <Pine.LNX.4.44L0.1204271036480.1690-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

Alan Stern wrote:
> On Fri, 27 Apr 2012, Norman Diamond wrote:
>>> Let's just not worry about it.  It seems pretty clear that the patc=
hes=20
>>> will fix your immediate problem.
>>=20
>> Only partly, because an odd multiple of 63 is possible.
>=20
> Look, I didn't say the changes would help with every possible disk.=A0=
=20
> Just that they would fix your immediate problem, i.e., the problem wi=
th
> your current disk.

"Look" ...
We already found a workaround for what you thought was my immediate pro=
blem, one of the bridges that can test with and one of the disks that I=
 can test with.  A kernel boot parameter can remove all quirks flags fo=
r the Prolific bridge.

That is not a fix for what really is my immediate problem, which is tha=
t my users can have any kind of bridge and any kind of disk, and in an =
emergency I can tell them to add a kernel boot parameter, or see if the=
y can use a different bridge, etc., but it's really better if we can av=
oid such emergencies.

>>> What about a device that has 6362 sectors but reports 6363?  Then y=
our=20
>>> test would fail to decrement the value when we do want to.
>>=20
>> But we can't distinguish two versions of the device, one where 6363
>> is correct and one where 6363 is wrong.=A0 I prefer to take the
>> device's word for it unless we know for sure that it is wrong.=A0=20
>> TEST_CAPACITY would still be a good idea.=A0 FIX_CAPACITY (where we
>> know for sure that the device is wrong) will not suffer from this
>> ambiguity and will always get a decrement.
>=20
> That's the whole point of CAPACITY_HEURISTICS -- we have two versions=
=20
> of the device, of which one is buggy and the other isn't, and we can'=
t=20
> tell them apart.=A0 If we preferred to take the device's word for it=20
> whenever we didn't know for sure, there would be no need for=20
> CAPACITY_HEURISTICS at all.

A preference for taking the device's word (in cases where we don't have=
 a more reliable heuristic) is different from always taking the device'=
s word (in all cases even when we have a more reliable heuristic).  CAP=
ACITY_HEURISTICS will remain meaningful and will become more meaningful=
=2E

> For example, consider all those cameras sold by Nikon, Pentax, and so
> on.=A0 They probably all used Symbian's firmware, which some years ag=
o=A0=20
> had the capacity bug.=A0 Maybe the firmware has been fixed since then=
; I
> don't know.=A0 But under the reasonable assumption that the
> SD/CF/whatever memories used in these cameras will always have an eve=
n=20
> number of blocks, the existing CAPACITY_HEURISTICS solution is=20
> appropriate.

If you think that a revised CAPACITY_HEURISTICS incorporating my sugges=
tion will become less appropriate than the existing CAPACITY_HEURISTICS=
 then we need two separate heuristics, one for Symbian and similar, one=
 for Prolific and similar.  And we even more surely do need TEST_CAPACI=
TY.

>>> Anyway, why do you want to test for n % 63 !=3D 0?  You have no
>>> justification for decrementing the block count if the result would
>>> not be divisible by 63.
>>=20
>> I sure do.=A0 You know as well as I do that for decades a lot of ATA
>> disks reported capacities that were multiples of 63 and they had a
>> reason for it.
>=20
> ?=A0 That makes no sense.=A0 Go back and reread what I wrote.=A0 In=20
> particular, I was asking why you changed the test from (n % 63 =3D=3D=
 1) to=20
> (n % 63 !=3D 0).

My change was bigger than that.  Where you had ||, I had &&, though in =
one of my two codings I accidentally deleted one of the &&s.

6363 is an example.  Your code would cut it to 6362.  I think it should=
 stay 6363, because for decates a lot of ATA disks reported capacities =
that were multiples of 63.

> You know that for decades, ATA disks have reported capacities that we=
re
> multiples of 63.=A0 So if a drive reports a capacity that is 5 larger
> than a multiple of 63, why would you want to decrement the value?

Where a report is 5 larger than a multiple of 63, I left the existing h=
euristic intact.  I suggested only modifying the heuristic to avoid dec=
rementing from exact multiples of 63.

> The result still would not be a multiple of 63.=A0 Didn't you say tha=
t you=20
> preferred to take the device's word for it?

Only when we have unresolvable ambiguities.

>>> Bear in mind that if anybody reports a problem caused by the new
>>> "divisible by 63" criterion, we will have to revert the changed tes=
t
>>> (the updated message could remain, since it doesn't affect
>>> functionality).
>>=20
>> Mostly I agree.=A0 But if reversion causes a different known problem=
 to
>> be reinstated, then TEST_CAPACITY is really needed.
>=20
> The same caveat applies to TEST_CAPACITY.
>=20
> Also, the amount of effort required to write the TEST_CAPACITY code a=
nd=20
> get it accepted into the kernel would be non-trivial.=A0 I prefer not=
 to=20
> do it unless it turns out to be clearly necessary.

I think it is clearly necessary.  In the meantime a revised heuristic w=
ill help a lot.

By the way, I will not be the primary beneficiary of these revisions.  =
The primary beneficiaries will be owners of bridges and devices that yo=
u and I have learned to dislike, but we have to live with them.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
