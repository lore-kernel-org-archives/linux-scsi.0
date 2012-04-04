From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was:
 ehci_hcd fails to read a single good block)
Date: Wed, 4 Apr 2012 11:48:31 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1204041128160.1543-100000@iolanthe.rowland.org>
References: <388819.38189.qm@web100008.mail.kks.yahoo.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <388819.38189.qm-303aDswoEIaf2IT/n6niikyFvBl6snHEEwWAM/ix52Y@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Norman Diamond <n0diamond-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 4 Apr 2012, Norman Diamond wrote:

> Alan Stern wrote:
> > On Tue, 3 Apr 2012, Norman Diamond wrote:
> >>>> Wrong.  We CAN try to read the last block that the bridge says e=
xists, to see if it really exists or not.  (Well, only partly wrong.  M=
aybe there really are some bridges that crash in that situation, but mi=
ne doesn't, and a broken driver still needs fixing.)
> >>>=20
> >>> Yes, there really are such bridges.  You can find reports from pe=
ople complaining about them in the email archives.
> >>=20
> >> Wait.=A0 Is there a bridge which overreports the last sector numbe=
r by 1, and which ALSO crashes when the host PC tries to read that supp=
osed last sector number?
> >=20
> > Yes.=A0 Like I said before, you can find complaints about these thi=
ngs in the mailing list archives.=A0 However it's not clear whether the=
 crashing is the fault of the bridge itself or the drive it is attached=
 to.
>=20
> Or the driver.

No, it is not the fault of the driver.

> I think it is not the fault of the drive.  If a drive crashed when a =
driver tried to access a nonexistent sector, then the drive would crash=
 when mounted internally on an ATA or SATA cable not only when connecte=
d to a USB cable.
>=20
> It might be the fault of the bridge, BUT, does a single bridge really=
 suffer from BOTH faults as I asked?  You seem to be saying yes, but th=
en you cloud it up by saying it's unclear if it might be the drive inst=
ead of the bridge.  I still wonder if it's the driver instead of the br=
idge, but surely not the drive.

I wanted to hedge because all the computer sees is what it gets from=20
the bridge.  It has no way to tell whether a problem was caused by the=20
bridge or the drive.  If you want to exonerate the drive, that's fine=20
with me.  Certainly the bridge has enough other problems that we=20
shouldn't be surprised to find it was solely responsible.

And I repeat, the driver did everything exactly as it should have.

> >>=A0 If so then we need a quirk for that doubly broken bridge.
> >=20
> > That's what the existing quirk entries are there for.
>=20
> Surely that's not what the quirk is for on my bridge.

Yes, it is.  Or rather, it probably is -- to be absolutely certain I'd=20
have to look through the email archives to find the bug reports that=20
caused the quirk entry to be added.

However there's no question that other bridges having the same vendor,
product, and revision ID values as yours _did_ report the drive
capacity incorrectly; otherwise the quirk entry would not be there. =20
What I'm not sure of is whether those bridges went on to crash as
dramatically as yours.

> >> But otherwise, we can try to read the supposedly last sector numbe=
r and figure out whether we have to subtract 1.
> >=20
> > True enough, but we don't have any way to know which bridges do cra=
sh and which don't other than trying it.=A0 And you'll probably agree t=
hat trial and error is not such a good idea in the cases where the brid=
ge does crash.
>=20
> This still makes me wonder why Windows is able to handle the same bri=
dges.

Probably because Windows does not try to read the last block, unless it
is occupied by a file.  If it did, it probably would crash the bridges
too.

It would be interesting to know the details of what your Windows system
does when trying to read a file that occupies the faulty sector. =20
There are programs around that are roughly equivalent to usbmon for
Windows; you could try one of them.

> Now, as far as I can tell, I have found a WTF of a standard.  I only =
have drafts of old T10 documents but it sure looks like a WTF unless so=
mething was fixed later.
>=20
> In SCSI Block Commands, it seems to me that the READ CAPACITY (10) co=
mmand (opcode 0x25) returns the number of blocks.

I'm not sure how you reached that conclusion.  In my rather old copy of
the SCSI-2 standard, section 9.2.7 (the READ CAPACITY command in the
chapter on Direct-access devices) says:

	A partial medium indicator (PMI) bit of zero indicates that the=20
	returned logical block address and the block length in bytes
	are those of the last logical block on the logical unit.

And of course, the PMI bit _is_ zero for the commands we are talking
about.

> In Reduced Block Commands, it says explicitly that the READ CAPACITY =
command (opcode 0x25) returns the LBA of the last logical block of the =
media contained in the device.  So a USB-to-ATA bridge is required to s=
ubtract 1 from the number of blocks reported by ATA IDENTIFY, and a USB=
-to-SCSI bridge has to subtract 1 from the result of READ CAPACITY (10)=
=2E  (Our present discussion involves the fact that a defective bridge =
might not subtract that 1, whereupon the next step gets spindled and mu=
tilated.)
>=20
> If a driver wants the last block number then it has to subtract 1 in =
the case of SCSI, and it wants the number of blocks then it has to add =
1 in the case of USB.  Did I really read this right?

No.  The READ CAPACITY command should always return the last block
number for any form of SCSI, including SCSI over USB, and to get the
number of blocks that value should be incremented.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
