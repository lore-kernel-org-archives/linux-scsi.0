From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 19/20] scsi_dh_alua: update 'access_state' field
Date: Wed, 30 Dec 2015 14:34:05 +0100
Message-ID: <20151230133405.GA15705@lst.de>
References: <1449560260-53407-1-git-send-email-hare@suse.de> <1449560260-53407-20-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49570 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022AbbL3NeH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Dec 2015 08:34:07 -0500
Content-Disposition: inline
In-Reply-To: <1449560260-53407-20-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jbottomley@odin.com>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Tue, Dec 08, 2015 at 08:37:39AM +0100, Hannes Reinecke wrote:
> Track attached SCSI devices and update the 'access_state' field
> whenever an ALUA state change has been detected.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 29 ++++++++++++++++++++=
+++++++++
>  1 file changed, 29 insertions(+)
>=20
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scs=
i/device_handler/scsi_dh_alua.c
> index 6c6ff0b..d01c86407 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -24,6 +24,7 @@
>  #include <linux/module.h>
>  #include <asm/unaligned.h>
>  #include <scsi/scsi.h>
> +#include <scsi/scsi_proto.h>
>  #include <scsi/scsi_dbg.h>
>  #include <scsi/scsi_eh.h>
>  #include <scsi/scsi_dh.h>
> @@ -76,6 +77,7 @@ static struct workqueue_struct *kaluad_wq;
>  struct alua_port_group {
>  	struct kref		kref;
>  	struct list_head	node;
> +	struct list_head	dh_list;
>  	unsigned char		device_id_str[256];
>  	int			device_id_len;
>  	int			group_id;
> @@ -93,6 +95,7 @@ struct alua_port_group {
>  };
> =20
>  struct alua_dh_data {
> +	struct list_head	node;
>  	struct alua_port_group	*pg;
>  	int			rel_port;
>  	spinlock_t		pg_lock;
> @@ -243,6 +246,7 @@ struct alua_port_group *alua_get_pg(struct scsi_d=
evice *sdev,
>  	INIT_DELAYED_WORK(&pg->rtpg_work, alua_rtpg_work);
>  	INIT_LIST_HEAD(&pg->rtpg_list);
>  	INIT_LIST_HEAD(&pg->node);
> +	INIT_LIST_HEAD(&pg->dh_list);
>  	spin_lock_init(&pg->lock);
> =20
>  	/* Re-check list again to catch concurrent updates */
> @@ -370,13 +374,26 @@ static int alua_check_vpd(struct scsi_device *s=
dev, struct alua_dh_data *h,
>  		old_pg =3D pg;
>  		/* port_group has changed. Update to new port group */
>  		if (h->pg !=3D pg) {
> +			unsigned long flags;
> +
>  			old_pg =3D h->pg;
>  			rcu_assign_pointer(h->pg, pg);
> +			spin_lock_irqsave(&old_pg->lock, flags);
> +			list_del_rcu(&h->node);
> +			spin_unlock_irqrestore(&old_pg->lock, flags);
> +			spin_lock_irqsave(&pg->lock, flags);
> +			list_add_rcu(&h->node, &pg->dh_list);
> +			spin_unlock_irqrestore(&pg->lock, flags);

I think it makes more sense to remove it from the old list
before assining the new h->pg pointer to stay consistant.

Also the add code is not common with the other half of the outer
branch, it would be nice to find a way to share the code between
those two branches.

>  		list_for_each_entry(tmp_pg, &port_group_list, node) {
> +			struct alua_dh_data *h;
> +
>  			if (tmp_pg->group_id !=3D group_id)
>  				continue;
>  			if (tmp_pg->device_id_len !=3D pg->device_id_len)
> @@ -639,6 +658,12 @@ static int alua_rtpg(struct scsi_device *sdev, s=
truct alua_port_group *pg)
>  				continue;
>  			tmp_pg->state =3D desc[0] & 0x0f;
>  			tmp_pg->pref =3D desc[0] >> 7;
> +			rcu_read_lock();
> +			list_for_each_entry_rcu(h, &tmp_pg->dh_list, node) {
> +				if (h->sdev)
> +					h->sdev->access_state =3D desc[0];
> +			}
> +			rcu_read_unlock();

=D0=86'd expect h->=D1=95dev to always be non-NULL.  With a little twea=
k (see below)
that should indeed be the case.

> @@ -1086,6 +1112,9 @@ static void alua_bus_detach(struct scsi_device =
*sdev)
>  	h->sdev =3D NULL;
>  	spin_unlock(&h->pg_lock);
>  	if (pg) {
> +		spin_lock(&pg->lock);
> +		list_del_rcu(&h->node);
> +		spin_unlock(&pg->lock);
>  		synchronize_rcu();
>  		if (pg->rtpg_sdev)
>  			flush_delayed_work(&pg->rtpg_work);

Here we'd just need to make sure to do the list_del before setting
h->sdev to NULL.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
