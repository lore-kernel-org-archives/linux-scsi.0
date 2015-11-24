From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] Fix a memory leak in scsi_host_dev_release()
Date: Tue, 24 Nov 2015 13:55:22 +0100
Message-ID: <1448369722.2877.33.camel@suse.de>
References: <564D0224.9040001@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54002 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753387AbbKXMzX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Nov 2015 07:55:23 -0500
In-Reply-To: <564D0224.9040001@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, 2015-11-18 at 14:56 -0800, Bart Van Assche wrote:
> Avoid that kmemleak reports the following memory leak if a
> SCSI LLD calls scsi_host_alloc() and scsi_host_put() but neither
> scsi_host_add() nor scsi_host_remove(). The following shell
> command triggers that scenario:
>=20
> for ((i=3D0; i<2; i++)); do
> =C2=A0 srp_daemon -oac |
> =C2=A0 while read line; do
> =C2=A0=C2=A0=C2=A0=C2=A0echo $line >/sys/class/infiniband_srp/srp-mlx=
4_0-1/add_target
> =C2=A0 done
> done
>=20
> unreferenced object 0xffff88021b24a220 (size 8):
> =C2=A0 comm "srp_daemon", pid 56421, jiffies 4295006762 (age 4240.750=
s)
> =C2=A0 hex dump (first 8 bytes):
> =C2=A0=C2=A0=C2=A0=C2=A068 6f 73 74 35 38 00 a5=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0host58..
> =C2=A0 backtrace:
> =C2=A0=C2=A0=C2=A0=C2=A0[<ffffffff8151014a>] kmemleak_alloc+0x7a/0xc0
> =C2=A0=C2=A0=C2=A0=C2=A0[<ffffffff81165c1e>] __kmalloc_track_caller+0=
xfe/0x160
> =C2=A0=C2=A0=C2=A0=C2=A0[<ffffffff81260d2b>] kvasprintf+0x5b/0x90
> =C2=A0=C2=A0=C2=A0=C2=A0[<ffffffff81260e2d>] kvasprintf_const+0x8d/0x=
b0
> =C2=A0=C2=A0=C2=A0=C2=A0[<ffffffff81254b0c>] kobject_set_name_vargs+0=
x3c/0xa0
> =C2=A0=C2=A0=C2=A0=C2=A0[<ffffffff81337e3c>] dev_set_name+0x3c/0x40
> =C2=A0=C2=A0=C2=A0=C2=A0[<ffffffff81355757>] scsi_host_alloc+0x327/0x=
4b0
> =C2=A0=C2=A0=C2=A0=C2=A0[<ffffffffa03edc8e>] srp_create_target+0x4e/0=
x8a0 [ib_srp]
> =C2=A0=C2=A0=C2=A0=C2=A0[<ffffffff8133778b>] dev_attr_store+0x1b/0x20
> =C2=A0=C2=A0=C2=A0=C2=A0[<ffffffff811f27fa>] sysfs_kf_write+0x4a/0x60
> =C2=A0=C2=A0=C2=A0=C2=A0[<ffffffff811f1e8e>] kernfs_fop_write+0x14e/0=
x180
> =C2=A0=C2=A0=C2=A0=C2=A0[<ffffffff81176eef>] __vfs_write+0x2f/0xf0
> =C2=A0=C2=A0=C2=A0=C2=A0[<ffffffff811771e4>] vfs_write+0xa4/0x100
> =C2=A0=C2=A0=C2=A0=C2=A0[<ffffffff81177c64>] SyS_write+0x54/0xc0
> =C2=A0=C2=A0=C2=A0=C2=A0[<ffffffff8151b257>] entry_SYSCALL_64_fastpat=
h+0x12/0x6f
>=20
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: stable <stable@vger.kernel.org>
> ---
> =C2=A0drivers/scsi/hosts.c | 11 +++++++++++
> =C2=A01 file changed, 11 insertions(+)
>=20
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 323982f..82ac1cd 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -333,6 +333,17 @@ static void scsi_host_dev_release(struct device
> *dev)
> =C2=A0		kfree(queuedata);
> =C2=A0	}
> =C2=A0
> +	if (shost->shost_state =3D=3D SHOST_CREATED) {
> +		/*
> +		=C2=A0* Free the shost_dev device name here if
> scsi_host_alloc()
> +		=C2=A0* and scsi_host_put() have been called but neither
> +		=C2=A0* scsi_host_add() nor scsi_host_remove() has been
> called.
> +		=C2=A0* This avoids that the memory allocated for the
> shost_dev
> +		=C2=A0* name is leaked.
> +		=C2=A0*/
> +		kfree(dev_name(&shost->shost_dev));
> +	}
> +
> =C2=A0	scsi_destroy_command_freelist(shost);
> =C2=A0	if (shost_use_blk_mq(shost)) {
> =C2=A0		if (shost->tag_set.tags)

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
