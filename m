Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BE57C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 04:16:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 203C160FD7
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 04:16:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbhI2EQr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 00:16:47 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:14132 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229452AbhI2EQq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Sep 2021 00:16:46 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T3Doro001981;
        Wed, 29 Sep 2021 04:15:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=g5Q4iE7vMCHzgFOH/0zWIh744IEoSxmun8qNm2mb4l8=;
 b=h7zkGxzJ7Fs84zDbOfZ6mkfhLQ+eu1WA5C2epRH8ZsPtAGv7O5+vEqhYqQK8RBWm5cdM
 sjsPcCL5hn9tjlFr4AESLUtIe9VH9J6CjdEtCq8XnsAoUaHNDjL9I1kMP5miZ3LxNwba
 P2oCb38u9UH4ENPnc6jvyFCwlL/TmiEHZi0yCdTPALeAthLQ1d9AH6lVFeZme9nDngon
 U2O+F8NRHen1hC41rkNLRaebTUQmVKjYdCgC5yFT29HOi4oS6aZhnUniOAvwM/UMl/pb
 uuJmXztZQWGNwhINriUUidZeXQYMvQP6qRK4Q7Ef7DA8uGA5qmgtRfOaqxaBCll0jHIs Dg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bccc894sv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 04:15:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18T4BeUm132305;
        Wed, 29 Sep 2021 04:15:05 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by aserp3020.oracle.com with ESMTP id 3bceu4up7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 04:15:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l/qd4DGYrMgJQC/vj+J3MYRh1/Y/98oxLeOj9B4IzPGVwnt7UATiWKwANfA5AAuMi6E3j5zXv1gccb9W+lFSlqhGVE+tctkC51ElSSGZlZufpGXZw7VhFTbKlOGjseX5z9EZ/aJVIAsU/0vnU9QH6XzHFU8GYPIYBk+1gO0EeMmv566a1wGKqwnCzOPDtq1YbIvzNfEo4eyi/Ok//H0Z5PIl5h4xmMUh/F/2e5ND50SU5dGUln8CFOTKTywMajw3XlfCqSwQ9WLODSkymiheewhif006m0lieiVzyWriG0nl+MOHt6OwByLYBAD5IVI2zS8X8+9uUizL5rXRXgAIzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=g5Q4iE7vMCHzgFOH/0zWIh744IEoSxmun8qNm2mb4l8=;
 b=DkfhQyYSTqFwiX3oGvHtvmwNc8BKSB9cbljKe+q56YUxu9lVt/nfWqbHUs4C6oOzQBFm7Nvl+Z7m5Xrk9fVn7IHOrPViXw6LQvLkjDo6wtmuHwP2nCP1So0Yvyex/kASH/l6YGhmFiJJ5xitt3k155kofLzEu3iQSpeGB4zhBaVUCD3Z6s476u2QOhWui4aWV5HZwdmXEGl9yiyUxjegiat/aHeRl5bwLd8dewBHytWGcvrFHSsrVT43Z0vg6lZwOafYd5K9jYx98jwMIRcjSdxGiOBVS2j+ytNteqWsTr/GoVPGwUAQpOdoZBPFspzzaTOpy+73CrpzJLMILaFpLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g5Q4iE7vMCHzgFOH/0zWIh744IEoSxmun8qNm2mb4l8=;
 b=iZid7OO+CI9/Toxe3Xbcs395Lw/QrkPuUtlR4mXB3sYDatlvNi6pgDB30BMeb9B0Mam5snCNXxca+Z9i2f7nnCfW0EM/Cn5+V43Ca+FY+PPJrRt0JfEgAkDFh/t8Xgcoxx/7dJ8wQsv4miiZPqKIH5ZSx6egCiEYylQGaH/sC98=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5644.namprd10.prod.outlook.com (2603:10b6:510:fb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Wed, 29 Sep
 2021 04:15:02 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%8]) with mapi id 15.20.4566.014; Wed, 29 Sep 2021
 04:15:02 +0000
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 0/3] Fixes for scsi_mode_sense/select()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lf3gdns5.fsf@ca-mkp.ca.oracle.com>
References: <20210820070255.682775-1-damien.lemoal@wdc.com>
Date:   Wed, 29 Sep 2021 00:15:00 -0400
In-Reply-To: <20210820070255.682775-1-damien.lemoal@wdc.com> (Damien Le Moal's
        message of "Fri, 20 Aug 2021 16:02:52 +0900")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR18CA0025.namprd18.prod.outlook.com
 (2603:10b6:806:f3::29) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.46) by SN7PR18CA0025.namprd18.prod.outlook.com (2603:10b6:806:f3::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Wed, 29 Sep 2021 04:15:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7d29966-76fb-4752-05ad-08d982ffb5bb
X-MS-TrafficTypeDiagnostic: PH0PR10MB5644:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5644AF4D12A5618338F386A68EA99@PH0PR10MB5644.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8frruDZk0drjH0ITRY5/yfYwNQF+RXhr7Tk6XFPUKhMxGaMghbzX5kFq5yhxh3Yb/m373+p3vP1A/RYsipOvku1XuB1Vqq4VmKGPuIXnGdPj/YC/oLEgdJ2vHLGX3jYtRcxdzdkYCfWXUiTY2YVBPTX8JbnPjA3TQtT/oZwZkNZMhUHjuc2Tp1GisvS25HYr8ATrgelm+8vtzBh9/YUsvxuo4tYzvF5Ed7PPRQGJTYTbaFhBRnEGcp4SAtUe0pcMHoP3ZdtpWWFZ8y9+7djiDvOZcSb9wBhWCa2LEfyR7xNqbKbKOscAAKgfZwbtl0/6cSxaKdJn3JDcn7ZySgF+TXr4vqrSNdtMGoAJdp7LcJcLPAns0mFj31nNhnNl1umsfNtM8gciJC7OFJZB78+7vADifCNkZg9dZNAaIFheO8LrWXjr5oX9ewTgpMV3GFzJAxXAvCaIZ4YzWlPSNHxOvecSh84VyVGdfJjl+JMtEM17UCm35DFjRWfwCHRvgxZsAGTOa5OEIf5pibkMzahP5WCRGM/VbAPajjRp9cyeZb4obChRdcBEAyF+EIEikr0GvVRrd8cM8cpDqZCVfA2vGFGD6Ko2GtAGRj5uuMa8VNXAclaR1MbZv5SiB8PNNObjjAgWBh3Tx5nvNJsedDvL3IHAJT1OntQLOe2NoxnWyFL3tR4R/CWSu10HXc3KKq0xCcqLFGTqRiRb4nWSAxcuC/j3J6Z4U26squmC8ebfB69mw0cFVu2Jm0hj/HtT7Ko/M5TUVAhxfAhNQwUj35SAQwyBOqXSSkhrdoKyvNV6DDc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(8936002)(6916009)(966005)(4744005)(55016002)(36916002)(956004)(38100700002)(38350700002)(508600001)(66556008)(83380400001)(2906002)(26005)(66946007)(107886003)(4326008)(8676002)(186003)(7696005)(5660300002)(316002)(86362001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z1qZN8AuSEdiNXNfAY842nz/HR5jKFFN8hXGapQdCaJgilm0udNns4+I1sID?=
 =?us-ascii?Q?nYgmZIQC+pbk0EHp4DLPLIzWMUJjh3qRY5hyZtgKquvyixm3UiLLkVEjv32S?=
 =?us-ascii?Q?5zcIGNHvxkB/dPO00lisR8Tr3efFt9WZ+007Y7Xh3jo60okbdqwEn4VzMB9E?=
 =?us-ascii?Q?xPE2JeZbqTDaqHU9Y4aCcTIshAODILs/yMBLWVBefS4RH5ZBKAc/HYN9Fs8U?=
 =?us-ascii?Q?A5DzWYdvHwd1TbfLKcysopLBfILju4iVtVoIUITbqSPSodqjMLlCGkj9kYRh?=
 =?us-ascii?Q?0JKti7Ovje1xR0XUhWn7v9GLKl80rAlRKZBHa8c5c5sTqaongzUxrLg9F1/z?=
 =?us-ascii?Q?vQ0b7x5/g0V5C5XcErPc5y6+2Yw9wT9v+S6ZtioJiO+cK1ZHOJpgUbIffGFd?=
 =?us-ascii?Q?3gVBZ2q1VeS7+AwiaE191FJotWsTEqfi9NQsRho9Z5cWUU/IhgYmcyLMYfMF?=
 =?us-ascii?Q?CLax5bg0obAeWJzlgRdfvHa8od+2TtcFGgl1/qAmGDzlu084PF7xMqCR98Pw?=
 =?us-ascii?Q?k8tY6nnVkviS4AnMGRL67MWbiLVBJfbyhH2OpKH7ZmdVx4AvV/W+afAAgXQc?=
 =?us-ascii?Q?jlPY+0tqfTiuQe8N12mjZnEdVlaJQqwGGot6MJHbKamh+zPb9U1W+y+ibIqz?=
 =?us-ascii?Q?0cbqiDSrx2MaSe9fpyFXxeMNDKds/nBnFS4T2SU/JwLr7Wb4TSQIm3KztOjx?=
 =?us-ascii?Q?gCuS+TJMl4gDJRYj+f6XNOwU/kdPZZZvHHjHXvuav2u7yVvUhof8BfAZ3ia2?=
 =?us-ascii?Q?rypoNWt8pJR/WAdqq6lgTfQq6wMSNVwXIR1P48TSQmnNhOnK0cK3bEWdMGZq?=
 =?us-ascii?Q?IcRRJHsD1dfCXAjKw6jvCuwG5ETZPZduftgtte4MTswmNOO2EFv/ltv9EbyI?=
 =?us-ascii?Q?lKkb8CK3l839nwA5rWnOrTQHGs9k8zhGumtw6T9RqrLxkoLmTpl9CQbCPvfa?=
 =?us-ascii?Q?8lQ/9uMYenMCnRWPxlxoYwgsSc1DB6ev3Lec7mSFrsuMgUB2Uac5iuGZmMVz?=
 =?us-ascii?Q?G38kd2kad7wPHcuTMBHePUbPAr6bHoN5VUFK3E2geYJHklzYbXYoQCn3rVqJ?=
 =?us-ascii?Q?sz+oMGq27W7gxbjBb3e5gBGuXMjyrhKnedjkaREGSb94lp/bDjRmzdN1ZBqB?=
 =?us-ascii?Q?K7ONsh4KLypo6aV9t97lfyKs1HUPMe6ATgjQ1TmWRZAiVcHNzfcAOVgbcT7D?=
 =?us-ascii?Q?+5HSu4+XjSSz20nYeNj7sVS6PBowVjDJm6gpDj0nTz7tcFVK+iaFhW3UHzic?=
 =?us-ascii?Q?pdq0wU+18YZroSpF3DCzEQC42h6Fp3GYgHt7NRRULB46MC0ZRZDYvjFZ8+EI?=
 =?us-ascii?Q?B7GH2e2LmaDUIVmea/HD/CWp?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7d29966-76fb-4752-05ad-08d982ffb5bb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 04:15:02.7885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I0+6ijE4qY8pr8DV3g28ejak4vb+QK+blO8IhGeRQNk2gz6DdVeE8rX9g9NmBRQxGjaQiYG6dRn6B8SqD5L5l/ZhV77EZJ9AQXzRP+ZiaoY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5644
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10121 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109290025
X-Proofpoint-GUID: StuHeOQLiLORvhqPdprLHMu6R1_cwXxr
X-Proofpoint-ORIG-GUID: StuHeOQLiLORvhqPdprLHMu6R1_cwXxr
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> The first patch in this series is the formet standalone patch titled
> "scsi: fix scsi_mode_sense()". Patch 2 fixes similar buffer length
> handling problems found in scsi_mode_select().
> Patch 3 fixes the use of scsi_mode_sense() in sd.c to ensure that calls
> are issued with a sensible buffer size for devices that explicitly
> requested the use of MODE SENSE 10 (e.g. SATA drives on AHCI).

Applied to 5.16/scsi-staging with some changes. There was some confusion
between SENSE vs. SELECT in patch #2 in particular.

I tried to clean up the dbd situation a while back but it fell by the
wayside:

https://lore.kernel.org/all/20200325222416.5094-1-martin.petersen@oracle.com/

-- 
Martin K. Petersen	Oracle Linux Engineering
