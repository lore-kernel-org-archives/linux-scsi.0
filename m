From: Norman Diamond <n0diamond-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was: ehci_hcd fails to read a single good block)
Date: Mon, 16 Apr 2012 11:13:02 +0900 (JST)
Message-ID: <344714.25777.qm@web100012.mail.kks.yahoo.co.jp>
References: <Pine.LNX.4.44L0.1204122044390.10558-100000@netrider.rowland.org>
Reply-To: n0diamond-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1204122044390.10558-100000-pYrvlCTfrz9XsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Alan Stern wrote:
> On Fri, 13 Apr 2012, Norman Diamond wrote:
>> You THOUGHT you knew in advance that a particular bridge is known to=
 have the overreporting but, where in fact in some secret revisions it =
doesn't and in some secret revisions we're not quite sure, missing a lo=
g and missing a test sample for further testing.=A0 How can we be sure =
that other bridge manufacturers don't also make secret revisions?
>=20
> In fact we don't know.=A0 But that's not a good enough reason to risk=
 breaking existing systems.=A0 When we encounter bridges whose behavior=
 has changed, we can update the quirk entries.

That's not a good enough reason to cause known breakage in newer existi=
ng systems, but I agree that updating the quirk entries helps solve it.

> (Even that isn't as cautious as I'd like.=A0 If the device behavior h=
as changed then maybe the old devices won't handle reading beyond the e=
nd of the drive.=A0 But I can't think of anything safer.)

Well, if the reported capacity isn't a multiple of 63 and if no existin=
g partition includes the last reported block then it seems comparativel=
y safe to decrement the reported size, but as you pointed out, we can't=
 really be sure what the existing partitions are (non-DOS tables etc.).=
  But a multiple of 63 still seems like a relatively safe heuristic, co=
mparatively speaking.  But not always, as you pointed out, and as I'll =
detail below.

>>> Not all disks have an even number of blocks.  That heuristic really=
 isn't a very good one -- its only benefit is that it works okay for th=
e one case where it is currently used.
>>=20
>> If you do mean disks, then we can improve that heuristic.=A0 Forget =
about the 126 that I mentioned last time, but go with the 63 because we=
 know why that factor is very common in drives that had physical 512 by=
te sectors.=A0 For drives being made these days with physical 4096 byte=
 sectors, obviously the number of logical 512 byte sectors is going to =
be even just as it is with the one device that presently has the HEURIS=
TICS flag.
>=20
> Don't modern disks have some arbitrary numbers of blocks reserved by =
the manufacturer?

Of course, for relocations of bad blocks and for some other purposes to=
o.  They don't have LBAs.  They aren't included in the reported capacit=
y.  They aren't relevant to this discussion.

(I assume that my drive with bad blocks has already used all of its blo=
cks that had been reserved for relocations.)

> I forget the acronym for this, but it seems reasonable that it could =
cause the capacity not to be a multiple of 63.

No need to worry about that  ^_^

I have a drive made in 1992, with no currently observed bad blocks, wit=
h the following identifications:
C*H*S =3D 1579*16*63 =3D 1591632
LBA capacity =3D 1592568
(Today I only have to manhandle a fragile SATA-to-PATA adapter, plus eS=
ATA-to-SATA cable and SATA power supply, to get genuine ATA identificat=
ions.)

So yes indeed the capacity might not be a multiple of 63.  63 is very c=
ommon for obvious reasons, but not universal.  Also of course 63 isn't =
likely on current drives with 4096 byte physical sectors, which emulate=
 a capacity in 512 byte sectors that will obviously be a multiple of 8.=
  But in all of these cases the current heuristic for even numbers stil=
l succeeds.  So respecting a report of a multiple of 63, and if it isn'=
t a multiple of 63 then falling back to respecting a report of a multip=
le of 2, seems like a good bet for doing a test read of the last report=
ed sector.

>> If you mean other USB devices that emulate disks, then of course the=
re's a wider range of possibilities. [...]  So yeah, I have no suggesti=
on for devices other than actual disks being connected through USB to [=
S]ATA bridges.
>=20
> The problem is that we don't always know which devices are USB-(S)ATA=
 bridges and which aren't.=A0 The quirk entries may not record that inf=
ormation.

usb.ids records a bunch of them.  Though of course that's not an "alway=
s".
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
