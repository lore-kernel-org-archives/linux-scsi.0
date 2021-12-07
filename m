Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75076C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Dec 2021 02:51:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbhLGCzQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Dec 2021 21:55:16 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:53742 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231835AbhLGCzI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Dec 2021 21:55:08 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B6M5EdH012504;
        Tue, 7 Dec 2021 02:51:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=u00qoDBdAGW0JGm/dcunSrWRtUIddYZAsEHgU5/auDs=;
 b=TgnAvA1yU9haIXc+aP1anjuFsO/Dp+auNNYfDkPNU3/Wa2AC+FJXOZDe/SSf8zzXERxB
 USKJBNiy/FfBYRsKo/MMkES3PO+cnq9sCQRZ6lgsuA5yBXiUJc+S2oNipggfiKTtySsz
 n7xdOth1sOOwjD2N7oDYr57KyIH1/pktwnDQL+RLwl3lCT87KBfkL3T3erSs0V4LQ3dC
 z6LzuIfpcLRlE1+U0FRfMSJu2FuUK9nIis6bbNGln1Nw7ey5LXtfJYpE3tKs/602BAuG
 LsoRe4MUzUwkog3Wy3hA6cYte6kTVl8e6+iaULUe6g4xF/xCa6Vdb4kQcly2Xe7rsB0p Ow== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3csc72c35c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 02:51:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B72kh32153049;
        Tue, 7 Dec 2021 02:51:35 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by userp3020.oracle.com with ESMTP id 3cr1sn5w80-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 02:51:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dOEg651gJDDjKKxJa4D23B3N7qzsGUsVPmLIfqYuHgffJhWUcrhgZBppg7WvIClFFVwjIKqqcDetSjHxoDUfYLnCOv+/n/9/5ZdOQMUaiSoM3MrR6mXS62JmlaE90kkAAWD9CTqmU3G+IZXUbaE8FO7CFk3LSfBjWENjnvO+ZJk+a8VmNgtimYATRZA97SvGX2sFgnPondP96TWWUs8q/4Kg6ejPSLw6m2bj1FsgeGserAaBAlVwAhwdsIKOMBBCzp9vV6+FUVymgyOAOJzuSHI+m+mGdBJ9LfTZMsmWuWO87x/ii4XiD5amFI+Y9PWLWkDEAc5GR4ya+KT9u5Z8wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u00qoDBdAGW0JGm/dcunSrWRtUIddYZAsEHgU5/auDs=;
 b=CzsfACGAzrBMGpGZ8jFACAwNTUMKYX3pKtjOa09Mb1q8aV7MGh/KlE+O0P2C3guhhjxV6kUjJE1jDRfwTDcSKTKVtT19yMd/vSgYGNmjr4DTrFmsAoSIRYsRcpxdIhWLqFvKZkUqR5QImhg+q2SAUld6yB5rH1gbRhHRNvFBwsZAuR76ZNwzlDEq8DEUJV3KszCihDni5qAYaTx/+SZARxBVTcAupmBDUCU2n3H5yBb79tRZlMY8dgnjPpHmlbuJXT5QBc0tNl+zIR6Kt/bG3gXBpHc1j8Vze9EEdGOQ3R94P39hBcsjifZqXDpcMzk5fos4b9nD7vcV7B7EsyWlWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u00qoDBdAGW0JGm/dcunSrWRtUIddYZAsEHgU5/auDs=;
 b=GBLyrkVEPzJF02uBpEAbGodxdiO3oX7LMQRvtN472PHEfroGIPUB5IcRb/SF1BbFsrHAFo2l0pGcgmpQ6+FkJlReS3XFJYmf0y3vzsMC3+lgcoSxjkEkOmGhPJb8GaLZgx16VislO4TeISA+gSF+Wst/oRusl0CqlIep5CzQF4k=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB4347.namprd10.prod.outlook.com (2603:10b6:5:211::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.21; Tue, 7 Dec 2021 02:51:31 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041%11]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 02:51:31 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V5 12/12] vhost: allow worker attachment after initial setup
Date:   Mon,  6 Dec 2021 20:51:17 -0600
Message-Id: <20211207025117.23551-13-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211207025117.23551-1-michael.christie@oracle.com>
References: <20211207025117.23551-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7P222CA0021.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::20)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DS7P222CA0021.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.14 via Frontend Transport; Tue, 7 Dec 2021 02:51:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0f4aa0b-bac7-48b7-33dc-08d9b92c78e9
X-MS-TrafficTypeDiagnostic: DM6PR10MB4347:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB4347B59C7CE7F8C5E14CEA73F16E9@DM6PR10MB4347.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8n9n5LdCtmGJJjWZkumTIEMIN/uxglk1h6wzupgLjq5o4aRU9xJ9h0F0D2WXcn8G8ag1Uf06u+iIAeQEkkFSRkBiMzvkcJS+fdsQlEo/Ks6jEAFNk5oSxQGH1P5zR4ySoXbYbZ9iQNOkKfG8Y1MLqQr03C+wvU2a0cvX3iZEI3myTlxyVVGeaP5WE7AMCzwPXaFk+nud1YrEeTYyUCNxu8Es8Vd6y8jIkkOJFmOtPPiRbC9SUPvNABIZwlhHdS7fxatD+Kpv2FRPZP7C3QPcWzA7Pj21dLX1HR9bTB/Y2bDMtVtqay+yi2mSnf9RMNZwuUydra+h2s7x0S5Ov+Bugw2RqkmtrIt0O3iqP2M0RWSNM39JNSK1BA7NiBMNnfKYSM8SD7zYeaLJ8u5VH+kQxEbcjcEZCtwWanfrjh5g2T2IwE4VawVEhElNJ8ZEnrInGARriR8PQQsNV3ob030mubXmH+aLl5wsNLSJdYdDzSp/vVUzX2fv/G58tzJqILnWwSeMjNqksIvp2CPPzz0Q3JodTAPjbBMb2L4GAE5kK1u6k0/Qxuf68MO5Q++rRxw7cDqdNWPEoUK7B5UIdhJMu1YA7OnbVw/tXmqVi2xhhQk8vZLGqFCBpiIQpz4caDq2wy4rsKN5Pm2lCi25RWDOVwz0dtV+jt/+DDKdJvu5+D3YXFZUB8tSNTbQeI74aeFnTUhopBrSGnlUn7mfZJ6GTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(6486002)(956004)(107886003)(83380400001)(4326008)(5660300002)(1076003)(2616005)(508600001)(2906002)(6512007)(86362001)(66946007)(8936002)(6506007)(316002)(36756003)(8676002)(26005)(186003)(66476007)(66556008)(6666004)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TPngyCTHx55RjRh/QX222ZjWgdmwyWat5E1cUhJAioEy0R4g4VEXXtbVMP10?=
 =?us-ascii?Q?UNimzJsv6fAJwb+ipAwE0Cc867PEMp9SyF9lmpI8XAyNnzx8AEtK3asJqZxh?=
 =?us-ascii?Q?L4oek421Y72QQc760wsBavy2ro7/UfbDQIsJ+hPTSyEG6RwE0zOttLtYkuef?=
 =?us-ascii?Q?oM3g7Kym38V4a6RNDzipmwysKWOit40ijorskmAIL4sZM2rnswKVPpeMamnB?=
 =?us-ascii?Q?MlsS5qStkrBMEqMF2pyyCT9r1CEcRGVw9abOVk3ad5BWNdEMEiO146HtzNVH?=
 =?us-ascii?Q?5sRHzSEPNEHIyBUcvXMiTUvYVvVkwDxovk8VBMLCn/SQhGIxQ/3VKCM3oEdi?=
 =?us-ascii?Q?ULCcXvCbt7HgB7uige4argoFErflWhd1oSt9xpOWPECX+byK94TbA0lqRSof?=
 =?us-ascii?Q?TvNTjh7ypZGYf1uHhnsXlsyrc0bp2+2Q1gjQrHYiKzGTOJRgc5EJeRhl+09Y?=
 =?us-ascii?Q?XhXkwgdMUw9/hYkzDRMO7YWFtaFMNt9Il6vy3QpfDUqm4SDuS9/W+sU51N7D?=
 =?us-ascii?Q?KcSnSKoR6voCglaQZ0cSS+a3os5Vncc8BqJ+fW8c5rs+YE59XLAGgdqHhoOb?=
 =?us-ascii?Q?ywb9dfEf7Pfpc8S6JCe710cW90iqkj0ycX0SBuQtTqR/Ri5VDIjzh5hk8LFY?=
 =?us-ascii?Q?fpp6E3o03DjT/94XzgY8DyAKj2XW88y6N7kIyZBUMHBSwuTuQx1GzoqO3KJ+?=
 =?us-ascii?Q?ksbaSFCdckxE9809qmloSUvput6efRNy+JG7NOLqTZwU+e0NRtfY4yzYWvIZ?=
 =?us-ascii?Q?5i5jg2lEke+j8q7PMMpC+viDkWCTsOx9azwCEi02CI2UhvScXu0J+wkviUPJ?=
 =?us-ascii?Q?mCsdum/NYzHpi37+oEcyeGeZhA/5NW4ya6vNkF/YFHnu+tFKjliwcpNx9TZ2?=
 =?us-ascii?Q?wUWHaE2ScBhs9IOygRoOhYACt/v0syZ9I1cukIptcnX4/O0Ur4+Zq+Bz0wIN?=
 =?us-ascii?Q?Vm/Jv8onIKIYhsDJV+AnbxIw7996b8YlVjLt6Va4x82SaT7WA3z853EZEv2j?=
 =?us-ascii?Q?lKhZclgAk0xEJQWfJIQKf1LzwBGyxoBpyJymChoWCaUbp99pTlvq0cxJNd2J?=
 =?us-ascii?Q?fSFg0JQsf7Mflu0ZR4HYPCcVl35HS9rBgyij7dao9Mwt+txDzHO/24S2yAD8?=
 =?us-ascii?Q?ZvvSvk5SeRdzRgGs93As7/yqO19UVI8AURwrJQgxbSDPI1hCXe3nxDySne8V?=
 =?us-ascii?Q?uzCzaW3jjhpbOnQW7vrcB/Sab8GQFnRNZs/ZfQMA8me5T9X5RRJwaWF3x9Px?=
 =?us-ascii?Q?JTrAaVXmnxMOSTGxAMIN/iXHsZ3iOkfBlEsZ71/GwXTprKEpiKCNHF0vgh2l?=
 =?us-ascii?Q?un26r8cy4CWCQQ095OPP/L6fvGGIbqXzo5QNMxWtJZ1V0mzygpl4MmtNwF8L?=
 =?us-ascii?Q?66m7dGVxlo1KqBjwoLKU5H3iTcTE4vJbTFXg4RRp9TzPTSO8o3BBPcFCQZur?=
 =?us-ascii?Q?LvWzJUOWKVrj7/87oUXmVJyIhDlHFlimHojbAIrQshbzdwU2gHrHNMpD7uMM?=
 =?us-ascii?Q?jufG5RV0P9wTIEdqjo+p1nfjSzJmFzJR6VCMfdiaSXiXqFmWZ/ZmcZpUgMtF?=
 =?us-ascii?Q?JDmUfbfWtp8itJs0sNTgOaY/FjUEG4ERUEMc+voyYXjbvAkANCq+hKtBHAld?=
 =?us-ascii?Q?SAyI4MfSkoXXX/XMT171nw2clhRJXL+yBdDvA+MjeeaDJyYLCqAFZq+0TEck?=
 =?us-ascii?Q?fFmcnQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0f4aa0b-bac7-48b7-33dc-08d9b92c78e9
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 02:51:30.9173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8YPlwB7DYY79dyPVnlzmgsY3x1SHlsXgq3/iz/9UjBbsi2d7JF17vflNzDPcLaO3jCUHnR8N+DT2ttmd4+RrS8EnuqOl7tPlf3wZLP6df7k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4347
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10190 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112070016
X-Proofpoint-ORIG-GUID: KrZ0q4GwPO2-SNBqtDAKGNzhAOPgLlHc
X-Proofpoint-GUID: KrZ0q4GwPO2-SNBqtDAKGNzhAOPgLlHc
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch allows userspace to change the vq to worker mapping while it's
in use so tools can do this setup post device creation if needed.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/vhost.c      | 76 +++++++++++++++++++++++++++-----------
 drivers/vhost/vhost.h      |  2 +-
 include/uapi/linux/vhost.h |  2 +-
 3 files changed, 57 insertions(+), 23 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 1af43b5d1dbd..f702df0ce33f 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -232,12 +232,9 @@ void vhost_poll_stop(struct vhost_poll *poll)
 }
 EXPORT_SYMBOL_GPL(vhost_poll_stop);
 
-static void vhost_work_queue_on(struct vhost_worker *worker,
-				struct vhost_work *work)
+static void vhost_worker_work_queue(struct vhost_worker *worker,
+				    struct vhost_work *work)
 {
-	if (!worker)
-		return;
-
 	if (!test_and_set_bit(VHOST_WORK_QUEUED, &work->flags)) {
 		/* We can only add the work to the list after we're
 		 * sure it was not in the list.
@@ -248,21 +245,32 @@ static void vhost_work_queue_on(struct vhost_worker *worker,
 	}
 }
 
-static int vhost_workers_idr_flush_iter(int id, void *worker, void *dev)
+static void vhost_worker_flush(struct vhost_worker *worker)
 {
 	struct vhost_flush_struct flush;
 
 	init_completion(&flush.wait_event);
 	vhost_work_init(&flush.work, vhost_flush_work);
 
-	vhost_work_queue_on(worker, &flush.work);
+	vhost_worker_work_queue(worker, &flush.work);
 	wait_for_completion(&flush.wait_event);
+}
+
+static int vhost_workers_idr_flush_iter(int id, void *worker, void *dev)
+{
+	vhost_worker_flush(worker);
 	return 0;
 }
 
 void vhost_vq_work_queue(struct vhost_virtqueue *vq, struct vhost_work *work)
 {
-	vhost_work_queue_on(vq->worker, work);
+	struct vhost_worker *worker;
+
+	rcu_read_lock();
+	worker = rcu_dereference(vq->worker);
+	if (worker)
+		vhost_worker_work_queue(worker, work);
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(vhost_vq_work_queue);
 
@@ -282,7 +290,16 @@ EXPORT_SYMBOL_GPL(vhost_work_dev_flush);
 /* A lockless hint for busy polling code to exit the loop */
 bool vhost_vq_has_work(struct vhost_virtqueue *vq)
 {
-	return vq->worker && !llist_empty(&vq->worker->work_list);
+	struct vhost_worker *worker;
+	bool has_work = false;
+
+	rcu_read_lock();
+	worker = rcu_dereference(vq->worker);
+	if (worker && !llist_empty(&worker->work_list))
+		has_work = true;
+	rcu_read_unlock();
+
+	return has_work;
 }
 EXPORT_SYMBOL_GPL(vhost_vq_has_work);
 
@@ -507,7 +524,7 @@ void vhost_dev_init(struct vhost_dev *dev,
 		vq->log = NULL;
 		vq->indirect = NULL;
 		vq->heads = NULL;
-		vq->worker = NULL;
+		rcu_assign_pointer(vq->worker, NULL);
 		vq->dev = dev;
 		mutex_init(&vq->mutex);
 		vhost_vq_reset(dev, vq);
@@ -587,11 +604,30 @@ static void vhost_worker_put(struct vhost_dev *dev, struct vhost_worker *worker)
 	kfree(worker);
 }
 
-static void vhost_vq_detach_worker(struct vhost_virtqueue *vq)
+static void vhost_vq_swap_worker(struct vhost_virtqueue *vq,
+				 struct vhost_worker *new_worker, bool flush)
 {
-	if (vq->worker)
-		vhost_worker_put(vq->dev, vq->worker);
-	vq->worker = NULL;
+	struct vhost_worker *old_worker;
+
+	old_worker = rcu_dereference_check(vq->worker,
+					   lockdep_is_held(&vq->dev->mutex));
+	rcu_assign_pointer(vq->worker, new_worker);
+
+	if (!old_worker)
+		return;
+
+	if (flush) {
+		/*
+		 * For dev cleanup we won't have work running, but for the
+		 * dynamic attach case we might so make sure we see the new
+		 * worker and there is no work in the old worker when we
+		 * return.
+		 */
+		synchronize_rcu();
+		vhost_worker_flush(old_worker);
+	}
+
+	vhost_worker_put(vq->dev, old_worker);
 }
 
 static int vhost_workers_idr_iter(int id, void *worker, void *dev)
@@ -608,7 +644,7 @@ static void vhost_workers_free(struct vhost_dev *dev)
 		return;
 
 	for (i = 0; i < dev->nvqs; i++)
-		vhost_vq_detach_worker(dev->vqs[i]);
+		vhost_vq_swap_worker(dev->vqs[i], NULL, false);
 
 	idr_for_each(&dev->worker_idr, vhost_workers_idr_iter, dev);
 }
@@ -664,18 +700,13 @@ static int vhost_vq_attach_worker(struct vhost_virtqueue *vq,
 	if (!dev->use_worker)
 		return -EINVAL;
 
-	/* We don't support setting a worker on an active vq */
-	if (vq->private_data)
-		return -EBUSY;
-
 	worker = idr_find(&dev->worker_idr, info->worker_id);
 	if (!worker)
 		return -ENODEV;
 
 	refcount_inc(&worker->refcount);
 
-	vhost_vq_detach_worker(vq);
-	vq->worker = worker;
+	vhost_vq_swap_worker(vq, worker, true);
 	return 0;
 }
 
@@ -1826,7 +1857,10 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 			r = -EFAULT;
 			break;
 		}
+		/* We might flush worker, so we can't hold the vq mutex. */
+		mutex_unlock(&vq->mutex);
 		r = vhost_vq_attach_worker(vq, &w);
+		mutex_lock(&vq->mutex);
 		if (!r && copy_to_user(argp, &w, sizeof(w)))
 			r = -EFAULT;
 		break;
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 1738388fa02d..7903ac6bc92d 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -81,7 +81,7 @@ struct vhost_vring_call {
 /* The virtqueue structure describes a queue attached to a device. */
 struct vhost_virtqueue {
 	struct vhost_dev *dev;
-	struct vhost_worker *worker;
+	struct vhost_worker __rcu *worker;
 
 	/* The actual ring of buffers. */
 	struct mutex mutex;
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index 117ea92b3925..e0221c8ce877 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -88,7 +88,7 @@
 #define VHOST_SET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x13, struct vhost_vring_state)
 #define VHOST_GET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x14, struct vhost_vring_state)
 /* Attach a vhost_worker created with VHOST_NEW_WORKER to one of the device's
- * virtqueues. This must be done before the virtqueue is active.
+ * virtqueues.
  */
 #define VHOST_ATTACH_VRING_WORKER _IOR(VHOST_VIRTIO, 0x15,		\
 				       struct vhost_vring_worker)
-- 
2.25.1

