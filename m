Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 888ACC433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Oct 2021 02:38:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6868E61050
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Oct 2021 02:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244882AbhJQCkq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Oct 2021 22:40:46 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:58582 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231351AbhJQCkp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 16 Oct 2021 22:40:45 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19H00j9I005987;
        Sun, 17 Oct 2021 02:38:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=MJO6CeGd9xI7I1ZpBqIJ1MiZuVOxSCdK2NNlk9+ITm4=;
 b=NEIDUNjIaoNwB07M2L4mVRrFdrTXlGD2oD3Hz8PwgNzTlEGBYczVhWJOmfkyFG1Z3PEu
 szMaEKFUD1x8hrcKz6lxAZ+KCQmLmCG9LWMtUMNKV4JtpNjPXS0X2TNzZTip91o2NYOA
 F2Akb2wPzqrhdFyLPlA5dPvVKg1lkPu4vfCPJODsxxx5onC2P2+f5fFAZKRAtWaVIS1n
 nBJ/N8DR0+sJjPOXPBt8BEWwugGpz6ibtD/LNoZ0Q9h+v5/MRaCoZVr+xYFwqxpb5Gga
 N8N4xw/RZTfYBsykyr2QesVhqt9st0EDjiqJWrruEoNNjQ3BgH4BAvX9/UjNJMRHy4wB hg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bqqm19qnb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Oct 2021 02:38:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19H2b1B4133374;
        Sun, 17 Oct 2021 02:38:26 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by aserp3020.oracle.com with ESMTP id 3bqpj28ke1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Oct 2021 02:38:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=asXMzeik8jM+JRZe6wJfU9xcEpTWl/DcJJJFWTT2pQXg2sQTCFDNC2o22Yrj2dz4d2zI9clMmASDG3KTGvT1FDmegPaksU6YbZl8wut2212+gWgDBhbaAgumEVt7VEUMEgAGTUf0xWVk9bcvW3Sx6dJUcC6iWtbtIGSEbPu2LTpUapFHyaXoO3tfw00XxnU82j3i/Fy6zotl83KrVKBhjJairjMrX7A7PeeonkgBy+c+q+R10g0SoPMERfeoclGiz51akG4R+qwnUmvpgEMU027UVCCSo6ZxwRbTSyk6QTOqQIGmi4p0F7VaMbwDD+ggWcXR+AvV4HDXm1/upZOnLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MJO6CeGd9xI7I1ZpBqIJ1MiZuVOxSCdK2NNlk9+ITm4=;
 b=VL/JxaD6ulxerTIXeN49VdcKlk9Vz7LkqbIKMHKrND1I1WEA3JBHBFUvFCyXez286NxE8HKkiSXV30ABuldG3vS9h417aD3Ll+UMiwqEaZ4uU7OT7qnEwHiD8/BzKiaepEF6M4K3QG/Tgj4SMGhv/uOaZIUM96AGK0aqTCvRYscSKcKNh4W6uIkXIdqRtD6ckom5hLgFu9vnIGrY3y2Rg6DvuqcIHGU3oMxqCmd9cbQJwBf2jI73K5ayjOFeTHscmfpzELZ8xAXyvitRRuRGCNr/cxSW7829oeU5UyqsQlyAN0fxKGKKVsm0L2rx6morbhqtKuqCvYmI1bn4Z2IKng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MJO6CeGd9xI7I1ZpBqIJ1MiZuVOxSCdK2NNlk9+ITm4=;
 b=MJIyDOokY+M9Gijil9hvAIafMdI77dzHYfUgc210LDGT3gz5yMPpuQNnzcCILc1ui42yokJVt7K+Fu/WGgsE/NuW4TVHmqmSo4KHSP5XDfMHfHqMs5SnOzyVjbLSoBkED5OWISLHbBJcgwQdQJg8WUuIFpUT2Dw3PsRWx8Qjjyc=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4742.namprd10.prod.outlook.com (2603:10b6:510:3f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Sun, 17 Oct
 2021 02:38:25 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4608.018; Sun, 17 Oct 2021
 02:38:25 +0000
To:     Ye Bin <yebin10@huawei.com>
Cc:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dgilbert@interlog.com>, <bvanassche@acm.org>
Subject: Re: [PATCH v2 resend 0/2] Fix out-of-bound read in resp_readcap16
 and resp_report_tgtpgs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y26sfka1.fsf@ca-mkp.ca.oracle.com>
References: <20211013033913.2551004-1-yebin10@huawei.com>
Date:   Sat, 16 Oct 2021 22:38:22 -0400
In-Reply-To: <20211013033913.2551004-1-yebin10@huawei.com> (Ye Bin's message
        of "Wed, 13 Oct 2021 11:39:11 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0401CA0038.namprd04.prod.outlook.com
 (2603:10b6:803:2a::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.5) by SN4PR0401CA0038.namprd04.prod.outlook.com (2603:10b6:803:2a::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Sun, 17 Oct 2021 02:38:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5708b9e5-13b5-4ff4-6a1c-08d991173179
X-MS-TrafficTypeDiagnostic: PH0PR10MB4742:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4742E4A41C59F7D89BED01888EBB9@PH0PR10MB4742.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s2Is/WtGiQo9SWalF3NbspEsCo9y+KGp+saE4Vso90o/0SleUz+SojOb7KR/DIU0xcImhPc3V+5QOMdTZMdEc24lZ9hucMbBNJfKbTBYd+bntX6N2X9oa3Ap3ykSn/TIFax50X7Hh247bTyDMcZd0VeyNGt8P3iWgqxNDuR9su0FnGkYTX8YjtlZS7Ed4Z42RIXrXrmA6xFMcFe3c5sJbAgs1hwd6NdhgWsE5SXGfzse6qYc3hhgFZ+qRyW2tRbqSUS2w6/s+eUpGLkQopLWjjdab3PbYvYrRCS/efar8eEpA5ku6GHtzxM8Uh3z9O5JNNeBhT5vlAv6lxyP4uw/1G0mgAKGOxmdNzFTYQOyvNiklgZ/mR1sxoRmEMVrmZSBv25IrC0MMGo1hmHpJbo/cKbL10E3XbKiarhedl4nnvr4olvvGFu+sT2sZt5ySLd7yH6jjm46V1+1GFuj13AeRdEa3zN15AaOEV8exFNXXnHpy8w6yEIaxOshqpB6JOHZQQ4wMSyoO2Yrm6Zt3O86bPTLcVZdYCoJyAtUNGPTbnMiTq3aOWJwPu1n+GY/znmKukzdEeUlsI+DlPCTAowgx5JPL/bKFlsVIbUW8YofE9PR9lmpZLgBAMKwFq2cJMTVsj2Nmk0T98suTwppwlaP/zJeDSO2DLgv0tINEhViqWaiecGrL+6H7FrWEplm8NBSnLb2jz2ULAHHIN8NU64PyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(36916002)(55016002)(186003)(52116002)(26005)(5660300002)(316002)(6916009)(54906003)(558084003)(7696005)(508600001)(4326008)(38100700002)(66946007)(86362001)(38350700002)(2906002)(8936002)(66476007)(66556008)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5LAP/5TkLqa6+nHWS8gSTqzaFCQ7jSE2EoSVGWNP46h4xDWBFHbvqQjo+qZl?=
 =?us-ascii?Q?/3QYJiN6KjZ/R61tXcGMEWVcR6cCLVyFp2WvIUI0dOpTDFRfZV/1t3E7FhGB?=
 =?us-ascii?Q?WDq2Jv/bc1fh1JTxhScagQ96dWM3XJBHdankNKGkWLYx45oFSt8vPUYnSOBv?=
 =?us-ascii?Q?YfjeNTasYaomsmbriVJCWST3YxYaOkL0dxLZ1hKzKvM2iiY9a+gmAAIr0ulN?=
 =?us-ascii?Q?p5Svjd6lMer84hUlUlIzpF8VXPi8NEoFSbzuWlSdjKGBXcNdaSxpLpH5vNtT?=
 =?us-ascii?Q?MNirEDhdNi3tjkoGZEWAbF/zLJEFJkZAjWfUSE8yyoKRhwjlkrrtQRdkeduT?=
 =?us-ascii?Q?lGmJRvaQ26I1HHjlMhvrOjNpOuozvI41UiiYbxmRrMHBJsZNS35SltvQIeXM?=
 =?us-ascii?Q?NiuR8p38s0ywMm964elKuzM1jLM1DHm1nGuWD2tZ6RFa1KWoi+HKs7dXG/Ot?=
 =?us-ascii?Q?Yy/e1MOK4Ee6OD4q+MLpgiLoDjYrZNog+c/ornpC7ND4nB8A6N/61wcKjb8B?=
 =?us-ascii?Q?uAbXl4XsAIH7q+f1F3yzkNtlJv1NLuVxsIejOJb3M3Zf/25i1PqElb1q9Oip?=
 =?us-ascii?Q?+eZTY7AYARjApQqoicgZW7iD62/+d4a0EW1hFOLnyQW3BY4ViewwVb3zgSqm?=
 =?us-ascii?Q?7u1B/qs/YHlr2dXMS6hMKy/Hx3rA7OM4QHtBnEWMeZkVMulGWfcuDJr1jMAL?=
 =?us-ascii?Q?yXNUEJQTIlIoVGeq3EvFMLAbQ2wCkb5P9Q+SC4uDbxIZmLue+fU1O7zPoSW7?=
 =?us-ascii?Q?MAAh4/ZBhbUd00xvHExF6VcNm79gnLz4LW7mMxYVr0SiKl74u1RPBgNA0WJH?=
 =?us-ascii?Q?KefOczLgDQyq5jsuJ0Jz54lv+9JaTd/oI3+mZkM9592kCMjbE+Re8hcC7xK/?=
 =?us-ascii?Q?LqdnlPVuEKVxFWxzFaIMSMVsUv6ZVH5yvEmBXHr1kp3zCqXEd0+OsayDyonu?=
 =?us-ascii?Q?hIpX9yi53d8p7SZR0osOREWG+86mGUd6kJo9UGXeK6jim5fwZTHTgYmJWwxU?=
 =?us-ascii?Q?beACQjvnFWidHyNacDH/r1Wtuze8ofdZI4GwgoAq3AS/+Wtxne9g/Vz0S9P2?=
 =?us-ascii?Q?LQSp7pBBFmGP9sJqpGctlhliRVRHlzOrDG1THchVIN7IxVZdDnXMqh16kIbx?=
 =?us-ascii?Q?gtbSBvESeeZCKiCiCfLWaY8jQFFat1w2ncIF7znUdGy5hmyHNC6NV3KFXscR?=
 =?us-ascii?Q?/oP0B2E8XoqUoOQaxNKJhcCHSREASQ2cBGZqGJ5o8XJpelhglv00dH3rCFOM?=
 =?us-ascii?Q?zJXJjQqiMIIqDhj17vs3HP25SxdEMBJc5+ZBVW/g5c/fk2ZwiwXgqo7Fr5Pt?=
 =?us-ascii?Q?P7xLP5yjpPObls0NieI9aFPW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5708b9e5-13b5-4ff4-6a1c-08d991173179
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2021 02:38:25.1465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TIS1LqvBQrZgnmOy0jIClAmIh1lAGoewKHDUkUKd2z70QJMNbJVmecz7tn0O/9iCyolU+BLg3QGpUBZpsTncCggyDfifd+mGoW6oPA88zeU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4742
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10139 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=929 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110170017
X-Proofpoint-GUID: kovIgM-capryV_sX2E6BbEL2p4rIUfV_
X-Proofpoint-ORIG-GUID: kovIgM-capryV_sX2E6BbEL2p4rIUfV_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ye,

>   scsi:scsi_debug: Fix out-of-bound read in resp_readcap16
>   scsi:scsi_debug:Fix out-of-bound read in resp_report_tgtpgs

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
