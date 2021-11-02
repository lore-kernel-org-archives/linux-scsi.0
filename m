Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ADA1C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 12:50:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A0FF60F24
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 12:50:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbhKBMw5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Nov 2021 08:52:57 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:36886 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229712AbhKBMw4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2021 08:52:56 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A2BdeJI021981;
        Tue, 2 Nov 2021 12:50:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=diz4IT3VJeBNqxXSFcg/yMgwJzHoeJ3Rsx8mHTIv4Xs=;
 b=hTG8vNw6iA4RyFj9+rIPUsMsF1atHz448P1wUEL/A5/QGFlWrRLT7OiTQfqayEGuznQd
 mQ2y6qCS8LtUCPp7uMVej/Mcn1LGT69aPVsFwzzg08XYr/zg4+U0ou15Er48iqPph0WS
 36hy4B3NEjvTQyrWYQwueKtdVRf4xMCUbtE2qRLaco9G3pE6I3uFRKtmTl/jyZ0+73Pt
 WPxvUpa8rixIfezwkAoiTUrNHWRGISTUzp93eHfdt2VekXoW/EHlE/vQzRYSJoopYqN3
 7lIDiS8t9EoDGq5szk1B3MbgmaeqN/qI97tavAXrc8y3ZF3v9D+KWivtdJxHnnh/Gth+ HA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c278nfcn7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Nov 2021 12:50:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A2CoGcV196448;
        Tue, 2 Nov 2021 12:50:17 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by userp3020.oracle.com with ESMTP id 3c1khtecg3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Nov 2021 12:50:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CziEKd6jRpsbLsibrayF6QuTQzLJ002V1hMdI/LQlTbvjaxW6L45QLjrzJVoEGksc1uHDQKJsjQUR7hb0Ub48zClsHFK+ja5hNuy/Vq9LgZhdKnhrvXuIUHZNG69Y7b4gFPAwDU8koeMq6PFHQyWc5x6obHwLyEzuzySKhTng2Xr6q+/r2rQ8KoL4Z1GSWy/GJL9vsf1D5mLj3lchCkph3qtd7qKAUmlGbQDNneZDFOhG6A5pyBZ0Sp8nFdzFZJFXtaeBsIgY/ncOl1SU5WQ8iJzfoXesDXJJdIlIeokb9bSdRAIlMpOXctf7xkMW+qZAgPbmqcpuoz3t8MOplXTwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=diz4IT3VJeBNqxXSFcg/yMgwJzHoeJ3Rsx8mHTIv4Xs=;
 b=FrnBFZTi1oZ481MqMRNdfeJZ+sOlIET/On6em8eP1eLHab7ShXpBwiTWyESm2VG6WvbTcKxklZWy0SMGd5Hw/3g2YhzF38caxLLFikmVlTwXGHcwdxcz7U/uSkLuTxvv9MExf6KpCOCeHDHe6UPVG32LbKfAwxAwxlunHp6amnhtIE19yFiUiwc5kRInZemuA2KSlDIVHa+iIq3zVqfzZauvLqKdwdki0SXQZcrZYlcIWUscYigMDHdTdeDiFEz0Bh/4p2cOqNU/Bh3CLdi4nDgxa1JEnMcf9aghQF1A+ItSp64ENei2rOCzbkSoK+So2XHqxcjz/Za2zKvitmHkEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=diz4IT3VJeBNqxXSFcg/yMgwJzHoeJ3Rsx8mHTIv4Xs=;
 b=BTWKCXnGNhSFe80hZWaDB0VkczgCMCstZclGfrfucwU1T8/hKuevATwNEQkbHf+bdthT13Br9H8rXpm2dQsOBxTrt27FRB4L3n/AOfZD5xp1pE2xVU7VNDHxwPpLmygI40plHbKWQKZgHdh74fIDdYuNCGykgrYpyn9nTNhD4ro=
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BN0PR10MB5192.namprd10.prod.outlook.com (2603:10b6:408:115::8)
 by BN0PR10MB5046.namprd10.prod.outlook.com (2603:10b6:408:127::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Tue, 2 Nov
 2021 12:50:13 +0000
Received: from BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::8823:3dbf:b88f:2c0e]) by BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::8823:3dbf:b88f:2c0e%5]) with mapi id 15.20.4649.020; Tue, 2 Nov 2021
 12:50:13 +0000
From:   George Kennedy <george.kennedy@oracle.com>
To:     gregkh@linuxfoundation.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     george.kennedy@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com
Subject: [PATCH] scsi: scsi_debug: fix type in min_t to avoid stack OOB
Date:   Tue,  2 Nov 2021 07:47:58 -0500
Message-Id: <1635857278-29246-1-git-send-email-george.kennedy@oracle.com>
X-Mailer: git-send-email 1.9.4
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0003.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::16) To BN0PR10MB5192.namprd10.prod.outlook.com
 (2603:10b6:408:115::8)
MIME-Version: 1.0
Received: from dhcp-10-152-13-169.usdhcp.oraclecorp.com.com (209.17.40.42) by BYAPR02CA0003.namprd02.prod.outlook.com (2603:10b6:a02:ee::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.17 via Frontend Transport; Tue, 2 Nov 2021 12:50:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95fddadf-2bf2-4aea-5c1f-08d99dff5022
X-MS-TrafficTypeDiagnostic: BN0PR10MB5046:
X-Microsoft-Antispam-PRVS: <BN0PR10MB5046BF7943A2FA0E658B15D2E68B9@BN0PR10MB5046.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uOZoP8HdLfDEgDyTgOErLLPhpVkrtu2Xg3vpJEAgomw4R0+Cw8KtWVjo1lCtXe16gSB3kfwqDGLxY9qQVaU4mCwBZu2fercX85qSnILVDhCMR0zGtwdssolevy3I9lFlRClFvPGfOyicrBssXfDyybVg3iaGwrQdcPBgdH8NSqyuT5K8rNjXpp3el5DzAc/0uj8o/0XdXR451yPVjX3awN/3EzKMo00aCHKTZMQf50kKVA0n4i5R8UWccLrY0THobLCGotlRF+cuKvWe3F3NGD99pffHt7Bw1CvD/lT4sCWNboQbChTduvuxe4mn2w+RwfGAv9ZLHO6lKsNfe93sGpPxxa0MKJgUfNLoQHnyFWxHbkdOUKshmV1B9MUNXo3c8SAq4ijhqnG0ePOa5QJdGqCTC8PAPZLR0ITYyJBXZD9/LWp122wx8Zyznfa7XF4ZsxUy6UopjB6cYsauDcopiHO1D1itkzoCi62W0GQWs3yHIAA4aI1rmru5B25b+15vr+wmzlhBIN11Y7y0AnukUfMKcLgc5lVmhSXmBrqBERp86Nn0ZTCP3EGyi1x+71tE3DUxGnCG8yefahdkMAISGb/QfxHLn0ShT8fSYVTGop3LF6YpUoRT1q+wN2qIOXyNQz0qftWYkg8bx4jhIpRL2ofE35cWs1BrWpFlyW9TeLBMy7kFrZrlHu0Y81JCMCy5BDo//vZkNtLLg33yEsR72g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5192.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6636002)(186003)(6486002)(107886003)(44832011)(5660300002)(83380400001)(66946007)(6506007)(4326008)(66556008)(66476007)(508600001)(52116002)(36756003)(2616005)(2906002)(956004)(8676002)(26005)(316002)(8936002)(38100700002)(38350700002)(6512007)(86362001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JR6mwyLoBfl993P8NxeNiW1ID8ZkC0od1+nrQuyjDEZmdPyYWQspRjnCn1MS?=
 =?us-ascii?Q?/8Z/O0fpGHT5C9+xOJbvjYm7mJaXb6CE1CdkwYHfo4axjPXZQ7eNBkW2gah8?=
 =?us-ascii?Q?ntcXHUGaGx/L7sdYy9Dnj6Dt8XSQX6vjHsBLwh2YZ58xOn1jfCTmkEgZue7t?=
 =?us-ascii?Q?7Q+/2TrF/q+7oZcBXfdyFbixSPkg+WLCeIgqHUyOLTZwaUZl7vzVNAOg91hQ?=
 =?us-ascii?Q?esUjjhoVGecru7kFkG8BzMbsp3V2X6a7TNf6W2g4XdOmu8Mx7v3oILj2JSgd?=
 =?us-ascii?Q?HyLG5tnETh3MzMm4GBzXG+qPJKvxG6mPmc6eplXqo1JYCMdhxZZVRioMl8kG?=
 =?us-ascii?Q?4c+AkzGNlq6RQIsBRj3E+jqftmBgfMwiilQgi257W8Lbps1mNu9hB4QAHUBt?=
 =?us-ascii?Q?dvYqsancSDZEU4xtDEOhuAEbF5RP8wB2F6xlXb0G+qdqQT9rJ6+Lwo9EQsdu?=
 =?us-ascii?Q?DRXqd8kBCvSE7S02KasAXWyhWrYvm4sO4DZs6EUsWUaijezT9WK5oxBlKiPW?=
 =?us-ascii?Q?UzX7w2AW7NB4QG4fxdoOEo0qPT3pXiCF5Dhp+9qDEny9+ufRZUqElaUZ4ntr?=
 =?us-ascii?Q?gKS1Lu7jj2HXxsU9p+eFCoAoJLbKyH05Kdv1ikRauoEDGLGjNEJoZI0tsoMr?=
 =?us-ascii?Q?TUuon28TXkrtzUKqvsz9cFqVG4yd9vc9lIv9b14RcKPgrdZt8zHyMqhfIUQF?=
 =?us-ascii?Q?wNRmoc6DGsHaBchMX3ukMkXLupxYd9gmq92ObFL/g5Bn4p6Lg2BXL+qEZ3to?=
 =?us-ascii?Q?00I9buFIoRQcDcII1Ka6Qi7mXYxE+2i5g+/Ps/JsJew71/boXUvn1MEPvQIv?=
 =?us-ascii?Q?I3kEKUpOu51wMtBEkeaBc7atAJl6kkfVlV8w9JfwuOFdBOhnElVcVKjRIlQh?=
 =?us-ascii?Q?ihI3cvu8UTHBeGc7qOhRQ7Q8UQvOOyuRZHdxqe8HWRm0LT0j7aC8FvaQPZjn?=
 =?us-ascii?Q?RPrYm6yu4wt2OPuLnLOPyZ75x/tAbd82tpcuDlLvs6kHRC6kvY1Qp1DhuWCu?=
 =?us-ascii?Q?pJelHHnyJqlrhJxM9/KdsggNWxz1yH/EhBp2zl6qJWuqvOvCEiLDIzTXLSrf?=
 =?us-ascii?Q?UE8jlrJonJ8UE8LIGN4uvGG1NqId+gM3sZwtiFdOv+oNJiZQRsM+xgeA0rYH?=
 =?us-ascii?Q?Vyz4qHbm9/UfRE5C+mmM96kKraa1/a6tGaAdEsVP6atcX2PDtuDvZ0ia6Usr?=
 =?us-ascii?Q?gG01OCZSWvg16Z289P7xEaH8JNniq9P7ZggM/YBzNWQMupdktRqspXzX22oB?=
 =?us-ascii?Q?ga8/3yd9ghzkAGt90eAvKc17HOOjxo0nfgOVrfJZos3UKfJE0ezDXtUQRDXZ?=
 =?us-ascii?Q?mG3sLRjD3/hzlfcdj350+tv8s6sqD6E1sIw+YBJYI3YIoOmCYK+Y5kzbXnOF?=
 =?us-ascii?Q?bawa8BnARS3QS4SwQ4AvvXbwo+xo6jitCUy6C0w2GYbI9rJlnhj60HXb9qAR?=
 =?us-ascii?Q?A1B+XQt3GTjTynXYyERIBpQCEuqvoan8h8kjSSg8dBW9knjujwKu6xGn8oYr?=
 =?us-ascii?Q?3yPBwyu0zhVV0tG+UZbwjf/QOhP4Zmp8CTmDAg3aih68smsT3VJxNdtWo4KO?=
 =?us-ascii?Q?gPDL4KoeYl+hFmQsASaxkbH+aJFcf4GPNRNYvm5SNmB9mxh4f3YywVcmt1TB?=
 =?us-ascii?Q?88weL7dWOJ62ecckIqU8HbNtqTiHq3cviT5jXINaSL1giGgQtHhTUDMDOF7u?=
 =?us-ascii?Q?0ZF/Sg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95fddadf-2bf2-4aea-5c1f-08d99dff5022
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5192.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2021 12:50:13.8038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CcCBgsDMqg84Kha61uwYm9MvN9jwSvLQaHzSeHxJnl3wrcuGT823iRiUv9Ko3dRC9EHb0byCFk/JvDuFK+rNDYiVDvozTN8Zxdv719uuBYM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5046
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10155 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111020076
X-Proofpoint-GUID: ZCtQYrgzHEjHiuau8L_ITGRn_BqVnMSl
X-Proofpoint-ORIG-GUID: ZCtQYrgzHEjHiuau8L_ITGRn_BqVnMSl
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Change min_t() to use type "unsigned int" instead of type "int" to
avoid stack out of bounds. With min_t() type "int" the values get
sign extended and the larger value gets used causing stack out of bounds.

Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: George Kennedy <george.kennedy@oracle.com>

BUG: KASAN: stack-out-of-bounds in memcpy include/linux/fortify-string.h:191 [inline]
BUG: KASAN: stack-out-of-bounds in sg_copy_buffer+0x1de/0x240 lib/scatterlist.c:976
Read of size 127 at addr ffff888072607128 by task syz-executor.7/18707

CPU: 1 PID: 18707 Comm: syz-executor.7 Not tainted 5.15.0-syzk #1
Hardware name: Red Hat KVM, BIOS 1.13.0-2.module+el8.3.0+7860+a7792d29 04/01/2014
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

