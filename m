Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A536C433E6
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:18:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22CCF64E84
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:18:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhB0RO7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Feb 2021 12:14:59 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:47962 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbhB0REI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Feb 2021 12:04:08 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RGx6Qt032888;
        Sat, 27 Feb 2021 17:00:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=xU71cbsajd6EAjkDm/SEEusOTxGkcuJ4ufAFW1Y2p1I=;
 b=FbsCZO6BWGR58p28Q2MdGy29bNvu06qhFINlBbknStjAy6MTv2jyy4iYfgaEUL7BKf4L
 +HMP47I36mK9Z6oUrX/usIxQqjGY1hX10yyimx/V/5CJ7bITSesQoEa7+7rVzMIFfTNy
 M4NO2KdVqB5IzLz6oXaUPXg3L2zqgxS+TtOMECB+mQ9Db0jPxFxRS26XcXfhLpQ2w7dw
 KcBpjydDhl+rjzFiCSCOySIOrFJT1HajSnPBcxOe1DfWZCePZv0ulyStqO5ddg3Thirj
 iudWIfGFM+WsmyC2JBfm90xL4Q1O9kJ/lcbCuboUKD8CvTCrpNNgUGbATKsLa4QrhzUW dA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 36ybkb0v4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RGsmDB041731;
        Sat, 27 Feb 2021 17:00:31 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2048.outbound.protection.outlook.com [104.47.73.48])
        by userp3030.oracle.com with ESMTP id 36yb6sam7c-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G4QAQCI++bq99OOLcTlN20x4XJnwtKI2UndD0GRipB4zm5YibMtcpC3i6IcI45R9ijNH32P3chZiYirgB7PGDlsYn0l1P3HO6+TWkNkDMQBnc3pdiEK/gpWuWDpM4i9O8E3Bkz5Xs1x7/lIPTyRhQNPQB2KRTUe3kZ8kAsyjtqvs0x4F9uJuXgoNx0UHei7vT8TMGLNFrhb+E5CPJDKQH2/5bdvLg6Ksboi+Q8I/J/qrtljqv+obNH7TcrdbmkHtGs10ba/JejkkOHRnDrsjha8HV3d7FClBSynhksOgdpUH+emOEbNJNxIUDoyTVT21BhbtK/Uvr3kq9jx8MryIdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xU71cbsajd6EAjkDm/SEEusOTxGkcuJ4ufAFW1Y2p1I=;
 b=a3e9ZNSB0UcyHfRyYm1AnJQTZA2zMoaEJzEhOMRcPTgizm6QWk+KHbWqon62JjC7FYdOwoU+cNmOq8XIHw0wxCxKPYNFWqefEvB/VO3E4cCUTZH8s5Z1zqv/ZEwWXj4TeZJmGbymU+phWeInQ5K/rmvhqO24BdLa4OH+oCDn68P6wMVYWgtqQcRGAL2SCu1pVlM/6WpiRICb7z1hgt0PRhA4FHIApPKBUkluV51tQxFU8nNcHmR7MufR6cs0JzilJVLz/ucWcub1i14oGr9B1EePzvkrLkYX0AQ10ASiZCEq5NsBR5qNlMmNlfWoV/2djdWP5bvpUs/4gu3kdvWrpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xU71cbsajd6EAjkDm/SEEusOTxGkcuJ4ufAFW1Y2p1I=;
 b=aqeHcjqJlXNHJSvJKEbPowSo79bXZdonopcOFQ7GkeuV9GrSO+a6ziJTZEZSJ1giC9XeUF+nIx80qJnjkIAp5AyVSe/9LonUT79j6xpW5lKLq7McmNw2EoNqOwYoT+D5KU8po5aZZIgbv/GhwputZKnMQnVue8DmiG/t3w5TrZY=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3577.namprd10.prod.outlook.com (2603:10b6:5:152::16)
 by DM6PR10MB3499.namprd10.prod.outlook.com (2603:10b6:5:178::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.22; Sat, 27 Feb
 2021 17:00:29 +0000
Received: from DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b]) by DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b%7]) with mapi id 15.20.3868.034; Sat, 27 Feb 2021
 17:00:29 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 16/25] target: add workqueue based cmd submission
Date:   Sat, 27 Feb 2021 10:59:57 -0600
Message-Id: <20210227170006.5077-17-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210227170006.5077-1-michael.christie@oracle.com>
References: <20210227170006.5077-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:610:b1::32) To DM6PR10MB3577.namprd10.prod.outlook.com
 (2603:10b6:5:152::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH0PR13CA0027.namprd13.prod.outlook.com (2603:10b6:610:b1::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.13 via Frontend Transport; Sat, 27 Feb 2021 17:00:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c636e0de-8b66-4882-0e98-08d8db412fce
X-MS-TrafficTypeDiagnostic: DM6PR10MB3499:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB349956EDB2D49C0C4AF59F1BF19C9@DM6PR10MB3499.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SCDs1AsF3wjdxphN5nZn8qmXe5/qk5Ee5NRW56f8uaHO7PD8mzV7MBEhH8rj30RoYIi5/erX+P0xfU9QTGgIk9EqAVCy0jWUMkEIt2pJaJKVr058YUGQp7YMDvVa0DAp1XLFM/O2TgEZzckM+pNT7ZgtMDez3iNFygmyBeVqNs+RuQ/r1Ik+GAFD3gLUcJ9ekdDh2ryvw2ajhzXoq39ys9yvseICPEav3tcpTYnfWreWaK7xqc1NF1uhyYlenyMNige6Ae2MOZzXxXMIGPnX+h9XLFcbD5gULZyPeCyAdGfZTbo627tpp7kwB5M8PyObcZl9EOcAjtOi1Fmef80tL5EPp3XPqVsp9qA9Ch8qcWNWNMw8VSd+uxKW8Z1jbk+y5lJmKetudLCmu0tLAL47U1XWTn477uC+Zr17Rfl91vbGfkAiGRRBuForNmAe64EHRC3lMao9wnUUesHWDMmrvbt5mrhkvUe9/d1wFcbpHZpiP4dp2G0WjMKRxH2oGba7Md3Uri1MIC86sxhFngvlnWgEipzguNvimQX9s8Jq3+bo2Vozxq/u4k5cFyAKl7qO3d8KZmE3QO8ttBNXOoySqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3577.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(396003)(366004)(346002)(6666004)(956004)(36756003)(316002)(6512007)(86362001)(69590400012)(6506007)(1076003)(8936002)(83380400001)(2616005)(478600001)(2906002)(4326008)(186003)(16526019)(66556008)(5660300002)(66946007)(6486002)(66476007)(8676002)(107886003)(26005)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?2GM3n+jwXEgc4IglpbhiPGzFqhM7BZyjfyZxnj/6OXHLxnT/0S35zQZQXFmU?=
 =?us-ascii?Q?Gchaq+dUiAEMgiXajBGww+PX0yOwkMUckwFWv7Blqx1Y1gyA7tNuF1k6+gzm?=
 =?us-ascii?Q?68nfAWQLHTbrvfFPdxQNgFa8lu3W1VYdPPMkgCEIdZ8LoKr4muSoDEKR4Ogy?=
 =?us-ascii?Q?7MTfwAx4WvU9iwJB3o5xvPHRQ3GHKxujPu5J6yk2XssmihpgYzS+Uq9mhpRR?=
 =?us-ascii?Q?r8JC5GHMIlVa1CTybQuea8gBbPH0TRQ6UEupGil5nswCZyQ5NabzoYh/JfA4?=
 =?us-ascii?Q?OInCMrAYYmrIwedjBAVlpK9oM1fy5sOYPMxaNBgrxVd66lD74lZSaKd5PJWS?=
 =?us-ascii?Q?TNLLBlYf3A3qKl3g/gFjJz/D3mWZ+0iwFGSTdR6G4E5OBP1w2nLLO86d2wA6?=
 =?us-ascii?Q?vhePSvTkoHQtZX/4vu/9B3qmZ1voz8vSz+vbRsQGWYs2hbDdOjdQ+6d5W6HE?=
 =?us-ascii?Q?EoiOE4vcaIRW44eTHPE1nM7vp5svjo9R+ITD0YfwCe/MClCbzYjinY4+f4bQ?=
 =?us-ascii?Q?2/i+1iWBk9Ivg3N567sXcevtdxRKw+u/rLIzJcEcpxrCI4Ux/PGPQ45Pr2a9?=
 =?us-ascii?Q?AOVuuby0xoO+3Ix5YHVfzYXaLUIOqcMxJv9LjU2dNZWo3zCx4ktRx6EA2rGY?=
 =?us-ascii?Q?kRm2+qfuB953Aghm/WLuIFixlPbXd44lELwf27nz/zkr74YFo9+SOo1CnOan?=
 =?us-ascii?Q?mVU8OBeYshM+aYUVJBfoPg6FgkQ15zNkmf/1lGmefxo2LUpjwi4/MKAhKcdZ?=
 =?us-ascii?Q?wowCT6QuaBAGhSEoEp2f8hl1NShsOPMgLEISbPehfiM80wCLAfdEuRr9yXFD?=
 =?us-ascii?Q?NaQdPTGp9gA9GKv6nG1Dq9CbjhGFO2x3wCsruKbmhCKWBl92CpnXhABB75Hi?=
 =?us-ascii?Q?tEjZTI6owtgCVfsE54cdeWx8S7w+rGAP7VP1KQgtaKkSF1vvb+PRtTzQjeu2?=
 =?us-ascii?Q?TRDuc1QrPUskp2LN8+YLfEhiPpcKJ5AAoXQW0dSm2DupACAycIE4K4mT/jWj?=
 =?us-ascii?Q?jOSLP8xfwA9f3HNlLhXUMdb/NdcaV2umOSFaRzriH+ZLwWx32MtGMZV9iSiU?=
 =?us-ascii?Q?qbJ5stHiD2BeayIvkWx8utvwGZfHHmxNC1uvz39/uLDVUHNSKSRofaIEPJS8?=
 =?us-ascii?Q?kVAun1R2kb/ixXy2i+qum32wvxb4eAUTwGCpq6wam68W4P0xxscO5VGI5omF?=
 =?us-ascii?Q?T1dSMGcjpuTMFTXPPBHBjTnLwg8sWgyMZDSJH//jKHS2y3qLxuLxGh0tbJLq?=
 =?us-ascii?Q?difsxCqUpwyOr5o/yn9mkAPoG/U7iLlI+l3KtEOZWrSyAnUmYHWeRYwLCADK?=
 =?us-ascii?Q?YEHwYizTrn8GNkSjK8pSIfl/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c636e0de-8b66-4882-0e98-08d8db412fce
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3577.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 17:00:29.6284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yJ+ncXoMhVpGMqwHgUTVXhg+y6pQGAvLOnb/Uow9xqXzJ+EYzLKYKRlA8j9OuQ0cMSIB5pnG2uo7k1hRoUBcYgQ5UWnsHsAExgDZPP9l+gk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3499
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270145
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270146
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
Reviewed-by: Bodo Stroesser <bostroesser@gmail.com> 
Tested-by: Laurence Oberman <loberman@redhat.com>
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
index 6c88ca832da6..dd63f81bd702 100644
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
@@ -1797,6 +1805,38 @@ void target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
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

