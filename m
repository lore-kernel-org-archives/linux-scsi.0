Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA01DC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 03:19:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9227F60FC4
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 03:19:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhJ1DV7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 23:21:59 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:58280 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229691AbhJ1DV6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Oct 2021 23:21:58 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19S1r60U027774;
        Thu, 28 Oct 2021 03:19:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=9s/UnagYlkXvqNj/wCMGm0KuUk6VGkJzN6pN2DZo3yw=;
 b=ZOH2UhT3p820EDrcg7rJl4lsXTOmQV2Z5tv5yfsd8PkKzMqE+UZDnhSiNJhQyEf4B2x6
 Q7NDWAkgFL5SnV1AABrWS20+ccWKmjluNQSgLSKQqbvVSFPd59H7bLnVNKVssvm+5lXU
 wZp6MEUOmm1hDYqZjFX+8ER+GgpCoa50V+3c5pk73TMSNyjE4oWoC2imfbTqUPYiYUGQ
 /3gnWpTsRJMCJgAkJLTyJm0QFB3b6M1Eg3RIBqL8DuxYfv75BufN2vybgV+YnsVMPM0I
 5x8vCB1U8nFkzXKjRxTX5YV0tywjDDPDI0NdqxXT8MRh30jsVfivWLyvxoxdbT4UfgT+ cQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3byjkf05p1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Oct 2021 03:19:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19S3Fa0c149065;
        Thu, 28 Oct 2021 03:19:29 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by aserp3020.oracle.com with ESMTP id 3bx4gdny1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Oct 2021 03:19:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IzI7pPWm1TxifBptLU5gvnR4pJnrOiGLwmeVyQshy9AhG24KIpO9wiJpB1DPZSYFkiAv4MUMZOpSIdY+V3omlhAtmQ1ttHiggJ4ZojqqgUHzuqXGMzCFBb0ibpbib6hEkPuAmD+2ABzGwKfQjF1cwekJJrE8XcXHttN34zg85rmFoWrkdNhPIXPvM5KK1dZis6UVxyWwNmfYwHnD1Cf1vCJL1BZyGk6s+uqn6mdBnU01EmjMxnoNDRC7TEmpdwYnnXCR/KKM1u9ksgHeG9/Be+zhrs+j01eu75KjQXwaupeiIubAQ7AqttdmWI2LfDzbPZs3o6bGA7l9VNJWDyow5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9s/UnagYlkXvqNj/wCMGm0KuUk6VGkJzN6pN2DZo3yw=;
 b=EFmesl+yk11rtxG3Ux3wfHXD8TLnth5c3KA50nYhH9g0CpKFQOwBuVnPUmgW0Dibe2Tlfco0N8R+D2Xo7P0HiE0THeysdL9E1n9OFWlkORqktmJTVruNcuu6M2G1O4XDAQS/lOHjuAIe1DhUIrAoMGNXR25FmQFlC/Uc9qM1xKjfREU2YuCWfdc0S9D9oWMtmwcYkRqxSVa7refqmVWx9KddbBV8Xk4QD0uJmWs4DaMiHLkPcaLxekzCfFriH8pCtPmYsbJ/g3tvPuosVV+sE0vDyIwPma2YCIWp47D+Ivwu/T6Ap2BElvEQc+AEJfsTjhv5sUPx6/69cE1zrjgLLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9s/UnagYlkXvqNj/wCMGm0KuUk6VGkJzN6pN2DZo3yw=;
 b=GwypD25nQ9Ss3fzwQhunhjTEv5PC1jzcIA9XzNU7nvIvaa1+mXh8W6SE6eGdf4pxuNO/CY2zpO4UrX6+8xeHRtA4xQOhH7BsLgYtsA0Ww4KEIDTIlIJn7bkMnlws8GITRVsY7O+3/M0EyrFZJf9MrqtPTAerOeztftRgOaNSZOM=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4454.namprd10.prod.outlook.com (2603:10b6:510:3a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13; Thu, 28 Oct
 2021 03:19:27 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%8]) with mapi id 15.20.4649.015; Thu, 28 Oct 2021
 03:19:27 +0000
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi, sr: remove duplicate assignment
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y26dygy2.fsf@ca-mkp.ca.oracle.com>
References: <YXgybUhYN+Vrruj8@localhost.localdomain>
Date:   Wed, 27 Oct 2021 23:19:25 -0400
In-Reply-To: <YXgybUhYN+Vrruj8@localhost.localdomain> (Alexey Dobriyan's
        message of "Tue, 26 Oct 2021 19:53:01 +0300")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0024.prod.exchangelabs.com (2603:10b6:a02:80::37)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.21) by BYAPR01CA0024.prod.exchangelabs.com (2603:10b6:a02:80::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Thu, 28 Oct 2021 03:19:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47375df7-cdd5-4ca8-42b1-08d999c1bf88
X-MS-TrafficTypeDiagnostic: PH0PR10MB4454:
X-Microsoft-Antispam-PRVS: <PH0PR10MB4454B37809D6DE0419B693748E869@PH0PR10MB4454.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CdVjVP4k2fJBDveHuW5bNWMmatriWNs5+V5zgjRh3kIH3xm8lnm2l5oCpdeJCAGfLbn14/kJAitFZEhWIEMlpKw9Z72Kf20a2gtMAuCS94DrNnrHkVmoXlgbjfQTAp+8QFxxJ+BmjX6wvuPyFSHJsza8i/KHbKrKhvKWevhia6oKk6OeIsJAZXYityrcGJ6S7DJABXTwPNduwGoi1R5/8W7u9qmLGBBTTLo3tVn1GdhgOhuNWJvmRHCmW68C4WDx03CKNbJ1vWEGqwKLUQYJhwFAcSvANFECoNIgucF25kvEVS2PAuiKeoSslU67mzNP9dxoaV49U7lqzdnNa9d4pcKq6ftUz7kFGErjAvrKiQpAfbVtiAxvPzjtexFPZ/ZO9IO5VQsn7b0xMzaUnp6GSVmwjDouO9g5XpFXK4lM5sKnk+yHpVOaq47annX1nMUCHrGUQCU8EuYiym+k0vAbIWvSVMCHvDCguaWhyKjoi+Pz+fZezKr0KiWdBnubNrBrYtZHcj1+szJzREKqsibq/noXuEdTRJ7BWwGitDpsfiAGxFyDGba2PcWAxy9RJshtrc0ZKlDwEUd32YS/ud3JpZkX97BQJyxpfq6wOjfkprHGlE7SyyApPxwOGPAn/2uw0JbebchptOA5G/j0S/1+CuQJspp4NqfzNlze4rNzIG43icU52UlQaxr8NFUF3KccWjMerVgJmVbl5HJ98CTStg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(55016002)(7696005)(38350700002)(4326008)(6916009)(38100700002)(36916002)(956004)(316002)(558084003)(2906002)(66556008)(8936002)(26005)(5660300002)(186003)(508600001)(8676002)(66946007)(86362001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Qj2DwAVURS2/sVfFk4dM4tUaoLPzoNCQzrWClOa0sfcgFdccqcGpggCCLhLi?=
 =?us-ascii?Q?mvaSfjodL5bIov+ZWkDjmnF2KGdQVEmV+7swLtSAC2qD9cZUNVjpfU3ZEfaQ?=
 =?us-ascii?Q?NmCExIqsbWjjM2fFf4u5d5l8srwDYgUlOqgyOlQIUs3D+U8aYlASlcuPSInw?=
 =?us-ascii?Q?SaV3LKqOhCY7SDBkPATnjXsC2Ksd5ERE4TkJo/zjxli53czqaGjZRJnQRWI1?=
 =?us-ascii?Q?21hFcwcOjLR1nSbADINfxoJVNLkoVb7a+ucA0mJjyWXgKlVU4EJ8RlHXiaPi?=
 =?us-ascii?Q?NfJ+gqjRQijrS8hxy9jZL6zqzgbLB+vL+pPA3F7bbEhMXH5BWteGjAzzk0Jq?=
 =?us-ascii?Q?MwrytUXBfaBG09LeG1DwiywRiu52k/I/nzNE0HHtwMArQL9FCZTDOo+nvOG/?=
 =?us-ascii?Q?GPUEviZiYGVrpaKzfFKibY8/0VewLliWrdj0lCPXojPppki8wNJgkmaXvZ9p?=
 =?us-ascii?Q?pHcMXtQ9sou9wbt9su2qYEoXnYj6ijIFxYZ183dEq9r22UoIElCIWXbUOr8e?=
 =?us-ascii?Q?TKozcB/zT2YOdAlGTuDE2Hk1n8NBjCVpwDC13RLCaHXnE20zGrxsCPuH9OZQ?=
 =?us-ascii?Q?I4zHgFbovSC5TebVlwhmj16jsIQjV1DzRsxcZgJYtRy3oUdH82m9XPAyHAPf?=
 =?us-ascii?Q?ADZgTg8afAh1mij9rUHl5yxkyR9q60Xjxj01OLaF6K98zIY04P34cToKFMm3?=
 =?us-ascii?Q?Spob7VHLnybMUg0LLYk9NYmjxSENya5BSdWNKjfyL/rItBZ/oIchqCjoAIsX?=
 =?us-ascii?Q?r5/Vp6z+RwDKQy4/nTS5HUuAn5tX+Dn2R2LKU86z+M70bimr8/hds3hwJamc?=
 =?us-ascii?Q?2GHb/2RvonRrsZOp9PT7y8U21zdrBL47VRG3bYoxvuSr4grmfOGsvufeW2IP?=
 =?us-ascii?Q?C1zl1ac4yBhAyHwsIR4unH1OPH+lo3zXuP38D3Y+JM5Cnba400BeNGy2TbkL?=
 =?us-ascii?Q?sEWkOVDiqUgZpdCS2vsjR6VC34YeSZ8bMOvRVhzc9uNsBWriddxUMRCjP1xu?=
 =?us-ascii?Q?9gI0n06XhsvfPW8Y2m2evIUQQmSgr3sArCMA1ikOBot5GuK47aiSWXKZPHcr?=
 =?us-ascii?Q?RKyrqL/uIsJBQAnlyzBLCLkdyrYefjXsLvNQwz6k6Hxpzwt8fq7MItB38G+1?=
 =?us-ascii?Q?5n5voyG3XH/lQLGeS69LMKVUe4CIKCFz2hD9cQdrWROyI0By3rL/oRqCbO87?=
 =?us-ascii?Q?EYAaW+uvlYE6yaqR7p6xhPGf47eo6uvcrCsHM3BYojaPYi/W0P9qw/K9QzU4?=
 =?us-ascii?Q?NmDpcv20E+Zht0OYm8XKeyLEpcMpfIOZeouuFAwdCCINQm9Ks7iWqpqKOSoa?=
 =?us-ascii?Q?o76SrpubXsCI7qoq2r04Sn5CJIWWLKCTx/8369EZI4wGcLzoc29I/CpRoW3v?=
 =?us-ascii?Q?E1xoBnLnxxF/ZquouID1fSsETwXr+Tt/YVlJMScuv3UW8y1vuBLFPRq+qqoj?=
 =?us-ascii?Q?x4DSQeJdRF8l9vqJiA9/IfOX0JV0ijnCbUFzuUZi5msIfcpmsC+a8bix33ow?=
 =?us-ascii?Q?Rwuw4WR+OeVaWaD89E88bjBNzS6B7Lb6yfqcm8FDaUe+KhvJcR/XXhG79wdP?=
 =?us-ascii?Q?jYQdMKvme5s6JyHPxaFrGnIiCMwSD585kuSaR1To9uQJ9Mj7oUU5dVMYicFq?=
 =?us-ascii?Q?VLfM7+LOeJBbTzaaVl8BqwiaTDqh+QA4f2II5jmhBLKoKpTQpa/P7KtmTHJ4?=
 =?us-ascii?Q?6IwPtg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47375df7-cdd5-4ca8-42b1-08d999c1bf88
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2021 03:19:27.2464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Hirbyozs/wRgw8exCOMNtWD6MADfBjgrwnxIZK1MxJCvnfejfBZX7Fjx3vrbiB8al57jlsSjuOgDxE8qeFhcB32g1jjJhRiYeNRIR+B4yI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4454
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10150 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110280014
X-Proofpoint-ORIG-GUID: cOlwwkRB0UWWBUy_fnOSDnODKyqdJQMN
X-Proofpoint-GUID: cOlwwkRB0UWWBUy_fnOSDnODKyqdJQMN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Alexey,

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
