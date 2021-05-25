Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E54FCC47085
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:06:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9B1660FE4
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:06:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbhEYSIB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 14:08:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51536 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbhEYSHx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 14:07:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PI5mqO060529;
        Tue, 25 May 2021 18:06:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=LcfSH+XJGNeXyrQSX3IWZ3JhXGfiut6RzDMivAGG4YA=;
 b=Nkn2RSruao8FMbFL2/a+kkk89wlblv0J6ItOTizUpo7jQdanvnNllZ5kMB4HYiiHmWT2
 hGYe/zcnO/CPYWeeF2717fxV1XnXBPDkojThPTyIrUjFgmcJLHGvX6bLhXCBaZEsedjW
 t6CCv87NuHnR7Qx6I0o3QKgv2/S2o1nQwdMyCKq3Q++rvc20skZzwo4PoaS3zYK/aJbU
 AezyRgZh0LmBDgzVMwho2VaHGJKY4/4+VH76D3DDz33tzASBLmFnU8WNqgHmhdkwdzAA
 QlEnrwO54ggSp5RE7UGlzGFw6p2GcHt8FgAybVCn1eUExEEVMYF89JLowPROgraujiFx 8w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 38ptkp6uqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:06:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PI6DTx185061;
        Tue, 25 May 2021 18:06:18 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by userp3020.oracle.com with ESMTP id 38qbqsga9k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:06:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F1+MbKX7jp43q60cPosWFbTPI8HTjHyMPedKi2EIipW5s/aMKT6nwxoPfnjHKf7mfiZC7lKnMFLcBVBUxT21l2qyGRIDRB1tio8T8sRSJCb7/FQHIr52lT7prnRUnbYsLDtfZhm0Rydi7cDy3JZvTYPllPFel0zVuQV8w245r7u+e4NLsOGjZXueUGaxD8EAo7wVdv/NYr9OshFJlr9sDI2Ex22VmIciCFqhHy0drgXZZ4SrZmNSIOlvZheAi1eol/xgSj/3GxhH/ukV3J1JH5ACrlddObGsbPtNb+dgCCB+NeOqxvs/00GLiln6pb6/DJfOlgFyIbRzwF94+fsslw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LcfSH+XJGNeXyrQSX3IWZ3JhXGfiut6RzDMivAGG4YA=;
 b=IIi+EH1AW9nqowvqg4nphWRyVFL0pUMo2LYXbg9bI4dNtS3Kj7/WROhMUo3dyxxWFgt9a8KRYauCF/e2q1PLQUCjN8saErJ+KqMhUCBh6zm8FprFEsuXigQz7PCCgLeyvh11e5yrvQl+R9o2zxJ/oNrmQvBDUFKB/H4tdyYmVEXpp7iuDqZ8jrYvobmk/EEH6rUyrlrqaW8S0gRYTWN+h0fu1MM+8D3fghB7Y3ykkIu9mESnalfFhaY6017E8vWFWz5CBEgYr2NWrZkBQOmOOYKiVJagct3x8lhfirfpx5pHCepIJVB/rWqPQvU5tqJMbnS5C2uju30ehX1q1R2Lug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LcfSH+XJGNeXyrQSX3IWZ3JhXGfiut6RzDMivAGG4YA=;
 b=SDZdv5v8N51J2WUiH1Hf09M77ZzsvZpF384Pq3wxykrQO8djG4WrxomIkU6lEaPBhdv4/O/SUpe2QegeYF3QxFUOR6Qfq72pzGG28oPSc0uDbq56imvtbjUpk9fIJWbZwjrr5sYs7jA13BOa5xuAuD5/TPjP+klAUBIrLwtk9pg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3431.namprd10.prod.outlook.com (2603:10b6:a03:86::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 18:06:16 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 18:06:16 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 4/9] vhost: allow vhost_polls to use different vhost_workers
Date:   Tue, 25 May 2021 13:05:55 -0500
Message-Id: <20210525180600.6349-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525180600.6349-1-michael.christie@oracle.com>
References: <20210525180600.6349-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR13CA0021.namprd13.prod.outlook.com
 (2603:10b6:5:bc::34) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR13CA0021.namprd13.prod.outlook.com (2603:10b6:5:bc::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.12 via Frontend Transport; Tue, 25 May 2021 18:06:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ea78da6-24ad-412f-c0d8-08d91fa7c9f8
X-MS-TrafficTypeDiagnostic: BYAPR10MB3431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB343194EA58FB551319C902FEF1259@BYAPR10MB3431.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: clEyXZfxKj4XUZgYsdfdEBNL2+B39BnHHbBNFo+P0WatVuXApOQSPQx6gE/dm4oF+r6x9UDudXIhGiG0QCL0WZeuoKrUG28+YUnZY5eaSzRmlnLBEVl0gZgLyh/xeojVGL6FFP6gahSMm5LfkC5CNt9HqI1lbM2zURigVHyDn6RyOei/pK7jV1jxviRudWLSXhoGNpoxu4ms3L6C8RmItt/tmIa7QvpqgODNIYJMCYdEpeT8IcXVsQN9svz0ZqgRmul2QqsRPbNmmJA0pFb/n53X5RIrcdVMjhCi4ZIZT0cYE84S/EluZ3BClMfCpzQxvc/y1V+ypYnVtxbzi+6prSHrqkOw3z0jQXwCV/sqC88JPkZxzYRvwnNyofbjFkQgPUVRjUpBtw2eIt19bzvBzrQPuSWnfPkOGmZ9hyWmKrzT+uYqKeD3Y5Fto8GElDfMjn3Mun0GpXzTXZARp16vCPRegar8AvNqRipMvAZuf/Awt3ClvtGCNCeKNYzssb3emnG2jbZvRDkXZ4+hG+CUwsqB1uBqmS37nE+mIjzzzE8yYf0gY0p7Hq/IQ49hjAY+N/mJzS5pzwfgfxYqCZkIbQZ3T0ID4/8DX8tBCo0xQmk3gwaQ8W9qB6NBo6RdHM2Z1gnYM7FqEaC4clJKBGk7qaWjVHXsRYIqqXy6ECFDH+tU7aZOjTQO2IY3K1FZGCis
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(39860400002)(136003)(366004)(6512007)(26005)(38350700002)(186003)(66556008)(66476007)(52116002)(2616005)(8936002)(86362001)(6506007)(38100700002)(83380400001)(956004)(66946007)(8676002)(4326008)(5660300002)(2906002)(1076003)(6486002)(316002)(16526019)(6666004)(107886003)(478600001)(36756003)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7FskS1m1W9Ol8QNqHH0zbgSayW+0N9pxs5WpniNGkoGrV53jyUI+rmZvpYyl?=
 =?us-ascii?Q?eZaIbY+VRkm7NIJiInoglmSM/2Cqt2/YR654driLJWVWXy+8+R5OCnj2WuP7?=
 =?us-ascii?Q?de1jk7WmhSCwp5tFWgNb9NkvKIxa41UrNXbWWGmetEg4MAMWSIbU0xWVq/dm?=
 =?us-ascii?Q?lap8GXGOAedhIrlMxY6D/TqHh+1+WfvCEwd+oqRR+DmPyCE6jF1SaLoUqhOl?=
 =?us-ascii?Q?C8Gm5PKuaARPZIBWYp+Zqjc/Qz0wb10Kt/EubjazSaiekbe/aP/z6vC1rlKQ?=
 =?us-ascii?Q?+4PbVJSkRveXyh9OzHGljCae4htD3H2s0eIIgKj4ARKvp3gZHAYGM7yf6Up0?=
 =?us-ascii?Q?5i3jkBkXYxXFJg2oG0qBicOveO6wcbjiIDixjJwqnKvO5l+nBa/1CCX/vlwN?=
 =?us-ascii?Q?Pwb9ivwhemMqpyYuMbvg9u4R0Q+8Wgx0NCTC8wyCWodYY4C3qxY1yefuyZQQ?=
 =?us-ascii?Q?b+rZvzyA2xN3PwyxnEVEtoyZiRrUMMy2HrzJ8BkY5fILFM3j9eViYBjQfqY6?=
 =?us-ascii?Q?Qdr7/4jIIwsKffkm8p8POLyXcQEsB2SXG1WC9oiygFrraSu/y+U0u/aE9zFA?=
 =?us-ascii?Q?Sy8uUQb3lcOdseArmsCyrqHJr1fatNn+77KixD03IfywUr5AyMgldynFbApH?=
 =?us-ascii?Q?MEHy6lr5OUsXTziG0PbVbaFtl+M3jR9RKJHupHT4Fn3ijF59UZbRY6rEzVJw?=
 =?us-ascii?Q?6fzVZAHnFwKaQ+fmYgeLU9MDsfMc5OX0TJyGyeYDAlL9GuqKd1MmcyPo8/KJ?=
 =?us-ascii?Q?7t/bfbHg9zrYEYLFCkud92ol/ujJZSFohO5tugWQMBiK3Su7pk5WRAuBI5hd?=
 =?us-ascii?Q?CWe+0Yy3hUA5QG6fH3pqaZvf8RCUNhOk2QKgztjGJsL9jppD7u3r1j5pWs1g?=
 =?us-ascii?Q?XmIlEZ7Tc1v1QiEI6Sb4jBtfKfm/Np90d0npg/dxejHrBNgoZ4GuHrLQcA5A?=
 =?us-ascii?Q?MpBVB/mfgS2FVu9Q9yN8SxWSX9soAcSyeGIYj+ST0+0M2N8e98pDcuOWui2Z?=
 =?us-ascii?Q?4JhWVnYilTBx852QvQQPwmwbpC9pHI0Q0RyOzFEmV06aDxv1MgbQ2y4uhuDZ?=
 =?us-ascii?Q?ke+uFQ34s9ruHIdlcxOiHl+IbvUvkCoEiPpXaKp32JfdkqhICsrNheFrhsLJ?=
 =?us-ascii?Q?SRmHU+JA7qHdwU6bYEfKrVTSmVQNcGdmlZnjNuFemY3iYHs/Dqzob+Ti/Scy?=
 =?us-ascii?Q?FzqgGsEYm0d6prfh4NQAeDVlm2Ta/Pa2WGGVInNaGuoILOgpQMd+X7ptK/Se?=
 =?us-ascii?Q?cHL5zF0gQW9OT/ipB5NbqPsNqJdc24+R/T7A3v8J+kUBBj9MuyiF3Thpy6Ej?=
 =?us-ascii?Q?Md38iS/WH2g53TyDCuQ7NZAJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ea78da6-24ad-412f-c0d8-08d91fa7c9f8
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 18:06:16.1456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T8Iq096rX50Lr3cSBd+rmpcqW2oiuo/hteHLyPdQA3WzJVFFU7dPN4X4EgTamCZM+IErlfmKDoLOMuOeq5WANTdIABq4AVYCE/gBj/m7Nmk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3431
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250111
X-Proofpoint-GUID: wDukkXbXR0u_4V5LcnlE2emKSQl3FE8i
X-Proofpoint-ORIG-GUID: wDukkXbXR0u_4V5LcnlE2emKSQl3FE8i
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105250111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This allows vhost_polls to use the worker the vq the poll is associated
with.

This also exports a helper vhost_vq_work_queue which is used here
internally, and will be used in the vhost-scsi patches.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/net.c   |  6 ++++--
 drivers/vhost/vhost.c | 19 ++++++++++++++++---
 drivers/vhost/vhost.h |  6 +++++-
 3 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index df82b124170e..948bc3d361ab 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1334,8 +1334,10 @@ static int vhost_net_open(struct inode *inode, struct file *f)
 		       VHOST_NET_PKT_WEIGHT, VHOST_NET_WEIGHT, true,
 		       NULL);
 
-	vhost_poll_init(n->poll + VHOST_NET_VQ_TX, handle_tx_net, EPOLLOUT, dev);
-	vhost_poll_init(n->poll + VHOST_NET_VQ_RX, handle_rx_net, EPOLLIN, dev);
+	vhost_poll_init(n->poll + VHOST_NET_VQ_TX, handle_tx_net, EPOLLOUT, dev,
+			vqs[VHOST_NET_VQ_TX]);
+	vhost_poll_init(n->poll + VHOST_NET_VQ_RX, handle_rx_net, EPOLLIN, dev,
+			vqs[VHOST_NET_VQ_RX]);
 
 	f->private_data = n;
 	n->page_frag.page = NULL;
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 4bfa9a7a51bb..3cc1196d465b 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -187,13 +187,15 @@ EXPORT_SYMBOL_GPL(vhost_work_init);
 
 /* Init poll structure */
 void vhost_poll_init(struct vhost_poll *poll, vhost_work_fn_t fn,
-		     __poll_t mask, struct vhost_dev *dev)
+		     __poll_t mask, struct vhost_dev *dev,
+		     struct vhost_virtqueue *vq)
 {
 	init_waitqueue_func_entry(&poll->wait, vhost_poll_wakeup);
 	init_poll_funcptr(&poll->table, vhost_poll_func);
 	poll->mask = mask;
 	poll->dev = dev;
 	poll->wqh = NULL;
+	poll->vq = vq;
 
 	vhost_work_init(&poll->work, fn);
 }
@@ -298,9 +300,15 @@ bool vhost_has_work(struct vhost_dev *dev)
 }
 EXPORT_SYMBOL_GPL(vhost_has_work);
 
+void vhost_vq_work_queue(struct vhost_virtqueue *vq, struct vhost_work *work)
+{
+	vhost_work_queue_on(work, vq->worker);
+}
+EXPORT_SYMBOL_GPL(vhost_vq_work_queue);
+
 void vhost_poll_queue(struct vhost_poll *poll)
 {
-	vhost_work_queue(poll->dev, &poll->work);
+	vhost_vq_work_queue(poll->vq, &poll->work);
 }
 EXPORT_SYMBOL_GPL(vhost_poll_queue);
 
@@ -359,6 +367,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
 	vq->busyloop_timeout = 0;
 	vq->umem = NULL;
 	vq->iotlb = NULL;
+	vq->worker = NULL;
 	vhost_vring_call_reset(&vq->call_ctx);
 	__vhost_vq_meta_reset(vq);
 }
@@ -527,7 +536,7 @@ void vhost_dev_init(struct vhost_dev *dev,
 		vhost_vq_reset(dev, vq);
 		if (vq->handle_kick)
 			vhost_poll_init(&vq->poll, vq->handle_kick,
-					EPOLLIN, dev);
+					EPOLLIN, dev, vq);
 	}
 }
 EXPORT_SYMBOL_GPL(vhost_dev_init);
@@ -662,6 +671,7 @@ static struct vhost_worker *vhost_worker_create(struct vhost_dev *dev)
 static int vhost_worker_try_create_def(struct vhost_dev *dev)
 {
 	struct vhost_worker *worker;
+	int i;
 
 	if (!dev->use_worker || dev->workers)
 		return 0;
@@ -674,6 +684,9 @@ static int vhost_worker_try_create_def(struct vhost_dev *dev)
 	if (!worker)
 		goto free_workers;
 
+	for (i = 0; i < dev->nvqs; i++)
+		dev->vqs[i]->worker = worker;
+
 	dev->workers[worker->id] = worker;
 	dev->num_workers++;
 	return 0;
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index fa1af4106755..6880e7a29872 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -41,14 +41,17 @@ struct vhost_poll {
 	struct vhost_work	work;
 	__poll_t		mask;
 	struct vhost_dev	*dev;
+	struct vhost_virtqueue	*vq;
 };
 
 void vhost_work_init(struct vhost_work *work, vhost_work_fn_t fn);
 void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work);
 bool vhost_has_work(struct vhost_dev *dev);
+void vhost_vq_work_queue(struct vhost_virtqueue *vq, struct vhost_work *work);
 
 void vhost_poll_init(struct vhost_poll *poll, vhost_work_fn_t fn,
-		     __poll_t mask, struct vhost_dev *dev);
+		     __poll_t mask, struct vhost_dev *dev,
+		     struct vhost_virtqueue *vq);
 int vhost_poll_start(struct vhost_poll *poll, struct file *file);
 void vhost_poll_stop(struct vhost_poll *poll);
 void vhost_poll_flush(struct vhost_poll *poll);
@@ -76,6 +79,7 @@ struct vhost_vring_call {
 /* The virtqueue structure describes a queue attached to a device. */
 struct vhost_virtqueue {
 	struct vhost_dev *dev;
+	struct vhost_worker *worker;
 
 	/* The actual ring of buffers. */
 	struct mutex mutex;
-- 
2.25.1

