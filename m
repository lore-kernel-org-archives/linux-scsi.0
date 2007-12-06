From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.24-rc4-mm1: hostbyte=0x01 driverbyte=0x00 (now bisected)
Date: Thu, 6 Dec 2007 13:08:43 +0100
Message-ID: <20071206120843.GC5231@kernel.dk>
References: <20071204211701.994dfce6.akpm@linux-foundation.org> <20071205234154.GA4041@martell.zuzino.mipt.ru> <4757AA3D.4060003@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:7718 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbXLFMLM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Dec 2007 07:11:12 -0500
Content-Disposition: inline
In-Reply-To: <4757AA3D.4060003@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Thu, Dec 06 2007, Hannes Reinecke wrote:
> Alexey Dobriyan wrote:
> >>  git-scsi-misc.patch
> >=20
> > Apologies for not looking into the problem earlier. See
> > http://marc.info/?t=3D119628022300005&r=3D1&w=3D2
> > "2.6.24-rc3-mm2: Result: hostbyte=3D0x01 driverbyte=3D0x00\nend_req=
uest: I/O error"
> > for previous installment.
> >=20
> > I've bisected it to the following patch in git-scsi-misc branch.
> > Revert on top of 2.6.24-rc4-mm1 also helps.
> >=20
> > commit 8655a546c83fc43f0a73416bbd126d02de7ad6c0
> > Author: Hannes Reinecke <hare@suse.de>
> > Date:   Tue Nov 6 09:23:40 2007 +0100
> >=20
> >     [SCSI] Do not requeue requests if REQ_FAILFAST is set
> >    =20
> >     Any requests with the REQ_FAILFAST flag set should not be reque=
ued
> >     to the requeust queue, but rather terminated directly.
> >     Otherwise the multipath failover will stall until the command
> >     timeout triggers.
> >    =20
> >     Signed-off-by: Hannes Reinecke <hare@suse.de>
> >     Signed-off-by: James Bottomley <James.Bottomley@HansenPartnersh=
ip.com>
> >=20
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index 0f44bdb..0da0dd0 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -1286,6 +1286,11 @@ int scsi_prep_state_check(struct scsi_device=
 *sdev, struct request *req)
> >  			 */
> >  			if (!(req->cmd_flags & REQ_PREEMPT))
> >  				ret =3D BLKPREP_DEFER;
> > +			/*
> > +			 * Return failfast requests immediately
> > +			 */
> > +			if (req->cmd_flags & REQ_FAILFAST)
> > +				ret =3D BLKPREP_KILL;
> >  			break;
> >  		default:
> >  			/*
> > @@ -1414,6 +1419,17 @@ static inline int scsi_host_queue_ready(stru=
ct request_queue *q,
> >  	return 1;
> >  }
> > =20
> > +static void __scsi_kill_request(struct request *req)
> > +{
> > +	struct scsi_cmnd *cmd =3D req->special;
> > +	struct scsi_device *sdev =3D cmd->device;
> > +
> > +	cmd->result =3D DID_NO_CONNECT << 16;
> > +	atomic_inc(&cmd->device->iorequest_cnt);
> > +	sdev->device_busy--;
> > +	__scsi_done(cmd);
> > +}
> > +
> >  /*
> >   * Kill a request for a dead device
> >   */
> > @@ -1527,8 +1543,16 @@ static void scsi_request_fn(struct request_q=
ueue *q)
> >  		 * accept it.
> >  		 */
> >  		req =3D elv_next_request(q);
> > -		if (!req || !scsi_dev_queue_ready(q, sdev))
> > +		if (!req)
> > +			break;
> > +
> > +		if (!scsi_dev_queue_ready(q, sdev)) {
> > +			if (req->cmd_flags & REQ_FAILFAST) {
> > +				scsi_kill_request(req, q);
> > +				continue;
> > +			}
> >  			break;
> > +		}
> > =20
> >  		if (unlikely(!scsi_device_online(sdev))) {
> >  			sdev_printk(KERN_ERR, sdev,
> > @@ -1609,8 +1633,12 @@ static void scsi_request_fn(struct request_q=
ueue *q)
> >  	 * later time.
> >  	 */
> >  	spin_lock_irq(q->queue_lock);
> > -	blk_requeue_request(q, req);
> > -	sdev->device_busy--;
> > +	if (unlikely(req->cmd_flags & REQ_FAILFAST))
> > +		__scsi_kill_request(req);
> > +	else {
> > +		blk_requeue_request(q, req);
> > +		sdev->device_busy--;
> > +	}
> >  	if(sdev->device_busy =3D=3D 0)
> >  		blk_plug_device(q);
> >   out:
> Yeah, sorry. That patch was bad. Please use the attached one instead.
> Andrew, can you replace them?
>=20
> Cheers,
>=20
> Hannes
> --=20
> Dr. Hannes Reinecke		      zSeries & Storage
> hare@suse.de			      +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Markus Rex, HRB 16746 (AG N=FCrnberg)

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 13e7e09..9ec1566 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1284,13 +1284,15 @@ int scsi_prep_state_check(struct scsi_device =
*sdev, struct request *req)
>  			/*
>  			 * If the devices is blocked we defer normal commands.
>  			 */
> -			if (!(req->cmd_flags & REQ_PREEMPT))
> -				ret =3D BLKPREP_DEFER;
> -			/*
> -			 * Return failfast requests immediately
> -			 */
> -			if (req->cmd_flags & REQ_FAILFAST)
> -				ret =3D BLKPREP_KILL;
> +			if (!(req->cmd_flags & REQ_PREEMPT)) {
> +				/*
> +				 * Return failfast requests immediately
> +				 */
> +				if (req->cmd_flags & REQ_FAILFAST)
> +					ret =3D BLKPREP_KILL;
> +				else
> +					ret =3D BLKPREP_DEFER;
> +			}
>  			break;
>  		default:
>  			/*

can we please stick to using blk_noretry_request() consistently, instea=
d
of thwrowing REQ_FAILFAST tests in there?


--=20
Jens Axboe

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
