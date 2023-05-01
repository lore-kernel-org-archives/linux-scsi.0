Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF3EAC77B7C
	for <linux-scsi@archiver.kernel.org>; Mon,  1 May 2023 15:08:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232332AbjEAPIK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 May 2023 11:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbjEAPII (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 May 2023 11:08:08 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48FCB185
        for <linux-scsi@vger.kernel.org>; Mon,  1 May 2023 08:08:07 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 341EJ0R5019630;
        Mon, 1 May 2023 15:08:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=u1X6P/446RD1rUnhOO1BTCN2AqFRQx9tb/V6O9o9nd4=;
 b=II9fJNfDuDB1AZBIUZN2e4QW3O5egsQNzJdv7v1fioZvPGxu7uG1VA43csYyUqiP4CNK
 KjmMjuvt0zXCRYsQhRykNGYN6H0x2Z059WoNHEYmgRiodxPFm3AAHCuRYFrtwsktsr33
 g6q0f2dTtXoTvv7dQh5pK93+c+zW0pILaTMBoIdzLNCqTHF0V5wWrOX4htgI7k9tt0Fs
 EdSLQ1QPACVhrMv+nvaVofl8GQA0D5AIv2J9r5Fs7EO6dBU83/Y/I3s5DZodFpvKpV30
 ICHW7I+vureG1U4CQVmHPkPLLmDs1ycOfFENrm3fSJ1boa/vcBO0h9qmdBe0ftfqTWTt Dg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3q8sne2k0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 May 2023 15:08:05 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 341EhHrd022330;
        Mon, 1 May 2023 15:08:04 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3q8spatd8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 May 2023 15:08:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZXJz0n8EoLheOvFfWXXxCdAN93pfyIHr8+lA0zGAe2pk5JzIAyfkKTv9MO6mD8PF6yKN95Bdydw31+ShOf0d4B8sauN2bQ0F8sabU++sDTf2+ROCnRkSIF2wZBz6XN4Llm7hSp0g2CuPA3ZYR5/dS4YPNmKGi0n3Rdw3KS4b4AhPSxHmzk/J1fkNg2tI83mCCB89g01jv9y1YJubl3kw+72qQ2XB8k34qXtOrEsbRqzI/i0qmmJGOxMq7e7BhPxA/czwoVZBJdU2OVHps+NHFIu8SXwdGgBRBK8AY3MmyalDinTdpffQmEMSH3WI7KmI46fQ5gxKGQz92Qe7r44jNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u1X6P/446RD1rUnhOO1BTCN2AqFRQx9tb/V6O9o9nd4=;
 b=CI8CmhSvBuApfb3KqdVUy5kcStc10F5qI/gzjGrHHCirQ8a7RaTIKWH1p6ok8rQQmRzQA5LrvMTi3d1VKpM4IAveG7kLfLhA+tetCRCYbCMFaq+35CGr3MFrv7Erqk+Cj2B16+2aoUq1lxvcQNKrsmMkDgow08bXCAZx3XhxU1OZgd3wIBCLlJdVgNsSz0DcbmNFdE7FsjnrUm9i5x/IodQi8lVYW1alR7BS9r0WfBlkPqBfqW4wMmsEPpQaU9pLOZraUydeP7eOH5J1Wex/gIJqThlYslUbhpntMpfCw4KcWqIpk2g1F5ZcZRKH50GiAPQl+j04vLjs6JfB8+ZMzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u1X6P/446RD1rUnhOO1BTCN2AqFRQx9tb/V6O9o9nd4=;
 b=FyesK87/+CRIw26ot9JBr+yaM8yRyIzWhC67Ly0q4cB/r+J/VDAmRzagUTw+2KbJZdQ7+1F4nzUJUlcxa3ITfXb5/HEzdEQoE6sM7ZjUinIGU1xlgxD4uij4Z0tLo84k4jfttwkosVOkjqogVxwIwUte5hPiucBkJdELT2H0qaw=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BY5PR10MB4340.namprd10.prod.outlook.com (2603:10b6:a03:210::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Mon, 1 May
 2023 15:08:00 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::195a:41b1:6434:af74]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::195a:41b1:6434:af74%7]) with mapi id 15.20.6340.030; Mon, 1 May 2023
 15:08:00 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "bhazarika@marvell.com" <bhazarika@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>,
        "sdeodhar@marvell.com" <sdeodhar@marvell.com>
Subject: Re: [PATCH v2 3/7] qla2xxx: Fix task management cmd fail due to
 unavailable resource
Thread-Topic: [PATCH v2 3/7] qla2xxx: Fix task management cmd fail due to
 unavailable resource
Thread-Index: AQHZeaarw4Mg4sZVE0imQAMpMmnvja9FihYA
Date:   Mon, 1 May 2023 15:08:00 +0000
Message-ID: <4E5B3DB0-A871-431E-A42B-3541AE21FF01@oracle.com>
References: <20230428075339.32551-1-njavali@marvell.com>
 <20230428075339.32551-4-njavali@marvell.com>
In-Reply-To: <20230428075339.32551-4-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|BY5PR10MB4340:EE_
x-ms-office365-filtering-correlation-id: 4de21890-e18f-4fa9-c6d5-08db4a55daca
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nTgaBUgdHrkp4cNbTPU7fIQ4Soi2rGg8VDn/Yq4wrHO9ZOT0Zzd+7w7rEH5eW+8nNHicyQoGHLLWBXgzt8IHMmwLcdkdZ/K5XwpEf4EbUvF0Mn4KCtBHdgzwxB5GlHhcUeFTmq1+XHaOUeUC0Jr9Kkos18tT+D+6ccmLNWRSOmf0yAATQ6WW/9M6QIm3KvpJKYudJngzoPw36SIBOkcEeNB9BPwENX+qRcBaz3wXJOsZ9TAaFE/3kuWfq83BWTCchKFvPSmOESmNMVxes3pRnZj1p3jDMk2zcYcedS/EbJThKxCmubCfpogRtR/80fjrKxC63q+2vrXckgYwBY0rLMTNo5y0Xy94+cg5D6OpI78ZjZH1n3P1iGqXENrBkWbmbLGyPYo7tpkulBoTqiI8d+ST0BLbgtGwUrUjZaDyi6hc/BmnMvREEbHk1amFiEiRj+KYw9PRsxPRkdCr1WRbKRYEGQMxRcmTBlsqlWgwSHyGAyd6AH4JRakTvl1kCYs4OFP5ZKjzZmozZz8TDACD2qvD5QuP3/PTUrsHAGRc+Ni3LNrbzwYygMrMC+zTOTIaq7lVQXCFVLnxY6xTBa2ftYKjzijDOHyFR2pu5GHsRo3vDAys+HHDQS6mNhLZo+VlgVczFKDqi++lSxknH7wjHQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(366004)(346002)(396003)(39860400002)(451199021)(54906003)(478600001)(316002)(36756003)(4326008)(64756008)(66446008)(66476007)(76116006)(6916009)(66556008)(966005)(66946007)(6512007)(6506007)(26005)(2616005)(71200400001)(6486002)(186003)(53546011)(2906002)(8676002)(8936002)(5660300002)(44832011)(41300700001)(86362001)(38070700005)(38100700002)(122000001)(33656002)(83380400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ot7Dx86IjfJ1VPMk+L4DOhU7187DfAk7aTSM302SnnY0mQSrrWdzbucW5rXD?=
 =?us-ascii?Q?hoOhe8bB/fVk+HEUAJE59KETWqZ/LTB8BzhfqBOc8wnV8RqgFWJJpBGELtnN?=
 =?us-ascii?Q?QWJPUchkgcMpy16YF38/M83/rfTZ4qIWEb0vdhXJJIkmwGjKMgRc4nN1cud8?=
 =?us-ascii?Q?Jjhf1Z2D5Q+5qZZVvz6+mL/KOexu9n3rpf2ynE6Na0dp8+Tg9dY0XEAlBFgX?=
 =?us-ascii?Q?tDSWCg9yyWCD/iwzG3KlV63YJ9l3QFgov4LJuFVvi1oqlz1kLN2WHh3ZNLOQ?=
 =?us-ascii?Q?wq6X6M1DH4yggyivfHTqPifbecTtMvH1Ym6uWkciQxHHwMlMV5IojOlZQn8o?=
 =?us-ascii?Q?YIP515zFCwNP+iPn9250Mu+bLvQrMgyqjg523/DKFCn7KiLVWXoDEgBBPknu?=
 =?us-ascii?Q?UE6O9G3Z+TvktLih/XL70kb+3kDPSUGSIGwO/3Zi/MZYlzWYGv2kLGol05Bs?=
 =?us-ascii?Q?IDS0EF5nEHYSfVuqhpzIOrEX87PVJvhLfJU9Fswyryfu4FNTfW8XglZc/UdR?=
 =?us-ascii?Q?E/BrP6F1XxoaVwaP+wr/d00oAo0f1JW68KBBZAYPewgiSivgA5KmQGUHlU4s?=
 =?us-ascii?Q?LVovuHk0hdV22vYatu3OhLMV4yu03hxxGbSxxEF/qS5r6PfLLx1VeHjUpB3/?=
 =?us-ascii?Q?Aq5OWyDPTzmu79eBjA1r84V9B85cPrWbTk05RzL0VWodw3KELlFAyQPTVjKp?=
 =?us-ascii?Q?yvyHeizEsXW3uym3lqmN8CfYB1Aqis2UZCUV7U296WgUPfid+qzGHoCq3IYa?=
 =?us-ascii?Q?yfQVvV3H7knw3O1EVtqNbKs//DJZIfL+AbIDvwyTVBQKaZpaht0rB/bSI2Jq?=
 =?us-ascii?Q?xJr4sn0UyQpxalVZbV4dBm2Hz/+Dphug0LGLHVE7lZp/MeBaPFuzYktbIITS?=
 =?us-ascii?Q?2SV2y6JdEkYlwd7BeJ9B0YTEmznMl+MuazWuVtjX7IANK7cgeCTcyWPyFrbB?=
 =?us-ascii?Q?ZVU5UrhLa/Wu/MMg6tMig/eHDG5XCm8ahjnxRLH9v79a8A3zcfi/xAji2UoC?=
 =?us-ascii?Q?6t/HN5shoizbqdTgpyn6tCanRhMzB+XRyqkbQ4fJyw95oFxyUdyQY3K3QTKR?=
 =?us-ascii?Q?UeplKHHjhAKWGf0GEFsxuGoiyknYEiO1e/Xubqvx986El49R2kM9C2qpVkbK?=
 =?us-ascii?Q?VdXbmzB9F8tDkGpTJhDp/PSVbGYrfHhZsLF+GYKZqzjQSbHWpE6SRJETQXqt?=
 =?us-ascii?Q?ITkPQXyE8moArfqH3e0ZONhnoabY3SNt23GiQIdS8TSIyu83IjzzR1PTLQ8d?=
 =?us-ascii?Q?0Or6ZHeWQTCRhj6TzuKaSCFogflzW3cG0P/dCwMRrU4j58h1ZkDcoODZlr6T?=
 =?us-ascii?Q?ZM06PGASeW8yQAtYBVbE3X4TyQZcsv37CUB0O0FAVJpV64+WlWBcA8ppUNwm?=
 =?us-ascii?Q?Gl1rlDpaDPYG7ayEZELJZ9zDR/20UDCezXUVYsHPKKCLFdhYAo8f+tK6Vair?=
 =?us-ascii?Q?T0JDn4ypnSEvyHjHUzWjZcTWeQ+XbFXcQwU7gV6Wu0mZa88j/iwMsa5UzwCy?=
 =?us-ascii?Q?K3IZ0lV68br8+SGJZ7DTReFgeLeZ7/lmVsN8Ny2YfqoPbWNtScuSxEkxbfxn?=
 =?us-ascii?Q?eaO5PkbhcoVyGlNBL2sowqzoC8sJY6ZH4pgJMB0DgnsRQ+SEOYaWZBpaei55?=
 =?us-ascii?Q?Tw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <53771A1DE5368F419CFC00145F68A3E4@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 3UJkzF0ZmwvgI/ymI+Zn+Ng2TMHSYNQTeVmf1jtZZwlO8gBsQbdFoLWoemVFnG8Kwvyh4hSq8al3vk408k8zV1/Kf+ZO71PXoALq2eCrgDyRb6/eZtrpzF0dj9jfjRRLsbMgTRrmiADVbYW6t05gu5p+ZwJOLjrRf3M3r/5cfn/Gf0qtIphVto3OImTaWjSEesWk02mw3rgogxwqLHfINBgN9Y7c1x0W752EnGgnJxIS2DrwZ0izB3Z2TFghUf2F66yCpsrBW0X2FlHBeGEUirrMmOE4Uopic1GpG2j5mkmw3LIpZfZe3bOl5mLh2OZyABSYxgtgrsIausI7nsVeB8XOl7nnxS1sx21tN7Pm6HSw2Vpwwv1WJqMLto3+geabZInu3U+SV8STBkccCYFbr0VPTt2AY1APADqeNgcioEAekcHn9tJ5TvBAmxdbajciK9lsySoG9EKnd65f21yAumDgUp5eVb33Pa8WQ08cxt25gp29Tx+us4mKnOnHvewkgNJp3ZL6In+9J+TvhIozjDwUipnEyXN3kkDOhhGAiAEg08EGFnK+NUVzun62ZdLMNm/ad71RQ1cciyUUDeSjey33CvOeqwIhWAn1ZHp/DP9REY5DfiiyyKkHzNo+V7CqmPeFaSHscpHTsbWVrMvk8fB9RMZYxFS5TKSdZ19Yy9t4ZTvmBMsjlnqIXCbuOwZL6gelZk0TITIuatbNTtybO/asWSiajfs6CLaX4NlU+9r20HWvL6bRXyvuiTJEhd/K/LwltUy4vk8ZGFYHPxRKk3SRmR5bW/lestsMEr+6P28=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4de21890-e18f-4fa9-c6d5-08db4a55daca
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2023 15:08:00.6439
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VyAmnX4iafnRHQrHs0sTydh6VZrF7rM+bRu9U6g372RySXizzK/30/1RDMI5HvEB+8st0/rUJu3np9u4ar5cwiTEAVKFQl43A5jXMVwSGmA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4340
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-01_08,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2305010122
X-Proofpoint-GUID: agOAiPS-TlKxafrWdUsqrAW9hVuZJ2DY
X-Proofpoint-ORIG-GUID: agOAiPS-TlKxafrWdUsqrAW9hVuZJ2DY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 28, 2023, at 12:53 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> Task management command failed with status 2Ch which is
> a result of too many task management commands sent
> to the same target. Hence limit task management commands
> to 8 per target.
>=20
> Reported-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/oe-kbuild-all/202304271952.NKNmoFzv-lkp@int=
el.com/
> Cc: stable@vger.kernel.org
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> v2:
> - Fix warning reported by kernel robot.
>=20
> drivers/scsi/qla2xxx/qla_def.h  |  3 ++
> drivers/scsi/qla2xxx/qla_init.c | 63 ++++++++++++++++++++++++++++++---
> 2 files changed, 61 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_de=
f.h
> index 0437e0150a50..0971150953a9 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -2543,6 +2543,7 @@ enum rscn_addr_format {
> typedef struct fc_port {
> struct list_head list;
> struct scsi_qla_host *vha;
> + struct list_head tmf_pending;
>=20
> unsigned int conf_compl_supported:1;
> unsigned int deleted:2;
> @@ -2563,6 +2564,8 @@ typedef struct fc_port {
> unsigned int do_prli_nvme:1;
>=20
> uint8_t nvme_flag;
> + uint8_t active_tmf;
> +#define MAX_ACTIVE_TMF 8
>=20
> uint8_t node_name[WWN_SIZE];
> uint8_t port_name[WWN_SIZE];
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index 2402b1402e0d..17649cf9c39d 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -2149,6 +2149,54 @@ __qla2x00_async_tm_cmd(struct tmf_arg *arg)
> return rval;
> }
>=20
> +static void qla_put_tmf(fc_port_t *fcport)
> +{
> + struct scsi_qla_host *vha =3D fcport->vha;
> + struct qla_hw_data *ha =3D vha->hw;
> + unsigned long flags;
> +
> + spin_lock_irqsave(&ha->tgt.sess_lock, flags);
> + fcport->active_tmf--;
> + spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
> +}
> +
> +static
> +int qla_get_tmf(fc_port_t *fcport)
> +{
> + struct scsi_qla_host *vha =3D fcport->vha;
> + struct qla_hw_data *ha =3D vha->hw;
> + unsigned long flags;
> + int rc =3D 0;
> + LIST_HEAD(tmf_elem);
> +
> + spin_lock_irqsave(&ha->tgt.sess_lock, flags);
> + list_add_tail(&tmf_elem, &fcport->tmf_pending);
> +
> + while (fcport->active_tmf >=3D MAX_ACTIVE_TMF) {
> + spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
> +
> + msleep(1);
> +
> + spin_lock_irqsave(&ha->tgt.sess_lock, flags);
> + if (fcport->deleted) {
> + rc =3D EIO;
> + break;
> + }
> + if (fcport->active_tmf < MAX_ACTIVE_TMF &&
> +    list_is_first(&tmf_elem, &fcport->tmf_pending))
> + break;
> + }
> +
> + list_del(&tmf_elem);
> +
> + if (!rc)
> + fcport->active_tmf++;
> +
> + spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
> +
> + return rc;
> +}
> +
> int
> qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint64_t lun,
>     uint32_t tag)
> @@ -2156,18 +2204,19 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t =
flags, uint64_t lun,
> struct scsi_qla_host *vha =3D fcport->vha;
> struct qla_qpair *qpair;
> struct tmf_arg a;
> - struct completion comp;
> int i, rval;
>=20
> - init_completion(&comp);
> a.vha =3D fcport->vha;
> a.fcport =3D fcport;
> a.lun =3D lun;
> -
> - if (flags & (TCF_LUN_RESET|TCF_ABORT_TASK_SET| TCF_CLEAR_TASK_SET|TCF_C=
LEAR_ACA))
> + if (flags & (TCF_LUN_RESET|TCF_ABORT_TASK_SET| TCF_CLEAR_TASK_SET|TCF_C=
LEAR_ACA)) {
> a.modifier =3D MK_SYNC_ID_LUN;
> - else
> +
> + if (qla_get_tmf(fcport))
> + return QLA_FUNCTION_FAILED;
> + } else {
> a.modifier =3D MK_SYNC_ID;
> + }
>=20
> if (vha->hw->mqenable) {
> for (i =3D 0; i < vha->hw->num_qpairs; i++) {
> @@ -2186,6 +2235,9 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t fl=
ags, uint64_t lun,
> a.flags =3D flags;
> rval =3D __qla2x00_async_tm_cmd(&a);
>=20
> + if (a.modifier =3D=3D MK_SYNC_ID_LUN)
> + qla_put_tmf(fcport);
> +
> return rval;
> }
>=20
> @@ -5400,6 +5452,7 @@ qla2x00_alloc_fcport(scsi_qla_host_t *vha, gfp_t fl=
ags)
> INIT_WORK(&fcport->reg_work, qla_register_fcport_fn);
> INIT_LIST_HEAD(&fcport->gnl_entry);
> INIT_LIST_HEAD(&fcport->list);
> + INIT_LIST_HEAD(&fcport->tmf_pending);
>=20
> INIT_LIST_HEAD(&fcport->sess_cmd_list);
> spin_lock_init(&fcport->sess_cmd_lock);
> --=20
> 2.23.1
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani Oracle Linux Engineering

