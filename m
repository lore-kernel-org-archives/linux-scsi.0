From: Ralph Wuerthner <ralphw@linux.vnet.ibm.com>
Subject: Re: [PATCH] fc transport: pre-emptively terminate i/o upon
 dev_loss_tmo
Date: Mon, 11 May 2009 14:25:28 +0200
Message-ID: <20090511142528.7965ae58@rwuerthntp>
References: <1240423291.27035.3.camel@ogier>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.29.155]:61913 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484AbZEKMZd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2009 08:25:33 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate6.de.ibm.com (8.14.3/8.13.8) with ESMTP id n4BCPUnH155648
	for <linux-scsi@vger.kernel.org>; Mon, 11 May 2009 12:25:30 GMT
Received: from d12av04.megacenter.de.ibm.com (d12av04.megacenter.de.ibm.com [9.149.165.229])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n4BCPU2g3641442
	for <linux-scsi@vger.kernel.org>; Mon, 11 May 2009 14:25:30 +0200
Received: from d12av04.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av04.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n4BCPUEV029864
	for <linux-scsi@vger.kernel.org>; Mon, 11 May 2009 14:25:30 +0200
In-Reply-To: <1240423291.27035.3.camel@ogier>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>

On Wed, 22 Apr 2009 14:01:31 -0400
James Smart <James.Smart@Emulex.Com> wrote:

> =EF=BB=BFMike, Ralph,
>=20
> See if this helps. It compiles, but I haven't tested it.
>=20
> This modifies the final deletion steps, after dev_loss_tmo has fired,
> such that we keep a flag indicating we're deleting, and we only clear
> the flag once the additional steps that we had to perform w/o lock,
> are complete.  Then, in fc_remote_port_add(), when we fall into the
> case of using the rports for the bindings, which corresponds to the
> "open" unlocked code area, we stall and wait for the delete to
> finish before completing the rest of the add.
> =EF=BB=BF
> I'm a little nervous about the delay in fc_remote_port_add, but it
> should be quick, and our callees should be in a context that it's
> allowed.
>=20
> -- james s
>=20
>=20
>  Signed-off-by: James Smart <james.smart@emulex.com>
>=20
>  ---
>=20
>  drivers/scsi/scsi_transport_fc.c |   66
> +++++++++++++++++++++++++++++++++++++--
>  include/scsi/scsi_transport_fc.h |    5 ++
>  2 files changed, 69 insertions(+), 2 deletions(-)
>=20
>=20
> diff -upNr a/drivers/scsi/scsi_transport_fc.c
> b/drivers/scsi/scsi_transport_fc.c
> --- a/drivers/scsi/scsi_transport_fc.c	2009-04-06
> 12:13:13.000000000 -0400
> +++ b/drivers/scsi/scsi_transport_fc.c	2009-04-22
> 13:44:22.000000000 -0400
> @@ -144,6 +144,7 @@ static struct {
>  	{ FC_PORTSTATE_ERROR,		"Error" },
>  	{ FC_PORTSTATE_LOOPBACK,	"Loopback" },
>  	{ FC_PORTSTATE_DELETED,		"Deleted" },
> +	{ FC_PORTSTATE_DELETING,	"Deleting" },
>  };
>  fc_enum_name_search(port_state, fc_port_state, fc_port_state_names)
>  #define FC_PORTSTATE_MAX_NAMELEN	20
> @@ -2347,9 +2348,28 @@ fc_starget_delete(struct work_struct *wo
>  {
>  	struct fc_rport *rport =3D
>  		container_of(work, struct fc_rport,
> stgt_delete_work);
> +	struct Scsi_Host *shost =3D rport_to_shost(rport);
> +	unsigned long flags;
>=20
>  	fc_terminate_rport_io(rport);
>  	scsi_remove_target(&rport->dev);
> +
> +	spin_lock_irqsave(shost->host_lock, flags);
> +
> +	rport->flags &=3D ~FC_RPORT_STGT_DEL_INPROG;
> +
> +	/*
> +	 * if the final transition to NOTPRESENT was waiting on our
> +	 * scsi teardown calls to finish, make the transition now.
> +	 */
> +	if (rport->flags & FC_RPORT_NOTPRESENT_NEEDED) {
> +		BUG_ON(rport->port_state !=3D FC_PORTSTATE_DELETING);
> +		rport->flags &=3D ~FC_RPORT_NOTPRESENT_NEEDED;
> +		rport->port_state =3D FC_PORTSTATE_NOTPRESENT;
> +		complete(&rport->deleting);
> +	}
> +
> +	spin_unlock_irqrestore(shost->host_lock, flags);
>  }
>=20
>=20
> @@ -2694,6 +2714,19 @@ fc_remote_port_add(struct Scsi_Host *sho
>  			}
>=20
>  			if (match) {
> +				if (rport->port_state =3D=3D
> FC_PORTSTATE_DELETING) {
> +					/*
> +					 * We need to stall until
> the delete
> +					 * steps are complete
> +					 */
> +
> spin_unlock_irqrestore(shost->host_lock,
> +
> flags);
> +
> wait_for_completion(&rport->deleting);
> +
> spin_lock_irqsave(shost->host_lock,
> +
> flags);
> +					BUG_ON(rport->port_state !=3D
> +
> FC_PORTSTATE_NOTPRESENT);
> +				}
>  				list_move_tail(&rport->peers,
> &fc_host->rports); break;
>  			}
> @@ -3007,7 +3040,8 @@ fc_timeout_deleted_rport(struct work_str
>  	rport->maxframe_size =3D -1;
>  	rport->supported_classes =3D FC_COS_UNSPECIFIED;
>  	rport->roles =3D FC_PORT_ROLE_UNKNOWN;
> -	rport->port_state =3D FC_PORTSTATE_NOTPRESENT;
> +	rport->port_state =3D FC_PORTSTATE_DELETING;
> +	init_completion(&rport->deleting);
>  	rport->flags &=3D ~FC_RPORT_FAST_FAIL_TIMEDOUT;
>  	rport->flags |=3D FC_RPORT_DEVLOSS_CALLBK_DONE;
>=20
> @@ -3019,7 +3053,8 @@ fc_timeout_deleted_rport(struct work_str
>  	spin_unlock_irqrestore(shost->host_lock, flags);
>  	fc_terminate_rport_io(rport);
>=20
> -	BUG_ON(rport->port_state !=3D FC_PORTSTATE_NOTPRESENT);
> +	spin_lock_irqsave(shost->host_lock, flags);
> +	BUG_ON(rport->port_state !=3D FC_PORTSTATE_DELETING);
>=20
>  	/* remove the identifiers that aren't used in the consisting
> binding */
>  	switch (fc_host->tgtid_bind_type) {
> @@ -3040,12 +3075,20 @@ fc_timeout_deleted_rport(struct work_str
>  	}
>=20
>  	/*
> +	 * Indicate we have an outstanding workq element to delete
> +	 * the starget
> +	 */
> +	rport->flags |=3D FC_RPORT_STGT_DEL_INPROG;
> +
> +	/*
>  	 * As this only occurs if the remote port (scsi target)
>  	 * went away and didn't come back - we'll remove
>  	 * all attached scsi devices.
>  	 */
>  	fc_queue_work(shost, &rport->stgt_delete_work);
>=20
> +	spin_unlock_irqrestore(shost->host_lock, flags);
> +
>  	/*
>  	 * Notify the driver that the rport is now dead. The LLDD
> will
>  	 * also guarantee that any communication to the rport is
> terminated @@ -3054,6 +3097,25 @@ fc_timeout_deleted_rport(struct
> work_str */
>  	if (i->f->dev_loss_tmo_callbk)
>  		i->f->dev_loss_tmo_callbk(rport);
> +
> +	spin_lock_irqsave(shost->host_lock, flags);
> +
> +	/*
> +	 * if the starget teardown is complete, we can do the
> +	 * DELETING->NOTPRESENT transition.
> +	 */
> +	if ( !(rport->flags & FC_RPORT_STGT_DEL_INPROG)) {
> +		rport->port_state =3D FC_PORTSTATE_NOTPRESENT;
> +		complete(&rport->deleting);
> +
> +	} else
> +		/*
> +		 * Otherwise, mark the rport so that starget teardown
> +		 * does the DELETING->NOTPRESENT transition.
> +		 */
> +		rport->flags |=3D FC_RPORT_NOTPRESENT_NEEDED;
> +
> +	spin_unlock_irqrestore(shost->host_lock, flags);
>  }
>=20
>=20
> diff -upNr a/include/scsi/scsi_transport_fc.h
> b/include/scsi/scsi_transport_fc.h
> --- a/include/scsi/scsi_transport_fc.h	2009-01-27
> 09:44:40.000000000 -0500
> +++ b/include/scsi/scsi_transport_fc.h	2009-04-22
> 13:22:04.000000000 -0400
> @@ -82,6 +82,7 @@ enum fc_port_state {
>  	FC_PORTSTATE_ERROR,
>  	FC_PORTSTATE_LOOPBACK,
>  	FC_PORTSTATE_DELETED,
> +	FC_PORTSTATE_DELETING,
>  };
>=20
>=20
> @@ -352,6 +353,7 @@ struct fc_rport {	/* aka fc_starget_attr
>   	struct delayed_work fail_io_work;
>   	struct work_struct stgt_delete_work;
>  	struct work_struct rport_delete_work;
> +	struct completion deleting;
>  } __attribute__((aligned(sizeof(unsigned long))));
>=20
>  /* bit field values for struct fc_rport "flags" field: */
> @@ -359,6 +361,8 @@ struct fc_rport {	/* aka fc_starget_attr
>  #define FC_RPORT_SCAN_PENDING		0x02
>  #define FC_RPORT_FAST_FAIL_TIMEDOUT	0x04
>  #define FC_RPORT_DEVLOSS_CALLBK_DONE	0x08
> +#define FC_RPORT_STGT_DEL_INPROG	0x10
> +#define FC_RPORT_NOTPRESENT_NEEDED	0x20
>=20
>  #define	dev_to_rport(d)				\
>  	container_of(d, struct fc_rport, dev)
> @@ -685,6 +689,7 @@ fc_remote_port_chkready(struct fc_rport=20
>  			result =3D DID_NO_CONNECT << 16;
>  		break;
>  	case FC_PORTSTATE_BLOCKED:
> +	case FC_PORTSTATE_DELETING:
>  		if (rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)
>  			result =3D DID_TRANSPORT_FAILFAST << 16;
>  		else
>=20
>=20

We tested this patch on our systems and at least it didn't break
anything. But we don't know for sure if we really hit the original
problem again since it is very timing sensitive. I'm proposing to
include this patch upstream.

--=20
Ralph Wuerthner
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
