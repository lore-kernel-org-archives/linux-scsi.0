Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A83A1C433ED
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 03:54:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BB92600CD
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 03:54:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233975AbhDBDyd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Apr 2021 23:54:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45430 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233781AbhDBDyc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2021 23:54:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1323nvhk136706;
        Fri, 2 Apr 2021 03:54:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Xhx989irCWsWlpFqSgnqEigkTlYgqb4GdMSH4iouDJg=;
 b=cqQ4e9r4WZAfU64PGICFSBZ715eqM8sQ82WqtnQaw2UwSHfPYxc8knaTjiYXVrnyTElE
 OOJUt/IhHLmiA1clVcvj0xajDjKxgqjAdVoA3bC+PVI7buDSonX4X1KFRkNTfAgE2qGp
 8V3D4aJauf06akRSSwpnMtTLnHJLsc1GC07/QjE14m6wpiJR1KVWOmxBilt4oNxjoS5e
 Rvux2kOcdiuFl6M6EuObwa9S3t7DB61lQkYon8GGVWg5DC5hTxgNCM5uf3fx+zvttPFp
 PvFm4RXyVMRm7MoV6xsgenJ+VEE1i468HjIpEGZbaav1insuXWHMu5KhPGn+qe9ci2g2 mA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 37n2a03p5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 03:54:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1323pdIp101592;
        Fri, 2 Apr 2021 03:54:28 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by userp3030.oracle.com with ESMTP id 37n2atmxdq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 03:54:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MOyrC1HYNJyHlO1xyPUbJhKl1wX0en58OI8exeVS7vd7gxkD2N5WDhNkugHBM6XEdfaa4T9pBemZv5MVkTlrPxbEFp4xMvtCLVLFB/mGOJtrXor65HMM2JEc18be9m2kKZD1kFxXYMkFAhI7LsgF5GUjAZmiu5yLe/C4mhH/p8TlzVOGET0dqztGPAZt9dfac8NSckcza4WJX8O9V4G89Kk1N/LDywWfiprR03Rtz56EZPXO6ZKeqm2AoBG2phZU0pXamOOFJ3M2Ra0YB+qkAecgnlAqAnUnbrSsATktG5o8k4aB8+rp+E9LVZale7uJSGsOHXLEfW2Y9ziWTMFMyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xhx989irCWsWlpFqSgnqEigkTlYgqb4GdMSH4iouDJg=;
 b=UjX/44zHnLuX8TOxPfFJtRnI9N7eeCpwW4oLhDYCr/pDsLxezuo8beHEjHY72LMYzyYtDVs/X4TUOR22uTWfybX3Vws4btCN1/BergpBx6wAkOOgrrCEKZb5i6WMemeZJX+PYQlyML4JGIsRWhRTKkHz00BSAryLT3rayWEEImohYV+rZYu5zBwOKliO7fGRQ/4yXGkiucWnwRnriQfhgY8Q0v9bBPvYBxc0Cz2y/+QA8UudGYGVQYTQv3P2vnhJjMjimxOEmoC5/AQz08aLwbH7B/ujonWY0Xo5Cu0v+kgBSPHLFFSHhgxCRXRLLRuubSqSjMftrDMxDSmhaIyNVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xhx989irCWsWlpFqSgnqEigkTlYgqb4GdMSH4iouDJg=;
 b=DhwwDEWK93V3Ck2B07S8Tjw/NOaf1xt9tDW+9o2JKKvdbWeeHyBBEdz2zlGe4HLmYzV5p460zVyIRUqrDEjkXLgbd8iiViL8dIy51B8/gHN4BGYgHk0Rx0p7XKIWxQonZp/TRQ7CRVms9OJU4h8GLwK3kO9IuTMzyxTCZiuAS1U=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4711.namprd10.prod.outlook.com (2603:10b6:510:3c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Fri, 2 Apr
 2021 03:54:26 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3999.029; Fri, 2 Apr 2021
 03:54:25 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Colin King <colin.king@canonical.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: a100u2w: remove unused variable biosaddr
Date:   Thu,  1 Apr 2021 23:54:13 -0400
Message-Id: <161733541351.7418.10718271320140326166.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325170731.484651-1-colin.king@canonical.com>
References: <20210325170731.484651-1-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA9PR10CA0007.namprd10.prod.outlook.com
 (2603:10b6:806:a7::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR10CA0007.namprd10.prod.outlook.com (2603:10b6:806:a7::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27 via Frontend Transport; Fri, 2 Apr 2021 03:54:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48759e1c-b1cc-4e6c-9807-08d8f58b0209
X-MS-TrafficTypeDiagnostic: PH0PR10MB4711:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4711DC34069F8C923AC53DE18E7A9@PH0PR10MB4711.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q/UaiDo+8UQ3CE/oXWApHrmXt8M0wI0ZCGbKdngUcgL5h5tzXBuRNgqSsbs4GhzypCyIXFI/8aS63xNsnF3X3NaAx/lpP4uvhhoV1wZdjJ5LcSYwJ2qwiBPHyH439lZlGSX7QHx6Wm0bkxgpPDrmf19WEgau8VNBzsbmWeBhkfOp0H/nVxLOZIacDs9z4gvD36JwgjuoiW9ZQLHxPZNbbvqDWQjsGNGj5XjBrqsPVg66KmbXR3X2MIIpDnUr+McFpJv4NgwDwVvs4t4Sxcdr4UqVQ+OCNkFinrBmjcAi3soR2S0g0lxEae+uinLzs5r9ZALOwyINy1OueXp0fr7ev1AzFGKsp1IKMVfG+vxxm2PsXwxp/ZtH4qQ3j8BO8/x1k2e6Ylg/bbDQ9lhAgCK4vBnX9JAGzGcqkl1EzkJvcZ9WGxshs46cubpFOvdypCldKvP6GEc+eujRZwfUdDGbs+EVmsKHT5krWbEQwhE86CCFkH73+7Tnt5iNFX8bx1y4g9Jl3AnSitwM4qe/ZkzVuL87X2CNm/WmQ2/7EidCbbw5zl7e7+so71EZ9EiVYHE/EG7X9Nhu5qIWKOh+0SVic7JNy0LR/wHQZW07D3cQH0ByMRksQ59az9TUKYPZWZaiE5dYc13B/2g1Ox14dY3INtrwfVveFROZeRhdh1jz0AywSRp+At16duZNUUWxOpqCARkFzAyazdfOZfEBOqMo0sugzQNzwtbq0eU+t6KyUbI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39860400002)(396003)(376002)(136003)(38100700001)(4326008)(316002)(5660300002)(478600001)(966005)(86362001)(66946007)(66556008)(66476007)(186003)(956004)(110136005)(103116003)(8676002)(6666004)(8936002)(6486002)(36756003)(2906002)(4744005)(7696005)(52116002)(2616005)(16526019)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cXBZdmI5M2dEZFEvR2dCWGJvdU90amNuRjl4Wm9abDdrM0VGOTBJeUx2dEFt?=
 =?utf-8?B?YnJUSm5TRU1lRXIyNHNuMmRibnkwbnJZUzVVVjRLSkpNVkdreXZaSWxITUNO?=
 =?utf-8?B?NkwweHJOcEdaL0xsV0xRaXdReitWblBYY3RZYUJUNXVsMVkrc2p4ZmRRekti?=
 =?utf-8?B?Rys5Rk9KT0RzQ3loZ0wySTNVUWk3Wlc1VmhBYytxZjNsWTREMWF6UjNJRzlX?=
 =?utf-8?B?b2drL2RRUGdERHFuME5LMGJWUFJiN3N6VEdmMUJxa3dEUHJvaFZjWDNHZHlO?=
 =?utf-8?B?U0k5TjJTVGFOb1psWVNGendJRFFDOFdMeVpiRTJUeTNRQ2VYV2l0SHRMeDh6?=
 =?utf-8?B?aUNXY2ljczlsWlpmTWEzcGozOUVCekZqeGNMbmVZNWZDMFhYRlFiTEhUQjlQ?=
 =?utf-8?B?UzJROHRvRGZsYjVhdUhHUmNHeSsrRHZSa0p2VFBJTFVHLzUzMGh6YzRKVU01?=
 =?utf-8?B?Wm5jcUVENGs2ODNEMG00WFNIV29CeklNTDVNMWYxZCtRVWhaRVh5L0ZMM055?=
 =?utf-8?B?TWRqYWJjVEpUWUpKcUNmamEyM3h6M0pDMWpaR3JkaFltTm9qaVJrUjhVeXN4?=
 =?utf-8?B?UmhQVy9sMnRPRHF2ODFSbFZCWENCZmxzeXRsWjk0ekFzMURFeFg3VHJhQWdP?=
 =?utf-8?B?eTdrb044TmZOcDU2MmZFN2RNR0JWNE55R2hObHh3eVRrb3Iwc2U2eGV1dGR6?=
 =?utf-8?B?aC9jTG9VYW4yamcrVVBPYjU5VFczOWFEOS9pRE1qeCt5RExZMERVMGNHeGVZ?=
 =?utf-8?B?VzhvakJqeStYWXRjTUVrSy9hRERRT1AzWEt4anRHc0dOKzFCLzVDbGZ6UE5j?=
 =?utf-8?B?UXNRdndQWEpzMmY3b1hMRXF3eXdPVmlleThyWk9sVDRGQ21rOTNlZkdTWHNs?=
 =?utf-8?B?U1A2S1FmbE5MSTZJcXNYU1NYVFAwSnJOb0xCR0lsVHJnOWE3OE1JWTJMQ2FQ?=
 =?utf-8?B?cnAzVG9BZE5YYk1PZytYR2FNeTR2a2RPODQvbmE5azlvS1Q5d3ZpeFNqV2Fq?=
 =?utf-8?B?cDVSd0VXaTZ3c3FpS1ZvcGVkRVhyb2xBU3FkWjVIVTgyUzEyeHhpZTU0NXF1?=
 =?utf-8?B?TjVYS2dwYTJ4VlNBL0FCVmFqVHkwZm5VOXlOZUlZbEU2OXVUN2ZUSjVGb3JY?=
 =?utf-8?B?enNDM3FOenovY3hOL3U5dEtMOXc5aEhFUy9YeEFKSDZDbGc4TXY5ZnBSM1pE?=
 =?utf-8?B?cy9OYzNDc3VMU3JZQWFJR0pHOXZXUk5zZDNEK0ZHWFovWFR4VGxPQVdpYnZP?=
 =?utf-8?B?Q2VwakNqWnUwYmR5cG5WMDJrY0IzV0crVkc5dkM3a1c3LzdQS3JHWGU1VUQ3?=
 =?utf-8?B?b1VQQTZGblN0MUpHQjZHMThta3EzUHRJWXlTUUtQUUhBVm5FY3JmakZUcDJR?=
 =?utf-8?B?MXpOWW1uT1NxYmZrUG01UTVxZU5uVWZGQ3NNSFdqOC9va1BjUndld1RscVZW?=
 =?utf-8?B?VERXSU51SGxMQlc1MFJNNnFjUDBTVEljYm1QU3BQZlpvYzB0eXp4SlJNTWJu?=
 =?utf-8?B?SndRbmF5ZFlvWW51ZzhYbFNGQ0JvS1JpM3o3dk15bFNzYVdWdTBtaG9LRW5X?=
 =?utf-8?B?ekpsY3E5UjhYRDBySDVnU1FZc1hEYUhmeUxJMVNrM3hxMS92T05HdDF0YU9C?=
 =?utf-8?B?S1E2NXNHS3JGN3RORHFSbTlhYUVQR2F2dkFPZzV2YkdRSm52Qml2cHZNUGhP?=
 =?utf-8?B?dGl2bU9kUUI0bFQzeitwcnR0eWEwQnY3V1FINVFtd3RtRWluemxOMWh5SFVh?=
 =?utf-8?Q?bftLxF3IOpe5W27OW3qLcm2oHiStoBBg4iuA5HY?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48759e1c-b1cc-4e6c-9807-08d8f58b0209
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 03:54:25.7861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +1s8J3UlUef3TwnMc/lyPkdZFpgobuHp2uX/1Y7k1SY4WpvWs8dXdhczTUBdOD2kwPg48PHRz5HV+nMT2Zf+xlXwMHqBbTSMeoxtKej9cpQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4711
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020026
X-Proofpoint-GUID: sDsd8hEM63Y-0yu_TUF3DyUqTXytK9Vn
X-Proofpoint-ORIG-GUID: sDsd8hEM63Y-0yu_TUF3DyUqTXytK9Vn
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 adultscore=0
 clxscore=1011 mlxlogscore=999 phishscore=0 bulkscore=0 priorityscore=1501
 spamscore=0 malwarescore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 25 Mar 2021 17:07:31 +0000, Colin King wrote:

> The variable biosaddr is being assigned a value that is never read,
> the variable is redundant and can be safely removed.

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: a100u2w: remove unused variable biosaddr
      https://git.kernel.org/mkp/scsi/c/92b4c52c43e1

-- 
Martin K. Petersen	Oracle Linux Engineering
