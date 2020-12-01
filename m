Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3103C64E7A
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 15:49:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 235D3208FE
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 15:49:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ojeQ0NTr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391954AbgLAPtU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 10:49:20 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45354 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391948AbgLAPtT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 10:49:19 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1FYv7I135260;
        Tue, 1 Dec 2020 15:48:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=k4Gv7oGMals0cf7EHk+YtC0pw5uVxlBbQtJ1QtWFvIY=;
 b=ojeQ0NTrc8pwf9w+Wir0D6VAtOsJoKRnetcTm05EhGWL2i7Q79e3D1E3NbJIfCLHx8O4
 l0wyrSzReolZjs5lklIDVdOIh1Mooea8ce0KYgmmYLuxIUtHVCYrLwQp2yaZW0cD0gFp
 DnYyAcWAILX0rOGo0SOVOWrHs4Nav5efTmfdkdcYDGPl1RyEtR56fVvkHK7DEi8vlwkr
 MrOry3LireZ7NdkRC5GjeiypSphNxMZYadwVuv2/gC32vL3VPlxlCB+T83VTlmRbnE9c
 Ycn87DNXpB8dVM22+YwkRenH6jo3jrnCBbB1U34o58W0CMpBMXaBcFLMstAFGMG69hxI VQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 353egkk76d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 15:48:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1FUFrh113311;
        Tue, 1 Dec 2020 15:48:36 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 3540ashtb0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 15:48:36 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B1FmZ3b025804;
        Tue, 1 Dec 2020 15:48:35 GMT
Received: from [192.168.1.15] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 07:48:35 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH 04/15] qla2xxx: tear down session if FW say its down
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20201201082730.24158-5-njavali@marvell.com>
Date:   Tue, 1 Dec 2020 09:48:35 -0600
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <66CBC4DB-AFAA-404D-AC50-FDBF7D1EE310@oracle.com>
References: <20201201082730.24158-1-njavali@marvell.com>
 <20201201082730.24158-5-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010099
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010099
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 1, 2020, at 2:27 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> The completion status 0x28 (ppc =3D be =3D 0x2800) below indicate =
session
> is not there, trigger session deletion.
>=20
> qla2xxx [000b:04:00.1]-8009:8: DEVICE RESET ISSUED nexus=3D8:1:51 =
cmd=3Dc000001432d0f600.
> qla2xxx [000b:04:00.1]-5039:8: Async-tmf error - hdl=3D67b completion =
status(2800).
> qla2xxx [000b:04:00.1]-8030:8: TM IOCB failed (102).
> qla2xxx [000b:04:00.1]-800c:8: do_reset failed for =
cmd=3Dc000001432d0f600.
> qla2xxx [000b:04:00.1]-800f:8: DEVICE RESET FAILED: Task management =
failed nexus=3D8:1:51 cmd=3Dc000001432d0f600.
> qla2xxx [000b:04:00.1]-8009:8: DEVICE RESET ISSUED nexus=3D8:1:52 =
cmd=3Dc000001432d0c200.
> qla2xxx [000b:04:00.1]-5039:8: Async-tmf error - hdl=3D67c completion =
status(2800).
> qla2xxx [000b:04:00.1]-8030:8: TM IOCB failed (102).
>=20
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_isr.c | 28 +++++++++++++++++++++++++++-
> 1 file changed, 27 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c =
b/drivers/scsi/qla2xxx/qla_isr.c
> index 77dd7630c3f8..f9142dbec112 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -2226,11 +2226,13 @@ qla24xx_tm_iocb_entry(scsi_qla_host_t *vha, =
struct req_que *req, void *tsk)
> 	srb_t *sp;
> 	struct srb_iocb *iocb;
> 	struct sts_entry_24xx *sts =3D (struct sts_entry_24xx *)tsk;
> +	u16 comp_status;
>=20
> 	sp =3D qla2x00_get_sp_from_handle(vha, func, req, tsk);
> 	if (!sp)
> 		return;
>=20
> +	comp_status =3D le16_to_cpu(sts->comp_status);
> 	iocb =3D &sp->u.iocb_cmd;
> 	type =3D sp->name;
> 	fcport =3D sp->fcport;
> @@ -2244,7 +2246,7 @@ qla24xx_tm_iocb_entry(scsi_qla_host_t *vha, =
struct req_que *req, void *tsk)
> 	} else if (sts->comp_status !=3D cpu_to_le16(CS_COMPLETE)) {
> 		ql_log(ql_log_warn, fcport->vha, 0x5039,
> 		    "Async-%s error - hdl=3D%x completion =
status(%x).\n",
> -		    type, sp->handle, sts->comp_status);
> +		    type, sp->handle, comp_status);
> 		iocb->u.tmf.data =3D QLA_FUNCTION_FAILED;
> 	} else if ((le16_to_cpu(sts->scsi_status) &
> 	    SS_RESPONSE_INFO_LEN_VALID)) {
> @@ -2260,6 +2262,30 @@ qla24xx_tm_iocb_entry(scsi_qla_host_t *vha, =
struct req_que *req, void *tsk)
> 		}
> 	}
>=20
> +	switch (comp_status) {
> +	case CS_PORT_LOGGED_OUT:
> +	case CS_PORT_CONFIG_CHG:
> +	case CS_PORT_BUSY:
> +	case CS_INCOMPLETE:
> +	case CS_PORT_UNAVAILABLE:
> +	case CS_TIMEOUT:
> +	case CS_RESET:
> +		if (atomic_read(&fcport->state) =3D=3D FCS_ONLINE) {
> +			ql_dbg(ql_dbg_disc, fcport->vha, 0x3021,
> +			       "-Port to be marked lost on =
fcport=3D%02x%02x%02x, current port state=3D %s comp_status %x.\n",
> +			       fcport->d_id.b.domain, =
fcport->d_id.b.area,
> +			       fcport->d_id.b.al_pa,
> +			       port_state_str[FCS_ONLINE],
> +			       comp_status);
> +
> +			qlt_schedule_sess_for_deletion(fcport);
> +		}
> +		break;
> +
> +	default:
> +		break;
> +	}
> +
> 	if (iocb->u.tmf.data !=3D QLA_SUCCESS)
> 		ql_dump_buffer(ql_dbg_async + ql_dbg_buffer, sp->vha, =
0x5055,
> 		    sts, sizeof(*sts));
> --=20
> 2.19.0.rc0
>=20

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

