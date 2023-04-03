Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3B60C7619A
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Apr 2023 01:59:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbjDCB7z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Apr 2023 21:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjDCB7y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Apr 2023 21:59:54 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC6D769B
        for <linux-scsi@vger.kernel.org>; Sun,  2 Apr 2023 18:59:50 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 332ME0ri011618;
        Mon, 3 Apr 2023 01:59:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=5ecZYN5Snpb8q4RNpB6fyZtcQt1cPDOoDZCYA0d6GyU=;
 b=PSPKr65u2zCE79cMUy4t/j/3QM8dvC8GLv52RQ8l6Y/tgBqG2umNiMMjYRmryLltHYvy
 2DPHnT3122mTEhLYqcWs4+rHTFMA6DuuqpT6xvaJ+aorIdotrw/In86U6dlLbMeXn1eF
 lptEmLhnFQjrNJtYN7bjuioQEsVmtPcITXvSvkFA6PQzLq7+cQrBrk2RhGuqdqVpIu9A
 /mb9npI6AYROnxNjgSsWhYrCl25JZ3Ba/iwSIdTgGP8TCCO4MLAd67w/h14IuhKWqe70
 u5RUM60+5cQTS0kCUULL2VJPCSjMj/IgHwYrXmMPwnGeExyVI+vqMxSHiF7dFjxlW28z Lw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppbhbt1fp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Apr 2023 01:59:38 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 332M0D7G014402;
        Mon, 3 Apr 2023 01:59:38 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ppt3dcwau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Apr 2023 01:59:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N34T/Lgf1SuatwF8SVO4p4WZpOmHyYIKN6hgQpT2PPBe4viHse6T1iIzIEyWzMwQcIhOPan7tC2IVG/S3wh9fbLSLP8Np78ujK2iAGJXksUVGFFRiuuQF1n6yjJ7+VQ0R+8G6aL8ek5Xo37vo4F+nelDGQCJ5aJyhZZBL8AZqSOAfTvUxhTJTrdH8hfgQuVm6ecTGNW0+8yKdmF5/SsF17SIdtFBPG3rKDUmxjXJx+jf9ZsrArO+ahqmUdC2sI/2bwCf2/iPo9Ezi25XRCfIBIfxQ39J5IJJUP48Tgqj9NKb/VlvzB/5//nY2RW8wxWdOkWBGZmLc6eh8cQvz9n4mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ecZYN5Snpb8q4RNpB6fyZtcQt1cPDOoDZCYA0d6GyU=;
 b=UAzszBdaXg0IaIOMfKuxuuCArYEoLUn/RnjnRyFgE7Tbzzx7WMf4n0U3kXP6sVs9wMjsvlCzLIdaFy+Skf0C+mUOGrRldmkH594aJgNhYhfBeQew0YNAm2NQpfzY0D+L1eU5Yd8DkpGylZA64EeXOQ31QELjWZKFO/HeZ4iqZSpV1SG2jCa1X0fgJ7kpXSOWsTJSIBelTPaaxbBCwE0hQ8n7zQlyHCAeY/zGnhO+r0GMO8f6vWMDXs2RQY1zDsKjaDoacYRdEUUfaLYcJptV8+ncJCL0VKe0cAHEMZl+03nycjDxcfhzR2H4tQwqPWGKPeogilubHzuVU5l+PxcNqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ecZYN5Snpb8q4RNpB6fyZtcQt1cPDOoDZCYA0d6GyU=;
 b=PlbtMi4uTv75AWBDn+Pngz72IWbVxoTw4j2Es+PWG84vZrXUL2MsaZWiCNYOC3rySHU1CDpMfx95MJdJn67arZN+jr7envLbgu/35HDxNgnE7LIJvdtuqsYlLfMkIJGMbQnS4aaEFdaxvDWJIDuin6Vr0lwUiaKPd41dMo0+xxY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM4PR10MB7525.namprd10.prod.outlook.com (2603:10b6:8:188::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 01:59:35 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6c5c:93c2:3d1:5e98]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6c5c:93c2:3d1:5e98%6]) with mapi id 15.20.6254.030; Mon, 3 Apr 2023
 01:59:35 +0000
To:     chenxiang <chenxiang66@hisilicon.com>
Cc:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>
Subject: Re: [PATCH 0/4] scsi: hisi_sas: Some misc changes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15yadwwso.fsf@ca-mkp.ca.oracle.com>
References: <1679283265-115066-1-git-send-email-chenxiang66@hisilicon.com>
Date:   Sun, 02 Apr 2023 21:59:32 -0400
In-Reply-To: <1679283265-115066-1-git-send-email-chenxiang66@hisilicon.com>
        (chenxiang's message of "Mon, 20 Mar 2023 11:34:21 +0800")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR07CA0081.namprd07.prod.outlook.com
 (2603:10b6:5:337::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DM4PR10MB7525:EE_
X-MS-Office365-Filtering-Correlation-Id: 77a38567-9be8-41a8-aa01-08db33e71309
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SoWXfJXjD8WNjhteFGODP5X7h+p7RJA4NT4QAeKf1nBXEm5zEgbeQfD2iH5K+1RuOuQU6Y35L6dSzCheGXeARJdbxiXs3fqay7WA0UGB0wJLPjVZk90ZSM6O2FTrcHlizDckGGecR1wRCgFYkktvqudhrxf6TUmJpawyIWMDVLKzxn1tiD3oDKvVy+/S9/gfWsRtcw4m/J7WFdh+PrkHF9WOaCE58M530tXk3ylum9YCv8uGoQ1tbetjYvb0KcmdX0Cs2BUQAaD8dDmNY+r7df7BeACPuhIDAqZpq2kQS2zwC+gDwmgbzUfGYsIma50jH8HzOWiYYUcur1oDf4ZlS2hnQFx8RnL2MMEwn3jPOe9FNDWvvq6+8VyHd68AO+TcD9CeChBUcdMTNYJQ4CNBFAXrfwNW8SyctUBwqrJSx68pNEnwTb1gSf3HaLTDTnqgSb6Dl3nT93ZHZt5u9iOCISiocHJrIlQ4DbGGAtHScgkVc56ZZwIX5d8uLj/RHkS5CYY/jNgF7dBl27fADbDuSlWBQDcjGwRQ+Dx+Z2MU73/xkBvQo4MHWTylwD+iaMYo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199021)(6916009)(4326008)(8676002)(66946007)(66476007)(66556008)(316002)(54906003)(478600001)(8936002)(4744005)(5660300002)(41300700001)(38100700002)(186003)(83380400001)(36916002)(6486002)(6666004)(6512007)(6506007)(26005)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6muv/csAOwJ99QCt6N1ouscyJuScehiN5JyJV5WvQQUVX0zs57FJW2VuTn+n?=
 =?us-ascii?Q?IGfDxOGKTQMyBhcMoErag5v+4qvt2C3FlgPRi8zUqPhYcs3VTDZIgyS4dJRq?=
 =?us-ascii?Q?XTTBFk7jKq6FUFTQ52ip3boaG2LKQ0FsB/kiQpW2SqqT/RgeIzgQAnSQvyG8?=
 =?us-ascii?Q?fhwA7AFACEYyiSAxJ39on83JeqjCiYe+/iiuDEj0J+nwQ1GEND3GBFJ86dol?=
 =?us-ascii?Q?QDXBshy0tnVC4+2geKzDd5pJdOZMoC+K6jhCMAK9N9ZKD6UIfroj7sbpH5Rv?=
 =?us-ascii?Q?KXUldnOyhMcnlEyqEhQ8bhETzy4Z1RTbmii7D0SMMQFAHQBpPh54P3zAUbqY?=
 =?us-ascii?Q?cu9ijewsfGRTAKGoy00gZ0QZsk2NyNcexlbZ26k1RY07jCIyyqzKRN4X5rTf?=
 =?us-ascii?Q?zjTSWZnqVOwTgKrTF9buX+yT1jixQ/jNx44zhqoeDCb8egxSUCnhIcxoiK1Z?=
 =?us-ascii?Q?6MJQq84V9jNKPsaASHPE9CjLq7nsEW34dEe+ujy+0jxB/yTRh3IRbsbk+t/t?=
 =?us-ascii?Q?xwa9WeZPmxmUntq8g6hefDbsRYdjlbgOjaJh9eHRiCBMxouUCZiF8hfRAMbz?=
 =?us-ascii?Q?qWz/qegPgzBtDbnJz9C+phTkFUxusgFyuuVBXB8RVKzkuQ5xpUtpC+c7dA+O?=
 =?us-ascii?Q?uu4Tr2KkBbjv1SpIWcTNFeTBmqOQViEgyfBda1YPDjr0REP2aC2d+KAwnjhl?=
 =?us-ascii?Q?U0ZxWdpabivu4JocrOzaDTJnm+Im6tSB/cVb9zKXS39nwxNtXnVqP/bdJzbO?=
 =?us-ascii?Q?DhqslEsekYoDA9H+kAh39QbaXZMLp4Ak+ZnRIgbera7Omq/SKTW0cZfkoS30?=
 =?us-ascii?Q?yexbRm2LoMcNYzuIgtY9I552h3oZEZX9f1KBzB+ekdUtFYhBP3AfOcwxHuCi?=
 =?us-ascii?Q?mfeM19gnNi1Aim+tpn+e5dHL3/qCqn5TR3K1/Ok+i/mpdJZX36drQy8W/yN9?=
 =?us-ascii?Q?tog07FvXpIp4OEcXogo/Vs89doM382Ka/sBZSYPDiGcfgmGXn9AK3mgcnBk2?=
 =?us-ascii?Q?HgM98xCqmQQ7N1gndAbaNAYBk8giEXf8pWLKeKLdFUWxi3fZSVPR2YWVSxN4?=
 =?us-ascii?Q?gUFjPlwAGhBz54DJA3/NiWE4mMeG3HKgf3JlPr4QwchJjm2xP9Y7ZYNNVgt1?=
 =?us-ascii?Q?Vi9ayETlEqfwgnOFepCYQMsdVp6ZZPDfo7DbAgJQ1n/THClskCkP2+qLbIPC?=
 =?us-ascii?Q?FEwaYqhqTh/GVMCc5WkFRxnobV1gBj+rBju5TNtD/zePivSxqwZc5In6as4/?=
 =?us-ascii?Q?LmEpmktmBGrtJpsaVW8A74KNcPj468gYa87Qq9iJQZ6gHsmtADgnC6xOKrFa?=
 =?us-ascii?Q?C/UKcb2Yx0AcPpe3n2h6hJsQSEqhiOnvOoxPvtbCSFwkg+Jrlzylnx8CjHhd?=
 =?us-ascii?Q?sAX5mPXSQfUNXqnnG09OHOpF+0ypWcIkKEUyNtZBFH/b7i0BvhxQjcIntqTT?=
 =?us-ascii?Q?dkHHeA9pfkEGnYvfaUz/4ZPBNLsNvRBskf6rNXTsxhagtbnM25+8cmcMyuFi?=
 =?us-ascii?Q?1PiwYymeXIt8qq8vJ4MZLA99hAUjQ0wOG78+T5FGC1LWKXl0Jsqwh0/pKv1L?=
 =?us-ascii?Q?0JMZX7zuJkMEJjDGv72eVOkW/zG+NP/hGBk1e69znDUQ9tu4aLVrKk8aOU2E?=
 =?us-ascii?Q?jg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: UU8Kd5v4msB5qTkpqTik7skpAmvS4diBiYLvSDfgFQAJh0CMTlQgvcc2lB17j9R92m7c6E8IRYWnlL0NpkaWhGy0HQ/9hM4agHm01XIwmMjko4LqC0NmiLDVurRt0EbteUUJR0ZVAlpJT95q39tRURYs87UBD5I0EwvBq5B6bwsaXzDDd+hZb3zPeDpFiUVfhabwz6duChL6uQpbP2Z4BU2Td9Xa3maIAgL7UmLJvGjGWJjkZ1/Ji+XZQKwPNFdaKMnjFkRY7QgRdoi6Y6CdFeHiCFYTzTIzgjhWh0aI4PbjaurE4Q9hXks/cQfiSnm+CWdDAKJ0W49ikk+JIJUKKTg1A0Etmd6nbtSNNWXbhfCU3+6fc92Vtd/w3z5iN6uKrMei7B7ZVn2Ep0WAmZqX0Ab+EiqOvTpe0lPOXoyObykM1k0vTVwbFl5oY94lAJK2ZLzwpT9fUS9eIfXPoLH9E/O4LQ+QfNfp3Zc7DhWIGA1sPxZ6Bs2fiNuVU6eTC+vq/gfC8hc5MEyb8x+FdwUUT3ocDYtjDSc+KhWtM5hLRUeit4yZDjkubmr7XWN+QYWzH616cxiHn6d9QxvOsVavRsnWi/iHWcnKUbGVWOpAHsVT5ryI5Qenc2pS2YItFPpBcqoTxxi5+HP0Q37x5NqfJJVPxu2udrZRYoFaSGLXfBgFpf9x2F2nlD4UncH15cGYXsaYe2t/U+LwRRCCd8Ik2gxrmBrYl7OO9981b+X10RdrixPzexWj8/HHeM4+UYktCJzgLpJ19KVIM1/FpnMvm0ZtWr1FiBGAUdsKS47U2ajkf/wyOzLjh2wIXBbc6XTVBoizf8GFFEBCXNctrpkXOBG0eY8/Z9G++W++77opIjI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77a38567-9be8-41a8-aa01-08db33e71309
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 01:59:35.4538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S0N/YEMRv4Uzq5VdWMLdkwkaDvlXmulUbgXCAHcvQIeq1U7E4YVowhB7prGb1GcPmnY1yFHCn+9SNK/A1pu6y7ozX/5L00LzA70ndfdj26Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7525
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-31_07,2023-03-31_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=763 mlxscore=0 adultscore=0
 suspectscore=0 spamscore=0 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304030013
X-Proofpoint-GUID: RsWfPyx6WAIc9AEVhT-n6vP8_bIZGiuF
X-Proofpoint-ORIG-GUID: RsWfPyx6WAIc9AEVhT-n6vP8_bIZGiuF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


chenxiang,

> This series contain some fixes including:
> - Grab sas_dev lock when traversing sas_dev list to avoid NULL pointer
> - Handle NCQ error when IPTT is valid
> - Ensure all enabled PHYs up during controller reset
> - Exit suspend state when usage count of runtime PM is greater than 0

Applied to 6.4/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
