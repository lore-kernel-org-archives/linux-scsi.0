Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F752C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:32:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3882964E65
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:32:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbhBLHcI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Feb 2021 02:32:08 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:59912 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbhBLHaD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2021 02:30:03 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7Ounu170946;
        Fri, 12 Feb 2021 07:27:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=x3Ewt12IExJayKPDZZ4tEdHTL6r2juFdsMgtEah1atQ=;
 b=vnw9SItCIHtwI036uYrcRz8wI/KaFrtInltKR3WXPYWHiNr9Pr7upeGJp9LLOO9BrBOb
 R9X3bhqaxwp5kU1xUGHrrUaN1UcuhZm8p4pjiPDElu34eG66uKF79XtsiIVUf0HvJQP7
 SyejLc1d7+RLTRvxvZX78/VqyhqUIP1kXlKqjnFpAgRmkcDdYEe7G5iFn3n6ja04A29W
 w5cwu7oeOZw0fUHhaCNQefIQcMv/R6jbB1Ofp1Ks8VR2P2+M8dl7rEvNWQOg4DAT9wSL
 fms3kmTQQAa4jcTKq3dnaTawGh4C6olz77cUnSxk3zVLp+KqcnJJB3f8cADUvtHGxFoj zQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 36hkrna559-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7Q9BU090048;
        Fri, 12 Feb 2021 07:27:11 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2173.outbound.protection.outlook.com [104.47.73.173])
        by aserp3030.oracle.com with ESMTP id 36j4psn5st-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=naEbuHQtUc/SO049MqnLm39RtjsgLB/9NhHvwrtnIVh9Xj4GFQzM7TULEzI1oRSKeI2pt7QWuEXHSC0ux8/nIGtvGv3gyAQYPr19eS6p+RU8K+mu+x6KfiEF38PFO90jf5Mdzl1NF/oVD231pquc7HrKDErOwAMQEbrQG2Wy0eM3T4zbDzD59pISRG8HJFJwAythpRXqK61/mx17ZgH9B22AV2OK+Aomb1e1TVAMjhKJ5adNbgz9vtRW95WfrEFzm9zMhweDrWSgtBtjdGrHSl+kD3z2twKwCNOU66SZP4mqeeN62YXfEVUkd66REn8ax962KwBSBW6BPTsjm8mfkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x3Ewt12IExJayKPDZZ4tEdHTL6r2juFdsMgtEah1atQ=;
 b=BjtqrjjHx7Il7ADZLKUAMm6/8iY0WC5GhwoSkN54h62WO7vWkCfPkHlp2tP/yttLyUGAPS5BFIIWytWx1WiS2PZYJK6Sxcr3chzXJtVBsp3+c7NyQM5sQAfD9xbvdqKTQz0YPZCrn84Y2um9G3ni+mduVY1/DzW7E3s6tckuxn1OlKLkr/Hl+VTDEsUd4lAFgIqlL4Dynhh8I9Z4p26tAptLSDuu13xLeyRGJSmSaXfCzDg6pELeqP4aGv/CiSpPi9vU9rfVXIcKNbJS0wB2EyyV85FEmpTUOtB64oYdi+eqC7J6w3Zf51gJ/nvxHXMPUkZ7TBiIoc/pYRunWCnIbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x3Ewt12IExJayKPDZZ4tEdHTL6r2juFdsMgtEah1atQ=;
 b=SmT9zYcmJ6/FqviiBL6lHyYTsKPrQbt5uaJH7PtszV98wW2OlPjFtnBpYtgMua2y/4ILxiasjHd0aLCf/cOCdsIRWCCyP9KkBvlI1oXVeKSSBx4PKiJFfIFOEzKmXAHnNLlFY5huToxA9V8kV8UJBCbcruX+RBqmUIpzJ0wypLs=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from BN8PR10MB3570.namprd10.prod.outlook.com (2603:10b6:408:ae::12)
 by BN0PR10MB5254.namprd10.prod.outlook.com (2603:10b6:408:12f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Fri, 12 Feb
 2021 07:27:09 +0000
Received: from BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495]) by BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495%4]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 07:27:09 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mst@redhat.com, stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com,
        hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 16/25] target: add workqueue based cmd submission
Date:   Fri, 12 Feb 2021 01:26:33 -0600
Message-Id: <20210212072642.17520-17-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210212072642.17520-1-michael.christie@oracle.com>
References: <20210212072642.17520-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR14CA0050.namprd14.prod.outlook.com
 (2603:10b6:610:56::30) To BN8PR10MB3570.namprd10.prod.outlook.com
 (2603:10b6:408:ae::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR14CA0050.namprd14.prod.outlook.com (2603:10b6:610:56::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 07:27:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e362ae6-faf6-4ad4-f216-08d8cf279b51
X-MS-TrafficTypeDiagnostic: BN0PR10MB5254:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB5254983FFEBF76335EE9918AF18B9@BN0PR10MB5254.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O03mQklX0nXZcKCv8It5FmBRnb4qmTJEPPCKvrJ9ZxWcA/omh+CgzT9CeqKNMQjZbrMq6M3u8t3mIJjcxGiA8YHDZbjnnr8+8mERkFazIro4J1Kpfnm07WrbapEVz9VWdmNp44kWnT1yLYf0zWmJNgXM6cPk3eo41WpW90svBL1L6lQBdoNGYx1yNaXjIioEBstfLHrw2QqzxT3bERv+BuRWvg4RXelcTVv8q7xSx1RN0gxqMCzcA4kS+0GQ8SIc61tiRRvAN/sdON8Kj2jj8N1UA7DdE1u5JdKTwkuxfc14CwzJz53iLecJhtMo8D/jfnVu60De1xwJjnM0pg0qVRYy1OIGK0rWoFVSh+2ffLdMy1pvFaYdCDj7j72QBCwRmbaYU+HMa9diQ3DKiP0oDqPzy/mu2RZq92/XscFqRRnEelUI3dRQDl/6gj5om+tXKJ6daXjvKW6wGXywJtjS/eE4MxhSWaoKjt9+I39de82ev1g5LZ+09w3r9yKoUgw+W8TVKFP7mFsc4w5N0V0IzifEXRpUL7AuWRNmKdTtL6B31X1T7jJfqxPRuaM9MX1BD43rwJnCrbgF9jtVkzf2tQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR10MB3570.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(346002)(136003)(366004)(376002)(8676002)(2616005)(4326008)(316002)(8936002)(6512007)(66476007)(16526019)(107886003)(26005)(956004)(6666004)(69590400011)(186003)(83380400001)(36756003)(5660300002)(52116002)(1076003)(66556008)(478600001)(66946007)(86362001)(6506007)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?bvKWDeAaR9vLo/kPCr57faAuuSs4X7/mXGwnFmG3tdYtJtXesqCYAnAkD4rl?=
 =?us-ascii?Q?k+iOsUITNqIeGCUPCFdTUft3oK+OTApaW5KZORkKhmm84pHk/WMcDc+v0B6g?=
 =?us-ascii?Q?6dBcGrNStdjCmGa+W78MBdz03f5xm+1B4gPkqEM2rcQ2GVSjolg6MxUgkueo?=
 =?us-ascii?Q?fRTsvfFwMj/nqkl1Ttufzn/1JqOV9AetDBIzLETAAgcd1prCvjTRAql2L1W2?=
 =?us-ascii?Q?rGBoNleYc9HU8lhMy94uRtOXwkJMzNSkeYxYBbQY4uLA2PN+aw6+peHR5/kw?=
 =?us-ascii?Q?3HLEf2SwXfF9loYiIh/jnCx4ftLAm8fxRfXgw056LtnGFxCk+MsSaBBYM6hX?=
 =?us-ascii?Q?ZsTt7WCiFPg9ex7dWVpfBzhn8tH4qfTw0eUOOch/tFjUp6eBe3ZvoLrbC+69?=
 =?us-ascii?Q?ayUo3pB+JONTNB6rdhXvtd/78GJ/PRJ8/akNUoW2WyvNqpB9mrcBwy79vc8a?=
 =?us-ascii?Q?EpwzT0ewMa9PgN77vwLEd9NDPvYoiB5S3zVd5b0ZnhkGgBLhqg4c71VZ72L5?=
 =?us-ascii?Q?n95SVx8QU164PtA0UcBJneo7DNLJlV5fSNzZWVsc3T2Cl2ONwZVjmYtMK8SF?=
 =?us-ascii?Q?5ie0wi/lBJXA+YUGmurlBcX/Ao80ww1ZFd+shJHQE6RtD4SF7hRp8UGEc6QO?=
 =?us-ascii?Q?kCruPnEDQaX3oA5q1bAkQzkQand+8/zBsDNk3w8SChXLzLaawJDg+zEOODtt?=
 =?us-ascii?Q?Y2dw79wx4FgNBazcXAZSCgwC4R1QWWzPzKh0dW9mLDlRzBJj1umiXwgvbKu2?=
 =?us-ascii?Q?MnvCUi+1irMXZ3GnN5NsWSR1mgEXaFiFzvp08u5OtFbQMhxwiGaeaqwstqH4?=
 =?us-ascii?Q?EWUTZ7VkmXXKUtgnZDK8aHxgRgPdWt99q+sSq+jUHhb//dIzccRvMjPc5ZgB?=
 =?us-ascii?Q?H6bFQI6fNHjKuR2E0/j5W+Tdqzk1aTxzVziUn1W2186/nUAI2Qkh8uXZ3ozs?=
 =?us-ascii?Q?Cwut59BuMT0O+M9PcQsL5v1vuVWqBjWLifI7VDl7pl9Tz8Ch9AolfSg8+pVT?=
 =?us-ascii?Q?53X5mvGLszhoFdNeaXqQkRSaJsxcnpiGCJFTE8kB7MuGge+fLRpl2rBSMHU1?=
 =?us-ascii?Q?GLUaoNkCLgQHzpHrYgmLXbTb+KO/+5NVO17bXp2L+1CvfHNFSUyqp/5lVMVF?=
 =?us-ascii?Q?U9OvNBRYKN/sqlYDny6oQ/mAlmLN3+Ug3ujGbtJbuSaJMpxwh5jsm7kAuS58?=
 =?us-ascii?Q?gDKgu688awbsVzowc7D/8TO37+yZquS2GETHgcBgYj4Q5Jc1TGufaIT4yHs1?=
 =?us-ascii?Q?rKhdURFdDhZsSDCrp6iEQk0vERwxw3C6qJCFHdRARbw/OF6eTQYdxaA5+GUP?=
 =?us-ascii?Q?9i8aJ6n+h8gucJ//wURR73Q+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e362ae6-faf6-4ad4-f216-08d8cf279b51
X-MS-Exchange-CrossTenant-AuthSource: BN8PR10MB3570.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 07:27:09.1197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 30FUW0kha3r25sqiqJecw/eVInf9NyULNeaEIRjY2LjduLBZkLxFMm8posKj8kYQw9S7KJMi3Dc/zweCVM+WdRjXQzKcjO/4uIeY+abuXX0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5254
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120053
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120053
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

loop and vhost-scsi do their target cmd submission from driver
workqueues. This allows them to avoid an issue where the backend may
block waiting for resources like tags/requests, mem/locks, etc
and that ends up blocking their entire submission path and for the
case of vhost-scsi both the submission and completion path.

This patch adds a helper drivers can use to submit from a lio
workqueue. This code will then be extended in the next patches to
fix the plugging of backend devices.

Note: I'm only converting vhost/loop initially, but the workqueue
based submission will work for other drivers and have similar
benefits where the main target loops will not end up blocking one
some backend resource. I'll port others when I have more time to
test as I think we might want to make it configurable for some
drivers.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_device.c    | 10 ++++--
 drivers/target/target_core_internal.h  |  1 +
 drivers/target/target_core_transport.c | 42 +++++++++++++++++++++++++-
 include/target/target_core_base.h      |  8 ++++-
 include/target/target_core_fabric.h    |  2 ++
 5 files changed, 59 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 7787c527aad3..74d3a4896588 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -735,8 +735,14 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 
 	dev->queue_cnt = nr_cpu_ids;
 	for (i = 0; i < dev->queue_cnt; i++) {
-		INIT_LIST_HEAD(&dev->queues[i].state_list);
-		spin_lock_init(&dev->queues[i].lock);
+		struct se_device_queue *q;
+
+		q = &dev->queues[i];
+		INIT_LIST_HEAD(&q->state_list);
+		spin_lock_init(&q->lock);
+
+		init_llist_head(&q->sq.cmd_list);
+		INIT_WORK(&q->sq.work, target_queued_submit_work);
 	}
 
 	dev->se_hba = hba;
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index e7b3c6e5d574..56f841fd7f04 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -153,6 +153,7 @@ void	target_qf_do_work(struct work_struct *work);
 bool	target_check_wce(struct se_device *dev);
 bool	target_check_fua(struct se_device *dev);
 void	__target_execute_cmd(struct se_cmd *, bool);
+void	target_queued_submit_work(struct work_struct *work);
 
 /* target_core_stat.c */
 void	target_stat_setup_dev_default_groups(struct se_device *);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 4723cc6abf61..d782d3a0f9d5 100644
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
@@ -1380,7 +1389,6 @@ void __target_init_cmd(
 {
 	INIT_LIST_HEAD(&cmd->se_delayed_node);
 	INIT_LIST_HEAD(&cmd->se_qf_node);
-	INIT_LIST_HEAD(&cmd->se_cmd_list);
 	INIT_LIST_HEAD(&cmd->state_list);
 	init_completion(&cmd->t_transport_stop_comp);
 	cmd->free_compl = NULL;
@@ -1788,6 +1796,38 @@ void target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
 }
 EXPORT_SYMBOL(target_submit_cmd);
 
+void target_queued_submit_work(struct work_struct *work)
+{
+	struct se_cmd_queue *sq = container_of(work, struct se_cmd_queue, work);
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
+		target_submit(se_cmd);
+}
+
+/**
+ * target_queue_submission - queue the cmd to run on the LIO workqueue
+ * @se_cmd: command descriptor to submit
+ */
+void target_queue_submission(struct se_cmd *se_cmd)
+{
+	struct se_device *se_dev = se_cmd->se_dev;
+	int cpu = se_cmd->cpuid;
+	struct se_cmd_queue *sq;
+
+	sq = &se_dev->queues[cpu].sq;
+	llist_add(&se_cmd->se_cmd_list, &sq->cmd_list);
+	queue_work_on(cpu, target_submission_wq, &sq->work);
+}
+EXPORT_SYMBOL_GPL(target_queue_submission);
+
 static void target_complete_tmr_failure(struct work_struct *work)
 {
 	struct se_cmd *se_cmd = container_of(work, struct se_cmd, work);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 63dd12124139..815de4c97230 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -487,7 +487,7 @@ struct se_cmd {
 	/* Only used for internal passthrough and legacy TCM fabric modules */
 	struct se_session	*se_sess;
 	struct se_tmr_req	*se_tmr_req;
-	struct list_head	se_cmd_list;
+	struct llist_node	se_cmd_list;
 	struct completion	*free_compl;
 	struct completion	*abrt_compl;
 	const struct target_core_fabric_ops *se_tfo;
@@ -764,9 +764,15 @@ struct se_dev_stat_grps {
 	struct config_group scsi_lu_group;
 };
 
+struct se_cmd_queue {
+	struct llist_head	cmd_list;
+	struct work_struct	work;
+};
+
 struct se_device_queue {
 	struct list_head	state_list;
 	spinlock_t		lock;
+	struct se_cmd_queue	sq;
 };
 
 struct se_device {
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 0543ab107723..3c5ade7a04a6 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -165,6 +165,8 @@ sense_reason_t target_cmd_init_cdb(struct se_cmd *se_cmd, unsigned char *cdb,
 sense_reason_t target_cmd_parse_cdb(struct se_cmd *);
 void	target_submit_cmd(struct se_cmd *, struct se_session *, unsigned char *,
 		unsigned char *, u64, u32, int, int, int);
+void	target_queue_submission(struct se_cmd *se_cmd);
+
 int	target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 		unsigned char *sense, u64 unpacked_lun,
 		void *fabric_tmr_ptr, unsigned char tm_type,
-- 
2.25.1

