Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6DE8C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 20:09:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A065F61213
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 20:09:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbhKDULi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Nov 2021 16:11:38 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:6118 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231826AbhKDULh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2021 16:11:37 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A4JMB92007651;
        Thu, 4 Nov 2021 20:08:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=lpH3G2ZcoWgdlgsPRFofP5wHFbhKg07ABEUX38/y2wk=;
 b=WqCovYVchOU8sOkzPSi0rmqm4rFx+U4gQficMVKtDelSkWE6yTZeALYS6DLPrvXGzCly
 CohZ2MTw9JbTNeD9oxBqBem5hTbCYSFpAgcdqyRuSsxA/gy+1mHDx1HIjsevs6wXMiN5
 UR9pd+Ph+83SdhupgcDJ3jEdc0y1+xD/1GpoAvbIVrpqBjQjz3+96RHakiz3X+JPjotX
 PHjPPHICzXnCXDUebQPC4TMIZzqTVnyGWiFE0BqNNSRs+hqkLKpZ7gVVF4gWpEZCzH45
 D+S0VYn6+IqSrwM4pZPBR5/5QjJb/RS/isJgXJY7hYnUD6H6POXrld7LAKNQ/uNCZgjO jA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c3mt5k0b7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 20:08:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A4JgG39034696;
        Thu, 4 Nov 2021 20:08:49 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by aserp3020.oracle.com with ESMTP id 3c0wv8akuv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 20:08:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JphSiRoCTkkxuUrSBAjRWNRxtlX/5m1+kRcjyUJN5wHu7y5gr197j6KZW8BeDS/76emcGwuzMEhGEjR8Evggk0Yc57nj+dbvUXIbYJSbFGMgmEYNnfnMlXR6ES55gHLzHYTB4twfpHw2QoBc6vM8r5xIzR2baAtBkCBqjEYTZDfHTq5PnM7cfWY2YDIC0HMQd7PadQ1EqA6sS5AXVKmzkgI+PTEH1+Os+hSG7PpDISgkcbbFWtDt8U4puyvZepcrNw3XemoEz7fb28ySmxBFE8WZ5XbucE7XO6lFItJlTgMfHLVDw5zd15z06ImjdQ/2Uu/vF7fkZQdEyZjW5pdYxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lpH3G2ZcoWgdlgsPRFofP5wHFbhKg07ABEUX38/y2wk=;
 b=PB11kw7jdt4X1GKClAlsGqOBEPT0wnvioNfDCS6QAohxLQVJ7gZ9wZ6mGg2lqqGGAlkoX8eTaC+y3AAZcPmKfsdi7azWpo6RihADvzoSXXR5Bdv+a4yhFFDLs6aBFYK3qd/0xS8v5LKwY81in85kbr/Nwa5aVgyOcXDny7puLMo65r1cottueL0zMwRmx15x8ulb7gKmzdFqiA+pg0o2wPJH/MDdTQWTkmUSYTSTIJG3WPASCUfywxx64zZaniK1x2IAIplG35QtLeIJ6eXLDo+cR5TB7QFOy5S/XoHWgqBecH1Ft8FbmQ9b0iP+YHG/8OVZy6fAtdyf6JM301xIcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lpH3G2ZcoWgdlgsPRFofP5wHFbhKg07ABEUX38/y2wk=;
 b=DUwVrOXpOioG/4womaf8gdqN5puQ6AI7IiIjdWNoqp2lcJAViHzEqLGpWlP3Uwyxljm3k7AU/d66loZ/rPbQjJQYm7CuzjyDIkoeaisim/vNdUCD1mtfPysc7SyhCeplT/YnyAWIEM1ig0+LcwYIqlLxUfLACRQy4lXDSPSgnJA=
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BN0PR10MB5192.namprd10.prod.outlook.com (2603:10b6:408:115::8)
 by BN0PR10MB5094.namprd10.prod.outlook.com (2603:10b6:408:129::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Thu, 4 Nov
 2021 20:08:47 +0000
Received: from BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::8823:3dbf:b88f:2c0e]) by BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::8823:3dbf:b88f:2c0e%5]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 20:08:47 +0000
From:   George Kennedy <george.kennedy@oracle.com>
To:     gregkh@linuxfoundation.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     george.kennedy@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
        dgilbert@interlog.com, joe@perches.com
Subject: [PATCH v2] scsi: scsi_debug: don't call kcalloc if size arg is zero
Date:   Thu,  4 Nov 2021 15:06:37 -0500
Message-Id: <1636056397-13151-1-git-send-email-george.kennedy@oracle.com>
X-Mailer: git-send-email 1.9.4
Content-Type: text/plain
X-ClientProxiedBy: SN1PR12CA0069.namprd12.prod.outlook.com
 (2603:10b6:802:20::40) To BN0PR10MB5192.namprd10.prod.outlook.com
 (2603:10b6:408:115::8)
MIME-Version: 1.0
Received: from dhcp-10-152-13-169.usdhcp.oraclecorp.com.com (209.17.40.36) by SN1PR12CA0069.namprd12.prod.outlook.com (2603:10b6:802:20::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Thu, 4 Nov 2021 20:08:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 198a90ef-5d16-4ff4-3402-08d99fcee900
X-MS-TrafficTypeDiagnostic: BN0PR10MB5094:
X-Microsoft-Antispam-PRVS: <BN0PR10MB5094E5609C67D7E9A9E9A6EFE68D9@BN0PR10MB5094.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JdPmEijkZNSDrlv/rsuY4kjNep48OXVphypFHNNgWvpTWUdzp0ZlwSXVXGwlV5bQBNbJatKLNsiTOzfH1JsP3EWAHMs9PLojp7T8Rv31xItH9awJ8ArDql/9aSAhdhxM4P9bpmRDCEeZ6giVKu+v00JeYOmXk0mQ7P7oSQnAQoWZLeLRg5Er7siP6OW2RZ1Akq4eKOHHCDU4NkYfniTO5KfdveFf7rzQAOEOLybsUPiXuj7aSiwWZORns1pVq72MX9UHbAx2eMfKCxwVrnAC5DcyRKov+22kFgjqye2dz4jw5dAoA2Yunfpr0CGqM2pp+yKenpTTokAAuVwvtR48gDIO64P3CdetUZ290WBjGmVWHIQJ7GaoYE1QkFZkjmO4mC4u0sQsa0KYRF2X9jhf83+lsK7Om5vD9e+RhHd0wdwwHTHWQFWvKaj/KpmPR/QpromWnI9bB6jzLYTavCNjhsDtOy5uGNSrINXyx7dXl7zsdm8wp0xIdDbXFEwCP6dBXEpb1NxLCKxgT0NywquFo2KIjsUYu8zB5JTbySz9yZBbYvZoumgvfzQE6d1bNZHMMk0M8rYMQ8FAeq+ELLZU1mFBN+M1zYXqAfzUNVEAe+3BwnbH1K1mHqpbiUha9Bnd29uUB/8QBeldwDwyjtyBrNreXoyMuashprSGw8x3TzGFz1vjETncx05yemOdmzQ3Qnj7IIZ59zFV+V6yyl3zLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5192.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(6636002)(83380400001)(8936002)(508600001)(38100700002)(52116002)(8676002)(6506007)(186003)(26005)(5660300002)(86362001)(6486002)(36756003)(6512007)(4326008)(316002)(44832011)(2906002)(66476007)(956004)(66556008)(38350700002)(66946007)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4DGUEcRWOz634PhZwzxII1M3YTuEVCPqFS31FRHTz8+68E8OioU3UcWb3wnd?=
 =?us-ascii?Q?glXrgZ5fe9kvMfQe/pesi7mBCl2tjjcvFJPXMvF1+VI6BMCrSJekvLu89yCB?=
 =?us-ascii?Q?CqI4QUWFTRfNfVn6Amo89tXDHgylo+zsyF93nIaFF7o38GZnyhB0WIZBU4Wp?=
 =?us-ascii?Q?dPkwGdH7C8CvfXE/Lsv2Vn1sV4uNFUnZH38T5OEZze6fKP+9sOUgwD05T69W?=
 =?us-ascii?Q?ObAMAq3A+1MmagDJiyPXZ1tAB2CHFzGFVsu9/s/KLgXCw3AAmPR+R/2mjKfF?=
 =?us-ascii?Q?EG+v+QrjKlbb7wDlLM4Ji2LuBrhDz3RVndLLkB7YOx7XR3MJcdcx8vR4yFxW?=
 =?us-ascii?Q?fAiLYZY18lUN92akjW+wv9vDCu5uCY0dcTgwy9ctb4WxL6dSeEIHva/+bRis?=
 =?us-ascii?Q?pHy/d95NI2ltt/oYlVhd6dPr1hVBUVVFWo3QdMmm7bGagbEhLlIit2/pVH90?=
 =?us-ascii?Q?kkY0VH2Am8IBRZvPgrpY27rcs67rJ8IsdCZmQnOI1zY49iQwleYlLjKSZSzi?=
 =?us-ascii?Q?doxL9tbTg7GrH4LYSG/FGAXiv1+QISNusfZzJULc+WFLAeSRLf5Ze9z0qaYP?=
 =?us-ascii?Q?hCOkQznEM6YxLa875qV1VZ+1Lg7C1RYN26YS69V9Gk4N3M9h6KTBerjvRShH?=
 =?us-ascii?Q?RMdLGdMjnLa/6doq7UVckX8Xa6FK7UP6HVV6pAEFi5PepO41nCnY4kLwAtPm?=
 =?us-ascii?Q?GisB6QmqjNiS37qUR6Jinw2JNGICssXRPw9TIByVygOJONqT32WG3rZg5J8v?=
 =?us-ascii?Q?qmbldNjfRZqdR7QBWouym/jFX6xTkSKGoAu3Q+U3PShY8lNvZNn7CD6Li1kx?=
 =?us-ascii?Q?g58G0PjsjfzE9RVM6kIsFiBnm9dhZozjwMW9m8FM00siwxf3deON+v1h2X06?=
 =?us-ascii?Q?gLXQFxYT41ClAyt2KUr2HqsNzDwm8Yc4o3CBMr6FZkoQhAShxlSho2jIsFJS?=
 =?us-ascii?Q?TinHXx5K/7yxjTYXbyd56h7IcZb7mKalWqCmV48Y71iGgi7eg0d2EE7Fzwx1?=
 =?us-ascii?Q?Bj5AbswIclnE9HfGlHkgHN/BMC5pGjsKWzbceQ32AaLp1YHRliiPEWlna7u5?=
 =?us-ascii?Q?+LY5Wa/YzjHrzP9+ut4LnwQYX23GDbDAIpnKTHyoboXT0HxrZaOXRAmM32w1?=
 =?us-ascii?Q?DmeN3WYc6RFv1UDjAJiWd/GIhsJ58xvLDsgFfAQFnuOQB9gQEYXXFOXvUzV+?=
 =?us-ascii?Q?8wZAY4Zfkbi63SPo5fGffuybwkz/o1BEJgLpRXe42Q9YaHVHyBdrkO4ITELR?=
 =?us-ascii?Q?tHKGKg6vHC8YPJ+Asti673HWHQavf1ImLF0AM8FIoodPSPke0mkpACiCVe/d?=
 =?us-ascii?Q?6H8ovfUQV6Sb2kxdwLnJl+wU4Dq18zwHZffXzb/zdIuM6Bx7y1RpLeqohKUh?=
 =?us-ascii?Q?ulgxOCES+Bt/dX1tjgutPyxaoqMlNl9r9TkgEd5cws/CoiBNABMcGGP18RFp?=
 =?us-ascii?Q?ppgAxLwvTso/wahD/9IE7nEXgXTAymXnzeYDcJYa12vzwnm07mYkeI0uks9x?=
 =?us-ascii?Q?SYnEKBNZzqGH1zI3A40sALqqM8hNhRxZ/fsei/mhRugNPGoPYqWng0oWfsJz?=
 =?us-ascii?Q?jBFWy0gES9o+jaxsSzpi2eiOFoDgGZM5D2EmVNsZU6kF+38JQeu56OOuN/+S?=
 =?us-ascii?Q?ZvplyFWpxCDl9Pr9n6UQi5p0HinkSdQpyttQsHM99eBNj3xL1dD6S5YsUzoQ?=
 =?us-ascii?Q?T2aZEg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 198a90ef-5d16-4ff4-3402-08d99fcee900
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5192.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 20:08:47.3438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: epqbCI0eMxotcJJs7cjzW8NA/nYA1iEBjYsDjOgFMUsRDY5qwum3P51WZRg8tw/GEFY1Elozjc3qdl9Qg0zffM6KyXx5UoS8BIZnFOv75Vs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5094
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10158 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111040078
X-Proofpoint-ORIG-GUID: Biqav_FA40OBYP9wdsNbpdrN_F1lnTjo
X-Proofpoint-GUID: Biqav_FA40OBYP9wdsNbpdrN_F1lnTjo
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If the size arg to kcalloc() is zero, it returns ZERO_SIZE_PTR.
Because of that, for a following NULL pointer check to work
on the returned pointer, kcalloc() must not be called with the
size arg equal to zero. Return early without error before the
kcalloc() call if size arg is zero.

BUG: KASAN: null-ptr-deref in memcpy include/linux/fortify-string.h:191 [inline]
BUG: KASAN: null-ptr-deref in sg_copy_buffer+0x138/0x240 lib/scatterlist.c:974
Write of size 4 at addr 0000000000000010 by task syz-executor.1/22789

CPU: 1 PID: 22789 Comm: syz-executor.1 Not tainted 5.15.0-syzk #1
Hardware name: Red Hat KVM, BIOS 1.13.0-2
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x89/0xb5 lib/dump_stack.c:106
 __kasan_report mm/kasan/report.c:446 [inline]
 kasan_report.cold.14+0x112/0x117 mm/kasan/report.c:459
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x1a3/0x210 mm/kasan/generic.c:189
 memcpy+0x3b/0x60 mm/kasan/shadow.c:66
 memcpy include/linux/fortify-string.h:191 [inline]
 sg_copy_buffer+0x138/0x240 lib/scatterlist.c:974
 do_dout_fetch drivers/scsi/scsi_debug.c:2954 [inline]
 do_dout_fetch drivers/scsi/scsi_debug.c:2946 [inline]
 resp_verify+0x49e/0x930 drivers/scsi/scsi_debug.c:4276
 schedule_resp+0x4d8/0x1a70 drivers/scsi/scsi_debug.c:5478
 scsi_debug_queuecommand+0x8c9/0x1ec0 drivers/scsi/scsi_debug.c:7533
 scsi_dispatch_cmd drivers/scsi/scsi_lib.c:1520 [inline]
 scsi_queue_rq+0x16b0/0x2d40 drivers/scsi/scsi_lib.c:1699
 blk_mq_dispatch_rq_list+0xb9b/0x2700 block/blk-mq.c:1639
 __blk_mq_sched_dispatch_requests+0x28f/0x590 block/blk-mq-sched.c:325
 blk_mq_sched_dispatch_requests+0x105/0x190 block/blk-mq-sched.c:358
 __blk_mq_run_hw_queue+0xe5/0x150 block/blk-mq.c:1761
 __blk_mq_delay_run_hw_queue+0x4f8/0x5c0 block/blk-mq.c:1838
 blk_mq_run_hw_queue+0x18d/0x350 block/blk-mq.c:1891
 blk_mq_sched_insert_request+0x3db/0x4e0 block/blk-mq-sched.c:474
 blk_execute_rq_nowait+0x16b/0x1c0 block/blk-exec.c:62
 blk_execute_rq+0xdb/0x360 block/blk-exec.c:102
 sg_scsi_ioctl drivers/scsi/scsi_ioctl.c:621 [inline]
 scsi_ioctl+0x8bb/0x15c0 drivers/scsi/scsi_ioctl.c:930
 sg_ioctl_common+0x172d/0x2710 drivers/scsi/sg.c:1112
 sg_ioctl+0xa2/0x180 drivers/scsi/sg.c:1165
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:874 [inline]
 __se_sys_ioctl fs/ioctl.c:860 [inline]
 __x64_sys_ioctl+0x19d/0x220 fs/ioctl.c:860
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3a/0x80 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: George Kennedy <george.kennedy@oracle.com>
---
 drivers/scsi/scsi_debug.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 40b473e..3e97efc 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4258,6 +4258,8 @@ static int resp_verify(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		mk_sense_invalid_opcode(scp);
 		return check_condition_result;
 	}
+	if (vnum == 0)
+		return 0;	/* not an error */
 	a_num = is_bytchk3 ? 1 : vnum;
 	/* Treat following check like one for read (i.e. no write) access */
 	ret = check_device_access_params(scp, lba, a_num, false);
@@ -4321,6 +4323,8 @@ static int resp_report_zones(struct scsi_cmnd *scp,
 	}
 	zs_lba = get_unaligned_be64(cmd + 2);
 	alloc_len = get_unaligned_be32(cmd + 10);
+	if (alloc_len == 0)
+		return 0;	/* not an error */
 	rep_opts = cmd[14] & 0x3f;
 	partial = cmd[14] & 0x80;
 
-- 
1.8.3.1

