Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D78DC001B0
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Jul 2023 19:24:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbjGMTYt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Jul 2023 15:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbjGMTYr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Jul 2023 15:24:47 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 469882119
        for <linux-scsi@vger.kernel.org>; Thu, 13 Jul 2023 12:24:46 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36DIjjFo031821;
        Thu, 13 Jul 2023 19:24:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=Xe2ncSG+Q9O0gGKoXpxM4XvrSokNiEZQbyBsmWq1F4A=;
 b=xDKxKft9fCJuKQvWo2R3iWu7IVBPxCGz4tq2PbWM7YDIoTXET/4tUDkxImbajrjyyqEW
 cMWBTl4UOkqqwTWChYPRu140ciPG6jV1NXRAreQSS0ds4NcGQux6oLx6v31zYrJQgAJ1
 ralGQzSc7lQykxdnRHHLDkLOYY8ZALpR9EZzHhlLodBOG0HMruwPQOrEOt4a2gX1Nth5
 9vZ6xySLFNcmnKkevwbp71aw5OBZWFoAj9kYBy4pl0mTqZk960uNgWNWbwCzRJi3Fl6Q
 0IXke74+btB9g3Lb2pcoaWsgesZlXUYZikVScTl773dMcOZpy4w8/qXZp5RWfrooQH3b Uw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtptn02sy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 19:24:44 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36DIo361002517;
        Thu, 13 Jul 2023 19:24:43 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvw1amq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 19:24:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lo9pyZRPtPtVoabJyyAuJTh1U2dLBYiZ0j5ZuhhusrUyaP3HsFhAIiIF7POwaqrEwk9hR+dQmX2IkVQ8QOJJznCoVgyMXEEb7GjKujCegV8JHTQzAClew0tBQmStLFZy9AIT03M7hGzAmxXz5cwvmfE9Nqxay6W3U/jna/yykH0eU59ZW5uMeXsMooA+2SQ7ufrDzu/Q5U9xzcl6A5Dc13+nL5STxsnHPvgxASzRz9bz5F9CqMDc9tva2lIOE5EVfsUPYnFJJJiOVFTDQCo1uVbrNwF/OzUn7UoG32VDajqfvjlVPCptsGmlOjovVWKZgAdhJKpc3aRhh8r08lvQcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xe2ncSG+Q9O0gGKoXpxM4XvrSokNiEZQbyBsmWq1F4A=;
 b=gmYq25Nw4tu0BE5D0w895aFLuS+8BWR4NCST4ETm2OszCWyLnd1mcxKikChIzGExZmvS6NTe0ZlGlTho+wU82FqYR0Bz+J2rMX9IdVupeknc5OM8oS/tK1CXj33kowkCWtOqTcFx0r65LQNv/GB0fp5I1AaQf1CSIvbIiFgTrf8/I5w52RZQsSTfpgSW0cE/QFUih2KN8cGFvtH4HkKgRETHMbyAZ40FUnZeZewcIt1v7hE0LQLRgjqqpOW2m3C37sr4FD+VQr0hQfcNPMrEidCcQk5HpumzZegVOtLmX7NPlXW3wmBkBDCiNP8shNoY3q06Z4K+icPG4+ktDW8Alg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xe2ncSG+Q9O0gGKoXpxM4XvrSokNiEZQbyBsmWq1F4A=;
 b=BI8k4+NWKW1XRpwXAWWVjio/RAYDe+GAmJLaWrvdfNVkv3fTpT/w5A+F/lSknCYwQXX7VZoWVVBZhI06aJ0RF69w5MjcHQkfT/5Y3UOjDAZF2EZYhHYdf8G9Zbz/Z011zxJ1idUJlJkw2mTFNDbbIbzB10Kvj/Cp+ShDRUwftGg=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BN0PR10MB5047.namprd10.prod.outlook.com (2603:10b6:408:12a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.24; Thu, 13 Jul
 2023 19:24:40 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::2ab7:3a22:b4e3:93ef]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::2ab7:3a22:b4e3:93ef%4]) with mapi id 15.20.6588.022; Thu, 13 Jul 2023
 19:24:40 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        Anil Gurumurthy <agurumurthy@marvell.com>,
        "sdeodhar@marvell.com" <sdeodhar@marvell.com>
Subject: Re: [PATCH 04/10] qla2xxx: Fix command flush during TMF
Thread-Topic: [PATCH 04/10] qla2xxx: Fix command flush during TMF
Thread-Index: AQHZtKBQbHfnAOGnS06LgbQPq8I7p6+4FgkA
Date:   Thu, 13 Jul 2023 19:24:40 +0000
Message-ID: <9D452749-8998-40F5-8A34-6522AAE43560@oracle.com>
References: <20230712090535.34894-1-njavali@marvell.com>
 <20230712090535.34894-5-njavali@marvell.com>
In-Reply-To: <20230712090535.34894-5-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|BN0PR10MB5047:EE_
x-ms-office365-filtering-correlation-id: 2a1b42ad-e967-4a5a-4a95-08db83d6ce1a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Vg8A4lM2A3gNRyhHzZZ+DHcKQc66meo0gFuZaqPJrk901x7/mxj0qPl5sUAF5WuoPAmKXq7S8w5HnrU3glKQu3GTXwrv2ifjfo9J0FikXQ+S3v9jB2RFddGosGQLOL+bDTN1XtFKy4Pv0uAE81BV5fnEd6TmU6d56wGZ//c2Jj0iqtu3o6CVn/qkwEZWFJpSCtKmcltQTwo/IdeB6X7488FGXkTvFsPcTDR9gmB9Vibq54ldnZ7HQ7IAnckD9ITMvpV91WcXapFJ+zvfGHOGLcAa6tUYfFJGP09GxBFLbgKoMpaSeuEFWniDJcS8EtxEqx5u/oubXkebxAU482fcv1Sq92BfeW0EdJPtAgEquZ3kmnz+++8p1a8nkl8WE/IQLC9w/Pv0ME2mXaXNMs+i7VBDfTkaGx3y2ex83cpuAHTZWCL/wF3lzEwr48OgCYX/eym6XM56IV2KA5yAbWae9ZYGFg2wgPR1YP9Wwi/2yyp82BOgzsYHBO3UvX1MoTX5QyC2lHsus0uoaRkdM6CCScdfuntv72Y5vaSAEpGcJqgehlrIHKiHJXHnfE9Ei9cNGll7KkOYGq9HRXJu2Jed9w1m7aR6zBEr/SEkzv0zfXyRiiGvT/qRGlB9DnK8TrUi8evkIV/MmFLPJqAUI+yv6g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(39860400002)(396003)(366004)(346002)(451199021)(54906003)(316002)(71200400001)(91956017)(186003)(41300700001)(6916009)(4326008)(6512007)(478600001)(66946007)(76116006)(6486002)(64756008)(66556008)(66476007)(66446008)(8676002)(8936002)(53546011)(6506007)(86362001)(26005)(44832011)(5660300002)(33656002)(83380400001)(122000001)(38070700005)(2616005)(36756003)(2906002)(38100700002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ER1qp47bQD9DJlK/KaL3emSum2CP/WWoMcC+RWfCxWMJLH2KPYMnB2yxHn3H?=
 =?us-ascii?Q?vCAZ7PuRBV8hgp2R7YmEN7kI4GFLABMyGkUQ8j6jIV/BI1WFhckArEDBCgYi?=
 =?us-ascii?Q?cC/PYOVVqE3d6r859t6pe1MC1lEQBrQhm6X3HNaNqPB5yGg7q+MApkFPIIrT?=
 =?us-ascii?Q?IH4oszRUS4qckYAYsGBQnSDaZ7YizqDQF5jFLWJ3ODzUGR42S6vvQIzHvAd1?=
 =?us-ascii?Q?JunIf9R4zWeZCpg3d2auumavhCbWM62K9tItT/RVeodOvnuny67X6e329svk?=
 =?us-ascii?Q?7fqNIi6MHPUEiVyPgIkmyw5hc+5Ilbv8eOFr7H4L+xgZjLuqeF9fwE2i3Etf?=
 =?us-ascii?Q?3xqrzDq+oMVxs5zXESaW2HitnsCjs37giK/Zr2hg53vNPiYO7R+mz0/ewGCp?=
 =?us-ascii?Q?ITAIHtNV1BepbSK9yHE/Gz9jPKW4MSl5TLFTOTFBWqi+dcOGpqJN2ZhNIVJK?=
 =?us-ascii?Q?4F1lY6edVF751HM2HOitV5lsrhatZNmFIyl+vc/VbbjPDuNIm/pgM7weK0pR?=
 =?us-ascii?Q?J7Sv0ccZdiCmSm8rQqu8KI2Fw3b3WSxl/JrkLyZ544uNXYXQdmp1TyrVeXp+?=
 =?us-ascii?Q?3XjeT6VwxM6kf/cnQ2OIpIP6xEpnX1uDblUYGiVTsHdlBFgbX37J4EYNXhDZ?=
 =?us-ascii?Q?UTya3OeX8q4DA9BWbUPBnzGmeeHrv3N3dnbf/CjactQmVVwBfGf6FxjXDZlo?=
 =?us-ascii?Q?clm7XS2db/v1xx+rUPLEGrwm9JEwhjhPd9Y12d1vxNSywdCJ2hLBm+SIv02m?=
 =?us-ascii?Q?WZuv9v7i4ztD8nqRGdb00sV+v97ifDm6WrEUxgsRNiTvqUtbyW/28m5sdC0H?=
 =?us-ascii?Q?NiVHnuLs2Ns7426kiej5DCT2RVKPn7XxjB2V/rTeZkjuj5yEBMLL9g/tin5K?=
 =?us-ascii?Q?ASjs/8NgfQpMxEiUL/f3NQmbfSmQyQbAoA95YZb2GnGlvorfzfRLgYmt7Mec?=
 =?us-ascii?Q?LvcYv0far9ok3ceGP8NopsVqnYjLIZjnea+FYqIJWaz2UixVRl8BcXZlfkja?=
 =?us-ascii?Q?Tfs8mwl4TZsTXinQ4Euj7aR+o6xwL2qKECAhNxnLuNWDgrntbRt8xZuNEI4u?=
 =?us-ascii?Q?+lPeHZLwD1YtiKK/c7fs+Pen9++D7KfOJ2QJSifqK0avmk40Q9+1N1SUAJf6?=
 =?us-ascii?Q?rFewoDIP0igOAi0aDJVlTNSorQfFueKo0lGcUUiMbB/ai+9m2CBei1Bh/STN?=
 =?us-ascii?Q?EwG9PGDg66GLv4u6VsXeyAvmCjRuRqVnVfaycK0l49EaP9Q4TJXUB3/zWeCI?=
 =?us-ascii?Q?RX/s/Ok/EwuYwGlj42Njz9gib/OQPISi8v2ZTzHs4G2MKvudcCZ5sayxgxJB?=
 =?us-ascii?Q?nLjThjD7sY4UDRhp70HriMDI9y6dr+TwW/z/cXiFi2EIcp4w5Ub+o+ZgS8VG?=
 =?us-ascii?Q?XQWvYsSKU8BYjgOTacFY1CvRDqk+P1WWVR5W1TpmOWdd4yEoeo18HlnMzljJ?=
 =?us-ascii?Q?SQKvDGt67Q9oLYJ1c19QCnoC52TbVWBYVt8+I6xRvspL5mcC9+QMIlvJ9A7n?=
 =?us-ascii?Q?/TBYaN22q3K9tJ9U3FI2cpXLvsv72F2+TRrRpoB6KUQXdhRPdFiAJYU2ZgK4?=
 =?us-ascii?Q?oSNYoIrUDrk6xY3KVGUi48OPeW31cc9ksEllXkX3nMCaN18RWVD/DVL+KCQj?=
 =?us-ascii?Q?9uGTumzPZ3vNcPfG0KBgIVk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D2F342222FA3C042B332034E7609CBA7@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 0T5BSXdfwz0mhZcUFbNqOEWMfqdFJ6F69CQYA5/UFdrmOAQvclIM8G11Q4w9Ck1UFWakAAbK+bOjwjWWNhrfQi6wNgTPRFzyST1cSXCAzbsXl7QI1061eOKjPyFmCZg1cis3OhG2qJ2AGCDY/PZYSxAMySDlHXCs1cn3wsWctnhazDW03odFgEXCwZMlFo+Meupqp9tSJNNNODPvB6IRIyW5JMsDjj8zdwQL/m+DsF+8P8MKHzo58GdZ9tJv/equ28Z6/Nd+wl1smIf0S8/NfdaEDfnT4ZyBqqBOL8o226b42WT0SxGz75ujxfv/WhXsUt1QVgPu6k4qn+F26fsOWfs5P+DwrjBWaXiVJNMr9Q7P4sO2ieeZlepzwxtGVIDQuSb0x21Mbnogeuf3NUH2/aRf6zylHJ/KgA0v8dAVJV65QicD30M+XuAtv7zNE2FtXK6XNf0q9ULSONdBY6wMkWeVHuoPD5b8/6G8TgQ5qwKvwBM3RNxjzekqc/I1Nnm3es/NwZGIXo+ilFVAfZv4/1S24VYTri6eA/dQtN4PI/Hm/Zsftz1pUcd6uVwiDOC6a+Vq+aFB0j8+9CCDCb0bj+E/jSeU0rb7WPVwSLxvDjDOl7JmiEqqFvFdljAjbgp+BYxriQqTVlDFZWWw2NqIYo6TbCrUdM3cM1/T1IxKqEU8OTo1YLQJNQvh9xuiw2jhHAWRq5YAPxhmshUyXZppPm1OMUrDp7J3Re/ib1S84PA+yEmjmQdulNYTOIIoeCmeTVqJD0pgxfXqfxuL1MQOsHYtFlL+VVNeMBnSMxuneqQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a1b42ad-e967-4a5a-4a95-08db83d6ce1a
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2023 19:24:40.6837
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: shaefkGdJyp9M8fiA8FN7NjMYUcKQSn5v1t16cPrECMic6ubFinKOblnw+dqnXZgVY+LigZ525EUy/zUlljWAs2mOrkvWaAJ6+0sdrKyJzk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5047
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-13_08,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307130171
X-Proofpoint-ORIG-GUID: 2Pcxr-QxKDHRlpLwvn5eQAhGJU0PfdBz
X-Proofpoint-GUID: 2Pcxr-QxKDHRlpLwvn5eQAhGJU0PfdBz
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jul 12, 2023, at 2:05 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> For each TMF request, driver iterate through each qpair and flush
> commands associated to the TMF. At the end of the qpair flush, a
> Marker is used to complete the flush transaction. This process
> was repeated for each qpair. The multiple flush and marker for this
> TMF request seems to cause confusion for FW.
>=20
> Instead, 1 flush is send to FW. Driver would wait for FW to go through
> all the IO's on each qpair to be read then return. Driver then close out
> the transaction with a Marker.
>=20
> Cc: stable@vger.kernel.org
> Fixes: d90171dd0da5 ("scsi: qla2xxx: Multi-que support for TMF")
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_init.c | 74 +++++++++++++++++----------------
> drivers/scsi/qla2xxx/qla_iocb.c |  1 +
> drivers/scsi/qla2xxx/qla_os.c   |  9 ++--
> 3 files changed, 45 insertions(+), 39 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index 5ec6f01ca635..3b32e65d6260 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -2002,12 +2002,11 @@ qla2x00_tmf_iocb_timeout(void *data)
> int rc, h;
> unsigned long flags;
>=20
> - if (sp->type =3D=3D SRB_MARKER) {
> - complete(&tmf->u.tmf.comp);
> - return;
> - }
> + if (sp->type =3D=3D SRB_MARKER)
> + rc =3D QLA_FUNCTION_FAILED;
> + else
> + rc =3D qla24xx_async_abort_cmd(sp, false);
>=20
> - rc =3D qla24xx_async_abort_cmd(sp, false);
> if (rc) {
> spin_lock_irqsave(sp->qpair->qp_lock_ptr, flags);
> for (h =3D 1; h < sp->qpair->req->num_outstanding_cmds; h++) {
> @@ -2129,6 +2128,17 @@ static void qla2x00_tmf_sp_done(srb_t *sp, int res=
)
> complete(&tmf->u.tmf.comp);
> }
>=20
> +static int qla_tmf_wait(struct tmf_arg *arg)
> +{
> + /* there are only 2 types of error handling that reaches here, lun or t=
arget reset */
> + if (arg->flags & (TCF_LUN_RESET | TCF_ABORT_TASK_SET | TCF_CLEAR_TASK_S=
ET))
> + return qla2x00_eh_wait_for_pending_commands(arg->vha,
> +    arg->fcport->d_id.b24, arg->lun, WAIT_LUN);
> + else
> + return qla2x00_eh_wait_for_pending_commands(arg->vha,
> +    arg->fcport->d_id.b24, arg->lun, WAIT_TARGET);
> +}
> +
> static int
> __qla2x00_async_tm_cmd(struct tmf_arg *arg)
> {
> @@ -2136,8 +2146,9 @@ __qla2x00_async_tm_cmd(struct tmf_arg *arg)
> struct srb_iocb *tm_iocb;
> srb_t *sp;
> int rval =3D QLA_FUNCTION_FAILED;
> -
> fc_port_t *fcport =3D arg->fcport;
> + u32 chip_gen, login_gen;
> + u64 jif;
>=20
> if (TMF_NOT_READY(arg->fcport)) {
> ql_dbg(ql_dbg_taskm, vha, 0x8032,
> @@ -2182,8 +2193,27 @@ __qla2x00_async_tm_cmd(struct tmf_arg *arg)
>    "TM IOCB failed (%x).\n", rval);
> }
>=20
> - if (!test_bit(UNLOADING, &vha->dpc_flags) && !IS_QLAFX00(vha->hw))
> - rval =3D qla26xx_marker(arg);
> + if (!test_bit(UNLOADING, &vha->dpc_flags) && !IS_QLAFX00(vha->hw)) {
> + chip_gen =3D vha->hw->chip_reset;
> + login_gen =3D fcport->login_gen;
> +
> + jif =3D jiffies;
> + if (qla_tmf_wait(arg)) {
> + ql_log(ql_log_info, vha, 0x803e,
> +       "Waited %u ms Nexus=3D%ld:%06x:%llu.\n",
> +       jiffies_to_msecs(jiffies - jif), vha->host_no,
> +       fcport->d_id.b24, arg->lun);
> + }
> +
> + if (chip_gen =3D=3D vha->hw->chip_reset && login_gen =3D=3D fcport->log=
in_gen) {
> + rval =3D qla26xx_marker(arg);
> + } else {
> + ql_log(ql_log_info, vha, 0x803e,
> +       "Skip Marker due to disruption. Nexus=3D%ld:%06x:%llu.\n",
> +       vha->host_no, fcport->d_id.b24, arg->lun);
> + rval =3D QLA_FUNCTION_FAILED;
> + }
> + }
>=20
> done_free_sp:
> /* ref: INIT */
> @@ -2261,9 +2291,8 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t fl=
ags, uint64_t lun,
>     uint32_t tag)
> {
> struct scsi_qla_host *vha =3D fcport->vha;
> - struct qla_qpair *qpair;
> struct tmf_arg a;
> - int i, rval =3D QLA_SUCCESS;
> + int rval =3D QLA_SUCCESS;
>=20
> if (TMF_NOT_READY(fcport))
> return QLA_SUSPENDED;
> @@ -2283,34 +2312,9 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t f=
lags, uint64_t lun,
> if (qla_get_tmf(&a))
> return QLA_FUNCTION_FAILED;
>=20
> - if (vha->hw->mqenable) {
> - for (i =3D 0; i < vha->hw->num_qpairs; i++) {
> - qpair =3D vha->hw->queue_pair_map[i];
> - if (!qpair)
> - continue;
> -
> - if (TMF_NOT_READY(fcport)) {
> - ql_log(ql_log_warn, vha, 0x8026,
> -    "Unable to send TM due to disruption.\n");
> - rval =3D QLA_SUSPENDED;
> - break;
> - }
> -
> - a.qpair =3D qpair;
> - a.flags =3D flags|TCF_NOTMCMD_TO_TARGET;
> - rval =3D __qla2x00_async_tm_cmd(&a);
> - if (rval)
> - break;
> - }
> - }
> -
> - if (rval)
> - goto bailout;
> -
> a.qpair =3D vha->hw->base_qpair;
> rval =3D __qla2x00_async_tm_cmd(&a);
>=20
> -bailout:
> qla_put_tmf(&a);
> return rval;
> }
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_i=
ocb.c
> index a1675f056a5c..1c6e300ed3ab 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -3881,6 +3881,7 @@ qla_marker_iocb(srb_t *sp, struct mrk_entry_24xx *m=
rk)
> {
> mrk->entry_type =3D MARKER_TYPE;
> mrk->modifier =3D sp->u.iocb_cmd.u.tmf.modifier;
> + mrk->handle =3D make_handle(sp->qpair->req->id, sp->handle);
> if (sp->u.iocb_cmd.u.tmf.modifier !=3D MK_SYNC_ALL) {
> mrk->nport_handle =3D cpu_to_le16(sp->u.iocb_cmd.u.tmf.loop_id);
> int_to_scsilun(sp->u.iocb_cmd.u.tmf.lun, (struct scsi_lun *)&mrk->lun);
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index 47bbc8b321f8..03bc3a0b45b6 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -1488,8 +1488,9 @@ qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
> goto eh_reset_failed;
> }
> err =3D 3;
> - if (qla2x00_eh_wait_for_pending_commands(vha, sdev->id,
> -    sdev->lun, WAIT_LUN) !=3D QLA_SUCCESS) {
> + if (qla2x00_eh_wait_for_pending_commands(vha, fcport->d_id.b24,
> + cmd->device->lun,
> + WAIT_LUN) !=3D QLA_SUCCESS) {
> ql_log(ql_log_warn, vha, 0x800d,
>    "wait for pending cmds failed for cmd=3D%p.\n", cmd);
> goto eh_reset_failed;
> @@ -1555,8 +1556,8 @@ qla2xxx_eh_target_reset(struct scsi_cmnd *cmd)
> goto eh_reset_failed;
> }
> err =3D 3;
> - if (qla2x00_eh_wait_for_pending_commands(vha, sdev->id,
> -    0, WAIT_TARGET) !=3D QLA_SUCCESS) {
> + if (qla2x00_eh_wait_for_pending_commands(vha, fcport->d_id.b24, 0,
> + WAIT_TARGET) !=3D QLA_SUCCESS) {
> ql_log(ql_log_warn, vha, 0x800d,
>    "wait for pending cmds failed for cmd=3D%p.\n", cmd);
> goto eh_reset_failed;
> --=20
> 2.23.1
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani Oracle Linux Engineering

