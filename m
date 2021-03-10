Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 414B3C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 04:33:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0015A64E6C
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 04:33:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbhCJEdB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Mar 2021 23:33:01 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:44276 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbhCJEc4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2021 23:32:56 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12A4PdXF100731;
        Wed, 10 Mar 2021 04:32:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=GWCA0ut5fcHQIEfYbhA5QV7p48kMbwGKWUvhAQAdDjM=;
 b=s1KZTBsIZW6m9f3z7mHpg8WQhsCfAvFb8FgRwcckDXwhn1DKm+IONzFRdb6i/+rU2+/L
 Wm2x6dh+oPAHD+LfVfosTW0r6qm5BGScpZ1gYt7Zb5vk0pnatgLSmKSKDNpvgluwMc66
 HIIHwkNU3Lf+G5Iuvy56MPV37U0BBRObklhxGXPO17M2roRRCococczlAO8d4PnwKunn
 6T7+8Oz2/F0ifuYja/sDyRn5GOutzEjnupht1JUVatpXR63fFFtc0vNJ34Gx9Sbs+Ykv
 0T4nG192b/cf/EfbmMl1ZGTPfJ1Hx1NXYoRhnh1LijlmGlVkukQK+YlC9LKKiK7oFU2y zw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 373y8bsry5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 04:32:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12A4PQTx010193;
        Wed, 10 Mar 2021 04:32:47 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by aserp3030.oracle.com with ESMTP id 374kapndta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 04:32:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g/6Ilmw+7C0hnK7FKQcd49Qe36o6K+Qw+Sk0r3TMfEMUWa1usIYnIGa/vPHA/Q/s9/BY1ExZw77VU6siQPHOKUzSoO2LCFTDmr1COgfDkSxrfCNi4Be6fe0aiWy9GMdz+q1PYx0jJPJRRUBqIoEjUTYc6GCUZ9uVLJLIrZG8e64YACObnDR3A7vZEmGduEi67COo56yHXtpMPLXsqA2tDvWutPIdwbaX2BnDsI4Ji+nobdU+1xGCzkcmR0YTC4XaRiveJbGAsl/Lqv94CBeppezx9f8U3+bpg1SZJIKjWF4/rQ8LQovf3RgeojlnvlBjhk/B84Ai5Smsl7aGfSP1KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GWCA0ut5fcHQIEfYbhA5QV7p48kMbwGKWUvhAQAdDjM=;
 b=DOtsR4uy9EJj1qeoAoupcnHV7kHmSweUVtYja9CdOnK3PUQz0nHc4IrnRipHCSOtLbNLN8XJEcfBpZDtLN+8f9mFJn75XqHuzL17lBwra9o0owtvX2pI6RxB7DKrgpydR3r1mDZ6xAfkJ6uCD7zgm1FxTpT4GgUTS/s3/+kQzc4NTKJ4bpWbWNWSWvdXgoVpRDttfUIfOd1q/0MI6isCz/BsIF+JOwhKstwH+MRK8yr+f16s8gQm5s3dMsMbae1n6gsteBNpZUzWP1SLjjTtYcDEchaV6aZUD/KafnrlZYSjlOTylw6zT4ufhSchzLz9KktV3VqnSQCSdZ0QRvjf+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GWCA0ut5fcHQIEfYbhA5QV7p48kMbwGKWUvhAQAdDjM=;
 b=rnTr4zhvXwB8MpqSt548tQzu7eZT+heE2te4pFaNPEQGNk+rBnt7Pl26AEqDb1mVoT+c5FYwnPinoBKwqC+YojXy4RyPoWWnn1Cg/fPuaoABISK0BFKanXoYizZVrgUscGy1JPkOfs1ar+B1zXNsUOAXxn96/ZaVI7d1EnBcW90=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4726.namprd10.prod.outlook.com (2603:10b6:510:3d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.19; Wed, 10 Mar
 2021 04:32:45 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3912.029; Wed, 10 Mar 2021
 04:32:45 +0000
To:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        bvanassche@acm.org, houpu@bytedance.com
Subject: Re: [PATCH 00/23] target: code cleanup
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1zgzbaatp.fsf@ca-mkp.ca.oracle.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
Date:   Tue, 09 Mar 2021 23:32:42 -0500
In-Reply-To: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com> (Chaitanya
        Kulkarni's message of "Sat, 27 Feb 2021 21:56:22 -0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR05CA0131.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR05CA0131.namprd05.prod.outlook.com (2603:10b6:a03:33d::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.23 via Frontend Transport; Wed, 10 Mar 2021 04:32:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85949f3c-481c-4859-ed86-08d8e37d8ce9
X-MS-TrafficTypeDiagnostic: PH0PR10MB4726:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB472656D985565FCA0195DB4E8E919@PH0PR10MB4726.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R8tJTk5oJgiJBDmbjuf91xoHzWbZXdHC871RXU4l5viulOLoqPEEvLD+/ad3BrluGE7ik8h7c8LUr/udKiWdwUV3v8GcD+o5FKAJ0vB0o2YRF9NpMXCZdR++1c5HXSsI3nJtpIQWmyFlrCgkzwqTz1Y17aixuYordsWdRSkqkuhv81ySxsU1e947HZ2LVFxOuJU431EzFKDzewy48J3/faenc6PRSSihcmg3aq/kvtDOskQuIemNHzWqk74IQotWxzhaiJ3xy3vQunozZL4JoPlAgoh+6eKxyDsJqqABOxdmBIo2pYIZHruz9hHnsTl56o4h4mjE1PCCrEcdkyRQspUmN2PxCHUHarFc9rN5HbNXiO1PJj5UZBofP0Sugw0DCkMK3nzYWbQ17J3y8wAQKbzXpI36nlFfNGJSU5z4bMpBU//RhpjucoCRUraFWm84V7J/xb5BbIsbX0KgzKEkSMCF9po/MGHNo6/f3KwVdBqbo3fZQJzwc7RCVszLYwQkXJqE64ArkMXiDAl478or7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(39860400002)(396003)(136003)(558084003)(26005)(316002)(478600001)(5660300002)(8936002)(66476007)(83380400001)(186003)(6916009)(8676002)(2906002)(956004)(55016002)(66946007)(86362001)(16526019)(7696005)(4326008)(36916002)(52116002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?eglHI2e6mzznbWOXBdFWAGQonkqH0L/UW2ix4E7FymLrA31IVSDgWcJmZ5+8?=
 =?us-ascii?Q?H09Xh00FQB8RfFNzg4AC3ievYX7wQ4S4M5ZGmgie2tfq2vw157MgDFZu03WO?=
 =?us-ascii?Q?j9lUCms+USPnX/zJ4YySsQBPv99RLLoG7SaTH0y/jz4SIiPTPsY6SnRh9Gad?=
 =?us-ascii?Q?6jFrZbZ+ot6nDIHAbmPPqvTwV8XmM/2ExYan8+svG1JW9+dVWnX5nPXCTCe1?=
 =?us-ascii?Q?sWyJ10oM6qYoAn1FSN1II/TvdjA3CR7V3dKUKuYzOQ7IOdYbSkX3N/RWMm35?=
 =?us-ascii?Q?5M4MzgTqikVDvC+hSoaSCtZ/D+FENeovYd25wTBtShtCQyAoPeodflCikk7P?=
 =?us-ascii?Q?aBSdHChRc5Uip5DoRj4i7Fvtb5k8T9QH4XhoQQL1eBA8YQt9fm1asBLwoFYA?=
 =?us-ascii?Q?/g1JWdHOSghAjr0649fMc6lAVhX+uXxAJ2+prHFeQZsq8kc+pQx4p6vNlFHD?=
 =?us-ascii?Q?GcRvxf6bsYkmbmrOl3Is8VI/gZ0IXJ+74tvI5oQoqSsSNnbt84WdYB5aiiZW?=
 =?us-ascii?Q?gUbp98XphWsDPxY2djBRgZxnoycsb9V71Yb8mwHZt6ZX3QTtX4vaxSk1eVzU?=
 =?us-ascii?Q?F6wuhH9u2nPRYTI/2JAJc/DM/qsmVJIPTQjGlhKVW8TEZYPmMhXaytvFfaIc?=
 =?us-ascii?Q?gsFyYqtWtQnRQlChpUmTaHxNQ18AkHeDhV9FMEe4CWMLDmEOLR6k45hvyjQI?=
 =?us-ascii?Q?EvTkbopZuVOH26aqe64UQet822ygyR5gcREh4Dw/VVa5uE343JIUD77ttJXQ?=
 =?us-ascii?Q?WMWjeqFuMUqGymg6B06eAb6zv/1MDfcJ8ZbleJYxbRm5v0FaOyCXU4XjvAD4?=
 =?us-ascii?Q?31USVv9cCBBgaSxV1uwgc65zwMcy43xAOfepPYBxKQThb6tLlKPAd25pTYgm?=
 =?us-ascii?Q?4vAyWtOgTnltEb++tw7+Bg4MH5+rm6XW68scTSVBtgobrKFaYoSH2e78bHTT?=
 =?us-ascii?Q?+aKcAQCiphMGDry0cUym/tjimvRpXAwf1yFZ7jApEgTpA4wE50GiS4mSxLsi?=
 =?us-ascii?Q?JRWhgKpIGcfGilZrnVq8e29IvIEqhHsgXE/59P0UpR2qkSqT5gRjh4SWTJw/?=
 =?us-ascii?Q?HIYFDIHOJykW+3qRtPMP3fi1t/ygt9JvsCOnfNKnVw4RRgXVWxffL7bHe9Ys?=
 =?us-ascii?Q?ILtlh2nKtso1YdRnxho7cue8sduXTzOBJAjMznsfm2oLpgojuuBmCOZWltYZ?=
 =?us-ascii?Q?LCYAT4kzCd8sIctcY/YCe5m6qGzcXVhTPj8zgROB5kcgDE2JI0U3brKlnng+?=
 =?us-ascii?Q?zV7jlbRNJ544sFBUyZO/LEO36+vKRYCngpmzDKq5ylheMfe3Sz/d8O3Li0Td?=
 =?us-ascii?Q?FHyemUhy4sSfYStO+8Fy1+BB?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85949f3c-481c-4859-ed86-08d8e37d8ce9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 04:32:44.9335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wSAXx2eOvoUpBm7/c1hflghMdIC5o9Rwo95OeDCYxWXd9W4ILN3HbXzEcXoF2eCNTV/7dtG8UyA5R8YwioE35x6WVUYzRLvAixnHV6Is/C0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4726
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9918 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=879 suspectscore=0
 spamscore=0 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103100020
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9918 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 mlxscore=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103100020
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Chaitanya,

> This removes unused macros, various memset, extra variable in the
> target/iblock for bio get and fixes type mismatch for the same.

Applied to 5.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
