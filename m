Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7911C433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Oct 2021 02:05:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79A5960F9E
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Oct 2021 02:05:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbhJQCH4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Oct 2021 22:07:56 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:48050 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229835AbhJQCHz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 16 Oct 2021 22:07:55 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19GNwAH4011812;
        Sun, 17 Oct 2021 02:05:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=YcydErIZR/d8pxz2R4h3n2nHXngYFbxWZHipOEK8r3Y=;
 b=pN8ob9lEv4JAZs9eLkBVXsHkoYMR3PxNyTkTTte0ICVDaCPwDMbkP9kGBJJVPyR5WL2I
 sLLfo0oNB6d0Rv63meWmbzIzMNdxE8ZUgxqpqbbpeq6vW5RXhikSpv6vnc9z9Di3HbUZ
 FmnG5hIOXC3l4q4xtOQa1hnTyPAsWRe86SRYN/kU9dMd0AXeUE6fOTM/OYDh+QxB6iNY
 6qjLaqAz0xWssDDWuEutRHLBcJ0ht2hUb4QQ47uCxS/TXNp9mlCAhKvgq4tk05YQGrr0
 6dQWwG5D7GxuUXweq/luhE9E9O/Cj4qMoojyLJwyU0RLXejA7LG6k8dCFn7ZSnhuC/D5 Nw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bqqm49pjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Oct 2021 02:05:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19H20fNm018778;
        Sun, 17 Oct 2021 02:05:42 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by aserp3030.oracle.com with ESMTP id 3bqmsbjycd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Oct 2021 02:05:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ebXk1csq1nXA6KoCguC9CKNnvU7PXEQL6MWezJziGrB9IK1RJEZx2rGtbnROxHzy3ToUv0mREhfRe206bUQi+3cNV9OlEDh8pdwYpljyfDMcgfACKqQNFk9jKJ0Or2iclJ7pc9CfCS4RmD9AHnI2PtQBdW8UTU0ow44UgwGRnvuEcWrO9bBP9iRBmTab6uiDCDdhVIWMk6aDzcbHkzvnA3uytkDXJWn4AioP/xAIxVJvdGGXpenpzkOIp+TRKXsLTp7bmqDwMB1g0ToW9IqTNi0539l+eCc1ncrbLi/CBdg9DassJ3WOg3LsmC9Zn4Z6eLw4ctJC4V8IYCcqoYR24A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YcydErIZR/d8pxz2R4h3n2nHXngYFbxWZHipOEK8r3Y=;
 b=mazG55dUVi0BGRP0uR3e3TpCpUuTfkgenJSqhUFpgZzmjet/AMu934wh4WAlVOjGe5LVhaJkDaYfbduma10LZYIiBUhfmmv4lLHepCBS6Hn7gZ1q2PoPOaW9nTTYkRBCxRobYzrDPTEJXNGSB4AzWn3iQTViRli5SehIAJknGbpO4Yj3lYwKt+1fsnAqZXR1P2NV5Hioq9X0hygTxxCxwG4ddeEwXztGsg//hjA610gZ7w8BrHX4ye/GDHoxYNb3yu0+6GLelt6aIyVtxEf6s/BF52z/L3RRb63DaKtEkNFdWMkP6MzNgdFWfudB/TixEVcaXORbB+L7vjlqF6T+pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YcydErIZR/d8pxz2R4h3n2nHXngYFbxWZHipOEK8r3Y=;
 b=yApqFAY1dsyqqFzUGn1bV6R7PZeQrCai/YkZZMVFOO/qv5mNKpe0Gn6A2jnRrOBgtMI0yja3vTLLeMBgyGTfcEPgEh5fQgZqm1YIkdUQvZG7BhQMRnapB5gXuNeOxYRmT+7C/UkJiIwA78rcN0bhDJjftD8u1zqyJnazs/2WjA8=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB5697.namprd10.prod.outlook.com (2603:10b6:510:125::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Sun, 17 Oct
 2021 02:05:40 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4608.018; Sun, 17 Oct 2021
 02:05:40 +0000
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/1] scsi: ufs-pci: Force a full restore after
 suspend-to-disk
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y26sh0d5.fsf@ca-mkp.ca.oracle.com>
References: <20211012125914.21977-1-adrian.hunter@intel.com>
        <20211012125914.21977-2-adrian.hunter@intel.com>
Date:   Sat, 16 Oct 2021 22:05:38 -0400
In-Reply-To: <20211012125914.21977-2-adrian.hunter@intel.com> (Adrian Hunter's
        message of "Tue, 12 Oct 2021 15:59:14 +0300")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR11CA0016.namprd11.prod.outlook.com
 (2603:10b6:806:6e::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.5) by SA9PR11CA0016.namprd11.prod.outlook.com (2603:10b6:806:6e::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Sun, 17 Oct 2021 02:05:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2afd4dc8-6992-4b8f-bd6f-08d991129e61
X-MS-TrafficTypeDiagnostic: PH7PR10MB5697:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH7PR10MB5697033B9B04530DBA88FFB48EBB9@PH7PR10MB5697.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oaANh6c7c+hS86wcOTHFOiCOQXzyhsTny+sqBPWnKInRNDidYAoWotHTRLkRAaCWXQYSUUZ2caYepFu1pctlIK8VGvZtSDNosKSRg0v/NytNyVpo/0e/t7+4CEY5/NLNvGJi1Z7iUAvinebWtS3ogXsdOl+I6ImTWbn6Q1IyILE1gPRCoY9W8lBwUidaUrAZaJEXW8nZOwtiGJyJwU7EpSyRRliof6OFPX9AUz5T3AATIQdkYXLVQVwkpnScCWXqjvNsK/UWsFFfDohFc61g44USmnnW2wktRgtuIJkACvenCXMGOC1Rv37q0hXsgLFfoFrUjVNmYdVmmEQ2lrhTkzlj7i4Lb1+OHUukQfu0jbojCplbgajCJKdTYQl1anxb2CPB6122QiA2ybbrrzTpuX3KAxvQM64alb8ZMZ2W0HdvktVPXIVu56I4KC1keF5U63TiCm9UWVHdoxqkqAooOXfMj5MoUZ/oM9HDQGdjOIjtuVZuPL6ZdR61ecCdB+pAlCRPUyPstzzriJ0xpynKi6knSokElPWnT+a/a/HOvg1hrbqDr2Cub5KS2JtqToa18iUAFfjZAX7tDEbPbVbs6lUEJYvoQEZSHH/8/+hDl/caydZPRsNkAWYrzOZ/JDG1XmTYGD921zyaiwRkc/799+MC8qq3YuLqj6kG5l4cYWAYZ3jmhne8WVs7xSkubUcJo0T3d1d5gjYM+27GAWSbIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(38350700002)(8676002)(2906002)(15650500001)(316002)(956004)(66946007)(66556008)(38100700002)(55016002)(7696005)(52116002)(8936002)(83380400001)(66476007)(6916009)(54906003)(36916002)(86362001)(5660300002)(26005)(558084003)(508600001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sfTsdcQA5NunDpkxZiLk7CV0TaF0WGuMf/qXUSicUIvuw3bXsuK9wX9RMjy6?=
 =?us-ascii?Q?elpLXBmNrr4KWjLf7ePmKJ22sefsvP+qOjRrg2qAssi1+ZNAswgvcnI7MYSW?=
 =?us-ascii?Q?ozj7zrwgQO0Kpc37WzcrxmmyvKuqnrU5F96H2fDkqQw8+sZHJ4A9+/sDFgb4?=
 =?us-ascii?Q?xBC0EVW9Pzrh12D/YoXs3VYbUjVD+MkAuF9traniYHW6cZ2wrRTqux9UdQit?=
 =?us-ascii?Q?F2oJ5R8LTU3EpQ6eeSefZgGGvGUSXV8hfLYVNJv3RiOo/eGqSkNez4IU1ghv?=
 =?us-ascii?Q?pWSESz5j3J1oygp9jnKVd5cI19frwH1M90K9LhcdwFWfJuv7oCRon5ze2ojI?=
 =?us-ascii?Q?vgcXCmgSXtd6AgwcWIXhSM9YD9VnsXPn7+0IrkOzWic999AcmAIOdF6zkK9e?=
 =?us-ascii?Q?nYTSySdYpUSs1vxUsgJIdW6c4IunBK/h2e1QmOR5LzQY9MIptKu00SZThT8t?=
 =?us-ascii?Q?VUvOqiC1fHT17DBE9Hqk9MQkB8Gi3DwspA9O03uEHAzKwi/xFJoMlbgLmVWg?=
 =?us-ascii?Q?VNWACRvYoeapI+ea7i7MakdGOJJAb+MIV6SGCmWyfEYfnqFpKCiK91tzkSnK?=
 =?us-ascii?Q?gLDsYt0vJTxQ7elUg+s63FYJGCqLgkADdGgSac+0SoUowyevqHi0gCg5fRad?=
 =?us-ascii?Q?TAibvYmTbeV8munCnShanCKQBGg0CRCOzXUwKSfLAlhRkhA9MluPAHso78HS?=
 =?us-ascii?Q?4eZdFULGr1JikQQclynVMY1nsJ6whbYcX+DlYoEmlhObmjDCAF/Nycg63DBm?=
 =?us-ascii?Q?lOMuwiCuGv3aWsMa85ZUqJTFPzVLTicyUziv3kPu6k0IZFoAXMBjMJsNmDvC?=
 =?us-ascii?Q?l1Tnk4EbYqRjR4L2hJXMEDILNitnAb59NCmY7DwoLvGdMIjmIqQ9TUFkJdnu?=
 =?us-ascii?Q?49TQuhhxiFBxncN7junIZuGQC9oE+WElHiLp2PGuA5l6+CCmjo8CNlLBYs5x?=
 =?us-ascii?Q?PmktKtE4S7gI+BOjlpOa1X4Pu0Cv2YEMwYrnEk1ccBpTBHWCr6dMf5TLUKSG?=
 =?us-ascii?Q?uzLrW5qIcgucaljF6AoJeuPPKp8kooSzN47+rUOgFd735sPL9d2R13ZJ1nmS?=
 =?us-ascii?Q?JEhwmsoyJ3wd6WoA86ezGnZL4JznLq1KPciW/qrvWxXx4iBPeyTshkbSiacB?=
 =?us-ascii?Q?i3uO3/IX/qynVchqFSfubzoR01aa0mkw9kY0kG+oCGAZKaKR0GypPZEOaxqd?=
 =?us-ascii?Q?QPmvPYuh0+c44+JEu4tG7bODsf4ExWUYW4FsjMn8M1OGTpoyrw/wv+dmiajo?=
 =?us-ascii?Q?IXAVOS47i1iN60XybLS71JHncZAHw7Yyjca42OlUbBSy+y3GmCh7j9MnMRNi?=
 =?us-ascii?Q?GaHy3lEowUDNjwSw5fJa80DE?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2afd4dc8-6992-4b8f-bd6f-08d991129e61
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2021 02:05:40.3933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KPxmPb43gIcxlSAv4JT75GGY50rLuM3SxXagb5kPMzuQW79YdYSDZSxDayaECTE/X0iWKyYm0vY1cNl0vaE7s9qcrx5axWhDCORVVZK/Q8k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5697
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10139 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110170012
X-Proofpoint-GUID: t53OcxFPvm9sVDzKw14wkZLZ9uCcS3PV
X-Proofpoint-ORIG-GUID: t53OcxFPvm9sVDzKw14wkZLZ9uCcS3PV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Adrian,

> Implement the ->restore() PM operation and set the link to off, which
> will force a full reset and restore.  This ensures that Host
> Performance Booster is reset after suspend-to-disk.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
