Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED497C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 11:38:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FCFD64E50
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 11:38:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235816AbhBDLiG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Feb 2021 06:38:06 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:38660 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235799AbhBDLg0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2021 06:36:26 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 114BZ00h122042;
        Thu, 4 Feb 2021 11:35:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=DUsGq8rQVt90eljYA/wSFh5hK7WjwbWj/lAPfT3zKfk=;
 b=Ji7xDJQO0zVCeiUoXdNREv4KevQCtk2v2AC1IeAllOIwIK+S2GbTXUuLvSYd8NaaI8pC
 nOUg6B+MEQvedSmSzjyFQA44Z3kLi0SBHFkvWk+tl9f5mahqRINU4z0ysjHqMoarw5PL
 ajD+Yn78fNSVit9B8h8bCUz6HwXkP+RA8UKG4+Bis4cxEdIZz/9OY54xS73Tdyk98XFP
 uo1CMw+d7o8QNU6I9XoS+ewBvh8JIuVmKv8eEu/tlnX4ZJPTXzDzI1YHkq6+zymebLY8
 gn5VhISYiNo/opLlXW+J1qybxW/ptH+Wb1GiXsbqKvkHpaa7uWgezijSDfjhCciahRVA uQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 36cydm4r7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Feb 2021 11:35:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 114BULCT037141;
        Thu, 4 Feb 2021 11:35:37 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by userp3020.oracle.com with ESMTP id 36dh7v17ss-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Feb 2021 11:35:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lnfNLL6yjkse/iz8TW7hNh+yIxspKJbcoemhjwgEDDWTcOyyMvSbhIR3J6psL5FksrRerK8aRjdKIGsw7BzHRQBcnsnfCNtWRJDHp6IAy7Y0UZ6yy9SYchvg7e9xW9N4Y/xXR/foXVMvPBm8Wd8uOZs1weM3J/26yfjCyMb12fT3x1KX9DjhNsFIs1eSL2ZH5SvMuchQ4d0VQb5QD5msuBkaFSK1EEEdfuJEChkMJ5Xlt2r0ZiJ+ckdZtJuTNQQ8BKIz2hNg9Ch95WmpYWHPzPR64/2780HxTcYb1x5h+OtNsfIhoCAB3kwpoRi52SSegtNbxdjzYzUR6eaAI6itdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DUsGq8rQVt90eljYA/wSFh5hK7WjwbWj/lAPfT3zKfk=;
 b=hqNzwhNpZYEzVi/92Y3s1Xf7w1LRv2gTwxGu6JIuS4TIwNAc58bLVdMV6UUEsAKoPiGkQIR7BIFph6oHLkNnveAhupGCUKsGUmERb/k8sL4pAw35j3UUbeRcdlKHlteUrA6aOMnDxyW5Vpnj+ceZ346VygOSFTsTLQSRQu/cVQhLisrDY7R5dlBTTbxRc8ZSnB33WSdixL02PUr/L6cEW+JEdLOHxI2R03+H7rUoUvmdqbrRfXtgUd1ov/PJ1Pafndv3bXF+rWsiiR+bQTkDh8neLpzNXxg14tpe1IjVIVCNZKJy/NcZrewE0EBu7CgN4zBLZwv56UVDBS1mo6duZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DUsGq8rQVt90eljYA/wSFh5hK7WjwbWj/lAPfT3zKfk=;
 b=K1o6KAi2dGL4BYiSXBV+9UCTQoEQF67Okn+PtkFy0+acPbcO413LNaYeneDUnmICXiqMb9oGcRj+2iEGivBGRSYNiVhyVUPJH0uDPd2PD5wI8Z5mErQ4X4IfQ6Axjux4ub2o0HZHt2sJ/CAJv/sfR+gZ1+3PgkoqW+3ltthIvQg=
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4480.namprd10.prod.outlook.com (2603:10b6:a03:2d7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Thu, 4 Feb
 2021 11:35:36 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3805.028; Thu, 4 Feb 2021
 11:35:36 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        stefanha@redhat.com, virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 10/11] target: replace work per cmd in completion path
Date:   Thu,  4 Feb 2021 05:35:12 -0600
Message-Id: <20210204113513.93204-11-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH0PR03CA0084.namprd03.prod.outlook.com (2603:10b6:610:cc::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Thu, 4 Feb 2021 11:35:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e1aefa1-1c5a-4ec3-4c3c-08d8c900fd3f
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4480:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4480A5C667F373882CEA3B04F1B39@SJ0PR10MB4480.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QO1P9eo0A252068jZbkJ6oGnHfbAw/ufC+bCR/OY0FN7DuP2k7LNwwpYBZstkw0evl/PAingCwFJZkYxk70U+jKQ9UAKulWu7G+mTrGFzVV5roQTCnBUgvsWNq4IGhjS49gqWLu9IfpKfGONRZ9252F25rQ6vdm/qJghuwAWEVF+RmWcOx25ZRogM/XpiGZHv5FZMUT3eIIhR8lm2tUAEVBGt7Xb2dVb28QVzam4/qoNlafUD8OsFYMUyaQUxsdJv8LOWX4TWz1hRh9UObQL2XrSPjeyJ0q2MNp+RpHM/pWCMTpbdarHTwLHaC9NhYO98G5H2mksF/26dRzjIzBlbu3dU2BDcpO2UaNfhJ3oqg1ghmMAaFjvIMxEjhC73PV38M6FirDoOhnqBUMNOrUG0Zn2OP0ULMZRUtto4hL/4mErX1Xi1SooHL9DcvljeegUxk5tWx4Pbuq9eXtt96M2FHrsKfhSgSPmwEziKEgCUzBfv/+lOR86/GuTQ8Il+eDBU+J9aXB0eMIrN0OXv9Cv1okRTbNRoez53dCk5hmIuYoKUquTUFvDSJSkcKICcJohmL5it8R6oyx2Ok62BUsSBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(396003)(366004)(52116002)(66946007)(66476007)(66556008)(26005)(6512007)(478600001)(16526019)(6486002)(8676002)(107886003)(8936002)(4326008)(186003)(2906002)(6506007)(5660300002)(6666004)(2616005)(1076003)(956004)(316002)(36756003)(86362001)(69590400011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?GeQADNlTYooVYkqRvw38OlMEpkRnXxonSCfLWMkBYiueC42KHEnECZy2MOTX?=
 =?us-ascii?Q?Z5az49yELyMwCrVPT6y9AHSjgIZ+87fuospl/ZcI2NpNc5Afx/gsqX/OsGqM?=
 =?us-ascii?Q?JXInmW720lbiM2KGrEHa7r6EQf+xnTLuVKinKVgJ0ATOw8jGZqWnZHL90dtw?=
 =?us-ascii?Q?ug/V5MRdQ3B8eXVCH+NVaqqGRA8Vss7IOfxKX/NQAKgQCqTtgfmzPc4+rJvU?=
 =?us-ascii?Q?13YdPP6i4mJi9N2faUw6BcC/G9KA/AAbnVXGwY0iQAcICAQ+hyy2aA1F1Jhk?=
 =?us-ascii?Q?roaaJgT7l80H5izbWdAOOTLp18o+a+YhBMGxZchAMfchnW17sxrw469GEArd?=
 =?us-ascii?Q?yh6PbVRhql08myCBcKfEH0LQd+suHHFvObsHzHT2/+5DshjSa/baFcsh5TTD?=
 =?us-ascii?Q?2SJ5syakt7z9dVxueB9JGhv8d9tUryRkcpHZqZ+47Tajg2aEgo28Y+KZr056?=
 =?us-ascii?Q?Yg1AH88MVh6Wh7V6cDE5g0zsSUeA5VOdzHjkLUc9GatkcKNOmADfnWxbO1ee?=
 =?us-ascii?Q?eMAxaGLOEcVO2tNkkJ1gNdcbZBk5K4554Qmh2WotTjYVwo7ev6HilWk10xoF?=
 =?us-ascii?Q?cNIGx8lQR/Vf6I3+dzlGXYYXF3bp+p2uzUkTVBD6mv8gml1snbQyBDh57bD4?=
 =?us-ascii?Q?umxhtxrhxr5Y6VbWrWgXF2mm0twsGPmW12ZCpoUkZc7ZzZngpBecyUeKQ+Yq?=
 =?us-ascii?Q?egGjUh6X9Et+fh2xsJQ1YLVEBg369Ty6uMJoZG/S7XCnl9ZazBnZ1LwE4SF2?=
 =?us-ascii?Q?SVMBtT3lJ5iZIBeQtGRdT+eEMuVAVfa3xM3Un4N2A9D+1z1t971BkcbDlcb7?=
 =?us-ascii?Q?jMPK4RNc9OWd5u7TADExWUviJXq9GPmgjtuDfWVceF6HOQWtMDJY6p0a+0wm?=
 =?us-ascii?Q?GbtTRMlJ6KzVuAKRm9tIxpMrv9r/gZq9k+/VWjdhZ4a5SPpxUXztwNXgsBdB?=
 =?us-ascii?Q?dQDNX1uuk3IfvUURVct/ECqyva9EQWwLQ+cfD8bHas9Yr0yo/8kdOYIwXNa+?=
 =?us-ascii?Q?qM0NTrSkOtRtRUNuoJfBWnQ/lXIcMRNwMVajm2JIqjcFaWP4h5xRfUsQL1P2?=
 =?us-ascii?Q?hYSIiJBKFTSRyyp8Fiu80IE2uS/dK1bofksghzS1DpBOsvvGkGedahFIWApR?=
 =?us-ascii?Q?hhvFALLwTXPvzUr++QL6V23t+/ySLog2Bc6Yq3Uq2expOEXWPdyjMq42m5xb?=
 =?us-ascii?Q?Ev0H56b+BfZEAdQg3YSI1DkMColva9GrE3l4NWP57m6R2FkVv7+axKMedGf4?=
 =?us-ascii?Q?lvkiaGRC417VpH1HfqR6Fm/17OFC8OGrW4vVmubtWeCvvuXodhiOq19CI6cb?=
 =?us-ascii?Q?FeNrMa1iGNYI+DSr9DVF5R2q?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e1aefa1-1c5a-4ec3-4c3c-08d8c900fd3f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 11:35:36.0890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nk1lNWoyE6Y9I6lvvnwyrdYaMmhRatC28bpxv21bu8yEjrgSrrBa6cNNprvk+n5OA90e1OUG3SLnmCZtbYXwPwl4edgwaJO38gi8ivo+FXY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4480
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102040072
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102040073
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Doing a work per cmd can lead to lots of threads being created.
This patch just replaces the completion work per cmd with a list.
Combined with the first patches this allows tcm loop with higher
perf initiators like iser to go from around 700K IOPs to 1000K
and reduces the number of threads that get created when the system
is under heavy load and hitting the initiator drivers tagging limits.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_transport.c | 124 +++++++++++++++----------
 include/target/target_core_base.h      |   1 +
 2 files changed, 77 insertions(+), 48 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 35aa201ed80b..57022285badb 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -55,7 +55,7 @@ static void transport_complete_task_attr(struct se_cmd *cmd);
 static void translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason);
 static void transport_handle_queue_full(struct se_cmd *cmd,
 		struct se_device *dev, int err, bool write_pending);
-static void target_complete_ok_work(struct work_struct *work);
+static void target_queued_compl_work(struct work_struct *work);
 
 int init_se_kmem_caches(void)
 {
@@ -295,10 +295,20 @@ static void target_queued_submit_work(struct work_struct *work)
 }
 
 static void target_queue_cmd_work(struct se_sess_cmd_queue *q,
-				  struct se_cmd *se_cmd, int cpu)
+				  struct se_cmd *se_cmd, int cpu,
+				  struct workqueue_struct *wq)
 {
 	llist_add(&se_cmd->se_cmd_list, &q->cmd_list);
-	queue_work_on(cpu, target_submission_wq, &q->work);
+	queue_work_on(cpu, wq, &q->work);
+}
+
+static void target_queue_cmd_compl(struct se_cmd *se_cmd)
+{
+	struct se_session *se_sess = se_cmd->se_sess;
+	int cpu = se_cmd->cpuid;
+
+	target_queue_cmd_work(&se_sess->cq[cpu], se_cmd, cpu,
+			      target_completion_wq);
 }
 
 /**
@@ -310,7 +320,8 @@ void target_queue_cmd_submit(struct se_session *se_sess, struct se_cmd *se_cmd)
 {
 	int cpu = smp_processor_id();
 
-	target_queue_cmd_work(&se_sess->sq[cpu], se_cmd, cpu);
+	target_queue_cmd_work(&se_sess->sq[cpu], se_cmd, cpu,
+			      target_submission_wq);
 }
 EXPORT_SYMBOL_GPL(target_queue_cmd_submit);
 
@@ -318,11 +329,13 @@ static void target_flush_queued_cmds(struct se_session *se_sess)
 {
 	int i;
 
-	if (!se_sess->sq)
-		return;
+	if (se_sess->sq) {
+		for (i = 0; i < se_sess->q_cnt; i++)
+			cancel_work_sync(&se_sess->sq[i].work);
+	}
 
 	for (i = 0; i < se_sess->q_cnt; i++)
-		cancel_work_sync(&se_sess->sq[i].work);
+		cancel_work_sync(&se_sess->cq[i].work);
 }
 
 static void target_init_sess_cmd_queues(struct se_session *se_sess,
@@ -359,13 +372,21 @@ int transport_init_session(const struct target_core_fabric_ops *tfo,
 	atomic_set(&se_sess->stopped, 0);
 	se_sess->tfo = tfo;
 
+	se_sess->cq = kcalloc(nr_cpu_ids, sizeof(*se_sess->cq), GFP_KERNEL);
+	if (!se_sess->cq)
+		return -ENOMEM;
+	se_sess->q_cnt = nr_cpu_ids;
+	target_init_sess_cmd_queues(se_sess, se_sess->cq,
+				    target_queued_compl_work);
+
 	if (tfo->submit_queued_cmd) {
 		se_sess->sq = kcalloc(nr_cpu_ids, sizeof(*se_sess->sq),
 				      GFP_KERNEL);
-		if (!se_sess->sq)
-			return -ENOMEM;
+		if (!se_sess->sq) {
+			rc = -ENOMEM;
+			goto free_cq;
+		}
 
-		se_sess->q_cnt = nr_cpu_ids;
 		target_init_sess_cmd_queues(se_sess, se_sess->sq,
 					    target_queued_submit_work);
 	}
@@ -379,12 +400,15 @@ int transport_init_session(const struct target_core_fabric_ops *tfo,
 
 free_sq:
 	kfree(se_sess->sq);
+free_cq:
+	kfree(se_sess->cq);
 	return rc;
 }
 EXPORT_SYMBOL(transport_init_session);
 
 void transport_uninit_session(struct se_session *se_sess)
 {
+	kfree(se_sess->cq);
 	kfree(se_sess->sq);
 	/*
 	 * Drivers like iscsi and loop do not call target_stop_session
@@ -877,14 +901,6 @@ static void transport_lun_remove_cmd(struct se_cmd *cmd)
 		percpu_ref_put(&lun->lun_ref);
 }
 
-static void target_complete_failure_work(struct work_struct *work)
-{
-	struct se_cmd *cmd = container_of(work, struct se_cmd, work);
-
-	transport_generic_request_failure(cmd,
-			TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE);
-}
-
 /*
  * Used when asking transport to copy Sense Data from the underlying
  * Linux/SCSI struct scsi_cmnd
@@ -972,13 +988,6 @@ static void target_handle_abort(struct se_cmd *cmd)
 	transport_cmd_check_stop_to_fabric(cmd);
 }
 
-static void target_abort_work(struct work_struct *work)
-{
-	struct se_cmd *cmd = container_of(work, struct se_cmd, work);
-
-	target_handle_abort(cmd);
-}
-
 static bool target_cmd_interrupted(struct se_cmd *cmd)
 {
 	int post_ret;
@@ -986,8 +995,8 @@ static bool target_cmd_interrupted(struct se_cmd *cmd)
 	if (cmd->transport_state & CMD_T_ABORTED) {
 		if (cmd->transport_complete_callback)
 			cmd->transport_complete_callback(cmd, false, &post_ret);
-		INIT_WORK(&cmd->work, target_abort_work);
-		queue_work(target_completion_wq, &cmd->work);
+
+		target_queue_cmd_compl(cmd);
 		return true;
 	} else if (cmd->transport_state & CMD_T_STOP) {
 		if (cmd->transport_complete_callback)
@@ -1002,7 +1011,6 @@ static bool target_cmd_interrupted(struct se_cmd *cmd)
 /* May be called from interrupt context so must not sleep. */
 void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 {
-	int success;
 	unsigned long flags;
 
 	if (target_cmd_interrupted(cmd))
@@ -1011,25 +1019,11 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 	cmd->scsi_status = scsi_status;
 
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
-	switch (cmd->scsi_status) {
-	case SAM_STAT_CHECK_CONDITION:
-		if (cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE)
-			success = 1;
-		else
-			success = 0;
-		break;
-	default:
-		success = 1;
-		break;
-	}
-
 	cmd->t_state = TRANSPORT_COMPLETE;
 	cmd->transport_state |= (CMD_T_COMPLETE | CMD_T_ACTIVE);
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
-	INIT_WORK(&cmd->work, success ? target_complete_ok_work :
-		  target_complete_failure_work);
-	queue_work_on(cmd->cpuid, target_completion_wq, &cmd->work);
+	target_queue_cmd_compl(cmd);
 }
 EXPORT_SYMBOL(target_complete_cmd);
 
@@ -2006,8 +2000,7 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 		cmd->transport_complete_callback(cmd, false, &post_ret);
 
 	if (cmd->transport_state & CMD_T_ABORTED) {
-		INIT_WORK(&cmd->work, target_abort_work);
-		queue_work(target_completion_wq, &cmd->work);
+		target_queue_cmd_compl(cmd);
 		return;
 	}
 
@@ -2433,10 +2426,32 @@ static bool target_read_prot_action(struct se_cmd *cmd)
 	return false;
 }
 
-static void target_complete_ok_work(struct work_struct *work)
+static void target_complete_cmd_work(struct se_cmd *cmd)
 {
-	struct se_cmd *cmd = container_of(work, struct se_cmd, work);
-	int ret;
+	int ret, success;
+
+	if (cmd->transport_state & CMD_T_ABORTED) {
+		target_handle_abort(cmd);
+		return;
+	}
+
+	switch (cmd->scsi_status) {
+	case SAM_STAT_CHECK_CONDITION:
+		if (cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE)
+			success = 1;
+		else
+			success = 0;
+		break;
+	default:
+		success = 1;
+		break;
+	}
+
+	if (!success) {
+		transport_generic_request_failure(cmd,
+				TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE);
+		return;
+	}
 
 	/*
 	 * Check if we need to move delayed/dormant tasks from cmds on the
@@ -2578,6 +2593,19 @@ static void target_complete_ok_work(struct work_struct *work)
 	transport_handle_queue_full(cmd, cmd->se_dev, ret, false);
 }
 
+static void target_queued_compl_work(struct work_struct *work)
+{
+	struct se_sess_cmd_queue *cq =
+				container_of(work, struct se_sess_cmd_queue,
+					     work);
+	struct se_cmd *se_cmd, *next_cmd;
+	struct llist_node *cmd_list;
+
+	cmd_list = llist_del_all(&cq->cmd_list);
+	llist_for_each_entry_safe(se_cmd, next_cmd, cmd_list, se_cmd_list)
+		target_complete_cmd_work(se_cmd);
+}
+
 void target_free_sgl(struct scatterlist *sgl, int nents)
 {
 	sgl_free_n_order(sgl, nents, 0);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 10ac30f7f638..6b32e8d26347 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -643,6 +643,7 @@ struct se_session {
 	void			*sess_cmd_map;
 	struct sbitmap_queue	sess_tag_pool;
 	const struct target_core_fabric_ops *tfo;
+	struct se_sess_cmd_queue *cq;
 	struct se_sess_cmd_queue *sq;
 	int			q_cnt;
 };
-- 
2.25.1

