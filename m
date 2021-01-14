Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1C25C4332D
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 20:35:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71BF323A9A
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 20:35:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730402AbhANUf1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jan 2021 15:35:27 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8792 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726049AbhANUfM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Jan 2021 15:35:12 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10EK3I3x055568;
        Thu, 14 Jan 2021 15:31:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=s7uIzYnvjJVpUj7SPxdNdB2CeheK+3/3guDKAgZ1/JU=;
 b=iyq/aw891Uxv59iJkQ0vcBCwqk82Gye5EQlFR6RKuKymwuasXHK1dCs//CPfNIgR+VoU
 u3vfT2FbbBWMdx74fQQf+NRVblQws6Ls1ijDi/8/i53OcMnD09AqynH6pbmXh+aLtfqW
 wBUjTbkV1YZDkWdjRp0z1u1Bt80wvoKYuEib6xVyxNh9NUJJ4g4s+8WrDRljvAs0xH9T
 XPpGQeqVADgLqf65WKsPATpjuX+yT6T5F8CmCFVDdN8vz9say7BfTsp7x+QDGemeUGcs
 Yyd2DJr5jW31NFe40ckTIeMjyZO04Orq/8BDZQdZHBqpwtE65KlVs7KtT21WkvtbCP+n fg== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 362vca94cb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 15:31:54 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10EKSHEG007288;
        Thu, 14 Jan 2021 20:31:53 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma05wdc.us.ibm.com with ESMTP id 362cwmdsqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 20:31:53 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10EKVqk927394382
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jan 2021 20:31:52 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 009836E053;
        Thu, 14 Jan 2021 20:31:52 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A27DC6E052;
        Thu, 14 Jan 2021 20:31:51 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 14 Jan 2021 20:31:51 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH v5 04/21] ibmvfc: add size parameter to ibmvfc_init_event_pool
Date:   Thu, 14 Jan 2021 14:31:31 -0600
Message-Id: <20210114203148.246656-5-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210114203148.246656-1-tyreld@linux.ibm.com>
References: <20210114203148.246656-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-14_07:2021-01-14,2021-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 malwarescore=0 priorityscore=1501
 impostorscore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101140115
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

With the upcoming addition of Sub-CRQs the event pool size may vary
per-queue.

Add a size parameter to ibmvfc_init_event_pool such that different size
event pools can be requested by ibmvfc_alloc_queue.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 9330f5a65a7e..524e81164d70 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -723,19 +723,23 @@ static int ibmvfc_send_crq_init_complete(struct ibmvfc_host *vhost)
  * Returns zero on success.
  **/
 static int ibmvfc_init_event_pool(struct ibmvfc_host *vhost,
-				  struct ibmvfc_queue *queue)
+				  struct ibmvfc_queue *queue,
+				  unsigned int size)
 {
 	int i;
 	struct ibmvfc_event_pool *pool = &queue->evt_pool;
 
 	ENTER;
-	pool->size = max_requests + IBMVFC_NUM_INTERNAL_REQ;
-	pool->events = kcalloc(pool->size, sizeof(*pool->events), GFP_KERNEL);
+	if (!size)
+		return 0;
+
+	pool->size = size;
+	pool->events = kcalloc(size, sizeof(*pool->events), GFP_KERNEL);
 	if (!pool->events)
 		return -ENOMEM;
 
 	pool->iu_storage = dma_alloc_coherent(vhost->dev,
-					      pool->size * sizeof(*pool->iu_storage),
+					      size * sizeof(*pool->iu_storage),
 					      &pool->iu_token, 0);
 
 	if (!pool->iu_storage) {
@@ -747,7 +751,7 @@ static int ibmvfc_init_event_pool(struct ibmvfc_host *vhost,
 	INIT_LIST_HEAD(&queue->free);
 	spin_lock_init(&queue->l_lock);
 
-	for (i = 0; i < pool->size; ++i) {
+	for (i = 0; i < size; ++i) {
 		struct ibmvfc_event *evt = &pool->events[i];
 
 		atomic_set(&evt->free, 1);
@@ -5013,6 +5017,7 @@ static int ibmvfc_alloc_queue(struct ibmvfc_host *vhost,
 {
 	struct device *dev = vhost->dev;
 	size_t fmt_size;
+	unsigned int pool_size = 0;
 
 	ENTER;
 	spin_lock_init(&queue->_lock);
@@ -5021,10 +5026,7 @@ static int ibmvfc_alloc_queue(struct ibmvfc_host *vhost,
 	switch (fmt) {
 	case IBMVFC_CRQ_FMT:
 		fmt_size = sizeof(*queue->msgs.crq);
-		if (ibmvfc_init_event_pool(vhost, queue)) {
-			dev_err(dev, "Couldn't initialize event pool.\n");
-			return -ENOMEM;
-		}
+		pool_size = max_requests + IBMVFC_NUM_INTERNAL_REQ;
 		break;
 	case IBMVFC_ASYNC_FMT:
 		fmt_size = sizeof(*queue->msgs.async);
@@ -5034,6 +5036,11 @@ static int ibmvfc_alloc_queue(struct ibmvfc_host *vhost,
 		return -EINVAL;
 	}
 
+	if (ibmvfc_init_event_pool(vhost, queue, pool_size)) {
+		dev_err(dev, "Couldn't initialize event pool.\n");
+		return -ENOMEM;
+	}
+
 	queue->msgs.handle = (void *)get_zeroed_page(GFP_KERNEL);
 	if (!queue->msgs.handle)
 		return -ENOMEM;
-- 
2.27.0

