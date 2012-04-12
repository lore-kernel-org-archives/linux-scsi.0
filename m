From: Norman Diamond <n0diamond-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was: ehci_hcd fails to read a single good block)
Date: Fri, 13 Apr 2012 08:08:50 +0900 (JST)
Message-ID: <14684.87111.qm@web100019.mail.kks.yahoo.co.jp>
References: <Pine.LNX.4.44L0.1204121030050.1496-100000@iolanthe.rowland.org>
Reply-To: n0diamond-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1204121030050.1496-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Alan Stern wrote:
> On Wed, 11 Apr 2012, Norman Diamond wrote:
[Alan Stern:]
>>> It sounds like you are suggesting that we have a new quirk, somethi=
ng like TEST_CAPACITY.  When this quirk is present, we could attempt to=
 read the last block when the drive (or media) is first detected, there=
by determining whether the reported capacity needs to be adjusted.
>>=20
>> Yes, that is what I've been suggesting for a while.=A0 But at this m=
oment I might have a better suggestion, discussed below.=A0 Or it might=
 be better to combine the two ideas.
>>=20
>>> The existing FIX_CAPACITY and CAPACITY_HEURISTICS quirk entries cou=
ld be changed to TEST_CAPACITY as people report the results of their te=
sting.  However this would be a very slow process.
>>=20
>> FIX_CAPACITY will still be necessary in cases where a bridge is know=
n to have both problems, always overreporting and crashing when tested =
for overreporting.=A0 I think these cases will be a small minority thou=
gh.
>=20
> Your naive faith in the high quality of the firmware in low-cost cons=
umer electronic devices is touching, but sadly misplaced.

Well, I thought this particular combination of two bugs would be caught=
 very quickly because such devices would even be unusable in Windows, b=
ut now I guess you might be right.

> Besides, your initial conclusion is wrong.=A0 FIX_CAPACITY will apply=
 well in cases where a bridge is known to have the overreporting bug.=A0=
 Even if the bridge doesn't crash when asked to read beyond the end of =
the drive, there's no reason to do such a test if we know in advance wh=
at the answer will be.

Now you're the one being naive  ^_^
You THOUGHT you knew in advance that a particular bridge is known to ha=
ve the overreporting but, where in fact in some secret revisions it doe=
sn't and in some secret revisions we're not quite sure, missing a log a=
nd missing a test sample for further testing.  How can we be sure that =
other bridge manufacturers don't also make secret revisions?

(Even the firmware revision number that you get from a hard drive doesn=
't tell you which firmware revision it really was, unless you know the =
vendor's proprietary protocol to get it.  "Specifications subject to ch=
ange without notice" says "without notice" and means "without notice" a=
nd really means it.)

> The only real reason for the new TEST_CAPACITY flag would be to handl=
e cases where some devices get the capacity wrong and others with the s=
ame IDs get it right.=A0 This means that initially only two quirk entri=
es would require the TEST_CAPACITY flag: the one for your device and th=
e single entry that currently uses CAPACITY_HEURISTICS.

Well, you already told us why the one that currently uses CAPACITY_HEUR=
ISTICS might not be suitable for converting to TEST_CAPACITY unless mor=
e testing is done to show that it won't crash  ^_^

>> Now, I think that most of the existing FIX_CAPACITY cases probably s=
hould be changed to CAPACITY_HEURISTICS.=A0 This will be simpler and qu=
icker, though not maximally accurate by itself.
>=20
> Definitely NOT!=A0 One of the most important rules we have in kernel =
development is that we do not break existing systems.=A0 It is known th=
at there are devices which overreport and for which the actual number o=
f blocks is odd; we cannot take the chance of changing any existing ent=
ries without positive evidence that it is safe to do so.

OK.  Then we still need something more than the new TEST_CAPACITY flag =
trying to read the last reported block to see if the block exists or no=
t.  In cases marked as FIX_CAPACITY we ought to see if an existing part=
ition ends in the last reported block -- if it doesn't then we can trun=
cate the drive and no partition gets truncated, but if it does then may=
be we should consider changing the device's flag to TEST_CAPACITY.

> > In drivers/scsi/sd.c, fix_capacity always causes a decrement but gu=
ess_capacity guesses an even number.
>>=20
>> So one thing to do for the Prolific bridge in unusual_devs.h is to u=
se US_FL_CAPACITY_HEURISTICS instead of US_FL_FIX_CAPACITY.
>=20
> Not all disks have an even number of blocks.=A0 That heuristic really=
 isn't a very good one -- its only benefit is that it works okay for th=
e one case where it is currently used.

If you do mean disks, then we can improve that heuristic.  Forget about=
 the 126 that I mentioned last time, but go with the 63 because we know=
 why that factor is very common in drives that had physical 512 byte se=
ctors.  For drives being made these days with physical 4096 byte sector=
s, obviously the number of logical 512 byte sectors is going to be even=
 just as it is with the one device that presently has the HEURISTICS fl=
ag.

If you mean other USB devices that emulate disks, then of course there'=
s a wider range of possibilities.  The ATA identification might assert =
any number of emulated sectors per emulated track, etc.  And even when =
the device states its correct number of LBA blocks (not having been alt=
ered by fraudsters to sell a fake high capacity device in eBay), the ve=
ndor might have preformatted it with a partition extending past the end=
 of the device.  So yeah, I have no suggestion for devices other than a=
ctual disks being connected through USB to [S]ATA bridges.

>> I also think that if the reported capacity is a multiple of 63 then =
it is very likely to be accurate and should not be decremented.=A0 Furt=
hermore if the capacity is a multiple of 126 (i.e. even as in the curre=
nt heuristic, and a multiple of 63) then US_FL_FIX_CAPACITY is almost c=
ertainly wrong.=A0 Of course that 63 is artificial but it is very commo=
n and the reason is well known.
>=20
> You seem to be ignoring the fact that we aren't just talking about US=
B-(S)ATA bridges.

I was but you weren't.  For other kinds of devices I have no suggestion=
s, as mentioned above.
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
