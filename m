Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58102C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 19:09:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29E9A64DE3
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 19:09:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbhBKTBT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 14:01:19 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6218 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231668AbhBKS6g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Feb 2021 13:58:36 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11BIpv3m032856;
        Thu, 11 Feb 2021 13:57:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=zEJ85hd4axtH9+FAVb7hRv7fh4iDT27yMYsW3T6Owx0=;
 b=VgpDL8/QclXCkFSXYyUdfhX3SCyjJ2VRwgem93KKFfkVVolJxQdTtIRrAqomTiGygoxc
 UQSdfGSHAiskN7siT+DbI2/t0ISFg4D3KW5sdi6ZMeIKrJCFwCijrNi5EHvLs5cxP5YK
 +SEtSs897z8aPbahutOS7L8BvFaTg3TRJwusd2l3Lyco7W0DKdlqW1tl/LHAGzwbncyQ
 hDibmxMrucOP5jOz/lbziBSZs1nBqXNR/AhY9AI8ZU2AhiuROrhGVFnVT61lovtB8WNf
 OOqnA35UlFxkrAu0QoMl4brNzHTwsYPRG5uOKn2uTmF4XIcXnChG/GKe+2JeQ0Bj/jvw ng== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36na8204kg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 13:57:48 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11BImKnN027027;
        Thu, 11 Feb 2021 18:57:47 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma02dal.us.ibm.com with ESMTP id 36hjrahqy7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 18:57:47 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11BIvj6G26411392
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 18:57:45 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE4EE136051;
        Thu, 11 Feb 2021 18:57:45 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 81BD4136053;
        Thu, 11 Feb 2021 18:57:45 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 11 Feb 2021 18:57:45 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 2/4] ibmvfc: fix invalid sub-CRQ handles after hard reset
Date:   Thu, 11 Feb 2021 12:57:40 -0600
Message-Id: <20210211185742.50143-3-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210211185742.50143-1-tyreld@linux.ibm.com>
References: <20210211185742.50143-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_07:2021-02-11,2021-02-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 bulkscore=0 spamscore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 malwarescore=0 adultscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102110148
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A hard reset results in a complete transport disconnect such that the
CRQ connection with the partner VIOS is broken. This has the side effect
of also invalidating the associated sub-CRQs. The current code assumes
that the sub-CRQs are perserved resulting in a protocol violation after
trying to reconnect them with the VIOS. This introduces an infinite loop
such that the VIOS forces a disconnect after each subsequent attempt to
re-register with invalid handles.

Avoid the aforementioned issue by releasing the sub-CRQs prior to CRQ
disconnect, and driving a reinitialization of the sub-CRQs once a new
CRQ is registered with the hypervisor.

fixes: faacf8c5f1d5 ("ibmvfc: add alloc/dealloc routines for SCSI Sub-CRQ Channels")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 384960036f8b..3dd20f383453 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -158,6 +158,9 @@ static void ibmvfc_npiv_logout(struct ibmvfc_host *);
 static void ibmvfc_tgt_implicit_logout_and_del(struct ibmvfc_target *);
 static void ibmvfc_tgt_move_login(struct ibmvfc_target *);
 
+static void ibmvfc_release_sub_crqs(struct ibmvfc_host *);
+static void ibmvfc_init_sub_crqs(struct ibmvfc_host *);
+
 static const char *unknown_error = "unknown error";
 
 static long h_reg_sub_crq(unsigned long unit_address, unsigned long ioba,
@@ -926,8 +929,8 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
 	unsigned long flags;
 	struct vio_dev *vdev = to_vio_dev(vhost->dev);
 	struct ibmvfc_queue *crq = &vhost->crq;
-	struct ibmvfc_queue *scrq;
-	int i;
+
+	ibmvfc_release_sub_crqs(vhost);
 
 	/* Close the CRQ */
 	do {
@@ -947,16 +950,6 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
 	memset(crq->msgs.crq, 0, PAGE_SIZE);
 	crq->cur = 0;
 
-	if (vhost->scsi_scrqs.scrqs) {
-		for (i = 0; i < nr_scsi_hw_queues; i++) {
-			scrq = &vhost->scsi_scrqs.scrqs[i];
-			spin_lock(scrq->q_lock);
-			memset(scrq->msgs.scrq, 0, PAGE_SIZE);
-			scrq->cur = 0;
-			spin_unlock(scrq->q_lock);
-		}
-	}
-
 	/* And re-open it again */
 	rc = plpar_hcall_norets(H_REG_CRQ, vdev->unit_address,
 				crq->msg_token, PAGE_SIZE);
@@ -966,6 +959,9 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
 		dev_warn(vhost->dev, "Partner adapter not ready\n");
 	else if (rc != 0)
 		dev_warn(vhost->dev, "Couldn't register crq (rc=%d)\n", rc);
+
+	ibmvfc_init_sub_crqs(vhost);
+
 	spin_unlock(vhost->crq.q_lock);
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
 
@@ -5692,6 +5688,7 @@ static void ibmvfc_deregister_scsi_channel(struct ibmvfc_host *vhost, int index)
 
 	free_irq(scrq->irq, scrq);
 	irq_dispose_mapping(scrq->irq);
+	scrq->irq = 0;
 
 	do {
 		rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address,
-- 
2.27.0

