Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24295C48BE5
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 02:31:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 039F861369
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 02:31:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbhFPCdU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 22:33:20 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:13510 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231172AbhFPCdT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Jun 2021 22:33:19 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15G2GaPM017512;
        Wed, 16 Jun 2021 02:31:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=qYBTILydxqj9PLQaPRkjGHuLbOVB/nHqY6/fydS/wzQ=;
 b=HdRW8vMTOnPqiekpe3TXJIp6Y5rYBVp2jHxYWq95cYPUkTMgJd4/0xUdBTO92NOcV8ny
 5HabnwmnYsx/mx6dfYG6QTsg3dfO3raDhIWbSFn9DsGbyOppkuQ9kCIMoYtwfptf+otj
 4wsXsWnyWiuyenaQVZDlie3dyxGoStpQ3rN9Sos94sV2Cl0nza6UozKmXphohC6Ju+7G
 nATIAUzDrEffuFtPY5uGZ/npaQt3QN/9gI/b2TZjN5INJZpmRldQDp1nJEVfOrmtqRmy
 JbQNJO6rjlHi8uvVjXnTbEcXVAespu6tm2bHaQtW6VS4Nc4EX8s61bbRQRMhst3wedQX RQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 395y1kss4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 02:31:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15G2FT1s082043;
        Wed, 16 Jun 2021 02:31:03 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by userp3020.oracle.com with ESMTP id 396wavr5q4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 02:31:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YQzEId8tlleO93yvLqrzGrhrXIbVzJ2arWwHhR2ZKkY7tQJHug/2PZ+YP6Vyk1+5uGL6qiDPK9obd8x1KsQcAob/jhU9F9Tmv1hM45hoh0lB4JF//3ghBP6zRtvkLBM6/G5LHIwcPZRUd6+ivEVHEkQVtIyrsqsx6dOs4o8VkyVonY6+JidHfd0z6vPWjQL9A7JpEjIf3s9Cr2cTUEFGisron8rFFErkouMDaQiMeTHZvJJzOZA1gDVaRUmzQ5NkbvGJdNN1xDvIDVqP6TEIeILjdV1vybymLHEEJGk4ybVH5Q7h9DXt3OEfQr+8A3r4ArkBfRnNYdGhmlK6DdND1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qYBTILydxqj9PLQaPRkjGHuLbOVB/nHqY6/fydS/wzQ=;
 b=IhC/pCOl8SZX2P6glAyCEE/KVctFNMe2yOkOcnP3Y2QpOoOPA5LrrmeULfQUZ8bQShUiKRWEu8d6xpN4oCDohmbZRlcasZYFZ7swA7Pl09yod9zBx2B0s+GxjXtzBjzAuVvICa1eSozSI4MoXPv+RY9UgvKuZ0Ib528QNYFKpC75pdOvVT8edY+3Z+gfE9Yy0mcAU83Jlw2R1hpqjVCT7A4ZeWn72rarZcgAnG3e9WrUBWVa5rfFIix72mt8VOL9hYaf0H0IWtia7jnbd/SwjXOxdr8uKRnbUrqQsk8u2poswY84qPoMJItHfF3H0NJsdBr58YfWJP37N3IWMQ2avA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qYBTILydxqj9PLQaPRkjGHuLbOVB/nHqY6/fydS/wzQ=;
 b=vYeESn2LapUy7Rq4XmzJJcCOGZ4l9i0csAd/wLJ3VP40KixLoduNhAov96tWKb5RhoJJvbkBXVTKl3D2VRvkllhgflh4obvPKCoRGYwsIrOcgeobkN2Tnac6VGpQTsbAz+l8hCQ+Pfv5OM5qGPlLmtyBAVRDDETSSJACRMHmc40=
Authentication-Results: hisilicon.com; dkim=none (message not signed)
 header.d=none;hisilicon.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4806.namprd10.prod.outlook.com (2603:10b6:510:3a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16; Wed, 16 Jun
 2021 02:31:01 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 02:31:00 +0000
To:     Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc:     <linux-scsi@vger.kernel.org>, Nilesh Javali <njavali@marvell.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qla2xxx: Remove the repeated declaration
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r1h25yn8.fsf@ca-mkp.ca.oracle.com>
References: <1621843402-34828-1-git-send-email-zhangshaokun@hisilicon.com>
Date:   Tue, 15 Jun 2021 22:30:57 -0400
In-Reply-To: <1621843402-34828-1-git-send-email-zhangshaokun@hisilicon.com>
        (Shaokun Zhang's message of "Mon, 24 May 2021 16:03:22 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN7PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:806:f2::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN7PR04CA0018.namprd04.prod.outlook.com (2603:10b6:806:f2::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Wed, 16 Jun 2021 02:31:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15dac0ac-16ad-4d12-2ea4-08d9306ec7e6
X-MS-TrafficTypeDiagnostic: PH0PR10MB4806:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4806446FF5788EFD18C779948E0F9@PH0PR10MB4806.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zr5oMPqsyLSII5hX/4y//MigSqhQZQtTL4GJW6Dp6NdjGNkfgyhOn9Ex3nyBbQrvxq9O6ZfJamlOxWLbMfOrkaOxmjbb95HK7k7bRCu2p9X4WV4EMmoBidEVHPZsoelqA18tHJZPLg0PNBSAShK7DKvKiU45aGaZMRPwo0hRSjABnY0zMHRwUbhJq8POiCYbGyIs703L0CY+JXKKh7F/W6CUM9BNOJWHEFcVPl+dnT2af8cppJnJ4VQXw9OlISQkEHPJdOHK/4ryEEdDqf7YK8YHXRXFE9S8MENDi5ZraIloGs/I2x1214qjgCtAKMV91NmAl+6eqsRxg1C5ZMWLgCWU524SZ7o4z/owCvAm40eaoEHmmDe0bPr/2VfM6Ls6b+oyTE2zvrfxPzRofOISC/phqqGNvMMX9kLAV/YIE2BJxqC3HIYzE/3ivBEssHtmPNt8sTJIC0U5li6is8ORmOvaj3z6VoFt3IIdGAJdD6dhnYaIaUQH55bhv4gvZbvzwE6IvcAGDU7TPAUsnaHfD8t3xnKt7qHEtGOe0GOwsvjEWe4DfxCImMU5nOB/03PuoHnGggPHGzZL5KKmysoF0puJ+Okln4LOJ8vqlYR0FTecOAe4E51SJ4adNzglmbQGj3XA6dAWhJa+2ZTxs95C3d6101jbTpEfOwrMp8rEuEA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(366004)(396003)(346002)(376002)(558084003)(6916009)(36916002)(83380400001)(5660300002)(956004)(4326008)(8676002)(54906003)(26005)(86362001)(107886003)(52116002)(66556008)(7696005)(66476007)(316002)(55016002)(8936002)(38350700002)(38100700002)(66946007)(2906002)(16526019)(6666004)(478600001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ro+T16i/ENLM/LD0dAPL+Qd2W7DuTp91Tq+2rkXiVJsVYqgqqEEFJ5Stnp5H?=
 =?us-ascii?Q?2OBcRV6ISJNFLw76foJpUU5M6pzmK4+8mF4fOXRYfqC1DByn1JB4KGskRJTG?=
 =?us-ascii?Q?yXhj0ByicbRBkBSdJxiIRb7VC1IcI837a8N86einiU3lRNeQrqeKcVPY5rwl?=
 =?us-ascii?Q?9ToS6lOQkvKK1ukyHYWPesYChp0fwRWbTN6pyGQ7d43Uwu8wOKRc1yuJpyvN?=
 =?us-ascii?Q?v0quQPSrlz5iz11e+u/Q/vvk4FWrpp6EG1T9MkIK3vf41i+hFNkuVjVh5uEC?=
 =?us-ascii?Q?9su4A8NHWjrCBgXdYokbzCy8drQiUpmv4jNPjV+2SWNxzYkHIxm+75xjNiwp?=
 =?us-ascii?Q?u84PAXubMYbeo88olJlCL+RtSey5M1b2Xvxr2+luqR/0hEtY1POJST3s8bvK?=
 =?us-ascii?Q?Lc+NZ5Fihj2kJCkdohjCayS0Qkj5lk6uSDW3MTsRXGBylEO58zWYELVFnFcN?=
 =?us-ascii?Q?v3dbRUUrwQMpiuv2i+bJrGS/knFqA6XSNEjoMGV6bMisM9lNp5F/fpEnR1P7?=
 =?us-ascii?Q?7d4My/m68dPXXfDlPURTT8HKtRa2duXA7JRBmzfHwHYgjDyrz3HQ+M92/8qN?=
 =?us-ascii?Q?t3JTxKmCcRXsphx00JoXEjdIR9+JURD1iWAkFVPsPH/xuPKefIc0B9NgXKno?=
 =?us-ascii?Q?s+tanpxerbBEP5GnI/65u2PZfdb2ek62xOMVczbQX/rrcUdIfOod7ZMJ7IGK?=
 =?us-ascii?Q?m+CEjckUS8LpgnPXeRKY5fsGMz/jJ1SxBAOgnV2G+FqEtc69OGO5lchhBZjM?=
 =?us-ascii?Q?LLs0rZrI6fIZfLbJg0dUYUFELRVnY9tkBA2fYTtU9Ysxxc/+/99iFCaaiwjL?=
 =?us-ascii?Q?SW4pOEuPIWStQO68GZsOAdpnB9TER/id9pbR+c3NiKYCx0E4aOObTfSRa2US?=
 =?us-ascii?Q?wU6bleW0PFfz8oEab0kMSwzG2RmjV2U/z5m4NqWAkVvzzEUmVYGYrEXwAKGV?=
 =?us-ascii?Q?OxplX2EWrAtHtFcJmRxQPtrDqEpkY5TwsPwD+Rqj+mYVDLhm2s0fJuVz0E5T?=
 =?us-ascii?Q?0OZE4rxIhTfKe315ub1svrz6m7F5UHXSRml9SMcVzll6LMgTSDYsWVmPX/7Z?=
 =?us-ascii?Q?NtVoim/Jdi+1kgJcQbhO/ofBR9/lWN32AL2QT+HIsr38F7NTtXNEWX9Gv33C?=
 =?us-ascii?Q?sNiDtKaS+XIt91ahy5EhTdcX/2kqSyW0XQKqJLRWcct3X4gtP/gV3prdBJ3C?=
 =?us-ascii?Q?5WlhLXrraWxTLODi4AIJEQmNWQ5hBdGGTIqSYpVZ8+h9P9v8Abj6eLSLphLc?=
 =?us-ascii?Q?SdGn3gp36Tfrx4qgr+7kcb1O0pJG8m99xzLa/sdl4Senl19O3eXta2sp2zkj?=
 =?us-ascii?Q?kkHrG8WARoPLbdPLE4hB2otW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15dac0ac-16ad-4d12-2ea4-08d9306ec7e6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 02:31:00.8669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zx6Uh1ayP8FGYTDl5miZavQH1gzRHwTa2mU0frUvnVrqEym/z7aPFUd8sO0CCdJJ6vCOUcsOPoReq4BZncNkS+k+l0nqjoXXw4pMq7CRvsA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4806
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10016 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 suspectscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106160013
X-Proofpoint-ORIG-GUID: sR77k4J61wmlyZB0X4SmF08ZwkWEdbkX
X-Proofpoint-GUID: sR77k4J61wmlyZB0X4SmF08ZwkWEdbkX
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Shaokun,

> Functions 'qla2x00_post_uevent_work', 'qla2x00_free_fcport' and
> variable 'ql2xexlogins' are declared twice, remove the repeated
> declaration.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
