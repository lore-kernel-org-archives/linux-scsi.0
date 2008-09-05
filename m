From: Andrew Patterson <andrew.patterson@hp.com>
Subject: Re: [PATCH 0/6] detect online disk resize
Date: Fri, 05 Sep 2008 09:15:10 -0600
Message-ID: <1220627710.7790.17.camel@grinch>
References: <20080904202714.10456.88061.stgit@bob.kio>
	 <20080905082110.GN13941@edu.joroinen.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:33100 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbYIEPPO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Sep 2008 11:15:14 -0400
In-Reply-To: <20080905082110.GN13941@edu.joroinen.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pasi =?ISO-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, axboe@kernel.dk, andmike@linux.vnet.ibm.com, mike.miller@hp.com, genanr@emsphone.com, jmoyer@redhat.com

On Fri, 2008-09-05 at 11:21 +0300, Pasi K=C3=A4rkk=C3=A4inen wrote:
> > 1. For SCSI devices do:
> >=20
> >   # echo 1 > /sys/class/scsi_device/<device>/device/rescan
> >=20
> >   or
> >=20
> >   # blockdev --rereadpt <device file>
> >=20
> > 2. Other devices (not device mapper)
> >=20
> >   # blockdev --rereadpt <device file>
> >=20
> > I have tested this patch on SCSI and SmartArray (cciss)
> > devices. Device mapper still does not recognize device size changes
> > until the device is restarted.
> >=20
>=20
> Hello and thanks for the patch!=20
>=20
> How about device mapper.. what's needed to make it detect/support onl=
ine resizes?
> I'm specificly interested in online resizing (growing) dm-multipath d=
evices..=20
>=20

Yes, it would be nice if this patchset worked here too. It currently
does not.=20

> Basicly I'd like to have LVM PV on dm-multipath device.. so first I n=
eed to
> get the actual disks resized, then dm-multipath device, and finally r=
un pvresize.
>=20

I did some testing with multipath here.  I could get it working by
shutting down the devices, resizing all the underlying paths using the
above methods, restarting the devices, then running pvresize. This
method does not help much given that most users cannot realistically
shutdown a device. This patch series works fine with standard LVM/dm,
i.e., resize using one of the above methods, then run pvresize.

I was planning on looking into dm-multipath in the near future.  Mike
Anderson has done some work in this area in the past.

> I know dm-multipath part can be done atm using this (hacky) method:
> https://www.redhat.com/archives/dm-devel/2008-August/msg00033.html
>=20

This is indeed ugly.  It looks like they are pulling the paths out of
the device, resizing them, and then adding them back in.

> -- Pasi


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
