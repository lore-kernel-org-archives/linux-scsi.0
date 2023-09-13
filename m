Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CB87EE0213
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Sep 2023 23:30:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbjIMXaz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Sep 2023 19:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233122AbjIMXax (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Sep 2023 19:30:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACDB8E3
        for <linux-scsi@vger.kernel.org>; Wed, 13 Sep 2023 16:30:49 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38DNJPp2029718;
        Wed, 13 Sep 2023 23:30:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=AF/qZLC4l62hVAW5W0ATTYfoPgerK9hCqqy0+Tp0Q9w=;
 b=XZ9s8g25Ekg/4bJDWdAG12w8YVAv4r761BWM7mat9UrAnc5c9RHrTYCFrvP/bp/5HSrW
 pFrTKuI3QYndHRaLSUcSnnsBWoHJlFAAEe+FBL2kBuRqepwd/H+9v+Smb4ydxymeWx7K
 c+nrMlKj3v8F/S/3EgO10OF0cxKwf9XbcVCv/uQY0o+5vfPH5bh1vNuqJ2Ire0022UcL
 VZoJ8Q254mxtVJff1DLKQChPLiqK/eRwMMyItEtkSsSvBeaNHXtGFZmDiPvTCumL0Rkh
 ZqIkocVQrgkmZeh+oeDRHE9WPFTNiV3syr0B29NlZZl2YV9F3oEz/8QoRzV0BFuLxkx2 sg== 
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3t3kfgcn20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Sep 2023 23:30:46 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 38DKgcXK022941;
        Wed, 13 Sep 2023 23:05:06 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3t141nxm0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Sep 2023 23:05:06 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
        by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 38DN547M27787550
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Sep 2023 23:05:05 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9BE9B58059;
        Wed, 13 Sep 2023 23:05:04 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 241D958053;
        Wed, 13 Sep 2023 23:05:04 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 13 Sep 2023 23:05:04 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, brking@linux.ibm.com,
        james.bottomley@hansenpartnership.com,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 08/11] ibmvfc: make channel allocation generic
Date:   Wed, 13 Sep 2023 18:04:54 -0500
Message-Id: <20230913230457.2575849-9-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230913230457.2575849-1-tyreld@linux.ibm.com>
References: <20230913230457.2575849-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1uKYZPm3jub1GtvW4IeHj7iDqX89w8q6
X-Proofpoint-ORIG-GUID: 1uKYZPm3jub1GtvW4IeHj7iDqX89w8q6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-13_17,2023-09-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 priorityscore=1501 clxscore=1011 mlxscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309130191
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
index 443223c16f39..8b2421fa2b2c 100644
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
 
@@ -926,7 +926,7 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
 	struct vio_dev *vdev = to_vio_dev(vhost->dev);
 	unsigned long flags;
 
-	ibmvfc_dereg_sub_crqs(vhost);
+	ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
 
 	/* Re-enable the CRQ */
 	do {
@@ -945,7 +945,7 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
 	spin_unlock(vhost->crq.q_lock);
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
 
-	ibmvfc_reg_sub_crqs(vhost);
+	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
 
 	return rc;
 }
@@ -964,7 +964,7 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
 	struct vio_dev *vdev = to_vio_dev(vhost->dev);
 	struct ibmvfc_queue *crq = &vhost->crq;
 
-	ibmvfc_dereg_sub_crqs(vhost);
+	ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
 
 	/* Close the CRQ */
 	do {
@@ -997,7 +997,7 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
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

