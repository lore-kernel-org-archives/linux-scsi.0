Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6B6FC11F66
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 03:45:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B37CB61D2E
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 03:45:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbhF2Dr1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Jun 2021 23:47:27 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:39270 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231931AbhF2Dr0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Jun 2021 23:47:26 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15T3gxts004977;
        Tue, 29 Jun 2021 03:44:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=mV0/wYRQ5kZARY5KqvbYAMRnWyOpWbksCUcU2/9ljaI=;
 b=W7VBsqDm7co+slkB4BHpR6jCiTj2AapgWk0lFMgViMSpfGOEAa7w5mPCe+7K5ySwIf4h
 1Wg/ivPaMLLwS+uLJmQ3f+Q1CaRJe/Nr42dSxjT3H9OKUq3N/com8GMPmy82sVU8bzdH
 ZlAoO7MD3LwO5LQzJpR0F3b0n5zKCBvXZdzIvM/rCrfnj6P8wmNLkMbBuvLv28iU6zsC
 UV9inDugvz5UKvYmHGcEWAXLo4v7/SnshVPQI8NBfKB6iVtMlZSPUmB79HiCIY+c3AwA
 TGMxlf1G+NxNUnAlV2NMqieo0yRxLJIecLRREtdvXnd4YDMAJQQPWHj4+8zDp48sAHya jw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39f6y3je9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 03:44:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15T3doXn072048;
        Tue, 29 Jun 2021 03:44:56 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2042.outbound.protection.outlook.com [104.47.51.42])
        by aserp3020.oracle.com with ESMTP id 39dv24s7m7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 03:44:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CT0bo3PG76pmFTU3FcyeJ+h7C75BX+oQtGWxKyt+Bmq6DfjByh0pToSbf46ibN40gs7V84jdiTWpE8pSsZLQNP49J0HfQDA4UcVpvg7IFVjfTV7WXmjGYAjBQhX2R232uZQahMrLO5ozzdkTJwwETA756WIFXD6U7yiVt5qxzNDnSV9LtxFdSweumQBUNIvkrFxWdlB5XjFg0vm2fiF/kA0S4HCNHkb/ujmhAtNHdl7WtduFteYFlouVhGWKNjxdi3UxPBvw9zJmUNpt4YyfxKxfVRpjrWRwMrBwotiHQkN6/sK8kIDxoIELbIh24PGkxTwrPxgFCMBzttx4XVaNQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mV0/wYRQ5kZARY5KqvbYAMRnWyOpWbksCUcU2/9ljaI=;
 b=P4UzRtudO0AuieU1uQ0zslPFbZ04VInpUiwMO/eh+UghdMYVzkpmcyC/Uyd1kn7+EGIQr+AA3LVOfP85MQHdcdGCxiL7q0IzWuesIGMfBWQoow3E5XNJv3OYxVPFJMGfjBLaTPH0prRPuZb4JGHiGXn9c0Mq/5i68sb5sQNoAP6tj1MDDG6MN1JrPIKzJeAJ0pa28p9UVgU2FsLdoJ5MXm12Sc7XXiB7KU8WTzEQi54WySFBZpkObGPn0SoZHEX9Kp2cpN6DYpYGfT+lRCwVEXycquX5bxeXpzlbIIHdEl2j6Kq5StFPZeczMM6OoulR5ezJdKras0P41pZoCvyX9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mV0/wYRQ5kZARY5KqvbYAMRnWyOpWbksCUcU2/9ljaI=;
 b=DEKs1pStEecsTD84JMOvjCQK7X1LGkHqEtJ87agOPDoVHNZJj7NEKHGFZgBDLb60QD0alKHdpl7nDRuf01QeOVqtsi94zmH4qs6Sb/lmLBQ31E5acBtZ5rDn9oWF7gP9IRxOOtPz17oPpVXq6m3kvUTrPfH7qCZy153yea4SCS8=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4552.namprd10.prod.outlook.com (2603:10b6:510:42::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19; Tue, 29 Jun
 2021 03:44:54 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4264.026; Tue, 29 Jun 2021
 03:44:54 +0000
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.ibm.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        kashyap.desai@broadcom.com, sathya.prakash@broadcom.com,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] mpi3mr: Fix W=1 compilation warnings
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1czs5l4uw.fsf@ca-mkp.ca.oracle.com>
References: <20210623072153.25758-1-sreekanth.reddy@broadcom.com>
        <20210623072153.25758-2-sreekanth.reddy@broadcom.com>
Date:   Mon, 28 Jun 2021 23:44:52 -0400
In-Reply-To: <20210623072153.25758-2-sreekanth.reddy@broadcom.com> (Sreekanth
        Reddy's message of "Wed, 23 Jun 2021 12:51:53 +0530")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR02CA0004.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR02CA0004.namprd02.prod.outlook.com (2603:10b6:a02:ee::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Tue, 29 Jun 2021 03:44:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6982ee2-9e12-44b0-fff6-08d93ab0421a
X-MS-TrafficTypeDiagnostic: PH0PR10MB4552:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4552B36019478C5EC2A886688E029@PH0PR10MB4552.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fhAqP14pGxnqUN03X+AMtMvWo9k9RxMZqKIC4HvHwo07X/EzTKyNNGAdlv898uRbNORhR13nLtmXDHmp2LJxbEESFXn3rYaQPjZinHx5/gDZIYjiZUJOzGW8U+mnRBbdfYJ29EoJlxKNuiksIBJl8ebSOfiM6rWTR9e+L2dWwStNKX9nDEi0FaJpymtPHbZMu+1s+OKHVjHRQ2IQjEyjRIjc9BQ3m50pXuxU3A2Nlrpaq+VMgZYvsq2g85JkvuH3EpEhH/Qig+wgYJMJLI2mtqZ2u0mrtIYnREMFDDB8A2Rgd13quvNklwJZ7/V2InSvra7UrqBdFhgmSmkr3Y8t4wKFE/zmUTd2sKSiboCbZGn4faXdK4B9k3rutB1DZGmfEBtijp5P5zBOyv47npb/xLusLEZDuQphs5UX1zXb6BRbtwf/pqFfL+AT2XrSgx004hNXE9q1kXxTmW0owC9MYTK0OcqQnfwLD7TbXQKEhEqjYApgZvCxsHV/ZzgKTRpw7PfmrmyJ/0hwyOJ17vRNcp8dvvCvN7ZnnFLF6I5SukK6ug9bPsSHrGrMKRS3vMWn9EO74W98IWH3aU48uaxefDwzTS9eoCGHC4XKvjuaCjuN/rq8LTcrUk7mJaYRVv+faWDAMHzzi5O6ff//1j6ZDPuQrN5ajOivrXTzjaSZ9deRkNSQyY4SreKOQBk3wsRP723hyKSZHiZntPt/K5iGjznJxTD8MBSd0XLfqP7N7S8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(39860400002)(346002)(396003)(38350700002)(38100700002)(55016002)(478600001)(86362001)(2906002)(316002)(4744005)(36916002)(26005)(66946007)(8676002)(4326008)(66476007)(956004)(5660300002)(66556008)(52116002)(7696005)(6916009)(186003)(16526019)(8936002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jpvYm87J43AEXVQwLgcMlJdZpkeHfYdqqEDLH7eB7mH+eFR/lP29qEOHh2QF?=
 =?us-ascii?Q?NRqSZA9lHc2UjmNP81SI7qbYSzK91s/tLFer3LdogpPegrEgb+7FMoUd40EO?=
 =?us-ascii?Q?A8KYep8pHVks3Lt3DPBbrGdymB+YVIB1GJqdUn/R75bYQ7RdB0/fxqIlV2Kj?=
 =?us-ascii?Q?w/do+7oy510MUNU/W2h1udR1JAjgXz1gAr7il3zlmyaxEIcceh7WVyGyK+hd?=
 =?us-ascii?Q?Mb+r5g3XiquIMoF8ZRd0LERE71ZiLERCJfb+g6mG3rqMNITMn4fF4tL9Jr5q?=
 =?us-ascii?Q?ctCE+BkP3mn3059vCz3q+xoWnaRwIfKdnfqWfV1qkJFqo0afHhFg4hrBVgzZ?=
 =?us-ascii?Q?VEF1+NeLDTP3JBTt/8oy8whm8eMyuNOGV1BPa7l2fpfiKtRhIO9WHoqYzYtC?=
 =?us-ascii?Q?jBHuDaw6BXy2n92xzEtQT+A+G6Vn4kdYj6eX62KhYGYLPu7Cq+hqeDtZHtNt?=
 =?us-ascii?Q?QW0IR7Q1a1/h5Dmw1WOPj93hxCr8ATPjcnGf2c+udDcjMy4bo8JJyIrvn4Bk?=
 =?us-ascii?Q?Kiz9mSJKCNCl80ogHNpuAx3/GXy7x+Y5+4H2ZsF0vWcVKq0QEKGWhzGEeeuY?=
 =?us-ascii?Q?J+WdIYLRTJX/cSX89VJZg2NkqHMdR4vJit9vvuanWu1W+XxHhamPHr83Gui4?=
 =?us-ascii?Q?NUxzDVMzhuo+u2NmB0pg5/2Yd6mhB3MgMk1eOYAl9mJeOEtP5WSxDfVD8tEa?=
 =?us-ascii?Q?r/aLo119YW/MkIxgAf4fZvSapgzfq0IqSOwyU0C9VkYEk5vhCCUKduiCxoE6?=
 =?us-ascii?Q?OWHBm4526udO4gMwFREEtb4kNYIVOA55PIlASOy59BnH39iCTfNXlHh589i/?=
 =?us-ascii?Q?Nv2nl/VTt2RSx2czZ3GhN+wXG2C9pH/1ECb/ozmgYqQ+wLljgYhzIeUCV3F0?=
 =?us-ascii?Q?w14twnh04KBzV8wWkfWTy1CTRqgwSH/FazDqt4dAOh7pJtaMpvJQYDT1/d3k?=
 =?us-ascii?Q?UzY9dSb+GLG0h0yKsF5tgfb0DLR4wI4LHBZooCZ+Tfz2zBtCgM0hueg5Jgm3?=
 =?us-ascii?Q?M+Ba3HbgSXbVMR+lGk4d101/Bip3JYCbx0zeq0HkMEgnO2xu64K8y0whLm5j?=
 =?us-ascii?Q?26I3A0X9a1e9LyUf9r5I3QUSj/J2xqsPT6iGdJEHbw6pFCuSSSO+gicPBbZC?=
 =?us-ascii?Q?a/YR76CCyT1aW5+v3q9UGm/ddCFaO/xaB6hFbx9Kn0Tb36sbYiR9Yczq1Vda?=
 =?us-ascii?Q?Eyeh6hKHCCNAmEg0g1PeaptT/j0OmZ28HwGlrgCHCv5GsVNC0FefVDCRTTrj?=
 =?us-ascii?Q?dUECgZvd+JlsQFf+8SV+TMiIYRGiteMz7yatOZ4Rf1YmwJmZ6Wgeb8HSNjxN?=
 =?us-ascii?Q?ZHzIZS6u50Heq64vq7Fm9xxY?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6982ee2-9e12-44b0-fff6-08d93ab0421a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2021 03:44:54.8342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P/99VwzmQ8J8WYh/TKWw0b2MjjQN9FohuSIiC66X2CJb6kSJ2UhyA33TJNeBi4iRAagOK3z8Z1L1EEMhGs4B+nryaHKsE2I/2pxvzEzlp/8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4552
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10029 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106290025
X-Proofpoint-GUID: 12zYa33ah8xm0vifbcNQSmR06uqWP-y0
X-Proofpoint-ORIG-GUID: 12zYa33ah8xm0vifbcNQSmR06uqWP-y0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sreekanth,

> -	strncpy(drv_info->os_name, utsname()->sysname, sizeof(drv_info->os_name));
> -	drv_info->os_name[sizeof(drv_info->os_name) - 1] = 0;
> -	strncpy(drv_info->os_version, utsname()->release, sizeof(drv_info->os_version));
> -	drv_info->os_version[sizeof(drv_info->os_version) - 1] = 0;
> +	memcpy(drv_info->os_name, utsname()->sysname, sizeof(drv_info->os_name) - 1);
> +	memcpy(drv_info->os_version, utsname()->release, sizeof(drv_info->os_version) - 1);

strscpy()?

-- 
Martin K. Petersen	Oracle Linux Engineering
