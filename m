Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CB65C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 11:38:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 883AB64F44
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 11:38:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235866AbhBDLh5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Feb 2021 06:37:57 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:38536 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235877AbhBDLgM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2021 06:36:12 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 114BZ0Tf122033;
        Thu, 4 Feb 2021 11:35:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=H/0FEOl+dZ3K/w0U7uGdBe6WHG5+aAYUJnMUHipTrTo=;
 b=W9UeeTgvUMolvn0ouJyZR9aNu2UKy05oRfC85fv1ZSWAAU8/sp+p4cDtUw57KzlFd2MF
 Wfd0pXARrGganaq+hmmEKNEGioejIVI8hmR+lfc4yepgaAm3lXREptHzBFABOTm+VFpY
 3deu5unbKnWneg9DbtFCobLwnhtrB0WF1ilYc88YDAHXiP3ljsHxmz21GUnJ2ur2uhGR
 rrMtWwt2wBBZAj+E4jeNYLfl9yb8+nvKKG65WHMOhTI529Hjl/Sp8JVfwAV40qcX4CJo
 o2XYa2CDg8e6+anm8tJCkpRbQNJiIi7gNlj5sD+dRxdUQVOb3FR1fSI5s51LZTJs1rZi 0A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 36cydm4r6x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Feb 2021 11:35:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 114BYfUK134930;
        Thu, 4 Feb 2021 11:35:27 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by userp3030.oracle.com with ESMTP id 36dhd187r2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Feb 2021 11:35:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e9eY9eJGdnMS/aoc8Ub8Ul/gB01RioKRKhKjkLQGH6FYIo2Ms1H1zLFQ0RSJnxVK7BGmIF5JK3mNNgTWKIpJcmo7hCJhqbq4G3R2dhFc2AXXaMQc+v5z2jeV2zxPUQrvMs6pyZkiB7Wt6YHriM2ESk6htjH3ZYHqYhK8v+UD2TwyvfFLaVNLcsrAz+76zz/bha8lVa9QgFYxbnksT573l8J0j/LMXE+uaeH0GaeJM+zyshu2NJAVTXQy7200AcijXDXnT8W4i1WTvz/oIyknIb4ZDg9likohvXxluB9fXuu9FFrb9CbzbvVNdkKiAXbW9+MGg/EF74SBncmsxwKdIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H/0FEOl+dZ3K/w0U7uGdBe6WHG5+aAYUJnMUHipTrTo=;
 b=NNeNn5To1mteopXlnRRDS6FHpC2cM6HkXajlT8QAcGE4QvcVah1s3+0LJxTWDaQyRFpjLtds7QCpoeWuStUy1WI+hJ3XT1ZOd5chYdOozzws4IclDfOoIRsGviNAKOJi7XnNVQcxae7V+yuMjEeVqSbWwKBfCL7gnlgl4dUPBb0Y+fk9aI76Mp5kNqUELm3O831OhQ73YYmEZZt6FmvJ7fpeVcHKDVtQqKDlByQy6aI+WNxk//56n8B3yZZqA23wR2rOUf6r76eg3GhrwbVpnAFfwBtBT1dxWUyE1Qvo7IbgC6sYW8C0SoTRDXX/NxKVQ5+SxzsmaB2z3hhEi1bfmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H/0FEOl+dZ3K/w0U7uGdBe6WHG5+aAYUJnMUHipTrTo=;
 b=ujBgtcxo5TlzokD+NnLcZvp+lwseAulHrDOnPLZL4JYQIUt4pskeRHy1DCLFD+EXGEtohYfF5fd+xF7CFnDkydWKVkcn1S15RXI1NCggThELKy0HzkPSJMXIEid8zbr/jW52qD9oiLSDwUMniyr6fFI6ElZKjH+BLYskCaIANlk=
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4480.namprd10.prod.outlook.com (2603:10b6:a03:2d7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Thu, 4 Feb
 2021 11:35:25 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3805.028; Thu, 4 Feb 2021
 11:35:25 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        stefanha@redhat.com, virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 02/11] target: add workqueue cmd submission helper
Date:   Thu,  4 Feb 2021 05:35:04 -0600
Message-Id: <20210204113513.93204-3-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH0PR03CA0084.namprd03.prod.outlook.com (2603:10b6:610:cc::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Thu, 4 Feb 2021 11:35:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87467126-706f-44a0-afa3-08d8c900f70a
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4480:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4480A621BCB9719D85984D66F1B39@SJ0PR10MB4480.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b0LjR80E9e5zjBSkcS4PGOJa44kuJuYISx+mEx0vI9+uVLMZe49+9jYM8smM1c1TjWx7YwusBI9ChetIpT2QN7DDjKGNpV7hmP9Zjgq8V5cu6Tij8pmQcjS9k2cm3eJf9SwATnH/iB0b9ja3EJNQti2TeLIWR7eBgKLdGwjdgZR8RHmrFD6PHroZeWC+WaGcs6IUtGs+Z4OP4ECAEcFAqj+CpMqM/NgsIhswNprWffe1mBUKtX1xQhd01Su/1gieJqWkLExICH1H3NQkrHpfH8/jdDU9364JqwsPa3zE1eHSU8edVZJ9t3On+Lf5/qB65brw1x5jCkXpOZyH+qQF46VRFBO3kql9G5uqosiRLJUNmDA4iRsn6XSDMQziUhxndsWB+kERzpAE/VOmHiDYVFpGG7JfYc7iZqfEiIFWbxwjuGi9EcvnxXYflYu3rkpqgkYfrDTT/huHC7+3d9pidXjwuMdm6yMd2RlFfk8k9Lmkm7paR/ejJxdnpSipT5ObqVnVGAXpcy2Ac3xm97SkqepQk8fAFlOK5HZ0Z1uZqe4M5h3qQHclispvRj/k5SK1khJOVY3sAOYNBoG1Jr5SIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(396003)(366004)(52116002)(66946007)(66476007)(66556008)(26005)(6512007)(478600001)(16526019)(6486002)(8676002)(107886003)(8936002)(4326008)(186003)(2906002)(6506007)(5660300002)(6666004)(2616005)(1076003)(956004)(316002)(36756003)(86362001)(69590400011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Vp7/IzenjpxJ1OqHheJkJzuUnzWX7adld4k2DM68W36HCDvXHUgTrDxW4Lx5?=
 =?us-ascii?Q?Hks9fSWZww8gOze2Q846q+YhLnjb8c2AK4YTfclEaQuIllvp+L5mR811Es2u?=
 =?us-ascii?Q?VnTg/6OZmLwRGuNVgx1+eUdhFP//nIAjM+5ypZP2nq4V56uKujoEBKxwySzN?=
 =?us-ascii?Q?I6cP7ksTpJ84Yz3SgAkKLDkqDt7HwFhrfd5hVnjFdWq38LwRYmNCNkZn1kcb?=
 =?us-ascii?Q?gaQCOt7LMC4UZVArgDbtu9YFwlVaeCY3HWkK46u2kUp66+iL1n20TzkK+Sp2?=
 =?us-ascii?Q?9k9EWxdPAQ+wDbf4I1gizE+3UsWvwsJJ1em+/kuqz1D1CNdB9i66AZ/a5GaM?=
 =?us-ascii?Q?7fXJnFpO4qX7x+C2U/7gOmbUL+JDGrGWNgiUBRWFinbXFiCDAk8jHhkNANJE?=
 =?us-ascii?Q?eZSH4WFgKGbt1yGlnbifzGQRdnXwzD5LRmoFX9xuN04OhuextUS/cud+ZpxU?=
 =?us-ascii?Q?zSSOZ6ZxZ4DSI6KTU7guQVjxmGFQTAmH+IeAN2KRkxigrs1EeDOiWGg4Ekra?=
 =?us-ascii?Q?S/RURGPE0TM1K+8x7OFaUL0b+acpQ5fP6IdgykQ4ezWLRRdImA2+Rjp/rv6P?=
 =?us-ascii?Q?J4KsIHVZnNOixERRQsdv7mtSFVzWC1UARUZBvBzeabFX2eShRRGdYabyDGKt?=
 =?us-ascii?Q?2rFOJfp1+rFjX6Irqwk0PO6nzeKGhkFpUyUubq5QqhiahgY1nBGw64iQpSiz?=
 =?us-ascii?Q?TXTyZoDij4bUtrGjcGxUNZdgoRI0jFwMiSbm56wWvGLD/iPaBC5zG8WQn9o0?=
 =?us-ascii?Q?t9t07FLD5b1K/kkBp0W4aOz6XVf2qM1oEcuDaMg7BlY2/RizY5sHU9qec2rt?=
 =?us-ascii?Q?INsH5rz2reM/y7pR3v+rScG8E1KZEa/vHmD2+4SoTtWwDJcV21/14Q3I2492?=
 =?us-ascii?Q?HTSffNNCFUyiEOsOLiSICYsqOb2Q4q1t4I7oyRnqXK+prc5z8QtZd1z/wmDu?=
 =?us-ascii?Q?KJwKhulrQv++XdyLqhBrkt9V81RApDwiQ3a2BH+kstsPyggUY3Hjzr9YtPmD?=
 =?us-ascii?Q?bzUS9ZHzrZuofr08TrilxtdY0F7oIFftb1xcBw7fYS7NB3yIs29ksHef9kG9?=
 =?us-ascii?Q?x6blKso0UfnkEwi/Mezj+Oeh5CwiLRVW/uXmnG/kvGT+/kSBH785C5/YPr0N?=
 =?us-ascii?Q?6Ky3BR+HBUDEATyFlJL4VqCzF4gIYG/9gseWgPO8KN7fKVCkQiscofDbF/V1?=
 =?us-ascii?Q?Bx5gobgL1m6k+LSiiE2ACAR1MbleP9XapFUwAQI8fnTXNAhvHfN5BsC/tjon?=
 =?us-ascii?Q?ZkrUBQnmxz/GMUkJahhIyU0C5qWGQk06eLUJHDEwkJwXT19ow+RjTcZ9wduS?=
 =?us-ascii?Q?q3F7Vx1KdNNUwwo/gh9fonzo?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87467126-706f-44a0-afa3-08d8c900f70a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 11:35:25.6499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xiox5izSx6i6tNCwLlOE5KbJcSdXayZce03DxoiwlYKSv1V0/hn8Rxyf57e+jtgeIZ7r1cCGETkorGHIR5XwS05B7cL5c6Lz/DAiCl+5iJU=
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

loop and vhost-scsi do their target cmd submission from driver
workqueues. This allows them to avoid an issue where the backend may
block waiting for resources like tags/requests, mem/locks, etc
and that ends up blocking their entire submission path and for the
case of vhost-scsi both the submission and completion path.

This patch adds a helper these drivers can use to submit from the
lio workqueue. This code will then be extended in the next patches
to fix the plugging of backend devices.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_transport.c | 102 ++++++++++++++++++++++++-
 include/target/target_core_base.h      |  10 ++-
 include/target/target_core_fabric.h    |   3 +
 3 files changed, 111 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 7c5d37bac561..dec89e911348 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -41,6 +41,7 @@
 #include <trace/events/target.h>
 
 static struct workqueue_struct *target_completion_wq;
+static struct workqueue_struct *target_submission_wq;
 static struct kmem_cache *se_sess_cache;
 struct kmem_cache *se_ua_cache;
 struct kmem_cache *t10_pr_reg_cache;
@@ -129,8 +130,15 @@ int init_se_kmem_caches(void)
 	if (!target_completion_wq)
 		goto out_free_lba_map_mem_cache;
 
+	target_submission_wq = alloc_workqueue("target_submission",
+					       WQ_MEM_RECLAIM, 0);
+	if (!target_submission_wq)
+		goto out_free_completion_wq;
+
 	return 0;
 
+out_free_completion_wq:
+	destroy_workqueue(target_completion_wq);
 out_free_lba_map_mem_cache:
 	kmem_cache_destroy(t10_alua_lba_map_mem_cache);
 out_free_lba_map_cache:
@@ -153,6 +161,7 @@ int init_se_kmem_caches(void)
 
 void release_se_kmem_caches(void)
 {
+	destroy_workqueue(target_submission_wq);
 	destroy_workqueue(target_completion_wq);
 	kmem_cache_destroy(se_sess_cache);
 	kmem_cache_destroy(se_ua_cache);
@@ -218,6 +227,69 @@ static void target_release_sess_cmd_refcnt(struct percpu_ref *ref)
 	wake_up(&sess->cmd_count_wq);
 }
 
+static void target_queued_submit_work(struct work_struct *work)
+{
+	struct se_sess_cmd_queue *sq =
+				container_of(work, struct se_sess_cmd_queue,
+					     work);
+	struct se_session *se_sess = sq->se_sess;
+	struct se_cmd *se_cmd, *next_cmd;
+	struct llist_node *cmd_list;
+
+	cmd_list = llist_del_all(&sq->cmd_list);
+	if (!cmd_list)
+		/* Previous call took what we were queued to submit */
+		return;
+
+	cmd_list = llist_reverse_order(cmd_list);
+	llist_for_each_entry_safe(se_cmd, next_cmd, cmd_list, se_cmd_list)
+		se_sess->tfo->submit_queued_cmd(se_cmd);
+}
+
+static void target_queue_cmd_work(struct se_sess_cmd_queue *q,
+				  struct se_cmd *se_cmd, int cpu)
+{
+	llist_add(&se_cmd->se_cmd_list, &q->cmd_list);
+	queue_work_on(cpu, target_submission_wq, &q->work);
+}
+
+/**
+ * target_queue_cmd_submit - queue a se_cmd to be executed from the lio wq
+ * @se_sess: cmd's session
+ * @cmd_list: cmd to queue
+ */
+void target_queue_cmd_submit(struct se_session *se_sess, struct se_cmd *se_cmd)
+{
+	int cpu = smp_processor_id();
+
+	target_queue_cmd_work(&se_sess->sq[cpu], se_cmd, cpu);
+}
+EXPORT_SYMBOL_GPL(target_queue_cmd_submit);
+
+static void target_flush_queued_cmds(struct se_session *se_sess)
+{
+	int i;
+
+	if (!se_sess->sq)
+		return;
+
+	for (i = 0; i < se_sess->q_cnt; i++)
+		cancel_work_sync(&se_sess->sq[i].work);
+}
+
+static void target_init_sess_cmd_queues(struct se_session *se_sess,
+					struct se_sess_cmd_queue *q,
+					void (*work_fn)(struct work_struct *work))
+{
+	int i;
+
+	for (i = 0; i < se_sess->q_cnt; i++) {
+		init_llist_head(&q[i].cmd_list);
+		INIT_WORK(&q[i].work, work_fn);
+		q[i].se_sess = se_sess;
+	}
+}
+
 /**
  * transport_init_session - initialize a session object
  * @tfo: target core fabric ops
@@ -228,6 +300,8 @@ static void target_release_sess_cmd_refcnt(struct percpu_ref *ref)
 int transport_init_session(const struct target_core_fabric_ops *tfo,
 			   struct se_session *se_sess)
 {
+	int rc;
+
 	INIT_LIST_HEAD(&se_sess->sess_list);
 	INIT_LIST_HEAD(&se_sess->sess_acl_list);
 	spin_lock_init(&se_sess->sess_cmd_lock);
@@ -235,13 +309,34 @@ int transport_init_session(const struct target_core_fabric_ops *tfo,
 	init_completion(&se_sess->stop_done);
 	atomic_set(&se_sess->stopped, 0);
 	se_sess->tfo = tfo;
-	return percpu_ref_init(&se_sess->cmd_count,
-			       target_release_sess_cmd_refcnt, 0, GFP_KERNEL);
+
+	if (tfo->submit_queued_cmd) {
+		se_sess->sq = kcalloc(nr_cpu_ids, sizeof(*se_sess->sq),
+				      GFP_KERNEL);
+		if (!se_sess->sq)
+			return -ENOMEM;
+
+		se_sess->q_cnt = nr_cpu_ids;
+		target_init_sess_cmd_queues(se_sess, se_sess->sq,
+					    target_queued_submit_work);
+	}
+
+	rc = percpu_ref_init(&se_sess->cmd_count,
+			     target_release_sess_cmd_refcnt, 0, GFP_KERNEL);
+	if (rc)
+		goto free_sq;
+
+	return 0;
+
+free_sq:
+	kfree(se_sess->sq);
+	return rc;
 }
 EXPORT_SYMBOL(transport_init_session);
 
 void transport_uninit_session(struct se_session *se_sess)
 {
+	kfree(se_sess->sq);
 	/*
 	 * Drivers like iscsi and loop do not call target_stop_session
 	 * during session shutdown so we have to drop the ref taken at init
@@ -1385,7 +1480,6 @@ void transport_init_se_cmd(
 {
 	INIT_LIST_HEAD(&cmd->se_delayed_node);
 	INIT_LIST_HEAD(&cmd->se_qf_node);
-	INIT_LIST_HEAD(&cmd->se_cmd_list);
 	INIT_LIST_HEAD(&cmd->state_list);
 	init_completion(&cmd->t_transport_stop_comp);
 	cmd->free_compl = NULL;
@@ -2968,6 +3062,8 @@ void target_wait_for_sess_cmds(struct se_session *se_sess)
 {
 	int ret;
 
+	target_flush_queued_cmds(se_sess);
+
 	WARN_ON_ONCE(!atomic_read(&se_sess->stopped));
 
 	do {
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 50103a22b0e2..97138bff14d1 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -488,7 +488,7 @@ struct se_cmd {
 	/* Only used for internal passthrough and legacy TCM fabric modules */
 	struct se_session	*se_sess;
 	struct se_tmr_req	*se_tmr_req;
-	struct list_head	se_cmd_list;
+	struct llist_node	se_cmd_list;
 	struct completion	*free_compl;
 	struct completion	*abrt_compl;
 	const struct target_core_fabric_ops *se_tfo;
@@ -612,6 +612,12 @@ static inline struct se_node_acl *fabric_stat_to_nacl(struct config_item *item)
 			acl_fabric_stat_group);
 }
 
+struct se_sess_cmd_queue {
+	struct llist_head	cmd_list;
+	struct work_struct	work;
+	struct se_session	*se_sess;
+};
+
 struct se_session {
 	atomic_t		stopped;
 	u64			sess_bin_isid;
@@ -629,6 +635,8 @@ struct se_session {
 	void			*sess_cmd_map;
 	struct sbitmap_queue	sess_tag_pool;
 	const struct target_core_fabric_ops *tfo;
+	struct se_sess_cmd_queue *sq;
+	int			q_cnt;
 };
 
 struct se_device;
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index cdf610838ba5..899948967a65 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -80,6 +80,7 @@ struct target_core_fabric_ops {
 	int (*queue_status)(struct se_cmd *);
 	void (*queue_tm_rsp)(struct se_cmd *);
 	void (*aborted_task)(struct se_cmd *);
+	void (*submit_queued_cmd)(struct se_cmd *);
 	/*
 	 * fabric module calls for target_core_fabric_configfs.c
 	 */
@@ -166,6 +167,8 @@ int	target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 		unsigned char *sense, u64 unpacked_lun,
 		void *fabric_tmr_ptr, unsigned char tm_type,
 		gfp_t, u64, int);
+void	target_queue_cmd_submit(struct se_session *se_sess,
+				struct se_cmd *se_cmd);
 int	transport_handle_cdb_direct(struct se_cmd *);
 sense_reason_t	transport_generic_new_cmd(struct se_cmd *);
 
-- 
2.25.1

