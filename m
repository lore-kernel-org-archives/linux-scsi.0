From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH v2] st: Take additional queue ref in st_probe
Date: Tue, 5 Mar 2013 19:17:47 +0200 (EET)
Message-ID: <alpine.LNX.2.00.1303051913130.4183@kai.makisara.private>
References: <alpine.DEB.2.02.1303041101450.1736@jlaw-desktop.mno.stratus.com> <5135E780.6040303@redhat.com> <alpine.DEB.2.02.1303051053040.1736@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811327-129177391-1362503881=:4183"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs18.mail.saunalahti.fi ([62.142.117.199]:45572 "EHLO
	vs18.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922Ab3CERSE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Mar 2013 12:18:04 -0500
In-Reply-To: <alpine.DEB.2.02.1303051053040.1736@jlaw-desktop.mno.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <Joe.Lawrence@stratus.com>
Cc: linux-scsi@vger.kernel.org, Jan Vesely <jvesely@redhat.com>, "Seymour, Shane M" <shane.seymour@hp.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "Ewan D. Milne" <emilne@redhat.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811327-129177391-1362503881=:4183
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 5 Mar 2013, Joe Lawrence wrote:

> Changes from v1:
>   Corrected error paths as noted by Ewan Milne and Jan Vesely.
>=20
> These changes were applied to scsi.git, branch "misc".  This patch
> fixes a reference count bug in the SCSI tape driver which can be
> reproduced with the following:
>=20
> * Boot with slub_debug=3DFZPU, tape drive attached
> * echo 1 > /sys/devices/... tape device pci path .../remove
> * Wait for device removal
> * echo 1 > /sys/kernel/slab/blkdev_queue/validate
> * Slub debug complains about corrupted poison pattern
>=20
> In commit 523e1d39 (block: make gendisk hold a reference to its queue)=20
> add_disk() and disk_release() were modified to get/put an additional
> reference on a disk queue to fix a reference counting discrepency
> between bdev release and SCSI device removal.  The ST driver never
> calls add_disk(), so this commit introduced an extra kref put when the
> ST driver frees its struct gendisk.
>=20
> Attempts were made to fix this bug at the block level [1] but later
> abandoned due to floppy driver issues [2].
>=20
> [1] https://lkml.org/lkml/2012/8/27/354
> [2] https://lkml.org/lkml/2012/9/22/113
>=20
> From a50a6ee28748b7c1620af6f76772164ec0fc4a1d Mon Sep 17 00:00:00 2001
> From: Joe Lawrence <joe.lawrence@stratus.com>
> Date: Tue, 5 Mar 2013 09:30:14 -0500
> Subject: [PATCH v2] st: Take additional queue ref in st_probe
> MIME-Version: 1.0
> Content-Type: text/plain; charset=3DUTF-8
> Content-Transfer-Encoding: 8bit
>=20
> The SCSI tape driver employs a struct gendisk, calling alloc_disk() to
> create an instance, but does not register it via add_disk().  When the
> gendisk is torn down, disk_release() is called and expects to return a
> disk queue reference that add_disk() normally would have taken out. (Se=
e
> commit 523e1d39.)  Fix the kref accounting by adding a blk_get_queue()
> to st_probe().
>=20
> Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
> Tested-by: Ewan D. Milne <emilne@redhat.com>=20

I don't have to like this fix but as it fixes a real problem:

Acked-by: Kai M=C3=A4kisara <Kai.Makisara@kolumbus.fi>

(It should not be necessary to get additional references outside the bloc=
k=20
layer to make the block layer behave.)

Thanks,
Kai
---1463811327-129177391-1362503881=:4183--
