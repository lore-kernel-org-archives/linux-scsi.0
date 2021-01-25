Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C55AC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 05:28:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A1CD206F7
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 05:28:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbhAZF2R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jan 2021 00:28:17 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:32878 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727444AbhAYKYN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 Jan 2021 05:24:13 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10P9ZSDd025329;
        Mon, 25 Jan 2021 01:52:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=m6qGuHzQSkYN6uDOT5kTbmc4I59UuqyBRVG/chMkGvQ=;
 b=K39DW/ZNAjgUuWXAnGb6SXgHmwHSfX0thAND/DSeCxWQo2ZWweRbBM2g1a87qXaxzfSR
 eHni1obVctijA//+cl946Gmar+ijxpryHcrhK/9Kew3klG7UsuN2q/3GEyAhHhoS3DzO
 FXmatd2DhGpzD53N2yyRM+AKgXm1JWiGtzdsN6s48G7zJC3jEO2x8Hbult169ZAdGw5o
 wV2UXL0Wdz7y+IUVYb+6iyAgQL9sTy+IQJU1kVpGKIii+qfOLf3yc8w3eryET1ULQJAU
 W26t8mUFHrGMPT7gSaa2whI6uQy4ir0vgTHPwX1K5ve1eEL2XJQ984VDb5w6bRa9ICFT yA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 368j1u42kf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 25 Jan 2021 01:52:31 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 25 Jan
 2021 01:52:29 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 25 Jan
 2021 01:52:29 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 25 Jan 2021 01:52:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D0Rvm8QDoeDt5POneWX3PF3y7/1bDCpGNwfqmbdPu2ewF8/RNKPksHgChWnFixRHbzY/Qr+UDN3zekC9vCg8P5JrEOQ6wPHccvHP4Zi9fExN3dF95pKmcHuq4FCp59C/Z8dHt0l4+7RWClhEslWVylc5gIwX6mvK2vlaYqhE1A9N9CZ5120jT/j1hwlJDCQ+bu1lEKGT//khkyJjo1wJ6E8im4UEah5OLlKWQINcomMPfeO5/3Ir6wheofAmuirRNQPrdJZRCOMgGQgdN/+yM/b6FgNXY+4FWxffOxsh6fKlrN29QKwD2xHjGqCtQbaUoWNXvPhLbcrOxyMx5JtL1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m6qGuHzQSkYN6uDOT5kTbmc4I59UuqyBRVG/chMkGvQ=;
 b=KNI/NULdmNiT/yxwN6QLUPxXnB1lpZ5R03NZW0CVm4EhB+6VwtfWueWVfEtvJNWVVWh3Dy9aytqt6FNt/wuVui0utKwTsUk+fqv26ocH3+HiK6DhpBx2nfL4obYfNKwRZEyLoBIkgyRfiE4VDnIP9xlAx3zfpaXKdAAQm48i1PuCAHeblTD4QjbSSK4Tk36mORhxNjLHEfuWLMXdX/IV7/mDrws1lVvRySoUMVjYBHCtuNbAbwjKhocr787H0PNdpQeJXmQcwlWf4ddobr+BMDAoW8tdmAab3eUISq4Jys9ml5xQsjbcyJE0/kNZjItykSn+pYnr/KL8vZyAJGVzuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m6qGuHzQSkYN6uDOT5kTbmc4I59UuqyBRVG/chMkGvQ=;
 b=PoQMZeTh8aOXaxxOAcUJ8uj4kdErlxmnYjmagg3SoYkNsZHHElb1bsGRN1aDx64qJlKfWm66QctK7+xmR2ln0DScJjtIJVmjQDlmfZQ6QXPkYyJqbxC7LltH6IqQXh5OeiDq7w8QwCvaouotZzYYLq9z7IjXKwHLYG5J0KyXmfM=
Received: from DM6PR18MB3034.namprd18.prod.outlook.com (2603:10b6:5:18c::32)
 by DM6PR18MB3722.namprd18.prod.outlook.com (2603:10b6:5:c2::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Mon, 25 Jan
 2021 09:52:27 +0000
Received: from DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::455c:aa82:3f6c:95e9]) by DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::455c:aa82:3f6c:95e9%7]) with mapi id 15.20.3784.019; Mon, 25 Jan 2021
 09:52:27 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Nilesh Javali <njavali@marvell.com>
CC:     GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [EXT] [PATCH] scsi: qla2xxx: fix some memory corruption
Thread-Topic: [EXT] [PATCH] scsi: qla2xxx: fix some memory corruption
Thread-Index: AQHW8vZQqe0wROdeNU6MRb6tZasxpqo4GW/A
Date:   Mon, 25 Jan 2021 09:52:27 +0000
Message-ID: <DM6PR18MB303455B3BC025E7F82469A4AD2BD9@DM6PR18MB3034.namprd18.prod.outlook.com>
References: <YA6E0geUlL9Hs04A@mwanda>
In-Reply-To: <YA6E0geUlL9Hs04A@mwanda>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [103.103.215.229]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 207da384-2975-499b-5cc5-08d8c116ec6f
x-ms-traffictypediagnostic: DM6PR18MB3722:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR18MB3722DB8361C551FF32A98C22D2BD9@DM6PR18MB3722.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WR+g2FYgbLRlZLWDaZ/94Hzi535Sp3VfyAaMTmYDT89yOFnxZvk2blMbwpMqAiK1TG/7YH/6EyrJw5IlViVEMR09lutQILtVKWyO9krHZvp46CqFGuldczbZfQkgKrwG346Ft7ULLU8//LavnUrW2lk85kbkdnpMIVd3C/5sXtBKVeOISYdmYflb5Nz/Z7jYFsnJjVpbkjvwB/QbfRgomilpfqExeVcj33xmlAuKuWQCfzzbfjQXLwXeTPo60BZGQ7rx7gRCkTzbK2xfCZhbW+oJ5UDOEykX5mCUZXXx9l1Ff7XE121ZM2+A9Xy2r4EZ75Y98cgbZffNbaUfh61LimVvB6l/AVp/zAXTWKg1dMk8qxwatEsXinOK5frsZN741SHQYHuTbGbk0GRgf1qsXymUOTvdRB6eq9kRZQQ1+Mw9xH/TniONFjqBbFYGm2KGDRV9A3N6q1/BjZoRHkIW4a8u1B5fyIN1kUw1S8+IumEQas/oa0YwkuqApgx3u3bzg3dxlN7lKeDP5uQ8Ruv6/A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3034.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(346002)(366004)(39860400002)(4326008)(53546011)(478600001)(86362001)(83380400001)(76116006)(71200400001)(316002)(8936002)(7696005)(2906002)(66946007)(52536014)(8676002)(186003)(6636002)(66476007)(66556008)(64756008)(66446008)(110136005)(9686003)(6506007)(55016002)(26005)(5660300002)(33656002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?qpbIOVFhnYrnJkxY7bN46ZHIf7gHivOM1QJ1YXaOVOkAeVp52iQER4GJUvlA?=
 =?us-ascii?Q?Kcxh1qC8Si5HaM2ySmpPVtUy6Z/yhQGB4LJaIaHFdkXh4fkWZ6coMNjZfce4?=
 =?us-ascii?Q?rlMHF6ENSlKixQnZlgpdWKkeAT3ilkidJcs6MEoUd8Y9Vp1AihfOtoW/OJnW?=
 =?us-ascii?Q?MnRaRgOjIEWweKbDf8rYXtlxgc9coJZsLzuOhPE7FSxKxM6N1RXYfJLKqHUI?=
 =?us-ascii?Q?hWpNpt6h1Xq517b5ncGwuGGVHzo/muTtJsDEPxbz53qVcJ7ss1clfJCBqF0e?=
 =?us-ascii?Q?8qfQbHTrb4rcR8tmkXGdOyrdBzTzfis6+HZmC6FCrJUkbllBLKj/DEsKUN9T?=
 =?us-ascii?Q?BKF2V8CCYeZPS5xCTgq+j/sB49T5jQpfoSuo2Q5VpX88gpVcnUW7nFHP9kOa?=
 =?us-ascii?Q?Cyzt6ZtPMfLD7fuF9zAB+u/t85ct63B8KYzZAwRMk8Y5uLWDY6t7qtHjyGiD?=
 =?us-ascii?Q?Lp+e4bxcLAPnhNkcTluzT7woeseilPwjFkISMOwCucyPfm2jE4h2rLxd196Z?=
 =?us-ascii?Q?5B1CW7rbSImdgHLekMNpyDI1uwjriurTiW54Eg1gtyTg8MaLU0TTcmeyjVxh?=
 =?us-ascii?Q?o4WH9fKIYG/Xr7CozAom7SAhEqM+Tr5sDsjyBJa4C6PanQxafMnW4tah60vb?=
 =?us-ascii?Q?wN3nhLVReBO3601I7QM6cxPq7jYKZODBrrxkBWdFGBui9VKoAO3Zaf0sRENx?=
 =?us-ascii?Q?z4cak8pQBrVdavzFMQd/8sxGe32+xpS6ACTeCYHOOjlOqAhd4D+UKEy7Uiuw?=
 =?us-ascii?Q?sEA69Xc1gH7vBgOgosOpf5ZL5Mxpl9BH9dyzV3US2H535DdYiEfedlvA1fCH?=
 =?us-ascii?Q?cSnhAaSDi7+D32YziqkkHg/qmOq9WfYmjsDlj/xAEnQ57d55/tKyCr3N80d4?=
 =?us-ascii?Q?LXPju9MoLn/E8s4rto63zRaapjYWFjKFACTu5z24GPFTmcVS2k+BzWn+2kFI?=
 =?us-ascii?Q?lvTdTrvfsGF0i/ZAso4g4vwcgwQuU5XkkOBI1msr5EU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3034.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 207da384-2975-499b-5cc5-08d8c116ec6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2021 09:52:27.2168
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YQ3RtI/LiOQOGmFA1lnr6OoSe2Fy85IVXb3CrvKwGSVPHHfYfUuBeTPKV5GCyomI4favd2IJxemfDWFRExN8XA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB3722
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-25_03:2021-01-22,2021-01-25 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Dan,
Thanks for a patch.

> -----Original Message-----
> From: Dan Carpenter <dan.carpenter@oracle.com>
> Sent: Monday, January 25, 2021 2:14 PM
> To: Nilesh Javali <njavali@marvell.com>
> Cc: GR-QLogic-Storage-Upstream <GR-QLogic-Storage-
> Upstream@marvell.com>; James E.J. Bottomley <jejb@linux.ibm.com>;
> Martin K. Petersen <martin.petersen@oracle.com>; Himanshu Madhani
> <himanshu.madhani@oracle.com>; Saurav Kashyap
> <skashyap@marvell.com>; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org; kernel-janitors@vger.kernel.org
> Subject: [EXT] [PATCH] scsi: qla2xxx: fix some memory corruption
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> This was supposed to be "data" instead of "&data".  The current code
> will corrupt the stack.
>=20
> Fixes: dbf1f53cfd23 ("scsi: qla2xxx: Implementation to get and manage hos=
t,
> target stats and initiator port")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/scsi/qla2xxx/qla_bsg.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index e45da05383cd..bee8cf9f8123 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -2667,7 +2667,7 @@ qla2x00_get_tgt_stats(struct bsg_job *bsg_job)
>=20
>  		bsg_reply->reply_payload_rcv_len =3D
>  			sg_copy_from_buffer(bsg_job-
> >reply_payload.sg_list,
> -					    bsg_job->reply_payload.sg_cnt,
> &data,
> +					    bsg_job->reply_payload.sg_cnt,
> data,
>  					    sizeof(struct
> ql_vnd_tgt_stats_resp));
>=20
>  		bsg_reply->result =3D DID_OK;
> --

Acked-by: Saurav Kashyap <skashyap@marvell.com>


> 2.29.2

