Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A0E4C433DB
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 03:36:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F4EA64F4A
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 03:36:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbhBCDgr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 22:36:47 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:50680 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232255AbhBCDgj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2021 22:36:39 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1131XmLH176178;
        Wed, 3 Feb 2021 01:34:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=TKjQ+aARi6rBzeY9nnphB4Enz09RyKVx156qK85cSSw=;
 b=cRCQ3p6PPUpCUBH9PUAoWD4LW6Za6/bW/MOTDQAL0DsIHLGD46gFIjNMrE03jgOu0w/q
 WobAa6EbyKJomSkFutEM0/E+XRYQYbZ1osp7uVLWYan/GBSq8LzzT+5EFZZLVWEnmCHj
 9+zJV/NMC9qM3LR1zoG1gLikep7qvuPf/Grz+XAHpvsXBizxttz5VvIuE4j/H521HgfK
 bMx/4qujs1/NxBmQdOd9tUKD0ptzNend5PRMXNWOzVrI8ZcT3l/rmXsxBtzsJbTztYPx
 DCDOKRLmLhjT2g+KCFY9qPKk90e2LnmcU5Ue9uR7IkK1YDcFgQoemPKGckCIyrj+TIx6 /g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 36dn4wkgg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 01:34:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1131OxjJ139717;
        Wed, 3 Feb 2021 01:34:09 GMT
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2058.outbound.protection.outlook.com [104.47.44.58])
        by aserp3020.oracle.com with ESMTP id 36dhc05qfv-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 01:34:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=duQ5m496wBz4wldsoQmlNVfgN7SqNxgXAm1sRYPPRjEV44qOF4Ltg558tu1tVctph8YnInO2jZReaLAQtqRAx800jdYdB1alkrR92Ee6RlXRKhuIGcoPoIefbrqIP8bU36A1kxbn66IL7kp1ISISDJJOV+GUWdebbOwgSMUnwxdm+fE0hreiHwwGyW6ya7DnGRr2GuiqQpxsGnen/a9tX3kjEspyy5iu2e38+7+OcW9dNBmGvS6Pg6JzYusK9KAsxxkIUEj69FATFC5OoWkz76F5JaUKflMbW8MmkNbdA4TWM6AQpTbPHU6jNE88PDnzlQdOmX6MMyg4XxoTnfnpog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TKjQ+aARi6rBzeY9nnphB4Enz09RyKVx156qK85cSSw=;
 b=kPFYf8gh3hU+wscO9tUqp3LXmBcOhZceSxdnjfA/1ETVXYxv+6z+jsFTFK4AZV94rB2WPf8lj1rB6r1Az9Tp65DPMixgo4j6DxV26Lxke97MtQPcSEerpSU9fV2lmMplkaI0hmmkpki/F2QtttR8Z2avO5kxVP6BGdMPAbukCy827UpvDrZDDIUpvSuDaWeVNMVpyslvO5Hr7Y3sJ6vhQLkasybTF9meyAEPWEI5TDdLE2lG5T1FFbJFWfjUFdiHv2jE4q4pIlzIdb2PlfwitnFbXOTGHJ8BU9kTm30JStmc/W5cCL5K2qgRUYek8V7o1F5TAfJiVhiSS8mJIpQb+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TKjQ+aARi6rBzeY9nnphB4Enz09RyKVx156qK85cSSw=;
 b=L+WdROeZuSnZlIRuZ1fH/Tog8HBBc7jM9gL2QhthMVBqcDKDkGkkwMAaTsxewre/89cwUM42tZEc3QZCOyuwSKdWEJfMoksXysxqY1IiRY7b0wg8wvg/Ax6LaecC3nAJKJbSCX6orKLvHYH1Tg1u+hCql0te5CpO7ern3Owb2U8=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BN6PR10MB1236.namprd10.prod.outlook.com (2603:10b6:405:11::21)
 by BN0PR10MB5320.namprd10.prod.outlook.com (2603:10b6:408:12a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20; Wed, 3 Feb
 2021 01:34:07 +0000
Received: from BN6PR10MB1236.namprd10.prod.outlook.com
 ([fe80::f5ff:ea98:43fe:3d86]) by BN6PR10MB1236.namprd10.prod.outlook.com
 ([fe80::f5ff:ea98:43fe:3d86%4]) with mapi id 15.20.3805.028; Wed, 3 Feb 2021
 01:34:07 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 2/9] libiscsi: drop taskqueuelock
Date:   Tue,  2 Feb 2021 19:33:49 -0600
Message-Id: <20210203013356.11177-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203013356.11177-1-michael.christie@oracle.com>
References: <20210203013356.11177-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR02CA0012.namprd02.prod.outlook.com
 (2603:10b6:610:4e::22) To BN6PR10MB1236.namprd10.prod.outlook.com
 (2603:10b6:405:11::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR02CA0012.namprd02.prod.outlook.com (2603:10b6:610:4e::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Wed, 3 Feb 2021 01:34:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4cdfa114-0230-4601-cb90-08d8c7e3cc53
X-MS-TrafficTypeDiagnostic: BN0PR10MB5320:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB532027F4D309BC0E4305F1A4F1B49@BN0PR10MB5320.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: emZW+6lY7zhJyBjnCUu9n/4A9ZqDjBy2lSoN+RJL0JcgbFNCkL8pPPZNgD38lkdGxInEWDS2IyMIeS9hg1Tqm5PlCsK6qS2EpKGWfh+DRWMex1QgisF5Ig29tSmnOhjd+bBpHdU9aXfqS1VT7d+OfwMYvSBVvSxBR0EKN/Drwenab5sM1g/nnjjCO68DKe2oyzSclFyOcS63iMqRBcfZNO6lptRvmlvDjLPzgrwFTNnxBf9ztS2MvNlvOMYL/puQWfI+JKA5jaNOXSnSVemC9zYmoa68jBBXS9avacThjSZbnMBI5RlSAmiixPm7LFogi9FBaYc9CHKoxnmB+4+F2FBXWcyEoHEHiUZ7htSIY6i6lg4JguloFti4jN+Fo4wgG8hoo9wfsnTO9dV5yxx+zR4ViiLqY+c/xpG86is934cQhpudsBi9xWNG2ShVWuMk+1njE+K9PuwVDnNcu2iP5JEfQValglicI/CaKDmJNoFa8rXI2oJOzLxBpt3LT1Jy58b+rKpbf0NKSac5AyKLkDr/3s4+Vtm4/ED97SjpWW53igDpwOICQrTBBQPEzCOKD1tc1yUS5292E0SCu/CQpg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR10MB1236.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(136003)(376002)(346002)(52116002)(316002)(6666004)(69590400007)(956004)(2616005)(2906002)(478600001)(86362001)(107886003)(4326008)(66476007)(66556008)(66946007)(36756003)(6486002)(6506007)(16526019)(186003)(26005)(8936002)(6512007)(8676002)(1076003)(30864003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ttA7rwTz5boKKYNhI10oJGdauJmEPa0y2DLjcLCkfZQb8jCIXL7zICR+ctPo?=
 =?us-ascii?Q?q19vv+LligubZH6a7DETeVKEfgiFCkRCjIC+p4Q8CISzswBxZeSlLlz7K+wr?=
 =?us-ascii?Q?nD+wGv0DJorxgc3mxaLlmTbjJR6lNyTwirLeW9lMe/042Hrm7nybmm6HjLp0?=
 =?us-ascii?Q?UXoMIdy/AdPeVhgGDQ7f4n32/DoNXzDP1IdT7s7sq7QUutbwe+SNWeDebG17?=
 =?us-ascii?Q?6YKSjaL3Z7LmUGIXm0T2lrhTGndm9icCzdSkQQN6YhycWchR+iizcNjvePVn?=
 =?us-ascii?Q?vNGb2/BBcAe+tYPUXjfuQUlOAQ17JJfEN8zA3o4a9as1+EFbiYrbpd0k9Khk?=
 =?us-ascii?Q?8s7W8odVviBmw3WXNmvyGDcBpivCiuzigVJjfzGJ0JrVokAxveptgiqj/zk4?=
 =?us-ascii?Q?j0Px7XwfezGg8aPMKPCtWkH82kgv0japNOMOev3uyB+wkg110LPJ46HYb9gm?=
 =?us-ascii?Q?X5wJ+qzioWj3aYDnJb5GcJyAEFMkiA9xTbtvTUmTwBcPm2Y8z+/DprvmS1k1?=
 =?us-ascii?Q?KwHbr8svR94UXR5EGCSCEUD3xM+UcQ2Ber+cEUuXdm2cRhG97y6FQPtuzW1E?=
 =?us-ascii?Q?S3UlPcp5y12UKRdzdLgkBuqvYRJUaQMCudh+qnApIID8aaLbO/QDNocVs9XG?=
 =?us-ascii?Q?28A4PEhgeJIxLKsj+tyLure8VXuKA/zzxsI2KFGYJlxV36y4pyudTu4peAsZ?=
 =?us-ascii?Q?3+8PI3u65f4ECPgbet/5f+hz42cqU7uf9W/lC43X0J1BRWUI8B3d+PEDcf9b?=
 =?us-ascii?Q?K6NCYnPU6giuhQlzv4ytQh0UQXFCaHQPkyOQAh+0/7UZgLwaHTNm7tURZbWy?=
 =?us-ascii?Q?GXJMU72h1tLo47ekJDYCtzOzq33wnxaasmikKKt/qtLjwHsmQsi8/NwkqjP5?=
 =?us-ascii?Q?X6Ew6Jz3s7FtfpVbSi8Xsp9tFgmsnzWqyJDelZV42jritVc2MXrvSXBDcdWT?=
 =?us-ascii?Q?DBZB6dDLG84epXW9DSrb6ZErvGHkUCzToIN1eYmiLC9bWPIOyQOj7qNWQDBJ?=
 =?us-ascii?Q?ONrkBsA1SsGSPJkXobWRmm/f/RB3vZxaEBJ/Taji6UfQ4qH37O0NRLewoZe+?=
 =?us-ascii?Q?xfeSFXjP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cdfa114-0230-4601-cb90-08d8c7e3cc53
X-MS-Exchange-CrossTenant-AuthSource: BN6PR10MB1236.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2021 01:34:07.4001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gDUYn/BoyjGolJgPzhNfRirUwbbwsCiBrGIAK6R0eJWKvVI+GGZQrCI6ZbtObFohWhUq53q73ylgNI/KOsBTizqIA02/7JdcgWPE+cwmO3Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5320
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 spamscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102030004
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 phishscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102030005
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The purpose of the taskqueuelock was to handle the issue where a bad
target decides to send a R2T and before it's data has been sent
decides to send a cmd response to complete the cmd. The following
patches fix up the frwd/back locks so they are taken from the
queue/xmit (frwd) and completion (back) paths again. To get there
this patch removes the taskqueuelock which for iscsi xmit wq based
drivers was taken in the queue, xmit and completion paths.

Instead of the lock, we just make sure we have a ref to the task
when we queue a R2T, and then we always remove the task from the
requeue list in the xmit path or the forced cleanup paths.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/libiscsi.c     | 178 +++++++++++++++++++++++-------------
 drivers/scsi/libiscsi_tcp.c |  84 +++++++++++------
 include/scsi/libiscsi.h     |   4 +-
 3 files changed, 171 insertions(+), 95 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index cee1dbaa1b93..3d74fdd9f31a 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -523,16 +523,6 @@ static void iscsi_complete_task(struct iscsi_task *task, int state)
 	WARN_ON_ONCE(task->state == ISCSI_TASK_FREE);
 	task->state = state;
 
-	spin_lock_bh(&conn->taskqueuelock);
-	if (!list_empty(&task->running)) {
-		pr_debug_once("%s while task on list", __func__);
-		list_del_init(&task->running);
-	}
-	spin_unlock_bh(&conn->taskqueuelock);
-
-	if (conn->task == task)
-		conn->task = NULL;
-
 	if (READ_ONCE(conn->ping_task) == task)
 		WRITE_ONCE(conn->ping_task, NULL);
 
@@ -564,9 +554,40 @@ void iscsi_complete_scsi_task(struct iscsi_task *task,
 }
 EXPORT_SYMBOL_GPL(iscsi_complete_scsi_task);
 
+/*
+ * Must be called with back and frwd lock
+ */
+static bool cleanup_queued_task(struct iscsi_task *task)
+{
+	struct iscsi_conn *conn = task->conn;
+	bool early_complete = false;
+
+	/* Bad target might have completed task while it was still running */
+	if (task->state == ISCSI_TASK_COMPLETED)
+		early_complete = true;
+
+	if (!list_empty(&task->running)) {
+		list_del_init(&task->running);
+		/*
+		 * If it's on a list but still running, this could be from
+		 * a bad target sending a rsp early, cleanup from a TMF, or
+		 * session recovery.
+		 */
+		if (task->state == ISCSI_TASK_RUNNING ||
+		    task->state == ISCSI_TASK_COMPLETED)
+			__iscsi_put_task(task);
+	}
+
+	if (conn->task == task) {
+		conn->task = NULL;
+		__iscsi_put_task(task);
+	}
+
+	return early_complete;
+}
 
 /*
- * session back_lock must be held and if not called for a task that is
+ * session frwd_lock must be held and if not called for a task that is
  * still pending or from the xmit thread, then xmit thread must
  * be suspended.
  */
@@ -585,6 +606,13 @@ static void fail_scsi_task(struct iscsi_task *task, int err)
 	if (!sc)
 		return;
 
+	/* regular RX path uses back_lock */
+	spin_lock_bh(&conn->session->back_lock);
+	if (cleanup_queued_task(task)) {
+		spin_unlock_bh(&conn->session->back_lock);
+		return;
+	}
+
 	if (task->state == ISCSI_TASK_PENDING) {
 		/*
 		 * cmd never made it to the xmit thread, so we should not count
@@ -600,9 +628,6 @@ static void fail_scsi_task(struct iscsi_task *task, int err)
 
 	sc->result = err << 16;
 	scsi_set_resid(sc, scsi_bufflen(sc));
-
-	/* regular RX path uses back_lock */
-	spin_lock_bh(&conn->session->back_lock);
 	iscsi_complete_task(task, state);
 	spin_unlock_bh(&conn->session->back_lock);
 }
@@ -748,9 +773,7 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		if (session->tt->xmit_task(task))
 			goto free_task;
 	} else {
-		spin_lock_bh(&conn->taskqueuelock);
 		list_add_tail(&task->running, &conn->mgmtqueue);
-		spin_unlock_bh(&conn->taskqueuelock);
 		iscsi_conn_queue_work(conn);
 	}
 
@@ -1411,31 +1434,61 @@ static int iscsi_check_cmdsn_window_closed(struct iscsi_conn *conn)
 	return 0;
 }
 
-static int iscsi_xmit_task(struct iscsi_conn *conn)
+static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
+			   bool was_requeue)
 {
-	struct iscsi_task *task = conn->task;
 	int rc;
 
-	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx))
-		return -ENODATA;
-
 	spin_lock_bh(&conn->session->back_lock);
-	if (conn->task == NULL) {
+
+	if (!conn->task) {
+		/* Take a ref so we can access it after xmit_task() */
+		__iscsi_get_task(task);
+	} else {
+		/* Already have a ref from when we failed to send it last call */
+		conn->task = NULL;
+	}
+
+	/*
+	 * If this was a requeue for a R2T we have an extra ref on the task in
+	 * case a bad target sends a cmd rsp before we have handled the task.
+	 */
+	if (was_requeue)
+		__iscsi_put_task(task);
+
+	/*
+	 * Do this after dropping the extra ref because if this was a requeue
+	 * it's removed from that list and cleanup_queued_task would miss it.
+	 */
+	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
+		/*
+		 * Save the task and ref in case we weren't cleaning up this
+		 * task and get woken up again.
+		 */
+		conn->task = task;
 		spin_unlock_bh(&conn->session->back_lock);
 		return -ENODATA;
 	}
-	__iscsi_get_task(task);
 	spin_unlock_bh(&conn->session->back_lock);
+
 	spin_unlock_bh(&conn->session->frwd_lock);
 	rc = conn->session->tt->xmit_task(task);
 	spin_lock_bh(&conn->session->frwd_lock);
 	if (!rc) {
 		/* done with this task */
 		task->last_xfer = jiffies;
-		conn->task = NULL;
 	}
 	/* regular RX path uses back_lock */
 	spin_lock(&conn->session->back_lock);
+	if (rc && task->state == ISCSI_TASK_RUNNING) {
+		/*
+		 * get an extra ref that is released next time we access it
+		 * as conn->task above.
+		 */
+		__iscsi_get_task(task);
+		conn->task = task;
+	}
+
 	__iscsi_put_task(task);
 	spin_unlock(&conn->session->back_lock);
 	return rc;
@@ -1445,9 +1498,7 @@ static int iscsi_xmit_task(struct iscsi_conn *conn)
  * iscsi_requeue_task - requeue task to run from session workqueue
  * @task: task to requeue
  *
- * LLDs that need to run a task from the session workqueue should call
- * this. The session frwd_lock must be held. This should only be called
- * by software drivers.
+ * Callers must have taken a ref to the task that is going to be requeued.
  */
 void iscsi_requeue_task(struct iscsi_task *task)
 {
@@ -1457,11 +1508,18 @@ void iscsi_requeue_task(struct iscsi_task *task)
 	 * this may be on the requeue list already if the xmit_task callout
 	 * is handling the r2ts while we are adding new ones
 	 */
-	spin_lock_bh(&conn->taskqueuelock);
-	if (list_empty(&task->running))
+	spin_lock_bh(&conn->session->frwd_lock);
+	if (list_empty(&task->running)) {
 		list_add_tail(&task->running, &conn->requeue);
-	spin_unlock_bh(&conn->taskqueuelock);
+	} else {
+		/*
+		 * Don't need the extra ref since it's already requeued and
+		 * has a ref.
+		 */
+		iscsi_put_task(task);
+	}
 	iscsi_conn_queue_work(conn);
+	spin_unlock_bh(&conn->session->frwd_lock);
 }
 EXPORT_SYMBOL_GPL(iscsi_requeue_task);
 
@@ -1487,7 +1545,7 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 	}
 
 	if (conn->task) {
-		rc = iscsi_xmit_task(conn);
+		rc = iscsi_xmit_task(conn, conn->task, false);
 	        if (rc)
 		        goto done;
 	}
@@ -1497,49 +1555,41 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 	 * only have one nop-out as a ping from us and targets should not
 	 * overflow us with nop-ins
 	 */
-	spin_lock_bh(&conn->taskqueuelock);
 check_mgmt:
 	while (!list_empty(&conn->mgmtqueue)) {
-		conn->task = list_entry(conn->mgmtqueue.next,
-					 struct iscsi_task, running);
-		list_del_init(&conn->task->running);
-		spin_unlock_bh(&conn->taskqueuelock);
-		if (iscsi_prep_mgmt_task(conn, conn->task)) {
+		task = list_entry(conn->mgmtqueue.next, struct iscsi_task,
+				  running);
+		list_del_init(&task->running);
+		if (iscsi_prep_mgmt_task(conn, task)) {
 			/* regular RX path uses back_lock */
 			spin_lock_bh(&conn->session->back_lock);
-			__iscsi_put_task(conn->task);
+			__iscsi_put_task(task);
 			spin_unlock_bh(&conn->session->back_lock);
-			conn->task = NULL;
-			spin_lock_bh(&conn->taskqueuelock);
 			continue;
 		}
-		rc = iscsi_xmit_task(conn);
+		rc = iscsi_xmit_task(conn, task, false);
 		if (rc)
 			goto done;
-		spin_lock_bh(&conn->taskqueuelock);
 	}
 
 	/* process pending command queue */
 	while (!list_empty(&conn->cmdqueue)) {
-		conn->task = list_entry(conn->cmdqueue.next, struct iscsi_task,
-					running);
-		list_del_init(&conn->task->running);
-		spin_unlock_bh(&conn->taskqueuelock);
+		task = list_entry(conn->cmdqueue.next, struct iscsi_task,
+				  running);
+		list_del_init(&task->running);
 		if (conn->session->state == ISCSI_STATE_LOGGING_OUT) {
-			fail_scsi_task(conn->task, DID_IMM_RETRY);
-			spin_lock_bh(&conn->taskqueuelock);
+			fail_scsi_task(task, DID_IMM_RETRY);
 			continue;
 		}
-		rc = iscsi_prep_scsi_cmd_pdu(conn->task);
+		rc = iscsi_prep_scsi_cmd_pdu(task);
 		if (rc) {
 			if (rc == -ENOMEM || rc == -EACCES)
-				fail_scsi_task(conn->task, DID_IMM_RETRY);
+				fail_scsi_task(task, DID_IMM_RETRY);
 			else
-				fail_scsi_task(conn->task, DID_ABORT);
-			spin_lock_bh(&conn->taskqueuelock);
+				fail_scsi_task(task, DID_ABORT);
 			continue;
 		}
-		rc = iscsi_xmit_task(conn);
+		rc = iscsi_xmit_task(conn, task, false);
 		if (rc)
 			goto done;
 		/*
@@ -1547,7 +1597,6 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 		 * we need to check the mgmt queue for nops that need to
 		 * be sent to aviod starvation
 		 */
-		spin_lock_bh(&conn->taskqueuelock);
 		if (!list_empty(&conn->mgmtqueue))
 			goto check_mgmt;
 	}
@@ -1561,21 +1610,17 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 
 		task = list_entry(conn->requeue.next, struct iscsi_task,
 				  running);
+
 		if (iscsi_check_tmf_restrictions(task, ISCSI_OP_SCSI_DATA_OUT))
 			break;
 
-		conn->task = task;
-		list_del_init(&conn->task->running);
-		conn->task->state = ISCSI_TASK_RUNNING;
-		spin_unlock_bh(&conn->taskqueuelock);
-		rc = iscsi_xmit_task(conn);
+		list_del_init(&task->running);
+		rc = iscsi_xmit_task(conn, task, true);
 		if (rc)
 			goto done;
-		spin_lock_bh(&conn->taskqueuelock);
 		if (!list_empty(&conn->mgmtqueue))
 			goto check_mgmt;
 	}
-	spin_unlock_bh(&conn->taskqueuelock);
 	spin_unlock_bh(&conn->session->frwd_lock);
 	return -ENODATA;
 
@@ -1741,9 +1786,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 			goto prepd_reject;
 		}
 	} else {
-		spin_lock_bh(&conn->taskqueuelock);
 		list_add_tail(&task->running, &conn->cmdqueue);
-		spin_unlock_bh(&conn->taskqueuelock);
 		iscsi_conn_queue_work(conn);
 	}
 
@@ -2914,7 +2957,6 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
 	INIT_LIST_HEAD(&conn->mgmtqueue);
 	INIT_LIST_HEAD(&conn->cmdqueue);
 	INIT_LIST_HEAD(&conn->requeue);
-	spin_lock_init(&conn->taskqueuelock);
 	INIT_WORK(&conn->xmitwork, iscsi_xmitworker);
 
 	/* allocate login_task used for the login/text sequences */
@@ -3080,10 +3122,16 @@ fail_mgmt_tasks(struct iscsi_session *session, struct iscsi_conn *conn)
 		ISCSI_DBG_SESSION(conn->session,
 				  "failing mgmt itt 0x%x state %d\n",
 				  task->itt, task->state);
+
+		spin_lock_bh(&session->back_lock);
+		if (cleanup_queued_task(task)) {
+			spin_unlock_bh(&session->back_lock);
+			continue;
+		}
+
 		state = ISCSI_TASK_ABRT_SESS_RECOV;
 		if (task->state == ISCSI_TASK_PENDING)
 			state = ISCSI_TASK_COMPLETED;
-		spin_lock_bh(&session->back_lock);
 		iscsi_complete_task(task, state);
 		spin_unlock_bh(&session->back_lock);
 	}
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 83f14b2c8804..14c9169f13ec 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -524,48 +524,79 @@ static int iscsi_tcp_data_in(struct iscsi_conn *conn, struct iscsi_task *task)
 /**
  * iscsi_tcp_r2t_rsp - iSCSI R2T Response processing
  * @conn: iscsi connection
- * @task: scsi command task
+ * @hdr: PDU header
  */
-static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
+static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 {
 	struct iscsi_session *session = conn->session;
-	struct iscsi_tcp_task *tcp_task = task->dd_data;
-	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-	struct iscsi_r2t_rsp *rhdr = (struct iscsi_r2t_rsp *)tcp_conn->in.hdr;
+	struct iscsi_tcp_task *tcp_task;
+	struct iscsi_tcp_conn *tcp_conn;
+	struct iscsi_r2t_rsp *rhdr;
 	struct iscsi_r2t_info *r2t;
-	int r2tsn = be32_to_cpu(rhdr->r2tsn);
+	struct iscsi_task *task;
 	u32 data_length;
 	u32 data_offset;
+	int r2tsn;
 	int rc;
 
+	spin_lock(&session->back_lock);
+	task = iscsi_itt_to_ctask(conn, hdr->itt);
+	if (!task) {
+		spin_unlock(&session->back_lock);
+		return ISCSI_ERR_BAD_ITT;
+	} else if (task->sc->sc_data_direction != DMA_TO_DEVICE) {
+		spin_unlock(&session->back_lock);
+		return ISCSI_ERR_PROTO;
+	}
+	/*
+	 * A bad target might complete the cmd before we have handled R2Ts
+	 * so get a ref to the task that will be dropped in the xmit path.
+	 */
+	if (task->state != ISCSI_TASK_RUNNING) {
+		spin_unlock(&session->back_lock);
+		/* Let the path that got the early rsp complete it */
+		return 0;
+	}
+	task->last_xfer = jiffies;
+	__iscsi_get_task(task);
+
+	tcp_conn = conn->dd_data;
+	rhdr = (struct iscsi_r2t_rsp *)tcp_conn->in.hdr;
+	/* fill-in new R2T associated with the task */
+	iscsi_update_cmdsn(session, (struct iscsi_nopin *)rhdr);
+	spin_unlock(&session->back_lock);
+
 	if (tcp_conn->in.datalen) {
 		iscsi_conn_printk(KERN_ERR, conn,
 				  "invalid R2t with datalen %d\n",
 				  tcp_conn->in.datalen);
-		return ISCSI_ERR_DATALEN;
+		rc = ISCSI_ERR_DATALEN;
+		goto put_task;
 	}
 
+	tcp_task = task->dd_data;
+	r2tsn = be32_to_cpu(rhdr->r2tsn);
 	if (tcp_task->exp_datasn != r2tsn){
 		ISCSI_DBG_TCP(conn, "task->exp_datasn(%d) != rhdr->r2tsn(%d)\n",
 			      tcp_task->exp_datasn, r2tsn);
-		return ISCSI_ERR_R2TSN;
+		rc = ISCSI_ERR_R2TSN;
+		goto put_task;
 	}
 
-	/* fill-in new R2T associated with the task */
-	iscsi_update_cmdsn(session, (struct iscsi_nopin*)rhdr);
-
 	if (!task->sc || session->state != ISCSI_STATE_LOGGED_IN) {
 		iscsi_conn_printk(KERN_INFO, conn,
 				  "dropping R2T itt %d in recovery.\n",
 				  task->itt);
-		return 0;
+		rc = 0;
+		goto put_task;
 	}
 
 	data_length = be32_to_cpu(rhdr->data_length);
 	if (data_length == 0) {
 		iscsi_conn_printk(KERN_ERR, conn,
 				  "invalid R2T with zero data len\n");
-		return ISCSI_ERR_DATALEN;
+		rc = ISCSI_ERR_DATALEN;
+		goto put_task;
 	}
 
 	if (data_length > session->max_burst)
@@ -579,7 +610,8 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
 				  "invalid R2T with data len %u at offset %u "
 				  "and total length %d\n", data_length,
 				  data_offset, task->sc->sdb.length);
-		return ISCSI_ERR_DATALEN;
+		rc = ISCSI_ERR_DATALEN;
+		goto put_task;
 	}
 
 	spin_lock(&tcp_task->pool2queue);
@@ -589,7 +621,8 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
 				  "Target has sent more R2Ts than it "
 				  "negotiated for or driver has leaked.\n");
 		spin_unlock(&tcp_task->pool2queue);
-		return ISCSI_ERR_PROTO;
+		rc = ISCSI_ERR_PROTO;
+		goto put_task;
 	}
 
 	r2t->exp_statsn = rhdr->statsn;
@@ -607,6 +640,10 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
 
 	iscsi_requeue_task(task);
 	return 0;
+
+put_task:
+	iscsi_put_task(task);
+	return rc;
 }
 
 /*
@@ -730,20 +767,11 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 		rc = iscsi_complete_pdu(conn, hdr, NULL, 0);
 		break;
 	case ISCSI_OP_R2T:
-		spin_lock(&conn->session->back_lock);
-		task = iscsi_itt_to_ctask(conn, hdr->itt);
-		spin_unlock(&conn->session->back_lock);
-		if (!task)
-			rc = ISCSI_ERR_BAD_ITT;
-		else if (ahslen)
+		if (ahslen) {
 			rc = ISCSI_ERR_AHSLEN;
-		else if (task->sc->sc_data_direction == DMA_TO_DEVICE) {
-			task->last_xfer = jiffies;
-			spin_lock(&conn->session->frwd_lock);
-			rc = iscsi_tcp_r2t_rsp(conn, task);
-			spin_unlock(&conn->session->frwd_lock);
-		} else
-			rc = ISCSI_ERR_PROTO;
+			break;
+		}
+		rc = iscsi_tcp_r2t_rsp(conn, hdr);
 		break;
 	case ISCSI_OP_LOGIN_RSP:
 	case ISCSI_OP_TEXT_RSP:
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index b3bbd10eb3f0..44a9554aea62 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -187,7 +187,7 @@ struct iscsi_conn {
 	struct iscsi_task	*task;		/* xmit task in progress */
 
 	/* xmit */
-	spinlock_t		taskqueuelock;  /* protects the next three lists */
+	/* items must be added/deleted under frwd lock */
 	struct list_head	mgmtqueue;	/* mgmt (control) xmit queue */
 	struct list_head	cmdqueue;	/* data-path cmd queue */
 	struct list_head	requeue;	/* tasks needing another run */
@@ -332,7 +332,7 @@ struct iscsi_session {
 						 * cmdsn, queued_cmdsn     *
 						 * session resources:      *
 						 * - cmdpool kfifo_out ,   *
-						 * - mgmtpool,		   */
+						 * - mgmtpool, queues	   */
 	spinlock_t		back_lock;	/* protects cmdsn_exp      *
 						 * cmdsn_max,              *
 						 * cmdpool kfifo_in        */
-- 
2.25.1

