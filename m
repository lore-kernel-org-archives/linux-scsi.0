From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 10/11] qla2xxx: Set relogin flag when we fail to queue
 login requests.
Date: Wed, 27 Jan 2016 09:48:15 +0100
Message-ID: <56A8844F.1030601@suse.de>
References: <1453828246-28686-1-git-send-email-himanshu.madhani@qlogic.com>
 <1453828246-28686-11-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60796 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754009AbcA0IsQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jan 2016 03:48:16 -0500
In-Reply-To: <1453828246-28686-11-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, jbottomley@parallels.com, martin.petersen@oracle.com
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

On 01/26/2016 06:10 PM, Himanshu Madhani wrote:
> From: Chad Dupuis <chad.dupuis@qlogic.com>
>=20
> If we fail to queue an srb for an async login we should set the
> relogin flag so it will be retried as the reason for the queuing
> failure was most likely transient.  Failure to do this can lead to
> failed paths as login is never retried if the relogin flag is not
> set.
>=20
> Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_init.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/q=
la_init.c
> index 8001c89..184b6b6 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -157,8 +157,12 @@ qla2x00_async_login(struct scsi_qla_host *vha, f=
c_port_t *fcport,
>  	if (data[1] & QLA_LOGIO_LOGIN_RETRIED)
>  		lio->u.logio.flags |=3D SRB_LOGIN_RETRIED;
>  	rval =3D qla2x00_start_sp(sp);
> -	if (rval !=3D QLA_SUCCESS)
> +	if (rval !=3D QLA_SUCCESS) {
> +		fcport->flags &=3D ~FCF_ASYNC_SENT;
> +		fcport->flags |=3D FCF_LOGIN_NEEDED;
> +		set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
>  		goto done_free_sp;
> +	}
> =20
>  	ql_dbg(ql_dbg_disc, vha, 0x2072,
>  	    "Async-login - hdl=3D%x, loopid=3D%x portid=3D%02x%02x%02x "
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
