From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/2] scsi_dh_alua: Fix a recently introduced deadlock
Date: Tue, 29 Mar 2016 08:41:59 +0200
Message-ID: <56FA23B7.7030608@suse.de>
References: <56F9740A.4060100@sandisk.com> <56F9746C.40101@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38756 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbcC2GmC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Mar 2016 02:42:02 -0400
In-Reply-To: <56F9746C.40101@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 03/28/2016 08:14 PM, Bart Van Assche wrote:
> While retesting the SRP initiator I ran the command "rmmod mlx4_ib"
> while I/O was in progress. That command triggers SCSI device removal
> indirectly. Avoid that this action triggers the following deadlock:
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [ INFO: inconsistent lock state ]
> 4.6.0-rc0-dbg+ #2 Tainted: G           O
> ---------------------------------
> inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
> multipathd/484 [HC0[0]:SC0[0]:HE1:SE1] takes:
>  (&(&pg->lock)->rlock){+.?...}, at: [<ffffffffa04f50a2>] alua_bus_det=
ach+0x52/0xa0 [scsi_dh_alua]
> {IN-SOFTIRQ-W} state was registered at:
>   [<ffffffff810a64a9>] __lock_acquire+0x7e9/0x1ad0
>   [<ffffffff810a7fd0>] lock_acquire+0x60/0x80
>   [<ffffffff8159910e>] _raw_spin_lock_irqsave+0x3e/0x60
>   [<ffffffffa04f5131>] alua_rtpg_queue+0x41/0x1d0 [scsi_dh_alua]
>   [<ffffffffa04f5531>] alua_check+0xe1/0x220 [scsi_dh_alua]
>   [<ffffffffa04f5709>] alua_check_sense+0x99/0xb0 [scsi_dh_alua]
>   [<ffffffff813f0d01>] scsi_check_sense+0x71/0x3f0
>   [<ffffffff813f2f8b>] scsi_decide_disposition+0x18b/0x1d0
>   [<ffffffff813f6e52>] scsi_softirq_done+0x52/0x140
>   [<ffffffff812a26f2>] blk_done_softirq+0x52/0x90
>   [<ffffffff8105bc1f>] __do_softirq+0x10f/0x230
>   [<ffffffff8105bec8>] irq_exit+0xa8/0xb0
>   [<ffffffff8101a675>] do_IRQ+0x65/0x110
>   [<ffffffff8159a2c9>] ret_from_intr+0x0/0x19
>   [<ffffffff811732f1>] kmem_cache_alloc+0x151/0x190
>   [<ffffffff8118e534>] create_object+0x34/0x2d0
>   [<ffffffff8158eaa6>] kmemleak_alloc_percpu+0x56/0xd0
>   [<ffffffff8113ab0d>] pcpu_alloc+0x38d/0x660
>   [<ffffffff8113aded>] __alloc_percpu_gfp+0xd/0x10
>   [<ffffffff812e56a5>] __percpu_counter_init+0x55/0xb0
>   [<ffffffff812b4989>] blkg_alloc+0x79/0x230
>   [<ffffffff812b6756>] blkcg_init_queue+0x26/0x1d0
>   [<ffffffff81297eed>] blk_alloc_queue_node+0x27d/0x2e0
>   [<ffffffffa017766c>] dm_create+0x20c/0x570 [dm_mod]
>   [<ffffffffa017e356>] dev_create+0x56/0x2c0 [dm_mod]
>   [<ffffffffa017dcae>] ctl_ioctl+0x26e/0x520 [dm_mod]
>   [<ffffffffa017df6e>] dm_ctl_ioctl+0xe/0x20 [dm_mod]
>   [<ffffffff811aa8ee>] do_vfs_ioctl+0x8e/0x660
>   [<ffffffff811aaefc>] SyS_ioctl+0x3c/0x70
>   [<ffffffff81599929>] entry_SYSCALL_64_fastpath+0x1c/0xac
> irq event stamp: 4290931
> hardirqs last  enabled at (4290931): [ 1662.892772]
> [<ffffffff81599341>] _raw_spin_unlock_irqrestore+0x31/0x50
> hardirqs last disabled at (4290930): [<ffffffff815990e7>] _raw_spin_l=
ock_irqsave+0x17/0x60
> softirqs last  enabled at (4290774): [<ffffffff8105bcdb>] __do_softir=
q+0x1cb/0x230
> softirqs last disabled at (4289831): [<ffffffff8105bec8>] irq_exit+0x=
a8/0xb0
>=20
> other info that might help us debug this:
>  Possible unsafe locking scenario:
>=20
>        CPU0
>        ----
>   lock(&(&pg->lock)->rlock);
>   <Interrupt>
>     lock(&(&pg->lock)->rlock);
>=20
>  *** DEADLOCK ***
>=20
> 2 locks held by multipathd/484:
>  #0:  (&bdev->bd_mutex){+.+.+.}, at: [<ffffffff811d1cc3>] __blkdev_pu=
t+0x33/0x360
>  #1:  (sd_ref_mutex){+.+...}, at: [<ffffffff81400afc>] scsi_disk_put+=
0x1c/0x40
>=20
> stack backtrace:
> CPU: 6 PID: 484 Comm: multipathd Tainted: G           O    4.6.0-rc0-=
dbg+ #2
> Call Trace:
>  [<ffffffff812bd115>] dump_stack+0x67/0x92
>  [<ffffffff810a5175>] print_usage_bug+0x215/0x240
>  [<ffffffff810a56ea>] mark_lock+0x54a/0x610
>  [<ffffffff810a6505>] __lock_acquire+0x845/0x1ad0
>  [<ffffffff810a7fd0>] lock_acquire+0x60/0x80
>  [<ffffffff81598f23>] _raw_spin_lock+0x33/0x50
>  [<ffffffffa04f50a2>] alua_bus_detach+0x52/0xa0 [scsi_dh_alua]
>  [<ffffffff813ff6f7>] scsi_dh_release_device+0x17/0x50
>  [<ffffffff813fb8da>] scsi_device_dev_release_usercontext+0x2a/0x120
>  [<ffffffff810701f0>] execute_in_process_context+0x80/0x90
>  [<ffffffff813fb8a7>] scsi_device_dev_release+0x17/0x20
>  [<ffffffff813c8cfd>] device_release+0x2d/0x90
>  [<ffffffff812bfa8a>] kobject_release+0x7a/0x190
>  [<ffffffff812bf946>] kobject_put+0x26/0x50
>  [<ffffffff813c8ee2>] put_device+0x12/0x20
>  [<ffffffff813edc86>] scsi_device_put+0x26/0x30
>  [<ffffffff81400b0d>] scsi_disk_put+0x2d/0x40
>  [<ffffffff81400b68>] sd_release+0x48/0xb0
>  [<ffffffff811d1f2e>] __blkdev_put+0x29e/0x360
>  [<ffffffff811d24b9>] blkdev_put+0x49/0x170
>  [<ffffffff811d2600>] blkdev_close+0x20/0x30
>  [<ffffffff81198f48>] __fput+0xe8/0x1f0
>  [<ffffffff81199089>] ____fput+0x9/0x10
>  [<ffffffff81075d9e>] task_work_run+0x6e/0xa0
>  [<ffffffff81001119>] exit_to_usermode_loop+0xa9/0xb0
>  [<ffffffff81001590>] syscall_return_slowpath+0xb0/0xc0
>  [<ffffffff815999b7>] entry_SYSCALL_64_fastpath+0xaa/0xac
>=20
> Fixes: cb0a168cb6b8 (scsi_dh_alua: update 'access_state' field)
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scs=
i/device_handler/scsi_dh_alua.c
> index a404a41..8eaed05 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -1112,9 +1112,9 @@ static void alua_bus_detach(struct scsi_device =
*sdev)
>  	h->sdev =3D NULL;
>  	spin_unlock(&h->pg_lock);
>  	if (pg) {
> -		spin_lock(&pg->lock);
> +		spin_lock_irq(&pg->lock);
>  		list_del_rcu(&h->node);
> -		spin_unlock(&pg->lock);
> +		spin_unlock_irq(&pg->lock);
>  		kref_put(&pg->kref, release_port_group);
>  	}
>  	sdev->handler_data =3D NULL;
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
