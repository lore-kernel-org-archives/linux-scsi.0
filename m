Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 989AEC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 03:48:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70F2C64F1B
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 03:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233756AbhCSDru (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 23:47:50 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49674 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233674AbhCSDrT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 23:47:19 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J3WIbq092346;
        Fri, 19 Mar 2021 03:47:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=us3KR5O2rYXAV9DSihJ2GDw1XNe1BscRXPUmC3ERbVc=;
 b=FPQ7CtUtK5txCej+s7gfVw12mpHEwjd1HPdycXjfIUYL1HfpG3u18ra3SD0Gn3+ZuFfE
 lZFb5hLX4vY+8OdQ5lYkTUlFNnwBDvfC1PUjeN7tXf+ULiwLVOCI/Kopyaw88DRdjJRg
 ig+IDAr+kUw8pvaKHA1SygV1J9HHJQR64yvuTU5KsnZrEZyApSfpECDUoiQh7EiOF7Hc
 Sy5M0aLQMV9w3SyM92GTcvtUcyaqPh+4Io6/oKripl2IiSH+xSB3ChGnpM4OAolqD3sG
 3aev602aP1zpjTFtB2tN99uYGGdE5OUaG03fhc3YAAUz9RYy/1R99V3eClbpocQmNQfM Tw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 378p1p1fyx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 03:47:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J3U9X0175143;
        Fri, 19 Mar 2021 03:47:14 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by aserp3020.oracle.com with ESMTP id 37cf2v0dur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 03:47:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RxT4RghrDEevfuhdjbiXXvvzPVKRc82dykaJaSWFHm8L3TkAFKtMnKUr/WOcz63cHandB5+FOfiggj3vOoTZBkBVL7sWWk1OBuZUIOK17VwsEdE4/4/cuNcoWMUIOHEnDAgAY+fEVl2OPefUIMlmqxfeGYaxWQtw+1LKNW5zKy14Zdj5nZw5MhjaGU/PvHEG+AEuznXmVvqPEcO289m0w/fT8VPmjGakipM3aLSTenqtKM+7ZVzJArS+xanfQpcVOcjtja7UHGZH2QKvbVu68Z3E+/2MZ4O+BNMemqppNm8Q5nABoZyoOGb33XIYeJG1iWPgmdQO0jR+8jnio/7qdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=us3KR5O2rYXAV9DSihJ2GDw1XNe1BscRXPUmC3ERbVc=;
 b=YyFQGUxWj+rgXuAKM/S6PHyPKYYywCEqk3B1BxOgTLNhACHF48R+9T245NWkLfZ+MFA1oAeB66ThQeFnE1zJHlmepD4w1Owf4fy4XPswZZ6+rRpBY1Q1AgbFBBGpoFk8ocRgZPLUh853NAg82p33fnhw8Qe+5gWL6jeN/jIsye/oEtZhSHqPgbPnqHq5qB4lzjTqDEvcUyHKVmnUAUN6lMRyXdHHuslMtIrDFINOV7WUizZ2I+2iJDoZL99qw/tEH4kSU7s5JUhEKI7OUxQIhB8uMKIv/ZSahY2oSlK+yI1A7UuVqNPQoA8vVwgBlbzoxtOCz/t3PdgKmyzWPM+kbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=us3KR5O2rYXAV9DSihJ2GDw1XNe1BscRXPUmC3ERbVc=;
 b=OBZrKIXQiQIkvVbF4PDNs4Nhcgw9H40bfzsG5Em/fy6RNu91y7TxQJDXUZsmatlHtWnF0KtvcFjURWAEF7WIgP7h46bpbjwMJq3w1dlk2JW0as/laSTNp+6vphmKVnq/eznf7R8OJRUORYXbL/wJ/B/8bDEhelzQiMniorIX9A4=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4470.namprd10.prod.outlook.com (2603:10b6:510:41::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 19 Mar
 2021 03:47:12 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3955.018; Fri, 19 Mar 2021
 03:47:12 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Wang Qing <wangqing@vivo.com>,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qla2xxx: use dma_pool_zalloc instead
Date:   Thu, 18 Mar 2021 23:46:44 -0400
Message-Id: <161612513547.25210.8853708812571886217.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <1615603275-14303-1-git-send-email-wangqing@vivo.com>
References: <1615603275-14303-1-git-send-email-wangqing@vivo.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SJ0PR05CA0182.namprd05.prod.outlook.com
 (2603:10b6:a03:330::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SJ0PR05CA0182.namprd05.prod.outlook.com (2603:10b6:a03:330::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.9 via Frontend Transport; Fri, 19 Mar 2021 03:47:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ed9d812-f1bd-4a51-3c9f-08d8ea89ae19
X-MS-TrafficTypeDiagnostic: PH0PR10MB4470:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB447073E30BB41B7998533AD88E689@PH0PR10MB4470.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ys7W29WNwCd1ttVTbr9xcAH/uf3ku+VsN6lQN6MaJ0qhG3wZFG3F7QQJDBn0UPxIflNJr/uKe1d7sPZp2xzhXNyEORcmIzSrfxm7Sxbh8T+HKamrSf3nEQjEm0iGbwFQu8M2w5NkSeMvHNLohbV5vqref+7OIMnXRoSCXNC3Dq+ZsoZ7cTEjthExm+jWu8A+8MEZJdP/j996CVJcZ2qdmBK1Vs59zL5Bztnj+PWfDVVvtrAeoNFychTdpAZeuXHDIwOvriw5pJ6LWwbQrbHVuS0yhN9OtgVmHiyw1Bv2m7MSWWqfxqDOkbZKn23/TO+ZEYqw+auqeDonMX+3ufveb5n3eUHYltKzo+PRzDcP7ACSQa+Vil3iUgZsM260iW75p7CDGCEf341UfgfffaXyArfVod6Jbh2FhAVT9NdbCGw028JJjoChd0WDNE7VEpRn2xjJhUMaA9ML5qiNUtw5V2Lenz25NDZzaju+2HH1nVksxJIJozZum8XTWfLU/DQLfUJJyJ9XDQVsbeuYtaeP7BHoapJzA9qwYpDZpCLSDAmhY0M0zLZuFrA/tymXUQ8jPiZGGMagtSalYjaoD3N99xWsxQaLTsCc4CKpQwDpUAkkNvycyN/pPbXQXUtlVIPG0nNrx11bvHW6XCtUfuLhrqMkBriAd4GJjwoNAZqppR7byRui4+rusmOd5qt9j6lTu0Kxm4W9Fql9jUmI8mgqcntbHGASXqr89napbrMtrs0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(346002)(376002)(136003)(38100700001)(2906002)(4326008)(956004)(107886003)(6486002)(5660300002)(8676002)(16526019)(66556008)(186003)(6666004)(316002)(8936002)(110136005)(103116003)(86362001)(966005)(2616005)(26005)(66476007)(66946007)(558084003)(36756003)(52116002)(7696005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YXM0NldFSFkrTVJBdURpb2JMdnZsRDduV2NFTnRkdmUzMEcvb2R6SERMZlhE?=
 =?utf-8?B?cU9YYmhSZTJhbUpLYUpvSGE5d3FndTJUMDBlZFVVRTFWRHRSN1E0bkVla1Y1?=
 =?utf-8?B?YzVTMWZZa2RpT3ZWdnkyNG1RVEhQSExMYVhRcnMwMEo0THR5NUtXNjVJTUxx?=
 =?utf-8?B?bnJ5TTdBQXpHUTN1ZVF0NC9haWU0aFJFdnBLU1Rqa2doeUpDNmEvaUhCaXpy?=
 =?utf-8?B?Njd0YitRVWF4Tzh5czZEQVNDdUZ3WEdzYk9rMVhHU09iUkEyUTlDMEdOTkl3?=
 =?utf-8?B?SzZPd0tEMVd1UDBNWk1YZkJpcjM2TG9oVnJxeFlLQVJWTWRwYkVoZHpuQmE2?=
 =?utf-8?B?QllUUzVtREQwY3hLaEVSM0g0OUlEMCtJMDBZZ2ZrelFHWWJGbEtSSnhjcStS?=
 =?utf-8?B?cjVTbHBYUXVvZ1VSdW1HK0sxaVlDdTdoUGQwRWx3d3VKT0Z1ZmZrV3NSR1Ax?=
 =?utf-8?B?M2FITGFvT1JsaW4vYTR2QkhEd1pBdk9PaFAvL1ZkbDhQODRzc1FnKzBDQ2Yz?=
 =?utf-8?B?YXNOOVFzVGUzMFhvQ0N4aUZEMFJoYXpxQWdMR0IrZ0VrTkgxN0dOeUNVbmdV?=
 =?utf-8?B?U2NDRndoVExUY25XN1N1OVR0SjNJSnBRYTVhVUcvUUxPYVJIR1RKYTFCL1pH?=
 =?utf-8?B?MUxXQjY2ajk5dG9qTS9TYmVDcGxibHJiOSswNG1TQ2dLNVprOHFiY08zQlFG?=
 =?utf-8?B?N0RWL3VpWWxPRGpvVU5IQ2MyTmRqbGpMSFgxUzBkMnVpb2dZc0RyWnREZ2Nt?=
 =?utf-8?B?azZ3V0V1Vk1keDNDMkswcVVMNVpzcVlPeHZ0ZWZTYkZobzV0OVFaNlNkcVpE?=
 =?utf-8?B?MHk4SnU1bUxIMm95U1NHRUg5ZWp1YVhOMFJTRGQ0bkpWNlNGSVdGUlF6V3Vy?=
 =?utf-8?B?RHFJT2d4bnRua28zNHNtMmZNMG9uUWMxTlN0NW9pN0NJTTFoajhzNW1mN2FW?=
 =?utf-8?B?VTBnSzFVdU5nTXJ0RDl6WjZ4TTJKcmFxSmJJTFdscEFJRjNFcEZjUUhoRDZx?=
 =?utf-8?B?OWdjaGRvcGIya2tpYytZeFY4U1R2R3ZzZzFNMEJ5Qk5ZYVppRVJBSENJTWJL?=
 =?utf-8?B?Ym5aZFBBbEtWTGI0Z1pEQVF0SnR4S0JmWmQvY1ppUEVhSHRoNTBSZys1U2tV?=
 =?utf-8?B?bFR1eE5tenEwengxNk1JTHVmMkswSkNxcDlieDZhSWVOcjZraFFLR3JPdE1a?=
 =?utf-8?B?QThxWFVlcXhrbC9icTB6K3BPMDZISkF2ZlVOUTRaQlo1KzZPT3VrNTNoa2g1?=
 =?utf-8?B?cVhKTTBRMHFnQ2dDT0lpeHNRZEhhM1cwS0owVEJRaTdQYllwNzhIWXR4MkxM?=
 =?utf-8?B?TnpFczJldkZrYnBXaW9KM0RyTVZtNktFb1ZMQWpDT04wa0ZzMEpBM0xwNDBk?=
 =?utf-8?B?OHR4dENmRThQZG1FM1BvYTVKZnJ4Nnk3V3FwOFRFZDY1ZEZVdDdxb0JheE5M?=
 =?utf-8?B?bjVGVlpEOHMrTU54VHdsRm1xVitacEpvR3FhTWw5UVo2SWZVcytjT1Fkb21Q?=
 =?utf-8?B?dTNJUXBuYXpuUVpKUkdFMEc5UzExMFU3ckR2KzlEQ0llYUYxbTluMkUxdHBo?=
 =?utf-8?B?L251QlhRWmpqMzR3MXMydW1VbS9OMEU1M1dtZ3phSVF5VnZxa3JQa2hNQmpO?=
 =?utf-8?B?UU1HLzJDLzhlZG0wVitPbjVoZm1DOWN0Mk5OQWtKaVpKN2ZkdXN3cUdFckd5?=
 =?utf-8?B?TDFNei9BZy9ud09RUm4zbzZmdHBoSUc1WEdwTjdMSGw5QldYQzMxMGJScmxs?=
 =?utf-8?Q?S0G2efGfQlSZvTMwqDoX4zMSv557DbsAcuiloy7?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ed9d812-f1bd-4a51-3c9f-08d8ea89ae19
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 03:47:12.6896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tm1HNE2WRdk1tPi9NzTSJ1mpMqoLlRpEYQ8JgoRRkR2akzNbuBTI094N/tAeV842JQa/n2FuISHDBoUZuGzwpgSfMtrFVIJFhbDLtdtyPDw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4470
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 phishscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190023
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=0 phishscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103190023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 13 Mar 2021 10:41:15 +0800, Wang Qing wrote:

> use dma_pool_zalloc instead of dma_pool_alloc and memset

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: qla2xxx: use dma_pool_zalloc instead
      https://git.kernel.org/mkp/scsi/c/720efdd23f96

-- 
Martin K. Petersen	Oracle Linux Engineering
