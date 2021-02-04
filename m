Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C384C433E9
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 11:39:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 109DB64F45
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 11:39:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236058AbhBDLjZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Feb 2021 06:39:25 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:39788 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235675AbhBDLiZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2021 06:38:25 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 114BZ0CT122043;
        Thu, 4 Feb 2021 11:37:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=VMZxcFvzwLNYHH9m/5wgDVBDSjFJj3E6tS5Qnm5WVp0=;
 b=tbykdFqMv0w9jS3tTxsu+NMZOD81UYtpOyHWj280ZKmsIxoROAZFZkOLxCqQS3uIBWFr
 KKnaRBPoW3Nl+TbmkzytVwgJ9Z5pZw1VQ5AdPqRNIHZaQ2p42u6SqOuHETtn3ZHqoXeM
 6rxsilGGDVk8+28RBN1qDm4nys052spBLDY693h6n7GkYShP1MxlAVmOLmoEs148Ptk7
 3kevJNZOcPLds2puqrSK2l/z9thDooWPl79FSjEK07NH1eXmT28H20CUn7GbdDgKe9w5
 Cl5MdOzRxNbfD0fLD6dGVKsqcBvDz91OmoR6H1rgX5uBwevSEF69i9wP0LRez217a1AP ew== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 36cydm4rd2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Feb 2021 11:37:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 114BYerK134836;
        Thu, 4 Feb 2021 11:35:39 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by userp3030.oracle.com with ESMTP id 36dhd18811-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Feb 2021 11:35:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aEKAsaI7eXM8ERlfGvZlijgSqs2oZInNQ8fN70kaNgLEAYElAWDHhsnyBnMbLacFkjd/U+x7Fuubd/kTpN0eb1RdUIokvpkkbYMgjlMUHBSyfGaNeHXCP+ltYNRl8Mcvbo4MvbR/SK/jrD2gXE5MQDaqx9R7Z7lUhL6hW42Elfjbn2ABre6ASRhmHQPV3FMaJhfrl2bxHnAgju3hhpRETysAmg2XQFrQt52Y5k+GhRxKWH+mfLbptiAt0CW0Kv2xiFQxSOOv/t1906tZoMJcCrdWPkV9wzvVeRki1ubDKPfjYQmbohuzKGHANM0thtejl+CYn6Ive0DZaeICQd+Nag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VMZxcFvzwLNYHH9m/5wgDVBDSjFJj3E6tS5Qnm5WVp0=;
 b=N0um4EFKJQfzl1qat8V2ktwwLoKbHMEVhEHDswUWz2SwxoxdR+zXw13NQoGitk0DS/TYg127l3m3p+3Nb9GaW9Exy/Vqtlwc67uE8U2JzCjKoyn0G1ASrlvwMBasTGI5OWQPiRgjFVOXfnna5Wsf3EFeA8FpCYpoQ29XsR8YZYp4j0AZ0Yk/sQxtErRpLnPczi1vz05OC5vhxBe7bKNUMqrCrquPDz73fGlKQUFKDft08FW/+KED8qRkVYMzsm8SXf3Dtqov/jM7ABueBEKpfDfVfatxOzAT5zGz5mhPXe83AJ+89PsaIwkPdylQmmTZRvwNiG7PrdYWLzt0gzGeDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VMZxcFvzwLNYHH9m/5wgDVBDSjFJj3E6tS5Qnm5WVp0=;
 b=0SXw2/ORTLTfn5pvy3nmaFYVHl5N1qONYpkx6W2H0aVib3wHdJQoAVtdm3mp5T1wy9eLZ7QEOlirgGLEjZMFOHyZ/iD2Mirgz8VMFRmUjT1rEN+E5mqdWReDWsXb+J0+a659DPUfY1Zs0rzMadVXACNqBtSJQgQUOblb54+hJKk=
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4480.namprd10.prod.outlook.com (2603:10b6:a03:2d7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Thu, 4 Feb
 2021 11:35:37 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3805.028; Thu, 4 Feb 2021
 11:35:37 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        stefanha@redhat.com, virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 11/11] target, vhost-scsi: don't switch cpus on completion
Date:   Thu,  4 Feb 2021 05:35:13 -0600
Message-Id: <20210204113513.93204-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210204113513.93204-1-michael.christie@oracle.com>
References: <20210204113513.93204-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR03CA0084.namprd03.prod.outlook.com
 (2603:10b6:610:cc::29) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH0PR03CA0084.namprd03.prod.outlook.com (2603:10b6:610:cc::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Thu, 4 Feb 2021 11:35:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 72ad7924-b932-4f9a-0a4b-08d8c900fe0b
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4480:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB448085E52648AC2BD3474865F1B39@SJ0PR10MB4480.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zsiETygP0Ra/Pi5/WypQwlENFqj8PxAFpiw2cD4x5PfQ0RSQJsDm24cmjqlKC8w6NSXhsM+RbSux2L/E6MfVKFI035Zkp3KlOzcdQd49ss9gFlLm5NOC69q0wtX0mVT8ET8Ae16BW3hUDj4STxIR4TTfO7yq3XPD0afleAHqTBTdTABxwHKIKdmmzjZJ5RaiRwyQYeeHfjyJfS/16FXOP/lebIFTI5b0GniyoaWYTzsGOpG9MnnmYNRD6TX6BZWoWnL45qw8XWMrrxQCeVxMS8TSW7/AG0cXrgoY0u2dvYb3+xXh2HQvAS4d15VZri3v1iXQGFmvZMsTXm0Mkt4K5JC7RYG0Pc82qLlA9k/yRvDTqHPyRnaDhHIv375pEX1s5shkk7yd9TuBYak/pNsfVcJN2LQdMriqGrrcWxPmQAVKF3thMRCpmVDGNtlzd7XtO0UfMgHdqziDIG1gSYxdt4TghCeIZ4JdkrrL3cjolb6VHFBrRyBRJx8xOO2u3WBfm4ZsTlprxyHHIvXPrOz59RThpVnsc2J+RQPDmQrQP6JJx+8iLQOc7uR40HzqNUC8cTnUFIL+FGTBrbjMSA2k5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(396003)(366004)(52116002)(66946007)(66476007)(66556008)(26005)(6512007)(478600001)(16526019)(6486002)(8676002)(107886003)(8936002)(4326008)(186003)(2906002)(6506007)(5660300002)(6666004)(2616005)(1076003)(956004)(316002)(36756003)(86362001)(69590400011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?gtKEuKNROxEXV9oZqe6Ltp3JKDzrIYEEBLsQZc/B/HzhwC06Pz/TRbTCRaa9?=
 =?us-ascii?Q?x0MdmQ6sUSjzlLOmI7RgP+hn7J8bi02lZNF5nai6sdbH5Anj2312IOSRia0r?=
 =?us-ascii?Q?ig9JbBGfKBjtrfU6LY7C+jY2KXfVnkTMwYvzTMgWq3c24lo1CvM9ZCdHhrnL?=
 =?us-ascii?Q?UjO/4hChpW/cqfScLW0L34NAY/sMyqC6wp17+//YsWO1OzGB1OIPyVbft+uo?=
 =?us-ascii?Q?eAKLXq+TvfSx9Mk7o0Mp/fQnZh7BzCEy0WLLuZTY/5K45G0pCOljRP+odXF0?=
 =?us-ascii?Q?2BQr4tGzNGzh1pdG7hKR36EcTi06Z4naNUV8UmzSqSheY5qj41sj/t+K/1Ev?=
 =?us-ascii?Q?t8wIzCbLyOwLE0WW4UJTwwowdfifdjdnVIwk1MmKR+3ZO/nhYrzXw02FZC9N?=
 =?us-ascii?Q?/51EcYLSePl3deoHSHJhUyt8faHmt+7l/oWVijZnIG3vov+l5jw4Hj2dfRWd?=
 =?us-ascii?Q?XDSHBvp3/CyeECcjFgWuX9seDa+FPXDE9KNuygXzQ5HjyRQaJ+fK262DdChw?=
 =?us-ascii?Q?ECIP1JDYbF5jEai9uH4d5vG4Bqxzl2J/wqWZbm22nQfKC73m/quXwary0cKs?=
 =?us-ascii?Q?bEKSG+7mEtwCW/9N1YQel8kh+FWgA25RmFzDlAK/TYYuuxTgRI4hUd575RZG?=
 =?us-ascii?Q?U//qCFsdQgC13QcLDlaHl8YQsaWTmzld6f+evNhZIXJXre6xPxACaYuWp6Vh?=
 =?us-ascii?Q?M1/NUpU/kqWjLIuqDIS1M5WzHZtR8hNrwpSqrGzI/272ceyHSJxIIbqTHK1A?=
 =?us-ascii?Q?s3YrD62k9xgUDE80Ob84kfhjTV0Efb5xBoMyFQbv3PBPAU/UVOpGhgn0FXIz?=
 =?us-ascii?Q?7rUEGZ8KLaIi0sUW433nokoU9H7hi25uoJ3jCUJZp6LpCOTMmAZPGr2o0/R3?=
 =?us-ascii?Q?G0LKViDxRoutMgXEMBiuUhDV52sKEB7Hm4vVdrXmqJFdbV978k0xUFK265Df?=
 =?us-ascii?Q?K6zPT6JhhNScncTBt1q+PZpuahvH1C7tjQi4HFMl9OkhHlCGB4oZ/IaancH4?=
 =?us-ascii?Q?6lagevtfQAuRkIEiqwv98WQbT2wtvv9hkxQtRP1jobuExteiglSRl7fsJQr2?=
 =?us-ascii?Q?fnSVq78aEW98zlDn19tZCQ3KFrixf26bwVhlZmCTy7eph3s0NTY1rVs8fkMT?=
 =?us-ascii?Q?4LPz+dneyCL7pugBp7iigLWm/ktz5GBzS4gLvM+X7ZRmT37oxqj7GQIlrccU?=
 =?us-ascii?Q?zUPlpclpG74mNo+soyMoEEY5JEZnnL+U/xzNmaOVIkk8TxoyQNZTsKEY0uYm?=
 =?us-ascii?Q?9z5edXbG4D3aiTjIkI5c0WvbnGbz7rUL8c12BT0/sKUJNLjhy2L9R0M0IP8L?=
 =?us-ascii?Q?v+/uyU9w+XSnk2OMpX7GgLC2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72ad7924-b932-4f9a-0a4b-08d8c900fe0b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 11:35:37.4033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FhAzZTe2uZnQ8pUSYRRPX5MZkLvu4VfYJqmlnd5Bf0tbOlgvS/5Z7I9BaoIcxXGMtl2U79luefgQlsB3OBUt+MWFhmjjGgVDETHNhRS6vAY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4480
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102040073
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102040073
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
---
 drivers/target/target_core_transport.c | 10 +++++++++-
 drivers/vhost/scsi.c                   |  3 ++-
 include/target/target_core_base.h      |  2 ++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 57022285badb..5475f628a119 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -305,7 +305,12 @@ static void target_queue_cmd_work(struct se_sess_cmd_queue *q,
 static void target_queue_cmd_compl(struct se_cmd *se_cmd)
 {
 	struct se_session *se_sess = se_cmd->se_sess;
-	int cpu = se_cmd->cpuid;
+	int cpu;
+
+	if (se_cmd->se_cmd_flags & SCF_IGNORE_CPUID_COMPL)
+		cpu = smp_processor_id();
+	else
+		cpu = se_cmd->cpuid;
 
 	target_queue_cmd_work(&se_sess->cq[cpu], se_cmd, cpu,
 			      target_completion_wq);
@@ -1758,6 +1763,9 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 	BUG_ON(!se_tpg);
 	BUG_ON(se_cmd->se_tfo || se_cmd->se_sess);
 
+	if (flags & TARGET_SCF_IGNORE_CPUID_COMPL)
+		se_cmd->se_cmd_flags |= SCF_IGNORE_CPUID_COMPL;
+
 	if (flags & TARGET_SCF_USE_CPUID)
 		se_cmd->se_cmd_flags |= SCF_USE_CPUID;
 	/*
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index aacad9e222ff..baee85dbf97c 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -804,7 +804,8 @@ static void vhost_scsi_submit_queued_cmd(struct se_cmd *se_cmd)
 			cmd->tvc_cdb, &cmd->tvc_sense_buf[0],
 			cmd->tvc_lun, cmd->tvc_exp_data_len,
 			vhost_scsi_to_tcm_attr(cmd->tvc_task_attr),
-			cmd->tvc_data_direction, TARGET_SCF_ACK_KREF,
+			cmd->tvc_data_direction,
+			TARGET_SCF_ACK_KREF | TARGET_SCF_IGNORE_CPUID_COMPL,
 			sg_ptr, cmd->tvc_sgl_count, NULL, 0, sg_prot_ptr,
 			cmd->tvc_prot_sgl_count);
 	if (rc < 0) {
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 6b32e8d26347..13514c59ae3d 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -147,6 +147,7 @@ enum se_cmd_flags_table {
 	SCF_TASK_ATTR_SET			= (1 << 17),
 	SCF_TREAT_READ_AS_NORMAL		= (1 << 18),
 	SCF_BATCHED				= (1 << 19),
+	SCF_IGNORE_CPUID_COMPL			= (1 << 20),
 };
 
 /*
@@ -197,6 +198,7 @@ enum target_sc_flags_table {
 	TARGET_SCF_ACK_KREF		= 0x02,
 	TARGET_SCF_UNKNOWN_SIZE		= 0x04,
 	TARGET_SCF_USE_CPUID		= 0x08,
+	TARGET_SCF_IGNORE_CPUID_COMPL	= 0x10,
 };
 
 /* fabric independent task management function values */
-- 
2.25.1

