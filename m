Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B554C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Dec 2021 04:48:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234240AbhLWEsE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Dec 2021 23:48:04 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:19302 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229704AbhLWEsE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Dec 2021 23:48:04 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BN0bPmr026373;
        Thu, 23 Dec 2021 04:45:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=3HcyYOZQkJLVInvFYlZf2JUWCBF906NIjzHSOdAENgU=;
 b=uzXYOl5XuREw9EUhT5pOiky6lUVISBnIj48xMMbsKwNLousk+ylls7B7gtoJvadSV+EG
 2Ok8NJESG2F3nUYvLDQzzBRrJUQ1kt4t7hI9O3RgXnJWh0zPKF+eA5F8IfbRltsvrjGH
 J78BT20HCQdhu4vO5ZRX7wwiSHpxaLxP3OMJ59PjkOOipCbkOSa/LhxKJ9fci0iDvaLo
 h9oXCvRTw/P7iA0FpG8V/UuEPazlwJ1JG4Aobr4cpZAeZLTATrHY7gCoJtunKKf5L5dC
 TSGeHZagriKjyhUW2SyZSOsr21K5zZ5Z4uRqQekfK4Ma1my3RuDOWpR9nuYIP1Av5nu9 qA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3d4103a0qb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Dec 2021 04:45:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BN4j3HD003293;
        Thu, 23 Dec 2021 04:45:51 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by userp3030.oracle.com with ESMTP id 3d14ryevw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Dec 2021 04:45:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZWseNnpt4yydA1o7DDR8LxTTG351FxvaFLDaD/55QzwQp93+qSwM2xOuxmHY711Alm31lKWM8friTdxspyxbChocBO+EL5oRlZRHTei70dwQFYW01yYc8toDEC2ABJUZp2drFxUnBwDev/38WBcXbvKt+6+HT/iZS5NRHiAWYjUYGIF3vPlsTnpEfa+zqU3FcpEd0+Fmt5SVOpHDlHGOnjAAztLi0dMXtvWs+arnGJCkIEpM5HLgehGs0LwcO1ya229uAolv/BpBjJWpxepTMwjvItJ/wgfJpPvyrcT+AIyeSq2LZ4b72NWoe0EuzG3P7u34f0siV+bLrl/xqyIDYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3HcyYOZQkJLVInvFYlZf2JUWCBF906NIjzHSOdAENgU=;
 b=UoRazfbCqUq2BHFEfOyOIO54fBKTW5BGJmuqVA+4o7q0dscNJfZDqGdFLkGbA8QOCb3kP2OYxqCm4PPZk3NMpLWavNRKqWPSu+4TNmURsZiS95K1Ta2ylzEXgIckpxTq5dShP9qYyCfnEdut1XLUZZ/K6iv3cB0sRijy0LmJDafukqWC2Z+qpmLSigL0gDKZLlPreVvscUokB5W1dsV0IMj0F8+lHCO2I5rCMT3RO7Sw20jGs6qV5lgH2AUEmWMBhy1aAiCpCQFuW2BAreF/jLKdepvrFWIDbTWqtPfx2zooxSJK697niLp9niZ4s4lJdZjIta82XdEgDyv5QX5TIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3HcyYOZQkJLVInvFYlZf2JUWCBF906NIjzHSOdAENgU=;
 b=JMpfZ3c89uUV2vSOJd8r4ktOWMyJkuU+m5FC1TjB1BXqF7b7vspFEd7OFbEMgvQv5baHQSRtQD9Wrw/qdSSNcz3JXERKsDGGKvZtqS8cmhgucBYXcxBykF8Y+xoe0MI3ArYStbWTsaF1tkBUIGwwOvYJxhLj5sdWEL4IZBbeiks=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4599.namprd10.prod.outlook.com (2603:10b6:510:39::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Thu, 23 Dec
 2021 04:45:49 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::f4fb:f2ea:bda5:441e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::f4fb:f2ea:bda5:441e%8]) with mapi id 15.20.4823.019; Thu, 23 Dec 2021
 04:45:49 +0000
To:     Christoph Hellwig <hch@lst.de>
Cc:     martin.petersen@oracle.com, hare@kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] myrb: don't use GFP_DMA in myrb_pdev_slave_alloc
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fsqkgc96.fsf@ca-mkp.ca.oracle.com>
References: <20211222091801.924745-1-hch@lst.de>
Date:   Wed, 22 Dec 2021 23:45:47 -0500
In-Reply-To: <20211222091801.924745-1-hch@lst.de> (Christoph Hellwig's message
        of "Wed, 22 Dec 2021 10:18:01 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0701CA0021.namprd07.prod.outlook.com
 (2603:10b6:803:28::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f642173-bd22-422a-5923-08d9c5cf17ba
X-MS-TrafficTypeDiagnostic: PH0PR10MB4599:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB45994AA4236D608647872E148E7E9@PH0PR10MB4599.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jG/gGfwomfMyIiMliRA4H59D9vFv0LLlUCOUxqgNkek/P+KytNjkTyAI/9KzTOIPetmaVC8dqIMbOkR3L6/6uOhYoJoIPkqTQPCByodkXthSXyFYXR3+g6zmkpe2+k1B41soGeFnqL0jZFSoQ16UB7JoBkz9TWZJfQN/R3IErzNamayavO1tBsHfALzJ/U2WsOYbZRZZn3ExS9a8e5DIKBsYc9Cters/jKEvKoAx/4GcUjR5d0QWvRlqmee3dOinenhP+RndBsD1w0l04cqTqesANs3OIs6n0nMn8TtPl9OlOlVSZILAwfWqw1iGMMzd8YrxiX5VboasdSRuh/kIhX3v5qHQBD9AHgwdUTfn0EKs3yD4EUr3S+wqcP3GxOISTwDQ+X4xSAnR/e3zaSs2vpSmH7swFd9ZCnHCOKC8wwogxZZAhl0BWFldCSuNJKP0rmjDV7LjKOus+3p/RU6WLdd6Zg6I5tGJ6AGUPE6MSLU9PCvMmd6yPHxhSQqAwxd2SHOMYbraQXRxko29eke5PNu+Ceg341AAMRFYllqmyJApt/trJfXQ+A8il1CBAw6ugDGJbQI8ROIvIOXtNwMJMwPckcLAi4JbdixIqE8f1S6kFHQekIDSO4gC5UpEE2fNgwnI6K1dAvKMhN57FKOzkvCbTpn2Ms7nZ1wG8OF36yxhb23eA10vWV3Hwb7jecV9qNqqEp6RCRzAy/1viNpmTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(2906002)(66946007)(38100700002)(66556008)(38350700002)(8676002)(66476007)(4326008)(5660300002)(316002)(508600001)(6512007)(558084003)(52116002)(6916009)(6486002)(36916002)(83380400001)(6506007)(26005)(186003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ggYe9hy3uz3eTKt3128QjtKqHbRGVWoIjEGDx80VvwWYizF6LeVWHCBsuMw7?=
 =?us-ascii?Q?+0ZQX8NNm0Txqzv/4QSm5JqGx8yxOUzqmFfNYXgtEzJleSCfUaEfWevtE7YL?=
 =?us-ascii?Q?Z3Iso/nV3RkFOp1VUCYaYw1iwU0uK1V4b8AshjXy/z4ZVhuUOTQF/vdlsq83?=
 =?us-ascii?Q?XQbqN+1k0TYGzcI92aPpvG2PIq0FNYHjerihR7Pq51t0le6u2My/OSvWSoyI?=
 =?us-ascii?Q?5Vo9lKEGQek0ZQsX8Q4jIpHng9eXhW3J3jQZpF1jGg8wSugj3icOUYXMTl5i?=
 =?us-ascii?Q?UB67RSWbLNeZT0UnZ2Lc/4tXuMytvc/zfXeaIv3GdmBfTOR54W5C5kHeh7WF?=
 =?us-ascii?Q?JTeNWEtOdSIRZw5TAOU0ly1eacJ1XSw4f1Oeo3vETP7tShP79cVNEjZcySdo?=
 =?us-ascii?Q?P9Wl9tjBWwyTczpFtYTXAB9NRffgKZeVZZCtZa1Um5bGlNrqs6ZXQ/vtjWNs?=
 =?us-ascii?Q?SV/Q6vYC4+A7Ch26KFmbUsd1FeVp+/D29WBQHNSaQ1RrHDOkkgtCRRxTR6f5?=
 =?us-ascii?Q?ovAURc/0ZJvqB7WYqUS3/Y9qyG9+5i8HH2Ssqt2tNyB5et9O5CroXL8ds1yE?=
 =?us-ascii?Q?XTY2P559hWGHqoGLtSqD2sdgVVANJjUxOTn6S4zGCu8t8DFTlHHUmCtsZ4sx?=
 =?us-ascii?Q?sHHWDutW7/ZlD8WI+NNc8zLR/8GHfQwTDiT6UN6uiZY7YuYqvvV72I5BHuBv?=
 =?us-ascii?Q?6bV08IXMLZe8X4m912POT+vsv3B4pcc9TgzUliYHfXOyiU+vj1ngaBdeMuC1?=
 =?us-ascii?Q?rMbrFgOq1bigs2AhfQwVupFQbeaoMjpIBYi4Q5SSq0nicCaRVXZiaeQbPpQD?=
 =?us-ascii?Q?4SRgPgvmTN20SrDR0blP+kF3Rt+Mrg1WDQEfb++Jsx9rxe7tysbmbBXfgCIM?=
 =?us-ascii?Q?nlAxPQNdNXHrEe7x86QjFEKvETb0I+DLlN9Bpi5xp7m/M1RyKlWnpJMeDlma?=
 =?us-ascii?Q?rahxDyDelFrDkIzGrFjQ/+wpc453pVX6eR+qqCe3QdbxVl1vplrjnLF/7QmV?=
 =?us-ascii?Q?IAzcq6ilRhFGYxKh0BWQFYyf++CtMxv97qJ0nE3qeg+kLsT16nDlAV9an8U9?=
 =?us-ascii?Q?LIyjVQV7bZLf2xJhZ4Dqc3oXpUUizOqf342TaRNR3Q4IcaF4tmKBKHEPfTkQ?=
 =?us-ascii?Q?AkcG9SCOS2bPTpgM7jciFqSqTbydwLxnqbBh3Wjb1dozlZfpocYx2mk8N5vw?=
 =?us-ascii?Q?eT12lK/USwE5QWCLRcpMVg09i8Fx94GYD6bAbc5TFJYiCivysd71w6LeH3xL?=
 =?us-ascii?Q?Ny6oL1BVko5Pd3rd1hzyzaqp6yasMJ0sy5t/sI/Vo7z54ttCHeZpuK4LWeBQ?=
 =?us-ascii?Q?QkUVxmWHRqF/o6rPTDcU2VWVzORXRfsLCole6WtOF3bSNEAqBuMgP0EwQhaG?=
 =?us-ascii?Q?2Z/QP68YHwgAnKNhgpx+cTJMz3iA/azTT5e+9fUPkm5Uyf2Xx/P2b14tNFkB?=
 =?us-ascii?Q?U/9impGMbanNsNYifjOkEs1h7YEwf+kUOYzPau/hOEEEw568K1p8GXVFqkCd?=
 =?us-ascii?Q?iJr/FSWZVfkUzwE+9wEQMgaNqaqTKXI0Zf0wKcZidrUmWkPxUpotkoU21gh3?=
 =?us-ascii?Q?gaWe2edvbrhp+b4Vm6Yo//qTL5id86uy7Odoe9C/dK7F0GHIMYnSau/uwl+B?=
 =?us-ascii?Q?VBXXC6I9CAM9rd5/M4WeeC3tNikqFfiEnHDiiRXFJEZnbB+j80j38rfi+Z+z?=
 =?us-ascii?Q?zl/sWA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f642173-bd22-422a-5923-08d9c5cf17ba
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2021 04:45:49.7407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uEjKzwlbvhCiToWttuvZSNaqJ6R/dqJAbjes+6084aO1oPcCfTzeUmgPWmiECFUFpRnjbu6cMrgBzOoldzdKoxxic8FFUvQH82/PsGnuC8k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4599
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10206 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 adultscore=0
 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=672 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112230025
X-Proofpoint-ORIG-GUID: 8Jgr9t-ZCq5LE4sLiLKh-ybEBUl230GC
X-Proofpoint-GUID: 8Jgr9t-ZCq5LE4sLiLKh-ybEBUl230GC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> The driver doesn't express DMA addressing limitation under 32-bits
> anywhere else, so remove the spurious GFP_DMA allocation.

Applied to 5.17/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
