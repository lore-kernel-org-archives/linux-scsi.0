Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4A01C433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 12:40:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8098164E50
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 12:40:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbhBIMk1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 07:40:27 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:42596 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbhBIMj4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 07:39:56 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119CZSep008730;
        Tue, 9 Feb 2021 12:39:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=OSCFIcw+tBeadXvOC1n4T7x3USrV/C467H2FsDnmOF0=;
 b=JlJGFFDkLgBo8NycMgJIMYd2qUXPfng6CxosqMp28wxnHQwRt2URyuL9n5s7xkErg4X0
 9DOoifLbPFXTQLsg6LHn8W45Lpgem2Ut1iif48QP/V0E6NVlwreT5RNDZep2RkfO+ZxH
 oCdfeGWPcTxvqhlyvjyywtDQzQimO/wxEp3FkYxjT5JlcuPMMH2a5E9SOH19mxQufxxs
 CUXyNT+nQ/5n1KMchLvdTNUek2UaktXYI8QCAo5yCsHadzm7Vp1Ahvpop+dZ9IDAHt/f
 avG4bIFvqaB2H5L2Xz209yytb0xjJ7hSBaU2oLEZLtUClEv2LEtNlRsTJQmXb3RuldDp xQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 36hk2kfajt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 12:39:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119CZJIf035198;
        Tue, 9 Feb 2021 12:39:10 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by userp3030.oracle.com with ESMTP id 36j51w15v2-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 12:39:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F8SH0VwrQtcQN7kgDBEPbfdPlC8BBxsozlLoTvs5hstBndaXeKz5MrWDrvqt8MdJeiN3fw6PDC40RjOn9tK3grKrfSTbuyzfG2y6tODmPDxZrqdlhO0RP/EwTMhHKgGiy37xM1nERGdYoJobALIfGB2c7wFM8QHxQsk4pwSQbAQQaa4vM3Nx06kXa0JrKC0RrATZafae1wU/PmDF66bYbygZp7d4123BkYfZfCunzHThPOxaVvI6AEIoyUCvp8/CnokRyBJxwlC+mVAmNS9pcLlk2hjfTMuh92567qozPTvxMrU3AlbR+ILJidsRsboTy4pklZuVfaM6uUBCx7OkZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OSCFIcw+tBeadXvOC1n4T7x3USrV/C467H2FsDnmOF0=;
 b=V7LzHMfaamHcxiEA1DWib9/aEsxAJX3/vZWD+8mK2cLtIWrJpbHCRNMbBlFF0XwFJ0PSTEWjo1UpadwG0m1qqjHMjiYIkrNKME+wtsIzF4B17WD+/Uon23fDuvyToKzM4Sw+RtU+Mr4TuMmtQkjXz/uwbKx2efVja9+D9Wlm77ApV+1EeszUzWdVlYBB0fO0cwUGZxtXdfodfZMOD1+ATfyli769MelLbkgcqnu7qwKTMeGBUH5byXL37665chRxJFhs/MetckDpoOiEoq0poH+xXqEZZdD0Mk3DvnG7R2T/DPiGThsDltQX923WKRy8X886KcWVcX6JOwNh+gVRCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OSCFIcw+tBeadXvOC1n4T7x3USrV/C467H2FsDnmOF0=;
 b=rMVeXr7aEJ3pk9Pvjh5VB8IcgDMn7WX1ypAsTFqpyBZtes8ecQwaTo21yoELit2OOuC/RIslkzBRkklmuRe6kYtnfvmGhm6g303IlLQPAbE+fc8Av+ZWfkVJ/q9q9F0dRLMvFv5GpnffUYHdfS8tqwIeg1iKw4n++dpsIpQQ3xs=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2600.namprd10.prod.outlook.com (2603:10b6:a02:aa::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.25; Tue, 9 Feb
 2021 12:39:08 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 12:39:08 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     Chaitanya.Kulkarni@wdc.com, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 12/13] target, vhost-scsi: don't switch cpus on completion
Date:   Tue,  9 Feb 2021 06:38:44 -0600
Message-Id: <20210209123845.4856-13-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210209123845.4856-1-michael.christie@oracle.com>
References: <20210209123845.4856-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR03CA0007.namprd03.prod.outlook.com
 (2603:10b6:610:59::17) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR03CA0007.namprd03.prod.outlook.com (2603:10b6:610:59::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Tue, 9 Feb 2021 12:39:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e6ea9c1-be35-45a8-71c3-08d8ccf7b1bb
X-MS-TrafficTypeDiagnostic: BYAPR10MB2600:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB2600047E04C247EFD0B67B99F18E9@BYAPR10MB2600.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GNdoq/FM+ILuwB3XErAeLREVUev7zV05pBQ39q+/m3gaQqsTe6ZC9ebwWaI5EyvyZzNqyTgBgOhrcvLNb9WcfD4qDZMZKhU7Hjz/o1s0RlTCrJf2L3QnwyFMl7iqBWlRyKRgnZjqzFq9ZXBJ/B78OE/HPfi54TOdjd813lHAPasWJdEOCyGCBDb+6RbjMpz2KF58AMW1+LMcwEbXUrBfzVWvBTtgiTrGqGsRit8+LecBAG66PRgg19ZAB11GwpD2MLHhmomioxab+eEd2tp7bX8XyP+fqLFaZ1RMERQ6GCBU/Xoay8AP6OaoaJ1pD9D2vMsVdunAitR4oYvJeUcXUpAwAvf74gq0Tpvfez9ygAN4dG1CiED8WijulcPDSSguXtS26EShiModkrMSVAXj9AMVV2HXjoomKLghliksnlsBbkk/jiWa5jtEbThpzx2Y2h2POO8D8SEmMNMV01K7h6CYWrkVVsT2XYtQdQGcJ9n9EOb3R1mpYyL6jiBcW90uwaF0G/y8BafWHJabxrpXXyilr6tWN3hgWPmN70OAtqiZsW9b+qePec5pXCBpKmyT9Y2vK7UUjV5xTCQub5YsCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(366004)(136003)(396003)(2906002)(6486002)(16526019)(8676002)(86362001)(8936002)(5660300002)(4326008)(6666004)(107886003)(1076003)(478600001)(6512007)(6506007)(52116002)(26005)(69590400011)(186003)(66946007)(66476007)(36756003)(66556008)(316002)(83380400001)(956004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ArKyj6Z/+LdgVEYOjHYUfsOy5itSmVGRbBERn3fnR4QXIH2eMt2bEFGnszYI?=
 =?us-ascii?Q?UqMA69DMpfqmh3FD5rNDAIoOQuHBuHZvYBT//jOMjljUdgNRz+4KlC7bw4/f?=
 =?us-ascii?Q?NNvoi8L/TrjqtGg6s0eV6plz5bZOTAMUchOOcxGpPaxxxW5CHkbzgqMKw+r6?=
 =?us-ascii?Q?r50hCESOAcNMpGv0Zf3pJp7LW97JCeXzYVHkaccYdEguDOa0ZnimjVEAA9Mc?=
 =?us-ascii?Q?ajMaTcBtavSzIPyfB+MIsEZAtdNVX/OMhxBnha/8XL5iw0UOA7cnj/+aDIn9?=
 =?us-ascii?Q?Y6teOYjFDPfyQF8I68KDMmYaswBnMLZ5x7+n3oPkqW0l2xqy5TH63DyaxTAW?=
 =?us-ascii?Q?fSxPF2nIeYHBNB1egEj9s4QgBs7algVrAX/CVtTSwpxqd5DCqJmQxn697MwX?=
 =?us-ascii?Q?f+vNgxn/lO/Y7o6gwlzB7N8TZzxIpuTqg8os8RFuFjg/3wN2fUBnO5TC0svu?=
 =?us-ascii?Q?xk2S3DDTYQix0GsUVGnyMDp1h6LI57G/14e1ZVES+nVg+OzUgJG7m0RvRMc0?=
 =?us-ascii?Q?W+GURbdcfQ2jBLAQOkLrCaMhhWYQzURoIvPsEO17hPUGdP5TjADwjkP72rFn?=
 =?us-ascii?Q?MCi6o3Fjskm9V8N557q/4XmoLNxkiIzHbJqRqAe5W4LTVKOaKQw7VHEYa3cE?=
 =?us-ascii?Q?YVYKykngQrh+uGerEoaJdnmOZ2/pQDdBTfIUE6AUTkILrARf3fgo95Yq0M+y?=
 =?us-ascii?Q?EQQQh+eLWD9WvlYNeqBK5YQh1EDWUSG5N6uxVj4kok63y4pzW84ch3HlQaPn?=
 =?us-ascii?Q?A4gQRHBI/sO03e2+JXpK109zH7XzHe7zp33IeIcL1F88bOwQLp5QFAM/wLPX?=
 =?us-ascii?Q?7yrI7ww+3CdgWuBR3/rr0OkwzWXdsaOV1iLYmLBT1UwLRZihG4Ss8Alm7ono?=
 =?us-ascii?Q?+SieugM8TgtrcregLKX+NHPfUnrxVN7+knBIabgYiGALOvwR/Ef5J379vh8/?=
 =?us-ascii?Q?+B4Rz3fe1JUYsGyf9AplLMEhnFxxh7A/4t/5hhLw9H5Cvum3Ak2aKwtoIU21?=
 =?us-ascii?Q?v3uMZ00+b8u4fVXbhFXri6pykVSm9MONNLFTRSEboyBfby0HvY9R2+8DD+A4?=
 =?us-ascii?Q?ABTkEVjfdKNvjHlPZXODZGFKw4kg2rb5SNRNIDNqFHe4yj9RD2W0P29gDTFo?=
 =?us-ascii?Q?q5IPS10qthTp8yL2c15BNwhl0u4llBwz+hXy1fFeoXY4dV+GTlvVIR7aHZOA?=
 =?us-ascii?Q?rMceqari0Zw5VSlIaCYesEvVtrLoNWPo9c3f+S7Mg8ug0THjcYavpcnNg6Ny?=
 =?us-ascii?Q?Qmkl63aU4gT94sb3pAsiuZeM33BYVXgua4lx8FNaOzZgJmcXl+fDQfELLUea?=
 =?us-ascii?Q?LvuUHuuS17XvrAmn8LGr+uku?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e6ea9c1-be35-45a8-71c3-08d8ccf7b1bb
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 12:39:08.5214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vc8TMmdPilGRu0JkrHpF7K0vlBxB047HiXpEtUVZr73zRQ4WGc9ZDvmb3RwLpy+Nf0vgLVdSQdRHpzb2CQJXdvDnVqiMiBqoLYm9/7gF3UI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2600
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090066
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 lowpriorityscore=0
 bulkscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090066
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

LIO wants to complete a cmd on the CPU it was submitted on, because
most drivers have per cpu or hw queue handlers. But, for vhost-scsi
which has the single thread for submissions and completions this
is not always the best thing to do since the thread could be running
on a different CPU now, and it conflicts with what the user has setup
in the lower levels with settings like the block layer rq_affinity
or for network block devices what the user has setup on their nic.

This patch has vhost-scsi tell LIO to complete the cmd on the CPU the
layer below LIO has completed the cmd on. We then stop fighting
the block, net and whatever layer/setting is below us.

With this patch and the previous ones I see an increase in IOPs by about
50% (234K -> 350K) for random 4K workloads like:

fio --filename=/dev/sda  --direct=1 --rw=randrw --bs=4k
--ioengine=libaio --iodepth=128  --numjobs=8 --time_based
--group_reporting --runtime=60

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/target/target_core_transport.c | 10 +++++++++-
 drivers/vhost/scsi.c                   |  3 ++-
 include/target/target_core_base.h      |  2 ++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index b1f920c1b816..e5e555dcd73a 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -828,7 +828,12 @@ static void target_queue_cmd_work(struct se_cmd_queue *q, struct se_cmd *se_cmd,
 static void target_queue_cmd_compl(struct se_cmd *se_cmd)
 {
 	struct se_device *se_dev = se_cmd->se_dev;
-	int cpu = se_cmd->cpuid;
+	int cpu;
+
+	if (se_cmd->se_cmd_flags & SCF_IGNORE_CPUID_COMPL)
+		cpu = smp_processor_id();
+	else
+		cpu = se_cmd->cpuid;
 
 	target_queue_cmd_work(&se_dev->queues[cpu].cq, se_cmd, cpu,
 			      target_completion_wq);
@@ -1609,6 +1614,9 @@ target_submit_prep(struct se_cmd *se_cmd, struct se_session *se_sess,
 	BUG_ON(!se_tpg);
 	BUG_ON(se_cmd->se_tfo || se_cmd->se_sess);
 
+	if (flags & TARGET_SCF_IGNORE_CPUID_COMPL)
+		se_cmd->se_cmd_flags |= SCF_IGNORE_CPUID_COMPL;
+
 	if (flags & TARGET_SCF_USE_CPUID)
 		se_cmd->se_cmd_flags |= SCF_USE_CPUID;
 	/*
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 99909c6f3960..b9addd5fdd28 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -803,7 +803,8 @@ static void vhost_scsi_target_queue_cmd(struct vhost_scsi_cmd *cmd)
 			&cmd->tvc_sense_buf[0], cmd->tvc_lun,
 			cmd->tvc_exp_data_len,
 			vhost_scsi_to_tcm_attr(cmd->tvc_task_attr),
-			cmd->tvc_data_direction, TARGET_SCF_ACK_KREF,
+			cmd->tvc_data_direction,
+			TARGET_SCF_ACK_KREF | TARGET_SCF_IGNORE_CPUID_COMPL,
 			sg_ptr, cmd->tvc_sgl_count, NULL, 0, sg_prot_ptr,
 			cmd->tvc_prot_sgl_count);
 	if (rc < 0) {
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index f2ba7de59da7..bb4ac7e6f560 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -146,6 +146,7 @@ enum se_cmd_flags_table {
 	SCF_USE_CPUID				= (1 << 16),
 	SCF_TASK_ATTR_SET			= (1 << 17),
 	SCF_TREAT_READ_AS_NORMAL		= (1 << 18),
+	SCF_IGNORE_CPUID_COMPL			= (1 << 19)
 };
 
 /*
@@ -195,6 +196,7 @@ enum target_sc_flags_table {
 	TARGET_SCF_ACK_KREF		= 0x02,
 	TARGET_SCF_UNKNOWN_SIZE		= 0x04,
 	TARGET_SCF_USE_CPUID		= 0x08,
+	TARGET_SCF_IGNORE_CPUID_COMPL	= 0x10,
 };
 
 /* fabric independent task management function values */
-- 
2.25.1

