Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 408F4C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Jan 2022 05:24:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234728AbiAEFYS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Jan 2022 00:24:18 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:64818 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232056AbiAEFYQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jan 2022 00:24:16 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 204Ni991025076;
        Wed, 5 Jan 2022 05:24:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=PCm9QCi5sVguod6MJDO37LK+X7u7G+fF7hoqlMdm+fE=;
 b=dOi7VQurmelDnhd9voLjpkA6v1uIGfl5cvvrYlzS24vexpKZAmcXAoUXVNdVDlR3zvis
 hoDYixB7c8qzEsHS9jDutrWSVEZwVO4rZ9fdDSpibXJC274IMX9XV2Kr8XV37zxIHLrm
 2qGtbt/BwcNNpkGHL8q8DtYudfWLHr976Szby6hrf3klmirFG4ZC3yz0ufECgIS43YmB
 vN5nZUErTlaGeeMAudfsFyBRLrSQ854NkTlV92xOTAou/Z7Tollvt4wCafp9+iaqKnJq
 uIqRfp5HzxHg7awYKLSJDowfZtRyKRayE1u9+ZoJJmS+XKXJMle9+vrp8yMhX/VqKv+V 8Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dc43gbxcp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jan 2022 05:24:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2055Bn1l121550;
        Wed, 5 Jan 2022 05:24:08 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by userp3030.oracle.com with ESMTP id 3dac2xpt25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jan 2022 05:24:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ni3vuhc4sEtf831M50e7mzUixWw0/o0NhOt1yCUmZ8uFA/KAErviZFIA1BPcdDQHdhLqPEL2Y0poIzK2+uXtd+Y8uewp89/4Xf3a5Y0/Xa5MNhYg6LrsLICkbqQLaYdPSuA35fM83VODfwRyujB1KK//dc5dyev7QQ2tq0EdGXZqz4pkPU2/yDIG24IVdkfB703wubaI8swql/hkscPWXx2vNc6QFs5oiQPdPWaOHrqdL1X9bAL0Bf0CBrbwjLkTXHImm3R9fS78Qt7oMZ9RG3JLlwYG9pQ1GKXam3sKfV8o8HlrflBgq6GFt3qq5NbjWz+4SDcDwAgNfJuWJoBvBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PCm9QCi5sVguod6MJDO37LK+X7u7G+fF7hoqlMdm+fE=;
 b=HOm6N2X43lK46CCT4YlXqXd7RYS3hiPdbmcv9rkCpVYTAAvOcKRs6b3+kpw49wpHFKj2bdwdoT722F015n7C/mh3ZShvurg8eh6qVkfoqJeLEOFPtN+xbyD6eCwL3Sad5J9gFow0am0a8cTytjbXKuot0zQOD0wbE1BBrbAp1vJ7cu7S/+p4FNnlIe3FneCDWyJZfx1wDyjF+PoyhLBJWScXG9BgCWuf2p/44IYeEdXjouHnRIAAor+x03B1aLJq4Ge6tDWgm6klp09ld+HiHydvjYZkfFqagCO0YiA9166z9Df0kGO05z2poOsrfKlm+8IF7qZCegGHkie5TC1Hew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PCm9QCi5sVguod6MJDO37LK+X7u7G+fF7hoqlMdm+fE=;
 b=kZzTZ95z0AZwqmkaWyHyWD+sUJ5lHRKStta/ZiQMTcqcRSRpkxB7M6sUWBGy1qbQkH6qN9xjk1fSMOw7LJjV8E+pU3tr5SLWaaH9AN8FgzpA/aSWko9duRCAhPPHiYJTwmE6S52DDLDM1NTIRhAytCgkXO0ZDEqHrVkRWsgVpgs=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4616.namprd10.prod.outlook.com (2603:10b6:510:34::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Wed, 5 Jan
 2022 05:24:06 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1053:7ae3:932b:f166]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1053:7ae3:932b:f166%5]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 05:24:06 +0000
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-scsi@vger.kernel.org,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: aacraid: fix spelling of "its"
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pmp6zrf9.fsf@ca-mkp.ca.oracle.com>
References: <20211223061119.18304-1-rdunlap@infradead.org>
Date:   Wed, 05 Jan 2022 00:24:04 -0500
In-Reply-To: <20211223061119.18304-1-rdunlap@infradead.org> (Randy Dunlap's
        message of "Wed, 22 Dec 2021 22:11:19 -0800")
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0016.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::29) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a09d2816-1eb9-47ce-2f6d-08d9d00b97f6
X-MS-TrafficTypeDiagnostic: PH0PR10MB4616:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB46168FF3698B95B9A32370738E4B9@PH0PR10MB4616.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f4f3tQ1el/lisIVdZ6nPSBIAGkSZ3XAgdI4KmPyM9pSK9/+4lFIWQ/DytHLh8D8fyWi7KAzioC7vXUGnC1gF0/oW0Xp4v/pVthWk1vATlayUSns0LvzeCqvpcGq4KgkH6gTcCzUZCCT5cWcYPleRO/4jXdQbsz0w9YpyhL+Xj7t26bQmmSxbdOHagWtVgkn6D6cMOXmI/Zmo9AOfTr+0NEV4loZPqHAITqIDvbIPV6/WYWDENwyNTPIK7D2IEeerkoxysGlQh6Vo7aZ3c0482UMAYwKKsu0lmORYZNbF3It92UkkGj06mVAYBkfzWsmoUpmPkXCg62Dea9NYFG3NiGnbKZrxWvtAYUmb5oUcHr652zyXuwuLK9Pi5bgXVkM9Kh/pfX8MP3E7SFeP8qLeaJmJr456mD+HYPae4aCUrBFGxXt91XSG7j1QGNQxPTUz/4G8yQthyTE4xjM/XPv969dKIyC8jQ3GSwMohw3POeb7D+u2y0C1cZQp1FPKbeJAADM9l3A3PbXmojB8kHwGPsQWAWZpYv5k0B/TnUaRIYtZ7JXN5mUHs/te/EvyPo4U6VNe2E+EtIs1SalntGb33c5PfsJmitW0JDafK12k/cPVHRqbQSu/xBEn/ImP3M9PMmE2F93CLWDnEW/SbdpCYHLVPbb9rvobprW5i/rDw3w323lvHw7Ch36eOIB5PdeGrn7bSG22fG0hK/vofGlcvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(5660300002)(107886003)(8936002)(4326008)(54906003)(52116002)(36916002)(6486002)(6506007)(6512007)(2906002)(558084003)(508600001)(6916009)(38100700002)(316002)(38350700002)(26005)(186003)(86362001)(83380400001)(66946007)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mqFX+xJzAffm4byzpVz37zN0G4me05MiiaorareKlggFXuQP+i7NpXpf3y2p?=
 =?us-ascii?Q?zoc5oYQTVF/z1hDWEjJDRqZlOaz4eex6dmJ0PyuBmE9vP106AIYe7UvY9nGS?=
 =?us-ascii?Q?owSFUbt0u1t2xMfidgZrIwrRX5s+xkULzO15mpfF/1ByxBn4fBg8vnadhWW6?=
 =?us-ascii?Q?vDFutNrAJTKXQD5KfmlCWZzXkXRLkcVq2jQDOGE7Pj4BR73vUOEAQNJFg+S+?=
 =?us-ascii?Q?4+nnXGVJwyAAzAivBiJWBGTkKVOjC31r6j1B23z2BA/Lr8LznEMtTNjewCfI?=
 =?us-ascii?Q?u6ajx28nsmbvaxMGboP22XCWQzlYwB6ian0jY7no50qGwF1lRxHRP9e7c1GD?=
 =?us-ascii?Q?VDQv22gT35eGxbt7hrEHWUThCXO/MW+1bNT/3EhgQM/FXxFEVeroQ2XjTxDm?=
 =?us-ascii?Q?e7njhVQtq2uUmcy2UjAfWsoE0HZySeg+ThUYP3PVs9rQQlPjVD0L3rT8eyOL?=
 =?us-ascii?Q?ChGe42TAiYZiuBvT0Xr8Yw+U/scUnBTQE920UhLfIqFaBI/Is4dBR3qDLJ9O?=
 =?us-ascii?Q?XEEdFJFU0qze4mdmBjpPN12lwKCySK4VjrCaZpJp3ayGScm5qJecheFvOTGQ?=
 =?us-ascii?Q?NwjIPjmuJWEVG5xU74RoauZy7zmUB7zNacX2oH92JMf9aP8Bjz7RZiic3Wvg?=
 =?us-ascii?Q?r6rAFgi16HIZc5+xNIyTwNBtS6KtMYZBkgOB9RKt3uSgrnsjcLLTVjuBSSXv?=
 =?us-ascii?Q?8iTF1a+1Y6q4j2mnIQVlz0YyH/IvxOHRH6ki2aHYkQqG989KJLHybH3ONFKZ?=
 =?us-ascii?Q?rbU0tObKWDYMlJSaUREw3LS6trU80XtpiX/oVHaqy5CugHX2syqeF2ORpnm5?=
 =?us-ascii?Q?FFZhnQ6L07WH4+YKQme6Io/Smlts/cgktWdYEqugeqnEZh8wtAuKf5Zls95D?=
 =?us-ascii?Q?l7Ci4A73jO0bu6nWzaG4QBMdZXvmg06fFRCnjLlyVuQSOwyiR+RO1fA40Zm3?=
 =?us-ascii?Q?9qJAP6Wljvg7XqXFiOIpsLwQalRoN/Tl/xL96UMgWNLbpqUwJK4KwNWyTSvu?=
 =?us-ascii?Q?Y+/A9xGTuHdYI6Z/lyc0JcFPEtmFt2eu6dJqj/Wk0wTCX5ie6JS9CG689OPq?=
 =?us-ascii?Q?mQMkJtbDMrb7+JpNj1mqV2BQKzaX3rktOG6rUZgeWQ8IWImBTvtQAvfnhIdj?=
 =?us-ascii?Q?gL4nEyg4SyelCS/ONc1JoEcatShYMK64UEs5vj6b+NvRvYniOdaxqogrn/Me?=
 =?us-ascii?Q?wskKkQUYKKjXJxa3M+NYFt3FqQjZErnklDed44++coUfihB0GuBP0xdG26GC?=
 =?us-ascii?Q?AaTBrBt/cLvUzbhFygt4SQl3EB7fgdEgmVH/ged9pQQxHy0Td3OQm5Ras6uQ?=
 =?us-ascii?Q?0I6oMLHh5SYK//gygGvVr7j1jdsSTappPIRtSlltdTGDiQWBJAPx1jN+PutK?=
 =?us-ascii?Q?Wix2AsazdFy4PrBPYMArMZGScvVUOnVdsKiWqaMWJCjLA0L8YY4iFEK+gyRy?=
 =?us-ascii?Q?21X9dPnivpE8NCDUHv6SRQ96A7MzMngMFWAxkoRrYUUVQ2guuM5YptyPJvJ5?=
 =?us-ascii?Q?YqX8C8fIh4IaXSM9wfALIE0ytfLtAhYh+H2Gdj8BQbmmSWcisKmQ7kJs7YmF?=
 =?us-ascii?Q?cdCAslryHNbL2X0t5Zl8QPDC6e9/9KlfzPXJ389UK82LtdIwDy3MSsF9l5Af?=
 =?us-ascii?Q?+VoBNM7lkg3EYxS6uzPCtUw1eZL5PizXTZMUKPDmnguBeNskFjPbt0M/r8xW?=
 =?us-ascii?Q?4SFKLQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a09d2816-1eb9-47ce-2f6d-08d9d00b97f6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 05:24:06.4221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DSV6VU3+RLJHwQeNSFtmMPqVKIa7IcVW10wJE1zvRhsMS/2bxN5o1hEu10BE7v6fdG6T/I/pwukrmBjns/pgeEAhkhEyA4551AoLR8mmnd4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4616
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10217 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=958 mlxscore=0
 suspectscore=0 spamscore=0 phishscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201050035
X-Proofpoint-GUID: Hi7CfyAR_ntyIyCz5FdQe8PTnv29ZUSY
X-Proofpoint-ORIG-GUID: Hi7CfyAR_ntyIyCz5FdQe8PTnv29ZUSY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Randy,

> Use the possessive "its" instead of the contraction "it's" in user
> messages.

Applied to 5.17/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
