Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B943CC433E2
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 15:49:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56DA12087C
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 15:49:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m20sc749"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731369AbgIJPsS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Sep 2020 11:48:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41628 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730408AbgIJPrj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Sep 2020 11:47:39 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08AFi3QK170647;
        Thu, 10 Sep 2020 15:46:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=ZrPymd9ayEA4cEcw3vDr1WFAm1EWnYzLuplMs/4TKLM=;
 b=m20sc749FdVxnhmEEW5/6EvnIgw2LDyP3JgxSiRKXnsMWrzI6I2QZmeW0dys+OGEsPb8
 iLKvtsqFxakLEv0wqQ641YYUTkP+aaXVvvaQVgcQyRe7jDPIy3K2ycjlG3t1HOI98yQo
 cXAhXyKQmmxIA7sZ1tVculupnLo7VAm9tzneryCh+4amw219TMNtiFO7gNauSWQETZiQ
 7kEcV8p8pzsh7CMPlHM6lcmqvdABcnJxvea40xu9xYgj3FO9f8TeGtUFTYJ+9tWYW2wO
 Drsuve7Ihxj6vtTACUgEaIf1ILt3A9BTQh7xlgd42lGbrWcZxDLMY9oWwBL9U4pNR6Ik Bw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33c3an8vvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 10 Sep 2020 15:46:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08AFjq5k159552;
        Thu, 10 Sep 2020 15:46:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33cmka2wvs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 15:46:27 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08AFkRJH000356;
        Thu, 10 Sep 2020 15:46:27 GMT
Received: from dhcp-10-154-107-125.vpn.oracle.com (/10.154.107.125)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 10 Sep 2020 08:46:27 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH v2 3/3] scsi: handle zone resources errors
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20200910074843.217661-4-damien.lemoal@wdc.com>
Date:   Thu, 10 Sep 2020 10:46:26 -0500
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <4D07E3FF-38F9-4B80-94AD-56D277EB6069@oracle.com>
References: <20200910074843.217661-1-damien.lemoal@wdc.com>
 <20200910074843.217661-4-damien.lemoal@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9739 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009100145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9739 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 clxscore=1015 bulkscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=3 adultscore=0 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100145
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Sep 10, 2020, at 2:48 AM, Damien Le Moal <Damien.LeMoal@wdc.com> =
wrote:
>=20
> ZBC or ZAC disks that have a limit on the number of open zones may =
fail
> a zone open command or a write to a zone that is not already =
implicitly
> or explicitly open if the total number of open zones is already at the
> maximum allowed.
>=20
> For these operations, instead of returning the generic BLK_STS_IOERR,
> return BLK_STS_DEV_RESOURCE which is returned as -EBUSY to the I/O
> issuer, allowing the device user to act appropriately on these
> relatively benign zone resource errors.
>=20
> With this change the NVMe (ZNS) and sd drivers both return the same
> error code for zone resource errors, facilitating the implementation =
of
> IO error handling by the user with a common code base for both device
> types.
>=20
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
> drivers/scsi/scsi_lib.c | 9 +++++++++
> 1 file changed, 9 insertions(+)
>=20
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 7c6dd6f75190..1b5c2a6ad072 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -758,6 +758,15 @@ static void scsi_io_completion_action(struct =
scsi_cmnd *cmd, int result)
> 			/* See SSC3rXX or current. */
> 			action =3D ACTION_FAIL;
> 			break;
> +		case DATA_PROTECT:
> +			action =3D ACTION_FAIL;
> +			if ((sshdr.asc =3D=3D 0x0C && sshdr.ascq =3D=3D =
0x12) ||
> +			    (sshdr.asc =3D=3D 0x55 &&
> +			     (sshdr.ascq =3D=3D 0x0E || sshdr.ascq =3D=3D =
0x0F))) {
> +				/* Insufficient zone resources */
> +				blk_stat =3D BLK_STS_DEV_RESOURCE;
> +			}
> +			break;
> 		default:
> 			action =3D ACTION_FAIL;
> 			break;
> --=20
> 2.26.2
>=20

Looks Good.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

