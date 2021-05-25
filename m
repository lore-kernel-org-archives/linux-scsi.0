Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21F64C2B9F8
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:06:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07E0A60234
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:06:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232539AbhEYSII (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 14:08:08 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:39854 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232231AbhEYSIC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 14:08:02 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PI5ee1110747;
        Tue, 25 May 2021 18:06:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=fOauqFxTvnnDuWkdAM9Xn9ghBtvojat93NonAZx9odw=;
 b=Pi/ZmEzzDbiZ1JI5JbZH5BBd5ZE6Q7kLuG/+9WGQlxSMscVzhz8NZAQlA/XNM6joRHuS
 8L4hzlVqR7TLveKQajl7wjXmDT0tHuoilRUYjDLNOriXDgjkqBT676EcSnJzNnDEo0s0
 qGJlpuGJPeQ3QH3HgdTNsbYJEzYU+p7aqrqveEjes+23cjQB0zm16vO1q0yvxgwS9IIp
 9S6BjVw84gjxPkwxX7MeTr9jk8I23SWw1bn/3LJLj56/IfkNC9aa/n1AeMYjgMmI1plf
 xYuT8mHPYvpwIPnz5nTxMAkXsNvVxug1bOmDULWgCEHUxN+a3hro5Qe97AskhVpcCV99 xg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 38pqfcexw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:06:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PI5GM4084737;
        Tue, 25 May 2021 18:06:28 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2041.outbound.protection.outlook.com [104.47.56.41])
        by userp3030.oracle.com with ESMTP id 38pq2ufcpc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:06:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QLtxSRXcPvWOlfdnVe7x3DIOa7HL/ryBcUd+vRD+6JZvWriN1KVehSy8r6n4rqAwOr2h2hN/mOE8FL1iEp9wkwJbybV2/0ychDk4K6RYE30o4Jm3OqkUw8uN7ZyYRMzdQbfVqaE9TMzfJ9PPyd3uT4UsjNkVzbuvX5UZPjamsv/9+QBM+9aQvlQM22uEPTjt6kW6sq3WTSvwJISqJI357t8xeJrVIt22SpbwhTWivdpky3LtC3meEnJaViiPubjwRAslaeyleVhDdSGqrC/j1XLcfKyijOSkMsLWK11mtsglYI16O5WdtbLmwUxV8AQwoKHpvqS9POhQbQGW7uifhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fOauqFxTvnnDuWkdAM9Xn9ghBtvojat93NonAZx9odw=;
 b=fXLpoRWi1qjeEA1b9Mt+1SihxwSCAE3Nx9tn3YcfaqalFJtPPuwbegusgUbquNApf2GnTGPfEZTwiT5Yk3k1xQB03olxM3CUxbZG53K8rj+kpsBQ5AM/WxDIRP6XLG4ckj8/TMJQGXNGkHQnjDBKPQvfBGGUNe3DbAkE/9I3TjKR3vajqXeNhnQTjSEQxzrFWpOFlLfVVlL/zU8zqO1eGAvlpTl/q31RQBBWTvP4RZDwj1jqQdOCZ3zsTU7uT0r2Y9JeLzwx/8XOONkdLMNcvQHTpcAlHBQ8h/YXfoVpXHhDj7Oe3YOjEbamrSDiKQK13/EgP3UPLRFG/pf4LYfq4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fOauqFxTvnnDuWkdAM9Xn9ghBtvojat93NonAZx9odw=;
 b=QeYulF+hbWzszxyizJQvaHJjKft5X7Y0HZc1wjXlcDEbG1it8SqUWAvdr1elIOfM/3LTCAuSagrZO61qERx2av1F1M0PBusFykI4pwfdWwLYS4cB4arGZ3/y9NicKQeOm3tuZJh/dozSXckcsKIcQ3E7b2C7JgW+x9MC/t81vk0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4639.namprd10.prod.outlook.com (2603:10b6:a03:2db::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Tue, 25 May
 2021 18:06:26 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 18:06:24 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 9/9] vhost: support sharing workers across devs
Date:   Tue, 25 May 2021 13:06:00 -0500
Message-Id: <20210525180600.6349-10-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DM6PR13CA0021.namprd13.prod.outlook.com (2603:10b6:5:bc::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.12 via Frontend Transport; Tue, 25 May 2021 18:06:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3cd7630d-6ce2-4efc-e994-08d91fa7cf1d
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4639:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4639B93D6B3342F72F2A981BF1259@SJ0PR10MB4639.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l7qIYOpT82bZRVsnkGV4ZcH2YHARBVC1Pz33fazUi9kKFvRXZiTCEL/bQn+PedVJr8BrO5UmikPZjocXZ9LoiERxLjBD9hGcSpvNMAZXBpojcbrqCab4ecKSJC6Uetzu9c3uWlTfAyDmYOCNmBLi2Zuyl7h3TyVYkqy7RkXpaxpuYNhiLI4U+yVLf5lCW0d/teKPuUpHcb8PXZp9yQFE1JkXX5fHkeoXfNBZ9Nev4nBsnUOY3dqSNRZaczUgHmgAfmr9FcVWHarWGTBNkq3FxIITR89qDpmFIYkuuiXF2TDaqyBViijltdGBv2w1vgJkl5cPc9QynD1V+tva5mcjEB+slitamZEoZVdRJFxPPNfG2ifzAWw/menVdjUhIKkx+GH+gib5TgmHAMU479Xew/Z767LwXBOlCSJcGfkvSrUzXqEDp3rqm3lwHG2jHjRZ4vCgvApdeQAYoDHFIAP7BfhtU6g/I3yeS2WvD+IB2w+LEiHkzDTzNExNuXwJrNuBtwtEjyeQHpqoH1skKcH7g9hgLWsRENLVEPVXLryJfWY6lcWIlcj3UPYSrkEHxWPSTTGY0iZXjT/M7chujoUx+4WqOiWYG803jZJ4xqUOhFDthDWBUTJCE6hlAP9qrgX/m+FK5ttBvlWj/bx5a7FUMpXIuv+FsVxyaFxLjujgyJI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(376002)(366004)(136003)(346002)(36756003)(2616005)(83380400001)(4326008)(186003)(316002)(6512007)(6666004)(6486002)(1076003)(8676002)(16526019)(478600001)(2906002)(52116002)(66556008)(38350700002)(86362001)(66476007)(26005)(5660300002)(38100700002)(956004)(66946007)(8936002)(6506007)(107886003)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?uE11UUqXKVNHZyp7fxTSddCO30THPAklTVEYDbXKp1fRyfven2o+10inr6EY?=
 =?us-ascii?Q?FZArKPu/23yb+pQDXCxP1HipUe3MMH2mR11r1KPgNWcslHbOr+1Jd8KEG3/F?=
 =?us-ascii?Q?fngoF3G8Hanj1Rnc0SNU0UiOGh9/BoEY4G1kGVcPC/Jww0Slfm+4USxwqOGT?=
 =?us-ascii?Q?BSq7tmFDpUAN6RdHt8yQMqJHLToqE+sgFGI79iB+rzZ+RzjdsbTV9tK6huBd?=
 =?us-ascii?Q?4nEx6U68dlpoqwSQ4YWJcKePPGV4M36WfurSHrc1Luw9ypuQ3xn+0bdNcWgX?=
 =?us-ascii?Q?tsEv95KIJ7Kh5I8jwV4/0hyvljrNzhCxkLwMkz0FCH1nuGm14QCoSWW39fj9?=
 =?us-ascii?Q?F1xniXw2QQCpIINNwVvLdsgU2CTjX7ctifc8c8l4UwGYfj4PYrbiH7UaKKXB?=
 =?us-ascii?Q?TIGUAdt1j/oEWxqmXKOVdaBcsLaPItOUgXTI8amJQuadClReS73NbMYPYkKz?=
 =?us-ascii?Q?6teoZzQPTHYmxupep1ufRs7LLuCb9bng0IzKkPxgpFQ46PXXe6mNikdot6/Z?=
 =?us-ascii?Q?DoO1uIkF/iAFMLa0LjQ1H3InkS5cdiom8t7heg2EKiiHbmbhbuUA4/P7zf3n?=
 =?us-ascii?Q?Cxgtbsu8AS/uNlghuAbTXuVVU8/ky4TUGGxrrDMfvawvB3o6/HOp0JyV2ppg?=
 =?us-ascii?Q?dBiNC57irp2EiUBTR+ncQOwv7TYG7PhlpVqYa9cvfOjH/AhMyN0b0iXf+wGK?=
 =?us-ascii?Q?lvOKt4Fylf9jl2u3/X7CElT9dLvIU57xDy+/UHuLj/0J3rNFyInm1MxDQsEg?=
 =?us-ascii?Q?l3awWlPY4XY2/Iy7pndcYHTqw9XVp7erRKcP6cgs4dmG0+5o+850UevCZNRg?=
 =?us-ascii?Q?lmtPhLpjWTPHBRxEk7bST1841tsYWzzvb3exBy2w3wbj8pRY/gk7GmfToytq?=
 =?us-ascii?Q?NPJGD/w9LXr7V3hF/HX8s0p4gB4QOTeA/Ziof4lN3W4SvERwZyhp+b9MsDMD?=
 =?us-ascii?Q?jQBTeZ2gW6O2YqlEoZBM1KR5NIxuB5FQg3+y3Z8k0UeDzeboekzBiMMpAN1I?=
 =?us-ascii?Q?HQEC/xuSBzQOjjN0Xqml8CJZxIjJkxGLbXl10EeoZkH0+wwGpfCwfpVq9rDH?=
 =?us-ascii?Q?6WrnVMUETx0JGO0GKUShTv/mA+ezGwMXUSeaYZngpE6PCXt1b84bdPXNfYD8?=
 =?us-ascii?Q?f3zRtnoXfgY9GkUNo5nsB2Hsc5TNL2NCMx0wynYaw86Ye0SSXUgMrgDexf6P?=
 =?us-ascii?Q?5PAY4wNLQ3SAGiy40ST0PzwK45+RSCa8i7N81E3ALTgVvzxZ6eDB6WFN6mbC?=
 =?us-ascii?Q?+dFbKQBrixtiBJnJ/cS4R9Uc3LgUuERzpuBMSWIsuoH6MiheOZs4/j+IVEOL?=
 =?us-ascii?Q?QMNl6I5L6dAAyw9qXEg8Qnge?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cd7630d-6ce2-4efc-e994-08d91fa7cf1d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 18:06:24.6348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CuKOjWUpTFJ3kRzkscYCoBGlJgccNVyD2ibf9JWxfwj93HPSG12HFkB0W4mrToNGPAToVKqiAvh9J7SXZJufDJlN76f3cVzvuHQGsuA9tCs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4639
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250111
X-Proofpoint-ORIG-GUID: Z6oNXHcwliieyGRFX3SY4ajHLBPo3uaD
X-Proofpoint-GUID: Z6oNXHcwliieyGRFX3SY4ajHLBPo3uaD
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This allows a worker to handle multiple device's vqs.

TODO:
- The worker is attached to the cgroup of the device that created it. In
this patch you can share workers with devices with different owners which
could be in different cgroups. Do we want to restict sharing workers with
devices that have the same owner (dev->mm value)?

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/vhost.c | 16 +++++++---------
 drivers/vhost/vhost.h |  1 -
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index eb16eb2bbee0..c32f72b1901c 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -388,12 +388,10 @@ static void vhost_vq_reset(struct vhost_dev *dev,
 static int vhost_worker(void *data)
 {
 	struct vhost_worker *worker = data;
-	struct vhost_dev *dev = worker->dev;
 	struct vhost_work *work, *work_next;
+	struct vhost_dev *dev;
 	struct llist_node *node;
 
-	kthread_use_mm(dev->mm);
-
 	for (;;) {
 		/* mb paired w/ kthread_stop */
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -412,15 +410,20 @@ static int vhost_worker(void *data)
 		smp_wmb();
 		llist_for_each_entry_safe(work, work_next, node, node) {
 			clear_bit(VHOST_WORK_QUEUED, &work->flags);
+			dev = work->dev;
+
+			kthread_use_mm(dev->mm);
+
 			__set_current_state(TASK_RUNNING);
 			kcov_remote_start_common(dev->kcov_handle);
 			work->fn(work);
 			kcov_remote_stop();
 			if (need_resched())
 				schedule();
+
+			kthread_unuse_mm(dev->mm);
 		}
 	}
-	kthread_unuse_mm(dev->mm);
 	return 0;
 }
 
@@ -667,7 +670,6 @@ static struct vhost_worker *vhost_worker_create(struct vhost_dev *dev)
 		return NULL;
 
 	worker->id = dev->num_workers;
-	worker->dev = dev;
 	init_llist_head(&worker->work_list);
 	INIT_HLIST_NODE(&worker->h_node);
 	refcount_set(&worker->refcount, 1);
@@ -702,10 +704,6 @@ static struct vhost_worker *vhost_worker_find(struct vhost_dev *dev, pid_t pid)
 	spin_lock(&vhost_workers_lock);
 	hash_for_each_possible(vhost_workers, worker, h_node, pid) {
 		if (worker->task->pid == pid) {
-			/* tmp - next patch allows sharing across devs */
-			if (worker->dev != dev)
-				break;
-
 			found_worker = worker;
 			refcount_inc(&worker->refcount);
 			break;
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 75ad3aa5adca..40c400172a84 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -32,7 +32,6 @@ struct vhost_worker {
 	struct llist_head	work_list;
 	struct hlist_node	h_node;
 	refcount_t		refcount;
-	struct vhost_dev	*dev;
 	int			id;
 };
 
-- 
2.25.1

