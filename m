From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2] st: Take additional queue ref in st_probe
Date: Tue, 05 Mar 2013 17:34:22 +0000
Message-ID: <1362504862.22821.67.camel@dabdike.int.hansenpartnership.com>
References: <alpine.DEB.2.02.1303041101450.1736@jlaw-desktop.mno.stratus.com>
	 <5135E780.6040303@redhat.com>
	 <alpine.DEB.2.02.1303051053040.1736@jlaw-desktop.mno.stratus.com>
	 <alpine.LNX.2.00.1303051913130.4183@kai.makisara.private>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57479 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757416Ab3CERe0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Mar 2013 12:34:26 -0500
In-Reply-To: <alpine.LNX.2.00.1303051913130.4183@kai.makisara.private>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Joe Lawrence <Joe.Lawrence@stratus.com>, linux-scsi@vger.kernel.org, Jan Vesely <jvesely@redhat.com>, "Seymour, Shane M" <shane.seymour@hp.com>, "Ewan D. Milne" <emilne@redhat.com>

On Tue, 2013-03-05 at 19:17 +0200, Kai Makisara wrote:
> On Tue, 5 Mar 2013, Joe Lawrence wrote:
>=20
> > Changes from v1:
> >   Corrected error paths as noted by Ewan Milne and Jan Vesely.
> >=20
> > These changes were applied to scsi.git, branch "misc".  This patch
> > fixes a reference count bug in the SCSI tape driver which can be
> > reproduced with the following:
> >=20
> > * Boot with slub_debug=3DFZPU, tape drive attached
> > * echo 1 > /sys/devices/... tape device pci path .../remove
> > * Wait for device removal
> > * echo 1 > /sys/kernel/slab/blkdev_queue/validate
> > * Slub debug complains about corrupted poison pattern
> >=20
> > In commit 523e1d39 (block: make gendisk hold a reference to its que=
ue)=20
> > add_disk() and disk_release() were modified to get/put an additiona=
l
> > reference on a disk queue to fix a reference counting discrepency
> > between bdev release and SCSI device removal.  The ST driver never
> > calls add_disk(), so this commit introduced an extra kref put when =
the
> > ST driver frees its struct gendisk.
> >=20
> > Attempts were made to fix this bug at the block level [1] but later
> > abandoned due to floppy driver issues [2].
> >=20
> > [1] https://lkml.org/lkml/2012/8/27/354
> > [2] https://lkml.org/lkml/2012/9/22/113
> >=20
> > From a50a6ee28748b7c1620af6f76772164ec0fc4a1d Mon Sep 17 00:00:00 2=
001
> > From: Joe Lawrence <joe.lawrence@stratus.com>
> > Date: Tue, 5 Mar 2013 09:30:14 -0500
> > Subject: [PATCH v2] st: Take additional queue ref in st_probe
> > MIME-Version: 1.0
> > Content-Type: text/plain; charset=3DUTF-8
> > Content-Transfer-Encoding: 8bit
> >=20
> > The SCSI tape driver employs a struct gendisk, calling alloc_disk()=
 to
> > create an instance, but does not register it via add_disk().  When =
the
> > gendisk is torn down, disk_release() is called and expects to retur=
n a
> > disk queue reference that add_disk() normally would have taken out.=
 (See
> > commit 523e1d39.)  Fix the kref accounting by adding a blk_get_queu=
e()
> > to st_probe().
> >=20
> > Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
> > Tested-by: Ewan D. Milne <emilne@redhat.com>=20
>=20
> I don't have to like this fix but as it fixes a real problem:
>=20
> Acked-by: Kai M=E4kisara <Kai.Makisara@kolumbus.fi>
>=20
> (It should not be necessary to get additional references outside the =
block=20
> layer to make the block layer behave.)

Agree with that.  However, from a practical point of view, alloc_disk()
has no idea what disk queue it's allocating the minors for, so on the
information we provide to block, there's no disconnect.

On the other hand, the other consequence of this situation is that
there's no current sysfs way of getting at the queue parameters because
the gendisk isn't added.  We actually need some type of

add_disk_not_really_a_disk()

Call which would tell block about the queue associated with the disk an=
d
ask to to add the relevant non-disk sysfs parameters.

James



--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
