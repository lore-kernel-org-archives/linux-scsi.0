Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF7B6C0015E
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Jul 2023 19:27:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232398AbjGMT1x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Jul 2023 15:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232834AbjGMT1v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Jul 2023 15:27:51 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F88272B
        for <linux-scsi@vger.kernel.org>; Thu, 13 Jul 2023 12:27:39 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36DHiNTi016569;
        Thu, 13 Jul 2023 19:27:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=SCMtezsl7JzOUG9yl0IFgfLmV/55AdnAxMUeW7MMJ1g=;
 b=asPYDAizWRlBe1uW90YCEF0TkKkomXuJ9g0UUlRhnE8kZ12H+0ebxZUOrUf6P7EgL5lP
 EAxApD697IlOshaVuof+LQdQVKNq9G+wxgn0+iS2fh5DlFAK5XT2eIYHQHnwGIhJMgem
 NG49smS4R9jvqdw/7doehDiIxZvZScyaeT5bWXN67URPNYBRTiJjdoiw05ODe7ssls9k
 L6VWFzVDSLi1LWRbHBauAxsSfsHzuak/0/m5COeXMdyM5OEtw8iZvltU3PyTvkLmseL/
 K9LaHxCdq4a7N1SxvNnk9Vp84TJbHJhVd11xYj4kAlOmhNRVvQ7NdF3jvFxA8QZ3vSMb hQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rpydu2b49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 19:27:37 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36DInJqP007760;
        Thu, 13 Jul 2023 19:27:31 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvqhebr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 19:27:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SWG6tE50/OBoVwBU8FuS631dASoG28u53e2jXAOjfTbBYSsRNifTqb6F8kF2JDk7C1I+1cZVc8mZWR4vaf28WY2Zvp4fXAxtHZ6v2F/JNPdmxTaDX/vA91+rHGjQQAYy0Fm39Eo3g1wEfH4W17NBVgFlp5jUQJPZOu2i59+5/MGvscDAhgdJN3IrN1viiaZUXZFZs74KhN5Eq7HKqMWCNgBW6KkIe57OyxhFGW7W9lESVnszeG6axm7pPyBGF0BVrC27wa9irX7/IZAN0YrnaxqQp/YenLuGhdaduQnjoylLEmlK6NNNJsUB2I8oYh/KIjBhBxLVyVbdpq3wJrbpFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SCMtezsl7JzOUG9yl0IFgfLmV/55AdnAxMUeW7MMJ1g=;
 b=hCi3bx4SKgC48fpvmm4iNKR6a/IaxQnssP3rv+uAGJz5zPZPsKAIidpDTOO2aQzAMzes7U5r9QHWKv86xUM1sJ+Awgp6ib2LvONDkfeCaOJrOifKQLV0QBm5Gtw7GhtUyPoiEBiiTEB1LX9Lqlt3VvuDVcG8ap9kegyPhPb9PcK2D/l/oTu/K09Autb9PHqfC/A/+AeaWxsS6qw6N3F7S5MZrieYbp9c8svHQDvs3E0A/uhqasT50csn76yf4m+GRwgY8vGZQNJLKwmWufUJy3zdhPkBgTvoZwTrQf2FbkJCs4cmbL6H9IBVuPkqPpy5t1AmiBnVCsXyFfvsRJR37A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SCMtezsl7JzOUG9yl0IFgfLmV/55AdnAxMUeW7MMJ1g=;
 b=t9B2VNCgTN9rHp4Gl3dCTEgbi4eDIP3NS3SVsxd4SaOmaXSNbT+8qjRLHPXM4ARbm5k6DYUzVG0GXPTrtyQ9UNKM79621s3tMud+CO+/JfQdeLBYl6RmGqZT7GLLigPmajTA5m/q+YNewvCvyvmPhEficu0Ky5Nd4TF677UaYto=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by CY8PR10MB7193.namprd10.prod.outlook.com (2603:10b6:930:76::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.24; Thu, 13 Jul
 2023 19:27:28 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::2ab7:3a22:b4e3:93ef]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::2ab7:3a22:b4e3:93ef%4]) with mapi id 15.20.6588.022; Thu, 13 Jul 2023
 19:27:28 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>,
        "sdeodhar@marvell.com" <sdeodhar@marvell.com>
Subject: Re: [PATCH 05/10] qla2xxx: Fix erroneous link up failure
Thread-Topic: [PATCH 05/10] qla2xxx: Fix erroneous link up failure
Thread-Index: AQHZtKBTXYVGo6Z5uE2lxFPbZmcVU6+4FtCA
Date:   Thu, 13 Jul 2023 19:27:28 +0000
Message-ID: <4471ED02-1D68-4BE2-9736-4D5180B19321@oracle.com>
References: <20230712090535.34894-1-njavali@marvell.com>
 <20230712090535.34894-6-njavali@marvell.com>
In-Reply-To: <20230712090535.34894-6-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|CY8PR10MB7193:EE_
x-ms-office365-filtering-correlation-id: bb4e3201-f2f3-4040-c388-08db83d73231
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1t5tzshnuVAay+KyZZQTXqeKQpliQlvGRAJiVAeF/rvNFl5D3QxDXzIwusAhd+AhTy6tziY57Y7yIUC53xEF4A5DdZXyNMN2T7SKG2wcaTGY5vjsbCCGwZic3U5WN2RqWqqx8yxjdEC5Dt+GM6oeQfRfMaGoXf5O4MkpLX777O0Z+hHSwx14nQW3LUNn4wl1JY5798uObaGt1xuHs6zeq1NiBNjmFTtArvLvqcO7j2gTJP6sfIvu6xuqSZvyLh8eL3wIDNjZAT+EoExfZaDPYQLJkb87z19XLP5hVDU0O9hgiHHHo1Clap2YIbb/C7Sg20XnyM24FKNQU4oEAZO8G+3UBsU/GOpdEyeeZX89HgGHR8slg2FW1PLc3CMVptRjBdkg2NdgQSRWhcQ/ZI6psCKeGJbbqPA/ExKh8Ns6phpNuItZjJ4Hzj5ZsybcM1P81fAwKNTl7V+0pQTUXDEsneyeY/xRfB1oxAkBVue4FL/P2PvSmcB3tsTvPplqRZ2gSSEByomV1kBfmwiAptjSVpAP5+eUHfTyA0pcwlZSZC/PQxXqQ2ywrLtxij95O4cUMaBOJLW52Irfwe5mwKNi6uB5f8wLCzjNc+1kT7t5PAsksq7KSdfWxry3DmRRohXs0QF5Nu9mZyiYctDsHmsFCQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(136003)(396003)(366004)(346002)(451199021)(38100700002)(6486002)(6512007)(71200400001)(33656002)(186003)(53546011)(83380400001)(36756003)(2616005)(38070700005)(86362001)(6506007)(122000001)(26005)(6916009)(66446008)(91956017)(4326008)(76116006)(66946007)(64756008)(66556008)(66476007)(2906002)(41300700001)(316002)(44832011)(5660300002)(8676002)(8936002)(54906003)(478600001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1TRbb7SevPoC7I6a3RciYfgJEdFXeDozMx3hNe7BpU7fWxXnrS/e0JtpbAtl?=
 =?us-ascii?Q?iYutUy4WlaDivEjQQYkhlwZrnMd1sDDp4ERBDwV5Dk/WaY7GyuD5R7u51S1w?=
 =?us-ascii?Q?PceYED1rubOKaVrmBY9z66qzZS3CrmGShWkRe8UpCSsQ3Xt68XSqxpI6az6s?=
 =?us-ascii?Q?jzCirvAJY8A01LFcgIpKEjvKfZuJtbFm9R2v3wu4si6VEm/mvgUN9LgJBFkc?=
 =?us-ascii?Q?jrexQRc+G2Yw4xMACUGTBUlmO75GoeGMWyXJ4ougHt7Xh39SW+G4MDn5FOpx?=
 =?us-ascii?Q?exyXSP8/oYgzZ0VWsKMvxmSLPxitOXqYV0XpXxp+Puyrcon2Q/UtF3jgP0Ep?=
 =?us-ascii?Q?VS17xonz/9Em9q0Orx5JTaPKdeZf569DltDYC2cBb5DEyMKf1Z+71KVvUEhE?=
 =?us-ascii?Q?d7uGM4xA5szfldjknkPiCgbQkT5wzHdBNw1DXR9jA7mAc0rJvGBs9eUD0Ufn?=
 =?us-ascii?Q?PnyVgynrbaMgK6GmN1qzHHefTKn7KAx7d/QAfdT1Zxg2moNn7p0CIbXsUUm8?=
 =?us-ascii?Q?ZTVGp16zTQRAfPI24l+VsONcV0F6deOSdX2FlrLNM90XV57nuoK5s31F88dX?=
 =?us-ascii?Q?rAl3r92ot4cN0UszDDpuWPuflWZ8101t4fgb+gF++GHGwaqntVPh1b0thMq0?=
 =?us-ascii?Q?HAtUHcrm1nIjOjKTl/8wnCtGFE9aJjhxVCB0wLka/XI66IAxFBouacPj3zDK?=
 =?us-ascii?Q?brk+hHmoReOlhl7gBvLCEQocmVksjQzhl7MRxmu0U10xFW8PySNpAy/foXT6?=
 =?us-ascii?Q?RVJeZ0QZiNmV+s/jS6k5tHogbXYXdHx0yRG5Q/c9z1YM9ja75BnIEnw+AAhr?=
 =?us-ascii?Q?tPHi9nERmVgzxe702Tyupf+VGGUxRTGkTTAm2bOGi0W5IPZ8vMiimJcueIn1?=
 =?us-ascii?Q?NPK6E4nyCu/RqWqMV+6C7DGAOu8sLxduNzZMFw7Q8d15CmRWtdJUgHt3zy+D?=
 =?us-ascii?Q?AYvojYteKK24cGY2sHzABogY2ie2Bdn9GJI554ukV/iDaX0m/FP4m1iUEAzj?=
 =?us-ascii?Q?Ms1zcwLnu0SbOHBhaC5uDeijgK/M962LI6+632GnaUt/oCuj2meipD8scVED?=
 =?us-ascii?Q?aENGCT4GI/PX3hBYVPrnknDQgJGwmavytdyXINdf0E+Q4JIbYa0RET4N4vGb?=
 =?us-ascii?Q?eClAaaRd64ruyvYJekQBXVc2y4VOZI4TdC3hqIkg1v1S6Cs0s8XYyZGCGHxt?=
 =?us-ascii?Q?fqTBmc5sFcp/AgMJCovSPECRXuBJLEVXRddg/XYYqGOSi+Kk4ozW9UvVKRFj?=
 =?us-ascii?Q?P803htDn24nIUyBn+aU7zGXKQ5JJ9WqDIiHiMEbjnzlI9Op8Y8uyndWa+o5+?=
 =?us-ascii?Q?d3itXtA+EUJl8Xw3Wyyu33QVtRdP5W2A0H+JNP6KSeI0WqJAIcC40iCwGTes?=
 =?us-ascii?Q?KbLI0v6cU/1CojwN395EsTOyrXLlcrZjBNottotTG0zwJ+QRJcZ873ofBnOR?=
 =?us-ascii?Q?a5MXUeolvFDoB7CzAoL1PXbRKYhGuy57I6cO3thbUkYHcyH7Ez2U8jpYMvw4?=
 =?us-ascii?Q?kHm6zrIhanTfGAmoqNKLFv4ht5EOiHBA4ZevP/BCr2bHlT1QcKQrsXhDNU0E?=
 =?us-ascii?Q?PLAT88FMTPH7iwWXh/rYP7RmDI0qdKb6Gp3yf4tENNq9EvsWNqmovz1fYgnk?=
 =?us-ascii?Q?Aj1+2fvoXQz9MFUfOau73c0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <63461C945CAB9D4F96AAF3D8F6B3D79C@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: GEW6cdkhqTyWfQVIn+SwwVEW7wWIOiR6QWrY6eY9q5tLxjviVoAZrDs4oF5p+WSZMkCckj7qk0u8YekEnRCuPfAAHcHD8uPe7ffYOHTKpTjIjBOolga37tgUIpmzz65Gt/Lg1YCLMovmdSD/24zZY8TJR9s0ZpEY3i9zk19QMoj40cTJOedM2EYZ5qUtFKIXjHQp1HLD4XVVTQgz3F0qdp6cwo/g6Slxbj+OlcajRkgdejWdxOJ9w9QOo9bW2YbilYhtv7580oJEuThN5bTXU1A7SvTekZ20y3xrnI/NKDYJpMdT5XRDQBxDUoERex2s/eG1zxOXb/HKE3HFtTR9i0eCYHcd2CjoO1UbeuYtI47IHTt+bmxKUj2ocUzCqt9dICz3FXq7dhi7BWz2Pcro+CHV6Zx0dQ4i2hQRfrijg7JkKcdr1Tu0Ur82FSscR/uMRldN6J0TqUHpGTjGjO5XqkS3ILCLfG8YABBfcPN30EwLQBBUF5ydL9icjtebE6ZxLhrYzN9OMMLtN1S9+PvnA4B0qdSPuInnve3Turlo8S3hfzEJEQT521fYBsbjSRJBxZDT8C9uZZw+0bI38DDVma1Cwu3ea6sUlJ8L2WEnOH34RbJIFpFNVrwd46VAocXUhous66Rtiy0iqG/H4WflzqIX1lkGWaKNMzV43lf5NolRc3RkWXXUgs2vlrzk+bfw2mXtwaGSnTcWOnPCvhLNmZkUdh/czJxWfLttO9My9Uu8Kxn/gXKbsVo5i5xCmxNBZTG4RM8F/uPEN45teM0NF/G6Q6dWexy76iTbI2DXE90=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb4e3201-f2f3-4040-c388-08db83d73231
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2023 19:27:28.6344
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xARQqwB7VXsxlcqJ0DP8EGBQ2sUqtXqfB+px5Z8fCPD1zmTRw3PXKr55XYRuDptt6F0iQQKOCmLsdgzkMR/O47GZekndrwS0WMSsvsGHruQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7193
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-13_08,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307130171
X-Proofpoint-GUID: -pF6qB919Ne033wHP0EKyyRnLKFFYAIw
X-Proofpoint-ORIG-GUID: -pF6qB919Ne033wHP0EKyyRnLKFFYAIw
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jul 12, 2023, at 2:05 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> Link up failure occurred where driver fail to see certain
> events from FW indicating link up (AEN 8011) and fabric login completion
> (AEN 8014). Without these 2 events driver would not proceed forward
> to scan the fabric. The cause of this is due to delay in the receive
> of interrupt for Mailbox 60 that cause qla to set the fw_started flag lat=
e.
> The late setting of this flag cause other interrupts to be dropped.
> These dropped interrupts happen to be the link up (AEN 8011) and
> fabric login completion (AEN 8014).
>=20
> Set fw_started flag early to prevent interrupts being dropped.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_init.c | 3 ++-
> drivers/scsi/qla2xxx/qla_isr.c  | 6 +++++-
> 2 files changed, 7 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index 3b32e65d6260..725806ca9572 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -4815,15 +4815,16 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
> if (ha->flags.edif_enabled)
> mid_init_cb->init_cb.frame_payload_size =3D cpu_to_le16(ELS_MAX_PAYLOAD);
>=20
> + QLA_FW_STARTED(ha);
> rval =3D qla2x00_init_firmware(vha, ha->init_cb_size);
> next_check:
> if (rval) {
> + QLA_FW_STOPPED(ha);
> ql_log(ql_log_fatal, vha, 0x00d2,
>    "Init Firmware **** FAILED ****.\n");
> } else {
> ql_dbg(ql_dbg_init, vha, 0x00d3,
>    "Init Firmware -- success.\n");
> - QLA_FW_STARTED(ha);
> vha->u_ql2xexchoffld =3D vha->u_ql2xiniexchg =3D 0;
> }
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index a07c010b0843..eb8480a0d7b0 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -1121,8 +1121,12 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct r=
sp_que *rsp, uint16_t *mb)
> unsigned long flags;
> fc_port_t *fcport =3D NULL;
>=20
> - if (!vha->hw->flags.fw_started)
> + if (!vha->hw->flags.fw_started) {
> + ql_log(ql_log_warn, vha, 0x50ff,
> +    "Dropping AEN - %04x %04x %04x %04x.\n",
> +    mb[0], mb[1], mb[2], mb[3]);
> return;
> + }
>=20
> /* Setup to process RIO completion. */
> handle_cnt =3D 0;
> --=20
> 2.23.1
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani Oracle Linux Engineering

