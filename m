Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95A1BC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 19:04:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FE2060EE9
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 19:04:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbhKCTGm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 15:06:42 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:7842 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229697AbhKCTGl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 15:06:41 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A3IXLiH023579;
        Wed, 3 Nov 2021 19:04:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=xpM91YzHjCuudD/R1z/xidkZGHS/JRC2fzg2kq8RNrI=;
 b=UEYLwOcfK/AI5KqiSy4u8VY/DkGwKQA5zPecnVoTAk5uG+RUc7whgbRhOziQ9iedPib5
 XNnd3T3zXHaz7Qe3ssXxCJQginDizEJIf53GH5mUApXNN7SB6uyj19ntFVHm4O6a14m6
 CbzwMTtXsXRvuA+PaGr+MWVb538IkDgsx7+4c0/z1uI2jWucdF8MvbpJQljZy1OmNeUj
 VetSv1LQvuK+g34K8iSCDuHTReu4IFBywC9t8u4ZH9/7kPIX9K8auWmzQ4naJDoFxCxR
 yX+2TChbDcGPZzgmD/B8uNHJIHvjoNtU1nfbXw7yjNwV/pvbArw1SnrNjOShdbchxJFU tA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c3mt5ca5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Nov 2021 19:04:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A3Itvae071817;
        Wed, 3 Nov 2021 19:03:59 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2043.outbound.protection.outlook.com [104.47.51.43])
        by aserp3020.oracle.com with ESMTP id 3c0wv6r6uj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Nov 2021 19:03:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YoDe9cBiRMBKDdM5C5jz/VO1LrNf1qrSeuF6tcuclhDASxvMjlT9KX7bXt2/DBzH7wqyuHBqQwzAQTmMLFg+o3soYLQoWTnhOcYhqV26IucbI+e30waW6HhUUi5R7eyYxChHVnQN841bBJv7WUW/kRWqPyqvowx/VvMt4qU+Vs7bkA15cPdggumiGQSSJ9PQOPRFuYhTRXK7ea1CBFM8IZPvgcwK6sIWujEhyp+iHk4fCDw8+9C86lR+KMr9MPBbvscBti+IoCgXdFncx8vAb0WbeK9HcXVwb3be70fcfmN5tKhV4pll6WGdZFCL0VK5iF1H3iyYES7ekgsWmyuSFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xpM91YzHjCuudD/R1z/xidkZGHS/JRC2fzg2kq8RNrI=;
 b=EoMo0P0p/cFdpNUkdsm48e1gJ2oGkqIUNxGfqev9ugCoTrY86gnWitoU7o0gPndL0JitZrQJUgccYKdGWy9t5jCNF4kImRyl2dU39HcDy8Qv68Dhc+FCDC/PxlMTysa8RG1VmQEWsec7ywA2VFUFO3nqgxVUulamGznegEiID5bN6cTCM2wSxL0IOy1rv7nCeN+RAWFk8vdslju83wONIzgpsEHzYrrq1a+T9dOhvwbxrLi1LjpX9VZsqsW8aiJDt7PVzTBkucJOk3T24OR00LUro78RV7ga+bBbkLlKk9479a27cXlOoCAtHIxdqhuP9nKu8LsXeNoy4EJnpwjsgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xpM91YzHjCuudD/R1z/xidkZGHS/JRC2fzg2kq8RNrI=;
 b=Rhn3vlgT2vyGXHsC1EIYxA0oBoYaiaFIwG9BVnF9KDq5BcNV65xQeEoNjyqmREf6FYHXDzh+JHEYCZjRq7jhtIgksb+rc1TtcpTKgdHdDWGRNjuB3C5IFOmNrmqjW5JEOBoNZJ6FWXSlOregPeu6u2kcL1WCOWNMwc5HNIDLHOE=
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BN0PR10MB5192.namprd10.prod.outlook.com (2603:10b6:408:115::8)
 by BN0PR10MB5254.namprd10.prod.outlook.com (2603:10b6:408:12f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Wed, 3 Nov
 2021 19:03:56 +0000
Received: from BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::8823:3dbf:b88f:2c0e]) by BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::8823:3dbf:b88f:2c0e%5]) with mapi id 15.20.4649.020; Wed, 3 Nov 2021
 19:03:56 +0000
From:   George Kennedy <george.kennedy@oracle.com>
To:     gregkh@linuxfoundation.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     george.kennedy@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com
Subject: [PATCH] scsi: scsi_debug: fix return checks for kcalloc
Date:   Wed,  3 Nov 2021 14:01:42 -0500
Message-Id: <1635966102-29320-1-git-send-email-george.kennedy@oracle.com>
X-Mailer: git-send-email 1.9.4
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0401CA0001.namprd04.prod.outlook.com
 (2603:10b6:803:21::11) To BN0PR10MB5192.namprd10.prod.outlook.com
 (2603:10b6:408:115::8)
MIME-Version: 1.0
Received: from dhcp-10-152-13-169.usdhcp.oraclecorp.com.com (209.17.40.37) by SN4PR0401CA0001.namprd04.prod.outlook.com (2603:10b6:803:21::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Wed, 3 Nov 2021 19:03:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0aea446-c3df-42b8-90b0-08d99efcaf37
X-MS-TrafficTypeDiagnostic: BN0PR10MB5254:
X-Microsoft-Antispam-PRVS: <BN0PR10MB525486D4D872F07BE17351E2E68C9@BN0PR10MB5254.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ebuJoAioQ509U60+5+M3/j/aBOjGY3wPXGqxOJaCp0WNa8vBCNdaILnUEqjMzRzk+zcEX2Lrox1Scsn+qyh8lBzCuHHvERJs7MkU9zMFO5BYuqsmD5hUml+SGK9xAXetgUbfPeopur+QC1h+JU2IsyHzGdH7+5jZCiPnBwlJUa3r0u9iwcS8jv1R4QkJqA7EtloaffmK6pLmR2yOC3WkzIVJi6v0ybeM82+jN2B/JkqoVNTXR+Nd0FU67FfjS0yfNQV637okwXXfOK7cdhJKhl7OH9rPTO1yeDD5WmyEDfDMmgFQy9r6HuTHklLtwDE1MbBtvMcJTn6KgtcqxqU3Xt6aELtNOexoZAUKgGHFyAAy8475AgDnkv82DNRVr3BA+9V7QXewMiv+EZaiRaRW9h9daTO4nFW+U0Wc88twIY7D0gKz+IzUt00gkWn0bdsRuFg4T9ao0ZA12J/M+8eJeCiRhUP1mCMsKbNm0J/a6REt6mF7wPbW0XBDWtHYbrFKDuT7jlTi2os9azs/Xmdy+9mbox3HuJ95AL0qjUECWjFb1nDP8zdyJENaJia+EAsZih6xqtyXFRoEKa5HBvd8IYEqXA5Grfn/rwxlWBGIMJ9+5CZmdfQrFF7Nx9BxC34HMAgythCHQiKyg43mZbnN2lqIvXSg0bm9DGjVJn3MJUTbspb0pwpf0/NZUDq3b29VdLAGEdMj+XfBAAzJ3zlanQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5192.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(44832011)(956004)(66946007)(8676002)(107886003)(8936002)(66476007)(66556008)(2616005)(83380400001)(52116002)(6512007)(316002)(6506007)(26005)(186003)(4326008)(36756003)(508600001)(6636002)(6666004)(38100700002)(38350700002)(6486002)(86362001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U//rSEbwPSQfGuqQwg/DbrnGlzlH0hoBoMc0EezpfdV1bturdn7qpbz5p5qQ?=
 =?us-ascii?Q?OBRHnTn9SrzDWTLyC3MPwZN93vFqVjNy76uZUAFwF9qJwshGkSO1bStfJ1zz?=
 =?us-ascii?Q?0FgAgneoepESN0GC/KFFrTdb99Cy+WAYkyWD8K/1G1crSBtpIzAK/Yj8zhkz?=
 =?us-ascii?Q?ZDuSKwC0p8B4vG/RZrENuQyK9yUTxpulW3YWNtN9qGfndsqPM5pnIHSCJXxO?=
 =?us-ascii?Q?KV7EW0UGAdh4gqfewYtun15VwLVBi4w/ru/jxYwnoVo0FO1l8ZkFLx5ZSOIf?=
 =?us-ascii?Q?Y9vb0W+tmmJOaUOUskq/d6uAhORkfuRHHV3rF91IF45F11r2CPBW48P1AcK8?=
 =?us-ascii?Q?fq7/1Xg9TdVIAvLjV65IynoGf3k5VKKBNrNsd5QqnbyemFjfL89p0SSA+/OI?=
 =?us-ascii?Q?vrnJktGgIjCaYFdAlOlBqo25Cly7qxLaVZRGFUwl+2uN5mHAqHGfWEAM661c?=
 =?us-ascii?Q?MU9nMZnalfeZOeds+UnqwnunUq8lli3ydQ8l4jGeiDhBVwC6hCQnAG9lIMVH?=
 =?us-ascii?Q?xJ5ps+0bqieSqwPER6FyDSLIVbyKs1HKJFu9MRLrdgLH1oV4OfTmtemxS4ww?=
 =?us-ascii?Q?MseScLl657ozX4h7eF/9HZayC520diuq92kU1zquLsfq4VG2ia5vVgvl2aB0?=
 =?us-ascii?Q?dhHM0j3GhbHdqH/G3ozZkjE9+zaapabojBc4aTK/I1+3sK1gNKf7ZwyMAkgI?=
 =?us-ascii?Q?N8ZCCBqhN/wUXjAjT/0JIZP1ZWuS4S3S/dxqNgcfU8H2V5wHFhxEsjUoicif?=
 =?us-ascii?Q?oxm5Aen5oTN93oCoyvVtp+bY3PlrqqlheViSckRqLuCiUpOcv5Wt257QzrIW?=
 =?us-ascii?Q?/Z+vN/ySg7KthdiJJhf8ll5WBTddgwNeiYWPpJkEIS6chvV66DD+tTc6pVLC?=
 =?us-ascii?Q?ev0Ne3PjcXS26B5Z2nGjB36fckXr8Hwb/veW/uzZfU6FL7rWoaNI4qB2XUED?=
 =?us-ascii?Q?wX0CpNCNPcu2aAOGCFe7RbN7PrwkJYe24nmlOvPurDLtua5Gwy35vDN1+j1R?=
 =?us-ascii?Q?jYnc0bFRrbQNGxKJOwz0qSCuRdgMJq2C3zjFhTCa2Zn0Iq7PSQW3c+gLiIcB?=
 =?us-ascii?Q?4oRKP8VpvgDqMz5S1JHPSGr6gDIlQYdE1bvAPeU+VSwY1xYeqlB6GpNkwiOr?=
 =?us-ascii?Q?kLJMxy8R2eEEQU3EtJfcIgzvClW3fnDoN+uvpDfiLsgFvWa9kFH+AKQN7e7q?=
 =?us-ascii?Q?NltCHNhl+w/3Vkv5e6xh44e53n6oA1FQ64tVvid3XC9TUqP41ljg2gszsWM3?=
 =?us-ascii?Q?ZPxb53sQdUThJ8uHxdkgxfU5JLnztiKR/S1cgGHTTVzWUktjUcqnpuFMPO6g?=
 =?us-ascii?Q?WlNmDKmAyIHob3Hor3Luc/pLknRLv89AaiFim13XwnLnwpZxtro9oebTWIpQ?=
 =?us-ascii?Q?8DvgVCeTq54pWAus4cbtmda+30kGSif5IYqJYF2N25t94fJ2z943DY4RW5On?=
 =?us-ascii?Q?tS/FjWzBymJMrNA5jm+ShUops34mZvkZaAusJu+7+aR9R/i7hZNDft5djBsw?=
 =?us-ascii?Q?itY7NNuiiSrsTU7ChhHiD3sBYlctuX0VW3aKR+IzNog/W0coK43/cr9uICGW?=
 =?us-ascii?Q?bMPsS7QdifKEh87O4zxRziN8MiyTBZ5SrYKgjqgnP2kVpHeXXGV92bMdc5Cg?=
 =?us-ascii?Q?onkrlTOQ9Nn1IKG0lKoprgq5YoSSNobvFtYE7C/5Ep9CGK3eCwAACk06NgFh?=
 =?us-ascii?Q?rWCEfg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0aea446-c3df-42b8-90b0-08d99efcaf37
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5192.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2021 19:03:56.0407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n4+fonhSXJqLzZkg7niGhmDsWBFw+bTCUwcfJibS5EpOKajHYLLt3EH8U/67VpMFY1z/Xw3qetthU0SiniX3lUDM+cxX+ngan6AYy6M9jI0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5254
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10157 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111030100
X-Proofpoint-ORIG-GUID: 60vUCEYzA5D_B16rDXrTyRhZ9Q8TrYqy
X-Proofpoint-GUID: 60vUCEYzA5D_B16rDXrTyRhZ9Q8TrYqy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Change return checks from kcalloc() to now check for NULL and
ZERO_SIZE_PTR using the ZERO_OR_NULL_PTR macro or the following
crash can occur if ZERO_SIZE_PTR indicator is returned.

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
 drivers/scsi/scsi_debug.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 40b473e..222e985 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3909,7 +3909,7 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 		return ret;
 	dnum = 2 * num;
 	arr = kcalloc(lb_size, dnum, GFP_ATOMIC);
-	if (NULL == arr) {
+	if (ZERO_OR_NULL_PTR(arr)) {
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
 				INSUFF_RES_ASCQ);
 		return check_condition_result;
@@ -4265,7 +4265,7 @@ static int resp_verify(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		return ret;
 
 	arr = kcalloc(lb_size, vnum, GFP_ATOMIC);
-	if (!arr) {
+	if (ZERO_OR_NULL_PTR(arr)) {
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
 				INSUFF_RES_ASCQ);
 		return check_condition_result;
@@ -4334,7 +4334,7 @@ static int resp_report_zones(struct scsi_cmnd *scp,
 			    max_zones);
 
 	arr = kcalloc(RZONES_DESC_HD, alloc_len, GFP_ATOMIC);
-	if (!arr) {
+	if (ZERO_OR_NULL_PTR(arr)) {
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
 				INSUFF_RES_ASCQ);
 		return check_condition_result;
-- 
1.8.3.1

