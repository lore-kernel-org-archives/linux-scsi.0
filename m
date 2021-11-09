Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32E44C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Nov 2021 19:00:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1153E610FF
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Nov 2021 19:00:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242912AbhKITDY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Nov 2021 14:03:24 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:11696 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242898AbhKITDX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2021 14:03:23 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A9IttiM027948;
        Tue, 9 Nov 2021 19:00:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=Mo8iDOUslqRRWbg4Tvdg8oQKgQR4j9uIWrfB1/w5+4Y=;
 b=XzsvcTZtAgJFFylGM59Eoyuo8nF9fp7eWzSKQeDiVXbAtcnR6rC2ebmTl98pNnRBruxj
 YZCwtxpXBIiy4BcIIWApmGX0Ab1YGe7ovSqiUnlrIOuqCwxzFS5wrgYxrSR8jE8lgh/W
 i5Swv585CFt7+dp+DOlw6gI5lEFJLQQ36vvxClNFGLAqWofl4VqVXd4EhwtbrxjBgNsk
 wo3I0h14LgGHstr2hFdGn8R4roERJEAKlVS+lyzquq1xIZx5d7oaOKVj05cqxfMIu5pq
 bexOrQEVtDLRsjhULZikeO9i3m5TYiIsk1zgVGPCkaM63YLdGVexA++hbH7uFFcsgFlq rA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c6st8wxce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 19:00:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A9ItO7o014110;
        Tue, 9 Nov 2021 18:59:39 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by userp3030.oracle.com with ESMTP id 3c5etw4rg2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 18:59:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qh+q5ner2YkzXI10b/1j5E90O5Aw2aaa19oE0fxMmsbC7OQNV3o4oRcI7I2KmKKFFJDnfq2dN4u1zEg8bukdvbYw2cY1JpXG5o2b6ermaMKNk3cwq17OUv1iqYCp9igDsjYDNdhJnhxilpu4Y2AmHQaaaFc5J34uO9Wi4rLKEAtp5fXQSjdRTOdLfcgbI7AZg97Y7f9JG9O1Itk7rOm9OlkvbLh6hbXZv8Vfy/umaeoc/4wIqAQhNDCSJ6FeyE3PFNO1SwUbnukml9D+dAZjOSrIvVdldv6y+cR0e0jFDLcr1sAXakq69CKJyZgsc3fhwqwjzNpSxFtdnKjPMOV1WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mo8iDOUslqRRWbg4Tvdg8oQKgQR4j9uIWrfB1/w5+4Y=;
 b=ltzwP0qR/9HvUrHSdqL3VQrX4WN9f7ebI8hS7EPiSGZmOKDu5QhH/A/yQPOCdkpP+FPCiVmXqQXLDACfK1JDvJSNsKH9nS+RdvjoroWaPV4QjSEsnSVngy6wgbfUEy2Nb/iT9htin4Pkuhy8KFvi0BOq9068HM1kYr1lZjE2fJZvSyz5xdgvNAHU4rlnvnqwQ8Y8VLw5ZYLWJYWKSWMREBUaVtrAZ/yQ/JD1Elk505b8X2+icJgUZfYxAoTECDjI3OTyN4iC3rl62UnovsY9LZ0DxKIngIND+SbK3gaL7nPWs+AGTcxLGlMPu2whnic+z/sydz8YUYvpJI0dOhgO6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mo8iDOUslqRRWbg4Tvdg8oQKgQR4j9uIWrfB1/w5+4Y=;
 b=vZEhpocT//GfKQVjcAXpysbCkn2+Mm/Gball3M7L4EF7PIj1v+8iWn8vnAY8URyjfFBLZX+IJQQXf0ix7+cYwupZwEWXyC5H2HbsVzXXHvUBH0Lmj8VQ3Luo8emmZXGfI9jw7W6oQSnN8yNrVGn6QEZ4ysqBMSWgpf5N09AwdDs=
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BN0PR10MB5192.namprd10.prod.outlook.com (2603:10b6:408:115::8)
 by BN6PR10MB2001.namprd10.prod.outlook.com (2603:10b6:404:101::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Tue, 9 Nov
 2021 18:59:37 +0000
Received: from BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::8823:3dbf:b88f:2c0e]) by BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::8823:3dbf:b88f:2c0e%5]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 18:59:37 +0000
From:   George Kennedy <george.kennedy@oracle.com>
To:     gregkh@linuxfoundation.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, dgilbert@interlog.com
Cc:     george.kennedy@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 linux-next] scsi: scsi_debug: fix type in min_t to avoid stack OOB
Date:   Tue,  9 Nov 2021 13:57:27 -0500
Message-Id: <1636484247-21254-1-git-send-email-george.kennedy@oracle.com>
X-Mailer: git-send-email 1.9.4
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0257.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::22) To BN0PR10MB5192.namprd10.prod.outlook.com
 (2603:10b6:408:115::8)
MIME-Version: 1.0
Received: from dhcp-10-152-13-169.usdhcp.oraclecorp.com.com (209.17.40.42) by BL1PR13CA0257.namprd13.prod.outlook.com (2603:10b6:208:2ba::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.5 via Frontend Transport; Tue, 9 Nov 2021 18:59:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 919b0caa-61b2-4070-de1a-08d9a3b31386
X-MS-TrafficTypeDiagnostic: BN6PR10MB2001:
X-Microsoft-Antispam-PRVS: <BN6PR10MB20010304025946AB0A7C9401E6929@BN6PR10MB2001.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: otMPIY/lbKmQpJlr5wAuCYR7WmzunrWEPO9Cq8Jl5zKVrTBx0ScYY5CNvSAtBbSQ040GLlMtdyHo7Yo/+iaNAU1WZk4gxpZlVU2bWAb5b15wOTWJl1h7dTeAsvqmg0lUSTcw/D1ekT3DEmFbYxQhAoN5HsNhLL/SSuIlkN86NLo0/JWB4cN7/qpZsNJNsxNprS21YGGZgnWuOw0FfK+Dk084sRjvSmcJj/Nknr0+xNBJjWjA/fxI8cXR1nHvYuMC4ocADzDBu8vDYxZbimZMfp6voTnXtxvlJT1EgvDrt3yCgy4HMGnuBrvoW0aSzxqj/sCGaZnMbB4nQYV2YWNxE//9XT6q5zmwjrWhEUsJ+inUyqJekroVMi9VU6VlO5VAOTRQKkljUUEQ3qvl8rXiICvXC9Nir9ZbawCYKZLCmjNP0AnHx6fgw2QBM7EF9z3bvMm81StMyBpf5eqHF6wBgdiFLx8Jh+S+OOh2mt/dx1nqgLxcbFrgHstR9zkSOI7B3gcll8hFzjmU3ze/18FsDL1pAbj5n3qYBTGP+4nx5WQif+vWLrcFD6go3xO/biRllF+e5DXF25a0/Pre3V5mfHZxqDd3Zd1BFqhwX9NY4rPjEd122nfn0uSS0iWfKErYH1VAHWWDfhwi5tZIEwVRI+Tbo3BVqzRRhmb9ki2OwW06HIknNNHUK9Dt2QVqWikK2Ty2a6Yrut2Hkwkz4Tl/UQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5192.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(6512007)(956004)(316002)(2616005)(2906002)(66946007)(66556008)(66476007)(508600001)(44832011)(6506007)(36756003)(5660300002)(86362001)(38100700002)(38350700002)(52116002)(186003)(26005)(8676002)(4326008)(8936002)(6486002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ftz+qYgPwtu+cmvSSGc3GouJbCTZJwFei7FxutRv6CzOtv9YAv9IH7VRl+O3?=
 =?us-ascii?Q?DhLwJ4GajYwjKxcZN4ySA6fqg9IvbvGEjhsUsqzBiLUM3xCL6IHHp6R4OP77?=
 =?us-ascii?Q?L8xZxNVXgxXB34HjFjtrtdyTNFXwxZLZaO55FSu81ok5yeoDPwGzys14W6no?=
 =?us-ascii?Q?VF2Zv0u33msm2c8kLhBJIA4fnMLqEac3NvBMbNlTJzOY0nlF0410UBZHR1y/?=
 =?us-ascii?Q?NfvgJzp9HaWVvgxa3TOPPMbXQMOCVH98R1q2yiTMHJXPhHwzaEJO/BXtuert?=
 =?us-ascii?Q?ZlZsALxemFA/gZk0wqDWQG9hLiAcOIxdwxfT9EgUOsaO8Huhcl2Ehm/KWCOn?=
 =?us-ascii?Q?I3AzSvPK0AxrpX82vVqaB9JQ1zVsZsK5MAk7dtgxbVeEab3Ip/nsvHfHZ9ga?=
 =?us-ascii?Q?3DeRuOjKPSHscf09wBVBcci4zAdJ17bB6W6lEht6cLWSp/3B/ycGwtk6Cn65?=
 =?us-ascii?Q?zNBYJTfxtz2GnnxFoBkuRi1HanuPf87e1BV14BN+zeoa4wIGgl0f0KVLjv6q?=
 =?us-ascii?Q?QghMH+9K/rIG7ZbrguSvln2QC3LVqaAl7OogrdGNgX7+PTdLYnPlwc13B05a?=
 =?us-ascii?Q?w6q+Ri4QHYiqCF+nISzYufcWQaHhH8aiXOVjJJYwGIlKQbKlYBhuCgQoMLsp?=
 =?us-ascii?Q?8HAkckWJyMF4R4aDVBuYD96l+t1lS/tw/k+QxbBS6Xfvg2sffonps7bWNFaI?=
 =?us-ascii?Q?bjVfSoJ8wDWEwLWnjV8HH7in18ffck5pbMBcpeYsLfUtxcaD4JqTkz9aM2nf?=
 =?us-ascii?Q?8+EoVILiKy0kQad4558v8I8vnDyluT6bpnkEAc9tWNNioyqaUGKXdVoK8K0H?=
 =?us-ascii?Q?F4upDfuQIHr15qM7GnbphOD5Z8JANsVcjVNgvruwJrYqOEqUFsxig4LEa5JC?=
 =?us-ascii?Q?7avHsmRovcGNp5UzRUNIofcOyzzPPuO15jWSMxbctNYEpKHQTqils70+rgZc?=
 =?us-ascii?Q?BW+T+8Yhjy4FPPswCdw8gXAppjcCGWTL9StfCkNu+Nl08MiLntTLqo8p5kYs?=
 =?us-ascii?Q?hWkl19jqh4mXnJFrMM/EHkWSby3mDW4PAZVkdhv8yz4sP8fKL5WCAj0THP2d?=
 =?us-ascii?Q?nTpIOhf/4Cl80jUbJf/K1x/87M2mZBJR4YYPFsaPth5TaobDsNws6Ocp/Z2f?=
 =?us-ascii?Q?K1e0r28QoVjfTV5wxRGAit66M/3D06pAuopm0D+Rr5ZMOBwp2VA3zCNsN2Np?=
 =?us-ascii?Q?bTDsZZSR5JMpZ2lDNgdsnheZwH/qG2klIwuHWsUwFF3pHgQexeMpBT0f2bVW?=
 =?us-ascii?Q?yE6ISleDj3l+QLWyUE3uBmljXDNk8VDM6aY5T2aWhDBIASPwMUtbjJ7WtvKu?=
 =?us-ascii?Q?dsfz5B64C7A4On5U7406JQ/uqZifiMpOyaYEYrO0lK8jA8gxXHmw8U78aqt4?=
 =?us-ascii?Q?/t2veCWIDEhZ9SFBHp8Gmv5E7LwA0CEyeFcdwU1PTb4pzWXIZ6jbqvgPGN82?=
 =?us-ascii?Q?B5qiHWhCpuVwdWhyLBzUPOGh4Y5qWo9PlalyxV6IRAOYWY7S058S1TSLCs/q?=
 =?us-ascii?Q?87pdO0iyKyJTP6cRckNgqDfQTym3rHo4EnMpp6E5XhII5FaB+mBVvT9S1BCY?=
 =?us-ascii?Q?+a3T04yo1FY+kg2LB3fbv0VcQl1PG7sWk+6gOhh6KaOIHOWJAmxV4phxF6Sa?=
 =?us-ascii?Q?ArKstwa5qmUMpQUFmZ7Vnbeyde4maJafTn6kUPAHWh/flMOeaWaxMneuLN6u?=
 =?us-ascii?Q?eBr5hw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 919b0caa-61b2-4070-de1a-08d9a3b31386
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5192.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2021 18:59:37.3497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /jTr0P3obU3wyv7v9jKq1WNM6B0tQW/bZddf6mqLSELG44GZ29bdhSCWoLIDHy2yh4hES8246KU12JFV1DcVS0HChrPIRnbZPz79lBnRdp8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB2001
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10163 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111090107
X-Proofpoint-ORIG-GUID: TkrMI2auFW7pICch5KKqHgLFXpRf2bTp
X-Proofpoint-GUID: TkrMI2auFW7pICch5KKqHgLFXpRf2bTp
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Change min_t() to use type "u32" instead of type "int" to
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
 drivers/scsi/scsi_debug.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 1d0278d..ab01ef7 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1189,7 +1189,7 @@ static int p_fill_from_dev_buffer(struct scsi_cmnd *scp, const void *arr,
 		 __func__, off_dst, scsi_bufflen(scp), act_len,
 		 scsi_get_resid(scp));
 	n = scsi_bufflen(scp) - (off_dst + act_len);
-	scsi_set_resid(scp, min_t(int, scsi_get_resid(scp), n));
+	scsi_set_resid(scp, min_t(u32, scsi_get_resid(scp), n));
 	return 0;
 }
 
@@ -1562,7 +1562,8 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	unsigned char pq_pdt;
 	unsigned char *arr;
 	unsigned char *cmd = scp->cmnd;
-	int alloc_len, n, ret;
+	u32 alloc_len, n;
+	int ret;
 	bool have_wlun, is_disk, is_zbc, is_disk_zbc;
 
 	alloc_len = get_unaligned_be16(cmd + 3);
@@ -1585,7 +1586,8 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		kfree(arr);
 		return check_condition_result;
 	} else if (0x1 & cmd[1]) {  /* EVPD bit set */
-		int lu_id_num, port_group_id, target_dev_id, len;
+		int lu_id_num, port_group_id, target_dev_id;
+		u32 len;
 		char lu_id_str[6];
 		int host_no = devip->sdbg_host->shost->host_no;
 		
@@ -1676,9 +1678,9 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 			kfree(arr);
 			return check_condition_result;
 		}
-		len = min(get_unaligned_be16(arr + 2) + 4, alloc_len);
+		len = min_t(u32, get_unaligned_be16(arr + 2) + 4, alloc_len);
 		ret = fill_from_dev_buffer(scp, arr,
-			    min(len, SDEBUG_MAX_INQ_ARR_SZ));
+			    min_t(u32, len, SDEBUG_MAX_INQ_ARR_SZ));
 		kfree(arr);
 		return ret;
 	}
@@ -1714,7 +1716,7 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	}
 	put_unaligned_be16(0x2100, arr + n);	/* SPL-4 no version claimed */
 	ret = fill_from_dev_buffer(scp, arr,
-			    min_t(int, alloc_len, SDEBUG_LONG_INQ_SZ));
+			    min_t(u32, alloc_len, SDEBUG_LONG_INQ_SZ));
 	kfree(arr);
 	return ret;
 }
@@ -1729,8 +1731,8 @@ static int resp_requests(struct scsi_cmnd *scp,
 	unsigned char *cmd = scp->cmnd;
 	unsigned char arr[SCSI_SENSE_BUFFERSIZE];	/* assume >= 18 bytes */
 	bool dsense = !!(cmd[1] & 1);
-	int alloc_len = cmd[4];
-	int len = 18;
+	u32 alloc_len = cmd[4];
+	u32 len = 18;
 	int stopped_state = atomic_read(&devip->stopped);
 
 	memset(arr, 0, sizeof(arr));
@@ -1774,7 +1776,7 @@ static int resp_requests(struct scsi_cmnd *scp,
 			arr[7] = 0xa;
 		}
 	}
-	return fill_from_dev_buffer(scp, arr, min_t(int, len, alloc_len));
+	return fill_from_dev_buffer(scp, arr, min_t(u32, len, alloc_len));
 }
 
 static int resp_start_stop(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
@@ -2312,7 +2314,8 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 {
 	int pcontrol, pcode, subpcode, bd_len;
 	unsigned char dev_spec;
-	int alloc_len, offset, len, target_dev_id;
+	u32 alloc_len, offset, len;
+	int target_dev_id;
 	int target = scp->device->id;
 	unsigned char *ap;
 	unsigned char arr[SDEBUG_MAX_MSENSE_SZ];
@@ -2468,7 +2471,7 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 		arr[0] = offset - 1;
 	else
 		put_unaligned_be16((offset - 2), arr + 0);
-	return fill_from_dev_buffer(scp, arr, min_t(int, alloc_len, offset));
+	return fill_from_dev_buffer(scp, arr, min_t(u32, alloc_len, offset));
 }
 
 #define SDEBUG_MAX_MSELECT_SZ 512
@@ -2583,7 +2586,8 @@ static int resp_ie_l_pg(unsigned char *arr)
 static int resp_log_sense(struct scsi_cmnd *scp,
 			  struct sdebug_dev_info *devip)
 {
-	int ppc, sp, pcode, subpcode, alloc_len, len, n;
+	int ppc, sp, pcode, subpcode;
+	u32 alloc_len, len, n;
 	unsigned char arr[SDEBUG_MAX_LSENSE_SZ];
 	unsigned char *cmd = scp->cmnd;
 
@@ -2653,9 +2657,9 @@ static int resp_log_sense(struct scsi_cmnd *scp,
 		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 3, -1);
 		return check_condition_result;
 	}
-	len = min_t(int, get_unaligned_be16(arr + 2) + 4, alloc_len);
+	len = min_t(u32, get_unaligned_be16(arr + 2) + 4, alloc_len);
 	return fill_from_dev_buffer(scp, arr,
-		    min_t(int, len, SDEBUG_MAX_INQ_ARR_SZ));
+		    min_t(u32, len, SDEBUG_MAX_INQ_ARR_SZ));
 }
 
 static inline bool sdebug_dev_is_zoned(struct sdebug_dev_info *devip)
@@ -4430,7 +4434,7 @@ static int resp_report_zones(struct scsi_cmnd *scp,
 	put_unaligned_be64(sdebug_capacity - 1, arr + 8);
 
 	rep_len = (unsigned long)desc - (unsigned long)arr;
-	ret = fill_from_dev_buffer(scp, arr, min_t(int, alloc_len, rep_len));
+	ret = fill_from_dev_buffer(scp, arr, min_t(u32, alloc_len, rep_len));
 
 fini:
 	read_unlock(macc_lckp);
-- 
1.8.3.1

