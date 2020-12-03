Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E476C71155
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 02:10:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CD0B21D7A
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 02:10:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729669AbgLCCK1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 21:10:27 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18352 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727681AbgLCCK0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 21:10:26 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B322rE9113478;
        Wed, 2 Dec 2020 21:09:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ylRBnpuamzDBA63iOoDUHX6UnApFo/wltbO4CWNulm0=;
 b=rIobVNc/9RG7zHBDQVyDbihx20iLw6q9OCghIAVIYlJZ6Dk5LT8TOoZSlMS/JukXfHZd
 /Opm3Sn/hreOqY7B4yoaIJVvE6EI8iVkCnwclGXAVOjzZVPIvx+eT2urGJMm3bHCnzof
 7X7mCk6/RfcY95fOC4hBUiy2mmQFnulSOKobgXHyWINBoSuvsoyl4YQJb5/4HQ8L2rxc
 E5Wbb3+IEzsRdvmxaMginRMCM08BhE6DRZQkiFvCNd9b/kxvIH64YCEpI8qEEr2/puAN
 GCQhCQq+8EcJRLG8cxrXMekzwOx+tvBZIYlYKGkCyZsOQxxPi98cwe9Cae78lzxKmRvF 3A== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 356jdqf009-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Dec 2020 21:09:39 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B31uL48013325;
        Thu, 3 Dec 2020 02:09:38 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01wdc.us.ibm.com with ESMTP id 355vrfvcjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Dec 2020 02:09:38 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B328FOo32047844
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Dec 2020 02:08:15 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B038678060;
        Thu,  3 Dec 2020 02:08:21 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 275F078063;
        Thu,  3 Dec 2020 02:08:21 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  3 Dec 2020 02:08:21 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v3 18/18] ibmvfc: drop host lock when completing commands in CRQ
Date:   Wed,  2 Dec 2020 20:08:06 -0600
Message-Id: <20201203020806.14747-19-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201203020806.14747-1-tyreld@linux.ibm.com>
References: <20201203020806.14747-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_14:2020-11-30,2020-12-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=1 bulkscore=0
 mlxlogscore=999 spamscore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 malwarescore=0 mlxscore=0 impostorscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030009
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The legacy CRQ holds the host lock the even while completing commands.
This presents a problem when in legacy single queue mode and
nr_hw_queues is greater than one since calling scsi_done() introduces
the potential for deadlock.

If nr_hw_queues is greater than one drop the hostlock in the legacy CRQ
path when completing a command.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index e499599662ec..e2200bdff2be 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -2969,6 +2969,7 @@ static void ibmvfc_handle_crq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost)
 {
 	long rc;
 	struct ibmvfc_event *evt = (struct ibmvfc_event *)be64_to_cpu(crq->ioba);
+	unsigned long flags;
 
 	switch (crq->valid) {
 	case IBMVFC_CRQ_INIT_RSP:
@@ -3039,7 +3040,12 @@ static void ibmvfc_handle_crq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost)
 	del_timer(&evt->timer);
 	list_del(&evt->queue);
 	ibmvfc_trc_end(evt);
-	evt->done(evt);
+	if (nr_scsi_hw_queues > 1) {
+		spin_unlock_irqrestore(vhost->host->host_lock, flags);
+		evt->done(evt);
+		spin_lock_irqsave(vhost->host->host_lock, flags);
+	} else
+		evt->done(evt);
 }
 
 /**
-- 
2.27.0

