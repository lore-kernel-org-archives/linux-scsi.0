Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B038BE7D0B7
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Sep 2023 22:54:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbjIUWy6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Sep 2023 18:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbjIUWyv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2023 18:54:51 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C632F122
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2023 15:54:44 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38LMa6QA022563;
        Thu, 21 Sep 2023 22:54:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=w+9XtGoh9PhCJ7ZNPsjXX7/nx8kPxRvL4k/a/tt7tNU=;
 b=qDG22xseBeGN0oKRDKq+DB7Rif82XQTyGh8QoX+MmJoMdiSnFkHhQOhva72UjqLxnIw5
 78qcZrDTZ+znt0RIGD3+47K0bvnBVUzBufegvBU545ViJuyq1WEcvYvyZhPfQHntjz9N
 9zCuj8RFuyr3RNwUgU6zwLljA9P4l5mbwnZrWZJh6U7FzMsZezGMaSTQs53di72ucXHC
 gBOI3l9NiuuiQzUMYyncQQWYHKz+wDU2ldG95A4+VklxtcdbGKpLz7bPTIo4QzTjI4R2
 iLogWvvxrLqUWoPBdnx1Z38r6i0FfYCdzKtFogREgFsp3ln8YwAeHMG6Su8wPhhVXejg YQ== 
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3t8vuc3sky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Sep 2023 22:54:41 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 38LLwbBi022905;
        Thu, 21 Sep 2023 22:54:40 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3t8tspv74m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Sep 2023 22:54:40 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
        by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 38LMsdL34195048
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Sep 2023 22:54:39 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C96758051;
        Thu, 21 Sep 2023 22:54:39 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5104558060;
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
Subject: [PATCH v2 08/11] ibmvfc: make channel allocation generic
Date:   Thu, 21 Sep 2023 17:54:32 -0500
Message-Id: <20230921225435.3537728-9-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230921225435.3537728-1-tyreld@linux.ibm.com>
References: <20230921225435.3537728-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: T7YGyovzfxjZt3Ib04PUnXBiA4RKBJ-K
X-Proofpoint-GUID: T7YGyovzfxjZt3Ib04PUnXBiA4RKBJ-K
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-21_19,2023-09-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 phishscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2309210196
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

With the comming of NVMeoF support the driver will need to also allocate
channels for NVMe. Implement generic channel allocation wrappers that
can be used for both SCSI and NVMeoF protocol setup.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 127 +++++++++++++++++++--------------
 1 file changed, 75 insertions(+), 52 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 42b3ebe85faa..f6646d71633d 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -163,8 +163,8 @@ static void ibmvfc_npiv_logout(struct ibmvfc_host *);
 static void ibmvfc_tgt_implicit_logout_and_del(struct ibmvfc_target *);
 static void ibmvfc_tgt_move_login(struct ibmvfc_target *);
 
-static void ibmvfc_dereg_sub_crqs(struct ibmvfc_host *);
-static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *);
+static void ibmvfc_dereg_sub_crqs(struct ibmvfc_host *, struct ibmvfc_channels *);
+static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *, struct ibmvfc_channels *);
 
 static const char *unknown_error = "unknown error";
 
@@ -925,7 +925,7 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
 	struct vio_dev *vdev = to_vio_dev(vhost->dev);
 	unsigned long flags;
 
-	ibmvfc_dereg_sub_crqs(vhost);
+	ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
 
 	/* Re-enable the CRQ */
 	do {
@@ -944,7 +944,7 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
 	spin_unlock(vhost->crq.q_lock);
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
 
-	ibmvfc_reg_sub_crqs(vhost);
+	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
 
 	return rc;
 }
@@ -963,7 +963,7 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
 	struct vio_dev *vdev = to_vio_dev(vhost->dev);
 	struct ibmvfc_queue *crq = &vhost->crq;
 
-	ibmvfc_dereg_sub_crqs(vhost);
+	ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
 
 	/* Close the CRQ */
 	do {
@@ -996,7 +996,7 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
 	spin_unlock(vhost->crq.q_lock);
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
 
-	ibmvfc_reg_sub_crqs(vhost);
+	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
 
 	return rc;
 }
@@ -5906,12 +5906,13 @@ static int ibmvfc_init_crq(struct ibmvfc_host *vhost)
 	return retrc;
 }
 
-static int ibmvfc_register_scsi_channel(struct ibmvfc_host *vhost,
-				  int index)
+static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
+				   struct ibmvfc_channels *channels,
+				   int index)
 {
 	struct device *dev = vhost->dev;
 	struct vio_dev *vdev = to_vio_dev(dev);
-	struct ibmvfc_queue *scrq = &vhost->scsi_scrqs.scrqs[index];
+	struct ibmvfc_queue *scrq = &channels->scrqs[index];
 	int rc = -ENOMEM;
 
 	ENTER;
@@ -5959,11 +5960,13 @@ static int ibmvfc_register_scsi_channel(struct ibmvfc_host *vhost,
 	return rc;
 }
 
-static void ibmvfc_deregister_scsi_channel(struct ibmvfc_host *vhost, int index)
+static void ibmvfc_deregister_channel(struct ibmvfc_host *vhost,
+				      struct ibmvfc_channels *channels,
+				      int index)
 {
 	struct device *dev = vhost->dev;
 	struct vio_dev *vdev = to_vio_dev(dev);
-	struct ibmvfc_queue *scrq = &vhost->scsi_scrqs.scrqs[index];
+	struct ibmvfc_queue *scrq = &channels->scrqs[index];
 	long rc;
 
 	ENTER;
@@ -5987,18 +5990,19 @@ static void ibmvfc_deregister_scsi_channel(struct ibmvfc_host *vhost, int index)
 	LEAVE;
 }
 
-static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost)
+static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost,
+				struct ibmvfc_channels *channels)
 {
 	int i, j;
 
 	ENTER;
-	if (!vhost->mq_enabled || !vhost->scsi_scrqs.scrqs)
+	if (!vhost->mq_enabled || !channels->scrqs)
 		return;
 
-	for (i = 0; i < nr_scsi_hw_queues; i++) {
-		if (ibmvfc_register_scsi_channel(vhost, i)) {
+	for (i = 0; i < channels->max_queues; i++) {
+		if (ibmvfc_register_channel(vhost, channels, i)) {
 			for (j = i; j > 0; j--)
-				ibmvfc_deregister_scsi_channel(vhost, j - 1);
+				ibmvfc_deregister_channel(vhost, channels, j - 1);
 			vhost->do_enquiry = 0;
 			return;
 		}
@@ -6007,77 +6011,96 @@ static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost)
 	LEAVE;
 }
 
-static void ibmvfc_dereg_sub_crqs(struct ibmvfc_host *vhost)
+static void ibmvfc_dereg_sub_crqs(struct ibmvfc_host *vhost,
+				  struct ibmvfc_channels *channels)
 {
 	int i;
 
 	ENTER;
-	if (!vhost->mq_enabled || !vhost->scsi_scrqs.scrqs)
+	if (!vhost->mq_enabled || !channels->scrqs)
 		return;
 
-	for (i = 0; i < nr_scsi_hw_queues; i++)
-		ibmvfc_deregister_scsi_channel(vhost, i);
+	for (i = 0; i < channels->max_queues; i++)
+		ibmvfc_deregister_channel(vhost, channels, i);
 
 	LEAVE;
 }
 
-static void ibmvfc_init_sub_crqs(struct ibmvfc_host *vhost)
+static int ibmvfc_alloc_channels(struct ibmvfc_host *vhost,
+				 struct ibmvfc_channels *channels)
 {
 	struct ibmvfc_queue *scrq;
 	int i, j;
+	int rc = 0;
 
+	channels->scrqs = kcalloc(channels->max_queues,
+				  sizeof(*channels->scrqs),
+				  GFP_KERNEL);
+	if (!channels->scrqs)
+		return -ENOMEM;
+
+	for (i = 0; i < channels->max_queues; i++) {
+		scrq = &channels->scrqs[i];
+		rc = ibmvfc_alloc_queue(vhost, scrq, IBMVFC_SUB_CRQ_FMT);
+		if (rc) {
+			for (j = i; j > 0; j--) {
+				scrq = &channels->scrqs[j - 1];
+				ibmvfc_free_queue(vhost, scrq);
+			}
+			kfree(channels->scrqs);
+			channels->scrqs = NULL;
+			channels->active_queues = 0;
+			return rc;
+		}
+	}
+
+	return rc;
+}
+
+static void ibmvfc_init_sub_crqs(struct ibmvfc_host *vhost)
+{
 	ENTER;
 	if (!vhost->mq_enabled)
 		return;
 
-	vhost->scsi_scrqs.scrqs = kcalloc(nr_scsi_hw_queues,
-					  sizeof(*vhost->scsi_scrqs.scrqs),
-					  GFP_KERNEL);
-	if (!vhost->scsi_scrqs.scrqs) {
+	if (ibmvfc_alloc_channels(vhost, &vhost->scsi_scrqs)) {
 		vhost->do_enquiry = 0;
+		vhost->mq_enabled = 0;
 		return;
 	}
 
-	for (i = 0; i < nr_scsi_hw_queues; i++) {
-		scrq = &vhost->scsi_scrqs.scrqs[i];
-		if (ibmvfc_alloc_queue(vhost, scrq, IBMVFC_SUB_CRQ_FMT)) {
-			for (j = i; j > 0; j--) {
-				scrq = &vhost->scsi_scrqs.scrqs[j - 1];
-				ibmvfc_free_queue(vhost, scrq);
-			}
-			kfree(vhost->scsi_scrqs.scrqs);
-			vhost->scsi_scrqs.scrqs = NULL;
-			vhost->scsi_scrqs.active_queues = 0;
-			vhost->do_enquiry = 0;
-			vhost->mq_enabled = 0;
-			return;
-		}
-	}
-
-	ibmvfc_reg_sub_crqs(vhost);
+	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
 
 	LEAVE;
 }
 
-static void ibmvfc_release_sub_crqs(struct ibmvfc_host *vhost)
+static void ibmvfc_release_channels(struct ibmvfc_host *vhost,
+				    struct ibmvfc_channels *channels)
 {
 	struct ibmvfc_queue *scrq;
 	int i;
 
+	if (channels->scrqs) {
+		for (i = 0; i < channels->max_queues; i++) {
+			scrq = &channels->scrqs[i];
+			ibmvfc_free_queue(vhost, scrq);
+		}
+
+		kfree(channels->scrqs);
+		channels->scrqs = NULL;
+		channels->active_queues = 0;
+	}
+}
+
+static void ibmvfc_release_sub_crqs(struct ibmvfc_host *vhost)
+{
 	ENTER;
 	if (!vhost->scsi_scrqs.scrqs)
 		return;
 
-	ibmvfc_dereg_sub_crqs(vhost);
-
-	for (i = 0; i < nr_scsi_hw_queues; i++) {
-		scrq = &vhost->scsi_scrqs.scrqs[i];
-		ibmvfc_free_queue(vhost, scrq);
-	}
+	ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
 
-	kfree(vhost->scsi_scrqs.scrqs);
-	vhost->scsi_scrqs.scrqs = NULL;
-	vhost->scsi_scrqs.active_queues = 0;
+	ibmvfc_release_channels(vhost, &vhost->scsi_scrqs);
 	LEAVE;
 }
 
-- 
2.31.1

