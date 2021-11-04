Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44280C4321E
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 19:05:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2932261215
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 19:05:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234235AbhKDTH7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Nov 2021 15:07:59 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:23532 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234008AbhKDTH5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2021 15:07:57 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A4IapaA001625;
        Thu, 4 Nov 2021 19:05:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=YRvGMJIr+pPdp6mOPkFreVfqZcjqlBTVExiJGCzv26c=;
 b=Cu+wYIKHS+TCJyN6ikRBw+xu+dzR8yABx3UGQEvEKGHbm2AXvSO7AMB2CS9WTcJ93eqp
 1IqpzaKESXdzseOvderB8wHddJbZa0/+NF0AtO/FqxW+LE4iuxIuy3mFOE17qLbxrg8d
 yd2IJuzllXv0HdJUoWdAYl1v5zLe6J+jZE8omIuSU6I4Xb1OEhr9B5i81apziRNp9mqM
 x4zrTTEss2NHTl9+3/9RitiUcbzskMDrJp38ORGSxh/BpnFgfGDtYgz4f+Q5TgzIjGDZ
 KcVIDU7gq4ga9+McPmjF5P0cwJXTyk6O3kzbxzDSBc2CAhILZ6sJIfPerbfYgp0CyhdS AA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c3n8p9u7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 19:05:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A4J0PIe122897;
        Thu, 4 Nov 2021 19:05:14 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by userp3020.oracle.com with ESMTP id 3c1khxpeas-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 19:05:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LhqnXAgm3x5wNH8Qu6fCkoHe3TRutwSdhMkzdnJ6QiQdKZUEY7FOZ7rdVtmJ/px95mo0ZQFQUbHTkimR0daqDswDyJSIqrVw4lyvEoTUncJt0g7EPCuSEcpWsRxuQbtx+HQuKFlyC65lIFFCfxYqi/mV7mPOabZQ2VdWbA6++FreyqRUrcTrGGAptvl61dCmIPB/go/rqzJm/i77fCgWpsDh1YDSwhU3vhwrA71WooFmhkuHubjMhwMtk98ixOadJnjbeI2251/8+9plFufCrrqa/lnsOWdfXwPiMbx2Uz602G6tN45NAdzW3WJ4x5VGUjHzbtvsC+ZC4XgRYA2RBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YRvGMJIr+pPdp6mOPkFreVfqZcjqlBTVExiJGCzv26c=;
 b=lzT4VcSTQ/yMh36JmuhQVRLPEhLMp+9C3QJtBWNQGSFPDso79cwA9UsdWkcilV6/TUhtMJYNvX0K+6ul2/46l5V8l+1LUQ3YaPWjKzKWdX8TjEwiXTgwHB+V1ruIn6HOJo8hmxZT13+Lq37Sf94aRgo7H0EoEWlQiWYs5dTvIx1UOqOPF35Zgf14vBnDhjRfj6bfLHqTsPpumsFUFQo1QtPKrMo5LsKNff6j5+r7q2ULK53l0Kz1tKfUdUTh2nSNvzw8NDT1ppMmipYqO1IlPl0cJIC9eNAwrT6Zxo91iPnq6/i6z27qM0w+bRiJBS2ToP1/dtB6n8/oASJWQwpZ0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YRvGMJIr+pPdp6mOPkFreVfqZcjqlBTVExiJGCzv26c=;
 b=bwH2b4/B37gY6ZdnEEL1dTqzxuRFyZNA4zBro72PUlwe8CRroX/4I6gpOV6YRUN8UndTEcCxPPyOaodsXxoB6gJbuV0Kvfm1owkrgEiQnkqL8Zl+TGbwHVpeOKcSo9nQ1INZr4N+1nYU+bbNCyT/ILzPtOGDQUdx9kcCJcinOvo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB2873.namprd10.prod.outlook.com (2603:10b6:5:63::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4649.15; Thu, 4 Nov 2021 19:05:11 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041%11]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 19:05:11 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V4 03/12] vhost: take worker or vq instead of dev for queueing
Date:   Thu,  4 Nov 2021 14:04:53 -0500
Message-Id: <20211104190502.7053-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211104190502.7053-1-michael.christie@oracle.com>
References: <20211104190502.7053-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR07CA0080.namprd07.prod.outlook.com
 (2603:10b6:4:ad::45) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DM5PR07CA0080.namprd07.prod.outlook.com (2603:10b6:4:ad::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Thu, 4 Nov 2021 19:05:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ab3acc03-5bcf-4102-ab71-08d99fc60686
X-MS-TrafficTypeDiagnostic: DM6PR10MB2873:
X-Microsoft-Antispam-PRVS: <DM6PR10MB2873675332FB9BD609B93C7EF18D9@DM6PR10MB2873.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CcCcCp4TFu0X9dw/p147h91LgUxjDnKxNWpOeyI76Y8ITv8V3pq9CyKu2SaYpzOLlqaqO9y7eMTYom5QUHBx++drVjfeZFSRBYwexpmm+E8fsLCw5txCq/XRDp035bI5+VEAAA8G/6FWyzjYRCJvPHdB02B3O27rsmCwVE6Ew1vTHBgtms8muX9hCQ9ZMfrvMJl9WRtiYaxSbzXzLsDtBeMS8CdLdlhCfQw6VhmWpUaGA6pdjPhitWW99hUk4qRL6dmTyRYvoAT81tsBy6agv2SzxMOOFg2yfdqRFO+6MSdJt5n+J8AmYSNrQea3MGNqCRyXBLRJahmVfiPn4qXL19XW+ORgxioyW4WDNpmK0bcQzRUZWwtsbxNgvUSmrgPECgPQ4Ox+tueMDUTq89N5Pe13JrII2SM38sdlehtQsKo0Z7bivTe842B6ANXga7dT2uKjVpvDw/GHVbD/wmC6f+8XIEGdIyC3R/I+oAE+9YHcTMrp5AEETIqhZyi02z450NXICcC8SNA+CNmsz5WfccTAdmgNp3+Ds/s7KvwCqXOfo3He7ohzxpxo1awEqTDfeYWAzqhAfXBGqfc3EBwkc8BlMPclnR/2R2sEAenioEyKZB1LaYXPo6lRfMRRXqlH6syQEWeO0ei3QoccHHn53jhCnEWxvjrvwBrhkLCkCL80hXu+bcdtSsniPRpJ52QEQW6Rxdl0gCMLd8Y+nox+Jw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(8676002)(52116002)(6512007)(66556008)(66476007)(6506007)(26005)(66946007)(38100700002)(38350700002)(4326008)(186003)(36756003)(1076003)(86362001)(8936002)(83380400001)(6666004)(316002)(508600001)(956004)(6486002)(2616005)(2906002)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?48BzlbFkAO0MGMc+7uc98NHG07IGRK1Yez9BCPSw+I4ePMuI/MozZpx9QxwE?=
 =?us-ascii?Q?lWM/xUfzLIUM4Vt1JGaxa52xzcmPHvnNTLpWv5QsF5ESu4TKjZ3wE0YLfeG8?=
 =?us-ascii?Q?4P/DPcdH504uc/izpa2nu/X6FrkjF+D6ftjUshOebrjlmgncPmYRDHQT+5g8?=
 =?us-ascii?Q?BXqbfCqTVANakhqIHLC0AWqcUikWYEbfzxkUE0uNzKrLxd5DaznS3yoJ46Kp?=
 =?us-ascii?Q?N5xPZgahcLSzhd3pp/u6mjkLPHXWd7OiWVegCwULuOXefLCZRyQEm8pVa0M/?=
 =?us-ascii?Q?ZUw0FlWj+5CIojxuRMmsEPf+RmTEOjrxIh8thk3stqf6VoH9Jhq8JAdq7LJD?=
 =?us-ascii?Q?Y2ccsi4X07QXLnYaVj0lS2lU6+Uh/+T1k1uPxR8Jw5Y+vO2N90dCaMykpegy?=
 =?us-ascii?Q?KiAS1yI6mKYueehK5WGXiDGepEM9vrHTbC6uVHthCmSEvI5UnW/3FoZ/34Yx?=
 =?us-ascii?Q?p/ISj4QA+Il2ZQwNyOXdo332ienSNGkrcwyTmOijoybDbP7zmOf0rrwa/2Ln?=
 =?us-ascii?Q?7giWXRTmppvWdEaCJroaDGuBqOg+f4Q3BBP6oDO+/OSrzXLK8IvQ592cUufj?=
 =?us-ascii?Q?U81jjHfl6H/levw2emZUKsLng2tK+3rw/edTqUZ2I4AqbUvii2YgucRxdwQs?=
 =?us-ascii?Q?dQQLEI+acD46TRMXU7vO24G/Z1Xs4USPZlbISNN0y/ZPHdRFke4uUzYmb8Gz?=
 =?us-ascii?Q?I0bZ296GtJDXgFMo7i9D4k7dMAqbUnzvG8piU0AdhGPSoNPASUw/pRClfph+?=
 =?us-ascii?Q?YzOTVmZQYLW56KZqev7KDYQa92FxRi+qck589LyHOUXpbf+VqXXb7n768QnP?=
 =?us-ascii?Q?zt7VQvN4+7dSEvtpOWgjUiNLYNRR2BBTEJLtOwHmjRMTY9qrg+Lx7gTvJuqv?=
 =?us-ascii?Q?hJGVf1mLA/BttUeMjUGoBvA5U4hFNBUQHtiKKJbW8/mgFhNUyyVIElzAK1Gp?=
 =?us-ascii?Q?e2rOOnaOyPCsF04UGVMu+D76nt60WGBRS8gHiGYd98e2q962xkdP9zge5Kk+?=
 =?us-ascii?Q?+0A4/MDmz4PZWNides876KXdBxafHMRIJSf4oGOCPfQ/1qwYjHexPW3tQ1Zx?=
 =?us-ascii?Q?yf1Ja7aPGEtnLPKkcsxzMxZp7Hq9v0uLRtjW56be/IsIA3QyZPIQuCGEQSl9?=
 =?us-ascii?Q?bqAZ+u1sjhP/fnnQpru/uyO3jnZpKqf1Ss9umXIRhjRD3UI8qi/lrrIWsdnj?=
 =?us-ascii?Q?aLVi5o5XwACrdtz6uMW60wC6MavzgaS2j3szI3XuNHfFB/7/JH0raIVTLhYM?=
 =?us-ascii?Q?2nwYC9C/fsXu3TbWleOiJ22/98syUXEhqlh7qd7CqKQW5AMoLo3lRASiqkuY?=
 =?us-ascii?Q?8BzNZECJHeTEdrGJOlYLwkdeu6K+6lDf0cwEv9NUMNoyIa3UN1cGrX/3IelU?=
 =?us-ascii?Q?PF2ok79mLVxhfKsx7Cu96bsW044bxi7Ruc3eva8Aw8j+HdBcKSCwtiZea29Z?=
 =?us-ascii?Q?2ascvU3vGs6AaL9bmmOxrjvp3BnHwetoe6bhP+bLbqABXsoqUMSisR0U+Lv6?=
 =?us-ascii?Q?10evg0xdBjmyB3q1b2SznPRi4pB4mOZ2QpRIy+hinEvBCbTbRXjnKnMBe05S?=
 =?us-ascii?Q?jNs+gUyu0XAMdi82EZzuBClM/lMbwPaYVkV1luf+Ul+/WGwdkkKuYJ2MdmBt?=
 =?us-ascii?Q?lVHv0yH5f4zd+g4kQv6vo1iwCoyOT1HAm5M37TzD8l5o3YXipfeIqtliPFNV?=
 =?us-ascii?Q?0m5H1w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab3acc03-5bcf-4102-ab71-08d99fc60686
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 19:05:11.2615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pWPbPpBTSK2nvI0QSaiOHTxgLJtKa4HGmA8Di/UqtidrLOfQaaCyF0AKpKNrsVyuLgGkoox0nmep3/R9cPzJUdNMIBbPzV4E7/W6QSnk0vo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2873
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10158 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111040076
X-Proofpoint-ORIG-GUID: CkzZwRmNOSl53nPRJGLTkCM83rQ-21_o
X-Proofpoint-GUID: CkzZwRmNOSl53nPRJGLTkCM83rQ-21_o
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

