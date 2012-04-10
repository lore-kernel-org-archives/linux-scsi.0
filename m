From: Norman Diamond <n0diamond@yahoo.co.jp>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was: ehci_hcd fails to read a single good block)
Date: Wed, 11 Apr 2012 08:24:08 +0900 (JST)
Message-ID: <870556.54475.qm@web100005.mail.kks.yahoo.co.jp>
References: <Pine.LNX.4.44L0.1204101024420.1605-100000@iolanthe.rowland.org>
Reply-To: n0diamond@yahoo.co.jp
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web100005.mail.kks.yahoo.co.jp ([114.111.98.179]:25345 "HELO
	web100005.mail.kks.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755735Ab2DJXYL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Apr 2012 19:24:11 -0400
In-Reply-To: <Pine.LNX.4.44L0.1204101024420.1605-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

Alan Stern wrote:
> On Tue, 10 Apr 2012, Norman Diamond wrote:
> > Alan Stern wrote:
>>> On Mon, 9 Apr 2012, Norman Diamond wrote:
>>>> I suggest that quirk processing should only try to read 1 block, t=
he last block which is asserted to exist, and decrement if the read fai=
ls due to non-existence.  If the read fails for a different reason then=
 the block exists and the count should not be decremented.
>>>=20
>>> I have tried to explain before that this is a very bad idea.  Bridg=
es that crash when attempting to read beyond the end of the device woul=
d become totally unusable.
>>=20
>> In cases where a bridge has been observed to crash when trying to re=
ad a SINGLE block which the bridge asserted to exist but which didn't a=
ctually exist, I agree that an aggressive quirk is needed.
>>=20
>> In cases where a bridge has been observed to crash when trying to re=
ad MULTIPLE blocks among which one block had a problem, there is no evi=
dence yet to judge that my idea is very bad.=A0 Those bridges need to b=
e tested again with single block reads, and need to be tested on readin=
g the last block number which the bridge asserts to exist rather than a=
ttempting to read an existing bad block (by coincidence the two might b=
e the same block, but not usually).
>=20
> It sounds like you are suggesting that we have a new quirk, something=
 like TEST_CAPACITY.=A0 When this quirk is present, we could attempt to=
 read the last block when the drive (or media) is first detected, there=
by determining whether the reported capacity needs to be adjusted.

Yes, that is what I've been suggesting for a while.  But at this moment=
 I might have a better suggestion, discussed below.  Or it might be bet=
ter to combine the two ideas.

> The existing FIX_CAPACITY and CAPACITY_HEURISTICS quirk entries could=
 be changed to TEST_CAPACITY as people report the results of their test=
ing.=A0 However this would be a very slow process.

=46IX_CAPACITY will still be necessary in cases where a bridge is known=
 to have both problems, always overreporting and crashing when tested f=
or overreporting.  I think these cases will be a small minority though.

Now, I think that most of the existing FIX_CAPACITY cases probably shou=
ld be changed to CAPACITY_HEURISTICS.  This will be simpler and quicker=
, though not maximally accurate by itself.

In drivers/scsi/sd.c, fix_capacity always causes a decrement but guess_=
capacity guesses an even number.

So one thing to do for the Prolific bridge in unusual_devs.h is to use =
US_FL_CAPACITY_HEURISTICS instead of US_FL_FIX_CAPACITY.

I also think that if the reported capacity is a multiple of 63 then it =
is very likely to be accurate and should not be decremented.  Furthermo=
re if the capacity is a multiple of 126 (i.e. even as in the current he=
uristic, and a multiple of 63) then US_FL_FIX_CAPACITY is almost certai=
nly wrong.  Of course that 63 is artificial but it is very common and t=
he reason is well known.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
