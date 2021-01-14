Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8791BC4321A
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 20:34:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D9EF23B03
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 20:34:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbhANUcl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jan 2021 15:32:41 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31104 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725918AbhANUck (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Jan 2021 15:32:40 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10EK3WpO133088;
        Thu, 14 Jan 2021 15:31:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=w9GOEHUIwadmmQ6/WimiQJ9BqdJfITO+Oan6ZTv5mO4=;
 b=eWg2vY6Rpq1pKQ9E+c/N4BRnUP81IpJSiX4tmCZ1qYPq7GAQ2r9dnrRSuBG3dNggOzpi
 Q5saCITWT7H8DEYFeJWWBz6AtAuDORvQkzx6f2K7aIm8Xf4b3L66BiixFAksMPAeCUKN
 oBf4fhzneIkC+N++QKzaNcTqYSObJNEr9jZ9wZV9qUTkJfeSOv94leXKiakeU6SeueoH
 Pk2fNjCmfeuenvLZCdTBf2wZKxMQu7VM4MjFht3K+TWc3CPT8OMlqKfn9CQZ0zg5Ixq4
 c4SnOmKlaJdFDmSaeFutQ0Fpf4/gcSpizxLA6O7n/tgy7ZnatMsdQ0oYbbBs1DBbj1Yi HQ== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 362vnm8pe0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 15:31:53 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10EKRP40032079;
        Thu, 14 Jan 2021 20:31:52 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04wdc.us.ibm.com with ESMTP id 35y449fsjs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 20:31:52 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10EKVpHX27066818
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jan 2021 20:31:51 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31CF16E052;
        Thu, 14 Jan 2021 20:31:51 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2F906E04C;
        Thu, 14 Jan 2021 20:31:50 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 14 Jan 2021 20:31:50 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH v5 02/21] ibmvfc: move event pool init/free routines
Date:   Thu, 14 Jan 2021 14:31:29 -0600
Message-Id: <20210114203148.246656-3-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210114203148.246656-1-tyreld@linux.ibm.com>
References: <20210114203148.246656-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-14_07:2021-01-14,2021-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=959 phishscore=0
 mlxscore=0 suspectscore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 adultscore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101140115
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The next patch in this series reworks the event pool allocation calls to
happen within the individual queue allocation routines instead of as
independent calls.

Move the init/free routines earlier in ibmvfc.c to prevent undefined
reference errors when calling these functions from the queue allocation
code. No functional change.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 151 +++++++++++++++++----------------
 1 file changed, 76 insertions(+), 75 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 9200fe49c57e..cd9273a5fadb 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -716,6 +716,82 @@ static int ibmvfc_send_crq_init_complete(struct ibmvfc_host *vhost)
 	return ibmvfc_send_crq(vhost, 0xC002000000000000LL, 0);
 }
 
+/**
+ * ibmvfc_init_event_pool - Allocates and initializes the event pool for a host
+ * @vhost:	ibmvfc host who owns the event pool
+ *
+ * Returns zero on success.
+ **/
+static int ibmvfc_init_event_pool(struct ibmvfc_host *vhost,
+				  struct ibmvfc_queue *queue)
+{
+	int i;
+	struct ibmvfc_event_pool *pool = &queue->evt_pool;
+
+	ENTER;
+	pool->size = max_requests + IBMVFC_NUM_INTERNAL_REQ;
+	pool->events = kcalloc(pool->size, sizeof(*pool->events), GFP_KERNEL);
+	if (!pool->events)
+		return -ENOMEM;
+
+	pool->iu_storage = dma_alloc_coherent(vhost->dev,
+					      pool->size * sizeof(*pool->iu_storage),
+					      &pool->iu_token, 0);
+
+	if (!pool->iu_storage) {
+		kfree(pool->events);
+		return -ENOMEM;
+	}
+
+	INIT_LIST_HEAD(&queue->sent);
+	INIT_LIST_HEAD(&queue->free);
+	spin_lock_init(&queue->l_lock);
+
+	for (i = 0; i < pool->size; ++i) {
+		struct ibmvfc_event *evt = &pool->events[i];
+
+		atomic_set(&evt->free, 1);
+		evt->crq.valid = 0x80;
+		evt->crq.ioba = cpu_to_be64(pool->iu_token + (sizeof(*evt->xfer_iu) * i));
+		evt->xfer_iu = pool->iu_storage + i;
+		evt->vhost = vhost;
+		evt->queue = queue;
+		evt->ext_list = NULL;
+		list_add_tail(&evt->queue_list, &queue->free);
+	}
+
+	LEAVE;
+	return 0;
+}
+
+/**
+ * ibmvfc_free_event_pool - Frees memory of the event pool of a host
+ * @vhost:	ibmvfc host who owns the event pool
+ *
+ **/
+static void ibmvfc_free_event_pool(struct ibmvfc_host *vhost,
+				   struct ibmvfc_queue *queue)
+{
+	int i;
+	struct ibmvfc_event_pool *pool = &queue->evt_pool;
+
+	ENTER;
+	for (i = 0; i < pool->size; ++i) {
+		list_del(&pool->events[i].queue_list);
+		BUG_ON(atomic_read(&pool->events[i].free) != 1);
+		if (pool->events[i].ext_list)
+			dma_pool_free(vhost->sg_pool,
+				      pool->events[i].ext_list,
+				      pool->events[i].ext_list_token);
+	}
+
+	kfree(pool->events);
+	dma_free_coherent(vhost->dev,
+			  pool->size * sizeof(*pool->iu_storage),
+			  pool->iu_storage, pool->iu_token);
+	LEAVE;
+}
+
 /**
  * ibmvfc_free_queue - Deallocate queue
  * @vhost:	ibmvfc host struct
@@ -1312,81 +1388,6 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
 	strncpy(login_info->drc_name, location, IBMVFC_MAX_NAME);
 }
 
-/**
- * ibmvfc_init_event_pool - Allocates and initializes the event pool for a host
- * @vhost:	ibmvfc host who owns the event pool
- *
- * Returns zero on success.
- **/
-static int ibmvfc_init_event_pool(struct ibmvfc_host *vhost,
-				  struct ibmvfc_queue *queue)
-{
-	int i;
-	struct ibmvfc_event_pool *pool = &queue->evt_pool;
-
-	ENTER;
-	pool->size = max_requests + IBMVFC_NUM_INTERNAL_REQ;
-	pool->events = kcalloc(pool->size, sizeof(*pool->events), GFP_KERNEL);
-	if (!pool->events)
-		return -ENOMEM;
-
-	pool->iu_storage = dma_alloc_coherent(vhost->dev,
-					      pool->size * sizeof(*pool->iu_storage),
-					      &pool->iu_token, 0);
-
-	if (!pool->iu_storage) {
-		kfree(pool->events);
-		return -ENOMEM;
-	}
-
-	INIT_LIST_HEAD(&queue->sent);
-	INIT_LIST_HEAD(&queue->free);
-	spin_lock_init(&queue->l_lock);
-
-	for (i = 0; i < pool->size; ++i) {
-		struct ibmvfc_event *evt = &pool->events[i];
-		atomic_set(&evt->free, 1);
-		evt->crq.valid = 0x80;
-		evt->crq.ioba = cpu_to_be64(pool->iu_token + (sizeof(*evt->xfer_iu) * i));
-		evt->xfer_iu = pool->iu_storage + i;
-		evt->vhost = vhost;
-		evt->queue = queue;
-		evt->ext_list = NULL;
-		list_add_tail(&evt->queue_list, &queue->free);
-	}
-
-	LEAVE;
-	return 0;
-}
-
-/**
- * ibmvfc_free_event_pool - Frees memory of the event pool of a host
- * @vhost:	ibmvfc host who owns the event pool
- *
- **/
-static void ibmvfc_free_event_pool(struct ibmvfc_host *vhost,
-				   struct ibmvfc_queue *queue)
-{
-	int i;
-	struct ibmvfc_event_pool *pool = &queue->evt_pool;
-
-	ENTER;
-	for (i = 0; i < pool->size; ++i) {
-		list_del(&pool->events[i].queue_list);
-		BUG_ON(atomic_read(&pool->events[i].free) != 1);
-		if (pool->events[i].ext_list)
-			dma_pool_free(vhost->sg_pool,
-				      pool->events[i].ext_list,
-				      pool->events[i].ext_list_token);
-	}
-
-	kfree(pool->events);
-	dma_free_coherent(vhost->dev,
-			  pool->size * sizeof(*pool->iu_storage),
-			  pool->iu_storage, pool->iu_token);
-	LEAVE;
-}
-
 /**
  * ibmvfc_get_event - Gets the next free event in pool
  * @vhost:	ibmvfc host struct
-- 
2.27.0

