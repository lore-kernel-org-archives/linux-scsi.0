Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF668C64E7A
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 15:51:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABB632080A
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 15:51:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fI5xCyFz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731102AbgLAPv1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 10:51:27 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:47532 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726402AbgLAPv0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 10:51:26 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1FYtwi135207;
        Tue, 1 Dec 2020 15:50:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=r+4kTKFBwyUjIndj0+KHRMEjqHuy5QXvgzWH2u2pWRk=;
 b=fI5xCyFzmG76nbsSnyHo5VjFPJgPuPm26vZjQZX4wcZfaROPJVFxP1fKmLyBYw5l68a+
 uqVkghZzw1M+PZmRMOYuYl6DERwMtw35UWsaeDRDipbfbk5Xl/XVl5CCvrjsWsOpXufl
 xSiN6vLBlRn4e7i/uXCA33KwPxMhZYNvG27ERQU1088obZTXFXmgFDjGYInCDWypt3Wf
 qjx6bIiujaPEX6qTuU+hVOWNp/cEahlzAxMdrkb6tvT9uDCCb6TkO8yBSX0l40UH/k3W
 5e6W8h7bomfw17t5MyTWxxzwI1osvvxyB5EcF+8FL++EnChVxfGpPwGLtnyA4NvSHh9x /g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 353egkk7gv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 15:50:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1FU7i6110151;
        Tue, 1 Dec 2020 15:50:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 3540ey4sx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 15:50:43 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B1FogQa015541;
        Tue, 1 Dec 2020 15:50:42 GMT
Received: from [192.168.1.15] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 07:50:42 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH 05/15] qla2xxx: Don't check for fw_started while posting
 nvme command
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20201201082730.24158-6-njavali@marvell.com>
Date:   Tue, 1 Dec 2020 09:50:41 -0600
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <38D31504-C395-400F-A638-410ECA7B23BD@oracle.com>
References: <20201201082730.24158-1-njavali@marvell.com>
 <20201201082730.24158-6-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010099
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
> From: Saurav Kashyap <skashyap@marvell.com>
>=20
> NVMe commands can come only after successful addition of rport and =
nvme
> connect, and rport is only registered after FW started bit is set. =
Remove the
> redundant check.
>=20
> Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_nvme.c | 12 ++++--------
> 1 file changed, 4 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c =
b/drivers/scsi/qla2xxx/qla_nvme.c
> index b7a1dc24db38..d4159d5a4ffd 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -554,19 +554,15 @@ static int qla_nvme_post_cmd(struct =
nvme_fc_local_port *lport,
>=20
> 	fcport =3D qla_rport->fcport;
>=20
> -	if (!qpair || !fcport)
> -		return -ENODEV;
> -
> -	if (!qpair->fw_started || fcport->deleted)
> +	if (unlikely(!qpair || !fcport || fcport->deleted))
> 		return -EBUSY;
>=20
> -	vha =3D fcport->vha;
> -
> 	if (!(fcport->nvme_flag & NVME_FLAG_REGISTERED))
> 		return -ENODEV;
>=20
> -	if (test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) ||
> -	    (qpair && !qpair->fw_started) || fcport->deleted)
> +	vha =3D fcport->vha;
> +
> +	if (test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags))
> 		return -EBUSY;
>=20
> 	/*
> --=20
> 2.19.0.rc0
>=20

Looks Good

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

