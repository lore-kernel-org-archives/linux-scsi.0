Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AA18C43217
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 05:21:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 339B86124D
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 05:21:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbhJVFXS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Oct 2021 01:23:18 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:55058 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230428AbhJVFVw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Oct 2021 01:21:52 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19M2lxtB016493;
        Fri, 22 Oct 2021 05:19:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=fspmCOXmEpt+I2Zli2AQcYiLadL+u7tR5vrwNrLtu8w=;
 b=jIslBeu/znzJ0syxoFEXJwiTfxKFw2Ijj+AYLj4aThkRqOnFmdWehdZ++Y/5Oems5k9y
 QRUT50Ny709V+OkAjirMNyRJ64QuzYMeWeqdJQauRzvP4wDJ4NKqZEbVMGk1bXbEAeLW
 bzC9xzh4EYnqeKBo0at3iKYmRpbozJqAj+chwtM8yAAnw8cTlSSjzQ3BBKyswCPo5E1k
 UXFvh/VWO1i1JksTUm9uzQhOYWsBTiargMPVVgFnd/Zay8+EXL53N8nhCA9a1tkSbAcF
 +pGiiLTUP7apzDJW8nH0FH+yGD0mX8qRpoWIIBeJJzShkPpJaT57dvWvGDpMGCB2/yYi AA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btrfm8sxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 05:19:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19M5BHIj139141;
        Fri, 22 Oct 2021 05:19:31 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by aserp3020.oracle.com with ESMTP id 3bqpja16nf-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 05:19:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZPpHjE1IxZmpg8dePmCtzX3lksDjphLcTjoUPfvgpvfNwrYyC/TbXsY2f3PSPZ461aDeSqzpzPNARjJqMtzXPoI8pcN55Pq/8r7xalSG4VleS4n4xNbvtrwh7eV7q7nACNC3MzX8uXlP5GGNYujATjzUmdZISkPm85GfrRiMCjX9dfwYq9ZjrVZl/BnUHweOJeP6FHR4jtOBOlkfqyy6qLCejSdd4jLfuYsCPsyJvJ6D/D0eL/4ZvxL9qWUziO8TQ5yi9oYEVSdb1aw4MmRxw12f3km/IdottnuqCmXZJbLDjd7VbaJRUtaa1E7HyFcGC+Q3DIFDsftW2aFnb9QUeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fspmCOXmEpt+I2Zli2AQcYiLadL+u7tR5vrwNrLtu8w=;
 b=mIUZwH4t3qkGbXFznAhHGVCOIOWXjryfuaEwFzeXb++34p1kVRnqN7dttKrYiOIcq/1yhRdCxQAz7pJwiaO7KsIobzE74CSfoXC5zWyZc32RoWHI1eeWU7dibc2pCzHXj6TQUoApqH8vFjMd0dbQXNF76zkME2ed+U+IjgNbK38EI9M318AKJhMj/7H+TzVR+ou6taQ0QuQdW+vMkGc7SFwQljGwoCg8QptqAyyd+Qk98AsW2vA9i2dc1hkoRsNwuZhq2fDMp6GhKT3a7elavlZIiYC/DGfeoBVj2UYz+OvfFiNUptv5MiKPy+yBU31Hh5p7s6fZ+xG3DVGTe8LDlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fspmCOXmEpt+I2Zli2AQcYiLadL+u7tR5vrwNrLtu8w=;
 b=kO+R9JyciXyrTqZ4dnIKhD2IV3RY685PprDuofId3LfUEbFk/d7SZlqzybO1d9sUrrHXpT/2FjDuU/HZPXnq43KeOuX1HikcHZQKeEvowqkLRcjH0wpXMY9Ijccnew6LGfWdyLjSdIB8m3JevyrJfPGpXSOA85t9AjiXb3NcnJs=
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
Subject: [PATCH V3 10/11] vhost: remove device wide queu/flushing helpers
Date:   Fri, 22 Oct 2021 00:19:10 -0500
Message-Id: <20211022051911.108383-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022051911.108383-1-michael.christie@oracle.com>
References: <20211022051911.108383-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR08CA0012.namprd08.prod.outlook.com
 (2603:10b6:5:80::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DM6PR08CA0012.namprd08.prod.outlook.com (2603:10b6:5:80::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Fri, 22 Oct 2021 05:19:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29dee8b6-e106-4484-e506-08d9951b8654
X-MS-TrafficTypeDiagnostic: DS7PR10MB4974:
X-Microsoft-Antispam-PRVS: <DS7PR10MB4974E900196A531AFD203ABCF1809@DS7PR10MB4974.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:813;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ptSYYqs/iFeTc8sCSVgzyNaJ3VvY3zagY44zGDtZauOOLXtDhu3ZEUyf8HBd7Ie+T6/kDiTn88UcZIMCZ2xHPVdaHKmC5dDwIaL0ndOSbulHZBNuI2ofMK/tq3le91A6cupvvWuezWk/JfdyQMlDiY80UY329/OuDVDJklmxdb5CYKSJiPdh8a6I5OULprbdNV47vuIv9wUwLb7wvpVzt9lJ9H4f91P/tbes7EkKFFB4H+fduuvSiniMnWjwj8s/9GQ/xu7z+g2MZjY/SvmXTUTvYWP8ueoGCg7OuCN355nKOOa0Go/svFTyKPwDnZU47nr2COBP5waexXrtZWH2ZYSk5o/3XP2St7TfpXa00ul3In2tEtQNNDdw6vNEJojM8sU0xoVrfM/iuwCGMdRTjnvw8BKNvSqGYMfW1JMwF9zQYe+dmDqwk3I980LW7ShRif3COmXJbqh7jKwz7u5eVt/l+5MIvEwvkRqllwUouicJiMZ1eD/L9XJWlYOBd4hFJwHLpHVzn0qvNyuPLeBx5zFFqlq9hYgZp5fyCejxPzQ6tluT6PkgwASHZKC8dA35mmz5HbOtIV94fB3jzgwODXXBjbt1zVeopZJ8M0oX+b4eO/Xlet6toWZphYRJw/rKQIDX1L7qUcRrhqEyxpzqLMIx1L4azJnem15TGtM9HZM2BgyGsSOOVZBEfuudYyaV/LDpZni4x4+tp2JpzZ8mGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(107886003)(38350700002)(66556008)(4326008)(36756003)(6666004)(1076003)(508600001)(2906002)(66476007)(66946007)(8936002)(38100700002)(316002)(6506007)(186003)(26005)(6486002)(6512007)(83380400001)(52116002)(2616005)(86362001)(5660300002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8xzvUgQyx770zfJEKy5KOjbxNA3aQA1G4WGMVaVGSnhM68BvRcLqSRAUism2?=
 =?us-ascii?Q?DzsOzhxj+ANjwt6HDSXI/Pf5cTj4rmWkSD40VtulY/Rf7eO6aTeR79U2mGei?=
 =?us-ascii?Q?AblnxNNjkLwJknYmpNlxJFF8mE3YHlF81A9Yg5YhLpYf229lDLB4vBXZTrip?=
 =?us-ascii?Q?ND7zYCy+c6zGDAm69ii/r2E1QDVQj7wJFfDgQaCcB+2gawp/6HqodLcrBqEA?=
 =?us-ascii?Q?q+8/v1setSt0bBLPp6q4Wu4Kwbc+Zpi0XcCViu97TpRj5kX+Vze1195pzjfE?=
 =?us-ascii?Q?yT5LwpZ8rmCkaOVukUBZqndTbk5DbhtCBKcQv9pbz1COy1ScPZbQDEo4hU1N?=
 =?us-ascii?Q?/uFdBtblRG4aD1vZ9/aXzS2qpEt0Gx7fG/gPQHboWO96t7fGpTIHYBSBT/MA?=
 =?us-ascii?Q?iVUy5K+FKUvtHem2KPsiW3MznOIxjVsp66E8WUy5uQAX3SEvZ+QWSSjtX3I2?=
 =?us-ascii?Q?hh4OnRtxP+hrY8oHoviUeenSkhqUIHtzqrZmGGd6F/CyL4d9vv/4E4oUo3+q?=
 =?us-ascii?Q?1K72ojyG/d2Lpw1Z+BP9+hokxqJmDtmJU5EAipXnFLjrk0CrXelqRsdrxMED?=
 =?us-ascii?Q?sWNba1Oww5Mhf9eqOgaEtaeJT0PxC+rm0t1E9FAnd4L2uYX3qlyVV5BrxVHh?=
 =?us-ascii?Q?jXgqGho2xlI0B76Q8a9aL0IHVFV3YUr+NF+2jFffp7lSpJpFN41J4wBU+fap?=
 =?us-ascii?Q?M/5o2YZZTBgN6PDnZ+E7EmPZTLNhD1It5Ccpkut8NQamOc9hcFJcliykeihN?=
 =?us-ascii?Q?CjmzWutKDZX+YKLlNGU7bKNC6h4ZawznKRzMZ7JW4PaACxQjjpJQ73HUtU7p?=
 =?us-ascii?Q?F0wEdlPOG1J2z0q70bFXHysYvgSiVGjZRr/WcOIzq7yeAFoeCv86m1GRxz4J?=
 =?us-ascii?Q?34JZQH+9xfPv0rUmwXi8f3LVrB4i+/BNVmVtR+8t61NDmRYgXac8VNCL+zHV?=
 =?us-ascii?Q?92hOS1N2PjM9O1U+DWVDlZJZIUwuWo4V1MjoR6T/Hb0as+Ap0L6MIo3k7Y7+?=
 =?us-ascii?Q?ld6NAZVFpoS8dlQ4ik0ejhxCQxfdaCvxgAKkoY8SYdR+9K4D7xf/X3FE9wZR?=
 =?us-ascii?Q?285061xQFnGoLk/08WgqczkVrS9KDbQ8PXLnQaLLQqJv9BjYKrM6717xYYba?=
 =?us-ascii?Q?LUXfWgbUE6hgKGyPXaWEcZdc/AbI0Rh4JqQswCusHxiE9UnEKuZqPtPYQjJ+?=
 =?us-ascii?Q?jT6+wiM7CFpPgPxe0jEOzl7Q0baUQDjr5zA6h04nKeBfYlBhBvuFxNj6OzQ7?=
 =?us-ascii?Q?+F59r+THo6Aqvl8mm1QzJhSkvQAlRSXolXa4LP5WK9FaWZyNoeGaVINRf4zZ?=
 =?us-ascii?Q?U72lrDyHWug2Hyr32e2TVlps+yZFuIJWYZKocBtQF0DSPbTBZo0o8cDMa7YM?=
 =?us-ascii?Q?xcpPZbo0z+fJH7zxMff7FLnJHqwRB3if8NAU8TcrKvGKMNQW7fkylf2B+DQq?=
 =?us-ascii?Q?+LSycNQ+cimpRfNG0knwXsxMmg2GZtDN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29dee8b6-e106-4484-e506-08d9951b8654
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 05:19:30.1321
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
X-Proofpoint-GUID: nJRjA_Zh2jCWSmzoJzALE6WRGxJg97qR
X-Proofpoint-ORIG-GUID: nJRjA_Zh2jCWSmzoJzALE6WRGxJg97qR
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

vhost_work_queue and vhost_work_dev_flush are no longer used, so drop
them.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/vhost.c | 12 ------------
 drivers/vhost/vhost.h |  2 --
 2 files changed, 14 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index c84024afefff..04f43a6445e1 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -268,24 +268,12 @@ void vhost_vq_work_flush(struct vhost_virtqueue *vq)
 }
 EXPORT_SYMBOL_GPL(vhost_vq_work_flush);
 
-void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work)
-{
-	vhost_work_queue_on(dev->worker, work);
-}
-EXPORT_SYMBOL_GPL(vhost_work_queue);
-
 void vhost_vq_work_queue(struct vhost_virtqueue *vq, struct vhost_work *work)
 {
 	vhost_work_queue_on(vq->worker, work);
 }
 EXPORT_SYMBOL_GPL(vhost_vq_work_queue);
 
-void vhost_work_dev_flush(struct vhost_dev *dev)
-{
-	vhost_work_flush_on(dev->worker);
-}
-EXPORT_SYMBOL_GPL(vhost_work_dev_flush);
-
 /* Flush any work that has been scheduled. When calling this, don't hold any
  * locks that are also used by the callback. */
 void vhost_poll_flush(struct vhost_poll *poll)
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index d9650da2be2c..33c63b24187a 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -50,7 +50,6 @@ struct vhost_poll {
 };
 
 void vhost_work_init(struct vhost_work *work, vhost_work_fn_t fn);
-void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work);
 
 void vhost_poll_init(struct vhost_poll *poll, vhost_work_fn_t fn,
 		     __poll_t mask, struct vhost_dev *dev,
@@ -59,7 +58,6 @@ int vhost_poll_start(struct vhost_poll *poll, struct file *file);
 void vhost_poll_stop(struct vhost_poll *poll);
 void vhost_poll_flush(struct vhost_poll *poll);
 void vhost_poll_queue(struct vhost_poll *poll);
-void vhost_work_dev_flush(struct vhost_dev *dev);
 
 struct vhost_log {
 	u64 addr;
-- 
2.25.1

