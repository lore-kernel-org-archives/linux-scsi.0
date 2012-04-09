From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was:
 ehci_hcd fails to read a single good block)
Date: Mon, 9 Apr 2012 10:40:16 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1204091030260.1429-100000@iolanthe.rowland.org>
References: <582586.38117.qm@web100016.mail.kks.yahoo.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:40204 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756461Ab2DIOkR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Apr 2012 10:40:17 -0400
In-Reply-To: <582586.38117.qm@web100016.mail.kks.yahoo.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Norman Diamond <n0diamond@yahoo.co.jp>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 9 Apr 2012, Norman Diamond wrote:

> > You're not thinking about it the right way.=A0 If the quirk handlin=
g were any less agressive, it would fail to work entirely on some devic=
es (those that crash when trying to access a nonexistent block).
>=20
> I see your point, regarding devices which differ from mine, and which=
 possibly differ from the other user in 2004 since we don't really know=
 the reason for his crash (he might have had a bad block at or near the=
 end of his drive).
>=20
> > Such devices would not usable at all.
>=20
> We are already in that situation because of the decrement.

No.  That statement is simply wrong.  Such devices are quite usable.

>  If the drive was partitioned while the drive was internally installe=
d on an ATA cable, then the decrement now interferes with the usability=
 of the drive regardless of whether the USB bridge really does or doesn=
't have a bug.

What are you talking about?  If the bridge does have the capacity bug=20
then the decrement allows the bridge to be used correctly.

>  Also, if the drive was partitioned when using a known non-buggy brid=
ge, then the same situation happens when using a bridge whose status is=
 ambiguous because the driver does a decrement.

It is true that the current situation sometimes denies access to a
block which might work perfectly well.  But we don't have any better
solutions.  And don't forget, in any individual case it is always
possible to disable the quirk by means of a module parameter.

> > Besides, suppose this quirk entry were removed.=A0 What would happe=
n with the other bridges with the same ID numbers that do not decrement=
 the block count properly?=A0 Linux would try to access the nonexistent=
 last block, and the access would fail.=A0 Perhaps no unplug and replug=
 would be needed, but any data destined for that block would be lost.
>=20
> The present situation loses reads and writes of the last block when
> the last block DOES exist.

No, it doesn't; it prevents those reads and writes from being
attempted in the first place.  You probably don't care about this
distinction, however.

If you're trying to make a point in this discussion, I can't tell what
it is.  I already know that decrementing the capacity is not always the
right thing to do.  But I don't know of any better alternative.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
