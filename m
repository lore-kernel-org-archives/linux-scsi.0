Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01474C47084
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:06:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D79B761400
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:06:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbhEYSH5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 14:07:57 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56454 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231430AbhEYSHv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 14:07:51 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PI5cg0108029;
        Tue, 25 May 2021 18:06:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=adkC/lusXAvRBza6cvEif34yOWKLomqy1QYrDWkSuBA=;
 b=kuSaUPBp7U86jg0/Ffhg9Z0rXdfPqe/4+ePyd402Z+VcPab8soGKX3Kvg2teSZGDjh6n
 YEg3NbQl2dj4K2AaSFT3xovT708r9leJwm3rzztRfoFNe6aUslGyrwFHvr5VcXBiMV1w
 pQv44p9STu/QXXeoN6pKpdyHYqOvBqhb/XqrloxZsx0kp749EXuhLbulww/xqLOb/9W5
 2DH84NVbTXnIMw82pYF6IZSlNjuwxgWy03KZz7SAB8tdAqKOIHNZ+3i23iC9PaAHLI00
 pBIv7FVb7m3i4Ivy/4ZZmX31GLsXnCms7YwMwvcNts1dACHpiTOTxv5rs/hIE+Hl16Kk BA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 38q3q8xc04-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:06:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PI6D78185054;
        Tue, 25 May 2021 18:06:16 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by userp3020.oracle.com with ESMTP id 38qbqsga75-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:06:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SPE6AmzCiBYAvsw5INZUsF0z9u3/7rrlMHLxhbKYSshaaJMXUVqOQ4OkUtcPU3bdW9bDFNSnPXy4O4y+iPL7aSaUQeg4FvDEC9dmdd8PQov80ss23Zi0f4OI7kVj7XbPMrRVQPpMOg+J2PJLPBqcaKdj0U++9JpZuMB+kNWqLhkuS9nYf4KfuYVnI0GctHhr0a7nMn+7BX1HBnFj7rvyA30RTaMAk6v77TWsohLuEmQlle4/cYFb23b+6J/rDLgzNJWs+Ls7Y8l/1Z0M4DOPYoFC9aIuxBzSrqnasMiS+WExv8nAr7+Szh9/QJv1zLj1SFc+n6QFlf6G6MMR53kl0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=adkC/lusXAvRBza6cvEif34yOWKLomqy1QYrDWkSuBA=;
 b=DuVKY6l68loxUuP8aAeyXnl+9kARzHE6ZLGm6DP1fl1xHNWY8j9okvvu94f7JNuBici7vuZ9IZ3zIK62szAlcN3hAteTkwa4feeraSlAuQiPab634uBBuC2Wnygq3gmBBhyMrkEExhCfC9ywZGmu7sgDL/rCryR9l/vxpzyLj8+xZx1O0YAvfGNBi3EtY8A2LYZdEwHxqFE/+pZTWnIRDY9o+NsHWEkcNCEKz8ExnKCegRQdRCwmTgkbBb/gs/vG8baGq5QkV+7oCbpgOcinxS7z5ypEMKGJ8A6kmDtVynCf1TM8eLXtjUAl4NZHiKSnqi2Cd1t6VI3TBdAr/tO4Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=adkC/lusXAvRBza6cvEif34yOWKLomqy1QYrDWkSuBA=;
 b=Drolyypvtrn/a3BMn1MhOnu+NyCYRj9JcEvwlgOit/CIxb6xbk5xHCl20nvgLklusSmQOkIDOnk3OvwcrYF1PosvBKWb3fn/NcfJeJl4pAXaHC6CV0M5FD9mO1HXqdNv6TQ3a3kVMYxuNrSxKOZuT1jL8LOglQgsF2AFrQC2BLg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3431.namprd10.prod.outlook.com (2603:10b6:a03:86::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 18:06:14 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 18:06:14 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 3/9] vhost: modify internal functions to take a vhost_worker
Date:   Tue, 25 May 2021 13:05:54 -0500
Message-Id: <20210525180600.6349-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525180600.6349-1-michael.christie@oracle.com>
References: <20210525180600.6349-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR13CA0021.namprd13.prod.outlook.com
 (2603:10b6:5:bc::34) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR13CA0021.namprd13.prod.outlook.com (2603:10b6:5:bc::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.12 via Frontend Transport; Tue, 25 May 2021 18:06:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dcf62351-c05d-4a90-5682-08d91fa7c919
X-MS-TrafficTypeDiagnostic: BYAPR10MB3431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3431CA1DD38750446BD940C1F1259@BYAPR10MB3431.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:514;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xSJKwX+OroCDH5GR/LKnWbOUg/uIlUXRjpCn8J26MYhu+PYyWgqlUoULVJdvkuQUhC+9nsc7/AT9SSVnQVTNbc/roP0ZZX3GuoL7zNKpVV2v75Y0XhCsBlLiD8FR2yHxZb3iwPW6HpbnbId7JgGjgEYc2zE9ka0DPK+dobo/28Z0ch0ufPedr+hx1nRd4bZPk/jivqCA/LR618SBi7ptR32NOK7zczi2kDHD0SA83ZCHBb6dA/rIuu951+KCUJTHpjhnpDaOUGDFrpOZUF69DvcEvFwKcqZ9hTAHTvxjYUC3UmrqSeyZY0cqhURn7Wf1ulOlDagklemJAvQy40Nztl3j/k//H/439k80RcFUjyb3AaVvtX/VOmCEI0K4xU+krdQ/FihpbUMneiUg6ioq+vEw4ePyU27R0lgKI4d5y8BMemq9SKap55juWT3M6AJiezx0iWep1l+t4AekHYfYLGDayu1mJr7LfYv22Dj80QQvV1A/W1uEbEW9HxUM96sYoAqMLAPYVMVZoHz78FMfuoAOs4d6VgSiZLHxfnd4E8ys2BM005y6WD4A4nd9ZPM2cz8nCeugSnH8ZfK95xZg4kV1QexRoQsjeiWv0tlswPEdSMe8OZ2wmrYwa/0NZ/2880VuuCElaiMc7EoumDyu9F4cJ7cvr/IdgwBDgU0PSQoDQa1MxaiqgzSRUzmv/k1R
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(39860400002)(136003)(366004)(6512007)(26005)(38350700002)(186003)(66556008)(66476007)(52116002)(2616005)(8936002)(86362001)(6506007)(38100700002)(83380400001)(956004)(66946007)(8676002)(4326008)(5660300002)(2906002)(1076003)(6486002)(316002)(16526019)(6666004)(107886003)(478600001)(36756003)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?xAyqJzp0u0yP5CVIgNkU1Tem62okr0P8OHaUAigbgOWAyllMJG0YYd6+R1Qn?=
 =?us-ascii?Q?rQZpqSUwHM8HGLhIq/sSubosbdW+b5SS+ALy6ZteXyHEaSL4+2hsZnP1VZ5o?=
 =?us-ascii?Q?WmR6z8Hvx6rVX0om/KQBV4euAZTdMdLzV54I3xrnnp4Xtz84yDoAruUyYzMo?=
 =?us-ascii?Q?qf7IAk5JUx6v7KFiaAmKbjL4XLESpqU1g0vvWWMm2zWC22jwRA/q1BPULCw8?=
 =?us-ascii?Q?6bgNc82/QOvd9ez1XN7KHB9qt3Fx7ZjU6aZLgb9bkObnK+EGAC/o8pcr1F0Z?=
 =?us-ascii?Q?+WKLzUZjNIiCaaOL9OyYj0jenQJv5RzU7V+7pEizj0RVlnG5gOLD8q9QxFme?=
 =?us-ascii?Q?85bwOQgGD7Ib2xJgQRptAWJiVLb+HA1+k7giYGxBPwDuyacZzEI8jfDZQxMk?=
 =?us-ascii?Q?cFbtc+Wq280pcS7JjWi2+lUEGBNtJZbMOdnbZ6uEOO3TuVeZqkq4J9EAvp7S?=
 =?us-ascii?Q?WbUK4+dJ0GOS3q6dq1HeeaxX1z//SrhsBJQFgDxl2AwHIDT8RTeuWqX+PAgw?=
 =?us-ascii?Q?5q0I7gPYTxyuBUjeX6Ak3YuNyxRKp8WLQIgL4gXaFYVCuHGl1RPrXxLQLkRb?=
 =?us-ascii?Q?3TRu7f/4ORuNlXxfG+Xwjk+gmEu5dqtVd1BN1bSdFKvd1fh/ykfRjaQuToAZ?=
 =?us-ascii?Q?z6cdS4nJD5YnODnvQqRNTBnECZROR0MWK3CdCo+Zq4e0bNGhjMZENpm8ILsL?=
 =?us-ascii?Q?mySZrBa4FSe60e248I2WROZXKgRjGTfVD0wVHAeUdRb00stQPINLh4RRCPjT?=
 =?us-ascii?Q?swp3vefG3ulMVSbh4lsif8LjcmSC8g5oU2W+QtJW6A9ccMini4AapMcye+UN?=
 =?us-ascii?Q?/iZJbbjDtmilLulfS8FHViflfEi6MO+9X3ZdKIJywbY1BjgSBxNeCBttVHzM?=
 =?us-ascii?Q?vTraFEGWUlcFQcgf9rWjvuw2Yh9L7f0mR2a1y5dMS3JwGfnV31jgjq38i3B8?=
 =?us-ascii?Q?XrQMlMGOzgh+/f8zGAuwOreqjvsXFhSPgOZhXvvzC9c+89OKAz2I05Mp74Ga?=
 =?us-ascii?Q?5Kx77sdrG7WXYh/iQ/ozrRFoLtrvnGYpsAjZ4jnvIQIraRV77Sg1sHFFtEaK?=
 =?us-ascii?Q?XX5vo2m4BZxjnmD2Iq16iiTTmJCM757QOC0J4sfDVOPmLnVITYjeoPZa+Y0L?=
 =?us-ascii?Q?GEUZcpZl8G93Q1ekHFz6/cpW/L5803j8kQYbY+HMdXFkJgMttwtkythHRVzP?=
 =?us-ascii?Q?21VQAgKKOM8A54AQsMsITYKqcIgdO+gUf1sKgXorU+2a71NT6qdS4GUHRyw+?=
 =?us-ascii?Q?yYMwEDnpjmnl76aQa+GpmS45UBrRSZkXSDegMcMAIwsjZ7v9vVjqlKPYSx7l?=
 =?us-ascii?Q?mJzXMjxYH1nHaJgInHKAWow2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcf62351-c05d-4a90-5682-08d91fa7c919
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 18:06:14.5125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: szG1x4fGYirS8PybSeHoxl3J6Iv6VmRgaa4oLeACQmTiYfRM+M4wjezCEt487qmhN++WlNr+JmFd0rf4EEIb8kjPbx4dz6vRF++SG3cg/bM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3431
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250111
X-Proofpoint-GUID: xJuhYMUr_2PPhfqC9alAezf5bt7_OyAn
X-Proofpoint-ORIG-GUID: xJuhYMUr_2PPhfqC9alAezf5bt7_OyAn
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The final patches will allow us to have multiple vhost_workers per device
and be able to share them across devices. To prepare for that, this patch
allow us our internal work queueing, flush and cgroup attach functions to
take a vhost_worker as an arg.

The poll code required a change to the drivers, so the next patch will
convert that code.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/vhost.c | 136 ++++++++++++++++++++++++++++--------------
 drivers/vhost/vhost.h |   4 +-
 2 files changed, 94 insertions(+), 46 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index a291cde95c43..4bfa9a7a51bb 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -231,20 +231,6 @@ void vhost_poll_stop(struct vhost_poll *poll)
 }
 EXPORT_SYMBOL_GPL(vhost_poll_stop);
 
-void vhost_work_dev_flush(struct vhost_dev *dev)
-{
-	struct vhost_flush_struct flush;
-
-	if (dev->worker) {
-		init_completion(&flush.wait_event);
-		vhost_work_init(&flush.work, vhost_flush_work);
-
-		vhost_work_queue(dev, &flush.work);
-		wait_for_completion(&flush.wait_event);
-	}
-}
-EXPORT_SYMBOL_GPL(vhost_work_dev_flush);
-
 /* Flush any work that has been scheduled. When calling this, don't hold any
  * locks that are also used by the callback. */
 void vhost_poll_flush(struct vhost_poll *poll)
@@ -253,26 +239,62 @@ void vhost_poll_flush(struct vhost_poll *poll)
 }
 EXPORT_SYMBOL_GPL(vhost_poll_flush);
 
-void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work)
+static void vhost_work_queue_on(struct vhost_work *work,
+				struct vhost_worker *worker)
 {
-	if (!dev->worker)
-		return;
-
 	if (!test_and_set_bit(VHOST_WORK_QUEUED, &work->flags)) {
 		/* We can only add the work to the list after we're
 		 * sure it was not in the list.
 		 * test_and_set_bit() implies a memory barrier.
 		 */
-		llist_add(&work->node, &dev->worker->work_list);
-		wake_up_process(dev->worker->task);
+		llist_add(&work->node, &worker->work_list);
+		wake_up_process(worker->task);
 	}
 }
+
+void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work)
+{
+	if (!dev->workers)
+		return;
+	/*
+	 * devs with use_worker=true created by tools that do not support the
+	 * worker creation ioctl will always have at least one worker.
+	 */
+	vhost_work_queue_on(work, dev->workers[0]);
+}
 EXPORT_SYMBOL_GPL(vhost_work_queue);
 
+static void vhost_work_dev_flush_on(struct vhost_worker *worker)
+{
+	struct vhost_flush_struct flush;
+
+	init_completion(&flush.wait_event);
+	vhost_work_init(&flush.work, vhost_flush_work);
+
+	vhost_work_queue_on(&flush.work, worker);
+	wait_for_completion(&flush.wait_event);
+}
+
+void vhost_work_dev_flush(struct vhost_dev *dev)
+{
+	int i;
+
+	for (i = 0; i < dev->num_workers; i++)
+		vhost_work_dev_flush_on(dev->workers[i]);
+}
+EXPORT_SYMBOL_GPL(vhost_work_dev_flush);
+
 /* A lockless hint for busy polling code to exit the loop */
 bool vhost_has_work(struct vhost_dev *dev)
 {
-	return dev->worker && !llist_empty(&dev->worker->work_list);
+	int i;
+
+	for (i = 0; i < dev->num_workers; i++) {
+		if (!llist_empty(&dev->workers[i]->work_list))
+			return true;
+	}
+
+	return false;
 }
 EXPORT_SYMBOL_GPL(vhost_has_work);
 
@@ -482,7 +504,8 @@ void vhost_dev_init(struct vhost_dev *dev,
 	dev->umem = NULL;
 	dev->iotlb = NULL;
 	dev->mm = NULL;
-	dev->worker = NULL;
+	dev->workers = NULL;
+	dev->num_workers = 0;
 	dev->iov_limit = iov_limit;
 	dev->weight = weight;
 	dev->byte_weight = byte_weight;
@@ -531,14 +554,14 @@ static void vhost_attach_cgroups_work(struct vhost_work *work)
 	s->ret = cgroup_attach_task_all(s->owner, current);
 }
 
-static int vhost_attach_cgroups(struct vhost_dev *dev)
+static int vhost_attach_cgroups_on(struct vhost_worker *worker)
 {
 	struct vhost_attach_cgroups_struct attach;
 
 	attach.owner = current;
 	vhost_work_init(&attach.work, vhost_attach_cgroups_work);
-	vhost_work_queue(dev, &attach.work);
-	vhost_work_dev_flush(dev);
+	vhost_work_queue_on(&attach.work, worker);
+	vhost_work_dev_flush_on(worker);
 	return attach.ret;
 }
 
@@ -579,20 +602,29 @@ static void vhost_detach_mm(struct vhost_dev *dev)
 	dev->mm = NULL;
 }
 
-static void vhost_worker_free(struct vhost_dev *dev)
+static void vhost_worker_free(struct vhost_worker *worker)
 {
-	struct vhost_worker *worker = dev->worker;
-
-	if (!worker)
-		return;
-
-	dev->worker = NULL;
 	WARN_ON(!llist_empty(&worker->work_list));
 	kthread_stop(worker->task);
 	kfree(worker);
 }
 
-static int vhost_worker_create(struct vhost_dev *dev)
+static void vhost_workers_free(struct vhost_dev *dev)
+{
+	int i;
+
+	if (!dev->workers)
+		return;
+
+	for (i = 0; i < dev->num_workers; i++)
+		vhost_worker_free(dev->workers[i]);
+
+	kfree(dev->workers);
+	dev->num_workers = 0;
+	dev->workers = NULL;
+}
+
+static struct vhost_worker *vhost_worker_create(struct vhost_dev *dev)
 {
 	struct vhost_worker *worker;
 	struct task_struct *task;
@@ -600,42 +632,56 @@ static int vhost_worker_create(struct vhost_dev *dev)
 
 	worker = kzalloc(sizeof(*worker), GFP_KERNEL);
 	if (!worker)
-		return -ENOMEM;
+		return NULL;
 
-	dev->worker = worker;
+	worker->id = dev->num_workers;
 	worker->dev = dev;
 	init_llist_head(&worker->work_list);
 
 	task = kthread_create(vhost_worker, worker, "vhost-%d", current->pid);
-	if (IS_ERR(task)) {
-		ret = PTR_ERR(task);
+	if (IS_ERR(task))
 		goto free_worker;
-	}
 
 	worker->task = task;
 	wake_up_process(task); /* avoid contributing to loadavg */
 
-	ret = vhost_attach_cgroups(dev);
+	ret = vhost_attach_cgroups_on(worker);
 	if (ret)
 		goto stop_worker;
 
-	return 0;
+	return worker;
 
 stop_worker:
 	kthread_stop(worker->task);
 free_worker:
 	kfree(worker);
-	dev->worker = NULL;
-	return ret;
+	return NULL;
 }
 
 /* Caller must have device mutex */
 static int vhost_worker_try_create_def(struct vhost_dev *dev)
 {
-	if (!dev->use_worker || dev->worker)
+	struct vhost_worker *worker;
+
+	if (!dev->use_worker || dev->workers)
 		return 0;
 
-	return vhost_worker_create(dev);
+	dev->workers = kcalloc(1, sizeof(struct vhost_worker *), GFP_KERNEL);
+	if (!dev->workers)
+		return -ENOMEM;
+
+	worker = vhost_worker_create(dev);
+	if (!worker)
+		goto free_workers;
+
+	dev->workers[worker->id] = worker;
+	dev->num_workers++;
+	return 0;
+
+free_workers:
+	kfree(dev->workers);
+	dev->workers = NULL;
+	return -ENOMEM;
 }
 
 /* Caller should have device mutex */
@@ -750,7 +796,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
 	dev->iotlb = NULL;
 	vhost_clear_msg(dev);
 	wake_up_interruptible_poll(&dev->wait, EPOLLIN | EPOLLRDNORM);
-	vhost_worker_free(dev);
+	vhost_workers_free(dev);
 	vhost_detach_mm(dev);
 	dev->kcov_handle = 0;
 }
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index bfc4563e612f..fa1af4106755 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -29,6 +29,7 @@ struct vhost_worker {
 	struct task_struct	*task;
 	struct llist_head	work_list;
 	struct vhost_dev	*dev;
+	int			id;
 };
 
 /* Poll a file (eventfd or socket) */
@@ -155,7 +156,8 @@ struct vhost_dev {
 	struct vhost_virtqueue **vqs;
 	int nvqs;
 	struct eventfd_ctx *log_ctx;
-	struct vhost_worker *worker;
+	struct vhost_worker **workers;
+	int num_workers;
 	struct vhost_iotlb *umem;
 	struct vhost_iotlb *iotlb;
 	spinlock_t iotlb_lock;
-- 
2.25.1

