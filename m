From: Jan Vesely <jvesely@redhat.com>
Subject: Re: [PATCH] st: Take additional queue ref in st_probe
Date: Tue, 05 Mar 2013 13:39:28 +0100
Message-ID: <5135E780.6040303@redhat.com>
References: <alpine.DEB.2.02.1303041101450.1736@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab3CEMjr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Mar 2013 07:39:47 -0500
In-Reply-To: <alpine.DEB.2.02.1303041101450.1736@jlaw-desktop.mno.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <Joe.Lawrence@stratus.com>
Cc: linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, =?UTF-8?B?S2FpIE3DpGtpc2FyYQ==?= <Kai.Makisara@kolumbus.fi>

Hi,

I don't understand how error paths are supposed to work with this patch=
=2E
As I see it, if we fail to get a reference, the error path tries to put=
 a=20
non-existent one. moreover, error paths on lines 4188 and 4196 still go=
to=20
out_put_disk, leaking the reference.

other than that, it fixes the load/unload cycle issue for me as well

thanks,


On 04/03/13 17:14, Joe Lawrence wrote:
> These changes were applied to scsi.git, branch "misc".  This patch
> fixes a reference count bug in the SCSI tape driver which can be
> reproduced with the following:
>
> * Boot with slub_debug=3DFZPU, tape drive attached
> * echo 1 > /sys/devices/... tape device pci path .../remove
> * Wait for device removal
> * echo 1 > /sys/kernel/slab/blkdev_queue/validate
> * Slub debug complains about corrupted poison pattern
>
> In commit 523e1d39 (block: make gendisk hold a reference to its queue=
)
> add_disk() and disk_release() were modified to get/put an additional
> reference on a disk queue to fix a reference counting discrepency
> between bdev release and SCSI device removal.  The ST driver never
> calls add_disk(), so this commit introduced an extra kref put when th=
e
> ST driver frees its struct gendisk.
>
> Attempts were made to fix this bug at the block level [1] but later
> abandoned due to floppy driver issues [2].
>
> [1] https://lkml.org/lkml/2012/8/27/354
> [2] https://lkml.org/lkml/2012/9/22/113
>
> Regards,
>
> -- Joe
>
>  From f209bda3ee16a70e714b55c372ed4265bfa91784 Mon Sep 17 00:00:00 20=
01
> From: Joe Lawrence <joe.lawrence@stratus.com>
> Date: Fri, 1 Mar 2013 17:32:30 -0500
> Subject: [PATCH] st: Take additional queue ref in st_probe
> MIME-Version: 1.0
> Content-Type: text/plain; charset=3DUTF-8
> Content-Transfer-Encoding: 8bit
>
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
>
> Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
> Tested-by: Ewan Milne <emilne@redhat.com>
> Cc: Kai M=C3=A4kisara <Kai.Makisara@kolumbus.fi>
> Cc: James E.J. Bottomley <JBottomley@parallels.com>
> Cc: Ewan Milne <emilne@redhat.com>
> Cc: linux-scsi@vger.kernel.org
> ---
>   drivers/scsi/st.c | 6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index 98156a9..eef8ddc 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -4112,6 +4112,10 @@ static int st_probe(struct device *dev)
>   	tpnt->disk =3D disk;
>   	disk->private_data =3D &tpnt->driver;
>   	disk->queue =3D SDp->request_queue;
> +	/* SCSI tape doesn't register this gendisk via add_disk().  Manuall=
y
> +	 * take queue reference that release_disk() expects. */
> +	if (!blk_get_queue(disk->queue))
> +		goto out_put_queue;
>   	tpnt->driver =3D &st_template;
>
>   	tpnt->device =3D SDp;
> @@ -4222,6 +4226,8 @@ out_put_index:
>   	spin_lock(&st_index_lock);
>   	idr_remove(&st_index_idr, dev_num);
>   	spin_unlock(&st_index_lock);
> +out_put_queue:
> +	blk_put_queue(disk->queue);
>   out_put_disk:
>   	put_disk(disk);
>   	kfree(tpnt);
>


--=20
-----
Jan Vesely <jvesely@redhat.com>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
