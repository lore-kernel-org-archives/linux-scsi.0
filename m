Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1532C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:45:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99C47611B0
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:45:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbhIVErS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 00:47:18 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:40568 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231836AbhIVErL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Sep 2021 00:47:11 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M1oG9Y021885;
        Wed, 22 Sep 2021 04:45:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Di0k15CLgscefUFiH7yPmZmlbjdYI8HuqNNowtA5frQ=;
 b=edybdIbbWUkm5UbEVOIu9GNRmFMgrXzkRjW2zJ8qZKJ2nQ/Or6YnhFXeAZohaOIj0kmP
 Y6ytd9n/gjMh8bhiurwY6EQT0kvvory54fH4Lg6Ur3bB6zceig6H+GmlGNEtvZ8vjlEY
 bVbaat+3q7owf4/wAGty2tDpWJA3JlHIn7AaqUxYWxLNOdnmG7GljwtnDm6UbbC+0e4O
 t7w8qQ3uJMh7rDgxxtLti9zO3xf5sBtcl9duQmhcn6/AKTw321lO/z7fnDz8+bPAPlSf
 bTgVxxJ1g2aw1FmA8KJXfTdW25eOxTeY02BuvZOmUXx0xOTQPAjSlTml+pZs7eq2Ea89 Cw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b7q4p1c1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18M4jZs6178811;
        Wed, 22 Sep 2021 04:45:38 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by userp3030.oracle.com with ESMTP id 3b7q5mc7nu-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZLZkfBFs4VmJfKpXGx2QSNhPggRtAbfFRuFGKXOnnGKVj+8A0lV7BlGbKINx/FYs7Fby278IFmZBsbzPIL5nvCnbnBqsPkiDcAu2nD7d4mnraBEEUaPQM5LD1WUhaIXcqSbW4CIkjl8ltxLzFDJ7GuDM56DFxacSmm/QJNSzbrSU6wjvC/wPY8bcIIq+plKdXRnHXiwrufHXYbFP26hLKDZT8TS5o6iMM4DNGtQ8F8IgRgArhwWMpfjR6+JQ+US8tPPZXCoWQhxL9+FXlCMCGQWVc5p8ngKry1G/zUmtY3GYZ4g9gxKBoph5xaeCKfkau/W2B+2HJqHbBcQsBMjf1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Di0k15CLgscefUFiH7yPmZmlbjdYI8HuqNNowtA5frQ=;
 b=CGhCrUN3LJMaUelAaMXtd9ZKDDgHimyASKuKt2noNqfigWEBfPYVKc6Udp5XGfayQw/cfWI6+I5/wRnNMr8Z/CYWKLKrNs24v7jIjqqktLei+FYh8unOIPROjsrDQKvmzkkWDDqgOyYRq3D/jfBtS4y1RZi7/eWhlNdrg9XS+Ubeh86nlxN/oTcGW9rEcoO3TS13Aw9JBlBy3Q9LGMy1y9sqwqWa4MYYrCQTfuTjHrxQcz/8ZC/v0MooiM+W9wCZjO/5T5ppgtud2h019EEUTA4G9NSc0oRlOZoPn/SUs+jtKDqkP6c8Q4Ro2nMLyWdWmbA6bKcCMoclq1/phdf+Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Di0k15CLgscefUFiH7yPmZmlbjdYI8HuqNNowtA5frQ=;
 b=DGidzP/RfQY6L0AUXQ/svMjn/xYVkKTEmtQ6OxBSl/KwAfOXOd/uCJ7/CXpufjNHXafALWWZtN/JG1gi7/yQLJZN31kEUGEDszUUmyEH2m+TAkAeDMRqZ6MzPB3ZGbrgFaEocPpo5lXQyDdW4iNN4zrYfNC7f7iasrG8zGEiXgA=
Authentication-Results: smartx.com; dkim=none (message not signed)
 header.d=none;smartx.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 22 Sep
 2021 04:45:33 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 04:45:33 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Li Feng <fengli@smartx.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:SCSI TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>,
        "open list:SCSI TARGET SUBSYSTEM" <target-devel@vger.kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: target: Remove unused argument of some functions
Date:   Wed, 22 Sep 2021 00:45:17 -0400
Message-Id: <163228527481.25516.16123570299139745327.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210913083045.3670648-1-fengli@smartx.com>
References: <20210913083045.3670648-1-fengli@smartx.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0154.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR11CA0154.namprd11.prod.outlook.com (2603:10b6:806:1bb::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Wed, 22 Sep 2021 04:45:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae73ff4a-bcdd-4614-926e-08d97d83cfb5
X-MS-TrafficTypeDiagnostic: PH0PR10MB4456:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4456D402468394F9E98D65B78EA29@PH0PR10MB4456.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: koY/fLkB/z/O9cGt4PtHsk3ZAePCLIySjyAUR7ykIomn2AZZLCeUiXHv9VjRSpg0Pf8oD7YCgni8PjOz33a223o1dw/Bu5abyvDv1+Yd/qGSuF5RPnk+zs5Wf/FzuSQ7js/C9UzNVwmQgRtBWzBYJAKCuo7btVBGcntXoJpCvbgS+4fYPXDtlkXQMj8zqs/P9sTRWoUERrah9w0OYu+tr0cD1TKfQBmaZABJmb0jSxc3zR3kg2VEBy7WcEoRSu7onmGIQ+k/+75glQOf+hId+LLB+JPhmo7plQLuBXEqRhSf1K+sOz/wxmKSiCjxxGBZqgvw3I1QPB9906KAW0Eq/lfTJg1GKvBv4297zg3LeWC3y2HdDUFo98I7Kc7OqKdJSDQXquKYlm2/Ztm0wk9J/3VWNuP3M675LyawY7Nzy/ZbN5d/VTVLbSMH+rZpJ1Op/Yj4oTklWprxxX3Ixx2jrZjUJeMSwS4pkWAICDDmaq4ILyxKufoy+S01o2z6NdiRmBJD4oE4vPhmoURYmwI9b++gKM5t98yES8k9/8Qoka++im0JhQqLBDbEgMEnzVh+PlFJSstX7HfWPY8unfFWtC3B9Vi+sZ1QYS7XeWcnJp1othJgEICputxz4Glw0H2UAkMDjrCE44M3oFCCoWrN5uphygaKqP10uu4am8EqZuW+G1cwSqVJ2F59zawizmMF3xFavns4JfKvczBkgZfK5Wnj4mdYCvuIUegiQSuDdyQqu4FyIU9ltWj5bgfAiL5eThX8Sowzh3CS06MY1yxI36UKxRW3qAZaJ7IuK91LXWw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(966005)(36756003)(86362001)(2616005)(4326008)(508600001)(2906002)(8676002)(6666004)(66476007)(38100700002)(26005)(52116002)(103116003)(66556008)(5660300002)(66946007)(7696005)(6486002)(4744005)(186003)(38350700002)(8936002)(107886003)(110136005)(316002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZVZSalRoZ0FRdDc1b2gvZ1UyYUk2WHN1cVVqbDVZaXhuU0hQTE9yMCtKSkVV?=
 =?utf-8?B?Z29GTVBBUlNlV0VTOVp0bXFLUmk2bThEVmlKOStlZmtuN2s4ZjJqV1RZTzF4?=
 =?utf-8?B?QXdYWWZOdERKNFhTZVdSbHNhOEdNNVhFM3AvQlVob1gxbzFLT3FReXk0RDZ5?=
 =?utf-8?B?VUdzRG1aYzIxZ2hHakNOb1pSaCtCVHFxMGR6VFI4QTFGRUZUdElZQXZZRFhK?=
 =?utf-8?B?WkVZNkl1QU9kekp1L29YQ3RlZ2NYbk1YV2pNV3N2WFhnZmFOVHpWWFkvZ2lS?=
 =?utf-8?B?ZERPbWdiVnEzVWRlVjRLZnoxbkNBTmtZb0wrbEJ1bTBRbjJXczg0a2gyUDJV?=
 =?utf-8?B?Y1FDNHljWnJhYVZRbHNuOXo5ZWtYbEQ3RGh4YzRiVHFqN1AyVWtJNWY1UUZF?=
 =?utf-8?B?ZDRRcWJlUkE4OXdkb2tWT25xdVlSMnNPYXJCdFRPV0hmcFpQSmx1NlhMTVlO?=
 =?utf-8?B?cjhTaTJ1bjF1Zy8zd1hiQ0wrV3IxNTRLQXJQRnM5bTJqZzVzanNxQlVNZ0lp?=
 =?utf-8?B?VnBXMUtJZFhKV0ozZEIrYlhaS1NGamI4S0RPVGRVemNJWkFJWUg3cHhiSzR1?=
 =?utf-8?B?bWlhWHRaK0JmakFsR2ZwNS9pZmNSQTNmRmNvUUFrZU82dUg0R1FuWno4YkJ3?=
 =?utf-8?B?UkZKcVpFN2hCZm1FN1QrZHV3cHU5MjIvKy85RHhaN0VCQkoybmhCUk5TcXo0?=
 =?utf-8?B?UHNTa2NzMG1vWHNuYmRxVGRMVFpRbnR4QTBFYjIzRzU5N2ZGNTg3Z2w0cE5F?=
 =?utf-8?B?b29WRzN6cmZmaFJQL2VyamJKejVGc0JrN3JVckZXWVR1TGtOdHhZb1B3RGVE?=
 =?utf-8?B?TmlCZnRYRkR3SHRzMVlPaTNhTGkyYjVnZ1R5RTNjaXF6MEhBRWxoV2RrWEl5?=
 =?utf-8?B?Tm5tTU5lcFA5bFA2WnplOFpTam1KeHNwa2FKdkVSc0pxaXNIUERQa3N2UElW?=
 =?utf-8?B?NFk2Z3dPc1lORVhRZTUzbHNBTE9PajJaekdRV21ncVc2T0ZlV0RER3JZZFhY?=
 =?utf-8?B?U3hreDZNd2lIbHhMeXp4UE5PMk5HY2llNVNVaWYvZk5Oa0JkdUhNZVlxZHJG?=
 =?utf-8?B?M2tmRm1NeGxnS09aeGY5OXJjbzFHcm1OZGllUVFJM2ZZVngwZm9GTzlkdmpt?=
 =?utf-8?B?TVJuT0VIV0RZS1RDd09kbHhIMjFGc1dURUhQS1NvcW85SHhHeG4xWENFWXFQ?=
 =?utf-8?B?N2xobkJlRCsxeDlTVWN0QzhEVStPd1NHb001QUtYQ0g1ZFFvTk9zSHh5NzlE?=
 =?utf-8?B?VHFXaUt5Vk5EeHZ1YnBoN2hsSGxZWFVLNG5meFErdlVzYkZ6TDFTaStUWFps?=
 =?utf-8?B?Mm5PbHRyb1RLcUYvbjRqSW1rRm9Mdi9xdEp6ZFNXRklINE9WSnNuWTIyVld2?=
 =?utf-8?B?SFFOZFhyRHB4RHhLOEFxcnFjYWFNbysrNnU3RDZPRUxNU3Zwd0hsUUpQZkgv?=
 =?utf-8?B?d3ptTUZ6Q05qL3pNMllKTjBRUWpFWFZoUEtaR3FmWnRXNXZKZWZLN3FtZWd1?=
 =?utf-8?B?S2o3Y1pCWWxEYnpYR3lOWExXMFY0bS9PQk1hNmhqTGwydmtVbmthQlhJRWs0?=
 =?utf-8?B?b0x5bUdJR2NSMW1GbnFqTWEwcFEyWnJGaEZLYUJjN2N0Tzk2Zzk4dzhGZnN5?=
 =?utf-8?B?bGQyRlhjVkgzOWxXNFhVVE5sL3lueVdzWlJHZnN3eDJ3enI3Sk8xVkx2ZHI2?=
 =?utf-8?B?QmMxcFlxay9tajZ5STIvMzYvck9ZOFNsT2w1S1RFZWU1MWVKc3U4d25zUUEz?=
 =?utf-8?Q?vMNDfaR9mkUWIl/ZMShx7oDP901YKVK0qulYgCX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae73ff4a-bcdd-4614-926e-08d97d83cfb5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 04:45:33.0289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pvD1JDy+gZVt36C6s7YWxyrZQRfqXn5MLjogHhfZsR17B/1iiymph9/qZZK8iI0snU8JPonxarhozzZmOtUYvNkLp8viivvRLOtSXbCtJIA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10114 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=834
 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220030
X-Proofpoint-GUID: 6P1TZ8T6WaNZP_M2gCiYncVkJH6WnV__
X-Proofpoint-ORIG-GUID: 6P1TZ8T6WaNZP_M2gCiYncVkJH6WnV__
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 13 Sep 2021 16:30:45 +0800, Li Feng wrote:

> The se_cmd is unused in these functions, just remove it.
> 
> 

Applied to 5.16/scsi-queue, thanks!

[1/1] scsi: target: Remove unused argument of some functions
      https://git.kernel.org/mkp/scsi/c/7e642ca0375b

-- 
Martin K. Petersen	Oracle Linux Engineering
