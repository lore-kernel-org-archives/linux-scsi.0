Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99452C433DB
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jan 2021 15:38:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6533623122
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jan 2021 15:38:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbhAFPif (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jan 2021 10:38:35 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:54008 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbhAFPif (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2021 10:38:35 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106FXadf160968;
        Wed, 6 Jan 2021 15:37:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=epCEWFT6+QS93H599ib7IXKIe8YyfGZBLW63Jx89a3Q=;
 b=od5nS2PVABY1UqVcyMrVpdDB9epKd8qUhFRlxSW1npjf1KCLOgkae1HVpZiVLflf1olP
 Y+Q2lwXQq89iXkG32K3Devz2LKgfwAUjPJlr7s+QD/P27u+vND4gMl7mCZxqgDGFupC7
 AVdRTaugV4sE0nesWyRLSzvJBBql8sf57SwFH+hHd2V2MhM4zhYUb2unSo3IOiNoedJi
 PW2hkmTmd3YMRs62YQpuA6qFi6XmgS7HLh7xDkLnxvzvNaBnar0BT0Fw0kNnE9haaDjP
 jUx+bqJpTcRN2o/XQ6A3fXG9gI+LkmbDapp3mL95ZmCgVyN29dCQM14qI3A9f79cGizx Zw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35wepm8fky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 06 Jan 2021 15:37:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106FUPJG162200;
        Wed, 6 Jan 2021 15:37:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 35w3qs6cgf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Jan 2021 15:37:52 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 106FbpGF015170;
        Wed, 6 Jan 2021 15:37:51 GMT
Received: from [192.168.1.30] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Jan 2021 07:37:51 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH v3 6/7] qla2xxx: Enable NVME CONF (BIT_7) when enabling
 SLER
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20210105103847.25041-7-njavali@marvell.com>
Date:   Wed, 6 Jan 2021 09:37:51 -0600
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <DE3CFA5F-0AED-4415-B93A-2D45CAC189A4@oracle.com>
References: <20210105103847.25041-1-njavali@marvell.com>
 <20210105103847.25041-7-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060097
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060097
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jan 5, 2021, at 4:38 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Saurav Kashyap <skashyap@marvell.com>
>=20
> Enable NVME confirmation bit in PRLI.
>=20
> Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_iocb.c | 2 ++
> 1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c =
b/drivers/scsi/qla2xxx/qla_iocb.c
> index e27359b294d3..8b41cbaf8535 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -2378,6 +2378,8 @@ qla24xx_prli_iocb(srb_t *sp, struct =
logio_entry_24xx *logio)
> 			logio->io_parameter[0] =3D
> 				cpu_to_le32(NVME_PRLI_SP_FIRST_BURST);
> 		if (sp->vha->flags.nvme2_enabled) {
> +			/* Set service parameter BIT_7 for NVME CONF =
support */
> +			logio->io_parameter[0] |=3D NVME_PRLI_SP_CONF;
> 			/* Set service parameter BIT_8 for SLER support =
*/
> 			logio->io_parameter[0] |=3D
> 				cpu_to_le32(NVME_PRLI_SP_SLER);
> --=20
> 2.19.0.rc0
>=20

Looks Good.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

