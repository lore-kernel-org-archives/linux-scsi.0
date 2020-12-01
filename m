Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1262CC64E7B
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 15:46:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B1352080A
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 15:46:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="baOBmOkx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390100AbgLAPqL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 10:46:11 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:42490 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391944AbgLAPqK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 10:46:10 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1FYv6u135260;
        Tue, 1 Dec 2020 15:45:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=uLb2wYduce1z6ag2SkCHKVGD+fRur6S1xve6KgGkVYY=;
 b=baOBmOkxYWplzbH+wf54m38nRhIzQdmGaBg26u6gUGAO34ze+hBQKU4yz581zNKP8TNq
 +exgUnRvb9ZTwF3GKb2t0P03KJCh0paep6qRP2exv475OOaMgs66YDVLqALiIOz943xu
 MLrcWVARW9T12ruZ9x8I0+XqLwtryqIJXxwLg6Qm1NGYy63Auf3i9bCoIHinFCIGRdUU
 QV8UrXZmhbjvSYC9LemvXlVYqbVzBgLlILvPWQhk5q5NeYVhvSdbG6hqYk+VkhuukXIl
 HsRZsUJuD9xleDSNi0Va5OdV7Usc6SI9YLqXKTcBMMlMOJgzHe2A8KFA7U7Ltu4XXbcV cw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 353egkk6mn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 15:45:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1FUGGq113352;
        Tue, 1 Dec 2020 15:45:27 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3540ashq6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 15:45:27 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B1FjQ1w009072;
        Tue, 1 Dec 2020 15:45:26 GMT
Received: from [192.168.1.15] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 07:45:26 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH 02/15] qla2xxx: Change post del message from debug level
 to log level
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20201201082730.24158-3-njavali@marvell.com>
Date:   Tue, 1 Dec 2020 09:45:25 -0600
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <3CCE1C90-64DB-46C7-A49D-9378077CA083@oracle.com>
References: <20201201082730.24158-1-njavali@marvell.com>
 <20201201082730.24158-3-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010099
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
> Change the message debug level.
>=20
> Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_gs.c | 8 ++++----
> 1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_gs.c =
b/drivers/scsi/qla2xxx/qla_gs.c
> index e28c4b7ec55f..391ac75e3de3 100644
> --- a/drivers/scsi/qla2xxx/qla_gs.c
> +++ b/drivers/scsi/qla2xxx/qla_gs.c
> @@ -3558,10 +3558,10 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t =
*vha, srb_t *sp)
> 					if (fcport->flags & =
FCF_FCP2_DEVICE)
> 						fcport->logout_on_delete =
=3D 0;
>=20
> -					ql_dbg(ql_dbg_disc, vha, 0x20f0,
> -					    "%s %d %8phC post del =
sess\n",
> -					    __func__, __LINE__,
> -					    fcport->port_name);
> +					ql_log(ql_log_warn, vha, 0x20f0,
> +					       "%s %d %8phC post del =
sess\n",
> +					       __func__, __LINE__,
> +					       fcport->port_name);
>=20
> 					=
qlt_schedule_sess_for_deletion(fcport);
> 					continue;
> --=20
> 2.19.0.rc0
>=20

I am okay with the change just curious, Would it not flood message file =
for large number of sessions?

--
Himanshu Madhani	 Oracle Linux Engineering

