Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B1B4C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 14:09:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BA3160EDF
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 14:09:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbhKBOLl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Nov 2021 10:11:41 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:22272 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231446AbhKBOLa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2021 10:11:30 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A2DL3cU005650;
        Tue, 2 Nov 2021 14:08:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=W6Utp5twy7HmQQ+CkWUzhGJX+PQG3U+NTZFQ335JpQQ=;
 b=BpTGpPK316wyUNCedlUS6ri88yL7c00bRZKFvztsdeIF8nQdnIutaOgbParL/ngat8Co
 Hw/YtU7O0VUUxElXKvGtrIYjnXj5j5Vmg3NspTpVUWtuPhC+D6KuwWwR/+DwpbNXSigZ
 Kz1WR2A/+1HptArVn26vw0rDhBD7mZCc4rVEO+HHw4rwCWuDjskSPdHKM/3qLJamHMmy
 W0Nt7pRE+ShsvL598CDX2WuO1VqfneY/yuk9rkRsnv/RIi1HqMfDIP+HyVjE3C2qaoX6
 HD1I9NZoMkGOelyT5hYVsn4KhCXbD1ewTOQahVLRP0YZMm1f8xQ2A6CAob/0h43zf2eG rg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c28gn7jqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Nov 2021 14:08:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A2E5rxg168201;
        Tue, 2 Nov 2021 14:08:52 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by aserp3020.oracle.com with ESMTP id 3c0wv4c7rh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Nov 2021 14:08:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fQbfc5k0v+VWCrgumqhHQuFkCRhgN07InLqb10TNrECgvkIjoaQS3/fvs8KQeTne8okA4u/5UAM42lJWnpo84zMmek8felViFCJIGWZ0nRxmJSRoL1Do2Hvqwumz6z14owFCh6OpFMatow9D+bl3ropZW6zoYYbnp0bHhKy2PwiCF7UDgrE6JXZWDO4nDroeVhTyy5ZDGgM9taeQ4rdV4y9m+YlUJeaQogpHL5VTeWrYk8iZUuuvqr1UYhznMGFVCwgTn1OTgQqn5zF/1D37DHdq5YWUkN3srs/Cxp2Kh3Ea0RRJ+L2dMt5aj+wafKaj2rqzOYPhLfd7kS/kzoCRpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W6Utp5twy7HmQQ+CkWUzhGJX+PQG3U+NTZFQ335JpQQ=;
 b=fh6aaFPxASk5lNQtwY3YrczVV3JQrekoKzLjAE0hbJJlCdQeClVo73fwMnTu2OghHt/Ne9aoCGNzY0MjreM4TXBUyEuxEglyCHp2wg/1MVe76OjkheH7RS3SMrYrifjsjl8JZwkP2V/AGGOcuOr784P0jA1w/dc5aybMh7OjcV831fbyerC+dzOU35AvO5HAXM2AhTiL1Hbe50ROpUZiJ5KuHIWsNzncO6St+6rwv//QH+ZswTT4PnfmitAeSabi2jt/wRZh+qCnCh5MwCNsn4d9/L8xKbkUkWKPORPXdohQ5aL7qbzjVzq4DXf67Ay1LhXCVU39Lt9B8FmvA71K+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W6Utp5twy7HmQQ+CkWUzhGJX+PQG3U+NTZFQ335JpQQ=;
 b=hFW1Kz3AcN40T9vwOLBHiyUuyWx2ggqJ2sZ1JczvAF8tjK6D3LNlubzvwbOt9+yLWJf/21v19PBTVQy4DjhrWMRUWyc2onCPpNh/ytGprXOrUiA5FSJ7dvEUHto60Upf4Wnrrfv+ExBpUx/IKPKX5zBElBVT8ccOz/1EVpuH88Q=
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BN0PR10MB5192.namprd10.prod.outlook.com (2603:10b6:408:115::8)
 by BN6PR10MB1313.namprd10.prod.outlook.com (2603:10b6:404:43::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Tue, 2 Nov
 2021 14:08:49 +0000
Received: from BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::8823:3dbf:b88f:2c0e]) by BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::8823:3dbf:b88f:2c0e%5]) with mapi id 15.20.4649.020; Tue, 2 Nov 2021
 14:08:49 +0000
From:   George Kennedy <george.kennedy@oracle.com>
To:     gregkh@linuxfoundation.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     george.kennedy@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com
Subject: [PATCH v2] scsi: scsi_debug: fix type in min_t to avoid stack OOB
Date:   Tue,  2 Nov 2021 09:06:37 -0500
Message-Id: <1635861997-987-1-git-send-email-george.kennedy@oracle.com>
X-Mailer: git-send-email 1.9.4
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0013.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::26) To BN0PR10MB5192.namprd10.prod.outlook.com
 (2603:10b6:408:115::8)
MIME-Version: 1.0
Received: from dhcp-10-152-13-169.usdhcp.oraclecorp.com.com (209.17.40.42) by MN2PR15CA0013.namprd15.prod.outlook.com (2603:10b6:208:1b4::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.17 via Frontend Transport; Tue, 2 Nov 2021 14:08:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb2afb23-2991-4d87-2dce-08d99e0a4ada
X-MS-TrafficTypeDiagnostic: BN6PR10MB1313:
X-Microsoft-Antispam-PRVS: <BN6PR10MB131322086A6B80AC022B866CE68B9@BN6PR10MB1313.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OzcNCjGn8xPQpOqeUxPdaQkWji+87t3UddLD4QbMfUBCxQysbc2p8Ij3nG8F/3RoJCWAjV8MO4byXwpL2Y7owNy7HHTSuK5grYS5GNWYg2tTz/OpIbyMmAbqxsIZB6pOa5Txc5TjTQo8FAbgj5ijoZ7KFCZDch2XVuVHk+8EP7CzUCm8JOimNqirqDNNZvzmNeZ9WaL7cwwGDnEYNr5M5zS5oN+ml0AoPoI7NvG7ndkwvTaQhnAo0QnIr8tON42hjEQhmBHTcMNzAcdztRJQloIrgO7PJhR7qArRlAvU+DPcOKTpvPzzJdOHQODz1ZlfTTxHWhcL2HaPWvhd9pxCwgmDeV3YeDD3KSnYnIIaRP1e4uRh7Ppgu+90+FeRO2vVC+gN4mUy5JjueJQeG47mh9zqe3CD7oHBbvjVPqlUcYJf4Ahqs7zoKBjSFJbMSPvfyNkV/ca9S5FY2BqgSfs1qMDNzqrpBMUEtre1kTR/IPUrjLM1O/QBC1832U/HvEffICkscZpCxxv0ElygXIZWM3x+JNQNZxVemJVL7hEhVh1VxMXisd67wp88DHLEmtCSV5s1N+M5MiCjIt/dTvSRnKXlKUIQJllrJ1Czk6H/dmaBLQvsuMYATHssrTuxZV5Gbi9h0212S0XgKeiZL72xXSUJs0EGW8K6wymUM1nsp5RHJQ93b/qxvZ5LrAtZcD46I0N1SnF+LY2XpSoh1qp64w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5192.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(956004)(26005)(2616005)(52116002)(186003)(6512007)(4326008)(107886003)(6506007)(6666004)(6636002)(2906002)(38100700002)(36756003)(8676002)(8936002)(38350700002)(66946007)(66556008)(66476007)(316002)(83380400001)(86362001)(44832011)(508600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tblHP371fq3YL5LhXn0WS7Pgn25FaiEvH1jQjT0+aZ0UlRdo3G1fgrZie2uC?=
 =?us-ascii?Q?omWYCXBKhWeTM5bm4elDzS/uHPEpMKBQou0DWmo74vpD5M7Cc4v7g7U55sN2?=
 =?us-ascii?Q?Q/lGiHQX+qVyMkDWW3WpaC4vxwf2c1kTlv4GERmKDgjsyW89yIpYsYp0YW/B?=
 =?us-ascii?Q?volYKYjuKlLbvN7J27MCKwvdPrtRlOXeu1ohA7jDRY4N0vUrEgRG1vLDTXMt?=
 =?us-ascii?Q?k9faA+g/0d0rVzJhfGw0jR4/CQw76PWmIjUrAMVkbGLIGc9aTDjYxyjHfKSM?=
 =?us-ascii?Q?ALJUA91prZTVJJQNxb7HE8sagYUfLVuCK3rtnrhJOdLdjF7lWNHLpEdlze0Y?=
 =?us-ascii?Q?8xEYBIAhQQKDwK5oseWAZKK052ourI3Q7Rnjag4KAcNXEY92o0Zqj/9sLE73?=
 =?us-ascii?Q?O84yNwXqzmd0eENqsIsYe/jXY07Ubgescyrxf3xzkqpiIgOg6sRmkyfy2vM3?=
 =?us-ascii?Q?A5rMIoXGmN3sVI9sea0fMlFdfrev/QFKyKfRgmuX3enn4UbCTr5wTXbkpu2+?=
 =?us-ascii?Q?hFQBDTiI2913fIXTAJKM5LLLKaVGKzSFDSKg68cAMS6IF6/CcpgXI3wTm+ay?=
 =?us-ascii?Q?4eqkdcycdySfuWa8+/UhqWy7i2TvWaO4HOpqwvdMXpDW5uH7CCiz4mrHgcai?=
 =?us-ascii?Q?lvhyyl1goArvaJLJ3+8spdyv098f2cQ++jeLxaLWbIlplIlGJDm+G9VOWWt6?=
 =?us-ascii?Q?GeB8Xgi7HiIvWl3DHqa12BpzogoF/EkpaimS2ryc9wnG5Sq1LYaDPY7ytvpT?=
 =?us-ascii?Q?30dol+60amaLHVXy4GJXILZ4D3IsQzm1/XnUJ2e5YMO0TxJiihDqmn5wupo4?=
 =?us-ascii?Q?7b4ZZx4lQM2q0aRuRFneEaRyk0sMlJFFOaUjxrLhwxwUxZCv6FHc+FRtSF7C?=
 =?us-ascii?Q?v7VmLBJliYbxAFWIH/2bwCWfc6G7iXeROVxaOcWTT3w3lOi9K10xgSdPh4ec?=
 =?us-ascii?Q?i/UE7o3BfBaT5SAn5HvF7L+DJk9Ltvor/+ZD5LKiV46dFXoauU1FJ8yf0LPJ?=
 =?us-ascii?Q?4V/4TKqaCO+F+qcZjgqiGw1YxPwGfQ/sTCXyXiOsszGNqFM/kJCvUn66ONgO?=
 =?us-ascii?Q?DA46ErGOygldcrre7MC899fRSNgIHM+i9iQi3o230vZQ0uV3mmafCo6512IB?=
 =?us-ascii?Q?MT9MwKLyEKf+PAFPTGLPl8xi7GFvaUs+PNPUeCYeRkD9axaNjAOCL9+V4ZP7?=
 =?us-ascii?Q?uphm+6RgsHRgGuTMfX6UwX9m2GeOxocl9CP7FHxKWBRB/6ei3g+Sa6FYqNiw?=
 =?us-ascii?Q?+9JQCIQatB9YcnJ3qP59DX/EGvtASk//PAxVXjfeOV7V6P4mDJFM6Z9VqATy?=
 =?us-ascii?Q?kDvr3i6vM+Hep0Mmc+YQWElzVt3L13yHoL9XpHswjv92hl04FgPLJYrPRrTW?=
 =?us-ascii?Q?0bQvCc0BZbTJ+PZVzzu7YzZL5H7eonNWKNi+DpXNVcbZzfiSBeeql5M0W6Ur?=
 =?us-ascii?Q?bsjFZCOSq2kq5TBy3lyBciwo0yDE9pRoGA9Z43nGAG5MiQmAyKfr8K4mJxM4?=
 =?us-ascii?Q?K30cRKT7SGoGRj6bs+AJ8Z7YnMGg7XuByMw/1qyK3PhENO7qTydn3Ox3SzeD?=
 =?us-ascii?Q?L4TUr67id5KagG8RnUiP2ap135p1pnV7Q4qO/NYg5uaLSRJjpwqKNc97Zhal?=
 =?us-ascii?Q?tVvlmn2ZQL1UGWFICkX+bgZ9sNrCZhh0TKiO41OXz3zXBAOa5gB9KsN9p83h?=
 =?us-ascii?Q?YPR/gg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb2afb23-2991-4d87-2dce-08d99e0a4ada
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5192.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2021 14:08:49.4022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IfVfMCpwaK3D6Nx31bInMSGcHiP7727N4MIcVZc22i6I3telUpGpZauZKPGmPR8i9+CqD5iF+fLPWLVbyVYWgkmVi3cAoLync7pzIsJaFiA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1313
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10155 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111020084
X-Proofpoint-ORIG-GUID: 0k3eh4DgYSZsgUPQN2PfESLe9NtvMO3r
X-Proofpoint-GUID: 0k3eh4DgYSZsgUPQN2PfESLe9NtvMO3r
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Change min_t() to use type "unsigned int" instead of type "int" to
avoid stack out of bounds. With min_t() type "int" the values get
sign extended and the larger value gets used causing stack out of bounds.

BUG: KASAN: stack-out-of-bounds in memcpy include/linux/fortify-string.h:191 [inline]
BUG: KASAN: stack-out-of-bounds in sg_copy_buffer+0x1de/0x240 lib/scatterlist.c:976
Read of size 127 at addr ffff888072607128 by task syz-executor.7/18707

CPU: 1 PID: 18707 Comm: syz-executor.7 Not tainted 5.15.0-syzk #1
Hardware name: Red Hat KVM, BIOS 1.13.0-2
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x89/0xb5 lib/dump_stack.c:106
 print_address_description.constprop.9+0x28/0x160 mm/kasan/report.c:256
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold.14+0x7d/0x117 mm/kasan/report.c:459
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x1a3/0x210 mm/kasan/generic.c:189
 memcpy+0x23/0x60 mm/kasan/shadow.c:65
 memcpy include/linux/fortify-string.h:191 [inline]
 sg_copy_buffer+0x1de/0x240 lib/scatterlist.c:976
 sg_copy_from_buffer+0x33/0x40 lib/scatterlist.c:1000
 fill_from_dev_buffer.part.34+0x82/0x130 drivers/scsi/scsi_debug.c:1162
 fill_from_dev_buffer drivers/scsi/scsi_debug.c:1888 [inline]
 resp_readcap16+0x365/0x3b0 drivers/scsi/scsi_debug.c:1887
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
 sg_common_write.isra.18+0xeb3/0x2000 drivers/scsi/sg.c:836
 sg_new_write.isra.19+0x570/0x8c0 drivers/scsi/sg.c:774
 sg_ioctl_common+0x14d6/0x2710 drivers/scsi/sg.c:939
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
 drivers/scsi/scsi_debug.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 40b473e..e4c48fb 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1189,7 +1189,7 @@ static int p_fill_from_dev_buffer(struct scsi_cmnd *scp, const void *arr,
 		 __func__, off_dst, scsi_bufflen(scp), act_len,
 		 scsi_get_resid(scp));
 	n = scsi_bufflen(scp) - (off_dst + act_len);
-	scsi_set_resid(scp, min_t(int, scsi_get_resid(scp), n));
+	scsi_set_resid(scp, min_t(unsigned int, scsi_get_resid(scp), n));
 	return 0;
 }
 
@@ -1714,7 +1714,7 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	}
 	put_unaligned_be16(0x2100, arr + n);	/* SPL-4 no version claimed */
 	ret = fill_from_dev_buffer(scp, arr,
-			    min_t(int, alloc_len, SDEBUG_LONG_INQ_SZ));
+			    min_t(unsigned int, alloc_len, SDEBUG_LONG_INQ_SZ));
 	kfree(arr);
 	return ret;
 }
@@ -1774,7 +1774,7 @@ static int resp_requests(struct scsi_cmnd *scp,
 			arr[7] = 0xa;
 		}
 	}
-	return fill_from_dev_buffer(scp, arr, min_t(int, len, alloc_len));
+	return fill_from_dev_buffer(scp, arr, min_t(unsigned int, len, alloc_len));
 }
 
 static int resp_start_stop(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
@@ -1885,7 +1885,7 @@ static int resp_readcap16(struct scsi_cmnd *scp,
 	}
 
 	return fill_from_dev_buffer(scp, arr,
-			    min_t(int, alloc_len, SDEBUG_READCAP16_ARR_SZ));
+			    min_t(unsigned int, alloc_len, SDEBUG_READCAP16_ARR_SZ));
 }
 
 #define SDEBUG_MAX_TGTPGS_ARR_SZ 1412
@@ -1959,9 +1959,9 @@ static int resp_report_tgtpgs(struct scsi_cmnd *scp,
 	 * - The constructed command length
 	 * - The maximum array size
 	 */
-	rlen = min_t(int, alen, n);
+	rlen = min_t(unsigned int, alen, n);
 	ret = fill_from_dev_buffer(scp, arr,
-			   min_t(int, rlen, SDEBUG_MAX_TGTPGS_ARR_SZ));
+			   min_t(unsigned int, rlen, SDEBUG_MAX_TGTPGS_ARR_SZ));
 	kfree(arr);
 	return ret;
 }
@@ -2467,7 +2467,7 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 		arr[0] = offset - 1;
 	else
 		put_unaligned_be16((offset - 2), arr + 0);
-	return fill_from_dev_buffer(scp, arr, min_t(int, alloc_len, offset));
+	return fill_from_dev_buffer(scp, arr, min_t(unsigned int, alloc_len, offset));
 }
 
 #define SDEBUG_MAX_MSELECT_SZ 512
@@ -2652,9 +2652,9 @@ static int resp_log_sense(struct scsi_cmnd *scp,
 		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 3, -1);
 		return check_condition_result;
 	}
-	len = min_t(int, get_unaligned_be16(arr + 2) + 4, alloc_len);
+	len = min_t(unsigned int, get_unaligned_be16(arr + 2) + 4, alloc_len);
 	return fill_from_dev_buffer(scp, arr,
-		    min_t(int, len, SDEBUG_MAX_INQ_ARR_SZ));
+		    min_t(unsigned int, len, SDEBUG_MAX_INQ_ARR_SZ));
 }
 
 static inline bool sdebug_dev_is_zoned(struct sdebug_dev_info *devip)
@@ -4425,7 +4425,7 @@ static int resp_report_zones(struct scsi_cmnd *scp,
 	put_unaligned_be64(sdebug_capacity - 1, arr + 8);
 
 	rep_len = (unsigned long)desc - (unsigned long)arr;
-	ret = fill_from_dev_buffer(scp, arr, min_t(int, alloc_len, rep_len));
+	ret = fill_from_dev_buffer(scp, arr, min_t(unsigned int, alloc_len, rep_len));
 
 fini:
 	read_unlock(macc_lckp);
-- 
1.8.3.1

