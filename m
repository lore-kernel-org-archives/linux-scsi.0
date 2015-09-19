From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: Fix a bdi reregistration race
Date: Sat, 19 Sep 2015 09:46:42 +0200
Message-ID: <55FD12E2.8030603@suse.de>
References: <55FCAB0E.3020707@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57795 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426AbbISHqp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Sep 2015 03:46:45 -0400
In-Reply-To: <55FCAB0E.3020707@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <jbottomley@odin.com>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 09/19/2015 02:23 AM, Bart Van Assche wrote:
> Unregister and reregister BDI devices in the proper order. This patch
> avoids that the following kernel warning can get triggered:
>=20
> WARNING: CPU: 7 PID: 203 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x68/0x8=
0()
> sysfs: cannot create duplicate filename '/devices/virtual/bdi/8:32'
> Workqueue: events_unbound async_run_entry_fn
> Call Trace:
> [<ffffffff814ff5a4>] dump_stack+0x4c/0x65
> [<ffffffff810746ba>] warn_slowpath_common+0x8a/0xc0
> [<ffffffff81074736>] warn_slowpath_fmt+0x46/0x50
> [<ffffffff81237ca8>] sysfs_warn_dup+0x68/0x80
> [<ffffffff81237d8e>] sysfs_create_dir_ns+0x7e/0x90
> [<ffffffff81291f58>] kobject_add_internal+0xa8/0x320
> [<ffffffff812923a0>] kobject_add+0x60/0xb0
> [<ffffffff8138c937>] device_add+0x107/0x5e0
> [<ffffffff8138d018>] device_create_groups_vargs+0xd8/0x100
> [<ffffffff8138d05c>] device_create_vargs+0x1c/0x20
> [<ffffffff8117f233>] bdi_register+0x63/0x2a0
> [<ffffffff8117f497>] bdi_register_dev+0x27/0x30
> [<ffffffff81281549>] add_disk+0x1a9/0x4e0
> [<ffffffffa00c5739>] sd_probe_async+0x119/0x1d0 [sd_mod]
> [<ffffffff8109a81a>] async_run_entry_fn+0x4a/0x140
> [<ffffffff81091078>] process_one_work+0x1d8/0x7c0
> [<ffffffff81091774>] worker_thread+0x114/0x460
> [<ffffffff81097878>] kthread+0xf8/0x110
> [<ffffffff8150801f>] ret_from_fork+0x3f/0x70
>=20
> See also patch "block: destroy bdi before blockdev is unregistered"
> (commit ID 6cd18e711dd8).
>=20
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/scsi/scsi_sysfs.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index b333389..5e085d4 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1084,9 +1084,7 @@ void __scsi_remove_device(struct scsi_device *s=
dev)
>  		device_unregister(&sdev->sdev_dev);
>  		transport_remove_device(dev);
>  		scsi_dh_remove_device(sdev);
> -		device_del(dev);
> -	} else
> -		put_device(&sdev->sdev_dev);
> +	}
> =20
>  	/*
>  	 * Stop accepting new requests and wait until all queuecommand() an=
d
> @@ -1097,6 +1095,16 @@ void __scsi_remove_device(struct scsi_device *=
sdev)
>  	blk_cleanup_queue(sdev->request_queue);
>  	cancel_work_sync(&sdev->requeue_work);
> =20
> +	/*
> +	 * Remove the device after blk_cleanup_queue() has been called such
> +	 * a possible bdi_register() call with the same name occurs after
> +	 * blk_cleanup_queue() has called bdi_destroy().
> +	 */
> +	if (sdev->is_visible)
> +		device_del(dev);
> +	else
> +		put_device(&sdev->sdev_dev);
> +
>  	if (sdev->host->hostt->slave_destroy)
>  		sdev->host->hostt->slave_destroy(sdev);
>  	transport_destroy_device(dev);
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
