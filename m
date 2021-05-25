Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2098CC47084
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:06:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05907613D8
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:06:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbhEYSIE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 14:08:04 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:39822 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231960AbhEYSH6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 14:07:58 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PI51Cx110223;
        Tue, 25 May 2021 18:06:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=BDD2zD4Z9eqQ4D79sxtj+QB1WP36mQ1ylgzUKEXeDy0=;
 b=mEajGOD6RFZOSnuAgS1GqZO8jpmcN20M/aOE7KYHz6juGepmlzwUas3ErM6CPgg5P+0t
 ZXK4E7AXxpVTdaUO5Vie6hpPM8BWDiP03NWvXjR64vACXgm2Vx7sK/dAA5saqscWR+V+
 qRdS0qe8pWVSGfWCvWbMwllmlSyN8OwtyREkrFNk48oBbPVbOPYLWVzjxSFxhhcSfbqn
 m/i8He0CeCXRElPDFunQewZQLUFz8OqFrgQrqDdM/bhH0F4cId/N8EBs3PqzKJXk/Yi5
 7A64XB4TytlvrzQ+BYwQHEObFutGU+NkvAniW8OqlvkIN+NvqCn+/OJw8GatUq7+pmx3 Tw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 38pqfcexvt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:06:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PI6DUZ185109;
        Tue, 25 May 2021 18:06:23 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2046.outbound.protection.outlook.com [104.47.56.46])
        by userp3020.oracle.com with ESMTP id 38qbqsgac5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:06:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nu0ejN76PLxN6oiyOKFpNIF5EwZ4BCcWUhDYO23VktnldyctQJtHwq6w8xzWrAa+tuBC6owhTrNQldMGua7Vy7OuSa2eQyswL67c853c1FVdsmm84+FMNCSaCJfSywV5drx7NnehK8/q/119qBWHl8qDUFB/EdUTJNLZyio5WPaRptym0wTM2V2AewuicJA8LHnm3LI6K1gToBGAp93JwaZQar8wCU49KIR0qJRlHTQQJoNM4FMXraHg/ynf/dTk4UryaqaRiV/RpacMsyq38Yx5m+WI8h0qG+REPOLwcYOG8dkneUfHZnQeWHa9IpeVAN7iPaaGP0uV251xwVvjag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BDD2zD4Z9eqQ4D79sxtj+QB1WP36mQ1ylgzUKEXeDy0=;
 b=n0QiE60/L3wLXS60wLyLEGTnt0so6i9R6cAAMX6vPO3DYx2p5wwmLq4VadJAaFlIzbyuKGMNf6YCVXwLGtF0nQOnDpCdc4P82A+V4hSlbEGIAX90xbsO8eBlUtA3pEty6FUuTtndL0wpSg5DuoEvHP7rC4u+bbxs2CEtGM52VVQ8Uydl8aMxgBMW3En0BqFJtlHqhNIW0JCQKCQ8vxwn4o3ShbBy+f81wHWszEzpSaODFudnR8CGHWlqOdEeLqZRx4BoCI2LxEJSJsiu+y3vksw/gFyg9iyW6E+jJk1KZzyPjUMAnoSSbwnnPvr3PLpEmd1IVbENWpgQouD8F/9S+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BDD2zD4Z9eqQ4D79sxtj+QB1WP36mQ1ylgzUKEXeDy0=;
 b=FeY7Mh7NyWbGzF19UXt1MKoCgHK7M/r3HsBAORpGY37anl0iQ7cP6tKBquSuVz9vCwmcUXrNi6MJaihbbb71E9WrtcsuBfTrFkBWkMJJk3qtC9YMQe42P547wMrhVKET9rS+YtqQ+gXolYqPbis47XAj3JLNrlxnKa87YLzUwy0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4639.namprd10.prod.outlook.com (2603:10b6:a03:2db::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Tue, 25 May
 2021 18:06:21 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 18:06:21 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 7/9] vhost: allow userspace to create workers
Date:   Tue, 25 May 2021 13:05:58 -0500
Message-Id: <20210525180600.6349-8-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DM6PR13CA0021.namprd13.prod.outlook.com (2603:10b6:5:bc::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.12 via Frontend Transport; Tue, 25 May 2021 18:06:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4524a5d-6cdc-46be-d85e-08d91fa7ccdc
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4639:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4639EE3527A9E918D9652D9DF1259@SJ0PR10MB4639.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:198;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QIzRP/AnJPEZkdljlCGtbnBq+FD34opBQjI+u+sN6POJ1JiLXHXHqfTHXPkObXLPLTst6DlMlQ0Tgyeo23FT4fgVrd8xy86iGJRYOg5iaoquyaPF9BIqMD6aqMy16P1wdKlcNso//zRFTQ7G9bi3s8NuJleeWwL3FVLTgepuPS/xsRmYChfxZiLYCgMjbOBrH4sMTLwjvE4pVqnxYZ7uTFcz92KfgWyR6fiSWBJ3wmdR2H63ZI9lUvVgK+tLWWEVYCBsa9EAZEFzx+dDTALVo/ZLev2+XiakXJsN4AEdgEtaeSY3uTm015brXywsuIVLLoIW+jE6GFsPagc847eaFFQG2rIbisQ+Jw0uz4svwM1q+cm9llWiK89+jFB9kDEBbQ1KlQ6VgQwhmsiAn0Iao86dlAjJNPEi6tW2TJ7hY8w76XjzH41Elz5SmmVQ5G0ncsBUzzLwN+/KYH5LOHX7xkLXbERCDv7iRmaDv60YeCJ7RPNW/KOmp8lIAsJZQ/R2XXaJC1RWvt4W1LsPk2O4duZg15phdioDqnWqLsTHfgOkP6/wZpRtbSpWiMgpbxCswzWQo9Cz6suYFHgtC1JqGPKZyJraBsZmxsoDPFJmN180yiZ/x9IryUO2MSETEDfHdqqoiwS1tHlMxsVKBx2wa7meaKGbnNGODR+JXmx1Vmr5w4zSsBMfR0VXk6A4q+2P
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(376002)(366004)(136003)(346002)(36756003)(2616005)(83380400001)(4326008)(186003)(316002)(6512007)(6666004)(6486002)(1076003)(8676002)(16526019)(478600001)(2906002)(52116002)(66556008)(38350700002)(86362001)(66476007)(26005)(5660300002)(38100700002)(956004)(66946007)(8936002)(6506007)(107886003)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?eXCoNz4Or1M0FfFjF/wcuwJSuc55v5dl+KbIFEeAO3s9/MET51Fo9rGFrIm7?=
 =?us-ascii?Q?O+ZIztZf6y4Bj/QiLrFj3EcylT1S4ySo9oxtmbzVGDMcNxNbdQim9k3Y2l53?=
 =?us-ascii?Q?eEXKLc6I8wmHuC9RVyYnRyJc0lknIP5jfCJBQuppkpmK4r3SD8Oyg8AFbomQ?=
 =?us-ascii?Q?OBknxFtVzSzKHClBON30VGhMuj8qSEE17rtqW9/6VvyOfcc9L5WTN72Mn8vo?=
 =?us-ascii?Q?D9C/Tfc54XYLiKCe51AmaKfBE9awqwysDVjFit3YcjpywDAe0e07Neh4rFPR?=
 =?us-ascii?Q?395m4ubhuzQOc6Hsh2V38JY28SWIxbxm8wGvHKznpJjBqOvnZU6Azg9vvbAQ?=
 =?us-ascii?Q?z8ILdSY/wsz2IzoG6igKvnaEveST4EabDaOQxU7SFrqLbWChnOpj6S9HaYhv?=
 =?us-ascii?Q?qGaWqoAZeIk/2t1AYedFrhHRCr0RUcy0pS3Pitw8d0918U5ntjnK26Ff5Iy9?=
 =?us-ascii?Q?XjDhJ9ffNBHler6jS+Fei82/8UYkY3ierbb1IUJGPyiMkxi83IpSNTAJyvyB?=
 =?us-ascii?Q?DHprCJt+Bdy8dhAjLsoRC5Egk6GNs1PZ/550lSpNhvpfLSh0rSUUMKEbEzZs?=
 =?us-ascii?Q?olkbtKW30zl+QMhfvJDDWN5gDQ2wSUzm2Jqng+AumWTSDfhQlsiFrjoYy/QY?=
 =?us-ascii?Q?5tp5nxmyXa6uaK0ZbKIUtj3hvRrJnhbAajmJVsYhf/vrPsIjFO+Rwd0wjrxv?=
 =?us-ascii?Q?mD+G6LSwSiaF4YqgRwSEF2Zdr4hIDg3HA2IKkYjltw7EPKDiADftJh3IdhpM?=
 =?us-ascii?Q?1fhNVjtqZ0lGMcrfXWd2QfYYi9HeA3BX7fIhOP0ttDZr8piV0Q4Dyb2xfZpI?=
 =?us-ascii?Q?im+1tAwsKv17rDavOIeN1PyVE7Sig7myD3RnE4LnDv464cnwAkJ5xdxxdbC+?=
 =?us-ascii?Q?zwL2yTVEntESeDFyd+i5FjMu/msNoAB5NZ85ewvfBuN2QAn0fDpk4NreY5kf?=
 =?us-ascii?Q?YT3c0Zk0yfdE50ikIK5RNEbRTk+GGtI3KTNs2D1IYqJ92ZM/AUFCJcU7j9qY?=
 =?us-ascii?Q?/nWCnpm1yEwMcyxPpRORkSm8mCJkwdD8+p8tBQEdFISAalZsIpETk5IB6Xcf?=
 =?us-ascii?Q?AgGBvGj8T+MjrbBzqwx7ufEuMUoFvG5CsP1aH3qimQ6dNb4qfhfTcS42PDBN?=
 =?us-ascii?Q?CZu3ESycNq1COcEaDpyb4iP3KWxoL6Uf63CqzZphEFyKmOLilg/yRqJd+Ozs?=
 =?us-ascii?Q?HelT9VjgguSUWm92+oyV5h7mIsPWCYDnXYDBtMk7bs/Fp3oGPhrdl8n7tARI?=
 =?us-ascii?Q?rqOELQsROJj9u/98M+i8bdO0S2AWshJxw7ktTef7U/dNVdLc6yZzcITg6Xck?=
 =?us-ascii?Q?uJwQ652VAhpZaDvIdPFZ/FCV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4524a5d-6cdc-46be-d85e-08d91fa7ccdc
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 18:06:21.0778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I3DBZ6InmdHDyA+SjsaeGMi4rkzZ8aQgTNWI996Oyx+GPaY+tAaRRW+enfRDRm6Lwh/3d34uri2sYv5VfNyw0jFZG1B64vdqKFH0Kw6hXZ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4639
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250111
X-Proofpoint-ORIG-GUID: mfnR38DOrThe9PWOEm0hT2IW1adgrNL4
X-Proofpoint-GUID: mfnR38DOrThe9PWOEm0hT2IW1adgrNL4
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch allows userspace to create workers and bind them to vqs, so you
can have N workers per dev and also share N workers with M vqs. The next
patch will allow sharing across devices.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/vhost.c            | 94 +++++++++++++++++++++++++++++++-
 drivers/vhost/vhost.h            |  3 +
 include/uapi/linux/vhost.h       |  6 ++
 include/uapi/linux/vhost_types.h | 12 ++++
 4 files changed, 113 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 345ade0af133..981e9bac7a31 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -30,6 +30,7 @@
 #include <linux/interval_tree_generic.h>
 #include <linux/nospec.h>
 #include <linux/kcov.h>
+#include <linux/hashtable.h>
 
 #include "vhost.h"
 
@@ -42,6 +43,9 @@ module_param(max_iotlb_entries, int, 0444);
 MODULE_PARM_DESC(max_iotlb_entries,
 	"Maximum number of iotlb entries. (default: 2048)");
 
+static DEFINE_HASHTABLE(vhost_workers, 5);
+static DEFINE_SPINLOCK(vhost_workers_lock);
+
 enum {
 	VHOST_MEMORY_F_LOG = 0x1,
 };
@@ -617,8 +621,17 @@ static void vhost_detach_mm(struct vhost_dev *dev)
 	dev->mm = NULL;
 }
 
-static void vhost_worker_free(struct vhost_worker *worker)
+static void vhost_worker_put(struct vhost_worker *worker)
 {
+	spin_lock(&vhost_workers_lock);
+	if (!refcount_dec_and_test(&worker->refcount)) {
+		spin_unlock(&vhost_workers_lock);
+		return;
+	}
+
+	hash_del(&worker->h_node);
+	spin_unlock(&vhost_workers_lock);
+
 	WARN_ON(!llist_empty(&worker->work_list));
 	kthread_stop(worker->task);
 	kfree(worker);
@@ -632,7 +645,7 @@ static void vhost_workers_free(struct vhost_dev *dev)
 		return;
 
 	for (i = 0; i < dev->num_workers; i++)
-		vhost_worker_free(dev->workers[i]);
+		vhost_worker_put(dev->workers[i]);
 
 	kfree(dev->workers);
 	dev->num_workers = 0;
@@ -652,6 +665,8 @@ static struct vhost_worker *vhost_worker_create(struct vhost_dev *dev)
 	worker->id = dev->num_workers;
 	worker->dev = dev;
 	init_llist_head(&worker->work_list);
+	INIT_HLIST_NODE(&worker->h_node);
+	refcount_set(&worker->refcount, 1);
 
 	task = kthread_create(vhost_worker, worker, "vhost-%d", current->pid);
 	if (IS_ERR(task))
@@ -664,6 +679,9 @@ static struct vhost_worker *vhost_worker_create(struct vhost_dev *dev)
 	if (ret)
 		goto stop_worker;
 
+	spin_lock(&vhost_workers_lock);
+	hash_add(vhost_workers, &worker->h_node, worker->task->pid);
+	spin_unlock(&vhost_workers_lock);
 	return worker;
 
 stop_worker:
@@ -673,6 +691,67 @@ static struct vhost_worker *vhost_worker_create(struct vhost_dev *dev)
 	return NULL;
 }
 
+static struct vhost_worker *vhost_worker_find(struct vhost_dev *dev, pid_t pid)
+{
+	struct vhost_worker *worker, *found_worker = NULL;
+
+	spin_lock(&vhost_workers_lock);
+	hash_for_each_possible(vhost_workers, worker, h_node, pid) {
+		if (worker->task->pid == pid) {
+			/* tmp - next patch allows sharing across devs */
+			if (worker->dev != dev)
+				break;
+
+			found_worker = worker;
+			refcount_inc(&worker->refcount);
+			break;
+		}
+	}
+	spin_unlock(&vhost_workers_lock);
+	return found_worker;
+}
+
+/* Caller must have device mutex */
+static int vhost_vq_set_worker(struct vhost_virtqueue *vq,
+			       struct vhost_vring_worker *info)
+{
+	struct vhost_dev *dev = vq->dev;
+	struct vhost_worker *worker;
+
+	if (vq->worker) {
+		/* TODO - support changing while works are running */
+		return -EBUSY;
+	}
+
+	if (info->pid == VHOST_VRING_NEW_WORKER) {
+		worker = vhost_worker_create(dev);
+		if (!worker)
+			return -ENOMEM;
+
+		info->pid = worker->task->pid;
+	} else {
+		worker = vhost_worker_find(dev, info->pid);
+		if (!worker)
+			return -ENODEV;
+	}
+
+	if (!dev->workers) {
+		dev->workers = kcalloc(vq->dev->nvqs,
+				       sizeof(struct vhost_worker *),
+				       GFP_KERNEL);
+		if (!dev->workers) {
+			vhost_worker_put(worker);
+			return -ENOMEM;
+		}
+	}
+
+	vq->worker = worker;
+
+	dev->workers[dev->num_workers] = worker;
+	dev->num_workers++;
+	return 0;
+}
+
 /* Caller must have device mutex */
 static int vhost_worker_try_create_def(struct vhost_dev *dev)
 {
@@ -1680,6 +1759,7 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 	struct eventfd_ctx *ctx = NULL;
 	u32 __user *idxp = argp;
 	struct vhost_virtqueue *vq;
+	struct vhost_vring_worker w;
 	struct vhost_vring_state s;
 	struct vhost_vring_file f;
 	u32 idx;
@@ -1794,6 +1874,15 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 		if (copy_to_user(argp, &s, sizeof(s)))
 			r = -EFAULT;
 		break;
+	case VHOST_SET_VRING_WORKER:
+		if (copy_from_user(&w, argp, sizeof(w))) {
+			r = -EFAULT;
+			break;
+		}
+		r = vhost_vq_set_worker(vq, &w);
+		if (!r && copy_to_user(argp, &w, sizeof(w)))
+			r = -EFAULT;
+		break;
 	default:
 		r = -ENOIOCTLCMD;
 	}
@@ -2726,6 +2815,7 @@ EXPORT_SYMBOL_GPL(vhost_set_backend_features);
 
 static int __init vhost_init(void)
 {
+	hash_init(vhost_workers);
 	return 0;
 }
 
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 0a252dd45101..75b884ad1f17 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -14,6 +14,7 @@
 #include <linux/atomic.h>
 #include <linux/vhost_iotlb.h>
 #include <linux/irqbypass.h>
+#include <linux/refcount.h>
 
 struct vhost_work;
 typedef void (*vhost_work_fn_t)(struct vhost_work *work);
@@ -28,6 +29,8 @@ struct vhost_work {
 struct vhost_worker {
 	struct task_struct	*task;
 	struct llist_head	work_list;
+	struct hlist_node	h_node;
+	refcount_t		refcount;
 	struct vhost_dev	*dev;
 	int			id;
 };
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index c998860d7bbc..ce32119cb139 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -70,6 +70,12 @@
 #define VHOST_VRING_BIG_ENDIAN 1
 #define VHOST_SET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x13, struct vhost_vring_state)
 #define VHOST_GET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x14, struct vhost_vring_state)
+/* Create/bind a vhost worker to a virtqueue. If pid > 0 and matches an existing
+ * vhost_worker thread it will be bound to the vq. If pid is
+ * VHOST_VRING_NEW_WORKER, then a new worker will be created and bound to the
+ * vq.
+ */
+#define VHOST_SET_VRING_WORKER _IOWR(VHOST_VIRTIO, 0x15, struct vhost_vring_worker)
 
 /* The following ioctls use eventfd file descriptors to signal and poll
  * for events. */
diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhost_types.h
index f7f6a3a28977..5113baa8bc3e 100644
--- a/include/uapi/linux/vhost_types.h
+++ b/include/uapi/linux/vhost_types.h
@@ -47,6 +47,18 @@ struct vhost_vring_addr {
 	__u64 log_guest_addr;
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
+	__kernel_pid_t pid;
+};
+
 /* no alignment requirement */
 struct vhost_iotlb_msg {
 	__u64 iova;
-- 
2.25.1

