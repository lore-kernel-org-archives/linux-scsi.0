Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91C88C43331
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 12:40:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CD8E64EB4
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 12:40:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbhBIMkB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 07:40:01 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:43206 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbhBIMjs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 07:39:48 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119CYA8k054681;
        Tue, 9 Feb 2021 12:39:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=/PA4gd1D6jVrBXFmI67kErEr/sUV9xPGhvQiBeIrQXk=;
 b=DUwaFX0gvqgSRe3VeXsh+8pKHu+T3MmB1gOsLNq5UG4MHEL4Go0qS9xXbbKOKQS0J6gW
 wlH2rjy0r3FIsB529NmDZ7S4/qO4WAS/tAlvqvsESNOnHnTixalY+x0/S5bQXgOarQ8P
 BJ4MXKTrRUI0WvCD3HvZnoaPVK01kaQnf9Yw546g++IJ4O/DpnSbC0KO8mmRghtxqsVu
 bLqSOM+vdbrgXCUdQMkz4bIVFNpj0Ae1aPGTjVo7hT9O6BDrnRF8+4G9cmdRkxFzuTBh
 bifLGkjdF/wJJ+/uH0tT1X3aoCyddVLZQmhdmBMARHoON2FcKOU+MBJmkdItm+CwhA68 6A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 36hgmafe4p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 12:38:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119CaDIH178533;
        Tue, 9 Feb 2021 12:38:59 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by aserp3030.oracle.com with ESMTP id 36j4pnn07j-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 12:38:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VCq+LcRGgk8e5A80+oDvV7gUvLEK9+nP5SZbT5vuO0PPJx6Lk69/KZdcsVfdkp0IlqQWh2rOjdX/xQeQ6vGj8E2zFxNFFJBp+sniZLAH9bCkr+lmmLYaBX8VmsymcTVJayigGIqW2qLP90CknWYx62qu7SookT7sIz5L46oCDjUpFl+G23BTRy9U0Rwp5CN829O47zTv2/TssfjEykL3fwOxGv0ZPPKELX6K8zezY6ccHp88IEvuYmW29UA22P88DF4sabECNA7dZdpczKXjzX8puopDpws303vz7Mycq0EBV8AAxHlPTU20TPkzWormV8bYZ/349RGoWzdhLFTRow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/PA4gd1D6jVrBXFmI67kErEr/sUV9xPGhvQiBeIrQXk=;
 b=GajDKcug2p8V+ZLDgt8tW4Pz1uFVTDdZzxxWJicbZPiOI+PlDJ8HWdmrT0xn+G8p5MvIOyJuFd8FP6xo58CRw8BTVLMU+xnTI1BCNNOTnrwkACD0aPpE8dGvyEKL8q0HgSsRS13t66Q2uFzf4e3ocD9YbkvK3h9fxXOFTZABX13WQmBxpxWkBWSpP3tmZ3Hy5YPgPQyUKfM84tMi6J35Moh2nAkOL97QsMjiBpfNiGwPK1vhuV96s3xRo1LjmKJvuenE9tRcvC3Vn5/d/LkCI9IpwLfN9rXo5JJ6/mQs8tXzEMF5laVajN74AAXTm+5CSfYPaM6tfizZif8VO0TaWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/PA4gd1D6jVrBXFmI67kErEr/sUV9xPGhvQiBeIrQXk=;
 b=puzm1Mw3dv1ghnbG9hCC51TucUizDDTnW5sAl8D8RW+uRZh3AtGPdJG91sZORzJ0fXfzPs8N2DeWhGMyERPHvydvq8XdM73KjEqNKQdEf4y33OquijPsHpShtvr4EwnQXgyXbdmvqB7MCkk5ICSjkF29QWv8JB6W8PB81LKu5XY=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2600.namprd10.prod.outlook.com (2603:10b6:a02:aa::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.25; Tue, 9 Feb
 2021 12:38:58 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 12:38:58 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     Chaitanya.Kulkarni@wdc.com, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 03/13] target: add workqueue based cmd submission
Date:   Tue,  9 Feb 2021 06:38:35 -0600
Message-Id: <20210209123845.4856-4-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH2PR03CA0007.namprd03.prod.outlook.com (2603:10b6:610:59::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Tue, 9 Feb 2021 12:38:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 685d3e76-995a-446f-76a8-08d8ccf7ab6a
X-MS-TrafficTypeDiagnostic: BYAPR10MB2600:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB2600EFFF8157983E6E62A070F18E9@BYAPR10MB2600.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BlRGrxny6ExQ+lf5UlDesm1FJVggZiEAl5Rh28I0IHhoQI6SskTNy1HQlry7f6m4mWAwx30FFIsK/ga1tVnLQ3NSLXA2rDzy0Fg01yfJE8JamdrocdzRIREgDqkU4yG2/ApVLXh6cjMGaHdkujaNNv0wdRZn8IJF2EwSE4m67ON0FSffKYBgMPRE7ZZ27DLLlHgS9HI2jogCDRFSy4shkVc4efCSSGTvjMdYaa03FH/q2U2IjjXVNKMtW9mX+hhDw4u215af5oLfP/Lfw0Q/6pxUSCh6FUYFvzK/bNaMrIoEcHcBLPo82l8QScaBwknMl/GA7B9X2UpSOa5f7yj8H9r7KobHTBZT262CIC8k9Ze94wtrT8qj3ME6Pb1sz1vQuYyODMfzCHKRpz9ZOHnOBTRIHcOIeqCvB+mrkfjXDB9tLSQ/qigKGBdWMJcO/6LBbA8rpqaExQAlq+KFMVnrAu01NHSmkj7eg7oDDRLkbREFZBrNPU4WY4OjcFOYMSj35HFFCKIZhUPXpHeR5mOvGUF/SmBFxbitKv48kojQOwu5kGykR69IhenTizy7kjov+ldOT4tPdErW6c1/4HKRpw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(366004)(136003)(396003)(2906002)(6486002)(16526019)(8676002)(86362001)(8936002)(5660300002)(4326008)(6666004)(107886003)(1076003)(478600001)(6512007)(6506007)(52116002)(26005)(69590400011)(186003)(66946007)(66476007)(36756003)(66556008)(316002)(83380400001)(956004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?trq/OHb3UlXaMAOP+E8spcc2cCTLeNekSdv/hSCPHnbaHphDH7p1T8NLTJWD?=
 =?us-ascii?Q?fLDbGeOMRXTe3K29tbsk5Ywke08O/XIsG8t28Z/hPGIpziujNJS/5Zj4QYua?=
 =?us-ascii?Q?dbmcDr3Tjybt7BbfAvSfWVwmSYNcpSq37F/5fwBXaqdzfSBWxOROMBPdBYuu?=
 =?us-ascii?Q?l2x6/fzTjAvXHSK5JT0vhLISgbqYzVLhukB0Qx5912wufjlgtSWFdTvzgLIY?=
 =?us-ascii?Q?0rDkEZipMiYhIcCWYj23DBNbPwu+IezdBE8rhFiM/7EKvXyiwiVnFemZUa8x?=
 =?us-ascii?Q?sYbLptcxf1S4OH77W7DqBI1+6LRTmSSo2yMGrLiH7z1Rj4RtmYs0Z2iQiLBa?=
 =?us-ascii?Q?czqOEyoA+9P5U8KwrG/O7t3U2g/TWeklEGfRYIRYpAhh2minTEJrGhDiSCGk?=
 =?us-ascii?Q?xx55jZY7mBdzYXV9v+dXvtzsDGlfjgIl4fWatUBVdqSAuqgx5R3aIl1Gy4p7?=
 =?us-ascii?Q?1Z5vhmX6Kr0VI6tG9Ge3sOHFxKd1glz7UrM/5+v4fVDvEJPcbJKA2+9BAH1A?=
 =?us-ascii?Q?F8NJ2MsX7pc+7wBsqjF2IHDpLuYVDFrAxggG8Um/cCHqa6ypBG8rgqBt6j4E?=
 =?us-ascii?Q?3aRWS7M4OFm47S77QLAgADLOJ0W7M0kut8xRJOKOAuc7oE7H6UdiCWtGm78Y?=
 =?us-ascii?Q?+ox4jXIjPGvM1vCjfMJgmIz73BdmJcevNtKLW3S2AJbADuzk98Il+aZ2VFde?=
 =?us-ascii?Q?CF4dOVKgH1sAUuC8Hpm6an/UcUBWvvc2wJVD+n/+AsUz47EL0GKDdCsUHqy7?=
 =?us-ascii?Q?bgXiiwdsX+9wCPF9fbCww5oHnMGwMiSrWx0P15YUoALAo5esO5Osi5Z/i1oJ?=
 =?us-ascii?Q?SS6a923geXVFDPC0WNoDQGfpapfi6km0K+ek4zv58CPxzAk4d9KXDkNdbnzc?=
 =?us-ascii?Q?1UvXtXN0wCPG9ta68jwMqi5eNY3nWT8bEci5FvWCGVQj5fuLwlOc54fCnj0+?=
 =?us-ascii?Q?bC6Eqs3sVKnI6o1kVJkfVyYtB8Z3IUWLDF6mRZBVk3R5zs6VP9rgFUhBrU3m?=
 =?us-ascii?Q?UM6viHObf+jvLYcOr4vGq3ckYDx6qMK1V92lRcq7FQ0GxqV+lNzn/dHzCuum?=
 =?us-ascii?Q?cACCAwPxXfOPOx39hXWzfI9bPox+DAZXLAvQqoRxouWoK/uarvOhzHdZyshU?=
 =?us-ascii?Q?YlEYRASLEBY4rPcOBTn0/ysi9NcSd03/HRgEBFLkVkOADXPufYYQcTwad44Q?=
 =?us-ascii?Q?DYFi77ZgJ086MiIF59nzNDCxq/f7YpagoS1nOvoMJTO2jkmJ5sJ+77i8762v?=
 =?us-ascii?Q?gsAQ6WV80V3/D0+spXS5zTx/qq+Mq63Rkn+jB+EFu9yu9K5xmAX6HsugDE75?=
 =?us-ascii?Q?igy/MJELuXwi3UqLjcYr6cAj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 685d3e76-995a-446f-76a8-08d8ccf7ab6a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 12:38:57.9323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jNbNFNqI+BEEl2c+4zQTS6BG979/w77BH83Ff9cy9FcGKIEVP2iuqBDy/3mEX1cyDhizs9m3W+nA1zPTOjMSP+01DQVoMaP1ZyMMbLAQbm0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2600
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090066
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090066
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
 drivers/target/target_core_device.c    | 10 ++-
 drivers/target/target_core_internal.h  |  1 +
 drivers/target/target_core_transport.c | 91 +++++++++++++++++++++++++-
 include/target/target_core_base.h      |  8 ++-
 include/target/target_core_fabric.h    |  7 ++
 5 files changed, 113 insertions(+), 4 deletions(-)

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
index 71b0a862608b..46e20c42119e 100644
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
@@ -1380,7 +1389,6 @@ void transport_init_se_cmd(
 {
 	INIT_LIST_HEAD(&cmd->se_delayed_node);
 	INIT_LIST_HEAD(&cmd->se_qf_node);
-	INIT_LIST_HEAD(&cmd->se_cmd_list);
 	INIT_LIST_HEAD(&cmd->state_list);
 	init_completion(&cmd->t_transport_stop_comp);
 	cmd->free_compl = NULL;
@@ -1827,6 +1835,87 @@ int target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
 }
 EXPORT_SYMBOL(target_submit_cmd);
 
+void target_queued_submit_work(struct work_struct *work)
+{
+	struct se_cmd_queue *sq = container_of(work, struct se_cmd_queue, work);
+	struct se_cmd *se_cmd, *next_cmd;
+	struct llist_node *cmd_list;
+	unsigned char *cdb;
+
+	cmd_list = llist_del_all(&sq->cmd_list);
+	if (!cmd_list)
+		/* Previous call took what we were queued to submit */
+		return;
+
+	cmd_list = llist_reverse_order(cmd_list);
+	llist_for_each_entry_safe(se_cmd, next_cmd, cmd_list, se_cmd_list) {
+		cdb = se_cmd->se_tfo->get_cdb(se_cmd);
+		target_submit(se_cmd, cdb);
+	}
+}
+
+static void target_queue_cmd_work(struct se_cmd_queue *q, struct se_cmd *se_cmd,
+				  int cpu)
+{
+	llist_add(&se_cmd->se_cmd_list, &q->cmd_list);
+	queue_work_on(cpu, target_submission_wq, &q->work);
+}
+
+/**
+ * target_queue_cmd_submit - queue the cmd to run on the LIO workqueue
+ * @se_cmd: command descriptor to submit
+ * @se_sess: associated se_sess for endpoint
+ * @sense: pointer to SCSI sense buffer
+ * @unpacked_lun: unpacked LUN to reference for struct se_lun
+ * @data_length: fabric expected data transfer length
+ * @task_attr: SAM task attribute
+ * @data_dir: DMA data direction
+ * @flags: flags for command submission from target_sc_flags_tables
+ * @sgl: struct scatterlist memory for unidirectional mapping
+ * @sgl_count: scatterlist count for unidirectional mapping
+ * @sgl_bidi: struct scatterlist memory for bidirectional READ mapping
+ * @sgl_bidi_count: scatterlist count for bidirectional READ mapping
+ * @sgl_prot: struct scatterlist memory protection information
+ * @sgl_prot_count: scatterlist count for protection information
+ *
+ * Task tags are supported if the caller has set @se_cmd->tag.
+ *
+ * Returns non zero to signal active I/O shutdown failure.  All other
+ * setup exceptions will be returned as a SCSI CHECK_CONDITION response,
+ * but still return zero here.
+ *
+ * This may only be called from interrupt context if the caller's
+ * queue_status and release_cmd callouts do not block.
+ *
+ * This assumes internal allocation of fabric payload buffer by target-core.
+ */
+int
+target_queue_cmd_submit(struct se_cmd *se_cmd, struct se_session *se_sess,
+			unsigned char *sense, u64 unpacked_lun, u32 data_length,
+			int task_attr, int data_dir, int flags,
+			struct scatterlist *sgl, u32 sgl_count,
+			struct scatterlist *sgl_bidi, u32 sgl_bidi_count,
+			struct scatterlist *sgl_prot, u32 sgl_prot_count)
+{
+	struct se_device *se_dev;
+	int cpu, ret;
+
+	ret = target_submit_prep(se_cmd, se_sess, sense, unpacked_lun,
+				 data_length, task_attr, data_dir, flags,
+				 sgl, sgl_count, sgl_bidi, sgl_bidi_count,
+				 sgl_prot, sgl_prot_count);
+	if (ret < 0)
+		return ret;
+	else if (ret > 0)
+		return 0;
+
+	cpu = se_cmd->cpuid;
+	se_dev = se_cmd->se_dev;
+	target_queue_cmd_work(&se_dev->queues[cpu].sq, se_cmd, cpu);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(target_queue_cmd_submit);
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
index d60a3eb7517a..d7b54f3e04da 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -80,6 +80,7 @@ struct target_core_fabric_ops {
 	int (*queue_status)(struct se_cmd *);
 	void (*queue_tm_rsp)(struct se_cmd *);
 	void (*aborted_task)(struct se_cmd *);
+	unsigned char *(*get_cdb)(struct se_cmd *);
 	/*
 	 * fabric module calls for target_core_fabric_configfs.c
 	 */
@@ -160,6 +161,12 @@ int	target_submit_cmd_map_sgls(struct se_cmd *, struct se_session *,
 		struct scatterlist *, u32);
 int	target_submit_cmd(struct se_cmd *, struct se_session *, unsigned char *,
 		unsigned char *, u64, u32, int, int, int);
+int	target_queue_cmd_submit(struct se_cmd *se_cmd, struct se_session *se_sess,
+		unsigned char *sense, u64 unpacked_lun, u32 data_length,
+		int task_attr, int data_dir, int flags, struct scatterlist *sgl,
+		u32 sgl_count, struct scatterlist *sgl_bidi, u32 sgl_bidi_count,
+		struct scatterlist *sgl_prot, u32 sgl_prot_count);
+
 int	target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 		unsigned char *sense, u64 unpacked_lun,
 		void *fabric_tmr_ptr, unsigned char tm_type,
-- 
2.25.1

