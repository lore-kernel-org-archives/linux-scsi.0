Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 451E8C07E97
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Jul 2021 22:10:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C28661405
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Jul 2021 22:10:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbhGCWMh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Jul 2021 18:12:37 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:2040 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229520AbhGCWMh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Jul 2021 18:12:37 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 163M6mDr004633;
        Sat, 3 Jul 2021 22:09:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=m+/H08qKCQaogUkpfwvuQRmObtscXxZKW/9XwfQT+pM=;
 b=GQpKCC0dIWayV3YPp09AcwZJBCxzcAjWXWolhxadMzPxjcntsi/2e8ilsLfRKC2uwesf
 YGIpLbJ5R3g94e88uGYlzEXxlGRStarCEETNR6JwA8F7mqQIn05+ZBgKJHJ0+iSv+uzb
 TquPJtniA+3kAQp4LQgbsSvbz+sma1cpSyaeySvF8UZVEsOB9iSQLqPtgY0gOAD5zFQ2
 NgFb1twZf5hGWT7Evq8ThM4NOA07vtsQzmANgyylF1WApGQsv33d8THia5fgW3yh4cdZ
 kwjVhEHsIXrhvKDbJJ1hPtbBvr5NeB6+i1jCfsDNXcMpXncedE5Jb8agtOoFEIlQQ7+O LQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39jep1gnua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Jul 2021 22:09:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 163M6KNd082397;
        Sat, 3 Jul 2021 22:09:43 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by aserp3030.oracle.com with ESMTP id 39jdxc7c0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Jul 2021 22:09:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VmWkM6gg2pxMftB6RPWxHRMMBwfUfiT/SI4E9gQmTU01oOfu9l3dWUFoiaFEA7ghSrZTh9HQbRaUyCeTbjJGuflkK014hJFqgW9aDD01hju5QX3Oh1LnWzCB4ikM8rckej2ZZ71mAleodr6gt0UPPaq6w0hQvPAGlMPKq/B7gQEuqAN06X/i7lyEUmDfHpcNqtoQidhCBocJtzkJpyj4EjzI5XFORdUFgAVIFaihIjPOYmKsYriJQfgp82JyHMHpmwVA9Bo+W3xpZQiQS6I6P6uI60erBk1gca3B5cZ/MnqaYFmG/KltBAFsP28OCtZAnEWlSLVB2FF/i0OIy67W5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m+/H08qKCQaogUkpfwvuQRmObtscXxZKW/9XwfQT+pM=;
 b=nfG/btefpT0z4WPxiVlq5ogXF7SkH4SNAmgLJpkM19i6Vjcp4fC5VSJY+dBKj/im1HtBNZLkRVS0tcP/KAOwgj9U6S2nL87LwUzljpRBNPCxPEfpiDhl+rqK7aeYLXhqayMtEIPajtSrKlonCpksjhWbdQjgr1aJ1S4FEe1z7Iy86nADCLOKYuEvxeEjFnTvKxBPciiPsf3hrFnmd6YCnv8FFpWpjjPtO4NK7qgaJdN740pAys94r2STIulC2W1lnv5AvwCAKFPP/3LOxz+Lb9U3VRoG5u4W9gzAmVSfnEpxJnjEK7WxFooHnWRvRXNh7e3/rO2H19LSQLtSRj+XAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m+/H08qKCQaogUkpfwvuQRmObtscXxZKW/9XwfQT+pM=;
 b=IysBZtKugA2SLNLL3+6rcIc+Ry2po3FUn7u6AMZ4jPqBJ7lI9imZmmVItZxUrRuAVXJfPTqShRJrnD9KOHojD8NxmBjdj5yqyruGtiUMXwcu8HmB15gM+dbP6LmNMKVcLL+2+cVnNFVIhPLBIczdsFpaS99pvE5o/erbDVQdHmU=
Authentication-Results: roeck-us.net; dkim=none (message not signed)
 header.d=none;roeck-us.net; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5402.namprd10.prod.outlook.com (2603:10b6:510:e2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22; Sat, 3 Jul
 2021 22:09:41 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4264.026; Sat, 3 Jul 2021
 22:09:41 +0000
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Jiri Slaby <jirislaby@kernel.org>
Subject: Re: [PATCHv2] virtio_scsi: do not overwrite SCSI status
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11r8fgirc.fsf@ca-mkp.ca.oracle.com>
References: <20210622091153.29231-1-hare@suse.de>
        <20210703183510.GA1235060@roeck-us.net>
Date:   Sat, 03 Jul 2021 18:09:37 -0400
In-Reply-To: <20210703183510.GA1235060@roeck-us.net> (Guenter Roeck's message
        of "Sat, 3 Jul 2021 11:35:10 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN4PR0501CA0141.namprd05.prod.outlook.com
 (2603:10b6:803:2c::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0501CA0141.namprd05.prod.outlook.com (2603:10b6:803:2c::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.8 via Frontend Transport; Sat, 3 Jul 2021 22:09:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d05f939-8e4d-4897-d76f-08d93e6f4187
X-MS-TrafficTypeDiagnostic: PH0PR10MB5402:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5402D2AA5685718607AE4D388E1E9@PH0PR10MB5402.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:497;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K9hLmRFm1TT+F3SC9B6El5UjJj+JZ4DtmxxOCx/mg1LxDkeWN053I6jpKd0SSZUucj14jUHy6X9wUjoBE9kQFa3ZcZdjOE3QDkIXGvKOH8Lip+sVY9A9+Oi0G3kQK+c26yvEGd6HEcjxXM3jsO9lw2FGHNj2jyU5Wxvk6Sf6CuY1RhPdlUCUgDlr8h1Y8AoQF0StLkiR9rFQzyeP1dw1PufBmxvQNmetAT7+IZSrRHzE1CEOTooPQBCK+jsStyAV34qwxQX4EJlrf2RxYEx+uCCaKk54IL+IIlUDgX9Z4T+Tmr4NxcVtEFlXkM22NJeezTXTfraftJ7lSDJ01GVma//L0/G2d2jkXPYV2MBW7p6Mli8cKe0yyHe/6YlnAnS6DaQcrQ1ww4pCEH/LaiYyyYt2dhsmahHt9RpyvDvYEBMRHh2i1UCzn24kJTFGyo8fFJPRCXBzVRzHbg1q1lj3zU7/hetu244MCmJbfIp9ah3W1sm7QooNV3CyTzTR8RHxRYcOojSDM/gVUgZPwiPZcprLL4x/ysUTRDnSmiIGWxt1dmTl/7klqI7GytQvS2KW+HBP6+O45pGcGo5C2ulY9YhGjzua/7DR+oaB7QHleoKunsgtkqIvdXj7x8DCne4mdzzoqBAKwe0rCKTI5qCSkYOBaVX13xoQ7ylfvb+hLRRfgkUpm6m1fz73GBmQV2L+DGXgBHMnu/y14ZJhcqrHR/xyZPzUouHwdt4GVVbzPBdp4+Hp6x2Ld9lkUYm6bpwGHIFUsqEAr/+PlyghNq5x+rfHZNrqmb+6/MWC6IKexSw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(376002)(39860400002)(396003)(136003)(966005)(16526019)(186003)(66556008)(66476007)(55016002)(4326008)(26005)(316002)(54906003)(6666004)(66946007)(8936002)(86362001)(7696005)(52116002)(36916002)(4744005)(5660300002)(2906002)(956004)(478600001)(38100700002)(38350700002)(6916009)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AEHbIoSDotlLGclRYwJjvkwU0QB/6vFqEMPmdFFwxLQYH+sUreyk/QxtTRtw?=
 =?us-ascii?Q?NVj2/pJWwb6lTtunqMiQ/u/w7cP0mXH6RZF4JRL3L9XMiH7WN5ihgGptwzgf?=
 =?us-ascii?Q?TGdS/Y44/ChSDKiPKq2rCzAVwqpEZAxJqa0tUaXuLycp//T8wLaKnxzCTfhe?=
 =?us-ascii?Q?wn4mFG9a0qwiVoCwPRf3cuth5zYq2gsCWSGTQwU2TjPOBn1/dZrMWzmj68RJ?=
 =?us-ascii?Q?EhgnZ6k9m//hyUHG1xz7n4PxcoKX+1EGQfCF0ziBrIUXBVpk7x5tYicjFRGG?=
 =?us-ascii?Q?hsNHEwmEzxLax4rkiRdldlstJ5rW1H2CL0hnGhIfi5Nw13woDlNyP69Y3FTV?=
 =?us-ascii?Q?hXLvKM76aUUZ4eo1KsWTGFoda9alrY9svSVAEWPI/A4KI5xGF61ADwohgFsH?=
 =?us-ascii?Q?SBrO90DaNPA7OcGIca/977uTSjF8V5gfa2h3dC4tXYsJiHnEn1wdTRIMsSBw?=
 =?us-ascii?Q?M3HG3ID/fa/5oV2tV0h8XNDOX8gM1WbGZg5urQN1zRhsQclGcQrHNGVOXfD5?=
 =?us-ascii?Q?WtsByglAhQLckrIqJEx/bkgAYDGyKLxOEy1RVqrBXVdhANVFWQ0SreWbg3GC?=
 =?us-ascii?Q?DsWvRY8FnsUa7yQpRGEaaZl0n7OARhDQGmd7/rDEb0jC9/Gq9s3cOLieF4CX?=
 =?us-ascii?Q?7s7nhoqn2w45+zd9UbA/9z+cUbVVqopuMgNLMJ7jcHP+x1OcxWY67TGqedDx?=
 =?us-ascii?Q?ZyVjNbOsz2BuktIGjKtNB7ZpS78kjfmWerurJI2FFqGabeh5b7XxrZ3AiymT?=
 =?us-ascii?Q?DM7abFYt7h9u1NO5YTOdENm6rJeD2OwQJF/efj8oy3hQXSuHtE7HucKw8wHq?=
 =?us-ascii?Q?oTVdYfZR4x7xAC07CzWTS0aUquZz8auPe8S8S+qe90oWWLNIolIC+cfEJiK7?=
 =?us-ascii?Q?vz1qt9jd1rLGnBtGBu+ZXZdXqPAsxeCGHwrDHH8kwH+XAcnIfQVnP0+xroLP?=
 =?us-ascii?Q?j4Dzc8iSAblzCwh//euFkAFX/FZsmy+hs6FSsHfJqzzu1yK7KrJ/aRCiWKh+?=
 =?us-ascii?Q?+lMGMG5lIgIOQhrochhnCf4GA2zaThr9/YjAG9cm0pgr5N8xvUApoMr/7FDJ?=
 =?us-ascii?Q?75vDee9H0lcF8U+8HuYB7cuyTmh8sfyaUAIXObE1aZH2/DCBRFfCm2Qu6Ltk?=
 =?us-ascii?Q?tGdfPL76o87TTGXczomtFGdjt+VaH2HN2vAAZ5kL6rKvN11j9+KrGfPx7Fk4?=
 =?us-ascii?Q?GLttSA6paPezfFtXMfoSY9caGOxe9/RnnVdBmJNyRZi0FuvmriESH/WyPSrl?=
 =?us-ascii?Q?HjL2czYsevks80cu7JR55ws19zrZP7l1UHlCm0baEa9Qm7vx9a7AKBapI1Ym?=
 =?us-ascii?Q?s1RUHxFVyQ0E3joHeSm5ziAS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d05f939-8e4d-4897-d76f-08d93e6f4187
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2021 22:09:41.5869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yoK/3OcQ6M6M+ZYi5H+dCYeUCdLDffG86w9AKiccEv4OhUsXd2IpTA0Bg1C36oRjSEPPV6VGUiZ9tJovuFymEWLcvgPSh2OLuzcXO+FA9rw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5402
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10034 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=964 suspectscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107030138
X-Proofpoint-GUID: caCf6xygR5zd8l1WuIomFXrpbIUJenrA
X-Proofpoint-ORIG-GUID: caCf6xygR5zd8l1WuIomFXrpbIUJenrA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Guenter,

> This patch didn't make it into mainline, but commit 464a00c9e0ad is
> there. This means that virtio_scsi is now broken in mainline (as of
> v5.13-9356-g4b820e167bf6). Did it get lost, or is it still queued
> somewhere ?

It's still in 5.14/scsi-queue:

https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/log/?h=5.14/scsi-queue

-- 
Martin K. Petersen	Oracle Linux Engineering
