Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BCA9C43334
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jul 2022 19:14:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231638AbiGMTOn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jul 2022 15:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236838AbiGMTOk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jul 2022 15:14:40 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456FB1F2D8
        for <linux-scsi@vger.kernel.org>; Wed, 13 Jul 2022 12:14:39 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26DJDmkw023352;
        Wed, 13 Jul 2022 19:14:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ZrN1svKNgTEJZjwH4xsFc9FQHMZXIVIVPuyvEk1HhpM=;
 b=qL9EwvPc1Hab5fPFTKJwtb8U9t2FHh3FUd8vUfgdXN022Td0d4kLOrBgoRGbkynStIl4
 0x8zgARWVOMdgNLrb8ycK8BAexauTau+SMqYTCSLByHElRsCAqbheBnGwuMDibeb9W8a
 +bpanOV1MgA5p3Brnjx8RDBLzLkYDXSuJeV5XBet2nrkHLCDQuIO1+6kYy8GNtLVE21X
 SLLH/HFOJQpu6z8LKf4sTGZ2T3FXTr7+2/j9FBmx6snv2xq2OOcr4YcCAxGVE8tH63WO
 WFuIoJQHzLvSIaKFf3oTdqD6W5x4GJEw/W3UtYkyNcKoQkLG49LZ5qLflbE52DAWPxTb KQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h71scb9a3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jul 2022 19:14:37 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26DJ6pUR031158;
        Wed, 13 Jul 2022 19:14:37 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2174.outbound.protection.outlook.com [104.47.73.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h7044q6y1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jul 2022 19:14:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NF5MdM0Hxm3oS89jWUUp1RIeZKNSPfx+Iq1L0zMopS9rtqexF6UxXOvo3G35t32QgIqzBGAFTvxmPNnZ74ijqxDqVZbi20GdfJJC72uwCXaj8gdNwHql264P/QcLXgmXA+5Z7Jf1+xHMWfuceNn34qZAwrqaRvOkAhsBkJg6XxLLNz6eVUX8SKfxtu8z75PSDh/E21lcQw9T2Rx+I3OTV5WplSVftda+8XYzfwyqxTi15vmjEmw9Xnc21/FUA3L9QttFaESz+6QNRLGxEAfBnqyO8R7nb4+2toR/r+pbcjMraMY9x9p8n2GMH9K7OyHnvhc03+9QdCFoeuHD98oICA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZrN1svKNgTEJZjwH4xsFc9FQHMZXIVIVPuyvEk1HhpM=;
 b=RBVhHGQzglnyiEMYzDq6qDYMgXSG7rQJk8iVeNgtZCMuG9hCHaImJdL6/xyMuGiTjF4GV2/9If8CfiVcjVKTrK1JupkudHSr33401RAMNmTwb+IGDWlQubwiPMvgffOqyGrILJS4ZUXQ+QoLMsCpNidyCt0kEWxyS9ia+S+ZCr8suxgrzqR9MOSi1qjhnE53fkti6ELBjX+xcjHVZ716NgjXkuZizjYhW5pZChAxCTDOnHG/dt7eTXN8YAAUrcN7naEzLwHEVdn9fUhHBslsUVzx3fn5oeRjeV+Kdj/b3xvnxSsctOKVnpFzkUpirv04/Lf1mZJFTnyLpC2amhpVNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZrN1svKNgTEJZjwH4xsFc9FQHMZXIVIVPuyvEk1HhpM=;
 b=IdlEneAPbT5bKl+5YP2zh4q7pf/ecggc8xZV5bWWYapVODVWmyYwA98ims0KNCM7eOwGK1zqllp0bctYaen5ceZGsMEoelJyZuAheG5Ucp/A5PblQu9H9BYmTptPtnEfwZkCp9jaIzGn5IjzYUL1/VzjTL/7V5ZBHFgrq1F9Kpo=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by CY4PR10MB1287.namprd10.prod.outlook.com (2603:10b6:903:2b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Wed, 13 Jul
 2022 19:14:34 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a99d:1057:f4ba:a4eb]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a99d:1057:f4ba:a4eb%3]) with mapi id 15.20.5417.026; Wed, 13 Jul 2022
 19:14:34 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 00/10] qla2xxx bug fixes
Thread-Topic: [PATCH 00/10] qla2xxx bug fixes
Thread-Index: AQHYlnhanBMNFMakc0WV5Zinx2jvqa18rKEA
Date:   Wed, 13 Jul 2022 19:14:34 +0000
Message-ID: <A69D1C1D-7FF1-4F44-AAC9-5AE7B3A4EF85@oracle.com>
References: <20220713052045.10683-1-njavali@marvell.com>
In-Reply-To: <20220713052045.10683-1-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cfee1ae3-bddd-4b74-675b-08da6503ec24
x-ms-traffictypediagnostic: CY4PR10MB1287:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nIPyDI1v1mEaL5Nzc4CCFv01kgJowHypcT0a0rb4hEP2QMfM9MWk5tAfTOxra6ibV4CIGeoG4CEcKMQbPmOUC9zTH/ZjYKOKSCHxxtzP2CJGKrJ9T9DnbFbXfGzIjs5vpjVZCmGGKfg2yoMgxAaAddxHy6Pg5hmdEs916QtjGWoa+QvsWjqj5ZzwPWR8CZNDF/hs+QFNTCkeHQfk5q62he2zgcDRuyY5XMH3N+CGLnq6MG4mB+fxAh/PDSgHmKS1d4a9HiyuYnvP/Td1VR39tgbT3m0yz1Z7eQuDqfoIYCSedqjOfT3CCT0Jol0l60rHL8PmcFsrS5BY15G1nQ0phcNX2JiuKUniqOUti862L7oA700AxkHVUps2RV4v+43dGfi0LaXFqcTEciGCVJs4JgOh5INXOhudcrEF2gzu8JVNGdN+p8mLkhVxdLJHV4iWt7HYrWzkgc2OUfBYM2wxFfDtAlUY2/9wL7NKOpS87f8N0ekrI/E6uv32SzAWqYAEiCrwWiaxVGsWLScPzZbIoWHbP9MrFq/3X0iLVXD4icJWplItxb1pMMBenhFEBQbJ39TPsZnwQrh0NnefaUuzAdcPlzT2pa3ubp1Rqkr0uFQTqFPeIxCk9gcYu5NLlCwYMjpj1vGp16wQJEpayVRUq/t+rDYEPl0GHZjYGGyuNY+EAyLdSOeKDxu2m0Hd66lDzmy+5YcLZnnxvFwqGW9G7DhQ98/2R9nePOt7N7p9kQ7Mlz8JWvaS8004crqptxZX+HDh3oXthTMvNCVsX2Ob9J5iPlmaoGnrS2ZhuzA8f3rLxSGy1nHfwplSevCnozMubh9S6xQ6XCNfPMAnQkvA6fgM3X4SJGSYCybVRanK5lA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(366004)(136003)(396003)(346002)(376002)(64756008)(66446008)(66476007)(54906003)(2616005)(66946007)(41300700001)(6486002)(71200400001)(8676002)(6916009)(66556008)(4326008)(2906002)(478600001)(76116006)(83380400001)(6506007)(8936002)(91956017)(5660300002)(44832011)(33656002)(316002)(38070700005)(86362001)(122000001)(26005)(36756003)(53546011)(38100700002)(186003)(6512007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?V3aDXkKcNwxaHxlsRrDSGGOXJZGdi4vMBJDxoRt3D/E9wQvJWU4csmP9h4CQ?=
 =?us-ascii?Q?ZqE43nWIa0zUK9utwEsOz9UEJ7Z+zKsDqmux+BNgJDP5wEjJ3xWSPwHLPqkh?=
 =?us-ascii?Q?oDQfl14u9MIqsQrdt8lbBgqOxGPYY/jKsrIbeTEeYbPJiPdK/ovDEgB+o4pr?=
 =?us-ascii?Q?gq6KTqKF8TmJu37b5T0OyTYMG8ajLOAUc99y5Vf+YDGTx0GFgX3hbSjND+ON?=
 =?us-ascii?Q?Kwnwy8O9Grz9RrQkTaxX1674iphnfGDj3JxASU5IRz4SHPytTRw9kKQ+V+W0?=
 =?us-ascii?Q?VVERagjaSF3IvvHxSKLql2PB2wh7fcuT3zQcAtxKlHW+wKa+W3g5pno9mAkK?=
 =?us-ascii?Q?f5TirpQe7WkKh4ewxjp1M8FTOd0sdfavnrZSHZeEVDwlsrf5n0G0FHCkw5Jn?=
 =?us-ascii?Q?+3qx7ynWNe8C4qw5wKR4R7gCEoGa5WIfvC4dCe4n33OqKyEQPgiURwkqs/Ta?=
 =?us-ascii?Q?QY/1VRMAmCzBg/r0bepQCBclf3HBMWDZ73gtYClDck6Ml5YzP5UiIVcbwUGb?=
 =?us-ascii?Q?6WFT97+MhFF+Jc9ot1s3y8bw7x4tvTrEClprPeQd3cIt0FTu7b2UUuL4kefL?=
 =?us-ascii?Q?ZlQE7taJg6FZgrAZufHcOcOjXyAzDCUdTIeDUlF+LVCbkG7YEbSjsVXV/ilB?=
 =?us-ascii?Q?Olw/DYaH5UCcs/18EM4un7tm9n09CEgPGiNj8148zPThW66CL9jDELhMuPJn?=
 =?us-ascii?Q?hP/JG3T9skmNEmyVizyURRfwQlPjy2kgvynt3nsRGt+TzIoF7fVDNPdqC5H0?=
 =?us-ascii?Q?gsBgL0Y84FG5ak3PnjwCRf34vHcegKCVr4GapOB2T6DWOxY3v6K/3Afauimm?=
 =?us-ascii?Q?Xz4TOM4nUDQdCD8e3irKuMoKXZxsmp4g3s108M7QZHM4kYK80CgdnJlrgzfS?=
 =?us-ascii?Q?jIzYIDftbBjtBGp4lbKCKpW3LjnxsHwbdFozZVWIISnIxtGn1yca6yi47Nxx?=
 =?us-ascii?Q?ECZ948lBptzkgzv4p1uty0prLc995Z6RCKIr/powGc9sbhdTeIgAhHZf9UI4?=
 =?us-ascii?Q?H50iF1CP17ezFlfd8du/On6pJvcVHV6RAANER/YCRdoZcaiuG34yT6Qu70f3?=
 =?us-ascii?Q?yPsbix7SWDGb9cUPXn8lveT6mXsle5KFJ4aB9yVd43Ux9g6gAYiL1pI1hPLb?=
 =?us-ascii?Q?Uu56m9LJx2pgrV7ISvuPFVBuhnUK2QLvplOrPTUXJGxSYkrVO+SrKAdIIdhj?=
 =?us-ascii?Q?rltVIIx2hRmHzEQk1x2Q0w1kGNViHjP38fG6altMaM6XuTxkALQGrnHi3htI?=
 =?us-ascii?Q?GXKIOwSgXdZe0SgBztLBEtOImqLJcbqkCagSraEWGZ8/ee7+asA4oKp0qAh1?=
 =?us-ascii?Q?OBVflega16MDCnk6ZV6hIDFQOF083L8elgEjW6WJh/z5F9msPwa5X46X5uHC?=
 =?us-ascii?Q?9uhpHB/8BnlVTT9XQ+iY6JYY44AGfAhhlp3Li4dil6+XpZ48poM8KzcCPUOb?=
 =?us-ascii?Q?Bchr98NLnGbMyoygStC2NtDkDgtPSFbJ+3RNYCW7JthiastCtze8mVm2dpGr?=
 =?us-ascii?Q?yZFrt13beqLvSSuT0CRt1dNFgZlfK17cdgpXTPdcJrnCpTSlZKPWIF4WWW6/?=
 =?us-ascii?Q?bjXZeyLXkIxPj72Jz2h2fm0ahv9+AZp+Y/AKBrDGDHpdQGGhr7QCp9qpqy89?=
 =?us-ascii?Q?JA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6DA1426949601A47B7A8FF30302D142E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfee1ae3-bddd-4b74-675b-08da6503ec24
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2022 19:14:34.7306
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T/MWLAWrk8K5e6MpGLP2ylnoQFiIIVK5V0+akzSVPNwNhCLwnvYRboDzTATldmJTe1djy5OjBO7bFp7/wIK1DcJJZNhJy2VY8tJYdnKbK/g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1287
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-13_07:2022-07-13,2022-07-13 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207130073
X-Proofpoint-GUID: UuZfB3_SUbu1G1cyuWEqttnTNkYUJDol
X-Proofpoint-ORIG-GUID: UuZfB3_SUbu1G1cyuWEqttnTNkYUJDol
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jul 12, 2022, at 10:20 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> Martin,
>=20
> Please apply the qla2xxx driver bug fixes to the scsi tree
> at your earliest convenience.
>=20
> Thanks,
> Nilesh
>=20
> Arun Easi (2):
>  qla2xxx: Fix response queue handler reading stale packets
>  qla2xxx: Fix discovery issues in FC-AL topology
>=20
> Bikash Hazarika (3):
>  qla2xxx: Fix incorrect display of max frame size
>  qla2xxx: zero undefined mailbox IN registers
>  qla2xxx: update manufacturer details
>=20
> Nilesh Javali (3):
>  Revert "scsi: qla2xxx: Fix disk failure to rediscover"
>  qla2xxx: fix sparse warning for dport_data
>  qla2xxx: Update version to 10.02.07.800-k
>=20
> Quinn Tran (2):
>  qla2xxx: edif: Fix dropped IKE message
>  qla2xxx: Fix imbalance vha->vref_count
>=20
> drivers/scsi/qla2xxx/qla_bsg.c     |  4 +-
> drivers/scsi/qla2xxx/qla_def.h     |  3 +-
> drivers/scsi/qla2xxx/qla_gbl.h     |  5 +-
> drivers/scsi/qla2xxx/qla_gs.c      | 11 ++--
> drivers/scsi/qla2xxx/qla_init.c    | 40 +++++++++++++--
> drivers/scsi/qla2xxx/qla_isr.c     | 80 ++++++++++++++++++------------
> drivers/scsi/qla2xxx/qla_mbx.c     |  7 ++-
> drivers/scsi/qla2xxx/qla_nvme.c    |  5 --
> drivers/scsi/qla2xxx/qla_os.c      | 10 ++++
> drivers/scsi/qla2xxx/qla_version.h |  4 +-
> 10 files changed, 114 insertions(+), 55 deletions(-)
>=20
>=20
> base-commit: bcec04b3cce4c498ef0d416a3a2aaf0369578151
> --=20
> 2.19.0.rc0
>=20

Looks Good. For the series

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	Oracle Linux Engineering

