Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F21BC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Nov 2021 15:13:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F76B60EB4
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Nov 2021 15:13:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233423AbhKEPPz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Nov 2021 11:15:55 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:60538 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233343AbhKEPPy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Nov 2021 11:15:54 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A5EYPl9003137;
        Fri, 5 Nov 2021 15:13:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=EeLj0ZZ0f9JGNBotyZZgQEdllWnO0uPkVbz2Naf8Nac=;
 b=Aoby/TD5X6Y+59IydSeEnSJXV19Tv+Pd+xWX7Cn1mXVvaM0sLfPEvZiULz1o3ZAjNTYF
 QkaAeYZRxW07qeBAwZnVPInKc4r2ptfkQHZwVeFhtU0AtNTYoQXOEgRDtIyp9Lq3sOze
 ut/ro7VfHouFHJrlbjSp361MmNb9EC1FPUy1iizEVokKB4rFepv1iQdhCSOBY+dBdEpg
 xkz9wIlNxHG4xj+Td9LGo0Cn033G8D/cZy2hzlyXJ3XCYBotzByNjL1g9ETmPPRcBj5B
 9nDSwemRbS4MIgtIplwoUrsmCK+LKORfuo8UGmgawBtabiM8n3biB3dYYGHBuXQYs4g7 4A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c4t7btypb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Nov 2021 15:13:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A5FBmsx103025;
        Fri, 5 Nov 2021 15:13:11 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by aserp3030.oracle.com with ESMTP id 3c4t5nrv07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Nov 2021 15:13:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DQhgWuPOC6AUtgNkfgr+8ihJ22NUL/qoqNZltVPB7V5k0+9wkePLUEj2Kjo/2TRqSbYexJul0wOc6OutCuUEahMRv8vzddRsacXsqyN5K3WF3R2trFObTXAI9fz0MNT7ZeCcvn7RRn0+m0Q1/pE4DRq8753CUsfh0zbLZm8kcYrMOmY+mqdIx1xOEZXpnCUFxqwMiiQzJoLMCt1nCPQnV/nDjYbzHkJIMkZtYrVu+damqvc7ngUjDmJ/DEDh+yigCGMRsJrX/AHKmabZDWShwRdcjrmNSWoQUmnK2+L0xywuWBme/GqWKY3z6ZpzsehPFGffGDDeUvPgCSgkFv+45g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EeLj0ZZ0f9JGNBotyZZgQEdllWnO0uPkVbz2Naf8Nac=;
 b=QM/jSWWW2RJDX6w4cvFYyU2JaNT1uspXTHD5DGPwF9cMgukknz7mjgJUAZZqKSeSDm0yWeKEl6XU1kkijt3wdmnKuuwU1fJznCL4dVrUlnHbROgC4tC5CSvS3jCawTuVKDQMyhy7fAumDESlRwCBCpYbei/fzRWH/6PRzU+NTEIBKgvwexV4H81DAYNCqRwh2/7Aub5SIWucTjk8XuEHFkouwvnjPnt9RFcIuIgQ4YsIr2/15U9SfsPXsRwSX0GmMmrVceV62O2/6Br6S+jThUXW4q3R00n0yJ/DODyIBXoqMd0SE9fArN9VrBnWRSPFjOPg4/AJ0pBc9NQbvOW9ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EeLj0ZZ0f9JGNBotyZZgQEdllWnO0uPkVbz2Naf8Nac=;
 b=KnoFuovk5MEGs7Bgf3NJRlxEIzyWrBR8HIza6azl7xwde0sYMp/TNvNjcX1UPI7BKHhLqh5zF/F+dNVTWvZnq2HHC15Hh18iLFak2QE/xUlNG0AimeYGOtxq/0omwcDf/amuO5iwqu5r8NEq90zT0/Dor3/zTkbuzN+VtkQBfAI=
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BN0PR10MB5192.namprd10.prod.outlook.com (2603:10b6:408:115::8)
 by BN0PR10MB5221.namprd10.prod.outlook.com (2603:10b6:408:122::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Fri, 5 Nov
 2021 15:13:09 +0000
Received: from BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::8823:3dbf:b88f:2c0e]) by BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::8823:3dbf:b88f:2c0e%5]) with mapi id 15.20.4669.013; Fri, 5 Nov 2021
 15:13:09 +0000
From:   George Kennedy <george.kennedy@oracle.com>
To:     gregkh@linuxfoundation.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     george.kennedy@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 linux-next] scsi: scsi_debug: fix type in min_t to avoid stack OOB
Date:   Fri,  5 Nov 2021 10:10:55 -0500
Message-Id: <1636125055-10909-1-git-send-email-george.kennedy@oracle.com>
X-Mailer: git-send-email 1.9.4
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0401CA0027.namprd04.prod.outlook.com
 (2603:10b6:803:2a::13) To BN0PR10MB5192.namprd10.prod.outlook.com
 (2603:10b6:408:115::8)
MIME-Version: 1.0
Received: from dhcp-10-152-13-169.usdhcp.oraclecorp.com.com (209.17.40.44) by SN4PR0401CA0027.namprd04.prod.outlook.com (2603:10b6:803:2a::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Fri, 5 Nov 2021 15:13:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8175f5c1-a338-4953-9def-08d9a06ec652
X-MS-TrafficTypeDiagnostic: BN0PR10MB5221:
X-Microsoft-Antispam-PRVS: <BN0PR10MB5221BA6F8728CD51F4790717E68E9@BN0PR10MB5221.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t4r7kzfb5HBPobQ75uIxPl4DsU1o/i9rMUuOX3tOE4UHSvst2JtP4U7xXl4I+OWYAFyo66uzg2RDA2YhgXWwYE4qD47DxNEyPUsmvsm5ag2IXGmPn8lURf6PdrHkGEHSxgrPa5nCt5Be8PnotLJ1FKbaoleia4EpJbRfc82MTLE250kjG+5rh5KYQq5IRJfO3izrqRNo5+uSrz/4/oycVeh7hUlK3CxktRv7PBLknukrLdRae81SSD3IAiKz2Z+571NcDKCqd3ijpyd+MYm/9WQxTPZfqrRfSqhSDdjSAqjRbpcv7CS5wAK4unGrJ5henPNzmwmqZ1spYzJ/o0GLl1mXbXiX4I7o26+vU/DjSnZlEF3y7rvXW+4Lfn+nTCJ73/gwqwU3YQcnudlTVzLN3cTDK3P7alVqfOjhFNbShl6WO/MHUtqflPS4no+e6eUXCelrZ/K+aHvs8pLueGMW/12cdUa57WOcBNSk77czovqiVla5Ixo6kyCRhYqBkLYlyLDIA0WoUtY5M5r206+orK9hntHRC6HMBJqokBn/x7Q90x12c+UH0LIYPJtWE7jTJR0jqYu6OTfkhuN93J/uQ6GSKnlzcL+jFSnwuGgA5BCwVAA0TGMCVMox9v0ZuCCnmU7bIMCHMifEpppPodXP2WSRoKNcQaaonIwCdUpwrZhjN2NbFV/83xf8stI052v7PbLgBo+vZRIVQHBdk2EOIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5192.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(4326008)(86362001)(6666004)(38100700002)(38350700002)(8676002)(66556008)(66946007)(66476007)(5660300002)(6486002)(2616005)(956004)(2906002)(6512007)(44832011)(508600001)(6506007)(36756003)(6636002)(26005)(52116002)(83380400001)(316002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o+0q9ujuCn0LeR21O8Y/13KpO1wHU+/b2PYl6ed9U7znp1jgLezNqc943NbD?=
 =?us-ascii?Q?6kv4vG7PMFn1702rSxyfU4ibeLEK0rh25otNCPbu+spgfEg+QIyccI9St9pc?=
 =?us-ascii?Q?FnnJ6SLzq//p9maZDwrISp+VLfbBDs9alMVQfCGli1AZDTVHaPkZirGLcDYe?=
 =?us-ascii?Q?W9r8I5m40cgu22qCdd/5v4P6flIfrdIxYPGFjFtgvLxb7ZHsXbcf8dXuX0Cp?=
 =?us-ascii?Q?BX6u07r8qFqL1go8rMbVbuOVar7GB+kFA50QPZriqVd8VUSeRtjSqqbXs9Tn?=
 =?us-ascii?Q?S255MLBnDRHEdYlUCIdpc6AFrmydfk3qnwPBrFwK8rq7ykOJzwGeLmU+bKix?=
 =?us-ascii?Q?1y6rE5rwtPvjo08KadbUa70N1xKQpvdcY1Kg9JJj6ZDvHpA/kfUez06G9mZI?=
 =?us-ascii?Q?6KPBgtdidfAjnbPLEKVDIbfL0qw4ABm1ITXBpLuJ+g/ejhm/beePY/cYJAxF?=
 =?us-ascii?Q?tUPr7cMgAEI3hVXLpQCTe4PBU9FfgKCwxywfDMTGUf/oAro6kWe34L18pvVD?=
 =?us-ascii?Q?wIyFfGrcPrk/zg+mRsO7vneeNP+vp/FSdB0GYeHQCMQaikkDADAKyprCfp2o?=
 =?us-ascii?Q?7+VK5tzfSUamGG+0Qlt+c/FrTkRrn6uXaKLn2+Z9sZ0X1e6G8goptCA77Sxv?=
 =?us-ascii?Q?b/3xXuB//Ce/95jpf+aQclUP9Y2REdhXIWVfFurJZwM5CrlSJ5y9INQtXlsi?=
 =?us-ascii?Q?Gs1CPT+HkImslC68q6vdddCiIu4COVaZRt2o2C0HzHi0wVd59Nzf3Bwoj4FE?=
 =?us-ascii?Q?3EFmJsGo7BA06ns+wvaY5LcWK7PqxiVR2CYIWngWGmC5IFuvuQWkc7Wjovhh?=
 =?us-ascii?Q?9ni0ckOE8v78XIJSWtIxj8axrARN3eekVDLRsJhtDiEN5uUNpZpRCwfh6r1E?=
 =?us-ascii?Q?navwhOwAHDDSlBwSjHid85Ki+5jr4amxOopgh9eueQ+C/zJEql8xSKBkdcCw?=
 =?us-ascii?Q?Kjq+Ha6yZr/dvNG8kI9fbOgcVQ4vofzVdDa+fr6MfXMkoRCT4g0XP6Sp4apR?=
 =?us-ascii?Q?NEhpeiO1BlxgirbCvEHSuaqsyiEozysokJFPpClWtHW7YeI2yrWKWnHDiOCo?=
 =?us-ascii?Q?XHZcl5+GfRKdwyXChZWImf/raEf8OsDHxJTUQchx0AeZ71T+QpQsmZojuumY?=
 =?us-ascii?Q?Cm0JyZFHzCJgxrdOvCN98F4dJ1b4liyRihQfNKTHgb3c/7y/IsPpn7KmhUnt?=
 =?us-ascii?Q?pfX5FbDQ95KSeuEESfd11T/vGTooq1UDpmjiv1vTjWFdGGb+M7ukOUm7pbav?=
 =?us-ascii?Q?ww7J0T9btwBHlIRam+nN5HPVK8xukzOdEsdAYaMd/67KaWmmdH7iQwRZt9LF?=
 =?us-ascii?Q?NswlaSlXGNHwe06XTtUv9nf5HTfqdr6PvJ9LB7/NfVWcX5SMnAiF8fP/IE/r?=
 =?us-ascii?Q?UXXOX/yTjm3YDVb0NbhuXSQxw7QhFnKaSoB4Z7aP0+JoUgbJuXh5da8FRu4J?=
 =?us-ascii?Q?3RKdQnvdDAWhJhFXnq4w32VLa3PtQap8mtJyiWB8U3lPhscIndyDn7Y4Xf2+?=
 =?us-ascii?Q?IcW0cm1UgtzJcHMXCqLj8v6S67nxVSrubcnelkZVxnTtaBFsNUwPhc8ltbJu?=
 =?us-ascii?Q?ZHGWqCjY8hsU+EBVyCQbZB0W8tzPkm2ANKetJqP5T5RbWu9OmcDohVw0blMA?=
 =?us-ascii?Q?cr0uMDH3B/77m/p8xJpONtg2O6A82+8u9negN/imWxoILX7Hlg6Or0+Scylr?=
 =?us-ascii?Q?/Q+LTQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8175f5c1-a338-4953-9def-08d9a06ec652
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5192.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2021 15:13:08.8315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KRXJRW1kIfv2YB+UBwVCCYEVwymkR9+jU36xhtJMHJmhMPNBdfjGLFkz3NsBaaCtFbejv2pjS7NFuxix70ByJZ17bqj2SDqZiENQ6aT3tzA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5221
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10158 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 adultscore=0 mlxscore=0 malwarescore=0 phishscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111050088
X-Proofpoint-GUID: hHcBUuj_9XeKwh8z6TAO3oXBkmtES6q3
X-Proofpoint-ORIG-GUID: hHcBUuj_9XeKwh8z6TAO3oXBkmtES6q3
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
 drivers/scsi/scsi_debug.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 06e7266..3b5ee42 100644
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
@@ -1714,7 +1715,7 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	}
 	put_unaligned_be16(0x2100, arr + n);	/* SPL-4 no version claimed */
 	ret = fill_from_dev_buffer(scp, arr,
-			    min_t(int, alloc_len, SDEBUG_LONG_INQ_SZ));
+			    min_t(u32, alloc_len, SDEBUG_LONG_INQ_SZ));
 	kfree(arr);
 	return ret;
 }
@@ -1729,8 +1730,8 @@ static int resp_requests(struct scsi_cmnd *scp,
 	unsigned char *cmd = scp->cmnd;
 	unsigned char arr[SCSI_SENSE_BUFFERSIZE];	/* assume >= 18 bytes */
 	bool dsense = !!(cmd[1] & 1);
-	int alloc_len = cmd[4];
-	int len = 18;
+	u32 alloc_len = cmd[4];
+	u32 len = 18;
 	int stopped_state = atomic_read(&devip->stopped);
 
 	memset(arr, 0, sizeof(arr));
@@ -1774,7 +1775,7 @@ static int resp_requests(struct scsi_cmnd *scp,
 			arr[7] = 0xa;
 		}
 	}
-	return fill_from_dev_buffer(scp, arr, min_t(int, len, alloc_len));
+	return fill_from_dev_buffer(scp, arr, min_t(u32, len, alloc_len));
 }
 
 static int resp_start_stop(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
@@ -2312,7 +2313,8 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 {
 	int pcontrol, pcode, subpcode, bd_len;
 	unsigned char dev_spec;
-	int alloc_len, offset, len, target_dev_id;
+	u32 alloc_len, offset, len;
+	int target_dev_id;
 	int target = scp->device->id;
 	unsigned char *ap;
 	unsigned char arr[SDEBUG_MAX_MSENSE_SZ];
@@ -2468,7 +2470,7 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 		arr[0] = offset - 1;
 	else
 		put_unaligned_be16((offset - 2), arr + 0);
-	return fill_from_dev_buffer(scp, arr, min_t(int, alloc_len, offset));
+	return fill_from_dev_buffer(scp, arr, min_t(u32, alloc_len, offset));
 }
 
 #define SDEBUG_MAX_MSELECT_SZ 512
@@ -2583,7 +2585,8 @@ static int resp_ie_l_pg(unsigned char *arr)
 static int resp_log_sense(struct scsi_cmnd *scp,
 			  struct sdebug_dev_info *devip)
 {
-	int ppc, sp, pcode, subpcode, alloc_len, len, n;
+	int ppc, sp, pcode, subpcode;
+	u32 alloc_len, len, n;
 	unsigned char arr[SDEBUG_MAX_LSENSE_SZ];
 	unsigned char *cmd = scp->cmnd;
 
@@ -2653,9 +2656,9 @@ static int resp_log_sense(struct scsi_cmnd *scp,
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
@@ -4426,7 +4429,7 @@ static int resp_report_zones(struct scsi_cmnd *scp,
 	put_unaligned_be64(sdebug_capacity - 1, arr + 8);
 
 	rep_len = (unsigned long)desc - (unsigned long)arr;
-	ret = fill_from_dev_buffer(scp, arr, min_t(int, alloc_len, rep_len));
+	ret = fill_from_dev_buffer(scp, arr, min_t(u32, alloc_len, rep_len));
 
 fini:
 	read_unlock(macc_lckp);
-- 
1.8.3.1

