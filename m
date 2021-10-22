Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B241C4321E
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 05:19:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1349061215
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 05:19:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbhJVFV4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Oct 2021 01:21:56 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:50640 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229609AbhJVFVt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Oct 2021 01:21:49 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19M2qeuH019167;
        Fri, 22 Oct 2021 05:19:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=D40tPvmKWcALQ529N71eSOpOGZt4d+MRa6Xymi5OU3A=;
 b=l9cDYPGlKSUyo8M6v2HQRbA4M80lPNbyBAypeH/vLfJPxgVk7dKvcuRPfAMfkHQCJHcW
 upZMVDGAktUnk0tFMNGKhJ78GMiwcv1vruUrfZqh8WlgAmlog+dHl6Ah3oPTmZvEPWnL
 Sl21oXb4bf0+S2TD0Tmg2LOEqKN2Gwi84oNImJ/oLPMX9/KcjQ/S3Jg5hEPTpfXN/jrJ
 TyDGuznyTrP6eaW44NeOlge5f8hLxUJuTI4SPKG8uG6aaJTfmK/1tkOVrel0S3p1yMvh
 bYJptir8Wt19pD4qr9FhvZzF7KCNDfLzRM9/IX0gk8OUSiKjtSrvsqN8DjF4gzIi9++D 7A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btqp2s1an-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 05:19:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19M5BHId139141;
        Fri, 22 Oct 2021 05:19:28 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by aserp3020.oracle.com with ESMTP id 3bqpja16nf-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 05:19:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WJs/LlYYpFPjKWGJtyZ7rg39HBIoCuA3CimQ5EDwlRtUujMESvTqWLEIuozZzg/uZev9WIuKTZ6Ix0Q9Kovbs9sUiiN6RYK2TB9EWIhtScXCZOPBCkEYo+177ZpSbf2AKZeXwtqTv0jFAwXgKHrE3OlYHrY2ZPJiZMJKtnf33V8A6X77H4wfp2hFFPi2lnB0Xc8E20SeKO76VQs7BT2rJv54zZXF81dWakkcgkI+itARjKwhtf2zo0fVvxI17d/BYgBzFhh6luCzsPwW1gZOJ9MR+IT2E3584CjaMcvSu7q5TEPdUaE65hv/fVv55BktmDjhRkWiS/kUHn0ZR8JfnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D40tPvmKWcALQ529N71eSOpOGZt4d+MRa6Xymi5OU3A=;
 b=gN8SNw4ADdeg1q5nBmsgs1gvogoagQ4Ff6ocYLg8jwovIlGg2svBZIj/8NPyePLNje4+0VWC7GYnWfQ0BnC/Gy03fyV4pbXLZGVVohmTFEze7nelD2cwhlCzJHure8tnPj1ZabZrLNeVIelP7+rDxyx6NeQoOGwzRBO5S811RYDeMmh1aASkiggjm7Iw3HmsQS8Hf1y68the1JAKlknETlR1XYFuR1O+bDa2oYuTun7x9LwOvQXwt901BAwau6RV2cWNWGLbtnJSlw4XKW2qXaA8e7yi6sBYpmu0q9T0hZF5/Eik9cMObNSy0/ojaIvJIjP3dIv9BA51USwvjrslIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D40tPvmKWcALQ529N71eSOpOGZt4d+MRa6Xymi5OU3A=;
 b=occ3Ym4eOvwPNU4Xt+QKYQ1REvHD8hBbyrVSwExI5oqQcg3nvLmadfOee4AK6tyTBn//iyr7ItBfsssGejNEYsmiArW9UAtxWcUzVWPOWl8xi0iCVGebXVFxn5bc7zxd2os3K7V3lUolgXS5eBu3o3f39WvewT1F0o68lohe+NM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB4974.namprd10.prod.outlook.com (2603:10b6:5:3a0::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.16; Fri, 22 Oct 2021 05:19:26 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4628.018; Fri, 22 Oct 2021
 05:19:26 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V3 04/11] vhost: take worker or vq instead of dev for flushing
Date:   Fri, 22 Oct 2021 00:19:04 -0500
Message-Id: <20211022051911.108383-6-michael.christie@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: d30ffe5b-a092-4441-64c8-08d9951b83f7
X-MS-TrafficTypeDiagnostic: DS7PR10MB4974:
X-Microsoft-Antispam-PRVS: <DS7PR10MB49740A197A1F1480E95AFF8AF1809@DS7PR10MB4974.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sDSb5sRiABQHk/RLunRbVjZctnjyBIwXXpdxkMoW8jAo/w7FcUo2vq01mLqJzKIaaH9c6q+AWsb6rnSD6LRpH+aAI9DYMYZt3af8UU48uHMLlK6AqwUsfji9OzDq8JyCkG2YoTTcL44sDESFeZPyLXreHZxer3knbC1cS7XxL31nDvnn8M5RetNUvGH2iIgHrntvK8yjs0/RopNqim3LVPLuyjhz5TAUyQUudX6nlEQpndhM1qbrd9hGn59cWZW4DoqU3sxNQ27ukW213HpQVpMFSrFTQXAUtriRcGEcy9hTxz5fuNu0NaXJkO9S0BNhE4HECooU/px4P8j65onbeTjshxoEYfcWxOpq9TKVKz/Jn1g/mFqpLgsstzuDolywjQ5q1mbjOlQc5nw/O6iWhTo/mMjQHxK/1cx7OBnNX8UhrxlrmvRi4PXBVoPxGSKocSGrU/QRW/4CfDZXxrlMPc+8R1jOzgvvfuGNxqI4fuKeJbjixujmAXLU3XbBaYimj+BgPvSZNtwrwKllXUs51XlUlqHbHhsRjNut50bbGEx0Ad06wV2e73pM2L285A7tWzsD96P2ZRXnT/e+VCIzGP/QtSziptpjQ4uVszW0uaOAW9PsPgKhTyv3mX1Nymq8ksLLLYxo8djjhEo122FgaQV5DvONGgl65Vadp3CddG4FiXOalsqxnthNdiVOjQqsP4a6Re8cXLfjR6lYiLfKvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(107886003)(38350700002)(66556008)(4326008)(36756003)(6666004)(1076003)(508600001)(2906002)(66476007)(66946007)(8936002)(38100700002)(316002)(6506007)(186003)(26005)(6486002)(6512007)(83380400001)(52116002)(2616005)(86362001)(5660300002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rgzChaSp8qDBY8FNTmU0wpnSssQ9N34N/98kKJrD+UNC88FYNdIxV0rvc4h5?=
 =?us-ascii?Q?wqhZReyP8zcTe8tbhcyUkbz2xtHrTZPBmp52LHD/NQ+uv9cd4dcMlTPlPJXH?=
 =?us-ascii?Q?hvXXEhBC2vMDpCol33Z1JCm+B04DXsG7SN3sUfsmcbI8L1J6flM7FUa1+WG3?=
 =?us-ascii?Q?57AA3a5G0CMVb4aVBxhoyjv7Jl2HHl1uX50btiVV5zvNPAxHb+j9su+xopyl?=
 =?us-ascii?Q?fWziHgmlfDGPzwk4DQsf8pOvE3HKaGAmKkWBWEQVvwB1okzXOvjCuaFr/ToK?=
 =?us-ascii?Q?f6dB1PLKs6oh4l9p3Xz1fsjPBvF7d5n2fBsyQmEaBOGX8SUzRVE7fEHb1JBx?=
 =?us-ascii?Q?PAtp/NQZwKfn1tRk/e084DINrMFKTGdmTVB3rEhIhHgNSEUlfFV+m9hQSRrX?=
 =?us-ascii?Q?yAVZgENwshE9VL8Q+xngC9cSx6Rnb6SUHdGpllwfwYnS1+tul1Rg1TfB2NTo?=
 =?us-ascii?Q?PxUSkADxRTc41JmuoxIynOMfpm6f9ZWAkg6jiK88M8d4B4/eLKoBlAJqoFdR?=
 =?us-ascii?Q?bYg8Fohj8GQjubUHoSAIBNkrB50/0Awm69GTlhQ4XkdgSsocZ8b9v8XoKSkK?=
 =?us-ascii?Q?hclgU3vSHSdc2GLdUlU3tVIobpZWEKKl9xBTybpCNrZ55vSvfnmOcbTwBKkT?=
 =?us-ascii?Q?dUQoahzQb9iCxSLzXROPGJOL2hWD9pS9ot3FTov7EXVx6VTUD7TvngC6+b74?=
 =?us-ascii?Q?k1e0NPqrr5aFtd2oh/P2YkP1SBuYQrgatv9dJu3VKIQhYavyJ399CI8QoEFx?=
 =?us-ascii?Q?yXCpxj2j99YPVyvL+hIBGo2o6/sZSqGaU/7hMm14L07cb8aI/7xdkqpRGxq4?=
 =?us-ascii?Q?qSRK8b+TJuAZh1PqC1sWm37ufw+a69PeX0GExVvRM9FsocOqSvBxFkkQF6CF?=
 =?us-ascii?Q?cm98sY8PMJIlFmLMZ4QdMZGAebrVvSsObfzrTu+Rfgp/GLgBSX1I/+JZEctA?=
 =?us-ascii?Q?XMO3CYfJpKXc2cwLTfGtqKj+gf2FoGeOcIbegg+7SzB5H1Nmt1N+ONv6+swx?=
 =?us-ascii?Q?srwV9DGh9+HtXDOXyg18yP+f0JfeaVV9Byi0VP2QIAIydEhFlNXRveqGCvki?=
 =?us-ascii?Q?J8eifG0UJbXCENen/CcsFEWx4i7BLhwcCmBSM/VMh7GuwA0ahra/5h6AkKTB?=
 =?us-ascii?Q?fU7ZG3ykgqNjATjEo7SMK9Khi/CDFKvgdKQqmvd5wh0YxnYa3SPMsjMqayAa?=
 =?us-ascii?Q?cVFNPMxzPWIHuYTtH7Yh/yzJIryBYfO6SRUJy6sCCPKyXiKYkjrdUTi4iXXr?=
 =?us-ascii?Q?tvM2luhDok864bLEgNrJ35aqsc+HSkl/cnV0+BSZA7SNqw7UgmsGM2Lx6KfB?=
 =?us-ascii?Q?Bzvuwe9g3t8FPCIf30EmN1wBYrFRDZXg7odlYO1EiQlPlwWWJV4w+WysycH8?=
 =?us-ascii?Q?wZ5VRbg+objpGKY7VnKyMNz4DI4V7rvxu5fuSJOmc6krZsMFYkWvl1o2tVH4?=
 =?us-ascii?Q?xDfbww7leBXoWkopfgT+ds6ZSOVPheRQ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d30ffe5b-a092-4441-64c8-08d9951b83f7
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 05:19:26.1889
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
X-Proofpoint-ORIG-GUID: pxOE1s_46WOBfnnedDVximMlFm8FcqOW
X-Proofpoint-GUID: pxOE1s_46WOBfnnedDVximMlFm8FcqOW
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch has the core work flush function take a worker for when we
support multiple workers. It also adds a helper that takes a vq during
flushing so modules can control which vq/worker to flush.

This temp leaves vhost_work_dev_flush. It will be removed when the drivers
are converted in the next patches.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/vhost.c | 30 +++++++++++++++++++++---------
 drivers/vhost/vhost.h |  1 +
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index f2c6981297d0..e4d765f6c821 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -246,6 +246,26 @@ static void vhost_work_queue_on(struct vhost_worker *worker,
 	}
 }
 
+static void vhost_work_flush_on(struct vhost_worker *worker)
+{
+	struct vhost_flush_struct flush;
+
+	if (!worker)
+		return;
+
+	init_completion(&flush.wait_event);
+	vhost_work_init(&flush.work, vhost_flush_work);
+
+	vhost_work_queue_on(worker, &flush.work);
+	wait_for_completion(&flush.wait_event);
+}
+
+void vhost_vq_work_flush(struct vhost_virtqueue *vq)
+{
+	vhost_work_flush_on(vq->worker);
+}
+EXPORT_SYMBOL_GPL(vhost_vq_work_flush);
+
 void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work)
 {
 	vhost_work_queue_on(dev->worker, work);
@@ -260,15 +280,7 @@ EXPORT_SYMBOL_GPL(vhost_vq_work_queue);
 
 void vhost_work_dev_flush(struct vhost_dev *dev)
 {
-	struct vhost_flush_struct flush;
-
-	if (dev->worker) {
-		init_completion(&flush.wait_event);
-		vhost_work_init(&flush.work, vhost_flush_work);
-
-		vhost_work_queue(dev, &flush.work);
-		wait_for_completion(&flush.wait_event);
-	}
+	vhost_work_flush_on(dev->worker);
 }
 EXPORT_SYMBOL_GPL(vhost_work_dev_flush);
 
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 8f209d1c8890..a985caa35633 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -199,6 +199,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *,
 		      struct vhost_log *log, unsigned int *log_num);
 void vhost_discard_vq_desc(struct vhost_virtqueue *, int n);
 
+void vhost_vq_work_flush(struct vhost_virtqueue *vq);
 void vhost_vq_work_queue(struct vhost_virtqueue *vq, struct vhost_work *work);
 bool vhost_vq_has_work(struct vhost_virtqueue *vq);
 bool vhost_vq_is_setup(struct vhost_virtqueue *vq);
-- 
2.25.1

