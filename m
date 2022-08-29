Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CCFCECAAD2
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Aug 2022 16:26:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbiH2Q0b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Aug 2022 12:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbiH2Q0X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Aug 2022 12:26:23 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98EDC79696
        for <linux-scsi@vger.kernel.org>; Mon, 29 Aug 2022 09:26:22 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27TEOtaC018675;
        Mon, 29 Aug 2022 16:26:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=i2KXurdj6WOXvVRj1Cm3wK55yNXFTJ0/4oyAlN7XlF0=;
 b=yHHliS1vfSADTacj4ECImb89U1Rv+w1eGqZDfgfdHvJb5Yim3iq9zBtuMBQgDTxDoTZV
 6StFNuEa1+Jv1vCAgPK3UKG9mwIrggQv/4qQgF5sbKBEuLE3tPm0S+v6q31iFvw118nm
 sHgMoiN01kPLlpGOgK6CfWG1FcMerGFX1RpXcW14NcJ6FerfwdCa5K9hktcbIoi0aTFE
 z5Nn+9FvOoXkSkOGPGN7Vjtl0sZyjg1ttUTu4oHV0x1tk3pXROhpBS6rAe9qhON8wAUk
 kG3bZGCwZqAZTCVJWovfIZYJwud72aY2Pa8644F3DOcet54+xdooGswNYse8oSA3GL6x xA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j7btt3vm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Aug 2022 16:26:21 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27TG79Qn005272;
        Mon, 29 Aug 2022 16:26:20 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j79q2kmcs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Aug 2022 16:26:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QWbof26e9XSIzqG4TYK9q9tcCXjFo9Z1KyNC+KvA0VKuSvhgeUwvbvAANisrxw4TZ5y9n8ZDkqi9PGufg25Mra7NmBE0IkagHotvGIIFHdBdQXtbEMYwQQB3EmHAjTk5PKdfRxx5ZgAqqA2dbewET/HQnJB2+Gyf+foYn7oAsaFANXpmC5rzaV/L0e5XxDfHcg9ipYrCApTRJ0xeg/wg2t0DxwqbjdoTYlx4zTNEsMUeRYarI0NC8qNWLyXDDOhryx1xXWLC6RVBMO+orSe801YxqTI50+ff0Hd2qoZAm8ZzKZq/lhfynVT+QQbUASTYLv/t8voVQXPADDDWaqMM+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i2KXurdj6WOXvVRj1Cm3wK55yNXFTJ0/4oyAlN7XlF0=;
 b=HedfyTi8lW/COPSefHGI2wIN7gUJUS1g6Nw+hQ3OSMdQtsPl325WNapFyOfpvqN5Z2c0gQt/E9WenlfkbT3iqFsqBy9/4vWh91Fc2diSnkMvsMAM0FtNxHW3j4wUyCOFbrz8CqWE/M+PAO/fbB544q3736hui1A/IOqfsXIQHxNSjmfpbe3ZGKPHBooK3zxQu5CTKlurvtxjQEnRg4vAuHJEfL5U+mzOJUiQQAbx/9lhnCIN/hJX7yeomde2XHGpqPXC58qeCRDLiKPWGjZlmNjbDbLLx2UFz9siVb9y8CvHkmJVm5N7uleIwMugnbdJZTaY2cm4FKhPzjLoDsIy+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i2KXurdj6WOXvVRj1Cm3wK55yNXFTJ0/4oyAlN7XlF0=;
 b=hlt8AeE703fLT9dBlTqDjOkVNj0XqzOv0C97Or9rkTVS9Vdzd36S9lV1AQugRpZNxEaMLVhy1vgaL+L6PvBNlYFtT8wXC7VDxDHLmx7l6kS5WiThUrgaSz0yoMXOs/RoGXmSN7QJrlwtjUcecLpc3NR/4yqqciIs5hE/MWkjPlM=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BN8PR10MB3395.namprd10.prod.outlook.com (2603:10b6:408:c1::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Mon, 29 Aug
 2022 16:26:18 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::4833:dbd5:3d83:84aa]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::4833:dbd5:3d83:84aa%3]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 16:26:18 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "bhazarika@marvell.com" <bhazarika@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>
Subject: Re: [PATCH v2 7/7] qla2xxx: Update version to 10.02.07.900-k
Thread-Topic: [PATCH v2 7/7] qla2xxx: Update version to 10.02.07.900-k
Thread-Index: AQHYuTZSHbAPAg4v3E2fGvGA5yq/PK3GFbUA
Date:   Mon, 29 Aug 2022 16:26:18 +0000
Message-ID: <270C552A-7272-43F3-B84D-F974D18FBAAB@oracle.com>
References: <20220826102559.17474-1-njavali@marvell.com>
 <20220826102559.17474-8-njavali@marvell.com>
In-Reply-To: <20220826102559.17474-8-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 523075df-a752-4df1-a8a6-08da89db33b7
x-ms-traffictypediagnostic: BN8PR10MB3395:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XWbmfhV88esn3UhfUMdsNYbIFFBuGsc/Ad7oMYKIJprEBCWA7Nb9Sdi+avMo/CLwY1LDyJlFQ4UvXYiTUAEKiFHyoQq/ckVr3N1ePB422BFC+xtH+QePKgKPOs4nv/Lh/7tMJ9lXmWY35fImWX3V46p97bfZa0jEuGZv7DrAianLYSQHTsFHQaRLKKsdhZcMGwG4bGCS52HJJExlrcbUed5z+P2ox+3gF0c/S/xai8//O38ET/qSHi26m+Q7rV1fUf6gb2t7RyJ4sIM8w4AyzJEQHUktd+r7Ak+n1oSIxomDK8EGgpKCAjJ/PmL0SzIHVzvWoFXp8T6cj5kHIQQxfpD+i6wSuU742fp4sCYwNe7Cx0iZiWhMqkP9NUBGXyxO4Ongv5R/zOhM/G2u1rhMHt4ETtjGdllIMBo/cU2fTBA9mPt5Wi7f1v6jVg1HXlfoToHpx2pKNSLF9BG3i3ju6IyqD1+Gthy6A/tEMjsDi2i1E5ZjlH1blQVycyQqC1tCFkAa48Yilf5zpdv10MGzqS5J23hWtv5MUjhv9JybTWJhKBIcoKOolewcRK7SB/Bi82cdRxCQzHUHjCnZol7JXguENCsxThXYmPCeMBd/WDInb3Lx9DackDY/0zns8zcjXvPARr2sxrJkAj9GurIYueGyJRlQlk1YLhPBpi2bdK1ccG7FNP0ZZzg9m+R9ypBQ/Ws0xu4xiL2LkJGYocGTEXJefv0CV+CGzjtCVUPN5jvBNfPxtFOnilmS5fPpRe94jtRIY2IiqaxT/QN3OzXOoFJW0HMsK+9YiBfvuEcRXHw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(39860400002)(396003)(376002)(346002)(136003)(86362001)(6512007)(26005)(71200400001)(6486002)(478600001)(53546011)(6506007)(41300700001)(2616005)(38100700002)(122000001)(38070700005)(83380400001)(186003)(91956017)(54906003)(5660300002)(36756003)(33656002)(44832011)(6916009)(64756008)(66446008)(66556008)(8676002)(4326008)(8936002)(66476007)(316002)(4744005)(66946007)(76116006)(2906002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?puqdATOcEzrkD2pFetNWc5p8YgT7WlEY1UPlH8gEAAbrdamXxajNbX069wkm?=
 =?us-ascii?Q?oMBefjDajRsf33eN+KE2VAJKScCbH3Nq4hTemMX4xE5UZ0FExW7y1ZS1lRAf?=
 =?us-ascii?Q?Bu4pnefkOntCfYV7xyYtFAOdYSKHvl/4IWn+VUfSF2VS7k5sXNoCSva+nSiC?=
 =?us-ascii?Q?vt21HrONIE9GRv0sz5aUOfC7MuSd0+UAK7H9OX7KQ4Xtjjmhg/FhAgZy+sAN?=
 =?us-ascii?Q?COz4fRJtCII9l92r/kkiCJSIqpE2ytqPy2CUA6am9H96rwr6UBbncfSxfIAw?=
 =?us-ascii?Q?ZXweG7lV8waClWd/iDG7nyfzlhXzBolCvXC32sGnJRMwCtO+NpU9jxGDdOL/?=
 =?us-ascii?Q?T5cby2RQ7U8dtuwsZUR94MuKr8OgRv8oJrL4cSSt2VtnTFWUwnZy/H/QIpxg?=
 =?us-ascii?Q?t44wARQS6smokMgt091GR74xbrpB3bLUhPYddj7jMka59C6DYk1Npyo/d8X+?=
 =?us-ascii?Q?A/FENZI8XiEwf8yjrtWaF3NNerzgUawUWyy159pZbUsQcVrrYEjBI8Lrqtgt?=
 =?us-ascii?Q?yBSGE9PtcgksXjx4y0RMFzfO0wd7SkRsXatomrVSpJU56AdvZ6wtwGdDPuX1?=
 =?us-ascii?Q?ATFXVK29hICs9cdS/bLr258LzWfkC6/P4MvOKbrtxCDAhikED4ow33gISFrW?=
 =?us-ascii?Q?V43oG07J6gdCz74Cf9O7GqrEOX31Yp8bwoq0Wkti7kN+78Sp9/YCVEzLn/01?=
 =?us-ascii?Q?/MZhflTJfxeYN5ndozom/ee1LWiRb3MS2kLQQ9erLcEETVOV1Qj0UPhhs3re?=
 =?us-ascii?Q?X3GayQkKjCBXYmCLIbqv4eqreMX/8SmvgjOHSwE2CoShk7RI3QpNNEUenB0E?=
 =?us-ascii?Q?w0njGqNlYnwb/4VjhSWNTTlZZfolIiQVT1gONvAOEKqp4XgU0z+4WDZnNqYI?=
 =?us-ascii?Q?2aI+nNfd/n0MtzTbl355VdaAfAXxOIh/10MLHjM6HBoJOhoXhNmatxPZq/GM?=
 =?us-ascii?Q?dH0tTjXJIXe4bqFmje0oELEkwv7zwEv9ZxGi6haUxrPn2Bu5+0l5dikmXut7?=
 =?us-ascii?Q?uANeTHIpj1vIOoj1XUukFMuX/JWS08DYS2ke/gFB6oLtywpI4WGXF+1SBk/N?=
 =?us-ascii?Q?tWjG+2OgcA2VEC6E/vHIwyH9cE1TX/0S52FFv19H44qkYm60s4wiDmoNEP9p?=
 =?us-ascii?Q?f6nHctj4p0ITrnDXnd3FxDlyHIDACnn0EZDcq4Z3LW8azNcKScf4Tb9nHGOO?=
 =?us-ascii?Q?IR68b4e2IUkDsF+WY8B6rCu672AkAaE/swZ6OS/SxwvwJ6QA5fThMG4/eJlO?=
 =?us-ascii?Q?kFu9UOGyllFc7XsZ5oqVyxJAsNnCojtFDLxkNpn7E1kDas9eTmT2L6z/WoGF?=
 =?us-ascii?Q?7tIiKncXzIFlvVEMbdFMSEVhrknmoSFNiKlHLrvWWUrIwNdjIDjct6Q0B4w9?=
 =?us-ascii?Q?7zIuZCwViJ4Uxh7JTyhIK5w5xQaa8kG1XWwiixVPOAQadVTWuQg/pEIYtUVD?=
 =?us-ascii?Q?YYGs6zdf4u/i3xP28EUKOBoJvrhqEGuAXR18rt3MnYn8sFNo9hKVo/gTzFiL?=
 =?us-ascii?Q?8s706HecX//eJKQW9L7YH9k5J54S66Wj4T4cYkDCv2JIOxXlJiO6FOm5mktl?=
 =?us-ascii?Q?st864CJyS80LiDNNNGNzB2QT9PCtw3e3SKpHf32cCqIxJvuvtmgmqnIV5CK3?=
 =?us-ascii?Q?Jg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <72817E480BB59944B41AFB1E65178F90@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 523075df-a752-4df1-a8a6-08da89db33b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2022 16:26:18.4707
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vhn+AJ5Mm3q1u9YgcMx+m6VrhL9ErdR8zsfSaXAv6lnjV0T7yyZ0LrQ4yjbYiOM2AztbAPszVGQV362IjBAglA2vRZpIHSi2P1exSc7twRg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3395
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-29_07,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208290076
X-Proofpoint-ORIG-GUID: Eg7KafEL7FOmK_16q_xYJzdRwtc0S1uo
X-Proofpoint-GUID: Eg7KafEL7FOmK_16q_xYJzdRwtc0S1uo
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Aug 26, 2022, at 3:25 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_version.h | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/ql=
a_version.h
> index f3257d46b6d2..03f3e2cd62b5 100644
> --- a/drivers/scsi/qla2xxx/qla_version.h
> +++ b/drivers/scsi/qla2xxx/qla_version.h
> @@ -6,9 +6,9 @@
> /*
>  * Driver version
>  */
> -#define QLA2XXX_VERSION      "10.02.07.800-k"
> +#define QLA2XXX_VERSION      "10.02.07.900-k"
>=20
> #define QLA_DRIVER_MAJOR_VER	10
> #define QLA_DRIVER_MINOR_VER	2
> #define QLA_DRIVER_PATCH_VER	7
> -#define QLA_DRIVER_BETA_VER	800
> +#define QLA_DRIVER_BETA_VER	900
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani	Oracle Linux Engineering

