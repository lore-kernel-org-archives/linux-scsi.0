Return-Path: <SRS0=c2qj=BW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5869C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 19:42:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C175206DA
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 19:42:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O/le0zD/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgHLTmi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Aug 2020 15:42:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47076 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbgHLTmi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2020 15:42:38 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07CJg9so056339;
        Wed, 12 Aug 2020 19:42:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=0+ZjJ2J9/XHmvzDgmrOp042IGa+oZrpmvo0ST0uasLU=;
 b=O/le0zD/BzHnRH+U5oRnJV0j0x2fv8u6dDnDLwUDclhfHAVxk4AkNET1Qvz8QSobxPMX
 xsuSUNhsAyX4amLG0hIMVEfwTa8KFhKOzbQINC8ewqr837ChtrE7Co/49RY5fzgnLO1Y
 w3J7EWZAPGTXCFEM/URoH410oIgBTf4DPFBaWsU8S4v9zFILek0eh7W7sUfWE05IDfqO
 Ni/8kMuSj/H18WkN59zd0I9mZW6h4zRcvht1QzX/VaPYb5PWvWFyyjtDfCxyQyWdqzoB
 Uw8DkYzUcYvs1/dGjo0O0NH5l/9dpECArBujoTpqWB3n5AWfrd3CfgbbrmJuIIoxThnJ lA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 32t2ydu5g0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 12 Aug 2020 19:42:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07CJWWed110259;
        Wed, 12 Aug 2020 19:40:35 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 32t6024xew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Aug 2020 19:40:35 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07CJeYfk012495;
        Wed, 12 Aug 2020 19:40:34 GMT
Received: from dhcp-10-154-152-217.vpn.oracle.com (/10.154.152.217)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 12 Aug 2020 19:40:34 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH v2 03/11] qla2xxx: Indicate correct supported speeds for
 Mezz card
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20200806111014.28434-4-njavali@marvell.com>
Date:   Wed, 12 Aug 2020 14:40:33 -0500
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <52C01BE2-4F18-4399-A1C4-8FADDCA84EA7@oracle.com>
References: <20200806111014.28434-1-njavali@marvell.com>
 <20200806111014.28434-4-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9711 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 adultscore=0 spamscore=0 suspectscore=3 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008120121
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
> Correct the supported speeds for 16G Mezz card.
>=20
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_gs.c | 17 ++++++++++++-----
> 1 file changed, 12 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_gs.c =
b/drivers/scsi/qla2xxx/qla_gs.c
> index d9ce8d31457a..8c30d9dbb48c 100644
> --- a/drivers/scsi/qla2xxx/qla_gs.c
> +++ b/drivers/scsi/qla2xxx/qla_gs.c
> @@ -1505,11 +1505,11 @@ qla2x00_prep_ct_fdmi_req(struct ct_sns_pkt *p, =
uint16_t cmd,
> static uint
> qla25xx_fdmi_port_speed_capability(struct qla_hw_data *ha)
> {
> +	uint speeds =3D 0;
> +
> 	if (IS_CNA_CAPABLE(ha))
> 		return FDMI_PORT_SPEED_10GB;
> 	if (IS_QLA28XX(ha) || IS_QLA27XX(ha)) {
> -		uint speeds =3D 0;
> -
> 		if (ha->max_supported_speed =3D=3D 2) {
> 			if (ha->min_supported_speed <=3D 6)
> 				speeds |=3D FDMI_PORT_SPEED_64GB;
> @@ -1536,9 +1536,16 @@ qla25xx_fdmi_port_speed_capability(struct =
qla_hw_data *ha)
> 		}
> 		return speeds;
> 	}
> -	if (IS_QLA2031(ha))
> -		return FDMI_PORT_SPEED_16GB|FDMI_PORT_SPEED_8GB|
> -			FDMI_PORT_SPEED_4GB;
> +	if (IS_QLA2031(ha)) {
> +		if ((ha->pdev->subsystem_vendor =3D=3D 0x103C) &&
> +		    (ha->pdev->subsystem_device =3D=3D 0x8002)) {
> +			speeds =3D FDMI_PORT_SPEED_16GB;
> +		} else {
> +			speeds =3D =
FDMI_PORT_SPEED_16GB|FDMI_PORT_SPEED_8GB|
> +				FDMI_PORT_SPEED_4GB;
> +		}
> +		return speeds;
> +	}
> 	if (IS_QLA25XX(ha))
> 		return FDMI_PORT_SPEED_8GB|FDMI_PORT_SPEED_4GB|
> 			FDMI_PORT_SPEED_2GB|FDMI_PORT_SPEED_1GB;
> --=20
> 2.19.0.rc0
>=20

Looks fine.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

