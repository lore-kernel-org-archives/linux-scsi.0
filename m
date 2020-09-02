Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8B4AC433E2
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 15:54:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B686220C56
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 15:54:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BQneU6T4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgIBPym (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 11:54:42 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49916 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727892AbgIBPye (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 11:54:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082FnqTA046975;
        Wed, 2 Sep 2020 15:54:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=dCwIctvT+fzRYXAM4X/VspcSnaaRoweB8dPMvD+Au0k=;
 b=BQneU6T4Sz9G+cPCBEP6yYhqRPClqQFpUSUnLjnWqbXZcdP3kAFHPsKKsJ/u1tuOa1Z1
 Bd2DolgnY6OU71UtmzemJSOl7bFFfIeYTLADamD1VaNMS6MgNp+Nnk9G1QOtBx2lM/qu
 Xz6mivmQG/SksA7/p2O4ZcrH8fsAZkREeSvJThC6ZGkk8Xo43atN6/w9cOM7e/kzyXc+
 zpiPxzUEE6PbJMOhG6m46EBg1HnU4+nG7camx5AC52A/V37qOH1ubMuPOHv41cdNtg2a
 ezfh/hR4TP6ViPJT57wwS11gSf+GXggf9oHTD1q6FIsiEVf4gebuYacvvUPktul+/VEe QQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 339dmn1x7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Sep 2020 15:54:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082Fnjf5086632;
        Wed, 2 Sep 2020 15:54:31 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3380xyxmcc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Sep 2020 15:54:31 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 082FsU29009469;
        Wed, 2 Sep 2020 15:54:30 GMT
Received: from dhcp-10-154-155-248.vpn.oracle.com (/10.154.155.248)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Sep 2020 08:54:30 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH v2 08/13] qla2xxx: Fix I/O errors during LIP reset tests
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20200902072548.11491-9-njavali@marvell.com>
Date:   Wed, 2 Sep 2020 10:54:30 -0500
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <096EF8C1-B112-42DE-A68B-66522D7FB8E1@oracle.com>
References: <20200902072548.11491-1-njavali@marvell.com>
 <20200902072548.11491-9-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 mlxlogscore=955 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=959 adultscore=0 impostorscore=0 mlxscore=0 suspectscore=3
 spamscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020151
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Sep 2, 2020, at 2:25 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Arun Easi <aeasi@marvell.com>
>=20
> In .fcp_io(), returning ENODEV as soon as remote port delete has =
started
> can cause I/O errors. Fix this by returning EBUSY until the remote =
port
> delete finishes.
>=20
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_nvme.c | 10 ++++++++++
> 1 file changed, 10 insertions(+)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c =
b/drivers/scsi/qla2xxx/qla_nvme.c
> index b0c13144c21a..675f2b1180e8 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -548,6 +548,16 @@ static int qla_nvme_post_cmd(struct =
nvme_fc_local_port *lport,
> 		return rval;
>=20
> 	vha =3D fcport->vha;
> +
> +	if (!(fcport->nvme_flag & NVME_FLAG_REGISTERED))
> +		return rval;
> +
> +	if (test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags))
> +		return -EBUSY;
> +
> +	if ((qpair && !qpair->fw_started) || fcport->deleted)
> +		return -EBUSY;
> +

Small nit

Why not combine above 2 if statements as=20

	if (test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) ||
	    (qpair && !qpair->fw_started) || fcport->deleted)
		return -EBUSY;

> 	/*
> 	 * If we know the dev is going away while the transport is still =
sending
> 	 * IO's return busy back to stall the IO Q.  This happens when =
the
> --=20
> 2.19.0.rc0
>=20

--
Himanshu Madhani	 Oracle Linux Engineering

