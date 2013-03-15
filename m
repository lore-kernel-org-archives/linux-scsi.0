From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH v2] st: Take additional queue ref in st_probe
Date: Fri, 15 Mar 2013 08:51:54 -0400
Message-ID: <1363351914.18372.176.camel@localhost.localdomain>
References: <alpine.DEB.2.02.1303041101450.1736@jlaw-desktop.mno.stratus.com>
	 <5135E780.6040303@redhat.com>
	 <alpine.DEB.2.02.1303051053040.1736@jlaw-desktop.mno.stratus.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754167Ab3COMwQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Mar 2013 08:52:16 -0400
In-Reply-To: <alpine.DEB.2.02.1303051053040.1736@jlaw-desktop.mno.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <Joe.Lawrence@stratus.com>
Cc: linux-scsi@vger.kernel.org, Jan Vesely <jvesely@redhat.com>, "Seymour, Shane M" <shane.seymour@hp.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Kai =?ISO-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>

On Tue, 2013-03-05 at 10:57 -0500, Joe Lawrence wrote:
> Changes from v1:
>   Corrected error paths as noted by Ewan Milne and Jan Vesely.

Acked-by: Ewan D. Milne <emilne@redhat.com>

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
> In commit 523e1d39 (block: make gendisk hold a reference to its queue=
)=20
> add_disk() and disk_release() were modified to get/put an additional
> reference on a disk queue to fix a reference counting discrepency
> between bdev release and SCSI device removal.  The ST driver never
> calls add_disk(), so this commit introduced an extra kref put when th=
e
> ST driver frees its struct gendisk.
>=20
> Attempts were made to fix this bug at the block level [1] but later
> abandoned due to floppy driver issues [2].
>=20
> [1] https://lkml.org/lkml/2012/8/27/354
> [2] https://lkml.org/lkml/2012/9/22/113
>=20
> From a50a6ee28748b7c1620af6f76772164ec0fc4a1d Mon Sep 17 00:00:00 200=
1
> From: Joe Lawrence <joe.lawrence@stratus.com>
> Date: Tue, 5 Mar 2013 09:30:14 -0500
> Subject: [PATCH v2] st: Take additional queue ref in st_probe
> MIME-Version: 1.0
> Content-Type: text/plain; charset=3DUTF-8
> Content-Transfer-Encoding: 8bit
>=20
> The SCSI tape driver employs a struct gendisk, calling alloc_disk() t=
o
> create an instance, but does not register it via add_disk().  When th=
e
> gendisk is torn down, disk_release() is called and expects to return =
a
> disk queue reference that add_disk() normally would have taken out. (=
See
> commit 523e1d39.)  Fix the kref accounting by adding a blk_get_queue(=
)
> to st_probe().
>=20
> Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
> Tested-by: Ewan D. Milne <emilne@redhat.com>=20
> Cc: Kai M=C3=A4kisara <Kai.Makisara@kolumbus.fi>
> Cc: James E.J. Bottomley <JBottomley@parallels.com>
> Cc: "Seymour, Shane M" <shane.seymour@hp.com>
> Cc: Jan Vesely <jvesely@redhat.com>
> Cc: linux-scsi@vger.kernel.org
> ---
>  drivers/scsi/st.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index 98156a9..96f3363 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -4112,6 +4112,10 @@ static int st_probe(struct device *dev)
>  	tpnt->disk =3D disk;
>  	disk->private_data =3D &tpnt->driver;
>  	disk->queue =3D SDp->request_queue;
> +	/* SCSI tape doesn't register this gendisk via add_disk().  Manuall=
y
> +	 * take queue reference that release_disk() expects. */
> +	if (!blk_get_queue(disk->queue))
> +		goto out_put_disk;
>  	tpnt->driver =3D &st_template;
> =20
>  	tpnt->device =3D SDp;
> @@ -4181,7 +4185,7 @@ static int st_probe(struct device *dev)
>  	if (!idr_pre_get(&st_index_idr, GFP_KERNEL)) {
>  		pr_warn("st: idr expansion failed\n");
>  		error =3D -ENOMEM;
> -		goto out_put_disk;
> +		goto out_put_queue;
>  	}
> =20
>  	spin_lock(&st_index_lock);
> @@ -4189,7 +4193,7 @@ static int st_probe(struct device *dev)
>  	spin_unlock(&st_index_lock);
>  	if (error) {
>  		pr_warn("st: idr allocation failed: %d\n", error);
> -		goto out_put_disk;
> +		goto out_put_queue;
>  	}
> =20
>  	if (dev_num > ST_MAX_TAPES) {
> @@ -4222,6 +4226,8 @@ out_put_index:
>  	spin_lock(&st_index_lock);
>  	idr_remove(&st_index_idr, dev_num);
>  	spin_unlock(&st_index_lock);
> +out_put_queue:
> +	blk_put_queue(disk->queue);
>  out_put_disk:
>  	put_disk(disk);
>  	kfree(tpnt);


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
