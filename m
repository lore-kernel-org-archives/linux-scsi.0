From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was:
 ehci_hcd fails to read a single good block)
Date: Mon, 30 Apr 2012 15:42:42 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1204301523120.1558-100000@iolanthe.rowland.org>
References: <518968.75200.qm@web100005.mail.kks.yahoo.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:60438 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756578Ab2D3Tmn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Apr 2012 15:42:43 -0400
In-Reply-To: <518968.75200.qm@web100005.mail.kks.yahoo.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Norman Diamond <n0diamond@yahoo.co.jp>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 30 Apr 2012, Norman Diamond wrote:

> Here you are modifying my proposal.  It is no problem to discuss your
> idea.  At first I thought your idea was better than mine, but on
> second thought, sorry, here's a problem.  Again it is because the
> broken and unbroken Prolific bridges are indistinguishable.  A
> Prolific bridge could be connected to a drive whose actual usable
> capacity is a multiple of 63, or it could be connected to a modern
> drive with emulated capacity that is even (in fact a multiple of 8)
> and not usually a multiple of 63.
>=20
> Therefore I still favour my version.  If the bridge reports an even
> number then I want to believe it, if the bridge reports a multiple of
> 63 then I want to believe it, and if neither then I want to fall back
> on the existing heuristic which performs a decrement.

Hmmm.  What about when one of the broken bridges with an older drive
reports a number which is 1 larger than a multiple of 63 but also
happens to be even?  In that case your proposed heuristic would fail --
but then so would the existing heuristic, so we'd be no worse off than
we are now.

I still think your proposed heuristic should be handled separately from=
=20
the existing one, so that it would not be applied in situations where=20
we know the device is not a USB-(S)ATA bridge.

> > As for whether we need TEST_CAPACITY...=A0 That is still highly
> > debatable.=A0 If we did have it, which quirk entries would use it?=A0=
 So
> > far the only candidate we have is your Prolific bridge, and even th=
ere
> > it seems that the divisible-by-63 heuristic would work just as well=
=2E
>=20
> I wish I could get a broken Prolific bridge to test together with
> mine.  Anyway the divisible-by-63 heuristic would work better than
> the existing heuristic but it would not work as well as
> TEST_CAPACITY.  My proposed modified heursitic would usually work
> better than the existing heuristic but not as well as TEST_CAPACITY.

How do you know?  You haven't read through ten years' worth of email=20
messages on this subject, have you?  You're going on the basis of your=20
experience with _one_ bridge and a couple of drives.

By the way, have you tried connecting your bridge to a CD/DVD drive? =20
I believe that some bridges are supposed to work with both regular
disks and optical drives, but I don't know if any of them mess up the
capacity of an optical disc.  Quite possibly not.

> By the way, a while back you asked what happens if I use sg_dd to try
> reading multiple blocks including the last existing block and some
> non-existing ones.  The answer seems to depend on the drive as well
> as the method of connection (USB-to-PATA vs. eSATA plus
> SATA-to-PATA).  With the drive that I've usually been using I think
> the drive hangs so we can't really figure out whether to blame the
> bridge.  With a different drive the drive reports the error but sg_dd
> and Linux drivers do something to retry so many times that after 30
> minutes I lost patience waiting for sg_dd to finish and report its
> error.

Indeed -- that's exactly the sort of thing which could happen with
TEST_CAPACITY.  It's one of the reasons I'm cautious about adding
TEST_CAPACITY and an example of why TEST_CAPACITY might not work as=20
well as you think.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
