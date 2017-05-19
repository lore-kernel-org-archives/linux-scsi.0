From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 15/25] qla2xxx: Convert 32-bit LUN usage to 64-bit
Date: Fri, 19 May 2017 23:19:11 +0000
Message-ID: <1495235950.2581.13.camel@sandisk.com>
References: <20170519215344.2168-1-himanshu.madhani@cavium.com>
         <20170519215344.2168-16-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:24410 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754139AbdESXTO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 May 2017 19:19:14 -0400
In-Reply-To: <20170519215344.2168-16-himanshu.madhani@cavium.com>
Content-Language: en-US
Content-ID: <A3876A13B605AE458B3594391EFD1163@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2017-05-19 at 14:53 -0700, Himanshu Madhani wrote:
> @@ -1851,17 +1851,13 @@ static int __qlt_24xx_handle_abts(struct scsi_qla=
_host *vha,
>  	struct se_session *se_sess =3D sess->se_sess;
>  	struct qla_tgt_mgmt_cmd *mcmd;
>  	struct se_cmd *se_cmd;
> -	u32 lun =3D 0;
>  	int rc;
>  	bool found_lun =3D false;
>  	unsigned long flags;
> =20
>  	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
>  	list_for_each_entry(se_cmd, &se_sess->sess_cmd_list, se_cmd_list) {
> -		struct qla_tgt_cmd *cmd =3D
> -			container_of(se_cmd, struct qla_tgt_cmd, se_cmd);
>  		if (se_cmd->tag =3D=3D abts->exchange_addr_to_abort) {
> -			lun =3D cmd->unpacked_lun;
>  			found_lun =3D true;
>  			break;
>  		}
> @@ -1900,7 +1896,7 @@ static int __qlt_24xx_handle_abts(struct scsi_qla_h=
ost *vha,
>  	mcmd->reset_count =3D vha->hw->chip_reset;
>  	mcmd->tmr_func =3D QLA_TGT_ABTS;
> =20
> -	rc =3D ha->tgt.tgt_ops->handle_tmr(mcmd, lun, mcmd->tmr_func,
> +	rc =3D ha->tgt.tgt_ops->handle_tmr(mcmd, 0, mcmd->tmr_func,
>  	    abts->exchange_addr_to_abort);
>  	if (rc !=3D 0) {
>  		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf052,

Hello Himanshu and Quinn,

A LIO target driver should not make any assumptions about whether or not LU=
N 0
exists. Please modify this patch such that the LUN through which the task
management function was received is passed to the LIO core instead of passi=
ng 0.

Bart.=
