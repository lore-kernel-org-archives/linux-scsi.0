Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9222C71156
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 16:17:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A1A52224B
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 16:17:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="uj058qdG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392091AbgLAQQx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 11:16:53 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:44948 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390874AbgLAQQw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 11:16:52 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1G52Nu005453;
        Tue, 1 Dec 2020 16:16:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=h2KWeEBHgIUdUqYOKSIrtLybXvb5JLif7dP2O35lRyc=;
 b=uj058qdG/ZFMzXTYuXjcDl7LdwdqRY6tGBw8lq8Ett+i3+EjZnmRFZo3LlYVFoh4izXN
 FzUfTMYshsG/0XuBsW8+Ve81QQV8kyE/hZ2YeBSZmFqbv47RXq/Ij20YAxYO5mPpjV+C
 WndoXFD0wGSBuZSfFwIWvx1Ut0j3GC3APAhRay4CHTofSJkG6B+neBYhVZHSHYDkY2Tb
 5UKe7YlZoS08/4BkDtbLTAkVljaJk7MpMooIddrzzH7cGqpN4oQu94tKlU6IC9ur5nNo
 Hu8N4dzW94bVOh7n545H/jZHZx/41hJEJNV9SxekXyVAMKnClKSV/hQwilJi9BZs6W6k Pw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 353egkkcx0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 16:16:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1G656s042669;
        Tue, 1 Dec 2020 16:16:09 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 3540ey65eg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 16:16:09 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B1GG8h5013157;
        Tue, 1 Dec 2020 16:16:08 GMT
Received: from [192.168.1.15] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 08:16:08 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH 09/15] qla2xxx: fix N2N and NVME connect retry failure
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20201201082730.24158-10-njavali@marvell.com>
Date:   Tue, 1 Dec 2020 10:16:07 -0600
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <F81FDFFE-F060-4B82-A191-8D16EDC3EA9B@oracle.com>
References: <20201201082730.24158-1-njavali@marvell.com>
 <20201201082730.24158-10-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010101
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010101
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 1, 2020, at 2:27 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> FC-NVMe target discovery failed when initiator wwpn < target wwpn in =
an
> N2N (Direct Attach) config, where the driver was stuck on FCP PRLI
> mode and failed to retry with NVME PRLI.
>=20
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>

Missing Fixes tag=20

Fixes: 84ed362ac40ca ("scsi: qla2xxx: Dual FCP-NVMe target port =
support=E2=80=9D)
Fixes: 983f127603fac ("scsi: qla2xxx: Retry PLOGI on FC-NVMe PRLI =
failure=E2=80=9D)

> ---
> drivers/scsi/qla2xxx/qla_init.c | 71 ++++++++++++++++++++++++---------
> drivers/scsi/qla2xxx/qla_mbx.c  |  3 --
> 2 files changed, 52 insertions(+), 22 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_init.c =
b/drivers/scsi/qla2xxx/qla_init.c
> index 5626e9b6949f..12e3b05baf41 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -1268,9 +1268,10 @@ qla24xx_async_prli(struct scsi_qla_host *vha, =
fc_port_t *fcport)
> 		lio->u.logio.flags |=3D SRB_LOGIN_NVME_PRLI;
>=20
> 	ql_dbg(ql_dbg_disc, vha, 0x211b,
> -	    "Async-prli - %8phC hdl=3D%x, loopid=3D%x portid=3D%06x =
retries=3D%d %s.\n",
> +	    "Async-prli - %8phC hdl=3D%x, loopid=3D%x portid=3D%06x =
retries=3D%d fc4type %x priority %x %s.\n",
> 	    fcport->port_name, sp->handle, fcport->loop_id, =
fcport->d_id.b24,
> -	    fcport->login_retry, NVME_TARGET(vha->hw, fcport) ? "nvme" : =
"fc");
> +	    fcport->login_retry, fcport->fc4_type, =
vha->hw->fc4_type_priority,
> +	    NVME_TARGET(vha->hw, fcport) ? "nvme" : "fcp");
>=20
> 	rval =3D qla2x00_start_sp(sp);
> 	if (rval !=3D QLA_SUCCESS) {
> @@ -1932,26 +1933,58 @@ qla24xx_handle_prli_done_event(struct =
scsi_qla_host *vha, struct event_arg *ea)
> 			break;
> 		}
>=20
> -		/*
> -		 * Retry PRLI with other FC-4 type if failure occurred =
on dual
> -		 * FCP/NVMe port
> -		 */
> -		if (NVME_FCP_TARGET(ea->fcport)) {
> -			ql_dbg(ql_dbg_disc, vha, 0x2118,
> -				"%s %d %8phC post %s prli\n",
> -				__func__, __LINE__, =
ea->fcport->port_name,
> -				(ea->fcport->fc4_type & FS_FC4TYPE_NVME) =
?
> -				"NVMe" : "FCP");
> -			if (vha->hw->fc4_type_priority =3D=3D =
FC4_PRIORITY_NVME)
> +		ql_dbg(ql_dbg_disc, vha, 0x2118,
> +		       "%s %d %8phC priority %s, fc4type %x\n",
> +		       __func__, __LINE__, ea->fcport->port_name,
> +		       vha->hw->fc4_type_priority =3D=3D =
FC4_PRIORITY_FCP ?
> +		       "FCP" : "NVMe", ea->fcport->fc4_type);
> +
> +		if (N2N_TOPO(vha->hw)) {
> +			if (vha->hw->fc4_type_priority =3D=3D =
FC4_PRIORITY_NVME) {
> 				ea->fcport->fc4_type &=3D =
~FS_FC4TYPE_NVME;
> -			else
> +				ea->fcport->fc4_type |=3D =
FS_FC4TYPE_FCP;
> +			} else {
> 				ea->fcport->fc4_type &=3D =
~FS_FC4TYPE_FCP;
> -		}
> +				ea->fcport->fc4_type |=3D =
FS_FC4TYPE_NVME;
> +			}
>=20
> -		ea->fcport->flags &=3D ~FCF_ASYNC_SENT;
> -		ea->fcport->keep_nport_handle =3D 0;
> -		ea->fcport->logout_on_delete =3D 1;
> -		qlt_schedule_sess_for_deletion(ea->fcport);
> +			if (ea->fcport->n2n_link_reset_cnt < 3) {
> +				ea->fcport->n2n_link_reset_cnt++;
> +				vha->relogin_jif =3D jiffies + 2 * HZ;
> +				/*
> +				 * PRLI failed. Reset link to kick start
> +				 * state machine
> +				 */
> +				set_bit(N2N_LINK_RESET, =
&vha->dpc_flags);
> +			} else {
> +				ql_log(ql_log_warn, vha, 0x2119,
> +				       "%s %d %8phC Unable to =
reconnect\n",
> +				       __func__, __LINE__,
> +				       ea->fcport->port_name);
> +			}
> +		} else {
> +			/*
> +			 * switch connect. login failed. Take connection =
down
> +			 * and allow relogin to retrigger
> +			 */
> +			if (NVME_FCP_TARGET(ea->fcport)) {
> +				ql_dbg(ql_dbg_disc, vha, 0x2118,
> +				       "%s %d %8phC post %s prli\n",
> +				       __func__, __LINE__,
> +				       ea->fcport->port_name,
> +				       (ea->fcport->fc4_type & =
FS_FC4TYPE_NVME)
> +				       ? "NVMe" : "FCP");
> +				if (vha->hw->fc4_type_priority =3D=3D =
FC4_PRIORITY_NVME)
> +					ea->fcport->fc4_type &=3D =
~FS_FC4TYPE_NVME;
> +				else
> +					ea->fcport->fc4_type &=3D =
~FS_FC4TYPE_FCP;
> +			}
> +
> +			ea->fcport->flags &=3D ~FCF_ASYNC_SENT;
> +			ea->fcport->keep_nport_handle =3D 0;
> +			ea->fcport->logout_on_delete =3D 1;
> +			qlt_schedule_sess_for_deletion(ea->fcport);
> +		}
> 		break;
> 	}
> }
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c =
b/drivers/scsi/qla2xxx/qla_mbx.c
> index 1b4261c3c476..d7d4ab65009c 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -3998,9 +3998,6 @@ qla24xx_report_id_acquisition(scsi_qla_host_t =
*vha,
> 				fcport->scan_state =3D QLA_FCPORT_FOUND;
> 				fcport->n2n_flag =3D 1;
> 				fcport->keep_nport_handle =3D 1;
> -				fcport->fc4_type =3D FS_FC4TYPE_FCP;
> -				if (vha->flags.nvme_enabled)
> -					fcport->fc4_type |=3D =
FS_FC4TYPE_NVME;
>=20
> 				if (wwn_to_u64(vha->port_name) >
> 				    wwn_to_u64(fcport->port_name)) {
> --=20
> 2.19.0.rc0
>=20

--
Himanshu Madhani	 Oracle Linux Engineering

