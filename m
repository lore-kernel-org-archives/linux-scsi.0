From: Norman Diamond <n0diamond-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was: ehci_hcd fails to read a single good block)
Date: Fri, 27 Apr 2012 08:13:10 +0900 (JST)
Message-ID: <918221.71348.qm@web100013.mail.kks.yahoo.co.jp>
References: <Pine.LNX.4.44L0.1204261026260.1530-100000@iolanthe.rowland.org>
Reply-To: n0diamond-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1204261026260.1530-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Alan Stern wrote:
> On Thu, 26 Apr 2012, Norman Diamond wrote:
>=20
>> OK, the new code for heuristics makes it PROBABLY good enough to
>> change the Prolific bridge from FIX_CAPACITY to CAPACITY_HEURISTICS.
>>=20
>>> Below are two patches that do pretty much what you are asking for.=A0=
=20
>>> Please test just the first and then both together.
>>=20
>> Ouch.=A0 Yeah I should expect it to be my responsibility to test, bu=
t
>> rebuilding the live Linux system that I use is particularly painful.=
=A0=20
>> (Of course I have to be grateful that it is even possible in the
>> first place, regardless of being painful.)
>>=20
>> Would it be acceptable for me to donate my USB-to-ATA cable to you?
>=20
> Let's just not worry about it.=A0 It seems pretty clear that the patc=
hes=20
> will fix your immediate problem.

Only partly, because an odd multiple of 63 is possible.

>>> +=A0 =A0 =A0 =A0 (sdp->guess_capacity && (n % 2 =3D=3D 1 || n % 63 =
=3D=3D 1))) {
>>=20
>> Imagine a device with 63 blocks.=A0 guess_capacity is true and n % 2=
 =3D=3D
>> 1 so this is going to truncate when we don't want to.
>=20
> Yes.=A0 As the comment at the start of this code says, we err on the =
side=20
> of truncating.=A0 Besides, that's what the current algorithm does.
>=20
>> How is one of these, either in my style:
>> (sdp->guess_capacity && (n % 2 !=3D 0) && (n % 63 !=3D 0))) {
>>=20
>> or a popular coding style:
>> (sdp->guess_capacity && n % 2 n % 63)) {
>=20
> (I have no idea what "popular coding style" that might be -- it
> contains a syntax error!)

I lost an && in editing.  But it seems to be popular to omit redundant =
parentheses and to omit extra operations such as "!=3D 0" when, as in t=
his case, they don't affect the result.  Both of these kinds of redunda=
ncies only assist readability for a subset of human readers, not for co=
mpilers.

(sdp->guess_capacity && n % 2 && n % 63)) {

Anyway, the version with my coding style showed what I suggest and why.

> What about a device that has 6362 sectors but reports 6363?=A0 Then y=
our=20
> test would fail to decrement the value when we do want to.

But we can't distinguish two versions of the device, one where 6363 is =
correct and one where 6363 is wrong.  I prefer to take the device's wor=
d for it unless we know for sure that it is wrong.  TEST_CAPACITY would=
 still be a good idea.  FIX_CAPACITY (where we know for sure that the d=
evice is wrong) will not suffer from this ambiguity and will always get=
 a decrement.

> Anyway, why do you want to test for n % 63 !=3D 0?=A0 You have no
> justification for decrementing the block count if the result would
> not be divisible by 63.

I sure do.  You know as well as I do that for decades a lot of ATA disk=
s reported capacities that were multiples of 63 and they had a reason f=
or it.

> (Interestingly, I just found an email thread that appears to be the=20
> origin of the CAPACITY_HEURISTICS flag:
> =A0=A0=A0 http://marc.info/?l=3Dlinux-usb-devel&m=3D117025868105192&w=
=3D2
> Among other things, it suggests testing for divisibility by 255 * 63=20
> instead of by 63, which ought to help reduce the number of errors.

A few weeks ago I also had the idea of testing divisibility by 255 * 63=
, but very quickly disproved this idea.  I still have a lot of drives t=
hat report multiples of 63 for the obvious reason, but they are not mul=
tiples of 255 * 63.  BIOSes, and software that has to provide some amou=
nt of interoperability with BIOSes, do geometry translation to get a mu=
ltiple of 255 * 63, and then they don't use the entire drive.

> Bear in mind that if anybody reports a problem caused by the new
> "divisible by 63" criterion, we will have to revert the changed test
> (the updated message could remain, since it doesn't affect
> functionality).

Mostly I agree.  But if reversion causes a different known problem to b=
e reinstated, then TEST_CAPACITY is really needed.
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
