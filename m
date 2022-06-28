Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2000EC43334
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 03:11:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiF1DLX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jun 2022 23:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiF1DLV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jun 2022 23:11:21 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F4724BC5
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jun 2022 20:11:20 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25S2CA5Q027276;
        Tue, 28 Jun 2022 03:11:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=rmfASSxadh2Sy/k3j7AAbq64lcjXl+GAaXzTvDKZi8Y=;
 b=pxFozu5AJ2/k+vHNErQoOakJIyLpZKd9oDM+g4yUXyacsvSKZyY0yvHhror719AcRr2e
 1I+51BYDTcZuUqMFKZDohOje//d9KfkAyE9D95e1gK9oSREPLs4Cdbe2AWG9X+BikiGy
 lVsEZ9xdrR7gnimB+KZAALehDr0Kl3QXVnTYsugtTZkPPoY8N1e4qA7z2r3Lg+gbgJPx
 cFxOwy6XLBpH6nvTLsXcDszeCMJqV+8AMtMZ9+KqBzzy5wNELSeSlPksraDKgqeC3JfH
 4ECahAHI+GevzoAmbHGoeSRoaC70gVnwq9u3jx/OoIljH+E0x10T8tC5F0IsAUy8+rWW wQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gwsyscr9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 03:11:18 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25S36Ijs023665;
        Tue, 28 Jun 2022 03:11:17 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gwrt1tryn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 03:11:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TxBhx4CQ1ll33P12aOx+BTw7lDsGLzC9YGu1pUPRDC8bE56aeQwPUMiX5ROn4aiwe/ipvg5DTXYNcZYh/CmvyI6pd04A7RaLoAw9uhJ19joyiqW+aVkGw2UQFjKSfOO3F6rewy/sWyNhq6NiDWz3GDOUbcJHZJu0npRhPhIFWarEnlDUy3bBc7BMYtG9uJEoNdCQbKbLFqHOy4C2rrFgFXCmvSxzTZhgxMwxVeyD0vzjUlfOjS29tNiWAWXaBDe/5VxOZFBkU5KxRNfLR/MZfZuwNT82YhCWtxMmyHEMwc/UCdRsmr93WdBlS8TqDg3tH3TpSXAQiM5nEeF5SEd7cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rmfASSxadh2Sy/k3j7AAbq64lcjXl+GAaXzTvDKZi8Y=;
 b=GB8PdZhweTk+N/4QuWFlk3wZml+O+qStvdBFmuF5fTg8mZ+ZPUYn40xKGJwMudzqvVE/NDXrwuToujtcLeB81KupmzG4emTGuThRbDOYBFQ555B/c/U+B++/QmNXm3aNjGj+K8ABnmRFeXniyXNAKEUl5VjrB65BIoY+S2P4HbvI0/v/aIj0ljKdt1uz6DZYIUAVttG42sPXVLUwymuBtJn+PcO6Me/1prtjiT7h2B1A57v/893c5HoCyBdGw93TJqaIal06X8abMzbTwnaPIJtvPmllOq9aY6JwXj50zoTHI6XTNLpGjbVYlnIf3y5rBjHQjTr0KMbwZ5fabDBrKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rmfASSxadh2Sy/k3j7AAbq64lcjXl+GAaXzTvDKZi8Y=;
 b=LRSGlHCdTc7I/LV1ChR9LFqlc3KZmWr0n7x9G+KizyBzpyK8vM535YIBF5xcnwmZC5XXLwhmHLAd0jO1ogZZqrp37O2k6rrFaGOoaFU0eTTybgReE+T9quGfLPj/I07DC0RmA+216ddVH9klpJHrsW/KVlRUQKYK/vML9DNLpco=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BL0PR10MB2914.namprd10.prod.outlook.com (2603:10b6:208:79::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Tue, 28 Jun
 2022 03:11:15 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%5]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 03:11:15 +0000
To:     Forza <forza@tnonline.net>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: mpt3sas and /sys/block/<dev>/device/timeout
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15yklh4ng.fsf@ca-mkp.ca.oracle.com>
References: <3e2b3e3b-447a-a84c-65cd-e2965a3d8a12@tnonline.net>
Date:   Mon, 27 Jun 2022 23:11:12 -0400
In-Reply-To: <3e2b3e3b-447a-a84c-65cd-e2965a3d8a12@tnonline.net>
        (forza@tnonline.net's message of "Sat, 25 Jun 2022 01:10:34 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0209.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f355d4f-2f43-4a95-3084-08da58b3dc7f
X-MS-TrafficTypeDiagnostic: BL0PR10MB2914:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2yGrsjZa4XdCfw/ExH5PtGqWuSmLWRhjULyFuppa61+67BEO+Y7v/ZRTUA6mMsRlRcnzaaqsPlTMaNwsXkj2p5F0GIMRV7q3fiSUC2N0fplveivzFNtfd2y23sr2li0rXbmwLaGQ0fyG5SRpPKp8QqaJ8xgk4vKiUnD/VqjM0xo86/84/V2fGaDTGeIvRrLUngpcXxlpOeICFw5MzSi9we6mS3bT0EGYqTfS5JD4iR6lqJgaR7cxTduU/6ZkRewBFhFx/I1T0lAJKQWS+5IrEwLwTmrYeIgAoEXGItl6FqUGbVH2Mae0J7vVm5+M3CjKpzEG26pzbeLU8tjM6tcuIDKgG4GsXjBX85GFAc2unCjZDIZph1Ji7o4hqW8cChOI5v7NGkt+YAytgMLBeRnXk8cGSoLBd6XYgnYuvtu8Mp/iIGTHNtEAhrxLbvDLOaO0ZYL8fuMJ/9WdjY50scPDiLB/+21uQAg1t5jnNrgHuq8i8k+IgtQV4ahjgRfelOyw+XRU3QvVPQ1W2fAEdURj9bDGDOVyhGxa6aTnzSK2JaJuj6Y8Ql3UHvBVUtstJkRJuK9wXCrloTbrlDbEiIqegYe66c/xlpE+xVi9M/i6Ku03zUC/nK7rzb6L5tSVmPWsmKiRCgnWjBCSJiwaNB1cA0mfDO8yJhREanYkPCkYPyUmMexDLGlbagAXv8ztG21SA3W/CIDLTRM18+itrJFYHRJ/8kzcxnX1AfzZvGEXqFF1S37I//f6l6AErK848dewtcfjgCUVompKAxPfI0WRyWVX4IS8wfA1lAeiK7EqVGifkcER7ntUsArIC5JtcOb7PBxDzSVviuhO+84kOpssazMo9Z/Ahbqo7CAJq4wtSDQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(39860400002)(376002)(396003)(366004)(6916009)(38350700002)(38100700002)(66946007)(4326008)(8676002)(66556008)(316002)(66476007)(2906002)(8936002)(5660300002)(26005)(6512007)(83380400001)(6506007)(86362001)(6486002)(478600001)(4744005)(36916002)(6666004)(41300700001)(186003)(52116002)(42413004)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Pms75XnUtB0cCybVaX+yj+5UQeBOFlqkFfzSxOMvyuTlInexvoebrNnPAY4+?=
 =?us-ascii?Q?iwP97S45IH8lCbscqvLum6VSoo0Q4DMoahkbUFc2lIWBb3mW4P7Pv4rXB/wE?=
 =?us-ascii?Q?Pvjsj+wyrhMCpOKrCPWSF/uFqw70t1mHEb+sfA/Ex/lpHLu4lrfix0iteaFp?=
 =?us-ascii?Q?69SSpnbtS2dsf74tw78s0CpW099NcqlEyxm28d7VQ0KPXALNzzb2QxACAXpU?=
 =?us-ascii?Q?xT2nVOxXP6gbYK/FmnfoGKR2IQsDKrO4MmCTxURd5U/Rr5lyCHqNRlWBlcH/?=
 =?us-ascii?Q?UTk3qRhp/q4yhqw2+evx2EwGO32liR+1iiifmB38iWsj4H2rKp0zc79D+kpZ?=
 =?us-ascii?Q?ivUmkYTjfLWvDJacGvxCFq2CGo7JcHMuhyTmhSStVtjJbJnSwGz78jArlf5O?=
 =?us-ascii?Q?5RJheCCUEEZp8CdDZlvXeTbqYVi7mdkls9hoRV3Fut+BzjFst7uO3YkYQ+Ez?=
 =?us-ascii?Q?roY7oiImWplti8OYlHeNCNMOllSrhvK5c7Ol+sZCIyL2FD66oFgu3AFmOTy/?=
 =?us-ascii?Q?fzp+avMcC0AAKCngp6CX3Gth+xQ3vPoFFI+Wucuhob46gA9AK1viravmqPGX?=
 =?us-ascii?Q?WN7JGzHHn9y1ZI+rvXGYZuoRwX2ir/uyboLGmX9rvhrPxosmuygYv9S0duNB?=
 =?us-ascii?Q?EYlYVYPbe0ZBXunsVY7DwUUg/umEWzzZYRGPu9XnzXUXPr9i1LmkK8Q0lPgU?=
 =?us-ascii?Q?yCV8bC12kJji7Ozhv71yOX26rbjQMuHOX9mM44dRiyMumgsd0F1fXSBjqjDr?=
 =?us-ascii?Q?co85XRG8f2ezD2xExB9tHzPRLSvjHeGF/YfOPC1w4oNqQDKDI7GRerC7whvq?=
 =?us-ascii?Q?kaz7fLefWJR+5zRmgLKGs64Wkdjv3+IH0R89LOxAURN8ST5dUVJ+f1ibyzBE?=
 =?us-ascii?Q?FCkGs6aJYsPJIH45qdxuOg6UStXfp8Vzo9CIbsvP9GrCab7eSNhMi2x7IoYn?=
 =?us-ascii?Q?vNygAzIxr0VhyLM8dwPC0HuamfI/fiiBVmSBIJLIG4S0zFDQUqrdQ7IRiSB+?=
 =?us-ascii?Q?6/30nNxyf5MLjMSex/ueoRAe2bRtBf35dnPwVPPfZwuCgLyfZynlbH15LuRo?=
 =?us-ascii?Q?Fm0PY3FE8/BPeGGDf6JCf/yccZuFXOsVPSGkuZzaHXZt+f/wz7FtU2YsOBUN?=
 =?us-ascii?Q?psDJZ5fHxFdGvByZe9CNaSEhov8P6F9ToYia/UpooWWuyxRkONOybmQLkS4m?=
 =?us-ascii?Q?LWFrLgTVFD/+fVYVsHYufHxs1OpYlBvLVT44Zi592MzZKCrH+pyV5Wnlr1Ix?=
 =?us-ascii?Q?USHYZQ824J7pwedg91t8S8yEuOXXkyEEqbfbVwIk7BXfcJbyq8qs3p96EGN9?=
 =?us-ascii?Q?3Noplk7uKIUy3n7z6Wxh5rzx0Lxbprb2hlwQiULHRhKeUcwMWSIaRMNLLxuQ?=
 =?us-ascii?Q?MG6SlIIlrsHav8wL0OBwnDdlyN6cCHrPgQk7gSPilQNPw73GX6Ti9y9g0xKt?=
 =?us-ascii?Q?xn4mTfJXXKyuM5e61bxhjuOgZ28BaLXcbsFR+M8cLDjdTJgfiDypF9Onkx3Z?=
 =?us-ascii?Q?jdyPMGxlZzjWekObdYmg40s1gay/DwxILClx71Y9vRtZFggqJcnl5qvC+KRq?=
 =?us-ascii?Q?6P0MK8wP/kmccbSuI/4XeQMGJ1gvvCDdgd2SoPR3cfc7r4TL9Wjclh5pVygV?=
 =?us-ascii?Q?ow=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f355d4f-2f43-4a95-3084-08da58b3dc7f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 03:11:15.1497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VEW670DoQGAdh420wUEvdP8CzgP3XQ7zjGxfOiql3wz9Br2+J/Ek4dX8tbZupgu0o34ehULZ+57bSoE7RfKHP1dVQO0hEr/s3INwM5QDft4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2914
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-27_06:2022-06-24,2022-06-27 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206280012
X-Proofpoint-ORIG-GUID: qoG7KSRcZSNEf0k75seaZqzY2TX1nEwt
X-Proofpoint-GUID: qoG7KSRcZSNEf0k75seaZqzY2TX1nEwt
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Forza,

> Does the mpt3sas driver or the HBA controller not follow the
> /sys/block/<dev>/device/timeout value?

Discard operations have different timeouts than regular filesystem
read/write I/O.

> Any thoughts other than trying to avoid using discards/fstrim? I did
> reach out to Broadcom for support, and they claim it is a fault in the
> fstrim code and that on FreeBSD they had fixed this. Not sure how
> relevant that statement is though.

Since this HBA performs SCSI->ATA translation in firmware, Linux has
very little control over what's going on. We issue discard commands
constrained by the drive limits reported to us by the HBA.

I recommend making sure you run the latest HBA firmware. You can also
try setting discard_max_bytes in sysfs for the block device in question
to a smaller value.

-- 
Martin K. Petersen	Oracle Linux Engineering
