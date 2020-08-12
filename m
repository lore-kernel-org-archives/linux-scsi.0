Return-Path: <SRS0=c2qj=BW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFCEFC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 19:41:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A790B206DA
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 19:41:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MeDHuOeR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgHLTlE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Aug 2020 15:41:04 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45926 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbgHLTlE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2020 15:41:04 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07CJWg96048186;
        Wed, 12 Aug 2020 19:41:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=sPw4gIyI8zKzV3Y462yEbdDDXvHtEYhW57LuNAIQQ60=;
 b=MeDHuOeRjyRh/zf6g64gw9lxApe6epL4vcx3V5P+R18/ZqD/n2o9fz79ROy247a4b8MH
 R8JHLPwqoE3B4tMAUqF0zU30mgSVgxhj1q8HHzwryODPUqWZ9Zs+KLN3EbgxJRJV6xPS
 XUI1Tu1hbOLKrq7D//uU27pvINY4FBaYBAbSrhiLEN1Rf9aqmNm0z+u4EWtskIFtE6ID
 OorKgLS9wg1Yj2ftXarm6Hg63BwiPjqGVn87H1FXrv+l4V+ABB72WIRZdnXP6SZ5gufn
 Tvbq8jwAHk5Gy985gYoKxwuY6aiG8ZEIFA/U6ZaOnYuJocT04+A7q5BPTxDSH/nZDBpl cg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 32t2ydu58s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 12 Aug 2020 19:41:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07CJXaLu196154;
        Wed, 12 Aug 2020 19:39:01 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 32t5mqvw5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Aug 2020 19:39:01 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07CJcx94029870;
        Wed, 12 Aug 2020 19:39:00 GMT
Received: from dhcp-10-154-152-217.vpn.oracle.com (/10.154.152.217)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 12 Aug 2020 19:38:59 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH v2 01/11] qla2xxx: flush all sessions on zone disable
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20200806111014.28434-2-njavali@marvell.com>
Date:   Wed, 12 Aug 2020 14:38:58 -0500
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <F6F121A2-E2F6-4B50-9435-A13F3CE1F2D2@oracle.com>
References: <20200806111014.28434-1-njavali@marvell.com>
 <20200806111014.28434-2-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9711 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008120121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9711 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 impostorscore=0 lowpriorityscore=0 mlxscore=0 bulkscore=0
 suspectscore=3 phishscore=0 adultscore=0 spamscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008120121
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Aug 6, 2020, at 6:10 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> On Zone Disable, certain switch would ignore all
> commands. This cause timeout for both switch
> scan command and abort of that command. On detection
> of this condition, all sessions will be shutdown.
>=20
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_gs.c | 12 ++++++++++++
> 1 file changed, 12 insertions(+)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_gs.c =
b/drivers/scsi/qla2xxx/qla_gs.c
> index 42c3ad27f1cb..c5529da1df59 100644
> --- a/drivers/scsi/qla2xxx/qla_gs.c
> +++ b/drivers/scsi/qla2xxx/qla_gs.c
> @@ -3734,6 +3734,18 @@ static void =
qla2x00_async_gpnft_gnnft_sp_done(srb_t *sp, int res)
> 		unsigned long flags;
> 		const char *name =3D sp->name;
>=20
> +		if (res =3D=3D QLA_OS_TIMER_EXPIRED) {
> +			/* switch is ignoring all commands.
> +			 * This might be a zone disable behavior.
> +			 * This means we hit 64s timeout.
> +			 * 22s GPNFT + 44s Abort =3D 64s
> +			 */
> +			ql_dbg(ql_dbg_disc, vha, 0xffff,
> +			       "%s: Switch Zone check please .\n",
> +			       name);
> +			qla2x00_mark_all_devices_lost(vha);
> +		}
> +
> 		/*
> 		 * We are in an Interrupt context, queue up this
> 		 * sp for GNNFT_DONE work. This will allow all
> --=20
> 2.19.0.rc0
>=20


Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

