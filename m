Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6BA0C64E7A
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 15:55:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A571208FE
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 15:55:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ka3N8E22"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390635AbgLAPzW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 10:55:22 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:51066 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388395AbgLAPzV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 10:55:21 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1FYvg7135254;
        Tue, 1 Dec 2020 15:54:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=oTRezXP8fYQXBApH8Z9w8Fq6cyLJVEVwhcNEDkzwRYo=;
 b=Ka3N8E22cHUHvbq625E/NrZk9t1BuM1iGFoK8E8EQTvQJXgx+ZK+u50s+c7+VOC+K+ja
 iK0AXjAW1H9Aw14L3NHQF6EIZe8pdy2cZS8/l5ZxnebNe/urCfhDrLo88Sej4QUOUeJs
 LYsNwT7xIrWmdVrJtgvrWuuKKxPpoMSEDqqjesev7KNxRxlmhkqM9Nm76H+566nzrvow
 KJ2nNvSibuA+HbSyehbd6vmBuVMxxB1tnpOagIyngb5MIw5jhxUmcol8EIAoimYYjEVN
 jnMhgeBW9MqaGA4WGn7fGAM4W+T3Fe5jN4nS3tMjQLC82xAMNGu9tZGtH+xoTatLreXp YA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 353egkk891-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 15:54:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1FU4up109963;
        Tue, 1 Dec 2020 15:54:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 3540ey4yrk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 15:54:39 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B1Fsc8p029112;
        Tue, 1 Dec 2020 15:54:38 GMT
Received: from [192.168.1.15] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 07:54:38 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH 07/15] qla2xxx: Fix crash during driver load on big endian
 machines
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20201201082730.24158-8-njavali@marvell.com>
Date:   Tue, 1 Dec 2020 09:54:36 -0600
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <163A0E1F-D1FF-4408-9FA0-6E61FA1BC46D@oracle.com>
References: <20201201082730.24158-1-njavali@marvell.com>
 <20201201082730.24158-8-njavali@marvell.com>
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
> From: Arun Easi <aeasi@marvell.com>
>=20
> Crash stack:
> 	[576544.715489] Unable to handle kernel paging request for data =
at address 0xd00000000f970000
> 	[576544.715497] Faulting instruction address: 0xd00000000f880f64
> 	[576544.715503] Oops: Kernel access of bad area, sig: 11 [#1]
> 	[576544.715506] SMP NR_CPUS=3D2048 NUMA pSeries
> 	:
> 	[576544.715703] NIP [d00000000f880f64] =
.qla27xx_fwdt_template_valid+0x94/0x100 [qla2xxx]
> 	[576544.715722] LR [d00000000f7952dc] =
.qla24xx_load_risc_flash+0x2fc/0x590 [qla2xxx]
> 	[576544.715726] Call Trace:
> 	[576544.715731] [c0000004d0ffb000] [c0000006fe02c350] =
0xc0000006fe02c350 (unreliable)
> 	[576544.715750] [c0000004d0ffb080] [d00000000f7952dc] =
.qla24xx_load_risc_flash+0x2fc/0x590 [qla2xxx]
> 	[576544.715770] [c0000004d0ffb170] [d00000000f7aa034] =
.qla81xx_load_risc+0x84/0x1a0 [qla2xxx]
> 	[576544.715789] [c0000004d0ffb210] [d00000000f79f7c8] =
.qla2x00_setup_chip+0xc8/0x910 [qla2xxx]
> 	[576544.715808] [c0000004d0ffb300] [d00000000f7a631c] =
.qla2x00_initialize_adapter+0x4dc/0xb00 [qla2xxx]
> 	[576544.715826] [c0000004d0ffb3e0] [d00000000f78ce28] =
.qla2x00_probe_one+0xf08/0x2200 [qla2xxx]
>=20
> Fixes: f73cb695d3ec ("[SCSI] qla2xxx: Add support for ISP2071.")
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>

I think this needs stable tag as well.=20

> ---
> drivers/scsi/qla2xxx/qla_tmpl.c | 9 +++++----
> drivers/scsi/qla2xxx/qla_tmpl.h | 2 +-
> 2 files changed, 6 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c =
b/drivers/scsi/qla2xxx/qla_tmpl.c
> index 84f4416d366f..a6bb1c0e2245 100644
> --- a/drivers/scsi/qla2xxx/qla_tmpl.c
> +++ b/drivers/scsi/qla2xxx/qla_tmpl.c
> @@ -928,7 +928,8 @@ qla27xx_template_checksum(void *p, ulong size)
> static inline int
> qla27xx_verify_template_checksum(struct qla27xx_fwdt_template *tmp)
> {
> -	return qla27xx_template_checksum(tmp, tmp->template_size) =3D=3D =
0;
> +	return qla27xx_template_checksum(tmp,
> +		le32_to_cpu(tmp->template_size)) =3D=3D 0;
> }
>=20
> static inline int
> @@ -944,7 +945,7 @@ qla27xx_execute_fwdt_template(struct scsi_qla_host =
*vha,
> 	ulong len =3D 0;
>=20
> 	if (qla27xx_fwdt_template_valid(tmp)) {
> -		len =3D tmp->template_size;
> +		len =3D le32_to_cpu(tmp->template_size);
> 		tmp =3D memcpy(buf, tmp, len);
> 		ql27xx_edit_template(vha, tmp);
> 		qla27xx_walk_template(vha, tmp, buf, &len);
> @@ -960,7 +961,7 @@ qla27xx_fwdt_calculate_dump_size(struct =
scsi_qla_host *vha, void *p)
> 	ulong len =3D 0;
>=20
> 	if (qla27xx_fwdt_template_valid(tmp)) {
> -		len =3D tmp->template_size;
> +		len =3D le32_to_cpu(tmp->template_size);
> 		qla27xx_walk_template(vha, tmp, NULL, &len);
> 	}
>=20
> @@ -972,7 +973,7 @@ qla27xx_fwdt_template_size(void *p)
> {
> 	struct qla27xx_fwdt_template *tmp =3D p;
>=20
> -	return tmp->template_size;
> +	return le32_to_cpu(tmp->template_size);
> }
>=20
> int
> diff --git a/drivers/scsi/qla2xxx/qla_tmpl.h =
b/drivers/scsi/qla2xxx/qla_tmpl.h
> index c47184db5081..6e0987edfceb 100644
> --- a/drivers/scsi/qla2xxx/qla_tmpl.h
> +++ b/drivers/scsi/qla2xxx/qla_tmpl.h
> @@ -12,7 +12,7 @@
> struct __packed qla27xx_fwdt_template {
> 	__le32 template_type;
> 	__le32 entry_offset;
> -	uint32_t template_size;
> +	__le32 template_size;
> 	uint32_t count;		/* borrow field for running/residual =
count */
>=20
> 	__le32 entry_count;
> --=20
> 2.19.0.rc0
>=20

Otherwise.. Looks good

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

