From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was:
 ehci_hcd fails to read a single good block)
Date: Fri, 27 Apr 2012 10:51:59 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1204271036480.1690-100000@iolanthe.rowland.org>
References: <918221.71348.qm@web100013.mail.kks.yahoo.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:34917 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759972Ab2D0OwA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Apr 2012 10:52:00 -0400
In-Reply-To: <918221.71348.qm@web100013.mail.kks.yahoo.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Norman Diamond <n0diamond@yahoo.co.jp>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 27 Apr 2012, Norman Diamond wrote:

> > Let's just not worry about it.=A0 It seems pretty clear that the pa=
tches=20
> > will fix your immediate problem.
>=20
> Only partly, because an odd multiple of 63 is possible.

Look, I didn't say the changes would help with every possible disk. =20
Just that they would fix your immediate problem, i.e., the problem with
your current disk.

> > What about a device that has 6362 sectors but reports 6363?=A0 Then=
 your=20
> > test would fail to decrement the value when we do want to.
>=20
> But we can't distinguish two versions of the device, one where 6363
> is correct and one where 6363 is wrong.  I prefer to take the
> device's word for it unless we know for sure that it is wrong. =20
> TEST_CAPACITY would still be a good idea.  FIX_CAPACITY (where we
> know for sure that the device is wrong) will not suffer from this
> ambiguity and will always get a decrement.

That's the whole point of CAPACITY_HEURISTICS -- we have two versions=20
of the device, of which one is buggy and the other isn't, and we can't=20
tell them apart.  If we preferred to take the device's word for it=20
whenever we didn't know for sure, there would be no need for=20
CAPACITY_HEURISTICS at all.

=46or example, consider all those cameras sold by Nikon, Pentax, and so
on.  They probably all used Symbian's firmware, which some years ago =20
had the capacity bug.  Maybe the firmware has been fixed since then; I
don't know.  But under the reasonable assumption that the
SD/CF/whatever memories used in these cameras will always have an even=20
number of blocks, the existing CAPACITY_HEURISTICS solution is=20
appropriate.

> > Anyway, why do you want to test for n % 63 !=3D 0?=A0 You have no
> > justification for decrementing the block count if the result would
> > not be divisible by 63.
>=20
> I sure do.  You know as well as I do that for decades a lot of ATA
> disks reported capacities that were multiples of 63 and they had a
> reason for it.

?  That makes no sense.  Go back and reread what I wrote.  In=20
particular, I was asking why you changed the test from (n % 63 =3D=3D 1=
) to=20
(n % 63 !=3D 0).

You know that for decades, ATA disks have reported capacities that were
multiples of 63.  So if a drive reports a capacity that is 5 larger
than a multiple of 63, why would you want to decrement the value?  The
result still would not be a multiple of 63.  Didn't you say that you=20
preferred to take the device's word for it?

> > Bear in mind that if anybody reports a problem caused by the new
> > "divisible by 63" criterion, we will have to revert the changed tes=
t
> > (the updated message could remain, since it doesn't affect
> > functionality).
>=20
> Mostly I agree.  But if reversion causes a different known problem to
> be reinstated, then TEST_CAPACITY is really needed.

The same caveat applies to TEST_CAPACITY.

Also, the amount of effort required to write the TEST_CAPACITY code and=
=20
get it accepted into the kernel would be non-trivial.  I prefer not to=20
do it unless it turns out to be clearly necessary.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
