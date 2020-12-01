Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43AA4C64E90
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 16:18:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D231722240
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 16:18:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aqJMLezp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391874AbgLAQSe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 11:18:34 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:40718 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390841AbgLAQSe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 11:18:34 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1G59Rf063049;
        Tue, 1 Dec 2020 16:17:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=k2S0i6N067felbOAZOdEH14dYciiCf29z6ZKQ1qwlQA=;
 b=aqJMLezp+X24ErnObHKtAnK27hD+DPVvJZyHjtJtnLq6l8K/UDhlyO47yy9ow3wTKIaY
 wvBJL+iQo79qw5boXSG3TFAFCX2+Khbu/FonbQ5wd2fNi7S3yqv8uhnhjasYrB92dVky
 qbnhEJsPTUu9idhimqudH1Y4BFCvrBJcypVytJMAvAagBGiXKiy1GBr1xhmoJY7dWjfK
 igKakWYmDetiMXQBS0xmWD4HxR9Iz2jYYRb8MBlbtG9FlHyJDUdhfMa2SvgeXej9Sn3U
 XMcw9J6/3K6GgZENKtHMq0c2ewWC9Jw8GGvZ6ZHaP4oJKHpdefzCXe5lq9Kun0FjZRby PQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 353c2aujvb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 16:17:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1G5Ll2139497;
        Tue, 1 Dec 2020 16:17:50 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 3540fx6efb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 16:17:50 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B1GHoXo027083;
        Tue, 1 Dec 2020 16:17:50 GMT
Received: from [192.168.1.15] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 08:17:49 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH 11/15] qla2xxx: Fix flash update in 28XX adapters on big
 endian machines
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20201201082730.24158-12-njavali@marvell.com>
Date:   Tue, 1 Dec 2020 10:17:49 -0600
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <EB5FF572-64DF-48C1-B791-3E0F11952C3D@oracle.com>
References: <20201201082730.24158-1-njavali@marvell.com>
 <20201201082730.24158-12-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010101
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010101
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 1, 2020, at 2:27 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Arun Easi <aeasi@marvell.com>
>=20
> Flash update failed due to missing endian conversion in FLT region =
access
> as well as in checksum computation.
>=20
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_sup.c | 10 +++++-----
> 1 file changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_sup.c =
b/drivers/scsi/qla2xxx/qla_sup.c
> index 0f92e9a044dc..f771fabcba59 100644
> --- a/drivers/scsi/qla2xxx/qla_sup.c
> +++ b/drivers/scsi/qla2xxx/qla_sup.c
> @@ -2634,14 +2634,14 @@ qla28xx_extract_sfub_and_verify(struct =
scsi_qla_host *vha, uint32_t *buf,
> 	    sizeof(struct secure_flash_update_block));
>=20
> 	for (i =3D 0; i < (sizeof(struct secure_flash_update_block) >> =
2); i++)
> -		check_sum +=3D p[i];
> +		check_sum +=3D le32_to_cpu(p[i]);
>=20
> 	check_sum =3D (~check_sum) + 1;
>=20
> -	if (check_sum !=3D p[i]) {
> +	if (check_sum !=3D le32_to_cpu(p[i])) {
> 		ql_log(ql_log_warn, vha, 0x7097,
> 		    "SFUB checksum failed, 0x%x, 0x%x\n",
> -		    check_sum, p[i]);
> +		    check_sum, le32_to_cpu(p[i]));
> 		return QLA_COMMAND_ERROR;
> 	}
>=20
> @@ -2721,7 +2721,7 @@ qla28xx_write_flash_data(scsi_qla_host_t *vha, =
uint32_t *dwptr, uint32_t faddr,
> 	if (ha->flags.secure_adapter && region.attribute) {
>=20
> 		ql_log(ql_log_warn + ql_dbg_verbose, vha, 0xffff,
> -		    "Region %x is secure\n", region.code);
> +		    "Region %x is secure\n", le16_to_cpu(region.code));
>=20
> 		switch (le16_to_cpu(region.code)) {
> 		case FLT_REG_FW:
> @@ -2775,7 +2775,7 @@ qla28xx_write_flash_data(scsi_qla_host_t *vha, =
uint32_t *dwptr, uint32_t faddr,
> 		default:
> 			ql_log(ql_log_warn + ql_dbg_verbose, vha,
> 			    0xffff, "Secure region %x not supported\n",
> -			    region.code);
> +			    le16_to_cpu(region.code));
> 			rval =3D QLA_COMMAND_ERROR;
> 			goto done;
> 		}
> --=20
> 2.19.0.rc0
>=20

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

