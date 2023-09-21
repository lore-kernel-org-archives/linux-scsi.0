Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88409E7D0B6
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Sep 2023 22:54:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbjIUWy5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Sep 2023 18:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbjIUWyv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2023 18:54:51 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A87E114
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2023 15:54:45 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38LMcZig028134;
        Thu, 21 Sep 2023 22:54:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=zvHY4n5nSD6YGemB0aMkZGueUTiIwLuBA5hP4j3U5eg=;
 b=Fm+wAG+nUSltvY30W9OeIctEfTUxbyfikXJjLYO7FUKBoOIMBDK/KoyThqL/zDRof48l
 AQ9XcRTQercjOBAO8hhlVsr3flu+w11bQEG98dDAlRNi4snekgzDy5U7VsR0cPmNZbZO
 INS9QfI6KO0IOvtR6YApjN/3Cr0hO57igE9jN7K4TAXMUgrZ7Q3fgCfGG6sYt391Nb9r
 4JRbac74NOmdq88j0VGL3cv1aVsyFZge7AoHbQGo0gELbz7lQ5EVjRemSG4VEPC3DTY6
 HTcJPXnX383J/A/Y1TihJWg+2iC3aLQjpo8k/sq953xUMERyg/PIqgiNcHjxD/w/niTJ 3A== 
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3t8tss6evb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Sep 2023 22:54:41 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 38LLtVXu015460;
        Thu, 21 Sep 2023 22:54:40 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3t8tsp479k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Sep 2023 22:54:40 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
        by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 38LMsdt4852540
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Sep 2023 22:54:40 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBCEC58051;
        Thu, 21 Sep 2023 22:54:39 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A76E75805C;
        Thu, 21 Sep 2023 22:54:39 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 21 Sep 2023 22:54:39 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, brking@linux.ibm.com,
        james.bottomley@hansenpartnership.com,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH v2 09/11] ibmvfc: add protocol field to ibmvfc_channels
Date:   Thu, 21 Sep 2023 17:54:33 -0500
Message-Id: <20230921225435.3537728-10-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230921225435.3537728-1-tyreld@linux.ibm.com>
References: <20230921225435.3537728-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2JeOttWQSure-HWEiGNo3WJkKix0jUyf
X-Proofpoint-ORIG-GUID: 2JeOttWQSure-HWEiGNo3WJkKix0jUyf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-21_19,2023-09-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 priorityscore=1501 mlxscore=0 phishscore=0 clxscore=1015 malwarescore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2309210196
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There are cases in the generic code where protocol specific
configuration or actions may need to be taken. Add a protocol field to
struct ibmvfc_channels and initial IBMVFC_PROTO_[SCSI/NVME] definitions.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 24 ++++++++++++++++++++----
 drivers/scsi/ibmvscsi/ibmvfc.h |  7 +++++++
 2 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index f6646d71633d..a1d547db7eef 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -3935,7 +3935,7 @@ static void ibmvfc_drain_sub_crq(struct ibmvfc_queue *scrq)
 	}
 }
 
-static irqreturn_t ibmvfc_interrupt_scsi(int irq, void *scrq_instance)
+static irqreturn_t ibmvfc_interrupt_mq(int irq, void *scrq_instance)
 {
 	struct ibmvfc_queue *scrq = (struct ibmvfc_queue *)scrq_instance;
 
@@ -5936,9 +5936,24 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
 		goto irq_failed;
 	}
 
-	snprintf(scrq->name, sizeof(scrq->name), "ibmvfc-%x-scsi%d",
-		 vdev->unit_address, index);
-	rc = request_irq(scrq->irq, ibmvfc_interrupt_scsi, 0, scrq->name, scrq);
+	switch (channels->protocol) {
+	case IBMVFC_PROTO_SCSI:
+		snprintf(scrq->name, sizeof(scrq->name), "ibmvfc-%x-scsi%d",
+			 vdev->unit_address, index);
+		scrq->handler = ibmvfc_interrupt_mq;
+		break;
+	case IBMVFC_PROTO_NVME:
+		snprintf(scrq->name, sizeof(scrq->name), "ibmvfc-%x-nvmf%d",
+			 vdev->unit_address, index);
+		scrq->handler = ibmvfc_interrupt_mq;
+		break;
+	default:
+		dev_err(dev, "Unknown channel protocol (%d)\n",
+			channels->protocol);
+		goto irq_failed;
+	}
+
+	rc = request_irq(scrq->irq, scrq->handler, 0, scrq->name, scrq);
 
 	if (rc) {
 		dev_err(dev, "Couldn't register sub-crq[%d] irq\n", index);
@@ -6317,6 +6332,7 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	vhost->mq_enabled = mq_enabled;
 	vhost->scsi_scrqs.desired_queues = min(shost->nr_hw_queues, nr_scsi_channels);
 	vhost->scsi_scrqs.max_queues = shost->nr_hw_queues;
+	vhost->scsi_scrqs.protocol = IBMVFC_PROTO_SCSI;
 	vhost->using_channels = 0;
 	vhost->do_enquiry = 1;
 	vhost->scan_timeout = 0;
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index 79e1a3bbb2f7..085dfc38446a 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -813,10 +813,17 @@ struct ibmvfc_queue {
 	unsigned long irq;
 	unsigned long hwq_id;
 	char name[32];
+	irq_handler_t handler;
+};
+
+enum ibmvfc_protocol {
+	IBMVFC_PROTO_SCSI = 0,
+	IBMVFC_PROTO_NVME = 1,
 };
 
 struct ibmvfc_channels {
 	struct ibmvfc_queue *scrqs;
+	enum ibmvfc_protocol protocol;
 	unsigned int active_queues;
 	unsigned int desired_queues;
 	unsigned int max_queues;
-- 
2.31.1

