Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AC76C0015E
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Jul 2023 19:35:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231996AbjGMTf0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Jul 2023 15:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232041AbjGMTfZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Jul 2023 15:35:25 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97C37268B
        for <linux-scsi@vger.kernel.org>; Thu, 13 Jul 2023 12:35:24 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36DJWpgS006789;
        Thu, 13 Jul 2023 19:35:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=C32+1PrlmXvMRCy7gvC1KfsS2Y5e9kjlc2ZdtgH6avg=;
 b=Vab3LezUsxWBGfB89bT8EfC5eg9Dnazmhi9vc5ziApwkg/yKj08uPWMA0G40jrH2A6xU
 +iOxPXQtZNxya+0lhNEVbe5SSUmCNpilgZOWo/TMb8aLVYzJgDfSJpYeK/hrt8h+VLD5
 gqydLLbxZQv3O7g+ZWIorhz+/RSRIMhh0nJtyLOAle7wxLrbgJFCpN21f4AIb35adEBe
 O1La9Zj0CQMZZlNKI+ol4zl36LxV5SNqPeKAC+wBtdemRcy55zzKl4z9v/wMWRIH8F0r
 BVfo+EYpi2Cdaw9LQJgtha2c12d+XpIbs9O1Whltx2he0ednFFRbTc4CIRg1MI0BqIM/ Cw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtqgr0071-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 19:35:22 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36DInSBC001993;
        Thu, 13 Jul 2023 19:35:22 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvw1nsh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 19:35:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cxm0/sI/86WN4i07+R72bxNYmnjl1AhQMNapSYkL9FGdSxIpKpluPfSIU9JGflFMEAXkUJebhEw1akMz544Fd8ZcPj8mq9ZQbVq91zZhc86G68XWjzrcL2XYumwVdLh7e+AaZYi62yOsOgE17aHbkjEK4Al/TdtswvnfoIdhCcGsjVGvrPcBWMzMX0sbCYqrsqnKjwbXdOHTnd55lIOZ//AyaRctgrIIJNh35NurAhL8PqXdUPTv8P3Sqk5PyIXJNoURMJ+z+jax7zhwlJRbwqtpwuvCUOIDRkHfPenLc98byCNlvSYSmTzQGLH0AzOLSKQxAw4TPSEQO5RuuKYBzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C32+1PrlmXvMRCy7gvC1KfsS2Y5e9kjlc2ZdtgH6avg=;
 b=ISjlCUXQAIFtgsgpg0EWvmml0KXWVV2wDZFpvnLDL9DCb64aIpHUzOT2fjjL/84fbJ8B2NCbxmEVFvSfH5DoI7YndYVSx0YFMqu7ZfJQrcpONxvwa81Cmi9qDI4K0ZCZakn6iSFeTJeqkdL5q+3+LpxsqP7q6Thtbtb/QmwV3v/Swoj2OvtphxS0hrbMo2t1lFukczoMjWJDqnebCoS0BnVKiSZM5YQg7ch2234PHYiKzRyu5dsA6S3x6yeMqlm5JOxlIF/jzpodSUzWhzves0qTKTYUJcnOWbs09jvdbx3SRAHZy7KLp8PvTLFoKTw1Zrd8DG5RP+3Oc1kbBHNRRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C32+1PrlmXvMRCy7gvC1KfsS2Y5e9kjlc2ZdtgH6avg=;
 b=O+SlBCfHEqwZQlcW/v79Ue/tJU8J/4GxiodFib6Ht7BjUSFPwIT/0VPQsC5/lIHsORVpmFm00TeGuW1Bmcz3h06NdSGFuN4zxZ9+z1eNfUgqH9+2CUd/xV+6o3i94bou5puW1aEvIPnCfYwaikVBKrkQJdw/k5mKsy8mPWTWnWI=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BN0PR10MB4936.namprd10.prod.outlook.com (2603:10b6:408:123::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.24; Thu, 13 Jul
 2023 19:35:19 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::2ab7:3a22:b4e3:93ef]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::2ab7:3a22:b4e3:93ef%4]) with mapi id 15.20.6588.022; Thu, 13 Jul 2023
 19:35:19 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        Anil Gurumurthy <agurumurthy@marvell.com>,
        "sdeodhar@marvell.com" <sdeodhar@marvell.com>
Subject: Re: [PATCH 10/10] qla2xxx: Update version to 10.02.08.500-k
Thread-Topic: [PATCH 10/10] qla2xxx: Update version to 10.02.08.500-k
Thread-Index: AQHZtKBb6Mi4Vs8Ofk+bF/O9b4waM6+4GQOA
Date:   Thu, 13 Jul 2023 19:35:19 +0000
Message-ID: <93348D9E-F9AF-4EB4-A7CD-A46F3FA0D3DB@oracle.com>
References: <20230712090535.34894-1-njavali@marvell.com>
 <20230712090535.34894-11-njavali@marvell.com>
In-Reply-To: <20230712090535.34894-11-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|BN0PR10MB4936:EE_
x-ms-office365-filtering-correlation-id: 5b2146b3-3bec-467d-a987-08db83d84ad6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: atnSHiIl6J7Pwzs2zL3CXxzN965pooFXB++JGBKAbVT+syXMbEYgJhSD5fNNXMU/vhvQ8DpoBINSFUTKLnwrGaR38Q+Dce44AP+64xVPMMfJgIrBqeGQGvDdxj81qrQKB2mDV4pJRrt7/dxH632xxAHZUVNPkHEqxaTOn1q09zaBmdXEiflzTjMaA3G3URpBlejtfXyYazg2byt3G3TEwHwqbVDLJ1jBAZG1Dd27nAm0yY632K2ay/F8eQpmbeCr8bVO2FP3sKep1ZwPuoFjxk78XzB4IYbiPXeTFKpr8VG34znLsjJ2Gy1Vp7g0PXDqEJZh6dMuQf8lJaaeTwZi9aNSIm17W4KXXCcmsKkDVFfwpT9+Cq231IZddS4iDBkU0Jtp2zL1CGnTofJyRXIdf22f7SlsVXKOeYEnAujgmPm1nQAKq7TS+yNfNh+J/KvUbB2P/gOOxCgom1tGRCnsrP0Bs/VY+7RnNdcySd9mQqhdBeJl2CLFJ+32HNqwrXXyu7Hab/qZ4C71TJiGxM3UZRWh2WjAXI+RVuUP+GW1y0hqO3MIEoXM6JyILqxR+hCkHPTjn45a5ld9x46v1ZOGtoI+Ss5LRjlQg1VwvuxrNIpWmQ+JO6eBEZrYdWQ++EmN/sxHv/+zchNT7SjMiYAFWw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(396003)(346002)(39860400002)(376002)(451199021)(316002)(54906003)(91956017)(71200400001)(186003)(6916009)(66946007)(4326008)(6486002)(76116006)(66446008)(66556008)(66476007)(64756008)(478600001)(41300700001)(6512007)(8676002)(8936002)(53546011)(6506007)(86362001)(26005)(44832011)(5660300002)(33656002)(83380400001)(122000001)(38070700005)(2616005)(36756003)(2906002)(38100700002)(4744005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+uKnfYBF6WPHTccsd+x8C7I1PvT2sFlEJwUn3qt6iL5Ygi0XxvMSOwFzJcaP?=
 =?us-ascii?Q?RBkuEL8HX8b8AFIIligydNUqR4p5Rmcpy+x4bt6wWRz6pfoBsEdfTxAmk/O6?=
 =?us-ascii?Q?QVfSwMh8lDiu37ugVNsatSf3mCuPwtg5ukSMDYmG384J8p3Egqh0B3o+e0FV?=
 =?us-ascii?Q?lk4ctCgsAhVFkU1jgAv/kx/FieUejYFIL3+FJmzWKFtGOZjY9uSlpajukogb?=
 =?us-ascii?Q?uPpVFOuEMvmjWeDiawgeXXW9IGxUXiyxbyqMGBhkssEGTTJg5NU/vSTjV/8C?=
 =?us-ascii?Q?tGsFjHzGbL4Z2UXH39MDj9Flduevfds1enxwvjP/tZ0vrgNl5hSJtxYbLhKj?=
 =?us-ascii?Q?arfJTO7h8VKHj0Ue6Zj9NrIAqhxLK3aSEly3mcbWr37Co1nDhJXx02qNy9zg?=
 =?us-ascii?Q?CIQu+ZgrvGFk5FDX2yZBkMdOUTRlE9k9ZF8gS3H5DYnf/tcWWtfItxGrIxUU?=
 =?us-ascii?Q?t4tXao3TxuhwiO7dt4E+dt07v5uF22AlDt/r5I2BKnWBEi2QEcxDIx58OAY1?=
 =?us-ascii?Q?IkFY70yS4rEiDAwaM6UvM0wvlo+lGEs2MNrWaRaKpmWR3EfUAAi7OWp3UabH?=
 =?us-ascii?Q?L9vk4pIbYk247+SCn4wPOOheNY/DsditVAhKy+J0SrGXx6FxARwmjuqZR8/h?=
 =?us-ascii?Q?FrkTQuudns4TZpV/eBZD9zI7bOyZbVcoMnGGOtuN5AIJcPL7ZFWmdmIl4Vfy?=
 =?us-ascii?Q?Vq/m8N5YqAEK9L4mXPVx6xjK2pG8+7HgVaInbwaxG3dOMQWlmxTGN37sXLSr?=
 =?us-ascii?Q?4+kVsDAh3KWmNHl9J+GbC7xj569+tlHmUhir7CP8p90FV7WNVoPm07SFbwSV?=
 =?us-ascii?Q?x3BzaFuV/bI0fom5CrJKUuDDNBSlbB3QQ7VXoq5Raz1RrQSeeANeFhDut2x2?=
 =?us-ascii?Q?LJhbg9PR9f/7unMTGcyiwpiPTPinq0QtlBr/up0HB3KLHXEcd+VDr9VGXKuJ?=
 =?us-ascii?Q?IvsNKTc6nBNl50oAqR3dH4m65xiOtGpvV0aSP2vYmcTAVpZyrRyy0Etw8H7x?=
 =?us-ascii?Q?blZmyz1wA9Gpq9lYtbAdh3XUNgSwgkqm00LszAmFVwNuodIkHstap2pih+oF?=
 =?us-ascii?Q?Nw59jq/gIZvTWAujQNP3krCdVewaMGsJgdyRufYwJ872/2rNwa1I+XR3OK4d?=
 =?us-ascii?Q?mDFYxnF3TBKx1qn9I5cKpxY4MWXp1mPUM8PEGlQ9g/a9eGk6fljZajKjdxXv?=
 =?us-ascii?Q?NN0rZI+mM2smNzX4Lh/q9KbbNwF/en8f7BiZEdV3RWw6k2aL3Qk/h2h45x9G?=
 =?us-ascii?Q?TULE1kIikRO5KQfqyGp84JSHSNwGVdjUZm8bzQFqE7tQ3RSbykCXHogFOR/y?=
 =?us-ascii?Q?f3EDHYRk+B6YWJsQq3l/nd4hqB60SRVou9ysYAfvQ8Jn+FhpoER53q9OGE4k?=
 =?us-ascii?Q?fOpyDlTHpd2ny+fAfKR8W2Q4h62xfbOU+ZQZxaElGLvVtiZRuScvAmoD0xmu?=
 =?us-ascii?Q?CgZa4DDZDzWmGin3yc87554RzjI22fAQe7YsyDu4cX+HLBlTQ1ybpz3A3YXq?=
 =?us-ascii?Q?h8oHfmSfNJONS0jIXABww7RUWHcXX4M0mh23LKy9uyheJzABle0z2FND0ujs?=
 =?us-ascii?Q?BjSMRMr8FSv3YrXL5xH9uUDYQ2G8YNC0xwa3rb5t7izQ1vbgtzUi0s5U+8u1?=
 =?us-ascii?Q?Esfbi0NnqAYRdr84uaBLzPs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <60038DAA038C2C479AC706852D20E9DC@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 6IbRoyCUFNr2oZtSrbXS8jqEYpYN2mn9M6bCIIUF+bOO1KeDAPtv/ylfMPMR6qVmrtA0z536ZgswpILxajh+ElMhXG8dkNBkPw1XfoKElTR6V96c0aW61wvyJIe8C47xIdukMov8CsGeawsSoXn7nlIB7JkjDlW4MDoz7MSZwI0Vr9dRr/owmMAwyz5gdVR++zCvq2KKNaHE8dc9q04Z6DpKmMShZ/ZJZv8s1+C+jpzT4M8jA+8/mHCQLFxakDqSZngYsUpTDXFJYCj8E+jCZFwRaxS4K+h9T825l7Tue+oai72utGpKCIPMIyJZcL1X5N9wqOrc3k02cT9pWA1k0n+uCY43n94hHrP/Tg8eBGipNdQhUZFWzlGWx3faVnq/L+7D3DjJsGLI470T7Mfz3K1jzLyKgLnS0oE0KZ1I+9Be4QFwf0bUSj1HlPT9olRwD2Bwx11/V/FhtpPnYShYAs0a9iX+7XPojUGFbzRfzz3j4yhx3o0tnsbP7WPy7ZR5IFrX1t5QazEGrOHb3nG2Gksa+GL2qeRqUZ84MvKu+yqlq1F/s9VA3DBx4xPUtjCy8jAgEbsjPmO+Nmu9PpK1AGC/I3jSX0Tr59ShoIx0GJtJZ0IpdJpicLFsVC4XmWA6cibMopCRQ0piolEihpNyyi5AxCCeySet9DVUDQJpLBPKt4LMeKPyb2G+2MqTNqwl+yhCihrqjE83/qzrBYQqdFr0zky0sZkAshVHbitwaZLvrXk57IG5aVFc1dca2kW6ueb9O0F4Fo/V2RmK+/9NrBvOha/ljizx1QsO4OyaxYc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b2146b3-3bec-467d-a987-08db83d84ad6
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2023 19:35:19.4606
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: suwpQLvicxoTmloOfTFZD+ic5whnLVBSoyVC6uJsco+CaZN8un1f+NXzXZ2DWiGiUAvUbptxc1dfaWh4R3Db0KEqhqj5ZUZpTb0SfSN3J/g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4936
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-13_08,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307130172
X-Proofpoint-ORIG-GUID: jiDpbXwPh2YrdXbtwe5dJq7QB4uyG-TT
X-Proofpoint-GUID: jiDpbXwPh2YrdXbtwe5dJq7QB4uyG-TT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jul 12, 2023, at 2:05 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_version.h | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/ql=
a_version.h
> index e3771923b0d7..81bdf6b03241 100644
> --- a/drivers/scsi/qla2xxx/qla_version.h
> +++ b/drivers/scsi/qla2xxx/qla_version.h
> @@ -6,9 +6,9 @@
> /*
>  * Driver version
>  */
> -#define QLA2XXX_VERSION      "10.02.08.400-k"
> +#define QLA2XXX_VERSION      "10.02.08.500-k"
>=20
> #define QLA_DRIVER_MAJOR_VER 10
> #define QLA_DRIVER_MINOR_VER 2
> #define QLA_DRIVER_PATCH_VER 8
> -#define QLA_DRIVER_BETA_VER 400
> +#define QLA_DRIVER_BETA_VER 500
> --=20
> 2.23.1
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani Oracle Linux Engineering

