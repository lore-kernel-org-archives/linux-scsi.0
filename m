Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C29EBC433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 16:19:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82628613F1
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 16:19:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbhENQUb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 12:20:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43328 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbhENQUa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 12:20:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14EGIs09043849;
        Fri, 14 May 2021 16:18:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=wZ3g5jlmKjLtqJxFkE6bP39UZV8dLCFtRxxk7M4Yi+8=;
 b=C6CSWyoMO30f01Oelzd5/vU3G8uvSHoLhoE/Hgu1wtNLvU63L7Ky90IsgadPX1Z7khG0
 fBPK4RwiSHoMEbbg1XqajbaMzyRA086P176JgHkMNmp5yKS3aZAICe994QeF7ORxEk9M
 iR4cTiQNRiBxk759OqgaNrKjxugxEVPBPH7yY9dgVNmJX7gG0/O6rv5GEW6Keaua6uiS
 N8f0foBL35dinMNBp9lioOL3nLsnz9NY9Te3fiExcdOuNBvvORO5ui/ERHMAv7WyAagi
 dzN9T+zfk+pQ0q10kg5ZtP1Rum3iGdJezZGVVIJ3v+XZxJ23GtF94P0az0ulIjoSR12A mA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 38gpnumskf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 May 2021 16:18:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14EGG2cH132543;
        Fri, 14 May 2021 16:18:53 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2174.outbound.protection.outlook.com [104.47.73.174])
        by aserp3030.oracle.com with ESMTP id 38gppq83xr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 May 2021 16:18:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g1IV97urInELS2u0wW/G97e41nKfo8D+/1SrhnqEn48LKEqXTBvPAWayxga40t13e9svP3uycdetbYiXqt4viUE7j0ovCSTUW9JADrl037MfhpzJvULCy3qK9Vl7hXQyAIN00HEwUAJw6wm+Pu9wY9hm1xWY2hMFyEAWnb66cs1EfGLyNebJR8JUX0DoEZ2DzE1aljSFz9lEGNJLUuvUwqkedftBxQg6pDRXJFOd3K2EbTYlP1mEGm3F6UNj3s6fm89igNMq1TUBu2ELeSz8epxfQ0XCsWGwgngwnHM5ksGWapVHTfvLSJp2c06YTypDfH6q5HGnBjJWBfPEFm4b5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wZ3g5jlmKjLtqJxFkE6bP39UZV8dLCFtRxxk7M4Yi+8=;
 b=ORnPC5TyWFDfL59q8k+FJ7y0W9fF4eDGeCXbgfsA+iUCa1wrRTVYaUM6wwYdgEL3bAWFv/SsyItSSucER+4xXj7cfoLw9iJiEKWmVOilGgLWnmjitahyi4m3koJe1FNfmTVXXh4hX+a7vVyke8OvS0Yl/HURar8FHcxMaexHxRPCSCc++3Gkn/4vgAGVSuIbWQOj4iDwVCiZ0T4wwIPwNvLM5LVFPhKgYy+wnowX0KWUAMrKrR3aHGiZlLuo/Ewh89dOpfuAbSsvxwmbktGN/85bgyEJJk3vctyk56oeFGiJhafuF096undwaIKEW42BscyuoHVMwg5ffAp5hdgoSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wZ3g5jlmKjLtqJxFkE6bP39UZV8dLCFtRxxk7M4Yi+8=;
 b=t4PObaZTCnH3vwgd/7NUaO7K4NuJJsq5Y8430TgU6cU+Tte0QhqdjRGHBJVrPVpl5DOCskeOkvL+GYuVPvDBAZVgyFN4wPlSHzQqSFw3Bf+KoBnYUeTpPKxEfXRaTEe0TU3vcpQUDTk1bNUhiLrBHHzJ2RMna3hcPCUH2r0rhho=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4524.namprd10.prod.outlook.com (2603:10b6:806:118::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Fri, 14 May
 2021 16:18:49 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4129.025; Fri, 14 May 2021
 16:18:49 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "steve.hagan@broadcom.com" <steve.hagan@broadcom.com>,
        "peter.rivera@broadcom.com" <peter.rivera@broadcom.com>,
        "mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "thenzl@redhat.com" <thenzl@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH v5 01/24] mpi3mr: add mpi30 Rev-R headers and Kconfig
Thread-Topic: [PATCH v5 01/24] mpi3mr: add mpi30 Rev-R headers and Kconfig
Thread-Index: AQHXR9KNYhLqENiCm0G5m6ex38CO46rjKf4A
Date:   Fri, 14 May 2021 16:18:49 +0000
Message-ID: <AB59CAB3-B513-4D76-A523-344E909D1E9A@oracle.com>
References: <20210513083608.2243297-1-kashyap.desai@broadcom.com>
 <20210513083608.2243297-2-kashyap.desai@broadcom.com>
In-Reply-To: <20210513083608.2243297-2-kashyap.desai@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.6)
authentication-results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.143.106]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5d0d8317-482b-4c02-cc06-08d916f3f504
x-ms-traffictypediagnostic: SA2PR10MB4524:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB45246AA0780305FDDAA8EEE8E6509@SA2PR10MB4524.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C7HN9KMaRzUq3MJSdDQXCayXmjhKOeHDuD+1/bvp2xZJG0YeXyDkmWln4py3Z35lGDgi8EhhSlCW70Y0kl6m+T3Sf9w06KZ3UYiLBskzhjkUqSzYjw/Bd+YuUYyr1zehS2hcrjHZyAIkFtWCYOmXX3obwettNJpyI8HYAOLHCBCrxSS9FQ8Pu+P0zVdUw+c19evigheDU7ucL2nqV/neOOpmxMnOCrH4GIEQhCwg52OI0CvgrggwnnKapR1qCebdpMZpEdjI1EKZ0wSVrLi5w4f2QNJYm2whD9eVCdAEdZVP/OPRx8o6Mo1X/7RL3ct5YJhRVv/f5S9gVbU4wTjjs0zWL6ACPVGnn0CGTGyo4YfvNPQWWarsfkc4GAcEk4pVNMNSiUhwHcLNW3sjr8ZAcp4z6jVwaLdaanHt6zx2DLRx521PCEarREOkrDhrlKVCPFGVWoc+0YFNI/HZ50MtARQTX0SqzPeHoherN5q8/BEJVbu83HDOf2qbZmtxdaOx6ZnVUtv/ckZOH4N78OAVtaNiuzxa4UIc70tfFhUjvY1UKvY1Z+8AD/rS6sQJYAkowjyWsPeHrpVm5wfN6ypjp1ED6ut6/X7qRdyIW6HA1tuS7mNhiorXDI3U3UT44tAoGqSgFpqQwHwqENdtiaj8d9B9TOlFXUItsJ+9mhB+gh2r7K7eQrXcB2+MwgO1w1vEUx+/NSEb5ebH3CQhyaUJnQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(136003)(346002)(366004)(71200400001)(2906002)(6486002)(26005)(38100700002)(5660300002)(66946007)(66476007)(66446008)(66556008)(64756008)(76116006)(6916009)(44832011)(4326008)(6512007)(2616005)(316002)(86362001)(186003)(8936002)(36756003)(8676002)(54906003)(7416002)(83380400001)(478600001)(53546011)(122000001)(30864003)(6506007)(33656002)(32563001)(45980500001)(579004)(559001)(569008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?KLet03KIyOGDhgFMiGF38jCnZdlDNRymTAZNyx2K3QqtCqYtY5u2WPDGE+IP?=
 =?us-ascii?Q?FZY8TF9iNbz2UgNLpq0SNTeCayj3XaunIvEJ9PceXDCe266gPF3LFRWLJRV/?=
 =?us-ascii?Q?nHr3IN6mm95az0lBvIWf9Ql7PGlcBjJuM6MT7WFPxt2iJOT5qQCxgoQO3Eof?=
 =?us-ascii?Q?LDHlyyovqU2vDIvovdo9WKLAR0GaepS7sMtbVGZkanr9Pc9CDr1ikiuk35IM?=
 =?us-ascii?Q?6kIffxUGI1w5ybsVqTBy8M4Y6tJwwDSwYXiOAMMEwUkGb/tBghS7vSyG/712?=
 =?us-ascii?Q?zPSsToeXc6auggCQTYklm9F2V5TXdgu4ckCx5xwAbeuT9pqsdeaKjEhdkpff?=
 =?us-ascii?Q?tRO5jZYHJ90LiCsOkpSWpFJuJ2vvKLwtPCFJftJ79C/1buD2/ui1QJT0mfxF?=
 =?us-ascii?Q?tQBFarGbvYJZrmHf1aDWWde3rvt+/YpZEkWzyBLwnp/DhCW8Hpv8sDy0IhrT?=
 =?us-ascii?Q?7rpV8EMa+7QfqzQQyMLluwadQrI+KCLoi0GcFFgjZEOd9ZTp5jm8XxKvVylM?=
 =?us-ascii?Q?CBNevV9D5CrAIHupNrlhMFr0xIox3uvAk8OpSGF2QSXjlHCHK/Ho8w9q3eLB?=
 =?us-ascii?Q?sYGkA7q+doeqswQLJ+15SXEyGaVnbUMz4FDZGvpFcXzCyVXHipUm0XQRa2A5?=
 =?us-ascii?Q?BRucGhaJM15OTWVe4wmNMPOecjKWi//GQL8jLjw2R7+uHwpHOk5IeTuuBxg0?=
 =?us-ascii?Q?jYTADXxR9OSSWJi1PZrbeUoWsouT0o5PZO5F8e5RLnU6tyHRqam1xbHIaTdT?=
 =?us-ascii?Q?D6ra6QQFcrChCFnGCOKjyZv8v/r+0HX7sTVI9UpM5oAWE7N942D9SwSZB1T/?=
 =?us-ascii?Q?Bzl93O+EIZLKjxixj2HQh4T3hWRAQCtK4fIrz08VVJw91a5YXqJv8XZ/TcK6?=
 =?us-ascii?Q?jtnDAmjxdmJvlILK9NQXB77hUK0w9aRjCw08RujbaCSryu7V67VF32/eF+uu?=
 =?us-ascii?Q?zfMfSZav4smmcZ0fkoffF/bg5uQqzulMzB7839lf1rnAalDhYsaPMD0GRdHC?=
 =?us-ascii?Q?Bu/FMIU25TwB8yzeMuoPWGSajxiEwWzaUesVQOXBP9dJf7YhVJZ8XOD/Xfif?=
 =?us-ascii?Q?6R6GNpRglyuSCP2hLRcUbeTNli7tBctHQpPEH3Z4Lln5pWMlGdXj0UvbgPEf?=
 =?us-ascii?Q?TZcZZ59wTMJqMf6wnURC9HqDtLCIABFpyl3i8dD6KMjAlgaYf3bRPfA4HdXq?=
 =?us-ascii?Q?vr//aTlgu1dSwqYALqamyid25LYnKB0arwih597ebL013znZTmlNidsmU3eQ?=
 =?us-ascii?Q?O8uweeQ3s3xDuvaoi92HNXUvEpoBneCtUeBMXYaQafhpHXw6vXGvuX+Jg/yE?=
 =?us-ascii?Q?TnFVqdWmOix9e1Ip2wmVW1DU?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <262D21F9CE0F0D43980496EDFE1DFA3E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d0d8317-482b-4c02-cc06-08d916f3f504
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2021 16:18:49.1922
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uj7NvoBQWL64kXU78F0Bdqznk92Txhu9wPbQhYyTmJSL4ludr6TiUpxqG3yzXvCNIbfw4tbXPo80je3jkBLnGFBUZXmvnlZzKs4MDUAOJFs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4524
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 suspectscore=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105140128
X-Proofpoint-ORIG-GUID: Poc5tkeM89swNhVduPsIa6sC2c4sl9o7
X-Proofpoint-GUID: Poc5tkeM89swNhVduPsIa6sC2c4sl9o7
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 adultscore=0 spamscore=0 clxscore=1011 mlxlogscore=999 bulkscore=0
 mlxscore=0 priorityscore=1501 malwarescore=0 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105140129
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On May 13, 2021, at 3:35 AM, Kashyap Desai <kashyap.desai@broadcom.com> w=
rote:
>=20
> This adds the Kconfig and mpi30 headers.
>=20
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
>=20
> Cc: sathya.prakash@broadcom.com
> Cc: bvanassche@acm.org
> Cc: thenzl@redhat.com
> Cc: hare@suse.de
> Cc: himanshu.madhani@oracle.com
> Cc: hch@infradead.org
> ---
> drivers/scsi/Kconfig                      |    1 +
> drivers/scsi/Makefile                     |    1 +
> drivers/scsi/mpi3mr/Kconfig               |    7 +
> drivers/scsi/mpi3mr/mpi/mpi30_api.h       |   18 +
> drivers/scsi/mpi3mr/mpi/mpi30_image.h     |  220 +++++
> drivers/scsi/mpi3mr/mpi/mpi30_init.h      |  163 ++++
> drivers/scsi/mpi3mr/mpi/mpi30_ioc.h       | 1009 +++++++++++++++++++++
> drivers/scsi/mpi3mr/mpi/mpi30_transport.h |  486 ++++++++++
> 8 files changed, 1905 insertions(+)
> create mode 100644 drivers/scsi/mpi3mr/Kconfig
> create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_api.h
> create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_image.h
> create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_init.h
> create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
> create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_transport.h
>=20
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 06b87c7f6bab..1f06811740a7 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -482,6 +482,7 @@ config SCSI_ARCMSR
> source "drivers/scsi/esas2r/Kconfig"
> source "drivers/scsi/megaraid/Kconfig.megaraid"
> source "drivers/scsi/mpt3sas/Kconfig"
> +source "drivers/scsi/mpi3mr/Kconfig"
> source "drivers/scsi/smartpqi/Kconfig"
> source "drivers/scsi/ufs/Kconfig"
>=20
> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
> index bc3882f5cc69..06f2d5fab899 100644
> --- a/drivers/scsi/Makefile
> +++ b/drivers/scsi/Makefile
> @@ -99,6 +99,7 @@ obj-$(CONFIG_MEGARAID_LEGACY)	+=3D megaraid.o
> obj-$(CONFIG_MEGARAID_NEWGEN)	+=3D megaraid/
> obj-$(CONFIG_MEGARAID_SAS)	+=3D megaraid/
> obj-$(CONFIG_SCSI_MPT3SAS)	+=3D mpt3sas/
> +obj-$(CONFIG_SCSI_MPI3MR)	+=3D mpi3mr/
> obj-$(CONFIG_SCSI_UFSHCD)	+=3D ufs/
> obj-$(CONFIG_SCSI_ACARD)	+=3D atp870u.o
> obj-$(CONFIG_SCSI_SUNESP)	+=3D esp_scsi.o	sun_esp.o
> diff --git a/drivers/scsi/mpi3mr/Kconfig b/drivers/scsi/mpi3mr/Kconfig
> new file mode 100644
> index 000000000000..2d0568dd176a
> --- /dev/null
> +++ b/drivers/scsi/mpi3mr/Kconfig
> @@ -0,0 +1,7 @@
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +
> +config SCSI_MPI3MR
> +	tristate "Broadcom MPI3 Storage Controller Device Driver"
> +	depends on PCI && SCSI
> +	help
> +	This driver supports Broadcom's Unified MPI3 based Storage & RAID Contr=
ollers.
> diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_api.h b/drivers/scsi/mpi3mr/mp=
i/mpi30_api.h
> new file mode 100644
> index 000000000000..48247c254953
> --- /dev/null
> +++ b/drivers/scsi/mpi3mr/mpi/mpi30_api.h
> @@ -0,0 +1,18 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + *  Copyright 2019-2021 Broadcom Inc. All rights reserved.
> + *
> + *           Name: mpi30_api.h
> + *    Description: Root header that include all other MPI 3.0 headers
> + *                 Developers need to only include this header to gain
> + *                 access to the full MPI3.0 API definitions.
> + *  Creation Date: 04/15/2019
> + *        Version: 03.00.00
> + */
> +#ifndef MPI30_API_H
> +#define MPI30_API_H     1
> +#include "mpi30_transport.h"
> +#include "mpi30_image.h"
> +#include "mpi30_init.h"
> +#include "mpi30_ioc.h"
> +#endif
> diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_image.h b/drivers/scsi/mpi3mr/=
mpi/mpi30_image.h
> new file mode 100644
> index 000000000000..45e7510698cb
> --- /dev/null
> +++ b/drivers/scsi/mpi3mr/mpi/mpi30_image.h
> @@ -0,0 +1,220 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + *  Copyright 2018-2021 Broadcom Inc. All rights reserved.
> + *
> + *           Name: mpi30_image.h
> + *    Description: Contains definitions for firmware and other component=
 images.
> + *  Creation Date: 04/02/2018
> + *        Version: 03.00.00
> + */
> +#ifndef MPI30_IMAGE_H
> +#define MPI30_IMAGE_H     1
> +struct _mpi3_comp_image_version {
> +	__le16     build_num;
> +	__le16     customer_id;
> +	u8         phase_minor;
> +	u8         phase_major;
> +	u8         gen_minor;
> +	u8         gen_major;
> +};
> +
> +struct _mpi3_hash_exclusion_format {
> +	__le32                     offset;
> +	__le32                     size;
> +};
> +
> +#define MPI3_IMAGE_HASH_EXCUSION_NUM                           (4)
> +struct _mpi3_component_image_header {
> +	__le32                            signature0;
> +	__le32                            load_address;
> +	__le32                            data_size;
> +	__le32                            start_offset;
> +	__le32                            signature1;
> +	__le32                            flash_offset;
> +	__le32                            image_size;
> +	__le32                            version_string_offset;
> +	__le32                            build_date_string_offset;
> +	__le32                            build_time_string_offset;
> +	__le32                            environment_variable_offset;
> +	__le32                            application_specific;
> +	__le32                            signature2;
> +	__le32                            header_size;
> +	__le32                            crc;
> +	__le32                            flags;
> +	__le32                            secondary_flash_offset;
> +	__le32                            etp_offset;
> +	__le32                            etp_size;
> +	union _mpi3_version_union             rmc_interface_version;
> +	union _mpi3_version_union             etp_interface_version;
> +	struct _mpi3_comp_image_version        component_image_version;
> +	struct _mpi3_hash_exclusion_format     hash_exclusion[MPI3_IMAGE_HASH_E=
XCUSION_NUM];
> +	__le32                            next_image_header_offset;
> +	union _mpi3_version_union             security_version;
> +	__le32                            reserved84[31];
> +};
> +
> +#define MPI3_IMAGE_HEADER_SIGNATURE0_MPI3                     (0xeb00003=
e)
> +#define MPI3_IMAGE_HEADER_LOAD_ADDRESS_INVALID                (0x0000000=
0)
> +#define MPI3_IMAGE_HEADER_SIGNATURE1_APPLICATION              (0x2050504=
1)
> +#define MPI3_IMAGE_HEADER_SIGNATURE1_FIRST_MUTABLE            (0x20434d4=
6)
> +#define MPI3_IMAGE_HEADER_SIGNATURE1_BSP                      (0x2050534=
2)
> +#define MPI3_IMAGE_HEADER_SIGNATURE1_ROM_BIOS                 (0x534f494=
2)
> +#define MPI3_IMAGE_HEADER_SIGNATURE1_HII_X64                  (0x4d49494=
8)
> +#define MPI3_IMAGE_HEADER_SIGNATURE1_HII_ARM                  (0x4149494=
8)
> +#define MPI3_IMAGE_HEADER_SIGNATURE1_CPLD                     (0x444c504=
3)
> +#define MPI3_IMAGE_HEADER_SIGNATURE1_SPD                      (0x2044505=
3)
> +#define MPI3_IMAGE_HEADER_SIGNATURE1_GAS_GAUGE                (0x2053414=
7)
> +#define MPI3_IMAGE_HEADER_SIGNATURE1_PBLP                     (0x504c425=
0)
> +#define MPI3_IMAGE_HEADER_SIGNATURE2_VALUE                    (0x5058454=
6)
> +#define MPI3_IMAGE_HEADER_FLAGS_DEVICE_KEY_BASIS_MASK         (0x0000003=
0)
> +#define MPI3_IMAGE_HEADER_FLAGS_DEVICE_KEY_BASIS_CDI          (0x0000000=
0)
> +#define MPI3_IMAGE_HEADER_FLAGS_DEVICE_KEY_BASIS_DI           (0x0000001=
0)
> +#define MPI3_IMAGE_HEADER_FLAGS_SIGNED_NVDATA                 (0x0000000=
8)
> +#define MPI3_IMAGE_HEADER_FLAGS_REQUIRES_ACTIVATION           (0x0000000=
4)
> +#define MPI3_IMAGE_HEADER_FLAGS_COMPRESSED                    (0x0000000=
2)
> +#define MPI3_IMAGE_HEADER_FLAGS_FLASH                         (0x0000000=
1)
> +#define MPI3_IMAGE_HEADER_SIGNATURE0_OFFSET                   (0x00)
> +#define MPI3_IMAGE_HEADER_LOAD_ADDRESS_OFFSET                 (0x04)
> +#define MPI3_IMAGE_HEADER_DATA_SIZE_OFFSET                    (0x08)
> +#define MPI3_IMAGE_HEADER_START_OFFSET_OFFSET                 (0x0c)
> +#define MPI3_IMAGE_HEADER_SIGNATURE1_OFFSET                   (0x10)
> +#define MPI3_IMAGE_HEADER_FLASH_OFFSET_OFFSET                 (0x14)
> +#define MPI3_IMAGE_HEADER_FLASH_SIZE_OFFSET                   (0x18)
> +#define MPI3_IMAGE_HEADER_VERSION_STRING_OFFSET_OFFSET        (0x1c)
> +#define MPI3_IMAGE_HEADER_BUILD_DATE_STRING_OFFSET_OFFSET     (0x20)
> +#define MPI3_IMAGE_HEADER_BUILD_TIME_OFFSET_OFFSET            (0x24)
> +#define MPI3_IMAGE_HEADER_ENVIROMENT_VAR_OFFSET_OFFSET        (0x28)
> +#define MPI3_IMAGE_HEADER_APPLICATION_SPECIFIC_OFFSET         (0x2c)
> +#define MPI3_IMAGE_HEADER_SIGNATURE2_OFFSET                   (0x30)
> +#define MPI3_IMAGE_HEADER_HEADER_SIZE_OFFSET                  (0x34)
> +#define MPI3_IMAGE_HEADER_CRC_OFFSET                          (0x38)
> +#define MPI3_IMAGE_HEADER_FLAGS_OFFSET                        (0x3c)
> +#define MPI3_IMAGE_HEADER_SECONDARY_FLASH_OFFSET_OFFSET       (0x40)
> +#define MPI3_IMAGE_HEADER_ETP_OFFSET_OFFSET                   (0x44)
> +#define MPI3_IMAGE_HEADER_ETP_SIZE_OFFSET                     (0x48)
> +#define MPI3_IMAGE_HEADER_RMC_INTERFACE_VER_OFFSET            (0x4c)
> +#define MPI3_IMAGE_HEADER_ETP_INTERFACE_VER_OFFSET            (0x50)
> +#define MPI3_IMAGE_HEADER_COMPONENT_IMAGE_VER_OFFSET          (0x54)
> +#define MPI3_IMAGE_HEADER_HASH_EXCLUSION_OFFSET               (0x5c)
> +#define MPI3_IMAGE_HEADER_NEXT_IMAGE_HEADER_OFFSET_OFFSET     (0x7c)
> +#define MPI3_IMAGE_HEADER_SIZE                                (0x100)
> +struct _mpi3_extended_image_header {
> +	u8                                image_type;
> +	u8                                reserved01[3];
> +	__le32                            checksum;
> +	__le32                            image_size;
> +	__le32                            next_image_header_offset;
> +	__le32                            reserved10[4];
> +	__le32                            identify_string[8];
> +};
> +
> +#define MPI3_EXT_IMAGE_IMAGETYPE_OFFSET         (0x00)
> +#define MPI3_EXT_IMAGE_IMAGESIZE_OFFSET         (0x08)
> +#define MPI3_EXT_IMAGE_NEXTIMAGE_OFFSET         (0x0c)
> +#define MPI3_EXT_IMAGE_HEADER_SIZE              (0x40)
> +#define MPI3_EXT_IMAGE_TYPE_UNSPECIFIED             (0x00)
> +#define MPI3_EXT_IMAGE_TYPE_NVDATA                  (0x03)
> +#define MPI3_EXT_IMAGE_TYPE_SUPPORTED_DEVICES       (0x07)
> +#define MPI3_EXT_IMAGE_TYPE_ENCRYPTED_HASH          (0x09)
> +#define MPI3_EXT_IMAGE_TYPE_RDE                     (0x0a)
> +#define MPI3_EXT_IMAGE_TYPE_AUXILIARY_PROCESSOR     (0x0b)
> +#define MPI3_EXT_IMAGE_TYPE_MIN_PRODUCT_SPECIFIC    (0x80)
> +#define MPI3_EXT_IMAGE_TYPE_MAX_PRODUCT_SPECIFIC    (0xff)
> +struct _mpi3_supported_device {
> +	__le16                     device_id;
> +	__le16                     vendor_id;
> +	__le16                     device_id_mask;
> +	__le16                     reserved06;
> +	u8                         low_pci_rev;
> +	u8                         high_pci_rev;
> +	__le16                     reserved0a;
> +	__le32                     reserved0c;
> +};
> +
> +#ifndef MPI3_SUPPORTED_DEVICE_MAX
> +#define MPI3_SUPPORTED_DEVICE_MAX                      (1)
> +#endif
> +struct _mpi3_supported_devices_data {
> +	u8                         image_version;
> +	u8                         reserved01;
> +	u8                         num_devices;
> +	u8                         reserved03;
> +	__le32                     reserved04;
> +	struct _mpi3_supported_device   supported_device[MPI3_SUPPORTED_DEVICE_=
MAX];
> +};
> +
> +#ifndef MPI3_ENCRYPTED_HASH_MAX
> +#define MPI3_ENCRYPTED_HASH_MAX                      (1)
> +#endif
> +struct _mpi3_encrypted_hash_entry {
> +	u8                         hash_image_type;
> +	u8                         hash_algorithm;
> +	u8                         encryption_algorithm;
> +	u8                         reserved03;
> +	__le32                     reserved04;
> +	__le32                     encrypted_hash[MPI3_ENCRYPTED_HASH_MAX];
> +};
> +
> +#define MPI3_HASH_IMAGE_TYPE_KEY_WITH_SIGNATURE      (0x03)
> +#define MPI3_HASH_ALGORITHM_VERSION_MASK             (0xe0)
> +#define MPI3_HASH_ALGORITHM_VERSION_NONE             (0x00)
> +#define MPI3_HASH_ALGORITHM_VERSION_SHA1             (0x20)
> +#define MPI3_HASH_ALGORITHM_VERSION_SHA2             (0x40)
> +#define MPI3_HASH_ALGORITHM_VERSION_SHA3             (0x60)
> +#define MPI3_HASH_ALGORITHM_SIZE_MASK                (0x1f)
> +#define MPI3_HASH_ALGORITHM_SIZE_UNUSED              (0x00)
> +#define MPI3_HASH_ALGORITHM_SIZE_SHA256              (0x01)
> +#define MPI3_HASH_ALGORITHM_SIZE_SHA512              (0x02)
> +#define MPI3_ENCRYPTION_ALGORITHM_UNUSED             (0x00)
> +#define MPI3_ENCRYPTION_ALGORITHM_RSA256             (0x01)
> +#define MPI3_ENCRYPTION_ALGORITHM_RSA512             (0x02)
> +#define MPI3_ENCRYPTION_ALGORITHM_RSA1024            (0x03)
> +#define MPI3_ENCRYPTION_ALGORITHM_RSA2048            (0x04)
> +#define MPI3_ENCRYPTION_ALGORITHM_RSA4096            (0x05)
> +#define MPI3_ENCRYPTION_ALGORITHM_RSA3072            (0x06)
> +#ifndef MPI3_PUBLIC_KEY_MAX
> +#define MPI3_PUBLIC_KEY_MAX                          (1)
> +#endif
> +struct _mpi3_encrypted_key_with_hash_entry {
> +	u8                         hash_image_type;
> +	u8                         hash_algorithm;
> +	u8                         encryption_algorithm;
> +	u8                         reserved03;
> +	__le32                     reserved04;
> +	__le32                     public_key[MPI3_PUBLIC_KEY_MAX];
> +	__le32                     encrypted_hash[MPI3_ENCRYPTED_HASH_MAX];
> +};
> +
> +#ifndef MPI3_ENCRYPTED_HASH_ENTRY_MAX
> +#define MPI3_ENCRYPTED_HASH_ENTRY_MAX               (1)
> +#endif
> +struct _mpi3_encrypted_hash_data {
> +	u8                                  image_version;
> +	u8                                  num_hash;
> +	__le16                              reserved02;
> +	__le32                              reserved04;
> +	struct _mpi3_encrypted_hash_entry        encrypted_hash_entry[MPI3_ENCR=
YPTED_HASH_ENTRY_MAX];
> +};
> +
> +#ifndef MPI3_AUX_PROC_DATA_MAX
> +#define MPI3_AUX_PROC_DATA_MAX               (1)
> +#endif
> +struct _mpi3_aux_processor_data {
> +	u8                         boot_method;
> +	u8                         num_load_addr;
> +	u8                         reserved02;
> +	u8                         type;
> +	__le32                     version;
> +	__le32                     load_address[8];
> +	__le32                     reserved28[22];
> +	__le32                     aux_processor_data[MPI3_AUX_PROC_DATA_MAX];
> +};
> +
> +#define MPI3_AUX_PROC_DATA_OFFSET                                     (0=
x80)
> +#define MPI3_AUXPROCESSOR_BOOT_METHOD_MO_MSG                          (0=
x00)
> +#define MPI3_AUXPROCESSOR_BOOT_METHOD_MO_DOORBELL                     (0=
x01)
> +#define MPI3_AUXPROCESSOR_BOOT_METHOD_COMPONENT                       (0=
x02)
> +#define MPI3_AUXPROCESSOR_TYPE_ARM_A15                                (0=
x00)
> +#define MPI3_AUXPROCESSOR_TYPE_ARM_M0                                 (0=
x01)
> +#define MPI3_AUXPROCESSOR_TYPE_ARM_R4                                 (0=
x02)
> +#endif
> diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_init.h b/drivers/scsi/mpi3mr/m=
pi/mpi30_init.h
> new file mode 100644
> index 000000000000..dfd968681889
> --- /dev/null
> +++ b/drivers/scsi/mpi3mr/mpi/mpi30_init.h
> @@ -0,0 +1,163 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + *  Copyright 2016-2021 Broadcom Inc. All rights reserved.
> + *
> + *           Name: mpi30_init.h
> + *    Description: Contains definitions for SCSI initiator mode messages=
 and structures.
> + *  Creation Date: 10/27/2016
> + *        Version: 03.00.00
> + */
> +#ifndef MPI30_INIT_H
> +#define MPI30_INIT_H     1
> +struct _mpi3_scsi_io_cdb_eedp32 {
> +	u8                 cdb[20];
> +	__be32          primary_reference_tag;
> +	__le16             primary_application_tag;
> +	__le16             primary_application_tag_mask;
> +	__le32             transfer_length;
> +};
> +
> +union _mpi3_scso_io_cdb_union {
> +	u8                         cdb32[32];
> +	struct _mpi3_scsi_io_cdb_eedp32 eedp32;
> +	struct _mpi3_sge_common         sge;
> +};
> +
> +struct _mpi3_scsi_io_request {
> +	__le16                     host_tag;
> +	u8                         ioc_use_only02;
> +	u8                         function;
> +	__le16                     ioc_use_only04;
> +	u8                         ioc_use_only06;
> +	u8                         msg_flags;
> +	__le16                     change_count;
> +	__le16                     dev_handle;
> +	__le32                     flags;
> +	__le32                     skip_count;
> +	__le32                     data_length;
> +	u8                         lun[8];
> +	union _mpi3_scso_io_cdb_union  cdb;
> +	union _mpi3_sge_union          sgl[4];
> +};
> +
> +#define MPI3_SCSIIO_MSGFLAGS_METASGL_VALID                  (0x80)
> +#define MPI3_SCSIIO_FLAGS_LARGE_CDB                         (0x60000000)
> +#define MPI3_SCSIIO_FLAGS_CDB_16_OR_LESS                    (0x00000000)
> +#define MPI3_SCSIIO_FLAGS_CDB_GREATER_THAN_16               (0x20000000)
> +#define MPI3_SCSIIO_FLAGS_CDB_IN_SEPARATE_BUFFER            (0x40000000)
> +#define MPI3_SCSIIO_FLAGS_TASKATTRIBUTE_MASK                (0x07000000)
> +#define MPI3_SCSIIO_FLAGS_TASKATTRIBUTE_SIMPLEQ             (0x00000000)
> +#define MPI3_SCSIIO_FLAGS_TASKATTRIBUTE_HEADOFQ             (0x01000000)
> +#define MPI3_SCSIIO_FLAGS_TASKATTRIBUTE_ORDEREDQ            (0x02000000)
> +#define MPI3_SCSIIO_FLAGS_TASKATTRIBUTE_ACAQ                (0x04000000)
> +#define MPI3_SCSIIO_FLAGS_CMDPRI_MASK                       (0x00f00000)
> +#define MPI3_SCSIIO_FLAGS_CMDPRI_SHIFT                      (20)
> +#define MPI3_SCSIIO_FLAGS_DATADIRECTION_MASK                (0x000c0000)
> +#define MPI3_SCSIIO_FLAGS_DATADIRECTION_NO_DATA_TRANSFER    (0x00000000)
> +#define MPI3_SCSIIO_FLAGS_DATADIRECTION_WRITE               (0x00040000)
> +#define MPI3_SCSIIO_FLAGS_DATADIRECTION_READ                (0x00080000)
> +#define MPI3_SCSIIO_FLAGS_DMAOPERATION_MASK                 (0x00030000)
> +#define MPI3_SCSIIO_FLAGS_DMAOPERATION_HOST_PI              (0x00010000)
> +#define MPI3_SCSIIO_METASGL_INDEX                           (3)
> +struct _mpi3_scsi_io_reply {
> +	__le16                     host_tag;
> +	u8                         ioc_use_only02;
> +	u8                         function;
> +	__le16                     ioc_use_only04;
> +	u8                         ioc_use_only06;
> +	u8                         msg_flags;
> +	__le16                     ioc_use_only08;
> +	__le16                     ioc_status;
> +	__le32                     ioc_log_info;
> +	u8                         scsi_status;
> +	u8                         scsi_state;
> +	__le16                     dev_handle;
> +	__le32                     transfer_count;
> +	__le32                     sense_count;
> +	__le32                     response_data;
> +	__le16                     task_tag;
> +	__le16                     scsi_status_qualifier;
> +	__le32                     eedp_error_offset;
> +	__le16                     eedp_observed_app_tag;
> +	__le16                     eedp_observed_guard;
> +	__le32                     eedp_observed_ref_tag;
> +	__le64                     sense_data_buffer_address;
> +};
> +
> +#define MPI3_SCSIIO_REPLY_MSGFLAGS_REFTAG_OBSERVED_VALID        (0x01)
> +#define MPI3_SCSIIO_REPLY_MSGFLAGS_APPTAG_OBSERVED_VALID        (0x02)
> +#define MPI3_SCSIIO_REPLY_MSGFLAGS_GUARD_OBSERVED_VALID         (0x04)
> +#define MPI3_SCSI_STATUS_GOOD                   (0x00)
> +#define MPI3_SCSI_STATUS_CHECK_CONDITION        (0x02)
> +#define MPI3_SCSI_STATUS_CONDITION_MET          (0x04)
> +#define MPI3_SCSI_STATUS_BUSY                   (0x08)
> +#define MPI3_SCSI_STATUS_INTERMEDIATE           (0x10)
> +#define MPI3_SCSI_STATUS_INTERMEDIATE_CONDMET   (0x14)
> +#define MPI3_SCSI_STATUS_RESERVATION_CONFLICT   (0x18)
> +#define MPI3_SCSI_STATUS_COMMAND_TERMINATED     (0x22)
> +#define MPI3_SCSI_STATUS_TASK_SET_FULL          (0x28)
> +#define MPI3_SCSI_STATUS_ACA_ACTIVE             (0x30)
> +#define MPI3_SCSI_STATUS_TASK_ABORTED           (0x40)
> +#define MPI3_SCSI_STATE_SENSE_MASK              (0x03)
> +#define MPI3_SCSI_STATE_SENSE_VALID             (0x00)
> +#define MPI3_SCSI_STATE_SENSE_FAILED            (0x01)
> +#define MPI3_SCSI_STATE_SENSE_BUFF_Q_EMPTY      (0x02)
> +#define MPI3_SCSI_STATE_SENSE_NOT_AVAILABLE     (0x03)
> +#define MPI3_SCSI_STATE_NO_SCSI_STATUS          (0x04)
> +#define MPI3_SCSI_STATE_TERMINATED              (0x08)
> +#define MPI3_SCSI_STATE_RESPONSE_DATA_VALID     (0x10)
> +#define MPI3_SCSI_RSP_RESPONSECODE_MASK         (0x000000ff)
> +#define MPI3_SCSI_RSP_RESPONSECODE_SHIFT        (0)
> +#define MPI3_SCSI_RSP_ARI2_MASK                 (0x0000ff00)
> +#define MPI3_SCSI_RSP_ARI2_SHIFT                (8)
> +#define MPI3_SCSI_RSP_ARI1_MASK                 (0x00ff0000)
> +#define MPI3_SCSI_RSP_ARI1_SHIFT                (16)
> +#define MPI3_SCSI_RSP_ARI0_MASK                 (0xff000000)
> +#define MPI3_SCSI_RSP_ARI0_SHIFT                (24)
> +#define MPI3_SCSI_TASKTAG_UNKNOWN               (0xffff)
> +struct _mpi3_scsi_task_mgmt_request {
> +	__le16                     host_tag;
> +	u8                         ioc_use_only02;
> +	u8                         function;
> +	__le16                     ioc_use_only04;
> +	u8                         ioc_use_only06;
> +	u8                         msg_flags;
> +	__le16                     change_count;
> +	__le16                     dev_handle;
> +	__le16                     task_host_tag;
> +	u8                         task_type;
> +	u8                         reserved0f;
> +	__le16                     task_request_queue_id;
> +	__le16                     reserved12;
> +	__le32                     reserved14;
> +	u8                         lun[8];
> +};
> +
> +#define MPI3_SCSITASKMGMT_MSGFLAGS_DO_NOT_SEND_TASK_IU      (0x08)
> +#define MPI3_SCSITASKMGMT_TASKTYPE_ABORT_TASK               (0x01)
> +#define MPI3_SCSITASKMGMT_TASKTYPE_ABORT_TASK_SET           (0x02)
> +#define MPI3_SCSITASKMGMT_TASKTYPE_TARGET_RESET             (0x03)
> +#define MPI3_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET       (0x05)
> +#define MPI3_SCSITASKMGMT_TASKTYPE_CLEAR_TASK_SET           (0x06)
> +#define MPI3_SCSITASKMGMT_TASKTYPE_QUERY_TASK               (0x07)
> +#define MPI3_SCSITASKMGMT_TASKTYPE_CLEAR_ACA                (0x08)
> +#define MPI3_SCSITASKMGMT_TASKTYPE_QUERY_TASK_SET           (0x09)
> +#define MPI3_SCSITASKMGMT_TASKTYPE_QUERY_ASYNC_EVENT        (0x0a)
> +#define MPI3_SCSITASKMGMT_TASKTYPE_I_T_NEXUS_RESET          (0x0b)
> +struct _mpi3_scsi_task_mgmt_reply {
> +	__le16                     host_tag;
> +	u8                         ioc_use_only02;
> +	u8                         function;
> +	__le16                     ioc_use_only04;
> +	u8                         ioc_use_only06;
> +	u8                         msg_flags;
> +	__le16                     ioc_use_only08;
> +	__le16                     ioc_status;
> +	__le32                     ioc_log_info;
> +	__le32                     termination_count;
> +	__le32                     response_data;
> +	__le32                     reserved18;
> +};
> +
> +#define MPI3_SCSITASKMGMT_RSPCODE_IO_QUEUED_ON_IOC      (0x80)
> +#endif
> diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h b/drivers/scsi/mpi3mr/mp=
i/mpi30_ioc.h
> new file mode 100644
> index 000000000000..2c62075cbbe1
> --- /dev/null
> +++ b/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
> @@ -0,0 +1,1009 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + *  Copyright 2016-2021 Broadcom Inc. All rights reserved.
> + *
> + *           Name: mpi30_ioc.h
> + *    Description: Contains definitions for IOC messages such as IOC Ini=
t, IOC Facts, Port Enable,
> + *                 Events, FW Download, and FW Upload.
> + *  Creation Date: 10/24/2016
> + *        Version: 03.00.00
> + */
> +#ifndef MPI30_IOC_H
> +#define MPI30_IOC_H     1
> +struct _mpi3_ioc_init_request {
> +	__le16                   host_tag;
> +	u8                       ioc_use_only02;
> +	u8                       function;
> +	__le16                   ioc_use_only04;
> +	u8                       ioc_use_only06;
> +	u8                       msg_flags;
> +	__le16                   change_count;
> +	__le16                   reserved0a;
> +	union _mpi3_version_union    mpi_version;
> +	__le64                   time_stamp;
> +	u8                       reserved18;
> +	u8                       who_init;
> +	__le16                   reserved1a;
> +	__le16                   reply_free_queue_depth;
> +	__le16                   reserved1e;
> +	__le64                   reply_free_queue_address;
> +	__le32                   reserved28;
> +	__le16                   sense_buffer_free_queue_depth;
> +	__le16                   sense_buffer_length;
> +	__le64                   sense_buffer_free_queue_address;
> +	__le64                   driver_information_address;
> +};
> +
> +#define MPI3_WHOINIT_NOT_INITIALIZED            (0x00)
> +#define MPI3_WHOINIT_ROM_BIOS                   (0x02)
> +#define MPI3_WHOINIT_HOST_DRIVER                (0x03)
> +#define MPI3_WHOINIT_MANUFACTURER               (0x04)
> +struct _mpi3_driver_info_layout {
> +	__le32             information_length;
> +	u8                 driver_signature[12];
> +	u8                 os_name[16];
> +	u8                 os_version[12];
> +	u8                 driver_name[20];
> +	u8                 driver_version[32];
> +	u8                 driver_release_date[20];
> +	__le32             driver_capabilities;
> +};
> +
> +struct _mpi3_ioc_facts_request {
> +	__le16                 host_tag;
> +	u8                     ioc_use_only02;
> +	u8                     function;
> +	__le16                 ioc_use_only04;
> +	u8                     ioc_use_only06;
> +	u8                     msg_flags;
> +	__le16                 change_count;
> +	__le16                 reserved0a;
> +	__le32                 reserved0c;
> +	union _mpi3_sge_union      sgl;
> +};
> +
> +struct _mpi3_ioc_facts_data {
> +	__le16                     ioc_facts_data_length;
> +	__le16                     reserved02;
> +	union _mpi3_version_union      mpi_version;
> +	struct _mpi3_comp_image_version fw_version;
> +	__le32                     ioc_capabilities;
> +	u8                         ioc_number;
> +	u8                         who_init;
> +	__le16                     max_msix_vectors;
> +	__le16                     max_outstanding_request;
> +	__le16                     product_id;
> +	__le16                     ioc_request_frame_size;
> +	__le16                     reply_frame_size;
> +	__le16                     ioc_exceptions;
> +	__le16                     max_persistent_id;
> +	u8                         sge_modifier_mask;
> +	u8                         sge_modifier_value;
> +	u8                         sge_modifier_shift;
> +	u8                         protocol_flags;
> +	__le16                     max_sas_initiators;
> +	__le16                     max_sas_targets;
> +	__le16                     max_sas_expanders;
> +	__le16                     max_enclosures;
> +	__le16                     min_dev_handle;
> +	__le16                     max_dev_handle;
> +	__le16                     max_pc_ie_switches;
> +	__le16                     max_nvme;
> +	__le16                     max_pds;
> +	__le16                     max_vds;
> +	__le16                     max_host_pds;
> +	__le16                     max_advanced_host_pds;
> +	__le16                     max_raid_pds;
> +	__le16                     max_posted_cmd_buffers;
> +	__le32                     flags;
> +	__le16                     max_operational_request_queues;
> +	__le16                     max_operational_reply_queues;
> +	__le16                     shutdown_timeout;
> +	__le16                     reserved4e;
> +	__le32                     diag_trace_size;
> +	__le32                     diag_fw_size;
> +};
> +
> +#define MPI3_IOCFACTS_CAPABILITY_ADVANCED_HOST_PD             (0x0000001=
0)
> +#define MPI3_IOCFACTS_CAPABILITY_RAID_CAPABLE                 (0x0000000=
8)
> +#define MPI3_IOCFACTS_CAPABILITY_COALESCE_CTRL_GRAN_MASK      (0x0000000=
1)
> +#define MPI3_IOCFACTS_CAPABILITY_COALESCE_CTRL_IOC_GRAN       (0x0000000=
0)
> +#define MPI3_IOCFACTS_CAPABILITY_COALESCE_CTRL_REPLY_Q_GRAN   (0x0000000=
1)
> +#define MPI3_IOCFACTS_PID_TYPE_MASK                           (0xf000)
> +#define MPI3_IOCFACTS_PID_TYPE_SHIFT                          (12)
> +#define MPI3_IOCFACTS_PID_PRODUCT_MASK                        (0x0f00)
> +#define MPI3_IOCFACTS_PID_PRODUCT_SHIFT                       (8)
> +#define MPI3_IOCFACTS_PID_FAMILY_MASK                         (0x00ff)
> +#define MPI3_IOCFACTS_PID_FAMILY_SHIFT                        (0)
> +#define MPI3_IOCFACTS_EXCEPT_SAFE_MODE                        (0x0800)
> +#define MPI3_IOCFACTS_EXCEPT_SECURITY_KEY_MASK                (0x0700)
> +#define MPI3_IOCFACTS_EXCEPT_SECURITY_KEY_NONE                (0x0000)
> +#define MPI3_IOCFACTS_EXCEPT_SECURITY_KEY_LOCAL_VIA_RAID      (0x0100)
> +#define MPI3_IOCFACTS_EXCEPT_SECURITY_KEY_LOCAL_VIA_OOB       (0x0200)
> +#define MPI3_IOCFACTS_EXCEPT_SECURITY_KEY_EXT_VIA_RAID        (0x0300)
> +#define MPI3_IOCFACTS_EXCEPT_SECURITY_KEY_EXT_VIA_OOB         (0x0400)
> +#define MPI3_IOCFACTS_EXCEPT_PCIE_DISABLED                    (0x0080)
> +#define MPI3_IOCFACTS_EXCEPT_PARTIAL_MEMORY_FAILURE           (0x0040)
> +#define MPI3_IOCFACTS_EXCEPT_MANUFACT_CHECKSUM_FAIL           (0x0020)
> +#define MPI3_IOCFACTS_EXCEPT_FW_CHECKSUM_FAIL                 (0x0010)
> +#define MPI3_IOCFACTS_EXCEPT_CONFIG_CHECKSUM_FAIL             (0x0008)
> +#define MPI3_IOCFACTS_EXCEPT_BOOTSTAT_MASK                    (0x0001)
> +#define MPI3_IOCFACTS_EXCEPT_BOOTSTAT_PRIMARY                 (0x0000)
> +#define MPI3_IOCFACTS_EXCEPT_BOOTSTAT_SECONDARY               (0x0001)
> +#define MPI3_IOCFACTS_PROTOCOL_SAS                            (0x0010)
> +#define MPI3_IOCFACTS_PROTOCOL_SATA                           (0x0008)
> +#define MPI3_IOCFACTS_PROTOCOL_NVME                           (0x0004)
> +#define MPI3_IOCFACTS_PROTOCOL_SCSI_INITIATOR                 (0x0002)
> +#define MPI3_IOCFACTS_PROTOCOL_SCSI_TARGET                    (0x0001)
> +#define MPI3_IOCFACTS_FLAGS_SIGNED_NVDATA_REQUIRED            (0x0001000=
0)
> +#define MPI3_IOCFACTS_FLAGS_DMA_ADDRESS_WIDTH_MASK            (0x0000ff0=
0)
> +#define MPI3_IOCFACTS_FLAGS_DMA_ADDRESS_WIDTH_SHIFT           (8)
> +#define MPI3_IOCFACTS_FLAGS_INITIAL_PORT_ENABLE_MASK          (0x0000003=
0)
> +#define MPI3_IOCFACTS_FLAGS_INITIAL_PORT_ENABLE_NOT_STARTED   (0x0000000=
0)
> +#define MPI3_IOCFACTS_FLAGS_INITIAL_PORT_ENABLE_IN_PROGRESS   (0x0000001=
0)
> +#define MPI3_IOCFACTS_FLAGS_INITIAL_PORT_ENABLE_COMPLETE      (0x0000002=
0)
> +#define MPI3_IOCFACTS_FLAGS_PERSONALITY_MASK                  (0x0000000=
f)
> +#define MPI3_IOCFACTS_FLAGS_PERSONALITY_EHBA                  (0x0000000=
0)
> +#define MPI3_IOCFACTS_FLAGS_PERSONALITY_RAID_DDR              (0x0000000=
2)
> +struct _mpi3_mgmt_passthrough_request {
> +	__le16                 host_tag;
> +	u8                     ioc_use_only02;
> +	u8                     function;
> +	__le16                 ioc_use_only04;
> +	u8                     ioc_use_only06;
> +	u8                     msg_flags;
> +	__le16                 change_count;
> +	__le16                 reserved0a;
> +	__le32                 reserved0c[5];
> +	union _mpi3_sge_union      command_sgl;
> +	union _mpi3_sge_union      response_sgl;
> +};
> +
> +struct _mpi3_create_request_queue_request {
> +	__le16             host_tag;
> +	u8                 ioc_use_only02;
> +	u8                 function;
> +	__le16             ioc_use_only04;
> +	u8                 ioc_use_only06;
> +	u8                 msg_flags;
> +	__le16             change_count;
> +	u8                 flags;
> +	u8                 burst;
> +	__le16             size;
> +	__le16             queue_id;
> +	__le16             reply_queue_id;
> +	__le16             reserved12;
> +	__le32             reserved14;
> +	__le64             base_address;
> +};
> +
> +#define MPI3_CREATE_REQUEST_QUEUE_FLAGS_SEGMENTED_MASK          (0x80)
> +#define MPI3_CREATE_REQUEST_QUEUE_FLAGS_SEGMENTED_SEGMENTED     (0x80)
> +#define MPI3_CREATE_REQUEST_QUEUE_FLAGS_SEGMENTED_CONTIGUOUS    (0x00)
> +struct _mpi3_delete_request_queue_request {
> +	__le16             host_tag;
> +	u8                 ioc_use_only02;
> +	u8                 function;
> +	__le16             ioc_use_only04;
> +	u8                 ioc_use_only06;
> +	u8                 msg_flags;
> +	__le16             change_count;
> +	__le16             queue_id;
> +};
> +
> +struct _mpi3_create_reply_queue_request {
> +	__le16             host_tag;
> +	u8                 ioc_use_only02;
> +	u8                 function;
> +	__le16             ioc_use_only04;
> +	u8                 ioc_use_only06;
> +	u8                 msg_flags;
> +	__le16             change_count;
> +	u8                 flags;
> +	u8                 reserved0b;
> +	__le16             size;
> +	__le16             queue_id;
> +	__le16             msix_index;
> +	__le16             reserved12;
> +	__le32             reserved14;
> +	__le64             base_address;
> +};
> +
> +#define MPI3_CREATE_REPLY_QUEUE_FLAGS_SEGMENTED_MASK            (0x80)
> +#define MPI3_CREATE_REPLY_QUEUE_FLAGS_SEGMENTED_SEGMENTED       (0x80)
> +#define MPI3_CREATE_REPLY_QUEUE_FLAGS_SEGMENTED_CONTIGUOUS      (0x00)
> +#define MPI3_CREATE_REPLY_QUEUE_FLAGS_INT_ENABLE_MASK           (0x01)
> +#define MPI3_CREATE_REPLY_QUEUE_FLAGS_INT_ENABLE_DISABLE        (0x00)
> +#define MPI3_CREATE_REPLY_QUEUE_FLAGS_INT_ENABLE_ENABLE         (0x01)
> +struct _mpi3_delete_reply_queue_request {
> +	__le16             host_tag;
> +	u8                 ioc_use_only02;
> +	u8                 function;
> +	__le16             ioc_use_only04;
> +	u8                 ioc_use_only06;
> +	u8                 msg_flags;
> +	__le16             change_count;
> +	__le16             queue_id;
> +};
> +
> +struct _mpi3_port_enable_request {
> +	__le16             host_tag;
> +	u8                 ioc_use_only02;
> +	u8                 function;
> +	__le16             ioc_use_only04;
> +	u8                 ioc_use_only06;
> +	u8                 msg_flags;
> +	__le16             change_count;
> +	__le16             reserved0a;
> +};
> +
> +#define MPI3_EVENT_LOG_DATA                         (0x01)
> +#define MPI3_EVENT_CHANGE                           (0x02)
> +#define MPI3_EVENT_GPIO_INTERRUPT                   (0x04)
> +#define MPI3_EVENT_TEMP_THRESHOLD                   (0x05)
> +#define MPI3_EVENT_CABLE_MGMT                       (0x06)
> +#define MPI3_EVENT_DEVICE_ADDED                     (0x07)
> +#define MPI3_EVENT_DEVICE_INFO_CHANGED              (0x08)
> +#define MPI3_EVENT_PREPARE_FOR_RESET                (0x09)
> +#define MPI3_EVENT_COMP_IMAGE_ACT_START             (0x0a)
> +#define MPI3_EVENT_ENCL_DEVICE_ADDED                (0x0b)
> +#define MPI3_EVENT_ENCL_DEVICE_STATUS_CHANGE        (0x0c)
> +#define MPI3_EVENT_DEVICE_STATUS_CHANGE             (0x0d)
> +#define MPI3_EVENT_ENERGY_PACK_CHANGE               (0x0e)
> +#define MPI3_EVENT_SAS_DISCOVERY                    (0x11)
> +#define MPI3_EVENT_SAS_BROADCAST_PRIMITIVE          (0x12)
> +#define MPI3_EVENT_SAS_NOTIFY_PRIMITIVE             (0x13)
> +#define MPI3_EVENT_SAS_INIT_DEVICE_STATUS_CHANGE    (0x14)
> +#define MPI3_EVENT_SAS_INIT_TABLE_OVERFLOW          (0x15)
> +#define MPI3_EVENT_SAS_TOPOLOGY_CHANGE_LIST         (0x16)
> +#define MPI3_EVENT_SAS_PHY_COUNTER                  (0x18)
> +#define MPI3_EVENT_SAS_DEVICE_DISCOVERY_ERROR       (0x19)
> +#define MPI3_EVENT_PCIE_TOPOLOGY_CHANGE_LIST        (0x20)
> +#define MPI3_EVENT_PCIE_ENUMERATION                 (0x22)
> +#define MPI3_EVENT_HARD_RESET_RECEIVED              (0x40)
> +#define MPI3_EVENT_MIN_PRODUCT_SPECIFIC             (0x60)
> +#define MPI3_EVENT_MAX_PRODUCT_SPECIFIC             (0x7f)
> +#define MPI3_EVENT_NOTIFY_EVENTMASK_WORDS           (4)
> +struct _mpi3_event_notification_request {
> +	__le16             host_tag;
> +	u8                 ioc_use_only02;
> +	u8                 function;
> +	__le16             ioc_use_only04;
> +	u8                 ioc_use_only06;
> +	u8                 msg_flags;
> +	__le16             change_count;
> +	__le16             reserved0a;
> +	__le16             sas_broadcast_primitive_masks;
> +	__le16             sas_notify_primitive_masks;
> +	__le32             event_masks[MPI3_EVENT_NOTIFY_EVENTMASK_WORDS];
> +};
> +
> +struct _mpi3_event_notification_reply {
> +	__le16             host_tag;
> +	u8                 ioc_use_only02;
> +	u8                 function;
> +	__le16             ioc_use_only04;
> +	u8                 ioc_use_only06;
> +	u8                 msg_flags;
> +	__le16             ioc_use_only08;
> +	__le16             ioc_status;
> +	__le32             ioc_log_info;
> +	u8                 event_data_length;
> +	u8                 event;
> +	__le16             ioc_change_count;
> +	__le32             event_context;
> +	__le32             event_data[1];
> +};
> +
> +#define MPI3_EVENT_NOTIFY_MSGFLAGS_ACK_MASK                        (0x01=
)
> +#define MPI3_EVENT_NOTIFY_MSGFLAGS_ACK_REQUIRED                    (0x01=
)
> +#define MPI3_EVENT_NOTIFY_MSGFLAGS_ACK_NOT_REQUIRED                (0x00=
)
> +#define MPI3_EVENT_NOTIFY_MSGFLAGS_EVENT_ORIGINALITY_MASK          (0x02=
)
> +#define MPI3_EVENT_NOTIFY_MSGFLAGS_EVENT_ORIGINALITY_ORIGINAL      (0x00=
)
> +#define MPI3_EVENT_NOTIFY_MSGFLAGS_EVENT_ORIGINALITY_REPLAY        (0x02=
)
> +struct _mpi3_event_data_gpio_interrupt {
> +	u8                 gpio_num;
> +	u8                 reserved01[3];
> +};
> +
> +struct _mpi3_event_data_temp_threshold {
> +	__le16             status;
> +	u8                 sensor_num;
> +	u8                 reserved03;
> +	__le16             current_temperature;
> +	__le16             reserved06;
> +	__le32             reserved08;
> +	__le32             reserved0c;
> +};
> +
> +#define MPI3_EVENT_TEMP_THRESHOLD_STATUS_THRESHOLD3_EXCEEDED         (0x=
0008)
> +#define MPI3_EVENT_TEMP_THRESHOLD_STATUS_THRESHOLD2_EXCEEDED         (0x=
0004)
> +#define MPI3_EVENT_TEMP_THRESHOLD_STATUS_THRESHOLD1_EXCEEDED         (0x=
0002)
> +#define MPI3_EVENT_TEMP_THRESHOLD_STATUS_THRESHOLD0_EXCEEDED         (0x=
0001)
> +struct _mpi3_event_data_cable_management {
> +	__le32             active_cable_power_requirement;
> +	u8                 status;
> +	u8                 receptacle_id;
> +	__le16             reserved06;
> +};
> +
> +#define MPI3_EVENT_CABLE_MGMT_ACT_CABLE_PWR_INVALID     (0xffffffff)
> +#define MPI3_EVENT_CABLE_MGMT_STATUS_INSUFFICIENT_POWER        (0x00)
> +#define MPI3_EVENT_CABLE_MGMT_STATUS_PRESENT                   (0x01)
> +#define MPI3_EVENT_CABLE_MGMT_STATUS_DEGRADED                  (0x02)
> +struct _mpi3_event_ack_request {
> +	__le16             host_tag;
> +	u8                 ioc_use_only02;
> +	u8                 function;
> +	__le16             ioc_use_only04;
> +	u8                 ioc_use_only06;
> +	u8                 msg_flags;
> +	__le16             change_count;
> +	__le16             reserved0a;
> +	u8                 event;
> +	u8                 reserved0d[3];
> +	__le32             event_context;
> +};
> +
> +struct _mpi3_event_data_prepare_for_reset {
> +	u8                 reason_code;
> +	u8                 reserved01;
> +	__le16             reserved02;
> +};
> +
> +#define MPI3_EVENT_PREPARE_RESET_RC_START                (0x01)
> +#define MPI3_EVENT_PREPARE_RESET_RC_ABORT                (0x02)
> +struct _mpi3_event_data_comp_image_activation {
> +	__le32            reserved00;
> +};
> +
> +struct _mpi3_event_data_device_status_change {
> +	__le16             task_tag;
> +	u8                 reason_code;
> +	u8                 io_unit_port;
> +	__le16             parent_dev_handle;
> +	__le16             dev_handle;
> +	__le64             wwid;
> +	u8                 lun[8];
> +};
> +
> +#define MPI3_EVENT_DEV_STAT_RC_MOVED                                (0x0=
1)
> +#define MPI3_EVENT_DEV_STAT_RC_HIDDEN                               (0x0=
2)
> +#define MPI3_EVENT_DEV_STAT_RC_NOT_HIDDEN                           (0x0=
3)
> +#define MPI3_EVENT_DEV_STAT_RC_ASYNC_NOTIFICATION                   (0x0=
4)
> +#define MPI3_EVENT_DEV_STAT_RC_INT_DEVICE_RESET_STRT                (0x2=
0)
> +#define MPI3_EVENT_DEV_STAT_RC_INT_DEVICE_RESET_CMP                 (0x2=
1)
> +#define MPI3_EVENT_DEV_STAT_RC_INT_TASK_ABORT_STRT                  (0x2=
2)
> +#define MPI3_EVENT_DEV_STAT_RC_INT_TASK_ABORT_CMP                   (0x2=
3)
> +#define MPI3_EVENT_DEV_STAT_RC_INT_IT_NEXUS_RESET_STRT              (0x2=
4)
> +#define MPI3_EVENT_DEV_STAT_RC_INT_IT_NEXUS_RESET_CMP               (0x2=
5)
> +#define MPI3_EVENT_DEV_STAT_RC_PCIE_HOT_RESET_FAILED                (0x3=
0)
> +#define MPI3_EVENT_DEV_STAT_RC_EXPANDER_REDUCED_FUNC_STRT           (0x4=
0)
> +#define MPI3_EVENT_DEV_STAT_RC_EXPANDER_REDUCED_FUNC_CMP            (0x4=
1)
> +#define MPI3_EVENT_DEV_STAT_RC_VD_NOT_RESPONDING                    (0x5=
0)
> +struct _mpi3_event_data_energy_pack_change {
> +	__le32             reserved00;
> +	__le16             shutdown_timeout;
> +	__le16             reserved06;
> +};
> +
> +struct _mpi3_event_data_sas_discovery {
> +	u8                 flags;
> +	u8                 reason_code;
> +	u8                 io_unit_port;
> +	u8                 reserved03;
> +	__le32             discovery_status;
> +};
> +
> +#define MPI3_EVENT_SAS_DISC_FLAGS_DEVICE_CHANGE                 (0x02)
> +#define MPI3_EVENT_SAS_DISC_FLAGS_IN_PROGRESS                   (0x01)
> +#define MPI3_EVENT_SAS_DISC_RC_STARTED                          (0x01)
> +#define MPI3_EVENT_SAS_DISC_RC_COMPLETED                        (0x02)
> +#define MPI3_SAS_DISC_STATUS_MAX_ENCLOSURES_EXCEED            (0x8000000=
0)
> +#define MPI3_SAS_DISC_STATUS_MAX_EXPANDERS_EXCEED             (0x4000000=
0)
> +#define MPI3_SAS_DISC_STATUS_MAX_DEVICES_EXCEED               (0x2000000=
0)
> +#define MPI3_SAS_DISC_STATUS_MAX_TOPO_PHYS_EXCEED             (0x1000000=
0)
> +#define MPI3_SAS_DISC_STATUS_MULTIPLE_DEVICES_IN_SLOT         (0x0000400=
0)
> +#define MPI3_SAS_DISC_STATUS_SLOT_COUNT_MISMATCH              (0x0000200=
0)
> +#define MPI3_SAS_DISC_STATUS_TOO_MANY_SLOTS                   (0x0000100=
0)
> +#define MPI3_SAS_DISC_STATUS_EXP_MULTI_SUBTRACTIVE            (0x0000080=
0)
> +#define MPI3_SAS_DISC_STATUS_MULTI_PORT_DOMAIN                (0x0000040=
0)
> +#define MPI3_SAS_DISC_STATUS_TABLE_TO_SUBTRACTIVE_LINK        (0x0000020=
0)
> +#define MPI3_SAS_DISC_STATUS_UNSUPPORTED_DEVICE               (0x0000010=
0)
> +#define MPI3_SAS_DISC_STATUS_TABLE_LINK                       (0x0000008=
0)
> +#define MPI3_SAS_DISC_STATUS_SUBTRACTIVE_LINK                 (0x0000004=
0)
> +#define MPI3_SAS_DISC_STATUS_SMP_CRC_ERROR                    (0x0000002=
0)
> +#define MPI3_SAS_DISC_STATUS_SMP_FUNCTION_FAILED              (0x0000001=
0)
> +#define MPI3_SAS_DISC_STATUS_SMP_TIMEOUT                      (0x0000000=
8)
> +#define MPI3_SAS_DISC_STATUS_MULTIPLE_PORTS                   (0x0000000=
4)
> +#define MPI3_SAS_DISC_STATUS_INVALID_SAS_ADDRESS              (0x0000000=
2)
> +#define MPI3_SAS_DISC_STATUS_LOOP_DETECTED                    (0x0000000=
1)
> +struct _mpi3_event_data_sas_broadcast_primitive {
> +	u8                 phy_num;
> +	u8                 io_unit_port;
> +	u8                 port_width;
> +	u8                 primitive;
> +};
> +
> +#define MPI3_EVENT_BROADCAST_PRIMITIVE_CHANGE                 (0x01)
> +#define MPI3_EVENT_BROADCAST_PRIMITIVE_SES                    (0x02)
> +#define MPI3_EVENT_BROADCAST_PRIMITIVE_EXPANDER               (0x03)
> +#define MPI3_EVENT_BROADCAST_PRIMITIVE_ASYNCHRONOUS_EVENT     (0x04)
> +#define MPI3_EVENT_BROADCAST_PRIMITIVE_RESERVED3              (0x05)
> +#define MPI3_EVENT_BROADCAST_PRIMITIVE_RESERVED4              (0x06)
> +#define MPI3_EVENT_BROADCAST_PRIMITIVE_CHANGE0_RESERVED       (0x07)
> +#define MPI3_EVENT_BROADCAST_PRIMITIVE_CHANGE1_RESERVED       (0x08)
> +struct _mpi3_event_data_sas_notify_primitive {
> +	u8                 phy_num;
> +	u8                 io_unit_port;
> +	u8                 reserved02;
> +	u8                 primitive;
> +};
> +
> +#define MPI3_EVENT_NOTIFY_PRIMITIVE_ENABLE_SPINUP         (0x01)
> +#define MPI3_EVENT_NOTIFY_PRIMITIVE_POWER_LOSS_EXPECTED   (0x02)
> +#define MPI3_EVENT_NOTIFY_PRIMITIVE_RESERVED1             (0x03)
> +#define MPI3_EVENT_NOTIFY_PRIMITIVE_RESERVED2             (0x04)
> +#ifndef MPI3_EVENT_SAS_TOPO_PHY_COUNT
> +#define MPI3_EVENT_SAS_TOPO_PHY_COUNT           (1)
> +#endif
> +struct _mpi3_event_sas_topo_phy_entry {
> +	__le16             attached_dev_handle;
> +	u8                 link_rate;
> +	u8                 status;
> +};
> +
> +#define MPI3_EVENT_SAS_TOPO_LR_CURRENT_MASK                 (0xf0)
> +#define MPI3_EVENT_SAS_TOPO_LR_CURRENT_SHIFT                (4)
> +#define MPI3_EVENT_SAS_TOPO_LR_PREV_MASK                    (0x0f)
> +#define MPI3_EVENT_SAS_TOPO_LR_PREV_SHIFT                   (0)
> +#define MPI3_EVENT_SAS_TOPO_LR_UNKNOWN_LINK_RATE            (0x00)
> +#define MPI3_EVENT_SAS_TOPO_LR_PHY_DISABLED                 (0x01)
> +#define MPI3_EVENT_SAS_TOPO_LR_NEGOTIATION_FAILED           (0x02)
> +#define MPI3_EVENT_SAS_TOPO_LR_SATA_OOB_COMPLETE            (0x03)
> +#define MPI3_EVENT_SAS_TOPO_LR_PORT_SELECTOR                (0x04)
> +#define MPI3_EVENT_SAS_TOPO_LR_SMP_RESET_IN_PROGRESS        (0x05)
> +#define MPI3_EVENT_SAS_TOPO_LR_UNSUPPORTED_PHY              (0x06)
> +#define MPI3_EVENT_SAS_TOPO_LR_RATE_6_0                     (0x0a)
> +#define MPI3_EVENT_SAS_TOPO_LR_RATE_12_0                    (0x0b)
> +#define MPI3_EVENT_SAS_TOPO_LR_RATE_22_5                    (0x0c)
> +#define MPI3_EVENT_SAS_TOPO_PHY_STATUS_MASK                 (0xc0)
> +#define MPI3_EVENT_SAS_TOPO_PHY_STATUS_SHIFT                (6)
> +#define MPI3_EVENT_SAS_TOPO_PHY_STATUS_ACCESSIBLE           (0x00)
> +#define MPI3_EVENT_SAS_TOPO_PHY_STATUS_NO_EXIST             (0x40)
> +#define MPI3_EVENT_SAS_TOPO_PHY_STATUS_VACANT               (0x80)
> +#define MPI3_EVENT_SAS_TOPO_PHY_RC_MASK                     (0x0f)
> +#define MPI3_EVENT_SAS_TOPO_PHY_RC_TARG_NOT_RESPONDING      (0x02)
> +#define MPI3_EVENT_SAS_TOPO_PHY_RC_PHY_CHANGED              (0x03)
> +#define MPI3_EVENT_SAS_TOPO_PHY_RC_NO_CHANGE                (0x04)
> +#define MPI3_EVENT_SAS_TOPO_PHY_RC_DELAY_NOT_RESPONDING     (0x05)
> +#define MPI3_EVENT_SAS_TOPO_PHY_RC_RESPONDING               (0x06)
> +struct _mpi3_event_data_sas_topology_change_list {
> +	__le16                             enclosure_handle;
> +	__le16                             expander_dev_handle;
> +	u8                                 num_phys;
> +	u8                                 reserved05[3];
> +	u8                                 num_entries;
> +	u8                                 start_phy_num;
> +	u8                                 exp_status;
> +	u8                                 io_unit_port;
> +	struct _mpi3_event_sas_topo_phy_entry   phy_entry[MPI3_EVENT_SAS_TOPO_P=
HY_COUNT];
> +};
> +
> +#define MPI3_EVENT_SAS_TOPO_ES_NO_EXPANDER              (0x00)
> +#define MPI3_EVENT_SAS_TOPO_ES_NOT_RESPONDING           (0x02)
> +#define MPI3_EVENT_SAS_TOPO_ES_RESPONDING               (0x03)
> +#define MPI3_EVENT_SAS_TOPO_ES_DELAY_NOT_RESPONDING     (0x04)
> +struct _mpi3_event_data_sas_phy_counter {
> +	__le64             time_stamp;
> +	__le32             reserved08;
> +	u8                 phy_event_code;
> +	u8                 phy_num;
> +	__le16             reserved0e;
> +	__le32             phy_event_info;
> +	u8                 counter_type;
> +	u8                 threshold_window;
> +	u8                 time_units;
> +	u8                 reserved17;
> +	__le32             event_threshold;
> +	__le16             threshold_flags;
> +	__le16             reserved1e;
> +};
> +
> +struct _mpi3_event_data_sas_device_disc_err {
> +	__le16             dev_handle;
> +	u8                 reason_code;
> +	u8                 io_unit_port;
> +	__le32             reserved04;
> +	__le64             sas_address;
> +};
> +
> +#define MPI3_EVENT_SAS_DISC_ERR_RC_SMP_FAILED          (0x01)
> +#define MPI3_EVENT_SAS_DISC_ERR_RC_SMP_TIMEOUT         (0x02)
> +struct _mpi3_event_data_pcie_enumeration {
> +	u8                 flags;
> +	u8                 reason_code;
> +	u8                 io_unit_port;
> +	u8                 reserved03;
> +	__le32             enumeration_status;
> +};
> +
> +#define MPI3_EVENT_PCIE_ENUM_FLAGS_DEVICE_CHANGE            (0x02)
> +#define MPI3_EVENT_PCIE_ENUM_FLAGS_IN_PROGRESS              (0x01)
> +#define MPI3_EVENT_PCIE_ENUM_RC_STARTED                     (0x01)
> +#define MPI3_EVENT_PCIE_ENUM_RC_COMPLETED                   (0x02)
> +#define MPI3_EVENT_PCIE_ENUM_ES_MAX_SWITCH_DEPTH_EXCEED     (0x80000000)
> +#define MPI3_EVENT_PCIE_ENUM_ES_MAX_SWITCHES_EXCEED         (0x40000000)
> +#define MPI3_EVENT_PCIE_ENUM_ES_MAX_DEVICES_EXCEED          (0x20000000)
> +#define MPI3_EVENT_PCIE_ENUM_ES_RESOURCES_EXHAUSTED         (0x10000000)
> +#ifndef MPI3_EVENT_PCIE_TOPO_PORT_COUNT
> +#define MPI3_EVENT_PCIE_TOPO_PORT_COUNT         (1)
> +#endif
> +struct _mpi3_event_pcie_topo_port_entry {
> +	__le16             attached_dev_handle;
> +	u8                 port_status;
> +	u8                 reserved03;
> +	u8                 current_port_info;
> +	u8                 reserved05;
> +	u8                 previous_port_info;
> +	u8                 reserved07;
> +};
> +
> +#define MPI3_EVENT_PCIE_TOPO_PS_NOT_RESPONDING          (0x02)
> +#define MPI3_EVENT_PCIE_TOPO_PS_PORT_CHANGED            (0x03)
> +#define MPI3_EVENT_PCIE_TOPO_PS_NO_CHANGE               (0x04)
> +#define MPI3_EVENT_PCIE_TOPO_PS_DELAY_NOT_RESPONDING    (0x05)
> +#define MPI3_EVENT_PCIE_TOPO_PS_RESPONDING              (0x06)
> +#define MPI3_EVENT_PCIE_TOPO_PI_LANES_MASK              (0xf0)
> +#define MPI3_EVENT_PCIE_TOPO_PI_LANES_UNKNOWN           (0x00)
> +#define MPI3_EVENT_PCIE_TOPO_PI_LANES_1                 (0x10)
> +#define MPI3_EVENT_PCIE_TOPO_PI_LANES_2                 (0x20)
> +#define MPI3_EVENT_PCIE_TOPO_PI_LANES_4                 (0x30)
> +#define MPI3_EVENT_PCIE_TOPO_PI_LANES_8                 (0x40)
> +#define MPI3_EVENT_PCIE_TOPO_PI_LANES_16                (0x50)
> +#define MPI3_EVENT_PCIE_TOPO_PI_RATE_MASK               (0x0f)
> +#define MPI3_EVENT_PCIE_TOPO_PI_RATE_UNKNOWN            (0x00)
> +#define MPI3_EVENT_PCIE_TOPO_PI_RATE_DISABLED           (0x01)
> +#define MPI3_EVENT_PCIE_TOPO_PI_RATE_2_5                (0x02)
> +#define MPI3_EVENT_PCIE_TOPO_PI_RATE_5_0                (0x03)
> +#define MPI3_EVENT_PCIE_TOPO_PI_RATE_8_0                (0x04)
> +#define MPI3_EVENT_PCIE_TOPO_PI_RATE_16_0               (0x05)
> +#define MPI3_EVENT_PCIE_TOPO_PI_RATE_32_0               (0x06)
> +struct _mpi3_event_data_pcie_topology_change_list {
> +	__le16                                 enclosure_handle;
> +	__le16                                 switch_dev_handle;
> +	u8                                     num_ports;
> +	u8                                     reserved05[3];
> +	u8                                     num_entries;
> +	u8                                     start_port_num;
> +	u8                                     switch_status;
> +	u8                                     io_unit_port;
> +	__le32                                 reserved0c;
> +	struct _mpi3_event_pcie_topo_port_entry     port_entry[MPI3_EVENT_PCIE_=
TOPO_PORT_COUNT];
> +};
> +
> +#define MPI3_EVENT_PCIE_TOPO_SS_NO_PCIE_SWITCH          (0x00)
> +#define MPI3_EVENT_PCIE_TOPO_SS_NOT_RESPONDING          (0x02)
> +#define MPI3_EVENT_PCIE_TOPO_SS_RESPONDING              (0x03)
> +#define MPI3_EVENT_PCIE_TOPO_SS_DELAY_NOT_RESPONDING    (0x04)
> +struct _mpi3_event_data_sas_init_dev_status_change {
> +	u8                 reason_code;
> +	u8                 io_unit_port;
> +	__le16             dev_handle;
> +	__le32             reserved04;
> +	__le64             sas_address;
> +};
> +
> +#define MPI3_EVENT_SAS_INIT_RC_ADDED                (0x01)
> +#define MPI3_EVENT_SAS_INIT_RC_NOT_RESPONDING       (0x02)
> +struct _mpi3_event_data_sas_init_table_overflow {
> +	__le16             max_init;
> +	__le16             current_init;
> +	__le32             reserved04;
> +	__le64             sas_address;
> +};
> +
> +struct _mpi3_event_data_hard_reset_received {
> +	u8                 reserved00;
> +	u8                 io_unit_port;
> +	__le16             reserved02;
> +};
> +
> +#define MPI3_PEL_LOCALE_FLAGS_NON_BLOCKING_BOOT_EVENT   (0x0200)
> +#define MPI3_PEL_LOCALE_FLAGS_BLOCKING_BOOT_EVENT       (0x0100)
> +#define MPI3_PEL_LOCALE_FLAGS_PCIE                      (0x0080)
> +#define MPI3_PEL_LOCALE_FLAGS_CONFIGURATION             (0x0040)
> +#define MPI3_PEL_LOCALE_FLAGS_CONTROLER                 (0x0020)
> +#define MPI3_PEL_LOCALE_FLAGS_SAS                       (0x0010)
> +#define MPI3_PEL_LOCALE_FLAGS_EPACK                     (0x0008)
> +#define MPI3_PEL_LOCALE_FLAGS_ENCLOSURE                 (0x0004)
> +#define MPI3_PEL_LOCALE_FLAGS_PD                        (0x0002)
> +#define MPI3_PEL_LOCALE_FLAGS_VD                        (0x0001)
> +#define MPI3_PEL_CLASS_DEBUG                            (0x00)
> +#define MPI3_PEL_CLASS_PROGRESS                         (0x01)
> +#define MPI3_PEL_CLASS_INFORMATIONAL                    (0x02)
> +#define MPI3_PEL_CLASS_WARNING                          (0x03)
> +#define MPI3_PEL_CLASS_CRITICAL                         (0x04)
> +#define MPI3_PEL_CLASS_FATAL                            (0x05)
> +#define MPI3_PEL_CLASS_FAULT                            (0x06)
> +#define MPI3_PEL_CLEARTYPE_CLEAR                        (0x00)
> +#define MPI3_PEL_WAITTIME_INFINITE_WAIT                 (0x00)
> +#define MPI3_PEL_ACTION_GET_SEQNUM                      (0x01)
> +#define MPI3_PEL_ACTION_MARK_CLEAR                      (0x02)
> +#define MPI3_PEL_ACTION_GET_LOG                         (0x03)
> +#define MPI3_PEL_ACTION_GET_COUNT                       (0x04)
> +#define MPI3_PEL_ACTION_WAIT                            (0x05)
> +#define MPI3_PEL_ACTION_ABORT                           (0x06)
> +#define MPI3_PEL_ACTION_GET_PRINT_STRINGS               (0x07)
> +#define MPI3_PEL_ACTION_ACKNOWLEDGE                     (0x08)
> +#define MPI3_PEL_STATUS_SUCCESS                         (0x00)
> +#define MPI3_PEL_STATUS_NOT_FOUND                       (0x01)
> +#define MPI3_PEL_STATUS_ABORTED                         (0x02)
> +#define MPI3_PEL_STATUS_NOT_READY                       (0x03)
> +struct _mpi3_pel_seq {
> +	__le32                             newest;
> +	__le32                             oldest;
> +	__le32                             clear;
> +	__le32                             shutdown;
> +	__le32                             boot;
> +	__le32                             last_acknowledged;
> +};
> +
> +struct _mpi3_pel_entry {
> +	__le32                             sequence_number;
> +	__le32                             time_stamp[2];
> +	__le16                             log_code;
> +	__le16                             arg_type;
> +	__le16                             locale;
> +	u8                                 class;
> +	u8                                 reserved13;
> +	u8                                 ext_num;
> +	u8                                 num_exts;
> +	u8                                 arg_data_size;
> +	u8                                 fixed_format_size;
> +	__le32                             reserved18[2];
> +	__le32                             pel_info[24];
> +};
> +
> +struct _mpi3_pel_list {
> +	__le32                             log_count;
> +	__le32                             reserved04;
> +	struct _mpi3_pel_entry                  entry[1];
> +};
> +
> +struct _mpi3_pel_arg_map {
> +	u8                                 arg_type;
> +	u8                                 length;
> +	__le16                             start_location;
> +};
> +
> +#define MPI3_PEL_ARG_MAP_ARG_TYPE_APPEND_STRING                (0x00)
> +#define MPI3_PEL_ARG_MAP_ARG_TYPE_INTEGER                      (0x01)
> +#define MPI3_PEL_ARG_MAP_ARG_TYPE_STRING                       (0x02)
> +#define MPI3_PEL_ARG_MAP_ARG_TYPE_BIT_FIELD                    (0x03)
> +struct _mpi3_pel_print_string {
> +	__le16                             log_code;
> +	__le16                             string_length;
> +	u8                                 num_arg_map;
> +	u8                                 reserved05[3];
> +	struct _mpi3_pel_arg_map                arg_map[1];
> +};
> +
> +struct _mpi3_pel_print_string_list {
> +	__le32                             num_print_strings;
> +	__le32                             residual_bytes_remain;
> +	__le32                             reserved08[2];
> +	struct _mpi3_pel_print_string           print_string[1];
> +};
> +
> +#ifndef MPI3_PEL_ACTION_SPECIFIC_MAX
> +#define MPI3_PEL_ACTION_SPECIFIC_MAX               (1)
> +#endif
> +struct _mpi3_pel_request {
> +	__le16                             host_tag;
> +	u8                                 ioc_use_only02;
> +	u8                                 function;
> +	__le16                             ioc_use_only04;
> +	u8                                 ioc_use_only06;
> +	u8                                 msg_flags;
> +	__le16                             change_count;
> +	u8                                 action;
> +	u8                                 reserved0b;
> +	__le32                             action_specific[MPI3_PEL_ACTION_SPEC=
IFIC_MAX];
> +};
> +
> +struct _mpi3_pel_req_action_get_sequence_numbers {
> +	__le16                             host_tag;
> +	u8                                 ioc_use_only02;
> +	u8                                 function;
> +	__le16                             ioc_use_only04;
> +	u8                                 ioc_use_only06;
> +	u8                                 msg_flags;
> +	__le16                             change_count;
> +	u8                                 action;
> +	u8                                 reserved0b;
> +	__le32                             reserved0c[5];
> +	union _mpi3_sge_union                  sgl;
> +};
> +
> +struct _mpi3_pel_req_action_clear_log_marker {
> +	__le16                             host_tag;
> +	u8                                 ioc_use_only02;
> +	u8                                 function;
> +	__le16                             ioc_use_only04;
> +	u8                                 ioc_use_only06;
> +	u8                                 msg_flags;
> +	__le16                             change_count;
> +	u8                                 action;
> +	u8                                 reserved0b;
> +	u8                                 clear_type;
> +	u8                                 reserved0d[3];
> +};
> +
> +struct _mpi3_pel_req_action_get_log {
> +	__le16                             host_tag;
> +	u8                                 ioc_use_only02;
> +	u8                                 function;
> +	__le16                             ioc_use_only04;
> +	u8                                 ioc_use_only06;
> +	u8                                 msg_flags;
> +	__le16                             change_count;
> +	u8                                 action;
> +	u8                                 reserved0b;
> +	__le32                             starting_sequence_number;
> +	__le16                             locale;
> +	u8                                 class;
> +	u8                                 reserved13;
> +	__le32                             reserved14[3];
> +	union _mpi3_sge_union                  sgl;
> +};
> +
> +struct _mpi3_pel_req_action_get_count {
> +	__le16                             host_tag;
> +	u8                                 ioc_use_only02;
> +	u8                                 function;
> +	__le16                             ioc_use_only04;
> +	u8                                 ioc_use_only06;
> +	u8                                 msg_flags;
> +	__le16                             change_count;
> +	u8                                 action;
> +	u8                                 reserved0b;
> +	__le32                             starting_sequence_number;
> +	__le16                             locale;
> +	u8                                 class;
> +	u8                                 reserved13;
> +	__le32                             reserved14[3];
> +	union _mpi3_sge_union                  sgl;
> +};
> +
> +struct _mpi3_pel_req_action_wait {
> +	__le16                             host_tag;
> +	u8                                 ioc_use_only02;
> +	u8                                 function;
> +	__le16                             ioc_use_only04;
> +	u8                                 ioc_use_only06;
> +	u8                                 msg_flags;
> +	__le16                             change_count;
> +	u8                                 action;
> +	u8                                 reserved0b;
> +	__le32                             starting_sequence_number;
> +	__le16                             locale;
> +	u8                                 class;
> +	u8                                 reserved13;
> +	__le16                             wait_time;
> +	__le16                             reserved16;
> +	__le32                             reserved18[2];
> +};
> +
> +struct _mpi3_pel_req_action_abort {
> +	__le16                             host_tag;
> +	u8                                 ioc_use_only02;
> +	u8                                 function;
> +	__le16                             ioc_use_only04;
> +	u8                                 ioc_use_only06;
> +	u8                                 msg_flags;
> +	__le16                             change_count;
> +	u8                                 action;
> +	u8                                 reserved0b;
> +	__le32                             reserved0c;
> +	__le16                             abort_host_tag;
> +	__le16                             reserved12;
> +	__le32                             reserved14;
> +};
> +
> +struct _mpi3_pel_req_action_get_print_strings {
> +	__le16                             host_tag;
> +	u8                                 ioc_use_only02;
> +	u8                                 function;
> +	__le16                             ioc_use_only04;
> +	u8                                 ioc_use_only06;
> +	u8                                 msg_flags;
> +	__le16                             change_count;
> +	u8                                 action;
> +	u8                                 reserved0b;
> +	__le32                             reserved0c;
> +	__le16                             start_log_code;
> +	__le16                             reserved12;
> +	__le32                             reserved14[3];
> +	union _mpi3_sge_union                  sgl;
> +};
> +
> +struct _mpi3_pel_req_action_acknowledge {
> +	__le16                             host_tag;
> +	u8                                 ioc_use_only02;
> +	u8                                 function;
> +	__le16                             ioc_use_only04;
> +	u8                                 ioc_use_only06;
> +	u8                                 msg_flags;
> +	__le16                             change_count;
> +	u8                                 action;
> +	u8                                 reserved0b;
> +	__le32                             sequence_number;
> +	__le32                             reserved10;
> +};
> +
> +#define MPI3_PELACKNOWLEDGE_MSGFLAGS_SAFE_MODE_EXIT            (0x01)
> +struct _mpi3_pel_reply {
> +	__le16                             host_tag;
> +	u8                                 ioc_use_only02;
> +	u8                                 function;
> +	__le16                             ioc_use_only04;
> +	u8                                 ioc_use_only06;
> +	u8                                 msg_flags;
> +	__le16                             ioc_use_only08;
> +	__le16                             ioc_status;
> +	__le32                             ioc_log_info;
> +	u8                                 action;
> +	u8                                 reserved11;
> +	__le16                             reserved12;
> +	__le16                             pe_log_status;
> +	__le16                             reserved16;
> +	__le32                             transfer_length;
> +};
> +
> +struct _mpi3_ci_download_request {
> +	__le16                             host_tag;
> +	u8                                 ioc_use_only02;
> +	u8                                 function;
> +	__le16                             ioc_use_only04;
> +	u8                                 ioc_use_only06;
> +	u8                                 msg_flags;
> +	__le16                             change_count;
> +	u8                                 action;
> +	u8                                 reserved0b;
> +	__le32                             signature1;
> +	__le32                             total_image_size;
> +	__le32                             image_offset;
> +	__le32                             segment_size;
> +	__le32                             reserved1c;
> +	union _mpi3_sge_union                  sgl;
> +};
> +
> +#define MPI3_CI_DOWNLOAD_MSGFLAGS_LAST_SEGMENT                 (0x80)
> +#define MPI3_CI_DOWNLOAD_MSGFLAGS_FORCE_FMC_ENABLE             (0x40)
> +#define MPI3_CI_DOWNLOAD_MSGFLAGS_SIGNED_NVDATA                (0x20)
> +#define MPI3_CI_DOWNLOAD_MSGFLAGS_WRITE_CACHE_FLUSH_MASK       (0x03)
> +#define MPI3_CI_DOWNLOAD_MSGFLAGS_WRITE_CACHE_FLUSH_FAST       (0x00)
> +#define MPI3_CI_DOWNLOAD_MSGFLAGS_WRITE_CACHE_FLUSH_MEDIUM     (0x01)
> +#define MPI3_CI_DOWNLOAD_MSGFLAGS_WRITE_CACHE_FLUSH_SLOW       (0x02)
> +#define MPI3_CI_DOWNLOAD_ACTION_DOWNLOAD                       (0x01)
> +#define MPI3_CI_DOWNLOAD_ACTION_ONLINE_ACTIVATION              (0x02)
> +#define MPI3_CI_DOWNLOAD_ACTION_OFFLINE_ACTIVATION             (0x03)
> +#define MPI3_CI_DOWNLOAD_ACTION_GET_STATUS                     (0x04)
> +struct _mpi3_ci_download_reply {
> +	__le16                             host_tag;
> +	u8                                 ioc_use_only02;
> +	u8                                 function;
> +	__le16                             ioc_use_only04;
> +	u8                                 ioc_use_only06;
> +	u8                                 msg_flags;
> +	__le16                             ioc_use_only08;
> +	__le16                             ioc_status;
> +	__le32                             ioc_log_info;
> +	u8                                 flags;
> +	u8                                 cache_dirty;
> +	u8                                 pending_count;
> +	u8                                 reserved13;
> +};
> +
> +#define MPI3_CI_DOWNLOAD_FLAGS_DOWNLOAD_IN_PROGRESS                  (0x=
80)
> +#define MPI3_CI_DOWNLOAD_FLAGS_KEY_UPDATE_PENDING                    (0x=
10)
> +#define MPI3_CI_DOWNLOAD_FLAGS_ACTIVATION_STATUS_MASK                (0x=
0e)
> +#define MPI3_CI_DOWNLOAD_FLAGS_ACTIVATION_STATUS_NOT_NEEDED          (0x=
00)
> +#define MPI3_CI_DOWNLOAD_FLAGS_ACTIVATION_STATUS_AWAITING            (0x=
02)
> +#define MPI3_CI_DOWNLOAD_FLAGS_ACTIVATION_STATUS_ONLINE_PENDING      (0x=
04)
> +#define MPI3_CI_DOWNLOAD_FLAGS_ACTIVATION_STATUS_OFFLINE_PENDING     (0x=
06)
> +#define MPI3_CI_DOWNLOAD_FLAGS_COMPATIBLE                            (0x=
01)
> +struct _mpi3_ci_upload_request {
> +	__le16                             host_tag;
> +	u8                                 ioc_use_only02;
> +	u8                                 function;
> +	__le16                             ioc_use_only04;
> +	u8                                 ioc_use_only06;
> +	u8                                 msg_flags;
> +	__le16                             change_count;
> +	__le16                             reserved0a;
> +	__le32                             signature1;
> +	__le32                             reserved10;
> +	__le32                             image_offset;
> +	__le32                             segment_size;
> +	__le32                             reserved1c;
> +	union _mpi3_sge_union                  sgl;
> +};
> +
> +#define MPI3_CI_UPLOAD_MSGFLAGS_LOCATION_MASK                        (0x=
01)
> +#define MPI3_CI_UPLOAD_MSGFLAGS_LOCATION_PRIMARY                     (0x=
00)
> +#define MPI3_CI_UPLOAD_MSGFLAGS_LOCATION_SECONDARY                   (0x=
01)
> +#define MPI3_CI_UPLOAD_MSGFLAGS_FORMAT_MASK                          (0x=
02)
> +#define MPI3_CI_UPLOAD_MSGFLAGS_FORMAT_FLASH                         (0x=
00)
> +#define MPI3_CI_UPLOAD_MSGFLAGS_FORMAT_EXECUTABLE                    (0x=
02)
> +#define MPI3_CTRL_OP_FORCE_FULL_DISCOVERY                            (0x=
01)
> +#define MPI3_CTRL_OP_LOOKUP_MAPPING                                  (0x=
02)
> +#define MPI3_CTRL_OP_UPDATE_TIMESTAMP                                (0x=
04)
> +#define MPI3_CTRL_OP_GET_TIMESTAMP                                   (0x=
05)
> +#define MPI3_CTRL_OP_REMOVE_DEVICE                                   (0x=
10)
> +#define MPI3_CTRL_OP_CLOSE_PERSISTENT_CONNECTION                     (0x=
11)
> +#define MPI3_CTRL_OP_HIDDEN_ACK                                      (0x=
12)
> +#define MPI3_CTRL_OP_SAS_SEND_PRIMITIVE                              (0x=
20)
> +#define MPI3_CTRL_OP_SAS_CLEAR_ERROR_LOG                             (0x=
21)
> +#define MPI3_CTRL_OP_PCIE_CLEAR_ERROR_LOG                            (0x=
22)
> +#define MPI3_CTRL_OP_LOOKUP_MAPPING_PARAM8_LOOKUP_METHOD_INDEX       (0x=
00)
> +#define MPI3_CTRL_OP_UPDATE_TIMESTAMP_PARAM64_TIMESTAMP_INDEX        (0x=
00)
> +#define MPI3_CTRL_OP_REMOVE_DEVICE_PARAM16_DEVHANDLE_INDEX           (0x=
00)
> +#define MPI3_CTRL_OP_CLOSE_PERSIST_CONN_PARAM16_DEVHANDLE_INDEX      (0x=
00)
> +#define MPI3_CTRL_OP_HIDDEN_ACK_PARAM16_DEVHANDLE_INDEX              (0x=
00)
> +#define MPI3_CTRL_OP_SAS_SEND_PRIM_PARAM8_PHY_INDEX                  (0x=
00)
> +#define MPI3_CTRL_OP_SAS_SEND_PRIM_PARAM8_PRIMSEQ_INDEX              (0x=
01)
> +#define MPI3_CTRL_OP_SAS_SEND_PRIM_PARAM32_PRIMITIVE_INDEX           (0x=
00)
> +#define MPI3_CTRL_OP_SAS_CLEAR_ERR_LOG_PARAM8_PHY_INDEX              (0x=
00)
> +#define MPI3_CTRL_OP_PCIE_CLEAR_ERR_LOG_PARAM8_PHY_INDEX             (0x=
00)
> +#define MPI3_CTRL_LOOKUP_METHOD_WWID_ADDRESS                         (0x=
01)
> +#define MPI3_CTRL_LOOKUP_METHOD_ENCLOSURE_SLOT                       (0x=
02)
> +#define MPI3_CTRL_LOOKUP_METHOD_SAS_DEVICE_NAME                      (0x=
03)
> +#define MPI3_CTRL_LOOKUP_METHOD_PERSISTENT_ID                        (0x=
04)
> +#define MPI3_CTRL_LOOKUP_METHOD_WWIDADDR_PARAM16_DEVH_INDEX             =
(0)
> +#define MPI3_CTRL_LOOKUP_METHOD_WWIDADDR_PARAM64_WWID_INDEX             =
(0)
> +#define MPI3_CTRL_LOOKUP_METHOD_ENCLSLOT_PARAM16_SLOTNUM_INDEX          =
(0)
> +#define MPI3_CTRL_LOOKUP_METHOD_ENCLSLOT_PARAM64_ENCLOSURELID_INDEX     =
(0)
> +#define MPI3_CTRL_LOOKUP_METHOD_SASDEVNAME_PARAM16_DEVH_INDEX           =
(0)
> +#define MPI3_CTRL_LOOKUP_METHOD_SASDEVNAME_PARAM64_DEVNAME_INDEX        =
(0)
> +#define MPI3_CTRL_LOOKUP_METHOD_PERSISTID_PARAM16_DEVH_INDEX            =
(0)
> +#define MPI3_CTRL_LOOKUP_METHOD_PERSISTID_PARAM16_PERSISTENT_ID_INDEX   =
(1)
> +#define MPI3_CTRL_LOOKUP_METHOD_VALUE16_DEVH_INDEX                      =
(0)
> +#define MPI3_CTRL_GET_TIMESTAMP_VALUE64_TIMESTAMP_INDEX                 =
(0)
> +#define MPI3_CTRL_PRIMFLAGS_SINGLE                                   (0x=
01)
> +#define MPI3_CTRL_PRIMFLAGS_TRIPLE                                   (0x=
03)
> +#define MPI3_CTRL_PRIMFLAGS_REDUNDANT                                (0x=
06)
> +struct _mpi3_iounit_control_request {
> +	__le16                             host_tag;
> +	u8                                 ioc_use_only02;
> +	u8                                 function;
> +	__le16                             ioc_use_only04;
> +	u8                                 ioc_use_only06;
> +	u8                                 msg_flags;
> +	__le16                             change_count;
> +	u8                                 reserved0a;
> +	u8                                 operation;
> +	__le32                             reserved0c;
> +	__le64                             param64[2];
> +	__le32                             param32[4];
> +	__le16                             param16[4];
> +	u8                                 param8[8];
> +};
> +
> +struct _mpi3_iounit_control_reply {
> +	__le16                             host_tag;
> +	u8                                 ioc_use_only02;
> +	u8                                 function;
> +	__le16                             ioc_use_only04;
> +	u8                                 ioc_use_only06;
> +	u8                                 msg_flags;
> +	__le16                             ioc_use_only08;
> +	__le16                             ioc_status;
> +	__le32                             ioc_log_info;
> +	__le64                             value64[2];
> +	__le32                             value32[4];
> +	__le16                             value16[4];
> +	u8                                 value8[8];
> +};
> +#endif
> diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_transport.h b/drivers/scsi/mpi=
3mr/mpi/mpi30_transport.h
> new file mode 100644
> index 000000000000..d2a5e7e84b16
> --- /dev/null
> +++ b/drivers/scsi/mpi3mr/mpi/mpi30_transport.h
> @@ -0,0 +1,486 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + *  Copyright 2016-2021 Broadcom Inc. All rights reserved.
> + *
> + *           Name: mpi30_transport.h
> + *    Description: Contains definitions for System Interface Register Se=
t, Scatter Gather Lists etc
> + *  Creation Date: 08/31/2016
> + *        Version: 03.00.00
> + *
> + *  mpi3.h Version:  03.00.00.18
> + *
> + *
> + *  Version History
> + *  ---------------
> + *
> + *  Date      Version       Description
> + *  --------  -----------  ---------------------------------------------=
---------
> + *  11-30-18  03.00.00.08  Corresponds to Fusion-MPT MPI 3.0 Specificati=
on Rev H.
> + *  02-08-19  03.00.00.09  Corresponds to Fusion-MPT MPI 3.0 Specificati=
on Rev I.
> + *  05-03-19  03.00.00.10  Corresponds to Fusion-MPT MPI 3.0 Specificati=
on Rev J.
> + *  08-30-19  03.00.00.12  Corresponds to Fusion-MPT MPI 3.0 Specificati=
on Rev L.
> + *  11-01-19  03.00.00.13  Corresponds to Fusion-MPT MPI 3.0 Specificati=
on Rev M.
> + *  12-16-19  03.00.00.14  Corresponds to Fusion-MPT MPI 3.0 Specificati=
on Rev N.
> + *  02-28-20  03.00.00.15  Corresponds to Fusion-MPT MPI 3.0 Specificati=
on Rev O.
> + *  05-01-20  03.00.00.16  Corresponds to Fusion-MPT MPI 3.0 Specificati=
on Rev P.
> + *  06-26-20  03.00.00.17  Corresponds to Fusion-MPT MPI 3.0 Specificati=
on Rev Q.
> + *  08-28-20  03.00.00.18  Corresponds to Fusion-MPT MPI 3.0 Specificati=
on Rev R.
> + */
> +#ifndef MPI30_TRANSPORT_H
> +#define MPI30_TRANSPORT_H     1
> +struct _mpi3_version_struct {
> +	u8         dev;
> +	u8         unit;
> +	u8         minor;
> +	u8         major;
> +};
> +
> +union _mpi3_version_union {
> +	struct _mpi3_version_struct     mpi3_version;
> +	__le32                     word;
> +};
> +
> +#define MPI3_VERSION_MAJOR                                              =
(3)
> +#define MPI3_VERSION_MINOR                                              =
(0)
> +#define MPI3_VERSION_UNIT                                               =
(0)
> +#define MPI3_VERSION_DEV                                                =
(18)
> +struct _mpi3_sysif_oper_queue_indexes {
> +	__le16         producer_index;
> +	__le16         reserved02;
> +	__le16         consumer_index;
> +	__le16         reserved06;
> +};
> +
> +struct _mpi3_sysif_registers {
> +	__le64                             ioc_information;
> +	union _mpi3_version_union              version;
> +	__le32                             reserved0c[2];
> +	__le32                             ioc_configuration;
> +	__le32                             reserved18;
> +	__le32                             ioc_status;
> +	__le32                             reserved20;
> +	__le32                             admin_queue_num_entries;
> +	__le64                             admin_request_queue_address;
> +	__le64                             admin_reply_queue_address;
> +	__le32                             reserved38[2];
> +	__le32                             coalesce_control;
> +	__le32                             reserved44[1007];
> +	__le16                             admin_request_queue_pi;
> +	__le16                             reserved1002;
> +	__le16                             admin_reply_queue_ci;
> +	__le16                             reserved1006;
> +	struct _mpi3_sysif_oper_queue_indexes   oper_queue_indexes[383];
> +	__le32                             reserved1c00;
> +	__le32                             write_sequence;
> +	__le32                             host_diagnostic;
> +	__le32                             reserved1c0c;
> +	__le32                             fault;
> +	__le32                             fault_info[3];
> +	__le32                             reserved1c20[4];
> +	__le64                             hcb_address;
> +	__le32                             hcb_size;
> +	__le32                             reserved1c3c;
> +	__le32                             reply_free_host_index;
> +	__le32                             sense_buffer_free_host_index;
> +	__le32                             reserved1c48[2];
> +	__le64                             diag_rw_data;
> +	__le64                             diag_rw_address;
> +	__le16                             diag_rw_control;
> +	__le16                             diag_rw_status;
> +	__le32                             reserved1c64[35];
> +	__le32                             scratchpad[4];
> +	__le32                             reserved1d00[192];
> +	__le32                             device_assigned_registers[2048];
> +};
> +
> +#define MPI3_SYSIF_IOC_INFO_LOW_OFFSET                                  =
(0x00000000)
> +#define MPI3_SYSIF_IOC_INFO_HIGH_OFFSET                                 =
(0x00000004)
> +#define MPI3_SYSIF_IOC_INFO_LOW_TIMEOUT_MASK                            =
(0xff000000)
> +#define MPI3_SYSIF_IOC_INFO_LOW_TIMEOUT_SHIFT                           =
(24)
> +#define MPI3_SYSIF_IOC_CONFIG_OFFSET                                    =
(0x00000014)
> +#define MPI3_SYSIF_IOC_CONFIG_OPER_RPY_ENT_SZ                           =
(0x00f00000)
> +#define MPI3_SYSIF_IOC_CONFIG_OPER_RPY_ENT_SZ_SHIFT                     =
(20)
> +#define MPI3_SYSIF_IOC_CONFIG_OPER_REQ_ENT_SZ                           =
(0x000f0000)
> +#define MPI3_SYSIF_IOC_CONFIG_OPER_REQ_ENT_SZ_SHIFT                     =
(16)
> +#define MPI3_SYSIF_IOC_CONFIG_SHUTDOWN_MASK                             =
(0x0000c000)
> +#define MPI3_SYSIF_IOC_CONFIG_SHUTDOWN_NO                               =
(0x00000000)
> +#define MPI3_SYSIF_IOC_CONFIG_SHUTDOWN_NORMAL                           =
(0x00004000)
> +#define MPI3_SYSIF_IOC_CONFIG_DEVICE_SHUTDOWN                           =
(0x00002000)
> +#define MPI3_SYSIF_IOC_CONFIG_DIAG_SAVE                                 =
(0x00000010)
> +#define MPI3_SYSIF_IOC_CONFIG_ENABLE_IOC                                =
(0x00000001)
> +#define MPI3_SYSIF_IOC_STATUS_OFFSET                                    =
(0x0000001c)
> +#define MPI3_SYSIF_IOC_STATUS_RESET_HISTORY                             =
(0x00000010)
> +#define MPI3_SYSIF_IOC_STATUS_SHUTDOWN_MASK                             =
(0x0000000c)
> +#define MPI3_SYSIF_IOC_STATUS_SHUTDOWN_NONE                             =
(0x00000000)
> +#define MPI3_SYSIF_IOC_STATUS_SHUTDOWN_IN_PROGRESS                      =
(0x00000004)
> +#define MPI3_SYSIF_IOC_STATUS_SHUTDOWN_COMPLETE                         =
(0x00000008)
> +#define MPI3_SYSIF_IOC_STATUS_FAULT                                     =
(0x00000002)
> +#define MPI3_SYSIF_IOC_STATUS_READY                                     =
(0x00000001)
> +#define MPI3_SYSIF_ADMIN_Q_NUM_ENTRIES_OFFSET                           =
(0x00000024)
> +#define MPI3_SYSIF_ADMIN_Q_NUM_ENTRIES_REQ_MASK                         =
(0x0fff)
> +#define MPI3_SYSIF_ADMIN_Q_NUM_ENTRIES_REPLY_OFFSET                     =
(0x00000026)
> +#define MPI3_SYSIF_ADMIN_Q_NUM_ENTRIES_REPLY_MASK                       =
(0x0fff0000)
> +#define MPI3_SYSIF_ADMIN_Q_NUM_ENTRIES_REPLY_SHIFT                      =
(16)
> +#define MPI3_SYSIF_ADMIN_REQ_Q_ADDR_LOW_OFFSET                          =
(0x00000028)
> +#define MPI3_SYSIF_ADMIN_REQ_Q_ADDR_HIGH_OFFSET                         =
(0x0000002c)
> +#define MPI3_SYSIF_ADMIN_REPLY_Q_ADDR_LOW_OFFSET                        =
(0x00000030)
> +#define MPI3_SYSIF_ADMIN_REPLY_Q_ADDR_HIGH_OFFSET                       =
(0x00000034)
> +#define MPI3_SYSIF_COALESCE_CONTROL_OFFSET                              =
(0x00000040)
> +#define MPI3_SYSIF_COALESCE_CONTROL_ENABLE_MASK                         =
(0xc0000000)
> +#define MPI3_SYSIF_COALESCE_CONTROL_ENABLE_NO_CHANGE                    =
(0x00000000)
> +#define MPI3_SYSIF_COALESCE_CONTROL_ENABLE_DISABLE                      =
(0x40000000)
> +#define MPI3_SYSIF_COALESCE_CONTROL_ENABLE_ENABLE                       =
(0xc0000000)
> +#define MPI3_SYSIF_COALESCE_CONTROL_VALID                               =
(0x30000000)
> +#define MPI3_SYSIF_COALESCE_CONTROL_QUEUE_ID_MASK                       =
(0x00ff0000)
> +#define MPI3_SYSIF_COALESCE_CONTROL_QUEUE_ID_SHIFT                      =
(16)
> +#define MPI3_SYSIF_COALESCE_CONTROL_TIMEOUT_MASK                        =
(0x0000ff00)
> +#define MPI3_SYSIF_COALESCE_CONTROL_TIMEOUT_SHIFT                       =
(8)
> +#define MPI3_SYSIF_COALESCE_CONTROL_DEPTH_MASK                          =
(0x000000ff)
> +#define MPI3_SYSIF_COALESCE_CONTROL_DEPTH_SHIFT                         =
(0)
> +#define MPI3_SYSIF_ADMIN_REQ_Q_PI_OFFSET                                =
(0x00001000)
> +#define MPI3_SYSIF_ADMIN_REPLY_Q_CI_OFFSET                              =
(0x00001004)
> +#define MPI3_SYSIF_OPER_REQ_Q_PI_OFFSET                                 =
(0x00001008)
> +#define MPI3_SYSIF_OPER_REQ_Q_N_PI_OFFSET(n)                            =
(MPI3_SYSIF_OPER_REQ_Q_PI_OFFSET + (((n) - 1) * 8))
> +#define MPI3_SYSIF_OPER_REPLY_Q_CI_OFFSET                               =
(0x0000100c)
> +#define MPI3_SYSIF_OPER_REPLY_Q_N_CI_OFFSET(n)                          =
(MPI3_SYSIF_OPER_REPLY_Q_CI_OFFSET + (((n) - 1) * 8))
> +#define MPI3_SYSIF_WRITE_SEQUENCE_OFFSET                                =
(0x00001c04)
> +#define MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_MASK                        =
(0x0000000f)
> +#define MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_FLUSH                       =
(0x0)
> +#define MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_1ST                         =
(0xf)
> +#define MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_2ND                         =
(0x4)
> +#define MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_3RD                         =
(0xb)
> +#define MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_4TH                         =
(0x2)
> +#define MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_5TH                         =
(0x7)
> +#define MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_6TH                         =
(0xd)
> +#define MPI3_SYSIF_HOST_DIAG_OFFSET                                     =
(0x00001c08)
> +#define MPI3_SYSIF_HOST_DIAG_RESET_ACTION_MASK                          =
(0x00000700)
> +#define MPI3_SYSIF_HOST_DIAG_RESET_ACTION_NO_RESET                      =
(0x00000000)
> +#define MPI3_SYSIF_HOST_DIAG_RESET_ACTION_SOFT_RESET                    =
(0x00000100)
> +#define MPI3_SYSIF_HOST_DIAG_RESET_ACTION_FLASH_RCVRY_RESET             =
(0x00000200)
> +#define MPI3_SYSIF_HOST_DIAG_RESET_ACTION_COMPLETE_RESET                =
(0x00000300)
> +#define MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT                    =
(0x00000700)
> +#define MPI3_SYSIF_HOST_DIAG_SAVE_IN_PROGRESS                           =
(0x00000080)
> +#define MPI3_SYSIF_HOST_DIAG_SECURE_BOOT                                =
(0x00000040)
> +#define MPI3_SYSIF_HOST_DIAG_CLEAR_INVALID_FW_IMAGE                     =
(0x00000020)
> +#define MPI3_SYSIF_HOST_DIAG_INVALID_FW_IMAGE                           =
(0x00000010)
> +#define MPI3_SYSIF_HOST_DIAG_HCBENABLE                                  =
(0x00000008)
> +#define MPI3_SYSIF_HOST_DIAG_HCBMODE                                    =
(0x00000004)
> +#define MPI3_SYSIF_HOST_DIAG_DIAG_RW_ENABLE                             =
(0x00000002)
> +#define MPI3_SYSIF_HOST_DIAG_DIAG_WRITE_ENABLE                          =
(0x00000001)
> +#define MPI3_SYSIF_FAULT_OFFSET                                         =
(0x00001c10)
> +#define MPI3_SYSIF_FAULT_FUNC_AREA_MASK                                 =
(0xff000000)
> +#define MPI3_SYSIF_FAULT_FUNC_AREA_SHIFT                                =
(24)
> +#define MPI3_SYSIF_FAULT_FUNC_AREA_MPI_DEFINED                          =
(0x00000000)
> +#define MPI3_SYSIF_FAULT_CODE_MASK                                      =
(0x0000ffff)
> +#define MPI3_SYSIF_FAULT_CODE_DIAG_FAULT_RESET                          =
(0x0000f000)
> +#define MPI3_SYSIF_FAULT_CODE_CI_ACTIVATION_RESET                       =
(0x0000f001)
> +#define MPI3_SYSIF_FAULT_CODE_SOFT_RESET_IN_PROGRESS                    =
(0x0000f002)
> +#define MPI3_SYSIF_FAULT_CODE_COMPLETE_RESET_NEEDED                     =
(0x0000f003)
> +#define MPI3_SYSIF_FAULT_CODE_SAFE_MODE_EXIT                            =
(0x0000f004)
> +#define MPI3_SYSIF_FAULT_CODE_FACTORY_RESET                             =
(0x0000f005)
> +#define MPI3_SYSIF_FAULT_INFO0_OFFSET                                   =
(0x00001c14)
> +#define MPI3_SYSIF_FAULT_INFO1_OFFSET                                   =
(0x00001c18)
> +#define MPI3_SYSIF_FAULT_INFO2_OFFSET                                   =
(0x00001c1c)
> +#define MPI3_SYSIF_HCB_ADDRESS_LOW_OFFSET                               =
(0x00001c30)
> +#define MPI3_SYSIF_HCB_ADDRESS_HIGH_OFFSET                              =
(0x00001c34)
> +#define MPI3_SYSIF_HCB_SIZE_OFFSET                                      =
(0x00001c38)
> +#define MPI3_SYSIF_HCB_SIZE_SIZE_MASK                                   =
(0xfffff000)
> +#define MPI3_SYSIF_HCB_SIZE_SIZE_SHIFT                                  =
(12)
> +#define MPI3_SYSIF_HCB_SIZE_HCDW_ENABLE                                 =
(0x00000001)
> +#define MPI3_SYSIF_REPLY_FREE_HOST_INDEX_OFFSET                         =
(0x00001c40)
> +#define MPI3_SYSIF_SENSE_BUF_FREE_HOST_INDEX_OFFSET                     =
(0x00001c44)
> +#define MPI3_SYSIF_DIAG_RW_DATA_LOW_OFFSET                              =
(0x00001c50)
> +#define MPI3_SYSIF_DIAG_RW_DATA_HIGH_OFFSET                             =
(0x00001c54)
> +#define MPI3_SYSIF_DIAG_RW_ADDRESS_LOW_OFFSET                           =
(0x00001c58)
> +#define MPI3_SYSIF_DIAG_RW_ADDRESS_HIGH_OFFSET                          =
(0x00001c5c)
> +#define MPI3_SYSIF_DIAG_RW_CONTROL_OFFSET                               =
(0x00001c60)
> +#define MPI3_SYSIF_DIAG_RW_CONTROL_LEN_MASK                             =
(0x00000030)
> +#define MPI3_SYSIF_DIAG_RW_CONTROL_LEN_1BYTE                            =
(0x00000000)
> +#define MPI3_SYSIF_DIAG_RW_CONTROL_LEN_2BYTES                           =
(0x00000010)
> +#define MPI3_SYSIF_DIAG_RW_CONTROL_LEN_4BYTES                           =
(0x00000020)
> +#define MPI3_SYSIF_DIAG_RW_CONTROL_LEN_8BYTES                           =
(0x00000030)
> +#define MPI3_SYSIF_DIAG_RW_CONTROL_RESET                                =
(0x00000004)
> +#define MPI3_SYSIF_DIAG_RW_CONTROL_DIR_MASK                             =
(0x00000002)
> +#define MPI3_SYSIF_DIAG_RW_CONTROL_DIR_READ                             =
(0x00000000)
> +#define MPI3_SYSIF_DIAG_RW_CONTROL_DIR_WRITE                            =
(0x00000002)
> +#define MPI3_SYSIF_DIAG_RW_CONTROL_START                                =
(0x00000001)
> +#define MPI3_SYSIF_DIAG_RW_STATUS_OFFSET                                =
(0x00001c62)
> +#define MPI3_SYSIF_DIAG_RW_STATUS_STATUS_MASK                           =
(0x0000000e)
> +#define MPI3_SYSIF_DIAG_RW_STATUS_STATUS_SUCCESS                        =
(0x00000000)
> +#define MPI3_SYSIF_DIAG_RW_STATUS_STATUS_INV_ADDR                       =
(0x00000002)
> +#define MPI3_SYSIF_DIAG_RW_STATUS_STATUS_ACC_ERR                        =
(0x00000004)
> +#define MPI3_SYSIF_DIAG_RW_STATUS_STATUS_PAR_ERR                        =
(0x00000006)
> +#define MPI3_SYSIF_DIAG_RW_STATUS_BUSY                                  =
(0x00000001)
> +#define MPI3_SYSIF_SCRATCHPAD0_OFFSET                                   =
(0x00001cf0)
> +#define MPI3_SYSIF_SCRATCHPAD1_OFFSET                                   =
(0x00001cf4)
> +#define MPI3_SYSIF_SCRATCHPAD2_OFFSET                                   =
(0x00001cf8)
> +#define MPI3_SYSIF_SCRATCHPAD3_OFFSET                                   =
(0x00001cfc)
> +#define MPI3_SYSIF_DEVICE_ASSIGNED_REGS_OFFSET                          =
(0x00002000)
> +#define MPI3_SYSIF_DIAG_SAVE_TIMEOUT                                    =
(60)
> +struct _mpi3_default_reply_descriptor {
> +	__le32             descriptor_type_dependent1[2];
> +	__le16             request_queue_ci;
> +	__le16             request_queue_id;
> +	__le16             descriptor_type_dependent2;
> +	__le16             reply_flags;
> +};
> +
> +#define MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK                       (0x00=
01)
> +#define MPI3_REPLY_DESCRIPT_FLAGS_TYPE_MASK                        (0xf0=
00)
> +#define MPI3_REPLY_DESCRIPT_FLAGS_TYPE_ADDRESS_REPLY               (0x00=
00)
> +#define MPI3_REPLY_DESCRIPT_FLAGS_TYPE_SUCCESS                     (0x10=
00)
> +#define MPI3_REPLY_DESCRIPT_FLAGS_TYPE_TARGET_COMMAND_BUFFER       (0x20=
00)
> +#define MPI3_REPLY_DESCRIPT_FLAGS_TYPE_STATUS                      (0x30=
00)
> +struct _mpi3_address_reply_descriptor {
> +	__le64             reply_frame_address;
> +	__le16             request_queue_ci;
> +	__le16             request_queue_id;
> +	__le16             reserved0c;
> +	__le16             reply_flags;
> +};
> +
> +struct _mpi3_success_reply_descriptor {
> +	__le32             reserved00[2];
> +	__le16             request_queue_ci;
> +	__le16             request_queue_id;
> +	__le16             host_tag;
> +	__le16             reply_flags;
> +};
> +
> +struct _mpi3_target_command_buffer_reply_descriptor {
> +	__le32             reserved00;
> +	__le16             initiator_dev_handle;
> +	u8                 phy_num;
> +	u8                 reserved07;
> +	__le16             request_queue_ci;
> +	__le16             request_queue_id;
> +	__le16             io_index;
> +	__le16             reply_flags;
> +};
> +
> +struct _mpi3_status_reply_descriptor {
> +	__le16             ioc_status;
> +	__le16             reserved02;
> +	__le32             ioc_log_info;
> +	__le16             request_queue_ci;
> +	__le16             request_queue_id;
> +	__le16             host_tag;
> +	__le16             reply_flags;
> +};
> +
> +#define MPI3_REPLY_DESCRIPT_STATUS_IOCSTATUS_LOGINFOAVAIL               =
(0x8000)
> +#define MPI3_REPLY_DESCRIPT_STATUS_IOCSTATUS_STATUS_MASK                =
(0x7fff)
> +#define MPI3_REPLY_DESCRIPT_STATUS_IOCLOGINFO_TYPE_MASK                 =
(0xf0000000)
> +#define MPI3_REPLY_DESCRIPT_STATUS_IOCLOGINFO_TYPE_NO_INFO              =
(0x00000000)
> +#define MPI3_REPLY_DESCRIPT_STATUS_IOCLOGINFO_TYPE_SAS                  =
(0x30000000)
> +#define MPI3_REPLY_DESCRIPT_STATUS_IOCLOGINFO_DATA_MASK                 =
(0x0fffffff)
> +union _mpi3_reply_descriptors_union {
> +	struct _mpi3_default_reply_descriptor               default_reply;
> +	struct _mpi3_address_reply_descriptor               address_reply;
> +	struct _mpi3_success_reply_descriptor               success;
> +	struct _mpi3_target_command_buffer_reply_descriptor target_command_buff=
er;
> +	struct _mpi3_status_reply_descriptor                status;
> +	__le32                                         words[4];
> +};
> +
> +struct _mpi3_sge_common {
> +	__le64             address;
> +	__le32             length;
> +	u8                 reserved0c[3];
> +	u8                 flags;
> +};
> +
> +struct _mpi3_sge_bit_bucket {
> +	__le64             reserved00;
> +	__le32             length;
> +	u8                 reserved0c[3];
> +	u8                 flags;
> +};
> +
> +struct _mpi3_sge_extended_eedp {
> +	u8                 user_data_size;
> +	u8                 reserved01;
> +	__le16             eedp_flags;
> +	__le32             secondary_reference_tag;
> +	__le16             secondary_application_tag;
> +	__le16             application_tag_translation_mask;
> +	__le16             reserved0c;
> +	u8                 extended_operation;
> +	u8                 flags;
> +};
> +
> +union _mpi3_sge_union {
> +	struct _mpi3_sge_common                 simple;
> +	struct _mpi3_sge_common                  chain;
> +	struct _mpi3_sge_common             last_chain;
> +	struct _mpi3_sge_bit_bucket             bit_bucket;
> +	struct _mpi3_sge_extended_eedp          eedp;
> +	__le32                             words[4];
> +};
> +
> +#define MPI3_SGE_FLAGS_ELEMENT_TYPE_MASK        (0xf0)
> +#define MPI3_SGE_FLAGS_ELEMENT_TYPE_SIMPLE      (0x00)
> +#define MPI3_SGE_FLAGS_ELEMENT_TYPE_BIT_BUCKET  (0x10)
> +#define MPI3_SGE_FLAGS_ELEMENT_TYPE_CHAIN       (0x20)
> +#define MPI3_SGE_FLAGS_ELEMENT_TYPE_LAST_CHAIN  (0x30)
> +#define MPI3_SGE_FLAGS_ELEMENT_TYPE_EXTENDED    (0xf0)
> +#define MPI3_SGE_FLAGS_END_OF_LIST              (0x08)
> +#define MPI3_SGE_FLAGS_END_OF_BUFFER            (0x04)
> +#define MPI3_SGE_FLAGS_DLAS_MASK                (0x03)
> +#define MPI3_SGE_FLAGS_DLAS_SYSTEM              (0x00)
> +#define MPI3_SGE_FLAGS_DLAS_IOC_DDR             (0x01)
> +#define MPI3_SGE_FLAGS_DLAS_IOC_CTL             (0x02)
> +#define MPI3_SGE_EXT_OPER_EEDP                  (0x00)
> +#define MPI3_EEDPFLAGS_INCR_PRI_REF_TAG             (0x8000)
> +#define MPI3_EEDPFLAGS_INCR_SEC_REF_TAG             (0x4000)
> +#define MPI3_EEDPFLAGS_INCR_PRI_APP_TAG             (0x2000)
> +#define MPI3_EEDPFLAGS_INCR_SEC_APP_TAG             (0x1000)
> +#define MPI3_EEDPFLAGS_ESC_PASSTHROUGH              (0x0800)
> +#define MPI3_EEDPFLAGS_CHK_REF_TAG                  (0x0400)
> +#define MPI3_EEDPFLAGS_CHK_APP_TAG                  (0x0200)
> +#define MPI3_EEDPFLAGS_CHK_GUARD                    (0x0100)
> +#define MPI3_EEDPFLAGS_ESC_MODE_MASK                (0x00c0)
> +#define MPI3_EEDPFLAGS_ESC_MODE_DO_NOT_DISABLE      (0x0040)
> +#define MPI3_EEDPFLAGS_ESC_MODE_APPTAG_DISABLE      (0x0080)
> +#define MPI3_EEDPFLAGS_ESC_MODE_APPTAG_REFTAG_DISABLE   (0x00c0)
> +#define MPI3_EEDPFLAGS_HOST_GUARD_MASK              (0x0030)
> +#define MPI3_EEDPFLAGS_HOST_GUARD_T10_CRC           (0x0000)
> +#define MPI3_EEDPFLAGS_HOST_GUARD_IP_CHKSUM         (0x0010)
> +#define MPI3_EEDPFLAGS_HOST_GUARD_OEM_SPECIFIC      (0x0020)
> +#define MPI3_EEDPFLAGS_PT_REF_TAG                   (0x0008)
> +#define MPI3_EEDPFLAGS_EEDP_OP_MASK                 (0x0007)
> +#define MPI3_EEDPFLAGS_EEDP_OP_NOOP                 (0x0000)
> +#define MPI3_EEDPFLAGS_EEDP_OP_CHECK                (0x0001)
> +#define MPI3_EEDPFLAGS_EEDP_OP_STRIP                (0x0002)
> +#define MPI3_EEDPFLAGS_EEDP_OP_CHECK_REMOVE         (0x0003)
> +#define MPI3_EEDPFLAGS_EEDP_OP_INSERT               (0x0004)
> +#define MPI3_EEDPFLAGS_EEDP_OP_REPLACE              (0x0006)
> +#define MPI3_EEDPFLAGS_EEDP_OP_CHECK_REGEN          (0x0007)
> +#define MPI3_EEDP_UDS_512                           (0x01)
> +#define MPI3_EEDP_UDS_520                           (0x02)
> +#define MPI3_EEDP_UDS_4080                          (0x03)
> +#define MPI3_EEDP_UDS_4088                          (0x04)
> +#define MPI3_EEDP_UDS_4096                          (0x05)
> +#define MPI3_EEDP_UDS_4104                          (0x06)
> +#define MPI3_EEDP_UDS_4160                          (0x07)
> +struct _mpi3_request_header {
> +	__le16             host_tag;
> +	u8                 ioc_use_only02;
> +	u8                 function;
> +	__le16             ioc_use_only04;
> +	u8                 ioc_use_only06;
> +	u8                 msg_flags;
> +	__le16             change_count;
> +	__le16             function_dependent;
> +};
> +
> +struct _mpi3_default_reply {
> +	__le16             host_tag;
> +	u8                 ioc_use_only02;
> +	u8                 function;
> +	__le16             ioc_use_only04;
> +	u8                 ioc_use_only06;
> +	u8                 msg_flags;
> +	__le16             ioc_use_only08;
> +	__le16             ioc_status;
> +	__le32             ioc_log_info;
> +};
> +
> +#define MPI3_HOST_TAG_INVALID                       (0xffff)
> +#define MPI3_FUNCTION_IOC_FACTS                     (0x01)
> +#define MPI3_FUNCTION_IOC_INIT                      (0x02)
> +#define MPI3_FUNCTION_PORT_ENABLE                   (0x03)
> +#define MPI3_FUNCTION_EVENT_NOTIFICATION            (0x04)
> +#define MPI3_FUNCTION_EVENT_ACK                     (0x05)
> +#define MPI3_FUNCTION_CI_DOWNLOAD                   (0x06)
> +#define MPI3_FUNCTION_CI_UPLOAD                     (0x07)
> +#define MPI3_FUNCTION_IO_UNIT_CONTROL               (0x08)
> +#define MPI3_FUNCTION_PERSISTENT_EVENT_LOG          (0x09)
> +#define MPI3_FUNCTION_MGMT_PASSTHROUGH              (0x0a)
> +#define MPI3_FUNCTION_CONFIG                        (0x10)
> +#define MPI3_FUNCTION_SCSI_IO                       (0x20)
> +#define MPI3_FUNCTION_SCSI_TASK_MGMT                (0x21)
> +#define MPI3_FUNCTION_SMP_PASSTHROUGH               (0x22)
> +#define MPI3_FUNCTION_NVME_ENCAPSULATED             (0x24)
> +#define MPI3_FUNCTION_TARGET_ASSIST                 (0x30)
> +#define MPI3_FUNCTION_TARGET_STATUS_SEND            (0x31)
> +#define MPI3_FUNCTION_TARGET_MODE_ABORT             (0x32)
> +#define MPI3_FUNCTION_TARGET_CMD_BUF_POST_BASE      (0x33)
> +#define MPI3_FUNCTION_TARGET_CMD_BUF_POST_LIST      (0x34)
> +#define MPI3_FUNCTION_CREATE_REQUEST_QUEUE          (0x70)
> +#define MPI3_FUNCTION_DELETE_REQUEST_QUEUE          (0x71)
> +#define MPI3_FUNCTION_CREATE_REPLY_QUEUE            (0x72)
> +#define MPI3_FUNCTION_DELETE_REPLY_QUEUE            (0x73)
> +#define MPI3_FUNCTION_TOOLBOX                       (0x80)
> +#define MPI3_FUNCTION_DIAG_BUFFER_POST              (0x81)
> +#define MPI3_FUNCTION_DIAG_BUFFER_MANAGE            (0x82)
> +#define MPI3_FUNCTION_DIAG_BUFFER_UPLOAD            (0x83)
> +#define MPI3_FUNCTION_MIN_IOC_USE_ONLY              (0xc0)
> +#define MPI3_FUNCTION_MAX_IOC_USE_ONLY              (0xef)
> +#define MPI3_FUNCTION_MIN_PRODUCT_SPECIFIC          (0xf0)
> +#define MPI3_FUNCTION_MAX_PRODUCT_SPECIFIC          (0xff)
> +#define MPI3_IOCSTATUS_LOG_INFO_AVAIL_MASK          (0x8000)
> +#define MPI3_IOCSTATUS_LOG_INFO_AVAILABLE           (0x8000)
> +#define MPI3_IOCSTATUS_STATUS_MASK                  (0x7fff)
> +#define MPI3_IOCSTATUS_SUCCESS                      (0x0000)
> +#define MPI3_IOCSTATUS_INVALID_FUNCTION             (0x0001)
> +#define MPI3_IOCSTATUS_BUSY                         (0x0002)
> +#define MPI3_IOCSTATUS_INVALID_SGL                  (0x0003)
> +#define MPI3_IOCSTATUS_INTERNAL_ERROR               (0x0004)
> +#define MPI3_IOCSTATUS_INSUFFICIENT_RESOURCES       (0x0006)
> +#define MPI3_IOCSTATUS_INVALID_FIELD                (0x0007)
> +#define MPI3_IOCSTATUS_INVALID_STATE                (0x0008)
> +#define MPI3_IOCSTATUS_INSUFFICIENT_POWER           (0x000a)
> +#define MPI3_IOCSTATUS_INVALID_CHANGE_COUNT         (0x000b)
> +#define MPI3_IOCSTATUS_FAILURE                      (0x001f)
> +#define MPI3_IOCSTATUS_CONFIG_INVALID_ACTION        (0x0020)
> +#define MPI3_IOCSTATUS_CONFIG_INVALID_TYPE          (0x0021)
> +#define MPI3_IOCSTATUS_CONFIG_INVALID_PAGE          (0x0022)
> +#define MPI3_IOCSTATUS_CONFIG_INVALID_DATA          (0x0023)
> +#define MPI3_IOCSTATUS_CONFIG_NO_DEFAULTS           (0x0024)
> +#define MPI3_IOCSTATUS_CONFIG_CANT_COMMIT           (0x0025)
> +#define MPI3_IOCSTATUS_SCSI_RECOVERED_ERROR         (0x0040)
> +#define MPI3_IOCSTATUS_SCSI_TM_NOT_SUPPORTED        (0x0041)
> +#define MPI3_IOCSTATUS_SCSI_INVALID_DEVHANDLE       (0x0042)
> +#define MPI3_IOCSTATUS_SCSI_DEVICE_NOT_THERE        (0x0043)
> +#define MPI3_IOCSTATUS_SCSI_DATA_OVERRUN            (0x0044)
> +#define MPI3_IOCSTATUS_SCSI_DATA_UNDERRUN           (0x0045)
> +#define MPI3_IOCSTATUS_SCSI_IO_DATA_ERROR           (0x0046)
> +#define MPI3_IOCSTATUS_SCSI_PROTOCOL_ERROR          (0x0047)
> +#define MPI3_IOCSTATUS_SCSI_TASK_TERMINATED         (0x0048)
> +#define MPI3_IOCSTATUS_SCSI_RESIDUAL_MISMATCH       (0x0049)
> +#define MPI3_IOCSTATUS_SCSI_TASK_MGMT_FAILED        (0x004a)
> +#define MPI3_IOCSTATUS_SCSI_IOC_TERMINATED          (0x004b)
> +#define MPI3_IOCSTATUS_SCSI_EXT_TERMINATED          (0x004c)
> +#define MPI3_IOCSTATUS_EEDP_GUARD_ERROR             (0x004d)
> +#define MPI3_IOCSTATUS_EEDP_REF_TAG_ERROR           (0x004e)
> +#define MPI3_IOCSTATUS_EEDP_APP_TAG_ERROR           (0x004f)
> +#define MPI3_IOCSTATUS_TARGET_INVALID_IO_INDEX      (0x0062)
> +#define MPI3_IOCSTATUS_TARGET_ABORTED               (0x0063)
> +#define MPI3_IOCSTATUS_TARGET_NO_CONN_RETRYABLE     (0x0064)
> +#define MPI3_IOCSTATUS_TARGET_NO_CONNECTION         (0x0065)
> +#define MPI3_IOCSTATUS_TARGET_XFER_COUNT_MISMATCH   (0x006a)
> +#define MPI3_IOCSTATUS_TARGET_DATA_OFFSET_ERROR     (0x006d)
> +#define MPI3_IOCSTATUS_TARGET_TOO_MUCH_WRITE_DATA   (0x006e)
> +#define MPI3_IOCSTATUS_TARGET_IU_TOO_SHORT          (0x006f)
> +#define MPI3_IOCSTATUS_TARGET_ACK_NAK_TIMEOUT       (0x0070)
> +#define MPI3_IOCSTATUS_TARGET_NAK_RECEIVED          (0x0071)
> +#define MPI3_IOCSTATUS_SAS_SMP_REQUEST_FAILED       (0x0090)
> +#define MPI3_IOCSTATUS_SAS_SMP_DATA_OVERRUN         (0x0091)
> +#define MPI3_IOCSTATUS_DIAGNOSTIC_RELEASED          (0x00a0)
> +#define MPI3_IOCSTATUS_CI_UNSUPPORTED               (0x00b0)
> +#define MPI3_IOCSTATUS_CI_UPDATE_SEQUENCE           (0x00b1)
> +#define MPI3_IOCSTATUS_CI_VALIDATION_FAILED         (0x00b2)
> +#define MPI3_IOCSTATUS_CI_UPDATE_PENDING            (0x00b3)
> +#define MPI3_IOCSTATUS_SECURITY_KEY_REQUIRED        (0x00c0)
> +#define MPI3_IOCSTATUS_INVALID_QUEUE_ID             (0x0f00)
> +#define MPI3_IOCSTATUS_INVALID_QUEUE_SIZE           (0x0f01)
> +#define MPI3_IOCSTATUS_INVALID_MSIX_VECTOR          (0x0f02)
> +#define MPI3_IOCSTATUS_INVALID_REPLY_QUEUE_ID       (0x0f03)
> +#define MPI3_IOCSTATUS_INVALID_QUEUE_DELETION       (0x0f04)
> +#define MPI3_IOCLOGINFO_TYPE_MASK               (0xf0000000)
> +#define MPI3_IOCLOGINFO_TYPE_SHIFT              (28)
> +#define MPI3_IOCLOGINFO_TYPE_NONE               (0x0)
> +#define MPI3_IOCLOGINFO_TYPE_SAS                (0x3)
> +#define MPI3_IOCLOGINFO_LOG_DATA_MASK           (0x0fffffff)
> +#endif
> --=20
> 2.18.1
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

