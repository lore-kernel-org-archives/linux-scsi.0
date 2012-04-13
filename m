From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was:
 ehci_hcd fails to read a single good block)
Date: Thu, 12 Apr 2012 20:59:34 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1204122044390.10558-100000@netrider.rowland.org>
References: <14684.87111.qm@web100019.mail.kks.yahoo.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <14684.87111.qm-W9a5FxB6bg+O4BqzrDeqF0yFvBl6snHEEwWAM/ix52Y@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Norman Diamond <n0diamond-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 13 Apr 2012, Norman Diamond wrote:

> Now you're the one being naive  ^_^
> You THOUGHT you knew in advance that a particular bridge is known to
> have the overreporting but, where in fact in some secret revisions it
> doesn't and in some secret revisions we're not quite sure, missing a
> log and missing a test sample for further testing.  How can we be
> sure that other bridge manufacturers don't also make secret
> revisions?

In fact we don't know.  But that's not a good enough reason to risk=20
breaking existing systems.  When we encounter bridges whose behavior=20
has changed, we can update the quirk entries.

(Even that isn't as cautious as I'd like.  If the device behavior has=20
changed then maybe the old devices won't handle reading beyond the end=20
of the drive.  But I can't think of anything safer.)

> OK.  Then we still need something more than the new TEST_CAPACITY
> flag trying to read the last reported block to see if the block
> exists or not.  In cases marked as FIX_CAPACITY we ought to see if an
> existing partition ends in the last reported block -- if it doesn't
> then we can truncate the drive and no partition gets truncated, but
> if it does then maybe we should consider changing the device's flag
> to TEST_CAPACITY.

This is getting too complicated.  Not all storage devices have
partition tables.  Not all partition tables use the conventional DOS
format.  And by the time the partition-table parsing code runs, it may
be too late to change the recorded capacity -- I'm not sure about that.

> > Not all disks have an even number of blocks.=A0 That heuristic real=
ly
> > isn't a very good one -- its only benefit is that it works okay for
> > the one case where it is currently used.
>=20
> If you do mean disks, then we can improve that heuristic.  Forget
> about the 126 that I mentioned last time, but go with the 63 because
> we know why that factor is very common in drives that had physical
> 512 byte sectors.  For drives being made these days with physical
> 4096 byte sectors, obviously the number of logical 512 byte sectors
> is going to be even just as it is with the one device that presently
> has the HEURISTICS flag.

Don't modern disks have some arbitrary numbers of blocks reserved by
the manufacturer?  I forget the acronym for this, but it seems
reasonable that it could cause the capacity not to be a multiple of 63.

> If you mean other USB devices that emulate disks, then of course
> there's a wider range of possibilities.  The ATA identification might
> assert any number of emulated sectors per emulated track, etc.  And
> even when the device states its correct number of LBA blocks (not
> having been altered by fraudsters to sell a fake high capacity device
> in eBay), the vendor might have preformatted it with a partition
> extending past the end of the device.  So yeah, I have no suggestion
> for devices other than actual disks being connected through USB to
> [S]ATA bridges.

The problem is that we don't always know which devices are USB-(S)ATA
bridges and which aren't.  The quirk entries may not record that
information.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
