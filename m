From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was:
 ehci_hcd fails to read a single good block)
Date: Thu, 12 Apr 2012 10:53:52 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1204121030050.1496-100000@iolanthe.rowland.org>
References: <870556.54475.qm@web100005.mail.kks.yahoo.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:42527 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S964944Ab2DLOxx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Apr 2012 10:53:53 -0400
In-Reply-To: <870556.54475.qm@web100005.mail.kks.yahoo.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Norman Diamond <n0diamond@yahoo.co.jp>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 11 Apr 2012, Norman Diamond wrote:

> > It sounds like you are suggesting that we have a new quirk,
> > something like TEST_CAPACITY.=A0 When this quirk is present, we cou=
ld
> > attempt to read the last block when the drive (or media) is first
> > detected, thereby determining whether the reported capacity needs
> > to be adjusted.
>=20
> Yes, that is what I've been suggesting for a while.  But at this
> moment I might have a better suggestion, discussed below.  Or it
> might be better to combine the two ideas.
>=20
> > The existing FIX_CAPACITY and CAPACITY_HEURISTICS quirk entries
> > could be changed to TEST_CAPACITY as people report the results of
> > their testing.=A0 However this would be a very slow process.
>=20
> FIX_CAPACITY will still be necessary in cases where a bridge is known
> to have both problems, always overreporting and crashing when tested
> for overreporting.  I think these cases will be a small minority
> though.

Your naive faith in the high quality of the firmware in low-cost=20
consumer electronic devices is touching, but sadly misplaced.

Besides, your initial conclusion is wrong.  FIX_CAPACITY will apply
well in cases where a bridge is known to have the overreporting bug. =20
Even if the bridge doesn't crash when asked to read beyond the end of
the drive, there's no reason to do such a test if we know in advance
what the answer will be.

The only real reason for the new TEST_CAPACITY flag would be to handle
cases where some devices get the capacity wrong and others with the
same IDs get it right.  This means that initially only two quirk
entries would require the TEST_CAPACITY flag: the one for your device
and the single entry that currently uses CAPACITY_HEURISTICS.

> Now, I think that most of the existing FIX_CAPACITY cases probably
> should be changed to CAPACITY_HEURISTICS.  This will be simpler and
> quicker, though not maximally accurate by itself.

Definitely NOT!  One of the most important rules we have in kernel
development is that we do not break existing systems.  It is known that
there are devices which overreport and for which the actual number of
blocks is odd; we cannot take the chance of changing any existing
entries without positive evidence that it is safe to do so.

> In drivers/scsi/sd.c, fix_capacity always causes a decrement but
> guess_capacity guesses an even number.
>=20
> So one thing to do for the Prolific bridge in unusual_devs.h is to
> use US_FL_CAPACITY_HEURISTICS instead of US_FL_FIX_CAPACITY.

Not all disks have an even number of blocks.  That heuristic really
isn't a very good one -- its only benefit is that it works okay for the
one case where it is currently used.

> I also think that if the reported capacity is a multiple of 63 then
> it is very likely to be accurate and should not be decremented. =20
> Furthermore if the capacity is a multiple of 126 (i.e. even as in the
> current heuristic, and a multiple of 63) then US_FL_FIX_CAPACITY is
> almost certainly wrong.  Of course that 63 is artificial but it is
> very common and the reason is well known.

You seem to be ignoring the fact that we aren't just talking about=20
USB-(S)ATA bridges.  The same driver also handles things like flash=20
drives and card readers.

=46or example, I just plugged in my music player.  It has both an
internal flash memory and a memory card slot, and it reports their
capacities correctly.  But the flash memory has 7683072 blocks and the
memory card has 3842048 blocks; neither of these numbers is divisible
by 63.  Therefore relying on it isn't particularly safe.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
