From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was:
 ehci_hcd fails to read a single good block)
Date: Tue, 1 May 2012 12:05:53 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1205011025131.1499-100000@iolanthe.rowland.org>
References: <909120.88778.qm@web100007.mail.kks.yahoo.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:34252 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757458Ab2EAQFy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 May 2012 12:05:54 -0400
In-Reply-To: <909120.88778.qm@web100007.mail.kks.yahoo.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Norman Diamond <n0diamond@yahoo.co.jp>
Cc: USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 1 May 2012, Norman Diamond wrote:

> >> I wish I could get a broken Prolific bridge to test together with
> > > mine.=C2=A0 Anyway the divisible-by-63 heuristic would work bette=
r than
> > > the existing heuristic but it would not work as well as
> > > TEST_CAPACITY.=C2=A0 My proposed modified heursitic would usually=
 work
> > > better than the existing heuristic but not as well as TEST_CAPACI=
TY.
> >=20
> > How do you know?=C2=A0 You haven't read through ten years' worth of=
 email=20
> > messages on this subject, have you?=C2=A0 You're going on the basis=
 of your=20
> > experience with _one_ bridge and a couple of drives.
>=20
> Because we do know there are a lot of multiples of 63 out there, and
> because if the bridge reports a capacity that is a multiple of 63
> (i.e. maximum LBA one less than a multiple of 63) and we try reading
> that last block then it should be read successfully.  The only time
> we have to worry about TEST_CAPACITY is a pretty rare case -- and
> even in such rare cases, we don't know if the bridge will always hang
> in those cases.

We don't know, but our experience has not been good.  Even if the=20
bridge doesn't hang, it is quite possible the kernel will get stuck in=20
a very long, very slow retry loop.  Maybe not as bad as the loop you=20
experienced while testing a different scenario, but still bad.

> >> By the way, a while back you asked what happens if I use sg_dd to =
try
> >> reading multiple blocks including the last existing block and some
> >> non-existing ones.=C2=A0 The answer seems to depend on the drive a=
s well
> >> as the method of connection (USB-to-PATA vs. eSATA plus
> >> SATA-to-PATA).=C2=A0 With the drive that I've usually been using I=
 think
> >> the drive hangs so we can't really figure out whether to blame the
> >> bridge.=C2=A0 With a different drive the drive reports the error b=
ut sg_dd
> >> and Linux drivers do something to retry so many times that after 3=
0
> >> minutes I lost patience waiting for sg_dd to finish and report its
> >> error.
> >=20
> > Indeed -- that's exactly the sort of thing which could happen with
> > TEST_CAPACITY.=C2=A0 It's one of the reasons I'm cautious about add=
ing
> > TEST_CAPACITY and an example of why TEST_CAPACITY might not work as=
=20
> > well as you think.
>=20
> Correction:  Therefore TEST_CAPACITY should not try to read multiple
> blocks in one read.

To repeat: You have no way of knowing whether reading a single block=20
will avoid this problem when other bridges are used.

> Your other message says you have a different model of Prolific bridge
> which has the capacity bug but which is (sadly at this moment)
> distinguishable from mine.  Anyway, what happens if you try to read
> the last block that the bridge asserted to exist?

It behaves the same way yours does: immediate failure with no error=20
information.

>  Also for curiosity
> what happens if you try to read multiple nonexistent blocks, but that
> curiosity is irrelevant to the single block that TEST_CAPACITY would
> try to read.

I tried multiple experiments, reading 8 blocks starting at different=20
positions relative to the end.  In each case, if any of the blocks were=
=20
after the physical end of the drive, the bridge returned immediately=20
with no data and no error information.

I also have another bridge to test, a very buggy device made by
JMicron.  I don't remember whether it has the capacity bug, and I don't
have time to work on it today.  I'll let you know how it behaves later
on.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
