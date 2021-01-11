Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2AF4C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 00:31:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FBC722D08
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 00:31:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391762AbhALAZq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 19:25:46 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36022 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2403869AbhAKXNV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Jan 2021 18:13:21 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10BN1QpE093616;
        Mon, 11 Jan 2021 18:12:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=0HO1nQX0OZEtB+IaScUuAUpOS+cC9/9gLWrf8WnhoXY=;
 b=eYlC6ZFTW3ltO+mAvE+GtxKHw8AAZm8EPHl0mGmdgSrYK32HeDlVB4osOtavtn0dpUxe
 3bduO/f7+WplAp4ITRXm7QeLcQ+Zzl1OE2Ydunqeg0F7M04xhlUhhztNp5cYxqpbYNon
 gThW8I2duvTAlNC4sPZXrd9HyDSxQI9/WLYFDSBVcGPZf//lPvgxXWF9ybX0itcQcXdw
 XqTGNklmPLjz6uxuCegARAEUcJqqBU990p58zrxkd7gVTsWYv7L00LcOG7YjXRsDdRWq
 WUvxNT7MtMpYXCI3ixg6SHbajeoN5mD1HE1R2f0TbcQ/uPvWjWc2Xa/JsVV2GhWNrnGQ LA== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 360wgfmehh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 18:12:34 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10BN805p008151;
        Mon, 11 Jan 2021 23:12:34 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma03dal.us.ibm.com with ESMTP id 35y448xcp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 23:12:34 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10BNCW8L6422890
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Jan 2021 23:12:32 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A7BD78067;
        Mon, 11 Jan 2021 23:12:32 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C6FC778064;
        Mon, 11 Jan 2021 23:12:31 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 11 Jan 2021 23:12:31 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v4 09/21] ibmvfc: add handlers to drain and complete Sub-CRQ responses
Date:   Mon, 11 Jan 2021 17:12:13 -0600
Message-Id: <20210111231225.105347-10-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210111231225.105347-1-tyreld@linux.ibm.com>
References: <20210111231225.105347-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_32:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 impostorscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0 mlxscore=0
 priorityscore=1501 mlxlogscore=999 spamscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101110126
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The logic for iterating over the Sub-CRQ responses is similiar to that
of the primary CRQ. Add the necessary handlers for processing those
responses.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 86 ++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 5d7ada0ed0d6..f3cd092478ee 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -3485,6 +3485,92 @@ static int ibmvfc_toggle_scrq_irq(struct ibmvfc_queue *scrq, int enable)
 	return rc;
 }
 
+static void ibmvfc_handle_scrq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost,
+			       struct list_head *evt_doneq)
+{
+	struct ibmvfc_event *evt = (struct ibmvfc_event *)be64_to_cpu(crq->ioba);
+
+	switch (crq->valid) {
+	case IBMVFC_CRQ_CMD_RSP:
+		break;
+	case IBMVFC_CRQ_XPORT_EVENT:
+		return;
+	default:
+		dev_err(vhost->dev, "Got and invalid message type 0x%02x\n", crq->valid);
+		return;
+	}
+
+	/* The only kind of payload CRQs we should get are responses to
+	 * things we send. Make sure this response is to something we
+	 * actually sent
+	 */
+	if (unlikely(!ibmvfc_valid_event(&evt->queue->evt_pool, evt))) {
+		dev_err(vhost->dev, "Returned correlation_token 0x%08llx is invalid!\n",
+			crq->ioba);
+		return;
+	}
+
+	if (unlikely(atomic_read(&evt->free))) {
+		dev_err(vhost->dev, "Received duplicate correlation_token 0x%08llx!\n",
+			crq->ioba);
+		return;
+	}
+
+	spin_lock(&evt->queue->l_lock);
+	list_move_tail(&evt->queue_list, evt_doneq);
+	spin_unlock(&evt->queue->l_lock);
+}
+
+static struct ibmvfc_crq *ibmvfc_next_scrq(struct ibmvfc_queue *scrq)
+{
+	struct ibmvfc_crq *crq;
+
+	crq = &scrq->msgs.scrq[scrq->cur].crq;
+	if (crq->valid & 0x80) {
+		if (++scrq->cur == scrq->size)
+			scrq->cur = 0;
+		rmb();
+	} else
+		crq = NULL;
+
+	return crq;
+}
+
+static void ibmvfc_drain_sub_crq(struct ibmvfc_queue *scrq)
+{
+	struct ibmvfc_crq *crq;
+	struct ibmvfc_event *evt, *temp;
+	unsigned long flags;
+	int done = 0;
+	LIST_HEAD(evt_doneq);
+
+	spin_lock_irqsave(scrq->q_lock, flags);
+	while (!done) {
+		while ((crq = ibmvfc_next_scrq(scrq)) != NULL) {
+			ibmvfc_handle_scrq(crq, scrq->vhost, &evt_doneq);
+			crq->valid = 0;
+			wmb();
+		}
+
+		ibmvfc_toggle_scrq_irq(scrq, 1);
+		if ((crq = ibmvfc_next_scrq(scrq)) != NULL) {
+			ibmvfc_toggle_scrq_irq(scrq, 0);
+			ibmvfc_handle_scrq(crq, scrq->vhost, &evt_doneq);
+			crq->valid = 0;
+			wmb();
+		} else
+			done = 1;
+	}
+	spin_unlock_irqrestore(scrq->q_lock, flags);
+
+	list_for_each_entry_safe(evt, temp, &evt_doneq, queue_list) {
+		del_timer(&evt->timer);
+		list_del(&evt->queue_list);
+		ibmvfc_trc_end(evt);
+		evt->done(evt);
+	}
+}
+
 /**
  * ibmvfc_init_tgt - Set the next init job step for the target
  * @tgt:		ibmvfc target struct
-- 
2.27.0

