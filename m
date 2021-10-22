Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF46AC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 05:21:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B579E60EE2
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 05:21:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbhJVFXU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Oct 2021 01:23:20 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:46692 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231773AbhJVFV4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Oct 2021 01:21:56 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19M3R0C5010002;
        Fri, 22 Oct 2021 05:19:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=3KYSseobhLsX3CCyduMS8iQ/XqjAJDgW1U5mrujvZwY=;
 b=gVvCtJ7kYdcYR+vmUWoJxAOdhjm/XE+yd3M3b4b3t7uvlPvOVYDA+JR7WkD8YQFlD/6Y
 aHhDpXDo8WMrWJ9QKGezSZBXOqzItMyQJrjs5qGoOmGPKh36MBVhTig4JY4c18+51k89
 LNabbxVD0D2jy8fAooq/ZCPyNcixBX4LMCv3DpskKYLOWnKvF1VSH1vteE9+AwQqfh2b
 J/QbFdKU8k1K8onnM06BK9WqDhH8k9nbdoJEoHD47ldvIXdp4+KFGxpa2WOOH7a56pUj
 ASzayaxResreh5Kbej/3AwuyPu7RLiYmZZtGJAVoFWbEJOPBuNMCyXLXL4uOK4ibf+Zb yg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bundfg9ek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 05:19:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19M5BfsG096761;
        Fri, 22 Oct 2021 05:19:32 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by userp3030.oracle.com with ESMTP id 3bqkv35pvd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 05:19:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RcumpIpgeoChP7/mC61QL+WN5K4BW5RC/+JW/wMnf8TJKO3vstY1s3cae1uDC04wXodxa9asEj45I+Beq1+vF1Sl7UrVsfIVHkaLqo3AnuFwolwTqQW5fWzoJzUBu1EHKByZ+kJRkNoNxojrhwnWyR56WGGQuhDjfrzCXLqDxIrGZ/Qns2GpCGwukqFYuU2f5uDuF7InCWVS7E8cuWs9ysM9fkfFlImuXm5htp2MvD2TKZgGc/wFSrNiY3iTDMufXEsjZoeMK7tpId1r3RYtPdGzb4la7Qxojc0JwzlFVjokU+e/pdM20YKtStWn2jobP3RB4vgRiSuaKyXJw60ydQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3KYSseobhLsX3CCyduMS8iQ/XqjAJDgW1U5mrujvZwY=;
 b=M7Z8gnflnx1a3D601AgheVJ0ayVBmm+D6iY53c3OzWeu/OySxv/WJ/gQBj/1aXYQIkIX3r62i/aSG75cfkOi+4IhoknJ+/s9YDW0KUC2hkWSVrv/EbqTLqXL9Oc5eguAVfTrVsR3QQDpuemkmMoQ6QOjhvzOId7ZkBrWWLHeHYKDmIUAMZvI7u6FohJbGoeHw8Na5Q5zCw5JCJJEEjybIW9x+6EVu5MqLWSm+CNYkawZu++6+fTcrnvOWff5luOj4ZPGY2qC5W6uIkmQyemZQuTf1t828KTCeOAsq6oGFAwWqWDa+hFMfWnaFWtbML471RghCbJpI3YL0KadCNehWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3KYSseobhLsX3CCyduMS8iQ/XqjAJDgW1U5mrujvZwY=;
 b=OZyFbL6CafpkJtLNfPB0n1zjUiUJFTHCaFZ4bdSkZE1DdTxdiogBtVYYhAbSp0EFJDCgEcKQ0qpQ3nbmD3wb9x/LMdFw/Ku1d4C4DGcfAIK+Vy6tGoNrS+svyzQ4GgzH4i9N02hCR7BMpJzWuRvNSfWw3GnQfSvU4VyZY3CjZWg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB4974.namprd10.prod.outlook.com (2603:10b6:5:3a0::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.16; Fri, 22 Oct 2021 05:19:30 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4628.018; Fri, 22 Oct 2021
 05:19:30 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V3 11/11] vhost: allow userspace to create workers
Date:   Fri, 22 Oct 2021 00:19:11 -0500
Message-Id: <20211022051911.108383-13-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022051911.108383-1-michael.christie@oracle.com>
References: <20211022051911.108383-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR08CA0012.namprd08.prod.outlook.com
 (2603:10b6:5:80::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DM6PR08CA0012.namprd08.prod.outlook.com (2603:10b6:5:80::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Fri, 22 Oct 2021 05:19:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed2c5601-2585-4285-26c6-08d9951b86b3
X-MS-TrafficTypeDiagnostic: DS7PR10MB4974:
X-Microsoft-Antispam-PRVS: <DS7PR10MB497438CC353FD32FF48AD0B3F1809@DS7PR10MB4974.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:324;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hQqsgnKD0yZYPLRegDrRyoj3npC6mydEDFYSULyCgiDsoGqS8upSQuhOXAsyLTMugBbT+eKVwvufjqrujr44FD4obRXQguD2tKu4zT86yQ7JbkTYamvF/MyKJ+kzThMPRqK6OAQeBPZAccViL5g8FZraWu5djYITBsvE83OaHNfxy5zEuzE9OiMPFdsfGNUfrteJvdMriA/EChhYEX0maHwutjnlv6sK5Cbi9ajmzLoULR5bXX89zoXO7X0+OcuVVBMFnQBNA/pzfLRwlBvSooaF1SxsaaXN3PBxsWt+/g7/8ndKdTFaWEjrOKoq4QuYuimQHhq0lVcxPPeTrJ95UKSE0N5kK7F+Py2/+7glebvhW4mxmmNAR+Yu0BSF5sx1f1yVFKiFG37GJv5JsFadkhNryfRPKubvAvTkso5mxRmj8tJBzFVJm8jv8QnGn71v+p9F9KAQVug9sEc2RdUU4Mtcio/FhxTyxAdAOV4WbAA1vn9tvahKllkBitKKwRqRgsR1mfbpKUP3gNF2g7lPCI5muNjQh42exGUigHabnUJyegvg0DOpsPl3eXBqoXTHZc5Cqmj2ndb/f/KImxRvX8HXgLb6ms74/7WP/mZIHaq/VLO3RE8IeAokq0JOcdsW5ce1WySKhYoxTYG46rSXjMzidjuhjNLntrfdWcHNxUQRB43Q9W1j6ql6KySypSs/B2NgBIeSn2pZy57XQIlkoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(107886003)(38350700002)(66556008)(4326008)(36756003)(6666004)(1076003)(508600001)(2906002)(66476007)(66946007)(8936002)(38100700002)(316002)(6506007)(186003)(26005)(6486002)(6512007)(83380400001)(52116002)(2616005)(86362001)(5660300002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?igNS9s9a42JXBULYqgHELn4SIdULhLJvti0VcgWIFLxUcYcA0EzpxSVi7c5y?=
 =?us-ascii?Q?D9M54izml33D4lPKyad5WO3Tf46NZHHYNYXWqMKScenX/BZGGLoK4A4LMzA8?=
 =?us-ascii?Q?ATuD2v60uMBqLvbAJ/OMbvZe+AABo2s8LqojBy7Zcy0zGIoEk0BDllU1MD1j?=
 =?us-ascii?Q?77UemcbhfVIqI0NRuW/Hnq8yXoHflI5TOQxE1dMmzIwO19xUEqllYSnirZ5J?=
 =?us-ascii?Q?W7mw+12GgDAaeLW7H7ycuuSHDlvUqSQ4gEHvxklds+syd97MTCZieXs7niEx?=
 =?us-ascii?Q?Zp0ByU9VKKmtHPnhR33Z8n+BDMXeTwZR9Y7XAktQNhHUr4PRh1bY5yDEaIIQ?=
 =?us-ascii?Q?i4UdK3Sf7mPWo1asGrq1n8M5BG1KPvY2nDLQd9ygU3S/Y2dUJR2ZHCqIdRLl?=
 =?us-ascii?Q?5dfiEIUCwhKs91m88GdyHToa/PQYOgj5mwNHiF289AzLj/T2UbqeCUFFaCq3?=
 =?us-ascii?Q?6rWoNJrB6tKM596YFd3JWc2vRaEZkVj3mkHz7YV4KM1sFVktfqFCk1HN5hSp?=
 =?us-ascii?Q?+9pkGaA/DcxEo2VJCN535YBmvBjcIjDgBIziuNmTICH2ceYPaWnjpRPIEEB6?=
 =?us-ascii?Q?0V1882GtBu3whLXqTGCCIWLFSMskvPu1Yrk8F8DREKX79XFHV+blDX0aplrO?=
 =?us-ascii?Q?k5IO+lBEoK8XNfCozc/G6Z+UTlNhnfUQsUzDf6FHOnwI6EIS55hV6a1lgzMA?=
 =?us-ascii?Q?6ujG0nQApRMMT/pao/b/D9lVrgPvMr4HxThwCyK78tYquuus0h+iKJkwFgxx?=
 =?us-ascii?Q?+B6kPqo3xzivMqZJzmlPxOpBJ0q9hzpH/vqlohLKLpiIp3joa8tNbt9vWNpI?=
 =?us-ascii?Q?Bmi2jd9leEN4rYyTvIcJiABpA8gpUHKGz94hqHb5MfUIA6+I6QgtahjRy1sa?=
 =?us-ascii?Q?/Y65gk5t00EaJu4+bbdXsidAIya7BJadA/KizqbzwHqml5l59RSCdripO/dy?=
 =?us-ascii?Q?fXMJihxhA9uoJSqXyM2RMutloYarvnNm0OW2UDI6sPTKLJb48hMa8RP8ySQB?=
 =?us-ascii?Q?S/jDFfWNMGq85szyUioXz1F14azKs+cFh9+CkQvz263BbsuFdJHRy2PZR4YR?=
 =?us-ascii?Q?eIa4rWc9cZXvQE6P/lyLzX+Z7FUomqwPfoMhexQxAEPvx946Ctjl1rAzT3he?=
 =?us-ascii?Q?KN6v90EYM2KiVOoels6tNmwKrDTdT9A83fz2thTxQa9ZTieT41b/oCwmj3OZ?=
 =?us-ascii?Q?EUc1AelaT6jrsV19GJt+h+3Z3OY3MrdrF+XU+UQS4HXJSOBCxbVMAdAbDXcN?=
 =?us-ascii?Q?1+HbUxLDwQ8Ik5+Q3Y+bFignoEXLW8B/g/uEhGrCePEXhQ5S1UU3NFS3uqFX?=
 =?us-ascii?Q?yxV8L2smgC/flBm6EIc99TdGruthrUFnyYo+JIABOuX2uwU0/A3+iawRQfvS?=
 =?us-ascii?Q?mntJNTXkrmPCwUKEy4nUTTRQeqS/UlXqSiXrCpVKqL6jrV8oPkkZjP2gvjTj?=
 =?us-ascii?Q?Uq1q5y8yl59sCk77HQLekN8a5mTDFkIb?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed2c5601-2585-4285-26c6-08d9951b86b3
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 05:19:30.7998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: michael.christie@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4974
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10144 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110220028
X-Proofpoint-ORIG-GUID: dsdACF8mSAPZprrxMjka07R7BkqYeXl7
X-Proofpoint-GUID: dsdACF8mSAPZprrxMjka07R7BkqYeXl7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch allows userspace to create workers and bind them to vqs. You
can have N workers per dev and also share N workers with M vqs.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/vhost.c            | 99 ++++++++++++++++++++++++++++----
 drivers/vhost/vhost.h            |  2 +-
 include/uapi/linux/vhost.h       | 11 ++++
 include/uapi/linux/vhost_types.h | 12 ++++
 4 files changed, 112 insertions(+), 12 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 04f43a6445e1..c86e88d7f35c 100644
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
@@ -576,20 +575,40 @@ static void vhost_worker_stop(struct vhost_worker *worker)
 	wait_for_completion(worker->exit_done);
 }
 
-static void vhost_worker_free(struct vhost_dev *dev)
-{
-	struct vhost_worker *worker = dev->worker;
 
+static void vhost_worker_put(struct vhost_worker *worker)
+{
 	if (!worker)
 		return;
 
-	dev->worker = NULL;
+	if (!refcount_dec_and_test(&worker->refcount))
+		return;
+
 	WARN_ON(!llist_empty(&worker->work_list));
 	vhost_worker_stop(worker);
 	kfree(worker);
 }
 
-static struct vhost_worker *vhost_worker_create(struct vhost_dev *dev)
+static void vhost_vq_clear_worker(struct vhost_virtqueue *vq)
+{
+	if (vq->worker)
+		vhost_worker_put(vq->worker);
+	vq->worker = NULL;
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
+		vhost_vq_clear_worker(dev->vqs[i]);
+}
+
+static struct vhost_worker *vhost_worker_create(struct vhost_dev *dev,
+						int init_vq_map_count)
 {
 	struct vhost_worker *worker;
 	struct task_struct *task;
@@ -598,9 +617,9 @@ static struct vhost_worker *vhost_worker_create(struct vhost_dev *dev)
 	if (!worker)
 		return NULL;
 
-	dev->worker = worker;
 	worker->kcov_handle = kcov_common_handle();
 	init_llist_head(&worker->work_list);
+	refcount_set(&worker->refcount, init_vq_map_count);
 
 	/*
 	 * vhost used to use the kthread API which ignores all signals by
@@ -617,10 +636,58 @@ static struct vhost_worker *vhost_worker_create(struct vhost_dev *dev)
 
 free_worker:
 	kfree(worker);
-	dev->worker = NULL;
 	return NULL;
 }
 
+static struct vhost_worker *vhost_worker_find(struct vhost_dev *dev, pid_t pid)
+{
+	struct vhost_worker *worker = NULL;
+	int i;
+
+	for (i = 0; i < dev->nvqs; i++) {
+		if (dev->vqs[i]->worker->task->pid != pid)
+			continue;
+
+		worker = dev->vqs[i]->worker;
+		break;
+	}
+
+	return worker;
+}
+
+/* Caller must have device mutex */
+static int vhost_vq_setup_worker(struct vhost_virtqueue *vq,
+				 struct vhost_vring_worker *info)
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
+	if (info->pid == VHOST_VRING_NEW_WORKER) {
+		worker = vhost_worker_create(dev, 1);
+		if (!worker)
+			return -ENOMEM;
+
+		info->pid = worker->task->pid;
+	} else {
+		worker = vhost_worker_find(dev, info->pid);
+		if (!worker)
+			return -ENODEV;
+
+		refcount_inc(&worker->refcount);
+	}
+
+	vhost_vq_clear_worker(vq);
+	vq->worker = worker;
+	return 0;
+}
+
 /* Caller should have device mutex */
 long vhost_dev_set_owner(struct vhost_dev *dev)
 {
@@ -636,7 +703,7 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
 	vhost_attach_mm(dev);
 
 	if (dev->use_worker) {
-		worker = vhost_worker_create(dev);
+		worker = vhost_worker_create(dev, dev->nvqs);
 		if (!worker)
 			goto err_worker;
 
@@ -650,7 +717,7 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
 
 	return 0;
 err_iovecs:
-	vhost_worker_free(dev);
+	vhost_workers_free(dev);
 err_worker:
 	vhost_detach_mm(dev);
 err_mm:
@@ -742,7 +809,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
 	dev->iotlb = NULL;
 	vhost_clear_msg(dev);
 	wake_up_interruptible_poll(&dev->wait, EPOLLIN | EPOLLRDNORM);
-	vhost_worker_free(dev);
+	vhost_workers_free(dev);
 	vhost_detach_mm(dev);
 }
 EXPORT_SYMBOL_GPL(vhost_dev_cleanup);
@@ -1612,6 +1679,7 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 	struct eventfd_ctx *ctx = NULL;
 	u32 __user *idxp = argp;
 	struct vhost_virtqueue *vq;
+	struct vhost_vring_worker w;
 	struct vhost_vring_state s;
 	struct vhost_vring_file f;
 	u32 idx;
@@ -1719,6 +1787,15 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 		if (copy_to_user(argp, &s, sizeof(s)))
 			r = -EFAULT;
 		break;
+	case VHOST_SET_VRING_WORKER:
+		if (copy_from_user(&w, argp, sizeof(w))) {
+			r = -EFAULT;
+			break;
+		}
+		r = vhost_vq_setup_worker(vq, &w);
+		if (!r && copy_to_user(argp, &w, sizeof(w)))
+			r = -EFAULT;
+		break;
 	default:
 		r = -ENOIOCTLCMD;
 	}
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 33c63b24187a..0911d1a9bd3b 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -35,6 +35,7 @@ struct vhost_worker {
 	struct llist_head	work_list;
 	u64			kcov_handle;
 	unsigned long		flags;
+	refcount_t		refcount;
 };
 
 /* Poll a file (eventfd or socket) */
@@ -160,7 +161,6 @@ struct vhost_dev {
 	struct vhost_virtqueue **vqs;
 	int nvqs;
 	struct eventfd_ctx *log_ctx;
-	struct vhost_worker *worker;
 	struct vhost_iotlb *umem;
 	struct vhost_iotlb *iotlb;
 	spinlock_t iotlb_lock;
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index c998860d7bbc..e5c0669430e5 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -70,6 +70,17 @@
 #define VHOST_VRING_BIG_ENDIAN 1
 #define VHOST_SET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x13, struct vhost_vring_state)
 #define VHOST_GET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x14, struct vhost_vring_state)
+/* By default, a device gets one vhost_worker created during VHOST_SET_OWNER
+ * that its virtqueues share. This allows userspace to create a vhost_worker
+ * and map a virtqueue to it or map a virtqueue to an existing worker.
+ *
+ * If pid > 0 and it matches an existing vhost_worker thread it will be bound
+ * to the vq. If pid is VHOST_VRING_NEW_WORKER, then a new worker will be
+ * created and bound to the vq.
+ *
+ * This must be called after VHOST_SET_OWNER and before the vq is active.
+ */
+#define VHOST_SET_VRING_WORKER _IOWR(VHOST_VIRTIO, 0x15, struct vhost_vring_worker)
 
 /* The following ioctls use eventfd file descriptors to signal and poll
  * for events. */
diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhost_types.h
index f7f6a3a28977..af654e3cef0e 100644
--- a/include/uapi/linux/vhost_types.h
+++ b/include/uapi/linux/vhost_types.h
@@ -47,6 +47,18 @@ struct vhost_vring_addr {
 	__u64 log_guest_addr;
 };
 
+#define VHOST_VRING_NEW_WORKER -1
+
+struct vhost_vring_worker {
+	unsigned int index;
+	/*
+	 * The pid of the vhost worker that the vq will be bound to. If
+	 * pid is VHOST_VRING_NEW_WORKER a new worker will be created and its
+	 * pid will be returned in pid.
+	 */
+	__kernel_pid_t pid;
+};
+
 /* no alignment requirement */
 struct vhost_iotlb_msg {
 	__u64 iova;
-- 
2.25.1

