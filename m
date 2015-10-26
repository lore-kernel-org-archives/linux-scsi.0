From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi: restart list search after unlock in
 scsi_remove_target
Date: Mon, 26 Oct 2015 09:35:37 +0100
Message-ID: <1445848537.16404.26.camel@suse.de>
References: <20151019143546.GA7486@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55328 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049AbbJZIfj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Oct 2015 04:35:39 -0400
In-Reply-To: <20151019143546.GA7486@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On Mon, 2015-10-19 at 16:35 +0200, Christoph Hellwig wrote:
> When dropping a lock while iterating a list we must restart the
> search
> as other threads could have manipulated the list under us.=C2=A0=C2=A0=
Without
> this
> we can get stuck in an endless loop.
>=20
> Reported-by: Johannes Thumshirn <jthumshirn@suse.de>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>=20
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index b333389f..d3b34d8 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1158,31 +1158,23 @@ static void __scsi_remove_target(struct
> scsi_target *starget)
> =C2=A0void scsi_remove_target(struct device *dev)
> =C2=A0{
> =C2=A0	struct Scsi_Host *shost =3D dev_to_shost(dev->parent);
> -	struct scsi_target *starget, *last =3D NULL;
> +	struct scsi_target *starget;
> =C2=A0	unsigned long flags;
> =C2=A0
> -	/* remove targets being careful to lookup next entry before
> -	=C2=A0* deleting the last
> -	=C2=A0*/
> +restart:
> =C2=A0	spin_lock_irqsave(shost->host_lock, flags);
> =C2=A0	list_for_each_entry(starget, &shost->__targets, siblings) {
> =C2=A0		if (starget->state =3D=3D STARGET_DEL)
> =C2=A0			continue;
> =C2=A0		if (starget->dev.parent =3D=3D dev || &starget->dev =3D=3D
> dev) {
> -			/* assuming new targets arrive at the end */
> =C2=A0			kref_get(&starget->reap_ref);
> =C2=A0			spin_unlock_irqrestore(shost->host_lock,
> flags);
> -			if (last)
> -				scsi_target_reap(last);
> -			last =3D starget;
> =C2=A0			__scsi_remove_target(starget);
> -			spin_lock_irqsave(shost->host_lock, flags);
> +			scsi_target_reap(starget);
> +			goto restart;
> =C2=A0		}
> =C2=A0	}
> =C2=A0	spin_unlock_irqrestore(shost->host_lock, flags);
> -
> -	if (last)
> -		scsi_target_reap(last);
> =C2=A0}
> =C2=A0EXPORT_SYMBOL(scsi_remove_target);

Hi Christoph,

I haven't heard anything from the original reporter of the lockup but
my test's went all O.K., so=C2=A0

Tested-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

> =C2=A0
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
=20
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0=C2=A0http://vger.kernel.org/majordomo-in=
fo.html

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
