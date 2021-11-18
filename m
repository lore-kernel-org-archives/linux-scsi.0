Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D2D9C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Nov 2021 19:05:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCC32611C0
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Nov 2021 19:05:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbhKRTIo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Nov 2021 14:08:44 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:56624 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230107AbhKRTIo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Nov 2021 14:08:44 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AII5Nkl031693;
        Thu, 18 Nov 2021 19:05:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=+IDro81HnAGGh3MRfDiAB2CpWJ4MhTWn8dNV/1gYJ4Y=;
 b=eUl/fUD3xP+r+JUpAqW+zwE32KGXi5aldVw0rapZ+rrXyWeceajmDU93242OKQTR8x9X
 bqEJTreg+VFBxRX7ax1b0YMPV0qR34T301xRU1UhIG1xhE71ppyDo1AlsIllUy38Fr8A
 iK2GpIvyaTFNLX+PK0nT7gO/ZfWzFn/q2pnpSo/99YEHAlN3uFzCxMieeRhXy6PFzgx/
 H6z/gy0WXtD7hUw6+fVBu22qPyPu1DyLpynbffyK+EBG/lbpnDDCvdHLG7P1NvEjVMP7
 8laHcTDlCTYRtHfKXABoz+TUJnm7BcYOzW/HH2O90W6lGq5GUCDga5BdlSHg4IqRig9F IQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cd2ajsa6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Nov 2021 19:05:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AIJ0Yfs123178;
        Thu, 18 Nov 2021 19:05:37 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by aserp3030.oracle.com with ESMTP id 3ccccs7urc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Nov 2021 19:05:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n9sTgCVnnivEynqIe+edGb9DzZKaSGlDo9jG75ubHdH6O3KeyT20J+BsFu5dpujo43BHYZbiTtVEjr/JRh8NbyVNhK8OwSvODMCKhoGwxdBQCt5/9shy6O1nub2r61sTqGjQij7WgVd0L61LJmoUMv7IZ9JgAmuLC/Z2WfCLUckp9tDqew+Ut+8FhXTkN4gCXKhYfX7ycdx5YMGWCdhZBmu9dD2uygYdl4KF2KPvSn72iBBNeZJyEVUCxpOrDoN43vFMPVLcFOM9JmhToTs3g+71GnCXfH1YKN0ccvFAjxIiintUYbR/x1JEIitI43DpntkZg3nZ1duXBxmWquxawg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+IDro81HnAGGh3MRfDiAB2CpWJ4MhTWn8dNV/1gYJ4Y=;
 b=TkRiHZs9824tMJG4rVO7CpnzLtFgX2dPCGu5EPHlOWaiSl9K+6lJpwkS6fuX11W/fEmGolNiKPNIbfLkUIakEeHEk6q4+nL9BotL+v0+oT40TnxRj8KmC3gB0mK4umUno+tW5lWnRvpHDBQEDxMGpkfmjGLICvSFSp7HpBiLFom56E2KLbuidhmKOU5I11rWxQrehgmcMANFrgAi6LAY3XYIB/k1AORzPyQ5H+O6JnWemFQ9KPGhQKvjry8IMH7wrxMVzDW51qmrqET0FaiCxgoI0TWBIgpwnqT9C2Z3LFwc3AqVpGhe8FEQpp2Kp+wH7qixGFwilWUDew7XHdNirQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+IDro81HnAGGh3MRfDiAB2CpWJ4MhTWn8dNV/1gYJ4Y=;
 b=gcB9UuyDLTF5jCnDQ689qWZPTtahcoZOGzJtI2oiNR5f9vkFq8gRODwzwg/LUXh9oxFFUu9/k7dl1GUcu89bJYxuDYwer0dNTAQRnuueI7aOY70ije6WFgidbG5vVMBErs2bUJnQxNlwGeOUxlPdI+a+DMHxKiETUm0yv8iEgh0=
Received: from BN0PR10MB5192.namprd10.prod.outlook.com (2603:10b6:408:115::8)
 by BN7PR10MB2627.namprd10.prod.outlook.com (2603:10b6:406:c8::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.20; Thu, 18 Nov
 2021 19:05:35 +0000
Received: from BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::8823:3dbf:b88f:2c0e]) by BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::8823:3dbf:b88f:2c0e%4]) with mapi id 15.20.4713.022; Thu, 18 Nov 2021
 19:05:35 +0000
From:   George Kennedy <george.kennedy@oracle.com>
To:     gregkh@linuxfoundation.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, dgilbert@interlog.com
Cc:     george.kennedy@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: scsi_debug: sanity check block descriptor length in resp_mode_select
Date:   Thu, 18 Nov 2021 14:03:28 -0500
Message-Id: <1637262208-28850-1-git-send-email-george.kennedy@oracle.com>
X-Mailer: git-send-email 1.9.4
Content-Type: text/plain
X-ClientProxiedBy: SN2PR01CA0017.prod.exchangelabs.com (2603:10b6:804:2::27)
 To BN0PR10MB5192.namprd10.prod.outlook.com (2603:10b6:408:115::8)
MIME-Version: 1.0
Received: from dhcp-10-152-13-169.usdhcp.oraclecorp.com.com (209.17.40.40) by SN2PR01CA0017.prod.exchangelabs.com (2603:10b6:804:2::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Thu, 18 Nov 2021 19:05:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71455e31-9dae-46f0-6534-08d9aac666ed
X-MS-TrafficTypeDiagnostic: BN7PR10MB2627:
X-Microsoft-Antispam-PRVS: <BN7PR10MB262795D60B312E6B6FE68CAFE69B9@BN7PR10MB2627.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b1ZmOMDFIT7AAvRnygZ4l0/HxZ+1C+HQNaCp/1SafYK9yl5L0VI8GR04aP8TNzHAZQJPSTsxlQgjK5IhB+pC78TuzP9tnKz9wn4qlWy8dAMZQYcm2FzHYq7BCsqUqmM3eIcovQ+++B7OY4+RcnjMkzHXv1bA1GdcctttICdZ2SI7AINzmAOAKY8Zx9Bsv9yFhT1ib5qUS46431qvIRajkCLnTm5EIWH/BDoXO7RYH6hDboLd2ErqnIRV0nXHyC8rI2MnSkXVIMsG5giNBYmyhCh14nqNQQS7PKom+sE2TWwtowI1nlCVDLMtninwokWD52F0znV9MjjFZsRhqlF0kJiW9BJDYuqOo2UWjw8ylYkWdVFd0ahQUaL/XVWusybDOGhhj2CA5oDBT24lhMHtoy4WQyQSfxlkd5+pXaP9ThXPqlt9nZYxKllMQdF86HOaVJNzEycKyYfR+IZWSFT4NLSkLQdM7WXM0LwDctfg7bgBNeT0HK0VzqqNK5PyrSI9oTEHr2LcLe6IjvulVHw4/EV7CE0DDnJt16BbVgvOSLdIng4muJgbzhiTzKYJ86zWi64waq3WoGQusLtzzRbEd+WDaXQZ5J3gEUxwkUCSTdjjMAAfULUqe3yfuVUK6RNUauZ4A06C3O6LCAmLMHMH2QdMTIjsmaQW8SLzXYetjoFHpSitHFbGoQAs/fn6Fz3Ggjg9liZ58elXCzdgAPPzLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5192.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(38100700002)(956004)(6666004)(5660300002)(66946007)(66476007)(6486002)(44832011)(38350700002)(6512007)(66556008)(8936002)(8676002)(6506007)(36756003)(4326008)(52116002)(186003)(26005)(508600001)(2616005)(86362001)(316002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g6TiYKrJWySZVMqP3GZaugTTGSLb1KozGPJtA8Gynf4M0pPl9vKB8WnCa6fB?=
 =?us-ascii?Q?8vxMsUS493ABrHp+AsY6Z8fgZhpjUFpwI0C81YIxGq9yH3LURuVQYNyShW4M?=
 =?us-ascii?Q?8PgtzjFRo24Mta6I1TQUC95L6glfOvig4TkJPj9RoKb0rCp42ORPQW0JX0jQ?=
 =?us-ascii?Q?7qgwTwoD1EDdJE1h0sW0NThWupKYQRP3fZmPvp4UKWoC2Ylv4aLpzkcjzXnA?=
 =?us-ascii?Q?63z0B/ZVRdMx41ojD53MFP9q4fhhFBh95WBP3ysJrcOPf3CTjPIWwmxGog5c?=
 =?us-ascii?Q?jRqbIaldf7Itgcvu3PQ20SCOfKWzPTQuvnJITYVeJwyh/G7CXffgT+9OF1kW?=
 =?us-ascii?Q?CRwDxbLdwmeex7tzQ1Khp4bGLhSCMwZ/toeuDdv1TFVYDosr2/dJW86W1KLc?=
 =?us-ascii?Q?it49bfo4tuHdnBZDOmUghVrXThc3YuvyY4kPZM+EKe4ehyVIhav+kZbslwTP?=
 =?us-ascii?Q?eVxOprNcEajrX/Rq2hsc9Mtixb913trzjxQDmTfNEei0LvhUkHTXFfSrWW0M?=
 =?us-ascii?Q?SiKEgGW1t9QB23UbrL1Bxr7Kz9vpSq7Jnb4Q6PIu7evNfB/MEeqFnfBmPabj?=
 =?us-ascii?Q?Ko+JfMqr/8fgoREeUeFIqkvr3x/23BpK7Hl/3ZOUiTCNIlml0f7KKxxjLJ+T?=
 =?us-ascii?Q?d6U8/c0uA2KnaU1vRf7gtMsejauphCdmEq8LAWhGYs4q6c0hndaNvG3DhIOO?=
 =?us-ascii?Q?qnZXZD5TQX4OskbSBqDWYudCneoKr8tsa157QCHQjPlyxz+NgmuwfC98w/KZ?=
 =?us-ascii?Q?L0HrNn9kFkTDUoByRQNWc0hVcRPZYEsvqz/Dvi0L5e6uajEfyJWL2uETkEDO?=
 =?us-ascii?Q?77XxGnFBOZ/Q0aHmLPHmaHAeci55zIcUZ8XbCowFK3XZftt8vo4QPP/MgFNd?=
 =?us-ascii?Q?+hoYX21Ivt1O7c21+5cZxMuKYmqAgn1Y+cJGX1Dni3FhnVyC0pQUfbwuv5bR?=
 =?us-ascii?Q?ntkfqmcfLuuTvfYk+iGUkvTvQKJpFNE7Of3u9NzH4HHeOmhq0k0DbIika2oV?=
 =?us-ascii?Q?xdRAm+uKCGpAQi6Ip0mUvDaMyyDfheNZuXM91iMSADw31db/tPYYsnckn/Xh?=
 =?us-ascii?Q?jpp4QT2BL7bDoalQgiSi9VhvLSvISMaJN50OP6FWyW3wusUKuEedtwUhzy18?=
 =?us-ascii?Q?40Umg+DbY4dv/L4ePahs/XH/t9Hl+7RGqzRT0Q5oWN5O1bQOcovTDs4sJc7N?=
 =?us-ascii?Q?1uxrH4zbODHuzs6u8pQeACjvXhJz/AGr9hepT+XXn5if3qLYgUnONmGgRsaV?=
 =?us-ascii?Q?LaYWo/6A6e/GsD4No/nWReqc5/2MeuBp+T/GNSir670ZGoaIBX0W9FcsbWq1?=
 =?us-ascii?Q?Bm7nV+T6XDLvdSjLcnGtWnTphvPfl+mkktlDqXdN9WRPMUqF76BzPWeOLPto?=
 =?us-ascii?Q?HEGx9wbWT8p/7O+8e91J8AhG5QzMFZRaeCFwNe71gFXNz81icXLnesfFyG2F?=
 =?us-ascii?Q?C6r6U3wIV9vOV/2Y5wfOYbSY4bfZMMDIfgGWHxhLL6pZXIftfEyuh0BIwP+D?=
 =?us-ascii?Q?dLYFy3EIhDW120JuCJG/Y6dPi2X6acXePi5oxWqHvfCRrCItiPqyFVAGqLjD?=
 =?us-ascii?Q?UveFphToN3pJLBRUmN/s6sXhpl9nDjM6foADZvy/fqRegKoEsM0OXl1+ROGt?=
 =?us-ascii?Q?RvzzIRPM8WlF4GMfUlY4ZLGWsIE+sPtpqi6CyQUKOlD4ZCRX8SZD/4CMdFke?=
 =?us-ascii?Q?99asGQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71455e31-9dae-46f0-6534-08d9aac666ed
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5192.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 19:05:35.8538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R/fIcw5gXtWpNxVLZgxU0B5HlMA6QKSl8tfSIzruIxlRvdXf8d2BAULShO6wrtUrSwgS0xrRHg+i2ydAmlShBa19qmEGsZeepggOmuOmQJk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2627
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10172 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111180101
X-Proofpoint-GUID: 62lkHl-KOwscIb1mNbbxXx3g76iuTrEN
X-Proofpoint-ORIG-GUID: 62lkHl-KOwscIb1mNbbxXx3g76iuTrEN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In resp_mode_select() sanity check the block descriptor len to avoid UAF.

BUG: KASAN: use-after-free in resp_mode_select+0xa4c/0xb40 drivers/scsi/scsi_debug.c:2509
Read of size 1 at addr ffff888026670f50 by task scsicmd/15032

CPU: 1 PID: 15032 Comm: scsicmd Not tainted 5.15.0-01d0625 #15
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
Call Trace:
 <TASK>
 dump_stack_lvl+0x89/0xb5 lib/dump_stack.c:107
 print_address_description.constprop.9+0x28/0x160 mm/kasan/report.c:257
 kasan_report.cold.14+0x7d/0x117 mm/kasan/report.c:443
 __asan_report_load1_noabort+0x14/0x20 mm/kasan/report_generic.c:306
 resp_mode_select+0xa4c/0xb40 drivers/scsi/scsi_debug.c:2509
 schedule_resp+0x4af/0x1a10 drivers/scsi/scsi_debug.c:5483
 scsi_debug_queuecommand+0x8c9/0x1e70 drivers/scsi/scsi_debug.c:7537
 scsi_queue_rq+0x16b4/0x2d10 drivers/scsi/scsi_lib.c:1521
 blk_mq_dispatch_rq_list+0xb9b/0x2700 block/blk-mq.c:1640
 __blk_mq_sched_dispatch_requests+0x28f/0x590 block/blk-mq-sched.c:325
 blk_mq_sched_dispatch_requests+0x105/0x190 block/blk-mq-sched.c:358
 __blk_mq_run_hw_queue+0xe5/0x150 block/blk-mq.c:1762
 __blk_mq_delay_run_hw_queue+0x4f8/0x5c0 block/blk-mq.c:1839
 blk_mq_run_hw_queue+0x18d/0x350 block/blk-mq.c:1891
 blk_mq_sched_insert_request+0x3db/0x4e0 block/blk-mq-sched.c:474
 blk_execute_rq_nowait+0x16b/0x1c0 block/blk-exec.c:63
 sg_common_write.isra.18+0xeb3/0x2000 drivers/scsi/sg.c:837
 sg_new_write.isra.19+0x570/0x8c0 drivers/scsi/sg.c:775
 sg_ioctl_common+0x14d6/0x2710 drivers/scsi/sg.c:941
 sg_ioctl+0xa2/0x180 drivers/scsi/sg.c:1166
 __x64_sys_ioctl+0x19d/0x220 fs/ioctl.c:52
 do_syscall_64+0x3a/0x80 arch/x86/entry/common.c:50
 entry_SYSCALL_64_after_hwframe+0x44/0xae arch/x86/entry/entry_64.S:113

Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: George Kennedy <george.kennedy@oracle.com>
---
 drivers/scsi/scsi_debug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 1d0278d..51e3b57 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2499,11 +2499,11 @@ static int resp_mode_select(struct scsi_cmnd *scp,
 			    __func__, param_len, res);
 	md_len = mselect6 ? (arr[0] + 1) : (get_unaligned_be16(arr + 0) + 2);
 	bd_len = mselect6 ? arr[3] : get_unaligned_be16(arr + 6);
-	if (md_len > 2) {
+	off = bd_len + (mselect6 ? 4 : 8);
+	if (md_len > 2 || off >= res) {
 		mk_sense_invalid_fld(scp, SDEB_IN_DATA, 0, -1);
 		return check_condition_result;
 	}
-	off = bd_len + (mselect6 ? 4 : 8);
 	mpage = arr[off] & 0x3f;
 	ps = !!(arr[off] & 0x80);
 	if (ps) {
-- 
1.8.3.1

