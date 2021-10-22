Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8677C4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 05:21:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B823661215
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 05:21:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbhJVFXX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Oct 2021 01:23:23 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:39416 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230295AbhJVFVv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Oct 2021 01:21:51 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19M3wlCE006097;
        Fri, 22 Oct 2021 05:19:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=3aJDenUEDyOoOTfoekDrWXg24pA1mwwyDffqn29hT0U=;
 b=RUYWT8ucdv1kfp9pyKSGJodZhWo3ZpWr6/9t7YOAWyxK85F3eyvsqOcdqjLtsAzIk5wE
 5bpG3uNCnetafTrQrGj38HDQ2ivLq9pFlfiTrU33rIoQorEXZkGiu/tdmBLuvXVJonOD
 83qxKIjvqXxcomzSsf+jBnXbbcg5SSrWcwNwK/TOlrUf7V0ox8WsoBsfRp5BiY0TPyiv
 fYGy1NI2JLJDiXET75V/WGZsc75RZNumkJnryI5SlZRIdBJN5f0XWH382FFQXO763XYg
 x68wDDc8SVYrobATzaAxX6CuC8wp8wkizT5ZJKQVzYzVMUWFoi4DnlYISuGLWrI/Bbag WA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bunvd072j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 05:19:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19M5BHIa139141;
        Fri, 22 Oct 2021 05:19:26 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by aserp3020.oracle.com with ESMTP id 3bqpja16nf-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 05:19:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bCjYmIWIZLf9zup0gMpeN7TluwItRDflUV8WY1jBI2UvmEywls4exYzmWxehpLIthA0Dz4KeXKaoqQD8l0lvaaaVEUgygicbGJZpp1xAx8Z9svYx791Eqw/TBP0TiqYc7kpkGYugef1BnwUYs3WYrpeecgAfYBU0EzJ4rBeNyEu4HGzUOrbIzuoKjCaKcr0D8sxYp4ZO2SXzaH4BkWxEVxDGgyL+s2bMNK96nVW9N47YOP9+Y18XVkAl2ogn7GgjZC16NjtRodbh4BJ6ajabpbwalitOt9o1xdbsBeaPITn4rPGwZmuwecUg2mUJwXHuP7LQkyn6BX0l4DiwC57nCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3aJDenUEDyOoOTfoekDrWXg24pA1mwwyDffqn29hT0U=;
 b=R8wVWTcKfuUsoUv8i5gYPDKcK1aLR7h75pJYRlvF6bLJe2WLpfSgHdKIvMHlnOkE1RmuatILBeYi9IIJr82cVlLOmo1KTkCkyhcQ4QpZ6cOvw1++Kz3J4GQwG6HyQwwh2BWphjQ6LtbLr0mqYRU6CTdA78lCtkKnSACtDcdTItMuwMvy42nXIAvS7xHCuc9wUuFSEWaXecgwxvgueqHsaO2N5oDLzTjfxsYofSVT64AVFdP97KCyxKGChdOYXZ+Tth0p1sZ46usdm8CBhWzFWyZ9j62oo0ScxlBoQ9oryNE21QkMUqaZTDbX7gw/fBwz03n+4FUTPMCpq0jaM0xbmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3aJDenUEDyOoOTfoekDrWXg24pA1mwwyDffqn29hT0U=;
 b=oFlXtMoX+/yh6psGwkrrV8nlVjmGsev0TGIcmy97AQ04vvB6ALUZN6CZqzQjRiysxuZFYjgg2Z9T3npUqGoapB4Kfu6i8pjW+VU5mdvEkSrJgUwh4D/vgfSpPvSkgjl8vrZU8y2XmPJUAivW/ccO5e/DGrUatFfwpbC4s+VeTRg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB4974.namprd10.prod.outlook.com (2603:10b6:5:3a0::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.16; Fri, 22 Oct 2021 05:19:24 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4628.018; Fri, 22 Oct 2021
 05:19:24 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V3 01/11] vhost: add vhost_worker pointer to vhost_virtqueue
Date:   Fri, 22 Oct 2021 00:19:01 -0500
Message-Id: <20211022051911.108383-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022051911.108383-1-michael.christie@oracle.com>
References: <20211022051911.108383-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR08CA0012.namprd08.prod.outlook.com
 (2603:10b6:5:80::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DM6PR08CA0012.namprd08.prod.outlook.com (2603:10b6:5:80::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Fri, 22 Oct 2021 05:19:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 94fcd8b9-16f1-4df4-3b5c-08d9951b82e6
X-MS-TrafficTypeDiagnostic: DS7PR10MB4974:
X-Microsoft-Antispam-PRVS: <DS7PR10MB49745FC384FCD5C2EF858FD8F1809@DS7PR10MB4974.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6Y68c3FhfzQUyqGAE+rnG03P/+DjSDCDM8kUGi3kAUEodo1YfDZCHyRu/x1ueSeKg5/UrIi0fxMnGW1Wj30hSNIB1+gfgJWXG/HLDvvtCv9hRZTNqnEy0QCMvnVcuk1P4QfYimDlYhza0FlIq/+Tu3B3V3RqMdB9Y1KVkm3wjWsH8HPzG/q700NJqx6aoqUPneAV8ImHmEc36snZ/vMxIst750SMoJJxmmizfDfu19GJ84UP50/WIAUivcT3piEJbo5po0RejihH6RODvRhhSwf7W2jIpz9HbAV2mpuSSNGIyDlya3et9HPhK1YHKw6hqgh8Z/WjaHlSjYGV8dJnak8hOrR++SvL4IZozFJaDzVQuyjEfaR2smclHbY1UcjynHqoXmapHpJvHNJXBgsaNyxzm1oof+MYJaE31ckgYMNV++H8k1x49rxkh77U84x5xxx2VAXaSduedxqMRs5CQvJKHMx9IQZg5f7O8i8GqBSPYgDavEnoV9bbYmyE35vEp5zXRyrTAe2XEd7PricaMgoBmXHZZrMWSrIrhyYf+K55jd7fCyTrUQE3FzwWnwXJC2cLLAhBtXn64ROC3VMN+9GwHEiXFSof+rRXHtguXkZ2S9uWzou7kXbNgcuKaHNJ44D+Nd398nh+9Kx9kp1ElUUlMz00fW/r2v65SFcOsclZlMn+9MlkkCJ9K6BE/zAcCiAnegw2VPXpQZkwrj3VPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(107886003)(38350700002)(66556008)(4326008)(36756003)(6666004)(1076003)(508600001)(2906002)(66476007)(66946007)(8936002)(38100700002)(316002)(6506007)(186003)(26005)(6486002)(6512007)(83380400001)(52116002)(2616005)(86362001)(5660300002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QnRZe6K1HqLNOD+Pk72omBWHd5CcInkG8Ypf/HCB6uBfboERH2jynu5ow8ar?=
 =?us-ascii?Q?0kgFNCvdq+yzBdbbzRoDOr+iaIoNwWzrBa+tgMglF9mlAezW98stXF5xRdmO?=
 =?us-ascii?Q?oZ4TN0iux+pI0py5yLGZ7idVDYZQhdYZMMeMWyptuRbtUlJPIGDLNDRR4DFh?=
 =?us-ascii?Q?urvT3QDI02pzf+GWOQ4ucmukkxl8hjcBZPlMn54mZ4xxkSgjYG8dN8CvNJ+f?=
 =?us-ascii?Q?9KzVvGan5aYr80qHrx9ZjoS9se3EHM8oQhUqf3+6cH8JKWVVvbaATTD800QR?=
 =?us-ascii?Q?6brqRtuhywW1XfgliDrmYTglx3xU2rBg04QFp/QmWfq+s8YVQlv5c9YBnqrT?=
 =?us-ascii?Q?KrnT/0/35S77WYFxfaJl16poSnC8omxGqIesxvBrGzIRDlH2J3StIoMXJQz2?=
 =?us-ascii?Q?8a57hVjcUXPxmsQQUHlkI9dhO0tjphuyNxpo6O8vx4TnEhiktiCSsEs6G778?=
 =?us-ascii?Q?sSnYs1+94MpxR2NPy4IOsv8zOUWfVs0FbOfQh88UftpjPmF4eaLhrFBlX/ZU?=
 =?us-ascii?Q?gDk5BsWbODxjGI7BVhsxjmr3jIKQzFbZgoQqv4fLP+ROCrRzZzuddbP66CLX?=
 =?us-ascii?Q?PnegA+fpwWtDuZIcbwGU2hBRhoCmIRlNayI9DIxKn0AKGEIM7n+354FIA7Sz?=
 =?us-ascii?Q?qAhgvwmgxgxUadVpBC29MZxgFfL6GRbMM9lhZoRLDbtXa//6Y8Qweq6/JJNn?=
 =?us-ascii?Q?tZZRhIGWQVh4PRl2pgjB4VqMiOdBPP0Ahaz1/93niuwgMAkm5FlAuoLiutza?=
 =?us-ascii?Q?MFX0oE5wlS+oBAQQ9ZObUtN9v/qzINkTr8K4Ubk6XVUGN9amMGV9ThBLL5UG?=
 =?us-ascii?Q?RUYcp3Leh4vrGkcQauZ7jJMGp4doMxvkdvVwKKcXXrDMIifrYNfxq9OPIz4J?=
 =?us-ascii?Q?9dB7d47nX35Bp7zQASuiSTKE439a9qN2+AI6A1g88BpgKRTRMup8a/n4e+Pt?=
 =?us-ascii?Q?KnaegKTLAf+YyVBJn05BvWtdOstufWhEzadshDpdeK7MGdQ0GiTdX4C7AfW2?=
 =?us-ascii?Q?WPfTakJ3yCdpuBtYVZUfqY4qv2ZbgJgP3BFelgSSSbAQFsUvmRAp0NA9pWYk?=
 =?us-ascii?Q?2f6CjG+Gq/Z2+e8qX7FcG9j1BWexET5ft3/Ju22r+/GDto6X72DAJDEs/PWp?=
 =?us-ascii?Q?yTXe1uOXvSomYKcykLC7WaTVeyVAutsAFVJym//BPfK74rIDkZt/8ZWHd1XH?=
 =?us-ascii?Q?cAjwMHj2oQqcpqPXyxj8yM5PYOklBQZS8Jz6l0FC6+Uiq8G5HkyRMmDSgo/q?=
 =?us-ascii?Q?Ku92FBbCaf4sTCy/MwMD6WKt2OGEakM7luETAK6bsoP606QmmCLoLVl8ZhFA?=
 =?us-ascii?Q?gQc/vuqbmcv7VJIp6QJ8IE9VRSv+8ef+263ptqbARmhzqRU372lmIXWtHQS7?=
 =?us-ascii?Q?uZbcGqUf0sek3nczadd/ZLBaC7x9flRrgqfF6/ngCrGOzj4O41A3lCYga+/u?=
 =?us-ascii?Q?Z7glQApH8cYgRWblUFVxQBN76SlZTBo+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94fcd8b9-16f1-4df4-3b5c-08d9951b82e6
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 05:19:24.3647
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
X-Proofpoint-ORIG-GUID: jqzFLvrJ6sNcTrqO9Qk5pg6SgFkYvZWC
X-Proofpoint-GUID: jqzFLvrJ6sNcTrqO9Qk5pg6SgFkYvZWC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patchset allows userspace to map vqs to different workers. This
patch adds a worker pointer to the vq so we can store that info.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/vhost.c | 24 +++++++++++++-----------
 drivers/vhost/vhost.h |  1 +
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 9aa04fcdf210..9b4e7d74dab4 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -496,6 +496,7 @@ void vhost_dev_init(struct vhost_dev *dev,
 		vq->log = NULL;
 		vq->indirect = NULL;
 		vq->heads = NULL;
+		vq->worker = NULL;
 		vq->dev = dev;
 		mutex_init(&vq->mutex);
 		vhost_vq_reset(dev, vq);
@@ -574,15 +575,14 @@ static void vhost_worker_free(struct vhost_dev *dev)
 	kfree(worker);
 }
 
-static int vhost_worker_create(struct vhost_dev *dev)
+static struct vhost_worker *vhost_worker_create(struct vhost_dev *dev)
 {
 	struct vhost_worker *worker;
 	struct task_struct *task;
-	int ret;
 
 	worker = kzalloc(sizeof(*worker), GFP_KERNEL_ACCOUNT);
 	if (!worker)
-		return -ENOMEM;
+		return NULL;
 
 	dev->worker = worker;
 	worker->kcov_handle = kcov_common_handle();
@@ -594,25 +594,24 @@ static int vhost_worker_create(struct vhost_dev *dev)
 	 */
 	task = kernel_worker(vhost_worker, worker, NUMA_NO_NODE, CLONE_FS,
 			     KERN_WORKER_NO_FILES | KERN_WORKER_SIG_IGN);
-	if (IS_ERR(task)) {
-		ret = PTR_ERR(task);
+	if (IS_ERR(task))
 		goto free_worker;
-	}
 
 	worker->task = task;
 	kernel_worker_start(task, "vhost-%d", current->pid);
-	return 0;
+	return worker;
 
 free_worker:
 	kfree(worker);
 	dev->worker = NULL;
-	return ret;
+	return NULL;
 }
 
 /* Caller should have device mutex */
 long vhost_dev_set_owner(struct vhost_dev *dev)
 {
-	int err;
+	struct vhost_worker *worker;
+	int err, i;
 
 	/* Is there an owner already? */
 	if (vhost_dev_has_owner(dev)) {
@@ -623,9 +622,12 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
 	vhost_attach_mm(dev);
 
 	if (dev->use_worker) {
-		err = vhost_worker_create(dev);
-		if (err)
+		worker = vhost_worker_create(dev);
+		if (!worker)
 			goto err_worker;
+
+		for (i = 0; i < dev->nvqs; i++)
+			dev->vqs[i]->worker = worker;
 	}
 
 	err = vhost_dev_alloc_iovecs(dev);
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 09748694cb66..7ee38b4a2807 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -80,6 +80,7 @@ struct vhost_vring_call {
 /* The virtqueue structure describes a queue attached to a device. */
 struct vhost_virtqueue {
 	struct vhost_dev *dev;
+	struct vhost_worker *worker;
 
 	/* The actual ring of buffers. */
 	struct mutex mutex;
-- 
2.25.1

