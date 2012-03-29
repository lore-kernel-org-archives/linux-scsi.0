From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was:
 ehci_hcd fails to read a single good block)
Date: Thu, 29 Mar 2012 10:44:02 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1203291029190.1417-100000@iolanthe.rowland.org>
References: <886259.81235.qm@web100012.mail.kks.yahoo.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:34103 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933409Ab2C2OoD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Mar 2012 10:44:03 -0400
In-Reply-To: <886259.81235.qm@web100012.mail.kks.yahoo.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Norman Diamond <n0diamond@yahoo.co.jp>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, 29 Mar 2012, Norman Diamond wrote:

> Alan Stern wrote:
> > On Wed, 28 Mar 2012, Norman Diamond wrote:
> >=20
> >> I don't want to manhandle that old notebook's fragile vendor propr=
ietary IDE cable again, but I'll try to find another way to test that d=
rive again without going though USB.
> >=20
> > You don't have to worry about that.=A0 sg_dd works fine over USB.
> >=20
> >>> The USB-to-IDE bridge is vendor 067b, product 2507, Prolific Tech=
nology Inc., and usb-storage matches it for quirk 110.
> >=20
> > What is the bcdDevice value?
>=20
> Is that different from 2507?

It is a separate value from the product ID.  It appears in the output=20
from "lsusb -v" or in /sys/kernel/debug/usb/devices (where it is=20
labelled "Rev=3D").

> Now, if a combination of zeroing the readahead and proper user input =
of an sg_dd command will succeed in reading a single valid block next d=
oor to the bad block, then it won't even be necessary to unplug and rep=
lug the USB bridge.  That will be good news.
>=20
> >>> Digression:  Someone adjusts the number of blocks from the report=
ed 39070080 (which I think is correct) to 39070079 (which I think is wr=
ong).  I'll have to install the drive in an old notebook to check if th=
e reported number of blocks is really correct.
> >>=20
> >> Further on this digression:=A0 The number of blocks really is 3907=
0080.=A0 Today libata made no adjustment and the number of blocks was c=
orrect.=A0 So some USB component makes a misadjustment to screw up the =
number of blocks.
> >=20
> > usb-storage does this, because in the past Prolific's bridges have =
reported the wrong number of blocks.=A0 In fact, I'm surprised that it =
seems to work correctly with your drive.
>=20
> It is hard to imagine a USB bridge adding 1 to the number of blocks. =
 Did that really happen?

No.  What happened was that the bridge reported the number of blocks,
but SCSI's READ CAPACITY command requires the device to report the
highest available block number (which is one smaller since blocks are
numbered starting from 0).

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
