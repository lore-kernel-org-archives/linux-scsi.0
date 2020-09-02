Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB394C43461
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 15:40:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A461120829
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 15:40:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hFQ0Wjp1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgIBPkV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 11:40:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37184 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgIBPjx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 11:39:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082Fdid7024212;
        Wed, 2 Sep 2020 15:39:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=K3GtYKd+39jy9raJRqZV2lWjH7MjMClGz/Ff+x0y9nQ=;
 b=hFQ0Wjp12BaysRyVTgSPRaQa3W1E+AFR+cO6op0f7FCo1/XZ5h9EU0azxrFgqNIFq5Wv
 I/CCY2Sp78JymE37in0fWgzVilDGAib+R5dYkoRVxDWgBHu+/0PjITzI0dAjZgoK9/h1
 5Yf5oI08Ie1NUUByUy6Fk6Vymyt3zuGhZ2EmJEijn+biKTwY96LY1OUmXr9OTEqGq9pO
 2ubXXPvmpVk11n18O94zHozB4wkRFm2O5l+gSQ+nH+4m8TpeqAmNuLj0fwODLHX00w1S
 +T0fPCk7rV8mD8AADA0UvKY1iu/uCt2Lo/q37b0DDedO/kD5g3vBRPwJ7UjhJlB7dc4J CQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 339dmn1tqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Sep 2020 15:39:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082FYnhM066686;
        Wed, 2 Sep 2020 15:39:50 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 3380x70gxq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Sep 2020 15:39:49 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 082FdmLx007706;
        Wed, 2 Sep 2020 15:39:48 GMT
Received: from dhcp-10-154-155-248.vpn.oracle.com (/10.154.155.248)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Sep 2020 08:39:48 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH v2 05/13] qla2xxx: Reduce duplicate code in reporting
 speed
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20200902072548.11491-6-njavali@marvell.com>
Date:   Wed, 2 Sep 2020 10:39:47 -0500
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <81782CD0-F5B0-44AC-B2C6-AA2C53586575@oracle.com>
References: <20200902072548.11491-1-njavali@marvell.com>
 <20200902072548.11491-6-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=3 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 impostorscore=0 mlxscore=0 suspectscore=3
 spamscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020149
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Sep 2, 2020, at 2:25 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> Indicate correct speed for 16G Mezz card.
>=20
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_attr.c | 41 +-------------
> drivers/scsi/qla2xxx/qla_gbl.h  |  2 +
> drivers/scsi/qla2xxx/qla_gs.c   |  7 +--
> drivers/scsi/qla2xxx/qla_os.c   | 96 +--------------------------------
> 4 files changed, 9 insertions(+), 137 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c =
b/drivers/scsi/qla2xxx/qla_attr.c
> index 5d93ccc73153..d006ae193677 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -3214,46 +3214,7 @@ qla2x00_init_host_attr(scsi_qla_host_t *vha)
> 	fc_host_max_npiv_vports(vha->host) =3D ha->max_npiv_vports;
> 	fc_host_npiv_vports_inuse(vha->host) =3D ha->cur_vport_count;
>=20
> -	if (IS_CNA_CAPABLE(ha))
> -		speeds =3D FC_PORTSPEED_10GBIT;
> -	else if (IS_QLA28XX(ha) || IS_QLA27XX(ha)) {
> -		if (ha->max_supported_speed =3D=3D 2) {
> -			if (ha->min_supported_speed <=3D 6)
> -				speeds |=3D FC_PORTSPEED_64GBIT;
> -		}
> -		if (ha->max_supported_speed =3D=3D 2 ||
> -		    ha->max_supported_speed =3D=3D 1) {
> -			if (ha->min_supported_speed <=3D 5)
> -				speeds |=3D FC_PORTSPEED_32GBIT;
> -		}
> -		if (ha->max_supported_speed =3D=3D 2 ||
> -		    ha->max_supported_speed =3D=3D 1 ||
> -		    ha->max_supported_speed =3D=3D 0) {
> -			if (ha->min_supported_speed <=3D 4)
> -				speeds |=3D FC_PORTSPEED_16GBIT;
> -		}
> -		if (ha->max_supported_speed =3D=3D 1 ||
> -		    ha->max_supported_speed =3D=3D 0) {
> -			if (ha->min_supported_speed <=3D 3)
> -				speeds |=3D FC_PORTSPEED_8GBIT;
> -		}
> -		if (ha->max_supported_speed =3D=3D 0) {
> -			if (ha->min_supported_speed <=3D 2)
> -				speeds |=3D FC_PORTSPEED_4GBIT;
> -		}
> -	} else if (IS_QLA2031(ha))
> -		speeds =3D FC_PORTSPEED_16GBIT|FC_PORTSPEED_8GBIT|
> -			FC_PORTSPEED_4GBIT;
> -	else if (IS_QLA25XX(ha) || IS_QLAFX00(ha))
> -		speeds =3D FC_PORTSPEED_8GBIT|FC_PORTSPEED_4GBIT|
> -			FC_PORTSPEED_2GBIT|FC_PORTSPEED_1GBIT;
> -	else if (IS_QLA24XX_TYPE(ha))
> -		speeds =3D FC_PORTSPEED_4GBIT|FC_PORTSPEED_2GBIT|
> -			FC_PORTSPEED_1GBIT;
> -	else if (IS_QLA23XX(ha))
> -		speeds =3D FC_PORTSPEED_2GBIT|FC_PORTSPEED_1GBIT;
> -	else
> -		speeds =3D FC_PORTSPEED_1GBIT;
> +	speeds =3D qla25xx_fdmi_port_speed_capability(ha);
>=20
> 	fc_host_supported_speeds(vha->host) =3D speeds;
> }
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h =
b/drivers/scsi/qla2xxx/qla_gbl.h
> index 36c210c24f72..3360857c4405 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -704,6 +704,8 @@ int qla24xx_async_gfpnid(scsi_qla_host_t *, =
fc_port_t *);
> void qla24xx_handle_gfpnid_event(scsi_qla_host_t *, struct event_arg =
*);
> void qla24xx_sp_unmap(scsi_qla_host_t *, srb_t *);
> void qla_scan_work_fn(struct work_struct *);
> +uint qla25xx_fdmi_port_speed_capability(struct qla_hw_data *);
> +uint qla25xx_fdmi_port_speed_currently(struct qla_hw_data *);
>=20
> /*
>  * Global Function Prototypes in qla_attr.c source file.
> diff --git a/drivers/scsi/qla2xxx/qla_gs.c =
b/drivers/scsi/qla2xxx/qla_gs.c
> index 676607f2cf53..de5a944bdec2 100644
> --- a/drivers/scsi/qla2xxx/qla_gs.c
> +++ b/drivers/scsi/qla2xxx/qla_gs.c
> @@ -1502,7 +1502,7 @@ qla2x00_prep_ct_fdmi_req(struct ct_sns_pkt *p, =
uint16_t cmd,
> 	return &p->p.req;
> }
>=20
> -static uint
> +uint
> qla25xx_fdmi_port_speed_capability(struct qla_hw_data *ha)
> {
> 	uint speeds =3D 0;
> @@ -1546,7 +1546,7 @@ qla25xx_fdmi_port_speed_capability(struct =
qla_hw_data *ha)
> 		}
> 		return speeds;
> 	}
> -	if (IS_QLA25XX(ha))
> +	if (IS_QLA25XX(ha) || IS_QLAFX00(ha))
> 		return FDMI_PORT_SPEED_8GB|FDMI_PORT_SPEED_4GB|
> 			FDMI_PORT_SPEED_2GB|FDMI_PORT_SPEED_1GB;
> 	if (IS_QLA24XX_TYPE(ha))
> @@ -1556,7 +1556,8 @@ qla25xx_fdmi_port_speed_capability(struct =
qla_hw_data *ha)
> 		return FDMI_PORT_SPEED_2GB|FDMI_PORT_SPEED_1GB;
> 	return FDMI_PORT_SPEED_1GB;
> }
> -static uint
> +
> +uint
> qla25xx_fdmi_port_speed_currently(struct qla_hw_data *ha)
> {
> 	switch (ha->link_data_rate) {
> diff --git a/drivers/scsi/qla2xxx/qla_os.c =
b/drivers/scsi/qla2xxx/qla_os.c
> index f9e40a6d7189..74e6a04850c0 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -5810,98 +5810,6 @@ qla25xx_rdp_rsp_reduce_size(struct =
scsi_qla_host *vha,
> 	return true;
> }
>=20
> -static uint
> -qla25xx_rdp_port_speed_capability(struct qla_hw_data *ha)
> -{
> -	if (IS_CNA_CAPABLE(ha))
> -		return RDP_PORT_SPEED_10GB;
> -
> -	if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
> -		unsigned int speeds =3D 0;
> -
> -		if (ha->max_supported_speed =3D=3D 2) {
> -			if (ha->min_supported_speed <=3D 6)
> -				speeds |=3D RDP_PORT_SPEED_64GB;
> -		}
> -
> -		if (ha->max_supported_speed =3D=3D 2 ||
> -		    ha->max_supported_speed =3D=3D 1) {
> -			if (ha->min_supported_speed <=3D 5)
> -				speeds |=3D RDP_PORT_SPEED_32GB;
> -		}
> -
> -		if (ha->max_supported_speed =3D=3D 2 ||
> -		    ha->max_supported_speed =3D=3D 1 ||
> -		    ha->max_supported_speed =3D=3D 0) {
> -			if (ha->min_supported_speed <=3D 4)
> -				speeds |=3D RDP_PORT_SPEED_16GB;
> -		}
> -
> -		if (ha->max_supported_speed =3D=3D 1 ||
> -		    ha->max_supported_speed =3D=3D 0) {
> -			if (ha->min_supported_speed <=3D 3)
> -				speeds |=3D RDP_PORT_SPEED_8GB;
> -		}
> -
> -		if (ha->max_supported_speed =3D=3D 0) {
> -			if (ha->min_supported_speed <=3D 2)
> -				speeds |=3D RDP_PORT_SPEED_4GB;
> -		}
> -
> -		return speeds;
> -	}
> -
> -	if (IS_QLA2031(ha))
> -		return RDP_PORT_SPEED_16GB|RDP_PORT_SPEED_8GB|
> -		       RDP_PORT_SPEED_4GB;
> -
> -	if (IS_QLA25XX(ha))
> -		return RDP_PORT_SPEED_8GB|RDP_PORT_SPEED_4GB|
> -		       RDP_PORT_SPEED_2GB|RDP_PORT_SPEED_1GB;
> -
> -	if (IS_QLA24XX_TYPE(ha))
> -		return RDP_PORT_SPEED_4GB|RDP_PORT_SPEED_2GB|
> -		       RDP_PORT_SPEED_1GB;
> -
> -	if (IS_QLA23XX(ha))
> -		return RDP_PORT_SPEED_2GB|RDP_PORT_SPEED_1GB;
> -
> -	return RDP_PORT_SPEED_1GB;
> -}
> -
> -static uint
> -qla25xx_rdp_port_speed_currently(struct qla_hw_data *ha)
> -{
> -	switch (ha->link_data_rate) {
> -	case PORT_SPEED_1GB:
> -		return RDP_PORT_SPEED_1GB;
> -
> -	case PORT_SPEED_2GB:
> -		return RDP_PORT_SPEED_2GB;
> -
> -	case PORT_SPEED_4GB:
> -		return RDP_PORT_SPEED_4GB;
> -
> -	case PORT_SPEED_8GB:
> -		return RDP_PORT_SPEED_8GB;
> -
> -	case PORT_SPEED_10GB:
> -		return RDP_PORT_SPEED_10GB;
> -
> -	case PORT_SPEED_16GB:
> -		return RDP_PORT_SPEED_16GB;
> -
> -	case PORT_SPEED_32GB:
> -		return RDP_PORT_SPEED_32GB;
> -
> -	case PORT_SPEED_64GB:
> -		return RDP_PORT_SPEED_64GB;
> -
> -	default:
> -		return RDP_PORT_SPEED_UNKNOWN;
> -	}
> -}
> -
> /*
>  * Function Name: qla24xx_process_purex_iocb
>  *
> @@ -6068,9 +5976,9 @@ void qla24xx_process_purex_rdp(struct =
scsi_qla_host *vha,
> 	rsp_payload->port_speed_desc.desc_len =3D
> 	    cpu_to_be32(RDP_DESC_LEN(rsp_payload->port_speed_desc));
> 	rsp_payload->port_speed_desc.speed_capab =3D cpu_to_be16(
> -	    qla25xx_rdp_port_speed_capability(ha));
> +	    qla25xx_fdmi_port_speed_capability(ha));
> 	rsp_payload->port_speed_desc.operating_speed =3D cpu_to_be16(
> -	    qla25xx_rdp_port_speed_currently(ha));
> +	    qla25xx_fdmi_port_speed_currently(ha));
>=20
> 	/* Link Error Status Descriptor */
> 	rsp_payload->ls_err_desc.desc_tag =3D cpu_to_be32(0x10002);
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

