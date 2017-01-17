From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2 08/12] qla2xxx: Add framework for Async fabric
 discovery.
Date: Tue, 17 Jan 2017 22:12:16 +0000
Message-ID: <1484691121.2729.13.camel@sandisk.com>
References: <1484598924-29066-1-git-send-email-himanshu.madhani@cavium.com>
         <1484598924-29066-9-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0079.outbound.protection.outlook.com ([104.47.32.79]:24160
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751015AbdAQWMv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Jan 2017 17:12:51 -0500
In-Reply-To: <1484598924-29066-9-git-send-email-himanshu.madhani@cavium.com>
Content-Language: en-US
Content-ID: <27507B381778094FAF7B015A901BF6E9@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "bart.vanassche@gmail.com" <bart.vanassche@gmail.com>, "hch@infradead.org" <hch@infradead.org>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "giridhar.malavali@cavium.com" <giridhar.malavali@cavium.com>

On Mon, 2017-01-16 at 12:35 -0800, Himanshu Madhani wrote:
> -static void
> +void
>  qla2x00_async_iocb_timeout(void *data)
>  {
>  	srb_t *sp =3D (srb_t *)data;
>  	fc_port_t *fcport =3D sp->fcport;
> +	struct srb_iocb *lio =3D &sp->u.iocb_cmd;
> +	struct event_arg ea;
> =20
>  	ql_dbg(ql_dbg_disc, fcport->vha, 0x2071,
> -	    "Async-%s timeout - hdl=3D%x portid=3D%02x%02x%02x.\n",
> +	    "Async-%s timeout - hdl=3D%x portid=3D%02x%02x%02x %8phC.\n",
>  	    sp->name, sp->handle, fcport->d_id.b.domain, fcport->d_id.b.area,
> -	    fcport->d_id.b.al_pa);
> +		fcport->d_id.b.al_pa, fcport->port_name);
> =20
> -	fcport->flags &=3D ~FCF_ASYNC_SENT;
> -	if (sp->type =3D=3D SRB_LOGIN_CMD) {
> -		struct srb_iocb *lio =3D &sp->u.iocb_cmd;
> -		qla2x00_post_async_logout_work(fcport->vha, fcport, NULL);
> +	if (fcport)
> +		fcport->flags &=3D ~FCF_ASYNC_SENT;

This code triggers a new static checker warning because the fcport pointer
is dereferenced before it is used. Please review the code.

Thanks,

Bart.=
