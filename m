From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/3]  SCSI: Rework list handling in __scsi_target_remove
Date: Wed, 14 Oct 2015 16:19:16 +0200
Message-ID: <561E6464.2020702@suse.de>
References: <cover.1444829611.git.jthumshirn@suse.de> <1cfe37e6cb89ede18c88e60578d4293a6eb7430b.1444829611.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1cfe37e6cb89ede18c88e60578d4293a6eb7430b.1444829611.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/14/2015 03:50 PM, Johannes Thumshirn wrote:
> Rework the list handling in __scsi_target_remove(). The new version i=
ntroduces
> a reap list for devices. Devices that shall be removed are placed on =
the reap
> list and can then be removed later on.
>=20
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/scsi_sysfs.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index b41dcb3..2bd88c6 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1129,20 +1129,24 @@ static void __scsi_remove_target(struct scsi_=
target *starget)
>  {
>  	struct Scsi_Host *shost =3D dev_to_shost(starget->dev.parent);
>  	unsigned long flags;
> -	struct scsi_device *sdev;
> +	struct scsi_device *sdev, *tmp;
> +	LIST_HEAD(reap_list);
> =20
>  	spin_lock_irqsave(&shost->device_lock, flags);
>   restart:
> -	list_for_each_entry(sdev, &shost->__devices, siblings) {
> +	list_for_each_entry_safe(sdev, tmp, &shost->__devices, siblings) {
>  		if (sdev->channel !=3D starget->channel ||
>  		    sdev->id !=3D starget->id ||
>  		    scsi_device_get(sdev))
>  			continue;
> -		scsi_remove_device(sdev);
> +		list_move_tail(&sdev->siblings, &reap_list);
>  		scsi_device_put(sdev);
>  		goto restart;
>  	}
>  	spin_unlock_irqrestore(&shost->device_lock, flags);
> +
> +	list_for_each_entry_safe(sdev, tmp, &reap_list, siblings)
> +		scsi_remove_device(sdev);
>  }
> =20
>  /**
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
