Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12952C43381
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 20:34:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE65323A6C
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 20:34:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbhANUdk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jan 2021 15:33:40 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18626 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726007AbhANUcn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Jan 2021 15:32:43 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10EKKntT186081;
        Thu, 14 Jan 2021 15:31:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=KiW4KtoxoUb3zWD6erav8E6aKJ0GSkiplUjOZMLfJNM=;
 b=N8C96SLdakxFMh+jnGZwVWB05AB38GmJGuA5gZYb613Vj13p7Iy3WQSEralRuuzwL0mO
 SzrNZnu4Vk7d+D4O/K4url4WeTYoRXtdO2ZWKSgmiEJAHixlHL/cdSsywFGDao5I17vr
 IP9VXyDQkwFqqiimRM9GaTtXtrCZUjek5K7n/K/yf//8uD7ZPuteBf8DhYO19T4cIPqD
 s9TH0hNvZkUfYfOUd+sRxLv8MIEx0T9jZYkmC/SZmVWjfxjehFrtPJsJy4Ule5VWdjSJ
 yJ+3HJHXTlG+ksi81FVGn5HHLRC4RojC8tKSOp93HHJUWKzuR2gAft8ElcNkkDyqYM1H Qg== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 362vwr07ba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 15:31:56 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10EKHRYC004746;
        Thu, 14 Jan 2021 20:31:52 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02wdc.us.ibm.com with ESMTP id 35y449fry0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 20:31:52 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10EKVpUn27066826
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jan 2021 20:31:51 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 932D66E04E;
        Thu, 14 Jan 2021 20:31:51 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40AF06E056;
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
Subject: [PATCH v5 03/21] ibmvfc: init/free event pool during queue allocation/free
Date:   Thu, 14 Jan 2021 14:31:30 -0600
Message-Id: <20210114203148.246656-4-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210114203148.246656-1-tyreld@linux.ibm.com>
References: <20210114203148.246656-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-14_07:2021-01-14,2021-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 mlxscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 malwarescore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101140115
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The event pool and CRQ used to be separate entities of the adapter host
structure and as such were allocated and freed independently of each
other. Recent work as defined a generic queue structure with an event
pool specific to each queue. As such the event pool for each queue
shouldn't be allocated/freed independently, but instead performed as
part of the queue allocation/free routines.

Move the calls to ibmvfc_event_pool_{init|free} into
ibmvfc_{alloc|free}_queue respectively. The only functional change here
is that the CRQ cannot be released in ibmvfc_remove until after the
event pool has been successfully purged since releasing the queue will
also free the event pool.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index cd9273a5fadb..9330f5a65a7e 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -807,6 +807,8 @@ static void ibmvfc_free_queue(struct ibmvfc_host *vhost,
 	dma_unmap_single(dev, queue->msg_token, PAGE_SIZE, DMA_BIDIRECTIONAL);
 	free_page((unsigned long)queue->msgs.handle);
 	queue->msgs.handle = NULL;
+
+	ibmvfc_free_event_pool(vhost, queue);
 }
 
 /**
@@ -5019,6 +5021,10 @@ static int ibmvfc_alloc_queue(struct ibmvfc_host *vhost,
 	switch (fmt) {
 	case IBMVFC_CRQ_FMT:
 		fmt_size = sizeof(*queue->msgs.crq);
+		if (ibmvfc_init_event_pool(vhost, queue)) {
+			dev_err(dev, "Couldn't initialize event pool.\n");
+			return -ENOMEM;
+		}
 		break;
 	case IBMVFC_ASYNC_FMT:
 		fmt_size = sizeof(*queue->msgs.async);
@@ -5333,13 +5339,8 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 		goto kill_kthread;
 	}
 
-	if ((rc = ibmvfc_init_event_pool(vhost, &vhost->crq))) {
-		dev_err(dev, "Couldn't initialize event pool. rc=%d\n", rc);
-		goto release_crq;
-	}
-
 	if ((rc = scsi_add_host(shost, dev)))
-		goto release_event_pool;
+		goto release_crq;
 
 	fc_host_dev_loss_tmo(shost) = IBMVFC_DEV_LOSS_TMO;
 
@@ -5362,8 +5363,6 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 
 remove_shost:
 	scsi_remove_host(shost);
-release_event_pool:
-	ibmvfc_free_event_pool(vhost, &vhost->crq);
 release_crq:
 	ibmvfc_release_crq_queue(vhost);
 kill_kthread:
@@ -5398,7 +5397,6 @@ static int ibmvfc_remove(struct vio_dev *vdev)
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
 
 	ibmvfc_wait_while_resetting(vhost);
-	ibmvfc_release_crq_queue(vhost);
 	kthread_stop(vhost->work_thread);
 	fc_remove_host(vhost->host);
 	scsi_remove_host(vhost->host);
@@ -5408,7 +5406,7 @@ static int ibmvfc_remove(struct vio_dev *vdev)
 	list_splice_init(&vhost->purge, &purge);
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
 	ibmvfc_complete_purge(&purge);
-	ibmvfc_free_event_pool(vhost, &vhost->crq);
+	ibmvfc_release_crq_queue(vhost);
 
 	ibmvfc_free_mem(vhost);
 	spin_lock(&ibmvfc_driver_lock);
-- 
2.27.0

