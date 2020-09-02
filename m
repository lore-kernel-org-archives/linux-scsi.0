Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84F23C433E7
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 15:46:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64270208B3
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 15:46:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="x25ddqXl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbgIBPqZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 11:46:25 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42804 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727980AbgIBPqX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 11:46:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082Fhcv3041297;
        Wed, 2 Sep 2020 15:46:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=iuolGXeag3dm1pKLSqsUBoBGta9Po4NKV1S+UfFIJus=;
 b=x25ddqXlRHpT2gQ0LQMc8HK/p4Oj+xCGaAqZ8LWYffkGeIenVB8bgRjVOjlpKDqho7rD
 vRCSsIud0tYhjlohR0nWm8NXjM771HMjYfrbwfCPEIG0pq50z3WPpoyvI4tejkyQjcUZ
 LNPB97iuABGzyHab46VNRH67jT7/TIAh1CIZB5sjpcvfDz4j8+42MZ0Q6hJOQ2z4IGRX
 /l9Ath5Et1M5V4dOR7RpNzIeVeATvT++kzmaH4fWdBN03wW/4Fk+pxLWJwhGbTXhswqv
 KhH2NhuTtrDS6fZjD3m11WRztNDmI1xNpGNAxHKRL2hvNA4RKvDFVZqdTZMzbithey2l SA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 339dmn1vaq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Sep 2020 15:46:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082Fid5s110599;
        Wed, 2 Sep 2020 15:46:20 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 3380x712pb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Sep 2020 15:46:20 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 082FkJVf030360;
        Wed, 2 Sep 2020 15:46:19 GMT
Received: from dhcp-10-154-155-248.vpn.oracle.com (/10.154.155.248)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Sep 2020 08:46:19 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH v2 06/13] qla2xxx: Fix memory size truncation
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20200902072548.11491-7-njavali@marvell.com>
Date:   Wed, 2 Sep 2020 10:46:18 -0500
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <571543A3-4D6F-4EB8-AD73-9A2344ECA29C@oracle.com>
References: <20200902072548.11491-1-njavali@marvell.com>
 <20200902072548.11491-7-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=3 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020150
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 impostorscore=0 mlxscore=0 suspectscore=3
 spamscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020150
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Sep 2, 2020, at 2:25 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> Memory size calculation for Extended Login use in hardware
> offload was truncated when the setting was set with higher
> value.
>=20

I see code change makes sense but commit message does not.=20

Does following makes sense?=20

Memory size calculations for Extended Login used in hardware Offload got =
truncated.
Fix this by changing definition of exlogin_size to use uint32_t.

> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_def.h | 2 +-
> drivers/scsi/qla2xxx/qla_mbx.c | 7 ++++---
> drivers/scsi/qla2xxx/qla_os.c  | 5 +++--
> 3 files changed, 8 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h =
b/drivers/scsi/qla2xxx/qla_def.h
> index 074d8753cfc3..ad4a0ba7203c 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -4216,7 +4216,7 @@ struct qla_hw_data {
> 	/* Extended Logins  */
> 	void		*exlogin_buf;
> 	dma_addr_t	exlogin_buf_dma;
> -	int		exlogin_size;
> +	uint32_t	exlogin_size;
>=20
> #define ENABLE_EXCHANGE_OFFLD	BIT_2
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c =
b/drivers/scsi/qla2xxx/qla_mbx.c
> index 989327868dd8..ab7dbbc99c22 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -845,7 +845,7 @@ qla_get_exlogin_status(scsi_qla_host_t *vha, =
uint16_t *buf_sz,
>  * Context:
>  *	Kernel context.
>  */
> -#define CONFIG_XLOGINS_MEM	0x3
> +#define CONFIG_XLOGINS_MEM	0x9
> int
> qla_set_exlogin_mem_cfg(scsi_qla_host_t *vha, dma_addr_t phys_addr)
> {
> @@ -872,8 +872,9 @@ qla_set_exlogin_mem_cfg(scsi_qla_host_t *vha, =
dma_addr_t phys_addr)
> 	mcp->flags =3D 0;
> 	rval =3D qla2x00_mailbox_command(vha, mcp);
> 	if (rval !=3D QLA_SUCCESS) {
> -		/*EMPTY*/
> -		ql_dbg(ql_dbg_mbx, vha, 0x111b, "Failed=3D%x.\n", rval);
> +		ql_dbg(ql_dbg_mbx, vha, 0x111b,
> +		       "EXlogin Failed=3D%x. MB0=3D%x MB11=3D%x\n",
> +		       rval, mcp->mb[0], mcp->mb[11]);
> 	} else {
> 		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x118c,
> 		    "Done %s.\n", __func__);
> diff --git a/drivers/scsi/qla2xxx/qla_os.c =
b/drivers/scsi/qla2xxx/qla_os.c
> index 74e6a04850c0..31bfc0c088b7 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -4379,11 +4379,12 @@ int
> qla2x00_set_exlogins_buffer(scsi_qla_host_t *vha)
> {
> 	int rval;
> -	uint16_t	size, max_cnt, temp;
> +	uint16_t	size, max_cnt;
> +	uint32_t temp;
> 	struct qla_hw_data *ha =3D vha->hw;
>=20
> 	/* Return if we don't need to alloacate any extended logins */
> -	if (!ql2xexlogins)
> +	if (ql2xexlogins <=3D MAX_FIBRE_DEVICES_2400)
> 		return QLA_SUCCESS;
>=20
> 	if (!IS_EXLOGIN_OFFLD_CAPABLE(ha))
> --=20
> 2.19.0.rc0
>=20

Small nit for commit message, Otherwise=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

