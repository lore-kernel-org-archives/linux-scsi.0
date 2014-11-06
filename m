From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Large disk drives
Date: Thu, 06 Nov 2014 18:18:07 +0100
Message-ID: <1415294287.10617.14.camel@jarvis.quadriga.com>
References: <Pine.LNX.4.44L0.1411061049310.886-100000@iolanthe.rowland.org>
	 <545BA52F.6050205@gmail.com>
	 <063D6719AE5E284EB5DD2968C1650D6D1C9EA6C1@AcuExch.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47842 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750963AbaKFRSL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2014 12:18:11 -0500
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1C9EA6C1@AcuExch.aculab.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Laight <David.Laight@ACULAB.COM>
Cc: 'Boaz Harrosh' <openosd@gmail.com>, Alan Stern <stern@rowland.harvard.edu>, Boaz Harrosh <boaz@plexistor.com>, Christoph Hellwig <hch@infradead.org>, "Dale R. Worley" <worley@alum.mit.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>

On Thu, 2014-11-06 at 17:08 +0000, David Laight wrote:
> From: Boaz Harrosh
> > On 11/06/2014 05:53 PM, Alan Stern wrote:
> > >> But just the simple case of read-capacity failure should we then=
?
> > >
> > > That's a separate question.  As far as I know, the case you are
> > > describing has not come up.
> > >
> >=20
> > BTW: what we should do is when the partition parser at the block la=
yer
> > see that the partition capacity as written in the partition-table i=
s
> > bigger then the capacity reported for the device we can put a fat
> > message at dmesg with both sizes and user can decide.
>=20
> One possibility is to try to read the last sector of the actual
> partition. If it succeeds there are 2 possibilities:

These are USB devices (bridges) not well behaved SCSI devices.  The las=
t
time we tried to poke USB devices beyond their defined capacity (the US=
B
capacity off by one problem) the firmware on some crashed and we
eventually gave up.  That's why, unless we can find simple, functional
heuristics for the kernel, it's safer to punt to userspace.

James

> 1) The disk is as bit as the partition table indicates.
> 2) The high bit(s) of the sector number have been masked.
> (or the disk locks up)
>=20
> In many cases the latter can be verified by reading the other sector.
> But if the media is new/erased then all the sectors will be 0xff
> and you'd have to do a write to ensure there was no sector aliasing.
>=20
> 	David
>=20
> NrybX=C7=A7v^)=DE=BA{.n+{"{ay=1D=CA=87=DA=99,j=07fhz=1Ew=0Cj:+vwjm=07=
zZ+=DD=A2j"!


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
