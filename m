From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 10/11] qla2xxx: Set relogin flag when we fail to queue
 login requests.
Date: Thu, 28 Jan 2016 10:01:56 +0100
Message-ID: <20160128090156.GO27565@c203.arch.suse.de>
References: <1453914218-380-1-git-send-email-himanshu.madhani@qlogic.com>
 <1453914218-380-11-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33752 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934456AbcA1JB6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Jan 2016 04:01:58 -0500
Content-Disposition: inline
In-Reply-To: <1453914218-380-11-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

On Wed, Jan 27, 2016 at 12:03:37PM -0500, Himanshu Madhani wrote:
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
> --=20
> 1.7.7
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
