Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96A38C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 19:05:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82B956121F
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 19:05:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234253AbhKDTIW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Nov 2021 15:08:22 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:13916 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234229AbhKDTIF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2021 15:08:05 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A4IKgC8007651;
        Thu, 4 Nov 2021 19:05:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=uhy0eaVXtQ5BTjjbq3SmuQky/hU3/yMsNKzsIBCGH+U=;
 b=Z5Fy3yfctuW+pkvmubwPwygxIJFtgl/E8qjxkerz7kKLZzmpFpV7AS7OZTClhkwJY+zI
 Nmccha0bd8MHUd+qsaYzZ85DYfyS2xMTVEEEQD0gHtQMRNUiq7WqbdWdB3HUl3kE+wzt
 hQhzOLmerlYDvcmTqJG8hhETEcXVaCQT3jhN1TZR1+DSD5mASCOJRAtis2T4bMpFhERd
 upSvHxrCsmCJl9RiOl0McqjJZahECN5ZxjdBxl5PAw5PMD2+GUBP+p2LnV62K3L4IIxX
 mMVejdYECrj1/fT4VPHWYZSLG0Q0vRMWRgv6le8oVj7kXt/Xk+9v0SHaeq+qiugFtKTp GA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c3mt5jjnf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 19:05:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A4J18Pk042493;
        Thu, 4 Nov 2021 19:05:22 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by userp3030.oracle.com with ESMTP id 3c27k94tnm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 19:05:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GHF1qUpk14hJ69p7GUvqX2f0uWiTB9O+eew7ZCYthft2pXv4PKiCciBjMq6cA7gUxgLStqLMIP7kGQbD/3kz/0MB3sBfEMYhx0YxZDGzP+AVX111F3VqHIER9LouH0pRUNc8K6oEyTbaiKvczkkoyDF/99eo+PLx/LHNQq8a+oK32DsJWuHta5Jqe46PC8rl6JnS1DCkU9w5FtcZ+o/yMF6qUK7VLg86+ftfhsn1Uh61xCTyk2QUQ/ntqT3g/8XQXHDSTx/ZXFfTQG3Z3R1xoD1SQD6KgVz6PIuPHH+7FV1lmXHMFHk1wVDhhNFptmuP5PKHbV5+Z2q5TfLJOucEXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uhy0eaVXtQ5BTjjbq3SmuQky/hU3/yMsNKzsIBCGH+U=;
 b=hyFLn138I+UyYN7iUJVm3oSEaEt/AGGiBWnyKAhbhDLeGUu94jQKmbM++OTeJS5437WYDPynPWQoR8JxAuSJI691LMjeXorGVVD1fKA5H71jFQPQwCNbJOP7r9z5k86riFJ6qpISVanWlFcrMVzJZ4VX7QRJPTCn7h7JwBL4hU/JKvAFKlvBEQEPjtZByIpRpOKsXCDRih4q5lDB60IvI7IuFMR4o/f1gOV8tpFMwGpDLa5qKU+06e/udQovO9kPFe4HNIk8m/H2rjRybKfPCDKmk0fvJBqdTwh9Y4otQ6s7c7OijhLsFD5ntI072mWmzvogezKvcP9Ue+qG2A/fmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uhy0eaVXtQ5BTjjbq3SmuQky/hU3/yMsNKzsIBCGH+U=;
 b=SullmOThPhPJkA4QEf2dxpjkdfZfRWsrDhssN8mmesoIqV3+Ixal+JZ3YRo4ybgR9eqfPXI/66RR3UaWOeFn1g52dkjMpjelQ7C0pgAHOqFEzR8Iux7GuCV2dyKbEIs76ZF2zM+HlvEvtuITZL9KJYPWTcL3oiDht5hvuP2owm8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB2873.namprd10.prod.outlook.com (2603:10b6:5:63::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4649.15; Thu, 4 Nov 2021 19:05:16 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041%11]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 19:05:16 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V4 12/12] vhost: allow worker attachment after initial setup
Date:   Thu,  4 Nov 2021 14:05:02 -0500
Message-Id: <20211104190502.7053-13-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211104190502.7053-1-michael.christie@oracle.com>
References: <20211104190502.7053-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR07CA0080.namprd07.prod.outlook.com
 (2603:10b6:4:ad::45) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DM5PR07CA0080.namprd07.prod.outlook.com (2603:10b6:4:ad::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Thu, 4 Nov 2021 19:05:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ea4edfb-1fc9-40b7-ef6d-08d99fc60945
X-MS-TrafficTypeDiagnostic: DM6PR10MB2873:
X-Microsoft-Antispam-PRVS: <DM6PR10MB28731EADBB12488DB6852DE2F18D9@DM6PR10MB2873.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 55xXuw+T/WD+pjxsiIItlMC0k7i9uwnDXZ3N8wL6xwdFHriK7Ezusd7MjaCcU0qWVB81wteWZlse5zhlvVavP7ATPt3ry1TqwGmhGg2Hpt8WuQRgAL7tUMRYfMe708wq56jOHS6KFTjA7XsWt9aSRR/NIQ2Yr614R6KWictCA76IyZfVq+e36AieKDMZOluaG2eulT1lmhNJTK0mJqq6eoSYDQRVnZKu8Pm9lPXgl4/TAJLGTvbG8J7HVUx7k2ppZY3mNGAKtqyrGdx/dG9jYmjLaYX5HgXuEQ14yIrU9oqpgyxrJL8eyNwlhJT7wGpYJmvuVd0Svd0BHBH0x+jmFiIhKltS2Zcl7D+RSUHd7NWFMfO2MUtjLxgkvdKIZy41A0AOI1/5PpEsODWDR01a4aWWs4JolfS46pRncSOM2+aS5AlmvKvy0nXP8m2E31Ld0Ceg/TlXW9G6z1KC0UdZ16oT/3duL/WTz6OtwYnKJhxFi0hdWigKloXkptprTI7OyG0USKUQXSby7x44JdAeCzn8Mg11Y7gBaj3ZCupunzco0v2DJEkoqxNLQasmkfxrfHshXpvHwN4x72/EM+n0bKnCvFK/woKVMsQ+bKcl73R+CIjm82hf6ZlwWkk6ZVUNytgzc2zhke9Fv8gtA2ZW79PQ+QNsefCbv7kcGGyB32XfrKNNCOy0/Y4ChoF96e50mGagxzX+s6Sa9yv+Wo5SaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(8676002)(52116002)(6512007)(66556008)(66476007)(6506007)(26005)(66946007)(38100700002)(38350700002)(4326008)(186003)(36756003)(1076003)(86362001)(8936002)(83380400001)(6666004)(316002)(508600001)(956004)(6486002)(2616005)(2906002)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UxFerOYzWQugyyDVTEHDnZC0fXHj1oTrTEHyeaq5sDriCE5u9wiAL2+ykdPT?=
 =?us-ascii?Q?/zqvFXTWVkra3k2LFpjjXkNwLTt7EndFhahIHdIUW8w/u7KTmIy98212P0TT?=
 =?us-ascii?Q?mS9hGXZNUx6JJ0MjucJeTieUF1KZcl5WHcqeg5ElbsgV8zD4o57e0wmf7e8S?=
 =?us-ascii?Q?eByMFqTt9M2CXkhuX65d4xijfxl0mHk7h5yCTXBMYihKQ9BXxoeqx6EB0zZT?=
 =?us-ascii?Q?hy20dmWK/VvJXWrt+sJCQCZYSlfsJ4rVipn8QEHCLRVlFgYV/SmsBBq5G0ZC?=
 =?us-ascii?Q?ScpspJ2FBNiWLdk6ozU+RqNqsAQYB2hqhMeSE5AhOJsVnsnNyiTFDo947oxb?=
 =?us-ascii?Q?oyLSz5BZAW08YHBsEhHJu1tRQVnbDihP8o1/VOQmodWLsn+XM7PGRhEaB8pg?=
 =?us-ascii?Q?4wDb1QOfHdJVMD0AlI6CppDMJwr5GKiUmZi4hHLQl8BGNOcKObpCqQKUAU1b?=
 =?us-ascii?Q?uGhCwYoBQAqKtImOIvXYe3hk8R1wJp2qRCJGiR2l6K6zE49mXg6jyZI8oPd9?=
 =?us-ascii?Q?gsKwkTN7DM12rG3y5iR81tFvy7BnupUfJVAHGtkFX2YVhoEHOLMNr0feML4t?=
 =?us-ascii?Q?adB4KuOMdpInZ6imcjwGXPvg8DsHlSTJYbK4vgOBlVBozKeoAHUJmYDI5aFU?=
 =?us-ascii?Q?tSza0KAKhO1vFnt+bGBUEOFZLHeepn83N4rizpLJAg4ayDm3tXfXMaJnXhCZ?=
 =?us-ascii?Q?vYog3mg6SJr1hfUpJ+uidz2nNcSHBIX+rzBGY5I3rb7xln4kZL0w8EoJTxU9?=
 =?us-ascii?Q?nuXmC1HF8bh6sckUK8tYuXL1RRnMaWs9UqlF4euH3EI5SlG/sSKvmdLj50CC?=
 =?us-ascii?Q?JLiF0p6JOOgG5Hlmi82TiRoIpX6INQFYpq6bYd6RCnM9cdvu02IzwCpS2rDB?=
 =?us-ascii?Q?1EOsNos5LBvOLQPWSktGJy34nTw6iGFJhq8uUxKmnqMYBNgKQfabHqdpYIGw?=
 =?us-ascii?Q?gvF/+IF7CkKA8tT4wEvWZ+Nw0p58BDtHWOAMNuE6+74U22jAW3jD2+P2KA3I?=
 =?us-ascii?Q?0SUxhGeUfGiNXJ411hpghE4DR1KThC7YB+A4pTlif4CUGr55W+vsLsXHAO/2?=
 =?us-ascii?Q?uG+MtCElsioNRxUfWJbOx1/YVlkw7Lhzq9Q0sN+sbwYYBp6+Z0WOo76WErsP?=
 =?us-ascii?Q?kU0sMa5EKN6RbLS4941AkdmBESHgdFGxBjX7yXBjt0YXFtjms1PbRjXPG0Jp?=
 =?us-ascii?Q?OHb0KDWvFDQ1ypmI1ydv+40P5QQS2gt6BGnbCL3RJtDbdfDiyTZuVwhZSLDG?=
 =?us-ascii?Q?DpE4sSaCqZGAQC4mFZ8bICaOg6718tHiriPKThmo6Azg+i5R+ao3gzQ5J1Pg?=
 =?us-ascii?Q?1pYWEq/hlRiTmndFpxWAblftGAKPO82tATo1ZUnNX6BzITfiItb62I/pba2V?=
 =?us-ascii?Q?jqIPsQ4nTkATKR8/TKLVanF5AXGnTQf1kXaElv9z2ZydcllAHnN7eDItsPFS?=
 =?us-ascii?Q?av4ogs4CajUzz61iojRJk2jlNc/QHZzhYQENkKDhAYkDwOW6oXMiHCAaOJ7B?=
 =?us-ascii?Q?yVlFZVcQO6i59+JUxxMn7p63n1jhGwAPNZob4HE7rMed3buRtq2FUrrhD4tQ?=
 =?us-ascii?Q?fYmyZjdUzERNKskeuO/ANtrrGf1ztMUQhY9ej3iEzQXNuWTl2mC3fTJJ/lbQ?=
 =?us-ascii?Q?PVYw3S2UwbUtl3NvvUCJn3wHNbhbCuN8J1pIYT9r+ril1Epn5jGhAF9LPvFg?=
 =?us-ascii?Q?Xq+eaQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ea4edfb-1fc9-40b7-ef6d-08d99fc60945
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 19:05:15.9893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dg9dHjVdl72hqmM7mi84QYXKUNqTtZX8PZ8LUiuxpTqPDvEU8wf/yfnSqUHMEOdMX1rTBREews3h4Zhx731R96fka4zpZbRCnrgJyFMacWU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2873
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10158 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111040076
X-Proofpoint-ORIG-GUID: cKBByJNOqo_YbGIxgTBe_aOh8xTGpECz
X-Proofpoint-GUID: cKBByJNOqo_YbGIxgTBe_aOh8xTGpECz
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch allows userspace to change the vq to worker mapping while it's
in use so tools can do this setup post device creation if needed.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---

 drivers/vhost/vhost.c      | 102 +++++++++++++++++++++++++------------
 drivers/vhost/vhost.h      |   2 +-
 include/uapi/linux/vhost.h |   2 +-
 3 files changed, 71 insertions(+), 35 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 20bf67a846f1..f47710a77853 100644
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
@@ -248,31 +245,45 @@ static void vhost_work_queue_on(struct vhost_worker *worker,
 	}
 }
 
-static void vhost_work_flush_on(struct vhost_worker *worker)
+void vhost_vq_work_queue(struct vhost_virtqueue *vq, struct vhost_work *work)
 {
-	struct vhost_flush_struct flush;
+	struct vhost_worker *worker;
 
-	if (!worker)
-		return;
+	rcu_read_lock();
+	worker = rcu_dereference(vq->worker);
+	if (worker)
+		vhost_worker_work_queue(worker, work);
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL_GPL(vhost_vq_work_queue);
 
-	init_completion(&flush.wait_event);
-	vhost_work_init(&flush.work, vhost_flush_work);
+static void vhost_worker_flush_queue(struct vhost_worker *worker,
+				     struct vhost_flush_struct *flush)
+{
+	init_completion(&flush->wait_event);
+	vhost_work_init(&flush->work, vhost_flush_work);
 
-	vhost_work_queue_on(worker, &flush.work);
-	wait_for_completion(&flush.wait_event);
+	vhost_worker_work_queue(worker, &flush->work);
 }
 
 void vhost_vq_work_flush(struct vhost_virtqueue *vq)
 {
-	vhost_work_flush_on(vq->worker);
-}
-EXPORT_SYMBOL_GPL(vhost_vq_work_flush);
+	struct vhost_flush_struct flush;
+	struct vhost_worker *worker;
 
-void vhost_vq_work_queue(struct vhost_virtqueue *vq, struct vhost_work *work)
-{
-	vhost_work_queue_on(vq->worker, work);
+	rcu_read_lock();
+	worker = rcu_dereference(vq->worker);
+	if (!worker) {
+		rcu_read_unlock();
+		return;
+	}
+
+	vhost_worker_flush_queue(worker, &flush);
+	rcu_read_unlock();
+
+	wait_for_completion(&flush.wait_event);
 }
-EXPORT_SYMBOL_GPL(vhost_vq_work_queue);
+EXPORT_SYMBOL_GPL(vhost_vq_work_flush);
 
 /* Flush any work that has been scheduled. When calling this, don't hold any
  * locks that are also used by the callback. */
@@ -285,7 +296,16 @@ EXPORT_SYMBOL_GPL(vhost_poll_flush);
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
 
@@ -510,7 +530,7 @@ void vhost_dev_init(struct vhost_dev *dev,
 		vq->log = NULL;
 		vq->indirect = NULL;
 		vq->heads = NULL;
-		vq->worker = NULL;
+		rcu_assign_pointer(vq->worker, NULL);
 		vq->dev = dev;
 		mutex_init(&vq->mutex);
 		vhost_vq_reset(dev, vq);
@@ -590,11 +610,32 @@ static void vhost_worker_put(struct vhost_dev *dev, struct vhost_worker *worker)
 	kfree(worker);
 }
 
-static void vhost_vq_detach_worker(struct vhost_virtqueue *vq)
+static void vhost_vq_swap_worker(struct vhost_virtqueue *vq,
+				 struct vhost_worker *new_worker, bool flush)
 {
-	if (vq->worker)
-		vhost_worker_put(vq->dev, vq->worker);
-	vq->worker = NULL;
+	struct vhost_flush_struct flush_work;
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
+		 * worker and there is no work in the old worker.
+		 */
+		synchronize_rcu();
+
+		vhost_worker_flush_queue(old_worker, &flush_work);
+		wait_for_completion(&flush_work.wait_event);
+	}
+
+	vhost_worker_put(vq->dev, old_worker);
 }
 
 static int vhost_workers_idr_iter(int id, void *worker, void *dev)
@@ -611,7 +652,7 @@ static void vhost_workers_free(struct vhost_dev *dev)
 		return;
 
 	for (i = 0; i < dev->nvqs; i++)
-		vhost_vq_detach_worker(dev->vqs[i]);
+		vhost_vq_swap_worker(dev->vqs[i], NULL, false);
 
 	idr_for_each(&dev->worker_idr, vhost_workers_idr_iter, dev);
 }
@@ -667,18 +708,13 @@ static int vhost_vq_attach_worker(struct vhost_virtqueue *vq,
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
 
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index b3786e3537f1..607e95887942 100644
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

