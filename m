Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CF4BC4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 15:58:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DE3561131
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 15:58:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242864AbhHEP6b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 11:58:31 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:57704 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242690AbhHEP6b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 11:58:31 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 175FviqI016182;
        Thu, 5 Aug 2021 15:58:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=YhPvZEjmZUYEy72yfB/RfXLdGRV6uMvbp1j3Mu1C8GA=;
 b=DGxXeNcERs5zled60GMwErSapU7FOYzf5s6e5jgltE+k1o343wNXP4Yiosl9Kf2U02DT
 imQNFtWhCU5TProV9zjcYCPjn1BysImXrHBG0I8i5XvjU+0LCKPERiksFLOeudgQYdiA
 F2VeVek7UJ9hG8g/Yd9kBzAkKbNLoh6wYZC9PsJAqbGIvCGqcbwtnagvjiJU6Y/EllQc
 +otjDnyOJJwx4x4JEskdr6IRRp6zxQfQ3kp+AdDJfEFPJ/xaXWRw2ZpllC5nrVsuQbcH
 rsyxXUmV/JOpbKW8DuCnv6j2u+3/01+XAJLLPGAKOulMu0QpL82BP1D+fOgW0piL5cZa IQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=YhPvZEjmZUYEy72yfB/RfXLdGRV6uMvbp1j3Mu1C8GA=;
 b=z7rRPk0Ed1DZ3xeP3JFbjCljxA/ph1IXEB6KcpeFxp7kwLHP7acSoH6bW1km/W41yXpN
 70Qm74rcG28H7MknjmskHvJVio29XA6ZeGCz9RpNoIXqPOC3KHYF2FNs24IN+eCIFbJe
 FI+2BdfDDeR6t2hkk15ELDwCIzC7YCBnDNFD9YCHTLA19apZL9LDMoleznu5fMc+SikD
 uDORPX/5YIkXQlHG8ULwH3W4odiApP5tjKUnRlQmfM7JsLvw6altRTd3ZojWXKdh+kcJ
 B7K3XF44gS4G+Ll9yMpXJFWbzUXykZAgqODPIzV2Q7UZx9fXSV0WrVdrpRGTWYVT2WuD xQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a7cxn4pj3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Aug 2021 15:58:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 175Ftba9058090;
        Thu, 5 Aug 2021 15:58:13 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2043.outbound.protection.outlook.com [104.47.57.43])
        by userp3030.oracle.com with ESMTP id 3a4un40v4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Aug 2021 15:58:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hOFZd/bjseOSo4MjMFFJ/aFL8n1ihcsNbQGH7VsvPFRtRHjpEfB1W2tjt41nPUeEE7PDPaw0VT7NYhPPxCmBT5e/5QQUHvH+/jL7bGa1KZXr2XvjF4pnkMVYb7rNJZ1DniI1+epiSUjHHVYI5/G6H/5lkBNkmFcu6VD0VvbdWOEHtMxbdirCnSrLjFag1x5bxM2TPyC1EGhUjP0O8TIBFTTGoqhW2XsuXwB34SFivTGiHxXaasGSRcACq1wkC+cXhUiBCzOyT/fZ152OmiaWOormllse2ivbS7shofUz28NBBmDFZeNe3lXwKNzY1c54rqNngPu8SmveDMmwTn0Zsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YhPvZEjmZUYEy72yfB/RfXLdGRV6uMvbp1j3Mu1C8GA=;
 b=C2lM78EAhU7S/G4IA/kM9QVxxKzdU8HAT3lR1fdzVlkhyzde54SuxJ2dswIUGpnKCW86IdbFtZVIPkwlyNBXJ3OpGdJWHaCkVITlcnXVGfTUmijdCOG2AAR2XlXyjS/ynyuTa6kd/KrCgJZ2xzLRUvTl14Xx35tRtd0Wk2tkXgtRMyrv0FUhRhZ4ZnkXvL1wnZ8tOVuksQqrFFOoHP81JRm/tPXW/CkbNLVwXsnLX2ZcVCdIZ0qCv2q1bTCDjXj0H64i6hjg+dojIla+PmjiINo3VoYQ4sf+OJJW3E7OoP14PClF9Rjn45JQoC3O+DyCqEqLvoGX9OfrMpkI0Oe+Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YhPvZEjmZUYEy72yfB/RfXLdGRV6uMvbp1j3Mu1C8GA=;
 b=XhXPc1WuVZJU8ES6ma7v85iogVZ7l354x/pkzBh2eUp6XN/IRYg5UrCqAKhxND+Zt3kV3rwYiNhpFeHxHduw2yIQckZ7Q/PYE1YyolluauUwbsX/EZl++Sr74HtCrIV8ltLPix0SPAmQcAxQ3NRqWzxbEGt5AeSVuHHkLq64kow=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2941.namprd10.prod.outlook.com (2603:10b6:805:dc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Thu, 5 Aug
 2021 15:58:12 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::7c0c:7f1d:bbb2:b43]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::7c0c:7f1d:bbb2:b43%5]) with mapi id 15.20.4394.017; Thu, 5 Aug 2021
 15:58:12 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 14/14] qla2xxx: Update version to 10.02.06.100-k
Thread-Topic: [PATCH 14/14] qla2xxx: Update version to 10.02.06.100-k
Thread-Index: AQHXieRS/w2iMah+zE2LacnghB6JKqtlEZiA
Date:   Thu, 5 Aug 2021 15:58:11 +0000
Message-ID: <C4D3D8B1-2DC1-46D0-BFAC-088137F8D72A@oracle.com>
References: <20210805102005.20183-1-njavali@marvell.com>
 <20210805102005.20183-15-njavali@marvell.com>
In-Reply-To: <20210805102005.20183-15-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a909b6c0-ebbc-4ed3-f289-08d95829d3cf
x-ms-traffictypediagnostic: SN6PR10MB2941:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB29416BDA1358F33E41FF1F98E6F29@SN6PR10MB2941.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aDMEq5qLrtP0cNAI4vOyErB+6f/dynGXxJTD/qx9Js7anVvD/RYPHB2YUdC8zeFWOomtMGrEXo0CN5nBABMnb+NiqJkB4a5N/FGWSM15fqZwsww+Z/sBGF17pp9hYogGzF+jzD5ZANIufyo3snIStF+KW17cB2zbeY2Uk1iQiOh5RsL6/DUZi0ZeT+ONduBGa93AgEaIcgjLTgi6icEuXoS4d+9jrv+ua7D+jFuhrDT10LITD3jk9kQ6Bb1Nb0K4zon9SAR7mHeNtrvAS6DEO9bRffMIlml0ckgVHXnldTLVWathSQlRJInoI4zr0515hVtrD3TIePTHoWjk2ElpDriWKiNAea8DkWb3uKA9qVWQV+OPlPEi5igK3NXM0bPrIE90XW/KmWCtx7vJHLwRnTrpzWKMpp9/Xegexx2glwQZEYpy8V37NW2s6ZUMvKJtNa1lCtqcci/QGyygNTWtNkBVrv16/UUp4/7cJRh3pJOjp4DOAPUHxWGWwOVX7Nt0ifunqNeJYHcDuO692uN4LvHqSy026u1y0MSLFEhvHJCs+qLdlW/IkkxOk7oBOIDaUk44/iGKLln9Y+ZaCxNgonS+oC5wxJCXT56BulIvOxMr43a74dknoNktA4AZ/QvjAKd3TcBHA54IRVoY6cm1FhoDfHW3tIc/Mvc/2i1AYSvzInmekDBGBGfzUXmwckcSjFrfWnoGGhBq1iUHET+4ABoD8id7p3I5RCHP42vGZ+AkcAM/UJJAP6ImpA6UPSxk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(376002)(39860400002)(346002)(366004)(4326008)(53546011)(6916009)(38070700005)(4744005)(76116006)(8676002)(86362001)(8936002)(6512007)(38100700002)(316002)(2906002)(83380400001)(26005)(186003)(66946007)(2616005)(122000001)(36756003)(44832011)(478600001)(6486002)(5660300002)(6506007)(66556008)(71200400001)(66476007)(64756008)(66446008)(54906003)(33656002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xO6iMvwHh761angJLconBweYJx4aym4ZT9GyW4UKMnqmDZdH1HdijamhSuAU?=
 =?us-ascii?Q?eE5OyZK+6KjBGDGiQPBL3ee7R4hEK2kjC0KY9uaAhk9TqWAH7gRHAc2cJuNy?=
 =?us-ascii?Q?afPgS0FE4PRkcweHgNHiGRQ1GvZ6qumOPBIJyq35eKhbKHH+KL7Cq6m0WDXU?=
 =?us-ascii?Q?msWeb2qnYcbl1opXrIFPZ9KemLDligh+EujCC2EDwIt8yINF1yHeB1gx46W7?=
 =?us-ascii?Q?atzW0cv5TmXKQlG7e/Wcct9pWOtp7l9PtO2fueN3M7kXth/lQFOYRbPXuHYC?=
 =?us-ascii?Q?nY4f68VmNY/SnMWvuUEAgywuai/hjEt3j94adaM/nqVMnBNFG2X2Bi4x1ZMm?=
 =?us-ascii?Q?GpsgW1UmLjnRK5Ufbo6l8T8Da1fTQSZCYw9DqsIk1EAotZLHGqNL9nSa7hB6?=
 =?us-ascii?Q?vwVXyU4NNmDEiV6qp6t6poWmeRO3mI3c/2bznzLgAwiUx4hXH+oAu0jS2w/W?=
 =?us-ascii?Q?HeBamMyG5DQy3eDY/ZGHJaFUc7KTeKkcoD/spxihHuEi68no5POVSgbxB+Uu?=
 =?us-ascii?Q?xb4LIKvl/gTGenhj7bquwtQb1et723ZdxLoXVaz+K96AI9UHti4Ec9HM8DSI?=
 =?us-ascii?Q?hZ9IXYpH5jcbnpyjK+TqhUQqO7E8D/aYlqSnw4grMadh6UKVkoZM7zRpFwkK?=
 =?us-ascii?Q?HTUU13YN3+G0xaTUipouLQtffhNhSssBiXbydlVqIAJiWlDwPr9m5iEanFJt?=
 =?us-ascii?Q?2I8ZO/qZybTSOIHu5BhuwA9TkENAfQJEBBzVoC9NEtfH38+58p90bWNDCDVB?=
 =?us-ascii?Q?/CUWy25Lsw3ALQp5uqk9eSelaQf5TCe+YR+hcdewDweTAafT1IqXjA/7DEe2?=
 =?us-ascii?Q?9PzhXZZ5Upzlbi32BaPOwNYMMYx7vfl+22Oaci21f1QglF+tWPbAxX738Y1O?=
 =?us-ascii?Q?q7M4cVKVEGTux6ocBtPEvmxjzWpHrMc0rIkPowGl6VQOFh+Ej/vY3rYR3Yeu?=
 =?us-ascii?Q?dJnVmpmOnmDWocKdgu2ipy7XsWfGG2apijBsoYfYg5kIN0+sVNXL26xcBEus?=
 =?us-ascii?Q?8wg22tbMj8MoGgDLr9VieUJ2NQh/0AAslgFrAM7rYzg5XaUyr3GJRI0O6Y51?=
 =?us-ascii?Q?swdOVsNAxeORPRvwqwZLlDpd8PPEauE9yIVb4NEgtYvWEfhcbk2Go7qTBHAx?=
 =?us-ascii?Q?FxgBH1VZ0qF3+MpHJSSoWmeHuP27gd8GBwR8DQf3vt7v6VLTho+ucDZcmIZN?=
 =?us-ascii?Q?J2z2DVVsUAyajA1AiiAOyotnqJjhBxcqgF3mlWnnD1G3lr/SvUaqg64+rg43?=
 =?us-ascii?Q?tzfcBAcZHwPOr1E0I8frUnS2qFdG6WHcZkkfwaT4ixjGCvrZ81s+oeqG4YFl?=
 =?us-ascii?Q?myYKe3kkAhBn75WzxN6AEl3YP3BDJqpoO1QsxdbgCb83qA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BBF79CAD2ACD1E4B9420938017266792@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a909b6c0-ebbc-4ed3-f289-08d95829d3cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2021 15:58:11.9520
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zhx2xcYA1SCkbOiP81SSDDRXPbO4BRpaUYoDzSXg//LusIfIpA+IyIy7AcZxH79rtihb7+GcJpo7L+XclydvTE9hgpwtIkroAn5VjELO/4o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2941
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10067 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108050097
X-Proofpoint-GUID: yZjZA4TR5dlt2rqnUyy-oohT5udwTSLt
X-Proofpoint-ORIG-GUID: yZjZA4TR5dlt2rqnUyy-oohT5udwTSLt
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Aug 5, 2021, at 5:20 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_version.h | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/ql=
a_version.h
> index 2e05dd74b5cb..8b0ace50b52f 100644
> --- a/drivers/scsi/qla2xxx/qla_version.h
> +++ b/drivers/scsi/qla2xxx/qla_version.h
> @@ -6,9 +6,9 @@
> /*
>  * Driver version
>  */
> -#define QLA2XXX_VERSION      "10.02.00.107-k"
> +#define QLA2XXX_VERSION      "10.02.06.100-k"
>=20
> #define QLA_DRIVER_MAJOR_VER	10
> #define QLA_DRIVER_MINOR_VER	2
> -#define QLA_DRIVER_PATCH_VER	0
> -#define QLA_DRIVER_BETA_VER	107
> +#define QLA_DRIVER_PATCH_VER	6
> +#define QLA_DRIVER_BETA_VER	100
> --=20
> 2.19.0.rc0
>=20

Just curious..=20

Why bump Patch version for the driver? And numbering does not make sense.. =
please explain

--
Himanshu Madhani	 Oracle Linux Engineering

