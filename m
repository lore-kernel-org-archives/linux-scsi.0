From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/2] scsi_transport_fc: Introduce scsi_host_{get,put}()
Date: Tue, 24 Nov 2015 13:43:32 +0100
Message-ID: <1448369012.2877.28.camel@suse.de>
References: <564F910E.9070306@sandisk.com> <564F9190.5090103@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52632 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960AbbKXMnf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Nov 2015 07:43:35 -0500
In-Reply-To: <564F9190.5090103@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Smart <james.smart@emulex.com>

On Fri, 2015-11-20 at 13:33 -0800, Bart Van Assche wrote:
> Use scsi_host_{get,put}() instead of open-coding these functions.
> Compile-tested only.
>=20
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: James Smart <james.smart@emulex.com>
> Cc: stable <stable@vger.kernel.org>
> ---
> =C2=A0drivers/scsi/scsi_transport_fc.c | 12 ++++++------
> =C2=A01 file changed, 6 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_transport_fc.c
> b/drivers/scsi/scsi_transport_fc.c
> index 24eaaf6..8a88226 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -2586,7 +2586,7 @@ fc_rport_final_delete(struct work_struct *work)
> =C2=A0	transport_remove_device(dev);
> =C2=A0	device_del(dev);
> =C2=A0	transport_destroy_device(dev);
> -	put_device(&shost->shost_gendev);	/* for fc_host-
> >rport list */
> +	scsi_host_put(shost);			/* for fc_host-
> >rport list */
> =C2=A0	put_device(dev);			/* for self-
> reference */
> =C2=A0}
> =C2=A0
> @@ -2650,7 +2650,7 @@ fc_rport_create(struct Scsi_Host *shost, int
> channel,
> =C2=A0	else
> =C2=A0		rport->scsi_target_id =3D -1;
> =C2=A0	list_add_tail(&rport->peers, &fc_host->rports);
> -	get_device(&shost->shost_gendev);	/* for fc_host-
> >rport list */
> +	scsi_host_get(shost);			/* for fc_host-
> >rport list */
> =C2=A0
> =C2=A0	spin_unlock_irqrestore(shost->host_lock, flags);
> =C2=A0
> @@ -2685,7 +2685,7 @@ delete_rport:
> =C2=A0	transport_destroy_device(dev);
> =C2=A0	spin_lock_irqsave(shost->host_lock, flags);
> =C2=A0	list_del(&rport->peers);
> -	put_device(&shost->shost_gendev);	/* for fc_host-
> >rport list */
> +	scsi_host_put(shost);			/* for fc_host-
> >rport list */
> =C2=A0	spin_unlock_irqrestore(shost->host_lock, flags);
> =C2=A0	put_device(dev->parent);
> =C2=A0	kfree(rport);
> @@ -3383,7 +3383,7 @@ fc_vport_setup(struct Scsi_Host *shost, int
> channel, struct device *pdev,
> =C2=A0	fc_host->npiv_vports_inuse++;
> =C2=A0	vport->number =3D fc_host->next_vport_number++;
> =C2=A0	list_add_tail(&vport->peers, &fc_host->vports);
> -	get_device(&shost->shost_gendev);	/* for fc_host-
> >vport list */
> +	scsi_host_get(shost);			/* for fc_host-
> >vport list */
> =C2=A0
> =C2=A0	spin_unlock_irqrestore(shost->host_lock, flags);
> =C2=A0
> @@ -3441,7 +3441,7 @@ delete_vport:
> =C2=A0	transport_destroy_device(dev);
> =C2=A0	spin_lock_irqsave(shost->host_lock, flags);
> =C2=A0	list_del(&vport->peers);
> -	put_device(&shost->shost_gendev);	/* for fc_host-
> >vport list */
> +	scsi_host_put(shost);			/* for fc_host-
> >vport list */
> =C2=A0	fc_host->npiv_vports_inuse--;
> =C2=A0	spin_unlock_irqrestore(shost->host_lock, flags);
> =C2=A0	put_device(dev->parent);
> @@ -3504,7 +3504,7 @@ fc_vport_terminate(struct fc_vport *vport)
> =C2=A0		vport->flags |=3D FC_VPORT_DELETED;
> =C2=A0		list_del(&vport->peers);
> =C2=A0		fc_host->npiv_vports_inuse--;
> -		put_device(&shost->shost_gendev);=C2=A0=C2=A0/* for fc_host-
> >vport list */
> +		scsi_host_put(shost);		/* for fc_host-
> >vport list */
> =C2=A0	}
> =C2=A0	spin_unlock_irqrestore(shost->host_lock, flags);
> =C2=A0

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
