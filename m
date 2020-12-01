Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10B00C64E7A
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 16:22:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AADB72065C
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 16:22:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="yMpGhcXN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392172AbgLAQVu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 11:21:50 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:43914 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392161AbgLAQVt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 11:21:49 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1G4wXQ062911;
        Tue, 1 Dec 2020 16:21:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=BPF5oBhdOYZAJPaxtF6+FrDTV7DEfz+gF8d6g4B7TK4=;
 b=yMpGhcXN6SrPaKMjdOg9IR1lQ+QeU8gSKcsAFItUL1PpT0PyB81WmVXBJS0I9weiYt/o
 nbDJa3JNVn9/j1M/YWelFY7gulRGS+oEEsP3n7zoePn1N2fRVnCKjrqtg4lX+T6IMVzO
 JQkDb1yvs5zjD6Tq4m/+1umoP9pu/zkOdP8oUJUFO3rm3mZaQd1UkxuqRhbPeoAOj8To
 bFVbT+TmGGM4GFCq7KM5+AgWJz/K67xsS4aaGl4s2J+6/9QGUVFNxzkqUy5HdNZz3p8Z
 UMiS6GcF5GTQ1nfPG0QfuzdCuhHLSwgxo4im1oYCAsb9WYYSi817Gc6Owpy5hU6bAD6W zA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 353c2aukh9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 16:21:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1G5L9a139561;
        Tue, 1 Dec 2020 16:21:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3540fx6p9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 16:21:05 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B1GL4C7027534;
        Tue, 1 Dec 2020 16:21:04 GMT
Received: from [192.168.1.15] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 08:21:04 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH 13/15] qla2xxx: If fcport is undergoing deletion return IO
 with retry
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20201201082730.24158-14-njavali@marvell.com>
Date:   Tue, 1 Dec 2020 10:21:04 -0600
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <985F0D78-F20A-497B-9A6F-7454C2432367@oracle.com>
References: <20201201082730.24158-1-njavali@marvell.com>
 <20201201082730.24158-14-njavali@marvell.com>
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
> From: Saurav Kashyap <skashyap@marvell.com>
>=20
> Driver unload with IOs causes server to crash.
> Return IO with retry if fcport undergoing deletion.
>=20

Any call stack or panic signature to share in commit message?

> Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_os.c | 8 ++++----
> 1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_os.c =
b/drivers/scsi/qla2xxx/qla_os.c
> index a75edba2b334..be9d10092dd3 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -884,8 +884,8 @@ qla2xxx_queuecommand(struct Scsi_Host *host, =
struct scsi_cmnd *cmd)
> 			goto qc24_fail_command;
> 	}
>=20
> -	if (!fcport) {
> -		cmd->result =3D DID_NO_CONNECT << 16;
> +	if (!fcport || fcport->deleted) {
> +		cmd->result =3D DID_IMM_RETRY << 16;
> 		goto qc24_fail_command;
> 	}
>=20
> @@ -966,8 +966,8 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, =
struct scsi_cmnd *cmd,
> 		goto qc24_fail_command;
> 	}
>=20
> -	if (!fcport) {
> -		cmd->result =3D DID_NO_CONNECT << 16;
> +	if (!fcport || fcport->deleted) {
> +		cmd->result =3D DID_IMM_RETRY << 16;
> 		goto qc24_fail_command;
> 	}
>=20
> --=20
> 2.19.0.rc0
>=20

Patch itself looks good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

