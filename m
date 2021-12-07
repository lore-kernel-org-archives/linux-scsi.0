Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08DB5C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Dec 2021 02:51:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbhLGCzS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Dec 2021 21:55:18 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:52686 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230374AbhLGCzI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Dec 2021 21:55:08 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B6M56An019276;
        Tue, 7 Dec 2021 02:51:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=nTH3clUOEM+dbqJQFParaCo7XSrE4LwcicG5ZL2R4hI=;
 b=K/qLkYzK8FawnUMMbMFqz3Ci+eqYMK9iiRALQg0S6Sq2HsrY3LHk9FnfKFcX3HNsqjqo
 AYlWUHZINKCLUQStr1jDOWJEigjoWmB4aU5abbtFGDFRvxb0hzw7Hb29EBgo5Bm791bo
 u3fj4N56DeBCa2x4twfKuxRuIMQA2ej6hns0hPHnIk7FrOKegLRz6xfDgG1lN0jIX4ID
 J0Jx7zTJXxpFgOTU5yMEXiKQf7C6ntYnPlvdNCJ5IHv4GRSBq28pjmRgS1e4w2Nrf9nl
 TSlpCoc31tN4glgy2AHRN9P4CKiYIoQsa7dnXo3n9ane7AGrgs5JoV1oIbRAmIAQA4gL IA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3csbbqmefe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 02:51:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B72kh31153049;
        Tue, 7 Dec 2021 02:51:34 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by userp3020.oracle.com with ESMTP id 3cr1sn5w80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 02:51:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SusmI+MeY2vH9EIH4tLhFctegSh9FVHa36YPIblH2Hap6zIId+p3djbqgsKuMDVMfv9m8ko8CUhtWJqCuxAY66hCWKhCOiIEkx7DB9K23MxtAaZcFWybsn5scBbDLeA32JIORGCVcYCrsxwlRbk/kXMkc497d1OnTKCsia1zMnqy3yU+Zv+IEPAV09kJRVYsFKM94YvGBDxqv2Uhd4C5HrlZwhpb5jIUM/lNJkX/u1sABS/W6oMFEEV3VElpMwjRPnjRspRZ8gH5gn3HLAc++uq6Z6hUvYueUYTFsPNSdurMowLCta/7wBm1AOyMKSQUzQrasQqLqonM1P7yNm41Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nTH3clUOEM+dbqJQFParaCo7XSrE4LwcicG5ZL2R4hI=;
 b=B1OzYL6c9ln+BZ//lHmOO2fy6ns+Rad555T55ZrI7Vbg6ncoD5M+j1R867s/F0ZSiKsMwPNIPyVP03iAtFc78k/5UpcYTY34WYDvNgEULG4GIh0ZB3P4QtIOaQGG8VHF8B3XigGmtzWp+mMVKT+7QM/sg30zZIsE0CG0Cg2WmSanoRxDyI6K/VcB3yHhTc26aeCrAUOph/+dsZuHv49wrBOBC0yEl0EGub7YxT4ZR3RULHqgSS6MBi3JK+BeAnp6bVFUvxHZIw6MiSFqtKt/vd3DStAoGSm87GIoICh2F3nevCBxu59BBNv3e9HRg3w4f4QuMzlUcZOiYdR1FmNatA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nTH3clUOEM+dbqJQFParaCo7XSrE4LwcicG5ZL2R4hI=;
 b=fxKRPRRXu1MHsrW6Whnyd7yGWhMRVFkKCJKOlvD3DaMWxP9yYzV5ueVHHOpS8odf7epKrrxqkAvFt1DyMTitwlmHoHK0AZq1vrcy1ynyUlUOY8Wci3Teb1uymjbqJU7bxa8c517uohYgQHcotm2B/wj04waw90kWCD5aldXirx8=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB4347.namprd10.prod.outlook.com (2603:10b6:5:211::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.21; Tue, 7 Dec 2021 02:51:30 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041%11]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 02:51:30 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V5 11/12] vhost: allow userspace to create workers
Date:   Mon,  6 Dec 2021 20:51:16 -0600
Message-Id: <20211207025117.23551-12-michael.christie@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: b649f04d-8db7-4135-dfc9-08d9b92c78a4
X-MS-TrafficTypeDiagnostic: DM6PR10MB4347:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB43474DCDCDD221B6E02329B9F16E9@DM6PR10MB4347.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5v6iUBj0MHE+WNusvFU6tGEr0ncQJeNv+2rNkSB4d7UZNqUf/A3Ei+op9EnsnkDi0V31iV8f1o7SRYM+P7X50TZnOtMUJaRGSM0kuhqL78jscrDYXuo7mdeX4sZtl2mvKBl88RlnqqeC6cH3GDQAf3pmW2hk9q40BtNA008OLH+vHEW4t75DGoLfoGNPWGgwvyqzmbX3RL2Y4G2WInIoVUn70rpsmWFZa49Yl1iYoSjOhcVidmaTod/cGA84Aft3KGMt8o0a761uQWznR303sG1bd3XGNpYzpN08yuWk/YlOPKmZ9YyzJC65WDKV0mfd/gevEH2yJg63s6Mngg8df7NLkp3VtPROVOzCPEsy2qUvuudp2GGXGDPvFff+53ngJ9cNK/ogA+zTjVfGCGGZf49Yn84GVcSK80LuW7KHx5RjAj6bBS3WlquWJ1gjTH33Ko9fsKDHNPIczELNb02QXdjSfVc1Mx/dUGzJPxzI5YunpiUctVGrR8oDbjlUuODa8HYkBncY2yl9XNijg7cJO+cADTE9bX1sjgaBg+37M+rtyJIK4QW1AmZxmidIvgfbbojuZLN/gDNWXo9utUai7uxd5vlLs79V+9iyPHlqxAjWhzHr7BieK9lzUaSnbIM5luPhVluZwhZP4Yde2QX1jV3XFLwwrOfAsquEshQpVfEWU7kW8AZG1A9JTgMlGufq+XG9kf1RHHfQS7EwwwxZ4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(6486002)(956004)(107886003)(30864003)(83380400001)(4326008)(5660300002)(1076003)(2616005)(508600001)(2906002)(6512007)(86362001)(66946007)(8936002)(6506007)(316002)(36756003)(8676002)(26005)(186003)(66476007)(66556008)(6666004)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EKURCg/NCwumANwiGGaTN0G35dyVzJ1cbYNlwPjOjYEqJRQal1+ZrZIng/7y?=
 =?us-ascii?Q?D6mrhUYgUxnHNycyD1S5/vInu4AcBo5v0wh8FTx4yoggpTXfDYdjfuKPe2n8?=
 =?us-ascii?Q?2fU9TM3yGKrNyW6mizdQ+YwciYKlOtWtaNMrABQ+yPhFeSWff/WjyBsqKWJi?=
 =?us-ascii?Q?zyjFBQFFPRKu+EU5fjmssC0ZETaAX8gNnMflD4N/R7Qfg/p0QNMxo3/EqjjA?=
 =?us-ascii?Q?edFtK1HcpCzeWgWwfQreAM4zSnMqhdRvFD3o5xtxHvwZygpF7uygtC86PqPa?=
 =?us-ascii?Q?yopJgm6eS1EfkT1FCpclobCxFuSg6AnJbqueCZtgL9a/FkKfeaL0mCrDXr9t?=
 =?us-ascii?Q?ziUBYxWLobI2hYGm2ET9GQHws3IPAaId7Dj/IiymjbrQJ3Do+P9RcbcpWc7p?=
 =?us-ascii?Q?TKKus/YbuckSOvEJ70c7EbzLfbU+o91DoswtyhHVXhd0vWbF7BqjCb/BJppT?=
 =?us-ascii?Q?PTl9BzonQol81EynT76Rb5qPu76egGQDXuJL/W7Vg7RhmSpvnbDjms/4nrVu?=
 =?us-ascii?Q?IWB3UVSa9bq+7rX/PQBgmlZQLDz8dQscW/tgNCNb+VlFVHlihe4Kg2OHwkzQ?=
 =?us-ascii?Q?XIjVdC7CdVA6pptCNlX0eQuKjmvW9sppME/qEwPJAiVF19IxlXa2jgQFW73N?=
 =?us-ascii?Q?mwS0LhEaSk4GHGRasjUNwf9oVw8uAm01p4VTirryKl0Q4loed086hSgJomm3?=
 =?us-ascii?Q?YB8ujB2u7+frF6ZUNFUrU8INphigvdZOhfshYY6PQOgQkGmpGljKDmm4b0wR?=
 =?us-ascii?Q?jsOFxUfN+HsZkrMe7Dv46EiZz0jb9ot9pA7R0jaP58f7qklQYqpdTAg4XH7z?=
 =?us-ascii?Q?i6CY2orkqOIiozrTgiAf1dH6Ai1zpgiLvlYySY//wjMq6j1dLa7Vb7xmcBU/?=
 =?us-ascii?Q?sYOJUIaghU3h8ywyHXgReB6hQ+S015zYzYcG5DJEktBQrvnlzHYDMv7ReecP?=
 =?us-ascii?Q?PEVlNdOX/G17AK/HTYaS8QPIHHK7neR2VHNJoqnTKajak4ZgJ+OROim6+w5U?=
 =?us-ascii?Q?A6SiesO+vyRNJ5YEfw95URMIXVehKtGbQejsofL2DkrU9nyp1hjl5J7eDVEP?=
 =?us-ascii?Q?LSElan9LAuwbsITBKbJ1BG9SqGzyTabZMlL9FjHRsCfuhBUOReYFWAco8U/j?=
 =?us-ascii?Q?xiBh0E4FiIowmXZ71WtFfhdiswHsO2Z6qPlo3KC2AP8Rmh6klUviZ3/2B7ee?=
 =?us-ascii?Q?cQss5vtNms2A4m7egKAzZXZXHdN3a0U/672hmAGzimkW7w5dgKD+rijOYRJD?=
 =?us-ascii?Q?VcOS9aIfYcgZ1pTS+eiVon1y0gNotLvM3XkB4O2ipEpmg8EsAFgkxYygONu4?=
 =?us-ascii?Q?a9B/chyRsnMgwQ6NLYqviYHrb8+pOcRMpfXrtiQg4kgwXnDeE8fKm8b2t9WY?=
 =?us-ascii?Q?+T8pXRQGqTS862kN2LMejccqn14yHCH9YZj+bD/AJxQKAdc3PCFAGYLlx2p2?=
 =?us-ascii?Q?IsIU3tY1TBDPHZXH1XDDoGhn20ETGNFg0FxSRo3i49GIOGrmE9KuxlkC7LlJ?=
 =?us-ascii?Q?UQUuavf94sHZETJtpuwoQZFewOrIttGpW4J31F8jPwT5x3qHo139LZinL/Mz?=
 =?us-ascii?Q?5f+Mv5Ha8rAWpBZaOLbGzvAVPFAmwdVHZnJIJWUrr0aPQYcgOAK6jSB8k2tN?=
 =?us-ascii?Q?FOnhQJatfWe7TPFEtVrk8Uhz7k7AAR7/VhbJMNvYEmxc/KDwlPPGO+CwZctj?=
 =?us-ascii?Q?qBirTQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b649f04d-8db7-4135-dfc9-08d9b92c78a4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 02:51:30.4815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Etd1UzuI++iYrILa8Jgu38SlOC4EoINd2UOxz+rVBx6BmQ6BMaZxBtEf8KGvptsA4n1FiH7DGajpZWICCSc2wodxnZ2Nu5jK7q2/bnP9Zg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4347
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10190 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112070016
X-Proofpoint-GUID: KcOt800NaP9wf2MseGdiquoLbkZUgETP
X-Proofpoint-ORIG-GUID: KcOt800NaP9wf2MseGdiquoLbkZUgETP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For vhost-scsi with 3 vqs and a workload like that tries to use those vqs
like:

fio --filename=/dev/sdb  --direct=1 --rw=randrw --bs=4k \
--ioengine=libaio --iodepth=128  --numjobs=3

the single vhost worker thread will become a bottlneck.

To better utilize virtqueues and available CPUs, this patch allows
userspace to create workers and bind them to vqs. You can have N workers
per dev and also share N workers with M vqs.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/vhost.c            | 164 ++++++++++++++++++++++++++++---
 drivers/vhost/vhost.h            |   4 +-
 include/uapi/linux/vhost.h       |  22 +++++
 include/uapi/linux/vhost_types.h |  15 +++
 4 files changed, 188 insertions(+), 17 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 050b8007db8b..1af43b5d1dbd 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -248,18 +248,16 @@ static void vhost_work_queue_on(struct vhost_worker *worker,
 	}
 }
 
-static void vhost_work_flush_on(struct vhost_worker *worker)
+static int vhost_workers_idr_flush_iter(int id, void *worker, void *dev)
 {
 	struct vhost_flush_struct flush;
 
-	if (!worker)
-		return;
-
 	init_completion(&flush.wait_event);
 	vhost_work_init(&flush.work, vhost_flush_work);
 
 	vhost_work_queue_on(worker, &flush.work);
 	wait_for_completion(&flush.wait_event);
+	return 0;
 }
 
 void vhost_vq_work_queue(struct vhost_virtqueue *vq, struct vhost_work *work)
@@ -268,9 +266,16 @@ void vhost_vq_work_queue(struct vhost_virtqueue *vq, struct vhost_work *work)
 }
 EXPORT_SYMBOL_GPL(vhost_vq_work_queue);
 
+/**
+ * vhost_work_dev_flush - flush vhost work in device
+ * @dev: vhost dev to flush
+ *
+ * This must be called with the device mutex or from the device's release
+ * function when workers cannot be swapped.
+ */
 void vhost_work_dev_flush(struct vhost_dev *dev)
 {
-	vhost_work_flush_on(dev->worker);
+	idr_for_each(&dev->worker_idr, vhost_workers_idr_flush_iter, dev);
 }
 EXPORT_SYMBOL_GPL(vhost_work_dev_flush);
 
@@ -485,7 +490,6 @@ void vhost_dev_init(struct vhost_dev *dev,
 	dev->umem = NULL;
 	dev->iotlb = NULL;
 	dev->mm = NULL;
-	dev->worker = NULL;
 	dev->iov_limit = iov_limit;
 	dev->weight = weight;
 	dev->byte_weight = byte_weight;
@@ -495,6 +499,7 @@ void vhost_dev_init(struct vhost_dev *dev,
 	INIT_LIST_HEAD(&dev->read_list);
 	INIT_LIST_HEAD(&dev->pending_list);
 	spin_lock_init(&dev->iotlb_lock);
+	idr_init(&dev->worker_idr);
 
 
 	for (i = 0; i < dev->nvqs; ++i) {
@@ -568,31 +573,59 @@ static void vhost_worker_stop(struct vhost_worker *worker)
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
@@ -605,14 +638,88 @@ static struct vhost_worker *vhost_worker_create(struct vhost_dev *dev)
 
 	worker->task = task;
 	user_worker_start(task, "vhost-%d", current->pid);
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
@@ -632,8 +739,10 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
 		if (!worker)
 			goto err_worker;
 
-		for (i = 0; i < dev->nvqs; i++)
+		for (i = 0; i < dev->nvqs; i++) {
+			refcount_inc(&worker->refcount);
 			dev->vqs[i]->worker = worker;
+		}
 	}
 
 	err = vhost_dev_alloc_iovecs(dev);
@@ -642,7 +751,7 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
 
 	return 0;
 err_iovecs:
-	vhost_worker_free(dev);
+	vhost_workers_free(dev);
 err_worker:
 	vhost_detach_mm(dev);
 err_mm:
@@ -734,7 +843,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
 	dev->iotlb = NULL;
 	vhost_clear_msg(dev);
 	wake_up_interruptible_poll(&dev->wait, EPOLLIN | EPOLLRDNORM);
-	vhost_worker_free(dev);
+	vhost_workers_free(dev);
 	vhost_detach_mm(dev);
 }
 EXPORT_SYMBOL_GPL(vhost_dev_cleanup);
@@ -1604,6 +1713,7 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 	struct eventfd_ctx *ctx = NULL;
 	u32 __user *idxp = argp;
 	struct vhost_virtqueue *vq;
+	struct vhost_vring_worker w;
 	struct vhost_vring_state s;
 	struct vhost_vring_file f;
 	u32 idx;
@@ -1711,7 +1821,16 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
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
 
@@ -1764,6 +1883,7 @@ EXPORT_SYMBOL_GPL(vhost_init_device_iotlb);
 /* Caller must have device mutex */
 long vhost_dev_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *argp)
 {
+	struct vhost_worker_state w;
 	struct eventfd_ctx *ctx;
 	u64 p;
 	long r;
@@ -1824,6 +1944,18 @@ long vhost_dev_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *argp)
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
index 4423b2420c90..1738388fa02d 100644
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

