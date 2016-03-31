From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 1/2] scsi: Add intermediate STARGET_REMOVE state to
 scsi_target_state
Date: Thu, 31 Mar 2016 18:17:37 +0200
Message-ID: <56FD4DA1.3000006@suse.de>
References: <cover.1459428540.git.jthumshirn@suse.de>
 <95ae7ee32dca23bb7f3ab432046fb7016b341049.1459428540.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <95ae7ee32dca23bb7f3ab432046fb7016b341049.1459428540.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Ewan D. Milne" <emilne@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 03/31/2016 02:53 PM, Johannes Thumshirn wrote:
> Add intermediate STARGET_REMOVE state to scsi_target_state to avoid r=
unning
> into the BUG_ON() in scsi_target_reap().
>=20
> This intermediate state is only valid in the path from scsi_remove_ta=
rget() to
> scsi_target_destroy() indicating this target is going to be removed.
>=20
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> Fixes: 40998193560dab6c3ce8d25f4fa58a23e252ef38
> ---
>  drivers/scsi/scsi_scan.c   | 2 ++
>  drivers/scsi/scsi_sysfs.c  | 2 ++
>  include/scsi/scsi_device.h | 1 +
>  3 files changed, 5 insertions(+)
>=20
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 6a82066..63b8bca 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -315,6 +315,8 @@ static void scsi_target_destroy(struct scsi_targe=
t *starget)
>  	struct Scsi_Host *shost =3D dev_to_shost(dev->parent);
>  	unsigned long flags;
> =20
> +	BUG_ON(starget->state !=3D STARGET_REMOVE &&
> +	       starget->state !=3D STARGET_CREATED);
>  	starget->state =3D STARGET_DEL;
>  	transport_destroy_device(dev);
>  	spin_lock_irqsave(shost->host_lock, flags);
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 00bc721..0df82e8 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1279,11 +1279,13 @@ restart:
>  	spin_lock_irqsave(shost->host_lock, flags);
>  	list_for_each_entry(starget, &shost->__targets, siblings) {
>  		if (starget->state =3D=3D STARGET_DEL ||
> +		    starget->state =3D=3D STARGET_REMOVE ||
>  		    starget =3D=3D last_target)
>  			continue;
>  		if (starget->dev.parent =3D=3D dev || &starget->dev =3D=3D dev) {
>  			kref_get(&starget->reap_ref);
>  			last_target =3D starget;
> +			starget->state =3D STARGET_REMOVE;
>  			spin_unlock_irqrestore(shost->host_lock, flags);
>  			__scsi_remove_target(starget);
>  			scsi_target_reap(starget);
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index f63a167..2bffaa6 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -240,6 +240,7 @@ scmd_printk(const char *, const struct scsi_cmnd =
*, const char *, ...);
>  enum scsi_target_state {
>  	STARGET_CREATED =3D 1,
>  	STARGET_RUNNING,
> +	STARGET_REMOVE,
>  	STARGET_DEL,
>  };
> =20
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
