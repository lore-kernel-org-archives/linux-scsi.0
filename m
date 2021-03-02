Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8CE8C4332B
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Mar 2021 13:06:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EF5A60234
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Mar 2021 13:06:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238745AbhCCMp4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 07:45:56 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51202 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1840151AbhCBXHu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2021 18:07:50 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 122N3UIb085385;
        Tue, 2 Mar 2021 18:07:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=irrRsLs0NTP5Zv+PpCeH6SbhEb+QnJYC27pGBpqTglM=;
 b=npohZ37I6EgMYM7Isyph0eWuxAUtC0uGEV/Ns6C77UTVixIeim96trmVqpxe+PBraQhO
 4/L4eyYYIymE8kL93n56iSV3k0tasBvqh+pmljD4jyJoZjrIdt2ptw195IMaTQKO3aV6
 /ei5Z63Lp6Q1LAMO1ZeJqhcy1Gc5PJz24bA77lzyK91+Y8Tbz2oUtI3laV/ocsgAS1jZ
 tyuo2lqQQBx9Ri98W5bx52yEfRQNq/08Lp/OkHl2LTMCxGDduARhoROuxQcj3PIlT/p4
 P+AMWNJm+McdzYYFP7iyiA55HyDF+2ol/evRSdgXoxLY2Z74UJCInDx8J1m9sW9iBEKb XQ== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 371xmwrg0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 18:07:03 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 122N27Wl016832;
        Tue, 2 Mar 2021 23:05:47 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03dal.us.ibm.com with ESMTP id 37103w6raj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 23:05:47 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 122N5kId25559388
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Mar 2021 23:05:46 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5E866E050;
        Tue,  2 Mar 2021 23:05:45 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8784F6E04E;
        Tue,  2 Mar 2021 23:05:45 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue,  2 Mar 2021 23:05:45 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v5 2/5] ibmvfc: fix invalid sub-CRQ handles after hard reset
Date:   Tue,  2 Mar 2021 17:05:40 -0600
Message-Id: <20210302230543.9905-3-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210302230543.9905-1-tyreld@linux.ibm.com>
References: <20210302230543.9905-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-02_08:2021-03-01,2021-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 adultscore=0 mlxscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103020170
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

fixes: 3034ebe26389 ("ibmvfc: add alloc/dealloc routines for SCSI Sub-CRQ Channels")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Reviewed-by: Brian King <brking@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 384960036f8b..d34e1a4f74d9 100644
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
@@ -966,9 +959,12 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
 		dev_warn(vhost->dev, "Partner adapter not ready\n");
 	else if (rc != 0)
 		dev_warn(vhost->dev, "Couldn't register crq (rc=%d)\n", rc);
+
 	spin_unlock(vhost->crq.q_lock);
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
 
+	ibmvfc_init_sub_crqs(vhost);
+
 	return rc;
 }
 
@@ -5692,6 +5688,7 @@ static void ibmvfc_deregister_scsi_channel(struct ibmvfc_host *vhost, int index)
 
 	free_irq(scrq->irq, scrq);
 	irq_dispose_mapping(scrq->irq);
+	scrq->irq = 0;
 
 	do {
 		rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address,
-- 
2.27.0

