Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3D82C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 03:55:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAF41613D0
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 03:55:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244084AbhI2D5Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 23:57:25 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:15756 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243788AbhI2D5Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Sep 2021 23:57:24 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T3GOq0017406;
        Wed, 29 Sep 2021 03:55:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=HbIeZ/xYQt61oGhJvf1uMq/PtiB191to+flcfXCZvBQ=;
 b=vZ4SCb/Ud83teTkh6vu2Kuyv2c4FPq7so4XEGF+bjTIaPcnUvS1V9UNVTYlLpv/OcgKc
 KTILbDk+lc22wk2U+7flQ51YjVfzwwcPLjb0k4N3xkAR1ssV7God6+4SiYi5Mb/jhWIk
 54ALxTD8okTfY0RgZNBTuzRQm6O2+5klWu09gM38T+LooLa8YmxFAMVIofPZWkD0u6CG
 aesu+NxtUetSLQeQmeW9oiCBqd9OEQvSnuy6llp5ee4f/O6FUNhWDFlEFfXbijavGZvh
 +IGBs6g5Dakwk+/HcCM+Us6gjwyJLDjtleAP5wg5Qr9uxVwsfU9HiioLCj5uTURsX07K AA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bcg3hg3s0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 03:55:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18T3oRsB150645;
        Wed, 29 Sep 2021 03:55:41 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by userp3030.oracle.com with ESMTP id 3bc3bjafpa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 03:55:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CzpaUBIc3cSD0Eg5MnhuFavPjJ+wsFih759NR6prmOUjRkemUuQV6GCdxNP0GXLYyMS+vKnz2N+K3QE/NBBmtnGtZI/lgBTWBFWJD4QLE0/ZRtWSu2qq3HRgY/+vLE7LeMdZczcopUb5r/LupDFu5oYm5Z9iCPyQSQiifaQ5dwZjlzrvTRTkS3DkDBwQxkoAFsmfEc22DQ55cp6nobU2Jh/i4y54Euqu23GnhRZ8/zkEXiQIgclRBfig1SdThfElGWnaQfXuTTaFya1DIUgNU3PU97uxDxrIasiwVVy/D75HLAh76kIa6tvj/Yub6v4dr4OdV2CA4EwH3zjBYCN2XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=HbIeZ/xYQt61oGhJvf1uMq/PtiB191to+flcfXCZvBQ=;
 b=ZASEvulzNA8zdEwwHDy52EGEnwawTbqbYOTugMQdGKupDME1gU3QrlYIubmYsMSFzNoMNJ3x+yfTYrbHXz0e7+Xnq4rdMzaAeC0x8rGKv4PCamwTHiMhUBZvU4yfJeQaqT+/80V1wB9SGu9DUy5Xqs6Mi7vL/MfwbFHl05W1Pu3YC38VEpdpZdtFF1eNZwVoJ+p7JzsXUEhzIdCsILTGLBVuF+9UMDICb6yz/heSIuxdZHcf75YeI9JNru/MbR3V5PrMOmO51ijZmwrZPWlSplVTCf5FDKj6sgLVJpSLDC9Sayo0S8Bb5IGP6IQwB6werNgEJAGDwe1FT6XnGgZ76g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HbIeZ/xYQt61oGhJvf1uMq/PtiB191to+flcfXCZvBQ=;
 b=PgXZ3adLabojjN293eG/7fxrmAWfawCJV23IZ6dofQZ4fBrRf3FK+qx3aDwHo3t9k/Z72Dam8TkkPXT91W0SZQ7oMsDvMNoZNiS+0ycWCTBcR1/xwACByTJlvWTnKSK3mI2amt7HEZ0H0qUediRGriE5QE3SbWRJHKkzWPnKh48=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4744.namprd10.prod.outlook.com (2603:10b6:510:3c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 29 Sep
 2021 03:55:40 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%8]) with mapi id 15.20.4566.014; Wed, 29 Sep 2021
 03:55:40 +0000
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v8 0/5] Initial support for multi-actuator HDDs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r1d8dom3.fsf@ca-mkp.ca.oracle.com>
References: <20210909023545.1101672-1-damien.lemoal@wdc.com>
Date:   Tue, 28 Sep 2021 23:55:37 -0400
In-Reply-To: <20210909023545.1101672-1-damien.lemoal@wdc.com> (Damien Le
        Moal's message of "Thu, 9 Sep 2021 11:35:40 +0900")
Content-Type: text/plain
X-ClientProxiedBy: SN6PR16CA0060.namprd16.prod.outlook.com
 (2603:10b6:805:ca::37) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.46) by SN6PR16CA0060.namprd16.prod.outlook.com (2603:10b6:805:ca::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Wed, 29 Sep 2021 03:55:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b844b520-ad3a-4b4e-1c4f-08d982fd009a
X-MS-TrafficTypeDiagnostic: PH0PR10MB4744:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47443404E5B5E4F6AF1E0AE68EA99@PH0PR10MB4744.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KKOSv1rbGSMrexSeb4r0iRSaYZoWp+IpfBjfg4+3aJCKFqiafOXPBeAcmcqT9V9kYdPn3yBL2R36/JIA32ISMDl2D43gAbJYGYR3N8rC+ZxGT14G2wqliDuSLHYhpD+e5iL0fafww2GCy9B1G2DV77oYu+30yJPIEgNAEKI/QkDakcvmOinRcp9GJhXdwjUp3wCh81hJRxNfprMr0LX8xjDDspzOa2LWv0jCM02ps1WYLtDKGS/D337huz6gMiSIX/xUO/wT3pPYJGKKtIo1/3mhSIiwQgahzFjKxMJOVFt60upngaFM3cJ+f4kBUz4B7E7KPfQesaLhNsnZoVzbeirz3FRHHaZRwDg++UtwtTOvSt9Sfk6iIUk9/OfKbNx9SeVvGIxXqd0JJ2U9ekhiZ0/4MA6hKnmZO1pBrYlnDwNKs4mVO29HUIQlzPiTv7WNFWkwhhy2GlFFVFHqPsJAhFqBtG/+f6pNG04Fy22h5bdXWF6Be37Pp5wl0bVLpFPS8TXJKAerJmybmM5UH48+OA3IUg2V+29YZpb6v8wLdRx83j60vZ8bb39eQlLV3uayVQ35KMDTBvcUTlidC2JT05UE3MDkY6mLDnXc//bOKO/P22Mxf2T6JbBdUPv9Md1UXiOjq9b7/SJrb3FPenQRxXNJ39GOKqsHcBBkJccE8fZnneErRv77XR+tHhUxn8dtl/wg4eDrIfDKPLfWrgJFCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4744005)(4326008)(66476007)(66556008)(8936002)(55016002)(8676002)(508600001)(66946007)(5660300002)(956004)(186003)(86362001)(26005)(83380400001)(6916009)(36916002)(7696005)(52116002)(54906003)(38350700002)(38100700002)(2906002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ChNb5YMrS7y4Fdou+IoupN9J1rYkUAIJPlQvNFewff320pIC+TNqOd+A07Nm?=
 =?us-ascii?Q?UytwpRvCw5wAKCQZVSUqGYJKPPvReoF7x/lo/aNj/+MLGrzKc7WEu03P0d4E?=
 =?us-ascii?Q?Wx1A67moSGlAY+P2cdBnvvDlHsmj4gkmjrzUNvQrNcEbaDwVzrUYGGbu7E/C?=
 =?us-ascii?Q?bTcZAU01o4F3cuIlS1sIUkk3fzSa5bRCOavOlEpvB/CU0Qb5Fft8zCVpd9Iz?=
 =?us-ascii?Q?TQLUqUJGaI9Iiof9zsd4ZYg2Wm2qQ3Ey73/IgzUWg31WcuzIzeO43LbedOtV?=
 =?us-ascii?Q?7x3ye1lx5HQ84hQ/nErKmkgBucHzcgGIeCOs79xkwTtossHD1IePp+ZeHvH6?=
 =?us-ascii?Q?oRnsZQ0RH5oFGVD1vDYXa5mTXU5s0/DMwx8V+wI0Yq1EMvq9WON/JMq1nyxh?=
 =?us-ascii?Q?s/QduZ7MX3MOgFh1tgwqZ8wt8r7kZM9E3wBlZ8wBkYcXrfkzL8H94SlZ1fVG?=
 =?us-ascii?Q?cFBpW2fBBi5dM6YxufF6vRgrZ6Fex90krNULv5Rx9PJd+dI1Wje78xesUun8?=
 =?us-ascii?Q?5b7mB3gb/NO6nSBeuJOX5gNEBp+buERWl9sQJjhlOOhB2GnK7Xb0ettiiqn4?=
 =?us-ascii?Q?lGPe7mFnLNtFgbMTYotuz29Aq9PtvE9gwrBiuWtsg+B1pTLgdCyRPBgSy+bz?=
 =?us-ascii?Q?6MBlCdtpqcBMk+v0f1Bd3FP5eUE2rHZooFDPpchgNVhgW6jir1lilxAfqlD+?=
 =?us-ascii?Q?4KfyGQCf+h3HppbYW9QuZEdD4fgehJcW+o+8euHmbGiIDKxN9faFRP4dre1/?=
 =?us-ascii?Q?7eUrR8FLirj8qfcQiEcFfcyeolHBsVd8JLp7BGt1JkhWdOAjqI0ON8sStlxc?=
 =?us-ascii?Q?YkwU/88Xa/OueG63yre/jTt+UZhmaz7BLXTqGUQZjeIHz8gNnDSolBbZLUU4?=
 =?us-ascii?Q?EuBNmQr2IRlBuZKzxgQvK5eRnB84PxXwXAqYfvHqLQpYZAmMenmG9S7iiT0C?=
 =?us-ascii?Q?SCt/KntbyS8NEEe4phL7MFVGOkWkTBZcSeD/UWWalof9WwVSKD2muz0bR5Kw?=
 =?us-ascii?Q?VgjFAbxsefF+NUYEKEJAxzClYmPwAaHgF8PyhpocS/hXqnOKlgnQ9j+3JG1b?=
 =?us-ascii?Q?up+wk9y1xDThf9OCNQVRh3n2jpwXJtZW8VwjA9aKBWodjsC0dTVlXoVHeQ+5?=
 =?us-ascii?Q?U3F2G3tRNn61U3CJ1HDHAUpA9FgTfJnvlQU2ZbcY4MVZj0l+evNI56s+4YSP?=
 =?us-ascii?Q?29TRsQNUOHhdkHY+0wlol1v2E7cyzOJ3Cg5ohTfqE6ewx8ikWBUCEKSKxu0z?=
 =?us-ascii?Q?UrP8ajYOJq8bpu9Yi03XQ25LE/FCmw8/+1OjqBiEKNEYpsrrnLryo4CVcupF?=
 =?us-ascii?Q?sF447xA33EXNGYYMZzNhxWu2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b844b520-ad3a-4b4e-1c4f-08d982fd009a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 03:55:39.8958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e2aYTTteKNmh9D+kSe+yzWMEM8tMVrofqLRZn7PTtNLgHeGx9mOIhj8C4qTmWz/gimvOz1QFGhvpFKJIKGM1R/Wr9LcUZN9p58Fe578kTxI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4744
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10121 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109290022
X-Proofpoint-GUID: mcNrgKR5-npU1tVTfXKu6Ph8ObQm6C5o
X-Proofpoint-ORIG-GUID: mcNrgKR5-npU1tVTfXKu6Ph8ObQm6C5o
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> Changes from v7:
> * Renamed functions to spell out "independent_access_range" instead of
>   using contracted names such as iaranges. Structure fields names are
>   changed to ia_ranges from iaranges.
> * Added reviewed-by tags in patch 4 and 5

The new name is long but it makes the code much easier to follow. So I
guess I am OK with this version.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
