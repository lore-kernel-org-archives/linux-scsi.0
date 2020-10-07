Return-Path: <SRS0=2LRe=DO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9B6BC47095
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 13:29:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69E0820870
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 13:29:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BikErFg2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728448AbgJGN3k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Oct 2020 09:29:40 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47800 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728380AbgJGN3k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2020 09:29:40 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097DDSMw134516;
        Wed, 7 Oct 2020 13:29:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=CwN46KYA6wJKiyru5KHjshaf/jMkwSRcmYxyCnULW74=;
 b=BikErFg29guYiSfqReZiklztBXlXpy6G4LpI8ItXnabkz4RZM7fiLiqxiaNT2tnkPTGy
 LPipImh+kdPkmJQnKnMk3rAmftrtdeAP4aqGnYjaC360V9Nshc+sg72FbNaYquxeXKg0
 YrGLXmrLuE1lUcQBdvDW9fr3mJ2q0uz7r4P7odqf0kOs5iOHWgGVWxq2X3ppxd5hKQhF
 mnfrSZYOU2MgakTdRLQjZ6M72d+t67Acf+KvQueMTHhPLGErbKUrB8hzyAub6vCV/37b
 W53e5lTO4loZoVsNS/S0wifSH8M11lQVzj8CGgSsG3o4UiOK1hDm0Ave19/6IGHwXfmM Gg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33xhxn1nt9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 13:29:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097DFCIK141475;
        Wed, 7 Oct 2020 13:29:31 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33yyjh77v7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 13:29:30 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 097DTO4v023066;
        Wed, 7 Oct 2020 13:29:25 GMT
Received: from [192.168.1.26] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 06:29:24 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] qla2xxx: Use constant when it is known.
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20200921112340.GA19336@duo.ucw.cz>
Date:   Wed, 7 Oct 2020 08:29:24 -0500
Cc:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <39CE3456-73A7-4533-BE7F-382469695E08@oracle.com>
References: <20200921112340.GA19336@duo.ucw.cz>
To:     Pavel Machek <pavel@denx.de>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070088
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 clxscore=1011 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070088
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Sep 21, 2020, at 6:23 AM, Pavel Machek <pavel@denx.de> wrote:
>=20
> Directly return constant when it is known, to make code easier to
> understand.
>=20
> Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c =
b/drivers/scsi/qla2xxx/qla_nvme.c
> index 90bbc61f361b..248197e9e8ea 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -530,7 +530,7 @@ static int qla_nvme_post_cmd(struct =
nvme_fc_local_port *lport,
> 	fc_port_t *fcport;
> 	struct srb_iocb *nvme;
> 	struct scsi_qla_host *vha;
> -	int rval =3D -ENODEV;
> +	int rval;
> 	srb_t *sp;
> 	struct qla_qpair *qpair =3D hw_queue_handle;
> 	struct nvme_private *priv =3D fd->private;
> @@ -538,14 +538,14 @@ static int qla_nvme_post_cmd(struct =
nvme_fc_local_port *lport,
>=20
> 	if (!priv) {
> 		/* nvme association has been torn down */
> -		return rval;
> +		return -ENODEV;
> 	}
>=20
> 	fcport =3D qla_rport->fcport;
>=20
> 	if (!qpair || !fcport || (qpair && !qpair->fw_started) ||
> 	    (fcport && fcport->deleted))
> -		return rval;
> +		return -ENODEV;
>=20
> 	vha =3D fcport->vha;
> 	/*
>=20
> --=20
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) =
http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

