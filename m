Return-Path: <SRS0=33X3=DI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF075C4727E
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 16:47:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 797BC2075F
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 16:47:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="X4283qo1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732803AbgJAQrd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Oct 2020 12:47:33 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:36346 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732342AbgJAQrc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2020 12:47:32 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 091Gjx6D156948;
        Thu, 1 Oct 2020 16:47:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=QJVjlnEPglxc9dDw8a6eVj9sP2pGnbCzt9sJAAwCCkA=;
 b=X4283qo1c1b6h5ksu5+TxdOmNvFwWcH2xOnjXJMkLv6+wXXxeWQY91pqTJnGvT6PMlpi
 3uiTpZahkQSwrrOJwKLTmzsQZ+t3fau4Sp5qpc7cHDieRHlrXSF1U3i9NTuJvsOPhER/
 cpXrmbIaV2wHBnx5Cocu2+QP5zTVZQ2GeK81b/Mowg0ZpyH6SE72vFZ/shHuUya9IMJN
 me5SXZd+SxzWUWAyKZZ9DNpM9wIbm2X6Dor+pwH5NPaCkbyPJeKL5sx11WaA6NPs2YKW
 hlXFYuykNBAErXrsbtRbji+M2vCwRZhIsr8wtYzZR4yPs6OnLam0IdBGHjk9N6MaZMG0 2g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 33su5b78c1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 01 Oct 2020 16:47:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 091GjqKP111841;
        Thu, 1 Oct 2020 16:47:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 33tfk1vvhx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Oct 2020 16:47:18 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 091GlHHD000879;
        Thu, 1 Oct 2020 16:47:17 GMT
Received: from dhcp-10-154-119-140.vpn.oracle.com (/10.154.119.140)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 01 Oct 2020 09:47:17 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH 1/3] scsi: qla2xxx: Fix inconsistent of format with
 argument type in tcm_qla2xxx.c
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20200930022515.2862532-2-yebin10@huawei.com>
Date:   Thu, 1 Oct 2020 11:47:16 -0500
Cc:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        Hulk Robot <hulkci@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <16EE7295-38DA-448B-A72F-7B50139D72D2@oracle.com>
References: <20200930022515.2862532-1-yebin10@huawei.com>
 <20200930022515.2862532-2-yebin10@huawei.com>
To:     Ye Bin <yebin10@huawei.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9761 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=4
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010010141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9761 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=4
 lowpriorityscore=0 spamscore=0 clxscore=1011 mlxscore=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010010141
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Sep 29, 2020, at 9:25 PM, Ye Bin <yebin10@huawei.com> wrote:
>=20
> Fix follow warnings:
> [drivers/scsi/qla2xxx/tcm_qla2xxx.c:884]: (warning) %u in format =
string (no. 1)
> 	requires 'unsigned int' but the argument type is 'signed int'.
> [drivers/scsi/qla2xxx/tcm_qla2xxx.c:885]: (warning) %u in format =
string (no. 1)
> 	requires 'unsigned int' but the argument type is 'signed int'.
> [drivers/scsi/qla2xxx/tcm_qla2xxx.c:886]: (warning) %u in format =
string (no. 1)
> 	requires 'unsigned int' but the argument type is 'signed int'.
> [drivers/scsi/qla2xxx/tcm_qla2xxx.c:887]: (warning) %u in format =
string (no. 1)
> 	requires 'unsigned int' but the argument type is 'signed int'.
> [drivers/scsi/qla2xxx/tcm_qla2xxx.c:888]: (warning) %u in format =
string (no. 1)
> 	requires 'unsigned int' but the argument type is 'signed int'.
>=20
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---
> drivers/scsi/qla2xxx/tcm_qla2xxx.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c =
b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index 44bfe162654a..61017acd3458 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -850,7 +850,7 @@ static ssize_t =
tcm_qla2xxx_tpg_attrib_##name##_show(			\
> 	struct tcm_qla2xxx_tpg *tpg =3D container_of(se_tpg,		=
\
> 			struct tcm_qla2xxx_tpg, se_tpg);		=
\
> 									=
\
> -	return sprintf(page, "%u\n", tpg->tpg_attrib.name);	\
> +	return sprintf(page, "%d\n", tpg->tpg_attrib.name);	\
> }									=
\
> 									=
\
> static ssize_t tcm_qla2xxx_tpg_attrib_##name##_store(			=
\
> --=20
> 2.25.4
>=20

Looks good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

