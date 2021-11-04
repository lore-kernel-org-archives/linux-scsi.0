Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A92F6C43219
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 19:05:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9384261215
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 19:05:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbhKDTH6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Nov 2021 15:07:58 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:55514 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231823AbhKDTH4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2021 15:07:56 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A4IEb3P032488;
        Thu, 4 Nov 2021 19:05:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=3aJDenUEDyOoOTfoekDrWXg24pA1mwwyDffqn29hT0U=;
 b=vLMvk4d6XbrNR8prJjqNrXj6RfUrOWQDLtCOnuyNYn/K3dhhNO0tRg+EQwZz4iuSLm+F
 WP09w7YFECFwG318VtktNyUaB3lpkg9g8tJo6iyW8uP6vyeVSIXzGm4owY+cGixhNk6K
 hfilX4+VKjxICoeIgEtx4VEzZNFiw38YtmYmnb9boNiBnQgp1xIDy2AKwhIgod6Ol9ly
 YFc5pSWHzzqm+E64KSQCcYzADjsASk5HhtcOcF6qtnOetdTOUtqjxdJs6HXu058/U4MT
 XixnGUhdsF1iIUDPbAn0s2caegMphEryC9e0yBL57VEBp3+VSyzea7EsZk/rYitZeCAJ nA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c3ju73acm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 19:05:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A4J17XZ042421;
        Thu, 4 Nov 2021 19:05:13 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by userp3030.oracle.com with ESMTP id 3c27k94tdc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 19:05:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YIcwZcIMgaDIEXVoX3SN3D2L7pmWoz5eBowW4nO6pRxYSJlRPYC3l45AYsILT4Q/MjZk0dWTMIz4CBgGNoK6RjDOPJUwNmGuZC5pRfJ2HgdbD6SyMfuG0iDfG2L2zHKUJfSDVr0GOy9+tLLqizK8jtFHgGuJ12tmIg3zEusF4iZysk65Zkr7nWBiGAP1rgarBcH91shSNMz74/ZCVmfvWo1VUFLZrDd4o/tlJ2P6clh559BKJEN0YC+hGDxZgQ/BQ27PK+de9ik3JZCx/pMr9TQJzOwh4WoE32OdlTzzDMYY4+93pmVmUBS/FOv5gzHxbqm12Yz/oWY1imXdqwzNAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3aJDenUEDyOoOTfoekDrWXg24pA1mwwyDffqn29hT0U=;
 b=hVeSZAgABGibShtXObbX7/pRWm+eChAvcGihBm5Cfsra5H2QrjYMQLJIphmd4m3+aDAw+YpjJ5r4L1Z/jY7PFJiCWh95ZDaahROax3eXljl+HFW1Ytg/ZGVQy6CtSg5iE4IDbcV8g4lkVar4qWS4jknODsqVRI2v69Le3aXJd8/ryMrz+PRgv7YHou1ym1YnwC7fkgNJsx9inkwZSL7X0iCf/pM+tZfQnCi8xejAR5aDuTWolv2IZpyKpstFsjKcWRCLWN2I2MJu0dpZ++thH4iplwEolMO/h1hhSfetS68STH7O72PwuB6bQgxAWwXG83bcLy2ViI21LM9CDdT0bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3aJDenUEDyOoOTfoekDrWXg24pA1mwwyDffqn29hT0U=;
 b=y9C/a7dsfbhInCRgp/XcxJJiCSMK//PdHL0XpcVVsNlJYYVpKoH7NZitai1QNxXw/7zazZyt/YPYda5T4drguthsgw+9MvjMV9mpCxs2rMh5Prm2sHx2zQwoGExrLQeoGTzFpcpu9z0x78y4c/Wv8TXMFg13lomTse2MCoQmY5c=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM5PR10MB1595.namprd10.prod.outlook.com (2603:10b6:3:13::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.11; Thu, 4 Nov 2021 19:05:10 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041%11]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 19:05:10 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V4 01/12] vhost: add vhost_worker pointer to vhost_virtqueue
Date:   Thu,  4 Nov 2021 14:04:51 -0500
Message-Id: <20211104190502.7053-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211104190502.7053-1-michael.christie@oracle.com>
References: <20211104190502.7053-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR07CA0080.namprd07.prod.outlook.com
 (2603:10b6:4:ad::45) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DM5PR07CA0080.namprd07.prod.outlook.com (2603:10b6:4:ad::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Thu, 4 Nov 2021 19:05:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 014cdbe8-367e-495d-818e-08d99fc605f1
X-MS-TrafficTypeDiagnostic: DM5PR10MB1595:
X-Microsoft-Antispam-PRVS: <DM5PR10MB159506CE24E9615D6F294070F18D9@DM5PR10MB1595.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Oxt+utEUkH5ogAKhrMzQTejltitVgOWCcKSyyx2hJVrULTD8lArpRUi/Vk1jbgtHDMOzVohDgaU1T8kCP05A9LRh2RIxNtp4EoiOjAEH6pdYs4XErZGbwQQ+WAmlk0FkExWXryFOY2nyGLC0aLFuxEjMMP9DdoeNDNs2+BclFhHhygnWpXwphcqrXLOEQgwXB+OSTM9L9J/SpPjDzd42fL53DNikkSws85PI81N29ivhWm0TTNy9gfnsD7ROzA31WIJGw4x9Wq/6yfQwiWiK2gJCnEBcZNF/GQ0ojR6PWOter377aebBwzLrmihRu6G0Dn+dIQ7pdYpn9WvCOvNfP2UZ/C4kX3NMcCMqT1uz9HoS62+7KKUgSENEnVKmkXyv96ZLm3LpTzxTvyeHoKg3tY8fIxtyH5nfVmf0fFJ7U5cp2xiVbw0dwQfXnALu78MA0XxEVClmelp6sKeIrV66QK2Zz1fjqzHWv/WJLnOxTkj1TgOkBZ6ykXBBevbG60HbsIEUpGoj2H/kg8DkxpDHmo+rJWKdultUHrAnLf0aDq2XsDcxau+9BhS/5mInyucZnnFRuoWJm1r1+HBngnV3yj63L0mi4YEfejdVB46xfoJdlnMGBv4dNPUkjSlANrcn3AALVaI1DKR4ulKdjfoGzfqVO2mZSCEDWW/QLiyr8yQrr5k0hehHgpQ6/T1wVkCBEQ4BIbwmp+76KXYd266PYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(107886003)(66946007)(52116002)(5660300002)(36756003)(508600001)(6506007)(66556008)(2906002)(4326008)(1076003)(66476007)(6666004)(83380400001)(956004)(8936002)(2616005)(186003)(6512007)(38100700002)(26005)(8676002)(86362001)(316002)(6486002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AZ46gQ/qlOyKc9YYyHtSM+GLmzIXX3//48dXokYoApsf9cHK/ioscSIbgKLg?=
 =?us-ascii?Q?VIko1qFRsEYYvuw6ECjOvPXCH6YkVshUTFc/c8Rr+pHdFYsDxUw2cNKZGWw4?=
 =?us-ascii?Q?9lJr0hI+eQJsrUp+WThSyW/NeOse7kMEnSrTZYJUUps4IGCardtgTazKmBJ/?=
 =?us-ascii?Q?2hdFou5PUk50l0LNuL206ZgEVvSYdyw8agVRJotdR1Hu6GIrLK6nTy7aehPN?=
 =?us-ascii?Q?jgfPvQRPqSmd0H671b3QyaziP58/QQUovrbIWNsQqdyfI73dGss8lWA2YfZT?=
 =?us-ascii?Q?/OYjte2PsXPXtCLDQmwYurB2pXmJsNknxVvWoaALy1MT8EYQJgmiHCPkHZRW?=
 =?us-ascii?Q?y2O+BwGEuLWCW2LYR9qmyFv0gx396yg/VZd9UsM49aUgu0P3JmHsdhO6+W55?=
 =?us-ascii?Q?rj9p+q0x704f75tCbViq5Xqs8AFb6Ep7fCN4nGZ8gEdYGmE3Aqv1/z4dxkH5?=
 =?us-ascii?Q?uayLZ6N/mE5rVS5xAuDCJXagURqNwbbs6c4GTV64qwQZNWYVQo/7QUi7VixE?=
 =?us-ascii?Q?vzJy02ePbG4bJz8LiR7KLeQVzeUpFYa4iQOV2qmrhCEto/g/RxOa8mCAedyT?=
 =?us-ascii?Q?kSvhyoKr20usZD/lgDZ5WSD+V+vdf8UuD/be3Cx1VMuIfb9vNX25KFKfEnSJ?=
 =?us-ascii?Q?ut8wrUFqg+b2fiLx+s3pjx4NvtfNpqzMtDBXn7LF1X3U/7uJcbKrULVsxkGW?=
 =?us-ascii?Q?g9tyB5lkNwz+ICjeja/ZS2MuNoOyxUUsTfzTkwBW5QYKaPPBuq4rShkBjhkt?=
 =?us-ascii?Q?G+HPFlTIjd7gwHQw8HTInYCKi2DP5V9gaVW4y52LGS3o0pq2TtSsUktyG9v3?=
 =?us-ascii?Q?p5A3c1JvI8PGaMpCKp9DT2+7mjsREDlBjv3fmpBLIh8XUeMwLsFroNkQp4wL?=
 =?us-ascii?Q?IRX+rxrJ9YvFCd2dqvWMLJP0rqTiUWjIcxf16x0qUiRfGVVMQ3UNhuLHYuXj?=
 =?us-ascii?Q?5uILIJGX8cuo3niIX5HBMzbLlxHKeHCVNCblqVR9oqSGn1K3saib63TbgM4r?=
 =?us-ascii?Q?JmV7x5vXS6lCAhTtbbH1TOuM9QdzHXE58OVGP+J6UdeGbVvRdpvCTcpu3gsO?=
 =?us-ascii?Q?YcYXBYsnVJsM1V6n4m5+h3jywl+RSsip60qv5LlM5HUQZ3vLLJTPv8KRy4go?=
 =?us-ascii?Q?diPheHBlGBKGLPnBNFzu88vBnutObPst7utljRVHU039vVF+jmr5lU797qpI?=
 =?us-ascii?Q?aqc1dxsTawVwLtgipkHu6iWhKeg2lEZE0e5LoAjsCFGyMWMXoXPDCuShtl74?=
 =?us-ascii?Q?ZVJzeKj7u9id0H7WPkkvWwu6nEgr6eGSDH4vReoxLqywQnRPN5OOs1V/JPAc?=
 =?us-ascii?Q?6cGDJbUV5NijTKO/oU4sj2XmcHd9QHSaowamcRIUqHmSeVmn4OsB97+0XH/K?=
 =?us-ascii?Q?+FESm0qT/wFaAlJZFf5skizDYnVOveipzV8Yy4bSjZE8wHaNLW2bSnGltkpI?=
 =?us-ascii?Q?J/eVvbZdh5DU26Q1VrJp4I5BKxtW5zboe0J9DG3GnE04bKm/Mh8MjEBDf2Ap?=
 =?us-ascii?Q?+XQp5dCsvOtySlDF0sW38i3NDD6+c2ZaL0wQshuwN2/luKSUtrpGZuxXcA0K?=
 =?us-ascii?Q?nzog3Em1vfzUjAmQjL39kfM1FN7mBG7InlMZnkgwcMy3OLM+nUCKERa1u1j6?=
 =?us-ascii?Q?BTzhkEhl8BoCHSTCt0w+X3O9Z/h11RSALdWRSEGtQFct6/dWvQxePAv1ClRc?=
 =?us-ascii?Q?FRp91w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 014cdbe8-367e-495d-818e-08d99fc605f1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 19:05:10.3519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TtmAFkTQMSFC6vNnDQxCPTC0OZVNm5efGnI6spNBffw6TusMRmZFT9LFykb7afc06jzEeRP4YCVcYfszr2/68wZlWjwPRzX9jrcjmxbmdFk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1595
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10158 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111040076
X-Proofpoint-GUID: EAoLvzligz_kDjxpkxnMn7HSRuZvVX5U
X-Proofpoint-ORIG-GUID: EAoLvzligz_kDjxpkxnMn7HSRuZvVX5U
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

