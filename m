From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/7] lpfc: remove queue_depth events
Date: Thu, 20 Nov 2014 08:27:07 +0100
Message-ID: <546D97CB.2050607@suse.de>
References: <1415901546-8006-1-git-send-email-hch@lst.de> <1415901546-8006-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47153 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755854AbaKTH1M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Nov 2014 02:27:12 -0500
In-Reply-To: <1415901546-8006-2-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: James Smart <james.smart@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>

On 11/13/2014 06:59 PM, Christoph Hellwig wrote:
> James Smart said the userspace to consume these events never emerged.=
  Given
> that these get in the way of the following patches remove support for=
 them.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/lpfc/lpfc_scsi.c | 66 ---------------------------------=
----------
>  1 file changed, 66 deletions(-)
>=20
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_s=
csi.c
> index 8533ee9..80351ff 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -243,60 +243,6 @@ lpfc_update_stats(struct lpfc_hba *phba, struct =
 lpfc_scsi_buf *lpfc_cmd)
>  }
> =20
>  /**
> - * lpfc_send_sdev_queuedepth_change_event - Posts a queuedepth chang=
e event
> - * @phba: Pointer to HBA context object.
> - * @vport: Pointer to vport object.
> - * @ndlp: Pointer to FC node associated with the target.
> - * @lun: Lun number of the scsi device.
> - * @old_val: Old value of the queue depth.
> - * @new_val: New value of the queue depth.
> - *
> - * This function sends an event to the mgmt application indicating
> - * there is a change in the scsi device queue depth.
> - **/
> -static void
> -lpfc_send_sdev_queuedepth_change_event(struct lpfc_hba *phba,
> -		struct lpfc_vport  *vport,
> -		struct lpfc_nodelist *ndlp,
> -		uint64_t lun,
> -		uint32_t old_val,
> -		uint32_t new_val)
> -{
> -	struct lpfc_fast_path_event *fast_path_evt;
> -	unsigned long flags;
> -
> -	fast_path_evt =3D lpfc_alloc_fast_evt(phba);
> -	if (!fast_path_evt)
> -		return;
> -
> -	fast_path_evt->un.queue_depth_evt.scsi_event.event_type =3D
> -		FC_REG_SCSI_EVENT;
> -	fast_path_evt->un.queue_depth_evt.scsi_event.subcategory =3D
> -		LPFC_EVENT_VARQUEDEPTH;
> -
> -	/* Report all luns with change in queue depth */
> -	fast_path_evt->un.queue_depth_evt.scsi_event.lun =3D lun;
> -	if (ndlp && NLP_CHK_NODE_ACT(ndlp)) {
> -		memcpy(&fast_path_evt->un.queue_depth_evt.scsi_event.wwpn,
> -			&ndlp->nlp_portname, sizeof(struct lpfc_name));
> -		memcpy(&fast_path_evt->un.queue_depth_evt.scsi_event.wwnn,
> -			&ndlp->nlp_nodename, sizeof(struct lpfc_name));
> -	}
> -
> -	fast_path_evt->un.queue_depth_evt.oldval =3D old_val;
> -	fast_path_evt->un.queue_depth_evt.newval =3D new_val;
> -	fast_path_evt->vport =3D vport;
> -
> -	fast_path_evt->work_evt.evt =3D LPFC_EVT_FASTPATH_MGMT_EVT;
> -	spin_lock_irqsave(&phba->hbalock, flags);
> -	list_add_tail(&fast_path_evt->work_evt.evt_listp, &phba->work_list)=
;
> -	spin_unlock_irqrestore(&phba->hbalock, flags);
> -	lpfc_worker_wake_up(phba);
> -
> -	return;
> -}
> -
> -/**
>   * lpfc_change_queue_depth - Alter scsi device queue depth
>   * @sdev: Pointer the scsi device on which to change the queue depth=
=2E
>   * @qdepth: New queue depth to set the sdev to.
> @@ -310,11 +256,6 @@ static int
>  lpfc_change_queue_depth(struct scsi_device *sdev, int qdepth, int re=
ason)
>  {
>  	struct lpfc_vport *vport =3D (struct lpfc_vport *) sdev->host->host=
data;
> -	struct lpfc_hba   *phba =3D vport->phba;
> -	struct lpfc_rport_data *rdata;
> -	unsigned long new_queue_depth, old_queue_depth;
> -
> -	old_queue_depth =3D sdev->queue_depth;
> =20
>  	switch (reason) {
>  	case SCSI_QDEPTH_DEFAULT:
> @@ -334,13 +275,6 @@ lpfc_change_queue_depth(struct scsi_device *sdev=
, int qdepth, int reason)
>  		return -EOPNOTSUPP;
>  	}
> =20
> -	new_queue_depth =3D sdev->queue_depth;
> -	rdata =3D lpfc_rport_data_from_scsi_device(sdev);
> -	if (rdata)
> -		lpfc_send_sdev_queuedepth_change_event(phba, vport,
> -						       rdata->pnode, sdev->lun,
> -						       old_queue_depth,
> -						       new_queue_depth);
>  	return sdev->queue_depth;
>  }
> =20
>=20
You definitely need to get an ACK from James Smart for this.
There's a good possibility that there are some Emulex management
software which makes use of this event...

Otherwise:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
