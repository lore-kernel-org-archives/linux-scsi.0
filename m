Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A950AC07E96
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 15:21:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E78E61C1F
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 15:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbhGFPYV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Jul 2021 11:24:21 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:38480 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232719AbhGFPYN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jul 2021 11:24:13 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 166ELanV012673;
        Tue, 6 Jul 2021 14:27:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=e9U3wcSM286lLR3Uth3pSwjM6uaPSgUhGlmZJ+1jBYo=;
 b=nYSyDKTgfiLJsCLM6o/NIDeeoTWcG3d/qiNHYT97F6IP3zq+2MD5pAlB9hfSGIReLdB5
 exPDGVAti08eoqxrnLV5UBGP+vbqI6ij1UngaQ/Py/tlywxgPM4FHw8WXzhlWiJDV0nj
 6gWpqvFBA4zN530EUc45Q22Btwq3eCZo8vREcAbzskgR1g9BpuOZH5Uzg5ERhR1D90/p
 nW8Us2w9RTL7JjGgKftUtB8Ih8In/M8u5/5lENN5ETWsU4RJFuQWHhqBQMoQy2SwGA81
 lROyIs1lh8bo/3+P8XyY9++XTrFgf1ro7frnYadu5fwS7Dxr+oXL8xSyTWyfEhbNNSUO vQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39m2smhypj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jul 2021 14:27:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 166EKGk8072837;
        Tue, 6 Jul 2021 14:27:37 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by aserp3020.oracle.com with ESMTP id 39jfq8n690-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jul 2021 14:27:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GvGBCfhgt/Uracxv+YIdEXtvHFNJFTT6RbiOb9h/k5FHFS96SHZX+/GafRmy+Fgp3mGjjJe5MYxRZMnK00wxuMWoj/9Jf/UAUBdaEgcWYHdKdHmoQF+Jn69CvyM4x4576hTjg7W/eVe8GZW4a6qn/5B2n/TBMOw+qVVszakIgQuZ3RUuvObl1Vq2rVSiZTKjizQ9vOodBHCb5/ugm96EcFUxuM4akN/BytsQ20hzOxkYeHibq7FtPRvoQHDPghSEMAG5dyKJeiuIjcpPCRGebg9J7ervtAvU3mW4VftdA/9sJ0GigYOrIjme3xKHLbCOjE3U0jemzgmElZKd2AVBpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e9U3wcSM286lLR3Uth3pSwjM6uaPSgUhGlmZJ+1jBYo=;
 b=QswKJZVORVNgJjF/G9vy+8CHf3hZowTcv91nSieb7Y8yTP9Lqi5KSori5fQezV5p5w1G3vndvQmirW3VVFiW+6azfiRZZ1vqfm58mozWWeT6RqKAXnhunUpREOCvboO8gVi3ZRwoGAuu3wZiiORoKSBJaCapXTzFTe2FPS0GiiIqiy64F0g7/U6Iwf3naQDqaProf5rKTGDaozRb0G+d7VJQTsfKah2KMT5h3PdBciSKCpBqs/FjtP+pzeJU4MAQU1h2ozdzacRPwGzVcF+xm3v9q4/5qdO88R9FGfQ7RSYaUrkriALvo7rE7okyriBAxdDG1pxx4Lqce61vl/PpNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e9U3wcSM286lLR3Uth3pSwjM6uaPSgUhGlmZJ+1jBYo=;
 b=CzeJAhDKq3dOZ7MZEIcLpAI4Uk26e+JfFn4cJC8Opftzdp8fYqIT1+Mg9tR5o2ZjQI/jy5fqflDCv4uv4wgI/vA51wG+1IO9woeicWgbMIQMNuPav19wkNr3rBIMURa1gcvAQ7YeyLyVGib9py24butbAckHsI3m4V8QeARa1bQ=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4631.namprd10.prod.outlook.com (2603:10b6:510:41::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.23; Tue, 6 Jul
 2021 14:27:33 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%7]) with mapi id 15.20.4287.033; Tue, 6 Jul 2021
 14:27:33 +0000
To:     Marco Elver <elver@google.com>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, hare@suse.de,
        martin.petersen@oracle.com, syzkaller-bugs@googlegroups.com
Subject: Re: [GIT PULL] first round of SCSI updates for the 5.13+ merge window
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wnq3ed3i.fsf@ca-mkp.ca.oracle.com>
References: <e118d4b2fb924156f791564483336e7125276c47.camel@HansenPartnership.com>
        <YORh1+8Mk5RYCzx7@elver.google.com>
Date:   Tue, 06 Jul 2021 10:27:29 -0400
In-Reply-To: <YORh1+8Mk5RYCzx7@elver.google.com> (Marco Elver's message of
        "Tue, 6 Jul 2021 15:59:51 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR10CA0024.namprd10.prod.outlook.com
 (2603:10b6:806:a7::29) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9PR10CA0024.namprd10.prod.outlook.com (2603:10b6:806:a7::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Tue, 6 Jul 2021 14:27:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db499f19-8040-40ff-4b3d-08d9408a31a5
X-MS-TrafficTypeDiagnostic: PH0PR10MB4631:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46312D7D47CE7C3BAF09B5978E1B9@PH0PR10MB4631.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:295;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q86g+vyrmQ5dE7MPNP60uk3dM8bYMhg54NBurOtGxp8eco8AHtpGquyC8YuiFkyW9hIl6t7CSsuJEBUusNkg/kwF1tFNH47ZEr/HIWB/dJW9tAh2xzJMh7MvhG7zaLhmg1bAB60x/whJj+XSVH6Io1jWHGtvfBKX7JxqJQ3/mObO6RwwFoR1VFtk6KEj5hB+aMqS+5nbTWM9vD6NBZaWhu7htdl+8JQprjd38mC5P4p9X6IKRMOLNmktLLorjH+UZRN6M2UL5rclTkv6A+ylLZZMnBSvd+Oo1ZrkB80FrMppGrPQg/HmZlTT6epPsQDlywhE/3Kfl1nEnmkXcCSTT8uLqi2hkjdJ7QwC6fQb7Iw8QHT25Gsc4430pHoimnC9OQs3cQweeNYOB/8c+0qPoL6H5zjhRnkE3yX1eufq/tC8csWC5WKSTq0VsGffBwwG/CcoyVvTL2NMcOwQZS9lpnPfe5BFIBX1hyEluJMzYVMcd9q4QNKQSz/LCCHDrQrqCuxGZYWRUjhL5qJvEunrVgD7yM1GainYVTbQsAiT+8bruG6BHC+SA/XSYMweq7XzNGlL6S79DxYJOIKPJJvc0KY7KrZRitB4toLid7W7psX0wBMwODdYvKvlwD29BkG2iRKJWyk21jcxcqcXR732UFFTU010Bk5S9W5f2gkmr+g3UIG+tAkuLLMoKxStM80imjDMxwjv6izCV/mGgPhgcDtMySq64RzWz1x+svYD2UyBLBkwIMbreL8tdIcV8YLEsVrSkITo18bzpJ2bibkXH68it2UmeeOOPYWw6j+7rjY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7696005)(8936002)(956004)(4744005)(6916009)(54906003)(66556008)(52116002)(5660300002)(36916002)(2906002)(86362001)(55016002)(6666004)(66946007)(186003)(26005)(498600001)(966005)(66476007)(8676002)(4326008)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FYnDWNIVi+7w7MI0V/kmvo94SDcGe2dr98ZcZwN6tRx6fyfnu7FXZeyO6v6e?=
 =?us-ascii?Q?zuDIAU/e8PWHh/U8PLXgexACf85ljHZrk8srFD5yKBsM4BbnEAtnBzNk5MOy?=
 =?us-ascii?Q?IDu8mXxtbHwnjRhvFQWAUe9p0JeRDcykQP+7SyaRp4D9EdGM1Y9fBFW75ktG?=
 =?us-ascii?Q?EVZy8k+abfy7Fg+Jm9U+LyBkOTiWXggXvMNeJIYtBetLmnj1isIgYz81wSSH?=
 =?us-ascii?Q?YZG2JFwagAt0+1KjuYueaLPTVNe6U/7MSqQDQvP4XRBPPlm7AVJ2b6h/gmUm?=
 =?us-ascii?Q?hWPA/oNfePcHyFc4CyJdoJtH3ssuN76eXT2wi+5biW8VY/JKOpO5pAbxY9Uz?=
 =?us-ascii?Q?Hkwlz9VZNqY+DuE8oDcx2s8aVn5oVfp8M09UUTqCE28WMFF3qGaNoZpX+BxH?=
 =?us-ascii?Q?iIXG/LtrAwPNGwKrKHryaen1CNeP6z0le1hZu8fKIBByI0JCcZnQNWwaahvi?=
 =?us-ascii?Q?ss5Y7TmtvPGJ7v3fp9P5nh48cujVbpIOR8Em4x3qgFOL5zdsmOWNlWgXPuPZ?=
 =?us-ascii?Q?K0pvbTFYC6otu2Oa/MJw3BiKcjOhWyb2gwTohbL83uOU69h0fzNB5yj2sQ5U?=
 =?us-ascii?Q?GRIJsZip2QGwYXuw+0gLi90BgTsj+Ol+1+om548ljUJkqGx2FGxVtZp4qq3/?=
 =?us-ascii?Q?GvwFBsxpmJR/lgw/bUpEtlFL1GA8ZNFVxFTUzhbmYU6cROQMgpG5q6ElImfv?=
 =?us-ascii?Q?jh05JekzK4bwc7toNDVvWQ0vQydNOKgUaed31hOZT42h+1ThB7akc6DlQD3B?=
 =?us-ascii?Q?/wzRPj5oVUBpEojBDKIJgt70r8nXCewoQg6aaQC57cdUNBUnwOmRoxsY4sk0?=
 =?us-ascii?Q?duL2SX0SJSuBFFNN9Yfmgaa3/TSte4eL5gV5zZxSX8dxis71DG9+RcSPgqgs?=
 =?us-ascii?Q?GxJa8Q7X7N6XUtC4ZxAcQm94UCxqO0tP4lcdQrM2YLNPnpexnqAaGJkFgRVy?=
 =?us-ascii?Q?o1gBCHOrSz5NaTR/74RF+mzwIuv/5KY5il0sjLe9zI+zNl2C4LXWjWj2Lg+T?=
 =?us-ascii?Q?S6ofyzhNZijdhEN1jT71xpHjmQHkpd8YTCY9rgouwCJSXDCHAOkuwvFm9AHr?=
 =?us-ascii?Q?DSTzZC94aH1t4++2o1L7Mx/3Yg0rSiWSiVVG50y7xyaNCvQWYfVVRz4j+B6a?=
 =?us-ascii?Q?n0HNFWUPBHpnQGuAOQgZV6IcvvIDYgYTg3NppSBN9z35R8E46ZQmn6Enp93r?=
 =?us-ascii?Q?vnDYsX2TCHhmjjcDIISB8aPCXcI6zg7vqOC6khZlNz+gp/y14GvWyHxU+bYj?=
 =?us-ascii?Q?xfYkfsTEajaN4LNt4BnYDzd6HeLQ3fitPyscEKQY5iG+EAxlwj71c1+CBfd+?=
 =?us-ascii?Q?nPedDI7m7YG4A/sb4//tjoG5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db499f19-8040-40ff-4b3d-08d9408a31a5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2021 14:27:33.4257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZupGszO+dSw4amBov2z0U+FYZW4Zf2b8NFka1FSJOLba7A4DGy+5cYUrrKQ8vbx9HOoVlNiK1wd8kvNskG4/84cGtV72BEZPY52vVspXyAU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4631
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10037 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 bulkscore=0 malwarescore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107060067
X-Proofpoint-GUID: rtFTOjUKcbgr7WirQrExeOp3t-EOxDCN
X-Proofpoint-ORIG-GUID: rtFTOjUKcbgr7WirQrExeOp3t-EOxDCN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Marco,

> On Fri, Jul 02, 2021 at 09:11AM +0100, James Bottomley wrote:
> [...]
>>       scsi: core: Kill DRIVER_SENSE
> [...]
>
> As of this being merged, most of our syzbot instances are broken with:

I believe this should fix it:

https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?h=5.14/scsi-queue&id=c43ddbf97f46b93727718408d60a47ce8c08f30c

-- 
Martin K. Petersen	Oracle Linux Engineering
