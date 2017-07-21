From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v2 6/6] qla2xxx: Refactor usage of Active command arrays
Date: Fri, 21 Jul 2017 23:11:51 +0000
Message-ID: <1500678710.2545.8.camel@wdc.com>
References: <20170721163228.32339-1-himanshu.madhani@cavium.com>
         <20170721163228.32339-7-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:59250 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753111AbdGUXMp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Jul 2017 19:12:45 -0400
In-Reply-To: <20170721163228.32339-7-himanshu.madhani@cavium.com>
Content-Language: en-US
Content-ID: <CB26E420931BB74A97B12B58C709A512@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2017-07-21 at 09:32 -0700, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>

Thank you for having done this work!

> +#define SRB_TO_U(_p) container_of(_p, struct unify_cmd, srb)
> +#define TCMD_TO_U(_p) container_of(_p, struct unify_cmd, tcmd)

If you have to repost this patch, please change these macros into inline
functions such that the compiler can check the type of the argument (_p).

> @@ -2799,7 +2800,7 @@ qla2x00_alloc_outstanding_cmds(struct qla_hw_data *=
ha, struct req_que *req)
>                         req->num_outstanding_cmds =3D ha->cur_fw_iocb_cou=
nt;
>         }
> =20
> -       req->outstanding_cmds =3D kzalloc(sizeof(srb_t *) *
> +       req->outstanding_cmds =3D kzalloc(sizeof(struct unify_cmd *) *
>             req->num_outstanding_cmds, GFP_KERNEL);
> =20
>         if (!req->outstanding_cmds) {
> @@ -2808,7 +2809,7 @@ qla2x00_alloc_outstanding_cmds(struct qla_hw_data *=
ha, struct req_que *req)
>                  * initialization.
>                  */
>                 req->num_outstanding_cmds =3D MIN_OUTSTANDING_COMMANDS;
> -               req->outstanding_cmds =3D kzalloc(sizeof(srb_t *) *
> +               req->outstanding_cmds =3D kzalloc(sizeof(struct unify_cmd=
 *) *
>                     req->num_outstanding_cmds, GFP_KERNEL);
> =20
>                 if (!req->outstanding_cmds) {

Please use kcalloc() instead of kzalloc(... * ..., ...).

> @@ -2165,6 +2170,7 @@ qla25xx_process_bidir_status_iocb(scsi_qla_host_t *=
vha, void *pkt,
>  	struct fc_bsg_reply *bsg_reply;
>  	sts_entry_t *sts;
>  	struct sts_entry_24xx *sts24;
> +	struct unify_cmd *u;
>  	sts =3D (sts_entry_t *) pkt;
>  	sts24 =3D (struct sts_entry_24xx *) pkt;

Please leave a blank line between declarations and code.
=20
Anyway, whether or not these comments get addressed:

Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>=
