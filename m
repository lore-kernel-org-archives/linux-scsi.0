Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87A7FC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 02:56:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EDB460FE8
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 02:56:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243835AbhI2C6e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 22:58:34 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:3036 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243802AbhI2C6d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Sep 2021 22:58:33 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T2ECFZ013609;
        Wed, 29 Sep 2021 02:56:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=paHgRLbVmn5sXZg7mrSW8wy0NdGeb3a6G3u2MiI7f/w=;
 b=1Gns1GmAzHo/aWq73YkEYxxOypoDrq/H6zHG2EDILGG5CSV7pLMoRqcdRBLc84Fm+lxC
 ryFIZptfl9CA94Tn0mdB+c/KpDQWXUupUDEQHRsBplQPujpxvLiIgfL2+gCTfFIgu4SO
 vgLVMZruIhTOKF9OfYU35xO4F+1uuhEJkDSK4ZorHn3uP7Vcb93B7Q0qO7tdd2rA5LW0
 dkNLdnO7YE7vu76+Q6Q6dbSQ0E7hrA9+/MgpEYhJvfdTidUtXFpj/Z0L15FhyJUKpB5/
 WR3OJD84tD1nCQr+lq4Zw51j1HksQnzgk+9zZr+oXHVT8kk6k5LRIPqeBrJjTCUpdrX9 ag== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bcf6cr3fh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 02:56:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18T2suv1149793;
        Wed, 29 Sep 2021 02:56:45 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2169.outbound.protection.outlook.com [104.47.73.169])
        by aserp3030.oracle.com with ESMTP id 3bc4k8m7w9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 02:56:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ufg6SnXosRzeFr3GOpJrMLWGbBD7PZmKZFYVaW0Fle+bQocZDkuJdBpfpNe5s6dxZw7+31GXMdAk491R6kBb07D00B1FQegg8TjB2ZCkw9XC4riwhbufmgdrRsi6SNfEIWNJinsrsGBec9MvAQ1ZUX3cbX+z+mqRAB0eDQKKlNMVUiAZ7z7Ie/YivdAJkShKpoGNeBgH4Z2W9NR11YZlI7GgHkMqvtMrKfR5Ex2AZNniPday+eeyfuMO0skRl95j+XElA6n4q8GVnSib2npNla4qsj81BlRs+ceRWDHZjov7cV+t8gzqjz8nWljNsqX3cqG3OQ0wxZW+AWB/8BV2kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=paHgRLbVmn5sXZg7mrSW8wy0NdGeb3a6G3u2MiI7f/w=;
 b=MX2ZENH6gfDb9bDQ/DDKf/Q0nS2+6CLwCTWu3Q49Gxb4XZUHjbfb1MRmmIhM/yOLA2dmqXaDUauVnkaowssgy7l26+OY3RPrj4FKTP2ZifBwDyGsq9szwum1EPoGH+XUYkCxA9Tj4ohx2AbO9vMQ0G+xYG7vSzapSToXCzNKZZ89y0MzMD+v6ID3Hq/axO1Eb+i7/hGlzFotzq2AdGnSiL9fwsd6eiMNdY48oEi5tZSqnBu0W4yq0QwN70ZsoPvvhTl9/VmazbzyPxjeVpgbBYCRHvD6uEDw7X87v2PidSo4tCbQXoc+3PFJgRbAbEF0mmUYA2ma+hmGNh8S+UqxwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=paHgRLbVmn5sXZg7mrSW8wy0NdGeb3a6G3u2MiI7f/w=;
 b=ZIyvR6tqSei9TERs3J/1pyImz+3gJytjGlf9wph01QbuAWMkq3QMUlZ57Ijxghh5LJ+WsadrOpQdmg2awtRHva51ErF8q0pbNpC2Xm7V1VycOUPEXDCNX7d9RL4+a6M5AVtklAFR6BnPRk7NbzTy73ESixsxZDDPt1FzBrWfS48=
Authentication-Results: baidu.com; dkim=none (message not signed)
 header.d=none;baidu.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5561.namprd10.prod.outlook.com (2603:10b6:510:f0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Wed, 29 Sep
 2021 02:56:43 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%8]) with mapi id 15.20.4566.014; Wed, 29 Sep 2021
 02:56:43 +0000
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: aic7xxx: Fix a function name in comments
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11r58gkd8.fsf@ca-mkp.ca.oracle.com>
References: <20210925124645.356-1-caihuoqing@baidu.com>
Date:   Tue, 28 Sep 2021 22:56:41 -0400
In-Reply-To: <20210925124645.356-1-caihuoqing@baidu.com> (Cai Huoqing's
        message of "Sat, 25 Sep 2021 20:46:44 +0800")
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:208:c0::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.46) by MN2PR05CA0010.namprd05.prod.outlook.com (2603:10b6:208:c0::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.8 via Frontend Transport; Wed, 29 Sep 2021 02:56:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1892977-633e-49a1-05a4-08d982f4c47e
X-MS-TrafficTypeDiagnostic: PH0PR10MB5561:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5561CF391CFDA9E090005D958EA99@PH0PR10MB5561.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U0g0KFdy7hIHzgrWfJdttsKerzJegi2tGG9hFWk3DYgw5OosZYC1MBQ1vdLDNbFwN89pNP7QlwN9axfB2XNf0esukdBa421ksk4a+ZjQS9eev127VBPNioOeZxIcllfP30JAB7Mlk8QK9vx70qH4/cxpTY/SITA23JuVut2G3TQxfKkeb/T8KL/AnkYjF/CgQYHntphn3EtG7NYs2TuaDsVlg1MGRYkZ05Ox8zvT7//G21G/xTQm6xd7BcbATVvHMi6XaXjEtSdK/oeUfiF3j3jV2OGD31zQ3x6LR5fSlzzDPTAI87w7BnZF+XMcZkWmmRsO3Izk2GHPr5nL2oK/fzfbCytpbeQk35uNJAnkNWsLNWiAVrtrJBhKcneJfYSwdnehAHfWYIf7gQab6Jn9pmXjrzovbfDLLfILex9Ca7jB7TTzQ7OBHLbZKwjQgGC3KNBeY5XQXNFW1iejPkwkhYoL2Q2qrY9HaOmsy4YSvMn5CHtf7GmV/kKo2H//stwZcYDsaX16l0WIWqt3zKS3ryqGlk8YwmiJG4fGWUYGKafBhoYoXBqjDD+CxvzzJXZzV3FChMoy1fYPRNz91mtHJuQ9ZwZ/JBmAEPIbSvMwLmCp7+oc9iQb5CFuFqUeuKakWiaTsZ3H9FNnBH2g47WTdy4nM4LjwhXPANca3/lq5aR9Ubb6/OteaGu25OmNEVMHiCbJ4wbShpK3Qlt2IjuGBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36916002)(66556008)(66476007)(66946007)(6916009)(26005)(316002)(86362001)(38100700002)(38350700002)(508600001)(2906002)(54906003)(7696005)(186003)(8936002)(55016002)(5660300002)(4326008)(8676002)(956004)(52116002)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CL1dTffb+y1MxVaQ5Hb8zKpzt9dVglf36ZkA67uR7dH/HOEBzo7eHLKMkt6e?=
 =?us-ascii?Q?AJPIQidUKP/xJUSId9VdmB0QVRF+ddZsuZtpp0/YchqyMLmawTDPF+oAK9kV?=
 =?us-ascii?Q?g2vWpkvwfH3Xw+YKHuRuYFtuFAyLHWhTwFbqBTwp3KNreH1X6bH+pe+mVVq1?=
 =?us-ascii?Q?j9zC7obpD74L5TsdPevm37MGGEMlqdVyEcT/bC5/qTV/ow5O4lsDuTtQg4Wy?=
 =?us-ascii?Q?GrHXRyyA5SmpDMlfngFkrwenKur5+LlqMlkW77BmStohr2FJDa5nv21otqoj?=
 =?us-ascii?Q?TphE70tGbHYLtPGtlnCbTMxWzgzmrGa1rtrnnc04wxZlNTFlCBneCMyK3s6P?=
 =?us-ascii?Q?pZfOVzmPzl/CI2WZTl+vAcud+V/DzT6zHJ+W6SIWZ++A2hr7MKwAidSdtlV2?=
 =?us-ascii?Q?/pcHUkGRfwaHkZAbj/V3QHDsugSmh7pBKEsXJvAnMpOVyG2ZhUOMu42JzGVI?=
 =?us-ascii?Q?Fuu77B4mPfYKDg9eYptQPkSqr/EO4ZEaBqvLYM+5ysdMQGx+4QgH7g0UQl5O?=
 =?us-ascii?Q?d5NX7Rw7pN9zDVpGzOHMw9Qlc4CBaa7KeBpvCqu/OSbAp8ombk9f0QbbxkLg?=
 =?us-ascii?Q?H+RCweVwSTlKGaP1XjwZXVnm0Y3grFGq3HensZmZWPOr6l1ex6w5OJ2wREyy?=
 =?us-ascii?Q?AaJQYxN4FD5BSSTYMIj5WAuHLsg8DAhTNyCPr5LsAE2BhaGDXiU5Qt5r2/X2?=
 =?us-ascii?Q?CoMReMdBlhVUbSjNmWdahrA9u+LN/h6/ucHna+aFlzrurhTtCea5m+2oTKh1?=
 =?us-ascii?Q?AN4CWOmvDi39SDfLzaPHOr3phhQsZhb9SDadFzQxI0ET1lWJLs7nodVS1AAW?=
 =?us-ascii?Q?+ytP7uaoof9hwet5bEBz0+T84CWmUPeJjoPMn84WxIAfAIPp/EaFBW6ljbcO?=
 =?us-ascii?Q?vtIrS3i08TJopNLg+7U2cTVaeFFagTnrlYOhuyPr32bdDqt55SCNE5sxHC3B?=
 =?us-ascii?Q?8s9A9caor/BR14edyEYnjOU1oCzfCM69w8cgAgND+MnyNOowHo6UlCmT7GZQ?=
 =?us-ascii?Q?JHGDb/9RH8yCcywCCFj/4BuLxacE2+VF6noZmbqqMMyNj31RcJGe2ziRvac+?=
 =?us-ascii?Q?4QPOuKZKnKc5BQPigvxOrOg/UwNwfj32hQ4w+c80mhfA5VSlfeDkak/RvLA8?=
 =?us-ascii?Q?Kr5unk/HuEkrNMqYvileVxgRXqamMkPGCdPiVPdwrDs88AOQaHh5MUPpD/6O?=
 =?us-ascii?Q?EpBBhM70+/+KU5sBi0QZ7a3wJsIgyuXhcYpwq1Eq5IU1MAgoxFJ+YaC58j2M?=
 =?us-ascii?Q?KtikY4SVStMJ243V1NLdEdH1usXX7Opy28JWjeKFRqmCjogid4o3BPNHOY29?=
 =?us-ascii?Q?WXUSLwzz78DV5QvckoodPflz?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1892977-633e-49a1-05a4-08d982f4c47e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 02:56:43.0895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0zp2dS24lkHbsFmIaRoRoeYJmImNkrOVe3OFLL8PLrgnH+6q6tYX03Ci9QU80Up4q77R+hK3tCuhzf40v6p8CxdQLmfP2ckwynfxqGd6YO4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5561
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10121 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 mlxlogscore=950 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109290015
X-Proofpoint-GUID: xb64oeIQy8NfY6b2EiXOGwhQh7gs6kkV
X-Proofpoint-ORIG-GUID: xb64oeIQy8NfY6b2EiXOGwhQh7gs6kkV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Cai,

> Use dma_alloc_coherent() instead of pci_alloc_consistent(),
> because only dma_alloc_coherent() is called here.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
