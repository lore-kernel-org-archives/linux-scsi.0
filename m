Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7439BC83024
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 02:09:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EFC821D91
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 02:09:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbgLCCJE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 21:09:04 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63250 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729461AbgLCCJD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 21:09:03 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B321kdW044458;
        Wed, 2 Dec 2020 21:08:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=9R+EPmfXOYd059WiPsY59u7q+OrEXF3u9tkNl3psk2o=;
 b=PbqTstXlEL0uHoWdKroR5Gp+6VZQZ9kAxATCydPNsJm4UdfVx6hN++ehYfR1tGrC8hXt
 wIdsjewe2Eunilz1MKz0lju9wqFzx+UU3SEdV9fPrp0S044UnIyvg1RLB3FcRGDJkixV
 TSdUEI+2UapcFuX0G3MG56PoWZW1MkE1iw53MrDcyb8miCuhpK7YNESWa9bglrNzVBew
 B959JN77pbZuVKM87bGF7m98xMJd0jA/AOxjCDddsPG5f+G26IUOL1LX8fgdUqUPw3jy
 BUCgTFp7aSM5zmC5xJhkjekHLFBw82NaXb4qn01V0x4RsdGhvJi0Acou4QstKMeLUXJG CQ== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 356jdx73nd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Dec 2020 21:08:16 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B31uOU2013344;
        Thu, 3 Dec 2020 02:08:16 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma01wdc.us.ibm.com with ESMTP id 355vrfvc80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Dec 2020 02:08:16 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B3285Ru18350810
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Dec 2020 02:08:05 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D1E7B7805F;
        Thu,  3 Dec 2020 02:08:14 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45AB07805C;
        Thu,  3 Dec 2020 02:08:14 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  3 Dec 2020 02:08:14 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH v3 08/18] ibmvfc: map/request irq and register Sub-CRQ interrupt handler
Date:   Wed,  2 Dec 2020 20:07:56 -0600
Message-Id: <20201203020806.14747-9-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201203020806.14747-1-tyreld@linux.ibm.com>
References: <20201203020806.14747-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_14:2020-11-30,2020-12-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 clxscore=1015 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=3
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030006
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Create an irq mapping for the hw_irq number provided from phyp firmware.
Request an irq assigned our Sub-CRQ interrupt handler.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 649268996a5c..6b299df786fc 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -5134,12 +5134,34 @@ static int ibmvfc_register_scsi_channel(struct ibmvfc_host *vhost,
 		goto reg_failed;
 	}
 
+	scrq->irq = irq_create_mapping(NULL, scrq->hw_irq);
+
+	if (!scrq->irq) {
+		rc = -EINVAL;
+		dev_err(dev, "Error mapping sub-crq[%d] irq\n", index);
+		goto irq_failed;
+	}
+
+	snprintf(scrq->name, sizeof(scrq->name), "ibmvfc-%x-scsi%d",
+		 vdev->unit_address, index);
+	rc = request_irq(scrq->irq, ibmvfc_interrupt_scsi, 0, scrq->name, scrq);
+
+	if (rc) {
+		dev_err(dev, "Couldn't register sub-crq[%d] irq\n", index);
+		irq_dispose_mapping(scrq->irq);
+		goto irq_failed;
+	}
+
 	scrq->hwq_id = index;
 	scrq->vhost = vhost;
 
 	LEAVE;
 	return 0;
 
+irq_failed:
+	do {
+		plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq->cookie);
+	} while (rc == H_BUSY || H_IS_LONG_BUSY(rc));
 reg_failed:
 	dma_unmap_single(dev, scrq->msg_token, PAGE_SIZE, DMA_BIDIRECTIONAL);
 dma_map_failed:
-- 
2.27.0

