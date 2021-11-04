Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E14C1C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 19:05:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC1FD61157
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 19:05:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234247AbhKDTIU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Nov 2021 15:08:20 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:38160 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234227AbhKDTID (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2021 15:08:03 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A4IWIBA001562;
        Thu, 4 Nov 2021 19:05:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=n1E7o68yNwWUlvCj0ZVoARYR497MCigAHBDlATsxRNc=;
 b=Q6f3/NdL0pk7T2ZXvuNUIoToSmQ2n187SzAhtoaSoqJzT7zBk6mQvSDXYjy6xA7x+EfQ
 pNucgBoE0uO/wGxdJqJD/yWjWfNJK7lZWfMGRwLq9AHNi5PFOE+WDvnkIOdzMVpI255h
 DQu10KFc+1fKQuQkawWsK+widmqaPiwFrCwyMkAi3ofeJRzjBs4PgS2d7Dk0Onwn+IPd
 mwKjDP1QPG/pwdlEG1Nt+m+JD9Iox/HqeRvnsFG2UKlaENoh44qsbyO6hDXG32TMOcwH
 pwvXsNQQvv9o5kQVT5fDFZpOirimO+MlcEG0SFtGMZmv6kWvU1tWEv7siecvJFDBqS+s tA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c3n8p9u8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 19:05:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A4J0PIp122897;
        Thu, 4 Nov 2021 19:05:20 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by userp3020.oracle.com with ESMTP id 3c1khxpeas-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 19:05:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FaS+30Yyi7e1I+ffiXkGpmqyqRtE9dH27Usf9Qhlvv8uT2pzR5CVaiJ+4A+FHMGA7awQzFkhb16ni4jmdkNP8zYx3amITQpjvqM7RFvQpnA5L0hrGEEQbxlNlphxOLotX0O+sH9Bixt5wHgSJSwRn+fnQYVgZ8XK5AWhJsyMPJcUIAQx0YOXiaDVG4984kb3rkejvVmYX5L7bFof7QJmBUjR0lIzn2HfLk5QxhNWc/hJc9VCJbvv81JVok3EI3Z9hmkfkZCMt0n5Oq2Zn3mXRyjUKBCPwZZ/zgkfkT+Jzd6y9FTklmERBn3Dv8O6q6ARiWA2lGNReC8sztac4im1BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n1E7o68yNwWUlvCj0ZVoARYR497MCigAHBDlATsxRNc=;
 b=FhttiOmxJLD4Xnm8Ee0cZnCNAETU5AjpwuUjvDxKEcu+y5qkdXKxiZS34Bt0Tu42JZtKuI1nGVdBYSeXMfHdNoZT5V9X2JL7Q56I3uu26yLP6t22bx1bSoLZtTqWWEelBwGoV9KWWvEq3Oaefm0ps3kGysqR77n8z3I5inIhJt42z31w2ZwZRSjSVHGQfzB4lKQ9QrsYYR4+HlS/BpKL/GawLQSvzgR2wzPfuZdTM6VtOLBXft9PR2D1HzlZ2J7022qkzaDBlyFSxv+vaa4CFvgHSXNDdcAHj/8eaaR0v6KPwz8ieE3hDPrHPcpMTCOqeKF2MCkXn79YrvZum/Jodg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n1E7o68yNwWUlvCj0ZVoARYR497MCigAHBDlATsxRNc=;
 b=aorLc7iGFir5BKIlTvKeSW/2YhVQsqPOB/m4hEA1qB30I91/xdmgFejA5CgWTdch5Gx0VZl9OZcMlBW6WtYnbTO6QfsxHSbQ/0OjbVP4wYJYd8qyyPjmCDzqZX6fjeDhBRcO3Kuwltl0qr0xOoqf1/PXfNNAdXdwBYRdH83eOMY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB2873.namprd10.prod.outlook.com (2603:10b6:5:63::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4649.15; Thu, 4 Nov 2021 19:05:15 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041%11]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 19:05:15 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V4 11/12] vhost: allow userspace to create workers
Date:   Thu,  4 Nov 2021 14:05:01 -0500
Message-Id: <20211104190502.7053-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211104190502.7053-1-michael.christie@oracle.com>
References: <20211104190502.7053-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR07CA0080.namprd07.prod.outlook.com
 (2603:10b6:4:ad::45) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DM5PR07CA0080.namprd07.prod.outlook.com (2603:10b6:4:ad::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Thu, 4 Nov 2021 19:05:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1bc47b5f-039d-45d9-6bc9-08d99fc608fc
X-MS-TrafficTypeDiagnostic: DM6PR10MB2873:
X-Microsoft-Antispam-PRVS: <DM6PR10MB28736D552AEDE2BCA33D4D96F18D9@DM6PR10MB2873.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:972;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JoufT448qiPw4sM4/hm09H21Tqzs1RBnbiMq282NZ9iUmwye78RQJqkC6GoJmXYh3/q9npmSardNIHVJ0p5SVwlvw1Nv3ghLZ1k3YLyAou6weVjjiiCsQ2qdKMVZakMB1mftIenBoD69MvzWdDNkJ4roRsqFYF4ffCmpNlY6ojR5CY2ql5C/NZZDyqXyjkyl+fOA8kZMhJd2lQ5WKWCaOsoLSCV7TR3kGjFkgDo3rlozhkSJSBV/DR139HXWATEiRoKZmb+SfHJvysd1lnHE5MmkGXl1nUA1cCPQfBc8fOst7lwtoF7IueHRG6yHTltA54eqFsiXzzSSzOZfQbA37jOrCsKmqmgqcvFXobBK0w7tsHxM1St0VqpT38kzStPWqdm3c6VhyvNSL+i0d1uDsIXKmj7NHiWszXi0SnHkW1ekCjj80JmXuY78YD4Pg34jm2M/iNkEovvg9wIsMZQ3TbSLvgMZBINR2K28vlbraZWWu3aT5QUN4/k5ugB9DX4mVwcGYF1i9i+UyR66IGYvkJgsFyFePBNQjRHJesjcGwrkFRDheVfVhu8F5eed8Z5mWkn6nF3T3FbA4a0IRlNx/+wZPrZuX7KYVXy5AaBrXHrr4IyZJxTIS0jxZLHrVOZ2MQeMTsujkYr1nilpw52SHKj9H3Mjnm9xUPZaLiQAhusyWSNq16o9TlIEBYH3WOD/A8ROiaP3wVKliTg+hwlLjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(8676002)(52116002)(6512007)(66556008)(66476007)(6506007)(26005)(66946007)(38100700002)(38350700002)(4326008)(186003)(36756003)(1076003)(30864003)(86362001)(8936002)(83380400001)(6666004)(316002)(508600001)(956004)(6486002)(2616005)(2906002)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xKxTxA9LElXK/QD2RtYvLZlSlmVLyu2MDrKdRtcZ548+Vj5hQe3QzghO9XC6?=
 =?us-ascii?Q?e8hSEy8DPOQLZOqAjiWF/8EhNey4QSAkcPPRr4STwo46dshXCR3reLjOGAbo?=
 =?us-ascii?Q?o9y2crCglO/ClP5wVh5WbowzOTOMAAY22gKKaqP94Q/nRwP4haKrkeOFmYGQ?=
 =?us-ascii?Q?h1MLCjCuvlbNqot6D5AMFXDZ6OE34wsB3oNttvi8IX1AVSLZc/9DXX1iRH2U?=
 =?us-ascii?Q?y2dBFUIHvTjOHOSP7g/C/fv07CPvJa1VhyWMJZuw4d/4I5zDBN3j559JzLhH?=
 =?us-ascii?Q?H8GnAgxkD3hVBY5FMKjQL/U/AG5QmxpkQcMWg1qaar9oKWI38Qehf7kpPLgn?=
 =?us-ascii?Q?/YGH2yfGoU1JUTK6kNujYJeTRiMssTj9SnFUSKPsP/Mzy98D9/6Os5xCKA9l?=
 =?us-ascii?Q?fld1jAqEKyUfPEuK3NguYK3BzXPnzx5E4DnLnUajt5i9MceNjPEkSM1JTpiy?=
 =?us-ascii?Q?8tCz7GkLBMS67ApJk6tjrJ19Wrc6W39HgU8xx+EUDZn44+UlJ+0u6a7F6HKY?=
 =?us-ascii?Q?ckymTXhccIalA+0qoegPNKU1vXoP9b1+q+rnPOsWPkLKF7dgk06RT2uyqsXy?=
 =?us-ascii?Q?afCIoqIimRFOYQrP1PQhpZxuze0vVmRPNvLubPB2meBujZDC9T7q9AIbEB6r?=
 =?us-ascii?Q?XyfYftj8wuv66RmToyM/IFCv00QjDZxleHPwF/BXSp8yzu4Sx4Z0ctjt8jHT?=
 =?us-ascii?Q?HKht8kMemlngClDGOKdyX3OxrFj+BM+Mu2abc1/p8Ba5tb78nD3Bl2M6Soj9?=
 =?us-ascii?Q?6RjdNWpBe7AJgGNWxwtp+t0FSP4nnj1hEe7vwBXylZSFyHArVj5eS/NP4O9h?=
 =?us-ascii?Q?2SQJ+JQBMHfAe3n+bE4LipUYkoM3MeOfqOluHJp8WhxUl3mPusvXdwkryGTt?=
 =?us-ascii?Q?R/+WLxGpM0eazyrntfULAGfOsVzCDyekdkGYKYzR8DflYY/j+QxNzWXXGdhu?=
 =?us-ascii?Q?zTNivMoJnQAzFTDg67WfnM6X7eFJNEF+FGECp5HjTw0I7M+ddyUv9oH9mlkV?=
 =?us-ascii?Q?Bq8tQB7rLIJeL1nQpKT+1daxTqh7/+E7ZGqtnayvS25JukIGZxqUqbg3t9Pl?=
 =?us-ascii?Q?+ZKLaVIjOV6ECQ2x0bKuzjg6JgMD6IaEd5/tQ+FnbuEXtBiOJ/3dJI/eQ/ll?=
 =?us-ascii?Q?IYUC3BH7nM/xwVNql/t48kVAoAekb2+4P450zcAowmk5s7seEnzATP8eqDQY?=
 =?us-ascii?Q?41QJ9HO05RwG9dzgdCcqBcsJDuWKv/ZZnVzWizxeqXFBWv4KBszfXyLLIF/J?=
 =?us-ascii?Q?VXOiM01nFbk1+wSzBa+R4ATIRZ+LIIJ1EK9H7WQhWlropeY2GnR3mYFO6UvY?=
 =?us-ascii?Q?oEebQQcafrzk3XZp56iL6oEOsd/fmnPWAizUUvGW6BG+ZN+G5IkEWmFgdwZo?=
 =?us-ascii?Q?vSPTSPZKm3r1IUSfY0zex56BcQiaOIhEGZXX2ulItgpw+bx8Lv3yEFppOXSr?=
 =?us-ascii?Q?cHxXAlFt6mZh5ZPg45CUNUmN+bJDHnf1e5AoA6xviih8EnI+yCRwsE2GoPZD?=
 =?us-ascii?Q?eJSzui4JTbww536gO2HJaCIbLLSBie6x6U8O694Bk9HjZAgYiEpEVKJ1RiNs?=
 =?us-ascii?Q?NiFufZDBaTWGSN/I/Zl/wZL1qQ4t3Px3PKSwUEWJYr/2lwzeDojZKd8AR6/K?=
 =?us-ascii?Q?OzcjPI/fO+7zr6vbuLbf5RZuL8r0nRj01wa6VgS+o95SahSZCTHqtUoobqxs?=
 =?us-ascii?Q?LRZjhg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bc47b5f-039d-45d9-6bc9-08d99fc608fc
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 19:05:15.4236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sVBhu+fJ3ntCKVVC5gdYJP4Carxo67Ld37rQOWm0JEtKjBAi8SvEeNd4l6GnLfltwwi4NakVmuklTsN3Jpy+vAXyTnWD1In9/W+vqw/1wN8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2873
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10158 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111040076
X-Proofpoint-ORIG-GUID: PoLMfNpGpOw93DNi12C74yfHta9P3-p1
X-Proofpoint-GUID: PoLMfNpGpOw93DNi12C74yfHta9P3-p1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch allows userspace to create workers and bind them to vqs. You
can have N workers per dev and also share N workers with M vqs.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/vhost.c            | 149 ++++++++++++++++++++++++++++---
 drivers/vhost/vhost.h            |   4 +-
 include/uapi/linux/vhost.h       |  22 +++++
 include/uapi/linux/vhost_types.h |  15 ++++
 4 files changed, 178 insertions(+), 12 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 04f43a6445e1..20bf67a846f1 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -493,7 +493,6 @@ void vhost_dev_init(struct vhost_dev *dev,
 	dev->umem = NULL;
 	dev->iotlb = NULL;
 	dev->mm = NULL;
-	dev->worker = NULL;
 	dev->iov_limit = iov_limit;
 	dev->weight = weight;
 	dev->byte_weight = byte_weight;
@@ -503,6 +502,7 @@ void vhost_dev_init(struct vhost_dev *dev,
 	INIT_LIST_HEAD(&dev->read_list);
 	INIT_LIST_HEAD(&dev->pending_list);
 	spin_lock_init(&dev->iotlb_lock);
+	idr_init(&dev->worker_idr);
 
 
 	for (i = 0; i < dev->nvqs; ++i) {
@@ -576,31 +576,59 @@ static void vhost_worker_stop(struct vhost_worker *worker)
 	wait_for_completion(worker->exit_done);
 }
 
-static void vhost_worker_free(struct vhost_dev *dev)
+static void vhost_worker_put(struct vhost_dev *dev, struct vhost_worker *worker)
 {
-	struct vhost_worker *worker = dev->worker;
-
 	if (!worker)
 		return;
 
-	dev->worker = NULL;
+	if (!refcount_dec_and_test(&worker->refcount))
+		return;
+
 	WARN_ON(!llist_empty(&worker->work_list));
 	vhost_worker_stop(worker);
+	idr_remove(&dev->worker_idr, worker->id);
 	kfree(worker);
 }
 
+static void vhost_vq_detach_worker(struct vhost_virtqueue *vq)
+{
+	if (vq->worker)
+		vhost_worker_put(vq->dev, vq->worker);
+	vq->worker = NULL;
+}
+
+static int vhost_workers_idr_iter(int id, void *worker, void *dev)
+{
+	vhost_worker_put(dev, worker);
+	return 0;
+}
+
+static void vhost_workers_free(struct vhost_dev *dev)
+{
+	int i;
+
+	if (!dev->use_worker)
+		return;
+
+	for (i = 0; i < dev->nvqs; i++)
+		vhost_vq_detach_worker(dev->vqs[i]);
+
+	idr_for_each(&dev->worker_idr, vhost_workers_idr_iter, dev);
+}
+
 static struct vhost_worker *vhost_worker_create(struct vhost_dev *dev)
 {
 	struct vhost_worker *worker;
 	struct task_struct *task;
+	int id;
 
 	worker = kzalloc(sizeof(*worker), GFP_KERNEL_ACCOUNT);
 	if (!worker)
 		return NULL;
 
-	dev->worker = worker;
 	worker->kcov_handle = kcov_common_handle();
 	init_llist_head(&worker->work_list);
+	refcount_set(&worker->refcount, 1);
 
 	/*
 	 * vhost used to use the kthread API which ignores all signals by
@@ -613,14 +641,88 @@ static struct vhost_worker *vhost_worker_create(struct vhost_dev *dev)
 
 	worker->task = task;
 	kernel_worker_start(task, "vhost-%d", current->pid);
+
+	/* idr accesses are done under the vhost_dev mutex */
+	id = idr_alloc(&dev->worker_idr, worker, 0, INT_MAX, GFP_KERNEL);
+	if (id < 0)
+		goto stop_worker;
+	worker->id = id;
+
 	return worker;
 
+stop_worker:
+	vhost_worker_stop(worker);
 free_worker:
 	kfree(worker);
-	dev->worker = NULL;
 	return NULL;
 }
 
+/* Caller must have device mutex */
+static int vhost_vq_attach_worker(struct vhost_virtqueue *vq,
+				  struct vhost_vring_worker *info)
+{
+	struct vhost_dev *dev = vq->dev;
+	struct vhost_worker *worker;
+
+	if (!dev->use_worker)
+		return -EINVAL;
+
+	/* We don't support setting a worker on an active vq */
+	if (vq->private_data)
+		return -EBUSY;
+
+	worker = idr_find(&dev->worker_idr, info->worker_id);
+	if (!worker)
+		return -ENODEV;
+
+	refcount_inc(&worker->refcount);
+
+	vhost_vq_detach_worker(vq);
+	vq->worker = worker;
+	return 0;
+}
+
+/* Caller must have device mutex */
+static int vhost_new_worker(struct vhost_dev *dev,
+			    struct vhost_worker_state *info)
+{
+	struct vhost_worker *worker;
+
+	if (!dev->use_worker)
+		return -EINVAL;
+
+	worker = vhost_worker_create(dev);
+	if (!worker)
+		return -ENOMEM;
+
+	info->worker_id = worker->id;
+	return 0;
+}
+
+/* Caller must have device mutex */
+static int vhost_free_worker(struct vhost_dev *dev,
+			     struct vhost_worker_state *info)
+{
+	struct vhost_worker *worker;
+
+	if (!dev->use_worker)
+		return -EINVAL;
+
+	worker = idr_find(&dev->worker_idr, info->worker_id);
+	if (!worker)
+		return -ENODEV;
+
+	/*
+	 * We can free the worker if there are no attached vqs and we only
+	 * have the refcount from the initial creation.
+	 */
+	if (refcount_read(&worker->refcount) != 1)
+		return -EBUSY;
+
+	vhost_worker_put(dev, worker);
+	return 0;
+}
+
 /* Caller should have device mutex */
 long vhost_dev_set_owner(struct vhost_dev *dev)
 {
@@ -640,8 +742,10 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
 		if (!worker)
 			goto err_worker;
 
-		for (i = 0; i < dev->nvqs; i++)
+		for (i = 0; i < dev->nvqs; i++) {
+			refcount_inc(&worker->refcount);
 			dev->vqs[i]->worker = worker;
+		}
 	}
 
 	err = vhost_dev_alloc_iovecs(dev);
@@ -650,7 +754,7 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
 
 	return 0;
 err_iovecs:
-	vhost_worker_free(dev);
+	vhost_workers_free(dev);
 err_worker:
 	vhost_detach_mm(dev);
 err_mm:
@@ -742,7 +846,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
 	dev->iotlb = NULL;
 	vhost_clear_msg(dev);
 	wake_up_interruptible_poll(&dev->wait, EPOLLIN | EPOLLRDNORM);
-	vhost_worker_free(dev);
+	vhost_workers_free(dev);
 	vhost_detach_mm(dev);
 }
 EXPORT_SYMBOL_GPL(vhost_dev_cleanup);
@@ -1612,6 +1716,7 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 	struct eventfd_ctx *ctx = NULL;
 	u32 __user *idxp = argp;
 	struct vhost_virtqueue *vq;
+	struct vhost_vring_worker w;
 	struct vhost_vring_state s;
 	struct vhost_vring_file f;
 	u32 idx;
@@ -1719,7 +1824,16 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 		if (copy_to_user(argp, &s, sizeof(s)))
 			r = -EFAULT;
 		break;
-	default:
+	case VHOST_ATTACH_VRING_WORKER:
+		if (copy_from_user(&w, argp, sizeof(w))) {
+			r = -EFAULT;
+			break;
+		}
+		r = vhost_vq_attach_worker(vq, &w);
+		if (!r && copy_to_user(argp, &w, sizeof(w)))
+			r = -EFAULT;
+		break;
+default:
 		r = -ENOIOCTLCMD;
 	}
 
@@ -1772,6 +1886,7 @@ EXPORT_SYMBOL_GPL(vhost_init_device_iotlb);
 /* Caller must have device mutex */
 long vhost_dev_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *argp)
 {
+	struct vhost_worker_state w;
 	struct eventfd_ctx *ctx;
 	u64 p;
 	long r;
@@ -1832,6 +1947,18 @@ long vhost_dev_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *argp)
 		if (ctx)
 			eventfd_ctx_put(ctx);
 		break;
+	case VHOST_NEW_WORKER:
+		r = vhost_new_worker(d, &w);
+		if (!r && copy_to_user(argp, &w, sizeof(w)))
+			r = -EFAULT;
+		break;
+	case VHOST_FREE_WORKER:
+		if (copy_from_user(&w, argp, sizeof(w))) {
+			r = -EFAULT;
+			break;
+		}
+		r = vhost_free_worker(d, &w);
+		break;
 	default:
 		r = -ENOIOCTLCMD;
 		break;
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 33c63b24187a..b3786e3537f1 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -35,6 +35,8 @@ struct vhost_worker {
 	struct llist_head	work_list;
 	u64			kcov_handle;
 	unsigned long		flags;
+	refcount_t		refcount;
+	int			id;
 };
 
 /* Poll a file (eventfd or socket) */
@@ -160,7 +162,6 @@ struct vhost_dev {
 	struct vhost_virtqueue **vqs;
 	int nvqs;
 	struct eventfd_ctx *log_ctx;
-	struct vhost_worker *worker;
 	struct vhost_iotlb *umem;
 	struct vhost_iotlb *iotlb;
 	spinlock_t iotlb_lock;
@@ -170,6 +171,7 @@ struct vhost_dev {
 	int iov_limit;
 	int weight;
 	int byte_weight;
+	struct idr worker_idr;
 	bool use_worker;
 	int (*msg_handler)(struct vhost_dev *dev,
 			   struct vhost_iotlb_msg *msg);
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index c998860d7bbc..117ea92b3925 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -45,6 +45,23 @@
 #define VHOST_SET_LOG_BASE _IOW(VHOST_VIRTIO, 0x04, __u64)
 /* Specify an eventfd file descriptor to signal on log write. */
 #define VHOST_SET_LOG_FD _IOW(VHOST_VIRTIO, 0x07, int)
+/* By default, a device gets one vhost_worker that its virtqueues share. This
+ * command allows the owner of the device to create an additional vhost_worker
+ * for the device. It can later be bound to 1 or more of its virtqueues using
+ * the VHOST_ATTACH_VRING_WORKER command.
+ *
+ * This must be called after VHOST_SET_OWNER and the caller must be the owner
+ * of the device. The new thread will inherit caller's cgroups and namespaces,
+ * and will share the caller's memory space. The new thread will also be
+ * counted against the caller's RLIMIT_NPROC value.
+ */
+#define VHOST_NEW_WORKER _IOW(VHOST_VIRTIO, 0x8, struct vhost_worker_state)
+/* Free a worker created with VHOST_NEW_WORKER if it's not attached to any
+ * virtqueue. If userspace is not able to call this for workers its created,
+ * the kernel will free all the device's workers when the device is closed and
+ * the last reference to the device has been released.
+ */
+#define VHOST_FREE_WORKER _IOR(VHOST_VIRTIO, 0x9, struct vhost_worker_state)
 
 /* Ring setup. */
 /* Set number of descriptors in ring. This parameter can not
@@ -70,6 +87,11 @@
 #define VHOST_VRING_BIG_ENDIAN 1
 #define VHOST_SET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x13, struct vhost_vring_state)
 #define VHOST_GET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x14, struct vhost_vring_state)
+/* Attach a vhost_worker created with VHOST_NEW_WORKER to one of the device's
+ * virtqueues. This must be done before the virtqueue is active.
+ */
+#define VHOST_ATTACH_VRING_WORKER _IOR(VHOST_VIRTIO, 0x15,		\
+				       struct vhost_vring_worker)
 
 /* The following ioctls use eventfd file descriptors to signal and poll
  * for events. */
diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhost_types.h
index f7f6a3a28977..d38a023e494f 100644
--- a/include/uapi/linux/vhost_types.h
+++ b/include/uapi/linux/vhost_types.h
@@ -47,6 +47,21 @@ struct vhost_vring_addr {
 	__u64 log_guest_addr;
 };
 
+struct vhost_worker_state {
+	/*
+	 * For VHOST_NEW_WORKER the kernel will return the new vhost_worker id.
+	 * For VHOST_FREE_WORKER this must be set to the id of the vhost_worker
+	 * to free.
+	 */
+	int worker_id;
+};
+
+struct vhost_vring_worker {
+	unsigned int index;
+	/* The id of the vhost_worker returned from VHOST_NEW_WORKER */
+	int worker_id;
+};
+
 /* no alignment requirement */
 struct vhost_iotlb_msg {
 	__u64 iova;
-- 
2.25.1

