Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA6B0C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 05:19:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D796A61215
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 05:19:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbhJVFVx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Oct 2021 01:21:53 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:37220 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229815AbhJVFVt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Oct 2021 01:21:49 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19M3QuAN008796;
        Fri, 22 Oct 2021 05:19:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=YRvGMJIr+pPdp6mOPkFreVfqZcjqlBTVExiJGCzv26c=;
 b=0QrH3RxKeIE8tA+TN0M3cL02p7yfkLCne8Mak90oyiCl4xNs85w+txENCQxsSMj3dGRB
 qBwL4dk023QfYzFpREpcH1bwglEZjCJLGqKTFzUK8yLmme8qemSKnwHj0bD38bWKLhsh
 xaQ1DtbXsaermDt+lToIt6j1y/YCxvfNO2lQwNbYHivg+e/nV0rSfrBiboqceR2r8AJV
 d40VnCI19USAO8dEJKaENC6mWHPtzuXOygJAncKSOdkK0DkTAGcQuq0yQNza7GT4JI3a
 F7vyTujiBqWodz55cosHJVmomAF4eGbsAzCQStqbkPAxpeOGKI4YfMClaGYHf8gXg1wt pw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bundfg9eb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 05:19:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19M5BHIc139141;
        Fri, 22 Oct 2021 05:19:27 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by aserp3020.oracle.com with ESMTP id 3bqpja16nf-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 05:19:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TZIwmzrmcWV2LsiAU10W1JDcq3mJkhp8t/gNPtOCroRAn1gwE0pdMfM/V66AzPy7jN3kkHgtY0StrIIdSL28kjfS218lF8+uXo8jUpFW3d17j/BZBzsP6YrjKpub+cetW0qpNCNrxEoRT68wtnHZInTjEXfpoyhe2DKBG7bGR/zUD3k7isGtrbnzf4DG/R+yVbN5jsfKClA+StCLsWeb23KvLv41m9bycshgbjgPzhGoGhNj7HIzP3ZmNqDVqLtFPWsfc/ib6xvgxTP838J3Ky55xegZvX/UNPaY3MS18bNevNhbZc/glcyfQiMNQuSHV8jHFOEwsTr7L0gLHM4Rlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YRvGMJIr+pPdp6mOPkFreVfqZcjqlBTVExiJGCzv26c=;
 b=oav701Joxivnf480gpTgtbBjTlDhA4hdd4yddPEd800FFO0XupMq/acAlMQqDtZbUYVUnmLf2wsXN1yEGWj6/0qZ2YZSMxk6JnqjI9w3XW2gby8d1CBTjkkqfED34XmOl5DD5c0RgU3HGZ15wCZKTGNWjTdOzDPksHRq/ChLnkRiR4FYOVu14vyih9VyQj1jxFemFmMBvJRBdPJx1wvbKve3YL1+7cR1VxmOTNNcpmoeXcMUMk0bMjyxaetuOA4YAC4U45uB3I5Td3aTXFTO4oDjMRdYtIoyPJMT7ZQTxE9RUdXKwenXNASd7DOhG/YntTjZd08So+R/Ldjf05IVYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YRvGMJIr+pPdp6mOPkFreVfqZcjqlBTVExiJGCzv26c=;
 b=0AxkN+3MEZEkWKJEXe+6697MLpzMcASdxJkb5DxfJY/BELDZJtoY+9hGQIVlwz8H6e9oMtrOXTn/RJpxIvkbpCTV/Ie5sGlyZ1gHUnoxbivGABvk1JMQBOP1RQ4CxXK4Do7kGGK6znEWT7U2G2FilIM39MkxOPqXS8SznDb9SJA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB4974.namprd10.prod.outlook.com (2603:10b6:5:3a0::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.16; Fri, 22 Oct 2021 05:19:25 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4628.018; Fri, 22 Oct 2021
 05:19:25 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V3 03/11] vhost: take worker or vq instead of dev for queueing
Date:   Fri, 22 Oct 2021 00:19:03 -0500
Message-Id: <20211022051911.108383-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022051911.108383-1-michael.christie@oracle.com>
References: <20211022051911.108383-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR08CA0012.namprd08.prod.outlook.com
 (2603:10b6:5:80::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DM6PR08CA0012.namprd08.prod.outlook.com (2603:10b6:5:80::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Fri, 22 Oct 2021 05:19:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f6740cf7-65e5-4f5e-e1cf-08d9951b839b
X-MS-TrafficTypeDiagnostic: DS7PR10MB4974:
X-Microsoft-Antispam-PRVS: <DS7PR10MB49745D1A6D6E55512FBC5C0AF1809@DS7PR10MB4974.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: glQgvDdCjbVh/lIiuQyz2JpXW9J+Q6SGNi4CBQ9LcCwV0sUbxYokwxptPwA/iwj7v2mLynWKe9q+9TR0UOi7P/XDy1J7rZf6WI15HgMXdog5d1k8ApqRTNf6KTDW3erPZKSydXElDuFiphzMBAYrjwkPBghIT9kHmO5iHUDP9lLHEh2M9RL035bGAP4uPLD21joJ4Er2zpHo8Z15b6RxCg67/fDd/LK3llmp0k3yDtjNSGElRKGxaXDd+B8/zip1FjttOrU+qRKaAcMpV5jViHPBGq/tMbYX2VAZYH28QyI4qJnA7gmPKvWPg9dqpdw40isLhQTZrz4I/MPA4YsRgouNdHdC7hXuwk7JVB78X2icAdfiM+lJkncohrcH+mzKnzkQ++VfuKggSIgK8Vjhzz5zYlsZjZ5N4yK+/lRL449mN0wnLfmEcqR168wgXbCIM2qJkWkBuzRMQZmgyOxDLbOsStrtfQ50xbP4uk7z5au5boYOZuMxpDxEGcRntimzbS42UTjWLKMaOGr87IPU6LcgEQEF0J1/uot5WS1Bsl02GU+EKLYGvax8cS/79o8lGj3pfuIZtvWY9iqr1zvbJxePZBvdy1y8EZMqKYOlIEbQAai1Vu6xQPXFkc23C7aX5u0RUtsLcGKcGmn36ANen4onjZPUA9RIfIL9JNPBZUiGCv9mj+0lcWCv60JXfWbUFMU1wGIZhRJ9MwwF7PXssA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(107886003)(38350700002)(66556008)(4326008)(36756003)(6666004)(1076003)(508600001)(2906002)(66476007)(66946007)(8936002)(38100700002)(316002)(6506007)(186003)(26005)(6486002)(6512007)(83380400001)(52116002)(2616005)(86362001)(5660300002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DiAcV4XjbvINRxjko3PhqAiYXptlav1wMNkZ6ZVH1MMvy41JC0ULp12C/T5/?=
 =?us-ascii?Q?VwbzcqPlazoJNF6N6oVbrvdC78JDyM9Baij17vZC6HPSsVU85Xh4xOM9ZW0W?=
 =?us-ascii?Q?cDvxHFjQUNe2WqfYQCYvwRT6UgTuU9f6cTml7Aq8WYLguiy/nv243sMxgiAo?=
 =?us-ascii?Q?rC9UhbA2Y2eRVD1MCxZyML76Ab61HCkURglS5pWWRszpzZLDki+NO6upazZx?=
 =?us-ascii?Q?8bigVKyri6E3PrA0ivuIIGGdvkZlAhBVOGIqanURHDm7X/1DBmxOCjbQY4+E?=
 =?us-ascii?Q?hhpjMdDqJscikb2dNRsy8m1jGMfsH1QPC3W3CJgEhe9RedIHXaIwG7ot3T8k?=
 =?us-ascii?Q?4zZe0QwLbNhNWFOae+7Z9zvNKqPad3eABPrOP1W8p/p2pcCmJqNpRYog5eaJ?=
 =?us-ascii?Q?KBlNjJNj5TU+p8L7MxDlN2Mx4CztytcvdXA8qqQT7Yn56CfcxawaJs+YDex0?=
 =?us-ascii?Q?QFObf8y/+6hPnnDuR2QXmhXP6rkyLJ44Sq1yDi6XCW6a7mNxkk0whRJyteVy?=
 =?us-ascii?Q?lMnDnHbhSKvXhMaSHMLm30bYMtvu8PgaEgNkeQKz3OkZuDKe4woYb9RJdTLN?=
 =?us-ascii?Q?yVd9D5NcvxKko32n/lQSre7X1G8B3dv0wBtf7IJib2rZKyqHnw0bQHmJSnjw?=
 =?us-ascii?Q?tiHBwujTmuiACvwrIfgxyK86Z4uuV3dToGKoswe6L8Fm/0NKv+8BmiqfCxru?=
 =?us-ascii?Q?islREHg/MP5H58p66sDs5AHtAYebw9Ly+mg2HfESOAZg/AWrZ2CWblq5R9gu?=
 =?us-ascii?Q?0Y5tOGORVjWHD/Ym+sG6YaDc5xgbkT/Zx6DEl6fhFb8TYei9D9TKM58c+0bq?=
 =?us-ascii?Q?ZZQ/IAHibnOJ+eJimrDTDKsnXoI0jvtzqQN2eTRS3irAhsVWDr+e7jLvQ0nb?=
 =?us-ascii?Q?C8QnfffSMlGC73hsFeO9AzyaBMNMSmt9mE4dw8pKv+Ayatp69bSX/xgpAWMG?=
 =?us-ascii?Q?mX1Dj8m2kDzTB+dI+W49l3ehEzkj2HE4bcN+qXyyRxjsnIEg4FRrM8YBKeyj?=
 =?us-ascii?Q?T22hfUYPYX478x/b09B9iG/r8U1gj+QebVr3Da9HsNqgiE2jfkbxJR+4YIMk?=
 =?us-ascii?Q?6K/bQDoxg/JAfLFqxe2AAMHXvK2SfriczKupOjWpfxUkDT+5KVD3VvXFhbMy?=
 =?us-ascii?Q?0L+FfgaDIFSFqBJXg2KAFtEJXxi/8cl1n3C76N2tNzuLqmBsWR71nDgIpL7q?=
 =?us-ascii?Q?8F7B4GQkVsEbVTLj5OtZgpgzqbD+VVuc4gju5rp2YMbO/4+GuNOpQ0cudqJO?=
 =?us-ascii?Q?SGnR02v0COB9PgHOxu7gvnDXYcX4gN4D3BTopPzAEsNBjyE9mWfIIE2aDjhX?=
 =?us-ascii?Q?a1iL+BCD0Qre3Vkuv3fFq+lJ3WUickuad2qrGRmzA3GWHjsK9wI6DI+f6e2F?=
 =?us-ascii?Q?cn498ChjOAyLn0zgBlEN0nfPoc9LPoq+2UBc0m38V73RG6iYnRgr6W1gCRed?=
 =?us-ascii?Q?J9LfMcKxUy8/hnEiOY3DYuv8pxScv5Xr?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6740cf7-65e5-4f5e-e1cf-08d9951b839b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 05:19:25.5811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: michael.christie@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4974
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10144 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110220028
X-Proofpoint-ORIG-GUID: kwZNJUP-0EgNH715__dRMsub7vcuaZYH
X-Proofpoint-GUID: kwZNJUP-0EgNH715__dRMsub7vcuaZYH
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch has the core work queueing function take a worker for when we
support multiple workers. It also adds a helper that takes a vq during
queueing so modules can control which vq/worker to queue work on.

This temp leaves vhost_work_queue. It will be removed when the drivers
are converted in the next patches.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/vhost.c | 44 +++++++++++++++++++++++++++----------------
 drivers/vhost/vhost.h |  1 +
 2 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index f6bfa1c481df..f2c6981297d0 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -230,6 +230,34 @@ void vhost_poll_stop(struct vhost_poll *poll)
 }
 EXPORT_SYMBOL_GPL(vhost_poll_stop);
 
+static void vhost_work_queue_on(struct vhost_worker *worker,
+				struct vhost_work *work)
+{
+	if (!worker)
+		return;
+
+	if (!test_and_set_bit(VHOST_WORK_QUEUED, &work->flags)) {
+		/* We can only add the work to the list after we're
+		 * sure it was not in the list.
+		 * test_and_set_bit() implies a memory barrier.
+		 */
+		llist_add(&work->node, &worker->work_list);
+		wake_up_process(worker->task);
+	}
+}
+
+void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work)
+{
+	vhost_work_queue_on(dev->worker, work);
+}
+EXPORT_SYMBOL_GPL(vhost_work_queue);
+
+void vhost_vq_work_queue(struct vhost_virtqueue *vq, struct vhost_work *work)
+{
+	vhost_work_queue_on(vq->worker, work);
+}
+EXPORT_SYMBOL_GPL(vhost_vq_work_queue);
+
 void vhost_work_dev_flush(struct vhost_dev *dev)
 {
 	struct vhost_flush_struct flush;
@@ -252,22 +280,6 @@ void vhost_poll_flush(struct vhost_poll *poll)
 }
 EXPORT_SYMBOL_GPL(vhost_poll_flush);
 
-void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work)
-{
-	if (!dev->worker)
-		return;
-
-	if (!test_and_set_bit(VHOST_WORK_QUEUED, &work->flags)) {
-		/* We can only add the work to the list after we're
-		 * sure it was not in the list.
-		 * test_and_set_bit() implies a memory barrier.
-		 */
-		llist_add(&work->node, &dev->worker->work_list);
-		wake_up_process(dev->worker->task);
-	}
-}
-EXPORT_SYMBOL_GPL(vhost_work_queue);
-
 /* A lockless hint for busy polling code to exit the loop */
 bool vhost_vq_has_work(struct vhost_virtqueue *vq)
 {
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 37989518a07c..8f209d1c8890 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -199,6 +199,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *,
 		      struct vhost_log *log, unsigned int *log_num);
 void vhost_discard_vq_desc(struct vhost_virtqueue *, int n);
 
+void vhost_vq_work_queue(struct vhost_virtqueue *vq, struct vhost_work *work);
 bool vhost_vq_has_work(struct vhost_virtqueue *vq);
 bool vhost_vq_is_setup(struct vhost_virtqueue *vq);
 int vhost_vq_init_access(struct vhost_virtqueue *);
-- 
2.25.1

