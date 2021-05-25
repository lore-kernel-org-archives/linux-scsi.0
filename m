Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8331C47087
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:06:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E94861400
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:06:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbhEYSH4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 14:07:56 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56448 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbhEYSHu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 14:07:50 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PI6GI3108446;
        Tue, 25 May 2021 18:06:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=7mBm+Bv9Nw7pAlhNVJAiAXX8Qk6OFRPwIU7RbgE9xFA=;
 b=ZEkJs5Yu+cXDx7dq5L2O8uUhS3tCkNy/CMSs8DitD8GgLCH6WjM246FEFIZzT8ZdFWS6
 2mzCVTkp0Jn5WBCmI6Cmdn4pJiJwaCNSVBP+MgQPod6Q5oBbtwEmFOaYG9qy2b2SPE/o
 mTrr5z+hCws/uWdlWQfn7ZGXnBcFnyASFiZDvXyDgD9uVzzk7M+Y5Mtjcz9zBth/DfZq
 /gv/Tba0n6sJto0gQFAMFEXjPM7JScnDXwy5qztY+Br92iuef6BsswrzFdGCGisLT6jE
 eUSOctNHmTj4p0BEpebfk8+vXlLtvmBVVrEY5ajYeyJn1I/sLown81B/HeEWKCtP508u HA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 38q3q8xc02-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:06:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PI6DiE185024;
        Tue, 25 May 2021 18:06:15 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2049.outbound.protection.outlook.com [104.47.74.49])
        by userp3020.oracle.com with ESMTP id 38qbqsga7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:06:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XiRnF0ESSIHbjPuHaeO0PM1MuSZe56kDXwcdY5aisa0N3UlMuONrw/AuFz5UyTFCjyEWwJakwwjgU4rgVEVh5sp9tH4e0MoqLWgc+m3edCveUmKfNmMnSOP+c9zvHG+WcwNzSP9L1mznR/vcTd9UysnuoHW0ajJwJeXX2IelP/qGkcYj1m1XmXfexd0MLjkdk2FW9mPzW4OeZUfqynCRD92diL1yGCz6LdMkjB5QdqC1sN2NVMqZ6OjeT5n1LSNmNbE8QZoksOvPOKAGIOwJ0SfjbMbazMAPB4XKk/Cps0adYvi8are021Wx4mPUNWsH0jfNQOqPGUMNA87SN/gDOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7mBm+Bv9Nw7pAlhNVJAiAXX8Qk6OFRPwIU7RbgE9xFA=;
 b=bfTBmL+QFi11fsgJbNRYlks1/Tmh7MbjY9epccHxGgL43UsdvhUCCYkbZyGsNH3w8mwRvDcnK3eNg0uFDARaf9wWJR2ahDT/q6ri/4/VOdS5lUhGr4P31KoTsPvqz7DHZuqf10cn9pDgbJ/AGqFpDTHBaFX0rEIbcmAsmeTMk871oImqW1PYM82zbxt0jWEm3efcWncLbxcFJh7RyWvuVKMFhGeaX48v1N5KbsrVNbOcxFlADDn9OM9Esmu3K5RBozkuTdTwhll6WEW6BeAtvIYdEYDqxyQbzvIbtiRXn/1gN0zTde5N+DYJNcqmk7kuNX+CbDVKdrkJoRV6+g+QIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7mBm+Bv9Nw7pAlhNVJAiAXX8Qk6OFRPwIU7RbgE9xFA=;
 b=KJjtBF00lee4waJBdc4V5mstmfYVuRFvSplLe/XTJxXJ5oZqUGsBAe7CcrkvlpHBPvOp9AZZLFgF+UWAovnKYCpyq9WFesgDtmcHP64gyRJ7aIThKp2hnRPzuLi2z87TLfkLE4b1+zsfTpPZRKZ0+7YNFK0kyKmxe1YHHVWG2zo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4639.namprd10.prod.outlook.com (2603:10b6:a03:2db::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Tue, 25 May
 2021 18:06:11 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 18:06:11 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/9] vhost: move worker thread fields to new struct
Date:   Tue, 25 May 2021 13:05:52 -0500
Message-Id: <20210525180600.6349-2-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DM6PR13CA0021.namprd13.prod.outlook.com (2603:10b6:5:bc::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.12 via Frontend Transport; Tue, 25 May 2021 18:06:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa303427-5ea2-4b41-79f2-08d91fa7c70f
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4639:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4639FB951CB50559458C569EF1259@SJ0PR10MB4639.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OvVhchLpaWc+Eb9OEFLfEc9HH8SxFZJQqmnfu1Dkhm+AbgA8vni6qf02vr1hAnkAFXYWvBCu9YjItadmL8TIZs7KLFrv+MpXZLYDtQcGyu1ME9Bb/Qp6DPj5mnNRtwmEgyI2Jli4aU/IjpHoU77qjG8udfBLUBJxFm9yVsyoTliUnIPdXZr0R3qnDkaZQT/j3rRdq/rC2nlC++wEus2DOe2aoUUSBAr90KnOcHAEGKn9Ay5BkqQAKKDV+hqsk+RCesJHJefBZzzWfjhXSTjHOgFgWRRO6RpjhzWf+WjFFpSjt2mF2VCiJYw1y5s9bstqh4ecAhYoZ8lowxXabRr8a5/KbPFmaY18+Ph+jnjh4A8zjOENPqpbZNgewJwtayikBtkciHAQQnwihaUproau0Au/PYGK8lrivPux8gJXK597Mrkc20yqEYb3YYUFiu5FkIzRd/uWGqzqWzgbBRifH8Ao004hj4dmki/bs0gAoIySxoq86T4KG3w7qe7UaqpU6tye82zZTdCbaEB6BE40EQm2Una3Y21FG2rEk3lYqM0gVyuBP7CDyCD0GcMMYdhWvFXpRLga/+Po9y4VlQ/RfGAnYyqCO/CzhjlTKy+qu1RYgrRz+H0H4kGe7xJiV2j65EYLQgnGawGq3Jwrnm+LsbM3W77XzDuc5NH9zhBz+wfqQbsG2mE2EwqVbpTrW4IX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(376002)(366004)(136003)(346002)(36756003)(2616005)(83380400001)(4326008)(186003)(316002)(6512007)(6666004)(6486002)(1076003)(8676002)(16526019)(478600001)(2906002)(52116002)(66556008)(38350700002)(86362001)(66476007)(26005)(5660300002)(38100700002)(956004)(66946007)(8936002)(6506007)(107886003)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Cwyp0HBsjc+v2FHqpwI1Cvi8ItcnnvJIg9Ec50FOPtlvX4x3yHJH9M/ihjC0?=
 =?us-ascii?Q?pMHWBVSZcbg69PQ1CyewftfqvxiYpnBDzHuRqk+f8yeD27E3XaewlqAMw2Pq?=
 =?us-ascii?Q?3JaNX1+IG1j/3bJwkQXqf1KwB2rUB2yeKus/17yoE9MhUN6Cz7R/OlBTf69B?=
 =?us-ascii?Q?vOYwQ5ck8o4zb24Cgy2DXcdWy+WzHbor+qegkoqgTehosVmutbqFndEG1lhc?=
 =?us-ascii?Q?zwX/mCf51xN5yfZWo+QZP7ZlLZ6LzEvjibgPBxNCOek7YVzpw3xbBKu62grl?=
 =?us-ascii?Q?bITQPIb6l5WvhPJJL9uaUa0ro29mNYz/QP9kGH6YeU+TlbtTn/60WXm7dFU2?=
 =?us-ascii?Q?4Q7DmEIZ3678U44WY/IEamig2CQfStmVAm0SU4vQ3bot/jMfhMevtgI5z+uo?=
 =?us-ascii?Q?FMnXXwYt9aPd5fEGwl3OlU+lNUvoQbEIs2NOFFBcoCnN6l26aMs2NmFptTsV?=
 =?us-ascii?Q?LzNf8ckxiU6XDyUJhAiaUZE02oDoZlg3SkOJZhUVMzy2pb2Y8tOgfVCDzYUs?=
 =?us-ascii?Q?uGjtQV4n84+jgD99shRGqso6zd51qoVKRY2tkhv1/t5yVaFUWCQ4H5l7acZm?=
 =?us-ascii?Q?s9LDT4IemvV79+Q6GKg6VjKBkG8VAzrCnRzbk2BPjoC8Z+ntux5N7WJ5w996?=
 =?us-ascii?Q?oyYCaS0d/B5J/MmKzsESs3ZwmBMHku90Ho0gkql2n1SPL4Yo/ugvgeL71xDf?=
 =?us-ascii?Q?ZQl5zikcm3v/Y99tIaX1Ot+72q9cHaZ02cL6az042hR8WUJfIzCNcNIw62SE?=
 =?us-ascii?Q?ePG6vaq7i4g7gyBI30Xq3YLbfUA5IE+btNTmwq6O+19PsGNk/3v29sK1Mulx?=
 =?us-ascii?Q?c6JMT+tTm13m92UWrRVs9VtJPGMd6NqUolLudxqDnjGO3I/Y7XsDoTou079f?=
 =?us-ascii?Q?J4TqskeThXe1JKugxEXzS1eTgh2R2u+ezWx5EusScAnmfbCtdzXjMSsiLO5H?=
 =?us-ascii?Q?2qbqsLaiLACbphYzH4TWqrxB94NJ5XyM/6SLVL9LJ1rMikNpnjd1ryfj+0I5?=
 =?us-ascii?Q?YN79wfy9AZqNYVg0LU1tquUBR/YTiX+WPPZA0wbGB3FKe+a9SCuyQk8/TJS1?=
 =?us-ascii?Q?t/ABONR8jIIlHsxsjaxaMGznNH5soCBdKxL0N2MaNszOOUDdhD/68clA+BVf?=
 =?us-ascii?Q?9Zmp6x/PwTAxOWIlNgsXLw7QEMDSCH5IWJQzra7dSt46kvHBNPWGajveV+B4?=
 =?us-ascii?Q?QqXa8jtv6nMjeWWNTn0I+V8LcIJvVJjcYfjwcYFIL2Ji/FteLIwTwqDoaQb8?=
 =?us-ascii?Q?5G32hpaRe4MWit2P7nEeIYapNcNvOoCDI5IIocvdc2weSMG0YBk1Ub1/506K?=
 =?us-ascii?Q?AhPWQFQsL9/peE9qUnZ3bfft?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa303427-5ea2-4b41-79f2-08d91fa7c70f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 18:06:11.1024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SWhzxd53zRNFYNFax7DefvO5+VBm58jCbCVuATghf/9JcF5lrzwR5g781nLpdxcpeFLE9/+LbSE7aeOq5q17VlSDhlzaBnNA2c+PO9Q6kJ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4639
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250111
X-Proofpoint-GUID: Wl7tpj7NeluM9ThkvHN6nLrXSTupJpOe
X-Proofpoint-ORIG-GUID: Wl7tpj7NeluM9ThkvHN6nLrXSTupJpOe
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is just a prep patch. It moves the worker related fields to a new
vhost_worker struct and moves the code around to create some helpers that
will be used in the next patches.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/vhost.c | 94 +++++++++++++++++++++++++++++--------------
 drivers/vhost/vhost.h |  9 ++++-
 2 files changed, 70 insertions(+), 33 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index b9e853e6094d..0cd19b1a832e 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -263,8 +263,8 @@ void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work)
 		 * sure it was not in the list.
 		 * test_and_set_bit() implies a memory barrier.
 		 */
-		llist_add(&work->node, &dev->work_list);
-		wake_up_process(dev->worker);
+		llist_add(&work->node, &dev->worker->work_list);
+		wake_up_process(dev->worker->task);
 	}
 }
 EXPORT_SYMBOL_GPL(vhost_work_queue);
@@ -272,7 +272,7 @@ EXPORT_SYMBOL_GPL(vhost_work_queue);
 /* A lockless hint for busy polling code to exit the loop */
 bool vhost_has_work(struct vhost_dev *dev)
 {
-	return !llist_empty(&dev->work_list);
+	return dev->worker && !llist_empty(&dev->worker->work_list);
 }
 EXPORT_SYMBOL_GPL(vhost_has_work);
 
@@ -343,7 +343,8 @@ static void vhost_vq_reset(struct vhost_dev *dev,
 
 static int vhost_worker(void *data)
 {
-	struct vhost_dev *dev = data;
+	struct vhost_worker *worker = data;
+	struct vhost_dev *dev = worker->dev;
 	struct vhost_work *work, *work_next;
 	struct llist_node *node;
 
@@ -358,7 +359,7 @@ static int vhost_worker(void *data)
 			break;
 		}
 
-		node = llist_del_all(&dev->work_list);
+		node = llist_del_all(&worker->work_list);
 		if (!node)
 			schedule();
 
@@ -487,7 +488,6 @@ void vhost_dev_init(struct vhost_dev *dev,
 	dev->byte_weight = byte_weight;
 	dev->use_worker = use_worker;
 	dev->msg_handler = msg_handler;
-	init_llist_head(&dev->work_list);
 	init_waitqueue_head(&dev->wait);
 	INIT_LIST_HEAD(&dev->read_list);
 	INIT_LIST_HEAD(&dev->pending_list);
@@ -579,10 +579,59 @@ static void vhost_detach_mm(struct vhost_dev *dev)
 	dev->mm = NULL;
 }
 
+static void vhost_worker_free(struct vhost_dev *dev)
+{
+	struct vhost_worker *worker = dev->worker;
+
+	if (!worker)
+		return;
+
+	dev->worker = NULL;
+	WARN_ON(!llist_empty(&worker->work_list));
+	kthread_stop(worker->task);
+	kfree(worker);
+}
+
+static int vhost_worker_create(struct vhost_dev *dev)
+{
+	struct vhost_worker *worker;
+	struct task_struct *task;
+	int ret;
+
+	worker = kzalloc(sizeof(*worker), GFP_KERNEL);
+	if (!worker)
+		return -ENOMEM;
+
+	dev->worker = worker;
+	worker->dev = dev;
+	init_llist_head(&worker->work_list);
+
+	task = kthread_create(vhost_worker, worker, "vhost-%d", current->pid);
+	if (IS_ERR(task)) {
+		ret = PTR_ERR(task);
+		goto free_worker;
+	}
+
+	worker->task = task;
+	wake_up_process(task); /* avoid contributing to loadavg */
+
+	ret = vhost_attach_cgroups(dev);
+	if (ret)
+		goto stop_worker;
+
+	return 0;
+
+stop_worker:
+	kthread_stop(worker->task);
+free_worker:
+	kfree(worker);
+	dev->worker = NULL;
+	return ret;
+}
+
 /* Caller should have device mutex */
 long vhost_dev_set_owner(struct vhost_dev *dev)
 {
-	struct task_struct *worker;
 	int err;
 
 	/* Is there an owner already? */
@@ -595,31 +644,18 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
 
 	dev->kcov_handle = kcov_common_handle();
 	if (dev->use_worker) {
-		worker = kthread_create(vhost_worker, dev,
-					"vhost-%d", current->pid);
-		if (IS_ERR(worker)) {
-			err = PTR_ERR(worker);
-			goto err_worker;
-		}
-
-		dev->worker = worker;
-		wake_up_process(worker); /* avoid contributing to loadavg */
-
-		err = vhost_attach_cgroups(dev);
+		err = vhost_worker_create(dev);
 		if (err)
-			goto err_cgroup;
+			goto err_worker;
 	}
 
 	err = vhost_dev_alloc_iovecs(dev);
 	if (err)
-		goto err_cgroup;
+		goto err_iovecs;
 
 	return 0;
-err_cgroup:
-	if (dev->worker) {
-		kthread_stop(dev->worker);
-		dev->worker = NULL;
-	}
+err_iovecs:
+	vhost_worker_free(dev);
 err_worker:
 	vhost_detach_mm(dev);
 	dev->kcov_handle = 0;
@@ -712,13 +748,9 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
 	dev->iotlb = NULL;
 	vhost_clear_msg(dev);
 	wake_up_interruptible_poll(&dev->wait, EPOLLIN | EPOLLRDNORM);
-	WARN_ON(!llist_empty(&dev->work_list));
-	if (dev->worker) {
-		kthread_stop(dev->worker);
-		dev->worker = NULL;
-		dev->kcov_handle = 0;
-	}
+	vhost_worker_free(dev);
 	vhost_detach_mm(dev);
+	dev->kcov_handle = 0;
 }
 EXPORT_SYMBOL_GPL(vhost_dev_cleanup);
 
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 7d5306d1229d..bfc4563e612f 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -25,6 +25,12 @@ struct vhost_work {
 	unsigned long		flags;
 };
 
+struct vhost_worker {
+	struct task_struct	*task;
+	struct llist_head	work_list;
+	struct vhost_dev	*dev;
+};
+
 /* Poll a file (eventfd or socket) */
 /* Note: there's nothing vhost specific about this structure. */
 struct vhost_poll {
@@ -149,8 +155,7 @@ struct vhost_dev {
 	struct vhost_virtqueue **vqs;
 	int nvqs;
 	struct eventfd_ctx *log_ctx;
-	struct llist_head work_list;
-	struct task_struct *worker;
+	struct vhost_worker *worker;
 	struct vhost_iotlb *umem;
 	struct vhost_iotlb *iotlb;
 	spinlock_t iotlb_lock;
-- 
2.25.1

