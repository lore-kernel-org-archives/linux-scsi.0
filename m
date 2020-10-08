Return-Path: <SRS0=XwCY=DP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4D57C433E7
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 18:40:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 483E3221FF
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 18:40:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WU4OvAyW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729244AbgJHSkv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Oct 2020 14:40:51 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55744 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729235AbgJHSku (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Oct 2020 14:40:50 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098IY1jg107254;
        Thu, 8 Oct 2020 18:40:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=VkVDF9aacMr4G/rhxpGJkO7lauGuJuNDRrbm4OULKug=;
 b=WU4OvAyWXjR1OGljI7SpE6FBKZmVeTzLqWfWDWfhD+65max1SWjHBvx5n50bXgdzHd/e
 39xc5k6Sb+KdFhtvLX3N+XaJhBmOlGzGzehfjDvH+kOt62hZms1kKm4yJHd3k6NWwywB
 +dhYatpc2DTC0pmhEA6NJEsSiY5IKBZeq+6ectNlUb7+BqpfbMTnmhqE8vIgTxHSPKcW
 t7N9i5is7g62smR/V1+GmdYSeKktqvKdhZd0ikwh/JL7kEiZHXuUdp//VexBDucWT5fu
 R9YtA/5+fmuunTQzQX7pybmnRCEEnhDcMzcanuAjdADtohrRMG5/E722LVjxmQbUNmHJ Tg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33ym34xg1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 18:40:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098IaFRZ048025;
        Thu, 8 Oct 2020 18:40:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 33y381hyy8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 18:40:41 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 098IeZam018476;
        Thu, 8 Oct 2020 18:40:35 GMT
Received: from dhcp-10-154-152-144.vpn.oracle.com (/10.154.152.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 08 Oct 2020 11:40:33 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] scsi: qla2xxx: fix return of uninitialized value in rval
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20201008183239.200358-1-colin.king@canonical.com>
Date:   Thu, 8 Oct 2020 13:40:33 -0500
Cc:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Pavel Machek <pavel@denx.de>, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <9AD290EF-AA42-48F4-99F0-2C8FBDB592BA@oracle.com>
References: <20201008183239.200358-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9768 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 malwarescore=0 suspectscore=3 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9768 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 clxscore=1011 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=3 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080133
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Oct 8, 2020, at 1:32 PM, Colin King <colin.king@canonical.com> =
wrote:
>=20
> From: Colin Ian King <colin.king@canonical.com>
>=20
> A previous change removed the initialization of rval and there is
> now an error where an uninitialized rval is being returned on an
> error return path. Fix this by returning -ENODEV.
>=20
> Addresses-Coverity: ("Uninitialized scalar variable")
> Fixes: b994718760fa ("scsi: qla2xxx: Use constant when it is known")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
> drivers/scsi/qla2xxx/qla_nvme.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c =
b/drivers/scsi/qla2xxx/qla_nvme.c
> index ae47e0eb0311..1f9005125313 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -561,7 +561,7 @@ static int qla_nvme_post_cmd(struct =
nvme_fc_local_port *lport,
> 	vha =3D fcport->vha;
>=20
> 	if (!(fcport->nvme_flag & NVME_FLAG_REGISTERED))
> -		return rval;
> +		return -ENODEV;
>=20
> 	if (test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) ||
> 	    (qpair && !qpair->fw_started) || fcport->deleted)
> --=20
> 2.27.0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

