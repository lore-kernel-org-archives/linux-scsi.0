From: Johannes Thumshirn <jthumshirn@suse.com>
Subject: Re: [PATCH 1/1] we added changes in fnic driver patch 1.6.0.16 to acquire io_req_lock in fnic_queuecommand() before issuing I/O so that io completion is serialized. But when releasing the lock we check for the I/O flags and this could be modified if IO abort occurs before I/O completion. In this case we wont release the lock and causes deadlock in some scenerios. Using the local variable to check the IO lock status will resolve the problem.
Date: Fri, 03 Jul 2015 09:14:10 +0200
Message-ID: <mqd4mllaf25.fsf@c203.arch.suse.de>
References: <1435872835-30656-1-git-send-email-hishah@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38892 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974AbbGCHON convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2015 03:14:13 -0400
In-Reply-To: <1435872835-30656-1-git-send-email-hishah@cisco.com> (Hiral
	Shah's message of "Thu, 2 Jul 2015 14:33:55 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hiral Shah <hishah@cisco.com>
Cc: linux-scsi@vger.kernel.org, Sesidhar Baddela <sebaddel@cisco.com>, Anil Chintalapati <achintal@cisco.com>

Hiral Shah <hishah@cisco.com> writes:

> Signed-off-by: Hiral Shah <hishah@cisco.com>
> Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
> Signed-off-by: Anil Chintalapati <achintal@cisco.com>
> ---
>  drivers/scsi/fnic/fnic.h      | 2 +-
>  drivers/scsi/fnic/fnic_scsi.c | 4 +++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
> index 26270c3..ce129e5 100644
> --- a/drivers/scsi/fnic/fnic.h
> +++ b/drivers/scsi/fnic/fnic.h
> @@ -39,7 +39,7 @@
> =20
>  #define DRV_NAME		"fnic"
>  #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
> -#define DRV_VERSION		"1.6.0.17"
> +#define DRV_VERSION		"1.6.0.17a"
>  #define PFX			DRV_NAME ": "
>  #define DFX                     DRV_NAME "%d: "
> =20
> diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_s=
csi.c
> index 155b286..25436cd 100644
> --- a/drivers/scsi/fnic/fnic_scsi.c
> +++ b/drivers/scsi/fnic/fnic_scsi.c
> @@ -425,6 +425,7 @@ static int fnic_queuecommand_lck(struct scsi_cmnd=
 *sc, void (*done)(struct scsi_
>  	unsigned long ptr;
>  	struct fc_rport_priv *rdata;
>  	spinlock_t *io_lock =3D NULL;
> +	int io_lock_acquired =3D 0;
> =20
>  	if (unlikely(fnic_chk_state_flags_locked(fnic, FNIC_FLAGS_IO_BLOCKE=
D)))
>  		return SCSI_MLQUEUE_HOST_BUSY;
> @@ -518,6 +519,7 @@ static int fnic_queuecommand_lck(struct scsi_cmnd=
 *sc, void (*done)(struct scsi_
>  	spin_lock_irqsave(io_lock, flags);
> =20
>  	/* initialize rest of io_req */
> +	io_lock_acquired =3D 1;
>  	io_req->port_id =3D rport->port_id;
>  	io_req->start_time =3D jiffies;
>  	CMD_STATE(sc) =3D FNIC_IOREQ_CMD_PENDING;
> @@ -571,7 +573,7 @@ out:
>  		  (((u64)CMD_FLAGS(sc) >> 32) | CMD_STATE(sc)));
> =20
>  	/* if only we issued IO, will we have the io lock */
> -	if (CMD_FLAGS(sc) & FNIC_IO_INITIALIZED)
> +	if (io_lock_acquired)
>  		spin_unlock_irqrestore(io_lock, flags);

Can't you just use
if (spin_is_locked(io_lock))
   spin_unlock_irqrestore(io_lock, flags);


> =20
>  	atomic_dec(&fnic->in_flight);

Johannes

--=20
Johannes Thumshirn                                       Storage
jthumshirn@suse.de                             +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
