Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49E1BC433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 16:16:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEEF464E06
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 16:16:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234918AbhBCQOw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Feb 2021 11:14:52 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:36896 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233982AbhBCQOV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2021 11:14:21 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 113FoN2S030414;
        Wed, 3 Feb 2021 16:13:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=rKIP5qJb9E/CipQJHoa30X/bf3rssyIIx7Nn8DizNc8=;
 b=cEXiyIEE9PyCKKHsMR5KUJ31M4mWBil27/cE9DmRrqBZXusRKq26PTJ+4m0b2RLLt7xj
 7FhetmwF5CWYbqmxtvNvaS6ka3m/RE9qaugFylYeOTKDHviQa2fhyMEUlZbrfJqoVAI+
 UvM+0c2zNJtAWZB39A/U4K1S7qLDBpGQlK2nQClZrtvzWQxs98HCzgKgPxhWUCM0Wiwb
 33gHRWEEg6PdsoD1C4weT+QY/eL82vKIRqYlrbEQeg1nu9oFkLiiOOc32KfsiOnNMM1l
 rkErqkpcNuNmDMmoswFiR/31Ixg46J2cG1KLbYswznSi8mOh3aRShh0x7qipQjYC0cxo YA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 36cxvr3j7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 16:13:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 113FoIEg192589;
        Wed, 3 Feb 2021 16:13:23 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2051.outbound.protection.outlook.com [104.47.36.51])
        by userp3020.oracle.com with ESMTP id 36dh7tqhm5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 16:13:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ffHR9zn1IUXolpeIxN/5uxiCiUEbq2lxVqQ+1ZnWAu1fl5Hvnv1Qe555u03geZE9VTqdQTBWNJfxRJBLcU4gOyBlmTyfENkyA2Tj9vwicxA4DydJTjo7gL9kp7LVIr1QCDDvgwfJ4D8dKBP3UUOdMD3OLKn5QYjrSkXhaOoUu09QLLjZywj4m3GJRd8vteq+cOEitYBkqPZ6zeZD2vYFH+wpO9qlP2Ejot4ydcitXQSgp20LAkUYGS7ndaisUK5/Ju8H3wQxi6pb44yJ+cn9U6Rb4tj5zdV2l/H3Ro9F7W1U8elWoc0SJ9JoL2lEyCB9kbQZTn06JQsMY4q8+0BBQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rKIP5qJb9E/CipQJHoa30X/bf3rssyIIx7Nn8DizNc8=;
 b=MsytWO8btEqLPzKxEUldIi5H7B5CmS9y1awSzI2E/CD/0YmDaVawM7kuy1fGLGDVWJ8s9TcQ6jsnNlBDiir9J3nGRfxg7PeMPk5YL9MLbDuFhWneAvyol76Cr8R9OoSptXUksCXepfZRTX8/Wd+Axuy2/41VKzxyo1Ywp8LnFrvS+A0fM5eouqR366GxUcfsfR6h1lipWFG3BfNmRwAwatMoIuXpYS/JLTzNDb22i43XzYznwvnPsNkljZ5pchOHRCnQTXkYgF8LaQOmdGS1RBLtvGjV73GI1Qn8NC64WMMZAttH4qau+t0Ga1uO2RRZGYusQo+3R5gW+//17nMzjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rKIP5qJb9E/CipQJHoa30X/bf3rssyIIx7Nn8DizNc8=;
 b=EbFYYfs5lD1Q3s+RujzfZL6cu/QFPKvKwwgiLFmiom/vHxYb25MMyV5+iYu7mI0hzbBirrV2Upcg7FKkG8TP6Rmxx6dGqww2nCqIoj/rtmrqaXky4qHStQVgVNjdzs4fe+8f85hMuYoDotmu1c5vd2+XFoa9aDjodrtJHUooDYI=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4683.namprd10.prod.outlook.com (2603:10b6:806:112::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Wed, 3 Feb
 2021 16:13:21 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::793a:7eef:db3b:ad48]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::793a:7eef:db3b:ad48%5]) with mapi id 15.20.3805.024; Wed, 3 Feb 2021
 16:13:21 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
CC:     "njavali@marvell.com" <njavali@marvell.com>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: qla2xxx: Simplify the calculation of variables
Thread-Topic: [PATCH] scsi: qla2xxx: Simplify the calculation of variables
Thread-Index: AQHW+dRuaVnQbX0kw0ye7yBov8j3zapGm1EA
Date:   Wed, 3 Feb 2021 16:13:21 +0000
Message-ID: <59881FC4-7621-4740-A4DE-57FAA5936CDB@oracle.com>
References: <1612319190-111421-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1612319190-111421-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.alibaba.com; dkim=none (message not signed)
 header.d=none;linux.alibaba.com; dmarc=none action=none
 header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fb67638f-ce0e-459d-925e-08d8c85ea03c
x-ms-traffictypediagnostic: SA2PR10MB4683:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB46836816551B3D7541261155E6B49@SA2PR10MB4683.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:826;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2G/fDNuCk26xVEEqlKIBV51hbt12TY7DyhYwYcVT4tVqDp1QpMwyflGx8L1AYHKcCMRncKpjsJq9Hjf7i1A1tvrHjoRpBeJsHWyfwvTn3iodZQxFI28HuF+O6klaLEPqNb4hlUylWT5181DzHqrOxP+pGfgHXWoH7tdFhPadkPV4IlB20wF0uXFabtjmdIMdAWSREehvNLWHKdZ8QQR+aIITiyxu1rxtda3R5KQK/l9pWWD5eLNVzD3x6FNobARjIKDppqJgiUJB8b6NwVfrrvCjVEvNi9z1i5Ci+6HoMEpPsCsMmCGmjCz+V08gXq20FSM+MDkZrhBCz8nJN08tXOmLeRPPPbYvnu25bFlOptnSFXXfN2KOJ0ijh7fFnDHmIqWg4J93VZHZu0YpQ6lqiXuFihvzcVF8G7WK7cYB0KxtP503YMqMpzQ4m4RgtSxUUvgXeefeoF0oM/kSFdjOjfMvRtLQaJY27iGLWXYjPufB87rIpCi4NnLmtwGkdVSjqiZulqYzEtw3XhimVNlRsbHARjkg+6BwDcGXXzmG3yiyJRfdgx1yqLPqScT+buR55SSHUNF8w+hSExCT0JWE5g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(136003)(346002)(396003)(366004)(33656002)(186003)(2616005)(66446008)(478600001)(71200400001)(66946007)(66556008)(5660300002)(64756008)(53546011)(83380400001)(4744005)(44832011)(4326008)(316002)(6506007)(36756003)(2906002)(8676002)(6916009)(86362001)(26005)(6512007)(6486002)(66476007)(76116006)(8936002)(54906003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?rlud6Is7/OWZrX3PGHl4vI1Y+s9x9LlK1Ur8xOWsyrUzz+dPLEF4zbSZb1Io?=
 =?us-ascii?Q?sS6XAyuZ5RwzhYZJsiOIpswVwAyiRmX4fubduZFy5Xn8ASmmS+U+zgbDwu3M?=
 =?us-ascii?Q?Lj8MhScxWAisBNRf82yEwhQS5QK4b9O7MNQ67P3EOcAuNmoPvz/zfZ216E5D?=
 =?us-ascii?Q?+lBkfOaqBB7qE11JEO9ko3jirofrblslker490fgX88HEJ0zIc71r9jKH0a2?=
 =?us-ascii?Q?1vj3x57hHIpFj6atRC2Y381AqXRu1vUAdX4V6Rgkq9EwW9Xg7Zu4RKsmERpA?=
 =?us-ascii?Q?WFNNkpY/WXYVEEMdzSs0yJ69FOv2K3UASclvWzgYvX1Ve9BdAizJd4QjpO5N?=
 =?us-ascii?Q?weaKVawgFR60aVlGqaF1UsDHOd2PrFToPGVGHm6y4sm2U+xRynpIE6sjJB+N?=
 =?us-ascii?Q?xtk2PCl4cRjAKuwFGFsPWbRhlVt4lqj9t/wGpUhyQIgVfqYxzfsB8YnRZ558?=
 =?us-ascii?Q?DKzaETtkDvySQ86NnPsclpGWNiP/SBb8c1qa3E05jXuvQHiUfJfAGvapyuz2?=
 =?us-ascii?Q?NTMIyfY1KZqqQ3Wg7V1Fedc02S/ehAUTUjreS/GwXdlUuDyOD32QMk5PUZSG?=
 =?us-ascii?Q?9WZfGPfb3N/1GdSlbdZux+XBGworwlkMj7MyFTv4nyaUQWJ6Dtz1KDwMMw9x?=
 =?us-ascii?Q?7xWO+LPlbA2rQWkxj3+/CYPeBzAhViCO/pNJE77PQVpxx8mcXlF7XIiRPlN0?=
 =?us-ascii?Q?lSHcYscmgT2SN9e5zCori4vYMZGvhR+gpOvyGgC8KW1st5U/E/XjnfndFl7z?=
 =?us-ascii?Q?VEqX5qYzh8FigCtlyYCwTuzLVB44Q/5BzXQV/n9a3tE0NP0ENPFzcmnyZZ1+?=
 =?us-ascii?Q?WYtiFsU1iIqD0CuRsUXlVb1gXOlvOIAgppcN0t7kxL53o3n+n/YjaCOfdie7?=
 =?us-ascii?Q?Cero0180cCsDu9UsFdlUk1owZPWLUI0CLra2ylz4x1er9QVuiK+lgUlf7Cb9?=
 =?us-ascii?Q?rej5R/GKIItx9baJ67IUJJukEbU8atfBSnJaiTNVGwcAq+hGzBcIaYzWD42a?=
 =?us-ascii?Q?0Y4ZY/JhXq2VOx9JBs534pIH4we7ZzrJYnb5wE+CDOcG2ZK+KGnpMMlGkDL4?=
 =?us-ascii?Q?dM6atMyeIRrHoXs7cJrYgBIul+40Fg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EC2EB6AB30C4A942ADEFB881A579DDCB@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb67638f-ce0e-459d-925e-08d8c85ea03c
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2021 16:13:21.2940
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VtT01zXpRxO9C3j0Awz9s3uwHCoNOWSSAEs4mHjXaqi/QFOtKY1Fm+IIAXC7IjWM1+ZiVih6vzLJz3w26ardcR4EbVNbTqKBnwSr6rvB3uA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4683
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102030098
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1011
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102030098
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 2, 2021, at 8:26 PM, Jiapeng Chong <jiapeng.chong@linux.alibaba.co=
m> wrote:
>=20
> Fix the following coccicheck warnings:
>=20
> ./drivers/scsi/qla2xxx/qla_target.c:984:12-14: WARNING !A || A && B is
> equivalent to !A || B.
>=20
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
> drivers/scsi/qla2xxx/qla_target.c | 3 +--
> 1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla=
_target.c
> index 0d09480..c48daf5 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -981,8 +981,7 @@ void qlt_free_session_done(struct work_struct *work)
> 			int rc;
>=20
> 			if (!own ||
> -			    (own &&
> -			     (own->iocb.u.isp24.status_subcode =3D=3D ELS_PLOGI))) {
> +			     (own->iocb.u.isp24.status_subcode =3D=3D ELS_PLOGI)) {
> 				rc =3D qla2x00_post_async_logout_work(vha, sess,
> 				    NULL);
> 				if (rc !=3D QLA_SUCCESS)
> --=20
> 1.8.3.1
>=20

Looks Good.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

