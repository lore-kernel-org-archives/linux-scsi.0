Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B499C64E7B
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 01:49:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19FBB2075A
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 01:49:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="I+RzWBT6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732016AbgKZBsl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Nov 2020 20:48:41 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35424 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730060AbgKZBsl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Nov 2020 20:48:41 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AQ1WDTY120989;
        Wed, 25 Nov 2020 20:48:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=uEEA5OqlqcC9libALci4L3JPW4+Bvd1QfmrjaqCsxJk=;
 b=I+RzWBT6Yf3ZY8HONo16v5vj8T1qFX8UoGVx3abB1uqLdvM/TJ3AS3u3pDqTFMAgojij
 YVLrE8ycZ9jXt3Mh5mdzILnw14+Y4ujVdHxcSj2dEmYSF1/LLc748UpheDadpYj+s103
 HwZEokZ9rxDFNBxS2dZhGNHp+3tjkx5LaRS2nSX7vLRXMbRtrdr5vFzb6NAUWB/auVNR
 xDI0b+UY0YEs6f2U9D8GZI6g9L6+tLQurui3ujtDBIb3sbSgONdcp/fzzIfuqpKByKtM
 pEl7yu153Ukr6SP3ugHrMWKHYVAzZkJh0WIwVC3rdcY9LF45EyFVYHpn3HF4YBpVSmbj qw== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3522mr8cxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Nov 2020 20:48:35 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AQ1leEj008446;
        Thu, 26 Nov 2020 01:48:34 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01dal.us.ibm.com with ESMTP id 34xth9n0tm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 01:48:34 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AQ1mQlc38535506
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Nov 2020 01:48:26 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64E516E050;
        Thu, 26 Nov 2020 01:48:32 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 144416E04E;
        Thu, 26 Nov 2020 01:48:32 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 26 Nov 2020 01:48:32 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 07/13] ibmvfc: define Sub-CRQ interrupt handler routine
Date:   Wed, 25 Nov 2020 19:48:18 -0600
Message-Id: <20201126014824.123831-8-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201126014824.123831-1-tyreld@linux.ibm.com>
References: <20201126014824.123831-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-25_14:2020-11-25,2020-11-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 priorityscore=1501 mlxlogscore=869 clxscore=1015 phishscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=1 mlxscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011260001
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Simple handler that calls Sub-CRQ drain routine directly.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index a8730522920e..4fb782fa2c66 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -3443,6 +3443,20 @@ static void ibmvfc_drain_sub_crq(struct ibmvfc_sub_queue *scrq)
 	}
 }
 
+static irqreturn_t ibmvfc_interrupt_scsi(int irq, void *scrq_instance)
+{
+	struct ibmvfc_sub_queue *scrq = (struct ibmvfc_sub_queue *)scrq_instance;
+	struct ibmvfc_host *vhost = scrq->vhost;
+	unsigned long flags;
+
+	spin_lock_irqsave(vhost->host->host_lock, flags);
+	ibmvfc_toggle_scrq_irq(scrq, 0);
+	ibmvfc_drain_sub_crq(scrq);
+	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+
+	return IRQ_HANDLED;
+}
+
 /**
  * ibmvfc_init_tgt - Set the next init job step for the target
  * @tgt:		ibmvfc target struct
-- 
2.27.0

