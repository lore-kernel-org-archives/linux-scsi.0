Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69CB1C64E7A
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 16:18:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1039922244
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 16:18:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E+wrhvrL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390906AbgLAQRu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 11:17:50 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57170 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390720AbgLAQRt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 11:17:49 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1G5H9r099356;
        Tue, 1 Dec 2020 16:17:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=LTmgCnaq+/QccptVWlgifp70L6vfR4XNeWzhBp0emJs=;
 b=E+wrhvrL8eEd38L0T4lV4S/Iu1jcsaTzkG7KVaQ60/bA5lyv1vmwfyDQgwC39yIDEQEE
 KsT7CZTsJATG7VhvZIgFdVlD9Hpje9WxuReW6v1br2WHXgm0fhVCSsio6Aoh4HP1C76D
 dMfaFtPPLwuAyuxiqj6h1ttlxoOl+kTaXrnCPdpUcZ3ZnMgkmHBHz0ULI9Vte684xihg
 2I79Uh4EvcnglyErpJ6/dX5O2nwZ3QRTIMO4SAo8+JRg9GjDz/atJ0xHrIfIzRwWiPSb
 0yXFNiemmpMtKE1dMRY/ngpcxXCn6PqnLeB/yBz3w/Kf+7+Mb+CQ3PLAh06P8V9LbpHe 8A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 353dyqkf06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 16:17:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1G5KFi139386;
        Tue, 1 Dec 2020 16:17:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3540fx6dab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 16:17:07 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B1GH6Dw024483;
        Tue, 1 Dec 2020 16:17:06 GMT
Received: from [192.168.1.15] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 08:17:06 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH 10/15] qla2xxx: Handle aborts correctly for port
 undergoing deletion
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20201201082730.24158-11-njavali@marvell.com>
Date:   Tue, 1 Dec 2020 10:17:04 -0600
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <7FAEB66B-C3EB-4573-9017-256521147A77@oracle.com>
References: <20201201082730.24158-1-njavali@marvell.com>
 <20201201082730.24158-11-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010101
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010101
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 1, 2020, at 2:27 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Saurav Kashyap <skashyap@marvell.com>
>=20
> Call trace observed while shutting down the adapter ports (LINK DOWN).
> Handle aborts correctly.
>=20

Could you post call trace in commit message.=20

> Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_nvme.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c =
b/drivers/scsi/qla2xxx/qla_nvme.c
> index d4159d5a4ffd..eab559b3b257 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -227,7 +227,7 @@ static void qla_nvme_abort_work(struct work_struct =
*work)
> 	       "%s called for sp=3D%p, hndl=3D%x on fcport=3D%p =
deleted=3D%d\n",
> 	       __func__, sp, sp->handle, fcport, fcport->deleted);
>=20
> -	if (!ha->flags.fw_started && fcport->deleted)
> +	if (!ha->flags.fw_started || fcport->deleted)
> 		goto out;
>=20
> 	if (ha->flags.host_shutting_down) {
> --=20
> 2.19.0.rc0
>=20

Change itself is fine.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

