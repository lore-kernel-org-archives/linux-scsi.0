Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43857C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 02:59:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2469161057
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 02:59:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbhJUDBQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 23:01:16 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:38836 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230103AbhJUDBQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Oct 2021 23:01:16 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19L2iDHh000751;
        Thu, 21 Oct 2021 02:58:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=BDBQMkUsjJ5Tt3TDybxsB9MY88prDVEtMnVKRQKLXyA=;
 b=nWyAbAlYPGVpYCSL4W7TWsYgBLkm4++JLkQWD57FZpEOtH8eer+QeGMdlYu1kPRZAm2O
 5QmfbtKWFOhUvKsSyMXwGck0OFRkkNv0DTea1qwf4LpLHRL1DEHzcrl2opVdaS/TVU9g
 gkL85yzJ4HdPLumLSgx66lV1iuqMFz9SeMHfFjKheaygDP7JQUYZKER+RqyaR1FDVLZ8
 iJgThuv4d4qVb2SjoG6GOPpp767VDIljzdKdoQVOognOdnEXbyQjzL8YQuJJeJQwBwUl
 xXmnyQHDF0Cz2VuphOJqaE4i1Uqsosrlg/ccBstZ2Sx+B9gjkHS7EHx5SdRsRrnSXgm9 Zg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btkw4utc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 02:58:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19L2pbC1043722;
        Thu, 21 Oct 2021 02:58:29 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by userp3030.oracle.com with ESMTP id 3bqkv12wqj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 02:58:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b2bsISs2MU/onQD9vYjsTarjtStTa7/o1VZS0edT/DFnq9tt0cDnXgFRxtAhFuWkF92nQm6/y5jTeeggF00nYcLmme5fYPrVo4aphYhNLGonAit5CJs8taCobJ7z7Hiy5zWDLOOKa1uF7tN+Y6ihuMybKQNg7PrY195pHChpbJehp7TwyPn6DW1JGNlbZ/Ii7s36FzSzoIuJ3mbpl5EpooPgV4GXl+NE+MwHPRbiyL663IUvkSjnAwemQyRR7mIWMoP1NNBTjEMjl742YsaaeGxr56GDgRLYyrjaoYYrr1nQgZfS5860oy5o+k7dB6bGu6MyhUz3vw5WEoShHJU9rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BDBQMkUsjJ5Tt3TDybxsB9MY88prDVEtMnVKRQKLXyA=;
 b=eNyFWqahb29dn+e8DhEjzMv63fqpKGHduDtp1D5z9cqZqqG4l8syd6F2XKEBEltDELG8P57/xf8H3KEMLwvS4zX5az4OodF6ltHhduXYmFqfzukfCnOaem5LV8TZIL/8REKZZAesXD9cxwFbRup1kxnco1ZlU22t23xHWTddcFhne/InvOReTLWX/Zi3HRlFLTkmFXaAk61f2noTbosPN9wqbkRJZLh5yS1HizoznBNBYTK7y+EqEnB3QGXB59gNod6Pe5kX+dJXuS65M4Sz5BLmuyDP7g+PQSzdYnCNvkMhcQMsuWdwrEL+JZ+iAHyNb8JI5z2BZ/0ymlgRWjwrLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BDBQMkUsjJ5Tt3TDybxsB9MY88prDVEtMnVKRQKLXyA=;
 b=lzqPCpJZ5F1Xu6cYJOnwUZpphrN3/15lwwApIfMjniwbeZ4P03/gDexyFmJpAcWmbTJ3H2tHeV4dblxcXSz3B9ErMs+bR5V/5e2f9g9CsnwI6AEg0KgIk70A0HTmzn5Y0Qa6CauO11zfuWnq1EsPEv7IFkA5y8+7OEpq42+pKlg=
Authentication-Results: linux.alibaba.com; dkim=none (message not signed)
 header.d=none;linux.alibaba.com; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5896.namprd10.prod.outlook.com (2603:10b6:510:146::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Thu, 21 Oct
 2021 02:58:27 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4628.018; Thu, 21 Oct 2021
 02:58:27 +0000
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, MPT-FusionLinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: mpt3sas: make mpt3sas_dev_attrs static
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17de784pt.fsf@ca-mkp.ca.oracle.com>
References: <1634639239-2892-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Date:   Wed, 20 Oct 2021 22:58:24 -0400
In-Reply-To: <1634639239-2892-1-git-send-email-jiapeng.chong@linux.alibaba.com>
        (Jiapeng Chong's message of "Tue, 19 Oct 2021 18:27:19 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR12CA0012.namprd12.prod.outlook.com
 (2603:10b6:806:6f::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.45) by SA0PR12CA0012.namprd12.prod.outlook.com (2603:10b6:806:6f::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Thu, 21 Oct 2021 02:58:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9278dac-f3f5-4113-0ef7-08d9943ea7b8
X-MS-TrafficTypeDiagnostic: PH0PR10MB5896:
X-Microsoft-Antispam-PRVS: <PH0PR10MB58962AAA83F4E08DC01342D58EBF9@PH0PR10MB5896.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KF9i3ovH1FqfBYUnrDCLxve+6hf1pQ/qpgE5M5gCPKy4iXMSkj7OdT7QNfrIYpswRMQNzTCGm4zAqU++rm0iz8ZK31wQBDasaCUBVJTCTIooQp4UOIVkbC07pLGaNH0l7H6DJ/HeJ0xvZ9TAxD5yugB1ki7oZvJRLRBMz8vBbsNdHhsKBesPB4/n0OKnSmdpUkf1qx7Wrkvc+OooNHOzvvYifxflvz2wnvtiA3VOma0qIMJNnXYByV18d2PxAuFZjABqc4ycuGmCju4Oj4yApWXEPTfadzx8+qvGZ7EYy+F3tRR6qMHSANvWCWjQbQaeNg0DCLFTwsW9J1RBv8cuxmdYjoFKxCKcoabhxNa8EWndW4kx8eJzhuKXAeLhqeFSMllJXlDzIsa0X5gSsZ9a36jCuHFesZgJeZsas2icSfVvr2L9Lxy3AAMCLVZg3TAeMOtSIviYiU8tsqKal1d9NFvKrWiefGLtIyCpwM3HaFDo4AEEzORYmHDCKhr6O6qPdzCv3FormNsXkK5Za90xpF6j5k4mTwDfl8xV1RHUjAi74c3JjthU8c3i5teqtw9WX5mA8bXwqv3cN0JC2UwgKkka2ZV4zkeDAzIupCCqmj9sr9ap4zHJp0l1Xu8/0tE2OXbvjJSgKc173kWN9iV9psEsghvVfXy0AiPjIAWKbiUao84WxTWEKRLy04bEdNH7vVjqKbz/dySgUTwUit1ejlif5nLJOIFpgEEiQBLkSpk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7696005)(52116002)(36916002)(558084003)(66946007)(66556008)(26005)(66476007)(8936002)(508600001)(6916009)(2906002)(55016002)(5660300002)(86362001)(8676002)(6666004)(316002)(956004)(186003)(4326008)(38350700002)(38100700002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/CgC66wIfx95KK7RpnLB+PTwjnaYDyyPQsgrbCazb8GF/ifghFjZwHeutukd?=
 =?us-ascii?Q?lb3PWtcnCCPxW4/t0rRKQBsgh0nOPUx8u4aQ4O7tzy7IDCMb2piM03/cPZd/?=
 =?us-ascii?Q?0XNlqVBKsiVeSGLYMQuXOsQ0Qd9eL15PAOQJpJItDtGR2RG9BZkXtMQf6YAg?=
 =?us-ascii?Q?ZMdIA4pNSpVFUTGWT5PzdHnyQUbIC15lzR30tY8EzvQb9I/qBZLOMt56qCxL?=
 =?us-ascii?Q?yfK/7/3v8HcnH8TgqhmGKRSXRL5K8Gb3qrFpMZ0Vn+oq1B2m8rt8u7LsE6xy?=
 =?us-ascii?Q?Q03Oj7RnSe4NIE71Bz08nDZBij4qS3qjkfQbHVokpJ1X4OTdf4tfrL7Cy4c/?=
 =?us-ascii?Q?vXm7o+5AYWfcGSgsqYMMYgzbScOExiNGKeYaK/th4Y2KwQp2MvqVq19fHWzc?=
 =?us-ascii?Q?vdy7eqQ1XOoZa/UZFH11eV4f82i4mylXQa8h4YUd7rdCFcLqWkyyY8B3I33T?=
 =?us-ascii?Q?aPtKzEBWn2R+JRJFEAmGzuroYcdLzcX1EMjbz/MAiPnkkqSI7CtbJRG/AbAX?=
 =?us-ascii?Q?4OY0TCwvLYdAZkyavl/G2gHn4aVZMAjRxe4kZ0I3PEB5a2vv6Cxv13sQdzUP?=
 =?us-ascii?Q?/+THWo4FEX3LDNxYU+pv/Q+BJrdQVXq2x6wUbJBKsEU3mBvjr6kQbGCIoHl+?=
 =?us-ascii?Q?Zi4RMkh/OY4CYAVN9qvJ71RiK/GRHQERNfAppjtXCHEBQvRLiYl+gzXRLpsz?=
 =?us-ascii?Q?ERsgp58rnSVR19V4Ep54rgECvfiQVNy2VQNWTRGmDXX5vLaMYaBCtDdeSk+X?=
 =?us-ascii?Q?3R4HeV/5oRy8iSkoHjSNMlmfIb+wSKi9hUeKA00hrP8h/J/MIiug7OdoTc4m?=
 =?us-ascii?Q?31owZNdY7wjRiuetpCCZesrhHDG/b64ZUoiwoKKEeXvJesN5TJq+OuQBa9wQ?=
 =?us-ascii?Q?Mysj/y00OfvZqQd+DeQC6QHEJJW+JnPpmoKO2x/J72ThnijCNi0bPENR2Gr7?=
 =?us-ascii?Q?iUvgCq1CF1guGeGfM+LnJYT6V0gaMZfESE/j7o+o/0jddCtzvRtAYSsBOsVo?=
 =?us-ascii?Q?fTHGqQCpUF10s9jjmedzP+mem0sdDGCbNHKqF0rCXgoMzj9xuFlVYflXtneT?=
 =?us-ascii?Q?F0NoPJ4dGYBoRd7wDbDEXHkpcK47Bp405SiJs+tFUMRqBI3jopZyNlO8Bo7+?=
 =?us-ascii?Q?HYvJXX9HDRHWy+tekwHKrz1oAVwYWudUkoLu47sI3LzlmjzMhVK22Ka3O1RR?=
 =?us-ascii?Q?jv6j3VI6X0ub+qcz/9UPQNP7kMMytTGubNV6qjU/V7A/DpQCty6p1vV4yvMn?=
 =?us-ascii?Q?FLJNX2faROdafkPCnHN7K8mMeITm2VOCogxMbjkP0KU0vud+Iijsjo6ylZgn?=
 =?us-ascii?Q?p9du2CiiMg+jATuG0MkOVWYYb+8zj4GfYITTo3TX8J/xsuWe5J4Dki4iEEnD?=
 =?us-ascii?Q?KgDzP6mcBkzw9k9u1EZfXRT+et5xZeI/uGaxuQyeEIOSxOikNel3otw3/dQN?=
 =?us-ascii?Q?J4G+8EKDA6Mvr2TS8VPb3/gV5M+SoTVj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9278dac-f3f5-4113-0ef7-08d9943ea7b8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2021 02:58:27.5263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: martin.petersen@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5896
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10143 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=902 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110210011
X-Proofpoint-GUID: HV5ijafDY6Dou6owYZ3diNaZ6UlSMOWq
X-Proofpoint-ORIG-GUID: HV5ijafDY6Dou6owYZ3diNaZ6UlSMOWq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jiapeng,

> This symbol is not used outside of mpt3sas_ctl.c, so marks it static.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
