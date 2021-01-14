Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59129C4332D
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 20:34:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CD5323A7C
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 20:34:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729084AbhANUdp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jan 2021 15:33:45 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49384 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727300AbhANUcm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Jan 2021 15:32:42 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10EK2sfj051410;
        Thu, 14 Jan 2021 15:31:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=C19kqcusT6BaZ+vFfyqwz/QhfC+/ifYdrrhKkXGhhfE=;
 b=LPIMhqy5fh9oKtV9SLjplYmVZqRghbl2xAg2VzlfevyTGcB33IvrPeieYlCBOw/gz+st
 BfgEpofgApTTMLh8I85vEhkHBhYBiJ5yzK57+KfARiTvrIaRD+wwV09y0lIp3/2oehDe
 bvQw59a/FQ3bjfX4jdXokAtcSKsqmPc11IF+vckacyVBCM/anSitrNTjTaJor71xUYG8
 V8lUmcvwZjqaE+e1Db8Zt8o1OtF7fbwqU0kmUjnRqPxJ7Hwmzs4pwAOiwsi7/ZxXE2vM
 qIumGg56r5fJCJLso6Kv120+dKjuNND8zk8CBYVI3eSC+mWz1+dOFTfvF8mEE8g8Agx5 ZQ== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 362v29sggg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 15:31:57 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10EKSMXd007313;
        Thu, 14 Jan 2021 20:31:56 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma05wdc.us.ibm.com with ESMTP id 362cwmdsqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 20:31:56 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10EKVsII20447722
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jan 2021 20:31:55 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E0FE56E04E;
        Thu, 14 Jan 2021 20:31:54 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E93D6E058;
        Thu, 14 Jan 2021 20:31:54 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 14 Jan 2021 20:31:54 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH v5 11/21] ibmvfc: map/request irq and register Sub-CRQ interrupt handler
Date:   Thu, 14 Jan 2021 14:31:38 -0600
Message-Id: <20210114203148.246656-12-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210114203148.246656-1-tyreld@linux.ibm.com>
References: <20210114203148.246656-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-14_07:2021-01-14,2021-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 priorityscore=1501 mlxlogscore=999 malwarescore=0 impostorscore=0
 spamscore=0 clxscore=1015 bulkscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101140115
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Create an irq mapping for the hw_irq number provided from phyp firmware.
Request an irq assigned our Sub-CRQ interrupt handler. Unmap these irqs
at Sub-CRQ teardown.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 51bcafad9490..d3d7c6b53d4f 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -5292,12 +5292,34 @@ static int ibmvfc_register_scsi_channel(struct ibmvfc_host *vhost,
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
 	ibmvfc_free_queue(vhost, scrq);
 	LEAVE;
@@ -5313,6 +5335,9 @@ static void ibmvfc_deregister_scsi_channel(struct ibmvfc_host *vhost, int index)
 
 	ENTER;
 
+	free_irq(scrq->irq, scrq);
+	irq_dispose_mapping(scrq->irq);
+
 	do {
 		rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address,
 					scrq->cookie);
-- 
2.27.0

