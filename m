Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64DE9C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 05:19:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4588A60E97
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 05:19:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbhJVFVt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Oct 2021 01:21:49 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:35414 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229478AbhJVFVs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Oct 2021 01:21:48 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19M3R0C3010002;
        Fri, 22 Oct 2021 05:19:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=i1K9Q+8wKKbVXZVifF2EhDXzLFqt2vHRHXa5/AqZccg=;
 b=NEFKk8RdkvtlwtuIOsAx6dXVkP6ll5DK4Gw7p9w5Qk83B3Jr25B2C9BLfMg1scVliRCm
 OFvc7S67lIuBQTGbE6KmQtMbHuVqpzHMMsHdkwtHfaAMG+3yVmTg0FFkPtZvjFawa5Dh
 Pwvf+H7aI4TxSuZBXBtGyK1KHlBvpr2R1e7oAJPeA9TmYAgExPRLiO5gzkQX08ZPnizZ
 I1Zi3Q7d6VF0cZr8tfbH5Vl+DPG4serifbQguSzsTKKex5vlVpp5X8wXZjU8T2IMDe+F
 Kr41RMDn1LBqiGLiFkxY5wMTxd+Hu2hsaC3mZB3koc6t+C2acqJm6TK44sPYFLxwqqXC TQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bundfg9e9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 05:19:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19M5BHIZ139141;
        Fri, 22 Oct 2021 05:19:25 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by aserp3020.oracle.com with ESMTP id 3bqpja16nf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 05:19:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WwdsViYEWmjSq/cTyfxZ01l84azbV/9HElzS5Bvg8m33/loGSkDx1o3H4IqIW4u4uwM0MncVvYvkT+2IfGEhiVvU8Mkp5y6SSZO494EM1xks7B75sJe8fi/yO00UMr64mI3YcvHZAUPBdeWmmpbuXmbGg8v/2raU4Q9eWivmtyeRRH2bhPrq5/AZkTTc4pn8Yk1F8gH2VTy56G3TkqAssy32J9sqPwt3bq5SyJoEHzkldyBvs392cgZUnDJhojjzg9GiqtwlO8tpZOkpTEd1lo2UogplWJVMNtxW5UBatNgn/LZTsr5MnKJrRV5rj25+KEf9juilR/k7lJNNqnHgdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i1K9Q+8wKKbVXZVifF2EhDXzLFqt2vHRHXa5/AqZccg=;
 b=NNyqWFFOPKnkGF914Di3bXdY1141JScO+L0bgFppncE7VXNCeMGP+hRxTqtgTCoMKjuD0ojI8Ut7fwzeWDmDpzgxydG87K0QRkewZaNkONxAlNXs2CkK+iih7yoHO5G1CBg25vTHEUlFumFJTFiSR3+zf++ZOwSDWFzQqC+OMHRJPdSIi8hT8v+Mi7NAi+xMo5xStTi+0WbCCLNaA7jjwnZJXpVpvB3fAm2Pcsv7qYwuhwwV8wwRzwS888DgfXOMCeCIEmGg2fXSxbf6NaTUEFXdRLefaXL4w8YpeCVM40J9G5/ecqRoBXGOzw5eny7TnFDF8KSxwOSuAzxGcRudhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i1K9Q+8wKKbVXZVifF2EhDXzLFqt2vHRHXa5/AqZccg=;
 b=IPOfpeZ5vrvXKhERB9j3VKwNTSyswAEU9kc4YsjKbZtGhinaBsXQv+9kiinvBx8h35zWxOmLfWZXEOzL3/TKHTP+l46CEEzvfD8bZN4QfQ3RmAmG8oc79KeHjFlKcDF1w8qEuZzUzOlvFgd83ZJe1fOqUmOq6jRBIJx09n8oFvM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB4974.namprd10.prod.outlook.com (2603:10b6:5:3a0::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.16; Fri, 22 Oct 2021 05:19:23 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4628.018; Fri, 22 Oct 2021
 05:19:23 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH] QEMU vhost-scsi: add support for VHOST_SET_VRING_WORKER
Date:   Fri, 22 Oct 2021 00:19:00 -0500
Message-Id: <20211022051911.108383-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022051911.108383-1-michael.christie@oracle.com>
References: <20211022051911.108383-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR08CA0012.namprd08.prod.outlook.com
 (2603:10b6:5:80::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DM6PR08CA0012.namprd08.prod.outlook.com (2603:10b6:5:80::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Fri, 22 Oct 2021 05:19:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f999dce5-700c-476b-17d5-08d9951b828c
X-MS-TrafficTypeDiagnostic: DS7PR10MB4974:
X-Microsoft-Antispam-PRVS: <DS7PR10MB49746C497379556B182EB9EAF1809@DS7PR10MB4974.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:272;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e4+JtirSTEzlVcppqHHNGT61le4K0OJkBsstbjyoEkvPoXHXg1SDNLvT026NMi97h6wTy23qZgCVEhJxsBYfxCqDFbWl//5LEJmDdiI/W8s1hh+42B5bLLCilt93NxeSlPtERYV0VBgLW5Ij71sHNt2kHebvbrWxM6LxZdmRIfAE0zZa4PF0YHA2pc2YNhnh7UsFpwpwwvf1ovkCaHHBZaLgSh03nE83is9AMTN9ZgdWSYisu42UHZXD8vuAn9XYZqIQmkbrJfe+wEw5icZ6JOjG1Melde6MMOl1Cc0jt09wAfVo+LfprwC4prgMH/FC38Z1O1LrZteNm9ZP/f03HoqW72Iy4gkjh92/qZukEY04A2grFsxguXDuylkBeg4ElPDvyMIWP9o52QqlcSogUgihkhVbA0RXE6AJs8iRBhDfY4Y2mvnYL0QWDIY/o27Gb8f+hyKWGjM4L3QoL0+pRIY7jwGKeNz6rEe4aN/4d8QdyTfLU+wRRJGoafPcDn2W8dzZ98xIEgmbCyapeGvmPIRyIoP2ax3llLbOx2yGMMNx+t0bCdiJeYXpfKygaof+Ynf6v+zFpN3TECjzvLuTxByOxlQ5Qi9XBTdhVnfpd44IGAhqxJTiMTZ4JcP1VdpE+9yo5nVQzlSC1PAMMXMDPdJ8jBYcayPk3Wb2DndjzwKvNB2jffUnfj11bnid2Sl04HVJrTP5nP4wshEBXAWLPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(107886003)(38350700002)(66556008)(4326008)(36756003)(6666004)(1076003)(508600001)(2906002)(66476007)(66946007)(8936002)(38100700002)(316002)(6506007)(186003)(26005)(6486002)(6512007)(52116002)(2616005)(86362001)(5660300002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Gi25lf6PCgs9d3n649q8QM7/a/Grn3NtbLmSKG3cir4n5dg1sjWbFAp8qKo8?=
 =?us-ascii?Q?WRWlUbnh9pv+XrRPmOzVZmqQQ+n7wetEchUden7ffGvBS+BBR1wHwD8w+L85?=
 =?us-ascii?Q?A6DTxqzi0/qwshnA8yh/ZO/bukwLMqxbsZV5ZZ9PEuRhocsDGrvVU5upRVHx?=
 =?us-ascii?Q?HjHqLaHvnO+C2K64ASMZSPRUm/iFNK5o5veAPCo6rSSAf7e9aFPbX+wMb8sl?=
 =?us-ascii?Q?WUyT1cXj0NM0Z0AEOQe2ls/iJLLwUYGgGEmWFzZcjSKRVOSCBFt/5CJXuAHZ?=
 =?us-ascii?Q?PtqCcWxiKhKZ2cmBVyyWZ5Roxnus7HQ57VhRZg3aNdH9m2bGWB9afqeS2h89?=
 =?us-ascii?Q?YPLOgcPG6+2nI1iNQdM00JpYoWZHkRQe4Lehan7YrAPFdqaSEZDqLnhe8rxY?=
 =?us-ascii?Q?Uk5iAYPgg846q1cmYw4MqX3dJ2Rchkk5GNXInSkRaPDaRhG2Et1EmKsi5fyj?=
 =?us-ascii?Q?KdHKAeX4BVy79WHs1VaCIAU+n23N968AgFYa/kpmgatesOc6B/yNKZBJ16ZP?=
 =?us-ascii?Q?X7GeqrvwbMljIrnde9i+Ens3mLUPP+hgiCFIyc3FC5PuGR+Hw+knd1WC3Wyw?=
 =?us-ascii?Q?mjfUuTSUkObxMNGu7DxrPrbaE/HeRQq1joBn1qBi172wgnrE1KP/0hdXZfR4?=
 =?us-ascii?Q?ekJ4hhQ4qTrqYfweRRwZ47R8mcoKswPS7eAyZasA8/5YRXuXKad3ze5AYaz3?=
 =?us-ascii?Q?sfKqGBtYu1dnCcLTp1OEm9UVYDoCqVx28M5/WcRMT7JQGGDiLGherBFHe8pD?=
 =?us-ascii?Q?Ax0EeU+BICH2pJaKYz0H97KXm/X4eWXdA/+MztvTvkvf2NU8b3tOLM1ehddJ?=
 =?us-ascii?Q?P8QFH4veazRu8jLfbZ7UpuJsxF2HA48iouqHfDQb2jAqNqcPzXbpY0BhUEm9?=
 =?us-ascii?Q?VDk1rgBpHbvBXAkNQ/v9VdrWKqD7jFKB02Mo1XltI+C5KKicZ3oSnXBbKnca?=
 =?us-ascii?Q?e0E5cjEpHedHR4roniKoYub8yHF3TTx8uQb/xDXXSMUW+QQX+LSzUKrRq7pg?=
 =?us-ascii?Q?4s8YBkG34uRtXnlnyWyvUKulrIUeUpRPtmlviy8Fmy2fjX42+Fm29sjDlTeC?=
 =?us-ascii?Q?GLyQfBQvWj6UUC0lTb5pFyXRR9yhwH4rhk5sgiBrpBBAjXWNo1nn/0xKIi42?=
 =?us-ascii?Q?v3iUkG0fyjC79F3JPZgCmkNuk2bsRIe7uxoj7V96PEHbJ617V3IcEgVzpRhh?=
 =?us-ascii?Q?ymDTqybN1ldr3dPHCMtV4fXyb2ZVsPvlG5Dsj1T9xbYX8RqzzLsQgHomwV7e?=
 =?us-ascii?Q?9oPrpQN1OgT9+1ry0sqzjS6oMByfrcio1IPqxFS/9Lipr8o7NXjaJJGPQB2v?=
 =?us-ascii?Q?WFFASeB9oHe9Lq1B2DCHMfNPQggfLrrXI5D4td05rbbRaRZGduWF545dnJ1t?=
 =?us-ascii?Q?H6E+sR8OFUyCR5pUzAh0Y+WRN+iwB5EKjDDs8EnviMNXKY1D7srg1UXQsOoV?=
 =?us-ascii?Q?BI5tACvffufzO7Eqf309jwPOl3fOIsyj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f999dce5-700c-476b-17d5-08d9951b828c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 05:19:23.8189
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
X-Proofpoint-ORIG-GUID: HQT-aRGQerP9O0ct6PDlxYNb7ijAfH92
X-Proofpoint-GUID: HQT-aRGQerP9O0ct6PDlxYNb7ijAfH92
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds support for the proposed ioctl that allows userspace
to create virtqueue workers. For vhost-scsi you can set virtqueue_workers
to:

 0: default behavior where we have 1 worker for all vqs.
-1: create a worker per vq.
>0: create N workers and allow the vqs to share them.

TODO:
- Better support for sharing workers where we bind based on ISR to vq
mapping.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 hw/scsi/vhost-scsi.c                         | 65 ++++++++++++++++++++
 hw/virtio/vhost-backend.c                    |  8 +++
 include/hw/virtio/vhost-backend.h            |  4 ++
 include/hw/virtio/virtio-scsi.h              |  1 +
 include/standard-headers/linux/vhost_types.h | 12 ++++
 linux-headers/linux/vhost.h                  | 11 ++++
 6 files changed, 101 insertions(+)

diff --git a/hw/scsi/vhost-scsi.c b/hw/scsi/vhost-scsi.c
index 039caf2614eb..74363f9a519e 100644
--- a/hw/scsi/vhost-scsi.c
+++ b/hw/scsi/vhost-scsi.c
@@ -163,6 +163,62 @@ static const VMStateDescription vmstate_virtio_vhost_scsi = {
     .pre_save = vhost_scsi_pre_save,
 };
 
+static int vhost_scsi_set_workers(VHostSCSICommon *vsc, int vq_workers)
+{
+    struct vhost_dev *dev = &vsc->dev;
+    int workers_per_queue = 1, io_queues;
+    struct vhost_vring_worker w;
+    int i, ret, cnt = 0;
+
+    if (vq_workers < VHOST_VRING_NEW_WORKER)
+        return -EINVAL;
+
+    if (vq_workers == 0 ||
+        dev->nvqs == VHOST_SCSI_VQ_NUM_FIXED + 1)
+        /* Use the single default worker */
+        return 0;
+
+    io_queues = dev->nvqs - VHOST_SCSI_VQ_NUM_FIXED;
+    if (vq_workers > 0 && io_queues > vq_workers)
+        workers_per_queue = io_queues / vq_workers;
+
+    w.pid = VHOST_VRING_NEW_WORKER;
+    /*
+     * ctl/evt share the first worker since it will be rare for them
+     * to send cmds while IO is running. The rest of the vqs get their
+     * own worker.
+     */
+    for (i = VHOST_SCSI_VQ_NUM_FIXED + 1; i < dev->nvqs; i++) {
+        w.index = i;
+
+        switch (vq_workers) {
+        case VHOST_VRING_NEW_WORKER:
+            w.pid = VHOST_VRING_NEW_WORKER;
+            break;
+        default:
+            /*
+             * TODO: we should get the ISR to vq mapping and bind workers
+             * so vqs sharing a ISR share a worker.
+             */
+            if (cnt == workers_per_queue) {
+                w.pid = VHOST_VRING_NEW_WORKER;
+                cnt = 0;
+            } else {
+                cnt++;
+            }
+        }
+
+        ret = dev->vhost_ops->vhost_set_vring_worker(dev, &w);
+        if (ret == -ENOTTY) {
+            ret = 0;
+            break;
+        } else if (ret)
+            break;
+    }
+
+    return ret;
+}
+
 static void vhost_scsi_realize(DeviceState *dev, Error **errp)
 {
     VirtIOSCSICommon *vs = VIRTIO_SCSI_COMMON(dev);
@@ -223,6 +279,13 @@ static void vhost_scsi_realize(DeviceState *dev, Error **errp)
         goto free_vqs;
     }
 
+    ret = vhost_scsi_set_workers(vsc, vs->conf.virtqueue_workers);
+    if (ret < 0) {
+        error_setg(errp, "vhost-scsi: vhost worker setup failed: %s",
+                   strerror(-ret));
+        goto free_vqs;
+    }
+
     /* At present, channel and lun both are 0 for bootable vhost-scsi disk */
     vsc->channel = 0;
     vsc->lun = 0;
@@ -281,6 +344,8 @@ static Property vhost_scsi_properties[] = {
                                                  VIRTIO_SCSI_F_T10_PI,
                                                  false),
     DEFINE_PROP_BOOL("migratable", VHostSCSICommon, migratable, false),
+    DEFINE_PROP_INT32("virtqueue_workers", VirtIOSCSICommon,
+                      conf.virtqueue_workers, 0),
     DEFINE_PROP_END_OF_LIST(),
 };
 
diff --git a/hw/virtio/vhost-backend.c b/hw/virtio/vhost-backend.c
index b65f8f7e97bf..175ed1f1c3a8 100644
--- a/hw/virtio/vhost-backend.c
+++ b/hw/virtio/vhost-backend.c
@@ -152,6 +152,13 @@ static int vhost_kernel_set_vring_busyloop_timeout(struct vhost_dev *dev,
     return vhost_kernel_call(dev, VHOST_SET_VRING_BUSYLOOP_TIMEOUT, s);
 }
 
+static int vhost_kernel_set_vring_worker(struct vhost_dev *dev,
+                                         struct vhost_vring_worker *worker)
+{
+    return vhost_kernel_call(dev, VHOST_SET_VRING_WORKER, worker);
+}
+
+
 static int vhost_kernel_set_features(struct vhost_dev *dev,
                                      uint64_t features)
 {
@@ -313,6 +320,7 @@ const VhostOps kernel_ops = {
         .vhost_set_vring_call = vhost_kernel_set_vring_call,
         .vhost_set_vring_busyloop_timeout =
                                 vhost_kernel_set_vring_busyloop_timeout,
+        .vhost_set_vring_worker = vhost_kernel_set_vring_worker,
         .vhost_set_features = vhost_kernel_set_features,
         .vhost_get_features = vhost_kernel_get_features,
         .vhost_set_backend_cap = vhost_kernel_set_backend_cap,
diff --git a/include/hw/virtio/vhost-backend.h b/include/hw/virtio/vhost-backend.h
index 81bf3109f837..bede35cf4686 100644
--- a/include/hw/virtio/vhost-backend.h
+++ b/include/hw/virtio/vhost-backend.h
@@ -33,6 +33,7 @@ struct vhost_memory;
 struct vhost_vring_file;
 struct vhost_vring_state;
 struct vhost_vring_addr;
+struct vhost_vring_worker;
 struct vhost_scsi_target;
 struct vhost_iotlb_msg;
 struct vhost_virtqueue;
@@ -71,6 +72,8 @@ typedef int (*vhost_set_vring_call_op)(struct vhost_dev *dev,
                                        struct vhost_vring_file *file);
 typedef int (*vhost_set_vring_busyloop_timeout_op)(struct vhost_dev *dev,
                                                    struct vhost_vring_state *r);
+typedef int (*vhost_set_vring_worker_op)(struct vhost_dev *dev,
+                                         struct vhost_vring_worker *worker);
 typedef int (*vhost_set_features_op)(struct vhost_dev *dev,
                                      uint64_t features);
 typedef int (*vhost_get_features_op)(struct vhost_dev *dev,
@@ -146,6 +149,7 @@ typedef struct VhostOps {
     vhost_set_vring_kick_op vhost_set_vring_kick;
     vhost_set_vring_call_op vhost_set_vring_call;
     vhost_set_vring_busyloop_timeout_op vhost_set_vring_busyloop_timeout;
+    vhost_set_vring_worker_op vhost_set_vring_worker;
     vhost_set_features_op vhost_set_features;
     vhost_get_features_op vhost_get_features;
     vhost_set_backend_cap_op vhost_set_backend_cap;
diff --git a/include/hw/virtio/virtio-scsi.h b/include/hw/virtio/virtio-scsi.h
index 543681bc1838..694221601dad 100644
--- a/include/hw/virtio/virtio-scsi.h
+++ b/include/hw/virtio/virtio-scsi.h
@@ -58,6 +58,7 @@ struct VirtIOSCSIConf {
 #ifdef CONFIG_VHOST_SCSI
     char *vhostfd;
     char *wwpn;
+    int virtqueue_workers;
 #endif
     CharBackend chardev;
     uint32_t boot_tpgt;
diff --git a/include/standard-headers/linux/vhost_types.h b/include/standard-headers/linux/vhost_types.h
index 0bd2684a2ae4..0b844969a524 100644
--- a/include/standard-headers/linux/vhost_types.h
+++ b/include/standard-headers/linux/vhost_types.h
@@ -27,6 +27,18 @@ struct vhost_vring_file {
 
 };
 
+#define VHOST_VRING_NEW_WORKER -1
+
+struct vhost_vring_worker {
+	unsigned int index;
+	/*
+	 * The pid of the vhost worker that the vq will be bound to. If
+	 * pid is VHOST_VRING_NEW_WORKER a new worker will be created and it's
+	 * pid will be returned in pid.
+	 */
+	pid_t pid;
+};
+
 struct vhost_vring_addr {
 	unsigned int index;
 	/* Option flags. */
diff --git a/linux-headers/linux/vhost.h b/linux-headers/linux/vhost.h
index c998860d7bbc..6823f3b5309c 100644
--- a/linux-headers/linux/vhost.h
+++ b/linux-headers/linux/vhost.h
@@ -70,6 +70,17 @@
 #define VHOST_VRING_BIG_ENDIAN 1
 #define VHOST_SET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x13, struct vhost_vring_state)
 #define VHOST_GET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x14, struct vhost_vring_state)
+/* By default, a device gets one vhost_worker created during VHOST_SET_OWNER
+ * that its virtqueues share. This allows userspace to create a vhost_worker
+ * and bind a virtqueue to it or bind a virtqueue to an existing worker.
+ *
+ * If pid > 0 and it matches an existing vhost_worker thread it will be bound
+ * to the virtqueue. If pid is VHOST_VRING_NEW_WORKER, then a new worker will be
+ * created and bound to the virtqueue.
+ *
+ * This must be called after VHOST_SET_OWNER and before the virtqueue is active.
+ */
+#define VHOST_SET_VRING_WORKER _IOWR(VHOST_VIRTIO, 0x15, struct vhost_vring_worker)
 
 /* The following ioctls use eventfd file descriptors to signal and poll
  * for events. */
-- 
2.25.1

