From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] sd: tell the user when a disk's capacity is adjusted
Date: Mon, 15 Dec 2008 11:01:46 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0812151056340.2525-100000@iolanthe.rowland.org>
References: <200812151648.37650.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:36780 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752298AbYLOQBr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Dec 2008 11:01:47 -0500
In-Reply-To: <200812151648.37650.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 15 Dec 2008, Oliver Neukum wrote:

> Am Montag, 15. Dezember 2008 16:32:59 schrieb Alan Stern:
> > +=A0=A0=A0=A0=A0=A0=A0 =A0 =A0(sdp->guess_capacity && (sdkp->capaci=
ty & 0x01))) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0sd_printk(KERN_INFO, =
sdkp, "Adjusting the sector count "
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0"from its reported value: %llu\n",
>=20
> Maybe this is just me, but if the disk actually has an odd number of =
sectors
> this code will assume the disk is one sector too big.

The code will make that mistake only if sdp->guess_capacity is set. =20
Currently the only place the flag gets set is in code you added
yourself, an unusual_devs entry for the USB4500 FW1.04.

> Therefore we should
> still learn about buggy enclosures and add them to the list, so we sh=
ould
> make a difference between known buggy devices and cases the heuristic=
s
> works, particularly as it may mark a rare cases where a working devic=
e
> is truncated. So KERN_INFO seems a bit weak.

No, it should be KERN_INFO.  We don't want anything stronger, since=20
this message will appear every time somebody plugs in a USB storage=20
device known to have the READ CAPACITY bug.  The point of this message=20
isn't to learn about buggy or non-buggy devices; the point is to let=20
the user know that the kernel has adjusted the data reported by the=20
device.

I've got a different scheme for learning about devices where the=20
heuristic gives the wrong answer.  See the "last-sector-hack" patch=20
just posted to linux-usb.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
