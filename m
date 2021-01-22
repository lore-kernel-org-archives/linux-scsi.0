Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72BA3C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 22:22:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35A1623A5B
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 22:22:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728987AbhAVTzG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 14:55:06 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58318 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728385AbhAVShx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2021 13:37:53 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10MINhCh182174;
        Fri, 22 Jan 2021 18:37:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=TB2lu95oYPbwuvKsip6UpvzNleBkCP/+rNeWtHhERGs=;
 b=dFjKOfYZ9Cygf3jcwSKlIL8SRV/sqvVTMLxO5Le/M9F38b+7ZAJYgZWOE3TIas82YgQc
 Ska9EhBbmtpNYNLMBA6Rqi2xQNjnrjj5MLZnMzAfdMIge4Vv6eMehj2zLpllWhtFFBXa
 y3UI+oX597j6UWe4YWqV8mII/TgUGK93wP+Z4rAhki4/wxumL3UwaZ8a3azc6fbA8eCj
 kx+xbs0Y7UsvUJ8uiB2URiAZXIYm0KKH1mElgGJLJwWf0i3Sgxe6Z/v/urnWhbvG7Z70
 tY+x2t4gul+KwpU0wzsn+Xd4gj/lD7rTKG6awQ/gaFU4pZpDQP2mPi2DZ8Tqu4zGx0v5 lg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3668qanhw4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 18:37:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10MIPqd2169002;
        Fri, 22 Jan 2021 18:37:06 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by userp3030.oracle.com with ESMTP id 3668rham98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 18:37:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TGOTfMHuta8vfmJRkt5H8NjeZaXv7SaqOrogb3/EVn6bb4FCyMoJSUUia/GhJ3Hi5Q/rcAMHncnPb6L/bgHfyyT/47m1nDgbbZ6J+NS+WgoMv6h+JYKq1XYQVwpnGl3VGtAcD8ITFcMonqH9TJW6K2vOWs2QTi6xvaSJcJTUdN+KADEGetPNBQN2m2t7dgCuuLcVLw2GbPerVr/UN1XVCgNEb8kMp1hXdBgxIcKoX+K7bLpy4sHNDlNe5rdEwhj8N+8NCSu27ZoyQxHM49iqXOF4WkOPTH87MiZ2l0D+aGVDLNUez8dn8BN+knjUju5NBIckYmUB/xwv7rRR7EpaTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TB2lu95oYPbwuvKsip6UpvzNleBkCP/+rNeWtHhERGs=;
 b=oBIdMrjDMWZgCjA8N9EqLRc0Gzccx059Wi6hObfyNnL8oB0fG26XRw/ttijOJ2yIeeEhqxaVxdAd8n8MdG1GprfzDG1vttwgQki8ZEA5zbrku09iPHBULo1j/uo9iUED0Vs9JrUGoo51uowDnIwum+uLfd5fMiX7TsDAeQ6RJC45hzFcwx7JCPFwWX/0LkMNTXiBJaJXvVlxbvGueAXIVzmia3MeE1rn85TwuI8AAUhCWOuEjR+vG3NbZMwG5gHOrupIryndZPTAg7HU8zn81EOhMAnMjPTHxop/XoPC5qOj9+4Pnsj8rIrPtLpKYo2/pqLIDn9ZJGYFuwr1YXmh5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TB2lu95oYPbwuvKsip6UpvzNleBkCP/+rNeWtHhERGs=;
 b=gPdWrjkg1tnPk/6ohbATb+WO/f+0vKQhdq9a2vpdWTTzbvN59ypDmNUG5FpLUEXMZqnNjSdBsgiqQfPN03tPAUe+DDEwSVTRHp4Kb919qRG7PbNJLMkL1xK5RMwBVsJeYC482b4bzZ7PgZ/5/30bMmsSrgBs+QOA7+Ng15UPa0M=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4537.namprd10.prod.outlook.com (2603:10b6:806:116::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Fri, 22 Jan
 2021 18:37:04 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::793a:7eef:db3b:ad48]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::793a:7eef:db3b:ad48%5]) with mapi id 15.20.3784.015; Fri, 22 Jan 2021
 18:37:04 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Yang Li <abaci-bugfix@linux.alibaba.com>
CC:     "martin.petersen@oracle.c" <martin.petersen@oracle.c>,
        Martin Petersen <martin.petersen@oracle.com>,
        "njavali@marvell.com" <njavali@marvell.com>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "mrangankar@marvell.com" <mrangankar@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] scsi: qla2xxx: remove redundant NULL check
Thread-Topic: [PATCH 1/2] scsi: qla2xxx: remove redundant NULL check
Thread-Index: AQHW8KJy5TzZ1D8KyEueth5b35ly36oz+eKA
Date:   Fri, 22 Jan 2021 18:37:04 +0000
Message-ID: <984381A1-692A-42DB-818B-0A0ACAF57D10@oracle.com>
References: <1611306174-92627-1-git-send-email-abaci-bugfix@linux.alibaba.com>
In-Reply-To: <1611306174-92627-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.alibaba.com; dkim=none (message not signed)
 header.d=none;linux.alibaba.com; dmarc=none action=none
 header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f524e6c3-8437-480f-04f7-08d8bf04b6d8
x-ms-traffictypediagnostic: SA2PR10MB4537:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB45378F449A78922D730CD4A1E6A09@SA2PR10MB4537.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:268;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3ksLnLqQVJkKqcSyvJZQMFBAej7O0rYRHxMTWm3kj3gNBnVuNoZtbzBGxqTTzQZ4o+QQrRaGi8f7ici7ekE7uYBXStkjJvRmX+Rvdgcj3vJmXU2A2H8eckTR4zNwwOnB3smizRUBR9rkYe+AI7USbRIlpaVM5GTU4kEUoCuj+6xrlNSXYtZLpWutoyripbt1hPyit6N/OCuj3b8ozoRP9FF+wZBC6HCLfNL9CRntDiEyAnl3v3YcBDME4HNEFCJLEF/8eHJV01XeRyf8OUBB1/mUtaMh69WPBHNPSylyTll3c4zuD0DLRMavaYr1oBtsTs3dzwz6AGOEqR4o+luCtBy+oIhCJ/Hz0zZ23MfHUFQhAuJSX257zoX9WZwXlr5SyqjIjK7cTyfLNT5SY6CX2DRJLFZwQjW7UwOCQ1hUYUEQe2gc5CXS9sY3LHPeCura
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(396003)(346002)(136003)(39860400002)(6486002)(71200400001)(2906002)(4326008)(53546011)(6506007)(6916009)(186003)(5660300002)(26005)(8936002)(66556008)(66476007)(66946007)(66446008)(64756008)(76116006)(8676002)(33656002)(478600001)(83380400001)(44832011)(316002)(6512007)(36756003)(86362001)(2616005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?0nvDCIc7nQ/dyV71T+ojPzDMLOU//e7YKKOhyauZMLUN6AeIxhImwN16OBvl?=
 =?us-ascii?Q?I11YnMxWs+VZWRnXpJFL0ZuZ5Jn+x8OZVFeX99fxRzyQPcKrdeQMqHXNGj2L?=
 =?us-ascii?Q?XKHI+YHIqMw+j5VT0bhqa/tpEcvxQe24irxya3Vjgd97EymWOqudcdnGltYK?=
 =?us-ascii?Q?OTydgpQA+8UAMj1tPT1iEEWisQ1eaYSAeSC/4126qK9boSeWHZdM6izsWjfK?=
 =?us-ascii?Q?1WLFYqhAto03GQIDJjDZ8pJVcVZI0KY/0qoQR+WaJTzVPYPgGFg2SBvXn52Z?=
 =?us-ascii?Q?DhWre69RYLKvDZsSY/fP3uToh+B+HZNW7iEQjQxpowitO9xTb0Ma4OeaY65h?=
 =?us-ascii?Q?HpcRFldfhyRVALe7t4OVNizEPMxhjrnejm6+h1nTBYPqOTf3gH8Lb5n3gfLV?=
 =?us-ascii?Q?+9QFXxECH34f5HebCbW6mMSUzmalKaraIqm556Y0FTrjfMsueM8heZGKquWL?=
 =?us-ascii?Q?M0Pv4nzxgrxslNlw58ZWmW48Fh/5QB0AHCSc29ViHgqC/9YkOi0JW4G3Yig1?=
 =?us-ascii?Q?wdScEchhkPWIWVmy2PvNumG+XFNm8U/N0azhoqmnHwYqsRZMHgSsd1dWSwy+?=
 =?us-ascii?Q?uWQWyfhPghpLvbpLJNz/w+buh7EaITTwtgkKyMMh8AsDwG4XCEDYfnEbL8bi?=
 =?us-ascii?Q?zrUGJQi3+qw0BydSHb9wXf2hfgj5zL7WdrvhU3sWpoBpA/6FbXCpd++Ia9P7?=
 =?us-ascii?Q?xIPDqq5QSGopIXViygeJKRZ6xFjYj91B94xdUXQ/s3fuAu2yZdLeK6xKjbO+?=
 =?us-ascii?Q?3H5Ofhksw1a4SDPvh6ZqZ5CywQYzMzIUy06qUBdz1vaTsxrmJX4c3rzBgghY?=
 =?us-ascii?Q?VKG3FwMaabcNTzqklYB0+C4ICLIbES/2D0dC/KIl190zZVFWZBuzfveydkf1?=
 =?us-ascii?Q?dtW+w6Orct93nI+uNfrSn5n5fzjMSOTHufshgzmDJa8Q24qiO9/cyRfn+b+r?=
 =?us-ascii?Q?FkY+29aaKOmT8VvT9rLiB27DAW0fc1UHJ/B0xqMJ9cblNekxAWFxHyEQET4S?=
 =?us-ascii?Q?DMkK?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E370B735ECD4A74A95F96560AF53C580@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f524e6c3-8437-480f-04f7-08d8bf04b6d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2021 18:37:04.0210
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GgetlFxorEjoZYL+bci8RCETzrlO8JYpuMy+Vu+tqoAItM4cHxTKbVOoN43t48UAFStpK+3olWwKxoZQfen/ujsmd8lALJKYX9S6CL8xhHQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4537
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101220095
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1011 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101220095
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jan 22, 2021, at 3:02 AM, Yang Li <abaci-bugfix@linux.alibaba.com> wro=
te:
>=20
> Fix below warnings reported by coccicheck:
> ./drivers/scsi/qla2xxx/qla_init.c:3371:2-7: WARNING: NULL check before
> some freeing functions is not needed.
> ./drivers/scsi/qla2xxx/qla_init.c:7855:5-10: WARNING: NULL check before
> some freeing functions is not needed.
> ./drivers/scsi/qla2xxx/qla_init.c:7916:2-7: WARNING: NULL check before
> some freeing functions is not needed.
> ./drivers/scsi/qla2xxx/qla_init.c:8113:4-18: WARNING: NULL check before
> some freeing functions is not needed.
> ./drivers/scsi/qla2xxx/qla_init.c:8174:2-7: WARNING: NULL check before
> some freeing functions is not needed.
>=20
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <abaci-bugfix@linux.alibaba.com>
> ---
> drivers/scsi/qla2xxx/qla_init.c | 15 +++++----------
> 1 file changed, 5 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index dcc0f0d8..edd5dd1 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -3371,8 +3371,7 @@ static void qla2x00_tmf_sp_done(srb_t *sp, int res)
> 				    "Re-Allocated (%d KB) and save firmware dump.\n",
> 				    dump_size / 1024);
> 			} else {
> -				if (ha->fw_dump)
> -					vfree(ha->fw_dump);
> +				vfree(ha->fw_dump);
> 				ha->fw_dump =3D fw_dump;
>=20
> 				ha->fw_dump_len =3D ha->fw_dump_alloc_len =3D
> @@ -7855,8 +7854,7 @@ bool qla24xx_risc_firmware_invalid(uint32_t *dword)
> 	templates =3D (risc_attr & BIT_9) ? 2 : 1;
> 	ql_dbg(ql_dbg_init, vha, 0x0160, "-> templates =3D %u\n", templates);
> 	for (j =3D 0; j < templates; j++, fwdt++) {
> -		if (fwdt->template)
> -			vfree(fwdt->template);
> +		vfree(fwdt->template);
> 		fwdt->template =3D NULL;
> 		fwdt->length =3D 0;
>=20
> @@ -7916,8 +7914,7 @@ bool qla24xx_risc_firmware_invalid(uint32_t *dword)
> 	return QLA_SUCCESS;
>=20
> failed:
> -	if (fwdt->template)
> -		vfree(fwdt->template);
> +	vfree(fwdt->template);
> 	fwdt->template =3D NULL;
> 	fwdt->length =3D 0;
>=20
> @@ -8113,8 +8110,7 @@ bool qla24xx_risc_firmware_invalid(uint32_t *dword)
> 	templates =3D (risc_attr & BIT_9) ? 2 : 1;
> 	ql_dbg(ql_dbg_init, vha, 0x0170, "-> templates =3D %u\n", templates);
> 	for (j =3D 0; j < templates; j++, fwdt++) {
> -		if (fwdt->template)
> -			vfree(fwdt->template);
> +		vfree(fwdt->template);
> 		fwdt->template =3D NULL;
> 		fwdt->length =3D 0;
>=20
> @@ -8174,8 +8170,7 @@ bool qla24xx_risc_firmware_invalid(uint32_t *dword)
> 	return QLA_SUCCESS;
>=20
> failed:
> -	if (fwdt->template)
> -		vfree(fwdt->template);
> +	vfree(fwdt->template);
> 	fwdt->template =3D NULL;
> 	fwdt->length =3D 0;
>=20
> --=20
> 1.8.3.1
>=20

Make Sense.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

