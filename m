From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH v1 3/3] Using rport->dd_data to check rport online
 instead of rport_lookup.
Date: Tue, 29 Mar 2016 10:06:46 -0400
Message-ID: <1459260406.30035.3.camel@localhost.localdomain>
References: <1458325370-25615-1-git-send-email-satishkh@cisco.com>
	 <1458325370-25615-3-git-send-email-satishkh@cisco.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbcC2OGs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Mar 2016 10:06:48 -0400
In-Reply-To: <1458325370-25615-3-git-send-email-satishkh@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Satish Kharat <satishkh@cisco.com>
Cc: linux-scsi@vger.kernel.org, Sesidhar Baddela <sebaddel@cisco.com>

On Fri, 2016-03-18 at 11:22 -0700, Satish Kharat wrote:
> When issuing I/O we check if rport is online through libfc
> rport_lookup() function which needs to be protected by mutex lock
> that cannot acquired in I/O context. The change is to use midlayer
> remote port=E2=80=99s dd_data which is preserved until its devloss ti=
meout
> and no protection is required.
> The the scsi_cmnd error code is expected to be in the left 16 bits
> of the result field. Changed to correct this.
> Fnic driver version changed from 1.6.0.20 to 1.6.0.21
>=20
> Signed-off-by: Satish Kharat <satishkh@cisco.com>
> Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
> ---
>  * v1
>  - DID_NO_CONNECT left shifted 16 bits before assigning to sc->result
> ---
>  drivers/scsi/fnic/fnic.h      |  2 +-
>  drivers/scsi/fnic/fnic_scsi.c | 20 +++++++++++---------
>  2 files changed, 12 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
> index 1023eae..9ddc920 100644
> --- a/drivers/scsi/fnic/fnic.h
> +++ b/drivers/scsi/fnic/fnic.h
> @@ -39,7 +39,7 @@
> =20
>  #define DRV_NAME		"fnic"
>  #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
> -#define DRV_VERSION		"1.6.0.20"
> +#define DRV_VERSION		"1.6.0.21"
>  #define PFX			DRV_NAME ": "
>  #define DFX                     DRV_NAME "%d: "
> =20
> diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_s=
csi.c
> index 026b93d..0e874a5 100644
> --- a/drivers/scsi/fnic/fnic_scsi.c
> +++ b/drivers/scsi/fnic/fnic_scsi.c
> @@ -439,7 +439,6 @@ static int fnic_queuecommand_lck(struct scsi_cmnd=
 *sc, void (*done)(struct scsi_
>  	int sg_count =3D 0;
>  	unsigned long flags =3D 0;
>  	unsigned long ptr;
> -	struct fc_rport_priv *rdata;
>  	spinlock_t *io_lock =3D NULL;
>  	int io_lock_acquired =3D 0;
> =20
> @@ -455,14 +454,17 @@ static int fnic_queuecommand_lck(struct scsi_cm=
nd *sc, void (*done)(struct scsi_
>  		return 0;
>  	}
> =20
> -	rdata =3D lp->tt.rport_lookup(lp, rport->port_id);
> -	if (!rdata || (rdata->rp_state =3D=3D RPORT_ST_DELETE)) {
> -		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -			"returning IO as rport is removed\n");
> -		atomic64_inc(&fnic_stats->misc_stats.rport_not_ready);
> -		sc->result =3D DID_NO_CONNECT;
> -		done(sc);
> -		return 0;
> +	if (rport) {
> +		struct fc_rport_libfc_priv *rp =3D rport->dd_data;
> +
> +		if (!rp || rp->rp_state !=3D RPORT_ST_READY) {
> +			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> +				"returning DID_NO_CONNECT for IO as rport is removed\n");
> +			atomic64_inc(&fnic_stats->misc_stats.rport_not_ready);
> +			sc->result =3D DID_NO_CONNECT<<16;
> +			done(sc);
> +			return 0;
> +		}
>  	}
> =20
>  	if (lp->state !=3D LPORT_ST_READY || !(lp->link_up))

=46or v1:

Reviewed-by: Ewan D. Milne <emilne@redhat.com>



--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
