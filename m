Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0B3DC43217
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Dec 2021 02:51:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbhLGCzG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Dec 2021 21:55:06 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:44836 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229838AbhLGCzB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Dec 2021 21:55:01 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B6M5HmN012536;
        Tue, 7 Dec 2021 02:51:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=JGPKg5pR9JfEbo2Vntm8ShT4Bu7HYXnrVufWNfM16FQ=;
 b=Hlxki2aXLB9Fha7e3KM8dueLE5RzPkLQmg9lgfg8dGI1E40l+a4Af+/N/YVwTj9A4ADV
 G/qfalP/rdoqMNv3yvVT5tIvax/21o+nei1o0o2cQ+M8l30buDzZaq2cmgJ70EK8SsHJ
 UFZsen6s/upEEqclcSWpdTjYOg2kqi/uyzPmnnjBFUAF3gxduR7MrgodfokxPR8EoQXI
 +O0B0bZi6bGCJ21BmD0FT5pQVG51voIW1znr1SUm7ryJ0s28t9Fw8227ufEh02Be5eyA
 j+KF00Uegp1EhxNBNvmleRGM2auxYCMYzHo2tDb0lwmGdPC6WyiiYmEbQujHMWNsuc3J nQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3csc72c354-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 02:51:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B72kglW153019;
        Tue, 7 Dec 2021 02:51:27 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by userp3020.oracle.com with ESMTP id 3cr1sn5w2j-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 02:51:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iswVlnbeV87E4HdLfchAiU4m1jSHmDx2ZCCF9FRRI37ht9oDOoAKOJO3yC8LHI8pndMpYZmWrfTZUXiqRSlNy54GFmdLgqDiUd7f7uSwinEWmIxzdjBdgEsO2mjWAGS9SfndnF0Nj4epZZaEY2z5GsNCA0rBMq9Ph/IPe7JGYn/O+I/6CdRsPqHYcsdEsCy+IrG04L87VRVt189iqZKB9cTFU7V28INzqbVWvzZ5JGdWac4Q3HbAaLLCFbt6P5EYIGeNvZN0JJOSZTyiSmb03uJqkCDhcXAELI087/vbJL4+N/Fi5WEgmuDqBfNSXyXR5XJDGR16P+YxttAYGRDIVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JGPKg5pR9JfEbo2Vntm8ShT4Bu7HYXnrVufWNfM16FQ=;
 b=DXJk8GXZx92Tgtl7bgtNeE38r9QMsZUj+Qy1jexsbwgEMNzEGYSHDb0xe8hg5tdZufCKKxcN+klS5VaQ4cntcOrtCxU0NwyH0bi8gN1l8VMxV8rvGztLRYDwbT7Dhve5rZw0brLs7o9HnIsyFi9dGAW62ldejpYSo8cGqnBXNMrleLW6Ne8yptRY59R+VM/DLLWBc3YnJ+qJg9yY9VvOrWVF/lLXzbbEwyOdbLPTz5dUuKOMlQERrsb37INYHBIv1YQM5CCiO4LCb4ObZhfvzW74+P2qohZQqcizQBfw1nrMpn/46LSskCJZBHfUu6kV0No63sLkc0LIJEkgB4YdpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JGPKg5pR9JfEbo2Vntm8ShT4Bu7HYXnrVufWNfM16FQ=;
 b=nqCqS5WsUUc7Ys3l/KJ+e/5+BJTiS8apoYHlnssWKeYjh4vUobWPExabRu3zmT8O6lUk2xHWpYUjTncReIUKM72inVufw1+Tx8Lokbml8TIKuNcnA3HoTESEOty8fMRjIFyyEYui8Vhm2tyBqXyFk4udZzgH2gMVgRVvSTYqBIA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB4347.namprd10.prod.outlook.com (2603:10b6:5:211::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.21; Tue, 7 Dec 2021 02:51:26 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041%11]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 02:51:25 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V5 01/12] vhost: add vhost_worker pointer to vhost_virtqueue
Date:   Mon,  6 Dec 2021 20:51:06 -0600
Message-Id: <20211207025117.23551-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211207025117.23551-1-michael.christie@oracle.com>
References: <20211207025117.23551-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7P222CA0021.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::20)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DS7P222CA0021.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.14 via Frontend Transport; Tue, 7 Dec 2021 02:51:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ec105093-91f9-4111-51e2-08d9b92c75ec
X-MS-TrafficTypeDiagnostic: DM6PR10MB4347:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB43477EB9D8E1DA76F67F6BE0F16E9@DM6PR10MB4347.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +eLMtsR4jlP3KJxT6hH6qK44zkjyyoz9rGUP8MaBhsGOLyNksDFz7835u/rB6ckar4WgHzgjD8/Ls5U10Tfrg2Ns8mhDkN2Xn/+8uqSGc7VzVt9a3CBNReQLhynHWs0wehOJiW/inY2raZe82wKnWbR9Etku7JeBO0X44DzLuPXt9SRWGqi+rDXvW5g3WJqhX6BpAmKVAtSX+lnK5+go1bsVFWo6oKQeq3T0Ay6ILkDtTfC5MUoEYEfL+UeOlB11eanqip0RNfsQWDGMjr8PnZlLuHbpwR0YpndQTUKZI21tvLFlduMOq7WvZbCVGFb8D5gUpX6kz9XDF1+0S7wiP5PFlZmKXrXjpKf8liuFRnIK+yNBEfJWznTvCAhi0bh13XujF5VqLd5rZrWyzTFnyXFammbqUP3cGxQ4DzQk5N8R4tQU2+jDjoaeRBJweT40OIrpMbvStEXETZ/n3/CUzvmkzsefXDzWa+hPQE2FnfejOIEUx8AG0A6LZV2ZuWCYom/794gJT6OiRwaedwnxT2hXkHvJ+GMgmU/QhjKC4m4Qplk99NoBsgTyHn/ki7apn4GiXs85wfxzzvScp/cN70q63friUNPyuTb1YXCNmiTncS+NWhgbTgMHynWcbaPweq5OgDC4G5vD8Z43MjNSOFGtcQHecllFsDEZAfZQ6COvBZAQwgL25i3DiU+At0Mlfm1CFniOCBKKUKdIDBoQ+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(6486002)(956004)(107886003)(83380400001)(4326008)(5660300002)(1076003)(2616005)(508600001)(2906002)(6512007)(86362001)(66946007)(8936002)(6506007)(316002)(36756003)(8676002)(26005)(186003)(66476007)(66556008)(6666004)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Mo73JLi7lKwodgHCMMFjw67t/mjSIugC/Wpc3U0UpREiysK88VAUFtgYPupX?=
 =?us-ascii?Q?/+oiEZ1DrNAxiXRkXM3IRTdEFzLBPxYeeUmmzwFnF2gQrVpGtNlCFN1p7SKi?=
 =?us-ascii?Q?L29AQql2JSgZNTAdZWCuxkwlUDz8buw1sU1lmDDLm5NSXf+TEfm0Q4th2Uaw?=
 =?us-ascii?Q?G6b8ioFG0tsi2rB/86+0JZ35ill6WmhiOJpQsxaUYBsdbFbmfBsOZYOeQE7X?=
 =?us-ascii?Q?J83dJU8Lt+feDfB4C2Fd06DQTllrm9DDAdi3vrKLJc/dnbjv2flTnzU2wWPK?=
 =?us-ascii?Q?DhlmoLkpd8DD6gT7R4jgSVypc8C6wrUPRYhzZSsTE4OUoGNMVlCxVPdiWbFC?=
 =?us-ascii?Q?Y2XGXHICV1W5QGtutd9tXdcwrgOl95jekOOW7MNotq+RHAvzt17M8/oElBjx?=
 =?us-ascii?Q?DcB0SG1EyeN1rSXGa+00wxTwSlZ7zB3vCEUgHQuPEA+ZDYBqRuCM3DgsHDPo?=
 =?us-ascii?Q?M9no7oV8xVblvRi86aebGDq+8CosP8N+UPq1GP+HpZqGnO/SU1NkMo/W5UGY?=
 =?us-ascii?Q?/B49EIzJW3ScLC56sGn9U2L3wHgmeeB2m0kfQ0PNgq5HKk8qN9pJpClN08ge?=
 =?us-ascii?Q?69pNzp+K7CfVTRoF7HNyA4esM/NVtb2NFeot0wecmoYAttZVym4PBOgIBMSK?=
 =?us-ascii?Q?rjorxHznhlOsSuBfumqAEgsQNfDkGzrKKsYxe7dFIgZ0MNUNbThioEu/VTBa?=
 =?us-ascii?Q?JbMJAmtIs3nz16Ti3f1CZ52fiPmNAJgq+3jAiyxhQyPgEsoqC4RWHWqcp/7C?=
 =?us-ascii?Q?It5sRr9m7suBKSB4F0zUPfUZNCQ0oEvi6j0usxY4O3YwigIQrqIYc9kTe7EY?=
 =?us-ascii?Q?hqlfJFanHbxK39llMZdMFXMkLGntU73ub9j6SFm3UyFTDIw1DAWxr9jVzwO/?=
 =?us-ascii?Q?hWFVKdyyVyUaxHAohNNjdLgJaig/ucbgPkCnbSBJlS0q1mmme6C1xE0PREMt?=
 =?us-ascii?Q?rzIh18yOWv2/DEHd1Owv2mllKdKQacbGqxPDKVxoHL2uDMvMM204nT6DTh1B?=
 =?us-ascii?Q?7C6kqegG11bGoOlp+jaZXOFQTiRx4hrI5zXFO7gCFCHWn92pEyp/iefRbk+0?=
 =?us-ascii?Q?SdWkDVcCjYBeUmZ4FXa0KjahU7EY3A8KMSodtaKIkAhEw+0npariDUK3KOCu?=
 =?us-ascii?Q?RB1OnDeGOOz76rlS2AyUskfxfZ2njYFaMF59XJ813chp/W6ZJxt13WVPl00K?=
 =?us-ascii?Q?f9bodInRkp5rn41DN5rsZj1K8Hogm8EKU+3e5laZXzQB+rXGwxyvCJI771t7?=
 =?us-ascii?Q?qEvlIiiZtvpZANt3woQNPIIKKtyD3aVTagX5tAD8Z4t6piEK8VpAkD+hZD2A?=
 =?us-ascii?Q?Kdwp9PGpgKfz/4v2BuBGqDB0Xlkbgkpfy086VQfAriIVjVLJWpi4tNC+vZFI?=
 =?us-ascii?Q?iAIPA9iuu+QNyFnQt26tCXATgTKi/jdiF8iMtXQrJv/9EXH2E72/zVt/MTJO?=
 =?us-ascii?Q?zfDf6K+SOAH2GykWeFxDUupPR/Qg7jQoXBz6J2uU0XVk496tITBn8aPUkstz?=
 =?us-ascii?Q?z/Pv2UArRH9teUr3nh58siBqS0FRe/FIsL8zjf65OxQWkf+k6Y7K5Y/QaBMe?=
 =?us-ascii?Q?u4JxhrJowAXMGvMY4bxQSxYbKHjh/dnZrJYVAPsOvmq+91fPS9jXcpJwE72g?=
 =?us-ascii?Q?6vVhrtpYtWBuxcjeqIdq7eo7IRHm0O1FTv1Sl7LcGxtb2h6yT5RVLDagYJ9a?=
 =?us-ascii?Q?JTgZSg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec105093-91f9-4111-51e2-08d9b92c75ec
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 02:51:25.9126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sUANM54RfDT47YhRppwo2TqAOFn1SRrCL4yk4wNJcDYuMhlxa1i9Bvfv/N1HT3iYb6eUDlCjKv7/i+nz5RHeleHLy5a7wb4MUJHguJGNfag=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4347
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10190 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112070016
X-Proofpoint-ORIG-GUID: uk7zEP5tgM5C29OZuVq-uOWDQaPALIXx
X-Proofpoint-GUID: uk7zEP5tgM5C29OZuVq-uOWDQaPALIXx
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
index 17e5956e7424..a314f050413a 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -488,6 +488,7 @@ void vhost_dev_init(struct vhost_dev *dev,
 		vq->log = NULL;
 		vq->indirect = NULL;
 		vq->heads = NULL;
+		vq->worker = NULL;
 		vq->dev = dev;
 		mutex_init(&vq->mutex);
 		vhost_vq_reset(dev, vq);
@@ -566,15 +567,14 @@ static void vhost_worker_free(struct vhost_dev *dev)
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
@@ -586,25 +586,24 @@ static int vhost_worker_create(struct vhost_dev *dev)
 	 */
 	task = user_worker_create(vhost_worker, worker, NUMA_NO_NODE, CLONE_FS,
 				  USER_WORKER_NO_FILES | USER_WORKER_SIG_IGN);
-	if (IS_ERR(task)) {
-		ret = PTR_ERR(task);
+	if (IS_ERR(task))
 		goto free_worker;
-	}
 
 	worker->task = task;
 	user_worker_start(task, "vhost-%d", current->pid);
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
@@ -615,9 +614,12 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
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
index 67b23e178812..31d074724fe8 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -79,6 +79,7 @@ struct vhost_vring_call {
 /* The virtqueue structure describes a queue attached to a device. */
 struct vhost_virtqueue {
 	struct vhost_dev *dev;
+	struct vhost_worker *worker;
 
 	/* The actual ring of buffers. */
 	struct mutex mutex;
-- 
2.25.1

