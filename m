Return-Path: <SRS0=c2qj=BW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5377C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 19:45:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C38EF20774
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 19:45:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XaE8U4iV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbgHLTpA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Aug 2020 15:45:00 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48692 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbgHLTpA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2020 15:45:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07CJg2pN056246;
        Wed, 12 Aug 2020 19:44:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=3gziP2BEgfKPfMZhnqCPKLQG8wUsYnqlNQAbGUqZQG4=;
 b=XaE8U4iV5njmScoG9Set132i3IiEy3Rprp8b4OEcdC/kqWPLbRIYjdzsmwlGckzhlVZd
 KIkay48tzwgku+2qHjSIDmJFX9NQZBW5l9ARBzZoJHTjJAIz/zpHSunlap9fCUkCVDz9
 pfLx4FsWJAYJSbIW4kdD2e3GWMvXoBb2bSXN4npD06Zjn/93Hho+29sC8vevkOhaN/XQ
 P5ELNMeHS7zzzpmzwJVmHV6EubNapuWcg8f5ochEFwrp4fHdNx8T/BNiQF8vZfNN/W3B
 So+fcHr3+IyIlSVaasH06ts3xz0PV94W3+6zQ3wGWRLapp/QyVeIxMzb5f6viEK5sbe/ Ag== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 32t2ydu5st-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 12 Aug 2020 19:44:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07CJXN4a066252;
        Wed, 12 Aug 2020 19:42:56 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 32t5y7ph1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Aug 2020 19:42:56 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07CJgtR5032437;
        Wed, 12 Aug 2020 19:42:55 GMT
Received: from dhcp-10-154-152-217.vpn.oracle.com (/10.154.152.217)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 12 Aug 2020 19:42:55 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH v2 04/11] qla2xxx: fix login timeout
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20200806111014.28434-5-njavali@marvell.com>
Date:   Wed, 12 Aug 2020 14:42:54 -0500
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <531BD2EB-56B0-4022-99C9-EE97116F0492@oracle.com>
References: <20200806111014.28434-1-njavali@marvell.com>
 <20200806111014.28434-5-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9711 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=3 mlxscore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008120121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9711 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 impostorscore=0 lowpriorityscore=0 mlxscore=0 bulkscore=0
 suspectscore=3 phishscore=0 adultscore=0 spamscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008120122
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Aug 6, 2020, at 6:10 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> Multipath errors were seen during failback due to login timeout.
> The remote device sent LOGO, the local host teared down the session
> and did relogin. The RSCN arrived indicates remote device is going
> through failover after which the relogin is in a 20s timeout phase.
> At this point the driver is stuck in the relogin process.
> Add a fix to delete the session as part of abort/flush the login.
>=20
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_gs.c     | 19 ++++++++++++++++---
> drivers/scsi/qla2xxx/qla_target.c |  2 +-
> 2 files changed, 17 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_gs.c =
b/drivers/scsi/qla2xxx/qla_gs.c
> index 8c30d9dbb48c..2d7a47a2873b 100644
> --- a/drivers/scsi/qla2xxx/qla_gs.c
> +++ b/drivers/scsi/qla2xxx/qla_gs.c
> @@ -3536,10 +3536,23 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t =
*vha, srb_t *sp)
> 		}
>=20
> 		if (fcport->scan_state !=3D QLA_FCPORT_FOUND) {
> +			bool do_delete =3D false;
> +
> +			if (fcport->scan_needed &&
> +			    fcport->disc_state =3D=3D DSC_LOGIN_PEND) {
> +				/* his cable just got disconnected after =
we
> +				 * send him a login. Do delete to =
prevent
> +				 * timeout
> +				 */

Small nit.. the comment should describe who is =E2=80=9Chis=E2=80=9D in =
this case

> +				fcport->logout_on_delete =3D 1;
> +				do_delete =3D true;
> +			}
> +
> 			fcport->scan_needed =3D 0;
> -			if ((qla_dual_mode_enabled(vha) ||
> -				qla_ini_mode_enabled(vha)) &&
> -			    atomic_read(&fcport->state) =3D=3D =
FCS_ONLINE) {
> +			if (((qla_dual_mode_enabled(vha) ||
> +			      qla_ini_mode_enabled(vha)) &&
> +			    atomic_read(&fcport->state) =3D=3D =
FCS_ONLINE) ||
> +				do_delete) {
> 				if (fcport->loop_id !=3D FC_NO_LOOP_ID) =
{
> 					if (fcport->flags & =
FCF_FCP2_DEVICE)
> 						fcport->logout_on_delete =
=3D 0;
> diff --git a/drivers/scsi/qla2xxx/qla_target.c =
b/drivers/scsi/qla2xxx/qla_target.c
> index fbb80a043b4f..90289162dbd4 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -1270,7 +1270,7 @@ void qlt_schedule_sess_for_deletion(struct =
fc_port *sess)
>=20
> 	qla24xx_chk_fcp_state(sess);
>=20
> -	ql_dbg(ql_dbg_tgt, sess->vha, 0xe001,
> +	ql_dbg(ql_dbg_disc, sess->vha, 0xe001,
> 	    "Scheduling sess %p for deletion %8phC\n",
> 	    sess, sess->port_name);
>=20
> --=20
> 2.19.0.rc0
>=20

Other than small nit.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

