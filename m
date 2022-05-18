Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44D5BC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 18 May 2022 01:52:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbiERBwP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 May 2022 21:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbiERBwL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 May 2022 21:52:11 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B44C2C67C;
        Tue, 17 May 2022 18:52:10 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HKSZrZ023116;
        Wed, 18 May 2022 01:52:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=vJ3GK9+cbWTFYRcXFvYnXDNL91RxZWDbIuHQx8t1xcc=;
 b=yQgIQS+hYNVHHnOEWUbVMPBTZ9Sk4A52nADFTiNVXFASSngkBa47hAACQpY2UuK53K69
 8LOX6DzFthMbQWFK6RlJDP4wkkwD2HZ6glkHKV68o6bkODR90XrWcKowcGa4eFi3ucdA
 oD1rO8FPktgs/G/LtwfLTFVNJtH+IZbPfxiP/iSxXwfQ5/PAq8ZywXNYu19fKa58RIDO
 2eFG1Yks08AI5gyLhqiM/WfAcN4yWpXmdVQFB6vwspIzk+0E7G6eKKlmB0cx+HyISGcv
 LUoHaXZfrakkhm/LlACVXcIhhdqWL86u/XdHuNDqWesKat+7DvKQzQNm305meKjr4FH3 XQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g241s7wgd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 May 2022 01:52:05 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24I1jweu018457;
        Wed, 18 May 2022 01:52:05 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v98ugt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 May 2022 01:52:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PD8pEVtppBNsKFVHJHIc5sUo4IxzxGd0wJc6OlkgNCPMypnXydZx5XsUlrQY6Gn9SfRqqGaso60mEDZHA762MKAUNWKgXNFkGw9SXZ7tg3Z98VqIMKzIv4dvhufvivm72bAKmjr0L+A7IOO43L9f/i9cFlBZOsAeGg/jfop1r1RMyx9ctHCKZlpqPbC4sU8DjtQ6rIJ2UO81B2eHa6m08ly3/BQZv1l40nhTvXZD6QxkpvGCafPf5o5TWZlORfzTLJWFHHYCStEIm38mdG3ifPWqsSPpvtyot/i/080hAJmdAp1FTNU5u1IbZnXXyzAgwpBTf4JxbEb8aDhcAMurvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vJ3GK9+cbWTFYRcXFvYnXDNL91RxZWDbIuHQx8t1xcc=;
 b=eRHkvjmUpfxUzzzAaaow3e5cHdpel9WNuF9UJWtKazF1XaUfGmeSTl5v30Ftw8HIcF8ZhRlNIwNL9ooD2ihRRleDzd8mFyLqLpXisdpyp+eq7aSOmtYgfg6FLlHbb9HQ95iMjrcVOp+d2pfGsn2o5Q/JHaMaCxivWAPjjquVD+koumcQugZ/Fnlr/iRT2rTiBel1+cvLNlRNPTqj8IAfxNTyqW9kC5KaMKn6nPQ5PcHdlKQ+nw6Lt9thyY6JhwssiMSMmeWPIwCY9tz1kD0QSkhQKs65CBU8lg71U3X1/RRuUTyOtTQpQkGk8+qgrH+jO2IxrWp/P+TVBs6fwnS74A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vJ3GK9+cbWTFYRcXFvYnXDNL91RxZWDbIuHQx8t1xcc=;
 b=X9OBer6SUPwa0W564kgDVWBn6O+MX/eq7lu4cUjD3C39E+3liKEpvmewnJL5nemBQFWq1Q5WVPFhOjAw//lji8t0/OvvYhxOPZRX7pUBO6E3rRmxWXiKK07hMVw7li6ks83Im3yeTHUvR/bA81dmXVucHVV5CCuMlXqNUhosL74=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB2988.namprd10.prod.outlook.com (2603:10b6:5:6c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Wed, 18 May
 2022 01:52:03 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5250.018; Wed, 18 May 2022
 01:52:03 +0000
To:     Bodo Stroesser <bostroesser@gmail.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] scsi: target: tcmu: Avoid holding XArray lock when
 calling lock_page
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r14rmwum.fsf@ca-mkp.ca.oracle.com>
References: <20220517192913.21405-1-bostroesser@gmail.com>
Date:   Tue, 17 May 2022 21:52:00 -0400
In-Reply-To: <20220517192913.21405-1-bostroesser@gmail.com> (Bodo Stroesser's
        message of "Tue, 17 May 2022 21:29:13 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0036.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5408092b-be84-470e-45b4-08da387100d7
X-MS-TrafficTypeDiagnostic: DM6PR10MB2988:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB29887000FD4723017E027B278ED19@DM6PR10MB2988.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CUeKu7ozc1Vgb0omJt0cUZkjMoJ6HB2U1fmJim4PTq+cZ0e++v3VZbxp16/a1yRL5iDfOErjOc02zEjxk3pRrSRfJ47BFXKYr6g82WaPsgfVGYPta6cQX192Drj36EwuKGJgUL/KF70kEoe/AXZUMeqWgk7VVFdbb5WpPO8E1wz29w6ijdGn6orhSOrVPVKpDrHdbf1H5jM7Szm+bBwOWJwKmueOxVj/6gSAvfkhGEQZ6TVetRbc7Aiw7VzcmDoJrO9NRyi0//NSjMP328q5n7kdyA0SUSVzgZkaBGWRtJ3OZWgRneHw8xg6/hIG6XPoHUe6oR36GxvB1mpYimbwMHyxqs8mkzAxp/5cielIcwC4C0SbigXETkjw+4pFFhA06lfvFWfmEVUn+8ll1Ai19Q/Stv0RZvjfzU2tu69AuJhGvVm+tGfDihNWDRwvVaMdfSiyIIr0EOf1K29F4Is1O8BKK9QgiVtr+x1NpFOSU1GtsSlukz1rg8z2wy1HizEBdgYwmtVru/aB1TBxb3ryjbZKGb63wM+FyHiVvB5vUrJRzt/gQ5PwWk0mYZuEn7W3JbQ7vJu1viDBaPYK4Kz1EJshT7tuSDttfzGpmlsoZzJcv06fw0AlG1ixdd4ZPZQ8+GbtpV8VK3G9BGzDQxD7m/4DGMSp1FoHgjPhhG7DJMTJkd0M6Pjwh5vCQbovCI2XBo1yvJrL63GkzU8Qxl8rAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(558084003)(4326008)(107886003)(6916009)(186003)(66476007)(66946007)(66556008)(2906002)(5660300002)(83380400001)(6506007)(508600001)(6486002)(6512007)(86362001)(316002)(54906003)(36916002)(38350700002)(52116002)(38100700002)(8936002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ShiIvGNHlTOuNbD8wnVfMn5Y6aJviUjCSpLgiqWoESEs+eheg2jhQ765FWhb?=
 =?us-ascii?Q?ekOtQQMS36+m8i9IXZ3I14leAdlmoLmpWG6v+WiA/uUOrvNXbJHO3rQ0RmaX?=
 =?us-ascii?Q?SJkAeRpc+NwmyX/9jC0FrvzHtHl47C4PkDrgVupAV2hL/WGWCVYrqSLzyZ3n?=
 =?us-ascii?Q?73SlnyaTBKM6tclLuCpzDbpytcwObSSMbxM3eBrdwtmblD18Ytia3bCc/+ae?=
 =?us-ascii?Q?AruZ3Ka5bs8VR2PfcgOwkWzjQQd5xaQci/kCJFH5nvVPPPIYURn2zmT8eirb?=
 =?us-ascii?Q?ktxLsxaLvtGh6JCP0N7MpOiQ7nsz+gRW/XAKAMB0F2g4CASiFn4l41pIkhfI?=
 =?us-ascii?Q?nUjO/mO736mQiuD7FxZPgYMjW0M6QYY8R1ilegPlg8STvy1YTAEjRWsZnAga?=
 =?us-ascii?Q?yvYj/1FNCETgGvxJLPSbiET6eovoYDgChOf13fHnKHMU1ZykGD7Dh89zeGDc?=
 =?us-ascii?Q?zrFijPAggQIEm+tJmRf7wug52SkdV1ijtqRSbXm1rePpwBeS7vqyQA77SQuW?=
 =?us-ascii?Q?9bL3QRjV5TH/VNJZ53Uthh725ReoBn7oh0DRO2B1SVQzECCf3g9QbT4hBVJw?=
 =?us-ascii?Q?0CFQSOHU4zilokbG291m5s/GVA4lwr91nYOr7jmhymxKhFPSGme3KMSGagND?=
 =?us-ascii?Q?8uDWIavrduszFYMJ3VCw77zjG6lJJ1BBHjZueMd7G/H0F6GPJHrpEL/wXFez?=
 =?us-ascii?Q?uMK9bBLWzrWRyUyAgUzKDJ2q+41ImEQtR9KTYJAt5JUVfzT0dk/h5lo2VgE2?=
 =?us-ascii?Q?/3IW6gE24+RbgViY/7nqKtQMqUDOejvXjOmg50GSJsAIV7VsI1u6Ku1FAm53?=
 =?us-ascii?Q?estJmK/7fOG/QthxdRYC3ZhHGiYzYOkr8w22rwBEsFBCZxy0Hjqs2sK4wrWd?=
 =?us-ascii?Q?0888oWpVT7wk9g412BoGvup+9g6ofwtdjQ+waRLczkTfev1FJx8clqzgQ3pV?=
 =?us-ascii?Q?NF2R7a5tti9wpPbpyikwzZLx6sw36P0n+iMljBjHEVyF7lotIffibPtyHVWE?=
 =?us-ascii?Q?hUeb3vAVr1o/Cr+XaaDsWuEChs0KUMs3PEobO57WB41oOwhkWgyelH6JraQp?=
 =?us-ascii?Q?RVOK4Brgs0XozRwHPn6lldxXsSN/B1H3xMVjwjHqLUeiUWngIWLifxvBBYJ1?=
 =?us-ascii?Q?66qI3iW44IT2RakOtj1A0jmJtvbnG8XKE3VPU9b86ZTymWU3/bY8sxJoX2i9?=
 =?us-ascii?Q?Sh2SHfi4KBYqAAzvWjtjmxuDkZOC6cDwM0EK/gozObJkkiLKl1sjRO16hICP?=
 =?us-ascii?Q?GOP/csCnM0fsuLWLF9bs+RlHXirk32a2I4kwLT+daE847JLQfaQrM11ZR3Rl?=
 =?us-ascii?Q?Qjp2Ry3BS/bLl3lY02OR8Y+q5SUwt8ZBOGv+uRwg/YlYCrNo6/fuxhO/pOMC?=
 =?us-ascii?Q?FXZErqTgvYXDwQnCtLLmJBr1Y0Ebf/itVBrZ0xr2CCD0IwTFeEKjiCscmgf0?=
 =?us-ascii?Q?oq/FBNlTCFEB5jYjVMPbGmFk5ojsUsifW8B8T53p0cUztznYv7S8/dA7vUgi?=
 =?us-ascii?Q?1rfLNuYKKJJPc8TBbpkxaTVd/PjyB/kGH1l7AnBKoGuRyOicQAa6MLf57eoz?=
 =?us-ascii?Q?Mr+Vy0Vts1KGcRolr1o/rOI2vG2OogbtkTHDd2/1wy2Yx9f2Uf1jaEZqmtaG?=
 =?us-ascii?Q?qXG4LmAW3dXyhnorj+O9roB2ROxN2NS9NZ3gxmSIOPltaAm6AA1kR72PO5aw?=
 =?us-ascii?Q?2pRK/XczhBbV9nDmvTqEvZRCrVessaO+RuUxLqdUpGsFyYWUhDuVc6aGBVp3?=
 =?us-ascii?Q?JESRMoeGDRoCBKIOIWrESewjw/YSSPQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5408092b-be84-470e-45b4-08da387100d7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 01:52:02.9009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PWbRzZtnyZkF4wrnP7oQB9p6FjLLQy/odyd87LvCWNHiBjCJqtPnAiujfI42adiA73J0D1wrGmegniM9qsUlngKBDKVAAphIvIw0JTRUyao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2988
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_06:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=855 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205180008
X-Proofpoint-GUID: tLkyEBEZZkmZmhIcCEcStCdOSPMHCR_1
X-Proofpoint-ORIG-GUID: tLkyEBEZZkmZmhIcCEcStCdOSPMHCR_1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bodo,

> In tcmu_blocks_release, lock_page() is called to prevent a race
> causing possible data corruption. Since lock_page() might sleep,
> calling it while holding XArray lock is a bug.

Applied to 5.19/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
